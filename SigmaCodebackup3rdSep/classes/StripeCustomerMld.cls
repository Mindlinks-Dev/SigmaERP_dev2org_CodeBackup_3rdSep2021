global with sharing class StripeCustomerMld {
    //magento code
    private static  String SERVICE_URL = 'https://api.stripe.com/v1/customers';
    global static final String TEST_ID = 'cus_00000000000000';
    
    
    //private static  String SERVICE_URL ='';

    global Integer created;
     global Integer statusCode;
    global Integer account_balance;
    global String description;
    global StripeError error;       
    global Boolean livemode;
    global String token;
    global String id;
    global Map<String, String> metadata;
    
    global CardList cards;
    global String default_card;
    
    global class CardList {
        global Integer count;
        global String url;
        global List<StripeCardMld> stripeData;
    }

    // static cache to eliminate multiple lookups in same transaction
    private static Map<String, StripeCustomerMld> mCustomers = new Map<String, StripeCustomerMld>();
    //Commentted code below no where used

 
   //magento code
   global static StripeCustomerMld create(String token, String description, String StripeSecretKey) {
        
        System.debug('Inside Create 01:: '+ StripeSecretKey);
        Map<String, String> properties = new Map<String, String>{
            'card' => token,
            'description' => description
            
        };
        return StripeCustomerMld.create(properties, null ,StripeSecretKey );
    }
    
    global static StripeCustomerMld create(Map<String, String> properties, Map<String, String> metadata, String StripeSecretKey) {
       System.debug('Inside StripeCustomerMld Create 02 '+StripeSecretKey );
        return updateCustomer(null, properties, metadata , StripeSecretKey);      
    }

    global static StripeCustomerMld updateCustomer(String customerId, Map<String, String> properties, Map<String, String> metadata, String StripeSecretKey) {
      if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Stripe_API__c',new set<String>{'id','sigmaerpdev__Customer_URL__c'}))
          {
      Stripe_API__c Stripe;
        Stripe = [Select Id,Customer_URL__c from Stripe_API__c limit 1];
         SERVICE_URL = Stripe.Customer_URL__c;
          }
        HttpRequest http = new HttpRequest();
        
        if (customerId == null) 
            http.setEndpoint(StripeCustomerMld.SERVICE_URL);
        else 
            http.setEndpoint(StripeCustomerMld.SERVICE_URL+'/'+customerId);

        http.setMethod('POST');
        //StripeAPIApiKey Sandbox
        
        Blob headerValue = Blob.valueOf( StripeSecretKey + ':');
        
        //StripeAPIApiKey Production
        
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
        
        if (!Test.isRunningTest()) {
            try {
                hs = con.send(http);
                
            } catch (CalloutException e) {
                return null;
            }
        } else {
            hs.setBody(StripeCustomerMldTests.testData);
            hs.setStatusCode(200);
        }
        
        statusCode = hs.getStatusCode();
        
        try {
            StripeCustomerMld new_customer = StripeCustomerMld.parse(hs.getBody());
            if (new_customer.error != null) throw new StripeException(new_customer.error);

            mCustomers.put(new_customer.id, new_customer);
            return new_customer;
        } catch (System.JSONException e) {
            return null;
        }
         
    }

   global static StripeCustomerMld setDefaultCard(String customerId, String card) {
        Map<String, String> properties = new Map<String, String>{
            'default_card' => card
        };
        
        return updateCustomer(customerId, properties, null,null);
    }
    
    //Added new method set default card
   global static StripeCustomerMld setDefaultCardStripe(String customerId, String cardid) {
        Map<String, String> properties = new Map<String, String>{
            'default_card' => cardid
        };
        
        return updateCustomer(customerId, properties, null,null);
    }


    public static StripeCustomerMld parse(String json) {
        json = StripeUtil.cleanJson(json);
        return (StripeCustomerMld) System.JSON.deserialize(json, StripeCustomerMld.class);
    }

}