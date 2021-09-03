global class StripePayments{

        public String PublishableKey { get; set; }
        public String StripeScretKey {get;set;}
               
            //public payment__c payment {get;set;}
            public boolean isValid{get;set;}
            public String CCNumber{get;set;}//24th Nov Anil
            public string CardNo {get;set;}
            public string card {get;set;}
            public string expYe {get;set;}
            public string expMo {get;set;}
            public string CardType {get;set;}
            public string CVV {get;set;}
            

            public string FirstName {get;set;}
            public string LastName {get;set;}
            public string emailid {get;set;}
            public string amount {get;set;}
            public Decimal taxAmount{get;set;}
            public string address1 {get;set;}
            public string address2 {get;set;}
            public string city {get;set;}
            public string state{get;set;}
            public string country{get;set;}
            public string zip{get;set;}
            public String zipcode{get;set;}
            public String fax{get;set;}
            public String email{get;set;}
            public String customerName{get;set;}
            // public String email{get;set;}

            public String paymentType{get;set;}
            public Decimal companyId {get;set;}
            public String AppID{get;set;}
            public String AppName{get;set;}
            public String AppSecurityToken{get;set;}
            public String AddonComments{get;set;}
            public String Token{get;set;}
            public Boolean isSavedCard{get;set;}
            public String totalAmount{get;set;}
            public String taxRate {get;set;}
            public Decimal discount{get;set;}
            public String intialAmount{get;set;}
            public Double tax{get;set;}

          
            public List<String> yearList{get;set;}
            public String year1{get;set;} 
            public Integer year2{get;set;}//23rd sep
            public String selectedCard{get;set;}
            
            public String selectedCardtodelete{get;set;}
            
            public String paypalTransID{get;set;}
            public static Map<Id,String> AutoRenwMap{get;set;}//19th Nov
            public static List<Id> AutoRenwList{get;set;}
            PaypalProccessor p = new PaypalProccessor();
            
            public boolean flag{get;set;}//25th Nov 
            public boolean flag2{get;set;}//26th Nov
            public boolean flag3{get;set;}
             
            // For Check box value 13-03-2015
            public Boolean chckboxvalue{get;set;} 
            public String paymentInsertId = '';
            public String accId{get;set;}
            public String acc_Name = '';

            //contact details     
            
            public string contFirstName{get;set;}
            public string contLastName{get;set;}
            public string contEmail{get;set;}        
            public string contCity {get;set;}
            public string contState{get;set;}
            public string contCountry{get;set;}
            public string contFax{get;set;}
            public string contPostcode{get;set;}
            
            public boolean isGuestUser{get;set;}
            
            //public Tax__c tax{get{if(null==tax)tax=new Tax__c(); return tax;}set;}
            
            public String paymentDesc{get;set;}

            public String stateTax{get;set;}
           // public Double tax{get;set;}
            public Double taxAmt {get;set;}
            public Double stateTaxAmt{get;set;}
            public Double federalTaxRate{get;set;}
            public Double federalTaxAmt{get;set;}
            
            
           // public String selectedCard{get;set;}

            //public String paypalTransID{get;set;}
        
            //public Boolean isSavedCard{get;set;}

            public Double discountAmount{get;set;}
            public String netamount{get;set;}
            //public String AddonComments{get;set;}
            //public String paymentType{get;set;}
            
            public Payment__c payment{get;set;}
            Payment_Request_Response_PayPal__c paypal{get;set;}
            
            public Double discount_amount{get;set;}
            public String discount_code{get;set;}
            public Decimal shipping_amount{get;set;}
            public Double totalTax_amount{get;set;}
            public String orderID{get;set;}
            
            // 07
            public String PaymentToken = '';
            public String stripetoken{get;set;}
            public String customerId {get;set;}
            public String description{get;set;}
            public String stripecustId{get;set;}
            public Boolean Dispalycustomer{get;set;}
            public String selectedoption{get;set;}

            public StripePayments()
            {
              

               System.debug('--Inside Stripe Payment----' );
                
                //Check box value
               system.debug('chckboxvalue---->' + chckboxvalue);
                isGuestUser = false;
                Token =   ApexPages.currentPage().getParameters().get('token');
                customerId = Token;
                accId =   ApexPages.currentPage().getParameters().get('id');
                System.debug('Token is :'+Token);

               // companyId = [SELECT QSCompanyID__c  FROM Payment_Request_Resopnse_QS__c  WHERE Token__c =:Token LIMIT 1 ];
                isSavedCard = false;
                getCards();
                //
                validateToken(Token);
                
                
                year1= String.valueOf(Date.Today().Year());// 23rd sep
                year2 = Integer.valueOf(year1)+ 8;// 23rd sep
                
                            
               // PaymentToken = ApexPages.currentPage().getParameters().get('stripetoken');
                //PublishableKey='pk_test_S7HgAy2CROeGa4fDzRMaXulx';//StripeAPI.PublishableKey;
              //  chckboxvalue = true;
                        
                expYe = 'Year';
                
            }
        
            public void validateToken(String Token)
            {
          
               // Payment_Request_Resopnse_QS__c req = [SELECT Id,Amount__c,Addon_Comments__c,CustomerID__c,Description__c,Token__c,QSCompanyID__c from Payment_Request_Resopnse_QS__c where Token__c=:token];
                  System.debug('inside validateToken method ');
                if(Token != null )
             {
                Payment_Request_Response_QS__c req = [SELECT Id,Amount__c,Tax__c,State_Tax_Amount__c,Tax_Amount__c,Net_Transaction_Amount__c,Federal_Tax__c,Federal_Tax_Amount__c,Addon_Comments__c,Description__c,Token__c,QSCompanyID__c,Account__r.id from Payment_Request_Response_QS__c where Token__c=:token limit 1];
                 System.debug('requested payment token inside validate token  '+ req );
               // Fill Up the values for transaction
               
              // req.Account__r.id = '0012800000JtXyMAAV';
               Account accData = [SELECT id,name,type,stripeCustomerId__c,QSCompanyID__c,Parent.Stripe_Publishable_Key__c,Parent.Stripe_Secret_Key__c FROM Account WHERE id =:req.Account__r.id];
               
                 System.debug('**** Account Details second if is:***'+accData.stripeCustomerId__c);
                 System.debug('**** Account Details is:***'+accData.stripeCustomerId__c);
                 System.debug('**** Account Stripe_Publishable_Key__c is:***'+accData.Parent.Stripe_Publishable_Key__c);
                 System.debug('**** Account Stripe_Secret_Key__c is:***'+accData.Parent.Stripe_Secret_Key__c);
                 
                 /*PaymentToken= ApexPages.currentPage().getParameters().get('stripetoken');
                 System.debug('Inside the constructor the token is'+PaymentToken); 
                 */
                 
                 //StripeApI Sandbox
                 PublishableKey = accData.Parent.Stripe_Publishable_Key__c; //StripeAPI.PublishableKey;
                 StripeScretKey = accData.Parent.Stripe_Secret_Key__c;
                // PublishableKey='pk_test_S7HgAy2CROeGa4fDzRMaXulx';//StripeAPI.PublishableKey;
                 
                 //StripeApI Production
                 //PublishableKey='pk_live_lar9DzNcxhDjObFpgNT1xboJ';

                 if(accData.stripeCustomerId__c!=null)
                 {
                    stripecustId=accData.stripeCustomerId__c;
                    
                 } 
               
               if(accData.type == 'Guest User'){
               
                   isGuestUser = true;
               
               }
               
               
               if(req != null)
               {
                
                //amount = String.ValueOf(req.Amount__c);
                 // totalAmount= String.ValueOf(req.Amount__c);
                 // System.debug('InitalAmount before tax ::'+totalAmount);
                 
                intialAmount = String.ValueOf(req.Amount__c);
                System.debug('InitalAmount before tax ::'+ intialAmount );
                 
                AddonComments =  req.Addon_Comments__c ;
                PaymentType = req.Description__c ;
                companyId = req.QSCompanyID__c;
                system.debug('Account Id:'+accId+'Account Id:');
               
                Account acc=new Account();
                Contact cont=new Contact();
                
                acc = [SELECT Id,Name,companystate__c,QSCompanyID__c,discount__c,Email__c from Account WHERE id=:req.account__r.id  limit 1];
                cont = [SELECT Id,Name,Email,FirstName,LastName,MailingPostalCode,
                                Fax,MailingCountry,MailingStreet,MailingCity,MailingState
                                 from Contact where AccountId =:req.account__r.id limit 1];

            /*    Order ordData = [SELECT id,name,Order_Firstname__c,Order_Lastname__c,Order_Telephone__c,Account_Reference_Email__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry FROM Order WHERE AccountId=:req.account__r.id AND Token__c =:req.Token__c];
                system.debug('ordData new payment::::::::::: '+ordData);
              */  
                
                AppName = acc.Name;
                discount = 10 ; 
                System.debug('The discount percentage is:'+discount); 
                system.debug('Account details: '+acc);           
                
               
               //start contact detials
            
                
                FirstName='HM';
                LastName='N';
                emailid='hmnaik@gmail.com';
                email='hmnaik@gmail.com';
                country='IND';
                address1='Bng';
                address2='';
                city='BHb';
                state='kar';
                zip='331';zipcode = '321';
                fax='11111';

                //end contact detials
                
                // State value for tax Calc 
                //state = acc.companystate__c;              
                System.debug('State value ::'+state );
                
                //   Calculate the Discount Amount
                   CalcDiscount();
                  
                // Calculate the Tax Amount based on state 
                 // CalcTax(state);
                 
                 // tax calculation
                 System.debug('FirstName'+FirstName+' LastName'+LastName+' emailid'+emailid+'  country'+country+'  state'+state);
                 System.debug('Contact is     '+cont);
                 try{
                
                    tax = req.Tax__c;
                    taxAmt = req.Tax_Amount__c;
                    stateTaxAmt = req.State_Tax_Amount__c;
                    federalTaxRate = req.Federal_Tax__c;
                    federalTaxAmt = req.Federal_Tax_Amount__c ;
                    Decimal netamt = req.Net_Transaction_Amount__c;
                   
                      netamount = String.valueOf(netamt.setScale(2));
                      
                      //netamount = String.valueOf(req.Net_Transaction_Amount__c);
                      
                      system.debug('netamount:::: '+netamount);
                    
                    amount = String.valueOf(req.Net_Transaction_Amount__c);
                    customerName = acc.Name;//(Double.valueof(memberConfig.Member_Amount__c)*federalTaxRate)/100;
                    System.debug('InitalAmount before customerName ::'+ customerName );
                    //stateTaxAmt = Decimal.valueof(stateTaxAmt).setScale(2, RoundingMode.HALF_UP);
                    //federalTaxAmt = Decimal.valueof(federalTaxAmt).setScale(2, RoundingMode.HALF_UP);
                    //taxAmt = (Double.valueof(memberConfig.Member_Amount__c)*tmptax)/100;
                    //taxAmt  = Decimal.valueof(taxAmt).setScale(2, RoundingMode.HALF_UP);
                    system.debug('Tax amount: '+taxAmt);
                    
                /*amount=String.valueOf(temppamount);
                amount=amount.substring(0,amount.length()-2);*/
                amount = intialAmount;
                }catch(Exception e){
                  System.debug('Exception is   '+e);
                  System.debug('exception line  number  is  '+e.getLineNumber());
                }
                 
                 System.debug('CompanyId and name : '+acc.Name +':::'+companyId);
                 System.debug('amount  is'+amount );
                 System.debug('req.Addon_Comments__c'+req.Addon_Comments__c);
              
                 
                 }
            }
              
          }


            public List<SelectOption> getYears() {//23rd sep for getting years dynamically
                List<SelectOption> yearList = new List<SelectOption>();
                yearList.add(new SelectOption('0000','YYYY'));
                for(Integer i=Integer.valueOf(year1);i<=year2;i++){
                    yearList.add(new SelectOption(String.valueOf(i),String.valueOf(i)));
                }
                return yearList;
            }


        // --------------************************************--------------------------------------------

        
        
        // -------------------*************************  END HERE ********-------------------------------------------   
                   
            
    global PageReference makecharge()
    {
       system.debug('Inside makechargeOne');       
        
        Customer_Saved_Card__c csc = new Customer_Saved_Card__c();
        System.debug('chckbox value In makecharge: '+chckboxvalue );

        //payment = new Payment__c();
        system.debug('netamount::::::::::::: '+ netamount);
        system.debug('Token: '+ Token);

        Payment_Request_Response_QS__c  valQS = [SELECT Id,Token_StartTime__c,Account__c,Account__r.Id,Amount__c,Token_EndTime__c,Token_Status__c,Addon_Comments__c,AppID__c,Payment_Status__c,Discount_Code__c,Discount_Amount__c,Shipment_Amount__c,Tax__c,Tax_Amount__c from Payment_Request_Response_QS__c where Token__c =:Token limit 1 ];
        System.debug('Inside the makecharge valQS is: '+valQS);
        Account acc = [SELECT Id,Name,companystate__c,QSCompanyID__c,stripeCustomerId__c,Type,Magento_Guest_ID__c,Is_Guest_User__c from Account where Id =:valQS.Account__r.Id limit 1];
        System.debug('Inside the makecharge Account details is'+acc);

    //  String savedCardId ;
        PageReference  pg; //25th Nov Anil
        if(valQS.AppID__c !=null && Token != Null)
        {
            Payment_Client__c pc = [SELECT ResponseURL__c FROM Payment_Client__c WHERE AppID__c =: valQS.AppID__c LIMIT 1 ];
            pg = new PageReference(pc.ResponseURL__c );
            System.debug('page reference link'+pc.ResponseURL__c);
        }

        StripeChargeMld response;
        StripeCustomerMld cusresponse;
        StripeCardMld svestripcard;
     system.debug('Stripe card Numb::'+svestripcard);

        Double amount = Double.valueof(netamount);
        boolean Issaved=false;
        Boolean IsFirstCustomer = false;
        
        try{            
            if(chckboxvalue == true)
            {
                System.debug('stripecustId is:'+stripecustId);
                System.debug('StripeScretKey Is:: '+StripeScretKey);
                     //Stripe cust id is null for this account
                if(stripecustId==null)
                {    
                  //get the Stripe customer id for the account
                      IsFirstCustomer = true;   
                      cusresponse = new StripeCustomerMld();               
                      cusresponse=StripeCustomerMld.create(null,description,StripeScretKey);
                      System.debug('Stripe custer id response:::::'+cusresponse);
                      stripecustId=cusresponse.Id;
                      System.debug('The Strpe customer id is::::'+stripecustId);
                     // System.debug('customer id 07 : '+customerId);
                      
                      
                }else
                {         
                    System.debug('Inside Else id 07 : '+stripecustId);      
                      stripecustId=stripecustId;                
                      
                }
                     //System.debug('user details  ::'+userdetails);
                     System.debug('Token 07 ::'+stripetoken);
                     //Store the card details
                     svestripcard =new StripeCardMld();
                     svestripcard=StripeCardMld.create(stripecustId,stripetoken,StripeScretKey);
                     System.debug('stripcard07 data is:'+svestripcard);
                     String savedStripeId = svestripcard.id;
                     System.debug('stripcard07 data is:'+savedStripeId);   
                        
                        
                     //Card saved successfull
                     if( stripecustId !=null && svestripcard.id!=null )
                     {    
                        response= new StripeChargeMld();
                        Boolean afterCardSave=true;
                        
                              Map<String, String> properties=new Map<String, String>();
                              Map<String, String> metadata=new Map<String, String>();
                              //Stripe payment method
                        response = StripeChargeMld.createAndCharge(savedStripeId,amount,properties, metadata,afterCardSave,stripecustId,StripeScretKey);
                        System.debug('response IS :: '+response);
                        
                        paypalTransID = response.id ;
                        System.debug('Inside paypalTransID Val 07 Is:: '+paypalTransID);
                        
                                            
                     } 
                    
                            
            }
            else
            {
                
                System.debug('Inside make charge Unchecked checkbox value  '+chckboxvalue);
                response= new StripeChargeMld();           
                //Make the charge and card is not save      
                System.debug('StripeScretKey Inide Else :: '+StripeScretKey);
                response=StripeChargeMld.create(stripetoken,amount,Issaved,StripeScretKey);    
                System.debug('This is payment response record:: '+response);
                paypalTransID = response.id ;                   
                //System.debug('Inside response.getStatusCode() Is:: '+response.getStatusCode());
                System.debug('Inside paypalTransID Val Is:: '+paypalTransID);
                
            }
            
        }Catch(Exception e)
        {
            System.debug('Exception Is:: '+e);
            System.debug('Exception Message Is:: '+e.getMessage()); 
            pg.getParameters().put('responseCode','408');
            return pg;
        }    
        
        System.debug('Paypal transid ::'+paypalTransID);
               
        System.debug('after savecard inside makecharge');
        // Response code 
        String resStatus ; 
        Order order = [SELECT Id, OrdersExtID__c,Payment__c,TotalAmount__c,Tax_Amount__c,Discount_Amount__c,Discount_Code__c,Shipment_Amount__c from Order where Token__c =:Token  ];
        orderId = order.Id; 
            
        if(response.id!=null && response.error==null && paypalTransID != null)
        {           
            resStatus = '0'; 
                                
            if(chckboxvalue == true)
            {
                String card_type;
                System.debug('cardType : '+ cardType);
                card_type = cardType.toLowerCase();
                Customer_Saved_Card__c savecards = new Customer_Saved_Card__c();
                savecards.AppName__c = 'Magento';
                savecards.Card_Type__c = card_type;
                savecards.Credit_Card_No__c = 'XXXXXXXXXXXX'+svestripcard.last4;
                savecards.Paypal_Card_No__c = svestripcard.Id;
                savecards.Customer_Name__c = FirstName;
                //07 savecards.Expiry__c = expMo + ' ' + expYe;
                savecards.SFDC_Account__c= valQS.Account__r.Id;                   
                savecards.UserEmail__c = emailid;
                savecards.Payment_Vendor__c = 'Stripe';
               
                System.debug('Before card save the details are'+savecards);
                insert savecards;
             
                System.debug('After Stripe card Save :'+savecards);
            }
            
            // Updating Account Stripe Id
            if(IsFirstCustomer == true && stripecustId != Null)
            {
                acc.stripeCustomerId__c = stripecustId;
                update acc;                 
            }
            
          //Start Inserting the payment transaction into payment Object 26th Nov                 
            System.debug('Before saving in Payment Obj Email Id is::'+emailid);
            System.debug('Before saving in Payment Obj FirstName is::'+FirstName);
            System.debug('Before netamount is::'+amount);                  
              
            Payment__c payment = new Payment__c();  
            payment.Amount__c = amount;                  
            //07 payment.Tax_Amount__c = taxAmount;
            payment.PayPal_Transaction_Id__c = paypalTransID;
            payment.Transaction_Type__c = 'Direct';
            payment.Customer_Email__c = emailid;
            payment.Status__c = 'Completed'; 
            payment.OrderId__c = orderId;
            //  payment.PayPal_Response__c = message;
            payment.Pay_request__c = valQS.id;
            payment.Tax_Amount__c = valQS.Tax_Amount__c;
            payment.SFDC_Account__c = acc.Id; 
            payment.Customer_SFID__c = acc.Id;          
            payment.Customer_Name__c = FirstName +' '+ LastName;
            payment.Customer_Email__c = emailid;  
            payment.Payment_Mode__c='Card';               

            insert payment;
        //  SendPaymentReceipt(orderId);
       
            paymentInsertId = payment.Id;
            System.debug('Payment Object Values :::'+payment);
            //End Inserting the payment transaction into payment Object 26th Nov
          
              
            //acc_Name = valQS.Account__c;
            discount_amount = valQS.Discount_Amount__c;
            discount_code = valQS.Discount_Code__c;
            shipping_amount = valQS.Shipment_Amount__c;
            totalTax_amount = valQS.Tax_Amount__c;
            System.debug('Payment Client id :'+valQS.AppID__c);
            
            paypal = new Payment_Request_Response_PayPal__c();
            // paypal.TransactionID__c = String.valueOf(p.transid);
            paypal.TransactionID__c =   paypalTransID ;
            System.debug('paypal.TransactionID__c :'+paypal.TransactionID__c);
            paypal.Amount__c = valQS.Amount__c;
            paypal.Description__c = PaymentType ;
            paypal.QSCompanyID__c = companyId ;
            paypal.Token__c = Token ;
            paypal.Token_StartTime__c = valQS.Token_StartTime__c ;
            System.debug('Token_StartTime__c '+ valQS.Token_StartTime__c );
            paypal.Token_EndTime__c =  valQS.Token_EndTime__c;
            paypal.Token_Status__c = 'Closed';
            paypal.Payment_Status__c = 'Completed';
            paypal.Customer_Email__c = emailid;
            paypal.Response__c =  String.valueof(response);
            insert paypal;
            
            
            //Added on 26th April
            Order ordDataToUpdate = [SELECT id,name,Quantity__c,Order_Firstname__c,Order_Lastname__c,Order_Telephone__c,Account_Reference_Email__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry FROM Order WHERE Token__c =:Token];
            system.debug('ordData::::::::::: '+ordDataToUpdate );
            ordDataToUpdate.Order_Firstname__c=FirstName;
            ordDataToUpdate.Order_Lastname__c=LastName;
            ordDataToUpdate.Account_Reference_Email__c=emailid;
            ordDataToUpdate.Account_Reference_Email__c=email;
            ordDataToUpdate.BillingCountry=country;
            ordDataToUpdate.BillingStreet=address1;
            ordDataToUpdate.BillingCity=city;
            ordDataToUpdate.BillingState=state;
            ordDataToUpdate.BillingPostalCode=zip;
            ordDataToUpdate.BillingPostalCode=zipcode;
            ordDataToUpdate.Orders_Status__c = 'Order Confirmed';
            ordDataToUpdate.Discount_Code__c=discount_code;
            ordDataToUpdate.Discount_Amount__c=discount_amount;
            ordDataToUpdate.Shipment_Amount__c=shipping_amount;
            ordDataToUpdate.Payment__c = paymentInsertId ;
            //cont.Fax=fax;
            update ordDataToUpdate;
            //Till here         
                
            //orderId = ordDataToUpdate.Id;
    
     
            if(orderId != null && paymentInsertId !=null && paypalTransID != null)
            {
                
                List<Product_Order_Price_Book__c> prodOrderData = [SELECT id,name,Order_Status__c FROM Product_Order_Price_Book__c WHERE Order__c = :orderId];
                System.debug('prodOrderData Is: '+prodOrderData);
                
                for(Product_Order_Price_Book__c prodOrder : prodOrderData)
                {                  
                      prodOrder.Order_Status__c = 'Order Confirmed';
                  
                }                  
                update prodOrderData;   
                System.debug('prodOrderData Is: '+prodOrderData);
                
                Order_Payment__c orderPayment = new Order_Payment__c();
                orderPayment.Order__c = orderId;
                orderPayment.Payment__c = paymentInsertId;
                orderPayment.Amount__c = Double.valueOf(netamount);
                orderPayment.Payment_Type__c = 'Charge';
                orderPayment.Payment_Type__c = 'Payment Success';
                orderPayment.Quantity__c = ordDataToUpdate.Quantity__c;
                insert orderPayment;
            }
            
        }else 
        { 
           resStatus = '1'; 
           pg.getParameters().put('responseCode',resStatus);
           return pg;
           
        } 
        
        if(acc.Is_Guest_User__c == true && acc.Type == 'Guest User')
        {
            pg.getParameters().put('magentoGuestId',acc.Magento_Guest_ID__c);
            pg.getParameters().put('magentoGuestSFId',acc.Id);
            
            acc.Is_Guest_User__c = false;
            update acc;
            System.debug('After Guest USer :: '+ acc.Is_Guest_User__c); 
        }
             
         
        system.debug('Token Final:::::: in makecharge '+Token);
        system.debug('Order Data ------->'+resStatus);
        system.debug('Order Data ------->'+paypalTransID);
        system.debug('Order Data ------->'+netamount);
        system.debug('Order Data ------->'+Order);
           
        System.debug('URL QS ::::'+pg);//25th Nov Anil
        
            
        pg.getParameters().put('responseToken',Token);
        pg.getParameters().put('responseCode',resStatus);
        pg.getParameters().put('transactionId',paypalTransID);
        pg.getParameters().put('amount',netamount);            
        pg.getParameters().put('sfexid',order.OrdersExtID__c);
        pg.getParameters().put('tax',String.valueOf(order.Tax_Amount__c));
              
        return pg;
         // return null;  
    }
             
             
         //Added on 27th
          public PageReference  selectedCardDelete()
          {
               Customer_Saved_Card__c csp = [ SELECT Id,Credit_Card_No__c,Paypal_Card_No__c,UserEmail__c,Customer_Name__c,SFDC_Account__c  FROM Customer_Saved_Card__c WHERE Credit_Card_No__c =:selectedCardtodelete LIMIT 1 ] ;//and  SFDC_Account__c = :acc_Name
               delete csp;
               return null;
          }
              //till here
             
             
 public PageReference SendPaymentReceipt(String orderId)
 {
  // Send Payment Receipt Email
           
              document doc = new document();
    
        system.debug('sendInvoiceMail'+ orderId);
       order orderExt= [SELECT Id,Quantity__c,OrdersExtID__c,Account.Email__c from order where id=:orderId];
        
      PageReference pdf = Page.PaymentReceipt;
    // add parent id to the parameters for standardcontroller
    pdf.getParameters().put('id',orderId);

    // the contents of the attachment from the pdf
    Blob body;

    try {

      // returns the output of the page as a PDF
      body = pdf.getContent();

    // need to pass unit test -- current bug  
    } catch (VisualforceException e) {
      body = Blob.valueOf('Some Text');
    }

    Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
    attach.setContentType('application/pdf');
    attach.setFileName('PaymentReceipt.pdf');
    attach.setInline(false);
    attach.Body = body;
    doc.Body = body;
    doc.name='Invoice'+orderExt.OrdersExtID__c+'.pdf';
    
    doc.FolderId='00l28000000dfTU';
    List<document> documnt =[select id,name from document where name=:doc.name];
    System.debug('inside insert size:'+documnt.size());
        if(documnt.size() == 0)
        {
            System.debug('inside insert doc11:'+[select id,name from document where name=:doc.name]);
            System.debug('inside insert doc:'+doc);
            insert doc;
        }
        
   // orderExt.Account.Email__c ='suma.nb@mindlinkssolution.com';
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setUseSignature(false);
    mail.setToAddresses(new String[] {orderExt.Account.Email__c});
    mail.setSubject('PDF Email Demo');
    mail.setHtmlBody('Here is the email you requested! Check the attachment!');
    mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 

    // Send the email
    List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    system.debug('mailStatus  ' + results  );
   /* if (!results.get(0).isSuccess()) {
        System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
        String errorMessage = results.get(0).getErrors()[0].getMessage();
        system.debug('Mail Error ' + errorMessage );
        return false;
    }else{
      // return true;   
    }*/
    // Email Receipt End
  return null;
 }      
             

        // Make payment using Saved Card
    public PageReference  selectedCardPay()
    {
        System.debug('inside selectedCardpay and token ::'+Token );
            
        System.debug('Inside selected card pay');
        System.debug('Inside the selected charge :: '+stripetoken);
        System.debug('selected asdsadadasdda   '+selectedCard);     
        
        PageReference pg;
        Payment_Request_Response_QS__c  valQS = [SELECT Id,Token_StartTime__c,Account__c,Account__r.id,Amount__c,Token_EndTime__c,Token_Status__c,Addon_Comments__c,AppID__c,QSCompanyID__c,
                                                Payment_Status__c,Tax_Amount__c,Discount_Amount__c,Discount_Code__c,Shipment_Amount__c from Payment_Request_Response_QS__c where Token__c =:Token ];//25th Nov Anil                         
        if(valQS.AppID__c != null)
        {                   
           Payment_Client__c pc = [SELECT ResponseURL__c FROM Payment_Client__c WHERE AppID__c =: valQS.AppID__c LIMIT 1 ];
           System.debug('payment client '+pc);
           pg = new PageReference(pc.ResponseURL__c );
        }
        
        Customer_Saved_Card__c csp; // After Payment Sucess this variable need to access there
        StripeChargeMld response; 
    try
        {               
            System.debug('valQS valQS :07  '+valQS);
            System.debug('valQS sdda :07  '+valQS.Account__r.id);
        
            csp = [ SELECT Id,SFDC_Account__r.stripeCustomerId__c,Credit_Card_No__c,Paypal_Card_No__c,UserEmail__c,Customer_Name__c,QSCompanyID__c FROM Customer_Saved_Card__c WHERE SFDC_Account__r.Id =:valQS.Account__r.Id  AND Credit_Card_No__c =: selectedCard LIMIT 1 ] ;
            System.debug('selected asdsadadasdda :07  '+csp);           
            selectedoption = String.valueOf(csp.Paypal_Card_No__c); 
            System.debug('selectedoption sdda :07  '+selectedoption);

            String stripeCustomerId = csp.SFDC_Account__r.stripeCustomerId__c;
            System.debug('stripeCustomerId In :07  '+stripeCustomerId);

            String payer_mail = csp.UserEmail__c ;
            System.debug('payer_mail IS n :07  '+payer_mail);

            String des = 'Saved Card Payment';
            
            Decimal amountVal = Decimal.valueOf(netamount);

            System.debug('netamount Is: '+netamount);
            System.debug('StripeScretKey Inside selectedCardPay Is:: '+ StripeScretKey);

            System.debug('selected amountVal :'+amount);
            
            // -------------------------  Payment Starts
            
            response= new StripeChargeMld();    
            Boolean afterCardSave=true; 
            Map<String, String> properties=new Map<String, String>();
            Map<String, String> metadata=new Map<String, String>();
            //Stripe payment method

            response = StripeChargeMld.createAndCharge(selectedoption,amountVal,properties, metadata,afterCardSave,stripeCustomerId,StripeScretKey);
            System.debug('response IS :: '+response);
            System.debug('**** The response Id 07::***'+response.Id);
            paypalTransID = response.Id;
                
        }  
        catch(Exception e)
        {
            System.debug('Time Out Exception Occured IN selected Card Pay : '+e);
            System.debug('Exception IN selected Card Pay Message Is:: '+e.getMessage()); 
            pg.getParameters().put('resCode','408');
            return pg;
        }
        
            String resStatus  ;
            Order order = [SELECT Id, OrdersExtID__c,Payment__c,Tax_Amount__c,Discount_Amount__c,Discount_Code__c,Shipment_Amount__c from Order where Token__c =:Token  ];
            orderId = order.Id; 
            
            if(response.id!=null && response.error==null && paypalTransID != null)           
            {
                resStatus = '0';
                System.debug('companyId ::::::'+companyId);
                //Account acc = [SELECT Id,Name,companystate__c,QSCompanyID__c,discount__c from Account where QSCompanyID__c =:companyId limit 1];
                Payment__c payment = new Payment__c();
                System.debug('Customer_Name__c is in payment::'+csp.Customer_Name__c +'Email is:::'+csp.UserEmail__c);
                payment.Amount__c = Decimal.valueOf(netamount);  
                payment.PayPal_Transaction_Id__c = paypalTransID;
                payment.Transaction_Type__c = 'Direct';                 
                payment.Customer_Name__c = csp.Customer_Name__c ;
                payment.Customer_Email__c = csp.UserEmail__c;
                payment.Status__c = 'Completed';       
                payment.Pay_request__c = valQS.id;
                payment.Tax_Amount__c = valQS.Tax_Amount__c;                                    
                payment.OrderId__c = order.Id;
                payment.SFDC_Account__c = valQS.Account__r.Id;
                payment.Customer_SFID__c = valQS.Account__r.Id;
                payment.Payment_Mode__c='Card';
                
                insert payment;
                String OrderID= order.Id;
                //SendPaymentReceipt(OrderID);
                paymentInsertId = payment.Id;
                System.debug('Payment Object Values paymentInsertId :::'+paymentInsertId );
                System.debug('Payment Object Values :::'+payment);
                //End Inserting the payment transaction into payment Object 26th Nov
                  
                 //acc_Name = valQS.Account__c;
                discount_amount = valQS.Discount_Amount__c;
                discount_code = valQS.Discount_Code__c;
                shipping_amount = valQS.Shipment_Amount__c;
                totalTax_amount = valQS.Tax_Amount__c;
                System.debug('Payment Client id :'+valQS.AppID__c);
                
                paypal = new Payment_Request_Response_PayPal__c();
                paypal.TransactionID__c =   paypalTransID ;
                System.debug('paypal.TransactionID__c :'+paypal.TransactionID__c);
                paypal.Amount__c = valQS.Amount__c;
                paypal.Description__c = PaymentType ;
                paypal.QSCompanyID__c = companyId ;
                paypal.Token__c = Token ;
                paypal.Token_StartTime__c = valQS.Token_StartTime__c ;
                System.debug('Token_StartTime__c '+ valQS.Token_StartTime__c );
                paypal.Token_EndTime__c =  valQS.Token_EndTime__c;
                paypal.Token_Status__c = 'Closed';
                paypal.Payment_Status__c = 'Completed';
                paypal.Customer_Email__c = emailid;
                paypal.Response__c =  String.valueof(response);
                insert paypal;
                                
                //Added on 26th April
                Order ordDataToUpdate = [SELECT id,name,Order_Firstname__c,Quantity__c,Order_Lastname__c,Order_Telephone__c,Account_Reference_Email__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry FROM Order WHERE Token__c =:Token];
                system.debug('ordData::::::::::: '+ordDataToUpdate );
                ordDataToUpdate.Order_Firstname__c=FirstName;
                ordDataToUpdate.Order_Lastname__c=LastName;
                ordDataToUpdate.Account_Reference_Email__c=emailid;
                ordDataToUpdate.Account_Reference_Email__c=email;
                ordDataToUpdate.BillingCountry=country;
                ordDataToUpdate.BillingStreet=address1;
                ordDataToUpdate.BillingCity=city;
                ordDataToUpdate.BillingState=state;
                ordDataToUpdate.BillingPostalCode=zip;
                ordDataToUpdate.BillingPostalCode=zipcode;
                ordDataToUpdate.Orders_Status__c = 'Order Confirmed';
                ordDataToUpdate.Discount_Code__c=discount_code;
                ordDataToUpdate.Discount_Amount__c=discount_amount;
                ordDataToUpdate.Shipment_Amount__c=shipping_amount;
                ordDataToUpdate.Payment__c = paymentInsertId ;
                //cont.Fax=fax;
                update ordDataToUpdate;
         
                if(orderId != null && paymentInsertId !=null && paypalTransID != null)
                {                   
                    List<Product_Order_Price_Book__c> prodOrderData = [SELECT id,name,Order_Status__c FROM Product_Order_Price_Book__c WHERE Order__c = :orderId];
                    System.debug('prodOrderData Is: '+prodOrderData);
                    
                    for(Product_Order_Price_Book__c prodOrder : prodOrderData)
                    {                  
                          prodOrder.Order_Status__c = 'Order Confirmed';
                      
                    }                  
                    update prodOrderData;   
                    System.debug('prodOrderData Is: '+prodOrderData);
                    
                    Order_Payment__c orderPayment = new Order_Payment__c();
                    orderPayment.Order__c = orderId;
                    orderPayment.Payment__c = paymentInsertId;
                    orderPayment.Amount__c = Double.valueOf(netamount);
                    orderPayment.Payment_Type__c = 'Charge';
                    orderPayment.Payment_Type__c = 'Payment Success';
                    orderPayment.Quantity__c = ordDataToUpdate.Quantity__c;
                    insert orderPayment;
                }                  
                  

            }   
            else
            {
                 resStatus = '1';
                 pg.getParameters().put('resCode',resStatus);
                 return pg;
            }   
                        
            System.debug('Token ::::'+Token+' paypalTransID :::'+paypalTransID+'  resStatus:::'+resStatus);//22nd NOV         
            
            System.debug('URL QS ::::'+pg);//25th Nov Anil
            pg.getParameters().put('responseToken',Token);
            pg.getParameters().put('responseCode',resStatus);
            pg.getParameters().put('transactionId',paypalTransID);
            pg.getParameters().put('amount',netamount);
            pg.getParameters().put('sfexid',order.OrdersExtID__c);
            pg.getParameters().put('tax',String.valueOf(order.Tax_Amount__c));
            return pg;  
         
        }
// End Of Pay Using Exsiting Cards --------------------------------------------




            public void doCapture(){
              //  PaypalProccessor p = new PaypalProccessor();
                p.AuthorizationID= '19844009Y0177661P';
                p.type='DoCapture';
                string message = p.payCapture();
                system.debug('#### Message::' + message);
                system.debug('#### Transaction Object::' + p);

            }

                   

            public void getcarddetails(){
               System.debug('inside getcarddetails ::');
              p = new PaypalProccessor();
                //string Cardid='CARD-1KB34113JU747640PKPHWTZY';
                //string Cardid='CARD-2FN58463T2251420KKQTFRLY';//24th sep
                string Cardid='CARD-5LE36643KX641925UKRD3VUA';
                p.getdata(Cardid);

            }


        public List<SelectOption> getCards()
        {
            String userID = UserInfo.getUserId();
            System.debug('Token :'+Token);
            System.debug('Token userID  :'+userID );
            System.debug('AccID  :'+accId );
            Payment_Request_Response_QS__c qst = [SELECT Id,Account__r.Id,QSCompanyID__c FROM Payment_Request_Response_QS__c  WHERE Token__c=:Token LIMIT 1];

            System.debug('saved credit cards'+qst) ;

            System.debug('payment res cmp Id ::'+qst);
            List<Customer_Saved_Card__c> cards ;
            System.debug('Company ID is ::'+companyId );
            //cards = [SELECT Id,Credit_Card_No__c,SFDC_Account__c,Owner.Id FROM Customer_Saved_Card__c WHERE Owner.Id =:userID and owner.Id!='00528000000gWyzAAE'];
            //if(String.isNotEmpty(accId)){
                cards = [SELECT Id,Credit_Card_No__c FROM Customer_Saved_Card__c WHERE SFDC_Account__c =:qst.Account__r.Id AND Payment_Vendor__c = 'Stripe'];
            // }
            System.debug('list of cards is :'+cards.isEmpty());
            System.debug('list of cards is :'+cards);
            if(!cards.isEmpty()){
             isSavedCard = true;

             } System.debug('getCards isSavedCard is '+isSavedCard);
            System.debug('List of cards ::'+cards );
            // System.debug(cards.Credit_);
            List<SelectOption> cardlist= new List<SelectOption>();
            cardlist.add(new SelectOption('---SelectCard---' ,'---Select Card---'));
             try{
                 for(Customer_Saved_Card__c sc : cards )
                   {
                              cardlist.add(new SelectOption(sc.Credit_Card_No__c,sc.Credit_Card_No__c));
                              System.debug(' Credit cards ::'+sc.Credit_Card_No__c);

                   }

                }
                catch(Exception e){
                     System.debug('getCards exception '+e.getMessage());
                 }
                 
            return cardlist;

        }


            public void deletecard(){
               p = new PaypalProccessor();
                string Cardid='CARD-1KB34113JU747640PKPHWTZY';
                p.deletecard(Cardid);
            }

            public PageReference returnQS(){
                PageReference pg;
                 Payment_Request_Response_QS__c  valQS = [SELECT Id,Token_StartTime__c,Account__c,Amount__c,Token_EndTime__c,Token_Status__c,Addon_Comments__c,AppID__c,Payment_Status__c,Discount_Code__c,Discount_Amount__c,Shipment_Amount__c,Tax__c,Tax_Amount__c from Payment_Request_Response_QS__c where Token__c =:Token limit 1 ];
                        if(valQS.AppID__c == 'PC00001'){
                             pg = new PageReference('http://54.152.80.57');
                        }else{
                            pg = new PageReference('http://54.152.80.57/demo');
                        }
                 
                return pg ;
            }

            public PageReference cancelPayment(){
                PageReference pg;
                Payment_Request_Response_QS__c  valQS = [SELECT Id,Token_StartTime__c,Account__c,Amount__c,Token_EndTime__c,Token_Status__c,Addon_Comments__c,AppID__c,Payment_Status__c,Discount_Code__c,Discount_Amount__c,Shipment_Amount__c,Tax__c,Tax_Amount__c from Payment_Request_Response_QS__c where Token__c =:Token limit 1 ];
                if(valQS.AppID__c == 'PC00001'){
                             pg = new PageReference('http://54.152.80.57');
                        }else{
                            pg = new PageReference('http://54.152.80.57/demo');
                        }
                 
                return pg ;
            }
            
            //Calculate the Discount Amount
            
            public void CalcDiscount(){
            
                     Decimal initamt = (decimal.Valueof(intialAmount)).setScale(2);
                     Decimal discAmount = 0.00;
                     Decimal totdisAmount = 0.00;
                   if(intialAmount  != null){
                      System.debug('inside  intialAmount not equal to null');
                       discAmount  = (initamt*(discount/100.00)).setScale(2);
                       System.debug('The discount amount is :'+discAmount);
                       totdisAmount = initamt - discAmount ; 
                       System.debug('The total Amount after discount'+totdisAmount);
                       totalAmount = String.valueof(totdisAmount);
                       amount = String.valueof(totdisAmount);//Added on 11th Dec when tax calc not required
                       System.debug('The total Amount after dicountString'+totalAmount);
                   }
              
            
            }
            
         /* Code commented because there is no States values in States__c Object. 
         // Calculate the tax based on state        
           public void CalcTax(String state){ 
                  System.debug('State Name : '+state);
                  States__c st = [SELECT Id, Name, TaxAmount__c FROM States__c where Name =: state ];
                  System.debug('State for tax amount::'+st);
                  
                 if(st != null ){      
                 
                   // Calculate Tax 
                  taxRate = String.valueof(st.TaxAmount__c) ;
                  System.debug('TaxRate is ::'+taxRate);
                  
                  Decimal tax = st.TaxAmount__c;
                  Decimal totamt = (decimal.Valueof(totalAmount)).setScale(2);
                  System.debug('Tax amount for calc'+tax);
                  Decimal taxAmount = 0.00 ;
                  //Decimal netAmount = 0.00 ;
                  System.debug('Total amount before calc'+totamt);
                  if(  tax != null){
                      
                      taxAmount  = totamt*(tax/100.00);
                      Decimal toroundtax = taxAmount.setScale(2);
                      
                      System.debug('Tax amount before round calc'+taxAmount);
                      System.debug('Tax amount after round calc'+toroundtax);
                     
                      //netAmount = (totamt + toroundtax).setScale(2) ; 
                      System.debug('The total amount with tax'+netAmount);
                      
                      amount = String.valueof(netAmount);
                      System.debug('The total amount with tax tostring'+netAmount);
                  }
                  
                }
            }
            */
            
            
            public PageReference cardExpirationValidation(){
              PageReference pg =null;
              Integer currentMon = Date.Today().Month();
              Integer currentYear = Date.Today().Year();
              
              Integer expmon = Integer.valueOf(expMo);//Added on 22nd april
              Integer expyear = Integer.valueOf(expYe);//Added on 22nd april

              
              System.debug('Inside CCValidation() method currentMonth :'+currentMon);
              System.debug('Inside CCValidation() method ExpMonth :'+expMo);
              System.debug('Inside CCValidation() method ExpYear :'+expYe);
              
              String currentMonth = String.valueOf(currentMon);
              if(currentMonth.length() == 1 ){
                     currentMonth = '0'+currentMonth; 
              }
              
              system.debug('currentMonth::::::::::: '+currentMonth );
              
              String currentYrMonth = String.valueOf(currentMonth+'/'+currentYear);
              String expYrMonth = String.valueOf(expMo+'/'+expYe);
              system.debug('ExpiryMonth::::::::::: '+ expYrMonth );
              
              if(expYe != '0000' && expmon != 0){ // Added on 22nd April
                  system.debug('ExpiryMonth::::::::::: '+ expYe );
              
              if(!((((expyear > currentYear)&&(expyear!=0000))||((expyear == currentYear) && (currentMon <= expmon))))){
              system.debug('expYrMonth::::::::::: '+ expYrMonth );
              system.debug('currentYrMonth::::::::::: '+ currentYrMonth );
                  flag = false;
                  flag3 = TRUE;
                  flag2 = true;
                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Check Card Expiry');
                  ApexPages.addMessage(myMsg); 
              
              }else{
              
                 flag=false;
                 flag2=false;
              }
         
           
           }else{
           
              flag=false;
              flag2=false;
             }
              
              if('10/2017' > '10/2016'){
                  system.debug('greateryes');
              
              }
              
              if('10/2017' < '10/2016'){
                  system.debug('less');
              
              }
            
              return pg;
              
            }

            public PageReference CCValidation()
            { // Added on 24th Nov Anil
                boolean isNumber = true;//26th Nov Anil
                PageReference pg =null;
                isValid = false;
                
                System.debug('Inside CCValidation() method :'+CCNumber);
               
                
                try{
                    Long x = Long.valueOf(CCNumber);
                }catch(exception e){
                    isNumber = false;
                    
                }
                
                if(CCNumber != ''){
                    if(isNumber == true){
                        flag2 = FALSE;
                        
                        System.debug('Inside If : '+isValid);
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
                        isValid = ( math.mod( sum, 10) == 0 );
                        CardType = creditCardType(CCNumber);
                        System.debug('Credit Card isValid :'+isValid);
                        
                        if(isValid==TRUE && CCNumber.length()>10)
                        {
                            flag=FALSE;
                        }else
                        { flag2=false;
                          flag=TRUE;
                          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid Credit Card Number');
                          ApexPages.addMessage(myMsg); 
                        }
                                
                    }else{
                        flag = false;
                        flag2 = TRUE;
                        ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR,'Enter Digits');
                        ApexPages.addMessage(myMsg2);
                        //return pg;
                    }
                    
                    expMo = '0';
                    //expYe = 'YEAR';
                }

                return pg;
            } 
            
            public string creditCardType(String ccNumber)
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