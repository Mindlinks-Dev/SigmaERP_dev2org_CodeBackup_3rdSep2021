public without sharing class SavePaymentCntrl
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
    public static Payment__c saveCashPayment(Payment__c payment, String regid)
    {
        
        try{
            system.debug('regid>>>'+regid);
            system.debug('payment>>>'+payment);
            
            /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Account_Subscription_Intervals__c')
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Time_Base_Inventory__c')
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Payment__c') 
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Dimension_Tag__c') 
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Payment__c')  
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')  
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Invoice__c')
&&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Payment__c',new set<String>{'id','name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Amount__c','sigmaerpdev__SFDC_Account__c','sigmaerpdev__Amount_Recevied__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Payment_Time__c'}) 
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'sigmaerpdev__Status__c','sigmaerpdev__AccountId__c','sigmaerpdev__Customer_Type__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Total_Payable_Amount__c','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Quantity__c','sigmaerpdev__Account_Subscription_Interval__c','sigmaerpdev__Due_Amount__c','sigmaerpdev__TotalAmount__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Account_Subscription_Interval__r.Name'})              
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'id','sigmaerpdev__Sigma_Order__r.Id','sigmaerpdev__Stock_Fulfilled__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Auto_Allocate__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Product__c','sigmaerpdev__Product__r.name','sigmaerpdev__IsInventoryUpdated__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Customer_Type__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.name','createddate','sigmaerpdev__Sigma_Order__r.sigmaerpdev__AccountId__r.name','sigmaerpdev__Back_Order__c','sigmaerpdev__Total_Price__c','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Splited_Order_Line__c'})
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Account_Subscription_Intervals__c',new set<String>{'Id','Name','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Usage_Type__c','sigmaerpdev__Payment_Status__c','sigmaerpdev__Order_Status__c'}) 
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Time_Base_Inventory__c',new set<String>{'Id','name','sigmaerpdev__Order__c','sigmaerpdev__Proposal_to_Order__c'})
&&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new set<String>{'sigmaerpdev__Auto_Reserve_Stock__c'})
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Dimension_Tag__c',new set<String>{'id','sigmaerpdev__Base_Credit_Limit__c','sigmaerpdev__Ordered_Amount__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Account__c'})
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Invoice__c',new set<String>{'id','name','sigmaerpdev__Invoice_Status__c','sigmaerpdev__SO__c'})
&&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Payment__c',new set<String>{'sigmaerpdev__Payment_Time__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Amount_Recevied__c','sigmaerpdev__Amount__c','sigmaerpdev__Status__c','sigmaerpdev__Customer_SFID__c','sigmaerpdev__SFDC_Account__c','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Account_Subscription_Interval__c'}) 
&& CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sigma_Order__c',new set<String>{'sigmaerpdev__Status__c','sigmaerpdev__Is_Payment_Made__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Paid_Amount__c'}) 
&& CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Account_Subscription_Intervals__c',new set<String>{'sigmaerpdev__Payment_Status__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Payment__c'}) 
&& CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Order_Price_Book__c', new set<String>{'sigmaerpdev__Order_Status__c'}) 
&&Schema.sObjectType.Order_Payment__c.fields.name.isAccessible()
&&Schema.sObjectType.Order_Payment__c.fields.name.isAccessible()
&&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Order_Payment__c',new set<String>{'sigmaerpdev__Sigma_Order__c','sigmaerpdev__Payment__c','sigmaerpdev__Amount__c','sigmaerpdev__Payment_Type__c','sigmaerpdev__Payment_Status__c','sigmaerpdev__Quantity__c'})
&&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Dimension_Tag__c',new set<String>{'sigmaerpdev__Paid_Amount__c'})
&&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Invoice__c',new set<String>{'sigmaerpdev__Invoice_Status__c'})           
)
{ */
            
            //code added by rashmi to update ASI object paid and amount Received feilds on 12-07-2019
            Sigma_Order__c orderObj;
            Account_Subscription_Intervals__c accsub;
            Dimension_Tag__c DT;
            
            Id orderId = payment.Sigma_Order__c;  
            Id paymentId = payment.Id;
            Double chargeAmount = payment.Amount__c;               
            
            List<Product_Order_Price_Book__c> orderLines =  new List<Product_Order_Price_Book__c>();
            List<Product_Order_Price_Book__c> allocatedorderLines =  new List<Product_Order_Price_Book__c>();
            orderObj = [select Status__c,AccountId__c,Customer_Type__c,Orders_Status__c,Total_Payable_Amount__c,Order_Created_Via__c,Quantity__c,Account_Subscription_Interval__c,Due_Amount__c,TotalAmount__c ,Paid_Amount__c,Account_Subscription_Interval__r.Name,Work_Order__c from Sigma_Order__c where Id =: orderId];       
            
            //check autostock reserve is true 
            Default_Parameters__c autostockreserve = [select Auto_Reserve_Stock__c from Default_Parameters__c limit 1];
            
            
            
            datetime pmntDateTime = datetime.now();
            payment.Payment_Time__c = pmntDateTime; 
            system.debug('amount received'+payment.Amount_Recevied__c);
            if(payment.Paid_Amount__c == null)
            {
                payment.Paid_Amount__c = 0;
                
            }
            payment.Paid_Amount__c = payment.Paid_Amount__c+payment.Amount_Recevied__c;
            
            //code to update Account sub Status on 12-07-2019
            if(orderObj.Account_Subscription_Interval__c!= null)
            {
                accsub=[select Name,Paid_Amount__c,Usage_Type__c,Payment_Status__c,Order_Status__c,next_Billing_Amount__c from Account_Subscription_Intervals__c where Id =: orderObj.Account_Subscription_Interval__c ];//and  id =:payment.Account_Subscription_Interval__c
                
                //code Added isolate OrderLine's Order_Status__c field on Nov-16
                if(accsub.Payment_Status__c=='Not Paid' && accsub.Usage_Type__c=='Product')
                {
                    //code added by rashmi to update ASI object paid and amount Received feilds on 12-07-2019
                    if(accsub.Paid_Amount__c ==null)
                    {
                        accsub.Paid_Amount__c = 0; 
                        accsub.Order_Status__c='Pending';
                    }
                    accsub.Paid_Amount__c = accsub.Paid_Amount__c+payment.Amount_Recevied__c;
                    system.debug('Paid amount>>'+accsub.Paid_Amount__c );
                    system.debug('amount receved>>'+payment.Amount_Recevied__c);
                }
                else if(accsub.Payment_Status__c=='Partial Paid' && accsub.Usage_Type__c=='Product')
                {
                    if(accsub.Paid_Amount__c ==null)
                    {
                        accsub.Paid_Amount__c = 0;
                        accsub.Order_Status__c='Pending';
                    }
                    accsub.Paid_Amount__c = accsub.Paid_Amount__c+payment.Amount_Recevied__c;
                    
                }
                
                if(accsub.Payment_Status__c=='Not Paid' && accsub.Usage_Type__c!='Product')
                    
                {
                    if(accsub.Paid_Amount__c ==null)
                    {
                        accsub.Paid_Amount__c = 0;  
                        accsub.Order_Status__c='Pending';
                    }
                    accsub.Paid_Amount__c = accsub.Paid_Amount__c+payment.Amount_Recevied__c;
                    system.debug('Paid amount>>'+accsub.Paid_Amount__c );
                    system.debug('amount receved>>'+payment.Amount_Recevied__c);
                }
                else if(accsub.Payment_Status__c=='Partial Paid' && accsub.Usage_Type__c!='Product')
                    
                {
                    if(accsub.Paid_Amount__c ==null)
                    {
                        accsub.Paid_Amount__c = 0; 
                        accsub.Order_Status__c='Pending';
                    }
                    accsub.Paid_Amount__c = accsub.Paid_Amount__c+payment.Amount_Recevied__c;
                }
            }
            
            if(payment.Amount__c <= payment.Paid_Amount__c)
            {
                payment.Status__c = 'Completed';
                if(orderObj.Order_Created_Via__c == 'Subscription' )
                {
                    accsub.Payment_Status__c = 'Paid';
                    accsub.Order_Status__c='Order Confirmed';
                    payment.Order_Created_Via__c='Subscription';
                    payment.Account_Subscription_Interval__c = accsub.id;
                }
            }
            else
            {
                payment.Status__c = 'Partial Paid';
                if(orderObj.Order_Created_Via__c == 'Subscription' )
                {
                    accsub.Payment_Status__c = 'Partial Paid';
                    accsub.Order_Status__c='Order Confirmed';
                    payment.Order_Created_Via__c='Subscription';
                    payment.Account_Subscription_Interval__c = accsub.id;
                }
            }
            Id custId = payment.SFDC_Account__c;
            payment.Customer_SFID__c = custId;
            
            insert payment;     
            
            
            orderObj.Status__c = 'Draft';
            if(payment.Status__c == 'Completed')
            {
                orderObj.Is_Payment_Made__c = true;
            }
            else
            {
                orderObj.Is_Payment_Made__c = false;
            }
            
            
            if(regid!=null){
                sigmaerpdev2__Brewery_Registry__c Br;
                Br=[select Id,Name,sigmaerpdev2__Payment_Status__c from sigmaerpdev2__Brewery_Registry__c where Id =: regid];
                system.debug('B>r'+Br);
                Br.sigmaerpdev2__Payment_Status__c='Completed';
                update Br;
                
            }
            
            
            orderObj.Orders_Status__c = 'Order Confirmed'; 
            
            if(payment.Amount_Recevied__c == null)
            {
                payment.Amount_Recevied__c = 0;
            }
            orderObj.Paid_Amount__c = orderObj.Paid_Amount__c+payment.Amount_Recevied__c;
            system.debug('amount received>>'+payment.Amount_Recevied__c);
            update orderObj;    
            
            if(orderObj.Order_Created_Via__c == 'Subscription' )
            {
                //accsub.Order_Status__c='Order Confirmed';
                //accsub.Id = payment.Account_Subscription_Interval__c; 
                accsub.Payment__c=payment.id;
                update accsub;
                system.debug('accsub>>>>'+accsub);
            }
            //Code ends here to update ASI on 12-07-2019
            
            orderLines = [select id,Sigma_Order__r.Id,Splited_Order_Line__c,Stock_Fulfilled__c,Sigma_Order__r.Auto_Allocate__c,Order_Status__c,Product__c,Product__r.name,Product__r.Product_Price__c,IsInventoryUpdated__c,Sigma_Order__r.Customer_Type__c,Sigma_Order__c,Sigma_Order__r.name,createddate,Sigma_Order__r.AccountId__r.name,Back_Order__c,Total_Price__c,Net_Quantity__c,Sigma_Order__r.No_Picking_Package_Shipment_Required__c,Is_Credit_Updated__c,Inventory_Status__c,Sigma_Order__r.Payment__r.Paid_Amount__c,Sigma_Order__r.Order_Created_Via__c from Product_Order_Price_Book__c where Sigma_Order__r.Id = :orderId];
            List<Product_Order_Price_Book__c> allocateorderline = new  List<Product_Order_Price_Book__c>();
            for(Product_Order_Price_Book__c orderline :orderLines )
            {
                if(!orderline.IsInventoryUpdated__c)
                {
                    allocateorderline.add(orderline);
                }
            }
            Decimal Amounttoupdate =0;
            //code added by anuja
            //Time_Base_Inventory__c TBI;
            //TBI=[select Order__c,Proposal_to_Order__c from Time_Base_Inventory__c];
            Boolean Execute;
            
            // if(TBI.Order__c ==true || TBI.Proposal_to_Order__c ==true)
            
            
            
            for(Product_Order_Price_Book__c temp :orderLines ){
                if(!temp.Splited_Order_Line__c && (temp.Order_Status__c =='Pending' ||temp.Order_Status__c =='Submitted'))
                {
                    temp.Order_Status__c = 'Order Confirmed';
                    if(temp.Sigma_Order__r.Customer_Type__c == 'Credit Customer')
                    {
                        Amounttoupdate += temp.Total_Price__c;
                        temp.Is_Credit_Updated__c =true;
                    }
                    
                }
                
                if(temp.Stock_Fulfilled__c == true && temp.IsInventoryUpdated__c ==false && temp.Order_Status__c == 'Order Confirmed' && (temp.Sigma_Order__r.Auto_Allocate__c ||temp.Inventory_Status__c =='Allocated'))
                {
                    allocatedorderLines.add(temp);
                }
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
            
            if(allocateorderline.size()>0)
            {
                if(orderObj.Order_Created_Via__c == 'Time Based Inventory')
                {
                    system.debug('innn>>');
                    Execute = AllocateInventoryCntrl.AllocateInventoryforOrder(allocateorderline);
                }
            }
            //code to update credit user details
            if(orderObj.Customer_Type__c == 'Credit Customer' )//|| orderObj.Order_Created_Via__c == 'Subscription'
            {   
                DT = [select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: orderObj.AccountId__c limit 1 ];
                
                if(DT.Paid_Amount__c == null)
                    DT.Paid_Amount__c =0;
                DT.Paid_Amount__c = DT.Paid_Amount__c + payment.Amount_Recevied__c;
                if(Amounttoupdate >0)
                    DT.Ordered_Amount__c +=Amounttoupdate;
                update DT;
                system.debug('DT>>'+DT);
            }
            
            //handle invoice status after payment 13-03-2020
            if(orderObj.Order_Created_Via__c == 'POS'||orderObj.Order_Created_Via__c == 'Service Quote'||orderObj.Order_Created_Via__c == 'Work Order')
            {
                system.debug('orderObj.id>>>'+orderObj.id);
                List<Invoice__c> invoice=new List<Invoice__c>(); 
                invoice = [Select id,name,Invoice_Status__c from Invoice__c where SO__c =:orderObj.id];
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
                    invoice1.SO__c = orderObj.id; 
                    invoice1.Invoice_Type__c='Sales Invoice';
                    invoice1.Customer__c =orderObj.AccountId__c; 
                    
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
                    for(Product_Order_Price_Book__c orderline : orderLines)
                    {
                        Invoice_Item__c invoicedata = new Invoice_Item__c();
                        invoicedata.Invoice_Number__c=invoice1.id;
                        invoicedata.SOI__c=orderline.id;
                        invoicedata.Quantity__c = orderline.Net_Quantity__c;
                        invoicedata.Total_Amount__c=orderline.Total_Price__c;
                        invoicedata.Product__c=orderline.Product__c;
                        invoicedata.Net_Amount__c = orderline.Product__r.Product_Price__c;
                        if(orderline.Discounts__c!=null && orderline.Discounts__c>0)
                            invoicedata.Discount__c = orderline.Discounts__c;
                        Invoiceitem.add(invoicedata);
                    }
                    if(Invoiceitem.size()>0)
                        insert Invoiceitem;
                }
            }
            
            if(orderObj.Order_Created_Via__c == 'Work Order')
            {
                system.debug('orderObj.id>>>'+orderObj.id);
                List<Invoice__c> invoice=new List<Invoice__c>(); 
                invoice = [Select id,name,Invoice_Status__c from Invoice__c where SO__c =:orderObj.id];
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
                    invoice1.SO__c = orderObj.id; 
                    invoice1.Work_Order__c=orderObj.Work_Order__c;
                    invoice1.Invoice_Type__c='Work order Invoice';
                    invoice1.Customer__c =orderObj.AccountId__c; 
                    invoice1.Total_Amounts__c=orderObj.TotalAmount__c;
                    
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
                    
                    
                }
            }
            
            
            if(allocatedorderLines.size()>0 && orderObj.Order_Created_Via__c != 'Time Based Inventory')
            {
                system.debug('inautostock');
                autostockreservation.autostockreserve(allocatedorderLines);
                
            }
            // }
        }
        catch(Exception ex)
        {
            createErrorLog.insertError('SavePaymentCntrl',ex.getMessage(),'Method -saveCashPayment ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
        }  
        return payment; // added by samad
    }
    
    @AuraEnabled
    public static Payment__c saveChequePayment(Payment__c payment,String regid)
    {
        try{
            /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Account_Subscription_Intervals__c')
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Time_Base_Inventory__c')
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Payment__c') 
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Dimension_Tag__c') 
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Payment__c')  
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Invoice__c')
&&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Payment__c',new set<String>{'id','name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Amount__c','sigmaerpdev__SFDC_Account__c','sigmaerpdev__Amount_Recevied__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Payment_Time__c'}) 
&&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'sigmaerpdev__Status__c','sigmaerpdev__AccountId__c','sigmaerpdev__Customer_Type__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Total_Payable_Amount__c','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Quantity__c','sigmaerpdev__Account_Subscription_Interval__c','sigmaerpdev__Due_Amount__c','sigmaerpdev__TotalAmount__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Account_Subscription_Interval__r.Name'})              
&&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'id','sigmaerpdev__Sigma_Order__r.Id','sigmaerpdev__Stock_Fulfilled__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Auto_Allocate__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Product__c','sigmaerpdev__Product__r.name','sigmaerpdev__IsInventoryUpdated__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Customer_Type__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.name','createddate','sigmaerpdev__Sigma_Order__r.sigmaerpdev__AccountId__r.name','sigmaerpdev__Back_Order__c','sigmaerpdev__Total_Price__c','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Splited_Order_Line__c'})
&&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Account_Subscription_Intervals__c',new set<String>{'Id','Name','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Usage_Type__c','sigmaerpdev__Payment_Status__c','sigmaerpdev__Order_Status__c'}) 
&&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Time_Base_Inventory__c',new set<String>{'Id','name','sigmaerpdev__Order__c','sigmaerpdev__Proposal_to_Order__c'})
&&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new set<String>{'sigmaerpdev__Auto_Reserve_Stock__c'})
&&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Dimension_Tag__c',new set<String>{'id','sigmaerpdev__Base_Credit_Limit__c','sigmaerpdev__Ordered_Amount__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Account__c'})
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Invoice__c',new set<String>{'id','name','sigmaerpdev__Invoice_Status__c','sigmaerpdev__SO__c'})
&&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Payment__c',new set<String>{'sigmaerpdev__Payment_Time__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Amount_Recevied__c','sigmaerpdev__Amount__c','sigmaerpdev__Status__c','sigmaerpdev__Customer_SFID__c','sigmaerpdev__SFDC_Account__c','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Account_Subscription_Interval__c'}) 
&&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sigma_Order__c',new set<String>{'sigmaerpdev__Status__c','sigmaerpdev__Is_Payment_Made__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Paid_Amount__c'}) 
&&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Account_Subscription_Intervals__c',new set<String>{'sigmaerpdev__Payment_Status__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Payment__c'}) 
&&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Order_Price_Book__c', new set<String>{'sigmaerpdev__Order_Status__c'}) 
&&Schema.sObjectType.Order_Payment__c.fields.name.isAccessible()
&&Schema.sObjectType.Order_Payment__c.fields.name.isAccessible()
&&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Order_Payment__c',new set<String>{'sigmaerpdev__Sigma_Order__c','sigmaerpdev__Payment__c','sigmaerpdev__Amount__c','sigmaerpdev__Payment_Type__c','sigmaerpdev__Payment_Status__c','sigmaerpdev__Quantity__c'})
&&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Dimension_Tag__c',new set<String>{'sigmaerpdev__Paid_Amount__c'})                                                      
&&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Invoice__c',new set<String>{'sigmaerpdev__Invoice_Status__c'})            
) 
{ */
            system.debug('payment1-->>>'+payment);
            system.debug('payment2-->>>'+payment.Sigma_Order__c);
            system.debug('payment3-->>>'+payment.Id);
            Sigma_Order__c orderObj;
            Account_Subscription_Intervals__c accsub;
            Dimension_Tag__c DT;
            List<Product_Order_Price_Book__c> allocatedorderLines =  new List<Product_Order_Price_Book__c>();
            
            Id orderId = payment.Sigma_Order__c;  
            Id paymentId = payment.Id;
            Double chargeAmount = payment.Amount__c;               
            
            //check autostock reserve is true 
            Default_Parameters__c autostockreserve = [select Auto_Reserve_Stock__c from Default_Parameters__c limit 1];
            
            
            List<Product_Order_Price_Book__c> orderLines =  new List<Product_Order_Price_Book__c>();
            orderObj = [select Status__c,AccountId__c,Customer_Type__c,Total_Payable_Amount__c,Orders_Status__c,Order_Created_Via__c,Quantity__c,Account_Subscription_Interval__c,Due_Amount__c,TotalAmount__c ,Paid_Amount__c,Account_Subscription_Interval__r.Name from Sigma_Order__c where Id =: orderId];       
            
            datetime pmntDateTime = datetime.now();             
            payment.Payment_Time__c = pmntDateTime;
            system.debug('amount received'+payment.Amount_Recevied__c);
            
            if(payment.Paid_Amount__c == null)
            {
                payment.Paid_Amount__c = 0;
            }
            
            payment.Paid_Amount__c = payment.Paid_Amount__c+payment.Amount_Recevied__c;
            
            //code added by rashmi to update ASI object paid and amount Received feilds on 12-07-2019
            if(orderObj.Account_Subscription_Interval__c!= null)
            {
                accsub=[select Name,Paid_Amount__c,Usage_Type__c,Payment_Status__c,Order_Status__c from Account_Subscription_Intervals__c where Id =: orderObj.Account_Subscription_Interval__c ];//and  id =:payment.Account_Subscription_Interval__c
                
                //code Added isolate OrderLine's Order_Status__c field on Nov-16
                if(accsub.Payment_Status__c=='Not Paid' && accsub.Usage_Type__c=='Product')
                {
                    if(accsub.Paid_Amount__c ==null)
                    {
                        accsub.Paid_Amount__c = 0;   
                        accsub.Order_Status__c='Pending';
                    }
                    accsub.Paid_Amount__c = accsub.Paid_Amount__c+payment.Amount_Recevied__c;
                    system.debug('Paid amount>>'+accsub.Paid_Amount__c );
                    system.debug('amount receved>>'+payment.Amount_Recevied__c);
                }
                else if(accsub.Payment_Status__c=='Partial Paid' && accsub.Usage_Type__c=='Product')
                {
                    if(accsub.Paid_Amount__c ==null)
                    {
                        accsub.Paid_Amount__c = 0; 
                        accsub.Order_Status__c='Pending';
                    }
                    accsub.Paid_Amount__c = accsub.Paid_Amount__c+payment.Amount_Recevied__c;
                    
                }
                if(accsub.Payment_Status__c=='Not Paid' && accsub.Usage_Type__c!='Product')
                {
                    if(accsub.Paid_Amount__c ==null)
                    {
                        accsub.Paid_Amount__c = 0;
                        accsub.Order_Status__c='Pending';
                    }
                    accsub.Paid_Amount__c = accsub.Paid_Amount__c+payment.Amount_Recevied__c;
                    system.debug('Paid amount>>'+accsub.Paid_Amount__c );
                    system.debug('amount receved>>'+payment.Amount_Recevied__c);
                }
                else if(accsub.Payment_Status__c=='Partial Paid' && accsub.Usage_Type__c!='Product')
                    
                {
                    if(accsub.Paid_Amount__c ==null)
                    {
                        accsub.Paid_Amount__c = 0;
                        accsub.Order_Status__c='Pending';
                    }
                    accsub.Paid_Amount__c = accsub.Paid_Amount__c+payment.Amount_Recevied__c;
                }
                
            }
            system.debug('payment.Amount__c-->>'+payment.Amount__c);
            system.debug('payment.Paid_Amount__c-->>>'+payment.Paid_Amount__c);
            if(payment.Amount__c <= payment.Paid_Amount__c)
            {
                payment.Status__c = 'Completed';
                if(orderObj.Order_Created_Via__c == 'Subscription' )
                {
                    accsub.Payment_Status__c = 'Paid';
                    accsub.Order_Status__c='Order Confirmed';
                    payment.Order_Created_Via__c='Subscription';
                    payment.Account_Subscription_Interval__c = accsub.id;
                }
            }
            else
            {
                payment.Status__c = 'Partial Paid';
                if(orderObj.Order_Created_Via__c == 'Subscription' )
                {
                    accsub.Payment_Status__c = 'Partial Paid';
                    accsub.Order_Status__c='Order Confirmed';
                    payment.Order_Created_Via__c='Subscription';
                    payment.Account_Subscription_Interval__c = accsub.id;
                }
            }
            
            Id custId = payment.SFDC_Account__c;
            payment.Customer_SFID__c = custId;
            
            insert payment;
            
            orderObj.Status__c = 'Draft';
            if(payment.Status__c == 'Completed')
            {
                orderObj.Is_Payment_Made__c = true;
            }
            else
            {
                orderObj.Is_Payment_Made__c = false;
            }
            
            if(regid!=null){
                sigmaerpdev2__Brewery_Registry__c Br;
                Br=[select Id,Name,sigmaerpdev2__Payment_Status__c from sigmaerpdev2__Brewery_Registry__c where Id =: regid];
                system.debug('B>r'+Br);
                Br.sigmaerpdev2__Payment_Status__c='Completed';
                update Br;
                
            }
            orderObj.Orders_Status__c = 'Order Confirmed'; 
            
            if(payment.Amount_Recevied__c == null)
            {
                payment.Amount_Recevied__c = 0;
            }
            orderObj.Paid_Amount__c = orderObj.Paid_Amount__c+payment.Amount_Recevied__c;
            system.debug('amount received>>'+payment.Amount_Recevied__c);
            
            update orderObj;  
            
            if(orderObj.Order_Created_Via__c == 'Subscription' )
            {
                //accsub.Order_Status__c='Confirm';
                //accsub.Id = payment.Account_Subscription_Interval__c; 
                accsub.Payment__c=payment.id;
                update accsub;
            }
            //Code ends here to update ASI on 12-07-2019
            
            
            orderLines = [select id,Sigma_Order__r.Id,Splited_Order_Line__c,Sigma_Order__r.Auto_Allocate__c,Stock_Fulfilled__c,Order_Status__c,Product__c,Product__r.name,IsInventoryUpdated__c,Sigma_Order__r.Customer_Type__c,Sigma_Order__c,Sigma_Order__r.name,createddate,Sigma_Order__r.AccountId__r.name,Back_Order__c,Total_Price__c,Net_Quantity__c,Sigma_Order__r.No_Picking_Package_Shipment_Required__c,Is_Credit_Updated__c,Inventory_Status__c,Sigma_Order__r.Order_Created_Via__c from Product_Order_Price_Book__c where Sigma_Order__r.Id = :orderId];
            List<Product_Order_Price_Book__c> allocateorderline = new  List<Product_Order_Price_Book__c>();
            for(Product_Order_Price_Book__c orderline :orderLines )
            {
                if(!orderline.IsInventoryUpdated__c)
                {
                    allocateorderline.add(orderline);
                }
            }
            //code added by anuja
            // Time_Base_Inventory__c TBI;
            // TBI=[select Order__c,Proposal_to_Order__c from Time_Base_Inventory__c];
            Boolean Execute;
            Decimal Amounttoupdate = 0;
            
            // if(TBI.Order__c ==true ||TBI.Proposal_to_Order__c == true)
            
            for(Product_Order_Price_Book__c temp :orderLines ){
                
                if(!temp.Splited_Order_Line__c && (temp.Order_Status__c =='Pending'||temp.Order_Status__c =='Submitted'))
                {
                    temp.Order_Status__c = 'Order Confirmed';
                    if(temp.Sigma_Order__r.Customer_Type__c == 'Credit Customer')
                    {
                        Amounttoupdate += temp.Total_Price__c;
                        temp.Is_Credit_Updated__c =true;
                    }
                }
                
                if(temp.Stock_Fulfilled__c == true && temp.IsInventoryUpdated__c ==false && temp.Order_Status__c =='Order Confirmed' && (temp.Sigma_Order__r.Auto_Allocate__c ||temp.Inventory_Status__c =='Allocated') )
                {
                    allocatedorderLines.add(temp);
                }
                
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
            
            if(allocateorderline.size()>0)
            {
                if(orderObj.Order_Created_Via__c == 'Time Based Inventory' )
                {
                    Execute = AllocateInventoryCntrl.AllocateInventoryforOrder(allocateorderline);
                }
            }
            //code to update credit user details
            if(orderObj.Customer_Type__c == 'Credit Customer')// || orderObj.Order_Created_Via__c == 'Subscription'
            {   
                DT = [select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: orderObj.AccountId__c limit 1 ];
                
                if(DT.Paid_Amount__c == null)
                    DT.Paid_Amount__c =0;
                DT.Paid_Amount__c = DT.Paid_Amount__c + payment.Amount_Recevied__c;
                if(Amounttoupdate >0)
                    DT.Ordered_Amount__c +=Amounttoupdate; 
                update DT;
                system.debug('DT>>'+DT);
            }
            
            //handle invoice status after payment 13-03-2020
            /* if(orderObj.Order_Created_Via__c == 'POS')
{
Invoice__c invoice = [Select id,name,Invoice_Status__c from Invoice__c where SO__c =:orderObj.id];
if(orderObj.Orders_Status__c == 'Order Confirmed')
{
invoice.Invoice_Status__c='Paid';
}
if(invoice !=null)
{
update invoice;
}    
}*/
            
            
            if(allocatedorderLines.size()>0 && orderObj.Order_Created_Via__c != 'Time Based Inventory')
            {
                system.debug('inautostock');
                autostockreservation.autostockreserve(allocatedorderLines);
                
            }
            
            //}
        }
        catch(Exception ex)
        {
            createErrorLog.insertError('SavePaymentCntrl',ex.getMessage(),'Method -saveChequePayment ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
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
            system.debug('fetchPaymentVendor.custId>.'+custId);
            Account accObject ;
            
            accObject = [SELECT Id, ParentId, Parent.type, Parent.sigmaerpdev2__Payment_Vendor__c, Type FROM Account where Id=:custId];  
            system.debug('fetchPaymentVendor.accObject>.'+accObject);
            
            
            if(accObject.Parent.type!=null){
                
                if(accObject.Parent.type == 'Store')
                {
                    Account parentAcc;
                    
                    parentAcc = [SELECT Id, ParentId, Parent.type, Parent.sigmaerpdev2__Payment_Vendor__c, Type FROM Account where Id=:accObject.ParentId ];   
                    
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
            else{
                paymentVendor = 'Stripe';
            }   
            
        }
        catch(Exception ex)
        {
            //createErrorLog.insertError('SavePaymentCntrl',ex.getMessage(),'Method -fetchPaymentVendor ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
        } 
        
        //}
        return paymentVendor;
        
    }
    
    //new code added to stripe payment by chandana
    @AuraEnabled
    public static String stripePayment(Payment__c payment,Decimal chargeAmount,String CVV, String expiryMonth, String expiryYear,Decimal paidAmount,String accountid,String regid,String appointmentId)
    {   
        try{
            /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Account_Subscription_Intervals__c')
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Time_Base_Inventory__c')
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Payment__c') 
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Dimension_Tag__c') 
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Payment__c')  
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')
&&CRUD_FLS_CheckUtility.checkObjCRUD('Account') 
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Invoice__c')
&&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Payment__c',new set<String>{'id','name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Amount__c','sigmaerpdev__SFDC_Account__c','sigmaerpdev__Amount_Recevied__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Payment_Time__c'}) 
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'sigmaerpdev__Status__c','sigmaerpdev__AccountId__c','sigmaerpdev__Customer_Type__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Total_Payable_Amount__c','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Quantity__c','sigmaerpdev__Account_Subscription_Interval__c','sigmaerpdev__Due_Amount__c','sigmaerpdev__TotalAmount__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Account_Subscription_Interval__r.Name'})              
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'id','sigmaerpdev__Sigma_Order__r.Id','sigmaerpdev__Stock_Fulfilled__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Auto_Allocate__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Product__c','sigmaerpdev__Product__r.name','sigmaerpdev__IsInventoryUpdated__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Customer_Type__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.name','createddate','sigmaerpdev__Sigma_Order__r.sigmaerpdev__AccountId__r.name','sigmaerpdev__Back_Order__c','sigmaerpdev__Total_Price__c','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Splited_Order_Line__c'})
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Account_Subscription_Intervals__c',new set<String>{'Id','Name','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Usage_Type__c','sigmaerpdev__Payment_Status__c','sigmaerpdev__Order_Status__c'}) 
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Time_Base_Inventory__c',new set<String>{'Id','name','sigmaerpdev__Order__c','sigmaerpdev__Proposal_to_Order__c'})
&&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new set<String>{'sigmaerpdev__Auto_Reserve_Stock__c'})
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Dimension_Tag__c',new set<String>{'id','sigmaerpdev__Base_Credit_Limit__c','sigmaerpdev__Ordered_Amount__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Account__c'})
&& CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'id','sigmaerpdev__stripeCustomerId__c','sigmaerpdev__Currency_code__c'})
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Invoice__c',new set<String>{'id','name','sigmaerpdev__Invoice_Status__c','sigmaerpdev__SO__c'})
&&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Payment__c',new set<String>{'sigmaerpdev__Payment_Time__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Amount_Recevied__c','sigmaerpdev__Amount__c','sigmaerpdev__Status__c','sigmaerpdev__Customer_SFID__c','sigmaerpdev__SFDC_Account__c','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Account_Subscription_Interval__c','sigmaerpdev__Credit_CardNumber__c','sigmaerpdev__Charge_Id__c','sigmaerpdev__PayPal_Transaction_Id__c'}) 
&& CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sigma_Order__c',new set<String>{'sigmaerpdev__Status__c','sigmaerpdev__Is_Payment_Made__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Paid_Amount__c'}) 
&& CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Account_Subscription_Intervals__c',new set<String>{'sigmaerpdev__Payment_Status__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Payment__c'}) 
&& CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Order_Price_Book__c', new set<String>{'sigmaerpdev__Order_Status__c'}) 
&&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Order_Payment__c',new set<String>{'sigmaerpdev__Sigma_Order__c','sigmaerpdev__Payment__c','sigmaerpdev__Amount__c','sigmaerpdev__Payment_Type__c','sigmaerpdev__Payment_Status__c','sigmaerpdev__Quantity__c'})
&&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Dimension_Tag__c',new set<String>{'sigmaerpdev__Paid_Amount__c'})                                                      
&&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Invoice__c',new set<String>{'sigmaerpdev__Invoice_Status__c'})           

)
{ */
            system.debug('chargeAmount@@'+chargeAmount);
            system.debug('accid@@'+accountid);
            system.debug('cvv@@'+CVV);
            system.debug('expmnth@@'+expiryMonth);
            system.debug('expiryYear@@'+expiryYear);
            system.debug('rigID@@'+regid +' appointmentId:'+appointmentId);
            string temp;
            Sigma_Order__c orderObj;
            Account_Subscription_Intervals__c accsub;
            Dimension_Tag__c DT;
            Id orderId = payment.Sigma_Order__c;
            system.debug('orderId???'+orderId);
            Id paymentId = payment.Id;
            
            //  Double chargeAmount = payment.Amount__c;               
            
            List<Product_Order_Price_Book__c> allocatedorderLines =  new List<Product_Order_Price_Book__c>();
            List<Product_Order_Price_Book__c> orderLines =  new List<Product_Order_Price_Book__c>();
            //orderObj = [select id,Status__c,AccountId__c,Customer_Type__c,Total_Payable_Amount__c,Orders_Status__c,Order_Created_Via__c,Quantity__c,Account_Subscription_Interval__c,Due_Amount__c,TotalAmount__c ,Paid_Amount__c,Account_Subscription_Interval__r.Name,Brewer_Account__c from Sigma_Order__c where Id =: orderId];       
            orderObj = [select id,sigmaerpdev2__Status__c,sigmaerpdev2__AccountId__c,sigmaerpdev2__Customer_Type__c,sigmaerpdev2__Total_Payable_Amount__c,sigmaerpdev2__Orders_Status__c,sigmaerpdev2__Order_Created_Via__c,sigmaerpdev2__Quantity__c,sigmaerpdev2__Account_Subscription_Interval__c,sigmaerpdev2__Due_Amount__c,sigmaerpdev2__TotalAmount__c ,sigmaerpdev2__Paid_Amount__c,sigmaerpdev2__Account_Subscription_Interval__r.Name,sigmaerpdev2__Brewer_Account__c from sigmaerpdev2__Sigma_Order__c where Id =: orderId];
            system.debug('orderObj >>'+orderObj);
            
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
                            if(orderObj.Account_Subscription_Interval__c!= null)
                            {
                                accsub=[select Name,Paid_Amount__c,Usage_Type__c,Payment_Status__c,Order_Status__c from Account_Subscription_Intervals__c where Id =: orderObj.Account_Subscription_Interval__c ];//and  id =:payment.Account_Subscription_Interval__c
                                
                                //code Added isolate OrderLine's Order_Status__c field on Nov-16
                                if(accsub.Payment_Status__c=='Not Paid' && accsub.Usage_Type__c=='Product')
                                {
                                    if(accsub.Paid_Amount__c ==null)
                                    {
                                        accsub.Paid_Amount__c = 0; 
                                        accsub.Order_Status__c='Pending';
                                    }
                                    accsub.Paid_Amount__c = accsub.Paid_Amount__c+payment.Amount_Recevied__c;
                                    system.debug('Paid amount>>'+accsub.Paid_Amount__c );
                                    system.debug('amount receved>>'+payment.Amount_Recevied__c);
                                }
                                else if(accsub.Payment_Status__c=='Partial Paid' && accsub.Usage_Type__c=='Product')
                                {
                                    if(accsub.Paid_Amount__c ==null)
                                    {
                                        accsub.Paid_Amount__c = 0; 
                                        accsub.Order_Status__c='Pending';
                                    }
                                    accsub.Paid_Amount__c = accsub.Paid_Amount__c+payment.Amount_Recevied__c;
                                    
                                }
                                if(accsub.Payment_Status__c=='Not Paid' && accsub.Usage_Type__c!='Product')
                                {
                                    if(accsub.Paid_Amount__c ==null)
                                    {
                                        accsub.Paid_Amount__c = 0;
                                        accsub.Order_Status__c='Pending';
                                    }
                                    accsub.Paid_Amount__c = accsub.Paid_Amount__c+payment.Amount_Recevied__c;
                                    system.debug('Paid amount>>'+accsub.Paid_Amount__c );
                                    system.debug('amount receved>>'+payment.Amount_Recevied__c);
                                }
                                else if(accsub.Payment_Status__c=='Partial Paid' && accsub.Usage_Type__c!='Product')
                                    
                                {
                                    if(accsub.Paid_Amount__c ==null)
                                    {
                                        accsub.Paid_Amount__c = 0;
                                        accsub.Order_Status__c='Pending';
                                    }
                                    accsub.Paid_Amount__c = accsub.Paid_Amount__c+payment.Amount_Recevied__c;
                                }
                                //code added by rashmi to update ASI object paid and amount Received feilds on 12-07-2019
                                if(orderObj.Customer_Type__c == 'Credit Customer')// || orderObj.Order_Created_Via__c == 'Subscription'
                                {   
                                    DT = [select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: orderObj.AccountId__c limit 1 ];
                                    
                                    if(DT.Paid_Amount__c == null)
                                        DT.Paid_Amount__c =0;
                                    DT.Paid_Amount__c = DT.Paid_Amount__c + payment.Amount_Recevied__c;
                                    update DT;
                                    system.debug('DT>>'+DT);
                                }
                                
                            }
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
                                if(orderObj.Order_Created_Via__c == 'Subscription' )
                                {
                                    accsub.Payment_Status__c = 'Paid';
                                    accsub.Order_Status__c='Order Confirmed';
                                    payment.Order_Created_Via__c='Subscription';
                                    payment.Account_Subscription_Interval__c = accsub.id;
                                }
                            }
                            else
                            {
                                payment.Status__c = 'Partial Paid';
                                if(orderObj.Order_Created_Via__c == 'Subscription' )
                                {
                                    accsub.Payment_Status__c = 'Partial Paid';
                                    accsub.Order_Status__c='Order Confirmed';
                                    payment.Order_Created_Via__c='Subscription';
                                    payment.Account_Subscription_Interval__c = accsub.id;
                                }
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
                            system.debug('payment.Credit_CardNumber__c>>>'+payment.Credit_CardNumber__c);
                        }   
                        paymentList.add(payment);
                        upsert paymentList;
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
                                /*if ((Schema.sObjectType.Payment__c.isAccessible()) &&
                                    (Schema.sObjectType.Payment__c.fields.Paid_Amount__c.isAccessible()) &&
                                    (Schema.sObjectType.Payment__c.fields.Paid_Amount__c.isCreateable()) &&
                                    (Schema.sObjectType.Payment__c.fields.Paid_Amount__c.isUpdateable()))
                                {*/
                                    if(payment.Paid_Amount__c == null)
                                    {
                                        payment.Paid_Amount__c = 0;
                                        
                                    }
                                    payment.Paid_Amount__c = payment.Paid_Amount__c + payment.Amount_Recevied__c;
                                    payment.SFDC_Account__c=accountid;
                                    //code added by rashmi to update ASI object paid and amount Received feilds on 12-07-2019
                                    if(orderObj.Account_Subscription_Interval__c!= null)
                                    {
                                        accsub=[select Name,Paid_Amount__c,Usage_Type__c,Payment_Status__c,Order_Status__c from Account_Subscription_Intervals__c where Id =: orderObj.Account_Subscription_Interval__c ];//and  id =:payment.Account_Subscription_Interval__c
                                        
                                        //code Added isolate OrderLine's Order_Status__c field on Nov-16
                                        if(accsub.Payment_Status__c=='Not Paid' && accsub.Usage_Type__c=='Product')
                                        {
                                            if(accsub.Paid_Amount__c ==null)
                                            {
                                                accsub.Paid_Amount__c = 0;
                                                accsub.Order_Status__c='Pending';
                                            }
                                            accsub.Paid_Amount__c = accsub.Paid_Amount__c+payment.Amount_Recevied__c;
                                            system.debug('Paid amount>>'+accsub.Paid_Amount__c );
                                            system.debug('amount receved>>'+payment.Amount_Recevied__c);
                                        }
                                        else if(accsub.Payment_Status__c=='Partial Paid' && accsub.Usage_Type__c=='Product')
                                        {
                                            if(accsub.Paid_Amount__c ==null)
                                            {
                                                accsub.Paid_Amount__c = 0;
                                                accsub.Order_Status__c='Pending';
                                            }
                                            accsub.Paid_Amount__c = accsub.Paid_Amount__c+payment.Amount_Recevied__c;
                                            
                                        }
                                        if(accsub.Payment_Status__c=='Not Paid' && accsub.Usage_Type__c!='Product')
                                        {
                                            if(accsub.Paid_Amount__c ==null)
                                            {
                                                accsub.Paid_Amount__c = 0;
                                                accsub.Order_Status__c='Pending';                                               
                                            }
                                            accsub.Paid_Amount__c = accsub.Paid_Amount__c+payment.Amount_Recevied__c;
                                            system.debug('Paid amount>>'+accsub.Paid_Amount__c );
                                            system.debug('amount receved>>'+payment.Amount_Recevied__c);
                                        }
                                        else if(accsub.Payment_Status__c=='Partial Paid' && accsub.Usage_Type__c!='Product')
                                            
                                        {
                                            if(accsub.Paid_Amount__c ==null)
                                            {
                                                accsub.Paid_Amount__c = 0;
                                                accsub.Order_Status__c='Pending';   
                                            }
                                            accsub.Paid_Amount__c = accsub.Paid_Amount__c+payment.Amount_Recevied__c;
                                        }
                                        
                                    }
                               // }
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
                                        if(orderObj.Order_Created_Via__c == 'Subscription' )
                                        {
                                            accsub.Payment_Status__c = 'Paid';
                                            accsub.Order_Status__c='Order Confirmed';
                                            payment.Order_Created_Via__c='Subscription';
                                            payment.Account_Subscription_Interval__c = accsub.id;                      
                                        }
                                    }
                                    else
                                    {
                                        payment.Status__c = 'Partial Paid';
                                        if(orderObj.Order_Created_Via__c == 'Subscription' )
                                        {
                                            accsub.Payment_Status__c = 'Partial Paid';
                                            accsub.Order_Status__c='Order Confirmed';
                                            payment.Order_Created_Via__c='Subscription';
                                            payment.Account_Subscription_Interval__c = accsub.id;
                                        }                                          
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
                                system.debug('paymentList::'+paymentList);      
                                temp = savePaymentDetails(payment,orderId,paymentId);
                                orderObj.Status__c = 'Draft';
                                if(payment.Status__c == 'Completed')
                                {
                                    orderObj.Is_Payment_Made__c = true;
                                }
                                else
                                {
                                    orderObj.Is_Payment_Made__c = false;
                                }
                                
                                if(regid!=null){
                                    sigmaerpdev2__Booking__c Bk;
                                    Bk=[select Id,Name,sigmaerpdev2__Payment_Status__c from sigmaerpdev2__Booking__c where Id =: regid];
                                    system.debug('Bk>r'+Bk);
                                    Bk.sigmaerpdev2__Payment_Status__c='Completed';
                                    Bk.sigmaerpdev2__Payment__c=payment.id;
                                   
                                    update Bk;
                                    system.debug('Bk>r'+Bk);
                                
                                    
                                }
                                 if(appointmentId!=null){
                                   
                                    Appointment__c app = new Appointment__c(Id=appointmentId,Status__c='Booking Confirmed');
                                    update app;
                                    system.debug('app>r'+app);
                                
                                    
                                }
                                
                                
                                
                                orderObj.Orders_Status__c = 'Order Confirmed'; 
                                
                                if(payment.Amount_Recevied__c == null)
                                {
                                    payment.Amount_Recevied__c = 0;
                                }
                                orderObj.Paid_Amount__c = orderObj.Paid_Amount__c+payment.Amount_Recevied__c;
                                system.debug('amount received>>'+payment.Amount_Recevied__c);
                                update orderObj;  
                                system.debug('orderObj>>'+orderObj);                                
                                
                                if(orderObj.Order_Created_Via__c == 'Subscription' )
                                {
                                    
                                    accsub.Payment__c=payment.id;
                                    update accsub;
                                    system.debug('accsub>>'+accsub);    
                                }
                                //Code ends here to update ASI on 12-07-2019
                                
                                
                                orderLines = [select id,Sigma_Order__r.Id,Sigma_Order__r.Auto_Allocate__c,Splited_Order_Line__c,Stock_Fulfilled__c,Order_Status__c,Product__c,Product__r.name,IsInventoryUpdated__c,Sigma_Order__r.Customer_Type__c,Sigma_Order__c,Sigma_Order__r.name,createddate,Sigma_Order__r.AccountId__r.name,Back_Order__c,Total_Price__c,Net_Quantity__c,Sigma_Order__r.No_Picking_Package_Shipment_Required__c,Is_Credit_Updated__c,Inventory_Status__c,Sigma_Order__r.Order_Created_Via__c from Product_Order_Price_Book__c where Sigma_Order__r.Id = :orderId];
                                List<Product_Order_Price_Book__c> allocateorderline = new  List<Product_Order_Price_Book__c>();
                                for(Product_Order_Price_Book__c orderline :orderLines )
                                {
                                    if(!orderline.IsInventoryUpdated__c)
                                    {
                                        allocateorderline.add(orderline);
                                    }
                                }
                                //code added by anuja
                                //  Time_Base_Inventory__c TBI;
                                //  TBI=[select Order__c,Proposal_to_Order__c from Time_Base_Inventory__c];
                                Boolean Execute;
                                Decimal Amounttoupdate =0;
                                //if(TBI.Order__c ==true ||TBI.Proposal_to_Order__c == true)
                                
                                for(Product_Order_Price_Book__c temp1 :orderLines ){
                                    
                                    if(!temp1.Splited_Order_Line__c && (temp1.Order_Status__c =='Pending' ||temp1.Order_Status__c =='Submitted'))
                                    {
                                        temp1.Order_Status__c = 'Order Confirmed';
                                        
                                    }    
                                    if(temp1.Stock_Fulfilled__c == true && temp1.IsInventoryUpdated__c ==false && temp1.Order_Status__c == 'Order Confirmed' && (temp1.Sigma_Order__r.Auto_Allocate__c ||temp1.Inventory_Status__c =='Allocated'))
                                    {
                                        allocatedorderLines.add(temp1);
                                    }
                                    
                                    
                                }
                                
                                update orderLines;
                                //code added to update Credit user details paid and amount Received feilds on 12-07-2019
                                /* if(orderObj.Customer_Type__c == 'Credit Customer')// || orderObj.Order_Created_Via__c == 'Subscription'
{   
DT = [select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: orderObj.AccountId__c limit 1 ];

if(DT.Paid_Amount__c == null)
DT.Paid_Amount__c =0;
DT.Paid_Amount__c = DT.Paid_Amount__c + payment.Amount_Recevied__c;
if(Amounttoupdate>0)
{
DT.Ordered_Amount__c +=Amounttoupdate;
}
update DT;
system.debug('DT>>'+DT);
} */
                                
                                Order_Payment__c orderPaymentObj = new Order_Payment__c();
                                orderPaymentObj.Sigma_Order__c = orderId;
                                orderPaymentObj.Payment__c = paymentId;   
                                orderPaymentObj.Amount__c = chargeAmount;
                                orderPaymentObj.Payment_Type__c = 'Charge';         
                                orderPaymentObj.Payment_Status__c = 'Payment Success';
                                orderPaymentObj.Quantity__c = orderObj.Quantity__c;
                                upsert orderPaymentObj; 
                                
                                if(allocateorderline.size()>0)
                                {
                                    if(orderObj.Order_Created_Via__c == 'Time Based Inventory')
                                    {
                                        Execute = AllocateInventoryCntrl.AllocateInventoryforOrder(allocateorderline);
                                    }
                                }
                                //handle invoice status after payment 13-03-2020
                                /*  if(orderObj.Order_Created_Via__c == 'POS')
{
Invoice__c invoice = [Select id,name,Invoice_Status__c from Invoice__c where SO__c =:orderObj.id];


if(orderObj.Orders_Status__c == 'Order Confirmed' && invoice !=null)
{
invoice.Invoice_Status__c='Paid';
update invoice;
}
}*/
                                
                                
                                
                                if(allocatedorderLines.size()>0 && orderObj.Order_Created_Via__c != 'Time Based Inventory')
                                {
                                    system.debug('inautostock');
                                    autostockreservation.autostockreserve(allocatedorderLines);
                                    
                                }
                                
                                /*  if(orderObj.Order_Created_Via__c == 'Community' && orderObj.Orders_Status__c == 'Order Confirmed' && orderObj.Brewer_Account__c !=null)
{
system.debug('inemail');
SendEmailToBrewery.emailtobrewery(orderObj.id);

}*/
                                
                                return temp;
                            }
                            
                        }
                    }
                }
            }
            
            // }
            
        }
        catch(Exception ex)
        {
            createErrorLog.insertError('SavePaymentCntrl',ex.getMessage(),'Method -stripePayment ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
        }
        return null; //added by samad
    }
    
    
    @AuraEnabled
    public static string savePaymentDetails(Payment__c payment, Id orderId,Id paymentId){       
        try{
            Double chargeAmount = payment.Amount__c;
            /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Account_Subscription_Intervals__c')
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Time_Base_Inventory__c')
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Payment__c') 
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Dimension_Tag__c') 
&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Payment__c')  
&&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Payment__c',new set<String>{'id','name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Amount__c','sigmaerpdev__SFDC_Account__c','sigmaerpdev__Amount_Recevied__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Payment_Time__c','sigmaerpdev__Tax_Amount__c'}) 
&&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'Id','name','sigmaerpdev__Due_Amount__c','sigmaerpdev__Status__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Quantity__c','sigmaerpdev__Account_Subscription_Interval__c','sigmaerpdev__Account_Subscription_Interval__r.Name','sigmaerpdev__TotalAmount__c' ,'sigmaerpdev__Paid_Amount__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__TotalAmount__c'}) 
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Account_Subscription_Intervals__c',new set<String>{'Id','name','sigmaerpdev__Payment_Status__c','sigmaerpdev__Usage_Type__c','sigmaerpdev__Tax_Amount__c'})
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'id','sigmaerpdev__Sigma_Order__r.Id','sigmaerpdev__Product__c','sigmaerpdev__Order_Status__c'}) 
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Time_Base_Inventory__c',new set<String>{'sigmaerpdev__Order__c','sigmaerpdev__Proposal_to_Order__c'})
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Dimension_Tag__c',new set<String>{'id','sigmaerpdev__Base_Credit_Limit__c','sigmaerpdev__Ordered_Amount__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Account__c'})
&& CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sigma_Order__c',new set<String>{'sigmaerpdev__Status__c','sigmaerpdev__Is_Payment_Made__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Paid_Amount__c'}) 
&& CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Account_Subscription_Intervals__c',new set<String>{'sigmaerpdev__Payment_Status__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Paid_Amount__c'})
&& CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev__Order_Status__c'})
&& CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Order_Payment__c',new set<String>{'sigmaerpdev__Sigma_Order__c','sigmaerpdev__Payment__c','sigmaerpdev__Payment_Type__c','sigmaerpdev__Amount__c','sigmaerpdev__Payment_Status__c','sigmaerpdev__Quantity__c'})
&&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Dimension_Tag__c',new set<String>{'sigmaerpdev__Paid_Amount__c'})  
)
{ */ 
            Sigma_Order__c orderObj;
            Dimension_Tag__c DT;
            Account_Subscription_Intervals__c accsub;
            
            List<Product_Order_Price_Book__c> orderLines =  new List<Product_Order_Price_Book__c>();
            
            orderObj = [select Status__c,Quantity__c,AccountId__c,Order_Created_Via__c,Customer_Type__c,Account_Subscription_Interval__c,TotalAmount__c,Paid_Amount__c,Account_Subscription_Interval__r.Name from Sigma_Order__c where Id =: orderId];      
            system.Debug('orderObj>>'+orderObj);
            
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
            
            if(payment.Amount_Recevied__c == null)
            {
                payment.Amount_Recevied__c = 0;
            }
            orderObj.Paid_Amount__c = orderObj.Paid_Amount__c+payment.Amount_Recevied__c;
            system.Debug('orderObj1>>'+orderObj.Paid_Amount__c );
            update orderObj;     
            
            if(orderObj.Account_Subscription_Interval__c!= null)
            {
                accsub=[select Name,Paid_Amount__c,Usage_Type__c,Payment_Status__c,Order_Status__c from Account_Subscription_Intervals__c where Id =: orderObj.Account_Subscription_Interval__c ];//and  id =:payment.Account_Subscription_Interval__c
                
                //code Added isolate OrderLine's Order_Status__c field on Nov-16
                if(accsub.Payment_Status__c=='Not Paid' && accsub.Usage_Type__c=='Product')
                {
                    if(accsub.Paid_Amount__c ==null)
                    {
                        accsub.Paid_Amount__c = 0;
                        accsub.Order_Status__c='Pending';   
                    }
                    accsub.Paid_Amount__c = accsub.Paid_Amount__c+payment.Amount_Recevied__c;
                    system.debug('Paid amount>>'+accsub.Paid_Amount__c );
                    system.debug('amount receved>>'+payment.Amount_Recevied__c);
                }
                else if(accsub.Payment_Status__c=='Partial Paid' && accsub.Usage_Type__c=='Product')
                {
                    if(accsub.Paid_Amount__c ==null)
                    {
                        accsub.Paid_Amount__c = 0;
                        accsub.Order_Status__c='Pending';   
                    }
                    accsub.Paid_Amount__c = accsub.Paid_Amount__c+payment.Amount_Recevied__c;
                    
                }
                if(accsub.Payment_Status__c=='Not Paid' && accsub.Usage_Type__c!='Product')
                {
                    if(accsub.Paid_Amount__c ==null)
                    {
                        accsub.Paid_Amount__c = 0;  
                        accsub.Order_Status__c='Pending';
                    }
                    accsub.Paid_Amount__c = accsub.Paid_Amount__c+payment.Amount_Recevied__c;
                    system.debug('Paid amount>>'+accsub.Paid_Amount__c );
                    system.debug('amount receved>>'+payment.Amount_Recevied__c);
                }
                else if(accsub.Payment_Status__c=='Partial Paid' && accsub.Usage_Type__c!='Product')
                    
                {
                    if(accsub.Paid_Amount__c ==null)
                    {
                        accsub.Paid_Amount__c = 0;
                        accsub.Order_Status__c='Pending';
                    }
                    accsub.Paid_Amount__c = accsub.Paid_Amount__c+payment.Amount_Recevied__c;
                }
                
            }
            if(orderObj.Order_Created_Via__c == 'Subscription' )
            {
                accsub.Order_Status__c='Order Confirmed';
                //accsub.Id = payment.Account_Subscription_Interval__c; 
                accsub.Payment__c=payment.id;
                update accsub;
            }
            //Code ends here to update ASI on 12-07-2019
            
            orderLines = [select id,Splited_Order_Line__c,Sigma_Order__r.Id,Product__c,Order_Status__c,Is_Credit_Updated__c,Sigma_Order__r.Customer_Type__c,Total_Price__c from Product_Order_Price_Book__c where Sigma_Order__r.Id = :orderId];
            
            //code added by anuja
            Time_Base_Inventory__c TBI;
            TBI=[select Order__c,Proposal_to_Order__c from Time_Base_Inventory__c];
            Boolean Execute;
            Decimal Amounttoupdate = 0;
            if(TBI.Order__c ==true || TBI.Proposal_to_Order__c ==true )
            {
                Execute = AllocateInventoryCntrl.AllocateInventoryforOrder(orderLines);
            }
            
            
            for(Product_Order_Price_Book__c temp :orderLines ){
                if(!temp.Splited_Order_Line__c)
                {
                    temp.Order_Status__c = 'Order Confirmed';
                    if(temp.Sigma_Order__r.Customer_Type__c == 'Credit Customer')
                    {
                        system.debug('in@@');
                        Amounttoupdate += temp.Total_Price__c;
                        temp.Is_Credit_Updated__c =true;
                    }
                }
                
            }
            
            update orderLines;
            
            if(orderObj.Customer_Type__c == 'Credit Customer' )
            {   
                DT = [select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c,Account__c from Dimension_Tag__c where Account__c =: orderObj.AccountId__c limit 1 ];
                system.debug('DT@@'+DT);
                if(DT.Paid_Amount__c == null)
                    DT.Paid_Amount__c =0;
                DT.Paid_Amount__c = DT.Paid_Amount__c + payment.Amount_Recevied__c;
                if(Amounttoupdate >0)
                    DT.Ordered_Amount__c += Amounttoupdate;
                update DT;
                system.debug('DT>>'+DT);
            }
            
            Order_Payment__c orderPaymentObj = new Order_Payment__c();
            orderPaymentObj.Sigma_Order__c = orderId;
            orderPaymentObj.Payment__c = paymentId; 
            orderPaymentObj.Amount__c = chargeAmount;
            orderPaymentObj.Payment_Type__c = 'Charge';                 
            orderPaymentObj.Payment_Status__c = 'Payment Success'; 
            orderPaymentObj.Quantity__c = orderObj.Quantity__c;
            
            upsert orderPaymentObj;  
            //}
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
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Payment__c')
&& CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Dimension_Tag__c')
&& CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Account_Subscription_Intervals__c')

&& Schema.sObjectType.Payment__c.fields.Id.isAccessible()
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Payment__c',new set<String>{'id','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Amount_Recevied__c','sigmaerpdev__Amount__c','sigmaerpdev__SFDC_Account__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Account_Subscription_Interval__c','sigmaerpdev__Tax_Amount__c'})
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Account_Subscription_Intervals__c',new Set<String>{'id','name','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Due_Amount__c','sigmaerpdev__next_Billing_Amount__c','sigmaerpdev__Payment_Status__c','sigmaerpdev__Customer__c','sigmaerpdev__Customer__r.Customer_Type__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__Amount__c'})
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Dimension_Tag__c',new Set<String>{'id','sigmaerpdev__Base_Credit_Limit__c','sigmaerpdev__Ordered_Amount__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Account__c'})

&& CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Payment__c',new set<String>{'sigmaerpdev__Payment_Time__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Status__c','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Account_Subscription_Interval__c','sigmaerpdev__Customer_SFID__c','sigmaerpdev__Tax_Amount__c'})
&& CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Account_Subscription_Intervals__c',new set<String>{'sigmaerpdev__Paid_Amount__c','sigmaerpdev__Payment_Status__c','sigmaerpdev__Payment__c'})
&& CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Dimension_Tag__c',new Set<String>{'sigmaerpdev__Ordered_Amount__c','sigmaerpdev__Paid_Amount__c'}))
{ */
        try
        {
            Account_Subscription_Intervals__c orderObj = new Account_Subscription_Intervals__c();
            orderObj=[select id,name,Paid_Amount__c,Order_Status__c,Due_Amount__c,next_Billing_Amount__c,Payment_Status__c,Customer__c,Customer__r.Customer_Type__c,Tax_Amount__c,Amount__c from Account_Subscription_Intervals__c where id=:payment[0].Account_Subscription_Interval__c];
            Dimension_Tag__c DT;
            //code added by rashmi on 27-04-2020 to handle tax amount
            List<Tax__c> taxObj = TaxCntr.getTax(orderObj.Customer__c);
            Double federalTax = Double.valueOf(taxObj.get(0).Tax_Amount__c);
            String fedTaxType = String.valueOf(taxObj.get(0).Type__c);
            Double stateTax = Double.valueOf(taxObj.get(1).Tax_Amount__c);
            String stateTaxType = String.valueOf(taxObj.get(1).Type__c);
            //code Ends here
            //code added by rashmi to update Credit customer details in credit user info on 06-11-2019
            if(orderObj.Customer__r.Customer_Type__c == 'Credit Customer' && orderObj.Amount__c!=null && orderObj.Order_Status__c=='Not Created' )
            {   
                DT = [select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: orderObj.Customer__c limit 1 ];
                if(orderObj.Payment_Status__c=='Not Paid')
                {  
                    if(DT.Ordered_Amount__c==null)
                        DT.Ordered_Amount__c=0;
                    if(orderObj.Amount__c!=null)
                        DT.Ordered_Amount__c+=orderObj.Amount__c;
                }
                if(DT.Paid_Amount__c == null)
                    DT.Paid_Amount__c =0;
                DT.Paid_Amount__c = DT.Paid_Amount__c + payment[0].Amount_Recevied__c;
                update DT;
            }
            
            datetime pmntDateTime = datetime.now();             
            payment[0].Payment_Time__c = pmntDateTime;  
            
            if(payment[0].Paid_Amount__c == null)
            {
                payment[0].Paid_Amount__c = 0;
            }
            payment[0].Federal_Tax__c=federalTax;
            payment[0].State_Tax__c=stateTax;
            payment[0].Tax_Amount__c=orderObj.Tax_Amount__c;
            payment[0].Paid_Amount__c = payment[0].Paid_Amount__c+payment[0].Amount_Recevied__c;
            if(orderObj.Paid_Amount__c ==null )
            {
                orderObj.Paid_Amount__c = 0; 
                
            }
            orderObj.Paid_Amount__c = orderObj.Paid_Amount__c+payment[0].Amount_Recevied__c;
            if(payment[0].Amount__c <= payment[0].Paid_Amount__c)
            {
                payment[0].Status__c = 'Completed';
                orderObj.Payment_Status__c = 'Paid';
                payment[0].Order_Created_Via__c='Subscription';
                payment[0].Account_Subscription_Interval__c = orderObj.id;
            }
            else
            {
                payment[0].Status__c = 'Partial Paid';
                orderObj.Payment_Status__c = 'Partial Paid';
                payment[0].Order_Created_Via__c='Subscription';
                payment[0].Account_Subscription_Interval__c = orderObj.id;
            }
            
            Id custId = payment[0].SFDC_Account__c;
            payment[0].Customer_SFID__c = custId;
            
            insert payment;     
            orderObj.Id = payment[0].Account_Subscription_Interval__c; 
            orderObj.Payment__c=payment[0].id;
            update orderObj;
        }
        catch(Exception ex){
            createErrorLog.insertError('SavePaymentCntrl',ex.getMessage(),'Method -savesubscriptionCashPayment ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
        }
        // }
        return payment;
    }
    @AuraEnabled
    public static List<Payment__c> savesubscriptionChequePayment(List<Payment__c> payment)
    {
        /*  if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Payment__c')
&& CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Dimension_Tag__c')
&& CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Account_Subscription_Intervals__c')

&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Payment__c',new set<String>{'sigmaerpdev__Paid_Amount__c','sigmaerpdev__Amount_Recevied__c','sigmaerpdev__Amount__c','sigmaerpdev__SFDC_Account__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Credit_CardNumber__c','sigmaerpdev__Tax_Amount__c'})
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Account_Subscription_Intervals__c',new Set<String>{'id','name','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Due_Amount__c','sigmaerpdev__next_Billing_Amount__c','sigmaerpdev__Payment_Status__c','sigmaerpdev__Customer__c','sigmaerpdev__Customer__r.Customer_Type__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__Amount__c'})
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Dimension_Tag__c',new Set<String>{'id','sigmaerpdev__Base_Credit_Limit__c','sigmaerpdev__Ordered_Amount__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Account__c'})

&& CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Payment__c',new set<String>{'sigmaerpdev__Payment_Time__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Status__c','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Account_Subscription_Interval__c','sigmaerpdev__Customer_SFID__c','sigmaerpdev__Tax_Amount__c'})
&& CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Account_Subscription_Intervals__c',new set<String>{'sigmaerpdev__Paid_Amount__c','sigmaerpdev__Payment_Status__c','sigmaerpdev__Payment__c'})
&& CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Dimension_Tag__c',new Set<String>{'sigmaerpdev__Ordered_Amount__c','sigmaerpdev__Paid_Amount__c'}))
{*/
        try
        {
            Account_Subscription_Intervals__c orderObj = new Account_Subscription_Intervals__c();
            orderObj=[select id,name,Paid_Amount__c,Order_Status__c,Due_Amount__c,next_Billing_Amount__c,Payment_Status__c,Customer__c,Customer__r.Customer_Type__c,Tax_Amount__c,Amount__c from Account_Subscription_Intervals__c where id=:payment[0].Account_Subscription_Interval__c];
            Dimension_Tag__c DT;
            //code added by rashmi on 27-04-2020 to handle tax amount
            List<Tax__c> taxObj = TaxCntr.getTax(orderObj.Customer__c);
            Double federalTax = Double.valueOf(taxObj.get(0).Tax_Amount__c);
            String fedTaxType = String.valueOf(taxObj.get(0).Type__c);
            Double stateTax = Double.valueOf(taxObj.get(1).Tax_Amount__c);
            String stateTaxType = String.valueOf(taxObj.get(1).Type__c);
            //code Ends here
            //code added by rashmi to update Credit customer details in credit user info on 06-11-2019
            if(orderObj.Customer__r.Customer_Type__c == 'Credit Customer' && orderObj.Amount__c!=null && orderObj.Order_Status__c=='Not Created' )
            {   
                DT = [select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: orderObj.Customer__c limit 1 ];
                system.debug('DT>>>'+DT);
                
                if(orderObj.Payment_Status__c=='Not Paid')
                {  
                    system.debug('total amount to be paid>>>'+orderObj.Amount__c);
                    if(DT.Ordered_Amount__c==null)
                        DT.Ordered_Amount__c=0;
                    if(orderObj.next_Billing_Amount__c!=null)
                        DT.Ordered_Amount__c+=orderObj.Amount__c;
                    system.debug('after aading  order amount in DT'+DT.Ordered_Amount__c);
                    
                }
                if(DT.Paid_Amount__c == null)
                    DT.Paid_Amount__c =0;
                DT.Paid_Amount__c = DT.Paid_Amount__c + payment[0].Amount_Recevied__c;
                system.debug('DT paid amount>>>'+DT.Paid_Amount__c);
                update DT;
                system.debug('After Updating DT>>'+DT);
            }
            datetime pmntDateTime = datetime.now();             
            payment[0].Payment_Time__c = pmntDateTime;  
            system.debug('amount received'+payment[0].Amount_Recevied__c);
            if(payment[0].Paid_Amount__c == null)
            {
                payment[0].Paid_Amount__c = 0;
            }
            payment[0].Federal_Tax__c=federalTax;
            payment[0].State_Tax__c=stateTax;
            payment[0].Tax_Amount__c=orderObj.Tax_Amount__c;
            payment[0].Paid_Amount__c = payment[0].Paid_Amount__c+payment[0].Amount_Recevied__c;
            if(orderObj.Paid_Amount__c ==null )
            {
                orderObj.Paid_Amount__c = 0; 
            }
            orderObj.Paid_Amount__c = orderObj.Paid_Amount__c+payment[0].Amount_Recevied__c;
            if(payment[0].Amount__c <= payment[0].Paid_Amount__c)
            {
                payment[0].Status__c = 'Completed';
                orderObj.Payment_Status__c = 'Paid';
                payment[0].Order_Created_Via__c='Subscription';
                payment[0].Account_Subscription_Interval__c = orderObj.id;
            }
            else
            {
                payment[0].Status__c = 'Partial Paid';
                orderObj.Payment_Status__c = 'Partial Paid';
                payment[0].Order_Created_Via__c='Subscription';
                payment[0].Account_Subscription_Interval__c = orderObj.id;
            }
            Id custId = payment[0].SFDC_Account__c;
            payment[0].Customer_SFID__c = custId;
            insert payment;   
            
            orderObj.Id = payment[0].Account_Subscription_Interval__c; 
            orderObj.Payment__c=payment[0].id;
            update orderObj;
        }
        catch(Exception ex)
        {
            createErrorLog.insertError('SavePaymentCntrl',ex.getMessage(),'Method -savesubscriptionChequePayment ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
        }
        // }
        return payment;
    }
    @AuraEnabled
    public static String stripePaymentsubscription(Payment__c payment,Decimal chargeAmount,String CVV, String expiryMonth, String expiryYear,Decimal paidAmount,String accountid)
    {   
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Payment__c')
&& CRUD_FLS_CheckUtility.checkObjCRUD('Account')
&& CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Dimension_Tag__c')
&& CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Account_Subscription_Intervals__c')

&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Payment__c',new set<String>{'sigmaerpdev__Paid_Amount__c','sigmaerpdev__Amount_Recevied__c','sigmaerpdev__Amount__c','sigmaerpdev__SFDC_Account__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Credit_CardNumber__c','sigmaerpdev__Tax_Amount__c'})
&& CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'Id','name','sigmaerpdev__stripeCustomerId__c','sigmaerpdev__Currency_code__c'})
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Account_Subscription_Intervals__c',new Set<String>{'sigmaerpdev__Paid_Amount__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Due_Amount__c','sigmaerpdev__next_Billing_Amount__c','sigmaerpdev__Payment_Status__c','sigmaerpdev__Customer__c','sigmaerpdev__Customer__r.Customer_Type__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__Amount__c'})
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Dimension_Tag__c',new Set<String>{'sigmaerpdev__Base_Credit_Limit__c','sigmaerpdev__Ordered_Amount__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Account__c'})

&& CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Payment__c',new set<String>{'sigmaerpdev__PayPal_Transaction_Id__c','sigmaerpdev__Charge_Id__c','sigmaerpdev__Payment_Time__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__SFDC_Account__c','sigmaerpdev__Status__c','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Account_Subscription_Interval__c','sigmaerpdev__Credit_CardNumber__c','sigmaerpdev__Tax_Amount__c'})
&& CRUD_FLS_CheckUtility.checkFLS('Account',new set<String>{'sigmaerpdev__stripeCustomerId__c'})
&& CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Account_Subscription_Intervals__c',new set<String>{'sigmaerpdev__Paid_Amount__c','sigmaerpdev__Payment_Status__c','sigmaerpdev__Payment__c'})
&& CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Dimension_Tag__c',new Set<String>{'sigmaerpdev__Ordered_Amount__c','sigmaerpdev__Paid_Amount__c'}))
{ */
        try{
            
            
            string temp;
            String ids;
            Dimension_Tag__c DT;
            Account_Subscription_Intervals__c orderObj = new Account_Subscription_Intervals__c();
            orderObj=[select id,name,Paid_Amount__c,Order_Status__c,Due_Amount__c,next_Billing_Amount__c,Payment_Status__c,Customer__c,Customer__r.Customer_Type__c,Tax_Amount__c,Amount__c from Account_Subscription_Intervals__c where id=:payment.Account_Subscription_Interval__c];
            //code added by rashmi on 27-04-2020 to handle tax amount
            List<Tax__c> taxObj = TaxCntr.getTax(orderObj.Customer__c);
            Double federalTax = Double.valueOf(taxObj.get(0).Tax_Amount__c);
            String fedTaxType = String.valueOf(taxObj.get(0).Type__c);
            Double stateTax = Double.valueOf(taxObj.get(1).Tax_Amount__c);
            String stateTaxType = String.valueOf(taxObj.get(1).Type__c);
            //code Ends here
            if(accountid != null && String.isNotEmpty(accountid))
            {
                Map<String, String> properties;
                Map<String, String> metadata;
                List<Account> acc = new List<Account>();
                acc = [select id,stripeCustomerId__c,Currency_code__c from Account where id =:accountid limit 1];
                List<Payment__c> paymentList = new List<Payment__c>();
                if(!acc.isEmpty() && acc[0].stripeCustomerId__c != null && acc[0].Currency_code__c != null)
                {                
                    system.debug('inside stripe payment'); 
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
                            if(payment.Paid_Amount__c == null)
                            {
                                payment.Paid_Amount__c = 0;
                            }
                            payment.Federal_Tax__c=federalTax;
                            payment.State_Tax__c=stateTax;
                            payment.Tax_Amount__c=orderObj.Tax_Amount__c;
                            payment.Paid_Amount__c = payment.Paid_Amount__c+payment.Amount_Recevied__c;
                            payment.SFDC_Account__c=accountid; //code added by rashmi to update account related payment details on 07-11-2019
                            if(orderObj.Paid_Amount__c ==null )
                            {
                                orderObj.Paid_Amount__c = 0;
                            }
                            orderObj.Paid_Amount__c = orderObj.Paid_Amount__c+payment.Amount_Recevied__c;
                            //code added by rashmi to update Credit customer details in credit user info on 06-11-2019
                            if(orderObj.Customer__r.Customer_Type__c == 'Credit Customer' && orderObj.Amount__c!=null && orderObj.Order_Status__c=='Not Created' )
                            {   
                                DT = [select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: orderObj.Customer__c limit 1 ];
                                if(orderObj.Payment_Status__c=='Not Paid')
                                {  
                                    if(DT.Ordered_Amount__c==null)
                                        DT.Ordered_Amount__c=0;
                                    if(orderObj.Amount__c!=null)
                                        DT.Ordered_Amount__c+=orderObj.Amount__c;
                                }
                                if(DT.Paid_Amount__c == null)
                                    DT.Paid_Amount__c =0;
                                DT.Paid_Amount__c = DT.Paid_Amount__c + payment.Amount_Recevied__c;
                                update DT;
                            }
                            if(payment.Amount__c <= payment.Paid_Amount__c)
                            {
                                payment.Status__c = 'Completed';
                                orderObj.Payment_Status__c = 'Paid';
                                payment.Order_Created_Via__c='Subscription';
                                payment.Account_Subscription_Interval__c = orderObj.id;
                            }
                            else
                            {
                                payment.Status__c ='Partial Paid';
                                orderObj.Payment_Status__c ='Partial Paid';
                                payment.Order_Created_Via__c='Subscription';
                                payment.Account_Subscription_Interval__c = orderObj.id;
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
                                    if(payment.Paid_Amount__c == null)
                                    {
                                        payment.Paid_Amount__c = 0;
                                    }
                                    payment.Federal_Tax__c=federalTax;
                                    payment.State_Tax__c=stateTax;
                                    payment.Tax_Amount__c=orderObj.Tax_Amount__c;
                                    payment.Paid_Amount__c = payment.Paid_Amount__c+payment.Amount_Recevied__c;
                                    payment.SFDC_Account__c=accountid; //code added by rashmi to update account related payment details on 07-11-
                                    if(orderObj.Paid_Amount__c ==null )
                                    {
                                        orderObj.Paid_Amount__c = 0;
                                    }
                                    orderObj.Paid_Amount__c = orderObj.Paid_Amount__c+payment.Amount_Recevied__c;
                                    
                                    //code added by rashmi to update Credit customer details in credit user info on 06-11-2019
                                    if(orderObj.Customer__r.Customer_Type__c == 'Credit Customer' && orderObj.Amount__c!=null && orderObj.Order_Status__c=='Not Created' )
                                    {   
                                        DT = [select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: orderObj.Customer__c limit 1 ];
                                        if(orderObj.Payment_Status__c=='Not Paid')
                                        {  
                                            if(DT.Ordered_Amount__c==null)
                                                DT.Ordered_Amount__c=0;
                                            if(orderObj.Amount__c!=null)
                                                DT.Ordered_Amount__c+=orderObj.Amount__c;
                                        }
                                        if(DT.Paid_Amount__c == null)
                                            DT.Paid_Amount__c =0;
                                        DT.Paid_Amount__c = DT.Paid_Amount__c + payment.Amount_Recevied__c;
                                        update DT;
                                    }                                    
                                    if(payment.Amount__c <= payment.Paid_Amount__c)
                                    {
                                        payment.Status__c = 'Completed';
                                        orderObj.Payment_Status__c = 'Paid';
                                        payment.Order_Created_Via__c='Subscription';
                                        payment.Account_Subscription_Interval__c = orderObj.id;
                                    }
                                    else
                                    {
                                        payment.Status__c = 'Partial Paid';
                                        orderObj.Payment_Status__c = 'Partial Paid';
                                        payment.Order_Created_Via__c='Subscription';
                                        payment.Account_Subscription_Interval__c = orderObj.id;
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
                                Id orderId = payment.Sigma_Order__c;   
                                Id paymentId = payment.Id; 
                                temp = savePaymentDetails(payment,orderId,paymentId);
                                
                                //new code added for subcription payment 
                                orderObj.Id = payment.Account_Subscription_Interval__c; 
                                orderObj.Payment__c = paymentId;
                                update orderObj;
                                
                                return String.valueOf(paymentList[0].Id);
                            }
                            ids=String.valueOf(paymentList[0].Id);
                        }
                    }
                }
            }
        }
        catch(Exception ex)
        {
            createErrorLog.insertError('SavePaymentCntrl',ex.getMessage(),'Method -stripePaymentsubscription ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
        }
        // }
        return null;
    }       
}