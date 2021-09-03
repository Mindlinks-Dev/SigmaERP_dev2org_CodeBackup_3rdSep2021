public without sharing class CreateProductClass
{
    public class ProdWrapper
    {
        @AuraEnabled
        public String ProductName;
        @AuraEnabled
        public String SKU;
    }
    @AuraEnabled
    public static Product2 CreateProductMethod(Product2 ProductObj)
    {
        //User Userdetail = [select id,Profile.Name from User where Profile.Name = 'System Administrator' LIMIT 1];
        
        //System.runas(Userdetail)
        //{
            Product2 Prod = new Product2();
        Prod.Name = ProductObj.Name;
        Prod.sigmaerpdev2__SKU__c =ProductObj.sigmaerpdev2__SKU__c;
        insert Prod;
        //}
        
        return Prod;
    }
}