public without sharing class OrderSendEmailCntrl
{
    /**
* Aura enabled method to search a specified SObject for a specific string
*/
    @AuraEnabled
    public static String sendEmail(List<Id>OrderIds)
    {
        
        String result;
        String MessageBody;
        String body1 ;
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
		Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
		List<String> toMail = new List<String>();
		Default_Parameters__c dp=[select Logo__c,Company_Name__c,EmailImage__c from Default_Parameters__c Limit 1]; 
		body1 = '<html><table align="center"> ' +
		'<tr><td><img src="'+dp.Logo__c+'" width="100%" height="30%" /></td></tr><tr><td>' +
		'<strong>'+dp.Company_Name__c+'</strong><br/></td></tr>';
            
        List<Sigma_Order__c> c = [select AccountId__r.Name,AccountId__c,AccountId__r.Address__c,AccountId__r.City__c,AccountId__r.Zip__c,AccountId__r.State__c,AccountId__r.Country__c,AccountId__r.Email__c,Paid_Amount__c,Due_Amount__c,TotalProductPrice__c,Net_Amount__c,Discount__c,Discount_New__c,Tax__c,TotalAmount__c from Sigma_Order__c  where Id IN:OrderIds];
              
		List<Payment__c> p = [select Payment_Time__c,Due_Amount__c,Amount_Recevied__c, Sigma_Order__r.Name,ReceiptNumber__c,Payment_Mode__c,Sigma_Order__c,Customer_SFID__r.Id,Amount__c,Tax_Type__c,Tax_Amount__c,Sigma_Order__r.Order_Number__c from Payment__c ORDER BY Createddate DESC limit 1];

 
        if(c.size() > 0)
		{
			body1 += '<tr><td>Your Order details are shown below for your reference.</td></tr></table>' +
				'<br/>Order Details:<br/><br/><table align="left" width="75%" border = "1">' +
				'<tr><th align="center">Account Name</th><th align="center">Total Product Price</th><th align="center">Discount(%)</th><th align="center">Total Amount</th><th align="center">Tax(%)</th><th align="center">Net Amount</th></tr>';      
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
                    '</td><td align="center">' + productLine.TotalAmount__c +'</td></tr>';                                           
            }
            
            toMail.add(c[0].AccountId__r.Email__c);   
            MessageBody = 'Hi '+c[0].AccountId__r.Name +',\nAttached payment receipt along with this email. \nThanks & Regards';              
            
            body1 += '</table><br/>Payment Details:<br/><br/><table width="85%" border="1"><tr><td align="center">Date</td><td align="center">Rec. Number</td><td align="center">Mode</td><td align="center">Cust. Number</td><td align="center">Paid Amount</td><td align="center">Due Amount</td></tr>' +
                '<tr><td align="center">'+p[0].Payment_Time__c+'</td><td align="center">'+p[0].ReceiptNumber__c+'</td><td align="center">'+p[0].Payment_Mode__c +'</td><td align="center">'+p[0].Customer_SFID__r.Id+'</td><td align="center">'+p[0].Amount_Recevied__c+'</td><td align="center">'+p[0].Due_Amount__c+'</td></tr></table><br/>'+
                'Customer Details : <br /><br /><table width="76%" border = "1">' +
                '<tr><td>Name </td><td>'+c[0].AccountId__r.Name+'</td></tr>'+
                '<tr><td>Email </td><td>'+c[0].AccountId__r.Email__c+'</td></tr>'+
                '<tr><td>Customer Number </td><td>'+c[0].AccountId__c+'</td></tr></table>'+
                '<table align="center"><tr><td><img src="'+dp.EmailImage__c +'" width="100%" height="30%" /></td></tr></table></html>';
            
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
       public static string SendEmailOrder(List<Id>OrderIds)
       {
        String result;
        String MessageBody;
        String body1 ;
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
   
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        List<String> toMail = new List<String>();
        
        Default_Parameters__c dp=[select Logo__c,Company_Name__c,EmailImage__c from Default_Parameters__c]; 
        
        body1 = '<html><table align="center"' +
                '<tr><td><img src="'+dp.Logo__c+'"width="100%" height="30%" /> </td> </tr> <tr><td>'+
                 '<strong>'+dp.Company_Name__c+'</strong><br/></td></tr>';

        
         List<Order> ord = [select Id,CustomerAddress__c,AccountId,Account.Name,Account.Address__c,Account.City__c,Account.Zip__c,Account.State__c,Account.Country__c,Account.Email__c,Paid_Amount__c,Due_Amount__c,Total_product_Price__c,Net_Amount__c,Discount__c,Tax__c,TotalAmount__c  from Order where Id =: OrderIds];
          
         List<Payment__c> OrdPayment =  [select Id,Payment_Time__c,Due_Amount__c,Amount_Recevied__c, OrderId__r.Name,ReceiptNumber__c,Payment_Mode__c,OrderId__c,Customer_SFID__r.Id,Customer_SFID__r.Email__c,Customer_SFID__r.Name,Customer_SFID__c,Customer_SFID__r.Address__c,Customer_SFID__r.City__c,Customer_SFID__r.Zip__c,Customer_SFID__r.State__c,Customer_SFID__r.Country__c ,Amount__c,Tax_Type__c,Tax_Amount__c,OrderId__r.OrderNumber from Payment__c ORDER BY Createddate DESC limit 1 ];
          
         
          
        if(ord.size() > 0)
        {
            body1 += '<tr><td>Your Order details are shown below for your reference.</td></tr></table>' +
                '<br/>Order Details:<br/><br/><table align="left" width="75%" border = "1">' +
                '<tr><th align="center">Account Name</th><th align="center">Total Product Price</th><th align="center">Discount(%)</th><th align="center">Total Amount</th><th align="center">Tax(%)</th><th align="center">Net Amount</th></tr>';      
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
            
            toMail.add(ord[0].Account.Email__c);
            MessageBody = 'Hi '+ord[0].Account.Name +',\nAttached payment receipt along with this email. \nThanks & Regards';              

            body1 += '</table><br/>Payment Details:<br/><br/><table width="85%" border="1"><tr><td align="center">Date</td><td align="center">Rec. Number</td><td align="center">Mode</td><td align="center">Cust. Number</td><td align="center">Paid Amount</td><td align="center">Due Amount</td></tr>' +
                        '<tr><td align="center">'+OrdPayment[0].Payment_Time__c+'</td><td align="center">'+OrdPayment[0].ReceiptNumber__c+'</td><td align="center">'+OrdPayment[0].Payment_Mode__c +'</td><td align="center">'+OrdPayment[0].Customer_SFID__c+'</td><td align="center">'+OrdPayment[0].Amount_Recevied__c+'</td><td align="center">'+OrdPayment[0].Due_Amount__c+'</td></tr></table><br/>'+
                        'Customer Details : <br /><br /><table width="76%" border = "1">' +
                        '<tr><td>Name </td><td>'+ord[0].Account.Name+'</td></tr>'+
                        '<tr><td>Email </td><td>'+ord[0].Account.Email__c+'</td></tr>'+
                        '<tr><td>Customer Number </td><td>'+ord[0].Account+'</td></tr></table>'+
                        '<table align="center"><tr><td><img src="'+dp.EmailImage__c +'" width="100%" height="30%" /></td></tr></table></html>';

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