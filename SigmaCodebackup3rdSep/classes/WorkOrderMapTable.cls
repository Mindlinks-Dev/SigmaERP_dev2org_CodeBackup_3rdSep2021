/************************************************************************************************************************** 
SL.No      Author                  Version                     Description

1.         Jayanth G                1.0 (Initial Version)       WorkOrderMapTable is an Apex class which gets invoked by
                                                                WorkOrderRouteTableHelper. This class returns a Map that 
                                                                contains WorkOrder Id, WayPoint, Location, Distance, Time
                                                                CustomerName, Contact.
***************************************************************************************************************************/  
 
public with sharing class WorkOrderMapTable {
    @AuraEnabled
    public static List<WorkOrderDetails> getWorkOrdersDetails(Double lat, Double lon){
        
        system.debug('Latitude - '+lat);
        system.debug('Longitude - '+lon);
        
        String alpha = 'B';
        
        Integer i = 0;
        List<WorkOrderDetails> workOrderDetails = new List<WorkOrderDetails>();
        
        //To get the Id of User.
        Id userId;
        User u = new User();
        try{
            // User Fields that will be accessed.
          /*  String [] userFields = new String [] {'Name','contactId'};
                
                // Obtaining the field name/token map for the User object
                Map<String,Schema.SObjectField> userMap = Schema.SObjectType.User.fields.getMap();
            for (String fieldToCheck : userFields) {
                // Check if the user has create access on the each field
                if (!userMap.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on User Fields');
                    return null;
                }
            }
            
            u= [select id, Name, contactId from User where Id = :userId];
            system.debug('user - '+u);*/
            
            userId= UserInfo.getUserId();
            system.debug('UserID - '+userId);
        }
        catch(Exception e){
            system.debug('Exception at fetching User Details - '+u);
        }
        
        
        //User u = [select id, contactId from User where Name = 'John M'];
        
        list<Service_Resource__c> contact = new list<Service_Resource__c>();
        List<Work_Order__c>  workOrders = new List<Work_Order__c>();
        try{
            // Service Resources Fields that will be accessed.
            String [] serviceResourceFields = new String [] {'Name','sigmaerpdev2__Service_Location__c'};
                
                // Obtaining the field name/token map for the Contact object
                Map<String,Schema.SObjectField> serviceResourceMap = Schema.SObjectType.Service_Resource__c.fields.getMap();
            for (String fieldToCheck : serviceResourceFields) {
                // Check if the user has create access on the each field
                if (!serviceResourceMap.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on Contact Fields');
                    return null;
                }
            }
            //Getting contact's location.
            contact = [SELECT Id,Name,sigmaerpdev2__Service_Location__c FROM Service_Resource__c where User__c =:userId];
            system.debug('Service Resource - '+contact);
            system.debug('userId'+userId);
            
            // WorkOrder Fields that will be accessed.
         /*   String [] workOrderFields = new String [] {'Name','sigmaerpdev2__Work_Type__c','FFP_MR_Contact__c','sigmaerpdev2__Customer_Availability_Date__c','sigmaerpdev2__Status__c','sigmaerpdev2__AssignTo__c','sigmaerpdev2__Service_Street__c','Service_City__c','sigmaerpdev2__Service_Country__c','sigmaerpdev2__Service_State_Province__c','sigmaerpdev2__Service_Zip_Postal_Code__c'};
                
                // Obtaining the field name/token map for the WorkOrder object
                Map<String,Schema.SObjectField> workOrderMap = Schema.SObjectType.Work_Order__c.fields.getMap();
            for (String fieldToCheck : workOrderFields) {
                // Check if the user has create access on the each field
                if (!workOrderMap.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on WorkOrder Fields');
                    return null;
                }
            }*/
            system.debug('Before Query');
            system.debug('userId'+userId);
            workOrders = [SELECT Id,Name,sigmaerpdev2__Account__r.Name,Customer_Availability_Date__c, Status__c,Customer_Contact__c, FFP_MR_Contact__r.Name,AssignTo__c, Service_Street__c,Service_City__c,Service_Country__c,Service_State_Province__c ,Work_Type__r.Name, Service_Zip_Postal_Code__c FROM Work_Order__c where (Customer_Availability_Date__c = TODAY AND AssignTo__c = :userId AND Status__c = 'Accepted') ORDER BY Customer_Availability_Date__c ASC];
            system.debug('WorkOrders for today - '+workOrders);
        }
        catch(Exception e){
            system.debug('Exception at fetching contact and WorkOrder - '+e);
        }
        
        
        //If there are no workOrders null has to be returned.
        if(workOrders == null || workOrders.size()==0){
            system.debug('No WorkOrders');
            return null;
        }
        
        //Defining Map with key as WorkOrder and its value as List<WorkOrderDetails>.
        for(Work_Order__c eachWorkOrder : workOrders){
            WorkOrderDetails temp = new WorkOrderDetails();
            
            //Getting next Alphabet after every iteration.
            temp.alpha = getNextChar(i);
            system.debug('character - '+i);
            temp.workOrderId = eachWorkOrder.Id;
            temp.workOrderName = eachWorkOrder.Name;
            temp.location = eachWorkOrder.Service_Street__c+', '+eachWorkOrder.Service_City__c+', '+eachWorkOrder.Service_State_Province__c+', '+eachWorkOrder.Service_Country__c+', '+eachWorkOrder.Service_Zip_Postal_Code__c;
            temp.pincode = eachWorkOrder.Service_Zip_Postal_Code__c;
            temp.workType = eachWorkOrder.Work_Type__r.Name;
            temp.contactName = eachWorkOrder.Account__r.Name;
            temp.contactNumber = eachWorkOrder.Customer_Contact__c;
            //For the first WorkOrder's distance, it has to be calculated from Technician's current location by passing latitude and longitude.
            if(i==0){
                
                DistanceTime dt = new DistanceTime();
                
                //Google MAP's Distance Matrix API. 
                //Input: User's current Latitute and Longitude and First WorkOrder's Pincode.
                //Return: Distance between the two and also the time required to travel.
                try{
                    dt = getDistance(eachWorkOrder.Service_Street__c,eachWorkOrder.Service_State_Province__c,eachWorkOrder.Service_Zip_Postal_Code__c,eachWorkOrder.Service_Street__c,eachWorkOrder.Service_State_Province__c,eachWorkOrder.Service_Zip_Postal_Code__c,lat,lon,True);
                    temp.timeReq = dt.duration; 
                    system.debug('innn'+ temp.timeReq);
                    temp.distance = dt.distance;
                    system.debug(''+temp.distance );
                }
                catch(Exception e){
                    temp.timeReq = '0.0';
                    temp.distance = '0.0';
                    system.debug('Exception at fetching the first distance -'+e);
                }
                
                
            }
            else{
                DistanceTime dt = new DistanceTime();
                
                //Google MAP's Distance Matrix API. 
                //Input: Current WorkOrder's Pincode and the next WorkOrder's Pincode.
                //Return: Distance between the two and also the time required to travel.
                try{
                    dt = getDistance(workOrders[i-1].Service_Street__c,workOrders[i-1].Service_State_Province__c,workOrders[i-1].Service_Zip_Postal_Code__c,eachWorkOrder.Service_Street__c,eachWorkOrder.Service_State_Province__c,eachWorkOrder.Service_Zip_Postal_Code__c,lat,lon,false);
                   system.debug('dt'+dt);
                    temp.timeReq = dt.duration; 
                    system.debug('temp.timeReq'+  temp.timeReq);
                    temp.distance = dt.distance;
                    system.debug('temp.distance'+temp.distance);
                }
                catch(Exception e){
                    temp.timeReq = '0.0';
                    temp.distance = '0.0';
                    system.debug('Exception at fetching the distance btw workOrders -'+e);
                }
                
            }
            i++;
            workOrderDetails.add(temp);
        }
        system.debug('WorkOrderDetails - '+workOrderDetails);
        return workOrderDetails;
        
    }
    
    Public static DistanceTime getDistance(String startStreet, String startState, String startPincode,String destStreet, String destState,String endPincode,double lat, double lon, boolean isFirst)
    {      
        DistanceTime dt = new DistanceTime();
        dt.distance = '0';
        dt.duration = '0';
        system.debug('startPincode'+startPincode+'endPincode'+endPincode);
        system.debug('Start Street and State - '+startStreet+', '+startState);
        system.debug('Destination Street and State - '+destStreet+', '+destState);
        if(startStreet==null){
            startStreet = '';
        }
        if(startState==null){
            startState='';
        }
        if(destStreet==null){
            destStreet = '';
        }
        if(destState==null){
            destState='';
        }
        
        //Creating an Array variable "Address" to store both source and destination address.
        //Address array with index value such 0,1,2 contains source address.
        //Address array with index value such 3,4,5 contains destination address.
        String[] address = new List<String>();
        address.add(startStreet);
        address.add(startState);
        address.add(startPincode);
        address.add(destStreet);
        address.add(destState);
        address.add(endPincode);
        
        
        for(Integer j=0;j<6;j++){
            address[j] = address[j].trim();
            address[j] = address[j].replaceAll( '\\s+', '+');
        }
        
        system.debug('Address - '+address);
        
        //--holds the distance in km
        String distance= '0 km';
        //map<String,Decimal> startLatAndLog=getLocation(startPincode);
        //map<String,Decimal> endLatAndLog=getLocation(endPincode);
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        req.setMethod('GET');
        //String latString = String.valueOf(lat);
        //String lonString = String.valueOf(lon);
        
        //--get the google API from custom setting
        Google_API_Key__c googleAPIKey = Google_API_Key__c.getInstance();
        system.debug('API Key - '+googleAPIKey);
        String url;
        try{
            
            if(isFirst){
                //Address array with index value such 0,1,2 contains source address.
                //Address array with index value such 3,4,5 contains destination address.
                url ='https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins='+lat+','+lon+'&destinations='+address[3]+''+address[4]+''+address[5]+'&key='+googleAPIKey.API_Key__c;
            }
            else
            {
                //Address array with index value such 0,1,2 contains source address.
                //Address array with index value such 3,4,5 contains destination address.
                url ='https://maps.googleapis.com/maps/api/distancematrix/json?origins='+address[0]+''+address[1]+''+address[2]+'&destinations='+address[3]+''+address[4]+''+address[5]+'&key='+googleAPIKey.API_Key__c;    
            }
            //String url ='https://maps.googleapis.com/maps/api/distancematrix/json?origins='+startLatAndLog.get('Latitude')+','+startLatAndLog.get('Longitude')+'&destinations='+endLatAndLog.get('Latitude')+','+endLatAndLog.get('Longitude');
            
            req.setEndPoint(url);
            HTTPResponse resp = http.send(req); 
            
            String response = resp.getBody();
            
            //assuming you've already created your httprequest object
            httpresponse res = http.send(req);
            
            
            // Deserialize the JSON to a map of key => value
            Map <String, Object> root = (Map <String, Object>) JSON.deserializeUntyped(res.getBody());
            system.debug('root'+root);
            
            for (String obj : root.keySet())
            {            
                if(obj== 'rows'){                
                    List<Object> rows = (List<Object>)root.get(obj);       
                    if(rows != null && rows.size() >0){
                        Map<String, Object> mapData = (Map<String, Object>)rows[0];
                        List<Object> elements = (List<Object>)mapData.get('elements');                
                        Map<String, Object> elementMapData = (Map<String, Object>)elements[0];
                        
                        //--incase of unfound status
                        if(elementMapData.containsKey('status')){
                            String statuseMap = (String)elementMapData.get('status');
                            if(statuseMap != 'NOT_FOUND' && statuseMap != 'ZERO_RESULTS'){
                                
                                //Distance Map where it contains the distance between the Source address and Destination Address.
                                Map<String,Object> distanceMap = (Map<String,Object>)elementMapData.get('distance');
                                system.debug('distanceMap'+distanceMap.get('text'));
                                system.debug('distanceMap'+distanceMap.get('value'));
                                Decimal mi = (Decimal)distanceMap.get('value') * 0.000621371;   //Converting kms into miles
                                dt.distance = mi.setScale(2) + 'miles';
                                
                                //Time required to travel between the Source address and Destination Address.
                                Map<String,Object> durationMap = (Map<String,Object>)elementMapData.get('duration');
                                system.debug('distanceMap'+durationMap.get('text'));
                                system.debug('distanceMap'+durationMap.get('value'));
                                dt.duration = (String)durationMap.get('text');
                            }                    
                        }else{
                            //Distance Map where it contains the distance between the Source address and Destination Address.
                            Map<String,Object> distanceMap = (Map<String,Object>)elementMapData.get('distance');
                            system.debug('distanceMap'+distanceMap.get('text'));
                            system.debug('distanceMap'+distanceMap.get('value'));
                            Decimal mi = (Decimal)distanceMap.get('value') * 0.000621371;   //Converting kms into miles
                            dt.distance = mi.setScale(2) + 'miles';
                            
                            //Time required to travel between the Source address and Destination Address.
                            Map<String,Object> durationMap = (Map<String,Object>)elementMapData.get('duration');
                            system.debug('distanceMap'+durationMap.get('text'));
                            system.debug('distanceMap'+durationMap.get('value'));
                            dt.duration = (String)durationMap.get('text');
                        }   
                    }
                }
            }   
            system.debug('distance - '+dt);
            return dt;
        }
        catch(Exception e){
            system.debug('Exception Occured at Calling GoogleAPI - '+e);
            return dt;
        }
    }
    
    public class DistanceTime{
        public String distance;
        public String duration;
    }
    
    public static String getNextChar(Integer i) {
        String key = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        Integer index = i;
        return index == -1? null: key.substring(index+1, index+2);
    }
    
    public class WorkOrderDetails{
        @AuraEnabled
        public Id workOrderId;
        @AuraEnabled
        public String alpha;
        @AuraEnabled
        public String workOrderName;
        @AuraEnabled
        public String location;
        @AuraEnabled
        public String pincode;
        @AuraEnabled
        public String timeReq;
        @AuraEnabled
        public String distance;
        @AuraEnabled
        public String workType;
        @AuraEnabled
        public String contactName;
        @AuraEnabled
        public String contactNumber;
    }
}