/*=====================================================================================================
Author     : Harish Naik
Company    : Mindlinks Solution Pvt Ltd.
Date       : 05 jan 2019
Description: Sigma Order controller class
=======================================================================================================*/

public Without Sharing class SigmaorderCtrlWithTax {
    @AuraEnabled
    public static Account fetchAddress(String customer)
    {    
        Account acc;
        
       /*if(CRUD_FLS_CheckUtility.checkObjCRUD('Account')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Dimension_Tag__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('Account',new Set<String>{'Id','Name','ShippingStreet','ShippingCity','ShippingState','ShippingPostalcode','ShippingCountry','sigmaerpdev__Customer_Type__c','sigmaerpdev__Exchange_Currency__c','sigmaerpdev__Exchange_Currency__r.name','sigmaerpdev__Exchange_Currency__r.sigmaerpdev__Display_Name__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Dimension_Tag__c',new Set<String>{'Id','sigmaerpdev__Base_Credit_Limit__c','sigmaerpdev__Remaining_Credit_Limit__c','sigmaerpdev__Account__c'}))
        { */
            //acc = [ SELECT ShippingStreet,ShippingCity,ShippingState,ShippingPostalcode,ShippingCountry,Customer_Type__c,Exchange_Currency__c,Exchange_Currency__r.name,Exchange_Currency__r.Display_Name__c,(select Id,Base_Credit_Limit__c,Remaining_Credit_Limit__c from Dimension_Tags__r where Account__c =:customer limit 1),(Select Address__c,City__c,Country__c,State__c,Zip__c from Shipment_Details__r where Default_Address__c = true limit 1) from Account WHERE id =: customer];
        //edited by Krishna Pujara to populate Default Contact on 11-06-2021
        acc = [ SELECT ShippingStreet,ShippingCity,ShippingState,ShippingPostalcode,ShippingCountry,Customer_Type__c,Exchange_Currency__c,Exchange_Currency__r.name,Exchange_Currency__r.Display_Name__c,(select id,Name from Contacts where AccountId=:customer),(select Id,Base_Credit_Limit__c,Remaining_Credit_Limit__c from Dimension_Tags__r where Account__c =:customer limit 1),(Select Address__c,City__c,Country__c,State__c,Zip__c from Shipment_Details__r where Default_Address__c = true limit 1) from Account WHERE id =: customer];
       //ends here
        // }
        
        return acc;
    } 
    @AuraEnabled
    public static Order_Usage__c fetchDefualtConfig()
    {
        Order_Usage__c AllocationSO;
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new Set<String>{'sigmaerpdev__Allocation_in_Sales_Order__c'}))
        {*/
            AllocationSO = [select Allocation_in_Sales_Order__c from Order_Usage__c Limit 1];
        //}
        return AllocationSO;
    }
    @AuraEnabled
    public static Default_Parameters__c fetchallocation()
    {
        Default_Parameters__c fetchdefault;
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new Set<String>{'sigmaerpdev__Inventory_Status__c','sigmaerpdev__Auto_Reserve_Stock__c'}))
        {*/
            fetchdefault = [select Inventory_Status__c,Auto_Reserve_Stock__c from Default_Parameters__c Limit 1];
        //}
        return fetchdefault;
    }
   //code added to fetch product image data 13-05
     @AuraEnabled
    public static ContentDocumentLink getproductimage(Id prodId)
    {
        ContentDocumentLink productimagecontent = [SELECT Id, ContentDocumentId,ContentDocument.FileExtension, ContentDocument.LatestPublishedVersionId,ContentDocument.LatestPublishedVersion.Title,SystemModstamp,LinkedEntityId,Visibility,ShareType FROM ContentDocumentLink WHERE LinkedEntityId =: prodId and ContentDocument.FileExtension IN ('jpg','png') order by SystemModstamp DESC limit 1];
        
        return productimagecontent;
    }
    public class AccountRelatedData
    {
        @AuraEnabled
        public Account acc;
        @AuraEnabled
        public Dimension_Tag__c dimensionTag;
        @AuraEnabled
        public Decimal taxRate=0;
        @AuraEnabled
        public String paymentTermsId;
        @AuraEnabled
        public String paymentTermsName;
        @AuraEnabled
        public String salesPersonId;
        @AuraEnabled
        public String salesPersonName; 
    }
    
    @AuraEnabled
    public static AccountRelatedData fetchAccountRelatedDataWrap(Id accId)
    { 
        AccountRelatedData ard=new AccountRelatedData();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('Account')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Dimension_Tag__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('Account',new Set<String>{'id','Name','sigmaerpdev__Customer_Type__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Dimension_Tag__c',new Set<String>{'id','sigmaerpdev__Due_Amount__c','Name','sigmaerpdev__Stopped_Orders__c','sigmaerpdev__Base_Credit_Limit__c'}))
        {*/
            Account acc=[select id,name,Customer_Type__c,sigmaerpdev2__Tax_Treatment__c,sigmaerpdev2__Tax_Treatment__r.Name,(select id,Due_Amount__c,name,Stopped_Orders__c,Base_Credit_Limit__c from Dimension_Tags__r) from Account where id=:accId];
            ard.acc=acc;
        System.debug('acc.Dimension_Tags__r'+acc.Dimension_Tags__r);
            ard.dimensionTag=acc.Dimension_Tags__r;
        //}
        return ard;
        
    }
    @AuraEnabled
    public static Product2 getProdRelData(Id prodId,Id customerId)
    {
        Product2 prodRelList=new Product2();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'id','name','sigmaerpdev__Product_Price__c','sigmaerpdev__Max_Discount__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new Set<String>{'id','sigmaerpdev__Available_Qty__c'}))
        {*/
            Default_Parameters__c Dp = Default_Parameters__c.getInstance('Elift Merchant');
            string priceBook = Dp.priceBook_for_orders__c;
            prodRelList=[select id,name,Max_Discount__c,Stock_Item__c,Warranty_Applicable__c,Warranty_Duration__c,Warranty_Interval__c,Service_Warranty_Applicable__c,Service_Warranty_Duration__c,Service_Warranty_Interval__c,(select id,Available_Qty__c from Product_Inventory__r Limit 1),(Select Discout__c from Product_Prices__r where Customer__c =:customerId),(select id,UnitPrice,Pricebook2Id,Product2Id,ProductCode from PricebookEntries where product2id =: prodId AND Pricebook2Id =: priceBook) from Product2 where id=:prodId];
        //}
        return prodRelList;
    }
    @AuraEnabled
    public static List<Inventory_Location_Product_Line_Item__c> fetchILPLIDataForManualSelection(Id prodID)
    {
        List<Inventory_Location_Product_Line_Item__c> fetchinventory = new List<Inventory_Location_Product_Line_Item__c>(); 
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'id','name','sigmaerpdev__Available_Quantity__c','sigmaerpdev__Lot__c','sigmaerpdev__Lot__r.Name','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Serial_Number__c','sigmaerpdev__Received_Date__c','sigmaerpdev__Product_Expiry_Date__c','sigmaerpdev__Product_Received_date__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.name','sigmaerpdev__Bin__c','sigmaerpdev__Bin__r.name','sigmaerpdev__Product__c'}))
        { */   
            fetchinventory=[Select id,name,Available_Quantity__c,Lot__c,Lot__r.Name,Product_Serial_Number__r.Serial_Number__c,Received_Date__c,Inventory_Location_Product__r.Inventory_Location__r.Location__r.name,Bin__c,Bin__r.name from Inventory_Location_Product_Line_Item__c where Product__c=:prodID and Available_Quantity__c>0 ORDER BY Product_Expiry_Date__c ASC NULLS LAST,Product_Received_date__c ASC NULLS LAST];
        //}
        return fetchinventory;       
    }
    @AuraEnabled
    public static void deleteIndividualOrderLines(List<Product_Order_Price_Book__c> SigmaOrderLines) 
    {
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Invoice_Item__c')
          && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Invoice_Item__c',new Set<String>{'id','Name','sigmaerpdev__SOI__c'}))
        {*/
            Set<Id>orderlineid = new Set<Id>();
            for(Product_Order_Price_Book__c orderline :SigmaOrderLines)
            {
                orderlineid.add(orderline.id);
            }
            List<Invoice_Item__c> invoiceitem = [Select id,name,SOI__c from Invoice_Item__c where SOI__c =:orderlineid];
            
            if(invoiceitem.size()>0)
            {
                delete invoiceitem;
            }
            
            if(SigmaOrderLines.size()>0)
            {
                delete SigmaOrderLines;
            }
            
            //code to delete invoice line item after orderline delete
            
        //}
    }
    @auraEnabled
    public static responseWrap saveSigmaOrder(String so,String sol,boolean autostock,boolean soupdate)
    {
        system.debug('soupdate@@'+soupdate);
        Savepoint sp;
     //   responseWrap rw = new responseWrap();
        /*
if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('Account')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Currency__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Currency_Exchange_Rate__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Tax__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Serial_Number__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Lot_Product__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Dimension_Tag__c')  
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Linkage_Item__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Linkage__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Invoice__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Invoice_Item__c')
       
           && CRUD_FLS_CheckUtility.checkFLS('Account',new Set<String>{'ShippingStreet','ShippingCity','ShippingState','ShippingPostalcode','ShippingCountry'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Invoice_Item__c',new Set<String>{'sigmaerpdev__Quantity__c','sigmaerpdev__Total_Amount__c','sigmaerpdev__Product__c','sigmaerpdev__Net_Amount__c','sigmaerpdev__Discount__c','sigmaerpdev__SOI__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Invoice__c',new Set<String>{'sigmaerpdev__Invoice_Status__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sigma_Order__c',new Set<String>{'sigmaerpdev__Auto_Allocate__c','sigmaerpdev__BillingPersonNew__c','sigmaerpdev__Shipping_Street__c','sigmaerpdev__ShippingCity__c','sigmaerpdev__ShippingState__c','sigmaerpdev__ShippingCountry__c','sigmaerpdev__ShippingPostalCode__c','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Net_Amount__c','sigmaerpdev__Tax__c','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__TotalAmount__c','sigmaerpdev__Exchange_Net_Amount__c','sigmaerpdev__No_Picking_Package_Shipment_Required__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Customer_Type__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__Customer_Email__c','sigmaerpdev__BillingStreet__c','sigmaerpdev__BillingCity__c','sigmaerpdev__BillingState__c','sigmaerpdev__BillingPostalCode__c','sigmaerpdev__BillingCountry__c','sigmaerpdev__Customer_Email__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev__Quantity__c','sigmaerpdev__IsInventoryUpdated__c','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Total_Price__c','sigmaerpdev__Inventory_Status__c','sigmaerpdev__Remaining_Qty_To_Package__c','sigmaerpdev__Product__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Stock_Fulfilled__c','sigmaerpdev__Back_Order__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Allocation__c',new Set<String>{'sigmaerpdev__ILPLI__c','sigmaerpdev__Order_Line__c','sigmaerpdev__Quantity__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'sigmaerpdev__Status__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev__Deliver_Quantity__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Lot_Product__c',new Set<String>{'sigmaerpdev__Quantity__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'sigmaerpdev__Reserved_Quantity__c','sigmaerpdev__Delivered_Quantity__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Dimension_Tag__c',new Set<String>{'sigmaerpdev__Ordered_Amount__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new Set<String>{'sigmaerpdev__Delivered_Qty__c','sigmaerpdev__Available_Qty__c','sigmaerpdev__Comments__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sigma_Linkage__c',new Set<String>{'sigmaerpdev__Delivered_Quantity__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sigma_Linkage_Item__c',new Set<String>{'sigmaerpdev__Activity_Date_Time__c','sigmaerpdev__Order_Line__c','sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Sales_Unit_Price__c','sigmaerpdev__Total_Sales_Value__c','sigmaerpdev__Inventory_Location_Product_Line_Item__c','sigmaerpdev__Type__c'})
               
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Invoice__c',new Set<String>{'id','name','sigmaerpdev__SO__c','sigmaerpdev__Invoice_Type__c','sigmaerpdev__Customer__c','sigmaerpdev__Invoice_Status__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Invoice_Item__c',new Set<String>{'id','name','sigmaerpdev__Invoice_Number__c','sigmaerpdev__SOI__c','sigmaerpdev__Quantity__c','sigmaerpdev__Total_Amount__c','sigmaerpdev__Product__c','sigmaerpdev__Net_Amount__c','sigmaerpdev__Discount__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new Set<String>{'id','sigmaerpdev__Currency__c','name','sigmaerpdev__TotalAmount__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Currency__c',new Set<String>{'id','sigmaerpdev__Symbol__c','sigmaerpdev__Currency_Code__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Currency_Exchange_Rate__c',new Set<String>{'id','sigmaerpdev__Rate__c','sigmaerpdev__Currency__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new Set<String>{'sigmaerpdev__Inventory_Status__c','sigmaerpdev__Auto_Reserve_Stock__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Tax__c',new Set<String>{'sigmaerpdev__Tax_Amount__c','sigmaerpdev__Type__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new Set<String>{'id','name','sigmaerpdev__Delivered_Qty__c','sigmaerpdev__ProductCode__c','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__Available_Qty__c','sigmaerpdev__Comments__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'id','name','sigmaerpdev__Available_Quantity__c','sigmaerpdev__Reserved_Quantity__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Products__c','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Serial_Number__c','sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Status__c','sigmaerpdev__Received_Date__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.name','sigmaerpdev__Lot__c','sigmaerpdev__Lot__r.Name','sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__Product_Expiry_Date__c','sigmaerpdev__Product_Received_date__c','sigmaerpdev__Delivered_Quantity__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'id','name','sigmaerpdev__Status__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'id','name','sigmaerpdev__Deliver_Quantity__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Lot_Product__c',new Set<String>{'id','sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Location__c','sigmaerpdev__Lot__c','sigmaerpdev__Bin__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Dimension_Tag__c',new Set<String>{'id','sigmaerpdev__Ordered_Amount__c','sigmaerpdev__Account__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('Account',new Set<String>{'ShippingStreet','ShippingCity','ShippingState','ShippingPostalcode','ShippingCountry','sigmaerpdev__Email__c','sigmaerpdev__Address__c','sigmaerpdev__City__c','sigmaerpdev__State__c','sigmaerpdev__Country__c','sigmaerpdev__Zip__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Linkage_Item__c',new Set<String>{'Id', 'sigmaerpdev__Sigma_Linkage__c', 'sigmaerpdev__Inventory_Location_Product_Line_Item__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Linkage__c',new Set<String>{'Id', 'name', 'sigmaerpdev__SRP__c', 'sigmaerpdev__ILP__c', 'sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Delivered_Quantity__c', 'sigmaerpdev__Stock_Origin__c'})
           
           && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev__Sigma_Order__c'})
           && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Sigma_Order__c',new Set<String>{'sigmaerpdev__AccountId__c'})
           && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Sigma_Linkage_Item__c',new Set<String>{'sigmaerpdev__Sigma_Linkage__c'})
          && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Invoice_Item__c',new Set<String>{'sigmaerpdev__Invoice_Number__c'})
        )
        {*/
            try{
                Boolean insertaddress = true;
                sp = Database.setSavepoint();
                Sigma_Order__c soDataToSave=(Sigma_Order__c)System.JSON.deserialize(so,Sigma_Order__c.class);
                Double TaxOnBillAmount = 0;
                soDataToSave.Auto_Allocate__c = autostock; 
                if(soDataToSave.BillingPersonNew__c!=null)
                {
                    
                    soDataToSave.Billing_Person__c=[select name from contact where id=:soDataToSave.BillingPersonNew__c].name;
                }
                if(soDataToSave.Order_Created_Via__c !='Work Order'){
                    upsert soDataToSave;
                }
                  
                //to add order shipment details to customer
                Account acc = [SELECT Id,Name,Email__c,Address__c,City__c,State__c,Country__c,Zip__c,(Select Address__c,City__c,Country__c,State__c,Zip__c from Shipment_Details__r) from account where id =:soDataToSave.AccountId__c];
                
                if(acc.Shipment_Details__r.size()>0)
                {
                    for(Shipment_Detail__c ShipDetails: acc.Shipment_Details__r)
                    {
                        if(ShipDetails.Address__c == soDataToSave.Shipping_Street__c && ShipDetails.City__c == soDataToSave.ShippingCity__c && ShipDetails.Country__c == soDataToSave.ShippingCountry__c &&  ShipDetails.State__c == soDataToSave.ShippingState__c && ShipDetails.Zip__c == soDataToSave.ShippingPostalCode__c)
                        {
                            insertaddress = false;
                            
                        }
                    
                    }
                }
                
                if(insertaddress && soDataToSave.Shipping_Street__c!=null )
                {
                    Shipment_Detail__c shipinsert = new Shipment_Detail__c();
                    shipinsert.Address__c = soDataToSave.Shipping_Street__c;
                    shipinsert.City__c = soDataToSave.ShippingCity__c;
                    shipinsert.Country__c = soDataToSave.ShippingCountry__c;
                    shipinsert.State__c = soDataToSave.ShippingState__c;
                    shipinsert.Zip__c = soDataToSave.ShippingPostalCode__c;
                    shipinsert.Account__c = soDataToSave.AccountId__c;
                    if(acc.Shipment_Details__r.size() == 0)
                    shipinsert.Default_Address__c = true;
                    insert shipinsert;
                }
                
                
                //update  billing address in sigmaorder
                if(acc.Address__c !=null)
                    soDataToSave.BillingStreet__c =  acc.Address__c; 
                if(acc.City__c !=null)
                    soDataToSave.BillingCity__c = acc.City__c;
                if(acc.State__c !=null)
                    soDataToSave.BillingState__c = acc.State__c;
                if(acc.Zip__c !=null)
                    soDataToSave.BillingPostalCode__c = acc.Zip__c;
                if(acc.Country__c !=null)
                    soDataToSave.BillingCountry__c = acc.Country__c; 
                if(acc.Email__c!=null)
                {
                    soDataToSave.Customer_Email__c=acc.Email__c;
                }
                 
                //update billing address ends
                //Currency
                Currency__c currSymbol = null;
                List<string> soString =new List<string>();   
                List<Sigma_Order__c > sOrder = [select id,Currency__c from Sigma_Order__c where Currency__c = :soDataToSave.Currency__c];
                for(Sigma_Order__c sList :sOrder){
                    if(sList.Currency__c !=null)
                        soString.add(sList.Currency__c);
                }
                if( soString != null && soString.size() != 0 ) 
                    currSymbol = [select id,Symbol__c,Currency_Code__c from Currency__c where Id =: soString limit 1];
                List<Currency_Exchange_Rate__c> currExRate = [select id,Rate__c,Currency__c from Currency_Exchange_Rate__c where Currency__c =: soString ];
                
                //End here
                Default_Parameters__c Inventory= [select Inventory_Status__c,Auto_Reserve_Stock__c from Default_Parameters__c limit 1 ];
                string inventorystatus = Inventory.Inventory_Status__c;
                //Sigma order Lines
                Set<Id>OrderlineIds = new Set<Id>();
                List<Product_Order_Price_Book__c> solList = new List<Product_Order_Price_Book__c  >();
                List<Product_Order_Price_Book__c> solListToMakeInventoryUpdate = new List<Product_Order_Price_Book__c>();
                List<SigmaOrderWrap> solDataToSave=(List<SigmaOrderWrap>)System.JSON.deserialize(sol,List<SigmaOrderWrap>.class);
                Map<Id,Boolean> prodIdIsStockItemMap=new Map<Id,Boolean>();
                decimal netQunt=0;
                decimal totalprice=0;
                decimal taxrate=0;
                decimal taxamount=0;
                for(SigmaOrderWrap sow:solDataToSave)
                {
                    OrderlineIds.add(sow.orderLines.Id);
                    if(sow.orderLines.Quantity__c!=null || sow.orderLines.Quantity__c!=0 && !sow.orderLines.IsInventoryUpdated__c)
                    {
                        netQunt+=sow.orderLines.Net_Quantity__c;
                        totalprice+=sow.orderLines.Total_Price__c;
                        taxrate+=sow.orderLines.Tax_Rate__c;
                      // taxrate=sow.orderLines.Tax_Rate__c;
                       taxamount+=sow.orderLines.tax_amount__c;
                    }
                    if(sow.orderLines.Sigma_Order__c==null)
                        sow.orderLines.Sigma_Order__c=soDataToSave.id;
                    if(inventorystatus == 'Reserve' && sow.orderLines.Inventory_Status__c!='Un Reserved')
                    {
                        sow.orderLines.Inventory_Status__c='Reserve';
                    }
                    else if(sow.orderLines.Inventory_Status__c!='Un Reserved')
                    {
                        sow.orderLines.Inventory_Status__c='Allocated';
                    }
                    if(sow.orderLines.Remaining_Qty_To_Package__c==null)
                    {
                        sow.orderLines.Remaining_Qty_To_Package__c=0;  
                    }
                    
                    if(!sow.orderLines.IsInventoryUpdated__c && inventorystatus == 'Reserve')
                        sow.orderLines.Remaining_Qty_To_Package__c=sow.orderLines.Net_Quantity__c;
                    //if(inventorystatus == 'Allocated')
                    // {
                    // sow.orderLines.Delivered_Quantity__c=sow.orderLines.Net_Quantity__c;
                    //  }
                    solList.add(sow.orderLines);
                    prodIdIsStockItemMap.put(sow.orderLines.Product__c,false);
                }
                soDataToSave.Net_Quantity__c=netQunt;
              // soDataToSave.Net_Amount__c=totalprice;
                if(soDataToSave.Discount__c==null){
                    soDataToSave.Net_Amount__c=totalprice;
               
                }
                else{
                  soDataToSave.Net_Amount__c=totalprice-(totalprice*soDataToSave.Discount__c/100);  
                }
               soDataToSave.Tax__c=taxrate;
               soDataToSave.Tax_Amount__c=taxamount;
                
                //Code for TAX
                List<Tax__c> taxObj = OrderTaxCntr.getTax(soDataToSave.id);
                Double federalTax = Double.valueOf(taxObj.get(0).Tax_Amount__c);
                String fedTaxType = String.valueOf(taxObj.get(0).Type__c);
                Double stateTax = Double.valueOf(taxObj.get(1).Tax_Amount__c);
                String stateTaxType = String.valueOf(taxObj.get(1).Type__c);
                
                if(fedTaxType == 'Percentage'){
                    TaxOnBillAmount = (soDataToSave.Net_Amount__c * federalTax)/100;
                }else{
                    TaxOnBillAmount = soDataToSave.Net_Amount__c + federalTax;
                }               
                if(stateTaxType == 'Percentage'){
                    TaxOnBillAmount = (TaxOnBillAmount + (soDataToSave.Net_Amount__c * stateTax)/100);
                }else{
                    TaxOnBillAmount = (TaxOnBillAmount + (soDataToSave.Net_Amount__c + stateTax));
                }        
                soDataToSave.Tax_Amount__c = TaxOnBillAmount;
                soDataToSave.Tax__c = federalTax+stateTax; 
                string symbol='';
                Double  amt=0;
                if(soDataToSave.Order_Created_Via__c !='Proposal'||soDataToSave.Order_Created_Via__c !='Work Order'){
                    soDataToSave.TotalAmount__c = soDataToSave.Net_Amount__c + TaxOnBillAmount;
                }
                    if(currSymbol!= null){
                    if(currExRate.size() > 0){
                        symbol =currSymbol.Symbol__c;
                        string rateEx = currExRate[0].Rate__c +'';
                        amt= Double.valueOf(rateEx)*soDataToSave.TotalAmount__c;
                        string currStr=symbol+' '+amt;
                        soDataToSave.Exchange_Net_Amount__c = currStr;
                    }
                }
                if(soDataToSave.Order_Created_Via__c == 'Opportunity')
                {
                    soDataToSave.Order_Created_Via__c = 'Opportunity';
                    
                }
                else if(soDataToSave.Order_Created_Via__c == 'Proposal')
                {
                    soDataToSave.Order_Created_Via__c = 'Proposal';
                }
                else if(soDataToSave.Order_Created_Via__c == 'Subscription')
                {
                    soDataToSave.Order_Created_Via__c = 'Subscription';
                }
                else if(soDataToSave.Order_Created_Via__c == 'Time Based Inventory')
                {
                    soDataToSave.Order_Created_Via__c = 'Time Based Inventory';
                }
                else if(soDataToSave.Order_Created_Via__c == 'Service Quote')
                {
                    soDataToSave.Order_Created_Via__c = 'Service Quote';
                } 
                else if(soDataToSave.Order_Created_Via__c == 'Community')
                {
                    soDataToSave.Order_Created_Via__c = 'Community';
                }
                else if(soDataToSave.Order_Created_Via__c == 'Work Order')
                {
                    soDataToSave.Order_Created_Via__c = 'Work Order';
                }
                else
                {
                    soDataToSave.Order_Created_Via__c = 'POS'; 
                }
                if(acc.Email__c !=null)
                {
                    soDataToSave.Customer_Email__c = acc.Email__c;
                    
                }
        
        //Code Added for FFTB Community to get community user account and insert into brewery account
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,Profile.Name,Contact.AccountId from User where Id =: UserId];
        Community_Configuration__c Custset= [select Id,Name,Retailer_Community_URL__c,Products_Per_Page__c,Retailer_Profile_Name__c,Vendor_Community_URL__c,Vendor_Profile_Name__c from Community_Configuration__c where Name = 'Community Configurations' LIMIT 1];
        if(currentuser.Profile.Name != Custset.Retailer_Profile_Name__c)
        {
          if(soDataToSave.Order_Created_Via__c !='Work Order'){
          upsert soDataToSave;
          }
        }
        else{
          soDataToSave.Brewer_Account__c = currentuser.Contact.AccountId;
          soDataToSave.Order_Created_Via__c = 'Community';
          upsert soDataToSave;
        }
        
        
                if(soDataToSave.Order_Created_Via__c !='Work Order'){
                upsert soDataToSave;
                }
                system.debug('soDataToSave??'+soDataToSave);
                upsert solList;
                system.debug('solList??'+solList);
                
                //code to Auto Allocate inventory in TBI flows
                system.debug('OrderlineIds@@'+OrderlineIds);
                List<Product_Order_Price_Book__c>orderlineitemdatas = new List<Product_Order_Price_Book__c>() ;
                List<Product_Order_Price_Book__c> sigmaorderLinesdata =[select id,Sigma_Order__r.Id,Splited_Order_Line__c,Stock_Fulfilled__c,Sigma_Order__r.Auto_Allocate__c,Order_Status__c,Product__c,Product__r.name,IsInventoryUpdated__c,Sigma_Order__r.Customer_Type__c,Sigma_Order__c,Sigma_Order__r.name,createddate,Sigma_Order__r.AccountId__r.name,Back_Order__c,Total_Price__c,Net_Quantity__c,Sigma_Order__r.No_Picking_Package_Shipment_Required__c from Product_Order_Price_Book__c where Id = :OrderlineIds];
                system.debug('sigmaorderLinesdata@@'+sigmaorderLinesdata);
                for(Product_Order_Price_Book__c orderline :sigmaorderLinesdata)
                {
                    if(!orderline.IsInventoryUpdated__c)
                    {
                        orderlineitemdatas.add(orderline);
                    }
                }
                system.debug('orderlineitemdatas@@'+orderlineitemdatas);
                Boolean Execute;
                if(orderlineitemdatas.size()>0)
                {
                    if(soDataToSave.Order_Created_Via__c == 'Time Based Inventory' && soDataToSave.Orders_Status__c == 'Order Confirmed')
                    {
                        system.debug('innn>>');
                        Execute = AllocateInventoryCntrl.AllocateInventoryforOrder(sigmaorderLinesdata);
                    }
                }
                
                if(soDataToSave !=null)
                {
                    OrderCountCntrl.SigmaOrderCount(soDataToSave);
                }
                //code ends
                
                Map<Id,Decimal> productQuantityMap=new Map<Id,Decimal>();
                Map<Id,Product_Order_Price_Book__c> prodIdSOLMap=new Map<Id,Product_Order_Price_Book__c>();
                List<Product_Order_Price_Book__c> solListToUpdateAsAllocated = new List<Product_Order_Price_Book__c>();
                Map<id,decimal> ILPLIIdQuantMap=new Map<Id,Decimal>();
                List<Inventory_Allocation__c> IAListToInsert=new List<Inventory_Allocation__c>();
                if(inventorystatus =='Reserve')
                {
                    if(soDataToSave.Orders_Status__c!='Pending') 
                    {
                        system.debug('inside status check');
                        for(Integer i=0;i<solDataToSave.size();i++)
                        {
                            
                            if((solDataToSave[i].orderLines.Order_Status__c =='Order Confirmed')&& solDataToSave[i].ilpliData!=null && !solDataToSave[i].orderLines.IsInventoryUpdated__c && solDataToSave[i].orderLines.Stock_Fulfilled__c)
                            {
                                
                                for(ILPLISaveWrap ilplisw:solDataToSave[i].ilpliData)
                                {
                                    if(ilplisw.enteredQuant!=null && ilplisw.enteredQuant!=0){
                                        if(ILPLIIdQuantMap.containskey(ilplisw.id))
                                            ILPLIIdQuantMap.put(ilplisw.id,ILPLIIdQuantMap.get(ilplisw.id)+ilplisw.enteredQuant);
                                        else
                                            ILPLIIdQuantMap.put(ilplisw.id,ilplisw.enteredQuant);
                                        Inventory_Allocation__c indIA=new Inventory_Allocation__c();
                                        indIA.ILPLI__c=ilplisw.id;
                                        indIA.Order_Line__c=solDataToSave[i].orderLines.id;
                                        indIA.Quantity__c=ilplisw.enteredQuant;
                                        IAListToInsert.add(indIA);
                                    }
                                }
                            }
                            if((solDataToSave[i].orderLines.Order_Status__c =='Order Confirmed') && !solDataToSave[i].orderLines.IsInventoryUpdated__c && solDataToSave[i].ilpliData!=null && solDataToSave[i].orderLines.Stock_Fulfilled__c)
                            {
                                
                                if(productQuantityMap.containsKey(solDataToSave[i].orderLines.Product__c))
                                {
                                    productQuantityMap.put(solDataToSave[i].orderLines.Product__c,(productQuantityMap.get(solDataToSave[i].orderLines.Product__c)+solDataToSave[i].orderLines.Net_Quantity__c));
                                }
                                else
                                {
                                    productQuantityMap.put(solDataToSave[i].orderLines.Product__c,solDataToSave[i].orderLines.Net_Quantity__c);
                                }
                                if(solDataToSave[i].orderLines.Net_Quantity__c >0)
                                    solDataToSave[i].orderLines.IsInventoryUpdated__c=true;
                                system.debug('Inventorystatus'+solDataToSave[i].orderLines.IsInventoryUpdated__c);
                                solListToUpdateAsAllocated.add(solDataToSave[i].orderLines);
                            }
                        }
                        if(solListToUpdateAsAllocated.size()>0){
                            upsert solListToUpdateAsAllocated;
                        }
                        system.debug('checkbox@@'+soDataToSave.No_Picking_Package_Shipment_Required__c);
                        Map<Id,Inventory__c> inventoryMap=new Map<Id,Inventory__c>([select id,name,Delivered_Qty__c,ProductCode__c,Reserved_Qty__c,Available_Qty__c,Comments__c from Inventory__c where ProductCode__c in:productQuantityMap.keySet()]);
                        if(productQuantityMap.size()>0)
                            InventoryManagement.reduceOnlyPIOrder(inventoryMap,productQuantityMap,soDataToSave.No_Picking_Package_Shipment_Required__c);
                        if(ILPLIIdQuantMap.values().size()>0){
                            InventoryManagement.reduceWholeInventory11(ILPLIIdQuantMap,'Reserved_Quantity',soDataToSave.No_Picking_Package_Shipment_Required__c);
                        }
                        if(IAListToInsert.size()>0){
                            Insert IAListToInsert;
                        }
                        
                        //code for Sigma Finance added by Mahantesh on April 21st 2020 related to when inventory status = "Allocated"
                        if(soDataToSave.No_Picking_Package_Shipment_Required__c && IAListToInsert.size()>0)
                        {
                            Set<Id> IlpliSet = new Set<Id>();    //stores ilpli id
                            Map<Id,Inventory_Allocation__c> IlpliNIaMap = new Map<Id,Inventory_Allocation__c>();    //stores inventory allocation list
                            Map<Id,Id> IlpliSlIdMap = new Map<Id,Id>();    //key => Ilpli id, value => stock Linkage record id
                            Map<Id,Id> IaSlIdMap = new Map<Id,Id>();    //key => inventory allocation id, value => stock Linkage record id
                            
                            if(IAListToInsert.size() > 0)
                            {
                                for(Inventory_Allocation__c ia : [select id,ILPLI__c,Order_Line__r.Net_Quantity__c,Order_Line__r.Total_Amount__c,Quantity__c,Order_Line__c,Order_Line__r.Total_Price__c,Order_Line__r.Product__c,Order_Line__r.Amount_Per_Interval__c,Order_Line__r.Product__r.Attribute_Type__c from Inventory_Allocation__c where Id =: IAListToInsert ])
                                {
                                    IlpliSet.add(ia.ILPLI__c);
                                    IlpliNIaMap.put(ia.Id,ia);
                                }
                            }
                            //to create a map of ilpli and respective sigma linkage
                            List<Sigma_Linkage_Item__c> sigmalinkage=new List<Sigma_Linkage_Item__c>();
                            sigmalinkage=[select Id, Sigma_Linkage__c, Inventory_Location_Product_Line_Item__c from Sigma_Linkage_Item__c where Inventory_Location_Product_Line_Item__c IN: IlpliSet];
                            
                            if(sigmalinkage.size() > 0)
                            {
                                for(Sigma_Linkage_Item__c slli:sigmalinkage)
                                {
                                    IlpliSlIdMap.put(slli.Inventory_Location_Product_Line_Item__c, slli.Sigma_Linkage__c);
                                }
                            }
                            //List<Sigma_Linkage__c> SLToUpdateList = new List<Sigma_Linkage__c>();    //List of SL to be updated   
                            List<Sigma_Linkage__c> slListToUpdate=new List<Sigma_Linkage__c>();
                            slListToUpdate=[select Id, name, SRP__c, ILP__c, Packaged_Quantity__c,Delivered_Quantity__c, Stock_Origin__c from Sigma_Linkage__c where Id IN: IlpliSlIdMap.values()];
                            System.debug('IlpliNIaMap>>'+IlpliNIaMap);
                            System.debug('IlpliSet>>'+IlpliSet);
                            System.debug('slListToUpdate>>'+slListToUpdate);
                            for(Id ia:IlpliNIaMap.keySet())
                            {
                                if(slListToUpdate.size() > 0)
                                {
                                    for(Sigma_Linkage__c sl:slListToUpdate)
                                    {
                                        if(sl.Id == IlpliSlIdMap.get( IlpliNIaMap.get(ia).ILPLI__c ))
                                        {
                                            sl.Delivered_Quantity__c = sl.Delivered_Quantity__c + IlpliNIaMap.get(ia).Quantity__c;
                                            IaSlIdMap.put(ia,sl.Id);
                                            //SLToUpdateMap.add(sl);
                                        }
                                    }
                                }
                            }
                            
                            if(IaSlIdMap.size() > 0)
                            {
                                List<Sigma_Linkage_Item__c> SLLIList = new List<Sigma_Linkage_Item__c>();   //to insert SLLI
                                for(Id ia:IlpliNIaMap.keySet())
                                {
                                    system.debug('rental amount::'+IlpliNIaMap.get(ia).Order_Line__r.Amount_Per_Interval__c);
                                    Sigma_Linkage_Item__c SLLI = new Sigma_Linkage_Item__c();
                                    SLLI.Activity_Date_Time__c = system.now();
                                    SLLI.Order_Line__c = IlpliNIaMap.get(ia).Order_Line__c;
                                    SLLI.Sigma_Linkage__c = IaSlIdMap.get(ia);
                                    SLLI.Product__c = IlpliNIaMap.get(ia).Order_Line__r.Product__c;
                                    SLLI.Quantity__c = IlpliNIaMap.get(ia).Quantity__c;             
                                    SLLI.Sales_Unit_Price__c = IlpliNIaMap.get(ia).Order_Line__r.Total_Amount__c;
                                    if(IlpliNIaMap.get(ia).Order_Line__r.Product__r.Attribute_Type__c == 'SERIALIZED')
                                    {
                                        SLLI.Total_Sales_Value__c = (IlpliNIaMap.get(ia).Order_Line__r.Total_Price__c/IlpliNIaMap.get(ia).Order_Line__r.Net_Quantity__c);
                                    }
                                    else
                                    {
                                        SLLI.Total_Sales_Value__c = IlpliNIaMap.get(ia).Order_Line__r.Total_Price__c;
                                    }
                                    SLLI.Inventory_Location_Product_Line_Item__c = IlpliNIaMap.get(ia).ILPLI__c;
                                    //SLLI.Shipment_Product__c = ShipPackMap.get( IlpliNIaMap.get(ia).Packaged_Product__r.Package__c );
                                    SLLI.Type__c = 'Shipment';
                                    SLLIList.add(SLLI);
                                }
                                System.debug('SLLIList:'+SLLIList);
                                try
                                {
                                    if(SLLIList.size() > 0)
                                    {
                                        insert SLLIList;
                                        
                                    }
                                    if(slListToUpdate.size() > 0)
                                    {
                                        update slListToUpdate;
                                    }
                                }
                                catch(Exception e)
                                {
                                    System.debug('Exception createSLFromILP LinkPPLI:'+e.getMessage());
                                }
                            }
                            
                        }
                    }
                }
                if(inventorystatus=='Allocated')
                {
                    Map<Id,Decimal> orderlinequnt = new map<Id,Decimal>();
                    //Adding to Inventory Allocation Object
                    if(soDataToSave.Orders_Status__c=='Order Confirmed')
                    {
                        for(Integer i=0;i<solDataToSave.size();i++)
                        {
                            if((solDataToSave[i].orderLines.Order_Status__c =='Order Confirmed') && !solDataToSave[i].orderLines.IsInventoryUpdated__c && solDataToSave[i].orderLines.Stock_Fulfilled__c)
                            { 
                                if(productQuantityMap.containsKey(solDataToSave[i].orderLines.Product__c))
                                {
                                    productQuantityMap.put(solDataToSave[i].orderLines.Product__c,(productQuantityMap.get(solDataToSave[i].orderLines.Product__c)+solDataToSave[i].orderLines.Net_Quantity__c));
                                }
                                else
                                {
                                    
                                    productQuantityMap.put(solDataToSave[i].orderLines.Product__c,solDataToSave[i].orderLines.Net_Quantity__c);
                                }
                                solListToUpdateAsAllocated.add(solDataToSave[i].orderLines);
                                prodIdSOLMap.put(solDataToSave[i].orderLines.Product__c,solDataToSave[i].orderLines);
                                orderlinequnt.put(solDataToSave[i].orderLines.id,solDataToSave[i].orderLines.Net_Quantity__c);
                                
                            }
                        }
                        
                        system.debug('orderlinequnt@@'+orderlinequnt);
                        Map<Id,Inventory__c> inventoryMap=new Map<Id,Inventory__c>([select id,name,ProductCode__c,Reserved_Qty__c,Available_Qty__c,Delivered_Qty__c from Inventory__c where ProductCode__c in:productQuantityMap.keySet()]);
                        Map<Id,Inventory__c> inventoryUpdateMap=new Map<Id,Inventory__c>();
                        for(Integer i=0; i< inventoryMap.values().size(); i++)
                        {
                            Inventory__c tempInv=inventoryMap.values()[i];
                            if(tempInv.Delivered_Qty__c==null)
                                tempInv.Delivered_Qty__c=0;
                            tempInv.Delivered_Qty__c+=productQuantityMap.get(inventoryMap.values()[i].ProductCode__c);
                            tempInv.Available_Qty__c-=productQuantityMap.get(inventoryMap.values()[i].ProductCode__c);
                            inventoryUpdateMap.put(inventoryMap.values()[i].id,tempInv);
                        }
                        if(inventoryUpdateMap.size()>0)
                        {
                            update inventoryUpdateMap.values();
                        }
                        system.debug('inventoryUpdateMap>>'+ inventoryUpdateMap.values());
                        
                        List<Inventory_Location_Product_Line_Item__c> ilpliDataRecieveData= [Select id,name,Available_Quantity__c,Reserved_Quantity__c,Inventory_Location__c,Inventory_Location_Product__r.Products__c,Product_Serial_Number__r.Serial_Number__c,Product_Serial_Number__c  ,Product_Serial_Number__r.Status__c,Received_Date__c,Inventory_Location_Product__r.Inventory_Location__r.Location__r.name,Lot__c,Lot__r.Name,Bin__c,Bin__r.Name,Inventory_Location_Product__c,bucket_field__c,Delivered_Quantity__c from Inventory_Location_Product_Line_Item__c where Inventory_Location_Product__r.Products__c=:productQuantityMap.keySet() and  Available_Quantity__c>0 ORDER BY Product_Expiry_Date__c ASC NULLS LAST,Product_Received_date__c ASC NULLS LAST ];
                        System.debug('ilpliDataRecieveData:::'+ilpliDataRecieveData);
                        Map<id,decimal> ILPLIIdQuantMap1 = new Map<id,decimal>();
                        Map<Id,Inventory_Location_Product_Line_Item__c> ilpliIdILPLIMapToUpdate1=new Map<Id,Inventory_Location_Product_Line_Item__c>();
                        Map<Id,decimal> ILPQuant= new Map<id,decimal>();
                        Map<Id,Map<Id,Decimal>>  LotqtymapLoc = new Map<Id,Map<Id,Decimal>>();// added by rashmi for Lot
                        Map<Id,decimal> LotQuant= new Map<id,decimal>();
                        List<ID> lotLoc=new List<ID>(); 
                        Map<Id,Id> maplotproforIL = new Map<Id,Id>();//added by rashmi to get IL from  LP
                        Map<Id,decimal> maplotproforBin = new Map<Id,decimal>();//added by rashmi to update Bin from LP
                        Map<id,Map<id,decimal>> lotqtyupdate=new Map<id,Map<id,decimal>>();
                        
                        decimal soldquant=0;
                        set<Id> Serialid =new set<Id>();
                        set<Id>LOTID = new set<Id>();
                        for(Integer i=0;i<solDataToSave.size();i++)
                        {
                            Decimal solQuantCount=solDataToSave[i].orderLines.Net_Quantity__c;
                            if((solDataToSave[i].orderLines.Order_Status__c=='Order Confirmed')&& !solDataToSave[i].orderLines.IsInventoryUpdated__c)
                            {
                                System.debug('ifffff');
                                for(Inventory_Location_Product_Line_Item__c ilpli:ilpliDataRecieveData)
                                {
                                    lotLoc.add(ilpli.Inventory_Location__c); //for LOT added by rashmi
                                    if(ILPLIIdQuantMap1.containsKey(ilpli.id) ? ILPLIIdQuantMap1.get(ilpli.id)!=ilpli.Available_Quantity__c :true)
                                    {
                                        system.debug('came in-->>'+ilpli.Inventory_Location_Product__r.Products__c);
                                        system.debug('came in-->>'+solDataToSave[i].orderLines.Product__c);
                                        if(solQuantCount==0)
                                            Break;
                                        if(ilpli.Inventory_Location_Product__r.Products__c==solDataToSave[i].orderLines.Product__c)
                                        {
                                            
                                            if(ilpli.Lot__c != null)
                                            {
                                                maplotproforIL.put(ilpli.Lot__c,ilpli.Inventory_Location__c);
                                                LOTID.add(ilpli.Lot__c);
                                            }
                                            system.debug('productQuantityMap:::'+productQuantityMap.get(solDataToSave[i].orderLines.Product__c));
                                            system.debug('check Lot__c'+LotqtymapLoc.containsKey(ilpli.Lot__c));
                                            if(LotqtymapLoc.containsKey(ilpli.Lot__c)){
                                                system.debug('check Lot__c and Inventory_Location__c'+LotqtymapLoc.get(ilpli.Lot__c).containskey(ilpli.Inventory_Location__c));
                                                if(LotqtymapLoc.get(ilpli.Lot__c).containskey(ilpli.Inventory_Location__c)){
                                                    
                                                    decimal oldval = LotqtymapLoc.get(ilpli.Lot__c).get(ilpli.Inventory_Location__c);
                                                    decimal newval = oldval + ilpli.bucket_field__c;
                                                    system.debug('oldval>>>'+oldval);
                                                    system.debug('newval>>>'+newval);
                                                    
                                                    LotqtymapLoc.get(ilpli.Lot__c).put(ilpli.Inventory_Location__c,newval);
                                                    system.debug('LotqtymapLoc aftr puting il and qty--->>>'+LotqtymapLoc);
                                                }
                                                else{
                                                    LotqtymapLoc.get(ilpli.Lot__c).put(ilpli.Inventory_Location__c,ilpli.bucket_field__c);
                                                    system.debug('LotqtymapLoc aftr puting il and bucket qty--->>>'+LotqtymapLoc);
                                                }
                                            }else{
                                                Map<Id,Decimal>  Locqty = new Map<Id,Decimal>();
                                                Locqty.put(ilpli.Inventory_Location__c,ilpli.bucket_field__c);
                                                LotqtymapLoc.put(ilpli.Lot__c,Locqty);
                                                system.debug('inside LotqtymapLoc>>>'+LotqtymapLoc);
                                            }
                                            if(ilpli.Available_Quantity__c>=productQuantityMap.get(solDataToSave[i].orderLines.Product__c))
                                            {
                                                Inventory_Allocation__c indIA=new Inventory_Allocation__c();
                                                indIA.ILPLI__c=ilpli.id;
                                                indIA.Order_Line__c=solDataToSave[i].orderLines.id;
                                                indIA.Quantity__c=orderlinequnt.get(solDataToSave[i].orderLines.id);
                                                IAListToInsert.add(indIA);
                                                //code to handle PSN
                                                if(ilpli.Product_Serial_Number__c!=null)
                                                {
                                                    Serialid.add(ilpli.Product_Serial_Number__c); 
                                                }
                                                if(ilpliIdILPLIMapToUpdate1.containsKey(ilpli.id)){
                                                    ILPLIIdQuantMap1.put(ilpli.id,ILPLIIdQuantMap1.get(ilpli.id)+productQuantityMap.get(solDataToSave[i].orderLines.Product__c));
                                                }
                                                else{
                                                    ILPLIIdQuantMap1.put(ilpli.id,productQuantityMap.get(solDataToSave[i].orderLines.Product__c));
                                                }
                                                if(ilpliIdILPLIMapToUpdate1.containsKey(ilpli.id)){
                                                    Inventory_Location_Product_Line_Item__c tempILPLI=ilpliIdILPLIMapToUpdate1.get(ilpli.id);
                                                    
                                                    tempILPLI.Delivered_Quantity__c+=productQuantityMap.get(solDataToSave[i].orderLines.Product__c);
                                                    ilpliIdILPLIMapToUpdate1.put(ilpli.id,tempILPLI);
                                                }
                                                else{
                                                    
                                                    ilpli.Delivered_Quantity__c+=productQuantityMap.get(solDataToSave[i].orderLines.Product__c);
                                                    ilpliIdILPLIMapToUpdate1.put(ilpli.id,ilpli);
                                                }
                                                if(ILPQuant.containsKey(ilpli.Inventory_Location_Product__c))
                                                {
                                                    
                                                    ILPQuant.put(ilpli.Inventory_Location_Product__c,ILPQuant.get(ilpli.Inventory_Location_Product__c)+productQuantityMap.get(solDataToSave[i].orderLines.Product__c));
                                                    
                                                }
                                                else
                                                {
                                                    
                                                    ILPQuant.put(ilpli.Inventory_Location_Product__c,productQuantityMap.get(solDataToSave[i].orderLines.Product__c));
                                                    
                                                }
                                                
                                                
                                                //LOT for Allocated
                                                if(LotQuant.containsKey(ilpli.Lot__c))
                                                {
                                                    system.debug('Inside if Condition');
                                                    LotQuant.put(ilpli.Lot__c,LotQuant.get(ilpli.Lot__c)+productQuantityMap.get(solDataToSave[i].orderLines.Product__c));
                                                    system.debug('LotQuant in if-->>'+LotQuant);
                                                    system.debug('productQuantityMap in if-->>>'+productQuantityMap);
                                                    
                                                }
                                                else
                                                {
                                                    system.debug('Inside else Condition');
                                                    LotQuant.put(ilpli.Lot__c,productQuantityMap.get(solDataToSave[i].orderLines.Product__c));
                                                    system.debug('LotQuant in else-->>'+LotQuant);
                                                    
                                                }
                                                
                                                if(maplotproforBin.containsKey(ilpli.Bin__c))
                                                {
                                                    system.debug('Inside if Condition');
                                                    maplotproforBin.put(ilpli.Bin__c,maplotproforBin.get(ilpli.Bin__c)+productQuantityMap.get(solDataToSave[i].orderLines.Product__c));
                                                    
                                                    system.debug('maplotproforBin '+maplotproforBin);
                                                }
                                                else
                                                {
                                                    maplotproforBin.put(ilpli.Bin__c,productQuantityMap.get(solDataToSave[i].orderLines.Product__c));
                                                    system.debug('maplotproforBinelse@@'+maplotproforBin);
                                                }
                                                
                                            if(LOTID.size()>0)
                                            {
                                            if(lotqtyupdate.containsKey(ilpli.Lot__c))
                                            {
                                                if(lotqtyupdate.get(ilpli.Lot__c).containsKey(ilpli.Bin__c))
                                                {
                                                    decimal qty=lotqtyupdate.get(ilpli.Lot__c).get(ilpli.Bin__c);
                                                    lotqtyupdate.get(ilpli.Lot__c).put(ilpli.Bin__c,qty+productQuantityMap.get(solDataToSave[i].orderLines.Product__c));
                                                }
                                                else
                                                {
                                                    Map<id,decimal> locid=new Map<id,decimal>();
                                                    lotqtyupdate.get(ilpli.Lot__c).put(ilpli.Bin__c,productQuantityMap.get(solDataToSave[i].orderLines.Product__c));
                                                }
                                            }
                                            else
                                            {
                                                Map<id,decimal> locid=new Map<id,decimal>();
                                                locid.put(ilpli.Bin__c,productQuantityMap.get(solDataToSave[i].orderLines.Product__c));
                                                lotqtyupdate.put(ilpli.Lot__c,locid);
                                            }
                                            }
                                                
                                                
                                                solQuantCount-=productQuantityMap.get(solDataToSave[i].orderLines.Product__c);
                                                productQuantityMap.put(ilpli.Inventory_Location_Product__r.Products__c,0);
                                                system.debug('solQuantCount in if-->>'+solQuantCount);
                                                system.debug('productQuantityMap in if-->'+productQuantityMap);
                                            }
                                            else
                                            {
                                                decimal tempQuant=ilpli.Available_Quantity__c;
                                                Inventory_Allocation__c indIA=new Inventory_Allocation__c();
                                                indIA.ILPLI__c=ilpli.id;
                                                indIA.Order_Line__c=solDataToSave[i].orderLines.id;
                                                indIA.Quantity__c=tempQuant;
                                                IAListToInsert.add(indIA);
                                                //code to handle PSN
                                                if(ilpli.Product_Serial_Number__c!=null)
                                                {
                                                    Serialid.add(ilpli.Product_Serial_Number__c); 
                                                }
                                                if(ilpliIdILPLIMapToUpdate1.containsKey(ilpli.id)){
                                                    ILPLIIdQuantMap1.put(ilpli.id,ILPLIIdQuantMap1.get(ilpli.id)+tempQuant);
                                                }
                                                else{
                                                    ILPLIIdQuantMap1.put(ilpli.id,tempQuant);
                                                }
                                                if(ilpliIdILPLIMapToUpdate1.containsKey(ilpli.id)){
                                                    Inventory_Location_Product_Line_Item__c tempILPLI=ilpliIdILPLIMapToUpdate1.get(ilpli.id);
                                                    tempILPLI.Delivered_Quantity__c+=tempQuant;
                                                    ilpliIdILPLIMapToUpdate1.put(ilpli.id,tempILPLI);
                                                }
                                                else{
                                                    ilpli.Delivered_Quantity__c+=tempQuant;
                                                    ilpliIdILPLIMapToUpdate1.put(ilpli.id,ilpli);
                                                }
                                                if(ILPQuant.containsKey(ilpli.Inventory_Location_Product__c))
                                                {
                                                    ILPQuant.put(ilpli.Inventory_Location_Product__c,ILPQuant.get(ilpli.Inventory_Location_Product__c)+tempQuant);
                                                }
                                                else
                                                {
                                                    ILPQuant.put(ilpli.Inventory_Location_Product__c,tempQuant);
                                                }
                                                //LOT for Allocated
                                                system.debug('LotQuant.containsKey(ilpli.Lot__c)-->>>'+LotQuant.containsKey(ilpli.Lot__c));
                                                if(LotQuant.containsKey(ilpli.Lot__c))
                                                {
                                                    system.debug('Inside if Condition11');
                                                    LotQuant.put(ilpli.Lot__c,LotQuant.get(ilpli.Lot__c)+productQuantityMap.get(solDataToSave[i].orderLines.Product__c));
                                                    system.debug('LotQuant for allocated-->>>'+LotQuant);
                                                    
                                                }
                                                else
                                                {
                                                    system.debug('Inside else Condition22');
                                                    LotQuant.put(ilpli.Lot__c,productQuantityMap.get(solDataToSave[i].orderLines.Product__c));
                                                    system.debug('LotQuant for allocated-->>>'+LotQuant);
                                                    
                                                }
                                                
                                                if(maplotproforBin.containsKey(ilpli.Bin__c))
                                                {
                                                    maplotproforBin.put(ilpli.Bin__c,maplotproforBin.get(ilpli.Bin__c)+tempQuant);
                                                    system.debug('maplotproforBin in if-->>>'+maplotproforBin);
                                                }
                                                else
                                                {
                                                    
                                                    maplotproforBin.put(ilpli.Bin__c,tempQuant);
                                                    system.debug('maplotproforBin in if-->>>'+maplotproforBin);
                                                }
                                                //end time
                                                
                                        if(LOTID.size()>0)
                                        {
                                        if(lotqtyupdate.containsKey(ilpli.Lot__c))
                                        {
                                            if(lotqtyupdate.get(ilpli.Lot__c).containsKey(ilpli.Bin__c))
                                            {
                                                decimal qty=lotqtyupdate.get(ilpli.Lot__c).get(ilpli.Bin__c);
                                                lotqtyupdate.get(ilpli.Lot__c).put(ilpli.Bin__c,qty+tempQuant);
                                            }
                                            else
                                            {
                                                Map<id,decimal> locid=new Map<id,decimal>();
                                                lotqtyupdate.get(ilpli.Lot__c).put(ilpli.Bin__c,tempQuant);
                                            }
                                        }
                                        else
                                        {
                                            Map<id,decimal> locid=new Map<id,decimal>();
                                            locid.put(ilpli.Bin__c,tempQuant);
                                            lotqtyupdate.put(ilpli.Lot__c,locid);
                                        }
                                        }
                                                system.debug('came out8494');
                                                solQuantCount-=tempQuant;
                                                system.debug('came 0707'+ solQuantCount);
                                                productQuantityMap.put(ilpli.Inventory_Location_Product__r.Products__c,productQuantityMap.get(ilpli.Inventory_Location_Product__r.Products__c)-tempQuant);
                                                orderlinequnt.put(solDataToSave[i].orderLines.id,orderlinequnt.get(solDataToSave[i].orderLines.id)-tempQuant);
                                                system.debug('AFTR adding ilp prod>>>'+ productQuantityMap);
                                                system.debug('get ilp prod>>>'+ productQuantityMap);
                                            }
                                        }
                                    }
                                }
                            }
                        }
            System.debug('Serialid@@'+Serialid);
                        List<Product_Serial_Number__c> serialststusupdate=new List<Product_Serial_Number__c>();
                        serialststusupdate=[select id,name,Status__c from Product_Serial_Number__c where id=:Serialid];
                        for(Product_Serial_Number__c serialstatus:serialststusupdate)
                        {
                            serialstatus.Status__c='Used';
                        }
                        update serialststusupdate;
                        
                        //updating the sold quantity in ILP
                        List<Inventory_Location_Product__c>updatesoldqunt=new List<Inventory_Location_Product__c>();
                        updatesoldqunt=[select id,name,Deliver_Quantity__c from Inventory_Location_Product__c where id=:ILPQuant.keySet()];
                        for(Inventory_Location_Product__c ILP:updatesoldqunt)
                        {
                            ILP.Deliver_Quantity__c+=ILPQuant.get(ILP.id); 
                        }
                        
                        update updatesoldqunt;
                        //code added by rashmi to handle Lot product qty aftr allocation on 24-02-2020
                        system.debug('LotQuant.keySet()-->>'+LotQuant.keySet());
                        List<Lot_Product__c> lotproduct = new List<Lot_Product__c>();
                        decimal newval=0;
                        lotproduct = [select id,Product__c,Quantity__c,Location__c,Lot__c,Bin__c from Lot_Product__c where Lot__c =: lotqtyupdate.keySet()]; 
                        system.debug('aftr querrying lotproduct-->>'+lotproduct);
                        for(Lot_Product__c LP : lotproduct ) 
                        {
                            
                            if(lotqtyupdate.containsKey(LP.Lot__c))
                            {
                                if(lotqtyupdate.get(LP.Lot__c).containsKey(LP.Bin__c))
                                {
                                    LP.Quantity__c-=lotqtyupdate.get(LP.Lot__c).get(LP.Bin__c);
                                }
                            } 
                        }
                        if(lotproduct.size()>0){
                            update lotproduct;
                        }
                        
                        
                        List<Product_Serial_Number__c> ProdSNList = new List<Product_Serial_Number__c>();
                        if(ilpliIdILPLIMapToUpdate1.size()>0)
                        {
                            update ilpliIdILPLIMapToUpdate1.values();
                        }
                        if(IAListToInsert.size()>0)
                        {
                            Upsert IAListToInsert;
                        }
                        
                        for(Product_Order_Price_Book__c   tempSOL:solListToUpdateAsAllocated){
                            tempSOL.IsInventoryUpdated__c=true;
                        }
                        if(solListToUpdateAsAllocated.size()>0){
                            upsert solListToUpdateAsAllocated;
                        }
                        
                        
                        //code for Sigma Finance added by Mahantesh on march 26th 2020 related to when inventory status = "Allocated"
                        
                        Set<Id> IlpliSet = new Set<Id>();    //stores ilpli id
                        Map<Id,Inventory_Allocation__c> IlpliNIaMap = new Map<Id,Inventory_Allocation__c>();    //stores inventory allocation list
                        Map<Id,Id> IlpliSlIdMap = new Map<Id,Id>();    //key => Ilpli id, value => stock Linkage record id
                        Map<Id,Id> IaSlIdMap = new Map<Id,Id>();    //key => inventory allocation id, value => stock Linkage record id
                        
                        if(IAListToInsert.size() > 0)
                        {
                            for(Inventory_Allocation__c ia : [select id,ILPLI__c,Order_Line__r.Net_Quantity__c,Order_Line__r.Total_Amount__c,Quantity__c,Order_Line__c,Order_Line__r.Total_Price__c,Order_Line__r.Product__c,Order_Line__r.Amount_Per_Interval__c,Order_Line__r.Product__r.Attribute_Type__c from Inventory_Allocation__c where Id =: IAListToInsert ])
                            {
                                IlpliSet.add(ia.ILPLI__c);
                                IlpliNIaMap.put(ia.Id,ia);
                            }
                        }
                        //to create a map of ilpli and respective sigma linkage
                        List<Sigma_Linkage_Item__c> sigmalinkage=new List<Sigma_Linkage_Item__c>();
                        sigmalinkage=[select Id, Sigma_Linkage__c, Inventory_Location_Product_Line_Item__c from Sigma_Linkage_Item__c where Inventory_Location_Product_Line_Item__c IN: IlpliSet];
                        
                        if(sigmalinkage.size() > 0)
                        {
                            for(Sigma_Linkage_Item__c slli:sigmalinkage)
                            {
                                IlpliSlIdMap.put(slli.Inventory_Location_Product_Line_Item__c, slli.Sigma_Linkage__c);
                            }
                        }
                        //List<Sigma_Linkage__c> SLToUpdateList = new List<Sigma_Linkage__c>();    //List of SL to be updated   
                        List<Sigma_Linkage__c> slListToUpdate=new List<Sigma_Linkage__c>();
                        slListToUpdate=[select Id, name, SRP__c, ILP__c, Packaged_Quantity__c,Delivered_Quantity__c, Stock_Origin__c from Sigma_Linkage__c where Id IN: IlpliSlIdMap.values()];
                        System.debug('IlpliNIaMap>>'+IlpliNIaMap);
                        System.debug('IlpliSet>>'+IlpliSet);
                        System.debug('slListToUpdate>>'+slListToUpdate);
                        for(Id ia:IlpliNIaMap.keySet())
                        {
                            if(slListToUpdate.size() > 0)
                            {
                                for(Sigma_Linkage__c sl:slListToUpdate)
                                {
                                    if(sl.Id == IlpliSlIdMap.get( IlpliNIaMap.get(ia).ILPLI__c ))
                                    {
                                        sl.Delivered_Quantity__c = sl.Delivered_Quantity__c + IlpliNIaMap.get(ia).Quantity__c;
                                        IaSlIdMap.put(ia,sl.Id);
                                        //SLToUpdateMap.add(sl);
                                    }
                                }
                            }
                        }
                        
                        if(IaSlIdMap.size() > 0)
                        {
                            List<Sigma_Linkage_Item__c> SLLIList = new List<Sigma_Linkage_Item__c>();   //to insert SLLI
                            for(Id ia:IlpliNIaMap.keySet())
                            {
                                system.debug('rental amount::'+IlpliNIaMap.get(ia).Order_Line__r.Amount_Per_Interval__c);
                                Sigma_Linkage_Item__c SLLI = new Sigma_Linkage_Item__c();
                                SLLI.Activity_Date_Time__c = system.now();
                                SLLI.Order_Line__c = IlpliNIaMap.get(ia).Order_Line__c;
                                SLLI.Sigma_Linkage__c = IaSlIdMap.get(ia);
                                SLLI.Product__c = IlpliNIaMap.get(ia).Order_Line__r.Product__c;
                                SLLI.Quantity__c = IlpliNIaMap.get(ia).Quantity__c;             
                                SLLI.Sales_Unit_Price__c = IlpliNIaMap.get(ia).Order_Line__r.Total_Amount__c;
                                if(IlpliNIaMap.get(ia).Order_Line__r.Product__r.Attribute_Type__c == 'SERIALIZED')
                                {
                                    SLLI.Total_Sales_Value__c = (IlpliNIaMap.get(ia).Order_Line__r.Total_Price__c/IlpliNIaMap.get(ia).Order_Line__r.Net_Quantity__c);
                                }
                                else
                                {
                                    SLLI.Total_Sales_Value__c = IlpliNIaMap.get(ia).Order_Line__r.Total_Price__c;
                                }
                                SLLI.Inventory_Location_Product_Line_Item__c = IlpliNIaMap.get(ia).ILPLI__c;
                                //SLLI.Shipment_Product__c = ShipPackMap.get( IlpliNIaMap.get(ia).Packaged_Product__r.Package__c );
                                SLLI.Type__c = 'Shipment';
                                SLLIList.add(SLLI);
                            }
                            System.debug('SLLIList:'+SLLIList);
                            try
                            {
                                if(SLLIList.size() > 0)
                                {
                                    insert SLLIList;
                                    
                                }
                                if(slListToUpdate.size() > 0)
                                {
                                    update slListToUpdate;
                                }
                            }
                            catch(Exception e)
                            {
                                System.debug('Exception createSLFromILP LinkPPLI:'+e.getMessage());
                            }
                        } 
                    } 
                }  
                //code to create invoice records
                if(soupdate)
                {
                    Map<Id,Invoice_Item__c>Invoiceitemdetails = new Map<Id,Invoice_Item__c>();
                    List<Invoice_Item__c> InvoiceItemslist = new List<Invoice_Item__c>();
                    List<Invoice__c> invoicedata = [select id,name,SO__c,Invoice_Type__c,Customer__c,Invoice_Status__c,(select id,name,Invoice_Number__c,SOI__c,Quantity__c,Total_Amount__c,Product__c,Net_Amount__c,Discount__c from Invoice_Items__r) from Invoice__c where SO__c=:soDataToSave.id];
                    for(Invoice__c inv :invoicedata)
                    {
                        if(soDataToSave.Orders_Status__c=='Pending')
                        {
                            inv.Invoice_Status__c='Unpaid'; 
                        }
                        else if(soDataToSave.Orders_Status__c =='Canceled')
                        {
                            inv.Invoice_Status__c='Cancelled';
                        }
                        else
                        {
                            inv.Invoice_Status__c = 'paid';
                        }
                        for(Invoice_Item__c invitem:inv.Invoice_Items__r)
                        {
                            Invoiceitemdetails.put(invitem.SOI__c,invitem);
                        }
                        system.debug('Invoiceitemdetails@@'+Invoiceitemdetails);
                        
                    }
                    for(Product_Order_Price_Book__c orderline : solList) 
                    {
                        if(Invoiceitemdetails.containsKey(orderline.id))
                        {
                            Invoice_Item__c InvoiceItems =Invoiceitemdetails.get(orderline.id);
                            InvoiceItems.Quantity__c = orderline.Net_Quantity__c;
                            InvoiceItems.Total_Amount__c=orderline.Total_Price__c;
                            InvoiceItems.Product__c=orderline.Product__c;
                            InvoiceItems.Net_Amount__c = orderline.Total_Amount__c*orderline.Net_Quantity__c;
                            if(orderline.Discounts__c!=null && orderline.Discounts__c>0)
                                InvoiceItems.Discount__c = orderline.Discounts__c;
                            InvoiceItemslist.add(InvoiceItems);
                        }
                        //system.debug('invitem@@'+invitem);
                    }
                    if(invoicedata.size()>0)
                        update invoicedata;
                    system.debug('InvoiceItemslist@@'+InvoiceItemslist);
                    if(InvoiceItemslist.size()>0)
                        upsert InvoiceItemslist;
                    
                }
                else 
                {
                    Invoice__c invoice = new Invoice__c();
                    List<Invoice_Item__c>Invoiceitem = new List<Invoice_Item__c>();
                    invoice.SO__c = soDataToSave.id; 
                    invoice.Invoice_Type__c='Sales Invoice';
                    invoice.Customer__c =soDataToSave.AccountId__c; 
                    if(soDataToSave.Orders_Status__c=='Pending')
                    {
                        invoice.Invoice_Status__c='Unpaid'; 
                    }
                    else if(soDataToSave.Orders_Status__c =='Canceled')
                    {
                        invoice.Invoice_Status__c='Cancelled';
                    }
                    else
                    {
                        invoice.Invoice_Status__c = 'paid';
                    }
                    insert invoice;
                    for(Product_Order_Price_Book__c orderline : solList)
                    {
                        Invoice_Item__c invoicedata = new Invoice_Item__c();
                        invoicedata.Invoice_Number__c=invoice.id;
                        invoicedata.SOI__c=orderline.id;
                        invoicedata.Quantity__c = orderline.Net_Quantity__c;
                       invoicedata.Total_Amount__c=orderline.Total_Price__c;
                      invoicedata.Total_Amount__c=orderline.Total_Price__c+orderline.tax_amount__c;
                       // invoicedata.Product__c=orderline.Product__c;
                        invoicedata.Net_Amount__c = orderline.Total_Amount__c*orderline.Net_Quantity__c;
                        if(orderline.Discounts__c!=null && orderline.Discounts__c>0)
                            invoicedata.Discount__c = orderline.Discounts__c;
                        Invoiceitem.add(invoicedata);
                    }
                    if(Invoiceitem.size()>0)
                        insert Invoiceitem;
                }
                //CODE END
                Boolean retval=false;
                String type='';
                Decimal totalprice1;
                String Sigmaorder;
                decimal totalorderamount =0;
                system.debug('SODATA>>'+soDataToSave);
                system.debug('soDataForAccountUpdated>>'+soDataToSave.TotalAmount__c);
                try{
                    if(soDataToSave.Customer_Type__c=='Credit Customer'){
                        List<Product_Order_Price_Book__c>orderlinedata=[select id,Order_Status__c,Sigma_Order__r.Name,Total_Price__c,Is_Credit_Updated__c from Product_Order_Price_Book__c where Is_Credit_Updated__c =false and Order_Status__c ='Order Confirmed' and Sigma_Order__c=:soDataToSave.id];
                        system.debug('orderlinedata@@'+orderlinedata);
                        for(Product_Order_Price_Book__c POPB :orderlinedata)
                        {
                            if(POPB.Is_Credit_Updated__c == false && POPB.Order_Status__c =='Order Confirmed')
                            {
                                totalorderamount += POPB.Total_Price__c;
                                POPB.Is_Credit_Updated__c = true;
                            }
                        }
                         for(Product_Order_Price_Book__c POPB1 :orderlinedata)
                        {
                        totalprice1=POPB1.Total_Price__c;
                        Sigmaorder=POPB1.Sigma_Order__r.Name;
                        }
                        system.debug('totalprice1@@'+totalprice1);
                        system.debug('Sigmaorder@@'+Sigmaorder);
                        
                        Dimension_Tag__c dimTag;
                        try{
                            dimTag=[select id,Ordered_Amount__c,Account__c,Remaining_Credit_Limit__c,Sigma_Order__r.Name from Dimension_Tag__c where Account__c=:soDataToSave.AccountId__c limit 1];
                        }
                        catch(Exception e){
                            
                        }
                        
                        if(dimTag!=null){
                            if(dimTag.Ordered_Amount__c==null)
                                dimTag.Ordered_Amount__c=0;
                            if(totalorderamount>0){
                                dimTag.Ordered_Amount__c+=totalorderamount;
                            update dimTag;
                            System.debug('dimTag::'+dimTag);
                            TransactionHistory.creditHistorySO(dimTag,totalprice1,Sigmaorder);
                            }
                        }
                        if(orderlinedata.size()>0)
                        {
                            update orderlinedata;
                            system.debug('orderlinedata@@'+orderlinedata);
                        }
                    }
                }
                catch(Exception exc)
                {
                    try{
                        // createErrorLog.insertError('Stapp Order',exc.getMessage(),'While Updating Dimension tag Ordered amount',null,'',exc.getStackTraceString(),UserInfo.getUserId());
                    }
                    catch(Exception ex)
                    {
                    }
                }     
                responseWrap rw = new responseWrap();
                rw.message = 'success';
                rw.data = soDataToSave.Id;
                rw.soName=[select name from Sigma_Order__c where id=:soDataToSave.id].Name;//soDataToSave.Name not returning the Name of SO. so written query to fetch the SO name.
                // rw.proformaCheck=retval;
                return rw;
                
            }
            
            
            catch(Exception e)
            {
                Database.rollback(sp);
                try{
                    createErrorLog.insertError('Sigma Order',e.getMessage(),'While Saving',null,'',e.getStackTraceString(),UserInfo.getUserId());
                }
                catch(Exception ex)
                {
                }
                responseWrap rw = new responseWrap();
                rw.message = 'error';
                rw.data = e.getMessage()+ ', At Line number '+e.getStackTraceString();
                return rw;
            }
       // }
        
    }
    
    public class responseWrap
    {
        @auraEnabled
        public string message;
        @auraEnabled
        public string data;
        @auraEnabled
        public string soName;
        @auraEnabled
        public Boolean proformaCheck;
    }
    
    public class SigmaOrderWrap
    {
        @auraEnabled
        public Boolean hasBackOrder;
        @auraEnabled
        public Boolean isDisabled;
        @auraEnabled
        public Boolean isDisplay;
        @auraEnabled
        public Product_Order_Price_Book__c orderLines;
        @auraEnabled
        public List<ILPLISaveWrap> ilpliData;
        //added newly for AutoReserve
        @auraEnabled
        public String stockExist;
    }
    public class SigmaOrderUpdateWrap
    {
        @auraEnabled
        public Sigma_Order__c sigmaOrder;
        @auraEnabled
        public List<sigmaOrderLinesUpdateWrap> solWrap;
        @auraEnabled
        public Dimension_Tag__c credituser;
    }
    public class sigmaOrderLinesUpdateWrap
    {
        @auraEnabled
        public Boolean hasBackOrder;
        @auraEnabled
        public Boolean isDisabled;
        @auraEnabled
        public Boolean isDisplay;
        @auraEnabled
        public Boolean isConfirmedOL;
        @auraEnabled
        public String productName;
        @auraEnabled
        public String BillingPersonNew;
        @auraEnabled
        public Product_Order_Price_Book__c orderLines;
        @auraEnabled
        public String taxCodeName;
        
        @auraEnabled
        public Boolean BackOrdercheckbox;
    }
    public class ILPLISaveWrap
    {
        @auraEnabled
        public id Id{get;set;}
        @auraEnabled
        public Decimal enteredQuant{get;set;}
        
    }
    
    @auraEnabled
    public static SigmaOrderUpdateWrap getSigmaOrderData(String soId)
    {
        SigmaOrderUpdateWrap soEdit = new SigmaOrderUpdateWrap();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c') 
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Dimension_Tag__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new Set<String>{'id','name','sigmaerpdev__Total_Payable_Amount__c','sigmaerpdev__Is_Payment_Made__c','sigmaerpdev__TotalAmount__c','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Net_Amount__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__Tax__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Balance_Amount__c','sigmaerpdev__AccountId__c','sigmaerpdev__AccountId__r.Id','sigmaerpdev__AccountId__r.name','sigmaerpdev__Customer_Type__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Contact__c','sigmaerpdev__Contact__r.name','sigmaerpdev__ShippingCity__c','sigmaerpdev__ShippingCountry__c','sigmaerpdev__ShippingState__c','sigmaerpdev__ShippingPostalCode__c','sigmaerpdev__Shipping_Street__c','sigmaerpdev__Delivary_Date__c','sigmaerpdev__BillingPersonNew__c','sigmaerpdev__BillingPersonNew__r.Name','sigmaerpdev__No_Picking_Package_Shipment_Required__c','sigmaerpdev__Currency__c','sigmaerpdev__Currency__r.Name','sigmaerpdev__Currency__r.sigmaerpdev__Display_Name__c','sigmaerpdev__Auto_Allocate__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'id','name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Splited_Order_Line__c','sigmaerpdev__Remaining_Qty_To_Package__c','sigmaerpdev__Stock_Fulfilled__c','sigmaerpdev__Product__c','sigmaerpdev__Product__r.name','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Quantity__c','sigmaerpdev__Total_Amount__c','sigmaerpdev__Discounts__c','sigmaerpdev__Delivary_Date__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Back_Order__c','sigmaerpdev__IsInventoryUpdated__c','sigmaerpdev__Total_Price__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Dimension_Tag__c',new Set<String>{'id','name','sigmaerpdev__Remaining_Credit_Limit__c','sigmaerpdev__Account__c'})
          )
        {*/
            List<sigmaOrderLinesUpdateWrap> solWraplList=new List<sigmaOrderLinesUpdateWrap>();
            soEdit.sigmaOrder=[select id,name,Total_Payable_Amount__c,Is_Payment_Made__c,TotalAmount__c,Order_Created_Via__c,Net_Amount__c,Tax_Amount__c,Tax__c,Paid_Amount__c,Balance_Amount__c,AccountId__c,AccountId__r.Id,AccountId__r.name,Customer_Type__c,Orders_Status__c,Contact__c,Contact__r.name,ShippingCity__c,ShippingCountry__c,ShippingState__c,ShippingPostalCode__c,Shipping_Street__c,Delivary_Date__c,BillingPersonNew__c,BillingPersonNew__r.Name, No_Picking_Package_Shipment_Required__c,Currency__c,Currency__r.Name,Currency__r.Display_Name__c,Auto_Allocate__c,Tax_Treatment__c,Tax_Treatment__r.name,Discount__c  from Sigma_Order__c where id=:soId];
            if(soEdit.sigmaOrder.Customer_Type__c == 'Credit Customer')
            {
                soEdit.credituser =[select id,name,Remaining_Credit_Limit__c,Account__c from Dimension_Tag__c where Account__c =:soEdit.sigmaOrder.AccountId__c limit 1];
            }
            for(Product_Order_Price_Book__c   sol:[select id,name,Tax_Rate__c,tax_amount__c,Sigma_Order__c,Splited_Order_Line__c,Stock_Fulfilled__c,Product__c,Product__r.name,Net_Quantity__c,Quantity__c,Total_Amount__c,Discounts__c,Delivary_Date__c,Order_Status__c,Back_Order__c,IsInventoryUpdated__c,Total_Price__c,Remaining_Qty_To_Package__c,Service_Duration__c,Service_End_Date__c,Service_Intervals__c,Service_Start_Date__c,Product_Duration__c,Product_Interval__c,Product_Warranty_End_Date__c,Product_Warranty_Start_Date__c,Warranty_Created__c,Inventory_Status__c,Tax_Code__c,Tax_Code__r.name from Product_Order_Price_Book__c where Sigma_Order__c =:soId])
            {
                
                sigmaOrderLinesUpdateWrap solList=new sigmaOrderLinesUpdateWrap();
                solList.productName=sol.Product__r.name;
                solList.taxCodeName=sol.Tax_Code__r.name;
                if(sol.Splited_Order_Line__c)
                {
                    solList.isDisabled=true;
                    solList.isDisplay=true;
                }
                
                if(sol.Back_Order__c)
                {
                    solList.isDisabled=true;
                    solList.isDisplay=true;
                }
                
                
                if(sol.IsInventoryUpdated__c)
                {
                    solList.isConfirmedOL=true;
                }
                
                if(sol.Back_Order__c)
                {
                    solList.BackOrdercheckbox=true;
                }
                
                solList.orderLines=sol;
                solWraplList.add(solList);
            }
            system.debug('solWraplList@@'+solWraplList);
            soEdit.solWrap=solWraplList;
        //}
        return soEdit;
        
    }
    //code added by rashmi on 28-05-2021 - to handle SO
     @auraEnabled
    public static SigmaOrderUpdateWrap getSigmaOrderDataForCloning(String soId)
    {
        SigmaOrderUpdateWrap soEdit = new SigmaOrderUpdateWrap();
        
        List<sigmaOrderLinesUpdateWrap> solWraplList=new List<sigmaOrderLinesUpdateWrap>();
        soEdit.sigmaOrder=[select id,name,Total_Payable_Amount__c,Is_Payment_Made__c,sigmaerpdev2__Due_Amount__c,TotalAmount__c,Order_Created_Via__c,Net_Amount__c,Tax_Amount__c,Tax__c,Paid_Amount__c,Balance_Amount__c,AccountId__c,AccountId__r.Id,AccountId__r.name,Customer_Type__c,Orders_Status__c,Contact__c,Contact__r.name,ShippingCity__c,ShippingCountry__c,ShippingState__c,ShippingPostalCode__c,Shipping_Street__c,Delivary_Date__c,BillingPersonNew__c,BillingPersonNew__r.Name, No_Picking_Package_Shipment_Required__c,Currency__c,Currency__r.Name,Currency__r.Display_Name__c,Auto_Allocate__c  from Sigma_Order__c where id=:soId];
        soEdit.sigmaOrder.Orders_Status__c='Pending';
        soEdit.sigmaOrder.Is_Payment_Made__c=false;
        soEdit.sigmaOrder.Paid_Amount__c=0;
        soEdit.sigmaOrder.Delivary_Date__c=null;
        soEdit.sigmaOrder.Currency__c=null;
        for(Product_Order_Price_Book__c sol:[select id,name,Splited_Order_Line__c,Stock_Fulfilled__c,Product__c,Product__r.name,Net_Quantity__c,Ordered_Quantity__c,Quantity__c,Total_Amount__c,Discounts__c,Delivary_Date__c,Order_Status__c,Back_Order__c,IsInventoryUpdated__c,Total_Price__c,Remaining_Qty_To_Package__c,Service_Duration__c,Service_End_Date__c,Service_Intervals__c,Service_Start_Date__c,Product_Duration__c,Product_Interval__c,Product_Warranty_End_Date__c,Product_Warranty_Start_Date__c,Warranty_Created__c,Inventory_Status__c from Product_Order_Price_Book__c where Sigma_Order__c =:soId])
        {
            sigmaOrderLinesUpdateWrap solList=new sigmaOrderLinesUpdateWrap();
            solList.productName=sol.Product__r.name;
          
            //if(sol.Splited_Order_Line__c)
            //{
            //    solList.isDisabled=true;
            //    solList.isDisplay=true;
            //}
            //if(sol.Back_Order__c)
            //{
            //   solList.isDisabled=true;
            //   solList.isDisplay=true;
            //}
            //sol.id=null;
            sol.Order_Status__c='Pending';
            sol.Net_Quantity__c=sol.Quantity__c;
            sol.IsInventoryUpdated__c=false;
            sol.Delivary_Date__c=null;
           solList.orderLines=sol;
            solWraplList.add(solList);
        }
        soEdit.solWrap=solWraplList;
        system.debug('soEdit>>>>>>>>>>'+soEdit);
        return soEdit;
    }
    //code ends here - 28-05-2021
    @AuraEnabled
    public static List<SigmaOrderWrap> automateStockReservation(String so, String sol){
        List<SigmaOrderWrap> solDataToSave = (List<SigmaOrderWrap>)System.JSON.deserialize(sol,List<SigmaOrderWrap>.class); 
       /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')  
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c') 
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'id','sigmaerpdev__IsInventoryUpdated__c','sigmaerpdev__Product__c','sigmaerpdev__Stock_Fulfilled__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Net_Quantity__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'name','Products__c','sigmaerpdev__Net_Quantity__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'id','Name','sigmaerpdev__Available_Quantity__c','sigmaerpdev__Lot__c','sigmaerpdev__Lot__r.Name','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Serial_Number__c','sigmaerpdev__Received_Date__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.name','sigmaerpdev__Inventory_Location_Product__r.Id','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Products__c','sigmaerpdev__Product_Expiry_Date__c'})
          )
        {*/
            String stockExists = 'true'; //suggests whether there is not enough stock to do allocation or not
            Sigma_Order__c soDataToSave=(Sigma_Order__c)System.JSON.deserialize(so,Sigma_Order__c.class);
            
            Map<id,List<Inventory_Location_Product_Line_Item__c>> IlpandILPLIListMap = new Map<id,List<Inventory_Location_Product_Line_Item__c>>(); //store Product and its respective ILPLIs
            Map<id,List<Inventory_Location_Product__c>> prodIlpMap = new Map<id,List<Inventory_Location_Product__c>>(); //store Product and its respective ILPs
            Map<Integer,Map<Id,Decimal>> prodMap = new Map<Integer,Map<Id,Decimal>>();
            Set<Id> prodIdSet = new Set<Id>();
            Map<Id,String> prodNameMap = new Map<Id,String>(); 
            Map<Id,String> ilpListMap1 = new Map<Id,String>(); 
            List<Id> prodIdList = new List<Id>();
            Decimal qn =0;
            Map<Integer, Map<Id,Decimal>> rowProdILPLIAlloc = new Map<Integer, Map<Id,Decimal>>();
            
            
            for(Integer i=0;i < solDataToSave.size();i++){
                
                Id prodId = solDataToSave[i].orderLines.Product__c;
                if((solDataToSave[i].orderLines.Order_Status__c=='Order Confirmed') && solDataToSave[i].orderLines.Stock_Fulfilled__c)
                {
                    qn = solDataToSave[i].orderLines.Net_Quantity__c;                              
                    Map<Id,Decimal> prodInnerMap = new Map<Id,Decimal>();
                    prodIdList.add(prodId);
                    prodInnerMap.put(prodId, qn);
                    prodIdSet.add(prodId);
                    prodMap.put(prodIdList.size()-1, prodInnerMap);
                }
                
            }
            List<Inventory_Location_Product__c> ilpList = [select id,name,Products__c from Inventory_Location_Product__c where Net_Quantity__c > 0 and Products__c In :prodIdSet];            
            
            for(Inventory_Location_Product__c ilpListItems : ilpList){
                ilpListMap1.put(ilpListItems.Id,ilpListItems.Name);
                
                Id prodIds = ilpListItems.Products__c; 
                if(prodIlpMap.containsKey(prodIds))
                {
                    List<Inventory_Location_Product__c> usedILP = new List<Inventory_Location_Product__c>();
                    usedILP = prodIlpMap.get(prodIds);
                    usedILP.add(ilpListItems);
                    prodIlpMap.put(prodIds,usedILP);                         
                }
                else{
                    List<Inventory_Location_Product__c> usedILP = new List<Inventory_Location_Product__c>();
                    usedILP.add(ilpListItems);
                    prodIlpMap.put(prodIds,usedILP);                         
                }
                
            }
            List<Product2> prodList = [select Id,Name from Product2 where Id in :prodIdSet];
            for(Product2 prodObj : prodList){
                prodNameMap.put(prodObj.Id, prodObj.Name);
            }
            //get ilpli list - first priority is for expiry date and then received date in asc order.
            List<Inventory_Location_Product_Line_Item__c> ilpliList = new List<Inventory_Location_Product_Line_Item__c>();
            List<Inventory_Location_Product_Line_Item__c> tempilpliList = new List<Inventory_Location_Product_Line_Item__c>();
            List<Inventory_Location_Product_Line_Item__c> additionalILPLIList = new List<Inventory_Location_Product_Line_Item__c>();
            Decimal reqStock  = 0.0;
            Set<Id> insuffStockSet = new Set<Id>();         
            
            tempilpliList = [Select id,name,Available_Quantity__c,Lot__c,Lot__r.Name,Product_Serial_Number__r.Serial_Number__c,Received_Date__c,
                             Inventory_Location_Product__r.Inventory_Location__r.Location__r.name,
                             Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c
                             from Inventory_Location_Product_Line_Item__c where Inventory_Location_Product__c IN : ilpListMap1.keySet() 
                             and Available_Quantity__c > 0 and Product_Expiry_Date__c != null and Product_Expiry_Date__c > TODAY];
            system.debug('tempilpliList--->>>'+tempilpliList);
            if(tempilpliList.size() > 0){ //if expiry date exists choose those ilpli's to do allocation
                ilpliList = [Select id,name,Available_Quantity__c,Lot__c,Lot__r.Name,Product_Serial_Number__r.Serial_Number__c,Received_Date__c,
                             Inventory_Location_Product__r.Inventory_Location__r.Location__r.name,
                             Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c
                             from Inventory_Location_Product_Line_Item__c where Inventory_Location_Product__c IN : ilpListMap1.keySet() 
                             and Available_Quantity__c > 0 and
                             Product_Expiry_Date__c != null and 
                             Product_Expiry_Date__c > TODAY order by Product_Expiry_Date__c ASC];
                
                for(Integer rowID : prodMap.keySet()){
                    Decimal enoughStock = 0.0;  
                    reqStock = prodMap.get(rowID).get(prodIdList.get(rowID));
                    for(Inventory_Location_Product_Line_Item__c ilpItr : ilpliList){ 
                        if(ilpItr.Inventory_Location_Product__r.Products__c == prodIdList.get(rowID)){
                            enoughStock = enoughStock + ilpItr.Available_Quantity__c;
                        }
                    }
                    if(enoughStock < reqStock){
                        System.debug('prodID=='+prodIdList.get(rowID));
                        insuffStockSet.add(prodIdList.get(rowID));
                    }    
                }                   
                
                if(insuffStockSet.size() > 0){ // if still stock is low,again pick from the remaining ilpli's which doesn't have expiry date and combine both the lists
                    additionalILPLIList = [Select id,name,Available_Quantity__c,Lot__c,Lot__r.Name,Product_Serial_Number__r.Serial_Number__c,
                                           Received_Date__c,Inventory_Location_Product__r.Inventory_Location__r.Location__r.name,
                                           Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c
                                           from Inventory_Location_Product_Line_Item__c where Inventory_Location_Product__c IN : ilpListMap1.keySet() 
                                           and Inventory_Location_Product__r.Products__c in :insuffStockSet
                                           and Available_Quantity__c > 0  
                                           order by Received_Date__c ASC];
                    
                    ilpliList.addAll(additionalILPLIList);
                }
            }else{ //else choose all ilpli's to do allocation based on received date
                ilpliList = [Select id,name,Available_Quantity__c,Lot__c,Lot__r.Name,Product_Serial_Number__r.Serial_Number__c,Received_Date__c,
                             Inventory_Location_Product__r.Inventory_Location__r.Location__r.name,
                             Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c
                             from Inventory_Location_Product_Line_Item__c where Inventory_Location_Product__c IN : ilpListMap1.keySet() 
                             and Available_Quantity__c > 0 order by Received_Date__c ASC];
            }
            //ends here         
            
            for(Inventory_Location_Product_Line_Item__c ilpliItr : ilpliList){
                Id ILPIds = ilpliItr.Inventory_Location_Product__r.Id; 
                if(IlpandILPLIListMap.containsKey(ILPIds)){
                    List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                    usedILPLI = IlpandILPLIListMap.get(ILPIds);
                    usedILPLI.add(ilpliItr);
                    IlpandILPLIListMap.put(ILPIds,usedILPLI);                         
                }
                else{
                    List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                    usedILPLI.add(ilpliItr);
                    IlpandILPLIListMap.put(ILPIds,usedILPLI);                         
                }
            }      
            System.debug('IlpandILPLIListMap==='+IlpandILPLIListMap);
            Decimal lineItemOrderedQuantity = 0.0; 
            
            String lowStockProdName = '';           
            for(Integer rowID : prodMap.keySet()){
                Decimal tempQuantityTotal = 0.0;
                Id recordId;
                system.debug('prodIdList>>'+prodIdList);
                system.debug('prodMap>>'+prodMap);
                if(prodIdList.size()>0)
                    recordId = prodIdList.get(rowID);
                lineItemOrderedQuantity = prodMap.get(rowID).get(prodIdList.get(rowID));
                if(prodIlpMap.get(recordId) != null){
                    for(Inventory_Location_Product__c recordILPId : prodIlpMap.get(recordId)){                          
                        if(IlpandILPLIListMap.get(recordILPId.Id) != null){
                            for(Inventory_Location_Product_Line_Item__c ilpliRecord : IlpandILPLIListMap.get(recordILPId.Id)){                                                                  
                                tempQuantityTotal = tempQuantityTotal + ilpliRecord.Available_Quantity__c;                                               
                            }
                        }                    
                    }                     
                }
                if(tempQuantityTotal < lineItemOrderedQuantity){
                    if(lowStockProdName != '')
                        lowStockProdName = lowStockProdName+','+prodNameMap.get(recordId);                    
                    else
                        lowStockProdName = prodNameMap.get(recordId);                                                         
                    stockExists = 'false';
                }     
            }   
            System.debug('stockExists==='+stockExists);
            if(stockExists == 'false'){                
                stockExists = 'false'+'_'+lowStockProdName;                            
                solDataToSave[0].stockExist = stockExists;                
                return solDataToSave;
            }else{                
                Decimal requiredQuantity = 0.0;
                Decimal allocatingQuantity = 0.0;
                Decimal orderedQuantity = 0.0;
                Decimal allocatedQnty = 0.0;
                Decimal remainingQnty = 0.0;
                
                //do the allocation
                for(Integer rowID : prodMap.keySet()){
                    Id recordId = prodIdList.get(rowID);
                    Map<Id,Decimal> reqProductQuantityMap1 = new Map<Id,Decimal>();
                    reqProductQuantityMap1.put(recordId, prodMap.get(rowID).get(prodIdList.get(rowID)));
                    if(prodIlpMap.get(recordId) != null)
                    {
                        for(Inventory_Location_Product__c recordILPId : prodIlpMap.get(recordId)){
                            if(IlpandILPLIListMap.get(recordILPId.Id) != null){
                                for(Inventory_Location_Product_Line_Item__c allocateProd : IlpandILPLIListMap.get(recordILPId.Id)){
                                    //Id prodIds = allocateProd.Inventory_Location_Product__r.Product__c;                               
                                    requiredQuantity = reqProductQuantityMap1.get(recordId); 
                                    
                                    if(requiredQuantity != 0.0){
                                        allocatingQuantity = allocateProd.Available_Quantity__c;                                    
                                        if(allocatingQuantity <= requiredQuantity && allocatingQuantity != 0){
                                            if(allocateProd.Available_Quantity__c != null){
                                                //IlPLIQuan.put(allocateProd.Id, allocatingQuantity);                                           
                                                if(rowProdILPLIAlloc.containsKey(rowID)){
                                                    Map<Id, Decimal> newInnerMap = new Map<Id, Decimal>(rowProdILPLIAlloc.get(rowID));
                                                    newInnerMap.put(allocateProd.Id, allocatingQuantity);
                                                    rowProdILPLIAlloc.put(rowID, newInnerMap);
                                                }else{
                                                    Map<Id, Decimal> newInnerMap = new Map<Id, Decimal>();
                                                    newInnerMap.put(allocateProd.Id, allocatingQuantity);
                                                    rowProdILPLIAlloc.put(rowID, newInnerMap);
                                                }                                                                              
                                            }
                                            requiredQuantity = requiredQuantity - allocatingQuantity;
                                        }else if(allocatingQuantity > requiredQuantity){                              
                                            if(allocateProd.Available_Quantity__c != null){
                                                Map<Id, Decimal> newInnerMap = new Map<Id, Decimal>();
                                                newInnerMap.put(allocateProd.Id, requiredQuantity);
                                                rowProdILPLIAlloc.put(rowID, newInnerMap);
                                            }                   
                                            requiredQuantity = 0.0;                   
                                        }                                                                       
                                        reqProductQuantityMap1.put(recordId, requiredQuantity);
                                    }                               
                                }
                            }
                        }
                    }
                }
                System.debug('rowProdILPLIAlloc==='+rowProdILPLIAlloc);
                Map<Integer, List<ILPLISaveWrap>> prodILPLIAllocListMap = new Map<Integer, List<ILPLISaveWrap>>();
                for(Integer rowInt : rowProdILPLIAlloc.keySet()){                   
                    List<ILPLISaveWrap> ilpliSaveWrpList = new List<ILPLISaveWrap>();
                    for(Id ilpliObj : rowProdILPLIAlloc.get(rowInt).keySet()){
                        ILPLISaveWrap ilpliSaveWrpObj = new ILPLISaveWrap();
                        ilpliSaveWrpObj.Id = ilpliObj;
                        ilpliSaveWrpObj.enteredQuant = rowProdILPLIAlloc.get(rowInt).get(ilpliObj);
                        ilpliSaveWrpList.add(ilpliSaveWrpObj);
                    }
                    prodILPLIAllocListMap.put(rowInt, ilpliSaveWrpList);
                }
                System.debug('ILPLISaveWrap=='+prodILPLIAllocListMap);
                
                for(Integer i=0; i < solDataToSave.size(); i++){
                    solDataToSave[i].ilpliData = prodILPLIAllocListMap.get(i);
                }
                solDataToSave[0].stockExist = stockExists;
            }
            System.debug('solDataToSave==='+solDataToSave); 
        //}
        return solDataToSave;
    }
    
    @AuraEnabled
  public static String saveDetails(String accList,String lst2){
      system.debug('po'+accList);
       system.debug('pop'+lst2);
     
      sigmaerpdev2__Sigma_Order__c posave=(sigmaerpdev2__Sigma_Order__c)System.JSON.deserialize(accList,sigmaerpdev2__Sigma_Order__c.class);
      system.debug('po deser'+accList);
      system.debug('po deser'+lst2);
     
      sigmaerpdev2__Sigma_Order__c savepo=new sigmaerpdev2__Sigma_Order__c();
      savepo.sigmaerpdev2__AccountId__c=posave.sigmaerpdev2__AccountId__c;
      savepo.sigmaerpdev2__Orders_Status__c=posave.sigmaerpdev2__Orders_Status__c;
      savepo.sigmaerpdev2__Customer_Type__c=posave.sigmaerpdev2__Customer_Type__c;
      savepo.sigmaerpdev2__Customer__c=posave.sigmaerpdev2__Customer__c;
      savepo.sigmaerpdev2__Delivary_Date__c=posave.sigmaerpdev2__Delivary_Date__c;
     savepo.sigmaerpdev2__Net_Amount__c=posave.sigmaerpdev2__Net_Amount__c;  
     
      System.debug('before savepo'+savepo);
      insert savepo;
      System.debug('after savepo'+savepo);
     
       List<sigmaerpdev2__Product_Order_Price_Book__c> saveli=(List<sigmaerpdev2__Product_Order_Price_Book__c>)System.JSON.deserialize(lst2,List<sigmaerpdev2__Product_Order_Price_Book__c>.class);
      system.debug('saveli deser'+saveli);
      //List<SigmaOrderWrap> solDataToSave=(List<SigmaOrderWrap>)System.JSON.deserialize(sol,List<SigmaOrderWrap>.class);
      //List<invoice> lstInvoice = (list<invoice>) JSON.deserialize(jsonStr list<invoice>.class);
     //List<sigmaOrderLinesUpdateWrap> lt = (list<sigmaOrderLinesUpdateWrap>)JSON.deserialize(lst2 list<sigmaOrderLinesUpdateWrap>.class);
      List<sigmaerpdev2__Product_Order_Price_Book__c> newpop =new List<sigmaerpdev2__Product_Order_Price_Book__c>();
      for(sigmaerpdev2__Product_Order_Price_Book__c pref : saveli){
          system.debug('pref>>'+pref);
          sigmaerpdev2__Product_Order_Price_Book__c pobj = new sigmaerpdev2__Product_Order_Price_Book__c();
          pobj.sigmaerpdev2__Sigma_Order__c = savepo.id;
          pobj.sigmaerpdev2__Product__c= pref.sigmaerpdev2__Product__c;
          pobj.sigmaerpdev2__Product__r.Name= pref.sigmaerpdev2__Product__r.Name;
          //pobj.sigmaerpdev2__TotalPrice__c=pref.sigmaerpdev2__TotalPrice__c;
          pobj.sigmaerpdev2__Discount__c=pref.sigmaerpdev2__Discount__c;
          pobj.sigmaerpdev2__Quantity__c=pref.sigmaerpdev2__Quantity__c;
          pobj.sigmaerpdev2__Total_Price__c=pref.sigmaerpdev2__Total_Price__c;
          pobj.sigmaerpdev2__Net_Quantity__c=pref.sigmaerpdev2__Net_Quantity__c;
               
          newpop.add(pobj);
      }
      System.debug('newpop'+newpop);
      insert newpop;
       System.debug('after'+newpop);
      return savepo.Id;
  }
    @AuraEnabled
    public static String fetchTaxData(String headerData,String LinesData)
    {
        
       
        String className=[select id,sigmaerpdev2__Tax_Calculation_Handler_class_Name__c from Sigma_Configurations__c limit 1].sigmaerpdev2__Tax_Calculation_Handler_class_Name__c;
        Type t=Type.forName(className);
        TaxHandlerInterface obj=(TaxHandlerInterface)t.newInstance();
        return obj.fetchTaxDataSO(headerData,LinesData);
        
    }
    @AuraEnabled
     public static AccountRelatedData fetchTaxtreatmentData(Id accId)
    { 
        AccountRelatedData ard=new AccountRelatedData();
        
            Account acc=[select id,name,Customer_Type__c,sigmaerpdev2__Tax_Treatment__c,sigmaerpdev2__Tax_Treatment__r.Name from Account where id=:accId];
            ard.acc=acc;
        
        
        return ard;
    } 
    
    @AuraEnabled
    public static  Productdata gettaxcode(Id prodId,Id customerId){
         Productdata pd=new Productdata();
    Product2   pro=[select id,name,sigmaerpdev2__Tax_Code__c,sigmaerpdev2__Tax_Code__r.Name from Product2 where id=:prodId];
       pd.pro=pro;
        return pd;
    }
     public class Productdata
    {
        @AuraEnabled
        public Product2 pro;
       
    }
     @AuraEnabled
    public static Account fetchAccountData(Id accId)
    {
        Account acc=new Account();
       
            acc=[select id,name,sigmaerpdev2__Default_Location__c,sigmaerpdev2__Tax_Treatment__c,(Select id,name from contacts ), sigmaerpdev2__Tax_Treatment__r.name,sigmaerpdev2__Vendor_Tax_Treatment__c,sigmaerpdev2__Vendor_Tax_Treatment__r.Name,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet from Account where id=:accId];
            system.debug('acc>>'+acc);
        
        return acc;
    }
  /*   @AuraEnabled
    public static ProductDataWrap getProdRelDatatopopulatetaxcode(Id prodId,string taxTreatmentId,string Customerid)
    {
        system.debug('taxTreatmentId>>'+taxTreatmentId);
        ProductDataWrap pdw=new ProductDataWrap();
                system.debug('inside ');
                List<Product2> PB = [select id,name,sigmaerpdev2__Tax_Code__c,sigmaerpdev2__Tax_Code__r.name,sigmaerpdev2__Buying_Price__c from Product2 where id=:prodId];
                
                    pdw.prodData=PB[0];
                
                
                pdw.taxRateList=new List<sigmaerpdev2__Tax_Rate__c>();
                pdw.taxRateList=[select id,name,sigmaerpdev2__Tax_Rate__c from sigmaerpdev2__Tax_Rate__c where sigmaerpdev2__Tax_Treatment__c=:taxTreatmentId AND sigmaerpdev2__Tax_Code__c=:pdw.prodData.sigmaerpdev2__Tax_Code__c];
            
        return pdw;
    }*/
     public Class ProductDataWrap
    {
        @AuraEnabled
        public Product2 prodData;
       
        @AuraEnabled
        public List<sigmaerpdev2__Tax_Rate__c> taxRateList;

    }
     @AuraEnabled
    public static ProductDataWrap getProdRelDatanew(Id prodId,string taxTreatmentId)
    {
        ProductDataWrap pdw=new ProductDataWrap();
       
            system.debug('inside ');
                List<Product2> PB = [select id,name,sigmaerpdev2__Tax_Code__c, sigmaerpdev2__Tax_Code__r.name,sigmaerpdev2__Buying_Price__c from Product2 where id=:prodId];
                
                    pdw.prodData=PB[0];
           
           
            pdw.taxRateList=new List<sigmaerpdev2__Tax_Rate__c>();
            pdw.taxRateList=[select id,name,sigmaerpdev2__Tax_Rate__c from sigmaerpdev2__Tax_Rate__c where sigmaerpdev2__Tax_Treatment__c=:taxTreatmentId AND sigmaerpdev2__Tax_Code__c=:pdw.prodData.sigmaerpdev2__Tax_Code__c];
        system.debug('pdw.prodData>>'+pdw.prodData);
        
        return pdw;
    }
    @AuraEnabled
    public static Product2 getTaxCode(String prodId)
    {
        Product2 PB = [select id,name,sigmaerpdev2__Tax_Code__c, sigmaerpdev2__Tax_Code__r.name,sigmaerpdev2__Buying_Price__c from Product2 where Name=:prodId];
        return PB;
    }
      @AuraEnabled
    public static sigmaerpdev2__Tax_Code__c fetchTaxTreatementRelatedData(Id taxTreatmentId)
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Tax_Code__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Tax_Code__c',new Set<String>{'id','name'})
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Tax_rate__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Tax_rate__c',new Set<String>{'id','name','sigmaerpdev2__Tax_Code__c','sigmaerpdev2__Tax_Treatment__c'})
          )
        {
            return [select id,name from sigmaerpdev2__Tax_Code__c where id in (select sigmaerpdev2__Tax_Code__c from sigmaerpdev2__Tax_rate__c where sigmaerpdev2__Tax_Treatment__c=:taxTreatmentId) limit 1];
        }
        return null;
    }
}