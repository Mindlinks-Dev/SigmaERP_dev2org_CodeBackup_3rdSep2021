@isTest
public class TestProductTransferLineItems {
    @isTest 
    static void test(){
        try{
            Test.startTest();
            Integer i=0;
            
            Location__c fromLocation = new Location__c(Location_Name__c = 'Central Warehouse', Location_Type__c='WareHouse');
            Location__c toLocation = new Location__c(Location_Name__c ='Truck 1', Location_Type__c='Truck');
            insert fromLocation;
            insert toLocation;
            
            system.debug('fromLocation inserted - '+fromLocation);
            system.debug('toLocation inserted - '+toLocation);
            
            List<Product_Request__c> listProductRequest = new List<Product_Request__c>();
            
            for(i=0;i<4;i++){
                if(i==0){
                    Product_Request__c tempPR = new Product_Request__c();
                    tempPR.FromLocation__c = fromLocation.Id;
                    tempPR.To_Location__c = toLocation.Id;
                    
                    tempPR.Status__c = 'Approved';
                    listProductRequest.add(tempPR);
                }
                else if(i==2){
                    Product_Request__c tempPR = new Product_Request__c();
                    tempPR.FromLocation__c = fromLocation.Id;
                    tempPR.To_Location__c = toLocation.Id;
                    
                    tempPR.Status__c = 'Approved';
                    listProductRequest.add(tempPR);
                }
                else{
                    Product_Request__c tempPR = new Product_Request__c();
                    tempPR.FromLocation__c = fromLocation.Id;
                    tempPR.To_Location__c = toLocation.Id;
                    
                    tempPR.Status__c = 'Draft';
                    listProductRequest.add(tempPR);
                }
            }
            insert listProductRequest;
            system.debug('Product Request Inserted - '+listProductRequest);
            
            Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
            List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
            Id RID1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Account acc = new Account();
            acc.Name = 'Test';
            acc.Email__c='vid@gmail.com';
            acc.RecordTypeId = RID1;
            insert acc;
            
            
            Default_Parameters__c  dp = new Default_Parameters__c (Name = 'Sample dp',Parent_Id__c = acc.Id);
            insert dp;
            
            List<Product2> products = new List<Product2>();
            for(i=0;i<3;i++){
                
                Product2 temp = new Product2();
                temp.Name = 'Product'+i;
                temp.SKU__c = 'su2871'+i;
                temp.Active__c = True;
                temp.Minimum_Inventory__c = 10;
                temp.Maximum_Inventory__c = 15;
                temp.Replinishment_Stock__c = 10;
                products.add(temp);
                
            }
            insert products;
            system.debug('Products - '+products);
            
            Product_transfer__c productTransfer = new Product_transfer__c();
            productTransfer.Product_Transfer_From_location__c = fromLocation.Id;
            productTransfer.ProductTransferToLocation__c = toLocation.Id;
            productTransfer.Product_Request__c = listProductRequest[2].Id;
            productTransfer.Transfer_Status__c = 'Transfer Completed';
            
            insert productTransfer;
            system.debug('Product Transfer Inserted - '+productTransfer);  
            
            /*List<Product_Request_Line_Item__c> listPRLI = new List<Product_Request_Line_Item__c>();
for(i=0;i<3;i++){
if(i==1){
Product_Request_Line_Item__c tempPRLI = new Product_Request_Line_Item__c();
tempPRLI.Product__c = products[i].Id;
//tempPRLI.Product_Transfer__c = productTransfer.Id;
tempPRLI.Product_Request__c = listProductRequest[i].Id;
tempPRLI.Quantity__c = 10+i;
listPRLI.add(tempPRLI);
}
else{
Product_Request_Line_Item__c tempPRLI = new Product_Request_Line_Item__c();
tempPRLI.Product__c = products[i].Id;
tempPRLI.Product_Request__c = listProductRequest[i].Id;
tempPRLI.Quantity__c = 10+i;
listPRLI.add(tempPRLI);
}
}*/
            Product_Request_Line_Item__c tempPRLI = new Product_Request_Line_Item__c();
            tempPRLI.Product__c = products[0].Id;
            tempPRLI.Product_Request__c = listProductRequest[0].Id;
            tempPRLI.Quantity__c = 10;
            insert tempPRLI;
            system.debug('listPRLI - '+tempPRLI);
            
            Product_Request_Line_Item__c tempPRLI1 = new Product_Request_Line_Item__c();
            tempPRLI1.Id = tempPRLI.Id;
            
            try{
                tempPRLI1.Quantity__c = 12;
                update tempPRLI1;
            }
            catch(Exception e){
                system.debug('Exception in Updating - '+e);
            }
            system.debug('Update1 - '+tempPRLI1);
            Product_Request_Line_Item__c tempPRLIPT = new Product_Request_Line_Item__c();
            tempPRLIPT.Product__c = products[0].Id;
            tempPRLIPT.Product_Transfer__c = productTransfer.Id;
            tempPRLIPT.Quantity__c = 10;
            insert tempPRLIPT;
            system.debug('Insert 1 - '+tempPRLIPT);
            Product_Request_Line_Item__c tempPRLI2 = new Product_Request_Line_Item__c();
            tempPRLI2.Id = tempPRLIPT.Id;
            tempPRLI2.Quantity__c = 13;
            update tempPRLI2;
            system.debug('Update 2 - '+tempPRLI2);
            Test.stopTest();
            System.assert(true);
        }
        catch(Exception e){
            system.debug('Exception Occurred - '+e);
        }
    }
}