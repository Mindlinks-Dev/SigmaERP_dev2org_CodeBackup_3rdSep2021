public with sharing class LookupObjectCntrstandard
{
    
    public class Result
    {
        @AuraEnabled public String SObjectLabel {get; set;}
        @AuraEnabled public Id SObjectId {get; set;}
        
        public Result(String sObjectLabel, Id sObjectId)
        {
            this.SObjectLabel = sObjectLabel;
            this.SObjectId = sObjectId;
        }
    }
    
    @AuraEnabled
    public static Product2 fetchProduct(Id prodId)
    {    
        Product2 prod;
         if(CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
        && CRUD_FLS_CheckUtility.checkObjCRUD('PricebookEntry')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'Id','Name','sigmaerpdev__Max_Discount__c','sigmaerpdev__SKU__c','sigmaerpdev__Product_Description__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('PricebookEntry',new set<String>{'id','UnitPrice','product2id','Pricebook2Id'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new set<String>{'id','Name','sigmaerpdev__priceBook_for_orders__c'})    
        )
        {
            Default_Parameters__c Dp = Default_Parameters__c.getInstance('Elift Merchant');
            string priceBook = Dp.priceBook_for_orders__c;
            prod = [Select Id,Name,Max_Discount__c,SKU__c,Product_Description__c, (SELECT id,UnitPrice FROM PricebookEntries WHERE product2id =: prodId AND Pricebook2Id =: priceBook) from Product2 WHERE id =: prodId];
        }
        return prod;
    } 
    
    
    @AuraEnabled
    public static Inventory__c fetchInventory(Id prodId)
    {    
        
        Inventory__c inv;
         if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
         && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new Set<String>{'Id', 'sigmaerpdev__Available_Qty__c','sigmaerpdev__ProductCode__r.Id'}))
       
        {
            inv = [Select Available_Qty__c from Inventory__c where ProductCode__r.Id =:prodId ];
        }
        
        return inv;
    } 

    @AuraEnabled
    public static Default_Parameters__c getCurrency()
    {
         Default_Parameters__c options;
         if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')
         && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new Set<String>{'Id','sigmaerpdev__Inventory_Status__c','sigmaerpdev__Package_ID__c','sigmaerpdev__Parent_Id__c','sigmaerpdev__Shipment_ID__c','sigmaerpdev__StockReceiving_ID__c','sigmaerpdev__Currency__c'}))
         {
            options = [select Id,Inventory_Status__c,Package_ID__c,Parent_Id__c,Shipment_ID__c,StockReceiving_ID__c,Currency__c from Default_Parameters__c limit 1];
        }
        return options;
             
    }
    @AuraEnabled
    public static Id orderSave(List<String> productList,Id accId,String billingPerson,Double allPdtsAmount,Date orderdelivarydate)
    {     
         Id orderId;
        String OrderIDD;
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('Order')
        && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('pricebookentry')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')
        && CRUD_FLS_CheckUtility.checkFLS('Order',new Set<String>{'AccountId','EffectiveDate','Status','sigmaerpdev__Orders_Status__c','sigmaerpdev__Order_Type__c','sigmaerpdev__Order_Created_Via__c','Pricebook2Id','sigmaerpdev__Discount__c','sigmaerpdev__Discount_Amount__c','sigmaerpdev__Delivary_Date__c','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Quantity__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__TotalAmount__c','sigmaerpdev__Tax__c','sigmaerpdev__Net_Amount__c','sigmaerpdev__Total_product_Price__c'})
        && CRUD_FLS_CheckUtility.checkFLS('OrderItem',new Set<String>{'sigmaerpdev__Order_Status__c','sigmaerpdev__Unit_Price__c','sigmaerpdev__Inventory_Status__c','Quantity','sigmaerpdev__Net_Quantity__c','UnitPrice','sigmaerpdev__Discount__c','sigmaerpdev__Delivery_Date__c','sigmaerpdev__Tax_Amount__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new Set<String>{'sigmaerpdev__Purchased_Qty__c','sigmaerpdev__Total_Available_Qty__c','sigmaerpdev__Delivered_Qty__c','sigmaerpdev__Available_Qty__c','sigmaerpdev__Reserved_Qty__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Inventory_Location__c'})
        && Schema.sObjectType.Inventory__c.fields.Id.isAccessible()
        && Schema.sObjectType.Inventory_Location_Product__c.fields.Id.isAccessible()
        && CRUD_FLS_CheckUtility.checkFLScreateAccess('OrderItem',new Set<String>{'OrderId'})
        && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new Set<String>{'Product2Id'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new Set<String>{'Id','sigmaerpdev__Inventory_Status__c','sigmaerpdev__Default_Location__c','sigmaerpdev__Package_ID__c','sigmaerpdev__Parent_Id__c','sigmaerpdev__Shipment_ID__c','sigmaerpdev__StockReceiving_ID__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('pricebookentry',new set<String>{'id','Product2id','Pricebook2Id'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new set<String>{'Id','sigmaerpdev__Available_Qty__c','sigmaerpdev__Total_Available_Qty__c','sigmaerpdev__Delivered_Qty__c','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__Purchased_Qty__c','sigmaerpdev__ProductCode__r.Id'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c', new Set<String>{'Id','Name','sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Inventory_Location__c','sigmaerpdev__Received_Quantity__c','sigmaerpdev__Products__r.Id'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new set<String>{'id', 'name','sigmaerpdev__Reserved_Quantity__c','sigmaerpdev__Received_Quantity1__c','sigmaerpdev__Received_Quantity__c','sigmaerpdev__Product__c','sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__Inventory_Location__c','sigmaerpdev__Adjusted_Quantity__c','sigmaerpdev__Available_Quantity__c','sigmaerpdev__AvailableAdjustedQty__c','sigmaerpdev__Inventory_Location_Product__r.id'})
        ){
       
        String inventorystatus;
        String invlocation;
        Inventory_Location_Product__c ILP;
        Inventory_Location_Product_Line_Item__c ILPLI;
        Default_Parameters__c options;
        options = [select Id,Inventory_Status__c,Default_Location__c,Package_ID__c,Parent_Id__c,Shipment_ID__c,StockReceiving_ID__c from Default_Parameters__c];
        inventorystatus = options.Inventory_Status__c; 
        invlocation  = options.Default_Location__c;
        Default_Parameters__c Dp = Default_Parameters__c.getInstance('Elift Merchant');
        string priceBook = Dp.priceBook_for_orders__c;
        Map<Id,List<OrderLineLocation__c>> OrderLineItemLocations = new Map<Id,List<OrderLineLocation__c>>();
        List<OrderLineLocation__c> OrderLineLocList ;
        Map<Id,Product_Order_Price_Book__c> retainOrderLineData = new Map<Id,Product_Order_Price_Book__c>();
           
        Boolean temp = false;
        Double TaxOnBillAmount = 0; 
        Integer numOfOrderLines = 0;
        Integer numofProds = 0;
        String delivarydate;
        Integer netQuantity = 0;
        Double ProdDiscountsd = 0.0;
        Double ProdDiscountd = 0.0;
        Double TotalProdamount = 0.0;
        Double TotalprAmount ;
        Id prodid;
        
        If(OrderIDD InstanceOf Id)
        {
            temp = true;
        }
        
        Order editingOrder;
        if(temp)
        {                  
            
        }
        else
        {
           
            Order productOrder = new Order();
            productOrder.AccountId = accId;
            productOrder.Billing_Person__c = billingPerson;
            
            // hard coded for following fields
            productOrder.Status = 'Draft';
            productOrder.Orders_Status__c = 'Pending';
            productOrder.Order_Type__c = 'OFFLINE';
            productOrder.Order_Created_Via__c = 'POS';
            numOfOrderLines = productList.size();
            for(String a: productList)
            {
                String str =a;
                List<String> jsonList = new List<String>();
                jsonList = str.split('},');
                for (Integer i=0 ; i<jsonList.size() ; i++ )
                {
                    
                    String s1 = '';
                    if(i != jsonList.size()-1)
                    {
                        s1 = jsonList.get(i)+'}';
                    }
                    else
                    {    
                        s1 = jsonList.get(i);
                        
                    }
                    Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(s1);                                       
                    numofProds = numofProds + Integer.valueOf(root.get('quantity')); 

                        if(root.get('Discount') != null && root.get('Discount') != ''){
                        ProdDiscountd = ProdDiscountd + Double.valueOf(root.get('Discount'));
                        }
                        else{
                            ProdDiscountd =0;
                        }
                  TotalProdamount = TotalProdamount+ Double.valueOf(root.get('productAmount'));
                  TotalprAmount = TotalProdamount;
                  }                
            }
            ProdDiscountsd = ProdDiscountd;
            netQuantity = numofProds;
            productOrder.Discount__c = ProdDiscountsd;
            productOrder.Discount_Amount__c = ProdDiscountsd;
            productOrder.Net_Quantity__c= netQuantity;
            productOrder.Pricebook2Id=priceBook;
            productOrder.Quantity__c= netQuantity;
            if(orderdelivarydate!=null )
            {
                productOrder.Delivary_Date__c=orderdelivarydate;
                productOrder.EffectiveDate = orderdelivarydate;
            }
            
            List<Tax__c> taxObj = TaxCntr.getTax(accId);
            Double federalTax = Double.valueOf(taxObj.get(0).Tax_Amount__c);
            String fedTaxType = String.valueOf(taxObj.get(0).Type__c);
            Double stateTax = Double.valueOf(taxObj.get(1).Tax_Amount__c);
            String stateTaxType = String.valueOf(taxObj.get(1).Type__c);
            if(fedTaxType == 'Percentage'){
                TaxOnBillAmount = (allPdtsAmount * federalTax)/100;
            }else{
                TaxOnBillAmount = allPdtsAmount + federalTax;
            }               
            if(stateTaxType == 'Percentage'){
                TaxOnBillAmount = (TaxOnBillAmount + (allPdtsAmount * stateTax)/100);
            }else{
                TaxOnBillAmount = (TaxOnBillAmount + (allPdtsAmount + stateTax));
            }  
            productOrder.Tax_Amount__c = TaxOnBillAmount;
            productOrder.Tax__c = federalTax + stateTax;
            productOrder.Net_Amount__c=allPdtsAmount + TaxOnBillAmount;
            productOrder.TotalAmount__c = allPdtsAmount;
            productOrder.Total_product_Price__c= TotalprAmount;
            //ends here
            
            //**********************New code Added to Write shipping Address into an order on Nov-24 Starts here **************
            
                insert productOrder; 
             orderId = productOrder.Id;  
        } 
        
        List<OrderItem> productLines = new List<OrderItem>();
        OrderItem productLineObj;
        
        List<Inventory__c> inventoryLines = new List<Inventory__c>();
        Inventory__c inventoryObj;
        
        List<Inventory_Location_Product__c> ILPList = new List<Inventory_Location_Product__c>();
        List<Inventory_Location_Product_Line_Item__c> ILPLIList = new List<Inventory_Location_Product_Line_Item__c>();
        
        numOfOrderLines = productList.size();
        
        set<id> proid= new set<id>();
        
        for(String a: productList)
        {
            String str =a;// a.substring(1, a.length()-1);
            List<String> jsonList = new List<String>();
            jsonList = str.split('},');
            for (Integer i=0 ; i<jsonList.size() ; i++ )
            {
                String s1 = '';
                if(i != jsonList.size()-1)
                {
                    s1 = jsonList.get(i)+'}';
                    system.debug('s1>>>'+s1);
                }
                else
                {    
                    s1 = jsonList.get(i);
                    system.debug('s1>>>'+s1);
                }
                
                Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(s1);
                
                proid.add(string.valueof(root.get('Id')));
            }
        }
           
        map<Id,pricebookentry> pentry = new map<Id,pricebookentry>();
        
        for(pricebookentry pbe : [select id,Product2id from pricebookentry where product2id IN:proid AND Pricebook2Id =: priceBook ]){
            pentry.put(pbe.Product2id ,pbe);
        }       
        for(String a: productList)
        {
            productLineObj = new OrderItem();
            Inventory_Location_Product__c ILPrd = new Inventory_Location_Product__c();
            Inventory_Location_Product_Line_Item__c ILPLIPrd = new Inventory_Location_Product_Line_Item__c();
            inventoryObj = new Inventory__c();
            String str =a;// a.substring(1, a.length()-1);
            List<String> jsonList = new List<String>();
            jsonList = str.split('},');
            
            for (Integer i=0 ; i<jsonList.size() ; i++ )
            {
                String s1 = '';
                if(i != jsonList.size()-1)
                {
                    s1 = jsonList.get(i)+'}';
                }
                else
                {    
                    s1 = jsonList.get(i);
                }
                
                Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(s1);
                productLineObj.OrderId = orderId;
                productLineObj.Product2id = String.valueOf(root.get('Id'));
                productLineObj.Quantity = Integer.valueOf(root.get('quantity'));
                productLineObj.Net_Quantity__c= Integer.valueOf(root.get('quantity'));
                productLineObj.UnitPrice = Double.valueOf(root.get('productAmount'));
                productLineObj.Unit_Price__c = Double.valueOf(root.get('totalAmount')); 
                productLineObj.PricebookEntryId=pentry.get(productLineObj.Product2id ).id;
                delivarydate=String.valueOf(root.get('date'));
                
                if(root.get('Discount') != null && root.get('Discount') != ''){
                        productLineObj.Discount__c = Double.valueOf(root.get('Discount'));
                        }
                        else{
                            productLineObj.Discount__c = 0.0;
                        }
                
              if(delivarydate!='' && delivarydate!=null)
                {
                    productLineObj.Delivery_Date__c=Date.valueOf(delivarydate); 
                }
                //Chaged on 16 November to isolate order status and OrderLines status
                productLineObj.Order_Status__c = 'Pending';
                
               //added for tax calculation orderLines
                Double taxForPriceBookItems;
                Double totalAmountOL = Double.valueOf(root.get('totalAmount'));
                taxForPriceBookItems = (Double.valueOf(totalAmountOL) / Double.valueOf(allPdtsAmount)) * Double.valueOf(TaxOnBillAmount);
                productLineObj.tax_amount__c = taxForPriceBookItems;
                //ends here.
                
               inventoryObj = [Select Id,Available_Qty__c,Total_Available_Qty__c,Delivered_Qty__c,Reserved_Qty__c,Purchased_Qty__c from Inventory__c where ProductCode__r.Id=:productLineObj.Product2Id];
                
                if(inventorystatus !='Reserve')
                {
                    if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c', new Set<String>{'Id','Name','sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Inventory_Location__c','sigmaerpdev__Received_Quantity__c','sigmaerpdev__Products__r.Id'})) // Added by Raghavendra on 05-June
                    {   
                        ILP = [select id, name, Delivered_Quantity__c,Inventory_Location__c, Received_Quantity__c from Inventory_Location_Product__c where Products__r.Id = :productLineObj.Product2Id Limit 1];
                        
                    }   
                    ILPLI = [select id, name,Reserved_Quantity__c,Received_Quantity1__c,Received_Quantity__c,Product__c,Inventory_Location_Product__c,Inventory_Location__c,Adjusted_Quantity__c,Available_Quantity__c,AvailableAdjustedQty__c from Inventory_Location_Product_Line_Item__c where Inventory_Location_Product__r.id =: ILP.id Limit 1];
                    
                }
                if(inventorystatus =='Reserve')
                {   
                    productLineObj.Inventory_Status__c = 'Reserve';
                    inventoryObj.Reserved_Qty__c = inventoryObj.Reserved_Qty__c + productLineObj.Quantity;
                    inventoryObj.Available_Qty__c  = inventoryObj.Available_Qty__c - productLineObj.Quantity;
                   }
                else{
                    productLineObj.Inventory_Status__c = 'Allocated';    
                    inventoryObj.Available_Qty__c  = inventoryObj.Available_Qty__c - productLineObj.Quantity;
                    inventoryObj.Delivered_Qty__c  = inventoryObj.Delivered_Qty__c + productLineObj.Quantity;
                    ILPrd.Delivered_Quantity__c = ILP.Delivered_Quantity__c + productLineObj.Quantity;
                    ILPrd.Inventory_Location__c = invlocation;
                    ILPrd.Id = ILP.Id;
                    ILPList.add(ILPrd);
                    // new code  ILPLIPrd ILPLIList
                    ILPLIPrd.Reserved_Quantity__c =ILPLI.Reserved_Quantity__c + productLineObj.Quantity;
                    ILPLIPrd.Inventory_Location__c = invlocation;
                    ILPLIPrd.Id = ILPLI.Id;
                    ILPLIList.add(ILPLIPrd);
                }
                
                inventoryLines.add(inventoryObj);
                productLines.add(productLineObj);
                
            }
            upsert productLines;
            
        }
        //----------Till Here ----------------------------------------------------
        
        update inventoryLines;

        }
        return orderId;
        
        
    }
    //-------------------End Ord orderSave()--------------------------------------------------------
    
    
     @AuraEnabled
    public static List<Order> getInfoForSoOnHover(String stappOrderId){
        List<Order> retStr = new List<Order>();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('Order')
        && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
        && CRUD_FLS_CheckUtility.checkReadPermission('Order',new Set<String>{'id','sigmaerpdev__Date__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new Set<String>{'Product2.Name'}))
        {
        retStr = [select id,Date__c,(select Product2.Name from OrderItems) from Order where id = :stappOrderId];        
        }
        return retStr;
    }
    
}