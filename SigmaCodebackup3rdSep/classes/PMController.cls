public with sharing class PMController {
  
    @AuraEnabled
    public static Default_Parameters__c getGanttURL()
    {
        Default_Parameters__c fetchdefaulturl;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Default_Parameters__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Default_Parameters__c',new Set<String>{'sigmaerpdev2__Inventory_Status__c','sigmaerpdev2__Auto_Reserve_Stock__c'}))
        {
        fetchdefaulturl= [select GanttURL__c from Default_Parameters__c Limit 1];
        }
        return fetchdefaulturl;
    }
   @AuraEnabled
    public static Project2__c getProjectData(Id recid)
    {
        Project2__c projectdetails;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Project2__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Project2__c',new set<String>{'Id','Name','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Template__c'}))
        {
            projectdetails=[Select Id,Name,Start_Date__c,End_Date__c,Template__c From Project2__c where Id=: recid];
            system.debug('projectdetails>>>>'+projectdetails);
        }
        return projectdetails;
    }
}