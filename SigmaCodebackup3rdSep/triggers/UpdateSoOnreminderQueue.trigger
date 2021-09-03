trigger UpdateSoOnreminderQueue on sigmaerpdev2__Sigma_Order__c (after insert) {
    List<Reminder_Queue__c> reminderQList = new List<Reminder_Queue__c>();
    System.debug('reminderQList>>'+reminderQList);
    if(Trigger.isInsert){
        if(Trigger.isAfter){
            Set<ID> setSOId = new Set<ID>();        
            for(Sigma_Order__c soObj : Trigger.new)
            {               
                setSOId.add(soObj.Id);              
            }
            
            List<Sigma_Order__c> sigmadata = [select id,(select id,Delivary_Date__c from Order_Lines__r) from Sigma_Order__c where id = : setSOId];
            System.debug('sigmadata>>'+sigmadata);
            Id userId;
            for(sigmaerpdev2__Reminder_Setting__c setting: [SELECT Id,SetupOwnerId FROM sigmaerpdev2__Reminder_Setting__c]) {               
                userId = setting.SetupOwnerId;              
            }
            System.debug('userId>>'+userId);
            for(sigmaerpdev2__Sigma_Order__c sigma : sigmadata){
                for(sigmaerpdev2__Product_Order_Price_Book__c orderline : sigma.sigmaerpdev2__Order_Lines__r)
                {
                    system.debug('orderline.Delivary_Date__c==='+orderline.Delivary_Date__c);
                    reminderQList.add(new Reminder_Queue__c(Sigma_Order__c = sigma.Id,Status__c = 'Pending',User__c = userId,Start_date_new__c = orderline.Delivary_Date__c,Type__c = 'SO'));
                } 
            } 
            if(reminderQList.size() > 0){
                insert reminderQList;
            } 
            System.debug('reminderQList>>'+reminderQList);    
        }
    }
}