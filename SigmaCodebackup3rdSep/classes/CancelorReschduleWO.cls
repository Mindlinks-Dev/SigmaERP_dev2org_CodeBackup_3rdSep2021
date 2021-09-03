public class CancelorReschduleWO {
    
     @AuraEnabled
    public static Work_Order__c cancelWO(id recId,string rsn)
    {
    system.debug('recId?'+recId);
        system.debug('reasons>>>'+rsn);
       
        
        Work_Order__c work=[Select Id,Name,Status__c,Cancel_Reason__c from Work_Order__c where Id =: recId];
        if(work.Status__c=='Assigned'){
        work.Status__c='Cancelled';
        work.Cancel_Reason__c= rsn;
        }
       
       
        update work;
        
        
        
        if(work.Status__c=='Cancelled' ){
        Service_Appointments__c[] ser=[Select Id,Name from Service_Appointments__c where Work_Order__c=:recId];
        if (!ser.isEmpty()){
            delete ser;
           
            
        }
            
            Site_Visits__c[] sv=[Select Id,Name from Site_Visits__c where Work_Order__c=:recId];
            system.debug('sv???>>'+sv);
       		 if (!sv.isEmpty()){
				delete sv;        
        	}
   
        
        sigmaerpdev2__Work_Order_Assignment__c previousWOA = [SELECT Id, sigmaerpdev2__Technician__c FROM sigmaerpdev2__Work_Order_Assignment__c WHERE sigmaerpdev2__Work_Order__c=:recId LIMIT 1];
    	 system.debug('previousWOA???>>'+previousWOA);
            delete previousWOA;
        
        }
        
        
        
        return work;
    }
    
    @AuraEnabled
    public static void rescheduleWO(id recId)
    {
    system.debug('recId?'+recId);
        Work_Order__c work=[Select Id,Name,Status__c from Work_Order__c where Id =: recId];
        work.Status__c='Cancelled';
       
        update work;
        
        if(work.Status__c=='Cancelled'){
        Service_Appointments__c[] ser=[Select Id,Name from Service_Appointments__c where Work_Order__c=:recId];
            system.debug('ser>>>'+ser);
            if (!ser.isEmpty()){
            delete ser;
        }
        
            
            
               }
    
    }

}