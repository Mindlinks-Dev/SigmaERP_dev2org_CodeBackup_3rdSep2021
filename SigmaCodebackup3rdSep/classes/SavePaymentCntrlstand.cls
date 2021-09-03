public with sharing class SavePaymentCntrlstand {
    
    public static String PublishableKey { get; set; }
    public static String StripeScretKey {get;set;}
    public static String PaymentToken = '';
    public static String stripetoken{get;set;}
    public static String customerId {get;set;}
    public static String description{get;set;}
    public static String stripecustId{get;set;}
    public static Boolean Dispalycustomer{get;set;}
    public static String selectedoption{get;set;}
    public static String stripeTransID{get;set;}
    public static string message = '';


   @AuraEnabled
    public static Payment__c saveCashPayment(Payment__c payment)
    {
       /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Payment__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Payment__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Dimension_Tag__c')
            
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Payment__c',new set<String>{'sigmaerpdev__Paid_Amount__c','sigmaerpdev__Amount_Recevied__c','sigmaerpdev__Amount__c','sigmaerpdev__SFDC_Account__c','sigmaerpdev__OrderId__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'Status','sigmaerpdev__Orders_Status__c','sigmaerpdev__Paid_Amount__c','Quantity__c','Total_Payable_Amount__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'OrderId','Order.name','Order.Account.name','sigmaerpdev__Splited_Order_Line__c','sigmaerpdev__Order_Status__c','Product2Id','sigmaerpdev__Back_Order__c','sigmaerpdev__Stock_Fulfilled__c','Order.sigmaerpdev__Auto_Allocate__c','Product2.name','Order.sigmaerpdev__Customer_Type__c','sigmaerpdev__TotalPrice__c','TotalPrice','sigmaerpdev__Unit_Price__c','sigmaerpdev__Net_Quantity__c','Quantity','sigmaerpdev__IsInventoryUpdated__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Dimension_Tag__c',new set<String>{'Id','sigmaerpdev__Base_Credit_Limit__c','sigmaerpdev__Ordered_Amount__c','sigmaerpdev__Paid_Amount__c'})
            
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Payment__c',new set<String>{'sigmaerpdev__Payment_Time__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Status__c','sigmaerpdev__Customer_SFID__c','sigmaerpdev__Amount_Recevied__c'})
            && CRUD_FLS_CheckUtility.checkFLS('Order',new set<String>{'Status','sigmaerpdev__Is_Payment_Made__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Paid_Amount__c'})
            && CRUD_FLS_CheckUtility.checkFLS('OrderItem',new set<String>{'sigmaerpdev__Order_Status__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Order_Payment__c',new set<String>{'sigmaerpdev__Order__c','sigmaerpdev__Payment__c','sigmaerpdev__Amount__c','sigmaerpdev__Payment_Type__c','sigmaerpdev__Payment_Status__c','sigmaerpdev__Quantity__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Dimension_Tag__c',new set<String>{'sigmaerpdev__Paid_Amount__c'})
            )       
        {*/
            datetime pmntDateTime = datetime.now();             
            payment.Payment_Time__c = pmntDateTime; 
            if(payment.Paid_Amount__c == null)
            {
              payment.Paid_Amount__c = 0;
            }
            payment.Paid_Amount__c = payment.Paid_Amount__c+payment.Amount_Recevied__c;
            if(payment.Amount__c <= payment.Paid_Amount__c)
            {
                payment.Status__c = 'Completed';
            }
            else 
            {
                payment.Status__c = 'Partial Paid';
            }     
            Id custId = payment.SFDC_Account__c;
            payment.Customer_SFID__c = custId;
            insert payment;     
             
            Id orderId = payment.OrderId__c;  
            Id paymentId = payment.Id;
            Double chargeAmount = payment.Amount__c;               
            Order orderObj;
            Dimension_Tag__c DT;
            List<OrderItem> orderLines =  new List<OrderItem>();
            List<OrderItem> allocatedorderLines =  new List<OrderItem>();

            orderObj = [select AccountId,Customer_Type__c,Status,Orders_Status__c,Paid_Amount__c,Quantity__c,Total_Payable_Amount__c,Order_Created_Via__c from Order where Id =: orderId];       

             
            orderObj.Status = 'Draft';
            if(payment.Status__c == 'Completed')
            {
                orderObj.Is_Payment_Made__c = true;
            }
            else
            {
                orderObj.Is_Payment_Made__c = false;
            }
            orderObj.Orders_Status__c = 'Order Confirmed';        
            if(payment.Amount_Recevied__c == null)
            {
                payment.Amount_Recevied__c = 0;
            }
            orderObj.Paid_Amount__c = orderObj.Paid_Amount__c+payment.Amount_Recevied__c;
            update orderObj;    
            
            orderLines = [select id,Is_Credit_Updated__c,Splited_Order_Line__c,OrderId,Order.name,Order.Account.name,Order_Status__c,Product2Id,Back_Order__c,Stock_Fulfilled__c,Order.Auto_Allocate__c,Product2.name,Order.Customer_Type__c,TotalPrice__c,TotalPrice,Unit_Price__c,Net_Quantity__c,Quantity,IsInventoryUpdated__c,Order.No_Picking_Package_Shipment_Required__c,Inventory_Status__c,Discount__c from OrderItem where OrderId= :orderId];                
            Decimal Amounttoupdate =0;
            
            for(OrderItem temp :orderLines )
            {
                if(!temp.Splited_Order_Line__c && temp.Order_Status__c =='Pending')
                {
                    temp.Order_Status__c = 'Order Confirmed';
                    if(temp.Order.Customer_Type__c == 'Credit Customer')
                    {
                        Amounttoupdate += temp.TotalPrice__c;
                        temp.Is_Credit_Updated__c =true;
                    }
                }
                
                       
                if(temp.Stock_Fulfilled__c == true && temp.IsInventoryUpdated__c ==false && temp.Order_Status__c == 'Order Confirmed'&& (temp.Order.Auto_Allocate__c ||temp.Inventory_Status__c =='Allocated'))
                {
                  allocatedorderLines.add(temp);
                }
            }
                update orderLines;
                
                if(orderObj.Customer_Type__c == 'Credit Customer' )//|| orderObj.Order_Created_Via__c == 'Subscription'
                {   
                    DT = [select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: orderObj.AccountId limit 1 ];
                    
                    if(DT.Paid_Amount__c == null)
                        DT.Paid_Amount__c =0;
                    DT.Paid_Amount__c = DT.Paid_Amount__c + payment.Amount_Recevied__c;
                    if(Amounttoupdate >0)
                    DT.Ordered_Amount__c +=Amounttoupdate;
                    update DT;
                    system.debug('DT>>'+DT);
                }
                               
                Order_Payment__c orderPaymentObj = new Order_Payment__c();
                orderPaymentObj.Order__c = orderId;
                orderPaymentObj.Payment__c = paymentId;  
                orderPaymentObj.Amount__c = chargeAmount;
                orderPaymentObj.Payment_Type__c = 'Charge';
                orderPaymentObj.Payment_Status__c = 'Payment Success';  
                orderPaymentObj.Quantity__c = orderObj.Quantity__c;
                upsert orderPaymentObj;     
				
				//handle invoice status after payment 13-03-2020
            if(orderObj.Order_Created_Via__c == 'POS')
            {
                system.debug('orderObj.id>>>'+orderObj.id);
                List<Invoice__c> invoice=new List<Invoice__c>(); 
                invoice = [Select id,name,Invoice_Status__c from Invoice__c where Orderlookup__c =:orderObj.id];
                if(invoice.size()>0)
                {
                    if(orderObj.Orders_Status__c == 'Order Confirmed')
                    {
                        invoice[0].Invoice_Status__c='Paid';
                    }
                    if(invoice !=null)
                    {
                        update invoice;
                    }
                }
                else
                {
                    system.debug('inside else');
                    
                    Invoice__c invoice1 = new Invoice__c();
                    List<Invoice_Item__c>Invoiceitem = new List<Invoice_Item__c>();
                    invoice1.Orderlookup__c = orderObj.id; 
                    invoice1.Invoice_Type__c='Sales Invoice';
                    invoice1.Customer__c =orderObj.AccountId; 
                    
                    if(orderObj.Orders_Status__c=='Pending')
                    {
                        invoice1.Invoice_Status__c='Unpaid'; 
                    }
                    else if(orderObj.Orders_Status__c =='Canceled')
                    {
                        invoice1.Invoice_Status__c='Cancelled';
                    }
                    else
                    {
                        invoice1.Invoice_Status__c = 'paid';
                    }
                    system.debug('invoice1>>>>'+invoice1);
                    insert invoice1;
                    for(OrderItem orderline : orderLines)
                    {
                        Invoice_Item__c invoicedata = new Invoice_Item__c();
                        invoicedata.Invoice_Number__c=invoice1.id;
                        invoicedata.Order_Product__c=orderline.id;
                        invoicedata.Quantity__c = orderline.Quantity;
                        invoicedata.Total_Amount__c=orderline.TotalPrice__c;
                        invoicedata.Product__c=orderline.Product2Id;
                        //invoicedata.Net_Amount__c = orderline.Product__r.Product_Price__c;
                        if(orderline.Discount__c!=null && orderline.Discount__c>0)
                            invoicedata.Discount__c = orderline.Discount__c;
                        Invoiceitem.add(invoicedata);
                    }
                    if(Invoiceitem.size()>0)
                        insert Invoiceitem;
                }
            }
				
				

                if(allocatedorderLines.size()>0)
                {
                  autostockreservation.autostockreserveforOrder(allocatedorderLines);
                }
            
        //}           
        return payment; 
    }
    
    @AuraEnabled
    public static Payment__c saveChequePayment(Payment__c payment)
    {
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Payment__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Payment__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Dimension_Tag__c')
            
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Payment__c',new set<String>{'sigmaerpdev__Paid_Amount__c','sigmaerpdev__Amount_Recevied__c','sigmaerpdev__Amount__c','sigmaerpdev__SFDC_Account__c','sigmaerpdev__OrderId__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'Status','sigmaerpdev__Orders_Status__c','sigmaerpdev__Paid_Amount__c','Quantity__c','Total_Payable_Amount__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'OrderId','Order.name','Order.Account.name','','sigmaerpdev__Order_Status__c','Product2Id','sigmaerpdev__Back_Order__c','sigmaerpdev__Stock_Fulfilled__c','Order.sigmaerpdev__Auto_Allocate__c','Product2.name','Order.sigmaerpdev__Customer_Type__c','sigmaerpdev__TotalPrice__c','TotalPrice','sigmaerpdev__Unit_Price__c','sigmaerpdev__Net_Quantity__c','Quantity','sigmaerpdev__IsInventoryUpdated__c','sigmaerpdev__Splited_Order_Line__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Dimension_Tag__c',new set<String>{'Id','sigmaerpdev__Base_Credit_Limit__c','sigmaerpdev__Ordered_Amount__c','sigmaerpdev__Paid_Amount__c'})
            
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Payment__c',new set<String>{'sigmaerpdev__Payment_Time__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Status__c','sigmaerpdev__Customer_SFID__c'})
            && CRUD_FLS_CheckUtility.checkFLS('Order',new set<String>{'Status','sigmaerpdev__Is_Payment_Made__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Paid_Amount__c'})
            && CRUD_FLS_CheckUtility.checkFLS('OrderItem',new set<String>{'sigmaerpdev__Order_Status__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Order_Payment__c',new set<String>{'sigmaerpdev__Order__c','sigmaerpdev__Payment__c','sigmaerpdev__Amount__c','sigmaerpdev__Payment_Type__c','sigmaerpdev__Payment_Status__c','sigmaerpdev__Quantity__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Dimension_Tag__c',new set<String>{'sigmaerpdev__Paid_Amount__c'})
            
            )
        {*/
            datetime pmntDateTime = datetime.now();             
            payment.Payment_Time__c = pmntDateTime;
            if(payment.Paid_Amount__c == null)
            {
                payment.Paid_Amount__c = 0;
            }
            if(payment.Amount_Recevied__c == null)
            {
                payment.Amount_Recevied__c = 0;
            }
            payment.Paid_Amount__c = payment.Paid_Amount__c+payment.Amount_Recevied__c;

            if(payment.Amount__c <= payment.Paid_Amount__c)
            {
                payment.Status__c = 'Completed';
            }
            else
            {
                payment.Status__c = 'Partial Paid';
            }
            Id custId = payment.SFDC_Account__c;
            payment.Customer_SFID__c = custId;
            insert payment;

            Id orderId = payment.OrderId__c;         
            Id paymentId = payment.Id;
            Double chargeAmount = payment.Amount__c;        
            Order orderObj;
            Dimension_Tag__c DT;
            List<OrderItem> orderLines =  new List<OrderItem>();
            List<OrderItem> allocatedorderLines =  new List<OrderItem>();
            orderObj = [select AccountId,Customer_Type__c,Status,Orders_Status__c,Paid_Amount__c,Quantity__c,Total_Payable_Amount__c,Order_Created_Via__c from Order where Id =: orderId];       


            
            
            orderObj.Status = 'Draft';
            if(payment.Status__c == 'Completed')
            {
                orderObj.Is_Payment_Made__c = true;
            }
            else
            {
                orderObj.Is_Payment_Made__c = false;
            }
            orderObj.Orders_Status__c = 'Order Confirmed';    

            if(payment.Amount_Recevied__c == null)
            {
                payment.Amount_Recevied__c = 0;
            }
            orderObj.Paid_Amount__c = orderObj.Paid_Amount__c+payment.Amount_Recevied__c;
            update orderObj;  
            
            orderLines = [select id,Is_Credit_Updated__c,Splited_Order_Line__c,OrderId,Order.name,Order.Account.name,Order_Status__c,Product2Id,Back_Order__c,Stock_Fulfilled__c,Order.Auto_Allocate__c,Product2.name,Order.Customer_Type__c,TotalPrice__c,TotalPrice,Unit_Price__c,Net_Quantity__c,Quantity,IsInventoryUpdated__c,Order.No_Picking_Package_Shipment_Required__c,Inventory_Status__c,Discount__c from OrderItem where OrderId= :orderId]; Decimal Amounttoupdate =0;
            for(OrderItem temp :orderLines )
            {
                if(!temp.Splited_Order_Line__c && temp.Order_Status__c =='Pending')
                {
                    temp.Order_Status__c = 'Order Confirmed';
                    if(temp.Order.Customer_Type__c == 'Credit Customer')
                        {
                            Amounttoupdate += temp.TotalPrice__c;
                            temp.Is_Credit_Updated__c =true;
                        }
                }
                

                if(temp.Stock_Fulfilled__c == true  && temp.IsInventoryUpdated__c ==false && temp.Order_Status__c =='Order Confirmed' && (temp.Order.Auto_Allocate__c ||temp.Inventory_Status__c =='Allocated'))
                {
                allocatedorderLines.add(temp);
                }
            }
            update orderLines;
            
            if(orderObj.Customer_Type__c == 'Credit Customer' )//|| orderObj.Order_Created_Via__c == 'Subscription'
            {   
                DT = [select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: orderObj.AccountId limit 1 ];
                
                if(DT.Paid_Amount__c == null)
                    DT.Paid_Amount__c =0;
                DT.Paid_Amount__c = DT.Paid_Amount__c + payment.Amount_Recevied__c;
                if(Amounttoupdate >0)
                DT.Ordered_Amount__c +=Amounttoupdate;
                update DT;
                system.debug('DT>>'+DT);
            }

            Order_Payment__c orderPaymentObj = new Order_Payment__c();
            orderPaymentObj.Order__c = orderId;
            orderPaymentObj.Payment__c = paymentId;   
            orderPaymentObj.Amount__c = chargeAmount;
            orderPaymentObj.Payment_Type__c = 'Charge';         
            orderPaymentObj.Payment_Status__c = 'Payment Success';
            orderPaymentObj.Quantity__c = orderObj.Quantity__c;
            upsert orderPaymentObj;  
			
			
			//handle invoice status after payment 13-03-2020
            if(orderObj.Order_Created_Via__c == 'POS')
            {
                system.debug('orderObj.id>>>'+orderObj.id);
                List<Invoice__c> invoice=new List<Invoice__c>(); 
                invoice = [Select id,name,Invoice_Status__c from Invoice__c where Orderlookup__c =:orderObj.id];
                if(invoice.size()>0)
                {
                    if(orderObj.Orders_Status__c == 'Order Confirmed')
                    {
                        invoice[0].Invoice_Status__c='Paid';
                    }
                    if(invoice !=null)
                    {
                        update invoice;
                    }
                }
                else
                {
                    system.debug('inside else');
                    
                    Invoice__c invoice1 = new Invoice__c();
                    List<Invoice_Item__c>Invoiceitem = new List<Invoice_Item__c>();
                    invoice1.Orderlookup__c = orderObj.id; 
                    invoice1.Invoice_Type__c='Sales Invoice';
                    invoice1.Customer__c =orderObj.AccountId; 
                    
                    if(orderObj.Orders_Status__c=='Pending')
                    {
                        invoice1.Invoice_Status__c='Unpaid'; 
                    }
                    else if(orderObj.Orders_Status__c =='Canceled')
                    {
                        invoice1.Invoice_Status__c='Cancelled';
                    }
                    else
                    {
                        invoice1.Invoice_Status__c = 'paid';
                    }
                    system.debug('invoice1>>>>'+invoice1);
                    insert invoice1;
                    for(OrderItem orderline : orderLines)
                    {
                        Invoice_Item__c invoicedata = new Invoice_Item__c();
                        invoicedata.Invoice_Number__c=invoice1.id;
                        invoicedata.Order_Product__c=orderline.id;
                        invoicedata.Quantity__c = orderline.Quantity;
                        invoicedata.Total_Amount__c=orderline.TotalPrice__c;
                        invoicedata.Product__c=orderline.Product2Id;
                        //invoicedata.Net_Amount__c = orderline.Product__r.Product_Price__c;
                        if(orderline.Discount__c!=null && orderline.Discount__c>0)
                            invoicedata.Discount__c = orderline.Discount__c;
                        Invoiceitem.add(invoicedata);
                    }
                    if(Invoiceitem.size()>0)
                        insert Invoiceitem;
                }
            }
            
            if(allocatedorderLines.size()>0)
            {
                autostockreservation.autostockreserveforOrder(allocatedorderLines);
            }
        //}  
        return payment;
    }
   @AuraEnabled
    public static String fetchPaymentVendor(Id custId)
    {       
        String paymentVendor = '';  
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('Account')
            && CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'Id','name','ParentId','Parent.type','Parent.sigmaerpdev__Payment_Vendor__c','Type'}))
        {*/
            Account accObject ;
            accObject = [SELECT Id,ParentId,Parent.type,Parent.Payment_Vendor__c,Type from Account where Id=:custId];  
            if(accObject.Parent.type == 'Store')
            {
                Account parentAcc;
                parentAcc = [Select Id,ParentId,Parent.type,Parent.Payment_Vendor__c from Account where Id=:accObject.ParentId ];   

                if(parentAcc.Parent.type == 'Merchant')
                {
                    if(parentAcc.Parent.Payment_Vendor__c == 'Stripe'){
                    paymentVendor = 'Stripe';
                    }
                    else if(parentAcc.Parent.Payment_Vendor__c == 'Paypal'){
                        paymentVendor = 'Paypal';
                    }
                }  
            }
            else if(accObject.Parent.type == 'Merchant')
            {
                if(accObject.Parent.Payment_Vendor__c == 'Stripe'){
                paymentVendor = 'Stripe';
                }
                else if(accObject.Parent.Payment_Vendor__c == 'Paypal'){
                paymentVendor = 'Paypal';
                }
            }
            else if(accObject.type == 'Client')
            {
                paymentVendor = 'Paypal';
            }
            else if(accObject.type == 'Customer')
            {
                paymentVendor = 'Paypal';
            }
            else{
                System.debug('unknown parent type');
            }
        //}
        return paymentVendor;
    }
    @AuraEnabled
    public static String stripePayment(Payment__c payment,Decimal chargeAmount,String CVV, String expiryMonth, String expiryYear,Decimal paidAmount,String accountid)
    {   
        string temp;
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Payment__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('Account')
            && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')

            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Payment__c',new set<String>{'sigmaerpdev__Paid_Amount__c','sigmaerpdev__Amount_Recevied__c','sigmaerpdev__Amount__c','sigmaerpdev__SFDC_Account__c','sigmaerpdev__OrderId__c','sigmaerpdev__Credit_CardNumber__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new set<String>{'sigmaerpdev__Auto_Reserve_Stock__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'Id','name','sigmaerpdev__stripeCustomerId__c','sigmaerpdev__Currency_code__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'OrderId','Order.name','Order.Account.name','sigmaerpdev__Order_Status__c','Product2Id','sigmaerpdev__Back_Order__c','sigmaerpdev__Stock_Fulfilled__c','Order.sigmaerpdev__Auto_Allocate__c','Product2.name','Order.sigmaerpdev__Customer_Type__c','sigmaerpdev__TotalPrice__c','TotalPrice','sigmaerpdev__Unit_Price__c','sigmaerpdev__Net_Quantity__c','Quantity','sigmaerpdev__IsInventoryUpdated__c','sigmaerpdev__Splited_Order_Line__c'})
            
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Payment__c',new set<String>{'sigmaerpdev__PayPal_Transaction_Id__c','sigmaerpdev__Charge_Id__c','sigmaerpdev__Payment_Time__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Status__c','sigmaerpdev__Credit_CardNumber__c'})
            && CRUD_FLS_CheckUtility.checkFLS('OrderItem',new set<String>{'sigmaerpdev__Order_Status__c'}))
        {*/
            List<OrderItem> allocatedorderLines =  new List<OrderItem>();
            List<OrderItem> orderLines =  new List<OrderItem>();
            
            //check autostock reserve is true 
            Default_Parameters__c autostockreserve = [select Auto_Reserve_Stock__c from Default_Parameters__c limit 1];
            if(accountid != null && String.isNotEmpty(accountid))
            {
                Map<String, String> properties;
                Map<String, String> metadata;
                List<Account> acc = new List<Account>();
                acc = [select id,stripeCustomerId__c,Currency_code__c from Account where id =:accountid limit 1];

                List<Payment__c> paymentList = new List<Payment__c>();
                if(!acc.isEmpty() && acc[0].stripeCustomerId__c != null && acc[0].Currency_code__c != null)
                {                
                    properties = new Map<String, String>();
                    metadata = new Map<String, String>();
                    String cusID =  acc[0].stripeCustomerId__c;
                    Decimal Amount = chargeAmount; 
                    metadata.put('SFDCAccount',acc[0].Id);
                    properties.put('customer', acc[0].stripeCustomerId__c);
                    properties.put('currency', acc[0].Currency_code__c); 
                    StripeCharge sc = StripeCharge.charge(cusID,Amount,properties,metadata);

                    if(Test.isrunningtest() || (sc.balance_transaction != null && String.isNotEmpty(sc.balance_transaction)))
                    { 
                        if(!test.isrunningtest()){
                            payment.PayPal_Transaction_Id__c = sc.balance_transaction; 
                        }
                        if ((Schema.sObjectType.Payment__c.isAccessible()) &&
                        (Schema.sObjectType.Payment__c.fields.Paid_Amount__c.isAccessible()) &&
                        (Schema.sObjectType.Payment__c.fields.Paid_Amount__c.isCreateable()) &&
                        (Schema.sObjectType.Payment__c.fields.Paid_Amount__c.isUpdateable()))
                        {
                            if(payment.Paid_Amount__c == null)
                            {
                                payment.Paid_Amount__c = 0;
                            }
                            payment.Paid_Amount__c = payment.Paid_Amount__c + payment.Amount_Recevied__c;

                        }
                        if((Schema.sObjectType.Payment__c.isAccessible()) &&
                        (Schema.sObjectType.Payment__c.fields.Charge_Id__c.isAccessible()) &&
                        (Schema.sObjectType.Payment__c.fields.Charge_Id__c.isCreateable()) &&
                        (Schema.sObjectType.Payment__c.fields.Charge_Id__c.isUpdateable()))
                        { 
                            if(!test.isrunningtest()){
                                payment.Charge_Id__c = sc.id; 
                            }
                        }                                          
                        datetime pmntDateTime = datetime.now();    
                        if ((Schema.sObjectType.Payment__c.isAccessible()) &&
                        (Schema.sObjectType.Payment__c.fields.Payment_Time__c.isAccessible()) &&
                        (Schema.sObjectType.Payment__c.fields.Payment_Time__c.isCreateable()) &&
                        (Schema.sObjectType.Payment__c.fields.Payment_Time__c.isUpdateable()))
                        {
                            payment.Payment_Time__c = pmntDateTime;
                        }
                        if ((Schema.sObjectType.Payment__c.isAccessible()) &&
                            (Schema.sObjectType.Payment__c.fields.Status__c.isAccessible()) &&
                            (Schema.sObjectType.Payment__c.fields.Status__c.isCreateable()) &&
                            (Schema.sObjectType.Payment__c.fields.Status__c.isUpdateable()))
                        {
                            if(payment.Amount__c <= payment.Paid_Amount__c)
                            {
                                payment.Status__c = 'Completed';
                            }
                            else
                            {
                                payment.Status__c = 'Partial Paid';
                            } 
                        }
                        Integer first = payment.Credit_CardNumber__c.length() - 4;
                        Integer sec = payment.Credit_CardNumber__c.length();
                        String mask = payment.Credit_CardNumber__c.substring(first,sec );
                        String markcardnumb= 'XXXXXXXXXXXX'+String.valueof(mask) ;
                        if ((Schema.sObjectType.Payment__c.isAccessible()) &&
                        (Schema.sObjectType.Payment__c.fields.Credit_CardNumber__c.isAccessible()) &&
                        (Schema.sObjectType.Payment__c.fields.Credit_CardNumber__c.isCreateable()) &&
                        (Schema.sObjectType.Payment__c.fields.Credit_CardNumber__c.isUpdateable()))
                        {
                        payment.Credit_CardNumber__c = markcardnumb;

                        }
                        paymentList.add(payment);
                        upsert paymentList;
					
                        Id orderId = payment.OrderId__c;      
                        Id paymentId = payment.Id; 
                        temp = savePaymentDetails(payment,orderId,paymentId);
                        return temp;
                    }
                }                                                                                
                else if(!acc.isEmpty() && acc[0].stripeCustomerId__c == null && acc[0].Currency_code__c != null)
                {
                    String cardNumber = String.valueOf(payment.Credit_CardNumber__c);
                    String expMonth = expiryMonth;
                    String expYear = expiryYear;
                    String cvc = CVV;
                    properties = new Map<String, String>();
                    properties.put('number',cardNumber);
                    properties.put('exp_month',expMonth);
                    properties.put('exp_year',expYear);
                    properties.put('cvc',cvc);
                    FetchStripeToken st = FetchStripeToken.fetchToken(properties);
                    if(st.id != null && String.isNotEmpty(st.id))
                    {
                        properties = new Map<String, String>();
                        metadata = new Map<String, String>();
                        properties.put('source', st.id);
                        properties.put('description','sigma order Customer');
                        
                        metadata.put('SFDCAccount', acc[0].Id);
                        StripeCustomer scus = StripeCustomer.updateCustomer(null,properties,metadata);
                        if(scus.id != null && String.isNotEmpty(scus.id))
                        {
                            properties = new Map<String, String>();
                            metadata = new Map<String, String>();
                            String cusID =  scus.id;
                            Decimal Amount = chargeAmount; 
                            
                           
                            metadata.put('SFDCAccount',acc[0].Id);
                            properties.put('customer', acc[0].stripeCustomerId__c);
                            properties.put('currency', acc[0].Currency_code__c); 
                            StripeCharge sc = StripeCharge.charge(cusID,Amount,properties,metadata);
                            acc[0].stripeCustomerId__c = scus.id;
                            
                            if(Test.isrunningtest() || sc.balance_transaction != null && String.isNotEmpty(sc.balance_transaction))
                            { 
                                if ((Schema.sObjectType.Payment__c.isAccessible()) &&
                                (Schema.sObjectType.Payment__c.fields.Paid_Amount__c.isAccessible()) &&
                                (Schema.sObjectType.Payment__c.fields.Paid_Amount__c.isCreateable()) &&
                                (Schema.sObjectType.Payment__c.fields.Paid_Amount__c.isUpdateable()))
                                {
                                    if(payment.Paid_Amount__c == null)
                                    {
                                        payment.Paid_Amount__c = 0;
                                        
                                    }
                                    payment.Paid_Amount__c = payment.Paid_Amount__c + payment.Amount_Recevied__c;
                                  
                                }
                                if ((Schema.sObjectType.Payment__c.isAccessible()) &&
                                (Schema.sObjectType.Payment__c.fields.PayPal_Transaction_Id__c.isAccessible()) &&
                                (Schema.sObjectType.Payment__c.fields.PayPal_Transaction_Id__c.isCreateable()) &&
                                (Schema.sObjectType.Payment__c.fields.PayPal_Transaction_Id__c.isUpdateable()))
                                {
                                    if(!test.isrunningtest()){
                                        payment.PayPal_Transaction_Id__c = sc.balance_transaction; 
                                          
                                    }
                                }
                                datetime pmntDateTime = datetime.now(); 
                                if ((Schema.sObjectType.Payment__c.isAccessible()) &&
                                (Schema.sObjectType.Payment__c.fields.Charge_Id__c.isAccessible()) &&
                                (Schema.sObjectType.Payment__c.fields.Charge_Id__c.isCreateable()) &&
                                (Schema.sObjectType.Payment__c.fields.Charge_Id__c.isUpdateable()))
                                { 
                                    if(!test.isrunningtest()){
                                    payment.Charge_Id__c = sc.id; 
                                    }
                                }
                                if ((Schema.sObjectType.Payment__c.isAccessible()) &&
                                (Schema.sObjectType.Payment__c.fields.Payment_Time__c.isAccessible()) &&
                                (Schema.sObjectType.Payment__c.fields.Payment_Time__c.isCreateable()) &&
                                (Schema.sObjectType.Payment__c.fields.Payment_Time__c.isUpdateable()))
                                {
                                   payment.Payment_Time__c = pmntDateTime;
                                }
                                if ((Schema.sObjectType.Payment__c.isAccessible()) &&
                                (Schema.sObjectType.Payment__c.fields.Status__c.isAccessible()) &&
                                (Schema.sObjectType.Payment__c.fields.Status__c.isCreateable()) &&
                                (Schema.sObjectType.Payment__c.fields.Status__c.isUpdateable()))
                                {

                                    if(payment.Amount__c <= payment.Paid_Amount__c)
                                    {
                                        payment.Status__c = 'Completed';
                                    }
                                    else
                                    {
                                        payment.Status__c = 'Partial Paid';
                                    }  
                                }
                                Integer first = payment.Credit_CardNumber__c.length() - 4;
                                Integer sec = payment.Credit_CardNumber__c.length();
                                String mask = payment.Credit_CardNumber__c.substring(first,sec );
                                String markcardnumb= 'XXXXXXXXXXXX'+String.valueof(mask) ;    
                                if ((Schema.sObjectType.Payment__c.isAccessible()) &&
                                (Schema.sObjectType.Payment__c.fields.Credit_CardNumber__c.isAccessible()) &&
                                (Schema.sObjectType.Payment__c.fields.Credit_CardNumber__c.isCreateable()) &&
                                (Schema.sObjectType.Payment__c.fields.Credit_CardNumber__c.isUpdateable()))
                                {
                                        payment.Credit_CardNumber__c = markcardnumb; 
                                       
                                }
                                paymentList.add(payment);
                               
                                insert paymentList;
                               
                                
								
                                Id orderId = payment.OrderId__c;      
                                Id paymentId = payment.Id; 
								temp = savePaymentDetails(payment,orderId,paymentId);
                                
                                orderLines = [select id,OrderId,Order.name,Splited_Order_Line__c,Order.Account.name,Order_Status__c,Product2Id,Back_Order__c,Stock_Fulfilled__c,Order.Auto_Allocate__c,Product2.name,Order.Customer_Type__c,TotalPrice__c,TotalPrice,Unit_Price__c,Net_Quantity__c,Quantity,IsInventoryUpdated__c,Order.No_Picking_Package_Shipment_Required__c,Inventory_Status__c from OrderItem where OrderId= :orderId];
                                for(OrderItem temp1 :orderLines )
                                {
                                    
                                    if(temp1.Stock_Fulfilled__c == true && temp1.IsInventoryUpdated__c ==false && temp1.Order_Status__c == 'Order Confirmed' && (temp1.Order.Auto_Allocate__c ||temp1.Inventory_Status__c =='Allocated'))
                                    {
                                      allocatedorderLines.add(temp1);
                                    }
                                }
                                update orderLines;
                                if(allocatedorderLines.size()>0)
                                {
                                    system.debug('inautostock');
                                    autostockreservation.autostockreserveforOrder(allocatedorderLines);
                                }
                                
                            }
                        }
                    }
					return temp;
                }
            }
        //}
        return null; //added by samad
    }
     @AuraEnabled
    public static string savePaymentDetails(Payment__c payment, Id orderId,Id paymentId)
    {       
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Payment__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('Account')
            && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Payment__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Dimension_Tag__c')
            
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Payment__c',new set<String>{'sigmaerpdev__Paid_Amount__c','sigmaerpdev__Amount_Recevied__c','sigmaerpdev__Amount__c','sigmaerpdev__SFDC_Account__c','sigmaerpdev__OrderId__c','sigmaerpdev__Credit_CardNumber__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new set<String>{'sigmaerpdev__Auto_Reserve_Stock__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'Id','name','sigmaerpdev__stripeCustomerId__c','sigmaerpdev__Currency_code__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'Status','sigmaerpdev__Orders_Status__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Quantity__c','Total_Payable_Amount__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'sigmaerpdev__Order_Status__c','Product2Id','sigmaerpdev__Back_Order__c'})
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Dimension_Tag__c',new set<String>{'Id','sigmaerpdev__Base_Credit_Limit__c','sigmaerpdev__Ordered_Amount__c','sigmaerpdev__Paid_Amount__c'})
             
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Payment__c',new set<String>{'sigmaerpdev__Amount_Recevied__c'})
            && CRUD_FLS_CheckUtility.checkFLS('Order',new set<String>{'Status','sigmaerpdev__Is_Payment_Made__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Paid_Amount__c'})
            && CRUD_FLS_CheckUtility.checkFLS('OrderItem',new set<String>{'sigmaerpdev__Back_Order__c','sigmaerpdev__Order_Status__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Order_Payment__c',new set<String>{'sigmaerpdev__Order__c','sigmaerpdev__Payment__c','sigmaerpdev__Amount__c','sigmaerpdev__Payment_Type__c','sigmaerpdev__Payment_Status__c','sigmaerpdev__Quantity__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Dimension_Tag__c',new set<String>{'sigmaerpdev__Paid_Amount__c'})
            )
        { */
            try
            {
                Double chargeAmount = payment.Amount__c;  
                Order orderObj;
                List<OrderItem> orderLines =  new List<OrderItem>();
                Dimension_Tag__c DT;
                orderObj = [select AccountId,Customer_Type__c,Status,Orders_Status__c,Paid_Amount__c,Quantity__c,Total_Payable_Amount__c,Order_Created_Via__c from Order where Id =: orderId];       
      
              
                orderObj.Status = 'Draft';
                if(payment.Status__c == 'Completed')
                {
                    orderObj.Is_Payment_Made__c = true;
                }
                else
                {
                    orderObj.Is_Payment_Made__c = false;
                }
                orderObj.Orders_Status__c = 'Order Confirmed'; 
                if(payment.Amount_Recevied__c == null)
                {
                    payment.Amount_Recevied__c = 0;
                }
                orderObj.Paid_Amount__c = orderObj.Paid_Amount__c+payment.Amount_Recevied__c;
                update orderObj;     

                orderLines = [select id,Is_Credit_Updated__c,Splited_Order_Line__c,OrderId,Order.name,Order.Account.name,Order_Status__c,Product2Id,Back_Order__c,Stock_Fulfilled__c,Order.Auto_Allocate__c,Product2.name,Order.Customer_Type__c,TotalPrice__c,TotalPrice,Unit_Price__c,Net_Quantity__c,Quantity,IsInventoryUpdated__c,Order.No_Picking_Package_Shipment_Required__c,Inventory_Status__c,Discount__c from OrderItem where OrderId= :orderId];
                Decimal Amounttoupdate = 0;
                for(OrderItem temp :orderLines )
                {
                    
                    if(!temp.Splited_Order_Line__c && temp.Order_Status__c =='Pending')
                    {
                        temp.Order_Status__c = 'Order Confirmed';
                        if(temp.Order.Customer_Type__c == 'Credit Customer')
                        {
                            system.debug('in@@');
                            Amounttoupdate += temp.TotalPrice__c;
                            temp.Is_Credit_Updated__c =true;
                        }
                    }
                    
                }
                update orderLines;
                
                if(orderObj.Customer_Type__c == 'Credit Customer' )//|| orderObj.Order_Created_Via__c == 'Subscription'
                {   
                    DT = [select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: orderObj.AccountId limit 1 ];
                    
                    if(DT.Paid_Amount__c == null)
                        DT.Paid_Amount__c =0;
                    DT.Paid_Amount__c = DT.Paid_Amount__c + payment.Amount_Recevied__c;
                    if(Amounttoupdate >0)
                    DT.Ordered_Amount__c += Amounttoupdate;
                    update DT;
                    system.debug('DT>>'+DT);
                }
                
                Order_Payment__c orderPaymentObj = new Order_Payment__c();
                orderPaymentObj.Order__c = orderId;
                orderPaymentObj.Payment__c = paymentId; 
                orderPaymentObj.Amount__c = chargeAmount;
                orderPaymentObj.Payment_Type__c = 'Charge';                 
                orderPaymentObj.Payment_Status__c = 'Payment Success'; 
                orderPaymentObj.Quantity__c = orderObj.Quantity__c;
                upsert orderPaymentObj; 
                system.debug('orderPaymentObj::'+orderPaymentObj);
				
				//handle invoice status after payment 13-03-2020
            if(orderObj.Order_Created_Via__c == 'POS')
            {
                system.debug('orderObj.id>>>'+orderObj.id);
                List<Invoice__c> invoice=new List<Invoice__c>(); 
                invoice = [Select id,name,Invoice_Status__c from Invoice__c where Orderlookup__c =:orderObj.id];
                if(invoice.size()>0)
                {
                    if(orderObj.Orders_Status__c == 'Order Confirmed')
                    {
                        invoice[0].Invoice_Status__c='Paid';
                    }
                    if(invoice !=null)
                    {
                        update invoice;
                    }
                }
                else
                {
                    system.debug('inside else');
                    
                    Invoice__c invoice1 = new Invoice__c();
                    List<Invoice_Item__c>Invoiceitem = new List<Invoice_Item__c>();
                    invoice1.Orderlookup__c = orderObj.id; 
                    invoice1.Invoice_Type__c='Sales Invoice';
                    invoice1.Customer__c =orderObj.AccountId; 
                    
                    if(orderObj.Orders_Status__c=='Pending')
                    {
                        invoice1.Invoice_Status__c='Unpaid'; 
                    }
                    else if(orderObj.Orders_Status__c =='Canceled')
                    {
                        invoice1.Invoice_Status__c='Cancelled';
                    }
                    else
                    {
                        invoice1.Invoice_Status__c = 'paid';
                    }
                    system.debug('invoice1>>>>'+invoice1);
                    insert invoice1;
                    for(OrderItem orderline : orderLines)
                    {
                        Invoice_Item__c invoicedata = new Invoice_Item__c();
                        invoicedata.Invoice_Number__c=invoice1.id;
                        invoicedata.Order_Product__c=orderline.id;
                        invoicedata.Quantity__c = orderline.Quantity;
                        invoicedata.Total_Amount__c=orderline.TotalPrice__c;
                        invoicedata.Product__c=orderline.Product2Id;
                        //invoicedata.Net_Amount__c = orderline.Product__r.Product_Price__c;
                        if(orderline.Discount__c!=null && orderline.Discount__c>0)
                            invoicedata.Discount__c = orderline.Discount__c;
                        Invoiceitem.add(invoicedata);
                    }
                    if(Invoiceitem.size()>0)
                        insert Invoiceitem;
                }
            }
				
            }
            catch(Exception e){
                System.debug('error while saving payment details in order & order_payment objects'+e.getMessage());
            }
        //}  
        return 'hai'; 
    }
}