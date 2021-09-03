trigger updateOrderStatusOnShipment on Shipment__c (after update) {
    
    system.debug('inside updateOrderStatusOnShipment Trigger.isInsert ');
    
    List<Shipment__c> newShipment = Trigger.New;
    List<Shipment__c> oldShipment = Trigger.Old;
    
    System.debug('***SFDC: Trigger.new is: ' + Trigger.new);

    TriggerHandler triggerHandler=new TriggerHandler();
    if(Trigger.isInsert == true || Trigger.isUpdate == true){
        system.debug('inside Trigger.isInsert ');
        System.debug('newShipment:'+newShipment);
        TriggerHandler.updateOrderStatusOnShipment(newShipment,oldShipment);
    
    }

}