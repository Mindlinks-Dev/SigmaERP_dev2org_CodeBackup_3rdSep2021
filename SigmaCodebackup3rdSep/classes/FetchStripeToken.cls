/*=====================================================

// FLS added Samad on 24th May 2018
=======================================================*/



global with sharing class FetchStripeToken {
 private static String TOKEN_URL = '';
    private static String API_KEY = '';
   
    global Integer created;
    global Boolean used;
    global StripeCard card;
    global String stripeObject;
    global Boolean livemode;
    global String id;
    
    global class StripeCard
    {
        global String stripeType;
        global String country;
        global Integer exp_month;
        global String fingerprint;
        global Integer exp_year;
        global String last4;
        global String stripeObject;
        global String id;
        global String name;
        global String customer_id;
    }
  
    global static FetchStripeToken fetchToken(Map<String, String> properties)
    {
        system.debug('line 35....');
       if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Stripe_API__c',new Set<String>{'id','sigmaerpdev2__Api_Key__c','sigmaerpdev2__Charge_URL__c','sigmaerpdev2__Token_URL__c'})){
        
          if (test.isRunningTest()){
            Test.setMock(HttpCalloutMock.class, new UploadFileMock());
        }
         
            Stripe_API__c sap;
           
            //if (CheckReadsap())
            //{
                sap = [select id,Api_Key__c,Charge_URL__c,Token_URL__c from Stripe_API__c where Token_URL__c != '' Limit 1];
                API_KEY = sap.Api_Key__c;
                TOKEN_URL = sap.Token_URL__c;
                
                //system.debug('sap >>>>'+sap );
                //system.debug('API_KEY >>>>'+API_KEY );
                //system.debug('TOKEN_URL >>>>'+TOKEN_URL );
               
            //}
       } 
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(TOKEN_URL);
        req.setMethod('POST');
        Blob headerValue = Blob.valueOf(API_KEY+ ':');
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        Map<String, String> payload = new Map<String, String>();
        
        if (properties != null) {
            for (String key : properties.keySet()) {
                if (properties.get(key) != null) {
                    payload.put('card['+key+']', properties.get(key));
                }
            }
        }
        
        req.setBody(StripeUtil.urlify(payload));
        httpResponse res = new httpResponse();
        http ht = new http();
        system.debug('req -->>>'+req );
            res = ht.send(req);
       system.debug('res -->>>'+res );
       
      
        try {
            return parse(res.getBody());
        } catch (System.JSONException e) {
            return parse(res.getBody());
        }
       }
        
   
    
    public static FetchStripeToken parse(String json) {
        json = StripeUtil.cleanJson(json);
        
        return (FetchStripeToken) System.JSON.deserialize(json, FetchStripeToken.class);
    }
    public Static boolean CheckReadsap(){        
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Stripe_API__c',new Set<String>{'id','sigmaerpdev2__Api_Key__c','sigmaerpdev2__Charge_URL__c','sigmaerpdev2__Token_URL__c'}))
        {            
           return true;
        }  
        return false;
     }
   
}