global with sharing class ProductTransferBatch /*implements 
Database.Batchable<sObject>, Database.Stateful */{
  /*   
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
        /*
        //List<Location__c> locations = [SELECT Id, Location_Name__c, Location_Description__c, Location_Type__c, Parent_Location__c FROM Location__c where Location_Type__c = 'Truck'];
        return Database.getQueryLocator(
            'SELECT ID, Location_Name__c,Name,Location_Description__c, Location_Type__c,Parent_Location__c  ' +
            'FROM Location__c ' + 
            'Where Location_Type__c = \'Truck\'' 
        );
    }
    global void execute(Database.BatchableContext bc, List<Location__c> locationList){
        // process each batch of records
        
        /*List<Product_Stock__c> productStock = [SELECT Id, Name, Location_Lookup__c, Product_Lookup__c, Inventory__c, Minimum_Inventory_Units__c FROM Product_Stock__c];
        Map<String,List<Product_Stock__c>> locProductStck = new Map<String,List<Product_Stock__c>>();
        
        //Defining Map with Key as Location Name and its value as ProductStock at its Location.
        for(Location__c location : locationList){
            List<Product_Stock__c> tempPS = new List<Product_Stock__c>();
            for(Product_Stock__c eachProductStock : productStock){
                if(location.Id == eachProductStock.Location_Lookup__c){
                    tempPS.add(eachProductStock);
                }
            }
            if(tempPS.size()!=0){
                locProductStck.put(location.Name,tempPS);
            }
        }
        
    List<Product2> products = [SELECT Id, Name, Minimum_Inventory__c, Maximum_Inventory__c, Replinishment_Stock__c FROM Product2];        
        
        //Creating a ProductTransfer Based on the Minimum Inventory of Products at every Location.
        for(String key : locProductStck.keySet()){
            
            for(Location__c eachLocation : locationList){
                if(key == eachLocation.Name){
                    
                    //Fetching the Product Stock Detials of the Location as per the current Iteration's Location.
                    List<Product_Stock__c> temp = locProductStck.get(key);
                    
                    //Creating a product Transfer.
                    Product_transfer__c productTransfer = new Product_transfer__c();
                    productTransfer.Product_Transfer_From_location__c = eachLocation.Parent_Location__c;
                    productTransfer.ProductTransferToLocation__c = eachLocation.Id;
                    productTransfer.Automatic_Replenishment__c = True;
                    insert productTransfer;
                    
                    //creating ProductLineItems as per the Inventory of Products and the Inventory at the Location.
                    list<Product_Request_Line_Item__c> listPRLI = new list<Product_Request_Line_Item__c>();
                    for(Product_Stock__c eachProductStck : temp){
                        for(Product2 eachProduct : products){
                            if(eachProduct.Id == eachProductStck.Product_Lookup__c){
                                Product_Request_Line_Item__c productRequestLineItem = new Product_Request_Line_Item__c();
                            productRequestLineItem.Product__c = eachProductStck.Product_Lookup__c;
                                productRequestLineItem.Product_Transfer__c = productTransfer.Id;
                                if(eachProductStck.Inventory__c < eachProduct.Minimum_Inventory__c){
                                    
                                    //The Quantity of PRLI of every product should not cross its Product's Max Inventory.
                                    if((eachProductStck.Inventory__c+eachProduct.Replinishment_Stock__c)>eachProduct.Maximum_Inventory__c){
                                        productRequestLineItem.Quantity__c = eachProduct.Maximum_Inventory__c;
                                    }
                                    else{
                                        productRequestLineItem.Quantity__c = eachProduct.Replinishment_Stock__c;
                                    }
                                   listPRLI.add(productRequestLineItem); 
                                }
                            }
                        } 
                    }
                    if(listPRLI.size()!=0){
                        insert listPRLI;
                    }
                }
                
            }
        } 
    }
    global void finish(Database.BatchableContext bc){
    }  */ 
}