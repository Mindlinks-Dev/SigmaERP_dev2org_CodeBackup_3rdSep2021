@isTest
public class ViewctrlTest 
{
    @IsTest(seeAllData=false)
    public static void Test()
    {
        ID RID3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();
        Account  acc2=new Account();
        acc2.Name='Belagavi';
        acc2.Type='Location';
        acc2.RecordTypeId = RID3;
        acc2.Active__c = 'Yes';
        insert acc2;
        System.assertEquals(acc2.Name,'Belagavi');
        
        ID RID1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        ID OrderRecordType = Schema.SObjectType.Sigma_Order__c.getRecordTypeInfosByDeveloperName().get('Product_Order').getRecordTypeId();
        
        List<Account>  acc=new List<Account>();
        //inserting Accounts
        SET<ID> CustomerID = new SET<ID>();
        Account acc1 = new Account();
        acc1.Name='Kruti Credit Customer';
        acc1.Type='Customer';
        acc1.RecordTypeId = RID1;
        acc1.Active__c = 'Yes';
        acc1.Base_Credit_Limit__c = 10000000.00;
        acc1.Customer_Type__c = 'Credit Customer';
        acc1.Email__c = 'Test@test.com';
        acc.add(acc1);
        insert acc;
        CustomerID.add(acc1.id);
        System.assertEquals(acc1.Name,'Kruti Credit Customer');
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=acc1.id;
        insert attach;
        System.assertEquals(attach.Name,'Unit Test Attachment');
        
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:acc1.id];
        System.assertEquals(1, attachments.size()); 
        
        ID RID2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        Account testAccount = new Account();
        testAccount.Type = 'Vendor';
        testAccount.Name = 'TestAccountName';
        testAccount.RecordTypeId = RID2;
        testAccount.Active__c='Yes';
        testAccount.Email__c = 'Test@test.com';
        insert testAccount;
        System.assertequals('Vendor',testAccount.Type);
        
        System.assertEquals(testAccount.name, 'TestAccountName');
        
        
        //inserting Contact
        Contact conn=new Contact();
        conn.AccountId=acc1.id;
        conn.Title='ms';
        conn.FirstName='Vidya';
        conn.LastName='min';
        insert conn;
        system.assertEquals(conn.FirstName,'Vidya');
        
        Default_Parameters__c DP = new Default_Parameters__c();
        DP.Name='defualt';
        DP.Inventory_Status__c='Reserve';
        DP.Auto_Reserve_Stock__c=true;
        insert DP;
        system.assertEquals(DP.Auto_Reserve_Stock__c,true);
        
        //inserting Products
        List<Product2> ProdList = new List<Product2>();
        Product2 prod=new Product2();
        prod.Name='Medical Kit';
        prod.Stock_Item__c = true;
        prod.Product_Type__c = 'Category 1';
        prod.Attribute_Type__c='BULK';
        prod.Type__c='BOM';
        prod.Reorder_Quantity__c=50;
        prod.Threshold_Quantity__c=50;
        prod.Product_Price__c = 100.00;
        prod.Solution_Component__c=true;
        ProdList.add(prod);
        system.assertEquals(prod.Product_Price__c ,100.00);
        
        Product2 prod2=new Product2();
        prod2.Name='Vivo';
        prod2.Stock_Item__c = true;
        prod2.Attribute_Type__c='BULK';
        prod2.Type__c='BOM';
        prod2.Reorder_Quantity__c=50;
        prod2.Threshold_Quantity__c=50;
        prod2.Product_Type__c = 'Category 1';
        prod2.Product_Price__c = 100.00;
        prod2.Solution_Component__c=true;
        ProdList.add(prod2);
        system.assertEquals(prod2.Product_Price__c ,100.00);
        
        
        Product2 prod3=new Product2();
        prod3.Name='Redme';
        prod3.Stock_Item__c = true;
        prod3.Product_Type__c = 'Category 1';
        prod3.Attribute_Type__c='BULK';
        prod3.Type__c='BOM';
        prod3.Reorder_Quantity__c=50;
        prod3.Threshold_Quantity__c=50;
        prod3.Product_Price__c = 100.00;
        prod3.Solution_Component__c=true;
        ProdList.add(prod3);
        system.assertEquals(prod3.Product_Price__c ,100.00);
        
        Product2 prod4=new Product2();
        prod4.Name='Panasonic';
        prod4.Stock_Item__c = true;
        prod4.Product_Type__c = 'Category 1';
        prod4.Attribute_Type__c='BULK';
        prod4.Type__c='BOM';
        prod4.Reorder_Quantity__c=50;
        prod4.Threshold_Quantity__c=50;
        prod4.Product_Price__c = 100.00;
        prod4.Solution_Component__c=true;
        ProdList.add(prod4);
        system.assertEquals(prod4.Product_Price__c ,100.00);        
        insert ProdList;
        
        
        Vendor_Product__c vp  = new Vendor_Product__c();
        vp.Product_Name__c = prod.id;
        vp.Account_Name__c = testAccount.Id;
        vp.Buying_Price__c = 200;
        vp.Is_Preferred__c=true;
        insert vp;
        system.assertEquals(prod.id,vp.Product_Name__c);
        
        //inserting Product Inventory
        Inventory__c ProdInv = new Inventory__c();
        ProdInv.ProductCode__c = ProdList[0].Id;
        ProdInv.Total_Qty__c = 100;
        ProdInv.Available_Qty__c = 90;
        insert ProdInv;
        system.assertEquals(ProdInv.Available_Qty__c,90 );
        
        Inventory__c ProdInv1 = new Inventory__c();
        ProdInv1.ProductCode__c = ProdList[1].Id;
        ProdInv1.Total_Qty__c = 100;
        ProdInv1.Available_Qty__c = 20;
        insert ProdInv1;
        system.assertEquals(ProdInv1.Available_Qty__c,20);
        
        List<Dimension_Tag__c> DimTag = new List<Dimension_Tag__c>();
        for(Dimension_Tag__c DImtags:[select Id,Account__c,Base_Credit_Limit__c,Due_Amount__c,Ordered_Amount__c,Paid_Amount__c,Remaining_Credit_Limit__c from Dimension_Tag__c where Account__c =: acc1.Id])
        {
            DImtags.Base_Credit_Limit__c = 100000000000000.00;
            DImtags.Ordered_Amount__c = 100;
            DImtags.Paid_Amount__c = 50;
            DimTag.add(DImtags);
        }
        update DimTag;
        
        List<Sigma_Order__c> SigOrderList=new List<Sigma_Order__c>();
        SET<ID> OrderID = new SET<ID>();
        
        //inserting Sales Order
        Sigma_Order__c SigOrder=new Sigma_Order__c();
        SigOrder.AccountId__c = acc1.Id;
        SigOrder.BillingPersonNew__c = conn.Id;
        SigOrder.Orders_Status__c = 'Pending';
        SigOrder.Order_Created_Via__c = 'Community';
        SigOrder.Delivary_Date__c = System.Today();
        SigOrder.Customer_Email__c = acc1.Email__c;
        SigOrder.Shipping_Street__c = acc1.ShippingStreet;
        SigOrder.ShippingState__c = acc1.ShippingState;
        SigOrder.ShippingPostalCode__c = acc1.ShippingPostalCode;
        SigOrder.ShippingCountry__c = acc1.ShippingCountry;
        SigOrder.ShippingCity__c = acc1.ShippingCity;
        SigOrder.RecordTypeId = OrderRecordType;
        SigOrder.TotalAmount__c=100;
        SigOrder.Order_Type__c = 'Online';
        SigOrder.Customer_Type__c = acc1.Customer_Type__c;
        SigOrder.Auto_Allocate__c = true;
        OrderID.add(SigOrder.id);
        SigOrderList.add(SigOrder);
        system.assertEquals(SigOrder.Order_Type__c ,'Online');
        
        
        Sigma_Order__c SigOrder1=new Sigma_Order__c();
        SigOrder1.AccountId__c = acc1.Id;
        SigOrder1.BillingPersonNew__c = conn.Id;
        SigOrder1.Orders_Status__c = 'Submitted';
        SigOrder1.Order_Created_Via__c = 'Community';
        SigOrder1.Delivary_Date__c = System.Today();
        SigOrder1.Customer_Email__c = acc1.Email__c;
        SigOrder1.Shipping_Street__c = acc1.ShippingStreet;
        SigOrder1.ShippingState__c = acc1.ShippingState;
        SigOrder1.ShippingPostalCode__c = acc1.ShippingPostalCode;
        SigOrder1.ShippingCountry__c = acc1.ShippingCountry;
        SigOrder1.ShippingCity__c = acc1.ShippingCity;
        SigOrder1.TotalAmount__c=100;
        SigOrder1.RecordTypeId = OrderRecordType;
        SigOrder1.Order_Type__c = 'Online';
        SigOrder1.Customer_Type__c = acc1.Customer_Type__c;
        SigOrder1.Auto_Allocate__c = true;
        OrderID.add(SigOrder1.id);
        SigOrderList.add(SigOrder1);
        
        insert SigOrderList;
        system.assertEquals(SigOrder1.Order_Type__c ,'Online');
        
        //Order and available quantity
        integer orderingQuantity = 100;
        integer AvlQua = Integer.valueof(ProdInv.Available_Qty__c);
        List<Product_Order_Price_Book__c> OrdlineList = new List<Product_Order_Price_Book__c>();
        
        Map<String,Product_Order_Price_Book__c> Lineit = new Map<String,Product_Order_Price_Book__c>();
        Map<String,List<Product_Order_Price_Book__c>> Lineits = new Map<String,List<Product_Order_Price_Book__c>>();
        
        
        //inserting Sales Order Line item
        SET<ID> OrderLineID = new SET<ID>();
        Product_Order_Price_Book__c SignProd= new Product_Order_Price_Book__c();
        SignProd.Product__c = ProdList[0].Id;
        SignProd.Sigma_Order__c = SigOrderList[0].Id;
        SignProd.Quantity__c = orderingQuantity;
        SignProd.Discounts__c=2;
        SignProd.IsInventoryUpdated__c=true;
        SignProd.Back_Order__c=true;
        SignProd.Order_Status__c='Order Confirmed';
        SignProd.Net_Quantity__c = orderingQuantity;
        SignProd.Remaining_Qty_To_Package__c = orderingQuantity;
        SignProd.Total_Amount__c = ProdList[0].Product_Price__c;
        SignProd.Total_Price__c = orderingQuantity * (ProdList[0].Product_Price__c);
        SignProd.Ordered_Amount__c = orderingQuantity * (ProdList[0].Product_Price__c);
        SignProd.Back_Order__c = false;
        OrderLineID.add(SignProd.id);
        OrdlineList.add(SignProd);
        system.assertEquals(SignProd.Order_Status__c,'Order Confirmed');
        
