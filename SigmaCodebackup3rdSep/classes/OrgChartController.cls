global with sharing class OrgChartController {

    @AuraEnabled
    public static Contact[] getEmployees(String searchKey) {
        String key = '%' + searchKey + '%';
        return [SELECT Id, Name, Title, Picture__c FROM Contact
                      WHERE Include_In_Org_Chart__c = TRUE AND (Name LIKE :key OR Title LIKE :key)
                      ORDER BY LastName, FirstName LIMIT 50];
    }

    @AuraEnabled
    public static Contact getEmployeeById(Id employeeId) {
        return [SELECT Id, Name, Title, MailingCity, Email, Phone, MobilePhone, Picture__c, ReportsTo.Name, ReportsTo.Picture__c, ReportsTo.Title FROM Contact
                WHERE Id=:employeeId];
    }

	@AuraEnabled
    public static Contact[] getDirectReports(Id employeeId) {
        return [SELECT Id, Name, Title, Picture__c FROM Contact
                      WHERE ReportsTo.Id = :employeeId];
    }

}