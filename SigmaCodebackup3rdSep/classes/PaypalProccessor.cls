public class PaypalProccessor{
public  string amount{set;get;}
public  String result {set;get;}
public  string FirstName{get; set;}
public  string LastName{get; set;}
public  string Addy1{get; set;}
public  string Addy2{get; set;}
public  string Country{get; set; }
public  string CardType{get; set; }
public  string CardNo{get; set; }
public  string expMo{get; set; }
public  string expYe{get; set; }
public  string CVV{get; set; }
public  string city{get; set; }
public  string state{get; set; }
public  string zip{get; set; }
public  string payer{ get; set; }
public  string transid {get; set;}
public  string message {get; set; }
public  string err {get; set; }
public  string rawResponse {get; set; }
Public string paymentaction{get;set;}
Public string AuthorizationID{get;set;}
Public string type{get;set;}
Public string SFDCAccountId{get;set;}
Public string PaypalCardId{get;set;}
public String paymentDesc{get;set;}

public String stateTax{get;set;}
public Double tax{get;set;}
public Double taxAmt {get;set;}
public Double stateTaxAmt{get;set;}
public Double federalTaxRate{get;set;}
public Double federalTaxAmt{get;set;}


public String selectedCard{get;set;}
public String paypalTransID{get;set;}    
public Boolean isSavedCard{get;set;}
public Double discountAmount{get;set;}
public String netamount{get;set;}
public String AddonComments{get;set;}
public String paymentType{get;set;}


Public string accessToken{get;set;}
Public string savedCardId{get;set;}

public PaypalProccessor(){
  city = '';
  state = '';
  zip = '';
  CVV = '';
  expYe = '';
  expMo = '';
  CardNo = '';
 /* CardType = 'visa'; Commented On 26th Nov Anil*/
  CardType = '';// Added on 26th Nov Anil
  FirstName = '';
  LastName = '';
 /* Country = 'US'; Commented On 26th Nov Anil*/
 Country = '';// Added on 26th Nov Anil
  Addy1 = '';
  Addy2 = '';
  payer = '';
  err = '';
  message = '';
  paymentaction='';
  AuthorizationID ='';
  type='';
  amount='';
}
/* Following lines are commented Error: Limit Exceeded --> */

 
 private string un ;
 private string pw ;
 private string sig ;  
 private String client_id;
 private String secret_id;
   

 private String url = 'https://api-3t.sandbox.paypal.com/2.0/';
 /* 07 private string un = 'imran.hunter786-facilitator_api1.gmail.com';
 private string pw = '1382342069';
 private string sig = 'AFcWxV21C7fd0v3bYYYRCpSSRl31A5Na9gzLZOTBEaFiLttC-86hW.sy';
*/

 /* private  String url = 'https://api-3t.sandbox.paypal.com/2.0/';
 private string un = 'iqbal2mlsolution-facilitator_api1.gmail.com';
 private string pw = '1366118450';
 private string sig = 'AhvrtQgkASNJszuSc42RFycX6NZOArj3zAx6gYvvHz7OoM7LqMa9E3nM';

 
 private  String url = 'https://api-3t.sandbox.paypal.com/2.0/';
 private string un = 'nivedithar2290-facilitator_api1.gmail.com';
 private string pw = 'H56WX9VW8LPCZWEP';
 private string sig = 'A4oiw8fgJMQdJH3MtXEUNvIAbImrAquduMvPKF1ybfoFLoCTOJmy7BtN'; */
 
 
public String doDirectPayment()
{ 
  Http h = new Http();
  HttpRequest req = new HttpRequest();

  System.debug('CardType ::'+CardType+' Country::'+Country+' CardNo::'+CardNo+' expYe::'+expYe);
  System.debug('doDirectPayment -- UserName :: ' + un +' Password:: '+pw +' Signature:: '+sig +' client Id:: '+ client_id +' secret Id:: '+secret_id);
  
  String doDirectRequest;
  doDirectRequest =  '<soap:Envelope xmlns:soap=' + '\'' + 'http://schemas.xmlsoap.org/soap/envelope/'  + '\'' + ' xmlns:xsi=' + '\''+ 'http://www.w3.org/2001/XMLSchema-instance'  + '\'' + ' xmlns:xsd=' + '\''+ 'http://www.w3.org/2001/XMLSchema' + '\'' + '>';
  doDirectRequest += '<soap:Header><RequesterCredentials xmlns="urn:ebay:api:PayPalAPI"><Credentials xmlns="urn:ebay:apis:eBLBaseComponents">';
  doDirectRequest += '<Username>' + un + '</Username><ebl:Password xmlns:ebl="urn:ebay:apis:eBLBaseComponents">' + pw;
  doDirectRequest += '</ebl:Password><Signature>' + sig + '</Signature>';
  doDirectRequest += '</Credentials></RequesterCredentials></soap:Header><soap:Body><DoDirectPaymentReq xmlns="urn:ebay:api:PayPalAPI">';
  doDirectRequest += '<DoDirectPaymentRequest><Version xmlns="urn:ebay:apis:eBLBaseComponents">1.00</Version>';
  doDirectRequest += '<DoDirectPaymentRequestDetails xmlns="urn:ebay:apis:eBLBaseComponents">';
  doDirectRequest += '<PaymentAction>' + paymentaction + '</PaymentAction><PaymentDetails><OrderTotal currencyID="USD">' + amount + '</OrderTotal>';
  doDirectRequest += '<ShipToAddress><Name>' + FirstName + ' ' + LastName + '</Name><Street1>' + Addy1 + '</Street1><Street2>' +Addy2 + '</Street2>';
  doDirectRequest += '<CityName>' + city + '</CityName><StateOrProvince>' + state + '</StateOrProvince><PostalCode>' + zip + '</PostalCode>';
  doDirectRequest += '<Country>' + country + '</Country></ShipToAddress>';
  doDirectRequest += '</PaymentDetails><CreditCard><CreditCardType>' + CardType + '</CreditCardType><CreditCardNumber>' + CardNo + '</CreditCardNumber>';
  doDirectRequest += '<ExpMonth>' + expMo + '</ExpMonth><ExpYear>' + expYe + '</ExpYear><CardOwner><PayerStatus>verified</PayerStatus>';
  doDirectRequest += '<PayerName><FirstName>' + FirstName+ '</FirstName><LastName>' + LastName + '</LastName></PayerName><PayerCountry>' + country + '</PayerCountry>';
  doDirectRequest += '<Address><Street1>' + Addy1 + '</Street1><Street2>' + Addy2 + '</Street2><CityName>' + city + '</CityName>';
  doDirectRequest += '<StateOrProvince>' + state + '</StateOrProvince><Country>' + country + '</Country><PostalCode>' + zip + '</PostalCode></Address>';
  doDirectRequest += '</CardOwner><CVV2>' + CVV + '</CVV2></CreditCard></DoDirectPaymentRequestDetails>';
  doDirectRequest += '</DoDirectPaymentRequest></DoDirectPaymentReq></soap:Body></soap:Envelope>';
  
  req.setBody(doDirectRequest); 
  
  req.setEndpoint(url);
  req.setMethod('POST');
  req.setHeader('Content-length', '1753' );
  req.setHeader('Content-Type', 'text/xml;charset=UTF-8'); 
  req.setHeader('SOAPAction','');
  req.setHeader('Host','api-aa.sandbox.paypal.com');
  req.setTimeout(120000);//20th Nov Anil
  HttpResponse res;
  try{ //try added on 24th nov anil
      res = h.send(req);
  }catch(System.CalloutException e){
      System.debug('Time Out Exception : '+e);
      return '408';
  }    
  String xml = res.getBody();
  rawResponse = xml;
  system.debug('new directpayment xmlresponse::' + rawResponse);
  XmlStreamReader reader = res.getXmlStreamReader();
  result = readXMLResponse(reader,'Ack');
  System.debug('Response XML '+result );
  reader = res.getXmlStreamReader();
  amount = readXMLResponse(reader, 'Amount');
  err = readXMLResponse(reader, 'LongMessage');
  
  System.debug('doDirect :: '+doDirectRequest);
  System.debug('Long Message ::::'+err);//Anil 26th Nov
  System.debug('Request : '+req);//24th sep
  System.debug('Response : '+res);//24th sep
  
  if (result == 'Success' || result == 'SuccessWithWarning')
  {
    reader = res.getXmlStreamReader();
    transid = readXMLResponse(reader, 'TransactionID'); 
    system.debug('Trans Id::' + transid ); 
    
   
    //Start Inserting values into object 25th sep
 /*   Payment__c payment = new Payment__c(); 
    payment.Amount__c = Decimal.valueOf(amount);  
    payment.PayPal_Transaction_Id__c = transid;
    payment.Transaction_Type__c = 'Direct';
 //   payment.SFDC_Account__c = '00190000014WI0i'; //Commented on 25th Nov Anil

    
    insert payment;
    system.debug('payment::' + payment ); Commented on 26th Nov Anil*/
 
    //End Inserting values into object 25th sep
  }
 /* else
  {
    result = err;
    system.debug('Error Result : ' + result);
  } */
  System.debug('final result '+result);
  return result;
}

public String doCapture()
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
 // doCaptureRequest += '<TransactionID>' +AuthorizationID+ '</TransactionID>';
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


public String readXMLResponse(XmlStreamReader reader, String sxmltag)
{
  string retValue; // Read through the XML
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

public String payCapture(){
  
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
    //pr = null;
  }
  return message;
}


public String pay(){
  
  err = '';
  if (FirstName == '')
    err = err + 'You must enter a First Name.\n';
  if (LastName == '')
    err = err + 'You must enter a Last Name.\n';
  if (Addy1 == '')
    err = err + 'You must enter an Address.\n';
  if (city == '')
    err = err + 'You must enter a City.\n';
  if (state == '')
    err = err + 'You must enter a State.\n';
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
    //pr = null;
  }
  return message;
}

