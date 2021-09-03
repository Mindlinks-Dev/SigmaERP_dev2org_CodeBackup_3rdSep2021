public with sharing class PackageCtrl 
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
             createErrorLog.insertError('Package',e.getMessage(),'Method -fetchProductImageInformation ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                    
            }
       // }
         return productimagecontent;
    }


    @AuraEnabled
    public static Map<String,List<PackagedProducts__c>> validateSalesOrder(Id OrderId)
    {
        /* if(
        CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new Set<String>{'Id','Name'})
             &&   CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'id','name','sigmaerpdev__Sigma_Order__r.Name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Package__c','sigmaerpdev__Package__r.Name','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Package__r.sigmaerpdev__Status__c'})
        )
        {*/
            try{
                List<PackagedProducts__c> pakageProductlist=[select id,name,Sigma_Order__r.Name,Sigma_Order__c,Package__c,Package__r.Name,Product__c,Product__r.Name,Package__r.Status__c   from PackagedProducts__c where Sigma_Order__c=:OrderId];
                if(pakageProductlist.size()>0)
                {
                    Map<String,List<PackagedProducts__c>>packProducts=new Map<String,List<PackagedProducts__c>>();
                    packProducts.put('Found',pakageProductlist);
                    return packProducts;
                }
                }catch(Exception e)
                {
                    System.debug('e'+e);
                
                }
        //}
        return null; 
    }
    @AuraEnabled
    public static Map<String,List<PackagedProducts__c>> validateStandardOrder(Id OrderId)
    {
        /*if(
        CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new Set<String>{'Id','Name'})
             &&   CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'sigmaerpdev__Order__c','id','name','sigmaerpdev__Sigma_Order__r.Name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Package__c','sigmaerpdev__Package__r.Name','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Package__r.sigmaerpdev__Status__c'})
        )
        {*/
            try{
                List<PackagedProducts__c> pakageProductlist=[select id,name,Sigma_Order__r.Name,Sigma_Order__c,Order__c,Package__c,Package__r.Name,Product__c,Product__r.Name,Package__r.Status__c  from PackagedProducts__c where Order__c=:OrderId];
                if(pakageProductlist.size()>0)
                {
                    Map<String,List<PackagedProducts__c>>packProducts=new Map<String,List<PackagedProducts__c>>();
                    packProducts.put('Found',pakageProductlist);
                    return packProducts;
                }
                }catch(Exception e)
                {
                    System.debug('e'+e);
                
                }
        //}
        return null; 
    }
     @AuraEnabled
    public static String deletePackageRecordById(Id packageId)
    {
        /* if(
        CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new Set<String>{'Id','Name'})
             &&   CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'Id','Name'})
        )
        {*/
            try{        
                List<Package__c> packagelist = [select id,Name,(select id,Name from PackagedProducts__r) from Package__c where id = :packageId];
                delete packagelist[0].PackagedProducts__r;    
                delete packagelist;
                return 'success';
                }catch(Exception e)
                {
                
                }
        //}
        return null; 
    }
     @AuraEnabled
    public static PackagePaginationHelper fetchPackageList(Integer pageNumber)
    {
         PackagePaginationHelper pph=new PackagePaginationHelper();
         /*if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')  
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c','sigmaerpdev__Allocation__c'})                      
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new Set<String>{'Id', 'Name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.Name','sigmaerpdev__Status__c','sigmaerpdev__PackagedDate__c','sigmaerpdev__Customer__c','sigmaerpdev__Customer__r.Name','createddate','sigmaerpdev__Order__c','sigmaerpdev__Order__r.OrderNumber'})
            &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
              &&   CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'Id','Name'})
            )
            {*/
                try{        
                    Order_Usage__c ou=[select Id,Name, Allocation__c,Allocation_in_Picking__c,Allocation_in_Sales_Order__c,Auto_Allocate_in_picking__c,Sigma_order__c,Standard_object__c  from Order_Usage__c limit 1];
                    Integer pageSize = 10;
                    Integer offset = ((Integer)pageNumber - 1) * pageSize;
                    pph.pageSize=pageSize;
                    pph.page= (Integer) pageNumber;
                    if(ou.Sigma_order__c==true)
                    {
                        //Code Added for FFTB
            Id CommUserId= UserInfo.getUserId();
            User currentuser = [select Id,Profile.Name,Contact.AccountId from User where Id =: CommUserId];
            Community_Configuration__c CommCustset= [select Id,Name,Retailer_Community_URL__c,Products_Per_Page__c,Retailer_Profile_Name__c,Vendor_Community_URL__c,Vendor_Profile_Name__c from Community_Configuration__c where Name = 'Community Configurations' LIMIT 1];
            if(currentuser.Profile.Name == CommCustset.Retailer_Profile_Name__c)
            {
              pph.total= [SELECT count() FROM Package__c where Sigma_Order__c!=null and Sigma_Order__r.Brewer_Account__c =: currentuser.Contact.AccountId];
              pph.packageList= [select id,Name,Sigma_Order__c,Sigma_Order__r.Brewer_Account__c,Sigma_Order__r.Brewer_Account__r.Name,Sigma_Order__r.Name,Status__c,PackagedDate__c,Customer__c,Customer__r.Name,(select id,Name from PackagedProducts__r) from Package__c where Sigma_Order__c!=null and Sigma_Order__r.Brewer_Account__c =: currentuser.Contact.AccountId
                                          order by createddate desc limit :pageSize offset :offset]; 
            }
            else
            {
              pph.total= [SELECT count() FROM Package__c where Sigma_Order__c!=null ];
                        pph.packageList= [select id,Name,Sigma_Order__c,Sigma_Order__r.Name,Status__c,PackagedDate__c,Customer__c,Customer__r.Name,(select id,Name from PackagedProducts__r) from Package__c where Sigma_Order__c!=null
                                          order by createddate desc limit :pageSize offset :offset];
            }
                
                        /*pph.total= [SELECT count() FROM Package__c where Sigma_Order__c!=null ];
                        pph.packageList= [select id,Name,Sigma_Order__c,Sigma_Order__r.Name,Status__c,PackagedDate__c,Customer__c,Customer__r.Name,(select id,Name from PackagedProducts__r) from Package__c where Sigma_Order__c!=null
                                          order by createddate desc limit :pageSize offset :offset];*/
                    } 
                    else if(ou.Standard_object__c==true)
                    {
                        pph.total= [SELECT count() FROM Package__c where Order__c!=null ];
                        pph.packageList= [select id,Name,Status__c,PackagedDate__c,Order__c,Order__r.OrderNumber,Customer__c,Customer__r.Name,(select id,Name from PackagedProducts__r) from Package__c where Order__c!=null
                                          order by createddate desc limit :pageSize offset :offset];
                    }
                }catch(Exception e)
                {
                }
                
          //  }
        return pph;
    }
    @AuraEnabled
    public static Boolean fetchPackageDetails(String Id)
    {
        /*if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')  
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c','sigmaerpdev__Allocation__c'})                      
            )
            {*/
                Order_Usage__c ou=[select Id,Name,Allocation__c,Allocation_in_Picking__c,Allocation_in_Sales_Order__c,Auto_Allocate_in_picking__c,Sigma_order__c,Standard_object__c  from Order_Usage__c limit 1];
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
    public static Boolean fetchDefaultParameters()
    {
        /*if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')  
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new set<String>{'Id', 'Name','sigmaerpdev__Inventory_Status__c'})                        
            )   
            {*/
                Default_Parameters__c dp=[select id,Name,Inventory_Status__c from Default_Parameters__c limit 1];
                if(dp.Inventory_Status__c!='Reserve')
                {
                    return false;
                }
                else
                {
                }  
            //}
            return true;
    }
    //code to show a validation for cash customer name 27-01-2020
        @AuraEnabled
    public static decimal fetchdueamount(String SOId)
    {
        decimal dueamount =0;
            /*if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')  
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'Id', 'Name','sigmaerpdev__Due_Amount__c','sigmaerpdev__Customer_Type__c'})                         
             && CRUD_FLS_CheckUtility.checkObjCRUD('Order')  
            && CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'Id','sigmaerpdev__Due_Amount__c','sigmaerpdev__Customer_Type__c'})                         
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')  
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c','sigmaerpdev__Allocation__c'})                      
           
           )   
            {*/
                   Order_Usage__c ou=[select Id,Name,Allocation__c,Allocation_in_Picking__c,Allocation_in_Sales_Order__c,Auto_Allocate_in_picking__c,Sigma_order__c,Standard_object__c  from Order_Usage__c limit 1];
             
                 if(ou.Sigma_order__c==true)
                {
                    Sigma_Order__c SO = [Select id,Name,Due_Amount__c,Customer_Type__c from Sigma_Order__c where id =:SOId limit 1];
                    if(SO.Customer_Type__c =='Cash Customer')
                    {
                        dueamount =SO.Due_Amount__c;
                    }
                }
                else{
                    Order SO = [Select id,Due_Amount__c,Customer_Type__c from Order where id =:SOId limit 1];
                    if(SO.Customer_Type__c =='Cash Customer')
                    {
                        dueamount =SO.Due_Amount__c;
                    }
                    
                }
                
            //}
        return dueamount;
    }
    //code added by rashmi on 24-07-2019
    @AuraEnabled
    public static Boolean SelectOrders()
    {
            /*    if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')  
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c','sigmaerpdev__Allocation__c'})                      
            )
            {*/
                Order_Usage__c ou=[select Id,Name,Allocation__c,Allocation_in_Picking__c,Allocation_in_Sales_Order__c,Auto_Allocate_in_picking__c,Sigma_order__c,Standard_object__c  from Order_Usage__c limit 1];
                if(ou.Sigma_order__c==true)
                {
                    return true;
                }
                else
                {
                }
                
            //}
            return false;
    }
    public class PackageProductWrap
    {
        @auraEnabled
        public PackagedProducts__c ppLineItemRec{get;set;}
        @auraEnabled
        public String productName{get;set;}
        @auraEnabled
        public Decimal orderedQuantity{get;set;}
        @auraEnabled
        public Inventory_Location_Product_Line_Item__c ilpliData{get;set;}
        @auraEnabled
        public Product_Order_Price_Book__c solData{get;set;}
        @auraEnabled
        public OrderItem olData{get;set;} //code added by rashmi to handle package for standard order on 24-07-2019
        @auraEnabled
        public Boolean isSerialCodeMandatory{get;set;}  
        public PackageProductWrap(PackagedProducts__c ppLineItemRec,String productName,Decimal orderedQuantity,Inventory_Location_Product_Line_Item__c ilpliData /*,String compId*/,Product_Order_Price_Book__c solData,OrderItem olData,Boolean isSerialCodeMandatory)
        {
            this.ppLineItemRec = ppLineItemRec;
            this.productName = productName;
            this.orderedQuantity = orderedQuantity;
            this.ilpliData = ilpliData;
            this.solData=solData;
            this.olData=olData; //code added by rashmi to handle package for standard order on 24-07-2019
            this.isSerialCodeMandatory=isSerialCodeMandatory;
        }
    }
    
    public class PackageEditWrap
    {
        @auraEnabled
        public Package__c pData{get;set;}
        @auraEnabled
        public List<packageProductEditWrap> ppsow{get;set;}
    }
    public class packageProductEditWrap
    {
        @auraEnabled
        public string SOId{get;set;}
        @auraEnabled
        public string SOName{get;set;}
        @auraEnabled
        public List<packageLinItemsEditWrap> packageLinItems{get;set;}
    }
    public class packageLinItemsEditWrap
    {
        @auraEnabled
        public PackagedProducts__c ppLineItemRec{get;set;}
        @auraEnabled
        public Inventory_Location_Product_Line_Item__c ilpliData{get;set;}
        @auraEnabled
        public String productName{get;set;}
        @auraEnabled
        public Decimal orderedQuantity{get;set;}
    }
    
    @auraEnabled
    public static PackageEditWrap fetchPackageDataForEdit(String pId,String customername)
    {
        PackageEditWrap pew=new PackageEditWrap();
            /*if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')  
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new set<String>{'Id', 'Name','sigmaerpdev__Inventory_Status__c'})                        
            &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new Set<String>{'Id', 'Name','sigmaerpdev__Status__c','sigmaerpdev__PackagedDate__c','sigmaerpdev__Customer__c','sigmaerpdev__Customer__r.Name'})
            &&   CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'Id','Name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Product_Order__r.sigmaerpdev__Remaining_Qty_For_Package__c','sigmaerpdev__Sigma_Order__r.name','sigmaerpdev__Product__c','sigmaerpdev__Product__r.name','sigmaerpdev__Quantity__c','sigmaerpdev__Status__c','sigmaerpdev__Package__c','sigmaerpdev__Product_Order__c','sigmaerpdev__Product_Order__r.sigmaerpdev__Quantity__c','sigmaerpdev__Product_Order__r.sigmaerpdev__Remaining_Qty_To_Package__c'})    
            )
            {*/
                Default_Parameters__c dp=[select id,Name,Inventory_Status__c from  Default_Parameters__c limit 1];
                if(dp.Inventory_Status__c!='Reserve')
                {
                    return null;
                }
                else
                {
                    
                    if(pId!=null )
                    {
                        
                        pew.pData=[select id,name,Customer__c,Customer__r.name,Status__c,PackagedDate__c from Package__c where id=:pId];
                    }
                    else 
                    {
                        pew.pData=[select id,name,Customer__c,Customer__r.name,Status__c,PackagedDate__c from Package__c where Customer__r.name=:customername];
                    }
                    Map<ID,String> soNameMap = new Map<ID,String>();
                    Map<String,List<packageLinItemsEditWrap>> ppMap = new Map<String,List<packageLinItemsEditWrap>>();
                    if(pId!=null)
                    {
                        
                        for(PackagedProducts__c temppp:[select id,name,Sigma_Order__c,Product_Order__r.Remaining_Qty_For_Package__c,Sigma_Order__r.name,Product__c,Product__r.name,Quantity__c,Status__c,Package__c,Product_Order__c,Product_Order__r.Quantity__c,Product_Order__r.Remaining_Qty_To_Package__c from PackagedProducts__c where Package__c=:pId]) //,IsInventoryUpdated__c
                        {                               
                            soNameMap.put(temppp.Sigma_Order__c,temppp.Sigma_Order__r.name);
                            if(ppMap.containskey(temppp.Sigma_Order__c))
                            {
                                packageLinItemsEditWrap ppsw=new packageLinItemsEditWrap(); 
                                ppsw.ppLineItemRec= temppp;
                                ppsw.productName= temppp.Product__r.name;
                                ppsw.orderedQuantity= temppp.Product_Order__r.Remaining_Qty_For_Package__c;
                                ppMap.get(temppp.Sigma_Order__c).add(ppsw);
                            }
                            else
                            {
                                List<packageLinItemsEditWrap> ppswList=new List<packageLinItemsEditWrap>();
                                packageLinItemsEditWrap ppsw=new packageLinItemsEditWrap();
                                ppsw.ppLineItemRec= temppp;
                                ppsw.productName= temppp.Product__r.name;
                                ppsw.orderedQuantity= temppp.Product_Order__r.Remaining_Qty_For_Package__c;
                                ppswList.add(ppsw);
                                ppMap.put(temppp.Sigma_Order__c,ppswList);
                            }
                        }
                    }
                    else
                    {
                        for(PackagedProducts__c temppp:[select id,name,Sigma_Order__c,Sigma_Order__r.name,Product__c,Product__r.name,Quantity__c,Status__c,Package__c,Product_Order__c,Product_Order__r.Quantity__c,Product_Order__r.Remaining_Qty_To_Package__c,Product_Order__r.Remaining_Qty_For_Package__c from PackagedProducts__c where Package__c=:pew.pData.id]) //,IsInventoryUpdated__c
                        {           
                            soNameMap.put(temppp.Sigma_Order__c,temppp.Sigma_Order__r.name);
                            if(ppMap.containskey(temppp.Sigma_Order__c))
                            {
                                packageLinItemsEditWrap ppsw=new packageLinItemsEditWrap(); 
                                ppsw.ppLineItemRec= temppp;
                                ppsw.productName= temppp.Product__r.name;
                                ppsw.orderedQuantity= temppp.Product_Order__r.Remaining_Qty_For_Package__c;
                                ppMap.get(temppp.Sigma_Order__c).add(ppsw);
                            }
                            else
                            {
                                List<packageLinItemsEditWrap> ppswList=new List<packageLinItemsEditWrap>();
                                packageLinItemsEditWrap ppsw=new packageLinItemsEditWrap();
                                ppsw.ppLineItemRec= temppp;
                                ppsw.productName= temppp.Product__r.name;
                                ppsw.orderedQuantity= temppp.Product_Order__r.Remaining_Qty_For_Package__c;
                                ppswList.add(ppsw);
                                ppMap.put(temppp.Sigma_Order__c,ppswList);
                            }
                        }
                    }
                    List<packageProductEditWrap> ppewList = new List<packageProductEditWrap>();
                    for(String uniqueTrans: ppMap.keySet())
                    {
                        String soID = uniqueTrans;
                        packageProductEditWrap ppew = new packageProductEditWrap();
                        ppew.SOId = soID;
                        ppew.SOName = soNameMap.get(soID);
                        ppew.packageLinItems = ppMap.get(uniqueTrans);
                        ppewList.add(ppew);
                    }
                    pew.ppsow=ppewList;
                    
                }
                
            //}
            return pew;
    }
    //code added by rashmi to handle package for standard order on 24-07-2019
         @auraEnabled
    public static PackageEditWrap fetchPackageOrderDataForEdit(String pId,String customername)
    {
         PackageEditWrap pew=new PackageEditWrap();
        /*if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')  
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new set<String>{'Id', 'Name','sigmaerpdev__Inventory_Status__c'})                        
            &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')  
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new Set<String>{'Id', 'Name','sigmaerpdev__Status__c','sigmaerpdev__PackagedDate__c','sigmaerpdev__Customer__c','sigmaerpdev__Customer__r.Name'})
            &&   CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'Id','Name','sigmaerpdev__Quantity__c','sigmaerpdev__Status__c','sigmaerpdev__Package__c','sigmaerpdev__Order__c','sigmaerpdev__Order__r.OrderNumber','sigmaerpdev__Order_Product__c','sigmaerpdev__Order_Product__r.sigmaerpdev__Remaining_Qty_For_Package__c','sigmaerpdev__Order_Product__r.Quantity','sigmaerpdev__Order_Product__r.sigmaerpdev__Remaining_Qty_To_Package__c','sigmaerpdev__Product__c','sigmaerpdev__Product__r.name'}) 
            ) 
            {*/
                    Default_Parameters__c dp=[select id,Name,Inventory_Status__c from  Default_Parameters__c limit 1];
                    if(dp.Inventory_Status__c!='Reserve')
                    {
                        return null;
                    }
                    else
                    {

                        if(pId!=null )
                        {
                            pew.pData=[select id,name,Customer__c,Customer__r.name,Status__c,PackagedDate__c from Package__c where id=:pId];
                        }
                        else 
                        {
                            pew.pData=[select id,name,Customer__c,Customer__r.name,Status__c,PackagedDate__c from Package__c where Customer__r.name=:customername];
                        }
                        Map<ID,String> soNameMap = new Map<ID,String>();
                        Map<String,List<packageLinItemsEditWrap>> ppMap = new Map<String,List<packageLinItemsEditWrap>>();
                        if(pId!=null)
                        {
                            for(PackagedProducts__c temppp:[select id,name,Quantity__c,Status__c,Package__c,Order__c,Order__r.OrderNumber,Order_Product__c,Order_Product__r.Remaining_Qty_For_Package__c,Order_Product__r.Quantity,Order_Product__r.Remaining_Qty_To_Package__c,Product__c,Product__r.name from PackagedProducts__c where Package__c=:pId]) //,IsInventoryUpdated__c
                            {                                           
                                soNameMap.put(temppp.Order__c,temppp.Order__r.OrderNumber);
                                if(ppMap.containskey(temppp.Order__c))
                                {
                                    packageLinItemsEditWrap ppsw=new packageLinItemsEditWrap(); 
                                    ppsw.ppLineItemRec= temppp;
                                    ppsw.productName= temppp.Product__r.name;
                                    ppsw.orderedQuantity= temppp.Order_Product__r.Remaining_Qty_For_Package__c;
                                    ppMap.get(temppp.Order__c).add(ppsw);
                                }
                                else
                                {
                                    List<packageLinItemsEditWrap> ppswList=new List<packageLinItemsEditWrap>();
                                    packageLinItemsEditWrap ppsw=new packageLinItemsEditWrap();
                                    ppsw.ppLineItemRec= temppp;
                                    ppsw.productName= temppp.Product__r.name;
                                    ppsw.orderedQuantity= temppp.Order_Product__r.Remaining_Qty_For_Package__c;
                                    ppswList.add(ppsw);
                                    ppMap.put(temppp.Order__c,ppswList);
                                }
                            }
                        }
                        else
                        {
                            for(PackagedProducts__c temppp:[select id,name,Order__c,Order__r.OrderNumber,Quantity__c,Status__c,Package__c,Order_Product__c,Order_Product__r.Quantity,Order_Product__r.Remaining_Qty_To_Package__c, Product__c,Product__r.name
                                                                         from PackagedProducts__c where Package__c=:pew.pData.id]) //,IsInventoryUpdated__c
                            {                                       
                                soNameMap.put(temppp.Order__c,temppp.Order__r.OrderNumber);
                                if(ppMap.containskey(temppp.Order__c))
                                {
                                    packageLinItemsEditWrap ppsw=new packageLinItemsEditWrap(); 
                                    ppsw.ppLineItemRec= temppp;
                                    ppsw.productName= temppp.Product__r.name;
                                    ppsw.orderedQuantity= temppp.Order_Product__r.Remaining_Qty_For_Package__c;
                                    ppMap.get(temppp.Order__c).add(ppsw);
                                }
                                else
                                {
                                    List<packageLinItemsEditWrap> ppswList=new List<packageLinItemsEditWrap>();
                                    packageLinItemsEditWrap ppsw=new packageLinItemsEditWrap();
                                    ppsw.ppLineItemRec= temppp;
                                    ppsw.productName= temppp.Product__r.name;
                                    ppsw.orderedQuantity= temppp.Order_Product__r.Remaining_Qty_For_Package__c;
                                    ppswList.add(ppsw);
                                    ppMap.put(temppp.Order__c,ppswList);
                                }
                            }
                        }
                        List<packageProductEditWrap> ppewList = new List<packageProductEditWrap>();
                        for(String uniqueTrans: ppMap.keySet())
                        {
                            String soID = uniqueTrans;
                            packageProductEditWrap ppew = new packageProductEditWrap();
                            ppew.SOId = soID;
                            ppew.SOName = soNameMap.get(soID);
                            ppew.packageLinItems = ppMap.get(uniqueTrans);
                            ppewList.add(ppew);
                        }
                        pew.ppsow=ppewList;
                        
                    }
                
           // }           
        
        
        return pew;
    }   
   
   
     @AuraEnabled
    public static void deletePPLines(List<PackagedProducts__c> ppList)
    {
        /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'Id','Name'})
         )
         {*/
                if(ppList.size()>0)
                {
                    delete ppList;
                } 
        // }
       
    }
     @auraEnabled
    public static List<PackageProductWrap> fetchStappOrderItems(Id soID,Id basketId)
    {
           List<PackageProductWrap> ppWrapList=new List<PackageProductWrap>();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
            &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new Set<String>{'sigmaerpdev__Order_Line__c','sigmaerpdev__Status__c'})           
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'Id','Name','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Quantity__c','sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Remaining_Qty_To_Package__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Shipping_Street__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__ShippingCity__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__ShippingState__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__ShippingPostalCode__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__ShippingCountry__c','sigmaerpdev__Sigma_Order__r.Name','sigmaerpdev__Sigma_Order__r.sigmaerpdev__AccountId__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__AccountId__r.Name','sigmaerpdev__Order_Status__c','sigmaerpdev__Remaining_Qty_For_Package__c','sigmaerpdev__IsInventoryUpdated__c','sigmaerpdev__In_Progress_In_Package__c'})
         &&   CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'Id','Name','sigmaerpdev__Quantity__c','sigmaerpdev__Status__c','sigmaerpdev__Product__c','sigmaerpdev__Product_Order__c'})  
        &&   CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new Set<String>{'Id'})    
         
        )
         {*/
            List<Product_Order_Price_Book__c> solList;
            if(!string.isEmpty(soID))
            {     
                solList=[select id,name,Product__c,Product__r.name,Quantity__c,Packaged_Quantity__c,Remaining_Qty_To_Package__c,Sigma_Order__c,Sigma_Order__r.Shipping_Street__c,Sigma_Order__r.ShippingCity__c,Sigma_Order__r.ShippingState__c,Sigma_Order__r.ShippingPostalCode__c,Sigma_Order__r.ShippingCountry__c,Sigma_Order__r.name,Sigma_Order__r.AccountId__c,Sigma_Order__r.AccountId__r.name,Order_Status__c,Remaining_Qty_For_Package__c from Product_Order_Price_Book__c where Sigma_Order__c =:soID and IsInventoryUpdated__c=true and Remaining_Qty_To_Package__c>0 and Order_Status__c='Order Confirmed' And In_Progress_In_Package__c=false And id in(select  Order_Line__c  from Inventory_Allocation__c where Status__c=:'Picked')];// changed sigmaerpdev__Remaining_Qty_To_Package__c from sigmaerpdev__Remaining_Qty_For_Package__c and added sigmaerpdev__Order_Status__c='Order Confirmed     
            }           
            for(Product_Order_Price_Book__c indSOL:solList){
                PackagedProducts__c pp=new PackagedProducts__c();
                pp.Product__c=indSOL.Product__c;
                pp.Quantity__c=indSOL.Remaining_Qty_To_Package__c;// changed sigmaerpdev__Remaining_Qty_To_Package__c   from sigmaerpdev__Remaining_Qty_For_Package__c on 15-11-2019
                pp.Status__c='In Progress';
                pp.Product_Order__c=indSOL.id;
                ppWrapList.add(new PackageProductWrap(pp,indSOL.Product__r.name,indSOL.Remaining_Qty_To_Package__c,null,indSOL,null,null));// changed sigmaerpdev__Remaining_Qty_To_Package__c   from sigmaerpdev__Remaining_Qty_For_Package__c on 15-11-2019
            }
            
         //}
        return ppWrapList;
    }
    //code added by rashmi to handle package for standard order on 24-07-2019
      @auraEnabled
    public static List<PackageProductWrap> fetchStandOrderItems(Id soID,Id basketId)
    {
        List<PackageProductWrap> ppWrapList=new List<PackageProductWrap>();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
            &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new Set<String>{'sigmaerpdev__Order_Product__c','sigmaerpdev__Status__c'})  
            &&CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new Set<String>{'Id','Name','Product2Id','Product2.Name','Quantity','sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Remaining_Qty_To_Package__c','OrderId','Order.sigmaerpdev__Shipping_Street__c','Order.sigmaerpdev__ShippingCity__c','Order.sigmaerpdev__ShippingState__c','Order.sigmaerpdev__ShippingPostalCode__c','Order.sigmaerpdev__ShippingCountry__c','Order.OrderNumber','Order.AccountId','Order.Account.Name','sigmaerpdev__Order_Status__c','sigmaerpdev__Remaining_Qty_For_Package__c','sigmaerpdev__IsInventoryUpdated__c','sigmaerpdev__In_Progress_In_Package__c'})
         &&   CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'Id','Name','sigmaerpdev__Quantity__c','sigmaerpdev__Status__c','sigmaerpdev__Product__c','sigmaerpdev__Order_Product__c'})  
        &&   CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            &&CRUD_FLS_CheckUtility.checkReadPermission('Order',new Set<String>{'Id'})  
        )
         { */
            List<OrderItem> olList;
            if(!string.isEmpty(soID))
            {
                olList=[select id,Product2Id,Product2.name,Quantity,Packaged_Quantity__c,Remaining_Qty_To_Package__c,OrderId,Order.Shipping_Street__c,Order.ShippingCity__c,Order.ShippingState__c,Order.ShippingPostalCode__c,Order.ShippingCountry__c,Order.OrderNumber,Order.AccountId,Order.Account.name,Order_Status__c,Remaining_Qty_For_Package__c from OrderItem where OrderId =:soID and IsInventoryUpdated__c=true and Remaining_Qty_To_Package__c>0 and Order_Status__c='Order Confirmed' And  In_Progress_In_Package__c=false And id in(select Order_Product__c    from Inventory_Allocation__c where Status__c='Picked')];  // added sigmaerpdev__Order_Status__c='Order Confirmed'   on 15-11-2019
            }               
            for(OrderItem indOL:olList){
                PackagedProducts__c pp=new PackagedProducts__c();
                pp.Product__c=indOL.Product2Id;
                pp.Quantity__c=indOL.Remaining_Qty_To_Package__c;// changed sigmaerpdev__Remaining_Qty_To_Package__c   from sigmaerpdev__Remaining_Qty_For_Package__c on 15-11-2019
                pp.Status__c='In Progress';
                pp.Order_Product__c=indOL.id;
                ppWrapList.add(new PackageProductWrap(pp,indOL.Product2.name,indOL.Remaining_Qty_To_Package__c,null,null,indOL,null));// changed sigmaerpdev__Remaining_Qty_To_Package__c   from sigmaerpdev__Remaining_Qty_For_Package__c on 15-11-2019
            }
        // }
        return ppWrapList;
    }
    @AuraEnabled
    public static BasketDetailsWrap getBasketInfo(String stappOrderId)
    {
         BasketDetailsWrap basketDet =null;
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Picking_Slip__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Picking_Slip__c',new Set<String>{'Id','Name','sigmaerpdev__Sigma_Order__c'})
            &&   CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new Set<String>{'Id','Name'}) 
            &&   CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'Id','Name','sigmaerpdev__Product__c','sigmaerpdev__Product_Bar_Code__c'})   
        )
        {*/
            List<Picking_Slip__c> pickingObj = [select id,Name,Sigma_Order__c from Picking_Slip__c  where Sigma_Order__c = :stappOrderId];
            List<Id>lis=new List<Id>();
            FOR(Picking_Slip__c ps: pickingObj)
            {
                lis.add(ps.Sigma_Order__c);
            }
            List<Sigma_Order__c>sos=[SELECT ID, NAME,(select id,name,Product__c,Product__r.Product_Bar_Code__c from Order_Lines__r) FROM  Sigma_Order__c WHERE ID=:  lis];
             basketDet = new BasketDetailsWrap(sos[0].Order_Lines__r[0].Product__r.Product_Bar_Code__c, null, null, null, null,null, '');     
        //}
        return basketDet;
    }
    //code added by rashmi to handle package for standard order on 24-07-2019
    @AuraEnabled
    public static BasketDetailsWrap getBasketInfoFromOrder(String stappOrderId){
         BasketDetailsWrap basketDet=null;
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Picking_Slip__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Picking_Slip__c',new Set<String>{'Id','Name','sigmaerpdev__Order__c'})
            &&   CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            &&CRUD_FLS_CheckUtility.checkReadPermission('Order',new Set<String>{'Id','OrderNumber'}) 
            &&   CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
             &&CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new Set<String>{'Id','Product2Id','Product2.sigmaerpdev__Product_Bar_Code__c'})
          )
        {*/
            List<Picking_Slip__c> pickingObj = [select id,Name,Order__c from Picking_Slip__c  where Order__c = :stappOrderId];
            List<Id>lis=new List<Id>();
            FOR(Picking_Slip__c ps: pickingObj)
            {
                lis.add(ps.Order__c);
            }
            List<Order> ords=[select id,OrderNumber,(select id,Product2Id,Product2.Product_Bar_Code__c from OrderItems) FROM  Order WHERE id=: lis];
             basketDet = new BasketDetailsWrap(ords[0].OrderItems[0].Product2.Product_Bar_Code__c, null, null, null, null,null, ''); 
                
       // } 
        return basketDet;
    }
    //added on 7/3/2019 for basket scode scanning
    public class BasketDetailsWrap
    {
        @AuraEnabled
        public String basketBarCode{get;set;}
        @AuraEnabled
        public String custName{get;set;}
        @AuraEnabled
        public Id custId{get;set;}
        @AuraEnabled
        public String stappOrderName{get;set;}
        @AuraEnabled
        public String standOrderNumber{get;set;}
        @AuraEnabled
        public Id stappOrderId{get;set;}    
        @AuraEnabled
        public String msg{get;set;}
        public BasketDetailsWrap(String baskBarCode, String cusName, Id cusId, String stappOrdName, String stappOrdNum,Id stappOrdId, String message){
            this.basketBarCode = baskBarCode;
            this.custName = cusName;
            this.custId = cusId;
            this.stappOrderName = stappOrdName;
            this.standOrderNumber = stappOrdNum;
            this.stappOrderId = stappOrdId;  
            this.msg = message;
        }
    }
     @auraEnabled
    public static responseWrapper savePackage(String packageData,String ppData,Boolean proceedToShipmentFlag)
    {
         responseWrapper rw = new responseWrapper();
       /*  if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
          &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new Set<String>{'Id','Name','sigmaerpdev__Sigma_Order__c'})
             &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Package__c',new Set<String>{'sigmaerpdev__Sigma_Order__c'})
              &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
               &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'Id','Name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Package__c','sigmaerpdev__Status__c','sigmaerpdev__Product_Order__c','sigmaerpdev__Quantity__c','sigmaerpdev__Product__c'})
        &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__PackagedProducts__c',new Set<String>{'sigmaerpdev__Sigma_Order__c','sigmaerpdev__Package__c'})
        &&   CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new Set<String>{'Id','Name'})
            &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Picking_Slip__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Picking_Slip__c',new Set<String>{'Id','Name','sigmaerpdev__Status__c'})
             && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{ 'Id','Name','sigmaerpdev__Quantity__c','sigmaerpdev__Order_Line__c','sigmaerpdev__Order_Line__r.sigmaerpdev__Sigma_Order__c','sigmaerpdev__Packaged_Product__c','sigmaerpdev__ILPLI__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Allocation__c',new set<String>{ 'sigmaerpdev__Quantity__c','sigmaerpdev__Packaged_Product__c','sigmaerpdev__ILPLI__c'})
            &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev__In_Progress_In_Package__c','Id','Name','sigmaerpdev__Remaining_Qty_To_Package__c','sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Remaining_Qty_For_Package__c','sigmaerpdev__Order_Status__c'})
            &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev__In_Progress_In_Package__c','sigmaerpdev__Remaining_Qty_To_Package__c','sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Order_Status__c'})
             &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')  
              &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new Set<String>{'Id','Name','sigmaerpdev__ProductCode__c','sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Picked_Quantity__c','sigmaerpdev__Delivered_Qty__c','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__Total_Available_Qty__c' })
    &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new Set<String>{'sigmaerpdev__ProductCode__c','sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Picked_Quantity__c' })
        )
        {*/
                Savepoint sp;
                try{
                    sp= Database.setSavepoint();
                    Package__c packageDataToSave=(Package__c)System.JSON.deserialize(packageData,Package__c.class);
                    System.debug('packageDataToSave>>'+packageDataToSave);
                    List<PackageProductSaveOuterWrap> PPSOW=(List<PackageProductSaveOuterWrap>)System.JSON.deserialize(ppData,List<PackageProductSaveOuterWrap>.class);
                     System.debug('PPSOW>>'+PPSOW);
                    if(PPSOW.size()>0 && PPSOW[0].SOId!=null)
                    {
                        packageDataToSave.Sigma_Order__c=PPSOW[0].SOId;
                        upsert packageDataToSave;
                    }
                     System.debug('packageDataToSave>>'+packageDataToSave);
                    List<PackagedProducts__c> ppListToSave=new List<PackagedProducts__c>();
                    Map<id,decimal> ILPLIIdQuantMap=new Map<Id,Decimal>();
                    List<Inventory_Allocation__c> IAListToInsert=new List<Inventory_Allocation__c>();
                    List<Product_Order_Price_Book__c> solToUpdate=new List<Product_Order_Price_Book__c>();
                    Map<Id,Id> soIdCompIdForPIUpdate=new Map<Id,Id>();
                    Map<Id,String> soIdPickedStatusForILPLIUpdate=new Map<Id,String>();
                    Map<Id,Decimal> prodIdCompIdQauntForPIUpdate=new Map<Id,Decimal>();
                    List<String> sericodelist=new List<String>();
                    System.debug('PPSOW>>'+PPSOW);
                    for(PackageProductSaveOuterWrap indPPData:PPSOW)
                    {
                        System.debug('indPPData>>'+indPPData);
                        for(PackageProductSaveWrap ppsw:indPPData.packageLinItems)
                        {
                            System.debug('ppsw>>'+ppsw);
                            PackagedProducts__c tempPP=new PackagedProducts__c();
                            tempPP=ppsw.ppLineItemRec;
                            tempPP.Sigma_Order__c=indPPData.SOId;
                            soIdCompIdForPIUpdate.put(indPPData.SOId,null);
                            if(tempPP.Package__c==null)
                            {
                                tempPP.Package__c=packageDataToSave.id;
                            }
                            ppListToSave.add(tempPP);
                        }
                    }
                    System.debug('ppListToSave>>'+ppListToSave);
                    if(ppListToSave.size()>0)
                    {
                        upsert ppListToSave;
                    }
                    //////////////////////// added 08-04-2020
                    Map<Id,PackagedProducts__c>mapOfLinItemsPackageProducts=new Map<Id,PackagedProducts__c>();
                    System.debug('ppListToSave'+ppListToSave);
                    for(PackagedProducts__c pp:ppListToSave)
                    { 
                        System.debug('ppListToSave'+ppListToSave);
                        if(pp.Status__c=='In Progress')
                        {
                            mapOfLinItemsPackageProducts.put(pp.Product_Order__c,pp);
                            
                        }
                        
                    }
                    System.debug('mapOfLinItemsPackageProducts'+mapOfLinItemsPackageProducts);
                    if(mapOfLinItemsPackageProducts.keySet().size()>0)
                    {
                        List<Product_Order_Price_Book__c>popListINProgree22=[select id,name,In_Progress_In_Package__c from Product_Order_Price_Book__c where id  =: mapOfLinItemsPackageProducts.keySet()];
                    System.debug('popListINProgree22'+popListINProgree22);
                    List<Product_Order_Price_Book__c>popListINProgree22New=new List<Product_Order_Price_Book__c>();
                    
                    for(Product_Order_Price_Book__c pop:popListINProgree22)
                    {
                        pop.In_Progress_In_Package__c=true;
                        System.debug('pop'+pop);
                        popListINProgree22New.add(pop);
                        
                    }
                    System.debug('popListINProgree22New'+popListINProgree22New);
                    if(popListINProgree22New.size()>0)
                    {
                        update popListINProgree22New;
                    }
                        
                    }
                    
                    ////////////////////
                    
                    
                    System.debug('soIdCompIdForPIUpdate>>'+soIdCompIdForPIUpdate);
                    for(Sigma_Order__c so:[select id,Name,(select id,name,Status__c from Picking_Slips__r) from Sigma_Order__c where id=:soIdCompIdForPIUpdate.keySet()]){
                        soIdPickedStatusForILPLIUpdate.put(so.id,so.Picking_Slips__r.size()>0? so.Picking_Slips__r[0].Status__c : null );
                    }
                    Map<Id,decimal> solIdQuantMap=new Map<Id,Decimal>();
                    Map<Id,Id> solIdPPIdMap=new Map<Id,Id>();
                    Map<id,decimal> prodIdQuantReduceInPIMap=new Map<Id,Decimal>();
                    List<Id> ppIdListToUpdate=new List<Id>();
                    for(PackageProductSaveOuterWrap indPPData:PPSOW)
                    {
                        System.debug('indPPData>>'+indPPData);
                        for(PackageProductSaveWrap ppsw:indPPData.packageLinItems)
                        { 
                            System.debug('ppsw>>'+ppsw);
                            if(ppsw.ppLineItemRec.Status__c=='Ready' )
                            {
                                System.debug('ppsw.ilpliData>>'+ppsw.ilpliData);
                                if(ppsw.ilpliData!=null)
                                {
                                    for(ILPLISaveWrap ilplisw:ppsw.ilpliData)
                                    {
                                        if(ilplisw.enteredQuant!=null)
                                        {
                                            if(ILPLIIdQuantMap.containskey(ilplisw.id))
                                            {
                                                ILPLIIdQuantMap.put(ilplisw.id,ILPLIIdQuantMap.get(ilplisw.id)+ilplisw.enteredQuant);
                                            }
                                            else
                                            {
                                                ILPLIIdQuantMap.put(ilplisw.id,ilplisw.enteredQuant);
                                            }
                                            Inventory_Allocation__c indIA=new Inventory_Allocation__c();
                                            indIA.ILPLI__c=ilplisw.id;
                                            indIA.Packaged_Product__c=ppsw.ppLineItemRec.id;
                                            indIA.Quantity__c=ilplisw.enteredQuant;
                                            IAListToInsert.add(indIA);
                                        }
                                    }
                                    solIdQuantMap.put(ppsw.ppLineItemRec.Product_Order__c,ppsw.ppLineItemRec.Quantity__c);
                                    ppIdListToUpdate.add(ppsw.ppLineItemRec.id);
                                }
                                else
                                {
                                    solIdQuantMap.put(ppsw.ppLineItemRec.Product_Order__c,ppsw.ppLineItemRec.Quantity__c);
                                    ppIdListToUpdate.add(ppsw.ppLineItemRec.id);
                                    solIdPPIdMap.put(ppsw.ppLineItemRec.Product_Order__c,ppsw.ppLineItemRec.Id);
                                }
                                if(prodIdQuantReduceInPIMap.containsKey(ppsw.ppLineItemRec.Product__c))
                                {
                                    prodIdQuantReduceInPIMap.put(ppsw.ppLineItemRec.Product__c,prodIdQuantReduceInPIMap.get(ppsw.ppLineItemRec.Product__c)+ppsw.ppLineItemRec.Quantity__c);
                                }   
                                else
                                {
                                    prodIdQuantReduceInPIMap.put(ppsw.ppLineItemRec.Product__c,ppsw.ppLineItemRec.Quantity__c);
                                }
                                Boolean soPickedFlag=(soIdPickedStatusForILPLIUpdate.get(indPPData.SOId)!='Picked' && soIdPickedStatusForILPLIUpdate.get(indPPData.SOId)!='Manual Pick');
                            }
                        }
                    }
                    List<Inventory_Allocation__c> iaList1=new List<Inventory_Allocation__c>();
                    for(Inventory_Allocation__c indIA:[select id,name,Quantity__c,Order_Line__c,Order_Line__r.Sigma_Order__c,Packaged_Product__c,ILPLI__c from Inventory_Allocation__c where Order_Line__c in:solIdQuantMap.keyset()])
                    { 
                        if(soIdPickedStatusForILPLIUpdate.get(indIA.Order_Line__r.Sigma_Order__c)!='Manual Pick')
                        {
                            if(ILPLIIdQuantMap.containskey(indIA.ILPLI__c))
                            {
                                ILPLIIdQuantMap.put(indIA.ILPLI__c,ILPLIIdQuantMap.get(indIA.ILPLI__c)+indIA.Quantity__c);
                            }
                            else
                            {
                                ILPLIIdQuantMap.put(indIA.ILPLI__c,indIA.Quantity__c);
                            }
                        }
                        indIA.Packaged_Product__c=solIdPPIdMap.get(indIA.Order_Line__c);
                        iaList1.add(indIA);
                    }
                    if(iaList1.size()>0)
                    {
                        update iaList1;
                    }
                    if(solIdQuantMap.size()>0)
                    {
                        List<Product_Order_Price_Book__c> solToUpdateAfterPackage=[select id,name,Remaining_Qty_To_Package__c,Packaged_Quantity__c,Remaining_Qty_For_Package__c   ,Order_Status__c from Product_Order_Price_Book__c where id in :solIdQuantMap.keyset()]; 
                        for(Product_Order_Price_Book__c tempSOL:solToUpdateAfterPackage)
                        {       
                            if(tempSOL.Packaged_Quantity__c==null)
                                tempSOL.Packaged_Quantity__c=0;
                            tempSOL.Packaged_Quantity__c+=solIdQuantMap.get(tempSOL.id);
                            tempSOL.Remaining_Qty_To_Package__c-=tempSOL.Packaged_Quantity__c;
                            tempSOL.Order_Status__c='Packaged';
                        }
                        update solToUpdateAfterPackage;
                    }
                    if(IAListToInsert.size()>0)
                    {
                        insert IAListToInsert;// changed 07-08-2018 from insert to upsert
                    }
                    if(prodIdQuantReduceInPIMap.size()>0)
                    {
                        List<Inventory__c> invList=new List<Inventory__c>();
                        for(Inventory__c inv:[select id,name,ProductCode__c,Packaged_Quantity__c,Picked_Quantity__c,Delivered_Qty__c,Reserved_Qty__c,Total_Available_Qty__c from Inventory__c where ProductCode__c in:prodIdQuantReduceInPIMap.keySet()])
                        {       
                            if(inv.Packaged_Quantity__c==null)
                                inv.Packaged_Quantity__c=0;
                            inv.Packaged_Quantity__c+=prodIdQuantReduceInPIMap.get(inv.ProductCode__c);
                            if(inv.Picked_Quantity__c!=null)
                                inv.Picked_Quantity__c-=prodIdQuantReduceInPIMap.get(inv.ProductCode__c);//////////////////////////////
                            invList.add(inv);
                        }
                        
                        if(invList.size()>0)
                        {
                            update invList;
                        }
                    }
                    if(ILPLIIdQuantMap.size()>0)
                    {
                        InventoryManagement.reduceInventoryoutbound(ILPLIIdQuantMap,'Package');
                    }
                    Package__c pk=[select id,name from Package__c where id=:packageDataToSave.Id  limit 1];
                    if(pk!=null)
                    {
                        rw.message = 'success';
                        rw.data = pk.Name+','+packageDataToSave.Id;
                    }
                    
                }
                catch(Exception e)
                {
                    createErrorLog.insertError('Package',e.getMessage(),'Method -savePackage ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                    Database.rollback(sp);
                    rw.message = 'error';
                    rw.data = e.getMessage()+ ', At Line number '+e.getStackTraceString();
                }
        //}
      
        return rw; 
    }
    //code added by rashmi to handle package for standard order on 24-07-2019
     @auraEnabled
    public static responseWrapper saveOrderPackage(String packageData,String ppData,Boolean proceedToShipmentFlag)
    {
         responseWrapper rw = new responseWrapper();
        /*    if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new Set<String>{'Id','Name','sigmaerpdev__Order__c'})
             &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Package__c',new Set<String>{'sigmaerpdev__Order__c'})
              &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
               &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'Id','Name','sigmaerpdev__Order__c','sigmaerpdev__Package__c','sigmaerpdev__Status__c','sigmaerpdev__Order_Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Product__c'})
            &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__PackagedProducts__c',new Set<String>{'sigmaerpdev__Order__c','sigmaerpdev__Package__c'})
            &&   CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            &&CRUD_FLS_CheckUtility.checkReadPermission('Order',new Set<String>{'Id'})
            &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Picking_Slip__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Picking_Slip__c',new Set<String>{'Id','Name','sigmaerpdev__Status__c'})
             && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{ 'Id','Name','sigmaerpdev__Quantity__c','sigmaerpdev__Order_Product__c','sigmaerpdev__Order_Product__r.OrderId','sigmaerpdev__Packaged_Product__c','sigmaerpdev__ILPLI__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Allocation__c',new set<String>{'sigmaerpdev__Quantity__c','sigmaerpdev__Packaged_Product__c','sigmaerpdev__ILPLI__c'})
            &&CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
            &&CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new Set<String>{'sigmaerpdev__In_Progress_In_Package__c','Id','sigmaerpdev__Remaining_Qty_To_Package__c','sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Remaining_Qty_For_Package__c','sigmaerpdev__Order_Status__c'})
            &&CRUD_FLS_CheckUtility.checkFLS('OrderItem',new Set<String>{'sigmaerpdev__In_Progress_In_Package__c','sigmaerpdev__Remaining_Qty_To_Package__c','sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Order_Status__c'})
            &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')   
              &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new Set<String>{'Id','Name','sigmaerpdev__ProductCode__c','sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Picked_Quantity__c','sigmaerpdev__Delivered_Qty__c','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__Total_Available_Qty__c' })
            &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new Set<String>{'sigmaerpdev__ProductCode__c','sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Picked_Quantity__c' })
        )
        {*/
                Savepoint sp;
                try{
                    sp= Database.setSavepoint();
                    Package__c packageDataToSave=(Package__c)System.JSON.deserialize(packageData,Package__c.class);
                    List<PackageProductSaveOuterWrap> PPSOW=(List<PackageProductSaveOuterWrap>)System.JSON.deserialize(ppData,List<PackageProductSaveOuterWrap>.class);
                    if(PPSOW.size()>0 && PPSOW[0].SOId!=null)
                    {
                        packageDataToSave.Order__c=PPSOW[0].SOId;
                        upsert packageDataToSave;
                    }
                    List<PackagedProducts__c> ppListToSave=new List<PackagedProducts__c>();
                    Map<id,decimal> ILPLIIdQuantMap=new Map<Id,Decimal>();
                    List<Inventory_Allocation__c> IAListToInsert=new List<Inventory_Allocation__c>();
                    List<OrderItem> olToUpdate=new List<OrderItem>();
                    Map<Id,Id> soIdCompIdForPIUpdate=new Map<Id,Id>();
                    Map<Id,String> soIdPickedStatusForILPLIUpdate=new Map<Id,String>();
                    Map<Id,Decimal> prodIdCompIdQauntForPIUpdate=new Map<Id,Decimal>();
                    List<String> sericodelist=new List<String>();
                    for(PackageProductSaveOuterWrap indPPData:PPSOW)
                    {
                        for(PackageProductSaveWrap ppsw:indPPData.packageLinItems)
                        {
                            PackagedProducts__c tempPP=new PackagedProducts__c();
                            tempPP=ppsw.ppLineItemRec;
                            tempPP.Order__c=indPPData.SOId;
                            soIdCompIdForPIUpdate.put(indPPData.SOId,null);
                            if(tempPP.Package__c==null)
                            {
                                tempPP.Package__c=packageDataToSave.id;
                            }
                            ppListToSave.add(tempPP);
                        }
                    }
                    if(ppListToSave.size()>0)
                    {
                        upsert ppListToSave;
                    }
                    //////////////////////// added 08-04-2020
                    Map<Id,PackagedProducts__c>mapOfLinItemsPackageProducts=new Map<Id,PackagedProducts__c>();
                    System.debug('ppListToSave'+ppListToSave);
                    for(PackagedProducts__c pp:ppListToSave)
                    {   
                        System.debug('ppListToSave'+ppListToSave);
                        if(pp.Status__c=='In Progress')
                        {
                            mapOfLinItemsPackageProducts.put(pp.Order_Product__c,pp);
                            
                        }
                        
                    }
                    System.debug('mapOfLinItemsPackageProducts'+mapOfLinItemsPackageProducts);
                    if(mapOfLinItemsPackageProducts.keySet().size()>0)
                    {
                        List<OrderItem>popListINProgree22=[select id,In_Progress_In_Package__c  from OrderItem where id  =: mapOfLinItemsPackageProducts.keySet()];
                    System.debug('popListINProgree22'+popListINProgree22);
                    List<OrderItem>popListINProgree22New=new List<OrderItem>();
                    
                    for(OrderItem oI:popListINProgree22)
                    {
                        oI.In_Progress_In_Package__c   =true;
                        System.debug('oI'+oI);
                        popListINProgree22New.add(oI);
                        
                    }
                    System.debug('popListINProgree22New'+popListINProgree22New);
                    if(popListINProgree22New.size()>0)
                    {
                        update popListINProgree22New;
                    }
                        
                    }
                    
                    ////////////////////
                    
                    
                    
                    
                    for(Order so:[select id,(select id,name,Status__c from Picking_Slips__r) from Order where id=:soIdCompIdForPIUpdate.keySet()]){
                        soIdPickedStatusForILPLIUpdate.put(so.id,so.Picking_Slips__r.size()>0? so.Picking_Slips__r[0].Status__c : null );
                    }
                    Map<Id,decimal> solIdQuantMap=new Map<Id,Decimal>();
                    Map<Id,Id> solIdPPIdMap=new Map<Id,Id>();
                    Map<id,decimal> prodIdQuantReduceInPIMap=new Map<Id,Decimal>();
                    List<Id> ppIdListToUpdate=new List<Id>();
                    for(PackageProductSaveOuterWrap indPPData:PPSOW)
                    {
                        for(PackageProductSaveWrap ppsw:indPPData.packageLinItems)
                        { 
                            if(ppsw.ppLineItemRec.Status__c=='Ready' )
                            {
                                if(ppsw.ilpliData!=null)
                                {
                                    for(ILPLISaveWrap ilplisw:ppsw.ilpliData)
                                    {
                                        if(ilplisw.enteredQuant!=null)
                                        {
                                            if(ILPLIIdQuantMap.containskey(ilplisw.id))
                                            {
                                                ILPLIIdQuantMap.put(ilplisw.id,ILPLIIdQuantMap.get(ilplisw.id)+ilplisw.enteredQuant);
                                            }
                                            else
                                            {
                                                ILPLIIdQuantMap.put(ilplisw.id,ilplisw.enteredQuant);
                                            }
                                            Inventory_Allocation__c indIA=new Inventory_Allocation__c();
                                            indIA.ILPLI__c=ilplisw.id;
                                            indIA.Packaged_Product__c=ppsw.ppLineItemRec.id;
                                            indIA.Quantity__c=ilplisw.enteredQuant;
                                            IAListToInsert.add(indIA);
                                        }
                                    }
                                    solIdQuantMap.put(ppsw.ppLineItemRec.Order_Product__c,ppsw.ppLineItemRec.Quantity__c);
                                    ppIdListToUpdate.add(ppsw.ppLineItemRec.id);
                                }
                                else
                                {
                                    solIdQuantMap.put(ppsw.ppLineItemRec.Order_Product__c,ppsw.ppLineItemRec.Quantity__c);
                                    ppIdListToUpdate.add(ppsw.ppLineItemRec.id);
                                    solIdPPIdMap.put(ppsw.ppLineItemRec.Order_Product__c,ppsw.ppLineItemRec.Id);
                                }
                                if(prodIdQuantReduceInPIMap.containsKey(ppsw.ppLineItemRec.Product__c))
                                {
                                    prodIdQuantReduceInPIMap.put(ppsw.ppLineItemRec.Product__c,prodIdQuantReduceInPIMap.get(ppsw.ppLineItemRec.Product__c)+ppsw.ppLineItemRec.Quantity__c);
                                }   
                                else
                                {
                                    prodIdQuantReduceInPIMap.put(ppsw.ppLineItemRec.Product__c,ppsw.ppLineItemRec.Quantity__c);
                                }
                                Boolean soPickedFlag=(soIdPickedStatusForILPLIUpdate.get(indPPData.SOId)!='Picked' && soIdPickedStatusForILPLIUpdate.get(indPPData.SOId)!='Manual Pick');
                            }
                        }
                    }
                    List<Inventory_Allocation__c> iaList1=new List<Inventory_Allocation__c>();
                    for(Inventory_Allocation__c indIA:[select id,name,Quantity__c,Order_Product__c,Order_Product__r.OrderId,Packaged_Product__c,ILPLI__c from Inventory_Allocation__c where Order_Product__c in:solIdQuantMap.keyset()])
                    {       
                        if(soIdPickedStatusForILPLIUpdate.get(indIA.Order_Product__r.OrderId)!='Manual Pick')
                        {
                            if(ILPLIIdQuantMap.containskey(indIA.ILPLI__c))
                            {
                                ILPLIIdQuantMap.put(indIA.ILPLI__c,ILPLIIdQuantMap.get(indIA.ILPLI__c)+indIA.Quantity__c);
                            }
                            else
                            {
                                ILPLIIdQuantMap.put(indIA.ILPLI__c,indIA.Quantity__c);
                            }
                        }
                        indIA.Packaged_Product__c=solIdPPIdMap.get(indIA.Order_Product__c);
                        iaList1.add(indIA);
                    }
                    if(iaList1.size()>0)
                    {
                        update iaList1;
                    }
                    if(solIdQuantMap.size()>0)
                    {
                        List<OrderItem> solToUpdateAfterPackage=[select id,Remaining_Qty_To_Package__c,Packaged_Quantity__c,Remaining_Qty_For_Package__c,Order_Status__c from OrderItem where id in :solIdQuantMap.keyset()]; 
                        for(OrderItem tempSOL:solToUpdateAfterPackage)
                        {   
                            if(tempSOL.Packaged_Quantity__c==null)
                            {
                                tempSOL.Packaged_Quantity__c=0;
                            }
                            tempSOL.Packaged_Quantity__c+=solIdQuantMap.get(tempSOL.id);
                            tempSOL.Remaining_Qty_To_Package__c-=tempSOL.Packaged_Quantity__c;
                            tempSOL.Order_Status__c='Packaged';
                        }
                        update solToUpdateAfterPackage;
                    }
                    if(IAListToInsert.size()>0)
                    {
                        Insert IAListToInsert;
                    }
                    if(prodIdQuantReduceInPIMap.size()>0)
                    {
                        List<Inventory__c> invList=new List<Inventory__c>();
                        for(Inventory__c inv:[select id,name,ProductCode__c,Packaged_Quantity__c,Picked_Quantity__c,Delivered_Qty__c,Reserved_Qty__c,Total_Available_Qty__c from Inventory__c where ProductCode__c in:prodIdQuantReduceInPIMap.keySet()])
                        {                       
                            if(inv.Packaged_Quantity__c==null)
                                inv.Packaged_Quantity__c=0;
                            inv.Packaged_Quantity__c+=prodIdQuantReduceInPIMap.get(inv.ProductCode__c);
                            if(inv.Picked_Quantity__c!=null)
                                inv.Picked_Quantity__c-=prodIdQuantReduceInPIMap.get(inv.ProductCode__c);
                            invList.add(inv);
                        }
                        if(invList.size()>0)
                        {
                            update invList;
                        }
                    }
					 if(ILPLIIdQuantMap.size()>0)
                    {
                        InventoryManagement.reduceInventoryoutbound(ILPLIIdQuantMap,'Package');
                    }
                    
                    
                    Package__c pk=[select id,name from Package__c where id =:packageDataToSave.Id  limit 1];
                    if(pk!=null)
                    {
                        rw.message = 'success';
                        rw.data = pk.Name+','+packageDataToSave.Id;
                    }
                    //rw.message = 'success';
                    //rw.data  =packageDataToSave.Name+','+packageDataToSave.Id;
                }
                catch(Exception e)
                {
                    Database.rollback(sp);
                    rw.message = 'error';
                    rw.data = e.getMessage()+ ', At Line number '+e.getStackTraceString();
                }
        //}
        
        return rw;  
    }
    public class responseWrapper
    {
        @auraEnabled
        public String message{get;set;}
        @auraEnabled
        public String data{get;set;}
    }
    public class PackageProductSaveOuterWrap
    {
        @auraEnabled
        public string SOId{get;set;}
        @auraEnabled
        public List<PackageProductSaveWrap> packageLinItems{get;set;}
    }
    public class PackageProductSaveWrap
    {
        @auraEnabled
        public PackagedProducts__c ppLineItemRec{get;set;}
        @auraEnabled
        public String productName{get;set;}
        @auraEnabled
        public Decimal orderedQuantity{get;set;}
        @auraEnabled
        public String StockSelectedAs{get;set;}
        @auraEnabled
        public List<ILPLISaveWrap> ilpliData{get;set;}
    }
    public class ILPLISaveWrap
    {
        @auraEnabled
        public id Id{get;set;}
        @auraEnabled
        public Decimal enteredQuant{get;set;}
    }
}