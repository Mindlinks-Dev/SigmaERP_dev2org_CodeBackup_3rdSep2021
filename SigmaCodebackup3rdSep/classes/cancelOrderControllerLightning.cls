/*------------------------------------------------------------
    Author: 
    Company: Mindlinks Solution
    Description: A code coverage for the UpdateOrderCancellation
    Inputs:  "cancel Order" - Update Order Cancellation
             "cancel Order" - Update Order Cancellation  values. 
          
            
    Test Class: cancelOrderControllerLightningTest
    History
    <Date>         <Authors Name>   <Brief Description of Change>
   
    12-12-2016     javed            Added FLS Payment object.
    12-12-2016     javed            Added FLS Order for update object.
------------------------------------------------------------*/

public with sharing class cancelOrderControllerLightning
{
    public static Sigma_Order__c OrderObjectDetail {get;set;}
    public static Order standOrderObjectDetail {get;set;}
    public static List<Product_Order_Price_Book__c> POPBList{get;set;}
    public static List<OrderItem> OrdList{get;set;}
    public static Id TempOrderId{get;set;}
    public static String paymentTransactionID{get;set;}
    public static String paypalUrl = 'https://api-3t.sandbox.paypal.com/2.0/';
    public static string rawResponse {get; set; }
    public static string err {get; set; }
   
     @AuraEnabled
     public static Sigma_Order__c getOrderDetails(Id OrderId)
     {
        
        /* if(CRUD_FLS_CheckUtility.checkObjCRUD(' sigmaerpdev2__Sigma_Order__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD(' sigmaerpdev2__Product_Order_Price_Book__c') 
            && CRUD_FLS_CheckUtility.checkReadPermission(' sigmaerpdev2__Sigma_Order__c',new set<String>{'id','Name',' sigmaerpdev2__Order_Number__c',' sigmaerpdev2__Total_Amount__c', ' sigmaerpdev2__TotalAmount__c',' sigmaerpdev2__Orders_Status__c',' sigmaerpdev2__Is_Payment_Made__c',' sigmaerpdev2__Order_Created_Via__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission(' sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'Id',' sigmaerpdev2__Total_Amount__c',' sigmaerpdev2__Net_Quantity__c',' sigmaerpdev2__Quantity__c',' sigmaerpdev2__tax_amount__c',' sigmaerpdev2__Sigma_Order__c'})
         )
         {*/
           
        
         TempOrderId = OrderId;
         Double subTotalAmount = 0.00;
         
            OrderObjectDetail = [select id,Name,Order_Number__c,Total_Amount__c, TotalAmount__c,Orders_Status__c,Is_Payment_Made__c,Order_Created_Via__c from Sigma_Order__c where Id=:OrderId limit 1];
         
        
         list<Product_Order_Price_Book__c> orderProductData1;
         
            orderProductData1 = [SELECT Id,Total_Amount__c,Net_Quantity__c,Quantity__c,tax_amount__c FROM Product_Order_Price_Book__c WHERE Sigma_Order__c = :OrderId];
         
         for(Product_Order_Price_Book__c tempProductOrder : orderProductData1)
         {   
            if(tempProductOrder.Net_Quantity__c != 0 && tempProductOrder.Net_Quantity__c != null)
             {
                 subTotalAmount = (subTotalAmount + (tempProductOrder.Total_Amount__c*tempProductOrder.Net_Quantity__c) + tempProductOrder.tax_amount__c).setScale(2);
             }
         }
         if(subTotalAmount == 0.00)
             {
                 subTotalAmount=OrderObjectDetail.Total_Amount__c;
             }
         
         OrderObjectDetail.TotalAmount__c = subTotalAmount;
             
        // }
         system.debug('OrderObjectDetail@@@'+OrderObjectDetail);
         return OrderObjectDetail;
     }
     
     //code to handle cancelOrder for credit customer 03-03-2020
     @AuraEnabled
     public static Sigma_Order__c getsigmaOrderDetails(Id OrderId)
     {
        
         /*if(CRUD_FLS_CheckUtility.checkObjCRUD(' sigmaerpdev2__Sigma_Order__c')
           
            && CRUD_FLS_CheckUtility.checkReadPermission(' sigmaerpdev2__Sigma_Order__c',new set<String>{'id','Name',' sigmaerpdev2__Order_Number__c',' sigmaerpdev2__Total_Amount__c', ' sigmaerpdev2__TotalAmount__c',' sigmaerpdev2__Orders_Status__c',' sigmaerpdev2__Is_Payment_Made__c',' sigmaerpdev2__Order_Created_Via__c'})
             )
         {*/
            OrderObjectDetail = [select id,Name,Order_Number__c,Total_Amount__c, TotalAmount__c,Orders_Status__c,Is_Payment_Made__c,Order_Created_Via__c from Sigma_Order__c where Id=:OrderId limit 1];
         //}
         system.debug('OrderObjectDetail@@@'+OrderObjectDetail);
         return OrderObjectDetail;
     }
     //code end
     
     @AuraEnabled
     public static Payment__c getPaymentMode(Id OrderId)
     {
          Payment__c paymentMode;
           /* if(CRUD_FLS_CheckUtility.checkObjCRUD(' sigmaerpdev2__Payment__c')
           && CRUD_FLS_CheckUtility.checkReadPermission(' sigmaerpdev2__Payment__c',new set<String>{'Id','Name',' sigmaerpdev2__Payment_Mode__c',' sigmaerpdev2__Sigma_Order__c',' sigmaerpdev2__Status__c'}))
         {*/
          
            paymentMode = [select Id,Name,Payment_Mode__c,Sigma_Order__c,Status__c from Payment__c where Sigma_Order__c=:OrderId AND Status__c =:'Completed'];
        
         //}
         return paymentMode;
     }
     
     @AuraEnabled
     public static List<string>getProductList(Id OrderId)
     {
         List<String> options = new List<String>();
        /* if(CRUD_FLS_CheckUtility.checkObjCRUD(' sigmaerpdev2__Product_Order_Price_Book__c')
         && CRUD_FLS_CheckUtility.checkReadPermission(' sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{' sigmaerpdev2__Product__r.Name',' sigmaerpdev2__Product__r.Id',' sigmaerpdev2__Order_Status__c',' sigmaerpdev2__Sigma_Order__c'}))
         {*/
             
            POPBList = [select Product__r.Name,Product__r.Id,Order_Status__c,Sigma_Order__c from Product_Order_Price_Book__c where Sigma_Order__c=:OrderId and (Order_Status__c ='Order Confirmed' or Order_Status__c ='Packaged')];
         
        
         for(Product_Order_Price_Book__c temp: POPBList)
         {
             options.add(temp.Product__r.Name);
         }
        // }
         return options;
         
     }
    
     @AuraEnabled
     public static List<Product_Order_Price_Book__c> getOrderProductDetails(Id OrderId)
     {
          /*if(CRUD_FLS_CheckUtility.checkObjCRUD(' sigmaerpdev2__Product_Order_Price_Book__c')
          && CRUD_FLS_CheckUtility.checkReadPermission(' sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'id','Name',' sigmaerpdev2__Quantity__c',' sigmaerpdev2__Subtotal__c',' sigmaerpdev2__Product__r.Name',' sigmaerpdev2__Product__c',' sigmaerpdev2__Order_Status__c',' sigmaerpdev2__Sigma_Order__r.id'})){*/
           
            POPBList = [select id,Name,Quantity__c,Subtotal__c,Product__r.Name,Product__c,Order_Status__c from Product_Order_Price_Book__c where Sigma_Order__r.id=:OrderId];
         
            // }
         return POPBList;
     }
     @AuraEnabled
     public static Boolean partialCashRefund(Id OrderId, Id productId, Integer selectedQuantity, double subTotalAmount)
     {
        
     
        CancelOrderManagement cancelOrder = new CancelOrderManagement();
        cancelOrder.manageProductsOnCancelOrder(OrderId, productId ,selectedQuantity,subTotalAmount,'','CASH');
        boolean updateLotFlag = cancelOrder.updateLotProductonCancelOrder(OrderId, productId);
       
        return true;
     }
     
     @AuraEnabled
     public static Boolean partialChequeRefund(Id OrderId, Id productId, Integer selectedQuantity, double subTotalAmount)
     {
     
        CancelOrderManagement cancelOrder = new CancelOrderManagement();
        cancelOrder.manageProductsOnCancelOrder(OrderId, productId ,selectedQuantity,subTotalAmount,'','CHEQUE');
        return true;
     }
    
     @AuraEnabled
     public static Boolean partialVoucherRefund(Id OrderId, Id productId, Integer selectedQuantity, double subTotalAmount)
     {
     
        CancelOrderManagement cancelOrder = new CancelOrderManagement();
        cancelOrder.manageProductsOnCancelOrder(OrderId, productId ,selectedQuantity,subTotalAmount,'','VOUCHER');
        return true;
     }
    
    //code to handle cancel order for credit customer
    @AuraEnabled
    public static Boolean CancelSigmaOrder(Id OrderId,Decimal subTotalAmount)
    {
        CancelOrderManagement cancelOrder = new CancelOrderManagement();
        String refundedTransId;
        cancelOrder.manageinventoryOnCancelorder(OrderId, subTotalAmount);
        //boolean lotUpdateOnCompleteOrdercancel = cancelOrder.updateLotProductonCompleteCancelOrder(OrderId,'CASH');
        return true;
    } 
 
    @AuraEnabled
    public static Boolean completeCashRefund(Id OrderId,Decimal subTotalAmount)
    {
        CancelOrderManagement cancelOrder = new CancelOrderManagement();
        String refundedTransId;
        cancelOrder.manageOrderOnCancel(OrderId, subTotalAmount,refundedTransId ,'CASH');
        boolean lotUpdateOnCompleteOrdercancel = cancelOrder.updateLotProductonCompleteCancelOrder(OrderId,'CASH');
        return true;
    }
    @AuraEnabled
    public static Boolean completeChequeRefund(Id OrderId,Decimal subTotalAmount)
    {
        CancelOrderManagement cancelOrder = new CancelOrderManagement();
        String refundedTransId;
        cancelOrder.manageOrderOnCancel(OrderId, subTotalAmount, refundedTransId,'CHEQUE');
        return true;
    }
    @AuraEnabled
    public static Boolean completeVoucherRefund(Id OrderId,double subTotalAmount)
    {
        CancelOrderManagement cancelOrder = new CancelOrderManagement();
        cancelOrder.manageOrderOnCancel(OrderId, subTotalAmount, '','VOUCHER');
        return true;
    }
    
   
    @AuraEnabled
    public static String completeCardRefund(Id OrderId,Decimal subTotalAmount)
    {
        
        Payment__c paymentRecordForTransactionId;
        String cId;
        Double pAmount = 0.0;
        List<Payment__c> payList = new List<Payment__c>();
        List<Payment__c> paymentList = new List<Payment__c>();
        List<Sigma_Order__c> soList = new List<Sigma_Order__c>();
        CancelOrderManagement sc;
        Decimal rAmount;
        Sigma_Order__c so;
        order ord;
    
        String refundedTransId;
    try{
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD(' sigmaerpdev2__Order_Usage__c')
          && CRUD_FLS_CheckUtility.checkObjCRUD('order')
          && CRUD_FLS_CheckUtility.checkObjCRUD(' sigmaerpdev2__Sigma_Order__c')
          && CRUD_FLS_CheckUtility.checkObjCRUD(' sigmaerpdev2__Payment__c')
          && CRUD_FLS_CheckUtility.checkReadPermission(' sigmaerpdev2__Order_Usage__c',new set<String>{'Id', 'Name',' sigmaerpdev2__Sigma_order__c',' sigmaerpdev2__Standard_object__c'})
          && CRUD_FLS_CheckUtility.checkReadPermission('order',new set<String>{'id','name',' sigmaerpdev2__TotalAmount__c',' sigmaerpdev2__Last_Refund_Date_Time__c',' sigmaerpdev2__Orders_Status__c'})
          && CRUD_FLS_CheckUtility.checkReadPermission(' sigmaerpdev2__Sigma_Order__c',new set<String>{'id','name',' sigmaerpdev2__TotalAmount__c',' sigmaerpdev2__Last_Refund_Date_Time__c',' sigmaerpdev2__Orders_Status__c'})
          && CRUD_FLS_CheckUtility.checkReadPermission(' sigmaerpdev2__Payment__c',new set<String>{'id',' sigmaerpdev2__Last_Refund_Date_Time__c',' sigmaerpdev2__Refund_Transaction_Id__c',' sigmaerpdev2__Refund_Charge_Id__c',' sigmaerpdev2__Status__c',' sigmaerpdev2__Charge_Id__c',' sigmaerpdev2__Amount__c',' sigmaerpdev2__Sigma_Order__c',' sigmaerpdev2__OrderId__c'})    
          && CRUD_FLS_CheckUtility.checkFLS(' sigmaerpdev2__Payment__c',new set<String>{' sigmaerpdev2__Refund_Transaction_Id__c',' sigmaerpdev2__Last_Refund_Date_Time__c'})
          && CRUD_FLS_CheckUtility.checkFLS(' sigmaerpdev2__Sigma_Order__c',new set<String>{' sigmaerpdev2__Last_Refund_Date_Time__c'})
          && CRUD_FLS_CheckUtility.checkFLS('order',new set<String>{' sigmaerpdev2__Last_Refund_Date_Time__c'})
        )
        {*/
            
            
            Order_Usage__c OrderTypeusage = new Order_Usage__c();
            OrderTypeusage= [select Id, Name,Sigma_order__c,Standard_object__c from Order_Usage__c limit 1];
            if(OrderTypeusage.Standard_object__c == true)
            {
            
                ord = [select id,name,TotalAmount__c,Last_Refund_Date_Time__c,Orders_Status__c from order where id =: orderId AND Orders_Status__c  =: 'Order Confirmed'];
                
                payList = [select id,Last_Refund_Date_Time__c,Refund_Transaction_Id__c,Status__c,Refund_Charge_Id__c ,Charge_Id__c,Amount__c,OrderId__c from Payment__c where OrderId__c=: orderId  AND Status__c =:'Completed'];
            
            }
            else {
                
            so = [select id,name,TotalAmount__c,Last_Refund_Date_Time__c,Orders_Status__c from Sigma_Order__c where id =: orderId AND Orders_Status__c  =: 'Order Confirmed'];
            payList = [select id,Last_Refund_Date_Time__c,Refund_Transaction_Id__c,Status__c,Refund_Charge_Id__c ,Charge_Id__c,Amount__c,Sigma_Order__c from Payment__c where Sigma_Order__c =: orderId  AND Status__c =:'Completed'];
          }
           
            if(!payList.isEmpty())
            {
                for(Payment__c p:payList)
                    {   
                    cId = p.Charge_Id__c;
                    rAmount = subTotalAmount;
                    String rfdAmount = String.valueof(rAmount.round(System.RoundingMode.CEILING));
                    sc = CancelOrderManagement.createRefund(cId,rfdAmount);
                    system.debug('sc.status'+sc.status);
                    if(sc.balance_transaction != null && String.isNotEmpty(sc.balance_transaction) && sc.status == 'succeeded'){
                        system.debug('inside');
                        p.Refund_Transaction_Id__c = sc.balance_transaction;
                       
                        p.Last_Refund_Date_Time__c = system.now();
                       
                        paymentList.add(p);
                        if(OrderTypeusage.Standard_object__c == true)
                        {
                            ord.Last_Refund_Date_Time__c = system.now();
                            update ord; 
                        }
                        else{
                            so.Last_Refund_Date_Time__c = system.now();
                            update so; 
                        }
                     }
                }
            }
            
            update paymentList;
            if(OrderTypeusage.Standard_object__c == true)
            {
                update ord; 
            }
            else{
                update so;
            }
            
            Boolean result;
            if(sc.status == 'succeeded')
            {
                system.debug('Result@@');
              result = true;  
            }
            else
            {
                result = true;   
            }
            
            if(result)
             {
                CancelOrderManagement cancelOrder = new CancelOrderManagement();
                cancelOrder.manageOrderOnCancel(orderId ,subTotalAmount,refundedTransId,'CARD');
                boolean lotUpdateOnCompleteOrdercancel = cancelOrder.updateLotProductonCompleteCancelOrder(OrderId,'CARD');
                return 'hi';
                 
             }
      // }
             
              return sc.balance_transaction;
        }
        catch(Exception e){
            return 'hi';
        }
    
    }
     @AuraEnabled
     public static Sigma_Order__c getOrder(Id OrderId)
     {
        Sigma_Order__c Orderstatus = new Sigma_Order__c();
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD(' sigmaerpdev2__Sigma_Order__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD(' sigmaerpdev2__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkReadPermission(' sigmaerpdev2__Sigma_Order__c',new Set<String>{'Id','name',' sigmaerpdev2__Due_Amount__c',' sigmaerpdev2__Paid_Amount__c',' sigmaerpdev2__Orders_Status__c',' sigmaerpdev2__TotalAmount__c',' sigmaerpdev2__Total_Amount__c',' sigmaerpdev2__Order_Created_Via__c',' sigmaerpdev2__No_Picking_Package_Shipment_Required__c',' sigmaerpdev2__Customer_Type__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission(' sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'id', 'name',' sigmaerpdev2__Delivered_Quantity__c',' sigmaerpdev2__Shipped_Quantity__c'})
         ){*/
            Orderstatus = [select id,name,Due_Amount__c,Paid_Amount__c,Orders_Status__c,TotalAmount__c,sigmaerpdev2__Total_Amount_With_Tax__c,Total_Amount__c,Order_Created_Via__c,Customer_Type__c,No_Picking_Package_Shipment_Required__c,(select id, name,Delivered_Quantity__c,Shipped_Quantity__c,Is_Credit_Updated__c,Total_Price__c,sigmaerpdev2__Tax_Amount1__c,Inventory_Status__c,Order_Status__c from Order_Lines__r) from Sigma_Order__c where Id=:OrderId limit 1];
        system.debug('Orderstatus@@@'+Orderstatus);
        //}
        return Orderstatus;
     }
     @AuraEnabled
     public static Order getstandOrder(Id OrderId)
     {
        Order Orderstatus = new Order();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('Order')
        && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
        && CRUD_FLS_CheckUtility.checkReadPermission('Order',new Set<String>{'Id','name','OrderNumber',' sigmaerpdev2__Due_Amount__c',' sigmaerpdev2__Net_Amount__c',' sigmaerpdev2__Orders_Status__c',' sigmaerpdev2__TotalAmount__c',' sigmaerpdev2__Order_Created_Via__c',' sigmaerpdev2__Paid_Amount__c',' sigmaerpdev2__Customer_Type__c',' sigmaerpdev2__No_Picking_Package_Shipment_Required__c'})
        &&  CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'id',' sigmaerpdev2__Delivired__c',' sigmaerpdev2__Shipped_Quantity__c',' sigmaerpdev2__Order_Status__c'})
        )
        {*/
         
         Orderstatus = [select id,name,Due_Amount__c,Paid_Amount__c,OrderNumber,Orders_Status__c,TotalAmount__c,Order_Created_Via__c,Net_Amount__c,Customer_Type__c,No_Picking_Package_Shipment_Required__c,(select id,Delivired__c,Shipped_Quantity__c,Inventory_Status__c,Is_Credit_Updated__c,TotalPrice__c,Order_Status__c from OrderItems) from Order where Id=:OrderId limit 1];
       
        //}
        return Orderstatus;
     }
    
     @AuraEnabled
    public static Order_Usage__c CheckOrder()
    {
        Order_Usage__c OrderTypeusage= new Order_Usage__c();
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD(' sigmaerpdev2__Order_Usage__c')
        && CRUD_FLS_CheckUtility.checkReadPermission(' sigmaerpdev2__Order_Usage__c',new Set<String>{'Id', 'Name',' sigmaerpdev2__Standard_object__c',' sigmaerpdev2__Sigma_order__c'}))
        {*/
        try{
                OrderTypeusage= [select Id, Name,Sigma_order__c,Standard_object__c from Order_Usage__c limit 1];
              
           }
            catch(Exception e)
            {
                return null;
            }
       // }
        return OrderTypeusage;
        
    }
    @AuraEnabled
     public static List<string>getstandProductList(Id OrderId)
     {
        List<String> options = new List<String>();
         /*if(CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
         && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'id',' sigmaerpdev2__Order_Status__c','OrderId','Pricebookentry.Product2Id'}))
         {*/
           OrdList = [select id,Pricebookentry.Product2Id,OrderId,Order_Status__c from OrderItem where OrderId=:OrderId];
            for(OrderItem temp: OrdList)
            {
                options.add(temp.Pricebookentry.Product2Id);
            }
        // }
         return options;
         
     }
     @AuraEnabled
     public static List<OrderItem> getstandOrderProductDetails(Id OrderId)
     {
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
        && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'id','Quantity','Pricebookentry.Product2Id',' sigmaerpdev2__Order_Status__c','Order.id'}))
        {*/
           OrdList = [select id,Quantity,Pricebookentry.Product2Id,Order_Status__c from OrderItem where Order.id=:OrderId];
        //}
         return OrdList;
     }
     @AuraEnabled
     public static Payment__c getstandPaymentMode(Id OrderId)
     {
          Payment__c paymentMode;
        /* if(CRUD_FLS_CheckUtility.checkObjCRUD(' sigmaerpdev2__Payment__c')
         && CRUD_FLS_CheckUtility.checkReadPermission(' sigmaerpdev2__Payment__c',new set<String>{'Id','Name',' sigmaerpdev2__Payment_Mode__c',' sigmaerpdev2__OrderId__c'}))
         {*/
            paymentMode = [select Id,Name,Payment_Mode__c from Payment__c where OrderId__c=:OrderId  AND Status__c =:'Completed' limit 1];
         //}
         return paymentMode;
     }
    @AuraEnabled
     public static Order getstandOrderDetails(Id OrderId)
     {
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('Order')
        && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
        && CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'id','Name','OrderNumber',' sigmaerpdev2__TotalAmount__c', ' sigmaerpdev2__Orders_Status__c',' sigmaerpdev2__Is_Payment_Made__c',' sigmaerpdev2__Order_Created_Via__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'Id',' sigmaerpdev2__Unit_Price__c',' sigmaerpdev2__Net_Quantity__c','Quantity',' sigmaerpdev2__tax_amount__c','OrderId'})    
        )
        {*/
         TempOrderId = OrderId;
         Double subTotalAmount = 0.00;
         
         standOrderObjectDetail = [select id,Name, OrderNumber,TotalAmount__c,Orders_Status__c,Is_Payment_Made__c,Order_Created_Via__c from Order where Id=:OrderId limit 1];
         list<OrderItem> orderProductData1;
         
         orderProductData1 = [SELECT Id,Unit_Price__c,Net_Quantity__c,Quantity,tax_amount__c FROM OrderItem WHERE OrderId = :OrderId];
         system.debug('orderProductData1::'+orderProductData1);
         
          for(OrderItem tempProductOrder : orderProductData1)
         {   
             system.debug('tempProductOrder>>>'+tempProductOrder);
            if(tempProductOrder.Net_Quantity__c != 0 && tempProductOrder.Net_Quantity__c != null)
             {
                 if(tempProductOrder.tax_amount__c!=0 && tempProductOrder.tax_amount__c!=null )
                subTotalAmount  = (subTotalAmount + (tempProductOrder.Unit_Price__c*tempProductOrder.Net_Quantity__c) + tempProductOrder.tax_amount__c).setScale(2);
             }
         }
         if(subTotalAmount == 0.00)
         {
            subTotalAmount=standOrderObjectDetail.TotalAmount__c;
         }
            
         standOrderObjectDetail.TotalAmount__c = subTotalAmount;
         
      //  }
         
         return standOrderObjectDetail;
         
     }
    //code to fetch standardorder details
     @AuraEnabled
     public static Order getstandOrderDetailsforcancel(Id OrderId)
     {
       /*if(CRUD_FLS_CheckUtility.checkObjCRUD('Order')
        && CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'id','Name','OrderNumber',' sigmaerpdev2__TotalAmount__c', ' sigmaerpdev2__Orders_Status__c',' sigmaerpdev2__Is_Payment_Made__c',' sigmaerpdev2__Order_Created_Via__c'})
        )
        {*/
         standOrderObjectDetail = [select id,Name, OrderNumber,TotalAmount__c,Orders_Status__c,Is_Payment_Made__c,Order_Created_Via__c from Order where Id=:OrderId limit 1];
        //}
         
         return standOrderObjectDetail;
         
     }
    // code added by sandhya for checking Order Usage
    @AuraEnabled
     public Static Order_Usage__c  OrderUsageRefund(){
         
         Order_Usage__c cu = new Order_Usage__c();
         /*if(CRUD_FLS_CheckUtility.checkObjCRUD(' sigmaerpdev2__Order_Usage__c')
         && CRUD_FLS_CheckUtility.checkReadPermission(' sigmaerpdev2__Order_Usage__c',new set<String>{' sigmaerpdev2__Sigma_order__c',' sigmaerpdev2__Standard_object__c'})
             ){*/
         cu = [Select Sigma_order__c,Standard_object__c from Order_Usage__c limit 1];
        // }
         return cu;
     }
    //ends here
     @AuraEnabled
    public static Default_Parameters__c getInventorystatus()
    {
        Default_Parameters__c Inventorystatus;
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD(' sigmaerpdev2__Default_Parameters__c')
        && CRUD_FLS_CheckUtility.checkReadPermission(' sigmaerpdev2__Default_Parameters__c',new Set<String>{'id',' sigmaerpdev2__Inventory_Status__c'}))
        {*/
             Inventorystatus= new Default_Parameters__c();
            Inventorystatus= [select id,Inventory_Status__c from Default_Parameters__c  limit 1];
       // }
        return Inventorystatus;
        
    } 
}