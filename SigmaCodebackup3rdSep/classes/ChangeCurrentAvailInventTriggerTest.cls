@isTest 
Public class ChangeCurrentAvailInventTriggerTest
{
  @IsTest(seeAllData=false)
   public static void methodOne()
  {
        Test.startTest();
        
        Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos(); 
        Id RID1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
         Account acc = new Account();
        acc.Name = 'Test';
        acc.Email__c = 'cus@gmail.com';
        acc.RecordTypeId = RID1;
        insert acc;
        system.assertEquals(acc.Name,'Test');
        
        Default_Parameters__c  dp = new Default_Parameters__c (Name = 'Sample dp',Parent_Id__c = acc.Id);
        insert dp;
        system.assertEquals(dp.Name,'Sample dp');
        
         Id RID3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();
        Account acc3 = new Account();
        acc3.Name = 'Test1';
        acc3.RecordTypeId = RID3;
        acc3.Type = 'Location';
        acc3.Email__c = 'Test@test.com';
        insert acc3;
        system.assertEquals(acc3.Name,'Test1');
        
        Product2 Pro1 = new Product2(Name='Product - 1',SKU__c = 'TP001',Stock_Item__c=true);
        Insert Pro1;
        system.assertEquals('Product - 1',Pro1.Name);

        Inventory__c i1 = [select id from Inventory__c where ProductCode__c =: Pro1.Id];
        Inventory_Location__c il = new Inventory_Location__c(Location__c = acc3.Id);
        insert il;
        system.assertEquals(il.Location__c,acc3.Id);
        
        Inventory_Location_Product__c ilp1 = new Inventory_Location_Product__c(Inventory_Location__c =il.Id,Adjusted_Quantity__c=1,Received_Quantity__c=100, Products__c = Pro1.Id,Inventory__c = i1.Id, Delivered_Quantity__c = 0 );
        insert ilp1;    
        system.assertEquals(ilp1.Inventory_Location__c,il.Id);
        Test.stopTest();
     
  }
}