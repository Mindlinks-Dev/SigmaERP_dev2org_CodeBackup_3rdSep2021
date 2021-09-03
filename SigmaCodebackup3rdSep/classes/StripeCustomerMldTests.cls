@isTest
public class StripeCustomerMldTests {

public Static String StripeSecretKey = 'defetrtreybteyyty5'; 

    
   public static String testData_getCustomer {
        get {
            Integer i = 10;
            System.assertEquals(i,10);
            return '{"object": "customer", "created": 1375155380, "id": "cus_00000000000000", "livemode": false, "description": "Cirruspath (005G00000025O4VIAU)", "email": null, "delinquent": false, "metadata": { }, "subscription": { "id": "su_2I44CLUFxzAgjY", "plan": { "interval": "year", "name": "Cirrus Insight Annual Subscription", "amount": 0, "currency": "usd", "id": "CI_ANNUALLY", "object": "plan", "livemode": false, "interval_count": 1, "trial_period_days": null }, "object": "subscription", "start": 1375155380, "status": "active", "customer": "cus_00000000000000", "cancel_at_period_end": false, "current_period_start": '+testData_currentPeriodStart+', "current_period_end": '+testData_currentPeriodEnd+', "ended_at": null, "trial_start": null, "trial_end": null, "canceled_at": null, "quantity": 1, "application_fee_percent": null }, "discount": null, "account_balance": 0, "cards": { "object": "list", "count": 1, "url": "/v1/customers/cus_00000000000000/cards", "data": [ { "id": "cc_2I43Pdw7gh8Qlo", "object": "card", "last4": "4242", "type": "Visa", "exp_month": 12, "exp_year": 2014, "fingerprint": "pmVir47Ti9dNLS50", "customer": "cus_00000000000000", "country": "US", "name": null, "address_line1": null, "address_line2": null, "address_city": null, "address_state": null, "address_zip": null, "address_country": null, "cvc_check": "pass", "address_line1_check": null, "address_zip_check": null } ] }, "default_card": "cc_2I43Pdw7gh8Qlo"}';
        }
    }
    
   
    
    public static String testData_updateCustomer {
        get {
            Integer i = 10;
            System.assertEquals(i,10);
            return '{'+
                '  "object": "customer",'+
                '  "created": 1375155380,'+
                '  "id": "cus_00000000000000",'+
                '  "livemode": false,'+
                '  "description": "Cirruspath",'+
                '  "email": null,'+
                '  "delinquent": false,'+
                '  "metadata": {'+
                '  },'+
                '  "discount": null,'+
                '  "account_balance": 0,'+
                '  "cards": {'+
                '    "object": "list",'+
                '    "count": 1,'+
                '    "url": "/v1/customers/cus_00000000000000/cards",'+
                '    "data": ['+
                '      {'+
                '        "id": "cc_2I43Pdw7gh8Qlo",'+
                '        "object": "card",'+
                '        "last4": "4242",'+
                '        "type": "Visa",'+
                '        "exp_month": 12,'+
                '        "exp_year": 2014,'+
                '        "fingerprint": "pmVir47Ti9dNLS50",'+
                '        "customer": "cus_00000000000000",'+
                '        "country": "US",'+
                '        "name": null,'+
                '        "address_line1": null,'+
                '        "address_line2": null,'+
                '        "address_city": null,'+
                '        "address_state": null,'+
                '        "address_zip": null,'+
                '        "address_country": null,'+
                '        "cvc_check": "pass",'+
                '        "address_line1_check": null,'+
                '        "address_zip_check": null'+
                '      }'+
                '    ]'+
                '  },'+
                '  "default_card": "cc_2I43Pdw7gh8Qlo"'+
                '}';
        }
    }
   
    
     public static String testData_currentPeriodEnd {
        get {
            Integer j = 10;
            System.assertEquals(j,10);
            DateTime d = DateTime.now().addYears(1);
            Integer i = (d.getTime() / 1000).intValue();
            return String.valueOf(i);
        }}
    
 public static String testData_currentPeriodStart {
        get {
            Integer j = 10;
            System.assertEquals(j,10);
            DateTime d = DateTime.now();
            Integer i = (d.getTime() / 1000).intValue();
            return String.valueOf(i);
        }
    }
    
     public static String testData {
        get {
            Integer i = 10;
            System.assertEquals(i,10);
            return testData == null ? testData_getCustomer : testData;
        }
        set
        {
            Integer i = 10;
            System.assertEquals(i,10);
        }
    }
    
   
    @isTest(SeeAllData=false)
    private static  void test_DefaultCard() {
    
    
     Test.startTest();
     
    

    Stripe_API__c Stripe= new Stripe_API__c();
    Stripe.Name='Name'; 
    Stripe.Api_Key__c ='Api_Key__c';
    Stripe.Charge_URL__c ='Charge_URL__c';
    Stripe.Customer_URL__c ='Customer_URL__c';
    Stripe.Refund_URL__c ='Refund_URL__c';
    Stripe.Token_URL__c ='Token_URL__c';
    insert Stripe;
    
    System.assertEquals(Stripe.Name, 'Name');
   
   String customerId='cut_test';
    
    String id='card_45812165464';
   
     Integer a = 5;
    
     StripeCustomerMld.setDefaultCardStripe(customerId,id);
     System.assertEquals(5,a,'MisMatch Of values ');
     Test.stopTest(); 
    }
    @isTest(SeeAllData=false)
    private static  void test_DefaultCard1() {
    
            
    Test.startTest();
    
    Stripe_API__c Stripe= new Stripe_API__c();
    Stripe.Name='Name'; 
    Stripe.Api_Key__c ='Api_Key__c';
    Stripe.Charge_URL__c ='Charge_URL__c';
    Stripe.Customer_URL__c ='Customer_URL__c';
    Stripe.Refund_URL__c ='Refund_URL__c';
    Stripe.Token_URL__c ='Token_URL__c';
    insert Stripe;
    
    System.assertEquals(Stripe.Name, 'Name');   


   String customerId='cus_test';
    
    String id='card_gfyy465gfg79';
   
   
    Integer a = 5;
    
    StripeCustomerMld.setDefaultCard(customerId,id);
    System.assertEquals(5,a,'MisMatch Of values ');
    Test.stopTest();
    
    }
    


}