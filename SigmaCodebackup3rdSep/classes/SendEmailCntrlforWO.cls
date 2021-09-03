public with sharing class SendEmailCntrlforWO
{
    /**
* Aura enabled method to search a specified SObject for a specific string
*/
    @AuraEnabled
    public static String sendEmail(ID Id)
    {
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
            
            List<sigmaerpdev2__Work_Order__c> c;
              
                c = [Select Id,Name,sigmaerpdev2__AssignTo__r.ContactID,sigmaerpdev2__Case_Description__c,Account__r.State__c,Account__r.Zip__c,Account__r.Address__c,Account__r.City__c,sigmaerpdev2__Case_Subject_text__c , sigmaerpdev2__Total_Value__c,sigmaerpdev2__Bill_Street__c,sigmaerpdev2__Bill_City__c,sigmaerpdev2__Customer_Contact__c,sigmaerpdev2__Account__r.Name,
                           sigmaerpdev2__Account__r.AccountNumber,Account__r.Country__c,sigmaerpdev2__Case_Number_text__c,Tax_Amount__c,Tax__c,Service_Contract__c,Service_Contract__r.Contract_End_Date__c,Account__r.Customer_Type__c,Account__c,Status__c,TotalAmount__c,Account__r.Email__c,
                           sigmaerpdev2__Work_Type__c,Service_Warrenty_End_date__c,sigmaerpdev2__Work_Type__r.sigmaerpdev2__Service_Charge__c,sigmaerpdev2__FFP_MR_Contact__c FROM sigmaerpdev2__Work_Order__c  where sigmaerpdev2__Work_Order__c.Id =: OrderId1];   
          for(sigmaerpdev2__Work_Order__c custInfo: c)
            {        
                if(String.isNotBlank(String.valueOf(custInfo.Account__r.Name))) 
                {
                    customerName = custInfo.Account__r.Name;
                }  
                if(String.isNotBlank(String.valueOf(custInfo.Account__r.Email__c))) 
                {
                    customerEmailId = custInfo.Account__r.Email__c;
                } 
                if(String.isNotBlank(String.valueOf(custInfo.Account__c))) 
                {
                    customerNumber = String.valueOf(custInfo.Account__c);                   
                }                               
                
                if(String.isNotBlank(String.valueOf(custInfo.Account__r.Address__c))) 
                {
                    customerAddress = String.valueOf(custInfo.Account__r.Address__c);                  
                }
                if(String.isNotBlank(String.valueOf(custInfo.Account__r.City__c)))
                {
                    customerAddress = customerAddress +','+ String.valueOf(custInfo.Account__r.City__c);                  
                }
                if(String.isNotBlank(String.valueOf(custInfo.Account__r.Zip__c))) 
                {
                    customerAddress = customerAddress +'-'+ String.valueOf(custInfo.Account__r.Zip__c);                  
                }
                if(String.isNotBlank(String.valueOf(custInfo.Account__r.State__c))) 
                {
                    customerAddress = customerAddress +','+ String.valueOf(custInfo.Account__r.State__c);                  
                }
                if(String.isNotBlank(String.valueOf(custInfo.Account__r.Country__c))) 
                {
                    customerAddress = customerAddress +','+ String.valueOf(custInfo.Account__r.Country__c);                  
                }    
                
            }
            
            
            List<Payment__c> p ;
            
                p = [select Payment_Time__c,Due_Amount__c,Amount_Recevied__c, sigmaerpdev2__Work_Order__r.Name,ReceiptNumber__c,Payment_Mode__c,sigmaerpdev2__Work_Order__c,Customer_SFID__r.Id,Amount__c,Tax_Type__c,Tax_Amount__c from Payment__c where sigmaerpdev2__Work_Order__r.Id =: OrderId1 order by CreatedDate DESC limit 1];  
                
               
            if(c.size() > 0)
            {
                body1 += '<tr><td>Your Work Order details are shown below for your reference.</td></tr></table>' +
                    '<br/>Work Order Details:<br/><br/><table align="left" width="75%" border = "1">' +
                    '<tr><th align="center">Account Name</th><th align="center">Tax(%)</th><th align="center">Net Amount</th></tr>';      
            }
            
            if(c.size() == 0)
            {
                p = [select Payment_Time__c,Due_Amount__c,Amount_Recevied__c,sigmaerpdev2__Work_Order__r.Name,Customer_SFID__r.Country__c,Customer_SFID__r.State__c,Customer_SFID__r.City__c,Customer_SFID__r.Zip__c,Customer_SFID__r.Name,Customer_SFID__r.Email__c,Customer_SFID__r.Address__c,ReceiptNumber__c,Payment_Mode__c,Customer_SFID__c,Customer_SFID__r.Id,Amount__c,Tax_Type__c,Tax_Amount__c from Payment__c where Id =: OrderId1  ];   
               
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
                
                if(String.isNotBlank(String.valueOf(pmtInfo.sigmaerpdev2__Work_Order__r.Name))){
                    pmtOrderId = pmtInfo.sigmaerpdev2__Work_Order__r.Name; 
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
                if(String.isNotBlank(String.valueOf(pmtInfo.Due_Amount__c))){
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
            List<sigmaerpdev2__Work_Order__c> ord;
            
              ord = [select Account__r.ShippingAddress from sigmaerpdev2__Work_Order__c where Id =: OrderId1 ]; 
                
           
            for(sigmaerpdev2__Work_Order__c ordInfo: ord)
            {
                if(String.isNotBlank(String.valueOf(ordInfo.Account__r.ShippingAddress)))
                {
                    shippingAddress = String.valueOf(ordInfo.Account__r.ShippingAddress);
                } 
            }
            
            if(String.isBlank(shippingAddress))
            {
                shippingAddress =  customerAddress;
                
            }
            
            if(shippingAddress == null || shippingAddress == '')
            {
                shippingAddress =  customerAddress;
               
            }            
            
            
            attach.setContentType('application/pdf');
            attach.setFileName('Receipt.pdf');
            
            PageReference pdf =  Page.AttachmentPDF;
             
          if(!test.isrunningtest()) {
                Blob b = pdf.getContent();
            }
                

            
            for(sigmaerpdev2__Work_Order__c productLine: c)
            {                    
                 body1 += '<tr><td align="center">' + productLine.Account__r.Name + 
                    '</td><td align="center">' + productLine.Tax__c +
                    '</td><td align="center">' + productLine.TotalAmount__c +'</td></tr>';                                           
            }
            
            toMail.add(customerEmailId);   
            MessageBody = 'Hi '+customerName +',Attached payment receipt along with this email.Thanks & Regards';              
            
            body1 += '</table><br/>Payment Details:<br/><br/><table width="85%" border="1"><tr><td align="center">Date</td><td align="center">Rec. Number</td><td align="center">Mode</td><td align="center">WorkOrderId</td><td align="center">Paid Amount</td><td align="center">Due Amount</td></tr>' +
                '<tr><td align="center">'+paymentDate+'</td><td align="center">'+recptNumber+'</td><td align="center">'+mode +'</td><td align="center">'+pmtOrderId +'</td><td align="center">'+recAmt+'</td><td align="center">'+dueAmt+'</td></tr></table><br/>'+
                'Customer Details : <br /><br /><table width="76%" border = "1">' +
                '<tr><td>Name </td><td>'+customerName+'</td></tr>'+
                '<tr><td>Email </td><td>'+customerEmailId+'</td></tr>'+
                '<tr><td>Customer Number </td><td>'+customerNumber+'</td></tr>'+
                '<tr><td>Address </td><td>'+customerAddress+'</td></tr></table>'+
                '<br/>Shipping Address : <br /><table width="70%" border = "0"><tr><td>'+customerAddress+'</td></tr></table><table align="center"><tr><td><img src="'+dp.EmailImage__c +'" width="100%" height="30%" /></td></tr></table></html>';
            
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
    
   
    
     
}