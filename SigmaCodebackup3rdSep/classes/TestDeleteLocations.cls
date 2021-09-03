@isTest
public class TestDeleteLocations {

    @isTest(SeeAllData=false)
    public static void test(){        
      Test.startTest();
    Account a1=new Account();
    a1.Name='abc';
    Id stExam = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();
    a1.Email__c='abc@gmail.com';
    a1.NumberofLocations__c=2;
    insert a1;
    system.assertEquals(a1.NumberofLocations__c,2);
    
    Account a=new Account();
    a.Name='Harish';
    //a.Location__c = a1.id;
    a.NumberofLocations__c=2;
    a.RecordtypeId=stExam;
    insert a;
    system.assertEquals(a.Name,'Harish');
    
    Inventory_Location__c il=new Inventory_Location__c();
    il.Location__c=a.Id;
    il.Available_Quantity__c=1;
    insert il;
    system.assertEquals(il.Available_Quantity__c,1);
    delete il;
    
  
     
    Test.stopTest();    
}
}