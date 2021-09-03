trigger ProductTransferLineItems on Product_Request_Line_Item__c (before insert,before update) { 
    try{ 
        
        // RequestLineItems Fields that will be accessed.
        String [] requestlineitemFields = new String [] {'sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product_Transfer__c','sigmaerpdev2__Product_Request__c'};
            
            // Obtaining the field name/token map for the Product_Request_Line_Item__c object
            Map<String,Schema.SObjectField> mPRLI = Schema.SObjectType.Product_Request_Line_Item__c.fields.getMap();
        for (String fieldToCheck : requestlineitemFields) {
            // Check if the user has create access on the each field
            if (!mPRLI.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on ProductRequestLineItem Fields');
                return;
            }
        }
        List<Product_Request_Line_Item__c> productLineItems = [SELECT Id, Product__c, Quantity__c, Product_Request__c ,Product_Transfer__c FROM Product_Request_Line_Item__c where Id in :Trigger.New];
        Product_Request__c productRequest;
        Product_transfer__c productTransfer;
        
        system.debug('PRLI - '+productLineItems);  
        
        if(productLineItems[0].Product_Request__c!=null){
            //system.debug('Product Request Not Null - '+productLineItems[0].sigmaerpdev2__Product_Request__c);
            
            // ProductRequest Fields that will be accessed.
            String [] productRequestFields = new String [] {'Name','sigmaerpdev2__Requested_From_Location__c','sigmaerpdev2__Request_To_Location__c','sigmaerpdev2__Status__c'};
                
                // Obtaining the field name/token map for the ProductRequest object
                Map<String,Schema.SObjectField> productRequestMap = Schema.SObjectType.Product_Request__c.fields.getMap();
            for (String fieldToCheck : productRequestFields) {
                // Check if the user has create access on the each field
                if (!productRequestMap.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on ProductRequest Fields');
                    return;
                }
            }
            Id productRequestId = productLineItems[0].Product_Request__c;
            productRequest = [SELECT Id, Name, sigmaerpdev2__Request_To_Location__c, sigmaerpdev2__Requested_From_Location__c, Status__c FROM Product_Request__c where Id = :productRequestId];
            system.debug('Product Request - '+productRequest);
        }
        if(productLineItems[0].Product_Transfer__c != null){
            system.debug('Product Transfer Not Null - '+productLineItems[0].Product_Transfer__c);
            
            // ProductTransfer Fields that will be accessed.
            String [] productTransferFields = new String [] {'sigmaerpdev2__Request_Location__c','sigmaerpdev2__To_Requested_Location__c','sigmaerpdev2__Transfer_Status__c'};
                
                // Obtaining the field name/token map for the ProductTransfer object
                Map<String,Schema.SObjectField> productTransferMap = Schema.SObjectType.Product_transfer__c.fields.getMap();
            for (String fieldToCheck : productTransferFields) {
                // Check if the user has create access on the each field
                if (!productTransferMap.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on ProductTransfer Fields');
                    return;
                }
            }
            Id productTransferId = productLineItems[0].Product_Transfer__c;
            productTransfer = [SELECT Id, sigmaerpdev2__Request_Location__c, sigmaerpdev2__To_Requested_Location__c, Transfer_Status__c FROM Product_transfer__c where Id =: productTransferId];
            system.debug('Product Transfer - '+productTransfer);
        }
        
        for(Product_Request_Line_Item__c eachPRLI : productLineItems){
            
            if(productRequest != null){
                if(productRequest.Status__c == 'Approved'){
                    
                    system.debug('Product Request Status Approved');
                    Map<Id,Product_Request_Line_Item__c> oldMap = Trigger.oldMap;
                    Map<Id,Product_Request_Line_Item__c> newMap = Trigger.newMap;
                    
                    Product_Request_Line_Item__c oldMapPRLI = oldMap.get(eachPRLI.Id);
                    Product_Request_Line_Item__c newMapPRLI = newMap.get(eachPRLI.Id);
                    
                    if(oldMapPRLI.Quantity__c != newMapPRLI.Quantity__c){
                        system.debug('Quantity is different');
                        newMapPRLI.addError('Cannot change Quantity after Product Request is Approved');
                    }
                    else{
                        system.debug('Quantity is same');
                    }
                }
            }
            
            if(productTransfer != null){
                if(productTransfer.Transfer_Status__c=='Transfer Completed'){
                    system.debug('Product Transfer Status Transfer Completed');
                    Map<Id,Product_Request_Line_Item__c> oldMap = Trigger.oldMap;
                    Map<Id,Product_Request_Line_Item__c> newMap = Trigger.newMap;
                    
                    Product_Request_Line_Item__c oldMapPRLI = oldMap.get(eachPRLI.Id);
                    Product_Request_Line_Item__c newMapPRLI = newMap.get(eachPRLI.Id);
                    
                    if(oldMapPRLI.Quantity__c != newMapPRLI.Quantity__c){
                        system.debug('Quantity is different');
                        newMapPRLI.addError('Cannot change Quantity once the Transfer is completed');
                    }
                    else{
                        system.debug('Quantity is same');
                    }
                }
            }
            
        }
    }
    catch(Exception e){
        system.debug('Exception - '+e);
    }
}