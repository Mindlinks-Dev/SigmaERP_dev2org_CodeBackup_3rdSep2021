@isTest
public class TestWorkOrderTrigger { 
    static testMethod void ValidateWorkOrderTrigger() {
        Test.startTest();
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
        
        Account testAccount = new Account();
        testAccount.Name = 'Test';
        testAccount.BillingCity = 'Bengalore';
        testAccount.BillingCountry = 'India';
        testAccount.BillingPostalCode = '560068';
        testAccount.BillingState = 'Karnataka';
        testAccount.BillingStreet = 'Hosur Main Road';
        testAccount.ShippingCity = 'San Francisco';
        testAccount.ShippingCountry = 'USA';
        testAccount.ShippingState = 'California';
        testAccount.ShippingPostalCode = '94103';
        testAccount.Email__c='abc@gmail.com';
        insert testAccount;
        Work_Order__c w = new Work_Order__c(Status__c = 'Assigned');
        w.Service_City__c = 'TestCity';
        w.Work_Type__c = workType.Id;
        w.Customer_Availability_Date__c = d1;
        w.Status__c = 'Assigned';
        w.Account__c = testAccount.Id;
        insert w;
        //Work_Order__c testWO = [select id,Status__c from Work_Order__c where Service_City__c='TestCity'];
        Work_Order__c testWO = [select id,Status__c from Work_Order__c where id=:w.Id];
        testWO.Status__c = 'Completed';
        Update testWO;
        Work_Order__c testWO1 = [select id,Status__c from Work_Order__c where id =:w.id];
        system.debug('Updated Status  :'+testWO1.Status__c);
        System.assertEquals('Completed', testWO.Status__c);
        Test.stopTest();
        
    }
    
