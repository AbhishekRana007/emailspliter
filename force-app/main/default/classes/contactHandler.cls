/**
 * Sample Trigger Handler for Account
 */
public class contactHandler implements ITrigger 
{  
    //all those contact whose account we didnt get
    list<contact>incomingContact=new list<contact>();

     //all domains are getted here which are present in organization 
    map<String,id> domainMap=new map<String,id>();

   // map<contact,string> newDomains=new map<contact,string>();
 
    public void bulkBefore(){
        domainMap=contactHelper.domainExtractor(trigger.new);
  		system.debug('--- bulkbEfore is called');      
    }
    
    public void bulkAfter(){
     
  		system.debug('--- bulkAfter is called');      
    }
    
    public void beforeInsert(sObject so){
       contact soo=(contact)so;

       contact newContacts=contactHelper.contactDomianIncluder(domainMap,soo);

        incomingContact.add(newContacts);
       //newDomains.put(incomingDomian);
        
  		system.debug('--- beforeInsert is called');      
    }
    public void beforeUpdate(SObject oldSo, SObject so){
  		system.debug('--- beforeUpdate is called');      
    }

    public void beforeDelete(SObject so){
  		system.debug('--- beforeDelete is called');      
    }

    public void afterInsert(SObject so){
  		system.debug('--- afterInsert is called');      
    }

    public void afterUpdate(SObject oldSo, SObject so){
  		system.debug('--- afterUpdate is called');      
    }

    public void afterDelete(SObject so){
  		system.debug('--- afterDelete is called');      
    }
  
    public void andFinally(){
        system.debug(incomingContact+'is in finally');
        contactHelper.finalAccountadder(incomingContact);
        system.debug('--- andFinally called');      
    }
}