/*=====================================================================================================
Author     : Pooja Kote
Company    : Mindlinks Solution Pvt Ltd.
Date       : 30 Jul 2018
Description: temperary class used by useanddelete visualforce page
=======================================================================================================*/

global with sharing class UseAndDeleteClass  
{

    public PageReference todeletesm() {
        return null;
    }

    public String batchid{get;set;}
    public Integer size{get;set;}
    public void toschedule()
    {
        BatchClassforUpdateRecords be = new BatchClassforUpdateRecords();
        String batchid= database.executeBatch(be,1);
        system.debug('batchid:'+batchid);
    }
    
    public void todeletevendor()
    {
        List<sigmaerpdev2__Vendor_Product__c> a = new List<sigmaerpdev2__Vendor_Product__c>();
        a = [select id from     sigmaerpdev2__Vendor_Product__c];
        size = a.size();
        delete a;
    }
    
    public void todeleteproduct()
    {
        List<Product2> a = new List< Product2>();
        a = [select id from  Product2];
        size = a.size();
        delete a;
    }
    
    public void todeleteilpli()
    {
        List<sigmaerpdev2__Inventory_Location_Product_Line_Item__c> a = new List<sigmaerpdev2__Inventory_Location_Product_Line_Item__c>();
        a = [select id from sigmaerpdev2__Inventory_Location_Product_Line_Item__c];
        size = a.size();
        delete a;
    }
    
    public void todeleteilp()
    {
        List<sigmaerpdev2__Inventory_Location_Product__c> a = new List<sigmaerpdev2__Inventory_Location_Product__c>();
        a = [select id from sigmaerpdev2__Inventory_Location_Product__c];
        size = a.size();
        delete a;
    }
    public void todeleteilphistory()
    {
        List<sigmaerpdev2__Inventory_Location_Product_History__c> a = new List<sigmaerpdev2__Inventory_Location_Product_History__c>();
        a = [select id from sigmaerpdev2__Inventory_Location_Product_History__c];
        size = a.size();
        delete a;
    }
    public void todeleteinventorytrans()
    {
        List<sigmaerpdev2__Inventory_Transaction__c> a = new List<sigmaerpdev2__Inventory_Transaction__c>();
        a = [select id from sigmaerpdev2__Inventory_Transaction__c];
        size = a.size();
        delete a;
    }
    
    public void todeletesrpli()
    {
        List<sigmaerpdev2__Stock_Receiving_Product_Line_Item__c> a = new List<sigmaerpdev2__Stock_Receiving_Product_Line_Item__c>();
        a = [select id from sigmaerpdev2__Stock_Receiving_Product_Line_Item__c];
        size = a.size();
        delete a;
    }
    
    public void todeletesr()
    {
        List<sigmaerpdev2__Stock_In__c> a = new List<sigmaerpdev2__Stock_In__c>();
        a = [select id from sigmaerpdev2__Stock_In__c];
        size = a.size();
        delete a;
    }
    
    public void todeletesrp()
    {
        List<sigmaerpdev2__Stock_In_Product__c> a = new List<sigmaerpdev2__Stock_In_Product__c>();
        a = [select id from sigmaerpdev2__Stock_In_Product__c];
        size = a.size();
        delete a;
    }
    
    public void todeletesmp()
    {
        List<sigmaerpdev2__Stock_Moment_Product__c> a = new List<sigmaerpdev2__Stock_Moment_Product__c>();
        a = [select id from sigmaerpdev2__Stock_Moment_Product__c];
        size = a.size();
        delete a;
    }
    
    
    public void todeletesa()
    {
        List<sigmaerpdev2__StockAdjustment__c> a = new List<sigmaerpdev2__StockAdjustment__c>();
        a = [select id from sigmaerpdev2__StockAdjustment__c];
        size = a.size();
        delete a;
    }
    
    public void todeleteshipment()
    {
        List<sigmaerpdev2__Shipment__c> a = new List<sigmaerpdev2__Shipment__c>();
        a = [select id from sigmaerpdev2__Shipment__c];
        size = a.size();
        delete a;
    }
    
    public void todeletesoa()
    {
        List<sigmaerpdev2__Sales_Order_Allocation__c> a = new List<sigmaerpdev2__Sales_Order_Allocation__c>();
        a = [select id from sigmaerpdev2__Sales_Order_Allocation__c];
        size = a.size();
        delete a;
    }
    public void todeleteso()
    {
        List<sigmaerpdev2__Sigma_Order__c> a = new List<sigmaerpdev2__Sigma_Order__c>();
        a = [select id from sigmaerpdev2__Sigma_Order__c];
        size = a.size();
        delete a;
    }
    
    public void todeletesl()
    {
        List<sigmaerpdev2__Sigma_Linkage__c> a = new List<sigmaerpdev2__Sigma_Linkage__c>();
        a = [select id from sigmaerpdev2__Sigma_Linkage__c];
        size = a.size();
        delete a;
    }
    
    public void todeletepo()
    {
        List<sigmaerpdev2__Purchase_Order__c> a = new List<sigmaerpdev2__Purchase_Order__c>();
        a = [select id from sigmaerpdev2__Purchase_Order__c];
        size = a.size();
        delete a;
    }
    public void todeletept()
    {
        List<sigmaerpdev2__Product_Transaction__c> a = new List<sigmaerpdev2__Product_Transaction__c>();
        a = [select id from sigmaerpdev2__Product_Transaction__c];
        size = a.size();
        delete a;
    }
    public void todeletepsn()
    {
        List<sigmaerpdev2__Product_Serial_Number__c> a = new List<sigmaerpdev2__Product_Serial_Number__c>();
        a = [select id from sigmaerpdev2__Product_Serial_Number__c];
        size = a.size();
        delete a;
    }
    public void todeleteprodprice()
    {
        List<sigmaerpdev2__Product_Price__c> a = new List<sigmaerpdev2__Product_Price__c>();
        a = [select id from sigmaerpdev2__Product_Price__c];
        size = a.size();
        delete a;
    }
    public void todeleteprodinvhist()
    {
        List<sigmaerpdev2__Product_Inventory_History__c> a = new List<sigmaerpdev2__Product_Inventory_History__c>();
        a = [select id from sigmaerpdev2__Product_Inventory_History__c];
        size = a.size();
        delete a;
    }
    public void todeleteprodinv()
    {
        List<sigmaerpdev2__Inventory__c> a = new List<sigmaerpdev2__Inventory__c>();
        a = [select id from sigmaerpdev2__Inventory__c];
        size = a.size();
        delete a;
    }
    public void todeletepp()
    {
        List<sigmaerpdev2__PackagedProducts__c> a = new List<sigmaerpdev2__PackagedProducts__c>();
        a = [select id from sigmaerpdev2__PackagedProducts__c];
        size = a.size();
        delete a;
    }
    public void todeletepackage()
    {
        List<sigmaerpdev2__Package__c> a = new List<sigmaerpdev2__Package__c>();
        a = [select id from sigmaerpdev2__Package__c];
        size = a.size();
        delete a;
    }
    public void todeletelotprod()
    {
        List<sigmaerpdev2__Lot_Product__c> a = new List<sigmaerpdev2__Lot_Product__c>();
        a = [select id from sigmaerpdev2__Lot_Product__c];
        size = a.size();
        delete a;
    }
    public void todeletelot()
    {
        List<sigmaerpdev2__Lot__c> a = new List<sigmaerpdev2__Lot__c>();
        a = [select id from sigmaerpdev2__Lot__c];
        size = a.size();
        delete a;
    }
    public void todeletesublineitem()
    {
        List<sigmaerpdev2__Subscription_Line_Item__c> a = new List<sigmaerpdev2__Subscription_Line_Item__c>();
        a = [select id from sigmaerpdev2__Subscription_Line_Item__c];
        size = a.size();
        delete a;
    }
    public void todeletesub()
    {
        List<sigmaerpdev2__SubscriptionDetail__c> a = new List<sigmaerpdev2__SubscriptionDetail__c>();
        a = [select id from sigmaerpdev2__SubscriptionDetail__c];
        size = a.size();
        delete a;
    }
    public void todeleteaccsubinter()
    {
        List<sigmaerpdev2__Account_Subscription_Intervals__c> a = new List<sigmaerpdev2__Account_Subscription_Intervals__c>();
        a = [select id from sigmaerpdev2__Account_Subscription_Intervals__c];
        size = a.size();
        delete a;
    }
    public void todeleteaccsub()
    {
        List<sigmaerpdev2__Account_Subscription__c> a = new List<sigmaerpdev2__Account_Subscription__c>();
        a = [select id from sigmaerpdev2__Account_Subscription__c];
        size = a.size();
        delete a;
    }
    
         public void todeleteproductstock()
    {
        List<sigmaerpdev2__Product_Stock__c> a = new List<sigmaerpdev2__Product_Stock__c>();
        a = [select id from sigmaerpdev2__Product_Stock__c];
        size = a.size();
        delete a;
    }
    
    
      public void todeleteinvoice()
    {
        List<sigmaerpdev2__Invoice__c> a = new List<sigmaerpdev2__Invoice__c>();
        a = [select id from sigmaerpdev2__Invoice__c];
        size = a.size();
        delete a;
    }
    
      public void todeletewo()
    {
        List<sigmaerpdev2__Work_Order__c> a = new List<sigmaerpdev2__Work_Order__c>();
        a = [select id from sigmaerpdev2__Work_Order__c];
        size = a.size();
        delete a;
    }
    
       public void todeletewoassign()
    {
        List<sigmaerpdev2__Work_Order_Assignment__c> a = new List<sigmaerpdev2__Work_Order_Assignment__c >();
        a = [select id from sigmaerpdev2__Work_Order_Assignment__c];
        size = a.size();
        delete a;
    }
    
        public void todeletewoinvtrack()
    {
        List<sigmaerpdev2__Work_Order_Inventory_Track__c> a = new List<sigmaerpdev2__Work_Order_Inventory_Track__c>();
        a = [select id from sigmaerpdev2__Work_Order_Inventory_Track__c];
        size = a.size();
        delete a;
    }
    
         public void todeletewolines()
    {
        List<sigmaerpdev2__Work_Oder_Lines__c> a = new List<sigmaerpdev2__Work_Oder_Lines__c>();
        a = [select id from sigmaerpdev2__Work_Oder_Lines__c];
        size = a.size();
        delete a;
    }
    
          public void todeleteworktype()
    {
        List<sigmaerpdev2__Work_Type__c> a = new List<sigmaerpdev2__Work_Type__c>();
        a = [select id from sigmaerpdev2__Work_Type__c];
        size = a.size();
        delete a;
    }
    
          public void todeleteworktypebinding()
    {
        List<sigmaerpdev2__Work_T__c> a = new List<sigmaerpdev2__Work_T__c>();
        a = [select id from sigmaerpdev2__Work_T__c];
        size = a.size();
        delete a;
    }
    
      public void todeleteproductrequest()
    {
        List<sigmaerpdev2__Product_Request__c> a = new List<sigmaerpdev2__Product_Request__c>();
        a = [select id from sigmaerpdev2__Product_Request__c];
        size = a.size();
        delete a;
    }
       public void todeleteproductrequestlineitem()
    {
        List<sigmaerpdev2__Product_Request_Line_Item__c> a = new List<sigmaerpdev2__Product_Request_Line_Item__c>();
        a = [select id from sigmaerpdev2__Product_Request_Line_Item__c];
        size = a.size();
        delete a;
    }

     public void todeleteproducttransfer()
    {
        List<sigmaerpdev2__Product_transfer__c> a = new List<sigmaerpdev2__Product_transfer__c>();
        a = [select id from sigmaerpdev2__Product_transfer__c];
        size = a.size();
        delete a;
    }
     public void todeleteproducttransferlineitem()
    {
        List<sigmaerpdev2__Product_Transfer_Inventory_Tracking__c> a = new List<sigmaerpdev2__Product_Transfer_Inventory_Tracking__c>();
        a = [select id from sigmaerpdev2__Product_Transfer_Inventory_Tracking__c];
        size = a.size();
        delete a;
    }
    public void todeleteservicequote()
    {
        List<sigmaerpdev2__Service_Quote__c> a = new List<sigmaerpdev2__Service_Quote__c>();
        a = [select id from sigmaerpdev2__Service_Quote__c];
        size = a.size();
        delete a;
    }
    public void todeleteservicequotelineitem()
    {
        List<sigmaerpdev2__Service_Quote_Line_Item__c> a = new List<sigmaerpdev2__Service_Quote_Line_Item__c>();
        a = [select id from sigmaerpdev2__Service_Quote_Line_Item__c];
        size = a.size();
        delete a;
    }
     public void todeletepayment()
    {
        List<sigmaerpdev2__Payment__c> a = new List<sigmaerpdev2__Payment__c>();
        a = [select id from sigmaerpdev2__Payment__c];
        size = a.size();
        delete a;
    }
     public void todeletepickingslip()
    {
        List<sigmaerpdev2__Picking_Slip__c> a = new List<sigmaerpdev2__Picking_Slip__c>();
        a = [select id from sigmaerpdev2__Picking_Slip__c];
        size = a.size();
        delete a;
    }
     public void todeleteorder()
    {
        List<Order> a = new List<Order>();
        a = [select id from Order];
        size = a.size();
        delete a;
    }
     public void todeleteorderline()
    {
        List<sigmaerpdev2__Product_Order_Price_Book__c> a = new List<sigmaerpdev2__Product_Order_Price_Book__c>();
        a = [select id from sigmaerpdev2__Product_Order_Price_Book__c];
        size = a.size();
        delete a;
    }
    public void todeleteorderpayment()
    {
        List<sigmaerpdev2__Order_Payment__c> a = new List<sigmaerpdev2__Order_Payment__c>();
        a = [select id from sigmaerpdev2__Order_Payment__c];
        size = a.size();
        delete a;
    }
    public void todeleteproductneeded()
    {
        List<sigmaerpdev2__Products_Needed__c> a = new List<sigmaerpdev2__Products_Needed__c>();
        a = [select id from sigmaerpdev2__Products_Needed__c];
        size = a.size();
        delete a;
    }
    public void todeletevendorevaluation()
    {
        List<sigmaerpdev2__Vendor_Evaluation__c> a = new List<sigmaerpdev2__Vendor_Evaluation__c>();
        a = [select id from sigmaerpdev2__Vendor_Evaluation__c];
        size = a.size();
        delete a;
    }
    public void todeletevendoreincidence()
    {
        List<sigmaerpdev2__Vendor_Incidence__c> a = new List<sigmaerpdev2__Vendor_Incidence__c>();
        a = [select id from sigmaerpdev2__Vendor_Incidence__c];
        size = a.size();
        delete a;
    }
    public void todeleteinventoryallocation()
    {
        List<sigmaerpdev2__Inventory_Allocation__c> a = new List<sigmaerpdev2__Inventory_Allocation__c>();
        a = [select id from sigmaerpdev2__Inventory_Allocation__c];
        size = a.size();
        delete a;
    }
    public void todeletepricebook()
    {
        List<Pricebook2> a = new List<Pricebook2>();
        a = [select id from Pricebook2];
        size = a.size();
        delete a;
    }



}