global with sharing class GenerateinvoiceCntrl{

    public  List<Purchase_Order__c> orderData{get;set;}
    public  List<Purchase_Order_Product__c> POPOrderData{get;set;}
    public String orderId;
    public Default_Parameters__c defaultparam{get;set;}
    
    public GenerateinvoiceCntrl(ApexPages.StandardController controller) 
    {   
        orderId = System.currentPageReference().getParameters().get('id');
        system.debug('orderId'+orderId);
        this.getdefaultparameter();
        this.getOrderData();
        this.getOrderPODetails();
        
    }
    
    public List<Purchase_Order__c> getOrderPODetails()
    {
       if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order__c')
       && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order__c',new set<String>{'Id','Name','sigmaerpdev2__Status__c','sigmaerpdev2__Order_Date__c','sigmaerpdev2__Expected_Date__c','sigmaerpdev2__Total_Amount__c','sigmaerpdev2__Vendor_Mail__c','sigmaerpdev2__Product_Supplier__c','sigmaerpdev2__Product_Supplier__r.Type','sigmaerpdev2__Product_Supplier__r.Name','sigmaerpdev2__Product_Supplier__r.sigmaerpdev2__Address__c','sigmaerpdev2__Product_Supplier__r.sigmaerpdev2__City__c','sigmaerpdev2__Product_Supplier__r.sigmaerpdev2__Country__c','sigmaerpdev2__Product_Supplier__r.sigmaerpdev2__State__c','sigmaerpdev2__Product_Supplier__r.Phone','sigmaerpdev2__Product_Supplier__r.sigmaerpdev2__Email__c','sigmaerpdev2__Product_Supplier__r.Fax','sigmaerpdev2__Product_Supplier__r.sigmaerpdev2__Zip__c'})
       ){
        orderData = [SELECT Id,Name,Status__c,Order_Date__c,Expected_Date__c,Total_Amount__c,Vendor_Mail__c,Product_Supplier__c,Product_Supplier__r.Type,Product_Supplier__r.Name,Product_Supplier__r.Address__c,Product_Supplier__r.City__c,Product_Supplier__r.Country__c,Product_Supplier__r.State__c,Product_Supplier__r.Phone,Product_Supplier__r.Email__c,Product_Supplier__r.Fax,Product_Supplier__r.Zip__c FROM Purchase_Order__c WHERE Id = :orderId];
        system.debug('orderData>>'+orderData);
       }
        return orderData;
    }
    
     public Default_Parameters__c getdefaultparameter()
    {
         if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Default_Parameters__c')
       && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Default_Parameters__c',new set<String>{'sigmaerpdev2__Company_Name__c','sigmaerpdev2__Company_Email__c','sigmaerpdev2__Company_Phone__c','sigmaerpdev2__Logo__c','sigmaerpdev2__Company_VAT__c'})
       ){
        
        defaultparam = [SELECT Company_Name__c,Company_Email__c,Company_Phone__c,Logo__c,Company_VAT__c from Default_Parameters__c Limit 1];
       system.debug('defaultparam-->>>'+defaultparam);
       }
        return defaultparam;
    }
    public pagereference getOrderData()
    {
        system.debug('orderId'+orderId);
         if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order_Product__c')
       && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order_Product__c',new set<String>{'Id','Name','sigmaerpdev2__Purchase_Order__c','sigmaerpdev2__Expected_Delivery_Date__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Remaining_to_come__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Status__c','sigmaerpdev2__Buying_Price__c','sigmaerpdev2__Vendor_Price__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Discount__c','sigmaerpdev2__Purchase_Order__r.Id'})
       ){
        POPOrderData = [SELECT Id,Name,Purchase_Order__c,Expected_Delivery_Date__c,Quantity__c,Remaining_to_come__c,Received_Quantity__c,Status__c,Buying_Price__c,Vendor_Price__c,Product__c,Product__r.Name,Discount__c FROM Purchase_Order_Product__c WHERE Purchase_Order__r.Id = :orderId ];
           system.debug('POPOrderData'+POPOrderData);
       }
        return null;
    }
    
   webservice static boolean sendInvoiceMail(String orderId)
    {
    
    if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c')
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new set<String>{'Id','Name','sigmaerpdev2__Quantity__c','sigmaerpdev2__AccountId__r.sigmaerpdev2__Email__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Default_Parameters__c',new set<String>{'Id','Name','sigmaerpdev2__Invoice_Doc_Id__c'}))
{
    
        document doc = new document();
        Sigma_Order__c orderExt;
         Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        
        if(checkAccessPermissionsOrder() == true)
        {
            orderExt = [SELECT Id,Name,Quantity__c,AccountId__r.Email__c from Sigma_Order__c where id=:orderId];
        }  
        
        PageReference pdf = Page.GenerateInvoice;
        pdf.getParameters().put('id',orderId);
        Blob body;
        try 
        {
            body = pdf.getContent();
        } 
        catch (VisualforceException e) 
        {
            body = Blob.valueOf('Some Text');
        }

       
        Default_Parameters__c DefParam ; 
        if(checkAccessPermissionsDefaultParameters())
        {
            DefParam = [select Id,Invoice_Doc_Id__c from Default_Parameters__c Limit 1];
        }
        attach.setContentType('application/pdf');
        attach.setFileName('Invoice.pdf');
        attach.setInline(false);
        attach.Body = body;
        doc.Body = body;
        doc.name='Invoice'+orderExt.Name+'.pdf';
        doc.FolderId=DefParam.Invoice_Doc_Id__c;
        List<document> documnt;
        if(checkAccessPermissionsDocument() == true)
        {
            documnt =[select id,name from document where name=:doc.name];
        }
        if(documnt.size() == 0)
        {
            if(checkFLSPermissionsDocument() == true)
            {
                insert doc;
            }    
        } 
    
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setToAddresses(new String[] {orderExt.AccountId__r.Email__c});
        mail.setSubject('PDF Email Demo');
        mail.setHtmlBody('Here is the email you requested! Check the attachment!');
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 

        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    
        if (!results.get(0).isSuccess()) 
        {
            System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
            String errorMessage = results.get(0).getErrors()[0].getMessage();
            return false;
        }
       
    }
    return true;
    }
    public Static boolean checkAccessPermissionsOrder()
    {
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new Set<String>{'Id','Name','sigmaerpdev2__AccountId__r.sigmaerpdev2__Email__c','sigmaerpdev2__Orders_Status__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Net_Amount__c','sigmaerpdev2__Discount_Amount__c','sigmaerpdev2__Discount_Code__c','sigmaerpdev2__Shipment_Amount__c','sigmaerpdev2__Tax_Amount__c','sigmaerpdev2__TotalAmount__c','sigmaerpdev2__AccountId__r.BillingAddress','sigmaerpdev2__AccountId__r.BillingCountry','sigmaerpdev2__AccountId__r.BillingState','sigmaerpdev2__AccountId__r.BillingCity','sigmaerpdev2__AccountId__r.BillingStreet','sigmaerpdev2__AccountId__r.sigmaerpdev2__companystate__c','sigmaerpdev2__AccountId__r.Name','createddate'}))
        {
           return true;
        }  
        return false;
    }

    public Static boolean checkAccessPermissionsDocument()
    {
        if(CRUD_FLS_CheckUtility.checkReadPermission('document',new Set<String>{'id','name'}))
        {
           return true;
        }  
        return false;
    }
    public Static boolean checkFLSPermissionsDocument()
    {
        if(CRUD_FLS_CheckUtility.checkFLS('document',new Set<String>{'Body','name','FolderId'}))
        {
           return true;
        }  
        return false;
    }  
     
    public Static boolean checkAccessPermissionsDefaultParameters()
    {
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Default_Parameters__c',new Set<String>{'Id','sigmaerpdev2__Invoice_Doc_Id__c'}))
        {
           return true;
        }  
        return false;
    }

}