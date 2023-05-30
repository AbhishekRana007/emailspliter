@istest
public class EmailSplitterTestClass {

   @isTest
    public static void customSetting(){
        //This is to Activate custom Setting.
        TriggerConfig__c triggerConfig =new TriggerConfig__c();
        triggerConfig.Name='Contact';
        triggerConfig.IsActive__c=true;
        triggerConfig.ApexHandler__c='contactHandler';
        triggerConfig.SkipForUsers__c=null;
        
        
        insert triggerConfig;
        
        // TriggerConfig__c   setting = TriggerConfig__c.getValues('Contact');

        test.startTest();
        list<Contact> conList=new list<Contact>();
        for(integer i=0;i<205;i++){
           conList.add(new Contact(lastName='news'+i,email='ABCD@gmail'+i+'.com'));
        }
        insert conList;
        test.stopTest();
        list<Contact> incon=[select name,id fom Contact where name like 'news'];
        system.assertequals(205,incon.size());
    }
    
   @isTest
    public static void updateContact(){
        
         TriggerConfig__c triggerConfig =new TriggerConfig__c();
        triggerConfig.Name='Contact';
        triggerConfig.IsActive__c=true;
        triggerConfig.ApexHandler__c='contactHandler';
        triggerConfig.SkipForUsers__c=null;
        
        
        insert triggerConfig;
        
        list<Contact> conList=new list<Contact>();
        for(integer i=0;i<205;i++){
           conList.add(new Contact(lastName='news'+i,email='ABCD@gmail'+i+'.com'));
        }
        insert conList;
        
       test.startTest();
        list<contact> con= [Select name,id from contact where id in :conList ];
        for( contact coo:con){
        coo.lastName='updated Contact';
           }
         update con;
       test.stopTest();
       list<Contact> incon=[select name,id fom Contact where name = 'updated Contact'];
       system.assertequals(205,incon.size());

    }
    
    
   @isTest
    public static void deleteContact(){
        
         TriggerConfig__c triggerConfig =new TriggerConfig__c();
        triggerConfig.Name='Contact';
        triggerConfig.IsActive__c=true;
        triggerConfig.ApexHandler__c='contactHandler';
        triggerConfig.SkipForUsers__c=null;
        
        
        insert triggerConfig;
        
       list<Contact> conLists=new list<Contact>();
        for(integer i=0;i<200;i++){
           conLists.add(new Contact(lastName='newjs',email='ABCD@gmail'+i+'.com'));
        }
        insert conLists;
       
      
        list<contact> cons= [Select name,id from contact where name ='newjs'];
        system.assertequals(10,cons.size());
        test.startTest();
     List<Database.DeleteResult> deleteResultList = Database.delete(cons, false);
        test.stopTest();
     //  list<contact> conss= [Select name,id from contact where name like 'newjs%'];
       //  system.assertequals(0,conss.size());
        


    }
}