public with sharing class viewCartctrl {
    @AuraEnabled
    public static contact getCurrentUserContact()
    {
        utilityClass.userWrapper ConDetail = utilityClass.Userdetails();
        if(CRUD_FLS_CheckUtility.checkReadPermission('Contact',new set<String>{'id','Name','AccountId'})
            && CRUD_FLS_CheckUtility.checkReadPermission('User',new set<String>{'id','Name','ContactId','Email','Contact.Name','Contact.Account.Name'}))
        {
            if(ConDetail.Userobj.ContactId !=null)
                return ConDetail.ContactsId;
            else
                return null;
        }
        return ConDetail.ContactsId;
    }
    
    @AuraEnabled
    public static List<SOLIWrapper> getAllCartDetails()
    {
        List<SOLIWrapper> prodwrapList = new List<SOLIWrapper>();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c') 
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('ContentDocumentLink')
        //&& CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Community_Configuration__c')
        
        && CRUD_FLS_CheckUtility.checkReadPermission('Contact',new set<String>{'id','Name','AccountId'})
        && CRUD_FLS_CheckUtility.checkReadPermission('User',new set<String>{'id','Name','ContactId','Email','Contact.Name','Contact.Account.Name'})
        && CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'id','name','sigmaerpdev2__Customer_Type__c','sigmaerpdev2__Currency_code__c','ShippingAddress'})
        && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'id','Name','sigmaerpdev2__Product_Type__c','sigmaerpdev2__Product_Price__c','sigmaerpdev2__Bar_Code_Gene__c','sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Type__c','sigmaerpdev2__Reorder_Quantity__c','sigmaerpdev2__Threshold_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('Attachment',new set<String>{'id'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new set<String>{'id','sigmaerpdev2__TotalAmount__c','sigmaerpdev2__AccountId__c','sigmaerpdev2__BillingPersonNew__c','sigmaerpdev2__TotalProductPrice__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Orders_Status__c','sigmaerpdev2__Order_Type__c','sigmaerpdev2__Order_Created_Via__c','sigmaerpdev2__Delivary_Date__c','CreatedById'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'id','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__Back_Order__c','sigmaerpdev2__Ordered_Amount__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Product__r.Description','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Total_Price__c','sigmaerpdev2__Total_Amount__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('ContentDocumentLink',new set<String>{'id','ContentDocumentId','ContentDocument.FileExtension','ContentDocument.LatestPublishedVersionId','ContentDocument.LatestPublishedVersion.Title','SystemModstamp','LinkedEntityId','Visibility','ShareType'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Community_Configuration__c',new set<String>{'id','Name','sigmaerpdev2__Retailer_Community_URL__c','sigmaerpdev2__Products_Per_Page__c','sigmaerpdev2__Retailer_Profile_Name__c','sigmaerpdev2__Vendor_Community_URL__c','sigmaerpdev2__Vendor_Profile_Name__c'})
        )
        {
            utilityClass.userWrapper ConDetail = utilityClass.Userdetails();
            Id UserId= ConDetail.UserIds;
            User currentuser = ConDetail.Userobj;
            Contact ConId = ConDetail.ContactsId;
            Account Acc = ConDetail.AccountsID;
            Map<String,String> AttchId = new Map<String,String>();
            SET<ID> ProdId=new SET<ID>();
            Map<Id,Id> ProdImalink= new Map<Id,Id>();
            
            for(Product2 ProList : [select Id,Name,Product_Price__c,Bar_Code_Gene__c,Attribute_Type__c,Product_Type__c,Type__c,Reorder_Quantity__c,Threshold_Quantity__c,(SELECT Id FROM Attachments) from Product2 where Id != null and Product_Price__c != null and Stock_Item__c =true])
            {
                ProdId.add(ProList.Id);
                if(ProList.Attachments.size() > 0)
                AttchId.put(ProList.Id,ProList.Attachments[0].Id);
            }
            for(ContentDocumentLink Contelink : [SELECT Id, ContentDocumentId,ContentDocument.FileExtension, ContentDocument.LatestPublishedVersionId,ContentDocument.LatestPublishedVersion.Title,SystemModstamp,LinkedEntityId,Visibility,ShareType FROM ContentDocumentLink WHERE LinkedEntityId IN: ProdId and ContentDocument.FileExtension IN ('jpg','png') order by SystemModstamp ASC])
            {
                ProdImalink.put(Contelink.LinkedEntityId,Contelink.ContentDocument.LatestPublishedVersionId);
            } 
            List<Sigma_Order__c> SaleOdList=new List<Sigma_Order__c>();
            List<Product_Order_Price_Book__c> SalOrdItems = new List<Product_Order_Price_Book__c>();
            List<Product_Order_Price_Book__c> SOLIList = new List<Product_Order_Price_Book__c>();
            SaleOdList = [select id,TotalAmount__c,AccountId__c, BillingPersonNew__c,TotalProductPrice__c,Quantity__c, Orders_Status__c, Order_Type__c,Order_Created_Via__c, Delivary_Date__c from Sigma_Order__c where AccountId__c =:Acc.id AND Orders_Status__c = 'Pending' AND Order_Created_Via__c = 'Community' and CreatedById =: UserId];
            Map<String, SOLIWrapper>  CompleteProd = new Map<String, SOLIWrapper>();
            Map<String, List<Product_Order_Price_Book__c>>  CompleteProdwrap = new Map<String, List<Product_Order_Price_Book__c>>();
            List<Community_Configuration__c> Custset= new List<Community_Configuration__c>();
            Custset = [select Id,Name,Retailer_Community_URL__c,Products_Per_Page__c,Retailer_Profile_Name__c,Vendor_Community_URL__c,Vendor_Profile_Name__c from Community_Configuration__c where Name = 'Community Configurations' LIMIT 1];
            
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
                        productobj.RetailerCommURL = Custset[0].Retailer_Community_URL__c;
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
                        productobj.RetailerCommURL = Custset[0].Retailer_Community_URL__c;
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
        return prodwrapList;
    }
    
    @AuraEnabled
    public static String  deleteProductFromCart(string soliId, string soId, string ProductId)
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c') 
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new set<String>{'id'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'id','sigmaerpdev2__Product__c'}))
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
        return 'SUCCESS';
    }
    @AuraEnabled
    public static void ClearCartDetails(string customerid)
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c') 
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c')
        
            && CRUD_FLS_CheckUtility.checkReadPermission('Contact',new set<String>{'id','Name','AccountId'})
            && CRUD_FLS_CheckUtility.checkReadPermission('User',new set<String>{'id','Name','ContactId'})
            && CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'id','name'})
            && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'id','Name','sigmaerpdev2__Product_Type__c','sigmaerpdev2__Product_Price__c','sigmaerpdev2__Bar_Code_Gene__c','sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Type__c','sigmaerpdev2__Reorder_Quantity__c','sigmaerpdev2__Threshold_Quantity__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new set<String>{'id','sigmaerpdev2__AccountId__c','sigmaerpdev2__BillingPersonNew__c','sigmaerpdev2__Orders_Status__c','sigmaerpdev2__Order_Type__c','sigmaerpdev2__Order_Created_Via__c','sigmaerpdev2__Delivary_Date__c','CreatedById'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'id','name'}))
        {
            utilityClass.userWrapper ConDetail = utilityClass.Userdetails();
            Id UserId= ConDetail.UserIds;
            User currentuser = ConDetail.Userobj;
            Contact ConId = ConDetail.ContactsId;
            Account Acc = ConDetail.AccountsID;
            Sigma_Order__c SOobject=new Sigma_Order__c();
            List<Sigma_Order__c> soObjects = new List<Sigma_Order__c>();
            List<Product_Order_Price_Book__c> solilist = new List<Product_Order_Price_Book__c>();
            soObjects =[select id,AccountId__c, BillingPersonNew__c, Orders_Status__c, Order_Type__c,Order_Created_Via__c, Delivary_Date__c from Sigma_Order__c where AccountId__c =:Acc.id AND Orders_Status__c = 'Pending' AND Order_Created_Via__c = 'Community' and CreatedById =: UserId];
            delete soObjects;
        }
        
    }
    @AuraEnabled 
    public static string updateCartValue(String solilistjson)
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c') 
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
            
            && CRUD_FLS_CheckUtility.checkReadPermission('Contact',new set<String>{'id','Name','AccountId'})
            && CRUD_FLS_CheckUtility.checkReadPermission('User',new set<String>{'id','Name','ContactId','Email','Contact.Name','Contact.Account.Name'})
            && CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'id','name','sigmaerpdev2__Customer_Type__c','sigmaerpdev2__Currency_code__c','ShippingAddress'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new set<String>{'id','sigmaerpdev2__TotalAmount__c','sigmaerpdev2__AccountId__c','sigmaerpdev2__BillingPersonNew__c','sigmaerpdev2__TotalProductPrice__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Orders_Status__c','sigmaerpdev2__Order_Type__c','sigmaerpdev2__Order_Created_Via__c','sigmaerpdev2__Delivary_Date__c','CreatedById'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'id','sigmaerpdev2__Remaining_Qty_To_Package__c','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__Back_Order__c','sigmaerpdev2__Stock_Fulfilled__c','sigmaerpdev2__Ordered_Amount__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Product__r.Description','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Total_Price__c','sigmaerpdev2__Total_Amount__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new set<String>{'id','sigmaerpdev2__ProductCode__c','sigmaerpdev2__Available_Qty__c'})
            
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Total_Price__c','sigmaerpdev2__Ordered_Amount__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Remaining_Qty_To_Package__c','sigmaerpdev2__Product__c','sigmaerpdev2__Total_Amount__c','sigmaerpdev2__Back_Order__c','sigmaerpdev2__Stock_Fulfilled__c'})
            
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev2__Sigma_Order__c'}))
        {
        
            try{
                utilityClass.userWrapper ConDetail = utilityClass.Userdetails();
                Id UserId= ConDetail.UserIds;
                User currentuser = ConDetail.Userobj;
                Account Acc = ConDetail.AccountsID;
                list<SOLIWrapper> prodwrapList = new list<SOLIWrapper>();
                list<Product_Order_Price_Book__c> Solilist = new list<Product_Order_Price_Book__c>();
                list<Product_Order_Price_Book__c> DeleteSolilist = new list<Product_Order_Price_Book__c>();
                list<SOLIWrapper> solideserlist = (list<SOLIWrapper>)JSON.deserialize(solilistjson , list<SOLIWrapper>.class);
                
                Map<String,Decimal> ProdInvQuant = new Map<String,Decimal>();
                SET<ID> OrderID = new SET<ID>();
                SET<ID> OrderProdID = new SET<ID>();
                SET<ID> AccountID = new SET<ID>();
                AccountID.add(Acc.Id);
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
                                backSoliobj.Stock_Fulfilled__c = false;
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
                utilityClass.DiscountDetails(OrderId,AccountID,OrderProdID);
                delete DeleteSolilist;
                return 'SUCCESS';
            }
            catch (Exception e)
            {
                return 'ERROR';
            }
        }
        return 'SUCCESS';
    }
    @AuraEnabled
    public static ResponseWrapper placeOrder(String solilistjson)
    {
        ResponseWrapper RespoWrap = new ResponseWrapper(); 
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Dimension_Tag__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c') 
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c')
            
            && CRUD_FLS_CheckUtility.checkReadPermission('Contact',new set<String>{'id','Name','AccountId'})
            && CRUD_FLS_CheckUtility.checkReadPermission('User',new set<String>{'id','Name','ContactId'})
            && CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'id','name','sigmaerpdev2__Customer_Type__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new set<String>{'id','sigmaerpdev2__Orders_Status__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'id','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__Order_Status__c','sigmaerpdev2__IsInventoryUpdated__c','sigmaerpdev2__Product__c','sigmaerpdev2__Back_Order__c','sigmaerpdev2__Net_Quantity__c','Inventory_Status__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Dimension_Tag__c',new Set<String>{'id','sigmaerpdev2__Account__c','sigmaerpdev2__Base_Credit_Limit__c','sigmaerpdev2__Due_Amount__c','sigmaerpdev2__Ordered_Amount__c','sigmaerpdev2__Paid_Amount__c','sigmaerpdev2__Remaining_Credit_Limit__c'})
            
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Order__c',new set<String>{'sigmaerpdev2__Orders_Status__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev2__Order_Status__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Dimension_Tag__c',new Set<String>{'sigmaerpdev2__Ordered_Amount__c'}))
        {
            try{
                utilityClass.userWrapper ConDetail = utilityClass.Userdetails();
                Id UserId= ConDetail.UserIds;
                User currentuser = ConDetail.Userobj;
                Contact ConId = ConDetail.ContactsId;
                Account Acc = ConDetail.AccountsID;
                list<SOLIWrapper> prodwrapList = new list<SOLIWrapper>();
                list<Sigma_Order__c> Solilist = new list<Sigma_Order__c>();
                list<SOLIWrapper> solideserlist = (list<SOLIWrapper>)JSON.deserialize(solilistjson , list<SOLIWrapper>.class);
                SET<Id> OrderId = new SET<Id>();
                SET<Id> OrderLineProdId = new SET<Id>();
                SET<Id> AccountId = new SET<Id>();
                AccountId.add(Acc.Id);
                Map<String,Sigma_Order__c> Salorders = new Map<String,Sigma_Order__c>();
                List<Product_Order_Price_Book__c> PriceBookdetaie = new List<Product_Order_Price_Book__c>();
                List<Product_Order_Price_Book__c> OrderlineUpdate = new List<Product_Order_Price_Book__c>();
                List<Dimension_Tag__c> Creditamount = new List<Dimension_Tag__c>();
                SET<Dimension_Tag__c> OrdAmtUpdateUnique = new SET<Dimension_Tag__c>();
                List<Dimension_Tag__c> OrdAmtUpdate = new List<Dimension_Tag__c>();
                Creditamount = [select Id,Account__c,Base_Credit_Limit__c,Due_Amount__c,Ordered_Amount__c,Paid_Amount__c,Remaining_Credit_Limit__c from Dimension_Tag__c where Account__c =: Acc.Id];
                
                for(SOLIWrapper SOLIwrap:solideserlist)
                {
                    Sigma_Order__c Soliobj = new Sigma_Order__c();
                    Soliobj.id = SOLIwrap.SOid;
                    OrderId.add(SOLIwrap.SOid);
                    OrderLineProdId.add(SOLIwrap.ProductId);
                     if(Acc.Customer_Type__c == 'Credit Customer')
                     {
                         if(Creditamount.size() >= 1 && (SOLIwrap.OrderTotalPrice < Creditamount[0].Remaining_Credit_Limit__c))
                         {
                            Dimension_Tag__c UpdateoRdAmt = new Dimension_Tag__c();
                            Soliobj.Orders_Status__c = 'Order Confirmed';
                            UpdateoRdAmt.Id = Creditamount[0].Id;
                            if(Creditamount[0].Ordered_Amount__c == null)
                                UpdateoRdAmt.Ordered_Amount__c = 0.00 + SOLIwrap.OrderTotalPrice;
                            else                        
                            UpdateoRdAmt.Ordered_Amount__c = Creditamount[0].Ordered_Amount__c + SOLIwrap.OrderTotalPrice;
                            OrdAmtUpdateUnique.add(UpdateoRdAmt);
                           
                             
                         }
                         else
                         {
                            RespoWrap.errorMessage = 'Your Credit limit has been exceeded, please add credit to your Account to proceed the Order';
                            RespoWrap.Status = 'ERROR';
                            return RespoWrap;
                         }
                     }
                     else
                     {
                        Soliobj.Orders_Status__c = 'Submitted';
                     }
                    if(!Salorders.containsKey(Soliobj.id))
                    {
                        Salorders.put(Soliobj.id,Soliobj);
                        Solilist.add(Soliobj);
                    }
                }
                
                OrdAmtUpdate.addAll(OrdAmtUpdateUnique);
                update OrdAmtUpdate;
                for(Product_Order_Price_Book__c ProdLineUpdate : [select Id,Order_Status__c,Sigma_Order__c from Product_Order_Price_Book__c where Sigma_Order__c IN : OrderId])
                {
                    Product_Order_Price_Book__c Orderline= new Product_Order_Price_Book__c();
                    if(Acc.Customer_Type__c == 'Credit Customer')
                    {
                        Orderline.Id = ProdLineUpdate.Id;
                        Orderline.Order_Status__c = 'Order Confirmed';
                        Orderline.Is_Credit_Updated__c = true;
                        OrderlineUpdate.add(Orderline);
                    }
                    else if(Acc.Customer_Type__c == 'Cash Customer')
                    {
                        Orderline.Id = ProdLineUpdate.Id;
                        Orderline.Order_Status__c = 'Pending';
                        OrderlineUpdate.add(Orderline);
                    }
                }
                if(OrderlineUpdate.size() > 0)
                    update OrderlineUpdate;
                    update Solilist;
               
                utilityClass.DiscountDetails(OrderId,AccountId,OrderLineProdId);
                PriceBookdetaie = [Select Id,Sigma_Order__c,IsInventoryUpdated__c,Product__c,Back_Order__c,Net_Quantity__c,Order_Status__c,Sigma_Order__r.Order_Created_Via__c,Sigma_Order__r.No_Picking_Package_Shipment_Required__c,Inventory_Status__c from Product_Order_Price_Book__c where Sigma_Order__c IN : OrderId AND Back_Order__c != true];
                
                if(PriceBookdetaie.size() >= 1 && Acc.Customer_Type__c == 'Credit Customer')
                {
                    autostockreservation.autostockreserve(PriceBookdetaie); 
                }
                 
                RespoWrap.errorMessage = 'Order has been placed Successfully';
                RespoWrap.Status = 'SUCCESS';
                return RespoWrap;
            }
            catch (Exception e)
            {
                RespoWrap.errorMessage = e.getMessage();
                RespoWrap.Status = 'ERROR';
                return RespoWrap;
            }
        }
        return RespoWrap;
    }
    @AuraEnabled
    public static ViewSalesorderPagination FetchSalesOrders(String PageNumber)
    {
        ViewSalesorderPagination ResWrapView = new ViewSalesorderPagination();
        List<SalesOrderWrapNew> responseWrapper = new List<SalesOrderWrapNew>();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c') 
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Community_Configuration__c',new set<String>{'Id','sigmaerpdev2__Orders_Per_Page__c','Name','sigmaerpdev2__Retailer_Community_URL__c','sigmaerpdev2__Products_Per_Page__c','sigmaerpdev2__Retailer_Profile_Name__c','sigmaerpdev2__Vendor_Community_URL__c','sigmaerpdev2__Vendor_Profile_Name__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('Contact',new set<String>{'id','Name','AccountId'})
            && CRUD_FLS_CheckUtility.checkReadPermission('User',new set<String>{'id','Name','ContactId'})
            && CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'id','name','sigmaerpdev2__Customer_Type__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new set<String>{'id','name','sigmaerpdev2__Orders_Status__c','AccountId__c','AccountId__r.Customer_Type__c','AccountId__r.name','Order_Created_Via__c','Customer_Type__c','Delivary_Date__c','CreatedById','CreatedDate'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'id','name','sigmaerpdev2__Total_Price__c','sigmaerpdev2__Delivary_Date__c','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__Sigma_Order__r.name','sigmaerpdev2__Product__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Order_Status__c'}))
        {
            try
            {
                Id currentuserId = UserInfo.getUserId();
                Contact ConID=getCurrentUserContact();
                Id AccId=ConID.AccountId;
                Set<Id> OrdID = new Set<Id>();
                List<Community_Configuration__c> Custset= new List<Community_Configuration__c>();
                Custset = [select Id,Name,Orders_Per_Page__c,Products_Per_Page__c,Retailer_Community_URL__c,Retailer_Profile_Name__c,Vendor_Community_URL__c,Vendor_Profile_Name__c from Community_Configuration__c where Name = 'Community Configurations' LIMIT 1];
                Integer pageRecSize = Integer.valueOf(Custset[0].Orders_Per_Page__c);
                Integer offset = (Integer.valueof(pageNumber) - 1) * pageRecSize;
                List<Sigma_Order__c> soListsize = [Select Id,Name,Orders_Status__c,AccountId__c,AccountId__r.Customer_Type__c,AccountId__r.name,Order_Created_Via__c,Customer_Type__c,Delivary_Date__c,(select id,Total_Price__c,Delivary_Date__c,Name,Sigma_Order__c,Sigma_Order__r.name,Product__c,Product__r.name,Quantity__c,Net_Quantity__c,Order_Status__c from Order_Lines__r) from Sigma_Order__c where CreatedById =:currentuserId AND Orders_Status__c != 'Pending' order by CreatedDate desc];
                List<Sigma_Order__c> soList = [Select Id,Name,Orders_Status__c,AccountId__c,AccountId__r.Customer_Type__c,AccountId__r.name,Order_Created_Via__c,Customer_Type__c,Delivary_Date__c,(select id,Total_Price__c,Delivary_Date__c,Name,Sigma_Order__c,Sigma_Order__r.name,Product__c,Product__r.name,Quantity__c,Net_Quantity__c,Order_Status__c from Order_Lines__r) from Sigma_Order__c where CreatedById =:currentuserId AND Orders_Status__c != 'Pending' order by CreatedDate desc LIMIT : pageRecSize OFFSET:offset];
                Map<Id,Map<Id,SOLIWrapper>> SOnSOLIListMap = new Map<Id,Map<Id,SOLIWrapper>>();
                //String QueryData = 'select Id,Name,Orders_Status__c,AccountId__c,AccountId__r.Customer_Type__c,AccountId__r.name,Order_Created_Via__c,Customer_Type__c,Delivary_Date__c from Sigma_Order__c where CreatedById =:currentuserId AND Orders_Status__c != \''+Pending+'\'order by CreatedDate desc';
                List<SalesOrderWrap> SOWrapList = new List<SalesOrderWrap>();
                List<SOLIWrapper> SOLineWrapList = new List<SOLIWrapper>();
                
                //Order logic starts here
                for(Sigma_Order__c order : soList)
                {
                    SalesOrderWrapNew indSalesOrderWrap = new SalesOrderWrapNew();
                    indSalesOrderWrap.SO = order;
                    indSalesOrderWrap.SOLI = new List<SOLIWrapper>();
                    Map<Id,SOLIWrapper> ProOrderline = new Map<Id,SOLIWrapper>();
                    for(Product_Order_Price_Book__c OrderLines : order.Order_Lines__r)
                    {
                        if(ProOrderline.containsKey(OrderLines.Product__c))
                        {
                            SOLIWrapper productobj = new SOLIWrapper();
                            productobj = ProOrderline.get(OrderLines.Product__c);
                            productobj.OrderedQuantity += Integer.valueof(OrderLines.Net_Quantity__c);
                            productobj.ProductPrice += OrderLines.Total_Price__c;
                            ProOrderline.put(OrderLines.Product__c,productobj);
                        }
                        else
                        {
                            SOLIWrapper productobj = new SOLIWrapper();
                            productobj.id = OrderLines.id;
                            productobj.SOid = OrderLines.Sigma_Order__c;
                            productobj.ProductId = OrderLines.Product__c;
                            productobj.OrderName = order.name;
                            productobj.AccountName = order.AccountId__r.name;
                            productobj.OrderStatus = order.Orders_Status__c;
                            productobj.CreatedVia = order.Order_Created_Via__c;
                            productobj.OrderLineDate = OrderLines.Delivary_Date__c;
                            productobj.Name = OrderLines.Product__r.Name;
                            productobj.OrderLineName=OrderLines.Name;
                            productobj.OrderedQuantity=Integer.valueof(OrderLines.Net_Quantity__c);
                            productobj.ProductPrice=OrderLines.Total_Price__c;
                            productobj.OrderlineStatus = OrderLines.Order_Status__c;
                            ProOrderline.put(OrderLines.Product__c,productobj);
                        }
                    }
                    indSalesOrderWrap.SOLI.addAll(ProOrderline.values());
                    responseWrapper.add(indSalesOrderWrap);
                }
                ResWrapView.SalesViewList = responseWrapper;
                ResWrapView.pageSize = pageRecSize;
                ResWrapView.totalRecords = soListsize.size();
                ResWrapView.page = Integer.valueof(PageNumber);
                return ResWrapView;
            }
            catch (Exception e)
            {
                return null;
            }
        }
        return ResWrapView;
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