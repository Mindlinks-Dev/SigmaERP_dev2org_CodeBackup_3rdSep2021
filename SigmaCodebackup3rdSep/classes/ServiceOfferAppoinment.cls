public with sharing class ServiceOfferAppoinment
{
     public static String addressBreakLenght = '';

    @AuraEnabled
    public static workOrderWrapper fetchOfferAppointment(Id recId)
    {
        /*Map<string,OfferAppointmentDefaultRecord__c> recordCount = OfferAppointmentDefaultRecord__c.getAll(); 
        OfferAppointmentDefaultRecord__c showRecord=recordCount.values();*/
        Work_Order__c work=[Select Id,Name,sigmaerpdev2__Is_Payment_Made__c,Account__c,sigmaerpdev2__Account__r.Name,Account__r.Customer_Type__c,Tax__c ,sigmaerpdev2__Work_Type__r.Name,Service_Street__c,
                       sigmaerpdev2__Account__r.AccountNumber,sigmaerpdev2__Work_Type__c,Service_Warrenty_End_date__c,sigmaerpdev2__TotalAmount__c,sigmaerpdev2__Paid_Amount__c,Service_City__c,Service_Country__c,
                       sigmaerpdev2__Work_Type__r.sigmaerpdev2__Service_Charge__c ,Sigma_orders__r.Total_Price__c,sigmaerpdev2__FFP_MR_Contact__c,Status__c,Service_State_Province__c,Service_Zip_Postal_Code__c,
                       sigmaerpdev2__Due_Amount__c,Net_Amount__c FROM sigmaerpdev2__Work_Order__c where Id =: recId LIMIT 1 For update];
        system.debug('work'+work);
        workOrderWrapper workWrap=new workOrderWrapper();
        workWrap.workOrderDetail=work;
      //  workWrap.defaultview= Integer.valueOf(showRecord.Initial_Record_Display__c);
        return workWrap;
    }
    
     @AuraEnabled
    public static List<Date> Getdates(Date startdate,Date enddate)
    {
         system.debug('startdate>>'+startdate);
         system.debug('enddate>>>>'+enddate);
        Date d1 = startdate;
		Date d2 = enddate;
		List<date> datesmonthYearSet = new List<date>();
        Integer noOfDays = startdate.daysBetween(enddate);
		system.debug('noOfDays=='+noOfDays);
		
        Integer i =0 ;
		while(i <= noOfDays)
	{
  		 date indDate = startdate.addDays(i);
   		 datesmonthYearSet.add(indDate);
   		i++;    
	}
system.debug('datesmonthYearSet=='+datesmonthYearSet);
return datesmonthYearSet;
   	
    }
    
    @AuraEnabled
    public static void SelectedDate(Id rec,Date SelDate)
    {
        system.debug('rec>>'+rec);
         system.debug('seldate>>>>'+seldate);
        
        Work_Order__c work=[Select Id,Name,Customer_Availability_Date__c from Work_Order__c where Id =: rec];
       
        work.Customer_Availability_Date__c=seldate;
         system.debug('work.Customer_Availability_Date__c>>'+work.Customer_Availability_Date__c);
            
        update work;
        
    
    }
    
    
    @AuraEnabled
    public static responseWrap fetchWorkOrderdDetails(Id recId)
    {
        responseWrap responseError = new responseWrap();
        Map<Id,string> wordOrderIds = new Map<Id,string>();
        list<Work_Order__c> listWO = [select id,Status__c from Work_Order__c where id=:recId];
        system.debug('listWO'+listWO);
        for(Work_Order__c woList : listWO){
            wordOrderIds.put(woList.id,woList.Status__c);
        }
        List<serviceAppointment> spList=[select id,ParentRecordId from serviceAppointment where ParentRecordId=:wordOrderIds.keyset()]; 
        system.debug('spList'+spList);
        for(serviceAppointment sp :spList){
            if(sp.ParentRecordId !=null && wordOrderIds.keyset().contains(sp.ParentRecordId)){
                responseError.status='Success';               
            }else{
                 responseError.status='Failure';
            }
        } 
        
        //if(wordOrderIds.keySet().size() > 0 && wordOrderIds.keySet() != null)
            return responseError; 
    }
    
    @AuraEnabled
    public static ServiceAppointment fetchServiceAppointment(Id recordId){
        ServiceAppointment sa =  [SELECT id,WorkTypeId,WorkType.name,Street,city,postalCode,country,state,EarliestStartTime,DueDate,ParentRecordId,ParentRecord.name,Status from ServiceAppointment Where Id =:recordId LIMIT 1 For update];
        return sa;
    }    
    
     public class responseWrap
    {
        @AuraEnabled public String type{get;set;}
        @AuraEnabled public String errorCode{get;set;}
        @AuraEnabled public String status{get;set;}
        @AuraEnabled public String serviceAppointmentId{get;set;}
        @AuraEnabled public String description{get;set;}
     
        
    }
    
   
    public class workOrderWrapper
    {
        @AuraEnabled public Work_Order__c workOrderDetail{get;set;}
        @AuraEnabled public Integer defaultview{get;set;}
        
        
    }
 
    
}