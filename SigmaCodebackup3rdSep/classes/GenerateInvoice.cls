global with sharing class GenerateInvoice{

    public  List<Sigma_Order__c> orderData{get;set;}
    public List<Work_Order__c> service{get;set;}
    public  List<Product_Order_Price_Book__c> productOrderData{get;set;}
    public List<OrderLineLocation__c>OrderLineItemData{get;set;}
    public String orderId;
    public Integer Total{get;set;}
    public Decimal TotalAmount{get;set;}
     public Default_Parameters__c defaultparam{get;set;}
   
    public GenerateInvoice(ApexPages.StandardController controller) 
    {   
        orderId = System.currentPageReference().getParameters().get('id');
        this.getdefaultparameter();
        this.getOrderData();
        this.getOrderLineItemData();
        this.getOrderAddress();
        this.getserviceAddress();
    }

    public pagereference getOrderData()
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'Id','Name','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.sigmaerpdev2__Product_Price__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Total_Amount__c','sigmaerpdev2__tax_amount__c','sigmaerpdev2__Total_Price__c','sigmaerpdev2__Order_Status__c','sigmaerpdev2__Sigma_Order__r.sigmaerpdev2__Orders_Status__c','sigmaerpdev2__Sigma_Order__r.sigmaerpdev2__Order_Number__c','sigmaerpdev2__Sigma_Order__r.sigmaerpdev2__AccountId__r.sigmaerpdev2__Email__c','sigmaerpdev2__Sigma_Order__r.sigmaerpdev2__AccountId__r.BillingAddress','sigmaerpdev2__Sigma_Order__r.sigmaerpdev2__AccountId__r.sigmaerpdev2__companystate__c','sigmaerpdev2__Sigma_Order__r.sigmaerpdev2__AccountId__r.Name','sigmaerpdev2__Sigma_Order__r.createddate','sigmaerpdev2__Sigma_Order__r.sigmaerpdev2__Tax_Amount__c','sigmaerpdev2__Sigma_Order__r.sigmaerpdev2__Payment__r.sigmaerpdev2__Tax_Amount__c','sigmaerpdev2__Sigma_Order__r.sigmaerpdev2__TotalAmount__c','sigmaerpdev2__Subtotal__c','sigmaerpdev2__Total_Rental_Days__c','sigmaerpdev2__Discounts__c','sigmaerpdev2__Amount_without_discount__c','sigmaerpdev2__Amount_Per_Interval__c', 'sigmaerpdev2__Billing_Interval__c','sigmaerpdev2__Sigma_Order__r.Id'})
        ){
        productOrderData = [SELECT Id,Name,Product__c,Product__r.Product_Price__c,Quantity__c,Net_Quantity__c,Product__r.Name,Total_Amount__c,tax_amount__c,Total_Price__c,Order_Status__c,Sigma_Order__r.Orders_Status__c,Sigma_Order__r.Order_Number__c,Sigma_Order__r.AccountId__r.Email__c,Sigma_Order__r.AccountId__r.BillingAddress,Sigma_Order__r.AccountId__r.companystate__c,Sigma_Order__r.AccountId__r.Name,Sigma_Order__r.createddate,Sigma_Order__r.Tax_Amount__c,Sigma_Order__r.Payment__r.Tax_Amount__c,Sigma_Order__r.TotalAmount__c,Subtotal__c,Total_Rental_Days__c,Discounts__c,Amount_without_discount__c,Amount_Per_Interval__c, Billing_Interval__c  FROM Product_Order_Price_Book__c WHERE Sigma_Order__r.Id = :orderId ];                                          
             Total =0;
            TotalAmount=0;
            for(Product_Order_Price_Book__c POD:productOrderData)
            {
                TotalAmount=TotalAmount+POD.Total_Price__c;
            }
       
        }
        return null;
    }
    public pagereference getOrderLineItemData()
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__OrderLineLocation__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__OrderLineLocation__c',new set<String>{'Id','Name','sigmaerpdev2__Location__r.Name','sigmaerpdev2__Location_Discount__c','sigmaerpdev2__Unit_Price__c'})
        ){
        OrderLineItemData = [SELECT Id,Name,sigmaerpdev2__Location__r.Name,sigmaerpdev2__Product__r.sigmaerpdev2__Active__c,sigmaerpdev2__Location_Discount__c,sigmaerpdev2__Unit_Price__c,sigmaerpdev2__Order_Line__r.sigmaerpdev2__Sigma_Order__r.sigmaerpdev2__Order_Created_Via__c from sigmaerpdev2__OrderLineLocation__c where sigmaerpdev2__Order_Line__r.sigmaerpdev2__Sigma_Order__r.sigmaerpdev2__Order_Created_Via__c='Time Based Inventory' and sigmaerpdev2__Order_Line__r.sigmaerpdev2__Sigma_Order__r.Id=:orderId];                                          
             system.debug('OrderLineItemData>>>'+OrderLineItemData);
        }
        return null;
    }
    
     public Default_Parameters__c getdefaultparameter()
    {
       if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Default_Parameters__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Default_Parameters__c',new set<String>{'sigmaerpdev2__Company_Name__c','sigmaerpdev2__Company_Email__c','sigmaerpdev2__Company_Phone__c','sigmaerpdev2__Logo__c'})
        ){ 
        defaultparam = [SELECT Company_Name__c,Company_Email__c,Company_Phone__c,Logo__c from Default_Parameters__c Limit 1];
        }
        return defaultparam;
    }
    
    public List<Sigma_Order__c> getOrderAddress()
    {
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new set<String>{'Id','Name','sigmaerpdev2__Due_Amount__c','sigmaerpdev2__Orders_Status__c','sigmaerpdev2__TotalProductPrice__c','sigmaerpdev2__Tax__c','sigmaerpdev2__Discount_New__c','sigmaerpdev2__Total_Amount_With_Tax__c','sigmaerpdev2__Total_Order_Tax__c','sigmaerpdev2__Discount__c','sigmaerpdev2__Order_Created_Via__c','sigmaerpdev2__Delivary_Date__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Net_Amount__c','sigmaerpdev2__Discount_Amount__c','sigmaerpdev2__TotalAmount__c','sigmaerpdev2__Discount_Code__c','sigmaerpdev2__Shipment_Amount__c','sigmaerpdev2__Tax_Amount__c','sigmaerpdev2__AccountId__r.sigmaerpdev2__Email__c','sigmaerpdev2__AccountId__r.BillingAddress','sigmaerpdev2__AccountId__r.BillingCountry','sigmaerpdev2__AccountId__r.BillingState','sigmaerpdev2__AccountId__r.BillingCity','sigmaerpdev2__AccountId__r.BillingStreet','sigmaerpdev2__AccountId__r.sigmaerpdev2__companystate__c','sigmaerpdev2__AccountId__r.Name','createddate','sigmaerpdev2__AccountId__r.sigmaerpdev2__Zip__c','sigmaerpdev2__AccountId__r.sigmaerpdev2__Country__c','sigmaerpdev2__AccountId__r.sigmaerpdev2__State__c','sigmaerpdev2__AccountId__r.sigmaerpdev2__City__c','sigmaerpdev2__AccountId__r.sigmaerpdev2__Address__c'})
        ){*/
        orderData = [SELECT Id,Name,AccountId__c,Orders_Status__c,Due_Amount__c,TotalProductPrice__c,Tax__c,Discount_New__c,Discount__c,Order_Created_Via__c,Delivary_Date__c,Quantity__c,Net_Amount__c,Discount_Amount__c,TotalAmount__c,Total_Amount_With_Tax__c,Total_Order_Tax__c,Discount_Code__c,Shipment_Amount__c,Tax_Amount__c,AccountId__r.Email__c,AccountId__r.BillingAddress,AccountId__r.BillingCountry,AccountId__r.BillingState,AccountId__r.BillingCity,AccountId__r.BillingStreet,AccountId__r.companystate__c,AccountId__r.Name,createddate,Shipping_Street__c,ShippingCity__c,ShippingCountry__c,ShippingState__c,ShippingPostalCode__c FROM Sigma_Order__c WHERE Id = :orderId];
        //}
        return orderData;
       
    }
    public List<Work_Order__c> getserviceAddress()
    {
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new set<String>{'Id','Name','sigmaerpdev2__Due_Amount__c','sigmaerpdev2__Orders_Status__c','sigmaerpdev2__TotalProductPrice__c','sigmaerpdev2__Tax__c','sigmaerpdev2__Discount_New__c','sigmaerpdev2__Discount__c','sigmaerpdev2__Order_Created_Via__c','sigmaerpdev2__Delivary_Date__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Net_Amount__c','sigmaerpdev2__Discount_Amount__c','sigmaerpdev2__TotalAmount__c','sigmaerpdev2__Discount_Code__c','sigmaerpdev2__Shipment_Amount__c','sigmaerpdev2__Tax_Amount__c','sigmaerpdev2__AccountId__r.sigmaerpdev2__Email__c','sigmaerpdev2__AccountId__r.BillingAddress','sigmaerpdev2__AccountId__r.BillingCountry','sigmaerpdev2__AccountId__r.BillingState','sigmaerpdev2__AccountId__r.BillingCity','sigmaerpdev2__AccountId__r.BillingStreet','sigmaerpdev2__AccountId__r.sigmaerpdev2__companystate__c','sigmaerpdev2__AccountId__r.Name','createddate','sigmaerpdev2__AccountId__r.sigmaerpdev2__Zip__c','sigmaerpdev2__AccountId__r.sigmaerpdev2__Country__c','sigmaerpdev2__AccountId__r.sigmaerpdev2__State__c','sigmaerpdev2__AccountId__r.sigmaerpdev2__City__c','sigmaerpdev2__AccountId__r.sigmaerpdev2__Address__c'})
        ){*/
        service = [SELECT Service_City__c,Service_Street__c,Service_Country__c,Service_Zip_Postal_Code__c,Service_State_Province__c from Work_Order__c];
        //}
        return service;
       
    }
    
    webservice static boolean sendInvoiceMail(String orderId)
    {
        document doc = new document();
        Sigma_Order__c orderExt;
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

        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
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
        else
        {
            return true;   
        }
    
    }
    
    public Static boolean checkAccessPermissionsOrder()
    {
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new Set<String>{'Id','Name','sigmaerpdev2__Orders_Status__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Net_Amount__c','sigmaerpdev2__Discount_Amount__c','sigmaerpdev2__Discount_Code__c','sigmaerpdev2__Shipment_Amount__c','sigmaerpdev2__Tax_Amount__c','sigmaerpdev2__TotalAmount__c','sigmaerpdev2__AccountId__r.sigmaerpdev2__Email__c','sigmaerpdev2__AccountId__r.BillingAddress','sigmaerpdev2__AccountId__r.BillingCountry','sigmaerpdev2__AccountId__r.BillingState','sigmaerpdev2__AccountId__r.BillingCity','sigmaerpdev2__AccountId__r.BillingStreet','sigmaerpdev2__AccountId__r.sigmaerpdev2__companystate__c','sigmaerpdev2__AccountId__r.Name','createddate'}))
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