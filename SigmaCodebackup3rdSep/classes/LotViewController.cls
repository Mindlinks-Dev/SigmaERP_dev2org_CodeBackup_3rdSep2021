public with sharing class LotViewController
{

@AuraEnabled
public static  List<wrapperClass>  getLotData(String productId,String lotId)
{
  System.debug('ProductID>>>'+productId);
  System.debug('LotID>>>'+lotId);
   
   List<wrapperClass> wrapList;
   
/*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot_Product__c',new Set<String>{'id','Name','sigmaerpdev2__Lot__c','sigmaerpdev2__Lot__r.Name','sigmaerpdev2__Product__c','sigmaerpdev2__Location__c','sigmaerpdev2__Product__r.name','sigmaerpdev2__Location__r.Name','sigmaerpdev2__Quantity__c'}) 
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'Id','Name','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Products__c,sigmaerpdev2__Products__r.Name','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Delivered_Quantity__c','sigmaerpdev2__Inventory_Location__c'}))
{*/
   
   
    System.debug('I am inside FLS:');
    System.debug('LOT::'+lotId);
    System.debug('ProductID:'+productId);
   
   
   
   List<Lot_Product__c> LotProduct =[select id,Name,Lot__c,Lot__r.Name,Product__c,Location__c,Product__r.name,Location__r.Name,Quantity__c from Lot_Product__c where Lot__c =:lotId /*and Product__c=:productId*/];
   System.debug('LotProduct->'+LotProduct);
   
   
   Map<Id,Lot_Product__c> mapref=new Map<Id,Lot_Product__c>();
   
   List<Id> loc=new List<Id>();
   List<Id> prod=new List<Id>();
   for(Lot_Product__c ref:LotProduct)
   {
       system.debug('------->'+ref.Location__c);
      
       mapref.put(ref.Location__c,ref);
       loc.add(ref.Location__c);
       prod.add(ref.Product__c);
       
   }
   
   
   System.debug('product Id map->'+mapref.keyset());
   //System.debug('values->'+mapref.values().Product__c);
   System.debug('loc->'+loc);
   System.debug('loc->'+prod);
   
   
   
  List<Inventory_Location_Product__c> ILp =[select id,Name,Received_Quantity__c,Products__c,Products__r.Name,Net_Quantity__c,Delivered_Quantity__c,Inventory_Location__c from Inventory_Location_Product__c where Inventory_Location__c=:loc and Products__c=:prod];
  
  
  System.debug('ILp-->'+ILp);
  
  
 
  
   wrapList=new List<WrapperClass>();
  
  for(Inventory_Location_Product__c ILpref:ILp)
  {
     wrapperClass wrap=new wrapperClass();
     
    if(mapref.containsKey(ILpref.Inventory_Location__c))
    {
          
        wrap.Lot=mapref.get(ILpref.Inventory_Location__c).Lot__r.Name;
        wrap.productName=mapref.get(ILpref.Inventory_Location__c).Product__r.Name;
        wrap.ReceivedQuantity=ILpref.Received_Quantity__c;
        wrap.AvailableQuantity=ILpref.Net_Quantity__c;
        wrap.InventoryLocation=mapref.get(ILpref.Inventory_Location__c).Location__r.Name;
        wrap.DeliveredQuantity=ILpref.Delivered_Quantity__c;
        wrapList.add(wrap);
          
    }
       
  }
  
  System.debug('wrapList->'+wrapList);       
//}

return wrapList;
}




@AuraEnabled
public static  List<wrapperIlp>  getILP(String productId,String lotId)
{
   
    System.debug('ProductName'+productId);
    System.debug('LotNumber'+lotId);
    List<wrapperIlp> wrapIlpList;
   
/*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot_Product__c',new Set<String>{'id','Name','sigmaerpdev2__Lot__c','sigmaerpdev2__Lot__r.Name','sigmaerpdev2__Product__c','sigmaerpdev2__Location__c','sigmaerpdev2__Product__r.name','sigmaerpdev2__Quantity__c'}) 
&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'Id','Name','sigmaerpdev2__Inventory_Location__r.Name','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Products__c','sigmaerpdev2__Products__r.Name','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Inventory_Location_Name__c','sigmaerpdev2__Delivered_Quantity__c','sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Inventory__r.Name','sigmaerpdev2__Inventory_Location__c'}))
{*/
           
      
   System.debug('I am inside FLS:');
   
    System.debug('I am inside Loc'+lotId);
    System.debug('I am product:'+productId);
   
   List<Lot_Product__c> LotProduct =[select id,Name,Lot__c,Lot__r.Name,Product__c,Location__c,Product__r.name,Quantity__c from Lot_Product__c where Lot__c =:lotId /*and Product__c=:productId*/];
   System.debug('LotProduct->'+LotProduct);
   
   
   
   Map<Id,Lot_Product__c> mapref=new Map<Id,Lot_Product__c>();
   List<Id> loc=new List<Id>();
   List<Id> prod=new List<Id>();
   
   for(Lot_Product__c ref:LotProduct)
   {
      
       mapref.put(ref.Location__c,ref);
       loc.add(ref.Location__c);
       prod.add(ref.Product__c);
       
   }
   
   
   System.debug('product Id map->'+mapref);
   System.debug('loc->'+loc);
   System.debug('prod->'+mapref);
   
   
   
   
   List<Inventory_Location_Product__c> ILp =[select id,Name,Inventory_Location__r.Name,Received_Quantity__c,Products__c,Products__r.Name,Net_Quantity__c,Inventory_Location_Name__c,Delivered_Quantity__c,Attribute_Type__c,Inventory__r.Name,Inventory_Location__c from Inventory_Location_Product__c where Inventory_Location__c=:loc and Products__c=:prod];
  
  
   System.debug('ILp-->'+ILp);
   
   wrapIlpList=new List<wrapperIlp>();
   
    for(Inventory_Location_Product__c ILpref:ILp)
    {
     wrapperIlp wrapIlp=new wrapperIlp();
     
     wrapIlp.InventoryLocProdNumber=ILpref.Name;
     wrapIlp.InventoryLocation=ILpref.Inventory_Location__r.Name;
     wrapIlp.InventoryLocationName=ILpref.Inventory_Location_Name__c;
     wrapIlp.productName=ILpref.Products__r.Name;
     wrapIlp.Inventory=ILpref.Inventory__r.Name;
     wrapIlp.AttributeType=ILpref.Attribute_Type__c;
     wrapIlp.AvailableQuantity=ILpref.Net_Quantity__c;
     wrapIlp.DeliveredQuantity=ILpref.Delivered_Quantity__c;
     wrapIlp.ReceivedQuantity=ILpref.Received_Quantity__c;
   
     wrapIlpList.add(wrapIlp);
   
   
   
    }
    
    
    System.debug('wrapIlpList-->'+wrapIlpList);
//}
    return wrapIlpList;


}

@AuraEnabled 
public static  List<WrapperShipment>  getShipment(String productId,String lotId)
{
    
    System.debug('productId'+productId);
    System.debug('lotId'+lotId);
    
    
    List<WrapperShipment> wrapShipList;
    
    /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__PackagedProducts__c',new Set<String>{'id','Name','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Quantity__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Package__c','sigmaerpdev2__Lot__r.Name','sigmaerpdev2__Package__r.Name','sigmaerpdev2__Status__c','sigmaerpdev2__Location__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Product_Order__c','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__Package_Date__c'}) 
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Shipment_Products__c',new Set<String>{'id','Name','sigmaerpdev2__Package_ID__c','sigmaerpdev2__Shipment__r.Name','sigmaerpdev2__Shipment__c','sigmaerpdev2__Status__c','sigmaerpdev2__Customer_Name__c','sigmaerpdev2__Customer_Name__r.Name','sigmaerpdev2__Order__c','sigmaerpdev2__Shipment_Delivery_Date__c','sigmaerpdev2__Order_Product__c'}))
    {*/
        try{
            system.debug('insidemethod');
            List<Lot_Product__c> LotProduct =[select id,Name,Lot__c,Lot__r.Name,Product__c,Location__c,Product__r.name,Quantity__c from Lot_Product__c where Lot__c =:lotId /*and Product__c=:productId*/];
         System.debug('LotProduct->'+LotProduct);
   
   
   
   Map<Id,Lot_Product__c> mapref=new Map<Id,Lot_Product__c>();
   List<Id> loc=new List<Id>();
   List<Id> prod=new List<Id>();
   
   for(Lot_Product__c ref:LotProduct)
   {
      
       mapref.put(ref.Location__c,ref);
       loc.add(ref.Location__c);
       prod.add(ref.Product__c);
       
   }
   
   
   System.debug('product Id map->'+mapref);
   System.debug('loc->'+loc);
   System.debug('prod->'+mapref);
            
            List<PackagedProducts__c> pkprod=new List<PackagedProducts__c>();
            
            pkprod=[select id,Name,Product__c,Product__r.Name,Quantity__c,Lot__c,Package__c,Lot__r.Name,Package__r.Name,Status__c,Location__c,Inventory_Location_Product__c,Product_Order__c,Sigma_Order__c,Package_Date__c from PackagedProducts__c where Product__c=:prod and Status__c='Ready'];
            
            System.debug('pkprod-->'+pkprod);
            
            Map<Id,PackagedProducts__c> pprod=new Map<Id,PackagedProducts__c>();
            List<Id> ppId=new List<Id>();
            for(PackagedProducts__c ref:pkprod)
            {
                
                
                pprod.put(ref.Package__c,ref);
                
                
            }
            
            System.debug('pprod-->'+pprod);
            System.debug('pprod key-->'+pprod.keySet());
            
         
            List<Shipment_Products__c>  shipList=new List<Shipment_Products__c>();
         
            shipList=[Select id,Name,Package_ID__c,Shipment__r.Name,Shipment__c,Status__c,Customer_Name__c,Customer_Name__r.Name,Order__c,Shipment__r.Shipment_Date__c,Order_Product__c from Shipment_Products__c where Status__c ='Delivered' and Package_ID__c=:pprod.keySet()];
          
            
            System.debug('shipList-->'+shipList[0].Shipment__r.Shipment_Date__c);
         
            Map<Id,Shipment_Products__c> ShipMap=new Map<Id,Shipment_Products__c>();
         
         
         
            for(Shipment_Products__c refObj:shipList)
            {
             ShipMap.put(refObj.Package_ID__c,refObj);
            }
            system.debug('ShipMap-->'+ShipMap);
         
           wrapShipList=new List<WrapperShipment>();
         
            for(Shipment_Products__c ob:shipList)
            {
                WrapperShipment wrapShip=new WrapperShipment();
             
                if(pprod.ContainsKey(ob.Package_ID__c))
                {
                
                 System.debug('-->'+pprod.ContainsKey(ob.Package_ID__c));
                 wrapShip.ProductName=pprod.get(ob.Package_ID__c).Product__r.Name;
                 System.debug('prod Name-->'+wrapShip.ProductName);
                 wrapShip.Lot=pprod.get(ob.Package_ID__c).Lot__r.Name;
                 System.debug('wrapShip.Lot-->'+wrapShip.Lot);
                 wrapShip.Status=ob.Status__c;
                 wrapShip.Quantity=pprod.get(ob.Package_ID__c).Quantity__c;
                 wrapShip.PackageID=pprod.get(ob.Package_ID__c).Package__r.Name;
                 wrapShip.ShipmentProductName=ob.Name;
                 wrapShip.CustomerName=ob.Customer_Name__r.Name;
                 wrapShip.ShipmentDeliveryDate=ob.Shipment__r.Shipment_Date__c;
                 wrapShip.Shipment=ob.Shipment__r.Name;
                 
                 wrapShipList.add(wrapShip);
                 System.debug('wrapShipList inner-->'+wrapShipList);
                }
            }
         
         System.debug('wrapShipList-->'+wrapShipList);
          return wrapShipList;
    }
    catch(Exception e)
    {
        system.debug('do nothing');
         return null;
    }
    
//}
 //return wrapShipList;

}





public class wrapperClass
{
     
    @AuraEnabled public String Lot{get;set;}
    @AuraEnabled public String productName{get;set;}
    @AuraEnabled public String InventoryLocation{get;set;}
    @AuraEnabled public Decimal AvailableQuantity{get;set;}
    @AuraEnabled public Decimal DeliveredQuantity{get;set;}
    @AuraEnabled public Decimal ReceivedQuantity{get;set;}
    
}


public class wrapperIlp
{
    @AuraEnabled public String InventoryLocProdNumber{get;set;}
    @AuraEnabled public String InventoryLocation{get;set;}
    @AuraEnabled public String InventoryLocationName{get;set;}
    @AuraEnabled public String productName{get;set;}
    @AuraEnabled public String Inventory{get;set;}
    @AuraEnabled public String AttributeType{get;set;}
    @AuraEnabled public Decimal AvailableQuantity{get;set;}
    @AuraEnabled public Decimal DeliveredQuantity{get;set;}
    @AuraEnabled public Decimal ReceivedQuantity{get;set;}
    
}

public class WrapperShipment
{
    @AuraEnabled public String ProductName{get;set;}
    @AuraEnabled public String Lot{get;set;}
    @AuraEnabled public String Status{get;set;}
    @AuraEnabled public Decimal Quantity{get;set;}
    @AuraEnabled public String PackageID{get;set;}
    @AuraEnabled public String ShipmentProductName{get;set;}
    @AuraEnabled public String CustomerName{get;set;}
    @AuraEnabled public Date ShipmentDeliveryDate{get;set;}
    @AuraEnabled public String Shipment{get;set;}
    
}

}