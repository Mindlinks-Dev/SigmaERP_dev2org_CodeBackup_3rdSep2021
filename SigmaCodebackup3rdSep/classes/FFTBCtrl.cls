public without sharing class FFTBCtrl { 
    @AuraEnabled
    public static List<Sigma_Order__c> getBPData(String bpId, DateTime fromDate, DateTime endDate){
        List<Sigma_Order__c> sigmaOrdList = [select sc.id,sc.name,sc.Delivary_Date__c,
							sc.Net_Quantity__c,sc.TotalAmount__c,sc.Brewer_Account__r.Commision_Fees__c from Sigma_Order__c sc 
                            where sc.Brewer_Account__c = :bpId AND
							sc.CreatedDate >= :fromDate AND sc.CreatedDate <= :endDate 
                            AND sc.Payment_Made_to_BP__c = false AND sc.Is_Payment_Made__c = true ORDER BY Name ASC];
		return sigmaOrdList;
    }       
    
    /*@AuraEnabled
    public static List<Account> getBPsList(){
        List<Account> accList = [select id,Name,sigmaerpdev2__Active__c,sigmaerpdev2__Currency_code__c,CreatedDate,
                                 Email__c,Contact_Person_Mobile__c,Commision_Fees__c 
                                 from Account where recordType.name='Vendor' ORDER BY Name ASC];
		return accList;
    }*/
    
    @AuraEnabled
    public static List<Brewery_Registry__c> getBPsList(){
        List<Brewery_Registry__c> accList = [select name,Brewer_Account__c,Brewery_Name__c,
                                 Date_of_Registration__c,Email__c,Contact_Number__c,
                                 Registration_Status__c from Brewery_Registry__c ORDER BY Name ASC];
		return accList;
    }
    
    @AuraEnabled
    public static String changeBPStatus(String brewID, String status){
        String newStatus = '';
        try{           
            List<User> userList = [select Id,IsActive,Contact.AccountId from User where Contact.AccountId = :brewID];        
            Brewery_Registry__c brObj = [select id,name,Registration_Status__c from Brewery_Registry__c where Brewer_Account__c = :brewID];            
            if(status == 'Active'){
                brObj.Registration_Status__c = 'Inactive';
                update brObj;
                UpdateContacts(brewID, status);          
            }else{
                brObj.Registration_Status__c = 'Active';
                update brObj;
                UpdateContacts(brewID, status);
        	}  
        newStatus = (String) brObj.Registration_Status__c;		  
        }catch(Exception e){
            newStatus = e.getMessage();
        }
        return newStatus; 
    }
    
    @future
    public static void UpdateContacts(String brewID, String status){
        List<User> userList = [select Id,IsActive,Contact.AccountId from User where Contact.AccountId = :brewID]; 
        if(status == 'Active'){
            if(userList.size() > 0){
                for(User userObj : userList){
                    userObj.IsActive = false;
                }
                update userList;    
            } 
        }else{  
            if(userList.size() > 0){
                for(User userObj : userList){
                    userObj.IsActive = true;
                }
                update userList;    
            }
        }  
    }
            
    @AuraEnabled
    public static String makeBPPayments(String bpId, Date fromDate, Date endDate, Decimal totalSalesAmt, Decimal deductCommAmt, List<String> sigOrdsId){
        String msg = 'success';
        try{            
            Account accObj = [select id,Interval__c from Account where id = :bpId];            
        	BP_Payment__c bpObj = new BP_Payment__c();
            bpObj.Brewery_Producer__c = bpId;
            bpObj.Interval__c = accObj.Interval__c;
            insert bpObj;
            
            BP_Payment_Details__c bpdObj = new BP_Payment_Details__c();
            bpdObj.BP_Payment__c = bpObj.Id;
            bpdObj.From_Date__c = fromDate;
            bpdObj.To_Date__c = endDate;
            bpdObj.Total_Sales_Amount__c = totalSalesAmt;
            bpdObj.Commission_Amount__c = deductCommAmt;
            bpdObj.Final_payable_amount_to_BP__c = (totalSalesAmt - deductCommAmt);
            bpdObj.Amount_Paid__c = (totalSalesAmt - deductCommAmt);
            insert bpdObj;            
            
            List<String> lstAlpha = sigOrdsId;
            List<Sigma_Order__c> sigList = [select id,name,Payment_Made_to_BP__c from Sigma_Order__c where id in :lstAlpha];
            for(Sigma_Order__c sordObj : sigList){
                sordObj.Payment_Made_to_BP__c = true;
            }
            update sigList;
            
        	return msg;
        }catch(Exception ex){
            msg = ex.getMessage();
            return msg;
        }
    }
    
    @AuraEnabled
    public static List<Sigma_Order__c> getBPSales(String selVal){ 
        //Contact cntObj = [select AccountId from Contact where id =: UserInfo.getUserId()];
		
        User currentuser = [select Id,Profile.Name,Contact.AccountId from User where Id =: UserInfo.getUserId()];        
        /*List<Sigma_Order__c> sigmaOrdList = [select id,name,sigmaerpdev2__Customer_Formula__c,Delivary_Date__c,
								Net_Quantity__c,TotalAmount__c,Is_Payment_Made__c,Orders_Status__c
                                from Sigma_Order__c where Brewer_Account__c = :cntObj.AccountId
                                ORDER BY Name DESC];

		//from Sigma_Order__c where Brewer_Account__c = '0012x00000FR5bC'
		*/
        List<Sigma_Order__c> sigmaOrdList = new List<Sigma_Order__c>();
        if(selVal.equalsIgnoreCase('All')){
        	sigmaOrdList = [select id,name,sigmaerpdev2__Customer_Formula__c,Delivary_Date__c,
								Net_Quantity__c,TotalAmount__c,Is_Payment_Made__c,Orders_Status__c
                                from Sigma_Order__c where Brewer_Account__c =: currentuser.Contact.AccountId                              
                                ORDER BY Name DESC];    
        }else{
           sigmaOrdList = [select id,name,sigmaerpdev2__Customer_Formula__c,Delivary_Date__c,
								Net_Quantity__c,TotalAmount__c,Is_Payment_Made__c,Orders_Status__c
                                from Sigma_Order__c where Brewer_Account__c =: currentuser.Contact.AccountId 
                           		and Orders_Status__c = :selVal
                                ORDER BY Name DESC];    
        }        
		return sigmaOrdList;
    }
    
    @AuraEnabled
    public static List<Account> getBPCustomers(){
        //Contact cntObj = [select AccountId from Contact where id = :UserInfo.getUserId()];
        User currentuser = [select Id,Profile.Name,Contact.AccountId from User where Id =: UserInfo.getUserId()]; 
        List<Brewery_Customer__c> custList = new List<Brewery_Customer__c>();
        custList = [select id,Brewer_Account__c,Brewery_Customer__c from Brewery_Customer__c];
        Set<Id> custIds = new Set<Id>();
        List<Account> accList = new List<Account>();
        if(custList.size() > 0)
        {
           for(Brewery_Customer__c bcObj : custList){
           	custIds.add(bcObj.Brewery_Customer__c);
           }
           accList = [select id,name,Email__c,Contact_Person_Mobile__c,
                                     ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry 
                                     from account where id in :custIds];
        }        
		return accList;
    }
    
    @AuraEnabled
    public static void markAsDelvStatus(String soId){
        Sigma_Order__c soObj = [select id,Orders_Status__c from Sigma_Order__c where id = :soId];        
        soObj.Orders_Status__c = 'Delivered';        
        update soObj;
    }
    
    @AuraEnabled
    public static void deleteSalesOrder(String soId){
        Sigma_Order__c soObj = [select id from Sigma_Order__c where id = :soId];  
        delete soObj;
    }
    
}