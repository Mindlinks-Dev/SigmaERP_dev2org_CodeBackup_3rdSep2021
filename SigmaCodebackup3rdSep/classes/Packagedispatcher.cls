/*------------------------------------------------------------
Author: <Anuja Tupale>
Company: Mindlinks Solution
Description: Generating Package Slip.

------------------------------------------------------------*/
global with sharing class Packagedispatcher{


public String orderId;
public String Pkname;
public Default_Parameters__c defaultparam{get;set;}
public  Sigma_Order__c orderData{get;set;}
public Package__c Pk{get;set;}
public Order_Usage__c ordertype{get;set;}
 
public Packagedispatcher(ApexPages.StandardController controller) 
{   
    orderId = System.currentPageReference().getParameters().get('id');
     this.getdefault();
     this.getpk();
  
}

 public Default_Parameters__c getdefault()
{
    /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new set<String>{'sigmaerpdev__Company_Name__c','sigmaerpdev__Company_Email__c','sigmaerpdev__Company_Phone__c','sigmaerpdev__Logo__c'})
           )
           {*/
               defaultparam=new Default_Parameters__c();
    defaultparam = [SELECT Company_Name__c,Company_Email__c,Company_Phone__c,Logo__c from Default_Parameters__c Limit 1];
         //  }
      return defaultparam;
}//end of getdefault

 public Package__c getpk()
{
    /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new set<String>{'id','name','sigmaerpdev__Status__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__PackagedDate__c','sigmaerpdev__Sigma_Order__r.Name','sigmaerpdev__Order__c','sigmaerpdev__Order__r.OrderNumber','sigmaerpdev__Customer_Email__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new set<String>{'id','name','sigmaerpdev__Order__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Order__r.Account.sigmaerpdev__Email__c','sigmaerpdev__Order__r.Account.Name','sigmaerpdev__Order__r.sigmaerpdev__Shipping_Street__c','sigmaerpdev__Order__r.sigmaerpdev__ShippingCity__c','sigmaerpdev__Order__r.sigmaerpdev__ShippingState__c','sigmaerpdev__Order__r.sigmaerpdev__ShippingCountry__c','sigmaerpdev__Order__r.sigmaerpdev__ShippingPostalCode__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__AccountId__r.sigmaerpdev__Email__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__AccountId__r.Name','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Shipping_Street__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__ShippingCity__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__ShippingState__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__ShippingCountry__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__ShippingPostalCode__c','sigmaerpdev__Sigma_Order__r.Name','sigmaerpdev__Quantity__c','sigmaerpdev__Product_Order__c','sigmaerpdev__Product_Order__r.sigmaerpdev__Product__r.Name','sigmaerpdev__Package__r.Name','sigmaerpdev__Package__r.sigmaerpdev__Status__c','sigmaerpdev__Product_Order__r.sigmaerpdev__Product__r.sigmaerpdev__Product_Bar_Code__c','sigmaerpdev__Order_Product__c','sigmaerpdev__Order_Product__r.Product2Id','sigmaerpdev__Order_Product__r.Product2.Name','sigmaerpdev__Order_Product__r.Product2.sigmaerpdev__Product_Bar_Code__c'})
           )
           {*/
               Pk=new Package__c();
        Pk=[SELECT id,name,Status__c,Sigma_Order__c,PackagedDate__c,Sigma_Order__r.Name,Order__c,Order__r.OrderNumber,Customer_Email__c,(SELECT id,name,Order__c,Sigma_Order__c,Order__r.Account.Email__c,Order__r.Account.Name,Order__r.Shipping_Street__c,Order__r.ShippingCity__c,Order__r.ShippingState__c,Order__r.ShippingCountry__c,Order__r.ShippingPostalCode__c,Quantity__c,Sigma_Order__r.Name,Sigma_Order__r.AccountId__r.Email__c,Sigma_Order__r.AccountId__r.Name,Sigma_Order__r.Shipping_Street__c,Sigma_Order__r.ShippingCity__c,Sigma_Order__r.ShippingState__c,Sigma_Order__r.ShippingCountry__c,Sigma_Order__r.ShippingPostalCode__c,Product_Order__c,Product_Order__r.Product__r.Name,Product_Order__r.Product__r.Product_Bar_Code__c,Package__r.Name,Package__r.Status__c,Order_Product__c,Order_Product__r.Product2Id,Order_Product__r.Product2.Name,Order_Product__r.Product2.Product_Bar_Code__c from PackagedProducts__r) from Package__c where id=:orderId ];
      //     }   
   return Pk;
}//end of getpk

}