global with sharing class StripeCustomer 
{
    private static String CUS_URL = '';
    private static String API_KEY = '';
    
    global Integer created;
    global Integer account_balance;
    global String description;
    global Boolean livemode;
    global String token;
    global String id;
    global Map<String, String> metadata;
    global String default_card;
    
    global static StripeCustomer updateCustomer(String customerId, Map<String, String> properties, Map<String, String> metadata) 
    {
      HttpRequest http = new HttpRequest();
        Stripe_API__c sap;
        //==================[Checking FLS]=============
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Stripe_API__c',new set<String>{'id','sigmaerpdev2__Api_Key__c','sigmaerpdev2__Charge_URL__c','sigmaerpdev2__Token_URL__c','sigmaerpdev2__Customer_URL__c'}))
        {
               sap = [select id,Api_Key__c,Charge_URL__c,Token_URL__c,Customer_URL__c from Stripe_API__c Limit 1];
                CUS_URL = sap.Customer_URL__c;
                API_KEY = sap.Api_Key__c;   
           
        }
        
        if (customerId == null) 
            http.setEndpoint(CUS_URL);
        else 
            http.setEndpoint(CUS_URL+'/'+customerId);
        
        http.setMethod('POST');
        Blob headerValue = Blob.valueOf(API_KEY + ':');
        String authorizationHeader = 'BASIC ' +
        EncodingUtil.base64Encode(headerValue);
        http.setHeader('Authorization', authorizationHeader);
        
        Map<String, String> payload = new Map<String, String>();
        if (properties != null) {
            for (String key : properties.keySet()) {
                if (properties.get(key) != null) {
                    payload.put(key, properties.get(key));
                }
            }
        }
        
        if (metadata != null) {
            for (String key : metadata.keySet()) {
                if (metadata.get(key) != null) {
                    payload.put('metadata['+key+']', metadata.get(key));
                }
            }
        }
    http.setBody(StripeUtil.urlify(payload));
        
        String response;
        Integer statusCode;
        Http con = new Http();
        HttpResponse hs = new HttpResponse();
           try {
                hs = con.send(http);
                
            } catch (CalloutException e) {
                return null;
            }
        
        statusCode = hs.getStatusCode();
        
        try {
            StripeCustomer new_customer = StripeCustomer.parse(hs.getBody());
            return new_customer;
        } catch (System.JSONException e) {
            return null;
        }
    }
    
    public static StripeCustomer parse(String json) {
        json = StripeUtil.cleanJson(json);
        return (StripeCustomer) System.JSON.deserialize(json, StripeCustomer.class);
    }
   
}