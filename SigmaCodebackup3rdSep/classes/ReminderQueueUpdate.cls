public class ReminderQueueUpdate {
    
    @InvocableMethod
    public static void UpdateRecord(List<String> Ids) {
        List<Purchase_Order__c> purchaseorder = [select id,sigmaerpdev2__Expected_Date__c from Purchase_Order__c where id in:Ids];
        System.debug('purchaseorder>>'+purchaseorder);
        
        List<sigmaerpdev2__Reminder_Queue__c> Remindata = [select id,sigmaerpdev2__Purchase_Order__c from sigmaerpdev2__Reminder_Queue__c];
        set<Id> PO = new set<Id>();
        for(sigmaerpdev2__Reminder_Queue__c rem:Remindata){
            PO.add(rem.sigmaerpdev2__Purchase_Order__c);
        }
        
        Id userId;
        for(sigmaerpdev2__Reminder_Setting__c setting: [SELECT Id,SetupOwnerId FROM sigmaerpdev2__Reminder_Setting__c]) {
            //if(setting.SetupOwnerId.getSObjectType() == User.SObjectType) {
            userId = setting.SetupOwnerId;
            // }
        }
        List<sigmaerpdev2__Reminder_Queue__c> RemUpdate1 = new List<sigmaerpdev2__Reminder_Queue__c>();
        List<sigmaerpdev2__Reminder_Queue__c> RemUpdate2 = new List<sigmaerpdev2__Reminder_Queue__c>();
        for(Purchase_Order__c purs:purchaseorder){
            if(PO.contains(purs.id)){
                sigmaerpdev2__Reminder_Queue__c reminder = new sigmaerpdev2__Reminder_Queue__c();
                reminder.sigmaerpdev2__Purchase_Order__c = purchaseorder[0].Id;
                reminder.sigmaerpdev2__Status__c = 'Pending';
                RemUpdate2.add(reminder);
            }
            else{
                sigmaerpdev2__Reminder_Queue__c reminder = new sigmaerpdev2__Reminder_Queue__c();
                reminder.sigmaerpdev2__Purchase_Order__c = purchaseorder[0].Id;
                reminder.sigmaerpdev2__Status__c = 'Pending';
                reminder.sigmaerpdev2__User__c = userId;
                RemUpdate1.add(reminder);
            }
        }
        System.debug('RemUpdate1>>'+RemUpdate1);
        System.debug('RemUpdate2>>'+RemUpdate2);
        if(RemUpdate1.size() > 0){
            insert RemUpdate1;
        }
        else if(RemUpdate2.size()>0){
            update RemUpdate2;
        }
    }
}