//code added to handle Resource allocation for MR module Gantt Usage by Rashmi on 20-12-2020
public with sharing class AddResourcesController {
    
     @AuraEnabled
    public static Project_Resource__c saveResourceObject(String resource, String ManuID)
    {
        system.debug('resource>>'+resource);
        system.debug('ManuID>>'+ManuID);
        Project_Resource__c resourceRecord;
      if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Project_Resource__c')
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Project_Resource__c',new set<String>{'sigmaerpdev2__Manufacturing_Run__c','sigmaerpdev2__Resource__c'}))
        {
       
          
           try{
           
            Type otype = Type.forName('sigmaerpdev2__Project_Resource__c');
            resourceRecord = (Project_Resource__c )JSON.deserialize(resource,otype);
           
            resourceRecord.Resource__r = null;
        
            resourceRecord.Manufacturing_Run__c=ManuID;
            upsert resourceRecord;
            
          }
          catch (Exception ex){
            
          }
          }
        return resourceRecord;
    }
    @AuraEnabled
    public static Resource__c fetchResourceData(String resourceid)
    { 
    Resource__c res;
    if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Resource__c')
        &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Resource__c',new set<String>{'id','Name','sigmaerpdev2__Last_Name__c','sigmaerpdev2__Roles__c'})){
        
        res=[select id,Name,Last_Name__c,Roles__c from Resource__c where id=:resourceid limit 1];
        }
        return res; 
    }
    @AuraEnabled  
    public static Resource__c getResData(String resourceid)
    {
        Resource__c res;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Resource__c')
              &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Resource__c',new set<String>{'id','Name','sigmaerpdev2__Roles__c'})){
       
        if(resourceid !=null && resourceid !='')
        {
            res=[select id,Name,Roles__c from Resource__c where id=:resourceid limit 1];
            
        }
              }
        return res;
        
    }
    
    @AuraEnabled  
    Public static Project_Resource__c getResourceInfo(String resourceID)
    {
         List<Project_Resource__c> dataList;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Project_Resource__c')
              &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Project_Resource__c',new set<String>{'id','Name','sigmaerpdev2__Manufacturing_Run__c','sigmaerpdev2__Resource__c','sigmaerpdev2__Resource__r.Name','sigmaerpdev2__Resource__r.sigmaerpdev2__Roles__c','sigmaerpdev2__Interval__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c'})){
        
       
       dataList=new List<Project_Resource__c>();
        dataList=[select id,name,Manufacturing_Run__c,Resource__c,Resource__r.Name,Resource__r.Roles__c,Interval__c,Start_Date__c,End_Date__c from Project_Resource__c where Id=:resourceID limit 1000];
              }
        return dataList[0];
    }
    //code added to fetch existing Resources in respective MR Table view for Resource Planning Usage
    @AuraEnabled
    public static List<Project_Resource__c> fetchMRResource(String manfRunId)
    {
        system.debug('manfRunId>>>>'+manfRunId);
        List<Project_Resource__c> manuResource;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Project_Resource__c') 
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Project_Resource__c',new set<String>{'id','Name','sigmaerpdev2__Manufacturing_Run__c','sigmaerpdev2__Resource__r.Name','sigmaerpdev2__Resource__r.sigmaerpdev2__Roles__c','sigmaerpdev2__Interval__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c'}))
        {
            if(manfRunId !=null && manfRunId !='')
            {
                manuResource =[select id,name,Manufacturing_Run__c,Resource__r.Name,Resource__r.Roles__c,Interval__c,Start_Date__c,End_Date__c from Project_Resource__c where Manufacturing_Run__c=:manfRunId limit 1000];                
            }
        }
        return manuResource;
    }
    
}