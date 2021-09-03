public with sharing class UploadStock {
    @AuraEnabled
    public static List <Vendor_Product__c> fetchVendProdlist() {
        List <Vendor_Product__c> vpList = [SELECT sigmaerpdev2__Account_Name__c,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__VendorProductCode__c,sigmaerpdev2__Vendor_Location__c,sigmaerpdev2__Vendor_Location__r.Name,sigmaerpdev2__Product_Name__c,sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Product_Name__r.ProductCode from sigmaerpdev2__Vendor_Product__c];
      //  List <Vendor_Product__c> vpList = [SELECT sigmaerpdev2__Account_Name__c,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__VendorProductCode__c,sigmaerpdev2__Vendor_Location__c,sigmaerpdev2__Vendor_Location__r.Name,sigmaerpdev2__Current_Stock__c,sigmaerpdev2__Buying_Price__c,sigmaerpdev2__Product_Name__c,sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Product_Name__r.ProductCode from sigmaerpdev2__Vendor_Product__c Where sigmaerpdev2__Product_Name__c =:ProductName and sigmaerpdev2__Account_Name__c=:Acc.id ];
        return vpList;
    }
    @AuraEnabled
    public static void saveVendproducts(List<Vendor_Product__c> vplistdata){
        insert vplistdata;
    }
}