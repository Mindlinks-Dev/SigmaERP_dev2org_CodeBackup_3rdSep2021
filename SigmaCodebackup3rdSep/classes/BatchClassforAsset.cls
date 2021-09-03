global with sharing class BatchClassforAsset implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext bc)  
    {
        string query;
        // collect the batches of records or objects to be passed to execute
    if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Asset__c')
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Asset__c',new set<String>{'id','name','sigmaerpdev__Current_Asset_Value__c','sigmaerpdev__Current_Deprecation_value__c','sigmaerpdev__Current_Deprecation__c','sigmaerpdev__Product__c','sigmaerpdev__Purchase_Value__c','sigmaerpdev__Status__c','sigmaerpdev__Type_of_Asset__c','sigmaerpdev__Value__c','sigmaerpdev__Vendor__c','sigmaerpdev__Warrenty_Period__c','sigmaerpdev__Year_On_Year_Depreciation__c'}))
    {
      query= 'select id,name,sigmaerpdev__Current_Asset_Value__c,sigmaerpdev__Current_Deprecation_value__c,sigmaerpdev__Current_Deprecation__c,sigmaerpdev__Product__c,sigmaerpdev__Purchase_Value__c,sigmaerpdev__Status__c,sigmaerpdev__Type_of_Asset__c,sigmaerpdev__Value__c,sigmaerpdev__Vendor__c,sigmaerpdev__Warrenty_Period__c,sigmaerpdev__Year_On_Year_Depreciation__c from sigmaerpdev__Sigma_Asset__c where sigmaerpdev__Status__c =\'Active\'';
      system.debug('query:::'+query);
    }
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Sigma_Asset__c> records)
    {
    
        system.debug('records::'+records);
    if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Asset__c')
    && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sigma_Asset__c',new set<String>{'sigmaerpdev__Status__c','sigmaerpdev__Current_Asset_Value__c','sigmaerpdev__Current_Deprecation__c','sigmaerpdev__Current_Deprecation_value__c'}))
    {
       system.debug('bc'+bc);
       for(Sigma_Asset__c Assetrec: records)
      {
        system.debug('Assetrec status::'+Assetrec.Status__c);
        if(Assetrec.Status__c == 'Active')
        {
          system.debug('inside active record');
          //condition for the first record bez current assent will update when scheduler runs 
          if(Assetrec.Current_Asset_Value__c == null )
          {
            system.debug('inside Current asset valu is null');
            Assetrec.Current_Asset_Value__c = Assetrec.Value__c;
          }
          if(Assetrec.Current_Deprecation__c == null)
          {
            system.debug('inside Current dep valu is null');
            Assetrec.Current_Deprecation__c = Assetrec.Year_On_Year_Depreciation__c;
          }
          Assetrec.Current_Deprecation_value__c = Assetrec.Current_Asset_Value__c*Assetrec.Current_Deprecation__c/100;
          Assetrec.Current_Asset_Value__c = Assetrec.Current_Asset_Value__c-Assetrec.Current_Deprecation_value__c;
           system.debug('Assetrec:::>>::'+Assetrec.Current_Deprecation_value__c);
           system.debug('Assetrec::<<'+Assetrec.Current_Asset_Value__c);
         } 
      }
      system.debug('records::'+records);
      update records;
    }
    }    
    global void finish(Database.BatchableContext bc)
    {
        // execute any post-processing operations
    }   
}