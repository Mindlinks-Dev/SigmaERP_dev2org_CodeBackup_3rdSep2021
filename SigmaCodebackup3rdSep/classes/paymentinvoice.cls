public with sharing class paymentinvoice {
     @auraEnabled
    public static List<Sigma_Order__c> getSalesInvoiceForPayment(String accId)
    {
        List<Sigma_Order__c> saleInvoiceList=[Select id,AccountId__c,AccountId__r.Name,Name,Due_Amount__c,TotalAmount__c from  Sigma_Order__c where AccountId__c=:accId and Customer_Type__c='Credit Customer' and Due_Amount__c>0 and TotalAmount__c>0 order by name desc];
         return saleInvoiceList;
    }


@AuraEnabled
    public static List<Tax__c> getTax(list<String> customerSFID)
    {   
        List<Tax__c> totalTaxes = new List<Tax__c>();
        if(CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<string>{'id','name','BillingState','BillingCountry','sigmaerpdev__Country__c','sigmaerpdev__State__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Tax__c',new set<string>{'Id','sigmaerpdev__Name__c','sigmaerpdev__Applies_To__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__Type__c','sigmaerpdev__Country__c','sigmaerpdev__State__c','sigmaerpdev__Merchant_Account__c','sigmaerpdev__Status__c'})
          )
        {
            Account accDetails;
                accDetails = [select id,name,BillingState,BillingCountry,Country__c,State__c from Account where id =: customerSFID];
            
            List<Tax__c> federalTax = new List<Tax__c>();
            List<Tax__c> stateTax = new List<Tax__c>();
            List<Tax__c> ProductTax = new List<Tax__c>();
            try{
                   federalTax  = [Select Id,Name__c,Status__c,Applies_To__c,Tax_Amount__c,Type__c,Country__c,State__c,Merchant_Account__c from Tax__c  where Applies_To__c = 'Federal Tax' and Country__c =:accDetails.Country__c   limit 1];  
                   
            }
            catch(Exception ex){
            }
            
            try{
                  stateTax  = [Select Id,Name__c,Status__c,Tax_Amount__c,Applies_To__c,Type__c,Country__c,State__c,Merchant_Account__c from Tax__c  where Applies_To__c = 'State Tax' and Country__c = :accDetails.Country__c and State__c = :accDetails.State__c   limit 1]; 
                    
               }
            catch(Exception ex){
                system.debug('Exception occured during fetching of stateTax ::'+ex);    
            }
           
            if(federalTax.size() > 0 && federalTax[0].Status__c == 'Active'){
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
           
        } 
       return totalTaxes;        
    }    
    @AuraEnabled
    public static List<Sigma_Order__c> OrderedProduct(string Ids)
    {
        List<string> val = new List<string>();
        val=(List<string>)System.JSON.deserialize(Ids,List<string>.class);
        system.debug('val::'+val);
       List<Sigma_Order__c> srecord = new List<Sigma_Order__c>();
        
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'id','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Proposals__c','sigmaerpdev__Due_Amount__c','sigmaerpdev__Total_Amount__c','sigmaerpdev__Order_Number__c','sigmaerpdev__BillingPersonNew__c','sigmaerpdev__Billing_Person__c','sigmaerpdev__Is_Payment_Made__c','sigmaerpdev__BillingPersonNew__r.Name','sigmaerpdev__TotalAmount__c','sigmaerpdev__Net_Amount__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__AccountId__r.Name','RecordTypeId','RecordType.Name'})
     &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'id', 'name','sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Shipped_Quantity__c'})
    )
        {
            srecord = [select id,Order_Created_Via__c,Proposals__c,Total_Amount__c,Due_Amount__c,Order_Number__c,BillingPersonNew__c,Billing_Person__c,Is_Payment_Made__c,BillingPersonNew__r.Name,TotalAmount__c,Net_Amount__c,Orders_Status__c,AccountId__r.Name,RecordTypeId,RecordType.Name,(select id, name,Delivered_Quantity__c,Packaged_Quantity__c,Shipped_Quantity__c from Order_Lines__r) from Sigma_Order__c where id=:val]; 
           
        }
        system.debug('srecord::'+srecord);
        return srecord;   
       
    } 
    
     @AuraEnabled
     public Static customWrappervalid  ordervalid(){
          customWrappervalid cuvalid = new customWrappervalid();
          if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Time_Base_Inventory__c',new set<String>{'sigmaerpdev__Order__c','sigmaerpdev__Proposal__c','sigmaerpdev__Proposal_for_Products__c','sigmaerpdev__Proposal_to_Order__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_API__c',new set<String>{'sigmaerpdev__Subscription_Product__c','sigmaerpdev__Subscription_Renewal__c'})
            ){
     
               cuvalid.ou = [Select Sigma_order__c,Standard_object__c from Order_Usage__c limit 1];
                cuvalid.tmi = [Select Order__c,Proposal__c,Proposal_for_Products__c,Proposal_to_Order__c from Time_Base_Inventory__c limit 1];
                cuvalid.OP =[select Subscription_Product__c,Subscription_Renewal__c from Order_API__c limit 1] ; 
               
            }
         return cuvalid;
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