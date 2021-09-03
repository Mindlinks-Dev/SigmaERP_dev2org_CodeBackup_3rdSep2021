public with sharing class DeleteWOAOnDateUpdate {
    //******************************************************************************************************************************************************************************  
    //  Date: 23/05/2018  Author :Jyoshna  functionName:deleteWOAOnChangeOfPreferredDateTime() 
    // Function Desdription: This method is called from process builder when preffered dateTime is updated to delete Work_Order_Assignment__c
    //********************************************************************************************************************************************************************************
    
    @InvocableMethod 
    public Static void deleteWOAOnChangeOfPreferredDateTime(List<Work_Order__c> workorderId){
        System.debug('workorderId'+workorderId); 
        try{
            // Check if the user has delete access on the Work_Order_Assignment__c object
            if (!Work_Order_Assignment__c.sObjectType.getDescribe().isDeletable()) {
                return;
            }
            Work_Order_Assignment__c AllworkorderAssignmentRecords=[SELECT Id, Work_Order__c FROM Work_Order_Assignment__c where Work_Order__c=:workorderId[0].id Limit 1];
            delete AllworkorderAssignmentRecords;
            System.debug('WOA records deleted Successfully');
        }
        catch(Exception e){
            System.debug('Exception'+e);
        }
    }
    
}