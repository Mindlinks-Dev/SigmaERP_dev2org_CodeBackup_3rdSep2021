public with sharing class CreditSavePaymentCntrl
{ 
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
       
    system.debug('InsideFLS');
       
      /*  datetime pmntDateTime = datetime.now();             
        payment.Payment_Time__c = pmntDateTime; 
          if(payment.sigmaerpdev__Paid_Amount__c == null)
          {
            payment.sigmaerpdev__Paid_Amount__c = 0;
          }
        payment.sigmaerpdev__Paid_Amount__c = payment.sigmaerpdev__Paid_Amount__c+payment.sigmaerpdev__Amount_Recevied__c;
       
        if(payment.sigmaerpdev__Amount__c <= payment.sigmaerpdev__Paid_Amount__c)
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
        system.debug('payment:'+payment); */
       
        //Id orderId = payment.Sigma_Order__c;
       // List<Id>orderId = new List<Id>();
       // orderId.add(payment.Sigma_Order__c); 
         
    //system.debug('orderId::'+orderId);
        Id paymentId = payment.Id;
        Double chargeAmount = payment.Amount__c;               
        system.debug('payment.Sigma_Order__c'+payment.Sigma_Order__c);
       List<Sigma_Order__c> orderObj= new List<Sigma_Order__c>();
        
        List<Product_Order_Price_Book__c> orderLines =  new List<Product_Order_Price_Book__c>();
           
            orderObj = [select Status__c,Orders_Status__c,Quantity__c,Account_Subscription_Interval__c,Due_Amount__c,TotalAmount__c ,Paid_Amount__c,Account_Subscription_Interval__r.Name from Sigma_Order__c where Id =: payment.Sigma_Order__c];       
            
       system.debug('orderObj::'+orderObj);
       /*  orderObj[0].Status__c = 'Draft';
        if(payment.Status__c == 'Completed')
        {
            orderObj[0].Is_Payment_Made__c = true;
        }
        else
        {
            orderObj[0].Is_Payment_Made__c = false;
        }
        
        orderObj[0].Orders_Status__c = 'Order Confirmed'; 
         if(payment.sigmaerpdev__Amount_Recevied__c == null)
          {
          payment.sigmaerpdev__Amount_Recevied__c = 0;
          }
        orderObj[0].sigmaerpdev__Paid_Amount__c = orderObj[0].sigmaerpdev__Paid_Amount__c+payment.sigmaerpdev__Amount_Recevied__c;
           
              update orderObj[0];    
        
           //code to update Account sub Status  
       if(orderObj[0].Account_Subscription_Interval__c!= null)
       {
        Account_Subscription_Intervals__c accsub;
        
       // accsub=[select Name,sigmaerpdev__Usage_Type__c,Payment_Status__c from Account_Subscription_Intervals__c where Name =: orderObj.Account_Subscription_Interval__r.Name];
        //code Added isolate OrderLine's Order_Status__c field on Nov-16
        if(accsub.Payment_Status__c=='Not Paid' && accsub.sigmaerpdev__Usage_Type__c=='Product')
        {
            accsub.Payment_Status__c='Paid';
            accsub.sigmaerpdev__Order_Status__c='Confirm';
        }
        else if(accsub.Payment_Status__c=='Not Paid' && accsub.sigmaerpdev__Usage_Type__c!='Product')

        {
            accsub.Payment_Status__c='Paid';
           
        }
        
        update accsub;
       }  

           orderLines = [select id,Sigma_Order__r.Id,Order_Status__c,Product__c from Product_Order_Price_Book__c where Sigma_Order__r.Id = :payment.Sigma_Order__c];
       
        //code added by anuja
        Time_Base_Inventory__c TBI;
            TBI=[select Order__c,Proposal_to_Order__c from Time_Base_Inventory__c];
        Boolean Execute;
        
            if(TBI.Order__c ==true || TBI.Proposal_to_Order__c ==true)
            {
                Execute = AllocateInventoryCntrl.AllocateInventoryforOrder(orderLines);
            }
        
        
        
        for(Product_Order_Price_Book__c temp :orderLines ){
            temp.Order_Status__c = 'Order Confirmed';
        }
        
        
          update orderLines;
              
        Order_Payment__c orderPaymentObj = new Order_Payment__c();
        //orderPaymentObj.Sigma_Order__c = orderId;
        orderPaymentObj.Payment__c = paymentId;  
        orderPaymentObj.Amount__c = chargeAmount;
        orderPaymentObj.Payment_Type__c = 'Charge';
        orderPaymentObj.Payment_Status__c = 'Payment Success';  
       // orderPaymentObj.Quantity__c = orderObj.Quantity__c;
           
              upsert orderPaymentObj;     
            */
                     
         return payment; // added by samad  
  }
    
   /*
    @AuraEnabled
    public static Payment__c saveChequePayment(Payment__c payment)
    {
        if(CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Payment__c',new set<String>{'sigmaerpdev__Payment_Time__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Amount_Recevied__c','sigmaerpdev__Amount__c','sigmaerpdev__Status__c','sigmaerpdev__Customer_SFID__c','sigmaerpdev__SFDC_Account__c'}) 
          &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Payment__c',new set<String>{'id','name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Amount__c','sigmaerpdev__SFDC_Account__c'}) 
          && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'Id','name','sigmaerpdev__Due_Amount__c','sigmaerpdev__Status__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Quantity__c','sigmaerpdev__Account_Subscription_Interval__c','sigmaerpdev__Account_Subscription_Interval__r.Name','sigmaerpdev__TotalAmount__c' ,'sigmaerpdev__Paid_Amount__c','sigmaerpdev__Orders_Status__c'}) 
       && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sigma_Order__c',new set<String>{'sigmaerpdev__Status__c','sigmaerpdev__Is_Payment_Made__c','sigmaerpdev__Orders_Status__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Account_Subscription_Intervals__c',new set<String>{'Id','name','sigmaerpdev__Payment_Status__c','sigmaerpdev__Usage_Type__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Account_Subscription_Intervals__c',new set<String>{'sigmaerpdev__Payment_Status__c','sigmaerpdev__Order_Status__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c', new set<String>{'id','sigmaerpdev__Sigma_Order__r.Id','sigmaerpdev__Order_Status__c','sigmaerpdev__Product__c'}) 
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Order_Price_Book__c', new set<String>{'sigmaerpdev__Order_Status__c'}) 
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Time_Base_Inventory__c',new set<String>{'Id','name','sigmaerpdev__Order__c','sigmaerpdev__Proposal_to_Order__c'}) 
        &&Schema.sObjectType.sigmaerpdev__Order_Payment__c.fields.name.isAccessible()
        &&Schema.sObjectType.sigmaerpdev__Order_Payment__c.fields.name.isAccessible()
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Order_Payment__c',new set<String>{'sigmaerpdev__Sigma_Order__c','sigmaerpdev__Payment__c','sigmaerpdev__Amount__c','sigmaerpdev__Payment_Type__c','sigmaerpdev__Payment_Status__c','sigmaerpdev__Quantity__c'}))
        {
            
        
        datetime pmntDateTime = datetime.now();             
        payment.Payment_Time__c = pmntDateTime;
        if(payment.sigmaerpdev__Paid_Amount__c == null)
          {
            payment.sigmaerpdev__Paid_Amount__c = 0;
          }
         
        payment.sigmaerpdev__Paid_Amount__c = payment.sigmaerpdev__Paid_Amount__c+payment.sigmaerpdev__Amount_Recevied__c;
        
        if(payment.sigmaerpdev__Amount__c <= payment.sigmaerpdev__Paid_Amount__c)
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
        
        Id orderId = payment.Sigma_Order__c;         
        Id paymentId = payment.Id;
        Double chargeAmount = payment.Amount__c;        
        Sigma_Order__c orderObj;
        
        List<Product_Order_Price_Book__c> orderLines =  new List<Product_Order_Price_Book__c>();
           
            orderObj = [select Status__c,Quantity__c,Orders_Status__c,sigmaerpdev__Paid_Amount__c,sigmaerpdev__TotalAmount__c,Account_Subscription_Interval__c,Account_Subscription_Interval__r.Name from Sigma_Order__c where Id =: orderId]; 
       orderObj.Status__c = 'Draft';
        if(payment.Status__c == 'Completed')
        {
            orderObj.Is_Payment_Made__c = true;
        }
        else
        {
            orderObj.Is_Payment_Made__c = false;
        }
        orderObj.Orders_Status__c = 'Order Confirmed'; 
            if(payment.sigmaerpdev__Amount_Recevied__c == null)
            {
            payment.sigmaerpdev__Amount_Recevied__c = 0;
            }
        orderObj.sigmaerpdev__Paid_Amount__c = orderObj.sigmaerpdev__Paid_Amount__c+payment.sigmaerpdev__Amount_Recevied__c;
           
       
            update orderObj;  
        
       if(orderObj.Account_Subscription_Interval__c!= null )
       {
           Account_Subscription_Intervals__c accsub;
        
        accsub=[select Name,Payment_Status__c,sigmaerpdev__Usage_Type__c from Account_Subscription_Intervals__c where Name =: orderObj.Account_Subscription_Interval__r.Name];
        if(accsub.Payment_Status__c=='Not Paid' && accsub.sigmaerpdev__Usage_Type__c=='Product' )
        {
            accsub.Payment_Status__c='Paid';
            accsub.sigmaerpdev__Order_Status__c='Confirm';
        }
        else if(accsub.Payment_Status__c=='Not Paid' && accsub.sigmaerpdev__Usage_Type__c !='Product' )
        {
            accsub.Payment_Status__c='Paid';
           
        }
        
        update accsub; 
       }
        //code Added isolate OrderLine's Order_Status__c field on Nov-16
            
           
            orderLines = [select id,Sigma_Order__r.Id,Product__c,Order_Status__c from Product_Order_Price_Book__c where Sigma_Order__r.Id = :orderId];
       
          //code added by anuja
        Time_Base_Inventory__c TBI;
            TBI=[select Order__c,Proposal_to_Order__c from Time_Base_Inventory__c];
        Boolean Execute;
        
            if(TBI.Order__c ==true ||TBI.Proposal_to_Order__c == true)
            {
                Execute = AllocateInventoryCntrl.AllocateInventoryforOrder(orderLines);
            }
        
        for(Product_Order_Price_Book__c temp :orderLines ){
            temp.Order_Status__c = 'Order Confirmed';
        }
            
            update orderLines;
                        
        Order_Payment__c orderPaymentObj = new Order_Payment__c();
        orderPaymentObj.Sigma_Order__c = orderId;
        orderPaymentObj.Payment__c = paymentId;   
        orderPaymentObj.Amount__c = chargeAmount;
        orderPaymentObj.Payment_Type__c = 'Charge';         
        orderPaymentObj.Payment_Status__c = 'Payment Success';
        orderPaymentObj.Quantity__c = orderObj.Quantity__c;
            upsert orderPaymentObj;  
       
    }
    return payment;
    }
    
    
    @AuraEnabled
    public static String fetchPaymentVendor(Id custId)
    {       
        String paymentVendor = '';      
         
         if(CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'Id','name','ParentId','Parent.type','Parent.sigmaerpdev__Payment_Vendor__c','Type'}) 
          )  
         {
         
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
         
    }
     return paymentVendor;
    }
       
    //new code added to stripe payment by chandana
   @AuraEnabled
    public static String stripePayment(Payment__c payment,Decimal chargeAmount,String CVV, String expiryMonth, String expiryYear,String zipCode,Decimal paidAmount,String accountid)
    {   
       
        if(CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'Id','name','sigmaerpdev__Currency_code__c','sigmaerpdev__stripeCustomerId__c'})
            &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Payment__c',new Set<String>{'sigmaerpdev__Paid_Amount__c','sigmaerpdev__Credit_CardNumber__c','sigmaerpdev__Status__c','sigmaerpdev__Payment_Time__c','sigmaerpdev__Charge_Id__c','sigmaerpdev__PayPal_Transaction_Id__c'})
            &&Schema.sObjectType.sigmaerpdev__Payment__c.fields.Id.isAccessible()
           &&CRUD_FLS_CheckUtility.checkObjCRUD('Account')   
       &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Payment__c')
            )
        {
           
        string temp;
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
                       if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Paid_Amount__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Amount_Recevied__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Paid_Amount__c.isCreateable()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Paid_Amount__c.isUpdateable()))
                         {
                           if(payment.sigmaerpdev__Paid_Amount__c == null)
                            {
                                payment.sigmaerpdev__Paid_Amount__c = 0;
                            }
                            payment.sigmaerpdev__Paid_Amount__c = payment.sigmaerpdev__Paid_Amount__c + payment.sigmaerpdev__Amount_Recevied__c;
                            system.debug('sigmaerpdev__Paid_Amount__c::'+payment.sigmaerpdev__Paid_Amount__c);
                         }
                        if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__PayPal_Transaction_Id__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__PayPal_Transaction_Id__c.isCreateable()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__PayPal_Transaction_Id__c.isUpdateable()))
                        {   
                            if(!test.isrunningtest()){
                                payment.PayPal_Transaction_Id__c = sc.balance_transaction; 
                            } 
                        }
                        if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Charge_Id__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Charge_Id__c.isCreateable()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Charge_Id__c.isUpdateable()))
                        {   
                            if(!test.isrunningtest()){
                            payment.Charge_Id__c = sc.id; 
                            }
                        }                       
                        
                        datetime pmntDateTime = datetime.now();    
                        if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Payment_Time__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Payment_Time__c.isCreateable()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Payment_Time__c.isUpdateable()))
                        {
                            payment.Payment_Time__c = pmntDateTime;
                        }   
                         if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Status__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Status__c.isCreateable()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Status__c.isUpdateable()))
                        {
                            
                            if(payment.sigmaerpdev__Amount__c <= payment.sigmaerpdev__Paid_Amount__c)
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
                        if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Credit_CardNumber__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Credit_CardNumber__c.isCreateable()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Credit_CardNumber__c.isUpdateable()))
                        {
                            payment.Credit_CardNumber__c = markcardnumb;
                        }   
                        if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Paid_Amount__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Paid_Amount__c.isCreateable()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Paid_Amount__c.isUpdateable()))
                        {
                            //payment.Paid_Amount__c = paidAmount;
                        }
                        paymentList.add(payment);
                       
                            upsert paymentList;
                                                  
                        Id orderId = payment.Sigma_Order__c;      
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
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Paid_Amount__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Paid_Amount__c.isCreateable()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Paid_Amount__c.isUpdateable()))
                            {
                                if(payment.sigmaerpdev__Paid_Amount__c == null)
                                {
                                    payment.sigmaerpdev__Paid_Amount__c = 0;
                                    
                                }
                                payment.sigmaerpdev__Paid_Amount__c = payment.sigmaerpdev__Paid_Amount__c + payment.sigmaerpdev__Amount_Recevied__c;
                               
                            }
                            if ((Schema.sObjectType.Payment__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__PayPal_Transaction_Id__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__PayPal_Transaction_Id__c.isCreateable()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__PayPal_Transaction_Id__c.isUpdateable()))
                            {
                                if(!test.isrunningtest())
                                    payment.PayPal_Transaction_Id__c = sc.balance_transaction; 
                                  
                            }
                            datetime pmntDateTime = datetime.now(); 
                            if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Charge_Id__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Charge_Id__c.isCreateable()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Charge_Id__c.isUpdateable()))
                            { 
                                if(!test.isrunningtest()){
                                payment.Charge_Id__c = sc.id; 
                                }
                            }
                            if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Payment_Time__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Payment_Time__c.isCreateable()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Payment_Time__c.isUpdateable()))
                            {
                                payment.Payment_Time__c = pmntDateTime;
                            }
                            if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Status__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Status__c.isCreateable()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Status__c.isUpdateable()))
                            {
                               if(payment.sigmaerpdev__Amount__c <= payment.sigmaerpdev__Paid_Amount__c)
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
                            if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Credit_CardNumber__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Credit_CardNumber__c.isCreateable()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Credit_CardNumber__c.isUpdateable()))
                            {
                                payment.Credit_CardNumber__c = markcardnumb; 
                            }   
                            if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Paid_Amount__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Paid_Amount__c.isCreateable()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Paid_Amount__c.isUpdateable()))
                            {
                               // payment.sigmaerpdev__Paid_Amount__c = paidAmount; 
                            }
                            paymentList.add(payment);
                            
                                insert paymentList;
                            
                            system.debug('paymentList::'+paymentList);      
                            Id orderId = payment.Sigma_Order__c;      
                            Id paymentId = payment.Id; 
                            temp = savePaymentDetails(payment,orderId,paymentId);
                            return temp;
                        }
                        
                    }
                }
            }
        }
       
      }
     return null; //added by samad
    }
    
    
    @AuraEnabled
    public static string savePaymentDetails(Payment__c payment, Id orderId,Id paymentId){       
        try{
            Double chargeAmount = payment.Amount__c;
           if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'Id','name','sigmaerpdev__Due_Amount__c','sigmaerpdev__Status__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Quantity__c','sigmaerpdev__Account_Subscription_Interval__c','sigmaerpdev__Account_Subscription_Interval__r.Name','sigmaerpdev__TotalAmount__c' ,'sigmaerpdev__Paid_Amount__c','sigmaerpdev__Orders_Status__c'}) 
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sigma_Order__c',new set<String>{'sigmaerpdev__Status__c','sigmaerpdev__Is_Payment_Made__c','sigmaerpdev__Orders_Status__c'}) 
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Account_Subscription_Intervals__c',new set<String>{'Id','name','sigmaerpdev__Payment_Status__c','sigmaerpdev__Usage_Type__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Account_Subscription_Intervals__c',new set<String>{'sigmaerpdev__Payment_Status__c','sigmaerpdev__Order_Status__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'id','sigmaerpdev__Sigma_Order__r.Id','sigmaerpdev__Product__c','sigmaerpdev__Order_Status__c'}) 
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Time_Base_Inventory__c',new set<String>{'sigmaerpdev__Order__c','sigmaerpdev__Proposal_to_Order__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev__Order_Status__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Order_Payment__c',new set<String>{'sigmaerpdev__Sigma_Order__c','sigmaerpdev__Payment__c','sigmaerpdev__Payment_Type__c','sigmaerpdev__Amount__c','sigmaerpdev__Payment_Status__c','sigmaerpdev__Quantity__c'}))
            {
             Sigma_Order__c orderObj;
            
            List<Product_Order_Price_Book__c> orderLines =  new List<Product_Order_Price_Book__c>();
                
                orderObj = [select Status__c,Quantity__c,Account_Subscription_Interval__c,sigmaerpdev__TotalAmount__c,sigmaerpdev__Paid_Amount__c,Account_Subscription_Interval__r.Name from Sigma_Order__c where Id =: orderId];      
             
            orderObj.Status__c = 'Draft';
           if(payment.Status__c == 'Completed')
            {
                orderObj.Is_Payment_Made__c = true;
            }
            else
            {
                orderObj.Is_Payment_Made__c = false;
            }
            orderObj.Orders_Status__c = 'Order Confirmed';    
            if(payment.sigmaerpdev__Amount_Recevied__c == null)
               {
                  payment.sigmaerpdev__Amount_Recevied__c = 0;
               }
            orderObj.sigmaerpdev__Paid_Amount__c = orderObj.sigmaerpdev__Paid_Amount__c+payment.sigmaerpdev__Amount_Recevied__c;
               
                update orderObj;     
            
              if(orderObj.Account_Subscription_Interval__c!= null )
                {
            Account_Subscription_Intervals__c accsub;
        
        accsub=[select Name,Payment_Status__c,sigmaerpdev__Usage_Type__c from Account_Subscription_Intervals__c where Name =: orderObj.Account_Subscription_Interval__r.Name];
        //code Added isolate OrderLine's Order_Status__c field on Nov-16
        if(accsub.Payment_Status__c=='Not Paid' && accsub.sigmaerpdev__Usage_Type__c=='Product')

        {
            accsub.Payment_Status__c='Paid';
            accsub.sigmaerpdev__Order_Status__c='Confirm';
        }
        else if(accsub.Payment_Status__c=='Not Paid' && accsub.sigmaerpdev__Usage_Type__c !='Product')

        {
            accsub.Payment_Status__c='Paid';
            
        }
        update accsub;
       }
           
            orderLines = [select id,sigmaerpdev__Sigma_Order__r.Id,Product__c,Order_Status__c from Product_Order_Price_Book__c where Sigma_Order__r.Id = :orderId];
        
            //code added by anuja
            Time_Base_Inventory__c TBI;
            TBI=[select Order__c,Proposal_to_Order__c from Time_Base_Inventory__c];
            Boolean Execute;
            
            if(TBI.Order__c ==true || TBI.Proposal_to_Order__c ==true )
            {
                Execute = AllocateInventoryCntrl.AllocateInventoryforOrder(orderLines);
            }
            
        
        for(Product_Order_Price_Book__c temp :orderLines ){
            temp.Order_Status__c = 'Order Confirmed';
        }
           
            update orderLines;
         
            Order_Payment__c orderPaymentObj = new Order_Payment__c();
            orderPaymentObj.Sigma_Order__c = orderId;
            orderPaymentObj.Payment__c = paymentId; 
            orderPaymentObj.Amount__c = chargeAmount;
            orderPaymentObj.Payment_Type__c = 'Charge';                 
            orderPaymentObj.Payment_Status__c = 'Payment Success'; 
            orderPaymentObj.Quantity__c = orderObj.Quantity__c;
            
                    upsert orderPaymentObj;  
            
              
         }
          
         
        }
        catch(Exception e){
             System.debug('error while saving payment details in order & order_payment objects'+e.getMessage());
         }
        return 'hai'; 
        
     
    }
    
    @AuraEnabled
    public static String CCValidation(String CCNumber)
    { // Added on 24th Nov Anil
            boolean isNumber = true;//26th Nov Anil
            String CardType; 
            try{
                Long x = Long.valueOf(CCNumber);
            }catch(exception e){
                isNumber = false;
                
            }
            
            if(CCNumber != ''){
                if(isNumber == true){
                    
                    Integer sum = 0;
                    Integer len = CCNumber.length();
                        for(Integer i=len-1;i>=0;i--){
                            Integer num = Integer.ValueOf(CCNumber.substring(i,i+1));
                            if ( math.mod(i , 2) == math.mod(len, 2) )
                            {
                                Integer n = num * 2;
                                sum += (n / 10) + ( math.mod(n, 10));
                            }
                            else{
                                sum += num;
                            }
                        }
                    CardType = creditCardType(CCNumber);
                }
            }
            return CardType;
        } 
        
        
        @AuraEnabled
        public static string creditCardType(String ccNumber)
        {
            string ccType = 'Unknown';
            if(Pattern.matches('^4[0-9]{12}(?:[0-9]{3})?$', ccNumber)){
                ccType = 'Visa';
            } else if(Pattern.matches('^5[1-5][0-9]{14}$', ccNumber)){
                ccType = 'MasterCard';
            } else if(Pattern.matches('^3[47][0-9]{13}$', ccNumber)){
                ccType = 'Amex';
            } else if(Pattern.matches('^6(?:011|5[0-9]{2})[0-9]{12}$', ccNumber)){
                ccType = 'Discover';
            }
            return ccType;
        }
    
    
          
   @AuraEnabled
    public static list<Payment__c> savesubscriptionCashPayment(List<Payment__c> payment)
    {
       if(CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Payment__c',new Set<String>{'sigmaerpdev__Payment_Time__c','sigmaerpdev__Status__c','sigmaerpdev__Customer_SFID__c','sigmaerpdev__SFDC_Account__c'})
        &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Account_Subscription_Intervals__c',new Set<String>{'sigmaerpdev__Payment_Status__c','sigmaerpdev__Payment__c'})
        &&Schema.sObjectType.sigmaerpdev__Payment__c.fields.Id.isAccessible()
        )
        {
        datetime pmntDateTime = datetime.now();             
        payment[0].Payment_Time__c = pmntDateTime;        
        payment[0].Status__c = 'Completed';       
        Id custId = payment[0].SFDC_Account__c;
        payment[0].Customer_SFID__c = custId;
       
       insert payment;     
        
        Account_Subscription_Intervals__c orderObj = new Account_Subscription_Intervals__c();
        String paymentid=payment[0].id;
        orderObj.Id = payment[0].Account_Subscription_Interval__c; 
        orderObj.Payment_Status__c = 'Paid';
        orderObj.Payment__c=paymentid;
        update orderObj;
      
        }
        return payment;
    }
        
    @AuraEnabled
    public static List<Payment__c> savesubscriptionChequePayment(List<Payment__c> payment)
    {
       if(CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Payment__c',new Set<String>{'sigmaerpdev__Payment_Time__c','sigmaerpdev__Status__c','sigmaerpdev__Customer_SFID__c','sigmaerpdev__SFDC_Account__c'})
       &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Account_Subscription_Intervals__c',new Set<String>{'sigmaerpdev__Payment_Status__c','sigmaerpdev__Payment__c'})
       &&Schema.sObjectType.sigmaerpdev__Payment__c.fields.Id.isAccessible()
       )
        {
        
        datetime pmntDateTime = datetime.now();             
        payment[0].Payment_Time__c = pmntDateTime;
        payment[0].Status__c = 'Completed';
        Id custId = payment[0].SFDC_Account__c;
        payment[0].Customer_SFID__c = custId;
         
            insert payment;
       
      Account_Subscription_Intervals__c orderObj = new Account_Subscription_Intervals__c();
        orderObj.Id = payment[0].Account_Subscription_Interval__c; 
        orderObj.Payment_Status__c = 'Paid';
        orderObj.Payment__c=payment[0].id;
        update orderObj;
        }
    
        return payment; 
 
    }
    @AuraEnabled
    public static String stripePaymentsubscription(Payment__c payment,Decimal chargeAmount,String CVV, String expiryMonth, String expiryYear,String zipCode,Decimal paidAmount,String accountid)
    {   
 
       if(CRUD_FLS_CheckUtility.checkReadPermission('Account',new Set<String>{'id','sigmaerpdev__Currency_code__c','sigmaerpdev__stripeCustomerId__c'})
            &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Account_Subscription_Intervals__c',new Set<String>{'sigmaerpdev__Order_Status__c','sigmaerpdev__Payment_Status__c','sigmaerpdev__Payment__c'})
            &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Payment__c',new Set<String>{'sigmaerpdev__Paid_Amount__c','sigmaerpdev__Credit_CardNumber__c','sigmaerpdev__Status__c','sigmaerpdev__Payment_Time__c','sigmaerpdev__Charge_Id__c','sigmaerpdev__PayPal_Transaction_Id__c'})
            
        )
        {
        
        string temp;
        String ids;
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
                            
                        if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__PayPal_Transaction_Id__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__PayPal_Transaction_Id__c.isCreateable()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__PayPal_Transaction_Id__c.isUpdateable()))
                        {   
                            if(!test.isrunningtest()){
                                payment.PayPal_Transaction_Id__c = sc.balance_transaction; 
                            } 
                        }
                        if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Charge_Id__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Charge_Id__c.isCreateable()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Charge_Id__c.isUpdateable()))
                        {   
                            if(!test.isrunningtest()){
                            payment.Charge_Id__c = sc.id; 
                            }
                        }                       
                        
                        datetime pmntDateTime = datetime.now();    
                        if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Payment_Time__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Payment_Time__c.isCreateable()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Payment_Time__c.isUpdateable()))
                        {
                            payment.Payment_Time__c = pmntDateTime;
                        }   
                         if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Status__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Status__c.isCreateable()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Status__c.isUpdateable()))
                        {
                            payment.Status__c = 'Completed'; 
                        } 
                        Integer first = payment.Credit_CardNumber__c.length() - 4;
                        Integer sec = payment.Credit_CardNumber__c.length();
                        String mask = payment.Credit_CardNumber__c.substring(first,sec );
                        String markcardnumb= 'XXXXXXXXXXXX'+String.valueof(mask) ;
                        if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Credit_CardNumber__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Credit_CardNumber__c.isCreateable()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Credit_CardNumber__c.isUpdateable()))
                        {
                            payment.Credit_CardNumber__c = markcardnumb;
                        }   
                        if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Paid_Amount__c.isAccessible()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Paid_Amount__c.isCreateable()) &&
                        (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Paid_Amount__c.isUpdateable()))
                        {
                            payment.Paid_Amount__c = paidAmount;
                        }
                        paymentList.add(payment);
                       
                            upsert paymentList;
                                                   
                        Id orderId = payment.Sigma_Order__c;      
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
                        
                        if(sc.balance_transaction != null && String.isNotEmpty(sc.balance_transaction))
                        { 
                            if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__PayPal_Transaction_Id__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__PayPal_Transaction_Id__c.isCreateable()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__PayPal_Transaction_Id__c.isUpdateable()))
                            {
                                payment.PayPal_Transaction_Id__c = sc.balance_transaction;   
                            }
                            datetime pmntDateTime = datetime.now(); 
                            
                            if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Payment_Time__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Payment_Time__c.isCreateable()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Payment_Time__c.isUpdateable()))
                            {
                                payment.Payment_Time__c = pmntDateTime;
                            }
                            if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Status__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Status__c.isCreateable()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Status__c.isUpdateable()))
                            {
                                payment.Status__c = 'Completed';   
                            }
                            Integer first = payment.Credit_CardNumber__c.length() - 4;
                            Integer sec = payment.Credit_CardNumber__c.length();
                            String mask = payment.Credit_CardNumber__c.substring(first,sec );
                            String markcardnumb= 'XXXXXXXXXXXX'+String.valueof(mask) ;    
                            if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Credit_CardNumber__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Credit_CardNumber__c.isCreateable()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Credit_CardNumber__c.isUpdateable()))
                            {
                                payment.Credit_CardNumber__c = markcardnumb; 
                            }   
                            if ((Schema.sObjectType.sigmaerpdev__Payment__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Paid_Amount__c.isAccessible()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Paid_Amount__c.isCreateable()) &&
                            (Schema.sObjectType.sigmaerpdev__Payment__c.fields.sigmaerpdev__Paid_Amount__c.isUpdateable()))
                            {
                                payment.Paid_Amount__c = paidAmount; 
                            }
                            paymentList.add(payment);
                            
                                insert paymentList;
                                
                            Id orderId = payment.Sigma_Order__c;   
                            Id paymentId = payment.Id; 
                            temp = savePaymentDetails(payment,orderId,paymentId);
                            //new code added for subcription payment 
                                Account_Subscription_Intervals__c orderObj = new Account_Subscription_Intervals__c();
                                orderObj.Id = payment.Account_Subscription_Interval__c; 
                                orderObj.Payment_Status__c = 'Paid';
                                orderObj.Payment__c = paymentId;
                                orderObj.sigmaerpdev__Order_Status__c='Confirm';
                                update orderObj;
                            
                            return String.valueOf(paymentList[0].Id);
                        }
                        ids=String.valueOf(paymentList[0].Id);
                    }
                }
            }
        }
        }
        return null;
    }  
    */
    
}