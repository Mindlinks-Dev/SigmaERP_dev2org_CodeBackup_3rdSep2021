public with sharing class CatalogOrderController 
{
  @AuraEnabled
  public static completeProductWrapper searchProducts(String SearchKeyword, Integer offsetValue, String SelectedProductType, Decimal pageNumber)
  {
      
      completeProductWrapper Cmplwraps = new completeProductWrapper();
      /*if(
        CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Vendor_Product__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('ContentDocumentLink')
          //&& CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Community_Configuration__c')
          
            && CRUD_FLS_CheckUtility.checkReadPermission('ContentDocumentLink',new set<String>{'id','ContentDocumentId','ContentDocument.FileExtension','ContentDocument.LatestPublishedVersionId','ContentDocument.LatestPublishedVersion.Title','SystemModstamp','LinkedEntityId','Visibility','ShareType'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Community_Configuration__c',new set<String>{'Id','Name','sigmaerpdev__Retailer_Community_URL__c','sigmaerpdev__Products_Per_Page__c','sigmaerpdev__Retailer_Profile_Name__c','sigmaerpdev__Vendor_Community_URL__c','sigmaerpdev__Vendor_Profile_Name__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'id','Name','sigmaerpdev__Stock_Item__c','sigmaerpdev__Product_Price__c','sigmaerpdev__Bar_Code_Gene__c','sigmaerpdev__Attribute_Type__c','sigmaerpdev__Product_Type__c','sigmaerpdev__Type__c','sigmaerpdev__Reorder_Quantity__c','sigmaerpdev__Threshold_Quantity__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new set<String>{'id','sigmaerpdev__Available_Qty__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Vendor_Product__c',new set<String>{'id','sigmaerpdev__Buying_Price__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('Attachment',new set<String>{'id'})
            
            )*/
        {
                //Query starts
            String qryPbProNames='select Name from Product2';    //to get unique set of product name within the given limit
            String qryPbProDetails='select id,Name,Stock_Item__c,Product_Price__c,Bar_Code_Gene__c,Attribute_Type__c,Product_Type__c,Type__c,Reorder_Quantity__c,Threshold_Quantity__c, (SELECT Id FROM Attachments),(SELECT Id,Available_Qty__c from Product_Inventory__r),(SELECT Id,Buying_Price__c from Vendor_Products__r) from Product2';
            String qryPbProWhereClause = ' where Stock_Item__c =true ';
            
            String qryCount=' select COUNT_DISTINCT(Name) totalCount from Product2 where Stock_Item__c =true ';
            
            List<Community_Configuration__c> Custset= new List<Community_Configuration__c>();
            Custset = [select Id,Name,Retailer_Community_URL__c,Products_Per_Page__c,Retailer_Profile_Name__c,Vendor_Community_URL__c,Vendor_Profile_Name__c from Community_Configuration__c where Name = 'Community Configurations' LIMIT 1];
            if(SelectedProductType !=null)
            {
                qryPbProWhereClause+='AND Product_Type__c=\''+SelectedProductType+'\'';
                qryCount+=' AND Product_Type__c=\''+SelectedProductType+'\'';
            }
            
            //this part should always be at last to prevent offset and limit attribute during search by product names
            if(SearchKeyword!=null && SearchKeyword!='')
            {
                SearchKeyword ='%'+searchKeyWord +'%';
                qryPbProWhereClause+=' AND Name Like \''+SearchKeyword+'\'';
                qryCount+=' AND Name Like \''+SearchKeyword+'\'';
            }
            
            qryPbProNames=qryPbProNames + qryPbProWhereClause;
            
            Integer pageRecSize = Integer.valueOf(Custset[0].Products_Per_Page__c);
            if(SearchKeyword!=null && SearchKeyword!='')  //if searching product name don't include limit and offset
            {
                pageNumber = 1;
                pageRecSize = 200;  //changes specific to search by name feature
                qryPbProNames=qryPbProNames + ' group by Name order by name ';
            }
            else
            {
                qryPbProNames=qryPbProNames + ' group by Name order by name Limit ' + Custset[0].Products_Per_Page__c +' OFFSET:offset';
            }
            
            //code added for Pagination
            Integer offset = ((Integer)pageNumber - 1) * pageRecSize;
            Cmplwraps.totalRecords = Integer.valueOf(Database.query(qryCount)[0].get('totalCount'));
            Cmplwraps.pageSize = pageRecSize;
            Cmplwraps.pageNumber = (Integer) pageNumber;
            //executing Query to get price specification book names
            List<AggregateResult> listofprodNames = (Database.query(qryPbProNames));    //to get unique names of products with given limit in query
            
            Set<String> pruductNameSet = new Set<String>();
            for(AggregateResult priceBookPro : listofprodNames)
            {
                pruductNameSet.add( String.valueOf( priceBookPro.get('Name') ) );
            }
            //executing Query to get price specification book details
            qryPbProDetails=qryPbProDetails + qryPbProWhereClause+ ' AND Name IN:pruductNameSet order by name';
            List<Product2> ProductList = (Database.query(qryPbProDetails));   //to get unique names of products with given limit in query
            
            List<ProductWrapper> productLists = new List<ProductWrapper>();
            List<ResponseWrapper> Respwrap = new List<ResponseWrapper>();           
            //to store product family form pricebook product
            Set<String> proFamily= new Set<String>();
            SET<ID> ProdId=new SET<ID>();
            Map<Id,Id> ProdImalink= new Map<Id,Id>();
            
            
            if(ProductList.size() > 0)
            {
                for(Product2 ProdIDsss : ProductList)
                {
                    ProdId.add(ProdIDsss.Id);
                }
                for(ContentDocumentLink Contelink : [SELECT Id, ContentDocumentId,ContentDocument.FileExtension, ContentDocument.LatestPublishedVersionId,ContentDocument.LatestPublishedVersion.Title,SystemModstamp,LinkedEntityId,Visibility,ShareType FROM ContentDocumentLink WHERE LinkedEntityId IN: ProdId and ContentDocument.FileExtension IN ('jpg','png') order by SystemModstamp ASC])
                {
                    ProdImalink.put(Contelink.LinkedEntityId,Contelink.ContentDocument.LatestPublishedVersionId);
                }
                        ResponseWrapper RespWrapper = new ResponseWrapper();
                    for(Product2 Prods : ProductList)
                    {
                        ProductWrapper ProdL= new ProductWrapper();
                        
                          if(Custset.size() > 0)
                          {
                            ProdL.retailerProfile = Custset[0].Retailer_Profile_Name__c;
                            ProdL.VendorProfile = Custset[0].Vendor_Profile_Name__c;
                            ProdL.retailerCommURL = Custset[0].Retailer_Community_URL__c;
                            ProdL.VendorCommURL = Custset[0]. Vendor_Community_URL__c;
                          }
                        ProdL.id = Prods.id;
                        ProdL.Name = Prods.Name;
                        ProdL.producttype = Prods.Product_Type__c;
                        if(Prods.Product_Inventory__r.size() >0)
                        ProdL.AvailableQuantity = Prods.Product_Inventory__r[0].Available_Qty__c;
                        ProdL.productfamily = Prods.Bar_Code_Gene__c;
                        ProdL.ProductPrice = Prods.Product_Price__c;
                        if(ProdImalink.containsKey(Prods.id))
                        {
                            ProdL.Attachementsid = ProdImalink.get(Prods.id);
                            ProdL.ProductImageAvail = true;
                        }
                        else
                        {
                            ProdL.ProductImageAvail = false;
                        }
                        
                        if(Prods.Product_Price__c != null)
                        productLists.add(ProdL);
                    }
                    Cmplwraps.productList = productLists;
                    Cmplwraps.pageSize = pageRecSize;
                    Cmplwraps.pageNumber = Integer.valueof(PageNumber);
                    Cmplwraps.totalRecords = ProductList.size();
                    RespWrapper.Status = 'SUCCESS';
                    Respwrap.add(RespWrapper);
                    Cmplwraps.ResponseWrapperList = Respwrap;
            }
            else{
                ResponseWrapper RespWrapper = new ResponseWrapper();
                RespWrapper.Status = 'ERROR';
                RespWrapper.errorMessage = 'Sorry, no results found! Please check the spelling or try searching for something else';
                Respwrap.add(RespWrapper);
                Cmplwraps.ResponseWrapperList = Respwrap;
                return Cmplwraps;
            }
            
        }
        return Cmplwraps;
  }

    @AuraEnabled
    public Static List<String> retailerCodeDisplay()
    {
        List<String> pickListValuesList= new List<String>();
        //if( CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'id','Name','sigmaerpdev__Product_Type__c'}))
        {
            Schema.DescribeFieldResult fieldResult = Product2.Product_Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                pickListValuesList.add(pickListVal.getLabel());
            }     
        }
        return pickListValuesList;
    }
    @AuraEnabled
    public static completeProductWrapper getProductList(String ProdType, String PageNumber)
    {
        completeProductWrapper Cmplwrap = new completeProductWrapper();
		System.debug(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')+' '+CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Vendor_Product__c')+' '+CRUD_FLS_CheckUtility.checkObjCRUD('ContentDocumentLink')+' '+CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Community_Configuration__c'));
        /*if(
        CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Vendor_Product__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('ContentDocumentLink')
        //&& CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Community_Configuration__c')
      
        && CRUD_FLS_CheckUtility.checkReadPermission('ContentDocumentLink',new set<String>{'id','ContentDocumentId','ContentDocument.FileExtension','ContentDocument.LatestPublishedVersionId','ContentDocument.LatestPublishedVersion.Title','SystemModstamp','LinkedEntityId','Visibility','ShareType'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Community_Configuration__c',new set<String>{'Id','Name','sigmaerpdev__Retailer_Community_URL__c','sigmaerpdev__Products_Per_Page__c','sigmaerpdev__Retailer_Profile_Name__c','sigmaerpdev__Vendor_Community_URL__c','sigmaerpdev__Vendor_Profile_Name__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'id','Name','sigmaerpdev__Stock_Item__c','sigmaerpdev__Product_Price__c','sigmaerpdev__Bar_Code_Gene__c','sigmaerpdev__Attribute_Type__c','sigmaerpdev__Product_Type__c','sigmaerpdev__Type__c','sigmaerpdev__Reorder_Quantity__c','sigmaerpdev__Threshold_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new set<String>{'id','sigmaerpdev__Available_Qty__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Vendor_Product__c',new set<String>{'id','sigmaerpdev__Buying_Price__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('Attachment',new set<String>{'id'}))
    */
        {
            List<ProductWrapper> ProdList = new List<ProductWrapper>();
            List<Community_Configuration__c> Custset= new List<Community_Configuration__c>();
            Custset = [select Id,Name,Products_Per_Page__c,Retailer_Community_URL__c,Retailer_Profile_Name__c,Vendor_Community_URL__c,Vendor_Profile_Name__c from Community_Configuration__c where Name = 'Community Configurations' LIMIT 1];
            integer i = 0;
            Integer pageRecSize = Integer.valueOf(Custset[0].Products_Per_Page__c);
            Integer offset = (Integer.valueof(pageNumber) - 1) * pageRecSize;
            List<Product2> ProductList = new List<Product2>();
            List<Product2> ProductListCount = new List<Product2>();
            SET<ID> ProdId=new SET<ID>();
            Map<Id,Id> ProdImalink= new Map<Id,Id>();
            
            ProductList = [select id,Name,Stock_Item__c,Product_Price__c,Bar_Code_Gene__c,Attribute_Type__c,Product_Type__c,Type__c,Reorder_Quantity__c,Threshold_Quantity__c, (SELECT Id FROM Attachments),(SELECT Id,Available_Qty__c from Product_Inventory__r),(SELECT Id,Buying_Price__c from Vendor_Products__r) from Product2 where Product_Type__c =: ProdType AND Stock_Item__c =true and Product_Price__c != null Order by Name LIMIT : pageRecSize OFFSET:offset];
            for(Product2 ProdIDsss : [select id, Name from Product2 where Product_Type__c =: ProdType AND Stock_Item__c =true and Product_Price__c != null])
            {
                ProductListCount.add(ProdIDsss);
                ProdId.add(ProdIDsss.Id);
            }
            for(ContentDocumentLink Contelink : [SELECT Id, ContentDocumentId,ContentDocument.FileExtension, ContentDocument.LatestPublishedVersionId,ContentDocument.LatestPublishedVersion.Title,SystemModstamp,LinkedEntityId,Visibility,ShareType FROM ContentDocumentLink WHERE LinkedEntityId IN: ProdId and ContentDocument.FileExtension IN ('jpg','png') order by SystemModstamp ASC])
            {
                ProdImalink.put(Contelink.LinkedEntityId,Contelink.ContentDocument.LatestPublishedVersionId);
            }   
            if(ProductList.size() > 0)
            {
                for(Product2 Prods : ProductList)
                {
                  ProductWrapper ProdL= new ProductWrapper();
                  if(Custset.size() > 0)
                  {
                    ProdL.retailerProfile = Custset[0].Retailer_Profile_Name__c;
                    ProdL.VendorProfile = Custset[0].Vendor_Profile_Name__c;
                    ProdL.retailerCommURL = Custset[0].Retailer_Community_URL__c;
                    ProdL.VendorCommURL = Custset[0]. Vendor_Community_URL__c;
                  }
                    ProdL.id = Prods.id;
                    ProdL.Name = Prods.Name;
                    ProdL.producttype = Prods.Product_Type__c;
                    if(Prods.Product_Inventory__r.size() >0)
                    ProdL.AvailableQuantity = Prods.Product_Inventory__r[0].Available_Qty__c;
                    ProdL.productfamily = Prods.Bar_Code_Gene__c;
                    ProdL.ProductPrice = Prods.Product_Price__c;
                    if(ProdImalink.containsKey(Prods.id))
                    {
                        ProdL.Attachementsid = ProdImalink.get(Prods.id);
                        ProdL.ProductImageAvail = true;
                    }
                    else
                    {
                       ProdL.ProductImageAvail = false; 
                    }
                    
                    if(Prods.Product_Price__c != null)
                    ProdList.add(ProdL);
                }
                Cmplwrap.productList = ProdList;
                Cmplwrap.pageSize = pageRecSize;
                Cmplwrap.pageNumber = Integer.valueof(PageNumber);
                Cmplwrap.totalRecords = ProductListCount.size();
            }
            
        }
        return Cmplwrap;
    }
    @AuraEnabled
    public static String saveSO(String ProductId, String ProductPrice, String Avlquantity, String EnteredQuantity)
    {
        /*if( CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Vendor_Product__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
        
        && CRUD_FLS_CheckUtility.checkReadPermission('User',new set<String>{'id','Name','ContactId','Contact.Name','Contact.Account.Name'})
        && CRUD_FLS_CheckUtility.checkReadPermission('Contact',new set<String>{'id','Name','AccountId'})
        && CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'id','sigmaerpdev__Email__c','sigmaerpdev__Exchange_Currency__c','name','sigmaerpdev__Customer_Type__c','sigmaerpdev__Currency_code__c','ShippingAddress'})
        && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'id','Name','sigmaerpdev__Product_Price__c','sigmaerpdev__Type__c','sigmaerpdev__Retail_Price__c','sigmaerpdev__Selling_Price__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new set<String>{'id','sigmaerpdev__Available_Qty__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Vendor_Product__c',new set<String>{'id','sigmaerpdev__Buying_Price__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('Attachment',new set<String>{'id'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'id','name','Auto_Allocate__c','sigmaerpdev__Currency__c','sigmaerpdev__Customer_Email__c','sigmaerpdev__Shipping_Street__c','sigmaerpdev__ShippingState__c','sigmaerpdev__ShippingPostalCode__c','sigmaerpdev__ShippingCountry__c','sigmaerpdev__Customer_Type__c','sigmaerpdev__ShippingCity__c','sigmaerpdev__AccountId__c','sigmaerpdev__BillingPersonNew__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Order_Type__c','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Delivary_Date__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'id','name','sigmaerpdev__Inventory_Status__c','sigmaerpdev__Back_Order__c','sigmaerpdev__Ordered_Amount__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Quantity__c','sigmaerpdev__Product__c','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Total_Amount__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new set<String>{'id','name','sigmaerpdev__ProductCode__c','sigmaerpdev__ProductCode__r.Name','sigmaerpdev__Available_Qty__c'})
        
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sigma_Order__c',new set<String>{'sigmaerpdev__BillingPersonNew__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Order_Type__c','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Delivary_Date__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev__Product__c','sigmaerpdev__Inventory_Status__c','sigmaerpdev__Quantity__c','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Remaining_Qty_To_Package__c','sigmaerpdev__Total_Amount__c','sigmaerpdev__Total_Price__c','sigmaerpdev__Ordered_Amount__c','sigmaerpdev__Back_Order__c'})
        
        && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev__Sigma_Order__c'})
        && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Sigma_Order__c',new Set<String>{'sigmaerpdev__AccountId__c'})
                
        )*/
    {
            Id UserId= UserInfo.getUserId();
        System.debug('UserId'+UserId);
            User currentuser = [select Id,ContactId,Name,Contact.Name,Contact.Account.Name from User where id =: UserId];
            Map<String,Decimal> ProdInvMap = new Map<String,Decimal>();
            Map<String,List<Product_Order_Price_Book__c>> ProdOrderMap = new Map<String,List<Product_Order_Price_Book__c>>();
            Contact ConId = [select id,Name from Contact where id =:currentuser.ContactId ];
            Account Acc = [select id,Email__c,Exchange_Currency__c,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Customer_Type__c,Currency_code__c from Account where Id =: currentuser.Contact.AccountId];
            Product2 Prod = [select id,Product_Price__c,Name,Type__c, Retail_Price__c, Selling_Price__c from Product2 where id =: ProductId];
            List<Sigma_Order__c> SaleOdList=new List<Sigma_Order__c>();
            List<Product_Order_Price_Book__c> SalOrdItems = new List<Product_Order_Price_Book__c>();
            SaleOdList = [select id,AccountId__c, BillingPersonNew__c, Orders_Status__c, Order_Type__c,Order_Created_Via__c, Delivary_Date__c from Sigma_Order__c where AccountId__c =: Acc.id AND Orders_Status__c = 'Pending' AND Order_Created_Via__c = 'Community'];
            Id SOID;
            SET<ID> Orderset = new SET<ID>();
            SET<ID> Productset = new SET<ID>();
            SET<ID> AccIDset = new SET<ID>();
            AccIDset.add(Acc.Id);
            Id recordTypeIds = Schema.SObjectType.Sigma_Order__c.getRecordTypeInfosByDeveloperName()
                          .get('Product_Order').getRecordTypeId();
            for(Inventory__c ProdInv : [select Id,name,ProductCode__c,ProductCode__r.Name,Available_Qty__c from Inventory__c where ProductCode__c != null])
            {
                if(ProdInv.ProductCode__r.Name != null && ProdInv.ProductCode__r.Name !='')
                ProdInvMap.put(ProdInv.ProductCode__c, ProdInv.Available_Qty__c);
            }
            Decimal AvlQunt = ProdInvMap.get(ProductId);
            if(SaleOdList.size() == 0)
            {
                Sigma_Order__c SigOrder=new Sigma_Order__c();
                SigOrder.AccountId__c = Acc.id;
                SigOrder.BillingPersonNew__c = ConId.Id;
                SigOrder.Orders_Status__c = 'Pending';
                SigOrder.Order_Created_Via__c = 'Community';
                SigOrder.Delivary_Date__c = System.Today();
                SigOrder.Customer_Email__c = Acc.Email__c;
                SigOrder.Shipping_Street__c = Acc.ShippingStreet;
                SigOrder.ShippingState__c = Acc.ShippingState;
                SigOrder.ShippingPostalCode__c = Acc.ShippingPostalCode;
                SigOrder.ShippingCountry__c = Acc.ShippingCountry;
                SigOrder.ShippingCity__c = Acc.ShippingCity;
                SigOrder.RecordTypeId = recordTypeIds;
                SigOrder.Order_Type__c = 'Online';
                SigOrder.Customer_Type__c = Acc.Customer_Type__c;
                SigOrder.Auto_Allocate__c = true;
                SigOrder.Currency__c = Acc.Exchange_Currency__c;
                insert SigOrder;
                SOID = SigOrder.Id;
                
                List<Product_Order_Price_Book__c> SignProdList= new List<Product_Order_Price_Book__c>();
                Sigma_Order__c SigOrdes=new Sigma_Order__c();
                SigOrdes.Id = SigOrder.Id;
                Product_Order_Price_Book__c SignProd= new Product_Order_Price_Book__c();
                
                Product_Order_Price_Book__c BackOrderProd= new Product_Order_Price_Book__c();
                Orderset.add(SigOrder.Id);
                Productset.add(ProductId);
                
                if(Integer.valueof(EnteredQuantity) <= AvlQunt)
                {
                    SignProd.Product__c = ProductId;
                    SignProd.Sigma_Order__c = SigOrder.Id;
                    SignProd.Quantity__c = Integer.valueof(EnteredQuantity);
                    SignProd.Net_Quantity__c = Integer.valueof(EnteredQuantity);
                    SignProd.Remaining_Qty_To_Package__c = Integer.valueof(EnteredQuantity);
                    SignProd.Total_Amount__c = Prod.Product_Price__c;
                    SignProd.Total_Price__c = Integer.valueof(EnteredQuantity) * (Prod.Product_Price__c);
                    SignProd.Ordered_Amount__c = Integer.valueof(EnteredQuantity) * (Prod.Product_Price__c);
                    SignProd.Inventory_Status__c = 'Reserve';
                    SignProdList.add(SignProd);
                    
                }
                else if (Integer.valueof(EnteredQuantity) > AvlQunt)
                {
                    SignProd.Product__c = ProductId;
                    SignProd.Sigma_Order__c = SigOrder.Id;
                    SignProd.Quantity__c = Integer.valueof(EnteredQuantity);
                    SignProd.Net_Quantity__c = AvlQunt;
                    SignProd.Remaining_Qty_To_Package__c = AvlQunt;
                    SignProd.Total_Amount__c = Prod.Product_Price__c;
                    SignProd.Total_Price__c = AvlQunt * (Prod.Product_Price__c);
                    SignProd.Ordered_Amount__c = AvlQunt * (Prod.Product_Price__c);
                    SignProd.Inventory_Status__c = 'Reserve';
                    SignProdList.add(SignProd);
                    
                    BackOrderProd.Product__c = ProductId;
                    BackOrderProd.Sigma_Order__c = SigOrder.Id;
                    BackOrderProd.Net_Quantity__c = (Integer.valueof(EnteredQuantity) - AvlQunt);
                    BackOrderProd.Remaining_Qty_To_Package__c = (Integer.valueof(EnteredQuantity) - AvlQunt);
                    BackOrderProd.Total_Amount__c = Prod.Product_Price__c;
                    BackOrderProd.Back_Order__c = true;
                    BackOrderProd.Inventory_Status__c = 'Reserve';
                    BackOrderProd.Total_Price__c = (Integer.valueof(EnteredQuantity) - AvlQunt) * (Prod.Product_Price__c);
                    BackOrderProd.Ordered_Amount__c = (Integer.valueof(EnteredQuantity) - AvlQunt) * (Prod.Product_Price__c);
                    BackOrderProd.Stock_Fulfilled__c = false;
                    SignProdList.add(BackOrderProd);
                }
                ProdOrderMap.put(SigOrder.Id,SignProdList);
                insert SignProdList;
				
				 //code to created invoice, added by harish 11-01-2021
				if(SOID !=null)
                {
                	Invoice__c invoice = new Invoice__c();
				List<Invoice_Item__c>Invoiceitem = new List<Invoice_Item__c>();
				invoice.SO__c = SOID; 
				invoice.Invoice_Type__c='Sales Invoice';
				invoice.Customer__c =Acc.id;
				invoice.Invoice_Status__c='Unpaid'; 
				insert invoice;
                
                for(Product_Order_Price_Book__c orderline : SignProdList)
				{
					Invoice_Item__c invoicedata = new Invoice_Item__c();
					invoicedata.Invoice_Number__c=invoice.id;
					invoicedata.SOI__c=orderline.id;
					invoicedata.Quantity__c = orderline.Net_Quantity__c;
					invoicedata.Total_Amount__c=orderline.Total_Price__c;
					invoicedata.Product__c=orderline.Product__c;
					invoicedata.Net_Amount__c = orderline.Total_Amount__c;
					//if(orderline.Discounts__c!=null && orderline.Discounts__c>0)
						//invoicedata.Discount__c = orderline.Discounts__c;
					Invoiceitem.add(invoicedata);
				}
				if(Invoiceitem.size()>0)
					insert Invoiceitem;    
                }
                // To update Order Amount to order with discount 
                utilityClass.DiscountDetails(Orderset,AccIDset,Productset);
            }
            else
            {
                SalOrdItems = [Select id,Inventory_Status__c,Back_Order__c,Ordered_Amount__c,Sigma_Order__c,Quantity__c,Product__c,Net_Quantity__c,Total_Amount__c from Product_Order_Price_Book__c where Product__c =: ProductId and Sigma_Order__c IN : SaleOdList];
                Orderset.add(SaleOdList[0].Id);
                Productset.add(ProductId);
                
                List<Product_Order_Price_Book__c> ProdlinList = new List<Product_Order_Price_Book__c>();
                List<Product_Order_Price_Book__c> DeleProdlinList = new List<Product_Order_Price_Book__c>();
                if(SalOrdItems.size() == 0)
                {
                    Product_Order_Price_Book__c SignProd= new Product_Order_Price_Book__c();
                    Product_Order_Price_Book__c backOrde=new Product_Order_Price_Book__c();
                    if(Integer.valueof(EnteredQuantity) <= AvlQunt)
                    {
                        SignProd.Sigma_Order__c = SaleOdList[0].Id;
                        SignProd.Product__c = ProductId;
                        SignProd.Quantity__c = Integer.valueof(EnteredQuantity);
                        SignProd.Net_Quantity__c = Integer.valueof(EnteredQuantity);
                        SignProd.Remaining_Qty_To_Package__c = Integer.valueof(EnteredQuantity);
                        SignProd.Total_Amount__c = Prod.Product_Price__c;
                        SignProd.Total_Price__c = Integer.valueof(EnteredQuantity) * (Prod.Product_Price__c);
                        SignProd.Ordered_Amount__c = Integer.valueof(EnteredQuantity) * (Prod.Product_Price__c);
                        SignProd.Inventory_Status__c = 'Reserve';
                        ProdlinList.add(SignProd);
                    }
                    else if(Integer.valueof(EnteredQuantity) > AvlQunt)
                    {
                        SignProd.Sigma_Order__c = SaleOdList[0].Id;
                        SignProd.Product__c = ProductId;
                        SignProd.Quantity__c = Integer.valueof(EnteredQuantity);
                        SignProd.Net_Quantity__c = AvlQunt;
                        SignProd.Remaining_Qty_To_Package__c = AvlQunt;
                        SignProd.Total_Amount__c = Prod.Product_Price__c;
                        SignProd.Total_Price__c = AvlQunt * (Prod.Product_Price__c);
                        SignProd.Ordered_Amount__c = AvlQunt * (Prod.Product_Price__c);
                        SignProd.Inventory_Status__c = 'Reserve';
                        ProdlinList.add(SignProd);
                        
                        
                        backOrde.Product__c = ProductId;
                        backOrde.Sigma_Order__c = SaleOdList[0].Id;
                        backOrde.Net_Quantity__c = (Integer.valueof(EnteredQuantity) - AvlQunt);
                        backOrde.Remaining_Qty_To_Package__c = (Integer.valueof(EnteredQuantity) - AvlQunt);
                        backOrde.Total_Amount__c = Prod.Product_Price__c;
                        backOrde.Back_Order__c = true;
                        backOrde.Stock_Fulfilled__c = false;
                        backOrde.Inventory_Status__c = 'Reserve';
                        backOrde.Total_Price__c = (Integer.valueof(EnteredQuantity) - AvlQunt)  * (Prod.Product_Price__c);
                        backOrde.Ordered_Amount__c = (Integer.valueof(EnteredQuantity) - AvlQunt)  * (Prod.Product_Price__c);
                        ProdlinList.add(backOrde);
                    }
                }
                else
                {
                    Product_Order_Price_Book__c backOrde=new Product_Order_Price_Book__c();
                    for(Product_Order_Price_Book__c ProdList : SalOrdItems)
                    {
                        if(Integer.valueof(EnteredQuantity) <= AvlQunt)
                        {
                            if(ProdList.Back_Order__c)
                                DeleProdlinList.add(ProdList);
                            else
                            {
                                ProdList.Product__c = ProductId;
                                ProdList.Quantity__c = Integer.valueof(EnteredQuantity);
                                ProdList.Net_Quantity__c = Integer.valueof(EnteredQuantity);
                                ProdList.Remaining_Qty_To_Package__c = Integer.valueof(EnteredQuantity);
                                ProdList.Total_Amount__c = Prod.Product_Price__c;
                                ProdList.Total_Price__c = Integer.valueof(EnteredQuantity) * (Prod.Product_Price__c);
                                ProdList.Ordered_Amount__c = Integer.valueof(EnteredQuantity) * (Prod.Product_Price__c);
                                ProdList.Inventory_Status__c = 'Reserve';
                                ProdlinList.add(ProdList);
                            }
                        }
                        else if(Integer.valueof(EnteredQuantity) > AvlQunt)
                        {
                            if(!ProdList.Back_Order__c)
                            {
                                ProdList.Product__c = ProductId;
                                ProdList.Quantity__c = Integer.valueof(EnteredQuantity);
                                ProdList.Net_Quantity__c = AvlQunt;
                                ProdList.Remaining_Qty_To_Package__c = AvlQunt;
                                ProdList.Total_Amount__c = Prod.Product_Price__c;
                                ProdList.Total_Price__c = AvlQunt * (Prod.Product_Price__c);
                                ProdList.Ordered_Amount__c = AvlQunt * (Prod.Product_Price__c);
                                ProdList.Inventory_Status__c = 'Reserve';
                                ProdlinList.add(ProdList);
                                
                                if(SalOrdItems.size() == 1)
                                {
                                    backOrde.Product__c = ProductId;
                                    backOrde.Sigma_Order__c = SaleOdList[0].Id;
                                    backOrde.Net_Quantity__c = (Integer.valueof(EnteredQuantity) - AvlQunt);
                                    backOrde.Remaining_Qty_To_Package__c = (Integer.valueof(EnteredQuantity) - AvlQunt);
                                    backOrde.Total_Amount__c = Prod.Product_Price__c;
                                    backOrde.Back_Order__c = true;
                                    backOrde.Stock_Fulfilled__c = false;
                                    backOrde.Total_Price__c = (Integer.valueof(EnteredQuantity) - AvlQunt)  * (Prod.Product_Price__c);
                                    backOrde.Ordered_Amount__c = (Integer.valueof(EnteredQuantity) - AvlQunt)  * (Prod.Product_Price__c);
                                    backOrde.Inventory_Status__c = 'Reserve';
                                    ProdlinList.add(backOrde);
                                }
                            }
                            else if(ProdList.Back_Order__c)
                            {
                                ProdList.Product__c = ProductId;
                                ProdList.Net_Quantity__c = (Integer.valueof(EnteredQuantity) - AvlQunt);
                                ProdList.Remaining_Qty_To_Package__c = (Integer.valueof(EnteredQuantity) - AvlQunt);
                                ProdList.Total_Amount__c = Prod.Product_Price__c;
                                ProdList.Back_Order__c = true;
                                ProdList.Stock_Fulfilled__c = false;
                                ProdList.Total_Price__c = (Integer.valueof(EnteredQuantity) - AvlQunt)  * (Prod.Product_Price__c);
                                ProdList.Ordered_Amount__c = (Integer.valueof(EnteredQuantity) - AvlQunt)  * (Prod.Product_Price__c);
                                ProdList.Inventory_Status__c = 'Reserve';
                                ProdlinList.add(ProdList);
                            }
                            else
                            {
                                backOrde.Product__c = ProductId;
                                backOrde.Sigma_Order__c = SaleOdList[0].Id;
                                backOrde.Net_Quantity__c = (Integer.valueof(EnteredQuantity) - AvlQunt);
                                backOrde.Remaining_Qty_To_Package__c = (Integer.valueof(EnteredQuantity) - AvlQunt);
                                backOrde.Total_Amount__c = Prod.Product_Price__c;
                                backOrde.Back_Order__c = true;
                                backOrde.Stock_Fulfilled__c = false;
                                backOrde.Total_Price__c = (Integer.valueof(EnteredQuantity) - AvlQunt)  * (Prod.Product_Price__c);
                                backOrde.Ordered_Amount__c = (Integer.valueof(EnteredQuantity) - AvlQunt)  * (Prod.Product_Price__c);
                                backOrde.Inventory_Status__c = 'Reserve';
                                ProdlinList.add(backOrde);
                            }
                        }
                        
                    }
                }
                
                if(DeleProdlinList.size() > 0)
                    delete DeleProdlinList;
                if(ProdlinList.size() > 0)
                    upsert ProdlinList;
                
               
                
                // To update Order Amount to order with discount 
                utilityClass.DiscountDetails(Orderset,AccIDset,Productset);
               
            }
        }
        return 'success';
    }
    
     public class completeProductWrapper {
        @AuraEnabled
        public Integer pageSize;
        @AuraEnabled
        public Integer pageNumber;
        @AuraEnabled
        public Integer totalRecords;
        @AuraEnabled
        public Integer recordStart;
        @AuraEnabled
        public Integer recordEnd;
        @AuraEnabled
        public String tabOverride;
        @AuraEnabled
        public List<ProductWrapper> productList;
        @AuraEnabled
        public List<String> productFamilyList;
        @AuraEnabled
        public String Ocomp;
        @AuraEnabled
        public String Pcurr;
        @AuraEnabled
        public List<String> PcurrList;
        @AuraEnabled
        public List<ResponseWrapper> ResponseWrapperList;
    
    
    }
    
    //wrapper for product Details
    public class ProductWrapper{
        @AuraEnabled
        public String Id;
        @AuraEnabled
        public String Name;
        @AuraEnabled
        public String producttype;
        @AuraEnabled
        public Decimal AvailableQuantity;
        @AuraEnabled
        public String productfamily;
        @AuraEnabled
        public String Attachementsid;
        @AuraEnabled
        public Decimal ProductPrice; 
        @AuraEnabled
        public String retailerProfile;
        @AuraEnabled
        public String VendorProfile;
        @AuraEnabled
        public String retailerCommURL;
        @AuraEnabled
        public String VendorCommURL;
        @AuraEnabled
        public boolean ProductImageAvail;
    }
    public class ResponseWrapper
    {
        @AuraEnabled
        public String errorMessage;
        @AuraEnabled
        public String Status;
        
    }
}