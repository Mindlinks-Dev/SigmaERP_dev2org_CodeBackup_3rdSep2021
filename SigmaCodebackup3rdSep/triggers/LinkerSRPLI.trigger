/*=====================================================================================================
Author     : Vidit Kumar
Company    : Mindlinks Solution Pvt Ltd.
Date       : 09-03-2018
Description: For Sigma Financial - creates Sigma Linkage Item Record of type Stock receiving
=======================================================================================================*/
trigger LinkerSRPLI  on Stock_Receiving_Product_Line_Item__c  (after insert, after update) 
{
    
    try
    {
        String EventType = 'SRPLIInsert';
        Set<Id> ObjectIdSet = new Set<Id>();
        for(Stock_Receiving_Product_Line_Item__c i:trigger.new)
        {
            
            if(Trigger.isUpdate)
            {
            EventType = 'SRPLIUpdate';
            ObjectIdSet.add(i.Id);
            }
            
            if(Trigger.isInsert)
            {
                ObjectIdSet.add(i.Id);

            }
        }
        system.debug('ObjectIdSet>>'+ObjectIdSet);
        if(ObjectIdSet.size() > 0)
        {
            if(!Test.isRunningTest()){
            //LinkageServiceClass link = new LinkageServiceClass();
            //link.createSL(ObjectIdSet,EventType,proIdlist);
            LinkageServiceClass.LinkSRPLI(ObjectIdSet,EventType);
            }
        }
    }
    catch(Exception e)
    {
        System.debug('Exception in LinkerSRPLI:'+e);
        System.debug('Exception Line Num in LinkerSRPLI'+e.getLineNumber());
    }
  
}