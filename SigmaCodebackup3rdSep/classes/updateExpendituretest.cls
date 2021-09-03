@isTest
public class updateExpendituretest {
 @IsTest(seeAllData=false)
  public static void updateExpenditure1()
    {
 Test.startTest();
   
   Project2__c prg=new Project2__c();
   prg.Status__c='Open';
   insert prg; 
   system.assertEquals(prg.Status__c,'Open');
   
    
   Expenditure__c ec=new Expenditure__c ();
    ec.Travel_Expenditure__c=123;
    ec.Resource_Expenditure__c=1345;
    ec.Project__c=prg.id;
    insert ec;
    system.assertEquals(ec.Resource_Expenditure__c,1345);
        
     Inventory_Consumption__c uc=new Inventory_Consumption__c();
    uc.Consumed_Quantity__c=5;
    uc.Reserve_Quantity__c=10;
    uc.Project__c=prg.id;
    insert uc;
    system.assertEquals(uc.Reserve_Quantity__c,10);
    
     
 Test.stopTest();
}
}