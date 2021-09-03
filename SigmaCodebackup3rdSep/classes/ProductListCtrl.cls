public without sharing class ProductListCtrl
{
    @AuraEnabled 
    public static ListProductWrap GetProductWrapper(Decimal pageNumber)
    {  
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,Profile.Name,Contact.AccountId from User where Id =: UserId]; 
        Community_Configuration__c Custset= [select Id,Name,Retailer_Community_URL__c,Products_Per_Page__c,Retailer_Profile_Name__c,Vendor_Community_URL__c,Vendor_Profile_Name__c from Community_Configuration__c where Name = 'Community Configurations' LIMIT 1];        
         Integer pageSize = 10;
         Integer offset = ((Integer)pageNumber - 1) * pageSize;
        String UserIDs = UserInfo.getUserId();
        List<ProductListWrapper> prodcutListWrapper = new List<ProductListWrapper>();
        Map<Id,Inventory__c> Quantitymap = new Map<Id,Inventory__c>();
        for(Inventory__c PI : [select Id,Name,Product_Name__c,Reserved_Qty__c,Shipped_Qty__c,Delivered_Qty__c,ProductCode__c,Total_Qty__c,Available_Qty__c from Inventory__c])
        {
            Quantitymap.put(PI.ProductCode__c,PI);
        }
        ListProductWrap objSizes = new ListProductWrap();
       // for(sigmaerpdev2__Product_Price__c prod : [Select id,Product2.Exchange_Average_Selling_Price__c,Product2.Average_Buying_Price__c,Product2.Exchange_Selling_Price__c,Product2.Selling_Price__c,Product2.Product_Price__c,Product2.Buying_Price__c,Product2.Retail_Price__c,Product2.Currency__c,Product2.IsActive,Product2.Type__c,Product2.Product_Bar_Code__c,Product2.Product_Weight__c,Product2.Active__c,Product2.Product_UOM__c,Product2.Has_Expiry_Date__c,Product2.ProductCode,Product2.Stock_Item__c,Product2.Attribute_Type__c,Product2.SKU__c,Name,sigmaerpdev2__Product_Id__c,Product2.Name From sigmaerpdev2__Product_Price__c where sigmaerpdev2__Product_Id__c != null and Product2.CreatedById =: UserIDs Limit 1000])
        for(PriceBookEntry Prod : [Select id,Pricebook2Id,Product2.Brewery_Account__c,Product2.Product_Description__c,Product2.Product_Catalog__c,Product2.Product_Catalog__r.Name,Product2.Exchange_Average_Selling_Price__c,Product2.Average_Buying_Price__c,Product2.Exchange_Selling_Price__c,Product2.Selling_Price__c,Product2.Product_Price__c,Product2.Buying_Price__c,Product2.Retail_Price__c,Product2.Currency__c,Product2.Currency__r.Name,Product2.IsActive,Product2.Type__c,Product2.Product_Bar_Code__c,Product2.Product_Weight__c,Product2.Active__c,Product2.Product_UOM__c,Product2.Has_Expiry_Date__c,Product2.ProductCode,Product2.Stock_Item__c,Product2.Attribute_Type__c,Product2.SKU__c,Name,Product2Id,Product2.Name From PriceBookEntry where Product2Id != null and Product2.Stock_Item__c= true AND  Product2.Brewery_Account__c =: currentuser.Contact.AccountId Limit :pageSize offset :offset])
        {
            ProductListWrapper obj = new ProductListWrapper();
            obj.isChecked =  false;
            obj.productId =  prod.Product2Id;
            obj.productName =  prod.Product2.Name;
            obj.SKU =  prod.Product2.SKU__c;
            obj.AttributeType =  prod.Product2.Attribute_Type__c;
            obj.Stockitem =  prod.Product2.Stock_Item__c;
            obj.ProductCode =  prod.Product2.ProductCode;
            obj.HasExpiryDate =  prod.Product2.Has_Expiry_Date__c;
            obj.ProductUOM =  prod.Product2.Product_UOM__c;
            obj.TimeBaseInventory =  prod.Product2.Active__c;
            obj.ProductWeight =  prod.Product2.Product_Weight__c;
            obj.ProductBarCode =  prod.Product2.Product_Bar_Code__c;
            obj.Type =  prod.Product2.Type__c;
            obj.Active =  prod.Product2.IsActive;
            obj.Currencyy =  prod.Product2.Currency__c;
            obj.RetailPrice =  prod.Product2.Retail_Price__c;
            obj.BuyingPrice =  prod.Product2.Buying_Price__c;
            obj.SellingPrice =  prod.Product2.Product_Price__c;
            obj.ProductPrice =  prod.Product2.Selling_Price__c;
            //obj.ExchangeSellingPrice =  prod.Product2.Exchange_Selling_Price__c;
            obj.Quantity = Quantitymap.get(prod.Product2Id).Available_Qty__c;
            obj.AverageBuyingPrice =  prod.Product2.Average_Buying_Price__c;
            obj.ExchangeAverageSellingPrice =  prod.Product2.Exchange_Average_Selling_Price__c;
            //obj.ExchangeSellingPrice =  prod.Product2.
            obj.ProductCatalogId = prod.Product2.Product_Catalog__c;
            obj.ProductCatalogName = prod.Product2.Product_Catalog__r.Name;
            if(currentuser.Profile.Name == Custset.Retailer_Profile_Name__c)
            obj.UserAccount = currentuser.Contact.AccountId;
            obj.ProductDescription = prod.Product2.Product_Description__c;
            obj.prodinventory = Quantitymap.get(prod.Product2Id);
            obj.CurrencyyName = prod.Product2.Currency__r.Name;
            prodcutListWrapper.add(obj);
        }
        objSizes.ProductListWrap = prodcutListWrapper;
        objSizes.pageSizeSigma = pageSize;
        objSizes.pageSigma = (Integer) pageNumber;
        objSizes.totalSigma = [Select count() from PriceBookEntry where Product2Id != null and Product2.CreatedById =: UserIDs];
        
        System.debug('prodcutListWrapper:'+objSizes);
        return objSizes; 
    }
    @AuraEnabled
    public static List<Inventory__c> InvDetails(String ProductId)
    {
        List<Inventory__c> InvList = new List<Inventory__c>();
        InvList = [select id,name,ProductCode__c,Product_Name__c,Available_Qty__c,Shipped_Qty__c,Reserved_Qty__c,Delivered_Qty__c from Inventory__c where ProductCode__c =: ProductId];
        return InvList;
    }
    @AuraEnabled
    public static AllPickListwrap getPicklistValues()
    {
         List<PicklistWrap> options = new List<PicklistWrap>();
         AllPickListwrap allpik = new AllPickListwrap();
        try{
            
          List<String> PicklistVa = new List<String>();
          PicklistVa.add('Attribute_Type__c');
          PicklistVa.add('Product_UOM__c');
          PicklistVa.add('Type__c');
            //for(String St: PicklistVa)
            {
                List<Schema.PicklistEntry> ple = Product2.Attribute_Type__c.getDescribe().getPicklistValues();
               /*Schema.DescribeFieldResult fieldResult = Product2.Attribute_Type__c.getDescribe();
               List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();    */
               for( Schema.PicklistEntry f : ple)
               {
                  options.add(new PicklistWrap(f.getLabel(), f.getValue()));
               }     
            }    
        }
        catch(exception ex)
        {
            return allpik;
        }
     allpik.PicklistWraps = options;
       //allpik.AttributeType = options[0];
     allpik.PicklistWrapss = getPicklistValues1();
     allpik.PicklistWrapsss = getPicklistValues2();
       return allpik;
    }
    
    @AuraEnabled
    public static List<PicklistWrap> getPicklistValues1()
    {
         List<PicklistWrap> options = new List<PicklistWrap>();
        try{
            
          List<String> PicklistVa = new List<String>();
          PicklistVa.add('Attribute_Type__c');
          PicklistVa.add('Product_UOM__c');
          PicklistVa.add('Type__c');
            //for(String St: PicklistVa)
            {
                List<Schema.PicklistEntry> ple = Product2.Product_UOM__c.getDescribe().getPicklistValues();
               /*Schema.DescribeFieldResult fieldResult = Product2.Product_UOM__c.getDescribe();
               List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();*/  
               for( Schema.PicklistEntry f : ple)
               {
                  options.add(new PicklistWrap(f.getLabel(), f.getValue()));
               }     
            }    
        }
        catch(exception ex)
        {
            return options;
        }
     
       return options;
    }
    
    @AuraEnabled
    public static List<PicklistWrap> getPicklistValues2()
    {
         List<PicklistWrap> options = new List<PicklistWrap>();
        try{
            
          List<String> PicklistVa = new List<String>();
          PicklistVa.add('Attribute_Type__c');
          PicklistVa.add('Product_UOM__c');
          PicklistVa.add('Type__c');
            //for(String St: PicklistVa)
            {
                List<Schema.PicklistEntry> ple = Product2.Type__c.getDescribe().getPicklistValues();
               /*Schema.DescribeFieldResult fieldResult = Product2.Type__c.getDescribe();
               List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();*/  
               for( Schema.PicklistEntry f : ple)
               {
                  options.add(new PicklistWrap(f.getLabel(), f.getValue()));
               }     
            }    
        }
        catch(exception ex)
        {
            return options;
        }
     
       return options;
    }
    
    @AuraEnabled
    public static String SaveProducts(String ProductDetails,boolean NewProds,boolean Editprods,String base64Data,String fileName,String contentType)
    {
        String Status = '';
        try
        {
			Id UserId= UserInfo.getUserId();
			User currentuser = [select Id,Profile.Name,Contact.AccountId from User where Id =: UserId]; 
			Community_Configuration__c Custset= [select Id,Name,Retailer_Community_URL__c,Products_Per_Page__c,Retailer_Profile_Name__c,Vendor_Community_URL__c,Vendor_Profile_Name__c from Community_Configuration__c where Name = 'Community Configurations' LIMIT 1];        
        
            System.debug(ProductDetails);
            ProductListWrapper Proddetwrap= (ProductListWrapper)System.JSON.deserialize(ProductDetails,ProductListWrapper.class);
            Product2 Prod = new Product2();
            Prod.Name = Proddetwrap.productName;
            Prod.SKU__c = Proddetwrap.SKU;
            Prod.Attribute_Type__c = Proddetwrap.AttributeType;
            Prod.Stock_Item__c =  NewProds? true : Proddetwrap.Stockitem != null ? Proddetwrap.Stockitem : false;
            //Prod.ProductCode = Proddetwrap.ProductCode;
            //Prod.Has_Expiry_Date__c = Proddetwrap.HasExpiryDate != null ? Proddetwrap.HasExpiryDate : false;
            Prod.Product_UOM__c = Proddetwrap.ProductUOM;
            Prod.Active__c = NewProds ? true : Proddetwrap.TimeBaseInventory != null ? Proddetwrap.TimeBaseInventory : false;
            //Prod.Product_Weight__c = Proddetwrap.ProductWeight;
            //Prod.Product_Bar_Code__c = Proddetwrap.ProductBarCode;
            //Prod.Type__c = Proddetwrap.Type;
            Prod.IsActive = Proddetwrap.Active != null ? Proddetwrap.Active : false;
            Prod.Currency__c = Proddetwrap.Currencyy;
            //Prod.Retail_Price__c = Proddetwrap.RetailPrice != null ? Proddetwrap.RetailPrice : 0.00;
            //Prod.Buying_Price__c = Proddetwrap.BuyingPrice != null ? Proddetwrap.BuyingPrice : 0.00;
            //Prod.Product_Price__c = Proddetwrap.SellingPrice != null ? Proddetwrap.SellingPrice : 0.00;
            Prod.Selling_Price__c = Proddetwrap.ProductPrice != null ? Proddetwrap.ProductPrice : 0.00;
            //Prod.Exchange_Selling_Price__c = Proddetwrap.ExchangeSellingPrice;
            //Prod.Average_Buying_Price__c = Proddetwrap.AverageBuyingPrice != null ? Proddetwrap.AverageBuyingPrice : 0.00;
            //Prod.Exchange_Average_Selling_Price__c = Proddetwrap.ExchangeAverageSellingPrice;
            Prod.Product_Catalog__c = Proddetwrap.ProductCatalogId;
            Prod.Product_Description__c = Proddetwrap.ProductDescription;
			if(currentuser.Profile.Name == Custset.Retailer_Profile_Name__c && currentuser.Contact != null)
			Prod.Brewery_Account__c = currentuser.Contact.AccountId;
            if(NewProds)
                insert Prod;
            else if(Editprods)
            {
                Prod.Id = Proddetwrap.productId;
                update Prod;
            }
                
            
            PriceBookEntry ProdPrice = new PriceBookEntry();
            ProdPrice.Product2Id = Prod.Id;
            ProdPrice.Pricebook2Id = '01s2x000002ULV3';
            ProdPrice.IsActive = true;
            ProdPrice.UnitPrice = Proddetwrap.ProductPrice;
            
            Inventory__c Inv = [select Id,ProductCode__c,Total_Qty__c,Available_Qty__c from Inventory__c where ProductCode__c =: Prod.Id LIMIT 1];
            
            
            
            System.debug('Quantity>>'+Proddetwrap.Quantity);
            
            if(NewProds)
            {
                insert ProdPrice;
                if(Proddetwrap.Quantity == null)
                {
                    Inv.Available_Qty__c = 0;
                    Inv.Total_Qty__c = 0;
                }
                else{
                    Inv.Available_Qty__c = Proddetwrap.Quantity;
                    Inv.Total_Qty__c = Proddetwrap.Quantity;
                }
                update Inv;
                
                //creating Vendor Product for Product
                
                Vendor_Product__c Vendor = new Vendor_Product__c();
                Vendor.Product_Name__c = Prod.Id;
                Vendor.Account_Name__c = currentuser.Contact.AccountId;
                Vendor.Is_Preferred__c = true;
                Vendor.Buying_Price__c = Proddetwrap.ProductPrice;
                
                insert Vendor;
                
                //Creating Location for Brewery Account
                SET<String> AccIds = new SET<String>();
                Map<String,Account> ExistAcc = new Map<String,Account>();
                Id RecTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Location').getRecordTypeId();
                List<Account> Existingrec = new List<Account>();
                Existingrec = [select id,Name from Account where RecordTypeId =: RecTypeId];
                for(Account accs : Existingrec)
                {
                    AccIds.add(accs.Name);
                    ExistAcc.put(accs.Name,accs);
                }
                Product2 Prodsss = [Select Id,Name,Attribute_Type__c,CreatedBy.Name from Product2 where Id =: Prod.Id];
                System.debug('Test123<>'+Prodsss.CreatedBy.Name);
                Account acc= new Account();
                Inventory_Location__c InvLoc = new Inventory_Location__c();
                Sublevel_location__c SubLovBin = new Sublevel_location__c();
                Id ZoneRecTypeId = Schema.getGlobalDescribe().get('sigmaerpdev2__Sublevel_location__c').getDescribe().getRecordTypeInfosByName().get('Zone').getRecordTypeId();
                Id BinRecTypeId = Schema.getGlobalDescribe().get('sigmaerpdev2__Sublevel_location__c').getDescribe().getRecordTypeInfosByName().get('Bin').getRecordTypeId();
                if(!AccIds.contains(Prodsss.CreatedBy.Name+' Location'))
                {
                    
                    acc.Name = Prodsss.CreatedBy.Name+' Location';
                    acc.RecordTypeId = RecTypeId;
                    acc.Active__c = 'Yes';
                    acc.Locations_Type__c = 'Warehouse';
                    insert acc; 
                    
                    //creating inventory Location for Above location
                    
                    InvLoc = [Select Id,Location_Type__c from Inventory_Location__c where Location__c =: acc.Id LIMIT 1];
                    
                    //InvLoc.Location__c = acc.Id;
                    //insert InvLoc;
                    
                    //creating Zone and bin
                    
                    Sublevel_location__c SubLovZone = new Sublevel_location__c();
                    SubLovZone.Name = Prodsss.CreatedBy.Name+' Zone';
                    SubLovZone.RecordTypeId = ZoneRecTypeId;
                    SubLovZone.Inventory_Location__c = InvLoc.Id;
                    insert SubLovZone;
                    
                    
                    
                    SubLovBin.Name = Prodsss.CreatedBy.Name+' Bin';
                    SubLovBin.RecordTypeId = BinRecTypeId;
                    SubLovBin.Inventory_Location__c = InvLoc.Id;
                    SubLovBin.zone__c = SubLovZone.Id;
                    insert SubLovBin;
                }
                else
                {
                    String LocaIdmap = ExistAcc.get(Prodsss.CreatedBy.Name+' Location').Id;
                    Inventory_Location__c invlocid = [Select id from Inventory_Location__c where Location__r.Name =: Prodsss.CreatedBy.Name+' Location'AND Location__c =: LocaIdmap LIMIT 1];
                    InvLoc.id = invlocid.Id;
                    Sublevel_location__c Sublocid = [Select id from Sublevel_location__c where Inventory_Location__c =: invlocid.Id And RecordTypeId =: BinRecTypeId LIMIT 1];
                    SubLovBin.Id = Sublocid.Id;
                }
                
                if(Proddetwrap.Quantity > 0)
                {
                    //creating ILP
                    Inventory_Location_Product__c ILPdata = new Inventory_Location_Product__c ();
                    ILPdata.Inventory__c = Inv.Id;
                    ILPdata.Inventory_Location__c = InvLoc.Id;
                    ILPdata.Products__c = Prod.Id;
                    ILPdata.Received_Quantity__c = Proddetwrap.Quantity;
                    ILPdata.Source_Type__c = 'System';
                    ILPdata.Unit_Price__c = Proddetwrap.ProductPrice;
                    ILPdata.Stock_Origin__c = 'Direct Add';
                    insert ILPdata;
                    
                    //creating ILPLI
                    Inventory_Location_Product_Line_Item__c ILPLIdata= new Inventory_Location_Product_Line_Item__c(); 
                    ILPLIdata.Inventory_Location_Product__c = ILPdata.Id;
                    ILPLIdata.Product__c = Prod.Id;
                    ILPLIdata.Received_Quantity__c = Proddetwrap.Quantity;
                    ILPLIdata.Inventory_Location__c  = InvLoc.Id;
                    ILPLIdata.Stock_Type__c = 'Direct Add'; 
                    ILPLIdata.Attribute_Type__c = Prodsss.Attribute_Type__c;
                    ILPLIdata.Unit_Price__c = Proddetwrap.ProductPrice;
                    ILPLIdata.Bin__c = SubLovBin.Id;
                    
                    insert ILPLIdata;
                }
                
                
            }
                
            else if(Editprods)
            {
                PriceBookEntry PB = [select id,Product2Id from PriceBookEntry where Product2Id =: Prod.Id LIMIT 1];
                
                
                ProdPrice.Id = PB.Id;
                update ProdPrice;
                if(Proddetwrap.Quantity == null)
                    Inv.Available_Qty__c = 0;
                else
                Inv.Available_Qty__c = Proddetwrap.Quantity;
                if(Inv.Available_Qty__c != Proddetwrap.Quantity)
                {
                    if(Proddetwrap.Quantity != null && Inv.Available_Qty__c > Proddetwrap.Quantity)
                    {
                        Inv.Total_Qty__c = Inv.Available_Qty__c - Proddetwrap.Quantity;
                    }
                    else if(Proddetwrap.Quantity != null && Inv.Available_Qty__c < Proddetwrap.Quantity)
                    {
                        Inv.Total_Qty__c = Inv.Available_Qty__c - 0;
                       
                    }
                }
                update Inv;
            }
            System.debug('base64Database64Data>'+base64Data);
            if(base64Data != null)
            {
                base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
                Blob b = EncodingUtil.base64Decode(base64Data);
                /*Attachment attachment = new Attachment();
                attachment.Body = b;
                attachment.Name = fileName;
                attachment.ParentId = Prod.Id;
                attachment.ContentType = contentType;
                insert attachment;
                */
                ContentVersion contentVersion_1 = new ContentVersion();
                  contentVersion_1.Title = fileName;
                  contentVersion_1.PathOnClient = fileName;
                  contentVersion_1.VersionData = b;
                  contentVersion_1.IsMajorVersion = true;
                    insert contentVersion_1;
                    
                    
                    ContentDocumentLink cdl = new ContentDocumentLink();
                    cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: contentVersion_1.Id].ContentDocumentId;
                    cdl.LinkedEntityId = Prod.Id;
                    cdl.ShareType = 'V';
                    insert cdl;
            }
            
            Status = 'Success';
        }
        catch(exception ex)
        {
            System.debug(ex);
            Status = 'Error';
        }
        
        return Status;
    }
     @AuraEnabled
    public static ProdImageWrapper getproductimage(Id prodId)
    {
        Id UserId= UserInfo.getUserId();
            User currentuser = [select Id,Profile.Name from User where Id =: UserId];
            Community_Configuration__c Custset= [select Id,Name,Retailer_Community_URL__c,Products_Per_Page__c,Retailer_Profile_Name__c,Vendor_Community_URL__c,Vendor_Profile_Name__c from Community_Configuration__c where Name = 'Community Configurations' LIMIT 1];
            ProdImageWrapper URLWrap = new ProdImageWrapper();
            if(currentuser.Profile.Name == Custset.Retailer_Profile_Name__c)
            {
                URLWrap.ProdImage = [SELECT Id, ContentDocumentId,ContentDocument.FileExtension, ContentDocument.LatestPublishedVersionId,ContentDocument.LatestPublishedVersion.Title,SystemModstamp,LinkedEntityId,Visibility,ShareType FROM ContentDocumentLink WHERE LinkedEntityId =: prodId and ContentDocument.FileExtension IN ('jpg','png') order by SystemModstamp DESC limit 1];
                URLWrap.CommunityURL = Custset.Retailer_Community_URL__c;
            }
            else
            {
                URLWrap.ProdImage = [SELECT Id, ContentDocumentId,ContentDocument.FileExtension, ContentDocument.LatestPublishedVersionId,ContentDocument.LatestPublishedVersion.Title,SystemModstamp,LinkedEntityId,Visibility,ShareType FROM ContentDocumentLink WHERE LinkedEntityId =: prodId and ContentDocument.FileExtension IN ('jpg','png') order by SystemModstamp DESC limit 1];
                URLWrap.CommunityURL = '';
            }
            
        //ContentDocumentLink productimagecontent = [SELECT Id, ContentDocumentId,ContentDocument.FileExtension, ContentDocument.LatestPublishedVersionId,ContentDocument.LatestPublishedVersion.Title,SystemModstamp,LinkedEntityId,Visibility,ShareType FROM ContentDocumentLink WHERE LinkedEntityId =: prodId and ContentDocument.FileExtension IN ('jpg','png') order by SystemModstamp DESC limit 1];
        
        return URLWrap;
    }
    public class ProdImageWrapper
    {
        @AuraEnabled
        public ContentDocumentLink ProdImage;
        @AuraEnabled
        public String CommunityURL;
        @AuraEnabled
        public boolean isCommunityURL;
    }
    @AuraEnabled
    public static String DeleteProductsapex(String ProdIDs)
    {
        String Status = '';
        try{
            Product2 Prod = [select id from Product2 where id =: ProdIDs];
            PriceBookEntry ProdPrice = [select id,Product2Id from PriceBookEntry where Product2Id =: ProdIDs];
        
        delete prod;
        delete ProdPrice;
        Status = 'Success';
        }
        catch(exception ex)
        {
            Status = 'Errror';
        }
        return Status;
    }
    @AuraEnabled
    public static CatalogWrapper createCatalog(string CatalogData)
    {
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,Profile.Name,Contact.AccountId from User where Id =: UserId];
        CatalogWrapper Catwrap = new CatalogWrapper();
        try{
            CatalogWrapper CatalogDatatwrap= (CatalogWrapper)System.JSON.deserialize(CatalogData,CatalogWrapper.class);
            Map<String,Product_Catalog__c> ProdCatMap = new  Map<String,Product_Catalog__c>();
            List<Product_Catalog__c> ProdCatList = new List<Product_Catalog__c>();
            ProdCatList = [SELECT Id,Name,Brewery_Account__c,Catalog_Decscription__c from Product_Catalog__c where Brewery_Account__c =: currentuser.Contact.AccountId];
            if(ProdCatList.size() > 0)
            {
                for(Product_Catalog__c PC : ProdCatList)
                {
                    ProdCatMap.put(PC.Name,PC);
                }
            }
            System.debug('ProdCatMap>>'+ProdCatMap);
            if(!ProdCatMap.containsKey(CatalogDatatwrap.CatalogName))
            {
                Product_Catalog__c Prodcat = new Product_Catalog__c();
                Prodcat.Name = CatalogDatatwrap.CatalogName;
                Prodcat.Brewery_Account__c = currentuser.Contact.AccountId;
                Prodcat.Catalog_Decscription__c= CatalogDatatwrap.CatalogDescription;
                insert Prodcat;
                
                Catwrap.CatalogName = CatalogDatatwrap.CatalogName;
                Catwrap.Status = 'SUCCESS';
                Catwrap.ErrorMessage = CatalogDatatwrap.CatalogName + ' Product Catalog has been created';
                
            }
            else
            {
                Catwrap.CatalogName = CatalogDatatwrap.CatalogName;
                Catwrap.Status = 'ERROR';
                Catwrap.ErrorMessage = CatalogDatatwrap.CatalogName + ' Product Catalog is already Existed';
            }
            return Catwrap;
        }
        catch(exception ex)
        {
            Catwrap.Status = 'ERROR';
            Catwrap.ErrorMessage = ex.getMessage();
            return Catwrap;
        }
        
    }
    
    public class CatalogWrapper
    {
        @AuraEnabled public String CatalogName;
        @AuraEnabled public String CatalogDescription;
        @AuraEnabled public String Status;
        @AuraEnabled public String ErrorMessage;
    }
    public class ListProductWrap
    {
        @AuraEnabled public List<ProductListWrapper> ProductListWrap;
        @AuraEnabled public Integer pageSize { get;set; }
        @AuraEnabled public Integer page { get;set; }
        @AuraEnabled public Integer total { get;set; }
        @AuraEnabled public Integer pageSizeSigma { get;set; }
        @AuraEnabled public Integer pageSigma { get;set; }
        @AuraEnabled public Integer totalSigma { get;set; }
        
    }
    
    public class ProductListWrapper 
    {
        @AuraEnabled public Inventory__c prodinventory;
        @AuraEnabled public List<PicklistWrap> PickWrap;
        @AuraEnabled public boolean isChecked;
        @AuraEnabled public String productId;
        @AuraEnabled public String productName;
        @AuraEnabled public String SKU;
        @AuraEnabled public String AttributeType;
        @AuraEnabled public boolean Stockitem;
        @AuraEnabled public String ProductCode;
        @AuraEnabled public boolean HasExpiryDate;
        @AuraEnabled public String ProductUOM;
        @AuraEnabled public boolean TimeBaseInventory;
        @AuraEnabled public Decimal ProductWeight;
        @AuraEnabled public String ProductBarCode;
        @AuraEnabled public String Type;
        @AuraEnabled public boolean Active;
        @AuraEnabled public String Currencyy;
        @AuraEnabled public String CurrencyyName;
        @AuraEnabled public Decimal RetailPrice;
        @AuraEnabled public Decimal BuyingPrice;
        @AuraEnabled public Decimal SellingPrice;
        @AuraEnabled public Decimal ProductPrice;
        @AuraEnabled public String ExchangeSellingPrice;
        @AuraEnabled public Decimal Quantity;
        @AuraEnabled public Decimal AverageBuyingPrice;
        @AuraEnabled public String ExchangeAverageSellingPrice;
        @AuraEnabled public String ProductCatalogId;
        @AuraEnabled public String ProductCatalogName;
        @AuraEnabled public String UserAccount;
        @AuraEnabled public String ProductDescription;
        
    }
    
    public class AllPickListwrap
    {
        @AuraEnabled public List<PicklistWrap> PicklistWraps;
        @AuraEnabled public List<PicklistWrap> PicklistWrapss;
        @AuraEnabled public List<PicklistWrap> PicklistWrapsss;
    }
    
    public class PicklistWrap
    {
        @AuraEnabled public String PicklistAPI;
        @AuraEnabled public String PicklistLabel;
        @AuraEnabled public String FieldAPI;
        
        public PicklistWrap(string PicklistLabel, string PicklistAPI){
            this.PicklistLabel=PicklistLabel;
            this.PicklistAPI=PicklistAPI;
        }
        
    }
    public class PicklistWrap1
    {
        @AuraEnabled public String PicklistAPI;
        @AuraEnabled public String PicklistLabel;
        @AuraEnabled public String FieldAPI;
        
        public PicklistWrap1(string PicklistLabel, string PicklistAPI){
            this.PicklistLabel=PicklistLabel;
            this.PicklistAPI=PicklistAPI;
        }
        
    }
    public class PicklistWrap2
    {
        @AuraEnabled public String PicklistAPI;
        @AuraEnabled public String PicklistLabel;
        @AuraEnabled public String FieldAPI;
        
        public PicklistWrap2(string PicklistLabel, string PicklistAPI){
            this.PicklistLabel=PicklistLabel;
            this.PicklistAPI=PicklistAPI;
        }
        
    }
}