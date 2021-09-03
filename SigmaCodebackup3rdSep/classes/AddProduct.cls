public without sharing class AddProduct {
    @AuraEnabled
    public static String saveData(String VPlistparamParam,String ProductName,String ProductCode) {
        
        String Status = '';
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        
        // List<Vendor_Product__c> vendProdList = new List<Vendor_Product__c>();
        System.debug('VPlistparamParam>>'+VPlistparamParam);
        // List<LocationWrapper> LocationWrap = (List<LocationWrapper>)System.JSON.deserialize(VPlistparamParam,List<LocationWrapper>.class);
        List<Vendor_Product__c> vendProdList  = (List<Vendor_Product__c>)System.JSON.deserialize(VPlistparamParam, List<Vendor_Product__c>.class);
        System.debug('vendProdList>>'+vendProdList);
        
        List<Vendor_Product__c> vendProdListnew = new List<Vendor_Product__c>();
        SET<String> locationnames=new SET<String>();
        for(Vendor_Product__c loc:vendProdList){
            locationnames.add(loc.sigmaerpdev2__Vendor_Location__c) ;
        }
        System.debug('locationnames>>'+locationnames);
        List<Account> accloclist=[SELECT id,Name from Account WHERE Name IN :locationnames];
        System.debug('accloclist>>'+accloclist);
        
       /* SET<ID> locid=new SET<ID>();
        for(Account acct:accloclist)
        {
            locid.add(acct.id);
        }
        System.debug('locid>>'+locid);
        */
        Map<Integer,Id>locid = new Map<Integer,Id>();
        for(integer i=0;i<accloclist.size();i++)
        {
            locid.put(i,accloclist[i].Id);
        }
        Set<Id> ProductNameId = new Set<Id>();
        for(sigmaerpdev2__Vendor_Product__c vpProdutName : vendProdList)
        {
          
            ProductNameId.add(vpProdutName.Product_Name__c);
        }
        system.debug('ProductNameId>>>'+ProductNameId);
        /* for(sigmaerpdev2__Vendor_Product__c pwValid:vendProdList)
{
if(pwValid.Current_Stock__c > 0)
Id.add(pwValid.Product_Name__c);            
}
*/
        List<sigmaerpdev2__Vendor_Product__c> ValidVP= [SELECT sigmaerpdev2__Is_Preferred__c,sigmaerpdev2__Buying_Price__c,sigmaerpdev2__Account_Name__c,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__Vendor_Location__c,sigmaerpdev2__Vendor_Location__r.Name,sigmaerpdev2__Product_Name__c,sigmaerpdev2__Product_Name__r.Name
                                                        from sigmaerpdev2__Vendor_Product__c Where sigmaerpdev2__Product_Name__c IN: ProductNameId and sigmaerpdev2__Is_Preferred__c=true];
        system.debug('ValidVP>>'+ValidVP);
        if(ValidVP.size()>0)
       
        {
            Vendor_Product__c vp;
            for(integer i=0;i<vendProdList.size();i++)
            {
                system.debug('vendProdList : '+vendProdList);
               
                vp=new Vendor_Product__c();
            // vp.Buying_Price__c=101;
             vp.Buying_Price__c=vendProdList[i].sigmaerpdev2__Buying_Price__c;
                vp.Account_Name__c=Acc.id;  
                vp.Current_Stock__c=vendProdList[i].sigmaerpdev2__Current_Stock__c;
                vp.Product_Name__c=vendProdList[i].sigmaerpdev2__Product_Name__c;
                
                vp.VendorProductCode__c=vendProdList[i].sigmaerpdev2__VendorProductCode__c;
                
                vp.Last_Updated_Date__c=vendProdList[i].sigmaerpdev2__Last_Updated_Date__c;
                vp.Vendor_Location__c=locid.get(i);
               vp.sigmaerpdev2__Is_Preferred__c=false;
               // if(vp.Buying_Price__c>0)
                vendProdListnew.add(vp);
            }
            system.debug('vendProdListnew>>'+vendProdListnew);
        }
        
       else
        {
            
            system.debug('else');
            Vendor_Product__c vp;
            for(integer i=0;i<vendProdList.size();i++)
            {
                system.debug('vendProdList : '+vendProdList);
                
                vp=new Vendor_Product__c();
             // vp.Buying_Price__c=101;
                vp.Account_Name__c=Acc.id; 
              vp.Buying_Price__c=vendProdList[i].sigmaerpdev2__Buying_Price__c;
                vp.Current_Stock__c=vendProdList[i].sigmaerpdev2__Current_Stock__c;
                vp.Product_Name__c=vendProdList[i].sigmaerpdev2__Product_Name__c;
               vp.VendorProductCode__c=vendProdList[i].sigmaerpdev2__VendorProductCode__c;
                
                vp.Last_Updated_Date__c=vendProdList[i].sigmaerpdev2__Last_Updated_Date__c;
                vp.Vendor_Location__c=locid.get(i);
                vp.sigmaerpdev2__Is_Preferred__c=true;
              // if(vp.Buying_Price__c>0)
                vendProdListnew.add(vp);
            }
            system.debug('vendProdListnew>>'+vendProdListnew);
            system.debug('inside else vendProdListnew>>'+vendProdListnew);
        }
        
       /* if(ValidVP.size()>0)
        {
            for(Vendor_Product__c vpdata : ValidVP)
            {
                if(vpdata.sigmaerpdev2__Is_Preferred__c == true)
                {
                    system.debug('ValidVP if>'+ValidVP);
                    
                    for(sigmaerpdev2__Vendor_Product__c lw:vendProdList)
                        
                    {
                        Vendor_Product__c vp=new Vendor_Product__c();
                        
                        for(id locationid:locid){
                            system.debug('lw : '+vendProdList);
                            vp.Buying_Price__c=101;
                            vp.Account_Name__c=Acc.id;  
                            vp.Current_Stock__c=lw.sigmaerpdev2__Current_Stock__c;
                            vp.Product_Name__c=lw.sigmaerpdev2__Product_Name__c;
                            vp.VendorProductCode__c=lw.sigmaerpdev2__VendorProductCode__c;
                            vp.Last_Updated_Date__c=lw.sigmaerpdev2__Last_Updated_Date__c;
                            
                            vp.Vendor_Location__c=locationid;
                            
                        }
                        vendProdListnew.add(vp);
                        
                        
                    }
                }
                
                else{
                    system.debug('ValidVP else>'+ValidVP);
                    for(sigmaerpdev2__Vendor_Product__c lw:vendProdList)
                    {
                        Vendor_Product__c vp=new Vendor_Product__c();
                        
                        for(id locationid:locid){
                            system.debug('lw : '+vendProdList);
                            vp.Buying_Price__c=101;
                            vp.Account_Name__c=Acc.id;  
                            vp.Current_Stock__c=lw.sigmaerpdev2__Current_Stock__c;
                            vp.Product_Name__c=lw.sigmaerpdev2__Product_Name__c;
                            vp.VendorProductCode__c=lw.sigmaerpdev2__VendorProductCode__c;
                            vp.Last_Updated_Date__c=lw.sigmaerpdev2__Last_Updated_Date__c;
                            vp.sigmaerpdev2__Is_Preferred__c = true;
                            vp.Vendor_Location__c=locationid;
                            
                            
                        }
                        vendProdListnew.add(vp);  
                    }
                }
            }
        }*/
        system.debug('vendProdListnew : '+vendProdListnew);
        insert vendProdListnew;
        return 'SUCCESS';
    } 
    @AuraEnabled
    public static String saveData2(String VPlistparamParam,String ProductName,String ProductCode) {
        
        String Status = '';
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        
        // List<Vendor_Product__c> vendProdList = new List<Vendor_Product__c>();
        System.debug('VPlistparamParam>>'+VPlistparamParam);
        // List<LocationWrapper> LocationWrap = (List<LocationWrapper>)System.JSON.deserialize(VPlistparamParam,List<LocationWrapper>.class);
        List<Vendor_Product__c> vendProdList  = (List<Vendor_Product__c>)System.JSON.deserialize(VPlistparamParam, List<Vendor_Product__c>.class);
        System.debug('vendProdList>>'+vendProdList);
        
        List<Vendor_Product__c> vendProdListnew = new List<Vendor_Product__c>();
        SET<String> locationnames=new SET<String>();
        for(Vendor_Product__c loc:vendProdList){
            locationnames.add(loc.sigmaerpdev2__Vendor_Location__c) ;
        }
        System.debug('locationnames>>'+locationnames);
        List<Account> accloclist=[SELECT id,Name from Account WHERE Name IN :locationnames];
        System.debug('accloclist>>'+accloclist);
        
     
        Map<Integer,Id>locid = new Map<Integer,Id>();
        for(integer i=0;i<accloclist.size();i++)
        {
            locid.put(i,accloclist[i].Id);
        }
        Set<Id> ProductNameId = new Set<Id>();
        for(sigmaerpdev2__Vendor_Product__c vpProdutName : vendProdList)
        {
          
            ProductNameId.add(vpProdutName.Product_Name__c);
        }
        system.debug('ProductNameId>>>'+ProductNameId);
        
        List<sigmaerpdev2__Vendor_Product__c> ValidVP= [SELECT sigmaerpdev2__Is_Preferred__c,sigmaerpdev2__Buying_Price__c,sigmaerpdev2__Account_Name__c,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__Vendor_Location__c,sigmaerpdev2__Vendor_Location__r.Name,sigmaerpdev2__Product_Name__c,sigmaerpdev2__Product_Name__r.Name
                                                        from sigmaerpdev2__Vendor_Product__c Where sigmaerpdev2__Product_Name__c IN: ProductNameId and sigmaerpdev2__Is_Preferred__c=true];
        system.debug('ValidVP>>'+ValidVP);
        if(ValidVP.size()>0)
       
        {
            Vendor_Product__c vp;
            for(integer i=0;i<vendProdList.size();i++)
            {
                system.debug('vendProdList : '+vendProdList);
               
                vp=new Vendor_Product__c();
            // vp.Buying_Price__c=101;
             vp.Buying_Price__c=vendProdList[i].sigmaerpdev2__Buying_Price__c;
                vp.Account_Name__c=Acc.id;  
                vp.Current_Stock__c=vendProdList[i].sigmaerpdev2__Current_Stock__c;
                //vp.Product_Name__c=vendProdList[i].sigmaerpdev2__Product_Name__c;
               // vp.VendorProductCode__c=vendProdList[i].sigmaerpdev2__VendorProductCode__c;
                vp.Product_Name__c=ProductName;
                vp.VendorProductCode__c=ProductCode;
                vp.Last_Updated_Date__c=vendProdList[i].sigmaerpdev2__Last_Updated_Date__c;
                vp.Vendor_Location__c=vendProdList[i].sigmaerpdev2__Vendor_Location__c;
               vp.sigmaerpdev2__Is_Preferred__c=false;
               // if(vp.Buying_Price__c>0)
                vendProdListnew.add(vp);
            }
            system.debug('vendProdListnew>>'+vendProdListnew);
        }
        
       else
        {
            
            system.debug('else');
            Vendor_Product__c vp;
            for(integer i=0;i<vendProdList.size();i++)
            {
                system.debug('vendProdList : '+vendProdList);
                
                vp=new Vendor_Product__c();
             // vp.Buying_Price__c=101;
                vp.Account_Name__c=Acc.id; 
              vp.Buying_Price__c=vendProdList[i].sigmaerpdev2__Buying_Price__c;
                vp.Current_Stock__c=vendProdList[i].sigmaerpdev2__Current_Stock__c;
               // vp.Product_Name__c=vendProdList[i].sigmaerpdev2__Product_Name__c;
                //vp.VendorProductCode__c=vendProdList[i].sigmaerpdev2__VendorProductCode__c;
                vp.Product_Name__c=ProductName;
                vp.VendorProductCode__c=ProductCode;
                vp.Last_Updated_Date__c=vendProdList[i].sigmaerpdev2__Last_Updated_Date__c;
                vp.Vendor_Location__c=vendProdList[i].sigmaerpdev2__Vendor_Location__c;
                vp.sigmaerpdev2__Is_Preferred__c=true;
              // if(vp.Buying_Price__c>0)
                vendProdListnew.add(vp);
            }
            system.debug('vendProdListnew>>'+vendProdListnew);
            system.debug('inside else vendProdListnew>>'+vendProdListnew);
        }
        
     
        system.debug('vendProdListnew : '+vendProdListnew);
        insert vendProdListnew;
        return 'SUCCESS';
    } 
    
    
    
    @AuraEnabled
    public static List<LocationWrapper> saveData1(String LocationWrapperParam, String productName,String productCode,Vendor_Product__c currentstockanddate) {
        
        String Status = '';
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        
        System.debug('LocationWrapperParam>>'+LocationWrapperParam);
        System.debug('productName>>'+productName);
        System.debug('productCode>>'+productCode);
        System.debug('currentstockanddate>>'+currentstockanddate);
        List<LocationWrapper> LocationWrap = (List<LocationWrapper>)System.JSON.deserialize(LocationWrapperParam, List<LocationWrapper>.class);
        System.debug('LocationWrap>>'+LocationWrap);
        Id RIDloc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();
        
        //List<Account> locList = new List<Account>();
        List<Vendor_Product__c> vendProdList = new List<Vendor_Product__c>();
        
        // Account loc;
        Vendor_Product__c vp;
        for(LocationWrapper lw:LocationWrap)
        {
            // loc = new Account();
            //// loc.Name = pw.LocationName;
            //loc.Locations_Type__c='Vendor Inventory Location';
            // loc.RecordTypeId=RIDloc;
            //locList.add(loc);
            //system.debug('locList : '+locList);
            
            vp = new Vendor_Product__c();
            vp.Buying_Price__c=101;
            vp.Account_Name__c=Acc.id;  
            vp.Current_Stock__c=lw.CurrentStock;
            vp.Product_Name__c=lw.ProductName;
            vp.VendorProductCode__c=lw.VPCode;
            vp.Last_Updated_Date__c=lw.AsOfDate;
            vp.sigmaerpdev2__Is_Preferred__c=false;
            // vp.Vendor_Location__c=lw.Vendor_Location__c;
            system.debug('vendProdList : '+vendProdList);
        }
        // upsert locList;
        // for(Account acloc: locList)
        /* {*/
        //vp.Vendor_Location__c=loc.Id;
        vendProdList.add(vp);
        /*}*/
        
        upsert vendProdList;
        
        return locationWrap;
    } 
    
    @AuraEnabled 
    public static user fetchUser(){
        // query current user information  
        User oUser = [select id,Name,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled 
                      FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }
  @AuraEnabled
public static List <Vendor_Product__c> fetchVendProdlist(String ProductId) 
{
    system.debug('ProductId : '+ProductId);
    
    //to fetch logged in vendor id
    Id UserId= UserInfo.getUserId();
    User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
    Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
    Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
    
    Map<Id,Id> MapOfvpid = new Map<Id,Id>(); //holding actid,locid
    
    Set<Id> filteredloc=new Set<Id>();
    
    //fetch VendorProducts of selected productid and vendorid
    List<Vendor_Product__c> removeLoc =  [SELECT Account_Name__c,Account_Name__r.Name,VendorProductCode__c,Vendor_Location__c,Vendor_Location__r.Name,Current_Stock__c,Buying_Price__c,Product_Name__c,Product_Name__r.Name,Product_Name__r.ProductCode from Vendor_Product__c Where Product_Name__c =:ProductId and Account_Name__c=:Acc.id ];
    System.debug('removeLoc'+removeLoc);

    for(Vendor_Product__c vpt1 : removeLoc)
    {
        filteredloc.add(vpt1.Vendor_Location__c); 
        
    }
    System.debug('filteredloc>>>>>>'+filteredloc);

   // List <Vendor_Product__c> vpList = [SELECT Account_Name__c,Account_Name__r.Name,VendorProductCode__c,Vendor_Location__c,Vendor_Location__r.Name,Product_Name__c,Product_Name__r.Name,Product_Name__r.ProductCode,Last_Updated_Date__c,Buying_Price__c,Current_Stock__c from Vendor_Product__c Where Account_Name__c=:Acc.id and Vendor_Location__c  not IN :filteredloc ];
     List <Vendor_Product__c> vpList = [SELECT Account_Name__c,Account_Name__r.Name,VendorProductCode__c,Vendor_Location__c,Vendor_Location__r.Name,Product_Name__c,Product_Name__r.Name,Product_Name__r.ProductCode from Vendor_Product__c Where Account_Name__c=:Acc.id and Vendor_Location__c  not IN :filteredloc ];
    System.debug('vpList'+vpList);
   
    List<String> productsAndLocList = new List<String>();
    List<Vendor_Product__c> LocList = new List<Vendor_Product__c>();
    for(Vendor_Product__c indvpt : vpList)
    {
        if(!productsAndLocList .contains(indvpt.Account_Name__c + ':' + indvpt.Vendor_Location__c))
        {
           LocList.add(indvpt);
           productsAndLocList.add(indvpt.Account_Name__c + ':' + indvpt.Vendor_Location__c);
        }
      }
    system.debug('productsAndLocList>>>'+productsAndLocList);
    system.debug('MapOfvpid>>>'+MapOfvpid);
    /*List <Vendor_Product__c> finalvpList = [select id,Vendor_Location__r.Name, Product_Name__r.Name,
                               Account_Name__r.Name,VendorProductCode__c,  
                               Current_Stock__c,Last_Updated_Date__c,Buying_Price__c from Vendor_Product__c
                               WHERE  Account_Name__c=: Acc.id and Vendor_Location__c =:MapOfvpid.values()];
    System.debug('finalvpList'+finalvpList);*/
    // return vpList;
    system.debug('LocList>>>'+LocList);
    return LocList;
} 
    @AuraEnabled
    public static List <Vendor_Product__c> fetchProduct() {
        
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        
        List < Vendor_Product__c > returnList = new List < Vendor_Product__c > ();
        List <Vendor_Product__c> lstOfProduct = [select id,sigmaerpdev2__Vendor_Location__r.Name, sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__VendorProductCode__c,sigmaerpdev2__Buying_Price__c from sigmaerpdev2__Vendor_Product__c  WHERE sigmaerpdev2__Account_Name__c=: Acc.id ];
        
        for (Vendor_Product__c VP: lstOfProduct){
            returnList.add(VP); 
            
        }
        return lstOfProduct;
    } 
    @AuraEnabled
    public static List <Account> fetchLocation() {
        
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        
        List < Account > returnList = new List < Account > ();
        List <Account> lstOfLocation = [select id,name,sigmaerpdev2__Locations_Type__c from Account where sigmaerpdev2__Locations_Type__c='Vendor Inventory Location'];
        return lstOfLocation;
    } 
    
    
     @AuraEnabled
    public static LocationWrapper fetchProductWrapper(){ 
        system.debug('inside fetch product wrapper');
               
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
     LocationWrapper returnLocationWrapper =  new LocationWrapper();
        returnLocationWrapper.VPList = new List<sigmaerpdev2__Vendor_Product__c>();
        List<String> productsAndVendorList = new List<String>();
        List<sigmaerpdev2__Vendor_Product__c> completeVendorProduct = [SELECT sigmaerpdev2__Account_Name__c,sigmaerpdev2__Is_Preferred__c,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__VendorProductCode__c,
                                                                       sigmaerpdev2__Vendor_Location__c,sigmaerpdev2__Vendor_Location__r.Name,sigmaerpdev2__Current_Stock__c,sigmaerpdev2__Buying_Price__c,
                                                                       sigmaerpdev2__Product_Name__c,sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Product_Name__r.ProductCode from sigmaerpdev2__Vendor_Product__c
                                                                       Where sigmaerpdev2__Account_Name__c=:Acc.id Order by sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Vendor_Location__r.Name ASC 
                                                                       ];
        for(sigmaerpdev2__Vendor_Product__c indRec : completeVendorProduct)
        {
            if(!productsAndVendorList.contains(indRec.sigmaerpdev2__Vendor_Location__c))
            {
                returnLocationWrapper.VPList.add(indRec);
                productsAndVendorList.add(indRec.sigmaerpdev2__Vendor_Location__c );
            }
        }        
                
        return returnLocationWrapper;
    
    }
    @AuraEnabled 
    public static LocationWrapper fetchLocationForNewProductWrapper(String ProductName) {
        system.debug('inside fetchLocationForNewProductWrapper');
        system.debug('ProductName : '+ProductName);
        //Instance of Product DataTable Wrapper Class
        LocationWrapper returnLocationWrapper =  new LocationWrapper(); 
        
        Set<String> locationnames=  new Set<String>();
        Set<String> filteredloc=new Set<String>();
        Set<Id> locationId = new Set<Id>();
        Map<Id,Id> vpid = new Map<Id,Id>();
        Map<Id,String> lStrings1=new  Map<Id,String>();
        
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        
        
        List<sigmaerpdev2__Vendor_Product__c> removeLoc =  [SELECT sigmaerpdev2__Account_Name__c,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__VendorProductCode__c,sigmaerpdev2__Vendor_Location__c,sigmaerpdev2__Vendor_Location__r.Name,sigmaerpdev2__Current_Stock__c,sigmaerpdev2__Buying_Price__c,sigmaerpdev2__Product_Name__c,sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Product_Name__r.ProductCode from sigmaerpdev2__Vendor_Product__c Where sigmaerpdev2__Product_Name__c =:ProductName and sigmaerpdev2__Account_Name__c=:Acc.id ];
        System.debug('removeLoc'+removeLoc);
        
        for(sigmaerpdev2__Vendor_Product__c vpt1 : removeLoc)
        {
            filteredloc.add(vpt1.sigmaerpdev2__Vendor_Location__r.Name);  
        }
        System.debug('filteredloc>>>>>>'+filteredloc);
        
        List<sigmaerpdev2__Vendor_Product__c> vplist = [SELECT sigmaerpdev2__Account_Name__c,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__VendorProductCode__c,sigmaerpdev2__Vendor_Location__c,sigmaerpdev2__Vendor_Location__r.Name,sigmaerpdev2__Current_Stock__c,sigmaerpdev2__Buying_Price__c,sigmaerpdev2__Product_Name__c,sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Product_Name__r.ProductCode from sigmaerpdev2__Vendor_Product__c Where sigmaerpdev2__Account_Name__c=:Acc.id and sigmaerpdev2__Vendor_Location__r.Name  not IN :filteredloc ];
        
        System.debug('vplist'+vplist);
        
        for(sigmaerpdev2__Vendor_Product__c vpt : vplist)
        {
            locationnames.add(vpt.sigmaerpdev2__Vendor_Location__r.Name);
            
            system.debug('locationnames>>'+locationnames);
            
            locationId.add(vpt.sigmaerpdev2__Vendor_Location__c);
            vpid.put(vpt.sigmaerpdev2__Vendor_Location__c,vpt.sigmaerpdev2__Account_Name__c);
            lStrings1.put(vpt.sigmaerpdev2__Vendor_Location__c,vpt.sigmaerpdev2__Vendor_Location__r.Name);
            System.debug('lStrings1'+lStrings1);
        }
        
        List<String> lStrings = new List<String>(locationnames);
        List<Id>  locId= new List<Id>(locationId);
        system.debug('locationId>>'+vpid.keyset());
        
        
        returnLocationWrapper.VPList = [select id,sigmaerpdev2__Vendor_Location__r.Name, sigmaerpdev2__Product_Name__r.Name,
                                        sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__VendorProductCode__c,   
                                        sigmaerpdev2__Current_Stock__c,sigmaerpdev2__Last_Updated_Date__c,sigmaerpdev2__Buying_Price__c from sigmaerpdev2__Vendor_Product__c 
                                        WHERE  sigmaerpdev2__Account_Name__c=: Acc.id and sigmaerpdev2__Vendor_Location__c =:vpid.keyset()
                                        Order by sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Vendor_Location__r.Name ];
        
        system.debug('VPList size : '+returnLocationWrapper.VPList.size());
        
        system.debug('VPList : '+returnLocationWrapper.VPList);
        returnLocationWrapper.lStrings = lStrings;
        returnLocationWrapper.vpid = vpid;
        returnLocationWrapper.locId = locId;
        returnLocationWrapper.lStrings1 = lStrings1;
        
       return returnlocationWrapper; 
         
    } 
    @AuraEnabled
    public static LocationWrapper fetchLocationForNewProductWrapper1(){        
        //Instance of Product DataTable Wrapper Class
        LocationWrapper returnLocationWrapper =  new LocationWrapper();  
        
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        
        returnLocationWrapper.VPList = new List<sigmaerpdev2__Vendor_Product__c>();
        
        List<String> productsAndVendorList = new List<String>();
        List<sigmaerpdev2__Vendor_Product__c> completeVendorProduct = [SELECT sigmaerpdev2__Account_Name__c,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__VendorProductCode__c,sigmaerpdev2__Vendor_Location__c,sigmaerpdev2__Vendor_Location__r.Name,sigmaerpdev2__Current_Stock__c,sigmaerpdev2__Buying_Price__c,sigmaerpdev2__Product_Name__c,sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Product_Name__r.ProductCode from sigmaerpdev2__Vendor_Product__c Where sigmaerpdev2__Account_Name__c=:Acc.id  ];
        for(sigmaerpdev2__Vendor_Product__c indRec : completeVendorProduct)
        {
            if(!productsAndVendorList.contains(indRec.sigmaerpdev2__Vendor_Location__c + ':' + indRec.sigmaerpdev2__Product_Name__c))
            {
                returnLocationWrapper.VPList.add(indRec);
                productsAndVendorList.add(indRec.sigmaerpdev2__Vendor_Location__c + ':' + indRec.sigmaerpdev2__Product_Name__c);
            }
        }
        
        return returnLocationWrapper;
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
    public static string getCode(String pid){
         Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        
        
        list<sigmaerpdev2__Vendor_Product__c> vplist = [SELECT sigmaerpdev2__VendorProductCode__c from sigmaerpdev2__Vendor_Product__c Where sigmaerpdev2__Product_Name__c=:pid AND sigmaerpdev2__Account_Name__c=:Acc.id];
        return vplist[0].sigmaerpdev2__VendorProductCode__c;
    }
    
    @AuraEnabled 
    public static String checkLocationExists(String LocationName,Id ProductId){
        String status;
        List<Account> Acc = [Select Id,Name From Account WHERE Name=:LocationName and sigmaerpdev2__Locations_Type__c='Vendor Inventory Location'];
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acct = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        
        if(Acc.size()>0){
            List<sigmaerpdev2__Vendor_Product__c> Vp = [select id,sigmaerpdev2__Vendor_Location__r.Name, sigmaerpdev2__Product_Name__r.Name,sigmaerpdev2__Account_Name__r.Name,sigmaerpdev2__VendorProductCode__c from sigmaerpdev2__Vendor_Product__c  
                                                        WHERE sigmaerpdev2__Account_Name__c =: Acct.Id 
                                                        AND sigmaerpdev2__Vendor_Location__c =: Acc[0].Id AND sigmaerpdev2__Product_Name__c =: ProductId];
            system.debug('Vp : '+Vp);
            if(Vp.size()>0){                
                status = 'Location Exist';
                system.debug('status : '+status);
            }
        }
        system.debug('return status : '+status);
        return status = 'Success';
        
    }
    
    // method for update records after inline editing  
    @AuraEnabled
    public static List<Vendor_Product__c> saveProduct(List<Vendor_Product__c> lstProduct) {
        update lstProduct;
        return lstProduct;
    }
    
    
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
        @AuraEnabled
        public Map<Id,Id> vpid;
        @AuraEnabled 
        public List<String> lStrings;
        
        @AuraEnabled
        public String LocationName;
        @AuraEnabled
        public Integer CurrentStock;
        @AuraEnabled
        public Date AsOfDate;
        @AuraEnabled
        public Id ProductId;
        @AuraEnabled
        public String ProductName;
        @AuraEnabled
        public String VPCode;
        
    }
    //Wrapper Class For Location   
    public class LocationWrapper{
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
        public List<sigmaerpdev2__Vendor_Product__c> removeLoc;
        
        @AuraEnabled
        public List<Inventory_Location_Product__c> ILPList;
        @AuraEnabled
        public Map<Id,Id> vpid;
        @AuraEnabled 
        public List<String> lStrings;
        @AuraEnabled
        public Map<Id,String> lStrings1;
        @AuraEnabled 
        public List<Id> locId;
        
        @AuraEnabled
        public String LocationName;
        @AuraEnabled
        public Integer CurrentStock;
        @AuraEnabled
        public Date AsOfDate;
        @AuraEnabled
        public Id ProductId;
        @AuraEnabled
        public String ProductName;
        @AuraEnabled
        public String VPCode;
        
    }
}