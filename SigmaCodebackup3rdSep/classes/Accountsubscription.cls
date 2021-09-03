/*------------------------------------------------------------
Author: <Anuja Tupale>
Company: Mindlinks Solution
Description: Insert Records and Line Items in Account Subscription.

------------------------------------------------------------*/
public with sharing class Accountsubscription {
    
    @AuraEnabled
    public static List<String> getsubscriptionStatus(){
        List<String> options = new List<String>();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Account_Subscription__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Account_Subscription__c',new set<String>{'sigmaerpdev2__Status__c'})
          ){
              Schema.DescribeFieldResult fieldResult = Account_Subscription__c.Status__c.getDescribe();
              options.add('--Select--');
              List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
              for (Schema.PicklistEntry f: ple) {
                  options.add(f.getLabel());
              }
          }
        return options;
    }
    @AuraEnabled
    public static List<String> getsubscriptionduration(){
        List<String> options = new List<String>();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Account_Subscription__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Account_Subscription__c',new set<String>{'sigmaerpdev2__Subscription_Duration__c'})
          ){ 
              Schema.DescribeFieldResult fieldResult = Account_Subscription__c.Subscription_Duration__c.getDescribe();
              options.add('--Select--');
              List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
              for (Schema.PicklistEntry f: ple) {
                  options.add(f.getLabel());
              }
          }
        return options;
    }
    
    @AuraEnabled
    public static List<String> getBillingfrequency(){
        List<String> options = new List<String>();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Account_Subscription__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Account_Subscription__c',new set<String>{'sigmaerpdev2__Billing_Frequency__c'})
          ){
              Schema.DescribeFieldResult fieldResult = Account_Subscription__c.Billing_Frequency__c.getDescribe();
              options.add('--Select--');
              List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
              for (Schema.PicklistEntry f: ple) {
                  options.add(f.getLabel());
              }
          }
        return options;
    }
    @AuraEnabled
    public static List<String> getsubscriptionTier(){
        List<String> options = new List<String>();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Account_Subscription__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Account_Subscription__c',new set<String>{'sigmaerpdev2__Subscription_Tier__c'})
          ){
              Schema.DescribeFieldResult fieldResult = Account_Subscription__c.Subscription_Tier__c.getDescribe();
              options.add('--Select--');
              List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
              for (Schema.PicklistEntry f: ple) {
                  options.add(f.getLabel());
              }
          }
        
        return options;
    }
    
    
    @AuraEnabled
    public static Subscription_Line_Item__c getsubscriptionDetails(String subname)
    {
        Subscription_Line_Item__c sub;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Subscription_Line_Item__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Subscription_Line_Item__c',new set<String>{'Id','Name','sigmaerpdev2__Subscription_Duration__c','sigmaerpdev2__Subscription__c','sigmaerpdev2__Subscription__r.sigmaerpdev2__Subscription_Tier__c','sigmaerpdev2__Total_charges__c'}))
        {
            sub=[Select Id,Name,Subscription_Duration__c,Subscription__c,Subscription__r.Subscription_Tier__c,Total_charges__c From Subscription_Line_Item__c where Id=:subname ];
            
        }
        return sub;
    }
    @AuraEnabled
    public static Account_Subscription__c saveAccsub(Account_Subscription__c Accsub,Decimal interval,Decimal frequency,Id recid,String subenddate)
    {
        system.debug('subenddate'+subenddate);
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Account_Subscription__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Subscription_Line_Item__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Account_Subscription_Intervals__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Tax__c')
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Account_Subscription__c',new set<String>{'sigmaerpdev2__End_Date__c','sigmaerpdev2__Previous_Start_Date__c','sigmaerpdev2__Previous_End_Date__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__Extend_Start_Date__c','sigmaerpdev2__Extend_End_Date__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Account_Subscription__c',new set<String>{'Id','Name','sigmaerpdev2__Subscription_Total_Amount__c','sigmaerpdev2__Subscription_Line_Item__c','sigmaerpdev2__Subscription_Line_Item__r.Name','sigmaerpdev2__Account__c','sigmaerpdev2__Total_Intervel__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Status__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Tax__c',new set<String>{ 'sigmaerpdev2__Tax_Amount__c','sigmaerpdev2__Type__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Subscription_Line_Item__c',new set<String>{ 'sigmaerpdev2__Usage_Type__c','Id','Name','sigmaerpdev2__Subscription__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Account_Subscription_Intervals__c',new set<String>{'sigmaerpdev2__Usage_Type__c','sigmaerpdev2__Next_Billing_Date__c','sigmaerpdev2__Account_Subscription__c','sigmaerpdev2__Payment_Status__c','sigmaerpdev2__Customer__c','sigmaerpdev2__next_Billing_Amount__c','sigmaerpdev2__Product_Name__c','sigmaerpdev2__Quantity__c'})
          )
        {
            try{
                if(recid==null)
                {
                    Accsub.End_Date__c=date.valueOf(subenddate);
                    insert Accsub;   
                    
                }else
                {
                    if(Accsub.Extend_Start_Date__c!=null)
                    {
                        Account_Subscription__c sub=new Account_Subscription__c();
                        sub=Accsub;
                        sub.Previous_Start_Date__c=Accsub.Start_Date__c;
                        sub.Previous_End_Date__c=Accsub.End_Date__c;
                        sub.Start_Date__c=Accsub.Extend_Start_Date__c;
                        sub.End_Date__c=date.valueOf(subenddate);
                        sub.Extend_Start_Date__c=null;
                        sub.Extend_End_Date__c=null;
                        
                        update sub; 
                    }
                    else
                    {
                        update Accsub;
                    }
                    
                }
                Account_Subscription__c accsubrec;
                accsubrec=[Select Id,Name,Subscription_Total_Amount__c,Subscription_Line_Item__c,Subscription_Line_Item__r.Name,Account__c,Total_Intervel__c,Start_Date__c,End_Date__c,Status__c From Account_Subscription__c where Id=: Accsub.Id];
                
                Subscription_Line_Item__c sub;
                sub=[Select Id,Name,Subscription__c,Product__c,Quantity__c,Usage_Type__c From Subscription_Line_Item__c where Name=: accsubrec.Subscription_Line_Item__r.Name];
                Integer intervals=Integer.valueof(frequency);
                List<Account_Subscription_Intervals__c> accintervals=new List<Account_Subscription_Intervals__c>();
                Double TaxOnBillAmount = 0; 
                for(integer i=0;i<interval;i++)
                {
                    if(accsubrec.Status__c=='Active')
                    {
                        Account_Subscription_Intervals__c accsubs=new Account_Subscription_Intervals__c();
                        accsubs.Next_Billing_Date__c=accsubrec.Start_Date__c;//add month to start date
                        accsubs.Account_Subscription__c=Accsub.Id;
                        accsubs.Payment_Status__c='Not Paid';
                        accsubs.Order_Status__c='Not Created';
                        accsubs.Customer__c=accsubrec.Account__c;
                        accsubs.next_Billing_Amount__c=accsubrec.Subscription_Total_Amount__c;
                        accsubs.Product_Name__c=sub.Product__c;
                        if(sub.Usage_Type__c!=null)
                        {
                            accsubs.Usage_Type__c=sub.Usage_Type__c;
                        }
                        if(sub.Quantity__c!=null)
                        {
                            accsubs.Quantity__c=sub.Quantity__c;
                        }
                        accsubrec.Start_Date__c=accsubs.Next_Billing_Date__c.addmonths(intervals);
                       // if(sub.Usage_Type__c=='' || sub.Usage_Type__c==null || sub.Usage_Type__c=='Service')
                       // {
                            List<Tax__c> taxObj = TaxCntr.getTax(accsubrec.Account__c);
                            Double federalTax = Double.valueOf(taxObj.get(0).Tax_Amount__c);
                            String fedTaxType = String.valueOf(taxObj.get(0).Type__c);
                            
                            Double stateTax = Double.valueOf(taxObj.get(1).Tax_Amount__c);
                            String stateTaxType = String.valueOf(taxObj.get(1).Type__c);
                            
                            if(fedTaxType == 'Percentage'){
                                TaxOnBillAmount = (accsubs.next_Billing_Amount__c * federalTax)/100;
                            }else{
                                TaxOnBillAmount = accsubs.next_Billing_Amount__c + federalTax;
                            }               
                            
                            if(stateTaxType == 'Percentage'){
                                TaxOnBillAmount = (TaxOnBillAmount + (accsubs.next_Billing_Amount__c * stateTax)/100);
                            }else{
                                TaxOnBillAmount = (TaxOnBillAmount + (accsubs.next_Billing_Amount__c + stateTax));
                            }        
                            accsubs.Tax_Amount__c = TaxOnBillAmount;
                            accsubs.Tax__c = federalTax+stateTax;
                            accsubs.Amount__c = accsubs.next_Billing_Amount__c + accsubs.Tax_Amount__c;
                       // }
                        accintervals.add(accsubs);
                    }
                }
                insert accintervals; 
                system.debug('accintervals??'+accintervals);
            }
            catch(Exception ex)
            {
                createErrorLog.insertError('Accountsubscription',ex.getMessage(),'Method -saveAccsub ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
            }
        }
        
        System.debug('Accsub::'+Accsub);
        return Accsub;
    }  
    @AuraEnabled
    public static Account_Subscription__c getAccsub(Id recid)
    {
        system.debug('recid>>>'+recid);
        Account_Subscription__c accsub;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Account_Subscription__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Account_Subscription__c',new set<String>{'Id','Name','sigmaerpdev2__Subscription_Total_Amount__c','sigmaerpdev2__Product_Name__c','sigmaerpdev2__Amount__c','sigmaerpdev2__Subscription_Line_Item__r.sigmaerpdev2__Subscription__r.sigmaerpdev2__Subscription_Tier__c','sigmaerpdev2__Subscription_Line_Item__c','sigmaerpdev2__Subscription_Line_Item__r.sigmaerpdev2__Usage_Type__c','sigmaerpdev2__Subscription_Line_Item__r.Id','sigmaerpdev2__Subscription_Line_Item__r.Name','sigmaerpdev2__Account__c','sigmaerpdev2__Account__r.Name','sigmaerpdev2__Billing_Frequency__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Subscribe_Date__c','sigmaerpdev2__Discount__c','sigmaerpdev2__Status__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Owned_Subscription_Duration__c','sigmaerpdev2__Subscription_Duration__c'}))
        {
             accsub=[Select Id,Name,Subscription_Total_Amount__c,Product_Name__c,Amount__c,Subscription_Line_Item__r.Subscription__r.Subscription_Tier__c,Subscription_Line_Item__c,Subscription_Line_Item__r.Id,Subscription_Line_Item__r.Name,Subscription_Line_Item__r.Usage_Type__c,Account__c,Account__r.Name,Billing_Frequency__c,Start_Date__c,End_Date__c,Subscribe_Date__c,Discount__c,Status__c,Unit_Price__c,Owned_Subscription_Duration__c,Subscription_Duration__c From Account_Subscription__c where Id=: recid];
            
        }
        return accsub;
    }
    @AuraEnabled
    public static  List<Account_Subscription__c> updateAccount(List<Account_Subscription__c> Accsub,Decimal interval,Decimal frequency,Id recid,string subenddate)
    {
        system.debug('Accsub>>>>'+Accsub);
        Account_Subscription__c accsubrec1;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Account_Subscription__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Subscription_Line_Item__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__SubscriptionDetail__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Account_Subscription_Intervals__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Account_Subscription__c',new set<String>{'sigmaerpdev2__Subscription_Tier__c','Id','Name','sigmaerpdev2__Subscription_Total_Amount__c','sigmaerpdev2__SubscriptionDetail__c','sigmaerpdev2__SubscriptionDetail__r.Name','sigmaerpdev2__Account__c','sigmaerpdev2__Total_Intervel__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Subscription_Tier__c','sigmaerpdev2__Status__c','sigmaerpdev2__Subscription_Line_Item__c','sigmaerpdev2__Subscription_Line_Item__r.Name'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Account_Subscription__c',new set<String>{'sigmaerpdev2__Status__c','sigmaerpdev2__End_Date__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Subscription_Line_Item__c',new set<String>{'Id','Name','sigmaerpdev2__Subscription__c','sigmaerpdev2__Subscription__r.Name','sigmaerpdev2__Product__c','sigmaerpdev2__Usage_Type__c','sigmaerpdev2__Quantity__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__SubscriptionDetail__c',new set<String>{'Id','Name','sigmaerpdev2__Subscription_Name__c','sigmaerpdev2__Product__c','sigmaerpdev2__Subscription_Tier__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__SubscriptionDetail__c',new set<String>{'sigmaerpdev2__Subscription_Tier__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Account_Subscription_Intervals__c',new set<String>{'sigmaerpdev2__Next_Billing_Date__c','sigmaerpdev2__Account_Subscription__c','sigmaerpdev2__Payment_Status__c','sigmaerpdev2__Customer__c','sigmaerpdev2__next_Billing_Amount__c','sigmaerpdev2__Usage_Type__c'}))
        {
            try{
                accsubrec1=[Select Id,Name,Subscription_Total_Amount__c,SubscriptionDetail__c,SubscriptionDetail__r.Name,Account__c,Total_Intervel__c,Start_Date__c,End_Date__c,Subscription_Tier__c,Status__c From Account_Subscription__c where Id=: recid];
                
                //List<Account_Subscription__c>Accsublist = new List<Account_Subscription__c>();
                accsubrec1.Status__c='InActive';
                update accsubrec1;
                
                if(recid!=null)
                {
                    for(Account_Subscription__c actsub:Accsub){
                          actsub.End_Date__c=date.valueOf(subenddate);
                    }
                  
                    insert Accsub;
                   
                   //added by rashmi to solve Bulkify issue 11-05 
                   /* Accsublist.add(Accsub);
                    if(Accsublist.size()>0)
                    {
                        insert Accsublist;
                    }*/
               }
                Account_Subscription__c accsubrec;
                accsubrec=[Select Id,Name,Subscription_Total_Amount__c,Subscription_Tier__c,Subscription_Line_Item__c,Subscription_Line_Item__r.Name,Account__c,Total_Intervel__c,Start_Date__c,End_Date__c,Status__c From Account_Subscription__c where Id=: Accsub[0].Id];
                Subscription_Line_Item__c sub1;
                sub1=[Select Id,Name,Product__c,Usage_Type__c,Quantity__c,Subscription__c,Subscription__r.Name From Subscription_Line_Item__c where Name=: accsubrec.Subscription_Line_Item__r.Name];
                
                SubscriptionDetail__c sub;
                sub=[Select Id,Name,Subscription_Name__c,Product__c,Subscription_Tier__c From SubscriptionDetail__c where Name=: sub1.Subscription__r.Name];
                
                sub.Subscription_Tier__c=accsubrec.Subscription_Tier__c;
                update sub;
                
                Integer intervals=Integer.valueof(frequency);
                
                List<Account_Subscription_Intervals__c> accintervals=new List<Account_Subscription_Intervals__c>();
                Double TaxOnBillAmount = 0;
                for(integer i=0;i<interval;i++)
                {
                    if(accsubrec.Status__c=='Active')
                    {
                        Account_Subscription_Intervals__c accsubs=new Account_Subscription_Intervals__c();
                        accsubs.Next_Billing_Date__c=accsubrec.Start_Date__c;//add month to start date
                        accsubs.Account_Subscription__c=Accsub[0].Id;
                        accsubs.Payment_Status__c='Not Paid';
                        accsubs.Order_Status__c='Not Created';
                        accsubs.Customer__c=accsubrec.Account__c;
                        accsubs.Product_Name__c=sub1.Product__c;
                        if(sub1.Usage_Type__c!=null)
                        {
                            accsubs.Usage_Type__c=sub1.Usage_Type__c;
                        }
                        if(sub1.Quantity__c!=null)
                        {
                            accsubs.Quantity__c=sub1.Quantity__c;
                        }
                        accsubs.next_Billing_Amount__c=accsubrec.Subscription_Total_Amount__c;
                        accsubrec.Start_Date__c = accsubs.Next_Billing_Date__c.addmonths(intervals);
                         if(sub1.Usage_Type__c=='' || sub1.Usage_Type__c==null || sub1.Usage_Type__c=='Service')
                        {
                            List<Tax__c> taxObj = TaxCntr.getTax(accsubrec.Account__c);
                            Double federalTax = Double.valueOf(taxObj.get(0).Tax_Amount__c);
                            String fedTaxType = String.valueOf(taxObj.get(0).Type__c);
                            
                            Double stateTax = Double.valueOf(taxObj.get(1).Tax_Amount__c);
                            String stateTaxType = String.valueOf(taxObj.get(1).Type__c);
                            
                            if(fedTaxType == 'Percentage'){
                                TaxOnBillAmount = (accsubs.next_Billing_Amount__c * federalTax)/100;
                            }else{
                                TaxOnBillAmount = accsubs.next_Billing_Amount__c + federalTax;
                            }               
                            
                            if(stateTaxType == 'Percentage'){
                                TaxOnBillAmount = (TaxOnBillAmount + (accsubs.next_Billing_Amount__c * stateTax)/100);
                            }else{
                                TaxOnBillAmount = (TaxOnBillAmount + (accsubs.next_Billing_Amount__c + stateTax));
                            }        
                            accsubs.Tax_Amount__c = TaxOnBillAmount;
                            accsubs.Tax__c = federalTax+stateTax;
                            accsubs.Amount__c = accsubs.next_Billing_Amount__c + accsubs.Tax_Amount__c;
                        }
                        accintervals.add(accsubs);
                    }
                }
                insert accintervals;
                
                return Accsub;
            } catch(Exception ex)
            {
                createErrorLog.insertError('Accountsubscription',ex.getMessage(),'Method -UpdateAccount ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
            }  
        }
        system.debug('Accsub>>>'+Accsub);
        return Accsub;
    }
    //new code for Subscription payment by chandana 
    @AuraEnabled
    public static Account_Subscription_Intervals__c subintervelRecords(id Ids)
    {
        Account_Subscription_Intervals__c srecord;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Account_Subscription_Intervals__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Account_Subscription_Intervals__c',new set<String>{'id' ,'name','sigmaerpdev2__Paid_Amount__c','sigmaerpdev2__Due_Amount__c','sigmaerpdev2__Usage_Type__c','sigmaerpdev2__next_Billing_Amount__c','sigmaerpdev2__Amount__c','sigmaerpdev2__Payment_Status__c','sigmaerpdev2__Subscription_Name__c','sigmaerpdev2__Account_Subscription__r.sigmaerpdev2__Status__c','sigmaerpdev2__Account_Subscription__r.id','sigmaerpdev2__Account_Subscription__r.Name','sigmaerpdev2__Customer__r.id','sigmaerpdev2__Customer__r.name'}))
        {
            srecord = new Account_Subscription_Intervals__c();
            
            srecord = [select id ,name,Paid_Amount__c ,next_Billing_Amount__c,Due_Amount__c,Usage_Type__c,Payment_Status__c,Subscription_Name__c,Account_Subscription__r.id,Account_Subscription__r.Name,Account_Subscription__r.Status__c,Order_Status__c,Customer__r.id,Customer__r.name,Amount__c from Account_Subscription_Intervals__c  where id=:ids]; 
            
        }
        return srecord;    
    }
    //added by sandhya
    @AuraEnabled
    public Static Order_API__c  orderAPI(){
        
        Order_API__c OrderAPi = new Order_API__c();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Order_API__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Order_API__c',new set<String>{'sigmaerpdev2__Subscription_Product__c','sigmaerpdev2__Subscription_Renewal__c'})
          ){
              OrderAPi = [Select Subscription_Product__c,Subscription_Renewal__c from Order_API__c limit 1];
         
            }
        return OrderAPi;
    }
    
    
    @AuraEnabled
    public Static customWrapperList  OrderValid(){
        
        customWrapperList cuwrapp = new customWrapperList();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Order_Usage__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Order_API__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Time_Base_Inventory__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Order_Usage__c',new set<String>{'sigmaerpdev2__Sigma_order__c','sigmaerpdev2__Standard_object__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Time_Base_Inventory__c',new set<String>{'sigmaerpdev2__Order__c','sigmaerpdev2__Proposal__c','sigmaerpdev2__Proposal_for_Products__c','sigmaerpdev2__Proposal_to_Order__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Order_API__c',new set<String>{'sigmaerpdev2__Subscription_Product__c','sigmaerpdev2__Subscription_Renewal__c'})
          ){
              cuwrapp.ou = [Select Sigma_order__c,Standard_object__c from Order_Usage__c limit 1];
              cuwrapp.tmi = [Select Order__c,Proposal__c,Proposal_for_Products__c,Proposal_to_Order__c from Time_Base_Inventory__c limit 1];
              cuwrapp.OP =[select Subscription_Product__c,Subscription_Renewal__c from Order_API__c limit 1] ; 
          
            }
        return cuwrapp;
        
    }
    
    public class customWrapperList{
        
        @AuraEnabled
        public Order_Usage__c ou{get;set;}
        @AuraEnabled        
        public Time_Base_Inventory__c tmi{get;set;}
        @AuraEnabled 
        public Order_API__c OP{get;set;}
    }
    
}