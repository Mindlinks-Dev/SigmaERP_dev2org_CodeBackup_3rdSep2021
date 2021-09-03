Public with sharing class createErrorLog
{
  public static void insertError(String module, String description, String scenario, Id objectID, String recordData, String salesforceErrorLog, Id userID)
  {
  /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Error_Log__c')
  && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Error_Log__c',new Set<String>{'sigmaerpdev__Module__c','sigmaerpdev__Error_Description__c','sigmaerpdev__Error_Scenario__c','sigmaerpdev__Object_Id__c','sigmaerpdev__Record_Data__c','sigmaerpdev__Salesforce_Error_Log__c','sigmaerpdev__User_Id__c'})) 
  
  
  {*/
    Error_Log__c err = new Error_Log__c();
    err.Module__c = 'Payment';
    err.Error_Description__c = description;
    err.Error_Scenario__c = scenario;
    err.Object_Id__c = objectID;
    err.Record_Data__c = recordData;
    err.Salesforce_Error_Log__c = salesforceErrorLog;
    err.User_Id__c = userID;
    
    insert err;
    system.debug('error log record:::::: '+err);
  //}
  }
}