public with sharing class CheckIncurrentWorkorderLocation { 
    //******************************************************************************************************************************************************************************  
    //  Date: 23/05/2018  Author :Jyoshna  functionName:updatecurentworkorderlocation() 
    // Function Desdription: This method is used to update Check In lat,log ,dateTime when "Check In" button is clicked on Work order.
    //********************************************************************************************************************************************************************************
    
    
    public class WrapperClass{
        @AuraEnabled
        public List<WO_Checklist_Item__c> checkList {get;set;}
        @AuraEnabled
        public String sizeOfTimeSheet {get;set;}
        @AuraEnabled
        public String message {get;set;}
    }
    
    @AuraEnabled
    public static WrapperClass getWOCheckList(String recordId){
        system.debug('recordId - '+recordId);
        WrapperClass wrapClass = new WrapperClass();
        // WO CheckList Fields that will be accessed.
        String [] woCheckListFields = new String [] {'sigmaerpdev2__Not_Applicable__c','Name','sigmaerpdev2__Name_Text__c','sigmaerpdev2__Work_Order__c','sigmaerpdev2__Yes__c','sigmaerpdev2__No__c'};
            
            // Obtaining the field name/token map for the WorkOrder object
            Map<String,Schema.SObjectField> woCheckListMap = Schema.SObjectType.WO_Checklist_Item__c.fields.getMap();
        for (String fieldToCheck : woCheckListFields) {
            // Check if the user has create access on the each field
            if (!woCheckListMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no read Access on WO CheckList Fields');
                wrapClass.message = 'No Read Access permission on WO CheckList';
                return wrapClass;
            }
        }
        
        List<WO_Checklist_Item__c> checkList = [SELECT Id,Not_Applicable__c, Name,Name_Text__c, Work_Order__c, Yes__c, No__c FROM WO_Checklist_Item__c where Work_Order__c=:recordId Order BY Name_Text__c];
        System.debug('checkList - '+checkList);
        
        
        String [] woTimesheetsFields = new String [] {'sigmaerpdev2__Work_Order__c'};
            
            // Obtaining the field name/token map for the WorkOrder object
            Map<String,Schema.SObjectField> woTimesheetMap = Schema.SObjectType.Work_Order_TimeSheets__c.fields.getMap();
        for (String fieldToCheck : woTimesheetsFields) {
            // Check if the user has create access on the each field
            if (!woTimesheetMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no read Access on WO Timesheets Fields');
                wrapClass.message = 'No Read Access permission on WO Timesheets';
                return wrapClass;
            }
        }
        List<Work_Order_TimeSheets__c> existingTimeSheets = [select Id, Work_Order__c from Work_Order_TimeSheets__c where Work_Order__c=:recordId];
        system.debug('existingTimeSheets - '+existingTimeSheets);
        
        wrapClass.checkList = checkList.clone();
        wrapClass.sizeOfTimeSheet = String.valueOf(existingTimeSheets.size());
        wrapClass.message='';
        System.debug('wrapClass - '+wrapClass);
        return wrapClass;
    }
    
    
    @AuraEnabled
    public static String updatecurentworkorderlocation(Id WOrecordId,Decimal Lat,Decimal Log,Map<String,String> checkListDetails){
        
        System.debug('WOrecordId'+WOrecordId);
        System.debug('Lat'+Lat);
        System.debug('Log'+Log);
        System.debug('System.now()'+System.now());
        try{
            
            Boolean isAllCheckListTrue = true;
            List<WO_Checklist_Item__c> updateCheckList = new List<WO_Checklist_Item__c>();
            System.debug('checkListDetails - '+checkListDetails);
            List<WO_Checklist_Item__c> checkList = new List<WO_Checklist_Item__c>();
            try{     
                Set<String> checkListNames = new Set<String>();
                if(checkListDetails.size()>0){
                    checkListNames = checkListDetails.keySet();
                    
                    // WO CheckList Fields that will be accessed.
                    String [] woCheckListFields = new String [] {'sigmaerpdev2__Not_Applicable__c','sigmaerpdev2__Name_Text__c','sigmaerpdev2__Work_Order__c','sigmaerpdev2__Yes__c','sigmaerpdev2__No__c'};
                        
                        // Obtaining the field name/token map for the WorkOrder object
                        Map<String,Schema.SObjectField> woCheckListMap = Schema.SObjectType.WO_Checklist_Item__c.fields.getMap();
                    for (String fieldToCheck : woCheckListFields) {
                        // Check if the user has create access on the each field
                        if (!woCheckListMap.get(fieldToCheck).getDescribe().isAccessible()) {
                            system.debug('Has no read Access on WO CheckList Fields');
                            return 'No Read Access permission on WO CheckList';
                        }
                        if (!woCheckListMap.get(fieldToCheck).getDescribe().isUpdateable()) {
                            system.debug('Has no read Access on WO CheckList Fields');
                            return 'No Update Access permission on WO CheckList';
                        }
                    }
                    
                    System.debug('checkListNames - '+checkListNames);
                    updateCheckList = new List<WO_Checklist_Item__c>();
                    checkList = [SELECT Id, Name,Name_Text__c, Work_Order__c, Yes__c, No__c,Not_Applicable__c FROM WO_Checklist_Item__c where Name=:checkListNames];
                    System.debug('checkList - '+checkList);
                    
                    for(WO_Checklist_Item__c eachCheckList : checkList){
                        for(String eachName : checkListNames){
                            if(eachCheckList.Name == eachName){
                                if(checkListDetails.get(eachName)=='Yes'){
                                    eachCheckList.Yes__c = true;
                                    eachCheckList.No__c = false;
                                    eachCheckList.Not_Applicable__c = false;
                                    updateCheckList.add(eachCheckList);
                                    break;
                                }
                                else if(checkListDetails.get(eachName)=='NA'){
                                    eachCheckList.Yes__c = false;
                                    eachCheckList.No__c = false;
                                    eachCheckList.Not_Applicable__c = true;
                                    updateCheckList.add(eachCheckList);
                                    break;
                                }
                                else{
                                    eachCheckList.Yes__c = false;
                                    eachCheckList.No__c = true;
                                    eachCheckList.Not_Applicable__c = false;
                                    updateCheckList.add(eachCheckList);
                                    isAllCheckListTrue = false;
                                    break;
                                }
                            }
                        }
                    }
                    
                    System.debug('Update Successfull');
                }
            }
            catch(Exception e){
                System.debug('Exception at - '+e.getLineNumber());
                System.debug('Exception - '+e.getMessage());
                //return 'checklistError';
            }
            
            if(checkList.size()==0){
                isAllCheckListTrue = true;
            }
            
            // WorkOrder Fields that will be accessed.
            String [] workOrderFields = new String [] {'sigmaerpdev2__Check_In_Location__Latitude__s','sigmaerpdev2__Check_In_Location__Longitude__s','sigmaerpdev2__Status__c','sigmaerpdev2__Check_In_Address__c','sigmaerpdev2__CheckIn_DateTime__c'};
                
                // Obtaining the field name/token map for the WorkOrder object
                Map<String,Schema.SObjectField> workOrderMap = Schema.SObjectType.Work_Order__c.fields.getMap();
            for (String fieldToCheck : workOrderFields) {
                // Check if the user has create access on the each field
                if (!workOrderMap.get(fieldToCheck).getDescribe().isUpdateable()) {
                    system.debug('Has no edit Access on WorkOrder Fields');
                    return 'Has no edit Access on WorkOrder Fields';
                }
            }
            
            // WorkOrderTimeSheets Fields that will be accessed.
            String [] workOrderTimeSheetsFields = new String [] {'sigmaerpdev2__Work_Order__c','sigmaerpdev2__Service_Date__c','sigmaerpdev2__Status__c'};
                
                // Obtaining the field name/token map for the WorkOrderTimeSheets object
                Map<String,Schema.SObjectField> workOrderTimeSheetsMap = Schema.SObjectType.Work_Order_TimeSheets__c.fields.getMap();
            for (String fieldToCheck : workOrderTimeSheetsFields) {
                // Check if the user has create access on the each field
                if (!workOrderTimeSheetsMap.get(fieldToCheck).getDescribe().isCreateable()) {
                    system.debug('Has no edit update on WorkOrderTimeSheets Fields');
                    return 'permission';
                }
            }
            if(isAllCheckListTrue){
                Work_Order_TimeSheets__c  timeSheets = new Work_Order_TimeSheets__c();
                
                timeSheets.Work_Order__c=WOrecordId;
                timeSheets.Service_Date__c = Date.today();
                timeSheets.Status__c='Draft';
                
                system.debug('Check Successfull');
                Work_Order__c  workordertoupdateLatAndLog = new Work_Order__c();
                workordertoupdateLatAndLog.Id=WOrecordId;
                workordertoupdateLatAndLog.Check_In_Location__Latitude__s=Lat;
                workordertoupdateLatAndLog.Check_In_Location__Longitude__s=Log;
                workordertoupdateLatAndLog.Status__c='In Progress';
                workordertoupdateLatAndLog.CheckIn_DateTime__c=System.now();
                String postalCode = '';
                
                Site_Visits__c site;
                site=[select Work_Order__c from Site_Visits__c where Work_Order__c=:WOrecordId order by createdDate DESC limit 1];
                system.debug('site>>>>>>>'+site);
                site.Check_In_DateTime__c=System.now();
                site.Check_In_Location__Latitude__s=Lat;
                site.Check_In_Location__Longitude__s=Log;
                site.Service_Date__c=Date.today();
                update site;
                 system.debug('site111111111>>>>>>>'+site);
               Service_Appointments__c Service;
                Service=[select Work_Order__c from Service_Appointments__c  where Work_Order__c=:WOrecordId order by createdDate DESC limit 1];
                Service.Work_Order_Status__c='In Progress';
                update Service;
                
                try{
                    HttpRequest req = new HttpRequest();
                    Http http = new Http();
                    req.setMethod('GET');
                    // Get Google Key from custom settings
                    Google_API_Key__c googleAPIKey = Google_API_Key__c.getInstance();
                    String url;
                    
                    url ='https://maps.googleapis.com/maps/api/geocode/json?latlng='+Lat+','+Log+'&key='+googleAPIKey.API_Key__c;
                    
                    req.setEndPoint(url);
                    HTTPResponse resp = http.send(req); 
                    
                    String response = resp.getBody();
                    
                    //assuming you've already created your httprequest object
                    httpresponse res = http.send(req);
                    
                    
                    // Deserialize the JSON to a map of key => value
                    Map <String, Object> root = (Map <String, Object>) JSON.deserializeUntyped(res.getBody());
                    system.debug('root'+root);
                    
                    
                    if(root.get('status')== 'OK'){
                        system.debug('API request Successfull');
                        for(String key : root.keySet()){
                            if(key=='results'){
                                List<Object> results = (List<Object>)root.get('results');
                                system.debug('Results - '+results);
                                
                                Map<String,Object> address_components = (Map<String,Object>)results[0];
                                system.debug('address_components - '+address_components);
                                
                                for(String addressKey : address_components.keySet()){
                                    if(addressKey == 'address_components'){
                                        List<Object> addressComponentTypes = (List<Object>)address_components.get('address_components');
                                        system.debug('addressComponentTypes - '+addressComponentTypes);
                                        
                                        for(Object tempAddressTypes : addressComponentTypes){
                                            Map<String,Object> addressData = (Map<String,Object>)tempAddressTypes;
                                            system.debug('addressData - '+addressData);
                                            
                                            List<Object> types = (List<Object>)addressData.get('types');
                                            system.debug('types - '+types);
                                            
                                            for(Object tempTypes : types){
                                                String pstCode = (String)tempTypes;
                                                if(pstCode == 'postal_code'){
                                                    postalCode = (String)addressData.get('long_name');
                                                    system.debug('Postal Code - '+postalCode);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else{
                        system.debug('API request Unsuccessfull');
                    }
                }
                catch(Exception e){
                    system.debug('Exception at capturing pincode');
                }
                
                system.debug('Check Successfull');
                //update Work order with lat,log,current datetime and pincode            
                //Work_Order__c  workordertoupdateLatAndLog=[SELECT Id, Check_In_Location__Longitude__s,Check_In_Location__Latitude__s, Check_In_Address__c, CheckIn_DateTime__c, Status__c FROM Work_Order__c where Id =:WOrecordId];
                
                workordertoupdateLatAndLog.Check_In_Address__c = postalCode;
                insert timeSheets;
                System.debug('timeSheets inserted - '+timeSheets);
                update workordertoupdateLatAndLog;
                system.debug('Update Successfull');
                return 'success '+workordertoupdateLatAndLog.Id;
            }
            else{
                return 'fail '+'i';
            }
        }catch(Exception e){
            System.debug('Update failed'+e.getMessage()+'Line no error@@'+e.getLineNumber());
            return 'fail';
        }
    }
    
    @AuraEnabled
    public static String CheckOut(Id WOrecordId,Decimal Lat,Decimal Log){
        System.debug('WOrecordId'+WOrecordId);
        System.debug('Lat'+Lat);
        System.debug('Log'+Log);
        System.debug('System.now()'+System.now());
        try{
            
            
            // WorkOrder Fields that will be accessed.
            String [] workOrderFields = new String [] {'sigmaerpdev2__RecordTypeId','sigmaerpdev2__Check_Out_Location__Latitude__s','sigmaerpdev2__Check_Out_Location__Longitude__s','sigmaerpdev2__Check_Out_Pincode__c','sigmaerpdev2__Check_Out_Date_Time__c','sigmaerpdev2__Status__c'};
                
                // Obtaining the field name/token map for the WorkOrder object
                Map<String,Schema.SObjectField> workOrderMap = Schema.SObjectType.Work_Order__c.fields.getMap();
            for (String fieldToCheck : workOrderFields) {
                // Check if the user has create access on the each field
                if (!workOrderMap.get(fieldToCheck).getDescribe().isUpdateable()) {
                    system.debug('Has no edit Access on WorkOrder Fields');
                    return 'Has no edit Access on WorkOrder Fields';
                }
                if (!workOrderMap.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no edit Access on WorkOrder Fields');
                    return 'Has no read Access on WorkOrder Fields';
                }
            }
            
            Work_Order__c workOrderQuery = [SELECT Id, Status__c, CheckIn_DateTime__c FROM Work_Order__c where Id=:WOrecordId];
            
            system.debug('Check Successfull - '+workOrderQuery);
            Id workOrderRecordId = Schema.SObjectType.Work_Order__c.getRecordTypeInfosByName().get('Proceed').getRecordTypeId();
            Work_Order__c  workordertoupdateLatAndLog1 = new Work_Order__c();
            workordertoupdateLatAndLog1.Id=WOrecordId;
            workordertoupdateLatAndLog1.RecordTypeId = workOrderRecordId;
            workordertoupdateLatAndLog1.Check_Out_Location__Latitude__s = lat;
            workordertoupdateLatAndLog1.Check_Out_Location__Longitude__s = log;
            workordertoupdateLatAndLog1.Check_Out_Date_Time__c = System.now();
            
            Site_Visits__c site;
                site=[select Work_Order__c from Site_Visits__c where Work_Order__c=:WOrecordId order by createdDate DESC limit 1];
                system.debug('site>>>>>>>'+site);
                site.Check_Out_Date_Time__c=workordertoupdateLatAndLog1.Check_Out_Date_Time__c;
                site.Check_Out_Location__Latitude__s=lat;
                site.Check_Out_Location__Longitude__s=log;
                update site;
                 system.debug('site111111111>>>>>>>'+site);
             Service_Appointments__c Service;
                Service=[select Work_Order__c from Service_Appointments__c  where Work_Order__c=:WOrecordId order by createdDate DESC limit 1];
            
                Service.Work_Order_Status__c='Completed';
            
                update Service;
            // WorkOrderTimeSheets Fields that will be accessed.
            String [] workOrderTimeSheetsFields = new String [] {'sigmaerpdev2__Work_Order__c','sigmaerpdev2__Normal_Service_Time_In_mins__c','sigmaerpdev2__Service_Date__c','sigmaerpdev2__Status__c'};
                
                // Obtaining the field name/token map for the WorkOrderTimeSheets object
                Map<String,Schema.SObjectField> workOrderTimeSheetsMap = Schema.SObjectType.Work_Order_TimeSheets__c.fields.getMap();
            for (String fieldToCheck : workOrderTimeSheetsFields) {
                // Check if the user has create access on the each field
                if (!workOrderTimeSheetsMap.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no edit create on WorkOrderTimeSheets Fields');
                    return 'Permission';
                }
                if (!workOrderTimeSheetsMap.get(fieldToCheck).getDescribe().isUpdateable()) {
                    system.debug('Has no edit update on WorkOrderTimeSheets Fields');
                    return 'Permission';
                }
            }
            
            Work_Order_TimeSheets__c workTS=[select id,Name,Work_Order__c,Normal_Service_Time_In_mins__c, Streched_Service_Time_In_mins__c FROM Work_Order_TimeSheets__c where Work_Order__c=:WOrecordId and Service_Date__c=Today limit 1];
            system.debug('WorkOrder TimeSheet - '+workTS);
           
            Integer checkOutTime;
            Integer checkInTime;
            checkOutTime = (Integer)workordertoupdateLatAndLog1.Check_Out_Date_Time__c.getTime();
            checkInTime = (Integer)workOrderQuery.CheckIn_DateTime__c.getTime();
            system.debug('Check Out Time - '+checkOutTime);
            system.debug('Check In Time - '+checkInTime);
            workTS.Normal_Service_Time_In_mins__c =  (Integer)((workordertoupdateLatAndLog1.Check_Out_Date_Time__c.getTime() - workOrderQuery.CheckIn_DateTime__c.getTime())/(1000*60));
            
            String postalCode = '';
            try{
                HttpRequest req = new HttpRequest();
                Http http = new Http();
                req.setMethod('GET');
                // Get Google Key from custom settings
                Google_API_Key__c googleAPIKey = Google_API_Key__c.getInstance();
                String url;
                System.debug('before setting URL');
                url ='https://maps.googleapis.com/maps/api/geocode/json?latlng='+Lat+','+Log+'&key='+googleAPIKey.API_Key__c;
                System.debug('after setting URL - '+url);
                
                req.setEndPoint(url);
                HTTPResponse resp = http.send(req); 
                
                String response = resp.getBody();
                system.debug('Response - '+response);
                
                //assuming you've already created your httprequest object
                httpresponse res = http.send(req);
                
                
                // Deserialize the JSON to a map of key => value
                Map <String, Object> root = (Map <String, Object>) JSON.deserializeUntyped(res.getBody());
                system.debug('root'+root);
                
                
                if(root.get('status')== 'OK'){
                    system.debug('API request Successfull');
                    for(String key : root.keySet()){
                        if(key=='results'){
                            List<Object> results = (List<Object>)root.get('results');
                            system.debug('Results - '+results);
                            
                            Map<String,Object> address_components = (Map<String,Object>)results[0];
                            system.debug('address_components - '+address_components);
                            
                            for(String addressKey : address_components.keySet()){
                                if(addressKey == 'address_components'){
                                    List<Object> addressComponentTypes = (List<Object>)address_components.get('address_components');
                                    system.debug('addressComponentTypes - '+addressComponentTypes);
                                    
                                    for(Object tempAddressTypes : addressComponentTypes){
                                        Map<String,Object> addressData = (Map<String,Object>)tempAddressTypes;
                                        system.debug('addressData - '+addressData);
                                        
                                        List<Object> types = (List<Object>)addressData.get('types');
                                        system.debug('types - '+types);
                                        
                                        for(Object tempTypes : types){
                                            String pstCode = (String)tempTypes;
                                            if(pstCode == 'postal_code'){
                                                postalCode = (String)addressData.get('long_name');
                                                system.debug('Postal Code - '+postalCode);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else{
                    system.debug('API request Unsuccessfull');
                }
                
            }
            catch(Exception e){
                system.debug('Exception at pinCode');
            }
            system.debug('Check Successfull');
            
            workordertoupdateLatAndLog1.Check_Out_Pincode__c = postalCode;
            update workordertoupdateLatAndLog1;
             try{
                update workTS;
            }
            catch(Exception e){
                System.debug('Exception e '+e.getMessage());
                return 'fail at updating Timesheet';                
            }
            system.debug('Check-In Check-Out Object Updated Successfully');
            update workordertoupdateLatAndLog1;
            system.debug('Update Successfull');
            return 'success'+' '+workordertoupdateLatAndLog1.Id;
        }catch(Exception e){
            System.debug('Update failed'+e.getMessage()+'Line no error@@'+e.getLineNumber());
            return 'fail';
        }
    }
}