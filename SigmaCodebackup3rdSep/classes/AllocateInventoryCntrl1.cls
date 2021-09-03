public with sharing class AllocateInventoryCntrl1 
{

public static boolean DeAllocateInventoryforOrder()
    {
        List<Id> productId = new List<Id>();
        List<Id> ProposalItemId = new List<Id>();
        List<Id> locationIdList = new List<Id>();
        List<Product_Order_Price_Book__c> orderItemList = new List<Product_Order_Price_Book__c>();
        List<Product_Order_Price_Book__c> LineItemList;
       
     /*   if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__OrderLineLocation__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'id','Name','sigmaerpdev2__Product__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Sigma_Order__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__OrderLineLocation__c',new set<String>{'id','sigmaerpdev2__Location__c','sigmaerpdev2__Order_Line__c','sigmaerpdev2__Inventory_Allocated__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'id','sigmaerpdev2__Products__c','sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c','sigmaerpdev2__Delivered_Quantity__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Start_Date__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'id','sigmaerpdev2__Product__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__OrderLineLocation__c',new set<String>{'id','sigmaerpdev2__Location__c','sigmaerpdev2__Quantity__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'sigmaerpdev2__Delivered_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__OrderLineLocation__c',new set<String>{'sigmaerpdev2__Inventory_Allocated__c'})
        )
        { */
           
            LineItemList = [select id, Name, Product__c, Start_Date__c, End_Date__c,Sigma_Order__c from Product_Order_Price_Book__c where sigmaerpdev2__Sigma_Order__r.sigmaerpdev2__Order_Created_Via__c='Time Based Inventory' and IsInventoryUpdated__c = true and End_Date__c =: system.today()];
        for(Product_Order_Price_Book__c pi : LineItemList)
        {
            productId.add(pi.Product__c);
            ProposalItemId.add(pi.Id);
        }
        List<OrderLineLocation__c> toGetLocList = [select id, Location__c, Order_Line__c,Inventory_Allocated__c from OrderLineLocation__c where ((Order_Line__c In : ProposalItemId) AND (Inventory_Allocated__c = true))];
        for(OrderLineLocation__c clil : toGetLocList)
        {
            locationIdList.add(clil.Location__c);
        }
        
        List<Inventory_Location_Product__c> ilpList = [select id, Products__c, Inventory_Location__r.Location__c, Delivered_Quantity__c, Received_Quantity__c, Net_Quantity__c, End_Date__c, Start_Date__c from Inventory_Location_Product__c where ((Inventory_Location__r.Location__c In: locationIdList) And (Products__c In: productId ))];
        
        orderItemList = [select id, Product__c, Start_Date__c, End_Date__c, (select id, Location__c, Quantity__c from OrderLineItemLocations__r where Inventory_Allocated__c = true) from Product_Order_Price_Book__c where id In: ProposalItemId];
        
        Map<Id, List<WrapperForIlpAndQuantity>> invenAllocation = new Map<Id, List<WrapperForIlpAndQuantity>>();
        for(Product_Order_Price_Book__c pItem : orderItemList)
        {
            //to get start and end date
            Date firstDayOfMonth = (pItem.Start_Date__c).toStartOfMonth();
            Date getLastMonthDate = (pItem.End_Date__c);
            Integer dayNumbers = Date.daysInMonth((getLastMonthDate).year(), (getLastMonthDate).month());
            Date lastDayOfMonth = Date.newInstance(getLastMonthDate.year(), getLastMonthDate.month(), dayNumbers);
            
            for(OrderLineLocation__c cil : pItem.OrderLineItemLocations__r)
            {
                for(Inventory_Location_Product__c ilp : ilpList)
                {
                    if((ilp.Products__c == pItem.Product__c) && (cil.Location__c == ilp.Inventory_Location__r.Location__c) && (ilp.Start_Date__c >= firstDayOfMonth) && (ilp.End_Date__c <= lastDayOfMonth))
                    {
                        if(invenAllocation.containsKey(pItem.Product__c))
                        {
                            invenAllocation.get(pItem.Product__c).add(new WrapperForIlpAndQuantity(ilp, Integer.valueOf(cil.Quantity__c)));
                        }
                        else
                        {
                            List<WrapperForIlpAndQuantity> WrapList = new List<WrapperForIlpAndQuantity>();
                            WrapList.add(new WrapperForIlpAndQuantity(ilp, Integer.valueOf(cil.Quantity__c)));
                            invenAllocation.put((pItem.Product__c),WrapList);
                        }
                    }
                }
            }
        }
        
        List<Inventory_Location_Product__c> ilpListToUpdate = new List<Inventory_Location_Product__c>();
        for(Id proId : invenAllocation.keySet())
        {
            List<WrapperForIlpAndQuantity> ilpQuantityList = invenAllocation.get(proId);
            for(WrapperForIlpAndQuantity wiaq : ilpQuantityList)
            {
                Inventory_Location_Product__c ilp = wiaq.ilpRecord;
                ilp.Delivered_Quantity__c = ilp.Delivered_Quantity__c - wiaq.quantity;
                ilpListToUpdate.add(ilp);
            }
        }
        update ilpListToUpdate;
        
        for(OrderLineLocation__c clil : toGetLocList)
        {
            clil.Inventory_Allocated__c = false;
        }
        update toGetLocList;
        
       // }
        
        return true;
    }
    
    public class WrapperForIlpAndQuantity
    {
        Inventory_Location_Product__c ilpRecord;
        integer quantity;
        public WrapperForIlpAndQuantity(Inventory_Location_Product__c ilpRecord, integer quantity)
        { 
       
            this.ilpRecord = ilpRecord;
            this.quantity = quantity;
        
        }
    }
    
}