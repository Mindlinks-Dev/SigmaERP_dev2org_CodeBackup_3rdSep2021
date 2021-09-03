/*=========================================================
Created by Sandhya,25-06-2018 for Stripe API Custom Setting
============================================================*/
public with sharing Class StripeAPICustomController 
{
    public Stripe_API__c StripeSetting {get;set;}
    public StripeAPICustomController()
     { 
     if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Stripe_API__c',new set<String>{'Id','Name','sigmaerpdev2__Api_Key__c','sigmaerpdev2__Charge_URL__c','sigmaerpdev2__Customer_URL__c','sigmaerpdev2__Refund_URL__c','sigmaerpdev2__Token_URL__c'})
         ){
         Map<string,Stripe_API__c> StripeMap = Stripe_API__c.getAll();
         if(!(StripeMap.containsKey('Stripe_API')))
        {    
            StripeSetting = new Stripe_API__c();
            StripeSetting.Name = 'Stripe_API';
            
        }else
        {
            StripeSetting =  Stripe_API__c.getValues('Stripe_API');
            
        }
     }
     }
    
    public pagereference saveConfig(){
         if(CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Stripe_API__c',new set<String>{'Name','sigmaerpdev2__Api_Key__c','sigmaerpdev2__Charge_URL__c','sigmaerpdev2__Customer_URL__c','sigmaerpdev2__Refund_URL__c','sigmaerpdev2__Token_URL__c'})
           )
           {

            if(StripeSetting!=null)
            {
                upsert StripeSetting;
            }
           }
        return null;
    }
    public pagereference cancelConfig1(){
        return null;
    }
}