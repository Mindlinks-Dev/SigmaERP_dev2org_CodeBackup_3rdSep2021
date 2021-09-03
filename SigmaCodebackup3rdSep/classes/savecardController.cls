public with sharing class savecardController {
     
    public savecardController(ApexPages.StandardController controller)
    {    
    }
    @AuraEnabled
    public static Customer_Saved_Card__c cardsave(Customer_Saved_Card__c savecarddetails)
    { 
        Customer_Saved_Card__c encryptedcard;    
       if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Customer_Saved_Card__c')
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Customer_Saved_Card__c',new Set<String>{'sigmaerpdev__Source__c','sigmaerpdev__Credit_Card_No__c','sigmaerpdev__SFDC_Account__c','sigmaerpdev__Card_Number__c','sigmaerpdev__CVVNO__c','sigmaerpdev__SourceCvv__c','sigmaerpdev__Card_Type__c'}))
        {
    
          encryptedcard = savecarddetails.clone(false, false, false, false);
        
        //to store key
        Blob encryptKey = Crypto.generateAesKey(256);
        encryptedcard.Source__c = EncodingUtil.base64Encode(encryptKey);
       
       String myString = savecarddetails.Credit_Card_No__c;
       String myString1 = savecarddetails.SourceCvv__c;
        Blob data = Blob.valueOf(myString);
        Blob data1 = Blob.valueOf(myString1);
        encryptedcard.Credit_Card_No__c= ( cardencription(data,encryptKey) );
        encryptedcard.SFDC_Account__c = savecarddetails.SFDC_Account__c;
        encryptedcard.Card_Number__c = 'XXXX XXXX XXXX '+savecarddetails.Credit_Card_No__c.substring(11, 15);
       
        //encryptedcard.CVVNO__c= savecarddetails.CVVNO__c;
        encryptedcard.SourceCvv__c=( cardencription(data1,encryptKey) );
        encryptedcard.CVVNO__c=savecarddetails.SourceCvv__c.replace(savecarddetails.SourceCvv__c, 'XXX');
        
        encryptedcard.Card_Type__c=savecarddetails.Card_Type__c;

        insert encryptedcard;
        system.debug('encryptedcard::'+encryptedcard);
        }
        return encryptedcard;
    }
    //code added to Restrict duplicate credit card entry for same customer -by rashmi on 05-05-2020
    @AuraEnabled
    public static List<Customer_Saved_Card__c> fetchcardDetails(String customerId)
    {
        system.debug('customerId>>'+customerId);
       
        List<Customer_Saved_Card__c> cardinfo;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Customer_Saved_Card__c') 
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Customer_Saved_Card__c',new set<String>{'id','Name','sigmaerpdev__Customer_Name__c','sigmaerpdev__SFDC_Account__c','sigmaerpdev__Expiry_Month__c','sigmaerpdev__Expiry_Year__c','sigmaerpdev__Credit_Card_No__c','sigmaerpdev__Card_Number__c','sigmaerpdev__Status__c','sigmaerpdev__Card_Type__c','sigmaerpdev__UserEmail__c','sigmaerpdev__Default_Card__c','sigmaerpdev__CVVNO__c','sigmaerpdev__SourceCvv__c'}))
        {
           
            if(customerId !=null && customerId !='')
            {
                cardinfo =[select id,name,Customer_Name__c,SFDC_Account__c,Expiry_Month__c,Expiry_Year__c,Card_Number__c,Credit_Card_No__c,Status__c,Card_Type__c,UserEmail__c,Default_Card__c,CVVNO__c,SourceCvv__c from Customer_Saved_Card__c where SFDC_Account__c=:customerId limit 1000];                
            system.debug('cardinfo>>'+cardinfo);
            }
        }
        return cardinfo;
    }
    public static string cardencription(Blob arg,Blob cryptoKey)
    {
       
        Blob encryptedData = Crypto.encryptWithManagedIV('AES256', cryptoKey, arg);
        String encodedCipherText = EncodingUtil.base64Encode(encryptedData );
         Blob encodedEncryptedBlob = EncodingUtil.base64Decode(encodedCipherText);
         Blob decryptedData = Crypto.decryptWithManagedIV('AES256', cryptoKey, encodedEncryptedBlob );
        String decryptedDataString = decryptedData.toString();
        return encodedCipherText;
    }
}