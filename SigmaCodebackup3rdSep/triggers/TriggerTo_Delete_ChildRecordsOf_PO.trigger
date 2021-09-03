/*------------------------------------------------------------
    Author: Banu       
    Company: Mindlinks Solution
    Description: Trigger To Delete ChildRecords Of Purchase order when deleted.
       
    Apex Trigger : TriggerTo_Delete_ChildRecordsOf_PO
   
------------------------------------------------------------*/


trigger TriggerTo_Delete_ChildRecordsOf_PO on Purchase_Order__c (before delete, after insert) {
    
    //To store parent ids
    /*list<id> poIds=new list<id>();
    for(Purchase_Order__c poVar:trigger.old)
    {
        poIds.add(poVar.id);
    }  
    //Collecting all child records related to Parent records
    list<Purchase_Order_Product__c> listOfPops=[select id from Purchase_Order_Product__c where Purchase_Order__r.Id in :poIds];
    system.debug('listOfPops'+listOfPops);
    //deleting child records
    delete listOfPops;*/ //commented on 30/6/2020
    
    /*
    Commented by Raghavendra because it is another trigger on the same object
    Trigger Name: PO
        trigger PO on Purchase_Order__c (after insert) {
        List<Purchase_Order__c> PO= Trigger.New;
     
      
        system.debug('Purchase Order after for loop ::' + PO );
         TriggerHandler triggerHandler = new TriggerHandler();
          triggerHandler.managePOP(PO,Trigger.isInsert);
      
   

        }
    
    */
    
    //added newly on 30/6/2020 for alert notifications
    
    List<Reminder_Queue__c> reminderQList = new List<Reminder_Queue__c>();
    if (Trigger.isInsert) {
        if (Trigger.isAfter) {
            Id userId;
            for(sigmaerpdev2__Reminder_Setting__c setting: [SELECT Id,SetupOwnerId FROM sigmaerpdev2__Reminder_Setting__c]) {               
                userId = setting.SetupOwnerId;              
            }
            Datetime dt;
            for(Purchase_Order__c purOrdObj: Trigger.new){
                dt = (datetime)purOrdObj.sigmaerpdev2__Expected_Date__c;
            }
            Date purdate =  dt.date();
            for(Purchase_Order__c purOrdObj: Trigger.new){
                if(purOrdObj.Set_Alert_For_Procurement__c)
                    reminderQList.add(new Reminder_Queue__c(Purchase_Order__c=purOrdObj.Id,Status__c = 'Pending',User__c=userId,Start_date_new__c=purdate,Type__c = 'PO'));
            }
            if(reminderQList.size() > 0)
                insert reminderQList;
        }        
    }   
}