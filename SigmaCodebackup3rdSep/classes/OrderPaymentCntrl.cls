public With Sharing class OrderPaymentCntrl {
	public class CompleteWrap
    {
		@auraEnabled
		public List<Sigma_Order__c>SigmaOrder{get;set;}
		@auraEnabled
		public List<Order>StandardOrder{get;set;}
		@auraEnabled
		public Order_Usage__c OrderTypeusage{get;set;}
		public CompleteWrap(List<Sigma_Order__c>SigmaOrder,List<Order>StandardOrder,Order_Usage__c OrderTypeusage)
		{
			this.SigmaOrder = SigmaOrder;
			this.StandardOrder = StandardOrder;
			this.OrderTypeusage = OrderTypeusage;
		}
	}		
	@AuraEnabled
    public static CompleteWrap fetchOrder(Id AccId)
    { 
		List<Sigma_Order__c>SigmaOrder = new List<Sigma_Order__c>();
		List<Order>StandardOrder = New List<Order>();
		Order_Usage__c OrderTypeusage = [select Id,Name,Sigma_order__c,Standard_object__c from Order_Usage__c limit 1];
		if(OrderTypeusage.Sigma_order__c)
		{
			SigmaOrder = [select id,Name,AccountId__c,AccountId__r.Name,TotalAmount__c,Due_Amount__c from Sigma_Order__c where AccountId__c=:AccId and Due_Amount__c >0];
		}
		else if(OrderTypeusage.Standard_object__c)
		{
			StandardOrder = [select id,AccountId,Account.Name,OrderNumber,Net_Amount__c,Orders_Status__c,Due_Amount__c from order where AccountId =:AccId and Due_Amount__c>0];
		}
		
		if(SigmaOrder.size()>0)
		{
			return new CompleteWrap(SigmaOrder,null,OrderTypeusage);          
        
		}
		else if(StandardOrder.size()>0)
		{
			return new CompleteWrap(null,StandardOrder,OrderTypeusage);   
		}
		else
		{
			return null;
		}
	}
    
    @AuraEnabled
    public static List<Sigma_Order__c> fetchsigmaorder(List<Id> OrderId)
    {
        system.debug('OrderId@@'+OrderId);
		List<Sigma_Order__c>SigmaOrder = [select id,Name,AccountId__c,AccountId__r.Name,TotalAmount__c,Due_Amount__c from Sigma_Order__c where Id=:OrderId];
		return SigmaOrder;
		
	}
    
     @AuraEnabled
    public static List<order> fetchstdorder(List<Id> OrderId)
    {
        system.debug('OrderId@@'+OrderId);
		List<order>Orderdata = [select id,AccountId,Account.Name,OrderNumber,Net_Amount__c,Orders_Status__c,Due_Amount__c from order where Id=:OrderId];
		return Orderdata;
		
	}
    
     @AuraEnabled
    public static List<Tax__c> getTax(Id customerSFID)
    {   
        List<Tax__c> totalTaxes = new List<Tax__c>();
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<string>{'id','name','BillingState','BillingCountry','sigmaerpdev__Country__c','sigmaerpdev__State__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Tax__c',new set<string>{'Id','sigmaerpdev__Name__c','sigmaerpdev__Applies_To__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__Type__c','sigmaerpdev__Country__c','sigmaerpdev__State__c','sigmaerpdev__Merchant_Account__c','sigmaerpdev__Status__c'})
          )
        {*/
            Account accDetails;
                accDetails = [select id,name,BillingState,BillingCountry,Country__c,State__c from Account where id =: customerSFID];
            
            List<Tax__c> federalTax = new List<Tax__c>();
            List<Tax__c> stateTax = new List<Tax__c>();
            List<Tax__c> ProductTax = new List<Tax__c>();
            try{
                   federalTax  = [Select Id,Name__c,Status__c,Applies_To__c,Tax_Amount__c,Type__c,Country__c,State__c,Merchant_Account__c from Tax__c  where Applies_To__c = 'Federal Tax' and Country__c =:accDetails.Country__c   limit 1];  
                   
            }
            catch(Exception ex){
            }
            
            try{
                  stateTax  = [Select Id,Name__c,Status__c,Tax_Amount__c,Applies_To__c,Type__c,Country__c,State__c,Merchant_Account__c from Tax__c  where Applies_To__c = 'State Tax' and Country__c = :accDetails.Country__c and State__c = :accDetails.State__c   limit 1]; 
                    
               }
            catch(Exception ex){
                system.debug('Exception occured during fetching of stateTax ::'+ex);    
            }
           
            if(federalTax.size() > 0 && federalTax[0].Status__c == 'Active'){
                totalTaxes.add(federalTax[0]);      
            }
            else{
                Tax__c  tempFederalobj = new Tax__c();  
                tempFederalobj.Tax_Amount__c = 0;
                tempFederalobj.Type__c = 'Percentage';
                totalTaxes.add(tempFederalobj); 
            }   
            
            if(stateTax.size() > 0 && stateTax[0].Status__c == 'Active'){
                totalTaxes.add(stateTax[0]);        
            }
            else{
                Tax__c  tempStateobj = new Tax__c();            
                tempStateobj.Tax_Amount__c = 0;
                tempStateobj.Type__c = 'Percentage';    
                totalTaxes.add(tempStateobj);
            }
           
        //} 
       return totalTaxes;        
    }
    
    
	
	@AuraEnabled
    public static Payment__c saveCashPayment(Payment__c payment,List<Sigma_Order__c>order)
    {
		system.debug(order);
        
		
		Id orderId = payment.Sigma_Order__c;  
		Id paymentId = payment.Id;
		Double chargeAmount = payment.Amount__c;  
		Dimension_Tag__c DT;
		List<Product_Order_Price_Book__c> allocatedorderLines =  new List<Product_Order_Price_Book__c>();
		List<Product_Order_Price_Book__c> timebasedorderline = new  List<Product_Order_Price_Book__c>();
		
		
		//orderObj = [select Status__c,AccountId__c,Customer_Type__c,Orders_Status__c,Total_Payable_Amount__c,Order_Created_Via__c,Quantity__c,Account_Subscription_Interval__c,Due_Amount__c,TotalAmount__c ,Paid_Amount__c,Account_Subscription_Interval__r.Name from Sigma_Order__c where Id =: orderId];       
		
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
        payment.Status__c = 'Completed';
		
		insert payment;   
		system.debug('payment@'+payment);
		
		List<Order_Payment_Relation__c> OrderPayment=  new List<Order_Payment_Relation__c>();
        List<Product_Order_Price_Book__c>OrderLines = new List<Product_Order_Price_Book__c>();
		Map<Id,Decimal>PaidAmountMap = new Map<Id,Decimal>();
		for(Sigma_Order__c SO:order)
		{
            PaidAmountMap.put(SO.Id,SO.Due_Amount__c);
			Order_Payment_Relation__c OPR = New Order_Payment_Relation__c();
			OPR.Sigma_Order__c = SO.Id;
			OPR.Payment__c = payment.id;
			OPR.Amount_Recevied__c = SO.Due_Amount__c;
			OrderPayment.add(OPR);
		}
                
		if(OrderPayment.size()>0)
		{
			Insert OrderPayment;
		}
		List<Sigma_Order__c> SigmaOrders = [Select Id,Name,Orders_Status__c,Paid_Amount__c,Is_Payment_Made__c,Customer_Type__c,AccountId__c,(Select id,Sigma_Order__r.Id,Splited_Order_Line__c,Stock_Fulfilled__c,Sigma_Order__r.Auto_Allocate__c,Sigma_Order__r.Order_Created_Via__c,Order_Status__c,Product__c,Product__r.name,IsInventoryUpdated__c,Sigma_Order__r.Customer_Type__c,Sigma_Order__c,Sigma_Order__r.name,createddate,Sigma_Order__r.AccountId__r.name,Back_Order__c,Total_Price__c,Net_Quantity__c,Sigma_Order__r.No_Picking_Package_Shipment_Required__c,Is_Credit_Updated__c,Inventory_Status__c from Order_Lines__r)from Sigma_Order__c where ID =:PaidAmountMap.keyset()];
         Decimal Amounttoupdate =0;
		for(Sigma_Order__c So:SigmaOrders)
		{
			So.Paid_Amount__c = PaidAmountMap.get(So.Id);
			So.Orders_Status__c = 'Order Confirmed';
            if(payment.Status__c == 'Completed')
                {
                    So.Is_Payment_Made__c = true;
                }
			for(Product_Order_Price_Book__c orderline:So.Order_Lines__r)
			{
				if(orderline.Order_Status__c == 'Pending')
				Amounttoupdate += orderline.Total_Price__c;
				orderline.Order_Status__c = 'Order Confirmed';
				if(orderline.Stock_Fulfilled__c == true && orderline.Sigma_Order__r.Auto_Allocate__c && orderline.IsInventoryUpdated__c ==false && orderline.Order_Status__c == 'Order Confirmed' && orderline.Sigma_Order__r.Order_Created_Via__c !='Time Based Inventory')
				{
					allocatedorderLines.add(orderline);
				}
				if(orderline.Sigma_Order__r.Order_Created_Via__c =='Time Based Inventory')
				{
					timebasedorderline.add(orderline);
				}
				OrderLines.add(orderline);
			}
		}
		
		if(OrderLines.size()>0)
		{
			Update OrderLines;
		}
		if(SigmaOrders.size()>0)
		{
			Update SigmaOrders;
		}
		
		 //code to update credit user details
		if(SigmaOrders[0].Customer_Type__c == 'Credit Customer' )//|| orderObj.Order_Created_Via__c == 'Subscription'
		{   
			DT = [select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: SigmaOrders[0].AccountId__c limit 1 ];
			
			if(DT.Paid_Amount__c == null)
				DT.Paid_Amount__c =0;
			DT.Paid_Amount__c = DT.Paid_Amount__c + payment.Amount_Recevied__c;
			if(Amounttoupdate >0)
			DT.Ordered_Amount__c +=Amounttoupdate;
			update DT;
			system.debug('DT>>'+DT);
		}
		if(allocatedorderLines.size()>0)
		{
			system.debug('inautostock');
			autostockreservation.autostockreserve(allocatedorderLines);
		}
		Boolean Execute;
		if(timebasedorderline.size()>0)
		{
			Execute = AllocateInventoryCntrl.AllocateInventoryforOrder(timebasedorderline);
		}
        
        List<Invoice__c> invoice=new List<Invoice__c>(); 
                invoice = [Select id,name,Invoice_Status__c from Invoice__c where SO__c =:PaidAmountMap.keyset()];
                if(invoice.size()>0)
                {
                    for(Invoice__c inv :invoice )
                    {
                        if(SigmaOrders[0].Orders_Status__c == 'Order Confirmed')
                        { 
                            inv.Invoice_Status__c = 'Paid';
                        }
                    }
                    
                   
                        update invoice;
                    
                }
        
        return payment; 
    }
	@AuraEnabled
    public static Payment__c saveChequePayment(Payment__c payment,List<Sigma_Order__c>order)
    {
		system.debug(order);
        
		
		Id orderId = payment.Sigma_Order__c;  
		Id paymentId = payment.Id;
		Double chargeAmount = payment.Amount__c;     
		Dimension_Tag__c DT;
		List<Product_Order_Price_Book__c> allocatedorderLines =  new List<Product_Order_Price_Book__c>();
		List<Product_Order_Price_Book__c> timebasedorderline = new  List<Product_Order_Price_Book__c>();
		
		//orderObj = [select Status__c,AccountId__c,Customer_Type__c,Orders_Status__c,Total_Payable_Amount__c,Order_Created_Via__c,Quantity__c,Account_Subscription_Interval__c,Due_Amount__c,TotalAmount__c ,Paid_Amount__c,Account_Subscription_Interval__r.Name from Sigma_Order__c where Id =: orderId];       
		
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
        payment.Status__c = 'Completed';
		
		insert payment;   
		system.debug('payment@'+payment);
		
		List<Order_Payment_Relation__c> OrderPayment=  new List<Order_Payment_Relation__c>();
        List<Product_Order_Price_Book__c>OrderLines = new List<Product_Order_Price_Book__c>();
		Map<Id,Decimal>PaidAmountMap = new Map<Id,Decimal>();
		for(Sigma_Order__c SO:order)
		{
            PaidAmountMap.put(SO.Id,SO.Due_Amount__c);
			Order_Payment_Relation__c OPR = New Order_Payment_Relation__c();
			OPR.Sigma_Order__c = SO.Id;
			OPR.Payment__c = payment.id;
			OPR.Amount_Recevied__c = SO.Due_Amount__c;
			OrderPayment.add(OPR);
		}
                
		if(OrderPayment.size()>0)
		{
			Insert OrderPayment;
		}
		List<Sigma_Order__c> SigmaOrders = [Select Id,Name,Orders_Status__c,Paid_Amount__c,Is_Payment_Made__c,Customer_Type__c,AccountId__c,(Select id,Sigma_Order__r.Id,Splited_Order_Line__c,Stock_Fulfilled__c,Sigma_Order__r.Auto_Allocate__c,Sigma_Order__r.Order_Created_Via__c,Order_Status__c,Product__c,Product__r.name,IsInventoryUpdated__c,Sigma_Order__r.Customer_Type__c,Sigma_Order__c,Sigma_Order__r.name,createddate,Sigma_Order__r.AccountId__r.name,Back_Order__c,Total_Price__c,Net_Quantity__c,Sigma_Order__r.No_Picking_Package_Shipment_Required__c,Is_Credit_Updated__c,Inventory_Status__c from Order_Lines__r)from Sigma_Order__c where ID =:PaidAmountMap.keyset()];
        Decimal Amounttoupdate =0;
		for(Sigma_Order__c So:SigmaOrders)
		{
			So.Paid_Amount__c = PaidAmountMap.get(So.Id);
			So.Orders_Status__c = 'Order Confirmed';
             if(payment.Status__c == 'Completed')
                {
                    So.Is_Payment_Made__c = true;
                }
			for(Product_Order_Price_Book__c orderline:So.Order_Lines__r)
			{
				if(orderline.Order_Status__c == 'Pending')
				Amounttoupdate += orderline.Total_Price__c;
				orderline.Order_Status__c = 'Order Confirmed';
				if(orderline.Stock_Fulfilled__c == true && orderline.Sigma_Order__r.Auto_Allocate__c && orderline.IsInventoryUpdated__c ==false && orderline.Order_Status__c == 'Order Confirmed' && orderline.Sigma_Order__r.Order_Created_Via__c !='Time Based Inventory')
				{
					allocatedorderLines.add(orderline);
				}
				if(orderline.Sigma_Order__r.Order_Created_Via__c =='Time Based Inventory')
				{
					timebasedorderline.add(orderline);
				}
				OrderLines.add(orderline);
			}
		}
		
		if(OrderLines.size()>0)
		{
			Update OrderLines;
		}
		if(SigmaOrders.size()>0)
		{
			Update SigmaOrders;
		}
		//code to update credit user details
		if(SigmaOrders[0].Customer_Type__c == 'Credit Customer' )//|| orderObj.Order_Created_Via__c == 'Subscription'
		{   
			DT = [select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: SigmaOrders[0].AccountId__c limit 1 ];
			
			if(DT.Paid_Amount__c == null)
				DT.Paid_Amount__c =0;
			DT.Paid_Amount__c = DT.Paid_Amount__c + payment.Amount_Recevied__c;
			if(Amounttoupdate >0)
			DT.Ordered_Amount__c +=Amounttoupdate;
			update DT;
			system.debug('DT>>'+DT);
		}
		if(allocatedorderLines.size()>0)
		{
			system.debug('inautostock');
			autostockreservation.autostockreserve(allocatedorderLines);
		}
		Boolean Execute;
		if(timebasedorderline.size()>0)
		{
			
			Execute = AllocateInventoryCntrl.AllocateInventoryforOrder(timebasedorderline);
			
		}
        
        List<Invoice__c> invoice=new List<Invoice__c>(); 
                invoice = [Select id,name,Invoice_Status__c from Invoice__c where SO__c =:PaidAmountMap.keyset()];
                if(invoice.size()>0)
                {
                    for(Invoice__c inv :invoice )
                    {
                        if(SigmaOrders[0].Orders_Status__c == 'Order Confirmed')
                        { 
                            inv.Invoice_Status__c = 'Paid';
                        }
                    }
                    
                   
                        update invoice;
                    
                }
        
        return payment; 
    }
	
	@AuraEnabled
    public static Payment__c stripePayment(Payment__c payment,Decimal chargeAmount,String CVV, String expiryMonth, String expiryYear,String zipCode,Decimal paidAmount,String accountid,List<Sigma_Order__c>order)
    {   
        
          
                system.debug('chargeAmount@@'+chargeAmount);
                system.debug('accid@@'+accountid);
                string temp;
                Sigma_Order__c orderObj;
                //Account_Subscription_Intervals__c accsub;
                Dimension_Tag__c DT;
                Id orderId = payment.Sigma_Order__c;  
                Id paymentId = payment.Id;
                
                //  Double chargeAmount = payment.Amount__c;               
                
                List<Product_Order_Price_Book__c> allocatedorderLines =  new List<Product_Order_Price_Book__c>();
                List<Product_Order_Price_Book__c> orderLines =  new List<Product_Order_Price_Book__c>();
				List<Product_Order_Price_Book__c> timebasedorderline = new  List<Product_Order_Price_Book__c>();
                
                
                 //check autostock reserve is true 
                Default_Parameters__c autostockreserve = [select Auto_Reserve_Stock__c from Default_Parameters__c limit 1];
                
                
                if(accountid != null && String.isNotEmpty(accountid))
                {
                    Map<String, String> properties;
                    Map<String, String> metadata;
                    List<Account> acc = new List<Account>();
                    
                    acc = [select id,stripeCustomerId__c,Currency_code__c from Account where id =:accountid limit 1];
                    
                    List<Payment__c> paymentList = new List<Payment__c>();
                                                                                                   
                    
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
                                        //code added by rashmi to update ASI object paid and amount Received feilds on 12-07-2019
                                        
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
                                    payment.Status__c = 'Completed';
                                    paymentList.add(payment);
                                    insert paymentList;
                                    system.debug('paymentList::'+paymentList);      
                                    
                                    
									List<Order_Payment_Relation__c> OrderPayment=  new List<Order_Payment_Relation__c>();
									List<Product_Order_Price_Book__c>OrderLinesvalue = new List<Product_Order_Price_Book__c>();
									Map<Id,Decimal>PaidAmountMap = new Map<Id,Decimal>();
									for(Sigma_Order__c SO:order)
									{
										PaidAmountMap.put(SO.Id,SO.Due_Amount__c);
										Order_Payment_Relation__c OPR = New Order_Payment_Relation__c();
										OPR.Sigma_Order__c = SO.Id;
										OPR.Payment__c = payment.id;
										OPR.Amount_Recevied__c = SO.Due_Amount__c;
										OrderPayment.add(OPR);
									}
											
									if(OrderPayment.size()>0)
									{
										Insert OrderPayment;
									}
									List<Sigma_Order__c> SigmaOrders = [Select Id,Name,Orders_Status__c,Paid_Amount__c,Is_Payment_Made__c,Customer_Type__c,AccountId__c,(Select id,Sigma_Order__r.Id,Splited_Order_Line__c,Stock_Fulfilled__c,Sigma_Order__r.Auto_Allocate__c,Sigma_Order__r.Order_Created_Via__c,Order_Status__c,Product__c,Product__r.name,IsInventoryUpdated__c,Sigma_Order__r.Customer_Type__c,Sigma_Order__c,Sigma_Order__r.name,createddate,Sigma_Order__r.AccountId__r.name,Back_Order__c,Total_Price__c,Net_Quantity__c,Sigma_Order__r.No_Picking_Package_Shipment_Required__c,Is_Credit_Updated__c,Inventory_Status__c from Order_Lines__r)from Sigma_Order__c where ID =:PaidAmountMap.keyset()];
									Decimal Amounttoupdate=0;
									for(Sigma_Order__c So:SigmaOrders)
									{
										So.Paid_Amount__c = PaidAmountMap.get(So.Id);
										So.Orders_Status__c = 'Order Confirmed';
										if(payment.Status__c == 'Completed')
										{
											So.Is_Payment_Made__c = true;
										}
										for(Product_Order_Price_Book__c orderline:So.Order_Lines__r)
										{
											if(orderline.Order_Status__c == 'Pending')
											Amounttoupdate += orderline.Total_Price__c;
											orderline.Order_Status__c = 'Order Confirmed';
											if(orderline.Stock_Fulfilled__c == true && orderline.Sigma_Order__r.Auto_Allocate__c && orderline.IsInventoryUpdated__c ==false && orderline.Order_Status__c == 'Order Confirmed' && orderline.Sigma_Order__r.Order_Created_Via__c !='Time Based Inventory')
											{
												allocatedorderLines.add(orderline);
											}
											if(orderline.Sigma_Order__r.Order_Created_Via__c =='Time Based Inventory')
											{
												timebasedorderline.add(orderline);
											}
											OrderLinesvalue.add(orderline);
										}
									}
									
									if(OrderLinesvalue.size()>0)
									{
										Update OrderLinesvalue;
									}
									if(SigmaOrders.size()>0)
									{
										Update SigmaOrders;
									}
                                    
                                    List<Invoice__c> invoice=new List<Invoice__c>(); 
        invoice = [Select id,name,Invoice_Status__c from Invoice__c where SO__c =:PaidAmountMap.keyset()];
        if(invoice.size()>0)
        {
            for(Invoice__c inv :invoice )
            {
                if(SigmaOrders[0].Orders_Status__c == 'Order Confirmed')
                { 
                    inv.Invoice_Status__c = 'Paid';
                }
            }
            
            
            update invoice;
            
        }
									//code to update credit user details
									if(SigmaOrders[0].Customer_Type__c == 'Credit Customer' )//|| orderObj.Order_Created_Via__c == 'Subscription'
									{   
										DT = [select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: SigmaOrders[0].AccountId__c limit 1 ];
										
										if(DT.Paid_Amount__c == null)
											DT.Paid_Amount__c =0;
										DT.Paid_Amount__c = DT.Paid_Amount__c + payment.Amount_Recevied__c;
										if(Amounttoupdate >0)
										DT.Ordered_Amount__c +=Amounttoupdate;
										update DT;
										system.debug('DT>>'+DT);
									}
                                    
                                    
                                }
                                
                            }
                        
						}
						if(allocatedorderLines.size()>0)
						{
							system.debug('inautostock');
							autostockreservation.autostockreserve(allocatedorderLines);
						}
						Boolean Execute;
						if(timebasedorderline.size()>0)
						{
							
							Execute = AllocateInventoryCntrl.AllocateInventoryforOrder(timebasedorderline);
							
						}
                    
                    
				}
        
        
		return Payment;
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
    public static Payment__c savestdCashPayment(Payment__c payment,List<Order>order)
    {
		system.debug(order);
        
		
		//Id orderId = payment.Order;  
		Id paymentId = payment.Id;
		Double chargeAmount = payment.Amount__c; 
		Dimension_Tag__c DT;
		List<OrderItem> allocatedorderLines =  new List<OrderItem>();
		
		
		//orderObj = [select Status__c,AccountId__c,Customer_Type__c,Orders_Status__c,Total_Payable_Amount__c,Order_Created_Via__c,Quantity__c,Account_Subscription_Interval__c,Due_Amount__c,TotalAmount__c ,Paid_Amount__c,Account_Subscription_Interval__r.Name from Sigma_Order__c where Id =: orderId];       
		
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
		payment.Status__c = 'Completed';
		insert payment;   
		system.debug('payment@'+payment);
		
		List<Order_Payment_Relation__c> OrderPayment=  new List<Order_Payment_Relation__c>();
        List<OrderItem>OrderLines = new List<OrderItem>();
		Map<Id,Decimal>PaidAmountMap = new Map<Id,Decimal>();
		for(Order StdOrder:order)
		{
            PaidAmountMap.put(StdOrder.Id,StdOrder.Due_Amount__c);
			Order_Payment_Relation__c OPR = New Order_Payment_Relation__c();
			OPR.Order__c = StdOrder.Id;
			OPR.Payment__c = payment.id;
			OPR.Amount_Recevied__c = StdOrder.Due_Amount__c;
			OrderPayment.add(OPR);
		}
                
		if(OrderPayment.size()>0)
		{
			Insert OrderPayment;
		}
		List<Order> StdOrders = [Select Id,Name,Orders_Status__c,Paid_Amount__c,Is_Payment_Made__c,Customer_Type__c,AccountId,(Select id,Is_Credit_Updated__c,Splited_Order_Line__c,OrderId,Order.name,Order.Account.name,Order_Status__c,Product2Id,Back_Order__c,Stock_Fulfilled__c,Order.Auto_Allocate__c,Product2.name,Order.Customer_Type__c,TotalPrice__c,TotalPrice,Unit_Price__c,Net_Quantity__c,Quantity,IsInventoryUpdated__c,Order.No_Picking_Package_Shipment_Required__c,Inventory_Status__c from OrderItems)from Order where ID =:PaidAmountMap.keyset()];
        Decimal Amounttoupdate = 0; 
		for(Order So:StdOrders)
		{
			So.Paid_Amount__c = PaidAmountMap.get(So.Id);
			So.Orders_Status__c = 'Order Confirmed';
			if(payment.Status__c == 'Completed')
			{
				So.Is_Payment_Made__c = true;
			}
			for(OrderItem orderline:So.OrderItems)
			{
				if(orderline.Order_Status__c =='Pending')
				Amounttoupdate += orderline.TotalPrice__c;
				orderline.Order_Status__c = 'Order Confirmed';
				if(orderline.Stock_Fulfilled__c == true && orderline.Order.Auto_Allocate__c && orderline.IsInventoryUpdated__c ==false && orderline.Order_Status__c == 'Order Confirmed')
                {
                  allocatedorderLines.add(orderline);
                }
				OrderLines.add(orderline);
			}
		}
		
		if(OrderLines.size()>0)
		{
			Update OrderLines;
		}
		if(StdOrders.size()>0)
		{
			Update StdOrders;
		}
		if(StdOrders[0].Customer_Type__c == 'Credit Customer' )//|| orderObj.Order_Created_Via__c == 'Subscription'
		{   
			DT = [select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: StdOrders[0].AccountId limit 1 ];
			
			if(DT.Paid_Amount__c == null)
				DT.Paid_Amount__c =0;
			DT.Paid_Amount__c = DT.Paid_Amount__c + payment.Amount_Recevied__c;
			if(Amounttoupdate >0)
			DT.Ordered_Amount__c +=Amounttoupdate;
			update DT;
			system.debug('DT>>'+DT);
		}
		if(allocatedorderLines.size()>0)
		{
		  autostockreservation.autostockreserveforOrder(allocatedorderLines);
		}
        List<Invoice__c> invoice=new List<Invoice__c>(); 
        invoice = [Select id,name,Invoice_Status__c from Invoice__c where Orderlookup__c =:PaidAmountMap.keyset()];
        if(invoice.size()>0)
        {
            for(Invoice__c inv :invoice )
            {
                if(StdOrders[0].Orders_Status__c == 'Order Confirmed')
                { 
                    inv.Invoice_Status__c = 'Paid';
                }
            }
            update invoice;
            
        }
        
        return payment; 
    }
	
	@AuraEnabled
    public static Payment__c savestdChequePayment(Payment__c payment,List<Order>order)
    {
		system.debug(order);
        
		
		//Id orderId = payment.Order;  
		Id paymentId = payment.Id;
		Double chargeAmount = payment.Amount__c;   
		Dimension_Tag__c DT;
		List<OrderItem> allocatedorderLines =  new List<OrderItem>();
		
		
		//orderObj = [select Status__c,AccountId__c,Customer_Type__c,Orders_Status__c,Total_Payable_Amount__c,Order_Created_Via__c,Quantity__c,Account_Subscription_Interval__c,Due_Amount__c,TotalAmount__c ,Paid_Amount__c,Account_Subscription_Interval__r.Name from Sigma_Order__c where Id =: orderId];       
		
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
		payment.Status__c = 'Completed';
		insert payment;   
		system.debug('payment@'+payment);
		
		List<Order_Payment_Relation__c> OrderPayment=  new List<Order_Payment_Relation__c>();
        List<OrderItem>OrderLines = new List<OrderItem>();
		Map<Id,Decimal>PaidAmountMap = new Map<Id,Decimal>();
		for(Order StdOrder:order)
		{
            PaidAmountMap.put(StdOrder.Id,StdOrder.Due_Amount__c);
			Order_Payment_Relation__c OPR = New Order_Payment_Relation__c();
			OPR.Order__c = StdOrder.Id;
			OPR.Payment__c = payment.id;
			OPR.Amount_Recevied__c = StdOrder.Due_Amount__c;
			OrderPayment.add(OPR);
		}
                
		if(OrderPayment.size()>0)
		{
			Insert OrderPayment;
		}
		List<Order> StdOrders = [Select Id,Name,Orders_Status__c,Paid_Amount__c,Is_Payment_Made__c,Customer_Type__c,AccountId,(Select id,Is_Credit_Updated__c,Splited_Order_Line__c,OrderId,Order.name,Order.Account.name,Order_Status__c,Product2Id,Back_Order__c,Stock_Fulfilled__c,Order.Auto_Allocate__c,Product2.name,Order.Customer_Type__c,TotalPrice__c,TotalPrice,Unit_Price__c,Net_Quantity__c,Quantity,IsInventoryUpdated__c,Order.No_Picking_Package_Shipment_Required__c,Inventory_Status__c from OrderItems)from Order where ID =:PaidAmountMap.keyset()];
        Decimal Amounttoupdate =0;
		for(Order So:StdOrders)
		{
			So.Paid_Amount__c = PaidAmountMap.get(So.Id);
			So.Orders_Status__c = 'Order Confirmed';
			if(payment.Status__c == 'Completed')
			{
				So.Is_Payment_Made__c = true;
			}
			for(OrderItem orderline:So.OrderItems)
			{
				if(orderline.Order_Status__c =='Pending')
				Amounttoupdate += orderline.TotalPrice__c;
				orderline.Order_Status__c = 'Order Confirmed';
				if(orderline.Stock_Fulfilled__c == true && orderline.Order.Auto_Allocate__c && orderline.IsInventoryUpdated__c ==false && orderline.Order_Status__c == 'Order Confirmed')
                {
                  allocatedorderLines.add(orderline);
                }
				OrderLines.add(orderline);
			}
		}
		
		if(OrderLines.size()>0)
		{
			Update OrderLines;
		}
		if(StdOrders.size()>0)
		{
			Update StdOrders;
		}
		if(StdOrders[0].Customer_Type__c == 'Credit Customer' )//|| orderObj.Order_Created_Via__c == 'Subscription'
		{   
			DT = [select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: StdOrders[0].AccountId limit 1 ];
			
			if(DT.Paid_Amount__c == null)
				DT.Paid_Amount__c =0;
			DT.Paid_Amount__c = DT.Paid_Amount__c + payment.Amount_Recevied__c;
			if(Amounttoupdate >0)
			DT.Ordered_Amount__c +=Amounttoupdate;
			update DT;
			system.debug('DT>>'+DT);
		}
		if(allocatedorderLines.size()>0)
		{
		  autostockreservation.autostockreserveforOrder(allocatedorderLines);
		}
        
                List<Invoice__c> invoice=new List<Invoice__c>(); 
        invoice = [Select id,name,Invoice_Status__c from Invoice__c where Orderlookup__c =:PaidAmountMap.keyset()];
        if(invoice.size()>0)
        {
            for(Invoice__c inv :invoice )
            {
                if(StdOrders[0].Orders_Status__c == 'Order Confirmed')
                { 
                    inv.Invoice_Status__c = 'Paid';
                }
            }
            update invoice;
            
        }
        
        return payment; 
    }
	
	@AuraEnabled
    public static Payment__c stdstripePayment(Payment__c payment,Decimal chargeAmount,String CVV, String expiryMonth, String expiryYear,String zipCode,Decimal paidAmount,String accountid,List<Order>order)
    {   
        
          
                system.debug('chargeAmount@@'+chargeAmount);
                system.debug('accid@@'+accountid);
                string temp;
               
                Dimension_Tag__c DT;
                Id orderId = payment.Sigma_Order__c;  
                Id paymentId = payment.Id;
				List<OrderItem> allocatedorderLines =  new List<OrderItem>();
                 //check autostock reserve is true 
                Default_Parameters__c autostockreserve = [select Auto_Reserve_Stock__c from Default_Parameters__c limit 1];
                
                
                if(accountid != null && String.isNotEmpty(accountid))
                {
                    Map<String, String> properties;
                    Map<String, String> metadata;
                    List<Account> acc = new List<Account>();
                    
                    acc = [select id,stripeCustomerId__c,Currency_code__c from Account where id =:accountid limit 1];
                    
                    List<Payment__c> paymentList = new List<Payment__c>();
                                                                                                   
                    
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
                                        //code added by rashmi to update ASI object paid and amount Received feilds on 12-07-2019
                                        
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
                                   payment.Status__c = 'Completed';
                                    paymentList.add(payment);
                                    insert paymentList;
                                    system.debug('paymentList::'+paymentList);      
                                    
                                    
									List<Order_Payment_Relation__c> OrderPayment=  new List<Order_Payment_Relation__c>();
									List<OrderItem>OrderLines = new List<OrderItem>();
									Map<Id,Decimal>PaidAmountMap = new Map<Id,Decimal>();
									for(Order StdOrder:order)
									{
										PaidAmountMap.put(StdOrder.Id,StdOrder.Due_Amount__c);
										Order_Payment_Relation__c OPR = New Order_Payment_Relation__c();
										OPR.Order__c = StdOrder.Id;
										OPR.Payment__c = payment.id;
										OPR.Amount_Recevied__c = StdOrder.Due_Amount__c;
										OrderPayment.add(OPR);
									}
											
									if(OrderPayment.size()>0)
									{
										Insert OrderPayment;
									}
									List<Order> StdOrders = [Select Id,Name,Orders_Status__c,Paid_Amount__c,Is_Payment_Made__c,Customer_Type__c,AccountId,(Select id,Is_Credit_Updated__c,Splited_Order_Line__c,OrderId,Order.name,Order.Account.name,Order_Status__c,Product2Id,Back_Order__c,Stock_Fulfilled__c,Order.Auto_Allocate__c,Product2.name,Order.Customer_Type__c,TotalPrice__c,TotalPrice,Unit_Price__c,Net_Quantity__c,Quantity,IsInventoryUpdated__c,Order.No_Picking_Package_Shipment_Required__c,Inventory_Status__c from OrderItems)from Order where ID =:PaidAmountMap.keyset()];
									Decimal Amounttoupdate = 0;
									for(Order So:StdOrders)
									{
										So.Paid_Amount__c = PaidAmountMap.get(So.Id);
										So.Orders_Status__c = 'Order Confirmed';
										if(payment.Status__c == 'Completed')
										{
											So.Is_Payment_Made__c = true;
										}
										for(OrderItem orderline:So.OrderItems)
										{
											if(orderline.Order_Status__c =='Pending')
											Amounttoupdate += orderline.TotalPrice__c;
											orderline.Order_Status__c = 'Order Confirmed';
											if(orderline.Stock_Fulfilled__c == true && orderline.Order.Auto_Allocate__c && orderline.IsInventoryUpdated__c ==false && orderline.Order_Status__c == 'Order Confirmed')
											{
											  allocatedorderLines.add(orderline);
											}
											OrderLines.add(orderline);
										}
									}
									
									if(OrderLines.size()>0)
									{
										Update OrderLines;
									}
									if(StdOrders.size()>0)
									{
										Update StdOrders;
									}
                                            List<Invoice__c> invoice=new List<Invoice__c>(); 
        invoice = [Select id,name,Invoice_Status__c from Invoice__c where Orderlookup__c =:PaidAmountMap.keyset()];
        if(invoice.size()>0)
        {
            for(Invoice__c inv :invoice )
            {
                if(StdOrders[0].Orders_Status__c == 'Order Confirmed')
                { 
                    inv.Invoice_Status__c = 'Paid';
                }
            }
            update invoice;
            
        }
									if(StdOrders[0].Customer_Type__c == 'Credit Customer' )//|| orderObj.Order_Created_Via__c == 'Subscription'
									{   
										DT = [select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: StdOrders[0].AccountId limit 1 ];
										
										if(DT.Paid_Amount__c == null)
											DT.Paid_Amount__c =0;
										DT.Paid_Amount__c = DT.Paid_Amount__c + payment.Amount_Recevied__c;
										if(Amounttoupdate >0)
										DT.Ordered_Amount__c +=Amounttoupdate;
										update DT;
										system.debug('DT>>'+DT);
									}
									if(allocatedorderLines.size()>0)
									{
									  autostockreservation.autostockreserveforOrder(allocatedorderLines);
									}
                                    
                                    
								}
                                
                            }
                        
						}
				}
		return Payment;
    }
	
}