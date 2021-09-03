public with sharing class UpdateWorkOrderInSurveyResponces {
 
    @InvocableMethod 
    public Static void updateObj(List<Id> ids){
        System.debug('ids'+ids); 
       try{
            list <SurveyQuestionResponse__c> lacc = [select id,Shipment__c,name,SurveyTaker__c,Work_Order__c	 from SurveyQuestionResponse__c where id=:ids order by LastModifiedDate DESC limit 1];
            list<Work_Order__c> wo=[select id,FFP_MR_Contact__c from Work_Order__c order by LastModifiedDate DESC limit 1];
            lacc[0].Work_Order__c=wo[0].Id;
            list <SurveyTaker__c> st = [select id,name,Contact__c	 from SurveyTaker__c where id=:lacc[0].SurveyTaker__c ];
            st[0].Contact__c=wo[0].FFP_MR_Contact__c;
            update lacc;
            update st;
        }catch(Exception ex)
        {
            System.debug('Ex>>>'+ex.getCause()+'::'+ex.getLineNumber()+'::'+ex.getMessage()+'::'+ex.getTypeName()+'::'+ex.getStackTraceString());
        }
    }
    
}