        Product_Order_Price_Book__c SignProd1= new Product_Order_Price_Book__c();
        SignProd1.Product__c = ProdList[1].Id;
        SignProd1.Sigma_Order__c = SigOrderList[0].Id;
        SignProd1.Quantity__c = orderingQuantity;
        SignProd1.Discounts__c=2;
        SignProd1.IsInventoryUpdated__c=true;
        SignProd1.Back_Order__c=true;
        SignProd1.Order_Status__c='Order Confirmed';
        SignProd1.Net_Quantity__c = orderingQuantity;
        SignProd1.Remaining_Qty_To_Package__c = orderingQuantity;
        SignProd1.Total_Amount__c = ProdList[1].Product_Price__c;
        SignProd1.Total_Price__c = orderingQuantity * (ProdList[1].Product_Price__c);
        SignProd1.Ordered_Amount__c = orderingQuantity * (ProdList[1].Product_Price__c);
        SignProd1.Back_Order__c = true;
        OrderLineID.add(SignProd1.id);
        OrdlineList.add(SignProd1);
        system.assertEquals(SignProd1.Order_Status__c,'Order Confirmed');
        
        Product_Order_Price_Book__c SignProd2= new Product_Order_Price_Book__c();
        SignProd2.Product__c = ProdList[1].Id;
        SignProd2.Sigma_Order__c = SigOrderList[0].Id;
        SignProd2.Quantity__c = 20;
        SignProd2.Discounts__c=2;
        SignProd2.IsInventoryUpdated__c=true;
        SignProd2.Back_Order__c=true;
        SignProd2.Order_Status__c='Order Confirmed';
        SignProd2.Net_Quantity__c = 20;
        SignProd2.Remaining_Qty_To_Package__c = orderingQuantity;
        SignProd2.Total_Amount__c = ProdList[1].Product_Price__c;
        SignProd2.Total_Price__c = orderingQuantity * (ProdList[1].Product_Price__c);
        SignProd2.Ordered_Amount__c = orderingQuantity * (ProdList[1].Product_Price__c);
        SignProd2.Back_Order__c = true;
        OrderLineID.add(SignProd2.id);
        OrdlineList.add(SignProd2);
        
        system.assertEquals(SignProd2.Order_Status__c,'Order Confirmed');
        
        Product_Order_Price_Book__c SignProd3= new Product_Order_Price_Book__c();
        SignProd3.Product__c = ProdList[2].Id;
        SignProd3.Sigma_Order__c = SigOrderList[0].Id;
        SignProd3.Quantity__c = 90;
        SignProd3.Discounts__c=2;
        SignProd3.IsInventoryUpdated__c=true;
        SignProd3.Back_Order__c=true;
        SignProd3.Order_Status__c='Order Confirmed';
        SignProd3.Net_Quantity__c = 90;
        SignProd3.Remaining_Qty_To_Package__c = 90;
        SignProd3.Total_Amount__c = ProdList[2].Product_Price__c;
        SignProd3.Total_Price__c = 90 * (ProdList[2].Product_Price__c);
        SignProd3.Ordered_Amount__c = 90 * (ProdList[2].Product_Price__c);
        SignProd3.Back_Order__c = false;
        OrderLineID.add(SignProd3.id);
        OrdlineList.add(SignProd3);
        system.assertEquals(SignProd3.Order_Status__c,'Order Confirmed');
        
        Product_Order_Price_Book__c SignProd4= new Product_Order_Price_Book__c();
        SignProd4.Product__c = ProdList[2].Id;
        SignProd4.Sigma_Order__c = SigOrderList[0].Id;
        SignProd4.Quantity__c = 10;
        SignProd4.Discounts__c=2;
        SignProd4.IsInventoryUpdated__c=true;
        SignProd4.Back_Order__c=true;
        SignProd4.Order_Status__c='Order Confirmed';
        SignProd4.Net_Quantity__c = 10;
        SignProd4.Remaining_Qty_To_Package__c = 10;
        SignProd4.Total_Amount__c = ProdList[2].Product_Price__c;
        SignProd4.Total_Price__c = 10 * (ProdList[2].Product_Price__c);
        SignProd4.Ordered_Amount__c = 10 * (ProdList[2].Product_Price__c);
        SignProd4.Back_Order__c = true;
        OrderLineID.add(SignProd4.id);
        OrdlineList.add(SignProd4);
        system.assertEquals(SignProd4.Back_Order__c,true);
        
        
        Product_Order_Price_Book__c SignProd5= new Product_Order_Price_Book__c();
        SignProd5.Product__c = ProdList[3].Id;
        SignProd5.Sigma_Order__c = SigOrderList[1].Id;
        SignProd5.Quantity__c = 90;
        SignProd5.Discounts__c=2;
        SignProd5.IsInventoryUpdated__c=true;
        SignProd5.Back_Order__c=true;
        SignProd5.Order_Status__c='Order Confirmed';
        SignProd5.Net_Quantity__c = 90;
        SignProd5.Remaining_Qty_To_Package__c = 90;
        SignProd5.Total_Amount__c = ProdList[3].Product_Price__c;
        SignProd5.Total_Price__c = 90 * (ProdList[3].Product_Price__c);
        SignProd5.Ordered_Amount__c = 90 * (ProdList[3].Product_Price__c);
        SignProd5.Back_Order__c = false;
        OrderLineID.add(SignProd5.id);
        OrdlineList.add(SignProd5);
        system.assertEquals(SignProd5.Net_Quantity__c ,90);
        
        
        insert OrdlineList;
        
        List<string> soString = new List<string>();
        
        Product_Price__c  prodprice = new Product_Price__c();
        prodprice.Product_Id__c=prod.id;
        prodprice.Discout__c=2;
        prodprice.Customer__c=acc1.id;
        prodprice.Status__c ='Active';
        prodprice.Start_Date__c = system.today();
        prodprice.End_Date__c = system.today()+30;
        prodprice.Cost__c=1000;
        prodprice.Location__c=acc2.id;
        insert prodprice;
        system.assertEquals(prodprice.Status__c ,'Active');
        List<viewCartctrl.SOLIWrapper> UpdateCart = new List<viewCartctrl.SOLIWrapper>();
        
        for(Sigma_Order__c ord : SigOrderList)
        {
            
            for(Product_Order_Price_Book__c orfli: [select id,Ordered_Amount__c,Total_Price__c,Remaining_Qty_To_Package__c,Quantity__c,Sigma_Order__c,Product__c,Total_Amount__c,Net_Quantity__c from Product_Order_Price_Book__c where Sigma_Order__c IN : SigOrderList])
            {
                List<Product_Order_Price_Book__c> OrdlineLists = new List<Product_Order_Price_Book__c>();
                OrdlineLists.add(orfli);
                viewCartctrl.SOLIWrapper UpdateCarts = new viewCartctrl.SOLIWrapper();
                UpdateCarts.SOid = orfli.Sigma_Order__c;
                UpdateCarts.ProductId = orfli.Product__c;
                UpdateCarts.OrderedQuantity = Integer.valueof(orfli.Net_Quantity__c);
                UpdateCarts.LineitemAvlquant.put(orfli.Id,orfli);
                if(UpdateCarts.Lineitemse.containsKey(orfli.Product__c))
                    UpdateCarts.Lineitemse.get(orfli.Product__c).add(orfli);
                else
                    UpdateCarts.Lineitemse.put(orfli.Product__c,OrdlineLists);
                UpdateCart.add(UpdateCarts);
                // Lineit.put(orfli.Id,orfli);
                // Lineit.put(orfli.Product__c,OrdlineList);
                
                Lineits.put('str',OrdlineList);
            }
            String sostr = ord.Currency__c;
            soString.add(sostr);
            
        }
        
        System.debug(' test>>'+UpdateCart[0].Lineitemse);
        //adding value to wrapper class
        
        
        String Serlize = JSON.serialize(UpdateCart);
        
        DisplayProducts.completeProductWrapper catordorwrap1=new DisplayProducts.completeProductWrapper();
        catordorwrap1.pageSize=2;
        catordorwrap1.pageNumber=3;
        catordorwrap1.totalRecords=10;
        catordorwrap1.recordStart=1;
        catordorwrap1.recordEnd=9;
        catordorwrap1.tabOverride='tabOverride';
        system.assertEquals(catordorwrap1.recordEnd,9);
        
        List<DisplayProducts.ProductWrapper> listofcatprodwrap= new List<DisplayProducts.ProductWrapper>(); 
        DisplayProducts.ProductWrapper catprodwrap1=new DisplayProducts.ProductWrapper();
        catprodwrap1.Id=prod.id;
        catprodwrap1.Name=Prod.Name;
        catprodwrap1.producttype= Prod.Product_Type__c;
        catprodwrap1.AvailableQuantity=90;
        catprodwrap1.productfamily=Prod.Bar_Code_Gene__c;
        catprodwrap1.Attachementsid=attach.id;
        catprodwrap1.ProductPrice=Prod.Product_Price__c;
        listofcatprodwrap.add(catprodwrap1);
        system.assertEquals(catprodwrap1.AvailableQuantity,90);
        
        List<String> prodFamilyList = new List<String>();
        prodFamilyList.add('Bom type');
        prodFamilyList.add('Individual type');
        
        catordorwrap1.Ocomp='Ocomp';
        List<String> PcurrList=new List<String>();
        PcurrList.add('Euro');
        PcurrList.add('Aus');
        
        String ProductId = prod.id;
        String ProductPrice =prodprice.id;
        String Avlquantity ='90';
        String EnteredQuantity='5';
        String Avlquantity1 ='20';
        String EnteredQuantity1='50';
        
        
        String ProdType = Prod.Product_Type__c;
        String PageNumber ='1';
        String SearckKeyWord = prod.Name;
        Decimal PageNumbers =0.00;
        
        Test.startTest();
        ViewCart.deleteProductFromCart(SignProd.Id,SigOrder.Id,prod.Id);
        ViewCart.getAllCartDetails();
        ViewCart.updateCartValue(Serlize);
        ViewCart.ClearCartDetails(acc1.id);
        
