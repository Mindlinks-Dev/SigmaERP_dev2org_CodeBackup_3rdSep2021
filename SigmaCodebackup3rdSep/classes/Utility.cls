public with sharing class Utility {
    public static void getInvoicePDFContent(String currentRecordId) {    
        system.debug('************ APEX CLASS - UTILITY***************');
        System.debug('getFinalPDFContent - START');     
        // querying WO
        //Work_Order__c recordDetailForPDF = new Work_Order__c();
        
        Work_Order__c recordDetailForPDF;
        if(Schema.sObjectType.Work_Order__c.isAccessible()){
            recordDetailForPDF = [Select Id,Name,Version_Number__c,Case_Number_text__c,Case_Subject_text__c,FFP_MR_Contact__r.Email,Account__r.Email__c,FFP_MR_Contact__r.Name,Account__r.Name,CreatedDate,Include_Invoice_in_Service_Order_Report__c  FROM Work_Order__c where Id = : currentRecordId];       
        }
        else{
            system.debug('Work Order not Accessible');
        }
        
        PageReference pdf;
        
        
            pdf = Page.service_invoice1;
        
        pdf.getParameters().put('id', currentRecordId); 
        
        /********************************************     Files insert check               *******************************/
        
        
        List<Work_Oder_Lines__c> WoLineitemCheck;
        if(Schema.sObjectType.Work_Oder_Lines__c.fields.Name.isAccessible()){
            WoLineitemCheck = [SELECT Id,Name FROM Work_Oder_Lines__c where Work_Order__c = : currentRecordId];
        }
        else{
            system.debug('Work Order Line Items not Accessible');
        }
        
        if( !WoLineitemCheck.isEmpty()){
            system.debug('Inside WOLineItemCheck If Condition');
            Integer latestVersionNumber;
            if(recordDetailForPDF.Version_Number__c !=null){
                latestVersionNumber = recordDetailForPDF.Version_Number__c.intValue();            
                if(latestVersionNumber>=1){
                    latestVersionNumber=latestVersionNumber+1;
                }
            }else {
                latestVersionNumber = 1;
            }        
            Blob body;
            try {
                body = pdf.getContentAsPDF();
            } catch (VisualforceException e) {
                body = Blob.valueOf('Some Text');
            }
            //  body = EncodingUtil.base64Decode(body);
            
            String[] contectVersionFields = new String[] {'ContentLocation','VersionData','Title','PathOnClient'}; 
                
                // Obtaining the field name/token map for the Contact object
                Map<String,Schema.SObjectField> m = Schema.SObjectType.ContentVersion.fields.getMap();
            for (String fieldToCheck : contectVersionFields) {
                // Check if the user has create access on the each field
                if (!m.get(fieldToCheck).getDescribe().isCreateable()) {
                    system.debug('No access for Content Version');
                    return;
                }
            }
            
            ContentVersion cv = new ContentVersion();
            cv.ContentLocation = 'S';
            //cv.ContentDocumentId = ContentDocumentId;
            cv.VersionData = body;
            cv.Title = recordDetailForPDF.Name + '_INVOICE_V'+string.valueof(latestVersionNumber)+'.pdf';
            cv.PathOnClient = '/TestFilePreview.pdf';   
            // cv.ContentUrl='pdf';    
            
            if(Schema.sObjectType.ContentVersion.isCreateable()){    
                insert cv;
            }
            else{
                system.debug('ContentVersion is not createable...');
            }
            
            ContentDocumentLink cdl = new ContentDocumentLink();
            if(Schema.sObjectType.ContentDocumentLink.fields.ContentDocumentId.isAccessible()){
                cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
            }
            else{
                system.debug('Content Version not Accessible');
            }
            
            String[] contentDocumentLinkFields = new String[] {'LinkedEntityId','ShareType','Visibility'}; 
                
                // Obtaining the field name/token map for the ContentDocumentLink object
                Map<String,Schema.SObjectField> mcdlf = Schema.SObjectType.ContentDocumentLink.fields.getMap();
            for (String fieldToCheck : contentDocumentLinkFields) {
                // Check if the user has create access on the each field
                if (!mcdlf.get(fieldToCheck).getDescribe().isCreateable()) {
                    system.debug('No access for ContentDocumentLink');
                    return;
                }
            }
            cdl.LinkedEntityId = currentRecordId;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            
            if(Schema.sObjectType.ContentDocumentLink.isCreateable()){ 
                insert cdl;
            }
            else{
                system.debug('ContentDocumentLink is not createable...');
            }
            
            Invoice__c TempInv = new Invoice__c();
            if(Schema.sObjectType.Invoice__c.fields.Related_Work_Order__c .isCreateable()){
                TempInv.Related_Work_Order__c = currentRecordId; 
            }
            else{
                system.debug('No access on Invoice__c - Related_Work_Order__c Field');
            }
            if(Schema.sObjectType.Invoice__c.isCreateable()){ 
                insert TempInv;
            }
            else{
                system.debug('Invoice__c is not createable...');
            }
            
            ContentDocumentLink cdlINvoice = new ContentDocumentLink();
            if(Schema.sObjectType.ContentDocumentLink.fields.ContentDocumentId.isAccessible()){
                cdlINvoice.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
            }
            else{
                system.debug('Content Version not Accessible');
            }
            
            cdlINvoice.LinkedEntityId = TempInv.Id;
            cdlINvoice.ShareType = 'V';
            cdlINvoice.Visibility = 'AllUsers';
            if(Schema.sObjectType.ContentDocumentLink.isCreateable()){
                insert cdlINvoice;
            }
            else{
                system.debug('ContentDocumentLink is not createable...');
            }
            if(Schema.sObjectType.Work_Order__c.fields.Version_Number__c.isUpdateable()){
                recordDetailForPDF.Version_Number__c= latestVersionNumber;
            }
            else{
                system.debug('No access on Work_Order__c - Version_Number__c Field');
            }
            if(Schema.sObjectType.Work_Order__c.isUpdateable()){
                update recordDetailForPDF;
            }
            else{
                system.debug('Work_Order__c is not updateable...');
            }
            //Send  Email 
            String contentType = 'application/pdf';
            try{
                EmailTemplate et;
                // EmailTemplate Fields that will be accessed.
                String [] emailFields = new String [] {'Name','Description','Subject','Body'};
                    
                    // Obtaining the field name/token map for the EmailTemplate object
                    Map<String,Schema.SObjectField> emailMap = Schema.SObjectType.EmailTemplate.fields.getMap();
                for (String fieldToCheck : emailFields) {
                    // Check if the user has create access on the each field
                    if (!emailMap.get(fieldToCheck).getDescribe().isAccessible()) {
                        system.debug('Has no Access on EmailTemplate Fields');
                        return;
                    }
                }
                et = [SELECT id, Name, Description, Subject, Body from EmailTemplate where name = 'Send Invoice To Customer Email'];
                
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();            
                String subject = et.Subject;
                if(recordDetailForPDF.Case_Number_text__c!= null){
                    subject = subject.replace('{!Work_Order__c.CaseNumber}', recordDetailForPDF.Case_Number_text__c);
                } 
                if(recordDetailForPDF.Case_Subject_text__c != null){
                    subject = subject.replace('{!Work_Order__c.Case_Subject_text__c}', recordDetailForPDF.Case_Subject_text__c);
                } 
                mail.setSubject(subject);            
                String emailbody = et.Body;
                if(recordDetailForPDF.Case_Number_text__c != null){
                    emailbody= emailbody.replace('{!Work_Order__c.Case_Number_text__c}', recordDetailForPDF.Case_Number_text__c);
                } 
                if(recordDetailForPDF.Case_Subject_text__c != null){
                    emailbody= emailbody.replace('{!Work_Order__c.Case_Subject_text__c}', recordDetailForPDF.Case_Subject_text__c);
                }
                if(recordDetailForPDF.CreatedDate != null){
                    emailbody= emailbody.replace('{!Work_Order__c.CreatedDate}', (recordDetailForPDF.CreatedDate ).format());
                }
               //commented bellow line to send mail to account mail id
                /*  if(recordDetailForPDF.FFP_MR_Contact__r.Name != null){
                    emailbody= emailbody.replace('{!Contact.Name}', recordDetailForPDF.FFP_MR_Contact__r.Name);
                }*/
                if(recordDetailForPDF.Account__r.Name != null){
                    emailbody= emailbody.replace('{!Contact.Name}', recordDetailForPDF.Account__r.Name);
                }
                mail.setPlainTextBody(emailbody);            
                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                attach.setBody(cv.VersionData);
                attach.setFileName(cv.Title);
                attach.setContentType(contentType);
                attach.setInline(false);
                Messaging.EmailFileAttachment[] attachment = new Messaging.EmailFileAttachment[]{attach};
                    mail.setFileAttachments(attachment);
                // String[] ccAddrs = new String[]{UserInfo.getUserEmail(),'chethan.sn@crmit.com'};
                // mail.setCcAddresses(ccAddrs);
                // String[] toEmailIds = new String[]{'jyoshna.a@crmit.com'};
                String[] toEmailIds = new String[]{};
                     //commented bellow line to send mail to account mail id
                  /*  if(String.isNotEmpty(recordDetailForPDF.FFP_MR_Contact__r.Email)){
                        toEmailIds.add(recordDetailForPDF.FFP_MR_Contact__r.Email);
                    } */
                 if(String.isNotEmpty(recordDetailForPDF.Account__r.Email__c)){
                        toEmailIds.add(recordDetailForPDF.Account__r.Email__c);
                    } 
                mail.setToAddresses(toEmailIds);
                mail.setReplyTo('noreply@gmail.com');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
                //update the status field
                Invoice__c TempStatus;
                if(Schema.sObjectType.Invoice__c.fields.Status__c.isAccessible()){
                    TempStatus = [Select Id,Status__c from Invoice__c where id=:TempInv.Id];
                }
                else{
                    system.debug('Invoice not Accessible');
                }
                if (Schema.sObjectType.Invoice__c.fields.Status__c.isUpdateable()){
                    TempStatus.Status__c = 'Sent';
                }
                else{
                    system.debug('No access on Invoice__c - Status__c Field');
                }
                
                if(Schema.sObjectType.Invoice__c.isUpdateable()){
                    update TempStatus;
                }
            }catch(Exception emailSendEx){
                System.debug('Send Email Error:'+emailSendEx);
                //createErrorLog.insertError('ManufacturingRun',emailSendEx.getMessage(),'Method - getInvoicePDFContent',null,'',emailSendEx.getStackTraceString(),UserInfo.getUserId());
            }
        }
        else{
            system.debug('Inside Else Email');        
            try{
                EmailTemplate et;
                // EmailTemplate Fields that will be accessed.
                String [] emailFields = new String [] {'Name','Description','Subject','Body'};
                    
                    // Obtaining the field name/token map for the EmailTemplate object
                    Map<String,Schema.SObjectField> emailMap = Schema.SObjectType.EmailTemplate.fields.getMap();
                for (String fieldToCheck : emailFields) {
                    // Check if the user has create access on the each field
                    if (!emailMap.get(fieldToCheck).getDescribe().isAccessible()) {
                        system.debug('Has no Access on EmailTemplate Fields');
                        return;
                    }
                }
                if(Schema.sObjectType.EmailTemplate.isAccessible()){
                    et = [SELECT id, Name, Description, Subject, Body from EmailTemplate where name = 'NotifyCustomerWithoutPDF'];
                }
                else{
                    system.debug('Email Template not Accessible');
                }
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();            
                String subject = et.Subject;
                if(recordDetailForPDF.Case_Number_text__c!= null){
                    subject = subject.replace('{!Work_Order__c.Case_Number_text__c}', recordDetailForPDF.Case_Number_text__c);
                } 
                if(recordDetailForPDF.Case_Subject_text__c != null){
                    subject = subject.replace('{!Work_Order__c.Case_Subject_text__c}', recordDetailForPDF.Case_Subject_text__c);
                } 
                mail.setSubject(subject);            
                String emailbody = et.Body;
                if(recordDetailForPDF.Case_Number_text__c != null){
                    emailbody= emailbody.replace('{!Work_Order__c.Case_Number_text__c}', recordDetailForPDF.Case_Number_text__c);
                } 
                if(recordDetailForPDF.Case_Subject_text__c != null){
                    emailbody= emailbody.replace('{!Work_Order__c.Case_Subject_text__c}', recordDetailForPDF.Case_Subject_text__c);
                }
                if(recordDetailForPDF.CreatedDate != null){
                    emailbody= emailbody.replace('{!Work_Order__c.CreatedDate}', (recordDetailForPDF.CreatedDate).format());
                }
                //commented bellow line to send mail to account mail id
               /* if(recordDetailForPDF.FFP_MR_Contact__r.Name != null){
                    emailbody= emailbody.replace('{!Contact.Name}', recordDetailForPDF.FFP_MR_Contact__r.Name);
                }*/
                 if(recordDetailForPDF.Account__r.Name != null){
                    emailbody= emailbody.replace('{!Contact.Name}', recordDetailForPDF.Account__r.Name);
                }
                mail.setPlainTextBody(emailbody);
                // String[] ccAddrs = new String[]{UserInfo.getUserEmail(),'chethan.sn@crmit.com'};
                // mail.setCcAddresses(ccAddrs);
                //String[] toEmailIds = new String[]{'chethan.sn@crmit.com'};
                String[] toEmailIds = new String[]{};
                    //commented bellow line to send mail to account mail id
                   /* if(String.isNotEmpty(recordDetailForPDF.FFP_MR_Contact__r.Email)){
                        toEmailIds.add(recordDetailForPDF.FFP_MR_Contact__r.Email);
                    } */
                 if(String.isNotEmpty(recordDetailForPDF.Account__r.Email__c)){
                        toEmailIds.add(recordDetailForPDF.Account__r.Email__c);
                    } 
                mail.setToAddresses(toEmailIds);
                mail.setReplyTo('noreply@gmail.com');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }catch(Exception emailSendEx){
                System.debug('Send Email Error at Else:'+emailSendEx);
                //createErrorLog.insertError('ManufacturingRun',emailSendEx.getMessage(),'Method - getInvoicePDFContent',null,'',emailSendEx.getStackTraceString(),UserInfo.getUserId());
            }        
        }    
    }     
    
    public static String getPDFContentAsBase64(String currentRecordId) {
        //  setting Row Id
        System.debug('getFinalPDFContent - START');
        System.debug('getFinalPDFContent - START');
        
        Work_Order__c recordDetailForPDF;
        if(Schema.sObjectType.Work_Order__c.isAccessible()){
            recordDetailForPDF = [Select Id,Include_Invoice_in_Service_Order_Report__c  FROM Work_Order__c where Id = : currentRecordId];       
        }
        else{
            system.debug('Work Order not Accessible');
        }
        
        PageReference pdf;
        if(recordDetailForPDF.Include_Invoice_in_Service_Order_Report__c == true){
            System.debug('Inside Invoice Condition');
            pdf = Page.InvoiceTemplateVF;
            System.debug('Inside Invoice Condition - '+pdf);
        }
        else{
            system.debug('No need of Invoice ');
            pdf = Page.InvoiceTemplateToBeMailed;
            System.debug('Inside else Invoice Condition - '+pdf);
        }
        pdf.getParameters().put('id', currentRecordId); 

        
        // Noinv.getParameters().put('id', currentRecordId);
        
        //system.debug('currentRecordId'+currentRecordId);
        // get pdf content
        List<Work_Oder_Lines__c> WoLineitemCheck;
        if(Schema.sObjectType.Work_Oder_Lines__c.fields.Name.isAccessible()){
            WoLineitemCheck = [SELECT Id,Name FROM Work_Oder_Lines__c where Work_Order__c = : currentRecordId];
        }
        else{
            system.debug('Work Order not Accessible');
        }
        
        if( !WoLineitemCheck.isEmpty()){
            Blob body;
            try {
                System.debug('try');
                body = pdf.getContentAsPDF();
            } catch (VisualforceException e) {
                body = Blob.valueOf('Some Text');
            }
            system.debug('response : '+EncodingUtil.base64Encode(body));
            return EncodingUtil.base64Encode(body);
        }else{
            /*
Blob body;
try{
body = Noinv.getContentAsPDF();
//  body = Blob.valueOf('No Invoice Available');
}catch(VisualforceException e){
body = Blob.valueOf('Some Text');
}
return EncodingUtil.base64Encode(body);
*/          
            return 'No Invoice Available';
        }
        
    }
}