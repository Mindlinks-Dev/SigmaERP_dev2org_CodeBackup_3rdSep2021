public with sharing class utilityClass {
    public static userWrapper Userdetails()
    {
        userWrapper Userdet = new userWrapper();
        if(CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'id','Name','sigmaerpdev2__Product_Type__c'})
             && CRUD_FLS_CheckUtility.checkReadPermission('Contact',new set<String>{'id','Name','AccountId'})
             && CRUD_FLS_CheckUtility.checkReadPermission('User',new set<String>{'id','Name','ContactId','Email','Contact.Name','Contact.Account.Name'})
             && CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'id','name','sigmaerpdev2__Customer_Type__c','sigmaerpdev2__Currency_code__c','ShippingAddress'}))
        {
            Id UserId= UserInfo.getUserId();
            User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
            Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
            Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
            
            Userdet.UserIds = UserId;
            Userdet.Userobj = currentuser;
            Userdet.ContactsId = ConId;
            Userdet.AccountsID = Acc;
        }
        return Userdet;
    }
    public static void DiscountDetails(SET<ID> OrderID, SET<ID> CustomerID, SET<ID> OrderLineID)
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c') 
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Currency__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Currency_Exchange_Rate__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Price__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Tax__c')
        
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new set<String>{'id','sigmaerpdev2__TotalAmount__c','sigmaerpdev2__Currency__c','sigmaerpdev2__Order_Created_Via__c','sigmaerpdev2__Net_Amount__c','sigmaerpdev2__Tax_Amount__c','sigmaerpdev2__Tax__c','sigmaerpdev2__Exchange_Net_Amount__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Currency__c',new set<String>{'id','sigmaerpdev2__Symbol__c','sigmaerpdev2__Currency_Code__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Currency_Exchange_Rate__c',new set<String>{'id','sigmaerpdev2__Rate__c','sigmaerpdev2__Currency__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Price__c',new set<String>{'id','sigmaerpdev2__Product_Id__c','sigmaerpdev2__Discout__c','sigmaerpdev2__Customer__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'id','sigmaerpdev2__Discounts__c','sigmaerpdev2__Ordered_Amount__c','sigmaerpdev2__IsInventoryUpdated__c','sigmaerpdev2__Product__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Order_Status__c','sigmaerpdev2__Back_Order__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Total_Price__c','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Total_Amount__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Tax__c',new set<String>{'id','sigmaerpdev2__Tax_Amount__c','sigmaerpdev2__Type__c','sigmaerpdev2__IsInventoryUpdated__c','sigmaerpdev2__Product__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Order_Status__c','sigmaerpdev2__Back_Order__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Total_Price__c','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Total_Amount__c'})
        
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Order__c',new set<String>{'sigmaerpdev2__Net_Amount__c','sigmaerpdev2__Tax_Amount__c','sigmaerpdev2__Tax__c','sigmaerpdev2__TotalAmount__c','sigmaerpdev2__Exchange_Net_Amount__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev2__Discounts__c','sigmaerpdev2__Total_Price__c','sigmaerpdev2__Ordered_Amount__c','sigmaerpdev2__Product__c'})
        
        && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev2__Sigma_Order__c'})
        && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Sigma_Order__c',new Set<String>{'sigmaerpdev2__AccountId__c'}))
    
    {
                                                
                                                
        List<Product_Order_Price_Book__c> PriceBookdetaie = new List<Product_Order_Price_Book__c>();
        List<Product_Price__c> ProdPrice = new List<Product_Price__c>();
        SET<ID> ProdID = new SET<ID>();
        Map<String, Decimal> ProdDiscount = new map<String, Decimal>();
        List<Sigma_Order__c> OrderList = new List<Sigma_Order__c>();
       
        Decimal TotalOrderAmount = 0.00;
        
        List<string> soString =new List<string>(); 
        List<Currency__c> currSymbol = new List<Currency__c>();
        for(Sigma_Order__c Ordesigma : [Select Id,TotalAmount__c,Currency__c from Sigma_Order__c where Id IN : OrderID])
        {
            
            soString.add(Ordesigma.Currency__c);
        }
       
        if( soString != null && soString.size() != 0 ) 
            currSymbol = [select id,Symbol__c,Currency_Code__c from Currency__c where Id =: soString limit 1];
        List<Currency_Exchange_Rate__c> currExRate = new List<Currency_Exchange_Rate__c> ();
        currExRate = [select id,Rate__c,Currency__c from Currency_Exchange_Rate__c where Currency__c =: soString];
        for(Product_Price__c ProdDisc : [select Id,Product_Id__c,Status__c,Discout__c,Customer__c,Start_Date__c,End_Date__c from Product_Price__c where Customer__c IN : CustomerID AND Status__c = 'Active' AND Product_Id__c IN : OrderLineID AND Start_Date__c <= today AND End_Date__c >= today])
        {
            ProdDiscount.put(ProdDisc.Product_Id__c,ProdDisc.Discout__c);
        }
        for(Sigma_Order__c OrderUp : [Select Id,TotalAmount__c,AccountId__c,Order_Created_Via__c,(Select Id,Discounts__c,Ordered_Amount__c,Sigma_Order__c,IsInventoryUpdated__c,Product__c,Net_Quantity__c,Order_Status__c,Back_Order__c,Quantity__c,Total_Price__c,Product__r.Name,Total_Amount__c from Order_Lines__r) from Sigma_Order__c where Id IN : OrderID])
        {
            Decimal TotalAmount = 0.00;
            for(Product_Order_Price_Book__c ProdPriceDisc : OrderUp.Order_Lines__r)
            {
               
                if(ProdDiscount.containsKey(ProdPriceDisc.Product__c) && ProdDiscount.get(ProdPriceDisc.Product__c) > 0.00 && ProdPriceDisc.Net_Quantity__c > 0)
                {
                    Product_Order_Price_Book__c ProdDisc = new Product_Order_Price_Book__c();
                    ProdDisc.Id = ProdPriceDisc.Id;
                    ProdDisc.Total_Price__c = ProdPriceDisc.Ordered_Amount__c - ((ProdPriceDisc.Ordered_Amount__c * ProdDiscount.get(ProdPriceDisc.Product__c))/100);
                    ProdDisc.Discounts__c = ProdDiscount.get(ProdPriceDisc.Product__c);
                   
                    TotalAmount += ProdPriceDisc.Ordered_Amount__c - ((ProdPriceDisc.Ordered_Amount__c * ProdDiscount.get(ProdPriceDisc.Product__c))/100);
                    
                    PriceBookdetaie.add(ProdDisc);
                }
                else
                {
                    Product_Order_Price_Book__c ProdDisc = new Product_Order_Price_Book__c();
                    ProdDisc.Id = ProdPriceDisc.Id;
                    ProdDisc.Total_Price__c = ProdPriceDisc.Ordered_Amount__c;
                   
                    TotalAmount += ProdPriceDisc.Ordered_Amount__c;
                    
                    PriceBookdetaie.add(ProdDisc);
                }
            }
                //Code for TAX
                List<Tax__c> taxObj = TaxCntr.getTax(OrderUp.AccountId__c);
                Double TaxOnBillAmount = 0.00;
                Double federalTax = 0.00;
                String fedTaxType;
                Double stateTax = 0.00;
                String stateTaxType;
                
                if(taxObj.size() > 0)
                {
                    federalTax = Double.valueOf(taxObj.get(0).Tax_Amount__c);
                    fedTaxType = String.valueOf(taxObj.get(0).Type__c);
                    if(taxObj.size() > 1)
                    {
                        stateTax = Double.valueOf(taxObj.get(1).Tax_Amount__c);
                        stateTaxType = String.valueOf(taxObj.get(1).Type__c);
                    }
                }
                string symbol='';
                Double  amt=0;
                Sigma_Order__c Ord= new Sigma_Order__c(); 
                Ord.Id = OrderUp.Id;
                Ord.Net_Amount__c = TotalAmount;
                
                if(fedTaxType == 'Percentage')
                {
                    TaxOnBillAmount = (TotalAmount * federalTax)/100;
                }
                else if(fedTaxType != null)
                {
                    TaxOnBillAmount = TotalAmount + federalTax;
                }               
                if(stateTaxType == 'Percentage')
                {
                    TaxOnBillAmount = (TaxOnBillAmount + (TotalAmount * stateTax)/100);
                }
                else if(stateTaxType != null)
                {
                    TaxOnBillAmount = (TaxOnBillAmount + (TotalAmount + stateTax));
                } 
                System.debug('TotalAmount '+TotalAmount + 'TaxOnBillAmount '+TaxOnBillAmount);          
                Ord.Tax_Amount__c = TaxOnBillAmount;
                Ord.Tax__c = federalTax + stateTax;
                Ord.TotalAmount__c = TotalAmount + TaxOnBillAmount;
                
                if(currSymbol.size() > 0){
                    if(currExRate.size() > 0){
                        symbol =currSymbol[0].Symbol__c;
                        string rateEx = currExRate[0].Rate__c +'';
                        amt= Double.valueOf(rateEx) * (TotalAmount + TaxOnBillAmount);
                        string currStr=symbol+' '+amt;
                        Ord.Exchange_Net_Amount__c = currStr;
                    }
                }
            //code to count number of orders in account 
            //added by harish 14-1-2021
            	if(Ord !=null)
                {
                	OrderCountCntrl.SigmaOrderCount(Ord);    
                }
            	
                OrderList.add(Ord);
        }
        if(PriceBookdetaie.size() > 0)
        update PriceBookdetaie;
        if(OrderList.size() > 0)
        update OrderList;
    }       
    }
    public class userWrapper
    {
        @AuraEnabled
        public String UserIds;
        @AuraEnabled
        public User Userobj;
        @AuraEnabled
        public Contact ContactsId;
        @AuraEnabled
        public Account AccountsID;
    }
    
}