trigger SigmaQueueUpdate on Reminder_Queue__c (after insert,after update) 
{
    Set<Id> Ids = new Set<Id>();
    for(Reminder_Queue__c rem:Trigger.New){
        Ids.add(rem.Id);  
    }
    List<sigmaerpdev2__Sigma_Queue__c> Sigmaqueue2 = new List<sigmaerpdev2__Sigma_Queue__c>();
    List<sigmaerpdev2__Sigma_Queue__c> Sigmaqueue3 = new List<sigmaerpdev2__Sigma_Queue__c>();
    List<Reminder_Queue__c> Queuedata = [Select Id,Name,Purchase_Order__c,Sigma_Order__c,Purchase_Order__r.sigmaerpdev2__Expected_Date__c,Start_date__c,Stock_Receiving__c,Status__c,Start_date_new__c,Type__c From Reminder_Queue__c where Id in :Ids];
    List<sigmaerpdev2__Sigma_Queue__c> Sigmaqueue1 = [select id,Reminder_Queue__c from sigmaerpdev2__Sigma_Queue__c where Reminder_Queue__c=:Queuedata[0].Id];
 
    String types;
    for(Reminder_Queue__c rems:Queuedata){
        if(rems.Purchase_Order__c != null){
            types = 'PO';
        }
        else{
            types = 'SR';
        }
    } 
    String Action;
    Integer days;
    List<sigmaerpdev2__Reminder_Setting__c> ReminderData = [select sigmaerpdev2__After__c,SetupOwnerId,sigmaerpdev2__Before__c,sigmaerpdev2__Reminder_value__c from sigmaerpdev2__Reminder_Setting__c];
    System.debug('ReminderData>>'+ReminderData);
    for(sigmaerpdev2__Reminder_Setting__c rem:ReminderData)
    {
        days =(Integer)rem.sigmaerpdev2__Reminder_value__c;
        if(rem.sigmaerpdev2__Before__c == true){
            Action = 'Before';
        }
        else if(rem.sigmaerpdev2__After__c == true){
            Action = 'After';
        }
    }
    System.debug('Value>>'+ReminderData);
    System.debug('days>>'+ReminderData);
    for(Reminder_Queue__c temp : Queuedata)
    {
        if(Trigger.isInsert)
        {
            if(temp.Status__c == 'Pending')
            {
                sigmaerpdev2__Sigma_Queue__c Sigmaqueues = new sigmaerpdev2__Sigma_Queue__c();           
                Sigmaqueues.Reminder_Date__c = temp.Start_date_new__c;
                Sigmaqueues.Reminder_Queue__c= temp.Id;
                Sigmaqueues.Reminder_value__c = days;
                Sigmaqueues.Action__c= Action;
                Sigmaqueues.Type__c = temp.Type__c;
                Sigmaqueue2.add(Sigmaqueues); 
            }
        }
        if(Trigger.isUpdate)
        {
            if(temp.Status__c == 'Pending'){
                sigmaerpdev2__Sigma_Queue__c Sigmaqueues = new sigmaerpdev2__Sigma_Queue__c();
                Sigmaqueues.id = Sigmaqueue1[0].id;
                Sigmaqueues.Reminder_Date__c = temp.Start_date_new__c;
                Sigmaqueues.Reminder_Date__c = temp.Start_date__c;
                Sigmaqueue2.add(Sigmaqueues); 
            }
            else if(temp.Status__c == 'Closed'){
                sigmaerpdev2__Sigma_Queue__c Sigmaqueues = new sigmaerpdev2__Sigma_Queue__c();
                Sigmaqueues.id = Sigmaqueue1[0].Id;
                Sigmaqueue3.add(Sigmaqueues); 
            }
        } 
    }
    try 
    {
        if(Sigmaqueue2.size() > 0){
            upsert Sigmaqueue2;  
        }
        if(Sigmaqueue3.size() > 0){
            delete Sigmaqueue3;
        }
    } catch (Exception e) {
       System.debug('e>>'+e);
    }
    
}