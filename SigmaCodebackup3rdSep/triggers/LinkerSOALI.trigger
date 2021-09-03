/*=====================================================================================================
Author     : Vidit Kumar
Company    : Mindlinks Solution Pvt Ltd.
Date       : 19-03-2018
Description: For Sigma Financial - creates Sigma Linkage Item Record of type Allocation
=======================================================================================================*/
trigger LinkerSOALI on Sales_Order_Allocation_Line_Item__c (after insert) 
{
    try
    {
        String EventType = 'SOALI';
        Set<Id> ObjectIdSet = new Set<Id>();
        for(Sales_Order_Allocation_Line_Item__c  soali:trigger.new) 
        {
            ObjectIdSet.add(soali.Id);
            EventType = 'SOALI';
        }
        //LinkageServiceClass link = new LinkageServiceClass();
        //link.LinkSOALI(ObjectIdSet,EventType);
        if(ObjectIdSet.size() > 0)
        {
            if(!Test.isRunningTest()){
            LinkageServiceClass.LinkSOALI(ObjectIdSet,EventType);
            }
        }
    }
    catch(Exception e)
    {
        System.debug('Exception LinkerSOALI trigger::'+e);
        System.debug('Exception Line Num in LinkerSOALI :'+e.getLineNumber());
    }
}