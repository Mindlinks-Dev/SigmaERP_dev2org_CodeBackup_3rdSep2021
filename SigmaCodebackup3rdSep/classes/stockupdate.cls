public without sharing class stockupdate {
    @AuraEnabled
    public static contact getCurrentUserContact()
    {
       // utilityClass.userWrapper ConDetail = utilityClass.Userdetails();
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        
       /* if(CRUD_FLS_CheckUtility.checkReadPermission('Contact',new set<String>{'id','Name','AccountId'})
            && CRUD_FLS_CheckUtility.checkReadPermission('User',new set<String>{'id','Name','ContactId','Email','Contact.Name','Contact.Account.Name'}))
        {
            if(ConDetail.Userobj.ContactId !=null)
                return ConDetail.ContactsId;
            else
                return null;
        }
        return ConDetail.ContactsId;*/
        return ConId;
    }
    
    @AuraEnabled
    public static list<sigmaerpdev2__Vendor_Product__c> fetchproductRecords(Integer pageSize, Integer pageNumber){
      Integer offset = (pageNumber - 1) * pageSize;  
       // utilityClass.userWrapper ConDetail = utilityClass.Userdetails();
		Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId ];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        
    
        system.debug('userId>>>>>>>>>>>'+UserId); 
      	List<sigmaerpdev2__Vendor_Product__c> vendprodlist=[select sigmaerpdev2__Product_Name__r.name,sigmaerpdev2__Product_Name__r.ProductCode from sigmaerpdev2__Vendor_Product__c WHERE sigmaerpdev2__Account_Name__c=:Acc.id  LIMIT :pageSize OFFSET :offset ];
		return vendprodlist;
        //return [select sigmaerpdev2__Product_Name__c,sigmaerpdev2__Current_Stock__c from Inventory_Location_Product__c  Order By createdDate DESC ];        
    }
    
     @AuraEnabled    
    public static boolean updateproductrecords( List<Product2> updatedproductList ) {    
            
        try {  
          
            upsert updatedproductList;  
            return true;  
              
        } catch(Exception e) {  
          
            return false;  
              
        }  
            
    }    
        
}