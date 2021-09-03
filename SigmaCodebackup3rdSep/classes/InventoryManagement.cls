public with sharing class InventoryManagement 
{
    public static List<Inventory_Location_Product_Line_Item__c> fetchILPLIDataForManualSelection(Id prodID,Id locId,Id compId)
    {
       List<Inventory_Location_Product_Line_Item__c> ilpliData=new List<Inventory_Location_Product_Line_Item__c>();
       if(
            CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'Id','Name','sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__Received_Date__c','sigmaerpdev2__Product_Expiry_Date__c','sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__r.name','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Products__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c'})
          )
          {
                if(locId!=null)
                    ilpliData=[select id,name,Available_Quantity__c,Received_Date__c,Product_Expiry_Date__c,Reserved_Quantity__c,Inventory_Location_Product__r.Inventory_Location__r.Location__r.name from Inventory_Location_Product_Line_Item__c where Inventory_Location_Product__r.Products__c=:prodID and Inventory_Location_Product__r.Inventory_Location__r.Location__c=:locId and Available_Quantity__c>0 ];
                else
                    ilpliData=[select id,name,Available_Quantity__c,Received_Date__c,Product_Expiry_Date__c,Reserved_Quantity__c,Inventory_Location_Product__r.Inventory_Location__r.Location__r.name from Inventory_Location_Product_Line_Item__c where Inventory_Location_Product__r.Products__c=:prodID and Available_Quantity__c>0  ];
          }
       return ilpliData;
    }
    public static ILPLIDataForAutoPick fetchILPLIDataForAutoPick(Id prodID,Id locId,Id compId)
    {
         ILPLIDataForAutoPick ilpliAutoPick=new ILPLIDataForAutoPick();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'Id','Name','sigmaerpdev2__Received_Date__c','sigmaerpdev2__AvailableAdjustedQty__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Products__r.ProductCode','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__r.name','sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Products__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Products__r.name','sigmaerpdev2__Product_Expiry_Date__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Products__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c','sigmaerpdev2__Product_Expiry_Date__c','sigmaerpdev2__Received_Date__c'})
          )
          {
                List<Inventory_Location_Product_Line_Item__c> ilpliDataExpire=new List<Inventory_Location_Product_Line_Item__c>();
                List<Inventory_Location_Product_Line_Item__c> ilpliDataRecieveData=new List<Inventory_Location_Product_Line_Item__c>();
                if(locId!=null)
                    ilpliDataExpire=[select id,name,Received_Date__c,AvailableAdjustedQty__c,Inventory_Location_Product__r.Products__r.ProductCode,Inventory_Location_Product__r.Inventory_Location__r.Location__r.name,Available_Quantity__c,Reserved_Quantity__c,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.name,Product_Expiry_Date__c from Inventory_Location_Product_Line_Item__c where Inventory_Location_Product__r.Products__c=:prodID and Available_Quantity__c>0 and Inventory_Location_Product__r.Inventory_Location__r.Location__c=:locId and Product_Expiry_Date__c>=TODAY and Product_Expiry_Date__c!=null  ORDER BY Product_Expiry_Date__c ASC];
                else
                    ilpliDataExpire=[select id,name,Received_Date__c,AvailableAdjustedQty__c,Inventory_Location_Product__r.Products__r.ProductCode,Inventory_Location_Product__r.Inventory_Location__r.Location__r.name,Available_Quantity__c,Reserved_Quantity__c,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.name,Product_Expiry_Date__c from Inventory_Location_Product_Line_Item__c where Inventory_Location_Product__r.Products__c=:prodID and Available_Quantity__c>0 and Product_Expiry_Date__c>=TODAY and Product_Expiry_Date__c!=null  ORDER BY Product_Expiry_Date__c ASC];
                
                if(locId!=null)
                    ilpliDataRecieveData=[select id,name,Received_Date__c,AvailableAdjustedQty__c,Inventory_Location_Product__r.Products__r.ProductCode,Inventory_Location_Product__r.Inventory_Location__r.Location__r.name,Available_Quantity__c,Reserved_Quantity__c,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.name,Product_Expiry_Date__c from Inventory_Location_Product_Line_Item__c where Inventory_Location_Product__r.Products__c=:prodID and Available_Quantity__c>0 and Inventory_Location_Product__r.Inventory_Location__r.Location__c=:locId and Product_Expiry_Date__c=null   ORDER BY Received_Date__c ASC];
                else
                    ilpliDataRecieveData=[select id,name,Received_Date__c,AvailableAdjustedQty__c,Inventory_Location_Product__r.Products__r.ProductCode,Inventory_Location_Product__r.Inventory_Location__r.Location__r.name,Available_Quantity__c,Reserved_Quantity__c,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.name,Product_Expiry_Date__c from Inventory_Location_Product_Line_Item__c where Inventory_Location_Product__r.Products__c=:prodID and Available_Quantity__c>0 and Product_Expiry_Date__c=null  ORDER BY Received_Date__c ASC];
               
                 ilpliAutoPick.ilpliOrderByExpiryDate=ilpliDataExpire;
                ilpliAutoPick.ilpliOrderByRecieveDate=ilpliDataRecieveData;
          }
        return ilpliAutoPick;
    }
    public class ILPLIDataForAutoPick
    {
        @auraEnabled
        public List<Inventory_Location_Product_Line_Item__c> ilpliOrderByExpiryDate{get;set;}
        @auraEnabled
        public List<Inventory_Location_Product_Line_Item__c> ilpliOrderByRecieveDate{get;set;}
    }
    public static void reduceWholeInventory(Map<Id,Decimal> ilpliIdQuant,String updating)
    { 
       if(/*CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Order_Usage__c')
            &&*/  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Lot__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Lot_Product__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Serial_Number__c')
            
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Order_Usage__c',new Set<String>{'Id','Name','sigmaerpdev2__Sigma_order__c','sigmaerpdev2__Standard_object__c','sigmaerpdev2__Allocation_in_Sales_Order__c','sigmaerpdev2__Allocation_in_Picking__c','sigmaerpdev2__Auto_Allocate_in_picking__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'Id','Name','sigmaerpdev2__Received_Date__c','sigmaerpdev2__AvailableAdjustedQty__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Products__r.ProductCode','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__r.name','sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Products__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Products__r.name','sigmaerpdev2__Product_Expiry_Date__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Products__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c','sigmaerpdev2__Product_Expiry_Date__c','sigmaerpdev2__Received_Date__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot__c',new Set<String>{'Id','Name'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot_Product__c',new Set<String>{'Id','Name','sigmaerpdev2__Location__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Lot__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Serial_Number__c',new Set<String>{'Id','Name','sigmaerpdev2__Status__c'}) 
            
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Adjusted_Quantity1__c'})      
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Lot_Product__c',new Set<String>{'sigmaerpdev2__Quantity__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Serial_Number__c',new Set<String>{'sigmaerpdev2__Status__c'})
          )
        {
            //Parameter 1- Map is of ILPLI's id and quantity to reduce in that ILPLI, Parameter 1- What to update in ILPLI
            Order_Usage__c OrderType=[select Sigma_order__c,Standard_object__c,Allocation_in_Sales_Order__c,Allocation_in_Picking__c,Auto_Allocate_in_picking__c  from Order_Usage__c Limit 1]; 
            List<Inventory_Location_Product_Line_Item__c> ilpliList=[select id,name,Inventory_Location_Product__c,Available_Quantity__c,Inventory_Location__c,Bin__c,Reserved_Quantity__c,Adjusted_Quantity1__c,Product_Serial_Number__c,Lot__c from Inventory_Location_Product_Line_Item__c where id=:ilpliIdQuant.keyset()];
      Map<Id,decimal> ILPQuant= new Map<id,decimal>();
            set<Id> Serialid =new set<Id>();      
            Map<id,Map<id,decimal>> lotqtyupdate=new Map<id,Map<id,decimal>>();
            set<Id> LOTID =new set<Id>();
            for(Inventory_Location_Product_Line_Item__c indILPLI:ilpliList)
            {
                if(updating=='Reserved_Quantity'){
                    if(indILPLI.Reserved_Quantity__c==null)
                        indILPLI.Reserved_Quantity__c=0;
                    indILPLI.Reserved_Quantity__c+=ilpliIdQuant.get(indILPLI.id);
                }
                else if(updating=='Avail_Reserve_Quantity')
                {
                    if(indILPLI.Reserved_Quantity__c==null)
                        indILPLI.Reserved_Quantity__c=0;
                    indILPLI.Reserved_Quantity__c-=ilpliIdQuant.get(indILPLI.id);
                    if(indILPLI.Adjusted_Quantity1__c==null)
                        indILPLI.Adjusted_Quantity1__c=0;
                    indILPLI.Adjusted_Quantity1__c+=ilpliIdQuant.get(indILPLI.id);
                    if(indILPLI.Product_Serial_Number__c!=null)
                    {
                        Serialid.add(indILPLI.Product_Serial_Number__c); 
                    }
                    if(indILPLI.Lot__c!=null)
                    {
                        LOTID.add(indILPLI.Lot__c);
                        if(lotqtyupdate.containsKey(indILPLI.Lot__c))
                        {
                            if(lotqtyupdate.get(indILPLI.Lot__c).containsKey(indILPLI.Bin__c))
                            {
                                decimal qty=lotqtyupdate.get(indILPLI.Lot__c).get(indILPLI.Bin__c);
                                lotqtyupdate.get(indILPLI.Lot__c).put(indILPLI.Bin__c,qty+ilpliIdQuant.get(indILPLI.id));
                            }
                            else
                            {
                                Map<id,decimal> locid=new Map<id,decimal>();
                                lotqtyupdate.get(indILPLI.Lot__c).put(indILPLI.Bin__c,ilpliIdQuant.get(indILPLI.id));
                            }
                        }
                        else
                        {
                            Map<id,decimal> locid=new Map<id,decimal>();
                            locid.put(indILPLI.Bin__c,ilpliIdQuant.get(indILPLI.id));
                            lotqtyupdate.put(indILPLI.Lot__c,locid);
                        }
                    }
                }
                else if(updating=='Available_Quantity')
                {
                    if(indILPLI.Product_Serial_Number__c!=null)
                    {
                        Serialid.add(indILPLI.Product_Serial_Number__c); 
                    }
                }
        
         //code to reduce ILP
                if(ILPQuant.containsKey(indILPLI.Inventory_Location_Product__c))
                {
                    
                    ILPQuant.put(indILPLI.Inventory_Location_Product__c,ILPQuant.get(indILPLI.Inventory_Location_Product__c)+ilpliIdQuant.get(indILPLI.id));
                }
                else
                {
                    ILPQuant.put(indILPLI.Inventory_Location_Product__c,ilpliIdQuant.get(indILPLI.id));   
                }
            }
      //updating ILP pick qty 19-05-21
      
            List<Inventory_Location_Product__c>ILPList=[select id,name,Reserved_Quantity__c,Picked_Quantity__c,Source_Type__c from Inventory_Location_Product__c where id=:ILPQuant.keySet()];
            for(Inventory_Location_Product__c ILP:ILPList)
            {
                
        if(updating=='Avail_Reserve_Quantity')
        {
          if(ILP.Reserved_Quantity__c==null)
          ILP.Reserved_Quantity__c=0;
                    ILP.Reserved_Quantity__c-=ILPQuant.get(ILP.id);
          if(ILP.Picked_Quantity__c==null)
                    ILP.Picked_Quantity__c=0;
                    ILP.Picked_Quantity__c+=ILPQuant.get(ILP.id);
          ILP.Source_Type__c = 'System';
        }
                 
            }
      if(ILPList.Size()>0)
            update ILPList;
      
            List<Lot__c> lotList=new List<Lot__c>();
            lotList = [Select Id,Name,(Select Id,Name,Location__c,Bin__c,Quantity__c,Lot__c From Lot_Products__r) From Lot__c where Id in:LOTID];
            List<Lot_Product__c> updatelotpro=new List<Lot_Product__c>();
            for(Lot__c lt:lotList)
            {
                for(Lot_Product__c ltpro:lt.Lot_Products__r)
                {
                    if(lotqtyupdate.containsKey(ltpro.Lot__c))
                    {
                        if(lotqtyupdate.get(ltpro.Lot__c).containsKey(ltpro.Bin__c))
                        {
                            ltpro.Quantity__c-=lotqtyupdate.get(ltpro.Lot__c).get(ltpro.Bin__c);
                            updatelotpro.add(ltpro);
                        }
                    } 
                }
            }
            upsert updatelotpro;
            List<Product_Serial_Number__c> serialststusupdate=new List<Product_Serial_Number__c>();
            serialststusupdate=[select id,name,Status__c from Product_Serial_Number__c where id=:Serialid];
            if(updating=='Available_Quantity')
            {
                for(Product_Serial_Number__c serialstatus:serialststusupdate)
                {
                    serialstatus.Status__c='Allocate';
                }
            }
            if(updating=='Avail_Reserve_Quantity')
            {
                for(Product_Serial_Number__c serialstatus:serialststusupdate)
                {
                    serialstatus.Status__c='Used';
                }
            }
            if(serialststusupdate.size()>0){
                update serialststusupdate;
            }
            if(ilpliList.size()>0){
                update ilpliList;
            }
       }
    }
    //code added by rashmi to reduce PI when Standard Order is created and update IT Reason after every transation on 09-08-2019
    public static void reduceOnlyPI(Map<Id,Inventory__c> inventoryMap,Map<Id,Decimal> productQuantityMap,boolean nopickpack)
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
             
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'Id','Name'})
            
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new Set<String>{'sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Comments__c','sigmaerpdev2__Delivered_Qty__c'})      
            )
        {
            Map<Id,Inventory__c> inventoryUpdateMap=new Map<Id,Inventory__c>();
        
            for(Integer i=0; i< inventoryMap.values().size(); i++)
            {
                Inventory__c tempInv=inventoryMap.values()[i];
                if(nopickpack)
        {
          tempInv.Delivered_Qty__c += productQuantityMap.get(inventoryMap.values()[i].ProductCode__c);
        }
        else
        {
          tempInv.Reserved_Qty__c +=productQuantityMap.get(inventoryMap.values()[i].ProductCode__c);
        }
        tempInv.Available_Qty__c-=productQuantityMap.get(inventoryMap.values()[i].ProductCode__c); 
                tempInv.Comments__c = 'Inventory Reduced because "Order created" and allocated in "Order itself" ';
                inventoryUpdateMap.put(inventoryMap.values()[i].id,tempInv);
            }
            if(inventoryUpdateMap.size()>0)
            {
                update inventoryUpdateMap.values();
            }
        }
    }
   
    //code to reduce PI when Sales order is created and update IT Reason after every transation on 09-08-2019
    //added by Harish
    public static void reduceOnlyPIOrder(Map<Id,Inventory__c> inventoryMap,Map<Id,Decimal> productQuantityMap,boolean nopickpack)
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
             
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'Id','Name'})
            
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new Set<String>{'sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Comments__c','sigmaerpdev2__Delivered_Qty__c'})      
            )
        {
            Map<Id,Inventory__c> inventoryUpdateMap=new Map<Id,Inventory__c>();
        
            for(Integer i=0; i< inventoryMap.values().size(); i++)
            {
                Inventory__c tempInv=inventoryMap.values()[i];
                if(nopickpack)
        {
          tempInv.Delivered_Qty__c += productQuantityMap.get(inventoryMap.values()[i].ProductCode__c);
        }
        else
        {
          tempInv.Reserved_Qty__c+=productQuantityMap.get(inventoryMap.values()[i].ProductCode__c);
        }
                tempInv.Available_Qty__c-=productQuantityMap.get(inventoryMap.values()[i].ProductCode__c);
                tempInv.Comments__c = 'Inventory Reduced because "Sales Order created" and allocated in "Sales Order itself" ';
                inventoryUpdateMap.put(inventoryMap.values()[i].id,tempInv);
                
            }
            if(inventoryUpdateMap.size()>0)
            {
                update inventoryUpdateMap.values();
            }
        }
    }
    //Code to update delevered qty in ILPLI when order is delivered method called from Addshipmentprodlightng
  public static void updatedeliveredqty(Map<Id,Decimal> ilpliIdQuant){ 
       
    List<Inventory_Location_Product_Line_Item__c> ilpliList=[select id,name,Delivered_Quantity__c,Available_Quantity__c,Reserved_Quantity__c,Adjusted_Quantity1__c,Inventory_Location_Product__c,Product_Serial_Number__c,Lot__c,Bin__c from Inventory_Location_Product_Line_Item__c where id=:ilpliIdQuant.keyset()];
    Map<Id,decimal> ILPQuant= new Map<id,decimal>();
    for(Inventory_Location_Product_Line_Item__c indILPLI:ilpliList)
    {
      indILPLI.Delivered_Quantity__c += ilpliIdQuant.get(indILPLI.id); 
      indILPLI.Adjusted_Quantity1__c -= ilpliIdQuant.get(indILPLI.id); 
    
      //code to update delevered qty in ILP
      if(ILPQuant.containsKey(indILPLI.Inventory_Location_Product__c))
      {
        ILPQuant.put(indILPLI.Inventory_Location_Product__c,ILPQuant.get(indILPLI.Inventory_Location_Product__c)+ilpliIdQuant.get(indILPLI.id));
      }
      else
      {
        ILPQuant.put(indILPLI.Inventory_Location_Product__c,ilpliIdQuant.get(indILPLI.id));   
      }
    }
    if(ilpliList.size()>0){
      update ilpliList;
    }
    List<Inventory_Location_Product__c>updatesoldqunt=new List<Inventory_Location_Product__c>();
    updatesoldqunt=[select id,name,Deliver_Quantity__c,Reserved_Quantity__c,Source_Type__c from Inventory_Location_Product__c where id=:ILPQuant.keySet()];
    for(Inventory_Location_Product__c ILP:updatesoldqunt)
    {
      ILP.Deliver_Quantity__c += ILPQuant.get(ILP.id); 
      ILP.Reserved_Quantity__c-=ILPQuant.get(ILP.id);
      ILP.Source_Type__c = 'System';
    }
    if(updatesoldqunt.size()>0){
      update updatesoldqunt;
    }
  }
    //Code to reduce ILP and ILPLI when order is created
