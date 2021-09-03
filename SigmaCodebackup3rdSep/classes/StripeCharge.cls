global with sharing class StripeCharge 
{
    private static String CHARGE_URL = '';
    private static String API_KEY = '';
    
    global Decimal amount;
    global Integer created;
    global String stripeCurrency;
    global String customer_id;
    global StripeCustomer customer;
    global String description;
    global Boolean disputed;
    global Integer fee;
    global String id;
    global Boolean livemode;
    global String stripeObject;
    global Boolean paid;
    global Boolean refunded;
    global Integer amount_refunded;
    global String invoice_id;
    global String balance_transaction;
    global String failure_message;
    global Map<String, String> metadata;
    
    
    
    global static StripeCharge charge(String customerId, Decimal amount, Map<String, String> properties, Map<String, String> metadata) 
    {
        //==========================[checking FLS]=============
        //FLS Check : Sandhya
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Stripe_API__c',new set<String>{'id','sigmaerpdev2__Api_Key__c','sigmaerpdev2__Charge_URL__c','sigmaerpdev2__Token_URL__c','sigmaerpdev2__Refund_URL__c'}))
        {
        Stripe_API__c sap;
         if (test.isRunningTest()){
            Test.setMock(HttpCalloutMock.class, new UploadFileMock());
        }
               sap = [select id,Api_Key__c,Charge_URL__c,Token_URL__c,Refund_URL__c from Stripe_API__c Limit 1];
                
                CHARGE_URL = sap.Charge_URL__c;
                API_KEY = sap.Api_Key__c; 
           
            }
        HttpRequest http = new HttpRequest();
        http.setEndpoint(CHARGE_URL);
        http.setMethod('POST');
        Blob headerValue = Blob.valueOf(API_KEY + ':');
        String authorizationHeader = 'BASIC ' +
            EncodingUtil.base64Encode(headerValue);
        http.setHeader('Authorization', authorizationHeader);
        
        Integer amount_int = Math.round(amount * 100);//.intValue();
        Map<String, String> payload = new Map<String, String>{
            'customer' => customerId,
                'amount' => String.valueOf(amount_int)
                };
                    
                    // set the default currency to USD if it's not specified
                    if (properties == null || properties.containsKey('usd') == false) {
                        payload.put('currency', 'usd');
                    }
        
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
        
        
        
        response = hs.getBody();
        statusCode = hs.getStatusCode();
        
    
        
        try {
            StripeCharge o = StripeCharge.parse(response);
            return o;
        } catch (System.JSONException e) {
            System.debug(System.LoggingLevel.INFO, '\n**** JSONException: '+e); 
            return null;
        }
    }
    
    public static StripeCharge parse(String json) {
        // rough string replacement to simplify json parsing and avoid Apex reserved words
        json = StripeUtil.cleanJson(json);
        
        return (StripeCharge) System.JSON.deserialize(json, StripeCharge.class);
    }
  
}