/*=====================================================================================================
Author     : Vidit Kumar
Company    : Mindlinks Solution Pvt Ltd.
Date       : 19-03-2018
Description: For Sigma Financial - creates Sigma Linkage Item Record of type Packaging
=======================================================================================================*/
trigger LinkerPPLI on Package_Product_Line_Item__c (after insert, after update) 
{
    try
    {
        String EventType = 'PPLI';
        Set<Id> ObjectIdSet = new Set<Id>();
        Map<Id,Id> ShipPackMap = new Map<Id,Id>();
        for(Package_Product_Line_Item__c  ppli:trigger.new) 
        {
            if(ppli.Status__c == 'Ready')
            {
                ObjectIdSet.add(ppli.Id);
            }
        }
        //LinkageServiceClass link = new LinkageServiceClass();
        //link.LinkPPLI(ObjectIdSet,EventType);
        if(ObjectIdSet.size() > 0)
        {
            if(!Test.isRunningTest()){
            LinkageServiceClass.LinkPPLI(ObjectIdSet,EventType,ShipPackMap);
            }
        }
    }
    catch(Exception e)
    {
        System.debug('Exception LinkerPPLI trigger::'+e);
        System.debug('Exception Line Num in LinkerPPLI :'+e.getLineNumber());
    }
}