public static void reduceWholeInventory11(Map<Id,Decimal> ilpliIdQuant,String updating,boolean nopickpack){ 
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Serial_Number__c') 
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Lot_Product__c') 
            
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'id','name','sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Product_Serial_Number__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Delivered_Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'id','name','sigmaerpdev2__Deliver_Quantity__c','sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Source_Type__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Serial_Number__c',new Set<String>{'Id','Name','sigmaerpdev2__Status__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot_Product__c',new Set<String>{'Id','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Location__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Bin__c'})
                
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Delivered_Quantity__c'})      
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Source_Type__c','sigmaerpdev2__Deliver_Quantity__c'})      
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Serial_Number__c',new Set<String>{'sigmaerpdev2__Status__c'})
             && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Lot_Product__c',new Set<String>{'sigmaerpdev2__Quantity__c'})
            )
        {
            List<Inventory_Location_Product_Line_Item__c> ilpliList=[select id,name,Delivered_Quantity__c,Available_Quantity__c,Reserved_Quantity__c,Inventory_Location_Product__c,Product_Serial_Number__c,Lot__c,Bin__c from Inventory_Location_Product_Line_Item__c where id=:ilpliIdQuant.keyset()];
            Map<Id,decimal> ILPQuant= new Map<id,decimal>();
            set<Id> Serialid =new set<Id>();
      set<Id>LotId = new set<Id>();
     Map<Id,Map<Id,decimal>> maplotproforBin = new Map<Id,Map<Id,decimal>>();//added by rashmi to update Bin from LP
        for(Inventory_Location_Product_Line_Item__c indILPLI:ilpliList){
               
        
        if(nopickpack)
        {
          indILPLI.Delivered_Quantity__c += ilpliIdQuant.get(indILPLI.id); 
          if(indILPLI.Lot__c != null)
          {
            LotId.add(indILPLI.Lot__c);
          }
         /* if(maplotproforBin.containsKey(indILPLI.Bin__c))
          {
            system.debug('Inside if Condition');
            maplotproforBin.put(indILPLI.Bin__c,maplotproforBin.get(indILPLI.Bin__c)+ilpliIdQuant.get(indILPLI.id));
            system.debug('maplotproforBin '+maplotproforBin);
          }
          else
          {
             maplotproforBin.put(indILPLI.Bin__c,ilpliIdQuant.get(indILPLI.id));
             system.debug('maplotproforBinelse@@'+maplotproforBin);
          } */
      
      if(maplotproforBin.containsKey(indILPLI.Lot__c))
      {
        if(maplotproforBin.get(indILPLI.Lot__c).containsKey(indILPLI.Bin__c))
        {
          Decimal Qty = maplotproforBin.get(indILPLI.Lot__c).get(indILPLI.Bin__c);
          Map<Id,Decimal>Binqunt = new Map<Id,Decimal>();
          Binqunt.put(indILPLI.Bin__c,Qty+ilpliIdQuant.get(indILPLI.id));
          maplotproforBin.put(indILPLI.Lot__c,Binqunt);
        }
        else
        {
          Map<Id,Decimal>Binqunt = new Map<Id,Decimal>();
          Binqunt.put(indILPLI.Bin__c,ilpliIdQuant.get(indILPLI.id));
          maplotproforBin.put(indILPLI.Lot__c,Binqunt);
        }
      }
      else
      {
        Map<Id,Decimal> binqunt = new Map<Id,decimal>();
        binqunt.put(indILPLI.Bin__c,ilpliIdQuant.get(indILPLI.id));
        maplotproforBin.put(indILPLI.Lot__c,binqunt);
      }

      
      
        }
        else
        {
          indILPLI.Reserved_Quantity__c+=ilpliIdQuant.get(indILPLI.id);
        }
                //code to reduce ILP
                if(ILPQuant.containsKey(indILPLI.Inventory_Location_Product__c))
                {
                    
                    ILPQuant.put(indILPLI.Inventory_Location_Product__c,ILPQuant.get(indILPLI.Inventory_Location_Product__c)+ilpliIdQuant.get(indILPLI.id));
                }
                else
                {
                    ILPQuant.put(indILPLI.Inventory_Location_Product__c,ilpliIdQuant.get(indILPLI.id));   
                }
                if(indILPLI.Product_Serial_Number__c!=null)
                {
                    Serialid.add(indILPLI.Product_Serial_Number__c); 
                } 
            }
            if(ilpliList.size()>0){
                update ilpliList;
            }
            List<Inventory_Location_Product__c>updatesoldqunt=new List<Inventory_Location_Product__c>();
            updatesoldqunt=[select id,name,Deliver_Quantity__c,Reserved_Quantity__c,Source_Type__c from Inventory_Location_Product__c where id=:ILPQuant.keySet()];
            for(Inventory_Location_Product__c ILP:updatesoldqunt)
            {
                
        if(nopickpack)
        {
          ILP.Deliver_Quantity__c += ILPQuant.get(ILP.id); 
        }
        else
        {
          ILP.Reserved_Quantity__c+=ILPQuant.get(ILP.id);
        }
                 ILP.Source_Type__c = 'System';
            }
            update updatesoldqunt;
            List<Product_Serial_Number__c> serialststusupdate=new List<Product_Serial_Number__c>();
            serialststusupdate=[select id,name,Status__c from Product_Serial_Number__c where id=:Serialid];
            for(Product_Serial_Number__c serialstatus:serialststusupdate)
            {
                if(nopickpack)
                {
                    serialstatus.Status__c='Used';
                }
                else
                {
                  serialstatus.Status__c='Allocate';    
                }
                
            }
            update serialststusupdate;
      
      //code to update LOT for NOpickpack 02-04 //added by harish
      if(LotId.size()>0)
      {
        List<Lot_Product__c> lotproduct = [select id,Product__c,Quantity__c,Location__c,Lot__c,Bin__c from Lot_Product__c where Lot__c =:maplotproforBin.keySet()];
                system.debug('aftr querrying lotproduct-->>'+lotproduct);
        for(Lot_Product__c LP : lotproduct ) 
        {
          
          if(maplotproforBin.containsKey(LP.Lot__c) && maplotproforBin.get(LP.Lot__c).containsKey(LP.Bin__c))
          {
            LP.Quantity__c -= maplotproforBin.get(LP.Lot__c).get(LP.Bin__c);
            System.debug('after Lp qty---2>>>>>>>>'+LP.Quantity__c);
          }
        }
        if(lotproduct.size()>0){
          update lotproduct;
        }
      }
      
        }
    } 

    public static void reduceInventoryoutbound(Map<Id,Decimal> ilpliIdQuant,String updating)
    { 
        List<Inventory_Location_Product_Line_Item__c> ilpliList=[select id,name,Inventory_Location_Product__c,Available_Quantity__c,Inventory_Location__c,Bin__c,Package_Quantity__c,Adjusted_Quantity1__c,Shipped_Quantity__c,Delivered_Quantity__c from Inventory_Location_Product_Line_Item__c where id=:ilpliIdQuant.keyset()];
        Map<Id,decimal> ILPQuant= new Map<id,decimal>();
        set<Id> Serialid =new set<Id>();      
        Map<id,Map<id,decimal>> lotqtyupdate=new Map<id,Map<id,decimal>>();
        set<Id> LOTID =new set<Id>();
        for(Inventory_Location_Product_Line_Item__c indILPLI:ilpliList)
        {

            if(updating=='Package')
            {
                if(indILPLI.Adjusted_Quantity1__c==null)
                indILPLI.Adjusted_Quantity1__c=0;
                indILPLI.Adjusted_Quantity1__c-=ilpliIdQuant.get(indILPLI.id);
                if(indILPLI.Package_Quantity__c==null)
                indILPLI.Package_Quantity__c=0;
                indILPLI.Package_Quantity__c+=ilpliIdQuant.get(indILPLI.id);
            }
			 if(updating=='Shipped')
            {
                if(indILPLI.Package_Quantity__c==null)
                indILPLI.Package_Quantity__c=0;
                indILPLI.Package_Quantity__c-=ilpliIdQuant.get(indILPLI.id);
                if(indILPLI.Shipped_Quantity__c==null)
                indILPLI.Shipped_Quantity__c=0;
                indILPLI.Shipped_Quantity__c+=ilpliIdQuant.get(indILPLI.id);
            }
			if(updating=='Delivered')
			{
				if(indILPLI.Shipped_Quantity__c==null)
                indILPLI.Shipped_Quantity__c=0;
                indILPLI.Shipped_Quantity__c-=ilpliIdQuant.get(indILPLI.id);
                if(indILPLI.Delivered_Quantity__c==null)
                indILPLI.Delivered_Quantity__c=0;
                indILPLI.Delivered_Quantity__c+=ilpliIdQuant.get(indILPLI.id);
				
			}
        //code to reduce ILP
            if(ILPQuant.containsKey(indILPLI.Inventory_Location_Product__c))
            {
                ILPQuant.put(indILPLI.Inventory_Location_Product__c,ILPQuant.get(indILPLI.Inventory_Location_Product__c)+ilpliIdQuant.get(indILPLI.id));
            }
            else
            {
                ILPQuant.put(indILPLI.Inventory_Location_Product__c,ilpliIdQuant.get(indILPLI.id));   
            }
        }
        //updating ILP package qty 19-05-21

        List<Inventory_Location_Product__c>ILPList=[select id,name,Package_Quantity__c,Picked_Quantity__c,Shipped_Quantity__c,Source_Type__c,Deliver_Quantity__c from Inventory_Location_Product__c where id=:ILPQuant.keySet()];
        for(Inventory_Location_Product__c ILP:ILPList)
        {
            if(updating=='Package')
            {
                if(ILP.Picked_Quantity__c==null)
                ILP.Picked_Quantity__c=0;
                ILP.Picked_Quantity__c-=ILPQuant.get(ILP.id);
                if(ILP.Package_Quantity__c==null)
                ILP.Package_Quantity__c=0;
                ILP.Package_Quantity__c+=ILPQuant.get(ILP.id);
                ILP.Source_Type__c = 'System';
            }
			if(updating=='Shipped')
            {
                if(ILP.Package_Quantity__c==null)
                ILP.Package_Quantity__c=0;
                ILP.Package_Quantity__c-=ILPQuant.get(ILP.id);
                if(ILP.Shipped_Quantity__c==null)
                ILP.Shipped_Quantity__c=0;
                ILP.Shipped_Quantity__c+=ILPQuant.get(ILP.id);
                ILP.Source_Type__c = 'System';
            }
			if(updating=='Delivered')
            {
                if(ILP.Shipped_Quantity__c==null)
                ILP.Shipped_Quantity__c=0;
                ILP.Shipped_Quantity__c-=ILPQuant.get(ILP.id);
                if(ILP.Deliver_Quantity__c==null)
                ILP.Deliver_Quantity__c=0;
                ILP.Deliver_Quantity__c+=ILPQuant.get(ILP.id);
                ILP.Source_Type__c = 'System';
            }

        }
        if(ILPList.Size()>0)
        update ILPList;

        if(ilpliList.size()>0){
        update ilpliList;
        }
    
    }
   
}