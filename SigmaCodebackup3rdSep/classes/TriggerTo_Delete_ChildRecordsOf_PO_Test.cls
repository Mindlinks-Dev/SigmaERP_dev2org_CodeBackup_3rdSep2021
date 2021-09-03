/*------------------------------------------------------------
    Company: Mindlinks Solution
    Module Name : Inventory History
    Description: A Test Class for the class TriggerTo_Delete_ChildRecordsOf_P0
    Author :<Banu Prakash>  
    Elift version 1.0 
    since :Winter 17 Force.com IDE, API version "38.0"
   Date : 10-01-2017
  ------------------------------------------------------------*/


@isTest
public class TriggerTo_Delete_ChildRecordsOf_PO_Test
{       
    @isTest(SeeAllData=false)
      static void test() 
      {
        Test.startTest();
        Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        String RID2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
            
        Account acc1 = new Account();
        acc1.name ='xyz';
        acc1.Type='Merchant';
        acc1.RecordTypeID =RID2  ;
        acc1.Email__c='abcd@gmail.com';
        insert acc1;
        System.assertequals(acc1.Type,'Merchant');
        
        Account  acc=new Account();
        acc.Name='Testvendor';
        acc.Type='vendor';
        acc.Email__c='abcd@gmail.com';
        acc.RecordTypeID =RID2  ;
        insert acc;
        System.assertequals(acc.Type,'vendor');
    
        Default_Parameters__c DP = new Default_Parameters__c();
        DP.name ='test';
        DP.Parent_Id__c = acc1.Id;
        DP.POId__c ='/a0h/o'; 
        insert DP;
        System.assertequals(DP.name,'test');
    
        Product2  pro=new  Product2();
        pro.Name='JMTEST';
        pro.Attribute_Type__c = 'SERIALIZED';
        insert pro;
     System.assertequals(pro.Name,'JMTEST');
     
        Vendor_Product__c VP = new Vendor_Product__c();
        VP.Account_Name__c = acc.Id;
        VP.Product_Name__c = pro.Id;
        vp.Buying_Price__c = 200;
        vp.Is_Preferred__c=true;
        insert VP;
        System.assertequals(VP.Account_Name__c,acc.Id);
        
        Purchase_Order__c po = new Purchase_Order__c(); 
        PO.Product_Supplier__c = acc.Id;
        PO.Status__c = 'Open';
        PO.Order_Date__c = Date.today();
        insert po;
        System.assertequals(po.Status__c,'Open');
        
        List<Purchase_Order_Product__c> POP = new List<Purchase_Order_Product__c>(); 
        Purchase_Order_Product__c POindiv = new Purchase_Order_Product__c();
        POindiv.Product__c = pro.Id;
        POindiv.Quantity__c ='10';
        POindiv.Status__c = 'Open';
        POindiv.Purchase_Order__c = PO.Id;
        POP.add(POindiv);
        insert POP;
        System.assertequals(POindiv.Status__c,'Open');
        
        try 
        {  
         delete po;  
         System.Assert(true, 'POP successfully deleted upon deletion of respective PO');  
        }
         catch(DMLException e)
         {  
          System.assert(false, 'Deletion failed ');
         }
         Test.stopTest();
      }
 }