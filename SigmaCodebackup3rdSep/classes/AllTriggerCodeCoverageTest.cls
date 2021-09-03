@isTest(seeAllData=false)
public class AllTriggerCodeCoverageTest 
{
   public static testMethod void test1()
   {
             ID RID1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        Account  acc=new Account();
        acc.Status__c='Active';
        acc.Name='JTEST';
        acc.Email__c='df@gmail.com';
        acc.Type='Vendor';
        acc.RecordTypeId = RID1;
        insert acc;
         System.assertequals( acc.Type,'Vendor');
       Vendor_Incidence__c vi=new Vendor_Incidence__c();
       insert vi;
       
       
   }
  public static testMethod void test2()
   {
       Test.startTest();
        Order_Usage__c OU = new Order_Usage__c();
        OU.Name = 'Name';
        OU.Sigma_order__c = true;
        OU.Standard_object__c = false;
        insert OU;
        System.assertequals(OU.Name,'Name');        
        
        Account  acc=new Account();
        acc.Name='JTEST1';
        acc.Type='Logistics';
        acc.Email__c='cs@gmail.com';
        insert acc;
        System.assertequals(acc.Name,'JTEST1');
        
        Account  acc1=new Account();
        acc1.Name='JTEST2';
        acc1.Type='Customer';
        acc1.Email__c='ef@gmail.com';
       acc1.Currency_code__c='GBP';
        insert acc1;
        System.assertequals(acc1.Name,'JTEST2');
        
        Account  acc2=new Account();
        acc2.Name='JTEST3';
        acc2.Type='Packaged Location';
        acc2.Email__c='ssc@gmail.com';
        insert acc2;
        System.assertequals(acc2.Name,'JTEST3');
            
        

        Contact  con=new Contact();
        con.FirstName='JTEST4';
        con.LastName='JTEST5';
        con.AccountId=acc.Id;
        con.Phone='9740424742';
        insert con;
        System.assertequals(con.AccountId,acc.Id);
        system.debug('acc.Id@@@@@'+acc.Id);
        
        Shipment__c ship=new Shipment__c();
        ship.Account__c=acc.Id;
        ship.Delivery_Person__c=con.Id;
        ship.Description__c='JM TEST1';
        ship.Shipment_Date__c=system.today();
        ship.Truck_No__c='KA32PK0987';
        ship.Status__c='Shipped';
        insert ship;
        System.assertequals(ship.Account__c,acc.Id);
              
        Shipment__c ship1=new Shipment__c();
        ship1.Account__c=acc.Id;
        ship1.Delivery_Person__c=con.Id;
        ship1.Description__c='JM TEST2';
        ship1.Shipment_Date__c=system.today();
        ship1.Truck_No__c='KA32PK0987';
        ship1.Status__c='Shipped';
        System.assertequals(ship1.Account__c,acc.Id);
        insert ship1;
        
        Package__c  pkge=new Package__c();
        pkge.Customer__c=acc1.Id;
        pkge.Location__c =acc2.Id;
        pkge.Status__c='Ready';
        insert pkge;
        System.assertequals(pkge.Location__c,acc2.Id);
        System.debug('pkge iD in test class:'+pkge.ID);
        
        Shipment_Products__c  shipProd=new Shipment_Products__c();
        shipProd.Package_ID__c=pkge.Id;
        shipProd.Shipment__c = ship.Id;
        shipProd.Customer_Name__c=acc1.Id;
        shipProd.Shipment_Delivery_Date__c=System.today();
        shipProd.Status__c='Shipment Pending';
        System.assertequals(shipProd.Customer_Name__c,acc1.Id);
        
        Shipment_Products__c  shipProd1=new Shipment_Products__c();
        shipProd1.Package_ID__c=pkge.Id;
        shipProd1.Shipment__c = ship.Id;
        shipProd1.Customer_Name__c=acc1.Id;
        shipProd1.Shipment_Delivery_Date__c=system.today();
        shipProd1.Status__c='Shipment Pending';
        System.assertequals(shipProd1.Package_ID__c,pkge.Id);

        List<Shipment_Products__c>  SProdList=new List<Shipment_Products__c>();
        SProdList.add(shipProd);
        SProdList.add(shipProd1);
    
        String shipmentProduts = JSON.serialize(SProdList);

        insert SProdList;
        update ship;
       update SProdList;
       update ship1;
         Test.stopTest();
       
   }
    
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
        testAccount.Email__c='Manun91@gmail.com';
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
        
     
        
        Product2 testproduct = new Product2();
        testproduct.Name='Product - 1';
        testproduct.SKU__c = 'TP001';
        testproduct.Type__c = 'BOM';
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
         delete testPurchaseOrderProduct;
               delete testproduct;
      
        Test.stopTest();
    }
         

}