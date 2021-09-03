public with sharing class AllocateInventoryCntrl
{
    public static boolean AllocateInventory(List<Proposal_Item__c> LineItemList, List<ProposalLineItemLocation__c> LineItemLocationList)
    {
        system.debug('LineItemList>>'+LineItemList);
        system.debug('LineItemLocationList>>'+LineItemLocationList);
        List<Id> productId = new List<Id>();
        List<Id> ProposalItemId = new List<Id>();
        List<Id> locationIdList = new List<Id>();
        List<Proposal_Item__c> praposalItemList = new List<Proposal_Item__c>();
        for(Proposal_Item__c pi : LineItemList)
        {
            productId.add(pi.Product__c);
            ProposalItemId.add(pi.Id);
        }
        
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Proposal_Item__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__ProposalLineItemLocation__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__ProposalLineItemLocation__c',new set<String>{'id','sigmaerpdev__Location__c','sigmaerpdev__Proposal_Line_Item__c','sigmaerpdev__Inventory_Allocated__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new set<String>{'id','sigmaerpdev__Products__c','sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__c','sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Received_Quantity__c','sigmaerpdev__Net_Quantity__c','sigmaerpdev__End_Date__c','sigmaerpdev__Start_Date__c'})   
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Proposal_Item__c',new set<String>{'id','sigmaerpdev__Product__c','sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__ProposalLineItemLocation__c',new set<String>{'id','sigmaerpdev__Location__c','sigmaerpdev__Quantity__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new set<String>{'sigmaerpdev__Delivered_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__ProposalLineItemLocation__c',new set<String>{'sigmaerpdev__Inventory_Allocated__c'})
        )
        {*/
           
            List<ProposalLineItemLocation__c> toGetLocList = [select id, Location__c, Proposal_Line_Item__c from ProposalLineItemLocation__c where ((Proposal_Line_Item__c In : ProposalItemId and Inventory_Allocated__c = false))];
            for(ProposalLineItemLocation__c clil : toGetLocList)
            {
                locationIdList.add(clil.Location__c);
            }
        
        List<Inventory_Location_Product__c> ilpList = [select id, Products__c, Inventory_Location__r.Location__c, Delivered_Quantity__c, Received_Quantity__c, Net_Quantity__c, End_Date__c, Start_Date__c from Inventory_Location_Product__c where ( (Inventory_Location__r.Location__c In: locationIdList) And (Products__c In: productId ))];
        system.debug('ilpList>>'+ilpList);
        praposalItemList = [select id, Product__c, Start_Date__c, End_Date__c, (select id, Location__c, Quantity__c from CampaignLineItemLocations__r ) from Proposal_Item__c where id In: ProposalItemId];//where Proposal_Line_Item__c In:ProposalItemId
        system.debug('praposalItemList>>'+praposalItemList);
        Map<Id, List<WrapperForIlpAndQuantity>> invenAllocation = new Map<Id, List<WrapperForIlpAndQuantity>>();
        system.debug('praposalItemList>>'+praposalItemList.size());
        for(Proposal_Item__c pItem : praposalItemList)
        {
            system.debug('pItem>>>'+pItem);
            Date firstDayOfMonth = (pItem.Start_Date__c).toStartOfMonth();
            Date getLastMonthDate = (pItem.End_Date__c);
            Integer dayNumbers = Date.daysInMonth((getLastMonthDate).year(), (getLastMonthDate).month());
            Date lastDayOfMonth = Date.newInstance(getLastMonthDate.year(), getLastMonthDate.month(), dayNumbers);
            system.debug('pItem.CampaignLineItemLocations__r>>>>'+pItem.CampaignLineItemLocations__r);
            for(ProposalLineItemLocation__c cil : pItem.CampaignLineItemLocations__r)
            {
                system.debug('1st>>>>'+cil);
                for(Inventory_Location_Product__c ilp : ilpList)
                {
                    system.debug('ilp>>>>>>'+ilp);
                    if((ilp.Products__c == pItem.Product__c) && (cil.Location__c == ilp.Inventory_Location__r.Location__c) && (ilp.Start_Date__c >= firstDayOfMonth) && (ilp.End_Date__c <= lastDayOfMonth))
                    {
                        system.debug(invenAllocation.containsKey(pItem.Product__c));
                        if(invenAllocation.containsKey(pItem.Product__c))
                        {
                            system.debug('inn');
                            invenAllocation.get(pItem.Product__c).add(new WrapperForIlpAndQuantity(ilp, Integer.valueOf(cil.Quantity__c)));
                        }
                        else
                        {
                            system.debug('inelse');
                            List<WrapperForIlpAndQuantity> WrapList = new List<WrapperForIlpAndQuantity>();
                            WrapList.add(new WrapperForIlpAndQuantity(ilp, Integer.valueOf(cil.Quantity__c)));
                            system.debug('WrapList>>>'+WrapList);
                            invenAllocation.put((pItem.Product__c),WrapList);
                        }
                        System.debug('Inside::'+invenAllocation);
                    }
                }
            }
        }
        system.debug('invenAllocation>>'+invenAllocation);
        
        boolean CheckError = false;
        for(Id proId : invenAllocation.keySet())
        {
            List<WrapperForIlpAndQuantity> ilpQuantityList = invenAllocation.get(proId);
            for(WrapperForIlpAndQuantity wiaq : ilpQuantityList)
            {
                if(wiaq.ilpRecord.Net_Quantity__c < wiaq.quantity)
                {
                    CheckError = true;
                }
            }
        }
        if(CheckError)
        {
            return false;
        }
        else
        {
            List<Inventory_Location_Product__c> ilpListToUpdate = new List<Inventory_Location_Product__c>();
            for(Id proId : invenAllocation.keySet())
            {
                List<WrapperForIlpAndQuantity> ilpQuantityList = invenAllocation.get(proId);
                system.debug('ilpQuantityList>>'+ilpQuantityList);
                for(WrapperForIlpAndQuantity wiaq : ilpQuantityList)
                {
                    Inventory_Location_Product__c ilp = wiaq.ilpRecord;
                    ilp.Delivered_Quantity__c = ilp.Delivered_Quantity__c + wiaq.quantity;
                    ilpListToUpdate.add(ilp);
                }
            }
            update ilpListToUpdate;
            
            for(ProposalLineItemLocation__c clil : toGetLocList)
            {
                clil.Inventory_Allocated__c = true;
            }
            update toGetLocList;
            
        }
       // }
        return true;
        
    }
    
    public static boolean DeAllocateInventory(String selectedCampaignId)
    {
       
        //Added for new flow
        List<Id> productId = new List<Id>();
        List<Id> ProposalItemId = new List<Id>();
        List<Id> locationIdList = new List<Id>();
        List<Proposal_Item__c> praposalItemList = new List<Proposal_Item__c>();
        
        List<Proposal_Item__c> LineItemList ;
        
      /*  if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Proposal_Item__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__ProposalLineItemLocation__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__ProposalLineItemLocation__c',new set<String>{'id','sigmaerpdev__Location__c','sigmaerpdev__Proposal_Line_Item__c','sigmaerpdev__Inventory_Allocated__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new set<String>{'id','sigmaerpdev__Products__c','sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__c','sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Received_Quantity__c','sigmaerpdev__Net_Quantity__c','sigmaerpdev__End_Date__c','sigmaerpdev__Start_Date__c'})   
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Proposal_Item__c',new set<String>{'id','Name','sigmaerpdev__Product__c','sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__c','sigmaerpdev__Proposal__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__ProposalLineItemLocation__c',new set<String>{'id','sigmaerpdev__Location__c','sigmaerpdev__Quantity__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new set<String>{'sigmaerpdev__Delivered_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__ProposalLineItemLocation__c',new set<String>{'sigmaerpdev__Inventory_Allocated__c'})
        )
        {*/
            
            LineItemList = [select id, Name, Product__c, Start_Date__c, End_Date__c,Proposal__c from Proposal_Item__c where Proposal__c =: selectedCampaignId];
        for(Proposal_Item__c pi : LineItemList)
        {
            productId.add(pi.Product__c);
            ProposalItemId.add(pi.Id);
        }
        
        List<ProposalLineItemLocation__c> toGetLocList = [select id, Location__c, Proposal_Line_Item__c,Inventory_Allocated__c from ProposalLineItemLocation__c where ((Proposal_Line_Item__c In : ProposalItemId) AND (Inventory_Allocated__c = true))];
        for(ProposalLineItemLocation__c clil : toGetLocList)
        {
            locationIdList.add(clil.Location__c);
        }
        
        List<Inventory_Location_Product__c> ilpList = [select id, Products__c, Inventory_Location__r.Location__c, Delivered_Quantity__c, Received_Quantity__c, Net_Quantity__c, End_Date__c, Start_Date__c from Inventory_Location_Product__c where ((Inventory_Location__r.Location__c In: locationIdList) And (Products__c In: productId ))];
        
        praposalItemList = [select id, Product__c, Start_Date__c, End_Date__c, (select id, Location__c, Quantity__c from CampaignLineItemLocations__r where Inventory_Allocated__c = true) from Proposal_Item__c where id In: ProposalItemId];
        
        Map<Id, List<WrapperForIlpAndQuantity>> invenAllocation = new Map<Id, List<WrapperForIlpAndQuantity>>();
        for(Proposal_Item__c pItem : praposalItemList)
        {
            //to get start and end date
            Date firstDayOfMonth = (pItem.Start_Date__c).toStartOfMonth();
            Date getLastMonthDate = (pItem.End_Date__c);
            Integer dayNumbers = Date.daysInMonth((getLastMonthDate).year(), (getLastMonthDate).month());
            Date lastDayOfMonth = Date.newInstance(getLastMonthDate.year(), getLastMonthDate.month(), dayNumbers);
            
            for(ProposalLineItemLocation__c cil : pItem.CampaignLineItemLocations__r)
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
        
        for(ProposalLineItemLocation__c clil : toGetLocList)
        {
            clil.Inventory_Allocated__c = false;
        }
        update toGetLocList;
       // }
        return true;
    }
   
  
     public static boolean AllocateInventoryforOrder(List<Product_Order_Price_Book__c> LineItemList)
    {
        system.debug('inside');
        List<Id> productId = new List<Id>();
        List<Id> ProposalItemId = new List<Id>();
        List<Id> locationIdList = new List<Id>();
        List<Product_Order_Price_Book__c> orderItemList = new List<Product_Order_Price_Book__c>();
        for(Product_Order_Price_Book__c pi : LineItemList)
        {
            productId.add(pi.Product__c);
            ProposalItemId.add(pi.Id);
        }
       
        
        List<OrderLineLocation__c> toGetLocList;
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__OrderLineLocation__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__OrderLineLocation__c',new set<String>{'id','sigmaerpdev__Location__c','sigmaerpdev__Order_Line__c','sigmaerpdev__Quantity__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new set<String>{'id','sigmaerpdev__Products__c','sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__c','sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Received_Quantity__c','sigmaerpdev__Net_Quantity__c','sigmaerpdev__End_Date__c','sigmaerpdev__Start_Date__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'id','sigmaerpdev__Product__c','sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__c','sigmaerpdev__Order_Status__c'})
       && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new set<String>{'sigmaerpdev__Delivered_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__OrderLineLocation__c',new set<String>{'sigmaerpdev__Inventory_Allocated__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev__IsInventoryUpdated__c'})
        )
        {*/
           
            toGetLocList = [select id, Status__c, Location__c, Order_Line__c from OrderLineLocation__c where ((Order_Line__c In : ProposalItemId))];
        for(OrderLineLocation__c clil : toGetLocList)
        {
             clil.Status__c='Order Confirmed';
            locationIdList.add(clil.Location__c);
        }
        
            if(toGetLocList.size()>0)
            {
                update toGetLocList;
            }
            //code to update inventory checkbox
            List<Product_Order_Price_Book__c> orderlineitem = [Select id,Order_Status__c,IsInventoryUpdated__c from Product_Order_Price_Book__c where id =:ProposalItemId];
           system.debug('orderlineitem@@'+orderlineitem);
            for(Product_Order_Price_Book__c orderline :orderlineitem)
            {
                if(orderline.Order_Status__c == 'Order Confirmed')
                orderline.IsInventoryUpdated__c = true; 
            }
            if(orderlineitem.size()>0)
            {
                update orderlineitem;
            }
        List<Inventory_Location_Product__c> ilpList = [select id, Products__c, Inventory_Location__r.Location__c, Delivered_Quantity__c, Received_Quantity__c, Net_Quantity__c, End_Date__c, Start_Date__c from Inventory_Location_Product__c where ( (Inventory_Location__r.Location__c In: locationIdList) And (Products__c In: productId ))];
        system.debug('ILPLIST>>'+ilpList);
        orderItemList = [select id, Product__c, Start_Date__c, End_Date__c, (select id, Location__c, Quantity__c from OrderLineItemLocations__r) from Product_Order_Price_Book__c where id In: ProposalItemId];
        system.debug('orderItemList>>'+orderItemList);
        
        Map<Id, List<WrapperForIlpAndQuantity>> invenAllocation = new Map<Id, List<WrapperForIlpAndQuantity>>();
        for(Product_Order_Price_Book__c pItem : orderItemList)
        {
            Date firstDayOfMonth = (pItem.Start_Date__c).toStartOfMonth();
            Date getLastMonthDate = (pItem.End_Date__c);
            Integer dayNumbers = Date.daysInMonth((getLastMonthDate).year(), (getLastMonthDate).month());
            Date lastDayOfMonth = Date.newInstance(getLastMonthDate.year(), getLastMonthDate.month(), dayNumbers);
           
            for(OrderLineLocation__c cil : pItem.OrderLineItemLocations__r)
            {
                system.debug('check@@'+pItem.OrderLineItemLocations__r.size());
                for(Inventory_Location_Product__c ilp : ilpList)
                {
                    system.debug('in>>>');
                    if((ilp.Products__c == pItem.Product__c) && (cil.Location__c == ilp.Inventory_Location__r.Location__c) && (ilp.Start_Date__c >= firstDayOfMonth) && (ilp.End_Date__c <= lastDayOfMonth))
                    {
                        system.debug('286@@');
                        if(invenAllocation.containsKey(pItem.Product__c))
                        {
                            system.debug('289@@');
                            invenAllocation.get(pItem.Product__c).add(new WrapperForIlpAndQuantity(ilp, Integer.valueOf(cil.Quantity__c)));
                        }
                        else
                        {
                            system.debug('294@@');
                            List<WrapperForIlpAndQuantity> WrapList = new List<WrapperForIlpAndQuantity>();
                            WrapList.add(new WrapperForIlpAndQuantity(ilp, Integer.valueOf(cil.Quantity__c)));
                            system.debug('WrapList@@@'+WrapList);
                            invenAllocation.put((pItem.Product__c),WrapList);
                        	system.debug('invenAllocationmap@@@'+invenAllocation);
                        }
                       
                    }
                }
            }
        }
        system.debug('invenAllocation>>'+invenAllocation);
        boolean CheckError = false;
        for(Id proId : invenAllocation.keySet())
        {
            List<WrapperForIlpAndQuantity> ilpQuantityList = invenAllocation.get(proId);
            for(WrapperForIlpAndQuantity wiaq : ilpQuantityList)
            {
                if(wiaq.ilpRecord.Net_Quantity__c < wiaq.quantity)
                {
                    CheckError = true;
                }
            }
        }
        if(CheckError)
        {
            return false;
        }
        
        else
        {
            List<Inventory_Location_Product__c> ilpListToUpdate = new List<Inventory_Location_Product__c>();
            for(Id proId : invenAllocation.keySet())
            {
                List<WrapperForIlpAndQuantity> ilpQuantityList = invenAllocation.get(proId);
                for(WrapperForIlpAndQuantity wiaq : ilpQuantityList)
                {
                    Inventory_Location_Product__c ilp = wiaq.ilpRecord;
                    ilp.Delivered_Quantity__c = ilp.Delivered_Quantity__c + wiaq.quantity;
                    ilpListToUpdate.add(ilp);
                }
            }
            update ilpListToUpdate;
            system.debug('update>>'+ilpListToUpdate);
            for(OrderLineLocation__c clil : toGetLocList)
            {
                clil.Inventory_Allocated__c = true;
            }
            update toGetLocList;
            
        }
       // }
        return true;
        
    }
    
     public static boolean DeAllocateInventoryforOrder(String selectedCampaignId)
    {
        List<Id> productId = new List<Id>();
        List<Id> ProposalItemId = new List<Id>();
        List<Id> locationIdList = new List<Id>();
        List<Product_Order_Price_Book__c> orderItemList = new List<Product_Order_Price_Book__c>();
        List<Product_Order_Price_Book__c> LineItemList;
       
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__OrderLineLocation__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'id','Name','sigmaerpdev__Product__c','sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__c','sigmaerpdev__Sigma_Order__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__OrderLineLocation__c',new set<String>{'id','sigmaerpdev__Location__c','sigmaerpdev__Order_Line__c','sigmaerpdev__Inventory_Allocated__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new set<String>{'id','sigmaerpdev__Products__c','sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__c','sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Received_Quantity__c','sigmaerpdev__Net_Quantity__c','sigmaerpdev__End_Date__c','sigmaerpdev__Start_Date__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'id','sigmaerpdev__Product__c','sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__OrderLineLocation__c',new set<String>{'id','sigmaerpdev__Location__c','sigmaerpdev__Quantity__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new set<String>{'sigmaerpdev__Delivered_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__OrderLineLocation__c',new set<String>{'sigmaerpdev__Inventory_Allocated__c'})
        )
        {
           
            LineItemList = [select id, Name, Product__c, Start_Date__c, End_Date__c,Sigma_Order__c from Product_Order_Price_Book__c where Sigma_Order__c =: selectedCampaignId];
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
        
        }
        
        return true;
    }
    
    public class WrapperForIlpAndQuantity
    {
        Inventory_Location_Product__c ilpRecord;
        integer quantity;
        public WrapperForIlpAndQuantity(Inventory_Location_Product__c ilpRecord, integer quantity)
        { 
        //if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')){
            this.ilpRecord = ilpRecord;
            this.quantity = quantity;
        //}
        }
    }
    
}