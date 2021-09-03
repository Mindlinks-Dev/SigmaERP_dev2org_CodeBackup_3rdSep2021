public with sharing class APICallout 
{
    public static HttpResponse postAPI(String endPointUrl, String accessToken, String Body)
    
    {
    HTTPResponse res;
    if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__IoT_Settings__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__IoT_Settings__c',new Set<String>{'sigmaerpdev__Password__c','sigmaerpdev__User_Name__c'})
        ){
        System.debug('accessToken::'+accessToken);
        if(accessToken == '')
        {
            accessToken = getAccessToken();
            IoTController.accessTokenChanged = accessToken;
            IoTController.isAccessTokenChanged = true;
        }
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPointUrl);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setHeader('Authorization', 'Bearer '+ accessToken);
        req.setBody(Body);
        req.setTimeout(120000);
        Http http = new Http();
        System.debug('HTTPS request complete>>'+req);
        res = http.send(req);
        System.debug('response 201>>'+res);
        
        //Handling token expired situation
        if(res.getStatusCode() == 405)
        {
            String newAccessToken = getAccessToken();
            IoTController.accessTokenChanged = newAccessToken;
            IoTController.isAccessTokenChanged = true;
            sensorGraphController.accessTokenChanged = newAccessToken;
            sensorGraphController.isAccessTokenChanged = true;
            res = postAPI(endPointUrl, newAccessToken, Body);
        }
        }
        return res;
    }
    
    public static String getAccessToken()
    {
        
        
        //Retrive custom settings data
        Map<string, IoT_Settings__c> settingsData = IoT_Settings__c.getAll();
        String userName = settingsData.get('IoT Settings').User_Name__c;
        String password = settingsData.get('IoT Settings').Password__c;
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setEndpoint('http://www.ethersys.co/ees/enterprise/api/auth/login_validate');
        req.setBody('{"usernameOrEmail":"'+userName+'","password":"'+password+'"}');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        system.debug(res.getBody());
        JSONParser.authWrapper authContent= JSONParser.parseAuth(res.getBody());
        
        return authContent.accessToken;
        
    }
}