public with sharing class JSONParser 
{
    //For Authentication - Access token response
    public class authWrapper 
    {
        public String accessToken;
        public String tokenType;
    }
    
    public static authWrapper parseAuth(String authJSON) 
    {
        return (authWrapper) System.JSON.deserialize(authJSON, authWrapper.class);
    }
    
    //for create sensors data
    public class sensorsWrapper 
    {
        public String machine_id;
        public List<String> selected_channels;
    }
    
    public static sensorsWrapper parsesensorsWrapString(String sensorsJSON) 
    {
        return (sensorsWrapper) System.JSON.deserialize(sensorsJSON, sensorsWrapper.class);
    }
    
    //for create critical data
    public class criticalDataWrapper 
    {
        public String description;
        public String sensor_Id;
        public String machine_Id;
        public String dataType;
        public String componentName;
    }
    
    public static criticalDataWrapper criticalDataWrapString(String sensorsJSON) 
    {
        return (criticalDataWrapper) System.JSON.deserialize(sensorsJSON, criticalDataWrapper.class);
    }
    
    //for graph data
    public class IoTGraphWrapper
    {
        public List<List<String>> data;
        public String sensorId;
    }
    
    public static IoTGraphWrapper IoTGraphWrapperString(String sensorsGraphnJSON) 
    {
        return (IoTGraphWrapper) System.JSON.deserialize(sensorsGraphnJSON, IoTGraphWrapper.class);
    }
}