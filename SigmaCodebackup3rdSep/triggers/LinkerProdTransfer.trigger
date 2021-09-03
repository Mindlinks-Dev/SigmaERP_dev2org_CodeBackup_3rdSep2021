/*=====================================================================================================
Author     : Rashmi & Ibrahim 
Company    : Mindlinks Solution Pvt Ltd.
Date       : 25 December 2020
Description: Imperitive for Sigma Financials Used by Linker Triggers
=======================================================================================================*/
trigger LinkerProdTransfer on sigmaerpdev2__Product_Transfer_Inventory_Tracking__c (after insert,after update) {
    try
    {
        String EventType = 'PT';
        List<Product_Transfer_Inventory_Tracking__c> PTList = new List<Product_Transfer_Inventory_Tracking__c>();
        Set<Id> fromIlpliSet = new Set<Id>();
        Set<Id> toIlpliSet = new Set<Id>();
        for(Product_Transfer_Inventory_Tracking__c  pt:trigger.new)
        {
            system.debug('pt>>'+pt.To_ilpli__c);
            if(pt.To_ilpli__c!= null)
            {
                fromIlpliSet.add(pt.Inventory_Location_Product_Line_Item__c);
                toIlpliSet.add(pt.To_ilpli__c);
                PTList.add(pt);
            }
        }
        
        if(!Test.isRunningTest())
        {
            system.debug('fromIlpliSet??'+fromIlpliSet+'toIlpliSet??'+toIlpliSet);
            LinkageServiceClass.LinkProductTransfer(PTList,fromIlpliSet,toIlpliSet);
        }
    }
    catch(exception e)
    {
        System.debug('Exception in LinkerSMP :'+e);
        System.debug('Exception in LinkerSMP line:'+e.getLineNumber());
    }
}