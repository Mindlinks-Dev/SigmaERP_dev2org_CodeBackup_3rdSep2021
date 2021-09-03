/*=====================================================================================================
Author     : Vidit Kumar
Company    : Mindlinks Solution Pvt Ltd.
Date       : 09-03-2018
Description: For Sigma Financial - creates Sigma Linkage Item Record of type Inventory
=======================================================================================================*/
trigger LinkerILPLI on Inventory_Location_Product_Line_Item__c(after insert) 
{
    
    try
    {
        String EventType = 'ILPLI';
        //system.debug('inside trigger EventType:::: '+EventType);
        Set<Id> ObjectIdSet = new Set<Id>();
        for(Inventory_Location_Product_Line_Item__c i:trigger.new)
        {
            
            ObjectIdSet.add(i.Id);
			EventType = 'ILPLI';
        }
        if(ObjectIdSet.size() > 0)
        {
            if(!Test.isRunningTest()){
            LinkageServiceClass.LinkILPLI(ObjectIdSet,EventType);
            }
        }
    }
    catch(Exception e)
    {
        System.debug('Exception in LinkerILPLI :'+e);
        System.debug('Exception Line Num in LinkerILPLI :'+e.getLineNumber());
    }
}