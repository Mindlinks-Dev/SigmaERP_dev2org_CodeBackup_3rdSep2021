public with sharing class AgentContactListClass {
    
    /*
*This will get hte custom setting for agent assignment
* */
    @AuraEnabled  
    public Static sigmaerpdev2__Agent_Assignment_Settings__c  getAgentAssignmentCustomSetting(){
        //Map<String,Object> agentAssignmentCustomSettingMap = new Map<String,Object>();        
        //return agentAssignmentCustomSettingMap;
        
        return sigmaerpdev2__Agent_Assignment_Settings__c.getInstance();
    }
    
    @AuraEnabled  
    public Static sigmaerpdev2__Google_API_Key__c  getGoogleAPICustomSetting(){
        //Map<String,Object> agentAssignmentCustomSettingMap = new Map<String,Object>();        
        //return agentAssignmentCustomSettingMap;
        
        return sigmaerpdev2__Google_API_Key__c.getInstance();
    }
    
    
    @AuraEnabled
    public static Headers getTimeSlotsForHeader(DateTime PreferredDateandTime,String territory,Decimal tableHeaderDuration){
        System.debug('PreferredDateandTime: '+PreferredDateandTime);
        System.debug('tableHeaderDuration: '+tableHeaderDuration);
        
        List<String> tableHeaders = new List<String>();
        Time startTimeForHeader;
        Time endTimeForHeader;
        
        Headers headerWrapperClass = new Headers();
        headerWrapperClass.tableHeaders = new List<String>();
        headerWrapperClass.indexHeaders = new List<String>();
        
        tableHeaderDuration = tableHeaderDuration + 0.0;
        String[] tableHeaderDurationString = String.valueOf(tableHeaderDuration).split('\\.');
        //---get preffered time value
        Time preferredTime = Time.newInstance(PreferredDateandTime.hour(), PreferredDateandTime.minute(), PreferredDateandTime.second(), PreferredDateandTime.millisecond());
        system.debug('preferredTime'+preferredTime);
        
        //---get preffered date value
        Date myDate = date.newinstance(PreferredDateandTime.year(), PreferredDateandTime.month(), PreferredDateandTime.day());
        
        //---get preffered day
        Datetime dt1 = DateTime.newInstance(myDate, Time.newInstance(0, 0, 0, 0));
        String dateStr = dt1.format('EEEE');
        system.debug('day>>>'+dateStr);
        Datetime x =  Datetime.now();
        
        List<sigmaerpdev2__Business_Day_Slot__c> slotList=new List<sigmaerpdev2__Business_Day_Slot__c>();
        //get the slot list related to Business day equal to preferred day and preferred time with business day as well as active business day slothttps://ffpunmanagedv8-dev-ed.my.salesforce.com/_ui/common/apex/debug/ApexCSIPage#
        // BusinessDaySlot Fields that will be accessed.
        String [] businessDaySloyFields = new String [] {'sigmaerpdev2__Is_Available__c','sigmaerpdev2__Start_Time__c','sigmaerpdev2__End_Time__c','sigmaerpdev2__Business_Day__c'};
            
            // Obtaining the field name/token map for the BusinessDaySlot object
            Map<String,Schema.SObjectField> businessDaySlotMap = Schema.SObjectType.sigmaerpdev2__Business_Day_Slot__c.fields.getMap();
        for (String fieldToCheck : businessDaySloyFields) {
            // Check if the user has create access on the each field
            if (!businessDaySlotMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on Business Day Slot Fields');
                return null;
            }
        }
        slotList = [SELECT sigmaerpdev2__Business_Day__r.sigmaerpdev2__Business_Calendar__c FROM sigmaerpdev2__Business_Day_Slot__c
                    WHERE sigmaerpdev2__Start_Time__c <= :preferredTime AND sigmaerpdev2__END_Time__c >= :preferredTime 
                    AND sigmaerpdev2__Is_Available__c = TRUE AND sigmaerpdev2__Business_Day__r.Name=:dateStr 
                    AND sigmaerpdev2__Business_Day__r.sigmaerpdev2__Start_Time__c <=: preferredTime 
                    AND sigmaerpdev2__Business_Day__r.sigmaerpdev2__END_Time__c >= :preferredTime];
        
        
        System.debug('slotList----'+slotList);
        if(slotList.size() ==0)
        {
            system.debug('Check with Business slots of Technician');
            return null;  
        }
        
        Datetime x1 =  Datetime.now();
        
        List<Id> slotListId = new List<Id>();
        
        //--iterate and add the business calendar id in a list
        for(sigmaerpdev2__Business_Day_Slot__c eachSlot:slotList){
            slotListId.add(eachSlot.sigmaerpdev2__Business_Day__r.sigmaerpdev2__Business_Calendar__c);            
        }
        
        
        if(slotListId!=null && slotListId.size()>0){
            
            List<Id> businessCalendarsIds = new List<Id>();
            List<Time> tempTime =new List<Time>();
            List<sigmaerpdev2__Business_Day__c> businessDay=new List<sigmaerpdev2__Business_Day__c>();
            List<sigmaerpdev2__Service_Resource__c> contactList = new List<sigmaerpdev2__Service_Resource__c>();
            
            if(Schema.sObjectType.sigmaerpdev2__Service_Resource__c.fields.sigmaerpdev2__Business_Calendar__c.isAccessible()){
                contactList = [SELECT Id, sigmaerpdev2__Business_Calendar__c FROM sigmaerpdev2__Service_Resource__c 
                               WHERE sigmaerpdev2__Business_Calendar__r.sigmaerpdev2__Active__c = TRUE 
                               AND sigmaerpdev2__Business_Calendar__c IN :slotListId AND sigmaerpdev2__Territory__c =:territory];
            }
            else{
                system.debug('No access on Contact\'s BusinessCalendar Field');
                return null;
            }
            System.debug('contactList---'+contactList);
            
            for(sigmaerpdev2__Service_Resource__c eachContact :contactList){
                businessCalendarsIds.add(eachContact.sigmaerpdev2__Business_Calendar__c);
            }
            businessDay = [Select sigmaerpdev2__Start_Time__c,sigmaerpdev2__END_Time__c from sigmaerpdev2__Business_Day__c where sigmaerpdev2__Business_Calendar__c IN :businessCalendarsIds AND Name=:dateStr];
            Integer k,l;
            for(sigmaerpdev2__Business_Day__c eachBDay : businessDay){
                tempTime.add(eachBDay.sigmaerpdev2__Start_Time__c);
            }
            tempTime.sort();
            startTimeForHeader = tempTime[0];
            
            tempTime = new List<Time>();
            for(sigmaerpdev2__Business_Day__c eachBDay : businessDay){
                tempTime.add(eachBDay.sigmaerpdev2__END_Time__c);
            }
            tempTime.sort();
            endTimeForHeader = tempTime[tempTime.size()-1];
            
            system.debug('startTimeForHeader - '+startTimeForHeader);
            system.debug('endTimeForHeader - '+endTimeForHeader);
            
            
            Integer conversionOfDurationFromHoursToMins = Integer.valueOf(tableHeaderDuration*60);
            system.debug('tableHeaderDuration - '+tableHeaderDuration);
            //String[] startTimeForHeaderArray = startTimeForHeader.split(':');
            //String[] endTimeForHeaderArray = endTimeForHeader.split(':');
            Time temp = startTimeForHeader;
            //tableHeaders.add(String.valueOf(startTimeForHeader));
            
            //Creates Wrapper Object which contains two lists.
            //One is for the table headers in the Dispatcher Console.
            //The other one is for the indexing of those headers.
            for(Decimal i=startTimeForHeader.hour();i<=endTimeForHeader.hour();i=i+tableHeaderDuration){
                String tempString = ((temp.hour()<10) ? '0' : '')+String.valueOf(temp.hour())+':'+((temp.minute()==0) ? '00' :  String.valueOf(temp.minute()));
                headerWrapperClass.tableHeaders.add(tempString);
                
                if(tableHeaderDurationString[1].length()==2){
                    headerWrapperClass.indexHeaders.add(String.valueOf(i+0.00));
                }
                else{
                    headerWrapperClass.indexHeaders.add(String.valueOf(i+0.0));
                }
                //String[] tempIndex = (String.valueOf(i)).split('.');
                temp = temp.addMinutes(conversionOfDurationFromHoursToMins);
                system.debug('Temp after adding minutes - '+temp);
            }
            System.debug('tableHeaders - '+headerWrapperClass.tableHeaders);
            System.debug('tableHeaders Index - '+headerWrapperClass.indexHeaders);
            
        }
        return headerWrapperClass;
    }
    
    @AuraEnabled    
    /*
* This will fetch the available technician on the preferred date time for specified work type.
* And fetch the slot which is already allocated/busy for the available technician.
* 
* Steps : Query the business slot based on the preferred date/day, then query the contact related to valid slot and the binding records.
* Fetch the avaliable technicians Allocated WO details by querying the WOA records for the preferred date
*/
    public Static Map<String, Map<Object,Object>> fetchTechnicianList(String WorkOrderType,DateTime PreferredDateandTime,String territory, String searchText, String startHeader, String endHeader, Decimal tableHeaderDuration){
        try{
            System.debug('WorkOrderDetailList for type:'+WorkOrderType);
            System.debug('PreferredDateandTime:'+PreferredDateandTime);
            
            String[] splitStartHeader = startHeader.split(':');
            Decimal slotStartIndex = Decimal.valueOf(splitStartHeader[0]);
            
            String[] splitEndHeader = endHeader.split(':');
            Decimal slotEndIndex = Decimal.valueOf(splitEndHeader[0]);    
            
            
            
            tableHeaderDuration = tableHeaderDuration + 0.0;
            String[] tableHeaderDurationString = String.valueOf(tableHeaderDuration).split('\\.');
            String startTimeForHeader;
            String endTimeForHeader;
            
            //---get preffered time value
            Time preferredTime = Time.newInstance(PreferredDateandTime.hour(), PreferredDateandTime.minute(), PreferredDateandTime.second(), PreferredDateandTime.millisecond());
            system.debug('preferredTime'+preferredTime);
            
            //---get preffered date value
            Date myDate = date.newinstance(PreferredDateandTime.year(), PreferredDateandTime.month(), PreferredDateandTime.day());
            
            //---get preffered day
            Datetime dt1 = DateTime.newInstance(myDate, Time.newInstance(0, 0, 0, 0));
            String dateStr = dt1.format('EEEE');
            system.debug('day>>>'+dateStr);
            Datetime x =  Datetime.now();
            Integer m = x.millisecond();
            
            System.debug('before query'+m);
            List<sigmaerpdev2__Business_Day_Slot__c> slotList=new List<sigmaerpdev2__Business_Day_Slot__c>();
            //get the slot list related to Business day equal to preferred day and preferred time with business day as well as active business day slothttps://ffpunmanagedv8-dev-ed.my.salesforce.com/_ui/common/apex/debug/ApexCSIPage#
            // BusinessDaySlot Fields that will be accessed.
            String [] businessDaySloyFields = new String [] {'sigmaerpdev2__Is_Available__c','sigmaerpdev2__Start_Time__c','sigmaerpdev2__End_Time__c','sigmaerpdev2__Business_Day__c'};
                
                // Obtaining the field name/token map for the BusinessDaySlot object
                Map<String,Schema.SObjectField> businessDaySlotMap = Schema.SObjectType.sigmaerpdev2__Business_Day_Slot__c.fields.getMap();
            for (String fieldToCheck : businessDaySloyFields) {
                // Check if the user has create access on the each field
                if (!businessDaySlotMap.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on Business Day Slot Fields');
                    return null;
                }
            }
            slotList = [SELECT sigmaerpdev2__Business_Day__r.sigmaerpdev2__Business_Calendar__c FROM sigmaerpdev2__Business_Day_Slot__c
                        WHERE sigmaerpdev2__Start_Time__c <= :preferredTime AND sigmaerpdev2__END_Time__c >= :preferredTime 
                        AND sigmaerpdev2__Is_Available__c = TRUE AND sigmaerpdev2__Business_Day__r.Name=:dateStr 
                        AND sigmaerpdev2__Business_Day__r.sigmaerpdev2__Start_Time__c <=: preferredTime 
                        AND sigmaerpdev2__Business_Day__r.sigmaerpdev2__END_Time__c >= :preferredTime];
            
            //List<sigmaerpdev2__Business_Day_Slot__c> slotList = [SELECT sigmaerpdev2__Business_Day__r.sigmaerpdev2__Business_Calendar__c,sigmaerpdev2__Is_Available__c FROM sigmaerpdev2__Business_Day_Slot__c WHERE sigmaerpdev2__Start_Time__c <= :preferredTime AND sigmaerpdev2__END_Time__c >= :preferredTime AND sigmaerpdev2__Business_Day__r.Name=:dateStr AND sigmaerpdev2__Business_Day__r.sigmaerpdev2__Start_Time__c <=: preferredTime AND sigmaerpdev2__Business_Day__r.sigmaerpdev2__END_Time__c >= :preferredTime];
            System.debug('slotList----'+slotList);
            
            Datetime x1 =  Datetime.now();
            Integer m1 = x1.millisecond();
            System.debug('After query'+m1);
            //--holds the business calendar ids
            List<Id> slotListId = new List<Id>();
            
            //--iterate and add the business calendar id in a list
            for(sigmaerpdev2__Business_Day_Slot__c eachSlot:slotList){
                slotListId.add(eachSlot.sigmaerpdev2__Business_Day__r.sigmaerpdev2__Business_Calendar__c);            
            }
            
            Map<String, Map<Object,Object>> Worktypeslots = null;
            if(slotListId!=null && slotListId.size()>0){
                
                List<sigmaerpdev2__Service_Resource__c> contactList = new List<sigmaerpdev2__Service_Resource__c>();
                //--in case of search contact get the contact/technician related to search text only
                if(searchText != null && searchText != ''){
                    
                    string tempSearchText = '%' + searchText + '%';
                    //--query the contacts based on the avaiable slot of a business day
                    /*contactList = [SELECT Id, sigmaerpdev2__Business_Calendar__c FROM Contact 
WHERE sigmaerpdev2__Business_Calendar__r.sigmaerpdev2__Validity__c >=:myDate  
AND sigmaerpdev2__Business_Calendar__r.sigmaerpdev2__Active__c = TRUE 
AND sigmaerpdev2__Business_Calendar__c IN :slotListId AND sigmaerpdev2__Territory__c =:territory AND Name LIKE: tempSearchText];*/
                    if(Schema.sObjectType.sigmaerpdev2__Service_Resource__c.fields.sigmaerpdev2__Business_Calendar__c.isAccessible()){
                        contactList = [SELECT Id, sigmaerpdev2__Business_Calendar__c FROM sigmaerpdev2__Service_Resource__c 
                                       WHERE sigmaerpdev2__Business_Calendar__r.sigmaerpdev2__Active__c = TRUE 
                                       AND sigmaerpdev2__Business_Calendar__c IN :slotListId AND sigmaerpdev2__Territory__c =:territory AND Name LIKE: tempSearchText];
                        
                    }
                    else{
                        system.debug('No access on Contact\'s BusinessCalendar Field');
                        return null;
                    }
                    
                    
                }
                //--if no search text is entered
                else{
                    //--query the contacts based on the avaiable slot of a business day
                    /* contactList = [SELECT Id, sigmaerpdev2__Business_Calendar__c FROM Contact 
WHERE sigmaerpdev2__Business_Calendar__r.sigmaerpdev2__Validity__c >=:myDate  
AND sigmaerpdev2__Business_Calendar__r.sigmaerpdev2__Active__c = TRUE 
AND sigmaerpdev2__Business_Calendar__c IN :slotListId AND sigmaerpdev2__Territory__c =:territory];*/
                    Datetime x2 =  Datetime.now();
                    Integer m2 = x2.millisecond();
                    
                    System.debug('before query'+m2);
                    if(Schema.sObjectType.sigmaerpdev2__Service_Resource__c.fields.sigmaerpdev2__Business_Calendar__c.isAccessible()){
                        contactList = [SELECT Id, sigmaerpdev2__Business_Calendar__c FROM sigmaerpdev2__Service_Resource__c 
                                       WHERE sigmaerpdev2__Business_Calendar__r.sigmaerpdev2__Active__c = TRUE 
                                       AND sigmaerpdev2__Business_Calendar__c IN :slotListId AND sigmaerpdev2__Territory__c =:territory];
                    }
                    else{
                        system.debug('No access on Contact\'s BusinessCalendar Field');
                        return null;
                    }
                    System.debug('contactList---'+contactList);
                    Datetime x3 =  Datetime.now();
                    Integer m3 = x3.millisecond();
                    
                    System.debug('After query'+m3);
                }
                
                
                system.debug('slotList>>>>>'+slotList);
                system.debug('contactList>>>>>'+contactList);
                
                if(contactList != null && contactList.size()>0){
                    
                    //--map holds key as technician Id and value as WTB record
                    Map<Id, sigmaerpdev2__Work_T__c> contactIdWorkTypeMap = new Map<Id, sigmaerpdev2__Work_T__c>();
                    
                    //List<sigmaerpdev2__Work_T__c> TechnicianList = [Select id ,sigmaerpdev2__Resource_Name__r.Name,sigmaerpdev2__Skill_Level__c,sigmaerpdev2__Service_Duration__c from sigmaerpdev2__Work_T__c where sigmaerpdev2__Work_Type__c = 'Installation' and sigmaerpdev2__Skill_Level__c = 9 Limit 5];
                    
                    //--query the work type binding records based on the contact list queried above
                    Datetime technicianWorkTypeBindList1 =  Datetime.now();
                    Integer technicianWorkTypeBindList2 = technicianWorkTypeBindList1.millisecond();
                    
                    System.debug('before query'+technicianWorkTypeBindList2);
                    List<sigmaerpdev2__Work_T__c> technicianWorkTypeBindList=new List<sigmaerpdev2__Work_T__c>();
                    // WprkType Fields that will be accessed.
                    String [] workTypeFields = new String [] {'sigmaerpdev2__Technician__c','sigmaerpdev2__Service_Duration__c','sigmaerpdev2__Work_Type__c','sigmaerpdev2__Skill_Level__c'};
                        
                        // Obtaining the field name/token map for the WprkType object
                        Map<String,Schema.SObjectField> workTypeMap = Schema.SObjectType.sigmaerpdev2__Work_T__c.fields.getMap();
                    for (String fieldToCheck : workTypeFields) {
                        // Check if the user has create access on the each field
                        if (!workTypeMap.get(fieldToCheck).getDescribe().isAccessible()) {
                            system.debug('Has no Access on WprkType Fields');
                            return null;
                        }
                    }
                    
                    technicianWorkTypeBindList = [Select id, sigmaerpdev2__Technician__r.sigmaerpdev2__Average_Travel_Speed__c , sigmaerpdev2__Technician__r.sigmaerpdev2__Mailing_Zip_Postal_Code__c,                                                          
                                                  sigmaerpdev2__Technician__r.Name,sigmaerpdev2__Skill_Level__c,sigmaerpdev2__Service_Duration__c,sigmaerpdev2__Technician__c 
                                                  FROM sigmaerpdev2__Work_T__c WHERE sigmaerpdev2__Work_Type__c = :WorkOrderType AND sigmaerpdev2__Technician__c IN:contactList AND sigmaerpdev2__Technician__r.sigmaerpdev2__Active__c = :true  ORDER BY sigmaerpdev2__Skill_Level__c DESC];
                    
                    
                    system.debug('technicianWorkTypeBindList>>'+technicianWorkTypeBindList); 
                    Datetime technicianWorkTypeBindList3 =  Datetime.now();
                    Integer technicianWorkTypeBindList4 = technicianWorkTypeBindList3.millisecond();
                    
                    System.debug('After query'+technicianWorkTypeBindList4);
                    //--get the work order assignment records for the above contact records to get already allocated time
                    List<Id> technicianIdList = new List<Id>();
                    
                    //--holds the reach technician/contact details
                    Map<String, Map<Object,Object>> WorkTypeSlotsTemp = new Map<String, Map<Object,Object>>();
                    
                    //holds the technician break details
                    Map<Id, Map<Decimal, String>> technicianBreakDetailsMap = new Map<Id, Map<Decimal, String>>();
                    for(sigmaerpdev2__Work_T__c eachWTB : technicianWorkTypeBindList){
                        if(eachWTB.sigmaerpdev2__Technician__c != null ){
                            
                            //--holds the technician of required Work Type and territory availble for the WO preferred dateTime
                            technicianIdList.add(eachWTB.sigmaerpdev2__Technician__c);  
                            
                            //--map with key as technician and valua as WTB record
                            contactIdWorkTypeMap.put(eachWTB.sigmaerpdev2__Technician__c, eachWTB);
                            
                            //--adding the contact/technician details to the map
                            Map<Object,Object> eachTechnician = new Map<Object, Object>();
                            eachTechnician.put('sigmaerpdev2__Skill_Level__c', eachWTB.sigmaerpdev2__Skill_Level__c);                
                            eachTechnician.put('sigmaerpdev2__Service_Duration__c', (eachWTB.sigmaerpdev2__Service_Duration__c)/tableHeaderDuration);
                            eachTechnician.put('MailingPostalCode', eachWTB.sigmaerpdev2__Technician__r.sigmaerpdev2__Mailing_Zip_Postal_Code__c);
                            eachTechnician.put('contactName', eachWTB.sigmaerpdev2__Technician__r.Name); 
                            eachTechnician.put('contactSpeed', eachWTB.sigmaerpdev2__Technician__r.sigmaerpdev2__Average_Travel_Speed__c); 
                            //WorkTypeSlotsTemp.put(eachWTB.sigmaerpdev2__Resource_Name__c, eachTechnician);
                            
                            //-get the technician break details and store in Map
                            Map<Decimal, String> technicianBreakTime = getTechnicianBreak(PreferredDateandTime,eachWTB.sigmaerpdev2__Technician__c,startHeader,endHeader,tableHeaderDuration);
                            system.debug('technicianBreakTime'+technicianBreakTime);
                            technicianBreakDetailsMap.put(eachWTB.sigmaerpdev2__Technician__c, technicianBreakTime);
                            
                            for(Decimal slotKey :technicianBreakTime.keySet()){
                                eachTechnician.put(slotKey, technicianBreakTime.get(slotKey));
                            }
                            WorkTypeSlotsTemp.put(eachWTB.sigmaerpdev2__Technician__c, eachTechnician);
                            
                        }                    
                    }
                    system.debug('technicianBreakDetailsMap>>>'+technicianBreakDetailsMap);
                    
                    system.debug('contactIdWorkTypeMap>>>>'+contactIdWorkTypeMap);
                    system.debug('technicianIdList>>'+technicianIdList);
                    
                    //--holds the technicians/contacts
                    List<Id> contactId = new List<Id>();
                    
                    //---holds the flag to check the queried worktype binding record prefferred date matches the current WO preferred date
                    Boolean flagDate = true;
                    
                    Worktypeslots = new Map<String, Map<Object,Object>>();
                    
                    // WorkOrderAssignment Fields that will be accessed.
                    String [] woaFields = new String [] {'sigmaerpdev2__Work_Order__c','sigmaerpdev2__Technician__c','sigmaerpdev2__Start_Time__c','sigmaerpdev2__Work_Order_Duration__c'};
                        
                        // Obtaining the field name/token map for the WorkOrderAssignment object
                        Map<String,Schema.SObjectField> woaMap = Schema.SObjectType.sigmaerpdev2__Work_Order_Assignment__c.fields.getMap();
                    for (String fieldToCheck : woaFields) {
                        // Check if the user has create access on the each field
                        if (!woaMap.get(fieldToCheck).getDescribe().isAccessible()) {
                            system.debug('Has no Access on WorkOrderAssignment Fields');
                            return null;
                        }
                    }
                    //--query work order assignment records, iterate and build a map
                    //--query the WOA records and iterate through to get the assigned WO for the preffered date time for the technicians
                    if(Schema.sObjectType.sigmaerpdev2__Work_Order_Assignment__c.isAccessible()){
                        for(sigmaerpdev2__Work_Order_Assignment__c eachWOAssignment : 
                            [SELECT Id, sigmaerpdev2__Technician__c,sigmaerpdev2__Work_Order__c,sigmaerpdev2__Work_Order__r.sigmaerpdev2__Customer_Availability_Date__c,sigmaerpdev2__Work_Order__r.sigmaerpdev2__FFP_MR_Contact__r.Name,
                             sigmaerpdev2__Start_Time__c, sigmaerpdev2__Work_Order_Duration__c, sigmaerpdev2__Work_Order__r.sigmaerpdev2__Service_Zip_Postal_Code__c, sigmaerpdev2__Work_Order__r.Name FROM sigmaerpdev2__Work_Order_Assignment__c 
                             WHERE sigmaerpdev2__Technician__c IN: technicianIdList]){
                                 
                                 //Map<Integer, String> technicianBreakTime = getTechnicianBreak(PreferredDateandTime,eachWOAssignment.sigmaerpdev2__Contact__c);
                                 Map<Decimal, String> technicianBreakTime = new Map<Decimal, String>();
                                 if(technicianBreakDetailsMap.containsKey(eachWOAssignment.sigmaerpdev2__Technician__c)){
                                     technicianBreakTime = technicianBreakDetailsMap.get(eachWOAssignment.sigmaerpdev2__Technician__c);
                                 }
                                 system.debug('technicianBreakTime'+technicianBreakTime);                                                                           
                                 system.debug('eachWOAssignment>>>>>'+eachWOAssignment.sigmaerpdev2__Work_Order__r.sigmaerpdev2__Customer_Availability_Date__c);
                                 
                                 flagDate = true;
                                 
                                 //--if the Work type binding is has a WO associated get the WO preferred date and check whether allocated for the same preferred date to check the availability
                                 if(eachWOAssignment.sigmaerpdev2__Work_Order__c != null){ 
									if(eachWOAssignment.sigmaerpdev2__Work_Order__r.sigmaerpdev2__Customer_Availability_Date__c != null){
										DateTime eachWorkOrderPreferredDate = eachWOAssignment.sigmaerpdev2__Work_Order__r.sigmaerpdev2__Customer_Availability_Date__c;
										 Date eachWorkOrderPreferredDateValue = date.newinstance(eachWorkOrderPreferredDate.year(), eachWorkOrderPreferredDate.month(), eachWorkOrderPreferredDate.day());
										 system.debug('myDate'+myDate+'eachWorkOrderPreferredDateValue'+eachWorkOrderPreferredDateValue);
										 
										 if(eachWorkOrderPreferredDateValue  != myDate ){                   
											 flagDate = false;
										 }     
									}                                                
                                 }
                                 
                                 //--only if the current WO preferred date is same as the already allocated WO for a technician
                                 if(flagDate){
                                     
                                     //--check the technician list already has the current technician
                                     if(contactId != null && contactId.size()>0 && !contactId.isEmpty() && contactId.contains(eachWOAssignment.sigmaerpdev2__Technician__c))
                                     {                            
                                         Map<Object,Object> eachTechnician = Worktypeslots.get(eachWOAssignment.sigmaerpdev2__Technician__c);
                                         system.debug('eachTechnician'+eachTechnician);
                                         
                                         //--get the start hour
                                         Time startTime = eachWOAssignment.sigmaerpdev2__Start_Time__c;
                                         system.debug('startTime - '+startTime);
                                         Decimal startHour = startTime.hour();
                                         Decimal startMinutes = startTime.minute() + 0.0;
                                         startMinutes = startMinutes/60;
                                         startHour = startHour + startMinutes;
                                         if(tableHeaderDurationString[1].length()==2){
                                             startHour = startHour + 0.00;
                                         }
                                         //-- if the WOA start time is not empty add the WOA details to the corresponding slot of a technician
                                         if(startHour != null && startHour != 0){
                                             System.debug('startHour>>>>>!! '+startHour);
                                             Decimal slotValue = startHour+0.0;
                                             Decimal duration = eachWOAssignment.sigmaerpdev2__Work_Order_Duration__c;
                                             //--iterate to add slot hour details for the same WO 
                                             while((duration + startHour) > slotValue && slotValue<=slotEndIndex){
                                                 System.debug('slotValue>>>>>>!! '+slotValue +'wtb'+eachWOAssignment );
                                                 /*eachTechnician.put(slotValue, eachWOAssignment);
slotValue = slotValue+1;  */
                                                 Decimal slotValueInt = slotValue+0.0;
                                                 if(!technicianBreakTime.containsKey(slotValueInt)){
                                                     eachTechnician.put(slotValue, eachWOAssignment);
                                                 }else{
                                                     duration = duration+tableHeaderDuration;  
                                                 } 
                                                 slotValue = slotValue+tableHeaderDuration; 
                                             }                        
                                         }                    
                                         Worktypeslots.put(eachWOAssignment.sigmaerpdev2__Technician__c, eachTechnician);                                 
                                     }else{
                                         contactId.add(eachWOAssignment.sigmaerpdev2__Technician__c);                                
                                         Map<Object,Object> eachTechnician = new Map<Object, Object>();
                                         
                                         //--get the start hour
                                         Time startTime = eachWOAssignment.sigmaerpdev2__Start_Time__c;
                                         system.debug('startTime - '+startTime);
                                         Decimal startHour = startTime.hour();
                                         Decimal startMinutes = startTime.minute() + 0.0;
                                         startMinutes = startMinutes/60;
                                         startHour = startHour + startMinutes;
                                         if(tableHeaderDurationString[1].length()==2){
                                             startHour = startHour + 0.00;
                                         }
                                         //-- if the WOA start time is not empty add the WOA details to the corresponding slot of a technician
                                         if(startHour != null && startHour != 0){                        
                                             system.debug('else>>>>>>>>>>>>'+startHour);
                                             Decimal slotValue = startHour+0.0;
                                             Decimal duration = eachWOAssignment.sigmaerpdev2__Work_Order_Duration__c;
                                             system.debug('beforewhile>>>>>>>>>>>>'+((duration + slotValue)-tableHeaderDuration));
                                             
                                             while((duration + startHour) > slotValue && slotValue<=slotEndIndex){
                                                 system.debug('while>>>>>>>>>>>>'+duration);
                                                 Decimal slotValueInt = slotValue+0.0;
                                                 if(!technicianBreakTime.containsKey(slotValueInt)){
                                                     eachTechnician.put(slotValue, eachWOAssignment);
                                                     //duration = duration+1;  
                                                 }else{
                                                     duration = duration+tableHeaderDuration;  
                                                 } 
                                                 slotValue = slotValue+tableHeaderDuration; 
                                             }                        
                                         }    
                                         //--store the contact details for each technician
                                         if(contactIdWorkTypeMap.containsKey(eachWOAssignment.sigmaerpdev2__Technician__c)){
                                             sigmaerpdev2__Work_T__c workTypeDetails = contactIdWorkTypeMap.get(eachWOAssignment.sigmaerpdev2__Technician__c);
                                             //--store the skill level, duration, mailing Postal code technician name, and worktype binding records associated for technician
                                             eachTechnician.put('sigmaerpdev2__Skill_Level__c', workTypeDetails.sigmaerpdev2__Skill_Level__c);                
                                             eachTechnician.put('sigmaerpdev2__Service_Duration__c', (workTypeDetails.sigmaerpdev2__Service_Duration__c)/tableHeaderDuration);
                                             eachTechnician.put('MailingPostalCode', workTypeDetails.sigmaerpdev2__Technician__r.sigmaerpdev2__Mailing_Zip_Postal_Code__c);
                                             eachTechnician.put('contactName', workTypeDetails.sigmaerpdev2__Technician__r.Name); 
                                             eachTechnician.put('contactSpeed', workTypeDetails.sigmaerpdev2__Technician__r.sigmaerpdev2__Average_Travel_Speed__c); 
                                             for(Decimal slotKey :technicianBreakTime.keySet()){
                                                 eachTechnician.put(slotKey, technicianBreakTime.get(slotKey));
                                             }
                                         }
                                         Worktypeslots.put(eachWOAssignment.sigmaerpdev2__Technician__c, eachTechnician);
                                     }
                                 }
                                 system.debug('Worktypeslots>>'+Worktypeslots);                        
                             }
                    }                
                    //-- in case no WOA record found for the technician assign the technician details to the Worktypeslots map
                    if(Worktypeslots!=null && Worktypeslots.size()<=0){
                        Worktypeslots = WorkTypeSlotsTemp;
                        WorkTypeSlotsTemp = null;
                    }
                    //--if the some available technician does not have WOA add the technican details to the final Map
                    else{
                        //--iterate the technician map to check whether the WOA map has the tecnician details and add if not.
                        for(Id technicianId :WorkTypeSlotsTemp.keySet()){
                            if(!Worktypeslots.keySet().contains(technicianId)){
                                Worktypeslots.put(technicianId, WorkTypeSlotsTemp.get(technicianId));
                            }
                        }
                    }
                    system.debug('Worktypeslots>>>>--------------'+Worktypeslots);                                
                }
                
            }
            return Worktypeslots;
        }
        catch(Exception e){
            system.debug('Excetion occurred at '+e.getLineNumber());
            system.debug('Excetion occurred at '+e.getMessage());
            return null;
        }
        
    }
    
    @AuraEnabled
    public Static sigmaerpdev2__Work_Order__c WorkOrderDetailsL(String CurrentWOId,sigmaerpdev2__Work_Order__c WorkOrderDetailList){
        
        system.debug('CurrentWOId'+CurrentWOId);
        sigmaerpdev2__Work_Order__c workorderDetailsListC=new sigmaerpdev2__Work_Order__c();
        // WorkOrder Fields that will be accessed.
        String [] workOrderFields = new String [] {'name','sigmaerpdev2__Customer_Availability_Date__c','sigmaerpdev2__Status__c','sigmaerpdev2__AssignTo__c','sigmaerpdev2__FFP_MR_Contact__c','sigmaerpdev2__Service_City__c','sigmaerpdev2__Service_Zip_Postal_Code__c','sigmaerpdev2__Territory__c','sigmaerpdev2__Work_Type__c'};
            
            // Obtaining the field name/token map for the WorkOrder object
            Map<String,Schema.SObjectField> workOrderMap = Schema.SObjectType.sigmaerpdev2__Work_Order__c.fields.getMap();
        for (String fieldToCheck : workOrderFields) {
            // Check if the user has create access on the each field
            if (!workOrderMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on WorkOrder Fields');
                return null;
            }
        }
        workorderDetailsListC = [Select id,name,sigmaerpdev2__FFP_MR_Contact__r.Name,sigmaerpdev2__Status__c ,sigmaerpdev2__Customer_Availability_Date__c,sigmaerpdev2__Service_City__c,sigmaerpdev2__Service_Zip_Postal_Code__c,sigmaerpdev2__Account__r.Name,sigmaerpdev2__Work_Type__r.name,sigmaerpdev2__Work_Type__r.sigmaerpdev2__Gantt_Chart_Slot_Duration__c, sigmaerpdev2__Territory__c, sigmaerpdev2__AssignTo__c  from sigmaerpdev2__Work_Order__c where id =:CurrentWOId limit 1];
       
        if(workorderDetailsListC.sigmaerpdev2__Work_Type__c == null || workorderDetailsListC.sigmaerpdev2__Territory__c == null || workorderDetailsListC.sigmaerpdev2__Territory__c == null || workorderDetailsListC.sigmaerpdev2__Customer_Availability_Date__c == null){
            system.debug('Work Type or Territory or Preferred Service Date/Time is missing');
            return null;
        }
        //if(workorderDetailsListC.sigmaerpdev2__Territory__c!=)
        
        system.debug('workorderDetailsListC'+workorderDetailsListC);
        return workorderDetailsListC;
    }
    
    /*@AuraEnabled
public static List<sigmaerpdev2__Work_T__c> getTechnicianName(String searchText,List<sigmaerpdev2__Work_T__c> TechnicianList){
List<sigmaerpdev2__Work_T__c> SearchedTechnicianList;
if(searchText != null && searchText.length()>0){
searchText = '%' + searchText + '%';
try{
//SearchedTechnicianList = [Select id ,Resource_Name__r.Name,sigmaerpdev2__Skill_Level__c,sigmaerpdev2__Service_Duration__c from sigmaerpdev2__Work_T__c where Resource_Name__r.Name Like :searchText and sigmaerpdev2__Work_Type__c = 'Installation' and Skill_Level__c = 9 Order By LastModifiedDate Limit 5];
}catch(Exception ex){
System.debug('SearchedTechnicianList List query Failed='+ex.getMessage());
}
}
return  SearchedTechnicianList;
}*/
    
    //--this will return a Map with unavailable time details of a technician
    @AuraEnabled
    public static Map<Decimal, String> getTechnicianBreak(DateTime PreferredDateTime,Id TechnicianId,String startHeader,String endHeader,Decimal tableHeaderDuration)
    {
        System.debug('************************ Inside getTechnicianBreak Method ************************');
        System.debug('PreferredDate>>>>>!!!!:'+PreferredDateTime);
        System.debug('TechnicianId>>>>>!!!!!:'+TechnicianId);
        System.debug('TechnicianId>>>>>!!!!!:'+tableHeaderDuration);
        System.debug('Start Hour>>>>>!!!!!:'+startHeader);
        System.debug('End Hour>>>>>!!!!!:'+endHeader);
        //--get the preferred time value
        Time preferredTime = Time.newInstance(PreferredDateTime.hour(), PreferredDateTime.minute(), PreferredDateTime.second(), PreferredDateTime.millisecond());
        String[] tableHeaderDurationString = String.valueOf(tableHeaderDuration).split('\\.');
        
        //--get the preferred date value
        Date myDate = date.newinstance(PreferredDateTime.year(), PreferredDateTime.month(), PreferredDateTime.day());
        system.debug('Preferred Date -'+myDate);
        //--get the preferred day
        Datetime dt1 = DateTime.newInstance(myDate, Time.newInstance(0, 0, 0, 0));
        String dateStr = dt1.format('EEEE');
        sigmaerpdev2__Service_Resource__c con=new sigmaerpdev2__Service_Resource__c();
        //--query the business calendar related to the contact
        if(Schema.sObjectType.sigmaerpdev2__Service_Resource__c.fields.sigmaerpdev2__Business_Calendar__c.isAccessible()){
            con=[SELECT Id, sigmaerpdev2__Business_Calendar__c FROM sigmaerpdev2__Service_Resource__c WHERE id=:TechnicianId LIMIT 1];
        }
        else{
            system.debug('No access on Contact\'s BusinessCalendar Field');
            return null;
        }
        //--get the business slot based on the business calendar
        
        String [] businessDaySloyFields = new String [] {'sigmaerpdev2__Is_Available__c','sigmaerpdev2__Start_Time__c','sigmaerpdev2__End_Time__c','sigmaerpdev2__Business_Day__c','sigmaerpdev2__Is_Lunch__c'};
            
            // Obtaining the field name/token map for the BusinessDaySlot object
            Map<String,Schema.SObjectField> businessDaySlotMap = Schema.SObjectType.sigmaerpdev2__Business_Day_Slot__c.fields.getMap();
        for (String fieldToCheck : businessDaySloyFields) {
            // Check if the user has create access on the each field
            if (!businessDaySlotMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on Business Day Slot Fields');
                return null;
            }
        }
        List<sigmaerpdev2__Business_Day_Slot__c> slotDetails=new List<sigmaerpdev2__Business_Day_Slot__c>();
        
        List<sigmaerpdev2__Resource_Working_Hours__c> resourceWorkingHours = [SELECT sigmaerpdev2__Date__c, sigmaerpdev2__Start_Time_Part_1__c, sigmaerpdev2__Start_Time_Part_2__c, sigmaerpdev2__End_Time_Part_1__c, sigmaerpdev2__End_Time_Part_2__c, sigmaerpdev2__Service_Resource__c, Id, Name FROM sigmaerpdev2__Resource_Working_Hours__c where sigmaerpdev2__Service_Resource__c=:con.Id AND sigmaerpdev2__Date__c=:myDate limit 1];
        System.debug('resourceWorkingHours - '+resourceWorkingHours);
        
        if(resourceWorkingHours.size()>0){
            sigmaerpdev2__Business_Day_Slot__c tempBusinessDaySlot = new sigmaerpdev2__Business_Day_Slot__c();
            tempBusinessDaySlot.sigmaerpdev2__Start_Time__c = resourceWorkingHours[0].sigmaerpdev2__Start_Time_Part_1__c;
            tempBusinessDaySlot.sigmaerpdev2__End_Time__c = resourceWorkingHours[0].sigmaerpdev2__End_Time_Part_1__c;
            tempBusinessDaySlot.sigmaerpdev2__Is_Available__c = True;
            slotDetails.add(tempBusinessDaySlot);
            
            sigmaerpdev2__Business_Day_Slot__c tempBusinessDaySlot1 = new sigmaerpdev2__Business_Day_Slot__c();
            if(resourceWorkingHours[0].sigmaerpdev2__Start_Time_Part_2__c!=null && resourceWorkingHours[0].sigmaerpdev2__End_Time_Part_2__c!=null){
                tempBusinessDaySlot1.sigmaerpdev2__Start_Time__c = resourceWorkingHours[0].sigmaerpdev2__Start_Time_Part_2__c;
                tempBusinessDaySlot1.sigmaerpdev2__End_Time__c = resourceWorkingHours[0].sigmaerpdev2__End_Time_Part_2__c;
                tempBusinessDaySlot1.sigmaerpdev2__Is_Available__c = True;
                slotDetails.add(tempBusinessDaySlot1);
            }
            if(resourceWorkingHours[0].sigmaerpdev2__End_Time_Part_2__c==null){
                resourceWorkingHours[0].sigmaerpdev2__End_Time_Part_2__c = resourceWorkingHours[0].sigmaerpdev2__End_Time_Part_1__c;
            }
            system.debug('slotDetails'+slotDetails);
        }
        else{
            slotDetails = [SELECT Id, sigmaerpdev2__Is_Lunch__c, sigmaerpdev2__Is_Available__c, sigmaerpdev2__Start_Time__c, sigmaerpdev2__End_Time__c, sigmaerpdev2__Business_Day__c,sigmaerpdev2__Business_Day__r.Name,sigmaerpdev2__Business_Day__r.sigmaerpdev2__Business_Calendar__c,sigmaerpdev2__Business_Day__r.sigmaerpdev2__End_Time__c,sigmaerpdev2__Business_Day__r.sigmaerpdev2__Start_Time__c FROM sigmaerpdev2__Business_Day_Slot__c WHERE sigmaerpdev2__Business_Day__r.Name =:dateStr AND sigmaerpdev2__Business_Day__r.sigmaerpdev2__Business_Calendar__c=:con.sigmaerpdev2__Business_Calendar__c ORDER BY sigmaerpdev2__Start_Time__c];
            system.debug('slotDetails'+slotDetails);
        }       
        
        //--Map holds the key as the time (8,9..) and value as availability
        Map<Decimal, String> slotAvailabilityMap = new Map<Decimal, String>();
        
        
        
        //--standard day start time
        String[] splitStartHeader = startHeader.split(':');
        Decimal slotStartIndex = Decimal.valueOf(splitStartHeader[0]);
        
        String[] splitEndHeader = endHeader.split(':');
        Decimal slotEndIndex = Decimal.valueOf(splitEndHeader[0]);
        
        Decimal slotIndex = (slotDetails[0].sigmaerpdev2__Start_Time__c.hour())+0.0;
        system.debug('slotIndex - '+slotIndex);
        
        if(slotDetails!=null && slotDetails.size()>0){
            //hold the business day start time hour
            //Integer slotHour = slotDetails[0].sigmaerpdev2__Business_Day__r.sigmaerpdev2__Start_Time__c.hour();
            Decimal slotHour = slotStartIndex + 0.0;
            system.debug('slotHour - '+slotHour);
            //--based on the technician business day start time set the Map with unavailable time
            while(slotHour < slotIndex){
                slotAvailabilityMap.put(slotHour,'NW');
                slotHour = slotHour+1;
            }
            system.debug('slotAvailabilityMap for the start of the day - '+slotAvailabilityMap);
            //--standard day End time
            
            slotIndex = slotDetails[slotDetails.size()-1].sigmaerpdev2__End_Time__c.hour();
            
            //hold the business day End time hour
            //Integer slotEndHour = slotDetails[0].sigmaerpdev2__Business_Day__r.sigmaerpdev2__End_Time__c.hour();
            Decimal slotEndHour = slotEndIndex + 0.0;
            system.debug('slotEndHour - '+slotEndHour);
            system.debug('slotIndex - '+slotIndex);
            //--based on the technician business day End time set the Map with unavailable time
            while(slotEndHour >= slotIndex){
                slotAvailabilityMap.put(slotEndHour,'NW');
                slotEndHour = slotEndHour-1;
            }
            
            Set<Decimal> slotList = new Set<Decimal>();
            
            //--iterate through the list of slot to get the unavailable/break time for a technician
            for(sigmaerpdev2__Business_Day_Slot__c eachSlot : slotDetails){
                
                Decimal eachSlotStartHour = eachSlot.sigmaerpdev2__Start_Time__c.hour() + 0.0;
                Decimal eachSlotEndHour = eachSlot.sigmaerpdev2__End_Time__c.hour() + 0.0;
                if(tableHeaderDurationString[1].length()==2){
                    eachSlotStartHour = eachSlotStartHour+0.00;
                }
                while(eachSlotStartHour < eachSlotEndHour){
                    slotList.add(eachSlotStartHour);
                    eachSlotStartHour = eachSlotStartHour+tableHeaderDuration;
                    
                }
                
                //SC 1: prff=7pm ,,bs=11 BE = 6 >p-19; s- 11; e-18
                //SC 2: prff=8am ,,bs=11 BE = 6
                //SC 3: prff=12pm ,,bs=11 BE = 6
                //if(eachSlot.sigmaerpdev2__Business_Day__r.sigmaerpdev2__Start_Time__c > preferredTime && eachSlot.sigmaerpdev2__Business_Day__r.sigmaerpdev2__End_Time__c > preferredTime){
                //NA
                //}else if(eachSlot.sigmaerpdev2__Business_Day__r.sigmaerpdev2__End_Time__c < preferredTime){
                //NA
                //slotIndex = eachSlot.sigmaerpdev2__Business_Day__r.sigmaerpdev2__End_Time__c +1
                //slotAvailabilityMap[slotIndex] = "NA";
                // }else{
                if(resourceWorkingHours.size()>0){
                    if(!(resourceWorkingHours[0].sigmaerpdev2__Start_Time_Part_1__c > preferredTime && resourceWorkingHours[0].sigmaerpdev2__End_Time_Part_2__c > preferredTime) && !(resourceWorkingHours[0].sigmaerpdev2__End_Time_Part_2__c < preferredTime)){
                        system.debug('Inside first If loop');
                        if(eachSlot.sigmaerpdev2__Is_Available__c == false){
                            
                            
                            Decimal breakSlotStartHour = eachSlot.sigmaerpdev2__Start_Time__c.hour() + 0.0;
                            Decimal breakSlotStartMinutes = eachSlot.sigmaerpdev2__Start_Time__c.minute();
                            Decimal breakSlotStart = (breakSlotStartHour + breakSlotStartMinutes/60) + 0.0;
                            Decimal breakSlotEndHour = eachSlot.sigmaerpdev2__End_Time__c.hour() + 0.0;
                            Decimal breakSlotEndMinutes = eachSlot.sigmaerpdev2__End_Time__c.minute();
                            Decimal breakSlotEnd = (breakSlotEndHour + breakSlotEndMinutes/60) + 0.0;
                            system.debug('breakSlotStartHour'+breakSlotStart +'>>>breakSlotEndHour>'+breakSlotEnd);
                            
                            //--in case 1 hour break
                            if(breakSlotEnd - breakSlotStart == tableHeaderDuration) {
                                if(eachSlot.sigmaerpdev2__Is_Lunch__c == true){
                                    slotAvailabilityMap.put(breakSlotStart,'NW');
                                }else{
                                    slotAvailabilityMap.put(breakSlotStart,'NW');
                                }
                                system.debug('slotAvailabilityMap'+slotAvailabilityMap);   
                            }
                            //-- incase of more than 1 hour break
                            else if(breakSlotEnd - breakSlotStart >= tableHeaderDuration){
                                Decimal breakHour = breakSlotEnd - breakSlotStart + 0.0;
                                while(breakHour > 0){
                                    if(eachSlot.sigmaerpdev2__Is_Lunch__c == true){
                                        slotAvailabilityMap.put(breakSlotStart + breakHour -tableHeaderDuration,'NW');
                                    }else{
                                        slotAvailabilityMap.put(breakSlotStart + breakHour -tableHeaderDuration,'NW');
                                    }
                                    breakHour = breakHour-tableHeaderDuration;
                                    system.debug('slotAvailabilityMap'+slotAvailabilityMap);
                                }
                            }                                        
                        }               
                    }
                }
                else{
                    if(!(eachSlot.sigmaerpdev2__Business_Day__r.sigmaerpdev2__Start_Time__c > preferredTime && eachSlot.sigmaerpdev2__Business_Day__r.sigmaerpdev2__End_Time__c > preferredTime) && !(eachSlot.sigmaerpdev2__Business_Day__r.sigmaerpdev2__End_Time__c < preferredTime)){
                        system.debug('Inside first If loop');
                        if(eachSlot.sigmaerpdev2__Is_Available__c == false){
                            
                            
                            Decimal breakSlotStartHour = eachSlot.sigmaerpdev2__Start_Time__c.hour() + 0.0;
                            Decimal breakSlotStartMinutes = eachSlot.sigmaerpdev2__Start_Time__c.minute();
                            Decimal breakSlotStart = (breakSlotStartHour + breakSlotStartMinutes/60) + 0.0;
                            Decimal breakSlotEndHour = eachSlot.sigmaerpdev2__End_Time__c.hour() + 0.0;
                            Decimal breakSlotEndMinutes = eachSlot.sigmaerpdev2__End_Time__c.minute();
                            Decimal breakSlotEnd = (breakSlotEndHour + breakSlotEndMinutes/60) + 0.0;
                            system.debug('breakSlotStartHour'+breakSlotStart +'>>>breakSlotEndHour>'+breakSlotEnd);
                            
                            //--in case 1 hour break
                            if(breakSlotEnd - breakSlotStart == tableHeaderDuration) {
                                if(eachSlot.sigmaerpdev2__Is_Lunch__c == true){
                                    slotAvailabilityMap.put(breakSlotStart,'NW');
                                }else{
                                    slotAvailabilityMap.put(breakSlotStart,'NW');
                                }
                                system.debug('slotAvailabilityMap'+slotAvailabilityMap);   
                            }
                            //-- incase of more than 1 hour break
                            else if(breakSlotEnd - breakSlotStart >= tableHeaderDuration){
                                Decimal breakHour = breakSlotEnd - breakSlotStart + 0.0;
                                while(breakHour > 0){
                                    if(eachSlot.sigmaerpdev2__Is_Lunch__c == true){
                                        slotAvailabilityMap.put(breakSlotStart + breakHour -tableHeaderDuration,'NW');
                                    }else{
                                        slotAvailabilityMap.put(breakSlotStart + breakHour -tableHeaderDuration,'NW');
                                    }
                                    breakHour = breakHour-tableHeaderDuration;
                                    system.debug('slotAvailabilityMap'+slotAvailabilityMap);
                                }
                            }                                        
                        }               
                    }
                }
            }
            //--add NW to the slot which is not having a Business day slot created with in Business day hour
            for(Decimal i=slotStartIndex+0.0 ;i<=slotEndIndex;i=i+tableHeaderDuration){
                if(slotList.contains(i) == false){
                    slotAvailabilityMap.put(i, 'NW');
                    system.debug('slotAvailabilityMap'+' '+i+' '+slotAvailabilityMap.get(i));
                }
            }
        }
        system.debug('slotAvailabilityMap'+slotAvailabilityMap);
        return slotAvailabilityMap;
    }
    
    /*
* On Assign agent save the assignment details
* Create WOA record, also update WO record assigned to the Agent
* Added reassign concept --added on 8/16/2018
* */
    @AuraEnabled
    //public Static sigmaerpdev2__Work_Order__c SaveAssignAgentAssignDetails(String CurrentWOId, Map<String,Object> slotDetailsMap){
    public Static void SaveAssignAgentAssignDetails(String CurrentWOId, Map<String,Object> slotDetailsMap,String eachSlotDuration,List<String> slotIndexHeaders){
        system.debug('Inside SaveAssignAgentAssignDetails'+slotDetailsMap);
        system.debug('Each Slot Duration - '+eachSlotDuration);
        system.debug('slotIndexHeaders - '+slotIndexHeaders);
        
        Decimal eachSlotDurationDecimal = Decimal.valueOf(eachSlotDuration);
        sigmaerpdev2__Service_Resource__c serviceResource = new sigmaerpdev2__Service_Resource__c();
        if(slotDetailsMap!=null && slotDetailsMap.size()>0){
            system.debug('slotDetailsMap'+slotDetailsMap.get('contactId'));
            //-- get the contact related user
            Id contactId = (Id)slotDetailsMap.get('contactId');
            if(Schema.sObjectType.sigmaerpdev2__Service_Resource__c.fields.sigmaerpdev2__User__c.isAccessible()){
                serviceResource = [select Name, sigmaerpdev2__User__c from sigmaerpdev2__Service_Resource__c where Id =:contactId];
                system.debug('serviceResource - '+serviceResource);
            }
            else{
                system.debug('Has no Access on ServiceResource\'s User Field');
            }
            //--get WO id
            Id workOrderId = (Id)slotDetailsMap.get('WOId');
            
            ///Adding reassign concept -- START --added on 8/16/2018
            //Query WOA record based on the current WO Id, if any exists delete it and assign to the the curent WO to new Agent creating WOA record
            if(Schema.sObjectType.sigmaerpdev2__Work_Order_Assignment__c.isDeletable()){
                for(sigmaerpdev2__Work_Order_Assignment__c previousWOA : [SELECT Id, sigmaerpdev2__Technician__c FROM sigmaerpdev2__Work_Order_Assignment__c WHERE sigmaerpdev2__Work_Order__c=:workOrderId LIMIT 1]){
                    delete previousWOA;
                }
            } 
            ///Adding reassign concept -- END --added on 8/16/2018            
            
            sigmaerpdev2__Work_Order__c workOrder = new sigmaerpdev2__Work_Order__c();
            workOrder.Id = workOrderId;
            if(Schema.sObjectType.sigmaerpdev2__Work_Order__c.fields.sigmaerpdev2__AssignTo__c.isUpdateable()){
                workOrder.sigmaerpdev2__AssignTo__c = serviceResource.User__c;
            }
            else{
                system.debug('Has no access to udpate WorkOrder\'s AssignTo field');
            }
            if(Schema.sObjectType.sigmaerpdev2__Work_Order__c.fields.sigmaerpdev2__Status__c.isUpdateable()){
                system.debug('workOrder.sigmaerpdev2__Status__c>>>>>>>'+workOrder.sigmaerpdev2__Status__c);
                workOrder.sigmaerpdev2__Status__c = 'Assigned';
            
                Work_Order__c wo;
                wo=[select id,Name,Account__c,Account__r.Customer_Type__c,Customer_Availability_Date__c,sigmaerpdev2__Break_time_In_Minutes__c,Another_Visit_Needed__c,Paid_Amount__c,sigmaerpdev2__Is_Payment_Made__c,sigmaerpdev2__Next_Visit_Date_Time__c from Work_Order__c where Id =: workOrderId];
                system.debug('wo>>>>>>>'+wo);
                if(wo.Another_Visit_Needed__c==true){
                    wo.Another_Visit_Needed__c=false;
                    wo.sigmaerpdev2__Reason_for_another_Visit__c='';
                    wo.Paid_Amount__c=0;
                    wo.sigmaerpdev2__Break_time_In_Minutes__c=null;
                    wo.sigmaerpdev2__Next_Visit_Date_Time__c=null;
                    wo.sigmaerpdev2__Is_Payment_Made__c=false;
                }
                update wo;
                   
                list<sigmaerpdev2__Work_Oder_Lines__c> workordernewline=new  list<sigmaerpdev2__Work_Oder_Lines__c>();
                  List<sigmaerpdev2__Work_Oder_Lines__c> workOrderLines = [SELECT Id, Name, sigmaerpdev2__Product__c,sigmaerpdev2__Quote__c, sigmaerpdev2__Used1__c,sigmaerpdev2__Quantity__c, sigmaerpdev2__Work_Order_Line_Item_Number__c FROM sigmaerpdev2__Work_Oder_Lines__c where sigmaerpdev2__Work_Order__c =:wo.id];
                for(sigmaerpdev2__Work_Oder_Lines__c word:workOrderLines){
                    if(word.sigmaerpdev2__Used1__c==true||word.Quote__c==true){
                    word.sigmaerpdev2__Used1__c=false;
                    word.Quote__c=false;  
                        workordernewline.add(word);
               }
                    
                }
                
                update workordernewline;

              Service_Appointments__c sa=new Service_Appointments__c();
                sa.Work_Order__c=workOrder.id;
                sa.Preferred_Service_Date_Time__c=wo.Customer_Availability_Date__c;
                sa.AssignTo__c=serviceResource.User__c;
                sa.Work_Order_Status__c=workOrder.Status__c;
                insert sa;
                
                Site_Visits__c sv=new Site_Visits__c();
                sv.Work_Order__c=workOrder.id;
                sv.Service_Appointments__c=sa.id;
                sv.Preferred_Service_Date_Time__c=wo.Customer_Availability_Date__c;
                    insert sv;
                  
                    
               
                
                
            }
            else{
                system.debug('Has no access to udpate WorkOrder\'s Status field');
            }
            if(Schema.sObjectType.sigmaerpdev2__Work_Order__c.isUpdateable()){
                update workOrder;
            }
            sigmaerpdev2__Work_Order__c workorderDetailsListC =new sigmaerpdev2__Work_Order__c();
            if(Schema.sObjectType.sigmaerpdev2__Work_Order__c.fields.sigmaerpdev2__Customer_Availability_Date__c.isAccessible() && Schema.sObjectType.sigmaerpdev2__Work_Order__c.fields.sigmaerpdev2__Territory__c.isAccessible()){
                workorderDetailsListC = [Select id,sigmaerpdev2__Customer_Availability_Date__c,sigmaerpdev2__Territory__c   from sigmaerpdev2__Work_Order__c where id =:workOrderId limit 1];
                
            }
            else{
                system.debug('Has no Access on WorkOrder\'s Fields');
            }
            DateTime dT = workorderDetailsListC.sigmaerpdev2__Customer_Availability_Date__c;
            system.debug('dT - '+dT);
            sigmaerpdev2__Work_Order_Assignment__c WOARecord = new sigmaerpdev2__Work_Order_Assignment__c();
            
            // WorkOrderAssignment Fields that will be accessed.
            String [] woaFields = new String [] {'sigmaerpdev2__Work_Order__c','sigmaerpdev2__Technician__c','sigmaerpdev2__Start_Time__c','sigmaerpdev2__Work_Order_Duration__c','sigmaerpdev2__Territory__c','sigmaerpdev2__Date__c'};
                
                // Obtaining the field name/token map for the WorkOrderAssignment object
                Map<String,Schema.SObjectField> woaMap = Schema.SObjectType.sigmaerpdev2__Work_Order_Assignment__c.fields.getMap();
            for (String fieldToCheck : woaFields) {
                // Check if the user has create access on the each field
                if (!woaMap.get(fieldToCheck).getDescribe().isCreateable()) {
                    system.debug('Has no create Access on WorkOrderAssignment Fields');
                    return;
                }
            }
            WOARecord.sigmaerpdev2__Technician__c = serviceResource.Id;
            WOARecord.sigmaerpdev2__Work_Order__c = workOrderId;
            WOARecord.sigmaerpdev2__Work_Order_Duration__c = (((Decimal)slotDetailsMap.get('Duration'))*eachSlotDurationDecimal);
            WOARecord.sigmaerpdev2__Territory__c=workorderDetailsListC.sigmaerpdev2__Territory__c;
            WOARecord.sigmaerpdev2__Date__c= date.newinstance(dT.year(),dT.month(), dT.day());
            String slotString = (String)slotDetailsMap.get('slots');
            system.debug('slotString - '+slotString);
            String[] slotStringArray = slotString.split(',');
            system.debug('slotStringArray - '+slotStringArray[1]);
            Decimal slotstartTime = ((Decimal.valueOf(slotIndexHeaders[Integer.valueOf(slotStringArray[1])])))+0.0;
            //String[] splitStartTimeDecimalString = String.valueOf(slotstartTime).split('\\.');
            Time slotstartTimeVal = Time.newInstance(0,0,0,0);
            slotstartTimeVal = slotstartTimeVal.addMinutes(Integer.valueOf(slotstartTime*60));
            system.debug('slotstartTimeVal'+slotstartTimeVal);
            WOARecord.sigmaerpdev2__Start_Time__c = slotstartTimeVal;
            insert WOARecord;
            
        }
        
    }
    
    
    //--this will invoke google API to get the distance between any two provided pincode(latitude/longitude)
    @AuraEnabled
    Public static String getDistance(String startPincode,String endPincode)
    {  
        Datetime x1 =  Datetime.now();
        
        Integer m1 = x1.millisecond();
        system.debug('starttimetogetdistance>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+m1);
        system.debug('startPincode'+startPincode+'endPincode'+endPincode);
        //--holds the distance in km
        String distance= '0 km';
        //map<String,Integer> startLatAndLog=getLocation(startPincode);
        //map<String,Integer> endLatAndLog=getLocation(endPincode);
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        req.setMethod('GET');
       
        //--get the google API from custom setting
        sigmaerpdev2__Google_API_Key__c googleAPIKey = sigmaerpdev2__Google_API_Key__c.getInstance();
        system.debug('googleAPIKey>>>>>>'+googleAPIKey);
         system.debug('req???>>>>>>'+req);
        //String url ='https://maps.googleapis.com/maps/api/distancematrix/json?origins='+startLatAndLog.get('Latitude')+','+startLatAndLog.get('Longitude')+'&destinations='+endLatAndLog.get('Latitude')+','+endLatAndLog.get('Longitude');
        String url ='https://maps.googleapis.com/maps/api/distancematrix/json?origins='+startPincode+'&destinations='+endPincode+'&key='+googleAPIKey.sigmaerpdev2__API_Key__c;
        req.setEndPoint(url);
        HTTPResponse resp = http.send(req); 
        
        String response = resp.getBody();
        
        //assuming you've already created your httprequest object
        httpresponse res = http.send(req);
        System.debug('res'+res.getBody());
        System.debug('JSON.deserializeUntyped(res.getBody())'+JSON.deserializeUntyped(res.getBody()));
        
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
                            
                            Map<String,Object> distanceMap = (Map<String,Object>)elementMapData.get('distance');
                            system.debug('distanceMap'+distanceMap.get('text'));
                            system.debug('distanceMap'+distanceMap.get('value'));
                            distance = (String)distanceMap.get('text');
                        }                    
                    }else{
                        Map<String,Object> distanceMap = (Map<String,Object>)elementMapData.get('distance');
                        system.debug('distanceMap'+distanceMap.get('text'));
                        system.debug('distanceMap'+distanceMap.get('value'));
                        distance = (String)distanceMap.get('text');
                    }   
                }
            }
        }   
        system.debug('distance'+distance);
        Datetime x =  Datetime.now();
        
        Integer m = x.millisecond();
        system.debug('endtimetogetdistance>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+m);
        System.debug('distance'+distance);
        return distance;
    }
    
    public class Headers{
        @AuraEnabled
        public List<String> tableHeaders;
        @AuraEnabled
        public List<String> indexHeaders;
        
    }    
}