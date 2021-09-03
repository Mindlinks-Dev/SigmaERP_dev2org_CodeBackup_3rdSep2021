public with sharing class AutomatedProductTransfer {  
    public static void createProductTransfer(){
        
        // Location Fields that will be accessed.
            String [] locationFields = new String [] {'Name','sigmaerpdev2__Active__c'};
            
            // Obtaining the field name/token map for the ProductStock object
            Map<String,Schema.SObjectField> locationMap = Schema.SObjectType.Account.fields.getMap();
        for (String fieldToCheck : locationFields) {
            // Check if the user has create access on the each field
            if (!locationMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on Location Fields');
                return;
            }
        }
        List<Account> locations = [SELECT  Id,Name, sigmaerpdev2__Active__c  FROM Account ];
        system.debug('Locations - '+locations);
        Set<Id> locationsId = new Set<Id>();
        for(Account eachLocation : locations){
            if(locationsId.contains(eachLocation.Id)==false){
                locationsId.add(eachLocation.Id);
            }
        }
        
        // ProductStock Fields that will be accessed.
            String [] productStockFields = new String [] {'sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Inventory_Location_Name__c','sigmaerpdev2__Products__c'};
            
            // Obtaining the field name/token map for the ProductStock object
            Map<String,Schema.SObjectField> productStockMap = Schema.SObjectType.sigmaerpdev2__Inventory_Location_Product__c.fields.getMap();
        for (String fieldToCheck : productStockFields) {
            // Check if the user has create access on the each field
            if (!productStockMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on ProductStock Fields');
                return;
            }
        }
        List<sigmaerpdev2__Inventory_Location_Product__c> productStock = [SELECT Id, sigmaerpdev2__Reserved_Quantity__c, sigmaerpdev2__Products__c,sigmaerpdev2__Inventory_Location_Name__c FROM sigmaerpdev2__Inventory_Location_Product__c where sigmaerpdev2__Inventory_Location_Name__c = :locationsId];
        system.debug('Product Stock - '+productStock);
        Map<String,List<sigmaerpdev2__Inventory_Location_Product__c>> locProductStck = new Map<String,List<sigmaerpdev2__Inventory_Location_Product__c>>();
        for(Account location : locations){
            List<sigmaerpdev2__Inventory_Location_Product__c> tempPS = new List<sigmaerpdev2__Inventory_Location_Product__c>();
            for(sigmaerpdev2__Inventory_Location_Product__c eachProductStock : productStock){
                if(location.Id == eachProductStock.sigmaerpdev2__Inventory_Location_Name__c){
                    system.debug('Product Stock matched with Location - '+location.Name);
                    tempPS.add(eachProductStock);
                }
            }
            if(tempPS.size()!=0){
                locProductStck.put(location.Name,tempPS);
            }
        }
        system.debug('locProductStck Updated - '+locProductStck);
        
        
        // Product Fields that will be accessed.
        String [] productFields = new String [] {'Name','sigmaerpdev2__Minimum_Inventory__c','sigmaerpdev2__Maximum_Inventory__c','sigmaerpdev2__Replinishment_Stock__c'};
            
            // Obtaining the field name/token map for the Product object
            Map<String,Schema.SObjectField> productMap = Schema.SObjectType.Product2.fields.getMap();
        for (String fieldToCheck : productFields) {
            // Check if the user has create access on the each field
            if (!productMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on Product Fields');
                return;
            }
        }
        List<Product2> products = [SELECT Id, Name, sigmaerpdev2__Minimum_Inventory__c, sigmaerpdev2__Maximum_Inventory__c, sigmaerpdev2__Replinishment_Stock__c FROM Product2 limit 100];        
        
        // ProductTransfer Fields that will be accessed.
        String [] productTransferFields = new String [] {'sigmaerpdev2__From_Location__c','sigmaerpdev2__To_Location__c','sigmaerpdev2__Automatic_Replenishment__c'};
            
            // Obtaining the field name/token map for the ProductTransfer object
            Map<String,Schema.SObjectField> productTransferMap = Schema.SObjectType.sigmaerpdev2__Product_transfer__c.fields.getMap();
        for (String fieldToCheck : productTransferFields) {
            // Check if the user has create access on the each field
            if (!productTransferMap.get(fieldToCheck).getDescribe().isCreateable()) {
                system.debug('Has no create Access on ProductTransfer Fields');
                return;
            }
        }
        for(String key : locProductStck.keySet()){
            
            for(Account eachLocation : locations){
                if(key == eachLocation.Name){
                    List<sigmaerpdev2__Inventory_Location_Product__c> temp = locProductStck.get(key);
                    sigmaerpdev2__Product_transfer__c productTransfer = new sigmaerpdev2__Product_transfer__c();
                   //productTransfer.sigmaerpdev2__From_Location__c = eachLocation.sigmaerpdev2__Parent_Location__c;
                    productTransfer.sigmaerpdev2__To_Requested_Location__c = eachLocation.Id;
                    productTransfer.sigmaerpdev2__Automatic_Replenishment__c = True;
                    insert productTransfer;
                    
                    system.debug('Product Transfer Inserted');
                    list<sigmaerpdev2__Product_Request_Line_Item__c> listPRLI = new list<sigmaerpdev2__Product_Request_Line_Item__c>();
                    
                    
                    // RequestLineItems Fields that will be accessed.
                    String[] requestlineitemFields = new String [] {'sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product_Transfer__c'};
                        
                        // Obtaining the field name/token map for the sigmaerpdev2__Product_Request_Line_Item__c object
                        Map<String,Schema.SObjectField>  mPRLI = Schema.SObjectType.sigmaerpdev2__Product_Request_Line_Item__c.fields.getMap();
                    for (String fieldToCheck : requestlineitemFields) {
                        // Check if the user has create access on the each field
                        if (!mPRLI.get(fieldToCheck).getDescribe().isCreateable()) {
                            system.debug('User has no create Access on ProductRequestLineItem Fields');
                            return;
                        }
                    }
                    for(Product2 eachProduct : products){
                        boolean flag = false;
                        for(sigmaerpdev2__Inventory_Location_Product__c eachProductStck : temp){
                            if(eachProduct.Id == eachProductStck.sigmaerpdev2__Inventory_Location_Name__c){
                                system.debug('Matched product - '+eachProduct.Name);
                                sigmaerpdev2__Product_Request_Line_Item__c productRequestLineItem = new sigmaerpdev2__Product_Request_Line_Item__c();
                                productRequestLineItem.sigmaerpdev2__Product__c = eachProduct.Id;
                                productRequestLineItem.sigmaerpdev2__Product_Transfer__c = productTransfer.Id;
                                if(eachProductStck.sigmaerpdev2__Reserved_Quantity__c < eachProduct.sigmaerpdev2__Minimum_Inventory__c){
                                    if((eachProductStck.sigmaerpdev2__Reserved_Quantity__c+eachProduct.sigmaerpdev2__Replinishment_Stock__c)>eachProduct.sigmaerpdev2__Maximum_Inventory__c){
                                        productRequestLineItem.sigmaerpdev2__Quantity__c = eachProduct.sigmaerpdev2__Maximum_Inventory__c;
                                    }
                                    else{
                                        productRequestLineItem.sigmaerpdev2__Quantity__c = eachProductStck.sigmaerpdev2__Reserved_Quantity__c + eachProduct.sigmaerpdev2__Replinishment_Stock__c;
                                    }
                                    listPRLI.add(productRequestLineItem);
                                    flag=true;
                                    break;
                                }
                            }
                            else{
                                flag = false;
                            }
                        }
                        if(flag==false){
                            system.debug('UnMatched product - '+eachProduct.Name);
                            sigmaerpdev2__Product_Request_Line_Item__c productRequestLineItem = new sigmaerpdev2__Product_Request_Line_Item__c();
                            productRequestLineItem.sigmaerpdev2__Product__c = eachProduct.Id;
                            productRequestLineItem.sigmaerpdev2__Product_Transfer__c = productTransfer.Id;
                            if(eachProduct.sigmaerpdev2__Replinishment_Stock__c >eachProduct.sigmaerpdev2__Maximum_Inventory__c){
                                productRequestLineItem.sigmaerpdev2__Quantity__c = eachProduct.sigmaerpdev2__Maximum_Inventory__c;
                            }
                            else{
                                productRequestLineItem.sigmaerpdev2__Quantity__c = eachProduct.sigmaerpdev2__Replinishment_Stock__c;
                            }
                            listPRLI.add(productRequestLineItem);
                        }
                        
                    }
                    if(listPRLI.size()!=0){
                        system.debug('List - '+listPRLI);
                        insert listPRLI;
                    }
                    system.debug('Inserted');
                }
                
            }
        }
    }
}