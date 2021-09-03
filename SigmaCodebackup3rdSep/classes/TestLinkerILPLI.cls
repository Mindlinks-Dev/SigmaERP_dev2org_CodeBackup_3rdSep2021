@isTest
public  class TestLinkerILPLI {
 @isTest static void TestILPLI () {
          Test.startTest();
          Inventory_Location_Product_Line_Item__c ILPLI = new Inventory_Location_Product_Line_Item__c();
          ILPLI .Allocated_Quantity__c=10;
          insert ILPLI;
          system.assertEquals(ILPLI .Allocated_Quantity__c,10);
          Test.stopTest();
          }

}