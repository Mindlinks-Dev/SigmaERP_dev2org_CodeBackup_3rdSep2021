public with sharing class CommunityURL {
@AuraEnabled 
    public static string RetrievecommmunityURL(){
       domainURL__c settings = domainURL__c.getInstance('CommunityURL');
  String UrlValue = settings.IframeUrl__c;
        UrlValue= UrlValue  +'/resource/sigmaerpdev2__lcins1_pdfjs/web/viewer.html';  
  /*List<Domain> DomainURL = [SELECT Domain FROM Domain] ;
       List<Network> URLPrefix = [SELECT UrlPathPrefix FROM Network where name like '%Community%'];
        String UrlValue ;
        if(URLPrefix[0].UrlPathPrefix!= null && URLPrefix[0].UrlPathPrefix !=''){
        UrlValue = DomainURL[0].Domain + URLPrefix[0].UrlPathPrefix;
         UrlValue= 'https://'+UrlValue+'/resource/lcins1_pdfjs/web/viewer.html';
        system.debug('UrlValue : '+ UrlValue);
        } else {
              UrlValue= DomainURL[0].Domain;
        UrlValue= 'https://'+UrlValue  +'/resource/lcins1_pdfjs/web/viewer.html';
        system.debug('UrlValue : '+ UrlValue);                
            }        */
        return UrlValue;        
    }
    
}