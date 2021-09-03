global with sharing class GenerateStandardorderInvoice{

    public  List<Order> standorderData{get;set;}
    public  List<OrderItem> OrderproductData{get;set;}
    public String orderId;
    public Integer Total{get;set;}
    public Default_Parameters__c defaultparam{get;set;}
   
    public GenerateStandardorderInvoice(ApexPages.StandardController controller) 
    {   
       orderId = System.currentPageReference().getParameters().get('id');
        this.getStandardOrderData();
        this.getOrderAddress();
        this.getdefaultparameter();
       
    }
    
    public Default_Parameters__c getdefaultparameter()
    {
      if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')
      && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new set<String>{'sigmaerpdev__Company_Name__c','sigmaerpdev__Company_Email__c','sigmaerpdev__Company_Phone__c','sigmaerpdev__Logo__c'})
      ){  
        defaultparam = [SELECT Company_Name__c,Company_Email__c,Company_Phone__c,Logo__c from Default_Parameters__c Limit 1];
      }
        return defaultparam;
    }
    public pagereference getStandardOrderData()
    {
    if(CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
    && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new Set<String>{'Id','OrderId','Quantity','OrderItemNumber','Product2.Name','sigmaerpdev__Unit_Price__c','UnitPrice','sigmaerpdev__Tax_Amount__c','TotalPrice','sigmaerpdev__Discount__c'}))
        {
        OrderproductData = [SELECT Id,Quantity,OrderItemNumber,OrderId,Product2.Name,Unit_Price__c,TotalPrice__c,TotalPrice,Tax_Amount__c,Discount__c,UnitPrice,Order_Status__c,Order.Orders_Status__c,
        Order.OrderNumber,Order.Account.Email__c,Order.Account.BillingAddress,Order.Account.companystate__c,
        Order.Account.Name,Order.createddate,Order.Tax_Amount__c,Order.Payment__r.Tax_Amount__c,Order.TotalProductPrice__c,Order.Total_product_Price__c,Order.TotalAmount__c
        FROM OrderItem WHERE OrderId= :orderId ];                                          
        Total =0;
        
        }
        return null;
    }
    
    public List<Order> getOrderAddress()
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('Order')
        && CRUD_FLS_CheckUtility.checkReadPermission('Order',new Set<String>{'Id','Name','sigmaerpdev__Total_product_Price__c','Account.Name','Account.sigmaerpdev__Country__c','Account.sigmaerpdev__Zip__c','Account.sigmaerpdev__Email__c','Account.sigmaerpdev__City__c','Account.sigmaerpdev__State__c','Account.sigmaerpdev__Address__c','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Delivary_Date__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__Discount__c','sigmaerpdev__Net_Amount__c','sigmaerpdev__Net_Quantity__c','OrderNumber','sigmaerpdev__Orders_Status__c','sigmaerpdev__TotalAmount__c'}))
        {
            standorderData =[select id,OrderNumber,Orders_Status__c,TotalProductPrice__c,Total_product_Price__c,Tax__c,Discount_New__c,Discount__c,Order_Created_Via__c,Delivary_Date__c,Quantity__c,Net_Amount__c,Discount_Amount__c,TotalAmount__c,Discount_Code__c,Shipment_Amount__c,Tax_Amount__c,Account.Name,Account.Email__c,Account.BillingAddress,Account.BillingCountry,Account.BillingState,Account.BillingCity,Account.BillingStreet,Account.companystate__c,Shipping_Street__c,ShippingCity__c,ShippingCountry__c,ShippingState__c,ShippingPostalCode__c from Order where Id =: orderId];
        }
        return standorderData;
       
    }
   
}