@isTest
public  class TestLinkerPPLI {
    
     @isTest static void TestPPLI() {
          Test.startTest();
         PackagedProducts__c pack = new PackagedProducts__c();
         pack.Auto_allocate__c = false;
         pack.Quantity__c = 10;
         insert pack;
         system.assertEquals(pack.Quantity__c ,10);

        Package_Product_Line_Item__c  pp = new Package_Product_Line_Item__c();
        pp.Packaged_Product__c= pack.id;
        insert pp;
        system.assertEquals(pp.Packaged_Product__c,pack.id);
        
        StockAdjustment__c SA = new StockAdjustment__c();
        SA.Comments__c='hii';
        SA.Quantity__c = 10;
        insert SA;
        system.assertEquals(SA.Quantity__c , 10);
        
        Stock_Adjustment_Product__c SAP = new Stock_Adjustment_Product__c();
        SAP.Stock_Adjustment__c = SA.id;
        SAP.Adjusted_Quantity__c =5;
        insert SAP; 
        system.assertEquals(SAP.Adjusted_Quantity__c ,5);

        Shipment__c Ship = new Shipment__c();
        Ship.Truck_No__c = '123';
        insert Ship;
        system.assertEquals(Ship.Truck_No__c ,'123');

        
        Shipment_Products__c Shipproduct = new Shipment_Products__c();
        Shipproduct.Shipment__c=Ship.id;
        Shipproduct.Orderd_Quantity__c  =10;
        insert Shipproduct;
        system.assertEquals(Shipproduct.Orderd_Quantity__c ,10);
        
        Stock_Moment_Product__c SM = new Stock_Moment_Product__c();
        SM.Quantity__c = 10;
        SM.Vendor_Email__c = 'haris@gmail.com';
        insert SM;
        system.assertEquals(SM.Vendor_Email__c ,'haris@gmail.com');
        
        Sales_Order_Allocation__c SOA = new Sales_Order_Allocation__c();
        SOA.Status__c= 'Order Confirmed';
        insert SOA;
        system.assertEquals(SOA.Status__c,'Order Confirmed');
        
        Sales_Order_Allocation_Line_Item__c SOAL = new Sales_Order_Allocation_Line_Item__c();
        SOAL.Sales_Order_Allocation__c = SOA.id;
        insert SOAL;
        system.assertEquals( SOAL.Sales_Order_Allocation__c ,SOA.id);
        
         //defualt parameter
         Default_Parameters__c DP = new Default_Parameters__c();
         DP.Name='defualt';
         DP.Inventory_Status__c='Reserve';
         DP.Auto_Reserve_Stock__c=true;
         insert DP;
         System.assertEquals( DP.Auto_Reserve_Stock__c,true);
        
        Account accloc = new Account();
        accloc.name='bagalore';
        accloc.Type = 'Location';
        accloc.Email__c='abc@gmail.com';
        insert accloc;
         Account accvendor = new Account();
        accvendor.name='bagaloreVendor';
        accvendor.Type = 'Vendor';
        accvendor.Email__c='abx@gmail.com';
        insert accvendor;
        system.assertEquals(accvendor.Type , 'Vendor');
        
        Id RIDBOM = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('BOM').getRecordTypeId();
        Product2 prod= new Product2();
        prod.Name='test';
        prod.Product_Description__c='test description';
        prod.Product_Price__c=100;
        prod.Buying_Price__c=20;
        prod.Max_Discount__c=30;
        prod.Product_Weight__c = 3 ;
        prod.SKU__c = 'testing';
        prod.Type__c = 'BOM';
        prod.RecordtypeId = RIDBOM;
        insert prod;
        System.assertEquals(prod.name, 'test');
        
        //Product Inventory
        Inventory__c PI = new Inventory__c();
        PI.ProductCode__c=prod.id;
        PI.Available_Qty__c = 10;
        insert PI;
        System.assertEquals(PI.Available_Qty__c,10);
        
        
        
        Product_Price__c PP1 = new Product_Price__c();
        PP1.Status__c= 'Active';
        PP1.Cost__c = 10;
        PP1.End_Date__c = system.today()+5;
        PP1.Location__c = accloc.id;
        PP1.Product_Id__c = prod.id;
        PP1.Start_Date__c = system.today();
        insert PP1;
        system.assertEquals(PP1.Location__c , accloc.id);
        
        Vendor_Evaluation__c  VE = new Vendor_Evaluation__c ();
        VE.Order_Quantity__c= 10;
        insert VE;
        system.assertEquals(VE.Order_Quantity__c,10);
        
        Inventory__c Inventory = new Inventory__c();
        Inventory.Total_Qty__c=10;
        insert Inventory;
        system.assertEquals(Inventory.Total_Qty__c,10);
        
         Vendor_Product__c vp2=   new Vendor_Product__c();
       vp2.Account_Name__c = accvendor .id;
      vp2.Product_Name__c = prod.id;
        vp2.Buying_Price__c = 100;
        vp2.Discount__c = 10;
        vp2.Quantity__c = 1;
        vp2.Is_Preferred__c=true;
        insert vp2;
        system.assertEquals(vp2.Quantity__c , 1);
        
        Test.stopTest();
        
        
     }
}