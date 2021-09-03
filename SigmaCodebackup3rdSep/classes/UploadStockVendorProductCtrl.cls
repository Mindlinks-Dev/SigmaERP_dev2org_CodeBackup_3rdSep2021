public without sharing class UploadStockVendorProductCtrl {
    @AuraEnabled
    public static string insertData(String strfromle){
        String returnresponse ='';
        List<sigmaerpdev2__Vendor_Product__c> ListtoInsert = new List<sigmaerpdev2__Vendor_Product__c>();
        Map<Id,Id> vpMap = new Map<Id,Id>();
        Map<Id,Id> vpCheck = new Map<Id,Id>();
        system.debug('strfromle = ' + strfromle);
        List<fieldWrapper> datalist = (List<fieldWrapper>)JSON.deserialize(strfromle, List<fieldWrapper>.class);
        
        Id UserId= UserInfo.getUserId();
        User currentuser = [select Id,ContactId,Name,Email,Contact.Name,Contact.Account.Name from User where id =: UserId];
        Contact ConId = [select id,Name,AccountId from Contact where id =:currentuser.ContactId];
        Account Acc = [select id,ShippingCity,ShippingCountry,ShippingState,ShippingPostalCode,ShippingStreet,Email__c,Customer_Type__c,Currency_code__c,Exchange_Currency__c from Account where Id =: currentuser.Contact.AccountId];
        List<sigmaerpdev2__Vendor_Product__c> vpList=[select Id,Name from sigmaerpdev2__Vendor_Product__c where sigmaerpdev2__Account_Name__c=:Acc.Id];
        /*Set<Id> vpListIds=new Set<Id>();
        for(sigmaerpdev2__Vendor_Product__c vp: vpList){
            vpListIds.add(vp.Id);
        }*/
        system.debug('datalist = ' + datalist);
        system.debug('datalistSize = ' + datalist.size());
        sigmaerpdev2__Vendor_Product__c exactVP;
        String rr='';
        for(fieldWrapper wrapper: datalist){
            try{
                sigmaerpdev2__Vendor_Product__c vp =new  sigmaerpdev2__Vendor_Product__c();
                exactVP= [select id,Name,sigmaerpdev2__Account_Name__c,sigmaerpdev2__Vendor_Location__c,sigmaerpdev2__Vendor_Location__r.Name,sigmaerpdev2__VendorProductCode__c,sigmaerpdev2__Current_Stock__c,sigmaerpdev2__Product_Name__c from sigmaerpdev2__Vendor_Product__c where sigmaerpdev2__Vendor_Location__r.Name=:wrapper.Location and sigmaerpdev2__Account_Name__c=:Acc.Id and sigmaerpdev2__Product_Name__r.Name=:wrapper.Product];
                vp.Id=exactVP.Id;
                vp.sigmaerpdev2__Product_Name__c = exactVP.sigmaerpdev2__Product_Name__c;
                vp.sigmaerpdev2__Vendor_Location__c = exactVP.sigmaerpdev2__Vendor_Location__c;
                vp.sigmaerpdev2__VendorProductCode__c= wrapper.VendorCode;
                vp.sigmaerpdev2__Current_Stock__c=wrapper.CurrentStock;
                vp.sigmaerpdev2__Account_Name__c=exactVP.sigmaerpdev2__Account_Name__c;
                vp.sigmaerpdev2__Last_Updated_Date__c=Date.valueOf(wrapper.StockAsOnDate);
                ListtoInsert.add(vp);
            }
            catch(Exception e){
                rr=wrapper.Product;
            }
        }
        for (integer i = 0; i < ListtoInsert.size(); i++) {
            //for (integer j = i + 1 ; j < ListtoInsert.size(); j++) {
            /*for(Integer j=0;j<vpList.size();j++){
                if(ListtoInsert[i].Name != vpList[j].Name){
                    returnresponse = 'errorp';
                }
            }*/
            
            if (vpMap.containsKey(ListtoInsert[i].Id)) {
                returnresponse = 'error1'+(i+2);
                System.debug('if>>>'+returnresponse);
            } 
            else{
                if(ListtoInsert[i].sigmaerpdev2__Vendor_Location__r.Name==null && rr!=''){
                   
                    System.debug('if>>'+ListtoInsert[i].sigmaerpdev2__Vendor_Location__r.Name);
                    System.debug('if51>>'+ListtoInsert[i].sigmaerpdev2__Vendor_Location__c);
                    returnresponse = 'errorLoc'+rr;
                    
                }
                else{
                    System.debug('else');
                    vpMap.put(ListtoInsert[i].Id, ListtoInsert[i].sigmaerpdev2__Vendor_Location__c);
                    System.debug('else>>>'+ListtoInsert[i]);
                    returnresponse = 'success';  
                }
            }
            if(ListtoInsert[i].sigmaerpdev2__VendorProductCode__c == null || ListtoInsert[i].sigmaerpdev2__VendorProductCode__c ==''){
                returnresponse = 'errorVC'+(i+2);
            }
            System.debug('returnresponse61>>>'+returnresponse);            
        }
        /*Set<Id> insertListIds=new Set<Id>();
        for(sigmaerpdev2__Vendor_Product__c vp: ListtoInsert){
            insertListIds.add(vp.Id);
        }
        System.debug('ListtoInsert>>'+ListtoInsert);
        if(vpListIds.containsAll(insertListIds)){
            returnresponse = 'success';
        }
        else if(!vpListIds.containsAll(insertListIds)){
            returnresponse = 'errorp';
        }*/
        String msg='';
        if(returnresponse == 'success'){
            try{
                update ListtoInsert;       
            }
            catch(Exception e){  
                returnresponse = e.getMessage()+ ', At Line number '+e.getStackTraceString();
                //throw new AuraHandledException(e.getMessage());           
            }
        }
        
        return returnresponse;
    }
    
    public class fieldWrapper{    
        public String Id;
        public String Product;
        public String Location;
        public String VendorCode;
        public Double CurrentStock;
        public Date StockAsOnDate;
        
    } 
}