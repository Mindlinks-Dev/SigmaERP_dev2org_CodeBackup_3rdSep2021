public without sharing class OrderTaxCntr {
    
    @AuraEnabled
    public static List<Tax__c> getTax(Id OrderID)
    {   
        List<Tax__c> totalTaxes = new List<Tax__c>();
        
            Sigma_Order__c SO = [Select id,ShippingCountry__c,ShippingState__c from Sigma_Order__c where Id=:OrderID];
			List<Tax__c> federalTax = new List<Tax__c>();
            List<Tax__c> stateTax = new List<Tax__c>();
            List<Tax__c> ProductTax = new List<Tax__c>();
            try{
                   federalTax  = [Select Id,Name__c,Status__c,Applies_To__c,Tax_Amount__c,Type__c,Country__c,State__c,Merchant_Account__c from Tax__c  where Applies_To__c = 'Federal Tax' and Country__c =:SO.ShippingCountry__c   limit 1];  
                   
            }
            catch(Exception ex){
            }
            
            try{
                  stateTax  = [Select Id,Name__c,Status__c,Tax_Amount__c,Applies_To__c,Type__c,Country__c,State__c,Merchant_Account__c from Tax__c  where Applies_To__c = 'State Tax' and Country__c = :SO.ShippingCountry__c and State__c = :SO.ShippingState__c   limit 1]; 
                    
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
           
       
       return totalTaxes;        
    }
	
	@AuraEnabled
    public static List<Tax__c> getstdorderTax(Id OrderID)
    {   
        List<Tax__c> totalTaxes = new List<Tax__c>();
        
            Order Ord = [Select id,ShippingCountry__c,ShippingState__c from Order where Id=:OrderID];
			List<Tax__c> federalTax = new List<Tax__c>();
            List<Tax__c> stateTax = new List<Tax__c>();
            List<Tax__c> ProductTax = new List<Tax__c>();
            try{
                   federalTax  = [Select Id,Name__c,Status__c,Applies_To__c,Tax_Amount__c,Type__c,Country__c,State__c,Merchant_Account__c from Tax__c  where Applies_To__c = 'Federal Tax' and Country__c =:Ord.ShippingCountry__c   limit 1];  
                   
            }
            catch(Exception ex){
            }
            
            try{
                  stateTax  = [Select Id,Name__c,Status__c,Tax_Amount__c,Applies_To__c,Type__c,Country__c,State__c,Merchant_Account__c from Tax__c  where Applies_To__c = 'State Tax' and Country__c = :Ord.ShippingCountry__c and State__c = :Ord.ShippingState__c   limit 1]; 
                    
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
           
       
       return totalTaxes;        
    }
     
}