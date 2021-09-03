public with sharing class ViewCart 
{
    @AuraEnabled
    public static List<SOLIWrapper> getAllCartDetails()
    {
        List<SOLIWrapper> prodwrapList = new List<SOLIWrapper>();
        Map<String,String> AttchId = new Map<String,String>();
        SET<ID> ProdId=new SET<ID>();
        Map<Id,Id> ProdImalink= new Map<Id,Id>();
        
        for(Product2 ProList : [select Id,Name,Product_Price__c,Bar_Code_Gene__c,Attribute_Type__c,Product_Type__c,Type__c,Reorder_Quantity__c,Threshold_Quantity__c,(SELECT Id FROM Attachments) from Product2 where Id != null and Product_Price__c != null and Stock_Item__c =true])
        {
            ProdId.add(ProList.Id);
            if(ProList.Attachments.size() > 0)
                AttchId.put(ProList.Id,ProList.Attachments[0].Id);
        }
        for(ContentDocumentLink Contelink : [SELECT Id, ContentDocumentId,ContentDocument.FileExtension, ContentDocument.LatestPublishedVersionId,ContentDocument.LatestPublishedVersion.Title,SystemModstamp,LinkedEntityId,Visibility,ShareType FROM ContentDocumentLink WHERE LinkedEntityId IN: ProdId and ContentDocument.FileExtension IN ('jpg','png','jpeg') order by SystemModstamp ASC]) 
        {
            ProdImalink.put(Contelink.LinkedEntityId,Contelink.ContentDocument.LatestPublishedVersionId);
        } 
        List<Sigma_Order__c> SaleOdList=new List<Sigma_Order__c>();
        List<Product_Order_Price_Book__c> SalOrdItems = new List<Product_Order_Price_Book__c>();
        List<Product_Order_Price_Book__c> SOLIList = new List<Product_Order_Price_Book__c>();
        SaleOdList = [select id,TotalAmount__c,AccountId__c, BillingPersonNew__c,TotalProductPrice__c,Quantity__c, Orders_Status__c, Order_Type__c,Order_Created_Via__c, Delivary_Date__c from Sigma_Order__c where Orders_Status__c = 'Pending' AND Order_Created_Via__c = 'Community'];
        Map<String, SOLIWrapper>  CompleteProd = new Map<String, SOLIWrapper>();
        Map<String, List<Product_Order_Price_Book__c>>  CompleteProdwrap = new Map<String, List<Product_Order_Price_Book__c>>();
        List<Community_Configuration__c> Custset= new List<Community_Configuration__c>();
        Custset = [select Id,Name,Retailer_Community_URL__c,Products_Per_Page__c,Retailer_Profile_Name__c,Vendor_Community_URL__c,Vendor_Profile_Name__c from Community_Configuration__c where Name = 'ShoppingCart' LIMIT 1];
        
        if(SaleOdList.size() > 0)
        {
            SalOrdItems = [Select id,Sigma_Order__c,Ordered_Amount__c,Back_Order__c,Quantity__c,Product__c,Total_Price__c,Product__r.Name,Product__r.Description,Net_Quantity__c,Total_Amount__c from Product_Order_Price_Book__c where Sigma_Order__c =: SaleOdList[0].id];
            
            for(Product_Order_Price_Book__c  SOLI : SalOrdItems)
            {
                List<Product_Order_Price_Book__c> SalOrd = new List<Product_Order_Price_Book__c>();
                if(!CompleteProd.containsKey(SOLI.Product__c))
                {   
                    SOLIWrapper productobj = new SOLIWrapper();
                    SalOrd.add(SOLI);
                    productobj.id = SOLI.id;
                    productobj.SOid = SOLI.Sigma_Order__c;
                    productobj.ProductId = SOLI.Product__c;
                    productobj.Name=SOLI.Product__r.Name;
                    productobj.OrderedQuantity=Integer.valueof(SOLI.Net_Quantity__c);
                    productobj.UnitPrice=SOLI.Total_Amount__c;
                    productobj.ProductPrice=SOLI.Total_Price__c;
                    productobj.Description = SOLI.Product__r.Description;
                    productobj.Attachementsid = ProdImalink.get(SOLI.Product__c);
                    productobj.isBackOrder = SOLI.Back_Order__c;
                    productobj.OrderTotalPrice = SaleOdList[0].TotalAmount__c;
                    productobj.OrderedLineitemAmount = SOLI.Ordered_Amount__c;
                    if(Custset.size() > 0)
                        productobj.RetailerCommURL = Custset[0].Vendor_Community_URL__c;
                    if(SOLI.Back_Order__c)
                        productobj.BackOrder = SOLI.Id;
                    else
                        productobj.NotBackOrder = SOLI.Id;
                    productobj.LineitemAvlquant.put(SOLI.id,SOLI);
                    
                    productobj.Lineitemse.put(SOLI.Product__c, SalOrd);
                    CompleteProd.put(SOLI.Product__c,productobj);
                    SOLIList.add(SOLI);
                }
                else
                {
                    SOLIWrapper productobj = new SOLIWrapper();
                    productobj = CompleteProd.get(SOLI.Product__c);
                    if(Custset.size() > 0)
                        productobj.RetailerCommURL = Custset[0].Vendor_Community_URL__c;
                    productobj.OrderedQuantity += Integer.valueof(SOLI.Net_Quantity__c);
                    productobj.ProductPrice +=SOLI.Total_Price__c;
                    productobj.OrderTotalPrice = SaleOdList[0].TotalAmount__c;
                    productobj.OrderedLineitemAmount += SOLI.Ordered_Amount__c;
                    if(SOLI.Back_Order__c)
                        productobj.BackOrder = SOLI.Id;
                    else
                        productobj.NotBackOrder = SOLI.Id;
                    productobj.LineitemAvlquant.put(SOLI.id,SOLI);
                    productobj.Lineitemse.get(SOLI.Product__c).add(SOLI);
                    CompleteProd.put(SOLI.Product__c,productobj);
                    
                }
            }
            prodwrapList.addAll(CompleteProd.values());
            return prodwrapList;
        }
        else
        {
            return null;
        }
    }
    
     @AuraEnabled
    public static String  deleteProductFromCart(string soliId, string soId, string ProductId)
    {
        List<Product_Order_Price_Book__c> LIneListtoDelete = new List<Product_Order_Price_Book__c>();
            Sigma_Order__c ToDeleteList = [select id,(select id,Product__c from Order_Lines__r) from Sigma_Order__c where id =: soId];
            
            for(Product_Order_Price_Book__c LIntedelete : ToDeleteList.Order_Lines__r)
            {
                if(LIntedelete.Product__c == ProductId)
                {
                    LIneListtoDelete.add(LIntedelete);
                }
            }
            if(ToDeleteList.Order_Lines__r.size() == LIneListtoDelete.size())
            {
                delete ToDeleteList;
            }
            else
            {
                delete LIneListtoDelete;
            }
            return 'SUCCESS';
    }
    
    @AuraEnabled
    public static void ClearCartDetails(string customerid)
    {
            Sigma_Order__c SOobject=new Sigma_Order__c();
            List<Sigma_Order__c> soObjects = new List<Sigma_Order__c>();
            List<Product_Order_Price_Book__c> solilist = new List<Product_Order_Price_Book__c>();
            soObjects =[select id,AccountId__c, BillingPersonNew__c, Orders_Status__c, Order_Type__c,Order_Created_Via__c, Delivary_Date__c from Sigma_Order__c where Orders_Status__c = 'Pending' AND Order_Created_Via__c = 'Community'];
            delete soObjects;    
    }
    
    @AuraEnabled 
    public static string updateCartValue(String solilistjson)
    {       
            try{
                list<SOLIWrapper> prodwrapList = new list<SOLIWrapper>();
                list<Product_Order_Price_Book__c> Solilist = new list<Product_Order_Price_Book__c>();
                list<Product_Order_Price_Book__c> DeleteSolilist = new list<Product_Order_Price_Book__c>();
                list<SOLIWrapper> solideserlist = (list<SOLIWrapper>)JSON.deserialize(solilistjson , list<SOLIWrapper>.class);
                
                Map<String,Decimal> ProdInvQuant = new Map<String,Decimal>();
                SET<ID> OrderID = new SET<ID>();
                SET<ID> OrderProdID = new SET<ID>();
                SET<ID> AccountID = new SET<ID>();
               // AccountID.add(Acc.Id);
                Decimal TotalOrderPrice = 0.00;
                String OrderIDs = '';
                for(Inventory__c ProdInv : [select id,ProductCode__c,Available_Qty__c from Inventory__c where ProductCode__c != null])
                {
                    ProdInvQuant.put(ProdInv.ProductCode__c,ProdInv.Available_Qty__c);
                }
                for(SOLIWrapper SOLIwrap:solideserlist)
                {
                    OrderIDs = SOLIwrap.SOid;
                    OrderID.add(SOLIwrap.SOid);
                    OrderProdID.add(SOLIwrap.ProductId);
                    for(Product_Order_Price_Book__c LineTms : SOLIwrap.LineitemAvlquant.values())
                    {
                        if(SOLIwrap.OrderedQuantity > ProdInvQuant.get(LineTms.Product__c) && LineTms.Back_Order__c )
                        {
                            Product_Order_Price_Book__c Soliobj = new Product_Order_Price_Book__c();
                            Soliobj.id = LineTms.id;
                            Soliobj.Net_Quantity__c=SOLIwrap.OrderedQuantity - ProdInvQuant.get(LineTms.Product__c);
                            Soliobj.Total_Price__c = (SOLIwrap.OrderedQuantity - ProdInvQuant.get(LineTms.Product__c)) * LineTms.Total_Amount__c;
                            Soliobj.Ordered_Amount__c = (SOLIwrap.OrderedQuantity - ProdInvQuant.get(LineTms.Product__c)) * LineTms.Total_Amount__c;
                            Solilist.add(Soliobj);
                        }
                        else if(SOLIwrap.OrderedQuantity <= ProdInvQuant.get(LineTms.Product__c) && LineTms.Back_Order__c)
                        {
                            Product_Order_Price_Book__c Soliobj = new Product_Order_Price_Book__c();
                            Soliobj.id = LineTms.id;
                            DeleteSolilist.add(Soliobj);
                        }
                        else if(SOLIwrap.OrderedQuantity > ProdInvQuant.get(LineTms.Product__c) && !LineTms.Back_Order__c)
                        {
                            
                            if(SOLIwrap.Lineitemse.get(LineTms.Product__c).size() == 1)
                            {
                                Product_Order_Price_Book__c Soliobj = new Product_Order_Price_Book__c();
                                Soliobj.id = LineTms.id;
                                Soliobj.Quantity__c = ProdInvQuant.get(LineTms.Product__c);
                                Soliobj.Net_Quantity__c = ProdInvQuant.get(LineTms.Product__c);
                                Soliobj.Remaining_Qty_To_Package__c = ProdInvQuant.get(LineTms.Product__c);
                                Soliobj.Total_Price__c = ProdInvQuant.get(LineTms.Product__c)* LineTms.Total_Amount__c;
                                Soliobj.Ordered_Amount__c = ProdInvQuant.get(LineTms.Product__c)* LineTms.Total_Amount__c;
                                TotalOrderPrice += ProdInvQuant.get(LineTms.Product__c)* LineTms.Total_Amount__c;
                                Solilist.add(Soliobj);
                                
                                Product_Order_Price_Book__c backSoliobj = new Product_Order_Price_Book__c();
                                backSoliobj.Product__c = LineTms.Product__c;
                                backSoliobj.Sigma_Order__c = LineTms.Sigma_Order__c;
                                backSoliobj.Total_Amount__c = LineTms.Total_Amount__c;
                                backSoliobj.Net_Quantity__c = SOLIwrap.OrderedQuantity - ProdInvQuant.get(LineTms.Product__c);
                                backSoliobj.Remaining_Qty_To_Package__c = SOLIwrap.OrderedQuantity - ProdInvQuant.get(LineTms.Product__c);
                                backSoliobj.Back_Order__c = true;
                                backSoliobj.Total_Price__c = (SOLIwrap.OrderedQuantity - ProdInvQuant.get(LineTms.Product__c))* LineTms.Total_Amount__c;
                                backSoliobj.Ordered_Amount__c = (SOLIwrap.OrderedQuantity - ProdInvQuant.get(LineTms.Product__c)) * LineTms.Total_Amount__c;
                                Solilist.add(backSoliobj);
                            }
                            else if(SOLIwrap.Lineitemse.get(LineTms.Product__c).size() == 2)
                            {
                                Product_Order_Price_Book__c Soliobj = new Product_Order_Price_Book__c();
                                Soliobj.id = LineTms.id;
                                Soliobj.Quantity__c = ProdInvQuant.get(LineTms.Product__c);
                                Soliobj.Net_Quantity__c = ProdInvQuant.get(LineTms.Product__c);
                                Soliobj.Remaining_Qty_To_Package__c = ProdInvQuant.get(LineTms.Product__c);
                                Soliobj.Total_Price__c = ProdInvQuant.get(LineTms.Product__c)* LineTms.Total_Amount__c;
                                Soliobj.Ordered_Amount__c = ProdInvQuant.get(LineTms.Product__c)* LineTms.Total_Amount__c;
                                TotalOrderPrice += ProdInvQuant.get(LineTms.Product__c)* LineTms.Total_Amount__c;
                                Solilist.add(Soliobj);
                            }
                        }
                        else if(SOLIwrap.OrderedQuantity <= ProdInvQuant.get(LineTms.Product__c) && !LineTms.Back_Order__c)
                        {
                            Product_Order_Price_Book__c Soliobj = new Product_Order_Price_Book__c();
                            Soliobj.id = LineTms.id;
                            Soliobj.Quantity__c=SOLIwrap.OrderedQuantity;
                            Soliobj.Net_Quantity__c=SOLIwrap.OrderedQuantity;
                            Soliobj.Remaining_Qty_To_Package__c = SOLIwrap.OrderedQuantity;
                            Soliobj.Total_Price__c = SOLIwrap.OrderedQuantity * LineTms.Total_Amount__c;
                            Soliobj.Ordered_Amount__c = SOLIwrap.OrderedQuantity * LineTms.Total_Amount__c;
                            TotalOrderPrice += SOLIwrap.OrderedQuantity * LineTms.Total_Amount__c;
                            Solilist.add(Soliobj);
                        }
                    }
                }
                upsert Solilist;
               // utilityClass.DiscountDetails(OrderId,AccountID,OrderProdID);
                delete DeleteSolilist;
                return 'SUCCESS';
            }
            catch (Exception e)
            {
                return 'ERROR';
    }
    }
    
      public class SOLIWrapper
    {
        @AuraEnabled
        public String Id {get;set;}
        @AuraEnabled
        public String SOid {get;set;}
        @AuraEnabled
        public String Name {get;set;}
        @AuraEnabled
        public String OrderLineName {get;set;}
        @AuraEnabled
        public String OrderlineStatus {get;set;}
        @AuraEnabled
        public Decimal OrderedLineitemAmount {get;set;}
        @AuraEnabled
        public String ProductId {get;set;}
        @AuraEnabled
        public String producttype {get;set;}
        @AuraEnabled
        public Integer OrderedQuantity {get;set;}
        @AuraEnabled
        public Decimal UnitPrice {get;set;}
        @AuraEnabled
        public String Description {get;set;}
        @AuraEnabled
        public String Attachementsid {get;set;}
        @AuraEnabled
        public Decimal ProductPrice {get;set;}
        @AuraEnabled
        public Decimal OrderTotalPrice {get;set;}
        @AuraEnabled
        public Decimal AvailableQuantity {get;set;}
        @AuraEnabled
        public boolean isBackOrder {get;set;}
        @AuraEnabled
        public Map<String, Product_Order_Price_Book__c> LineitemAvlquant =new Map<String, Product_Order_Price_Book__c>();
        @AuraEnabled
        public String PreviousQuantity {get;set;}
        @AuraEnabled
        public String NotBackOrder {get;set;}
        @AuraEnabled
        public String BackOrder {get;set;}
        @AuraEnabled
        public Map<String, List<Product_Order_Price_Book__c>> Lineitemse =new Map<String, List<Product_Order_Price_Book__c>>();
        @AuraEnabled
        public String OrderName {get;set;}
        @AuraEnabled
        public String AccountName {get;set;}
        @AuraEnabled
        public String OrderStatus {get;set;}
        @AuraEnabled
        public String CreatedVia {get;set;}
        @AuraEnabled
        public Date OrderLineDate {get;set;}
        @AuraEnabled
        public String RetailerCommURL;
    }
    public class ResponseWrapper
    {
        @AuraEnabled
        public Integer pageSize;
        @AuraEnabled
        public Integer page;
        @AuraEnabled
        public Integer totalRecords ;
        @AuraEnabled
        public List<String> ListOfStatus;       
        @AuraEnabled
        public List<SalesOrderWrap> SOList;
        @AuraEnabled
        public List<SOLIWrapper> SOListWRAP;
        @AuraEnabled
        public String errorMessage;
        @AuraEnabled
        public String Status;
        
    }
    public class SalesOrderWrap
    {
        @AuraEnabled
        public Sigma_Order__c SO;
        @AuraEnabled
        public List<Product_Order_Price_Book__c> SOLI;
    }
    public class SalesOrderWrapNew
    {
        @AuraEnabled
        public Sigma_Order__c SO;
        @AuraEnabled
        public List<SOLIWrapper> SOLI;
        
    }
    public class ViewSalesorderPagination
    {
        @AuraEnabled
        public Integer pageSize;
        @AuraEnabled
        public Integer page;
        @AuraEnabled
        public Integer totalRecords ;
        @AuraEnabled
        public List<SalesOrderWrapNew> SalesViewList ; 
    }
}