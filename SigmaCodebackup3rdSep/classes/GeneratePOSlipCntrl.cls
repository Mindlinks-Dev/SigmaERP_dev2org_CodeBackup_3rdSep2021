global with sharing class GeneratePOSlipCntrl
{
    public String POId ;
    public  List<Purchase_Order__c> PurchaseOrderData {get;set;}
    public  List<Purchase_Order_Product__c> POData{get;set;}
     
    public GeneratePOSlipCntrl(ApexPages.StandardController controller) 
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order__c',new set<String>{'Id','sigmaerpdev2__Product_Supplier__r.Name','sigmaerpdev2__Product_Supplier__r.Type','sigmaerpdev2__Product_Supplier__r.Phone','sigmaerpdev2__Product_Supplier__r.sigmaerpdev2__Email__c','sigmaerpdev2__Status__c','sigmaerpdev2__Product_Supplier__r.sigmaerpdev2__Country__c','sigmaerpdev2__Product_Supplier__r.sigmaerpdev2__State__c','sigmaerpdev2__Product_Supplier__r.sigmaerpdev2__City__c','sigmaerpdev2__Product_Supplier__r.sigmaerpdev2__Zip__c'})
        ){
        POId = System.currentPageReference().getParameters().get('id');

        if(checkAccessPermissionsPurchaseOrder() == true)
        {
            PurchaseOrderData = [SELECT Id,Product_Supplier__r.Name,Product_Supplier__r.Type,Product_Supplier__r.Phone,Product_Supplier__r.Email__c,Status__c,Product_Supplier__r.Country__c,Product_Supplier__r.State__c,Product_Supplier__r.City__c,Product_Supplier__r.Zip__c from Purchase_Order__c  WHERE Id = :POId ];
        }
        this.getProductData();
        }
    }

    public List<Purchase_Order_Product__c> getProductData()
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order_Product__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order_Product__c',new set<String>{'Id','sigmaerpdev2__Status__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Purchase_Order_Product__c.Name','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Expected_Delivery_Date__c','sigmaerpdev2__Delivered_Date__c','sigmaerpdev2__Returned_Date__c','sigmaerpdev2__Price__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Purchase_Order__r.sigmaerpdev2__Expected_Date__c'})
        ){
        if(checkAccessPermissionsPurchaseOrderProduct() == true)
        {
            POData= [SELECT Id,Status__c,Quantity__c,Purchase_Order_Product__c.Name,Product__r.Name,Expected_Delivery_Date__c,Delivered_Date__c,Returned_Date__c,Price__c,Unit_Price__c,Purchase_Order__r.Expected_Date__c from Purchase_Order_Product__c WHERE Purchase_Order__r.Id = :POId ];
        }
        }       
        return POData;
    }
    webservice static boolean sendPOInvoiceMail(String POID)
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Default_Parameters__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('document')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order__c',new set<String>{'Id','sigmaerpdev2__Product_Supplier__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Default_Parameters__c',new set<String>{'Id','sigmaerpdev2__Invoice_Doc_Id__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('document',new set<String>{'id','name'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order__c',new set<String>{'Id','sigmaerpdev2__Product_Supplier__r.Name','sigmaerpdev2__Product_Supplier__r.Type','sigmaerpdev2__Product_Supplier__r.Phone','sigmaerpdev2__Product_Supplier__r.sigmaerpdev2__Email__c','sigmaerpdev2__Status__c','sigmaerpdev2__Product_Supplier__r.sigmaerpdev2__Country__c','sigmaerpdev2__Product_Supplier__r.sigmaerpdev2__State__c','sigmaerpdev2__Product_Supplier__r.sigmaerpdev2__City__c','sigmaerpdev2__Product_Supplier__r.sigmaerpdev2__Zip__c'})
        && CRUD_FLS_CheckUtility.checkFLS('document',new set<String>{'Body','name','FolderId'})
        ){
        document doc = new document();

        Purchase_Order__c PO ;
        if(checkAccessPermissionsPurchaseOrder() == true)
        {
            PO = [SELECT Id, Product_Supplier__c from Purchase_Order__c where id=:POID limit 1];
        }   
        PageReference pdf = Page.GeneratePOSlip;
        pdf.getParameters().put('id',POID);

        Blob body;

        try {
            body = pdf.getContent();
        } 
        catch (VisualforceException e) 
        {
            body = Blob.valueOf('Some Text');
        }

        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        Default_Parameters__c DefParam;
        if(checkAccessPermissionsDefaultParameters())
        {
            DefParam = [select Id,Invoice_Doc_Id__c from Default_Parameters__c Limit 1];
        }

        attach.setContentType('application/pdf');
        attach.setFileName('Purchase Order Invoice.pdf');
        attach.setInline(false);
        attach.Body = body;
        doc.Body = body;
        doc.name='Invoice'+POID+'.pdf';
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
        Purchase_Order__c DataPO;
        if(checkAccessPermissionsPurchaseOrder() == true)
        {
            DataPO = [SELECT Id,Product_Supplier__r.Name,Product_Supplier__r.Type,Product_Supplier__r.Phone,Product_Supplier__r.Email__c,Status__c,Product_Supplier__r.Country__c,Product_Supplier__r.State__c,Product_Supplier__r.City__c,Product_Supplier__r.Zip__c from Purchase_Order__c  WHERE Id = :POId ];
        }
        String emailID = DataPO.Product_Supplier__r.Email__c;

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setToAddresses(new String[] {emailID});
        mail.setSubject('PDF Email Demo');
        mail.setHtmlBody('Please find the attached PO invoice!!');
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
        return true;
    }
    
    public Static boolean checkAccessPermissionsPurchaseOrder()
    {
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order__c',new Set<String>{'Id','sigmaerpdev2__Product_Supplier__c','sigmaerpdev2__Product_Supplier__r.Name','sigmaerpdev2__Product_Supplier__r.Type','sigmaerpdev2__Product_Supplier__r.Phone','sigmaerpdev2__Product_Supplier__r.sigmaerpdev2__Email__c','sigmaerpdev2__Status__c','sigmaerpdev2__Product_Supplier__r.sigmaerpdev2__Country__c','sigmaerpdev2__Product_Supplier__r.sigmaerpdev2__State__c','sigmaerpdev2__Product_Supplier__r.sigmaerpdev2__City__c','sigmaerpdev2__Product_Supplier__r.sigmaerpdev2__Zip__c','sigmaerpdev2__Product_Supplier__c'}))
        {                                                                                       
            return true;
        }  
        return false;
    }

    public Static boolean checkAccessPermissionsPurchaseOrderProduct()
    {
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order_Product__c',new Set<String>{'Id','sigmaerpdev2__Status__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Purchase_Order_Product__c.Name','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Expected_Delivery_Date__c','sigmaerpdev2__Delivered_Date__c','sigmaerpdev2__Returned_Date__c','sigmaerpdev2__Price__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Purchase_Order__r.sigmaerpdev2__Expected_Date__c','sigmaerpdev2__Purchase_Order__r.Id'}))
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
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Default_Parameters__c',new Set<String>{'sigmaerpdev2__Invoice_Doc_Id__c'}))
        {
            return true;
        } 
        return false;
    }

}