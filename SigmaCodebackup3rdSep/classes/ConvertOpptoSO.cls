global with sharing class ConvertOpptoSO 
{
    @AuraEnabled
    public static Opportunity getOpportunity(Id Proposalid)
    {
     Opportunity campObject ; 
     /*if(CRUD_FLS_CheckUtility.checkObjCRUD('Opportunity') && 
        CRUD_FLS_CheckUtility.checkObjCRUD('OpportunityLineItem') &&
        CRUD_FLS_CheckUtility.checkReadPermission('Opportunity',new set<String>{'id','Name','AccountId','Amount','Account.Name','StageName','Is_Order_Created__c'})  &&
        CRUD_FLS_CheckUtility.checkReadPermission('OpportunityLineItem',new set<String>{'id','Name'})
          ){ */
       
         campObject=[Select Id,Name,AccountId,Amount,Account.Name,StageName,Is_Order_Created__c,(select id,name from OpportunityLineItems) from Opportunity where Id =: Proposalid];
       // }
        return campObject;        
    }  
    
    @AuraEnabled
    webservice static Id saveOrder(Id Orderid)
    {
    Sigma_Order__c orderObj ;
    
    /*if(CRUD_FLS_CheckUtility.checkObjCRUD('Sigma_Order__c') && 
       CRUD_FLS_CheckUtility.checkObjCRUD('Opportunity') &&
       CRUD_FLS_CheckUtility.checkObjCRUD('Account') &&
       CRUD_FLS_CheckUtility.checkObjCRUD('Dimension_Tag__c') &&
       CRUD_FLS_CheckUtility.checkObjCRUD('Product_Order_Price_Book__c') &&
       CRUD_FLS_CheckUtility.checkObjCRUD('Inventory__c')&&
       CRUD_FLS_CheckUtility.checkObjCRUD('OpportunityLineItem')&&
       CRUD_FLS_CheckUtility.checkObjCRUD('Tax__c') &&
       
       CRUD_FLS_CheckUtility.checkReadPermission('Sigma_Order__c',new set<String>{'id','Name','AccountId','Amount','Account.Name','Is_Order_Created__c'})  &&
       CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'id','Name','Customer_Type__c','Exchange_Currency__c','ShippingStreet','ShippingCity','ShippingState','ShippingPostalcode','ShippingCountry'}) &&
       CRUD_FLS_CheckUtility.checkFLScreateAccess('Sigma_Order__c',new Set<String>{'AccountId__c'}) &&
       CRUD_FLS_CheckUtility.checkReadPermission('OpportunityLineItem',new set<String>{'Id','Product2Id','OpportunityId','Quantity','UnitPrice','TotalPrice','ListPrice'}) &&
       CRUD_FLS_CheckUtility.checkReadPermission('Dimension_Tag__c' ,new set<String>{'id','Ordered_Amount__c','Account__c','AccountId__c'}) &&
       CRUD_FLS_CheckUtility.checkReadPermission('Inventory__c',new set<String>{'id','ProductCode__c','Available_Qty__c'}) &&
       CRUD_FLS_CheckUtility.checkReadPermission('Opportunity',new set<String>{'Id','Name','AccountId','Amount','Account.Name','Is_Order_Created__c'}) &&
    
       CRUD_FLS_CheckUtility.checkFLS('Sigma_Order__c',new set<String>{'Opportunity__c','Net_Amount__c','Order_Created_Via__c','Customer_Type__c','Orders_Status__c','Shipping_Street__c','ShippingCity__c','ShippingState__c','ShippingCountry__c','ShippingPostalCode__c','Currency__c','Delivary_Date__c','Tax_Amount__c','Tax__c','TotalAmount__c'}) &&
       CRUD_FLS_CheckUtility.checkFLS('Dimension_Tag__c',new set<String>{'Ordered_Amount__c'})&&
       CRUD_FLS_CheckUtility.checkFLS('Opportunity',new set<String>{'Is_Order_Created__c'})&&
         
       CRUD_FLS_CheckUtility.checkFLScreateAccess('Product_Order_Price_Book__c',new Set<String>{'Sigma_Order__c'})
    ){ */
    
        Double TaxOnBillAmount = 0;
        
        Account Acc;
        orderObj = new Sigma_Order__c() ;
        Opportunity opp=[Select Id,Name,AccountId,Amount,Account.Name,Is_Order_Created__c from Opportunity where Id =: Orderid];
        Acc=[Select id,name,Customer_Type__c,Exchange_Currency__c,ShippingStreet,ShippingCity,ShippingState,ShippingPostalcode,ShippingCountry from Account where id =:opp.AccountId];
        Id oppid=opp.Id;
        orderObj.Opportunity__c=opp.id;
        orderObj.AccountId__c = opp.AccountId;
        orderObj.Net_Amount__c = opp.Amount;
        orderObj.Order_Created_Via__c='Opportunity';
        orderObj.Customer_Type__c = Acc.Customer_Type__c;
        orderObj.Orders_Status__c = 'Pending';
        if(ACC.ShippingStreet != null)
        orderObj.Shipping_Street__c = ACC.ShippingStreet;
        if(ACC.ShippingCity != null)
        orderObj.ShippingCity__c = ACC.ShippingCity;
        if(ACC.ShippingState != null)
        orderObj.ShippingState__c = ACC.ShippingState ;
        if(ACC.ShippingCountry != null)
        orderObj.ShippingCountry__c = ACC.ShippingCountry;
        if(ACC.ShippingPostalcode != null)
        orderObj.ShippingPostalCode__c = ACC.ShippingPostalcode;
        if(ACC.Exchange_Currency__c != null)
        orderObj.Currency__c = ACC.Exchange_Currency__c;
        orderObj.Delivary_Date__c = System.today();
        List<Tax__c> taxObj = TaxCntr.getTax(opp.AccountId);
        Double federalTax = Double.valueOf(taxObj.get(0).Tax_Amount__c);
        String fedTaxType = String.valueOf(taxObj.get(0).Type__c);
        Double stateTax = Double.valueOf(taxObj.get(1).Tax_Amount__c);
        String stateTaxType = String.valueOf(taxObj.get(1).Type__c);
        if(fedTaxType == 'Percentage'){
        TaxOnBillAmount = (orderObj.Net_Amount__c * federalTax)/100;
        }else{
        TaxOnBillAmount = orderObj.Net_Amount__c + federalTax;
        }               
        if(stateTaxType == 'Percentage'){
        TaxOnBillAmount = (TaxOnBillAmount + (orderObj.Net_Amount__c * stateTax)/100);
        }else{
        TaxOnBillAmount = (TaxOnBillAmount + (orderObj.Net_Amount__c + stateTax));
        }        
        orderObj.Tax_Amount__c = TaxOnBillAmount;   
        orderObj.Tax__c = federalTax+stateTax;
        orderObj.TotalAmount__c = orderObj.Net_Amount__c + TaxOnBillAmount;
        insert orderObj;
  
        if(orderObj.Customer_Type__c=='Credit Customer')
        {
            Dimension_Tag__c creditdetails;
            creditdetails = [select id,Ordered_Amount__c from Dimension_Tag__c where Account__c=:orderObj.AccountId__c limit 1];
            if(creditdetails!=null){
            if(orderObj.TotalAmount__c!=null){
            if(creditdetails.Ordered_Amount__c==null)
            creditdetails.Ordered_Amount__c=0;
            creditdetails.Ordered_Amount__c+=orderObj.TotalAmount__c;
            
        }

        }
        update creditdetails;
        
        }
        
        List<Product_Order_Price_Book__c> OrderLineItems =new List<Product_Order_Price_Book__c>();
        List<OpportunityLineItem> OppLineItems;
        List<Inventory__c> PI = new List<Inventory__c>();
        List<Id>prod = new List<Id>();
        Map<id,Decimal> orderlinepro=new  Map<id,Decimal>();
        decimal netQunt=0;
        decimal totalprice = 0;
        OppLineItems=[Select Id,Product2Id,OpportunityId,Quantity,UnitPrice,TotalPrice,ListPrice from OpportunityLineItem where OpportunityId =:opp.Id];

        for(OpportunityLineItem opplineitem :OppLineItems)  
        {
        prod.add(opplineitem.Product2Id);
        }       
        PI = [Select id,ProductCode__c,Available_Qty__c from Inventory__c where ProductCode__c =:prod];
        for(OpportunityLineItem Oppline:OppLineItems)
        {
            for(Inventory__c proinv : PI)
            {
                if(proinv.ProductCode__c == Oppline.Product2Id)
                {
                    if(Oppline.Quantity > proinv.Available_Qty__c)
                    {
                    decimal remainqunt=Oppline.Quantity - proinv.Available_Qty__c;
                    Product_Order_Price_Book__c orderline = new Product_Order_Price_Book__c(); 
                    orderline.Product__c=Oppline.Product2Id;
                    orderline.Quantity__c=Oppline.Quantity; 
                    orderline.Net_Quantity__c=proinv.Available_Qty__c;
                    orderline.Remaining_Qty_To_Package__c=orderline.Net_Quantity__c;
                    orderline.Sigma_Order__c=orderObj.Id;
                    orderline.Order_Status__c = 'Pending';
                    orderline.Total_Amount__c=Oppline.UnitPrice;
                    orderline.Total_Price__c = orderline.Net_Quantity__c*Oppline.ListPrice;

                    totalprice=orderline.Net_Quantity__c*Oppline.ListPrice;
                    netQunt+=orderline.Net_Quantity__c;
                    OrderLineItems.add(orderline);





                    Product_Order_Price_Book__c orderline1 = new Product_Order_Price_Book__c();
                    orderline1.Net_Quantity__c=remainqunt;
                    orderline1.Remaining_Qty_To_Package__c=orderline1.Net_Quantity__c;
                    orderline1.Product__c=Oppline.Product2Id;
                    orderline1.Total_Price__c=orderline1.Net_Quantity__c*Oppline.ListPrice;
                    orderline1.Sigma_Order__c=orderObj.Id;
                    orderline1.Order_Status__c = 'Pending';
                    orderline1.Total_Amount__c=Oppline.UnitPrice;
                    orderline1.Back_Order__c =true;
                    orderline1.Stock_Fulfilled__c = false;  
                    OrderLineItems.add(orderline1);

                    }
                    else
                    {
                    Product_Order_Price_Book__c orderline2 = new Product_Order_Price_Book__c();
                    orderline2.Product__c=Oppline.Product2Id;
                    orderline2.Quantity__c=Oppline.Quantity;
                    orderline2.Net_Quantity__c=Oppline.Quantity;
                    orderline2.Remaining_Qty_To_Package__c=orderline2.Net_Quantity__c;
                    orderline2.Total_Amount__c=Oppline.UnitPrice;
                    orderline2.Total_Price__c=Oppline.TotalPrice;
                    orderline2.Sigma_Order__c=orderObj.Id;
                    orderline2.Order_Status__c = 'Pending';
                    orderlinepro.put(orderline2.Product__c,orderline2.Quantity__c);
                    netQunt+=orderline2.Quantity__c;
                    OrderLineItems.add(orderline2);  
                    }      
                }
            }


        } 
        upsert OrderLineItems;
        opp.Is_Order_Created__c =true;
        update opp;
       // }
        return orderObj.Id;
}

}