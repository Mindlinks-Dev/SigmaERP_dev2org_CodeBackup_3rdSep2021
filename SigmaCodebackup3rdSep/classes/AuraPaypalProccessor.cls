global with sharing class AuraPaypalProccessor
{
public static string amount{set;get;}
public static String result {set;get;}
public static string FirstName{get; set;}
public static string LastName{get; set;}

public static string CardType{get; set; }
public static string CardNo{get; set; }
public static string expMo{get; set; }
public static string expYe{get; set; }
public static string CVV{get; set; }

public static string zip{get; set; }
public static string payer{ get; set; }
public static string transid {get; set;}
public static string message {get; set; }
public static string err {get; set; }
public static string rawResponse {get; set; }
Public static string paymentaction{get;set;}
Public static string AuthorizationID{get;set;}
Public static string type{get;set;}
Public static string SFDCAccountId{get;set;}
Public static string PaypalCardId{get;set;}
public static String paymentDesc{get;set;}

public static String stateTax{get;set;}
public static Double tax{get;set;}
public static Double taxAmt {get;set;}
public static Double stateTaxAmt{get;set;}
public static Double federalTaxRate{get;set;}
public static Double federalTaxAmt{get;set;}


public static String selectedCard{get;set;}
public static String paypalTransID{get;set;}    
public static Boolean isSavedCard{get;set;}
public static Double discountAmount{get;set;}
public static String netamount{get;set;}
public static String AddonComments{get;set;}
public static String paymentType{get;set;}

public static string accessToken{get;set;}
public static String savedCardId{get;set;}

public AuraPaypalProccessor()
{
 
  zip = '';
  CVV = '';
  expYe = '';
  expMo = '';
  CardNo = '';

  CardType = '';
  FirstName = '';
  LastName = '';
 
  payer = '';
  err = '';
  message = '';
  paymentaction='';
  AuthorizationID ='';
  type='';
  amount='';
}

 private static string un ;
 private static string pw ;
 private static string sig ;  
 private static String client_id;
 private static String secret_id;
   

 private static String url = 'https://api-3t.sandbox.paypal.com/2.0/';
 
 
public static String doDirectPayment()
{ 
    // code modified by chandana for the paypal Xml format mismatch
  HttpRequest req = new HttpRequest();
    Http h = new Http();
    req.setHeader('Content-Type','text/xml;charset=UTF-8');
    req.setEndpoint(url);
    req.setMethod('POST');
    req.setBody('<?xml version="1.0" encoding="UTF-8"?> <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> <soap:Header> <RequesterCredentials xmlns="urn:ebay:api:PayPalAPI"> <Credentials xmlns="urn:ebay:apis:eBLBaseComponents"> <Username>' + un + '</Username> <ebl:Password xmlns:ebl="urn:ebay:apis:eBLBaseComponents">' + pw + '</ebl:Password> <Signature>' + sig + '</Signature> </Credentials> </RequesterCredentials> </soap:Header> <soap:Body> <DoDirectPaymentReq xmlns="urn:ebay:api:PayPalAPI"> <DoDirectPaymentRequest> <Version xmlns="urn:ebay:apis:eBLBaseComponents">1.00</Version> <DoDirectPaymentRequestDetails xmlns="urn:ebay:apis:eBLBaseComponents"> <PaymentAction>' + paymentaction + '</PaymentAction> <PaymentDetails> <OrderTotal currencyID="USD">' + amount + '</OrderTotal> </PaymentDetails> <CreditCard> <CreditCardType>' + CardType + '</CreditCardType> <CreditCardNumber>' + CardNo + '</CreditCardNumber> <ExpMonth>' + expMo + '</ExpMonth> <ExpYear>' + expYe + '</ExpYear> <CardOwner> <PayerStatus>verified</PayerStatus> <PayerName> <FirstName>' + FirstName+ '</FirstName> <LastName>' + LastName+ '</LastName> </PayerName> </CardOwner> <CVV2>' + CVV + '</CVV2> </CreditCard> </DoDirectPaymentRequestDetails> </DoDirectPaymentRequest> </DoDirectPaymentReq> </soap:Body> </soap:Envelope>');
    HttpResponse res;
  

  try{ 
      res = h.send(req);
      System.debug('res:'+res);
  }catch(System.CalloutException e){
      System.debug('Time Out Exception : '+e);
      return '408';
  }    
  String xml = res.getBody();
  rawResponse = xml;
 
  XmlStreamReader reader = res.getXmlStreamReader();
  result = readXMLResponse(reader,'Ack');
  System.debug('Response XML '+result );
  reader = res.getXmlStreamReader();
  amount = readXMLResponse(reader, 'Amount');
  err = readXMLResponse(reader, 'LongMessage');
  
  
  if (result == 'Success' || result == 'SuccessWithWarning')
  {
    reader = res.getXmlStreamReader();
    transid = readXMLResponse(reader, 'TransactionID'); 
   
  }
 
  return result;
}

public static String doCapture()
{ 
  
  Http ht = new Http();
  HttpRequest req = new HttpRequest();

  System.debug('doCapture -- UserName :: ' + un +' Password:: '+pw +' Signature:: '+sig +' client Id:: '+ client_id +' secret Id:: '+secret_id);
  
  String doCaptureRequest;
  doCaptureRequest =  '<soap:Envelope xmlns:soap=' + '\'' + 'http://schemas.xmlsoap.org/soap/envelope/'  + '\'' + ' xmlns:xsi=' + '\''+ 'http://www.w3.org/2001/XMLSchema-instance'  + '\'' + ' xmlns:xsd=' + '\''+ 'http://www.w3.org/2001/XMLSchema' + '\'' + '>';
  doCaptureRequest += '<soap:Header><RequesterCredentials xmlns="urn:ebay:api:PayPalAPI"><Credentials xmlns="urn:ebay:apis:eBLBaseComponents">';
  doCaptureRequest += '<Username>' + un + '</Username><ebl:Password xmlns:ebl="urn:ebay:apis:eBLBaseComponents">' + pw;
  doCaptureRequest += '</ebl:Password><Signature>' + sig + '</Signature>';
    if(type=='DoCapture'){
  
  doCaptureRequest += '</Credentials></RequesterCredentials></soap:Header><soap:Body><DoCaptureReq xmlns="urn:ebay:api:PayPalAPI">';

  doCaptureRequest += '<DoCaptureRequest><Version xmlns="urn:ebay:apis:eBLBaseComponents">1.00</Version>';
  doCaptureRequest += '<AuthorizationID>' +AuthorizationID+ '</AuthorizationID>';
  doCaptureRequest += '<Amount>10</Amount>';
  doCaptureRequest += '<CompleteType>Complete</CompleteType>';
  doCaptureRequest += '</DoCaptureRequest></DoCaptureReq ></soap:Body></soap:Envelope>';
  }else if(type=='Dovoid'){
    doCaptureRequest += '</Credentials></RequesterCredentials></soap:Header><soap:Body><DoVoidReq xmlns="urn:ebay:api:PayPalAPI">';

  doCaptureRequest += '<DoVoidRequest><Version xmlns="urn:ebay:apis:eBLBaseComponents">1.00</Version>';
  doCaptureRequest += '<AuthorizationID>' +AuthorizationID+ '</AuthorizationID>';
  doCaptureRequest += '</DoVoidRequest></DoVoidReq ></soap:Body></soap:Envelope>';
 }else if(type=='Refund'){
     doCaptureRequest += '</Credentials></RequesterCredentials></soap:Header><soap:Body><RefundTransactionReq xmlns="urn:ebay:api:PayPalAPI">';

  doCaptureRequest += '<RefundTransactionRequest><Version xmlns="urn:ebay:apis:eBLBaseComponents">1.00</Version>';
 doCaptureRequest += '<TransactionID>5XU72000YN7388255</TransactionID>'; //25th sep
 
  doCaptureRequest += '<currencyCode>USD</currencyCode>';
  doCaptureRequest += '<REFUNDTYPE>FULL</REFUNDTYPE>';
  doCaptureRequest += '</RefundTransactionRequest></RefundTransactionReq ></soap:Body></soap:Envelope>';
  System.debug('transId : '+transid);
 }
 
  req.setBody(doCaptureRequest); 
  
  req.setEndpoint(url);
  req.setMethod('POST');
  req.setHeader('Content-length', '1753' );
  req.setHeader('Content-Type', 'text/xml;charset=UTF-8'); 
  req.setHeader('SOAPAction','');
  req.setHeader('Host','api-aa.sandbox.paypal.com');
  HttpResponse res = ht.send(req);
  String xml = res.getBody();
  rawResponse = xml;
  system.debug('::' + rawResponse);
  XmlStreamReader reader = res.getXmlStreamReader();
  result = readXMLResponse(reader,'Ack');
  reader = res.getXmlStreamReader();
  err = readXMLResponse(reader, 'LongMessage');
  
  if (result == 'Success')
  {
    reader = res.getXmlStreamReader();
    transid = readXMLResponse(reader, 'TransactionID'); 
      system.debug('Trans Id::' + transid ); 
  }
  else
  {
    result = err;
  }
  return result;
}


public static String readXMLResponse(XmlStreamReader reader, String sxmltag)
{
  string retValue; 
  while(reader.hasNext())
  {
    if (reader.getEventType() == XmlTag.START_ELEMENT)
    {
      if (reader.getLocalName() == sxmltag) {
        reader.next();
        if (reader.getEventType() == XmlTag.characters)
        {
          retValue = reader.getText();
        }
      }
    }
    reader.next();
  }
  return retValue;
}

public static String payCapture()
{
  
  err = '';

  if (err == '')
  {
    
    message = doCapture();
  }
  
  if (message == 'Success')
  {
    
  }
  else
  {
    
  }
  return message;
}


public static String pay()
{
  
  err = '';
  if (FirstName == '')
    err = err + 'You must enter a First Name.\n';
  if (LastName == '')
    err = err + 'You must enter a Last Name.\n';
  
  if (zip == '')
    err = err + 'You must enter a Zip.\n';
  if (CardNo == '')
    err = err + 'You must enter a Credit Card Number.\n';
  if (expMo.length() != 2)
    err = err + 'Expiration month must be in the format MM.\n';
  if (expYe.length() != 4) 
    err = err + 'Expiration year must be in the format YYYY.\n';
    
  if (amount == '0')
  {
    err += 'Amount 0 can not process.\n';
    message = err;
  }  
  message = err;
  if (err == '')
  {
    
   message = doDirectPayment();
  }
  
  if (message == 'Success')
  {
    
  }
  else
  {
   
  }
  return message;
}


public static String fetchCredentials()
{
    
    if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new set<String>{'Id','sigmaerpdev__Currency__c','sigmaerpdev__Inventory_Status__c','sigmaerpdev__Package_ID__c','sigmaerpdev__Parent_Id__c','sigmaerpdev__Shipment_ID__c','sigmaerpdev__StockReceiving_ID__c'})
    )
    {
        Default_Parameters__c options;
       
            options = [select Id,Currency__c,Inventory_Status__c,Package_ID__c,Parent_Id__c,Shipment_ID__c,StockReceiving_ID__c from Default_Parameters__c limit 1];
       
    
    
    }  
    String resultOuth = 'Success';
    return resultOuth ;
}


