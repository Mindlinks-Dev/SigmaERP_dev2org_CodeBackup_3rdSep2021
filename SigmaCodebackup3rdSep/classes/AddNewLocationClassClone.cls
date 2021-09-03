public without sharing class AddNewLocationClassClone { 
    @AuraEnabled
    public static ProductWrapper fetchProductWrapper(){ 
        system.debug('inside fetch product wrapper');
        sigmaerpdev2__Stockupdate__c	dc=sigmaerpdev2__Stockupdate__c.getInstance();
        Integer noofload=Integer.valueOf(dc.sigmaerpdev2__No_of_Records_to_load_in_Stock__c);
        Integer noofloadmore=Integer.valueOf(dc.sigmaerpdev2__No_of_Records_on_Stock_Load_More_Click__c);
        system.debug('noofload : '+noofload);
         system.debug('noofloadmore : '+noofloadmore);
        
        ProductWrapper returnProductWrapper =  new ProductWrapper();        
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        Integer totalRecords = [SELECT COUNT() FROM Vendor_Product__c WHERE sigmaerpdev2__Account_Name__c=:Acc.id];
       
        returnProductWrapper.VPList = new List<sigmaerpdev2__Vendor_Product__c>();
        returnProductWrapper.numOfRec = totalRecords;
        returnProductWrapper.totalRecords = totalRecords;
        returnProductWrapper.numberOfRecordsOnLoadMoreClick = noofloadmore;
        returnProductWrapper.numberOfRecordsToDisplay = noofload; 
        
        system.debug('returnProductWrapper.totalRecords : '+returnProductWrapper.totalRecords);
         
        system.debug('returnProductWrapper.numberOfRecordsOnLoadMoreClick : '+returnProductWrapper.numberOfRecordsOnLoadMoreClick);
         
        system.debug('returnProductWrapper.numberOfRecordsToDisplay : '+returnProductWrapper.numberOfRecordsToDisplay);
         
        
        List<String> productsAndVendorList = new List<String>();
        List<sigmaerpdev2__Vendor_Product__c> completeVendorProduct = [SELECT sigmaerpdev2__Account_Name__c,sigmaerpdev2__Is_Preferred__c,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__VendorProductCode__c,
                                                                       sigmaerpdev2__Vendor_Location__c,sigmaerpdev2__Vendor_Location__r.Name,sigmaerpdev2__Current_Stock__c,sigmaerpdev2__Buying_Price__c,
                                                                       sigmaerpdev2__Product_Name__c,sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Product_Name__r.ProductCode from sigmaerpdev2__Vendor_Product__c
                                                                       Where sigmaerpdev2__Account_Name__c=:Acc.id Order by sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Vendor_Location__r.Name ASC 
                                                                       limit:noofload];
        for(sigmaerpdev2__Vendor_Product__c indRec : completeVendorProduct)
        {
            if(!productsAndVendorList.contains(indRec.sigmaerpdev2__Product_Name__c + ':' + indRec.sigmaerpdev2__VendorProductCode__c))
            {
                returnProductWrapper.VPList.add(indRec);
                productsAndVendorList.add(indRec.sigmaerpdev2__Product_Name__c + ':' + indRec.sigmaerpdev2__VendorProductCode__c);
            }
        }        
        return returnProductWrapper;
    }
    @AuraEnabled
    public static ProductWrapper loadMoreFetchProductWrapper(Integer numberOfRecordsToDisplay){ 
        sigmaerpdev2__Stockupdate__c	dc=sigmaerpdev2__Stockupdate__c.getInstance();
        Integer noofload=Integer.valueOf(dc.sigmaerpdev2__No_of_Records_to_load_in_Stock__c);
        Integer noofloadmore=Integer.valueOf(dc.sigmaerpdev2__No_of_Records_on_Stock_Load_More_Click__c);
        
        ProductWrapper returnProductWrapper =  new ProductWrapper();        
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        
        returnProductWrapper.VPList = new List<sigmaerpdev2__Vendor_Product__c>();
        
         Integer totalRecords = [SELECT COUNT() FROM Vendor_Product__c WHERE sigmaerpdev2__Account_Name__c=:Acc.id];
       
        
        List<String> productsAndVendorList = new List<String>();
        List<sigmaerpdev2__Vendor_Product__c> completeVendorProduct = [SELECT sigmaerpdev2__Account_Name__c,sigmaerpdev2__Is_Preferred__c,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__VendorProductCode__c,
                                                                       sigmaerpdev2__Vendor_Location__c,sigmaerpdev2__Vendor_Location__r.Name,sigmaerpdev2__Current_Stock__c,sigmaerpdev2__Buying_Price__c,
                                                                       sigmaerpdev2__Product_Name__c,sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Product_Name__r.ProductCode from sigmaerpdev2__Vendor_Product__c
                                                                       Where sigmaerpdev2__Account_Name__c=:Acc.id Order by sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Vendor_Location__r.Name ASC 
                                                                       limit:(noofload+numberOfRecordsToDisplay)];
        for(sigmaerpdev2__Vendor_Product__c indRec : completeVendorProduct)
        {
            if(!productsAndVendorList.contains(indRec.sigmaerpdev2__Product_Name__c + ':' + indRec.sigmaerpdev2__VendorProductCode__c))
            {
                returnProductWrapper.VPList.add(indRec);
                productsAndVendorList.add(indRec.sigmaerpdev2__Product_Name__c + ':' + indRec.sigmaerpdev2__VendorProductCode__c);
            }
        }        
        return returnProductWrapper;
    }
    @AuraEnabled
    public static ProductWrapper saveData(String ProductWrapperParam) {        
        String Status = '';
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        
        System.debug('ProductWrapperParam>>'+ProductWrapperParam);
        ProductWrapper ProductWrap = (ProductWrapper)System.JSON.deserialize(ProductWrapperParam, ProductWrapper.class);
        System.debug('ProductWrap>>'+ProductWrap);
        Id RIDloc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();
        
        Set<Id> Id = new Set<Id>();
        
        for(sigmaerpdev2__Vendor_Product__c pwValid:ProductWrap.VPList)
        {
            if(pwValid.Current_Stock__c > 0)
                Id.add(pwValid.Product_Name__c);            
        }
        
        List<sigmaerpdev2__Vendor_Product__c> InValidVP= [SELECT sigmaerpdev2__Account_Name__c,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__Vendor_Location__c,
                                                          sigmaerpdev2__Vendor_Location__r.Name,sigmaerpdev2__Product_Name__c,sigmaerpdev2__Product_Name__r.Name
                                                          from sigmaerpdev2__Vendor_Product__c Where sigmaerpdev2__Account_Name__c =: Acc.Id AND sigmaerpdev2__Product_Name__c IN: Id 
                                                          Order by sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Vendor_Location__r.Name ASC];
        
        If(InValidVP.size()>0){
            for(integer i=0;i<InValidVP.size();i++){
                if(InValidVP[i].sigmaerpdev2__Vendor_Location__r.Name == ProductWrap.LocationName){
                    ProductWrap.ErrorMessage = 'Location already exists';
                    ProductWrap.ProductNameMessage = InValidVP[i].sigmaerpdev2__Product_Name__r.Name;
                    return ProductWrap;
                }
            }
        }
        
        List<Vendor_Product__c> vendProdList = new List<Vendor_Product__c>();
        
        ID locId;
        List<Account> acctExists = [SELECT Id,Name FROM Account WHERE Name =: ProductWrap.LocationName];
        
        if(acctExists.size() == 0){    
            Account loc = new Account();
            loc.Name = ProductWrap.LocationName;
            loc.Locations_Type__c='Vendor Inventory Location';
            loc.RecordTypeId=RIDloc;
            //locList.add(loc);
            insert loc;
            locId = loc.ID;
            system.debug('location insert : '+loc);
        }
        else{
            locId = acctExists[0].ID;
        }
        Contact locCont = new Contact(
            FirstName = ProductWrap.Cont_FirstName,
            LastName = ProductWrap.Cont_LastName,
            Email = ProductWrap.Cont_Email,
            Phone = ProductWrap.Cont_Phone,
            sigmaerpdev2__Preferred_Contact_for_Location__c= ProductWrap.Cont_Isprefered_for_PO,
            MailingStreet = ProductWrap.Cont_MailingStreet,
            MailingCity = ProductWrap.Cont_MailingCity,
            MailingState = ProductWrap.Cont_MailingStateProvince,
            MailingPostalCode = ProductWrap.Cont_MailingPostalCode,
            MailingCountry = ProductWrap.Cont_MailingCountry,
            AccountId=locId);
        insert locCont;
        
        system.debug('location locCont : '+locCont);
        
        
        Boolean Chkbox = false;
        List<sigmaerpdev2__Vendor_Product__c> ValidVP= [SELECT sigmaerpdev2__Is_Preferred__c,sigmaerpdev2__Buying_Price__c,sigmaerpdev2__Account_Name__c,sigmaerpdev2__Account_Name__r.Name,
                                                        sigmaerpdev2__Vendor_Location__c,sigmaerpdev2__Vendor_Location__r.Name,sigmaerpdev2__Product_Name__c,sigmaerpdev2__Product_Name__r.Name
                                                        FROM sigmaerpdev2__Vendor_Product__c Where sigmaerpdev2__Product_Name__c IN: Id 
                                                        Order by sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Vendor_Location__r.Name ASC ];
        
        Map<Id,Boolean> checkPrefVendor = new Map<Id,Boolean>();
        
        
        /* for(Vendor_Product__c uniquevp : ValidVP)
{
checkPrefVendor.put(uniquevp.Product_Name__c,uniquevp.Is_Preferred__c);
}*/
        
        for(integer i=0;i<ValidVP.size();i++)
        {
            checkPrefVendor.put(ValidVP[i].Product_Name__c,ValidVP[i].Is_Preferred__c);
        }
        system.debug('checkPrefVendor single data>'+checkPrefVendor);
        if(ValidVP.size()>0)
        {
            Vendor_Product__c vp;            
                for(integer i=0;i<ProductWrap.VPList.size();i++)
                {
                    vp = new Vendor_Product__c();
                    vp.Buying_Price__c=ProductWrap.VPList[i].Buying_Price__c;     
                    //vp.Buying_Price__c=pw.Buying_Price__c;
                    vp.Account_Name__c=Acc.id;  
                    vp.Current_Stock__c=ProductWrap.VPList[i].sigmaerpdev2__Current_Stock__c;
                    vp.Product_Name__c=ProductWrap.VPList[i].sigmaerpdev2__Product_Name__c;
                    vp.VendorProductCode__c=ProductWrap.VPList[i].sigmaerpdev2__VendorProductCode__c;
                    vp.Last_Updated_Date__c=ProductWrap.VPList[i].sigmaerpdev2__Last_Updated_Date__c;
                    vp.Vendor_Location__c=locId;
                    vp.sigmaerpdev2__Vendor_Contact__c = locCont.Id;
                    vendProdList.add(vp);
                    system.debug('checkPrefVendor create vp>'+vendProdList);
                }
            }        
        
        /*    for(Id CheckVend : checkPrefVendor.KeySet())
{
system.debug('checkPrefVendor>'+checkPrefVendor.get(CheckVend));
if(checkPrefVendor.get(CheckVend))
{
vp.sigmaerpdev2__Is_Preferred__c = false;
system.debug('vendProdList if: '+vendProdList);
}
else
{
vp.sigmaerpdev2__Is_Preferred__c = true;
system.debug('vendProdList else: '+vendProdList);
}
vendProdList.add(vp);
}*/
        insert vendProdList;
        
        
        system.debug('vendProdList outside>'+vendProdList);
        
        
        system.debug('vendProdList'+vendProdList);
        
        
        return ProductWrap;
    } 
    
    @AuraEnabled 
    public static user fetchUser(){
        // query current user information  
        User oUser = [select id,Name,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled 
                      FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }
    
    
    //Wrapper Class For product   
    public class ProductWrapper{
        @AuraEnabled
        public List<sigmaerpdev2__Vendor_Product__c> VPList{get;set;}
        
        @AuraEnabled
        public String LocationName{get;set;}       
        @AuraEnabled
        public String ErrorMessage{get;set;}
        @AuraEnabled
        public String ProductNameMessage{get;set;}
        
        @AuraEnabled
        public String Cont_FirstName{get;set;}
        @AuraEnabled
        public String Cont_LastName{get;set;}
        @AuraEnabled
        public String Cont_Email{get;set;}
        @AuraEnabled
        public String Cont_Phone{get;set;}        
        @AuraEnabled
        public String Cont_MailingAddress{get;set;}
        @AuraEnabled
        public String Cont_MailingStreet{get;set;}
        @AuraEnabled
        public String Cont_MailingCity{get;set;}
        @AuraEnabled
        public String Cont_MailingStateProvince{get;set;}
        @AuraEnabled
        public String Cont_MailingPostalCode{get;set;}
        @AuraEnabled
        public String Cont_MailingCountry{get;set;}
        @AuraEnabled
        public Boolean Cont_Isprefered_for_PO=true;
        
        @AuraEnabled public Integer pageSize {get;set;}
        @AuraEnabled public Integer  pageNumber{get;set;}
        @AuraEnabled public Integer  totalRecords{get;set;}
        @AuraEnabled public Integer  recordStart{get;set;}
        @AuraEnabled public Integer  recordEnd{get;set;}
        @AuraEnabled public Integer  numOfRec{get;set;}
        
        @AuraEnabled
        public String noRecs;
        @AuraEnabled
        public Decimal totalRowCount{get;set;}
        @AuraEnabled
        public Decimal numberOfRecordsOnLoadMoreClick{get;set;}
        @AuraEnabled
        public Decimal numberOfRecordsToDisplay{get;set;}
        
    }
}