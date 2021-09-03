/*=====================================================================================================
Author     : Vidit Kumar
Company    : Mindlinks Solution Pvt Ltd.
Date       : 19-03-2018
Description: For Sigma Financial - creates Sigma Linkage Item Record of type Packaging
=======================================================================================================*/
trigger LinkerSAP on Stock_Adjustment_Product__c (after insert) 
{
    try
    {
        String EventType = 'SAP';
        List<Stock_Adjustment_Product__c> SAPList = new List<Stock_Adjustment_Product__c>();
        Id SAId;
        Set<Id> ILPLISet = new Set<Id>();
        for(Stock_Adjustment_Product__c  sap:trigger.new) 
        {
            SAId = sap.Stock_Adjustment__c;
            ILPLISet.add(sap.ILPLI__c);
            SAPList.add(sap);
        }
        
        if(!Test.isRunningTest())
        {
        LinkageServiceClass.LinkSADecrease(SAPList,SAId,ILPLISet,EventType);
        }
    }
    catch(Exception e)
    {
        System.debug('Exception LinkerSAP trigger::'+e);
        System.debug('Exception Line Num in LinkerSAP :'+e.getLineNumber());
    }
}