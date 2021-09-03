public with sharing class ServiceInvoiceGenPdfCtrl1 {
    
    public String eachWOLineItem { get; set; }
    public List<String> paymentTerms {get; set;}
    public List<WOLineItem> workOrderLineItems {get;set;}
    public List<WOLineItem> workOrderLineItemsQuoted {get;set;}
    public sigmaerpdev2__Invoice_Tax__c tax {get; set;}
    public List<String> dummyLIST {get; set;}
    public List<String> dummyUsedLIST {get; set;}
    public Decimal TotalAmount {get; set;}
    public Decimal scharge {get; set;}
    public Decimal Taxes {get; set;}
    public String W0Name {get; set;}
    //public String Coveredunderquote {get; set;}
    
    
    //public sigmaerpdev2__Work_Order__c workOrderRecord{get;set;}
   
    Work_Order__c workOrderRecord;
    //public Invoice__c InvoiceRecord{get;set;}      // to store invoice details
    public sigmaerpdev2__Service_Resource__c ContactAccountdetails{get;set;}
    public Date Today { get { return Date.today(); }}
    public Contact contactDetails{get;set;}
    public String lineItemsTotal{get;set;}
    public String taxPercentageStr{get;set;}
    public String signatureAttachmentId{get;set;}
    public String workOrderRowId{get;set;}
    //private final Work_Order__c w;
    public Date dat {get;set;}
    public String dt {get;set;}
    
    /*public ServiceInvoiceGenPdfCtrl1(ApexPages.StandardController stdController) {
        String workOrderRowId = apexpages.currentpage().getparameters().get('id');
        //String workOrderRowId = 'a292x0000001YrFAAU';
    } */  
    public ServiceInvoiceGenPdfCtrl1(ApexPages.StandardController stdController) {
        String workOrderRowId = apexpages.currentpage().getparameters().get('id');
      /*  Date d = date.today();
        dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('d-MM-YYYY');*/
         workOrderRecord = [Select Id,Name,sigmaerpdev2__AssignTo__r.ContactID,sigmaerpdev2__Case_Description__c,sigmaerpdev2__Case_Subject_text__c , sigmaerpdev2__Total_Value__c,sigmaerpdev2__Bill_Street__c,sigmaerpdev2__Bill_City__c,sigmaerpdev2__Customer_Contact__c,sigmaerpdev2__Account__r.Name,
                           sigmaerpdev2__Account__r.AccountNumber,sigmaerpdev2__Case_Number_text__c,Tax_Amount__c,Tax__c,Service_Contract__c,Service_Contract__r.Contract_End_Date__c,Account__r.Customer_Type__c,Account__c,Status__c,TotalAmount__c,Customer_Availability_Date__c,
                           sigmaerpdev2__Work_Type__c,Service_Warrenty_End_date__c,sigmaerpdev2__Work_Type__r.sigmaerpdev2__Service_Charge__c,sigmaerpdev2__FFP_MR_Contact__c FROM sigmaerpdev2__Work_Order__c where Id = :workOrderRowId];
        
        system.debug('workOrderRecord.Customer_Availability_Date__c:::::::::- '+workOrderRecord.Customer_Availability_Date__c);
        
        
         Datetime dT1=workOrderRecord.Customer_Availability_Date__c;
         Date dts = date.newinstance(dT1.year(), dT1.month(), dT1.day());
			dt = DateTime.newInstance(dts.year(),dts.month(),dts.day()).format('d-MM-YYYY');
        
        // -- collect WO ID
        system.debug('start===='+apexpages.currentpage().getparameters().get('id'));
        system.debug('workOrderRowIdBef==='+workOrderRowId);
        //String workOrderRowId = ApexPages.currentPage().getparameters().get('id');
        // workOrderRowId = stdController.getID();
        // system.debug('workOrderRowId after'+workOrderRowId);
        //query users details
        system.debug('line 40');
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
        system.debug('line 53');
        workOrderRecord = [Select Id,Name,sigmaerpdev2__AssignTo__r.ContactID,sigmaerpdev2__Case_Description__c,sigmaerpdev2__Case_Subject_text__c , sigmaerpdev2__Total_Value__c,sigmaerpdev2__Bill_Street__c,sigmaerpdev2__Bill_City__c,sigmaerpdev2__Customer_Contact__c,sigmaerpdev2__Account__r.Name,
                           sigmaerpdev2__Account__r.AccountNumber,sigmaerpdev2__Case_Number_text__c,Tax_Amount__c,Tax__c,Service_Contract__c,Service_Contract__r.Contract_End_Date__c,Account__r.Customer_Type__c,Account__c,Status__c,TotalAmount__c,Customer_Availability_Date__c,
                           sigmaerpdev2__Work_Type__c,Service_Warrenty_End_date__c,sigmaerpdev2__Work_Type__r.sigmaerpdev2__Service_Charge__c,sigmaerpdev2__FFP_MR_Contact__c FROM sigmaerpdev2__Work_Order__c where Id = :workOrderRowId];
        
        system.debug('workOrderRecord.Customer_Availability_Date__c:::::::::- '+workOrderRecord.Customer_Availability_Date__c);
        
        
         Datetime dT=workOrderRecord.Customer_Availability_Date__c;
        Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
        
        
        if((workOrderRecord.Service_Warrenty_End_date__c!=null) || (workOrderRecord.Service_Contract__c!=null)){
       
         system.debug('myDate::::- '+myDate);
        if((myDate<=workOrderRecord.Service_Warrenty_End_date__c) || (myDate<=workOrderRecord.Service_Contract__r.Contract_End_Date__c)){
        workOrderRecord.sigmaerpdev2__Work_Type__r.sigmaerpdev2__Service_Charge__c=0;
        }
        }
         scharge=0;
            if(workOrderRecord.sigmaerpdev2__Work_Type__r.sigmaerpdev2__Service_Charge__c!=null){
            scharge=workOrderRecord.sigmaerpdev2__Work_Type__r.sigmaerpdev2__Service_Charge__c;
            }
        W0Name=workOrderRecord.Name;
       
       
        
        
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
        
        sigmaerpdev2__Service_Resource__c ContactAccountdetails = [select Id,Name,sigmaerpdev2__Mailing_Street__c, 
        sigmaerpdev2__Mailing_City__c, sigmaerpdev2__Mailing_State_Province__c,
        sigmaerpdev2__Mailing_Zip_Postal_Code__c, sigmaerpdev2__Mailing_Country__c,
        sigmaerpdev2__Email__c ,sigmaerpdev2__Phone__c from sigmaerpdev2__Service_Resource__c 
        where sigmaerpdev2__User__c = :workOrderRecord.sigmaerpdev2__AssignTo__c limit 1];
        
        system.debug('ContactAccountdetails - '+ContactAccountdetails);
        // -- get all the WO Line Items
        
        /*String [] workOrderLineItemFields = new String [] {'sigmaerpdev2__Product__c','sigmaerpdev2__Quote__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Work_Order__c','sigmaerpdev2__Price__c','sigmaerpdev2__Value__c','sigmaerpdev2__Cost__c','sigmaerpdev2__Description__c','sigmaerpdev2__Warranty__c','sigmaerpdev2__Discount__c'};
            
            // Obtaining the field name/token map for the WorkOrderLineItem object
            Map<String,Schema.SObjectField> workOrderLineItemMap = Schema.SObjectType.sigmaerpdev2__Work_Oder_Lines__c.fields.getMap();
        for (String fieldToCheck : workOrderLineItemFields) {
            // Check if the user has create access on the each field
            if (!workOrderLineItemMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on WorkOrderLineItem Fields');
                return;
            }
        }*/
        List<sigmaerpdev2__Work_Oder_Lines__c> workOrderLineItemRecords;
        set<Id> prod=new set<Id>();
        workOrderLineItemRecords = [Select Id,sigmaerpdev2__Product__c,Work_Order__r.Product_Warranty_End_date__c,sigmaerpdev2__Discount__c,sigmaerpdev2__Quote__c,sigmaerpdev2__Quantity__c,sigmaerpdev2__Price__c,sigmaerpdev2__Value__c,
                                    sigmaerpdev2__Warranty__c,sigmaerpdev2__Description__c,sigmaerpdev2__Cost__c,sigmaerpdev2__Product__r.Name  FROM sigmaerpdev2__Work_Oder_Lines__c where sigmaerpdev2__Work_Order__c=:ApexPages.currentPage().getparameters().get('id') AND sigmaerpdev2__quote__c = false AND (sigmaerpdev2__Used1__c = true OR sigmaerpdev2__Warranty__c = true)];
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
        
         Decimal amnt;
         Decimal amt;
         Decimal cnt=0;
         Decimal cn=0;
         Decimal tamount=0;
         
          for(sigmaerpdev2__Work_Oder_Lines__c wol: workOrderLineItemRecords) {
            prod.add(wol.sigmaerpdev2__Product__c);
        }
         
         List<PricebookEntry> prce =[Select Product2Id,UnitPrice From PricebookEntry WHERE PriceBook2.Name = 'Standard Price Book' and Product2.Id =:prod];
        Decimal unitprice=0;
        Map<Id,Decimal> uprice = new Map<Id,Decimal>();
        for(PricebookEntry pbe: prce) {
          unitprice=pbe.UnitPrice;
            uprice.put(pbe.Product2Id,UnitPrice);
          }
         
         
         
         
        for(sigmaerpdev2__Work_Oder_Lines__c eachWOLineItem : workOrderLineItemRecords){
            WOLineItem woLineItemRecord = new WOLineItem();
            counter=counter+1;
            woLineItemRecord.serialNumber=String.valueof(counter);
            woLineItemRecord.productName=eachWOLineItem.sigmaerpdev2__Product__r.Name;
            woLineItemRecord.qunatity=String.valueof(eachWOLineItem.sigmaerpdev2__Quantity__c);
            woLineItemRecord.unitPrice=String.valueof(uprice.get(eachWOLineItem.sigmaerpdev2__Product__c));
            woLineItemRecord.warrantyYESNO='NO';
            decimal discount=0;
            
            woLineItemRecord.quoteYESNO=String.valueof(discount);
            amt=uprice.get(eachWOLineItem.sigmaerpdev2__Product__c)*eachWOLineItem.sigmaerpdev2__Quantity__c;
            woLineItemRecord.Coveredunderquote='NO';
            Service_Quote__c[] sq = [select id,Name,Work_Order__c from Service_Quote__c where Work_Order__c=:ApexPages.currentPage().getparameters().get('id')];
                 system.debug('sq'+sq);
                 
            
            if (!sq.isEmpty()) {
                List<Sigma_Order__c> so=new List<Sigma_Order__c>([Select id,name,sigmaerpdev2__Paid_Amount__c,sigmaerpdev2__Is_Payment_Made__c,sigmaerpdev2__Service_Quote__c,(select id,Name,sigmaerpdev2__Product__c from sigmaerpdev2__Order_Lines__r) from sigmaerpdev2__Sigma_Order__c where Service_Quote__c =:sq]);
             system.debug('so'+so);
                if(so.size()>0){
             if(so[0].Is_Payment_Made__c==true){
                 for(Sigma_Order__c s:so){
                     for(Product_Order_Price_Book__c ol:s.sigmaerpdev2__Order_Lines__r){
                         if(ol.Product__c==eachWOLineItem.sigmaerpdev2__Product__c){
                           woLineItemRecord.quoteYESNO=String.valueof(amt); 
                           woLineItemRecord.Coveredunderquote='YES';
                           amt=0;
                         }
                     }
                     
                 }
                 
                 
             }
            }
            } 
            
            woLineItemRecord.amount=String.valueof(amt);
            amnt=amt;
            cn=cn+amt;
            
            system.debug('myDate>>'+myDate);
        if((myDate<=eachWOLineItem.Work_Order__r.Product_Warranty_End_date__c) || (myDate<=eachWOLineItem.Work_Order__r.Product_Warranty_End_date__c)){
        
                eachWOLineItem.sigmaerpdev2__Warranty__c=true;
                
        }
        System.debug('eachWOLineItem.sigmaerpdev2__Warranty__c??????'+eachWOLineItem.sigmaerpdev2__Warranty__c);
        
            System.debug('amnt'+amnt);
            if(eachWOLineItem.sigmaerpdev2__Warranty__c==true){
                    woLineItemRecord.warrantyYESNO='YES';
                    woLineItemRecord.quoteYESNO=String.valueof(amt);
                    woLineItemRecord.amount='0';
                   cnt=cnt+amt;
                   
                
            }
             
            workOrderLineItems.add(woLineItemRecord);
            
            
        }
        System.debug('workOrderLineItems '+workOrderLineItems);
              
             // System.debug('amnt'+amnt);
            amnt=cn-cnt;
        
       tamount=scharge+amnt;
       System.debug('amnt'+amnt);
        
        
        Double TaxOnBillAmount = 0;
            List<Tax__c> taxObj = WoPayment.getTax(workOrderRecord.Account__c);
                Double federalTax = Double.valueOf(taxObj.get(0).Tax_Amount__c);
                String fedTaxType = String.valueOf(taxObj.get(0).Type__c);
                Double stateTax = Double.valueOf(taxObj.get(1).Tax_Amount__c);
                String stateTaxType = String.valueOf(taxObj.get(1).Type__c);
                
                if(fedTaxType == 'Percentage'){
                    TaxOnBillAmount = (tamount* federalTax)/100;
                }else{
                    TaxOnBillAmount = tamount + federalTax;
                }               
                if(stateTaxType == 'Percentage'){
                    TaxOnBillAmount = (TaxOnBillAmount + (tamount * stateTax)/100);
                }else{
                    TaxOnBillAmount = (TaxOnBillAmount + (tamount + stateTax));
                }        
                workOrderRecord.Tax_Amount__c = TaxOnBillAmount;
                workOrderRecord.Tax__c = federalTax+stateTax;
            system.debug('TaxOnBillAmount::'+TaxOnBillAmount);
            
            Taxes=TaxOnBillAmount;
            
            TotalAmount=tamount+TaxOnBillAmount;
            workOrderRecord.TotalAmount__c=TotalAmount;
        system.debug('workOrderRecord.TotalAmount__c::'+workOrderRecord.TotalAmount__c);
        
        
        
        
        lineItemsTotal=String.valueof(workOrderRecord.sigmaerpdev2__Total_Value__c+taxPercentage);
        taxPercentageStr = String.valueof(taxPercentage);
        
        workOrderLineItemRecords = new List<sigmaerpdev2__Work_Oder_Lines__c>();
        set<Id> Quoteprod=new set<Id>();
        workOrderLineItemRecords = [Select Id,sigmaerpdev2__Product__c,sigmaerpdev2__Quote__c,sigmaerpdev2__Quantity__c,sigmaerpdev2__Price__c,sigmaerpdev2__Value__c,
                                    sigmaerpdev2__Warranty__c,sigmaerpdev2__Description__c,sigmaerpdev2__Cost__c,sigmaerpdev2__Discount__c,sigmaerpdev2__Product__r.Name  FROM sigmaerpdev2__Work_Oder_Lines__c where sigmaerpdev2__Work_Order__c=:ApexPages.currentPage().getparameters().get('id') AND sigmaerpdev2__quote__c = true];
        system.debug('WorkOrderLineItems with Quote - '+workOrderLineItemRecords);
        
        if(workOrderLineItemRecords!=null && workOrderLineItemRecords.size()>0){
            workOrderLineItemsQuoted = new List<WOLineItem>();
            dummyLIST = new List<String>();
            dummyLIST.add('One Record');
        }
        
        for(sigmaerpdev2__Work_Oder_Lines__c wol: workOrderLineItemRecords) {
            Quoteprod.add(wol.sigmaerpdev2__Product__c);
        }
        
        List<PricebookEntry> prce1 =[Select Product2Id,UnitPrice From PricebookEntry WHERE PriceBook2.Name = 'Standard Price Book' and Product2.Id =:Quoteprod];
        Decimal unitprice1=0;
        Map<Id,Decimal> uprice1 = new Map<Id,Decimal>();
        for(PricebookEntry pbe: prce1) {
          unitprice1=pbe.UnitPrice;
            uprice1.put(pbe.Product2Id,UnitPrice1);
          }
        Decimal quoteamount;
        counter = 0;
        for(sigmaerpdev2__Work_Oder_Lines__c eachWOLineItem : workOrderLineItemRecords){
            WOLineItem woLineItemRecord = new WOLineItem();
            counter=counter+1;
            woLineItemRecord.serialNumber=String.valueof(counter);
            woLineItemRecord.productName=eachWOLineItem.sigmaerpdev2__Product__r.Name;
            woLineItemRecord.qunatity=String.valueof(eachWOLineItem.sigmaerpdev2__Quantity__c);
            woLineItemRecord.warrantyYESNO=String.valueof(uprice1.get(eachWOLineItem.sigmaerpdev2__Product__c));
            quoteamount=uprice1.get(eachWOLineItem.sigmaerpdev2__Product__c)*eachWOLineItem.sigmaerpdev2__Quantity__c;
            woLineItemRecord.quoteYESNO=String.valueof(quoteamount);
            //woLineItemRecord.Discount=0;
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
  
 
    
    
    
    public Work_Order__c getworkOrderRecord(){
        return workOrderRecord;
    }
     
    
}