@isTest
public Class SigmaorderCtrlTest {
     @IsTest(seeAllData=false)
     
     public static void testmethod1()
    {
          
        Currency__c curr = new Currency__c();
        curr.Name='Euro';
        curr.Symbol__c = '$';
        curr.Currency_Code__c = 'E';
        curr.Is_Default_Currency__c=true;
        insert curr;
        System.assertEquals( curr.Currency_Code__c , 'E'); 
        
        Currency_Exchange_Rate__c  CER = new Currency_Exchange_Rate__c();
        CER.Rate__c=2;
        CER.Currency__c=curr.id;
        insert CER;
          System.assertEquals(CER.Rate__c,2);
          
        
        
        Account acc = new  Account();
         acc.name='test1';
         acc.Customer_Type__c='Cash Customer';
         acc.Exchange_Currency__c=curr.id;
         acc.ShippingStreet ='PP Layout';
         acc.ShippingCity = 'Bangalore';
         acc.ShippingState = 'Karnataka';
         acc.ShippingPostalcode = '581354';
         acc.ShippingCountry = 'India';
         acc.Email__c='da@gmail.com';
         acc.Currency_code__c = 'GBP';
         acc.Type = 'Vendor';
         insert acc;
         System.assertEquals( acc.name,'test1');
         
         //account type customer
         Account acc1 = new  Account();
         acc1.name='test2';
         acc1.Customer_Type__c='Cash Customer';
         acc1.Currency_code__c = 'GBP';
         acc1.Exchange_Currency__c=curr.id;
         acc1.Email__c='dfs@gmail.com';
         acc1.Type = 'Customer';
         insert acc1;
         System.assertEquals( acc1.name,'test2');
         
         //Account type vendor
        Account acc2 = new  Account();
        acc2.name='rashmi';
        acc2.Exchange_Currency__c=curr.id;
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        acc2.Type = 'Vendor';
        acc2.Exchange_Currency__c=curr.id;
        acc2.Active__c='Yes';
        acc2.Email__c='kj@gmail.com';
        insert acc2;
        System.assertEquals( acc2.name,'rashmi');
        
         Contact con1 = new Contact();
         con1.FirstName = 'Harish';
         con1.LastName = 'Naik';
         con1.Account = acc1;
         insert con1;
         System.assertEquals( con1.FirstName,'Harish');
         
          
        //order usage
         Order_Usage__c OrderUsage = new Order_Usage__c(); 
         OrderUsage.Name='order';
         OrderUsage.Allocation__c = 'saleorder';
         OrderUsage.Allocation_in_Picking__c=false;
         OrderUsage.Allocation_in_Sales_Order__c=true;
         OrderUsage.Auto_Allocate_in_picking__c=false;
         OrderUsage.Sigma_order__c=true;
         OrderUsage.Standard_object__c=false;
         insert OrderUsage;
         System.assertEquals( OrderUsage.Allocation_in_Sales_Order__c,true);
      
         Default_Parameters__c DP = new Default_Parameters__c();
         DP.Name='defualt';
         DP.Inventory_Status__c='Reserve';
         DP.Auto_Reserve_Stock__c=true;
         insert DP;
         System.assertEquals( DP.Auto_Reserve_Stock__c,true);
         
      
        Dimension_Tag__c DimeTag = new Dimension_Tag__c();
        DimeTag.Base_Credit_Limit__c =1000;
        DimeTag.Account__c=acc1.id;
        insert DimeTag;
        System.assertEquals( DimeTag.Base_Credit_Limit__c,1000);
        
        
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
        
    
        Inventory__c PI = new Inventory__c();
        PI.ProductCode__c=prod.id;
        PI.Available_Qty__c = 10;
        insert PI;
        System.assertEquals(PI.Available_Qty__c,10);
        
       
        Inventory_Location_Product__c ILP = new Inventory_Location_Product__c();
        ILP.Received_Quantity__c=20;
        ILP.Products__c = prod.id;
        insert ILP;
        System.assertEquals(ILP.Received_Quantity__c,20);
        
      
        Inventory_Location_Product_Line_Item__c ILPLI = new Inventory_Location_Product_Line_Item__c();
        ILPLI.Received_Quantity__c=20;
        ILPLI.Product__c=prod.id;
        ILPLI.Inventory_Location_Product__c=ILP.id;
        insert ILPLI;
        System.assertEquals(ILPLI.Received_Quantity__c,20);
        
        Community_Configuration__c CC =  new Community_Configuration__c();
        CC.Name = 'Community Configurations';
        CC.Retailer_Community_URL__c = 'https://ssigma-mvp-dev2-dev-ed-developer-edition.ap17.force.com/Retailer';
        CC.Products_Per_Page__c = 24;
        CC.Retailer_Profile_Name__c = 'Retailer Community Plus User';
        CC.Vendor_Community_URL__c = 'https://ssigma-mvp-dev2-dev-ed-developer-edition.ap17.force.com/shoppingcart';
        CC.Vendor_Profile_Name__c = 'Vendor Community Plus User'; 
        Insert CC;
        
        Id Proorder = Schema.SObjectType.Sigma_Order__c.getRecordTypeInfosByName().get('Product Order').getRecordTypeId();
       
        Sigma_Order__c SO = new Sigma_Order__c();
        SO.AccountId__c = acc1.id;
        SO.Billing_Contact__c=con1.id;
        SO.Billing_Person__c='Harish Naik';
        SO.Orders_Status__c='Order Confirmed';
        SO.Customer_Type__c='Cash Customer';
        SO.Delivary_Date__c = System.today();
        SO.Currency__c=curr.id;
        insert SO;
        System.assertEquals(SO.Orders_Status__c,'Order Confirmed');
        String SerializeSO = JSON.serialize(SO);    
    
        Product_Order_Price_Book__c SOL = new Product_Order_Price_Book__c();
        SOL.Product__c=prod.id;
        SOL.Net_Quantity__c = 2;
        SOL.Quantity__c = 2;
        SOL.Total_Amount__c=100;
        SOL.Total_Price__c = 200;
        SOL.Delivary_Date__c =System.today()+5;
        SOL.Order_Status__c = 'Order Confirmed';
        SOL.Sigma_Order__c=SO.id;
        SOL.Back_Order__c = false;
        SOL.IsInventoryUpdated__c = false;
        insert SOL;
        System.assertEquals(SOL.Quantity__c,2);
        String SerializeSOL = JSON.serialize(SOL);  
    
       
         List<SigmaorderCtrl.ILPLISaveWrap> ilplidata1=new List<SigmaorderCtrl.ILPLISaveWrap>();
         SigmaorderCtrl.ILPLISaveWrap ilpli2=new SigmaorderCtrl.ILPLISaveWrap();
         ilpli2.Id = ILPLI.id;
         ilpli2.enteredQuant = 2;
         ilpliData1.add(ilpli2);
         System.assertEquals(ilpli2.enteredQuant ,2);

      
        SigmaorderCtrl.SigmaOrderWrap SigmaOrderWrap1=new SigmaorderCtrl.SigmaOrderWrap();
        SigmaOrderWrap1.hasBackOrder=false;
        SigmaOrderWrap1.isDisabled = false;
        SigmaOrderWrap1.isDisplay  = false;
        SigmaOrderWrap1.orderLines=SOL;
        SigmaOrderWrap1.ilpliData = ilplidata1;
        SigmaOrderWrap1.stockExist='true';
        System.assertEquals(SigmaOrderWrap1.stockExist,'true');
     
        
        Test.startTest();
        SigmaorderCtrl.fetchAddress(acc2.id);
        SigmaorderCtrl.fetchAccountRelatedDataWrap(acc1.id);
        SigmaorderCtrl.fetchDefualtConfig();
        SigmaorderCtrl.fetchallocation();
       // SigmaorderCtrl.getProdRelData(prod.id,acc1.Id);
        SigmaorderCtrl.fetchILPLIDataForManualSelection(prod.id);
        Test.stopTest();     
        
    } 
    
     @IsTest(seeAllData=false)
     public static void testmethod3()
     {
  
        
        Account acc2 = new Account();
        acc2.Name = 'Test-1';
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        acc2.Type = 'Packaged Location';
        acc2.Email__c='vf@gmail.com';
        acc2.Customer_Type__c='Cash Customer';
        insert acc2;
        System.assertEquals(acc2.Name , 'Test-1');
        
        
        
        Account acc33 = new Account();
        acc33.Name = 'Test-33';
        acc33.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        acc33.Type = 'Packaged Location';
        acc33.Email__c='ngh@gmail.com';
        acc33.Customer_Type__c='Credit Customer';
        acc33.Base_Credit_Limit__c=20000;
        insert acc33;
        System.assertEquals( acc33.Name ,'Test-33');
        
        
        Default_Parameters__c param = new Default_Parameters__c(); 
        param.Name='defulat';
        param.Parent_Id__c = acc2.id;
        param.Inventory_Status__c='Allocated';
        insert param;
        System.assertEquals(param.Name,'defulat');
        
        Order_Usage__c Orderusage= new Order_Usage__c();
        Orderusage.Name= 'orderusage';
        Orderusage.Allocation_in_Picking__c =true;
        insert Orderusage;
        System.assertEquals(Orderusage.Name, 'orderusage'); 
       
       
        Id RIDBOM = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('BOM').getRecordTypeId();
        Product2 Pro1= new Product2();
        Pro1.Name='test';
        Pro1.Product_Description__c='test description';
        Pro1.Product_Price__c=100;
        Pro1.Buying_Price__c=20;
        Pro1.Max_Discount__c=30;
        Pro1.Product_Weight__c = 3 ;
        Pro1.SKU__c = 'testing';
        Pro1.Type__c = 'BOM';
        Pro1.RecordtypeId = RIDBOM;
        insert Pro1;
        System.assertEquals(Pro1.name, 'test');
        
       Inventory__c PI = new Inventory__c();
        PI.ProductCode__c =Pro1.Id;
        PI.Delivered_Qty__c=0;
        PI.Total_Available_Qty__C=0;
        PI.Total_Qty__c=0;
        PI.Reserved_Qty__c=2;
        PI.Available_Qty__c=10;
        PI.Account__c=param.Parent_Id__c;
        PI.Quantity_To_Become_Out_Of_Stock__c=0;
        insert PI;
         System.assertEquals(PI.Reserved_Qty__c,2);
         
        Inventory_Location_Product__c ilp = new Inventory_Location_Product__c();
        ilp.Products__c = Pro1.Id;
        ilp.Inventory__c = PI.id;
        insert ilp;
         System.assertEquals( ilp.Products__c , Pro1.Id);
        
       
       List<Inventory_Location_Product_Line_Item__c> ilpliNewList = new List<Inventory_Location_Product_Line_Item__c>();
         
        Inventory_Location_Product_Line_Item__c ilpli1 = new Inventory_Location_Product_Line_Item__c();
        ilpli1.Inventory_Location_Product__c = ilp.Id;
       ilpli1.Reserved_Quantity__c = 0;
        ilpliNewList.add(ilpli1);
         System.assertEquals( ilpli1.Reserved_Quantity__c , 0 );

        Inventory_Location_Product_Line_Item__c ilpli2 = new Inventory_Location_Product_Line_Item__c();
        ilpli2.Inventory_Location_Product__c = ilp.Id;
        ilpli2.Reserved_Quantity__c = 0;
        ilpliNewList.add(ilpli2);
         System.assertEquals(ilpli2.Reserved_Quantity__c , 0);
      
        Community_Configuration__c CC =  new Community_Configuration__c();
        CC.Name = 'Community Configurations';
        CC.Retailer_Community_URL__c = 'https://ssigma-mvp-dev2-dev-ed-developer-edition.ap17.force.com/Retailer';
        CC.Products_Per_Page__c = 24;
        CC.Retailer_Profile_Name__c = 'Retailer Community Plus User';
        CC.Vendor_Community_URL__c = 'https://ssigma-mvp-dev2-dev-ed-developer-edition.ap17.force.com/shoppingcart';
        CC.Vendor_Profile_Name__c = 'Vendor Community Plus User'; 
        Insert CC;
        
        Id RIDBOM1 = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('BOM').getRecordTypeId();
        Product2 Pro2= new Product2();
        Pro2.Name='test';
        Pro2.Product_Description__c='test description';
        Pro2.Product_Price__c=100;
        Pro2.Buying_Price__c=20;
        Pro2.Max_Discount__c=30;
        Pro2.Product_Weight__c = 3 ;
        Pro2.SKU__c = 'testing1';
        Pro2.Type__c = 'BOM';
        Pro2.RecordtypeId = RIDBOM1;
        insert Pro2;
        System.assertEquals(Pro2.name, 'test');
        
        Inventory__c PI1 = new Inventory__c();
        PI1.ProductCode__c =Pro2.Id;
        PI1.Delivered_Qty__c=0;
        PI1.Total_Available_Qty__C=0;
        PI1.Total_Qty__c=0;
        PI1.Reserved_Qty__c=2;
        PI1.Available_Qty__c=10;
        PI1.Account__c=param.Parent_Id__c;
        PI1.Quantity_To_Become_Out_Of_Stock__c=0;
        insert PI1;
        System.assertEquals( PI1.Delivered_Qty__c,0);
        
      
        Product_Serial_Number__c PSN = new Product_Serial_Number__c();
        PSN.Status__c='Allocate'; 
        PSN.Serial_Number__c='HMN';
        insert PSN;
        System.assertEquals(PSN.Serial_Number__c,'HMN');
        
        Lot__c lot = new Lot__c();
        lot.Product__c=Pro2.Id;
        lot.Lot_Name__c='lot1';
        lot.Quantity__c = 2;
        lot.Created_Date__c =system.today();
        lot.Expiry_Date__c = system.today()+4;
        insert lot;
        System.assertEquals(lot.Quantity__c,2);
        
        Account acc22 = new Account();
        acc22.Name = 'Bangalore';
        acc22.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();
        acc22.Type = 'Location';
        insert acc22;
        System.assertEquals(acc22.Name ,'Bangalore');
        
        
        
        Inventory_Location__c IL = new Inventory_Location__c();
        IL.Location__c=acc22.id;
        IL.Inventory__c =PI1.id;
        insert IL; 
        System.assertEquals( IL.Location__c,acc22.id);   
        
        Inventory_Location_Product__c ilp1 = new Inventory_Location_Product__c();
        ilp1.Products__c = Pro2.Id;
        ilp1.Inventory__c = PI1.id;
        ilp1.Received_Quantity__c =2;
        ilp1.Inventory_Location__c=IL.id;
        insert ilp1;
        System.assertEquals(ilp1.Inventory__c,PI1.id);
        
        Inventory_Location_Product_Line_Item__c ilpli3 = new Inventory_Location_Product_Line_Item__c();
        ilpli3.Inventory_Location_Product__c = ilp1.Id;
        ilpli3.Lot__c =lot.id;
        ilpli3.Received_Quantity__c=10;
        ilpli3.Reserved_Quantity__c = 0;
        ilpliNewList.add(ilpli3);
        System.assertEquals(ilpli3.Lot__c,lot.id);
        

        Inventory_Location_Product_Line_Item__c ilpli4 = new Inventory_Location_Product_Line_Item__c();
        ilpli4.Inventory_Location_Product__c = ilp1.Id;
        ilpli4.Lot__c= lot.id;
        ilpli4.Product_Serial_Number__c=PSN.id;
        ilpli4.Product_Received_date__c=system.today();
        ilpli4.Received_Quantity__c=10;
        ilpli4.Reserved_Quantity__c = 2;
        ilpli4.Product_Expiry_Date__c =system.today()+1;
        ilpliNewList.add(ilpli4);
        insert ilpliNewList;
        System.assertEquals(ilpli4.Lot__c,lot.id);
        
        Pricebookentry pbe = new Pricebookentry();    
        pbe.Product2Id = Pro1.id;
        pbe.PriceBook2Id=Test.getStandardPricebookId();
        pbe.UnitPrice = 100;  
        pbe.IsActive = true;
        pbe.UseStandardPrice = false;
        insert pbe;
        System.assertEquals(pbe.UnitPrice,100);
        
         
        Sigma_Order__c so=new Sigma_Order__c(AccountId__c=acc22.id,Customer_Type__c='Cash Customer',Orders_Status__c='Order Confirmed');
        insert so;
        System.assertEquals(so.AccountId__c,acc22.id);
        
        
        Product_Order_Price_Book__c sol1=new Product_Order_Price_Book__c (Sigma_Order__c=so.id,Product__c=Pro2.id,Net_Quantity__c=2,Quantity__c=2,Total_Amount__c=100,Total_Price__c=100,Order_Status__c='Order Confirmed',Back_Order__c=false,IsInventoryUpdated__c=false,Stock_Fulfilled__c =true);
        insert sol1;
         System.assertEquals(sol1.Sigma_Order__c,so.id);
        
      
        List<SigmaorderCtrl.ILPLISaveWrap> ilplidata2=new List<SigmaorderCtrl.ILPLISaveWrap>();
         SigmaorderCtrl.ILPLISaveWrap ilplidata3=new SigmaorderCtrl.ILPLISaveWrap();
         ilplidata3.Id = ilpli4.id;
         ilplidata3.enteredQuant = 2;
         ilpliData2.add(ilplidata3);
         System.assertEquals( ilplidata3.enteredQuant,2);
               
      
        List<SigmaorderCtrl.SigmaOrderWrap> SigmaOrderWrapdata=new List<SigmaorderCtrl.SigmaOrderWrap>();
        SigmaorderCtrl.SigmaOrderWrap SigmaOrderWrap1=new SigmaorderCtrl.SigmaOrderWrap();
        SigmaOrderWrap1.hasBackOrder=false;
        SigmaOrderWrap1.isDisabled = false;
        SigmaOrderWrap1.isDisplay  = false;
        SigmaOrderWrap1.orderLines=sol1;
        SigmaOrderWrap1.ilpliData = ilplidata2;
        SigmaOrderWrap1.stockExist='true';
        SigmaOrderWrapdata.add(SigmaOrderWrap1);
         System.assertEquals(SigmaOrderWrap1.stockExist,'true'); 
   
        
         List<SigmaorderCtrl.responseWrap> responseWrapdata=new List<SigmaorderCtrl.responseWrap>();
         SigmaorderCtrl.responseWrap response=new SigmaorderCtrl.responseWrap();
         response.message = 'hii';
         response.data = 'data';
         response.soName = 'SO123';
         response.proformaCheck = true;
         responseWrapdata.add(response);
         System.assertEquals(response.message,'hii');
        
        Dimension_Tag__c  DT = new Dimension_Tag__c();
        DT.Ordered_Amount__c =0;
        DT.Account__c=acc33.id;
        insert DT;
        System.assertEquals(DT.Ordered_Amount__c,0);
       
        SigmaorderCtrl.SigmaOrderUpdateWrap sow=SigmaorderCtrl.getSigmaOrderData(so.id);
    
        
        String soJSON = JSON.serialize(sow.sigmaOrder);
        String solJSON = JSON.serialize(sow.solWrap);
        
        String solJSON11 = JSON.serialize(SigmaOrderWrapdata);
        boolean autostock =true;
        system.debug('serializedata'+solJSON11);
       


        Test.StartTest();
     
        boolean isupdate = false;
        SigmaorderCtrl.saveSigmaOrder(soJSON,solJSON11,autostock,isupdate);
        
        SigmaorderCtrl.automateStockReservation(soJSON,solJSON);
      
        
        so.Status__c='Cancelled';
        update so;
        

        
         Test.stopTest(); 
      }
    
    
    
     @IsTest(seeAllData=false)
     public static void testmethod2()
     {
         
        Currency__c curr = new Currency__c();
        curr.Name='Euro';
        curr.Symbol__c = '$';
        curr.Currency_Code__c = 'E';
        curr.Is_Default_Currency__c=true;
        insert curr;
        System.assertEquals( curr.Symbol__c , '$');
        
        Currency_Exchange_Rate__c  CER = new Currency_Exchange_Rate__c();
        CER.Rate__c=2;
        CER.Currency__c=curr.id;
        insert CER;
        System.assertEquals(CER.Rate__c,2);
        
       
        Account acc1 = new  Account();
        acc1.name='rashmi';
        acc1.Exchange_Currency__c=curr.id;
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        acc1.Type = 'Vendor';
        acc1.Email__c='fs@gmail.com';
        acc1.Active__c='Yes';
        insert acc1;
        System.assertEquals(acc1.name,'rashmi');
        
        Account acc2 = new Account();
        acc2.Name = 'Test-1';
        acc2.Exchange_Currency__c=curr.id;
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        acc2.Type = 'Packaged Location';
        acc2.Email__c='sdf@gmail.com';
        acc2.Customer_Type__c='Cash Customer';
        insert acc2;
        System.assertEquals(acc2.Type,'Packaged Location');
        
        Contact con =  new Contact();
        con.FirstName = 'Test1';
        con.LastName = 'con';
        con.Account= acc2;
        insert con;
        System.assertEquals(con.Account,acc2);
        
        
        Default_Parameters__c param = new Default_Parameters__c(); 
        param.Name='defulat';
        param.Parent_Id__c = acc2.id;
        param.Inventory_Status__c='Reserve';
        insert param;
        System.assertEquals(param.Name,'defulat');
        
        Order_Usage__c Orderusage= new Order_Usage__c();
        Orderusage.Name= 'orderusage';
        Orderusage.Allocation_in_Sales_Order__c =true;
        insert Orderusage;
        System.assertEquals(Orderusage.Name,'orderusage');
       
        Community_Configuration__c CC =  new Community_Configuration__c();
        CC.Name = 'Community Configurations';
        CC.Retailer_Community_URL__c = 'https://ssigma-mvp-dev2-dev-ed-developer-edition.ap17.force.com/Retailer';
        CC.Products_Per_Page__c = 24;
        CC.Retailer_Profile_Name__c = 'Retailer Community Plus User';
        CC.Vendor_Community_URL__c = 'https://ssigma-mvp-dev2-dev-ed-developer-edition.ap17.force.com/shoppingcart';
        CC.Vendor_Profile_Name__c = 'Vendor Community Plus User'; 
        Insert CC;
        
        Product2 Pro1 = new Product2(Name='Product - 1',Attribute_Type__c='BULK',IsActive=true);
        Pro1.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('BOM').getRecordTypeId();
        Insert Pro1;
        System.assertEquals(Pro1.Name,'Product - 1');
        
        Inventory__c PI = new Inventory__c();
        PI.ProductCode__c =Pro1.Id;
        PI.Delivered_Qty__c=0;
        PI.Total_Available_Qty__C=0;
        PI.Total_Qty__c=0;
        PI.Account__c=param.Parent_Id__c;
        PI.Quantity_To_Become_Out_Of_Stock__c=0;
        insert PI;
        System.assertEquals(PI.Delivered_Qty__c,0);
        
         
        Inventory_Location_Product__c ilp = new Inventory_Location_Product__c();
        ilp.Products__c = Pro1.Id;
        ilp.Inventory__c = PI.id;
        insert ilp;
        System.assertEquals(ilp.Inventory__c ,PI.id);
        
        List<Inventory_Location_Product_Line_Item__c> ilpliNewList = new List<Inventory_Location_Product_Line_Item__c>();
         
        Inventory_Location_Product_Line_Item__c ilpli1 = new Inventory_Location_Product_Line_Item__c();
        ilpli1.Inventory_Location_Product__c = ilp.Id;
        ilpli1.Reserved_Quantity__c = 0;
        ilpliNewList.add(ilpli1);
        System.assertEquals(ilpli1.Reserved_Quantity__c ,0);

        Inventory_Location_Product_Line_Item__c ilpli2 = new Inventory_Location_Product_Line_Item__c();
        ilpli2.Inventory_Location_Product__c = ilp.Id;
        ilpli2.Reserved_Quantity__c = 0;
        ilpliNewList.add(ilpli2);
        System.assertEquals(ilpli2.Reserved_Quantity__c ,0);
        
        Product2 Pro2 = new Product2(Name='Product - 2',Attribute_Type__c='BULK',IsActive=true);
        Pro1.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('BOM').getRecordTypeId();
        Insert Pro2;
        System.assertEquals(Pro2.Name,'Product - 2');
        
        
        Inventory__c PI1 = new Inventory__c();
        PI1.ProductCode__c =Pro2.Id;
        PI1.Delivered_Qty__c=0;
        PI1.Total_Available_Qty__C=0;
        PI1.Total_Qty__c=0;
        PI1.Account__c=param.Parent_Id__c;
        PI1.Quantity_To_Become_Out_Of_Stock__c=0;
        insert PI1;
        System.assertEquals(PI1.Total_Available_Qty__C,0);
        
        Inventory_Location_Product__c ilp1 = new Inventory_Location_Product__c();
        ilp1.Products__c = Pro2.Id;
        ilp1.Inventory__c = PI1.id;
        insert ilp1;
         System.assertEquals(ilp1.Products__c ,Pro2.Id);
        
        Inventory_Location_Product_Line_Item__c ilpli3 = new Inventory_Location_Product_Line_Item__c();
        ilpli3.Inventory_Location_Product__c = ilp1.Id;
        ilpli3.Reserved_Quantity__c = 0;
        ilpliNewList.add(ilpli3);
         System.assertEquals( ilpli3.Reserved_Quantity__c,0);

        Inventory_Location_Product_Line_Item__c ilpli4 = new Inventory_Location_Product_Line_Item__c();
        ilpli4.Inventory_Location_Product__c = ilp1.Id;
        ilpli4.Reserved_Quantity__c = 0;
        ilpliNewList.add(ilpli4);
        insert ilpliNewList;
         System.assertEquals(ilpli4.Reserved_Quantity__c,0);
        
        
        Pricebookentry pbe = new Pricebookentry();    
        pbe.Product2Id = Pro1.id;
        pbe.PriceBook2Id=Test.getStandardPricebookId();
        pbe.UnitPrice = 100;  
        pbe.IsActive = true;
        pbe.UseStandardPrice = false;
        insert pbe;
        System.assertEquals( pbe.UnitPrice,100);
        
        Sigma_Order__c so=new Sigma_Order__c(AccountId__c=acc2.id,Currency__c=curr.id,Customer_Type__c='Cash Customer',Orders_Status__c='Order Confirmed',BillingPersonNew__c=con.id);
        insert so;
        System.assertEquals(so.AccountId__c,acc2.id);
        
        Product_Order_Price_Book__c sol=new Product_Order_Price_Book__c (Sigma_Order__c=so.id,Product__c=Pro1.id,Net_Quantity__c=2,Quantity__c=2,Total_Amount__c=100,Total_Price__c=100,Order_Status__c='Order Confirmed',Back_Order__c=false,IsInventoryUpdated__c=false);
        insert sol;
        System.assertEquals(sol.Sigma_Order__c,so.id);
        
        
        Product_Order_Price_Book__c sol1=new Product_Order_Price_Book__c (Sigma_Order__c=so.id,Product__c=Pro2.id,Net_Quantity__c=2,Quantity__c=2,Total_Amount__c=100,Total_Price__c=100,Order_Status__c='Order Confirmed',Back_Order__c=true,IsInventoryUpdated__c=false,Stock_Fulfilled__c =true);
        insert sol1;
        System.assertEquals(sol1.Sigma_Order__c,so.id);
        
         
         
         List<SigmaorderCtrl.ILPLISaveWrap> ilplidata2=new List<SigmaorderCtrl.ILPLISaveWrap>();
         SigmaorderCtrl.ILPLISaveWrap ilplidata3=new SigmaorderCtrl.ILPLISaveWrap();
         ilplidata3.Id = ilpli4.id;
         ilplidata3.enteredQuant = 2;
         ilpliData2.add(ilplidata3);
         System.assertEquals(ilplidata3.enteredQuant,2);     
      
        List<SigmaorderCtrl.SigmaOrderWrap> SigmaOrderWrapdata=new List<SigmaorderCtrl.SigmaOrderWrap>();
        SigmaorderCtrl.SigmaOrderWrap SigmaOrderWrap1=new SigmaorderCtrl.SigmaOrderWrap();
        SigmaOrderWrap1.hasBackOrder=false;
        SigmaOrderWrap1.isDisabled = false;
        SigmaOrderWrap1.isDisplay  = false;
        SigmaOrderWrap1.orderLines=sol1;
        SigmaOrderWrap1.ilpliData = ilplidata2;
        SigmaOrderWrap1.stockExist='false';
        SigmaOrderWrapdata.add(SigmaOrderWrap1);
        System.assertEquals( SigmaOrderWrap1.isDisplay,false);
        
        Inventory_Allocation__c IA = new  Inventory_Allocation__c();
         IA.ILPLI__c=ilpli4.id;
         IA.Order_Line__c=sol.id;
         IA.Quantity__c=ilplidata3.enteredQuant;
         insert IA;
         System.assertEquals( IA.Order_Line__c,sol.id);
         
        
         
        String solJSON11 = JSON.serialize(SigmaOrderWrapdata);
        SigmaorderCtrl.SigmaOrderUpdateWrap sow=SigmaorderCtrl.getSigmaOrderData(so.id);
        String soJSON = JSON.serialize(sow.sigmaOrder);
        String solJSON = JSON.serialize(sow.solWrap);
        boolean autostock =true;
        boolean isupdate = false;
       


        Test.StartTest();
       
        
        SigmaorderCtrl.saveSigmaOrder(soJSON,solJSON11,autostock,isupdate);
        so.Status__c='Cancelled';
        update so;
        
        SigmaorderCtrl.SigmaOrderUpdateWrap sow1=SigmaorderCtrl.getSigmaOrderData(so.id);
        string soJSON1 = JSON.serialize(sow1.sigmaOrder);
        String solJSON1 = JSON.serialize(sow1.solWrap);
        
        SigmaorderCtrl.saveSigmaOrder(soJSON1,solJSON1,autostock,isupdate);
         Test.stopTest(); 
      }
      
     @IsTest(seeAllData=false)
     public static void testmethod4()
     {
         
        
        Account acc2 = new Account();
        acc2.Name = 'Test-1';
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        acc2.Type = 'Packaged Location';
        acc2.Email__c='kj@gmail.com';
        acc2.Customer_Type__c='Cash Customer';
        insert acc2;
        System.assertEquals(acc2.Type,'Packaged Location');
        
        Account acc33 = new Account();
        acc33.Name = 'Test-33';
        acc33.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        acc33.Type = 'Packaged Location';
        acc33.Email__c='kj@gmail.com';
        acc33.Customer_Type__c='Credit Customer';
         acc33.Base_Credit_Limit__c=20000;
        insert acc33;
        System.assertEquals(acc33.Type,'Packaged Location');
        
        
        Default_Parameters__c param = new Default_Parameters__c(); 
        param.Name='defulat';
        param.Parent_Id__c = acc2.id;
        param.Inventory_Status__c='Allocated';
        insert param;
        System.assertEquals(param.Parent_Id__c,acc2.id);
        
        Order_Usage__c Orderusage= new Order_Usage__c();
        Orderusage.Name= 'orderusage';
        Orderusage.Allocation_in_Picking__c =true;
        insert Orderusage;
        System.assertEquals(Orderusage.Name,'orderusage');
       
        Community_Configuration__c CC =  new Community_Configuration__c();
        CC.Name = 'Community Configurations';
        CC.Retailer_Community_URL__c = 'https://ssigma-mvp-dev2-dev-ed-developer-edition.ap17.force.com/Retailer';
        CC.Products_Per_Page__c = 24;
        CC.Retailer_Profile_Name__c = 'Retailer Community Plus User';
        CC.Vendor_Community_URL__c = 'https://ssigma-mvp-dev2-dev-ed-developer-edition.ap17.force.com/shoppingcart';
        CC.Vendor_Profile_Name__c = 'Vendor Community Plus User'; 
        Insert CC;
       
       Product2 Pro1 = new Product2(Name='Product - 1',Attribute_Type__c='BULK',IsActive=true);
        Pro1.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('BOM').getRecordTypeId();
        Insert Pro1;
        System.assertEquals(Pro1.Name,'Product - 1');
        
        Inventory__c PI = new Inventory__c();
        
        PI.ProductCode__c =Pro1.Id;
        PI.Delivered_Qty__c=0;
        PI.Total_Available_Qty__C=0;
        PI.Total_Qty__c=0;
        PI.Reserved_Qty__c=0;
        PI.Available_Qty__c=10;
        PI.Account__c=param.Parent_Id__c;
        PI.Quantity_To_Become_Out_Of_Stock__c=0;
        insert PI;
         System.assertEquals(PI.Delivered_Qty__c,0);
        
        Inventory_Location_Product__c ilp = new Inventory_Location_Product__c();
        ilp.Products__c = Pro1.Id;
        ilp.Inventory__c = PI.id;
        insert ilp;
         System.assertEquals(ilp.Products__c , Pro1.Id);
        
        List<Inventory_Location_Product_Line_Item__c> ilpliNewList = new List<Inventory_Location_Product_Line_Item__c>();
         
        Inventory_Location_Product_Line_Item__c ilpli1 = new Inventory_Location_Product_Line_Item__c();
        ilpli1.Inventory_Location_Product__c = ilp.Id;
        ilpli1.Reserved_Quantity__c = 0;
        ilpliNewList.add(ilpli1);
         System.assertEquals(ilpli1.Reserved_Quantity__c , 0);

        Inventory_Location_Product_Line_Item__c ilpli2 = new Inventory_Location_Product_Line_Item__c();
        ilpli2.Inventory_Location_Product__c = ilp.Id;
        ilpli2.Reserved_Quantity__c = 0;
        ilpliNewList.add(ilpli2);
        System.assertEquals(ilpli2.Reserved_Quantity__c , 0);
        
        Product2 Pro2 = new Product2(Name='Product - 2',Attribute_Type__c='BULK',IsActive=true);
        Pro1.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('BOM').getRecordTypeId();
        Insert Pro2;
        System.assertEquals(Pro2.Name , 'Product - 2');
        
        
        Inventory__c PI1 = new Inventory__c();
        PI1.ProductCode__c =Pro2.Id;
        PI1.Delivered_Qty__c=0;
        PI1.Total_Available_Qty__C=0;
        PI1.Total_Qty__c=0;
        PI1.Account__c=param.Parent_Id__c;
        PI1.Quantity_To_Become_Out_Of_Stock__c=0;
        insert PI1;
        System.assertEquals(PI1.Total_Available_Qty__C ,0);
        
      
        Product_Serial_Number__c PSN = new Product_Serial_Number__c();
        PSN.Status__c='Allocate'; 
        PSN.Serial_Number__c='HMN';
        insert PSN;
        System.assertEquals(PSN.Status__c,'Allocate');
        
        
        
        Lot__c lot = new Lot__c();
        lot.Product__c=Pro2.Id;
        lot.Lot_Name__c='lot1';
        lot.Quantity__c = 2;
        lot.Created_Date__c =system.today();
        lot.Expiry_Date__c = system.today()+4;
        insert lot;
        System.assertEquals(lot.Quantity__c ,2);
        
        
        Account acc22 = new Account();
        acc22.Name = 'Bangalore';
        acc22.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();
        acc22.Type = 'Location';
        insert acc22;
        System.assertEquals(acc22.Name ,'Bangalore');
        
        
        Inventory_Location__c IL = new Inventory_Location__c();
        IL.Location__c=acc22.id;
        IL.Inventory__c =PI1.id;
        insert IL; 
        System.assertEquals( IL.Inventory__c,PI1.id);       
        
        Inventory_Location_Product__c ilp1 = new Inventory_Location_Product__c();
        ilp1.Products__c = Pro2.Id;
        ilp1.Inventory__c = PI1.id;
        ilp1.Received_Quantity__c =10;
        ilp1.Inventory_Location__c=IL.id;
        insert ilp1;
        System.assertEquals(ilp1.Inventory__c ,PI1.id); 
        
        
        Inventory_Location_Product_Line_Item__c ilpli3 = new Inventory_Location_Product_Line_Item__c();
        ilpli3.Inventory_Location_Product__c = ilp1.Id;
        ilpli3.Reserved_Quantity__c = 0;
        ilpliNewList.add(ilpli3);
        System.assertEquals( ilpli3.Reserved_Quantity__c,0);    

        Inventory_Location_Product_Line_Item__c ilpli4 = new Inventory_Location_Product_Line_Item__c();
        ilpli4.Inventory_Location_Product__c = ilp1.Id;
        ilpli4.Lot__c= lot.id;
        ilpli4.Product_Serial_Number__c=PSN.id;
        ilpli4.Product_Received_date__c=system.today();
        ilpli4.Received_Quantity__c=10;
        ilpli4.Reserved_Quantity__c = 2;
        ilpli4.Product_Expiry_Date__c =system.today()+1;
        ilpliNewList.add(ilpli4); 
        insert ilpliNewList;
        System.assertEquals( ilpli4.Reserved_Quantity__c,2);
        
        
        Pricebookentry pbe = new Pricebookentry();    
        pbe.Product2Id = Pro1.id;
        pbe.PriceBook2Id=Test.getStandardPricebookId();
        pbe.UnitPrice = 100;  
        pbe.IsActive = true;
        pbe.UseStandardPrice = false;
        insert pbe;
        System.assertEquals( pbe.UseStandardPrice,false);
        
       List<Product_Order_Price_Book__c> SigmaOrderLines = new  List<Product_Order_Price_Book__c>(); 
       Sigma_Order__c so=new Sigma_Order__c(AccountId__c=acc33.id,Customer_Type__c='Credit Customer',Orders_Status__c='Order Confirmed');
       insert so;
       System.assertEquals( so.AccountId__c,acc33.id);
       
        
        
        Product_Order_Price_Book__c sol=new Product_Order_Price_Book__c (Sigma_Order__c=so.id,Product__c=Pro1.id,Net_Quantity__c=2,Quantity__c=2,Total_Amount__c=100,Total_Price__c=100,Order_Status__c='Order Confirmed',Back_Order__c=false,IsInventoryUpdated__c=false);
        insert sol;
        System.assertEquals( sol.Sigma_Order__c,so.id);
        
        Product_Order_Price_Book__c sol1=new Product_Order_Price_Book__c (Sigma_Order__c=so.id,Product__c=Pro2.id,Net_Quantity__c=2,Quantity__c=2,Total_Amount__c=100,Total_Price__c=100,Order_Status__c='Order Confirmed',Back_Order__c=false,IsInventoryUpdated__c=false);
        insert sol1;
        
        SigmaOrderLines.add(sol1);
        System.assertEquals( sol1.Net_Quantity__c,2);
        
      
        List<SigmaorderCtrl.ILPLISaveWrap> ilplidata2=new List<SigmaorderCtrl.ILPLISaveWrap>();
         SigmaorderCtrl.ILPLISaveWrap ilplidata3=new SigmaorderCtrl.ILPLISaveWrap();
         ilplidata3.Id = ilpli4.id;
         ilplidata3.enteredQuant = 2;
         System.assertEquals( ilplidata3.enteredQuant,2);
         ilpliData2.add(ilplidata3);
                 
         
      
        List<SigmaorderCtrl.SigmaOrderWrap> SigmaOrderWrapdata=new List<SigmaorderCtrl.SigmaOrderWrap>();
        SigmaorderCtrl.SigmaOrderWrap SigmaOrderWrap1=new SigmaorderCtrl.SigmaOrderWrap();
        SigmaOrderWrap1.hasBackOrder=false;
        SigmaOrderWrap1.isDisabled = false;
        SigmaOrderWrap1.isDisplay  = false;
        SigmaOrderWrap1.orderLines=sol1;
        SigmaOrderWrap1.ilpliData = ilplidata2;
        SigmaOrderWrap1.stockExist='true';
        System.assertEquals( SigmaOrderWrap1.isDisplay,false);
        SigmaOrderWrapdata.add(SigmaOrderWrap1); 
  
        
         List<SigmaorderCtrl.responseWrap> responseWrapdata=new List<SigmaorderCtrl.responseWrap>();
         SigmaorderCtrl.responseWrap response=new SigmaorderCtrl.responseWrap();
         response.message = 'hii';
         response.data = 'data';
         response.soName = 'SO123';
         response.proformaCheck = true;
         System.assertEquals( response.proformaCheck,true);
         responseWrapdata.add(response);
         
        
        Dimension_Tag__c  DT = new Dimension_Tag__c();
        DT.Ordered_Amount__c =0;
        DT.Account__c=acc33.id;
        System.assertEquals( DT.Account__c,acc33.id);
        insert DT;
        System.assertEquals(DT.Ordered_Amount__c,0);
        
       
        SigmaorderCtrl.SigmaOrderUpdateWrap sow=SigmaorderCtrl.getSigmaOrderData(so.id);
        
        String soJSON = JSON.serialize(sow.sigmaOrder);
        String solJSON = JSON.serialize(sow.solWrap);
        
        String solJSON11 = JSON.serialize(SigmaOrderWrapdata);
        
        system.debug('serializedata'+solJSON11);
        boolean autostock =true;
        boolean isupdate = false;

        Test.StartTest();
     
        
        SigmaorderCtrl.saveSigmaOrder(soJSON,solJSON11,autostock,isupdate);
        
        SigmaorderCtrl.automateStockReservation(soJSON,solJSON);
      
        SigmaorderCtrl.deleteIndividualOrderLines(SigmaOrderLines);
       
        

        
         Test.stopTest(); 
      }
      
   
      
      @IsTest(seeAllData=false)
     public static void testmethod5()
     {
         //String ParentId;
        
        Account acc2 = new Account();
        acc2.Name = 'Test-1';
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        acc2.Type = 'Packaged Location';
        acc2.Email__c='dc@gmail.com';
        acc2.Customer_Type__c='Cash Customer';
        insert acc2;
        System.assertEquals(acc2.Type,'Packaged Location');
        
       
        
        Default_Parameters__c param = new Default_Parameters__c(); 
        param.Name='defulat';
        param.Parent_Id__c = acc2.id;
        param.Inventory_Status__c='Allocated';
        insert param;
        System.assertEquals( param.Inventory_Status__c,'Allocated');
   
        Community_Configuration__c CC =  new Community_Configuration__c();
        CC.Name = 'Community Configurations';
        CC.Retailer_Community_URL__c = 'https://ssigma-mvp-dev2-dev-ed-developer-edition.ap17.force.com/Retailer';
        CC.Products_Per_Page__c = 24;
        CC.Retailer_Profile_Name__c = 'Retailer Community Plus User';
        CC.Vendor_Community_URL__c = 'https://ssigma-mvp-dev2-dev-ed-developer-edition.ap17.force.com/shoppingcart';
        CC.Vendor_Profile_Name__c = 'Vendor Community Plus User'; 
        Insert CC;
        
        Product2 Pro2 = new Product2(Name='Product - 2',Attribute_Type__c='BULK',IsActive=true);
        Pro2.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('BOM').getRecordTypeId();
        Insert Pro2;
        System.assertEquals(Pro2.Name,'Product - 2');
        
        Inventory__c PI1 = new Inventory__c();
        PI1.ProductCode__c =Pro2.Id;
        PI1.Delivered_Qty__c=0;
        PI1.Total_Available_Qty__C=0;
        PI1.Total_Qty__c=0;
        PI1.Available_Qty__c=20;
        PI1.Account__c=param.Parent_Id__c;
        PI1.Quantity_To_Become_Out_Of_Stock__c=0;
        insert PI1;
        System.assertEquals(PI1.Total_Qty__c,0);
        
      
        Product_Serial_Number__c PSN = new Product_Serial_Number__c();
        PSN.Status__c='Allocate'; 
        PSN.Serial_Number__c='HMN';
        insert PSN;
        System.assertEquals(PSN.Status__c,'Allocate');
        
        
        Lot__c lot = new Lot__c();
        lot.Product__c=Pro2.Id;
        lot.Lot_Name__c='lot1';
        lot.Quantity__c = 2;
        lot.Created_Date__c =system.today();
        lot.Expiry_Date__c = system.today()+4;
        insert lot;
        System.assertEquals(lot.Quantity__c , 2);
        
        Account acc22 = new Account();
        acc22.Name = 'Bangalore';
        acc22.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();
        acc22.Type = 'Location';
       insert acc22;
       System.assertEquals(acc22.Type,'Location');
        
        Inventory_Location__c IL = new Inventory_Location__c();
        IL.Location__c=acc22.id;
        IL.Inventory__c =PI1.id;
        insert IL;   
        System.assertEquals(IL.Location__c,acc22.id);       
        
        Inventory_Location_Product__c ilp1 = new Inventory_Location_Product__c();
        ilp1.Products__c = Pro2.Id;
        ilp1.Inventory__c = PI1.id;
        ilp1.Received_Quantity__c =10;
        ilp1.Inventory_Location__c=IL.id;
        insert ilp1;
        System.assertEquals(ilp1.Received_Quantity__c ,10);
        

        List<Inventory_Location_Product_Line_Item__c> ilpliNewList = new List<Inventory_Location_Product_Line_Item__c>();
        Inventory_Location_Product_Line_Item__c ilpli4 = new Inventory_Location_Product_Line_Item__c();
        ilpli4.Inventory_Location_Product__c = ilp1.Id;
        ilpli4.Lot__c= lot.id;
        ilpli4.Product_Serial_Number__c=PSN.id;
        ilpli4.Product_Received_date__c=system.today();
        ilpli4.Received_Quantity__c=10;
        ilpli4.Reserved_Quantity__c = 2;
        ilpli4.Product_Expiry_Date__c =system.today()+1;
        ilpliNewList.add(ilpli4);
        insert ilpliNewList;
        System.assertEquals(ilpli4.Reserved_Quantity__c,2);
        
        
       List<Product_Order_Price_Book__c> SigmaOrderLines = new  List<Product_Order_Price_Book__c>(); 
       
       Sigma_Order__c so=new Sigma_Order__c(AccountId__c=acc2.id,Customer_Type__c='Cash Customer',Orders_Status__c='Order Confirmed',Total_Payable_Amount__c = 10);
        insert so;
        System.assertEquals(so.Customer_Type__c,'Cash Customer');
    
        
        Product_Order_Price_Book__c sol1=new Product_Order_Price_Book__c (Sigma_Order__c=so.id,Product__c=Pro2.id,Net_Quantity__c=5,Quantity__c=5,Total_Amount__c=100,Total_Price__c=100,Order_Status__c='Order Confirmed',Back_Order__c=false,IsInventoryUpdated__c=false);
        insert sol1;
         System.assertEquals(sol1.Sigma_Order__c,so.id);
       SigmaOrderLines.add(sol1);
      
      
        List<SigmaorderCtrl.ILPLISaveWrap> ilplidata2=new List<SigmaorderCtrl.ILPLISaveWrap>();
         SigmaorderCtrl.ILPLISaveWrap ilplidata3=new SigmaorderCtrl.ILPLISaveWrap();
         ilplidata3.Id = ilpli4.id;
         ilplidata3.enteredQuant = 2;
         System.assertEquals(ilplidata3.Id , ilpli4.id);
         ilpliData2.add(ilplidata3);      
      
        List<SigmaorderCtrl.SigmaOrderWrap> SigmaOrderWrapdata=new List<SigmaorderCtrl.SigmaOrderWrap>();
        SigmaorderCtrl.SigmaOrderWrap SigmaOrderWrap1=new SigmaorderCtrl.SigmaOrderWrap();
        SigmaOrderWrap1.hasBackOrder=false;
        SigmaOrderWrap1.isDisabled = false;
        SigmaOrderWrap1.isDisplay  = false;
        SigmaOrderWrap1.orderLines=sol1;
        SigmaOrderWrap1.ilpliData = ilplidata2;
        SigmaOrderWrap1.stockExist='true';
        System.assertEquals( SigmaOrderWrap1.stockExist,'true');
        SigmaOrderWrapdata.add(SigmaOrderWrap1); 
       
        
         List<SigmaorderCtrl.responseWrap> responseWrapdata=new List<SigmaorderCtrl.responseWrap>();
         SigmaorderCtrl.responseWrap response=new SigmaorderCtrl.responseWrap();
         response.message = 'hii';
         response.data = 'data';
         response.soName = 'SO123';
         response.proformaCheck = true;
         System.assertEquals(response.soName,'SO123');
         responseWrapdata.add(response);
        
        SigmaorderCtrl.SigmaOrderUpdateWrap sow=SigmaorderCtrl.getSigmaOrderData(so.id);
       
        String lowStockProdName = '';
        String soJSON = JSON.serialize(sow.sigmaOrder);
        String solJSON = JSON.serialize(sow.solWrap);
        String solJSON11 = JSON.serialize(SigmaOrderWrapdata);
        boolean autostock =true;
        boolean isupdate = false;
        
        Test.StartTest();
        SigmaorderCtrl.saveSigmaOrder(soJSON,solJSON11,autostock,isupdate);
        SigmaorderCtrl.automateStockReservation(soJSON,solJSON11);
        SigmaorderCtrl.deleteIndividualOrderLines(SigmaOrderLines);
        Test.stopTest(); 
      }
}