    @isTest(seealldata=false)
    public static void test(){
        Boolean success = true;        
        try {
            System.Test.startTest(); 
            Integer i =0;
            
            AssetTriggerCheck__c cs = new AssetTriggerCheck__c();
            cs.Name='APU';
            cs.CheckAssetPriceUpdatetrigger__c=false;
            //cs.Other fiels values
            insert cs;
            system.debug('AssetTrigger Check');
            
            // creating test account
            Account communityAccount = new Account();
            communityAccount.Name = 'Community Account - Test';
            communityAccount.ShippingCity = 'San Francisco';
            communityAccount.ShippingCountry = 'USA';
            communityAccount.ShippingState = 'California';
            communityAccount.ShippingPostalCode = '94103';
            communityAccount.BillingCity = 'Bengalore';
            communityAccount.BillingCountry = 'India';
            communityAccount.BillingPostalCode = '560068';
            communityAccount.BillingState = 'Karnataka';
            communityAccount.BillingStreet = 'Hosur Main Road';
            communityAccount.Email__c='abc@gmail.com';
            insert communityAccount;
            
            //-- STEP 1 :- INSERT CONTACT
            Contact newContact = new Contact();
            newContact.FirstName='testFN';
            newContact.LastName='testLN';
            newContact.MailingPostalCode='517132';
            
            insert newContact;
            
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
            
            
            
            Date dtt = Date.today();
            
            /*//-- STEP 2 :- INSERT ASSET
            
            Asset newAsset = new Asset();
            newAsset.Name = 'Test';
            newAsset.AccountId = communityAccount.Id;
            newAsset.SerialNumber = '1234';
            newAsset.InstallDate = dtt;
            newAsset.PurchaseDate = dtt+1;
            newAsset.UsageEndDate = dtt+2;
            //System.debug('Assert -->'+asse);
            insert newAsset;
            Id AssetId = newAsset.Id;
            system.debug('Asset Inserted');*/
            
            //-- Insert WorkOrder Type
            Work_Type__c workType = new Work_Type__c();
            workType.Name = 'Repair';
            insert workType;
            
            DateTime d1 = DateTime.now();
            system.debug('>>.11'+d1);
            d1 = d1.addDays(30);
            system.debug('>>.'+d1);
            //d1.addHours(2);
            //caseRecord.Availability__c =  d1;//DateTime.newInstance(Date.today(), '11:00:00');//DateTime.now();
            d1 = DateTime.parse('11/02/2019 5:00 PM');
            
            String createOrEdit = '';
            Location__c fromLocation = new Location__c(Location_Name__c = 'Central Warehouse', Location_Type__c='WareHouse');
            Location__c toLocation = new Location__c(Location_Name__c ='Truck 1', Location_Type__c='Truck');
            insert fromLocation;
            insert toLocation;
            
            
            // creating user contact
            Contact userContact = new Contact();
            userContact.firstname = 'Test';
            userContact.lastname = 'User1';
            userContact.MailingPostalCode='517132';
            userContact.email = 'testuser@crmit.com';
            userContact.accountid = communityAccount.id;
            userContact.Location__c = toLocation.Id;
            insert userContact;
            
            // create portal user 
            User portalUser = new User();
            portalUser.profileId = [select Id, Name from Profile where name = 'Partner Community - PC'
                                    limit 1
                                   ].id;
            portalUser.username = userContact.email;
            portalUser.email = userContact.email;
            portalUser.emailencodingkey = 'UTF-8';
            portalUser.localesidkey = 'en_US';
            portalUser.languagelocalekey = 'en_US';
            portalUser.timezonesidkey = 'America/Los_Angeles';
            portalUser.alias = userContact.lastname;
            portalUser.lastname = userContact.lastname;
            portalUser.firstname = userContact.firstname;
            portalUser.contactId = userContact.Id;
            insert portalUser;
            
            Service_Resource__c serviceResource = new Service_Resource__c();
            serviceResource.Name = 'Mr. Test';
            serviceResource.User__c=portalUser.Id;
            //serviceResource.Business_Calendar__c=calendar.Id;
            serviceResource.Active__c=true;
            serviceResource.Account__c=communityAccount.id;
            //serviceResource.Location__c=toLocation.Id;
            serviceResource.SR_Type__c='Field';
            serviceResource.Average_Travel_Speed__c='30';
            serviceResource.Mobile__c='9761898211';
            serviceResource.Email__c ='';
            serviceResource.Territory__c='San Francisco';
            serviceResource.Mailing_Street__c='';
            serviceResource.Mailing_City__c='';
            serviceResource.Mailing_Zip_Postal_Code__c='560018';
            serviceResource.Mailing_State_Province__c='';
            serviceResource.Mailing_Country__c='';
            insert serviceResource;
            system.debug('Service Resource Inserted - '+serviceResource);
            
            Work_Order__c workOrder = new Work_Order__c(FFP_MR_Contact__c=userContact.ID,Account__c=communityAccount.Id,Customer_Availability_Date__c=d1,Work_Type__c=workType.Id,Status__c  = 'Draft');
            Work_Order__c workOrder1 = new Work_Order__c(AssignTo__c=portalUser.Id,FFP_MR_Contact__c=userContact.ID,Account__c=communityAccount.Id,Customer_Availability_Date__c=d1,Work_Type__c=workType.Id,Status__c  = 'In Progress',Another_Visit_Needed__c=true);
            Work_Order__c workOrder2 = new Work_Order__c(AssignTo__c=portalUser.Id,FFP_MR_Contact__c=userContact.ID,Account__c=communityAccount.Id,Customer_Availability_Date__c=d1,Work_Type__c=workType.Id,Status__c  = 'Draft',Another_Visit_Needed__c=true,Reason_for_another_Visit__c='More Service Time Needed',Next_Visit_Date_Time__c=d1);
            insert workOrder2;
            workOrder2.Status__c = 'In Progress';
            update workOrder2;
            workOrder2.Status__c = 'Completed';
            update workOrder2;
            insert workOrder1;
            insert workOrder;
            system.debug('workOrder Test'+workOrder);
            system.debug('workOrder Test Class ***********************************');
            system.debug('workOrder Test'+workOrder1);
            system.debug('workOrder Test Class ***********************************');
            system.debug('workOrder Test'+workOrder2);
           
            

            
            workOrder1.Status__c = 'In Progress';
            update workOrder1;
            workOrder1.Status__c = 'Completed';
            update workOrder1;
            
            
            
            
            system.debug('Update 2'+workOrder);
            
            
            System.Test.stopTest();
            System.assert(true);
        }
        catch(Exception e){
            system.debug('Exception Occurred - '+e);
        }
    } 
}