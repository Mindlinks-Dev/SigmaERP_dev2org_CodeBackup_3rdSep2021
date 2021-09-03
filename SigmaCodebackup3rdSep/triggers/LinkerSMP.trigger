/*=====================================================================================================
Author     : Vidit Kumar
Company    : Mindlinks Solution Pvt Ltd.
Date       : 19-03-2018
Description: For Sigma Financial - creates Sigma Linkage Item Record of type Packaging
=======================================================================================================*/
trigger LinkerSMP on Stock_Moment_Product__c (after insert) 
{
    try
        {
            String EventType = 'SMP';
            List<Stock_Moment_Product__c> SMPList = new List<Stock_Moment_Product__c>();
            Set<Id> fromIlpliSet = new Set<Id>();
            Set<Id> toIlpliSet = new Set<Id>();
            for(Stock_Moment_Product__c  smp:trigger.new) 
            {
                
                fromIlpliSet.add(smp.From_ILPLI__c);
                toIlpliSet.add(smp.ILPLI__c);
                SMPList.add(smp);
            }
            
            if(!Test.isRunningTest())
            {
                system.debug('fromIlpliSet??'+fromIlpliSet+'toIlpliSet??'+toIlpliSet);
            LinkageServiceClass.LinkStockMovement(SMPList,fromIlpliSet,toIlpliSet,EventType);
            }
        }
        catch(exception e)
        {
            System.debug('Exception in LinkerSMP :'+e);
            System.debug('Exception in LinkerSMP line:'+e.getLineNumber());
        }
}