        DisplayProducts.getproductlist(prod.Id);
        DisplayProducts.saveSO(ProductId,ProductPrice,Avlquantity,EnteredQuantity);
        DisplayProducts.saveSO(ProductId,ProductPrice,Avlquantity1,EnteredQuantity1);
        Test.stopTest();
    }
    
    @IsTest(seeAllData=false)
    public static void Test1()
    {   
        ID RID3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();
        Account  acc2=new Account();
        acc2.Name='Belagavi';
        acc2.Type='Location';
        acc2.RecordTypeId = RID3;
        acc2.Active__c = 'Yes';
        insert acc2;
        System.assertEquals(acc2.Name,'Belagavi');
        
        ID RID1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        ID OrderRecordType = Schema.SObjectType.Sigma_Order__c.getRecordTypeInfosByDeveloperName().get('Product_Order').getRecordTypeId();
        
        List<Account>  acc=new List<Account>();
        //inserting Accounts
        SET<ID> CustomerID = new SET<ID>();
        Account acc1 = new Account();
        acc1.Name='Kruti Credit Customer';
        acc1.Type='Customer';
        acc1.RecordTypeId = RID1;
        acc1.Base_Credit_Limit__c = 10000000.00;
        acc1.Customer_Type__c = 'Credit Customer';
        acc1.Active__c = 'Yes';
        acc1.Email__c = 'Test@test.com';
        acc.add(acc1);
        insert acc;
        CustomerID.add(acc1.id);
        System.assertEquals(acc1.Name,'Kruti Credit Customer');
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=acc1.id;
        insert attach;
        System.assertEquals(attach.Name,'Unit Test Attachment');
        
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:acc1.id];
        System.assertEquals(1, attachments.size());
        
        ID RID2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        Account testAccount = new Account();
        testAccount.Type = 'Vendor';
        testAccount.Name = 'TestAccountName';
        testAccount.RecordTypeId = RID2;
        testAccount.Email__c = 'Test@test.com';
        testAccount.Active__c='Yes';
        insert testAccount;
        System.assertequals('Vendor',testAccount.Type);
        
        System.assertEquals(testAccount.name, 'TestAccountName');
        
        //inserting Contact
        Contact conn=new Contact();
        conn.AccountId=acc1.id;
        conn.Title='ms';
        conn.FirstName='Vidya';
        conn.LastName='min';
        insert conn;
        system.assertEquals(conn.FirstName,'Vidya');
        
        Default_Parameters__c DP = new Default_Parameters__c();
        DP.Name='defualt';
        DP.Inventory_Status__c='Reserve';
        DP.Auto_Reserve_Stock__c=true;
        insert DP;
        System.assertEquals(DP.Name,'defualt');
        
        //inserting Products
        List<Product2> ProdList = new List<Product2>();
        Product2 prod=new Product2();
        prod.Name='Medical Kit';
        prod.Stock_Item__c = true;
        prod.Product_Type__c = 'Category 1';
        prod.Attribute_Type__c='BULK';
        prod.Type__c='BOM';
        prod.Reorder_Quantity__c=50;
        prod.Threshold_Quantity__c=50;
        prod.Product_Price__c = 100.00;
        prod.Solution_Component__c=true;
        ProdList.add(prod);
        System.assertEquals(prod.Type__c,'BOM');
        
        Product2 prod2=new Product2();
        prod2.Name='Vivo';
        prod2.Stock_Item__c = true;
        prod2.Attribute_Type__c='BULK';
        prod2.Type__c='BOM';
        prod2.Reorder_Quantity__c=50;
        prod2.Threshold_Quantity__c=50;
        prod2.Product_Type__c = 'Category 1';
        prod2.Product_Price__c = 100.00;
        prod2.Solution_Component__c=true;
        ProdList.add(prod2);
        System.assertEquals(prod2.Product_Type__c,'Category 1');
        
        Product2 prod3=new Product2();
        prod3.Name='Redme';
        prod3.Stock_Item__c = true;
        prod3.Product_Type__c = 'Category 1';
        prod3.Attribute_Type__c='BULK';
        prod3.Type__c='BOM';
        prod3.Reorder_Quantity__c=50;
        prod3.Threshold_Quantity__c=50;
        prod3.Product_Price__c = 100.00;
        prod3.Solution_Component__c=true;
        ProdList.add(prod3);
        System.assertEquals(prod3.Reorder_Quantity__c,50);
        
        Product2 prod4=new Product2();
        prod4.Name='Panasonic';
        prod4.Stock_Item__c = true;
        prod4.Product_Type__c = 'Category 1';
        prod4.Attribute_Type__c='BULK';
        prod4.Type__c='BOM';
        prod4.Reorder_Quantity__c=50;
        prod4.Threshold_Quantity__c=50;
        prod4.Product_Price__c = 100.00;
        prod4.Solution_Component__c=true;
        ProdList.add(prod4);
        System.assertEquals(prod4.Reorder_Quantity__c,50);
        
        insert ProdList;
        
        Vendor_Product__c vp  = new Vendor_Product__c();
        vp.Product_Name__c = prod.id;
        vp.Account_Name__c = testAccount.Id;
        vp.Buying_Price__c = 200;
        vp.Is_Preferred__c=true;
        insert vp;
        system.assertEquals(prod.id,vp.Product_Name__c);
        
        Inventory__c ProdInv = new Inventory__c();
        ProdInv.ProductCode__c = ProdList[0].Id;
        ProdInv.Total_Qty__c = 100;
        ProdInv.Available_Qty__c = 20;
        insert ProdInv;
        system.assertEquals(ProdInv.Available_Qty__c,20); 
        
        Inventory__c ProdInv1 = new Inventory__c();
        ProdInv1.ProductCode__c = ProdList[1].Id;
        ProdInv1.Total_Qty__c = 100;
        ProdInv1.Available_Qty__c = 90;
        insert ProdInv1;
        system.assertEquals(ProdInv1.Available_Qty__c,90); 
        
        List<Dimension_Tag__c> DimTag = new List<Dimension_Tag__c>();
        for(Dimension_Tag__c DImtags:[select Id,Account__c,Base_Credit_Limit__c,Due_Amount__c,Ordered_Amount__c,Paid_Amount__c,Remaining_Credit_Limit__c from Dimension_Tag__c where Account__c =: acc1.Id])
        {
            DImtags.Base_Credit_Limit__c = 100000000000000.00;
            DImtags.Ordered_Amount__c = 100;
            DImtags.Paid_Amount__c = 50;
            DimTag.add(DImtags);
        }
        update DimTag;
        
        List<Sigma_Order__c> SigOrderList=new List<Sigma_Order__c>();
        SET<ID> OrderID = new SET<ID>();
        
        //inserting Sales Order
        Sigma_Order__c SigOrder=new Sigma_Order__c();
        SigOrder.AccountId__c = acc1.Id;
        SigOrder.BillingPersonNew__c = conn.Id;
        SigOrder.Orders_Status__c = 'Pending';
        SigOrder.Order_Created_Via__c = 'Community';
        SigOrder.Delivary_Date__c = System.Today();
        SigOrder.Customer_Email__c = acc1.Email__c;
        SigOrder.Shipping_Street__c = acc1.ShippingStreet;
        SigOrder.ShippingState__c = acc1.ShippingState;
        SigOrder.ShippingPostalCode__c = acc1.ShippingPostalCode;
        SigOrder.ShippingCountry__c = acc1.ShippingCountry;
        SigOrder.ShippingCity__c = acc1.ShippingCity;
        SigOrder.RecordTypeId = OrderRecordType;
        SigOrder.TotalAmount__c=100;
        SigOrder.Order_Type__c = 'Online';
        SigOrder.Customer_Type__c = acc1.Customer_Type__c;
        SigOrder.Auto_Allocate__c = true;
        OrderID.add(SigOrder.id);
        SigOrderList.add(SigOrder);
        system.assertEquals(SigOrder.TotalAmount__c,100);
        
        
        Sigma_Order__c SigOrder1=new Sigma_Order__c();
        SigOrder1.AccountId__c = acc1.Id;
        SigOrder1.BillingPersonNew__c = conn.Id;
        SigOrder1.Orders_Status__c = 'Submitted';
        SigOrder1.Order_Created_Via__c = 'Community';
        SigOrder1.Delivary_Date__c = System.Today();
        SigOrder1.Customer_Email__c = acc1.Email__c;
        SigOrder1.Shipping_Street__c = acc1.ShippingStreet;
        SigOrder1.ShippingState__c = acc1.ShippingState;
        SigOrder1.ShippingPostalCode__c = acc1.ShippingPostalCode;
        SigOrder1.ShippingCountry__c = acc1.ShippingCountry;
        SigOrder1.ShippingCity__c = acc1.ShippingCity;
        SigOrder1.TotalAmount__c=100;
        SigOrder1.RecordTypeId = OrderRecordType;
        SigOrder1.Order_Type__c = 'Online';
        SigOrder1.Customer_Type__c = acc1.Customer_Type__c;
        SigOrder1.Auto_Allocate__c = true;
        OrderID.add(SigOrder1.id);
        SigOrderList.add(SigOrder1);
        system.assertEquals(SigOrder1.Delivary_Date__c ,System.Today());
        
        insert SigOrderList;
        
        //Order and available quantity
        integer orderingQuantity = 100;
        integer AvlQua = Integer.valueof(ProdInv.Available_Qty__c);
        List<Product_Order_Price_Book__c> OrdlineList = new List<Product_Order_Price_Book__c>();
        
        Map<String,Product_Order_Price_Book__c> Lineit = new Map<String,Product_Order_Price_Book__c>();
        Map<String,List<Product_Order_Price_Book__c>> Lineits = new Map<String,List<Product_Order_Price_Book__c>>();
        
        
        SET<ID> OrderLineID = new SET<ID>();
        Product_Order_Price_Book__c SignProd= new Product_Order_Price_Book__c();
        SignProd.Product__c = ProdList[0].Id;
        SignProd.Sigma_Order__c = SigOrderList[0].Id;
        SignProd.Quantity__c = orderingQuantity;
        SignProd.Discounts__c=2;
        SignProd.IsInventoryUpdated__c=true;
        SignProd.Back_Order__c=true;
        SignProd.Order_Status__c='Order Confirmed';
        SignProd.Net_Quantity__c = orderingQuantity;
        SignProd.Remaining_Qty_To_Package__c = orderingQuantity;
        SignProd.Total_Amount__c = ProdList[0].Product_Price__c;
        SignProd.Total_Price__c = orderingQuantity * (ProdList[0].Product_Price__c);
        SignProd.Ordered_Amount__c = orderingQuantity * (ProdList[0].Product_Price__c);
        SignProd.Back_Order__c = false;
        OrderLineID.add(SignProd.id);
        OrdlineList.add(SignProd);
        system.assertEquals(SignProd.Order_Status__c ,'Order Confirmed');
        
        Product_Order_Price_Book__c SignProd1= new Product_Order_Price_Book__c();
        SignProd1.Product__c = ProdList[1].Id;
        SignProd1.Sigma_Order__c = SigOrderList[0].Id;
        SignProd1.Quantity__c = orderingQuantity;
        SignProd1.Discounts__c=2;
        SignProd1.IsInventoryUpdated__c=true;
        SignProd1.Back_Order__c=true;
        SignProd1.Order_Status__c='Order Confirmed';
        SignProd1.Net_Quantity__c = orderingQuantity;
        SignProd1.Remaining_Qty_To_Package__c = orderingQuantity;
        SignProd1.Total_Amount__c = ProdList[1].Product_Price__c;
        SignProd1.Total_Price__c = orderingQuantity * (ProdList[1].Product_Price__c);
        SignProd1.Ordered_Amount__c = orderingQuantity * (ProdList[1].Product_Price__c);
        SignProd1.Back_Order__c = true;
        OrderLineID.add(SignProd1.id);
        OrdlineList.add(SignProd1);
        system.assertEquals(SignProd1.Back_Order__c ,true);
        
        Product_Order_Price_Book__c SignProd2= new Product_Order_Price_Book__c();
        SignProd2.Product__c = ProdList[1].Id;
        SignProd2.Sigma_Order__c = SigOrderList[0].Id;
        SignProd2.Quantity__c = 10;
        SignProd2.Discounts__c=2;
        SignProd2.IsInventoryUpdated__c=true;
        SignProd2.Back_Order__c=true;
        SignProd2.Order_Status__c='Order Confirmed';
        SignProd2.Net_Quantity__c = 10;
        SignProd2.Remaining_Qty_To_Package__c = orderingQuantity;
        SignProd2.Total_Amount__c = ProdList[1].Product_Price__c;
        SignProd2.Total_Price__c = orderingQuantity * (ProdList[1].Product_Price__c);
        SignProd2.Ordered_Amount__c = orderingQuantity * (ProdList[1].Product_Price__c);
        SignProd2.Back_Order__c = true;
        OrderLineID.add(SignProd2.id);
        OrdlineList.add(SignProd2);
        system.assertEquals(SignProd2.Back_Order__c ,true);
        
        Product_Order_Price_Book__c SignProd3= new Product_Order_Price_Book__c();
        SignProd3.Product__c = ProdList[2].Id;
        SignProd3.Sigma_Order__c = SigOrderList[0].Id;
        SignProd3.Quantity__c = 20;
        SignProd3.Discounts__c=2;
        SignProd3.IsInventoryUpdated__c=true;
        SignProd3.Back_Order__c=true;
        SignProd3.Order_Status__c='Order Confirmed';
        SignProd3.Net_Quantity__c = 20;
        SignProd3.Remaining_Qty_To_Package__c = 20;
        SignProd3.Total_Amount__c = ProdList[2].Product_Price__c;
        SignProd3.Total_Price__c = 20 * (ProdList[2].Product_Price__c);
        SignProd3.Ordered_Amount__c = 20 * (ProdList[2].Product_Price__c);
        SignProd3.Back_Order__c = false;
        OrderLineID.add(SignProd3.id);
        OrdlineList.add(SignProd3);
        system.assertEquals(SignProd3.Net_Quantity__c , 20);
        
        Product_Order_Price_Book__c SignProd4= new Product_Order_Price_Book__c();
        SignProd4.Product__c = ProdList[2].Id;
        SignProd4.Sigma_Order__c = SigOrderList[0].Id;
        SignProd4.Quantity__c = 10;
        SignProd4.Discounts__c=2;
        SignProd4.IsInventoryUpdated__c=true;
        SignProd4.Back_Order__c=true;
        SignProd4.Order_Status__c='Order Confirmed';
        SignProd4.Net_Quantity__c = 10;
        SignProd4.Remaining_Qty_To_Package__c = 10;
        SignProd4.Total_Amount__c = ProdList[2].Product_Price__c;
        SignProd4.Total_Price__c = 10 * (ProdList[2].Product_Price__c);
        SignProd4.Ordered_Amount__c = 10 * (ProdList[2].Product_Price__c);
        SignProd4.Back_Order__c = true;
        OrderLineID.add(SignProd4.id);
        OrdlineList.add(SignProd4);
        system.assertEquals(SignProd4.Back_Order__c ,true);
        
        
        Product_Order_Price_Book__c SignProd5= new Product_Order_Price_Book__c();
        SignProd5.Product__c = ProdList[3].Id;
        SignProd5.Sigma_Order__c = SigOrderList[1].Id;
        SignProd5.Quantity__c = 20;
        SignProd5.Discounts__c=2;
        SignProd5.IsInventoryUpdated__c=true;
        SignProd5.Order_Status__c='Order Confirmed';
        SignProd5.Net_Quantity__c = 20;
        SignProd5.Remaining_Qty_To_Package__c = 20;
        SignProd5.Total_Amount__c = ProdList[3].Product_Price__c;
        SignProd5.Total_Price__c = 20 * (ProdList[3].Product_Price__c);
        SignProd5.Ordered_Amount__c = 20 * (ProdList[3].Product_Price__c);
        SignProd5.Back_Order__c = false;
        OrderLineID.add(SignProd5.id);
        OrdlineList.add(SignProd5);
        system.assertEquals(SignProd5.Back_Order__c ,false);
        
        
        Product_Order_Price_Book__c SignProd6= new Product_Order_Price_Book__c();
        SignProd6.Product__c = ProdList[3].Id;
        SignProd6.Sigma_Order__c = SigOrderList[1].Id;
        SignProd6.Quantity__c = 90;
        SignProd6.Discounts__c=2;
        SignProd6.IsInventoryUpdated__c=true;
        SignProd6.Back_Order__c=true;
        SignProd6.Order_Status__c='Order Confirmed';
        SignProd6.Net_Quantity__c = 90;
        SignProd6.Remaining_Qty_To_Package__c = 90;
        SignProd6.Total_Amount__c = ProdList[3].Product_Price__c;
        SignProd6.Total_Price__c = 90 * (ProdList[3].Product_Price__c);
        SignProd6.Ordered_Amount__c = 90 * (ProdList[3].Product_Price__c);
        SignProd6.Back_Order__c = true;
        OrderLineID.add(SignProd6.id);
        OrdlineList.add(SignProd6);
        system.assertEquals(SignProd6.Back_Order__c ,true);
        
        insert OrdlineList;
        
        List<string> soString = new List<string>();
        
        Product_Price__c  prodprice = new Product_Price__c();
        prodprice.Product_Id__c=prod.id;
        prodprice.Discout__c=2;
        prodprice.Customer__c=acc1.id;
        prodprice.Status__c ='Active';
        prodprice.Start_Date__c = system.today();
        prodprice.End_Date__c = system.today()+30;
        prodprice.Cost__c=1000;
        prodprice.Location__c=acc2.id;
        insert prodprice;
        system.assertEquals(prodprice.Status__c ,'Active');
        
        List<viewCartctrl.SOLIWrapper> UpdateCart = new List<viewCartctrl.SOLIWrapper>();
        
        for(Sigma_Order__c ord : SigOrderList)
        {
            
            for(Product_Order_Price_Book__c orfli: [select id,Ordered_Amount__c,Total_Price__c,Remaining_Qty_To_Package__c,Quantity__c,Sigma_Order__c,Product__c,Total_Amount__c,Net_Quantity__c from Product_Order_Price_Book__c where Sigma_Order__c IN : SigOrderList])
            {
                List<Product_Order_Price_Book__c> OrdlineLists = new List<Product_Order_Price_Book__c>();
                OrdlineLists.add(orfli);
                viewCartctrl.SOLIWrapper UpdateCarts = new viewCartctrl.SOLIWrapper();
                UpdateCarts.SOid = orfli.Sigma_Order__c;
                UpdateCarts.ProductId = orfli.Product__c;
                UpdateCarts.OrderedQuantity = Integer.valueof(orfli.Net_Quantity__c);
                UpdateCarts.LineitemAvlquant.put(orfli.Id,orfli);
                system.assertEquals(UpdateCarts.SOid ,orfli.Sigma_Order__c);
                
                if(UpdateCarts.Lineitemse.containsKey(orfli.Product__c))
                    UpdateCarts.Lineitemse.get(orfli.Product__c).add(orfli);
                else
                    UpdateCarts.Lineitemse.put(orfli.Product__c,OrdlineLists);
                UpdateCart.add(UpdateCarts);
                Lineits.put('str',OrdlineList);
            }
            String sostr = ord.Currency__c;
            soString.add(sostr);
            
        }
        
        System.debug(' test>>'+UpdateCart[0].Lineitemse);
        //adding value to wrapper class
        
        
        String Serlize = JSON.serialize(UpdateCart);
        
        DisplayProducts.completeProductWrapper catordorwrap1=new DisplayProducts.completeProductWrapper();
        catordorwrap1.pageSize=2;
        catordorwrap1.pageNumber=3;
        catordorwrap1.totalRecords=10;
        catordorwrap1.recordStart=1;
        catordorwrap1.recordEnd=9;
        catordorwrap1.tabOverride='tabOverride';
        system.assertEquals(catordorwrap1.pageNumber,3);
        
        List<DisplayProducts.ProductWrapper> listofcatprodwrap= new List<DisplayProducts.ProductWrapper>(); 
        DisplayProducts.ProductWrapper catprodwrap1=new DisplayProducts.ProductWrapper();
        catprodwrap1.Id=prod.id;
        catprodwrap1.Name=Prod.Name;
        catprodwrap1.producttype= Prod.Product_Type__c;
        catprodwrap1.AvailableQuantity=90;
        catprodwrap1.productfamily=Prod.Bar_Code_Gene__c;
        catprodwrap1.Attachementsid=attach.id;
        catprodwrap1.ProductPrice=Prod.Product_Price__c;
        listofcatprodwrap.add(catprodwrap1);
        system.assertEquals(catprodwrap1.Name,Prod.Name);
        
        List<String> prodFamilyList = new List<String>();
        prodFamilyList.add('Bom type');
        prodFamilyList.add('Individual type');
        
        catordorwrap1.Ocomp='Ocomp';
        List<String> PcurrList=new List<String>();
        PcurrList.add('Euro');
        PcurrList.add('Aus');
        
        String ProductId = prod.id;
        String ProductPrice =prodprice.id;
        String Avlquantity1 ='20';
        String EnteredQuantity1='50';
        
        String Avlquantity2 ='90';
        String EnteredQuantity2='5';
        
        String ProdType = Prod.Product_Type__c;
        String PageNumber ='3';
        
        
        Test.startTest();
        DisplayProducts.saveSO(ProductId,ProductPrice,Avlquantity1,EnteredQuantity1);
        DisplayProducts.saveSO(ProductId,ProductPrice,Avlquantity2,EnteredQuantity2);
        Test.stopTest();
    }
    
    @IsTest(seeAllData=false)
    public static void Test2()
    {
        
        ID RID3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();
        Account  acc2=new Account();
        acc2.Name='Belagavi';
        acc2.Type='Location';
        acc2.RecordTypeId = RID3;
        acc2.Active__c = 'Yes';
        insert acc2;
        System.assertEquals(acc2.Name,'Belagavi');
        
        ID RID1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        ID OrderRecordType = Schema.SObjectType.Sigma_Order__c.getRecordTypeInfosByDeveloperName().get('Product_Order').getRecordTypeId();
        
        List<Account>  acc=new List<Account>();
        //inserting Accounts
        SET<ID> CustomerID = new SET<ID>();
        Account acc1 = new Account();
        acc1.Name='Kruti Credit Customer';
        acc1.Type='Customer';
        acc1.RecordTypeId = RID1;
        acc1.Base_Credit_Limit__c = 10000000.00;
        acc1.Customer_Type__c = 'Credit Customer';
        acc1.Active__c = 'Yes';
        acc1.Email__c = 'Test@test.com';
        acc.add(acc1);
        insert acc;
        System.assertEquals(acc1.Customer_Type__c,'Credit Customer');
        CustomerID.add(acc1.id);
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=acc1.id;
        insert attach;
        System.assertEquals(attach.Name,'Unit Test Attachment');
        
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:acc1.id];
        System.assertEquals(1, attachments.size()); 
        
        ID RID2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        Account testAccount = new Account();
        testAccount.Type = 'Vendor';
        testAccount.Name = 'TestAccountName';
        testAccount.RecordTypeId = RID2;
        testAccount.Active__c='Yes';
        testAccount.Email__c = 'Test@test.com';
        insert testAccount;
        System.assertequals('Vendor',testAccount.Type);
        
        System.assertEquals(testAccount.name, 'TestAccountName');
        
        
        //inserting Contact
        Contact conn=new Contact();
        conn.AccountId=acc1.id;
        conn.Title='ms';
        conn.FirstName='Vidya';
        conn.LastName='min';
        insert conn;
        system.assertEquals(conn.FirstName,'Vidya');
        
        Default_Parameters__c DP = new Default_Parameters__c();
        DP.Name='defualt';
        DP.Inventory_Status__c='Reserve';
        DP.Auto_Reserve_Stock__c=true;
        insert DP;
        System.assertequals(DP.Name,'defualt');
        
        //inserting Products
        List<Product2> ProdList = new List<Product2>();
        Product2 prod=new Product2();
        prod.Name='Medical Kit';
        prod.Stock_Item__c = true;
        prod.Product_Type__c = 'Category 1';
        prod.Attribute_Type__c='BULK';
        prod.Type__c='BOM';
        prod.Reorder_Quantity__c=50;
        prod.Threshold_Quantity__c=50;
        prod.Product_Price__c = 100.00;
        prod.Solution_Component__c=true;
        ProdList.add(prod);
        System.assertequals(prod.Name,'Medical Kit');
        
        Product2 prod2=new Product2();
        prod2.Name='Vivo';
        prod2.Stock_Item__c = true;
        prod2.Attribute_Type__c='BULK';
        prod2.Type__c='BOM';
        prod2.Reorder_Quantity__c=50;
        prod2.Threshold_Quantity__c=50;
        prod2.Product_Type__c = 'Category 1';
        prod2.Product_Price__c = 100.00;
        prod2.Solution_Component__c=true;
        ProdList.add(prod2);
        System.assertequals(prod2.Name,'Vivo');
        
        Product2 prod3=new Product2();
        prod3.Name='Redme';
        prod3.Stock_Item__c = true;
        prod3.Product_Type__c = 'Category 1';
        prod3.Attribute_Type__c='BULK';
        prod3.Type__c='BOM';
        prod3.Reorder_Quantity__c=50;
        prod3.Threshold_Quantity__c=50;
        prod3.Product_Price__c = 100.00;
        prod3.Solution_Component__c=true;
        ProdList.add(prod3);
        System.assertequals(prod3.Name,'Redme');
        
        Product2 prod4=new Product2();
        prod4.Name='Panasonic';
        prod4.Stock_Item__c = true;
        prod4.Product_Type__c = 'Category 1';
        prod4.Attribute_Type__c='BULK';
        prod4.Type__c='BOM';
        prod4.Reorder_Quantity__c=50;
        prod4.Threshold_Quantity__c=50;
        prod4.Product_Price__c = 100.00;
        prod4.Solution_Component__c=true;
        ProdList.add(prod4);
        System.assertequals(prod4.Name,'Panasonic');
        
        insert ProdList;
        
        Vendor_Product__c vp  = new Vendor_Product__c();
        vp.Product_Name__c = prod.id;
        vp.Account_Name__c = testAccount.Id;
        vp.Buying_Price__c = 200;
        vp.Is_Preferred__c=true;
        insert vp;
        system.assertEquals(prod.id,vp.Product_Name__c);
        
        Inventory__c ProdInv = new Inventory__c();
        ProdInv.ProductCode__c = ProdList[0].Id;
        ProdInv.Total_Qty__c = 100;
        ProdInv.Available_Qty__c = 20;
        insert ProdInv;
        System.assertequals(ProdInv.Total_Qty__c,100);
        
        Inventory__c ProdInv1 = new Inventory__c();
        ProdInv1.ProductCode__c = ProdList[1].Id;
        ProdInv1.Total_Qty__c = 100;
        ProdInv1.Available_Qty__c = 90;
        insert ProdInv1;
        System.assertequals(ProdInv1.Total_Qty__c,100);
        
        List<Sigma_Order__c> SigOrderList=new List<Sigma_Order__c>();
        SET<ID> OrderID = new SET<ID>();
        
        //inserting Sales Order
        Sigma_Order__c SigOrder=new Sigma_Order__c();
        SigOrder.AccountId__c = acc1.Id;
        SigOrder.BillingPersonNew__c = conn.Id;
        SigOrder.Orders_Status__c = 'Pending';
        SigOrder.Order_Created_Via__c = 'Community';
        SigOrder.Delivary_Date__c = System.Today();
        SigOrder.Customer_Email__c = acc1.Email__c;
        SigOrder.Shipping_Street__c = acc1.ShippingStreet;
        SigOrder.ShippingState__c = acc1.ShippingState;
        SigOrder.ShippingPostalCode__c = acc1.ShippingPostalCode;
        SigOrder.ShippingCountry__c = acc1.ShippingCountry;
        SigOrder.ShippingCity__c = acc1.ShippingCity;
        SigOrder.RecordTypeId = OrderRecordType;
        SigOrder.TotalAmount__c=100;
        SigOrder.Order_Type__c = 'Online';
        SigOrder.Customer_Type__c = acc1.Customer_Type__c;
        SigOrder.Auto_Allocate__c = true;
        OrderID.add(SigOrder.id);
        SigOrderList.add(SigOrder);
        insert SigOrderList;
        System.assertequals(SigOrder.Order_Type__c,'Online');
        
        
        Sigma_Order__c SigOrder1=new Sigma_Order__c();
        SigOrder1.AccountId__c = acc1.Id;
        SigOrder1.BillingPersonNew__c = conn.Id;
        SigOrder1.Orders_Status__c = 'Submitted';
        SigOrder1.Order_Created_Via__c = 'Community';
        SigOrder1.Delivary_Date__c = System.Today();
        SigOrder1.Customer_Email__c = acc1.Email__c;
        SigOrder1.Shipping_Street__c = acc1.ShippingStreet;
        SigOrder1.ShippingState__c = acc1.ShippingState;
        SigOrder1.ShippingPostalCode__c = acc1.ShippingPostalCode;
        SigOrder1.ShippingCountry__c = acc1.ShippingCountry;
        SigOrder1.ShippingCity__c = acc1.ShippingCity;
        SigOrder1.TotalAmount__c=100;
        SigOrder1.RecordTypeId = OrderRecordType;
        SigOrder1.Order_Type__c = 'Online';
        SigOrder1.Customer_Type__c = acc1.Customer_Type__c;
        SigOrder1.Auto_Allocate__c = true;
        OrderID.add(SigOrder1.id);
        
        insert SigOrder1;
        System.assertequals(SigOrder1.Order_Type__c,'Online');
        
        //Order and available quantity
        integer orderingQuantity = 100;
        integer AvlQua = Integer.valueof(ProdInv.Available_Qty__c);
        List<Product_Order_Price_Book__c> OrdlineList = new List<Product_Order_Price_Book__c>();
        
        Map<String,Product_Order_Price_Book__c> Lineit = new Map<String,Product_Order_Price_Book__c>();
        Map<String,List<Product_Order_Price_Book__c>> Lineits = new Map<String,List<Product_Order_Price_Book__c>>();
        
        
        //inserting Sales Order Line item
        SET<ID> OrderLineID = new SET<ID>();
        Product_Order_Price_Book__c SignProd= new Product_Order_Price_Book__c();
        SignProd.Product__c = ProdList[0].Id;
        SignProd.Sigma_Order__c = SigOrder1.Id;
        SignProd.Quantity__c = orderingQuantity;
        SignProd.Discounts__c=2;
        SignProd.IsInventoryUpdated__c=true;
        SignProd.Back_Order__c=true;
        SignProd.Order_Status__c='Order Confirmed';
        SignProd.Net_Quantity__c = orderingQuantity;
        SignProd.Remaining_Qty_To_Package__c = orderingQuantity;
        SignProd.Total_Amount__c = ProdList[0].Product_Price__c;
        SignProd.Total_Price__c = orderingQuantity * (ProdList[0].Product_Price__c);
        SignProd.Ordered_Amount__c = orderingQuantity * (ProdList[0].Product_Price__c);
        SignProd.Back_Order__c = false;
        OrderLineID.add(SignProd.id);
        OrdlineList.add(SignProd);
        System.assertequals(SignProd.Back_Order__c,false);
        
        Product_Order_Price_Book__c SignProd1= new Product_Order_Price_Book__c();
        SignProd1.Product__c = ProdList[1].Id;
        SignProd1.Sigma_Order__c = SigOrder1.Id;
        SignProd1.Quantity__c = orderingQuantity;
        SignProd1.Discounts__c=2;
        SignProd1.IsInventoryUpdated__c=true;
        SignProd1.Back_Order__c=true;
        SignProd1.Order_Status__c='Order Confirmed';
        SignProd1.Net_Quantity__c = orderingQuantity;
        SignProd1.Remaining_Qty_To_Package__c = orderingQuantity;
        SignProd1.Total_Amount__c = ProdList[1].Product_Price__c;
        SignProd1.Total_Price__c = orderingQuantity * (ProdList[1].Product_Price__c);
        SignProd1.Ordered_Amount__c = orderingQuantity * (ProdList[1].Product_Price__c);
        SignProd1.Back_Order__c = true;
        OrderLineID.add(SignProd1.id);
        OrdlineList.add(SignProd1);
        System.assertequals(SignProd1.Order_Status__c,'Order Confirmed');
        
        Product_Order_Price_Book__c SignProd2= new Product_Order_Price_Book__c();
        SignProd2.Product__c = ProdList[1].Id;
        SignProd2.Sigma_Order__c = SigOrder1.Id;
        SignProd2.Quantity__c = 10;
        SignProd2.Discounts__c=2;
        SignProd2.IsInventoryUpdated__c=true;
        SignProd2.Back_Order__c=true;
        SignProd2.Order_Status__c='Order Confirmed';
        SignProd2.Net_Quantity__c = 10;
        SignProd2.Remaining_Qty_To_Package__c = orderingQuantity;
        SignProd2.Total_Amount__c = ProdList[1].Product_Price__c;
        SignProd2.Total_Price__c = orderingQuantity * (ProdList[1].Product_Price__c);
        SignProd2.Ordered_Amount__c = orderingQuantity * (ProdList[1].Product_Price__c);
        SignProd2.Back_Order__c = true;
        OrderLineID.add(SignProd2.id);
        OrdlineList.add(SignProd2);
        System.assertequals(SignProd2.Order_Status__c,'Order Confirmed');
        
        Product_Order_Price_Book__c SignProd3= new Product_Order_Price_Book__c();
        SignProd3.Product__c = ProdList[2].Id;
        SignProd3.Sigma_Order__c = SigOrder1.Id;
        SignProd3.Quantity__c = 20;
        SignProd3.Discounts__c=2;
        SignProd3.IsInventoryUpdated__c=true;
        SignProd3.Back_Order__c=true;
        SignProd3.Order_Status__c='Order Confirmed';
        SignProd3.Net_Quantity__c = 20;
        SignProd3.Remaining_Qty_To_Package__c = 20;
        SignProd3.Total_Amount__c = ProdList[2].Product_Price__c;
        SignProd3.Total_Price__c = 20 * (ProdList[2].Product_Price__c);
        SignProd3.Ordered_Amount__c = 20 * (ProdList[2].Product_Price__c);
        SignProd3.Back_Order__c = false;
        OrderLineID.add(SignProd3.id);
        OrdlineList.add(SignProd3);
        System.assertequals(SignProd3.Order_Status__c,'Order Confirmed');
        
        
        Product_Order_Price_Book__c SignProd4= new Product_Order_Price_Book__c();
        SignProd4.Product__c = ProdList[2].Id;
        SignProd4.Sigma_Order__c = SigOrder1.Id;
        SignProd4.Quantity__c = 10;
        SignProd4.Discounts__c=2;
        SignProd4.IsInventoryUpdated__c=true;
        SignProd4.Back_Order__c=true;
        SignProd4.Order_Status__c='Order Confirmed';
        SignProd4.Net_Quantity__c = 10;
        SignProd4.Remaining_Qty_To_Package__c = 10;
        SignProd4.Total_Amount__c = ProdList[2].Product_Price__c;
        SignProd4.Total_Price__c = 10 * (ProdList[2].Product_Price__c);
        SignProd4.Ordered_Amount__c = 10 * (ProdList[2].Product_Price__c);
        SignProd4.Back_Order__c = true;
        OrderLineID.add(SignProd4.id);
        OrdlineList.add(SignProd4);
        System.assertequals(SignProd4.Order_Status__c,'Order Confirmed');
        
        
        Product_Order_Price_Book__c SignProd5= new Product_Order_Price_Book__c();
        SignProd5.Product__c = ProdList[3].Id;
        SignProd5.Sigma_Order__c = SigOrder1.Id;
        SignProd5.Quantity__c = 20;
        SignProd5.Discounts__c=2;
        SignProd5.IsInventoryUpdated__c=true;
        SignProd5.Back_Order__c=true;
        SignProd5.Order_Status__c='Order Confirmed';
        SignProd5.Net_Quantity__c = 20;
        SignProd5.Remaining_Qty_To_Package__c = 20;
        SignProd5.Total_Amount__c = ProdList[3].Product_Price__c;
        SignProd5.Total_Price__c = 20 * (ProdList[3].Product_Price__c);
        SignProd5.Ordered_Amount__c = 20 * (ProdList[3].Product_Price__c);
        SignProd5.Back_Order__c = false;
        OrderLineID.add(SignProd5.id);
        OrdlineList.add(SignProd5);
        System.assertequals(SignProd5.Order_Status__c,'Order Confirmed');
        
        
        Product_Order_Price_Book__c SignProd6= new Product_Order_Price_Book__c();
        SignProd6.Product__c = ProdList[3].Id;
        SignProd6.Sigma_Order__c = SigOrder1.Id;
        SignProd6.Quantity__c = 90;
        SignProd6.Discounts__c=2;
        SignProd6.IsInventoryUpdated__c=true;
        SignProd6.Back_Order__c=true;
        SignProd6.Order_Status__c='Order Confirmed';
        SignProd6.Net_Quantity__c = 90;
        SignProd6.Remaining_Qty_To_Package__c = 90;
        SignProd6.Total_Amount__c = ProdList[3].Product_Price__c;
        SignProd6.Total_Price__c = 90 * (ProdList[3].Product_Price__c);
        SignProd6.Ordered_Amount__c = 90 * (ProdList[3].Product_Price__c);
        SignProd6.Back_Order__c = true;
        OrderLineID.add(SignProd6.id);
        OrdlineList.add(SignProd6);
        System.assertequals(SignProd6.Discounts__c,2); 
        
        insert OrdlineList;
        
        List<string> soString = new List<string>();
        
        Product_Price__c  prodprice = new Product_Price__c();
        prodprice.Product_Id__c=prod.id;
        prodprice.Discout__c=2;
        prodprice.Customer__c=acc1.id;
        prodprice.Status__c ='Active';
        prodprice.Start_Date__c = system.today();
        prodprice.End_Date__c = system.today()+30;
        prodprice.Cost__c=1000;
        prodprice.Location__c=acc2.id;
        insert prodprice;
        System.assertequals(SignProd6.Discounts__c,2); 
        List<viewCartctrl.SOLIWrapper> UpdateCart = new List<viewCartctrl.SOLIWrapper>();
        
        String Serlize = JSON.serialize(UpdateCart);
        
        
        DisplayProducts.completeProductWrapper catordorwrap1=new DisplayProducts.completeProductWrapper();
        catordorwrap1.pageSize=2;
        catordorwrap1.pageNumber=3;
        catordorwrap1.totalRecords=10;
        catordorwrap1.recordStart=1;
        catordorwrap1.recordEnd=9;
        catordorwrap1.tabOverride='tabOverride';
        System.assertequals(catordorwrap1.totalRecords,10); 
        
        List<DisplayProducts.ProductWrapper> listofcatprodwrap= new List<DisplayProducts.ProductWrapper>(); 
        DisplayProducts.ProductWrapper catprodwrap1=new DisplayProducts.ProductWrapper();
        catprodwrap1.Id=prod.id;
        catprodwrap1.Name=Prod.Name;
        catprodwrap1.producttype= Prod.Product_Type__c;
        catprodwrap1.AvailableQuantity=90;
        catprodwrap1.productfamily=Prod.Bar_Code_Gene__c;
        catprodwrap1.Attachementsid=attach.id;
        catprodwrap1.ProductPrice=Prod.Product_Price__c;
        listofcatprodwrap.add(catprodwrap1);
        System.assertequals(catprodwrap1.AvailableQuantity,90); 
        
        List<String> prodFamilyList = new List<String>();
        prodFamilyList.add('Bom type');
        prodFamilyList.add('Individual type');
        
        catordorwrap1.Ocomp='Ocomp';
        List<String> PcurrList=new List<String>();
        PcurrList.add('Euro');
        PcurrList.add('Aus');
        
        String ProductId = prod.id;
        String ProductPrice =prodprice.id;
        String Avlquantity1 ='20';
        String EnteredQuantity1='50';
        
        String Avlquantity2 ='90';
        String EnteredQuantity2='5';
        
        String ProdType = Prod.Product_Type__c;
        String PageNumber ='3';
        
        Test.startTest();
        DisplayProducts.saveSO(ProductId,ProductPrice,Avlquantity1,EnteredQuantity1);
        DisplayProducts.saveSO(ProductId,ProductPrice,Avlquantity2,EnteredQuantity2);
        Test.stopTest();
    }
    
    @IsTest(seeAllData=false)
    public static void Test3()
    {
        ID RID3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();
        Account  acc2=new Account();
        acc2.Name='Belagavi';
        acc2.Type='Location';
        acc2.RecordTypeId = RID3;
        acc2.Active__c = 'Yes';
        insert acc2;
        System.assertEquals(acc2.Name,'Belagavi');
        
        ID RID1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        ID OrderRecordType = Schema.SObjectType.Sigma_Order__c.getRecordTypeInfosByDeveloperName().get('Product_Order').getRecordTypeId();
        
        List<Account>  acc=new List<Account>();
        //inserting Accounts
        SET<ID> CustomerID = new SET<ID>();
        Account acc1 = new Account();
        acc1.Name='Kruti Credit Customer';
        acc1.Type='Customer';
        acc1.RecordTypeId = RID1;
        acc1.Active__c = 'Yes';
        acc1.Base_Credit_Limit__c = 10000000.00;
        acc1.Customer_Type__c = 'Credit Customer';
        acc1.Email__c = 'Test@test.com';
        acc.add(acc1);
        insert acc;
        CustomerID.add(acc1.id);
        System.assertEquals(acc1.Name,'Kruti Credit Customer');
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=acc1.id;
        insert attach;
        System.assertEquals(attach.Name,'Unit Test Attachment');
        
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:acc1.id];
        System.assertEquals(1, attachments.size()); 
        
        ID RID2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        Account testAccount = new Account();
        testAccount.Type = 'Vendor';
        testAccount.Name = 'TestAccountName';
        testAccount.RecordTypeId = RID2;
        testAccount.Active__c='Yes';
        testAccount.Email__c = 'Test@test.com';
        insert testAccount;
        System.assertequals('Vendor',testAccount.Type);
        
        System.assertEquals(testAccount.name, 'TestAccountName');
        
        
        //inserting Contact
        Contact conn=new Contact();
        conn.AccountId=acc1.id;
        conn.Title='ms';
        conn.FirstName='Vidya';
        conn.LastName='min';
        insert conn;
        system.assertEquals(conn.FirstName,'Vidya');
        
        Default_Parameters__c DP = new Default_Parameters__c();
        DP.Name='defualt';
        DP.Inventory_Status__c='Reserve';
        DP.Auto_Reserve_Stock__c=true;
        insert DP;
        system.assertEquals(DP.Auto_Reserve_Stock__c,true);
        
        //inserting Products
        List<Product2> ProdList = new List<Product2>();
        Product2 prod=new Product2();
        prod.Name='Medical Kit';
        prod.Stock_Item__c = true;
        prod.Product_Type__c = 'Category 1';
        prod.Attribute_Type__c='BULK';
        prod.Type__c='BOM';
        prod.Reorder_Quantity__c=50;
        prod.Threshold_Quantity__c=50;
        prod.Product_Price__c = 100.00;
        prod.Solution_Component__c=true;
        ProdList.add(prod);
        system.assertEquals(prod.Product_Price__c ,100.00);
        
        Product2 prod2=new Product2();
        prod2.Name='Vivo';
        prod2.Stock_Item__c = true;
        prod2.Attribute_Type__c='BULK';
        prod2.Type__c='BOM';
        prod2.Reorder_Quantity__c=50;
        prod2.Threshold_Quantity__c=50;
        prod2.Product_Type__c = 'Category 1';
        prod2.Product_Price__c = 100.00;
        prod2.Solution_Component__c=true;
        ProdList.add(prod2);
        system.assertEquals(prod2.Product_Price__c ,100.00);
        
        
        Product2 prod3=new Product2();
        prod3.Name='Redme';
        prod3.Stock_Item__c = true;
        prod3.Product_Type__c = 'Category 1';
        prod3.Attribute_Type__c='BULK';
        prod3.Type__c='BOM';
        prod3.Reorder_Quantity__c=50;
        prod3.Threshold_Quantity__c=50;
        prod3.Product_Price__c = 100.00;
        prod3.Solution_Component__c=true;
        ProdList.add(prod3);
        system.assertEquals(prod3.Product_Price__c ,100.00);
        
        Product2 prod4=new Product2();
        prod4.Name='Panasonic';
        prod4.Stock_Item__c = true;
        prod4.Product_Type__c = 'Category 1';
        prod4.Attribute_Type__c='BULK';
        prod4.Type__c='BOM';
        prod4.Reorder_Quantity__c=50;
        prod4.Threshold_Quantity__c=50;
        prod4.Product_Price__c = 100.00;
        prod4.Solution_Component__c=true;
        ProdList.add(prod4);
        system.assertEquals(prod4.Product_Price__c ,100.00);        
        insert ProdList;
        
        
        Vendor_Product__c vp  = new Vendor_Product__c();
        vp.Product_Name__c = prod.id;
        vp.Account_Name__c = testAccount.Id;
        vp.Buying_Price__c = 200;
        vp.Is_Preferred__c=true;
        insert vp;
        system.assertEquals(prod.id,vp.Product_Name__c);
        
        //inserting Product Inventory
        Inventory__c ProdInv = new Inventory__c();
        ProdInv.ProductCode__c = ProdList[0].Id;
        ProdInv.Total_Qty__c = 100;
        ProdInv.Available_Qty__c = 90;
        insert ProdInv;
        system.assertEquals(ProdInv.Available_Qty__c,90 );
        
        Inventory__c ProdInv1 = new Inventory__c();
        ProdInv1.ProductCode__c = ProdList[1].Id;
        ProdInv1.Total_Qty__c = 100;
        ProdInv1.Available_Qty__c = 20;
        insert ProdInv1;
        system.assertEquals(ProdInv1.Available_Qty__c,20);
        
        List<Dimension_Tag__c> DimTag = new List<Dimension_Tag__c>();
        for(Dimension_Tag__c DImtags:[select Id,Account__c,Base_Credit_Limit__c,Due_Amount__c,Ordered_Amount__c,Paid_Amount__c,Remaining_Credit_Limit__c from Dimension_Tag__c where Account__c =: acc1.Id])
        {
            DImtags.Base_Credit_Limit__c = 100000000000000.00;
            DImtags.Ordered_Amount__c = 100;
            DImtags.Paid_Amount__c = 50;
            DimTag.add(DImtags);
        }
        update DimTag;
        
        List<Sigma_Order__c> SigOrderList=new List<Sigma_Order__c>();
        SET<ID> OrderID = new SET<ID>();
        
        //inserting Sales Order
        Sigma_Order__c SigOrder=new Sigma_Order__c();
        SigOrder.AccountId__c = acc1.Id;
        SigOrder.BillingPersonNew__c = conn.Id;
        SigOrder.Orders_Status__c = 'Pending';
        SigOrder.Order_Created_Via__c = 'Community';
        SigOrder.Delivary_Date__c = System.Today();
        SigOrder.Customer_Email__c = acc1.Email__c;
        SigOrder.Shipping_Street__c = acc1.ShippingStreet;
        SigOrder.ShippingState__c = acc1.ShippingState;
        SigOrder.ShippingPostalCode__c = acc1.ShippingPostalCode;
        SigOrder.ShippingCountry__c = acc1.ShippingCountry;
        SigOrder.ShippingCity__c = acc1.ShippingCity;
        SigOrder.RecordTypeId = OrderRecordType;
        SigOrder.TotalAmount__c=100;
        SigOrder.Order_Type__c = 'Online';
        SigOrder.Customer_Type__c = acc1.Customer_Type__c;
        SigOrder.Auto_Allocate__c = true;
        OrderID.add(SigOrder.id);
        SigOrderList.add(SigOrder);
        system.assertEquals(SigOrder.Order_Type__c ,'Online');
        
        
        Sigma_Order__c SigOrder1=new Sigma_Order__c();
        SigOrder1.AccountId__c = acc1.Id;
        SigOrder1.BillingPersonNew__c = conn.Id;
        SigOrder1.Orders_Status__c = 'Submitted';
        SigOrder1.Order_Created_Via__c = 'Community';
        SigOrder1.Delivary_Date__c = System.Today();
        SigOrder1.Customer_Email__c = acc1.Email__c;
        SigOrder1.Shipping_Street__c = acc1.ShippingStreet;
        SigOrder1.ShippingState__c = acc1.ShippingState;
        SigOrder1.ShippingPostalCode__c = acc1.ShippingPostalCode;
        SigOrder1.ShippingCountry__c = acc1.ShippingCountry;
        SigOrder1.ShippingCity__c = acc1.ShippingCity;
        SigOrder1.TotalAmount__c=100;
        SigOrder1.RecordTypeId = OrderRecordType;
        SigOrder1.Order_Type__c = 'Online';
        SigOrder1.Customer_Type__c = acc1.Customer_Type__c;
        SigOrder1.Auto_Allocate__c = true;
        OrderID.add(SigOrder1.id);
        SigOrderList.add(SigOrder1);
        
        insert SigOrderList;
        system.assertEquals(SigOrder1.Order_Type__c ,'Online');
        
        //Order and available quantity
        integer orderingQuantity = 100;
        integer AvlQua = Integer.valueof(ProdInv.Available_Qty__c);
        List<Product_Order_Price_Book__c> OrdlineList = new List<Product_Order_Price_Book__c>();
        
        Map<String,Product_Order_Price_Book__c> Lineit = new Map<String,Product_Order_Price_Book__c>();
        Map<String,List<Product_Order_Price_Book__c>> Lineits = new Map<String,List<Product_Order_Price_Book__c>>();
        
        
        //inserting Sales Order Line item
        SET<ID> OrderLineID = new SET<ID>();
        Product_Order_Price_Book__c SignProd= new Product_Order_Price_Book__c();
        SignProd.Product__c = ProdList[0].Id;
        SignProd.Sigma_Order__c = SigOrderList[0].Id;
        SignProd.Quantity__c = orderingQuantity;
        SignProd.Discounts__c=2;
        SignProd.IsInventoryUpdated__c=true;
        SignProd.Back_Order__c=true;
        SignProd.Order_Status__c='Order Confirmed';
        SignProd.Net_Quantity__c = orderingQuantity;
        SignProd.Remaining_Qty_To_Package__c = orderingQuantity;
        SignProd.Total_Amount__c = ProdList[0].Product_Price__c;
        SignProd.Total_Price__c = orderingQuantity * (ProdList[0].Product_Price__c);
        SignProd.Ordered_Amount__c = orderingQuantity * (ProdList[0].Product_Price__c);
        SignProd.Back_Order__c = false;
        OrderLineID.add(SignProd.id);
        OrdlineList.add(SignProd);
        system.assertEquals(SignProd.Order_Status__c,'Order Confirmed');
        
        Product_Order_Price_Book__c SignProd1= new Product_Order_Price_Book__c();
        SignProd1.Product__c = ProdList[1].Id;
        SignProd1.Sigma_Order__c = SigOrderList[0].Id;
        SignProd1.Quantity__c = orderingQuantity;
        SignProd1.Discounts__c=2;
        SignProd1.IsInventoryUpdated__c=true;
        SignProd1.Back_Order__c=true;
        SignProd1.Order_Status__c='Order Confirmed';
        SignProd1.Net_Quantity__c = orderingQuantity;
        SignProd1.Remaining_Qty_To_Package__c = orderingQuantity;
        SignProd1.Total_Amount__c = ProdList[1].Product_Price__c;
        SignProd1.Total_Price__c = orderingQuantity * (ProdList[1].Product_Price__c);
        SignProd1.Ordered_Amount__c = orderingQuantity * (ProdList[1].Product_Price__c);
        SignProd1.Back_Order__c = true;
        OrderLineID.add(SignProd1.id);
        OrdlineList.add(SignProd1);
        system.assertEquals(SignProd1.Order_Status__c,'Order Confirmed');
        
        Product_Order_Price_Book__c SignProd2= new Product_Order_Price_Book__c();
        SignProd2.Product__c = ProdList[1].Id;
        SignProd2.Sigma_Order__c = SigOrderList[0].Id;
        SignProd2.Quantity__c = 20;
        SignProd2.Discounts__c=2;
        SignProd2.IsInventoryUpdated__c=true;
        SignProd2.Back_Order__c=true;
        SignProd2.Order_Status__c='Order Confirmed';
        SignProd2.Net_Quantity__c = 20;
        SignProd2.Remaining_Qty_To_Package__c = orderingQuantity;
        SignProd2.Total_Amount__c = ProdList[1].Product_Price__c;
        SignProd2.Total_Price__c = orderingQuantity * (ProdList[1].Product_Price__c);
        SignProd2.Ordered_Amount__c = orderingQuantity * (ProdList[1].Product_Price__c);
        SignProd2.Back_Order__c = true;
        OrderLineID.add(SignProd2.id);
        OrdlineList.add(SignProd2);
        
        system.assertEquals(SignProd2.Order_Status__c,'Order Confirmed');
        
        Product_Order_Price_Book__c SignProd3= new Product_Order_Price_Book__c();
        SignProd3.Product__c = ProdList[2].Id;
        SignProd3.Sigma_Order__c = SigOrderList[0].Id;
        SignProd3.Quantity__c = 90;
        SignProd3.Discounts__c=2;
        SignProd3.IsInventoryUpdated__c=true;
        SignProd3.Back_Order__c=true;
        SignProd3.Order_Status__c='Order Confirmed';
        SignProd3.Net_Quantity__c = 90;
        SignProd3.Remaining_Qty_To_Package__c = 90;
        SignProd3.Total_Amount__c = ProdList[2].Product_Price__c;
        SignProd3.Total_Price__c = 90 * (ProdList[2].Product_Price__c);
        SignProd3.Ordered_Amount__c = 90 * (ProdList[2].Product_Price__c);
        SignProd3.Back_Order__c = false;
        OrderLineID.add(SignProd3.id);
        OrdlineList.add(SignProd3);
        system.assertEquals(SignProd3.Order_Status__c,'Order Confirmed');
        
        Product_Order_Price_Book__c SignProd4= new Product_Order_Price_Book__c();
        SignProd4.Product__c = ProdList[2].Id;
        SignProd4.Sigma_Order__c = SigOrderList[0].Id;
        SignProd4.Quantity__c = 10;
        SignProd4.Discounts__c=2;
        SignProd4.IsInventoryUpdated__c=true;
        SignProd4.Back_Order__c=true;
        SignProd4.Order_Status__c='Order Confirmed';
        SignProd4.Net_Quantity__c = 10;
        SignProd4.Remaining_Qty_To_Package__c = 10;
        SignProd4.Total_Amount__c = ProdList[2].Product_Price__c;
        SignProd4.Total_Price__c = 10 * (ProdList[2].Product_Price__c);
        SignProd4.Ordered_Amount__c = 10 * (ProdList[2].Product_Price__c);
        SignProd4.Back_Order__c = true;
        OrderLineID.add(SignProd4.id);
        OrdlineList.add(SignProd4);
        system.assertEquals(SignProd4.Back_Order__c,true);
        
        
        Product_Order_Price_Book__c SignProd5= new Product_Order_Price_Book__c();
        SignProd5.Product__c = ProdList[3].Id;
        SignProd5.Sigma_Order__c = SigOrderList[1].Id;
        SignProd5.Quantity__c = 90;
        SignProd5.Discounts__c=2;
        SignProd5.IsInventoryUpdated__c=true;
        SignProd5.Back_Order__c=true;
        SignProd5.Order_Status__c='Order Confirmed';
        SignProd5.Net_Quantity__c = 90;
        SignProd5.Remaining_Qty_To_Package__c = 90;
        SignProd5.Total_Amount__c = ProdList[3].Product_Price__c;
        SignProd5.Total_Price__c = 90 * (ProdList[3].Product_Price__c);
        SignProd5.Ordered_Amount__c = 90 * (ProdList[3].Product_Price__c);
        SignProd5.Back_Order__c = false;
        OrderLineID.add(SignProd5.id);
        OrdlineList.add(SignProd5);
        system.assertEquals(SignProd5.Net_Quantity__c ,90);
        
        
        insert OrdlineList;
        
        List<string> soString = new List<string>();
        
        Product_Price__c  prodprice = new Product_Price__c();
        prodprice.Product_Id__c=prod.id;
        prodprice.Discout__c=2;
        prodprice.Customer__c=acc1.id;
        prodprice.Status__c ='Active';
        prodprice.Start_Date__c = system.today();
        prodprice.End_Date__c = system.today()+30;
        prodprice.Cost__c=1000;
        prodprice.Location__c=acc2.id;
        insert prodprice;
        system.assertEquals(prodprice.Status__c ,'Active');
        List<viewCartctrl.SOLIWrapper> UpdateCart = new List<viewCartctrl.SOLIWrapper>();
        
        for(Sigma_Order__c ord : SigOrderList)
        {
            
            for(Product_Order_Price_Book__c orfli: [select id,Ordered_Amount__c,Total_Price__c,Remaining_Qty_To_Package__c,Quantity__c,Sigma_Order__c,Product__c,Total_Amount__c,Net_Quantity__c from Product_Order_Price_Book__c where Sigma_Order__c IN : SigOrderList])
            {
                List<Product_Order_Price_Book__c> OrdlineLists = new List<Product_Order_Price_Book__c>();
                OrdlineLists.add(orfli);
                List<Product_Order_Price_Book__c> OrdlineLists1 = new List<Product_Order_Price_Book__c>();
                OrdlineLists1.add(orfli);
                viewCartctrl.SOLIWrapper UpdateCarts = new viewCartctrl.SOLIWrapper();
                UpdateCarts.SOid = orfli.Sigma_Order__c;
                UpdateCarts.ProductId = orfli.Product__c;
                UpdateCarts.OrderedQuantity = Integer.valueof(orfli.Net_Quantity__c);
                UpdateCarts.LineitemAvlquant.put(orfli.Id,orfli);
                if(UpdateCarts.Lineitemse.containsKey(orfli.Product__c))
                    UpdateCarts.Lineitemse.get(orfli.Product__c).add(orfli);
                else
                    UpdateCarts.Lineitemse.put(orfli.Product__c,OrdlineLists);
                UpdateCart.add(UpdateCarts);
                
                Lineits.put('str',OrdlineList);
                Lineits.put('str',OrdlineLists1);
            }
            String sostr = ord.Currency__c;
            soString.add(sostr);
            
        }
        
        System.debug(' test>>'+UpdateCart[0].Lineitemse);
        //adding value to wrapper class
        
        
        String Serlize = JSON.serialize(UpdateCart);
        
        DisplayProducts.completeProductWrapper catordorwrap1=new DisplayProducts.completeProductWrapper();
        catordorwrap1.pageSize=2;
        catordorwrap1.pageNumber=3;
        catordorwrap1.totalRecords=10;
        catordorwrap1.recordStart=1;
        catordorwrap1.recordEnd=9;
        catordorwrap1.tabOverride='tabOverride';
        system.assertEquals(catordorwrap1.recordEnd,9);
        
        List<DisplayProducts.ProductWrapper> listofcatprodwrap= new List<DisplayProducts.ProductWrapper>(); 
        DisplayProducts.ProductWrapper catprodwrap1=new DisplayProducts.ProductWrapper();
        catprodwrap1.Id=prod.id;
        catprodwrap1.Name=Prod.Name;
        catprodwrap1.producttype= Prod.Product_Type__c;
        catprodwrap1.AvailableQuantity=90;
        catprodwrap1.productfamily=Prod.Bar_Code_Gene__c;
        catprodwrap1.Attachementsid=attach.id;
        catprodwrap1.ProductPrice=Prod.Product_Price__c;
        listofcatprodwrap.add(catprodwrap1);
        system.assertEquals(catprodwrap1.AvailableQuantity,90);
        
        List<String> prodFamilyList = new List<String>();
        prodFamilyList.add('Bom type');
        prodFamilyList.add('Individual type');
        
        catordorwrap1.Ocomp='Ocomp';
        List<String> PcurrList=new List<String>();
        PcurrList.add('Euro');
        PcurrList.add('Aus');
        
        String ProductId = prod.id;
        String ProductPrice =prodprice.id;
        String Avlquantity ='90';
        String EnteredQuantity='95';
        String Avlquantity1 ='20';
        String EnteredQuantity1='50';
        
        
        String ProdType = Prod.Product_Type__c;
        String PageNumber ='1';
        String SearckKeyWord = prod.Name;
        Decimal PageNumbers =0.00;
        
        Test.startTest();
        ViewCart.deleteProductFromCart(SignProd.Id,SigOrder.Id,prod.Id);
        ViewCart.getAllCartDetails();
        ViewCart.updateCartValue(Serlize);
        ViewCart.ClearCartDetails(acc1.id);
        
        DisplayProducts.getproductlist(prod.Id);
        DisplayProducts.saveSO(ProductId,ProductPrice,Avlquantity,EnteredQuantity);
        DisplayProducts.saveSO(ProductId,ProductPrice,Avlquantity1,EnteredQuantity1);
        Test.stopTest();
    }
    
}