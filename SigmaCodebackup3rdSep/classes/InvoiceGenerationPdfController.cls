public with sharing class InvoiceGenerationPdfController {
    @AuraEnabled
    public static boolean generateInvoicePDF(String currentRecordRowIdString) {
        //String currentRecordRowId = (String)JSON.deserialize(currentRecordRowIdString, String.Class);
        system.debug('************ APEX CLASS - INVOICE_GENERATION_PDF_CONTROLLER***************');
        Utility.getInvoicePDFContent(currentRecordRowIdString);
        system.debug('Function Returned Successfully');
        return true; 
    } 
    @AuraEnabled
    public static String getPDFContAsBase64(String currentRecordRowId) {
        // system.debug('currentRecordRowId'+currentRecordRowId);
        return Utility.getPDFContentAsBase64(currentRecordRowId);
    }
    @AuraEnabled
    public static workOrderWrapper updateStatus(String currentRecordRowId){
        // List<sObject> ObjectList = new List<sObject>();
        //String currentRecordRowId = (String)JSON.deserialize(currentRecordRowIdString, String.Class);
        workOrderWrapper orderWrap = new workOrderWrapper();
        orderWrap.isWorkOrderEmpty = true;
        Work_Order__c RecordToUpdate;
        String [] workOrderFields = new String [] {'sigmaerpdev2__Status__c'};
            
            // Obtaining the field name/token map for the WorkOrder object
            Map<String,Schema.SObjectField> workOrderMap = Schema.SObjectType.Work_Order__c.fields.getMap();
        for (String fieldToCheck : workOrderFields) {
            // Check if the user has create access on the each field
            if (!workOrderMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on WorkOrder Fields');
                return null;
            }
        }
        
        RecordToUpdate = [Select id,Status__c,Another_Visit_Needed__c from Work_Order__c where id=:currentRecordRowId Limit 1];
        
        List<Work_Oder_Lines__c> WoLineitemCheck;
        if(Schema.sObjectType.Work_Oder_Lines__c.fields.Name.isAccessible()){
            WoLineitemCheck = [SELECT Id,Name FROM Work_Oder_Lines__c where Work_Order__c = : currentRecordRowId];
        }
        else{
            system.debug('WorkOrderLineItem not Accessible');
        }
        
        
        if( !WoLineitemCheck.isEmpty()){
            orderWrap.isWorkOrderEmpty = false;
            system.debug('Work order Status '+RecordToUpdate.Status__c);
           
           if(RecordToUpdate.Another_Visit_Needed__c==true){

		   if(Schema.sObjectType.Work_Order__c.fields.Status__c.isUpdateable()){
				RecordToUpdate.Status__c = 'Another Visit Needed';
            }
		   }
		   
            else{
				 if(Schema.sObjectType.Work_Order__c.fields.Status__c.isUpdateable()){
				RecordToUpdate.Status__c = 'Invoiced to Customer';
            }
                system.debug('No Edit Access on Work_Order__c - Status__c Field');
            }
            Update RecordToUpdate;
           
            orderWrap.workOrderId = RecordToUpdate.ID;
        }
        return orderWrap;
        
    }
    
    public class workOrderWrapper {
        @AuraEnabled
        public ID workOrderId {get; set;}
        @AuraEnabled
        public Boolean isWorkOrderEmpty {get; set;}
    }
    
}