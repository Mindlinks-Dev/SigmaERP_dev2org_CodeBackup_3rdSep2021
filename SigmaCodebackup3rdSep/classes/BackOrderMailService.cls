Public with sharing class BackOrderMailService{
  public static Boolean notifyBackOrderStockAvailable(Map<Id,Decimal> prodIdSRPQuantMap,string flag){
  Boolean backOrderPresentFlag=false;  
  /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__BackOrder__c') &&
  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__BackOrder__c',new set<String>{'id','sigmaerpdev2__Email__c'}) &&
  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c')&&
  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'id','name','sigmaerpdev2__Cost__c','sigmaerpdev2__Product__c','sigmaerpdev2__Stock_Fulfilled__c','sigmaerpdev2__Product__r.name','sigmaerpdev2__IsInventoryUpdated__c','sigmaerpdev2__Order_Status__c','sigmaerpdev2__Sigma_Order__r.sigmaerpdev2__Auto_Allocate__c','sigmaerpdev2__Sigma_Order__r.Customer_Type__c','sigmaerpdev2__Sigma_Order__r.Order_Created_Via__c' ,'sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__Sigma_Order__r.name','createddate','sigmaerpdev2__Sigma_Order__r.AccountId__c','sigmaerpdev2__Sigma_Order__r.AccountId__r.name','sigmaerpdev2__Total_Price__c','sigmaerpdev2__Back_Order__c','Sigma_Order__r.sigmaerpdev2__No_Picking_Package_Shipment_Required__c' })&&
   CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev2__Sigma_Order__c'})&&
  CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')&&
  CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'id','Product2Id','Product2.name','Order.Account.name','OrderId','sigmaerpdev2__Stock_Fulfilled__c','sigmaerpdev2__IsInventoryUpdated__c','sigmaerpdev2__Order_Status__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Back_Order__c','OrderItemNumber','Quantity','Order.sigmaerpdev2__Auto_Allocate__c','Order.sigmaerpdev2__Customer_Type__c','Order.sigmaerpdev2__Order_Created_Via__c','Order.name','Order.sigmaerpdev2__No_Picking_Package_Shipment_Required__c'})&&
  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev2__Stock_Fulfilled__c'})&&
  CRUD_FLS_CheckUtility.checkFLS('OrderItem',new set<String>{'sigmaerpdev2__Stock_Fulfilled__c'})&&
  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Allocate_Stock_MR__c')&&
  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Allocate_Stock_MR__c',new set<String>{'sigmaerpdev2__Allocate_Back_Order_Quantity__c'})
  ){*/
    Map<Id,String> prodIdProdNameMap=new Map<Id,String>();
	Map<Id,Decimal> prodInventMap=new Map<Id,Decimal>();
    BackOrder__c config=[select id, Email__c from BackOrder__c limit 10 ];
	List<Inventory__c>PI = [Select Id,Available_Qty__c,ProductCode__c from Inventory__c where ProductCode__c=:prodIdSRPQuantMap.keyset()];
    for(Inventory__c invent:PI)
	{
		prodInventMap.put(invent.ProductCode__c,invent.Available_Qty__c);
	}
	
	String mailBody = '<table border="1"><tr><th>Order Number</th><th>Customer Name</th><th>Product Name</th><th>Ordered Quantity</th><th>Order Date</th></tr>';
     
    String prodQuantList='';
    List<Product_Order_Price_Book__c>solDataToupdatelist = new List<Product_Order_Price_Book__c>();
    List<Product_Order_Price_Book__c>solDataToSave = new List<Product_Order_Price_Book__c>();
    List<Product_Order_Price_Book__c>soldata =[select id,name,Cost__c,Product__c,Stock_Fulfilled__c,Product__r.name,IsInventoryUpdated__c,Order_Status__c,Sigma_Order__r.Auto_Allocate__c,Sigma_Order__r.Customer_Type__c,Sigma_Order__r.Order_Created_Via__c,Net_Quantity__c,Sigma_Order__c,Sigma_Order__r.name,createddate,Sigma_Order__r.AccountId__c,Sigma_Order__r.AccountId__r.name,Total_Price__c,Back_Order__c,Sigma_Order__r.No_Picking_Package_Shipment_Required__c,Inventory_Status__c from Product_Order_Price_Book__c where Product__c in :prodIdSRPQuantMap.keyset() and Back_Order__c=true and IsInventoryUpdated__c = false and Order_Status__c!='Canceled' and Stock_Fulfilled__c =false order by CreatedDate ASC];
    system.debug('soldata>>'+soldata);
    List<OrderItem>  orderline =[select id,Product2Id,Product2.name,Order.Account.name,OrderId,Stock_Fulfilled__c,IsInventoryUpdated__c,Order_Status__c,Net_Quantity__c,Back_Order__c,OrderItemNumber,Quantity,Order.Auto_Allocate__c,Order.Customer_Type__c,Order.Order_Created_Via__c,Order.name,Order.No_Picking_Package_Shipment_Required__c,Inventory_Status__c from OrderItem where Product2Id in:prodIdSRPQuantMap.keyset() and Back_Order__c=true and IsInventoryUpdated__c = false and Order_Status__c !='Canceled' and Stock_Fulfilled__c =false  order by CreatedDate ASC];
   system.debug('orderline@@'+orderline);
      List<OrderItem>  standardorderline = new List<OrderItem>(); 
    
     
    if(soldata.size()>0)
    {
        for(Product_Order_Price_Book__c sol:soldata)
        {
             sol.Stock_Fulfilled__c =true;
      if(prodInventMap.size()>0){
          
        prodIdProdNameMap.put(sol.Product__c,sol.Product__r.name);
        mailBody += '<tr><td>'+sol.Sigma_Order__r.name+'</td><td>'+sol.Sigma_Order__r.AccountId__r.name+'</td><td>'+sol.Product__r.name+'</td><td>'+sol.Net_Quantity__c+'</td><td>'+sol.createddate;
        backOrderPresentFlag=true;
        if(prodInventMap.containskey(sol.Product__c) && prodInventMap.get(sol.Product__c) >= sol.Net_Quantity__c)
        {
          solDataToSave.add(sol);  
          if((sol.Sigma_Order__r.Auto_Allocate__c ==true && sol.Order_Status__c == 'Order Confirmed') || (sol.Inventory_Status__c =='Allocated' && sol.Order_Status__c == 'Order Confirmed'))
          {
            solDataToupdatelist.add(sol);
          }
         
          prodInventMap.put(sol.Product__c,(prodInventMap.get(sol.Product__c)-sol.Net_Quantity__c));
          
        }
        for(id prodId:prodInventMap.keyset())
          prodQuantList+=prodIdProdNameMap.get(prodId)+' --> '+prodInventMap.get(prodId)+'<br/>';
      }
        }
        if(soldata.size()>0)
        update soldata;
        system.debug('soldata>>'+soldata);
    }
      //code for standard order backorder quantity notify
    if(orderline.size()>0)
    {
        for(OrderItem orderlineitem :orderline)
        {
      if(prodInventMap.size()>0){
                system.debug('in@@');
        prodIdProdNameMap.put(orderlineitem.Product2Id,orderlineitem.Product2.name);
        mailBody += '<tr><td>'+orderlineitem.Order.name+'</td><td>'+orderlineitem.Order.Account.name+'</td><td>'+orderlineitem.Product2.name+'</td><td>'+orderlineitem.Quantity;
        backOrderPresentFlag=true;
       
        if(prodInventMap.containskey(orderlineitem.Product2Id) && prodInventMap.get(orderlineitem.Product2Id) >= orderlineitem.Quantity) 
        {
                    
          if(orderlineitem.Order.Auto_Allocate__c ==true && orderlineitem.Order_Status__c == 'Order Confirmed')
          {
            standardorderline.add(orderlineitem);
          }
          orderlineitem.Stock_Fulfilled__c =true;
          prodInventMap.put(orderlineitem.Product2Id,(prodInventMap.get(orderlineitem.Product2Id)-orderlineitem.Quantity));
        }
        
      }
    }
        system.debug('standardorderline@@'+standardorderline);
        update orderline;
    }
    if(backOrderPresentFlag)
    {
        String completeMailBody='<html>Dear Support,<br/><br/>New stock is available for the following Back Order Products.<br/><br/>'+mailBody+'</table><br/><br/><br/>Regards,<br/>Mindlinks Solution.</html>';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();     
        mail.setToAddresses(new List<String>{config.Email__c}); 
        mail.setSubject('Back Order Product');
        mail.setHTMLBody(completeMailBody);
        mail.setSaveAsActivity(false);  
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
      //fetch auto allocate backorder custom setting 
      Allocate_Stock_MR__c backorder =[select Allocate_Back_Order_Quantity__c from Allocate_Stock_MR__c limit 1];
      
      if(backorder.Allocate_Back_Order_Quantity__c)
      {
        if(solDataToSave.size()>0 && flag =='MR')
        {
          autostockreservation.autostockreserve(solDataToSave);
        }
      }
      if(solDataToupdatelist.size()>0 && flag =='SR')
      {
        autostockreservation.autostockreserve(solDataToupdatelist);
      }
      if(standardorderline.size()>0 && flag =='SR')
      {
        autostockreservation.autostockreserveforOrder(standardorderline);
      }
    //}
   return backOrderPresentFlag;
  }
    
  }