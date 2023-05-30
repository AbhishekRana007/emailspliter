public with sharing class contactHelper {
  
  // private static set<string> newDomains;
    
    public static  Map<String,id> domainExtractor(list<Contact>listFromTrigger){
    //captures domain name and id of existing accounts
        map<String,id> domainMap=new map<String,id>();
        
        //name of matched account unique
    set<string> allDomains=new set<string>();
        
        for(Contact AllContacts:listFromTrigger){
            if(AllContacts.Email!=null){
                
                string emails=AllContacts.Email.split('@').get(1);
               
                string domain=emails.split('\\.').get(0);
             // system.debug('this is email fetched'+domain);
               domainMap.put(domain,AllContacts.Id);
                 
               //all domain are extracted even which are not present in the organization
                allDomains.add(domain);
            }
        }
        
        list<Account> accountMatch=[SELECT Name,id, CreatedDate FROM Account where name in :allDomains  ORDER BY CreatedDate desc]; 
            system.debug('this is list:'+accountMatch); 

            //only those domain whose account are avialable
        for(Account accounts :accountMatch) {
            
            domainMap.put(accounts.Name,accounts.Id);
                  
        }

      //  system.debug('this is map:'+domainMap); 
         return domainMap;
    }

    
    public static contact contactDomianIncluder(map<string,id>domains,contact newContact){
        
        //email split of individual domain
        string emails=newContact.Email.split('@').get(1); 

        string domain=emails.split('\\.').get(0);
        
       // system.debug('this is map2:'+domains); 
       // system.debug('this is '+newContact);
     //system.debug('this is splitted '+domain);

      //system.debug('this is domain key'+domains.get(domain));
        
      //here if domain is present in org it will assign it to contact
        if(domains.get(domain)!=null){
          // system.debug('has entered here');
           newContact.AccountId=domains.get(domain); 

        }
        else{
            
           system.debug('unfound domians are : '+domain );
           // system.debug('unfound domians are as follows : '+newDomains );

           //returning contact whose domain does not match others
            return newContact;
            
        }
    
  //null return
        return newContact;

        //if(domains.containskey(newContact))
        
      /*  system.debug('inside helper now');
        contact ImportedContact=newContact;
        //All contact will come here one by one.k
        string emails=ImportedContact.Email.split('@').get(1);
         string domain=emails.split('\\.').get(0);
        //Domain has been shorted here.
        Account findAccount=[select name,id from account where name= :domain limit 1];
        //if account name matches domaim name in our org if will run.
        
        if(findAccount.size()!=0)
        {id newids=findAccount[0].id;
          ImportedContact.AccountId =newids;
        }
        else{
            system.debug('account insert '+domain);
            //new contact created from domain name
             Account addingAccount=new Account(name=domain);
       Database.SaveResult insertResults = Database.insert(addingAccount, false);
            //account linked to contact
       system.debug('end of task'+insertResults);
            ImportedContact.AccountId=addingAccount.id;
            system.debug('new account id is '+ addingAccount);
        }*/
               

    }
    
    public static void finalAccountadder(list<contact> finalContact){
      
        list<Account> newAccounts=new list<Account>();
        set<string> emailsplits=new set <string>();
        map<string,id> newMapAccount=new map<string,id>();
          
        //splitting all contacts email those accounts are not avilable
        for(contact ncc:finalContact){
            string emdomain=ncc.Email.split('@').get(1); 
            string emdom2=emdomain.split('\\.').get(0);
            emailsplits.add(emdom2);
        }
         //all domains account that need to insert
        for(string cc:emailsplits){
            newAccounts.add(new account(name=cc));
        }
        
        insert newAccounts;
        
        list<Account> insertedAccount=[select name ,id from account where name in :emailsplits ORDER BY CreatedDate desc];

        //mapping domain and account id
        for(account accs:insertedAccount){
            newMapAccount.put(accs.name,accs.id);
        }
        
        //connecting added account to contacts
        for(contact nccs:finalContact){
             string emdomain=nccs.Email.split('@').get(1); 
            string emdom2=emdomain.split('\\.').get(0);
            if(newMapAccount.get(emdom2)!=null){
                nccs.AccountId=newMapAccount.get(emdom2); 
            }
        }
        
        
    }

}