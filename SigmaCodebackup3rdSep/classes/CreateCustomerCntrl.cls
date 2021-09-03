public with sharing Class CreateCustomerCntrl
{
   @AuraEnabled
    public static Account StoreCustomer(Account customerObj)
    {
        
    /*if(CRUD_FLS_CheckUtility.checkObjCRUD('Account')
    && CRUD_FLS_CheckUtility.checkFLS('Account',new set<String>{'Name','BillingPostalCode','BillingStreet','BillingState','BillingCity','BillingCountry','sigmaerpdev__Account_Created_Via__c','sigmaerpdev__Zip__c' ,'sigmaerpdev__City__c','sigmaerpdev__State__c','sigmaerpdev__Country__c','sigmaerpdev__LastName__c' }))
      {*/
                
        Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
    
       //Id RID ;
       //RID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Logistics').getRecordTypeId();
        
       customerObj.Type = 'Customer';
       //customerObj.RecordTypeId = RID;
       customerObj.BillingPostalCode =  customerObj.Zip__c;
        customerObj.BillingStreet =  customerObj.City__c;
        customerObj.BillingState = customerObj.State__c;
        customerObj.BillingCity = customerObj.City__c;
        customerObj.BillingCountry = customerObj.Country__c;
        customerObj.Account_Created_Via__c = 'POS';
        String Fname = customerObj.Name +'';
        String Lname = customerObj.LastName__c;
        String  finalName = Fname +' '+ Lname;
        customerObj.Name =finalName; 
       
        
           
             insert customerObj;  
           
          
      //}    
       return customerObj;
       
    } 
    
    
     
    
        
}