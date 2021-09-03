@isTest(seeAllData=false)
public class TriggerTo_Delete_ChildRecordsOf_POTest 
{
     @IsTest(seeAllData=false)
    public static void TestingForMethod4()
    {   
        Test.startTest();
       
        Account testaccmerchant = new Account(Name= 'Test Merchant 4', Type = 'Merchant',Email__c='Manun91@gmail.com', Web_Order_Value__c =40);
        insert testaccmerchant;   
        System.assertEquals(testaccmerchant.name, 'Test Merchant 4');
        
        
        Account testAccount = new Account();
        testAccount.Type = 'Vendor';
        testAccount.Name = 'TestAccountName';
        testAccount.Email__c='abc@gmail.com';
        insert testAccount;
        System.assertequals('Vendor',testAccount.Type);
        
        System.assertEquals(testAccount.name, 'TestAccountName');
        
        Purchase_Order__c testPurchaseOrder = new Purchase_Order__c();
        testPurchaseOrder.Status__c = 'Open';
        testPurchaseOrder.Product_Supplier__c = testAccount.Id;
        insert testPurchaseOrder;
        System.assertequals('Open',testPurchaseOrder.Status__c);
        
        Default_Parameters__c  dp = new Default_Parameters__c (Name = 'Sample dp',Parent_Id__c = testAccount.Id);
        insert dp;
        System.assertEquals(dp.Name,'Sample dp');
        
       /* Product2 testproduct =  new Product2 (Name= 'Test product', SKU__c='sku12345',Product_Price__c=15);
        insert testproduct;
       
        System.assertEquals(testproduct.Name,'Test product');
        
        Vendor_Product__c  vendor = new Vendor_Product__c ();
        vendor.Account_Name__c = testAccount.Id;
        vendor.Product_Name__c = testproduct.Id;
        vendor.Buying_Price__c = 500;
        insert vendor;
        
        System.assertEquals(vendor.Buying_Price__c,500); */
        
        Product2 testproduct = new Product2();
        testproduct.Name='Product - 1';
        testproduct.SKU__c = 'TP001';
        testproduct.Type__c = 'BOM';
        //testproduct.RecordTypeId = RID4;
        testproduct.Selling_Price__c= 10;
        testproduct.Product_Price__c = 100;
        testproduct.Buying_Price__c = 150;
        testproduct.Max_Discount__c = 2;        
        testproduct.Attribute_Type__c = 'SERIALIZED';
        Insert testproduct;
        system.assertEquals('Product - 1',testproduct.Name);
        
        Vendor_Product__c vp  = new Vendor_Product__c();
        vp.Product_Name__c = testproduct.id;
        vp.Account_Name__c = testAccount.Id;
        vp.Buying_Price__c = 200;
        vp.Is_Preferred__c=true;
        insert vp;
        system.assertEquals(testproduct.id,vp.Product_Name__c);
        
       
        
        Purchase_Order_Product__c testPurchaseOrderProduct = new Purchase_Order_Product__c();
        testPurchaseOrderProduct.Purchase_Order__c = testPurchaseOrder.Id;
        testPurchaseOrderProduct.Quantity__c = '1';
        insert testPurchaseOrderProduct;
        System.assertequals(testPurchaseOrder.Id,testPurchaseOrderProduct.Purchase_Order__c);
         delete testPurchaseOrderProduct ;
         delete testPurchaseOrder;
              
      
        Test.stopTest();
    }

}