/*=====================================================================================================
    Author     : Rashmi Degavi
    Company    : Mindlinks Solution Pvt Ltd.
    Date       : 28 Feb 2019
    Description: Standard Order controller class
    =======================================================================================================*/

    public with sharing class StandardOrderCtrl {
        @AuraEnabled
        public static Account fetchAddress(String customer)
        {    
            Account acc;
            
            /*if(CRUD_FLS_CheckUtility.checkObjCRUD('Account')
               && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Dimension_Tag__c')
               && CRUD_FLS_CheckUtility.checkReadPermission('Account',new Set<String>{'Id','Name','ShippingStreet','ShippingCity','ShippingState','ShippingPostalcode','ShippingCountry','sigmaerpdev__Customer_Type__c','sigmaerpdev__Exchange_Currency__c','sigmaerpdev__Exchange_Currency__r.Name','sigmaerpdev__Exchange_Currency__r.sigmaerpdev__Display_Name__c'})
               && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Dimension_Tag__c',new Set<String>{'Id','sigmaerpdev__Account__c','sigmaerpdev__Base_Credit_Limit__c','sigmaerpdev__Remaining_Credit_Limit__c'}))
            {*/
               // acc = [ SELECT ShippingStreet,ShippingCity,ShippingState,ShippingPostalcode,ShippingCountry,Customer_Type__c,Exchange_Currency__c,Exchange_Currency__r.Name,Exchange_Currency__r.Display_Name__c,(select id,Base_Credit_Limit__c,Remaining_Credit_Limit__c from Dimension_Tags__r where Account__c =:customer limit 1),(Select Address__c,City__c,Country__c,State__c,Zip__c from Shipment_Details__r where Default_Address__c = true limit 1) from Account WHERE id =: customer ];
            //edited by Krishna Pujara for to populate Default Contact on 17-06-2021
            acc = [ SELECT ShippingStreet,ShippingCity,ShippingState,ShippingPostalcode,ShippingCountry,Customer_Type__c,Exchange_Currency__c,Exchange_Currency__r.Name,Exchange_Currency__r.Display_Name__c,(select id,Name from Contacts where AccountId=:customer),(select id,Base_Credit_Limit__c,Remaining_Credit_Limit__c from Dimension_Tags__r where Account__c =:customer limit 1),(Select Address__c,City__c,Country__c,State__c,Zip__c from Shipment_Details__r where Default_Address__c = true limit 1) from Account WHERE id =: customer ];
            //end here
            //}
            System.debug('acc::'+acc);
            return acc;
        } 
        
        //code added to handle inventory status as Allocation in DefualtConfig
        @AuraEnabled
        public static Order_Usage__c fetchDefualtConfig()
        {
            Order_Usage__c AllocationSO;
            /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new Set<String>{'sigmaerpdev__Allocation_in_Sales_Order__c'}))
            {*/
                AllocationSO=[select Allocation_in_Sales_Order__c from Order_Usage__c Limit 1];
                system.debug('AllocationSO::'+AllocationSO);
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
                fetchdefault=[select Inventory_Status__c,Auto_Reserve_Stock__c from Default_Parameters__c Limit 1];
            	 system.debug('fetchdefault::'+fetchdefault);
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
                Account acc=[select id,name,Customer_Type__c,(select id,Due_Amount__c,name,Stopped_Orders__c,Base_Credit_Limit__c from Dimension_Tags__r) from Account where id=:accId];
                ard.acc=acc;
                ard.dimensionTag=acc.Dimension_Tags__r; 
            	system.debug('acc::'+acc);
            //}
            return ard;
        }
        @AuraEnabled
        public static Product2 getProdRelData(Id prodId,Id customerId)
        {
            //added to fetch  Fetching Standard Product Price from Product Object
            Product2 prodRelList=new Product2();
           /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('PricebookEntry')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new Set<String>{'sigmaerpdev__priceBook_for_orders__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'id','name','sigmaerpdev__Product_Price__c','sigmaerpdev__Max_Discount__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new Set<String>{'id','sigmaerpdev__Available_Qty__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('PricebookEntry',new Set<String>{'id','Name','UnitPrice','product2id','Pricebook2Id','ProductCode'}))
            {*/
                Default_Parameters__c Dp = Default_Parameters__c.getInstance('Elift Merchant');
                string priceBook = Dp.priceBook_for_orders__c;
                prodRelList = [select id,name,Product_Price__c,Max_Discount__c,Stock_Item__c,Warranty_Applicable__c,Warranty_Duration__c,Warranty_Interval__c,(Select Discout__c from Product_Prices__r where Customer__c =:customerId),(select id,Available_Qty__c from Product_Inventory__r Limit 1),(select id,UnitPrice,Pricebook2Id,Product2Id,ProductCode from PricebookEntries where product2id =: prodId AND Pricebook2Id =: priceBook) from Product2 where id =: prodId];
            	system.debug('prodRelList::'+prodRelList);
            //}
            return prodRelList;
        }
        @AuraEnabled
        public static List<Inventory_Location_Product_Line_Item__c> fetchILPLIDataForManualSelection(Id prodID)
        {
            List<Inventory_Location_Product_Line_Item__c> fetchinventory= new List<Inventory_Location_Product_Line_Item__c>();
            /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'id','name','sigmaerpdev__Product__c','sigmaerpdev__Available_Quantity__c','sigmaerpdev__Lot__c','sigmaerpdev__Lot__r.Name','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Serial_Number__c','sigmaerpdev__Product_Expiry_Date__c','sigmaerpdev__Received_Date__c','sigmaerpdev__Product_Received_date__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.name','sigmaerpdev__sigmaerpdev__Bin__c','sigmaerpdev__sigmaerpdev__Bin__r.name'}))
            { */
                fetchinventory=[Select id,name,Available_Quantity__c,Lot__c,Lot__r.Name,Product_Serial_Number__r.Serial_Number__c,Received_Date__c,Inventory_Location_Product__r.Inventory_Location__r.Location__r.name,Bin__c,Bin__r.name from Inventory_Location_Product_Line_Item__c where Product__c=:prodID and Available_Quantity__c>0 ORDER BY Product_Expiry_Date__c ASC NULLS LAST,Product_Received_date__c ASC NULLS LAST];
            	system.debug('fetchinventory::'+fetchinventory);
            //}   
            return fetchinventory;
        }
        @AuraEnabled
        public static void deleteIndividualOrderLines(List<OrderItem> StandOrderLines) //,Integer index
        {
            /*if(CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem'))
            {*/
                if(StandOrderLines.size()>0)
                {
                    delete StandOrderLines;
                }
            //}
        }
        
        @auraEnabled
        public static responseWrap saveStandOrder(String so,String sol,boolean autostock,boolean soupdate)
        {
            Savepoint sp;
            responseWrap rw = new responseWrap();
            /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('PricebookEntry')
            && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            && CRUD_FLS_CheckUtility.checkObjCRUD('contact')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Currency__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Currency_Exchange_Rate__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Tax__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Serial_Number__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Dimension_Tag__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('Account')
             
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new Set<String>{'sigmaerpdev__Inventory_Status__c','sigmaerpdev__Auto_Reserve_Stock__c','sigmaerpdev__priceBook_for_orders__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('PricebookEntry',new Set<String>{'id','Name','UnitPrice','product2id','Pricebook2Id','ProductCode'})
            && CRUD_FLS_CheckUtility.checkReadPermission('contact',new Set<String>{'id','Name'})
            && CRUD_FLS_CheckUtility.checkReadPermission('Order',new Set<String>{'sigmaerpdev__Billing_Person__c','Status','EffectiveDate','Pricebook2Id','sigmaerpdev__Auto_Allocate__c','sigmaerpdev__Delivary_Date__c','sigmaerpdev__Currency__c','AccountId','sigmaerpdev__TotalAmount__c','sigmaerpdev__Customer_Email__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Currency__c',new Set<String>{'id','sigmaerpdev__Symbol__c','sigmaerpdev__Currency_Code__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Currency_Exchange_Rate__c',new Set<String>{'id','sigmaerpdev__Rate__c','sigmaerpdev__Currency__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Tax__c',new Set<String>{'sigmaerpdev__Tax_Amount__c','sigmaerpdev__Type__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new Set<String>{'id','name','sigmaerpdev__Delivered_Qty__c','sigmaerpdev__ProductCode__c','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__Available_Qty__c','sigmaerpdev__Comments__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'id','name','sigmaerpdev__Available_Quantity__c','sigmaerpdev__Reserved_Quantity__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Products__c','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Serial_Number__c','sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Status__c','sigmaerpdev__Received_Date__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.name','sigmaerpdev__Lot__c','sigmaerpdev__Lot__r.Name','sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__Delivered_Quantity__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'id','name','sigmaerpdev__Status__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'id','name','sigmaerpdev__Deliver_Quantity__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Dimension_Tag__c',new Set<String>{'id','sigmaerpdev__Ordered_Amount__c','sigmaerpdev__Account__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('Account',new Set<String>{'ShippingStreet','ShippingCity','ShippingState','ShippingPostalcode','ShippingCountry','sigmaerpdev__Email__c','sigmaerpdev__Address__c','sigmaerpdev__City__c','sigmaerpdev__State__c','sigmaerpdev__Country__c','sigmaerpdev__Zip__c'})
            
            && CRUD_FLS_CheckUtility.checkFLS('Account',new Set<String>{'ShippingStreet','ShippingCity','ShippingState','ShippingPostalcode','ShippingCountry'})   
            && CRUD_FLS_CheckUtility.checkFLS('Order',new Set<String>{'sigmaerpdev__Billing_Person__c','sigmaerpdev__Customer_Type__c','Status','EffectiveDate','Pricebook2Id','sigmaerpdev__Auto_Allocate__c','sigmaerpdev__Delivary_Date__c','sigmaerpdev__Currency__c','sigmaerpdev__Customer_Email__c','sigmaerpdev__TotalAmount__c','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Tax__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__Net_Amount__c','sigmaerpdev__Exchange_Net_Amount__c','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Customer_Email__c','sigmaerpdev__BillingStreet__c','sigmaerpdev__BillingCity__c','sigmaerpdev__BillingState__c','sigmaerpdev__BillingPostalCode__c','sigmaerpdev__BillingCountry__c','sigmaerpdev__BillingPersonNew__c'})
            && CRUD_FLS_CheckUtility.checkFLS('OrderItem',new Set<String>{'sigmaerpdev__Net_Quantity__c','sigmaerpdev__IsInventoryUpdated__c','Quantity','sigmaerpdev__TotalPrice__c','sigmaerpdev__Inventory_Status__c','sigmaerpdev__Remaining_Qty_To_Package__c','sigmaerpdev__Unit_Price__c','UnitPrice','sigmaerpdev__Order_Status__c','sigmaerpdev__Stock_Fulfilled__c','sigmaerpdev__Delivired__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Allocation__c',new Set<String>{'sigmaerpdev__ILPLI__c','sigmaerpdev__Order_Product__c','sigmaerpdev__Quantity__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new Set<String>{'sigmaerpdev__Delivered_Qty__c','sigmaerpdev__Available_Qty__c','sigmaerpdev__Comments__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'sigmaerpdev__Reserved_Quantity__c','sigmaerpdev__Delivered_Quantity__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'sigmaerpdev__Status__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev__Deliver_Quantity__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Dimension_Tag__c',new Set<String>{'sigmaerpdev__Ordered_Amount__c'})
            
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('OrderItem',new Set<String>{'OrderId'})
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('Order',new Set<String>{'AccountId'}))
            
            {*/
            try{
                sp = Database.setSavepoint();
               	Boolean insertaddress = true;
                //added to fetch unit price from price book entry object
                Default_Parameters__c Dp = Default_Parameters__c.getInstance('Elift Merchant');
                
                  
                   
                   
                Map<Id,Id> prodIdPriceBookEntryId=new Map<Id,Id>();
                boolean nopickpack =false;
                for(PricebookEntry pbe:[SELECT id,UnitPrice,product2Id FROM PricebookEntry WHERE Pricebook2Id =: Dp.priceBook_for_orders__c])
                {
                  prodIdPriceBookEntryId.put(pbe.product2Id,pbe.id);
                }
               
                Order soDataToSave=(Order)System.JSON.deserialize(so,Order.class);
                
                Double TaxOnBillAmount = 0;
                Account acc = [SELECT ShippingStreet,ShippingCity,ShippingState,ShippingPostalcode,ShippingCountry,Email__c,Address__c,City__c,State__c,Country__c,Zip__c,(Select Address__c,City__c,Country__c,State__c,Zip__c from Shipment_Details__r) from account where id =:soDataToSave.AccountId];
               system.debug('acc 208::'+acc);
         
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
        
        if(insertaddress && soDataToSave.Shipping_Street__c !=null)
        {
          Shipment_Detail__c shipinsert = new Shipment_Detail__c();
          shipinsert.Address__c = soDataToSave.Shipping_Street__c;
          shipinsert.City__c = soDataToSave.ShippingCity__c;
          shipinsert.Country__c = soDataToSave.ShippingCountry__c;
          shipinsert.State__c = soDataToSave.ShippingState__c;
          shipinsert.Zip__c = soDataToSave.ShippingPostalCode__c;
          shipinsert.Account__c = soDataToSave.AccountId;
                    if(acc.Shipment_Details__r.size() == 0)
          shipinsert.Default_Address__c = true;
            system.debug('shipinsert::'+shipinsert);
          insert shipinsert;
        }
        
                
                
                //update  billing address in order
                if(acc.Address__c !=null)
                   soDataToSave.BillingStreet__c = acc.Address__c;
                if(acc.City__c !=null)
                    soDataToSave.BillingCity__c = acc.City__c;
                if(acc.State__c !=null)
                    soDataToSave.BillingState__c = acc.State__c;
                if(acc.Zip__c !=null)
                    soDataToSave.BillingPostalCode__c = acc.Zip__c;
                if(acc.Country__c !=null)
                    soDataToSave.BillingCountry__c = acc.Country__c; 
               
                if(soDataToSave.BillingPersonNew__c!=null)
                    soDataToSave.Billing_Person__c=[select name from contact where id=:soDataToSave.BillingPersonNew__c].name;
                
                if(acc.Email__c!=null)
                {
                    soDataToSave.Customer_Email__c=acc.Email__c;
                }
                soDataToSave.Status='Draft';
                soDataToSave.EffectiveDate=soDataToSave.Delivary_Date__c;
                soDataToSave.Pricebook2Id=Dp.priceBook_for_orders__c;
                soDataToSave.Auto_Allocate__c = autostock; 
                system.debug('soDataToSave::'+soDataToSave);
                upsert soDataToSave;
                
                
                //Currency code added on 18-09-2019
                Currency__c currSymbol = null;
                List<string> soString =new List<string>();   
                List<Order > stdOrder = [select id,Currency__c from Order where Currency__c = :soDataToSave.Currency__c];
                
                for(Order stdList :stdOrder){
                    if(stdList.Currency__c !=null)
                        soString.add(stdList.Currency__c);
                }
                if( soString != null && soString.size() != 0 ) 
                    currSymbol = [select id,Symbol__c,Currency_Code__c from Currency__c where Id =: soString limit 1];
                List<Currency_Exchange_Rate__c> currExRate = [select id,Rate__c,Currency__c from Currency_Exchange_Rate__c where Currency__c =: soString ];
                //End here
                
                Default_Parameters__c Inventory= [select Inventory_Status__c,Auto_Reserve_Stock__c from Default_Parameters__c limit 1 ];
                string inventorystatus = Inventory.Inventory_Status__c;
                
                //Standard order Lines
                List<OrderItem> solList = new List<OrderItem>();
                List<OrderItem> solListToMakeInventoryUpdate = new List<OrderItem>();
                List<OrderItem> confirmedsolList = new List<OrderItem>();
                List<OrderItem> DeliveredsolList = new List<OrderItem>();
                List<StandOrderWrap> solDataToSave=(List<StandOrderWrap>)System.JSON.deserialize(sol,List<StandOrderWrap>.class);
                system.debug('solDataToSave@@'+solDataToSave);
                Map<Id,Boolean> prodIdIsStockItemMap=new Map<Id,Boolean>();
                decimal netQunt=0;
                decimal totalprice=0;
                
                for(StandOrderWrap sow:solDataToSave)
                {
                    //code added to handle both reserve and allocation in default parameter
                    if(sow.orderLines.Net_Quantity__c!=null || sow.orderLines.Net_Quantity__c!=0 && !sow.orderLines.IsInventoryUpdated__c)
                    {
                        
                        netQunt+=sow.orderLines.Quantity;
                        totalprice+=sow.orderLines.TotalPrice__c;
                        
                    }
                    if(sow.orderLines.OrderId==null)
                        sow.orderLines.OrderId=soDataToSave.id;
                    if(inventorystatus == 'Reserve' && sow.orderLines.Inventory_Status__c!='Un Reserved')
                    {
                        sow.orderLines.Inventory_Status__c='Reserve';
                    }
                    else if(sow.orderLines.Inventory_Status__c!='Un Reserved')
                    {
                        sow.orderLines.Inventory_Status__c='Allocated';
                    }
                    if(sow.orderLines.Remaining_Qty_To_Package__c==null)
                        sow.orderLines.Remaining_Qty_To_Package__c=0;
                    if(!sow.orderLines.IsInventoryUpdated__c && inventorystatus == 'Reserve')
                    sow.orderLines.Remaining_Qty_To_Package__c=sow.orderLines.Quantity;
                    if(inventorystatus == 'Allocated')
                    {
                       sow.orderLines.Delivired__c=sow.orderLines.Quantity;
                    }
                    //ends here
                    sow.orderLines.UnitPrice=sow.orderLines.Unit_Price__c;
                    
                    if(sow.orderLines.PriceBookEntryId==null)
                    {
                        
                        sow.orderLines.PriceBookEntryId=prodIdPriceBookEntryId.get(sow.orderLines.Product2Id);
                    }
                    if(sow.orderLines.OrderId==null){
                        sow.orderLines.OrderId=soDataToSave.id;
                    }
                    
                    solList.add(sow.orderLines);
                    
                    prodIdIsStockItemMap.put(sow.orderLines.Product2Id,false);
                    if(sow.orderLines.Order_Status__c== 'Order Confirmed' && sow.orderLines.Quantity>0)
                    {
                        confirmedsolList.add(sow.orderLines);
                    }
                    if(sow.orderLines.Order_Status__c== 'Delivered')
                    {
                        DeliveredsolList.add(sow.orderLines);
                    }
                  
                }
               
                soDataToSave.Net_Quantity__c=netQunt;
                soDataToSave.TotalAmount__c=totalprice;
                
                
                //Code for TAX
                List<Tax__c> taxObj = OrderTaxCntr.getstdorderTax(soDataToSave.Id);
                Double federalTax = Double.valueOf(taxObj.get(0).Tax_Amount__c);
                
                String fedTaxType = String.valueOf(taxObj.get(0).Type__c);
                
                Double stateTax = Double.valueOf(taxObj.get(1).Tax_Amount__c);
               
                String stateTaxType = String.valueOf(taxObj.get(1).Type__c);
               
                if(fedTaxType == 'Percentage'){
                    TaxOnBillAmount = (soDataToSave.TotalAmount__c * federalTax)/100;
                   
                }else{
                    TaxOnBillAmount = soDataToSave.TotalAmount__c + federalTax;
                   
                }               
                if(stateTaxType == 'Percentage'){
                    TaxOnBillAmount = (TaxOnBillAmount + (soDataToSave.TotalAmount__c * stateTax)/100);
                   
                }else{
                    TaxOnBillAmount = (TaxOnBillAmount + (soDataToSave.TotalAmount__c + stateTax));
                   
                }        
                soDataToSave.Tax_Amount__c = TaxOnBillAmount;
                
                soDataToSave.Tax__c = federalTax+stateTax;
                
                string symbol='';
                Double  amt=0;
                
                soDataToSave.Net_Amount__c = soDataToSave.TotalAmount__c + TaxOnBillAmount;
                if(currSymbol!= null){
                    if(currExRate.size() > 0){
                        symbol =currSymbol.Symbol__c;
                        string rateEx = currExRate[0].Rate__c +'';
                        amt= Double.valueOf(rateEx)*soDataToSave.Net_Amount__c;
                        string currStr=symbol+' '+amt;
                        soDataToSave.Exchange_Net_Amount__c = currStr;
                    }
                }
                
                soDataToSave.Order_Created_Via__c = 'POS';
                system.debug('soDataToSave 398::'+soDataToSave);
                upsert soDataToSave;
                system.debug('solList 400::'+solList);
                upsert solList;
               
                //code added to handle Inventory_status as Allocation
                Map<id,decimal> ILPLIIdQuantMap=new Map<Id,Decimal>();
                List<Inventory_Allocation__c> IAListToInsert=new List<Inventory_Allocation__c>();
                Map<Id,Decimal> productQuantityMap=new Map<Id,Decimal>();
                List<OrderItem> solListToUpdateAsAllocated = new List<OrderItem>();
                Map<Id,OrderItem> prodIdSOLMap=new Map<Id,OrderItem>();
                if(inventorystatus =='Reserve')
                {
                    if(soDataToSave.Orders_Status__c!='Pending')
                    {
                        system.debug('in1@@');
                        
                        for(Integer i=0;i<solDataToSave.size();i++)
                        {
                           system.debug('solDataToSave[i].ilpliData@@'+solDataToSave[i].ilpliData);
                            if(solDataToSave[i].orderLines.Order_Status__c =='Order Confirmed' && solDataToSave[i].ilpliData!=null && !solDataToSave[i].orderLines.IsInventoryUpdated__c && solDataToSave[i].orderLines.Stock_Fulfilled__c)
                            {
                               system.debug('inif1@@');   
                                for(ILPLISaveWrap ilplisw:solDataToSave[i].ilpliData)
                                {
                                    if(ilplisw.enteredQuant!=null && ilplisw.enteredQuant!=0){
                                        if(ILPLIIdQuantMap.containskey(ilplisw.id))
                                            ILPLIIdQuantMap.put(ilplisw.id,ILPLIIdQuantMap.get(ilplisw.id)+ilplisw.enteredQuant);
                                        else
                                        ILPLIIdQuantMap.put(ilplisw.id,ilplisw.enteredQuant);
                                        Inventory_Allocation__c indIA=new Inventory_Allocation__c();
                                        indIA.ILPLI__c=ilplisw.id;
                                        indIA.Order_Product__c=solDataToSave[i].orderLines.id;
                                        indIA.Quantity__c=ilplisw.enteredQuant;
                                        IAListToInsert.add(indIA);
                                        system.debug('IAListToInsert@@'+IAListToInsert); 
                                    }
                                }
                            }
                            if(solDataToSave[i].orderLines.Order_Status__c =='Order Confirmed' && !solDataToSave[i].orderLines.IsInventoryUpdated__c && solDataToSave[i].ilpliData!=null && solDataToSave[i].orderLines.Stock_Fulfilled__c)
                            {
                                
                                if(productQuantityMap.containsKey(solDataToSave[i].orderLines.Product2Id))
                                {
                                    productQuantityMap.put(solDataToSave[i].orderLines.Product2Id,(productQuantityMap.get(solDataToSave[i].orderLines.Product2Id)+solDataToSave[i].orderLines.Quantity));
                                }
                                else
                                {
                                    productQuantityMap.put(solDataToSave[i].orderLines.Product2Id,solDataToSave[i].orderLines.Quantity);
                                }
                                if(solDataToSave[i].orderLines.Quantity>0)
                                solDataToSave[i].orderLines.IsInventoryUpdated__c=true;
                                solListToUpdateAsAllocated.add(solDataToSave[i].orderLines);
                            }
                        }
                        if(solListToUpdateAsAllocated.size()>0){
                            system.debug('solListToUpdateAsAllocated@@'+solListToUpdateAsAllocated); 
                            upsert solListToUpdateAsAllocated;
                        }
                        Map<Id,Inventory__c> inventoryMap=new Map<Id,Inventory__c>([select id,name,Delivered_Qty__c,ProductCode__c,Reserved_Qty__c,Available_Qty__c,Comments__c from Inventory__c where ProductCode__c in:productQuantityMap.keySet()]);
                        
                        if(productQuantityMap.size()>0)
                            InventoryManagement.reduceOnlyPI(inventoryMap,productQuantityMap,soDataToSave.No_Picking_Package_Shipment_Required__c);
                        
                       
                        if(ILPLIIdQuantMap.values().size()>0){
                            InventoryManagement.reduceWholeInventory11(ILPLIIdQuantMap,'Reserved_Quantity',soDataToSave.No_Picking_Package_Shipment_Required__c);
                        }
                        
                        if(IAListToInsert.size()>0){
                             system.debug('IAListToInsert@@'+IAListToInsert); 
                            Insert IAListToInsert;
                        }
                        //code for Sigma Finance added by Mahantesh on 21st april 2020 related to when NO pick pack checkbox is true
                        if(soDataToSave.No_Picking_Package_Shipment_Required__c && IAListToInsert.size()>0)
                        {
                            Set<Id> IlpliSet = new Set<Id>();    //stores ilpli id
                            Map<Id,Inventory_Allocation__c> IlpliNIaMap = new Map<Id,Inventory_Allocation__c>();    //stores inventory allocation list
                            Map<Id,Id> IlpliSlIdMap = new Map<Id,Id>();    //key => Ilpli id, value => stock Linkage record id
                            Map<Id,Id> IaSlIdMap = new Map<Id,Id>();    //key => inventory allocation id, value => stock Linkage record id
                            
                            if(IAListToInsert.size() > 0)
                            {
                                for(Inventory_Allocation__c ia : [select id,ILPLI__c,Order_Product__r.Quantity,Quantity__c,Order_Product__c,Order_Product__r.UnitPrice,Order_Product__r.product2.Attribute_Type__c,Order_Product__r.TotalPrice__c,Order_Line__c,Order_Line__r.Total_Price__c,Order_Line__r.Product__c,Order_Line__r.Amount_Per_Interval__c from Inventory_Allocation__c where Id =: IAListToInsert ])
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
                                    SLLI.Sigma_Linkage__c = IaSlIdMap.get(ia);
                                    SLLI.Product__c = IlpliNIaMap.get(ia).Order_Line__r.Product__c;
                                    SLLI.Quantity__c = IlpliNIaMap.get(ia).Quantity__c; 
                                    //SLLI.Total_Sales_Value__c = IlpliNIaMap.get(ia).Order_Product__r.TotalPrice__c;
                                    if(IlpliNIaMap.get(ia).Order_Product__r.product2.Attribute_Type__c == 'SERIALIZED')
                                    {
                                        SLLI.Total_Sales_Value__c = (IlpliNIaMap.get(ia).Order_Product__r.TotalPrice__c/IlpliNIaMap.get(ia).Order_Product__r.Quantity);
                                    }
                                    else
                                    {
                                        SLLI.Total_Sales_Value__c = IlpliNIaMap.get(ia).Order_Product__r.TotalPrice__c;
                                    }
                                    SLLI.Sales_Unit_Price__c = IlpliNIaMap.get(ia).Order_Product__r.UnitPrice;
                                    SLLI.Order_Products__c = IlpliNIaMap.get(ia).Order_Product__c;  
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
                                        System.debug('slListToUpdate:'+slListToUpdate);
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
                            if(solDataToSave[i].orderLines.Order_Status__c =='Order Confirmed' && !solDataToSave[i].orderLines.IsInventoryUpdated__c && solDataToSave[i].orderLines.Stock_Fulfilled__c)
                            { 
                                if(productQuantityMap.containsKey(solDataToSave[i].orderLines.Product2Id))
                                {
                                    productQuantityMap.put(solDataToSave[i].orderLines.Product2Id,(productQuantityMap.get(solDataToSave[i].orderLines.Product2Id)+solDataToSave[i].orderLines.Quantity));
                                }
                                else
                                {
                                    productQuantityMap.put(solDataToSave[i].orderLines.Product2Id,solDataToSave[i].orderLines.Quantity);
                                }
                                solListToUpdateAsAllocated.add(solDataToSave[i].orderLines);
                                prodIdSOLMap.put(solDataToSave[i].orderLines.Product2Id,solDataToSave[i].orderLines);
                                orderlinequnt.put(solDataToSave[i].orderLines.id,solDataToSave[i].orderLines.Quantity);
                            }
                        }
                        
                        Map<Id,Inventory__c> inventoryMap=new Map<Id,Inventory__c>([select id,name,ProductCode__c,Reserved_Qty__c,Available_Qty__c,Delivered_Qty__c from Inventory__c where ProductCode__c in:productQuantityMap.keySet()]);
                        Map<Id,Inventory__c> inventoryUpdateMap=new Map<Id,Inventory__c>();
                        for(Integer i=0; i< inventoryMap.values().size(); i++)
                        {
                            Inventory__c tempInv=inventoryMap.values()[i];
                            if(tempInv.Delivered_Qty__c==null)
                                tempInv.Delivered_Qty__c=0;
                            tempInv.Delivered_Qty__c+=productQuantityMap.get(inventoryMap.values()[i].ProductCode__c);
                            tempInv.Available_Qty__c-=productQuantityMap.get(inventoryMap.values()[i].ProductCode__c);
                            tempInv.Comments__c = 'Inventory updated via Standard Order';
                            inventoryUpdateMap.put(inventoryMap.values()[i].id,tempInv);
                        }
                        if(inventoryUpdateMap.size()>0)
                        {
                            update inventoryUpdateMap.values();
                        }
                        List<Inventory_Location_Product_Line_Item__c> ilpliDataRecieveData= [Select id,name,Bin__c,Available_Quantity__c,Reserved_Quantity__c,Inventory_Location_Product__r.Products__c,Product_Serial_Number__r.Serial_Number__c,Product_Serial_Number__c ,Product_Serial_Number__r.Status__c,Received_Date__c,Inventory_Location_Product__r.Inventory_Location__r.Location__r.name,Lot__c,Lot__r.Name,Inventory_Location_Product__c,Delivered_Quantity__c from Inventory_Location_Product_Line_Item__c where Inventory_Location_Product__r.Products__c=:productQuantityMap.keySet() and  Available_Quantity__c>0 ORDER BY Product_Expiry_Date__c ASC NULLS LAST,Product_Received_date__c ASC NULLS LAST];
                        Map<id,decimal> ILPLIIdQuantMap1 = new Map<id,decimal>();
                        Map<Id,Inventory_Location_Product_Line_Item__c> ilpliIdILPLIMapToUpdate1=new Map<Id,Inventory_Location_Product_Line_Item__c>();
                        Map<Id,decimal> ILPQuant= new Map<id,decimal>();
                        Set<Id>LotId = new Set<Id>();
                        decimal soldquant=0;
                        set<Id> Serialid =new set<Id>();
                        Map<Id,decimal> maplotproforBin= new Map<id,decimal>();
						Map<id,Map<id,decimal>> lotqtyupdate=new Map<id,Map<id,decimal>>();
                        for(Integer i=0;i<solDataToSave.size();i++)
                        {
                            Decimal solQuantCount=solDataToSave[i].orderLines.Quantity;
                            if(solDataToSave[i].orderLines.Order_Status__c=='Order Confirmed' && !solDataToSave[i].orderLines.IsInventoryUpdated__c )
                            {
                                for(Inventory_Location_Product_Line_Item__c ilpli:ilpliDataRecieveData)
                                {
                                    if(ILPLIIdQuantMap1.containsKey(ilpli.id) ? ILPLIIdQuantMap1.get(ilpli.id)!=ilpli.Available_Quantity__c :true)
                                    {
                                        if(solQuantCount==0)
                                            Break;
                                        if(ilpli.Inventory_Location_Product__r.Products__c==solDataToSave[i].orderLines.Product2Id)
                                        {
                                            if(ilpli.Product_Serial_Number__c!=null)
                                            {
                                                Serialid.add(ilpli.Product_Serial_Number__c); 
                                            }
                                              if(ilpli.Lot__c !=null)
                                              {
                                                LotId.add(ilpli.Lot__c);
                                              }
                      
                                            if(ilpli.Available_Quantity__c>=productQuantityMap.get(solDataToSave[i].orderLines.Product2Id))
                                            {
                                                Inventory_Allocation__c indIA=new Inventory_Allocation__c();
                                                indIA.ILPLI__c=ilpli.id;
                                                indIA.Order_Product__c=solDataToSave[i].orderLines.id;
                                                indIA.Quantity__c=orderlinequnt.get(solDataToSave[i].orderLines.id);
                                                IAListToInsert.add(indIA);
                                                System.debug('IAListToInsert:'+IAListToInsert);
                                                if(ilpliIdILPLIMapToUpdate1.containsKey(ilpli.id)){
                                                    ILPLIIdQuantMap1.put(ilpli.id,ILPLIIdQuantMap1.get(ilpli.id)+productQuantityMap.get(solDataToSave[i].orderLines.Product2Id));
                                                }
                                                else{
                                                    ILPLIIdQuantMap1.put(ilpli.id,productQuantityMap.get(solDataToSave[i].orderLines.Product2Id));
                                                }
                                                
                                                if(ilpliIdILPLIMapToUpdate1.containsKey(ilpli.id)){
                                                    Inventory_Location_Product_Line_Item__c tempILPLI=ilpliIdILPLIMapToUpdate1.get(ilpli.id);
                                                   
                                                    tempILPLI.Delivered_Quantity__c+=productQuantityMap.get(solDataToSave[i].orderLines.Product2Id);
                                                    ilpliIdILPLIMapToUpdate1.put(ilpli.id,tempILPLI);
                                                }
                                                else{
                                                    
                                                    ilpli.Delivered_Quantity__c+=productQuantityMap.get(solDataToSave[i].orderLines.Product2Id);
                                                    ilpliIdILPLIMapToUpdate1.put(ilpli.id,ilpli);
                                                }
                                                
                                                if(ILPQuant.containsKey(ilpli.Inventory_Location_Product__c))
                                                {
                                                    ILPQuant.put(ilpli.Inventory_Location_Product__c,ILPQuant.get(ilpli.Inventory_Location_Product__c)+productQuantityMap.get(solDataToSave[i].orderLines.Product2Id));
                                                    
                                                }
                                                else
                                                {
                                                    ILPQuant.put(ilpli.Inventory_Location_Product__c,productQuantityMap.get(solDataToSave[i].orderLines.Product2Id));
                                                }
												if(maplotproforBin.containsKey(ilpli.Bin__c))
                                                {
                                                    system.debug('Inside if Condition');
                                                    maplotproforBin.put(ilpli.Bin__c,maplotproforBin.get(ilpli.Bin__c)+productQuantityMap.get(solDataToSave[i].orderLines.Product2Id));
                                                    
                                                    system.debug('maplotproforBin '+maplotproforBin);
                                                }
                                                else
                                                {
                                                   maplotproforBin.put(ilpli.Bin__c,productQuantityMap.get(solDataToSave[i].orderLines.Product2Id));
                                                   system.debug('maplotproforBinelse@@'+maplotproforBin);
                                                }
												
												if(LotId.size()>0)
											{
											if(lotqtyupdate.containsKey(ilpli.Lot__c))
											{
												if(lotqtyupdate.get(ilpli.Lot__c).containsKey(ilpli.Bin__c))
												{
													decimal qty=lotqtyupdate.get(ilpli.Lot__c).get(ilpli.Bin__c);
													lotqtyupdate.get(ilpli.Lot__c).put(ilpli.Bin__c,qty+productQuantityMap.get(solDataToSave[i].orderLines.Product2Id));
												}
												else
												{
													Map<id,decimal> locid=new Map<id,decimal>();
													lotqtyupdate.get(ilpli.Lot__c).put(ilpli.Bin__c,productQuantityMap.get(solDataToSave[i].orderLines.Product2Id));
												}
											}
											else
											{
												Map<id,decimal> locid=new Map<id,decimal>();
												locid.put(ilpli.Bin__c,productQuantityMap.get(solDataToSave[i].orderLines.Product2Id));
												lotqtyupdate.put(ilpli.Lot__c,locid);
											}
											}
												
												
                                                solQuantCount-=productQuantityMap.get(solDataToSave[i].orderLines.Product2Id);
                                                productQuantityMap.put(ilpli.Inventory_Location_Product__r.Products__c,0);
                                            }
                                            else
                                            {
                                                
                                                decimal tempQuant=ilpli.Available_Quantity__c;
                                                
                                                Inventory_Allocation__c indIA=new Inventory_Allocation__c();
                                                indIA.ILPLI__c=ilpli.id;
                                                indIA.Order_Product__c=solDataToSave[i].orderLines.id;
                                                indIA.Quantity__c=tempQuant;
                                                IAListToInsert.add(indIA);
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
						if(LotId.size()>0)
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
                                                solQuantCount-=tempQuant;
                                                productQuantityMap.put(ilpli.Inventory_Location_Product__r.Products__c,productQuantityMap.get(ilpli.Inventory_Location_Product__r.Products__c)-tempQuant);
                                                orderlinequnt.put(solDataToSave[i].orderLines.id,orderlinequnt.get(solDataToSave[i].orderLines.id)-tempQuant);
                                            }
                                        }
                                    }
                                }
                            }
                        }
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
						 system.debug('updatesoldqunt-->>'+updatesoldqunt);                       
                        update updatesoldqunt;
                        
                        //code to update LOT
            List<Lot_Product__c> lotproduct = new List<Lot_Product__c>();
                       
                        lotproduct = [select id,Product__c,Quantity__c,Location__c,Lot__c,Bin__c from Lot_Product__c where Lot__c =:lotqtyupdate.keySet() ]; 
                        system.debug('aftr querrying lotproduct-->>'+lotproduct);
						system.debug('lotqtyupdate-->>'+lotqtyupdate);
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
                        
                       
                        if(ilpliIdILPLIMapToUpdate1.size()>0)
                        {
                            update ilpliIdILPLIMapToUpdate1.values();
                        }
                        if(IAListToInsert.size()>0)
                        {
                            system.debug('IAListToInsert-->>'+IAListToInsert);
                            Upsert IAListToInsert;
                        }
                        
                        for(OrderItem tempSOL:solListToUpdateAsAllocated){
                            tempSOL.IsInventoryUpdated__c=true;
                        }
                        if(solListToUpdateAsAllocated.size()>0){
                            system.debug('solListToUpdateAsAllocated-->>'+solListToUpdateAsAllocated);
                            upsert solListToUpdateAsAllocated;
                        }  

                        //code for Sigma Finance added by Mahantesh on march 26th 2020 related to when inventory status = "Allocated"
                            
                            Set<Id> IlpliSet = new Set<Id>();    //stores ilpli id
                            Map<Id,Inventory_Allocation__c> IlpliNIaMap = new Map<Id,Inventory_Allocation__c>();    //stores inventory allocation list
                            Map<Id,Id> IlpliSlIdMap = new Map<Id,Id>();    //key => Ilpli id, value => stock Linkage record id
                            Map<Id,Id> IaSlIdMap = new Map<Id,Id>();    //key => inventory allocation id, value => stock Linkage record id
                            
                            if(IAListToInsert.size() > 0)
                            {
                                for(Inventory_Allocation__c ia : [select id,ILPLI__c,Order_Product__r.Quantity,Quantity__c,Order_Product__c,Order_Product__r.UnitPrice,Order_Product__r.product2.Attribute_Type__c,Order_Product__r.TotalPrice__c,Order_Line__c,Order_Line__r.Total_Price__c,Order_Line__r.Product__c,Order_Line__r.Amount_Per_Interval__c from Inventory_Allocation__c where Id =: IAListToInsert ])
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
                                    SLLI.Sigma_Linkage__c = IaSlIdMap.get(ia);
                                    SLLI.Product__c = IlpliNIaMap.get(ia).Order_Line__r.Product__c;
                                    SLLI.Quantity__c = IlpliNIaMap.get(ia).Quantity__c; 
                                    //SLLI.Total_Sales_Value__c = IlpliNIaMap.get(ia).Order_Product__r.TotalPrice__c;
                                    if(IlpliNIaMap.get(ia).Order_Product__r.product2.Attribute_Type__c == 'SERIALIZED')
                                    {
                                        SLLI.Total_Sales_Value__c = (IlpliNIaMap.get(ia).Order_Product__r.TotalPrice__c/IlpliNIaMap.get(ia).Order_Product__r.Quantity);
                                    }
                                    else
                                    {
                                        SLLI.Total_Sales_Value__c = IlpliNIaMap.get(ia).Order_Product__r.TotalPrice__c;
                                    }
                                    SLLI.Sales_Unit_Price__c = IlpliNIaMap.get(ia).Order_Product__r.UnitPrice;
                                    SLLI.Order_Products__c = IlpliNIaMap.get(ia).Order_Product__c;  
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
                    List<Invoice__c> invoicedata = [select id,name,Orderlookup__c,Invoice_Type__c,Customer__c,Invoice_Status__c,(select id,name,Invoice_Number__c,Order_Product__c,Quantity__c,Total_Amount__c,Product__c,Net_Amount__c,Discount__c from Invoice_Items__r) from Invoice__c where Orderlookup__c=:soDataToSave.id];
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
                            Invoiceitemdetails.put(invitem.Order_Product__c,invitem);
                        }
                        system.debug('Invoiceitemdetails@@'+Invoiceitemdetails);
                        
                    }
                    for(OrderItem orderline : solList) 
                    {
                        if(Invoiceitemdetails.containsKey(orderline.id))
                        {
                            Invoice_Item__c InvoiceItems =Invoiceitemdetails.get(orderline.id);
                            InvoiceItems.Quantity__c = orderline.Quantity;
                            InvoiceItems.Total_Amount__c=orderline.TotalPrice__c;
                            InvoiceItems.Product__c=orderline.Product2Id;
                            InvoiceItems.Net_Amount__c = orderline.UnitPrice*orderline.Quantity;
                            if(orderline.Discount__c!=null && orderline.Discount__c>0)
                                InvoiceItems.Discount__c = orderline.Discount__c;
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
                    invoice.Orderlookup__c = soDataToSave.id; 
                    invoice.Invoice_Type__c='Sales Invoice';
                    invoice.Customer__c =soDataToSave.AccountId; 
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
                    for(OrderItem orderline : solList)
                    {
                        Invoice_Item__c invoicedata = new Invoice_Item__c();
                        invoicedata.Invoice_Number__c=invoice.id;
                        invoicedata.Order_Product__c=orderline.id;
                        invoicedata.Quantity__c = orderline.Quantity;
                        invoicedata.Total_Amount__c=orderline.TotalPrice__c;
                        invoicedata.Product__c=orderline.Product2Id;
                        invoicedata.Net_Amount__c = orderline.UnitPrice*orderline.Quantity;
                        if(orderline.Discount__c!=null && orderline.Discount__c>0)
                        invoicedata.Discount__c = orderline.Discount__c;
                        Invoiceitem.add(invoicedata);
                    }
                    if(Invoiceitem.size()>0)
                        insert Invoiceitem;
                }
                //CODE END
        
        
        
        
                
                Boolean retval=false;
                String type='';
                decimal totalorderamount =0;
               
                try{
                    if(soDataToSave.Customer_Type__c=='Credit Customer' && soDataToSave.Order_Created_Via__c == 'POS'){
                        List<OrderItem>orderlinedata =[select id,TotalPrice__c,Is_Credit_Updated__c,Order_Status__c from OrderItem where Is_Credit_Updated__c =false and Order_Status__c = 'Order Confirmed' and OrderId=:soDataToSave.id];
                        system.debug('orderlinedata@@'+orderlinedata);
                        for(OrderItem POPB :orderlinedata)
                        {
                            if(POPB.Is_Credit_Updated__c == false && POPB.Order_Status__c =='Order Confirmed')
                            {
                                totalorderamount += POPB.TotalPrice__c;
                                POPB.Is_Credit_Updated__c = true;
                            }
                        }
                        
                        
                        Dimension_Tag__c dimTag;
                        try{
                            dimTag=[select id,Ordered_Amount__c from Dimension_Tag__c where Account__c=:soDataToSave.AccountId limit 1];
                           system.debug('dimTag@@'+dimTag);
                        }
                        catch(Exception e){
                            
                        }
                        
                        if(dimTag!=null){
                            if(dimTag.Ordered_Amount__c==null)
                                dimTag.Ordered_Amount__c=0;
                            if(totalorderamount>0)
                                dimTag.Ordered_Amount__c+=totalorderamount;
                                update dimTag;
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
                          createErrorLog.insertError('Order',exc.getMessage(),'While Updating Dimension tag Ordered amount',null,'',exc.getStackTraceString(),UserInfo.getUserId());
                    }
                    catch(Exception ex)
                    {
                    }
                }            
                rw.message = 'success';
                rw.data = soDataToSave.Id;
                rw.soName=[select name from Order where id=:soDataToSave.id].Name;//soDataToSave.Name not returning the Name of SO. so written query to fetch the SO name.
                return rw;
            }
            catch(Exception e)
            {
                Database.rollback(sp);
                try{
                     createErrorLog.insertError('Order',e.getMessage(),'While Saving',null,'',e.getStackTraceString(),UserInfo.getUserId());
                }
                catch(Exception ex)
                {
                }
                
                rw.message = 'error';
                rw.data = e.getMessage()+ ', At Line number '+e.getStackTraceString();
                return rw;
            }
        
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
        public class StandOrderWrap
        {
            @auraEnabled
            public Boolean hasBackOrder;
            @auraEnabled
            public Boolean isDisabled;
            @auraEnabled
            public Boolean isDisplay;
            @auraEnabled
            public OrderItem orderLines;
            @auraEnabled
            public List<ILPLISaveWrap> ilpliData;
            //added newly for AutoReserve
            @auraEnabled
            public String stockExist;
        }
        public class StandOrderUpdateWrap
        {
            @auraEnabled
            public Order standOrder;
            @auraEnabled
            public List<StandOrderLinesUpdateWrap> solWrap;
            @auraEnabled
            public Dimension_Tag__c credituser;
        }
        public class StandOrderLinesUpdateWrap
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
            public OrderItem orderLines;
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
        public static StandOrderUpdateWrap getStandOrderData(String soId)
        {
            StandOrderUpdateWrap soEdit = new StandOrderUpdateWrap();
           /* if(CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Dimension_Tag__c')
            
            && CRUD_FLS_CheckUtility.checkReadPermission('Order',new Set<String>{'id','name','sigmaerpdev__TotalAmount__c','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Is_Payment_Made__c','sigmaerpdev__Net_Amount__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__Tax__c','sigmaerpdev__Paid_Amount__c','AccountId','Account.name','sigmaerpdev__Customer_Type__c','sigmaerpdev__Orders_Status__c','BillToContactId','BillToContact.name','sigmaerpdev__ShippingCity__c','sigmaerpdev__ShippingCountry__c','sigmaerpdev__ShippingState__c','sigmaerpdev__ShippingPostalCode__c','sigmaerpdev__Shipping_Street__c','sigmaerpdev__Delivary_Date__c','sigmaerpdev__BillingPersonNew__c','sigmaerpdev__BillingPersonNew__r.Name','sigmaerpdev__No_Picking_Package_Shipment_Required__c','sigmaerpdev__Currency__c','sigmaerpdev__Currency__r.Name','sigmaerpdev__Currency__r.sigmaerpdev__Display_Name__c','sigmaerpdev__Auto_Allocate__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new Set<String>{'id','name','sigmaerpdev__Splited_Order_Line__c','sigmaerpdev__Stock_Fulfilled__c','PriceBookEntryId','Product2Id','Product2.Name','sigmaerpdev__Net_Quantity__c','Quantity','sigmaerpdev__Unit_Price__c','sigmaerpdev__Discount__c','sigmaerpdev__Delivery_Date__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Back_Order__c','sigmaerpdev__IsInventoryUpdated__c','TotalPrice','sigmaerpdev__TotalPrice__c','sigmaerpdev__Back_Order__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Dimension_Tag__c',new Set<String>{'id','sigmaerpdev__Remaining_Credit_Limit__c','sigmaerpdev__Account__c'}))
            { */
                
                List<StandOrderLinesUpdateWrap> solWraplList=new List<StandOrderLinesUpdateWrap>();
                soEdit.standOrder=[select id,Name,TotalAmount__c,Order_Created_Via__c,Is_Payment_Made__c,Net_Amount__c,Tax_Amount__c,Tax__c,Paid_Amount__c,AccountId,Account.name,Customer_Type__c,Orders_Status__c,BillToContactId,BillToContact.name,ShippingCity__c,ShippingCountry__c,ShippingState__c,ShippingPostalCode__c,Shipping_Street__c,Delivary_Date__c,BillingPersonNew__c,BillingPersonNew__r.Name,No_Picking_Package_Shipment_Required__c,Currency__c,Currency__r.Name,Currency__r.Display_Name__c,Auto_Allocate__c from Order where id=:soId limit 1];
                
                if(soEdit.standOrder.Customer_Type__c == 'Credit Customer')
                {
                    soEdit.credituser =[select id,name,Remaining_Credit_Limit__c,Account__c from Dimension_Tag__c where Account__c =:soEdit.standOrder.AccountId limit 1];
                    
                }
                for(OrderItem  sol:[select id,Stock_Fulfilled__c,Inventory_Status__c,Splited_Order_Line__c,OrderId,PriceBookEntryId,Product2Id,Product2.Name,Net_Quantity__c,Quantity,Unit_Price__c,Discount__c,Delivery_Date__c,Order_Status__c,Back_Order__c,IsInventoryUpdated__c,TotalPrice,TotalPrice__c,Remaining_Qty_To_Package__c,Service_Duration__c,Service_Interval__c,Service_Start_Date__c,Service_End_Date__c,Product_Duration__c,Product_Interval__c,Product_Warranty_End_Date__c,Product_Warranty_Start_Date__c,Warranty_Created__c from OrderItem where OrderId =:soId])
                {
                    
                    StandOrderLinesUpdateWrap solList=new StandOrderLinesUpdateWrap();
                    solList.productName=sol.Product2.name;
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
               
                soEdit.solWrap=solWraplList;
            //}
            return soEdit;
        }
        
        //code added on 28/08/2019
        @AuraEnabled
        public static List<StandOrderWrap> automateStockReservation(String so, String sol){   
        
        List<StandOrderWrap> solDataToSave = (List<StandOrderWrap>)System.JSON.deserialize(sol,List<StandOrderWrap>.class);             
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Dimension_Tag__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
            
            && CRUD_FLS_CheckUtility.checkReadPermission('Order',new Set<String>{'id','name','sigmaerpdev__TotalAmount__c','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Is_Payment_Made__c','sigmaerpdev__Net_Amount__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__Tax__c','sigmaerpdev__Paid_Amount__c','AccountId','Account.name','sigmaerpdev__Customer_Type__c','sigmaerpdev__Orders_Status__c','BillToContactId','BillToContact.name','sigmaerpdev__ShippingCity__c','sigmaerpdev__ShippingCountry__c','sigmaerpdev__ShippingState__c','sigmaerpdev__ShippingPostalCode__c','sigmaerpdev__Shipping_Street__c','sigmaerpdev__Delivary_Date__c','sigmaerpdev__BillingPersonNew__c','sigmaerpdev__BillingPersonNew__r.Name','sigmaerpdev__No_Picking_Package_Shipment_Required__c','sigmaerpdev__Currency__c','sigmaerpdev__Currency__r.Name','sigmaerpdev__Currency__r.sigmaerpdev__Display_Name__c','sigmaerpdev__Auto_Allocate__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new Set<String>{'id','name','sigmaerpdev__Stock_Fulfilled__c','PriceBookEntryId','Product2Id','Product2.Name','sigmaerpdev__Net_Quantity__c','Quantity','sigmaerpdev__Unit_Price__c','sigmaerpdev__Discount__c','sigmaerpdev__Delivery_Date__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Back_Order__c','sigmaerpdev__IsInventoryUpdated__c','TotalPrice','sigmaerpdev__TotalPrice__c','sigmaerpdev__Back_Order__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Dimension_Tag__c',new Set<String>{'id','sigmaerpdev__Remaining_Credit_Limit__c','sigmaerpdev__Account__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'id','name','sigmaerpdev__Available_Quantity__c','sigmaerpdev__Lot__c','sigmaerpdev__Lot__r.Name','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Serial_Number__c','sigmaerpdev__Received_Date__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.name','sigmaerpdev__Inventory_Location_Product__r.Id','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Products__c','sigmaerpdev__Product_Expiry_Date__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'id','name','sigmaerpdev__Products__c'}))
        { */ 
            String stockExists = 'true'; //suggests whether there is not enough stock to do allocation or not
            Order soDataToSave=(Order)System.JSON.deserialize(so,Order.class);
            Map<id,List<Inventory_Location_Product_Line_Item__c>> IlpandILPLIListMap = new Map<id,List<Inventory_Location_Product_Line_Item__c>>(); //store Product and its respective ILPs
            Map<id,List<Inventory_Location_Product__c>> prodIlpMap = new Map<id,List<Inventory_Location_Product__c>>(); //store Product and its respective ILPs
            Map<Integer,Map<Id,Decimal>> prodMap = new Map<Integer,Map<Id,Decimal>>();
            Set<Id> prodIdSet = new Set<Id>();
            Map<Id,String> prodNameMap = new Map<Id,String>(); 
            Map<Id,String> ilpListMap1 = new Map<Id,String>(); 
            List<Id> prodIdList = new List<Id>();
            Decimal qn =0;
            Map<Integer, Map<Id,Decimal>> rowProdILPLIAlloc = new Map<Integer, Map<Id,Decimal>>();
            
            for(Integer i=0;i < solDataToSave.size();i++){
               
                    Id prodId = solDataToSave[i].orderLines.Product2Id;
                    if((solDataToSave[i].orderLines.Order_Status__c== 'Order Confirmed') && solDataToSave[i].orderLines.Stock_Fulfilled__c && !solDataToSave[i].orderLines.IsInventoryUpdated__c)
                    {
                        qn = solDataToSave[i].orderLines.Quantity;  
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
            System.debug('prodIlpMap==='+prodIlpMap);
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
                    system.debug('reqProductQuantityMap1@@'+reqProductQuantityMap1);
                if(prodIlpMap.size()>0)
                {
                    for(Inventory_Location_Product__c recordILPId : prodIlpMap.get(recordId)){
                        if(IlpandILPLIListMap.get(recordILPId.Id) != null){
                            for(Inventory_Location_Product_Line_Item__c allocateProd : IlpandILPLIListMap.get(recordILPId.Id)){
                                                            
                                requiredQuantity = reqProductQuantityMap1.get(recordId); 
                                
                                if(requiredQuantity != 0.0){
                                    allocatingQuantity = allocateProd.Available_Quantity__c;                                    
                                    if(allocatingQuantity <= requiredQuantity && allocatingQuantity != 0){
                                        if(allocateProd.Available_Quantity__c != null){
                                                                                      
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
                
               // for(Integer i=0; i < solDataToSave.size(); i++){
                 //   solDataToSave[i].ilpliData = prodILPLIAllocListMap.get(i);
                  //  system.debug('ilpdata@@'+ solDataToSave[i].ilpliData);
                //}
                for(Integer i=0; i < solDataToSave.size(); i++){
					integer j=0;
					if(solDataToSave[i].orderLines.Order_Status__c=='Order Confirmed' && solDataToSave[i].orderLines.Stock_Fulfilled__c && !solDataToSave[i].orderLines.IsInventoryUpdated__c)
					{
						solDataToSave[i].ilpliData = prodILPLIAllocListMap.get(j);
						j++;
					}
                    
                }
                solDataToSave[0].stockExist = stockExists;
            }
        //}
            system.debug('solDataToSave@@'+solDataToSave);
        return solDataToSave;
        }
    }