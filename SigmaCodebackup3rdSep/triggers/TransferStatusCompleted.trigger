/****************************************************************************************************************** 
SL.No      Author                  Version                     Description

1.         Jayanth G                1.0 (Initial Version)       TransferStatusCompleted is an ApexTrigger which gets 
                                triggered when the status in ProductTransfer Object 
                                is changed to "Transfer Completed". This trigger will 
                                invoke an Apex class named "InventoryAfterTransfer".
*******************************************************************************************************************/ 

trigger TransferStatusCompleted on Product_transfer__c (after update) {
    // ProductTransfer Fields that will be accessed.
        String [] productTransferFields = new String [] {'sigmaerpdev2__Request_Location__c','sigmaerpdev2__From_Bin__c','sigmaerpdev2__To_Bin__c','sigmaerpdev2__To_Requested_Location__c','sigmaerpdev2__Transfer_Status__c'};
            
            // Obtaining the field name/token map for the ProductTransfer object
            Map<String,Schema.SObjectField> productTransferMap = Schema.SObjectType.Product_transfer__c.fields.getMap();
        for (String fieldToCheck : productTransferFields) {
            // Check if the user has create access on the each field
            if (!productTransferMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on ProductTransfer Fields');
                return;
            }
        }
    List<Product_transfer__c> productTransfer= [select Id,Transfer_Status__c,sigmaerpdev2__From_Bin__c,sigmaerpdev2__To_Bin__c,sigmaerpdev2__Request_Location__c,sigmaerpdev2__To_Requested_Location__c from Product_transfer__c where Id in :Trigger.New];
    sigmaerpdev2__Esignature__c esig=[select id,sigmaerpdev2__Is_Esignature_Needed__c from sigmaerpdev2__Esignature__c];
    if(productTransfer[0].Transfer_Status__c == 'Transfer Completed' && esig.sigmaerpdev2__Is_Esignature_Needed__c==true){
          InventoryAfterTransfer.isSignaturemade(productTransfer);
     }else if(productTransfer[0].Transfer_Status__c == 'Transfer Completed' && esig.sigmaerpdev2__Is_Esignature_Needed__c==false){
        InventoryAfterTransfer.isTransferComplete(productTransfer); 
    }
    
    
}