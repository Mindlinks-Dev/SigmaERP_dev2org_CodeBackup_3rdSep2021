public with sharing class CheckDuplicateTaxHandler{
     
     public void CheckDuplicateinsert(List<Tax__c> newTax){
         if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Tax__c')
         && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Tax__c',new set<String>{'Id','sigmaerpdev__Name__c','sigmaerpdev__Status__c','sigmaerpdev__Country__c','sigmaerpdev__State__c','sigmaerpdev__Merchant_Account__c','sigmaerpdev__Merchant_Account__r.Name','sigmaerpdev__Applies_To__c'})){
         
            List<string> Country= new List<string>();
            List<string> State= new List<string>();
            List<string> AppliesTo= new List<string>();
            List<Id> taxId= new List<Id>();
            
            for(Tax__c tax : newTax){
            Country.add(tax.Country__c);
            State.add(tax.State__c);
            AppliesTo.add(tax.Applies_To__c);
            taxId.add(tax.Id);  
            }
            List<Tax__c> duplicateTaxList = [Select Id,Name__c,Status__c,Country__c,State__c,Merchant_Account__c,Merchant_Account__r.Name,Applies_To__c From Tax__c where Applies_To__c= 'State Tax' and Country__c IN: Country and State__c IN: State  and Applies_To__c IN: AppliesTo];
            
             if(!duplicateTaxList.isEmpty()){
                 
                 for(Tax__c taxList:newTax){
                     for(Tax__c taxList1:duplicateTaxList){
                         
                         if(taxList.Country__c == taxList1.Country__c && taxList.State__c == taxList1.State__c  && taxList.Applies_To__c == taxList1.Applies_To__c && taxList1.Status__c =='Active'){
                         
                          taxList.addError('Tax Already Exists for this State:'+taxList.State__c+',Country:'+taxList.Country__c+'Of this State Tax');
                         
                         }
                     }
                 }
                 
             }
             
             List<Tax__c> duplicateFedTaxList = [Select Id,Name__c,Country__c,State__c,Merchant_Account__c,Merchant_Account__r.Name,Status__c,Applies_To__c From Tax__c where Applies_To__c= 'Federal Tax' and Country__c IN: Country   and Applies_To__c IN: AppliesTo];
            
             if(!duplicateFedTaxList.isEmpty()){
                 
                 for(Tax__c FedtaxList:newTax){
                     for(Tax__c FedtaxList1:duplicateFedTaxList){
                         
                         if(FedtaxList.Country__c == FedtaxList1.Country__c   && FedtaxList.Applies_To__c == FedtaxList1.Applies_To__c && FedtaxList1.Status__c =='Active'
                            ){
                          FedtaxList.addError('Tax Already Exists for this Country:'+FedtaxList.Country__c+'Of this Federal Tax');
                         }
                         
                     }
                 }
                 
             }
        }
     }
        public void checkDuplicatesupdate(List<Tax__c> newTax){
            if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Tax__c',new set<String>{'Id','sigmaerpdev__Name__c','sigmaerpdev__Country__c','sigmaerpdev__State__c','sigmaerpdev__Merchant_Account__c','sigmaerpdev__Merchant_Account__r.Name','sigmaerpdev__Applies_To__c','sigmaerpdev__Status__c'}))
                {
         
            List<string> Country= new List<string>();
            List<string> State= new List<string>();
            List<string> AppliesTo= new List<string>();
            List<Id> taxId= new List<Id>();
            
            for(Tax__c tax : newTax){
            Country.add(tax.Country__c);
            State.add(tax.State__c);
            AppliesTo.add(tax.Applies_To__c);
            taxId.add(tax.Id);  
            }
            
            List<Tax__c> duplicateTaxList = [Select Id,Name__c,Country__c,State__c,Merchant_Account__c,Merchant_Account__r.Name,Status__c,Applies_To__c From Tax__c where Applies_To__c= 'State Tax' and Country__c IN: Country and State__c IN: State  and Applies_To__c IN: AppliesTo];
            
             if(!duplicateTaxList.isEmpty()){
                 
                 for(Tax__c taxList:newTax){
                     for(Tax__c taxList1:duplicateTaxList){
                         
                         if(taxList.Country__c == taxList1.Country__c && taxList.State__c == taxList1.State__c  && taxList.Applies_To__c == taxList1.Applies_To__c && taxList1.id!=taxList.id && taxList1.Status__c =='Active'){
                         
                          taxList.addError('Tax Already Exists for this State:'+taxList.State__c+',Country:'+taxList.Country__c+'Of this State Tax');
                         
                         }
                     }
                 }
                 
             }
             
             List<Tax__c> duplicateFedTaxList = [Select Id,Name__c,Country__c,State__c,Merchant_Account__c,Merchant_Account__r.Name,Status__c,Applies_To__c From Tax__c where Applies_To__c= 'Federal Tax' and Country__c IN: Country   and Applies_To__c IN: AppliesTo];
            
             if(!duplicateFedTaxList.isEmpty()){
                 
                 for(Tax__c FedtaxList:newTax){
                     for(Tax__c FedtaxList1:duplicateFedTaxList){
                         
                         if(FedtaxList.Country__c == FedtaxList1.Country__c   && FedtaxList.Applies_To__c == FedtaxList1.Applies_To__c && FedtaxList1.id!=FedtaxList.id && FedtaxList1.Status__c =='Active'){
                          FedtaxList.addError('Tax Already Exists for Country:'+FedtaxList.Country__c+'Of this Federal Tax');
                         }
                         
                     }
                 }
                 
             }
          }
        }           
}