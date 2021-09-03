public with sharing Class CancelOrderManagement
{
     
    public List<String> productIds;  
    public Decimal tax_amount; 
    private static String REFUND_CHARGE_URL = '';
    private static String API_KEY = '';
    public String balance_transaction;
    public String charge;
    public String status; 
    
    public void manageProductsOnCancelOrder(Id orderId , Id productId , Integer selectedQuantity, Double subTotalAmount,String refundedTransId,String PaymentMode)
    {
        /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Default_Parameters__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Payment__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Order_Payment__c')
           
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new set<String>{'id','name','sigmaerpdev2__Quantity__c','sigmaerpdev2__Tax_Amount__c, sigmaerpdev2__Order_Created_Via__c, sigmaerpdev2__Net_Quantity__c, sigmaerpdev2__Orders_Status__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new set<String>{'id','name','sigmaerpdev2__Delivered_Qty__c,sigmaerpdev2__Total_Qty__c,sigmaerpdev2__Reserved_Qty__c,sigmaerpdev2__Available_Qty__c,sigmaerpdev2__Web_Available_Qty__c,sigmaerpdev2__Purchased_Qty__c ,sigmaerpdev2__Total_Available_Qty__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Default_Parameters__c', new set<String>{'Id','sigmaerpdev2__Inventory_Status__c','sigmaerpdev2__Package_ID__c','sigmaerpdev2__Parent_Id__c','sigmaerpdev2__Shipment_ID__c,sigmaerpdev2__StockReceiving_ID__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'id','name','sigmaerpdev2__Product__c','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__Order_Status__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__tax_amount__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Payment__c',new set<String>{'id','name','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__Customer_Name__c','sigmaerpdev2__Order_Type__c','sigmaerpdev2__Tax_Amount__c','sigmaerpdev2__Order_Created_Via__c','sigmaerpdev2__Customer_Email__c','sigmaerpdev2__Transaction_Type__c','sigmaerpdev2__Sigma_Order__r.id '})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Order_Payment__c',new set<String>{'id','name','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__Amount__c','sigmaerpdev2__Ordered_Product__c','sigmaerpdev2__Payment__c','sigmaerpdev2__Payment_Type__c','sigmaerpdev2__Refunded_Amount__c'})
           
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Order__c',new set<String>{'sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Orders_Status__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev2__Order_Status__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new set<String>{'sigmaerpdev2__Web_Available_Qty__c','sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Purchased_Qty__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Delivered_Qty__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Payment__c',new set<String>{'sigmaerpdev2__Status__c','sigmaerpdev2__Amount__c','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__Customer_Name__c','sigmaerpdev2__Customer_Email__c','sigmaerpdev2__Transaction_Type__c','sigmaerpdev2__PayPal_Transaction_Id__c','sigmaerpdev2__Tax_Amount__c','sigmaerpdev2__Payment_Mode__c','sigmaerpdev2__Order_Created_Via__c','sigmaerpdev2__Order_Type__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Order_Payment__c',new set<String>{'sigmaerpdev2__Refunded_Amount__c','sigmaerpdev2__Payment_Type__c'})
          )
        {*/
            
            Boolean checkAllProdStatus = true;
            Sigma_Order__c orderData;
            
            orderData = [SELECT id, name,Quantity__c,Tax_Amount__c, Order_Created_Via__c, Net_Quantity__c, Orders_Status__c FROM Sigma_Order__c WHERE id=:orderId];
            
            Inventory__c productInventory;
            
            productInventory = [SELECT  id,name,Delivered_Qty__c,Total_Qty__c,Reserved_Qty__c,Available_Qty__c,Web_Available_Qty__c,Purchased_Qty__c ,Total_Available_Qty__c from Inventory__c WHERE ProductCode__c=:productId];
            
            
            if(orderData.Order_Created_Via__c == 'Web_Order')
            {   
                Integer manageQuantity = Integer.valueOf(productInventory.Web_Available_Qty__c) + Integer.valueOf(selectedQuantity);
                Integer managereserved = Integer.valueOf(productInventory.Reserved_Qty__c) - Integer.valueOf(selectedQuantity);
                Integer managepurcheased = Integer.valueOf(productInventory.Purchased_Qty__c) - Integer.valueOf(selectedQuantity);
                
                productInventory.Web_Available_Qty__c = manageQuantity;
                productInventory.Reserved_Qty__c = managereserved;
                productInventory.Purchased_Qty__c = managepurcheased;   
                
            }
            else
            {
                Default_Parameters__c options;
                
                options = [select Id,Inventory_Status__c,Package_ID__c,Parent_Id__c,Shipment_ID__c,StockReceiving_ID__c from Default_Parameters__c limit 1];
                
                String inventorystatus = options.Inventory_Status__c; 
                
                productInventory.Available_Qty__c  = productInventory.Available_Qty__c + Integer.valueOf(selectedQuantity);
                if(inventorystatus =='Reserve')
                {   
                    productInventory.Reserved_Qty__c = productInventory.Reserved_Qty__c - Integer.valueOf(selectedQuantity);
                }
                else
                {   
                    productInventory.Delivered_Qty__c  = productInventory.Delivered_Qty__c - Integer.valueOf(selectedQuantity);
                }
                
            }
            
            update productInventory;
            
            Product_Order_Price_Book__c orderProduct;
            
            
            orderProduct = [SELECT  id,name,Order_Status__c,Quantity__c,Net_Quantity__c,tax_amount__c from Product_Order_Price_Book__c WHERE Product__c=:productId and Sigma_Order__c = :orderId ];
            
            
            tax_amount = orderProduct.tax_amount__c;
            
            orderProduct.Net_Quantity__c = Integer.valueOf(orderProduct.Net_Quantity__c)-Integer.valueOf(selectedQuantity);
            if(orderProduct.Net_Quantity__c == 0)
            {
                orderProduct.Order_Status__c = 'Canceled';
            }
            
            
            update orderProduct;
            
            List<Product_Order_Price_Book__c> allOrderProdList;
            
            allOrderProdList = [SELECT id,name,Order_Status__c FROM Product_Order_Price_Book__c WHERE Sigma_Order__c = :orderId];
            
            for(Product_Order_Price_Book__c prodList :allOrderProdList)
            {
                if(prodList.Order_Status__c != 'Canceled')
                {
                    checkAllProdStatus = false;
                }
            }
            
            orderData.Net_Quantity__c = Integer.valueOf(orderData.Net_Quantity__c)-Integer.valueOf(selectedQuantity);
            if(checkAllProdStatus != false)
            {
                orderData.Orders_Status__c = 'Canceled';
            }
            
            
            update orderData;
            
            
            
            //Added on 20th May
            Payment__c insertPayment = new Payment__c();
            List<Payment__c> orderPayments;
            
            orderPayments = [SELECT id,Sigma_Order__c,Customer_Name__c,Order_Type__c,Tax_Amount__c,Order_Created_Via__c,Customer_Email__c,Transaction_Type__c FROM Payment__c WHERE Sigma_Order__r.id = :orderId];
            
            
            insertPayment.Status__c = 'Refunded';
            insertPayment.Amount__c = Double.valueOf(subTotalAmount);
            insertPayment.Sigma_Order__c = orderPayments[0].Sigma_Order__c;
            insertPayment.Customer_Name__c = orderPayments[0].Customer_Name__c;
            insertPayment.Customer_Email__c = orderPayments[0].Customer_Email__c;
            insertPayment.Transaction_Type__c = orderPayments[0].Transaction_Type__c;
            insertPayment.PayPal_Transaction_Id__c = refundedTransId;
            insertPayment.Tax_Amount__c=tax_amount;         
            if(PaymentMode!= null || PaymentMode != '')
            {
                insertPayment.Payment_Mode__c = PaymentMode;
                insertPayment.Order_Created_Via__c = orderPayments[0].Order_Created_Via__c;
            }
            if(orderData.Order_Created_Via__c == 'Web_Order')
            {
                insertPayment.PayPal_Transaction_Id__c = refundedTransId;
            }
            else
            {
                insertPayment.Order_Type__c = 'Offline';
            }
            
            
            insert insertPayment;
            
            Order_Payment__c orderPaymentstochange;
            
            orderPaymentstochange = [SELECT id,Sigma_Order__c,Amount__c,Ordered_Product__c,Payment__c,Payment_Type__c,Refunded_Amount__c FROM Order_Payment__c WHERE Sigma_Order__c = :orderId limit 1];
            
            
            orderPaymentstochange.Refunded_Amount__c = orderPaymentstochange.Refunded_Amount__c + Double.valueOf(subTotalAmount);
            if(orderPaymentstochange.Refunded_Amount__c == orderPaymentstochange.Amount__c)
            {
                orderPaymentstochange.Payment_Type__c = 'Refund';
            }
            else
            {
                orderPaymentstochange.Payment_Type__c = 'Partial Refund';
            }
            
            
            update orderPaymentstochange;
            
            //Till here
        //}
        
    }
    
    Boolean listContains(Object[] source, Object target)
    {
        return (new Set<Object>(source)).contains(target);
     }
    
        public void manageOrderOnCancel(Id orderId, Decimal subTotalAmount, String refundedTransId, String PaymentMode)
    {
       /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Order_Usage__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Default_Parameters__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Dimension_Tag__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Allocation__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Package__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Serial_Number__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Lot__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Lot_Product__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Time_Base_Inventory__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__PackagedProducts__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Package_Product_Line_Item__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Payment__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Account_Subscription_Intervals__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Invoice__c')
            
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Order_Usage__c',new set<String>{'Id','sigmaerpdev2__Sigma_order__c','sigmaerpdev2__Standard_object__c','sigmaerpdev2__Allocation_in_Sales_Order__c','sigmaerpdev2__Allocation_in_Picking__c','sigmaerpdev2__Auto_Allocate_in_picking__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Default_Parameters__c',new set<String>{'Id','sigmaerpdev2__Inventory_Status__c','sigmaerpdev2__Default_Location__c','sigmaerpdev2__Default_Bin__c','sigmaerpdev2__Package_ID__c','sigmaerpdev2__Parent_Id__c','sigmaerpdev2__Shipment_ID__c','sigmaerpdev2__StockReceiving_ID__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location__c',new set<String>{'id','name','sigmaerpdev2__Location__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Invoice__c',new set<String>{'id','name','Invoice_Status__c','SO__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Dimension_Tag__c',new set<String>{'id','sigmaerpdev2__Base_Credit_Limit__c','sigmaerpdev2__Ordered_Amount__c','sigmaerpdev2__Paid_Amount__c','Account__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'id','sigmaerpdev2__Quantity__c','sigmaerpdev2__Tax_Amount__c','sigmaerpdev2__Order_Created_Via__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Net_Amount__c','sigmaerpdev2__Orders_Status__c','sigmaerpdev2__No_Picking_Package_Shipment_Required__c','AccountId','Customer_Type__c','sigmaerpdev2__Last_Refund_Date_Time__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'id','name','PriceBookEntry.Product2.Id','Quantity','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__IsInventoryUpdated__c','sigmaerpdev2__Order_Status__c','sigmaerpdev2__Is_Credit_Updated__c','sigmaerpdev2__TotalPrice__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Allocation__c',new set<String>{'id','Name','sigmaerpdev2__ILPLI__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__ILPLI__r.sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__ILPLI__r.sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Picked_Quantity__c','sigmaerpdev2__ILPLI__r.sigmaerpdev2__Bin__c','sigmaerpdev2__ILPLI__r.sigmaerpdev2__Lot__c','sigmaerpdev2__ILPLI__r.sigmaerpdev2__Product__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new set<String>{'id','name','sigmaerpdev2__Quantity__c','sigmaerpdev2__No_Picking_Package_Shipment_Required__c','sigmaerpdev2__Tax_Amount__c','sigmaerpdev2__Order_Created_Via__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Orders_Status__c','sigmaerpdev2__TotalAmount__c','sigmaerpdev2__Customer_Type__c','sigmaerpdev2__Account_Subscription_Interval__c','sigmaerpdev2__Account_Subscription_Interval__r.Name'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'id','name','sigmaerpdev2__Order_Status__c','sigmaerpdev2__Inventory_Status__c','sigmaerpdev2__IsInventoryUpdated__c','sigmaerpdev2__Product__c','sigmaerpdev2__tax_amount__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Packaged_Quantity__c','sigmaerpdev2__TotalPrice__c','sigmaerpdev2__Is_Credit_Updated__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Package__c',new set<String>{'id','name','sigmaerpdev2__Canceled_Package__c','sigmaerpdev2__Order__c','sigmaerpdev2__Sigma_Order__c'})      
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'id','name','sigmaerpdev2__Deliver_Quantity__c','sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Products__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c','sigmaerpdev2__Inventory__c','sigmaerpdev2__Received_Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'id','name','sigmaerpdev2__Bin__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Adjusted_Quantity1__c','sigmaerpdev2__Product__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c','sigmaerpdev2__Product_Serial_Number__c','sigmaerpdev2__Delivered_Quantity__c','sigmaerpdev2__Product_Serial_Number__r.sigmaerpdev2__Status__c','sigmaerpdev2__Lot__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Serial_Number__c',new set<String>{'id','name','sigmaerpdev2__Status__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Order_Line__c','sigmaerpdev2__Package_Status__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot__c',new set<String>{'id','name'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot_Product__c',new set<String>{'id','name','sigmaerpdev2__Location__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Time_Base_Inventory__c',new set<String>{'id','name','sigmaerpdev2__Order__c','sigmaerpdev2__Proposal_to_Order__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new set<String>{'id','name','sigmaerpdev2__ProductCode__c','sigmaerpdev2__Delivered_Qty__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Web_Available_Qty__c','sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Purchased_Qty__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__Picked_Quantity__c','sigmaerpdev2__Packaged_Quantity__c','sigmaerpdev2__Comments__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__PackagedProducts__c',new set<String>{'id','name','sigmaerpdev2__Order__r.Id','sigmaerpdev2__Product__r.Id','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Canceled_Package__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Status__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Package__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Package_Product_Line_Item__c',new set<String>{'id','name','sigmaerpdev2__Packaged_Product__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c '})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Payment__c',new set<String>{'id','name','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__OrderId__c','sigmaerpdev2__Customer_Name__c','sigmaerpdev2__Tax_Amount__c','sigmaerpdev2__Credit_CardNumber__c','sigmaerpdev2__Card_Type__c','sigmaerpdev2__State_Tax__c','sigmaerpdev2__Customer_SFID__c','sigmaerpdev2__Federal_Tax__c','sigmaerpdev2__PayPal_Transaction_Id__c','sigmaerpdev2__Charge_Id__c','sigmaerpdev2__Order_Created_Via__c','sigmaerpdev2__Customer_Email__c','sigmaerpdev2__Transaction_Type__c','sigmaerpdev2__OrderId__r.id','sigmaerpdev2__Sigma_Order__r.id'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Account_Subscription_Intervals__c',new set<String>{'id','name','sigmaerpdev2__Usage_Type__c','sigmaerpdev2__Payment_Status__c','sigmaerpdev2__Order_Status__c'})
            
            &&  CRUD_FLS_CheckUtility.checkFLS('Order',new set<String>{'sigmaerpdev2__Orders_Status__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Last_Refund_Date_Time__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('OrderItem',new set<String>{'sigmaerpdev2__Order_Status__c','sigmaerpdev2__Packaged_Quantity__c','sigmaerpdev2__Remaining_Qty_To_Package__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Order__c',new Set<String>{'sigmaerpdev2__Orders_Status__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Last_Refund_Date_Time__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Dimension_Tag__c',new Set<String>{'sigmaerpdev2__Ordered_Amount__c','sigmaerpdev2__Paid_Amount__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev2__Packaged_Quantity__c','sigmaerpdev2__Order_Status__c','sigmaerpdev2__Remaining_Qty_To_Package__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Net_Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Package__c',new Set<String>{'sigmaerpdev2__Canceled_Package__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev2__Deliver_Quantity__c','sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Products__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Inventory__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Adjusted_Quantity1__c','sigmaerpdev2__Delivered_Quantity__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Product_Serial_Number__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Product__c','sigmaerpdev2__Received_Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Serial_Number__c',new Set<String>{'sigmaerpdev2__Status__c','sigmaerpdev2__Package_Status__c','sigmaerpdev2__Serial_Number__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Product_Code__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Lot_Product__c',new Set<String>{'sigmaerpdev2__Quantity__c','sigmaerpdev2__Location__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Product__c','sigmaerpdev2__Bin__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new Set<String>{'sigmaerpdev2__Packaged_Quantity__c','sigmaerpdev2__Picked_Quantity__c','sigmaerpdev2__Delivered_Qty__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Purchased_Qty__c','sigmaerpdev2__Web_Available_Qty__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Payment__c',new Set<String>{'sigmaerpdev2__OrderId__c','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__Status__c','sigmaerpdev2__Amount__c','sigmaerpdev2__Tax_Amount__c','sigmaerpdev2__Credit_CardNumber__c','sigmaerpdev2__Card_Type__c','sigmaerpdev2__State_Tax__c','sigmaerpdev2__Customer_SFID__c','sigmaerpdev2__Federal_Tax__c','sigmaerpdev2__PayPal_Transaction_Id__c','sigmaerpdev2__Charge_Id__c','sigmaerpdev2__Customer_Name__c','sigmaerpdev2__Customer_Email__c','sigmaerpdev2__Transaction_Type__c','sigmaerpdev2__Payment_Mode__c','sigmaerpdev2__Order_Created_Via__c','sigmaerpdev2__Order_Type__c'})  
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Account_Subscription_Intervals__c',new Set<String>{'sigmaerpdev2__Order_Status__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Invoice__c',new Set<String>{'sigmaerpdev2__Invoice_Status__c'})          
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Sigma_Order__c',new Set<String>{'sigmaerpdev2__AccountId__c'})
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev2__Sigma_Order__c'})
            )
        { */
            try
            {
            
                Order_Usage__c Orderusageoptions;
                Orderusageoptions = [select Id,Sigma_order__c,Standard_object__c,Allocation_in_Sales_Order__c,Allocation_in_Picking__c,Auto_Allocate_in_picking__c from Order_Usage__c limit 1];
                Integer manageQuantity;
                Integer managereserved;
                Integer managepurcheased;
                Integer manageDeliveredQty;
                Integer managepicked;
                Integer managepackage;
                Integer manageTotalAvailableQuantity;
                Sigma_Order__c orderData;
                order standorder;
                decimal pickedQuant=0;
                Boolean inventoryallocated=false;
                Boolean Nopickpack;
                Boolean ispackaged = false;
                String Orderlinestatus;
                String Orderstatus;
                Id Inventoryloc;
                Default_Parameters__c options;
                Decimal CreditAmount =0;
                
                
                options = [select Id,Inventory_Status__c,Default_Bin__c,Default_Location__c,Package_ID__c,Parent_Id__c,Shipment_ID__c,StockReceiving_ID__c from Default_Parameters__c limit 1];
                
                String  inventorystatus = options.Inventory_Status__c;
                String  Defaultlocation = options.Default_Location__c;
                String  Defaultbin = options.Default_Bin__c; 
                List<Inventory_Location__c>InventoryLocation = new List<Inventory_Location__c>();     
                // InventoryLocation=database.query('select id,name,Location__c from Inventory_Location__c where Location__c=:'+Defaultlocation);
                InventoryLocation=[select id,name,Location__c from Inventory_Location__c where id =:Defaultlocation];
                if(InventoryLocation.size()>0)
                Inventoryloc = InventoryLocation[0].id; 
                Map<String,Integer> productQuantity = new Map<String,Integer>();
                if(Orderusageoptions.Standard_object__c == true && inventorystatus == 'Reserve' )
                {
                    
                    standorder = [SELECT id,Quantity__c,Tax_Amount__c, Order_Created_Via__c, Net_Quantity__c,Net_Amount__c,Orders_Status__c,No_Picking_Package_Shipment_Required__c,Customer_Type__c,AccountId FROM Order WHERE id=:orderId];
                    Nopickpack = standorder.No_Picking_Package_Shipment_Required__c;
                    List<OrderItem> orderStatusUpdate = new List<OrderItem>();
                    List<OrderItem> orderProducts;
                    orderProducts = [SELECT id,PriceBookEntry.Product2.Id,Quantity,Net_Quantity__c,IsInventoryUpdated__c,Order_Status__c,Is_Credit_Updated__c,TotalPrice__c,(Select id,Name,ILPLI__c,Quantity__c,ILPLI__r.Available_Quantity__c,ILPLI__r.Reserved_Quantity__c,Picked_Quantity__c,ILPLI__r.Bin__c from Inventory_Allocations__r ) FROM OrderItem WHERE OrderId=:orderId AND Order_Status__c != 'Canceled'];
                    productIds = new List<String>();
                    Map<id,decimal> ReservedQuant=new Map<id,decimal>();
                    Map<id,decimal> BinQunt = new map<id,decimal>();
                    List<Id>ProductID=new List<Id>();
                    set<Id>Productserialnumber=new set<Id>();
                    List<Id>LocationID=new List<Id>();
                    List<Id>BinId=new List<Id>();
                    
                    for(OrderItem productsData:orderProducts)
                    {
                        for(Inventory_Allocation__c Allocateproduct: productsData.Inventory_Allocations__r )
                        {
                            if(ReservedQuant.containsKey(Allocateproduct.ILPLI__c))
                            {
                                decimal totalqyt = ReservedQuant.get(Allocateproduct.ILPLI__c);
                                ReservedQuant.put(Allocateproduct.ILPLI__c,totalqyt+Allocateproduct.Quantity__c);
                            }
                            else
                            {
                                ReservedQuant.put(Allocateproduct.ILPLI__c,Allocateproduct.Quantity__c);
                            }
                            
                            
                            if(Allocateproduct.Picked_Quantity__c==null)
                                Allocateproduct.Picked_Quantity__c=0;
                               pickedQuant+=Allocateproduct.Picked_Quantity__c;
							   if(BinQunt.containsKey(Allocateproduct.ILPLI__r.Bin__c))
							   {
								  BinQunt.put(Allocateproduct.ILPLI__r.Bin__c,BinQunt.get(Allocateproduct.ILPLI__r.Bin__c)+Allocateproduct.Picked_Quantity__c); 
							   }
							   else
							   {
								 BinQunt.put(Allocateproduct.ILPLI__r.Bin__c,Allocateproduct.Picked_Quantity__c);  
							   }
                               
                            
                        } 
                        if(productsData.Is_Credit_Updated__c)
                        CreditAmount += productsData.TotalPrice__c;
                        if(productsData.Order_Status__c == 'Packaged')
                        ispackaged =true;
                        Orderstatus = productsData.Order_Status__c;
                        if(inventoryallocated!=true)
                        inventoryallocated = productsData.IsInventoryUpdated__c;      
                        
                        OrderItem orderUpdate = new OrderItem();
                        productIds.add(productsData.PriceBookEntry.Product2Id);
                        if(productsData.IsInventoryUpdated__c)
                        {
                            if(productQuantity.containsKey(productsData.PriceBookEntry.Product2Id))
                            {
                                Integer netqty= productQuantity.get(productsData.PriceBookEntry.Product2Id);
                                productQuantity.put(productsData.PriceBookEntry.Product2Id,Integer.valueOf(productsData.Quantity)+netqty);
                            }
                            else
                            {
                                productQuantity.put(productsData.PriceBookEntry.Product2Id,Integer.valueOf(productsData.Quantity)); 
                            }
                        }
                        
                        orderUpdate.Id = productsData.id;
                        //orderUpdate.Net_Quantity__c = 0;
                        //orderUpdate.Quantity = orderUpdate.Net_Quantity__c;
                        orderUpdate.Remaining_Qty_To_Package__c=0;
                        orderUpdate.Order_Status__c = 'Canceled';
                        if(orderUpdate.Packaged_Quantity__c==null)
                        orderUpdate.Packaged_Quantity__c = 0;
                        orderStatusUpdate.add(orderUpdate);
                    }
                    update orderStatusUpdate;
                 
                    //code to update cancelorder checkbox in package
                
                    if(ispackaged)
                    {
                       Package__c packageproduct = [select id,Name,Canceled_Package__c from Package__c where Order__c=:standorder.id];
                       if(packageproduct !=null)
                       {
                            packageproduct.Canceled_Package__c = true;
                            update packageproduct; 
                       }
                       
                    }
                    
                    List<Inventory_Location_Product_Line_Item__c>updateILPLI=new List<Inventory_Location_Product_Line_Item__c>();
                    updateILPLI=[select id,name,Bin__c,Inventory_Location_Product__c,Reserved_Quantity__c,Adjusted_Quantity1__c,Product__c,Inventory_Location__c,Product_Serial_Number__c,Delivered_Quantity__c,Package_Quantity__c from Inventory_Location_Product_Line_Item__c where id=:ReservedQuant.keySet()];
                    Map<id,decimal> ilpmap=new Map<id,decimal>();
                    for(Inventory_Location_Product_Line_Item__c ilpli:updateILPLI)
                    {
                        
                        
                        if(ilpli.Product_Serial_Number__c!=null)
                        {
                            Productserialnumber.add(ilpli.Product_Serial_Number__c);
                            
                        }
                        
                        if(ilpli.Product__c!=null)
                        {
                            ProductID.add(ilpli.Product__c);
                        }
                        if(ilpli.Inventory_Location__c!=null)
                        {
                            LocationID.add(ilpli.Inventory_Location__c);
                        }
                        
                        if(ilpli.Bin__c!=null)
                            {
                               BinId.add(ilpli.Bin__c); 
                            }
                        if(ReservedQuant.containsKey(ilpli.id))
                        {
                            if(Nopickpack && pickedQuant==0)
                            {
                                ilpli.Delivered_Quantity__c-=ReservedQuant.get(ilpli.id);
                            }   
                            else if(ilpli.Reserved_Quantity__c!=0 && ilpli.Reserved_Quantity__c!=NULL && pickedQuant==0)
                            {
                                ilpli.Reserved_Quantity__c-=ReservedQuant.get(ilpli.id);    
                            }
                            if(ilpli.Adjusted_Quantity1__c!=0 && ilpli.Adjusted_Quantity1__c!=NULL && pickedQuant > 0 && Orderstatus != 'Packaged')
                                ilpli.Adjusted_Quantity1__c-=ReservedQuant.get(ilpli.id);
                            if(Orderstatus == 'Packaged' && Nopickpack !=true)
							{
								ilpli.Package_Quantity__c -=ReservedQuant.get(ilpli.id);
							}
							
                            if(ilpmap.containsKey(ilpli.Inventory_Location_Product__c))
                            {
                                decimal qty= ilpmap.get(ilpli.Inventory_Location_Product__c);
                                
                                ilpmap.put(ilpli.Inventory_Location_Product__c,qty+ReservedQuant.get(ilpli.id));
                            }
                            else
                            {
                                ilpmap.put(ilpli.Inventory_Location_Product__c,ReservedQuant.get(ilpli.id));
                            }
                            
                        }
                        
                        
                    }
                    update updateILPLI;
                    update orderStatusUpdate;
                    List<Inventory_Location_Product__c> ILPLIST= [select id,name,Deliver_Quantity__c,Reserved_Quantity__c,Picked_Quantity__c,Package_Quantity__c from Inventory_Location_Product__c where id=:ilpmap.keySet()];
                    
                    for(Inventory_Location_Product__c ilp:ILPLIST)
                    {
                        if(Nopickpack && ilpmap.containsKey(ilp.id))
                        {
                            ilp.Deliver_Quantity__c -= ilpmap.get(ilp.id);
                        }
                        else if(ilpmap.containsKey(ilp.id) && pickedQuant==0)
                        {
                            ilp.Reserved_Quantity__c-=ilpmap.get(ilp.id);
                        }
						else if(pickedQuant > 0 && ilp.Picked_Quantity__c!=null && Orderstatus != 'Packaged')
						{
							ilp.Picked_Quantity__c-=ilpmap.get(ilp.id);
						}
						else if(Orderstatus == 'Packaged' && Nopickpack !=true)
						{
							ilp.Package_Quantity__c -=ilpmap.get(ilp.id);
						}
                        
                    }
                    update ILPLIST;
                    if(Productserialnumber.size()>0)
                    {
                        List<Product_Serial_Number__c> serialststusupdate=new List<Product_Serial_Number__c>();
                        serialststusupdate=[select id,name,Status__c from Product_Serial_Number__c where id=:Productserialnumber];
                        for(Product_Serial_Number__c serialstatus:serialststusupdate)
                        {
                            serialstatus.Status__c='Available';
                        }
                        update serialststusupdate;
                        
                    }
                    //updating LOT Product2
                     List<Lot_Product__c>Lotproduct=[Select id,Name,Location__c,Bin__c,Product__c,Quantity__c from Lot_Product__c where Product__c =:ProductID and Location__c=:LocationID and  Bin__c=:BinId];
                      for(Lot_Product__c LP:Lotproduct)
                      {
                      if(LP.Product__c!=null && LP.Bin__c!=null && pickedQuant>0 && BinQunt.containsKey(LP.Bin__c))
                      LP.Quantity__c+=BinQunt.get(LP.Bin__c);
                      }
                      update Lotproduct;
                      
                     //code to update Credit user details 
                    if(standorder.Customer_Type__c=='Credit Customer' && (CreditAmount >0 || subTotalAmount >0))
                    {
                        Dimension_Tag__c DT =[select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: standorder.AccountId limit 1];
                        DT.Ordered_Amount__c -=CreditAmount;
                        DT.Paid_Amount__c -= subTotalAmount;
                        update DT;
                    }
                }
                
                //code to reduce inventory when allocation done in sigma order
                else if(Orderusageoptions.Sigma_order__c==true && inventorystatus == 'Reserve')
                {
                    
                    orderData = [SELECT id, name,Quantity__c,No_Picking_Package_Shipment_Required__c,Tax_Amount__c, Order_Created_Via__c, Net_Quantity__c, Orders_Status__c,TotalAmount__c,Customer_Type__c,AccountId__c FROM Sigma_Order__c WHERE id=:orderId];
                    Nopickpack=orderData.No_Picking_Package_Shipment_Required__c;
                    List<Product_Order_Price_Book__c> orderStatusUpdate = new List<Product_Order_Price_Book__c>();
                    List<Product_Order_Price_Book__c> orderProducts;
                    
                    //updating ILPLI
                    orderProducts = [SELECT id,name,Order_Status__c,Inventory_Status__c,IsInventoryUpdated__c,Product__c,tax_amount__c,Quantity__c,Net_Quantity__c,Packaged_Quantity__c,Is_Credit_Updated__c,Total_Price__c,(Select id,Name,ILPLI__c,Quantity__c,ILPLI__r.Available_Quantity__c,ILPLI__r.Reserved_Quantity__c,Picked_Quantity__c,ILPLI__r.Bin__c,ILPLI__r.Lot__c from Inventory_Allocations1__r ) FROM Product_Order_Price_Book__c WHERE Sigma_Order__c=:orderId AND Order_Status__c != 'Canceled'];
                    Map<id,decimal> ReservedQuant=new Map<id,decimal>();
                    Map<id,decimal> BinQunt = new map<id,decimal>();
                    set<Id>Productserialnumber=new set<Id>();
                    List<Id>ProductID=new List<Id>();
                    List<Id>LocationID=new List<Id>();
                    List<Id>BinId = new List<Id>();
                    List<ID>LOTIDS = new List<ID>();
                    
                    productIds = new List<String>();
                    for(Product_Order_Price_Book__c productsData:orderProducts)
                    {
                        tax_amount=+ productsData.tax_amount__c;
                        for(Inventory_Allocation__c Allocateproduct: productsData.Inventory_Allocations1__r )
                        {
                            if(ReservedQuant.containsKey(Allocateproduct.ILPLI__c))
                            {
                                decimal totalqyt = ReservedQuant.get(Allocateproduct.ILPLI__c);
                                ReservedQuant.put(Allocateproduct.ILPLI__c,totalqyt+Allocateproduct.Quantity__c);
                            }
                            else
                            {
                                ReservedQuant.put(Allocateproduct.ILPLI__c,Allocateproduct.Quantity__c);
                            }
                            
                            
                            if(Allocateproduct.Picked_Quantity__c==null)
                                Allocateproduct.Picked_Quantity__c=0;
                            pickedQuant+=Allocateproduct.Picked_Quantity__c;
                            if(Allocateproduct.ILPLI__r.Lot__c !=null)
                            LOTIDS.add(Allocateproduct.ILPLI__r.Lot__c);
							if(BinQunt.containsKey(Allocateproduct.ILPLI__r.Bin__c))
							{
								BinQunt.put(Allocateproduct.ILPLI__r.Bin__c,BinQunt.get(Allocateproduct.ILPLI__r.Bin__c)+Allocateproduct.Picked_Quantity__c);
							}
							else
							{
								BinQunt.put(Allocateproduct.ILPLI__r.Bin__c,Allocateproduct.Picked_Quantity__c);
							}
                            
                        }
                        if(productsData.Is_Credit_Updated__c)
                        CreditAmount += productsData.Total_Price__c;
                        if(productsData.Order_Status__c == 'Packaged')
                        ispackaged =true;
                        Orderstatus = productsData.Order_Status__c;
                        Orderlinestatus = productsData.Inventory_Status__c;
                        if(inventoryallocated!=true)
                        inventoryallocated = productsData.IsInventoryUpdated__c;      
                                      
                        Product_Order_Price_Book__c orderUpdate = new Product_Order_Price_Book__c();
                        productIds.add(productsData.Product__c);
                        //productQuantity.put(productsData.Product__c,Integer.valueOf(productsData.Net_Quantity__c));
                        if(productsData.IsInventoryUpdated__c)
                        {
                            if(productQuantity.containsKey(productsData.Product__c))
                            {
                                Integer netqty = productQuantity.get(productsData.Product__c);
                                productQuantity.put(productsData.Product__c,Integer.valueOf(productsData.Net_Quantity__c)+netqty);
                            }
                            else
                            {
                              productQuantity.put(productsData.Product__c,Integer.valueOf(productsData.Net_Quantity__c)); 
                            }
                        }
                            
                        orderUpdate.Id = productsData.id;
                        //orderUpdate.Net_Quantity__c = 0;
                        //orderUpdate.Quantity__c=0;
                        orderUpdate.Remaining_Qty_To_Package__c = 0;
                        orderUpdate.Order_Status__c = 'Canceled';
                        if(orderUpdate.Packaged_Quantity__c==null)
                        orderUpdate.Packaged_Quantity__c = 0;
                        orderStatusUpdate.add(orderUpdate);
                        
                    }
                    List<Inventory_Location_Product_Line_Item__c>updateILPLI=new List<Inventory_Location_Product_Line_Item__c>();
                    updateILPLI=[select id,name,Inventory_Location_Product__c,Reserved_Quantity__c,Adjusted_Quantity1__c,Product__c,Inventory_Location__c,Bin__c,Product_Serial_Number__c,Delivered_Quantity__c,Package_Quantity__c from Inventory_Location_Product_Line_Item__c where id=:ReservedQuant.keySet()];
                    Map<id,decimal> ilpmap=new Map<id,decimal>();
                
                        for(Inventory_Location_Product_Line_Item__c ilpli:updateILPLI)
                        {
                             if(ilpli.Product_Serial_Number__c!=null)
                            {
                                Productserialnumber.add(ilpli.Product_Serial_Number__c);
                                system.debug('Productserialnumber>>'+Productserialnumber);
                            }
                            if(ilpli.Product__c!=null)
                            {
                                ProductID.add(ilpli.Product__c);
                            }
                            if(ilpli.Inventory_Location__c!=null)
                            {
                                LocationID.add(ilpli.Inventory_Location__c);
                            }
                            if(ilpli.Bin__c!=null)
                            {
                               BinId.add(ilpli.Bin__c); 
                               
                            } 
                            if(ReservedQuant.containsKey(ilpli.id))
                            {
                                if(Nopickpack && pickedQuant==0)
                                {
                                    ilpli.Delivered_Quantity__c-=ReservedQuant.get(ilpli.id);
                                }
                                else if(ilpli.Reserved_Quantity__c!=0 && ilpli.Reserved_Quantity__c!=NULL && pickedQuant==0 && Orderlinestatus != 'Un Reserved')
                                {
                                    ilpli.Reserved_Quantity__c-=ReservedQuant.get(ilpli.id);
                                }
                            
                                if(ilpli.Adjusted_Quantity1__c!=0 && ilpli.Adjusted_Quantity1__c!=NULL && pickedQuant >0 && Orderstatus != 'Packaged')
                                    ilpli.Adjusted_Quantity1__c-=ReservedQuant.get(ilpli.id);
                                if(Orderstatus == 'Packaged' && Nopickpack !=true)
								{
									ilpli.Package_Quantity__c -=ReservedQuant.get(ilpli.id);
								}
                                if(ilpmap.containsKey(ilpli.Inventory_Location_Product__c))
                                {
                                    decimal qty= ilpmap.get(ilpli.Inventory_Location_Product__c);
                                    
                                    ilpmap.put(ilpli.Inventory_Location_Product__c,qty+ReservedQuant.get(ilpli.id));
                                }
                                else
                                {
                                    ilpmap.put(ilpli.Inventory_Location_Product__c,ReservedQuant.get(ilpli.id));
                                }
                            }
                        }
                        
                        update updateILPLI;
                        update orderStatusUpdate;
                    List<Product_Order_Price_Book__c> orderProducts1;
                    orderProducts1 = [SELECT id,tax_amount__c,Order_Status__c FROM Product_Order_Price_Book__c WHERE Sigma_Order__c=:orderId AND (Order_Status__c = 'Order Confirmed' OR Order_Status__c = 'Request for cancel')];
                    for(Product_Order_Price_Book__c P :orderProducts1  )
                    {
                        tax_amount=+ P.tax_amount__c;
                        P.Order_Status__c='Canceled';//code added to update child record after cancel on 05-11-2019
                    }
                    update orderProducts1;//code ends here.
                        
                        if(ispackaged)
                        {
                            Package__c packageproduct = [select id,Name,Canceled_Package__c from Package__c where Sigma_Order__c=:orderData.id];
                            if(packageproduct !=null)
                            {
                                packageproduct.Canceled_Package__c = true;
                                update packageproduct;
                            }
                            
                        }
                        List<Inventory_Location_Product__c> ILPLIST= [select id,name,Deliver_Quantity__c,Reserved_Quantity__c,Picked_Quantity__c,Package_Quantity__c from Inventory_Location_Product__c where id=:ilpmap.keySet()];
                        system.debug('ILPLIST:::::'+ILPLIST);
                        for(Inventory_Location_Product__c ilp:ILPLIST)
                        {
                            if(Nopickpack && ilpmap.containsKey(ilp.id))
                            {
                                ilp.Deliver_Quantity__c -= ilpmap.get(ilp.id);
                            }
                            else if(ilpmap.containsKey(ilp.id)&& Orderlinestatus != 'Un Reserved' && pickedQuant==0)
                            {
                                ilp.Reserved_Quantity__c-=ilpmap.get(ilp.id);
                            }
							else if(pickedQuant > 0 && ilp.Picked_Quantity__c!=null && Orderlinestatus != 'Un Reserved' && Orderstatus != 'Packaged')
							{
								ilp.Picked_Quantity__c-=ilpmap.get(ilp.id);
							}
							else if(Orderstatus == 'Packaged' && Nopickpack !=true)
							{
								ilp.Package_Quantity__c -=ilpmap.get(ilp.id);
							}
                            
                        }
                        update ILPLIST;
                        system.debug('ILPLIST>>>'+ILPLIST);
                 
                    List<Lot_Product__c>Lotproduct=[Select id,Name,Location__c,Bin__c,Product__c,Quantity__c from Lot_Product__c where Product__c =:ProductID and Location__c=:LocationID and Bin__c =:BinId and Lot__c =:LOTIDS];
                        
                    for(Lot_Product__c LP:Lotproduct)
                    {
                        if(LP.Product__c!=null && LP.Bin__c!=null && pickedQuant>0 && BinQunt.containsKey(LP.Bin__c))
                            LP.Quantity__c+=BinQunt.get(LP.Bin__c);
                    }
                    update Lotproduct;
                    if(Productserialnumber.size()>0)
                    {
                        List<Product_Serial_Number__c> serialststusupdate=new List<Product_Serial_Number__c>();
                        serialststusupdate=[select id,name,Status__c from Product_Serial_Number__c where id=:Productserialnumber];
                        for(Product_Serial_Number__c serialstatus:serialststusupdate)
                        {
                            serialstatus.Status__c='Available';
                        }
                        update serialststusupdate;
                        system.debug('serialststusupdate>>'+serialststusupdate);
                    }
                    //code to handle credit user detail once inventory reduce
                    if(orderData.Customer_Type__c=='Credit Customer' && (CreditAmount >0 || subTotalAmount >0))
                    {
                        Dimension_Tag__c DT =[select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: orderData.AccountId__c limit 1];
                        DT.Ordered_Amount__c -=CreditAmount;
                        DT.Paid_Amount__c -=subTotalAmount;
                        update DT;
                    }
                    
                }
                //ends here
                //code for inventory status is allocated 
                else
                {
                    
                    List<Id>ProductID=new List<Id>();
                    List<Id>LocationID=new List<Id>();
                    List<Id>BinId=new List<Id>();
                    List<Lot_Product__c> lotproductlist = new List<Lot_Product__c>();
                    List<Inventory_Location_Product__c> ilplist = new List<Inventory_Location_Product__c>();
                   // Set<Inventory_Location_Product__c> ilpset= new Set<Inventory_Location_Product__c>();
                    List<Inventory_Location_Product_Line_Item__c>liplilist = new List<Inventory_Location_Product_Line_Item__c>();
                    
                    set<Id>Productserialnumber=new set<Id>();
                    Map<Id,Inventory_Location_Product_Line_Item__c> isdefaultloc = new Map<id,Inventory_Location_Product_Line_Item__c>();
                    Map<Id,decimal>Unitprice = new Map<Id,decimal>();
                    Map<id,decimal> ReservedQuant=new Map<id,decimal>();
                    Map<id,decimal> BinQunt=new Map<id,decimal>();
					Map<id,Map<id,decimal>> lotqtyupdate=new Map<id,Map<id,decimal>>();
                    Map<Id,decimal>totalquant = new Map<Id,decimal>();
                    Map<Id,String>Producttype = New Map<Id,String>();
                    Map<Id,Id>LotId = new Map<Id,Id>();
                    List<OrderItem> standorderProducts;
                    List<Product_Order_Price_Book__c> orderProducts;
                    if(Orderusageoptions.Standard_object__c == true)
                    {
                        standorder = [SELECT id,Quantity__c,Tax_Amount__c, Order_Created_Via__c, Net_Quantity__c,Net_Amount__c,Orders_Status__c,No_Picking_Package_Shipment_Required__c,Customer_Type__c,AccountId FROM Order WHERE id=:orderId];
                        Nopickpack = standorder.No_Picking_Package_Shipment_Required__c;
                        List<OrderItem> orderStatusUpdate = new List<OrderItem>();
                        
                        standorderProducts = [SELECT id,PriceBookEntry.Product2.Id,PriceBookEntry.Product2.Attribute_Type__c,Quantity,Net_Quantity__c,IsInventoryUpdated__c,Order_Status__c,Is_Credit_Updated__c,TotalPrice__c,(Select id,Name,ILPLI__c,Quantity__c,ILPLI__r.Available_Quantity__c,ILPLI__r.Reserved_Quantity__c,Picked_Quantity__c,ILPLI__r.Bin__c,ILPLI__r.Product__c,ILPLI__r.Lot__c from Inventory_Allocations__r ) FROM OrderItem WHERE OrderId=:orderId AND Order_Status__c != 'Canceled'];
                        productIds = new List<String>();
                        for(OrderItem productsData:standorderProducts)
                        {
							Producttype.put(productsData.PriceBookEntry.Product2.Id,productsData.PriceBookEntry.Product2.Attribute_Type__c);
                            for(Inventory_Allocation__c Allocateproduct: productsData.Inventory_Allocations__r )
                            {
                                if(ReservedQuant.containsKey(Allocateproduct.ILPLI__c))
                                {
                                    decimal totalqyt = ReservedQuant.get(Allocateproduct.ILPLI__c);
                                    ReservedQuant.put(Allocateproduct.ILPLI__c,totalqyt+Allocateproduct.Quantity__c);
                                }
                                else
                                {
                                    ReservedQuant.put(Allocateproduct.ILPLI__c,Allocateproduct.Quantity__c);
                                }
                                if(BinQunt.containsKey(Allocateproduct.ILPLI__r.Bin__c))
                                {
                                    decimal qty = BinQunt.get(Allocateproduct.ILPLI__r.Bin__c);
                                    BinQunt.put(Allocateproduct.ILPLI__r.Bin__c,qty+Allocateproduct.Quantity__c);
                                }
                                else
                                {
                                    BinQunt.put(Allocateproduct.ILPLI__r.Bin__c,Allocateproduct.Quantity__c);
                                }
								if(Allocateproduct.ILPLI__r.Lot__c !=null){
										if(lotqtyupdate.containsKey(Allocateproduct.ILPLI__r.Lot__c))
										{
												if(lotqtyupdate.get(Allocateproduct.ILPLI__r.Lot__c).containsKey(Allocateproduct.ILPLI__r.Bin__c))
												{
													decimal qty=lotqtyupdate.get(Allocateproduct.ILPLI__r.Lot__c).get(Allocateproduct.ILPLI__r.Bin__c);
													lotqtyupdate.get(Allocateproduct.ILPLI__r.Lot__c).put(Allocateproduct.ILPLI__r.Bin__c,qty+Allocateproduct.Quantity__c);
												}
												else
												{
													Map<id,decimal> locid=new Map<id,decimal>();
													lotqtyupdate.get(Allocateproduct.ILPLI__r.Lot__c).put(Allocateproduct.ILPLI__r.Bin__c,Allocateproduct.Quantity__c);
												}
										}
										else
										{
											Map<id,decimal> locid=new Map<id,decimal>();
											locid.put(Allocateproduct.ILPLI__r.Bin__c,Allocateproduct.Quantity__c);
											lotqtyupdate.put(Allocateproduct.ILPLI__r.Lot__c,locid);
										}
								}
								if(Allocateproduct.ILPLI__r.Lot__c!=null)
                                LotId.put(Allocateproduct.ILPLI__r.Product__c,Allocateproduct.ILPLI__r.Lot__c);
                                system.debug('BinQunt@@@'+BinQunt);
                            } 
                            if(productsData.Is_Credit_Updated__c)
                            CreditAmount += productsData.TotalPrice__c;
                            Orderstatus = productsData.Order_Status__c;
                            if(inventoryallocated!=true)
                        	inventoryallocated = productsData.IsInventoryUpdated__c;   
                            OrderItem orderUpdate = new OrderItem();
                            productIds.add(productsData.PriceBookEntry.Product2Id);
                            if(productsData.IsInventoryUpdated__c)
                            {
                                if(productQuantity.containsKey(productsData.PriceBookEntry.Product2Id))
                                {
                                    Integer netqty= productQuantity.get(productsData.PriceBookEntry.Product2Id);
                                    productQuantity.put(productsData.PriceBookEntry.Product2Id,Integer.valueOf(productsData.Quantity)+netqty);
                                }
                                else
                                {
                                    productQuantity.put(productsData.PriceBookEntry.Product2Id,Integer.valueOf(productsData.Quantity)); 
                                }
                            }
                            
                            orderUpdate.Id = productsData.id;
                            //orderUpdate.Net_Quantity__c = 0;
                            //orderUpdate.Quantity = orderUpdate.Net_Quantity__c;
                            orderUpdate.Remaining_Qty_To_Package__c=0;
                            orderUpdate.Order_Status__c = 'Canceled';
                            if(orderUpdate.Packaged_Quantity__c==null)
                            orderUpdate.Packaged_Quantity__c = 0;
                            orderStatusUpdate.add(orderUpdate);
                        }
                        if(orderStatusUpdate.size()>0)
                        update orderStatusUpdate;
                        //system.debug('updateILPLI@@'+updateILPLI);
                        
                    }
                    else
                    {
                        orderData = [SELECT id, name,Quantity__c,Tax_Amount__c,No_Picking_Package_Shipment_Required__c,Order_Created_Via__c, Net_Quantity__c, Orders_Status__c,TotalAmount__c,Customer_Type__c,AccountId__c FROM Sigma_Order__c WHERE id=:orderId];
                        Nopickpack=orderData.No_Picking_Package_Shipment_Required__c;
                        List<Product_Order_Price_Book__c> orderStatusUpdate = new List<Product_Order_Price_Book__c>();
                        
                        //updating ILPLI
                        orderProducts = [SELECT id,name,Product__c,Product__r.Attribute_Type__c,IsInventoryUpdated__c,tax_amount__c,Quantity__c,Net_Quantity__c,Packaged_Quantity__c,Remaining_Qty_To_Package__c,Is_Credit_Updated__c,Total_Price__c,(Select id,Name,ILPLI__c,Quantity__c,ILPLI__r.Available_Quantity__c,ILPLI__r.Reserved_Quantity__c,ILPLI__r.Bin__c,ILPLI__r.Lot__c,ILPLI__r.Product__c,Picked_Quantity__c from Inventory_Allocations1__r ) FROM Product_Order_Price_Book__c WHERE Sigma_Order__c=:orderId AND Order_Status__c != 'Canceled'];
                        system.debug('orderProducts:::'+orderProducts);
                        productIds = new List<String>();
                        for(Product_Order_Price_Book__c productsData:orderProducts)
                        {
                            Producttype.put(productsData.Product__c,productsData.Product__r.Attribute_Type__c);
                            
                            for(Inventory_Allocation__c Allocateproduct: productsData.Inventory_Allocations1__r )
                            {
                                if(ReservedQuant.containsKey(Allocateproduct.ILPLI__c))
                                {
                                    decimal totalqyt = ReservedQuant.get(Allocateproduct.ILPLI__c);
                                    ReservedQuant.put(Allocateproduct.ILPLI__c,totalqyt+Allocateproduct.Quantity__c);
                                }
                                else
                                {
                                    ReservedQuant.put(Allocateproduct.ILPLI__c,Allocateproduct.Quantity__c);
                                }
                                if(BinQunt.containsKey(Allocateproduct.ILPLI__r.Bin__c))
                                {
                                    decimal qty = BinQunt.get(Allocateproduct.ILPLI__r.Bin__c);
                                    BinQunt.put(Allocateproduct.ILPLI__r.Bin__c,qty+Allocateproduct.Quantity__c);
                                }
                                else
                                {
                                    BinQunt.put(Allocateproduct.ILPLI__r.Bin__c,Allocateproduct.Quantity__c);
                                }
								if(Allocateproduct.ILPLI__r.Lot__c !=null){
										if(lotqtyupdate.containsKey(Allocateproduct.ILPLI__r.Lot__c))
										{
												if(lotqtyupdate.get(Allocateproduct.ILPLI__r.Lot__c).containsKey(Allocateproduct.ILPLI__r.Bin__c))
												{
													decimal qty=lotqtyupdate.get(Allocateproduct.ILPLI__r.Lot__c).get(Allocateproduct.ILPLI__r.Bin__c);
													lotqtyupdate.get(Allocateproduct.ILPLI__r.Lot__c).put(Allocateproduct.ILPLI__r.Bin__c,qty+Allocateproduct.Quantity__c);
												}
												else
												{
													Map<id,decimal> locid=new Map<id,decimal>();
													lotqtyupdate.get(Allocateproduct.ILPLI__r.Lot__c).put(Allocateproduct.ILPLI__r.Bin__c,Allocateproduct.Quantity__c);
												}
										}
										else
										{
											Map<id,decimal> locid=new Map<id,decimal>();
											locid.put(Allocateproduct.ILPLI__r.Bin__c,Allocateproduct.Quantity__c);
											lotqtyupdate.put(Allocateproduct.ILPLI__r.Lot__c,locid);
										}
								}
								
                                if(Allocateproduct.ILPLI__r.Lot__c !=null)
                                LotId.put(Allocateproduct.ILPLI__r.Product__c,Allocateproduct.ILPLI__r.Lot__c);
                            } 
                            if(productsData.Is_Credit_Updated__c)
                            CreditAmount += productsData.Total_Price__c;
                            if(inventoryallocated!=true)
                            inventoryallocated = productsData.IsInventoryUpdated__c;
                            Product_Order_Price_Book__c orderUpdate = new Product_Order_Price_Book__c();
                            productIds.add(productsData.Product__c);
                           // productQuantity.put(productsData.Product__c,Integer.valueOf(productsData.Net_Quantity__c));
                            if(productsData.IsInventoryUpdated__c)
                            {
                                if(productQuantity.containsKey(productsData.Product__c))
                                {
                                    Integer netqty = productQuantity.get(productsData.Product__c);
                                        
                                        productQuantity.put(productsData.Product__c,Integer.valueOf(productsData.Net_Quantity__c)+netqty);
                                }
                                else
                                {
                                  productQuantity.put(productsData.Product__c,Integer.valueOf(productsData.Net_Quantity__c)); 
                                }
                            }
                            orderUpdate.Id = productsData.id;
                            //orderUpdate.Net_Quantity__c = 0;
                            //orderUpdate.Quantity__c=0;
                            orderUpdate.Remaining_Qty_To_Package__c = 0;
                            orderUpdate.Order_Status__c = 'Canceled';
                            if(orderUpdate.Packaged_Quantity__c==null)
                                orderUpdate.Packaged_Quantity__c = 0;
                            orderStatusUpdate.add(orderUpdate);
                        }
                            if(orderStatusUpdate.size()>0)
                            update orderStatusUpdate;
                            //system.debug('updateILPLI@@'+updateILPLI);
                        
                    }
                    List<Inventory_Location_Product_Line_Item__c>updateILPLI=new List<Inventory_Location_Product_Line_Item__c>();
                    updateILPLI=[select id,name,Bin__c,Unit_Price__c,Inventory_Location_Product__c,Reserved_Quantity__c,Adjusted_Quantity1__c,Product__c,Inventory_Location__c,Inventory_Location__r.Location__c,Product_Serial_Number__c,Delivered_Quantity__c,Lot__c from Inventory_Location_Product_Line_Item__c where id=:ReservedQuant.keySet() ORDER BY Product_Expiry_Date__c ASC NULLS LAST,Product_Received_date__c ASC NULLS LAST];
                    Map<id,decimal> ilpmap=new Map<id,decimal>();
                    for(Inventory_Location_Product_Line_Item__c ilpli:updateILPLI)
                    {
                        Unitprice.put(ilpli.Product__c,ilpli.Unit_Price__c);
                         if(ilpli.Product_Serial_Number__c!=null)
                            {
                                Productserialnumber.add(ilpli.Product_Serial_Number__c);
                               
                            }
                         if(ilpmap.containsKey(ilpli.Inventory_Location_Product__c))
                                {
                                    decimal qty= ilpmap.get(ilpli.Inventory_Location_Product__c);
                                    
                                    ilpmap.put(ilpli.Inventory_Location_Product__c,qty+ReservedQuant.get(ilpli.id));
                                }
                                else
                                {
                                    ilpmap.put(ilpli.Inventory_Location_Product__c,ReservedQuant.get(ilpli.id));
                                }
                        
                        if(ilpli.Inventory_Location__c == Inventoryloc )
                        {
                            
                            //isdefaultloc.put(ilpli.Id,ilpli);
                            //system.debug('isdefaultloc@@@'+isdefaultloc);
                            if(ilpli.Product__c!=null)
                            {
                                ProductID.add(ilpli.Product__c);
                            }
                            if(ilpli.Inventory_Location__c!=null)
                            {
                                LocationID.add(ilpli.Inventory_Location__c);
                            }
                            if(ilpli.Bin__c!=null)
                            {
                               BinId.add(ilpli.Bin__c); 
                            } 
                            if(ReservedQuant.containsKey(ilpli.id))
                            {
                                if(ilpli.Delivered_Quantity__c!=0 && ilpli.Delivered_Quantity__c!=NULL && pickedQuant==0)
                                    ilpli.Delivered_Quantity__c-=ReservedQuant.get(ilpli.id);
                                
                            }
                        }
                        else
                        {
                            isdefaultloc.put(ilpli.Id,ilpli);
                            system.debug('isdefaultlocafter@@'+isdefaultloc);
                        }
                    }
                    
                    update updateILPLI;
                    
                    
                    List<Inventory_Location_Product__c> ILPLISTDATA= [select id,name,Deliver_Quantity__c,Products__c,Reserved_Quantity__c,Inventory_Location__c,Inventory_Location__r.Location__c from Inventory_Location_Product__c where id=:ilpmap.keySet()];
                    for(Inventory_Location_Product__c ilp:ILPLISTDATA)
                    {
                        if(ilp.Inventory_Location__c == Inventoryloc )
                        { 
                    
                            system.debug('match2');
                            if(ilpmap.containsKey(ilp.id))
                            {
                                ilp.Deliver_Quantity__c-=ilpmap.get(ilp.id);
                            }
                        }
                        
                    }
                    update ILPLISTDATA;
                    system.debug('ILPLISTDATA@@'+ILPLISTDATA);
                    //updating LOT Product2
                    List<Lot_Product__c>Lotproduct=[Select id,Name,Bin__c,Location__c,Product__c,Quantity__c,Lot__c from Lot_Product__c where Product__c =:ProductID and Lot__c =:lotqtyupdate.keySet() ];
                    system.debug('Lotproduct@@'+Lotproduct);
					system.debug('lotqtyupdate@@'+lotqtyupdate);
                    if(Lotproduct.size()>0)
                    {
                        for(Lot_Product__c LP:Lotproduct)
                        {
                            if(lotqtyupdate.containsKey(LP.Lot__c))
							{
								if(lotqtyupdate.get(LP.Lot__c).containsKey(LP.Bin__c))
								{
									LP.Quantity__c+=lotqtyupdate.get(LP.Lot__c).get(LP.Bin__c);
								}
							} 
                        }
                        update Lotproduct;
                        system.debug('Lotproduct@'+Lotproduct);
                    }
                   
                   
                    if(Productserialnumber.size()>0)
                    {
                        List<Product_Serial_Number__c> serialststusupdate=new List<Product_Serial_Number__c>();
                        serialststusupdate=[select id,name,Status__c,Inventory_Location__c from Product_Serial_Number__c where id=:Productserialnumber];
                        system.debug('serialststusupdate@@@'+serialststusupdate);
                        for(Product_Serial_Number__c serialstatus:serialststusupdate)
                        {
                            if(serialstatus.Inventory_Location__c == Inventoryloc)
                            {
                                serialstatus.Status__c='Available';
                            }
                            
                        }
                        update serialststusupdate;
                       
                    }
					Map<Id,Inventory_Location_Product_Line_Item__c>ILPLIExist = new Map<Id,Inventory_Location_Product_Line_Item__c>();
					if(isdefaultloc.size()>0)
					{
						//code to handle Lot 
						Map<Id,Lot_Product__c>LotExist = new Map<Id,Lot_Product__c>();
						for(Lot_Product__c LP :[Select id,Name,Lot__c,Bin__c,Location__c,Product__c,Quantity__c from Lot_Product__c where Product__c =:productQuantity.keySet()])
						{
							if(LP.Location__c == Inventoryloc && LP.Bin__c == Defaultbin)
							{
								LotExist.put(LP.Product__c,LP);
							}
						}
						//code to handle ILP
						Id Proinventory;
						Map<Id,Inventory_Location_Product__c>ILPExist = new Map<Id,Inventory_Location_Product__c>();
						for(Inventory_Location_Product__c ILP :[select id,name,Deliver_Quantity__c,Products__c,Inventory_Location__c,Inventory_Location__r.Location__c,Inventory__c,Received_Quantity__c from Inventory_Location_Product__c where Products__c=:productQuantity.keySet()])
						{
							Proinventory = ILP.Inventory__c;
							if(ILP.Inventory_Location__c==Inventoryloc)
							{
								ILPExist.put(ILP.Products__c,ILP);
							}
						}
						system.debug('ILPExist@@@'+ILPExist);
						//Code to handle ILPLI
						
						for(Inventory_Location_Product_Line_Item__c ILPLI:[select id,name,Bin__c,Unit_Price__c,Inventory_Location_Product__c,Product__c,Inventory_Location__c,Lot__c,Delivered_Quantity__c,Received_Quantity__c from Inventory_Location_Product_Line_Item__c where Product__c=:productQuantity.keySet()])
						{
							if(ILPLI.Inventory_Location__c == Inventoryloc && ILPLI.Bin__c == Defaultbin)
							{
								ILPLIExist.put(ILPLI.Product__c,ILPLI);
							}
						}
						
						//handle not default location ILPLIs
						for(Id Ilpli:isdefaultloc.keySet())
						{
							system.debug('proId@@'+isdefaultloc.get(Ilpli).Product__c);
							//handle Lot
							if(LotExist.containsKey(isdefaultloc.get(Ilpli).Product__c))
							{
								Lot_Product__c Newlp = LotExist.get(isdefaultloc.get(Ilpli).Product__c);
								if(BinQunt.containsKey(isdefaultloc.get(Ilpli).Bin__c))
                                Newlp.Quantity__c += BinQunt.get(isdefaultloc.get(Ilpli).Bin__c); 
								lotproductlist.add(Newlp);
							}
							else
							{
								Lot_Product__c Newlp = new Lot_Product__c();
								Newlp.Location__c = Inventoryloc;
								Newlp.Product__c = isdefaultloc.get(Ilpli).Product__c;
								Newlp.Lot__c = isdefaultloc.get(Ilpli).Lot__c;
								Newlp.Quantity__c = BinQunt.get(isdefaultloc.get(Ilpli).Bin__c);
								Newlp.Bin__c = Defaultbin;
								lotproductlist.add(Newlp);
							}
							//handle ILP
							if(ILPExist.containsKey(isdefaultloc.get(Ilpli).Product__c))
							{
								Inventory_Location_Product__c ilpnew = ILPExist.get(isdefaultloc.get(Ilpli).Product__c);
								ilpnew.Received_Quantity__c +=ilpmap.get(isdefaultloc.get(Ilpli).Inventory_Location_Product__c);
								ilplist.add(ilpnew);
								
							}
							else
							{
								Inventory_Location_Product__c ilpnew = new Inventory_Location_Product__c();
								ilpnew.Inventory_Location__c = Inventoryloc;
								ilpnew.Products__c = isdefaultloc.get(Ilpli).Product__c;
								ilpnew.Received_Quantity__c = ilpmap.get(isdefaultloc.get(Ilpli).Inventory_Location_Product__c);
								ilplist.add(ilpnew);
								
							}
							
						}
					}
					
					//Update LOT product
                    Map<Id,Id> LotIds = new map<Id,Id>();
                    if(lotproductlist.size()>0)
                    {
                    
                        Upsert lotproductlist;
                        for(Lot_Product__c LotPro :lotproductlist)
                        {
                            LotIds.put(LotPro.Product__c,LotPro.Lot__c);    
                        }
                    }
					
					//Update ILP
					Map<Id,Id> ILPIds = new map<Id,Id>();
					if(ilplist.size()>0)
					{
						upsert ilplist;
						for(Inventory_Location_Product__c IlpPro :ilplist)
                        {
                            ILPIds.put(IlpPro.Products__c,IlpPro.Id);    
                        }
					}
					
					//Handle ILPLI
					List<Product_Serial_Number__c> NewPSN=new List<Product_Serial_Number__c>();
					if(isdefaultloc.size()>0)
					{
						for(Id Ilpli:isdefaultloc.keySet())
						{
							if(ILPLIExist.containsKey(isdefaultloc.get(Ilpli).Product__c)&& Producttype.get(isdefaultloc.get(Ilpli).Product__c) == 'BULK')
							{
								Inventory_Location_Product_Line_Item__c newilpli= ILPLIExist.get(isdefaultloc.get(Ilpli).Product__c); 
								newilpli.Received_Quantity__c += ReservedQuant.get(isdefaultloc.get(Ilpli).Id);
								liplilist.add(newilpli);
							}
							else if(Producttype.get(isdefaultloc.get(Ilpli).Product__c) == 'BULK')
							{
								Inventory_Location_Product_Line_Item__c newilpli= new Inventory_Location_Product_Line_Item__c();
								newilpli.Inventory_Location__c = Inventoryloc;
								newilpli.Product__c = isdefaultloc.get(Ilpli).Product__c;
								newilpli.Unit_Price__c = Unitprice.get(isdefaultloc.get(Ilpli).Product__c);
								newilpli.Received_Quantity__c = ReservedQuant.get(isdefaultloc.get(Ilpli).Id);
								newilpli.Bin__c=Defaultbin;
								if(lotproductlist.size()>0)
								newilpli.Lot__c = LotIds.get(isdefaultloc.get(Ilpli).Product__c);
								if(ilplist.size()>0)
								newilpli.Inventory_Location_Product__c = ILPIds.get(isdefaultloc.get(Ilpli).Product__c);
								liplilist.add(newilpli);
								
								
							}
							else
							{
								String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
								String randStr = '';
								while (randStr.length() < 4) {
								Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
								randStr += chars.substring(idx, idx+1);
								}
								Product_Serial_Number__c PSN =new Product_Serial_Number__c();
								PSN.Status__c='Available';
								PSN.Serial_Number__c = 'M'+randStr;
								PSN.Inventory_Location_Product__c = ILPIds.get(isdefaultloc.get(Ilpli).Product__c);
								PSN.Product_Code__c = isdefaultloc.get(Ilpli).Product__c;
								if(lotproductlist.size()>0)
								PSN.Lot__c = LotIds.get(isdefaultloc.get(Ilpli).Product__c);
								PSN.Inventory_Location__c = Inventoryloc;
								PSN.Bin__c=Defaultbin;
								PSN.Quantity__c=1;
								NewPSN.add(PSN);
								
								
								
							}
						}
					}
					
					if(NewPSN.size()>0)
                    {
                        insert NewPSN;
                        for(Product_Serial_Number__c PSNvalue:NewPSN)
                        {
                            Inventory_Location_Product_Line_Item__c newilpli= new Inventory_Location_Product_Line_Item__c();
                            newilpli.Inventory_Location__c = Inventoryloc;
                            newilpli.Product__c = PSNvalue.Product_Code__c;
                            newilpli.Unit_Price__c = Unitprice.get(newilpli.Product__c);
                            newilpli.Received_Quantity__c =1;
                            newilpli.Bin__c=Defaultbin;
                            if(lotproductlist.size()>0)
                            newilpli.Lot__c = LotIds.get(newilpli.Product__c);
                            newilpli.Inventory_Location_Product__c = PSNvalue.Inventory_Location_Product__c;
                            newilpli.Product_Serial_Number__c=PSNvalue.id;  
                            liplilist.add(newilpli);
                        }
                    }
					system.debug('ILPLI@@'+liplilist);
                    if(liplilist.size()>0)
                    {
                        Upsert liplilist;
                    }
					
                   
                    //update sigma order status
                    if(orderData !=null)
                    {
                        orderData.Orders_Status__c ='Canceled';
                        update orderData;
                        if(orderData.Customer_Type__c=='Credit Customer' && Orderusageoptions.Sigma_order__c==true && (CreditAmount >0 || subTotalAmount >0))
                        {
                          Dimension_Tag__c DT =[select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =:orderData.AccountId__c limit 1];
                          DT.Ordered_Amount__c -=CreditAmount;
                          DT.Paid_Amount__c -=subTotalAmount;
                          
                          update DT;
                        }
                    }
                    if(standorder !=null)
                    {
                        standorder.Orders_Status__c ='Canceled';
                        update standorder;
                        if(standorder.Customer_Type__c=='Credit Customer' && Orderusageoptions.Standard_object__c == true && (CreditAmount >0 || subTotalAmount >0))
                        {
                          Dimension_Tag__c DT =[select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: standorder.AccountId limit 1];
                          DT.Ordered_Amount__c -=CreditAmount;
                          DT.Paid_Amount__c -=subTotalAmount;
                          update DT;
                        }
                    }
                   
                    
                    
                }
                
                //code added by Anuja
                Time_Base_Inventory__c TBI;
                TBI=[select Order__c,Proposal_to_Order__c from Time_Base_Inventory__c limit 1];
                Boolean Execute;
                
                if(TBI.Order__c ==true || TBI.Proposal_to_Order__c ==true)
                {
                    Execute = AllocateInventoryCntrl.DeAllocateInventoryforOrder(orderData.Id);
                }
                
                List<Inventory__c> inventoryUpdate = new List<Inventory__c>();
                List<Inventory__c> productInventory;
                system.debug('productIds::'+productIds);
                if(productIds!=NULL)
                {
                    
                    productInventory = [SELECT id,name,ProductCode__c,Delivered_Qty__c,Available_Qty__c,Web_Available_Qty__c,Reserved_Qty__c,Purchased_Qty__c,Total_Available_Qty__c,Picked_Quantity__c,Packaged_Quantity__c,Comments__c from Inventory__c WHERE ProductCode__c IN :productIds];
                    Integer proQuantity =0;
                    
                    for(Inventory__c productQty:productInventory)
                    {
                        
                        Inventory__c updateInventory = new Inventory__c();
                        if(productQuantity.size()>0)
                        {
                             proQuantity = productQuantity.get(productQty.ProductCode__c);
                        }
                        
                        
                        if(Orderusageoptions.Standard_object__c == true)
                        {
                            
                            if(standorder.Order_Created_Via__c == 'Web_Order')
                            {
                               
                                manageQuantity = Integer.valueOf(productQty.Web_Available_Qty__c)+proQuantity;
                                managereserved = Integer.valueOf(productQty.Reserved_Qty__c)-proQuantity;
                                managepurcheased = Integer.valueOf(productQty.Purchased_Qty__c)-proQuantity;
                                updateInventory.Web_Available_Qty__c = manageQuantity;
                                updateInventory.Reserved_Qty__c = managereserved;
                                updateInventory.Purchased_Qty__c = managepurcheased;
                                updateInventory.id = productQty.id;
                                inventoryUpdate.add(updateInventory);
                               
                            }
                            else
                            {
                               
                                if(inventorystatus != 'Allocated')
                                {
                                    
                                    if(Nopickpack && productQty.Delivered_Qty__c!=0 && productQty.Delivered_Qty__c!=NULL )
                                    {
                                        managepurcheased = Integer.valueOf(productQty.Delivered_Qty__c) - proQuantity;
                                    }
                                    else if(productQty.Reserved_Qty__c!=0 && productQty.Reserved_Qty__c!=NULL)
                                    {
                                        managepurcheased = Integer.valueOf(productQty.Reserved_Qty__c) - proQuantity;
                                    }
                               
                                    manageDeliveredQty =  Integer.valueOf(productQty.Delivered_Qty__c);
                                     //code to reduce Picked Qunt
                                    if(productQty.Picked_Quantity__c!=0 && productQty.Picked_Quantity__c!=NULL )
                                    {
                                         managepicked=Integer.valueOf(productQty.Picked_Quantity__c)-proQuantity;
                                    }
                                    if(productQty.Packaged_Quantity__c!=0 && productQty.Packaged_Quantity__c!=NULL)
                                    {
                                        managepackage=Integer.valueOf(productQty.Packaged_Quantity__c)-proQuantity;
                                    } 
                                }
                                else
                                {
                                    managepurcheased = Integer.valueOf(productQty.Reserved_Qty__c);
                                    system.debug('managepurcheased>>'+managepurcheased);
                                    manageDeliveredQty =  Integer.valueOf(productQty.Delivered_Qty__c) - proQuantity;
                                    system.debug('manageDeliveredQty>>'+manageDeliveredQty);
                                }
                                manageTotalAvailableQuantity = Integer.valueOf(productQty.Available_Qty__c) + proQuantity ;
                                if(Nopickpack && pickedQuant==0 && inventoryallocated == true)
                                {
                                    updateInventory.Delivered_Qty__c =managepurcheased;
                                }
                                else if(pickedQuant==0 && inventoryallocated == true)
                                {
                                    updateInventory.Reserved_Qty__c = managepurcheased;
                                }
                                //if(productQty.Reserved_Qty__c!=0 && productQty.Reserved_Qty__c!=NULL)
                                if(inventoryallocated == true)
                                updateInventory.Available_Qty__c = manageTotalAvailableQuantity;
                                if(!Nopickpack)
                                updateInventory.Delivered_Qty__c = manageDeliveredQty;
                                
                                if(Orderstatus == 'Order Confirmed' && Nopickpack !=true && pickedQuant!=0)
                                updateInventory.Picked_Quantity__c = managepicked;
                                if(Orderstatus == 'Packaged' && Nopickpack !=true)
                                updateInventory.Packaged_Quantity__c = managepackage;
                                updateInventory.id = productQty.id;
                                inventoryUpdate.add(updateInventory); 
                             
                            }
                        }
                        else{
                            if(orderData.Order_Created_Via__c == 'Web_Order')
                            {
                                manageQuantity = Integer.valueOf(productQty.Web_Available_Qty__c)+proQuantity;
                                managereserved = Integer.valueOf(productQty.Reserved_Qty__c)-proQuantity;
                                managepurcheased = Integer.valueOf(productQty.Purchased_Qty__c)-proQuantity;
                                updateInventory.Web_Available_Qty__c = manageQuantity;
                                updateInventory.Reserved_Qty__c = managereserved;
                                updateInventory.Purchased_Qty__c = managepurcheased;
                                updateInventory.id = productQty.id;
                                
                                inventoryUpdate.add(updateInventory); 
                            }
                            else
                            {
                                if(inventorystatus != 'Allocated')
                                    {
                                        if(Nopickpack && productQty.Delivered_Qty__c!=0 && productQty.Delivered_Qty__c!=NULL )
                                        {
                                            managepurcheased = Integer.valueOf(productQty.Delivered_Qty__c) - proQuantity;
                                        }
                                        else if(productQty.Reserved_Qty__c!=0 && productQty.Reserved_Qty__c!=NULL)
                                        {
                                            managepurcheased = Integer.valueOf(productQty.Reserved_Qty__c) - proQuantity;
                                        }   
                                        manageDeliveredQty =  Integer.valueOf(productQty.Delivered_Qty__c);
                                        system.debug('managepurcheased::'+managepurcheased);
                                        //code to reduce Picked Qunt
                                        if(productQty.Picked_Quantity__c!=0 && productQty.Picked_Quantity__c!=NULL )
                                        {
                                            system.debug('Inside3>>>>>');
                                            managepicked=Integer.valueOf(productQty.Picked_Quantity__c)-proQuantity;
                                            system.debug('Managevalue3::'+managepicked);
                                        }
                                        if(productQty.Packaged_Quantity__c!=0 && productQty.Packaged_Quantity__c!=NULL)
                                        {
                                            managepackage=Integer.valueOf(productQty.Packaged_Quantity__c)-proQuantity;
                                            system.debug('Managevalue4::'+managepicked);
                                        } 
                                    }
                                    else
                                    {
                                        managepurcheased = Integer.valueOf(productQty.Reserved_Qty__c);
                                        manageDeliveredQty =  Integer.valueOf(productQty.Delivered_Qty__c) - proQuantity;
                                    }
                                    manageTotalAvailableQuantity = Integer.valueOf(productQty.Available_Qty__c + proQuantity) ; //
                                    if(Nopickpack && pickedQuant==0 && inventoryallocated == true)
                                    {
                                        updateInventory.Delivered_Qty__c =managepurcheased;
                                    }
                                    else if(pickedQuant==0 && Orderlinestatus != 'Un Reserved' && inventoryallocated == true)
                                    {
                                        updateInventory.Reserved_Qty__c = managepurcheased;
                                    }
                                    if(inventoryallocated == true &&(Orderlinestatus != 'Un Reserved' || pickedQuant>0))
                                    updateInventory.Available_Qty__c = manageTotalAvailableQuantity;
                                    if(!Nopickpack)
                                    updateInventory.Delivered_Qty__c = manageDeliveredQty;
                                    if(Orderstatus == 'Order Confirmed' && Nopickpack !=true && pickedQuant!=0)
                                    updateInventory.Picked_Quantity__c = managepicked;
                                    if(Orderstatus == 'Packaged' && Nopickpack !=true)
                                    updateInventory.Packaged_Quantity__c = managepackage;
                                    
                                    updateInventory.id = productQty.id;
                                    inventoryUpdate.add(updateInventory); 
                             }
                        }            
                    }
                    
                    update inventoryUpdate;
                    
                }
                Map<Id,Id> packageILP = new Map<Id,Id>();
                Map<Id,Id> packageILPLI = new Map<Id,Id>();
                List<PackagedProducts__c> ppList = new List<PackagedProducts__c>();
                List<Package_Product_Line_Item__c> ppliList = new List<Package_Product_Line_Item__c>();
                if(Orderusageoptions.Standard_object__c == true)
                {
                    ppList = [SELECT id,Order__r.Id,Product__r.Id,Inventory_Location_Product__c,Canceled_Package__c FROM PackagedProducts__c where Order__r.Id = :orderId and Product__r.Id in :productIds];
                }
                else{
                    //   ppList = [SELECT id,Sigma_Order__r.Id,Product__r.Id,Inventory_Location_Product__c,Canceled_Package__c FROM PackagedProducts__c where Sigma_Order__r.Id = :orderId and Product__r.Id in :productIds];
                }
                
                List<Id> idlist=new List<Id>();
                for(PackagedProducts__c packageList : ppList)
                {
                    idlist.add(packageList.id);
                }
                ppliList = [SELECT Packaged_Product__c,Inventory_Location_Product__c,Inventory_Location_Product_Line_Item__c FROM Package_Product_Line_Item__c where Packaged_Product__c =: idlist];
                
                for(Package_Product_Line_Item__c pproliList : ppliList)
                {
                    packageILP.put(pproliList.Inventory_Location_Product__c,pproliList.Id);
                    packageILPLI.put(pproliList.Inventory_Location_Product_Line_Item__c,pproliList.Id);
                }
                
                //code to reduce after refund
                Integer manageILPQuantity;
                //code added to update IT reason after transaction on 09-08-2019
                set<Id> invIDList =new set<Id>();
                List<Inventory_Location_Product__c> ilpUpdate = new List<Inventory_Location_Product__c>();
                List<Inventory_Location_Product__c> ilpList;
               /* if(CRUD_FLS_CheckUtility.checkReadPermission('Inventory_Location_Product__c',new Set<String>{'Products__c','Delivered_Quantity__c'}))
                {*/
                    ilpList = [SELECT id,Products__c,Delivered_Quantity__c from Inventory_Location_Product__c WHERE id IN :packageILP.keySet()];
                //}
                for(Inventory_Location_Product__c ilpQnty : ilpList){
                    Inventory_Location_Product__c updateILP = new Inventory_Location_Product__c();
                    
                    Integer proQuantity = productQuantity.get(ilpQnty.Products__c);   
                    manageILPQuantity = Integer.valueOf(ilpQnty.Delivered_Quantity__c) - proQuantity;
                    if(CRUD_FLS_CheckUtility.checkFLS('Inventory_Location_Product__c',new Set<String>{'Delivered_Quantity__c'}))
                    {
                        updateILP.Delivered_Quantity__c = manageILPQuantity;
                        updateILP.Id = ilpQnty.id;
                    }                
                    ilpUpdate.add(updateILP);           
                }
                update ilpUpdate;
                
                
                // new code to update ilpli after refund by chandana 
                
                List<Inventory_Location_Product_Line_Item__c> ilpliList;
                List<Inventory_Location_Product_Line_Item__c> ilpliUpdate = new List<Inventory_Location_Product_Line_Item__c>();
                
                ilpliList = [SELECT id,Inventory_Location_Product__c,Product__c,Lot__c,Product_Serial_Number__c,Reserved_Quantity__c,Product_Serial_Number__r.Status__c from Inventory_Location_Product_Line_Item__c WHERE id IN :packageILPLI.keySet()];
                
                Product_Serial_Number__c psnList = new Product_Serial_Number__c();
                
                for(Inventory_Location_Product_Line_Item__c ilpliQnty : ilpliList)
                {
                    Inventory_Location_Product_Line_Item__c updateILPLI = new Inventory_Location_Product_Line_Item__c();
                    
                    Integer proQuantityilpli = productQuantity.get(ilpliQnty.Product__c);  
                    manageILPQuantity = Integer.valueOf(ilpliQnty.Reserved_Quantity__c) - proQuantityilpli;
                    updateILPLI.Reserved_Quantity__c = manageILPQuantity;
                    updateILPLI.Id = ilpliQnty.id;
                    ilpliUpdate.add(updateILPLI);           
                }
                update ilpliUpdate;
                
                //new code to update ilpli after refund by chandana ends here 
                if(Orderusageoptions.Standard_object__c == true )
                {
                    Order ordersData;
                    ordersData = [SELECT id,Last_Refund_Date_Time__c,name,Orders_Status__c,Net_Quantity__c,Quantity__c FROM Order WHERE id=:orderId];
                    ordersData.Orders_Status__c='Canceled';
                    //ordersData.Net_Quantity__c = 0;
                    ordersData.Last_Refund_Date_Time__c = system.now();
                    update ordersData;
                }
                else
                {
                    Sigma_Order__c ordersData;
                    ordersData = [SELECT id,name,Orders_Status__c,Net_Quantity__c,Quantity__c,Account_Subscription_Interval__c,Account_Subscription_Interval__r.Name,Order_Created_Via__c FROM Sigma_Order__c WHERE id=:orderId];
                    ordersData.Orders_Status__c='Canceled';
                    //ordersData.Net_Quantity__c = 0;
                    ordersData.Last_Refund_Date_Time__c = system.now();
                    update ordersData;
                    if(ordersData.Account_Subscription_Interval__c!=null)
                    {
                        system.debug('Acctsubint>>'+ordersData.Account_Subscription_Interval__c);
                        Account_Subscription_Intervals__c accsub=[select Name,Usage_Type__c,Payment_Status__c,Order_Status__c from Account_Subscription_Intervals__c where Id =: ordersData.Account_Subscription_Interval__c limit 1];                
                        system.debug('accsub before update::'+accsub);
                        if(accsub.Payment_Status__c=='Paid' && accsub.Usage_Type__c=='Product')
                            accsub.Order_Status__c='Cancelled';
                        update accsub;
                               
                    }
                    //handle invoice status after payment 13-03-2020
                    if(ordersData.Order_Created_Via__c == 'POS')
                    {
                        Invoice__c invoice = [Select id,name,Invoice_Status__c from Invoice__c where SO__c =:ordersData.id];
                         if(ordersData.Orders_Status__c == 'Canceled')
                         {
                            invoice.Invoice_Status__c='Cancelled';
                        }
                        if(invoice !=null)
                        {
                        update invoice;
                        }
                    }
                    
                }
                
                // new code to update in package as canceled package 
                //code used to reduce the lot 
                Map<String,List<Lot_Product__c>> lotMap = new Map<String,List<Lot_Product__c>>();
                List<Lot__c> lotList;
                lotList = [Select Id,Name,(Select Id,Name,Location__c,Bin__c,Quantity__c From Lot_Products__r) From Lot__c Limit 500];
                for(Lot__c lt:lotList)
                {
                    lotMap.put(lt.Id,lt.Lot_Products__r);
                }
                List<PackagedProducts__c> ppobj = new List<PackagedProducts__c>();
                List<Product_Serial_Number__c> serialnum = new List<Product_Serial_Number__c>();
                Package__c updatepackage;
                List<id> packageid= new List<id>();
                if(Orderusageoptions.Standard_object__c == true )
                {
                    ppobj = [SELECT id,Order__r.Id,Lot__c,Status__c,Quantity__c,Inventory_Location_Product__r.Inventory_Location__c,Product__r.Id,Inventory_Location_Product__c,Canceled_Package__c,Package__c FROM PackagedProducts__c where Order__r.Id = :orderId and Product__r.Id in :productIds];
                    
                }
                else{
                    // ppobj = [SELECT id,Sigma_Order__r.Id,Lot__c,Status__c,Quantity__c,Inventory_Location_Product__r.Inventory_Location__c,Product_Order__c,Product__r.Id,Inventory_Location_Product__c,Canceled_Package__c,Package__c FROM PackagedProducts__c where Sigma_Order__r.Id = :orderId and Product__r.Id in :productIds];
                    List<id> packagepp= new List<id>();
                    
                    for(PackagedProducts__c pkobj : ppobj)
                    {
                        packagepp.add(pkobj.Product_Order__c); 
                        packageid.add(pkobj.Package__c); 
                    }
                    serialnum=[SELECT id,name,Order_Line__c,Status__c,Package_Status__c from Product_Serial_Number__c where Order_Line__c = :packagepp];
                }
                for(Product_Serial_Number__c serial:serialnum)
                {
                    if(serial.Status__c=='Used')
                    {
                        serial.Status__c='Available';
                        serial.Package_Status__c = false;
                    }
                    
                }
                update serialnum;
                
                List<Package__c> packagelist= new List<Package__c>();
                Set<id> myset = new Set<id>();
                List<id> result = new List<id>();
                myset.addAll(packageid);
                result.addAll(myset);
                
                if(result != null && !result.isEmpty())
                {
                    for(id pkstatus:result)
                    {
                        
                        updatepackage = new Package__c();
                        updatepackage.Id = pkstatus;
                        updatepackage.Canceled_Package__c = true;
                        packagelist.add(updatepackage);
                    }
                    update packagelist;
                    
                    //end
                    
                }
                else 
                {
                    system.debug('exception caught');
                }
                List<Lot_Product__c> lotProductsList = new List<Lot_Product__c>();
                for(PackagedProducts__c pp : ppobj){
                    
                    List<Lot_Product__c> lotProdList = lotMap.get(pp.Lot__c);
                    Boolean isMatched = false;
                    
                    if(lotProdList != null){
                        Lot_Product__c lotProd;// = new Lot_Product__c();
                        for(Lot_Product__c lp:lotProdList){
                            if(lp.Location__c == pp.Inventory_Location_Product__r.Inventory_Location__c){
                                lotProd = lp;                                               
                                isMatched = true;
                                break;
                            }
                        }
                        
                        if(isMatched == true && pp.Status__c == 'Ready'){        
                            
                            if(pp.Status__c == 'Ready'){                                            
                                lotProd.Quantity__c = lotProd.Quantity__c + pp.Quantity__c;
                            }
                            isMatched = false;
                            lotProductsList.add(lotProd);
                        }
                    }
                }
                update lotProductsList;
                
                Payment__c insertPayment = new Payment__c();
                List<Payment__c> orderPayments;
                if(Orderusageoptions.Standard_object__c == true )
                {
                    
                    orderPayments = [SELECT id,Sigma_Order__c,OrderId__c,Customer_Name__c,Tax_Amount__c,Credit_CardNumber__c,Card_Type__c,State_Tax__c,Customer_SFID__c,Federal_Tax__c,PayPal_Transaction_Id__c,Charge_Id__c,Order_Created_Via__c,Customer_Email__c,Transaction_Type__c,Sigma_Order__r.Account_Subscription_Interval__c	 FROM Payment__c WHERE OrderId__r.id = :orderId and Status__c ='Completed'];
                    
                }
                else{
                    
                    orderPayments = [SELECT id,Sigma_Order__c,Customer_Name__c,Tax_Amount__c,Credit_CardNumber__c,Card_Type__c,State_Tax__c,Customer_SFID__c,Federal_Tax__c,PayPal_Transaction_Id__c,Charge_Id__c,Order_Created_Via__c,Customer_Email__c,Transaction_Type__c,Sigma_Order__r.Account_Subscription_Interval__c FROM Payment__c WHERE Sigma_Order__r.id = :orderId and Status__c ='Completed'];
                    
                }
                
                
                if(Orderusageoptions.Standard_object__c == true )
                {
                    insertPayment.OrderId__c = orderPayments[0].OrderId__c;
                }
                else{
                    insertPayment.Sigma_Order__c = orderPayments[0].Sigma_Order__c;
                }
                insertPayment.Status__c = 'Refunded';
                insertPayment.Amount__c = Double.valueOf(subTotalAmount);
                insertPayment.Tax_Amount__c = orderPayments[0].Tax_Amount__c;
                insertPayment.Credit_CardNumber__c = orderPayments[0].Credit_CardNumber__c;
                insertPayment.Card_Type__c = orderPayments[0].Card_Type__c;
                insertPayment.State_Tax__c = orderPayments[0].State_Tax__c;
                insertPayment.Customer_SFID__c = orderPayments[0].Customer_SFID__c;
                insertPayment.Federal_Tax__c = orderPayments[0].Federal_Tax__c;
                insertPayment.PayPal_Transaction_Id__c = orderPayments[0].PayPal_Transaction_Id__c;
                insertPayment.Charge_Id__c = orderPayments[0].Charge_Id__c;
                insertPayment.Customer_Name__c = orderPayments[0].Customer_Name__c;
                insertPayment.Customer_Email__c = orderPayments[0].Customer_Email__c;
                insertPayment.Transaction_Type__c = orderPayments[0].Transaction_Type__c;
                insertPayment.Tax_Amount__c=tax_amount;
                if(PaymentMode!= null || PaymentMode != '')
                {
                    insertPayment.Payment_Mode__c = PaymentMode;
                    insertPayment.Order_Created_Via__c = orderPayments[0].Order_Created_Via__c;
                }
				if(orderPayments[0].Sigma_Order__r.Account_Subscription_Interval__c != null)
				{
					insertPayment.Account_Subscription_Interval__c = orderPayments[0].Sigma_Order__r.Account_Subscription_Interval__c; 
				}
                if(Orderusageoptions.Standard_object__c == true )
                {
                    if(standorder.Order_Created_Via__c != 'Web_Order')
                    {
                        insertPayment.Order_Type__c = 'Offline';
                    }
                }
                else{
            }
                insert insertPayment;
				
				
					
					
				
				
            }
            catch(Exception ex){
            createErrorLog.insertError('Payment',ex.getMessage(),'Method -manageOrderOnCancel ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
            }
        //}   
    }
    
    public boolean updateLotProductonCancelOrder(Id orderId,Id productId)   
    {
        boolean flag =  false;
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__PackagedProducts__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Lot_Product__c')
           
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__PackagedProducts__c',new set<String>{'Id','Name','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__Location__c','sigmaerpdev2__Product_Order__c','sigmaerpdev2__Status__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Product__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot_Product__c',new set<String>{'Id','sigmaerpdev2__Quantity__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Product__c','sigmaerpdev2__Location__c','sigmaerpdev2__Lot__r.sigmaerpdev2__Product__c','Bin__c','sigmaerpdev2__Location__r.sigmaerpdev2__Location__c','sigmaerpdev2__Location__r.sigmaerpdev2__Location__r.Name'})   
           
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Lot_Product__c',new set<String>{'sigmaerpdev2__Quantity__c'})
          )
        {*/
            List<PackagedProducts__c> packProdList = new List<PackagedProducts__c>();
            
            packProdList = [select Id,Name,Sigma_Order__c,Location__c,Product_Order__c,Status__c,Product__c,Quantity__c,Lot__c,Inventory_Location_Product__r.Inventory_Location__c from PackagedProducts__c where Sigma_Order__c =:orderId and Product__c=:productId ]; 
            
            List<Id> lotIds =  new List<Id>();
            Map<Id,PackagedProducts__c> lotPackProdMap = new Map<Id,PackagedProducts__c>();
            
            if(packProdList.size() > 0)
            {
                for(PackagedProducts__c temp:packProdList)
                {
                    if(listContains(lotIds,temp.Lot__c))
                    {
                        System.debug('Inside List already contains lot :');
                    }
                    else
                    {
                        lotIds.add(temp.Lot__c);
                        
                    }
                    lotPackProdMap.put(temp.Lot__c,temp);
                }
                
                
            }
            
            List<Lot_Product__c> lotprodList= new List<Lot_Product__c>();
            if(lotIds.size() > 0)
            {
                lotprodList = [select Id,Quantity__c,Lot__c,Product__c,Location__c,Bin__c,Lot__r.Product__c,Location__r.Location__c,Location__r.Location__r.Name from Lot_Product__c where Lot__c IN :lotIds]; 
                system.debug('lotprodList>>>'+lotprodList);
            }
            else
            {
                System.debug('lotIds list empty so:');
            }
            if(lotprodList.size() > 0)
            {
                Integer i = 0;
                for(Lot_Product__c temp :lotprodList)
                {
                    if(lotPackProdMap.containsKey(temp.Lot__c))
                    {
                        
                        if(packProdList.size() > 0)
                        {
                            for(PackagedProducts__c tempPackProd:packProdList)
                            {
                                if(tempPackProd.Location__c != null)
                                {
                                    if(temp.Location__r.Location__c == tempPackProd.Location__c)
                                    {
                                        temp.Quantity__c = temp.Quantity__c + lotPackProdMap.get(temp.Lot__c).Quantity__c;
                                    }
                                    else
                                    {
                                        System.debug('tempPackProd.Location__c is null');
                                    }
                                    
                                }
                                else if(tempPackProd.Inventory_Location_Product__r.Inventory_Location__c !=null)
                                {   
                                    if(temp.Location__r.Location__c == tempPackProd.Inventory_Location_Product__r.Inventory_Location__c)
                                    {
                                        temp.Quantity__c = temp.Quantity__c + lotPackProdMap.get(temp.Lot__c).Quantity__c;
                                    }
                                    else
                                    {
                                        System.debug('tempPackProd.Location__c is null:'); 
                                    }
                                    
                                }
                                else
                                {
                                    System.debug('both location and ILP inside PackageProducts are empty:');
                                }
                            }
                        }   
                    }
                    else
                    {
                        System.debug('lotPackProdMap dont contains lot temp.Lot__c:'+temp.Lot__c);
                    }
                    i++;
                    
                }
                update lotprodList;
                flag = true;
                
            }
            
        //}
        return flag;
        
    }
    
    
    public boolean updateLotProductonCompleteCancelOrder(Id orderId,String mode)
    {
        boolean flag =  false;
        
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__PackagedProducts__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Lot_Product__c')
           
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__PackagedProducts__c',new set<String>{'Id','Name','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__Location__c','sigmaerpdev2__Product_Order__c','sigmaerpdev2__Status__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Inventory_Location__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot_Product__c',new set<String>{'Id','sigmaerpdev2__Quantity__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Product__c','sigmaerpdev2__Location__c','sigmaerpdev2__Lot__r.sigmaerpdev2__Product__c','sigmaerpdev2__Location__r.sigmaerpdev2__Location__c','sigmaerpdev2__Location__r.sigmaerpdev2__Location__r.Name'})
           
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Lot_Product__c',new set<String>{'sigmaerpdev2__Quantity__c'})
          )
        {*/
            List<PackagedProducts__c> packProdList = new List<PackagedProducts__c>();
            
            packProdList = [select Id,Name,Sigma_Order__c,Location__c,Product_Order__c,Status__c,Product__c,Quantity__c,Lot__c,Inventory_Location_Product__r.Inventory_Location__c from PackagedProducts__c where Sigma_Order__c =:orderId]; 
            
            List<Id> lotIds =  new List<Id>();
            Map<Id,PackagedProducts__c> lotPackProdMap = new Map<Id,PackagedProducts__c>();
            
            if(packProdList.size() > 0)
            {
                for(PackagedProducts__c temp:packProdList)
                {
                    if(listContains(lotIds,temp.Lot__c))
                    {
                        System.debug('Inside List already contains lot :');
                    }
                    else
                    {
                        lotIds.add(temp.Lot__c);
                    }
                    lotPackProdMap.put(temp.Lot__c,temp);
                }
            }
            List<Lot_Product__c> lotprodList= new List<Lot_Product__c>();
            if(lotIds.size() > 0)
            {
                lotprodList = [select Id,Quantity__c,Lot__c,Product__c,Location__c,Lot__r.Product__c,Location__r.Location__c,Location__r.Location__r.Name from Lot_Product__c where Lot__c IN :lotIds]; 
            }
            else
            {
                System.debug('lotIds list empty so:');
            }
            if(lotprodList.size() > 0)
            {
                Integer i = 0;
                for(Lot_Product__c temp :lotprodList)
                {
                    if(lotPackProdMap.containsKey(temp.Lot__c))
                    {
                        
                        if(packProdList.size() > 0)
                        {
                            for(PackagedProducts__c tempPackProd:packProdList)
                            {
                                if(tempPackProd.Location__c != null)
                                {
                                    if(temp.Location__r.Location__c == tempPackProd.Location__c)
                                    {
                                        temp.Quantity__c = temp.Quantity__c + lotPackProdMap.get(temp.Lot__c).Quantity__c;
                                    }
                                    else
                                    {
                                        System.debug('tempPackProd.Location__c is null');
                                    }
                                    
                                }
                                else if(tempPackProd.Inventory_Location_Product__r.Inventory_Location__c !=null)
                                {   
                                    if(temp.Location__r.Location__c == tempPackProd.Inventory_Location_Product__r.Inventory_Location__c)
                                    {
                                        temp.Quantity__c = temp.Quantity__c + lotPackProdMap.get(temp.Lot__c).Quantity__c;
                                    }
                                    else
                                    {
                                        System.debug('tempPackProd.Location__c is null:'); 
                                    }
                                    
                                }
                                else
                                {
                                    System.debug('both location and ILP inside PackageProducts are empty:');
                                }
                                
                            }
                        }
                        
                    }
                    else
                    {
                        System.debug('lotPackProdMap dont contains lot temp.Lot__c:'+temp.Lot__c);
                    }
                    i++;
                    
                }
                update lotprodList;
                flag = true;
                
            }
            
            
        //}
        return flag;
        
    }
    public static CancelOrderManagement createRefund(String chargeID,String refundAmount)
    {
        String response;
        CancelOrderManagement o;
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Stripe_API__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Stripe_API__c',new set<String>{'id','sigmaerpdev2__Api_Key__c','sigmaerpdev2__Charge_URL__c','sigmaerpdev2__Token_URL__c','sigmaerpdev2__Refund_URL__c'})
          )
        {*/
            
            Stripe_API__c sap;
            
            sap = [select id,Api_Key__c,Charge_URL__c,Token_URL__c,Refund_URL__c from Stripe_API__c Limit 1];
            REFUND_CHARGE_URL = sap.Refund_URL__c;
            API_KEY = sap.Api_Key__c;   
            
            HttpRequest http = new HttpRequest();
            http.setEndpoint(REFUND_CHARGE_URL);
            http.setMethod('POST');
            Blob headerValue = Blob.valueOf(API_KEY + ':');
            String authorizationHeader = 'BASIC ' +
                EncodingUtil.base64Encode(headerValue);
            http.setHeader('Authorization', authorizationHeader);
            
            Map<String, String> payload = new Map<String, String>();
            payload.put('charge',chargeID);
            
            payload.put('amount',refundAmount);
            
            
            http.setBody(StripeUtil.urlify(payload));
            
            
            Integer statusCode;
            Http con = new Http();
            HttpResponse hs = new HttpResponse();
            
            //if (!Test.isRunningTest()) {
            try {
                hs = con.send(http);
            } catch (CalloutException e) {
                system.debug('e>>>>>>'+e);
                return null;
            }
            // } 
            
            
            response = hs.getBody();
            statusCode = hs.getStatusCode();
            try {
            o = CancelOrderManagement.parse(response);
            return o;
            } catch (System.JSONException e) {
                return null;
            }
        //} 
        return o;   
    }
    
    public static CancelOrderManagement parse(String json) 
    {
        json = StripeUtil.cleanJson(json);
        
        return (CancelOrderManagement) 
            System.JSON.deserialize(json, CancelOrderManagement.class);
    }
    
    public void manageinventoryOnCancelorder(Id orderId, Decimal subTotalAmount)
    {
           /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Order_Usage__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Default_Parameters__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Allocation__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Package__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Serial_Number__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Lot__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Lot_Product__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Time_Base_Inventory__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__PackagedProducts__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Package_Product_Line_Item__c') 
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Dimension_Tag__c') 
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Invoice__c')
            
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Order_Usage__c',new set<String>{'Id','sigmaerpdev2__Sigma_order__c','sigmaerpdev2__Standard_object__c','sigmaerpdev2__Allocation_in_Sales_Order__c','sigmaerpdev2__Allocation_in_Picking__c','sigmaerpdev2__Auto_Allocate_in_picking__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Default_Parameters__c',new set<String>{'Id','sigmaerpdev2__Inventory_Status__c','sigmaerpdev2__Default_Location__c','sigmaerpdev2__Package_ID__c','sigmaerpdev2__Parent_Id__c','sigmaerpdev2__Shipment_ID__c','sigmaerpdev2__StockReceiving_ID__c','sigmaerpdev2__Default_Bin__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location__c',new set<String>{'id','name','sigmaerpdev2__Location__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'id','name','AccountId','Quantity__c','sigmaerpdev2__Tax_Amount__c','sigmaerpdev2__Order_Created_Via__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Net_Amount__c','sigmaerpdev2__Orders_Status__c','No_Picking_Package_Shipment_Required__c','sigmaerpdev2__Customer_Type__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'id','name','PriceBookEntry.Product2.Id','Quantity','sigmaerpdev2__Net_Quantity__c','IsInventoryUpdated__c','Back_Order__c','sigmaerpdev2__Order_Status__c','sigmaerpdev2__Tax_Amount__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new set<String>{'id','name','sigmaerpdev2__AccountId__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__No_Picking_Package_Shipment_Required__c','sigmaerpdev2__Tax_Amount__c','sigmaerpdev2__Order_Created_Via__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Orders_Status__c','sigmaerpdev2__TotalAmount__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'id','name','sigmaerpdev2__Order_Status__c','Inventory_Status__c','IsInventoryUpdated__c','sigmaerpdev2__Product__c','sigmaerpdev2__tax_amount__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Packaged_Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Package__c',new set<String>{'id','name','sigmaerpdev2__Canceled_Package__c '})      
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'id','name','sigmaerpdev2__Deliver_Quantity__c','Reserved_Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'id','name','sigmaerpdev2__Bin__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Adjusted_Quantity1__c','sigmaerpdev2__Product__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Product_Serial_Number__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Serial_Number__c',new set<String>{'id','name','Status__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot__c',new set<String>{'id','name'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot_Product__c',new set<String>{'id','name','Location__c','Bin__c','Product__c','Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Time_Base_Inventory__c',new set<String>{'id','name','sigmaerpdev2__Order__c','sigmaerpdev2__Proposal_to_Order__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new set<String>{'id','name','sigmaerpdev2__ProductCode__c','sigmaerpdev2__Delivered_Qty__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Web_Available_Qty__c','sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Purchased_Qty__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__Picked_Quantity__c','sigmaerpdev2__Packaged_Quantity__c','Comments__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__PackagedProducts__c',new set<String>{'id','name','sigmaerpdev2__Order__r.Id','sigmaerpdev2__Product__r.Id','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Canceled_Package__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Package_Product_Line_Item__c',new set<String>{'id','name','sigmaerpdev2__Packaged_Product__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c '})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Allocation__c',new set<String>{'id','Name','sigmaerpdev2__ILPLI__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__ILPLI__r.sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__ILPLI__r.sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Picked_Quantity__c','sigmaerpdev2__ILPLI__r.sigmaerpdev2__Bin__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Dimension_Tag__c',new set<String>{'id','sigmaerpdev2__Base_Credit_Limit__c','sigmaerpdev2__Ordered_Amount__c','sigmaerpdev2__Paid_Amount__c','sigmaerpdev2__Account__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Invoice__c',new set<String>{'id','name','sigmaerpdev2__Invoice_Status__c','sigmaerpdev2__SO__c'})
            
            &&  CRUD_FLS_CheckUtility.checkFLS('Order',new set<String>{'sigmaerpdev2__Orders_Status__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Last_Refund_Date_Time__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('OrderItem',new set<String>{'sigmaerpdev2__Order_Status__c','sigmaerpdev2__Packaged_Quantity__c','sigmaerpdev2__Remaining_Qty_To_Package__c','Quantity','sigmaerpdev2__Net_Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Order__c',new Set<String>{'sigmaerpdev2__Orders_Status__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Last_Refund_Date_Time__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev2__Packaged_Quantity__c','sigmaerpdev2__Order_Status__c','sigmaerpdev2__Remaining_Qty_To_Package__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Net_Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Package__c',new Set<String>{'sigmaerpdev2__Canceled_Package__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev2__Deliver_Quantity__c','sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Products__c','sigmaerpdev2__Received_Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Adjusted_Quantity1__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Product__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Product_Serial_Number__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Serial_Number__c',new Set<String>{'sigmaerpdev2__Status__c','sigmaerpdev2__Serial_Number__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Product_Code__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Lot_Product__c',new Set<String>{'sigmaerpdev2__Quantity__c','sigmaerpdev2__Location__c','sigmaerpdev2__Product__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Bin__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new Set<String>{'sigmaerpdev2__Packaged_Quantity__c','sigmaerpdev2__Picked_Quantity__c','sigmaerpdev2__Delivered_Qty__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Reserved_Qty__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Dimension_Tag__c',new Set<String>{'sigmaerpdev2__Ordered_Amount__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Invoice__c',new Set<String>{'sigmaerpdev2__Invoice_Status__c'})
            )
        { */
            try
            {
            
                Order_Usage__c Orderusageoptions;
                Orderusageoptions = [select Id,Sigma_order__c,Standard_object__c,Allocation_in_Sales_Order__c,Allocation_in_Picking__c,Auto_Allocate_in_picking__c from Order_Usage__c limit 1];
                Integer manageQuantity;
                Integer managereserved;
                Integer managepurcheased;
                Integer manageDeliveredQty;
                Integer managepicked;
                Integer managepackage;
                Integer manageTotalAvailableQuantity;
                Sigma_Order__c orderData;
                order standorder;
                decimal pickedQuant=0;
                Boolean inventoryallocated;
                Boolean Nopickpack;
                Boolean ispackaged = false;
                String Orderlinestatus;
                String Orderstatus;
                Id Inventoryloc;
                Default_Parameters__c options;
                Decimal CreditAmount =0;
                
                
                options = [select Id,Inventory_Status__c,Default_Bin__c,Default_Location__c,Package_ID__c,Parent_Id__c,Shipment_ID__c,StockReceiving_ID__c from Default_Parameters__c limit 1];
                
                String  inventorystatus = options.Inventory_Status__c;
                String  Defaultlocation = options.Default_Location__c;
                String  Defaultbin = options.Default_Bin__c;
                List<Inventory_Location__c>InventoryLocation = new List<Inventory_Location__c>();     
                InventoryLocation=[select id,name,Location__c from Inventory_Location__c where id =:Defaultlocation];
                if(InventoryLocation.size()>0)
                Inventoryloc = InventoryLocation[0].id; 
                Map<String,Integer> productQuantity = new Map<String,Integer>();
                if(Orderusageoptions.Standard_object__c == true && inventorystatus == 'Reserve' )
                {
                    
                    standorder = [SELECT id,AccountId,Quantity__c,Tax_Amount__c,Customer_Type__c,Order_Created_Via__c, Net_Quantity__c,Net_Amount__c,Orders_Status__c,No_Picking_Package_Shipment_Required__c FROM Order WHERE id=:orderId];
                    Nopickpack = standorder.No_Picking_Package_Shipment_Required__c;
                    List<OrderItem> orderStatusUpdate = new List<OrderItem>();
                    List<OrderItem> orderProducts;
                    if(standorder.Customer_Type__c == 'Cash Customer')
                    {
                        system.debug('infirstif');
                        orderProducts = [SELECT id,PriceBookEntry.Product2.Id,Quantity,Remaining_Qty_To_Package__c,Packaged_Quantity__c,Net_Quantity__c,IsInventoryUpdated__c,Order_Status__c,Is_Credit_Updated__c,(Select id,Name,ILPLI__c,Quantity__c,ILPLI__r.Available_Quantity__c,ILPLI__r.Reserved_Quantity__c,Picked_Quantity__c,ILPLI__r.Bin__c from Inventory_Allocations__r ) FROM OrderItem WHERE OrderId=:orderId AND Order_Status__c != 'Canceled'];
                        system.debug('orderProducts@@'+orderProducts);
                        for(OrderItem productsData:orderProducts)
                        {
                            //productsData.Net_Quantity__c = 0;
                            //productsData.Quantity = productsData.Net_Quantity__c;
                            productsData.Remaining_Qty_To_Package__c=0;
                            productsData.Order_Status__c = 'Canceled';
                            if(productsData.Packaged_Quantity__c==null)
                            productsData.Packaged_Quantity__c = 0;
                                
                        }
                        update orderProducts;
                    }
                    else    
                    {
                        if(standorder.Orders_Status__c == 'Pending')
                        {
                            orderProducts = [SELECT id,PriceBookEntry.Product2.Id,Quantity,Net_Quantity__c,IsInventoryUpdated__c,Order_Status__c,Is_Credit_Updated__c,TotalPrice__c,(Select id,Name,ILPLI__c,Quantity__c,ILPLI__r.Available_Quantity__c,ILPLI__r.Reserved_Quantity__c,Picked_Quantity__c,ILPLI__r.Bin__c from Inventory_Allocations__r ) FROM OrderItem WHERE OrderId=:orderId AND Order_Status__c != 'Canceled'];
                    
                        }
                        else
                        {
                            orderProducts = [SELECT id,PriceBookEntry.Product2.Id,Quantity,Net_Quantity__c,IsInventoryUpdated__c,Order_Status__c,Is_Credit_Updated__c,TotalPrice__c,(Select id,Name,ILPLI__c,Quantity__c,ILPLI__r.Available_Quantity__c,ILPLI__r.Reserved_Quantity__c,Picked_Quantity__c,ILPLI__r.Bin__c from Inventory_Allocations__r ) FROM OrderItem WHERE OrderId=:orderId AND Order_Status__c != 'Canceled'];
                    
                        }
                        //orderProducts = [SELECT id,PriceBookEntry.Product2.Id,Quantity,Net_Quantity__c,IsInventoryUpdated__c,Order_Status__c,(Select id,Name,ILPLI__c,Quantity__c,ILPLI__r.Available_Quantity__c,ILPLI__r.Reserved_Quantity__c,Picked_Quantity__c,ILPLI__r.Bin__c from Inventory_Allocations__r ) FROM OrderItem WHERE OrderId=:orderId AND Order_Status__c != 'Canceled' AND IsInventoryUpdated__c =true];
                        productIds = new List<String>();
                        Map<id,decimal> ReservedQuant=new Map<id,decimal>();
                        Map<id,decimal> BinQunt = new map<id,decimal>();
                        List<Id>ProductID=new List<Id>();
                        set<Id>Productserialnumber=new set<Id>();
                        List<Id>LocationID=new List<Id>();
                        List<Id>BinId=new List<Id>();
                        for(OrderItem productsData:orderProducts)
                        {
                            for(Inventory_Allocation__c Allocateproduct: productsData.Inventory_Allocations__r )
                            {
                                if(ReservedQuant.containsKey(Allocateproduct.ILPLI__c))
                                {
                                    decimal totalqyt = ReservedQuant.get(Allocateproduct.ILPLI__c);
                                    ReservedQuant.put(Allocateproduct.ILPLI__c,totalqyt+Allocateproduct.Quantity__c);
                                }
                                else
                                {
                                    ReservedQuant.put(Allocateproduct.ILPLI__c,Allocateproduct.Quantity__c);
                                }
                                
                                
                                if(Allocateproduct.Picked_Quantity__c==null)
                                    Allocateproduct.Picked_Quantity__c=0;
                                   pickedQuant+=Allocateproduct.Picked_Quantity__c;
                                  BinQunt.put(Allocateproduct.ILPLI__r.Bin__c,Allocateproduct.Picked_Quantity__c); 
                                
                            } 
                            if(productsData.Is_Credit_Updated__c)
                            CreditAmount += productsData.TotalPrice__c;
                            if(productsData.Order_Status__c == 'Packaged')
                            ispackaged =true;
                            Orderstatus = productsData.Order_Status__c;
                            inventoryallocated = productsData.IsInventoryUpdated__c;
                            OrderItem orderUpdate = new OrderItem();
                            if(productsData.Order_Status__c !='Pending')
                            productIds.add(productsData.PriceBookEntry.Product2Id);
                            if(productsData.IsInventoryUpdated__c)
                            {
                                if(productQuantity.containsKey(productsData.PriceBookEntry.Product2Id))
                                {
                                    Integer netqty= productQuantity.get(productsData.PriceBookEntry.Product2Id);
                                        
                                    productQuantity.put(productsData.PriceBookEntry.Product2Id,Integer.valueOf(productsData.Quantity)+netqty);
                                }
                                else
                                {
                                  productQuantity.put(productsData.PriceBookEntry.Product2Id,Integer.valueOf(productsData.Quantity)); 
                                }
                            }
                                
                            orderUpdate.Id = productsData.id;
                            //orderUpdate.Net_Quantity__c = 0;
                            //orderUpdate.Quantity = orderUpdate.Net_Quantity__c;
                            orderUpdate.Remaining_Qty_To_Package__c=0;
                            orderUpdate.Order_Status__c = 'Canceled';
                            if(orderUpdate.Packaged_Quantity__c==null)
                            orderUpdate.Packaged_Quantity__c = 0;
                            orderStatusUpdate.add(orderUpdate);
                        }
                        update orderStatusUpdate;
                        
                        


                        //code to update cancelorder checkbox in package
                        //if(Orderstatus == 'Packaged')
                        //{
                            system.debug('IDSSS'+standorder.Id);
                            system.debug('ispackaged@@'+ispackaged);
                            if(ispackaged)
                            {
                                Package__c packageproduct = [select id,Name,Canceled_Package__c from Package__c where Order__c=:standorder.Id];
                                system.debug('packageproduct@'+packageproduct);
                                if(packageproduct !=null)
                                {
                                    system.debug('insidepack');
                                    packageproduct.Canceled_Package__c = true;
                                    update packageproduct;
                                }
                            }
                            
                            
                        //}
                        
                        
                        List<Inventory_Location_Product_Line_Item__c>updateILPLI=new List<Inventory_Location_Product_Line_Item__c>();
                        updateILPLI=[select id,name,Bin__c,Inventory_Location_Product__c,Reserved_Quantity__c,Adjusted_Quantity1__c,Product__c,Inventory_Location__c,Product_Serial_Number__c,Delivered_Quantity__c from Inventory_Location_Product_Line_Item__c where id=:ReservedQuant.keySet()];
                        Map<id,decimal> ilpmap=new Map<id,decimal>();
                        for(Inventory_Location_Product_Line_Item__c ilpli:updateILPLI)
                        {
                            
                            if(ilpli.Product_Serial_Number__c!=null)
                            {
                                Productserialnumber.add(ilpli.Product_Serial_Number__c);
                                
                            }
                            
                            if(ilpli.Product__c!=null)
                            {
                                ProductID.add(ilpli.Product__c);
                            }
                            if(ilpli.Inventory_Location__c!=null)
                            {
                                LocationID.add(ilpli.Inventory_Location__c);
                            }
                            
                            if(ilpli.Bin__c!=null)
                                {
                                   BinId.add(ilpli.Bin__c); 
                                }
                            if(ReservedQuant.containsKey(ilpli.id))
                            {
                                if(Nopickpack && pickedQuant==0)
                                {
                                    ilpli.Delivered_Quantity__c-=ReservedQuant.get(ilpli.id);
                                }
                                else if(ilpli.Reserved_Quantity__c!=0 && ilpli.Reserved_Quantity__c!=NULL && pickedQuant==0)
                                {
                                    ilpli.Reserved_Quantity__c-=ReservedQuant.get(ilpli.id);
                                }
                                    
                                if(ilpli.Adjusted_Quantity1__c!=0 && ilpli.Adjusted_Quantity1__c!=NULL && pickedQuant > 0 )
                                    ilpli.Adjusted_Quantity1__c-=ReservedQuant.get(ilpli.id);
                                
                                if(ilpmap.containsKey(ilpli.Inventory_Location_Product__c))
                                {
                                    decimal qty= ilpmap.get(ilpli.Inventory_Location_Product__c);
                                    
                                    ilpmap.put(ilpli.Inventory_Location_Product__c,qty+ReservedQuant.get(ilpli.id));
                                }
                                else
                                {
                                    ilpmap.put(ilpli.Inventory_Location_Product__c,ReservedQuant.get(ilpli.id));
                                }
                                
                            }
                            
                            
                        }
                        update updateILPLI;
                        update orderStatusUpdate;
                        if(ilpmap.size()>0)
                        {
                            List<Inventory_Location_Product__c> ILPLIST= [select id,name,Deliver_Quantity__c,Reserved_Quantity__c from Inventory_Location_Product__c where id=:ilpmap.keySet()];
                            for(Inventory_Location_Product__c ilp:ILPLIST)
                            {
                                if(Nopickpack && ilpmap.containsKey(ilp.id))
                                {
                                    ilp.Deliver_Quantity__c -= ilpmap.get(ilp.id);
                                }
                                else if(ilpmap.containsKey(ilp.id))
                                {
                                    ilp.Reserved_Quantity__c-=ilpmap.get(ilp.id);
                                }
                                
                            }
                            update ILPLIST;
                        }
                        if(Productserialnumber.size()>0)
                        {
                            List<Product_Serial_Number__c> serialststusupdate=new List<Product_Serial_Number__c>();
                            serialststusupdate=[select id,name,Status__c from Product_Serial_Number__c where id=:Productserialnumber];
                            for(Product_Serial_Number__c serialstatus:serialststusupdate)
                            {
                                serialstatus.Status__c='Available';
                            }
                            update serialststusupdate;
                            
                        }
                        //updating LOT Product2
                        if(BinQunt.size()>0)
                        {
                          List<Lot_Product__c>Lotproduct=[Select id,Name,Location__c,Bin__c,Product__c,Quantity__c from Lot_Product__c where Product__c =:ProductID and Location__c=:LocationID and  Bin__c=:BinId];
                          for(Lot_Product__c LP:Lotproduct)
                          {
                          if(LP.Product__c!=null && LP.Bin__c!=null && pickedQuant>0 && BinQunt.containsKey(LP.Bin__c))
                          LP.Quantity__c+=BinQunt.get(LP.Bin__c);
                          }
                          update Lotproduct;
                        }
                         
                          //code to update PI
                        if(productIds.size()>0 && productQuantity.size()>0)
                        {
                            List<Inventory__c> productInventory = [SELECT id,name,ProductCode__c,Delivered_Qty__c,Available_Qty__c,Web_Available_Qty__c,Reserved_Qty__c,Purchased_Qty__c,Total_Available_Qty__c,Picked_Quantity__c,Packaged_Quantity__c,Comments__c from Inventory__c WHERE ProductCode__c IN :productIds];
                            system.debug('productInventory@@@'+productInventory);
                            for(Inventory__c productQty:productInventory)
                            {
                              productQty.Available_Qty__c+=productQuantity.get(productQty.ProductCode__c);
                                if(Nopickpack && pickedQuant==0 )
                                {
                                    productQty.Delivered_Qty__c -= productQuantity.get(productQty.ProductCode__c);
                                }
                                else if(pickedQuant==0)
                                    productQty.Reserved_Qty__c -=productQuantity.get(productQty.ProductCode__c);
                                if(Orderstatus == 'Order Confirmed' && Nopickpack !=true && pickedQuant!=0)
                                    productQty.Picked_Quantity__c -=productQuantity.get(productQty.ProductCode__c);
                                if(Orderstatus == 'Packaged' && Nopickpack !=true)
                                    productQty.Packaged_Quantity__c -=productQuantity.get(productQty.ProductCode__c);
                                
                            }
                            system.debug('productInventory!!!!'+productInventory);
                            update productInventory;  
                        }
                        
                        if(standorder.Customer_Type__c=='Credit Customer' && CreditAmount> 0)
                        {
                            Dimension_Tag__c DT =[select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: standorder.AccountId limit 1];
                            DT.Ordered_Amount__c -=CreditAmount;
                            update DT;
                        }
                        
                        
                       
                    }
                        //update sigma order status
                        standorder.Orders_Status__c ='Canceled';
                        update standorder;
                    
                }
                
                //code to reduce inventory when allocation done in sigma order
                else if(Orderusageoptions.Sigma_order__c==true && inventorystatus == 'Reserve')
                {
                    
                    orderData = [SELECT id, name,AccountId__c,Customer_Type__c,Quantity__c,No_Picking_Package_Shipment_Required__c,Tax_Amount__c, Order_Created_Via__c, Net_Quantity__c, Orders_Status__c,TotalAmount__c FROM Sigma_Order__c WHERE id=:orderId];
                    Nopickpack=orderData.No_Picking_Package_Shipment_Required__c;
                    List<Product_Order_Price_Book__c> orderStatusUpdate = new List<Product_Order_Price_Book__c>();
                    List<Product_Order_Price_Book__c> orderProducts;
                    
                    if(orderData.Customer_Type__c == 'Cash Customer')
                    {
                    
                        orderProducts = [SELECT id,name,Remaining_Qty_To_Package__c,Order_Status__c,Inventory_Status__c,IsInventoryUpdated__c,Product__c,tax_amount__c,Quantity__c,Net_Quantity__c,Packaged_Quantity__c,Is_Credit_Updated__c,Total_Price__c,(Select id,Name,ILPLI__c,Quantity__c,ILPLI__r.Available_Quantity__c,ILPLI__r.Reserved_Quantity__c,Picked_Quantity__c,ILPLI__r.Bin__c,ILPLI__r.Lot__c from Inventory_Allocations1__r ) FROM Product_Order_Price_Book__c WHERE Sigma_Order__c=:orderId AND Order_Status__c != 'Canceled'];
                        for(Product_Order_Price_Book__c productsData:orderProducts)
                        {
                            //productsData.Net_Quantity__c = 0;
                            //productsData.Quantity__c=0;
                            productsData.Remaining_Qty_To_Package__c = 0;
                            productsData.Order_Status__c = 'Canceled';
                            if(productsData.Packaged_Quantity__c==null)
                            productsData.Packaged_Quantity__c = 0; 
                        }
                        update orderProducts;
                    }
                    else
                    {
                        //updating ILPLI
                        if(orderData.Orders_Status__c == 'Pending')    
                        {
                            orderProducts = [SELECT id,name,Order_Status__c,Inventory_Status__c,IsInventoryUpdated__c,Product__c,tax_amount__c,Quantity__c,Net_Quantity__c,Packaged_Quantity__c,Is_Credit_Updated__c,Total_Price__c,(Select id,Name,ILPLI__c,Quantity__c,ILPLI__r.Available_Quantity__c,ILPLI__r.Reserved_Quantity__c,Picked_Quantity__c,ILPLI__r.Bin__c,ILPLI__r.Lot__c from Inventory_Allocations1__r ) FROM Product_Order_Price_Book__c WHERE Sigma_Order__c=:orderId AND Order_Status__c != 'Canceled'];
                        }
                        else
                        {
                            orderProducts = [SELECT id,name,Order_Status__c,Inventory_Status__c,IsInventoryUpdated__c,Product__c,tax_amount__c,Quantity__c,Net_Quantity__c,Packaged_Quantity__c,Is_Credit_Updated__c,Total_Price__c,(Select id,Name,ILPLI__c,Quantity__c,ILPLI__r.Available_Quantity__c,ILPLI__r.Reserved_Quantity__c,Picked_Quantity__c,ILPLI__r.Bin__c,ILPLI__r.Lot__c from Inventory_Allocations1__r ) FROM Product_Order_Price_Book__c WHERE Sigma_Order__c=:orderId AND Order_Status__c != 'Canceled'];
                        }
                        
                        Map<id,decimal> ReservedQuant=new Map<id,decimal>();
                        Map<id,decimal> BinQunt = new map<id,decimal>();
                        set<Id>Productserialnumber=new set<Id>();
                        List<Id>ProductID=new List<Id>();
                        List<Id>LocationID=new List<Id>();
                        List<Id>BinId = new List<Id>();
                        List<ID>LOTIDS = new List<ID>();
                        
                        productIds = new List<String>();
                        for(Product_Order_Price_Book__c productsData:orderProducts)
                        {
                            tax_amount=+ productsData.tax_amount__c;
                            for(Inventory_Allocation__c Allocateproduct: productsData.Inventory_Allocations1__r )
                            {
                                if(ReservedQuant.containsKey(Allocateproduct.ILPLI__c))
                                {
                                    decimal totalqyt = ReservedQuant.get(Allocateproduct.ILPLI__c);
                                    ReservedQuant.put(Allocateproduct.ILPLI__c,totalqyt+Allocateproduct.Quantity__c);
                                }
                                else
                                {
                                    ReservedQuant.put(Allocateproduct.ILPLI__c,Allocateproduct.Quantity__c);
                                }
                                
                                
                                if(Allocateproduct.Picked_Quantity__c==null)
                                    Allocateproduct.Picked_Quantity__c=0;
                                pickedQuant+=Allocateproduct.Picked_Quantity__c;
                                if(Allocateproduct.ILPLI__r.Lot__c !=null)
                                LOTIDS.add(Allocateproduct.ILPLI__r.Lot__c);
                                BinQunt.put(Allocateproduct.ILPLI__r.Bin__c,Allocateproduct.Picked_Quantity__c);
                            }
                            if(productsData.Is_Credit_Updated__c)
                            CreditAmount += productsData.Total_Price__c;
                            if(productsData.Order_Status__c == 'Packaged')
                            ispackaged =true;
                            Orderstatus = productsData.Order_Status__c;
                            Orderlinestatus = productsData.Inventory_Status__c;
                            inventoryallocated = productsData.IsInventoryUpdated__c;                    
                            Product_Order_Price_Book__c orderUpdate = new Product_Order_Price_Book__c();
                            if(productsData.Order_Status__c !='Pending')
                            productIds.add(productsData.Product__c);
                            //productQuantity.put(productsData.Product__c,Integer.valueOf(productsData.Net_Quantity__c));
                            if(productsData.IsInventoryUpdated__c)
                            {
                                if(productQuantity.containsKey(productsData.Product__c))
                                {
                                    Integer netqty = productQuantity.get(productsData.Product__c);
                                    productQuantity.put(productsData.Product__c,Integer.valueOf(productsData.Net_Quantity__c)+netqty);
                                }
                                else
                                {
                                    productQuantity.put(productsData.Product__c,Integer.valueOf(productsData.Net_Quantity__c)); 
                                }
                            }
                            
                            orderUpdate.Id = productsData.id;
                            //orderUpdate.Net_Quantity__c = 0;
                            //orderUpdate.Quantity__c=0;
                            orderUpdate.Remaining_Qty_To_Package__c = 0;
                            orderUpdate.Order_Status__c = 'Canceled';
                            if(orderUpdate.Packaged_Quantity__c==null)
                            orderUpdate.Packaged_Quantity__c = 0;
                            orderStatusUpdate.add(orderUpdate);
                            
                        }
                        
                        if(ispackaged)
                        {
                            Package__c packageproduct = [select id,Name,Canceled_Package__c from Package__c where Sigma_Order__c=:orderData.id];
                            if(packageproduct !=null)
                            {
                                packageproduct.Canceled_Package__c = true;
                                update packageproduct;
                            }
                            
                        }
                        List<Inventory_Location_Product_Line_Item__c>updateILPLI=new List<Inventory_Location_Product_Line_Item__c>();
                        updateILPLI=[select id,name,Inventory_Location_Product__c,Reserved_Quantity__c,Adjusted_Quantity1__c,Product__c,Inventory_Location__c,Bin__c,Product_Serial_Number__c,Delivered_Quantity__c from Inventory_Location_Product_Line_Item__c where id=:ReservedQuant.keySet()];
                        Map<id,decimal> ilpmap=new Map<id,decimal>();
                    
                            for(Inventory_Location_Product_Line_Item__c ilpli:updateILPLI)
                            {
                                 if(ilpli.Product_Serial_Number__c!=null)
                                {
                                    Productserialnumber.add(ilpli.Product_Serial_Number__c);
                                    system.debug('Productserialnumber>>'+Productserialnumber);
                                }
                                if(ilpli.Product__c!=null)
                                {
                                    ProductID.add(ilpli.Product__c);
                                }
                                if(ilpli.Inventory_Location__c!=null)
                                {
                                    LocationID.add(ilpli.Inventory_Location__c);
                                }
                                if(ilpli.Bin__c!=null)
                                {
                                   BinId.add(ilpli.Bin__c); 
                                   
                                } 
                                if(ReservedQuant.containsKey(ilpli.id))
                                {
                                    if(Nopickpack && pickedQuant==0)
                                    {
                                        ilpli.Delivered_Quantity__c-=ReservedQuant.get(ilpli.id);
                                    }
                                    else if(ilpli.Reserved_Quantity__c!=0 && ilpli.Reserved_Quantity__c!=NULL && pickedQuant==0 && Orderlinestatus != 'Un Reserved')
                                    {
                                        ilpli.Reserved_Quantity__c-=ReservedQuant.get(ilpli.id);
                                    }    
                                    if(ilpli.Adjusted_Quantity1__c!=0 && ilpli.Adjusted_Quantity1__c!=NULL && pickedQuant >0 )
                                        ilpli.Adjusted_Quantity1__c-=ReservedQuant.get(ilpli.id);
                                    
                                    if(ilpmap.containsKey(ilpli.Inventory_Location_Product__c))
                                    {
                                        decimal qty= ilpmap.get(ilpli.Inventory_Location_Product__c);
                                        
                                        ilpmap.put(ilpli.Inventory_Location_Product__c,qty+ReservedQuant.get(ilpli.id));
                                    }
                                    else
                                    {
                                        ilpmap.put(ilpli.Inventory_Location_Product__c,ReservedQuant.get(ilpli.id));
                                    }
                                }
                            }
                            
                            if(updateILPLI.size()>0)
                            update updateILPLI;
                            update orderStatusUpdate;
                            
                            if(ilpmap.size()>0)
                            {
                                List<Inventory_Location_Product__c> ILPLIST= [select id,name,Deliver_Quantity__c,Reserved_Quantity__c from Inventory_Location_Product__c where id=:ilpmap.keySet()];
                                system.debug('ILPLIST:::::'+ILPLIST);
                                for(Inventory_Location_Product__c ilp:ILPLIST)
                                {
                                    if(Nopickpack && ilpmap.containsKey(ilp.id))
                                    {
                                        ilp.Deliver_Quantity__c -= ilpmap.get(ilp.id);
                                    }
                                    else if(ilpmap.containsKey(ilp.id)&& Orderlinestatus != 'Un Reserved')
                                    {
                                        ilp.Reserved_Quantity__c-=ilpmap.get(ilp.id);
                                    }
                                
                                }
                                update ILPLIST;
                                system.debug('ILPLIST>>>'+ILPLIST);
                            }
                            
                        if(BinQunt.size()>0)
                        {
                            List<Lot_Product__c>Lotproduct=[Select id,Name,Location__c,Bin__c,Product__c,Quantity__c from Lot_Product__c where Product__c =:ProductID and Location__c=:LocationID and Bin__c =:BinId and Lot__c =:LOTIDS];
                            for(Lot_Product__c LP:Lotproduct)
                            {
                                if(LP.Product__c!=null && LP.Bin__c!=null && pickedQuant>0 && BinQunt.containsKey(LP.Bin__c))
                                LP.Quantity__c+=BinQunt.get(LP.Bin__c);
                            }
                                update Lotproduct;
                        }
                        
                        if(Productserialnumber.size()>0)
                        {
                            List<Product_Serial_Number__c> serialststusupdate=new List<Product_Serial_Number__c>();
                            serialststusupdate=[select id,name,Status__c from Product_Serial_Number__c where id=:Productserialnumber];
                            for(Product_Serial_Number__c serialstatus:serialststusupdate)
                            {
                                serialstatus.Status__c='Available';
                            }
                            update serialststusupdate;
                            system.debug('serialststusupdate>>'+serialststusupdate);
                        }
                        
                        //code to update PI 
                        if(productIds.size()>0 && productQuantity.size()>0)
                        {
                            List<Inventory__c> productInventory = [SELECT id,name,ProductCode__c,Delivered_Qty__c,Available_Qty__c,Web_Available_Qty__c,Reserved_Qty__c,Purchased_Qty__c,Total_Available_Qty__c,Picked_Quantity__c,Packaged_Quantity__c,Comments__c from Inventory__c WHERE ProductCode__c IN :productIds];
                            for(Inventory__c productQty:productInventory)
                            {
                                productQty.Available_Qty__c+=productQuantity.get(productQty.ProductCode__c);
                                if(Nopickpack && pickedQuant==0 )
                                {
                                    productQty.Delivered_Qty__c -= productQuantity.get(productQty.ProductCode__c);
                                }   
                                else if(pickedQuant==0)
                                    productQty.Reserved_Qty__c -=productQuantity.get(productQty.ProductCode__c);
                                if(Orderstatus == 'Order Confirmed' && Nopickpack !=true && pickedQuant!=0)
                                    productQty.Picked_Quantity__c -=productQuantity.get(productQty.ProductCode__c);
                                if(Orderstatus == 'Packaged' && Nopickpack !=true)
                                    productQty.Packaged_Quantity__c -=productQuantity.get(productQty.ProductCode__c);
                            }
                                update productInventory; 
                        }
                        

                        
                        //code to handle credit user detail once inventory reduce
                        if(orderData.Customer_Type__c=='Credit Customer' && CreditAmount >0)
                        {
                            Dimension_Tag__c DT =[select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: orderData.AccountId__c limit 1];
                            DT.Ordered_Amount__c -=CreditAmount;
                            update DT;
                        }
                        
                    }
                   
                    
                    //update sigma order status
                    orderData.Orders_Status__c ='Canceled';
                    update orderData;
                    
                    //handle invoice status after payment 13-03-2020
                    if(orderData.Order_Created_Via__c == 'POS')
                    {
                        Invoice__c invoice = [Select id,name,Invoice_Status__c from Invoice__c where SO__c =:orderData.id];
                        if(orderData.Orders_Status__c == 'Canceled')
                        {
                            invoice.Invoice_Status__c='Cancelled';
                        }
                        if(invoice !=null)
                        {
                            update invoice;
                        }
                    }
                    
                }
                //ends here
                //code for inventory status is allocated 
                else
                {
                    List<Lot_Product__c> lotproductlist = new List<Lot_Product__c>();
                    List<Inventory_Location_Product__c> ilplist = new List<Inventory_Location_Product__c>();
                    List<Inventory_Location_Product_Line_Item__c>liplilist = new List<Inventory_Location_Product_Line_Item__c>();
                    List<Id>ProductID=new List<Id>();
                    List<Id>LocationID=new List<Id>();
                    List<Id>BinId=new List<Id>();
                    set<Id>Productserialnumber=new set<Id>();
                    Map<Id,Boolean> isdefaultloc = new Map<id,Boolean>();
                    Map<Id,decimal>Unitprice = new Map<Id,decimal>();
                    Map<id,decimal> ReservedQuant=new Map<id,decimal>();
                    Map<id,decimal> BinQunt=new Map<id,decimal>();
                    Map<Id,decimal>totalquant = new Map<Id,decimal>(); 
                    productIds = new List<String>();
                    Map<Id,Id>LotId = new Map<Id,Id>();
                    Map<Id,String>Producttype = New Map<Id,String>();
                    List<OrderItem> standorderProducts;
                    List<Product_Order_Price_Book__c> orderProducts;
                    if(Orderusageoptions.Standard_object__c == true)
                    {
                        standorder = [SELECT id,AccountId,Quantity__c,Tax_Amount__c, Order_Created_Via__c, Net_Quantity__c,Net_Amount__c,Orders_Status__c,No_Picking_Package_Shipment_Required__c,Customer_Type__c FROM Order WHERE id=:orderId];
                        Nopickpack = standorder.No_Picking_Package_Shipment_Required__c;
                        List<OrderItem> orderStatusUpdate = new List<OrderItem>();
                        
                        standorderProducts = [SELECT id,PriceBookEntry.Product2.Id,Quantity,Net_Quantity__c,IsInventoryUpdated__c,Order_Status__c,Is_Credit_Updated__c,TotalPrice__c,(Select id,Name,ILPLI__c,Quantity__c,ILPLI__r.Available_Quantity__c,ILPLI__r.Reserved_Quantity__c,Picked_Quantity__c,ILPLI__r.Bin__c,ILPLI__r.Product__c,ILPLI__r.Lot__c from Inventory_Allocations__r ) FROM OrderItem WHERE OrderId=:orderId AND Order_Status__c != 'Canceled'];
                        productIds = new List<String>();
                        for(OrderItem productsData:standorderProducts)
                        {
                            for(Inventory_Allocation__c Allocateproduct: productsData.Inventory_Allocations__r )
                            {
                                if(ReservedQuant.containsKey(Allocateproduct.ILPLI__c))
                                {
                                    decimal totalqyt = ReservedQuant.get(Allocateproduct.ILPLI__c);
                                    ReservedQuant.put(Allocateproduct.ILPLI__c,totalqyt+Allocateproduct.Quantity__c);
                                }
                                else
                                {
                                    ReservedQuant.put(Allocateproduct.ILPLI__c,Allocateproduct.Quantity__c);
                                }
                                if(BinQunt.containsKey(Allocateproduct.ILPLI__r.Bin__c))
                                {
                                    decimal qty = BinQunt.get(Allocateproduct.ILPLI__r.Bin__c);
                                    BinQunt.put(Allocateproduct.ILPLI__r.Bin__c,qty+Allocateproduct.Quantity__c);
                                }
                                else
                                {
                                    BinQunt.put(Allocateproduct.ILPLI__r.Bin__c,Allocateproduct.Quantity__c);
                                }
                                LotId.put(Allocateproduct.ILPLI__r.Product__c,Allocateproduct.ILPLI__r.Lot__c); 
                                
                            } 
                            if(productsData.Is_Credit_Updated__c)
                            CreditAmount += productsData.TotalPrice__c;
                            Orderstatus = productsData.Order_Status__c;
                            inventoryallocated = productsData.IsInventoryUpdated__c;
                            OrderItem orderUpdate = new OrderItem();
                            productIds.add(productsData.PriceBookEntry.Product2Id);
                            if(productsData.IsInventoryUpdated__c)
                            {
                                if(productQuantity.containsKey(productsData.PriceBookEntry.Product2Id))
                                {
                                    Integer netqty= productQuantity.get(productsData.PriceBookEntry.Product2Id);
                                    productQuantity.put(productsData.PriceBookEntry.Product2Id,Integer.valueOf(productsData.Quantity)+netqty);
                                }
                                else
                                {
                                    productQuantity.put(productsData.PriceBookEntry.Product2Id,Integer.valueOf(productsData.Quantity)); 
                                }
                            }
                            
                            orderUpdate.Id = productsData.id;
                            orderUpdate.Net_Quantity__c = 0;
                            orderUpdate.Quantity = orderUpdate.Net_Quantity__c;
                            orderUpdate.Remaining_Qty_To_Package__c=0;
                            orderUpdate.Order_Status__c = 'Canceled';
                            if(orderUpdate.Packaged_Quantity__c==null)
                            orderUpdate.Packaged_Quantity__c = 0;
                            orderStatusUpdate.add(orderUpdate);
                        }
                        if(orderStatusUpdate.size()>0)
                        update orderStatusUpdate;
                        //system.debug('updateILPLI@@'+updateILPLI);
                        
                    }
                    else
                    {
                        orderData = [SELECT id, name,AccountId__c,Quantity__c,Tax_Amount__c,No_Picking_Package_Shipment_Required__c,Order_Created_Via__c, Net_Quantity__c, Orders_Status__c,TotalAmount__c,Customer_Type__c FROM Sigma_Order__c WHERE id=:orderId];
                        Nopickpack=orderData.No_Picking_Package_Shipment_Required__c;
                        List<Product_Order_Price_Book__c> orderStatusUpdate = new List<Product_Order_Price_Book__c>();
                        
                        //updating ILPLI
                        orderProducts = [SELECT id,name,Product__c,Product__r.Attribute_Type__c,IsInventoryUpdated__c,tax_amount__c,Quantity__c,Net_Quantity__c,Packaged_Quantity__c,Remaining_Qty_To_Package__c,Is_Credit_Updated__c,Total_Price__c,(Select id,Name,ILPLI__c,Quantity__c,ILPLI__r.Available_Quantity__c,ILPLI__r.Reserved_Quantity__c,ILPLI__r.Bin__c,ILPLI__r.Lot__c,ILPLI__r.Product__c,Picked_Quantity__c from Inventory_Allocations1__r ) FROM Product_Order_Price_Book__c WHERE Sigma_Order__c=:orderId AND Order_Status__c != 'Canceled'];
                        system.debug('orderProducts:::'+orderProducts);               
                        for(Product_Order_Price_Book__c productsData:orderProducts)
                        {
                            Producttype.put(productsData.Product__c,productsData.Product__r.Attribute_Type__c);
                            for(Inventory_Allocation__c Allocateproduct: productsData.Inventory_Allocations1__r )
                            {
                                if(ReservedQuant.containsKey(Allocateproduct.ILPLI__c))
                                {
                                    decimal totalqyt = ReservedQuant.get(Allocateproduct.ILPLI__c);
                                    ReservedQuant.put(Allocateproduct.ILPLI__c,totalqyt+Allocateproduct.Quantity__c);
                                }
                                else
                                {
                                    ReservedQuant.put(Allocateproduct.ILPLI__c,Allocateproduct.Quantity__c);
                                }
                                
                                if(Allocateproduct.Picked_Quantity__c==null)
                                    Allocateproduct.Picked_Quantity__c=0;
                                pickedQuant+=Allocateproduct.Picked_Quantity__c;
                                if(BinQunt.containsKey(Allocateproduct.ILPLI__r.Bin__c))
                                {
                                    decimal qty = BinQunt.get(Allocateproduct.ILPLI__r.Bin__c);
                                    BinQunt.put(Allocateproduct.ILPLI__r.Bin__c,qty+Allocateproduct.Quantity__c);
                                }
                                else
                                {
                                    BinQunt.put(Allocateproduct.ILPLI__r.Bin__c,Allocateproduct.Quantity__c);
                                }
                                
                                LotId.put(Allocateproduct.ILPLI__r.Product__c,Allocateproduct.ILPLI__r.Lot__c);
                            }
                            if(productsData.Is_Credit_Updated__c)
                            CreditAmount += productsData.Total_Price__c;                           
                            inventoryallocated = productsData.IsInventoryUpdated__c;
                            Product_Order_Price_Book__c orderUpdate = new Product_Order_Price_Book__c();
                            productIds.add(productsData.Product__c);
                           // productQuantity.put(productsData.Product__c,Integer.valueOf(productsData.Net_Quantity__c));
                            if(productsData.IsInventoryUpdated__c)
                            {
                                if(productQuantity.containsKey(productsData.Product__c))
                                {
                                    Integer netqty = productQuantity.get(productsData.Product__c);
                                        
                                        productQuantity.put(productsData.Product__c,Integer.valueOf(productsData.Net_Quantity__c)+netqty);
                                }
                                else
                                {
                                  productQuantity.put(productsData.Product__c,Integer.valueOf(productsData.Net_Quantity__c)); 
                                }
                            }
                            //add value to map 
                            
                            //system.debug('mapStockfullfill@@@'+Stockfullfill);
                            orderUpdate.Id = productsData.id;
                           // orderUpdate.Net_Quantity__c = 0;
                           // orderUpdate.Quantity__c=0;
                            orderUpdate.Remaining_Qty_To_Package__c = 0;
                            orderUpdate.Order_Status__c = 'Canceled';
                            if(orderUpdate.Packaged_Quantity__c==null)
                                orderUpdate.Packaged_Quantity__c = 0;
                            orderStatusUpdate.add(orderUpdate);
                            
                        }
                        update orderStatusUpdate;
                    }
                    
                    
                    List<Inventory_Location_Product_Line_Item__c>updateILPLI=new List<Inventory_Location_Product_Line_Item__c>();
                    updateILPLI=[select id,name,Bin__c,Unit_Price__c,Inventory_Location_Product__c,Reserved_Quantity__c,Adjusted_Quantity1__c,Product__c,Inventory_Location__c,Inventory_Location__r.Location__c,Product_Serial_Number__c,Delivered_Quantity__c from Inventory_Location_Product_Line_Item__c where id=:ReservedQuant.keySet() ORDER BY Product_Expiry_Date__c ASC NULLS LAST,Product_Received_date__c ASC NULLS LAST];
                    Map<id,decimal> ilpmap=new Map<id,decimal>();
                    List<string>serialcode = new List<string>(); 
                    for(Inventory_Location_Product_Line_Item__c ilpli:updateILPLI)
                    {
                        
                            Unitprice.put(ilpli.Product__c,ilpli.Unit_Price__c);
                            if(ilpli.Product_Serial_Number__c!=null)
                            {
                              Productserialnumber.add(ilpli.Product_Serial_Number__c);
                            }
                            
                            if(ilpli.Inventory_Location__c == Inventoryloc )
                            {
                                
                                isdefaultloc.put(ilpli.Product__c,true);
                                system.debug('isdefaultloc@@@'+isdefaultloc);
                                if(ilpli.Product__c!=null)
                                {
                                    ProductID.add(ilpli.Product__c);
                                }
                                if(ilpli.Inventory_Location__c!=null)
                                {
                                    LocationID.add(ilpli.Inventory_Location__c);
                                }
                                if(ilpli.Bin__c!=null)
                                {
                                   BinId.add(ilpli.Bin__c); 
                                } 
                                if(ReservedQuant.containsKey(ilpli.id))
                                {
                                    
                                    if(ilpli.Delivered_Quantity__c!=0 && ilpli.Delivered_Quantity__c!=NULL)
                                        ilpli.Delivered_Quantity__c-=ReservedQuant.get(ilpli.id);
                                    if(ilpmap.containsKey(ilpli.Inventory_Location_Product__c))
                                    {
                                        decimal qty= ilpmap.get(ilpli.Inventory_Location_Product__c);
                                        
                                        ilpmap.put(ilpli.Inventory_Location_Product__c,qty+ReservedQuant.get(ilpli.id));
                                    }
                                    else
                                    {
                                        ilpmap.put(ilpli.Inventory_Location_Product__c,ReservedQuant.get(ilpli.id));
                                    }
                                    
                                }
                            }
                            else
                            {
                                isdefaultloc.put(ilpli.Product__c,false);
                                system.debug('isdefaultlocafter@@'+isdefaultloc);
                            }
                        
                        
                    }
                    
                    update updateILPLI;
                    
                    system.debug('updateILPLI@@'+updateILPLI);
                    
                    List<Inventory_Location_Product__c> ILPSLIST= [select id,name,Deliver_Quantity__c,Products__c,Reserved_Quantity__c,Inventory_Location__c,Inventory_Location__r.Location__c from Inventory_Location_Product__c where id=:ilpmap.keySet()];
                    for(Inventory_Location_Product__c ilp:ILPSLIST)
                    {
                        if(ilp.Inventory_Location__c == Inventoryloc )
                        { 
                    
                            system.debug('match2');
                            if(ilpmap.containsKey(ilp.id))
                            {
                                ilp.Deliver_Quantity__c-=ilpmap.get(ilp.id);
                            }
                        }
                        
                    }
                    update ILPSLIST;
                    system.debug('ILPSLIST@@'+ILPSLIST);
                    //updating LOT Product2
                    List<Lot_Product__c>Lotproduct=[Select id,Name,Bin__c,Location__c,Product__c,Quantity__c from Lot_Product__c where Product__c =:ProductID and Location__c=:LocationID and Bin__c=:BinQunt.keySet()];
                    system.debug('Lotproduct@@'+Lotproduct);
                    if(Lotproduct.size()>0)
                    {
                        for(Lot_Product__c LP:Lotproduct)
                        {
                            if(LP.Location__c == Inventoryloc )
                            {
                                system.debug('match3');
                                if(LP.Product__c!=null && LP.Bin__c!=null && BinQunt.containsKey(LP.Bin__c))
                                 LP.Quantity__c+=BinQunt.get(LP.Bin__c);
                            }
                        }
                        update Lotproduct;
                        system.debug('Lotproduct@'+Lotproduct);
                    }
                   
                   
                    if(Productserialnumber.size()>0)
                    {
                        List<Product_Serial_Number__c> serialststusupdate=new List<Product_Serial_Number__c>();
                        serialststusupdate=[select id,name,Status__c,Serial_Number__c,Inventory_Location__c from Product_Serial_Number__c where id=:Productserialnumber];
                        system.debug('serialststusupdate@@@'+serialststusupdate);
                        for(Product_Serial_Number__c serialstatus:serialststusupdate)
                        {
                            if(serialstatus.Inventory_Location__c == Inventoryloc)
                            {
                                serialstatus.Status__c='Available';
                            }
                                
                            //serialcode.add(serialstatus.Serial_Number__c);
                        }
                        update serialststusupdate;
                       
                    }
                    
                    
                    //code to handle inventory revert back if defualt location not there
                    List<Inventory_Location_Product__c> ILPLISTS= [select id,name,Received_Quantity__c,Delivered_Quantity__c,Products__c,Reserved_Quantity__c,Inventory_Location__c,Inventory_Location__r.Location__c,Inventory__c   from Inventory_Location_Product__c where Products__c=:productQuantity.keySet()];
                    system.debug('ILPLISTS@@'+ILPLISTS);
                    Id Proinventory;
                    Map<Id,Inventory_Location_Product__c>ILPExist = new Map<Id,Inventory_Location_Product__c>();
                    for(Inventory_Location_Product__c ILP :ILPLISTS)
                    {
                        Proinventory = ILP.Inventory__c;
                        if(ILP.Inventory_Location__c==Inventoryloc)
                        {
                            system.debug('insideilps');
                            ILPExist.put(ILP.Products__c,ILP);
                        }
                            
                    }
                    system.debug('ILPExist@@@'+ILPExist);
                    //code to handle Lot 
                    List<Lot_Product__c>Lotproductlists=[Select id,Name,Lot__c,Bin__c,Location__c,Product__c,Quantity__c from Lot_Product__c where Product__c =:productQuantity.keySet()];
                    system.debug('Lotproductlists@@'+Lotproductlists);
                    Map<Id,Lot_Product__c>LotExist = new Map<Id,Lot_Product__c>();
                    for(Lot_Product__c LP :Lotproductlists)
                    {
                        if(LP.Location__c == Inventoryloc && LP.Bin__c == Defaultbin)
                        {
                            system.debug('inlot@@');
                            LotExist.put(LP.Product__c,LP);
                        }
                    }
                    system.debug('LotExist@@@'+LotExist);
                    
                    if(Orderusageoptions.Standard_object__c == true)
                    {
                        for(OrderItem orderline:standorderProducts)
                        {
                            if(totalquant.containsKey(orderline.PriceBookEntry.Product2Id))
                            {
                                decimal qunt = totalquant.get(orderline.PriceBookEntry.Product2Id);
                                totalquant.put(orderline.PriceBookEntry.Product2Id,qunt+orderline.Quantity);
                            }
                            else
                            {
                                totalquant.put(orderline.PriceBookEntry.Product2Id,orderline.Quantity);
                            }
                            if(isdefaultloc.containsKey(orderline.PriceBookEntry.Product2Id)&& isdefaultloc.get(orderline.PriceBookEntry.Product2Id)==false)
                            {
                                system.debug('in1stif');
                                
                                if(LotId.size()>0)
                                {
                                    if(LotExist.containsKey(orderline.PriceBookEntry.Product2Id))
                                    {
                                        Lot_Product__c Newlp = LotExist.get(orderline.PriceBookEntry.Product2Id);
                                        Newlp.Product__c = orderline.PriceBookEntry.Product2Id;
                                        Newlp.Quantity__c += productQuantity.get(Newlp.Product__c);
                                        Newlp.Lot__c = LotId.get(Newlp.Product__c);                                     
                                        lotproductlist.add(Newlp);
                                    }
                                    else
                                    {
                                        system.debug('in2stifffff');
                                        Lot_Product__c Newlp = new Lot_Product__c();
                                        Newlp.Location__c = Inventoryloc;
                                        Newlp.Product__c = orderline.PriceBookEntry.Product2Id;
                                        Newlp.Lot__c = LotId.get(Newlp.Product__c);
                                        Newlp.Quantity__c = productQuantity.get(Newlp.Product__c);
                                        Newlp.Bin__c = Defaultbin;
                                        lotproductlist.add(Newlp);
                                    }
                                    
                                    
                                }
                            
                                if(ILPExist.containsKey(orderline.PriceBookEntry.Product2Id))
                                {
                                    Inventory_Location_Product__c ilpnew = ILPExist.get(orderline.PriceBookEntry.Product2Id);
                                    ilpnew.Inventory_Location__c = Inventoryloc;
                                    ilpnew.Products__c = orderline.PriceBookEntry.Product2Id;
                                    ilpnew.Received_Quantity__c += productQuantity.get(ilpnew.Products__c);
                                    ilplist.add(ilpnew);
                                }
                                else
                                {
                                    Inventory_Location_Product__c ilpnew = new Inventory_Location_Product__c();
                                    ilpnew.Inventory_Location__c = Inventoryloc;
                                    ilpnew.Products__c = orderline.PriceBookEntry.Product2Id;
                                    ilpnew.Received_Quantity__c = productQuantity.get(ilpnew.Products__c);
                                    ilpnew.Inventory__c = Proinventory;
                                    ilplist.add(ilpnew);
                                }
                                
                            }
                        }
                    }
                    else
                    {
                        for(Product_Order_Price_Book__c orderline:orderProducts)
                        {
                            
                            if(totalquant.containsKey(orderline.Product__c))
                            {
                                decimal qunt = totalquant.get(orderline.Product__c);
                                totalquant.put(orderline.Product__c,qunt+orderline.Net_Quantity__c);
                            }
                            else
                            {
                                totalquant.put(orderline.Product__c,orderline.Net_Quantity__c);
                            }
                            if(isdefaultloc.containsKey(orderline.Product__c)&& isdefaultloc.get(orderline.Product__c)==false)
                            {
                                system.debug('in1stif');
                                
                                if(LotId.size()>0)
                                {
                                    system.debug('in2stifffff');
                                    if(LotExist.containsKey(orderline.Product__c))
                                    {
                                        Lot_Product__c Newlp = LotExist.get(orderline.Product__c);
                                        Newlp.Product__c = orderline.Product__c;
                                        Newlp.Quantity__c += productQuantity.get(Newlp.Product__c);
                                        Newlp.Lot__c = LotId.get(Newlp.Product__c);                                     
                                        lotproductlist.add(Newlp);
                                    }
                                    else
                                    {
                                        system.debug('in2stifffff');
                                        Lot_Product__c Newlp = new Lot_Product__c();
                                        Newlp.Location__c = Inventoryloc;
                                        Newlp.Product__c = orderline.Product__c;
                                        Newlp.Lot__c = LotId.get(Newlp.Product__c);
                                        Newlp.Quantity__c = productQuantity.get(Newlp.Product__c);
                                        Newlp.Bin__c = Defaultbin;
                                        lotproductlist.add(Newlp);
                                    }
                                   
                                   
                                    
                                }
                                
                                if(ILPExist.containsKey(orderline.Product__c))
                                {
                                    system.debug('ILPExist!!!!'+ILPExist);
                                    Inventory_Location_Product__c ilpnew = ILPExist.get(orderline.Product__c);
                                    ilpnew.Inventory_Location__c = Inventoryloc;
                                    ilpnew.Products__c = orderline.Product__c;
                                    ilpnew.Received_Quantity__c += productQuantity.get(ilpnew.Products__c);
                                    ilplist.add(ilpnew);
                                    system.debug('ilplist@@'+ilplist);
                                }
                                else
                                {
                                    Inventory_Location_Product__c ilpnew = new Inventory_Location_Product__c();
                                    ilpnew.Inventory_Location__c = Inventoryloc;
                                    ilpnew.Products__c = orderline.Product__c;
                                    ilpnew.Received_Quantity__c = productQuantity.get(ilpnew.Products__c);
                                    ilpnew.Inventory__c = Proinventory;
                                    //ilpnew.Products__r.Attribute_Type__c = orderline.Attribute_Type__c;
                                    ilplist.add(ilpnew);
                                }
                                
                                
                            }
                        }
                    }
                    
                    
                    //update LOT
                    Map<Id,Id> LotIds = new map<Id,Id>();
                    
                    if(lotproductlist.size()>0)
                    {
                        Upsert lotproductlist;
                        system.debug('lotproductlist@@'+lotproductlist);
                        for(Lot_Product__c LotPro :lotproductlist)
                        {
                            LotIds.put(LotPro.Product__c,LotPro.Lot__c);    
                        }
                    }
                    
                    //Update ILP
                    List<Product_Serial_Number__c> NewPSN=new List<Product_Serial_Number__c>();
                    system.debug('Producttype@@'+Producttype);
                    if(ilplist.size()>0)
                    {
                        Upsert ilplist;
                        for(Inventory_Location_Product__c ILP :ilplist)
                        {
                            if(ILP.Inventory_Location__c == Inventoryloc)
                            {
                                    if(Producttype.containsKey(ILP.Products__c) && Producttype.get(ILP.Products__c) == 'BULK')
                                    {
                                        system.debug('inifbulk');
                                        Inventory_Location_Product_Line_Item__c newilpli= new Inventory_Location_Product_Line_Item__c();
                                        newilpli.Inventory_Location__c = Inventoryloc;
                                        newilpli.Product__c = ILP.Products__c;
                                        newilpli.Unit_Price__c = Unitprice.get(newilpli.Product__c);
                                        newilpli.Received_Quantity__c = productQuantity.get(newilpli.Product__c);
                                        newilpli.Bin__c=Defaultbin;
                                        if(lotproductlist.size()>0)
                                        newilpli.Lot__c = LotIds.get(newilpli.Product__c);
                                        newilpli.Inventory_Location_Product__c = ILP.id;
                                        liplilist.add(newilpli);
                                    }
                                    else
                                    {
                                        
                                        
                                        for(Integer i=0;i<totalquant.get(ILP.Products__c);i++)
                                        {
                                            String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
                                            String randStr = '';
                                            while (randStr.length() < 4) {
                                            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
                                            randStr += chars.substring(idx, idx+1);
                                            }
                                            Product_Serial_Number__c PSN =new Product_Serial_Number__c();
                                            PSN.Status__c='Available';
                                            PSN.Serial_Number__c = 'M'+randStr+i;
                                            PSN.Inventory_Location_Product__c = ILP.id;
                                            PSN.Product_Code__c = ILP.Products__c;
                                            if(lotproductlist.size()>0)
                                            PSN.Lot__c = LotIds.get(PSN.Product_Code__c);
                                            PSN.Inventory_Location__c = Inventoryloc;
                                            PSN.Bin__c=Defaultbin;
                                            PSN.Quantity__c=1;
                                            NewPSN.add(PSN);
                                        }
                                    }
                            }
                            
                        }
                    }
                        
                    
                    if(NewPSN.size()>0)
                    {
                        insert NewPSN;
                        for(Product_Serial_Number__c PSNvalue:NewPSN)
                        {
                            Inventory_Location_Product_Line_Item__c newilpli= new Inventory_Location_Product_Line_Item__c();
                            newilpli.Inventory_Location__c = Inventoryloc;
                            newilpli.Product__c = PSNvalue.Product_Code__c;
                            newilpli.Unit_Price__c = Unitprice.get(newilpli.Product__c);
                            newilpli.Received_Quantity__c =1;
                            newilpli.Bin__c=Defaultbin;
                            if(lotproductlist.size()>0)
                            newilpli.Lot__c = LotIds.get(newilpli.Product__c);
                            newilpli.Inventory_Location_Product__c = PSNvalue.Inventory_Location_Product__c;
                            newilpli.Product_Serial_Number__c=PSNvalue.id;  
                            liplilist.add(newilpli);
                        }
                    }
                    if(liplilist.size()>0)
                    {
                        insert liplilist;
                    }
                    
                    
                    
                    
                    //code to update PI
                    if(productIds.size()>0 && productQuantity.size()>0)
                        {
                            List<Inventory__c> productInventory = [SELECT id,name,ProductCode__c,Delivered_Qty__c,Available_Qty__c from Inventory__c WHERE ProductCode__c IN :productIds];
                            for(Inventory__c productQty:productInventory)
                            {
                                productQty.Available_Qty__c+=productQuantity.get(productQty.ProductCode__c);
                                productQty.Delivered_Qty__c -=productQuantity.get(productQty.ProductCode__c);
                            }
                                update productInventory; 
                        }
                        //code to handle credit user detail once inventory reduce
                       //update sigma order status
                    if(orderData !=null)
                    {
                        orderData.Orders_Status__c ='Canceled';
                        update orderData;
                        if(orderData.Customer_Type__c=='Credit Customer' && Orderusageoptions.Sigma_order__c==true && CreditAmount>0 ) 
                        {
                            Dimension_Tag__c DT =[select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: orderData.AccountId__c limit 1];
                            DT.Ordered_Amount__c -=CreditAmount;
                            update DT;
                        }
                    }
                    if(standorder !=null)
                    {
                        standorder.Orders_Status__c ='Canceled';
                        update standorder;
                    
                        if(standorder.Customer_Type__c=='Credit Customer' && Orderusageoptions.Standard_object__c == true && CreditAmount>0)
                        {
                            Dimension_Tag__c DT =[select id,Base_Credit_Limit__c,Ordered_Amount__c,Paid_Amount__c from Dimension_Tag__c where Account__c =: standorder.AccountId limit 1];
                            DT.Ordered_Amount__c -=CreditAmount;
                            update DT;
                        }
                    }
                    
                }
                
              
                
            }
            
                catch(Exception ex){
                createErrorLog.insertError('Payment',ex.getMessage(),'Method -managesigmaOrderOnCancel ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
                }
        //}   
    } 
    
}