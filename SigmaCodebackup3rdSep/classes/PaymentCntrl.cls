public Class PaymentCntrl
{
  public String Token {get;set;} 
  public Boolean stripePaymentFlag {get;set;}  
  public Boolean payPalPaymentFlag {get;set;}    
  public String RecordId{get;set;}  
    public PaymentCntrl()
    {
        System.debug('Inside PaymentCntrl');
        Token =  ApexPages.currentPage().getParameters().get('token');
        System.debug('Inside PaymentCntrl Token  IS:: '+Token );  
        
       Sigma_Order__c so = [select id,name from sigmaerpdev2__Sigma_Order__c  ORDER BY CreatedDate DESC limit 1 ];       
        RecordId = so.id;
      /* Payment_Request_Response_QS__c pqs = [Select Id,Name,Account__c,Account__r.ParentId From Payment_Request_Response_QS__c where Token__c =:Token];
        System.debug('Inside PaymentCntrl pqs 01:: '+pqs );
         System.debug('InsidePaymentCntrl  pqs 01 :: '+pqs.Account__r.ParentId );  
        
        Account acc = [Select Id,Name,Type,Payment_Vendor__c From Account where Id =: pqs.Account__r.ParentId];
        System.debug('Inside PaymentCntrl accIs 02:: '+acc);
        System.debug('Inside  PaymentCntrl accIs 02:: '+acc.Payment_Vendor__c );  
        
        if(acc.Type != Null)
        {    
            if( acc.Type == 'Merchant' && acc.Payment_Vendor__c == 'Stripe') */
           // {
                stripePaymentFlag  = true;
           // }
           /* else if( acc.Type == 'Merchant' && acc.Payment_Vendor__c == 'Paypal' )
            {
               payPalPaymentFlag = true; 
            }
        }
               
        
        System.debug('stripePaymentFlag Is:: '+stripePaymentFlag);
        System.debug('Inside payPalPaymentFlag Is:: '+payPalPaymentFlag );
        */
    }
    
}