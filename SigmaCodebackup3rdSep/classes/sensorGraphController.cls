public with sharing class sensorGraphController 
{
 
   public static Boolean isAccessTokenChanged = false;
    public static String accessTokenChanged;
    
    public class LineChart
    {
        @auraEnabled
        public List<string> labels;
        @auraEnabled
        public List<Decimal> values;
        @auraEnabled
        public String sensorIoTId;
    }
    
    @auraEnabled
    public static LineChart loadGraphDetails(String recordId)
    {
             LineChart lineChartResponse = new LineChart();
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Machine_sensors__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__IoT_Settings__c')
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Machine_sensors__c',new Set<String>{'id', 'sigmaerpdev__IoT_Sensors_Id__c '})
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__IoT_Settings__c',new Set<String>{'sigmaerpdev__Access_Token__c','sigmaerpdev__Domain_Name__c','sigmaerpdev__Password__c','sigmaerpdev__User_Name__c'})
    && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__IoT_Settings__c',new Set<String>{'sigmaerpdev__Access_Token__c'})

        ){
    
        List<string> labelsWrap = new List<string>();
        List<Decimal> valuesWrap = new List<Decimal>();
   
        List<Machine_sensors__c> sensorRecord = [select id, IoT_Sensors_Id__c from Machine_sensors__c where Id =: recordId];
        if(sensorRecord.size() > 0)
        {
            //Retrive custom settings data
            String accessToken = '';
            String domainName = '';
            Map<string, IoT_Settings__c> settingsData = IoT_Settings__c.getAll();
            if(settingsData.get('IoT Settings').Access_Token__c != null)
                accessToken = settingsData.get('IoT Settings').Access_Token__c;
            domainName = settingsData.get('IoT Settings').Domain_Name__c;
            
            HTTPResponse res = APICallout.postAPI(domainName + '/rest/single_chart_data', accessToken, '{"sensorId":"'+ sensorRecord[0].IoT_Sensors_Id__c +'"}');
            
            //Update custom settings when token has been changed
            IoT_Settings__c updateSettings = settingsData.get('IoT Settings');
            if(isAccessTokenChanged)
            {
                if(accessTokenChanged.length() > 0)
                    updateSettings.Access_Token__c = accessTokenChanged;
                update updateSettings;
            }
            
            //String sampleResponseData = '{"data":[["2019-09-17 19:23:02","0.41"],["2019-09-17 19:24:02","0.4"],["2019-09-17 19:25:02","0.405"],["2019-09-17 19:26:02","0.403"],["2019-09-17 19:27:03","0.403"],["2019-09-17 19:28:02","0.407"],["2019-09-17 19:29:02","0.405"],["2019-09-17 19:30:02","0.4"],["2019-09-17 19:31:02","0.403"],["2019-09-17 19:32:02","0.407"],["2019-09-17 19:33:02","0.397"],["2019-09-17 19:34:02","0.393"],["2019-09-17 19:34:17","0.39"],["2019-09-17 19:35:02","0.39"],["2019-09-17 19:36:02","0.393"],["2019-09-17 19:37:02","0.393"],["2019-09-17 19:38:02","0.39"],["2019-09-17 19:39:02","0.397"],["2019-09-17 19:41:02","0.392"],["2019-09-17 19:42:02","0.393"],["2019-09-17 19:43:02","0.393"],["2019-09-17 19:44:02","0.393"],["2019-09-17 19:45:02","0.39"],["2019-09-17 19:46:02","0.39"],["2019-09-17 19:47:02","0.525"],["2019-09-17 19:48:02","0.52"],["2019-09-17 19:49:02","0.513"],["2019-09-17 19:50:02","0.515"],["2019-09-17 19:51:02","0.51"],["2019-09-17 19:52:02","0.508"],["2019-09-17 19:53:03","0.503"],["2019-09-17 19:54:02","0.502"],["2019-09-17 19:55:02","0.5"],["2019-09-17 19:56:02","0.425"],["2019-09-17 19:57:02","0.39"],["2019-09-17 19:58:02","0.393"],["2019-09-17 19:59:02","0.392"],["2019-09-17 20:00:02","0.39"],["2019-09-17 20:01:02","0.393"],["2019-09-17 20:02:02","0.39"],["2019-09-17 20:03:02","0.395"],["2019-09-17 20:04:02","0.39"],["2019-09-17 20:04:50","0.40"],["2019-09-17 20:05:02","0.395"],["2019-09-17 20:06:02","0.39"],["2019-09-17 20:07:02","0.393"],["2019-09-17 20:08:02","0.393"],["2019-09-17 20:09:02","0.39"],["2019-09-17 20:10:02","0.397"],["2019-09-17 20:11:02","0.39"],["2019-09-17 20:12:02","0.39"],["2019-09-17 20:13:02","0.39"],["2019-09-17 20:14:02","0.39"],["2019-09-17 20:15:02","0.39"],["2019-09-17 20:16:02","0.39"],["2019-09-17 20:17:02","0.357"],["2019-09-17 20:18:03","0.347"],["2019-09-17 20:19:02","0.347"],["2019-09-17 20:20:02","0.345"],["2019-09-17 20:21:02","0.35"],["2019-09-17 20:22:02","0.345"],["2019-09-17 20:23:02","0.35"],["2019-09-17 20:24:02","0.35"],["2019-09-17 20:25:02","0.347"],["2019-09-17 20:26:02","0.347"],["2019-09-17 20:27:02","0.42"],["2019-09-17 20:28:02","0.47"],["2019-09-17 20:29:02","0.47"],["2019-09-17 20:30:02","0.47"],["2019-09-17 20:31:02","0.465"],["2019-09-17 20:32:02","0.46"],["2019-09-17 20:33:02","0.46"],["2019-09-17 20:34:02","0.46"],["2019-09-17 20:35:02","0.453"],["2019-09-17 20:35:29","0.45"],["2019-09-17 20:36:02","0.415"],["2019-09-17 20:37:02","0.347"],["2019-09-17 20:38:02","0.35"],["2019-09-17 20:39:02","0.35"],["2019-09-17 20:40:03","0.348"],["2019-09-17 20:41:02","0.347"],["2019-09-17 20:42:02","0.35"],["2019-09-17 20:43:03","0.35"],["2019-09-17 20:44:02","0.35"],["2019-09-17 20:45:02","0.35"],["2019-09-17 20:46:03","0.35"],["2019-09-17 20:47:02","0.347"],["2019-09-17 20:48:02","0.35"],["2019-09-17 20:49:02","0.35"],["2019-09-17 20:50:03","0.35"],["2019-09-17 20:51:02","0.345"],["2019-09-17 20:52:02","0.35"],["2019-09-17 20:53:02","0.347"],["2019-09-17 20:54:03","0.35"],["2019-09-17 20:55:02","0.34"],["2019-09-17 20:56:02","0.348"],["2019-09-17 20:57:03","0.347"],["2019-09-17 20:58:02","0.343"],["2019-09-17 20:59:02","0.347"],["2019-09-17 21:00:02","0.35"],["2019-09-17 21:01:02","0.347"],["2019-09-17 21:02:02","0.347"],["2019-09-17 21:03:02","0.348"],["2019-09-17 21:04:02","0.347"],["2019-09-17 21:05:03","0.345"],["2019-09-17 21:06:03","0.347"],["2019-09-17 21:06:05","0.34"],["2019-09-17 21:07:02","0.348"],["2019-09-17 21:08:02","0.46"],["2019-09-17 21:09:02","0.472"],["2019-09-17 21:10:02","0.47"],["2019-09-17 21:11:02","0.467"],["2019-09-17 21:12:02","0.465"],["2019-09-17 21:13:02","0.457"],["2019-09-17 21:14:02","0.46"],["2019-09-17 21:15:02","0.453"],["2019-09-17 21:16:02","0.455"],["2019-09-17 21:17:02","0.38"],["2019-09-17 21:18:02","0.35"],["2019-09-17 21:19:02","0.343"],["2019-09-17 21:20:02","0.35"],["2019-09-17 21:21:02","0.347"],["2019-09-17 21:22:02","0.35"],["2019-09-17 21:23:02","0.348"],["2019-09-17 21:24:02","0.347"],["2019-09-17 21:25:02","0.348"],["2019-09-17 21:26:02","0.35"],["2019-09-17 21:27:02","0.348"],["2019-09-17 21:28:02","0.35"],["2019-09-17 21:29:02","0.347"],["2019-09-17 21:30:02","0.348"],["2019-09-17 21:31:02","0.35"],["2019-09-17 21:32:02","0.347"],["2019-09-17 21:33:02","0.347"],["2019-09-17 21:34:03","0.347"],["2019-09-17 21:35:02","0.35"],["2019-09-17 21:36:03","0.35"],["2019-09-17 21:36:39","0.35"],["2019-09-17 21:37:02","0.35"],["2019-09-17 21:38:02","0.347"],["2019-09-17 21:39:02","0.35"],["2019-09-17 21:40:03","0.347"],["2019-09-17 21:41:02","0.35"],["2019-09-17 21:42:02","0.35"],["2019-09-17 21:43:02","0.35"],["2019-09-17 21:44:02","0.35"],["2019-09-17 21:45:02","0.35"],["2019-09-17 21:46:02","0.347"],["2019-09-17 21:47:02","0.347"],["2019-09-17 21:48:02","0.348"],["2019-09-17 21:49:02","0.44"],["2019-09-17 21:50:02","0.47"],["2019-09-17 21:51:02","0.47"],["2019-09-17 21:52:02","0.463"],["2019-09-17 21:53:02","0.46"],["2019-09-17 21:54:02","0.46"],["2019-09-17 21:55:02","0.46"],["2019-09-17 21:56:02","0.457"],["2019-09-17 21:57:02","0.45"],["2019-09-17 21:58:02","0.353"],["2019-09-17 21:59:02","0.35"],["2019-09-17 22:00:02","0.35"],["2019-09-17 22:01:02","0.348"],["2019-09-17 22:02:02","0.347"],["2019-09-17 22:03:02","0.347"],["2019-09-17 22:04:02","0.35"],["2019-09-17 22:05:02","0.35"],["2019-09-17 22:06:02","0.35"],["2019-09-17 22:07:03","0.343"],["2019-09-17 22:07:16","0.35"],["2019-09-17 22:08:02","0.35"],["2019-09-17 22:09:02","0.343"],["2019-09-17 22:10:02","0.348"],["2019-09-17 22:11:02","0.347"],["2019-09-17 22:12:02","0.35"],["2019-09-17 22:13:02","0.35"],["2019-09-17 22:14:02","0.347"],["2019-09-17 22:15:02","0.348"],["2019-09-17 22:16:03","0.347"],["2019-09-17 22:17:03","0.35"],["2019-09-17 22:18:03","0.347"],["2019-09-17 22:19:02","0.35"],["2019-09-17 22:20:03","0.35"],["2019-09-17 22:21:03","0.348"],["2019-09-17 22:22:03","0.35"],["2019-09-17 22:23:02","0.35"],["2019-09-17 22:24:02","0.348"],["2019-09-17 22:25:02","0.343"],["2019-09-17 22:26:03","0.35"],["2019-09-17 22:27:03","0.35"],["2019-09-17 22:28:04","0.345"],["2019-09-17 22:29:02","0.347"],["2019-09-17 22:30:02","0.403"],["2019-09-17 22:31:02","0.47"],["2019-09-17 22:32:02","0.47"],["2019-09-17 22:33:02","0.467"],["2019-09-17 22:34:02","0.46"],["2019-09-17 22:35:02","0.46"],["2019-09-17 22:36:03","0.46"],["2019-09-17 22:37:02","0.455"],["2019-09-17 22:37:52","0.45"],["2019-09-17 22:38:02","0.45"],["2019-09-17 22:39:02","0.417"],["2019-09-17 22:40:03","0.347"],["2019-09-17 22:41:03","0.35"],["2019-09-17 22:42:02","0.345"],["2019-09-17 22:43:02","0.35"],["2019-09-17 22:44:02","0.345"],["2019-09-17 22:45:02","0.35"],["2019-09-17 22:46:02","0.35"],["2019-09-17 22:47:02","0.35"],["2019-09-17 22:48:02","0.35"],["2019-09-17 22:49:02","0.35"],["2019-09-17 22:50:02","0.347"],["2019-09-17 22:51:02","0.35"],["2019-09-17 22:52:02","0.347"],["2019-09-17 22:53:02","0.348"],["2019-09-17 22:54:02","0.35"],["2019-09-17 22:55:02","0.35"],["2019-09-17 22:56:03","0.35"],["2019-09-17 22:57:02","0.35"],["2019-09-17 22:58:02","0.347"],["2019-09-17 22:59:02","0.35"],["2019-09-17 23:00:02","0.348"],["2019-09-17 23:01:02","0.35"],["2019-09-17 23:02:02","0.343"],["2019-09-17 23:03:03","0.35"],["2019-09-17 23:04:02","0.35"],["2019-09-17 23:05:02","0.343"],["2019-09-17 23:06:03","0.347"],["2019-09-17 23:07:02","0.35"],["2019-09-17 23:08:02","0.35"],["2019-09-17 23:08:27","0.35"],["2019-09-17 23:09:02","0.348"],["2019-09-17 23:10:02","0.35"],["2019-09-17 23:11:02","0.348"],["2019-09-17 23:12:02","0.453"],["2019-09-17 23:13:02","0.47"],["2019-09-17 23:14:02","0.47"],["2019-09-17 23:15:02","0.47"],["2019-09-17 23:16:02","0.46"],["2019-09-17 23:17:02","0.463"],["2019-09-17 23:18:02","0.46"],["2019-09-17 23:19:03","0.46"],["2019-09-17 23:20:02","0.455"],["2019-09-17 23:21:02","0.373"],["2019-09-17 23:22:02","0.35"],["2019-09-17 23:23:02","0.35"],["2019-09-17 23:24:02","0.347"],["2019-09-17 23:25:02","0.347"],["2019-09-17 23:26:02","0.35"],["2019-09-17 23:27:02","0.35"],["2019-09-17 23:28:02","0.347"],["2019-09-17 23:29:02","0.35"],["2019-09-17 23:30:02","0.347"],["2019-09-17 23:31:02","0.35"],["2019-09-17 23:32:03","0.35"],["2019-09-17 23:33:02","0.35"],["2019-09-17 23:34:02","0.35"],["2019-09-17 23:35:02","0.347"],["2019-09-17 23:36:02","0.348"],["2019-09-17 23:37:02","0.35"],["2019-09-17 23:38:02","0.35"],["2019-09-17 23:39:02","0.35"],["2019-09-17 23:39:02","0.35"],["2019-09-17 23:40:02","0.35"],["2019-09-17 23:41:02","0.35"],["2019-09-17 23:42:02","0.35"],["2019-09-17 23:43:02","0.347"],["2019-09-17 23:44:02","0.35"],["2019-09-17 23:45:02","0.348"],["2019-09-17 23:46:02","0.35"],["2019-09-17 23:47:02","0.348"],["2019-09-17 23:48:02","0.35"],["2019-09-17 23:49:02","0.35"],["2019-09-17 23:50:02","0.35"],["2019-09-17 23:51:02","0.35"],["2019-09-17 23:52:02","0.35"],["2019-09-17 23:53:02","0.35"],["2019-09-17 23:54:02","0.38"],["2019-09-17 23:55:02","0.47"],["2019-09-17 23:56:02","0.47"],["2019-09-17 23:57:02","0.47"],["2019-09-17 23:58:02","0.462"],["2019-09-17 23:59:02","0.46"],["2019-09-18 00:00:02","0.457"]],"location":"Sensor Location","sensorId":"ENODE1061C101.100095-ch0"}';
            JSONParser.IoTGraphWrapper iotWrapper = JSONParser.IoTGraphWrapperString(res.getBody());
            for(List<String> indDataGraphContent : iotWrapper.data)
            {
                if(indDataGraphContent.size() > 1)
                {
                    labelsWrap.add(indDataGraphContent[0]);
                    valuesWrap.add(Decimal.valueOf(indDataGraphContent[1]));
                }                
            }
            lineChartResponse.labels = labelsWrap;
            lineChartResponse.values = valuesWrap;
            lineChartResponse.sensorIoTId = sensorRecord[0].IoT_Sensors_Id__c;
        }
        }
        return lineChartResponse;
    }
}