global with sharing class StripeChargeMld {
    
    //private static  String SERVICE_URL = '';
    private static  String SERVICE_URL = 'https://api.stripe.com/v1/charges';

    global Integer amount;
    global Integer statusCode;
    global Integer created;
    global String stripeCurrency;
    global String customer_id;
    global StripeCustomerMld customer;
    global String description;
    global Boolean disputed;
    global Integer fee;
    global String id;
    global Boolean livemode;
    global String stripeObject;
    global Boolean paid;
    global Boolean refunded;
    global Integer amount_refunded;
    global List<Fee_details> fee_details;
    global StripeError error;
    global String invoice_id;
    global String failure_message;
    global Map<String, String> metadata;

    global class Fee_details {
        global String stripeType;
        global String description;
        global Object application;
        global Integer amount;
        global String stripeCurrency;
    }
    
    
    
   
  
    
    global static StripeChargeMld create(String customerId, Decimal amount,Boolean crdSave,String StripeSecretKey) {
        return create(customerId, amount, new Map<String, String>(), new Map<String, String>(),crdSave,StripeSecretKey);
    }
    
  
 global static Map<String, String> payload;
    global static StripeChargeMld create(String customerId, Decimal amount, Map<String, String> properties, Map<String, String> metadata,Boolean SaveCrd,String StripeSecretKey) {
    if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Stripe_API__c',new set<String>{'id','sigmaerpdev__Charge_URL__c'}))
            {
    //created by sandhya,21-06-2018 ,to avoid hardcode
        Stripe_API__c Stripe;
        Stripe = [Select Id,Charge_URL__c from Stripe_API__c limit 1];
        
        SERVICE_URL = Stripe.Charge_URL__c;
            }
        HttpRequest http = new HttpRequest();
        http.setEndpoint(SERVICE_URL);
        http.setMethod('POST');
        
        //Sandbox Api key
        Blob headerValue = Blob.valueOf(StripeSecretKey+ ':');
        
        String authorizationHeader = 'BASIC ' +
        EncodingUtil.base64Encode(headerValue);
        http.setHeader('Authorization', authorizationHeader);
        Boolean Issavedcard=false;
        Integer amount_int = Math.round(amount * 100);//.intValue();
        
     
        if(SaveCrd==true){
        payload = new Map<String, String>{
              
          'customer' => 'cus_8Wj0xkOfB4wMKy',
            'card' => customerId,
            'amount' => String.valueOf(amount_int)
        };        
        }else{
           payload = new Map<String, String>{
            'card' => customerId,
            'amount' => String.valueOf(amount_int)
        };
          }
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
            StripeChargeMld o = StripeChargeMld.parse(response);
            return o;
        } catch (System.JSONException e) {
            System.debug(System.LoggingLevel.INFO, '\n**** JSONException: '+e); 
            return null;
        }
    }

    public static StripeChargeMld parse(String json) {
        // rough string replacement to simplify json parsing and avoid Apex reserved words
        json = StripeUtil.cleanJson(json);

        return (StripeChargeMld) System.JSON.deserialize(json, StripeChargeMld.class);
    }
    
    
    //Updated code for charge card when when making the card is default
    
    global static Map<String, String> payloaddata;
    //code added for magento
     global static StripeChargeMld createAndCharge(String customerId, Decimal amount, Map<String, String> properties, Map<String, String> metadata,Boolean SaveCrd,String stripecustid,String StripeSecretKey) 
    {
        System.debug('INSDIE THE CREATE AND CHARGE');
        System.debug('inside the stripe chage create '+customerId);
        System.debug('inside the stripe chage create '+amount);
        System.debug('inside the stripe chage create '+properties);
        System.debug('inside the stripe chage create '+customerId);
        System.debug('inside the stripe chage create '+SaveCrd);
        System.debug('Inside StripeChargeMld StripeSecretKey Is:: '+ StripeSecretKey);
        //System.debug('inside the COMPANY ID IS '+cid);
  
        HttpRequest http = new HttpRequest();
        http.setEndpoint(SERVICE_URL);
        http.setMethod('POST');
        //Blob headerValue = Blob.valueOf(StripeAPI.ApiKey + ':');
        //SandBox
        
        Blob headerValue = Blob.valueOf(StripeSecretKey+ ':');
        //07 Blob headerValue = Blob.valueOf('sk_test_lCHXJe3bVrmmiXkMHJNAb5ig'+ ':');
        
        //Production Api key
        //22Blob headerValue = Blob.valueOf('sk_live_qDC11iNlIfabzEGRqlP9MSPc'+ ':');
        System.debug('Header value'+headerValue);
        String authorizationHeader = 'BASIC ' +
        EncodingUtil.base64Encode(headerValue);
        System.debug('******authorizationHeader******'+authorizationHeader);
        http.setHeader('Authorization', authorizationHeader);
        Boolean Issavedcard=false;
        Integer amount_int = Math.round(amount * 100);//.intValue();
        System.debug('Before process the amount is  '+amount_int);
        System.debug('sddsfsdf-----'+Issavedcard);
      // User userdetails = [select CustomerID__c from User where ID=:UserInfo.getUserId() limit 1]; 
     
        if(SaveCrd==true){
        payloaddata = new Map<String, String>{           
           'customer' => stripecustid,
            'card' => customerId,
            'amount' => String.valueOf(amount_int)
        };        
        }else{
         payloaddata = new Map<String, String>{
            'card' => customerId,
            'amount' => String.valueOf(amount_int)
        };
          }
        // set the default currency to USD if it's not specified
        if (properties == null || properties.containsKey('usd') == false) {
            payloaddata.put('currency', 'usd');
        }

        if (properties != null) {
            for (String key : properties.keySet()) {
                if (properties.get(key) != null) {
                    payloaddata.put(key, properties.get(key));
                }
            }
        }

        if (metadata != null) {
            for (String key : metadata.keySet()) {
                if (metadata.get(key) != null) {
                    payloaddata.put('metadata['+key+']', metadata.get(key));
                }
            }
        }

        http.setBody(StripeUtil.urlify(payloaddata));
        System.debug(System.LoggingLevel.INFO, '\n**** REQUEST BODY:\n'+http.getBody());    
        
        String response;
        Integer statusCode;
        
        Http con = new Http();
        HttpResponse hs = new HttpResponse();
        
         try {
                hs = con.send(http);
            } catch (CalloutException e) {
                return null;
            }
       
        System.debug('Response data from stripe'+hs);

        system.debug('#### '+ hs.getBody());
        
        response = hs.getBody();
        statusCode = hs.getStatusCode();
        system.debug('$$statusCode = '+hs.getStatusCode());
       
        try {
            StripeChargeMld o = StripeChargeMld.parseData(response);
            System.debug(System.LoggingLevel.INFO, '\n**** StripeChargeMld object: '+o); 
            return o;
        } catch (System.JSONException e) {
            System.debug(System.LoggingLevel.INFO, '\n**** JSONException: '+e); 
            return null;
        }
        
        
    }
    
    // For refund Logic
    // This method is For Full Refund purpose
    global String TransactionID;
    global static StripeChargeMld createrefund(String TransactionID)
    {
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Stripe_API__c',new set<String>{'id','sigmaerpdev__Charge_URL__c'}))
            {
        Stripe_API__c Stripe;
        Stripe = [Select Id,Charge_URL__c from Stripe_API__c limit 1];
        
        SERVICE_URL = Stripe.Charge_URL__c;
            }
        HttpRequest http = new HttpRequest();
        http.setEndpoint(SERVICE_URL+'/'+TransactionID+'/refunds');
        http.setMethod('POST');
       //07 Blob headerValue = Blob.valueOf(StripeAPI.ApiKey + ':');
        Blob headerValue = Blob.valueOf('sk_test_lCHXJe3bVrmmiXkMHJNAb5ig'+ ':');
        String authorizationHeader = 'BASIC ' +
        EncodingUtil.base64Encode(headerValue);
        http.setHeader('Authorization', authorizationHeader);
        
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
            hs.setStatusCode(200);
        }

        
        response = hs.getBody();
        statusCode = hs.getStatusCode();
        
        try {
            StripeChargeMld o = StripeChargeMld.parse(response);
            return o;
        } catch (System.JSONException e) {
            System.debug(System.LoggingLevel.INFO, '\n**** JSONException: '+e); 
            return null;
        }
    }
        // This Method is for Partial Refund purpose based on Amount
    Global Integer refundamount;
    global static StripeChargeMld createPartialrefund(String TransactionID,Integer refundamount,String StripeSecretKey) 
    {
        
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Stripe_API__c',new set<String>{'id','sigmaerpdev__Charge_URL__c'}))
            {
        Stripe_API__c Stripe;
        Stripe = [Select Id,Charge_URL__c from Stripe_API__c limit 1];
        
        SERVICE_URL = Stripe.Charge_URL__c;
            }
        HttpRequest http = new HttpRequest();
        Integer amount_int = Math.round(refundamount * 100);//.intValue();
        http.setEndpoint(SERVICE_URL+'/'+TransactionID+'/refunds');
        http.setMethod('POST');
        
        Blob headerValue = Blob.valueOf(StripeSecretKey+ ':');
        
        String authorizationHeader = 'BASIC ' +
        EncodingUtil.base64Encode(headerValue);
        http.setHeader('Authorization', authorizationHeader);
         

         payload = new Map<String, String>{
            'amount' => String.valueOf(amount_int)
        };
       
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
            hs.setStatusCode(200);
        }

        
        response = hs.getBody();
        statusCode = hs.getStatusCode();
        
        try {
            StripeChargeMld o = StripeChargeMld.parse(response);
            return o;
        } catch (System.JSONException e) {
            System.debug(System.LoggingLevel.INFO, '\n**** JSONException: '+e); 
            return null;
        }
    }
    

    public static StripeChargeMld parseData(String json) {
        // rough string replacement to simplify json parsing and avoid Apex reserved words
        json = StripeUtil.cleanJson(json);

        return (StripeChargeMld) System.JSON.deserialize(json, StripeChargeMld.class);
    }
}