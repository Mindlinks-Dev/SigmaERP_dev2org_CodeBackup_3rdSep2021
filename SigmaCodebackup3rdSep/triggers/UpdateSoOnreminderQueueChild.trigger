trigger UpdateSoOnreminderQueueChild on Product_Order_Price_Book__c (after insert) {
    List<Reminder_Queue__c> reminderQList = new List<Reminder_Queue__c>();
    System.debug('reminderQList>>'+reminderQList);
    if(Trigger.isInsert){
        if(Trigger.isAfter){
            Set<ID> setSOId = new Set<ID>();        
            for(Product_Order_Price_Book__c soObj : Trigger.new)
            {               
                setSOId.add(soObj.Id);              
            }
            
            List<Product_Order_Price_Book__c> sigmadata = [select id,Sigma_Order__c,Delivary_Date__c, sigmaerpdev2__Order_Status__c from Product_Order_Price_Book__c where id in : setSOId];
            System.debug('sigmadata>>'+sigmadata);
            Id userId;
            for(Reminder_Setting__c setting: [SELECT Id,SetupOwnerId FROM Reminder_Setting__c]) {               
                userId = setting.SetupOwnerId;              
            }
            System.debug('userId>>'+userId);           
            for(Product_Order_Price_Book__c orderline : sigmadata)
            {
            if(orderline.sigmaerpdev2__Order_Status__c == 'Order Confirmed'){
                system.debug('orderline.Delivary_Date__c==='+orderline.Delivary_Date__c);
                reminderQList.add(new Reminder_Queue__c(Sigma_Order__c = orderline.Sigma_Order__c,Status__c = 'Pending'
                ,User__c = userId,Start_date_new__c = orderline.Delivary_Date__c,Type__c = 'SO'));
                }
                

            } 
            
            if(reminderQList.size() > 0){
                insert reminderQList;
            } 
            System.debug('reminderQList>>'+reminderQList);    
        }
    }
}