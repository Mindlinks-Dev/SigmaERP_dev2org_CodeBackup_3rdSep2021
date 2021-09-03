public without sharing class inlineEditCtrl {
    // method for fetch account records list  
    @AuraEnabled
    public static List <Vendor_Product__c> fetchProduct() {
        
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        
        List < Vendor_Product__c > returnList = new List < Vendor_Product__c > ();
        List <Vendor_Product__c> lstOfProduct = [select id,sigmaerpdev2__Vendor_Location__r.Name, sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__VendorProductCode__c,	sigmaerpdev2__Current_Stock__c,sigmaerpdev2__Last_Updated_Date__c from sigmaerpdev2__Vendor_Product__c  WHERE sigmaerpdev2__Account_Name__c=: Acc.id Order by sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Vendor_Location__r.Name ASC ];
        
        for (Vendor_Product__c VP: lstOfProduct){
            returnList.add(VP); 
            
        }
        /*List<Inventory_Location_Product__c> ilpz = [select id,Inventory__c,Name,Availability__c,sigmaerpdev2__Parent_Account__r.Name,sigmaerpdev2__Products__r.Name,sigmaerpdev2__Received_Quantity__c,sigmaerpdev2__Inventory_Location_Name__c,
Deliver_Quantity__c,Inventory_Location__c,AvailableAdjustedQty__c,sigmaerpdev2__Last_Updated_Date__c,
Products__c from Inventory_Location_Product__c where sigmaerpdev2__Parent_Account__c=: Acc.id order by sigmaerpdev2__Products__r.Name,sigmaerpdev2__Inventory_Location_Name__c];
system.debug('ilpz'+ilpz);*/
        
        return lstOfProduct;
        //return ilpz;
    } 
    @AuraEnabled
    public static List <Vendor_Product__c> fetcharrowupdata() {
        
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        
        List < Vendor_Product__c > returnList = new List < Vendor_Product__c > ();
        List <Vendor_Product__c> lstOfProduct = [select id,sigmaerpdev2__Vendor_Location__r.Name, sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__VendorProductCode__c,	sigmaerpdev2__Current_Stock__c,sigmaerpdev2__Last_Updated_Date__c from sigmaerpdev2__Vendor_Product__c  WHERE sigmaerpdev2__Account_Name__c=: Acc.id Order by sigmaerpdev2__Product_Name__r.Name ASC];
        
        for (Vendor_Product__c VP: lstOfProduct){
            returnList.add(VP); 
            
        }
        
        
        return lstOfProduct;
        //return ilpz;
    } 
    @AuraEnabled
    public static List <Vendor_Product__c> fetcharrowdowndata() {
        
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        
        List < Vendor_Product__c > returnList = new List < Vendor_Product__c > ();
        List <Vendor_Product__c> lstOfProduct = [select id,sigmaerpdev2__Vendor_Location__r.Name, sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__VendorProductCode__c,	sigmaerpdev2__Current_Stock__c,sigmaerpdev2__Last_Updated_Date__c from sigmaerpdev2__Vendor_Product__c  WHERE sigmaerpdev2__Account_Name__c=: Acc.id Order by sigmaerpdev2__Product_Name__r.Name DESC];
        
        for (Vendor_Product__c VP: lstOfProduct){
            returnList.add(VP); 
            
        }
        
        
        return lstOfProduct;
        //return ilpz;
    } 
    @AuraEnabled
    public static List <Vendor_Product__c> fetcharrowupdataforLocation() {
        
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        
        List < Vendor_Product__c > returnList = new List < Vendor_Product__c > ();
        List <Vendor_Product__c> lstOfProduct = [select id,sigmaerpdev2__Vendor_Location__r.Name, sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__VendorProductCode__c,	sigmaerpdev2__Current_Stock__c,sigmaerpdev2__Last_Updated_Date__c from sigmaerpdev2__Vendor_Product__c  WHERE sigmaerpdev2__Account_Name__c=: Acc.id Order by sigmaerpdev2__Vendor_Location__r.Name ASC];
        
        for (Vendor_Product__c VP: lstOfProduct){
            returnList.add(VP); 
            
        }
        
        
        return lstOfProduct;
        //return ilpz;
    } 
    @AuraEnabled
    public static List <Vendor_Product__c> fetcharrowdowndataforLocation() {
        
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        
        List < Vendor_Product__c > returnList = new List < Vendor_Product__c > ();
        List <Vendor_Product__c> lstOfProduct = [select id,sigmaerpdev2__Vendor_Location__r.Name, sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__VendorProductCode__c,	sigmaerpdev2__Current_Stock__c,sigmaerpdev2__Last_Updated_Date__c from sigmaerpdev2__Vendor_Product__c  WHERE sigmaerpdev2__Account_Name__c=: Acc.id Order by sigmaerpdev2__Vendor_Location__r.Name DESC];
        
        for (Vendor_Product__c VP: lstOfProduct){
            returnList.add(VP); 
            
        }
        
        
        return lstOfProduct;
        //return ilpz;
    } 
    @AuraEnabled
    public static List <Account> fetchLocation() {
        
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        
        List < Account > returnList = new List < Account > ();
        List <Account> lstOfLocation = [select id,name,sigmaerpdev2__Locations_Type__c from Account where sigmaerpdev2__Locations_Type__c='Vendor Inventory Location'];
        /* 
for (Account AL:lstOfLocation ){
returnList.add(AL); 

}*/
        /*List<Inventory_Location_Product__c> ilpz = [select id,Inventory__c,Name,Availability__c,sigmaerpdev2__Parent_Account__r.Name,sigmaerpdev2__Products__r.Name,sigmaerpdev2__Received_Quantity__c,sigmaerpdev2__Inventory_Location_Name__c,
Deliver_Quantity__c,Inventory_Location__c,AvailableAdjustedQty__c,sigmaerpdev2__Last_Updated_Date__c,
Products__c from Inventory_Location_Product__c where sigmaerpdev2__Parent_Account__c=: Acc.id order by sigmaerpdev2__Products__r.Name,sigmaerpdev2__Inventory_Location_Name__c];
system.debug('ilpz'+ilpz);*/
        
        return lstOfLocation;
        //return ilpz;
    } 
    
    @AuraEnabled 
    public static ProductWrapper fetchProductWrapper(){
        
        //Instance of Product DataTable Wrapper Class
        ProductWrapper returnProductWrapper =  new ProductWrapper();  
        
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        
        returnProductWrapper.ILPList = [select id,sigmaerpdev2__Current_Stock__c,Inventory__c,Name,Availability__c,sigmaerpdev2__Parent_Account__r.Name,sigmaerpdev2__Products__r.Name,sigmaerpdev2__Received_Quantity__c,sigmaerpdev2__Inventory_Location_Name__c,
                                        Deliver_Quantity__c,Inventory_Location__c,AvailableAdjustedQty__c,sigmaerpdev2__Last_Updated_Date__c,
                                        Products__c from Inventory_Location_Product__c where sigmaerpdev2__Parent_Account__c=: Acc.id order by sigmaerpdev2__Products__r.Name,sigmaerpdev2__Inventory_Location_Name__c ];
        
        return returnProductWrapper;
    }
    
    @AuraEnabled
    public static ProductWrapper saveProductWrap(String lstProduct) {
        system.debug('lstProduct>>'+lstProduct);
        Savepoint sp;
        ProductWrapper returnProductWrapper =  new ProductWrapper();  
        try{
            system.debug('Try lstProduct:::'+lstProduct);
            sp = Database.setSavepoint();
            Inventory_Location_Product__c ILPList = (Inventory_Location_Product__c)System.JSON.deserialize(lstProduct, Inventory_Location_Product__c.class);
            
            system.debug('ILPList'+ILPList);
            
        }
        catch(Exception e)
        {
            Database.rollback(sp);
            //update lstProduct;
            //return lstProduct;
        }
        //update ILPList;
        //update ILPList;
        return returnProductWrapper;
    }
    @AuraEnabled
    public static List<Vendor_Product__c> saveProduct1(List<Vendor_Product__c> lstProduct) {
        update lstProduct;
        
        return lstProduct;    
    }
    // method for update records after updating stock  
    @AuraEnabled
    public static List<Vendor_Product__c> saveProduct(List<Vendor_Product__c> lstProduct) {
        system.debug('lstProduct --->' + lstProduct);
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        List<Vendor_Product__c> vendProdList = new List<Vendor_Product__c>();
        Vendor_Product__c vp;
        Boolean Chkbox = false;
        
        //create a map that will hold the values of the list 
        map<id,sigmaerpdev2__Vendor_Product__c> vpmap = new map<id,sigmaerpdev2__Vendor_Product__c>();
        
        
        
        List<sigmaerpdev2__Vendor_Product__c> ValidVP= [SELECT id,sigmaerpdev2__Is_Preferred__c,sigmaerpdev2__Account_Name__c,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__Vendor_Location__c,sigmaerpdev2__Vendor_Location__r.Name,sigmaerpdev2__Product_Name__c,sigmaerpdev2__Product_Name__r.Name
                                                        from sigmaerpdev2__Vendor_Product__c  Where sigmaerpdev2__Account_Name__c =: Acc.Id  ];
        If(ValidVP.size()>0){
            
            for(Vendor_Product__c vendor:ValidVP){
                if(vendor.sigmaerpdev2__Is_Preferred__c==true){
                    // Vendor_Product__c vp;
                    system.debug(' vendor: '+vendor);
                    for(integer i=0;i<lstProduct.size();i++)
                    {
                        
                        system.debug('lstProduct : '+lstProduct);
                        vp = new Vendor_Product__c();
                        vp.Id = lstProduct[i].Id;
                        vp.Buying_Price__c=100;
                        vp.Account_Name__c=Acc.id;  
                        vp.Current_Stock__c=lstProduct[i].sigmaerpdev2__Current_Stock__c;
                        vp.Product_Name__c=lstProduct[i].sigmaerpdev2__Product_Name__c;
                        vp.VendorProductCode__c=lstProduct[i].sigmaerpdev2__VendorProductCode__c;
                        vp.Last_Updated_Date__c=lstProduct[i].sigmaerpdev2__Last_Updated_Date__c;
                        vp.Vendor_Location__c=lstProduct[i].sigmaerpdev2__Vendor_Location__c;
                        vp.sigmaerpdev2__Is_Preferred__c = true;
                        vendProdList.add(vp);
                        system.debug('vendProdList : '+vendProdList);
                    }
                    
                    
                }
                else{
                    // Vendor_Product__c vp;
                    
                    for(integer i=0;i<lstProduct.size();i++)
                    {
                        system.debug('lstProduct : '+lstProduct);
                        vp = new Vendor_Product__c();
                        vp.Id = lstProduct[i].Id;
                        vp.Buying_Price__c=100;
                        vp.Account_Name__c=Acc.id;  
                        vp.Current_Stock__c=lstProduct[i].sigmaerpdev2__Current_Stock__c;
                        vp.Product_Name__c=lstProduct[i].sigmaerpdev2__Product_Name__c;
                        vp.VendorProductCode__c=lstProduct[i].sigmaerpdev2__VendorProductCode__c;
                        vp.Last_Updated_Date__c=lstProduct[i].sigmaerpdev2__Last_Updated_Date__c;
                        vp.Vendor_Location__c=lstProduct[i].sigmaerpdev2__Vendor_Location__c;
                         vp.sigmaerpdev2__Is_Preferred__c = false;
                        vendProdList.add(vp);
                        system.debug('vendProdList : '+vendProdList);
                    }
                    
                }
                // Chkbox=true;
                
            }
            
        }
        
        
        //put all the values from the list to map. 
        vpmap.putall(vendProdList);
        if(vpmap.size()>0){
            update vpmap.values();
        }
        
        
        //update vendProdList;
        
        return lstProduct;
    }
    /* else{
Vendor_Product__c vp;
for(sigmaerpdev2__Vendor_Product__c pw:lstProduct)
{

system.debug('pw : '+pw);
vp = new Vendor_Product__c();
vp.Id = pw.Id;
vp.Buying_Price__c=100;
vp.Account_Name__c=Acc.id;  
vp.Current_Stock__c=pw.sigmaerpdev2__Current_Stock__c;
vp.Product_Name__c=pw.sigmaerpdev2__Product_Name__c;
vp.VendorProductCode__c=pw.sigmaerpdev2__VendorProductCode__c;
vp.Last_Updated_Date__c=pw.sigmaerpdev2__Last_Updated_Date__c;
vp.Vendor_Location__c=pw.sigmaerpdev2__Vendor_Location__c;
// vp.sigmaerpdev2__Is_Preferred__c = true;
vendProdList.add(vp);
system.debug('vendProdList : '+vendProdList);
}

}*/
    
    
    
    
    //Wrapper Class For product   
    public class ProductWrapper{
        @AuraEnabled
        public Integer pageSize {get;set;}
        @AuraEnabled
        public Integer pageNumber {get;set;}
        @AuraEnabled
        public Integer totalRecords {get;set;}
        @AuraEnabled
        public Integer recordStart {get;set;}
        @AuraEnabled
        public Integer recordEnd {get;set;}
        @AuraEnabled
        public List<sigmaerpdev2__Vendor_Product__c> VPList;
        @AuraEnabled
        public List<Inventory_Location_Product__c> ILPList;
    }
    @AuraEnabled 
    public static user fetchUser(){
        // query current user information  
        User oUser = [select id,Name,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled 
                      FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }
    @AuraEnabled
    public static PagerWrapper   fetchProductforpagination(Integer pageNumber, Integer pageSize,String searchKey) {
        //Offset for SOQL
        Integer offset = (pageNumber - 1) * pageSize;
        String name =  + searchKey + '%';
        system.debug('searchKey>>'+searchKey);
        system.debug('name>>'+name);
        //Total Records
        //Integer totalRecords = [SELECT COUNT() FROM Vendor_Product__c ];
        // Integer recordEnd = pageSize * pageNumber;
        
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        Integer totalRecords = [SELECT COUNT() FROM Vendor_Product__c WHERE sigmaerpdev2__Account_Name__c=: Acc.id];
        Integer recordEnd = pageSize * pageNumber;
        List <Vendor_Product__c> lstOfProduct = [select id,sigmaerpdev2__Vendor_Location__r.Name, sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__VendorProductCode__c,	sigmaerpdev2__Current_Stock__c,sigmaerpdev2__Last_Updated_Date__c from sigmaerpdev2__Vendor_Product__c  WHERE sigmaerpdev2__Account_Name__c=: Acc.id  Order by sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Vendor_Location__r.Name ASC LIMIT :pageSize OFFSET :offset ];
        PagerWrapper obj =  new PagerWrapper();
        // set the pageSize,Page(Number), total records and products List(using OFFSET)   
        obj.pageSize = pageSize;
        obj.numOfRec = totalRecords;
        obj.lstOfProduct = lstOfProduct;
        obj.pageSize = pageSize;
        obj.pageNumber = pageNumber;
        obj.recordStart = offset + 1;
        obj.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        obj.totalRecords = totalRecords;
        // return the wrapper class instance .
        return obj;
    }
    @AuraEnabled
    public static PagerWrapper   fetchDefaultValues() {
        sigmaerpdev2__Stockupdate__c	dc=sigmaerpdev2__Stockupdate__c.getInstance();
        Integer noofload=Integer.valueOf(dc.sigmaerpdev2__No_of_Records_to_load_in_Stock__c);
        Integer noofloadmore=Integer.valueOf(dc.sigmaerpdev2__No_of_Records_on_Stock_Load_More_Click__c);
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        
        List <Vendor_Product__c> lstOfProduct = new List <Vendor_Product__c>();
        lstOfProduct = [select id,sigmaerpdev2__Vendor_Location__r.Name, sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__VendorProductCode__c,	sigmaerpdev2__Current_Stock__c,sigmaerpdev2__Last_Updated_Date__c from sigmaerpdev2__Vendor_Product__c  WHERE sigmaerpdev2__Account_Name__c=: Acc.id Order by sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Vendor_Location__r.Name ASC limit:noofload ];
        system.debug('lstOfProduct>>>'+lstOfProduct);
        Integer totalRecords = [SELECT COUNT() FROM Vendor_Product__c WHERE sigmaerpdev2__Account_Name__c=:Acc.id];
        
        PagerWrapper obj =  new PagerWrapper();
        
        obj.lstOfProduct = lstOfProduct;
        obj.numOfRec = totalRecords;
        obj.totalRecords = totalRecords;
        obj.numberOfRecordsOnLoadMoreClick=noofloadmore;
        obj.numberOfRecordsToDisplay=noofload; 
        
        // return the wrapper class instance .
        return obj;
    }
    @AuraEnabled
    public static PagerWrapper   fetchProductforloadmore(String searchKey,String sortField,String ascDesc,Integer numberOfRecordsToDisplay) {
        sigmaerpdev2__Stockupdate__c	dc=sigmaerpdev2__Stockupdate__c.getInstance();
        
        // Integer noofload=Integer.valueOf(dc.sigmaerpdev2__No_of_Records_to_load_in_Stock__c);
        //Integer numberOfRecordsToDisplay=Integer.valueOf(dc.sigmaerpdev2__No_of_Records_on_Stock_Load_More_Click__c);
        
        sigmaerpdev2__Stockupdate__c   stck=[select id,Name,sigmaerpdev2__No_of_Records_to_load_in_Stock__c,sigmaerpdev2__No_of_Records_on_Stock_Load_More_Click__c	from sigmaerpdev2__Stockupdate__c];
        system.debug('stck>'+stck); 
        //Offset for SOQL
        
        String name = '%'+ searchKey + '%';
        system.debug('searchKey>>'+searchKey);
        system.debug('name>>'+name);
        system.debug('sortField>>'+sortField);
        //Total Records
        //Integer totalRecords = [SELECT COUNT() FROM Vendor_Product__c ];
        // Integer recordEnd = pageSize * pageNumber;
        
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        id act=Acc.id;
        Integer totalRecords = [SELECT COUNT() FROM Vendor_Product__c WHERE sigmaerpdev2__Account_Name__c=:Acc.id];
        
        List <Vendor_Product__c> lstOfProduct = new List <Vendor_Product__c>();
        String queryString;
        if(searchKey==''){
            
            queryString='select id,sigmaerpdev2__Vendor_Location__r.Name, sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__VendorProductCode__c,	sigmaerpdev2__Current_Stock__c,sigmaerpdev2__Last_Updated_Date__c from sigmaerpdev2__Vendor_Product__c  WHERE sigmaerpdev2__Account_Name__c=: act';
        }
        else {
            queryString='select id,sigmaerpdev2__Vendor_Location__r.Name, sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__VendorProductCode__c,	sigmaerpdev2__Current_Stock__c,sigmaerpdev2__Last_Updated_Date__c from sigmaerpdev2__Vendor_Product__c  WHERE sigmaerpdev2__Account_Name__c=: act  AND (sigmaerpdev2__Vendor_Location__r.Name LIKE:name OR  sigmaerpdev2__Product_Name__r.Name LIKE:name OR sigmaerpdev2__VendorProductCode__c LIKE:name)' ;
        }
        String querySize = 'SELECT COUNT(Id) countIds  FROM Vendor_Product__c WHERE sigmaerpdev2__Account_Name__c=: act ';
        system.debug('queryString???'+queryString);
        if(String.isNotEmpty(sortField) || String.isNotBlank(sortField))
        {
            queryString += ' order by  '+sortField+' '+ascDesc;
        }
        else{
            queryString += ' Order by sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Vendor_Location__r.Name asc';
            // queryString += ' Order by sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Vendor_Location__r.Name asc';
        } 
        queryString += ' Limit '+numberOfRecordsToDisplay;
        system.debug('queryString::'+queryString);
        Integer numOfRows=0;
        AggregateResult recordCount = Database.query(querySize);
        system.debug('recordCount::'+recordCount);
        numOfRows=(Integer)recordCount.get('countIds');
        
        List<Vendor_Product__c> VPQueryRecord = Database.query(queryString);
        system.debug('VPQueryRecord::'+VPQueryRecord);
        PagerWrapper obj =  new PagerWrapper();
        // set the pageSize,Page(Number), total records and products List(using OFFSET)   
        
        
        obj.lstOfProduct =VPQueryRecord ;
        obj.numOfRec = numOfRows;
        obj.numberOfRecordsOnLoadMoreClick=stck.sigmaerpdev2__No_of_Records_on_Stock_Load_More_Click__c;
        obj.numberOfRecordsToDisplay=stck.sigmaerpdev2__No_of_Records_to_load_in_Stock__c;   
        obj.totalRecords = totalRecords;
        system.debug('obj>>>'+obj);
        
        
        // return the wrapper class instance .
        return obj;
    }
    @AuraEnabled
    public static PagerWrapper   FindBySearchQuery(Integer pageNumber, Integer pageSize,String searchKey) {
        //Offset for SOQL
        // Integer offset = (pageNumber - 1) * pageSize;
        String name =  + searchKey + '%';
        system.debug('searchKey>>'+searchKey);
        system.debug('name>>'+name);
        //Total Records
        //Integer totalRecords = [SELECT COUNT() FROM Vendor_Product__c ];
        // Integer recordEnd = pageSize * pageNumber;
        
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        //Integer totalRecords = [SELECT COUNT() FROM Vendor_Product__c WHERE sigmaerpdev2__Account_Name__c=: Acc.id];
        // Integer recordEnd = pageSize * pageNumber;
        List <Vendor_Product__c> lstOfProduct = [select id,sigmaerpdev2__Vendor_Location__r.Name, sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__VendorProductCode__c,	sigmaerpdev2__Current_Stock__c,sigmaerpdev2__Last_Updated_Date__c from sigmaerpdev2__Vendor_Product__c  WHERE sigmaerpdev2__Account_Name__c=: Acc.id AND(sigmaerpdev2__Vendor_Location__r.Name LIKE:name OR  sigmaerpdev2__Product_Name__r.Name LIKE:name OR sigmaerpdev2__VendorProductCode__c LIKE:name) Order by sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Vendor_Location__r.Name ASC ];
        PagerWrapper obj =  new PagerWrapper();
        // set the pageSize,Page(Number), total records and products List(using OFFSET)   
        //obj.pageSize = pageSize;
        //obj.numOfRec = totalRecords;
        obj.lstOfProduct = lstOfProduct;
        //obj.pageSize = pageSize;
        //obj.pageNumber = pageNumber;
        //obj.recordStart = offset + 1;
        //obj.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        //obj.totalRecords = totalRecords;
        // return the wrapper class instance .
        return obj;
    }
    @AuraEnabled
    public static PagerWrapper   FindBySearchQuery1(String searchKey,Integer numberOfRecordsToDisplay) {
        sigmaerpdev2__Stockupdate__c	dc=sigmaerpdev2__Stockupdate__c.getInstance();
        Integer noofload=Integer.valueOf(dc.sigmaerpdev2__No_of_Records_to_load_in_Stock__c);
        Integer noofloadmore=Integer.valueOf(dc.sigmaerpdev2__No_of_Records_on_Stock_Load_More_Click__c);
        
        String Name =   '%'+ searchKey +'%';
        // String name =  + searchKey + '%';
        system.debug('searchKey>>'+searchKey);
        system.debug('Name>>'+Name);
        
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        
        
        List <Vendor_Product__c> lstOfProduct = [select id,sigmaerpdev2__Vendor_Location__r.Name, sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__VendorProductCode__c,	sigmaerpdev2__Current_Stock__c,sigmaerpdev2__Last_Updated_Date__c from sigmaerpdev2__Vendor_Product__c  WHERE sigmaerpdev2__Account_Name__c=: Acc.id AND(sigmaerpdev2__Vendor_Location__r.Name LIKE:Name OR  sigmaerpdev2__Product_Name__r.Name LIKE:Name OR sigmaerpdev2__VendorProductCode__c LIKE:Name) Order by sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Vendor_Location__r.Name ASC limit:noofload ];
        Integer totalRecords = [SELECT COUNT() FROM Vendor_Product__c WHERE sigmaerpdev2__Account_Name__c=: Acc.id AND(sigmaerpdev2__Vendor_Location__r.Name LIKE:Name OR  sigmaerpdev2__Product_Name__r.Name LIKE:Name OR sigmaerpdev2__VendorProductCode__c LIKE:Name)];
        PagerWrapper obj =  new PagerWrapper();
        
        obj.lstOfProduct = lstOfProduct;
        obj.numOfRec = totalRecords;
        obj.totalRecords = totalRecords;
        obj.numberOfRecordsOnLoadMoreClick=noofloadmore;
        obj.numberOfRecordsToDisplay=noofload; 
        
        // return the wrapper class instance .
        return obj;
    }
    //return ilpz;
    public class PagerWrapper {
        @AuraEnabled public Integer pageSize {get;set;}
        @AuraEnabled public Integer  pageNumber{get;set;}
        @AuraEnabled public Integer  totalRecords{get;set;}
        @AuraEnabled public Integer  recordStart{get;set;}
        @AuraEnabled public Integer  recordEnd{get;set;}
        @AuraEnabled public Integer  numOfRec{get;set;}
        @AuraEnabled public List<Vendor_Product__c> lstOfProduct {get;set;}
        
        @AuraEnabled
        public String noRecs;
        @AuraEnabled
        public Decimal totalRowCount{get;set;}
        @AuraEnabled
        public Decimal numberOfRecordsOnLoadMoreClick{get;set;}
        @AuraEnabled
        public Decimal numberOfRecordsToDisplay{get;set;}
    }
    @AuraEnabled
    public static List<ContentVersion> getContents(string imgId, string ObjectName) {
        Set<Id> contentIds = new Set<Id>();
        if(ObjectName == 'sigmaerpdev2__Vendor_Location__c')
        {
            //SOQL query to get pictures from VP object 
            for (ContentDocumentLink cont :[SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink where LinkedEntityId in ( SELECT Id FROM Vendor_Product__c where Id =: imgId) and LinkedEntity.Type=:ObjectName]) {
                contentIds.add(cont.ContentDocumentId);
            }
        }
        
        //Below Query will return the latest image Id uploaded in files 
        //return [SELECT Id,Title FROM ContentVersion WHERE ContentDocumentId IN :contentIds LIMIT 1];
        return [SELECT Id,Title FROM ContentVersion WHERE ContentDocumentId='0692x0000078jezAAA'];
        
    }
    
    
}