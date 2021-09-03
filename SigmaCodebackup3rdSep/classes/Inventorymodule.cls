/****************************************************************************************************************** 
SL.No      Author                  Version                     Description

1.         Jyoshna.A                1.0 (Initial Version)       workorderInventoryCheck()[this method is invoked from an 
process builder after creating an WO .This method is used 
to create WOLI under WO from Products needed for an Work Type.   
FLS added on 18-04-2020 
* ****************************************************************************************************************/  

public with sharing class Inventorymodule { 
    
    
    public static Void workorderInventoryCheck(List<Work_Order__c> workorderid)
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Work_Order__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Products_Needed__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Work_Oder_Lines__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Checklist_Item__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__WO_Checklist_Item__c')

            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Work_Oder_Lines__c',new Set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__WO_Checklist_Item__c',new Set<String>{'sigmaerpdev2__Name_Text__c','sigmaerpdev2__Work_Order__c'})

            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Products_Needed__c',new Set<String>{'Id','Name','sigmaerpdev2__Products__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Work_Type__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Work_Oder_Lines__c',new Set<String>{'Id','sigmaerpdev2__Work_Order__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Work_Order__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Checklist_Item__c',new Set<String>{'Id','sigmaerpdev2__Name_Text__c','sigmaerpdev2__Work_Type__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__WO_Checklist_Item__c',new Set<String>{'Id','sigmaerpdev2__Name_Text__c','sigmaerpdev2__Work_Order__c'})
            
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Work_Oder_Lines__c',new Set<String>{'sigmaerpdev2__Work_Order__c'})
        )
        {
            List<Id> locationName = new List<Id>();
            System.debug('workorderid'+workorderid);
            try{
                
                // ProductNeeded Fields that will be accessed.
                String [] productNeededFields = new String [] {'sigmaerpdev2__Products__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Work_Type__c'};
                    
                    // Obtaining the field name/token map for the ProductNeeded object
                    Map<String,Schema.SObjectField> productNeededMap = Schema.SObjectType.Products_Needed__c.fields.getMap();
                for (String fieldToCheck : productNeededFields) {
                    // Check if the user has create access on the each field
                    if (!productNeededMap.get(fieldToCheck).getDescribe().isAccessible()) {
                        system.debug('Has no Access on ProductNeeded Fields');
                        return;
                    }
                }
                //Querying products needed with respect to the workorderid and workorderType.
                List<Products_Needed__c> productNeeded = [SELECT Id, Products__c, Quantity__c FROM Products_Needed__c where Work_Type__c  =: workorderid[0].Work_Type__c ];
                System.debug('ProductNeeded'+productNeeded);
                
                
                if(!Work_Oder_Lines__c.sObjectType.getDescribe().isAccessible()){
                    system.debug('Has no read access on Work Order Lines Object');
                    return;
                }
                
                if(!Work_Oder_Lines__c.sObjectType.getDescribe().isDeletable()){
                    system.debug('Has no delete access on Work Order Lines Object');
                    return;
                }
                else{
                    List<Work_Oder_Lines__c> existingListWorkOrderLineItems = [Select Id from Work_Oder_Lines__c where Work_Order__c=:workorderid[0].id];
                    if(existingListWorkOrderLineItems.size()!=0){
                        Delete existingListWorkOrderLineItems;
                        system.debug('existingListWorkOrderLineItems Deleted');
                    } 
                }
                
                
                // WorkOrderLineItem Fields that will be accessed.
                String [] workOrderLineItemFields = new String [] {'sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Work_Order__c'};
                    
                    // Obtaining the field name/token map for the WorkOrderLineItem object
                    Map<String,Schema.SObjectField> workOrderLineItemMap = Schema.SObjectType.Work_Oder_Lines__c.fields.getMap();
                for (String fieldToCheck : workOrderLineItemFields) {
                    // Check if the user has create access on the each field
                    if (!workOrderLineItemMap.get(fieldToCheck).getDescribe().isCreateable()) {
                        system.debug('Has no Access on WorkOrderLineItem Fields');
                        return;
                    }
                }
                
                
                
                
                List<Work_Oder_Lines__c> listWorkOrderLineItems = new List<Work_Oder_Lines__c>();
                //Copying all the Products Needed to WOLI.
                for(Products_Needed__c productsneeded:productNeeded){
                    Work_Oder_Lines__c workorderlineitem= new Work_Oder_Lines__c();
                    workorderlineitem.Product__c=productsneeded.Products__c;
                    workorderlineitem.Quantity__c=productsneeded.Quantity__c;
                    workorderlineitem.Work_Order__c=workorderid[0].id;
                    listWorkOrderLineItems.add(workorderlineitem);
                    System.debug('workorderlineitem:'+workorderlineitem);
                }
                insert listWorkOrderLineItems;
                system.debug('WorkOrderLineItems Inserted Successfully ');
                
                
                // WO CheckList Fields that will be accessed.
                String [] checkListFields = new String [] {'sigmaerpdev2__Name_Text__c'};
                    
                    // Obtaining the field name/token map for the WorkOrder object
                    Map<String,Schema.SObjectField> checkListMap = Schema.SObjectType.Checklist_Item__c.fields.getMap();
                for (String fieldToCheck : checkListFields) {
                    // Check if the user has create access on the each field
                    if (!checkListMap.get(fieldToCheck).getDescribe().isAccessible()) {
                        system.debug('Has no read Access on CheckList Fields');
                        return;
                    }
                }
                List<Checklist_Item__c> checkListItems = [SELECT Id, Name_Text__c FROM Checklist_Item__c where Work_Type__c =:workorderid[0].Work_Type__c ORDER BY Name_Text__c ASC];
                System.debug('checkListItems - '+checkListItems);
                
                
                // WO CheckList Fields that will be accessed.
                String [] woCheckListFields = new String [] {'sigmaerpdev2__Name_Text__c','sigmaerpdev2__Work_Order__c'};
                    
                    // Obtaining the field name/token map for the WorkOrder object
                    Map<String,Schema.SObjectField> woCheckListMap = Schema.SObjectType.WO_Checklist_Item__c.fields.getMap();
                for (String fieldToCheck : woCheckListFields) {
                    // Check if the user has create access on the each field
                    if (!woCheckListMap.get(fieldToCheck).getDescribe().isUpdateable()) {
                        system.debug('Has no update Access on WO CheckList Fields');
                        return;
                    }
                }
                if(checkListItems.size()>0){
                    System.debug('Inside checkListItems.size()>0 If Condition');
                    List<WO_Checklist_Item__c> listWOCheckListItems = new List<WO_Checklist_Item__c>();
                    for(Checklist_Item__c eachCheckListItem : checkListItems){
                        WO_Checklist_Item__c tempWOCheckListItem = new WO_Checklist_Item__c();
                        tempWOCheckListItem.Name_Text__c = eachCheckListItem.Name_Text__c;
                        tempWOCheckListItem.Work_Order__c  = workorderid[0].id;
                        listWOCheckListItems.add(tempWOCheckListItem);
                        System.debug('listWOCheckListItems - '+listWOCheckListItems);
                    }
                    insert listWOCheckListItems;
                    System.debug('WO CheckList Inserted Successfully');
                }
                
            }
            catch(Exception e){
                System.debug(e);
            }        
        }
    }   
}