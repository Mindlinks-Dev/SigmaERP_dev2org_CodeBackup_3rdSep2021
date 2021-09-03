/* Helper class for all Triggers */
/*------------------------------------------------------------
Author: <Authors Name>
Company: Mindlinks Solution
Description: A utility class for the Helper class for all Triggers 
Inputs: "PackagedProducts " - PackagedProducts  objects that are being triggered
"PackagedProducts" - PackagedProducts  object values 


Test Class: CustomLookupStockInTest
History
<Date>         <Authors Name>   <Brief Description of Change>

25-10-2016     javed&anil            Added FLS & CRUD Check.
------------------------------------------------------------*/
public with sharing class TriggerHandler
{
    public static String isBOMtoIndvidual=null;
    public static String isIndvidualtoBOM=null;
    public static boolean quoteRecursion;
    public static boolean isManualILP = false;
    static 
    {
        quoteRecursion = false;
    }
    
    static Integer count=0;
    
    
    public boolean manageInventories(List<Sigma_Order__c> newOrders)
    {   
        String tempproduct='';
        Integer tempQuantity=0;
        Map<String,Integer> productQuantityMap=new Map<String,Integer>(); 
        List<String> productIds=new List<String>();
        Integer i=1;
        Integer j=0;
        Integer orderQuantity = 0;
        
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new Set<String>{'Id','name'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new Set<String>{'Id','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'name','Id','sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Web_Available_Qty__c','sigmaerpdev2__Purchased_Qty__c','sigmaerpdev2__ProductCode__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new Set<String>{'sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Web_Available_Qty__c','sigmaerpdev2__Purchased_Qty__c','sigmaerpdev2__ProductCode__c','sigmaerpdev2__Comments__c'})      
          )
        {*/
            List<Sigma_Order__c> newOrderData;
            
            newOrderData =  [SELECT id,name,(SELECT id,Product__c,Quantity__c FROM Order_Lines__r) FROM Sigma_Order__c WHERE id=:newOrders[0].id];
            
            
            for(Sigma_Order__c productOrderData :newOrderData)
            {
                for(Product_Order_Price_Book__c productOrder : productOrderData.Order_Lines__r){
                    
                    tempproduct= productOrder.Product__c;
                    orderQuantity = Integer.valueOf(productOrder.Quantity__c);
                    if(orderQuantity == null){
                        orderQuantity = 0;
                    }
                    
                    tempQuantity=orderQuantity+tempQuantity;
                    productQuantityMap.put(tempproduct,tempQuantity);
                    productIds.add(tempproduct);
                    tempQuantity=0;
                    
                }
            }
            
            List<Inventory__c> inventoriesToUpdate = new List<Inventory__c>();
            inventoriesToUpdate =[SELECT Id,Name,Reserved_Qty__c,Available_Qty__c,Web_Available_Qty__c,
                                  Purchased_Qty__c,ProductCode__c FROM Inventory__c WHERE ProductCode__c IN :productIds];
            
            for(Inventory__c inventory:inventoriesToUpdate)
            {
                if(inventory.Reserved_Qty__c==null){
                    
                    inventory.Reserved_Qty__c=0;
                }
                if(inventory.Purchased_Qty__c==null){
                    
                    inventory.Purchased_Qty__c=0;
                }
                
                
                inventory.Reserved_Qty__c=inventory.Reserved_Qty__c+productQuantityMap.get(inventory.ProductCode__c);
                inventory.Purchased_Qty__c = inventory.Purchased_Qty__c+productQuantityMap.get(inventory.ProductCode__c);
                inventory.Web_Available_Qty__c = inventory.Web_Available_Qty__c - productQuantityMap.get(inventory.ProductCode__c);
                inventory.Comments__c = 'Web Order';
                
            }
            
            if(null!=inventoriesToUpdate){
                
                update inventoriesToUpdate;
                
            }
        //}
        return TRUE;
    }
    
    public boolean updateOrderStatusOnShipmentFistTile(List<Id> shipprodarr){
        
         /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Shipment_Products__c',new Set<String>{'Id','Name','sigmaerpdev2__Shipment__c','sigmaerpdev2__Status__c','sigmaerpdev2__Sigma_Order__r.id','sigmaerpdev2__Sigma_Order__r.sigmaerpdev2__Orders_Status__c','sigmaerpdev2__Package_ID__r.Id'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Shipment__c',new Set<String>{'Id','Name','sigmaerpdev2__Status__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__PackagedProducts__c',new Set<String>{'id','name','sigmaerpdev2__Sigma_Order__r.Id','sigmaerpdev2__Sigma_Order__r.sigmaerpdev2__Orders_Status__c','sigmaerpdev2__Product__r.Id','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Package__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'id','name','sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Shipped_Qty__c','sigmaerpdev2__ProductCode__r.Id','sigmaerpdev2__Available_Qty__c', 'sigmaerpdev2__Web_Available_Qty__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__ProductCode__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new Set<String>{'sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Shipped_Qty__c','sigmaerpdev2__Comments__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new Set<String>{'id','sigmaerpdev2__Product__c','sigmaerpdev2__Order_Status__c','sigmaerpdev2__Order__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Order_Status__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Order__c',new Set<String>{'sigmaerpdev2__Orders_Status__c'})
           &&Schema.sObjectType.Sigma_Order__c.fields.Id.isAccessible()
          )
        {*/
            Set<String>packId = new Set<String>();
            Set<String>productId = new Set<String>();
            Set<String>OrderId = new Set<String>();
            Map<ID,Integer> packedProdQuantity = new Map<ID,Integer>();
            Shipment_Products__c Shipment = new Shipment_Products__c();
            List<Shipment_Products__c> shipprodList = new List<Shipment_Products__c>();
            
            shipprodList = [select Id,Name, Shipment__c,Status__c from  Shipment_Products__c where Id IN :shipprodarr];
            
            Shipment__c newShipment = new Shipment__c();
            
            newShipment = [select Id,Name,Status__c   from  Shipment__c where Id=:shipprodList[0].Shipment__c ];
            
            List<Shipment__c> oldShipment ;
            
            List<Shipment_Products__c> shipmentProducts = new List<Shipment_Products__c>();
            
            
            shipmentProducts = [SELECT id,name,Sigma_Order__r.id,Sigma_Order__r.Orders_Status__c,Package_ID__r.Id FROM Shipment_Products__c WHERE Shipment__r.id = :newShipment.Id And Id IN:shipprodarr];
            
            for(Shipment_Products__c shipProd : shipmentProducts){
                
                PackId.add(shipProd.Package_ID__r.Id);
            } 
            
            List<PackagedProducts__c> packProducts;
            
            packProducts = [SELECT id,name,Sigma_Order__r.Id,Sigma_Order__r.Orders_Status__c,Product__r.Id,Sigma_Order__c,Product__c,Quantity__c FROM PackagedProducts__c 
                            WHERE Package__c IN :PackId];
            
            Map<Id,PackagedProducts__c> updateOrderProductsStatus = new Map<Id,PackagedProducts__c>();
            Set<Id> uniqueOrderIds = new Set<Id>(); 
            List<Sigma_Order__c> orderStatusUpdate =  new List<Sigma_Order__c>();
            for(PackagedProducts__c packedProd : packProducts){
                
                OrderId.add(packedProd.Sigma_Order__r.Id);
                productId.add(packedProd.Product__r.Id);
                if(packedProdQuantity.containsKey(packedProd.Product__r.Id))
                {         
                    Integer value= packedProdQuantity.get(packedProd.Product__r.Id);
                    packedProdQuantity.put(packedProd.Product__r.Id,Integer.valueOf(packedProd.Quantity__c)+value);
                }
                else{
                    packedProdQuantity.put(packedProd.Product__r.Id,Integer.valueOf(packedProd.Quantity__c));
                }
                updateOrderProductsStatus.put(packedProd.Product__c,packedProd);
                uniqueOrderIds.add(packedProd.Sigma_Order__c);
                Sigma_Order__c Ordertemp = new Sigma_Order__c();
                Ordertemp.Id = packedProd.Sigma_Order__r.Id;
                Ordertemp.Orders_Status__c = newShipment.Status__c;
                if(listContains(orderStatusUpdate,Ordertemp))
                {
                }
                else
                {
                    orderStatusUpdate.add(Ordertemp);
                }
                
            }
            String newShipmentStatus =newShipment.Status__c;
            if((newShipmentStatus == 'Shipped' )){
                
                Integer packedQty;  
                List<Inventory__c> invShippedQtyToUpdate = new List<Inventory__c>();
                List<Inventory__c> prodInvs;
                
                prodInvs = [SELECT id,name,Reserved_Qty__c,Shipped_Qty__c,ProductCode__r.Id,Available_Qty__c, 
                            Web_Available_Qty__c,Total_Available_Qty__c FROM Inventory__c WHERE ProductCode__c  IN :productId];
                
                for(Inventory__c prodInv : prodInvs)
                {
                    Inventory__c newInv = new Inventory__c();
                    
                    packedQty = packedProdQuantity.get(prodInv.ProductCode__r.Id);
                    newInv.Shipped_Qty__c = prodInv.Shipped_Qty__c + packedQty;
                    newInv.Reserved_Qty__c = prodInv.Reserved_Qty__c - packedQty;    
                    newInv.Comments__c = 'Product has been "Shipped"';
                    newInv.Id = prodInv.Id;
                    invShippedQtyToUpdate.add(newInv);
                    
                }
                update invShippedQtyToUpdate;
                
            }
            
            update orderStatusUpdate;
            //commented on 10-10-2019 to update shipped quantity in sigma order line  using code
            List<Product_Order_Price_Book__c> orderLines = new List<Product_Order_Price_Book__c >();
            
            orderLines = [select id,Product__c,Order_Status__c,Order__c from Product_Order_Price_Book__c where Order__c  In :uniqueOrderIds];
            
            if(orderLines.size() > 0)
            {
                for(Product_Order_Price_Book__c temp :orderLines)
                {
                    if(updateOrderProductsStatus.containsKey(temp.Product__c))
                    {
                        temp.Order_Status__c = newShipment.Status__c;
                    }
                    
                } 
                
            }
            
            update orderLines;
            
        //}       
        
        
        return true;
    }
    
    public boolean updateOrderStatusOnShipmentProdUpdate(List<Shipment_Products__c> shipmentProductList)
    {
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Shipment__c',new Set<String>{'Id','Name','sigmaerpdev2__Status__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__PackagedProducts__c',new Set<String>{'id','name','sigmaerpdev2__Product_Order__c','sigmaerpdev2__Sigma_Order__r.Id','sigmaerpdev2__Sigma_Order__r.sigmaerpdev2__Orders_Status__c','sigmaerpdev2__Product__r.Id','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Package__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new Set<String>{'Id','sigmaerpdev2__Orders_Status__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Order__c',new Set<String>{'sigmaerpdev2__Orders_Status__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new Set<String>{'id','sigmaerpdev2__Product__c','sigmaerpdev2__Order_Status__c','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__IsInventoryUpdated__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Order_Status__c'})
          )
        {*/
            Set<String> packId = new Set<String>();
            
            Shipment__c newShipment = new Shipment__c();
            
            newShipment = [select Id,Name,Status__c   from  Shipment__c where Id=:shipmentProductList[0].Shipment__c ];
            
            if(newShipment.Status__c!='Returned')
            {
                for(Shipment_Products__c shipProd : shipmentProductList)
                {
                    PackId.add(shipProd.Package_ID__c);
                } 
                
                List<PackagedProducts__c> packProducts;
                
                packProducts = [SELECT id,name,Sigma_Order__r.Id,Sigma_Order__r.Orders_Status__c,Product__r.Id,Sigma_Order__c,Product__c,Quantity__c,Product_Order__c FROM PackagedProducts__c 
                                WHERE Package__c IN :PackId];
                
                Map<Id,PackagedProducts__c> updateOrderProductsStatus = new Map<Id,PackagedProducts__c>();
                Set<Id> uniqueOrderIds = new Set<Id>(); 
                Set<Id> uniqueOrderLineIds = new Set<Id>(); 
                Map<Id,Id>packageProductIdAndOrderLineItemIds=new Map<Id,Id>(); //added on 05-03-2020 
                List<Sigma_Order__c> orderStatusUpdate =  new List<Sigma_Order__c>();  
                
                for(PackagedProducts__c packedProd : packProducts)
                {
                    packageProductIdAndOrderLineItemIds.put(packedProd.id,packedProd.Product_Order__c);//added on 05-03-2020 
                    updateOrderProductsStatus.put(packedProd.Product__c,packedProd);
                    uniqueOrderIds.add(packedProd.Sigma_Order__c);
                    Sigma_Order__c Ordertemp = new Sigma_Order__c();
                    Ordertemp.Id = packedProd.Sigma_Order__r.Id;
                    Ordertemp.Orders_Status__c = newShipment.Status__c;
                    if(listContains(orderStatusUpdate,Ordertemp))
                    {
                    }
                    else
                    {
                        orderStatusUpdate.add(Ordertemp);
                    }
                    
                }
                
             //   update orderStatusUpdate; // commented on 04-03-2020 for stopping order header status
                
                List<Product_Order_Price_Book__c> orderLines = new List<Product_Order_Price_Book__c >();
               
                orderLines = [select id,Product__c,Order_Status__c,Sigma_Order__c,IsInventoryUpdated__c from Product_Order_Price_Book__c where Sigma_Order__c  In :uniqueOrderIds and IsInventoryUpdated__c=true and Id  In :packageProductIdAndOrderLineItemIds.values()];//added on 05-03-2020  //IsInventoryUpdated__c added on 26-02-2020
                
                if(orderLines.size() > 0)
                {
                    for(Product_Order_Price_Book__c temp :orderLines)
                    {
                        if(updateOrderProductsStatus.containsKey(temp.Product__c))
                        {
                            
                            temp.Order_Status__c = newShipment.Status__c;
                        }
                        
                    } 
                    
                }
                update orderLines;
        //added on 06-04-2020 to update order  line item status which has 0 qty
        System.debug('uniqueOrderIds>>'+uniqueOrderIds);
                       
        List<Product_Order_Price_Book__c > orderLinesWichHasZeroQTY = new List<Product_Order_Price_Book__c  >();
               
                orderLinesWichHasZeroQTY = [select id,Product__c,Order_Status__c,Sigma_Order__c,IsInventoryUpdated__c from Product_Order_Price_Book__c where Sigma_Order__c  In :uniqueOrderIds  And Net_Quantity__c=0 ];//added on 05-03-2020  //IsInventoryUpdated__c added on 26-02-2020
                System.debug('orderLinesWichHasZeroQTY>>'+orderLinesWichHasZeroQTY);
                if(orderLinesWichHasZeroQTY.size() > 0)
                {
                    for(Product_Order_Price_Book__c  temp :orderLinesWichHasZeroQTY)
                    {
                        if(updateOrderProductsStatus.containsKey(temp.Product__c))
                        {
                            temp.Order_Status__c = newShipment.Status__c;
                        }
                        
                    } 
                    
                }
        System.debug('orderLinesWichHasZeroQTY>>'+orderLinesWichHasZeroQTY);
        update orderLinesWichHasZeroQTY;
        



        
                ///////////////
                 List<Sigma_Order__c> UpdateSigmaOrderStatus =  new List<Sigma_Order__c>();  
                List<Sigma_Order__c> totalSigmaOrdersAndOrderLines=[select id, name, Orders_Status__c, (select id, name, Order_Status__c ,Sigma_Order__c from Order_Lines__r) from Sigma_Order__c where id In :uniqueOrderIds]; 
                System.debug('orderStatusUpdate>>'+totalSigmaOrdersAndOrderLines);
                System.debug('UpdateSigmaOrderStatus>>'+UpdateSigmaOrderStatus);
                System.debug('totalSigmaOrdersAndOrderLines>>'+totalSigmaOrdersAndOrderLines);
                for(Sigma_Order__c so:totalSigmaOrdersAndOrderLines)
                {
                        System.debug('so>>'+so);
                        System.debug('so.Order_Lines__r.size()>>'+so.Order_Lines__r.size());
                        System.debug('so.Order_Lines__r.'+so.Order_Lines__r);
                    
                    if(so.Order_Lines__r.size()>0)
                    {
                        Integer noOfLineItems=so.Order_Lines__r.size();
                        System.debug('noOfLineItems>>'+noOfLineItems);
                    
                        String shipStatus='Shipped';
                        String deleveredStatus='Delivered';
                        Integer shipCount=0;
                        Integer deliverCount=0;
                        
                        Map<Id,String>orderIdAndStatus=new Map<Id,String>();
                        System.debug('orderIdAndStatus>>'+orderIdAndStatus);
                    
                        for(Product_Order_Price_Book__c soli:so.Order_Lines__r)
                        {
                            System.debug('soli>>'+soli);
                    
                            if(soli.Order_Status__c==shipStatus)
                            {
                                ++shipCount;
                                System.debug('shipCount>>'+shipCount);
                                if(shipCount==noOfLineItems)
                                orderIdAndStatus.put(soli.Sigma_Order__c,soli.Order_Status__c);
                            
                            }
                            else if(soli.Order_Status__c==deleveredStatus)
                            {
                                ++deliverCount;
                                System.debug('deliverCount>>'+deliverCount);
                                if(deliverCount==noOfLineItems)
                                orderIdAndStatus.put(soli.Sigma_Order__c,soli.Order_Status__c);
                            }
                        }
                        System.debug('shipCount>>'+shipCount);
                        System.debug('deliverCount>>'+deliverCount);
                        System.debug('noOfLineItems>>'+noOfLineItems);
                        System.debug('orderIdAndStatus>>'+orderIdAndStatus);
                        if(shipCount==noOfLineItems)
                        {
                            if(orderIdAndStatus.containsKey(so.id))
                            {
                                so.Orders_Status__c=orderIdAndStatus.get(so.id);
                                UpdateSigmaOrderStatus.add(so);
                            }
                            
                        }
                        else if(deliverCount==noOfLineItems)
                        {
                            if(orderIdAndStatus.containsKey(so.id))
                            {
                                so.Orders_Status__c=orderIdAndStatus.get(so.id);
                                UpdateSigmaOrderStatus.add(so);
                            }
                        }
                    }
                }
                System.debug('UpdateSigmaOrderStatus>>'+UpdateSigmaOrderStatus);
                if(UpdateSigmaOrderStatus.size()>0)
                {
                    update UpdateSigmaOrderStatus;
                }

                //////////////////////////              
                
            }
            
            
        //}
        return true;
        
    }
    
    
    public boolean updateOrderStatusOnShipment(List<Shipment__c> newShipment,List<Shipment__c> oldShipment)
    {
        Integer i=0;
        Set<String>OrderId = new Set<String>();
        Set<String>packId = new Set<String>();
        Set<String>productId = new Set<String>();
        Map<ID,Integer> packedProdQuantity = new Map<ID,Integer>();
        Map<ID,Integer> sigmapkProdQty = new Map<ID,Integer>();
        
        
        List<String>  shipmentId = new List<String>();
        List<Sigma_Order__c> getrecordtype = New List<Sigma_Order__c>();
        
        String newShipmentStatus;
        String oldShipmentStatus;
        system.debug('newShipmentStatus:::'+newShipmentStatus);
        system.debug('oldShipmentStatus:::'+oldShipmentStatus);
        
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Shipment__c',new Set<String>{'Id','Name','sigmaerpdev2__Status__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Shipment_Products__c',new Set<String>{'Id','Name','sigmaerpdev2__Order__r.id','sigmaerpdev2__Package_ID__r.Id','sigmaerpdev2__Shipment__r.id','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__Package_ID__c','sigmaerpdev2__Order__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__PackagedProducts__c',new Set<String>{'id','name','sigmaerpdev2__Order__r.Id','sigmaerpdev2__Product__r.Id','sigmaerpdev2__Quantity__c','sigmaerpdev2__Package__c','Sigma_Order__c','sigmaerpdev2__Product__c','sigmaerpdev2__Order_Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Sigma_Order__r.RecordType.Name','sigmaerpdev2__Product_Order__c','sigmaerpdev2__Order__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Order_Usage__c',new Set<String>{'Id', 'Name','sigmaerpdev2__Sigma_order__c','sigmaerpdev2__Standard_object__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new Set<String>{'Id', 'Name','RecordTypeId','RecordType.Name'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'id','name','sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Shipped_Qty__c','sigmaerpdev2__ProductCode__r.Id','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Web_Available_Qty__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__Delivered_Qty__c','sigmaerpdev2__Rental_Delivered_Quantity__c','sigmaerpdev2__Rental_Reserve_Quantity__c','sigmaerpdev2__Rental_Shipped_Quantity__c','sigmaerpdev2__ProductCode__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new Set<String>{'sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Shipped_Qty__c','sigmaerpdev2__Comments__c','sigmaerpdev2__Rental_Delivered_Quantity__c','sigmaerpdev2__Rental_Reserve_Quantity__c','sigmaerpdev2__Rental_Shipped_Quantity__c'})
           &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Shipment_Products__c',new Set<String>{'sigmaerpdev2__Shipment__c'})
          )
        {*/
            system.debug('inside fls');
            for(Shipment__c shipmentData : newShipment)
            {
                if((newShipment[i].Status__c=='Shipped' || newShipment[i].Status__c=='Ready To Ship' || newShipment[i].Status__c== 'Delivered' || newShipment[i].Status__c=='Returned'))
                {
                    shipmentId.add(newShipment[i].id);
                    newShipmentStatus = newShipment[i].Status__c;              
                }
                i++;
            }
            if(oldShipment!= null)
            {
                
                for(Shipment__c oldShipmentData : oldShipment)
                {
                    oldShipmentStatus = oldShipmentData.Status__c;              
                }
            }
            //get shipment order from shipment products by shipment id
            List<Shipment_Products__c> shipmentProducts;
            
            shipmentProducts = [SELECT id,name,Sigma_Order__c,Package_ID__c,Order__c FROM Shipment_Products__c WHERE 
                                Shipment__c IN :shipmentId];
            
            //get package id from shipment products
            for(Shipment_Products__c shipProd : shipmentProducts)
            {
                if(shipProd.Package_ID__c != null)
                    PackId.add(shipProd.Package_ID__c);
            } 
            List<PackagedProducts__c> packProducts;
            
            packProducts = [SELECT id,name,Sigma_Order__c,Product__c,Order_Product__c,Quantity__c,Sigma_Order__r.RecordType.Name,Product_Order__c,Order__c FROM PackagedProducts__c WHERE Package__c IN :PackId];  
            //get product id & order Id from shipment products chandana and byforgation on order and sigma order starts 
            Order_Usage__c OrderTypeusage= new Order_Usage__c();
            OrderTypeusage= [select Id, Name,Sigma_order__c,Standard_object__c from Order_Usage__c limit 1];
            
            Map<ID,Integer> orderlineqty = new Map<ID,Integer>();
            if(OrderTypeusage.Standard_object__c == true)
            {
                for(PackagedProducts__c packedProd : packProducts)
                {
                    Integer qty=0;
                    Integer orderlinequnty=0;
                    OrderId.add(packedProd.Order__c);
                    productId.add(packedProd.Product__c);
                    if(packedProd.Order_Product__c!=null)
                    {
                        if(orderlineqty.containsKey(packedProd.Order_Product__c))
                        {
                            orderlinequnty=orderlineqty.get(packedProd.Order_Product__c);
                            orderlineqty.put(packedProd.Order_Product__c,orderlinequnty+Integer.valueOf(packedProd.Quantity__c));
                        }
                        else
                        {
                            orderlineqty.put(packedProd.Order_Product__c,Integer.valueOf(packedProd.Quantity__c));
                        }  
                    }
                    if(packedProdQuantity.containsKey(packedProd.Product__c))
                    {
                        qty=packedProdQuantity.get(packedProd.Product__c);
                        packedProdQuantity.put(packedProd.Product__c,qty+Integer.valueOf(packedProd.Quantity__c));
                    }
                    else{
                        packedProdQuantity.put(packedProd.Product__c,Integer.valueOf(packedProd.Quantity__c));
                    }
                    //packedProdQuantity.put(packedProd.Product__c,Integer.valueOf(packedProd.Quantity__c));
                }
                
            }
            else
            {
                for(PackagedProducts__c packedProd : packProducts)
                {
                    OrderId.add(packedProd.Sigma_Order__c);
                    productId.add(packedProd.Product__c);
                    Integer qty=0;
                    Integer orderlinequnty=0;
                    if(orderlineqty.containsKey(packedProd.Product_Order__c))
                    {
                        orderlinequnty=orderlineqty.get(packedProd.Product_Order__c);
                        orderlineqty.put(packedProd.Product_Order__c,orderlinequnty+Integer.valueOf(packedProd.Quantity__c));
                    }
                    else
                    {
                        
                        orderlineqty.put(packedProd.Product_Order__c,Integer.valueOf(packedProd.Quantity__c));
                    }
                    if(packedProd.Sigma_Order__r.RecordType.Name=='Rental Order')
                    {
                        if(packedProdQuantity.containsKey(packedProd.Product__c))
                        {
                            //packedProdQuantity.put(packedProd.Product__c,Integer.valueOf(packedProd.Quantity__c));
                            qty=packedProdQuantity.get(packedProd.Product__c);
                            packedProdQuantity.put(packedProd.Product__c,qty+Integer.valueOf(packedProd.Quantity__c));
                        }
                        else
                        {
                            packedProdQuantity.put(packedProd.Product__c,Integer.valueOf(packedProd.Quantity__c));  
                        }
                    }
                    else
                    {
                        if(sigmapkProdQty.containsKey(packedProd.Product__c))
                        {
                            qty=sigmapkProdQty.get(packedProd.Product__c);
                            sigmapkProdQty.put(packedProd.Product__c,qty+Integer.valueOf(packedProd.Quantity__c));
                        }
                        else
                        {
                            sigmapkProdQty.put(packedProd.Product__c,Integer.valueOf(packedProd.Quantity__c)); 
                        }
                    }
                    
                }
                
                if(OrderId != null && !OrderId.isEmpty())
                {
                    getrecordtype = [select id,RecordTypeId,RecordType.Name from Sigma_Order__c where id in :OrderId];
                    
                }
                
            }
            
            if((newShipmentStatus == 'Shipped' ))
            {
                system.debug('inside shipped status ');
                if(oldShipmentStatus != 'Shipped' && !(string.isBlank(oldShipmentStatus)))
                {
                    system.debug('oldShipmentStatus !=  && !(string.isBlank(oldShipmentStatus)');
                    Integer packedQty =0;
                    Integer packedsigmaQty=0;
                    List<Inventory__c> invShippedQtyToUpdate = new List<Inventory__c>();
                    List<Inventory__c> prodInvs;
                    
                    prodInvs = [SELECT id,name,Reserved_Qty__c,Shipped_Qty__c,ProductCode__r.Id,Available_Qty__c, 
                                Web_Available_Qty__c,Total_Available_Qty__c, Rental_Reserve_Quantity__c, Rental_Shipped_Quantity__c,Packaged_Quantity__c
                                FROM Inventory__c WHERE ProductCode__c  IN :productId];//Packaged_Quantity__c FIELD ADDED ON 29-08-2019 
                    system.debug('prodInvs::'+prodInvs);
                    if(OrderTypeusage.Standard_object__c == true)
                    {
                        system.debug('inside if1');
                        for(Inventory__c prodInv : prodInvs)
                        { 
                            system.debug('inside for1 prodInv.Shipped_Qty__c'+prodInv.Shipped_Qty__c);
                             system.debug('inside for1 prodInv'+prodInv);
                            Inventory__c newInv = new Inventory__c();
                            packedQty = packedProdQuantity.get(prodInv.ProductCode__r.Id);
                            if(prodInv.Shipped_Qty__c==null) prodInv.Shipped_Qty__c=0;//added on 24-04-2020 to avoid null pointer exception
                            newInv.Shipped_Qty__c = prodInv.Shipped_Qty__c + packedQty;
                            //newInv.Reserved_Qty__c = prodInv.Reserved_Qty__c - packedQty;//COMMENTED ON 29-08-2019
                            newInv.Packaged_Quantity__c = prodInv.Packaged_Quantity__c - packedQty;//ADDED ON 29-08-2019
                            newInv.Comments__c = 'Product has been "Delivered"';
                            system.debug('Comments>>1'+ newInv.Comments__c);
                            newInv.Id = prodInv.Id;
                            invShippedQtyToUpdate.add(newInv);
                            system.debug('invShippedQtyToUpdate1'+invShippedQtyToUpdate);
                        }
                    }
                    else{
                        system.debug('inside else1');
                        for(Inventory__c prodInv : prodInvs)
                        {
                            system.debug('inside for2');
                            Inventory__c newInv = new Inventory__c();
                            if(packedProdQuantity.containskey(prodInv.ProductCode__r.Id))
                            {
                                packedQty = packedProdQuantity.get(prodInv.ProductCode__r.Id);  
                                
                            }
                            if(sigmapkProdQty.containskey(prodInv.ProductCode__r.Id))
                            {
                                packedsigmaQty=sigmapkProdQty.get(prodInv.ProductCode__r.Id); 
                                system.debug('packedsigmaQty::'+packedsigmaQty);
                            }
                            
                            if(packedQty!=0)
                            {
                                newInv.Rental_Shipped_Quantity__c = prodInv.Rental_Shipped_Quantity__c + packedQty;
                                newInv.Rental_Reserve_Quantity__c = prodInv.Rental_Reserve_Quantity__c - packedQty;
                            }
                            if(packedsigmaQty !=0 )
                            {
                                system.debug('inside packedsigmaQty!=0');
                                newInv.Shipped_Qty__c = prodInv.Shipped_Qty__c + packedsigmaQty;
                                // newInv.Reserved_Qty__c = prodInv.Reserved_Qty__c - packedsigmaQty; //COMMENTED ON 29-08-2019
                                newInv.Packaged_Quantity__c = prodInv.Packaged_Quantity__c - packedsigmaQty; //ADDED ON 29-08-2019
                            }
                            newInv.Comments__c = 'Product has been "Delivered"';
                            system.debug('Comments'+newInv.Comments__c );
                            newInv.Id = prodInv.Id;
                            invShippedQtyToUpdate.add(newInv);
                            system.debug('inside invShippedQtyToUpdate2'+invShippedQtyToUpdate);
                        }
                    }//end of else
                    system.debug('invShippedQtyToUpdate::'+invShippedQtyToUpdate);
                    //if(checkObjectInventory() == true)
                    //{/
                    update invShippedQtyToUpdate;
                    //}
                    system.debug('invShippedQtyToUpdate::'+invShippedQtyToUpdate);
                }
            }
            //Added on 18/05/2016
            if(( newShipmentStatus == 'Delivered' && oldShipmentStatus == 'Shipped'))
            {
                //Integer packedQtydelivered;
                Integer packedQty=0;
                Integer packedsigmaQty=0;
                List<Inventory__c> invShippedQtyToUpdatedelivered = new List<Inventory__c>();
                List<Inventory__c> prodInvsdelivered;
                
                prodInvsdelivered = [SELECT id,name,Reserved_Qty__c,Delivered_Qty__c,Shipped_Qty__c,
                                     ProductCode__r.Id, Rental_Shipped_Quantity__c, Rental_Delivered_Quantity__c 
                                     FROM Inventory__c WHERE ProductCode__c IN :productId];
                
                if(OrderTypeusage.Standard_object__c == true)
                {
                    for(Inventory__c prodInv : prodInvsdelivered){
                        Inventory__c newInv = new Inventory__c();
                        packedQty = packedProdQuantity.get(prodInv.ProductCode__r.Id);
                        newInv.Shipped_Qty__c = prodInv.Shipped_Qty__c - packedQty;
                        newInv.Delivered_Qty__c = prodInv.Delivered_Qty__c + packedQty;
                        newInv.Comments__c = 'Product has been "Delivered"';
                        system.debug('Comments'+newInv.Comments__c );
                        newInv.Id = prodInv.Id;
                        invShippedQtyToUpdatedelivered.add(newInv);
                        system.debug('invShippedQtyToUpdatedelivered::'+invShippedQtyToUpdatedelivered);
                    }
                    
                }
                else 
                {
                    
                    for(Inventory__c prodInv : prodInvsdelivered)
                    {
                        Inventory__c newInv = new Inventory__c();
                        if(packedProdQuantity.containskey(prodInv.ProductCode__r.Id))
                        {
                            packedQty = packedProdQuantity.get(prodInv.ProductCode__r.Id);  
                            
                        }
                        if(sigmapkProdQty.containskey(prodInv.ProductCode__r.Id))
                        {
                            packedsigmaQty=sigmapkProdQty.get(prodInv.ProductCode__r.Id); 
                            
                        }
                        
                        if(packedQty!=0)
                        {
                            newInv.Rental_Shipped_Quantity__c = prodInv.Rental_Shipped_Quantity__c - packedQty;
                            newInv.Rental_Delivered_Quantity__c = prodInv.Rental_Delivered_Quantity__c + packedQty;
                        }
                        if(packedsigmaQty!=0)
                        {
                            newInv.Shipped_Qty__c = prodInv.Shipped_Qty__c - packedsigmaQty;
                            newInv.Delivered_Qty__c = prodInv.Delivered_Qty__c + packedsigmaQty;
                        }
                        newInv.Comments__c = 'Product has been Delivered';
                        system.debug('Comments'+newInv.Comments__c );
                        newInv.Id = prodInv.Id;
                        invShippedQtyToUpdatedelivered.add(newInv);
                        system.debug('invShippedQtyToUpdatedelivered::'+invShippedQtyToUpdatedelivered);
                    }
                    
                }
                system.debug('invShippedQtyToUpdatedelivered::'+invShippedQtyToUpdatedelivered);
                update invShippedQtyToUpdatedelivered;
                
            }
            //new code to add direct delivered from readytoship status to delivered status by chandana 
            //Added on 18/05/2016
            if(Test.isrunningTest() || ( newShipmentStatus == 'Delivered' && oldShipmentStatus == 'Ready To Ship'))
            {
                //Integer packedQtydelivered;
                Integer packedQty=0;
                Integer packedsigmaQty=0;
                List<Inventory__c> invAvalQtyToUpdatedelivered = new List<Inventory__c>();
                List<Inventory__c> prodInvsdelivered;
                
                prodInvsdelivered = [SELECT id,name,Reserved_Qty__c,Delivered_Qty__c,Shipped_Qty__c,
                                     ProductCode__r.Id, Rental_Delivered_Quantity__c, Rental_Reserve_Quantity__c 
                                     FROM Inventory__c WHERE ProductCode__c IN :productId];
                
                if(OrderTypeusage.Standard_object__c == true)
                {
                    for(Inventory__c prodInv : prodInvsdelivered){
                        Inventory__c newInv = new Inventory__c();
                        packedQty = packedProdQuantity.get(prodInv.ProductCode__r.Id);
                        newInv.Reserved_Qty__c = prodInv.Reserved_Qty__c - packedQty;
                        newInv.Delivered_Qty__c = prodInv.Delivered_Qty__c + packedQty;
                        newInv.Comments__c = 'Product has been Delivered';
                        system.debug('Comments'+newInv.Comments__c );
                        newInv.Id = prodInv.Id;
                        invAvalQtyToUpdatedelivered.add(newInv);
                        system.debug('invAvalQtyToUpdatedelivered::'+invAvalQtyToUpdatedelivered);
                    }
                    
                }
                else {
                    for(Inventory__c prodInv : prodInvsdelivered)
                    {
                        Inventory__c newInv = new Inventory__c();
                        if(packedProdQuantity.containskey(prodInv.ProductCode__r.Id))
                        {
                            packedQty = packedProdQuantity.get(prodInv.ProductCode__r.Id);  
                            
                        }
                        if(sigmapkProdQty.containskey(prodInv.ProductCode__r.Id))
                        {
                            packedsigmaQty=sigmapkProdQty.get(prodInv.ProductCode__r.Id); 
                            
                        }
                        
                        if(packedQty!=0)
                        {
                            newInv.Rental_Delivered_Quantity__c = prodInv.Rental_Delivered_Quantity__c + packedQty;
                            newInv.Rental_Reserve_Quantity__c = prodInv.Rental_Reserve_Quantity__c - packedQty;
                        }
                        if(packedsigmaQty!=0)
                        {
                            newInv.Delivered_Qty__c = prodInv.Delivered_Qty__c + packedsigmaQty;
                            newInv.Reserved_Qty__c = prodInv.Reserved_Qty__c - packedsigmaQty;
                        }
                        newInv.Comments__c = 'Product has been Delivered';
                        system.debug('Comments'+newInv.Comments__c );
                        newInv.Id = prodInv.Id;
                        invAvalQtyToUpdatedelivered.add(newInv);
                        system.debug('invAvalQtyToUpdatedelivered::'+invAvalQtyToUpdatedelivered);
                    }
                    
                }
                
                update invAvalQtyToUpdatedelivered;
                
            }
            
        //}//end of fls if
        return true;
        
    }
    
    public boolean  UpdateShippedQtyOnShipProducts(List<Shipment_Products__c> newShipmentProd,List<Shipment_Products__c> oldShipmentProd)
    {
        
        Integer i=0;
        Set<String>OrderId = new Set<String>();
        Set<String>packId = new Set<String>();
        Set<String>productId = new Set<String>();
        Map<ID,Integer> packedProdQuantity = new Map<ID,Integer>();
        
        List<String>  shipmentId = new List<String>();
        String shipmentStatus;
       /* if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Shipment__c',new Set<String>{'Id','Name','sigmaerpdev2__Status__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__PackagedProducts__c',new Set<String>{'id','name','sigmaerpdev2__Order__r.Id','sigmaerpdev2__Product__r.Id','sigmaerpdev2__Quantity__c','sigmaerpdev2__Package__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'id','name','sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Shipped_Qty__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__ProductCode__r.Id','sigmaerpdev2__ProductCode__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new Set<String>{'sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Shipped_Qty__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__Comments__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Shipment_Products__c',new Set<String>{'id','name','sigmaerpdev2__Status__c','sigmaerpdev2__Package_ID__c'})
           &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Shipment_Products__c',new Set<String>{'sigmaerpdev2__Shipment__c'})                         
          )
        {*/
            //getting shipment id to fetch order data of shipment products
            for(Shipment_Products__c shipmentData : newShipmentProd)
            {
                shipmentId.add(shipmentData.Shipment__c);
                PackId.add(shipmentData.Package_ID__c);
                
                i++;
            }
            List<Shipment__c> shipmentData;
            
            shipmentData = [SELECT id,name,Status__c FROM Shipment__c WHERE id IN :shipmentId];
            
            for(Shipment__c shipData : shipmentData){
                shipmentStatus = shipData.Status__c;
            }
            List<PackagedProducts__c> packProducts;
            
            packProducts = [SELECT id,name,Order__r.Id,Product__r.Id,Quantity__c FROM PackagedProducts__c 
                            WHERE Package__c IN :PackId];
            
            //get product id & order Id from shipment products
            for(PackagedProducts__c packedProd : packProducts){
                OrderId.add(packedProd.Order__r.Id);
                productId.add(packedProd.Product__r.Id);
                packedProdQuantity.put(packedProd.Product__r.Id,Integer.valueOf(packedProd.Quantity__c));
            }
            
            Integer packedQty;
            List<Inventory__c> invShippedQtyToUpdate = new List<Inventory__c>();
            List<Inventory__c> prodInvs;
            
            prodInvs= [SELECT id,name,Reserved_Qty__c,Total_Available_Qty__c,Shipped_Qty__c,ProductCode__r.Id 
                       FROM Inventory__c WHERE ProductCode__c IN :productId];
            
            for(Inventory__c prodInv : prodInvs){
                Inventory__c newInv = new Inventory__c();
                packedQty = packedProdQuantity.get(prodInv.ProductCode__r.Id);
                
                newInv.Shipped_Qty__c = prodInv.Shipped_Qty__c + packedQty;
                newInv.Reserved_Qty__c = prodInv.Reserved_Qty__c - packedQty;
                newInv.Total_Available_Qty__c = prodInv.Total_Available_Qty__c - packedQty;
                newInv.Comments__c = 'Product has been shipped';
                system.debug('Comments'+newInv.Comments__c );
                newInv.Id = prodInv.Id;
                
                invShippedQtyToUpdate.add(newInv);
                system.debug('invShippedQtyToUpdate8::'+invShippedQtyToUpdate);
            }
            if((shipmentStatus =='Shipped' || shipmentStatus == 'Delivered')){
                
                update invShippedQtyToUpdate;
                system.debug('invShippedQtyToUpdate9::'+invShippedQtyToUpdate);
            }
        //}
        
        return true;
    } 
    
    //manage inventory transaction
    public void manageInventoryTransactions(List<Inventory__c> newInventory1,Map<Id,Inventory__c> oldMap,Boolean isInsert,Boolean isUpdate)
    {
        system.debug('inside fls 1'+CRUD_FLS_CheckUtility.checkFLS('Inventory_Transaction__c',new Set<String>{'Available_Qty__c','Purchased_Qty__c','Reserved_Qty__c','Shipped_Qty__c','Delivered_Qty__c','ProductCode__c','Inventory_id__c','Total_Qty__c','Account__c','Quantity_To_Become_Out_Of_Stock__c','Total_Available_Qty__c','Web_Available_Qty__c','Reason__c'}));
        system.debug('inside fls 2'+CRUD_FLS_CheckUtility.checkReadPermission('Inventory__c',new Set<String>{'Available_Qty__c','Purchased_Qty__c','Reserved_Qty__c','Shipped_Qty__c','Delivered_Qty__c','ProductCode__c','id','Total_Qty__c','Account__c','Quantity_To_Become_Out_Of_Stock__c','Total_Available_Qty__c','Web_Available_Qty__c','Comments__c'}));
        
        /*if(CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Transaction__c',new Set<String>{'sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Purchased_Qty__c','sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Shipped_Qty__c','sigmaerpdev2__Delivered_Qty__c','sigmaerpdev2__ProductCode__c','sigmaerpdev2__Inventory_id__c','sigmaerpdev2__Total_Qty__c','sigmaerpdev2__Account__c','sigmaerpdev2__Quantity_To_Become_Out_Of_Stock__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__Web_Available_Qty__c','sigmaerpdev2__Reason__c'})
           &&Schema.sObjectType.Inventory_Transaction__c.fields.Id.isAccessible()
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Purchased_Qty__c','sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Shipped_Qty__c','sigmaerpdev2__Delivered_Qty__c','sigmaerpdev2__ProductCode__c','id','sigmaerpdev2__Total_Qty__c','sigmaerpdev2__Account__c','sigmaerpdev2__Quantity_To_Become_Out_Of_Stock__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__Web_Available_Qty__c','sigmaerpdev2__Comments__c'})           
          )        
        {*/
            system.debug('inside fls ');
            List<Inventory__c> newInventory = new List<Inventory__c>();
            newInventory = newInventory1;
            Set<String>inventoryid = new Set<String>();
            Set<String>productId = new Set<String>();
            
            List<Inventory_Transaction__c> inventran = new List<Inventory_Transaction__c>();
            if(isInsert){
                for(Inventory__c inven : newInventory){
                    
                    Inventory_Transaction__c inventrans = new Inventory_Transaction__c();
                    inventrans.Available_Qty__c = inven.Available_Qty__c;
                    inventrans.Purchased_Qty__c = inven.Purchased_Qty__c;
                    inventrans.Reserved_Qty__c = inven.Reserved_Qty__c;
                    inventrans.Shipped_Qty__c = inven.Shipped_Qty__c;
                    inventrans.Delivered_Qty__c = inven.Delivered_Qty__c;
                    inventrans.ProductCode__c = inven.ProductCode__c;
                    inventrans.Inventory_id__c = inven.id;
                    inventrans.Total_Qty__c = inven.Total_Qty__c;
                    inventrans.Account__c = inven.Account__c;
                    inventrans.Quantity_To_Become_Out_Of_Stock__c = inven.Quantity_To_Become_Out_Of_Stock__c;
                    inventrans.Total_Available_Qty__c = inven.Total_Available_Qty__c;
                    inventrans.Web_Available_Qty__c = inven.Web_Available_Qty__c;
                    inventrans.Reason__c = 'Inventory is empty';
                    
                    inventran.add(inventrans);
                }   
            }
            else if(isUpdate){
                for(Inventory__c inven : newInventory){
                    system.debug('inven>>'+inven);
                    system.debug('oldMap.get(inven.id)>>'+oldMap.get(inven.id));
                    if(inven.Available_Qty__c!=oldMap.get(inven.id).Available_Qty__c){
                        Inventory_Transaction__c inventrans = new Inventory_Transaction__c();
                        inventrans.Available_Qty__c = inven.Available_Qty__c;
                        inventrans.Purchased_Qty__c = inven.Purchased_Qty__c;
                        inventrans.Reserved_Qty__c = inven.Reserved_Qty__c;
                        inventrans.Shipped_Qty__c = inven.Shipped_Qty__c;
                        inventrans.Delivered_Qty__c = inven.Delivered_Qty__c;
                        inventrans.ProductCode__c = inven.ProductCode__c;
                        inventrans.Inventory_id__c = inven.id;
                        inventrans.Total_Qty__c = inven.Total_Qty__c;
                        inventrans.Account__c = inven.Account__c;
                        inventrans.Quantity_To_Become_Out_Of_Stock__c = inven.Quantity_To_Become_Out_Of_Stock__c;
                        inventrans.Total_Available_Qty__c = inven.Total_Available_Qty__c;
                        inventrans.Web_Available_Qty__c = inven.Web_Available_Qty__c;
                        inventrans.Reason__c = inven.Comments__c;
                        
                        inventran.add(inventrans);
                    }
                }   
            }
            if(inventran.size()>0)
            {
                insert inventran;
            }   
        //}
        
    }
    
    //removed the code(handlewebavalable()) for bulkification error by chandana
     public void handleAvailableqty(List<Inventory__c> newInventory1,List<Inventory__c> oldInventory,Boolean isUpdate)
    {
        System.debug('TriggerHandler.isBOMtoIndvidual>>'+TriggerHandler.isBOMtoIndvidual);
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'Id','name','sigmaerpdev2__Account__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__Total_Qty__c','sigmaerpdev2__Web_Available_Qty__c','sigmaerpdev2__Comments__c','sigmaerpdev2__Available_Qty__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new Set<String>{'sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__Available_Qty__c'})
           
          )
        {*/
            Set<Id> newInventoryIds = new Set<Id>();
        for(Inventory__c tempInventory : newInventory1)
        {
            newInventoryIds.add(tempInventory.Id);
        }
        system.debug('newInventoryIds---->>>>>>>>>'+newInventoryIds);
        if( TriggerHandler.isBOMtoIndvidual=='BOMTOINDIVIDUAL')
            TriggerHandler.isBOMtoIndvidual='BOMTOINDIVIDUALSTOP';
        System.debug('TriggerHandler.isBOMtoIndvidual>>'+TriggerHandler.isBOMtoIndvidual);
        List<Inventory__c> newInventory = new List<Inventory__c>();
        
        newInventory = [select Id, name,Account__c,Total_Available_Qty__c,Total_Qty__c,Web_Available_Qty__c,Comments__c,Available_Qty__c from Inventory__c where Id in :newInventoryIds];
        system.debug('Product newInventory---->>>>>>>>>'+newInventory);
        List<Inventory__c> CompleteInvenList = new List<Inventory__c>();
        
        if(isUpdate == true)
        {
            system.debug('Product isUpdate---->>>>>>>>>'+isUpdate);
            List<Inventory__c> UpdateInvenList = new List<Inventory__c>();
            Integer i = 0;
            
            for(Inventory__c toupdateinven: newInventory)
            {
                system.debug('Product toupdateinven---->>>>>>>>>'+toupdateinven);
                system.debug('toupdateinven.Total_Available_Qty__c--->>>>>>>>>'+toupdateinven.Total_Available_Qty__c);
                system.debug('oldInventory[i].Total_Available_Qty__c--->>>>>>>>>'+oldInventory[i].Total_Available_Qty__c);
                system.debug('toupdateinven.Comments__c---->>>>>>>>>'+toupdateinven.Comments__c);
                if(toupdateinven.Total_Available_Qty__c > oldInventory[i].Total_Available_Qty__c && toupdateinven.Comments__c!='Inventory Increased due to conversion from INDIVIDUALS to BOM')
                {
                    system.debug('came in');
                    Integer qtyValue = Integer.valueOf((toupdateinven.Total_Available_Qty__c - oldInventory[i].Total_Available_Qty__c));
                    system.debug('check calculated qty nw-->'+qtyValue);
                    Integer value = Integer.valueOf(qtyValue);
                    if ((Schema.sObjectType.Inventory__c.isAccessible()) &&
                        (Schema.sObjectType.Inventory__c.isCreateable()) &&
                        (Schema.sObjectType.Inventory__c.isUpdateable()) &&
                        (Schema.sObjectType.Inventory__c.fields.Available_Qty__c.isAccessible()) &&
                        (Schema.sObjectType.Inventory__c.fields.Available_Qty__c.isCreateable()) &&
                        (Schema.sObjectType.Inventory__c.fields.Available_Qty__c.isUpdateable()))
                    {
                        toupdateinven.Available_Qty__c = (toupdateinven.Available_Qty__c + value);
                    }
                    system.debug('check after adding qty -->'+toupdateinven.Available_Qty__c);
                    try
                    {
                        UpdateInvenList.add(toupdateinven);
                        system.debug('UpdateInvenList-->>>>>>>'+UpdateInvenList);
                    }
                    catch(Exception e)
                    {
                        System.debug('Exception:'+ e);
                    }   
                }
                i++;
            }
            System.debug('UpdateInvenList>>'+UpdateInvenList);
            try
            {
                System.debug('UpdateInvenList>>'+UpdateInvenList);
                System.debug('TriggerHandler.isBOMtoIndvidual>>'+TriggerHandler.isBOMtoIndvidual);
                system.debug('UpdateInvenList.size()-->>>>>>>'+UpdateInvenList.size());
                if(UpdateInvenList.size()>0)
                {
                    if( TriggerHandler.isBOMtoIndvidual=='BOMTOINDIVIDUAL')
                        TriggerHandler.isBOMtoIndvidual='BOMTOINDIVIDUALSTOP';
                    System.debug('TriggerHandler.isBOMtoIndvidual>>'+TriggerHandler.isBOMtoIndvidual);
                    System.debug('isManualILP>>'+isManualILP);  //if true don't update
                    //if(isManualILP!=true)
                    Update UpdateInvenList;
                }
                System.debug('UpdateInvenList after check----->>'+UpdateInvenList);
                System.debug('TriggerHandler.isBOMtoIndvidual>>'+TriggerHandler.isBOMtoIndvidual);
                
            }
            catch(Exception e)
            {
                System.debug('Exception:'+ e);
            } 
        }
        //}
        
    }
    
    
    public Boolean manageSA(List<StockAdjustment__c > SA,Boolean isInsert)
    {
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'id','sigmaerpdev2__Inventory__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Products__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Adjusted_Quantity__c','sigmaerpdev2__Source_Type__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'sigmaerpdev2__Source_Type__c','sigmaerpdev2__Adjusted_Quantity__c','sigmaerpdev2__Received_Quantity__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'id','sigmaerpdev2__ProductCode__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__Comments__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new Set<String>{'sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Comments__c'})
          
          )
        {*/
            Id name =  SA[0].Inventory_Location_Product__c;
            
            Inventory_Location_Product__c ILP;
            ILP =  [select id,Inventory__c,Inventory_Location__c,Products__c,Received_Quantity__c,Adjusted_Quantity__c,Source_Type__c 
                    from Inventory_Location_Product__c where id =: name  ];
            
            if(ILP.Adjusted_Quantity__c == null){
                ILP.Adjusted_Quantity__c = 0;
            }
            ILP.Source_Type__c = 'System';
            if(SA[0].Adjust_Type__c=='Reduce Stock' || SA[0].Adjust_Type__c == null)
            {
                ILP.Received_Quantity__c = ILP.Received_Quantity__c - SA[0].Quantity__c; 
                ILP.Adjusted_Quantity__c = 0-SA[0].Quantity__c;
            }
            else
            {
                ILP.Received_Quantity__c = ILP.Received_Quantity__c + SA[0].Quantity__c; 
                ILP.Adjusted_Quantity__c = SA[0].Quantity__c;
            }
            
            update ILP ;
            
            Inventory__c invent;
            
            invent = [select id, ProductCode__c,Available_Qty__c,Total_Available_Qty__c,Comments__c 
                      from Inventory__c where id=:ILP.Inventory__c];
            
            
            if(SA[0].Adjust_Type__c=='Reduce Stock' || SA[0].Adjust_Type__c == null)
            {
                invent.Total_Available_Qty__c = invent.Total_Available_Qty__c - SA[0].Adjusted_Qty__c;
                invent.Available_Qty__c = invent.Available_Qty__c - SA[0].Adjusted_Qty__c;
                invent.Comments__c = 'Inventory Updated because Stock Reduced';
            }
            else if(SA[0].Adjust_Type__c=='Increase Stock')
            {
                invent.Total_Available_Qty__c = invent.Total_Available_Qty__c + SA[0].Adjusted_Qty__c;
                invent.Comments__c = 'Inventory Updated because Stock Increased';
            }
            
            update invent;
            
       // }
        return true;  
    }
    public Boolean inventoryHandler(List<PackagedProducts__c> packageDatanew,List<PackagedProducts__c> packageDataold,Boolean isInsert,Boolean isUpdate )
    {
        
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'Id','Name','Comments__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Total_Qty__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__ProductCode__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new set<String>{'sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Total_Available_Qty__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'Id','sigmaerpdev2__Returned_Quantity__c','sigmaerpdev2__Delivered_Quantity__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'sigmaerpdev2__Returned_Quantity__c','sigmaerpdev2__Delivered_Quantity__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__PackagedProducts__c',new Set<String>{'sigmaerpdev2__Status__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Returned_Quantity__c','sigmaerpdev2__Inventory_Location_Product__c'})
           
          )
        {*/
            if(isInsert==true)
            {
                if(packageDatanew[0].Status__c=='Consumed')
                {
                    Inventory__c dinc;
                    dinc=[SELECT Id,Available_Qty__c,Total_Qty__c,Total_Available_Qty__c 
                          FROM Inventory__c WHERE ProductCode__c=:packageDatanew[0].Product__c];
                    if(dinc.Total_Available_Qty__c >0 && packageDatanew[0].Quantity__c>0)
                    {
                        dinc.Id=dinc.Id;
                        dinc.Available_Qty__c=(dinc.Available_Qty__c-packageDatanew[0].Quantity__c);
                        dinc.Total_Available_Qty__c=(dinc.Total_Available_Qty__c-packageDatanew[0].Quantity__c);
                        
                        update dinc;
                        
                    }
                    
                }
            }
            if(isUpdate==true)
            {
                List<Id> updatedpdts= new List<Id>();
                Map<Id,Integer> updData=new Map<Id, Integer>();
                
                List<Id> locInvIds=new List<Id>();
                Map<Id,Integer> retLocProd=new Map<Id, Integer>();
                
                List<Inventory_Location_Product__c> newUpdatedLocData=new List<Inventory_Location_Product__c>();
                
                
                for(PackagedProducts__c newPkgData: packageDatanew)
                {            
                    if(newPkgData.Status__c=='Consumed')
                    {
                        updatedpdts.add(newPkgData.Product__c);
                        updData.put(newPkgData.Product__c,Integer.valueOf(newPkgData.Returned_Quantity__c));
                        locInvIds.add(newPkgData.Inventory_Location_Product__c);
                        retLocProd.put(newPkgData.Inventory_Location_Product__c,Integer.valueOf(newPkgData.Returned_Quantity__c));
                    }
                }
                
                List<Inventory__c> listOfInventories;
                
                listOfInventories = [select Id,Name,Available_Qty__c,Total_Available_Qty__c,ProductCode__c,Comments__c from Inventory__c where ProductCode__c in :updatedpdts];
                List<Inventory_Location_Product__c> retLocQnty;
                
                retLocQnty=[SELECT Id,Returned_Quantity__c,Delivered_Quantity__c FROM Inventory_Location_Product__c WHERE Id IN:locInvIds];
                
                for( Inventory__c dp: listOfInventories)
                {
                    dp.Total_Available_Qty__c = dp.Total_Available_Qty__c + updData.get(dp.ProductCode__c);
                    
                }
                
                for(Inventory_Location_Product__c ilp:retLocQnty)
                {
                    
                    ilp.id=ilp.id;
                    if(ilp.Returned_Quantity__c==null)
                    {
                        ilp.Returned_Quantity__c = retLocProd.get(ilp.Id);
                        
                    }else{
                        ilp.Returned_Quantity__c = ilp.Returned_Quantity__c + retLocProd.get(ilp.Id);
                        
                    }
                    
                    
                    ilp.Delivered_Quantity__c=ilp.Delivered_Quantity__c - retLocProd.get(ilp.Id);
                    
                    newUpdatedLocData.add(ilp);
                }
                
                update listOfInventories;
                update newUpdatedLocData;
                
            }
       // }
        return true;
    }
    public Boolean managePBM(List<Product_Batch_Management__c> PBM,Boolean isInsert){
        
        
        return true;
        
    }
    
    private static boolean run = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
    public Boolean ManageCurrenAvail(List<Inventory_Location_Product__c> newIlp, List<Inventory_Location_Product__c> OldILP, Boolean isinsert, Boolean isUpdate)
    {
        
        try
        {
            system.debug('came inside try');
            Map<Id, Integer> ExactpiCountToUpdate = new Map<Id, Integer>();
            Map<Id, Integer> piCountToUpdate = new Map<Id, Integer>();
            Map<Id, Integer> piCountToreduse = new Map<Id, Integer>();
            Map<Id, Integer> AvailInven = new Map<Id, Integer>();
            Set<id> inventoryIds = new Set<id>();
            /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new set<String>{'Id','Name','sigmaerpdev2__Current_Available_Quantity__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__ProductCode__r.RecordType.Name','sigmaerpdev2__ProductCode__c','Comments__c'})
               && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new Set<String>{'sigmaerpdev2__Available_Qty__c'})
               && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'sigmaerpdev2__Source_Type__c','sigmaerpdev2__Inventory__c','sigmaerpdev2__Net_Quantity__c'})
               && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'id','name','RecordType.Name'})
              )
            {*/
                system.debug('called by Convert Bom to Individual apex');
                if(isinsert)
                {
                    for(Inventory_Location_Product__c OneNewILP : newIlp)
                    {
                        if(OneNewILP.Source_Type__c == 'Manual')
                        {
                            if(piCountToUpdate.containsKey((OneNewILP.Inventory__c)))
                            {
                                Integer count2 = piCountToUpdate.get((OneNewILP.Inventory__c))+ Integer.valueOf(OneNewILP.Net_Quantity__c);
                                piCountToUpdate.put((OneNewILP.Inventory__c),count2);
                                system.debug('piCountToUpdate1-->>'+piCountToUpdate);
                            }
                            else
                            {
                                piCountToUpdate.put((OneNewILP.Inventory__c),Integer.valueOf(OneNewILP.Net_Quantity__c));
                                system.debug('piCountToUpdate2-->>'+piCountToUpdate);
                            }
                            
                            inventoryIds.add(OneNewILP.Inventory__c);
                            system.debug('inventoryIds1-->>'+inventoryIds);
                            
                        }
                        
                    }             
                }
                else
                {
                    system.debug('came inside else part for manual'+newIlp);
                    for(Inventory_Location_Product__c OneNewILP : newIlp)
                    {
                         system.debug('OneNewILP-->'+OneNewILP.Source_Type__c);
                        if(OneNewILP.Source_Type__c == 'Manual')
                        {
                             system.debug('piCountToUpdate.containsKey((OneNewILP.Inventory__c))-->'+piCountToUpdate.containsKey((OneNewILP.Inventory__c)));
                            if(piCountToUpdate.containsKey((OneNewILP.Inventory__c)))
                            {
                                 system.debug('piCountToUpdate.get((OneNewILP.Inventory__c))-->'+piCountToUpdate.get((OneNewILP.Inventory__c)));
                                 system.debug('Integer.valueOf(OneNewILP.Net_Quantity__c)-->'+Integer.valueOf(OneNewILP.Net_Quantity__c));
                                Integer count10 = piCountToUpdate.get((OneNewILP.Inventory__c))+ Integer.valueOf(OneNewILP.Net_Quantity__c);
                                piCountToUpdate.put((OneNewILP.Inventory__c),count10);
                                system.debug('count10-->>'+count10);
                                system.debug('aftr adding OneNewILP.Inventory__c to-->>'+piCountToUpdate);
                            }
                            else
                            {
                                system.debug('OneNewILP.Inventory__c-->'+OneNewILP.Inventory__c);
                                system.debug('OneNewILP.Net_Quantity__c->'+Integer.valueOf(OneNewILP.Net_Quantity__c));
                                piCountToUpdate.put((OneNewILP.Inventory__c),Integer.valueOf(OneNewILP.Net_Quantity__c));
                                system.debug('Bom PI available Qty-->'+piCountToUpdate);
                            }
                            inventoryIds.add(OneNewILP.Inventory__c);
                            system.debug('added PI to inventoryIds2-->>'+inventoryIds);
                            isManualILP = true;
                        }
                        /*  else if(TriggerHandler.isBOMtoIndvidual=='BOMTOINDIVIDUALSTOP')
                        {
                        inventoryIds.add(OneNewILP.Inventory__c);
                        system.debug('inventoryIds1-->>'+inventoryIds);
                        }*/
                        //new code added by Anuja
                         system.debug('befr OldILP--->'+OldILP);
                        for(Inventory_Location_Product__c OneOldILP : OldILP)
                        {
                             system.debug('OneNewILP.Source_Type__c--->>>'+OneNewILP.Source_Type__c);
                            system.debug('OneOldILP.Source_Type__c--->>>'+OneOldILP.Source_Type__c );
                            if(OneNewILP.Source_Type__c == 'Manual' && OneOldILP.Source_Type__c == 'System' )
                            {
                                system.debug('OneOldILP.Inventory__c-->>'+OneOldILP.Inventory__c);
                                system.debug('Integer.valueOf(OneOldILP.Net_Quantity__c)-->>'+Integer.valueOf(OneOldILP.Net_Quantity__c));
                                piCountToreduse.put((OneOldILP.Inventory__c),Integer.valueOf(OneOldILP.Net_Quantity__c));
                                system.debug('piCountToreduse1-->>'+piCountToreduse);
                            }
                        }
                    }
                     system.debug('aftr OldILP-->>>'+OldILP);
                    for(Inventory_Location_Product__c OneOldILP : OldILP)
                    {
                         system.debug('OneOldILP.Source_Type__c-->>>'+OneOldILP.Source_Type__c);
                        if(OneOldILP.Source_Type__c == 'Manual')
                        {
                             system.debug('OneOldILP.Inventory__c)-->>'+piCountToreduse.containsKey((OneOldILP.Inventory__c)));
                            if(piCountToreduse.containsKey((OneOldILP.Inventory__c)))
                            {
                                 system.debug('Net_Quantity__c in if-->'+Integer.valueOf(OneOldILP.Net_Quantity__c));
                                Integer count11 = piCountToreduse.get((OneOldILP.Inventory__c)) + Integer.valueOf(OneOldILP.Net_Quantity__c);
                                piCountToreduse.put((OneOldILP.Inventory__c), count11);
                                system.debug('aftr cal count11-->>'+count11);
                                system.debug('piCountToreduse aftr adding count11-->>'+piCountToreduse);
                            }
                            else
                            {
                               system.debug('Net_Quantity__c in else-->'+Integer.valueOf(OneOldILP.Net_Quantity__c));
                                piCountToreduse.put((OneOldILP.Inventory__c),Integer.valueOf(OneOldILP.Net_Quantity__c));
                                system.debug('piCountToreduse2 aftr adding qty-->>'+piCountToreduse);
                            }
                            
                        }
                    }   
                }
                
                List<Id> listOfProIds=new List<Id>();
                
                List<Inventory__c> InventoryList;
                
                InventoryList = [select Id, Name, Current_Available_Quantity__c,Total_Available_Qty__c,Available_Qty__c,ProductCode__r.RecordType.Name,ProductCode__c,Comments__c from Inventory__c where id in: inventoryIds];
                System.debug('Iterating BOM PI from InventoryList>>>'+InventoryList);
                for(Inventory__c currinven : InventoryList)
                {
                    System.debug('currinven in BOM >>>'+currinven);
                    System.debug('available qty in bom pro >>>'+ Integer.valueOf(currinven.Available_Qty__c));
                    AvailInven.put(currinven.Id, Integer.valueOf(currinven.Available_Qty__c));
                    System.debug('AvailInven qty aft adding old qty>>>'+AvailInven);
                    listOfProIds.add(currinven.ProductCode__c);
                    System.debug('listOfProIds>>>'+listOfProIds);
                }
                List<Product2> pros=[ select id,name,RecordType.Name from Product2  where id=:listOfProIds];
                System.debug('pros>>>'+pros);
                List<String>ProType=new List<String>();
                System.debug('ProType>>'+ProType);
                if(TriggerHandler.isBOMtoIndvidual=='BOMTOINDIVIDUALSTOP')
                {
                     system.debug('inside chekc');
                    for(Product2 pro : pros)
                    {
                         system.debug('pro-->'+pro);
                        ProType.add(pro.RecordType.Name);
                    }
                }
                System.debug('ProType>>'+ProType);
                //String ProType='';
                
                System.debug('ExactpiCountToUpdate>>>'+ExactpiCountToUpdate);
                System.debug('piCountToUpdate>>>'+piCountToUpdate);
                
                System.debug('AvailInven>>>'+AvailInven);
                System.debug('ExactpiCountToUpdate>>>'+ExactpiCountToUpdate);
                
                if(isinsert)
                {
                    system.debug('piCountToUpdate keyset--->'+piCountToUpdate.KeySet());
                    set<id> setIds = piCountToUpdate.KeySet();
                    system.debug('setIds--->>>>'+setIds);
                    for(Id check: setIds)
                    {
                        system.debug('inside check1--->'+check);
                        system.debug('inside piCountToUpdate--->'+piCountToUpdate.get(check));
                        Integer value = piCountToUpdate.get(check);
                        system.debug('check value aftr calc --->'+value);
                        system.debug('AvailInven check aftr geting from AvailInven --->'+AvailInven.get(check));
                        value += AvailInven.get(check);
                        system.debug('aftr adding availinv qty --->'+value);
                        ExactpiCountToUpdate.put(check,Integer.valueOf(value));
                        system.debug('ExactpiCountToUpdate 1--->'+ExactpiCountToUpdate);
                    }
                }
                else
                {
                    set<id> setIds = piCountToUpdate.KeySet();
                     system.debug('aftr add piCountToUpdate.KeySet()-->'+setIds);
                    for(Id check: setIds)
                    {
                        system.debug('inside check PI-->'+ check);
                        system.debug('check in piCountToUpdate-->'+ piCountToUpdate.get(check));
                        Integer value = piCountToUpdate.get(check);
                        system.debug(' check Integer value after getng check --->'+value);
                        system.debug('piCountToreduse.get(check) --->'+piCountToreduse.get(check));
                        system.debug('AvailInven.get(check) --->'+AvailInven.get(check));
                        if(TriggerHandler.isIndvidualtoBOM !='StopUpdateManualPI')
                        {
                            if((piCountToreduse.get(check) != null) && (AvailInven.get(check) != null))
                            {
                                system.debug('bfr check value-->'+value+ 'AvailInven.get(check)-->'+AvailInven.get(check)+ 'piCountToreduse.get(check)-->>>' +piCountToreduse.get(check)  );
                                value = value + AvailInven.get(check) - piCountToreduse.get(check);
                                system.debug('value after calculation and adding val+avalinv+picount --->'+value);
                                system.debug('isIndvidualtoBOM --->'+TriggerHandler.isIndvidualtoBOM );
                                system.debug('isManualILP --->'+isManualILP );
                                if(isManualILP &&  TriggerHandler.isIndvidualtoBOM != 'IsManualUpdatePI')     //new to handle twice update of PI in SR after BOMTOIND
                                    ExactpiCountToUpdate.put(check,AvailInven.get(check));
                                else
                                    ExactpiCountToUpdate.put(check,Integer.valueOf(value)); //original line
                                    system.debug('ExactpiCountToUpdate 2--->'+ExactpiCountToUpdate);
                            }
                        }
                            
                        
                    }
                    
                }
                system.debug('before iterating InventoryList-->>'+InventoryList);
                for(Inventory__c newinven: InventoryList)
                {
                    system.debug('newinven--->'+newinven);
                    system.debug('TriggerHandler.isBOMtoIndvidual-->'+TriggerHandler.isBOMtoIndvidual);
                    system.debug('Available_Qty__c-->'+newinven.Available_Qty__c);
                    system.debug('ExactpiCountToUpdate-->'+Integer.valueOf(ExactpiCountToUpdate.get(newinven.Id)));
                 /*   if(newinven.Available_Qty__c<Integer.valueOf(ExactpiCountToUpdate.get(newinven.Id)) && TriggerHandler.isBOMtoIndvidual == 'BOMTOINDIVIDUAL')
                    {
                        newinven.Comments__c='Inventory Increased due to conversion from BOM to INDIVIDUALS';
                    }
                    else if(newinven.Available_Qty__c>Integer.valueOf(ExactpiCountToUpdate.get(newinven.Id)) && TriggerHandler.isBOMtoIndvidual == 'BOMTOINDIVIDUAL')
                    {
                        newinven.Comments__c='Inventory Reduced due to conversion from BOM to INDIVIDUALS';
                    }*/
                    system.debug('ExactpiCountToUpdate contains--->'+ExactpiCountToUpdate.containsKey(newinven.Id));
                    if(ExactpiCountToUpdate.containsKey(newinven.Id))
                    {
                        system.debug('befor cal Integer.valueOf(ExactpiCountToUpdate.get(newinven.Id)-->>>'+Integer.valueOf(ExactpiCountToUpdate.get(newinven.Id)));
                        newinven.Available_Qty__c= Integer.valueOf(ExactpiCountToUpdate.get(newinven.Id));
                        system.debug('aftr cal newinven.Available_Qty__c-->>>'+newinven.Available_Qty__c);
                        system.debug('newinven.Available_Qty__c--->'+newinven.Available_Qty__c);
                        system.debug('newinven.Comments__c-->'+newinven.Comments__c);  
                    }
                   
                    
                }
                system.debug('BOM PI InventoryListAfterUpdate>>'+InventoryList);
                system.debug('TriggerHandler.isBOMtoIndvidual>>'+TriggerHandler.isBOMtoIndvidual);
                 system.debug('inventoryList.size()-->>'+InventoryList.size());
                if(InventoryList.size()>0 && TriggerHandler.isBOMtoIndvidual!='BOMTOINDIVIDUALSTOP')
                {
                    /*  if(InventoryList[0].ProductCode__r.RecordType.Name=='BOM')
InventoryList[0].Comments__c='Inventory Updated due to conversion from BOM to INDIVIDUALS';
else
InventoryList[0].Comments__c='Inventory Updated due to conversion from BOM to INDIVIDUALS';
*/
                    update InventoryList;
                    system.debug('after updating InventoryList1'+InventoryList);
                }
                else if(InventoryList.size()>0 && TriggerHandler.isBOMtoIndvidual==null)
                {
                    update InventoryList;
                    system.debug('after updating InventoryList2'+InventoryList);
                }
                else if(InventoryList.size()>0 && TriggerHandler.isBOMtoIndvidual=='BOMTOINDIVIDUALSTOP' && ProType.contains('BOM'))
                {
                    update InventoryList;
                    system.debug('after updating InventoryList3'+InventoryList);
                    
                }
                
                
                system.debug('BOM InventoryListAfterUpdate>>'+InventoryList);
                
            //}
            return true;
        }
        catch(exception e)
        {
            system.debug('Exception is'+ e);
            return false;
        }
        
    }
    
    ///////////////////////////////////////////////////   
    public Boolean managePOP(List<Purchase_Order__c> PO,Boolean isInsert)
    {
        List<Vendor_Product__c> vendorprd;
        List<String> Prdname  = new List<String>() ;
        List<Product2> Prdvalue;
        List<Inventory__c> inventory;
        Map<Id, Inventory__c> InventoryMap = new Map<Id, Inventory__c>();
        Map<String , Integer> PrdQtyMap = new Map<String ,Integer>();
        List<Id> supplier = new List<Id>();
        List<Id> POId = new List<Id>();
        Map<Id, Id> POMap = new Map<Id, Id>();
        
        Map<Id, Id> IdMapForVendorAndPO = new Map<Id,Id>();
        Map<Id, Id> IdMapForVendorProductAndVendor = new Map<Id,Id>();
        System.debug('Tests>> '+CRUD_FLS_CheckUtility.checkFLS('Purchase_Order_Product__c',new set<String>{'Quantity__c','Product__c','Status__c','Purchase_Order__c','Received_Quantity__c'}));
       /* if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Vendor_Product__c',new set<String>{'Id','Name','sigmaerpdev2__Product_Name__c','sigmaerpdev2__Product_Name__r.Name','sigmaerpdev2__Vendor_Product__c','sigmaerpdev2__Account_Name__r.Id','sigmaerpdev2__Account_Name__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'Id','Name','sigmaerpdev2__Quantity__c','sigmaerpdev2__Reorder_Quantity__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new set<String>{'Id','Name','sigmaerpdev2__ProductCode__c','sigmaerpdev2__Web_Available_Qty__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__Comments__c'})
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order__c',new set<String>{'Id','sigmaerpdev2__Product_Supplier__c','sigmaerpdev2__Product_Supplier__r.Id'})
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order_Product__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order_Product__c',new set<String>{'Id','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Status__c','sigmaerpdev2__Purchase_Order__c','sigmaerpdev2__Received_Quantity__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Purchase_Order_Product__c',new set<String>{'sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Status__c','sigmaerpdev2__Received_Quantity__c'})        
           && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Purchase_Order_Product__c',new set<String>{'sigmaerpdev2__Purchase_Order__c'})
          )
        {*/
            for(Purchase_Order__c porder : PO)
            {
                supplier.add(porder.Product_Supplier__c);
                POId.add(porder.Id);
                POMap.put(porder.Product_Supplier__r.Id , porder.Id);
                IdMapForVendorAndPO.put(porder.Product_Supplier__r.Id, porder.Id);
            }
            
            vendorprd = [select Id,Name,Product_Name__c,Product_Name__r.Name,Vendor_Product__c.Account_Name__r.Id from Vendor_Product__c  where 
                         Account_Name__c IN: supplier];
            
            for(Vendor_Product__c Prd: vendorprd )
            {
                Prdname.add( Prd.Product_Name__c);
                IdMapForVendorProductAndVendor.put(Prd.Id,Prd.Account_Name__r.Id);
                
            }
            
            Prdvalue = [select Id, Name,Quantity__c,Reorder_Quantity__c from Product2 where ID IN :Prdname];
            
            List<Id> prdId = new List<Id>();
            for(Product2 prd : Prdvalue)
            {
                prdId.add(prd.Id);
                PrdQtyMap.put(prd.Id, Integer.valueof(prd.Quantity__c));
            }
            
            inventory  = [select Id, Name,ProductCode__c,Web_Available_Qty__c,Total_Available_Qty__c,Comments__c 
                          from Inventory__c  where ProductCode__c IN : prdId];
            
            List<Purchase_Order_Product__c> POPListToInsert = new List<Purchase_Order_Product__c>(); 
            for(Inventory__c inv :inventory)
            {
                InventoryMap.put(inv.ProductCode__c,inv);
            } 
            
            for(Product2 prd : Prdvalue)
            {
                Purchase_Order_Product__c POP = new Purchase_Order_Product__c();  
                if(InventoryMap.get(prd.Id).Total_Available_Qty__c < prd.Quantity__c )
                {
                    
                    
                    POP.Quantity__c = String.valueof(prd.Reorder_Quantity__c);
                    POP.Product__c =prd.Id; 
                    POP.Status__c = 'Open';
                    
                    POP.Purchase_Order__c=IdMapForVendorAndPO.get
                        (IdMapForVendorProductAndVendor.get(prd.Id));
                    
                    POP.Received_Quantity__c = prd.Reorder_Quantity__c;
                    
                    POPListToInsert.add(POP);
                }
            }
            
            insert POPListToInsert;
            
        //}
        
        return true; 
        
    }
    //code to update ILPLI
    public void getLotProductToILPLI(List<Inventory_Location_Product_Line_Item__c> ILPLI)
    {
        List<String> ProductIDList = new List<String>();
        List<String> LOTIDList= new List<String>();
        Map<String ,Inventory_Location_Product_Line_Item__c > ILPLIMap = new Map<String ,Inventory_Location_Product_Line_Item__c >();
        List<String> ILPLIId = new List<String>(); 
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'Id','sigmaerpdev2__Lot__c','name','sigmaerpdev2__Inventory_Location_Product__r.Products__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Inventory_Location__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot_Product__c',new set<String>{'Id','name','sigmaerpdev2__Location__c','sigmaerpdev2__Product__c','sigmaerpdev2__Lot__c'}) 
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'sigmaerpdev2__Lot_Product__c'})
          )
        {*/
            for(Inventory_Location_Product_Line_Item__c  ILPLIind:ILPLI)
            {
                ILPLIId.add(ILPLIind.Id);
            }  
            
            List<Inventory_Location_Product_Line_Item__c> iplitem = [select Id,Lot__C, name,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Inventory_Location__c from Inventory_Location_Product_Line_Item__c where Id IN: ILPLIId];
            
            for(Inventory_Location_Product_Line_Item__c  ILPLIindiv : iplitem)
            {
                LOTIDList.add(ILPLIindiv.Lot__C);
                ProductIDList.add(ILPLIindiv.Inventory_Location_Product__r.Products__c);
                ILPLIMap.put(ILPLIindiv.Inventory_Location_Product__r.Inventory_Location__c , ILPLIindiv);
            }
            List<Lot_Product__c> ltp = [select Id, name,Location__c from Lot_Product__c where Product__c IN :ProductIDList and Lot__c IN :  LOTIDList];
            List<Inventory_Location_Product_Line_Item__c> ILPLIList = new List<Inventory_Location_Product_Line_Item__c>(); 
            for(Lot_Product__c ltpindiv : ltp)
            {
                Inventory_Location_Product_Line_Item__c ILPLIindiv = new Inventory_Location_Product_Line_Item__c();
                ILPLIindiv.Lot_Product__c = ltpindiv.Id;
                ILPLIindiv.Id = ILPLIMap.get(ltpindiv.Location__c).Id;
                ILPLIList.add(ILPLIindiv);
            }
            update ILPLIList;
        //}
        
    }
    
    public Boolean manageInventoryLocation(List<Stock_In_Product__c> StockInPrd,Boolean isUpdate)
    {
        // Code added by cnk///////////
        
        
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'id','name','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Products__c','sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Products__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location__c',new Set<String>{'id','sigmaerpdev2__Location__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'id','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Total_Qty__c','sigmaerpdev2__ProductCode__c','sigmaerpdev2__Comments__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new Set<String>{'sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__Total_Qty__c','sigmaerpdev2__Comments__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order_Product__c',new Set<String>{'Id','sigmaerpdev2__Status__c','Name','sigmaerpdev2__Remaining_to_come__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Purchase_Order__c','sigmaerpdev2__Received_Quantity__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Purchase_Order_Product__c',new set<String>{'sigmaerpdev2__Status__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__AvailableQuantityRef__c','sigmaerpdev2__Remaining_to_come__c'})           
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Stock_In_Product__c',new Set<String>{'sigmaerpdev2__Status__c','Id','sigmaerpdev2__Purchase_Order__c','sigmaerpdev2__Product__c','sigmaerpdev2__Putaway_location__c','sigmaerpdev2__Quantity_Received__c','sigmaerpdev2__Inventory_Location__c'})
           
          ) 
        { */
            system.debug('StockInPrd>>>'+StockInPrd);
            List<id> productid=new List<id>();
            List<id> locationid=new List<id>();
            
            
            
            for(Stock_In_Product__c ss :StockInPrd)
            {
                productid.add(ss.Product__c);
                locationid.add(ss.Putaway_location__c);
            }
            system.debug('StockInPrd>>>'+StockInPrd);
            List<Inventory_Location_Product__c> ilps=new List<Inventory_Location_Product__c>();
            ilps=[select id,Received_Quantity__c,Inventory_Location__r.Location__c,Products__c from Inventory_Location_Product__c where Products__c =:productid];      
            
            // count += ilps.Inventory_Location_Product_Line_Items__r.size();
            //system.debug('count>>'+count);
            
            List<Inventory_Location__c> ilList=new List<Inventory_Location__c>();
            ilList=[select id,Location__c from Inventory_Location__c where Location__c =: locationid];
            
            List<Inventory__c> PiList=new List<Inventory__c>();
            PiList=[select id,Total_Available_Qty__c,Available_Qty__c,Total_Qty__c,ProductCode__c,Comments__c from Inventory__c where ProductCode__c =: productid];
            system.debug('PiList>>'+PiList);
            Map<ID,Inventory_Location_Product__c> ilpMap=new Map<ID,Inventory_Location_Product__c>();
            List<Id>proids = new List<Id>();
            
            
            Map<ID,Inventory__c> PImap=new Map<ID,Inventory__c>();
            
            Map<ID,Inventory__c> PImapToUpdate=new Map<ID,Inventory__c>();
            
            for(Inventory__c pi: PiList)
            {
                PImap.put(pi.ProductCode__c,pi);
                proids.add(pi.ProductCode__c);
            }
            system.debug('proids>>'+proids);
            
            List<Id> POPID= new List<Id>();
            //code added to handle multiple lot product quantity on 12-10-2019
            Map<id,Map<Id,Decimal>> StkprdMap = new  Map<id,Map<Id,Decimal>>();
            
            for(Stock_In_Product__c ss :StockInPrd)
            { 
                if(ss.Status__c == 'Verified')
                {
                    POPID.add(ss.Purchase_Order__c);
                    system.debug('StkprdMap1>>'+StkprdMap.containsKey(ss.Purchase_Order__c));
                    if(StkprdMap.containsKey(ss.Purchase_Order__c))
                    {
                        //system.debug('StkprdMap2>>'+StkprdMap.get(ss.Purchase_Order__c).containsKey(ss.Product__c));
                        if(StkprdMap.get(ss.Purchase_Order__c).containsKey(ss.Product__c))
                        {
                            Decimal srp=StkprdMap.get(ss.Purchase_Order__c).get(ss.Product__c);
                            system.debug('ss.Quantity_Received__c:::'+ss.Quantity_Received__c);
                            system.debug('srp:::'+srp);
                            srp+=ss.Quantity_Received__c;
                            system.debug('after adding latest qty11>>'+srp);
                            
                            StkprdMap.get(ss.Purchase_Order__c ).put(ss.Product__c,srp);
                        }
                        else
                        {
                            StkprdMap.get(ss.Purchase_Order__c ).put(ss.Product__c,ss.Quantity_Received__c);
                            
                        }
                        system.debug('StkprdMap3>>>>>>>>>'+StkprdMap);
                        
                    }
                    else
                    {
                        Map<Id,Decimal> srpmap=new Map<Id,Decimal>();
                        srpmap.put(ss.Product__c,ss.Quantity_Received__c);
                        system.debug('srpmap1>>>>'+srpmap);
                        StkprdMap.put(ss.Purchase_Order__c , srpmap);
                        system.debug('StkprdMap4>>>>'+StkprdMap);
                    }
                    for(Inventory_Location_Product__c invc: ilps)
                    {
                        
                        //code to handle Avg buying price in PI
                        if(invc.Inventory_Location__r.Location__c==ss.Inventory_Location__c && invc.Products__c==ss.Product__c)
                        {
                            if(invc.Received_Quantity__c==NULL)
                                invc.Received_Quantity__c=0;
                            
                            if(!ilpMap.containsKey(invc.id))
                            {
                                invc.Received_Quantity__c+=ss.Quantity_Received__c;
                                ilpMap.put(invc.id,invc);
                            }
                            
                            else if(ilpMap.containsKey(invc.id))
                            {
                                invc.Received_Quantity__c=ilpMap.get(invc.id).Received_Quantity__c+ss.Quantity_Received__c;
                                ilpMap.put(invc.id,invc);  
                            }
                        }
                    }
                    for(Inventory__c pi : PiList)
                    {
                        if(ss.Product__c==pi.ProductCode__c)
                        {
                            
                            if(pi.Total_Qty__c==NULL)
                                pi.Total_Qty__c=0;
                            
                            if(pi.Total_Available_Qty__c==NULL)
                                pi.Total_Available_Qty__c=0;
                            if(pi.Comments__c=='')
                                pi.Comments__c= 'Inventory is empty';
                            system.debug('PImapToUpdate.containsKey(pi.id)'+PImapToUpdate.containsKey(pi.id));
                            if(!PImapToUpdate.containsKey(pi.id))
                            {
                                system.debug('PImapToUpdate.containsKey(pi.id)'+PImapToUpdate.containsKey(pi.id));
                                pi.Total_Qty__c+=ss.Quantity_Received__c;
                                pi.Total_Available_Qty__c+=ss.Quantity_Received__c;
                                pi.Comments__c='Inventory Updated by "Receiving Stock" from the Product Vendor';
                                system.debug('Inventory Update'+pi.Comments__c);
                                PImapToUpdate.put(pi.id,pi);
                            }
                            
                            else if(PImapToUpdate.containsKey(pi.id))
                            {
                                system.debug('PImapToUpdate.containsKey(pi.id)'+PImapToUpdate.containsKey(pi.id));
                                pi.Total_Qty__c=PImapToUpdate.get(pi.id).Total_Qty__c+ss.Quantity_Received__c;
                                pi.Total_Available_Qty__c=PImapToUpdate.get(pi.id).Total_Available_Qty__c+ss.Quantity_Received__c;
                                pi.Comments__c='Inventory Updated by "Receiving Stock" from the Product Vendor';
                                system.debug('Inventory Update'+pi.Comments__c);
                                PImapToUpdate.put(pi.id,pi);
                            }
                            
                        }
                    }
                    
                    
                }
            } 
            List<Purchase_Order_Product__c> POPList = new List<Purchase_Order_Product__c>();
            POPList = [select Id,Product__c,Remaining_to_come__c,Received_Quantity__c, Name ,
                       Quantity__c,Status__c from Purchase_Order_Product__c  where Id IN: POPID];
            
            List<Purchase_Order_Product__c> POPListToUpdate = new List<Purchase_Order_Product__c>();
            for(Purchase_Order_Product__c POP : POPList)
            {
                Purchase_Order_Product__c POPval = new Purchase_Order_Product__c();
                system.debug('POP id>> '+StkprdMap.containsKey(POP.id));
                system.debug('POP product>> '+StkprdMap.get(POP.id).containsKey(POP.Product__c));
                if(StkprdMap.containsKey(POP.id) && StkprdMap.get(POP.id).containsKey(POP.Product__c))
                {
                    system.debug('Rec Qty1>>'+POP.Received_Quantity__c);
                    system.debug('Rec Qty2>>'+StkprdMap.get(POP.id).get(POP.Product__c));
                    if(POP.Received_Quantity__c > StkprdMap.get(POP.id).get(POP.Product__c))
                    {
                        POPval.Status__c='Partial Delivery';
                        system.debug('Rec Qty1111>>'+POPval.Received_Quantity__c);
                        POPval.Received_Quantity__c = Integer.valueof(POP.Received_Quantity__c)-StkprdMap.get(POP.id).get(POP.Product__c);
                        system.debug('Rec Qty222>>'+POPval.Received_Quantity__c);
                    } 
                    else
                    {
                        POPval.Status__c='Received';
                        POPval.Received_Quantity__c = Integer.valueof(POP.Received_Quantity__c)-StkprdMap.get(POP.id).get(POP.Product__c);
                        //need to ask pooja where this feild used
                        POPval.AvailableQuantityRef__c = StkprdMap.get(POP.id).get(POP.Product__c);//.Available_quantity__c
                    }
                    system.debug('Remaining Qty>>'+POP.Remaining_to_come__c);
                    system.debug('Received Qty>>>>>>'+StkprdMap.get(POP.id).get(POP.Product__c));
                    POPval.Remaining_to_come__c = (POP.Remaining_to_come__c + StkprdMap.get(POP.id).get(POP.Product__c)); 
                    system.debug('Remaining Qty>>'+POP.Remaining_to_come__c);
                    POPval.Id = POP.Id;
                    POPListToUpdate.add(POPval); 
                    system.debug('before update POPListToUpdate111>>>>'+POPListToUpdate);
                } 
            }
            try{
                update POPListToUpdate;
                system.debug('after update POPListToUpdate>>>>'+POPListToUpdate);
                update ilpMap.values();
                update PImapToUpdate.values();
                system.debug('PImapToUpdate>>'+PImapToUpdate);
                
            }
            catch(Exception ex)
            {
                System.debug('Error while updating ilpMap values or ilMap values '+ex.getDMLMessage(0));
            }  
        //}
        return true;
    }
    
    /* ------------------------------------------------------------
Author  :  Javed .
Company :  Mindlinks .
Description : Get the all the field access permision which is passed in set.

Inputs  : Order Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-10-2016  javed               Its checks the access permision of passed object and field.
------------------------------------------------------------ */
    Boolean listContains(Object[] source, Object target) 
    {
        return (new Set<Object>(source)).contains(target);
    }
    
}