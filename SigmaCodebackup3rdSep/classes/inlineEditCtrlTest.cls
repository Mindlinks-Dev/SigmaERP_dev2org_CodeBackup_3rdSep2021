@isTest
public class inlineEditCtrlTest {
     @IsTest(seeAllData=false)
    public static void Test1()
    {
        User currentuser=new user();
        currentuser.Username='vendor@mindlinkssolution.com';
        currentuser.ContactId='0032x00000G63ws';
        currentuser.Alias='svend';
        currentuser.Email='dev@mindlinkssolution.com';
        currentuser.LastName='svend';
        currentuser.TimeZoneSidKey='America/Los_Angeles';
        currentuser.LocaleSidKey='en_US';
        currentuser.EmailEncodingKey='ISO-8859-1';
        currentuser.ProfileId='00e2x000000laWuAAI';
        currentuser.LanguageLocaleKey='en_US';
        insert currentuser;
        
        Contact con = new Contact();
       // con.id=currentuser.id;
        con.LastName='Test LastName';
        con.Email='Test@gmail.com';
        insert con;
        Account acc = new Account();
        acc.Name='Test Account';
        acc.Type='Vendor';
        //acc.RecordTypeId = RID1;
        acc.Phone='7894561231';
        acc.sigmaerpdev2__Email__c='Test@gmail.com';
       // acc.id=currentuser.con.AccountId;
       
        insert acc;
        //System.assertEquals(acc.Name,'Test Account');
        List<sigmaerpdev2__Vendor_Product__c> vp = new List<sigmaerpdev2__Vendor_Product__c>();
        sigmaerpdev2__Vendor_Product__c  VendorProduct= new sigmaerpdev2__Vendor_Product__c();
        VendorProduct.sigmaerpdev2__Account_Name__c='0012x00000MjoPDAAZ';
        VendorProduct.sigmaerpdev2__Product_Name__c='01t2x0000027KC4AAM';
        VendorProduct.sigmaerpdev2__Is_Preferred__c=true;
       VendorProduct.sigmaerpdev2__Buying_Price__c=30000;
        VendorProduct.sigmaerpdev2__Vendor_Location__c='0012x00000NRHSfAAP';
        VendorProduct.sigmaerpdev2__VendorProductCode__c='VPC41';
        VendorProduct.sigmaerpdev2__Current_Stock__c=1123;
        VendorProduct.sigmaerpdev2__Last_Updated_Date__c=System.today();
        insert VendorProduct;
        vp.add(VendorProduct);
        
        Test.startTest();
        
        inlineEditCtrl.fetchUser();
        inlineEditCtrl.fetchProduct();
         Test.stopTest();
    }  

}