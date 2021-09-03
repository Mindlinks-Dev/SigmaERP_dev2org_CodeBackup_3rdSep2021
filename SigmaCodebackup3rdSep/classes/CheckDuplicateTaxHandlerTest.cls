@isTest 
public class CheckDuplicateTaxHandlerTest
{
    @isTest(SeeAllData=false)
    public static void CheckDuplicateTaxHandler1(){
        
        Id RIDloc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account customerAccount= new Account();
        customerAccount.Name= 'Test Merchant 5';
        customerAccount.Type = 'Customer';
        customerAccount.Email__c='raghavendrahgr@gmail.com';
        customerAccount.Web_Order_Type__c= 'Percentage';
        customerAccount.Web_Order_Value__c =40;
        customerAccount.State__c='Alabama';
        customerAccount.Country__c='USA';
        customerAccount.RecordtypeId = RIDloc;
        insert customerAccount;
        System.assertEquals(customerAccount.Type, 'Customer');
        
        List<Tax__c> taxlist = new List<Tax__c>();
        
        Tax__c tax = new Tax__c();
        tax.Name__c = 'Name1';
        tax.Status__c = 'Active';
        tax.Applies_To__c = 'Federal Tax';
        tax.Tax_Amount__c = 2;
        tax.Type__c = 'Percentage';
        tax.Country__c = 'USA';
        tax.State__c = 'Alabama';
        taxlist.add(tax);
        insert taxlist;
        
        System.assertEquals(tax.Type__c, 'Percentage');
        
        
        Tax__c tax1 = new Tax__c();
        tax1.Id= tax.Id;
        tax1.Name__c = 'Name1';
        tax1.Status__c = 'Active';
        tax1.Applies_To__c = 'Federal Tax';
        tax1.Tax_Amount__c = 2;
        tax1.Type__c = 'Percentage';
        tax1.Country__c = 'USA';
        tax1.State__c = 'Alabama';
        update tax1;
        
        System.assertEquals(tax1.Type__c, 'Percentage');
        
        List<Tax__c> StatetaxList = new List<Tax__c>();
        Tax__c Statetax = new Tax__c();
        Statetax.Name__c = 'Name3';
        Statetax.Status__c = 'Active';
        Statetax.Applies_To__c = 'State Tax';
        Statetax.Tax_Amount__c = 2;
        Statetax.Type__c = 'Percentage';
        Statetax.Country__c = 'USA';
        Statetax.State__c = 'Alabama';
        StatetaxList.add(Statetax);
        insert StatetaxList;
        
        System.assertEquals(Statetax.Type__c, 'Percentage');
        
        
        Tax__c Statetax1 = new Tax__c();
        Statetax1.Id= Statetax.Id;
        Statetax1.Name__c = 'Name3';
        Statetax1.Status__c = 'Active';
        Statetax1.Applies_To__c = 'State Tax';
        Statetax1.Tax_Amount__c = 2;
        Statetax1.Type__c = 'Percentage';
        Statetax1.Country__c = 'USA';
        Statetax1.State__c = 'Alabama';
        update Statetax1;
        System.assertEquals(Statetax1.Type__c, 'Percentage');
        
        
        CheckDuplicateTaxHandler dup = new  CheckDuplicateTaxHandler();
        dup.CheckDuplicateinsert(taxlist);
        dup.CheckDuplicateinsert(StatetaxList);
        dup.checkDuplicatesupdate(taxlist);
        dup.checkDuplicatesupdate(StatetaxList);
    }
}