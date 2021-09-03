public class AppointmentController {

    @AuraEnabled//Annotation to use method in lightning component
    public static ApptDataTableWrapper getAppDetails(Integer pageNumber, Integer pageSize) {//Fetch data
        Date Tommorowdate = Date.today().addDays(1);
        System.debug('Tommorowdate>>'+Tommorowdate);
        Date Enddate = Date.today().addDays(7);
        System.debug('Enddate>>'+Enddate);
        
        Integer offset = (pageNumber - 1) * pageSize;
         
        //Total Records
        Integer totalRecords = [SELECT COUNT() FROM sigmaerpdev2__Appointment__c];
        Integer recordEnd = pageSize * pageNumber;
 
        ApptDataTableWrapper objDT =  new ApptDataTableWrapper();  
        objDT.pageSize = pageSize;
        objDT.pageNumber = pageNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        objDT.appointmentList = [SELECT sigmaerpdev2__AppointmentDate__c,sigmaerpdev2__period_of_time__c,sigmaerpdev2__Time__c,
                sigmaerpdev2__Duration__c,sigmaerpdev2__Duration_Interval__c FROM sigmaerpdev2__Appointment__c 
                where sigmaerpdev2__AppointmentDate__c >=: Tommorowdate and sigmaerpdev2__AppointmentDate__c <=: Enddate order by sigmaerpdev2__AppointmentDate__c asc LIMIT :pageSize OFFSET :offset];
        return objDT;
         
    }
    public static void InsertBookAndCustomer(){
        
    }
    public class ApptDataTableWrapper {
        @AuraEnabled
        public Integer pageSize {get;set;}
        @AuraEnabled
        public Integer pageNumber {get;set;}
        @AuraEnabled
        public Integer totalRecords {get;set;}
        @AuraEnabled
        public Integer recordStart {get;set;}
        @AuraEnabled
        public Integer recordEnd {get;set;}
        @AuraEnabled
        public List<sigmaerpdev2__Appointment__c> appointmentList {get;set;}
    }
}