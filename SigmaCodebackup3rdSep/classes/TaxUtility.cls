public with sharing class TaxUtility{

 public Double taxAmt{get;set;}
    public Double calculateTax(Double amt,String state,String country){
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Tax__c',new set<String>{'Id','sigmaerpdev__Name__c','sigmaerpdev__State__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__Status__c','sigmaerpdev__Type__c','sigmaerpdev__Country__c'}))
        {
        Tax__c tax;
            tax = [Select Id,Name__c,State__c,Tax_Amount__c,Status__c,Type__c,Country__c from Tax__c where id=:state];
        
        if(tax.Status__c == 'Active'){
            //calculate for percentage
            if(tax.Type__c== 'Percentage'){
                taxAmt= (amt*tax.Tax_Amount__c)/100;
            }
            //calculate for Flat
            else if(tax.Type__c== 'Flat'){
                taxAmt= (amt+tax.Tax_Amount__c);
            }
        }
        }
        return taxAmt;
    }

    //get the tax details against state
    public Double calculateTaxForCity(String state){

        //get the tax amount for the state
        system.debug('Incoming State :'+state);
        Double stateTax = 0.00;
        Tax__c tax;
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Tax__c',new set<String>{'Id','sigmaerpdev__Name__c','sigmaerpdev__State__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__Status__c','sigmaerpdev__Type__c','sigmaerpdev__Country__c'}))
        {
         tax = [Select Id,Name__c,State__c,Tax_Amount__c,Status__c,Type__c,Country__c from Tax__c where id=:state or State__c=:state LIMIT 1];
       
        if(tax.Status__c=='Active')
        {
           stateTax = tax.Tax_Amount__c;
        }
        }

        return stateTax;
    }
    
    //get the federal tax
    public Double getFederalTax(){
    Double federalTax = 0.00;        
        Tax__c tax;
       if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Tax__c',new set<String>{'Id','sigmaerpdev__Name__c','sigmaerpdev__State__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__Status__c','sigmaerpdev__Type__c','sigmaerpdev__Country__c'}))
        {
            tax = [Select Id,Name__c,State__c,Tax_Amount__c,Status__c,Type__c,Country__c from Tax__c where Name__c='Federal Tax' LIMIT 1];
            if(tax.Status__c=='Active'){
                federalTax = tax.Tax_Amount__c;
            }
       
        }
        return federalTax;
    }
    public Double getFederalTaxByCountry(String country){

        //get the tax amount for the state
        Double federalTax = 0.00;
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Tax__c',new set<String>{'Id','sigmaerpdev__Name__c','sigmaerpdev__State__c','sigmaerpdev__Tax_Amount__c','sigmaerpdev__Status__c','sigmaerpdev__Type__c','sigmaerpdev__Country__c'}))
        {
        if(country!='' && country!=NULL && country!=null){
            Tax__c tax;
           
                tax = [Select Id,Name__c,State__c,Tax_Amount__c,Status__c,Type__c,Country__c from Tax__c where (id=:country or Country__c=:country) AND Name__c='Federal Tax' LIMIT 1];
                if(tax.Status__c=='Active'){
                    federalTax = tax.Tax_Amount__c;
                }
                     
        }
        }
        return federalTax;
    }
    
}