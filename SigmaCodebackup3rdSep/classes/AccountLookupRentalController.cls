public with sharing class AccountLookupRentalController
{   
    /* used to fetchSavedOrders 
Input parameters :order id;
returns/output parameters  : Sigma_Order__c Object contains Product_Order_Price_Books__r */
    @AuraEnabled
    public static Sigma_Order__c fetchSavedOrders(String orderSFId)
    {      
        Sigma_Order__c orderList = new Sigma_Order__c();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'id','sigmaerpdev__AccountId__c','sigmaerpdev__AccountId__r.name','sigmaerpdev__StoreName__c','sigmaerpdev__Order_Number__c',
                         'sigmaerpdev__Status__c','sigmaerpdev__TotalAmount__c','sigmaerpdev__Discount__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__BillingPersonNew__r.Name'})
        &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Sigma_Order__c',new set<String>{'sigmaerpdev__AccountId__c'})){
        */
        if(checkAccessPermissionsOrderOne() == true)
        {                
            orderList = [select id,AccountId__c,AccountId__r.name,StoreName__c,Order_Number__c,
                         Status__c,TotalAmount__c,Discount__c,Orders_Status__c,BillingPersonNew__r.Name FROM Sigma_Order__c WHERE Id=:orderSFId];
            
        }
        //}
        return orderList;
    }
    
    @AuraEnabled
    public static List<Product_Order_Price_Book__c> fetchOrderLines(String orderSFId)
    {         
        List<Product_Order_Price_Book__c> orderLineList = new List<Product_Order_Price_Book__c>();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'id','sigmaerpdev__Customer__r.Id','sigmaerpdev__Sigma_Order__r.Id','sigmaerpdev__Quantity__c','sigmaerpdev__Product_Name__c','sigmaerpdev__Total_Amount__c',
                             'sigmaerpdev__Total_Price__c','sigmaerpdev__TotalProductPrice__c','sigmaerpdev__Product__r.Id'})
         ){*/
        if(checkAccessPermissionsProductOrderPriceBookOne() == true)
        {              
            orderLineList = [select id,Customer__r.Id,Sigma_Order__r.Id,Quantity__c,Product_Name__c,Total_Amount__c,
                             Total_Price__c,TotalProductPrice__c,Product__r.Id from Product_Order_Price_Book__c where Sigma_Order__r.Id = :orderSFId];
        } 
        //}        
        return orderLineList ; 
    }
    
    @AuraEnabled
    public static Default_Parameters__c getCurrency()
    {           
        Default_Parameters__c options;
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new set<String>{'Id','sigmaerpdev__Inventory_Status__c','sigmaerpdev__Package_ID__c','sigmaerpdev__Parent_Id__c','sigmaerpdev__Shipment_ID__c','sigmaerpdev__StockReceiving_ID__c','sigmaerpdev__Currency__c'})    
        ){*/
        if(FLScheckAccessPermissionsCustomSettings())
        {
            System.debug('Inside fls*****');
            options = [select Id,Inventory_Status__c,Package_ID__c,Parent_Id__c,Shipment_ID__c,StockReceiving_ID__c,Currency__c from Default_Parameters__c limit 1];
        } 
        //}       
        return options;              
    }
    
    
    @AuraEnabled
    public static List<String> getRentalStatus(){
        List<String> options = new List<String>();
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev__Rental_Status__c'})
        ){*/
        Schema.DescribeFieldResult fieldResult = Product_Order_Price_Book__c.Rental_Status__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        //}
        return options;
    }
    
    // Fetching picklist values of Rental status field 
    @AuraEnabled
    public static List<String> getBillingInterval(){
        List<String> options = new List<String>();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev__Billing_Interval__c'})
        ){*/
        Schema.DescribeFieldResult fieldResult = Product_Order_Price_Book__c.Billing_Interval__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        //}
        return options;
    }
    
    @AuraEnabled
    public static List<String> getpaymenttype(){
        List<String> options = new List<String>();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'sigmaerpdev__Payment_type__c'})
        ){*/
        Schema.DescribeFieldResult fieldResult = Sigma_Order__c.Payment_type__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        //}
        
        return options;
        
    }
    
    /**
* Inner class to wrap up an SObject Label and its Id
*/
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
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
        && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'Id','Name','sigmaerpdev__Product_Description__c','sigmaerpdev__Product_Price__c','sigmaerpdev__Max_Discount__c','sigmaerpdev__Product_Weight__c','sigmaerpdev__SKU__c','sigmaerpdev__Billing_Charge__c','sigmaerpdev__Billing_Interval__c'})
           ){*/
        if(checkAccessPermissionsProduct() == true)
        {
            prod = [Select Id,Name,Product_Description__c,Product_Price__c,Max_Discount__c,Product_Weight__c,SKU__c,Billing_Charge__c,Billing_Interval__c  from Product2 where Id =:prodId ];
        }
        //}
        return prod;
    } 
    
    
    @AuraEnabled
    public static Inventory__c fetchInventory(Id prodId)
    {    
        
        Inventory__c inv;
       /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new set<String>{'sigmaerpdev__Available_Qty__c','sigmaerpdev__ProductCode__r.Id'})
        ){*/
        if(checkAccessPermissionsInventory() == true)
        {
            inv = [Select Available_Qty__c from Inventory__c where ProductCode__r.Id =:prodId ];
        }
        //}
        return inv;
    } 
    
    @AuraEnabled
    public static Id orderSave(List<String> productList, String OrderIDD ,Id accId,String subid,String billingPerson,String storeName,String paymenttype,Double allPdtsAmount,Date orderdelivarydate)
    {        
        String inventorystatus;
        String invlocation;
        Inventory_Location_Product__c ILP;
        Inventory_Location_Product_Line_Item__c ILPLI;
        
        Default_Parameters__c options;
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')
        &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new set<String>{'Id','sigmaerpdev__Inventory_Status__c','sigmaerpdev__Default_Location__c','sigmaerpdev__Package_ID__c','sigmaerpdev__Parent_Id__c','sigmaerpdev__Shipment_ID__c','sigmaerpdev__StockReceiving_ID__c'})
        ){*/
        if(FLScheckAccessPermissionsCustomSettings())
        {
            
            options = [select Id,Inventory_Status__c,Default_Location__c,Package_ID__c,Parent_Id__c,Shipment_ID__c,StockReceiving_ID__c from Default_Parameters__c limit 1];
        }
        //}
        
        inventorystatus = options.Inventory_Status__c; 
        invlocation  = options.Default_Location__c;
        //*********************** Logic Ends here****************************************
        Map<Id,List<OrderLineLocation__c>> OrderLineItemLocations = new Map<Id,List<OrderLineLocation__c>>();
        List<OrderLineLocation__c> OrderLineLocList ;
        Map<Id,Product_Order_Price_Book__c> retainOrderLineData = new Map<Id,Product_Order_Price_Book__c>();
        
        Id orderId = OrderIDD;
        System.debug('value of OrderIDD ::'+OrderIDD);
        Boolean temp = false;
        Double TaxOnBillAmount = 0; 
        Integer numOfOrderLines = 0;
        Integer numofProds = 0;
        String delivarydate;
        String startdate;
        String duedate;
        String returndate;
        Integer netQuantity = 0;
        Decimal ProdDiscountd = 0.0;
        Decimal ProdDiscountsd = 0.0;
        
        
        
       /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__OrderLineLocation__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('Account')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
             && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Tax__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('RecordType',new set<String>{'id','Name'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'Id','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Discount__c','sigmaerpdev__Quantity__c','sigmaerpdev__Order_Created_Via__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'Id','Name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Quantity__c','sigmaerpdev__Discounts__c','sigmaerpdev__Total_Amount__c','sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__c',
                                    'sigmaerpdev__Product__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c','sigmaerpdev__Product__r.sigmaerpdev__Active__c','sigmaerpdev__Product__r.sigmaerpdev__Type__c','sigmaerpdev__Product__r.sigmaerpdev__Product_Price__c',
                                    'sigmaerpdev__Product__r.sigmaerpdev__Selling_Price__c','sigmaerpdev__Product__r.sigmaerpdev__Buying_Price__c','sigmaerpdev__Product__r.sigmaerpdev__Max_Discount__c',
                                    'sigmaerpdev__Sigma_Order__r.Id','sigmaerpdev__Sigma_Order__r.Name','sigmaerpdev__Sigma_Order__r.sigmaerpdev__AccountId__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__BillingPersonNew__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Orders_Status__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Start_Date__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__End_Date__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Status__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Order_Created_Via__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Tax__c',new set<String>{ 'sigmaerpdev__Tax_Amount__c','sigmaerpdev__Type__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__OrderLineLocation__c',new set<String>{'Id','Name','sigmaerpdev__Order_Line__c','sigmaerpdev__Location__c','sigmaerpdev__Unit_Price__c','sigmaerpdev__Start_Date__c','sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Status__c','sigmaerpdev__Allocation_Done__c','sigmaerpdev__End_Date__c','sigmaerpdev__Inventory_Status__c','sigmaerpdev__Product_Price__c','sigmaerpdev__Inventory_Location_Product__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'Id','Name','sigmaerpdev__City__c','sigmaerpdev__State__c','sigmaerpdev__Country__c','sigmaerpdev__Zip__c','sigmaerpdev__Address__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new set<String>{'Id','sigmaerpdev__Available_Qty__c','sigmaerpdev__Delivered_Qty__c','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__Purchased_Qty__c','sigmaerpdev__Total_Available_Qty__c','sigmaerpdev__Rental_Reserve_Quantity__c','sigmaerpdev__Rental_Delivered_Quantity__c','sigmaerpdev__Rental_Shipped_Quantity__c','sigmaerpdev__ProductCode__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new set<String>{'id', 'name', 'sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Inventory_Location__c', 'sigmaerpdev__Received_Quantity__c','sigmaerpdev__Rental_Delivered_Quantity__c','sigmaerpdev__Products__r.Id'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new set<String>{'id', 'name','sigmaerpdev__Reserved_Quantity__c','sigmaerpdev__Received_Quantity1__c','sigmaerpdev__Received_Quantity__c','sigmaerpdev__Product__c','sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__Inventory_Location__c','sigmaerpdev__Adjusted_Quantity__c','sigmaerpdev__Available_Quantity__c','sigmaerpdev__AvailableAdjustedQty__c','sigmaerpdev__Rental_Reserved_Quantity__c','sigmaerpdev__Inventory_Location_Product__r.id'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sigma_Order__c',new Set<String>{'sigmaerpdev__Billing_Person__c','sigmaerpdev__Discount__c','sigmaerpdev__StoreName__c','sigmaerpdev__EffectiveDate__c','sigmaerpdev__Status__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Order_Type__c','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Account_Subscription_Interval__c','sigmaerpdev__Delivary_Date__c','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Quantity__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__TotalAmount__c','sigmaerpdev__ShippingCity__c','sigmaerpdev__ShippingState__c','sigmaerpdev__ShippingCountry__c','sigmaerpdev__ShippingPostalCode__c','RecordTypeId','sigmaerpdev__Payment_type__c','sigmaerpdev__Net_Amount__c','sigmaerpdev__Tax__c'})
            &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev__Order_Id__c','sigmaerpdev__Discounts__c','sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Total_Amount__c','sigmaerpdev__Total_Price__c','sigmaerpdev__Delivary_Date__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__c','sigmaerpdev__tax_amount__c','sigmaerpdev__Inventory_Status__c','sigmaerpdev__Amount_Per_Interval__c','sigmaerpdev__Rental_Start_Date__c','sigmaerpdev__Billing_Interval__c','sigmaerpdev__Rental_Status__c','sigmaerpdev__Rental_Due_Date__c','sigmaerpdev__Rental_Return_Date__c'})
            &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev__Sigma_Order__c'})
            &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__OrderLineLocation__c',new Set<String>{'sigmaerpdev__Location__c','sigmaerpdev__Unit_Price__c','sigmaerpdev__Start_Date__c','sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Status__c','sigmaerpdev__Allocation_Done__c','sigmaerpdev__Inventory_Status__c','sigmaerpdev__Product_Price__c','sigmaerpdev__Inventory_Location_Product__c'})
            &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__OrderLineLocation__c',new Set<String>{'sigmaerpdev__Order_Line__c'})
            &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new Set<string>{'sigmaerpdev__Purchased_Qty__c','sigmaerpdev__Total_Available_Qty__c','sigmaerpdev__Delivered_Qty__c','sigmaerpdev__Available_Qty__c','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__Rental_Reserve_Quantity__c','sigmaerpdev__Available_Qty__c','sigmaerpdev__Rental_Delivered_Quantity__c'})
            &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev__Rental_Delivered_Quantity__c','sigmaerpdev__Inventory_Location__c'})
            &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new set<String>{'sigmaerpdev__Rental_Reserved_Quantity__c','sigmaerpdev__Inventory_Location__c'})
            && Schema.sObjectType.Inventory__c.fields.Id.isAccessible()
            && Schema.sObjectType.Inventory_Location_Product__c.fields.Id.isAccessible()
          )   
        {*/
            string rentalrecordtype = [SELECT id from RecordType where Name ='Rental Order'].Id;
            
            If(OrderIDD InstanceOf Id)
            {
                temp = true;
            }
            
            Sigma_Order__c editingOrder;
            if(temp)
            {
                if(checkAccessPermissionsOrder() == true)
                {  
                    editingOrder = [select Net_Quantity__c,Discount__c,Quantity__c,Order_Created_Via__c from Sigma_Order__c where Sigma_Order__c.Id=:orderId];
                    
                }
                
                List<Product_Order_Price_Book__c> deleteOldRecords;
                if(checkAccessPermissionsProductOrderPriceBook() == true && checkAccessFororderLineloc()==true )
                {
                    deleteOldRecords = [Select Id,Name,Sigma_Order__c,Quantity__c,Discounts__c,Total_Amount__c,Start_Date__c,End_Date__c,
                                        Product__c,Product__r.Name,Product__r.Attribute_Type__c,Product__r.Active__c,Product__r.Type__c,Product__r.Product_Price__c,
                                        Product__r.Selling_Price__c,Product__r.Buying_Price__c,Product__r.Max_Discount__c,
                                        Sigma_Order__r.Id,Sigma_Order__r.Name,Sigma_Order__r.AccountId__c,Sigma_Order__r.BillingPersonNew__c,Sigma_Order__r.Orders_Status__c,Sigma_Order__r.Start_Date__c,Sigma_Order__r.End_Date__c,Sigma_Order__r.Status__c,Sigma_Order__r.Order_Created_Via__c,
                                        (Select Id,Name,Order_Line__c,Location__c,Unit_Price__c,Start_Date__c,Product__c,Quantity__c,Status__c,Allocation_Done__c,End_Date__c,Inventory_Status__c,Product_Price__c,Inventory_Location_Product__c From OrderLineItemLocations__r ) From Product_Order_Price_Book__c where Sigma_Order__r.Id =:orderID];
                            
                }
                for(Product_Order_Price_Book__c child : deleteOldRecords)
                {
                    retainOrderLineData.put(child.Product__c,child);
                    OrderLineLocList = new List<OrderLineLocation__c>();
                    for(OrderLineLocation__c innerChld: child.OrderLineItemLocations__r)
                    {           
                        OrderLineLocList.add(innerChld);
                    }
                    if(!OrderLineItemLocations.containsKey(child.Product__c))
                    {
                        OrderLineItemLocations.put(child.Product__c,OrderLineLocList); 
                    }                          
                }
                Set<Id> deletingOrderProductsId = new Set<Id>();
                map<Id,Decimal> deletingOrderProductsQuantity = new map<Id,Decimal>();
                for(Product_Order_Price_Book__c a : deleteOldRecords)
                {      
                    deletingOrderProductsId.add(a.Product__r.Id);
                    deletingOrderProductsQuantity.put(a.Product__r.Id,a.Quantity__c);
                }
                deleteOldRecordsAndRollBackInventory(deletingOrderProductsId,deletingOrderProductsQuantity,inventorystatus,deleteOldRecords,invlocation);
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
                        
                        if(root.get('Discount') != null){
                            ProdDiscountd = ProdDiscountd + Double.valueOf(root.get('Discount'));
                        }
                        else{
                            ProdDiscountd = 0;
                        }
                    }                
                }
                
                netQuantity = numofProds;
                ProdDiscountsd = ProdDiscountd;
                
                //ends here
                //get tax from TaxCntr
                List<Tax__c> taxObj = TaxCntr.getTax(accId);
                Double federalTax = Double.valueOf(taxObj.get(0).Tax_Amount__c);
                String fedTaxType = String.valueOf(taxObj.get(0).Type__c);
                Double stateTax = Double.valueOf(taxObj.get(1).Tax_Amount__c);
                String stateTaxType = String.valueOf(taxObj.get(1).Type__c);
                
                if(fedTaxType == 'Percentage')
                {
                    TaxOnBillAmount = (Double.valueOf(allPdtsAmount) * Double.valueOf(federalTax)) / 100;
                }
                else
                {
                    TaxOnBillAmount = Double.valueOf(allPdtsAmount) + Double.valueOf(federalTax);
                }               
                if(stateTaxType == 'Percentage')
                {
                    TaxOnBillAmount = (Double.valueOf(TaxOnBillAmount) + (Double.valueOf(allPdtsAmount) * Double.valueOf(stateTax))/100);
                }
                else
                {
                    TaxOnBillAmount = (Double.valueOf(TaxOnBillAmount) + (Double.valueOf(allPdtsAmount) + Double.valueOf(stateTax)));
                }
                editingOrder.Net_Quantity__c = Integer.valueOf(netQuantity);
                editingOrder.Discount__c = ProdDiscountsd;
                
                if(orderdelivarydate!=null)
                {
                    editingOrder.Delivary_Date__c=orderdelivarydate;
                }
                editingOrder.Quantity__c = Integer.valueOf(netQuantity);
                editingOrder.Tax_Amount__c = Double.valueOf(TaxOnBillAmount);
                editingOrder.Tax__c = federalTax+stateTax;
                editingOrder.TotalAmount__c = Double.valueOf(allPdtsAmount) + Double.valueOf(TaxOnBillAmount);
                //ends here
                
                if(checkFLSOrder())
                {
                    update editingOrder;  
                }
            }
            else 
            {
                Sigma_Order__c productOrder = new Sigma_Order__c();
                productOrder.AccountId__c = accId;
                productOrder.Billing_Person__c = billingPerson;
                productOrder.StoreName__c = storeName; 
                productOrder.EffectiveDate__c = Date.today(); 
                productOrder.Status__c = 'Draft';
                productOrder.Orders_Status__c = 'Order Confirmed';
                productOrder.Order_Type__c = 'OFFLINE';
                productOrder.RecordTypeId = rentalrecordtype;
                productOrder.Order_Created_Via__c = 'POS';
                productOrder.Account_Subscription_Interval__c= subid;
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
                            ProdDiscountd = 0;
                        }
                    }                
                }
                netQuantity = numofProds;
                ProdDiscountsd = ProdDiscountd;
                productOrder.Net_Quantity__c= netQuantity;
                productOrder.Quantity__c= netQuantity;
                productOrder.Discount__c= ProdDiscountsd;
                if( orderdelivarydate != null )
                {
                    productOrder.Delivary_Date__c = orderdelivarydate;
                }
                
                if(paymenttype== null){
                     productOrder.Payment_type__c = 'Postpaid';
                }
                else{
                     productOrder.Payment_type__c = paymenttype;
                }
                
                
                //ends here
                //get tax from TaxCntr
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
                productOrder.Net_Amount__c= allPdtsAmount;
                productOrder.Tax__c = federalTax+stateTax;
                productOrder.TotalAmount__c = allPdtsAmount+ TaxOnBillAmount;
                //ends here
                //**********************New code Added to Write shipping Address into an order on Nov-24 Starts here **************
                if(OrderIDD == null || OrderIDD ==''){
                    Account accAddress;
                    if(checkFLSAccountForAddress())
                    {
                        accAddress = [select Id,Name,City__c,State__c,Country__c,Zip__c,Address__c from Account where Id = :accId];
                    }  
                    if(accAddress.City__c != null || accAddress.City__c != '')
                    {
                        productOrder.ShippingCity__c  = accAddress.Address__c +','+accAddress.City__c; 
                    }
                    if(accAddress.State__c != null || accAddress.State__c != '')
                    {
                        productOrder.ShippingState__c   = accAddress.State__c ; 
                    }
                    if(accAddress.Country__c != null || accAddress.Country__c != '')
                    {
                        productOrder.ShippingCountry__c    = accAddress.Country__c  ; 
                    }
                    if(accAddress.Zip__c != null || accAddress.Zip__c != '')
                    {
                        productOrder.ShippingPostalCode__c = accAddress.Zip__c  ; 
                    }
                }   
                //**********************New code Added to Write shipping Address into an order on Nov-24 Starts here **************
                if(checkCrudAccessForOrder() == true)
                {
                    insert productOrder;
                }    
                orderId = productOrder.Id;  
            } 
            List<Product_Order_Price_Book__c> productLines = new List<Product_Order_Price_Book__c>();
            Product_Order_Price_Book__c productLineObj;
            List<Inventory__c> inventoryLines = new List<Inventory__c>();
            Inventory__c inventoryObj;
            List<Inventory_Location_Product__c> ILPList = new List<Inventory_Location_Product__c>();
            List<Inventory_Location_Product_Line_Item__c> ILPLIList = new List<Inventory_Location_Product_Line_Item__c>();
            numOfOrderLines = productList.size();
            
            for(String a: productList)
            {
                productLineObj = new Product_Order_Price_Book__c();
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
                    
                    productLineObj.Sigma_Order__c = orderId;
                    productLineObj.Order_Id__c = orderId;
                    productLineObj.Product__c = String.valueOf(root.get('Id'));
                    productLineObj.Quantity__c = Integer.valueOf(root.get('quantity'));
                    productLineObj.Net_Quantity__c= Integer.valueOf(root.get('quantity'));
                    productLineObj.Amount_Per_Interval__c = Integer.valueOf(root.get('amountperinterval'));
                    productLineObj.Total_Price__c = Double.valueOf(root.get('productAmount'));
                    productLineObj.Rental_Status__c = String.valueOf(root.get('rentalstatus'));
                    productLineObj.Billing_Interval__c = String.valueOf(root.get('billinginterval'));
                    
                    if(root.get('Discount') != null && root.get('Discount') != ''){
                        productLineObj.Discounts__c = Double.valueOf(root.get('Discount'));
                    }
                    else{
                        productLineObj.Discounts__c = 0;
                    }
                    delivarydate=String.valueOf(root.get('deliverydate'));
                    if(delivarydate!='' && delivarydate!=null)
                    {
                        productLineObj.Delivary_Date__c=Date.valueOf(delivarydate); 
                    }
                    
                    startdate=String.valueOf(root.get('startdate'));
                    if(startdate!='' && startdate!=null)
                    {
                        productLineObj.Rental_Start_Date__c=Date.valueOf(startdate); 
                    }
                    
                    duedate=String.valueOf(root.get('duedate'));
                    if(duedate!='' && duedate!=null)
                    {
                        productLineObj.Rental_Due_Date__c=Date.valueOf(duedate); 
                    }
                    
                    returndate=String.valueOf(root.get('returneddate'));
                    if(returndate!='' && returndate!=null)
                    {
                        productLineObj.Rental_Return_Date__c=Date.valueOf(returndate); 
                    }
                    //Chaged on 16 November to isolate order status and OrderLines status
                    productLineObj.Order_Status__c = 'Order Confirmed';
                    
                    if(retainOrderLineData.containsKey(productLineObj.Product__c))
                    {
                        productLineObj.Start_Date__c = retainOrderLineData.get(productLineObj.Product__c).Start_Date__c;
                        productLineObj.End_Date__c = retainOrderLineData.get(productLineObj.Product__c).End_Date__c;
                    }
                    
                    //added for tax calculation orderLines
                    Double taxForPriceBookItems;
                    Double totalAmountOL = Double.valueOf(root.get('totalAmount'));
                    taxForPriceBookItems = (Double.valueOf(totalAmountOL) / Double.valueOf(allPdtsAmount)) * Double.valueOf(TaxOnBillAmount);
                    productLineObj.tax_amount__c = taxForPriceBookItems;
                    //ends here.
                    if(checkAccessPermissionsInventory() == true)
                    {
                        inventoryObj = [Select Id,Available_Qty__c,Delivered_Qty__c ,Reserved_Qty__c,Purchased_Qty__c, Total_Available_Qty__c, Rental_Reserve_Quantity__c, Rental_Delivered_Quantity__c, Rental_Shipped_Quantity__c  from Inventory__c where ProductCode__c=:productLineObj.Product__c];
                    }
                    if(inventorystatus !='Reserve')
                    {
                              
                            ILP = [select id, name, Delivered_Quantity__c,Inventory_Location__c, Received_Quantity__c,Rental_Delivered_Quantity__c from Inventory_Location_Product__c where Products__r.Id = :productLineObj.Product__c Limit 1];
                         
                        
                                
                        ILPLI = [select id, name,Reserved_Quantity__c,Received_Quantity1__c,Received_Quantity__c,Product__c,Inventory_Location_Product__c,Inventory_Location__c,Adjusted_Quantity__c,Available_Quantity__c,AvailableAdjustedQty__c,Rental_Reserved_Quantity__c from Inventory_Location_Product_Line_Item__c where Inventory_Location_Product__r.id =: ILP.id Limit 1];
                      
                    }
                    
                    if(inventorystatus =='Reserve')
                    {   
                        productLineObj.Inventory_Status__c = 'Reserve';
                        inventoryObj.Rental_Reserve_Quantity__c = inventoryObj.Rental_Reserve_Quantity__c + productLineObj.Quantity__c;
                        inventoryObj.Available_Qty__c  = inventoryObj.Available_Qty__c - productLineObj.Quantity__c;
                        
                    }
                    else{
                       
                        productLineObj.Inventory_Status__c = 'Allocated';    
                        inventoryObj.Available_Qty__c  = inventoryObj.Available_Qty__c - productLineObj.Quantity__c;
                        inventoryObj.Rental_Delivered_Quantity__c  = inventoryObj.Rental_Delivered_Quantity__c + productLineObj.Quantity__c;
                        ILPrd.Rental_Delivered_Quantity__c = ILP.Rental_Delivered_Quantity__c + productLineObj.Quantity__c;
                        ILPrd.Inventory_Location__c = invlocation;
                        ILPrd.Id = ILP.Id;
                        ILPList.add(ILPrd);
                        // new code  ILPLIPrd ILPLIList
                       
                        ILPLIPrd.Rental_Reserved_Quantity__c =ILPLI.Rental_Reserved_Quantity__c + productLineObj.Quantity__c;
                        ILPLIPrd.Inventory_Location__c = invlocation;
                        ILPLIPrd.Id = ILPLI.Id;
                        ILPLIList.add(ILPLIPrd);
                        
                    }
                    
                    inventoryLines.add(inventoryObj);
                    
                    productLines.add(productLineObj);
                }
            }
            upsert productLines;
            //------Code to Insert OrderLineItemLocationsif Exists ------------------
            List<OrderLineLocation__c> LineLocationInsertList = new List<OrderLineLocation__c>();
            for(Product_Order_Price_Book__c tempOrdeLine: productLines)
            {
                if(OrderLineItemLocations.containsKey(tempOrdeLine.Product__c))
                {
                    
                    List<OrderLineLocation__c> LineLocationList  = OrderLineItemLocations.get(tempOrdeLine.Product__c);
                    
                    for(OrderLineLocation__c lineiItem : LineLocationList)
                    {
                        OrderLineLocation__c lineItemObj = new OrderLineLocation__c();
                        lineItemObj.Order_Line__c = tempOrdeLine.Id;
                        lineItemObj.Location__c = lineiItem.Location__c;
                        lineItemObj.Unit_Price__c = lineiItem.Unit_Price__c; 
                        lineItemObj.Start_Date__c = lineiItem.Start_Date__c;
                        lineItemObj.Product__c = lineiItem.Product__c;
                        lineItemObj.Quantity__c = lineiItem.Quantity__c;
                        lineItemObj.Status__c = 'Order Confirmed';
                        lineItemObj.Allocation_Done__c = lineiItem.Allocation_Done__c;
                        lineItemObj.Inventory_Status__c = lineiItem.Inventory_Status__c;
                        lineItemObj.Product_Price__c = lineiItem.Product_Price__c; 
                        lineItemObj.Inventory_Location_Product__c = lineiItem.Inventory_Location_Product__c;    
                        LineLocationInsertList.add(lineItemObj);
                    }
                }
            }
            
            //----------Till Here ----------------------------------------------------
            if(checkFLSOrderlineloc()==true)
            {
                insert LineLocationInsertList;
            }
            
            if(checkCrudAccessForInventory())
            {
                update inventoryLines;
            }
            if(checkCrudAccessForInventoryLocationProduct())
            {
                update ILPList;
               
            }
            update ILPLIList;
           
        //}
        return orderId;
    } 
    //-------------------End Ord orderSave()--------------------------------------------------------
    /*
* FLS Check
*/
    public Static boolean checkAccessPermissionsProduct(){
       /* if(CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'Id','Name','Description','sigmaerpdev__Product_Price__c','sigmaerpdev__Max_Discount__c','sigmaerpdev__Product_Weight__c','sigmaerpdev__SKU__c'}))
        {*/                                                                                       
            return true;
        /*}  
        return false;*/
    }
    
    public Static boolean checkAccessPermissionsInventory(){
       /* if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new Set<String>{'Id', 'sigmaerpdev__Available_Qty__c', 'sigmaerpdev__Reserved_Qty__c','sigmaerpdev__Total_Available_Qty__c', 'sigmaerpdev__Purchased_Qty__c','sigmaerpdev__ProductCode__r.Id'}))
            
        {*/                                                                                       
            return true;
        /*}  
        return false;*/
    }
    
    public Static boolean checkAccessPermissionsAccount(){
       /* if(CRUD_FLS_CheckUtility.checkReadPermission('Account',new Set<String>{'sigmaerpdev__Currency__c'}))
        {  */                                                                                     
            return true;
        /*}  
        return false;*/
    }
    
    public Static boolean checkAccessPermissionsOrder(){
       /* if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new Set<String>{'sigmaerpdev__Net_Quantity__c','sigmaerpdev__Quantity__c','sigmaerpdev__Order_Created_Via__c'}))
        {*/                                                                                       
            return true;
       /* }  
        return false;*/
    }
    
    public Static boolean checkAccessPermissionsProductOrderPriceBook(){
       /* if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'Id','sigmaerpdev__Discounts__c','sigmaerpdev__Product__r.Id','Name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Quantity__c','sigmaerpdev__Total_Amount__c','sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__c','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c','sigmaerpdev__Product__r.sigmaerpdev__Active__c','sigmaerpdev__Product__r.sigmaerpdev__Type__c','sigmaerpdev__Product__r.sigmaerpdev__Product_Price__c','sigmaerpdev__Product__r.sigmaerpdev__Selling_Price__c','sigmaerpdev__Product__r.sigmaerpdev__Buying_Price__c','sigmaerpdev__Product__r.sigmaerpdev__Max_Discount__c','sigmaerpdev__Sigma_Order__r.Id','sigmaerpdev__Sigma_Order__r.Name','sigmaerpdev__Sigma_Order__r.sigmaerpdev__AccountId__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__BillingPersonNew__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Orders_Status__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Start_Date__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__End_Date__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Status__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Order_Created_Via__c'}))
        { */                                                                                      
            return true;
        /*}  
        return false;*/
    }
    
    public Static boolean checkAccessPermissionsOrderOne(){
        
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new Set<String>{'id','sigmaerpdev__AccountId__c','sigmaerpdev__AccountId__r.name','sigmaerpdev__StoreName__c','sigmaerpdev__Order_Number__c','sigmaerpdev__Billing_Person__c','sigmaerpdev__Status__c','sigmaerpdev__TotalAmount__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__BillingPersonNew__c','sigmaerpdev__BillingPersonNew__r.Name'}))
            
        { */                                                                                      
            return true;
        /*}  
        return false;*/
    }
    
    public Static boolean checkAccessPermissionsProductOrderPriceBookOne(){
       /* if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'id','sigmaerpdev__Customer__r.Id','sigmaerpdev__Sigma_Order__r.Id','sigmaerpdev__Quantity__c','sigmaerpdev__Product_Name__c','sigmaerpdev__Total_Amount__c','sigmaerpdev__Total_Price__c','sigmaerpdev__TotalProductPrice__c','sigmaerpdev__Product__r.Id'}))
            
        { */                                                                                      
            return true;
        /*}  
        return false;*/
    }
    
   
    public Static boolean checkCrudAccessForProduct1()
    {
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c'))
        {*/
            return true;
       /* }  
        else
        {
            return false;
        }*/
    }
    
    public Static boolean checkFLSOrder(){
       /* if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new Set<String>{'sigmaerpdev__AccountId__c','sigmaerpdev__Billing_Person__c','sigmaerpdev__StoreName__c','sigmaerpdev__EffectiveDate__c','sigmaerpdev__Status__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Order_Type__c','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Delivary_Date__c','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Discount__c','sigmaerpdev__Quantity__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__TotalAmount__c'}))
        { */                                                                                      
            return true;
       /* }  
        return false;*/
    }
    public Static boolean FLScheckAccessPermissionsCustomSettings(){                      
       /* if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new Set<String>{'Id','sigmaerpdev__Inventory_Status__c','sigmaerpdev__Package_ID__c','sigmaerpdev__Parent_Id__c','sigmaerpdev__Shipment_ID__c','sigmaerpdev__StockReceiving_ID__c','sigmaerpdev__Currency__c'}))
        {  */                                                                                     
            return true;
        /*}  
        return false;*/
    }
    
    public Static boolean checkFLSAccountForAddress(){            
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('Account',new Set<String>{'Id','Name','sigmaerpdev__City__c','sigmaerpdev__State__c','sigmaerpdev__Country__c','sigmaerpdev__Zip__c','sigmaerpdev__Address__c'}))
        { */                                                                                      
            return true;
       /* }  
        return false;*/
    }
    
    
    public Static boolean checkFLSOrderlineloc()
    {
        /*if(CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__OrderLineLocation__c',new Set<String>{'sigmaerpdev__Location__c','sigmaerpdev__Unit_Price__c','sigmaerpdev__Start_Date__c','sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Status__c','sigmaerpdev__Allocation_Done__c','sigmaerpdev__Inventory_Status__c','sigmaerpdev__Product_Price__c','sigmaerpdev__Inventory_Location_Product__c'}))
        {*/
            return true;
        /*}  
        else
        {
            return false;
        }*/
    }
    public Static boolean checkCrudAccessForOrder()
    {
       /* if(CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sigma_Order__c',new Set<String>{'sigmaerpdev__AccountId__c','sigmaerpdev__Discount__c','sigmaerpdev__Billing_Person__c','sigmaerpdev__StoreName__c','sigmaerpdev__EffectiveDate__c','sigmaerpdev__Status__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Order_Type__c','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Account_Subscription_Interval__c','sigmaerpdev__Delivary_Date__c','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Quantity__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__TotalAmount__c','sigmaerpdev__ShippingCity__c','sigmaerpdev__ShippingState__c','sigmaerpdev__ShippingCountry__c','sigmaerpdev__ShippingPostalCode__c'}))
        {*/
            return true;
        /*}  
        else
        {
            return false;
        }*/
    }
    public Static boolean checkCrudAccessForInventory()
    {
       /* if(CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new Set<string>{'sigmaerpdev__Purchased_Qty__c','sigmaerpdev__Total_Available_Qty__c','sigmaerpdev__Delivered_Qty__c','sigmaerpdev__Available_Qty__c','sigmaerpdev__Reserved_Qty__c'}))
        {*/
            return true;
        /*}  
        else
        {
            return false;
        }*/
    }
    
   
    
    public Static boolean checkCrudAccessForInventoryLocationProduct()
    {
        /*if(CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Inventory_Location__c'}))
        {*/
            return true;
        /*}  
        else
        {
            return false;
        }*/
    } 
    
    public Static boolean checkAccessFororderLineloc(){
       /* if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__OrderLineLocation__c',new Set<String>{'Id','Name','sigmaerpdev__Order_Line__c','sigmaerpdev__Location__c','sigmaerpdev__Unit_Price__c','sigmaerpdev__Start_Date__c','sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Status__c','sigmaerpdev__Allocation_Done__c','sigmaerpdev__End_Date__c','sigmaerpdev__Inventory_Status__c','sigmaerpdev__Product_Price__c','sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__Product__r.Name'}))
        { */                                                                                      
            return true;
        /*}  
        return false;*/
    }
    
    public static void deleteOldRecordsAndRollBackInventory(Set<Id> deletingOrderProductsId,Map<Id,Decimal> deletingOrderProductsQuantity, String inventorystatus,List<Product_Order_Price_Book__c> deleteOldRecords, String invlocation)
    {
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new set<String>{'Id', 'sigmaerpdev__Available_Qty__c','sigmaerpdev__Reserved_Qty__c', 'sigmaerpdev__Total_Available_Qty__c','sigmaerpdev__ProductCode__r.Id', 'sigmaerpdev__Purchased_Qty__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new set<String>{'id', 'name', 'sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Inventory_Location__c', 'sigmaerpdev__Received_Quantity__c' , 'sigmaerpdev__Products__r.Id'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new Set<string>{'sigmaerpdev__Purchased_Qty__c','sigmaerpdev__Total_Available_Qty__c','sigmaerpdev__Delivered_Qty__c','sigmaerpdev__Available_Qty__c','sigmaerpdev__Reserved_Qty__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Inventory_Location__c'})
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
           &&Schema.sObjectType.Inventory__c.fields.Id.isAccessible()
           &&Schema.sObjectType.Inventory_Location_Product__c.fields.Id.isAccessible()
          )
        {*/
            List<Inventory__c> InventoryLISTS; 
            Inventory_Location_Product__c ILP;  
            List<Inventory_Location_Product__c> ILPList = new List<Inventory_Location_Product__c>();         
            if(checkAccessPermissionsInventory() == true)
            {
                InventoryLISTS = [Select Id, Available_Qty__c,Reserved_Qty__c, Total_Available_Qty__c,ProductCode__r.Id, Purchased_Qty__c from Inventory__c where ProductCode__r.Id in :deletingOrderProductsId];
            }
            
            if(inventorystatus !='Reserve')
            {
                if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c', new Set<String>{'Id','Name','sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Inventory_Location__c','sigmaerpdev__Received_Quantity__c'}))// Done by Raghavendra on June-05
                {       
                    ILP = [select id, name, Delivered_Quantity__c,Inventory_Location__c, Received_Quantity__c from Inventory_Location_Product__c where Inventory_Location__c =:invlocation AND  Products__r.Id = :deletingOrderProductsId];
                } 
            }           
            List<Inventory__c> modifiedInventoryList = new List<Inventory__c>();
            Inventory__c temp1;
            for(Inventory__c b : InventoryLISTS )
            {
                Inventory_Location_Product__c  ILPrd = new Inventory_Location_Product__c ();
                Decimal tempQuantity = deletingOrderProductsQuantity.get(b.ProductCode__r.Id);
                temp1 = new Inventory__c();
                if(inventorystatus == 'Reserve')
                {
                    temp1.Reserved_Qty__c = b.Reserved_Qty__c -  tempQuantity;
                    temp1.Available_Qty__c  = b.Available_Qty__c + tempQuantity;
                    
                }
                else
                {      
                    
                    temp1.Available_Qty__c = b.Available_Qty__c + tempQuantity ;
                    temp1.Purchased_Qty__c = b.Purchased_Qty__c - tempQuantity ;
                    try
                    {
                        temp1.Total_Available_Qty__c = b.Total_Available_Qty__c - tempQuantity;
                    }
                    catch(Exception ex)
                    {
                        System.debug('Inside a Exception catch block for total available quantity***'+ex);
                    }
                    ILPrd.Delivered_Quantity__c = ILP.Delivered_Quantity__c - tempQuantity;
                    ILPrd.Inventory_Location__c = invlocation;
                    ILPrd.Id = ILP.Id;
                    ILPList.add(ILPrd); 
                }
                temp1.Id = b.Id;
                modifiedInventoryList.add(temp1);
            }
            if(checkCrudAccessForInventory())
            {
                
                upsert modifiedInventoryList;
                
            }
            
            if(checkCrudAccessForInventoryLocationProduct())
            {
                
                update ILPList;
                
            }
            
            
            if(checkCrudAccessForProduct1())
            {
                
                delete deleteOldRecords;
            }
        //}
        
    }
    
    @AuraEnabled
    public static Sigma_Order__c getOrderDetails(Id OrderId)
    {
        
        Sigma_Order__c OrderObjectDetail = new Sigma_Order__c();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'id','Name','sigmaerpdev__Order_Number__c','sigmaerpdev__Discount__c', 'sigmaerpdev__TotalAmount__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Is_Payment_Made__c'})
            ){*/
        if(checkAccessgetOrderDetails())
        {
            OrderObjectDetail = [select id,Name,Order_Number__c,Discount__c, TotalAmount__c,Orders_Status__c,Is_Payment_Made__c from Sigma_Order__c where Id=:OrderId limit 1];
            
        }
        //}
        return OrderObjectDetail;
    }
    @AuraEnabled
    public static Account_Subscription__c subscriptionrecord(id Ids)
    {
        
        Account_Subscription__c srecord = new Account_Subscription__c();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Account_Subscription__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Account_Subscription__c',new set<String>{'id','sigmaerpdev__Account__r.Name','sigmaerpdev__Subscription_Total_Amount__c','sigmaerpdev__SubscriptionDetail__r.sigmaerpdev__Product__r.name','sigmaerpdev__Total_Intervel__c','sigmaerpdev__Order_Unit__c'})){
        */
        if(checkAccesssubscriptionrecord())
        {
            srecord = [select id,Account__r.Name,Subscription_Total_Amount__c,SubscriptionDetail__r.Product__r.name,Total_Intervel__c,Order_Unit__c from Account_Subscription__c where id=:ids];
            
        }
        ///}
        return srecord;    
    }
    public Static boolean checkAccessOrderRecords(){
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new Set<String>{'Id','sigmaerpdev__Order_Number__c','sigmaerpdev__Is_Payment_Made__c','sigmaerpdev__BillingPersonNew__c','sigmaerpdev__BillingPersonNew__r.Name','sigmaerpdev__TotalAmount__c','sigmaerpdev__Orders_Status__c','Account.Name'}))
        {*/
            return true;
        /*}  
        return false;*/
    }
    public Static boolean checkAccessgetOrderDetails(){
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new Set<String>{'Id','Name','sigmaerpdev__Date__c','sigmaerpdev__Order_Number__c','sigmaerpdev__TotalAmount__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Is_Payment_Made__c'}))
        {*/
            return true;
        /*}  
        return false;*/
    }
    
    public Static boolean checkAccesssubscriptionrecord(){
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Account_Subscription__c',new Set<String>{'Id','sigmaerpdev__Account__r.Name','sigmaerpdev__Total_Subscription_Amount__c','sigmaerpdev__Subscription__r.sigmaerpdev__Product__r.name','sigmaerpdev__Total_unit__c','sigmaerpdev__Order_Number__c'}))
        {*/
            return true;
        /*}  
        return false;*/
    }
    
    
    //-------------------End Ord orderSave()--------------------------------------------------------
    //------method for newpackage module to on load the order------
    @AuraEnabled
    public static List<Sigma_Order__c> getInfoForSoOnHover(String stappOrderId){
        List<Sigma_Order__c> retStr = new List<Sigma_Order__c>();
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
         && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
         && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'id','sigmaerpdev__Date__c'})
         && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev__Product__r.Name'})
        ){*/
        if(checkAccessgetOrderDetails()==true && checkAccessFororderLineloc()==true )
        {
            retStr = [select id,Date__c,(select Product__r.Name from Order_Lines__r) from Sigma_Order__c where id = :stappOrderId];        
            
        }
        //}
        return retStr;
    }
    
    
    @AuraEnabled
    public static List<Package__c> getPackageInfoForSoOnHover(String packageId){
        List<Package__c> retStr = new List<Package__c>();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
          && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
          && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new set<String>{'id','Name','sigmaerpdev__Customer__r.Name'})
          && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new set<String>{'sigmaerpdev__Sigma_Order__r.name','sigmaerpdev__Product__r.Name','sigmaerpdev__Package__r.Name','sigmaerpdev__Package__r.sigmaerpdev__Customer__r.Name'})
        ){*/
        if(checkPackagerecord()==true && checkPackageProductrecord()==true)
        {
            retStr = [select id,Name,Customer__r.Name,(select Sigma_Order__r.name,Product__r.Name,Package__r.Name,Package__r.Customer__r.Name from PackagedProducts__r) from Package__c where id = :packageId];        
        }
        //}
        return retStr;
        
    }
    
    @AuraEnabled
    public static List<Package__c> getPackageInfoOnHover(String packageId){
        List<Package__c> retStr = new List<Package__c>();
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
         && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
         && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new set<String>{'id','Name','sigmaerpdev__Customer__r.Name'})
         && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new set<String>{'sigmaerpdev__Sigma_Order__r.name','sigmaerpdev__Product__r.Name','sigmaerpdev__Package__r.Name','sigmaerpdev__Package__r.sigmaerpdev__Customer__r.Name'})
        ){*/
        if(checkPackagerecord()==true && checkPackageProductrecord()==true)
        {
            retStr = [select id,Name,Customer__r.Name,(select Sigma_Order__r.name,Product__r.Name,Package__r.Name,Package__r.Customer__r.Name from PackagedProducts__r) from Package__c where id = :packageId];        
        }
        //}
        return retStr;
    }
    
    //fls added by anuja
    public Static boolean checkPackagerecord(){
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new Set<String>{'id','Name','sigmaerpdev__Customer__r.Name'}))
        {*/
            return true;
        /*}  
        return false;*/
    }
    
    public Static boolean checkPackageProductrecord(){
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'sigmaerpdev__Sigma_Order__r.name','sigmaerpdev__Product__r.Name','sigmaerpdev__Package__r.Name','sigmaerpdev__Package__r.sigmaerpdev__Customer__r.Name'}))
        {*/
            return true;
        /*}  
        return false;*/
    } 
}