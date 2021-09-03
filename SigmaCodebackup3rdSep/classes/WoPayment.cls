public with sharing class WoPayment{
    
    @AuraEnabled
    public static List<Tax__c> getTax(Id customerSFID)
    {
         List<Tax__c> totalTaxes = new List<Tax__c>();
        try{
        //List<Tax__c> totalTaxes = new List<Tax__c>();
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
         catch(Exception ex)
        {
            createErrorLog.insertError('WoPayment',ex.getMessage(),'Method -getTax ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
        } 
        //} 
       return totalTaxes;        
    }
    
    @AuraEnabled
    public static Work_Order__c orderRecords(id Ids)
    {
        Work_Order__c srecord = new Work_Order__c();
        try{
        system.debug('ids??'+Ids);
       
        
            srecord = [Select Id,Name,sigmaerpdev2__Is_Payment_Made__c,sigmaerpdev2__Account__r.Name,Account__r.Customer_Type__c,Tax__c,Tax_Amount__c,Service_Contract__c,Service_Contract__r.Contract_End_Date__c,
                       sigmaerpdev2__Account__r.AccountNumber,sigmaerpdev2__Work_Type__c,Service_Warrenty_End_date__c,sigmaerpdev2__TotalAmount__c,sigmaerpdev2__Paid_Amount__c,Customer_Availability_Date__c,
                       sigmaerpdev2__Work_Type__r.sigmaerpdev2__Service_Charge__c ,Sigma_orders__r.Total_Price__c,sigmaerpdev2__FFP_MR_Contact__c,Status__c,
                       sigmaerpdev2__Due_Amount__c,Net_Amount__c FROM sigmaerpdev2__Work_Order__c where id=:ids]; 

             Datetime dT=srecord.Customer_Availability_Date__c;
             Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
             
            if((srecord.Service_Warrenty_End_date__c!=null) || (srecord.Service_Contract__c!=null)){
            system.debug('myDate - '+myDate);
            if((myDate<=srecord.Service_Warrenty_End_date__c) || (myDate<=srecord.Service_Contract__r.Contract_End_Date__c)){
            srecord.sigmaerpdev2__Work_Type__r.sigmaerpdev2__Service_Charge__c=0;
            }
            }
            Decimal scharge=0;
            if(srecord.sigmaerpdev2__Work_Type__r.sigmaerpdev2__Service_Charge__c!=null){
            scharge=srecord.sigmaerpdev2__Work_Type__r.sigmaerpdev2__Service_Charge__c;
            }
        if(srecord.sigmaerpdev2__TotalAmount__c==null){
            srecord.sigmaerpdev2__TotalAmount__c=0;
            
        }
        
        
        List<sigmaerpdev2__Work_Oder_Lines__c> sorecord;
        set<Id> prod=new set<Id>();
       sorecord=[Select Id,sigmaerpdev2__Product__c,Work_Order__r.Product_Warranty_End_date__c,sigmaerpdev2__Discount__c,sigmaerpdev2__Quote__c,sigmaerpdev2__Quantity__c,sigmaerpdev2__Price__c,sigmaerpdev2__Value__c,
         sigmaerpdev2__Warranty__c,sigmaerpdev2__Description__c,sigmaerpdev2__Cost__c,sigmaerpdev2__Product__r.Name FROM sigmaerpdev2__Work_Oder_Lines__c where sigmaerpdev2__Work_Order__c=:ids AND sigmaerpdev2__quote__c = false AND (sigmaerpdev2__Used1__c = true OR sigmaerpdev2__Warranty__c = true) ];
        
            Decimal TotalAmount;
            Decimal amnt;
            Decimal amt;
            Decimal cnt=0;
            Decimal cn=0;
            Decimal tamount=0;
            
     for(sigmaerpdev2__Work_Oder_Lines__c wol: sorecord) {
        prod.add(wol.sigmaerpdev2__Product__c);
        }
         
         
        List<PricebookEntry> prce =[Select Product2Id,UnitPrice From PricebookEntry WHERE PriceBook2.Name = 'Standard Price Book' and Product2.Id =:prod];
        Decimal unitprice=0;
        Map<Id,Decimal> uprice = new Map<Id,Decimal>();
        for(PricebookEntry pbe: prce) {
          unitprice=pbe.UnitPrice;
            uprice.put(pbe.Product2Id,UnitPrice);
          }
         for(sigmaerpdev2__Work_Oder_Lines__c wol: sorecord) {
         

             amt=uprice.get(wol.sigmaerpdev2__Product__c)*wol.sigmaerpdev2__Quantity__c;
             
             Service_Quote__c[] sq = [select id,Name,Work_Order__c from Service_Quote__c where Work_Order__c=:ids];
                 system.debug('sq'+sq);
                 
            
            if (!sq.isEmpty()) {
                List<Sigma_Order__c> so=new List<Sigma_Order__c>([Select id,name,sigmaerpdev2__Paid_Amount__c,sigmaerpdev2__Is_Payment_Made__c,sigmaerpdev2__Service_Quote__c,(select id,Name,sigmaerpdev2__Product__c from sigmaerpdev2__Order_Lines__r) from sigmaerpdev2__Sigma_Order__c where Service_Quote__c =:sq]);
             system.debug('so'+so);
            
             if(so[0].Is_Payment_Made__c==true){
                 for(Sigma_Order__c s:so){
                     for(Product_Order_Price_Book__c ol:s.sigmaerpdev2__Order_Lines__r){
                         if(ol.Product__c==wol.sigmaerpdev2__Product__c){
                           amt=0;  
                         }
                     }
                     
                 }
                 
                 
             }
            } 
        system.debug('amt'+amt);
         amnt=amt;
             system.debug('amt1>>'+amt);
        cn=cn+amt;
        
        system.debug('myDate>>'+myDate);
        if((myDate<=wol.Work_Order__r.Product_Warranty_End_date__c) || (myDate<=wol.Work_Order__r.Product_Warranty_End_date__c)){
        
                wol.sigmaerpdev2__Warranty__c=true;
                
        }
        
                system.debug('wol.sigmaerpdev2__Warranty__c>>'+wol.sigmaerpdev2__Warranty__c);
               if(wol.sigmaerpdev2__Warranty__c==true){
                    system.debug('inside if>>');
                    cnt=cnt+amt;
                   
                }
    
         }
        
        
            
            amnt=cn-cnt;
            system.debug('amt1111>>'+amnt);
            tamount=scharge+amnt;
            Double TaxOnBillAmount = 0;
            List<Tax__c> taxObj = getTax(srecord.Account__c);
                Double federalTax = Double.valueOf(taxObj.get(0).Tax_Amount__c);
                String fedTaxType = String.valueOf(taxObj.get(0).Type__c);
                Double stateTax = Double.valueOf(taxObj.get(1).Tax_Amount__c);
                String stateTaxType = String.valueOf(taxObj.get(1).Type__c);
                
                if(fedTaxType == 'Percentage'){
                    TaxOnBillAmount = (tamount* federalTax)/100;
                }else{
                    TaxOnBillAmount = tamount + federalTax;
                }               
                if(stateTaxType == 'Percentage'){
                    TaxOnBillAmount = (TaxOnBillAmount + (tamount * stateTax)/100);
                }else{
                    TaxOnBillAmount = (TaxOnBillAmount + (tamount + stateTax));
                }        
                srecord.Tax_Amount__c = TaxOnBillAmount;
                srecord.Tax__c = federalTax+stateTax;
            system.debug('TaxOnBillAmount::'+TaxOnBillAmount);
            TotalAmount=tamount+TaxOnBillAmount;
            
            system.debug('TotalAmount::'+TotalAmount);
            srecord.sigmaerpdev2__TotalAmount__c=TotalAmount;
        update srecord;
        system.debug('srecord::'+srecord);
        }
         catch(Exception ex)
        {
            createErrorLog.insertError('WoPayment',ex.getMessage(),'Method -orderRecords ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
        } 
        
        return srecord;   
       
    } 
     
}