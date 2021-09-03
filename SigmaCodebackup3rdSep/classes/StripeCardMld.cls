global with sharing class StripeCardMld {
    
     private static final String SERVICE_URL = 'https://api.stripe.com/v1/customers/';
  //  private static  String SERVICE_URL = '';

    global String stripeType;
    global String country;
    global Integer expMonth;
    global Integer statusCode;
    global String fingerprint;
    global Integer expYear;
    global String last4;
    global String stripeObject;
    global String id;
    global String name;
    global StripeError error;
    global String customer_id;
    global Date expirationDate {
        get {
            Date d = Date.newInstance(this.expyear, this.expmonth, Date.daysInMonth(this.expyear, this.expmonth));
            return d;
        }
    }
    //code added for magento
    global static StripeCardMld create(String customerId, String token, String StripeSecretKey)
    {
        System.debug('Inside StripeCardMld create the customer id 01 '+customerId);
        System.debug('Inside Stripecard create the token is'+token);
        System.debug('Inside create StripeSecretKey is: '+StripeSecretKey);
        
        HttpRequest http = new HttpRequest();
        http.setEndpoint(SERVICE_URL + customerId + '/cards');
        http.setMethod('POST');
        // Blob headerValue = Blob.valueOf(StripeAPI.ApiKey + ':');
        
        //Sandbox Apikey
        Blob headerValue = Blob.valueOf(StripeSecretKey + ':');
        //07 Blob headerValue = Blob.valueOf('sk_test_lCHXJe3bVrmmiXkMHJNAb5ig' + ':');     
        
        //Production key
        //22Blob headerValue = Blob.valueOf('sk_live_qDC11iNlIfabzEGRqlP9MSPc' + ':');
        String authorizationHeader = 'BASIC ' +
        EncodingUtil.base64Encode(headerValue);
        http.setHeader('Authorization', authorizationHeader); 
        
        Map<String, String> payload = new Map<String, String>{
            'card' => token
            
        };
         System.debug('Inside StripeCardMld create the data is'+payload);

        http.setBody(StripeUtil.urlify(payload));
        System.debug(System.LoggingLevel.INFO, '\n**** REQUEST BODY:\n'+http.getBody());    
        
        String response;
        Integer statusCode;
        Http con = new Http();
        HttpResponse hs = new HttpResponse();
        
        if (Test.isRunningTest()) {
        // hs.setBody(StripeCardMldTests.testData_getCard);
          //  hs.setStatusCode(200);
        }
        else
        {
          try {
                hs = con.send(http);
            } catch (CalloutException e) {
                return null;
            }
        }
     
        system.debug('#### '+ hs.getBody());
        
        response = hs.getBody();
        statusCode = hs.getStatusCode();
       
        try {
            StripeCardMld o = StripeCardMld.parse(response);
            System.debug(System.LoggingLevel.INFO, '\n**** StripeCardMld object: '+o); 
            return o;
        } catch (System.JSONException e) {
            System.debug(System.LoggingLevel.INFO, '\n**** JSONException: '+e); 
            return null;
        }
    }
    
    public static StripeCardMld parse(String json) {
        // rough string replacement to simplify json parsing and avoid Apex reserved words
        json = StripeUtil.cleanJson(json);

        return (StripeCardMld) System.JSON.deserialize(json, StripeCardMld.class);
    }
    
    
}