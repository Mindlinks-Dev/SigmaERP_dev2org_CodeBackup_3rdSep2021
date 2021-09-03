/*=====================================================================================================
Author     : Vidit Kumar
Company    : Mindlinks Solution Pvt Ltd.
Date       : 26 Mar 2018
Description: Test class for LinkageServiceClass(Sigma Financial)
=======================================================================================================*/

@isTest
public class LinkageServiceClassTest
{
    @IsTest(seeAllData=false)
    static void methodOne() 
    {
        
        Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();

        ID RID1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
               
        Account  venAcc =new Account();
        venAcc.Name='TestVendor';
        venAcc.Type='Vendor';
        venAcc.RecordTypeId = RID1;
        venAcc.Email__c = 'Test@test.com';
        insert venAcc;
        System.assertEquals(venAcc.Name,'TestVendor');  


        ID RID3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();

        Account locAcc=new Account();
        locAcc.Name='Hubli';
        locAcc.Type='Location';
        locAcc.RecordTypeId = RID3;
        locAcc.Email__c = 'Test@test.com';
        insert locAcc;
        System.assertEquals(locAcc.Name,'Hubli');
        
        Account ExamLocAcc=new Account();
        ExamLocAcc.Name='Dharwad';
        ExamLocAcc.Type='Location';
        ExamLocAcc.RecordTypeId = RID3;
        ExamLocAcc.Email__c = 'Test@test.com';
        insert ExamLocAcc;
        System.assertEquals(ExamLocAcc.Name,'Dharwad');

        ID RID4 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account cusAcc = new Account();
        cusAcc.Name='Rashmi';
        cusAcc.Type='Customer';
        cusAcc.RecordTypeId = RID4;
        cusAcc.Base_Credit_Limit__c = 10000000.00;
        cusAcc.Customer_Type__c = 'Credit Customer';
        cusAcc.Email__c = 'Test@test.com';
        insert cusAcc;
        System.assertEquals(cusAcc.Name,'Rashmi');  

        Account PkgLoc = new Account();
        PkgLoc.Name='Mangalore';
        PkgLoc.Type='Packaged Location';
        PkgLoc.Email__c = 'Test@test.com';
        insert PkgLoc;
        System.assertEquals(PkgLoc.Name,'Mangalore'); 

        Account  logisticsAcc=new Account();
        logisticsAcc.Name='TestLogistics';
        logisticsAcc.Type='Logistics';
        logisticsAcc.Email__c = 'Test@test.com';
        insert logisticsAcc;
        System.assertEquals(logisticsAcc.Name,'TestLogistics');

        Contact  con=new Contact();
        con.FirstName='TestCon';
        con.LastName='TestCon';
        con.AccountId=venAcc.Id;
        con.phone ='1234567890';
        insert con;
        System.assertEquals(con.FirstName,'TestCon');

        Default_Parameters__c  dp = new Default_Parameters__c (Name = 'Sample dp',Parent_Id__c = venAcc.Id);
        insert dp;
        System.assertEquals(dp.Name,'Sample dp');

        Product2 pro=new  Product2();
        pro.Name='TestPro';
        pro.Buying_Price__c = 10;
        pro.Product_Price__c = 10;
        pro.Stock_Item__c=true;
        insert pro;
        System.assertEquals(pro.Name,'TestPro');


        Vendor_Product__c vp = new Vendor_Product__c();
        vp.Account_Name__c = venAcc.Id;
        vp.Product_Name__c = pro.Id;
        vp.Duty__c = 1;
        vp.Freight__c = 1;
        vp.Insurance__c = 1;
        vp.Other__c = 1;
        vp.Buying_Price__c = 10;
        vp.Is_Preferred__c = true;
        insert vp;
        System.assertEquals(vp.Other__c,1);
        
        Purchase_Order__c  pord=new  Purchase_Order__c();
        pord.Product_Supplier__c=venAcc.Id;
        pord.Order_Date__c=date.today();
        pord.Expected_Date__c =date.today() + 1;
        pord.Status__c='Submitted';
        insert pord;
        System.assertEquals(pord.Status__c,'Submitted');

        Purchase_Order_Product__c porderp=new  Purchase_Order_Product__c();
        porderp.Purchase_Order__c=pord.Id;
        porderp.Status__c='Open';
        porderp.Quantity__c='50';
        porderp.Expected_Delivery_Date__c=date.today();  
        porderp.Buying_Price__c=10;
        porderp.Received_Quantity__c = 50;
        porderp.Product__c = pro.Id;
        insert porderp;
        System.assertEquals(porderp.Status__c,'Open');

        Stock_In__c sr = new Stock_In__c();
        sr.Delivery_Person__c=con.Id;
        sr.Received_Date_Time__c = date.today();
        sr.Location__c=locAcc.Id;
        sr.Status__c='Open';
        sr.Truck_Number__c='DNTKNW838';
        sr.Vendor__c=venAcc.Id;
        insert sr;

        System.assertEquals(sr.Status__c,'Open');
        Stock_In_Product__c srp = new Stock_In_Product__c();
        srp.Quantity_Received__c=50;
        srp.Returned_Quantity__c=0;
        srp.Putaway_location__c=locAcc.Id;
        srp.Status__c='Verified';
        srp.Stock_In__c = sr.Id;
        srp.Product__c = pro.Id;
        srp.Pur_Order__c = pord.Id;
        srp.Purchase_Order__c = porderp.Id;
        insert srp;
        System.assertEquals(srp.Status__c,'Verified');

        Stock_Receiving_Product_Line_Item__c srpli = new Stock_Receiving_Product_Line_Item__c();
        srpli.Product__c = pro.Id;
        srpli.Purchase_Order_Product__c = porderp.Id;
        srpli.Received_Quantity__c = 50;
        srpli.Stock_Receiving_Product__c = srp.Id;
        srpli.Total_Buying_Price__c = 500;
        insert srpli;
        System.assertEquals(srpli.Total_Buying_Price__c,500);

        srpli.Received_Quantity__c = 60;
        update srpli;
        System.assertEquals(srpli.Received_Quantity__c,60);
        
        Inventory_Location__c il = new Inventory_Location__c(Location__c = locAcc.Id);
        insert il;
        System.assertEquals(il.Location__c,locAcc.Id);

        Inventory__c PI = [select id,Total_Available_Qty__c from Inventory__c where ProductCode__c =: Pro.Id];

        Inventory_Location_Product__c ilp = new Inventory_Location_Product__c(Inventory_Location__c =il.Id,Adjusted_Quantity__c=0, Received_Quantity__c=50,Products__c = Pro.Id, Inventory__c = PI.Id, Delivered_Quantity__c = 0, Stock_Origin__c = 'Stock Receiving' );
        insert ilp;
        System.assertEquals(ilp.Inventory_Location__c,il.Id);
        
        Inventory_Location_Product__c ilp1 = new Inventory_Location_Product__c(Inventory_Location__c =il.Id,Adjusted_Quantity__c=0, Received_Quantity__c=50,Products__c = Pro.Id, Inventory__c = PI.Id, Delivered_Quantity__c = 0, Stock_Origin__c = 'Stock Receiving' );
        insert ilp1;
        System.assertEquals(ilp1.Inventory_Location__c,il.Id);

        Inventory_Location_Product_Line_Item__c ilpli = new Inventory_Location_Product_Line_Item__c();
        ilpli.Inventory_Location__c =il.Id;
        ilpli.Inventory_Location_Product__c = ilp.Id;
        ilpli.Stock_Receiving_Product__c = srp.Id;
        ilpli.Adjusted_Quantity__c = 0;
        ilpli.Received_Quantity__c = 50;
        ilpli.Product__c = Pro.Id;
        ilpli.Inventory_Location_Product__c=ilp1.id;
        ilpli.Stock_Type__c = 'Stock Receiving';
        ilpli.Delivered_Quantity__c = 0;
        ilpli.Package_Quantity__c =0;
        insert ilpli;
        System.assertEquals(ilpli.Stock_Type__c,'Stock Receiving');
        
       
        Inventory_Location_Product_Line_Item__c ilpli2 = new Inventory_Location_Product_Line_Item__c();
        ilpli2.Inventory_Location__c =il.Id;
        ilpli2.Inventory_Location_Product__c = ilp.Id;
        ilpli2.Stock_Receiving_Product__c = srp.Id;
        ilpli2.Adjusted_Quantity__c = 0;
        ilpli2.Received_Quantity__c = 50;
        ilpli2.Product__c = Pro.Id;
        ilpli2.Stock_Type__c = 'Stock Receiving';
        ilpli2.Delivered_Quantity__c = 0;
        ilpli2.Package_Quantity__c =0;
        insert ilpli2;
        System.assertEquals(ilpli2.Stock_Type__c,'Stock Receiving');
       
        //Stock Adjustment - Decrease Starts
        StockAdjustment__c SAdec = new StockAdjustment__c();
        SAdec.Inventory_Location_Product__c = ilp.Id;
        SAdec.Original_Qty__c = 100;
        SAdec.Adjusted_Qty__c = 2;
        SAdec.Date__c = system.TODAY();
        SAdec.Reason_Code__c ='Expired Stocks';
        SAdec.Adjust_Type__c = 'Reduce Stock';
        insert SAdec;
        system.assertEquals(SAdec.Inventory_Location_Product__c,ilp.Id);
        
        Stock_Adjustment_Product__c sapdec = new Stock_Adjustment_Product__c ();
        sapdec.Adjusted_Quantity__c = 1;
        sapdec.ILPLI__c = ilpli.Id;
        sapdec.Product__c = Pro.Id;
        sapdec.Stock_Adjustment__c = SAdec.Id;
        insert sapdec;
        system.assertEquals(sapdec.Product__c,Pro.Id);
        
       
        //Stock Adjustment - Increase Starts
        StockAdjustment__c SAinc = new StockAdjustment__c();
        SAinc.Inventory_Location_Product__c = ilp.Id;
        SAinc.Original_Qty__c = 100;
        SAinc.Adjusted_Qty__c = 2;
        SAinc.Date__c = system.TODAY();
        SAinc.Reason_Code__c ='Expired Stocks';
        SAinc.Adjust_Type__c = 'Increase Stock';
        insert SAinc;
        system.assertEquals(SAinc.Inventory_Location_Product__c,ilp.Id);
        
        Stock_Adjustment_Product__c sapinc = new Stock_Adjustment_Product__c ();
        sapinc.Adjusted_Quantity__c = 1;
        sapinc.ILPLI__c = ilpli2.Id;
        sapinc.Product__c = Pro.Id;
        sapinc.Stock_Adjustment__c = SAinc.Id;
        insert sapinc;
        system.assertEquals(sapinc.Product__c,Pro.Id);
        
        
        //Stock Movement Starts
        
        Inventory_Location__c ExamLoc = new Inventory_Location__c(Location__c = ExamLocAcc.Id);
        insert ExamLoc;
        System.assertEquals(ExamLoc.Location__c,ExamLocAcc.Id);
        
        Inventory_Location_Product__c ilpExam = new Inventory_Location_Product__c(Inventory_Location__c =ExamLoc.Id,Adjusted_Quantity__c=0, Received_Quantity__c=50,Products__c = Pro.Id, Inventory__c = PI.Id, Delivered_Quantity__c = 0, Stock_Origin__c = 'Stock Receiving' );
        insert ilpExam;
        System.assertEquals(ilpExam.Inventory_Location__c,ExamLoc.Id);

        List<Inventory_Location_Product_Line_Item__c> ilplist3=new List<Inventory_Location_Product_Line_Item__c>();
        Inventory_Location_Product_Line_Item__c ilpliExam = new Inventory_Location_Product_Line_Item__c();
        ilpliExam.Inventory_Location__c =ExamLoc.Id;
        ilpliExam.Inventory_Location_Product__c = ilpExam.Id;
        ilpliExam.Stock_Receiving_Product__c = srp.Id;
        ilpliExam.Adjusted_Quantity__c = 0;
        ilpliExam.Received_Quantity__c = 50;
        ilpliExam.Product__c = Pro.Id;
        ilpliExam.Stock_Type__c = 'Moved IN';
        ilpliExam.Delivered_Quantity__c = 0;
        ilpliExam.Package_Quantity__c =0;
        insert ilpliExam;
        System.assertEquals(ilpliExam.Stock_Type__c,'Moved IN');
        ilplist3.add(ilpliExam);
        
        StockMovement__c stockmove = new StockMovement__c();
        stockmove.From_Location__c = il.Id;
        insert stockmove;
        system.assertEquals(stockmove.From_Location__c,il.Id);
        
        Stock_Moment_Product__c stockmovepro1 = new Stock_Moment_Product__c ();
        stockmovepro1.Moved_Location__c = ExamLoc.Id;
        stockmovepro1.Inventory_Location_Product__c = ilpExam.Id;
        stockmovepro1.ILPLI__c = ilpliExam.Id;
       stockmovepro1.From_ILPLI__c = ilpli.Id;
        stockmovepro1.Product2__c = Pro.Id;
        stockmovepro1.Moved_Quantity__c = 1;
        stockmovepro1.Stock_Movement__c = stockmove.Id;
        insert stockmovepro1;
        system.assertEquals(stockmovepro1.ILPLI__c,ilpliExam.Id);
        
        Stock_Moment_Product__c stockmovepro = new Stock_Moment_Product__c ();
        stockmovepro.Moved_Location__c = ExamLoc.Id;
        stockmovepro.Inventory_Location_Product__c = ilpExam.Id;
        stockmovepro.ILPLI__c = ilpliExam.Id;
        stockmovepro.From_ILPLI__c = ilpli.Id;
        stockmovepro.Product2__c = Pro.Id;
        stockmovepro.Moved_Quantity__c = 1;
        stockmovepro.Stock_Movement__c = stockmove.Id;
        insert stockmovepro;
        system.assertEquals(stockmovepro.ILPLI__c,ilpliExam.Id);
        
        
        //Stock Movement Ends
        
        Sigma_Order__c SO = new Sigma_Order__c();
        SO.AccountId__c = cusAcc.Id;
        SO.Order_Created_Via__c = 'Portal';
        SO.Orders_Status__c = 'Order Confirmed';
        SO.Is_Payment_Made__c = true;
        SO.Billing_Person__c = con.Id;
        SO.Net_Amount__c = 50;
        SO.TotalAmount__c = 61.5;
        SO.Tax_Amount__c = 11.5;
        insert SO;
        System.assertEquals(SO.Tax_Amount__c,11.5);

        Product_Order_Price_Book__c ordrLine = new Product_Order_Price_Book__c();
        ordrLine.Total_Price__c = 61.5;
        ordrLine.Total_Amount__c = 10; 
        ordrLine.tax_amount__c = 11.5;
        ordrLine.Sigma_Order__c = SO.Id;
        ordrLine.Quantity__c = 5;
        ordrLine.Product__c = Pro.Id;
        insert ordrLine;
        System.assertEquals(ordrLine.Quantity__c,5);

        Sales_Order_Allocation__c SOA = new Sales_Order_Allocation__c();
        SOA.Sigma_Order__c = SO.Id;
        SOA.Status__c = 'Pending';
        insert SOA;
        System.assertEquals(SOA.Status__c,'Pending');

        Sales_Order_Allocation_Line_Item__c SOALI = new Sales_Order_Allocation_Line_Item__c();
        SOALI.Allocated_Quantity__c = 5;
        SOALI.Inventory_Location_Product_Line_Item__c = ilpli.Id;
        SOALI.Ordered_Quantity__c = 5;
        SOALI.Order_Line__c = ordrLine.Id;
        SOALI.Remaining_Quantity__c = 0;
        SOALI.Sales_Order_Allocation__c = SOA.Id;
        SOALI.Status__c = 'Pending';
        insert SOALI;
        System.assertEquals(SOALI.Status__c,'Pending');

        Package__c pkg = new Package__c();
        pkg.Customer__c = cusAcc.Id;
        pkg.PackagedBy__c = con.Id;
        pkg.PackagedDate__c = date.today();
        pkg.Location__c = PkgLoc.Id;
        pkg.Status__c = 'Ready';
        insert pkg;
        System.assertEquals(pkg.Status__c,'Ready');
        
        
        
        Package__c pkg1 = new Package__c();
        pkg1.Customer__c = cusAcc.Id;
        pkg1.PackagedBy__c = con.Id;
        pkg1.PackagedDate__c = date.today();
        pkg1.Location__c = PkgLoc.Id;
        pkg1.Status__c = 'Ready';
        insert pkg1;
        System.assertEquals(pkg1.Status__c,'Ready');

        PackagedProducts__c pkgPro = new PackagedProducts__c();
        pkgPro.Package__c = pkg.Id;
        pkgPro.Product_Order__c = ordrLine.Id;
        pkgPro.Status__c = 'Ready';
        pkgPro.Product__c = Pro.Id;
        pkgPro.Quantity__c = 5;
        pkgPro.Sigma_Order__c = SO.Id;
        insert pkgPro;
        System.assertEquals(pkgPro.Status__c,'Ready');

        Package_Product_Line_Item__c ppli = new Package_Product_Line_Item__c();
        ppli.Packaged_Product__c = pkgPro.Id;
        ppli.Quantity__c = 5;
        ppli.Status__c = 'Ready';
        ppli.Location__c = locAcc.Id;
        ppli.Inventory_Location_Product__c = ilp.Id;
        ppli.Inventory_Location_Product_Line_Item__c = ilpli.Id;
        insert ppli;
        System.assertEquals(ppli.Status__c,'Ready');

        Shipment__c ship = new Shipment__c();
        ship.Account__c = logisticsAcc.Id;
        ship.Delivery_Person__c = con.Id;
        ship.Shipment_Date__c = date.today();
        ship.Status__c = 'Delivered';
        insert ship;
         System.assertEquals(ship.Status__c,'Delivered');

        Shipment_Products__c shipPro = new Shipment_Products__c();
        shipPro.Package_ID__c = pkg.Id;
        shipPro.Customer_Name__c = cusAcc.Id;
        shipPro.Status__c = 'Delivered';
        shipPro.Shipment__c = ship.Id;
        shipPro.Shipment_Delivery_Date__c = date.today();
        insert shipPro;
         System.assertEquals(shipPro.Status__c,'Delivered');
         
         
          Shipment_Products__c shipPro1 = new Shipment_Products__c();
        shipPro1.Package_ID__c = pkg.Id;
        shipPro1.Customer_Name__c = cusAcc.Id;
        shipPro1.Status__c = 'Delivered';
        shipPro1.Shipment__c = ship.Id;
        shipPro1.Shipment_Delivery_Date__c = date.today();
        insert shipPro1;
         System.assertEquals(shipPro1.Status__c,'Delivered');

        
         

        Shipment__c shipUP = new Shipment__c();
        shipUP.Account__c = logisticsAcc.Id;
        shipUP.Delivery_Person__c = con.Id;
        shipUP.Shipment_Date__c = date.today();
        shipUP.Status__c = 'Shipped';
        insert shipUP;
         System.assertEquals(shipUP.Status__c,'Shipped');

        Shipment_Products__c shipProUP = new Shipment_Products__c();
        shipProUP.Package_ID__c = pkg.Id;
        shipProUP.Customer_Name__c = cusAcc.Id;
        shipProUP.Status__c = 'Shipped';
        shipProUP.Shipment__c = ship.Id;
        shipProUP.Shipment_Delivery_Date__c = date.today();
        insert shipProUP;
        System.assertEquals(shipProUP.Status__c,'Shipped');

        shipProUP.Status__c = 'Delivered';
        update shipProUP;
        System.assertEquals(shipProUP.Status__c,'Delivered');
      
        Id RIDBOM = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('BOM').getRecordTypeId();
        
        Product2 Pro1 = new Product2();
        Pro1.Name='test';
        Pro1.Product_Description__c='test description';
        Pro1.Product_Price__c=324.34;
        Pro1.Max_Discount__c=30;
        Pro1.Product_Weight__c = 3 ;
        Pro1.SKU__c = 'testing';
        Pro1.Type__c = 'BOM';
        Pro1.Product_UOM__c = 'kg';
        Pro1.Stock_Item__c = true;
        Pro1.Average_Buying_Price__c = 5.4;
        Pro1.RecordtypeId = RIDBOM;
        insert Pro1;
        system.assertEquals(Pro1.RecordtypeId ,RIDBOM);
        
          Recipe__c rcp = new Recipe__c();
        rcp.Name = 'Recipe1';
        rcp.Product__c = Pro1.Id;
        rcp.Quantity__c = 2;
        rcp.Recipe_Type__c = 'Raw Material';
        rcp.Unit_of_Measure__c = 'kg';
        insert rcp; 
        system.assertEquals(rcp.Unit_of_Measure__c ,'kg');
        
        Manufacturing_Run__c mrc = new Manufacturing_Run__c();
        mrc.Manufacturing_Name__c = 'TEST MR123';
        mrc.Recipe__c = rcp.Id;      
        mrc.PI_updated__c = false;
        mrc.Product__c = Pro1.Id;
        mrc.Status__c = 'Planning';
        mrc.Required_Quantity__c = 2;
        mrc.Run_Date__c = system.today() + 1;
        mrc.End_Date__c = System.today() + 9;
        insert mrc;
        system.assertEquals(mrc.Status__c , 'Planning');
        
        List<Inventory_Allocation__c> listallo=new List<Inventory_Allocation__c>();
        Inventory_Allocation__c ia=new Inventory_Allocation__c();
        
        ia.ILPLI__c=ilpliExam.id;
        ia.Packaged_Product__c=pkgPro.id;
        insert ia;
       listallo.add(ia);
        system.assertEquals(ia.ILPLI__c,ilpliExam.id);
        

        
        List<ImportBulkProductForInventory.dataWrap> dwrapList =new List<ImportBulkProductForInventory.dataWrap>();
        ImportBulkProductForInventory.dataWrap dwrap =new ImportBulkProductForInventory.dataWrap();
        dwrap.ilpid =ilpExam.id;
        dwrap.proid =pro.id;
        dwrap.qty =5;
        dwrap.unitprice =50;
        dwrapList.add(dwrap);
        
           List<ImportSerialProductForInventory.dataWrap> dwrapList1 =new List<ImportSerialProductForInventory.dataWrap>();
        ImportSerialProductForInventory.dataWrap dwrap1 =new ImportSerialProductForInventory.dataWrap();
        dwrap1.ilpid =ilpExam.id;
        dwrap1.proid =pro.id;
        dwrap1.qty =5;
        dwrap1.unitprice =50;
        dwrapList1.add(dwrap1);
        Test.startTest();

        //To cover Stock Receiving Flow
        Set<Id> SrpId = new Set<Id>();
            SrpId.add(srp.Id);
        LinkageServiceClass.createSLFromSRP( SrpId );

        //To cover Direct Add ILP Flow
        Set<Id> IlpId = new Set<Id>();
            IlpId.add(ilp.Id);
        LinkageServiceClass.createSLFromILP( IlpId , dwrapList);
        
        LinkageServiceClass.createSLFromILPforSerial( IlpId , dwrapList1);
      
        

        //To cover Stock Receiving Flow
        Set<Id> SrpliId = new Set<Id>();
            SrpliId.add(srpli.Id);
        String SrpliEventType = 'SRPLIInsert';
        LinkageServiceClass.LinkSRPLI( SrpliId,SrpliEventType );

        //To cover Inventory Flow
        Set<Id> IlpliId = new Set<Id>();
            IlpliId.add(ilpli.Id);
        String IlpliEventType = 'ILPLI';
        LinkageServiceClass.LinkILPLI( IlpliId,IlpliEventType );

        //To cover Package Flow
        Set<Id> PpliId = new Set<Id>();
            PpliId.add(ppli.Id);
        String PpliEventType = 'PPLI';
        Map<Id,Id> ShPaMap = new Map<Id,Id>();
        LinkageServiceClass.LinkPPLI( PpliId,PpliEventType,ShPaMap );

        //To cover Allocation Flow
        Set<Id> SoaliId = new Set<Id>();
            SoaliId.add(SOALI.Id);
        String AllocationEventType = 'SOALI';
        LinkageServiceClass.LinkSOALI( SoaliId, AllocationEventType );

        //To cover Shipment Flow
        Map<Id,Id> ShipPackMap = new Map<Id,Id>();
            ShipPackMap.put(shipPro.Id, pkg.Id );
        Set<Id> PkgId = new Set<Id>();
            PkgId.add(pkg.Id);
            
        Map<Id,Id> ShipPackMap1 = new Map<Id,Id>();
            ShipPackMap1.put(shipPro1.Id, pkg1.Id );
        Set<Id> PkgId1 = new Set<Id>();
            PkgId1.add(pkg1.Id);    
            
            
        String ShipEventType = 'SHIP';
         String ShipEventType1 = 'SHIP';
        LinkageServiceClass.LinkShipment( ShipPackMap1, PkgId1, ShipEventType1 );
         
        
        Map<Id,Id> packageids = new Map<Id,Id>();
            packageids.put(shipPro.Id, pkgPro.Id );
        
        
            
            Sigma_Linkage__c slc=new Sigma_Linkage__c();
            slc.Adjusted_Quantity__c=20;
            slc.ILP__c=ilp1.id;
            slc.Manufacturing__c=mrc.id;
            slc.SRP__c=srp.id;
            insert slc;
            update slc;
            system.assertEquals(slc.ILP__c,ilp1.id);
            
            
            
            
            
            Sigma_Linkage_Item__c SLIsource = new Sigma_Linkage_Item__c();
                    SLIsource.Activity_Date_Time__c = system.now();
                    SLIsource.Sigma_Linkage__c = slc.id;
                    SLIsource.Product__c = pro.id;
                    SLIsource.Type__c = 'Inventory';
                    SLIsource.Quantity__c = 100;
                    SLIsource.Inventory_Location_Product_Line_Item__c = ilpliExam.id;
                    SLIsource.SMP__c = stockmovepro.Id;
            insert SLIsource;
            update SLIsource;
            
        
            System.assertEquals( SLIsource.Quantity__c , 100);
            
            
        
        //To cover Stock Adjustment Increase
        List<Stock_Adjustment_Product__c> SAPincList = new List<Stock_Adjustment_Product__c>();
            SAPincList.add( sapinc );
        String SAEventType = 'SAP';
        LinkageServiceClass.LinkSADecrease( SAPincList, SAinc.Id, ilpliId, SAEventType );

        //To cover Stock Adjustment decrease
        List<Stock_Adjustment_Product__c> SAPdecList = new List<Stock_Adjustment_Product__c>();
            SAPdecList.add( sapdec );
        LinkageServiceClass.LinkSADecrease( SAPdecList, SAdec.Id, ilpliId, SAEventType );

        //To cover Stock Movement
        List<Stock_Moment_Product__c> StockMovementProList = new List<Stock_Moment_Product__c>();
            StockMovementProList.add( stockmovepro );
        Set<Id> fromILPLIId = new Set<Id>();
            fromILPLIId.add(ilpli.Id);
        Set<Id> toILPLIId = new Set<Id>();
            toILPLIId.add(ilpliExam.Id);
        String SMEventType = 'SMP';
        
        LinkageServiceClass.LinkStockMovement( StockMovementProList, fromILPLIId, toILPLIId, SMEventType );
        
           Map<id, Inventory_Location_Product__c> ilps=new Map<id, Inventory_Location_Product__c>();
    ilps.put(ilpExam.id,ilpExam);
    
          Map<id, decimal> decIlpli2=new Map<id, decimal>();
    decIlpli2.put(ilpExam.id,2);
        
        Map<Id,Product_Order_Price_Book__c> prodsss=new Map<Id,Product_Order_Price_Book__c>();
        prodsss.put(ordrLine.id,ordrLine);
        
        
    
    
        
        
           LinkageServiceClass.sigmafinanceInboundMRunwrap mrfinance=new LinkageServiceClass.sigmafinanceInboundMRunwrap();
           mrfinance.UnitPrice=100;
           mrfinance.TotalCost=1000;
           mrfinance.producedQty=4;
           mrfinance.MfRun=mrc;
           mrfinance.ILPs=ilps;
           mrfinance.movedQty=decIlpli2;
           
           LinkageServiceClass.sigmafinanceInboundwrap finance=new LinkageServiceClass.sigmafinanceInboundwrap();
           finance.source='src';
           finance.ilpliList=ilplist3;
           finance.MnufcturingDetails=mrfinance;
           
           
    LinkageServiceClass.slInbound(finance);
    LinkageServiceClass.inManufacturing(mrfinance,ilplist3);
    LinkageServiceClass.stockOutbySO(prodsss,listallo,packageids,'vid');
    
        
        Test.stopTest();
    }
    
