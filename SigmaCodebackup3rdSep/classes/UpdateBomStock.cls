public with sharing class UpdateBomStock {
    
    
    public class Wrapper 
    {
        
        @AuraEnabled
        public Inventory__c productinventory;
        @AuraEnabled
        public List<Product_Serial_Number__c> serialList;
        @AuraEnabled
        public Decimal UpdateStockNum;
        @AuraEnabled
        public String bomloc;
        @AuraEnabled
        public String bomlot;
        @AuraEnabled
        public List<WrapperLineItem> eachWrapperLineItem;
        @AuraEnabled
        public String message{get;set;}
        @AuraEnabled
        public String data{get;set;}
        @AuraEnabled
        public String duplicateSerialNo{get;set;}
        //}
    } 
    
    public class WrapperLineItem 
    {
        @AuraEnabled
        public String eachLineItem;
        @AuraEnabled
        public Decimal LineItemqty;
        @AuraEnabled
        public Decimal pickqtydisplay;
        @AuraEnabled
        public Decimal totalPickQty;//added on20-06-2020
        @AuraEnabled
        public Decimal Indavailable;
        @AuraEnabled
        public List<InnerWrapperLineItemILP> eachLineItemILPLIWrapper;
    }
    
    public class InnerWrapperLineItemILP
    {
        @AuraEnabled
        public Inventory_Location_Product_Line_Item__c eachLineItemILPLI; 
        @AuraEnabled
        public Integer pickQty;
        
    }
    @AuraEnabled  
    public static Wrapper getPIData( String inventoryid)
    {
        System.debug(inventoryid);
        Wrapper invenda;
        Savepoint sp;
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__BOM_Line_Item__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('product2')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Serial_Number__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'Id','Name','sigmaerpdev2__Product_Name__c','sigmaerpdev2__ProductCode__c','sigmaerpdev2__ProductCode__r.sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__ProductCode__r.sigmaerpdev2__Stock_Item__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__Description__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__BOM_Line_Item__c',new Set<String>{'Id','Name','sigmaerpdev2__Products__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__r.name','sigmaerpdev2__Products__r.name'})
           && CRUD_FLS_CheckUtility.checkReadPermission('product2',new Set<String>{'Id','Name'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'Id','Name','sigmaerpdev2__Type__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Product_Serial_Number__r.Name','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Product__r.sigmaerpdev2__Product_Bar_Code__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Inventory_Location_Product__r.Name','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Inventory_Location_Name__c','sigmaerpdev2__Expiry_Date__c','sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__Product_Serial_Number__c','sigmaerpdev2__AvailableAdjustedQty__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Lot__r.Name','sigmaerpdev2__Bin__c','sigmaerpdev2__Bin__r.Name','sigmaerpdev2__Bin__r.sigmaerpdev2_Bar_Code__c','sigmaerpdev2__Bin__r.sigmaerpdev2__zone__r.Name','sigmaerpdev2__Product__r.sigmaerpdev2__Attribute_Type__c' })
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Serial_Number__c',new Set<String>{'Id','Name','sigmaerpdev2__Product_Code__c','sigmaerpdev2__Serial_Number__c'}))
        {
            List<Product_Serial_Number__c> serial=new List<Product_Serial_Number__c>();
            Inventory__c InventoryData = [select Id, Name, Product_Name__c, ProductCode__c,ProductCode__r.Attribute_Type__c, Available_Qty__c,ProductCode__r.Stock_Item__c, Total_Available_Qty__c,Description__c from Inventory__c  Where  ProductCode__c =: inventoryid and ProductCode__r.Stock_Item__c=true Limit 1];            
            system.debug('InventoryData-->>>'+InventoryData.Product_Name__c);
            List<BOM_Line_Item__c> BomLineItems = [select Id, Name, Products__c,Product__c,Quantity__c,Product__r.name from BOM_Line_Item__c Where Products__r.name=: InventoryData.Product_Name__c];
            system.debug('BomLineItems-->>'+BomLineItems);
            Map<Id, decimal> eachitem = new Map<Id, decimal>();
            
            for(BOM_Line_Item__c bli : BomLineItems )
            {
                eachitem.put(bli.Product__c, bli.Quantity__c);
            }
            
            serial=[select Id, Name,Product_Code__c,Serial_Number__c from Product_Serial_Number__c where Product_Code__c=:InventoryData.ProductCode__c];
            List<product2>  IndividualLineItem = [select Id, Name, (select Id, Name,Type__c,Unit_Price__c,Attribute_Type__c,Product_Serial_Number__r.Name,Inventory_Location_Product__c,Product__c,Product__r.Name,Product__r.Product_Bar_Code__c,Inventory_Location__c,Received_Quantity__c, Inventory_Location_Product__r.Name, Inventory_Location_Product__r.Inventory_Location_Name__c, Expiry_Date__c, Available_Quantity__c, Product_Serial_Number__c,AvailableAdjustedQty__c,Lot__c,Lot__r.Name,Bin__c,Bin__r.Name,Bin__r.Bar_Code__c,Bin__r.zone__r.Name,Product__r.Attribute_Type__c  from Inventory_Location_Product_Line_Items__r where Available_Quantity__c > 0) from product2 Where Id In : eachitem.keyset() ];
            List<Inventory__c> IndividualPI=[select id, name,ProductCode__c, Available_Qty__c  from Inventory__c where ProductCode__c =: eachitem.keyset() ];
            system.debug('inside IndividualLineItem-->'+IndividualLineItem);
            system.debug('inside IndividualPI-->'+IndividualPI);
            
             Map<Id, decimal> eachPIitem = new Map<Id, decimal>();
            for(Inventory__c Inpi : IndividualPI )
            {
                eachPIitem.put(Inpi.ProductCode__c, Inpi.Available_Qty__c);
            }
             system.debug('inside eachPIitem-->'+eachPIitem);
            List<WrapperLineItem> eachBomLineItem = new List<WrapperLineItem>();
            
            List<InnerWrapperLineItemILP> ilplineItemWrapList;            
            WrapperLineItem wli;
            
            for(product2 prd:IndividualLineItem)
            {
                ilplineItemWrapList = new List<InnerWrapperLineItemILP>();
                
                String p2 = prd.Name;
                Decimal pqd = eachitem.get(prd.id);
                InnerWrapperLineItemILP iwli;
                System.debug('IndividualLineItem::'+ prd.Inventory_Location_Product_Line_Items__r);
                for(Inventory_Location_Product_Line_Item__c eachilp : prd.Inventory_Location_Product_Line_Items__r)
                {
                    system.debug('eachilp---->'+eachilp);
                    InnerWrapperLineItemILP innerilp=new InnerWrapperLineItemILP();
                    if(eachilp.Available_Quantity__c>0 && eachilp.Available_Quantity__c!= null)
                    {   
                        innerilp.eachLineItemILPLI=eachilp;
                        innerilp.pickQty=0;
                        
                        ilplineItemWrapList.add(innerilp);
                    }
                }
                System.debug('ilplineItemWrapList'+ilplineItemWrapList);                           
                wli = new WrapperLineItem();
                wli.eachLineItem=p2;
                wli.LineItemqty=pqd;
                wli.pickqtydisplay=0;
                wli.totalPickQty=0;
                
                wli.Indavailable=eachPIitem.get(prd.id);
                wli.eachLineItemILPLIWrapper=ilplineItemWrapList;
                eachBomLineItem.add(wli); 
            }
            
            invenda=new Wrapper();
            invenda.productinventory=InventoryData; 
            invenda.serialList=serial;
            invenda.UpdateStockNum=0;
            invenda.eachWrapperLineItem=eachBomLineItem;
        }
        system.debug('invenda-->>'+invenda);
        return invenda;
    }
    
    @AuraEnabled  
    public static Wrapper savedata(string wrapperdata,string serial,string binId)
    {
        
        
        
        system.debug('values::'+wrapperdata);
        system.debug('binId>>>'+binId);
        system.debug('serial>>>>>>>>>>>'+serial);
        Savepoint sp;
        Wrapper values;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Lot__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Lot_Product__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Serial_Number__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
           
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'Id','Name','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__AdjustedReceivedqty__c','sigmaerpdev2__Source_Type__c','sigmaerpdev2__Products__c','sigmaerpdev2__ProductCode__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Inventory__c','sigmaerpdev2__AvailableAdjustedQty__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'Id','Name','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Lot__c','sigmaerpdev2__AdjustedReceivedqty_c__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Product__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__AvailableAdjustedQty__c','sigmaerpdev2__Product_Serial_Number__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Inventory_Location_Product__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot__c',new Set<String>{'id','name'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot_Product__c',new Set<String>{'id','name','sigmaerpdev2__Location__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Bin__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Serial_Number__c',new Set<String>{'id','Name','sigmaerpdev2__Status__c','sigmaerpdev2__Serial_Number__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Product_Code__c','sigmaerpdev2__Lot__c','Bin__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Inventory_Location__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'sigmaerpdev2__ProductCode__c','sigmaerpdev2__Comments__c','sigmaerpdev2__ProductCode__r.sigmaerpdev2__Attribute_Type__c'})
           
           
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'sigmaerpdev2__Unit_Price__c','sigmaerpdev2__AvailableAdjustedQty__c','sigmaerpdev2__AdjustedReceivedqty_c__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product_Serial_Number__c','sigmaerpdev2__Lot__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Lot_Product__c',new Set<String>{'sigmaerpdev2__Quantity__c','sigmaerpdev2__Location__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Product__c','sigmaerpdev2__Bin__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Serial_Number__c',new Set<String>{'sigmaerpdev2__Status__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Serial_Number__c','sigmaerpdev2__Product_Code__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Inventory_Location__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev2__AdjustedReceivedqty__c','sigmaerpdev2__Source_Type__c','sigmaerpdev2__Products__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Inventory__c','sigmaerpdev2__AvailableAdjustedQty__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c', new Set<String>{'sigmaerpdev2__Comments__c'})
          )
        {
         
            try
            {
                
                sp = Database.setSavepoint();
                system.debug('values:::');
                values = (Wrapper)JSON.deserialize(wrapperdata,Wrapper.class);
                System.debug('values::'+values);
                Object[] values1 = (Object[])System.JSON.deserializeUntyped(serial);
                System.debug('values1::'+values1);
                List<String> selectedIdsList = new List<String>();
                if(values1 !=null)
                {
                    if(values1.size()>0 )
                    {         
                        for (Object id : values1)
                        {
                            selectedIdsList.add(string.valueof(id) );
                        }
                    } 
                }
                system.debug('selectedIdsList--->>'+selectedIdsList);
                String str1 = serial.substring(1, serial.length()-1);
                List<String> stringList = str1.split(',');  
                List<String> strSplt = str1.split('},');
                List<String> strList = new List<String>();
                for(integer i=0;i<strSplt.size();i++)
                {
                    if(i < strSplt.size()-1)
                    {
                        strList.add(strSplt[i]+'}');
                    }
                    else
                    {
                        strList.add(strSplt[i]);
                    }
                    
                }
                system.debug('strList--->>'+strList);
                Integer len = strSplt.size();
                Map<String, Object> rootProLoc; 
                List<Inventory_Location_Product__c> BomILPList;
                List<Inventory_Location_Product_Line_Item__c> IndividualILPList=new List<Inventory_Location_Product_Line_Item__c>();
                List<Inventory_Location_Product__c> BomILPListif;
                List<Inventory_Location_Product__c> BomILPListelse = new List<Inventory_Location_Product__c>();
                Map<id, decimal> ilpqty = new Map<id, decimal>();
                
                BomILPList = [select Id, Name, Received_Quantity__c,Products__c,Inventory_Location__c,Inventory_Location_Name__c,AdjustedReceivedqty__c, Source_Type__c from Inventory_Location_Product__c where Products__c =: values.productinventory.ProductCode__c AND Inventory_Location__c =: values.bomloc limit 1];
                List<id> individualsrno=new List<id>();
                Map<id,Map<id,decimal>> lotwithilpli=new Map<id,Map<id,decimal>>();
                Map<Id, Map<Id, decimal>> ILPLIunitprice = new Map<Id, Map<Id, decimal>>();//used to get il,bin and product unit price added by rashmi on 20-01-2021
                Map<Id, decimal> ilpliup = new Map<Id, decimal>();
                Map<id,id> lotpro=new Map<id,id>();
                Map<id,decimal> Ilpliwithqty=new Map<id,decimal>();
                Map<Id,Id> BomProdIds =new Map<Id,Id>();
                Decimal Totunitprice = 0;
                //Decimal Bomunitprice = 0;
                system.debug('values.eachWrapperLineItem-->'+values.eachWrapperLineItem);
                decimal updateBomQty;
                for(WrapperLineItem wli:values.eachWrapperLineItem)
                {
                    
                    Inventory_Location_Product_Line_Item__c wrapEachIlp;
                    Decimal totalPickQty = wli.pickqtydisplay;
                    updateBomQty = values.UpdateStockNum;
                    system.debug('updateBomQty--->'+updateBomQty);
                    totalPickQty = (totalPickQty *values.UpdateStockNum);
                    system.debug('totalPickQty-->>>'+totalPickQty);
                    system.debug(' wli.eachLineItemILPLIWrapper-->>>'+ wli.eachLineItemILPLIWrapper);
                    for(InnerWrapperLineItemILP iwli: wli.eachLineItemILPLIWrapper)
                    {
                        system.debug('iwli--->'+iwli);
                        if(iwli.pickQty>0)
                        {
                            wrapEachIlp = new Inventory_Location_Product_Line_Item__c();
                            wrapEachIlp.Id = iwli.eachLineItemILPLI.Id;  
                            wrapEachIlp.Product__c=iwli.eachLineItemILPLI.Product__c;
                            system.debug('wrapEachIlp.Unit_Price__c-->'+iwli.eachLineItemILPLI.Unit_Price__c);
                            wrapEachIlp.Unit_Price__c=iwli.eachLineItemILPLI.Unit_Price__c;
                            system.debug('wrapEachIlp.Unit_Price__c-->'+iwli.eachLineItemILPLI.Unit_Price__c);
                            
                            system.debug('ILP1--->'+iwli.eachLineItemILPLI.Inventory_Location_Product__c);
                            wrapEachIlp.Inventory_Location_Product__c=iwli.eachLineItemILPLI.Inventory_Location_Product__c;
                            system.debug('ILP2--->'+iwli.eachLineItemILPLI.Inventory_Location_Product__c);
                            
                            if(iwli.eachLineItemILPLI.AvailableAdjustedQty__c==null)
                            {
                                iwli.eachLineItemILPLI.AvailableAdjustedQty__c= 0;
                            }
                            if(iwli.eachLineItemILPLI.Received_Quantity__c ==null)
                            {
                                iwli.eachLineItemILPLI.Received_Quantity__c = 0;
                            }
                            wrapEachIlp.AvailableAdjustedQty__c= iwli.eachLineItemILPLI.AvailableAdjustedQty__c+ iwli.pickQty;  
                            if(ilpqty.containsKey(iwli.eachLineItemILPLI.Inventory_Location_Product__c))
                            {
                                decimal oldqty = ilpqty.get(iwli.eachLineItemILPLI.Inventory_Location_Product__c);
                                decimal newqty = oldqty + iwli.pickQty;
                                ilpqty.put(iwli.eachLineItemILPLI.Inventory_Location_Product__c,newqty);
                            }
                            else
                            {
                                ilpqty.put(iwli.eachLineItemILPLI.Inventory_Location_Product__c, iwli.pickQty);
                            }
                            if(iwli.eachLineItemILPLI.Product_Serial_Number__c!=null)
                            {
                                individualsrno.add(iwli.eachLineItemILPLI.Product_Serial_Number__c);
                            }
                            
                            if(lotwithilpli.containsKey(iwli.eachLineItemILPLI.Lot__c))
                            {
                                if(lotwithilpli.get(iwli.eachLineItemILPLI.Lot__c).containsKey(iwli.eachLineItemILPLI.Bin__c))
                                {
                                    Decimal lotqty=lotwithilpli.get(iwli.eachLineItemILPLI.Lot__c).get(iwli.eachLineItemILPLI.Bin__c)+iwli.pickQty;
                                    lotwithilpli.get(iwli.eachLineItemILPLI.Lot__c).put(iwli.eachLineItemILPLI.Bin__c,lotqty);
                                    Ilpliwithqty.put(iwli.eachLineItemILPLI.Id,iwli.pickQty);
                                    BomProdIds.put(iwli.eachLineItemILPLI.Id,iwli.eachLineItemILPLI.Product__c);
                                  
                                }
                                else
                                {
                                    lotwithilpli.get(iwli.eachLineItemILPLI.Lot__c).put(iwli.eachLineItemILPLI.Bin__c,iwli.pickQty);
                                    Ilpliwithqty.put(iwli.eachLineItemILPLI.Id,iwli.pickQty);
                                    BomProdIds.put(iwli.eachLineItemILPLI.Id,iwli.eachLineItemILPLI.Product__c);
                                   // ProdTypeid.add(iwli.eachLineItemILPLI.Product__c);//adding Bom product ids to the set
                                }
                            }
                            else
                            {
                                Map<id,decimal> lotil= new Map<id,decimal>();
                                lotil.put(iwli.eachLineItemILPLI.Bin__c,iwli.pickQty);
                                Ilpliwithqty.put(iwli.eachLineItemILPLI.Id,iwli.pickQty);
                                system.debug('Ilpliwithqty-->'+Ilpliwithqty);
                                lotwithilpli.put(iwli.eachLineItemILPLI.Lot__c,lotil);
                                BomProdIds.put(iwli.eachLineItemILPLI.Id,iwli.eachLineItemILPLI.Product__c);
                             //   ProdTypeid.add(iwli.eachLineItemILPLI.Product__c);//adding Bom product ids to the set
                            }
                           
                            // Code To get Unit price data from map ILPLIunitprice added by rashmi on 20-01-2021
                            /*system.debug('up> map >>'+ILPLIunitprice.containsKey(iwli.eachLineItemILPLI.Inventory_Location__c));
                            if(ILPLIunitprice.containsKey(iwli.eachLineItemILPLI.Inventory_Location__c)){
                                if(ILPLIunitprice.get(iwli.eachLineItemILPLI.Inventory_Location__c).containsKey(iwli.eachLineItemILPLI.Bin__c))
                                {
                                    system.debug('iwli.eachLineItemILPLI unitprice >>'+iwli.eachLineItemILPLI.Unit_Price__c );
                                    system.debug('iwli.eachLineItemILPLI bin >>'+ILPLIunitprice.get(iwli.eachLineItemILPLI.Inventory_Location__c).get(iwli.eachLineItemILPLI.Bin__c) );
                                    decimal bomunitprice = iwli.eachLineItemILPLI.Unit_Price__c + ILPLIunitprice.get(iwli.eachLineItemILPLI.Inventory_Location__c).get(iwli.eachLineItemILPLI.Bin__c); 
                                    system.debug('bomunitprice>>>>'+bomunitprice);
                                    ILPLIunitprice.get(iwli.eachLineItemILPLI.Inventory_Location__c).put(iwli.eachLineItemILPLI.Bin__c, bomunitprice);
                                    system.debug('ILPLIunitprice 1 >>>>'+ILPLIunitprice);
                                }
                                else{
                                    ILPLIunitprice.get(iwli.eachLineItemILPLI.Inventory_Location__c).put(iwli.eachLineItemILPLI.Bin__c, iwli.eachLineItemILPLI.Unit_Price__c);
                                    system.debug('ILPLIunitprice 2 >>>>'+ILPLIunitprice);
                                }
                            }
                            else{
                                ilpliup.put(iwli.eachLineItemILPLI.Bin__c, iwli.eachLineItemILPLI.Unit_Price__c *iwli.pickQty);
                                system.debug('ilpliup>>>'+ilpliup);
                                ILPLIunitprice.put(iwli.eachLineItemILPLI.Inventory_Location__c, ilpliup);
                                 system.debug('ILPLIunitprice-- 3 >>>>'+ILPLIunitprice);
                            }*/
                           system.debug('ILPLIunitprice--final>>>>'+ILPLIunitprice);
                            //code ends here -21-01-2021
                            lotpro.put(iwli.eachLineItemILPLI.Lot__c,iwli.eachLineItemILPLI.Product__c);
                            Totunitprice=(Totunitprice+(wrapEachIlp.Unit_Price__c*Ilpliwithqty.get(iwli.eachLineItemILPLI.Id))).setScale(2);
                            system.debug('Totunitprice--->>>'+Totunitprice);
                            IndividualILPList.add(wrapEachIlp);  
                        }      
                    }      
                }
                if(IndividualILPList.size()>0)
                {
                    TriggerHandler.isIndvidualtoBOM ='IsManualUpdatePI';
                    update  IndividualILPList;//updating individual ilpli
                }
                system.debug('after inserting IndividualILPList-->>'+IndividualILPList);
                List<Lot_Product__c> lotMap=[select id,name,Location__c,Quantity__c,Lot__c,Bin__c from Lot_Product__c where Lot__c=:lotwithilpli.keySet()];
                
                System.debug('lotMap:::'+lotMap);
                Map<id,List<Lot_Product__c>>  lotproduct = new Map<id,List<Lot_Product__c>>();
                
                for(Lot_Product__c lotprorec:lotMap)
                {
                    
                    if(lotproduct.containsKey(lotprorec.id))
                    {
                        List<Lot_Product__c> tempOnelist = lotproduct.get(lotprorec.id);
                        tempOnelist.add(lotprorec);
                        lotproduct.put(lotprorec.Lot__c,tempOnelist);
                    }
                    else
                    {
                        List<Lot_Product__c> templist=new List<Lot_Product__c>();
                        templist.add(lotprorec);
                        lotproduct.put(lotprorec.Lot__c,templist);
                    }
                }
                List<Lot_Product__c> lotproductlist = new List<Lot_Product__c>();
                List<Lot_Product__c> lotupdatelist = new List<Lot_Product__c>();
                
                for(Lot_Product__c lp:lotMap)
                {
                    system.debug('lp>>'+lp);
                    if(lotwithilpli.containskey(lp.Lot__c) && lotwithilpli.get(lp.Lot__c).containskey(lp.Bin__c))
                    {
                        
                        system.debug('lp>>'+lotwithilpli.get(lp.Lot__c).get(lp.Bin__c));
                        lp.Quantity__c-=lotwithilpli.get(lp.Lot__c).get(lp.Bin__c);
                        system.debug('lp.Quantity__c>>'+lp.Quantity__c);
                        lotupdatelist.add(lp);
                        
                        
                    }
                }
                
                update lotupdatelist;
                
                List<Product_Serial_Number__c> individualserial=[select Id, Name,Status__c from Product_Serial_Number__c where id=:individualsrno];
                List<Product_Serial_Number__c> serialnum=new List<Product_Serial_Number__c>();
                
                for(Product_Serial_Number__c slnm:individualserial)
                {
                    Product_Serial_Number__c snum=new Product_Serial_Number__c();
                    snum.id=slnm.id;
                    snum.Status__c='Unavailable';
                    serialnum.add(snum);
                }
                update serialnum;//updating individual serial no status
                Inventory_Location_Product__c bomproductupdate;
                if(BomILPList.size()>0)
                {
                    BomILPListif = new List<Inventory_Location_Product__c>();
                    
                    for(Inventory_Location_Product__c ILP: BomILPList)
                    {
                        bomproductupdate = new Inventory_Location_Product__c();
                        bomproductupdate.Id = ILP.Id;
                        if(ILP.AdjustedReceivedqty__c == null)
                        {
                            ILP.AdjustedReceivedqty__c =0; 
                        }
                        bomproductupdate.AdjustedReceivedqty__c = ILP.AdjustedReceivedqty__c +values.UpdateStockNum;
                        bomproductupdate.Products__c=values.productinventory.ProductCode__c;
                        bomproductupdate.Source_Type__c = 'Manual';
                        bomproductupdate.Inventory_Location__c=ILP.Inventory_Location__c;
                        BomILPListif.add(bomproductupdate);
                        values.productinventory.Comments__c='Inventory Increased due to conversion from INDIVIDUALS to BOM';
                        system.debug('values.productinventory1>>'+values.productinventory);
                    }
                    update values.productinventory; 
                    update BomILPListif;//updating bom ilp if loc exist
                }
                else
                {
                    BomILPList = new List<Inventory_Location_Product__c>();
                    bomproductupdate=new Inventory_Location_Product__c();
                    
                    if(bomproductupdate.AdjustedReceivedqty__c==null)
                    {
                        
                        bomproductupdate.AdjustedReceivedqty__c=0;
                    }
                    bomproductupdate.Inventory__c=values.productinventory.id;
                    bomproductupdate.Inventory_Location__c=values.bomloc;
                    bomproductupdate.AdjustedReceivedqty__c=bomproductupdate.AdjustedReceivedqty__c +values.UpdateStockNum;
                    system.debug('values.productinventory.ProductCode__c-->'+values.productinventory.ProductCode__c);
                    bomproductupdate.Products__c=values.productinventory.ProductCode__c;
                    bomproductupdate.Source_Type__c='Manual';
                    BomILPList.add(bomproductupdate);
                    
                    values.productinventory.Comments__c='Inventory Increased due to conversion from INDIVIDUALS to BOM ';
                    system.debug('values.productinventory2>>'+values.productinventory);
                    update values.productinventory;
                    
                    insert BomILPList;//insert bom ilp 
                    system.debug('BomILPList--->'+BomILPList);
                }
                List<Inventory_Location_Product__c> updateILPqtyList = [select id, name, Received_Quantity__c,Inventory__c,Inventory_Location__c,AvailableAdjustedQty__c, Source_Type__c from Inventory_Location_Product__c where id In: ilpqty.keySet() ];
                set<Id> InvIdList=new set<Id>();
                for(Inventory_Location_Product__c ilpitem : updateILPqtyList )
                {
                    if(ilpitem.AvailableAdjustedQty__c ==null)
                    {
                        ilpitem.AvailableAdjustedQty__c  = 0;
                    }
                    ilpitem.AvailableAdjustedQty__c=ilpitem.AvailableAdjustedQty__c+ ilpqty.get(ilpitem.id);
                    ilpitem.Source_Type__c = 'Manual';
                    InvIdList.add(ilpitem.Inventory__c);
                }
                
                List<Inventory__c> invList=new List<Inventory__c>();
                for(id invId:InvIdList)
                {
                    Inventory__c inv=new Inventory__c();
                    inv.id=invId;
                    inv.Comments__c='Inventory Reduced due to conversion from INDIVIDUALS to BOM';
                    invList.add(inv);
                }
                update invList;
                
                update updateILPqtyList;//updating individual ilp
                
                
                
                Inventory_Location_Product__c BomILPforILPLI = [select Id, Name, Products__c,Inventory_Location__c,Inventory_Location_Name__c, Received_Quantity__c, Source_Type__c from Inventory_Location_Product__c where Products__c =: values.productinventory.ProductCode__c AND Inventory_Location__c =: values.bomloc limit 1];
                
                List<Inventory_Location_Product_Line_Item__c> IlpliList = new List<Inventory_Location_Product_Line_Item__c>();
                system.debug('values.productinventory.ProductCode__r.Attribute_Type__c>>>>>>>'+values.productinventory.Description__c);
                if(values.productinventory.ProductCode__r.Attribute_Type__c == 'SERIALIZED')
                {
                    List<Product_Serial_Number__c>  bomPsnList = new List<Product_Serial_Number__c>();
                    Set<String> slnum = new Set<String>();
                    System.debug('strList.size::'+strList.size());
                    for(Integer j=0; j<strList.size(); j++)
                    {
                        List<String> stringList2 = strList[j].split(',');
                        String str2 = serial.substring(1, serial.length()-1);
                        
                        String str = strList[j];
                        Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(str);
                        rootProLoc= (Map<String, Object>) JSON.deserializeUntyped(str);
                        
                        Product_Serial_Number__c bomPsn = new Product_Serial_Number__c();
                        System.debug('root::'+root.get('code'));
                        if(root.get('code') !=null)
                        {
                            bomPsn.Serial_Number__c = String.valueOf(root.get('code'));
                        }
                        slnum.add(bomPsn.Serial_Number__c);
                        bomPsn.Inventory_Location_Product__c = BomILPforILPLI.id;
                        bomPsn.Product_Code__c = BomILPforILPLI.Products__c;
                        bomPsn.Lot__c=values.bomlot;
                        bomPsn.Bin__c=binId;
                        bomPsn.Inventory_Location__c=BomILPforILPLI.Inventory_Location__c;
                        bomPsnList.add(bomPsn);
                    }
                    System.debug('bomPsnList::'+bomPsnList);
                    
                    insert bomPsnList; //inserting bom serial no
                    set<id> serialrec=new  set<id>();
                    for(Product_Serial_Number__c serialno:bomPsnList)
                    {
                        serialrec.add(serialno.id);
                    }
                    System.debug('bomPsnList::'+bomPsnList);
                    List<Product_Serial_Number__c> InsertedPsns= [select id, Serial_Number__c,Bin__c,Inventory_Location__c,Unit_Price__c,Inventory_Location_Product__c,Inventory_Location_Product__r.Inventory_Location__c, Product_Code__c from Product_Serial_Number__c where id =: serialrec];
                    for(Product_Serial_Number__c psn : InsertedPsns)
                    {
                        	Inventory_Location_Product_Line_Item__c IlpliWithPsn = new Inventory_Location_Product_Line_Item__c();
                        	system.debug('create new ilpli-->'+IlpliWithPsn.Unit_Price__c);
                            if(IlpliWithPsn.AdjustedReceivedqty_c__c==null)
                            {
                                IlpliWithPsn.AdjustedReceivedqty_c__c   =0;
                            }
                            IlpliWithPsn.Inventory_Location_Product__c = psn.Inventory_Location_Product__c;
                            IlpliWithPsn.Inventory_Location__c=psn.Inventory_Location_Product__r.Inventory_Location__c;
                            IlpliWithPsn.Product__c = psn.Product_Code__c;
                            IlpliWithPsn.Product_Serial_Number__c = psn.id;
                            IlpliWithPsn.AdjustedReceivedqty_c__c = 1;
                            IlpliWithPsn.Bin__c=binId;
                            IlpliWithPsn.Unit_Price__c=Totunitprice/updateBomQty;
                            system.debug('IlpliWithPsn.Unit_Price__c-->'+IlpliWithPsn.Unit_Price__c);
                            IlpliWithPsn.Lot__c=values.bomlot;
                            IlpliWithPsn.Stock_Type__c='Bom Conversion';
                            IlpliList.add(IlpliWithPsn);
                        	system.debug('after adding IlpliList1---->'+IlpliList);
                    }
                }
                else
                {
                    List<Inventory_Location_Product_Line_Item__c>  Ilpliupdate=[select Id,Lot__c, sigmaerpdev2__Inventory_Location__c,Name,Unit_Price__c,Inventory_Location_Product__c, Received_Quantity__c,AdjustedReceivedqty_c__c ,AvailableAdjustedQty__c,Bin__c  from Inventory_Location_Product_Line_Item__c where Inventory_Location_Product__c =: BomILPforILPLI.id limit 1];
                    List<Inventory_Location_Product_Line_Item__c> Ilpliupdatelist = new List<Inventory_Location_Product_Line_Item__c>();
                    if(Ilpliupdate.size()>0)
                    {
                        for(Inventory_Location_Product_Line_Item__c ILPli: Ilpliupdate)
                        {
                            system.debug('ILPli--->'+ILPli);
                            Inventory_Location_Product_Line_Item__c IlpliWithOPsn = new Inventory_Location_Product_Line_Item__c();
                          //  system.debug('values.bomlot---->'+ILPLIunitprice.get(ILPli.Inventory_Location__c));
                         //   system.debug('values.bomlot---->'+ILPLIunitprice.get(ILPli.Inventory_Location__c).get(ILPli.Bin__c));
                            system.debug('values.bomlot---->'+values.bomlot + 'binId>>>'+binId +'unitprice>>'+ILPli.Unit_Price__c);
                            if(ILPli.Lot__c==values.bomlot && ILPli.Bin__c==binId && ILPli.Unit_Price__c==Totunitprice )
                            {
                                
                                    system.debug('ILPli.Lot__c---->'+ILPli.Lot__c + 'ILPli.Bin__c>>>'+ILPli.Bin__c);
                                    if(ILPli.AdjustedReceivedqty_c__c ==null)
                                    {
                                        ILPli.AdjustedReceivedqty_c__c =0;
                                    }
                                    ILPli.Inventory_Location_Product__c = BomILPforILPLI.id;
                                    ILPli.Product__c = BomILPforILPLI.Products__c;
                                    ILPli.Inventory_Location__c=BomILPforILPLI.Inventory_Location__c;
                                    ILPli.AdjustedReceivedqty_c__c = ILPli.AdjustedReceivedqty_c__c +values.UpdateStockNum;
                                 	ILPli.Unit_Price__c=Totunitprice/updateBomQty;
                                 	system.debug('after adding ILPli.Unit_Price__c---->'+ILPli.Unit_Price__c); 
                                    ILPli.Stock_Type__c='Bom Conversion';
                                    Ilplilist.add(ILPli);
                                    system.debug('after adding ILPli---->'+Ilplilist); 
                             }      
                            else
                            {
                               system.debug('21create new ilpli else'+values.bomlot);
                                if(IlpliWithOPsn.AdjustedReceivedqty_c__c ==null)
                                {
                                    IlpliWithOPsn.AdjustedReceivedqty_c__c  =0;
                                }
                                IlpliWithOPsn.Inventory_Location_Product__c = BomILPforILPLI.id;
                                IlpliWithOPsn.Inventory_Location__c=BomILPforILPLI.Inventory_Location__c;
                                IlpliWithOPsn.Product__c = BomILPforILPLI.Products__c;
                                IlpliWithOPsn.Bin__c=binId;
                                IlpliWithOPsn.AdjustedReceivedqty_c__c = IlpliWithOPsn.AdjustedReceivedqty_c__c+values.UpdateStockNum;
                                IlpliWithOPsn.Unit_Price__c=Totunitprice/updateBomQty;
                                IlpliWithOPsn.Lot__c=values.bomlot;
                                IlpliWithOPsn.Stock_Type__c='Bom Conversion';
                                IlpliList.add(IlpliWithOPsn);
                                system.debug('after adding IlpliWithOPsn to IlpliList---->'+IlpliList);
                            }
                        }
                    }
                    else
                    {
                        Inventory_Location_Product_Line_Item__c IlpliWithOPsn = new Inventory_Location_Product_Line_Item__c();
                        system.debug('21create new ilpli else'+values.bomlot);
                        if(IlpliWithOPsn.AdjustedReceivedqty_c__c ==null)
                        {
                            IlpliWithOPsn.AdjustedReceivedqty_c__c  =0;
                        }
                        IlpliWithOPsn.Inventory_Location_Product__c = BomILPforILPLI.id;
                        IlpliWithOPsn.Inventory_Location__c=BomILPforILPLI.Inventory_Location__c;
                        IlpliWithOPsn.Product__c = BomILPforILPLI.Products__c;
                        IlpliWithOPsn.Bin__c=binId;
                        IlpliWithOPsn.AdjustedReceivedqty_c__c = IlpliWithOPsn.AdjustedReceivedqty_c__c+values.UpdateStockNum;
                        IlpliWithOPsn.Unit_Price__c=Totunitprice/updateBomQty;
                        IlpliWithOPsn.Lot__c=values.bomlot;
                        IlpliWithOPsn.Stock_Type__c='Bom Conversion';
                        IlpliList.add(IlpliWithOPsn);
                        system.debug('after adding IlpliWithOPsn to IlpliList---->'+IlpliList);
                    }   
                }
                upsert IlpliList;//upserting bom ilpli    --Inserting/upserting  bom product ilpli
                
                
                
                //code added on 20-03-2020 to handle Average Buying Price in Product Inventory
                set<id> ProdTypeid=new set<id>();//created by rashmi to restrict Attribute type changing after updating inventories on 04-04-2020
                list<Inventory_Location_Product_Line_Item__c>  lneItem=[select Product__c,Stock_Type__c, Attribute_Type__c,Unit_Price__c from Inventory_Location_Product_Line_Item__c where Product__c =: values.productinventory.ProductCode__c  ];
                system.debug('lneItem>>'+lneItem);
                map<id,decimal> prolist=new map<id,decimal>();
                map<id,decimal> ilplilist1 =new map<id,decimal>();  
                
                system.debug('lneItem>>>'+lneItem);
                
                for(Inventory_Location_Product_Line_Item__c prores :lneItem)
                {   
                    ProdTypeid.add(prores.Product__c);//adding Bom product ids to the set
                    system.debug('ProdTypeid>>>>'+ProdTypeid);
                    system.debug('prores>>>>'+prores);
                    system.debug('prores>>>'+prolist.containsKey(prores.Product__c));
                    
                    if(prolist.containsKey(prores.Product__c))
                    {
                        system.debug('prores up>>>'+prores.Unit_Price__c);
                        decimal unitprice=prolist.get(prores.Product__c);
                        system.debug('unitprice>>>'+unitprice);
                        prolist.put(prores.Product__c,unitprice+prores.Unit_Price__c);
                        system.debug('prolistsss'+prolist);
                    }
                    else
                    {
                        system.debug('prores up2>>>'+prores.Unit_Price__c);
                        prolist.put(prores.Product__c,prores.Unit_Price__c);
                        system.debug('prolist>>>'+prolist);
                    }
                    if(ilplilist1.containsKey(prores.Product__c))
                    {
                        decimal counts=ilplilist1.get(prores.Product__c);
                        ilplilist1.put(prores.Product__c,counts+1);
                        system.debug('ilplilist111'+counts);
                    }
                    else
                    {
                        ilplilist1.put(prores.Product__c,1);
                    }
                    
                    
                }
                
                
                List<Inventory__c> productList = [select id, Name, ProductCode__c,Avg_Buying_Price__c, Total_Available_Qty__c, Available_Qty__c, ProductCode__r.Attribute_Type__c from Inventory__c where ProductCode__c =: values.productinventory.ProductCode__c ];
                system.debug('productList>>>>>'+productList);
                
                for(Inventory__c invId1 : productList)
                {
                    
                    invId1.Avg_Buying_Price__c=prolist.get(invId1.ProductCode__c)/ilplilist1.get(invId1.ProductCode__c);
                    system.debug('invId1.ProductCode__c'+invId1.Avg_Buying_Price__c);
                }
                
                update productList; 
                
                //ends here
                //code added by rashmi on 04-04-2020 to restrict changing attribute type after inventory updates
                List<Product2> Listprodtype;
                Listprodtype =[select id,Name,Typecheck__c from Product2 where Typecheck__c=false and id =:ProdTypeid ];
                system.debug('Listprodtype>>'+Listprodtype);
                 for(Product2 typeOfProd:Listprodtype){
                    typeOfProd.Typecheck__c=true;
                }  
                if(Listprodtype.size()>0)
                {
                     upsert Listprodtype;
                }
                //code ends here
                
                system.debug('after inserting IlpliList2---->'+IlpliList);
                Lot__c bomlot=new Lot__c();
                System.debug('values.bomlot'+values.bomlot);
                List<Lot_Product__c> lotprolist=new List<Lot_Product__c>();
                List<Lot_Product__c> lotprolistinsert=new List<Lot_Product__c>();
                if(values.bomlot!=null)
                {
                    bomlot=[Select id,name,(select id,name,Quantity__c,Location__c,Bin__c,Lot__c from Lot_Products__r) from Lot__c where id=:values.bomlot];
                    system.debug('after qurrying bomlot-->'+bomlot);
                    Lot_Product__c test = new  Lot_Product__c();
                    test=null;
                    for(Lot_Product__c lotproduct1:bomlot.Lot_Products__r)
                    {
                        system.debug('after iterating lotproduct1-->'+lotproduct1);
                        system.debug('before checking Location1-->'+lotproduct1.Location__c);
                        system.debug('before checking Location2-->'+values.bomloc);
                        system.debug('before checking  Bin__c1-->'+lotproduct1.Bin__c);
                        system.debug('before checking  Bin__c2-->'+binId);
                        
                        if(lotproduct1.Location__c==values.bomloc &&  lotproduct1.Bin__c==binId)
                        {
                            test=lotproduct1;
                        }
                    }
                    if(test==null)
                    {
                        system.debug('test is-->'+test);
                        Lot_Product__c lotproductdata=new Lot_Product__c();
                        lotproductdata.Lot__c=values.bomlot;
                        lotproductdata.Bin__c=binId;
                        lotproductdata.Location__c=values.bomloc;
                        lotproductdata.Product__c=values.productinventory.ProductCode__c;
                        lotproductdata.Quantity__c=values.UpdateStockNum;
                        lotprolistinsert.add(lotproductdata);
                        system.debug('lotprolistinsert-->'+lotprolistinsert);
                    }else
                    {
                        test.Quantity__c+=values.UpdateStockNum;
                        lotprolist.add(test);
                        system.debug('lotprolist-->'+lotprolist);
                    } 
                }
                
                
                
                update lotprolist;
                system.debug('after lotprolist update-->'+lotprolist);
                
                insert lotprolistinsert;
                system.debug('after lotprolistinsert update-->'+lotprolistinsert);
                
                values.message = 'Success';
                system.debug('Ilpliwithqty--->'+Ilpliwithqty);
                system.debug('IlpliList--->'+IlpliList);
                system.debug('bomproductupdate--->'+bomproductupdate);
                system.debug('updateBomQty--->'+updateBomQty);
                system.debug('BomProdIds-->'+BomProdIds);
                LinkageServiceClass.financeIndiviualToBom(Ilpliwithqty,IlpliList,bomproductupdate,updateBomQty,BomProdIds);
                return values;
                
            }
            
            catch(Exception e)
            {
                system.debug('e>>>'+e);
                Database.rollback(sp);
                
                system.debug('e>>>'+e.getMessage().contains('DUPLICATE_VALUE, duplicate value found: sigmaerpdev2__Serial_Number__c'));
                 try{
                        if(e.getMessage().contains('DUPLICATE_VALUE, duplicate value found:'))
                        {
                            String subStringId=e.getMessage().substringBetween('id: ',': []');
                            system.debug('subStringId-->>'+subStringId);
                            Product_Serial_Number__c psn=[select Id,Serial_Number__c from Product_Serial_Number__c where id=:subStringId];
                            system.debug('psn--->>'+psn);
                            values.duplicateSerialNo=psn.Serial_Number__c;
                            system.debug('values.duplicateSerialNo--->>'+values.duplicateSerialNo);
                        }
                }
                catch(Exception ecs){
                    
                }
                values.message = 'error';
                values.data = e.getMessage()+ ', At Line number '+e.getStackTraceString()+ 'response is-->' +values.message ;
                system.debug('values.data-->'+values.data);
                return values;
                
                
            }
        }
        
        return values;
    }
    
    
    
}