public with sharing class WorkOrderReject {
    
/*****************************************************************************************************************************/
  @AuraEnabled
    public static string WorkOrderRejectNew(string workOrderId){
        string result = 'success';
        Work_Order__c wo ;
        Service_Appointments__c sa=new Service_Appointments__c();
        System.debug('WorkOrderId-->'+workOrderId);
          
        
        if (Schema.sObjectType.Work_Order__c.isAccessible()) {
            wo= [SELECT Id , Status__c,Send_Back_Reason__c ,OwnerId FROM Work_Order__c
                      WHERE Id =:workOrderId limit 1];
            sa= [SELECT Id ,Work_Order_Status__c FROM Service_Appointments__c
                      WHERE Work_Order__r.Id =:workOrderId order by CreatedDate desc limit 1];
          
        }else{
            System.debug('Insufficient access');
        }
        if(wo!= null && wo.Send_Back_Reason__c== null){
            System.debug('Send_Back_Reason__c'+wo.Send_Back_Reason__c);
            return 'Send_Back_Reason__c Field Not Updated';
        }
        if(wo != null){ 
            if(!Work_Order__c.sObjectType.getDescribe().isUpdateable()){
                System.debug('Insufficient access to Update Event Record access');
            }else{
                if (Schema.sObjectType.Work_Order__c.isAccessible()) {
                    if(Schema.sObjectType.Work_Order__c.fields.Status__c.isUpdateable()){
                        wo.Status__c= 'Rejected';
                        sa.Work_Order_Status__c='Rejected';
                        
                    }
                    update sa;
                        
                    if(Schema.sObjectType.Work_Order__c.fields.AssignTo__c.isUpdateable()){
                        wo.AssignTo__c = null;
                    }
                    if (Schema.sObjectType.Work_Order__c.isUpdateable()) {
                       //update wo;
                      
                        performDML(JSON.serialize(wo), 'True');
                      //  performDML(JSON.serialize(sa), 'True');
                    }else{
                        System.debug('Insufficient access to Update Work_Order__c Record access');
                    }
                }else{
                    System.debug('Insufficient access to Access Work_Order__c Record access');
                }
            }
        }else{
             System.debug('Insufficient access to Access Work_Order__c Record access');
        }           
        
        return result;        
    }

/******************************************************************************************************************************/    
    @AuraEnabled
    public static String WorkOrderAccept(string workOrderId){
        string result = 'success';

        Work_Order__c wo ;
       Service_Appointments__c sa=new Service_Appointments__c();
        

        system.debug('WorkorderId '+workOrderId);
        Savepoint sp = Database.setSavepoint();  
        try{
        
        if (Schema.sObjectType.Work_Order__c.isAccessible()) {
            wo= [SELECT Id,sigmaerpdev2__Customer_Availability_Date__c FROM Work_Order__c WHERE Id =:workOrderId limit 1];
             sa= [SELECT Id ,Work_Order_Status__c FROM Service_Appointments__c
                      WHERE Work_Order__r.Id =:workOrderId order by CreatedDate desc limit 1];
        }else{
            
            System.debug('Insufficient access');
        }
            
          
        if(wo != null){ 
            if(!Work_Order__c.sObjectType.getDescribe().isUpdateable()){
                System.debug('Insufficient access to Update Event Record access');
            }else{
                if (Schema.sObjectType.Work_Order__c.isAccessible()) {
				if(wo.sigmaerpdev2__Customer_Availability_Date__c< system.Now()){
				system.debug('close');
				return null;
                }
                    
                 else{
				 if (Schema.sObjectType.Work_Order__c.fields.Status__c.isUpdateable()) {
                        wo.Status__c= 'Accepted';
                     sa.Work_Order_Status__c='Accepted';
                     
                    }
                     update sa;
                    if(Schema.sObjectType.Work_Order__c.isUpdateable()){
                        //update wo;
                        system.debug('updated successfully');
                        
                        performDML(JSON.serialize(wo), 'True');
                        //performDML(JSON.serialize(sa), 'True');
                       // 
                    }else{
                        System.debug('Insufficient access to Update Work_Order__c Record access');
                    }
                }
                }else{
                    System.debug('Insufficient access to access Work_Order__c Record access');
                }
            }
        }
        
          else{
            System.debug('Insufficient access to Access Work_Order__c Record access');
        }
       
        }catch(Exception e){
            system.debug('exception' +e);
            Database.rollback(sp);
        }
     
        
        return result;
          
    }
    
    @future
    public static void performDML(String obj, String isUpdate) {
        if(isUpdate == 'true') {
            update (Work_Order__c) JSON.deserialize(obj, Work_Order__c.class); 
            
        } 
             
    }
    
     @AuraEnabled
    public static void SendBackreason(string rsn,string workOrderId){
        system.debug('rsn>>'+rsn);
         system.debug('workOrderId>>'+workOrderId);
         Work_Order__c wo ;
        if (Schema.sObjectType.Work_Order__c.isAccessible()) {
            wo= [SELECT Id , Status__c,Send_Back_Reason__c ,OwnerId FROM Work_Order__c
                      WHERE Id =:workOrderId limit 1];
        wo.Send_Back_Reason__c=rsn;
        update wo;
         system.debug('wo');
        }else{
            System.debug('Insufficient access');
        }
    }  
    
     @AuraEnabled
    public static Work_Order__c GetresonPick(string workOrderId){
       
         system.debug('workOrderId>>'+workOrderId);
         Work_Order__c wo ;
        
            wo= [SELECT Id , Status__c,Send_Back_Reason__c ,OwnerId FROM Work_Order__c
                      WHERE Id =:workOrderId limit 1];
        
      return wo; 
    }
    
}