    @IsTest(seeAllData=false)
    static void directAddInventory() 
    {
    
            ID RID1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
                    
            Account  venAcc =new Account();
            venAcc.Name='TestVendor';
            venAcc.Type='Vendor';
            venAcc.RecordTypeId = RID1;
            venAcc.Email__c = 'Test@test.com';
            insert venAcc;
            System.assertEquals(venAcc.Name,'TestVendor');  

            Default_Parameters__c  dp = new Default_Parameters__c (Name = 'Sample dp',Parent_Id__c = venAcc.Id);
            insert dp;
            System.assertEquals(dp.Name,'Sample dp');

            ID RID3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();

            Account locAcc=new Account();
            locAcc.Name='TestLoc';
            locAcc.Type='Location';
            locAcc.RecordTypeId = RID3;
            locAcc.Email__c = 'Test@test.com';
            insert locAcc;
            System.assertEquals(locAcc.Name,'TestLoc');

            Product2 pro=new  Product2();
            pro.Name='TestPro';
            pro.Buying_Price__c = 10;
            pro.Product_Price__c = 10;
            pro.Stock_Item__c=true;
            insert pro;
             System.assertEquals(pro.Product_Price__c,10);


            Inventory_Location__c il = new Inventory_Location__c(Location__c = locAcc.Id);
            insert il;
             System.assertEquals(il.Location__c,locAcc.Id);

            Inventory__c PI = [select id,Total_Available_Qty__c from Inventory__c where ProductCode__c =: Pro.Id];

            Inventory_Location_Product__c ilp = new Inventory_Location_Product__c(Inventory_Location__c =il.Id,Adjusted_Quantity__c=0, Received_Quantity__c=50,Products__c = Pro.Id, Inventory__c = PI.Id, Delivered_Quantity__c = 0, Stock_Origin__c = 'Direct Add' , Unit_Price__c = 10);
            insert ilp;
             System.assertEquals(ilp.Inventory_Location__c,il.Id);


            Inventory_Location_Product__c ilp2 = new Inventory_Location_Product__c(Inventory_Location__c =il.Id,Adjusted_Quantity__c=0, Received_Quantity__c=50,Products__c = Pro.Id, Inventory__c = PI.Id, Delivered_Quantity__c = 0, Stock_Origin__c = 'Direct Add' , Unit_Price__c = 10);
            insert ilp2;
             System.assertEquals(ilp2.Inventory_Location__c,il.Id); 
             
            Inventory_Location_Product_Line_Item__c ilpli = new Inventory_Location_Product_Line_Item__c();
            ilpli.Inventory_Location__c =il.Id;
            ilpli.Inventory_Location_Product__c = ilp.Id;
            ilpli.Adjusted_Quantity__c = 0;
            ilpli.Received_Quantity__c = 50;
            ilpli.Product__c = Pro.Id;
            ilpli.Stock_Type__c = 'Direct Add';
            ilpli.Delivered_Quantity__c = 0;
            ilpli.Package_Quantity__c =0;
            insert ilpli;
             System.assertEquals(ilpli.Package_Quantity__c,0);
             
            BOM_Line_Item__c bli=new BOM_Line_Item__c();
            bli.Product__c=pro.id;
            bli.Quantity__c=30;
            insert bli;
            System.assertEquals(bli.Quantity__c,30);
            
        
                 
             
            List<ImportBulkProductForInventory.dataWrap> dwrapList =new List<ImportBulkProductForInventory.dataWrap>();
            ImportBulkProductForInventory.dataWrap dwrap =new ImportBulkProductForInventory.dataWrap();
            dwrap.ilpid =ilp.id;
            dwrap.proid =pro.id;
            dwrap.qty =5;
            dwrap.unitprice =50;
            dwrapList.add(dwrap);
            
            
            Test.startTest();

            //To cover Direct Add ILP Flow
            Set<Id> IlpId = new Set<Id>();
                IlpId.add(ilp.Id);
            LinkageServiceClass.createSLFromILP( IlpId, dwrapList);

            //To cover Inventory Flow
            Set<Id> IlpliId = new Set<Id>();
                IlpliId.add(ilpli.Id);
            String IlpliEventType = 'ILPLI';
            LinkageServiceClass.LinkILPLI( IlpliId,IlpliEventType );
            
            Map<id, decimal> decIlpli=new Map<id, decimal>(); // ilpli id,pickqty
            decIlpli.put(ilpli.id,2);
            List<Inventory_Location_Product_Line_Item__c> incILPLI=new List<Inventory_Location_Product_Line_Item__c>();
            incILPLI.add(ilpli);
        
            
            Decimal incBomQty=2;
            Map<Id,Id> BomProds=new Map<Id,Id>();
            BomProds.put(ilpli.id,pro.id);
            LinkageServiceClass.financeIndiviualToBom(decIlpli,incILPLI,ilp2,incBomQty,BomProds);
            
    
    
    
    
    
    Map<id, decimal> decIlpli1=new Map<id, decimal>();
    decIlpli1.put(ilpli.id,2);
    Map<id,Decimal> indprounitPrice=new Map<id,Decimal> ();
    indprounitPrice.put(bli.id,200);
    List<Inventory_Location_Product_Line_Item__c> incILPLI1=new List<Inventory_Location_Product_Line_Item__c>();
    incILPLI1.add(ilpli);
    List<Inventory_Location_Product__c> incILP=new List<Inventory_Location_Product__c> ();
    incILP.add(ilp2);
    Map<Id,Id> BomProd=new Map<Id,Id>();
            BomProd.put(ilpli.id,pro.id);
    Map<id,Decimal> updateIndQty=new Map<id,Decimal> ();
    updateIndQty.put(bli.id,20);
    LinkageServiceClass.financeBomToIndiviual(decIlpli1,indprounitPrice,incILPLI1,incILP,BomProd,updateIndQty);
    
    Test.stopTest();
    }
    

