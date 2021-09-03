public with sharing class PickingOrderCtrl  
{  
     //code added to fetch product image data 13-05
     @AuraEnabled
    public static ContentDocumentLink fetchProductImageInformation(Id prodId)
    {
     ContentDocumentLink productimagecontent=null;
     /*if(CRUD_FLS_CheckUtility.checkObjCRUD('ContentDocumentLink') && CRUD_FLS_CheckUtility.checkReadPermission('ContentDocumentLink',new set<String>{'id','ContentDocumentId','ContentDocument.FileExtension','ContentDocument.LatestPublishedVersionId','ContentDocument.LatestPublishedVersion.Title','SystemModstamp','LinkedEntityId','Visibility','ShareType'}))
        {*/
            try{
            productimagecontent = [SELECT Id, ContentDocumentId,ContentDocument.FileExtension, ContentDocument.LatestPublishedVersionId,ContentDocument.LatestPublishedVersion.Title,SystemModstamp,LinkedEntityId,Visibility,ShareType FROM ContentDocumentLink WHERE LinkedEntityId =: prodId and ContentDocument.FileExtension IN ('jpg','png') order by SystemModstamp DESC limit 1];
            System.debug('productimagecontent >>'+productimagecontent );
            }
            catch(Exception e)
            {
            System.debug('e.>>'+e.getCause());
             createErrorLog.insertError('PickingOrder',e.getMessage(),'Method -fetchProductImageInformation ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                    
            }
       // }
         return productimagecontent;
    }
    //added on 24-09-2019 to do confirm picking  for multiple  orders records
    @AuraEnabled
    public static void PickingPrintedOrderInBulk(List<Id> orderIDList)
    {
        
       /* if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Picking_Slip__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Picking_Slip__c',new Set<String>{'sigmaerpdev__Order__c','sigmaerpdev__Status__c'})     
            && CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'Id'}) 
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Picking_Slip__c',new Set<String>{'Id','Name'})  
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new Set<String>{'id','name','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__ProductCode__c','sigmaerpdev__Available_Qty__c','sigmaerpdev__Total_Available_Qty__c','sigmaerpdev__Delivered_Qty__c','sigmaerpdev__Comments__c','sigmaerpdev__Picked_Quantity__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'Id','Name','OrderId','Order.sigmaerpdev__Allocated_User__c','Order.Name','Product2.sigmaerpdev__Attribute_Type__c','Product2.sigmaerpdev__Product_Bar_Code__c','Product2.Name','sigmaerpdev__Net_Quantity__c','Product2.ProductCode','sigmaerpdev__Order_Status__c','sigmaerpdev__Picking_Slip__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{'id','name','sigmaerpdev__Order_Product__c','sigmaerpdev__Order_Product__r.Product2Id','sigmaerpdev__Quantity__c','sigmaerpdev__Status__c','sigmaerpdev__Picked_Quantity__c','sigmaerpdev__ILPLI__c','sigmaerpdev__Picking__c','sigmaerpdev__ILPLI__r.sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Name'})
             && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Allocation__c',new set<String>{'sigmaerpdev__Picking__c','sigmaerpdev__Status__c','sigmaerpdev__Picked_Quantity__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new Set<String>{'sigmaerpdev__Reserved_Qty__c','sigmaerpdev__Picked_Quantity__c'})
            && CRUD_FLS_CheckUtility.checkFLS('OrderItem',new set<String>{'sigmaerpdev__Picking_Slip__c'})
        )
        {*/
            try{
                Order_Usage__c OrderType=[select Sigma_order__c,Standard_object__c,Allocation_in_Sales_Order__c,Allocation_in_Picking__c,Auto_Allocate_in_picking__c  from Order_Usage__c Limit 1];
                if(OrderType.Standard_object__c==true )
                {
                    Map<Id,Picking_Slip__c> orderIdPikingMap=new Map<Id,Picking_Slip__c>();
                    for(Id orderId:orderIDList)
                    {
                        Picking_Slip__c pick=new Picking_Slip__c();
                        pick.Order__c=orderId;
                        pick.Status__c='Picked';
                        orderIdPikingMap.put(orderId,pick);
                    }
                    if(orderIdPikingMap.values().size()>0)
                        insert orderIdPikingMap.values();
                    Map<Id,List<OrderItem>> orderIdOrderLineLListMap=new Map<Id,List<OrderItem>>();
                    for(OrderItem orderLine: [select id,OrderId,Order.Allocated_User__c,Order.name,Product2.Attribute_Type__c,Product2.ProductCode,Product2.Product_Bar_Code__c,Product2.name,Quantity,Net_Quantity__c,
                                              (select id,name,Order_Product__c,Order_Product__r.Product2Id,Quantity__c,Status__c,Picked_Quantity__c,ILPLI__c,Picking__c ,ILPLI__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.name from Inventory_Allocations__r ) 
                                              from OrderItem where OrderId=:orderIDList AND  Order_Status__c='Order Confirmed' and id in (select Order_Product__c from Inventory_Allocation__c where Status__c=:'Printed')])
                    {
                        if(orderIdOrderLineLListMap.containsKey(orderLine.OrderId)){
                            List<OrderItem> tempList=orderIdOrderLineLListMap.get(orderLine.OrderId);
                            tempList.add(orderLine);
                            orderIdOrderLineLListMap.put(orderLine.OrderId,tempList);
                        }
                        else
                            orderIdOrderLineLListMap.put(orderLine.OrderId,new List<OrderItem>{orderLine});
                    }
                    List<OrderItem> deliveredSOlines=new List<OrderItem>();
                    List<OrderItem> orderLineListToUpdate=new List<OrderItem>();
                    List<Inventory_Allocation__c> iaList=new List<Inventory_Allocation__c>();
                    Map<id,decimal> ILPLIIdQuantMap=new Map<Id,Decimal>();
                    Map<id,decimal> productIdQuantMap=new Map<Id,Decimal>();
                    for(Id orderID:orderIdOrderLineLListMap.keySet())
                    {
                        List<OrderItem> solList=orderIdOrderLineLListMap.get(orderID);
                        for(OrderItem orderLine:solList)
                        {
                            orderLine.Picking_Slip__c=orderIdPikingMap.get(orderID).Id;
                            orderLineListToUpdate.add(orderLine);
                            for(Inventory_Allocation__c ia:orderLine.Inventory_Allocations__r)
                            {
                                ia.Status__c='Picked';
                                ia.Picking__c=orderIdPikingMap.get(orderID).Id;
                                ia.Picked_Quantity__c=ia.Quantity__c;
                                iaList.add(ia);
                                if(ILPLIIdQuantMap.containskey(ia.ILPLI__c))
                                    ILPLIIdQuantMap.put(ia.ILPLI__c,ILPLIIdQuantMap.get(ia.ILPLI__c)+ia.Picked_Quantity__c);
                                else
                                    ILPLIIdQuantMap.put(ia.ILPLI__c,ia.Picked_Quantity__c);
                                
                                if(productIdQuantMap.containsKey(ia.Order_Product__r.Product2Id))
                                    productIdQuantMap.put(ia.Order_Product__r.Product2Id,productIdQuantMap.get(ia.Order_Product__r.Product2Id)+ia.Picked_Quantity__c);
                                else productIdQuantMap.put(ia.Order_Product__r.Product2Id,ia.Picked_Quantity__c);
                                
                            }
                        }
                    }
                    if(orderLineListToUpdate.size()>0){
                        update orderLineListToUpdate;
                    }
                    if(ILPLIIdQuantMap.values().size()>0){
                        InventoryManagement.reduceWholeInventory(ILPLIIdQuantMap,'Avail_Reserve_Quantity');
                    }
                    if(iaList.size()>0){
                        upsert iaList;
                    }
                    if(productIdQuantMap.size()>0 )
                    {
                        List<Inventory__c> invList=new List<Inventory__c>();
                        for(Inventory__c inv:[select id,name,ProductCode__c,Reserved_Qty__c,Total_Available_Qty__c,Delivered_Qty__c,Available_Qty__c,Picked_Quantity__c,Comments__c from Inventory__c where ProductCode__c in:productIdQuantMap.keySet()])
                        { 
                            if(productIdQuantMap.containsKey(inv.ProductCode__c))
                            {
                                if(inv.Picked_Quantity__c==null) 
                                    inv.Picked_Quantity__c=0;
                                inv.Picked_Quantity__c+=productIdQuantMap.get(inv.ProductCode__c);
                                inv.Reserved_Qty__c-=productIdQuantMap.get(inv.ProductCode__c);
                            }
                            invList.add(inv);
                        }
                        if(invList.size()>0)
                            update invList;
                    } 
                }
                
            }catch(Exception ex){
                createErrorLog.insertError('PickingOrder',ex.getMessage(),'Method -PickingPrintedOrderInBulk ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
                
            }
        //}
    }
    //added on 24-09-2019 for allocate user for mutiple oders
    public class BulkPickerWrap
    {
        @AuraEnabled
        public String oId;
        @AuraEnabled
        public String userId;
    }
    //added on 24-09-2019 for allocate user for mutiple oders
    @AuraEnabled
    public static void OrderBULKPickerAllocation(string oIdPickerIdMap)
    {
        /*if(
        CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            && CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'Id','sigmaerpdev__Allocated_User__c'}) 
             && CRUD_FLS_CheckUtility.checkReadPermission('User',new set<String>{'Id'}) 
                && CRUD_FLS_CheckUtility.checkFLS('Order',new set<String>{'sigmaerpdev__Allocated_User__c'})
        )
        {*/
            List<BulkPickerWrap> dSerialisedoIdPickerIdMap=(List<BulkPickerWrap>)System.JSON.deserialize(oIdPickerIdMap,List<BulkPickerWrap>.class);
            List<Order> oList=new List<Order>();
            for(BulkPickerWrap bpw:dSerialisedoIdPickerIdMap)
            {
            oList.add(new Order(Id=bpw.oId,Allocated_User__c=bpw.userId));
            }
            if(oList.size()>0)
            update oList;  
       // }
    }
    public class standOrderLineWrapper {
        @AuraEnabled
        public OrderItem orderLineWrap{get;set;} 
        @AuraEnabled
        public List<standOrderIlpliWrapper> wrapperIlpli;   
    }
    
    public class standOrderIlpliWrapper{
        @AuraEnabled
        public Id LocationId;
        @AuraEnabled
        public string Location;
        @AuraEnabled
        public string SerialNo;
        @AuraEnabled
        public string Lot;
        @AuraEnabled
        public Date ReceivedDate;
        @AuraEnabled
        public Decimal AvailableQuantity;
        @AuraEnabled
        public Decimal EnterQuantity;
        
        
        public standOrderIlpliWrapper(string Location,string SerialNo,string Lot,Date ReceivedDate,Decimal AvailableQuantity,Decimal EnterQuantity)
        {
            this.Location = Location;
            this.SerialNo = SerialNo;
            this.Lot = Lot;
            this.ReceivedDate = ReceivedDate;
            this.AvailableQuantity = AvailableQuantity;
            this.EnterQuantity = EnterQuantity;
        }
    }  
    
    @AuraEnabled
    public static List<standOrderLineWrapper> getIlpli1(List<String> soIds)
    {
        List<standOrderLineWrapper>listOfstandOrderLineWrapper=new List<standOrderLineWrapper>();
        return listOfstandOrderLineWrapper;
    }   
    
    @AuraEnabled
    public static Boolean allocation(Boolean isAllocationInPicking)
    {
         /* if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c'})
        )
        {*/
            Order_Usage__c ou=[select Allocation_in_Sales_Order__c,Allocation_in_Picking__c,Auto_Allocate_in_picking__c,Sigma_order__c,Standard_object__c  from Order_Usage__c limit 1];
            
        //}
        return false;

    }
    @AuraEnabled
    public static Boolean getOrderUsage(Boolean autoAllocationInpicking)
    {
        /* if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c'})
        )
        {*/
            Order_Usage__c ou=[select Allocation_in_Sales_Order__c,Allocation_in_Picking__c,Auto_Allocate_in_picking__c,Sigma_order__c,Standard_object__c  from Order_Usage__c limit 1];
            
        //}
        return false;
      
    }
    @AuraEnabled
    public static String soPickerAllocation(String soID,String userId)
    {
         /*   if(
             CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
             && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            && CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'Id','sigmaerpdev__Allocated_User__c'}) 
               && CRUD_FLS_CheckUtility.checkFLS('Order',new set<String>{'sigmaerpdev__Allocated_User__c'})
                      && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{'sigmaerpdev__Order_Product__c','sigmaerpdev__Order_Product__r.OrderId','sigmaerpdev__Status__c'})
        )
        {*/
             List<Inventory_Allocation__c> iaList=[select Order_Product__c,Status__c from Inventory_Allocation__c where Status__c='Picking In Progress' AND Order_Product__r.OrderId=:soID];
        if(iaList.size()>0)
            return 'Picking In Progress';
        else{
            Order stdo=new Order();
            stdo.id=soID;
            stdo.Allocated_User__c=userId;
            update stdo;
            
        }
            
        //}
        return 'success';
        
       
    }
    
    public class standOrdersListInPickingScreeen
    {
        @AuraEnabled
        public Id logedInUserId{get;set;}
        @AuraEnabled
        public Boolean isSystemAdmin{get;set;}
        @AuraEnabled
        public String allocatedUserId{get;set;}
        @AuraEnabled
        public String allocatedUserName{get;set;}
        @AuraEnabled
        public List<user> users{get;set;}
        @AuraEnabled
        public Order standOrder{get;set;} 
        @AuraEnabled
        public String pickedSattus{get;set;}
        @AuraEnabled
        public String PickedUser{get;set;}
        @AuraEnabled
        public Decimal totalRowCount{get;set;}
    }
    public class StandardOrderListInPickingScreeenPagination
    {
            @AuraEnabled
            public Integer pageSize { get;set; }
            @AuraEnabled
            public Integer page { get;set; }
            @AuraEnabled
            public Integer total { get;set; }
            @AuraEnabled
            public List<standOrdersListInPickingScreeen> standardorderlistPickScreen { get;set; }
    
    }
    @AuraEnabled
    public static StandardOrderListInPickingScreeenPagination fetchSOData2(String sortField,String ascDesc,String soId,String tabSelected,Integer numberOfRecordsToDisplay,Integer pageNumber)
    {
         StandardOrderListInPickingScreeenPagination pickingScreenDataPagination=new StandardOrderListInPickingScreeenPagination();
       
                List<standOrdersListInPickingScreeen> pickingScreenData=new List<standOrdersListInPickingScreeen>();
         /*       if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('Profile',new Set<String>{'Id','Name'})  
            && CRUD_FLS_CheckUtility.checkReadPermission('User',new Set<String>{'Id','Name','UserRole.Name','Username','IsActive','Profile.Name'})  
                && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Commynity__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Commynity__c',new Set<String>{'Id','Name','sigmaerpdev__Retailer_Community_Plus_User__c','sigmaerpdev__Retailer_Profile__c','sigmaerpdev__SigmaVendor_Profile__c','sigmaerpdev__Vendor_Community_Plus_User__c'})  
            && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')    
            && CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'Id','OrderNumber','AccountId','Account.name','sigmaerpdev__Customer_Type__c','sigmaerpdev__Delivary_Date__c','Status','sigmaerpdev__TotalAmount__c','sigmaerpdev__Total_product_Price__c','sigmaerpdev__Allocated_User__c','sigmaerpdev__Allocated_User__r.name','sigmaerpdev__Orders_Status__c','sigmaerpdev__No_Picking_Package_Shipment_Required__c'}) 
              && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new set<String>{'Id','sigmaerpdev__Inventory_Status__c'})  
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Allocation__c','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'Id','Name','OrderId','sigmaerpdev__Order_Status__c','sigmaerpdev__Inventory_Status__c','sigmaerpdev__In_Progress_In_Package__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{'id','name','sigmaerpdev__Order_Product__c','sigmaerpdev__Status__c'})
        )
        {*/
            Default_Parameters__c dp=[select id,Inventory_Status__c from Default_Parameters__c limit 1];
            if(dp.Inventory_Status__c!='Reserve')
            {
                return null;
            }
            Order_Usage__c orderusage=[select Allocation_in_Sales_Order__c,Allocation_in_Picking__c,Auto_Allocate_in_picking__c,Sigma_order__c,Standard_object__c,Allocation__c  from Order_Usage__c Limit 1];
            Id profileId = userinfo.getProfileId();
            string profileName=[select id,Name from profile where id = :profileId].Name;
            Id logedInUserId= [select id,Name,UserRole.Name from User where id =: userInfo.getUserId()].id;
            String userRole= [select id,Name,UserRole.Name from User where id =: userInfo.getUserId()].UserRole.Name;
            String userId;
            boolean isSystemAdmin=false;
            List<user> users=new List<user>();
            SET<String> Profiname = new SET<String>();
            List<Commynity__c>  CustSet= new List<Commynity__c>();
            CustSet = [select Id,Retailer_Community_Plus_User__c,Vendor_Community_Plus_User__c,SigmaVendor_Profile__c,Retailer_Profile__c  from Commynity__c limit 1];
            if(CustSet.size() > 0)
            {
                for(Commynity__c cust : CustSet)
                {
                    Profiname.add(cust.Retailer_Community_Plus_User__c);
                    Profiname.add(cust.Vendor_Community_Plus_User__c);
                    Profiname.add(cust.SigmaVendor_Profile__c);
                    Profiname.add(cust.Retailer_Profile__c);
                }
            }
            
            if(profileName=='System Administrator' || userRole=='Warehouse Manager'|| userRole=='Warehouse user')
            {
                isSystemAdmin=true;       
                try{
                    users=[select id,name,Username from user where IsActive=true  AND Profile.Name NOT IN : Profiname ];
                    
                }
                catch(Exception e)
                {      
                }
            }
            else
                userId=userinfo.getUserId();
            if(tabSelected=='NotPicked')
                tabSelected='';
            if(tabSelected=='PickingInProgress')
                tabSelected='Picking In Progress';
            
            String soIdString='(';
            if(tabSelected=='')
            {
                // added AND sigmaerpdev__In_Progress_In_Package__c=false on 23-04-2020 to restrict order in picking  once we did package with in progress  status
                for(OrderItem oitem:[select OrderId from OrderItem where Inventory_Status__c!='Allocated' and id in (select Order_Product__c from Inventory_Allocation__c where Status__c='') and 
                                    Order_Status__c='Order Confirmed' AND In_Progress_In_Package__c=false])
                {
                    soIdString+='\''+oitem.OrderId+'\',';
                }   
            }
            else{
                // added AND sigmaerpdev__In_Progress_In_Package__c=false on 23-04-2020 to restrict order in picking  once we did package with in progress  status              
                for(OrderItem oitem:[select OrderId from OrderItem where Inventory_Status__c!='Allocated' and id in (select Order_Product__c from Inventory_Allocation__c where Status__c =: tabSelected ) and 
                                    Order_Status__c='Order Confirmed' AND In_Progress_In_Package__c=false])
                {
                    soIdString+='\''+oitem.OrderId+'\',';
                    System.debug('inside else ::'+oitem.OrderId);
                }
            }
            soIdString=soIdString.removeEnd(',');
            soIdString+=')';
            
            String queryString='select id,OrderNumber,AccountId,Account.name,Customer_Type__c,Delivary_Date__c,Status,TotalAmount__c,Total_product_Price__c,Allocated_User__c,Allocated_User__r.name from Order where Orders_Status__c=\'Order Confirmed\' and No_Picking_Package_Shipment_Required__c=false'; //sigmaerpdev__Customer_Type__c=\'Cash Customer\' and and  (sigmaerpdev__Due_Amount__c!=0.00)    //And (sigmaerpdev__Customer_Type__c=\'Cash Customer\'  and sigmaerpdev__Due_Amount__c!=0.00) OR (sigmaerpdev__Customer_Type__c=\'Credit Customer\' )  OR  (sigmaerpdev__Customer_Type__c=null)
            String querySize = 'select COUNT(Id) countIds from Order where Orders_Status__c=\'Order Confirmed\' ';
            
            if(soIdString!='()')
            {
                queryString += ' AND id in '+soIdString;
                querySize += ' AND id in '+soIdString;
            }
            else
            {
                queryString += ' AND id =null';
                querySize += ' AND id =null';
            }   
            if(userId!=null)
            {
                queryString += ' AND Allocated_User__c=\''+userId+'\'';
                querySize += ' AND Allocated_User__c=\''+userId+'\'';
            }
            if(String.isNotEmpty(soId) || String.isNotBlank(soId))
            {
                queryString += ' AND Id=\''+soId+'\'';
                querySize += ' AND Id=\''+soId+'\'';
            }
            if(String.isNotEmpty(sortField) || String.isNotBlank(sortField))
            {
                queryString += ' order by '+sortField+' '+ascDesc;
            }
            else
            {
                queryString += ' order by name desc';
            }
            //queryString += ' Limit '+numberOfRecordsToDisplay;
            
            
            Integer pageSize = 10;
                Integer offset = ((Integer)pageNumber - 1) * pageSize;
                pickingScreenDataPagination.pageSize=pageSize;
                pickingScreenDataPagination.page= (Integer) pageNumber;
                decimal numOfRows=0;
            AggregateResult recordCount = Database.query(querySize);
            numOfRows=(Integer)recordCount.get('countIds');
                pickingScreenDataPagination.total= (Integer)recordCount.get('countIds');
                System.debug('offset'+offset);
                 if(String.isNotEmpty(soId) || String.isNotBlank(soId))
                {
                    queryString += ' Limit '+pageSize; 
                }
                else{
                    queryString += ' Limit '+pageSize+' offset '+offset;
                }
                System.debug('queryString>>>>'+queryString);
            
            List<Order> oList = Database.query(queryString);
             System.debug('oList>>>>'+oList);
            
            for(Order o:oList)
            {
                standOrdersListInPickingScreeen indpickingScreenData=new standOrdersListInPickingScreeen();
                if(isSystemAdmin)
                {
                    indpickingScreenData.users=users;
                    indpickingScreenData.isSystemAdmin=true;
                }
                indpickingScreenData.logedInUserId=logedInUserId;
                indpickingScreenData.totalRowCount=numOfRows;
                indpickingScreenData.allocatedUserId=o.Allocated_User__c;
                indpickingScreenData.allocatedUserName=o.Allocated_User__r.Name;
                indpickingScreenData.PickedUser=o.Allocated_User__c;
                indpickingScreenData.standOrder=o;
                indpickingScreenData.pickedSattus=tabSelected==''? 'Not Picked':tabSelected;
                pickingScreenData.add(indpickingScreenData);
            } 
            pickingScreenDataPagination.standardorderlistPickScreen=pickingScreenData;
        //}
        return pickingScreenDataPagination; 
    }
    
    @AuraEnabled
    public static List<standOrdersListInPickingScreeen> fetchSOData(String sortField,String ascDesc,String soId,String tabSelected,Integer numberOfRecordsToDisplay)
    {
                List<standOrdersListInPickingScreeen> pickingScreenData=new List<standOrdersListInPickingScreeen>();
         /*       if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('Profile',new Set<String>{'Id','Name'})  
            && CRUD_FLS_CheckUtility.checkReadPermission('User',new Set<String>{'Id','Name','UserRole.Name','Username','IsActive','Profile.Name'})  
                && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Commynity__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Commynity__c',new Set<String>{'Id','Name','sigmaerpdev__Retailer_Community_Plus_User__c','sigmaerpdev__Retailer_Profile__c','sigmaerpdev__SigmaVendor_Profile__c','sigmaerpdev__Vendor_Community_Plus_User__c'})  
            && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')    
            && CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'Id','OrderNumber','AccountId','Account.name','sigmaerpdev__Customer_Type__c','sigmaerpdev__Delivary_Date__c','Status','sigmaerpdev__TotalAmount__c','sigmaerpdev__Total_product_Price__c','sigmaerpdev__Allocated_User__c','sigmaerpdev__Allocated_User__r.name','sigmaerpdev__Orders_Status__c','sigmaerpdev__No_Picking_Package_Shipment_Required__c'}) 
              && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new set<String>{'Id','sigmaerpdev__Inventory_Status__c'})  
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Allocation__c','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'Id','Name','OrderId','sigmaerpdev__Order_Status__c','sigmaerpdev__Inventory_Status__c','sigmaerpdev__In_Progress_In_Package__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{'id','name','sigmaerpdev__Order_Product__c','sigmaerpdev__Status__c'})
        )
        {*/
            Default_Parameters__c dp=[select id,Inventory_Status__c from Default_Parameters__c limit 1];
            if(dp.Inventory_Status__c!='Reserve')
            {
                return null;
            }
            Order_Usage__c orderusage=[select Allocation_in_Sales_Order__c,Allocation_in_Picking__c,Auto_Allocate_in_picking__c,Sigma_order__c,Standard_object__c,Allocation__c  from Order_Usage__c Limit 1];
            Id profileId = userinfo.getProfileId();
            string profileName=[select id,Name from profile where id = :profileId].Name;
            Id logedInUserId= [select id,Name,UserRole.Name from User where id =: userInfo.getUserId()].id;
            String userRole= [select id,Name,UserRole.Name from User where id =: userInfo.getUserId()].UserRole.Name;
            String userId;
            boolean isSystemAdmin=false;
            List<user> users=new List<user>();
            SET<String> Profiname = new SET<String>();
            List<Commynity__c>  CustSet= new List<Commynity__c>();
            CustSet = [select Id,Retailer_Community_Plus_User__c,Vendor_Community_Plus_User__c,SigmaVendor_Profile__c,Retailer_Profile__c  from Commynity__c limit 1];
            if(CustSet.size() > 0)
            {
                for(Commynity__c cust : CustSet)
                {
                    Profiname.add(cust.Retailer_Community_Plus_User__c);
                    Profiname.add(cust.Vendor_Community_Plus_User__c);
                    Profiname.add(cust.SigmaVendor_Profile__c);
                    Profiname.add(cust.Retailer_Profile__c);
                }
            }
            
            if(profileName=='System Administrator' || userRole=='Warehouse Manager'|| userRole=='Warehouse user')
            {
                isSystemAdmin=true;       
                try{
                    users=[select id,name,Username from user where IsActive=true  AND Profile.Name NOT IN : Profiname ];
                    
                }
                catch(Exception e)
                {      
                }
            }
            else
                userId=userinfo.getUserId();
            if(tabSelected=='NotPicked')
                tabSelected='';
            if(tabSelected=='PickingInProgress')
                tabSelected='Picking In Progress';
            
            String soIdString='(';
            if(tabSelected=='')
            {
                // added AND sigmaerpdev__In_Progress_In_Package__c=false on 23-04-2020 to restrict order in picking  once we did package with in progress  status
                for(OrderItem oitem:[select OrderId from OrderItem where Inventory_Status__c!='Allocated' and id in (select Order_Product__c from Inventory_Allocation__c where Status__c='') and 
                                    Order_Status__c='Order Confirmed' AND In_Progress_In_Package__c=false])
                {
                    soIdString+='\''+oitem.OrderId+'\',';
                }   
            }
            else{
                // added AND sigmaerpdev__In_Progress_In_Package__c=false on 23-04-2020 to restrict order in picking  once we did package with in progress  status              
                for(OrderItem oitem:[select OrderId from OrderItem where Inventory_Status__c!='Allocated' and id in (select Order_Product__c from Inventory_Allocation__c where Status__c =: tabSelected ) and 
                                    Order_Status__c='Order Confirmed' AND In_Progress_In_Package__c=false])
                {
                    soIdString+='\''+oitem.OrderId+'\',';
                    System.debug('inside else ::'+oitem.OrderId);
                }
            }
            soIdString=soIdString.removeEnd(',');
            soIdString+=')';
            
            String queryString='select id,OrderNumber,AccountId,Account.name,Customer_Type__c,Delivary_Date__c,Status,TotalAmount__c,Total_product_Price__c,Allocated_User__c,Allocated_User__r.name from Order where Orders_Status__c=\'Order Confirmed\' and No_Picking_Package_Shipment_Required__c=false'; //sigmaerpdev__Customer_Type__c=\'Cash Customer\' and and  (sigmaerpdev__Due_Amount__c!=0.00)    //And (sigmaerpdev__Customer_Type__c=\'Cash Customer\'  and sigmaerpdev__Due_Amount__c!=0.00) OR (sigmaerpdev__Customer_Type__c=\'Credit Customer\' )  OR  (sigmaerpdev__Customer_Type__c=null)
            String querySize = 'select COUNT(Id) countIds from Order where Orders_Status__c=\'Order Confirmed\' ';
            
            if(soIdString!='()')
            {
                queryString += ' AND id in '+soIdString;
                querySize += ' AND id in '+soIdString;
            }
            else
            {
                queryString += ' AND id =null';
                querySize += ' AND id =null';
            }   
            if(userId!=null)
            {
                queryString += ' AND Allocated_User__c=\''+userId+'\'';
                querySize += ' AND Allocated_User__c=\''+userId+'\'';
            }
            if(String.isNotEmpty(soId) || String.isNotBlank(soId))
            {
                queryString += ' AND Id=\''+soId+'\'';
                querySize += ' AND Id=\''+soId+'\'';
            }
            if(String.isNotEmpty(sortField) || String.isNotBlank(sortField))
            {
                queryString += ' order by '+sortField+' '+ascDesc;
            }
            else
            {
                queryString += ' order by name desc';
            }
            queryString += ' Limit '+numberOfRecordsToDisplay;
            List<Order> oList = Database.query(queryString);
            decimal numOfRows=0;
            AggregateResult recordCount = Database.query(querySize);
            numOfRows=(Integer)recordCount.get('countIds');
            for(Order o:oList)
            {
                standOrdersListInPickingScreeen indpickingScreenData=new standOrdersListInPickingScreeen();
                if(isSystemAdmin)
                {
                    indpickingScreenData.users=users;
                    indpickingScreenData.isSystemAdmin=true;
                }
                indpickingScreenData.logedInUserId=logedInUserId;
                indpickingScreenData.totalRowCount=numOfRows;
                indpickingScreenData.allocatedUserId=o.Allocated_User__c;
                indpickingScreenData.allocatedUserName=o.Allocated_User__r.Name;
                indpickingScreenData.PickedUser=o.Allocated_User__c;
                indpickingScreenData.standOrder=o;
                indpickingScreenData.pickedSattus=tabSelected==''? 'Not Picked':tabSelected;
                pickingScreenData.add(indpickingScreenData);
            }   
        //}
        return pickingScreenData; 
    }
    
    @AuraEnabled
    public static PickingParentWrap fetchPickingData(String soID,String callingFrom)
    {
               PickingParentWrap ppw=new PickingParentWrap();
        /*    if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Picking_Slip__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
           // && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Picking_Slip__c',new Set<String>{'sigmaerpdev__Order__c','sigmaerpdev__Status__c'})     
            && CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'Id'}) 
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Picking_Slip__c',new Set<String>{'Id','Name','sigmaerpdev__Start_Time__c','sigmaerpdev__Order__c'})  
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'Id','Name','OrderId','Product2Id','Product2.Name','Product2.sigmaerpdev__Attribute_Type__c','Product2.ProductCode','Product2.sigmaerpdev__Product_Bar_Code__c','sigmaerpdev__Net_Quantity__c','Quantity','sigmaerpdev__Order_Status__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{'id','name','sigmaerpdev__Order_Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Status__c','sigmaerpdev__Picked_Quantity__c','sigmaerpdev__ILPLI__c','sigmaerpdev__Picking__c','sigmaerpdev__ILPLI__r.sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Name','sigmaerpdev__ILPLI__r.sigmaerpdev__Bin__c','sigmaerpdev__ILPLI__r.sigmaerpdev__Bin__r.Name','sigmaerpdev__ILPLI__r.sigmaerpdev__Bin__r.sigmaerpdev__zone__c','sigmaerpdev__ILPLI__r.sigmaerpdev__Bin__r.sigmaerpdev__Bar_Code__c','sigmaerpdev__ILPLI__r.sigmaerpdev__Bin__r.sigmaerpdev__zone__r.Name'})
        )
        {*/
            Order_Usage__c orderusage=[select Allocation_in_Sales_Order__c,Allocation_in_Picking__c from Order_Usage__c Limit 1];
            List<OrderItem> oitemList;
            List<Inventory_Allocation__c> ilList;
            List<ID> ids=new List<ID>();
            if(callingFrom=='Printed')
            {
                //added on 03-10-2019  for whare house  bin and zone fields
                oitemList=[select id,OrderId,Product2Id,Product2.Name,Product2.Attribute_Type__c,Product2.ProductCode,Product2.Product_Bar_Code__c,Quantity,Net_Quantity__c,
                           (select id,name,
                            ILPLI__c,Status__c,Picked_Quantity__c,Quantity__c,
                            ILPLI__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.name 
                            ,ILPLI__r.Bin__c,ILPLI__r.Bin__r.Name,ILPLI__r.Bin__r.zone__c,ILPLI__r.Bin__r.zone__r.Name,ILPLI__r.Bin__r.Bar_Code__c,ILPLI__r.Product__r.Attribute_Type__c,ILPLI__r.Product__r.Name,ILPLI__r.Product__r.Product_Bar_Code__c,ILPLI__r.Product__c  
                            from Inventory_Allocations__r) 
                           from OrderItem where OrderId=:soID AND Order_Status__c='Order Confirmed' and id in (select Order_Product__c from Inventory_Allocation__c where Status__c='Printed')];
                
            }
            else if((callingFrom=='NavigateToPicking' || callingFrom=='NewPicking'))
            {
                //added on 03-10-2019  for whare house  bin and zone fields 
                oitemList=[select id,OrderId,Product2Id,Product2.Name,Product2.Attribute_Type__c,Product2.ProductCode,Product2.Product_Bar_Code__c,Quantity,Net_Quantity__c,
                           (select id,name,
                            ILPLI__c,Status__c,Picked_Quantity__c,Quantity__c,
                            ILPLI__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.name,ILPLI__r.Bin__c,ILPLI__r.Bin__r.Name,ILPLI__r.Bin__r.zone__c,ILPLI__r.Bin__r.zone__r.Name,ILPLI__r.Bin__r.Bar_Code__c,ILPLI__r.Product__c,ILPLI__r.Product__r.Attribute_Type__c,ILPLI__r.Product__r.Name,ILPLI__r.Product__r.Product_Bar_Code__c from Inventory_Allocations__r) 
                           from OrderItem where OrderId=:soID AND Order_Status__c='Order Confirmed' and id in (select Order_Product__c from Inventory_Allocation__c where Status__c=null  OR  Status__c='Picking In Progress'  )];
            }
            List<PickingDuplicateDataWrap> pddwList=new List<PickingDuplicateDataWrap>();
            
            Map<Id,Map<Id,Map<Id,PickingDuplicateDataWrap>>> prodIDLocIdBinIdMap=new Map<Id,Map<Id,Map<Id,PickingDuplicateDataWrap>>>();
            for(OrderItem oitem:oitemList)
            {
                ppw.soId=oitem.OrderId;
                
                Boolean duplicateDataFlag=false;
                for(Inventory_Allocation__c ia:oitem.Inventory_Allocations__r)
                {
                    Id lodId=ia.ILPLI__r.Inventory_Location_Product__r.Inventory_Location__r.Location__c;
                    String lodName=ia.ILPLI__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.name;
                    //added on 03-10-2019  for whare house  bin and zone fields
                    Id zoneId=ia.ILPLI__r.Bin__r.zone__c;
                    String zoneName=ia.ILPLI__r.Bin__r.zone__r.Name;
                    Id binId=ia.ILPLI__r.Bin__c;
                    String binName=ia.ILPLI__r.Bin__r.Name; 
                    PickingDuplicateDataWrap pddw=new PickingDuplicateDataWrap();
                    pddw.solId=oitem.Id;
                    
                    if(prodIDLocIdBinIdMap.containsKey(oitem.Product2Id))
                    {
                        if(prodIDLocIdBinIdMap.get(oitem.Product2Id).containsKey(lodId))
                        {
                            pddw.locId=lodId;
                            pddw.locName=lodName;
                            //added on 03-10-2019  for whare house  bin and zone fields
                            pddw.zoneId=zoneId;
                            pddw.zoneName=zoneName;
                            pddw.binId=binId;
                            pddw.binName=binName;
                            pddw.binBarCode=ia.ILPLI__r.Bin__r.Bar_Code__c  ;
                            pddw.prodId=oitem.Product2Id;
                            pddw.prodName=oitem.Product2.name;
                            pddw.prodCode=oitem.Product2.Product_Bar_Code__c;
                            pddw.reqQty=ia.Quantity__c;
                            pddw.pickedQty=0;
                            pddw.picked=false;
                            pddw.iaData.add(ia);
                            pddwList.add(pddw);
                            prodIDLocIdBinIdMap.put(oitem.Product2Id, new Map<Id,Map<Id,PickingDuplicateDataWrap>>{lodId =>new Map<Id,PickingDuplicateDataWrap>{lodId=>pddw}});
                        } 
                        else{
                            pddw.locId=lodId;
                            pddw.locName=lodName;
                            //added on 03-10-2019  for whare house  bin and zone fields
                            pddw.zoneId=zoneId;
                            pddw.zoneName=zoneName;
                            pddw.binId=binId;
                            pddw.binName=binName;
                            pddw.binBarCode=ia.ILPLI__r.Bin__r.Bar_Code__c  ;
                            pddw.prodId=oitem.Product2Id;
                            pddw.prodName=oitem.Product2.name;
                            pddw.prodCode=oitem.Product2.Product_Bar_Code__c;
                            pddw.reqQty=ia.Quantity__c;
                            pddw.pickedQty=0;
                            pddw.picked=false;
                            pddw.iaData.add(ia);
                            pddwList.add(pddw);
                            prodIDLocIdBinIdMap.put(oitem.Product2Id, new Map<Id, Map<Id,PickingDuplicateDataWrap>>{lodId =>new Map<Id,PickingDuplicateDataWrap>{lodId=>pddw}});
                        }   
                    } 
                    else{
                        pddw.locId=lodId;
                        pddw.locName=lodName;
                        //added on 09-09-2019  for whare house  bin and zone fields
                        pddw.zoneId=zoneId;
                        pddw.zoneName=zoneName;
                        pddw.binId=binId;
                        pddw.binName=binName;
                        pddw.binBarCode=ia.ILPLI__r.Bin__r.Bar_Code__c  ;
                        pddw.prodId=oitem.Product2Id;
                        pddw.prodName=oitem.Product2.name;
                        pddw.prodCode=oitem.Product2.Product_Bar_Code__c;
                        pddw.reqQty=ia.Quantity__c;
                        pddw.pickedQty=0;
                        pddw.picked=false;
                        pddw.iaData.add(ia);
                        pddwList.add(pddw);
                        prodIDLocIdBinIdMap.put(oitem.Product2Id, new Map<Id, Map<Id,PickingDuplicateDataWrap>>{lodId =>new Map<Id,PickingDuplicateDataWrap>{lodId=>pddw}});
                    }
                }
            }
            Picking_Slip__c pick=new Picking_Slip__c();
            pick.Order__c=ppw.soId;
            pick.Start_Time__c=datetime.now();
            ppw.pickingValues=pick;
            ppw.PickingDuplicateDataWrap=pddwList;
            
        //}

        return ppw;
    }
    
    public class PickingParentWrap
    {
        @AuraEnabled
        public Boolean isScannerUsed{get;set;}
        @AuraEnabled
        public Id soId{get;set;}
        @AuraEnabled
        public Picking_Slip__c pickingValues{get;set;}
        @AuraEnabled
        public List<PickingDuplicateDataWrap> PickingDuplicateDataWrap{get;set;}        
    }
    public class PickingDuplicateDataWrap
    {
        @AuraEnabled
        public String solId{get;set;}
        @AuraEnabled
        public String locId{get;set;}
        @AuraEnabled
        public String locName{get;set;}
        //added on 03-10-2019
        @AuraEnabled
        public String zoneId{get;set;}
        @AuraEnabled
        public String zoneName{get;set;}
        @AuraEnabled
        public String binId{get;set;}
        @AuraEnabled
        public String binName{get;set;}
        @AuraEnabled
        public String binBarCode{get;set;}
        @AuraEnabled
        public String prodId{get;set;}
        @AuraEnabled
        public String prodName{get;set;}
        @AuraEnabled
        public Decimal reqQty{get;set;}
        @AuraEnabled
        public String prodCode{get;set;}
        @AuraEnabled
        public Decimal pickedQty{get;set;}
        @AuraEnabled
        public Decimal totalPickedQty{get;set;}
        @AuraEnabled
        public Boolean picked{get;set;}
        @AuraEnabled
        public Boolean isAltPicked=false;
        @AuraEnabled
        public Boolean hasAltPick=false;
        @AuraEnabled
        public List<Inventory_Allocation__c> iaData=new List<Inventory_Allocation__c>();
        @AuraEnabled
        public List<PickingOuterDataWrap> pickingDulDataList{get;set;}
    }
    public class PickingOuterDataWrap
    {
        @AuraEnabled
        public String locId{get;set;}
        @AuraEnabled
        public String locName{get;set;}
        @AuraEnabled
        public String prodId{get;set;}
        @AuraEnabled
        public String prodName{get;set;}
        @AuraEnabled
        public String prodCode{get;set;}
        @AuraEnabled
        public Decimal reqQty{get;set;}
        @AuraEnabled
        public Decimal totalPickedQty{get;set;}
        @AuraEnabled
        public boolean picked{get;set;}
    }  
    /********************submit**********************************************************************************/
    public class PickingSOLWrap
    {
        @AuraEnabled
        public String proId{get;set;}
        @AuraEnabled
        public String prodName{get;set;}
        @AuraEnabled
        public String AttributeType{get;set;}
        @AuraEnabled
        public String prodCode{get;set;}
        @AuraEnabled
        public Decimal ReservedQuant{get;set;}
        @AuraEnabled
        public Decimal totalPickQty{get;set;}
        @AuraEnabled
        public String soID{get;set;}
        @AuraEnabled
        public String solID{get;set;}
        @AuraEnabled
        public List<PickingIAWrap> piawzlist{get;set;}
    }
    public class PickingIAWrap
    {
        @AuraEnabled
        public Inventory_Allocation__c iaData{get;set;}
        @AuraEnabled
        public Id ilpliId{get;set;}
        @AuraEnabled
        public Decimal pickedQty{get;set;}
        @AuraEnabled
        public String comment{get;set;}
        @AuraEnabled
        public String status{get;set;}
        @AuraEnabled
        public Boolean isAlternatePicked=false;
        @AuraEnabled
        public Boolean hasAlternatePick=false;
    }
    public class responseWrapForPackShip
    {
        @auraEnabled
        public string custName;
        @auraEnabled
        public string soName;
        @auraEnabled
        public Package__c packData;
        @auraEnabled
        public List<PackageCtrl.PackageProductWrap> ppData;
    }
    public class PickingOuterWrap
    {
        @AuraEnabled
        public Boolean isScannerUsed{get;set;}
        @AuraEnabled
        public Package__c pickingData{get;set;}
        @AuraEnabled
        public List<PickingSOLWrap> pickingSOLWrapList{get;set;}        
    }
    public class responseWrap
    {
        @auraEnabled
        public string message;
        @auraEnabled
        public string data;
        @auraEnabled
        public PickingOuterWrap pickedData;
        @auraEnabled
        public responseWrapForPackShip respPackData;
    }
    @AuraEnabled
    public static responseWrapForPackShip apexProceedToPackage(String soID)
    {
            responseWrapForPackShip resp=new responseWrapForPackShip();
        /*    if(
             CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
                && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
                    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'Id'}) 
            && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'Id','Name','OrderId','Order.OrderNumber','Order.AccountId','Order.Account.name','Product2Id','Product2.Name','sigmaerpdev__Location__c','sigmaerpdev__Net_Quantity__c','Quantity','sigmaerpdev__Order_Status__c','sigmaerpdev__Remaining_Qty_To_Package__c','sigmaerpdev__In_Progress_In_Package__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{'id','name','sigmaerpdev__Order_Product__c','sigmaerpdev__Status__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new set<String>{'id','name','sigmaerpdev__Product__c','sigmaerpdev__Customer__c','sigmaerpdev__Status__c','sigmaerpdev__PackagedDate__c','sigmaerpdev__Location__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new set<String>{'id','name','sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Status__c','sigmaerpdev__Order__c','sigmaerpdev__Order_Product__c'})
        )
        {*/
            //added on 04-10-2019 and id in (select Order_Product__c from Inventory_Allocation__c where Status__c =: 'Picked' )
            List<OrderItem> oitemList=
                [select id,OrderId,Order.OrderNumber,Order.AccountId,Order.Account.name,Product2Id,Product2.Name,Remaining_Qty_To_Package__c,Quantity,Net_Quantity__c,Location__c  from OrderItem where ( Order_Status__c ='Order Confirmed' )  and (  OrderId=:soID) and id in (select Order_Product__c from Inventory_Allocation__c where Status__c =: 'Picked' ) AND In_Progress_In_Package__c=false];        
            List<PackageCtrl.PackageProductWrap> ppWrapList=new List<PackageCtrl.PackageProductWrap>();
            Package__c pack=new Package__c();
            pack.Customer__c=oitemList[0].Order.AccountId; 
            pack.Status__c='Ready';
            pack.PackagedDate__c=System.Today(); 
            pack.Location__c=oitemList[0].Location__c;
            for(OrderItem indStdOL:oitemList)
            {
                PackagedProducts__c pp=new PackagedProducts__c();
                pp.Product__c=indStdOL.Product2Id;
                pp.Quantity__c=indStdOL.Remaining_Qty_To_Package__c;
                pp.Status__c='Ready';
                pp.Order__c=indStdOL.OrderId;
                pp.Order_Product__c=indStdOL.id;
                ppWrapList.add(new PackageCtrl.PackageProductWrap(pp,indStdOL.Product2.name,indStdOL.Remaining_Qty_To_Package__c,null,null,indStdOL,false));
            }
            resp.custName=oitemList[0].Order.Account.name;
            resp.soName=oitemList[0].Order.OrderNumber;
            resp.packData=pack;
            resp.ppData=ppWrapList;
            
        //}
        return resp;
    }
    
    @AuraEnabled 
    public static responseWrap sumbitPickedData(String pickedData,String solw)// String sow,List<Inventory_Location_Product_Line_Item__c> ilplis,Map<Id,Decimal> enteredQuantity
    {
           responseWrap rw = new responseWrap();
        /*        if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Picking_Slip__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Picking_Slip__c',new Set<String>{'sigmaerpdev__Status__c','sigmaerpdev__End_Time__c'})     
            && CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'Id','OrderNumber','AccountId','BillToContactId','sigmaerpdev__BillingPersonNew__c','sigmaerpdev__Payment_type__c','sigmaerpdev__Delivary_Date__c','sigmaerpdev__Discount__c','Status','sigmaerpdev__BillingStreet__c','sigmaerpdev__BillingCity__c','sigmaerpdev__BillingState__c','sigmaerpdev__BillingPostalCode__c','sigmaerpdev__BillingCountry__c','sigmaerpdev__Shipping_Street__c','sigmaerpdev__ShippingCity__c','sigmaerpdev__ShippingCountry__c','sigmaerpdev__ShippingPostalCode__c'}) 
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Picking_Slip__c',new Set<String>{'Id','Name','sigmaerpdev__End_Time__c','sigmaerpdev__Status__c'})  
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new Set<String>{'id','name','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__ProductCode__c','sigmaerpdev__Available_Qty__c','sigmaerpdev__Total_Available_Qty__c','sigmaerpdev__Delivered_Qty__c','sigmaerpdev__Comments__c','sigmaerpdev__Picked_Quantity__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'Id','sigmaerpdev__Picking_Slip__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{'id','name','sigmaerpdev__Order_Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Status__c','sigmaerpdev__Picked_Quantity__c','sigmaerpdev__ILPLI__c','sigmaerpdev__Picking__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new Set<String>{'sigmaerpdev__Reserved_Qty__c','sigmaerpdev__ProductCode__c','sigmaerpdev__Picked_Quantity__c','sigmaerpdev__Total_Available_Qty__c','sigmaerpdev__Available_Qty__c'})
            && CRUD_FLS_CheckUtility.checkFLS('OrderItem',new set<String>{'sigmaerpdev__Picking_Slip__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Allocation__c',new set<String>{'sigmaerpdev__Order_Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Status__c','sigmaerpdev__Picked_Quantity__c','sigmaerpdev__ILPLI__c','sigmaerpdev__Picking__c'})
        )
        {*/
                 Savepoint sp;
            try{
                sp = Database.setSavepoint();
                Order_Usage__c OrderType=[select Sigma_order__c,Standard_object__c,Allocation_in_Sales_Order__c,Allocation_in_Picking__c,Auto_Allocate_in_picking__c  from Order_Usage__c Limit 1]  ;   
                List<Inventory_Allocation__c> iaList=new List<Inventory_Allocation__c>();
                PickingParentWrap dSerialisedpickedData=(PickingParentWrap)System.JSON.deserialize(pickedData,PickingParentWrap.class);
                dSerialisedpickedData.pickingValues.Status__c='Picked';
                dSerialisedpickedData.pickingValues.End_Time__c=datetime.now();
                upsert dSerialisedpickedData.pickingValues;
                
                String pickid=dSerialisedpickedData.pickingValues.Id;
                map<id,OrderItem> olIdSolMap=new map<id,OrderItem>();
                Map<id,decimal> ILPLIIdQuantMap=new Map<Id,Decimal>();
                Map<id,decimal> ilpliIdQuantMapOfNeedsReview=new Map<Id,Decimal>();
                Map<id,decimal> newlyAddedILPLIIdQuantMap=new Map<Id,Decimal>();
                Map<id,decimal> prodIdQuantReduceInPIMap=new Map<Id,Decimal>();
                Set<Id> proid=new Set<Id>();
                
                
                
                List<OrderItem> deliveredSOlines=new List<OrderItem>();
                List<Order> standOrderRecord=new List<Order>();
                standOrderRecord=[select id,OrderNumber,AccountId,BillToContactId,BillingPersonNew__c,Payment_type__c,Delivary_Date__c,Discount__c,Status,
                                  BillingStreet__c,BillingCity__c,BillingState__c,BillingPostalCode__c,
                                  BillingCountry__c,Shipping_Street__c,ShippingCity__c,ShippingCountry__c,ShippingPostalCode__c
                                  from Order where id=: dSerialisedpickedData.soId];        
                for(PickingDuplicateDataWrap pddw:dSerialisedpickedData.PickingDuplicateDataWrap)
                {
                    proid.add(pddw.prodId);
                    for(Inventory_Allocation__c ia:pddw.iaData)
                    {
                        OrderItem ol=new OrderItem();
                        ol.Id=ia.Order_Product__c;
                        ol.Picking_Slip__c=dSerialisedpickedData.pickingValues.Id;
                        deliveredSOlines.add(ol);
                        olIdSolMap.put(ol.id,ol);
                        ia.Status__c='Picked';
                        ia.Picking__c=dSerialisedpickedData.pickingValues.id;
                        ia.Picked_Quantity__c=ia.Quantity__c;
                        ia.Order_Product__c=ol.id;
                        iaList.add(ia);
                        

                        if(ILPLIIdQuantMap.containskey(ia.ILPLI__c))
                            ILPLIIdQuantMap.put(ia.ILPLI__c,ILPLIIdQuantMap.get(ia.ILPLI__c)+ia.Picked_Quantity__c);
                        else
                            ILPLIIdQuantMap.put(ia.ILPLI__c,ia.Picked_Quantity__c);
                        if(prodIdQuantReduceInPIMap.containsKey(pddw.prodId))
                            prodIdQuantReduceInPIMap.put(pddw.prodId,prodIdQuantReduceInPIMap.get(pddw.prodId)+ia.Picked_Quantity__c);
                        else
                            prodIdQuantReduceInPIMap.put(pddw.prodId,ia.Picked_Quantity__c);
                    }
                }
                if(prodIdQuantReduceInPIMap.size()>0)
                {
                    List<Inventory__c> invList=new List<Inventory__c>();
                    for(Inventory__c inv:[select id,name,ProductCode__c,Picked_Quantity__c,Reserved_Qty__c,Total_Available_Qty__c,Available_Qty__c from Inventory__c where ProductCode__c in:prodIdQuantReduceInPIMap.keySet() ]){
                        if(inv.Picked_Quantity__c==null)
                            inv.Picked_Quantity__c=0;
                        inv.Picked_Quantity__c+=prodIdQuantReduceInPIMap.get(inv.ProductCode__c);
                        //added on 17-09-2019 to reduce Reserve Quantity from Product Inventory allocation in picking
                        inv.Reserved_Qty__c-=prodIdQuantReduceInPIMap.get(inv.ProductCode__c);//////////////
                        invList.add(inv);
                    }
                    if(invList.size()>0)
                        update invList;
                }
                if(olIdSolMap.values().size()>0){
                    update olIdSolMap.values();
                }
                if(iaList.size()>0){
                    upsert iaList;
                }
                if(ILPLIIdQuantMap.values().size()>0){
                    InventoryManagement.reduceWholeInventory(ILPLIIdQuantMap,'Avail_Reserve_Quantity');
                }
                upsert dSerialisedpickedData.pickingValues;
                rw.message = 'success';
                rw.data = 'Picked SuccessFully';
           
            }
            catch(Exception e)
            {
                createErrorLog.insertError('PickingOrder',e.getMessage(),'Method -sumbitPickedData ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                Database.rollback(sp);
                rw.message = 'error';
                rw.data = e.getMessage()+ ', At Line number '+e.getStackTraceString();
            }
        //}
             return rw;  
    }
    
    /** For creating shipment  */
    @AuraEnabled
    public static PickingParentWrap apexStartPicking(String pickingData,string soId)
    {
         PickingParentWrap dSerialisedpickedData=new PickingParentWrap();
        
        /*                if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Picking_Slip__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Picking_Slip__c',new Set<String>{'sigmaerpdev__Status__c','sigmaerpdev__Start_Time__c','sigmaerpdev__Order__c'})     
            && CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'Id','OrderNumber','AccountId','BillToContactId','sigmaerpdev__BillingPersonNew__c','sigmaerpdev__Payment_type__c','sigmaerpdev__Delivary_Date__c','sigmaerpdev__Discount__c','Status','sigmaerpdev__BillingStreet__c','sigmaerpdev__BillingCity__c','sigmaerpdev__BillingState__c','sigmaerpdev__BillingPostalCode__c','sigmaerpdev__BillingCountry__c','sigmaerpdev__Shipping_Street__c','sigmaerpdev__ShippingCity__c','sigmaerpdev__ShippingCountry__c','sigmaerpdev__ShippingPostalCode__c'}) 
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Picking_Slip__c',new Set<String>{'Id','Name','sigmaerpdev__End_Time__c','sigmaerpdev__Status__c'})  
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c','sigmaerpdev__Allocation__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{'id','name','sigmaerpdev__Order_Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Status__c','sigmaerpdev__Picked_Quantity__c','sigmaerpdev__ILPLI__c','sigmaerpdev__Picking__c'})
              && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Allocation__c',new set<String>{'sigmaerpdev__Status__c'})
       )
       {*/
           Order_Usage__c orderusage=[select Allocation_in_Sales_Order__c,Allocation_in_Picking__c,Auto_Allocate_in_picking__c,Sigma_order__c,Standard_object__c,Allocation__c from Order_Usage__c Limit 1];
         dSerialisedpickedData=(PickingParentWrap)System.JSON.deserialize(pickingData,PickingParentWrap.class);
        dSerialisedpickedData.pickingValues.Status__c='Picked';
        Picking_Slip__c pick=new Picking_Slip__c();
        pick.Start_Time__c=datetime.now();
        pick.Order__c=soId; 
        insert pick;
        dSerialisedpickedData.pickingValues=pick;
        List<Inventory_Allocation__c> iaList=new List<Inventory_Allocation__c>();
        for(PickingDuplicateDataWrap pddw:dSerialisedpickedData.PickingDuplicateDataWrap){
            for(Inventory_Allocation__c ia:pddw.iaData){
                ia.Status__c='Picking In Progress';
                iaList.add(ia);
            }
        }
        if(iaList.size()>0){
            update iaList;
        }
        try{
        }
        catch(Exception e){}
           
       //}
        return dSerialisedpickedData;
    }
    public class PrintPDFWrap
    {
        @AuraEnabled
        public String soName{get;set;}
        @AuraEnabled
        public String allocatedTo{get;set;}
        @AuraEnabled
        public List<PickingDuplicateDataWrap> PickingDuplicateDataWrap{get;set;}
        
    }
    @AuraEnabled
    public static List<PrintPDFWrap> fetchPrintPDFData(List<Id> soIdList,string selectedTab)
    {
        List<PrintPDFWrap> ppwlist=new List<PrintPDFWrap>();
        /*           if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')            
            && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
               && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')   
            && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'Id','Name','OrderId','sigmaerpdev__Order_Status__c','Order.sigmaerpdev__Allocated_User__c','Order.name','Product2Id','Product2.sigmaerpdev__Attribute_Type__c','Product2.ProductCode','Product2.sigmaerpdev__Product_Bar_Code__c','Product2.name','Quantity','sigmaerpdev__Net_Quantity__c'})       
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')                
            && CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'Id','OrderNumber','sigmaerpdev__IsPrinted__c'})
 && CRUD_FLS_CheckUtility.checkFLS('Order',new set<String>{'sigmaerpdev__IsPrinted__c'})                          
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c','sigmaerpdev__Allocation__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{'id','name','sigmaerpdev__ILPLI__c','sigmaerpdev__Picked_Quantity__c','sigmaerpdev__Quantity__c','sigmaerpdev__ILPLI__r.sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.name','sigmaerpdev__Status__c'})
              && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Allocation__c',new set<String>{'sigmaerpdev__Status__c'})
       )
       {   */     
            Order_Usage__c orderusage=[select Allocation_in_Sales_Order__c,Allocation_in_Picking__c,Auto_Allocate_in_picking__c,Sigma_order__c,Standard_object__c,Allocation__c from Order_Usage__c Limit 1]; 
            List<OrderItem> olList;
            if(selectedTab=='NotPicked')
            {
                olList=  [select id,OrderId,Order.Allocated_User__c,Order.name,Product2Id,Product2.Attribute_Type__c,Product2.ProductCode,Product2.Product_Bar_Code__c,Product2.name,Quantity,Net_Quantity__c,
                          (select id,name,
                           ILPLI__c,Picked_Quantity__c,Quantity__c,
                           ILPLI__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.name from Inventory_Allocations__r where Status__c='') 
                          from OrderItem where OrderId=:soIdList];                                                                                                   
            }
            else if(selectedTab=='Printed')
            { 
                olList=  [select id,OrderId,Order.Allocated_User__c,Order.name,Product2Id,Product2.Attribute_Type__c,Product2.ProductCode,Product2.Product_Bar_Code__c,Product2.name,Quantity,Net_Quantity__c,
                          (select id,name,
                           ILPLI__c,Status__c,Picked_Quantity__c,Quantity__c,
                           ILPLI__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.name from Inventory_Allocations__r where Status__c='Printed') 
                          from OrderItem where OrderId=:soIdList];
            }
            Map<Id,List<OrderItem>> soIdStdOLListMap=new Map<Id,List<OrderItem>>();
            List<Inventory_Allocation__c> iaListToMakePrinted=new List<Inventory_Allocation__c>();
            for(OrderItem ol:olList)
            {
                if(soIdStdOLListMap.containsKey(ol.OrderId))
                {
                    List<OrderItem> tempStdOLList=soIdStdOLListMap.get(ol.OrderId);
                    tempStdOLList.add(ol);
                    soIdStdOLListMap.put(ol.OrderId,tempStdOLList);
                }
                else
                {
                    List<OrderItem> tempStdOLList=new List<OrderItem>();
                    tempStdOLList.add(ol);
                    soIdStdOLListMap.put(ol.OrderId,tempStdOLList);
                }
                for(Inventory_Allocation__c ia:ol.Inventory_Allocations__r)
                {
                    ia.Status__c='Printed';
                    iaListToMakePrinted.add(ia);
                }
            }   
            if(iaListToMakePrinted.size()>0)
                update iaListToMakePrinted;
            if(soIdStdOLListMap.keySet().size()>0){
                List<Order> ordList=new List<Order>();
                for(Order o:[select id,OrderNumber,IsPrinted__c from Order where id in :soIdStdOLListMap.keySet()])
                {
                    o.IsPrinted__c=true;
                    ordList.add(o);
                }
                if(ordList.size()>0){
                    update ordList;
                }
            }
       //}
        
        return ppwlist;
    }
    /*********************************************/
    @AuraEnabled
    public static void PickingPrintedOrder(String soID,String solw)//String sow,List<Inventory_Location_Product_Line_Item__c> ilplis,Map<ID,Decimal>enteredQuantity        
    {
        /*    if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')            
            && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
             && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Picking_Slip__c')
               && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')   
                 && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Picking_Slip__c',new Set<String>{'Id','Name','sigmaerpdev__Order__c','sigmaerpdev__Status__c'})  
             && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Picking_Slip__c',new Set<String>{'sigmaerpdev__Order__c','sigmaerpdev__Status__c'})                                                                                    
            && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'Id','Name','OrderId','sigmaerpdev__Order_Status__c','Order.sigmaerpdev__Allocated_User__c','Order.name','Product2Id','Product2.sigmaerpdev__Attribute_Type__c','Product2.ProductCode','Product2.sigmaerpdev__Product_Bar_Code__c','Product2.name','Quantity','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Picking_Slip__c'})       
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')   
            && CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'Id','OrderNumber','sigmaerpdev__Customer_Type__c','AccountId','BillToContactId','sigmaerpdev__Discount__c','sigmaerpdev__BillingStreet__c','sigmaerpdev__BillingCity__c','sigmaerpdev__BillingState__c','sigmaerpdev__BillingPostalCode__c','sigmaerpdev__BillingCountry__c','sigmaerpdev__Shipping_Street__c','sigmaerpdev__ShippingCity__c','sigmaerpdev__ShippingCountry__c','sigmaerpdev__ShippingPostalCode__c'})                         
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c','sigmaerpdev__Allocation__c'})                                       
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{'id','name','sigmaerpdev__Order_Product__c','sigmaerpdev__Order_Product__r.Product2Id','sigmaerpdev__ILPLI__c','sigmaerpdev__Picked_Quantity__c','sigmaerpdev__Quantity__c','sigmaerpdev__ILPLI__r.sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.name','sigmaerpdev__Status__c','sigmaerpdev__Picking__c'})
              && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Allocation__c',new set<String>{'sigmaerpdev__Status__c','sigmaerpdev__Picking__c','sigmaerpdev__Picked_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new set<String>{'Id', 'Name','sigmaerpdev__ProductCode__c','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__Total_Available_Qty__c','sigmaerpdev__Delivered_Qty__c','sigmaerpdev__Available_Qty__c','sigmaerpdev__Picked_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new set<String>{'sigmaerpdev__ProductCode__c','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__Picked_Quantity__c'})
            && CRUD_FLS_CheckUtility.checkFLS('OrderItem',new set<String>{'sigmaerpdev__Picking_Slip__c'})       
       
       )
       {*/
                List<PickingOrderCtrl.standOrderLineWrapper>standOrderLineWrapper;
                if(solw!=null)
                {
                    standOrderLineWrapper =  (List<PickingOrderCtrl.standOrderLineWrapper>)System.JSON.deserialize(solw, List<PickingOrderCtrl.standOrderLineWrapper>.class); 
                }
                Map<id,decimal> ILPLIIdQuantMap=new Map<Id,Decimal>();
                Order_Usage__c orderusage=[select Allocation_in_Sales_Order__c,Allocation_in_Picking__c,Auto_Allocate_in_picking__c,Sigma_order__c,Standard_object__c,Allocation__c from Order_Usage__c Limit 1];
                List<OrderItem> olList;
                List<Order> standOrderRecord=new List<Order>();
                Picking_Slip__c pick=new Picking_Slip__c();
                pick.Order__c=soID;
                pick.Status__c='Picked';
                insert pick;
                olList=[select id,OrderId,Order.Allocated_User__c,Order.name,Product2.Attribute_Type__c,Product2.ProductCode,Product2.Product_Bar_Code__c,Product2.name,Quantity,Net_Quantity__c,
                        (select id,name,Order_Product__c,Order_Product__r.Product2Id,Quantity__c,Status__c,Picked_Quantity__c,ILPLI__c,Picking__c ,ILPLI__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.name from Inventory_Allocations__r ) 
                        from OrderItem where OrderId=:soID AND Order_Status__c='Order Confirmed' and id in (select Order_Product__c from Inventory_Allocation__c where Status__c=:'Printed')];
                
                standOrderRecord=[select id,OrderNumber,isPickingInProgress__c,Customer_Type__c,AccountId,BillToContactId,Discount__c,
                                  BillingStreet__c,BillingCity__c,BillingState__c,BillingPostalCode__c,
                                  BillingCountry__c,Shipping_Street__c,ShippingCity__c,ShippingCountry__c,ShippingPostalCode__c
                                  from Order where id=: soID];
                List<Id>productIDs=new List<Id>();
                Map<ID,Decimal>prodIdQuantReduceInPIMap=new Map<ID,Decimal>();
                List<Inventory_Allocation__c> iaList=new List<Inventory_Allocation__c>();
                List<OrderItem> olListToUpdate=new List<OrderItem>();
                List<OrderItem> deliveredStdOlines=new List<OrderItem>();
                
                for(OrderItem ol:olList)
                {
                    ol.Picking_Slip__c=pick.Id;
                    deliveredStdOlines.add(ol);
                    olListToUpdate.add(ol);
                    for(Inventory_Allocation__c ia:ol.Inventory_Allocations__r)
                    {
                        ia.Status__c='Picked';
                        ia.Picking__c=pick.id;
                        ia.Picked_Quantity__c=ia.Quantity__c;
                        iaList.add(ia); 
                        if(ILPLIIdQuantMap.containskey(ia.ILPLI__c)) ILPLIIdQuantMap.put(ia.ILPLI__c,ILPLIIdQuantMap.get(ia.ILPLI__c)+ia.Picked_Quantity__c);
                        else
                            ILPLIIdQuantMap.put(ia.ILPLI__c,ia.Picked_Quantity__c);
                        if(prodIdQuantReduceInPIMap.containsKey(ia.Order_Product__r.Product2Id))
                            prodIdQuantReduceInPIMap.put(ia.Order_Product__r.Product2Id,prodIdQuantReduceInPIMap.get(ia.Order_Product__r.Product2Id)+ia.Picked_Quantity__c);
                        else    
                            prodIdQuantReduceInPIMap.put(ia.Order_Product__r.Product2Id,ia.Picked_Quantity__c);
                    }
                }
                if(olListToUpdate.size()>0){
                    update olListToUpdate;
                }
                if(iaList.size()>0){
                    upsert iaList;
                }
                if(ILPLIIdQuantMap.values().size()>0){
                    InventoryManagement.reduceWholeInventory(ILPLIIdQuantMap,'Avail_Reserve_Quantity');
                }
                if(prodIdQuantReduceInPIMap.size()>0)
                {
                    List<Inventory__c> invList=new List<Inventory__c>();
                    for(Inventory__c inv:[select id,name,ProductCode__c,Reserved_Qty__c,Total_Available_Qty__c,Delivered_Qty__c,Available_Qty__c,Picked_Quantity__c from Inventory__c where ProductCode__c in:prodIdQuantReduceInPIMap.keySet() ])
                    {
                        if(orderusage.Allocation_in_Picking__c==false)
                        {
                            inv.Reserved_Qty__c-=prodIdQuantReduceInPIMap.get(inv.ProductCode__c);
                        }
                        if(inv.Picked_Quantity__c==null)
                            inv.Picked_Quantity__c=0;
                        inv.Picked_Quantity__c+=prodIdQuantReduceInPIMap.get(inv.ProductCode__c);
                        invList.add(inv);
                    }
                    if(invList.size()>0)
                        update invList;
                }   
       //}
           
    }  
}