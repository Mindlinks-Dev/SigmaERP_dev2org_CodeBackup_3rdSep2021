public class SignatureCtr{
    @AuraEnabled
    public static void saveSignature(String signatureBody){
       Attachment a = new Attachment();
        a.ParentId = 'a097F00000765JA'; // record id of object.
        a.Body = EncodingUtil.base64Decode(signatureBody);
        a.ContentType = 'image/png';
        a.Name = 'Signature Capture.png';
        insert a;
    }
}