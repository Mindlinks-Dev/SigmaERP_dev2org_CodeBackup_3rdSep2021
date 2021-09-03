@isTest
public class TestMR_WorkOrderLinePriceUpdate {
    @isTest(seealldata = false)
    static void TestMR_WorkOrderLinePriceUpdate1(){
        
        Test.startTest();
        AssetTriggerCheck__c cs = new AssetTriggerCheck__c();
        cs.Name='APU';
        cs.CheckAssetPriceUpdatetrigger__c=false;
        //cs.Other fiels values
        insert cs;
        
        Account testAccount = new Account();
        testAccount.Name = 'Test1';
        testAccount.ShippingCity = 'San Francisco';
        testAccount.ShippingCountry = 'USA';
        testAccount.ShippingState = 'California';
        testAccount.ShippingPostalCode = '94103';
        testAccount.BillingCity = 'Bengalore';
        testAccount.BillingCountry = 'India';
        testAccount.BillingPostalCode = '560068';
        testAccount.BillingState = 'Karnataka';
        testAccount.BillingStreet = 'Hosur Main Road';
        testAccount.Email__c='abc@gmail.com';
        insert testAccount;
        Id AccountId = testAccount.Id;
        //System.debug('Acc Id-->'+testAccount.Id);
        
        Contact testContact = new Contact();
        testContact.FirstName = 'Vishnu';
        testContact.LastName = 'Test';
        testContact.AccountId = AccountId;
        testContact.MailingPostalCode='517132';
        insert testContact;
        Id ContactId = testContact.Id;
        
        Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        Id RID1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Test';
        acc.RecordTypeId = RID1;
        acc.Email__c='abc@gmail.com';
        insert acc;
       
            
        Default_Parameters__c  dp = new Default_Parameters__c (Name = 'Sample dp',Parent_Id__c = acc.Id);
        insert dp;
        
        Pricebook2 pb = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive=true);
        update pb;
        pb = [select IsStandard from pricebook2 where id= :pb.Id];
        // Create a new product
        Product2 prod= new Product2();
        prod.IsActive=true;
        prod.Name='Product123';
        prod.Active__c = true;
        prod.SKU__c = 'hi8873';
        insert prod;
        system.debug('product id  '+prod.Id);
        
        // Create a pricebook entry for standard pricebook
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pb.Id, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice; 
        
        Id productId = prod.Id;
        Decimal Price = standardPrice.UnitPrice;
        
       
        Date dt = Date.today();
        //System.debug('Date -->'+dt);
        
        Asset asse = new Asset();
        asse.Name = 'Test';
        if(productId != Null){
            asse.Product2Id = productId;
        }else{
            System.debug('Product Id is Null In Test Assert Please Check');
        }
        asse.AccountId = AccountId;
        asse.SerialNumber = '1234';
        asse.InstallDate = dt;
        asse.PurchaseDate = dt+1;
        asse.UsageEndDate = dt+2;
        //System.debug('Assert -->'+asse);
        insert asse;
        Id AssetId = asse.Id;
        Work_Type__c workType = new Work_Type__c();
        workType.Name = 'Repair';
        insert workType;
        

       DateTime d1 = DateTime.now();
       system.debug('>>.11'+d1);
       d1 = d1.addDays(30);
       system.debug('>>.'+d1);
       //d1.addHours(2);
       //caseRecord.Availability__c =  d1;//DateTime.newInstance(Date.today(), '11:00:00');//DateTime.now();
       d1 = DateTime.parse('10/28/2019 9:00 AM');
       
        
        Work_Order__c workOrder = new Work_Order__c();
        
         workOrder.Customer_Availability_Date__c = d1;
       workOrder.Status__c = 'Assigned';
       workOrder.Account__c = testAccount.Id;
        insert workOrder;
        Id workOrderId = workOrder.Id;
        
        Work_Oder_Lines__c workOrderLines = new Work_Oder_Lines__c();
        workOrderLines.Product__c = productId;
        workOrderLines.Work_Order__c = workOrderId;
        workOrderLines.Quantity__c = 10;
            insert workOrderLines;
            
            
            
            workOrder.Status__c = 'In Progress';
            update workOrder;
            
            workOrderLines.Quantity__c = 13;
            update workOrderLines;
            
            
            System.assertNotEquals(workOrderLines.Price__c, Price);
        Test.stopTest();
        
        
    }
}