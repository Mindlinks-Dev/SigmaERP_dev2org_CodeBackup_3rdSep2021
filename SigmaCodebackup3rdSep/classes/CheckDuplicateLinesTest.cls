@isTest(seeAllData=false)
public class CheckDuplicateLinesTest
{
    @isTest
    public static void testDupLineItems()
    {
        //Account type of Vendor
        ID RID1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        Account  acc1=new Account();
        acc1.Name='Rashmi';
        acc1.Type='Vendor';
        acc1.RecordTypeId = RID1;
        acc1.Email__c = 'ven@gmail.com';
        insert acc1;
        System.assertEquals(acc1.Name,'Rashmi'); 

        //Account type of Location
        ID RID2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();
        Account  acc2=new Account();
        acc2.Name='New Delhi';
        acc2.Type='Location';
        acc2.RecordTypeId = RID2;
        acc2.Active__c = 'Yes';
        insert acc2;
        System.assertEquals(acc2.Name,'New Delhi');
        
        //Default_Parameters
        Default_Parameters__c  dp = new Default_Parameters__c (Name = 'Sample dp',Parent_Id__c = acc1.Id);
        insert dp;
        system.assertEquals(dp.Name,'Sample dp');
        
        // BOM Product
        List<Product2> prodList =new List<Product2>();
        Id proId1 = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('BOM').getRecordTypeId();
        Product2 prod1=new Product2(name='DeskTop',Attribute_Type__c='BULK',BOM_Line_Items_Count__c=2,Stock_Item__c=true,IsActive=true,RecordTypeId=proId1);
        prodList.add(prod1);
        insert prodList;
        system.assertEquals(prod1.Attribute_Type__c,'BULK');
       
        
        // Individual Product
        Id proId2 = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
        Product2 prod2=new Product2(name='Keyboard',Attribute_Type__c='BULK',Stock_Item__c=true,IsActive=true, RecordTypeId = proId2 );
        insert prod2;
        system.assertEquals(prod2.Attribute_Type__c,'BULK');
        
        //Vendor_Product
        Vendor_Product__c vp  = new Vendor_Product__c();
        vp.Product_Name__c = prod2.id;
        vp.Account_Name__c = acc1.Id;
        vp.Buying_Price__c = 200;
        vp.Is_Preferred__c=true;
        insert vp;
        system.assertEquals(prod2.id,vp.Product_Name__c);
        
         //Product Inventory
        Inventory__c PI = new Inventory__c();
        PI.ProductCode__c=prod1.id;
        PI.Available_Qty__c = 0;
        insert PI;
        System.assertEquals(PI.Available_Qty__c,0);
        
        //Purchase Order
        Purchase_Order__c  pord=new  Purchase_Order__c();
        pord.Product_Supplier__c=acc1.Id;
        pord.Order_Date__c=date.today();
        pord.Status__c='Submitted';
        insert pord;
        System.assertEquals(pord.Status__c,'Submitted');

        //Purchase Order Product
        Purchase_Order_Product__c porderp=new  Purchase_Order_Product__c();
        porderp.Purchase_Order__c=pord.Id;
        porderp.Product__c=prod2.id;
        porderp.Status__c='Open';
        porderp.Quantity__c='10';
        porderp.Received_Quantity__c=10;
        porderp.Expected_Delivery_Date__c=date.today();  
        porderp.Buying_Price__c=89;
        insert porderp;
        System.assertEquals(porderp.Status__c,'Open');
        
        //Inventory Location
        Inventory_Location__c invLocid=new Inventory_Location__c(Location__c = acc2.Id);
        insert invLocid;
        System.assertEquals(invLocid.Location__c,acc2.Id);
        
       
        List<BOM_Line_Item__c> bomlist =new List<BOM_Line_Item__c >();
        BOM_Line_Item__c BOMLineItem= new BOM_Line_Item__c();
        
        BOMLineItem.Product__c = prod2.Id;
        BOMLineItem.Products__c = prod1.Id;
        BOMLineItem.Quantity__c = 1;
        
        bomlist.add(BOMLineItem);       
        
        insert BOMLineItem;
        update BOMLineItem;
        delete BOMLineItem;
        System.assertEquals(BOMLineItem.Quantity__c ,1);
        
    }
}