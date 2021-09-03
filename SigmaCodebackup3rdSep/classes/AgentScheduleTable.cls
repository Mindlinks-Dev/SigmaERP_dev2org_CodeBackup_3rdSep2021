public with sharing class AgentScheduleTable { 
    @AuraEnabled 
    public static List<String> getPicklistTerritories(){
        List<String> pickListValuesList= new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Work_Order_Assignment__c.Territory__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        //To make the picklist values dynamic.
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }   
        System.debug('pickListValuesList'+pickListValuesList);
        return pickListValuesList;
    }
    
    @AuraEnabled
    public static Map<String,List<ScheduleDetails>> getWorkOrderAssignments(String territory, String dateString){
        system.debug('dt - '+dateString);
        system.debug('territory - '+territory);
        
        Date dt = Date.valueOf(dateString);
        system.debug('Date - '+dt);
        Integer i =0;
        
        //Map<String,List<Work_Order_Assignment__c>> techWOA = new Map<String,List<Work_Order_Assignment__c>>();
        Map<String,List<ScheduleDetails>> techDetails = new Map<String,List<ScheduleDetails>>();
        
        // WorkOrderAssignment Fields that will be accessed.
        String [] woaFields = new String [] {'sigmaerpdev2__Work_Order__c','sigmaerpdev2__Technician__c','sigmaerpdev2__Start_Time__c','sigmaerpdev2__Work_Order_Duration__c','sigmaerpdev2__Territory__c','sigmaerpdev2__Date__c'};
            
            // Obtaining the field name/token map for the WorkOrderAssignment object
            Map<String,Schema.SObjectField> woaMap = Schema.SObjectType.Work_Order_Assignment__c.fields.getMap();
        for (String fieldToCheck : woaFields) {
            // Check if the user has create access on the each field
            if (!woaMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on WorkOrderAssignment Fields');
                return null;
            }
        }
        List<Work_Order_Assignment__c> listWOA = [SELECT Id,Work_Order__r.Name,Technician__c,Work_Order__r.FFP_MR_Contact__r.Name,Work_Order__r.Service_Zip_Postal_Code__c,Start_Time__c, Work_Order__c, Work_Order_Duration__c, Territory__c, Date__c FROM Work_Order_Assignment__c where Territory__c=:territory AND Date__c=:dt ORDER BY Start_Time__c ASC];
        system.debug('listWOA - '+listWOA);
        
        if(listWOA==null || listWOA.size()==0){
            system.debug('WOA is NULL');
            return null;
        }
        
        Set<Id> contacts1 = new Set<Id>();
        for(Work_Order_Assignment__c eachWOA : listWOA){
            if(contacts1.contains(eachWOA.Technician__c)==false){
                contacts1.add(eachWOA.Technician__c);
            }
        }
        system.debug('Contacts ID - '+contacts1);
        
        
        // Service Resource Fields that will be accessed.
        String [] serviceResourceFields = new String [] {'Name'};
            
            // Obtaining the field name/token map for the Contact object
            Map<String,Schema.SObjectField> serviceResourceMap = Schema.SObjectType.Service_Resource__c.fields.getMap();
        for (String fieldToCheck : serviceResourceFields) {
            // Check if the user has create access on the each field
            if (!serviceResourceMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on Service Resource Fields');
                return null;
            }
        }
        
        List<Service_Resource__c> contacts = [select Id, Name from Service_Resource__c where Id in :contacts1];
        system.debug('contacts - '+contacts);
        
        
        //Defining a Map with key as Tech's Name and value as his List<ScheduleDetails>
        for(Service_Resource__c eachContact : contacts){
            List<ScheduleDetails> scheduleDetails = new List<ScheduleDetails>();
            
            list<Work_Order_Assignment__c> tempWOA = new list<Work_Order_Assignment__c>();
            
            //Getting all the WOA records of a Contact as per the current iteration.
            for(Work_Order_Assignment__c each : listWOA){
                if(eachContact.Id == each.Technician__c){
                    tempWOA.add(each);
                }
            }
            system.debug('tempWOA - '+tempWOA);
            Integer j =0;
            Integer StartTime = 8;
            
            //creating 13 Schedules for every contact.
            for(i=8;i<=20;i++){
                system.debug('TIME - '+tempWOA[j].Start_Time__c.hour());
                
                //If there is WOA at this hour(StartTime).
                if(tempWOA[j]!=null && tempWOA[j].Start_Time__c.hour()==StartTime){
                    system.debug('LIST WOA not NULL');
                    Work_Order_Assignment__c eachWOA = tempWOA[j];
                    
                    if(eachContact.Id == eachWOA.Technician__c){
                        //Getting the contacts slotBreaks according to the Business Calendar.
                        Map<Integer,String> slotBreaks = getSlotBreakTime(eachContact.Id,eachWOA.Date__c);
                        
                        //Differentiating if the Schedule duration is for 1 hour of more.
                        if(eachWOA.Work_Order_Duration__c>1){
                            Integer k;
                            Decimal duration_start = 1;
                            Decimal duration_end = eachWOA.Work_Order_Duration__c;
                            for(k=0;k<eachWOA.Work_Order_Duration__c;k++){
                                ScheduleDetails tempSchedule = new ScheduleDetails();
                                tempSchedule.techName = eachContact.Name;
                                //tempSchedule.techImageName = eachContact.User__r.Name;
                                tempSchedule.scheduleTime = StartTime;
                                tempSchedule.duration = eachWOA.Work_Order_Duration__c;
                                tempSchedule.available = 'Available';
                                tempSchedule.workOrderName = eachWOA.Work_Order__r.Name;
                                tempSchedule.workOrderId = eachWOA.Work_Order__c;
                                tempSchedule.workOrderContact = eachWOA.Work_Order__r.FFP_MR_Contact__r.Name;
                                tempSchedule.workOrderZip = eachWOA.Work_Order__r.Service_Zip_Postal_Code__c;
                                
                                //Differentating whether the slot belongs to either the 1st hour of the duration or the mid or the Last hour.
                                if(duration_start == 1 && duration_end > 1){
                                    tempSchedule.start=true;
                                    tempSchedule.mid=false;
                                    tempSchedule.stop=false;
                                    duration_start++;
                                }
                                else if(duration_start == duration_end){
                                    tempSchedule.start=false;
                                    tempSchedule.mid=false;
                                    tempSchedule.stop=true;
                                }
                                else{
                                    tempSchedule.start=false;
                                    tempSchedule.mid=true;
                                    tempSchedule.stop=false;
                                    duration_start++;
                                }
                                scheduleDetails.add(tempSchedule);
                                StartTime++;
                            }
                            StartTime--;
                            i=i+k-1;
                        }
                        else{
                            ScheduleDetails tempSchedule = new ScheduleDetails();
                            tempSchedule.techName = eachContact.Name;
                            tempSchedule.scheduleTime = StartTime;
                            tempSchedule.available = 'Available';
                            tempSchedule.duration = eachWOA.Work_Order_Duration__c;
                            tempSchedule.start=false;
                            tempSchedule.mid=false;
                            tempSchedule.stop=false;
                            tempSchedule.workOrderId = eachWOA.Work_Order__c;
                            tempSchedule.workOrderName = eachWOA.Work_Order__r.Name;
                            tempSchedule.workOrderContact = eachWOA.Work_Order__r.FFP_MR_Contact__r.Name;
                            tempSchedule.workOrderZip = eachWOA.Work_Order__r.Service_Zip_Postal_Code__c;
                            scheduleDetails.add(tempSchedule);
                        }
                        system.debug('schedule Details - '+scheduleDetails);
                        
                    }
                    StartTime++;
                    if(j<tempWOA.size()-1){
                        j++;  
                    }
                }
                else{
                    system.debug('LIST WOA is NULL');
                    
                    //Getting the contacts slotBreaks according to the Business Calendar.
                    Map<Integer,String> slotBreaks = getSlotBreakTime(eachContact.Id,dt);
                    ScheduleDetails tempSchedule = new ScheduleDetails();
                    tempSchedule.techName = eachContact.Name;
                    
                    //Defining Slots as working or Not Working based on the slotBreaks.
                    for(Integer key : slotBreaks.keySet()){
                        if(key== StartTime){
                            tempSchedule.available = 'NW';
                            break;
                        }
                        else{
                            tempSchedule.available = 'Available';
                        }
                        
                    }
                    tempSchedule.start=false;
                    tempSchedule.mid=false;
                    tempSchedule.stop=false;
                    tempSchedule.scheduleTime = StartTime;
                    tempSchedule.duration = 0;
                    scheduleDetails.add(tempSchedule);
                    //tempList.add(eachWOA);
                    StartTime++;
                }
                
                system.debug('Start Time - '+StartTime);
            }
            if(scheduleDetails.size()!=0 && scheduleDetails !=null){
                techDetails.put(eachContact.Name,scheduleDetails);
            }
        }
        
        system.debug('TechDetails - '+techDetails);
        return techDetails;
    }
    @AuraEnabled
    public static Map<Integer,String> getSlotBreakTime(Id TechnicianId,Date selecteddate){
        system.debug('selecteddate - '+selecteddate);
        Map<Integer,String> allSlotvalues=new Map<Integer,String>();
        //--get the preferred day
        Datetime dt1 = DateTime.newInstance(selecteddate, Time.newInstance(0, 0, 0, 0));
        String dateStr = dt1.format('EEEE');
        //--query the business calendar related to the contact
        Service_Resource__c con = new Service_Resource__c();
        if (Schema.sObjectType.Service_Resource__c.fields.Business_Calendar__c.isAccessible()){ 
            con=[SELECT Id, Business_Calendar__c FROM Service_Resource__c WHERE id=:TechnicianId LIMIT 1];
        }
        else{
            system.debug('No Access on COntact\'s BusinessCalendar Field');
        }
        
        // BusinessDaySlot Fields that will be accessed.
        String [] businessDaySloyFields = new String [] {'sigmaerpdev2__Is_Lunch__c','sigmaerpdev2__Is_Available__c','sigmaerpdev2__Start_Time__c','sigmaerpdev2__End_Time__c','sigmaerpdev2__Business_Day__c'};
            
            // Obtaining the field name/token map for the BusinessDaySlot object
            Map<String,Schema.SObjectField> businessDaySlotMap = Schema.SObjectType.Business_Day_Slot__c.fields.getMap();
        for (String fieldToCheck : businessDaySloyFields) {
            // Check if the user has create access on the each field
            if (!businessDaySlotMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on Business Day Slot Fields');
                return null;
            }
        }
        //--get the business slot based on the business calendar
        List<Business_Day_Slot__c> slotDetails = [SELECT Id, Is_Lunch__c, Is_Available__c, Start_Time__c, End_Time__c, Business_Day__c,Business_Day__r.Name,Business_Day__r.Business_Calendar__c,Business_Day__r.End_Time__c,Business_Day__r.Start_Time__c FROM Business_Day_Slot__c WHERE Business_Day__r.Name =:dateStr AND Business_Day__r.Business_Calendar__c=:con.Business_Calendar__c ORDER BY Start_Time__c];
        system.debug('slotDetails'+slotDetails);
        
        //--standard day start time
        Integer slotIndex = 8;
        
        if(slotDetails!=null && slotDetails.size()>0){
            //hold the business day start time hour
            Integer slotHour = slotDetails[0].Business_Day__r.Start_Time__c.hour();
            
            //--based on the technician business day start time set the Map with unavailable time
            while(slotIndex < slotHour){
                allSlotvalues.put(slotIndex,'NW');
                slotIndex = slotIndex+1;
            }
            
            //--standard day End time
            slotIndex = 20;
            
            
            //hold the business day End time hour
            Integer slotEndHour = slotDetails[0].Business_Day__r.End_Time__c.hour();
            
            //--based on the technician business day End time set the Map with unavailable time
            while(slotIndex > slotEndHour){
                allSlotvalues.put(slotIndex,'NW');
                slotIndex = slotIndex-1;
            }
            
            Set<Integer> slotList = new Set<Integer>();
            
            //--iterate through the list of slot to get the unavailable/break time for a technician
            for(Business_Day_Slot__c eachSlot : slotDetails){
                
                Integer eachSlotStartHour = eachSlot.Start_Time__c.hour();
                Integer eachSlotEndHour = eachSlot.End_Time__c.hour();
                while(eachSlotStartHour < eachSlotEndHour){
                    slotList.add(eachSlotStartHour);
                    eachSlotStartHour = eachSlotStartHour+1;
                }
                system.debug('slotList----------->'+slotList);
                
                if(eachSlot.Is_Available__c == false){
                    
                    
                    Integer breakSlotStartHour = eachSlot.Start_Time__c.hour();
                    Integer breakSlotEndHour = eachSlot.End_Time__c.hour();
                    system.debug('breakSlotStartHour'+breakSlotStartHour +'>>>breakSlotEndHour>'+breakSlotEndHour);
                    
                    //--in case 1 hour break
                    if(breakSlotEndHour - breakSlotStartHour == 1) {
                        if(eachSlot.Is_Lunch__c == true){
                            allSlotvalues.put(breakSlotStartHour,'NW');
                        }else{
                            allSlotvalues.put(breakSlotStartHour,'NW');
                        }
                        
                    }
                    //-- incase of more than 1 hour break
                    else if(breakSlotEndHour - breakSlotStartHour > 1){
                        Integer breakHour = breakSlotEndHour - breakSlotStartHour;
                        while(breakHour > 0){
                            if(eachSlot.Is_Lunch__c == true){
                                allSlotvalues.put(breakSlotStartHour + breakHour -1,'NW');
                            }else{
                                allSlotvalues.put(breakSlotStartHour + breakHour -1,'NW');
                            }
                            breakHour = breakHour-1;
                        }
                    }                                        
                }               
                
            }
            //--add NW to the slot which is not having a Business day slot created with in Business day hour
            for(Integer i=8 ;i<=20;i++){
                if(!slotList.contains(i)){
                    allSlotvalues.put(i, 'NW');
                }
            }
        }
        System.debug('allSlotvalues - '+allSlotvalues);
        return allSlotvalues;
    }
    
    public class ScheduleDetails{
        @AuraEnabled
        public String techName;
        @AuraEnabled
        public String techImageName;
        @AuraEnabled
        public Integer scheduleTime;
        @AuraEnabled 
        public Double duration;
        @AuraEnabled 
        public String available;
        @AuraEnabled 
        public Boolean start;
        @AuraEnabled 
        public Boolean mid;
        @AuraEnabled 
        public Boolean stop;
        @AuraEnabled
        public Id workOrderId;
        @AuraEnabled
        public String workOrderName;
        @AuraEnabled
        public String workOrderContact;
        @AuraEnabled
        public String workOrderZip;
        @AuraEnabled
        public Integer workOrderCount;
    }
}