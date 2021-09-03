public class DisplayProducts 
{
    @AuraEnabled
    public static completeProductWrapper getproductlist(Id recordId)
    {
        List<Product2> productlist= [select id,Name,Stock_Item__c,Product_Price__c,Bar_Code_Gene__c,Attribute_Type__c,Product_Type__c,Type__c,Reorder_Quantity__c,Threshold_Quantity__c,Purpose__c,How_it_will_help__c,Targeted_products__c, (SELECT Id FROM Attachments),(SELECT Id,Available_Qty__c from Product_Inventory__r),(SELECT Id,Buying_Price__c from Vendor_Products__r) from Product2 where sigmaerpdev2__Product_Price__c!=null and Solution_Component__c=True];
        
        List<Community_Configuration__c> Custset= new List<Community_Configuration__c>();
            Custset = [select Id,Name,Vendor_Community_URL__c from Community_Configuration__c where Name = 'ShoppingCart' LIMIT 1];
        System.debug('Custset>>>'+Custset);
        
         completeProductWrapper Cmplwraps = new completeProductWrapper();
         List<ProductWrapper> productLists = new List<ProductWrapper>();
         List<ResponseWrapper> Respwrap = new List<ResponseWrapper>();
   
         SET<ID> ProdId=new SET<ID>();
         Map<Id,Id> ProdImalink= new Map<Id,Id>();
            
            
            if(ProductList.size() > 0)
            {
                for(Product2 ProdIDsss : ProductList)
                {
                    ProdId.add(ProdIDsss.Id);
                }
                for(ContentDocumentLink Contelink : [SELECT Id, ContentDocumentId,ContentDocument.FileExtension, ContentDocument.LatestPublishedVersionId,ContentDocument.LatestPublishedVersion.Title,SystemModstamp,LinkedEntityId,Visibility,ShareType FROM ContentDocumentLink WHERE LinkedEntityId IN: ProdId and ContentDocument.FileExtension IN ('jpg','png','jpeg') order by SystemModstamp ASC])
                {
                    ProdImalink.put(Contelink.LinkedEntityId,Contelink.ContentDocument.LatestPublishedVersionId);
                    System.debug('<ProdImalink>>>'+ProdImalink);
                }
                        ResponseWrapper RespWrapper = new ResponseWrapper();
                    for(Product2 Prods : ProductList)
                    {
                        ProductWrapper ProdL= new ProductWrapper();
                            if(Custset.size() > 0)
                          {
                            ProdL.VendorCommURL = Custset[0]. Vendor_Community_URL__c;
                              System.debug('ProdL.VendorCommURL>>>'+ProdL.VendorCommURL);
                          }
                        ProdL.id = Prods.id;
                        ProdL.Name = Prods.Name;
                        ProdL.producttype = Prods.Product_Type__c;
                        ProdL.Purpose=Prods.Purpose__c;
                        ProdL.HowItWillHelp=Prods.How_it_will_help__c;
                        ProdL.TargetProducts=Prods.Targeted_products__c;
                        if(Prods.Product_Inventory__r.size() >0)
                        ProdL.AvailableQuantity = Prods.Product_Inventory__r[0].Available_Qty__c;
                        ProdL.productfamily = Prods.Bar_Code_Gene__c;
                        ProdL.ProductPrice = Prods.Product_Price__c;
                        System.debug('ProdImalink.containsKey(Prods.id)'+ProdImalink.containsKey(Prods.id));
                        if(ProdImalink.containsKey(Prods.id))
                        {
                            ProdL.Attachementsid = ProdImalink.get(Prods.id);
                            System.debug('Attachementsid>>>>'+ProdL.Attachementsid);
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
                    Cmplwraps.totalRecords = ProductList.size();
                    RespWrapper.Status = 'SUCCESS';
                    Respwrap.add(RespWrapper);
                    Cmplwraps.ResponseWrapperList = Respwrap;
            }
        return Cmplwraps;
    }
    
     @AuraEnabled
    public static String saveSO(String ProductId, String ProductPrice, String Avlquantity, String EnteredQuantity)
    {
    {
            Id UserId= UserInfo.getUserId();
            User currentuser = [select Id,ContactId,Name,Contact.Name,Contact.Account.Name from User where id =: UserId];
            Map<String,Decimal> ProdInvMap = new Map<String,Decimal>();
            Map<String,List<Product_Order_Price_Book__c>> ProdOrderMap = new Map<String,List<Product_Order_Price_Book__c>>();
            
            Product2 Prod = [select id,Product_Price__c,Name,Type__c, Retail_Price__c, Selling_Price__c from Product2 where id =: ProductId];
            List<Sigma_Order__c> SaleOdList=new List<Sigma_Order__c>();
            List<Product_Order_Price_Book__c> SalOrdItems = new List<Product_Order_Price_Book__c>();
            SaleOdList = [select id,AccountId__c, BillingPersonNew__c, Orders_Status__c, Order_Type__c,Order_Created_Via__c, Delivary_Date__c from Sigma_Order__c where Orders_Status__c = 'Pending' AND Order_Created_Via__c = 'Community'];
            
            SET<ID> Orderset = new SET<ID>();
            SET<ID> Productset = new SET<ID>();
            SET<ID> AccIDset = new SET<ID>();
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
                SigOrder.Orders_Status__c = 'Pending';
                SigOrder.Order_Created_Via__c = 'Community';
                SigOrder.Delivary_Date__c = System.Today();
                SigOrder.RecordTypeId = recordTypeIds;
                SigOrder.Order_Type__c = 'Online';
                SigOrder.Auto_Allocate__c = true;
                insert SigOrder;
                System.debug('SIgmaOrder Insert>>>'+SigOrder);
                
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
                // To update Order Amount to order with discount 
              //  utilityClass.DiscountDetails(Orderset,AccIDset,Productset);
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
               // utilityClass.DiscountDetails(Orderset,AccIDset,Productset);
            }
        }
        return 'success';
    }
    
    @AuraEnabled
    public static Id  displayimageClone(Id recordId)
    {
        ContentDocumentLink CDL = [SELECT ContentDocumentId,ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId =:recordId and ContentDocument.FileExtension IN ('jpg','png','jpeg') order by SystemModstamp ASC limit 1 ];
        return CDL.ContentDocument.LatestPublishedVersionId;
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
        public String Attachementsidimage; 
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
        @AuraEnabled
        public String Purpose;
        @AuraEnabled
        public String HowItWillHelp;
        @AuraEnabled
        public String TargetProducts; 
    }
    
       public class ResponseWrapper
    {
        @AuraEnabled
        public String errorMessage;
        @AuraEnabled
        public String Status;
        
    }

}