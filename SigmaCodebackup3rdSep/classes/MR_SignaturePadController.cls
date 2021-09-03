public with sharing class MR_SignaturePadController {
		public MR_SignaturePadController(ApexPages.StandardController stdController){
 
    } 
     @RemoteAction
    public static String uploadSignature(String b64SignData, String id){
        returnData ret = new returnData();
        ret.success = true;
        ret.message = 'Signature uploaded successfully';
        Blob signature = EncodingUtil.base64Decode(b64SignData);
       /* try{
            Blob signature = EncodingUtil.base64Decode(b64SignData);
            if(Schema.sObjectType.Attachment.isAccessible()){
                Attachment att = new Attachment();
                if(Schema.sObjectType.Attachment.fields.body.isCreateable()){
                    att.body = signature;
                }
            	if(Schema.sObjectType.Attachment.fields.ContentType.isCreateable()){
                    att.ContentType = 'image/png';
                }
                if(Schema.sObjectType.Attachment.fields.name.isCreateable()){
                    att.name = 'eSignature_dtd_' + Datetime.now().format('MM_dd_yyyy_HH_MM_ss');
                }
                if(Schema.sObjectType.Attachment.fields.IsPrivate.isCreateable()){
                    att.IsPrivate = false;
                }
            	if(Schema.sObjectType.Attachment.fields.ParentId.isCreateable()){
                    att.ParentId = id;
                }
            	insert att;
            }
            
        }catch(Exception e){
            ret.success = false;
            ret.message = e.getMessage();
        }    */
        try{
             String[] contectVersionFields = new String[] {'ContentLocation','VersionData','Title','PathOnClient'}; 
                
                // Obtaining the field name/token map for the Contact object
                Map<String,Schema.SObjectField> m = Schema.SObjectType.ContentVersion.fields.getMap();
            for (String fieldToCheck : contectVersionFields) {
                // Check if the user has create access on the each field
                if (!m.get(fieldToCheck).getDescribe().isCreateable()) {
                    system.debug('No access for Content Version');
                    return null;
                }
            }
         ContentVersion cv = new ContentVersion();
            cv.ContentLocation = 'S';
            cv.VersionData = signature;
            cv.Title = 'eSignature_dtd_' + Datetime.now().format('MM_dd_yyyy_HH_MM_ss');
            cv.PathOnClient = '/TestFilePreview.png';	
            // cv.ContentUrl='pdf';        
            insert cv;
            
             String[] ContentDocumentLinkFields = new String[] {'LinkedEntityId','ContentDocumentId','ShareType','Visibility'}; 
                
                // Obtaining the field name/token map for the Contact object
                Map<String,Schema.SObjectField> m1 = Schema.SObjectType.ContentDocumentLink.fields.getMap();
            for (String fieldToCheck : ContentDocumentLinkFields) {
                // Check if the user has create access on the each field
                if (!m1.get(fieldToCheck).getDescribe().isCreateable()) {
                    system.debug('No access for ContentDocumentLink');
                    return null;
                }
            }
            
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
            cdl.LinkedEntityId = Id;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            insert cdl;
        }catch(Exception e){
            system.debug('Exception while inserting signature :'+e);
        }
        return JSON.serialize(ret);
    }
 
     private class returnData{
        Boolean success {get;set;}
        String message {get;set;}
    }
}