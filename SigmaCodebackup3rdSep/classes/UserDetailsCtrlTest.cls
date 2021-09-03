@isTest
public class UserDetailsCtrlTest 
{
    /*@IsTest(seeAllData=false)
    public static void Test()
    {
       // ID RID1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account acc = new Account(Name = 'account',sigmaerpdev2__IsSalesforce__c='No');
        insert acc;
        
        Test.startTest();
        UserDetailsCtrl.getPickList('Account',acc.sigmaerpdev2__IsSalesforce__c);
        Test.stopTest();
        
    }*/
     @IsTest(seeAllData=false)
    public static void Test1()
    {
       // ID RID1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Account acc = new Account();
        acc.Name='Test Account';
        //acc.Type='Customer';
        //acc.RecordTypeId = RID1;
        acc.Phone='7894561231';
        acc.sigmaerpdev2__Email__c='Test@gmail.com';
        acc.sigmaerpdev2__Company__c='Mindlinks';
        acc.sigmaerpdev2__Job__c='Developer';
        acc.sigmaerpdev2__IsSalesforce__c='No';
       // insert acc;
        //System.assertEquals(acc.Name,'Test Account');
        
        Contact con = new Contact();
        con.AccountId=acc.id;
        con.LastName='Test LastName';
        con.Email='Test@gmail.com';
        insert con;
        
        Lead ld = new Lead();
        ld.sigmaerpdev2__Account__c = acc.Id;
        ld.LastName='Lead LastName';
        ld.Company='Mindlinks';
        insert ld;
        
        List<sigmaerpdev2__Sigma_Order__c> so = new List<sigmaerpdev2__Sigma_Order__c>();
        sigmaerpdev2__Sigma_Order__c sigmaorder = new sigmaerpdev2__Sigma_Order__c();
        //sigmaorder.sigmaerpdev2__AccountId__c=acc.Id;
        sigmaorder.sigmaerpdev2__CustomerName__c='Sigma';
        sigmaorder.sigmaerpdev2__Orders_Status__c= 'Pending';
        sigmaorder.sigmaerpdev2__Order_Created_Via__c = 'Community';
        sigmaorder.sigmaerpdev2__Order_Type__c='Online';
        sigmaorder.sigmaerpdev2__Delivary_Date__c=System.today();
        insert sigmaorder;
        so.add(sigmaorder);
        
        Test.startTest();
        UserDetailsCtrl.createAccount(acc);
        
        sigmaorder.sigmaerpdev2__AccountId__c=acc.Id;
        sigmaorder.sigmaerpdev2__Orders_Status__c= 'Order Confirmed';
        sigmaorder.sigmaerpdev2__Lead__c=ld.Id;
        update sigmaorder;
        Test.stopTest();
    }

}