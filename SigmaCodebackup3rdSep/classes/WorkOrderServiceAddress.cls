public class WorkOrderServiceAddress {
    @AuraEnabled
    public static Address getWorkOrderServiceAddress(String recordId){
        Address serviceAddress = new Address();
        try{
            System.debug('Record ID - '+recordId);
            
            // WorkOrder Fields that will be accessed.
            String [] workOrderFields = new String [] {'sigmaerpdev2__Service_Street__c','sigmaerpdev2__Service_Zip_Postal_Code__c','sigmaerpdev2__Service_State_Province__c','sigmaerpdev2__Service_City__c'};
                
                // Obtaining the field name/token map for the WorkOrder object
                Map<String,Schema.SObjectField> workOrderMap = Schema.SObjectType.Work_Order__c.fields.getMap();
            for (String fieldToCheck : workOrderFields) {
                // Check if the user has create access on the each field
                if (!workOrderMap.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on WorkOrder Fields');
                    return null;
                }
            }
            Work_Order__c workOrder = [SELECT Id, Service_Street__c, Service_City__c ,Service_Zip_Postal_Code__c, Service_State_Province__c FROM Work_Order__c where Id =:recordId];
            System.debug('Work Order - '+workOrder);

            if(workOrder.Service_Street__c!=null && workOrder.Service_Street__c.length()>0){
                String temp = workOrder.Service_Street__c;
                temp = temp.trim();
                temp = temp.replaceAll('\\s+', '+');
                serviceAddress.serviceStreet =temp;
                system.debug('Service Street - '+serviceAddress.serviceStreet);
            }
            if(workOrder.Service_City__c!=null && workOrder.Service_City__c.length()>0){
                String temp = workOrder.Service_City__c;
                temp = temp.trim();
                temp = temp.replaceAll('\\s+', '+');
                serviceAddress.serviceCity =temp;
                system.debug('Service City - '+serviceAddress.serviceCity);
            }
            if(workOrder.Service_State_Province__c!=null && workOrder.Service_State_Province__c.length()>0){
                String temp = workOrder.Service_State_Province__c;
                temp = temp.trim();
                temp = temp.replaceAll('\\s+', '+');
                serviceAddress.serviceState =temp;
                system.debug('Service State - '+serviceAddress.serviceState);
            }
            if(workOrder.Service_Zip_Postal_Code__c!=null && workOrder.Service_Zip_Postal_Code__c.length()>0){
                String temp = workOrder.Service_Zip_Postal_Code__c;
                temp = temp.trim();
                temp = temp.replaceAll('\\s+', '+');
                serviceAddress.servicePincode =temp;
                system.debug('Service Pincode - '+serviceAddress.servicePincode);
            }
        }
        catch(Exception e){
            System.debug('Exception Occurred - '+e);
        }
        return serviceAddress;
    }
    
    public class Address{
        @AuraEnabled
        public String serviceState;
        @AuraEnabled
        public String serviceStreet;
        @AuraEnabled
        public String serviceCity;
        @AuraEnabled
        public String servicePincode;
    }
}