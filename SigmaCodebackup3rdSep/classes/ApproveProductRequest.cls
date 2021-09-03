public with sharing class ApproveProductRequest { 
    @AuraEnabled 
    public static String approveProductReq(Id productRequestId){
        //Get the ProductRequest.
        system.debug('Product Request Id - '+productRequestId);
        
        // ProductRequest Fields that will be accessed.
        String [] productRequestFields = new String [] {'sigmaerpdev2__Request_To_Location__c','sigmaerpdev2__Requested_From_Location__c','sigmaerpdev2__Status__c'};
            
            // Obtaining the field name/token map for the ProductRequest object
            Map<String,Schema.SObjectField> productRequestMap = Schema.SObjectType.Product_Request__c.fields.getMap();
        for (String fieldToCheck : productRequestFields) {
            // Check if the user has create access on the each field
            if (!productRequestMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on ProductRequest Fields');
                return null;
            }
        }
        
        Product_Request__c productRequest = [SELECT Id, sigmaerpdev2__Request_To_Location__c, sigmaerpdev2__Requested_From_Location__c, Status__c FROM Product_Request__c where Id =:productRequestId limit 1];
        system.debug('Product Request  - '+productRequest);
        
        //Approve it if its Status is not equal to Approved.
        if(productRequest.Status__c == 'Approved'){
            return 'failure';
        }
         else if(productRequest.Status__c == 'Draft'){
            
                return 'failure1';
            }
        
        else{
            if (Schema.sObjectType.Product_Request__c.fields.Status__c.isUpdateable()){
            
                productRequest.Status__c = 'Approved';
                update productRequest;
            }
            else{
                system.debug('No Access on ProductRequest\'s status field');
                return null;
            }
            system.debug('Success');
            return 'success';
        }
    }
}