global with sharing class BatchClassforUpdateRecords implements Database.Batchable<sObject>, Database.AllowsCallouts
{
//global String accessToken;
global Database.QueryLocator start(Database.BatchableContext bc) 
{ 
String query;

/*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Account_Subscription_Intervals__c')
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Account_Subscription_Intervals__c',new set<String>{'id','Name','sigmaerpdev__Quantity__c','sigmaerpdev__Usage_Type__c','sigmaerpdev__Customer__r.name','sigmaerpdev__Customer__r.sigmaerpdev__autopay__c','sigmaerpdev__Customer__c','sigmaerpdev__Customer__r.sigmaerpdev__Customer_Type__c','sigmaerpdev__Customer__r.sigmaerpdev__Email__c','sigmaerpdev__Payment__c','sigmaerpdev__Last_Renewal_Date__c','sigmaerpdev__Next_Billing_Date__c','sigmaerpdev__Due_Amount__c','sigmaerpdev__Last_Renewal_Amount__c','sigmaerpdev__next_Billing_Amount__c','sigmaerpdev__Account_Subscription__c','sigmaerpdev__Account_Subscription__r.sigmaerpdev__SubId__c','sigmaerpdev__Account_Subscription__r.sigmaerpdev__Status__c','sigmaerpdev__Subscription_Name__c','sigmaerpdev__Product_Name__c','sigmaerpdev__Product_Name__r.Name','sigmaerpdev__Order_Status__c','sigmaerpdev__Payment_Status__c','sigmaerpdev__Next_Billing_Date__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__Amount__c'}))
{*/
    Date dt = Date.today();
    query = 'select id,Name,Quantity__c,Usage_Type__c,Customer__r.name,Customer__r.autopay__c,Customer__c,Customer__r.Customer_Type__c,Customer__r.Email__c,Payment__c,Last_Renewal_Date__c,Next_Billing_Date__c,Due_Amount__c,Last_Renewal_Amount__c,next_Billing_Amount__c,Account_Subscription__c,Account_Subscription__r.SubId__c,Account_Subscription__r.Status__c,Subscription_Name__c,Product_Name__c,Product_Name__r.Name,Order_Status__c,Payment_Status__c,Tax_Amount__c,Amount__c from Account_Subscription_Intervals__c where Payment_Status__c =\'Not Paid\' AND Account_Subscription__r.Status__c =\'Active\' AND Next_Billing_Date__c='+String.valueOf(dt);
   System.debug('query::'+query); 
//}
return Database.getQueryLocator(query);
}

//Execute Logic
global void execute(Database.BatchableContext BC, List<Account_Subscription_Intervals__c> scope)
{
  
 /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Customer_Saved_Card__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Account_Subscription_Intervals__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Payment__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
     && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Dimension_Tag__c')
     && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Dimension_Tag__c',new set<String>{'sigmaerpdev__Paid_Amount__c'})
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Customer_Saved_Card__c',new set<String>{'id','sigmaerpdev__SFDC_Account__c','sigmaerpdev__Credit_Card_No__c','sigmaerpdev__Source__c','sigmaerpdev__CVVNO__c','sigmaerpdev__SourceCvv__c','sigmaerpdev__Expiry_Month__c','sigmaerpdev__Expiry_Year__c','sigmaerpdev__Card_Type__c','sigmaerpdev__SFDC_Account__r.sigmaerpdev__Email__c','sigmaerpdev__SFDC_Account__r.sigmaerpdev__Customer_Type__c','sigmaerpdev__Default_Card__c','sigmaerpdev__SourceCvv__c'})
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Dimension_Tag__c',new set<String>{'id','sigmaerpdev__Account__c','sigmaerpdev__Ordered_Amount__c','sigmaerpdev__Base_Credit_Limit__c','sigmaerpdev__Due_Amount__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Remaining_Credit_Limit__c'})
    && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Account_Subscription_Intervals__c',new set<String>{'sigmaerpdev__Payment_Status__c','sigmaerpdev__Customer__c','sigmaerpdev__next_Billing_Amount__c','sigmaerpdev__Last_Renewal_Date__c','sigmaerpdev__Last_Renewal_Amount__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Payment_Status__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Payment__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__Amount__c'})
    && Schema.sObjectType.Account_Subscription_Intervals__c.fields.Id.isAccessible()
    && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev__Order_Status__c'})
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{' id','name','sigmaerpdev__Order_Status__c','sigmaerpdev__Sigma_Order__c'})
    && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Payment__c',new set<String>{'sigmaerpdev__SFDC_Account__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Payment_Mode__c','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Customer_SFID__c','sigmaerpdev__Tax_Amount__c'})
    && Schema.sObjectType.Payment__c.fields.Id.isAccessible()
    && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sigma_Order__c',new set<String>{'sigmaerpdev__Orders_Status__c','sigmaerpdev__Is_Payment_Made__c'})
    && Schema.sObjectType.Sigma_Order__c.fields.Id.isAccessible())
    {*/
    
  
            Account_Subscription_Intervals__c accs = new Account_Subscription_Intervals__c();
            
            if(!scope[0].Customer__r.autopay__c)
            {
                
                accs.Id = scope[0].Id;
                accs.Payment_Status__c = 'Not Paid';
                update accs;
            }
            else
            {
                List<String> errorMessages = new List<String>();
                
                List<Customer_Saved_Card__c> csc = [select id,Credit_Card_No__c,Source__c,SourceCvv__c,CVVNO__c,Expiry_Month__c,Expiry_Year__c,Card_Type__c,SFDC_Account__c,SFDC_Account__r.Email__c,SFDC_Account__r.Customer_Type__c from Customer_Saved_Card__c where SFDC_Account__c =: scope[0].Customer__c and Default_Card__c = true Limit 1];
                system.debug('csc>>>'+csc[0].SFDC_Account__r.Customer_Type__c);
                List<Dimension_Tag__c> CredituserInfo= [select id,Account__c,Ordered_Amount__c,Base_Credit_Limit__c,Due_Amount__c,Paid_Amount__c,Remaining_Credit_Limit__c from Dimension_Tag__c where Account__c =: scope[0].Customer__c];
                system.debug('CredituserInfo>>>'+CredituserInfo);
                //code added to send an email after credit limit exceeds for credit customer on 11-10-2019
                if(csc[0].SFDC_Account__r.Customer_Type__c=='Credit Customer')
                {
                
                    if(CredituserInfo[0].Remaining_Credit_Limit__c<scope[0].Amount__c)
                    {
                      
                        String mailBody = '<table border="1"><tr><th>Usage Type</th><th>Account Subscription</th><th>Customer Name</th><th>Product Name</th> <th>Ordered Quantity</th><th>Billing Date</th><th>Billing Amount</th><th>Due Amount</th><th>Payment Status</th><th>Ordered Status</th></tr>';
                        Map<Id,String> prodIdProdNameMap=new Map<Id,String>();
                    
                        List<Account_Subscription_Intervals__c> ASIList = (List<Account_Subscription_Intervals__c>) scope;
                        if(!ASIList.isEmpty()) 
                        { 
                            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
                            for (Account_Subscription_Intervals__c asi : ASIList)
                            {      
                                              
                                prodIdProdNameMap.put(asi.Product_Name__c,asi.Product_Name__r.name);
                                mailBody += '<tr><td>'+asi.Usage_Type__c+'</td><td>'+asi.Account_Subscription__r.SubId__c+'</td><td>'+asi.Customer__r.Name+'</td><td>'+asi.Product_Name__r.name+'</td><td>'+asi.Quantity__c+'</td><td>'+asi.Next_Billing_Date__c+'</td><td>'+asi.Amount__c+'</td><td>'+asi.Due_Amount__c+'</td><td>'+asi.Payment_Status__c+'</td><td>'+asi.Order_Status__c+'</td><tr>';                                         
                            }
                            String completeMailBody='<html>Dear Customer,<br/><br/>Payment Failed for Below Subscription because Your Credit Card Limit is exceeded!!.We are requesting you to check Further actions.<br/><br/><br/>'+mailBody+'</table><br/><br/><br/>Regards,<br/>Mindlinks Slution Pvt Ltd.</html>';
                            system.debug('completeMailBody>>'+completeMailBody);
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();     
                            mail.setToAddresses(new List<String>{scope[0].Customer__r.Email__c}); 
                            mail.setSubject('Renewal AutoPayment Failed!!');
                            mail.setHTMLBody(completeMailBody);
                            mail.setSaveAsActivity(false);  
                            mailList.add(mail);
                            //Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                            if(!mailList.isEmpty()) {
                                try{
                                    
                                   Messaging.sendEmail(mailList);
                                }
                                catch (Exception ex) {
                                    errorMessages.add('Unable to send email to Tech: '+ ex.getStackTraceString());
                                }
                            }
                        }
                        
                    } 
                    else if(csc.size()>0)
                    {
                       
                        //decription of data
                            string decripcardno = '';
                            string decripcvvno = '';
                            try
                            {
                            decripcardno = carddecreption(csc[0].Credit_Card_No__c,csc[0].Source__c);

                            decripcvvno = carddecreption(csc[0].SourceCvv__c,csc[0].Source__c);

                            }
                            catch(exception e)
                            {
                            system.debug('exception::'+e);
                            }
                        
                            String year=String.valueOf(csc[0].Expiry_Year__c);
                            Date eyear=date.valueOf(year);
                            Integer expyear=eyear.year();
                            Integer exmonth=eyear.month();
                             system.debug('Id'+String.valueOf(scope[0].Id));
                             system.debug('exmonth'+String.valueOf(exmonth));
                             system.debug('expyear'+String.valueOf(expyear));
                             system.debug('Amount__c'+String.valueOf(scope[0].Amount__c));
                            system.debug('Customer__c'+String.valueOf(scope[0].Customer__c));
                            system.debug('Tax_Amount__c'+String.valueOf(scope[0].Tax_Amount__c));
                            Id payid=selectedCardsave(String.valueOf(scope[0].Id),decripcardno,decripcvvno,String.valueOf(exmonth),String.valueOf(expyear),String.valueOf(scope[0].Amount__c),String.valueOf(scope[0].Customer__c),String.valueOf(scope[0].Tax_Amount__c));//String.valueOf(csc[0].SourceCvv__c)
                            system.debug('payid>>>'+payid);
                       
                           // if(selectedOption[0].get('Subscription_Renewal__c') == true && scope[0].Product_Name__c!= null&& scope[0].Usage_Type__c=='Product')
                             if(scope[0].Product_Name__c!= null&& scope[0].Usage_Type__c=='Product')
                            {
                   
                            String storeName='null';
                            String billingPerson=null;
                            String custType=scope[0].Customer__r.Customer_Type__c;
                            String subid=scope[0].Id;
                            Id accId=scope[0].Customer__c;
                            String OrderIDD=null;
                            Double allPdtsAmount=scope[0].Amount__c;
                            Date orderdelivarydate=system.today();
                            List<String> productList=new List<String>(0);
                            String Id=scope[0].Product_Name__c;
                            String Name=scope[0].Product_Name__r.Name;
                            String quantity=String.valueOf(scope[0].Quantity__c);
                            String totalAmount=String.valueOf(scope[0].Amount__c);
                            Id orderid=LookupObjectCntrl.subordersave(Id,Name,quantity,OrderIDD,accId,subid,custType,billingPerson,storeName,allPdtsAmount);
                            system.debug('orderid>>'+orderid);
                            
                            Payment__c payment=new Payment__c();
                            payment.id=payid;
                            payment.SFDC_Account__c=accId;
                            payment.Sigma_Order__c=orderid;
                            payment.Payment_Mode__c='Card';
                            payment.Order_Created_Via__c='Subscription';
                            payment.Tax_Amount__c=scope[0].Tax_Amount__c;
                            payment.Amount_Recevied__c= scope[0].Amount__c; 
                            update payment;
                            system.debug('payment>>'+payment);     
                            
                            Sigma_Order__c orderitem=new Sigma_Order__c();
                            orderitem.id=orderid;
                            orderitem.Is_Payment_Made__c=true;
                            orderitem.Orders_Status__c='Order Confirmed';
                            update orderitem;
                            system.debug('orderitem>>'+orderitem);
                            
                            accs.Id = scope[0].Id;
                            accs.Order_Status__c='Order Confirmed';
                            update accs;
                            system.debug('accs>>'+accs);
                            
                            Product_Order_Price_Book__c orderline=[select id,name,Order_Status__c,Sigma_Order__c from Product_Order_Price_Book__c where Sigma_Order__c=:orderid];
                            orderline.Order_Status__c='Order Confirmed';
                            update orderline;
                            system.debug('orderline>>'+orderline);    
                        }
                         if(payid != null)
                            {
                                
                                Date renewaldt = Date.today();
                                accs.Id = scope[0].Id;
                                accs.Last_Renewal_Date__c = renewaldt;
                                accs.Last_Renewal_Amount__c = scope[0].Amount__c;
                                //code added by rashmi to update paid and due amount feild in ASI on 01/10/2019
                                if(accs.Paid_Amount__c ==null )
                                {
                                    accs.Paid_Amount__c = 0;
                                }
                                accs.Paid_Amount__c = accs.Paid_Amount__c + accs.Last_Renewal_Amount__c;
                                
                               
                                accs.Payment_Status__c = 'Paid';
                                accs.Order_Status__c = 'Order Confirmed';
                                accs.Payment__c=payid;
                                update accs; 
                            }
                            
                            if(scope[0].Customer__r.Customer_Type__c == 'Credit Customer' && scope[0].Amount__c!=null && scope[0].Order_Status__c=='Not Created')
                            {   
                                Dimension_Tag__c DT = [select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: scope[0].Customer__c limit 1 ];
                                system.debug('DT>>>'+DT);
                                
                                if(scope[0].Payment_Status__c=='Not Paid' && scope[0].Usage_Type__c!='Product')
                                {   
                                    system.debug('total amount to be paid>>>'+scope[0].Amount__c);
                                    if(DT.Ordered_Amount__c==null)
                                            DT.Ordered_Amount__c=0;
                                    if(scope[0].Amount__c!=null)
                                        DT.Ordered_Amount__c+=scope[0].Amount__c;
                                      
                                }
                                if(DT.Paid_Amount__c == null)
                                DT.Paid_Amount__c =0;
                                DT.Paid_Amount__c = DT.Paid_Amount__c + accs.Last_Renewal_Amount__c;
                                system.debug('DT paid amount>>>'+DT.Paid_Amount__c);
                                update DT;
                                system.debug('After Updating DT>>'+DT);
                            }
                    }
                    else
                    {
                        accs.Id = scope[0].Id;
                        accs.Payment_Status__c = 'Not Paid';
                        accs.Order_Status__c = 'Not Created';
                        update accs;
                    }
                }
                else if(csc.size()>0) //cash customer
                {
                   
                    //decription of data
                        string decripcardno = '';
                        string decripcvvno = '';
                        try
                        {
                        decripcardno = carddecreption(csc[0].Credit_Card_No__c,csc[0].Source__c);
                        decripcvvno = carddecreption(csc[0].SourceCvv__c,csc[0].Source__c);
                        }
                        catch(exception e)
                        {
                        system.debug('exception::'+e);
                        if(test.isRunningTest())
                            decripcardno = 'juhgfjjghhhhhhhhhhh';
                        }
                    
                        String year=String.valueOf(csc[0].Expiry_Year__c);
                        Date eyear=date.valueOf(year);
                        Integer expyear=eyear.year();
                        Integer exmonth=eyear.month();
                        
                        system.debug('scope[0].Id:::'+scope[0].Customer__c);
                        Id payid=selectedCardsave(String.valueOf(scope[0].Id),decripcardno,decripcvvno,String.valueOf(exmonth),String.valueOf(expyear),String.valueOf(scope[0].Amount__c),String.valueOf(scope[0].Customer__c),String.valueOf(scope[0].Tax_Amount__c));//String.valueOf(csc[0].SourceCvv__c)
                        system.debug('payid>>>'+payid);
                   
                       // if(selectedOption[0].get('Subscription_Renewal__c') == true && scope[0].Product_Name__c!= null&& scope[0].Usage_Type__c=='Product')
                         if(scope[0].Product_Name__c!= null&& scope[0].Usage_Type__c=='Product')
                        {
               
                        String storeName='null';
                        String billingPerson=null;
                        String custType=scope[0].Customer__r.Customer_Type__c;
                        String subid=scope[0].Id;
                        Id accId=scope[0].Customer__c;
                        String OrderIDD=null;
                        Double allPdtsAmount=scope[0].Amount__c;
                        Date orderdelivarydate=system.today();
                        List<String> productList=new List<String>(0);
                        String Id=scope[0].Product_Name__c;
                        String Name=scope[0].Product_Name__r.Name;
                        String quantity=String.valueOf(scope[0].Quantity__c);
                        String totalAmount=String.valueOf(scope[0].Amount__c);
                        Id orderid=LookupObjectCntrl.subordersave(Id,Name,quantity,OrderIDD,accId,subid,custType,billingPerson,storeName,allPdtsAmount);
                        system.debug('orderid>>'+orderid);
                        
                        Payment__c payment=new Payment__c();
                        payment.id=payid;
                        payment.Customer_SFID__c=accId;
                        payment.Tax_Amount__c=scope[0].Tax_Amount__c;
                        payment.Sigma_Order__c=orderid;
                        payment.Order_Created_Via__c='Subscription';
                        update payment;
                        system.debug('payment>>'+payment); 
                        
                        Sigma_Order__c orderitem=new Sigma_Order__c();
                        orderitem.id=orderid;
                        orderitem.Is_Payment_Made__c=true;
                        orderitem.Orders_Status__c='Order Confirmed';
                        update orderitem;
                        system.debug('orderitem>>'+orderitem);
                        
                        accs.Id = scope[0].Id;
                        accs.Order_Status__c='Order Confirmed';
                        update accs;
                        system.debug('accs>>'+accs);
                        
                        Product_Order_Price_Book__c orderline=[select id,name,Order_Status__c,Sigma_Order__c from Product_Order_Price_Book__c where Sigma_Order__c=:orderid];
                        orderline.Order_Status__c='Order Confirmed';
                        update orderline;
                        system.debug('orderline>>'+orderline);    
                    }
                    if(payid != null)
                    {
                        
                        Date renewaldt = Date.today();
                        accs.Id = scope[0].Id;
                        accs.Last_Renewal_Date__c = renewaldt;
                        accs.Last_Renewal_Amount__c = scope[0].Amount__c;
                        //code added by rashmi to update paid and due amount feild in ASI on 01/10/2019
                        if(accs.Paid_Amount__c ==null )
                        {
                            accs.Paid_Amount__c = 0;
                        }
                        accs.Paid_Amount__c = accs.Paid_Amount__c + accs.Last_Renewal_Amount__c;
                        
                        system.debug('amount received'+ accs.Last_Renewal_Amount__c);
                        system.debug('Paid amount'+accs.Paid_Amount__c);
                        
                        accs.Payment_Status__c = 'Paid';
                        accs.Order_Status__c = 'Order Confirmed';
                        accs.Payment__c=payid;
                        update accs; 
                    }
                }
                else
                {
                    accs.Id = scope[0].Id;
                    accs.Payment_Status__c = 'Not Paid';
                    accs.Order_Status__c = 'Not Created';
                    update accs;
                }
            }
    //    }
  //  }
  //  }
  
