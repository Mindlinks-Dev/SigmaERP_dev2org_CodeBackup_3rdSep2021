public with sharing class PackagePaginationHelper 
{
    @AuraEnabled
    public Integer pageSize { get;set; }
    @AuraEnabled
    public Integer page { get;set; }
    @AuraEnabled
    public Integer total { get;set; }
    @AuraEnabled
    public List<Package__c> packageList { get;set; }
        public class ShipmentPaginationHelper {
            @AuraEnabled
            public Integer pageSize { get;set; }
            @AuraEnabled
            public Integer page { get;set; }
            @AuraEnabled
            public Integer total { get;set; }
            @AuraEnabled
            public List<Shipment__c> ShipmentList { get;set; }
        }
}