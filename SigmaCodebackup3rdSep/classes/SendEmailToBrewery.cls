public with sharing class SendEmailToBrewery {
	
	public static void emailtobrewery(Id orderId){
	List<String> toMail = new List<String>();	
    Sigma_Order__c orderdata = [Select id,name,Brewer_Account__c,Brewer_Account__r.Name,AccountId__c,AccountId__r.Name,AccountId__r.Email__c,AccountId__r.Phone,Customer_Email__c from Sigma_Order__c where id =:orderId];
	 
		if(orderdata.Brewer_Account__c !=null)
		{
			Brewery_Registry__c BR = [select id,Brewer_Account__c,Email__c from Brewery_Registry__c where Brewer_Account__c=:orderdata.Brewer_Account__c];
			if(BR.Email__c !=null)
			{
				toMail.add(BR.Email__c);
			}
		}
		
		if(toMail.size()>0)
		{
			//String MessageBody = 'Hi '+customerName +',Attached payment receipt along with this email.Thanks & Regards';  
			String completeMailBody='<html>Dear '+orderdata.Brewer_Account__r.Name+',<br/><br/>Payment is received for order number '+ orderdata.name+'<br/>Customer Name : '+orderdata.AccountId__r.Name +'<br/>Email :'+orderdata.AccountId__r.Email__c +'<br/>Phone :'+orderdata.AccountId__r.Phone+'<br/><br/>Regards,<br/>FFTB Team</html>';
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();     
			mail.setToAddresses(toMail); 
			mail.setSubject('Payment Received');
			mail.setHTMLBody(completeMailBody);
			mail.setSaveAsActivity(false);  
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
		}
		
	}

}