    @IsTest(seeAllData=false)
    static void methodthree() 
    {
        
        Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();

        ID RID1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
               
        Account  venAcc =new Account();
        venAcc.Name='TestVendor';
        venAcc.Type='Vendor';
        venAcc.RecordTypeId = RID1;
        venAcc.Email__c = 'Test@test.com';
        insert venAcc;
        System.assertEquals(venAcc.Name,'TestVendor');  


        ID RID3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();

        Account locAcc=new Account();
        locAcc.Name='Hubli';
        locAcc.Type='Location';
        locAcc.RecordTypeId = RID3;
        locAcc.Email__c = 'Test@test.com';
        insert locAcc;
        System.assertEquals(locAcc.Name,'Hubli');
        
        Account ExamLocAcc=new Account();
        ExamLocAcc.Name='Dharwad';
        ExamLocAcc.Type='Location';
        ExamLocAcc.RecordTypeId = RID3;
        ExamLocAcc.Email__c = 'Test@test.com';
        insert ExamLocAcc;
        System.assertEquals(ExamLocAcc.Name,'Dharwad');

        ID RID4 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account cusAcc = new Account();
        cusAcc.Name='Rashmi';
        cusAcc.Type='Customer';
        cusAcc.RecordTypeId = RID4;
        cusAcc.Base_Credit_Limit__c = 10000000.00;
        cusAcc.Customer_Type__c = 'Credit Customer';
        cusAcc.Email__c = 'Test@test.com';
        insert cusAcc;
        System.assertEquals(cusAcc.Name,'Rashmi');  

        Account PkgLoc = new Account();
        PkgLoc.Name='Mangalore';
        PkgLoc.Type='Packaged Location';
        PkgLoc.Email__c = 'Test@test.com';
        insert PkgLoc;
        System.assertEquals(PkgLoc.Name,'Mangalore'); 

        Account  logisticsAcc=new Account();
        logisticsAcc.Name='TestLogistics';
        logisticsAcc.Type='Logistics';
        logisticsAcc.Email__c = 'Test@test.com';
        insert logisticsAcc;
        System.assertEquals(logisticsAcc.Name,'TestLogistics');

        Contact  con=new Contact();
        con.FirstName='TestCon';
        con.LastName='TestCon';
        con.AccountId=venAcc.Id;
        con.phone ='1234567890';
        insert con;
        System.assertEquals(con.FirstName,'TestCon');

        Default_Parameters__c  dp = new Default_Parameters__c (Name = 'Sample dp',Parent_Id__c = venAcc.Id);
        insert dp;
        System.assertEquals(dp.Name,'Sample dp');

        Product2 pro=new  Product2();
        pro.Name='TestPro';
        pro.Buying_Price__c = 10;
        pro.Product_Price__c = 10;
        pro.Stock_Item__c=true;
        insert pro;
        System.assertEquals(pro.Name,'TestPro');


        Vendor_Product__c vp = new Vendor_Product__c();
        vp.Account_Name__c = venAcc.Id;
        vp.Product_Name__c = pro.Id;
        vp.Duty__c = 1;
        vp.Freight__c = 1;
        vp.Insurance__c = 1;
        vp.Other__c = 1;
        vp.Buying_Price__c = 10;
        vp.Is_Preferred__c = true;
        insert vp;
        System.assertEquals(vp.Other__c,1);
        
        Purchase_Order__c  pord=new  Purchase_Order__c();
        pord.Product_Supplier__c=venAcc.Id;
        pord.Order_Date__c=date.today();
        pord.Expected_Date__c =date.today() + 1;
        pord.Status__c='Submitted';
        insert pord;
        System.assertEquals(pord.Status__c,'Submitted');

        Purchase_Order_Product__c porderp=new  Purchase_Order_Product__c();
        porderp.Purchase_Order__c=pord.Id;
        porderp.Status__c='Open';
        porderp.Quantity__c='50';
        porderp.Expected_Delivery_Date__c=date.today();  
        porderp.Buying_Price__c=10;
        porderp.Received_Quantity__c = 50;
        porderp.Product__c = pro.Id;
        insert porderp;
        System.assertEquals(porderp.Status__c,'Open');

        Stock_In__c sr = new Stock_In__c();
        sr.Delivery_Person__c=con.Id;
        sr.Received_Date_Time__c = date.today();
        sr.Location__c=locAcc.Id;
        sr.Status__c='Open';
        sr.Truck_Number__c='DNTKNW838';
        sr.Vendor__c=venAcc.Id;
        insert sr;

        System.assertEquals(sr.Status__c,'Open');
        Stock_In_Product__c srp = new Stock_In_Product__c();
        srp.Quantity_Received__c=50;
        srp.Returned_Quantity__c=0;
        srp.Putaway_location__c=locAcc.Id;
        srp.Status__c='Verified';
        srp.Stock_In__c = sr.Id;
        srp.Product__c = pro.Id;
        srp.Pur_Order__c = pord.Id;
        srp.Purchase_Order__c = porderp.Id;
        insert srp;
        System.assertEquals(srp.Status__c,'Verified');

        Stock_Receiving_Product_Line_Item__c srpli = new Stock_Receiving_Product_Line_Item__c();
        srpli.Product__c = pro.Id;
        srpli.Purchase_Order_Product__c = porderp.Id;
        srpli.Received_Quantity__c = 50;
        srpli.Stock_Receiving_Product__c = srp.Id;
        srpli.Total_Buying_Price__c = 500;
        insert srpli;
        System.assertEquals(srpli.Total_Buying_Price__c,500);

        srpli.Received_Quantity__c = 60;
        update srpli;
        System.assertEquals(srpli.Received_Quantity__c,60);
        
        Inventory_Location__c il = new Inventory_Location__c(Location__c = locAcc.Id);
        insert il;
        System.assertEquals(il.Location__c,locAcc.Id);

        Inventory__c PI = [select id,Total_Available_Qty__c from Inventory__c where ProductCode__c =: Pro.Id];

        Inventory_Location_Product__c ilp = new Inventory_Location_Product__c(Inventory_Location__c =il.Id,Adjusted_Quantity__c=0, Received_Quantity__c=50,Products__c = Pro.Id, Inventory__c = PI.Id, Delivered_Quantity__c = 0, Stock_Origin__c = 'Stock Receiving' );
        insert ilp;
        System.assertEquals(ilp.Inventory_Location__c,il.Id);
        
        Inventory_Location_Product__c ilp1 = new Inventory_Location_Product__c(Inventory_Location__c =il.Id,Adjusted_Quantity__c=0, Received_Quantity__c=50,Products__c = Pro.Id, Inventory__c = PI.Id, Delivered_Quantity__c = 0, Stock_Origin__c = 'Stock Receiving' );
        insert ilp1;
        System.assertEquals(ilp1.Inventory_Location__c,il.Id);

        Inventory_Location_Product_Line_Item__c ilpli = new Inventory_Location_Product_Line_Item__c();
        ilpli.Inventory_Location__c =il.Id;
        ilpli.Inventory_Location_Product__c = ilp.Id;
        ilpli.Stock_Receiving_Product__c = srp.Id;
        ilpli.Adjusted_Quantity__c = 0;
        ilpli.Received_Quantity__c = 50;
        ilpli.Product__c = Pro.Id;
        ilpli.Stock_Type__c = 'Stock Receiving';
        ilpli.Delivered_Quantity__c = 0;
        ilpli.Package_Quantity__c =0;
        insert ilpli;
        System.assertEquals(ilpli.Stock_Type__c,'Stock Receiving');
        
       
        Inventory_Location_Product_Line_Item__c ilpli2 = new Inventory_Location_Product_Line_Item__c();
        ilpli2.Inventory_Location__c =il.Id;
        ilpli2.Inventory_Location_Product__c = ilp.Id;
        ilpli2.Stock_Receiving_Product__c = srp.Id;
        ilpli2.Adjusted_Quantity__c = 0;
        ilpli2.Received_Quantity__c = 50;
        ilpli2.Product__c = Pro.Id;
        ilpli2.Stock_Type__c = 'Stock Receiving';
        ilpli2.Delivered_Quantity__c = 0;
        ilpli2.Package_Quantity__c =0;
        insert ilpli2;
        System.assertEquals(ilpli2.Stock_Type__c,'Stock Receiving');
       
        //Stock Adjustment - Decrease Starts
        StockAdjustment__c SAdec = new StockAdjustment__c();
        SAdec.Inventory_Location_Product__c = ilp.Id;
        SAdec.Original_Qty__c = 100;
        SAdec.Adjusted_Qty__c = 2;
        SAdec.Date__c = system.TODAY();
        SAdec.Reason_Code__c ='Expired Stocks';
        SAdec.Adjust_Type__c = 'Reduce Stock';
        insert SAdec;
        system.assertEquals(SAdec.Inventory_Location_Product__c,ilp.Id);
        
        Stock_Adjustment_Product__c sapdec = new Stock_Adjustment_Product__c ();
        sapdec.Adjusted_Quantity__c = 1;
        sapdec.ILPLI__c = ilpli.Id;
        sapdec.Product__c = Pro.Id;
        sapdec.Stock_Adjustment__c = SAdec.Id;
        insert sapdec;
        system.assertEquals(sapdec.Product__c,Pro.Id);
        
       
        //Stock Adjustment - Increase Starts
        StockAdjustment__c SAinc = new StockAdjustment__c();
        SAinc.Inventory_Location_Product__c = ilp.Id;
        SAinc.Original_Qty__c = 100;
        SAinc.Adjusted_Qty__c = 2;
        SAinc.Date__c = system.TODAY();
        SAinc.Reason_Code__c ='Expired Stocks';
        SAinc.Adjust_Type__c = 'Increase Stock';
        insert SAinc;
        system.assertEquals(SAinc.Inventory_Location_Product__c,ilp.Id);
        
        Stock_Adjustment_Product__c sapinc = new Stock_Adjustment_Product__c ();
        sapinc.Adjusted_Quantity__c = 1;
        sapinc.ILPLI__c = ilpli2.Id;
        sapinc.Product__c = Pro.Id;
        sapinc.Stock_Adjustment__c = SAinc.Id;
        insert sapinc;
        system.assertEquals(sapinc.Product__c,Pro.Id);
        
        
        //Stock Movement Starts
        
        Inventory_Location__c ExamLoc = new Inventory_Location__c(Location__c = ExamLocAcc.Id);
        insert ExamLoc;
        System.assertEquals(ExamLoc.Location__c,ExamLocAcc.Id);
        
        Inventory_Location_Product__c ilpExam = new Inventory_Location_Product__c(Inventory_Location__c =ExamLoc.Id,Adjusted_Quantity__c=0, Received_Quantity__c=50,Products__c = Pro.Id, Inventory__c = PI.Id, Delivered_Quantity__c = 0, Stock_Origin__c = 'Stock Receiving' );
        insert ilpExam;
        System.assertEquals(ilpExam.Inventory_Location__c,ExamLoc.Id);

        List<Inventory_Location_Product_Line_Item__c> ilplist3=new List<Inventory_Location_Product_Line_Item__c>();
        Inventory_Location_Product_Line_Item__c ilpliExam = new Inventory_Location_Product_Line_Item__c();
        ilpliExam.Inventory_Location__c =ExamLoc.Id;
        ilpliExam.Inventory_Location_Product__c = ilpExam.Id;
        ilpliExam.Stock_Receiving_Product__c = srp.Id;
        ilpliExam.Adjusted_Quantity__c = 0;
        ilpliExam.Received_Quantity__c = 50;
        ilpliExam.Product__c = Pro.Id;
        ilpliExam.Stock_Type__c = 'Moved IN';
        ilpliExam.Delivered_Quantity__c = 0;
        ilpliExam.Package_Quantity__c =0;
        insert ilpliExam;
        System.assertEquals(ilpliExam.Stock_Type__c,'Moved IN');
        ilplist3.add(ilpliExam);
        
        StockMovement__c stockmove = new StockMovement__c();
        stockmove.From_Location__c = il.Id;
        insert stockmove;
        system.assertEquals(stockmove.From_Location__c,il.Id);
        
        Stock_Moment_Product__c stockmovepro1 = new Stock_Moment_Product__c ();
        stockmovepro1.Moved_Location__c = ExamLoc.Id;
        stockmovepro1.Inventory_Location_Product__c = ilpExam.Id;
        stockmovepro1.ILPLI__c = ilpliExam.Id;
       stockmovepro1.From_ILPLI__c = ilpli.Id;
        stockmovepro1.Product2__c = Pro.Id;
        stockmovepro1.Moved_Quantity__c = 1;
        stockmovepro1.Stock_Movement__c = stockmove.Id;
        insert stockmovepro1;
        system.assertEquals(stockmovepro1.ILPLI__c,ilpliExam.Id);
        
        Stock_Moment_Product__c stockmovepro = new Stock_Moment_Product__c ();
        stockmovepro.Moved_Location__c = ExamLoc.Id;
        stockmovepro.Inventory_Location_Product__c = ilpExam.Id;
        stockmovepro.ILPLI__c = ilpliExam.Id;
        stockmovepro.From_ILPLI__c = ilpli.Id;
        stockmovepro.Product2__c = Pro.Id;
        stockmovepro.Moved_Quantity__c = 1;
        stockmovepro.Stock_Movement__c = stockmove.Id;
        insert stockmovepro;
        system.assertEquals(stockmovepro.ILPLI__c,ilpliExam.Id);
        
        
        //Stock Movement Ends
        
        Sigma_Order__c SO = new Sigma_Order__c();
        SO.AccountId__c = cusAcc.Id;
        SO.Order_Created_Via__c = 'Portal';
        SO.Orders_Status__c = 'Order Confirmed';
        SO.Is_Payment_Made__c = true;
        SO.Billing_Person__c = con.Id;
        SO.Net_Amount__c = 50;
        SO.TotalAmount__c = 61.5;
        SO.Tax_Amount__c = 11.5;
        insert SO;
        System.assertEquals(SO.Tax_Amount__c,11.5);

        Product_Order_Price_Book__c ordrLine = new Product_Order_Price_Book__c();
        ordrLine.Total_Price__c = 61.5;
        ordrLine.Total_Amount__c = 10; 
        ordrLine.tax_amount__c = 11.5;
        ordrLine.Sigma_Order__c = SO.Id;
        ordrLine.Quantity__c = 5;
        ordrLine.Product__c = Pro.Id;
        insert ordrLine;
        System.assertEquals(ordrLine.Quantity__c,5);

        Sales_Order_Allocation__c SOA = new Sales_Order_Allocation__c();
        SOA.Sigma_Order__c = SO.Id;
        SOA.Status__c = 'Pending';
        insert SOA;
        System.assertEquals(SOA.Status__c,'Pending');

        Sales_Order_Allocation_Line_Item__c SOALI = new Sales_Order_Allocation_Line_Item__c();
        SOALI.Allocated_Quantity__c = 5;
        SOALI.Inventory_Location_Product_Line_Item__c = ilpli.Id;
        SOALI.Ordered_Quantity__c = 5;
        SOALI.Order_Line__c = ordrLine.Id;
        SOALI.Remaining_Quantity__c = 0;
        SOALI.Sales_Order_Allocation__c = SOA.Id;
        SOALI.Status__c = 'Pending';
        insert SOALI;
        System.assertEquals(SOALI.Status__c,'Pending');

        Package__c pkg = new Package__c();
        pkg.Customer__c = cusAcc.Id;
        pkg.PackagedBy__c = con.Id;
        pkg.PackagedDate__c = date.today();
        pkg.Location__c = PkgLoc.Id;
        pkg.Status__c = 'Ready';
        insert pkg;
        System.assertEquals(pkg.Status__c,'Ready');

        PackagedProducts__c pkgPro = new PackagedProducts__c();
        pkgPro.Package__c = pkg.Id;
        pkgPro.Product_Order__c = ordrLine.Id;
        pkgPro.Status__c = 'Ready';
        pkgPro.Product__c = Pro.Id;
        pkgPro.Quantity__c = 5;
        pkgPro.Sigma_Order__c = SO.Id;
        insert pkgPro;
        System.assertEquals(pkgPro.Status__c,'Ready');

        Package_Product_Line_Item__c ppli = new Package_Product_Line_Item__c();
        ppli.Packaged_Product__c = pkgPro.Id;
        ppli.Quantity__c = 5;
        ppli.Status__c = 'Ready';
        ppli.Location__c = locAcc.Id;
        ppli.Inventory_Location_Product__c = ilp.Id;
        ppli.Inventory_Location_Product_Line_Item__c = ilpli.Id;
        insert ppli;
        System.assertEquals(ppli.Status__c,'Ready');

        Shipment__c ship = new Shipment__c();
        ship.Account__c = logisticsAcc.Id;
        ship.Delivery_Person__c = con.Id;
        ship.Shipment_Date__c = date.today();
        ship.Status__c = 'Delivered';
        insert ship;
         System.assertEquals(ship.Status__c,'Delivered');

        Shipment_Products__c shipPro = new Shipment_Products__c();
        shipPro.Package_ID__c = pkg.Id;
        shipPro.Customer_Name__c = cusAcc.Id;
        shipPro.Status__c = 'Delivered';
        shipPro.Shipment__c = ship.Id;
        shipPro.Shipment_Delivery_Date__c = date.today();
        insert shipPro;
         System.assertEquals(shipPro.Status__c,'Delivered');

        Shipment__c shipUP = new Shipment__c();
        shipUP.Account__c = logisticsAcc.Id;
        shipUP.Delivery_Person__c = con.Id;
        shipUP.Shipment_Date__c = date.today();
        shipUP.Status__c = 'Shipped';
        insert shipUP;
         System.assertEquals(shipUP.Status__c,'Shipped');

        Shipment_Products__c shipProUP = new Shipment_Products__c();
        shipProUP.Package_ID__c = pkg.Id;
        shipProUP.Customer_Name__c = cusAcc.Id;
        shipProUP.Status__c = 'Shipped';
        shipProUP.Shipment__c = ship.Id;
        shipProUP.Shipment_Delivery_Date__c = date.today();
        insert shipProUP;
        System.assertEquals(shipProUP.Status__c,'Shipped');

        shipProUP.Status__c = 'Delivered';
        update shipProUP;
        System.assertEquals(shipProUP.Status__c,'Delivered');
      
        Id RIDBOM = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('BOM').getRecordTypeId();
        
        Product2 Pro1 = new Product2();
        Pro1.Name='test';
        Pro1.Product_Description__c='test description';
        Pro1.Product_Price__c=324.34;
        Pro1.Max_Discount__c=30;
        Pro1.Product_Weight__c = 3 ;
        Pro1.SKU__c = 'testing';
        Pro1.Type__c = 'BOM';
        Pro1.Product_UOM__c = 'kg';
        Pro1.Stock_Item__c = true;
        Pro1.Average_Buying_Price__c = 5.4;
        Pro1.RecordtypeId = RIDBOM;
        insert Pro1;
        system.assertEquals(Pro1.RecordtypeId ,RIDBOM);
        
          Recipe__c rcp = new Recipe__c();
        rcp.Name = 'Recipe1';
        rcp.Product__c = Pro1.Id;
        rcp.Quantity__c = 2;
        rcp.Recipe_Type__c = 'Raw Material';
        rcp.Unit_of_Measure__c = 'kg';
        insert rcp; 
        system.assertEquals(rcp.Unit_of_Measure__c ,'kg');
        
        Manufacturing_Run__c mrc = new Manufacturing_Run__c();
        mrc.Manufacturing_Name__c = 'TEST MR123';
        mrc.Recipe__c = rcp.Id;      
        mrc.PI_updated__c = false;
        mrc.Product__c = Pro1.Id;
        mrc.Status__c = 'Planning';
        mrc.Required_Quantity__c = 2;
        mrc.Run_Date__c = system.today() + 1;
        mrc.End_Date__c = System.today() + 9;
        insert mrc;
        system.assertEquals(mrc.Status__c , 'Planning');
        
        List<Inventory_Allocation__c> listallo=new List<Inventory_Allocation__c>();
        Inventory_Allocation__c ia=new Inventory_Allocation__c();
        
        ia.ILPLI__c=ilpliExam.id;
        ia.Packaged_Product__c=pkgPro.id;
        insert ia;
       listallo.add(ia);
        system.assertEquals(ia.ILPLI__c,ilpliExam.id);
        

        
        List<ImportBulkProductForInventory.dataWrap> dwrapList =new List<ImportBulkProductForInventory.dataWrap>();
        ImportBulkProductForInventory.dataWrap dwrap =new ImportBulkProductForInventory.dataWrap();
        dwrap.ilpid =ilpExam.id;
        dwrap.proid =pro.id;
        dwrap.qty =5;
        dwrap.unitprice =50;
        dwrapList.add(dwrap);
        
           List<ImportSerialProductForInventory.dataWrap> dwrapList1 =new List<ImportSerialProductForInventory.dataWrap>();
        ImportSerialProductForInventory.dataWrap dwrap1 =new ImportSerialProductForInventory.dataWrap();
        dwrap1.ilpid =ilpExam.id;
        dwrap1.proid =pro.id;
        dwrap1.qty =5;
        dwrap1.unitprice =50;
        dwrapList1.add(dwrap1);
        Test.startTest();

        //To cover Stock Receiving Flow
        Set<Id> SrpId = new Set<Id>();
            SrpId.add(srp.Id);
        LinkageServiceClass.createSLFromSRP( SrpId );

        //To cover Direct Add ILP Flow
        Set<Id> IlpId = new Set<Id>();
            IlpId.add(ilp.Id);
        LinkageServiceClass.createSLFromILP( IlpId , dwrapList);
        
        LinkageServiceClass.createSLFromILPforSerial( IlpId , dwrapList1);
      
        

        //To cover Stock Receiving Flow
        Set<Id> SrpliId = new Set<Id>();
            SrpliId.add(srpli.Id);
        String SrpliEventType = 'SRPLIUpdate';
        LinkageServiceClass.LinkSRPLI( SrpliId,SrpliEventType );

        //To cover Inventory Flow
        Set<Id> IlpliId = new Set<Id>();
            IlpliId.add(ilpli.Id);
        String IlpliEventType = 'ILPLI';
        LinkageServiceClass.LinkILPLI( IlpliId,IlpliEventType );

        //To cover Package Flow
        Set<Id> PpliId = new Set<Id>();
            PpliId.add(ppli.Id);
        String PpliEventType = 'SHIP';
        Map<Id,Id> ShPaMap = new Map<Id,Id>();
        LinkageServiceClass.LinkPPLI( PpliId,PpliEventType,ShPaMap );

        //To cover Allocation Flow
        Set<Id> SoaliId = new Set<Id>();
            SoaliId.add(SOALI.Id);
        String AllocationEventType = 'SOALI';
        LinkageServiceClass.LinkSOALI( SoaliId, AllocationEventType );

        //To cover Shipment Flow
        Map<Id,Id> ShipPackMap = new Map<Id,Id>();
            ShipPackMap.put(shipPro.Id, pkg.Id );
        Set<Id> PkgId = new Set<Id>();
            PkgId.add(pkg.Id);
        String ShipEventType = 'SHIP';
        LinkageServiceClass.LinkShipment( ShipPackMap, PkgId, ShipEventType );
        
        Map<Id,Id> packageids = new Map<Id,Id>();
            packageids.put(shipPro.Id, pkgPro.Id );
        
        
            
            Sigma_Linkage__c slc=new Sigma_Linkage__c();
            slc.Adjusted_Quantity__c=20;
            slc.ILP__c=ilp1.id;
            slc.Manufacturing__c=mrc.id;
            slc.SRP__c=srp.id;
            slc.Packaged_Quantity__c=30;
            slc.Delivered_Quantity__c=20;
            slc.Stock_Origin__c ='Stock Receiving';
            insert slc;
            system.assertEquals(slc.ILP__c,ilp1.id);
            
            
            
            
            
            Sigma_Linkage_Item__c SLIsource = new Sigma_Linkage_Item__c();
                    SLIsource.Activity_Date_Time__c = system.now();
                    SLIsource.Sigma_Linkage__c = slc.id;
                    SLIsource.Product__c = pro.id;
                    SLIsource.Type__c = 'Stock OUT';
                    SLIsource.Quantity__c = 100;
                    SLIsource.Inventory_Location_Product_Line_Item__c = ilpliExam.id;
                    SLIsource.SMP__c = stockmovepro.Id;
                
            insert SLIsource;
            System.assertEquals( SLIsource.Quantity__c , 100);
            
            
        
        //To cover Stock Adjustment Increase
        List<Stock_Adjustment_Product__c> SAPincList = new List<Stock_Adjustment_Product__c>();
            SAPincList.add( sapinc );
        String SAEventType = 'SAP';
        LinkageServiceClass.LinkSADecrease( SAPincList, SAinc.Id, ilpliId, SAEventType );

        //To cover Stock Adjustment decrease
        List<Stock_Adjustment_Product__c> SAPdecList = new List<Stock_Adjustment_Product__c>();
            SAPdecList.add( sapdec );
        LinkageServiceClass.LinkSADecrease( SAPdecList, SAdec.Id, ilpliId, SAEventType );

        //To cover Stock Movement
        List<Stock_Moment_Product__c> StockMovementProList = new List<Stock_Moment_Product__c>();
            StockMovementProList.add( stockmovepro );
        Set<Id> fromILPLIId = new Set<Id>();
            fromILPLIId.add(ilpli.Id);
        Set<Id> toILPLIId = new Set<Id>();
            toILPLIId.add(ilpliExam.Id);
        String SMEventType = 'SMP';
        
        LinkageServiceClass.LinkStockMovement( StockMovementProList, fromILPLIId, toILPLIId, SMEventType );
        
           Map<id, Inventory_Location_Product__c> ilps=new Map<id, Inventory_Location_Product__c>();
    ilps.put(ilpExam.id,ilpExam);
    
          Map<id, decimal> decIlpli2=new Map<id, decimal>();
    decIlpli2.put(ilpExam.id,2);
        
        Map<Id,Product_Order_Price_Book__c> prodsss=new Map<Id,Product_Order_Price_Book__c>();
        prodsss.put(ordrLine.id,ordrLine);
        
        
    
    
        
        
           LinkageServiceClass.sigmafinanceInboundMRunwrap mrfinance=new LinkageServiceClass.sigmafinanceInboundMRunwrap();
           mrfinance.UnitPrice=100;
           mrfinance.TotalCost=1000;
           mrfinance.producedQty=4;
           mrfinance.MfRun=mrc;
           mrfinance.ILPs=ilps;
           mrfinance.movedQty=decIlpli2;
           
           LinkageServiceClass.sigmafinanceInboundwrap finance=new LinkageServiceClass.sigmafinanceInboundwrap();
           finance.source='src';
           finance.ilpliList=ilplist3;
           finance.MnufcturingDetails=mrfinance;
           
           
    LinkageServiceClass.slInbound(finance);
    LinkageServiceClass.inManufacturing(mrfinance,ilplist3);
    LinkageServiceClass.stockOutbySO(prodsss,listallo,packageids,'vid');
    }
    
    
}