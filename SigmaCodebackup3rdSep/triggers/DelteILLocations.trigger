/*=====================================================================================================
Author     : Rashmi Degavi
Company    : Mindlinks Solution Pvt Ltd.
Date       : 23 Feb 2020
Description: Delete Account type of Locations if IL is deleted.
=======================================================================================================*/
trigger DelteILLocations on Inventory_Location__c (before delete) {
    
    Set<Id> accids= new Set<Id>();
    
    for (Inventory_Location__c  il : Trigger.old)
        accids.add(il.Location__c);
    
    system.debug('accids-->'+accids);
    List<Account> listOfAccounts=[SELECT Id, Name FROM Account where ID IN: accids]; 
    system.debug('listOfAccounts-->'+listOfAccounts);
    delete listOfAccounts;
}