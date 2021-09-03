/*=====================================================================================================
Author     : Rashmi Degavi
Company    : Mindlinks Solution Pvt Ltd.
Date       : 19 Dec 2018
Description: Prevent Duplicate Line Items
=======================================================================================================*/
trigger CheckDuplicateLines on BOM_Line_Item__c (before insert, after update, before delete,after insert,after delete) 
{
    if(Trigger.isInsert)
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__BOM_Line_Item__c')  
        &&CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__BOM_Line_Item__c')      
        && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'Id','Name','sigmaerpdev2__BOM_Line_Items_Count__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__BOM_Line_Item__c',new Set<String>{'Id', 'Name','sigmaerpdev2__Product__c'})
        && CRUD_FLS_CheckUtility.checkFLS('Product2',new Set<String>{'sigmaerpdev2__BOM_Line_Items_Count__c'})
        )   
        {
        Map<Id, List<BOM_Line_Item__c>> BomIds = new Map<Id, List<BOM_Line_Item__c>>();
        Map<Id, decimal> BomPrice = new Map<Id, decimal>();
        Id newids;
        for(BOM_Line_Item__c  bli : Trigger.New)
        {
            if(BomIds.containsKey(bli.Products__c)){
                BomIds.get(bli.Products__c).add(bli);
            }else{
                BomIds.put(bli.Products__c, new List<BOM_Line_Item__c> {bli});
            }
        }
        system.debug('BomIds:: '+BomIds);
        List<Product2> BomList = [Select Id, Name,BOM_Line_Items_Count__c, (Select Id, Name,Product__c from Line_Items__r where Id NOT IN :Trigger.New ) from Product2 Where Id In : BomIds.KeySet() ];
        system.debug('BomList :: '+BomList );
        
        for(Product2 bom : BomList)
        {
            Integer linecount = BomIds.get(bom.Id).size();
           // decimal Pricecount = BomPrice.get(bom.Id);
            system.debug('linecount ::: '+linecount);
            
            for(BOM_Line_Item__c line : bom.Line_Items__r )
            {
                if(BomIds.containsKey(bom.Id))
                {
                    for(BOM_Line_Item__c bli: BomIds.get(bom.Id))
                    {
                        if(line.Product__c == bli.Product__c)
                        {
                           // Trigger.new[0].addError('Duplicate Product Added');
                           bli.Product__c.addError('Duplicate Product Added');
                        }
                    }
                }
                linecount = linecount + 1;
              /*  if(line.Price__c != null)
                    Pricecount = Pricecount + line.Price__c;
                else
                    Pricecount = Pricecount + 0; */
            }
            bom.BOM_Line_Items_Count__c = linecount;
           // bom.BOM_Line_Items_Price_Sum__c = Pricecount;
        }
        update BomList;
        system.debug('update BomList :: '+BomList);
        }
       
    }
    
    if(Trigger.isUpdate)
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__BOM_Line_Item__c')  
        &&CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__BOM_Line_Item__c')      
        && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'Id','Name','sigmaerpdev2__BOM_Line_Items_Count__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__BOM_Line_Item__c',new Set<String>{'Id', 'Name','sigmaerpdev2__Product__c'})
        && CRUD_FLS_CheckUtility.checkFLS('Product2',new Set<String>{'sigmaerpdev2__BOM_Line_Items_Count__c'})
        )
        {
        Map<Id, List<BOM_Line_Item__c>> BomIds = new Map<Id, List<BOM_Line_Item__c>>();
      //  Map<Id, decimal> BomPrice = new Map<Id, decimal>();
        Set<Id> lineItemIds = new Set<Id>();
        
        for(BOM_Line_Item__c  bli : Trigger.New)
        {
            lineItemIds.add(bli.Id);
            if(BomIds.containsKey(bli.Products__c))
                BomIds.get(bli.Products__c).add(bli);
            else
                BomIds.put(bli.Products__c, new List<BOM_Line_Item__c> {bli});
        }
        system.debug('BomIds:: '+BomIds);
        
        List<Product2> BomList = [Select Id, Name, BOM_Line_Items_Count__c,(Select Id, Name,Product__c from Line_Items__r) from Product2 Where Id In : BomIds.KeySet() ];
        system.debug('BomList :: '+BomList );
        
        for(Product2 bom : BomList)
        {
            decimal Pricecount = 0;
            
            for(BOM_Line_Item__c line : bom.Line_Items__r )
            {
                if(BomIds.containsKey(bom.Id))
                {
                    for(BOM_Line_Item__c bli: BomIds.get(bom.Id))
                    {
                        if(!lineItemIds.contains(line.Id)){
                            if(line.Product__c == bli.Product__c)
                                 bli.Product__c.addError('Duplicate Product Added');
                        }
                    }
                }
              /*  if(line.Price__c != null)
                    Pricecount = Pricecount + line.Price__c;
                else
                    Pricecount = Pricecount + 0;*/
            }
           // system.debug('Pricecount ::: '+Pricecount);
            system.debug('bom.Line_Items__r.size ::: '+bom.Line_Items__r.size());
            
            bom.BOM_Line_Items_Count__c = bom.Line_Items__r.size();
          //  bom.BOM_Line_Items_Price_Sum__c = Pricecount;
        }
        update BomList;
        system.debug('update BomList :: '+BomList);
        }
    }
    
    if(Trigger.isdelete){
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__BOM_Line_Item__c')  
        &&CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__BOM_Line_Item__c')      
        && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'Id','Name','sigmaerpdev2__BOM_Line_Items_Count__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__BOM_Line_Item__c',new Set<String>{'Id', 'Name','sigmaerpdev2__Product__c'})
        && CRUD_FLS_CheckUtility.checkFLS('Product2',new Set<String>{'sigmaerpdev2__BOM_Line_Items_Count__c'})
        )
        {
            Map<Id, decimal> BomCount = new Map<Id, decimal>();
            Map<Id, decimal> BomPrice = new Map<Id, decimal>();
            
            for(BOM_Line_Item__c  bli : Trigger.old)
            {
                if(BomCount.containsKey(bli.Products__c)){
                    BomCount.put(bli.Products__c, BomCount.get(bli.Products__c)+1);
                }else{
                    BomCount.put(bli.Products__c, 1);
                }
            }
            system.debug('BomCount:: '+BomCount);
         //   system.debug('BomPrice:: '+BomPrice);
            
            List<Product2> BomList = [Select Id, Name,BOM_Line_Items_Count__c from Product2 Where Id In : BomCount.KeySet() ];
            system.debug('BomList :: '+BomList);
            
            for(Product2 bom : BomList)
            {
                if(BomCount.containsKey(bom.Id)){
                    bom.BOM_Line_Items_Count__c = bom.BOM_Line_Items_Count__c - BomCount.get(bom.Id);
                  //  bom.BOM_Line_Items_Price_Sum__c = bom.BOM_Line_Items_Price_Sum__c - BomPrice.get(bom.Id);
                }
            }
            update BomList;
            system.debug('update BomList :: '+BomList);
        }
    }
    
    
    
    
 /************************************************************************************************************
Trigger on Procurement time
Author     : vidya M
*************************************************************************************************************/

  Decimal totalunitprice = 0;
        Decimal maximumleadtime=0;
        Decimal maxfinal=0;
        String maxiumvalue;
        map<String,Decimal> dayslist=new map<String,Decimal>();
        dayslist.put('Hour',1);
        dayslist.put('Day',24);
        dayslist.put('Week',168);
        dayslist.put('Month',730.001);
        dayslist.put('Quarter',2190);
        dayslist.put('Half-Year',4380);
        dayslist.put('Year',8760);
   
        List<Product2> ListProduct = new List<Product2>();
        Set<Id>proids = new Set<Id>();
        List<BOM_Line_Item__c> lineitemss = new List<BOM_Line_Item__c>();
        
         for (BOM_Line_Item__c co : Trigger.new){
         proids.add(co.Products__c);
         }
        
     list<Product2> po = [SELECT Id,Name,BOM_Line_Items_Count__c,Max_Lead_Time__c,Total_Cost__c,(SELECT id,Product_Lead_Time_Interval__c,Products__c,Product_Lead_Time__c,Quantity__c,Unit_Cost__c,Total_Cost__c from Line_Items__r )FROM Product2 WHERE Id = :proids];
   
    if(Trigger.isInsert){
            try {
                for(Product2 prods : po) {
                for(BOM_Line_Item__c am_co:prods.Line_Items__r)
                {
                     totalunitprice += am_co.Total_Cost__c;
                     
                   if((dayslist.get(am_co.Product_Lead_Time_Interval__c)*am_co.Product_Lead_Time__c)>=maximumleadtime)
                   {
                    maxfinal = am_co.Product_Lead_Time__c;
                     maximumleadtime=am_co.Product_Lead_Time__c * dayslist.get(am_co.Product_Lead_Time_Interval__c);
                     
                     maxiumvalue=String.Valueof(maxfinal)+'                       ' +am_co.Product_Lead_Time_Interval__c;
               
                }
                    }
                    prods.Total_Cost__c = totalunitprice;
                       prods.Max_Lead_Time__c = maxiumvalue;

                    update prods;
                }
            } catch (Exception e) {
                System.debug(e);
            }
        }
     if(Trigger.isAfter) {
        if(Trigger.isUpdate){
            try {
             for (BOM_Line_Item__c co : Trigger.old){
                 proids.add(co.Products__c);
               }
               
                 for(Product2 prods : po) {
                for(BOM_Line_Item__c am_co:prods.Line_Items__r)
                {
                totalunitprice += am_co.Total_Cost__c;
                     
                   if((dayslist.get(am_co.Product_Lead_Time_Interval__c)*am_co.Product_Lead_Time__c)>=maximumleadtime)
                   {
                    maxfinal = am_co.Product_Lead_Time__c;
                     maximumleadtime=am_co.Product_Lead_Time__c * dayslist.get(am_co.Product_Lead_Time_Interval__c);
                     
                     maxiumvalue=String.Valueof(maxfinal)+'                       ' +am_co.Product_Lead_Time_Interval__c;
               
                    }
                 }
                    prods.Total_Cost__c = totalunitprice;
                    prods.Max_Lead_Time__c = maxiumvalue;

                    update po;
                }
            } catch (Exception e) {
                System.debug(e);
            }
        }
        
        if(Trigger.isDelete){
            try {
                for (BOM_Line_Item__c co : Trigger.old){
                 proids.add(co.Products__c);
               }
               
                    for(Product2 prods : po) {
                for(BOM_Line_Item__c am_co:prods.Line_Items__r)
                {
                     totalunitprice += am_co.Total_Cost__c;
                     
                   if((dayslist.get(am_co.Product_Lead_Time_Interval__c)*am_co.Product_Lead_Time__c)>=maximumleadtime)
                   {
                    maxfinal = am_co.Product_Lead_Time__c;
                     maximumleadtime=am_co.Product_Lead_Time__c * dayslist.get(am_co.Product_Lead_Time_Interval__c);
                     
                     maxiumvalue=String.Valueof(maxfinal)+'                       ' +am_co.Product_Lead_Time_Interval__c;
               
                }
                    }
                    prods.Total_Cost__c = totalunitprice;
                       prods.Max_Lead_Time__c = maxiumvalue;

                    update po;
                }
            } catch (Exception e) {
                System.debug(e);
            }
        }
    }
    

    
}