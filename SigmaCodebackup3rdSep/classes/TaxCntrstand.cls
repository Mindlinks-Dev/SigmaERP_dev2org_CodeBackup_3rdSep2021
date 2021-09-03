public with sharing class TaxCntrstand {

    @AuraEnabled
   public static List<Tax__c> getTax(Id customerSFID)
    {   
         List<Tax__c> totalTaxes = new List<Tax__c>();
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<string>{'id','name','BillingState','BillingCountry','sigmaerpdev__Country__c','sigmaerpdev__State__c'})
          &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Tax__c',new set<string>{'Id','sigmaerpdev__Name__c','sigmaerpdev__Applies_To__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__Type__c','sigmaerpdev__Country__c','sigmaerpdev__State__c','sigmaerpdev__Merchant_Account__c','sigmaerpdev__Status__c'})
          
         )
         {*/
        Account accDetails;
          accDetails = [select id,name,BillingState,BillingCountry,Country__c,State__c from Account where id =: customerSFID];
            
        List<Tax__c> federalTax = new List<Tax__c>();
        List<Tax__c> stateTax = new List<Tax__c>();
        List<Tax__c> ProductTax = new List<Tax__c>();
        try{
            federalTax  = [Select Id,Name__c,Status__c,Applies_To__c,Tax_Amount__c,Type__c,Country__c,State__c,Merchant_Account__c from Tax__c  where Applies_To__c = 'Federal Tax' and Country__c =:accDetails.Country__c and Merchant_Account__c =:accDetails.Id  limit 1];  
              
         }
        catch(Exception ex){
        }
        
        try{
           stateTax  = [Select Id,Name__c,Status__c,Tax_Amount__c,Applies_To__c,Type__c,Country__c,State__c,Merchant_Account__c from Tax__c  where Applies_To__c = 'State Tax' and Country__c = :accDetails.Country__c and State__c = :accDetails.State__c and Merchant_Account__c =:accDetails.Id and Status__c = 'Active' limit 1]; 
           }
        catch(Exception ex){
        system.debug('Exception occured during fetching of stateTax ::'+ex);    
        }
        
   
        if(federalTax.size() > 0 &&  federalTax[0].Status__c == 'Active'){
        totalTaxes.add(federalTax[0]);      
        }
        else{
        Tax__c  tempFederalobj = new Tax__c();  
        tempFederalobj.Tax_Amount__c = 0;
        tempFederalobj.Type__c = 'Percentage';
        totalTaxes.add(tempFederalobj); 
        }   
        
        if(stateTax.size() > 0 && stateTax[0].Status__c == 'Active'){
        totalTaxes.add(stateTax[0]);        
        }
        else{
        Tax__c  tempStateobj = new Tax__c();            
        tempStateobj.Tax_Amount__c = 0;
        tempStateobj.Type__c = 'Percentage';    
        totalTaxes.add(tempStateobj);
        }
        
       
       //} 
        return totalTaxes;        
    }
    @AuraEnabled
    public static Order orderRecords(id Ids)
    {
      Order srecord ;
      
     /* if(CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'id','TotalAmount','OrderNumber','sigmaerpdev__Is_Payment_Made__c','sigmaerpdev__TotalAmount__c','sigmaerpdev__Due_Amount__c','sigmaerpdev__Net_Amount__c','sigmaerpdev__Orders_Status__c','AccountId','Account.Name'})){*/
         srecord = new Order();
        srecord = [select id,TotalAmount,OrderNumber,Is_Payment_Made__c,TotalAmount__c,Net_Amount__c,Due_Amount__c,Orders_Status__c,AccountId,Account.Name from Order where id=:ids]; 
        
      // }
        return srecord;    
    }
    
    //CODE FOR VALIDATION OF SIGMA ORDER FROM CUSTOM SETTINGS , added by sandhya
     @AuraEnabled
     public Static customWrappervalid  custvalidOrder(){
         
         customWrappervalid custvalids = new customWrappervalid();
         /* if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Time_Base_Inventory__c',new set<String>{'sigmaerpdev__Order__c','sigmaerpdev__Proposal__c','sigmaerpdev__Proposal_for_Products__c','sigmaerpdev__Proposal_to_Order__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_API__c',new set<String>{'sigmaerpdev__Subscription_Product__c','sigmaerpdev__Subscription_Renewal__c'})
            ){*/
         custvalids.ou = [Select Sigma_order__c,Standard_object__c from Order_Usage__c limit 1];
         custvalids.tmi = [Select Order__c,Proposal__c,Proposal_for_Products__c,Proposal_to_Order__c from Time_Base_Inventory__c limit 1];
         custvalids.OP =[select Subscription_Product__c,Subscription_Renewal__c from Order_API__c limit 1] ; 
        
          //  }
         return custvalids;
     }
     
     public class customWrappervalid{
         @AuraEnabled
         public Order_Usage__c ou{get;set;}
         @AuraEnabled        
         public Time_Base_Inventory__c tmi{get;set;}
         @AuraEnabled 
         public Order_API__c OP{get;set;}
        
     }
  
    
}