public with sharing class PickingCtrl  
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
             createErrorLog.insertError('Picking',e.getMessage(),'Method -fetchProductImageInformation ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                    
            }
       // }
         return productimagecontent;
    }
    @AuraEnabled
    public static void PickingPrintedOrderInBulk(List<Id> soIDList)
    {
          /*if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c','sigmaerpdev__Allocation__c'})                   
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Picking_Slip__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Picking_Slip__c',new Set<String>{'Id','Name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Status__c'})  
             && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Picking_Slip__c',new Set<String>{'sigmaerpdev__Sigma_Order__c','sigmaerpdev__Status__c'})     
             && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'Id','Name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Allocated_User__c','sigmaerpdev__Sigma_Order__r.Name','sigmaerpdev__Product__c','sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c','sigmaerpdev__Product__r.ProductCode','sigmaerpdev__Product__r.sigmaerpdev__Product_Bar_Code__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Quantity__c','sigmaerpdev__Order_Status__c'})
                && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev__Sigma_Order__c'})
             && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev__Picking_Slip__c'}) 
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{'id','name','sigmaerpdev__Order_Line__c','sigmaerpdev__Order_Line__r.sigmaerpdev__Product__c','sigmaerpdev__ILPLI__c','sigmaerpdev__Picked_Quantity__c','sigmaerpdev__Quantity__c','sigmaerpdev__ILPLI__r.sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.name','sigmaerpdev__Status__c','sigmaerpdev__Picking__c'})
             && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Allocation__c',new set<String>{'sigmaerpdev__Status__c','sigmaerpdev__Picking__c','sigmaerpdev__Picked_Quantity__c'})
             && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new set<String>{'Id', 'Name','sigmaerpdev__ProductCode__c','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__Total_Available_Qty__c','sigmaerpdev__Delivered_Qty__c','sigmaerpdev__Available_Qty__c','sigmaerpdev__Picked_Quantity__c','sigmaerpdev__Comments__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new set<String>{'sigmaerpdev__ProductCode__c','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__Picked_Quantity__c'})
             && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
                && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'Id'})       
       )
       {*/
                try{
                Order_Usage__c OrderType=[select Sigma_order__c,Standard_object__c,Allocation_in_Sales_Order__c,Allocation_in_Picking__c,Auto_Allocate_in_picking__c  from Order_Usage__c Limit 1];
                if(OrderType.Sigma_order__c==true )
                {
                    Map<Id,Picking_Slip__c> soIdPikingMap=new Map<Id,Picking_Slip__c>();
                    for(Id soId:soIDList)
                    {
                        Picking_Slip__c pick=new Picking_Slip__c();
                        pick.Sigma_Order__c=soID;
                        pick.Status__c='Picked';
                        soIdPikingMap.put(soID,pick);
                    }
                    if(soIdPikingMap.values().size()>0)
                        insert soIdPikingMap.values();
                    Map<Id,List<Product_Order_Price_Book__c>> soIdSOLListMap=new Map<Id,List<Product_Order_Price_Book__c>>();
                    for(Product_Order_Price_Book__c sol: [select id,name, Sigma_Order__c,Sigma_Order__r.Allocated_User__c,Sigma_Order__r.name,Product__c,Product__r.Attribute_Type__c,Product__r.ProductCode,Product__r.Product_Bar_Code__c,Quantity__c,Product__r.name,
                                                          (select id,name,Order_Line__c,Order_Line__r.Product__c,Quantity__c,Status__c,Picked_Quantity__c,ILPLI__c,Picking__c , ILPLI__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.name from Inventory_Allocations1__r ) 
                                                          from Product_Order_Price_Book__c   where 
                                                          Sigma_Order__c=:soIDList AND  Order_Status__c=:'Order Confirmed' and id in (select Order_Line__c from Inventory_Allocation__c where Status__c=:'Printed')])
                    {
                        if(soIdSOLListMap.containsKey(sol.Sigma_Order__c)){
                            List<Product_Order_Price_Book__c> tempList=soIdSOLListMap.get(sol.Sigma_Order__c);
                            tempList.add(sol);
                            soIdSOLListMap.put(sol.Sigma_Order__c,tempList);
                        }
                        else
                            soIdSOLListMap.put(sol.Sigma_Order__c,new List<Product_Order_Price_Book__c>{sol});
                    }
                    List<Product_Order_Price_Book__c> deliveredSOlines=new List<Product_Order_Price_Book__c>();
                    List<Product_Order_Price_Book__c> solListToUpdate=new List<Product_Order_Price_Book__c>();
                    List<Inventory_Allocation__c> iaList=new List<Inventory_Allocation__c>();
                    Map<id,decimal> ILPLIIdQuantMap=new Map<Id,Decimal>();
                    Map<id,decimal> productIdQuantMap=new Map<Id,Decimal>();
                    for(Id soID:soIdSOLListMap.keySet())
                    {
                        List<Product_Order_Price_Book__c> solList=soIdSOLListMap.get(soID);
                        for(Product_Order_Price_Book__c sol:solList)
                        {
                            sol.Picking_Slip__c=soIdPikingMap.get(soID).Id;
                            solListToUpdate.add(sol);
                            for(Inventory_Allocation__c ia:sol.Inventory_Allocations1__r)
                            {
                                ia.Status__c='Picked';
                                ia.Picking__c=soIdPikingMap.get(soID).Id;
                                ia.Picked_Quantity__c=ia.Quantity__c;
                                iaList.add(ia);
                                if(ILPLIIdQuantMap.containskey(ia.ILPLI__c))
                                    ILPLIIdQuantMap.put(ia.ILPLI__c,ILPLIIdQuantMap.get(ia.ILPLI__c)+ia.Picked_Quantity__c);
                                else
                                    ILPLIIdQuantMap.put(ia.ILPLI__c,ia.Picked_Quantity__c);
                                if(productIdQuantMap.containsKey(ia.Order_Line__r.Product__c))
                                    productIdQuantMap.put(ia.Order_Line__r.Product__c,productIdQuantMap.get(ia.Order_Line__r.Product__c)+ia.Picked_Quantity__c);
                                else productIdQuantMap.put(ia.Order_Line__r.Product__c,ia.Picked_Quantity__c);
                            }
                        }
                    }
                    if(solListToUpdate.size()>0){
                        update solListToUpdate;
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
            }catch(Exception ex)
            {
                createErrorLog.insertError('Picking',ex.getMessage(),'Method -PickingPrintedOrderInBulk ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
            }
           
       //}
    }
    public class BulkPickerWrap
    {
        @AuraEnabled
        public String soId;
        @AuraEnabled
        public String userId;
    }
    @AuraEnabled
    public static void soBULKPickerAllocation(string soIdPickerIdMap)
    {
         /*if(
        CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'Id','sigmaerpdev__Allocated_User__c'}) 
             && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sigma_Order__c',new set<String>{'sigmaerpdev__Allocated_User__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('User',new set<String>{'Id'}) 
        )
        {*/
                List<BulkPickerWrap> dSerialisedsoIdPickerIdMap=(List<BulkPickerWrap>)System.JSON.deserialize(soIdPickerIdMap,List<BulkPickerWrap>.class);
                List<Sigma_Order__c> soList=new List<Sigma_Order__c>();
                for(BulkPickerWrap bpw:dSerialisedsoIdPickerIdMap)
                {
                    soList.add(new Sigma_Order__c(Id=bpw.soId,Allocated_User__c=bpw.userId));
                }
                if(soList.size()>0)
                update soList;  
        //}
    }
    @AuraEnabled
    public static Sublevel_location__c getBin(String barCode)
    {
        Sublevel_location__c sl;
        /*         if(
        CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sublevel_location__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sublevel_location__c',new set<String>{'Id','Name','sigmaerpdev__Bar_Code__c','sigmaerpdev__zone__c'}) 
        )
        {*/
             sl=[select id,name,Bar_Code__c,zone__c from Sublevel_location__c where Bar_Code__c=:barCode limit 1];
        //}
         return sl;
        
    }
    public class sigmaOrderLineWrapper {
        @AuraEnabled
        public Product_Order_Price_Book__c orderLineWrap{get;set;}
        @AuraEnabled
        public List<sigmaOrderIlpliWrapper> wrapperIlpli;   
    }
    public class sigmaOrderIlpliWrapper{
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
        public sigmaOrderIlpliWrapper(string Location,string SerialNo,string Lot,Date ReceivedDate,Decimal AvailableQuantity,Decimal EnterQuantity)
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
    public static List<sigmaOrderLineWrapper> getIlpli1(List<String> soIds)
    {
         List<sigmaOrderLineWrapper>listOfsigmaOrderLineWrapper;
                /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
                && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'Id'})  )
                {*/
                    listOfsigmaOrderLineWrapper=new List<sigmaOrderLineWrapper>();
                //}
        return listOfsigmaOrderLineWrapper;
    }    
    @AuraEnabled
    public static Boolean SelectOrders()
    {
         /*if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c','sigmaerpdev__Allocation__c'})                   
           )
           {*/
                Order_Usage__c ou=[select Allocation__c,Allocation_in_Picking__c,Allocation_in_Sales_Order__c,Auto_Allocate_in_picking__c,Sigma_order__c,Standard_object__c  from Order_Usage__c limit 1];
                if(ou.Sigma_order__c==true)
                {
                    return true;
                }
                else
                {
                }
          // }
            return false;
    }
    @AuraEnabled
    public static Boolean allocation(Boolean isAllocationInPicking)
    {
        /*if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c','sigmaerpdev__Allocation__c'})                   
           )
           {*/
        Order_Usage__c ou=[select Allocation_in_Sales_Order__c,Allocation_in_Picking__c,Auto_Allocate_in_picking__c,Sigma_order__c,Standard_object__c  from Order_Usage__c limit 1];
          // }
        return false;
        
    }
    @AuraEnabled
    public static Boolean getOrderUsage(Boolean autoAllocationInpicking)
    {
        /*if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c','sigmaerpdev__Allocation__c'})                   
           )
           {*/
                Order_Usage__c ou=[select Allocation_in_Sales_Order__c,Allocation_in_Picking__c,Auto_Allocate_in_picking__c,Sigma_order__c,Standard_object__c  from Order_Usage__c limit 1];
          // }
        return false;
    }
    @AuraEnabled
    public static String soPickerAllocation(String soID,String userId)
    {
        /*  if(
             CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
              && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{'sigmaerpdev__Order_Line__c','sigmaerpdev__Order_Product__c','sigmaerpdev__Status__c','sigmaerpdev__Order_Line__r.sigmaerpdev__Sigma_Order__c','sigmaerpdev__Order_Product__r.OrderId'})
             && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'Id','sigmaerpdev__Allocated_User__c'}) 
               && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sigma_Order__c',new set<String>{'sigmaerpdev__Allocated_User__c'})
                && CRUD_FLS_CheckUtility.checkReadPermission('User',new set<String>{'Id'})             
        )
        {*/
            List<Inventory_Allocation__c> iaList=[select Order_Line__c,Order_Product__c,Status__c from Inventory_Allocation__c where Status__c='Picking In Progress' AND Order_Line__r.Sigma_Order__c =:soID AND Order_Product__r.OrderId=:soID];
            if(iaList.size()>0)
                return 'Picking In Progress';
            else{
                Sigma_Order__c so=new Sigma_Order__c();
                so.id=soID;
                so.Allocated_User__c=userId;
                update so;
            }
        //}
         return 'success';
    }
    public class sigmaOrdersListInPickingScreeen
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
        public Sigma_Order__c sigmaOrder{get;set;}
        @AuraEnabled
        public String pickedSattus{get;set;}
        @AuraEnabled
        public String PickedUser{get;set;}
        @AuraEnabled
        public Decimal totalRowCount{get;set;}
    }
    public class sigmaOrdersListInPickingScreeenPagination
    {
            @AuraEnabled
            public Integer pageSize { get;set; }
            @AuraEnabled
            public Integer page { get;set; }
            @AuraEnabled
            public Integer total { get;set; }
            @AuraEnabled
            public List<sigmaOrdersListInPickingScreeen> sigmaorderlistPickScreen { get;set; }
    
    }
    @AuraEnabled
    public static sigmaOrdersListInPickingScreeenPagination fetchSOData2(String sortField,String ascDesc,String soId,String tabSelected,Integer numberOfRecordsToDisplay,Integer pageNumber)
    {
        System.debug('fetchSOData2>>>'+pageNumber);
        sigmaOrdersListInPickingScreeenPagination pickingScreenDataPagination=new sigmaOrdersListInPickingScreeenPagination();
                
        List<sigmaOrdersListInPickingScreeen> pickingScreenData=new List<sigmaOrdersListInPickingScreeen>();
        try{
            /*  if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
              && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Allocation__c','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c'})
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new set<String>{'Id','sigmaerpdev__Inventory_Status__c'})  
              && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_API__c')
              && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_API__c',new set<String>{'Id', 'Name','sigmaerpdev__Subscription_Product__c','sigmaerpdev__Subscription_Renewal__c'})
                && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Time_Base_Inventory__c')
              && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Time_Base_Inventory__c',new set<String>{'Id', 'Name','sigmaerpdev__Proposal_for_Products__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('Profile',new Set<String>{'Id','Name'})
            && CRUD_FLS_CheckUtility.checkReadPermission('User',new Set<String>{'Id','Name','UserRole.Name','Username','IsActive','Profile.Name'})
               && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Commynity__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Commynity__c',new Set<String>{'Id','Name','sigmaerpdev__Retailer_Community_Plus_User__c','sigmaerpdev__Retailer_Profile__c','sigmaerpdev__SigmaVendor_Profile__c','sigmaerpdev__Vendor_Community_Plus_User__c'})     
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'Id','Name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Inventory_Status__c','sigmaerpdev__In_Progress_In_Package__c'})
                        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{'id','name','sigmaerpdev__Order_Line__c','sigmaerpdev__Status__c'})
              && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
                && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'id','name','sigmaerpdev__Delivary_Date__c','sigmaerpdev__Order_Created_Via__c' ,'sigmaerpdev__AccountId__c','sigmaerpdev__AccountId__r.name','sigmaerpdev__Status__c','sigmaerpdev__Allocated_User__c','sigmaerpdev__Allocated_User__r.name','sigmaerpdev__Orders_Status__c','sigmaerpdev__No_Picking_Package_Shipment_Required__c'})
        )
        {*/
            Default_Parameters__c dp=[select id,Inventory_Status__c from Default_Parameters__c limit 1];
            if(dp.Inventory_Status__c!='Reserve')
            {
                return null;
            }
            Order_Usage__c orderusage=[select Allocation_in_Sales_Order__c,Allocation_in_Picking__c,Auto_Allocate_in_picking__c,Sigma_order__c,Standard_object__c,Allocation__c  from Order_Usage__c Limit 1];
            //code added to handle sigma order created via POS,Subscription,Proposal in picking module by rashmi on 30-07-2019
            Order_API__c orderapi =[select Subscription_Product__c,Subscription_Renewal__c from Order_API__c Limit 1];
            Time_Base_Inventory__c ordertbi = [select Proposal_for_Products__c from Time_Base_Inventory__c Limit 1];
            //if(orderusage.Sigma_order__c==true) changed  from if(orderusage.Sigma_order__c==true) to if(orderusage.sigmaerpdev__Allocation_in_Sales_Order__c==true)   on 13-08-2019
            if(orderusage.Sigma_order__c==true) ////commented on 05-11-2019 to ristrict inventory allocation in picking
            {
                Id profileId = userinfo.getProfileId();
                string profileName=[select id,Name from profile where id = :profileId].Name;
                Id logedInUserId= [select id,Name,UserRole.Name from User where id =: userInfo.getUserId()].id;
                String userRole= [select id,Name,UserRole.Name from User where id =: userInfo.getUserId()].UserRole.Name;
                String userId;
                boolean isSystemAdmin=false;
                List<user> users=new List<user>();
                List<Commynity__c>  CustSet= new List<Commynity__c>();
                SET<String> Profiname = new SET<String>();
				Community_Configuration__c CommuCustset= [select Id,Name,Retailer_Community_URL__c,Products_Per_Page__c,Retailer_Profile_Name__c,Vendor_Community_URL__c,Vendor_Profile_Name__c from Community_Configuration__c where Name = 'Community Configurations' LIMIT 1];
                CustSet = [select Id,Retailer_Community_Plus_User__c,Vendor_Community_Plus_User__c,SigmaVendor_Profile__c,Retailer_Profile__c from Commynity__c limit 1];
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
                if(profileName=='System Administrator' || userRole=='Warehouse Manager' || profileName==CommuCustset.Retailer_Profile_Name__c || userRole=='Warehouse User')
                {
                    isSystemAdmin=true;       
                    try{
                        users=[select id,name,Username from user where IsActive=true AND Profile.Name NOT IN : Profiname];
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
                    //And sigmaerpdev__In_Progress_In_Package__c=false added on 23-04-2020 to stop listing son in picking once the order is went for package in progress state
                    for(Product_Order_Price_Book__c sol:[select Sigma_Order__c from Product_Order_Price_Book__c   where  Inventory_Status__c!='Allocated'  and id in (select Order_Line__c from Inventory_Allocation__c where Status__c='') and 
                                                                      Order_Status__c='Order Confirmed' And In_Progress_In_Package__c=false ])
                    {
                        soIdString+='\''+sol.Sigma_Order__c+'\',';
                    }
                }
                else
                {
                    //And sigmaerpdev__In_Progress_In_Package__c=false added on 23-04-2020 to stop listing son in picking once the order is went for package in progress state              
                    for(Product_Order_Price_Book__c sol:[select Sigma_Order__c from Product_Order_Price_Book__c   where  Inventory_Status__c!='Allocated'  and   id in (select Order_Line__c from Inventory_Allocation__c where Status__c =: tabSelected ) and 
                                                                      Order_Status__c='Order Confirmed' And In_Progress_In_Package__c=false ])
                    {
                        soIdString+='\''+sol.Sigma_Order__c+'\',';
                    }
                }
                soIdString=soIdString.removeEnd(',');
                soIdString+=')';
                String queryString='select id,name,Delivary_Date__c,Order_Created_Via__c ,AccountId__c,AccountId__r.name,Status__c,Allocated_User__c,Allocated_User__r.name  from Sigma_Order__c where Orders_Status__c=\'Order Confirmed\' and No_Picking_Package_Shipment_Required__c=false'; 
                String querySize = 'select COUNT(Id) countIds from Sigma_Order__c where Orders_Status__c=\'Order Confirmed\' ';
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
				
				//Code Added for FFTB
				Id CommUserId= UserInfo.getUserId();
            User currentuser = [select Id,Profile.Name,Contact.AccountId from User where Id =: CommUserId];
            Community_Configuration__c CommCustset= [select Id,Name,Retailer_Community_URL__c,Products_Per_Page__c,Retailer_Profile_Name__c,Vendor_Community_URL__c,Vendor_Profile_Name__c from Community_Configuration__c where Name = 'Community Configurations' LIMIT 1];
				if(currentuser.Profile.Name == CommCustset.Retailer_Profile_Name__c)
				{
					queryString += ' AND Brewer_Account__c=\''+currentuser.Contact.AccountId+'\'';
                    querySize += ' AND Brewer_Account__c=\''+currentuser.Contact.AccountId+'\''; 
				}
				
				
                if(String.isNotEmpty(sortField) || String.isNotBlank(sortField))
                {
                    queryString += ' order by '+sortField+' '+ascDesc;  
                }
                else
                {
                    queryString += ' order by name desc';  
                }
               // queryString += ' Limit '+numberOfRecordsToDisplay;
                Integer pageSize = 10;
                Integer offset = ((Integer)pageNumber - 1) * pageSize;
                pickingScreenDataPagination.pageSize=pageSize;
                pickingScreenDataPagination.page= (Integer) pageNumber;
                
                decimal numOfRows=0;
                AggregateResult recordCount = Database.query(querySize);
                numOfRows=(Integer)recordCount.get('countIds');
                pickingScreenDataPagination.total= (Integer)recordCount.get('countIds');
                System.debug('offset'+offset);
                //queryString += ' Limit '+pageSize+' offset '+offset;
                
                 if(String.isNotEmpty(soId) || String.isNotBlank(soId))
                {
                    queryString += ' Limit '+pageSize; 
                }
                else{
                    queryString += ' Limit '+pageSize+' offset '+offset;
                }
                System.debug('queryString>>>>'+queryString);
                //limit :pageSize offset :offset
                List<Sigma_Order__c> soList = Database.query(queryString);
                
                System.debug('soList>>>>'+soList);
                
                
                for(Sigma_Order__c so:soList)
                {
                    sigmaOrdersListInPickingScreeen indpickingScreenData=new sigmaOrdersListInPickingScreeen();
                    if(isSystemAdmin)
                    {
                        indpickingScreenData.users=users;
                    }     
                    indpickingScreenData.logedInUserId=logedInUserId;
                    indpickingScreenData.totalRowCount=numOfRows;
                    indpickingScreenData.allocatedUserId=so.Allocated_User__c;
                    indpickingScreenData.allocatedUserName=so.Allocated_User__r.Name;
                    indpickingScreenData.PickedUser=so.Allocated_User__c;
                    indpickingScreenData.isSystemAdmin=isSystemAdmin;
                    indpickingScreenData.sigmaOrder=so;
                    indpickingScreenData.pickedSattus=tabSelected==''? 'Not Picked':tabSelected;
                    pickingScreenData.add(indpickingScreenData);
                } 
                pickingScreenDataPagination.sigmaorderlistPickScreen=pickingScreenData;
                
            }
        
            
        }catch(Exception ex)
        {
            System.debug('ex>>>'+ex.getCause()+'>>'+ex.getStackTraceString());
            
        }
            
       // }
        return pickingScreenDataPagination;    
    }
    @AuraEnabled
    public static List<sigmaOrdersListInPickingScreeen> fetchSOData(String sortField,String ascDesc,String soId,String tabSelected,Integer numberOfRecordsToDisplay)
    {
        List<sigmaOrdersListInPickingScreeen> pickingScreenData=new List<sigmaOrdersListInPickingScreeen>();
        /*  if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
              && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Allocation__c','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c'})
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new set<String>{'Id','sigmaerpdev__Inventory_Status__c'})  
              && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_API__c')
              && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_API__c',new set<String>{'Id', 'Name','sigmaerpdev__Subscription_Product__c','sigmaerpdev__Subscription_Renewal__c'})
                && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Time_Base_Inventory__c')
              && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Time_Base_Inventory__c',new set<String>{'Id', 'Name','sigmaerpdev__Proposal_for_Products__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('Profile',new Set<String>{'Id','Name'})
            && CRUD_FLS_CheckUtility.checkReadPermission('User',new Set<String>{'Id','Name','UserRole.Name','Username','IsActive','Profile.Name'})
               && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Commynity__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Commynity__c',new Set<String>{'Id','Name','sigmaerpdev__Retailer_Community_Plus_User__c','sigmaerpdev__Retailer_Profile__c','sigmaerpdev__SigmaVendor_Profile__c','sigmaerpdev__Vendor_Community_Plus_User__c'})     
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'Id','Name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Inventory_Status__c','sigmaerpdev__In_Progress_In_Package__c'})
                        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{'id','name','sigmaerpdev__Order_Line__c','sigmaerpdev__Status__c'})
              && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
                && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'id','name','sigmaerpdev__Delivary_Date__c','sigmaerpdev__Order_Created_Via__c' ,'sigmaerpdev__AccountId__c','sigmaerpdev__AccountId__r.name','sigmaerpdev__Status__c','sigmaerpdev__Allocated_User__c','sigmaerpdev__Allocated_User__r.name','sigmaerpdev__Orders_Status__c','sigmaerpdev__No_Picking_Package_Shipment_Required__c'})
        )
        {*/
            Default_Parameters__c dp=[select id,Inventory_Status__c from Default_Parameters__c limit 1];
            if(dp.Inventory_Status__c!='Reserve')
            {
                return null;
            }
            Order_Usage__c orderusage=[select Allocation_in_Sales_Order__c,Allocation_in_Picking__c,Auto_Allocate_in_picking__c,Sigma_order__c,Standard_object__c,Allocation__c  from Order_Usage__c Limit 1];
            //code added to handle sigma order created via POS,Subscription,Proposal in picking module by rashmi on 30-07-2019
            Order_API__c orderapi =[select Subscription_Product__c,Subscription_Renewal__c from Order_API__c Limit 1];
            Time_Base_Inventory__c ordertbi = [select Proposal_for_Products__c from Time_Base_Inventory__c Limit 1];
            //if(orderusage.Sigma_order__c==true) changed  from if(orderusage.Sigma_order__c==true) to if(orderusage.sigmaerpdev__Allocation_in_Sales_Order__c==true)   on 13-08-2019
            if(orderusage.Sigma_order__c==true) ////commented on 05-11-2019 to ristrict inventory allocation in picking
            {
                Id profileId = userinfo.getProfileId();
                string profileName=[select id,Name from profile where id = :profileId].Name;
                Id logedInUserId= [select id,Name,UserRole.Name from User where id =: userInfo.getUserId()].id;
                String userRole= [select id,Name,UserRole.Name from User where id =: userInfo.getUserId()].UserRole.Name;
                String userId;
                boolean isSystemAdmin=false;
                List<user> users=new List<user>();
                List<Commynity__c>  CustSet= new List<Commynity__c>();
                SET<String> Profiname = new SET<String>();
                CustSet = [select Id,Retailer_Community_Plus_User__c,Vendor_Community_Plus_User__c,SigmaVendor_Profile__c,Retailer_Profile__c    from Commynity__c limit 1];
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
                if(profileName=='System Administrator' || userRole=='Warehouse Manager'||userRole=='Warehouse User')
                  
                {
                    isSystemAdmin=true;       
                    try{
                        users=[select id,name,Username from user where IsActive=true AND Profile.Name NOT IN : Profiname];
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
                    //And sigmaerpdev__In_Progress_In_Package__c=false added on 23-04-2020 to stop listing son in picking once the order is went for package in progress state
                    for(Product_Order_Price_Book__c sol:[select Sigma_Order__c from Product_Order_Price_Book__c   where  Inventory_Status__c!='Allocated'  and id in (select Order_Line__c from Inventory_Allocation__c where Status__c='') and 
                                                                      Order_Status__c='Order Confirmed' And In_Progress_In_Package__c=false ])
                    {
                        soIdString+='\''+sol.Sigma_Order__c+'\',';
                    }
                }
                else
                {
                    //And sigmaerpdev__In_Progress_In_Package__c=false added on 23-04-2020 to stop listing son in picking once the order is went for package in progress state              
                    for(Product_Order_Price_Book__c sol:[select Sigma_Order__c from Product_Order_Price_Book__c   where  Inventory_Status__c!='Allocated'  and   id in (select Order_Line__c from Inventory_Allocation__c where Status__c =: tabSelected ) and 
                                                                      Order_Status__c='Order Confirmed' And In_Progress_In_Package__c=false ])
                    {
                        soIdString+='\''+sol.Sigma_Order__c+'\',';
                    }
                }
                soIdString=soIdString.removeEnd(',');
                soIdString+=')';
                String queryString='select id,name,Delivary_Date__c,Order_Created_Via__c ,AccountId__c,AccountId__r.name,Status__c,Allocated_User__c,Allocated_User__r.name  from Sigma_Order__c where Orders_Status__c=\'Order Confirmed\' and No_Picking_Package_Shipment_Required__c=false'; 
                String querySize = 'select COUNT(Id) countIds from Sigma_Order__c where Orders_Status__c=\'Order Confirmed\' ';
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
                List<Sigma_Order__c> soList = Database.query(queryString);
                decimal numOfRows=0;
                AggregateResult recordCount = Database.query(querySize);
                numOfRows=(Integer)recordCount.get('countIds');
                for(Sigma_Order__c so:soList)
                {
                    sigmaOrdersListInPickingScreeen indpickingScreenData=new sigmaOrdersListInPickingScreeen();
                    if(isSystemAdmin)
                    {
                        indpickingScreenData.users=users;
                    }     
                    indpickingScreenData.logedInUserId=logedInUserId;
                    indpickingScreenData.totalRowCount=numOfRows;
                    indpickingScreenData.allocatedUserId=so.Allocated_User__c;
                    indpickingScreenData.allocatedUserName=so.Allocated_User__r.Name;
                    indpickingScreenData.PickedUser=so.Allocated_User__c;
                    indpickingScreenData.isSystemAdmin=isSystemAdmin;
                    indpickingScreenData.sigmaOrder=so;
                    indpickingScreenData.pickedSattus=tabSelected==''? 'Not Picked':tabSelected;
                    pickingScreenData.add(indpickingScreenData);
                }      
            }
            
       // }
        return pickingScreenData;    
    } 
    @AuraEnabled
    public static PickingParentWrap fetchPickingData(String soID,String callingFrom)
    {
          PickingParentWrap ppw=new PickingParentWrap();
           /*if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c'})
             && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'id','name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Product__c','sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c','sigmaerpdev__Product__r.ProductCode','sigmaerpdev__Product__r.sigmaerpdev__Product_Bar_Code__c','sigmaerpdev__Quantity__c','sigmaerpdev__Product__r.name','sigmaerpdev__Order_Status__c'})
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{'id','name','sigmaerpdev__Order_Line__c','sigmaerpdev__Quantity__c','sigmaerpdev__Status__c','sigmaerpdev__Picked_Quantity__c','sigmaerpdev__ILPLI__c','sigmaerpdev__ILPLI__r.sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Name','sigmaerpdev__ILPLI__r.sigmaerpdev__Bin__c','sigmaerpdev__ILPLI__r.sigmaerpdev__Bin__r.Name','sigmaerpdev__ILPLI__r.sigmaerpdev__Bin__r.sigmaerpdev__zone__c','sigmaerpdev__ILPLI__r.sigmaerpdev__Bin__r.sigmaerpdev__Bar_Code__c','sigmaerpdev__ILPLI__r.sigmaerpdev__Bin__r.sigmaerpdev__zone__r.Name'})
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'Id'}) 
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Picking_Slip__c')
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Picking_Slip__c',new Set<String>{'Id','Name','sigmaerpdev__Start_Time__c','sigmaerpdev__Sigma_Order__c'})  
        ){*/
            Order_Usage__c orderusage=[select Allocation_in_Sales_Order__c,Allocation_in_Picking__c from Order_Usage__c Limit 1];
            List<Product_Order_Price_Book__c> solList;
            List<Inventory_Allocation__c> ilList;
            List<ID> ids=new List<ID>();
            if(callingFrom=='Printed'){
                //added on 09-09-2019  for whare house  bin and zone fields
                solList=[select id,name,Sigma_Order__c,Product__c,Product__r.Attribute_Type__c,Product__r.ProductCode,Product__r.Product_Bar_Code__c,Quantity__c,Product__r.name,
                         (select id,name,
                          ILPLI__c,Status__c,Picked_Quantity__c,Quantity__c,
                          ILPLI__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.name 
                          ,ILPLI__r.Bin__c,ILPLI__r.Bin__r.Name,ILPLI__r.Bin__r.zone__c,ILPLI__r.Bin__r.zone__r.Name,ILPLI__r.Product__r.Attribute_Type__c,ILPLI__r.Product__r.Name,ILPLI__r.Product__r.Product_Bar_Code__c,ILPLI__r.Product__c   
                          from Inventory_Allocations1__r) 
                         from Product_Order_Price_Book__c where Sigma_Order__c=:soID AND Order_Status__c='Order Confirmed' and id in (select Order_Line__c from Inventory_Allocation__c where Status__c='Printed')];
            }
            else if((callingFrom=='NavigateToPicking' || callingFrom=='NewPicking'))
            {
                //added on 09-09-2019  for whare house  bin and zone fields
                solList=[select id,name,Sigma_Order__c,Product__c,Product__r.Attribute_Type__c,Product__r.ProductCode,Product__r.Product_Bar_Code__c,Quantity__c,Product__r.name,
                         (select id,name,
                          ILPLI__c,Status__c,Picked_Quantity__c,Quantity__c,
                          ILPLI__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.name
                          ,ILPLI__r.Bin__c,ILPLI__r.Bin__r.Name,ILPLI__r.Bin__r.zone__c,ILPLI__r.Bin__r.zone__r.Name,
                          ILPLI__r.Bin__r.Bar_Code__c,ILPLI__r.Product__c,ILPLI__r.Product__r.Attribute_Type__c,ILPLI__r.Product__r.Name,ILPLI__r.Product__r.Product_Bar_Code__c                     
                          from Inventory_Allocations1__r) 
                         
                         from Product_Order_Price_Book__c  where Sigma_Order__c=:soID AND Order_Status__c='Order Confirmed' and id in (select Order_Line__c from Inventory_Allocation__c where Status__c=null  OR  Status__c='Picking In Progress'  )];
            }
            List<PickingDuplicateDataWrap> pddwList=new List<PickingDuplicateDataWrap>();
            Map<Id,Map<Id,Map<Id,PickingDuplicateDataWrap>>> prodIDLocIdBinIdMap=new Map<Id,Map<Id,Map<Id,PickingDuplicateDataWrap>>>();
            for(Product_Order_Price_Book__c sol:solList)
            {
                ppw.soId=sol.Sigma_Order__c;
                List<PickingOuterDataWrap> pickingDupValueList=new List<PickingOuterDataWrap>();
                List<Inventory_Allocation__c> iaDataList=new List<Inventory_Allocation__c>();
                Boolean duplicateDataFlag=false;
                for(Inventory_Allocation__c ia:sol.Inventory_Allocations1__r)
                {
                    Id lodId=ia.ILPLI__r.Inventory_Location_Product__r.Inventory_Location__r.Location__c;
                    String lodName=ia.ILPLI__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.name; 
                    //added on 09-09-2019  for whare house  bin and zone fields
                    Id zoneId=ia.ILPLI__r.Bin__r.zone__c;
                    String zoneName=ia.ILPLI__r.Bin__r.zone__r.Name;
                    Id binId=ia.ILPLI__r.Bin__c;
                    String binName=ia.ILPLI__r.Bin__r.Name; 
                    PickingDuplicateDataWrap pddw=new PickingDuplicateDataWrap();
                    pddw.solId=sol.Id;
                    
                    if(prodIDLocIdBinIdMap.containsKey(sol.Product__c))
                    {
                        if(prodIDLocIdBinIdMap.get(sol.Product__c).containsKey(lodId))
                        {
                            pddw.locId=lodId;
                            pddw.locName=lodName;
                            //added on 09-09-2019  for whare house  bin and zone fields
                            pddw.zoneId=zoneId;
                            pddw.zoneName=zoneName;
                            pddw.binId=binId;
                            pddw.binName=binName;
                            pddw.binBarCode=ia.ILPLI__r.Bin__r.Bar_Code__c  ;
                            pddw.prodId=sol.Product__c;
                            pddw.prodName=sol.Product__r.name;
                            pddw.prodCode=sol.Product__r.Product_Bar_Code__c;
                            pddw.reqQty=ia.Quantity__c;
                            pddw.pickedQty=0;
                            pddw.picked=false;
                            pddw.iaData.add(ia);
                            pddwList.add(pddw);
                            prodIDLocIdBinIdMap.put(sol.Product__c, new Map<Id,Map<Id,PickingDuplicateDataWrap>>{lodId =>new Map<Id,PickingDuplicateDataWrap>{lodId=>pddw}});
                            
                        } else
                        {
                            pddw.locId=lodId;
                            pddw.locName=lodName;
                            //added on 09-09-2019  for whare house  bin and zone fields
                            pddw.zoneId=zoneId;
                            pddw.zoneName=zoneName;
                            pddw.binId=binId;
                            pddw.binName=binName;
                            pddw.binBarCode=ia.ILPLI__r.Bin__r.Bar_Code__c  ;
                            pddw.prodId=sol.Product__c;
                            pddw.prodName=sol.Product__r.name;
                            pddw.prodCode=sol.Product__r.Product_Bar_Code__c;
                            pddw.reqQty=ia.Quantity__c;
                            pddw.pickedQty=0;
                            pddw.picked=false;
                            pddw.iaData.add(ia);
                            pddwList.add(pddw);
                            prodIDLocIdBinIdMap.put(sol.Product__c, new Map<Id, Map<Id,PickingDuplicateDataWrap>>{lodId =>new Map<Id,PickingDuplicateDataWrap>{lodId=>pddw}});
                        }
                    } else
                    {
                        pddw.locId=lodId;
                        pddw.locName=lodName;
                        //added on 09-09-2019  for whare house  bin and zone fields
                        pddw.zoneId=zoneId;
                        pddw.zoneName=zoneName;
                        pddw.binId=binId;
                        pddw.binName=binName;
                        pddw.binBarCode=ia.ILPLI__r.Bin__r.Bar_Code__c  ;
                        pddw.prodId=sol.Product__c;
                        pddw.prodName=sol.Product__r.name;
                        pddw.prodCode=sol.Product__r.Product_Bar_Code__c;
                        pddw.reqQty=ia.Quantity__c;
                        pddw.pickedQty=0;
                        pddw.picked=false;
                        pddw.iaData.add(ia);
                        pddwList.add(pddw);
                        prodIDLocIdBinIdMap.put(sol.Product__c, new Map<Id, Map<Id,PickingDuplicateDataWrap>>{lodId =>new Map<Id,PickingDuplicateDataWrap>{lodId=>pddw}});
                    }  
                }
            }
            Picking_Slip__c pick=new Picking_Slip__c();
            pick.Sigma_Order__c=ppw.soId;
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
        /*   if(
             CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
               && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'Id'})
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'id','name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.name','ssigmaerpdev__Sigma_Order__r.sigmaerpdev__AccountId__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__AccountId__r.name','sigmaerpdev__Product__r.name','sigmaerpdev__Quantity__c','sigmaerpdev__Remaining_Qty_To_Package__c','sigmaerpdev__Remaining_Qty_For_Package__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Location__c','sigmaerpdev__In_Progress_In_Package__c'})
             && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
              && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new set<String>{'id','name','sigmaerpdev__Customer__c','sigmaerpdev__Customer__c','sigmaerpdev__Status__c','sigmaerpdev__PackagedDate__c','sigmaerpdev__Location__c'})
              && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c') 
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new set<String>{'id','name','sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Status__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Product_Order__c'})
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{'id','name','sigmaerpdev__Order_Line__c','sigmaerpdev__Status__c'})
        )
        {*/
            List<Product_Order_Price_Book__c> solList=
            [select id,Sigma_Order__c,Sigma_Order__r.name,Sigma_Order__r.AccountId__c,Sigma_Order__r.AccountId__r.name,Product__c,Product__r.name,Remaining_Qty_To_Package__c,Quantity__c,Remaining_Qty_For_Package__c,Location__c  from Product_Order_Price_Book__c where  ( Order_Status__c='Order Confirmed')  and ( Sigma_Order__c=:soID) and id in (select Order_Line__c from Inventory_Allocation__c where Status__c =: 'Picked' ) AND In_Progress_In_Package__c=false ];
            List<PackageCtrl.PackageProductWrap> ppWrapList=new List<PackageCtrl.PackageProductWrap>();
            Package__c pack=new Package__c();
            pack.Customer__c=solList[0].Sigma_Order__r.AccountId__c; 
            pack.Status__c='Ready';
            pack.PackagedDate__c=System.Today(); 
            pack.Location__c=solList[0].Location__c;
            for(Product_Order_Price_Book__c indSOL:solList)
            {
                PackagedProducts__c pp=new PackagedProducts__c();
                pp.Product__c=indSOL.Product__c;
                pp.Quantity__c=indSOL.Remaining_Qty_To_Package__c;
                pp.Status__c='Ready';
                pp.Sigma_Order__c=indSOL.Sigma_Order__c;
                pp.Product_Order__c=indSOL.id;
                ppWrapList.add(new PackageCtrl.PackageProductWrap(pp,indSOL.Product__r.name,indSOL.Remaining_Qty_To_Package__c,null,indSOL,null,false));
            }
           
            resp.custName=solList[0].Sigma_Order__r.AccountId__r.name;
            resp.soName=solList[0].Sigma_Order__r.name;
            resp.packData=pack;
            resp.ppData=ppWrapList;
        //}
        return resp;
    }
    @AuraEnabled
    public static responseWrap sumbitPickedData(String pickedData,String solw)
    {
           responseWrap rw = new responseWrap();
        /*        if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c'})
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Picking_Slip__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Picking_Slip__c',new Set<String>{'Id','Name','sigmaerpdev__End_Time__c','sigmaerpdev__Status__c'})  
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Picking_Slip__c',new Set<String>{'sigmaerpdev__Status__c','sigmaerpdev__End_Time__c'})  
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'id','name','sigmaerpdev__AccountId__c','sigmaerpdev__Billing_Contact__c','sigmaerpdev__Payment_type__c','sigmaerpdev__Contact__c    ','sigmaerpdev__Delivary_Date__c','sigmaerpdev__Discount__c','sigmaerpdev__Status__c','sigmaerpdev__BillingStreet__c','sigmaerpdev__BillingCity__c','sigmaerpdev__BillingState__c','sigmaerpdev__BillingPostalCode__c','sigmaerpdev__BillingCountry__c'  ,'sigmaerpdev__Shipping_Street__c','sigmaerpdev__ShippingCity__c','sigmaerpdev__ShippingCountry__c','sigmaerpdev__ShippingPostalCode__c'}) 
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'Id','sigmaerpdev__Picking_Slip__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev__Picking_Slip__c'})
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{'id','name','sigmaerpdev__Order_Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Status__c','sigmaerpdev__Picked_Quantity__c','sigmaerpdev__ILPLI__c','sigmaerpdev__Picking__c'})
                && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Allocation__c',new set<String>{'sigmaerpdev__Order_Line__c','sigmaerpdev__Quantity__c','sigmaerpdev__Status__c','sigmaerpdev__Picked_Quantity__c','sigmaerpdev__ILPLI__c','sigmaerpdev__Picking__c'})
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')                                                          
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new Set<String>{'id','name','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__ProductCode__c','sigmaerpdev__Available_Qty__c','sigmaerpdev__Total_Available_Qty__c','sigmaerpdev__Picked_Quantity__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new Set<String>{'sigmaerpdev__Reserved_Qty__c','sigmaerpdev__Picked_Quantity__c'})
        )
        {*/
                    Savepoint sp;
                try{
                    sp = Database.setSavepoint();
                    Order_Usage__c OrderType=[select Sigma_order__c,Allocation_in_Sales_Order__c,Allocation_in_Picking__c,Auto_Allocate_in_picking__c  from Order_Usage__c Limit 1]  ;   
                    List<Inventory_Allocation__c> iaList=new List<Inventory_Allocation__c>();
                    PickingParentWrap dSerialisedpickedData=(PickingParentWrap)System.JSON.deserialize(pickedData,PickingParentWrap.class);
                    dSerialisedpickedData.pickingValues.Status__c='Picked';
                    dSerialisedpickedData.pickingValues.End_Time__c=datetime.now();
                    upsert dSerialisedpickedData.pickingValues;
                    String pickid=dSerialisedpickedData.pickingValues.Id;
                  
                    map<id,Product_Order_Price_Book__c> solIdSolMap=new map<id,Product_Order_Price_Book__c>();
                    Map<id,decimal> ILPLIIdQuantMap=new Map<Id,Decimal>();
                    Map<id,decimal> ilpliIdQuantMapOfNeedsReview=new Map<Id,Decimal>();
                    Map<id,decimal> newlyAddedILPLIIdQuantMap=new Map<Id,Decimal>();
                    Map<id,decimal> prodIdQuantReduceInPIMap=new Map<Id,Decimal>();
                    Set<Id> proid=new Set<Id>();
                    List<Product_Order_Price_Book__c> deliveredSOlines=new List<Product_Order_Price_Book__c>();
                    List<Sigma_Order__c> stappOrderRecord=new List<Sigma_Order__c>();
                    stappOrderRecord=[select id,AccountId__c,Billing_Contact__c,Payment_type__c,Contact__c,Delivary_Date__c,Discount__c,Status__c,
                                      BillingStreet__c,BillingCity__c,BillingState__c,BillingPostalCode__c,
                                      BillingCountry__c  ,Shipping_Street__c,ShippingCity__c,ShippingCountry__c,ShippingPostalCode__c
                                      from Sigma_Order__c where id=: dSerialisedpickedData.soId];
                    for(PickingDuplicateDataWrap pddw:dSerialisedpickedData.PickingDuplicateDataWrap){
                        proid.add(pddw.prodId);
                        for(Inventory_Allocation__c ia:pddw.iaData){
                            Product_Order_Price_Book__c sol=new Product_Order_Price_Book__c();
                            sol.Id=ia.Order_Line__c;
                            sol.Picking_Slip__c=dSerialisedpickedData.pickingValues.Id;
                            deliveredSOlines.add(sol);
                            solIdSolMap.put(sol.id,sol);
                            ia.Status__c='Picked';
                            ia.Picking__c=dSerialisedpickedData.pickingValues.id;
                            ia.Picked_Quantity__c=ia.Quantity__c;
                            ia.Order_Line__c=sol.id;
                            iaList.add(ia);
                            if(ILPLIIdQuantMap.containskey(ia.ILPLI__c))
                                ILPLIIdQuantMap.put(ia.ILPLI__c,ILPLIIdQuantMap.get(ia.ILPLI__c)+ia.Picked_Quantity__c);
                            else 
                                ILPLIIdQuantMap.put(ia.ILPLI__c,ia.Picked_Quantity__c);
                            if(prodIdQuantReduceInPIMap.containsKey(pddw.prodId))
                                prodIdQuantReduceInPIMap  .put(pddw.prodId,prodIdQuantReduceInPIMap.get(pddw.prodId)+ia.Picked_Quantity__c);
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
                            //added on 05-09-2019 to reduce Reserve Quantity from Product Inventory allocation in picking
                            inv.Reserved_Qty__c-=prodIdQuantReduceInPIMap.get(inv.ProductCode__c);//////////////
                            invList.add(inv);
                        }
                        if(invList.size()>0)
                            update invList;
                    }
                    if(solIdSolMap.values().size()>0){
                        update solIdSolMap.values();
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
                    createErrorLog.insertError('Picking',e.getMessage(),'Method -sumbitPickedData ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                    Database.rollback(sp);
          
                    rw.message = 'error';
                    rw.data = e.getMessage()+ ', At Line number '+e.getStackTraceString();

                }
            
        //}
        return rw;

    }  
    @AuraEnabled
    public static PickingParentWrap apexStartPicking(String pickingData,string soId)
    {
        PickingParentWrap dSerialisedpickedData=new PickingParentWrap();
        
        /*                if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c','sigmaerpdev__Allocation__c'})
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Picking_Slip__c')
             && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Picking_Slip__c',new Set<String>{'sigmaerpdev__Status__c','sigmaerpdev__Start_Time__c','sigmaerpdev__Sigma_Order__c'})     
 && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Picking_Slip__c',new Set<String>{'Id','Name','sigmaerpdev__Start_Time__c','sigmaerpdev__Status__c','sigmaerpdev__Sigma_Order__c'})  
           
            
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{'id','name'})
              && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Allocation__c',new set<String>{'sigmaerpdev__Status__c'})
           
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'Id'}) 
            
            
       )
       {*/
             Order_Usage__c orderusage=[select Sigma_order__c,Allocation_in_Sales_Order__c,Allocation_in_Picking__c,Auto_Allocate_in_picking__c  from Order_Usage__c Limit 1];
             dSerialisedpickedData=(PickingParentWrap)System.JSON.deserialize(pickingData,PickingParentWrap.class);
            if(orderusage.Sigma_order__c==true)
            {
                dSerialisedpickedData.pickingValues.Status__c='Picked';
                Picking_Slip__c pick=new Picking_Slip__c();
                pick.Start_Time__c=datetime.now();
                pick.Sigma_Order__c=soId; 
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
            }
            try{
            }
            catch(Exception e){ 
            }
           
      // }
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
        
          /*if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c') 
   && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c','sigmaerpdev__Allocation__c'})            
               && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'id','name', 'sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Allocated_User__c','sigmaerpdev__Sigma_Order__r.name','sigmaerpdev__Product__c','sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c','sigmaerpdev__Product__r.ProductCode','sigmaerpdev__Product__r.sigmaerpdev__Product_Bar_Code__c','sigmaerpdev__Quantity__c','sigmaerpdev__Product__r.name'})       
                       && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'Id','name','sigmaerpdev__IsPrinted__c'})
 && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sigma_Order__c',new set<String>{'sigmaerpdev__IsPrinted__c'})                          
         && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c') 
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{'id','name','sigmaerpdev__ILPLI__c','sigmaerpdev__Picked_Quantity__c','sigmaerpdev__Quantity__c','sigmaerpdev__ILPLI__r.sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.name','sigmaerpdev__Status__c'})
              && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Allocation__c',new set<String>{'sigmaerpdev__Status__c'})
       ){*/
           
                Order_Usage__c orderusage=[select Sigma_order__c,Allocation_in_Sales_Order__c,Allocation_in_Picking__c,Auto_Allocate_in_picking__c  from Order_Usage__c Limit 1];
                List<Product_Order_Price_Book__c> solList;
                if(selectedTab=='NotPicked'){
                    
                    
                    if(orderusage.Sigma_order__c==true)
                    {
                        solList=  [select id,name, Sigma_Order__c,Sigma_Order__r.Allocated_User__c,Sigma_Order__r.name,Product__c,Product__r.Attribute_Type__c,Product__r.ProductCode,Product__r.Product_Bar_Code__c,Quantity__c,Product__r.name,
                                   (select id,name,
                                    ILPLI__c,Picked_Quantity__c,Quantity__c,
                                    ILPLI__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.name from Inventory_Allocations1__r where Status__c='') 
                                   from Product_Order_Price_Book__c   where 
                                   Sigma_Order__c=:soIdList];
                    } 
                }
                else if(selectedTab=='Printed'){
                    if(orderusage.Sigma_order__c==true)
                    {                       
                        solList=  [select id,name, Sigma_Order__c,Sigma_Order__r.Allocated_User__c,Sigma_Order__r.name,Product__c,Product__r.Attribute_Type__c,Product__r.ProductCode,Product__r.Product_Bar_Code__c,Quantity__c,Product__r.name, 
                                (select id,name,ILPLI__c,Status__c,Picked_Quantity__c,Quantity__c,ILPLI__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.name from Inventory_Allocations1__r where  Status__c='Printed') 
                                from Product_Order_Price_Book__c   where Sigma_Order__c=:soIdList];
                    }                          
                }
                Map<Id,List<Product_Order_Price_Book__c>> soIdSOLListMap=new Map<Id,List<Product_Order_Price_Book__c>>();
                List<Inventory_Allocation__c> iaListToMakePrinted=new List<Inventory_Allocation__c>();
                for(Product_Order_Price_Book__c sol:solList)
                {
                    if(soIdSOLListMap.containsKey(sol.Sigma_Order__c))
                    {
                        List<Product_Order_Price_Book__c> tempSOLList=soIdSOLListMap.get(sol.Sigma_Order__c);
                        tempSOLList.add(sol);
                        soIdSOLListMap.put(sol.Sigma_Order__c,tempSOLList);
                    }
                    else
                    {
                        List<Product_Order_Price_Book__c> tempSOLList=new List<Product_Order_Price_Book__c>();
                        tempSOLList.add(sol);
                        soIdSOLListMap.put(sol.Sigma_Order__c,tempSOLList);
                    }
                    
                    for(Inventory_Allocation__c ia:sol.Inventory_Allocations1__r)
                    {
                        ia.Status__c='Printed';
                        iaListToMakePrinted.add(ia);
                    }
                }
                if(iaListToMakePrinted.size()>0)
                    update iaListToMakePrinted;
                if(soIdSOLListMap.keySet().size()>0){
                    List<Sigma_Order__c> soList=new List<Sigma_Order__c>();
                    for(Sigma_Order__c so:[select id,name,IsPrinted__c from Sigma_Order__c where id in :soIdSOLListMap.keySet()])
                    {
                        so.IsPrinted__c=true;
                        soList.add(so);
                    }
                    if(soList.size()>0){
                        update soList;
                    }
                }
       //}
        return ppwlist;
    }
    /*********************************************/
    @AuraEnabled
    public static void PickingPrintedOrder(String soID, string solw)
    {
        /*  if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')  
 && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c','sigmaerpdev__Allocation__c'})                         
             && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Picking_Slip__c')
                 && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Picking_Slip__c',new Set<String>{'Id','Name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Status__c'})  
             && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Picking_Slip__c',new Set<String>{'sigmaerpdev__Sigma_Order__c','sigmaerpdev__Status__c'})                                                                                    
             && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c') 
              && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev__Picking_Slip__c'})   
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'id','name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Allocated_User__c','sigmaerpdev__Sigma_Order__r.name','sigmaerpdev__Product__c','sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c','sigmaerpdev__Product__r.ProductCode','sigmaerpdev__Product__r.sigmaerpdev__Product_Bar_Code__c','sigmaerpdev__Quantity__c','sigmaerpdev__Product__r.name','sigmaerpdev__Order_Status__c'})       
             && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'id','sigmaerpdev__isPickingInProgress__c','sigmaerpdev__Customer_Type__c','sigmaerpdev__AccountId__c','sigmaerpdev__Contact__c','sigmaerpdev__Discount__c','sigmaerpdev__BillingStreet__c','sigmaerpdev__BillingCity__c','sigmaerpdev__BillingState__c','sigmaerpdev__BillingPostalCode__c','sigmaerpdev__BillingCountry__c','sigmaerpdev__Shipping_Street__c','sigmaerpdev__ShippingCity__c','sigmaerpdev__ShippingState__c','sigmaerpdev__ShippingPostalCode__c','sigmaerpdev__ShippingCountry__c'})                         
                 && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')                        
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{'id','name','sigmaerpdev__Order_Line__c','sigmaerpdev__Order_Line__r.sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Status__c','sigmaerpdev__Picked_Quantity__c','sigmaerpdev__ILPLI__c','sigmaerpdev__Picking__c', 'sigmaerpdev__ILPLI__r.sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.name'})
              && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Allocation__c',new set<String>{'sigmaerpdev__Status__c','sigmaerpdev__Picking__c','sigmaerpdev__Picked_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new set<String>{   'Id', 'Name','sigmaerpdev__ProductCode__c','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__Total_Available_Qty__c','sigmaerpdev__Delivered_Qty__c','sigmaerpdev__Available_Qty__c','sigmaerpdev__Picked_Quantity__c','sigmaerpdev__Comments__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new set<String>{'sigmaerpdev__ProductCode__c','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__Picked_Quantity__c'})
       )
       {*/
                   List<PickingCtrl.sigmaOrderLineWrapper>sigmaOrderLineWrapper;
                if(solw!=null)
                {
                    sigmaOrderLineWrapper =  (List<PickingCtrl.sigmaOrderLineWrapper>)System.JSON.deserialize(solw, List<PickingCtrl.sigmaOrderLineWrapper>.class); 
                } 
                Map<id,decimal> ILPLIIdQuantMap=new Map<Id,Decimal>();
                Order_Usage__c orderusage=[select Sigma_order__c,Allocation_in_Sales_Order__c,Allocation_in_Picking__c,Auto_Allocate_in_picking__c  from Order_Usage__c Limit 1];
                Picking_Slip__c pick=new Picking_Slip__c();
                pick.Sigma_Order__c=soID;
                pick.Status__c='Picked';
                insert pick;
                List<Product_Order_Price_Book__c> solList;
                List<Sigma_Order__c> stappOrderRecord=new List<Sigma_Order__c>();
                if(orderusage.Sigma_order__c==true)
                {
                    solList=[select id,name,Sigma_Order__c,Sigma_Order__r.Allocated_User__c,Sigma_Order__r.name,Product__c,Product__r.Attribute_Type__c,Product__r.ProductCode,Product__r.Product_Bar_Code__c,Quantity__c,Product__r.name,
                             (select id,name,Order_Line__c,Order_Line__r.Product__c,Quantity__c,Status__c,Picked_Quantity__c,ILPLI__c,Picking__c , ILPLI__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.name from Inventory_Allocations1__r ) 
                             from Product_Order_Price_Book__c   where 
                             Sigma_Order__c=:soID AND  Order_Status__c='Order Confirmed' and id in (select Order_Line__c from Inventory_Allocation__c where Status__c=:'Printed')];
                    stappOrderRecord=[select id,isPickingInProgress__c,Customer_Type__c,AccountId__c,Contact__c,Discount__c,
                                      BillingStreet__c,BillingCity__c,BillingState__c
                                      ,BillingPostalCode__c,   BillingCountry__c,Shipping_Street__c,ShippingCity__c,ShippingState__c,ShippingPostalCode__c,
                                      ShippingCountry__c from Sigma_Order__c where id=: soID];
                }
                List<Id>productIDs=new List<Id>();
                Map<ID,Decimal>prodIdQuantReduceInPIMap=new Map<ID,Decimal>();
                List<Inventory_Allocation__c> iaList=new List<Inventory_Allocation__c>();
                List<Product_Order_Price_Book__c> solListToUpdate=new List<Product_Order_Price_Book__c>();
                List<Product_Order_Price_Book__c> deliveredSOlines=new List<Product_Order_Price_Book__c>();
                for(Product_Order_Price_Book__c sol:solList)
                {
                    sol.Picking_Slip__c=pick.Id;
                    deliveredSOlines.add(sol);        
                    solListToUpdate.add(sol);
                    if(orderusage.Sigma_order__c==true)
                    {
                        for(Inventory_Allocation__c ia:sol.Inventory_Allocations1__r)
                        {
                            ia.Status__c='Picked';
                            ia.Picking__c=pick.id;
                            ia.Picked_Quantity__c=ia.Quantity__c;
                            iaList.add(ia); 
                            if(ILPLIIdQuantMap.containskey(ia.ILPLI__c)) ILPLIIdQuantMap.put(ia.ILPLI__c,ILPLIIdQuantMap.get(ia.ILPLI__c)+ia.Picked_Quantity__c);
                            else
                                ILPLIIdQuantMap.put(ia.ILPLI__c,ia.Picked_Quantity__c);
                            if(prodIdQuantReduceInPIMap.containsKey(ia.Order_Line__r.Product__c))
                                prodIdQuantReduceInPIMap.put(ia.Order_Line__r.Product__c,prodIdQuantReduceInPIMap.get(ia.Order_Line__r.Product__c)+ia.Picked_Quantity__c);
                            else     prodIdQuantReduceInPIMap.put(ia.Order_Line__r.Product__c,ia.Picked_Quantity__c);
                        }
                    }
                }
                if(solListToUpdate.size()>0){
                    update solListToUpdate;
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
                
                    for(Inventory__c inv:[select id,name,ProductCode__c,Reserved_Qty__c,Total_Available_Qty__c,Delivered_Qty__c,Available_Qty__c,Picked_Quantity__c,Comments__c from Inventory__c where ProductCode__c in:prodIdQuantReduceInPIMap.keySet() ])
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