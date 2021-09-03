public with sharing class ServiceInvoiceGenPdfCtrl {
    
    public String eachWOLineItem { get; set; }
    public List<String> paymentTerms {get; set;}
    public List<WOLineItem> workOrderLineItems {get;set;}
    public List<WOLineItem> workOrderLineItemsQuoted {get;set;}
    public sigmaerpdev2__Invoice_Tax__c tax {get; set;}
    public List<String> dummyLIST {get; set;}
    public List<String> dummyUsedLIST {get; set;}
    
    public sigmaerpdev2__Work_Order__c workOrderRecord{get;set;}
    //public Invoice__c InvoiceRecord{get;set;}      // to store invoice details
    public sigmaerpdev2__Service_Resource__c ContactAccountdetails{get;set;}
    public Date Today { get { return Date.today(); }}
    public Contact contactDetails{get;set;}
    public String lineItemsTotal{get;set;}
    public String taxPercentageStr{get;set;}
    public String signatureAttachmentId{get;set;}
    // public String workOrderRowId{get;set;}
    //private final Work_Order__c w;
    public Date dat {get;set;}
    public String dt {get;set;}
    
    public ServiceInvoiceGenPdfCtrl(ApexPages.StandardController stdController) {
        String workOrderRowId = ApexPages.currentPage().getparameters().get('id');
    }   
    public ServiceInvoiceGenPdfCtrl() {
        
        Date d = date.today();
        dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('d-MM-YYYY');
        
        // -- collect WO ID
        //system.debug('workOrderRowIdBef'+workOrderRowId);
        //String workOrderRowId = ApexPages.currentPage().getparameters().get('id');
        // workOrderRowId = stdController.getID();
        // system.debug('workOrderRowId after'+workOrderRowId);
        //query users details
        
        //-- query WO details
        String [] workOrderFields = new String [] {'sigmaerpdev2__Status__c','Name','sigmaerpdev2__Case_Description__c','sigmaerpdev2__Case_Subject_text__c','sigmaerpdev2__Total_Value__c','sigmaerpdev2__Bill_Street__c','sigmaerpdev2__Bill_City__c','sigmaerpdev2__Customer_Contact__c','sigmaerpdev2__Account__c'};
            
            // Obtaining the field name/token map for the WorkOrder object
            Map<String,Schema.SObjectField> workOrderMap = Schema.SObjectType.sigmaerpdev2__Work_Order__c.fields.getMap();
        for (String fieldToCheck : workOrderFields) {
            // Check if the user has create access on the each field
            if (!workOrderMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access to WorkOrder Fields');
                return;
            }
        }
        
        workOrderRecord = [Select Id,Name,sigmaerpdev2__AssignTo__r.ContactID,sigmaerpdev2__Case_Description__c,sigmaerpdev2__Case_Subject_text__c , sigmaerpdev2__Total_Value__c,sigmaerpdev2__Bill_Street__c,sigmaerpdev2__Bill_City__c,sigmaerpdev2__Customer_Contact__c,sigmaerpdev2__Account__r.Name,
                           sigmaerpdev2__Account__r.AccountNumber,sigmaerpdev2__Case_Number_text__c,
                           sigmaerpdev2__FFP_MR_Contact__c FROM sigmaerpdev2__Work_Order__c where Id=:ApexPages.currentPage().getparameters().get('id') limit 1];
        
        system.debug('workOrderRecord - '+workOrderRecord);
        
        
        // Service Resource Fields that will be accessed.
        String [] serviceResourceFields = new String [] {'Name','sigmaerpdev2__Mailing_Street__c','sigmaerpdev2__Mailing_City__c','sigmaerpdev2__Mailing_State_Province__c','sigmaerpdev2__Mailing_Zip_Postal_Code__c','sigmaerpdev2__Mailing_Country__c','sigmaerpdev2__Email__c','sigmaerpdev2__Phone__c'};
            
            // Obtaining the field name/token map for the Contact object
            Map<String,Schema.SObjectField> serviceResourceMap = Schema.SObjectType.sigmaerpdev2__Service_Resource__c.fields.getMap();
        for (String fieldToCheck : serviceResourceFields) {
            // Check if the user has create access on the each field
            if (!serviceResourceMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on Service Resource Fields');
            }
        }
        
        sigmaerpdev2__Service_Resource__c ContactAccountdetails = [select Id,Name,sigmaerpdev2__Mailing_Street__c, sigmaerpdev2__Mailing_City__c, sigmaerpdev2__Mailing_State_Province__c, sigmaerpdev2__Mailing_Zip_Postal_Code__c, sigmaerpdev2__Mailing_Country__c, sigmaerpdev2__Email__c ,sigmaerpdev2__Phone__c from sigmaerpdev2__Service_Resource__c where sigmaerpdev2__User__c = :workOrderRecord.sigmaerpdev2__AssignTo__c];
        
        system.debug('ContactAccountdetails - '+ContactAccountdetails);
        // -- get all the WO Line Items
        
        String [] workOrderLineItemFields = new String [] {'sigmaerpdev2__Product__c','sigmaerpdev2__Quote__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Work_Order__c','sigmaerpdev2__Price__c','sigmaerpdev2__Value__c','sigmaerpdev2__Cost__c','sigmaerpdev2__Description__c','sigmaerpdev2__Warranty__c','sigmaerpdev2__Discount__c'};
            
            // Obtaining the field name/token map for the WorkOrderLineItem object
            Map<String,Schema.SObjectField> workOrderLineItemMap = Schema.SObjectType.sigmaerpdev2__Work_Oder_Lines__c.fields.getMap();
        for (String fieldToCheck : workOrderLineItemFields) {
            // Check if the user has create access on the each field
            if (!workOrderLineItemMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on WorkOrderLineItem Fields');
                return;
            }
        }
        List<sigmaerpdev2__Work_Oder_Lines__c> workOrderLineItemRecords;
        
        workOrderLineItemRecords = [Select Id,sigmaerpdev2__Product__c,sigmaerpdev2__Quote__c,sigmaerpdev2__Quantity__c,sigmaerpdev2__Price__c,sigmaerpdev2__Value__c,
                                    sigmaerpdev2__Warranty__c,sigmaerpdev2__Description__c,sigmaerpdev2__Cost__c,sigmaerpdev2__Discount__c,sigmaerpdev2__Product__r.Name  FROM sigmaerpdev2__Work_Oder_Lines__c where sigmaerpdev2__Work_Order__c=:ApexPages.currentPage().getparameters().get('id') AND sigmaerpdev2__quote__c = false AND (sigmaerpdev2__Used1__c = true OR sigmaerpdev2__Warranty__c = true)];
        system.debug('WorkOrderLineItems - '+workOrderLineItemRecords);
        
        if(workOrderLineItemRecords!=null && workOrderLineItemRecords.size()>0){
            workOrderLineItems = new List<WOLineItem>();
            dummyUsedLIST = new List<String>();
            dummyUsedLIST.add('Used');
        }
        
        Integer counter =0;
        tax = sigmaerpdev2__Invoice_Tax__c.getInstance();
        paymentTerms = new List<String>();
        paymentTerms.add(tax.sigmaerpdev2__Payment_Terms_1__c);
        paymentTerms.add(tax.sigmaerpdev2__Payment_Terms_2__c);
        paymentTerms.add(tax.sigmaerpdev2__Payment_Terms_3__c);        
        Decimal taxPercentage=(workOrderRecord.sigmaerpdev2__Total_Value__c/100)*tax.sigmaerpdev2__Tax__c;
        for(sigmaerpdev2__Work_Oder_Lines__c eachWOLineItem : workOrderLineItemRecords){
            WOLineItem woLineItemRecord = new WOLineItem();
            counter=counter+1;
            woLineItemRecord.serialNumber=String.valueof(counter);
            woLineItemRecord.productName=eachWOLineItem.sigmaerpdev2__Product__r.Name;
            woLineItemRecord.qunatity=String.valueof(eachWOLineItem.sigmaerpdev2__Quantity__c);
            woLineItemRecord.unitPrice=String.valueof(eachWOLineItem.sigmaerpdev2__Price__c);
            woLineItemRecord.warrantyYESNO='NO';
            woLineItemRecord.quoteYESNO='NO';
            if(eachWOLineItem.sigmaerpdev2__Warranty__c){
                if(Schema.sObjectType.sigmaerpdev2__Work_Oder_Lines__c.fields.sigmaerpdev2__Warranty__c .isUpdateable()){
                    woLineItemRecord.warrantyYESNO='YES';
                }
            }
            
            woLineItemRecord.amount=String.valueof(eachWOLineItem.sigmaerpdev2__Value__c);
            workOrderLineItems.add(woLineItemRecord);
        }
        System.debug('workOrderLineItems '+workOrderLineItems);
        lineItemsTotal=String.valueof(workOrderRecord.sigmaerpdev2__Total_Value__c+taxPercentage);
        taxPercentageStr = String.valueof(taxPercentage);
        
        workOrderLineItemRecords = new List<sigmaerpdev2__Work_Oder_Lines__c>();
        workOrderLineItemRecords = [Select Id,sigmaerpdev2__Product__c,sigmaerpdev2__Quote__c,sigmaerpdev2__Quantity__c,sigmaerpdev2__Price__c,sigmaerpdev2__Value__c,
                                    sigmaerpdev2__Warranty__c,sigmaerpdev2__Description__c,sigmaerpdev2__Cost__c,sigmaerpdev2__Discount__c,sigmaerpdev2__Product__r.Name  FROM sigmaerpdev2__Work_Oder_Lines__c where sigmaerpdev2__Work_Order__c=:ApexPages.currentPage().getparameters().get('id') AND sigmaerpdev2__quote__c = true];
        system.debug('WorkOrderLineItems with Quote - '+workOrderLineItemRecords);
        
        if(workOrderLineItemRecords!=null && workOrderLineItemRecords.size()>0){
            workOrderLineItemsQuoted = new List<WOLineItem>();
            dummyLIST = new List<String>();
            dummyLIST.add('One Record');
        }
        
        counter = 0;
        for(sigmaerpdev2__Work_Oder_Lines__c eachWOLineItem : workOrderLineItemRecords){
            WOLineItem woLineItemRecord = new WOLineItem();
            counter=counter+1;
            woLineItemRecord.serialNumber=String.valueof(counter);
            woLineItemRecord.productName=eachWOLineItem.sigmaerpdev2__Product__r.Name;
            woLineItemRecord.qunatity=String.valueof(eachWOLineItem.sigmaerpdev2__Quantity__c);
            woLineItemRecord.warrantyYESNO='NO';
            woLineItemRecord.quoteYESNO='NO';
            workOrderLineItemsQuoted.add(woLineItemRecord);
        }
        System.debug('workOrderLineItemsQuoted '+workOrderLineItemsQuoted);
        
        
        //-- get Contact Details
        if(String.isNotEmpty(workOrderRecord.sigmaerpdev2__FFP_MR_Contact__c)){
            // Contact Fields that will be accessed.
            String [] contactFields = new String [] {'Name','FirstName','LastName','Email','Phone'};
                
                // Obtaining the field name/token map for the Contact object
                Map<String,Schema.SObjectField> contactMap = Schema.SObjectType.Contact.fields.getMap();
            for (String fieldToCheck : contactFields) {
                // Check if the user has create access on the each field
                if (!contactMap.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on Contact Fields');
                    return;
                }
            }
            contactDetails = [Select Id,Account.Name,Account.BillingStreet,Account.BillingCity,Account.BillingState,Account.BillingCountry,Account.BillingPostalCode,Name,FirstName,LastName,Email,Phone from Contact where Id=:workOrderRecord.sigmaerpdev2__FFP_MR_Contact__c];
            
        }
        
    } 
}