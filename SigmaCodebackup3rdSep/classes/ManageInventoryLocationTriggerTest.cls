@isTest 
Public class ManageInventoryLocationTriggerTest
{
   @IsTest(seeAllData=false)
   public static void methodOne()
  {
            Test.startTest();

            List<Stock_In__c> stk = new List<Stock_In__c>{};

            Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
            List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();

            String RID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();

            String RID1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();

             String RID2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();

            Account testaccmerchant = new Account(Name= 'Test Merchant 4', Type = 'Merchant',Email__c='suhasn91@gmail.com',Web_Order_Type__c= 'Percentage', Web_Order_Value__c =40);
            insert testaccmerchant;
            System.assertEquals(testaccmerchant.Name,'Test Merchant 4');  

            Account accNew = new Account();
            accNew.Name = 'Test';
            accNew.Type = 'Location';
            accNew.Email__c='df@gmail.com';
            insert accNew;
            system.assertEquals('Test',accNew.Name);
            
          

            Default_Parameters__c  dftPr = new Default_Parameters__c ();
            dftPr.Name = 'ELift Merchant';
            dftPr.Parent_Id__c  = accNew.Id;
            insert dftPr;    
            system.assertEquals('ELift Merchant',dftPr.Name);

            Account acc = new Account();
            acc.name ='xyz';
            acc.Type='Location';
            acc.RecordTypeID =RID  ;
            insert acc;
            system.assertEquals('xyz',acc.Name);

            Account acc1 = new Account();
            acc1.name ='xy44z';
            acc1.Type='Location';
            acc1.RecordTypeID =RID1  ;
            insert acc1;
            system.assertEquals('xy44z',acc1.Name);

            Account acc2 = new Account();
            acc2.name ='xyz11';
            acc2.Type='Vendor';
            acc2.Email__c='kj@gmail.com';
            acc2.RecordTypeID =RID2  ;
            insert acc2;
            system.assertEquals('xyz11',acc2.Name);

            Product2  pro=new  Product2();
            pro.Name='JMTEST';
            pro.Attribute_Type__c = 'SERIALIZED';
            insert pro;
            system.assertEquals('JMTEST',pro.Name);
            Account accVendor = new Account();
            accVendor.Name = 'TestaccVendor';
            accVendor.Email__c='sdf@gmail.com';
            accVendor.Type = 'Vendor';
            insert accVendor;
            system.assertEquals(accVendor.Type,'Vendor');
            
        Vendor_Product__c vp  = new Vendor_Product__c();
        vp.Product_Name__c = pro.id;
        vp.Account_Name__c = accVendor.Id;
        vp.Buying_Price__c = 200;
        vp.Is_Preferred__c=true;
        insert vp;
        system.assertEquals(vp.Buying_Price__c , 200);

              
            Purchase_Order__c PO = new Purchase_Order__c();
            PO.Product_Supplier__c =acc2.Id;
            insert PO;
            System.assertEquals( PO.Product_Supplier__c,acc2.Id);

            Purchase_Order_Product__c POP = new Purchase_Order_Product__c();
            POP.Purchase_Order__c =PO.ID;
            POP.Received_Quantity__c=10;
            POP.Quantity__c = '1';
            POP.Product__c = pro.Id;
            insert POP;
            System.assertEquals( POP.Purchase_Order__c,PO.ID);

            Stock_In__c s = new Stock_In__c();
            s.Location__c = acc.ID;
            s.Vendor__c = acc2.Id;
            s.Purchase_Order__c = PO.Id;
            s.Status__c = 'Open';
            insert s;
            System.assertEquals(s.Location__c,acc.ID);

            dftPr.StockReceiving_ID__c = s.Id;
            update dftPr;
            System.assertEquals(dftPr.StockReceiving_ID__c,s.Id);         


            Lot__c lot1 = new Lot__c();
            lot1.Lot_Name__c = 'Test Lot';
            lot1.Product__c = pro.Id;
            lot1.Quantity__c = 10;
            lot1.Created_Date__c = system.today();
            lot1.Expiry_Date__c =  system.today()+5;
            insert lot1;
            System.assertEquals(lot1.Lot_Name__c,'Test Lot');   

            Lot_Product__c lotProd1 = new Lot_Product__c();
            lotProd1.Lot__c = lot1.Id;
            lotProd1.Product__c = pro.Id;
            lotProd1.Quantity__c = 10; 
            insert lotProd1;
            System.assertEquals(lotProd1.Lot__c,lot1.Id); 

            List<Lot__c> lt = new List<Lot__c>();
            Lot__c lot = new Lot__c();
            lot.Lot_Name__c = 'test';
            lot.Product__c = pro.Id;
            lot.Created_Date__c = system.today();
            lot.Expiry_Date__c =  system.today()+5;
            lt.add(lot);
            insert lt;
            System.assertEquals(lot.Lot_Name__c,'test'); 



            List<Lot_Product__c> lp = new  List<Lot_Product__c>();
            Lot_Product__c lprd = new Lot_Product__C();
            lprd.Lot__c = lt[0].Id;
            lp.add(lprd);
            insert lp;
            System.assertEquals(lprd.Lot__c,lt[0].Id); 

            Stock_In_Product__c stkPrd = new Stock_In_Product__c();
            stkPrd.Stock_In__c =s.Id ;
            stkPrd.Quantity_Received__c =4;
            stkPrd.Status__c ='Open';
            stkPrd.Putaway_location__c = acc1.ID;
            stkPrd.Purchase_Order__c =POP.Id ;
            stkPrd.pur_Order__c =PO.Id;
            stkPrd.Product__c = pro.Id;
            stkPrd.Lot__c = lot1.Id;
            insert stkPrd;
            System.assertEquals(stkPrd.Lot__c,lot1.Id);

            stkPrd.Status__c = 'Verified';
            update stkPrd;
            System.assertEquals(stkPrd.Lot__c,lot1.Id);



            Test.stopTest();
        }
        
        @IsTest(seeAllData=false)
   public static void methodTwo()
  {
                Test.startTest();

                List<Stock_In__c> stk = new List<Stock_In__c>{};

                Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
                List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();

                String RID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();

                String RID1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();

                String RID2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();


                Account testaccmerchant = new Account(Name= 'Test Merchant 4', Type = 'Merchant',Email__c='suhasn91@gmail.com',Web_Order_Type__c= 'Percentage', Web_Order_Value__c =40);
                insert testaccmerchant;
                System.assertEquals(testaccmerchant.Name,'Test Merchant 4');  

                Account accNew = new Account();
                accNew.Name = 'Test';
                accNew.Type = 'Location';
                accNew.Email__c='svd@gmail.com';
                insert accNew;
                system.assertEquals('Test',accNew.Name);

                Default_Parameters__c  dftPr = new Default_Parameters__c ();
                dftPr.Name = 'ELift Merchant';
                dftPr.Parent_Id__c  = accNew.Id;
                insert dftPr;    
                system.assertEquals('ELift Merchant',dftPr.Name);

                Account acc = new Account();
                acc.name ='xyz';
                acc.Type='Location';
                acc.RecordTypeID =RID  ;
                insert acc;
                system.assertEquals('xyz',acc.Name);

                Account acc1 = new Account();
                acc1.name ='xyz1';
                acc1.Type='Location';
                acc1.RecordTypeID =RID1  ;
                insert acc1;
                system.assertEquals('xyz1',acc1.Name);

                Account acc2 = new Account();
                acc2.name ='xyz11';
                acc2.Type='Vendor';
                acc2.Email__c='hjh@gmail.com';
                acc2.RecordTypeID =RID2  ;
                insert acc2;
                system.assertEquals('xyz11',acc2.Name);

                Product2  pro=new  Product2();
                pro.Name='JMTEST';
                pro.Attribute_Type__c = 'SERIALIZED';
                insert pro;
                system.assertEquals('JMTEST',pro.Name);
                
            Account accVendor = new Account();
            accVendor.Name = 'TestaccVendor';
            accVendor.Type = 'Vendor';
            accVendor.Email__c='sg@gmail.com';
            insert accVendor;
            system.assertEquals(accVendor.Type ,'Vendor');
                
        Vendor_Product__c vp  = new Vendor_Product__c();
        vp.Product_Name__c = pro.id;
        vp.Account_Name__c = accVendor.Id;
        vp.Buying_Price__c = 200;
        vp.Is_Preferred__c=true;
        insert vp;
        system.assertEquals(vp.Is_Preferred__c,true);

                
                

                Purchase_Order__c PO = new Purchase_Order__c();
                PO.Product_Supplier__c =acc2.Id;
                insert PO;
                System.assertEquals( PO.Product_Supplier__c,acc2.Id);

                Purchase_Order_Product__c POP = new Purchase_Order_Product__c();
                POP.Purchase_Order__c =PO.ID;
                POP.Received_Quantity__c=10;
                POP.Quantity__c = '1';
                POP.Product__c = pro.Id;
                insert POP;
                System.assertEquals( POP.Purchase_Order__c,PO.ID);

                Stock_In__c s = new Stock_In__c();
                s.Location__c = acc.ID;
                s.Vendor__c = acc2.Id;
                s.Purchase_Order__c = PO.Id;
                s.Status__c = 'Open';
                insert s;
                System.assertEquals(s.Location__c,acc.ID);

                dftPr.StockReceiving_ID__c = s.Id;
                update dftPr;
                System.assertEquals(dftPr.StockReceiving_ID__c,s.Id);         


                Lot__c lot1 = new Lot__c();
                lot1.Lot_Name__c = 'Test Lot';
                lot1.Product__c = pro.Id;
                lot1.Quantity__c = 10; 
                lot1.Created_Date__c = system.today();
                lot1.Expiry_Date__c =  system.today()+5;
                insert lot1;
                System.assertEquals(lot1.Lot_Name__c,'Test Lot');   

                Lot_Product__c lotProd1 = new Lot_Product__c();
                lotProd1.Lot__c = lot1.Id;
                lotProd1.Product__c = pro.Id;
                lotProd1.Quantity__c = 10; 
                insert lotProd1;
                System.assertEquals(lotProd1.Lot__c,lot1.Id); 

                List<Lot__c> lt = new List<Lot__c>();
                Lot__c lot = new Lot__c();
                lot.Lot_Name__c = 'test';
                lot.Product__c = pro.Id;
                lot.Created_Date__c = system.today();
                lot.Expiry_Date__c =  system.today()+5;
                lt.add(lot);
                insert lt;
                System.assertEquals(lot.Lot_Name__c,'test'); 

                List<Lot_Product__c> lp = new  List<Lot_Product__c>();
                Lot_Product__c lprd = new Lot_Product__C();
                lprd.Lot__c = lt[0].Id;
                lp.add(lprd);
                insert lp;
                System.assertEquals(lprd.Lot__c,lt[0].Id); 

                Stock_In_Product__c stkPrd = new Stock_In_Product__c();
                stkPrd.Stock_In__c =s.Id ;
                stkPrd.Quantity_Received__c =4;
                stkPrd.Status__c ='Open';
                stkPrd.Putaway_location__c = acc1.ID;
                stkPrd.Purchase_Order__c =POP.Id ;
                stkPrd.pur_Order__c =PO.Id;
                stkPrd.Product__c = pro.Id;
                stkPrd.Lot__c = lot1.Id;
                insert stkPrd;
                System.assertEquals(stkPrd.Lot__c,lot1.Id);


                System.assertEquals(stkPrd.Lot__c,lot1.Id);

                delete stkPrd;
                System.assertEquals(stkPrd.Lot__c,lot1.Id);

                Test.stopTest();
        }
}