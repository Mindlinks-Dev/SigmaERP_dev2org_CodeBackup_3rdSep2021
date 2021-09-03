public without sharing class SendEmailCntrl
{
    /**
* Aura enabled method to search a specified SObject for a specific string
*/
    @AuraEnabled
    public static String sendEmail(ID Id,ID regId,String mailId,String Brewery)
    {
        system.debug('Id>>>>'+Id);
        system.debug('regId>>>>'+regId);
        system.debug('mailId>>>>'+mailId);
        system.debug('Brewery>>>>'+Brewery);
        String result;
        
       /*if(CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'Name','BillingStreet','BillingCity','BillingState','Billingcountry','Type'})
         &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'sigmaerpdev__Sigma_CustomerAddress__c','sigmaerpdev__AccountId__r.Name','sigmaerpdev__AccountId__c','sigmaerpdev__AccountId__r.sigmaerpdev__Address__c','sigmaerpdev__AccountId__r.sigmaerpdev__City__c','sigmaerpdev__AccountId__r.sigmaerpdev__Zip__c','sigmaerpdev__AccountId__r.sigmaerpdev__State__c','sigmaerpdev__AccountId__r.sigmaerpdev__Country__c','sigmaerpdev__AccountId__r.sigmaerpdev__Email__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Due_Amount__c','sigmaerpdev__TotalProductPrice__c','sigmaerpdev__Net_Amount__c','sigmaerpdev__Discount__c','sigmaerpdev__Discount_New__c','sigmaerpdev__Tax__c','sigmaerpdev__TotalAmount__c','sigmaerpdev__Sigma_Order__c.Id'})
          &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new set<String>{'sigmaerpdev__Logo__c','sigmaerpdev__Company_Name__c','sigmaerpdev__EmailImage__c'}) 
          &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Payment__c',new set<String>{'sigmaerpdev__Payment_Time__c','sigmaerpdev__Due_Amount__c','sigmaerpdev__Amount_Recevied__c','sigmadevSigma___Order__r.sigmaerpdev__Order_Number__c','sigmaerpdev__Sigma_Order__r.Name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Customer_SFID__r.sigmaerpdev__Country__c','sigmaerpdev__Customer_SFID__r.sigmaerpdev__State__c','sigmaerpdev__Customer_SFID__r.sigmaerpdev__City__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Order_Number__c','sigmaerpdev__Customer_SFID__r.sigmaerpdev__Zip__c','sigmaerpdev__Customer_SFID__r.Name','sigmaerpdev__Customer_SFID__r.sigmaerpdev__Email__c','sigmaerpdev__Customer_SFID__r.sigmaerpdev__Address__c','sigmaerpdev__Account_Subscription_Interval__c','sigmaerpdev__ReceiptNumber__c','sigmaerpdev__Payment_Mode__c','sigmaerpdev__Customer_SFID__c','sigmaerpdev__Customer_SFID__r.Id','sigmaerpdev__Amount__c','sigmaerpdev__Tax_Type__c','sigmaerpdev__Tax_Amount__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'Id','Name','sigmaerpdev__Product_Name__c','sigmaerpdev__Quantity__c','sigmaerpdev__Total_Amount__c','sigmaerpdev__Total_Price__c','sigmaerpdev__Product__r.sigmaerpdev__Special_Price__c'})
          )
        {*/
            
            String OrderId1 = Id;
            result = 'true';
            String customerName;
            String customerEmailId;
            String customerNumber;
            String customerAddress;
            String shippingAddress = '';
            String MessageBody;
            String body1 ;
            String storeName;
            String storeStreet;
            String storeCity;
            String storeState;
            String storeCountry;  
            
            //payment Details
            String paymentDate;
            String recptNumber = '';
            String mode;
            String pmtOrderId;
            String custNumber; 
            String billAmt;
            String taxType;
            String totalTax; 
            String recAmt;
            String dueAmt;
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            List<String> toMail = new List<String>();
            
            List<Account> acc;
                acc = [select Name,BillingStreet,BillingCity,BillingState,Billingcountry from Account where  Type = 'Store' limit 1];    
            
            for(Account storeAddress: acc){ 
                if(String.isNotBlank(String.valueOf(storeAddress.Name))){ 
                    storeName = String.valueOf(storeAddress.Name);
                }
                if(String.isNotBlank(String.valueOf(storeAddress.BillingStreet))){          
                    storeStreet = storeAddress.BillingStreet;
                }
                if(String.isNotBlank(String.valueOf(storeAddress.BillingCity))){
                    storeCity = storeAddress.BillingCity;
                }
                if(String.isNotBlank(String.valueOf(storeAddress.BillingState))){
                    storeState = storeAddress.BillingState; 
                }
                if(String.isNotBlank(String.valueOf(storeAddress.Billingcountry))){
                    storeCountry = String.valueOf(storeAddress.Billingcountry);
                }
            }               
            
            
            Default_Parameters__c dp=[select Logo__c,Company_Name__c,EmailImage__c from Default_Parameters__c Limit 1]; 
           
            body1 = '<html><table align="center"> ' +
                '<tr><td><img src="'+dp.Logo__c+'" width="100%" height="30%" /></td></tr><tr><td>' +
                '<strong>'+dp.Company_Name__c+'</strong><br/></td></tr>';
            
        if(regId!=null){
            system.debug('customerEmailId>>>'+mailId);
                    customerEmailId = mailId;
            			customerName = Brewery;
                }
            List<Sigma_Order__c> c;
              
                c = [select AccountId__r.Name,AccountId__c,AccountId__r.Address__c,AccountId__r.City__c,AccountId__r.Zip__c,AccountId__r.State__c,AccountId__r.Country__c,AccountId__r.Email__c,Paid_Amount__c,Due_Amount__c,TotalProductPrice__c,Net_Amount__c,Discount__c,Discount_New__c,Tax__c,TotalAmount__c,Total_Order_Tax__c from Sigma_Order__c  where Sigma_Order__c.Id =: OrderId1];   
          for(Sigma_Order__c custInfo: c)
            {        
                if(String.isNotBlank(String.valueOf(custInfo.AccountId__r.Name))) 
                {
                    customerName = custInfo.AccountId__r.Name;
                }  
                if(String.isNotBlank(String.valueOf(custInfo.AccountId__r.Email__c))) 
                {
                    customerEmailId = custInfo.AccountId__r.Email__c;
                }
                
                if(String.isNotBlank(String.valueOf(custInfo.AccountId__c))) 
                {
                    customerNumber = String.valueOf(custInfo.AccountId__c);                   
                }                               
                
                if(String.isNotBlank(String.valueOf(custInfo.AccountId__r.Address__c))) 
                {
                    customerAddress = String.valueOf(custInfo.AccountId__r.Address__c);                  
                }
                if(String.isNotBlank(String.valueOf(custInfo.AccountId__r.City__c)))
                {
                    customerAddress = customerAddress +','+ String.valueOf(custInfo.AccountId__r.City__c);                  
                }
                if(String.isNotBlank(String.valueOf(custInfo.AccountId__r.Zip__c))) 
                {
                    customerAddress = customerAddress +'-'+ String.valueOf(custInfo.AccountId__r.Zip__c);                  
                }
                if(String.isNotBlank(String.valueOf(custInfo.AccountId__r.State__c))) 
                {
                    customerAddress = customerAddress +','+ String.valueOf(custInfo.AccountId__r.State__c);                  
                }
                if(String.isNotBlank(String.valueOf(custInfo.AccountId__r.Country__c))) 
                {
                    customerAddress = customerAddress +','+ String.valueOf(custInfo.AccountId__r.Country__c);                  
                }    
                
            }
            
            
            List<Payment__c> p ;
            
                p = [select Payment_Time__c,Due_Amount__c,Amount_Recevied__c, Sigma_Order__r.Name,ReceiptNumber__c,Payment_Mode__c,Sigma_Order__c,Customer_SFID__r.Id,Amount__c,Tax_Type__c,Tax_Amount__c,Sigma_Order__r.Order_Number__c from Payment__c where Sigma_Order__r.Id =: OrderId1  ];  
                
               
            if(c.size() > 0)
            {
                body1 += '<tr><td>Your Order details are shown below for your reference.</td></tr></table>' +
                    '<br/>Order Details:<br/><br/><table align="left" width="75%" border = "1">' +
                    '<tr><th align="center">Account Name</th><th align="center">Total Product Price</th><th align="center">Discount(%)</th><th align="center">Total Amount</th><th align="center">Tax(%)</th><th align="center">Net Amount</th><th align="center">Tax Amount</th></tr>';      
            }
            
            if(c.size() == 0)
            {
                p = [select Payment_Time__c,Due_Amount__c,Amount_Recevied__c,Sigma_Order__r.Order_Number__c,Sigma_Order__r.Name,Customer_SFID__r.Country__c,Customer_SFID__r.State__c,Customer_SFID__r.City__c,Customer_SFID__r.Zip__c,Customer_SFID__r.Name,Customer_SFID__r.Email__c,Customer_SFID__r.Address__c,Account_Subscription_Interval__c,ReceiptNumber__c,Payment_Mode__c,Customer_SFID__c,Customer_SFID__r.Id,Amount__c,Tax_Type__c,Tax_Amount__c from Payment__c where Id =: OrderId1  ];   
               
            }
            for(Payment__c pmtInfo: p)
            {                    
                if(String.isNotBlank(String.valueOf(pmtInfo.Payment_Time__c))){          
                    paymentDate = String.valueOf(pmtInfo.Payment_Time__c);
                }
                if(String.isNotBlank(String.valueOf(pmtInfo.ReceiptNumber__c))){          
                    recptNumber = pmtInfo.ReceiptNumber__c;
                }
                if(String.isNotBlank(String.valueOf(pmtInfo.Payment_Mode__c))){
                    mode = pmtInfo.Payment_Mode__c;
                }
                
                if(String.isNotBlank(String.valueOf(pmtInfo.Sigma_Order__r.Name))){
                    pmtOrderId = pmtInfo.Sigma_Order__r.Name; 
                }
                else if(String.isNotBlank(String.valueOf(pmtInfo.Account_Subscription_Interval__c))){
                    pmtOrderId = pmtInfo.Account_Subscription_Interval__c; 
                }
                
                if(String.isNotBlank(String.valueOf(pmtInfo.Customer_SFID__r.Id))){
                    custNumber = String.valueOf(pmtInfo.Customer_SFID__r.Id);
                }
                if(String.isNotBlank(String.valueOf(pmtInfo.Amount__c))){
                    recAmt = String.valueOf(pmtInfo.Amount_Recevied__c);
                } 
                if(String.isNotBlank(String.valueOf(pmtInfo.Tax_Type__c))){
                    taxType = String.valueOf(pmtInfo.Tax_Type__c);
                }    
                if(String.isNotBlank(String.valueOf(pmtInfo.Tax_Amount__c))){
                    dueAmt = String.valueOf(pmtInfo.Due_Amount__c);
                }
                
                //////////////////////////code added by anuja////////////////////////////////////////////////
                if(c.size() == 0)
                {
                    if(String.isNotBlank(String.valueOf(pmtInfo.Customer_SFID__r.Name))) 
                    {
                        customerName = pmtInfo.Customer_SFID__r.Name;
                    }  
                    if(String.isNotBlank(String.valueOf(pmtInfo.Customer_SFID__r.Email__c))) 
                    {
                        customerEmailId = pmtInfo.Customer_SFID__r.Email__c;
                    } 
                    if(String.isNotBlank(String.valueOf(pmtInfo.Customer_SFID__c))) 
                    {
                        customerNumber = String.valueOf(pmtInfo.Customer_SFID__c);                   
                    }                               
                    
                    if(String.isNotBlank(String.valueOf(pmtInfo.Customer_SFID__r.Address__c))) 
                    {
                        customerAddress = String.valueOf(pmtInfo.Customer_SFID__r.Address__c);                  
                    }
                    if(String.isNotBlank(String.valueOf(pmtInfo.Customer_SFID__r.City__c)))
                    {
                        customerAddress = customerAddress +','+ String.valueOf(pmtInfo.Customer_SFID__r.City__c);                  
                    }
                    if(String.isNotBlank(String.valueOf(pmtInfo.Customer_SFID__r.Zip__c))) 
                    {
                        customerAddress = customerAddress +'-'+ String.valueOf(pmtInfo.Customer_SFID__r.Zip__c);                  
                    }
                    if(String.isNotBlank(String.valueOf(pmtInfo.Customer_SFID__r.State__c))) 
                    {
                        customerAddress = customerAddress +','+ String.valueOf(pmtInfo.Customer_SFID__r.State__c);                  
                    }
                    if(String.isNotBlank(String.valueOf(pmtInfo.Customer_SFID__r.Country__c))) 
                    {
                        customerAddress = customerAddress +','+ String.valueOf(pmtInfo.Customer_SFID__r.Country__c);                  
                    }   
                }
            }                             
            //FLSCheck Order AccessPermisson
            List<Sigma_Order__c> ord;
            
              ord = [select Shipping_Street__c,ShippingCity__c,ShippingState__c,ShippingCountry__c,ShippingPostalCode__c from Sigma_Order__c where Id =: OrderId1 ]; 
                
           
            for(Sigma_Order__c ordInfo: ord)
            {
                if(String.isNotBlank(ordInfo.Shipping_Street__c))
                {
                    shippingAddress = ordInfo.Shipping_Street__c +',';
                }
				if(String.isNotBlank(ordInfo.ShippingCity__c))
                {
                    shippingAddress += ordInfo.ShippingCity__c +',';
                }
				if(String.isNotBlank(ordInfo.ShippingState__c))
                {
                    shippingAddress += ordInfo.ShippingState__c +',';
                }
				if(String.isNotBlank(ordInfo.ShippingCountry__c))
                {
                    shippingAddress += ordInfo.ShippingCountry__c +'-';
                }
				if(String.isNotBlank(ordInfo.ShippingPostalCode__c))
                {
                    shippingAddress += ordInfo.ShippingPostalCode__c;
                }
				
			}
            
                     
            
            
            attach.setContentType('application/pdf');
            attach.setFileName('Receipt.pdf');
            
            PageReference pdf =  Page.AttachmentPDF;
             
          if(!test.isrunningtest()) {
                Blob b = pdf.getContent();
            }
                

            
            for(Sigma_Order__c productLine: c)
            {                    
                 body1 += '<tr><td align="center">' + productLine.AccountId__r.Name + 
                    '</td><td align="center">' + productLine.TotalProductPrice__c +
                    '</td><td align="center">' + productLine.Discount_New__c +
                    '</td><td align="center">' + productLine.Net_Amount__c +
                    '</td><td align="center">' + productLine.Tax__c +
                    '</td><td align="center">' + productLine.TotalAmount__c +
                     '</td><td align="center">' + productLine.Total_Order_Tax__c +'</td></tr>';
            }
            
            toMail.add(customerEmailId);   
            MessageBody = 'Hi '+customerName +',\nAttached payment receipt along with this email \nThanks & Regards';              
            
            body1 += '</table><br/>Payment Details:<br/><br/><table width="85%" border="1"><tr><td align="center">Date</td><td align="center">Rec. Number</td><td align="center">Mode</td><td align="center">OrderId</td><td align="center">Cust. Number</td><td align="center">Paid Amount</td><td align="center">Due Amount</td></tr>' +
                '<tr><td align="center">'+paymentDate+'</td><td align="center">'+recptNumber+'</td><td align="center">'+mode +'</td><td align="center">'+pmtOrderId +'</td><td align="center">'+customerNumber+'</td><td align="center">'+recAmt+'</td><td align="center">'+dueAmt+'</td></tr></table><br/>'+
                'Customer Details : <br /><br /><table width="76%" border = "1">' +
                '<tr><td>Name </td><td>'+customerName+'</td></tr>'+
                '<tr><td>Email </td><td>'+customerEmailId+'</td></tr>'+
                '<tr><td>Customer Number </td><td>'+customerNumber+'</td></tr>'+
                '</table>'+
                '<br/>Shipping Address : <br /><table width="70%" border = "0"><tr><td>'+shippingAddress+'</td></tr></table><table align="center"><tr><td><img src="'+dp.EmailImage__c +'" width="100%" height="30%" /></td></tr></table></html>';
            
            // Create the email attachment
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setContentType('application/pdf');
            efa.setFileName('receipt.pdf');
            
            //efa.setBody(b);  
            if(!test.isrunningtest()) {     
            efa.Body = Blob.toPDF(body1);
            }
            email.setSubject('Receipt Details');
            email.setToAddresses(toMail);
            email.setPlainTextBody(MessageBody);
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            try{
                Messaging.SendEmailResult [] r = 
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});          
            }catch(Exception e){
                result = 'false';
                
            }                            
            
            
       // }
        return result; 
    }
    
   
    @AuraEnabled
       public static string SendEmailOrder(Id OrderId)
       {
        String result;
         /*if(CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'Name','BillingStreet','BillingCity','BillingState','Billingcountry','Type'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'sigmaerpdev__CustomerAddress__c','AccountId','Account.Name','Account.sigmaerpdev__Address__c','Account.sigmaerpdev__City__c','Account.sigmaerpdev__Zip__c','Account.sigmaerpdev__State__c','Account.sigmaerpdev__Country__c','Account.sigmaerpdev__Email__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Due_Amount__c','sigmaerpdev__Total_product_Price__c','sigmaerpdev__Net_Amount__c','sigmaerpdev__Discount__c','sigmaerpdev__Tax__c','sigmaerpdev__TotalAmount__c','Id'})
          &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new set<String>{'sigmaerpdev__Logo__c','sigmaerpdev__Company_Name__c','sigmaerpdev__EmailImage__c'}) 
          &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Payment__c',new set<String>{'Id','sigmaerpdev__Payment_Time__c','sigmaerpdev__Due_Amount__c','sigmaerpdev__Amount_Recevied__c', 'sigmaerpdev__OrderId__r.Name','sigmaerpdev__ReceiptNumber__c','sigmaerpdev__Payment_Mode__c','sigmaerpdev__OrderId__c','sigmaerpdev__Customer_SFID__r.Id','sigmaerpdev__Customer_SFID__r.sigmaerpdev__Email__c','sigmaerpdev__Customer_SFID__r.Name','sigmaerpdev__Customer_SFID__c','sigmaerpdev__Customer_SFID__r.sigmaerpdev__Address__c','sigmaerpdev__Customer_SFID__r.sigmaerpdev__City__c','sigmaerpdev__Customer_SFID__r.sigmaerpdev__Zip__c','sigmaerpdev__Customer_SFID__r.sigmaerpdev__State__c','sigmaerpdev__Customer_SFID__r.sigmaerpdev__Country__c' ,'sigmaerpdev__Amount__c','sigmaerpdev__Tax_Type__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__OrderId__r.OrderNumber'})
          )
        {*/
        String StandOrderId = OrderId;
         result = 'true';
         
        String customerName;
        String customerEmailId;
        String customerNumber;
        String customerAddress;
        String shippingAddress = '';
        String MessageBody;
        String body1 ;
        String storeName;
        String storeStreet;
        String storeCity;
        String storeState;
        String storeCountry;  

        //payment Details
        String paymentDate;
        String recptNumber = '';
        String mode;
        String pmtOrderId;
        String custNumber; 
        String billAmt;
        String taxType;
        String totalTax; 
        String recAmt;
        String dueAmt;
        
         Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
   
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        List<String> toMail = new List<String>();
        
        List<Account> accStore;
        accStore = [select Name,BillingStreet,BillingCity,BillingState,Billingcountry from Account where  Type = 'Store' limit 1];    
       
         for(Account storeAddress: accStore){ 
                if(String.isNotBlank(String.valueOf(storeAddress.Name))){ 
                    storeName = String.valueOf(storeAddress.Name);
                }
                if(String.isNotBlank(String.valueOf(storeAddress.BillingStreet))){          
                    storeStreet = storeAddress.BillingStreet;
                }
                if(String.isNotBlank(String.valueOf(storeAddress.BillingCity))){
                    storeCity = storeAddress.BillingCity;
                }
                if(String.isNotBlank(String.valueOf(storeAddress.BillingState))){
                    storeState = storeAddress.BillingState; 
                }
                if(String.isNotBlank(String.valueOf(storeAddress.Billingcountry))){
                    storeCountry = String.valueOf(storeAddress.Billingcountry);
                }
            } 

        Default_Parameters__c dp=[select Logo__c,Company_Name__c,EmailImage__c from Default_Parameters__c]; 
        
        body1 = '<html><table align="center"' +
                '<tr><td><img src="'+dp.Logo__c+'"width="100%" height="30%" /> </td> </tr> <tr><td>'+
                 '<strong>'+dp.Company_Name__c+'</strong><br/></td></tr>';

        
         List<Order> ord;
          
         ord = [select Id,CustomerAddress__c,AccountId,Account.Name,Account.Address__c,Account.City__c,Account.Zip__c,Account.State__c,Account.Country__c,Account.Email__c,Paid_Amount__c,Due_Amount__c,Total_product_Price__c,Net_Amount__c,Discount__c,Tax__c,TotalAmount__c,Shipping_Street__c,ShippingCity__c,ShippingState__c,ShippingCountry__c,ShippingPostalCode__c  from Order where Id =: StandOrderId];

        for(Order ordList : ord){
             if(String.isNotBlank(String.valueOf(ordList.Account.Name))) 
                {
                    customerName = ordList.Account.Name;
                }  
                if(String.isNotBlank(String.valueOf(ordList.Account.Email__c))) 
                {
                    customerEmailId = ordList.Account.Email__c;
                } 
                if(String.isNotBlank(String.valueOf(ordList.AccountId))) 
                {
                    customerNumber = String.valueOf(ordList.AccountId);                   
                }                               
                
                if(String.isNotBlank(String.valueOf(ordList.Account.Address__c))) 
                {
                    customerAddress = String.valueOf(ordList.Account.Address__c);                  
                }
                if(String.isNotBlank(String.valueOf(ordList.Account.City__c)))
                {
                    customerAddress = customerAddress +','+ String.valueOf(ordList.Account.City__c);                  
                }
                if(String.isNotBlank(String.valueOf(ordList.Account.Zip__c))) 
                {
                    customerAddress = customerAddress +'-'+ String.valueOf(ordList.Account.Zip__c);                  
                }
                if(String.isNotBlank(String.valueOf(ordList.Account.State__c))) 
                {
                    customerAddress = customerAddress +','+ String.valueOf(ordList.Account.State__c);                  
                }
                if(String.isNotBlank(String.valueOf(ordList.Account.Country__c))) 
                {
                    customerAddress = customerAddress +','+ String.valueOf(ordList.Account.Country__c);                  
                }  

                if(String.isNotBlank(ordList.Shipping_Street__c))
                {
                    shippingAddress = ordList.Shipping_Street__c +',';
                }
				if(String.isNotBlank(ordList.ShippingCity__c))
                {
                    shippingAddress += ordList.ShippingCity__c +',';
                }
				if(String.isNotBlank(ordList.ShippingState__c))
                {
                    shippingAddress += ordList.ShippingState__c +',';
                }
				if(String.isNotBlank(ordList.ShippingCountry__c))
                {
                    shippingAddress += ordList.ShippingCountry__c +'-';
                }
				if(String.isNotBlank(ordList.ShippingPostalCode__c))
                {
                    shippingAddress += ordList.ShippingPostalCode__c;
                }              
               
        }
        
         List<Payment__c> OrdPayment;
         
         OrdPayment = [select Id,Payment_Time__c,Due_Amount__c,Amount_Recevied__c, OrderId__r.Name,ReceiptNumber__c,Payment_Mode__c,OrderId__c,Customer_SFID__r.Id,Customer_SFID__r.Email__c,Customer_SFID__r.Name,Customer_SFID__c,Customer_SFID__r.Address__c,Customer_SFID__r.City__c,Customer_SFID__r.Zip__c,Customer_SFID__r.State__c,Customer_SFID__r.Country__c ,Amount__c,Tax_Type__c,Tax_Amount__c,OrderId__r.OrderNumber from Payment__c where OrderId__c =:StandOrderId];
           
        if(ord.size() > 0)
        {
            body1 += '<tr><td>Your Order details are shown below for your reference.</td></tr></table>' +
                '<br/>Order Details:<br/><br/><table align="left" width="75%" border = "1">' +
                '<tr><th align="center">Account Name</th><th align="center">Total Product Price</th><th align="center">Discount(%)</th><th align="center">Total Amount</th><th align="center">Tax(%)</th><th align="center">Net Amount</th></tr>';      
        }
        
         for(Payment__c pmtInfo: OrdPayment)
            {                    
                if(String.isNotBlank(String.valueOf(pmtInfo.Payment_Time__c))){          
                    paymentDate = String.valueOf(pmtInfo.Payment_Time__c);
                }
                if(String.isNotBlank(String.valueOf(pmtInfo.ReceiptNumber__c))){          
                    recptNumber = pmtInfo.ReceiptNumber__c;
                }
                if(String.isNotBlank(String.valueOf(pmtInfo.Payment_Mode__c))){
                    mode = pmtInfo.Payment_Mode__c;
                }
                
                if(String.isNotBlank(String.valueOf(pmtInfo.OrderId__r.OrderNumber))){
                    pmtOrderId = pmtInfo.OrderId__r.OrderNumber; 
                }
                
                if(String.isNotBlank(String.valueOf(pmtInfo.Customer_SFID__r.Id))){
                    custNumber = String.valueOf(pmtInfo.Customer_SFID__r.Id);
                }
                if(String.isNotBlank(String.valueOf(pmtInfo.Amount_Recevied__c))){
                    recAmt = String.valueOf(pmtInfo.Amount_Recevied__c);
                } 
                if(String.isNotBlank(String.valueOf(pmtInfo.Tax_Type__c))){
                    taxType = String.valueOf(pmtInfo.Tax_Type__c);
                }    
                if(String.isNotBlank(String.valueOf(pmtInfo.Due_Amount__c))){
                    dueAmt = String.valueOf(pmtInfo.Due_Amount__c);
                }
                
                //////////////////////////code added by anuja////////////////////////////////////////////////
                if(Ord.size() == 0)
                {
                    if(String.isNotBlank(String.valueOf(pmtInfo.Customer_SFID__r.Name))) 
                    {
                        customerName = pmtInfo.Customer_SFID__r.Name;
                    }  
                    if(String.isNotBlank(String.valueOf(pmtInfo.Customer_SFID__r.Email__c))) 
                    {
                        customerEmailId = pmtInfo.Customer_SFID__r.Email__c;
                    } 
                    if(String.isNotBlank(String.valueOf(pmtInfo.Customer_SFID__c))) 
                    {
                        customerNumber = String.valueOf(pmtInfo.Customer_SFID__c);                  
                    }                               
                    
                    if(String.isNotBlank(String.valueOf(pmtInfo.Customer_SFID__r.Address__c))) 
                    {
                        customerAddress = String.valueOf(pmtInfo.Customer_SFID__r.Address__c);                  
                    }
                    if(String.isNotBlank(String.valueOf(pmtInfo.Customer_SFID__r.City__c)))
                    {
                        customerAddress = customerAddress +','+ String.valueOf(pmtInfo.Customer_SFID__r.City__c);                  
                    }
                    if(String.isNotBlank(String.valueOf(pmtInfo.Customer_SFID__r.Zip__c))) 
                    {
                        customerAddress = customerAddress +'-'+ String.valueOf(pmtInfo.Customer_SFID__r.Zip__c);                  
                    }
                    if(String.isNotBlank(String.valueOf(pmtInfo.Customer_SFID__r.State__c))) 
                    {
                        customerAddress = customerAddress +','+ String.valueOf(pmtInfo.Customer_SFID__r.State__c);                  
                    }
                    if(String.isNotBlank(String.valueOf(pmtInfo.Customer_SFID__r.Country__c))) 
                    {
                        customerAddress = customerAddress +','+ String.valueOf(pmtInfo.Customer_SFID__r.Country__c);                  
                    }   
                }
            }
            
                
                
            attach.setContentType('application/pdf');
            attach.setFileName('Receipt.pdf');
            
            PageReference pdf =  Page.AttachmentPDF;
          
              if(!test.isrunningtest()) {
                Blob b = pdf.getContent();
            }
            
            
            for(Order ordCont : ord){
                 body1 += '<tr><td align="center">' + ordCont.Account.Name + 
                    '</td><td align="center">' + ordCont.Total_product_Price__c +
                    '</td><td align="center">' + ordCont.Discount__c +
                    '</td><td align="center">' + ordCont.Net_Amount__c +
                    '</td><td align="center">' + ordCont.Tax__c +
                    '</td><td align="center">' + ordCont.TotalAmount__c +'</td></tr>'; 
            }
            
            toMail.add(customerEmailId);
            MessageBody = 'Hi '+customerName +',\nAttached payment receipt along with this email. \nThanks & Regards';              

            body1 += '</table><br/>Payment Details:<br/><br/><table width="85%" border="1"><tr><td align="center">Date</td><td align="center">Rec. Number</td><td align="center">Mode</td><td align="center">OrderId</td><td align="center">Cust. Number</td><td align="center">Paid Amount</td><td align="center">Due Amount</td></tr>' +
                        '<tr><td align="center">'+paymentDate+'</td><td align="center">'+recptNumber+'</td><td align="center">'+mode +'</td><td align="center">'+pmtOrderId +'</td><td align="center">'+customerNumber+'</td><td align="center">'+recAmt+'</td><td align="center">'+dueAmt+'</td></tr></table><br/>'+
                        'Customer Details : <br /><br /><table width="76%" border = "1">' +
                        '<tr><td>Name </td><td>'+customerName+'</td></tr>'+
                        '<tr><td>Email </td><td>'+customerEmailId+'</td></tr>'+
                        '<tr><td>Customer Number </td><td>'+customerNumber+'</td></tr>'+
                        '</table>'+
                        '<br/>Shipping Address : <br /><table width="70%" border = "0"><tr><td>'+shippingAddress+'</td></tr></table><table align="center"><tr><td><img src="'+dp.EmailImage__c +'" width="100%" height="30%" /></td></tr></table></html>';

             // Create the email attachment
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setContentType('application/pdf');
            efa.setFileName('receipt.pdf');
            
            //efa.setBody(b); 
             if(!test.isrunningtest()) {      
            efa.Body = Blob.toPDF(body1);
            }
            email.setSubject('Receipt Details');
            email.setToAddresses(toMail);
            email.setPlainTextBody(MessageBody);
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            try{
                Messaging.SendEmailResult [] r = 
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});          
            }catch(Exception e){
                result = 'false';
                
            }      
        //}
             return result; 
            
        }
     
}