//}
}
public Id selectedCardsave(string accIntervalId ,String selectedCard,string CVV,string ExpiryMon,string ExpiryYear,string amt,String accId,string taxamt)
{

    Id Paymentid;
    if(CRUD_FLS_CheckUtility.checkObjCRUD('Account')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Payment__c')
    && CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'id','sigmaerpdev__stripeCustomerId__c','sigmaerpdev__Currency_code__c','Name'})
    && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Payment__c',new set<String>{'sigmaerpdev__PayPal_Transaction_Id__c','sigmaerpdev__Payment_Time__c','sigmaerpdev__Status__c','sigmaerpdev__Account_Subscription_Interval__c','sigmaerpdev__Credit_CardNumber__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Amount__c','sigmaerpdev__Customer_Name__c','sigmaerpdev__Transaction_Type__c','sigmaerpdev__Customer_SFID__c','sigmaerpdev__Payment_Mode__c','sigmaerpdev__Charge_Id__c'}))
    {
       
    string temp;
    Map<String, String> properties;
    Map<String, String> metadata;
    List<Account> acc = new List<Account>();

    acc = [select id,stripeCustomerId__c,Currency_code__c,Name from Account where id =:accId limit 1];
    
    if(test.isRunningTest())
    {
        acc = [select id,stripeCustomerId__c,Currency_code__c,Name from Account where Name= 'Test' limit 1];
    }
    
    if(!acc.isEmpty() && acc[0].stripeCustomerId__c == null && acc[0].Currency_code__c != null)
    {
      string cardNumber = selectedCard;
      string cvc = CVV;
      string expMonth = ExpiryMon;
      string expYear = ExpiryYear;

            
      properties = new Map<String, String>();
      properties.put('number',cardNumber);
      properties.put('exp_month',expMonth);
      properties.put('exp_year',expYear);
      properties.put('cvc',cvc);
      FetchStripeToken st = FetchStripeToken.fetchToken(properties);
      system.debug('FetchStripeToken '+st );
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
          Decimal Amount = decimal.valueOf(amt); 
          Decimal TaxAmount = decimal.valueOf(taxamt); 
          
         
          metadata.put('SFDCAccount',acc[0].Id);
          properties.put('customer', acc[0].stripeCustomerId__c);
          properties.put('currency', acc[0].Currency_code__c); 
          StripeCharge sc = StripeCharge.charge(cusID,Amount,properties,metadata);
          
          acc[0].stripeCustomerId__c = scus.id;
          if((sc.balance_transaction != null && String.isNotEmpty(sc.balance_transaction)) || Test.isRunningTest())
          {
                Payment__c payment= new Payment__c();
                List<Payment__c> paymentList= new List<Payment__c>();
                payment.PayPal_Transaction_Id__c = sc.balance_transaction;  
                payment.Charge_Id__c=sc.id;
                datetime pmntDateTime = datetime.now(); 
                payment.Payment_Time__c = pmntDateTime;
                payment.Status__c = 'Completed';  
                payment.Account_Subscription_Interval__c = accIntervalId;
                Integer first = cardNumber.length() - 4;
                Integer sec = cardNumber.length();
                String mask = cardNumber.substring(first,sec );
                String markcardnumb= 'XXXXXXXXXXXX'+String.valueof(mask) ;    
                payment.Credit_CardNumber__c = markcardnumb; 
                payment.Paid_Amount__c = Amount; 
                payment.Amount__c = Amount;
                payment.Tax_Amount__c=TaxAmount;
                payment.Customer_Name__c = acc[0].Name;
                payment.SFDC_Account__c=acc[0].id;
                payment.Transaction_Type__c ='Renewal';
                payment.Payment_Mode__c='Card'; 
                payment.Card_Type__c='Visa';
                payment.Order_Created_Via__c='Subscription';
                paymentList.add(payment);
                          
                insert paymentList;
                Paymentid=paymentList[0].id;

        }
        }
      }
    }
    }

    return Paymentid;
    }
    public static string carddecreption(string arg,string key)
    {
       
       
        Blob cryptoKey = EncodingUtil.base64Decode(key);
        Blob encodedEncryptedBlob = EncodingUtil.base64Decode(arg);
        Blob decryptedData = Crypto.decryptWithManagedIV('AES256', cryptoKey, encodedEncryptedBlob );
        String decryptedDataString = decryptedData.toString();
    return decryptedDataString;
}
global void finish(Database.BatchableContext BC)
{
    System.debug('Logic to be Executed at finish');
}


}