//save credit card into Paypal. 

global static String oAuth()
{
     
     System.debug('oAuth -- UserName :: ' + un +' Password:: '+pw +' Signature:: '+sig +' client Id:: '+ client_id +' secret Id:: '+secret_id);
     
     http h = new http();
     httpRequest req = new httpRequest(); 
     req.setEndpoint('https://api.sandbox.paypal.com/v1/oauth2/token');   
    
    
    return accessToken;//27th sep
}
   
  public static String savecard(string Data,String saveCardUrl,String accessToken1)
{
    
     http h = new http();
     httpRequest req = new httpRequest(); 
     req.setEndpoint(saveCardUrl);
    req.setHeader('Authorization','Bearer '+accessToken1);//24th sep
     req.setHeader('Accept','application/json');
     req.setHeader('Content-Type','application/json');
     req.setBody(Data);
     req.setMethod('POST');
     
     
     HttpResponse res = h.send(req);
    
    if(res.getBody() != null){
        String JSonRes = res.getBody();//29th sep
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(JSonRes);//29th sep
        savedCardId = String.valueOf(m.get('id'));//29th sep
       
        
    }

       return savedCardId ;
        
} 
   

public static void getdata(String Cardid)
{
     http h = new http();
     httpRequest req = new httpRequest(); 
     req.setEndpoint('https://api.sandbox.paypal.com/v1/vault/credit-card/'+Cardid);
    
     req.setHeader('Authorization','Bearer A0155xAHXQ6VSxD2JFMHMT4y9P34aXmt.T6CtXV7V5qn8Ys');//24th sep
     req.setHeader('Accept','application/json');
     req.setHeader('Content-Type','application/json');
     req.setMethod('GET');
     HttpResponse res = h.send(req);
    
    
     
}
     
    public static void deletecard(String Cardid)
    {
        http h = new http();
     httpRequest req = new httpRequest(); 
     req.setEndpoint('https://api.sandbox.paypal.com/v1/vault/credit-card/'+Cardid);
    
     req.setHeader('Authorization','Bearer A015xpZYjw1jPJByHvM.ox6bF4EtPfD-OPJ8QezVcsDk81M');
     req.setHeader('Accept','application/json');
     req.setHeader('Content-Type','application/json');
     req.setMethod('DELETE');
     HttpResponse res = h.send(req);
    
     system.debug('Request ______----'+res.getBody()); 
     
    }
    
    

}