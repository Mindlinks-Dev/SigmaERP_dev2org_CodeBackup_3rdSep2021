public with sharing class TriggerHelper {
public static void UpdateAvaliableQty(Map<id,Inventory_Consumption__c> newMap,Map<id,Inventory_Consumption__c> oldMap)
{
              
    Map<Id,Decimal> ilpliIdQuantCount=new Map<Id,Decimal>();
        List<Id>lisOfIlp= new List<Id>();
   if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')&&
      CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')&&
      CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Consumption__c')&&
      CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')&&

     CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new set<String>{'id','name','sigmaerpdev__Used_Quantity__c','sigmaerpdev__Reserved_Quantity__c' ,'sigmaerpdev__Inventory_Location_Product__c' }) &&
     CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new set<String>{'id','name','sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Reserved_Quantity__c','sigmaerpdev__Inventory__c'})&&
     CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new set<String>{'id','name','sigmaerpdev__Available_Qty__c','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__Delivered_Qty__c'})&&
     CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Consumption__c',new set<String>{'sigmaerpdev__Reserve_Quantity__c'})&&
      
      CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new set<String>{'sigmaerpdev__Reserved_Quantity__c'})&&
     CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new set<String>{'sigmaerpdev__Reserved_Quantity__c'})&&
      CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new set<String>{'sigmaerpdev__Reserved_Qty__c','sigmaerpdev__Available_Qty__c'})
           ){
      
   
    
        for(Id key:newMap.keyset())
        {
        
         
            if(newMap.get(key).Reserve_Quantity__c!=oldMap.get(key).Reserve_Quantity__c)
            {
                if(ilpliIdQuantCount.containsKey(newMap.get(key).Inventory_Location_Product_Line_Item__c))
                {
                    Decimal qunat=newMap.get(key).Reserve_Quantity__c-oldMap.get(key).Reserve_Quantity__c+oldMap.get(key).Reserve_Quantity__c;
                  
                    ilpliIdQuantCount.put(newMap.get(key).Inventory_Location_Product_Line_Item__c,ilpliIdQuantCount.get(newMap.get(key).Inventory_Location_Product_Line_Item__c)+qunat);
                }
                else
                {
                    Decimal qunat=newMap.get(key).Reserve_Quantity__c-oldMap.get(key).Reserve_Quantity__c;
                    
                    ilpliIdQuantCount.put(newMap.get(key).Inventory_Location_Product_Line_Item__c,qunat);
                }
            
        List<Inventory_Location_Product_Line_Item__c>ilpliList=[select id,name,Used_Quantity__c,Reserved_Quantity__c ,Inventory_Location_Product__c  from Inventory_Location_Product_Line_Item__c where id=:ilpliIdQuantCount.keyset()];
        List<Inventory_Location_Product_Line_Item__c>ilpliListNew=new List<Inventory_Location_Product_Line_Item__c>();
               
   
                for(Inventory_Location_Product_Line_Item__c ilpli:ilpliList){
                ilpli.Reserved_Quantity__c+=ilpliIdQuantCount.get(ilpli.id);
         ilpliListNew.add(ilpli);
         lisOfIlp.add(ilpli.Inventory_Location_Product__c);
                }
         update ilpliList;
         
        
        
                
        Map<Id,Decimal> ilpidQuantCount=new Map<Id,Decimal>();
        List<Id>lisOfpi= new List<Id>();
        for(Inventory_Location_Product_Line_Item__c ilpli:ilpliList)
        {
            if(ilpidQuantCount.containsKey(ilpli.Inventory_Location_Product__c))
                {
                   
                    ilpidQuantCount.put(ilpli.Inventory_Location_Product__c,ilpidQuantCount.get(ilpli.Inventory_Location_Product__c)+ilpliIdQuantCount.get(ilpli.id));
                }
                else
                {
                   ilpidQuantCount.put(ilpli.Inventory_Location_Product__c,ilpliIdQuantCount.get(ilpli.id));
                }
             }   
      
        
   
      List<Inventory_Location_Product__c> listOfIlplNew=[select id,name,Delivered_Quantity__c,Reserved_Quantity__c,Inventory__c from  Inventory_Location_Product__c where id=:lisOfIlp];
      List<Inventory_Location_Product__c>listOfIlplNew1=new List<Inventory_Location_Product__c>();
        for(Inventory_Location_Product__c ilp:listOfIlplNew){
     ilp.Reserved_Quantity__c +=ilpidQuantCount.get(ilp.id);
    listOfIlplNew1.add(ilp);
    lisOfpi.add(ilp.Inventory__c);
    }
    update listOfIlplNew;
    
    Map<Id,Decimal> piidQuantCount=new Map<Id,Decimal>();
            List<Id>proIds=new List<Id>();
    
    
  
  
     
 
     for(Inventory_Location_Product__c ilp:listOfIlplNew)
     {
     if(piidQuantCount.containsKey(ilp.Inventory__c))
                {
                   
                    piidQuantCount.put(ilp.Inventory__c,piidQuantCount.get(ilp.Inventory__c)+ilpidQuantCount.get(ilp.id));
                }
                else
                {
                   piidQuantCount.put(ilp.Inventory__c,ilpidQuantCount.get(ilp.id));
                }
             }   
             
    List<Inventory__c> pis=[select id,name,Available_Qty__c,Reserved_Qty__c,Delivered_Qty__c from Inventory__c where  id=:lisOfpi];
     List<Inventory__c> pisnew=new List<Inventory__c>();
     
   
     for(Inventory__c pii:pis){
      pii.Reserved_Qty__c +=piidQuantCount.get(pii.id);
          pii.Available_Qty__c -=piidQuantCount.get(pii.id);
      pisnew.add(pii);
    
      
    }
       update pisnew;
       
     
     }
     }
  }
 
 }
}