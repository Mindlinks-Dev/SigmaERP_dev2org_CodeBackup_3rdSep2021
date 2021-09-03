public with sharing class CreateProductTransfer {  
    @AuraEnabled
    public static String checkProductReqStatus(Id recordId){
        
        // ProductRequest Fields that will be accessed.
        String [] productRequestFields = new String [] {'sigmaerpdev2__Requested_From_Location__c','sigmaerpdev2__Request_To_Location__c','sigmaerpdev2__Status__c'};
         
        Product_Request__c productRequest;
        
         if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Request__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Request__c',new set<String>{'Id','sigmaerpdev2__Requested_From_Location__c','sigmaerpdev2__Request_To_Location__c','sigmaerpdev2__Status__c'}))
     {
            // Obtaining the field name/token map for the ProductRequest object
            Map<String,Schema.SObjectField> productRequestMap = Schema.SObjectType.Product_Request__c.fields.getMap();
        for (String fieldToCheck : productRequestFields) {
            // Check if the user has create access on the each field
            if (!productRequestMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on ProductRequest Fields');
                return null;
            }
        }
        productRequest = [SELECT Id, sigmaerpdev2__Requested_From_Location__c, sigmaerpdev2__Request_To_Location__c, Status__c FROM Product_Request__c where Id =:recordId limit 1];
     }   
        if(productRequest.Status__c == 'Approved'){
            return 'success';
        }
        else{
            return 'failure';
        }
     
    }
    
    @AuraEnabled
    public static String createProductTrans(Id recordId){
    
     List<Product_Request_Line_Item__c> listPRLI = new List<Product_Request_Line_Item__c>();
        
     
        /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Request__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Request_Line_Item__c') 
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_transfer__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Request__c',new set<String>{'Id','sigmaerpdev2__Requested_From_Location__c','sigmaerpdev2__Request_To_Location__c','sigmaerpdev2__Status__c','sigmaerpdev2__Product_Transfer__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Request_Line_Item__c',new set<String>{'Id','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product_Request__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_transfer__c',new set<String>{'Id','Name','sigmaerpdev2__From_Location__c','sigmaerpdev2__To_Location__c','sigmaerpdev2__Transfer_Status__c','sigmaerpdev2__Product_Request__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_transfer__c',new set<String>{'sigmaerpdev2__From_Location__c','sigmaerpdev2__To_Location__c','sigmaerpdev2__Product_Request__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Request__c',new set<String>{'sigmaerpdev2__Requested_From_Location__c','sigmaerpdev2__Request_To_Location__c','sigmaerpdev2__Product_Transfer__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Request_Line_Item__c',new set<String>{'sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product_Transfer__c'}))
     {*/
        // ProductRequest Fields that will be accessed.
        String [] productRequestFields = new String [] {'sigmaerpdev2__Requested_From_Location__c','sigmaerpdev2__Request_To_Location__c','sigmaerpdev2__Status__c','sigmaerpdev2__Product_Transfer__c'};
            
            // Obtaining the field name/token map for the ProductRequest object
            Map<String,Schema.SObjectField> productRequestMap = Schema.SObjectType.Product_Request__c.fields.getMap();
        for (String fieldToCheck : productRequestFields) {
            // Check if the user has create access on the each field
            if (!productRequestMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on ProductRequest Fields');
                return null;
            }
        }
        Product_Request__c productRequest = [SELECT Id,sigmaerpdev2__From_Bin__c,sigmaerpdev2__To_Bin__c,sigmaerpdev2__Requested_From_Location__c, sigmaerpdev2__Request_To_Location__c,Product_Transfer__c , Status__c FROM Product_Request__c where Id =:recordId limit 1];
        system.debug('Product Request - '+productRequest);
        
        //Product Transfer must be created only when the ProductRequest's Status is Approved.
        if(productRequest.Status__c != 'Approved'){
            return 'failure';
        }
        
        // RequestLineItems Fields that will be accessed.
        String [] requestlineitemFields = new String [] {'sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product_Request__c'};
            
            // Obtaining the field name/token map for the sigmaerpdev2__Product_Request_Line_Item__c object
            Map<String,Schema.SObjectField> mPRLI = Schema.SObjectType.Product_Request_Line_Item__c.fields.getMap();
        for (String fieldToCheck : requestlineitemFields) {
            // Check if the user has create access on the each field
            if (!mPRLI.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on ProductRequestLineItem Fields');
                return null;
            }
        }
        List<Product_Request_Line_Item__c> productRequestLineItems = [SELECT Id, Product__c, Product_Request__c, Quantity__c FROM Product_Request_Line_Item__c where Product_Request__c =: recordId];
        system.debug('Product Request Line Items - '+productRequestLineItems);
        
        
        // ProductTransfer Fields that will be accessed.
        String [] productTransferFields = new String [] {'Name','sigmaerpdev2__Request_Location__c','sigmaerpdev2__To_Requested_Location__c','sigmaerpdev2__Transfer_Status__c','sigmaerpdev2__Product_Request__c'};
            
            // Obtaining the field name/token map for the ProductTransfer object
            Map<String,Schema.SObjectField> productTransferMap = Schema.SObjectType.Product_transfer__c.fields.getMap();
        for (String fieldToCheck : productTransferFields) {
            // Check if the user has create access on the each field
            if (!productTransferMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on ProductTransfer Fields');
                return null;
            }
        }
        List<Product_transfer__c> productTransferList = [SELECT Id, Name,sigmaerpdev2__From_Bin__c,sigmaerpdev2__To_Bin__c, sigmaerpdev2__Request_Location__c, sigmaerpdev2__To_Requested_Location__c, Transfer_Status__c, Product_Request__c FROM Product_transfer__c where Product_Request__c =:productRequest.Id];
        
        if(productTransferList!=null && productTransferList.size()!=0){
            system.debug('Product Transfer already created');
            return 'fail';
        }
        
        // ProductTransfer fields taht will be created.
        productTransferFields = new String [] {'sigmaerpdev2__Request_Location__c','sigmaerpdev2__To_Requested_Location__c','sigmaerpdev2__Product_Request__c'};
            // Obtaining the field name/token map for the ProductTransfer object
            productTransferMap = Schema.SObjectType.Product_transfer__c.fields.getMap();
        for (String fieldToCheck : productTransferFields) {
            // Check if the user has create access on the each field
            if (!productTransferMap.get(fieldToCheck).getDescribe().isCreateable()) {
                system.debug('User has no create access on Product Transfer');
                return null;
            }
        }
        //Creating a new ProductTransfer with ProductRequest as its LookUp.
        Product_transfer__c productTransfer = new Product_transfer__c();
        productTransfer.sigmaerpdev2__Request_Location__c = productRequest.sigmaerpdev2__Requested_From_Location__c;
        productTransfer.sigmaerpdev2__To_Requested_Location__c = productRequest.sigmaerpdev2__Request_To_Location__c;
        productTransfer.Product_Request__c  = productRequest.Id;
    productTransfer.sigmaerpdev2__From_Bin__c=productRequest.sigmaerpdev2__From_Bin__c;
    productTransfer.sigmaerpdev2__To_Bin__c=productRequest.sigmaerpdev2__To_Bin__c;
        
        if(productRequestLineItems!=NULL && productRequestLineItems.size()!=0){
            insert productTransfer;
        }
        else{
            return 'No Product Line Items';
        }
        system.debug('ProductTransfer Inserted - '+productTransfer);
        if (Schema.sObjectType.Product_Request__c.fields.Product_Transfer__c.isUpdateable()){ 
            productRequest.Product_Transfer__c = productTransfer.Id;
            update productRequest;
            system.debug('Product Request Field Updated');
        }
        else{
            system.debug('User has no Edit Access on ProductRequest\'s ProductTransfer Field');
        }
        // RequestLineItems Fields that will be accessed.
        requestlineitemFields = new String [] {'sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product_Transfer__c'};
            
            // Obtaining the field name/token map for the sigmaerpdev2__Product_Request_Line_Item__c object
            mPRLI = Schema.SObjectType.Product_Request_Line_Item__c.fields.getMap();
        for (String fieldToCheck : requestlineitemFields) {
            // Check if the user has create access on the each field
            if (!mPRLI.get(fieldToCheck).getDescribe().isCreateable()) {
                system.debug('User has no create Access on ProductRequestLineItem Fields');
                return null;
            }
        }
        //Creating ProductRequestLineItems for ProductTransfer as per ProductRequestLineItems of ProductRequest object.
       for(Product_Request_Line_Item__c eachPRLI : productRequestLineItems){
            Product_Request_Line_Item__c tempPRLI = new Product_Request_Line_Item__c();
            tempPRLI.Product__c = eachPRLI.Product__c;
            tempPRLI.Quantity__c = eachPRLI.Quantity__c;
            tempPRLI.Product_Transfer__c = productTransfer.Id;
            listPRLI.add(tempPRLI);
        }
       //} 
        if(listPRLI!=null && listPRLI.size()!=0){
            insert listPRLI;
            system.debug('ProductTransferLineItems Updated');
            return 'success';
        }
        else{
            return 'fail';
        }
         
    }
}