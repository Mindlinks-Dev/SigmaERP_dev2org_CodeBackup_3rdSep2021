public without sharing class WOSavePaymentCntrl
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
       
        try{
                System.debug('payment===='+payment);
                
                Work_Order__c orderObj;
                Id orderId = payment.Work_Order__c;  
                //Id paymentId = payment.Id;
                Double chargeAmount = payment.Amount__c;


                    
                
            system.debug('orderId'+orderId);
           //system.debug('paymentId'+paymentId);
           system.debug('chargeAmount'+chargeAmount);
                
                orderObj = [Select Id,Name,sigmaerpdev2__Is_Payment_Made__c,Account__c,sigmaerpdev2__Account__r.Name,Account__r.Customer_Type__c,Tax__c ,
                       sigmaerpdev2__Account__r.AccountNumber,sigmaerpdev2__Work_Type__c,Service_Warrenty_End_date__c,sigmaerpdev2__TotalAmount__c,sigmaerpdev2__Paid_Amount__c,
                       sigmaerpdev2__Work_Type__r.sigmaerpdev2__Service_Charge__c ,Sigma_orders__r.Total_Price__c,sigmaerpdev2__FFP_MR_Contact__c,Status__c,
                       sigmaerpdev2__Due_Amount__c,Net_Amount__c FROM sigmaerpdev2__Work_Order__c where Id =: orderId];    

            
                 Site_Visits__c site;
                 site=[select Work_Order__c from Site_Visits__c where Work_Order__c=:orderObj.id order by createdDate DESC limit 1];
            
        set<Id> prod=new set<Id>();
        List<sigmaerpdev2__Work_Oder_Lines__c> WOl;
            WOl=[Select Id,sigmaerpdev2__Product__c,sigmaerpdev2__Quantity__c,sigmaerpdev2__Price__c,
                sigmaerpdev2__Product__r.Name FROM sigmaerpdev2__Work_Oder_Lines__c where sigmaerpdev2__Work_Order__c=:orderId AND sigmaerpdev2__Used1__c = true];
                system.debug('WOl'+WOl);
                
           
         
               
                 List<Sigma_Order__c> Sorder=new List<Sigma_Order__c>(); 
                Sorder = [Select id,name,AccountId__c,TotalAmount__c,Paid_Amount__c,Is_Payment_Made__c from Sigma_Order__c where Site_Visits__c =:site.id];
                system.debug('Sorder'+Sorder);
                if(Sorder.size()>0)
                     {
                    
                    if(Sorder !=null)
                    {
                        if(Sorder[0].Paid_Amount__c == null)
                {
                    Sorder[0].Paid_Amount__c = 0;
                    
                }
                      /*  Sorder[0].Delivary_Date__c=System.today();
                        Sorder[0].Orders_Status__c= 'Delivered';
                        Sorder[0].Net_Amount__c=orderObj.Net_Amount__c;
                        Sorder[0].TotalAmount__c=orderObj.TotalAmount__c;
                        Sorder[0].Tax__c=orderObj.Tax__c;*/
                        Sorder[0].Paid_Amount__c=Sorder[0].Paid_Amount__c+payment.Amount_Recevied__c;
                        
                        if(Sorder[0].Paid_Amount__c >= orderObj.TotalAmount__c)
                        {
                            Sorder[0].Is_Payment_Made__c=true;
                        }
                        update Sorder;
                        system.debug('Sorder'+Sorder);
                        payment.Sigma_Order__c=Sorder[0].id;
                    }
                     }
                   
                   
                        
                       if(Sorder[0].Paid_Amount__c > 0)
               {
                   system.debug('Sorder[0].id>>>'+Sorder[0].id);
                   List<Invoice__c> invoice=new List<Invoice__c>(); 
                     invoice = [Select id,name,Invoice_Status__c from Invoice__c where SO__c =:Sorder[0].id];
                     if(invoice.size()>0)
                     {
                         if(Sorder[0].Is_Payment_Made__c!=true)
                    {
                        invoice[0].Invoice_Status__c='Partially Paid';
                    } 
                    if(Sorder[0].Is_Payment_Made__c==true)
                    {
                        invoice[0].Invoice_Status__c='Paid';
                    }
                    if(invoice !=null)
                    {
                        update invoice;
                    }
                     }
                   
               }
                        
                    
                   
         
         
       
                    
                    
                    
                
                                 
                datetime pmntDateTime = datetime.now();
                payment.Payment_Time__c = pmntDateTime; 
                system.debug('amount received'+payment.Amount_Recevied__c);
                if(payment.Paid_Amount__c == null)
                {
                    payment.Paid_Amount__c = 0;
                    
                }
                payment.Paid_Amount__c = payment.Paid_Amount__c+payment.Amount_Recevied__c;
                system.debug('payment.Paid_Amount__c'+payment.Paid_Amount__c);
                
                if(orderObj.Account__r.Customer_Type__c=='Credit Customer'){
                if(orderObj.Status__c =='Completed'||orderObj.Status__c =='Another Visit Needed'){
             
                    Dimension_Tag__c dimTag;
                        try{
                            dimTag=[select id,Paid_Amount__c from Dimension_Tag__c where Account__c=:orderObj.Account__c limit 1];
                        }
                        catch(Exception e){
                            
                        }
                        
                        if(dimTag!=null){
                            if(dimTag.Paid_Amount__c==null)
                                dimTag.Paid_Amount__c=0;
                            if(payment.Paid_Amount__c>0)
                                dimTag.Paid_Amount__c+=payment.Paid_Amount__c;
                            update dimTag;
                            System.debug('dimTag::'+dimTag);
                        }
        
                }
                }                                                                                   
                
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
                
                
                
                if(payment.Status__c == 'Completed')
                {
                    orderObj.Is_Payment_Made__c = true;
                }
                else
                {
                    orderObj.Is_Payment_Made__c = false;
                }
                
                  
                
                
                if(payment.Amount_Recevied__c == null)
                {
                    payment.Amount_Recevied__c = 0;
                }
                if(orderObj.Paid_Amount__c == null){
                    orderObj.Paid_Amount__c = 0;
                }
                orderObj.Paid_Amount__c = orderObj.Paid_Amount__c+payment.Amount_Recevied__c;
                system.debug('amount received>>'+payment.Amount_Recevied__c);
                update orderObj;    
                
                 if(orderObj.Paid_Amount__c > 0)
                {
                List<Invoice__c> invoice=new List<Invoice__c>(); 
                     invoice = [Select id,name,Invoice_Status__c from Invoice__c where Work_Order__c =:orderObj.id];
                     if(invoice.size()>0)
                     {
                         if(orderObj.Is_Payment_Made__c != true)
                    {
                        invoice[0].Invoice_Status__c='Partially Paid';
                    }
                    if(orderObj.Is_Payment_Made__c == true)
                    {
                        invoice[0].Invoice_Status__c='Paid';
                    }
                    if(invoice !=null)
                    {
                        update invoice;
                    }
                     }
                   
                }
                
                Order_Payment__c orderPaymentObj = new Order_Payment__c();
                orderPaymentObj.Work_Order__c = orderId;
                //orderPaymentObj.Payment__c = paymentId; 
                orderPaymentObj.Payment__c = payment.Id;
                orderPaymentObj.Amount__c = chargeAmount;
                orderPaymentObj.Payment_Type__c = 'Charge';
                orderPaymentObj.Payment_Status__c = 'Payment Success';  
                
                
                upsert orderPaymentObj; 
                
           
        }
        catch(Exception ex)
        {
            createErrorLog.insertError('WOSavePaymentCntrl',ex.getMessage(),'Method -saveCashPayment ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
        }  
        return payment;
    }
    
   @AuraEnabled
    public static Payment__c saveChequePayment(Payment__c payment)
    {
        try{
           
                
                Work_Order__c orderObj;
                Id orderId = payment.Work_Order__c;  
               // Id paymentId = payment.Id;
                Double chargeAmount = payment.Amount__c;               
                
                
                
                
                
                orderObj = [Select Id,Name,sigmaerpdev2__Is_Payment_Made__c,Account__c,sigmaerpdev2__Account__r.Name,Account__r.Customer_Type__c,Tax__c,
                       sigmaerpdev2__Account__r.AccountNumber,sigmaerpdev2__Work_Type__c,Service_Warrenty_End_date__c,sigmaerpdev2__TotalAmount__c,sigmaerpdev2__Paid_Amount__c,
                       sigmaerpdev2__Work_Type__r.sigmaerpdev2__Service_Charge__c ,Sigma_orders__r.Total_Price__c,sigmaerpdev2__FFP_MR_Contact__c,Status__c,
                       sigmaerpdev2__Due_Amount__c,Net_Amount__c FROM sigmaerpdev2__Work_Order__c where Id =: orderId];  
            
            Site_Visits__c site;
                 site=[select Work_Order__c from Site_Visits__c where Work_Order__c=:orderObj.id order by createdDate DESC limit 1];
                
                set<Id> prod=new set<Id>();
        List<sigmaerpdev2__Work_Oder_Lines__c> WOl;
            WOl=[Select Id,sigmaerpdev2__Product__c,sigmaerpdev2__Quantity__c,sigmaerpdev2__Price__c,
                sigmaerpdev2__Product__r.Name FROM sigmaerpdev2__Work_Oder_Lines__c where sigmaerpdev2__Work_Order__c=:orderId AND sigmaerpdev2__Used1__c = true];
                system.debug('WOl'+WOl);
                
                
         
                List<Sigma_Order__c> Sorder=new List<Sigma_Order__c>(); 
                Sorder = [Select id,name,AccountId__c,Paid_Amount__c,TotalAmount__c,Is_Payment_Made__c from Sigma_Order__c  where Site_Visits__c =:site.id];
                system.debug('Sorder'+Sorder);
                if(Sorder.size()>0)
                     {
                    
                    if(Sorder !=null)
                    {
                        if(Sorder[0].Paid_Amount__c == null)
                {
                    Sorder[0].Paid_Amount__c = 0;
                    
                }
                       /* Sorder[0].Delivary_Date__c=System.today();
                        Sorder[0].Orders_Status__c= 'Delivered';
                        Sorder[0].Net_Amount__c=orderObj.Net_Amount__c;
                        Sorder[0].TotalAmount__c=orderObj.TotalAmount__c;
                        Sorder[0].Tax__c=orderObj.Tax__c;*/
                        Sorder[0].Paid_Amount__c=Sorder[0].Paid_Amount__c+payment.Amount_Recevied__c;
                        
                        if(Sorder[0].Paid_Amount__c >= orderObj.TotalAmount__c)
                        {
                            Sorder[0].Is_Payment_Made__c=true;
                        }
                        update Sorder;
                        system.debug('Sorder'+Sorder);
                        payment.Sigma_Order__c=Sorder[0].id;
                    }
                     }
                    
                  if(Sorder[0].Paid_Amount__c > 0)
               {
                   system.debug('Sorder[0].id>>>'+Sorder[0].id);
                   List<Invoice__c> invoice=new List<Invoice__c>(); 
                     invoice = [Select id,name,Invoice_Status__c from Invoice__c where SO__c =:Sorder[0].id];
                     if(invoice.size()>0)
                     {
                          if(Sorder[0].Is_Payment_Made__c!=true)
                    {
                        invoice[0].Invoice_Status__c='Partially Paid';
                    }
                    if(Sorder[0].Is_Payment_Made__c==true)
                    {
                        invoice[0].Invoice_Status__c='Paid';
                    }
                    if(invoice !=null)
                    {
                        update invoice;
                    }
                     }
                    
               }
                    
                   
                     
                    
                    
                datetime pmntDateTime = datetime.now();             
                payment.Payment_Time__c = pmntDateTime;
                system.debug('amount received'+payment.Amount_Recevied__c);
                
                if(payment.Paid_Amount__c == null)
                {
                    payment.Paid_Amount__c = 0;
                }
                
                payment.Paid_Amount__c = payment.Paid_Amount__c+payment.Amount_Recevied__c;
                
               
                system.debug('payment.Amount__c-->>'+payment.Amount__c);
                system.debug('payment.Paid_Amount__c-->>>'+payment.Paid_Amount__c);
                
                if(orderObj.Account__r.Customer_Type__c=='Credit Customer'){
                if(orderObj.Status__c =='Completed'||orderObj.Status__c =='Another Visit Needed'){
             
                    Dimension_Tag__c dimTag;
                        try{
                            dimTag=[select id,Paid_Amount__c from Dimension_Tag__c where Account__c=:orderObj.Account__c limit 1];
                        }
                        catch(Exception e){
                            
                        }
                        
                        if(dimTag!=null){
                            if(dimTag.Paid_Amount__c==null)
                                dimTag.Paid_Amount__c=0;
                            if(payment.Paid_Amount__c>0)
                                dimTag.Paid_Amount__c+=payment.Paid_Amount__c;
                            update dimTag;
                            System.debug('dimTag::'+dimTag);
                        }
        
                }
                }   
                
                
                
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
                
                
                if(payment.Status__c == 'Completed')
                {
                    orderObj.Is_Payment_Made__c = true;
                }
                else
                {
                    orderObj.Is_Payment_Made__c = false;
                }
           
               
                
                if(payment.Amount_Recevied__c == null)
                {
                    payment.Amount_Recevied__c = 0;
                }
                if(orderObj.Paid_Amount__c == null){
                    orderObj.Paid_Amount__c = 0;
                }
                orderObj.Paid_Amount__c = orderObj.Paid_Amount__c+payment.Amount_Recevied__c;
                system.debug('amount received>>'+payment.Amount_Recevied__c);
                
                update orderObj;  
                
                 if(orderObj.Paid_Amount__c > 0)
                {
                List<Invoice__c> invoice=new List<Invoice__c>(); 
                     invoice = [Select id,name,Invoice_Status__c from Invoice__c where Work_Order__c =:orderObj.id];
                     if(invoice.size()>0)
                     {
                       if(orderObj.Is_Payment_Made__c != true)
                    {
                        invoice[0].Invoice_Status__c='Partially Paid';
                    }  
                    if(orderObj.Is_Payment_Made__c == true)
                    {
                        invoice[0].Invoice_Status__c='Paid';
                    }
                    if(invoice !=null)
                    {
                        update invoice;
                    }
                     }
                   
                }
                
               
                
                
                
                Order_Payment__c orderPaymentObj = new Order_Payment__c();
                orderPaymentObj.Work_Order__c = orderId;
                orderPaymentObj.Payment__c = payment.Id;   
                orderPaymentObj.Amount__c = chargeAmount;
                orderPaymentObj.Payment_Type__c = 'Charge';         
                orderPaymentObj.Payment_Status__c = 'Payment Success';
                
                upsert orderPaymentObj; 
                
               
                
            
        }
        catch(Exception ex)
        {
            createErrorLog.insertError('WOSavePaymentCntrl',ex.getMessage(),'Method -saveChequePayment ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
        } 
        return payment;
    }
    @AuraEnabled
    public static String fetchPaymentVendor(Id custId)
    {    
        String paymentVendor = '';      
        
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'Id','name','ParentId','Parent.type','Parent.sigmaerpdev__Payment_Vendor__c','Type'})  
          )  
        {*/
            try{ 
                
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
            catch(Exception ex)
            {
                createErrorLog.insertError('WOSavePaymentCntrl',ex.getMessage(),'Method -fetchPaymentVendor ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
            } 
            
        //}
        return paymentVendor;
        
    }
    
    
    
    
    @AuraEnabled
    public static String stripePayment(Payment__c payment,Decimal chargeAmount,String CVV, String expiryMonth, String expiryYear,String zipCode,Decimal paidAmount,String accountid)
    {   
        try{
           
                
                string temp;
                Work_Order__c orderObj;
                Id orderId = payment.Work_Order__c;  
               
                
                              
                
                
                orderObj = [Select Id,Name,sigmaerpdev2__Is_Payment_Made__c,Account__c,sigmaerpdev2__Account__r.Name,Account__r.Customer_Type__c,
                       sigmaerpdev2__Account__r.AccountNumber,sigmaerpdev2__Work_Type__c,Service_Warrenty_End_date__c,sigmaerpdev2__TotalAmount__c,sigmaerpdev2__Paid_Amount__c,
                       sigmaerpdev2__Work_Type__r.sigmaerpdev2__Service_Charge__c ,Sigma_orders__r.Total_Price__c,sigmaerpdev2__FFP_MR_Contact__c,Status__c,
                       sigmaerpdev2__Due_Amount__c,Net_Amount__c,Tax__c FROM sigmaerpdev2__Work_Order__c where Id =: orderId];          
                system.debug('orderObj >>'+orderObj);
            
                 Site_Visits__c site;
                 site=[select Work_Order__c from Site_Visits__c where Work_Order__c=:orderObj.id order by createdDate DESC limit 1];
                
                set<Id> prod=new set<Id>();
                List<sigmaerpdev2__Work_Oder_Lines__c> WOl;
                WOl=[Select Id,sigmaerpdev2__Product__c,sigmaerpdev2__Quantity__c,sigmaerpdev2__Price__c,
                sigmaerpdev2__Product__r.Name FROM sigmaerpdev2__Work_Oder_Lines__c where sigmaerpdev2__Work_Order__c=:orderId AND sigmaerpdev2__Used1__c = true];
                system.debug('WOl'+WOl);
                
                
         
                /*List<Sigma_Order__c> Sorder=new List<Sigma_Order__c>(); 
                Sorder = [Select id,name,Paid_Amount__c,Is_Payment_Made__c from Sigma_Order__c where Work_Order__c =:orderObj.id];
                system.debug('Sorder'+Sorder);
                if(Sorder.size() > 0)
                {                    
                    if(Sorder != null)
                    {
                        if(Sorder[0].Paid_Amount__c == null)
                        {
                            Sorder[0].Paid_Amount__c = 0;                    
                        }
                        Sorder[0].Paid_Amount__c=Sorder[0].Paid_Amount__c+payment.Amount_Recevied__c;
                        
                        if(Sorder[0].Paid_Amount__c >= orderObj.TotalAmount__c)
                        {
                            Sorder[0].Is_Payment_Made__c=true;
                        }
                        update Sorder;
                        system.debug('Sorder'+Sorder);
                        payment.Sigma_Order__c=Sorder[0].id;
                    }
                }else
                {  
                    Sigma_Order__c so=new Sigma_Order__c();
                    so.Work_Order__c=orderObj.id;   
                    so.Accountid__c=orderObj.Account__c;
                    so.Orders_Status__c= 'Delivered';
                    so.Order_Created_Via__c = 'Work Order';
                    so.Net_Amount__c=orderObj.Net_Amount__c;
                    so.TotalAmount__c=orderObj.TotalAmount__c;
                    so.Tax__c=orderObj.Tax__c;
                    if(so.Paid_Amount__c == null)
                    {
                        so.Paid_Amount__c = 0;
                        
                    }
                    so.Paid_Amount__c=so.Paid_Amount__c+payment.Amount_Recevied__c;
                    //so.Due_Amount__c=orderObj.Due_Amount__c;
                    so.Is_Payment_Made__c=orderObj.sigmaerpdev2__Is_Payment_Made__c;
                    insert so;
                    payment.Sigma_Order__c=so.id;
                    
                    Decimal amt;
                    for(sigmaerpdev2__Work_Oder_Lines__c woli: wol) {
                        prod.add(woli.sigmaerpdev2__Product__c);
                    }
         
         
                    List<PricebookEntry> prce =[Select Product2Id,UnitPrice From PricebookEntry WHERE PriceBook2.Name = 'Standard Price Book' and Product2.Id =:prod];
                    Decimal unitprice=0;
                    Map<Id,Decimal> uprice = new Map<Id,Decimal>();
                    for(PricebookEntry pbe: prce){
                        unitprice=pbe.UnitPrice;
                        uprice.put(pbe.Product2Id,UnitPrice);
                    }
                    for(sigmaerpdev2__Work_Oder_Lines__c woli: wol){                     
                        amt=uprice.get(woli.sigmaerpdev2__Product__c)*woli.sigmaerpdev2__Quantity__c;
                    }                               
                    for(sigmaerpdev2__Work_Oder_Lines__c woline:WOl){
                        Product_Order_Price_Book__c popb1=new Product_Order_Price_Book__c();
                        popb1.Sigma_Order__c=so.id;
                        popb1.Product__c=woline.Product__c;
                        popb1.Net_Quantity__c=woline.Quantity__c;
                        popb1.Total_Price__c=amt;
                        insert popb1;                               
                    }
                } */   //above section commented and moved to the end of this method     
                
                if(accountid != null && String.isNotEmpty(accountid))
                {
                    Map<String, String> properties;
                    Map<String, String> metadata;
                    List<Account> acc = new List<Account>();
                    
                    acc = [select id,stripeCustomerId__c,Currency_code__c from Account where id =:accountid limit 1];
                    
                    List<Payment__c> paymentList = new List<Payment__c>();
                    if(!acc.isEmpty() && acc[0].stripeCustomerId__c != null && acc[0].Currency_code__c != null)
                    {    
                        system.debug('inside if...934');
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
                            if ((Schema.sObjectType.Payment__c.isAccessible()) &&
                                (Schema.sObjectType.Payment__c.fields.Paid_Amount__c.isAccessible()) &&
                                (Schema.sObjectType.Payment__c.fields.Amount_Recevied__c.isAccessible()) &&
                                (Schema.sObjectType.Payment__c.fields.Paid_Amount__c.isCreateable()) &&
                                (Schema.sObjectType.Payment__c.fields.Paid_Amount__c.isUpdateable()))
                            {
                                if(payment.Paid_Amount__c == null)
                                {
                                    payment.Paid_Amount__c = 0;
                                }
                                payment.Paid_Amount__c = payment.Paid_Amount__c + payment.Amount_Recevied__c;
                                system.debug('Paid_Amount__c::'+payment.Paid_Amount__c);
                                payment.SFDC_Account__c=accountid;
                               
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
                            if ((Schema.sObjectType.Payment__c.isAccessible()) &&
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
                            system.debug('paymentList===='+paymentList);
                            /*temp = savePaymentDetails(payment,orderId,payment.Id);
                            return temp;*/
                        }
                    }                                                                                
                    else if(!acc.isEmpty() && acc[0].stripeCustomerId__c == null && acc[0].Currency_code__c != null)
                    {
                        system.debug('inside elsse...1024');
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
                                        payment.SFDC_Account__c=accountid;
                                        
                                        
                                    }
                                    if ((Schema.sObjectType.Payment__c.isAccessible()) &&
                                        (Schema.sObjectType.Payment__c.fields.PayPal_Transaction_Id__c.isAccessible()) &&
                                        (Schema.sObjectType.Payment__c.fields.PayPal_Transaction_Id__c.isCreateable()) &&
                                        (Schema.sObjectType.Payment__c.fields.PayPal_Transaction_Id__c.isUpdateable()))
                                    {
                                        if(!test.isrunningtest())
                                            payment.PayPal_Transaction_Id__c = sc.balance_transaction; 
                                        
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
                                    system.debug('paymentList=====1133==='+paymentList);      
                                    //temp = savePaymentDetails(payment,orderId,payment.Id);
                                    
                                    if(orderObj.Account__r.Customer_Type__c=='Credit Customer'){
                                        if(orderObj.Status__c =='Completed'||orderObj.Status__c =='Another Visit Needed'){             
                                            Dimension_Tag__c dimTag;
                                            try{
                                                dimTag=[select id,Paid_Amount__c from Dimension_Tag__c where Account__c=:orderObj.Account__c limit 1];
                                            }
                                            catch(Exception e){
                                                
                                            }
                                
                                            if(dimTag!=null){
                                                if(dimTag.Paid_Amount__c==null)
                                                    dimTag.Paid_Amount__c=0;
                                                if(payment.Paid_Amount__c>0)
                                                    dimTag.Paid_Amount__c+=payment.Paid_Amount__c;
                                                update dimTag;
                                                System.debug('dimTag::'+dimTag);
                                            }        
                                        }
                                    }
                                    
                                    if(payment.Status__c == 'Completed')
                                    {
                                        orderObj.Is_Payment_Made__c = true;
                                    }
                                    else
                                    {
                                        orderObj.Is_Payment_Made__c = false;
                                    }
                                                                       
                                    
                                    if(payment.Amount_Recevied__c == null)
                                    {
                                        payment.Amount_Recevied__c = 0;
                                    }
                                    if(orderObj.Paid_Amount__c == null){
                                    orderObj.Paid_Amount__c = 0;
                                    }
                                    orderObj.Paid_Amount__c = orderObj.Paid_Amount__c+payment.Amount_Recevied__c;
                                    system.debug('amount received>>'+payment.Amount_Recevied__c);
                                    update orderObj;  
                                    system.debug('orderObj>>'+orderObj);  
                                    
                                     if(orderObj.Paid_Amount__c > 0)
                {
                List<Invoice__c> invoice=new List<Invoice__c>(); 
                     invoice = [Select id,name,Invoice_Status__c from Invoice__c where Work_Order__c =:orderObj.id];
                     if(invoice.size()>0)
                     {	
                         if(orderObj.Is_Payment_Made__c != true)
                    {
                        invoice[0].Invoice_Status__c='Partially Paid';
                    }
                    if(orderObj.Is_Payment_Made__c == true)
                    {
                        invoice[0].Invoice_Status__c='Paid';
                    }
                    if(invoice !=null)
                    {
                        update invoice;
                    }
                     }
                   
                }
                                    
                                    Order_Payment__c orderPaymentObj = new Order_Payment__c();
                                    orderPaymentObj.Work_Order__c = orderId;
                                    orderPaymentObj.Payment__c = payment.Id;   
                                    orderPaymentObj.Amount__c = chargeAmount;
                                    orderPaymentObj.Payment_Type__c = 'Charge';         
                                    orderPaymentObj.Payment_Status__c = 'Payment Success';
                                    
                                    upsert orderPaymentObj;  
                                    
                                    //return temp;
                                }
                                
                            }
                        }
                    }
                }
                
                //new section added here to fix callout error
                List<Sigma_Order__c> Sorder = new List<Sigma_Order__c>(); 
                Sorder = [Select id,name,AccountId__c,Paid_Amount__c,TotalAmount__c,Is_Payment_Made__c from Sigma_Order__c  where Site_Visits__c =:site.id];
                system.debug('Sorder'+Sorder);
                if(Sorder.size() > 0)
                {   
                    system.debug('inside if....1232');
                    if(Sorder != null)
                    {
                        if(Sorder[0].Paid_Amount__c == null)
                        {
                            Sorder[0].Paid_Amount__c = 0;                    
                        }
                      /*  Sorder[0].Delivary_Date__c=System.today();
                        Sorder[0].Orders_Status__c= 'Delivered';
                        Sorder[0].Net_Amount__c=orderObj.Net_Amount__c;
                        Sorder[0].TotalAmount__c=orderObj.TotalAmount__c;
                        Sorder[0].Tax__c=orderObj.Tax__c;*/
                        Sorder[0].Paid_Amount__c=Sorder[0].Paid_Amount__c+payment.Amount_Recevied__c;
                        
                        if(Sorder[0].Paid_Amount__c >= orderObj.TotalAmount__c)
                        {
                            Sorder[0].Is_Payment_Made__c=true;
                        }
                        update Sorder;
                        system.debug('Sorder'+Sorder);
                        payment.Sigma_Order__c=Sorder[0].id;
                        
                        update payment; //added newly on 3/9/2020
                    }
                } 
                   if(Sorder[0].Paid_Amount__c > 0)
               {
                   system.debug('Sorder[0].id>>>'+Sorder[0].id);
                   List<Invoice__c> invoice=new List<Invoice__c>(); 
                     invoice = [Select id,name,Invoice_Status__c from Invoice__c where SO__c =:Sorder[0].id];
                     if(invoice.size()>0)
                     {
                          if(Sorder[0].Is_Payment_Made__c!=true)
                    {
                        invoice[0].Invoice_Status__c='Partially Paid';
                    }
                    if(Sorder[0].Is_Payment_Made__c==true)
                    {
                        invoice[0].Invoice_Status__c='Paid';
                    }
                    if(invoice !=null)
                    {
                        update invoice;
                    }
                     }
                    
               }
               
                
                
                //return is moved to the end
                temp = savePaymentDetails(payment,orderId,payment.Id);
                return temp;
                // ends here           
            
        }
        catch(Exception ex)
        {
            createErrorLog.insertError('WOSavePaymentCntrl',ex.getMessage(),'Method -stripePayment ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
            return null;
        }
        //return null; //added by samad
    }
    
    
    @AuraEnabled
    public static string savePaymentDetails(Payment__c payment, Id orderId,Id paymentId){       
        try{
           Double chargeAmount = payment.Amount__c;
           
                Work_Order__c orderObj;
                
                
                orderObj = [Select Id,Name,sigmaerpdev2__Is_Payment_Made__c,sigmaerpdev2__Account__r.Name,
                       sigmaerpdev2__Account__r.AccountNumber,sigmaerpdev2__Work_Type__c,Service_Warrenty_End_date__c,sigmaerpdev2__TotalAmount__c,sigmaerpdev2__Paid_Amount__c,
                       sigmaerpdev2__Work_Type__r.sigmaerpdev2__Service_Charge__c ,Sigma_orders__r.Total_Price__c,sigmaerpdev2__FFP_MR_Contact__c,Status__c,
                       sigmaerpdev2__Due_Amount__c,Net_Amount__c FROM sigmaerpdev2__Work_Order__c where Id =: orderId];     
                system.Debug('orderObj>>'+orderObj);
                
                
                
                
                
                if(payment.Status__c == 'Completed')
                {
                    orderObj.Is_Payment_Made__c = true;
                }
                else
                {
                    orderObj.Is_Payment_Made__c = false;
                }
               
                
                if(payment.Amount_Recevied__c == null)
                {
                    payment.Amount_Recevied__c = 0;
                }
                if(orderObj.Paid_Amount__c == null){
                    orderObj.Paid_Amount__c = 0;
                }
                orderObj.Paid_Amount__c = orderObj.Paid_Amount__c+payment.Amount_Recevied__c;
                system.Debug('orderObj1>>'+orderObj.Paid_Amount__c );
               // update orderObj;     
              
                
                Order_Payment__c orderPaymentObj = new Order_Payment__c();
                orderPaymentObj.Work_Order__c = orderId;
                orderPaymentObj.Payment__c = paymentId; 
                orderPaymentObj.Amount__c = chargeAmount;
                orderPaymentObj.Payment_Type__c = 'Charge';                 
                orderPaymentObj.Payment_Status__c = 'Payment Success'; 
                
                
                upsert orderPaymentObj;  
            
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
    
    
    
          
}