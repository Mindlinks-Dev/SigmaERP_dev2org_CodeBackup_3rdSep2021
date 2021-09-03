@isTest
public class HandleCurrencyTest{
@isTest(SeeAllData=false)
    public static void test(){
        
        Currency__c c=new Currency__c();
        c.Name='IL-0224';
        c.Is_Default_Currency__c=true;
         insert c;
         system.assertEquals(c.Is_Default_Currency__c,true);
         
         List<Currency__c> currencies=new List<Currency__c>();  
           currencies.add(c);    
          Test.startTest();
          
          HandleCurrency curr=new HandleCurrency();
          
          curr.onBeforeInsert(currencies);
          Test.stopTest();    
    }
    @isTest(SeeAllData=false)
    public static void test1(){
        
        Currency__c c1=new Currency__c();
        c1.Name='USD Dollar';
        c1.Symbol__c='';
        c1.Is_Default_Currency__c=true;
        c1.Currency_Code__c='qwe';
         insert c1;
         update c1;
         system.assertEquals(c1.Is_Default_Currency__c,true);
         List<Currency__c> currencies1=new List<Currency__c>();  
            currencies1.add(c1);   
          Test.startTest();
          
          HandleCurrency curr=new HandleCurrency();
          
          Test.stopTest();    
    }
    
}