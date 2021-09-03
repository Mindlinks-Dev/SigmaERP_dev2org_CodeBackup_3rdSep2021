@isTest 
Public class ManageInventoryTransactionsTriggerTest
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
        acc.RecordTypeId = RID1;
        acc.Email__c='sg@gmail.com';
        insert acc;
        system.assertEquals(acc.Name,'Test');
        
        Default_Parameters__c  dp = new Default_Parameters__c (Name = 'Sample dp',Parent_Id__c = acc.Id,Default_Vendor__c = true,Vendor_Rating__c = true);
        insert dp;
        system.assertEquals(dp.Name,'Sample dp');
        
        Id RID3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();
        Id RID45 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        
        Account acc3 = new Account();
        acc3.Name = 'Test1';
        acc3.RecordTypeId = RID3;
        acc3.Type = 'Location';
        insert acc3;
        system.assertEquals(acc3.Name,'Test1');
        
        Product2 Pro2 = new Product2(Name='Product - 2',SKU__c = 'TP003',Stock_Item__c=true,Reorder_Quantity__c = 50,Quantity__c = 10);
        Insert Pro2;
        system.assertEquals('Product - 2',Pro2.Name);
        
        Account Accs = new Account();
        Accs.Name = 'Test2';
        Accs.RecordTypeId = RID45;
        Accs.Type = 'Vendor';
        Accs.Email__c = 'Test@test.com';
        insert Accs;
        system.assertEquals(Accs.Name,'Test2');
        
        Product2 Pro1 = new Product2(Name='Product - 1',SKU__c = 'TP001',Stock_Item__c=true,Create_AutoPO__c = true,Threshold_Quantity__c = 50);
        Insert Pro1;
        system.assertEquals('Product - 1',Pro1.Name);
        
        
        
        Vendor_Product__c VendProd = new Vendor_Product__c();
        VendProd.Product_Name__c = Pro1.Id;
        VendProd.Account_Name__c = Accs.Id;
        VendProd.Selling_Price__c = 100;
        VendProd.Buying_Price__c = 100;
        VendProd.Is_Preferred__c = true;
        
        insert VendProd;
        system.assertEquals(VendProd.Selling_Price__c,100);
        
        Inventory__c i1 = [select id,Available_Qty__c from Inventory__c where ProductCode__c =: Pro1.Id];
        Inventory_Location__c il = new Inventory_Location__c(Location__c = acc3.Id);
        insert il;
        i1.Available_Qty__c = 50;
        update i1;
        system.assertEquals(il.Location__c,acc3.Id);
        
        
        
        Test.stopTest();
     
   }
   @IsTest(seeAllData=false)
    public static void methodOneTwo()
  {
        Test.startTest(); 
        
        Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        Id RID1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        
        Account acc = new Account();
        acc.Name = 'Test';
        acc.RecordTypeId = RID1;
        acc.Email__c='gf@gmail.com';
        insert acc;
        system.assertEquals(acc.Name,'Test');
        
        Default_Parameters__c  dp = new Default_Parameters__c (Name = 'Sample dp',Parent_Id__c = acc.Id,Default_Vendor__c = true,Vendor_Rating__c = true);
        insert dp;
        system.assertEquals(dp.Name,'Sample dp');
        
        Id RID3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();
        Id RID45 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        
        Account acc3 = new Account();
        acc3.Name = 'Test1';
        acc3.RecordTypeId = RID3;
        acc3.Type = 'Location';
        insert acc3;
        system.assertEquals(acc3.Name,'Test1');
        
        Product2 Pro2 = new Product2(Name='Product - 2',SKU__c = 'TP003',Stock_Item__c=true,Reorder_Quantity__c = 50,Quantity__c = 10);
        Insert Pro2;
        system.assertEquals('Product - 2',Pro2.Name);
        
        Account Accs = new Account();
        Accs.Name = 'Test2';
        Accs.RecordTypeId = RID45;
        Accs.Type = 'Vendor';
        Accs.Email__c = 'Test@test.com';
        insert Accs;
        system.assertEquals(Accs.Name,'Test2');
        
        Product2 Pro1 = new Product2(Name='Product - 1',SKU__c = 'TP001',Stock_Item__c=true,Create_AutoPO__c = true,Threshold_Quantity__c = 50);
        Insert Pro1;
        system.assertEquals('Product - 1',Pro1.Name);
       
        Vendor_Product__c VendProd = new Vendor_Product__c();
        VendProd.Product_Name__c = Pro1.Id;
        VendProd.Account_Name__c = Accs.Id;
        VendProd.Selling_Price__c = 100;
        VendProd.Buying_Price__c = 100;
        VendProd.Is_Preferred__c = true;
        
        insert VendProd;
        system.assertEquals(VendProd.Selling_Price__c,100);
        
        Purchase_Order__c PO= new Purchase_Order__c();
        PO.Product_Supplier__c = Accs.Id;
        PO.Status__c = 'Open';
        
        insert PO;
        system.assertEquals(PO.Status__c,'Open');
        
        Purchase_Order_Product__c POLine = new Purchase_Order_Product__c();
        POLine.Product__c = Pro1.Id;
        POLine.Purchase_Order__c = PO.Id;
        POLine.Orderd_Quantity__c = 20;
        POLine.Remaining_to_come__c = 10;    
        POLine.Received_Quantity__c = 10;
        POLine.Status__c = 'Partial Delivery';
        
        insert POLine;
        
        system.assertEquals(POLine.Status__c,'Partial Delivery');
        
        Inventory__c i1 = [select id,Available_Qty__c from Inventory__c where ProductCode__c =: Pro1.Id];
        System.debug('i1>> '+i1);
        Inventory_Location__c il = new Inventory_Location__c(Location__c = acc3.Id);
        insert il;
        i1.Available_Qty__c = 50;
        update i1;
        system.assertEquals(il.Location__c,acc3.Id);
        Test.stopTest();
     
   }
  
  
}