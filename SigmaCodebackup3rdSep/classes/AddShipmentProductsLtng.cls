/*------------------------------------------------------------
Author: Javed
Company: Mindlinks Solution
Description: A code coverage for the UpdateOrderCancellation
Inputs:  "Shipment" - Add Shipment Products
"Shipment Product" - Update Add Shipment Products  values. 


Test Class: AddShipmentProductsLtng
History
<Date>         <Authors Name>   <Brief Description of Change>

12-12-2016     chandana           Added FLS .
------------------------------------------------------------*/

public with sharing class AddShipmentProductsLtng
{
    @AuraEnabled
    public static Boolean SelectPackages()
    {
               /* if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')  
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Auto_Allocate_in_picking__c','sigmaerpdev__Allocation__c'})                      
            )
            {*/
             try{
               Order_Usage__c ou=[select Allocation__c,Allocation_in_Picking__c,Allocation_in_Sales_Order__c,Auto_Allocate_in_picking__c,Sigma_order__c,Standard_object__c  from Order_Usage__c limit 1];
                if(ou.Sigma_order__c==true)
                {
                    return true;
                }
                else
                {
                }
            
             }catch(Exception e)
                {
                String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                    createErrorLog.insertError('AddShipmentProductsLtng',ex,'Method -SelectPackages ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                    //Database.rollback(sp);
              }
              
                
           // }
            return false;
    }
        @AuraEnabled
    public static Map<String,List<Shipment_Products__c>> FindDuplicatePackage(Id packageId)
    {
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Shipment__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')  
         && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c'})

             &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Shipment_Products__c')
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Shipment__c',new Set<String>{'id','Name'})
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Shipment_Products__c',new Set<String>{'id', 'name', 'sigmaerpdev__Shipment__c','sigmaerpdev__Package_ID__c','sigmaerpdev__Package_ID__r.Name','sigmaerpdev__Shipment__r.Name'}))
                 {*/
        
        try{    
        System.debug('packageId>>'+packageId);
         
            List<Shipment_Products__c> shipmentLinelist = [select id, name, Shipment__c,Package_ID__c,Package_ID__r.Name,Shipment__r.Name    from Shipment_Products__c where Package_ID__c=:packageId ];
            System.debug('shipmentLinelist>>'+shipmentLinelist);
            
            if(shipmentLinelist.size()>0)
            {
                Map<String,List<Shipment_Products__c>>map1=new Map<String,List<Shipment_Products__c>>();
                map1.put('Found',shipmentLinelist);
                return map1;
            }
            
        }catch(Exception e)
        {
        String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                    createErrorLog.insertError('AddShipmentProductsLtng',ex,'Method -FindDuplicatePackage ',null,'',e.getStackTraceString(),UserInfo.getUserId());
             
            System.debug('Exception in Delete>>>>>'+e.getMessage());
           
        }
     //}
     return null;
    }   

    
        @AuraEnabled
    public static String deleteShipmentRecordById(Id shipmentId)
    {
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Shipment__c')
             &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Shipment_Products__c')
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Shipment__c',new Set<String>{'id','Name','sigmaerpdev__Status__c','sigmaerpdev__Courier_Status__c','sigmaerpdev__Selected_Courier__c','sigmaerpdev__Customer_Email__c','sigmaerpdev__Tracking_ID__c','sigmaerpdev__Shipment_Date__c'})
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Shipment_Products__c',new Set<String>{'id','Name'}))
                 {*/
        
        try{        
            List<Shipment__c> shipmentlist = [select id,Name,Status__c,Courier_Status__c,Selected_Courier__c,Customer_Email__c,Tracking_ID__c,Shipment_Date__c,(select id,Name from Shipment_Products__r) from Shipment__c where id = :shipmentId];
            delete shipmentlist[0].Shipment_Products__r;    
            delete shipmentlist;
            return 'success';
        }catch(Exception e)
        {
            String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                    createErrorLog.insertError('AddShipmentProductsLtng',ex,'Method -deleteShipmentRecordById ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                   
            System.debug('Exception in Delete>>>>>'+e.getMessage());
           
        }
     //}
     return null;
    }   

    @AuraEnabled
    public static PackagePaginationHelper.ShipmentPaginationHelper fetchShipmentList(Integer pageNumber)
    {
                PackagePaginationHelper.ShipmentPaginationHelper sph=new PackagePaginationHelper.ShipmentPaginationHelper();

        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Shipment__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Shipment_Products__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Shipment__c',new Set<String>{'id','Name','sigmaerpdev__Status__c','sigmaerpdev__Courier_Status__c','sigmaerpdev__Selected_Courier__c','sigmaerpdev__Customer_Email__c','sigmaerpdev__Tracking_ID__c','sigmaerpdev__Shipment_Date__c','createddate'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Shipment_Products__c',new Set<String>{'id','Name'}))
                {   */            
        
        try{        
            
            Integer pageSize = 10;
            Integer offset = ((Integer)pageNumber - 1) * pageSize;
            sph.pageSize=pageSize;
            sph.page= (Integer) pageNumber;
      
      //Code Added for FFTB
            Id CommUserId= UserInfo.getUserId();
            User currentuser = [select Id,Profile.Name,Contact.AccountId from User where Id =: CommUserId];
            Community_Configuration__c CommCustset= [select Id,Name,Retailer_Community_URL__c,Products_Per_Page__c,Retailer_Profile_Name__c,Vendor_Community_URL__c,Vendor_Profile_Name__c from Community_Configuration__c where Name = 'Community Configurations' LIMIT 1];
            if(currentuser.Profile.Name == CommCustset.Retailer_Profile_Name__c)
            { 
              SET<String> Idss = new SET<String>();
              List<Shipment_Products__c> SHPList = new List<Shipment_Products__c>();
              SHPList = [select id,Name,Shipment__c from Shipment_Products__c where Package_ID__r.Sigma_Order__r.Brewer_Account__c =: currentuser.Contact.AccountId];
              
              if(SHPList.size() > 0)
              {
                for(Shipment_Products__c SHO : SHPList)
                {
                  Idss.add(SHO.Shipment__c);
                }
                sph.total= [SELECT count() FROM Shipment__c where Id IN : Idss];
                sph.ShipmentList= [select id,Name,Status__c,Courier_Status__c,Selected_Courier__c,Customer_Email__c,Tracking_ID__c,Shipment_Date__c,(select id,Name from Shipment_Products__r) from Shipment__c where Id IN : Idss
                order by createddate desc limit :pageSize offset :offset];
              }
              /*else
              {
                sph.total= [SELECT count() FROM Shipment__c];
                sph.ShipmentList= [select id,Name,Status__c,Courier_Status__c,Selected_Courier__c,Customer_Email__c,Tracking_ID__c,Shipment_Date__c,(select id,Name from Shipment_Products__r) from Shipment__c
                order by createddate desc limit :pageSize offset :offset];
              }*/
              
            }
            else
            {
              sph.total= [SELECT count() FROM Shipment__c];
              sph.ShipmentList= [select id,Name,Status__c,Courier_Status__c,Selected_Courier__c,Customer_Email__c,Tracking_ID__c,Shipment_Date__c,(select id,Name from Shipment_Products__r) from Shipment__c
                              order by createddate desc limit :pageSize offset :offset];
            }
            /*sph.total= [SELECT count() FROM Shipment__c];
            sph.ShipmentList= [select id,Name,Status__c,Courier_Status__c,Selected_Courier__c,Customer_Email__c,Tracking_ID__c,Shipment_Date__c,(select id,Name from Shipment_Products__r) from Shipment__c
                              order by createddate desc limit :pageSize offset :offset];*/
        }catch(Exception e)
        {
            String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                    createErrorLog.insertError('AddShipmentProductsLtng',ex,'Method -fetchShipmentList ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                   
            System.debug('Exception in Delete>>>>>'+e.getMessage());
            
        }
        
      
               // }
                  return sph;
    }
    
    @AuraEnabled
    public static List<String> getStockInProductStatus(){
        List<String> options = new List<String>();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Shipment_Products__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Shipment_Products__c',new set<String>{'sigmaerpdev__Status__c'})
          ){*/
           try{
               Schema.DescribeFieldResult fieldResult = Shipment_Products__c.Status__c.getDescribe();
                  options.add('--Select--');
                  List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                  for (Schema.PicklistEntry f: ple) {
                      options.add(f.getLabel());
                  }
             
             }catch(Exception e)
                {
                String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                    createErrorLog.insertError('AddShipmentProductsLtng',ex,'Method -getStockInProductStatus ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                    //Database.rollback(sp);
              }
              
         // }
        return options;
    }
    @AuraEnabled
    public static List<String> getShipmentStatus(){
        List<String> options = new List<String>();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Shipment__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Shipment__c',new set<String>{'sigmaerpdev__Status__c'})
          ){ */
          try{
          Schema.DescribeFieldResult fieldResult = Shipment__c.Status__c.getDescribe();
              options.add('--Select--');
              List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
              for (Schema.PicklistEntry f: ple) {
                  options.add(f.getLabel());
              } 
          }catch(Exception e)
                {
                String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                    createErrorLog.insertError('AddShipmentProductsLtng',ex,'Method -getShipmentStatus ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                    //Database.rollback(sp);
              }
              
          //}       
        return options;
    }
    
    
    @AuraEnabled
    public static Shipment__c saveShipment(Shipment__c ShipmentObj,String shipmentProduts) 
    {
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Shipment__c')
          && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Shipment_Products__c')
          && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
          && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
          && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
          && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
          && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
          && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
          && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
          && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
          && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Shipment_Products__c',new Set<String>{'sigmaerpdev__Shipment__c'})
          && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Shipment_Products__c',new Set<String>{'sigmaerpdev__Package_ID__c','sigmaerpdev__Customer_Name__c','sigmaerpdev__Shipment_Delivery_Date__c','sigmaerpdev__Status__c'})     
          && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new set<String>{'Id','sigmaerpdev__Status__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.ShippingCountry__c','sigmaerpdev__Sigma_Order__r.ShippingState__c','sigmaerpdev__Sigma_Order__r.ShippingCity__c','sigmaerpdev__Sigma_Order__r.Shipping_Street__c','sigmaerpdev__Sigma_Order__r.ShippingPostalCode__c','sigmaerpdev__Customer__c','sigmaerpdev__Customer__r.sigmaerpdev__Email__c', 'sigmaerpdev__Order__c','sigmaerpdev__Order__r.sigmaerpdev__Shipping_Street__c','sigmaerpdev__Order__r.sigmaerpdev__ShippingCity__c','sigmaerpdev__Order__r.sigmaerpdev__ShippingCountry__c','sigmaerpdev__Order__r.sigmaerpdev__ShippingState__c','sigmaerpdev__Order__r.sigmaerpdev__ShippingPostalCode__c '}) 
          && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Package__c',new set<String>{'sigmaerpdev__Status__c'}) 
          && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Shipment_Products__c',new Set<String>{'Id','Name','sigmaerpdev__Order__r.id','sigmaerpdev__Package_ID__r.Id','sigmaerpdev__Shipment__r.id','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Package_ID__c','sigmaerpdev__Order__c','sigmaerpdev__Shipment_Delivery_Date__c','sigmaerpdev__Status__c','sigmaerpdev__Shipment__c '})
          && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'id','name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.RecordType.Name','sigmaerpdev__Order_Product__c','sigmaerpdev__Product_Order__c','sigmaerpdev__Quantity__c','sigmaerpdev__Product__c','sigmaerpdev__Order__c','sigmaerpdev__Package__c'})
          && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c'})
          && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'id','RecordTypeId','RecordType.Name'})
          && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new Set<String>{'id','name','Packaged_Quantity__c','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__ProductCode__c','sigmaerpdev__Shipped_Qty__c','sigmaerpdev__ProductCode__r.Id','sigmaerpdev__Available_Qty__c','sigmaerpdev__Web_Available_Qty__c','sigmaerpdev__Total_Available_Qty__c','sigmaerpdev__Delivered_Qty__c','sigmaerpdev__Rental_Delivered_Quantity__c','sigmaerpdev__Rental_Reserve_Quantity__c','sigmaerpdev__Rental_Shipped_Quantity__c'})
          && CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'id','sigmaerpdev__Orders_Status__c'})
          && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'id','OrderId','sigmaerpdev__IsInventoryUpdated__c','sigmaerpdev__Remaining_Qty_To_Package__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Shipped_Quantity__c','Pricebookentry.Product2Id','sigmaerpdev__Packaged_Quantity__c','Quantity','sigmaerpdev__Delivired__c','sigmaerpdev__Net_Quantity__c'})
          && CRUD_FLS_CheckUtility.checkFLS('Order',new set<String>{'sigmaerpdev__Orders_Status__c'})
          && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'id','name','sigmaerpdev__IsInventoryUpdated__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Shipped_Quantity__c','sigmaerpdev__Product__r.Id','sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Quantity__c','sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Sigma_Order__r.id','sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Order_Status__c'})
          && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Shipment__c',new Set<String>{'Id','Name','sigmaerpdev__Sales_Order__c','sigmaerpdev__Customer_Email__c','sigmaerpdev__ShippingCountry__c','sigmaerpdev__ShippingCity__c','sigmaerpdev__Shipping_Street__c','sigmaerpdev__ShippingPostalCode__c','sigmaerpdev__ShippingState__c'})
          
          && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Shipment__c',new Set<String>{'sigmaerpdev__Sales_Order__c','sigmaerpdev__Customer_Email__c','sigmaerpdev__ShippingCountry__c','sigmaerpdev__ShippingCity__c','sigmaerpdev__Shipping_Street__c','sigmaerpdev__ShippingPostalCode__c','sigmaerpdev__ShippingState__c'})
          && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new Set<String>{'sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__Shipped_Qty__c','sigmaerpdev__Comments__c','sigmaerpdev__Rental_Delivered_Quantity__c','sigmaerpdev__Rental_Reserve_Quantity__c','sigmaerpdev__Rental_Shipped_Quantity__c'})
          && CRUD_FLS_CheckUtility.checkFLS('OrderItem',new set<String>{'sigmaerpdev__Order_Status__c','sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Shipped_Quantity__c'})
          && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev__Order_Status__c','sigmaerpdev__Shipped_Quantity__c','sigmaerpdev__Packaged_Quantity__c'})
          )
        {      */                                                         
             Savepoint sp;
             try{
             sp= Database.setSavepoint();
             Order_Usage__c OrderTypeusage= new Order_Usage__c();
            
            OrderTypeusage= [select Id, Name,Sigma_order__c,Standard_object__c from Order_Usage__c limit 1]; 
                System.debug('OrderTypeusage>>'+OrderTypeusage);
           if(checkObjectShipment())
            {
                System.debug('ShipmentObj>>'+ShipmentObj);
                //insert ShipmentObj; //commented on 22-10-2019
                upsert ShipmentObj;
            }
            
            
            Id shipmentId = ShipmentObj.Id;
            String shipmentStatus = ShipmentObj.Status__c;
            System.debug('ShipmentObj>>'+ShipmentObj);
            List<String> selectedIdsList = new List<String>();
            Object[] values = (Object[])System.JSON.deserializeUntyped(shipmentProduts);
            System.debug('values>>'+values);
            if(values.size()>0){         
                for (Object id : values) {
                    
                    selectedIdsList.add(string.valueof(id) );
                }
            }
            System.debug('selectedIdsList>>'+selectedIdsList);
       
            String str1 = shipmentProduts.substring(1, shipmentProduts.length()-1);
            System.debug('str1>>'+str1);
            List<String> stringList = str1.split(',');
            System.debug('stringList>>'+stringList);
            for(integer i=0;i<stringList.size();i++){
            
            }
            
            List<String> strSplt = str1.split('},');
             System.debug('strSplt>>'+strSplt);
            
   
            List<String> strList = new List<String>();
            for(integer i=0;i<strSplt.size();i++){
                if(i < strSplt.size()-1){
                    strList.add(strSplt[i]+'}');
                }else{
                    strList.add(strSplt[i]);
                }
            }
            System.debug('strList>>'+strList);
            
            Integer len = strSplt.size();
            System.debug('len>>'+len);
            List<Shipment_Products__c> shipmentProdList = new List<Shipment_Products__c>();
            List<String> packageIDs=new List<String>();
            List<String> packageId=new List<String>();
            //added on 06-09-2019 to add shipment details in sigma order related list
            List<String> setOfPackageIds=new List<String>();
            
            for(Integer j=0; j<strList.size(); j++)
            {
                Shipment_Products__c shipPrd = new Shipment_Products__c();
                List<String> stringList2 = strList[j].split(',');
                String str2 = shipmentProduts.substring(1, shipmentProduts.length()-1);
                for(String d :strList){
                    
                }
                String str = strList[j];
                System.debug('str>>'+str);
                Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(str);
                System.debug('root>>'+root);
                if(FLSCheckInsertShipmentProducts()){
                    
                    for(Integer i=0; i<strList.size(); i++){ 
                        
                        shipPrd.Package_ID__c= String.valueOf(root.get('sigmaerpdev2__Package_ID__c'));
                        setOfPackageIds.add(shipPrd.Package_ID__c);
                        shipPrd.Customer_Name__c= String.valueOf(root.get('sigmaerpdev2__Customer_Name__c'));
                        String strDate = String.valueOf(root.get('sigmaerpdev2__Shipment_Delivery_Date__c'));
                        String[] tempDate=new List<String>(); 
                        if(strDate!=null)
                         tempDate = strDate.split('-');                                             
                        
                        if(tempDate.size()==3)// added if condition on 25-01-2020
                        {
                            date mydate = date.parse(tempDate[1]+'/'+tempDate[2]+'/'+tempDate[0]);
                            shipPrd.Shipment_Delivery_Date__c= mydate;
                        }                       
                        shipPrd.Status__c= String.valueOf(root.get('sigmaerpdev2__Status__c'));
                        shipPrd.Contact_Person__c= String.valueOf(root.get('sigmaerpdev2__Contact_Person__c'));// added on 22-06-2020
                       
                        shipPrd.Shipment__c=ShipmentObj.Id;                    
                    }            
                }            
                shipmentProdList.add(shipPrd);
            }               
            //added on 06-09-2019 to add shipment details in sigma order related list
            List<Package__c>  listOfPackage =[Select Id,Status__c,Sigma_Order__c,Sigma_Order__r.ShippingCountry__c,Sigma_Order__r.ShippingState__c,Sigma_Order__r.ShippingCity__c,Sigma_Order__r.Shipping_Street__c,Sigma_Order__r.ShippingPostalCode__c,Customer__c,Customer__r.Email__c, Order__c,Order__r.Shipping_Street__c,Order__r.ShippingCity__c,Order__r.ShippingCountry__c,Order__r.ShippingState__c,Order__r.ShippingPostalCode__c from Package__c where Id=:setOfPackageIds];
           
            if(OrderTypeusage.Standard_object__c == true)
            {
                ShipmentObj.Sales_Order__c=listOfPackage[0].Order__c;
                if(listOfPackage[0].Customer__r.Email__c!=null)
                ShipmentObj.Customer_Email__c=listOfPackage[0].Customer__r.Email__c;// added on 21-11-2019
                if(listOfPackage[0].Order__r.ShippingCountry__c!=null)
                ShipmentObj.ShippingCountry__c=listOfPackage[0].Order__r.ShippingCountry__c; // added on 30-11-2019
                if(listOfPackage[0].Order__r.ShippingCity__c!=null)
                ShipmentObj.ShippingCity__c=listOfPackage[0].Order__r.ShippingCity__c;  
                if(listOfPackage[0].Order__r.Shipping_Street__c!=null)
                ShipmentObj.Shipping_Street__c=listOfPackage[0].Order__r.Shipping_Street__c;  


                if(listOfPackage[0].Order__r.ShippingPostalCode__c!=null)
                ShipmentObj.ShippingPostalCode__c=listOfPackage[0].Order__r.ShippingPostalCode__c; // added on 30-11-2019
                if(listOfPackage[0].Order__r.ShippingState__c!=null)
                ShipmentObj.ShippingState__c=listOfPackage[0].Order__r.ShippingState__c; // added on 30-11-2019
                
                update ShipmentObj; 
            }
            else{
                    ShipmentObj.Sigma_Order__c=listOfPackage[0].Sigma_Order__c;
            if(listOfPackage[0].Customer__r.Email__c!=null)
                ShipmentObj.Customer_Email__c=listOfPackage[0].Customer__r.Email__c;// added on 21-11-2019
            
             if(listOfPackage[0].Sigma_Order__r.ShippingCountry__c!=null)
              ShipmentObj.ShippingCountry__c=listOfPackage[0].Sigma_Order__r.ShippingCountry__c; // added on 30-11-2019
                 if(listOfPackage[0].Sigma_Order__r.ShippingCity__c!=null)
            ShipmentObj.ShippingCity__c=listOfPackage[0].Sigma_Order__r.ShippingCity__c;  //// added on 30-11-2019
                if(listOfPackage[0].Sigma_Order__r.Shipping_Street__c!=null)
            ShipmentObj.Shipping_Street__c=listOfPackage[0].Sigma_Order__r.Shipping_Street__c;  // added on 30-11-2019
                if(listOfPackage[0].Sigma_Order__r.ShippingPostalCode__c!=null)
            ShipmentObj.ShippingPostalCode__c=listOfPackage[0].Sigma_Order__r.ShippingPostalCode__c; // added on 30-11-2019
                 if(listOfPackage[0].Sigma_Order__r.ShippingState__c!=null)
                ShipmentObj.ShippingState__c=listOfPackage[0].Sigma_Order__r.ShippingState__c; // added on 30-11-2019
            
            update ShipmentObj;
            }
            
        
     
            if(checkObjectShipmentProducts())
            {
                insert shipmentProdList;
                for(Shipment_Products__c  shpor:shipmentProdList) 
                {
                    
                    if(shpor.Status__c == 'Delivered')
                    { 
                        
                        packageIDs.add(shpor.Package_ID__c);
                    }
                    if(shpor.Status__c == 'Shipped')
                        packageId.add(shpor.Package_ID__c);
                }
                //added on 06-09-2019 to add shipment details in sigma order related list
                for(Shipment_Products__c  shpor:shipmentProdList) 
                {
                    
                    for(Package__c  pak:listOfPackage) 
                    {
                        if(shpor.Package_ID__c==pak.Id)
                        {
                            shpor.Sigma_Order__c=pak.Sigma_Order__c;
                        }
                    }
                    
                }
                if(shipmentProdList.size()>0)
                    update shipmentProdList;
            }
            
            List<Package__c> updatepklist=new List<Package__c>();
            List<Package__c>  packlist;
            List<Package__c>  packlist2;
            if(FLSCheckPackage())
            {
                packlist =[Select Id,Status__c from Package__c where Id=:packageIDs];
                packlist2 =[Select Id,Status__c from Package__c where Id=:packageId];
            }
            
            for (Package__c  plist:packlist)
            {
                plist.Status__c='Delivered';
                updatepklist.add(plist);
            }
            for (Package__c  plist2:packlist2)
            {
                plist2.Status__c='In Shipment';
                updatepklist.add(plist2);
            }
            
            if(CheckObjectPackage())
            {
                update updatepklist;
                
            }
            
            //get shipment order from shipment products by shipment id
            List<Shipment_Products__c> shipmentProducts;
            
            shipmentProducts = [SELECT id,name,Sigma_Order__c,Package_ID__c,Order__c,Shipment__c FROM Shipment_Products__c WHERE 
                                Shipment__c =: shipmentId];
            
            //get package id from shipment products
            
            Set<String>packId = new Set<String>();
            //commented on 10-10-2019
          
            Set<String>OrderId = new Set<String>();
              List<Order> ListOfOrders = New List<Order>();
                List<OrderItem> ListOfOrderlines = New List<OrderItem>();
            Set<String>productId = new Set<String>();
            Map<ID,Integer> packedProdQuantity = new Map<ID,Integer>();
            Map<ID,Integer> sigmapkProdQty = new Map<ID,Integer>();
            
            List<Sigma_Order__c> getrecordtype = New List<Sigma_Order__c>();
            
            for(Shipment_Products__c shipProd : shipmentProducts)
            {
                if(shipProd.Package_ID__c != null)
                    PackId.add(shipProd.Package_ID__c);
            } 
            List<PackagedProducts__c> packProducts;
       
            packProducts = [SELECT id,name,Sigma_Order__c,Sigma_Order__r.RecordType.Name,Order_Product__c,Product_Order__c,Quantity__c,Product__c,Order__c,Package__c FROM PackagedProducts__c WHERE Package__c IN :PackId];
            
                     
            //get product id & order Id from shipment products chandana
            
            //by forgation for standared order when the status is shipped by chandana 
           
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
                }
                
                
                
            }//standered order 
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
            }//sigma order 
                        
            if( OrderId != null && !OrderId.isEmpty())
            {
                getrecordtype = [select id,RecordTypeId,RecordType.Name from Sigma_Order__c where id in :OrderId];
              //  ListOfOrders=  [select id,name,Orders_Status__c,(select id,Order_Status__c,OrderId from OrderItems) from Order where id in :OrderId]; // commented on 05-03-2020
                 ListOfOrderlines=  [select id,Order_Status__c,IsInventoryUpdated__c from OrderItem where OrderId in :OrderId and IsInventoryUpdated__c=true and Order_Status__c='Packaged'  and Id IN :orderlineqty.keySet()];
                
            }
            else{
                system.debug('Exception caught in orderid==null ');
            }                       
            
                 if(OrderTypeusage.Standard_object__c == true)
                {
                    if(shipmentStatus=='Ready To Ship')
                    {
                        
                        List<Order> olist=new List<Order>();
                        List<OrderItem> oilist=new List<OrderItem>();
                    
                      /*  for(Order ord:ListOfOrders)
                        {
                            
                            ord.Orders_Status__c=ShipmentStatus;
                            olist.add(ord);

                        }*/
                        for(OrderItem oi:ListOfOrderlines)
                            {
                                oi.Order_Status__c=ShipmentStatus;
                                oilist.add(oi);
                            }
                        
                        if(oilist.size()>0)
                            update oilist;
                        List<OrderItem> oilistZeroQty=new List<OrderItem>();
                    
                        List<OrderItem>  ListOfOrderlinesWithZeroQty=  [select id,Order_Status__c,IsInventoryUpdated__c from OrderItem where OrderId in :OrderId And Quantity=0];
                        system.debug('ListOfOrderlinesWithZeroQty>>'+ListOfOrderlinesWithZeroQty);
                        for(OrderItem oi:ListOfOrderlinesWithZeroQty)
                            {
                                system.debug('oi>>'+oi);
                        
                                oi.Order_Status__c=ShipmentStatus;
                                oilistZeroQty.add(oi);
                            }
                            system.debug('oilistZeroQty>>'+oilistZeroQty);
                        
                             if(oilistZeroQty.size()>0)
                            update oilistZeroQty;
                
                        
                        
                        //if(olist.size()>0) commented on 04-03-2020
                           // update olist;
                    
                        
                    }
                    
                }
                
                
                
            if(shipmentStatus == 'Shipped')
            {
                Integer packedQty=0;
                Integer packedsigmaQty=0;
                List<Inventory__c> invShippedQtyToUpdate = new List<Inventory__c>();
                List<Inventory__c> prodInvs;
				Map<Id,Decimal> ilpliIdQuantinIA = new Map<Id,Decimal>();
                prodInvs = [SELECT id,name,Reserved_Qty__c,Packaged_Quantity__c,Shipped_Qty__c,ProductCode__r.Id,Available_Qty__c,Web_Available_Qty__c,Total_Available_Qty__c, Rental_Reserve_Quantity__c, Rental_Shipped_Quantity__c FROM Inventory__c WHERE ProductCode__c  IN :productId];
                
                if(OrderTypeusage.Standard_object__c == true)
                {
                    for(Inventory__c prodInv : prodInvs){
                        Inventory__c newInv = new Inventory__c();
                        packedQty = packedProdQuantity.get(prodInv.ProductCode__r.Id);
                        if(prodInv.Shipped_Qty__c==null) prodInv.Shipped_Qty__c=0;
                        newInv.Shipped_Qty__c = prodInv.Shipped_Qty__c + packedQty;
                        if(prodInv.Packaged_Quantity__c!=null)
                            newInv.Packaged_Quantity__c = prodInv.Packaged_Quantity__c-packedQty;
                        
                        newInv.Comments__c = 'Product has been Delivered';
                        newInv.Id = prodInv.Id;
                        invShippedQtyToUpdate.add(newInv);
                    }
                } 
                else{
                    
                    /////////new code
                    
                    for(Inventory__c prodInv : prodInvs)
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
                            newInv.Rental_Shipped_Quantity__c = prodInv.Rental_Shipped_Quantity__c + packedQty;
                            newInv.Rental_Reserve_Quantity__c = prodInv.Rental_Reserve_Quantity__c - packedQty;
                        }
                        if(packedsigmaQty!=0)
                        {
                            //////////////////////added on 22-10-2019
                            if(prodInv.Shipped_Qty__c==null)
                            {
                                prodInv.Shipped_Qty__c=0;
                            }
                            if(prodInv.Packaged_Quantity__c ==null)
                            {
                                prodInv.Packaged_Quantity__c =0;
                            }
                            ///////////////////////
                            newInv.Shipped_Qty__c = prodInv.Shipped_Qty__c + packedsigmaQty;
                            newInv.Packaged_Quantity__c = prodInv.Packaged_Quantity__c - packedsigmaQty;
                        }
                        newInv.Comments__c = 'Product has been Delivered';
                        newInv.Id = prodInv.Id;
                        invShippedQtyToUpdate.add(newInv);
                        
                    }
                    
                }// end of orderusage custom setting 
                
                update invShippedQtyToUpdate;
                
				
				
                if(OrderTypeusage.Standard_object__c == true)
                {
                    
                    List<OrderItem> OrderLineShippedQtyToUpdate = new List<OrderItem>();  
                    List<OrderItem> Orderlines;
                    Orderlines =[Select id,OrderId,Shipped_Quantity__c,Pricebookentry.Product2Id,Remaining_Qty_To_Package__c,Packaged_Quantity__c,Quantity,Delivired__c,Net_Quantity__c,Order_Status__c,IsInventoryUpdated__c,(select id,name,ILPLI__c,Quantity__c from Inventory_Allocations__r) from OrderItem where OrderId IN :OrderId and IsInventoryUpdated__c=true  and Id IN :orderlineqty.keySet()];
                    
                    for(OrderItem ordtoupdate : Orderlines)
                    {         
						for(Inventory_Allocation__c ia: ordtoupdate.Inventory_Allocations__r)
						{
							if(ilpliIdQuantinIA.containsKey(ia.ILPLI__c))
								ilpliIdQuantinIA.put(ia.ILPLI__c,ilpliIdQuantinIA.get(ia.ILPLI__c)+ia.Quantity__c);
							else
								ilpliIdQuantinIA.put(ia.ILPLI__c,ia.Quantity__c);
								system.debug('ilpliIdQuantinIA>>>'+ilpliIdQuantinIA);
						}
                        if(ordtoupdate.Order_Status__c=='Packaged') 
                        {
                            OrderItem newordtoupdate = new OrderItem();
                            packedQty = orderlineqty.get(ordtoupdate.id);
                            
                            
                            if(ordtoupdate.Shipped_Quantity__c == null )
                            {
                                ordtoupdate.Shipped_Quantity__c = 0;
                            }
                            
                            if(packedQty!=null)
                            {
                                newordtoupdate.Shipped_Quantity__c = ordtoupdate.Shipped_Quantity__c + packedQty;
                                newordtoupdate.Packaged_Quantity__c = ordtoupdate.Packaged_Quantity__c - packedQty;    
                            }
                            
                            newordtoupdate.Order_Status__c=shipmentStatus;
                            newordtoupdate.Id = ordtoupdate.Id;                            
                            OrderLineShippedQtyToUpdate.add(newordtoupdate);
                            
                        }
                        
                    }                                       
                    
                    if(OrderLineShippedQtyToUpdate.size()>0)
                    {
                        update OrderLineShippedQtyToUpdate ;
                    }       

					if(ilpliIdQuantinIA.values().size()>0){
                        InventoryManagement.reduceInventoryoutbound(ilpliIdQuantinIA,'Shipped');
                    }
                    ///////////////////////added on06-04-2020 to update older line item status which has zero Qty
                    List<OrderItem> oilistZeroQty=new List<OrderItem>();
                    
                        List<OrderItem>  ListOfOrderlinesWithZeroQty=  [select id,Order_Status__c,IsInventoryUpdated__c from OrderItem where OrderId in :OrderId And Quantity=0];
                        system.debug('ListOfOrderlinesWithZeroQty>>'+ListOfOrderlinesWithZeroQty);
                        for(OrderItem oi:ListOfOrderlinesWithZeroQty)
                            {
                                system.debug('oi>>'+oi);
                        
                                oi.Order_Status__c=ShipmentStatus;
                                oilistZeroQty.add(oi);
                            }
                            system.debug('oilistZeroQty>>'+oilistZeroQty);
                        
                             if(oilistZeroQty.size()>0)
                            update oilistZeroQty;
                
                    
                    
                    
                    
                    
                    /////////////////////////////////
                    



                    
                    List<Order> olist=new List<Order>();
                    if( OrderId != null && !OrderId.isEmpty())
                    {
                    ListOfOrders=  [select id,name,Orders_Status__c,(select id,Order_Status__c,OrderId from OrderItems) from Order where id in :OrderId];
                    }
                    System.debug('ListOfOrders>>'+ListOfOrders);
                    for(Order ord:ListOfOrders)
                    {
                        if(ord.OrderItems.size()>0)
                        {
                            Integer noOfLineItems=ord.OrderItems.size();
                            System.debug('noOfLineItems>>'+noOfLineItems);
                            String shipStatus='Shipped';
                            String deleveredStatus='Delivered';
                            Integer shipCount=0;
                            Map<Id,String>orderIdAndStatus=new Map<Id,String>();
                            System.debug('orderIdAndStatus>>'+orderIdAndStatus);
                             for(OrderItem OL:ord.OrderItems)
                                { 
                                    System.debug('OL>>'+OL);
                                    if(OL.Order_Status__c==shipStatus)
                                    { 
                                        ++shipCount;
                                        System.debug('shipCount>>'+shipCount);
                                        if(shipCount==noOfLineItems)
                                        orderIdAndStatus.put(OL.OrderId,OL.Order_Status__c);
                                    }
                                }
                        System.debug('shipCount>>'+shipCount);
                        System.debug('noOfLineItems>>'+noOfLineItems);
                        System.debug('orderIdAndStatus>>'+orderIdAndStatus);
                        if(shipCount==noOfLineItems)
                        {
                            if(orderIdAndStatus.containsKey(ord.id))
                            {
                                ord.Orders_Status__c=orderIdAndStatus.get(ord.id);
                                 olist.add(ord);
                            }
                        }
                        }
                    }
                    System.debug('olist>>'+olist);
                    if(olist.size()>0)
                        update olist;
                    
                }
                else
                {
                    
                    
                    List<Product_Order_Price_Book__c> OrderLineShippedQtyToUpdate = new List<Product_Order_Price_Book__c>();  
                    List<Product_Order_Price_Book__c> Orderlines;
                    
                    List<Inventory_Allocation__c> listOfSigmaOrderlineItemIds = [select id,name,Order_Line__c,Order_Line__r.id from Inventory_Allocation__c where Status__c = 'Picked' and Order_Line__r.Sigma_Order__c=: OrderId ];
                    
                    List<Id>lis=new List<Id>();
                    for(Inventory_Allocation__c ia:listOfSigmaOrderlineItemIds)
                    {
                        lis.add(ia.Order_Line__r.id); 
                    }
                    
                    Orderlines =[Select id,Sigma_Order__c,Shipped_Quantity__c,Packaged_Quantity__c,Order_Status__c,IsInventoryUpdated__c,(select id,name,ILPLI__c,Quantity__c from Inventory_Allocations1__r) from Product_Order_Price_Book__c  where Sigma_Order__c IN: OrderId and IsInventoryUpdated__c=true   and Id IN :orderlineqty.keySet()];
                    
                    
                    for(Product_Order_Price_Book__c ordtoupdate : Orderlines)
                    {
						for(Inventory_Allocation__c ia: ordtoupdate.Inventory_Allocations1__r)
						{
							if(ilpliIdQuantinIA.containsKey(ia.ILPLI__c))
								ilpliIdQuantinIA.put(ia.ILPLI__c,ilpliIdQuantinIA.get(ia.ILPLI__c)+ia.Quantity__c);
							else
								ilpliIdQuantinIA.put(ia.ILPLI__c,ia.Quantity__c);
							system.debug('ilpliIdQuantinIA>>>'+ilpliIdQuantinIA);
						}
                                            
                        if(ordtoupdate.Order_Status__c=='Shipped')
                        {
                            Product_Order_Price_Book__c newordtoupdate = new Product_Order_Price_Book__c();                            
                            packedQty = orderlineqty.get(ordtoupdate.id);                           
                                                        
                            if(ordtoupdate.Shipped_Quantity__c == null )
                            {
                                ordtoupdate.Shipped_Quantity__c = 0;
                            }                            
                            if(packedQty!=null)
                            {
                                newordtoupdate.Shipped_Quantity__c = ordtoupdate.Shipped_Quantity__c + packedQty;
                                newordtoupdate.Packaged_Quantity__c = ordtoupdate.Packaged_Quantity__c - packedQty;
                            }
                            
                            newordtoupdate.Order_Status__c=shipmentStatus;//after shipment update the sigma orderline status
                            newordtoupdate.Id = ordtoupdate.Id;
                            
                            OrderLineShippedQtyToUpdate.add(newordtoupdate);
                            
                            
                        }
                        
                        
                    }
                                        
                    
                    if(OrderLineShippedQtyToUpdate.size()>0)
                    {
                        update OrderLineShippedQtyToUpdate ;
                    }
					if(ilpliIdQuantinIA.values().size()>0){
                        InventoryManagement.reduceInventoryoutbound(ilpliIdQuantinIA,'Shipped');
                    }
                }
                
            }
            Shipment__c ship=[select Id,Name from Shipment__c where id =:ShipmentObj.Id limit 1];
            if(ship!=null)
            {
                ShipmentObj=ship;
            }
             
             }catch(Exception e)
                {
                String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                    createErrorLog.insertError('AddShipmentProductsLtng',ex,'Method -saveShipment ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                    Database.rollback(sp);
              }
             
        //}
        return ShipmentObj;  
    }
    
    @AuraEnabled
    public Static void deleteShipmentProd(String ShipmentProducts,Integer idx){
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Shipment_Products__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Shipment_Products__c',new set<String>{'Id','Name'})
          ){*/
          try{
          Type t = Type.forName('List<Shipment_Products__c>');
              List<SObject> ShipProdList = (List<SObject>)JSON.deserialize(ShipmentProducts, t);
              
              for (SObject o : ShipProdList) {
                  System.debug(o.getSObjectType().getDescribe().getName() + ', Name: ' + o.get('Name'));
                  System.debug('--------'+o);
              }
              
              if(ShipProdList.get(idx).Id != null)
              {
                  if(checkObjectShipmentProducts1())
                  {
                      delete ShipProdList.get(idx);
                  }
              }
          }catch(Exception e)
                {
                String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                    createErrorLog.insertError('AddShipmentProductsLtng',ex,'Method -deleteShipmentProd ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                    //Database.rollback(sp);
              }  
         // }
    }
    
    @AuraEnabled
    public Static Package__c getPackageCustomerName(ID  packageId)
    {    
        
        Package__c  cuPackage;
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')  
         && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c'})

           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new Set<String>{'Id','sigmaerpdev__Customer__c','sigmaerpdev__Customer__r.Name','Name','sigmaerpdev__Status__c','sigmaerpdev__Canceled_Package__c'})            
          )
        {*/
        try{
             Order_Usage__c OrderTypeusage= new Order_Usage__c();
            
            OrderTypeusage= [select Id, Name,Sigma_order__c,Standard_object__c from Order_Usage__c limit 1]; 
                System.debug('OrderTypeusage>>'+OrderTypeusage);
                if(OrderTypeusage.Sigma_order__c==true)// added on 22-06-2020 for surveys
                {
                    if(FLSCheckPackage())
                    {
                    //added Canceled_Package__c on 17-10-2019   after refund  to controll the package proceed to shipment
                    cuPackage =[Select Id,Name, Customer__c,Customer__r.Name,Status__c,Canceled_Package__c,Sigma_Order__c,Sigma_Order__r.Name,Sigma_Order__r.BillingPersonNew__c from Package__c where Id=:packageId and Canceled_Package__c=false];

                    String Ids = cuPackage.Customer__c;  
                    }
                    
                }
                else if(OrderTypeusage.Standard_object__c==true)
                {
                    if(FLSCheckPackage())
                    {
                    //added Canceled_Package__c on 17-10-2019   after refund  to controll the package proceed to shipment
                    cuPackage =[Select Id,Name, Customer__c,Customer__r.Name,Status__c,Canceled_Package__c,Order__c,Order__r.BillingPersonNew__c,Order__r.OrderNumber                        from Package__c where Id=:packageId and Canceled_Package__c=false];

                    String Ids = cuPackage.Customer__c;  
                    }
                    
                }
            
        }catch(Exception e)
                {
                String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                    createErrorLog.insertError('AddShipmentProductsLtng',ex,'Method -getPackageCustomerName ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                  //  Database.rollback(sp);
              }
             
        //} 
        return cuPackage;
    }
    
    /* --- Edit Section Starts here  ---- */
    public static List<Shipment_Products__c> shipmentProdList{get;set;}
    @AuraEnabled
    public static Shipment__c editShipment(Id shipmentObj)
    {
        
        Shipment__c shipm=new Shipment__c();
        
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Shipment__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Shipment_Products__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Shipment__c',new Set<String>{'id','sigmaerpdev__Account__r.Name','sigmaerpdev__Account__c','Delivery_Person__c','sigmaerpdev__Delivery_Person__r.Name','sigmaerpdev__Description__c','sigmaerpdev__Shipment_Date__c','sigmaerpdev__Truck_No__c','sigmaerpdev__Status__c','sigmaerpdev__WayBill__c','sigmaerpdev__track_url__c','sigmaerpdev__concenment__c','sigmaerpdev__Selected_Courier__c','sigmaerpdev__Delivery_Person1__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Shipment_Products__c',new Set<String>{'Id','Name','sigmaerpdev__Package_ID__c','sigmaerpdev__Package_ID__r.Name','sigmaerpdev__Customer_Name__r.Name','sigmaerpdev__Customer_Name__c','sigmaerpdev__Order__c','sigmaerpdev__Shipment_Delivery_Date__c','sigmaerpdev__Status__c'})
           && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Shipment_Products__c',new Set<String>{'sigmaerpdev__Shipment__c'})
          ){*/
          try{
          
              if(FLSCheckShipment()){
                  shipm = [SELECT id,Account__r.Name,Account__c,Delivery_Person__c,Selected_Courier__c,
                           Delivery_Person__r.Name,Description__c,Shipment_Date__c,Truck_No__c,
                           WayBill__c,track_url__c,concenment__c,Status__c,Delivery_Person1__c FROM Shipment__c where Id=:shipmentObj];
                  
              }
              
              if(FLSCheckShipmentProducts()){
                  shipmentProdList= [Select Id,Name,Package_ID__c,Package_ID__r.Name,Customer_Name__r.Name,
                                     Customer_Name__c,Order__c,Shipment_Delivery_Date__c,
                                     Status__c From Shipment_Products__c
                                     where Shipment__c =: shipm.id AND Status__c NOT IN('Delivered')];
                  
              }
          }catch(Exception e)
                {
                String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                    createErrorLog.insertError('AddShipmentProductsLtng',ex,'Method -shipmentProdList ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                    //Database.rollback(sp);
              }
          
       //   } 
        
        return shipm;             
    }
    
    @AuraEnabled
    public static List<Shipment_Products__c> editShipmentProducts(Id shipmentObj1) {
        
        //  return AddShipmentProductsLtng.shipmentProdList;
        Shipment__c shipm=new Shipment__c();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Shipment__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Shipment_Products__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Shipment__c',new Set<String>{'id','sigmaerpdev__Account__r.Name','sigmaerpdev__Account__c','sigmaerpdev__Delivery_Person__c','sigmaerpdev__Delivery_Person__r.Name','sigmaerpdev__Description__c','sigmaerpdev__Shipment_Date__c','sigmaerpdev__Truck_No__c','sigmaerpdev__Status__c','sigmaerpdev__WayBill__c','sigmaerpdev__track_url__c','sigmaerpdev__concenment__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Shipment_Products__c',new Set<String>{'Id','Name','sigmaerpdev__Package_ID__c','sigmaerpdev__Package_ID__r.Name','sigmaerpdev__Customer_Name__r.Name','sigmaerpdev__Customer_Name__c','sigmaerpdev__Order__c','sigmaerpdev__Shipment_Delivery_Date__c','sigmaerpdev__Status__c'})
           && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Shipment_Products__c',new Set<String>{'sigmaerpdev__Shipment__c'})
          ){*/
           try{
             if(FLSCheckShipment()){
                  shipm = [SELECT id,Account__r.Name,Account__c,Delivery_Person__c,
                           Delivery_Person__r.Name,Description__c,Shipment_Date__c,Truck_No__c,
                           WayBill__c,track_url__c,concenment__c,Status__c FROM Shipment__c where Id=:shipmentObj1];
                  
              }
              
              if(FLSCheckShipmentProducts()){
                  shipmentProdList= [Select Id,Name,Package_ID__c,Package_ID__r.Name,Customer_Name__r.Name,
                                     Customer_Name__c,Order__c,Shipment_Delivery_Date__c,
                                     Status__c,Contact_Person__c From Shipment_Products__c
                                     where Shipment__c =: shipm.id AND Status__c NOT IN('Delivered')];
                  
              }
             }catch(Exception e)
                {
                String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                    createErrorLog.insertError('AddShipmentProductsLtng',ex,'Method -editShipmentProducts ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                   // Database.rollback(sp);
              }
              
         // } 
        
        return shipmentProdList; 
        
    } 
    
    
    @AuraEnabled
    public static Shipment__c updateShipment(Shipment__c shipmentObj,String shipmentProduts) 
    {
      /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Shipment__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Shipment__c',new set<String>{'Id','Name'})
           
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Shipment_Products__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
           && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Shipment_Products__c',new Set<String>{'sigmaerpdev__Package_ID__c','sigmaerpdev__Customer_Name__c','sigmaerpdev__Shipment_Delivery_Date__c','sigmaerpdev__Status__c'})   
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new set<String>{'Id'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Package__c',new set<String>{'sigmaerpdev__Status__c'})
           && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Shipment_Products__c',new Set<String>{'sigmaerpdev__Shipment__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Shipment_Products__c',new Set<String>{'id','name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Package_ID__c','sigmaerpdev__Order__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'id','name','sigmaerpdev__Product_Order__c','sigmaerpdev__Sigma_Order__r.RecordType.Name','sigmaerpdev__Order_Product__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Order__c','sigmaerpdev__Package__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new Set<String>{'id','name','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__Delivered_Qty__c','sigmaerpdev__Shipped_Qty__c','sigmaerpdev__ProductCode__c','sigmaerpdev__ProductCode__r.Id','sigmaerpdev__Available_Qty__c', 
             'sigmaerpdev__Web_Available_Qty__c','sigmaerpdev__Total_Available_Qty__c', 'sigmaerpdev__Rental_Reserve_Quantity__c', 'sigmaerpdev__Rental_Shipped_Quantity__c','sigmaerpdev__Rental_Delivered_Quantity__c','sigmaerpdev__Packaged_Quantity__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'Id', 'Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'id','RecordTypeId','RecordType.Name'})
           && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'id','OrderId','sigmaerpdev__IsInventoryUpdated__c','sigmaerpdev__Shipped_Quantity__c','Pricebookentry.Product2Id','sigmaerpdev__Packaged_Quantity__c','Quantity','sigmaerpdev__Delivired__c','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Order_Status__c'})
           && CRUD_FLS_CheckUtility.checkFLS('OrderItem',new set<String>{'sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Shipped_Quantity__c','sigmaerpdev__Delivired__c','sigmaerpdev__Order_Status__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'id','name','sigmaerpdev__IsInventoryUpdated__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__c.id','sigmaerpdev__Shipped_Quantity__c','sigmaerpdev__Product__r.Id','sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Quantity__c','sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Net_Quantity__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev__Shipped_Quantity__c','sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Delivered_Quantity__c'})
          && CRUD_FLS_CheckUtility.checkFLS('Order',new Set<String>{'sigmaerpdev__Orders_Status__c'}))
        {*/
             Savepoint sp;
             try{
                sp= Database.setSavepoint();
                if(checkObjectShipment())
            {
                upsert shipmentObj;
            }
            
            Id shipmentId = ShipmentObj.Id;
            String shipmentStatus = ShipmentObj.Status__c;
            
            List<Shipment_Products__c> shipmentProductListForInsert = new List<Shipment_Products__c>();
            List<Shipment_Products__c> shipmentProductListForUpdate = new List<Shipment_Products__c>();
            Object[] values = (Object[])System.JSON.deserializeUntyped(shipmentProduts);
            
            for(Object obj:values)
            {
                String str = JSON.serialize(obj);
                Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(str);
                Shipment_Products__c shipPrd= new  Shipment_Products__c();
                
                if(String.valueOf(root.get('Id')) != null)
                {
                    if(FLSCheckInsertShipmentProducts()){
                        shipPrd.Id = String.valueOf(root.get('Id'));
                        shipPrd.Package_ID__c= String.valueOf(root.get('sigmaerpdev2__Package_ID__c'));
                        shipPrd.Customer_Name__c= String.valueOf(root.get('sigmaerpdev2__Customer_Name__c'));
                        String strDate = String.valueOf(root.get('sigmaerpdev2__Shipment_Delivery_Date__c'));
                        
                        if(strDate!=null){ //added  if condition on 25-01-2020
                            String[] tempDate = strDate.split('-');
                        
                        if(tempDate.size()>=3)//added  if condition on 25-01-2020
                        {
                            date mydate = date.parse(tempDate[1]+'/'+tempDate[2]+'/'+tempDate[0]);
                            shipPrd.Shipment_Delivery_Date__c= mydate;
                        }
                        }
                        
                        shipPrd.Contact_Person__c= String.valueOf(root.get('sigmaerpdev2__Contact_Person__c'));// added on 22-06-2020
                       
                        shipPrd.Status__c= String.valueOf(root.get('sigmaerpdev2__Status__c'));
                    }
                    shipmentProductListForUpdate.add(shipPrd);
                    
                }
                else{
                    if(FLSCheckInsertShipmentProducts()){
                        shipPrd = new Shipment_Products__c();
                        shipPrd.Package_ID__c= String.valueOf(root.get('sigmaerpdev2__Package_ID__c'));
                        shipPrd.Customer_Name__c= String.valueOf(root.get('sigmaerpdev2__Customer_Name__c'));
                        String strDate = String.valueOf(root.get('sigmaerpdev2__Shipment_Delivery_Date__c'));
                        String[] tempDate = strDate.split('-');
                        date mydate = date.parse(tempDate[1]+'/'+tempDate[2]+'/'+tempDate[0]);
                        shipPrd.Shipment_Delivery_Date__c= mydate;
                        shipPrd.Status__c= String.valueOf(root.get('sigmaerpdev2__Status__c'));
                        shipPrd.Contact_Person__c= String.valueOf(root.get('sigmaerpdev2__Contact_Person__c'));// added on 22-06-2020
                       
                        shipPrd.Shipment__c=ShipmentObj.Id;
                    }
                    shipmentProductListForInsert.add(shipPrd);
                }
            }
            List<String> packageIDs=new List<String>();
            List<String> packageId=new List<String>();
            if(checkObjectShipmentProducts())
            {
                update shipmentProductListForUpdate;
                insert shipmentProductListForInsert;
                
                for(Shipment_Products__c  shporUp:shipmentProductListForUpdate)
                {
                    if(shporUp.Status__c == 'Delivered')
                    {
                        packageIDs.add(shporUp.Package_ID__c);
                    }
                    
                    if(shporUp.Status__c == 'Shipped')
                        packageId.add(shporUp.Package_ID__c);
                }
                for(Shipment_Products__c  shporIn:shipmentProductListForInsert)
                {
                    if(shporIn.Status__c == 'Delivered')
                    {
                        packageIDs.add(shporIn.Package_ID__c);
                    }
                    
                    if(shporIn.Status__c == 'Shipped')
                        packageId.add(shporIn.Package_ID__c);
                }
            }           
            List<Package__c> updatepklist=new List<Package__c>();
            List<Package__c>  packlist;
            List<Package__c>  packlist2;
            if(FLSCheckPackage())
            {
                packlist=[Select Id from Package__c where Id=:packageIDs];
                packlist2 =[Select Id from Package__c where Id=:packageId];
            }
            
            for (Package__c  plist:packlist)
            {
                plist.Status__c='Delivered';
                updatepklist.add(plist);
            }
            for (Package__c  plist2:packlist2)
            {
                plist2.Status__c='In Shipment';
                updatepklist.add(plist2);
            }
            
            if(CheckObjectPackage())
            {
                update updatepklist;
            }
            
            List<Shipment_Products__c> shipmentProducts;
            
            shipmentProducts = [SELECT id,name,Sigma_Order__c,Package_ID__c,Order__c FROM Shipment_Products__c WHERE 
                                Shipment__c =:shipmentId];
            
            Set<String>packId = new Set<String>();
            Set<String>OrderId = new Set<String>();
            Set<String>productId = new Set<String>();
            Map<ID,Integer> packedProdQuantity = new Map<ID,Integer>();
            Map<ID,Integer> sigmapkProdQty = new Map<ID,Integer>();
            List<Sigma_Order__c> getrecordtype = New List<Sigma_Order__c>();
              List<Order> ListOfOrders = New List<Order>();
            
            //get package id from shipment products
            for(Shipment_Products__c shipProd : shipmentProducts)
            {
                if(shipProd.Package_ID__c != null)
                    PackId.add(shipProd.Package_ID__c);
            } 
            
            List<PackagedProducts__c> packProducts;
            
            packProducts = [SELECT id,name,Product_Order__c,Sigma_Order__r.RecordType.Name,Order_Product__c,Sigma_Order__c,Product__c,Quantity__c,Order__c FROM PackagedProducts__c WHERE Package__c IN :PackId];
            
            //get product id & order Id from shipment products chandana
            
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
                }
                
                if( OrderId != null && !OrderId.isEmpty())
                {
                    getrecordtype = [select id,RecordTypeId,RecordType.Name from Sigma_Order__c where id in :OrderId];
                  //  ListOfOrders=  [select id,name,Orders_Status__c,(select id,Order_Status__c,OrderId from OrderItems) from Order where id in :OrderId]; // commented on 05-03-2020
             }
                else{
                    system.debug('Exception caught in orderid==null ');
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
                else
                {
                    system.debug('Exception caught in orderid==null ');
                }
            }
                        
            if(ShipmentStatus == 'Shipped')
            {
                Integer packedQty;
                List<Inventory__c> invShippedQtyToUpdate = new List<Inventory__c>();
                List<Inventory__c> prodInvs;
				Map<Id,Decimal> ilpliIdQuantinIA = new Map<Id,Decimal>();
                //  Integer packedsigmaQty=0; 
                prodInvs = [SELECT id,name,Reserved_Qty__c,Shipped_Qty__c,ProductCode__c,ProductCode__r.Id,Available_Qty__c, 
                            Web_Available_Qty__c,Total_Available_Qty__c, Rental_Reserve_Quantity__c, Rental_Shipped_Quantity__c
                            ,Packaged_Quantity__c FROM Inventory__c WHERE ProductCode__c  IN :productId];
                
                                
                if(OrderTypeusage.Standard_object__c == true)
                {    
                    List<OrderItem> OrderLineShippedQtyToUpdate = new List<OrderItem>();  
                    List<OrderItem> Orderlines;
                    
                    Orderlines =[Select id,OrderId,Shipped_Quantity__c,Packaged_Quantity__c,Quantity,Delivired__c,Net_Quantity__c,Order_Status__c,IsInventoryUpdated__c,(select id,name,ILPLI__c,Quantity__c from Inventory_Allocations__r) from OrderItem where OrderId IN :OrderId AND Packaged_Quantity__c!= Null  AND Packaged_Quantity__c!= 0 AND Packaged_Quantity__c > 0 and IsInventoryUpdated__c=true and Id IN :orderlineqty.keySet()];                    
                    
                   for(OrderItem ordtoupdate : Orderlines)
                    {
						for(Inventory_Allocation__c ia: ordtoupdate.Inventory_Allocations__r)
						{
							if(ilpliIdQuantinIA.containsKey(ia.ILPLI__c))
								ilpliIdQuantinIA.put(ia.ILPLI__c,ilpliIdQuantinIA.get(ia.ILPLI__c)+ia.Quantity__c);
							else
								ilpliIdQuantinIA.put(ia.ILPLI__c,ia.Quantity__c);
								system.debug('ilpliIdQuantinIA>>>'+ilpliIdQuantinIA);
						}
                        OrderItem newordtoupdate = new OrderItem();
                        if(ordtoupdate.Shipped_Quantity__c == null )
                        {
                            ordtoupdate.Shipped_Quantity__c = 0;
                        }

                        packedQty = orderlineqty.get(ordtoupdate.id);
                           if(packedQty!=null)
                            {
                                newordtoupdate.Packaged_Quantity__c = ordtoupdate.Packaged_Quantity__c - packedQty;
                                newordtoupdate.Shipped_Quantity__c = ordtoupdate.Shipped_Quantity__c + packedQty;
                            }
                        newordtoupdate.Order_Status__c = ShipmentStatus;
                        newordtoupdate.Id = ordtoupdate.Id;
                        
                        OrderLineShippedQtyToUpdate.add(newordtoupdate);                                                
                    }
                    
                    update OrderLineShippedQtyToUpdate ;
                    /////////
                    if(ilpliIdQuantinIA.values().size()>0){
                            InventoryManagement.reduceInventoryoutbound(ilpliIdQuantinIA,'Shipped');
                        }
                    //////////////////////////////
                            List<OrderItem> oilistZeroQty=new List<OrderItem>();
                    
                        List<OrderItem>  ListOfOrderlinesWithZeroQty=  [select id,Order_Status__c,IsInventoryUpdated__c from OrderItem where OrderId in :OrderId And Quantity=0];
                        system.debug('ListOfOrderlinesWithZeroQty>>'+ListOfOrderlinesWithZeroQty);
                        for(OrderItem oi:ListOfOrderlinesWithZeroQty)
                            {
                                system.debug('oi>>'+oi);
                        
                                oi.Order_Status__c=ShipmentStatus;
                                oilistZeroQty.add(oi);
                            }
                            system.debug('oilistZeroQty>>'+oilistZeroQty);
                        
                             if(oilistZeroQty.size()>0)
                            update oilistZeroQty;
                    
                    
                    
                    //////////////////////////////////
                      List<Order> olist=new List<Order>();
                      if( OrderId != null && !OrderId.isEmpty())
                    {
                    ListOfOrders=  [select id,name,Orders_Status__c,(select id,Order_Status__c,OrderId from OrderItems) from Order where id in :OrderId];
                    }
                    System.debug('ListOfOrders>>'+ListOfOrders);
                    for(Order ord:ListOfOrders)
                    {
                        if(ord.OrderItems.size()>0)
                        {
                            Integer noOfLineItems=ord.OrderItems.size();
                            System.debug('noOfLineItems>>'+noOfLineItems);
                            String shipStatus='Shipped';
                            String deleveredStatus='Delivered';
                            Integer shipCount=0;
                            Integer deliverCount=0;
                            Map<Id,String>orderIdAndStatus=new Map<Id,String>();
                            System.debug('orderIdAndStatus>>'+orderIdAndStatus);
                             for(OrderItem OL:ord.OrderItems)
                                { 
                                    System.debug('OL>>'+OL);
                                    if(OL.Order_Status__c==shipStatus)
                                    { 
                                        ++shipCount;
                                        System.debug('shipCount>>'+shipCount);
                                        if(shipCount==noOfLineItems)
                                        orderIdAndStatus.put(OL.OrderId,OL.Order_Status__c);
                                    }
                                    else if(OL.Order_Status__c==deleveredStatus)
                                    {
                                        ++deliverCount;
                                        System.debug('deliverCount>>'+deliverCount);
                                        if(deliverCount==noOfLineItems)
                                        orderIdAndStatus.put(OL.OrderId,OL.Order_Status__c);
                                    }
                                }
                        System.debug('shipCount>>'+shipCount);
                        System.debug('deliverCount>>'+deliverCount);
                        System.debug('noOfLineItems>>'+noOfLineItems);
                        System.debug('orderIdAndStatus>>'+orderIdAndStatus);
                            if(shipCount==noOfLineItems)
                            {
                                if(orderIdAndStatus.containsKey(ord.id))
                                {
                                    ord.Orders_Status__c=orderIdAndStatus.get(ord.id);
                                     olist.add(ord);
                                }
                            }
                            else if(deliverCount==noOfLineItems)
                            {
                                if(orderIdAndStatus.containsKey(ord.id))
                                {
                                    ord.Orders_Status__c=orderIdAndStatus.get(ord.id);
                                      olist.add(ord);
                                }
                            }
                        }
                    }
                    System.debug('olist>>'+olist);
                    if(olist.size()>0)
                        update olist;
                   
                   /* List<Order> olist=new List<Order>();
                    for(Order ord:ListOfOrders)
                    {
                        ord.Orders_Status__c=ShipmentStatus;
                        olist.add(ord);
                        
                    }
                    
                    if(olist.size()>0)
                        update olist;*/
                    
                    
                    
                }
                else{
                    // new code to update orderLine 
                    List<Product_Order_Price_Book__c> OrderLineShippedQtyToUpdate = new List<Product_Order_Price_Book__c>();  
                    List<Product_Order_Price_Book__c> Orderlines;
                    Orderlines =[Select id,name,Sigma_Order__c,Shipped_Quantity__c,Product__r.Id,Packaged_Quantity__c,Quantity__c,Delivered_Quantity__c,Net_Quantity__c,IsInventoryUpdated__c,(select id,name,ILPLI__c,Quantity__c from Inventory_Allocations1__r) from Product_Order_Price_Book__c where Sigma_Order__r.id IN :OrderId AND Packaged_Quantity__c != Null  AND Packaged_Quantity__c != 0 AND Packaged_Quantity__c > 0 and IsInventoryUpdated__c=true and Id IN :orderlineqty.keySet()];
                    
                    
                    for(Product_Order_Price_Book__c ordtoupdate : Orderlines)
                    {
                        Product_Order_Price_Book__c newordtoupdate = new Product_Order_Price_Book__c();
                        packedQty = orderlineqty.get(ordtoupdate.id);
						for(Inventory_Allocation__c ia: ordtoupdate.Inventory_Allocations1__r)
						{
							if(ilpliIdQuantinIA.containsKey(ia.ILPLI__c))
								ilpliIdQuantinIA.put(ia.ILPLI__c,ilpliIdQuantinIA.get(ia.ILPLI__c)+ia.Quantity__c);
							else
								ilpliIdQuantinIA.put(ia.ILPLI__c,ia.Quantity__c);
							system.debug('ilpliIdQuantinIA>>>'+ilpliIdQuantinIA);
						}
						if(ordtoupdate.Shipped_Quantity__c==null)  newordtoupdate.Shipped_Quantity__c=0;
                        if(packedQty!=null){
                            newordtoupdate.Shipped_Quantity__c = ordtoupdate.Shipped_Quantity__c + packedQty;
                            newordtoupdate.Packaged_Quantity__c = ordtoupdate.Packaged_Quantity__c - packedQty;
                        }
                        newordtoupdate.Id = ordtoupdate.Id;
                        OrderLineShippedQtyToUpdate.add(newordtoupdate);                        
                        
                    }                    
                    update OrderLineShippedQtyToUpdate ;
                    
                     if(ilpliIdQuantinIA.values().size()>0){
                            InventoryManagement.reduceInventoryoutbound(ilpliIdQuantinIA,'Shipped');
                        }
                    
                }
            }
            
            //Added on 18/05/2016            
            if(ShipmentStatus == 'Delivered')
            {
                Integer packedQtydelivered;
                List<Inventory__c> prodInvsdelivered;
                prodInvsdelivered = [SELECT id,name,Reserved_Qty__c,ProductCode__c,Delivered_Qty__c,Shipped_Qty__c,ProductCode__r.Id, Rental_Shipped_Quantity__c, Rental_Delivered_Quantity__c 
                                     FROM Inventory__c WHERE ProductCode__c IN :productId];
                Set<Id>ProId = new Set<Id>();
                Map<Id,Decimal>produration = new Map<Id,Decimal>();
                Map<Id,string>prointerval = new Map<Id,string>();
                Map<Id,Decimal>serviceduration = new Map<Id,Decimal>();
                Map<Id,string>serviceinterval = new Map<Id,string>();
                Decimal days;
                Decimal totaldays;
                Decimal servicedays;
                Decimal servicetotaldays;
        Map<Id,Decimal> ilpliIdQuantinIA = new Map<Id,Decimal>();
                if(OrderTypeusage.Standard_object__c == true)
                {    
                    List<OrderItem> OrderLineShippedQtyToUpdate = new List<OrderItem>();  
                    List<OrderItem> Orderlines;
                    
                    Orderlines =[Select id,OrderId,Shipped_Quantity__c,Pricebookentry.Product2Id,Packaged_Quantity__c,Quantity,Delivired__c,Net_Quantity__c,Order_Status__c,IsInventoryUpdated__c,(select id,name,ILPLI__c,Quantity__c from Inventory_Allocations__r) from OrderItem where OrderId IN :OrderId AND Packaged_Quantity__c!= Null and IsInventoryUpdated__c=true  and Id IN :orderlineqty.keySet()];
                   //code to handle product warranty 
           system.debug('Orderlines@@'+Orderlines);
                   for(OrderItem orditem :Orderlines)
                   {
                       ProId.add(orditem.Pricebookentry.Product2Id);
             for(Inventory_Allocation__c ia: orditem.Inventory_Allocations__r)
             {
               
              if(ilpliIdQuantinIA.containsKey(ia.ILPLI__c))
                ilpliIdQuantinIA.put(ia.ILPLI__c,ilpliIdQuantinIA.get(ia.ILPLI__c)+ia.Quantity__c);
              else
                ilpliIdQuantinIA.put(ia.ILPLI__c,ia.Quantity__c);
               system.debug('ilpliIdQuantinIA>>>'+ilpliIdQuantinIA);
             }
                   }
           if(ilpliIdQuantinIA.values().size()>0){
                            InventoryManagement.reduceInventoryoutbound(ilpliIdQuantinIA,'Delivered');
                        }
                   List<Product2> productlist = [Select id,name,Warranty_Applicable__c,Warranty_Duration__c,Warranty_Interval__c,Service_Warranty_Applicable__c,Service_Warranty_Duration__c,Service_Warranty_Interval__c from Product2 where id=:ProId];
                    for(Product2 pro:productlist)
                    {
                        if(pro.Warranty_Applicable__c)
                        {
                            produration.put(pro.id,pro.Warranty_Duration__c);
                            prointerval.put(pro.id,pro.Warranty_Interval__c);
                        }
                        if(pro.Service_Warranty_Applicable__c)
                        {
                            serviceduration.put(pro.id,pro.Service_Warranty_Duration__c);
                            serviceinterval.put(pro.id,pro.Service_Warranty_Interval__c);
                        }
                        
                    }
                    
                    for(OrderItem ordtoupdate : Orderlines)
                    {
                        
                        if(ordtoupdate.Delivired__c == null )
                        {
                            ordtoupdate.Delivired__c = 0;
                        }
                        OrderItem newordtoupdate = new OrderItem(); 
                        packedQtydelivered = orderlineqty.get(ordtoupdate.id);
                        if(ordtoupdate.Shipped_Quantity__c ==null) ordtoupdate.Shipped_Quantity__c=0;
                        if(packedQtydelivered!=null){
                            newordtoupdate.Shipped_Quantity__c = ordtoupdate.Shipped_Quantity__c - packedQtydelivered;
                            newordtoupdate.Delivired__c = ordtoupdate.Delivired__c + packedQtydelivered;
                        }
                        newordtoupdate.Order_Status__c=ShipmentStatus;
                        newordtoupdate.Delivery_Date__c =  date.today();
                        if(produration.containsKey(ordtoupdate.Pricebookentry.Product2Id) && prointerval.containsKey(ordtoupdate.Pricebookentry.Product2Id))
                        {
                            newordtoupdate.Product_Warranty_Start_Date__c = newordtoupdate.Delivery_Date__c; 
                            newordtoupdate.Product_Duration__c = produration.get(ordtoupdate.Pricebookentry.Product2Id);
                            newordtoupdate.Product_Interval__c = prointerval.get(ordtoupdate.Pricebookentry.Product2Id);
                        if(newordtoupdate.Product_Interval__c =='Day')
                        {
                            days = 1;
                            totaldays = newordtoupdate.Product_Duration__c * days;    
                        }
                         
                        else if(newordtoupdate.Product_Interval__c == 'Month')
                        {
                        days = 30;
                        totaldays = newordtoupdate.Product_Duration__c * days;
                        }
                        else if(newordtoupdate.Product_Interval__c == 'Year')
                        {
                        days = 365;
                        totaldays = newordtoupdate.Product_Duration__c * days;
                        }
                        Date enddate = newordtoupdate.Product_Warranty_Start_Date__c + Integer.valueOf(totaldays);
                        //enddate.setDate(enddate.getDate() + totaldays);
                        newordtoupdate.Product_Warranty_End_Date__c = enddate;
                        newordtoupdate.Warranty_Created__c =true;
                        }
                    
                        if(serviceduration.containsKey(ordtoupdate.Pricebookentry.Product2Id) && serviceinterval.containsKey(ordtoupdate.Pricebookentry.Product2Id))
                        {
                            newordtoupdate.Service_Start_Date__c = newordtoupdate.Delivery_Date__c; 
                            newordtoupdate.Service_Duration__c = serviceduration.get(ordtoupdate.Pricebookentry.Product2Id);
                            newordtoupdate.Service_Interval__c = serviceinterval.get(ordtoupdate.Pricebookentry.Product2Id);
                        if(newordtoupdate.Service_Interval__c =='Day')
                        {
                            servicedays = 1;
                            servicetotaldays = newordtoupdate.Service_Duration__c * servicedays;    
                        }
                         
                        else if(newordtoupdate.Service_Interval__c == 'Month')
                        {
                        servicedays = 30;
                        servicetotaldays = newordtoupdate.Service_Duration__c * servicedays;
                        }
                        else if(newordtoupdate.Service_Interval__c == 'Year')
                        {
                        servicedays = 365;
                        servicetotaldays = newordtoupdate.Service_Duration__c * servicedays;
                        }
                        Date enddate = newordtoupdate.Service_Start_Date__c + Integer.valueOf(servicetotaldays);
                        //enddate.setDate(enddate.getDate() + totaldays);
                        newordtoupdate.Service_End_Date__c = enddate;
                        newordtoupdate.Warranty_Created__c =true;
                        }   
                            
                            
                            
                            
                    
                        newordtoupdate.Id = ordtoupdate.Id;
                        OrderLineShippedQtyToUpdate.add(newordtoupdate); 
                       
                    }
                    update OrderLineShippedQtyToUpdate ;
                    ///////////////////
                            List<OrderItem> oilistZeroQty=new List<OrderItem>();
                        List<OrderItem>  ListOfOrderlinesWithZeroQty=  [select id,Order_Status__c,IsInventoryUpdated__c from OrderItem where OrderId in :OrderId And Quantity=0];
                        system.debug('ListOfOrderlinesWithZeroQty>>'+ListOfOrderlinesWithZeroQty);
                        for(OrderItem oi:ListOfOrderlinesWithZeroQty)
                            {
                                system.debug('oi>>'+oi);
                        
                                oi.Order_Status__c=ShipmentStatus;
                                oilistZeroQty.add(oi);
                            }
                            system.debug('oilistZeroQty>>'+oilistZeroQty);
                        
                             if(oilistZeroQty.size()>0)
                            update oilistZeroQty;
                    ///////////////////
                      List<Order> olist=new List<Order>();
                      if( OrderId != null && !OrderId.isEmpty())
                    {
                    ListOfOrders=  [select id,name,Orders_Status__c,(select id,Order_Status__c,OrderId from OrderItems) from Order where id in :OrderId];
                    }
                    System.debug('ListOfOrders>>'+ListOfOrders);
                    for(Order ord:ListOfOrders)
                    {
                        if(ord.OrderItems.size()>0)
                        {
                            Integer noOfLineItems=ord.OrderItems.size();
                            System.debug('noOfLineItems>>'+noOfLineItems);
                            String shipStatus='Shipped';
                            String deleveredStatus='Delivered';
                            Integer shipCount=0;
                            Integer deliverCount=0;
                            Map<Id,String>orderIdAndStatus=new Map<Id,String>();
                            System.debug('orderIdAndStatus>>'+orderIdAndStatus);
                             for(OrderItem OL:ord.OrderItems)
                                { 
                                    System.debug('OL>>'+OL);
                                    if(OL.Order_Status__c==shipStatus)
                                    { 
                                        ++shipCount;
                                        System.debug('shipCount>>'+shipCount);
                                        if(shipCount==noOfLineItems)
                                        orderIdAndStatus.put(OL.OrderId,OL.Order_Status__c);
                                    }
                                    else if(OL.Order_Status__c==deleveredStatus)
                                    {
                                        ++deliverCount;
                                        System.debug('deliverCount>>'+deliverCount);
                                        if(deliverCount==noOfLineItems)
                                        orderIdAndStatus.put(OL.OrderId,OL.Order_Status__c);
                                    }
                                }
                        System.debug('shipCount>>'+shipCount);
                        System.debug('deliverCount>>'+deliverCount);
                        System.debug('noOfLineItems>>'+noOfLineItems);
                        System.debug('orderIdAndStatus>>'+orderIdAndStatus);
                            if(shipCount==noOfLineItems)
                            {
                                if(orderIdAndStatus.containsKey(ord.id))
                                {
                                    ord.Orders_Status__c=orderIdAndStatus.get(ord.id);
                                     olist.add(ord);
                                }
                            }
                            else if(deliverCount==noOfLineItems)
                            {
                                if(orderIdAndStatus.containsKey(ord.id))
                                {
                                    ord.Orders_Status__c=orderIdAndStatus.get(ord.id);
                                      olist.add(ord);
                                }
                            }
                        }
                    }
                    System.debug('olist>>'+olist);
                    if(olist.size()>0)
                        update olist;
                                        
                  /*  List<Order> olist=new List<Order>();
                    for(Order ord:ListOfOrders)
                    {
                        ord.Orders_Status__c=ShipmentStatus;
                        olist.add(ord);
                        
                    }
                    
                    if(olist.size()>0)
                        update olist;*/ //commented on 04-03-2020
                }
                else 
                {
                    // new code to update orderLine 
                    List<Product_Order_Price_Book__c> OrderShippedQtyToUpdatedelivered = new List<Product_Order_Price_Book__c>();  
                    List<Product_Order_Price_Book__c> Orderdelivered;
                    Orderdelivered =[Select id,name,Sigma_Order__c,Shipped_Quantity__c,Product__r.Id,Packaged_Quantity__c,Quantity__c,Delivered_Quantity__c,Net_Quantity__c ,Order_Status__c,IsInventoryUpdated__c,(select id,name,ILPLI__c,Quantity__c from Inventory_Allocations1__r) from Product_Order_Price_Book__c where Sigma_Order__r.id IN :OrderId AND Packaged_Quantity__c != Null and IsInventoryUpdated__c=true and Id IN :orderlineqty.keySet()];
          system.debug('Orderdelivered>>>'+Orderdelivered);
          
                    for(Product_Order_Price_Book__c orditem :Orderdelivered)
                   {
                       ProId.add(orditem.Product__r.Id);
             for(Inventory_Allocation__c ia: orditem.Inventory_Allocations1__r)
             {
              if(ilpliIdQuantinIA.containsKey(ia.ILPLI__c))
                ilpliIdQuantinIA.put(ia.ILPLI__c,ilpliIdQuantinIA.get(ia.ILPLI__c)+ia.Quantity__c);
              else
                ilpliIdQuantinIA.put(ia.ILPLI__c,ia.Quantity__c);
               system.debug('ilpliIdQuantinIA>>>'+ilpliIdQuantinIA);
             }
                   }
            if(ilpliIdQuantinIA.values().size()>0){
                            InventoryManagement.reduceInventoryoutbound(ilpliIdQuantinIA,'Delivered');
                        }
                    List<Product2> productlist = [Select id,name,Warranty_Applicable__c,Warranty_Duration__c,Warranty_Interval__c,Service_Warranty_Applicable__c,Service_Warranty_Duration__c,Service_Warranty_Interval__c from Product2 where id=:ProId];
                    for(Product2 pro:productlist)
                    {
                        if(pro.Warranty_Applicable__c)
                        {
                            produration.put(pro.id,pro.Warranty_Duration__c);
                            prointerval.put(pro.id,pro.Warranty_Interval__c);
                        }
                        if(pro.Service_Warranty_Applicable__c)
                        {
                            serviceduration.put(pro.id,pro.Service_Warranty_Duration__c);
                            serviceinterval.put(pro.id,pro.Service_Warranty_Interval__c);
                        }
                        
                    }  
                    
                      
                    for(Product_Order_Price_Book__c ordtoupdate : Orderdelivered)
                    {                        
                        Product_Order_Price_Book__c newordtoupdate = new Product_Order_Price_Book__c();
                        packedQtydelivered = orderlineqty.get(ordtoupdate.id);
                        if(ordtoupdate.Shipped_Quantity__c ==null) ordtoupdate.Shipped_Quantity__c=0;
                        
                        if(packedQtydelivered!=null){
                            newordtoupdate.Shipped_Quantity__c = ordtoupdate.Shipped_Quantity__c - packedQtydelivered;
                            newordtoupdate.Delivered_Quantity__c = ordtoupdate.Delivered_Quantity__c + packedQtydelivered;
                        }
                        ordtoupdate.Order_Status__c=ShipmentStatus;
                        newordtoupdate.Delivary_Date__c =  date.today();
                        if(produration.containsKey(ordtoupdate.Product__r.Id) && prointerval.containsKey(ordtoupdate.Product__r.Id))
                        {
                            newordtoupdate.Product_Warranty_Start_Date__c = newordtoupdate.Delivary_Date__c; 
                            newordtoupdate.Product_Duration__c = produration.get(ordtoupdate.Product__r.Id);
                            newordtoupdate.Product_Interval__c = prointerval.get(ordtoupdate.Product__r.Id);
                        if(newordtoupdate.Product_Interval__c =='Day')
                        {
                            days = 1;
                            totaldays = newordtoupdate.Product_Duration__c * days;    
                        }
                         
                        else if(newordtoupdate.Product_Interval__c == 'Month')
                        {
                        days = 30;
                        totaldays = newordtoupdate.Product_Duration__c * days;
                        }
                        else if(newordtoupdate.Product_Interval__c == 'Year')
                        {
                        days = 365;
                        totaldays = newordtoupdate.Product_Duration__c * days;
                        }
                        Date enddate = newordtoupdate.Product_Warranty_Start_Date__c + Integer.valueOf(totaldays);
                        //enddate.setDate(enddate.getDate() + totaldays);
                        newordtoupdate.Product_Warranty_End_Date__c = enddate;
                        newordtoupdate.Warranty_Created__c =true;
                        }
                        
                        if(serviceduration.containsKey(ordtoupdate.Product__r.Id) && serviceinterval.containsKey(ordtoupdate.Product__r.Id))
                        {
                            newordtoupdate.Service_Start_Date__c = newordtoupdate.Delivary_Date__c; 
                            newordtoupdate.Service_Duration__c = serviceduration.get(ordtoupdate.Product__r.Id);
                            newordtoupdate.Service_Intervals__c = serviceinterval.get(ordtoupdate.Product__r.Id);
                        if(newordtoupdate.Service_Intervals__c =='Day')
                        {
                            servicedays = 1;
                            servicetotaldays = newordtoupdate.Service_Duration__c * servicedays;    
                        }
                         
                        else if(newordtoupdate.Service_Intervals__c == 'Month')
                        {
                        servicedays = 30;
                        servicetotaldays = newordtoupdate.Service_Duration__c * servicedays;
                        }
                        else if(newordtoupdate.Service_Intervals__c == 'Year')
                        {
                        servicedays = 365;
                        servicetotaldays = newordtoupdate.Service_Duration__c * servicedays;
                        }
                        Date enddate = newordtoupdate.Service_Start_Date__c + Integer.valueOf(servicetotaldays);
                        //enddate.setDate(enddate.getDate() + totaldays);
                        newordtoupdate.Service_End_Date__c = enddate;
                        newordtoupdate.Warranty_Created__c =true;
                        }
                        
                        
                        
                        newordtoupdate.Id = ordtoupdate.Id;
                        OrderShippedQtyToUpdatedelivered.add(newordtoupdate);
                        //  }
                        
                        
                    } 
                    
                    update OrderShippedQtyToUpdatedelivered;
                    
                }
            }
            Shipment__c ship=[select Id,Name from Shipment__c where id =:ShipmentObj.Id limit 1];
            if(ship!=null)
            {
                ShipmentObj=ship;
            }
             }catch(Exception e)
                {
                String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                    createErrorLog.insertError('AddShipmentProductsLtng',ex,'Method -updateShipment ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                    Database.rollback(sp);
              }
            
        //}
        return shipmentObj;
    }
    
    /* ------------------------------------------------------------
Author  :  Vikas 
Company :  Mindlinks 
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  : Shipment Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
23-11-2016  Vikas               Its checks the Object FLS & CRUD permission of passed object and field. 
------------------------------------------------------------ */
    
    public Static boolean FLSCheckShipment(){
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Shipment__c',new Set<String>{'sigmaerpdev2__Account__r.Name',
            'sigmaerpdev2__Delivery_Person1__c','sigmaerpdev2__Delivery_Person__c','sigmaerpdev2__Delivery_Person__r.Name','sigmaerpdev2__Description__c','sigmaerpdev2__Shipment_Date__c','sigmaerpdev2__Truck_No__c',
            'sigmaerpdev2__Status__c'}))
        {*/
            return true;
        /*}  
        return false;*/
    }
    
    
    /* ------------------------------------------------------------
Author  :  Vikas 
Company :  Mindlinks 
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  : Shipment_Products Object and its fields.
Returns : Boolean flag - It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
23-11-2016  Vikas               Its checks the Object FLS & CRUD permission of passed object and field. 
------------------------------------------------------------ */
    
    public Static boolean FLSCheckShipmentProducts(){
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Shipment_Products__c',new Set<String>{'Name','sigmaerpdev__Package_ID__c',
            'sigmaerpdev2__Customer_Name__r.Name','sigmaerpdev2__Customer_Name__c','sigmaerpdev2__Order__c','sigmaerpdev2__Shipment_Delivery_Date__c',
            'sigmaerpdev2__Status__c','sigmaerpdev2__Contact_Person__c'}))
        {*/
            return true;
        /*}  
        return false;*/
    }
    
    
    /* ------------------------------------------------------------
Author  :  Vikas 
Company :  Mindlinks 
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  : Shipment_Products Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
23-11-2016  Vikas               Its checks the Object FLS & CRUD permission of passed object and field.
------------------------------------------------------------ */
    public Static boolean FLSCheckInsertShipmentProducts(){
        /*if(CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Shipment_Products__c',new Set<String>{'sigmaerpdev2__Package_ID__c','sigmaerpdev2__Customer_Name__c','sigmaerpdev2__Shipment_Delivery_Date__c',
            'sigmaerpdev2__Status__c'}))     
            
        {*/
            return true;
       /* }  
        return false;*/
    }
    
    /* ------------------------------------------------------------
Author  :  Vikas 
Company :  Mindlinks 
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  : Package Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
23-11-2016  Vikas               Its checks the Object FLS & CRUD permission of passed object and field. 
------------------------------------------------------------ */
    
    public Static boolean FLSCheckPackage(){
  /*      if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Package__c',new Set<String>{'sigmaerpdev2__Customer__c','sigmaerpdev2__Customer__r.Name','Name','sigmaerpdev2__Status__c','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__Sigma_Order__r.Name','sigmaerpdev2__Sigma_Order__r.sigmaerpdev2__BillingPersonNew__c','sigmaerpdev2__Order__c','sigmaerpdev2__Order__r.sigmaerpdev2__BillingPersonNew__c','sigmaerpdev2__Order__r.OrderNumber'})){
*/        
        return true;
        /*}  
        return false;*/
    }
    
    /* ------------------------------------------------------------
Author  :  Javed
Company :  Mindlinks 
Description : Get the  Object  permission which is passed.

Inputs  : Package Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
12-12-2016  Javed               Its checks the Object  permission of passed object and field. 
------------------------------------------------------------ */
    
    public Static boolean CheckObjectPackage(){
  /*      if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Package__c')){
*/   
   return true;
 /*       }  
        return false;*/
    }
    
    /* ------------------------------------------------------------
Author  :  Vikas 
Company :  Mindlinks
Description : Get the  Object access permission which is passed.

Inputs  : Shipment Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
23-11-2016  Vikas               Its checks the Object access permission .
------------------------------------------------------------ */
    public Static boolean checkObjectShipment()
    {
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Shipment__c'))
        {*/
            return true;
        /*}  
        return false;*/
    }
    
    /* ------------------------------------------------------------
Author  :  Vikas 
Company :  Mindlinks
Description : Get the  Object access permission which is passed.

Inputs  : Shipment_Products Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
23-11-2016  Vikas               Its checks the Object access permission .
------------------------------------------------------------ */
    public Static boolean checkObjectShipmentProducts()
    {
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Shipment_Products__c'))
        {*/
            return true;
        /*}  
        return false;*/
    }
    
    /*FLS check for delete operation*/
    public Static boolean checkObjectShipmentProducts1()
    {
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Shipment_Products__c'))
        {*/
            return true;
        /*}  
        return false;*/
    }
    
    
    /* ---------------------------------------------- AfterShip Integration  ----------------------------------------*/
    
    //Getting all Couriers availble
    @AuraEnabled
    public static Map<String,String> getCouriers(){ 
        string errorMessage='';
        Map<String,String> Courierlist = New Map<String,String>();
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__AfterShip_Courier_List__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__AfterShip_Courier_List__c',new set<String>{'Name','sigmaerpdev__Slug__c'}))
                {*/
        
        try{
            List<AfterShip_Courier_List__c> configvalues = AfterShip_Courier_List__c.getAll().values();
            for(AfterShip_Courier_List__c scl:configvalues){
                Courierlist.put(scl.Name,scl.Slug__c);
            }
            return Courierlist;
        }
        catch(CalloutException ex){
            Courierlist.put(ex.getTypeName(),ex.getMessage());
           
        }
         //       }
                 return Courierlist;
    }
    
    //Getting available couriers
    public class CourierRespwrapper{
        public metaWrapper meta;
        public dataWrapper data;
    }
    
    public class metaWrapper{
        public string code;
        public string message;
    }
    
    public class dataWrapper{
        public string total;
        public List<courierslistWrap> couriers;
        public trackingWrapper tracking;
    }
    public class courierslistWrap{
        public string slug;
        public string name;
    }
    
    public class trackingWrapper{
        public string tracking_number;
        public string tag;
        public string subtag_message;
    }
    
    //Pushing a Shipment record to AfterShip
    @AuraEnabled
    public static StatusWrapper pushtoAfterShip(Id ShipmentID,String courier,String trackNum){ 
        string errorMessage='';
        StatusWrapper s;
            /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Shipment__c')
             && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Shipment_Products__c')
             && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__AfterShip_Defaults__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__AfterShip_Courier_List__c')
            
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Shipment__c',new set<String>{'Id','Name','sigmaerpdev__Shipment_Date__c','sigmaerpdev__Account__c','sigmaerpdev__Selected_Courier__c','sigmaerpdev__Tracking_ID__c','sigmaerpdev__Status__c','sigmaerpdev__Account__r.sigmaerpdev__Email__c','sigmaerpdev__Account__r.Phone'})
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Shipment_Products__c',new set<String>{'id','sigmaerpdev__Package_ID__c','sigmaerpdev__Package_ID__r.sigmaerpdev__Order__c','sigmaerpdev__Package_ID__r.sigmaerpdev__Sigma_Order__c','sigmaerpdev__Customer_Name__r.sigmaerpdev__Email__c','sigmaerpdev__Customer_Name__r.Phone'}) 
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new set<String>{'id','sigmaerpdev__Package__c','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Product_Order__r.sigmaerpdev__Total_Price__c'})
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__AfterShip_Courier_List__c',new set<String>{'sigmaerpdev__Slug__c'})

             && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Shipment__c',new set<String>{'sigmaerpdev__Pushed_to_aftership__c','sigmaerpdev__Tracking_Number__c'}))
             {*/

       try{
            set<id> soids = new set<id>();
            set<id> oids = new set<id>();
            List<Shipment__c> shipment = New List<Shipment__c>();
            shipment = [SELECT Id,Name,Shipment_Date__c,Account__c,Selected_Courier__c,Tracking_ID__c,Status__c,Account__r.Email__c,Account__r.Phone,
                        (SELECT id,Package_ID__c,Package_ID__r.Order__c,Package_ID__r.Sigma_Order__c,Customer_Name__r.Email__c,Customer_Name__r.Phone FROM Shipment_Products__r) FROM Shipment__c WHERE Id=:ShipmentID];
            set<Id> packIds = New set<Id>();
            String phone,email;
            String status = shipment[0].Status__c;
            for(Shipment__c ship:shipment){
                for(Shipment_Products__c shipprod:ship.Shipment_Products__r){
                    packIds.add(shipprod.Package_ID__c);
                    phone = shipprod.Customer_Name__r.Email__c;
                    email = shipprod.Customer_Name__r.phone;
                    soids.add(shipprod.Package_ID__r.Sigma_Order__c);
                    oids.add(shipprod.Package_ID__r.Order__c);
                }
            }
            PackagedProducts__c packprod = [SELECT id,Package__c,Product__c,Product__r.Name,Product_Order__r.Total_Price__c FROM PackagedProducts__c WHERE Package__c IN:packIds LIMIT 1];
           
            Map<string,AfterShip_Defaults__c> configvalues = AfterShip_Defaults__c.getAll();
            AfterShip_Defaults__c config = new AfterShip_Defaults__c();
            if(configvalues.containsKey('DefaultValues'))
            {
                config = configvalues.get('DefaultValues');                
            }
            
            List<AfterShip_Courier_List__c> courierList = AfterShip_Courier_List__c.getall().values();
            String  slug;
            for(AfterShip_Courier_List__c acl:courierList){
                if(acl.Name==shipment[0].Selected_Courier__c){
                    slug = acl.Slug__c;
                }
            }
            
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(config.Create_Shipment__c);            
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept', 'application/json');
            req.setHeader('aftership-api-key', config.API_Key__c);
            HTTPResponse res;
            
            JSONGenerator gen = JSON.createGenerator(true);
            JSONGenerator genToStore = JSON.createGenerator(true);
            
            gen.writeStartObject();
            gen.writeFieldName('tracking');
            gen.writeStartObject();
            gen.writeStringField('slug', slug);
            gen.writeStringField('tracking_number', shipment[0].Tracking_ID__c);
            gen.writeStringField('title', shipment[0].Name);
            gen.writeFieldName('smses');
            gen.writeStartArray();
            if(phone!=null)
                gen.writeString(phone);
            //gen.writeString('0987654321');
            gen.writeEndArray();
            gen.writeFieldName('emails');
            gen.writeStartArray();
            if(email!=null)
                gen.writeString(email);
            //gen.writeString('test@two.com');
            gen.writeEndArray();
            gen.writeFieldName('custom_fields');
            gen.writeStartObject();
            gen.writeStringField('product_name',packprod.Product__r.Name);
            gen.writeStringField('product_price','');
            gen.writeEndObject();
            gen.writeEndObject();
            gen.writeEndObject();
            
            String jsonString = gen.getAsString();
            String jsonFileString = genToStore.getAsString();
            
            req.setBody(jsonString);
            Http http = new Http();
            res = http.send(req);
            System.debug('res>>'+res);
            PushShipRespwrapper wrapperCon = (PushShipRespwrapper)JSON.deserialize(res.getBody(),PushShipRespwrapper.class);
            System.debug('res.getBody()>>'+res.getBody());
            System.debug('wrapperCon>>'+wrapperCon);
            
            if(res.getStatusCode() == 201){
                Shipment__c ship = New Shipment__c();
                ship.Id = ShipmentID;
                ship.Pushed_to_aftership__c =  true;
                ship.Tracking_Number__c = trackNum;
                update ship;
                s=new StatusWrapper(True,'Success');
                return s;
            }
            else{
                if(res.getStatusCode()>=400){
                    errorMessage = wrapperCon.meta.message;
                }
               s=new StatusWrapper(False,errorMessage);
                return s;
            }
           
            }
            catch(CalloutException ex){
              s=new StatusWrapper(false,ex.getMessage());
               
            }
        //}
        return s;
    }
    
    public class PushShipRespwrapper{
        public metaNewWrapper meta;
    }
    public class metaNewWrapper{
        public string code;
        public string message;
    }
    
    @AuraEnabled
    public static Shipment__c getShipdetails(Id shipId){
        Shipment__c ship;
       /*  if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Shipment__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Shipment__c',new set<String>{'id','sigmaerpdev__Pushed_to_aftership__c','sigmaerpdev__Status__c','sigmaerpdev__Tracking_ID__c','sigmaerpdev__Courier_Status__c','sigmaerpdev__Selected_Courier__c'}))
                {*/
             
        ship = [SELECT id,Pushed_to_aftership__c,Status__c,Tracking_ID__c,Courier_Status__c,Selected_Courier__c FROM Shipment__c WHERE Id=:shipId];
              //  }
                return ship;
    }
    
    public class StatusWrapper{
        @AuraEnabled
        public Boolean status;
        @AuraEnabled
        public string errorMessage;
        
        public StatusWrapper(Boolean st,String err)
        {
            status=st;
            errorMessage=err;
        }
    }
    
    
    //Getting all Couriers availble
    @AuraEnabled
    public static StatusWrapper trackCourier(Id shipId){ 
        string status='';
        StatusWrapper s;
        /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Shipment_Products__c')
             && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Shipment__c')
             && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
             && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
             && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
             && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
             && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
             && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__AfterShip_Defaults__c')
              && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__AfterShip_Courier_List__c')
             
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__AfterShip_Courier_List__c',new set<String>{'sigmaerpdev__Slug__c'})
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Shipment__c',new set<String>{'Id','Name','sigmaerpdev__Selected_Courier__c','sigmaerpdev__Tracking_ID__c'})
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Shipment_Products__c',new set<String>{'Id','sigmaerpdev__Status__c','sigmaerpdev__Package_ID__c','sigmaerpdev__Shipment__c'})
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new set<String>{'Id','sigmaerpdev__Status__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Order__c'})
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'id','sigmaerpdev__Orders_Status__c'})
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'id','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Shipped_Quantity__c'})
             && CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'id','sigmaerpdev__Orders_Status__c'})
             && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'id','OrderId','sigmaerpdev__Order_Status__c','sigmaerpdev__Shipped_Quantity__c','sigmaerpdev__Delivery_Date__c'})

             && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev__Order_Status__c','sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Shipped_Quantity__c'})
             && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sigma_Order__c',new set<String>{'sigmaerpdev__Orders_Status__c'})
             && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Shipment_Products__c',new set<String>{'sigmaerpdev__Status__c'})
             && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Package__c',new set<String>{'sigmaerpdev__Status__c'})
             && CRUD_FLS_CheckUtility.checkFLS('OrderItem',new set<String>{'sigmaerpdev__Order_Status__c','sigmaerpdev__Delivired__c','sigmaerpdev__Shipped_Quantity__c'})
             && CRUD_FLS_CheckUtility.checkFLS('Order',new set<String>{'sigmaerpdev__Orders_Status__c'})
             && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Shipment__c',new set<String>{'sigmaerpdev__Courier_Status__c','sigmaerpdev__Status__c'}))
                 {*/

    try{
            List<Shipment_Products__c> sptoUpdate = New List<Shipment_Products__c>();
            List<Package__c> packtoUpdate = New List<Package__c>();
            List<Sigma_Order__c> sotoUpdate = New List<Sigma_Order__c>();
            List<Product_Order_Price_Book__c> soOlUpdate = New List<Product_Order_Price_Book__c>();
            List<Order> ordertoUpdate = New List<Order>();
            List<OrderItem> OrderItemUpdate = New List<OrderItem>();
            
            set<id> spids = new set<id>();
            set<id> packids = new set<id>();
            set<id> soids = new set<id>();
            set<id> oids = new set<id>();
            
            Shipment__c shipment = [SELECT Id,Name,Selected_Courier__c,Tracking_ID__c FROM Shipment__c WHERE Id=:shipId];
            
            List<Shipment_Products__c> shipProd = [SELECT Id,Status__c,Package_ID__c FROM Shipment_Products__c WHERE Shipment__c=:shipId];
            
            for(Shipment_Products__c sp: shipProd){
                packids.add(sp.Package_ID__c);
            }
                        
            List<Package__c> pack = [SELECT Id,Status__c,Sigma_Order__c,Order__c FROM Package__c WHERE Id IN:packids];
            
            for(Package__c p: pack){
                if(p.Sigma_Order__c!=null)
                    soids.add(p.Sigma_Order__c);
                if(p.Order__c!=null)
                    oids.add(p.Order__c);
            }
            
            List<Sigma_Order__c> sigmaOrder;
            List<Product_Order_Price_Book__c> orderLine;
            List<Order> OrderList;
            List<OrderItem> OrderItemlist;
            
            if(soids!=null){
                sigmaOrder  = [SELECT id,Orders_Status__c FROM Sigma_Order__c WHERE id IN:soids];                
                orderLine  = [SELECT id,Sigma_Order__c,Order_Status__c,Delivered_Quantity__c,Shipped_Quantity__c FROM Product_Order_Price_Book__c WHERE Sigma_Order__c IN:soids];                
            }
            
            if(oids!=null){
                OrderList = [SELECT id,Orders_Status__c FROM Order WHERE id IN:oids];                
                OrderItemlist  = [SELECT id,OrderId,Order_Status__c,Shipped_Quantity__c,Delivery_Date__c FROM OrderItem WHERE OrderId IN:oids];                
            }
           
            //To get AfterShip Default values from Custom settings
            Map<string,AfterShip_Defaults__c> configvalues = AfterShip_Defaults__c.getAll();
            AfterShip_Defaults__c config = new AfterShip_Defaults__c();
            if(configvalues.containsKey('DefaultValues'))
            {
                config = configvalues.get('DefaultValues');                
            }
            
            List<AfterShip_Courier_List__c> courierList = AfterShip_Courier_List__c.getall().values();
            String  slug;
            for(AfterShip_Courier_List__c acl:courierList){
                if(acl.Name==shipment.Selected_Courier__c){
                    slug = acl.Slug__c;
                }
            }
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(config.Tracking__c+slug+'/'+shipment.Tracking_ID__c);            
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('aftership-api-key', config.API_Key__c);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            String response = res.getBody();
          System.debug('response>>'+response);  
           System.debug('res>>'+res);  
            CourierRespwrapper wrapperCon = (CourierRespwrapper)JSON.deserialize(res.getBody(),CourierRespwrapper.class);
             System.debug('wrapperCon>>'+wrapperCon);           
            if(res.getStatusCode() == 200){
                status = wrapperCon.data.tracking.tag;
                Shipment__c ship = New Shipment__c();
                ship.Id = shipId;
                ship.Courier_Status__c = status;
                if(status=='Delivered'){
                    ship.Status__c = status;
                    for(Shipment_Products__c sp: shipProd){
                        sp.Status__c = status;
                        sptoUpdate.add(sp);
                    }
                                        
                    for(Package__c p: pack){
                        p.Status__c = status;
                        packtoUpdate.add(p);
                    }
                    
                    //added here
                    update sptoUpdate;
                    update packtoUpdate;
                    //ends here
                    
                    if(soids!=null){
                        for(Sigma_Order__c so: sigmaOrder){
                            so.Orders_Status__c = status;
                            sotoUpdate.add(so);
                        }                        
                        
                        for(Product_Order_Price_Book__c sool: orderLine){
                            sool.Order_Status__c = status;
                            sool.Delivered_Quantity__c = sool.Shipped_Quantity__c;
                            sool.Shipped_Quantity__c = 0;
                            soOlUpdate.add(sool);
                        }                        
                        update sotoUpdate;
                        update soOlUpdate;                                              
                    }
                    
                    if(oids!=null){
                        for(Order o: OrderList){
                            o.Orders_Status__c = status;
                            ordertoUpdate.add(o);
                        }
                        
                        for(OrderItem oi: OrderItemlist){
                            oi.Order_Status__c = status;
                            oi.Delivired__c = oi.Shipped_Quantity__c;
                            oi.Shipped_Quantity__c = 0;
                            OrderItemUpdate.add(oi);
                        }
                        update ordertoUpdate;
                        update OrderItemUpdate;
                    }
                    
                    //commented below section and moved above  
                    /*system.debug('soOlUpdate>> '+soOlUpdate);
                    system.debug('sptoUpdate>> '+sptoUpdate);
                    system.debug('packtoUpdate>> '+packtoUpdate);
                    update sptoUpdate;
                    update packtoUpdate;
                    system.debug('soOlUpdate>> '+soOlUpdate);
                    system.debug('sptoUpdate>> '+sptoUpdate);
                    system.debug('packtoUpdate>> '+packtoUpdate);*/
                }
                update ship;

                s=new StatusWrapper(True,status);
                return s;
            }
            if(res.getStatusCode()>=400){
                status = wrapperCon.meta.message;                
            }
            s=new StatusWrapper(False,status);
            return s;
        }
        catch(CalloutException ex){
            //createErrorLog.insertError('DPD',e.getMessage(),'Class -ShipmentCntrl, Method - PushtoDPD',null,'',e.getStackTraceString(),UserInfo.getUserId());
            s=new StatusWrapper(false,ex.getMessage());
            return s;           
        }
    //}
    return s;
    
}
}