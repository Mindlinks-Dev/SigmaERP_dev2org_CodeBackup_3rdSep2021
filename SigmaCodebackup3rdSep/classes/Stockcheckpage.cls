public with sharing class Stockcheckpage {
    public string stckid{get;set;}
    public string pkgid{get;set;}
    public Date Date1{get;set;}
    public Stockcheckpage (ApexPages.StandardController objStockcheckpage){
        stckid=System.currentPageReference().getParameters().get('name');
        pkgid=System.currentPageReference().getParameters().get('packagedBy');
        Date1=Date.valueOf(System.currentPageReference().getParameters().get('selDate'));
     //   Date1=System.currentPageReference().getParameters().get('selDate');
        
    }
    List<Inventory_Location_Product__c> stcklist=new List<Inventory_Location_Product__c>();
    public List<Inventory_Location_Product__c> getStockList(){
        if(stckid!=null && stckid!='' && stckid!='undefined'){
            
            stcklist=[select Inventory_Location_Name__c ,Products__r.name,Net_Quantity__c,Message__c,Availability__c from Inventory_Location_Product__c where Inventory_Location_Name__c =:stckid and Net_Quantity__c>0];
        }
        else 
        {
            stcklist=[select Inventory_Location_Name__c ,Products__r.name,Net_Quantity__c,Message__c,Availability__c from Inventory_Location_Product__c where Net_Quantity__c>0];  
            system.debug('stcklist>>'+stcklist);
        }
        return stcklist; 
    }
    
}