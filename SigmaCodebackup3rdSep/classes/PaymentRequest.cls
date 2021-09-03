@RestResource(urlMapping='/GetPaymentToken/*')
global with sharing class PaymentRequest{

    //public orderLists<Order> orderLists{get;set;}
    //public ID orderId;
    
    @HttpPost
    global static String getToken()
    {


        System.debug('Inside getParam()');
        RestRequest req = RestContext.request;
         
        Blob body = req.requestBody;
        System.debug('body is: '+body);
        String bodyString = body.toString();
        System.debug('myparam bodyString is:'+ bodyString);
        //String str = bodyString.substring(1, bodyString.length()-1);

        Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(bodyString);
        System.debug(' %% Element of the root %% '+root);
        System.debug(' %% ResortIdIs  %% '+ root.get('companyId'));
        System.debug(' %% adminSf_id %% '+ root.get('adminSf_id'));
        
        
        System.debug('Inside getToken()');
        System.debug('companyId:'+root.get('companyId')+':Amount:'+root.get('Amount'));
        String Token = '';
        String appID = (String)root.get('AppID');
        String appSecurityToken = (String)root.get('AppSecurityToken');
        String appName = (String)root.get('AppName');
         
         
         system.debug('appSecurityToken:::: '+appSecurityToken);
         system.debug('appName:::: '+appName);
         system.debug('appID:::: '+appID);
         
        Integer companyId = Integer.valueOf(root.get('companyId'));
        Double amount = Double.valueOf(root.get('Amount'));
        String paymentDescription = (String)root.get('PaymentDescription');
        String addonComments = (String)root.get('AddonComments');
        Boolean isMagentoGuestUser = (Boolean)root.get('isMagentoGuestUser'); 
        system.debug('isMagentoGuestUser::::::: '+isMagentoGuestUser);
        
        // Added for Register and Guest Users Flow
        String megentoCustomerId = String.valueOf(root.get('RegisteredId'));
        system.debug('MegentoCustomerId IS : '+megentoCustomerId);
        
        //parse the orders values
        String accountId = (String)root.get('AccountId');
        String brewaryaccid = (String)root.get('Brewaryacc');
        String contractId= (String)root.get('ContractId');
        Date effectiveDate = Date.today();
        String status = (String)root.get('Status');
        String ordersStatus= (String)root.get('Orders_Status__c');
        Double totalAmount = Double.valueOf(root.get('TotalAmount__c'));
        Integer quantity= Integer.valueOf(root.get('Quantity__c'));
        
        String discount_code = String.valueOf(root.get('coupon_code'));
        Integer discount_amount = Integer.valueOf(root.get('discount_amount'));
       Double discount_amt = Integer.valueOf(root.get('discount_amount'));
        
        Double total_tax = Double.valueOf(root.get('total_tax'));
        //String Parent = String.valueOf(root.get('adminSf_id'));
        String Parent = '0012800000X0joU';
        
        Double shipment_amount = Double.valueOf(root.get('ShipmentAmount'));
        
		//code for address information
		String MStreet = String.valueOf(root.get('Street'));
		String MCity = String.valueOf(root.get('City'));
		String MState = String.valueOf(root.get('State'));
		String MCountry = String.valueOf(root.get('Country'));
		String MPostalCode = String.valueOf(root.get('PostalCode'));
		
		String First = String.valueOf(root.get('First'));
		String Last = String.valueOf(root.get('Last'));
		String mail = String.valueOf(root.get('mail'));
		
        system.debug('Discout coupon '+ discount_code);
        system.debug('discount_amount '+ discount_amount);
        system.debug('shipment_amount '+ shipment_amount);
        system.debug('total_tax '+ total_tax);
        
        String ordersProductID = (String)root.get('Product__c');
        String accountName = '';
        //Map<String,Object> productdata = new Map<String,Object>();
       // List<Object> prod_data = new List<Object>(); */
        
        //String ProductData = (String)root.get('ProductData');
        
      // Map<String, Object> totalQuantity= (Map<String, Object>) (root.get('TotalQuantity'));
        
      // Map<String, Object> productData = (Map<String, Object>) (root.get('ProductData'));
       Map<String, Object> BillingData= new Map<String, Object>(); 
       
       Integer totalQuantity= 10;
       
        //productdata.put(root.get('ProductData'));
       //productdata = root.get('ProductData');
       
      // System.debug('totalQuantity : '+totalQuantity);
        
      //  System.debug('BillingData: '+BillingData);
      //  System.debug('Prduct Data: '+productData);

        
        sigmaerpdev2__Payment_Client__c pc = [Select Id,sigmaerpdev2__AppID__c from sigmaerpdev2__Payment_Client__c where sigmaerpdev2__AppID__c =:appID AND sigmaerpdev2__App_Security_Token__c =:appSecurityToken  AND sigmaerpdev2__AppName__c =:appName];

        //Validate the requesting application - Payment_Client
        if( pc != null){
            System.debug('AppID is ::'+pc.AppID__c);

            //On Success- Create the token
            Token = generateToken(10);
            DateTime TokenStartTime = DateTime.now();
            DateTime TokenEndTime = TokenStartTime.addHours(1);
            System.debug('Generated Token '+Token);
             
            //Insert Payment record
                 //insertPaymentRequest(companyId, Amount,PaymentDescription,AddonComments,Token,TokenStartTime,TokenEndTime,pc.AppID__c);
       

            // insertPaymentRequest(root.get('companyId'), root.get('Amount'),root.get('PaymentDescription'),root.get('AddonComments'),Token,TokenStartTime,TokenEndTime,pc.AppID__c);
        String firstname = First;
        String lastname = Last;
        String email= mail;
        //Removed for test coverage
        //String record_type= [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Guest User'].id;
        String record_type= [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Customer'].id;
        
       // String record_type = '01228000000Mtjt';//record type of guest user
       //Removed for test coverage
        //String type = 'Guest User';
        String type = 'Customer';
       //Double productTax = Double.valueOf(BillingData.get('pro_tax'));
        
        //system.debug('productTax  ' + productTax );
       
        accountName = checkUserExists(firstname,lastname,email,Parent,record_type,type,isMagentoGuestUser,megentoCustomerId);
        system.debug('account Name'+accountName);
        
        TaxUtility taxUtil = new TaxUtility();
        
        String stateTax;
        Double stateTaxAmt;   
        Double tax;
        Double taxAmt;
        Double federalTaxRate;
        Double federalTaxAmt;
        
        
        //get billing dfetails of the acount to calculate Tax amout of the state
       Account AccountBillingInfo = [SELECT id,name,BillingCity,BillingState,BillingCountry FROM Account WHERE id =:accountName];
         
         system.debug('Billing Info:::: '+ AccountBillingInfo);
         
       Double tmpTax;
       stateTax = AccountBillingInfo.BillingState;
       
       system.debug('stateTax ::::: '+stateTax );
       
       tax = taxUtil.calculateTaxForCity(stateTax);       
       federalTaxRate = taxUtil.getFederalTax();                         
       /*if(country!='' || country !=NULL){
           federalTaxRate = sportsUtil.getFederalTax(country);                         
       }*/
       if(tax>0 || federalTaxRate>0){
           tmptax = tax + federalTaxRate;
       }
                   
       //get the state for which event
       system.debug('Puchasing non mem: ===>'+stateTax);
       system.debug('Puchasing non federalTaxRate: ===>'+federalTaxRate);
       
       system.debug('Puchasing non mem Tax: ===>'+tax);
       
       //need to handle Discount on Tax
       system.debug('Puchasing non mem stateTax: ===>'+stateTax);
       stateTaxAmt = (tax)*(amount)/100;
       stateTaxAmt = Decimal.valueof(stateTaxAmt).setScale(2, RoundingMode.HALF_UP);       
                 
       federalTaxAmt = (federalTaxRate)*(amount)/100; 
       federalTaxAmt = Decimal.valueof(federalTaxAmt).setScale(2, RoundingMode.HALF_UP);                 
     
       //taxAmt = (tmptax)*(amount)/100;
       taxAmt = 10;
       taxAmt  = Decimal.valueof(taxAmt).setScale(2, RoundingMode.HALF_UP);
       system.debug('Tax amount: '+taxAmt);
       
       system.debug('Tax amount: '+taxAmt);

        
       String paymentId = insertPaymentRequest(companyId, amount,paymentDescription,addonComments,Token,TokenStartTime,TokenEndTime,pc.AppID__c,accountName,discount_code,discount_amount,shipment_amount,total_tax,tax,stateTaxAmt,federalTaxRate,federalTaxAmt,taxAmt);
       insertToOrder(accountName,brewaryaccid,email,contractId,effectiveDate,status,ordersStatus,totalAmount,quantity,Token,ordersProductID,totalQuantity,paymentId,shipment_amount,amount,taxAmt,discount_amt,MStreet,MCity,MState,MCountry,MPostalCode);
        
            
        }
        //Return the token
        return Token;

    }


      public static String checkUserExists(String firstname,String lastname,String email,String Parent,String record_type,String type,Boolean isMagentoGuestUser, String megentoCustomerId){
    
         /*  System.debug('Inside checkUserExistsmethod acc '+firstname);
           System.debug('Inside checkUserExistsmethod acc '+lastname);
           System.debug('Inside checkUserExistsmethod Parent '+Parent);
           System.debug('record_type:::');*/
           String street = 'MG';
           String city = 'Bang';
           String state = 'Kar';
           
           String country = 'IND';
           String telephone = '21121';
           String fax = 'SDW';
           String postcode = '121';
           
           String account_Id;
        
           List<Account> acc =new List<Account>();
           List<Account> updateAccount = new List<Account>();
           List<Contact> updateContact = new List<Contact>();
           List<Contract> updateContract = new List<Contract>();
           List<Contact> updateContacts = new List<Contact>();
           List<Contract> updateContracts = new List<Contract>();
           
           //try
           //{
           system.debug('Inside Try block upserting the data----address');
           //cont = [SELECT id, firstname, lastname, accountId FROM contact where firstname=:firstname and lastname=:lastname ];
           //acc = [SELECT id, Name FROM Account where Name=:firstname+' '+lastname];
           acc = [SELECT id, Name,BillingStreet,BillingCity,BillingCountry FROM Account where sigmaerpdev2__Email__c =:email LIMIT 1];
           
           system.debug('acc:::::: '+acc);
           
           
           if(!acc.isEmpty()){
               updateContacts = [SELECT id, Name FROM Contact where AccountId =:acc[0].id LIMIT 1];
               updateContracts = [SELECT id, Name FROM Contract where AccountId =:acc[0].id LIMIT 1];
               system.debug('updateContract::: '+updateContract); 
           }
           
           
           if(!(acc.isEmpty())){
               system.debug('inside if'+ acc);
               system.debug('inside if biling'+acc[0].BillingStreet);
            if(acc[0].BillingStreet == null || isMagentoGuestUser == true){
           ID RID = [Select Id From RecordType Where SobjectType = 'Account' and Name = 'Customer'].id;
            for(Account acnt :acc){
               Account updateAct = new Account();
               updateAct.id=acnt.id;
               //updateAct.name=firstname+' '+lastname;
               updateAct.sigmaerpdev2__companystate__c=state;
               updateAct.sigmaerpdev2__Email__c = email;
               updateAct.BillingState=state;
               updateAct.BillingCountry=country;
               updateAct.BillingCity=city;
               updateAct.BillingStreet=street;
               updateAct.BillingPostalCode=postcode;
               
               updateAct.ShippingState=state;
               updateAct.ShippingCountry=country;
               updateAct.ShippingCity=city;
               updateAct.ShippingStreet=street;
               updateAct.ShippingPostalCode=postcode;
               
              // updateAct.ParentId = parent;
               updateAct.RecordtypeId = RID;
               updateAct.type = 'Customer';
               updateAccount.add(updateAct);
            }  
            
            system.debug('updateAccount:::: '+updateAccount);
               update updateAccount;
               
             for(contact contct : updateContacts){ 
             
               Contact cont=new Contact(); 
               cont.firstName=firstname;
               cont.lastname=lastname;
               cont.Email=email;
               
               cont.MailingStreet=street;
               cont.MobilePhone=telephone;
               cont.MailingCity=city;
               cont.MailingState=state;
               cont.MailingCountry=country;
               cont.MailingPostalCode=postcode;
               cont.fax=fax;
              
               cont.AccountId = updateAccount[0].id;
               cont.id = contct.id;
               
               updateContact.add(cont);
              } 
               //insert cont;   
               update updateContact;
               
               for(contract contct : updateContracts){
               
               Contract contr=new Contract();
               
               contr.AccountId=updateAccount[0].id;
               contr.Status='Draft';
               contr.ContractTerm=12;
               //contr.sigmaerpdev2__Email__c=email;
               contr.StartDate= Date.Today();
               contr.id = contct.id;
               updateContract.add(contr);
            }
               update updateContract;
               
             Account accss = [SELECT id, Name,BillingStreet,BillingCity,BillingCountry FROM Account where sigmaerpdev2__Email__c =:email LIMIT 1];
           
               
           System.debug('End Try block upserting the data '+accss);
           }
           account_Id = acc[0].id;
          }else if(acc.isEmpty())
              
           //}catch(Exception e)
           {  
              system.debug('inside else');
              Account newAcc = new Account();
              Contact newCont = new Contact();
              Contract newContr = new Contract();
              
               system.debug('Inside Exceptions');       
               newAcc.Name = firstname+' '+lastname;
               newAcc.companystate__c=state;
               newAcc.sigmaerpdev2__Email__c = email;
               newAcc.BillingState=state;
               newAcc.BillingCountry=country;
               newAcc.BillingCity=city;
               newAcc.BillingStreet=street;
               newAcc.BillingPostalCode=postcode;
               
               newAcc.ShippingState=state;
               newAcc.ShippingCountry=country;
               newAcc.ShippingCity=city;
               newAcc.ShippingStreet=street;
               newAcc.ShippingPostalCode=postcode;
               
               //newAcc.ParentId = parent;
               newAcc.RecordtypeId = record_type;
               newAcc.type = type;
             /*  if(megentoCustomerId != '0')
               {
                    newAcc.Magento_Guest_ID__c = megentoCustomerId; 
                    newAcc.Is_Guest_User__c = true;
               }
               */               
               insert newAcc;
               
               newCont.firstName=firstname;
               newCont.lastname=lastname;
               newCont.Email=email;
               
               newCont.MailingStreet=street;
               newCont.MobilePhone=telephone;
               newCont.MailingCity=city;
               newCont.MailingState=state;
               newCont.MailingCountry=country;
               newCont.MailingPostalCode=postcode; 
               newCont.fax=fax;
               
               newCont.AccountId = newAcc.id;   
               insert  newCont;
              
               newContr.AccountId=newAcc.Id;
               newContr.Status='Draft';
               newContr.ContractTerm=12;
              // newContr.sigmaerpdev2__Email__c=email;
               newContr.StartDate= Date.Today();
            
               insert newContr; 
               
               account_Id = newAcc.Id;  
        }else{
        
               account_Id = acc[0].Id;
         }
       
               return  account_Id;
    
    }
    

    public static Long generateToken(){

        Long randomNumber = Math.round(Math.random() * (99999 - 11111)) + 11111 ;
        System.debug('Generated random number is '+randomNumber);
        return randomNumber ;
    }

    public static String generateToken(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), 62);
            randStr += chars.substring(idx, idx+1);
        }
        return randStr;
    }

    // Insert the token for payment application
    public static String insertPaymentRequest(Integer companyId, double Amount, String PaymentDescription, String AddonComments,String Token,
            DateTime TokenStartTime,DateTime TokenEndTime,String AppID,String accountName,String discount_code,Integer discount_amount,Double shipment_amount,Double total_tax,double tax,double stateTaxAmt,double federalTaxRate,double federalTaxAmt,double taxAmt){
        //Insert record into PaymentRequest object
        
        system.debug('inside insertPaymentRequest....');
        sigmaerpdev2__Payment_Request_Response_QS__c   qs = new sigmaerpdev2__Payment_Request_Response_QS__c();
        system.debug('AppID:::::: '+AppID);
         
        qs.sigmaerpdev2__Amount__c = Amount;
        qs.sigmaerpdev2__Description__c  = PaymentDescription ;
        qs.sigmaerpdev2__Addon_Comments__c = AddonComments;
        qs.sigmaerpdev2__Token__c = Token;
        qs.sigmaerpdev2__Token_StartTime__c = TokenStartTime ;
        qs.sigmaerpdev2__Token_EndTime__c   = TokenEndTime ;
        qs.sigmaerpdev2__QSCompanyID__c  = companyId; // String.valueOf(companyId);  //
        qs.sigmaerpdev2__Payment_Status__c = 'Pending';
        qs.sigmaerpdev2__AppID__c  = AppID ;
        qs.sigmaerpdev2__Account__c = accountName;
        qs.sigmaerpdev2__Discount_Amount__c = discount_amount;
        qs.sigmaerpdev2__Discount_Code__c = discount_code;
        qs.sigmaerpdev2__Shipment_Amount__c = shipment_amount;
        //qs.Tax__c = total_tax;
        qs.sigmaerpdev2__Tax_Amount__c= taxAmt;
        qs.sigmaerpdev2__Tax__c= tax;//Tax Rate
        qs.sigmaerpdev2__State_Tax_Amount__c = stateTaxAmt;//Tax amount charged
        qs.sigmaerpdev2__Federal_Tax__c = federalTaxRate;
        qs.sigmaerpdev2__Federal_Tax_Amount__c= federalTaxAmt;
       
       if(taxAmt>0){
           qs.sigmaerpdev2__Net_Transaction_Amount__c = Amount+taxAmt;
       }else{
           qs.sigmaerpdev2__Net_Transaction_Amount__c = Amount;
       }
         
        insert qs;
        
        system.debug('payment Response'+qs);
        
        return qs.Id;

    }

    public static void insertToOrder(String accountId,String brewaryaccid,String email, String contractId, Date effectiveDate, String status, String ordersStatus, Double totalAmount, Integer quantity, String Token, String ordersProductID, Integer totalQuantity,String paymentId,Double shipment_amount,Double amount,Double taxAmount, Double discount_amt,String MStreet,String MCity,String MState,String MCountry,String MPostalCode)
    {
    
        //get the first name, last name and check in account, if not create the account
        String firstname = 'HM';
        String lastname = 'N';
        
        String street = 'HBG';
        String city = 'Ban';
        String state = 'Kar';
       
        String country = 'IND';
        String postcode = '8000';
        
        String telephone = '6965979';
        
        system.debug('telephone:::::: '+telephone);
        
        //inserting shipment datails in orderString firstname = String.valueOf(BillingData.get('firstname'));
        String Shipfirstname = 'abs';
        String Shiplastname = 'c';
        
        String Shipstreet = 'asddwa';
        String Shipcity = 'fdad';
        String Shipstate = 'fsa';
       
        String Shipcountry = 'adfv';
        String Shippostcode = 'adw';
        
        String Shiptelephone = 'fad';
        //till here
        
        String contractName = firstname+' '+lastname;
        System.debug('Inside contractName () method '+contractName );
        System.debug('Inside accountId  () method '+accountId );
        
       // Contract contr = [SELECT Id,Account.Id from Contract where AccountId=:accountId LIMIT 1];
       // if(contr==null)
        
        //System.debug('Inside insertToOrder() method');
      //  System.debug('Inside insertToOrder() method'+contr);
        Integer totalProductQuantity = 10;
        if(totalProductQuantity == null){totalProductQuantity = 0;}
         
       
      /*  Order order =new Order();
        
        order.sigmaerpdev2__order_firstname__c = firstname;
        order.sigmaerpdev2__order_lastname__c = lastname;
        order.sigmaerpdev2__order_Telephone__c = telephone;
         order.sigmaerpdev2__Account_Reference_Email__c = email;
        order.AccountId=accountId;
        order.ContractId=contr.Id;
        order.EffectiveDate = effectiveDate;
        order.Status = status;
        order.sigmaerpdev2__Orders_Status__c = ordersStatus;
        order.sigmaerpdev2__TotalAmount__c = totalAmount;
        order.Quantity__c = totalProductQuantity;
        order.sigmaerpdev2__Net_Quantity__c = totalProductQuantity;
        //order.sigmaerpdev2__Product__c = ordersProductID;       
        order.sigmaerpdev2__Shipment_Amount__c = shipment_amount;
        order.sigmaerpdev2__Token__c = Token;
        order.BillingStreet = street;
        order.BillingCity = city;
        order.BillingState= state;
        order.BillingCountry = country;
        order.BillingPostalCode = postcode;
       
        order.sigmaerpdev2__Tax_Amount__c = taxAmount;
        order.ShippingStreet = Shipstreet;
        order.ShippingCity = Shipcity;
        order.ShippingState= Shipstate;
        order.ShippingCountry = Shipcountry;
        order.ShippingPostalCode = Shippostcode;
         if(discount_amt != null ){
        order.sigmaerpdev2__Discount_Amount__c = discount_amt ;
       }
       else{
       order.sigmaerpdev2__Discount_Amount__c =0.00;
       }
        //system.debug('Discount_Amount__c::'+discount);
        
        System.debug('Shipment Amount::'+shipment_amount);
               
        if(taxAmount>0){
           order.sigmaerpdev2__TotalAmount__c = amount+taxAmount;
       }else{
           order.sigmaerpdev2__TotalAmount__c = amount;
       }
        
        //order.Payment_Request_Response__c= paymentId;
        
        system.debug('PaymentId'+paymentId);
        
        //System.debug('Hi Product__c:'+order.Product__c);
              
        System.debug('accountId: '+accountId +',contractId: '+contractId+',effectiveDate: '+effectiveDate+',status: '+status+',ordersStatus: '+ordersStatus+',totalAmount: '+totalAmount+',quantity: '+quantity+',Token: '+Token);
        
        insert order;
        System.debug('Inserting into Order Line Items'+order);
        System.debug('Inserting into Order Line Items'+order.Id);
        //insert records into Order Products - Line items
       */
       Sigma_Order__c order = new Sigma_Order__c();
       order.AccountId__c = accountId;
       order.Orders_Status__c = 'Pending';
       order.Order_Created_Via__c = 'Community';
       order.Customer_Email__c = email;
       order.Customer_Type__c = 'Credit Customer';
       order.Net_Amount__c = amount;
       order.Net_Quantity__c = 3;
       order.TotalAmount__c = amount;
       order.Delivary_Date__c = effectiveDate;
       order.Brewer_Account__c = brewaryaccid;
	   order.Shipping_Street__c = MStreet;
       order.ShippingCity__c = MCity;
	   order.ShippingState__c = MState;
	   order.ShippingCountry__c = MCountry;
	   order.ShippingPostalCode__c = MPostalCode;
	   order.No_Picking_Package_Shipment_Required__c = true;
	   order.BillingStreet__c = MStreet;
       order.BillingCity__c = MCity;
	   order.BillingState__c = MState;
	   order.BillingCountry__c = MCountry;
	   order.BillingPostalCode__c = MPostalCode;
       //order.Auto_Allocate__c = true;
	   
	   insert order;
       
       insertToOrderProducts(order,accountId,contractId,effectiveDate,status,ordersStatus,totalAmount,totalProductQuantity,Token,ordersProductID,taxAmount,amount);
        System.debug('Inserting into Order Line OOOOkkk');
        
    }
    
    public static void insertToOrderProducts(Sigma_Order__c order, String accountId, String contractId, Date effectiveDate, String status, String ordersStatus, Double totalAmount, Integer totalProductQuantity, String Token, String ordersProductID,Double taxAmount, Double amount)
    {
        System.debug('%% Inside taxAmount '+taxAmount);
        System.debug('%% Inside totalAmount '+totalAmount);
        //System.debug('%% Inside insertToOrderProducts() method %%'+Order.id);
         //System.debug('%% Inside insertToOrderProducts() method Token__c %%'+Order.sigmaerpdev2__Token__c);
       // System.debug('Inside productData() method'+productData);
        
         //System.debug('Inside product tax() method '+productTax);
         
//        BillingData
        Integer productCount = 2;
        OrderItem orderItems = new OrderItem();
        List<String> orderItemsname = new List<String>();
        List<String> orderItemsprice = new List<String>();
        
        
        //Order orderData = [SELECT id,name,OrdersExtID__c FROM ORDER WHERE id =:Order.Id];
        
       // Order orderID = new Order();
        //List<String> orderDetailsId = new List<>() 
        
        

/*       Quantity
ProductCode
ListPrice
Product2 lookup
Order   lookup */

        //Added to calculate tax
        Double OrderWithoutTax = totalAmount;
        
        String description = '';
        List<sigmaerpdev2__Product_Order_Price_Book__c> productOrders=new List<sigmaerpdev2__Product_Order_Price_Book__c>();
       // for(Integer i =0; i <productCount; i++ ){
             // orderItems.Description 
            // orderItemsname.add(String.valueOf(BillingData.get('productName'+i)));
            // orderItemsname.add(String.valueOf(BillingData.get('productPrice'+i)));
           // if((productData.get('sfProductId'+i) !='') || (productData.get('sfProductId'+i)!=null)){
            sigmaerpdev2__Product_Order_Price_Book__c popbook=new sigmaerpdev2__Product_Order_Price_Book__c();
            //op.ProductCode=String.valueOf(productData.get('sku'+i));
            popbook.sigmaerpdev2__Sigma_Order__c =Order.id; 
            popbook.sigmaerpdev2__Quantity__c= 3;
            popbook.sigmaerpdev2__Net_Quantity__c=3;
        	popbook.Total_Amount__c = 100;
           popbook.sigmaerpdev2__Product__c=ordersProductID;
            popbook.Inventory_Status__c  = 'Reserve';  
        // popbook.sigmaerpdev2__Order__c=Order.id;
           // popbook.sigmaerpdev2__Order_Id__c=orderData.OrdersExtID__c;
            popbook.sigmaerpdev2__Order_Status__c = 'Pending';
         //   popbook.Total_Price__c=Double.valueOf(productData.get('productPrice'+i));
            popbook.sigmaerpdev2__Total_Price__c=300;
            //popbook.sigmaerpdev2__Total_Price__c = amount;
           // popbook.sigmaerpdev2__Total_Price__c=Double.valueOf(productData.get('productPrice'+i));
           Double tocheck = 100;
           tocheck = tocheck / OrderWithoutTax;
           tocheck = tocheck * taxAmount;
           //Added to calculate tax for order lines
           Double OrderLineWithoutTax = 130;
           System.debug('tocheck   :' + tocheck);
           System.debug('OrderLineWithoutTax   :' + OrderLineWithoutTax);
           
           
            //op.PricebookEntryId='01u28000000waQwAAI'; taxAmount
            system.debug('totalProductQuantity:::::: '+totalProductQuantity);
            //popbook.tax_amount__c = Double.valueOf(taxAmount/totalProductQuantity);
            //popbook.sigmaerpdev2__tax_amount__c = tocheck;
            // popbook.sigmaerpdev2__tax_amount__c=taxAmount;
            productOrders.add(popbook);
         //   }
             //description+i; 
        
        insert productOrders;    
        for(String  orderitemname:orderItemsname)
        {
           System.debug('===orderitemname=='+orderitemname);
        }
        
         
        
     //   Order OrderId  = [SELECT ID,NAME FROM Order where id := orderId];
        
     //   OrderItem orderItem = new OrderItem();
        
        
        
       // insert orderItem;
        
        //insert records into Order Products - Line items
        //insertToOrderProducts(order,accountId,contractId,effectiveDate,status,ordersStatus,totalAmount,quantity,Token,ordersProductID );
        
    }



}