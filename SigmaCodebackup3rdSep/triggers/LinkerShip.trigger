/*=====================================================================================================
Author     : Vidit Kumar
Company    : Mindlinks Solution Pvt Ltd.
Date       : 23-03-2018
Description: For Sigma Financial - creates Sigma Linkage Item Record of type Shipment
=======================================================================================================*/
trigger LinkerShip on Shipment_Products__c (after insert, after update) 
{
    try
    {
        //code added by anuja to remove multiple triggers on same object issue-------
    List<Shipment_Products__c > shipment= Trigger.New;
    List<Id> shipmentProductIdList = new List<Id>();
    TriggerHandler triggerHandler=new TriggerHandler();
    for(Shipment_Products__c  s : shipment){
        system.debug('Shipment ID:: ' + s.Id);     
        
        Id val = s.Id;
        shipmentProductIdList.add(val);
        System.debug('Individual shipmentProductIdList to send to TriggerHandler:'+shipmentProductIdList);
     
      
    } 
    ///////////////////////////////////////////////////////////////////
        String EventType = 'SHIP';
        Map<Id,Id> ShipPackMap = new Map<Id,Id>();  //key => package id; value => shipment Product id
        Set<Id> PackageSet = new Set<Id>(); 
        //commented code by chandana by handel the direct shipped status in PI 
       /* if(Trigger.isInsert)
        {
             triggerHandler.updateOrderStatusOnShipmentFistTile(shipmentProductIdList);  
            for(Shipment_Products__c  i:trigger.new)
            {
                if(i.Status__c == 'Delivered')
                {
                    ShipPackMap.put(i.Package_ID__c,i.Id);  //key => package id; value => shipment Product id
                    PackageSet.add(i.Package_ID__c);    //storing package id in the object list
                }
            }
        }
        else */
        if(Trigger.isUpdate)
        {
            triggerHandler.updateOrderStatusOnShipmentProdUpdate(shipment);  
            for(Shipment_Products__c  i:trigger.new)
            {
                for(Shipment_Products__c  j:trigger.old)
                {
                    if( i.Id == j.Id && (i.Status__c == 'Delivered' && j.Status__c != 'Delivered') )
                    {
                        ShipPackMap.put(i.Package_ID__c,i.Id);  //key => package id; value => shipment Product id
                        PackageSet.add(i.Package_ID__c);    //storing package id in the object list
                    }
                }
            }
        }
        
        if(PackageSet.size() > 0)
        {
            if(!Test.isRunningTest()){
            LinkageServiceClass.LinkShipment(ShipPackMap,PackageSet,EventType);
            }
        }
    }
    catch(Exception e)
    {
        System.debug('Exception LinkerShip trigger::'+e);
        System.debug('Exception Line Num in LinkerShip :'+e.getLineNumber());
    }
}