// Get Credentials From Parent Account

public String fetchCredentials(Id accParentId)
{
    
    Account accCreds = [Select Id,Name,Paypal_Username__c,Paypal_Password__c,Paypal_Signature__c,Paypal_Client_Id__c,Paypal_Secret_Id__c From Account where Id =: accParentId ];
    
    un = accCreds.Paypal_Username__c;
    pw  = accCreds.Paypal_Password__c;
    sig = accCreds.Paypal_Signature__c;
    client_id = accCreds.Paypal_Client_Id__c;
    secret_id = accCreds.Paypal_Secret_Id__c;
    
            
    String result = 'Success';
    return result;
}


//save credit card into Paypal. 

public String oAuth(){
     
     System.debug('oAuth -- UserName :: ' + un +' Password:: '+pw +' Signature:: '+sig +' client Id:: '+ client_id +' secret Id:: '+secret_id);
     
     http h = new http();
     httpRequest req = new httpRequest(); 
     req.setEndpoint('https://api.sandbox.paypal.com/v1/oauth2/token');   
     
     
    /* 07 String client_id='AduXdhB5X8s9R2h3Aj7ruuMSybvK7GbCKS2jAEIgP6g8-1HPRTnrdWVXGyq4';
     String secret_id='EASGyRCAsWT6tCEbXUj9HVVI202Rc9LNUzkk-6icCPBwftWGqffHstOxwf9O';
    */
    
     Blob headerValue = Blob.valueOf(client_id+ ':' + secret_id);
     String authorizationHeader ='BASIC ' +EncodingUtil.base64Encode(headerValue);
     system.debug('header Value : '+headerValue+' authorizationHeader : '+authorizationHeader);
     req.setHeader('Authorization', authorizationHeader);
     req.setHeader('Accept', 'application/json');
     req.setBody('grant_type=client_credentials');
  
     req.setMethod('POST');
     
     system.debug('Request dsgfdg----'+req);
     
    HttpResponse res = h.send(req);
    system.debug('Request ______----'+res.getBody());
    system.debug('Response ______----'+res);
    
    String JSonRes = res.getBody();//27th sep
    Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(JSonRes);//27th sep
    accessToken = String.valueOf(m.get('access_token'));
    system.debug('Access Token : '+accessToken);
    
    //JSONParser result = JSON.Parse(res.getBody());
    //JSONParser result= (JSONParser)JSON.deserialize(''+res.getBody()+'',JSONParser.class);
    //string access_token=result.access_token;
   // system.debug('Request access_token----'+result); 
    return accessToken;//27th sep
   }
   
  public String savecard(string Data,String url,String accessToken1){
     System.debug('inside paypalprocessor Data: '+Data);//24th sep
     System.debug('URL: '+url); //24th sep
     http h = new http();
     httpRequest req = new httpRequest(); 
     req.setEndpoint(url);

     //req.setHeader('Authorization','Bearer A015xpZYjw1jPJByHvM.ox6bF4EtPfD-OPJ8QezVcsDk81M');
     req.setHeader('Authorization','Bearer '+accessToken1);//24th sep
     req.setHeader('Accept','application/json');
     req.setHeader('Content-Type','application/json');
     req.setBody(Data);
     req.setMethod('POST');
     
     system.debug('Request dsgfdg----'+req);
     
     HttpResponse res = h.send(req);
     System.debug('paypalprocessor paypal response'+ res);
    if(res.getBody() != null){
        String JSonRes = res.getBody();//29th sep
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(JSonRes);//29th sep
        savedCardId = String.valueOf(m.get('id'));//29th sep
        system.debug('savedCardId  : '+savedCardId);//29th sep
        
    }
    system.debug('Request ______----'+res.getBody());
    system.debug('Response ______----'+res);
    system.debug('Access Token : '+accessToken1);
       return savedCardId ;
        
  } 
   

   public void getdata(String Cardid){
        http h = new http();
     httpRequest req = new httpRequest(); 
     req.setEndpoint('https://api.sandbox.paypal.com/v1/vault/credit-card/'+Cardid);
    
     //req.setHeader('Authorization','Bearer A015xpZYjw1jPJByHvM.ox6bF4EtPfD-OPJ8QezVcsDk81M');
     req.setHeader('Authorization','Bearer A0155xAHXQ6VSxD2JFMHMT4y9P34aXmt.T6CtXV7V5qn8Ys');//24th sep
     req.setHeader('Accept','application/json');
     req.setHeader('Content-Type','application/json');
     req.setMethod('GET');
     HttpResponse res = h.send(req);
    
    system.debug('Request ______----'+res.getBody()); 
     system.debug('Response ______----'+res); 
     
     }
     
    public void deletecard(String Cardid){
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