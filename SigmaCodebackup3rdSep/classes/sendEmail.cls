public with sharing class sendEmail {
   
 
  @AuraEnabled
    public static void send(id acctid) {
       system.debug('acctid>>>'+acctid);
        Service_Quote__c wo= [SELECT Name,Account__r.Email__c
                   FROM Service_Quote__c
                   WHERE Id = :acctid];
       
        // Define the email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
 
        
        PageReference pdf =  Page.DownloadQuotePDF;
        pdf.getParameters().put('id',acctid); 
        pdf.setRedirect(true);
 
        // Take the PDF content
        Blob b = pdf.getContent();
 
        // Create the email attachment
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('DownloadQuote.pdf');
        efa.setBody(b);
        
       
 
        List<String> toAddress=new List<String>();
        if (wo.Account__r.Email__c != null) {
        system.debug('wo.Account__r.Email__c??'+wo.Account__r.Email__c);
            toAddress.add(wo.Account__r.Email__c);
           system.debug('toAddress??'+toAddress);

        }
 
       String subject='Service Quotation';
       String body='Please find the service quote attachted to this mail.';
 
        // Sets the paramaters of the email
        email.setSubject( subject );
        email.setToAddresses(toAddress);
        email.setPlainTextBody( body );
 
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
 
        // Sends the email
        Messaging.SendEmailResult [] r = 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
        
       
    }
}