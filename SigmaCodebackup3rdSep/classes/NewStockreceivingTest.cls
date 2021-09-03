@isTest
public class NewStockreceivingTest
{
    @IsTest(seeAllData=false)
    public static  void configValues()
    {
        Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
       
        ID RID1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        Account  acc=new Account();
        acc.Name='rashmi';
        acc.Type='Vendor';
        acc.Email__c = 'cus@gmail.com';
        acc.RecordTypeId = RID1;
        insert acc;
        System.assertEquals(acc.Name,'rashmi'); 

        Account  acc1=new Account();
        acc1.Name='dharwad';
        acc1.Type='Receiving Location';
        acc1.Active__c = 'Yes';
        acc1.Email__c = 'cus@gmail.com';
        insert acc1;
        System.assertEquals(acc1.Name,'dharwad'); 

        ID RID3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();
        Account  acc2=new Account();
        acc2.Name='Belagavi';
        acc2.Type='Location';
        acc2.RecordTypeId = RID3;
        acc2.Active__c = 'Yes';
        insert acc2;
        System.assertEquals(acc2.Name,'Belagavi');

        Sublevel_location__c sulLevelObj = new Sublevel_location__c();
        sulLevelObj.RecordTypeId = Schema.SObjectType.Sublevel_location__c.getRecordTypeInfosByName().get('Zone').getRecordTypeId();
        sulLevelObj.Name = 'Zone1';
        sulLevelObj.Location__c = acc2.Id;
        insert sulLevelObj;
        System.assertEquals(sulLevelObj.Name ,'Zone1');
        
        Sublevel_location__c sulLevelBinObj = new Sublevel_location__c();
        sulLevelBinObj.RecordTypeId = Schema.SObjectType.Sublevel_location__c.getRecordTypeInfosByName().get('Bin').getRecordTypeId();
        sulLevelBinObj.Name = 'Bin1';
        sulLevelBinObj.zone__c = sulLevelObj.Id;
        insert sulLevelBinObj;
        System.assertEquals(sulLevelBinObj.Name,'Bin1');
        
        Sublevel_location__c sulLevelObj1 = new Sublevel_location__c();
        sulLevelObj1.RecordTypeId = Schema.SObjectType.Sublevel_location__c.getRecordTypeInfosByName().get('Zone').getRecordTypeId();
        sulLevelObj1.Name = 'Zone2';
        sulLevelObj1.Location__c = acc2.Id;
        insert sulLevelObj1;
        System.assertEquals(sulLevelObj1.Name , 'Zone2');
        
        Sublevel_location__c sulLevelBinObj2 = new Sublevel_location__c();
        sulLevelBinObj2.RecordTypeId = Schema.SObjectType.Sublevel_location__c.getRecordTypeInfosByName().get('Bin').getRecordTypeId();
        sulLevelBinObj2.Name = 'Bin2';
        sulLevelBinObj2.zone__c = sulLevelObj1.Id;
        insert sulLevelBinObj2;   
        System.assertEquals(sulLevelBinObj2.Name ,'Bin2');      
        
        Contact  con=new Contact();
        con.FirstName='Harish';
        con.LastName='Naik';
        con.AccountId=acc.Id;
        con.phone ='1234567890';
        insert con;
        System.assertEquals(con.FirstName,'Harish');

        Default_Parameters__c  dp = new Default_Parameters__c (Name = 'Sample dp',Parent_Id__c = acc.Id);
        insert dp;
        System.assertEquals(dp.Name,'Sample dp');

        //Product 1
        Product2  pro=new  Product2();
        pro.Name='Books01';
        pro.Attribute_Type__c='SERIALIZED';
        insert pro;
        System.assertEquals(pro.Name,'Books01');

        Vendor_Product__c vp  = new Vendor_Product__c();
        vp.Product_Name__c = pro.id;
        vp.Account_Name__c = acc.Id;
        vp.Buying_Price__c = 200;
        vp.Is_Preferred__c=true;
        insert vp;
        system.assertEquals(pro.id,vp.Product_Name__c);
        

        Purchase_Order__c  pord=new  Purchase_Order__c();
        pord.Product_Supplier__c=acc.Id;
        pord.Order_Date__c=date.today();
        pord.Status__c='Submitted';
        insert pord;
        System.assertEquals(pord.Status__c,'Submitted');

        Purchase_Order_Product__c porderp=new  Purchase_Order_Product__c();
        porderp.Purchase_Order__c=pord.Id;
        porderp.Product__c=pro.id;
        porderp.Status__c='Open';
        porderp.Quantity__c='10';
        porderp.Received_Quantity__c=10;
        porderp.Expected_Delivery_Date__c=date.today();  
        porderp.Buying_Price__c=89;
        insert porderp;
        System.assertEquals(porderp.Status__c,'Open');

        //Product Inventory
        Inventory__c PI = new Inventory__c();
        PI.ProductCode__c=pro.id;
        PI.Available_Qty__c = 10;
        insert PI;
        System.assertEquals(PI.Available_Qty__c,10);
       
        Id RIDBOM = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('BOM').getRecordTypeId();
        //Product 2
        Product2  pro1=new  Product2();
        pro1.Name='Books01';
        pro1.Product_Description__c='Books01 description';
        pro1.Product_Price__c=324.34;
        pro1.Max_Discount__c=30;
        pro1.Product_Weight__c = 3 ;
        pro1.Product_Bar_Code__c='Books123456';
        pro1.SKU__c = 'testing';
        pro1.Type__c = 'BOM';
        pro1.Attribute_Type__c='SERIALIZED';
        pro1.Has_Expiry_Date__c=true;
        pro1.RecordtypeId = RIDBOM;
        insert pro1;
        System.assertEquals(pro1.name, 'Books01');

        //Product 3
        Product2  pro2=new  Product2();
        pro2.Name='Lenovo-S850';
        pro2.Product_Description__c='Lenovo-S850 description';
        pro2.Product_Price__c=324.34;
        pro2.Max_Discount__c=30;
        pro2.Product_Weight__c = 3 ;
        pro2.Product_Bar_Code__c='LenovoS850111';
        pro2.SKU__c = 'testpro';
        pro2.Type__c = 'BOM';
        pro2.Attribute_Type__c='BULK';
        pro2.Has_Expiry_Date__c=true;
        pro2.RecordtypeId = RIDBOM;
        insert pro2;
        System.assertEquals(pro2.name, 'Lenovo-S850');
        
        Vendor_Product__c vp1  = new Vendor_Product__c();
        vp1.Product_Name__c = pro1.id;
        vp1.Account_Name__c = acc.Id;
        vp1.Buying_Price__c = 200;
        vp1.Is_Preferred__c=true;
        insert vp1;
        system.assertEquals(pro1.id,vp1.Product_Name__c);
        
        Vendor_Product__c vp2  = new Vendor_Product__c();
        vp2.Product_Name__c = pro2.id;
        vp2.Account_Name__c = acc.Id;
        vp2.Buying_Price__c = 200;
        vp2.Is_Preferred__c=true;
        insert vp2;
        system.assertEquals(pro2.id,vp2.Product_Name__c);

        Inventory__c inv1 = new Inventory__c();
        inv1.ProductCode__c = pro1.Id;
        inv1.Available_Qty__c = 100;
        insert inv1;
        system.assertEquals(inv1.ProductCode__c,pro1.Id);
        
        Inventory_Location__c invloc2 = new Inventory_Location__c(Location__c = acc2.Id);
        insert invloc2;
        system.assertEquals(invloc2.Location__c,acc2.Id);
        
        Inventory_Location__c invloc3 = new Inventory_Location__c(Location__c = acc2.Id);
        insert invloc3;
        system.assertEquals(invloc3.Location__c,acc2.Id);
        
        Inventory__c inv2 = new Inventory__c();
        inv2.ProductCode__c = pro2.Id;
        inv2.Available_Qty__c = 100;
        insert inv2;
        system.assertEquals(inv2.ProductCode__c,pro2.Id);
        
        Inventory_Location__c invloc4 = new Inventory_Location__c(Location__c = acc2.Id);
        insert invloc4;
        system.assertEquals(invloc4.Location__c,acc2.Id);
        
        
        //Product Inventory
        Inventory__c PI1 = new Inventory__c();
        PI1.ProductCode__c=pro1.id;
        PI1.Available_Qty__c = 10;
        insert PI1;
        System.assertEquals(PI1.Available_Qty__c,10);
        
        //Product Inventory
        Inventory__c PI2 = new Inventory__c();
        PI2.ProductCode__c=pro2.id;
        PI2.Available_Qty__c = 10;
        insert PI2;
        System.assertEquals(PI2.Available_Qty__c,10);
        
        Purchase_Order__c  pord1=new  Purchase_Order__c();
        pord1.Product_Supplier__c=acc.Id;
        pord1.Order_Date__c=date.today();
        pord1.Status__c='Open';
        insert pord1;
        System.assertEquals(pord1.Status__c,'Open');

        Id transID1 =pord.Id;
        Id transID2=pord1.Id;
        
        Purchase_Order_Product__c porderp1=new  Purchase_Order_Product__c();
        porderp1.Purchase_Order__c=transID2;
        porderp1.Product__c=pro.id;
        porderp1.Status__c='Open';
        porderp1.Quantity__c='10';
        porderp1.Received_Quantity__c=10;
        porderp1.Expected_Delivery_Date__c=date.today();  
        porderp1.Buying_Price__c=89;
        insert porderp1;
        System.assertEquals(porderp1.Status__c,'Open');
        
        Purchase_Order_Product__c porderp2=new  Purchase_Order_Product__c();
        porderp2.Purchase_Order__c=transID2;
        porderp2.Product__c=pro1.id;
        porderp2.Status__c='Open';
        porderp2.Quantity__c='10';
        porderp2.Received_Quantity__c=10;
        porderp2.Expected_Delivery_Date__c=date.today();  
        porderp2.Buying_Price__c=89;
        insert porderp2;
        System.assertEquals(porderp2.Status__c,'Open');
        
        Purchase_Order_Product__c porderp3=new  Purchase_Order_Product__c();
        porderp3.Purchase_Order__c=transID2;
        porderp3.Product__c=pro2.id;
        porderp3.Status__c='Open';
        porderp3.Quantity__c='10';
        porderp3.Received_Quantity__c=10;
        porderp3.Expected_Delivery_Date__c=date.today();  
        porderp3.Buying_Price__c=89;
        insert porderp3;
        System.assertEquals(porderp3.Status__c,'Open');
        
        //Stock Receiving
        Stock_In__c stIn1=new Stock_In__c();
        stIn1.Delivery_Person__c=con.Id;
        stIn1.Received_Date_Time__c=date.today();
        stIn1.Location__c=acc2.Id;
        stIn1.Status__c='Open';
        stIn1.Truck_Number__c='';
        stIn1.Vendor__c=acc.Id;
       // stIn1.PO__c=pord.Id;
        insert stIn1;
        System.assertEquals(stIn1.Location__c,acc2.Id);
           
        
        Product_Serial_Number__c  proPSN1=new Product_Serial_Number__c();
        proPSN1.Product_Code__c=pro.Id;
      //  proPSN.Stock_Receiving_Product__c=sInPro.Id;
        proPSN1.Serial_Number__c='4454454';
        insert proPSN1;
        System.assertEquals(proPSN1.Product_Code__c,pro.Id);
        
        Product_Serial_Number__c  proPSN2=new Product_Serial_Number__c();
        proPSN2.Product_Code__c=pro1.Id;
      //  proPSN.Stock_Receiving_Product__c=sInPro.Id;
        proPSN2.Serial_Number__c='32434';
        insert proPSN2;
        System.assertEquals(proPSN2.Product_Code__c,pro1.Id);
        
        Lot__c lot = new Lot__c();
        lot.Lot_Name__c = 'Test Lot';
        lot.Product__c = pro.Id;
        lot.Quantity__c = 10;
        lot.Created_Date__c=date.today();
        lot.Expiry_Date__c=date.today()+25;
        insert lot;
        System.assertEquals(lot.Lot_Name__c,'Test Lot');

        Lot__c lot1 = new Lot__c();
        lot1.Lot_Name__c = 'Test Lot1';
        lot1.Product__c = pro1.Id;
        lot1.Quantity__c = 10;
        lot1.Created_Date__c=date.today();
        lot1.Expiry_Date__c=date.today()+25;
        insert lot1;
        System.assertEquals(lot1.Lot_Name__c,'Test Lot1');

        Lot__c lot2 = new Lot__c();
        lot2.Lot_Name__c = 'Test lot2';
        lot2.Product__c = pro1.Id;
        lot2.Quantity__c = 10;
        lot2.Created_Date__c=date.today();
        lot2.Expiry_Date__c=date.today()+25;
        insert lot2;
        System.assertEquals(lot2.Lot_Name__c,'Test lot2');

        Lot__c lot3 = new Lot__c();
        lot3.Lot_Name__c = 'Test lot3';
        lot3.Product__c = pro.Id;
        lot3.Quantity__c = 10;
        lot3.Created_Date__c=date.today();
        lot3.Expiry_Date__c=date.today()+25;
        insert lot3;
        System.assertEquals(lot3.Lot_Name__c,'Test lot3');

        Lot__c lot4 = new Lot__c();
        lot4.Lot_Name__c = 'Test lot4';
        lot4.Product__c = pro2.Id;
        lot4.Quantity__c = 10;
        lot4.Created_Date__c=date.today();
        lot4.Expiry_Date__c=date.today()+25;
        insert lot4;
        System.assertEquals(lot4.Lot_Name__c,'Test lot4');


        Lot__c lot5 = new Lot__c();
        lot5.Lot_Name__c = 'Test lot5';
        lot5.Product__c = pro2.Id;
        lot5.Quantity__c = 10;
        lot5.Created_Date__c=date.today();
        lot5.Expiry_Date__c=date.today()+25;
        insert lot5;
        System.assertEquals(lot5.Lot_Name__c,'Test lot5');

        List<Stock_In_Product__c> ListSRP=new   List<Stock_In_Product__c>();
        Stock_In_Product__c  sInPro=new Stock_In_Product__c();
        sInPro.Stock_In__c=stIn1.id;
        sInPro.Pur_Order__c=transID1;
        sInPro.Product__c=pro.id;
        sInPro.Purchase_Order__c=porderp.id;
        sInPro.Quantity_Received__c=3;
        sInPro.Returned_Quantity__c=0;
        sInPro.Putaway_location__c=acc2.Id;
        sInPro.Product_Serial_Number__c=proPSN1.id;
        sInPro.Bin__c=sulLevelBinObj.id;
        sInPro.Expiry_Date__c=system.today()+30;
        sInPro.Status__c='Verified';
        sInPro.Return_Quantity_Comment__c='Stock receiving';
        sInPro.Lot__c = lot.Id;
         
        ListSRP.add(sInPro);
        
        
        Stock_In_Product__c  sInPro1=new Stock_In_Product__c();
        sInPro1.Stock_In__c=stIn1.id;
        sInPro1.Pur_Order__c=transID2;
        sInPro1.Product__c=pro.id;
        sInPro1.Purchase_Order__c=porderp1.id;
        sInPro1.Quantity_Received__c=3;
        sInPro1.Returned_Quantity__c=0;
        sInPro1.Putaway_location__c=acc2.Id;
        sInPro1.Status__c='Open';
        sInPro1.Return_Quantity_Comment__c='Stock receiving';
        sInPro1.Expiry_Date__c=system.today()+30;
        sInPro1.Lot__c = lot1.Id;
        sInPro1.Product_Serial_Number__c=proPSN1.id;
        sInPro1.Bin__c=sulLevelBinObj.id;
        
        ListSRP.add(sInPro1);
        
        Stock_In_Product__c  sInPro2=new Stock_In_Product__c();
        sInPro2.Stock_In__c=stIn1.id;
        sInPro2.Pur_Order__c=transID2;
        sInPro2.Product__c=pro1.id;
        sInPro2.Purchase_Order__c=porderp1.id;
        sInPro2.Quantity_Received__c=3;
        sInPro2.Returned_Quantity__c=0;
        sInPro2.Putaway_location__c=acc2.Id;
        sInPro2.Status__c='Verified';
        sInPro2.Return_Quantity_Comment__c='Stock receiving';
        sInPro2.Lot__c = lot2.Id;
        sInPro2.Expiry_Date__c=system.today()+30;
        sInPro2.Product_Serial_Number__c=proPSN2.id;
        sInPro2.Bin__c=sulLevelBinObj2.id;
       
        ListSRP.add(sInPro2);
        
        Stock_In_Product__c  sInPro3=new Stock_In_Product__c();
        sInPro3.Stock_In__c=stIn1.id;
        sInPro3.Product__c=pro2.id;
        sInPro3.Pur_Order__c=transID2;
        sInPro3.Purchase_Order__c=porderp1.id;
        sInPro3.Quantity_Received__c=3;
        sInPro3.Returned_Quantity__c=0;
        sInPro3.Putaway_location__c=acc2.Id;
        sInPro3.Status__c='Open';
        sInPro3.Expiry_Date__c=system.today()+30;
        sInPro3.Return_Quantity_Comment__c='Stock receiving';
        sInPro3.Lot__c = lot4.Id;
        sInPro3.Bin__c=sulLevelBinObj.id;
         
        ListSRP.add(sInPro3);
       
        
        Stock_In_Product__c  sInPro4=new Stock_In_Product__c();
        sInPro4.Stock_In__c=stIn1.id;
        sInPro4.Pur_Order__c=pord.id;
        sInPro4.Product__c=pro.id;
        sInPro4.Purchase_Order__c=porderp.id;
        sInPro4.Quantity_Received__c=3;
        sInPro4.Returned_Quantity__c=0;
        sInPro4.Putaway_location__c=acc2.Id;
        sInPro4.Bin__c=sulLevelBinObj2.id;
        sInPro4.Status__c='Verified';
        sInPro4.Expiry_Date__c=system.today()+30;
        sInPro4.Product_Serial_Number__c=proPSN1.id;
        sInPro4.Return_Quantity_Comment__c='Stock receiving';
        sInPro4.Lot__c = lot.Id;
        
        ListSRP.add(sInPro4);
        
        Stock_In_Product__c  sInPro5=new Stock_In_Product__c();
        sInPro5.Stock_In__c=stIn1.id;
        sInPro5.Pur_Order__c=pord.id;
        sInPro5.Product__c=pro.id;
        sInPro5.Purchase_Order__c=porderp.id;
        sInPro5.Quantity_Received__c=3;
        sInPro5.Returned_Quantity__c=0;
        sInPro5.Putaway_location__c=acc2.Id;
        sInPro5.Bin__c=sulLevelBinObj.id;
        sInPro5.Status__c='Verified';
        sInPro5.Expiry_Date__c=system.today()+30;
        sInPro5.Product_Serial_Number__c=proPSN1.id;
        sInPro5.Return_Quantity_Comment__c='Stock receiving';
        sInPro5.Lot__c = lot.Id;
       
        ListSRP.add(sInPro5);
        
        Stock_In_Product__c  sInPro6=new Stock_In_Product__c();
        sInPro6.Stock_In__c=stIn1.id;
        sInPro6.Pur_Order__c=pord.id;
        sInPro6.Product__c=pro.id;
        sInPro6.Purchase_Order__c=porderp.id;
        sInPro6.Quantity_Received__c=3;
        sInPro6.Returned_Quantity__c=0;
        sInPro6.Putaway_location__c=acc2.Id;
        sInPro6.Bin__c=sulLevelBinObj.id;
        sInPro6.Status__c='Open';
        sInPro6.Expiry_Date__c=system.today()+30;
        sInPro6.Product_Serial_Number__c=proPSN1.id;
        sInPro6.Return_Quantity_Comment__c='Stock receiving';
        sInPro6.Lot__c = lot.Id;
        ListSRP.add(sInPro6);
        
        Stock_In_Product__c  sInPro7=new Stock_In_Product__c();
        sInPro7.Stock_In__c=stIn1.id;
        sInPro7.Pur_Order__c=pord1.id;
        sInPro7.Product__c=pro2.id;
        sInPro7.Purchase_Order__c=porderp1.id;
        sInPro7.Quantity_Received__c=3;
        sInPro7.Returned_Quantity__c=0;
        sInPro7.Putaway_location__c=acc2.Id;
        sInPro7.Bin__c=sulLevelBinObj.id;
        sInPro7.Status__c='Verified';
        sInPro7.Expiry_Date__c=system.today()+30;
        sInPro7.Product_Serial_Number__c=proPSN1.id;
        sInPro7.Return_Quantity_Comment__c='Stock receiving';
        ListSRP.add(sInPro7);
        
        System.assertEquals(sInPro.Status__c,'Verified');
        System.assertEquals(sInPro1.Status__c,'Open');
        System.assertEquals(sInPro2.Status__c,'Verified');
        System.assertEquals(sInPro3.Status__c,'Open');
        System.assertEquals(sInPro4.Status__c,'Verified');
        System.assertEquals(sInPro5.Status__c,'Verified');
        System.assertEquals(sInPro6.Status__c,'Open');
        System.assertEquals(sInPro7.Status__c,'Verified');
        insert ListSRP;
        
        Lot_Product__c lotProd = new Lot_Product__c();
        lotProd.Lot__c = lot.Id;
        lotProd.Product__c = pro.Id;
        lotProd.Quantity__c = 10;
        lotProd.Bin__c=sulLevelBinObj.id;
        lotProd.Location__c = invloc2.id;
        insert lotProd;
        System.assertEquals(lotProd.Quantity__c,10);

        Lot_Product__c lotProd1 = new Lot_Product__c();
        lotProd1.Lot__c = lot.Id;
        lotProd1.Product__c = pro.Id;
        lotProd1.Quantity__c = 10;
        lotProd1.Bin__c=sulLevelBinObj2.id;
        lotProd1.Location__c = invloc2.id;
        insert lotProd1;
        System.assertEquals(lotProd1.Quantity__c,10);

        Lot_Product__c lotProd2 = new Lot_Product__c();
        lotProd2.Lot__c = lot1.Id;
        lotProd2.Product__c = pro1.Id;
        lotProd2.Quantity__c = 10;
        lotProd2.Location__c = invloc2.id;
        lotProd2.Bin__c=sulLevelBinObj.id;
        insert lotProd2;
        System.assertEquals(lotProd2.Quantity__c,10);

        Lot_Product__c lotProd3 = new Lot_Product__c();
        lotProd3.Lot__c = lot1.Id;
        lotProd3.Product__c = pro1.Id;
        lotProd3.Quantity__c = 10;
        lotProd3.Bin__c=sulLevelBinObj2.id;
        lotProd3.Location__c = invloc2.id;
        insert lotProd3;
        System.assertEquals(lotProd3.Quantity__c,10);

        Lot_Product__c lotProd4 = new Lot_Product__c();
        lotProd4.Lot__c = lot2.Id;
        lotProd4.Product__c = pro1.Id;
        lotProd4.Quantity__c = 10;
        lotProd4.Bin__c=sulLevelBinObj.id;
        lotProd4.Location__c = invloc2.id;
        insert lotProd4;
        System.assertEquals(lotProd4.Quantity__c,10);

        Lot_Product__c lotProd5 = new Lot_Product__c();
        lotProd5.Lot__c = lot2.Id;
        lotProd5.Product__c = pro1.Id;
        lotProd5.Quantity__c = 10;
        lotProd5.Bin__c=sulLevelBinObj2.id;
        lotProd5.Location__c = invloc2.id;
        insert lotProd5;
        System.assertEquals(lotProd5.Quantity__c,10);

        Lot_Product__c lotProd6 = new Lot_Product__c();
        lotProd6.Lot__c = lot3.Id;
        lotProd6.Product__c = pro.Id;
        lotProd6.Quantity__c = 10;
        lotProd6.Bin__c=sulLevelBinObj.id;
        lotProd6.Location__c = invloc2.id;
        insert lotProd6;
        System.assertEquals(lotProd6.Quantity__c,10);

        Lot_Product__c lotProd7 = new Lot_Product__c();
        lotProd7.Lot__c = lot4.Id;
        lotProd7.Product__c = pro2.Id;
        lotProd7.Quantity__c = 10;
        lotProd7.Bin__c=sulLevelBinObj.id;
        lotProd7.Location__c = invloc2.id;
        insert lotProd7;
        System.assertEquals(lotProd7.Quantity__c,10);

        Lot_Product__c lotProd8 = new Lot_Product__c();
        lotProd8.Lot__c = lot5.Id;
        lotProd8.Product__c = pro2.Id;
        lotProd8.Quantity__c = 10;
        lotProd8.Bin__c=sulLevelBinObj2.id;
        lotProd8.Location__c = invloc2.id;
        insert lotProd8;
        System.assertEquals(lotProd8.Quantity__c,10);
        //Product ILP
        Inventory_Location_Product__c ILP = new Inventory_Location_Product__c();
        ILP.Received_Quantity__c=20;
        ILP.Products__c = pro.id;
        insert ILP;
        System.assertEquals(ILP.Received_Quantity__c,20);
        
        //product ILPLI
        Inventory_Location_Product_Line_Item__c ILPLI = new Inventory_Location_Product_Line_Item__c();
        ILPLI.Received_Quantity__c=20;
        ILPLI.Product__c=pro.id;
        ILPLI.Inventory_Location_Product__c=ILP.id;
        ILPLI.Bin__c=sulLevelBinObj.id;
        ILPLI.Stock_Receiving_Product__c=sInPro.id;
        insert ILPLI;
        System.assertEquals(ILPLI.Received_Quantity__c,20);
        
        Inventory_Location_Product_Line_Item__c ILPLI3 = new Inventory_Location_Product_Line_Item__c();
        ILPLI3.Received_Quantity__c=20;
        ILPLI3.Product__c=pro.id;
        ILPLI3.Inventory_Location_Product__c=ILP.id;
        ILPLI3.Bin__c=sulLevelBinObj2.id;
        ILPLI3.Stock_Receiving_Product__c=sInPro6.id;
        insert ILPLI3;
        System.assertEquals(ILPLI3.Received_Quantity__c,20);
        
        //Product ILP
        Inventory_Location_Product__c ILP1 = new Inventory_Location_Product__c();
        ILP1.Received_Quantity__c=20;
        ILP1.Products__c = pro1.id;
        insert ILP1;
        System.assertEquals(ILP1.Received_Quantity__c,20);
        
        //product ILPLI
        Inventory_Location_Product_Line_Item__c ILPLI1 = new Inventory_Location_Product_Line_Item__c();
        ILPLI1.Received_Quantity__c=20;
        ILPLI1.Product__c=pro1.id;
        ILPLI1.Inventory_Location_Product__c=ILP.id;
        ILPLI1.Stock_Receiving_Product__c=sInPro2.id;
        ILPLI1.Bin__c=sulLevelBinObj.id;
        insert ILPLI1;
        System.assertEquals(ILPLI1.Received_Quantity__c,20);
        
        //Product ILP
        Inventory_Location_Product__c ILP2 = new Inventory_Location_Product__c();
        ILP2.Received_Quantity__c=20;
        ILP2.Products__c = pro2.id;
        insert ILP2;
        System.assertEquals(ILP2.Received_Quantity__c,20);
        
        //product ILPLI
        Inventory_Location_Product_Line_Item__c ILPLI2 = new Inventory_Location_Product_Line_Item__c();
        ILPLI2.Received_Quantity__c=20;
        ILPLI2.Product__c=pro2.id;
        ILPLI2.Inventory_Location_Product__c=ILP2.id;
        ILPLI2.Stock_Receiving_Product__c=sInPro3.id;
        ILPLI2.Bin__c=sulLevelBinObj.id;
        insert ILPLI2;
        System.assertEquals( ILPLI2.Bin__c,sulLevelBinObj.id);
        
         //product ILPLI
        Inventory_Location_Product_Line_Item__c ILPLI4 = new Inventory_Location_Product_Line_Item__c();
        ILPLI4.Received_Quantity__c=20;
        ILPLI4.Product__c=pro2.id;
        ILPLI4.Inventory_Location_Product__c=ILP2.id;
        ILPLI4.Stock_Receiving_Product__c=sInPro7.id;
        ILPLI4.Bin__c=sulLevelBinObj.id;
        insert ILPLI4;
        
        System.assertEquals(ILPLI4.Received_Quantity__c,20);
        
        List<Stock_Receiving_Product_Line_Item__c> srpList=new List<Stock_Receiving_Product_Line_Item__c>();
        Stock_Receiving_Product_Line_Item__c srpli1=new Stock_Receiving_Product_Line_Item__c();
        srpli1.Inventory_Location_Product__c=ILP.id;
        srpli1.Lot__c=lot.id;
        srpli1.Stock_Receiving_Product__c=sInPro.id;
        srpli1.Purchase_Order_Product__c=porderp.id;
        srpList.add(srpli1);
         System.assertEquals(srpli1.Lot__c,lot.id);
        
        Stock_Receiving_Product_Line_Item__c srpli2=new Stock_Receiving_Product_Line_Item__c();
        srpli2.Inventory_Location_Product__c=ILP.id;
        srpli2.Lot__c=lot.id;
        srpli2.Stock_Receiving_Product__c=sInPro4.id;
        srpli2.Purchase_Order_Product__c=porderp.id;
        srpList.add(srpli2);
         System.assertEquals(srpli2.Lot__c,lot.id);
        
        Stock_Receiving_Product_Line_Item__c srpli3=new Stock_Receiving_Product_Line_Item__c();
        srpli3.Inventory_Location_Product__c=ILP.id;
        srpli3.Lot__c=lot.id;
        srpli3.Stock_Receiving_Product__c=sInPro5.id;
        srpli3.Purchase_Order_Product__c=porderp.id;
        srpList.add(srpli3);
         System.assertEquals(srpli3.Stock_Receiving_Product__c,sInPro5.id);
        
        Stock_Receiving_Product_Line_Item__c srpli4=new Stock_Receiving_Product_Line_Item__c();
        srpli4.Inventory_Location_Product__c=ILP.id;
        srpli4.Lot__c=lot3.id;
        srpli4.Stock_Receiving_Product__c=sInPro1.id;
        srpli4.Purchase_Order_Product__c=porderp1.id;
        srpList.add(srpli4);
         System.assertEquals(srpli4.Lot__c,lot3.id);
        
        Stock_Receiving_Product_Line_Item__c srpli5=new Stock_Receiving_Product_Line_Item__c();
        srpli5.Inventory_Location_Product__c=ILP1.id;
        srpli5.Lot__c=lot2.id;
        srpli5.Stock_Receiving_Product__c=sInPro2.id;
        srpli5.Purchase_Order_Product__c=porderp1.id;
        srpList.add(srpli5);
         System.assertEquals(srpli5.Purchase_Order_Product__c,porderp1.id);
        
        Stock_Receiving_Product_Line_Item__c srpli6=new Stock_Receiving_Product_Line_Item__c();
        srpli6.Inventory_Location_Product__c=ILP2.id;
        srpli6.Lot__c=lot5.id;
        srpli6.Stock_Receiving_Product__c=sInPro3.id;
        srpli6.Purchase_Order_Product__c=porderp1.id;
        srpList.add(srpli6);
         System.assertEquals(srpli6.Stock_Receiving_Product__c,sInPro3.id);
        
        Stock_Receiving_Product_Line_Item__c srpli7=new Stock_Receiving_Product_Line_Item__c();
        srpli7.Inventory_Location_Product__c=ILP2.id;
        srpli7.Stock_Receiving_Product__c=sInPro7.id;
        srpli7.Purchase_Order_Product__c=porderp1.id;
        srpList.add(srpli7);
        
        insert srpList;
        String srId=stIn1.Id;
         System.assertEquals(srpli7.Purchase_Order_Product__c,porderp1.id);
        
        
        
      
        List<StockReceivingLinesWrap> srlwList=new List<StockReceivingLinesWrap>();

        StockReceivingLinesWrap srlw= new StockReceivingLinesWrap();
        srlw.transID=pord.Id;
        List<StockReceivingLinesWrap.TransLineItems> transaLIList=new List<StockReceivingLinesWrap.TransLineItems>();

        StockReceivingLinesWrap.TransLineItems transaLI=new StockReceivingLinesWrap.TransLineItems();
        transaLI.attributeType='SERIALIZED';
        transaLI.productName=pro.name;
        transaLI.Receiving_Quantity_Original=5;
        transaLI.BinId=sulLevelBinObj.id;
         System.assertEquals(transaLI.Receiving_Quantity_Original,5);

        StockReceivingLinesWrap.SRLineItemRec srlir=new StockReceivingLinesWrap.SRLineItemRec();
        srlir.Id=sInPro3.Id;
        srlir.TransactionID=pord.Id;
        srlir.Purchase_Order =porderp.Id;
        srlir.Product =pro1.Id;
        srlir.Ordered_Qty = 100;
        srlir.Quantity_Received =  50;
        srlir.Remaining_Quantity=50;
        srlir.Status='Verified'; 
        srlir.Putaway_location=acc2.id; 
        srlir.Lot=lot.id;
        transaLI.SRLineItemRec=srlir;
         System.assertEquals(srlir.Remaining_Quantity,50);
        
        

        List<StockReceivingLinesWrap.serialNo> serNoList=new List<StockReceivingLinesWrap.serialNo>();
        for(Integer i=0;i<5;i++)
        {
            StockReceivingLinesWrap.serialNo serNo=new StockReceivingLinesWrap.serialNo();
            serNo.Serial_Number='123-'+i;
            serNoList.add(serNo);
        }

        transaLI.serialNo=serNoList;
        transaLIList.add(transaLI); 
        srlw.TransLineItems=transaLIList;
        srlwList.add(srlw);
        String srlwListJSON = JSON.serialize(srlwList);
        String srdata = JSON.serialize(stIn1);

       

        StockReceivingLinesWrap srlw1= new StockReceivingLinesWrap();
        srlw1.transID=pord1.Id;
       
        StockReceivingLinesWrap.TransLineItems  transaLI1=new StockReceivingLinesWrap.TransLineItems();
        transaLI1.attributeType='BULK';
        transaLI1.productName='';
        transaLI1.Receiving_Quantity_Original=100;
        transaLI1.BinId=sulLevelBinObj2.id;
        System.assertEquals( transaLI1.Receiving_Quantity_Original,100);
        
        
        StockReceivingLinesWrap.SRLineItemRec srlir1=new StockReceivingLinesWrap.SRLineItemRec();
        srlir1.Id=sInPro.Id;
        srlir1.TransactionID=pord1.id;
        srlir1.Purchase_Order =porderp1.Id;
        srlir1.Product =pro2.Id;
        srlir1.Ordered_Qty = 100;
        srlir1.Quantity_Received =  50;
        srlir1.Remaining_Quantity=50;
        srlir1.Status='Verified'; 
        srlir1.Putaway_location=acc2.id; 
        srlir1.Lot=null;
        transaLI1.SRLineItemRec=srlir1;
        System.assertEquals(srlir1.Remaining_Quantity,50);

     
        transaLIList.add(transaLI1); 
        srlw1.TransLineItems=transaLIList;
        srlwList.add(srlw1);
        String srlwListJSON1 = JSON.serialize(srlwList);
        String srdata1 = JSON.serialize(stIn1);
        
        
        Test.startTest();
        NewStockreceiving.fetchStockReceivingItems(pord.id );
        NewStockreceiving.fetchStockLinesUpdate(srId);
        NewStockreceiving.saveStockReceiving(srdata,srlwListJSON);
        NewStockreceiving.saveStockReceiving(srdata1,srlwListJSON1);
        Test.stopTest();
    }
     @IsTest(seeAllData=false)
    public static  void configValues1()
    {
        Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
       
        ID RID1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        Account  acc=new Account();
        acc.Name='rashmi';
        acc.Type='Vendor';
        acc.Email__c = 'cus@gmail.com';
        acc.RecordTypeId = RID1;
        insert acc;
        System.assertEquals(acc.Name,'rashmi'); 

        Account  acc1=new Account();
        acc1.Name='dharwad';
        acc1.Type='Receiving Location';
        acc1.Active__c = 'Yes';
        acc1.Email__c = 'cus@gmail.com';
        insert acc1;
        System.assertEquals(acc1.Name,'dharwad'); 

        ID RID3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();
        Account  acc2=new Account();
        acc2.Name='Belagavi';
        acc2.Type='Location';
        acc2.RecordTypeId = RID3;
        acc2.Active__c = 'Yes';
        insert acc2;
        System.assertEquals(acc2.Name,'Belagavi');

        Sublevel_location__c sulLevelObj = new Sublevel_location__c();
        sulLevelObj.RecordTypeId = Schema.SObjectType.Sublevel_location__c.getRecordTypeInfosByName().get('Zone').getRecordTypeId();
        sulLevelObj.Name = 'Zone1';
        sulLevelObj.Location__c = acc2.Id;
        insert sulLevelObj;
        System.assertEquals(sulLevelObj.Name , 'Zone1');
        
        Sublevel_location__c sulLevelBinObj = new Sublevel_location__c();
        sulLevelBinObj.RecordTypeId = Schema.SObjectType.Sublevel_location__c.getRecordTypeInfosByName().get('Bin').getRecordTypeId();
        sulLevelBinObj.Name = 'Bin1';
        sulLevelBinObj.zone__c = sulLevelObj.Id;
        insert sulLevelBinObj;
        System.assertEquals(sulLevelBinObj.Name , 'Bin1');
        
        Sublevel_location__c sulLevelObj1 = new Sublevel_location__c();
        sulLevelObj1.RecordTypeId = Schema.SObjectType.Sublevel_location__c.getRecordTypeInfosByName().get('Zone').getRecordTypeId();
        sulLevelObj1.Name = 'Zone2';
        sulLevelObj1.Location__c = acc2.Id;
        insert sulLevelObj1;
        System.assertEquals(sulLevelObj1.Name , 'Zone2');

        
        Sublevel_location__c sulLevelBinObj2 = new Sublevel_location__c();
        sulLevelBinObj2.RecordTypeId = Schema.SObjectType.Sublevel_location__c.getRecordTypeInfosByName().get('Bin').getRecordTypeId();
        sulLevelBinObj2.Name = 'Bin2';
        sulLevelBinObj2.zone__c = sulLevelObj1.Id;
        insert sulLevelBinObj2;  
        System.assertEquals(sulLevelBinObj2.Name , 'Bin2');
        
        
        Contact  con=new Contact();
        con.FirstName='Harish';
        con.LastName='Naik';
        con.AccountId=acc.Id;
        con.phone ='1234567890';
        insert con;
        System.assertEquals(con.FirstName,'Harish');

        Default_Parameters__c  dp = new Default_Parameters__c (Name = 'Sample dp',Parent_Id__c = acc.Id);
        insert dp;
        System.assertEquals(dp.Name,'Sample dp');

        //Product 1
        Product2  pro=new  Product2();
        pro.Name='Books01';
        
        insert pro;
        System.assertEquals(pro.Name,'Books01');

        Vendor_Product__c vp  = new Vendor_Product__c();
        vp.Product_Name__c = pro.id;
        vp.Account_Name__c = acc.Id;
        vp.Buying_Price__c = 200;
        vp.Is_Preferred__c=true;
        insert vp;
        system.assertEquals(pro.id,vp.Product_Name__c);
        

        Purchase_Order__c  pord=new  Purchase_Order__c();
        pord.Product_Supplier__c=acc.Id;
        pord.Order_Date__c=date.today();
        pord.Status__c='Submitted';
        insert pord;
        System.assertEquals(pord.Status__c,'Submitted');

        Purchase_Order_Product__c porderp=new  Purchase_Order_Product__c();
        porderp.Purchase_Order__c=pord.Id;
        porderp.Product__c=pro.id;
        porderp.Status__c='Open';
        porderp.Quantity__c='10';
        porderp.Received_Quantity__c=10;
        porderp.Expected_Delivery_Date__c=date.today();  
        porderp.Buying_Price__c=89;
        insert porderp;
        System.assertEquals(porderp.Status__c,'Open');

        //Product Inventory
        Inventory__c PI = new Inventory__c();
        PI.ProductCode__c=pro.id;
        PI.Available_Qty__c = 10;
        insert PI;
        System.assertEquals(PI.Available_Qty__c,10);
       
        Id RIDBOM = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('BOM').getRecordTypeId();
        //Product 2
        Product2  pro1=new  Product2();
        pro1.Name='Books01';
        pro1.Product_Description__c='Books01 description';
        pro1.Product_Price__c=324.34;
        pro1.Max_Discount__c=30;
        pro1.Product_Weight__c = 3 ;
        pro1.Product_Bar_Code__c='Books123456';
        pro1.SKU__c = 'testing';
        pro1.Type__c = 'BOM';
        pro1.Attribute_Type__c='SERIALIZED';
        pro1.Has_Expiry_Date__c=true;
        pro1.RecordtypeId = RIDBOM;
        insert pro1;
        System.assertEquals(pro1.name, 'Books01');

        //Product 3
        Product2  pro2=new  Product2();
        pro2.Name='Lenovo-S850';
        pro2.Product_Description__c='Lenovo-S850 description';
        pro2.Product_Price__c=324.34;
        pro2.Max_Discount__c=30;
        pro2.Product_Weight__c = 3 ;
        pro2.Product_Bar_Code__c='LenovoS850111';
        pro2.SKU__c = 'testpro';
        pro2.Type__c = 'BOM';
        pro2.Attribute_Type__c='BULK';
        pro2.Has_Expiry_Date__c=true;
        pro2.RecordtypeId = RIDBOM;
        insert pro2;
        System.assertEquals(pro2.name, 'Lenovo-S850');
        
        Vendor_Product__c vp1  = new Vendor_Product__c();
        vp1.Product_Name__c = pro1.id;
        vp1.Account_Name__c = acc.Id;
        vp1.Buying_Price__c = 200;
        vp1.Is_Preferred__c=true;
        insert vp1;
        system.assertEquals(pro1.id,vp1.Product_Name__c);
        
        Vendor_Product__c vp2  = new Vendor_Product__c();
        vp2.Product_Name__c = pro2.id;
        vp2.Account_Name__c = acc.Id;
        vp2.Buying_Price__c = 200;
        vp2.Is_Preferred__c=true;
        insert vp2;
        system.assertEquals(pro2.id,vp2.Product_Name__c);

        Inventory__c inv1 = new Inventory__c();
        inv1.ProductCode__c = pro1.Id;
        inv1.Available_Qty__c = 100;
        insert inv1;
        system.assertEquals(inv1.ProductCode__c,pro1.Id);
        
        Inventory_Location__c invloc2 = new Inventory_Location__c(Location__c = acc2.Id);
        insert invloc2;
        system.assertEquals(invloc2.Location__c,acc2.Id);
        
        Inventory_Location__c invloc3 = new Inventory_Location__c(Location__c = acc2.Id);
        insert invloc3;
        system.assertEquals(invloc3.Location__c,acc2.Id);
        
        Inventory__c inv2 = new Inventory__c();
        inv2.ProductCode__c = pro2.Id;
        inv2.Available_Qty__c = 100;
        insert inv2;
        system.assertEquals(inv2.ProductCode__c,pro2.Id);
        
        Inventory_Location__c invloc4 = new Inventory_Location__c(Location__c = acc2.Id);
        insert invloc4;
        system.assertEquals(invloc4.Location__c,acc2.Id);
        
        
        //Product Inventory
        Inventory__c PI1 = new Inventory__c();
        PI1.ProductCode__c=pro1.id;
        PI1.Available_Qty__c = 10;
        insert PI1;
        System.assertEquals(PI1.Available_Qty__c,10);
        
        //Product Inventory
        Inventory__c PI2 = new Inventory__c();
        PI2.ProductCode__c=pro2.id;
        PI2.Available_Qty__c = 10;
        insert PI2;
        System.assertEquals(PI2.Available_Qty__c,10);
        
        Purchase_Order__c  pord1=new  Purchase_Order__c();
        pord1.Product_Supplier__c=acc.Id;
        pord1.Order_Date__c=date.today();
        pord1.Status__c='Open';
        insert pord1;
        System.assertEquals(pord1.Status__c,'Open');

        Id transID1 =pord.Id;
        Id transID2=pord1.Id;
        
        Purchase_Order_Product__c porderp1=new  Purchase_Order_Product__c();
        porderp1.Purchase_Order__c=transID2;
        porderp1.Product__c=pro.id;
        porderp1.Status__c='Open';
        porderp1.Quantity__c='10';
        porderp1.Received_Quantity__c=10;
        porderp1.Expected_Delivery_Date__c=date.today();  
        porderp1.Buying_Price__c=89;
        insert porderp1;
        System.assertEquals(porderp1.Status__c,'Open');
        
        Purchase_Order_Product__c porderp2=new  Purchase_Order_Product__c();
        porderp2.Purchase_Order__c=transID2;
        porderp2.Product__c=pro1.id;
        porderp2.Status__c='Open';
        porderp2.Quantity__c='10';
        porderp2.Received_Quantity__c=10;
        porderp2.Expected_Delivery_Date__c=date.today();  
        porderp2.Buying_Price__c=89;
        insert porderp2;
        System.assertEquals(porderp2.Status__c,'Open');
        
        Purchase_Order_Product__c porderp3=new  Purchase_Order_Product__c();
        porderp3.Purchase_Order__c=transID2;
        porderp3.Product__c=pro2.id;
        porderp3.Status__c='Open';
        porderp3.Quantity__c='10';
        porderp3.Received_Quantity__c=10;
        porderp3.Expected_Delivery_Date__c=date.today();  
        porderp3.Buying_Price__c=89;
        insert porderp3;
        System.assertEquals(porderp3.Status__c,'Open');
        
        //Stock Receiving
        Stock_In__c stIn1=new Stock_In__c();
        stIn1.Delivery_Person__c=con.Id;
        stIn1.Received_Date_Time__c=date.today();
        stIn1.Location__c=acc2.Id;
        stIn1.Status__c='Open';
        stIn1.Truck_Number__c='';
        stIn1.Vendor__c=acc.Id;
        insert stIn1;
        System.assertEquals(stIn1.Location__c,acc2.Id);
           
        
        Product_Serial_Number__c  proPSN1=new Product_Serial_Number__c();
        proPSN1.Product_Code__c=pro.Id;
        proPSN1.Serial_Number__c='4454454';
        insert proPSN1;
        System.assertEquals(proPSN1.Product_Code__c,pro.Id);
        
        Product_Serial_Number__c  proPSN2=new Product_Serial_Number__c();
        proPSN2.Product_Code__c=pro1.Id;
        proPSN2.Serial_Number__c='32434';
        insert proPSN2;
        System.assertEquals(proPSN2.Product_Code__c,pro1.Id);
        
        Lot__c lot = new Lot__c();
        lot.Lot_Name__c = 'Test Lot';
        lot.Product__c = pro.Id;
        lot.Quantity__c = 10;
        lot.Created_Date__c=date.today();
        lot.Expiry_Date__c=date.today()+25;
        insert lot;
        System.assertEquals(lot.Lot_Name__c,'Test Lot');

        Lot__c lot1 = new Lot__c();
        lot1.Lot_Name__c = 'Test Lot1';
        lot1.Product__c = pro1.Id;
        lot1.Quantity__c = 10;
        lot1.Created_Date__c=date.today();
        lot1.Expiry_Date__c=date.today()+25;
        insert lot1;
        System.assertEquals(lot1.Lot_Name__c,'Test Lot1');

        Lot__c lot2 = new Lot__c();
        lot2.Lot_Name__c = 'Test lot2';
        lot2.Product__c = pro1.Id;
        lot2.Quantity__c = 10;
        lot2.Created_Date__c=date.today();
        lot2.Expiry_Date__c=date.today()+25;
        insert lot2;
        System.assertEquals(lot2.Lot_Name__c,'Test lot2');

        Lot__c lot3 = new Lot__c();
        lot3.Lot_Name__c = 'Test lot3';
        lot3.Product__c = pro.Id;
        lot3.Quantity__c = 10;
        lot3.Created_Date__c=date.today();
        lot3.Expiry_Date__c=date.today()+25;
        insert lot3;
        System.assertEquals(lot3.Lot_Name__c,'Test lot3');

        Lot__c lot4 = new Lot__c();
        lot4.Lot_Name__c = 'Test lot4';
        lot4.Product__c = pro2.Id;
        lot4.Quantity__c = 10;
        lot4.Created_Date__c=date.today();
        lot4.Expiry_Date__c=date.today()+25;
        insert lot4;
        System.assertEquals(lot4.Lot_Name__c,'Test lot4');


        Lot__c lot5 = new Lot__c();
        lot5.Lot_Name__c = 'Test lot5';
        lot5.Product__c = pro2.Id;
        lot5.Quantity__c = 10;
        lot5.Created_Date__c=date.today();
        lot5.Expiry_Date__c=date.today()+25;
        insert lot5;
        System.assertEquals(lot5.Lot_Name__c,'Test lot5');

        List<Stock_In_Product__c> ListSRP=new   List<Stock_In_Product__c>();
        Stock_In_Product__c  sInPro=new Stock_In_Product__c();
        sInPro.Stock_In__c=stIn1.id;
        sInPro.Pur_Order__c=transID1;
        sInPro.Product__c=pro.id;
        sInPro.Purchase_Order__c=porderp.id;
        sInPro.Quantity_Received__c=3;
        sInPro.Returned_Quantity__c=0;
        sInPro.Putaway_location__c=acc2.Id;
        sInPro.Product_Serial_Number__c=proPSN1.id;
        sInPro.Bin__c=sulLevelBinObj.id;
        sInPro.Expiry_Date__c=system.today()+30;
        sInPro.Status__c='Verified';
        sInPro.Return_Quantity_Comment__c='Stock receiving';
        sInPro.Lot__c = lot.Id;
        
        ListSRP.add(sInPro);
        
        Stock_In_Product__c  sInPro1=new Stock_In_Product__c();
        sInPro1.Stock_In__c=stIn1.id;
        sInPro1.Pur_Order__c=transID2;
        sInPro1.Product__c=pro.id;
        sInPro1.Purchase_Order__c=porderp1.id;
        sInPro1.Quantity_Received__c=3;
        sInPro1.Returned_Quantity__c=0;
        sInPro1.Putaway_location__c=acc2.Id;
        sInPro1.Status__c='Open';
        sInPro1.Return_Quantity_Comment__c='Stock receiving';
        sInPro1.Expiry_Date__c=system.today()+30;
        sInPro1.Lot__c = lot1.Id;
        sInPro1.Product_Serial_Number__c=proPSN1.id;
        sInPro1.Bin__c=sulLevelBinObj.id;
        
        ListSRP.add(sInPro1);
        
        Stock_In_Product__c  sInPro2=new Stock_In_Product__c();
        sInPro2.Stock_In__c=stIn1.id;
        sInPro2.Pur_Order__c=transID2;
        sInPro2.Product__c=pro1.id;
        sInPro2.Purchase_Order__c=porderp1.id;
        sInPro2.Quantity_Received__c=3;
        sInPro2.Returned_Quantity__c=0;
        sInPro2.Putaway_location__c=acc2.Id;
        sInPro2.Status__c='Verified';
        sInPro2.Return_Quantity_Comment__c='Stock receiving';
        sInPro2.Lot__c = lot2.Id;
        sInPro2.Expiry_Date__c=system.today()+30;
        sInPro2.Product_Serial_Number__c=proPSN2.id;
        sInPro2.Bin__c=sulLevelBinObj2.id;
       
        ListSRP.add(sInPro2);
        
        Stock_In_Product__c  sInPro3=new Stock_In_Product__c();
        sInPro3.Stock_In__c=stIn1.id;
        sInPro3.Product__c=pro2.id;
        sInPro3.Pur_Order__c=transID2;
        sInPro3.Purchase_Order__c=porderp1.id;
        sInPro3.Quantity_Received__c=3;
        sInPro3.Returned_Quantity__c=0;
        sInPro3.Putaway_location__c=acc2.Id;
        sInPro3.Status__c='Open';
        sInPro3.Expiry_Date__c=system.today()+30;
        sInPro3.Return_Quantity_Comment__c='Stock receiving';
        sInPro3.Lot__c = lot4.Id;
        sInPro3.Bin__c=sulLevelBinObj.id;
         
        ListSRP.add(sInPro3);
       
        
        Stock_In_Product__c  sInPro4=new Stock_In_Product__c();
        sInPro4.Stock_In__c=stIn1.id;
        sInPro4.Pur_Order__c=pord.id;
        sInPro4.Product__c=pro.id;
        sInPro4.Purchase_Order__c=porderp.id;
        sInPro4.Quantity_Received__c=3;
        sInPro4.Returned_Quantity__c=0;
        sInPro4.Putaway_location__c=acc2.Id;
        sInPro4.Bin__c=sulLevelBinObj2.id;
        sInPro4.Status__c='Verified';
        sInPro4.Expiry_Date__c=system.today()+30;
        sInPro4.Product_Serial_Number__c=proPSN1.id;
        sInPro4.Return_Quantity_Comment__c='Stock receiving';
        sInPro4.Lot__c = lot.Id;
        
        ListSRP.add(sInPro4);
        
        Stock_In_Product__c  sInPro5=new Stock_In_Product__c();
        sInPro5.Stock_In__c=stIn1.id;
        sInPro5.Pur_Order__c=pord.id;
        sInPro5.Product__c=pro.id;
        sInPro5.Purchase_Order__c=porderp.id;
        sInPro5.Quantity_Received__c=3;
        sInPro5.Returned_Quantity__c=0;
        sInPro5.Putaway_location__c=acc2.Id;
        sInPro5.Bin__c=sulLevelBinObj.id;
        sInPro5.Status__c='Verified';
        sInPro5.Expiry_Date__c=system.today()+30;
        sInPro5.Product_Serial_Number__c=proPSN1.id;
        sInPro5.Return_Quantity_Comment__c='Stock receiving';
        sInPro5.Lot__c = lot.Id;
       
        ListSRP.add(sInPro5);
        
        Stock_In_Product__c  sInPro6=new Stock_In_Product__c();
        sInPro6.Stock_In__c=stIn1.id;
        sInPro6.Pur_Order__c=pord.id;
        sInPro6.Product__c=pro.id;
        sInPro6.Purchase_Order__c=porderp.id;
        sInPro6.Quantity_Received__c=3;
        sInPro6.Returned_Quantity__c=0;
        sInPro6.Putaway_location__c=acc2.Id;
        sInPro6.Bin__c=sulLevelBinObj.id;
        sInPro6.Status__c='Open';
        sInPro6.Expiry_Date__c=system.today()+30;
        sInPro6.Product_Serial_Number__c=proPSN1.id;
        sInPro6.Return_Quantity_Comment__c='Stock receiving';
        sInPro6.Lot__c = lot.Id;
        ListSRP.add(sInPro6);
        
        Stock_In_Product__c  sInPro7=new Stock_In_Product__c();
        sInPro7.Stock_In__c=stIn1.id;
        sInPro7.Pur_Order__c=pord1.id;
        sInPro7.Product__c=pro2.id;
        sInPro7.Purchase_Order__c=porderp1.id;
        sInPro7.Quantity_Received__c=3;
        sInPro7.Returned_Quantity__c=0;
        sInPro7.Putaway_location__c=acc2.Id;
        sInPro7.Bin__c=sulLevelBinObj.id;
        sInPro7.Status__c='Verified';
        sInPro7.Expiry_Date__c=system.today()+30;
        sInPro7.Product_Serial_Number__c=proPSN1.id;
        sInPro7.Return_Quantity_Comment__c='Stock receiving';
        ListSRP.add(sInPro7);
        
        System.assertEquals(sInPro.Status__c,'Verified');
        System.assertEquals(sInPro1.Status__c,'Open');
        System.assertEquals(sInPro2.Status__c,'Verified');
        System.assertEquals(sInPro3.Status__c,'Open');
        System.assertEquals(sInPro4.Status__c,'Verified');
        System.assertEquals(sInPro5.Status__c,'Verified');
        System.assertEquals(sInPro6.Status__c,'Open');
        System.assertEquals(sInPro7.Status__c,'Verified');

        
        insert ListSRP;
        
        Lot_Product__c lotProd = new Lot_Product__c();
        lotProd.Lot__c = lot.Id;
        lotProd.Product__c = pro.Id;
        lotProd.Quantity__c = 10;
        lotProd.Bin__c=sulLevelBinObj.id;
        lotProd.Location__c = invloc2.id;
        insert lotProd;
        System.assertEquals(lotProd.Quantity__c,10);

        Lot_Product__c lotProd1 = new Lot_Product__c();
        lotProd1.Lot__c = lot.Id;
        lotProd1.Product__c = pro.Id;
        lotProd1.Quantity__c = 10;
        lotProd1.Bin__c=sulLevelBinObj2.id;
        lotProd1.Location__c = invloc2.id;
        insert lotProd1;
        System.assertEquals(lotProd1.Quantity__c,10);

        Lot_Product__c lotProd2 = new Lot_Product__c();
        lotProd2.Lot__c = lot1.Id;
        lotProd2.Product__c = pro1.Id;
        lotProd2.Quantity__c = 10;
        lotProd2.Location__c = invloc2.id;
        lotProd2.Bin__c=sulLevelBinObj.id;
        insert lotProd2;
        System.assertEquals(lotProd2.Quantity__c,10);

        Lot_Product__c lotProd3 = new Lot_Product__c();
        lotProd3.Lot__c = lot1.Id;
        lotProd3.Product__c = pro1.Id;
        lotProd3.Quantity__c = 10;
        lotProd3.Bin__c=sulLevelBinObj2.id;
        lotProd3.Location__c = invloc2.id;
        insert lotProd3;
        System.assertEquals(lotProd3.Quantity__c,10);

        Lot_Product__c lotProd4 = new Lot_Product__c();
        lotProd4.Lot__c = lot2.Id;
        lotProd4.Product__c = pro1.Id;
        lotProd4.Quantity__c = 10;
        lotProd4.Bin__c=sulLevelBinObj.id;
        lotProd4.Location__c = invloc2.id;
        insert lotProd4;
        System.assertEquals(lotProd4.Quantity__c,10);

        Lot_Product__c lotProd5 = new Lot_Product__c();
        lotProd5.Lot__c = lot2.Id;
        lotProd5.Product__c = pro1.Id;
        lotProd5.Quantity__c = 10;
        lotProd5.Bin__c=sulLevelBinObj2.id;
        lotProd5.Location__c = invloc2.id;
        insert lotProd5;
        System.assertEquals(lotProd5.Quantity__c,10);

        Lot_Product__c lotProd6 = new Lot_Product__c();
        lotProd6.Lot__c = lot3.Id;
        lotProd6.Product__c = pro.Id;
        lotProd6.Quantity__c = 10;
        lotProd6.Bin__c=sulLevelBinObj.id;
        lotProd6.Location__c = invloc2.id;
        insert lotProd6;
        System.assertEquals(lotProd6.Quantity__c,10);

        Lot_Product__c lotProd7 = new Lot_Product__c();
        lotProd7.Lot__c = lot4.Id;
        lotProd7.Product__c = pro2.Id;
        lotProd7.Quantity__c = 10;
        lotProd7.Bin__c=sulLevelBinObj.id;
        lotProd7.Location__c = invloc2.id;
        insert lotProd7;
        System.assertEquals(lotProd7.Quantity__c,10);

        Lot_Product__c lotProd8 = new Lot_Product__c();
        lotProd8.Lot__c = lot5.Id;
        lotProd8.Product__c = pro2.Id;
        lotProd8.Quantity__c = 10;
        lotProd8.Bin__c=sulLevelBinObj2.id;
        lotProd8.Location__c = invloc2.id;
        insert lotProd8;
        System.assertEquals(lotProd8.Quantity__c,10);
        //Product ILP
        Inventory_Location_Product__c ILP = new Inventory_Location_Product__c();
        ILP.Received_Quantity__c=20;
        ILP.Products__c = pro.id;
        insert ILP;
        System.assertEquals(ILP.Received_Quantity__c,20);
        
        //product ILPLI
        Inventory_Location_Product_Line_Item__c ILPLI = new Inventory_Location_Product_Line_Item__c();
        ILPLI.Received_Quantity__c=20;
        ILPLI.Product__c=pro.id;
        ILPLI.Inventory_Location_Product__c=ILP.id;
        ILPLI.Bin__c=sulLevelBinObj.id;
        ILPLI.Stock_Receiving_Product__c=sInPro.id;
        insert ILPLI;
        System.assertEquals(ILPLI.Received_Quantity__c,20);
        
        Inventory_Location_Product_Line_Item__c ILPLI3 = new Inventory_Location_Product_Line_Item__c();
        ILPLI3.Received_Quantity__c=20;
        ILPLI3.Product__c=pro.id;
        ILPLI3.Inventory_Location_Product__c=ILP.id;
        ILPLI3.Bin__c=sulLevelBinObj2.id;
        ILPLI3.Stock_Receiving_Product__c=sInPro6.id;
        insert ILPLI3;
        System.assertEquals(ILPLI3.Received_Quantity__c,20);
        
        //Product ILP
        Inventory_Location_Product__c ILP1 = new Inventory_Location_Product__c();
        ILP1.Received_Quantity__c=20;
        ILP1.Products__c = pro1.id;
        insert ILP1;
        System.assertEquals(ILP1.Received_Quantity__c,20);
        
        //product ILPLI
        Inventory_Location_Product_Line_Item__c ILPLI1 = new Inventory_Location_Product_Line_Item__c();
        ILPLI1.Received_Quantity__c=20;
        ILPLI1.Product__c=pro1.id;
        ILPLI1.Inventory_Location_Product__c=ILP.id;
        ILPLI1.Stock_Receiving_Product__c=sInPro2.id;
        ILPLI1.Bin__c=sulLevelBinObj.id;
        insert ILPLI1;
        System.assertEquals(ILPLI1.Received_Quantity__c,20);
        
        //Product ILP
        Inventory_Location_Product__c ILP2 = new Inventory_Location_Product__c();
        ILP2.Received_Quantity__c=20;
        ILP2.Products__c = pro2.id;
        insert ILP2;
        System.assertEquals(ILP2.Received_Quantity__c,20);
        
        //product ILPLI
        Inventory_Location_Product_Line_Item__c ILPLI2 = new Inventory_Location_Product_Line_Item__c();
        ILPLI2.Received_Quantity__c=20;
        ILPLI2.Product__c=pro2.id;
        ILPLI2.Inventory_Location_Product__c=ILP2.id;
        ILPLI2.Stock_Receiving_Product__c=sInPro3.id;
        ILPLI2.Bin__c=sulLevelBinObj.id;
        insert ILPLI2;
        System.assertEquals( ILPLI2.Bin__c,sulLevelBinObj.id);

        
         //product ILPLI
        Inventory_Location_Product_Line_Item__c ILPLI4 = new Inventory_Location_Product_Line_Item__c();
        ILPLI4.Received_Quantity__c=20;
        ILPLI4.Product__c=pro2.id;
        ILPLI4.Inventory_Location_Product__c=ILP2.id;
        ILPLI4.Stock_Receiving_Product__c=sInPro7.id;
        ILPLI4.Bin__c=sulLevelBinObj.id;
        insert ILPLI4;
        
        System.assertEquals(ILPLI4.Received_Quantity__c,20);
        
        List<Stock_Receiving_Product_Line_Item__c> srpList=new List<Stock_Receiving_Product_Line_Item__c>();
        Stock_Receiving_Product_Line_Item__c srpli1=new Stock_Receiving_Product_Line_Item__c();
        srpli1.Inventory_Location_Product__c=ILP.id;
        srpli1.Lot__c=lot.id;
        srpli1.Stock_Receiving_Product__c=sInPro.id;
        srpli1.Purchase_Order_Product__c=porderp.id;
        srpList.add(srpli1);

        
        Stock_Receiving_Product_Line_Item__c srpli2=new Stock_Receiving_Product_Line_Item__c();
        srpli2.Inventory_Location_Product__c=ILP.id;
        srpli2.Lot__c=lot.id;
        srpli2.Stock_Receiving_Product__c=sInPro4.id;
        srpli2.Purchase_Order_Product__c=porderp.id;
        srpList.add(srpli2);
        
        Stock_Receiving_Product_Line_Item__c srpli3=new Stock_Receiving_Product_Line_Item__c();
        srpli3.Inventory_Location_Product__c=ILP.id;
        srpli3.Lot__c=lot.id;
        srpli3.Stock_Receiving_Product__c=sInPro5.id;
        srpli3.Purchase_Order_Product__c=porderp.id;
        srpList.add(srpli3);
        
        Stock_Receiving_Product_Line_Item__c srpli4=new Stock_Receiving_Product_Line_Item__c();
        srpli4.Inventory_Location_Product__c=ILP.id;
        srpli4.Lot__c=lot3.id;
        srpli4.Stock_Receiving_Product__c=sInPro1.id;
        srpli4.Purchase_Order_Product__c=porderp1.id;
        srpList.add(srpli4);
        
        Stock_Receiving_Product_Line_Item__c srpli5=new Stock_Receiving_Product_Line_Item__c();
        srpli5.Inventory_Location_Product__c=ILP1.id;
        srpli5.Lot__c=lot2.id;
        srpli5.Stock_Receiving_Product__c=sInPro2.id;
        srpli5.Purchase_Order_Product__c=porderp1.id;
        srpList.add(srpli5);
        
        Stock_Receiving_Product_Line_Item__c srpli6=new Stock_Receiving_Product_Line_Item__c();
        srpli6.Inventory_Location_Product__c=ILP2.id;
        srpli6.Lot__c=lot5.id;
        srpli6.Stock_Receiving_Product__c=sInPro3.id;
        srpli6.Purchase_Order_Product__c=porderp1.id;
        srpList.add(srpli6);
        
        Stock_Receiving_Product_Line_Item__c srpli7=new Stock_Receiving_Product_Line_Item__c();
        srpli7.Inventory_Location_Product__c=ILP2.id;
        srpli7.Stock_Receiving_Product__c=sInPro7.id;
        srpli7.Purchase_Order_Product__c=porderp1.id;
        srpList.add(srpli7);
        
        insert srpList;
        String srId=stIn1.Id;
         System.assertEquals(srpli1.Lot__c,lot.id);
         System.assertEquals(srpli2.Lot__c,lot.id);
         System.assertEquals(srpli3.Lot__c,lot.id);
         System.assertEquals(srpli4.Lot__c,lot3.id);
         System.assertEquals(srpli5.Lot__c,lot2.id);
         System.assertEquals(srpli6.Lot__c,lot5.id);
         System.assertEquals(srpli7.Purchase_Order_Product__c,porderp1.id);

        List<StockReceivingLinesWrap> srlwList=new List<StockReceivingLinesWrap>();

        StockReceivingLinesWrap srlw= new StockReceivingLinesWrap();
        srlw.transID=pord.Id;
        List<StockReceivingLinesWrap.TransLineItems> transaLIList=new List<StockReceivingLinesWrap.TransLineItems>();

        StockReceivingLinesWrap.TransLineItems transaLI=new StockReceivingLinesWrap.TransLineItems();
        transaLI.attributeType='SERIALIZED';
        transaLI.productName=pro.name;
        transaLI.Receiving_Quantity_Original=5;
        transaLI.BinId=sulLevelBinObj.id;
         System.assertEquals(transaLI.productName,pro.name);

        StockReceivingLinesWrap.SRLineItemRec srlir=new StockReceivingLinesWrap.SRLineItemRec();
        srlir.Id=sInPro3.Id;
        srlir.TransactionID=pord.Id;
        srlir.Purchase_Order =porderp.Id;
        srlir.Product =pro1.Id;
        srlir.Ordered_Qty = 100;
        srlir.Quantity_Received =  50;
        srlir.Remaining_Quantity=50;
        srlir.Status='Verified'; 
        srlir.Putaway_location=acc2.id; 
        srlir.Lot=lot.id;
        transaLI.SRLineItemRec=srlir;
         System.assertEquals(srlir.Lot,lot.id);
        
        

        List<StockReceivingLinesWrap.serialNo> serNoList=new List<StockReceivingLinesWrap.serialNo>();
        for(Integer i=0;i<5;i++)
        {
            StockReceivingLinesWrap.serialNo serNo=new StockReceivingLinesWrap.serialNo();
            serNo.Serial_Number='123-'+i;
            serNoList.add(serNo);
        }

        transaLI.serialNo=serNoList;
        transaLIList.add(transaLI); 
        srlw.TransLineItems=transaLIList;
        srlwList.add(srlw);
        String srlwListJSON = JSON.serialize(srlwList);
        String srdata = JSON.serialize(stIn1);

        List<id> IdList=new List<id>(); 
        
        Test.startTest();
        NewStockreceiving.fetchStockReceivingItems(pord.id );
        NewStockreceiving.fetchStockLinesUpdate(srId);
        NewStockreceiving.saveStockReceiving(srdata,srlwListJSON);
        NewStockreceiving.removeSRP(IdList);
        Test.stopTest();
    }
}