global class Payments{

   // public String PublishableKey { get; set; }
           
        //public payment__c payment {get;set;}
        public boolean isValid{get;set;}
        public String CCNumber{get;set;}//24th Nov Anil
        public string CardNo {get;set;}
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
        public String accessToken{get;set;}//27th sep
        public String selectedCard{get;set;}
        
        public String selectedCardtodelete{get;set;}
        
        public String paypalTransID{get;set;}
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
    
    // For getting payment credentials purpose
        public Id accParentId {get;set;}
    
        public string message{get;set;}
    
        public Payments()
        {
            system.debug('Inside Paypal Payment-- ');
            
            //Check box value
            system.debug('In Paypal Payment chckboxvalue---->' + chckboxvalue);
            isGuestUser = false;
            Token =   ApexPages.currentPage().getParameters().get('token');
            accId =   ApexPages.currentPage().getParameters().get('id');
            System.debug('Paypal Token is :'+Token);

           // companyId = [SELECT QSCompanyID__c  FROM Payment_Request_Resopnse_QS__c  WHERE Token__c =:Token LIMIT 1 ];
            isSavedCard = false;
            getCards();
            //
            validateToken(Token);

            year1= String.valueOf(Date.Today().Year());// 23rd sep
            year2 = Integer.valueOf(year1)+ 8;// 23rd sep

            accessToken =  oAuth();//27th sep
            //System.debug('Access Token : '+accessToken);
            expYe = 'Year';
            
        }
    
        public void validateToken(String Token)
        {
           // Payment_Request_Resopnse_QS__c req = [SELECT Id,Amount__c,Addon_Comments__c,CustomerID__c,Description__c,Token__c,QSCompanyID__c from Payment_Request_Resopnse_QS__c where Token__c=:token];
              System.debug('inside validateToken method ');
            if(Token != null ){
            Payment_Request_Response_QS__c req = [SELECT Id,Amount__c,Tax__c,State_Tax_Amount__c,Tax_Amount__c,Net_Transaction_Amount__c,Federal_Tax__c,Federal_Tax_Amount__c,Addon_Comments__c,Description__c,Token__c,QSCompanyID__c,Account__r.id from Payment_Request_Response_QS__c where Token__c=:token limit 1];
             System.debug('requested payment token inside validate token  '+ req );
           // Fill Up the values for transaction
           
           Account accData = [SELECT id,name,type,ParentId FROM Account WHERE id =:req.Account__r.id];
           accParentId = accData.ParentId;
           
           if(accData.type == 'Guest User'){
           
               isGuestUser = true;
           
           }
           
           
           if(req != null){
            
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

            Order ordData = [SELECT id,name,Order_Firstname__c,Order_Lastname__c,Order_Telephone__c,Account_Reference_Email__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry FROM Order WHERE AccountId=:req.account__r.id AND Token__c =:req.Token__c];
            system.debug('ordData new payment::::::::::: '+ordData.Account_Reference_Email__c);
            
            
            AppName = acc.Name;
            discount = acc.discount__c ; 
            System.debug('The discount percentage is:'+discount); 
            system.debug('Account details: '+acc);           
            
           
           //start contact detials
        
            
            FirstName=ordData.Order_Firstname__c;
            LastName=ordData.Order_Lastname__c;
           emailid=ordData.Account_Reference_Email__c;
           emailid=acc.Email__C ;
            email=acc.Email__C ;
            country=ordData.BillingCountry;
            address1=ordData.BillingStreet;
            address2='';
            city=ordData.BillingCity;
            state=ordData.BillingState;
            zip=ordData.BillingPostalCode;zipcode = ordData.BillingPostalCode;
            fax=cont.Fax;

                          
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


    global PageReference makecharge()
    {
        system.debug('Inside makecharge');
          //  PaypalProccessor
          // p = new PaypalProccessor();
          
        Customer_Saved_Card__c savedCardToInsert;
        String card;
        Boolean checkCardExists = true;

        HttpResponse ress;
        Customer_Saved_Card__c csc = new Customer_Saved_Card__c();
        System.debug('chckboxvalue '+chckboxvalue );
         
        payment = new Payment__c();
        System.debug('Existing data:City::: '+p.city+':p.amount = amount::: '+p.amount+'p.CardType = CardType:::  '+ p.CardType+'p.payer = emailid'+p.payer);
        system.debug('chckboxvalue---->' + chckboxvalue);
        p.city = city;
        p.state = state;
        p.zip = zip;
        p.CVV = CVV;
        p.expYe = expYe;
        p.expMo = expMo;
        p.CardNo = CardNo;//'4028398122647025'
        p.CardType = CardType;//'Visa'
        p.FirstName= FirstName;
        p.LastName= LastName;
        p.Country = country;
        p.Addy1 = address1;
        p.Addy2 = address2;
        p.payer = emailid; //'abuy_1294681533_per@gmail.com';
        p.amount = netamount ;
        p.paymentaction='Sale';
        
        system.debug('netamount In Makecharge: '+ netamount);

        Payment_Request_Response_QS__c  valQS = [SELECT Id,Token_StartTime__c,Account__c,Account__r.Id,Amount__c,Token_EndTime__c,Token_Status__c,Addon_Comments__c,AppID__c,Payment_Status__c,Discount_Code__c,Discount_Amount__c,Shipment_Amount__c,Tax__c,Tax_Amount__c from Payment_Request_Response_QS__c where Token__c =:Token limit 1 ];

        Account acc = [SELECT Id,Name,companystate__c,QSCompanyID__c,stripeCustomerId__c,Type,Magento_Guest_ID__c,Is_Guest_User__c from Account where Id =:valQS.Account__r.Id limit 1];
        System.debug('Inside the makecharge Account details is'+acc);

        String savedCardId ;
        PageReference  pg; 
        if(valQS.AppID__c != null)
        {
            Payment_Client__c pc = [SELECT ResponseURL__c FROM Payment_Client__c WHERE AppID__c =: valQS.AppID__c LIMIT 1 ];
            System.debug('payment client '+pc);
            pg = new PageReference(pc.ResponseURL__c );
        }
        

        CardType = CardType.toLowerCase();
        try
        {
            if(chckboxvalue == true)
            {
                
                System.debug('inside savecard()');
                System.debug('CardType.toLowerCase() : '+CardType );    
                System.debug('Save card values :'+ CardType+'::' + expYe+'::' + expMo +'::'+ CardNo +'::'+ FirstName +'::'+ LastName +'::'+ emailid );
               // string Data='{"number":"4111111111111111","type":"visa","payer_id":"pay123","first_name":"imran","last_name":"khan","expire_month":"03","expire_year":"2019"}';//23rd sep
                string Data='{"number":\"'+CardNo+'\","type":\"'+CardType+'\","payer_id":"'+emailid+'","first_name":\"'+FirstName+'\","last_name":\"'+LastName+'\","expire_month":\"'+expMo+'\","expire_year":\"'+expYe+'\"}';
                String url='https://api.sandbox.paypal.com/v1/vault/credit-card';
                System.debug(' request Data  '+Data );
                System.debug('request  url '+url);
               
                
                http hs = new http();
                httpRequest reqs = new httpRequest(); 
                reqs.setEndpoint(url);

                //req.setHeader('Authorization','Bearer A015xpZYjw1jPJByHvM.ox6bF4EtPfD-OPJ8QezVcsDk81M');
                System.debug('inside savecard accessToken'+accessToken);
                reqs.setHeader('Authorization','Bearer '+accessToken);//24th sep
                reqs.setHeader('Content-Type','application/json');
                reqs.setHeader('Accept','application/json');
                reqs.setMethod('POST');
                reqs.setBody(Data);


                system.debug('Request dsgfdg----'+reqs);

                ress = hs.send(reqs);
                System.debug('Httpresponse in makecharge:: '+ress);

                System.debug('paypalprocessor paypal response'+ ress);
                if(ress.getBody() != null)
                {
                    String JSonRes = ress.getBody();//29th sep
                    System.debug('JSonRes Is:: '+ JSonRes);
                    Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(JSonRes);//29th sep
                    savedCardId = String.valueOf(m.get('id'));//29th sep
                    system.debug('savedCardId  : '+savedCardId);//29th sep
                    
                }
                system.debug('Request ______----'+ress.getBody());
                system.debug('Response ______----'+ress);
                system.debug('Access Token : '+accessToken);
                 
                System.debug('card ifnormation :'+p);
                            
                  Integer first = CardNo.length() - 4;
            Integer sec = CardNo.length();
            String mask = CardNo.substring(first,sec );
            String markcardnumb= 'XXXXXXXXXXXX'+String.valueof(mask) ; 
            
                if(Token != null) 
                {
                    Payment_Request_Response_QS__c  qsc = [SELECT Id,Account__r.id from Payment_Request_Response_QS__c where Token__c =:Token limit 1 ];
                    Contact cont = [select id,name,FirstName,LastName FROM Contact WHERE AccountId = :qsc.Account__r.id];
                                
                    // Saving Card details into Customer_Saved_Card                     
                    List<Customer_Saved_Card__c> customerCards = [SELECT id,name,Credit_Card_No__c FROM Customer_Saved_Card__c WHERE SFDC_Account__r.id = :qsc.Account__r.id AND Credit_Card_No__c = :markcardnumb];
                    system.debug('entered card numb::' +markcardnumb);
                    system.debug('Account Details ::' +qsc.Account__r.id );
                    system.debug('customerCards::::::: '+customerCards); 
                    
                  /*  for(Customer_Saved_Card__c cd: customerCards ){
         
         //  String enterednumb= CCNumber.substring(12,16);
         
           String cards= cd.Credit_Card_No__c;
         //  String cardnumb= cards.substring(12,16);
           
           Integer start = CardNo.length()-4;
            Integer endi = CardNo.length();
            
            system.debug('CCNumber :: '+cd);
            
            
            String maskCard1 = CardNo.substring(start,endi);
            String enterednumb= 'XXXXXXXXXXXX'+String.valueof(maskCard1) ; 
            
            Integer start1 = cards.length() - 4;
            Integer endi1 = cards.length();
            String maskCard2 = cards.substring(start1,endi1);
            String cardnumb= 'XXXXXXXXXXXX'+String.valueof(maskCard2) ; 
            
            
            
           System.debug('Card number that you have entered::'+cardnumb);
           System.debug('entere Card number that you have entered::'+enterednumb);
           if(cardnumb == enterednumb ){
             System.debug('inside if::'+cardnumb);
        
          
                    ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.ERROR,'This card is already exists');
                      ApexPages.addMessage(myMsg1);
                      break;
           }
          
           }*/
            if(customerCards.isEmpty())
                    {
                        String maskCard = CardNo.substring((CardNo.length()-4),CardNo.length());
                        checkCardExists = false;
                        String mccard = 'XXXXXXXXXXXX'+String.valueof(maskCard) ;
                        csc.Credit_Card_No__c = mccard ;
                        csc.SFDC_Account__c = qsc.Account__r.id;
                        csc.Customer_Name__c = cont.FirstName+' '+cont.LastName;
                        csc.Card_Type__c = CardType;
                        System.debug('maskCard :::'+mccard );
                        //csc.Paypal_Card_No__c = paypalcard ;  savedCardId 
                        csc.Paypal_Card_No__c = savedCardId ;
                        csc.Status__c = 'Active';
                        csc.UserEmail__c = emailid ;
                        csc.Payment_Vendor__c = 'Paypal';
                    
                    }
              
                
                     
                }
                }
                 
           
                                    
            if(!Test.isRunningTest())
            {      
                message = p.pay();
            }    
            
                
        }Catch(Exception e)
        {
            System.debug('Message Inside Catch ::::::::'+message);
            System.debug('Exception Is:: '+e);
            System.debug('Exception Message Is:: '+e.getMessage()); 
            pg.getParameters().put('responseCode','408');
            return pg;
        } 
        
        System.debug('save card Httpresponse in makecharge:: '+ress);
        System.debug('Message ::::::::'+message);
        
        if(message == '408')
        {
            pg.getParameters().put('responseCode',message);
            return pg;     
        }
           
       // string transactionid = p.transid;
        paypalTransID = p.transid ; 
        
        System.debug('Paypal transid ::'+paypalTransID);
        System.debug('payment details'+message);
        system.debug('#### CVV::' + CVV+' FirstName : '+FirstName);
        system.debug('#### Message::' + message);
        system.debug('#### Transaction Object::' + p);
        system.debug('#### Transaction Object id ::' + p.transid);
        system.debug('#### Transaction Object id ::' + p.transid);
        system.debug('Access Token : '+accessToken);                   
        System.debug('card ifnormation :'+p);       
        System.debug('before into savecard');                  
        System.debug('after savecard inside makecharge');
        
        // Response code 
        String resStatus ; 
        Order order = [SELECT Id, OrdersExtID__c,Payment__c,TotalAmount__c,Tax_Amount__c,Discount_Amount__c,Discount_Code__c,Shipment_Amount__c from Order where Token__c =:Token  ];
        orderId = order.Id;
            
        if(message == 'Created' || message == 'SuccessWithWarning' || message == 'Success')
        { 
            resStatus = '0'; 

            if(checkCardExists == false)
            {
                insert csc;
                System.debug('Paypal Saves Cards List:: '+csc);
            }

            System.debug('Before saving in Payment Obj Email Id is::'+emailid);
            System.debug('Before saving in Payment Obj FirstName is::'+FirstName);

            payment.Amount__c = double.valueOf(netamount);  
            payment.Tax_Amount__c=taxAmount;
            payment.PayPal_Transaction_Id__c = p.transid;
            payment.Transaction_Type__c = 'Direct';
            payment.Customer_Email__c = emailid;
            payment.Status__c = 'Completed';            
            payment.OrderId__c = order.Id;
            payment.PayPal_Response__c = message;
            payment.Pay_request__c = valQS.id;
            payment.Tax_Amount__c = valQS.Tax_Amount__c;
            payment.Tax_Amount__c = valQS.Tax_Amount__c;
            payment.SFDC_Account__c = acc.Id; 
            payment.Customer_SFID__c = acc.Id;
            payment.Customer_Name__c = FirstName +' '+ LastName;
            payment.Customer_Email__c = emailid; 
            payment.Payment_Mode__c ='Card';                

            insert payment;
           StripePayments sp = new StripePayments();
           // sp.SendPaymentReceipt(order.Id);
            paymentInsertId = payment.Id;
            System.debug('Payment Object Values :::'+payment);
            //End Inserting the payment transaction into payment Object 26th Nov
          
            
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
            paypal.Response__c =  String.valueof(ress);
            insert paypal;
            
            
            //Added on 26th April
            Order ordDataToUpdate = [SELECT id,Quantity__c,name,Order_Firstname__c,Order_Lastname__c,Order_Telephone__c,Account_Reference_Email__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry FROM Order WHERE Token__c =:Token];
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
          public PageReference  selectedCardDelete(){
               Customer_Saved_Card__c csp = [ SELECT Id,Credit_Card_No__c,Paypal_Card_No__c,UserEmail__c,Customer_Name__c,SFDC_Account__c  FROM Customer_Saved_Card__c WHERE Credit_Card_No__c =:selectedCardtodelete LIMIT 1 ] ;//and  SFDC_Account__c = :acc_Name
               delete csp;
               return null;
          }
          //till here
         
         
         
         

        // Make payment using Saved Card
    public PageReference  selectedCardPay()
    {
        System.debug('inside selectedCardpay and token ::'+Token );
        
        // PageReference
        PageReference pg;
        Payment_Request_Response_QS__c  valQS = [SELECT Id,Token_StartTime__c,Account__c,Account__r.id,Amount__c,Token_EndTime__c,Token_Status__c,Addon_Comments__c,AppID__c,Payment_Status__c,Tax_Amount__c,Discount_Amount__c,Discount_Code__c,Shipment_Amount__c from Payment_Request_Response_QS__c where Token__c =:Token  ];//25th Nov Anil                         
        if(valQS.AppID__c != null)
        {
            Payment_Client__c pc = [SELECT ResponseURL__c FROM Payment_Client__c WHERE AppID__c =: valQS.AppID__c LIMIT 1 ];
            System.debug('payment client '+pc);
            pg = new PageReference(pc.ResponseURL__c );
        }       
                
        Customer_Saved_Card__c csp = [ SELECT Id,Credit_Card_No__c,Paypal_Card_No__c,UserEmail__c,Customer_Name__c,SFDC_Account__c  FROM Customer_Saved_Card__c WHERE Credit_Card_No__c =:selectedCard and  SFDC_Account__c = :valQS.Account__r.Id  LIMIT 1 ] ;//and  SFDC_Account__c = :acc_Name
        System.debug('Customer_Name__c is::'+csp.Customer_Name__c);
        String pcard = csp.Paypal_Card_No__c ;
        String payer_mail = csp.UserEmail__c ;
        String amount = netamount ;
        String des = 'Saved Card Payment';
        System.debug('paypal card no'+pcard );
        System.debug('paypal payer_mail'+payer_mail);
        System.debug('paypal amount '+amount );
        System.debug('paypal des '+des );       

        // String Data='{"intent":"sale","payer":{"payment_method":"credit_card","funding_instruments":[{"credit_card_token":{"credit_card_id":"CARD-5LE36643KX641925UKRD3VUA","payer_id":"baba@bbb.com"}}]},"transactions":[{"amount":{"total":"159","currency":"USD"},"description":"Auto Renewal"}]}';
        String Data = '{"intent":"sale","payer":{"payment_method":"credit_card","funding_instruments":[{"credit_card_token":{"credit_card_id":\"'+pcard+'\", "payer_id":\"'+payer_mail+'\"}}]},"transactions":[{"amount":{"total":\"'+amount+'\","currency":"USD"},"description":\"'+des+'\"}]}';
        System.debug('Data selectedCardPay'+Data);
        String url='https://api.sandbox.paypal.com/v1/payments/payment';
        System.debug('url selectedCardPay'+url);

        http ho = new http();
        httpRequest reqo = new httpRequest();
        reqo.setEndpoint(url);
        System.debug('selectedCardPay token'+accessToken);
        reqo.setHeader('Authorization','Bearer '+accessToken );
        reqo.setHeader('Accept','application/json');
        reqo.setHeader('Content-Type','application/json');
        reqo.setBody(Data);
        reqo.setTimeOut(120000);//24th NOv anil
        reqo.setMethod('POST');
        httpResponse reso;
        try
        { 
            reso = ho.send(reqo);
            System.debug('selectedCardPay Response is:: '+reso);
        }
        catch(System.CalloutException e)
        {
            System.debug('Paypal Time Out Exception Occured : '+e);
            System.debug('Paypal selected Card Pay Message Is:: '+e.getMessage());  
            pg.getParameters().put('responseCode','408');
            return pg;
        } 
        System.debug('respnse Paypal selected Card status: '+reso.getStatus());

        String resStatus  ;
        Order order = [SELECT Id, OrdersExtID__c,Payment__c,Tax_Amount__c,Discount_Amount__c,Discount_Code__c,Shipment_Amount__c from Order where Token__c =:Token  ];             
        orderId = order.Id;
        
        //if(reso.getStatus() == 'Created'){ resStatus = '0'; }else { resStatus = '1'; }
        
        String JSonReso = '';
        Map<String, Object> mo ;

        if(reso.getBody() != null && reso.getStatus() == 'Created')
        {   
            resStatus = '0';
            
            JSonReso = reso.getBody();
            System.debug(' JSonRes '+ JSonReso);
            mo = (Map<String, Object>)JSON.deserializeUntyped(JSonReso);
            System.debug('response selectedCardPay'+mo);
            System.debug('response selectedCardPay id'+String.valueOf(mo.get('id')));
            System.debug('response selectedCardPay transactions '+String.valueOf(mo.get('transactions')));
           
            System.debug('response renewals selectedCardPay transaction '+mo.get('transactions'));
            String trans = String.valueOf(mo.get('transactions')) ;
            System.debug('Transcatoin details of saved card'+trans);
            // Transaction Id code Starts
            if(trans != null )
            {
                String jsonstr = (String)JSON.serialize(mo.get('transactions'));
                jsonstr = jsonstr.substring(1,jsonstr.length()-1);
                
                Map<String, Object> root2 = (Map<String, Object>)JSON.deserializeUntyped(jsonstr);
                System.debug('roooooooooot2 : '+root2.get('related_resources'));
                String jsonstr2 = (String)JSON.serialize(root2.get('related_resources'));
                jsonstr2 = jsonstr2.substring(1,jsonstr2.length()-1);
                
                System.debug(' jsonstr2 string : '+jsonstr2);      
              
                Map<String, Object> root3 = (Map<String, Object>)JSON.deserializeUntyped(jsonstr2);
                 System.debug('Mapzzzzzzzzzzz : '+root3);
                String jsonstr3 = (String)JSON.serialize(root3.get('sale'));
                System.debug('roooooooooot3 : '+root3.get('sale'));
                
                
                Object objstr = jsonstr3;
                Map<String, Object> root4 = (Map<String, Object>)JSON.deserializeUntyped(jsonstr3);
                
                 System.debug('Map222222222 : '+objstr );
                 System.debug('Map3333333333 : '+jsonstr3);
                 
                System.debug('Map11111 : '+root4.get('id'));
              
                System.debug('Transaction Id : '+root4.get('id'));
                paypalTransID = String.valueOf(root4.get('id'));

                System.debug('Transaction Id String '+paypalTransID);
                
                if(root4.get('id') != null)
                {
                     //Start Inserting the payment transaction into payment Object 26th Nov
                      System.debug('companyId ::::::'+companyId);                    
                      Payment__c payment = new Payment__c();
                      System.debug('Customer_Name__c is in payment::'+csp.Customer_Name__c +'Email is:::'+csp.UserEmail__c);
                      payment.Amount__c = Decimal.valueOf(netamount);  
                      payment.PayPal_Transaction_Id__c = paypalTransID;
                      payment.Transaction_Type__c = 'Direct';
                      payment.Customer_Name__c = csp.Customer_Name__c ;
                      payment.Customer_Email__c = csp.UserEmail__c;
                      payment.Status__c = 'Completed';
                      //payment.PayPal_Response__c = message;
                      payment.Pay_request__c = valQS.id;
                      payment.Tax_Amount__c = valQS.Tax_Amount__c;
                      payment.SFDC_Account__c = valQS.Account__r.Id; 
                      payment.Customer_SFID__c = valQS.Account__r.Id;
                      payment.OrderId__c = order.Id;
                      payment.Payment_Mode__c='Card';
                    
                    insert payment;
                    StripePayments sp = new StripePayments();
                   // sp.SendPaymentReceipt(order.Id);
                    
                    paymentInsertId = payment.Id;
                    System.debug('Payment Object Values paymentInsertId :::'+paymentInsertId );
                    System.debug('Payment Object Values :::'+payment);
                    //End Inserting the payment transaction into payment Object 26th Nov
                      
                     
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
                    paypal.Response__c =  String.valueof(reso);
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
                        orderPayment.Amount__c = Double.valueOf(amount);
                        orderPayment.Payment_Type__c = 'Charge';
                        orderPayment.Payment_Type__c = 'Payment Success';
                        orderPayment.Quantity__c = ordDataToUpdate.Quantity__c;
                        insert orderPayment;
                    }                  
                      
                    
                }   
                //Transaction Id code ends
                System.debug('trans ::'+trans);
            }
        }
        else
        {
            resStatus = '1';
            pg.getParameters().put('resStatus',resStatus);
            return pg;
        }
 
        System.debug('Token ::::'+Token+' paypalTransID :::'+paypalTransID+'  resStatus:::'+resStatus);//22nd NOV
      
        System.debug('URL QS ::::'+pg);
        
        pg.getParameters().put('responseToken',Token);
        pg.getParameters().put('responseCode',resStatus);
        pg.getParameters().put('transactionId',paypalTransID);
        pg.getParameters().put('amount',amount);
        pg.getParameters().put('sfexid',order.OrdersExtID__c);
        pg.getParameters().put('tax',String.valueOf(order.Tax_Amount__c));
        return pg;
        
    }

// Paypal selected Pay Ends -----------------------------------------

   /*     public void doCapture(){
          //  PaypalProccessor p = new PaypalProccessor();
            p.AuthorizationID= '19844009Y0177661P';
            p.type='DoCapture';
            string message = p.payCapture();
            system.debug('#### Message::' + message);
            system.debug('#### Transaction Object::' + p);

        }

        public void dovoid(){
           // PaypalProccessor p = new PaypalProccessor();
            p.AuthorizationID= '2C4646411C607633K';
            p.type='Dovoid';
            string message = p.payCapture();
            system.debug('#### Message::' + message);
            system.debug('#### Transaction Object::' + p);

        }

        public void doRefund(){
          //  PaypalProccessor p = new PaypalProccessor();
            p.AuthorizationID= '35T45729AB827132H';
            p.type='Refund';
            string message = p.payCapture();
            system.debug('#### Message::' + message);
            system.debug('#### Transaction Object::' + p);

        }
 */
        /* 
        public void savecard(){
           System.debug('inside savecard()');
         //  p = new PaypalProccessor();
            CardType = CardType.toLowerCase();
            p.expYe = expYe; //'2016';//
            p.expMo = expMo; //'10';//
            p.CardNo = CardNo; // '402839812264702';
            p.CardType = CardType.toLowerCase(); //'visa';//;
            p.FirstName= FirstName; //'test';//
            p.LastName = LastName ;
            p.payer = emailid ;
            p.CVV = CVV ;
            System.debug('CardType.toLowerCase() : '+p.CardType);
            System.debug('Save card values :'+ CardType+'::' + expYe+'::' + expMo +'::'+ CardNo +'::'+ FirstName +'::'+ LastName +'::'+ emailid );
           // string Data='{"number":"4111111111111111","type":"visa","payer_id":"pay123","first_name":"imran","last_name":"khan","expire_month":"03","expire_year":"2019"}';//23rd sep
            string Data='{"number":\"'+CardNo+'\","type":\"'+CardType+'\","payer_id":"'+emailid+'","first_name":\"'+FirstName+'\","last_name":\"'+LastName+'\","expire_month":\"'+expMo+'\","expire_year":\"'+expYe+'\","CVV2":\"'+CVV+'\"}';
            String url='https://api.sandbox.paypal.com/v1/vault/credit-card/';
            System.debug('Data '+Data+' ||| URL '+url);
            String  paypalcard = p.savecard(Data,url,accessToken);
            System.debug('card ifnormation :'+p);
            System.debug('paypalcard  ID is :'+ paypalcard );

            if(Token != null) {
            Payment_Request_Resopnse_QS__c  qsc = [SELECT Id,QSCompanyID__c from Payment_Request_Resopnse_QS__c where Token__c =:Token  ];

            // Saving Card details into Customer_Saved_Card
            Customer_Saved_Card__c csc = new Customer_Saved_Card__c();
            csc.AppName__c = 'QuickSolar';
            //csc.Credit_Card_No__c  = CardNo;
            String maskCard = CardNo.substring(12,16);
            String mccard = 'XXXXXXXXXXXX'+String.valueof(maskCard) ;
            csc.Credit_Card_No__c = mccard ;
            System.debug('maskCard :::'+mccard );
            csc.Paypal_Card_No__c = paypalcard ;
            csc.Status__c = 'Active';
            csc.UserEmail__c = emailid ;
            csc.QSCompanyID__c = qsc.QSCompanyID__c ;
            System.debug('before insert inside savecard');
            insert csc ;
            System.debug('after insert inside savecard');
            
            }
            //System.debug('paypal card(savecard) :'+p.);
        }

         */  
         
    /*  global Customer_Saved_Card__c savecard(){
        
           String savedCardId ;
           String card;
           System.debug('inside savecard()');
         
            CardType = CardType.toLowerCase();
       
            System.debug('Save card values :'+ CardType+'::' + expYe+'::' + expMo +'::'+ CardNo +'::'+ FirstName +'::'+ LastName +'::'+ emailid );
           // string Data='{"number":"4111111111111111","type":"visa","payer_id":"pay123","first_name":"imran","last_name":"khan","expire_month":"03","expire_year":"2019"}';//23rd sep
            string Data='{"number":\"'+CardNo+'\","type":\"'+CardType+'\","payer_id":"'+emailid+'","first_name":\"'+FirstName+'\","last_name":\"'+LastName+'\","expire_month":\"'+expMo+'\","expire_year":\"'+expYe+'\"}';
            String url='https://api.sandbox.paypal.com/v1/vault/credit-card';
            System.debug(' request Data  '+Data );
            System.debug('request  url '+url);
           
             http hs = new http();
             httpRequest reqs = new httpRequest(); 
             reqs.setEndpoint(url);

             //req.setHeader('Authorization','Bearer A015xpZYjw1jPJByHvM.ox6bF4EtPfD-OPJ8QezVcsDk81M');
             System.debug('inside savecard accessToken'+accessToken);
             reqs.setHeader('Authorization','Bearer '+accessToken);//24th sep
             reqs.setHeader('Content-Type','application/json');
             reqs.setHeader('Accept','application/json');
             reqs.setMethod('POST');
             reqs.setBody(Data);
             
             
             system.debug('Request dsgfdg----'+reqs);
            
             HttpResponse ress = hs.send(reqs);
          
             System.debug('paypalprocessor paypal response'+ ress);
            if(ress.getBody() != null){
                String JSonRes = ress.getBody();//29th sep
                Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(JSonRes);//29th sep
                 savedCardId = String.valueOf(m.get('id'));//29th sep
                system.debug('savedCardId  : '+savedCardId);//29th sep
                
            }
             system.debug('Request ______----'+ress.getBody());
             system.debug('Response ______----'+ress);
             system.debug('Access Token : '+accessToken);
            
            
            
            System.debug('card ifnormation :'+p);
           
            
            String maskCard = CardNo.substring(12,16);
            card = 'XXXXXXXXXXXX'+String.valueof(maskCard);
             Customer_Saved_Card__c csc = new Customer_Saved_Card__c();
            if(Token != null) {
            Payment_Request_Response_QS__c  qsc = [SELECT Id,Account__r.id from Payment_Request_Response_QS__c where Token__c =:Token  ];
            Contact cont = [select id,name,FirstName,LastName FROM Contact WHERE AccountId = :qsc.Account__r.id];
            
            
           
           
            
            List<Customer_Saved_Card__c> customerCards = [SELECT id,name,Credit_Card_No__c FROM Customer_Saved_Card__c WHERE SFDC_Account__r.id = :qsc.Account__r.id AND Credit_Card_No__c = :card];
            
            system.debug('customerCards::::::: '+customerCards);
            
            
            if(customerCards.isEmpty()){
           
            
            String mccard = 'XXXXXXXXXXXX'+String.valueof(maskCard) ;
            csc.Credit_Card_No__c = mccard ;
            csc.SFDC_Account__c = qsc.Account__r.id;
            csc.Customer_Name__c = cont.FirstName+' '+cont.LastName;
            csc.Card_Type__c = CardType;
            System.debug('maskCard :::'+mccard );
            //csc.Paypal_Card_No__c = paypalcard ;  savedCardId 
            csc.Paypal_Card_No__c = savedCardId ;
            csc.Status__c = 'Active';
            csc.UserEmail__c = emailid ;
            
           }
           
            System.debug('before insert inside savecard');
         
            System.debug('after insert inside savecard');
            
            }
            
            return csc;
        }
*/
        public String oAuth()
        {
            p = new PaypalProccessor();
            
            System.debug('accParentId IS:: '+ accParentId);
            String result = p.fetchCredentials(accParentId);            
            if(result == 'Success')
            {    
                
                    accessToken = p.oAuth();//27th sep
                   //accessToken = 'A101.eqVzFFB-IH2QwwjELgOh5vp0huews4vtTYn5T-UVKKtIJA57WHv_DY98l5hAirKk.REDEou638ymP7htgy-B04jFa1t4';
                    return accessToken;
                          
                                         
            }
            else
            {
                return '';
            }
            
            
            //accessToken = p.oAuth(); //27th sep
            //return accessToken; 
            
        }


       

    /*    public void getcarddetails(){
           System.debug('inside getcarddetails ::');
          p = new PaypalProccessor();
            //string Cardid='CARD-1KB34113JU747640PKPHWTZY';
            //string Cardid='CARD-2FN58463T2251420KKQTFRLY';//24th sep
            string Cardid='CARD-5LE36643KX641925UKRD3VUA';
            p.getdata(Cardid);

        }
    */

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
                
                cards = [SELECT Id,Credit_Card_No__c FROM Customer_Saved_Card__c WHERE SFDC_Account__c =:qst.Account__r.Id AND Payment_Vendor__c =: 'Paypal'];
               
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
             Payment_Request_Response_QS__c  valQS = [SELECT Id,Token_StartTime__c,Account__c,Amount__c,Token_EndTime__c,Token_Status__c,Addon_Comments__c,AppID__c,Payment_Status__c,Discount_Code__c,Discount_Amount__c,Shipment_Amount__c,Tax__c,Tax_Amount__c from Payment_Request_Response_QS__c where Token__c =:Token  ];
                    if(valQS.AppID__c == 'PC00001'){
                         pg = new PageReference('http://54.152.80.57');
                    }else{
                        pg = new PageReference('http://54.152.80.57/demo');
                    }
             
            return pg ;
        }

        public PageReference cancelPayment(){
            PageReference pg;
            Payment_Request_Response_QS__c  valQS = [SELECT Id,Token_StartTime__c,Account__c,Amount__c,Token_EndTime__c,Token_Status__c,Addon_Comments__c,AppID__c,Payment_Status__c,Discount_Code__c,Discount_Amount__c,Shipment_Amount__c,Tax__c,Tax_Amount__c from Payment_Request_Response_QS__c where Token__c =:Token  ];
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
        
       // Calculate the tax based on state 
       
     /*  public void CalcTax(String state){ 
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
             // flag3 = true;
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
        { 
        // Added on 24th Nov Anil
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
                    System.debug('Card Type Is: '+CardType);
                    
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
        
        public string creditCardType(String ccNumber){
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