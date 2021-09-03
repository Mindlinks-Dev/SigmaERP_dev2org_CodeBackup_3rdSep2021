@isTest
public class CreateInventoryConversionHelperTest {
    @IsTest(seeAllData=false)
    public static void Test(){
    
    Account Ven= new Account();
        Ven.Name = 'Test Vendor';
        Ven.ShippingStreet = 'Test Street';
        Ven.ShippingCity = 'Test City';
        Ven.ShippingState = 'Test State';
        Ven.ShippingPostalCode = 'Test Code'; 
        Ven.Address__c ='Address';  
        Ven.ShippingCountry  = 'Test Country';
        Ven.Email__c = 'customer@gmail.com';
        Ven.RecordTypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId(); 
        insert Ven; 
        System.assertEquals(Ven.ShippingCity , 'Test City');
    
    Account loc= new Account();
        loc.Name = 'Test Location';
        loc.ShippingStreet = 'Street';
        loc.ShippingCity = 'City';
        loc.ShippingState = 'State';
        loc.ShippingPostalCode = 'Code'; 
        loc.Address__c ='Address1';  
        loc.ShippingCountry  = 'Country';
        loc.RecordTypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();   
        insert loc; 
        System.assertEquals( loc.Address__c ,'Address1');
    
     Default_Parameters__c dfp=new Default_Parameters__c();
         dfp.Default_Vendor__c=true;
         dfp.Company_Name__c='mindlinks';
         dfp.Inventory_Status__c='recieved';
         dfp.Name='Default';
         insert dfp;
         System.assertEquals(dfp.Inventory_Status__c,'recieved');
    
    Product2 pd2=new Product2();
pd2.IsActive=true;
pd2.Attribute_Type__c='BULK';
pd2.Name='po-01';
insert pd2;
System.assertEquals(pd2.Attribute_Type__c,'BULK');

Inventory_Location__c il=new Inventory_Location__c();
il.Actual_Quantity__c=20;
il.Available_Quantity__c=10;
il.Location__c=loc.id;
insert il;
System.assertEquals(il.Available_Quantity__c,10);

Purchase_Order__c po=new Purchase_Order__c();
po.Approved__c=true;
po.Expected_Delivery_Date__c=System.today();
po.Product_Supplier__c=ven.id;
insert po;
System.assertEquals(po.Product_Supplier__c,ven.id);


Project2__c p=new Project2__c();
p.Status__c='Open';
p.Template__c=true;
p.Total_Expenditure__c=4000;
p.Expenditure_Record_Count__c=1000;
insert p;
System.assertEquals(p.Total_Expenditure__c,4000);

Expenditure__c exp=new Expenditure__c();
exp.Project__c=p.id;
exp.Travel_Expenditure__c=16;
insert exp;
System.assertEquals(exp.Travel_Expenditure__c,16);


    
    Inventory_Consumption__c ic=new Inventory_Consumption__c();
    ic.Reserve_Quantity__c=10;
    ic.Product__c=pd2.id;
    ic.Project__c=p.id;
     ic.Consumed_Quantity__c=2;
    
    insert ic;
    System.assertEquals(ic.Reserve_Quantity__c,10);
    
    Inventory_Location_Product_Line_Item__c ilpli=new Inventory_Location_Product_Line_Item__c();
    ilpli.Allocated_Quantity__c=29;
    ilpli.Inventory_Location__c=il.id;
    ilpli.Product__c=pd2.id;
    ilpli.Purchase_Order__c=po.id;
    insert ilpli;
    System.assertEquals(ilpli.Allocated_Quantity__c,29);
    
    
    Inventory_Location_Product__c ilp=new Inventory_Location_Product__c();
    ilp.Inventory_Location__c=il.id;
    ilp.Products__c=pd2.id;   
    ilp.Start_Date__c=System.today();
    insert ilp;
    System.assertEquals(ilp.Products__c,pd2.id);
    
    List<Inventory_Consumption__c> ic1=new List<Inventory_Consumption__c>();
    ic1.add(ic);
    List<Id> ilpIds=new List<Id>();
    ilpIds.add(ilp.id);
    List<Id>  pro=new List<Id>();
    pro.add(p.id);
    Map<Id,Decimal> IlpliQty=new Map<Id,Decimal>();
    IlpliQty.put(ilp.id,20);
    IlpliQty.put(pd2.id,1);
    Map<Id,Decimal> reserveQty=new Map<Id,Decimal>();
    reserveQty.put(ic.id,20.00);
    reserveQty.put(pd2.id,20);
    
    Test.startTest(); 
    CreateInventoryConversionHelper.getMapOfQty2(ic1,'CONSUME');
    CreateInventoryConversionHelper.getMapOfQty(ic1,'CONSUME');
     CreateInventoryConversionHelper.getMapOfQty2(ic1,'RESERVE');
    CreateInventoryConversionHelper.getMapOfQty(ic1,'RESERVE');
    CreateInventoryConversionHelper.getMapOfIds(ilpIds,pro,IlpliQty,reserveQty,'RESERVECONSUME');
    Test.stopTest();
    }
    }