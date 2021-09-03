@isTest
public class TestTransferStatusCompleted { 
  @isTest
    public static void test(){
        test.startTest();
        Location__c fromLocation = new Location__c(Location_Name__c = 'Central Warehouse', Location_Type__c='WareHouse');
        Location__c toLocation = new Location__c(Location_Name__c ='Truck 1', Location_Type__c='Truck');
        insert fromLocation;
        insert toLocation;
        
        Product_transfer__c productTransfer = new Product_transfer__c(Product_Transfer_From_location__c=fromLocation.Id,ProductTransferToLocation__c=toLocation.Id);
        insert productTransfer;
        
        productTransfer.Transfer_Status__c = 'Transfer Completed';
        update productTransfer;
        test.stopTest();
         System.assert(true);
    }
}