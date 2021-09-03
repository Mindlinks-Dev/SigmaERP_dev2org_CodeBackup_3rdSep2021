/*------------------------------------------------------------
Author: <Anuja Tupale>
Company: Mindlinks Solution
Description: converting bom product to individual product

------------------------------------------------------------*/

public with sharing class  ConvertBOMToIndividualCntrl
{
    public class WrapperstockInProductList
    {
        @AuraEnabled
        public Inventory_Location_Product__c record {get;set;}
        @AuraEnabled
        public Boolean IsPIupdate;
        @AuraEnabled
        public Integer convertedQty {get;set;}
        @AuraEnabled
        public String Targetloc {get;set;}
        @AuraEnabled
        public String fromLot {get;set;} //added on 11-11-2019 to handle bin In Bom to Individual
        @AuraEnabled
        public String fromBin {get;set;} //added on 11-11-2019 to handle bin In Bom to Individual
        @AuraEnabled
        public List<BOMlineitem> IndPros {get;set;}
        @AuraEnabled
        public List<InnerWrapperLineItemILP> eachLineItemILPLIWrapper{get;set;}
        @auraEnabled
        public String message{get;set;}
        @auraEnabled
        public String data{get;set;}
        @auraEnabled
        public String duplicateSerialNo{get;set;}
    }
    public class InnerWrapperLineItemILP
    {
        @AuraEnabled
        public Inventory_Location_Product_Line_Item__c eachLineItemILPLI {get;set;} 
        @AuraEnabled    
        public Integer pickQty {get;set;}
        
        
    }
    public class BOMlineitem
    {
        @AuraEnabled    
        public BOM_Line_Item__c indpro {get;set;}
        @AuraEnabled
        public Decimal updqtydisplay {get;set;}
        @AuraEnabled    
        public String lot {get;set;}
        @AuraEnabled    
        public String bin {get;set;}
        @AuraEnabled
        public Decimal unitPrice {get;set;}
        @AuraEnabled
        public List<Product_Serial_Number__c> eachserialNo {get;set;}
    }
    //get ilp data
    @AuraEnabled
    public static WrapperstockInProductList getilpData(string ilpId)
    { 
        system.debug('ilpId-->>'+ilpId);
        WrapperstockInProductList ilp;
        Savepoint sp;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__BOM_Line_Item__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'Id','Name','sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Products__c','sigmaerpdev2__Products__r.sigmaerpdev2__Type__c','sigmaerpdev2__Products__r.sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Products__r.Name','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Inventory_Location_Name__c','sigmaerpdev2__AvailableAdjustedQty__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Inventory_Location__r.Name','sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__BOM_Line_Item__c',new Set<String>{'Id','Name','sigmaerpdev2__Products__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Product__r.Name'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'Id','Name','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Lot__r.Name','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Expiry_Date__c','sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__Product_Serial_Number__c','sigmaerpdev2__Product_Serial_Number__r.Name','sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__AvailableAdjustedQty__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Bin__r.Name','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.Name'}))
        {
            system.debug('ilp::');
            
            List<Inventory_Location_Product__c> ilpdatalist = new List<Inventory_Location_Product__c>();
            system.debug('ilp::'+ ilpdatalist);
            ilpdatalist=[SELECT Id,Name,Attribute_Type__c,Products__c,Products__r.Type__c,Products__r.Attribute_Type__c,Products__r.Name,Net_Quantity__c,AvailableAdjustedQty__c,Inventory_Location_Name__c,Inventory_Location__c,Inventory_Location__r.Name,Inventory_Location__r.Location__c from Inventory_Location_Product__c where id =:ilpId and Products__r.recordType.Name='BOM'];
            system.debug('ilpdatalist-->'+ilpdatalist);
            
            
            Inventory_Location_Product__c ilpdata=new Inventory_Location_Product__c();
            
            List<InnerWrapperLineItemILP> InnerWrapperLineItemILPList = new List<InnerWrapperLineItemILP>();
            List<BOMlineitem> BOMproitems=new List<BOMlineitem>();
            
            if(ilpdatalist.size()>0)
            {
                ilpdata= ilpdatalist[0];
                
                
                system.debug('ilpdata::'+ilpdata);
                system.debug('ilpdata::'+ ilpdata.Products__c);
                List<BOM_Line_Item__c> lineitm=new List<BOM_Line_Item__c>();
                lineitm=[select Id,Name,Products__c,Quantity__c,Product__c,Product__r.Name,Product__r.Attribute_Type__c from BOM_Line_Item__c where Products__c =:ilpdata.Products__c];
                System.debug('lineitm-->>'+lineitm);
                
                List<Inventory_Location_Product_Line_Item__c> ilplidata=new List<Inventory_Location_Product_Line_Item__c>();
                ilplidata =[select Id, Name,Unit_Price__c,Inventory_Location_Product__c,Lot__c,Lot__r.Name,Received_Quantity__c,  Expiry_Date__c, Available_Quantity__c, Product_Serial_Number__c,Product_Serial_Number__r.Name,Attribute_Type__c,AvailableAdjustedQty__c,Bin__c,Bin__r.Name,Product__c,Product__r.Name   from Inventory_Location_Product_Line_Item__c where  Inventory_Location_Product__c=:ilpdata.id AND Available_Quantity__c > 0];
                system.debug('ilplidata-->>'+ilplidata);
                
                for(Inventory_Location_Product_Line_Item__c eachilp : ilplidata)
                {
                    system.debug('eachilp-->>'+eachilp);
                    if(eachilp.Available_Quantity__c >0 && eachilp.Available_Quantity__c != null)
                    {   
                        InnerWrapperLineItemILP ilpli = new InnerWrapperLineItemILP();
                        ilpli.eachLineItemILPLI=eachilp;
                        InnerWrapperLineItemILPList.add(ilpli);
                    }
                }
                system.debug('InnerWrapperLineItemILPList-->>' +InnerWrapperLineItemILPList);
                
                for(BOM_Line_Item__c bomline:lineitm)
                {
                    BOMlineitem indproduct=new BOMlineitem();
                    indproduct.indpro=bomline;
                    BOMproitems.add(indproduct);
                }
            }
            ilp=new WrapperstockInProductList();
            ilp.record=ilpdata;
            ilp.eachLineItemILPLIWrapper=InnerWrapperLineItemILPList;
            system.debug('ilp.eachLineItemILPLIWrapper-->>'+ilp.eachLineItemILPLIWrapper);
            ilp.IndPros=BOMproitems;
            system.debug('ilp-->>>'+ilp);
        }
        return ilp;
    }
    
    //save data
    @AuraEnabled
    public static WrapperstockInProductList savedata(string wrapperdata)
    {
        WrapperstockInProductList values;
        Savepoint sp;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__BOM_Line_Item__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Lot__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Lot_Product__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Serial_Number__c')
           
           
           && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'Id','Name'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__BOM_Line_Item__c',new Set<String>{'Id','Name','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'Id','Name','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__ProductCode__c','sigmaerpdev2__Comments__c','sigmaerpdev2__Total_Qty__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'Id','Name','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Products__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Source_Type__c','sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__AdjustedReceivedqty__c','sigmaerpdev2__AvailableAdjustedQty__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'sigmaerpdev2__AvailableAdjustedQty__c','sigmaerpdev2__Product_Serial_Number__c','sigmaerpdev2__Lot__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot__c',new Set<String>{'Id','name','sigmaerpdev2__Product__c','sigmaerpdev2__Inventory_Location__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot_Product__c',new Set<String>{'Id','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Location__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Bin__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Serial_Number__c',new Set<String>{'Id','Name','sigmaerpdev2__Status__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Serial_Number__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Product_Code__c'})
           
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new Set<String>{'sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Comments__c','sigmaerpdev2__ProductCode__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev2__Products__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Inventory__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__AdjustedReceivedqty__c','sigmaerpdev2__AvailableAdjustedQty__c','sigmaerpdev2__Source_Type__c'})           
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'sigmaerpdev2__Product_Serial_Number__c','sigmaerpdev2__AdjustedReceivedqty_c__c','sigmaerpdev2__Product__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__AvailableAdjustedQty__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Unit_Price__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Lot_Product__c',new Set<String>{'sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Location__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Bin__c'})           
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Serial_Number__c',new Set<String>{'sigmaerpdev2__Status__c','sigmaerpdev2__Serial_Number__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Product_Code__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Location__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Bin__c'}))
            
        {
            
            try{
                system.debug('inside fls ');
                sp = Database.setSavepoint();
                values = (WrapperstockInProductList)JSON.deserialize(wrapperdata, WrapperstockInProductList.class);
                system.debug('values >>>'+values.IndPros);
                
                List<Product2> BOM = new List<Product2>();
                List<Product2> Prodlist = new List<Product2>();
                set<id> ProdTypeid=new set<id>();//created by rashmi to restrict Attribute type changing after updating inventories on 04-04-2020
                Id bomproductid=values.record.Products__c;
                
                BOM = [select Id, Name,(select Id, Name, Product__c, Quantity__c from Line_Items__r),(select Id, Name, Available_Qty__c, Total_Available_Qty__c, ProductCode__c from Product_Inventory__r limit 1) from Product2 where Id =:values.record.Products__c];
                system.debug('BOM>>'+BOM);
                List<Inventory__c> BOMInventoryList = new List<Inventory__c>();
                List<Inventory__c> UpdateBOMInventoryList = new List<Inventory__c>();  
                List<Inventory__c> ProInventoryList = new List<Inventory__c>();
                List<Inventory__c> UpdateProInventoryList = new List<Inventory__c>();
                
                for(Product2 i : BOM)
                {
                    BOMInventoryList.add(i.Product_Inventory__r);
                }
                system.debug('BOMInventoryList '+BOMInventoryList);
                for(Inventory__c iv : BOMInventoryList)
                {
                    system.debug('BOM pro iv >>>'+iv);
                    if ((Schema.sObjectType.Inventory__c.isAccessible()) &&
                        (Schema.sObjectType.Inventory__c.fields.Comments__c.isAccessible()) &&
                        (Schema.sObjectType.Inventory__c.fields.Comments__c.isCreateable()) &&
                        (Schema.sObjectType.Inventory__c.fields.Comments__c.isUpdateable()))
                    {
                        iv.Comments__c = 'Inventory Reduced due to conversion from BOM to INDIVIDUALS';
                    }
                    
                    UpdateBOMInventoryList.add(iv);
                }
                system.debug('Update BOM pro InventoryList >>>'+UpdateBOMInventoryList);
                system.debug('BOM >>>'+BOM);
                Map<id,Integer> lineitemqty=new Map<id,Integer>();
                Map<id,Decimal> IndProdQty=new Map<id,Decimal>();
                for(Product2 bomline:BOM)
                {
                    system.debug('bomline >>>'+bomline);
                    for(BOM_Line_Item__c lineitem:bomline.Line_Items__r)
                    {
                        lineitemqty.put(lineitem.Product__c,Integer.valueof(lineitem.Quantity__c));
                    } 
                }
                system.debug('lineitemqty >>>'+lineitemqty);
                
                Prodlist = [select Id, Name,(select Id, Name, Comments__c,Available_Qty__c, Total_Available_Qty__c, Total_Qty__c, ProductCode__c from Product_Inventory__r limit 1) from Product2 where Id IN : lineitemqty.keyset()];
                System.debug('Prodlist>>:::'+Prodlist); 
                Map<id,id> indpi=new Map<id,id>();
                Decimal updateIndQty ;
                
                
                for(Product2 pi1 : Prodlist)
                {
                    ProInventoryList.add(pi1.Product_Inventory__r);
                    
                }
                system.debug('ProInventoryList >>>'+ProInventoryList);
                for(Inventory__c v : ProInventoryList)
                {
                    indpi.put(v.ProductCode__c,v.id);
                    system.debug('product id-->>1'+lineitemqty.get(v.ProductCode__c));
                    updateIndQty = lineitemqty.get(v.ProductCode__c)*values.convertedQty; 
                    system.debug('product id-->>2'+indpi.get(v.ProductCode__c));
                    
                    System.debug('updateIndQty value>>:::'+updateIndQty); 
                    
                    v.Available_Qty__c = v.Available_Qty__c + updateIndQty; 
                    System.debug('v.Available_Qty__c--->'+ v.Available_Qty__c); 
                    if ((Schema.sObjectType.Inventory__c.isAccessible()) &&
                        (Schema.sObjectType.Inventory__c.fields.Comments__c.isAccessible()) &&
                        (Schema.sObjectType.Inventory__c.fields.Comments__c.isCreateable()) &&
                        (Schema.sObjectType.Inventory__c.fields.Comments__c.isUpdateable()))
                    {
                        v.Comments__c = 'Inventory increased due to conversion from BOM to INDIVIDUALS';
                    }
                    UpdateProInventoryList.add(v); 
                    
                }
                System.debug(' UpdateProInventoryList:::'+UpdateProInventoryList); 
                Inventory_Location_Product__c ilp=values.record;
                List<Inventory_Location_Product__c> listofILP=new List<Inventory_Location_Product__c>();
                System.debug(' ilp:::'+ilp);
                if(ilp.AvailableAdjustedQty__c==null)
                {
                    ilp.AvailableAdjustedQty__c=0;
                }
                if ((Schema.sObjectType.Inventory_Location_Product__c.isAccessible()) &&
                    (Schema.sObjectType.Inventory_Location_Product__c.fields.AvailableAdjustedQty__c.isAccessible()) &&
                    (Schema.sObjectType.Inventory_Location_Product__c.fields.AvailableAdjustedQty__c.isCreateable()) &&
                    (Schema.sObjectType.Inventory_Location_Product__c.fields.AvailableAdjustedQty__c.isUpdateable()))
                {
                    ilp.AvailableAdjustedQty__c=ilp.AvailableAdjustedQty__c+values.convertedQty;
                    ilp.Source_Type__c = 'Manual';
                }
                System.debug(' ilp:::'+ilp);
                List<InnerWrapperLineItemILP> BOMILPList =values.eachLineItemILPLIWrapper;
                System.debug(' BOMILPList:::'+ilp);
                List<Inventory_Location_Product_Line_Item__c> bomilpli=new List<Inventory_Location_Product_Line_Item__c>();
                List<id> Bomserialid=new List<id>();
                Map<Id, Decimal>  Lotqtymap = new Map<Id, Decimal>();
                Map<id,decimal> Ilpliwithqty=new Map<id,decimal>();
                Map<Id, Map<Id,Decimal>>  Lotqtymap1 = new Map<Id,  Map<Id,Decimal>>();
                System.debug(' BOMILPList:::'+ilp);
                Map<Id, Decimal>  productqtymap = new Map<Id, Decimal>();
                Map<Id,Id> BomProdId =new Map<Id,Id>();
                
                for(InnerWrapperLineItemILP ilplidata:BOMILPList)
                {
                    System.debug(' ilplidata:::'+ilplidata);
                    
                    if(productqtymap.containsKey(ilplidata.eachLineItemILPLI.Product__c))
                    {
                        if(ilplidata.pickQty!=null)
                            productqtymap.put(ilplidata.eachLineItemILPLI.Product__c,productqtymap.get(ilplidata.eachLineItemILPLI.Product__c)+ilplidata.pickQty);
                        system.debug('productqtymap1-->>'+productqtymap);
                    }
                    else{
                        if(ilplidata.pickQty!=null)
                            productqtymap.put(ilplidata.eachLineItemILPLI.Product__c,ilplidata.pickQty);
                        system.debug('productqtymap2-->>'+productqtymap);
                    }
                    System.debug(' productqtymap---->>>>>>'+productqtymap);
                    System.debug('ilplidata.pickQty'+ilplidata.pickQty); 
                    
                    if(ilplidata.pickQty>0)
                    {
                        Inventory_Location_Product_Line_Item__c  wrapEachIlp = new Inventory_Location_Product_Line_Item__c();
                        wrapEachIlp.Id =ilplidata.eachLineItemILPLI.id;
                        wrapEachIlp.Product__c=ilplidata.eachLineItemILPLI.Product__c;
                        system.debug('wrapEachIlp.Unit_Price__c-->'+ilplidata.eachLineItemILPLI.Unit_Price__c);
                        wrapEachIlp.Unit_Price__c=ilplidata.eachLineItemILPLI.Unit_Price__c;
                        system.debug('wrapEachIlp.Unit_Price__c-->'+ilplidata.eachLineItemILPLI.Unit_Price__c);
                        system.debug('ILP1--->'+ilplidata.eachLineItemILPLI.Inventory_Location_Product__c);
                        wrapEachIlp.Inventory_Location_Product__c=ilplidata.eachLineItemILPLI.Inventory_Location_Product__c;
                        system.debug('ILP2--->'+ilplidata.eachLineItemILPLI.Inventory_Location_Product__c);
                        
                        if(ilplidata.eachLineItemILPLI.AvailableAdjustedQty__c ==null)
                        {
                            ilplidata.eachLineItemILPLI.AvailableAdjustedQty__c  = 0;
                        }
                        wrapEachIlp.AvailableAdjustedQty__c =ilplidata.eachLineItemILPLI.AvailableAdjustedQty__c+ilplidata.pickQty;
                        Bomserialid.add(ilplidata.eachLineItemILPLI.Product_Serial_Number__c);
                        ProdTypeid.add(ilplidata.eachLineItemILPLI.Product__c);
                        bomilpli.add(wrapEachIlp);
                        System.debug(' wrapEachIlp:::'+wrapEachIlp);
                        
                        Ilpliwithqty.put(ilplidata.eachLineItemILPLI.Id,ilplidata.pickQty);
                        system.debug('Ilpliwithqty--->'+Ilpliwithqty);
                        BomProdId.put(ilplidata.eachLineItemILPLI.Id,ilplidata.eachLineItemILPLI.Product__c);
                        system.debug('BomProdId--->'+BomProdId);
                        
                        
                        //To reduce Lot
                        if(ilplidata.eachLineItemILPLI.Lot__c !=null)
                        {
                            if(Lotqtymap1.containsKey(ilplidata.eachLineItemILPLI.Lot__c)){
                                System.debug(' Lotqtymap1:::'+Lotqtymap1);
                                Map<Id,Decimal> map2=Lotqtymap1.get(ilplidata.eachLineItemILPLI.Lot__c);
                                System.debug(' map2:::'+map2);
                                
                                if(map2.containsKey(ilplidata.eachLineItemILPLI.Bin__c))
                                {
                                    decimal oldval =map2.get(ilplidata.eachLineItemILPLI.Bin__c);
                                    if(ilplidata.pickQty!=null) 
                                    {
                                        decimal newval = oldval + ilplidata.pickQty;
                                        map2.put(ilplidata.eachLineItemILPLI.Bin__c, newval);
                                        Lotqtymap1.put(ilplidata.eachLineItemILPLI.Lot__c,map2);
                                    }
                                }
                                else
                                {
                                    if(ilplidata.pickQty!=null) 
                                    {
                                        /*Map<Id,Decimal> map1=new Map<Id,Decimal>();
map1.put(ilplidata.eachLineItemILPLI.Bin__c, ilplidata.pickQty);
Lotqtymap1.put(ilplidata.eachLineItemILPLI.Lot__c,map1);
System.debug(' Lotqtymap1:::'+Lotqtymap1);*/
                                        //  Map<Id,Decimal> map1=Lotqtymap1.get(ilplidata.eachLineItemILPLI.Lot__c);
                                        map2.put(ilplidata.eachLineItemILPLI.Bin__c, ilplidata.pickQty);
                                        System.debug(' map2:::'+map2);
                                        Lotqtymap1.put(ilplidata.eachLineItemILPLI.Lot__c,map2);
                                        System.debug(' Lotqtymap1:::'+Lotqtymap1);
                                        
                                        
                                    }
                                    
                                }    
                            }else{
                                if(ilplidata.pickQty!=null) 
                                {
                                    Map<Id,Decimal> map1=new Map<Id,Decimal>();
                                    map1.put(ilplidata.eachLineItemILPLI.Bin__c, ilplidata.pickQty);
                                    Lotqtymap1.put(ilplidata.eachLineItemILPLI.Lot__c,map1);
                                    System.debug(' Lotqtymap1:::'+Lotqtymap1);
                                    
                                }    
                            }
                        }
                    }
                }
                System.debug(' Bomserialid:::'+Bomserialid);
                System.debug(' bomilpli:::'+bomilpli);
                System.debug(' Lotqtymap:::'+Lotqtymap);
                System.debug(' Lotqtymap1:::'+Lotqtymap1);
                
                List<Lot_Product__c> LPData = new List<Lot_Product__c>();
                List<Lot_Product__c> LPOut = new List<Lot_Product__c>();
                LPData = [select id,Product__c,Quantity__c,Location__c,Lot__c,Bin__c  from Lot_Product__c where Lot__c = : Lotqtymap1.keySet()  AND Location__c =: ilp.Inventory_Location__c];
                
                System.debug('LPData>>>>>>>>'+LPData);
                
                for(Lot_Product__c lp: LPData)
                {
                    System.debug('Lotqtymap1.containsKey(lp.Lot__c)>>>'+Lotqtymap1.containsKey(lp.Lot__c));
                    System.debug('Lotqtymap1.get(lp.Lot__c)>>>>'+Lotqtymap1.get(lp.Lot__c));
                    System.debug('Lotqtymap1.get(lp.Bin__c)>>>>'+Lotqtymap1.get(lp.Bin__c));
                    System.debug('Lotqtymap1.get(lp.Lot__c).containsKey(lp.Bin__c)>>>'+Lotqtymap1.get(lp.Lot__c).containsKey(lp.Bin__c));
                    if(Lotqtymap1.containsKey(lp.Lot__c) && Lotqtymap1.get(lp.Lot__c).containsKey(lp.Bin__c)){
                        
                        lp.Quantity__c -= Lotqtymap1.get(lp.Lot__c).get(lp.Bin__c);
                        
                        LPOut.add(lp);
                    }
                }
                System.debug(' LPOut:::'+LPOut);
                
                if(LPOut.size()>0)
                {
                    update LPOut;
                    system.debug('after updating LPOut-->'+LPOut);
                }
                List<Product_Serial_Number__c> Bomserial = [select Id, Name,Status__c  from Product_Serial_Number__c where id =: Bomserialid];
                System.debug(' Bomserial:::'+Bomserial);
                
                List<Product_Serial_Number__c> serialnum=new List<Product_Serial_Number__c>();
                for(Product_Serial_Number__c slnm:Bomserial)
                {
                    Product_Serial_Number__c snum=new Product_Serial_Number__c();
                    snum.id=slnm.id;
                    snum.Status__c='Unavailable';
                    serialnum.add(snum);
                }
                System.debug(' serialnum:::'+serialnum);
                System.debug(' UpdateBOMInventoryList:::'+UpdateBOMInventoryList);
                System.debug(' UpdateProInventoryList:::'+UpdateProInventoryList);
                System.debug(' ilp:::'+ilp);
                System.debug(' bomilpli:::'+bomilpli);
                
                update serialnum;
                system.debug('after updating serialnum-->'+serialnum);
                
                system.debug('size of BOM PRO INV>>>'+UpdateBOMInventoryList.size());
                update UpdateBOMInventoryList;
                listofILP.add(ilp);
                system.debug('listofILP.size()-->'+listofILP.size());
                TriggerHandler.isIndvidualtoBOM='IsManualUpdatePI';
                update ilp;
                system.debug('after updating ilp-->'+ilp);
                system.debug(' iv.Comments__c -->'+ UpdateBOMInventoryList[0].Comments__c );
                system.debug('after updating UpdateBOMInventoryList-->'+UpdateBOMInventoryList);
                
                system.debug('size of Ind PRO INV>>>'+UpdateProInventoryList.size());
                if(UpdateProInventoryList.size()>0)
                {
                    system.debug('updating PI');
                    TriggerHandler.isBOMtoIndvidual='BOMTOINDIVIDUAL';
                    update UpdateProInventoryList; 
                }
                
                system.debug('after updating UpdateProInventoryList-->'+UpdateProInventoryList);
                
                update bomilpli;  
                system.debug('after updating bomilpli-->'+bomilpli);
                
                List<Inventory_Location_Product__c> ILPList = new List<Inventory_Location_Product__c>();
                ILPList = [select Id, Name, Products__c,Products__r.Attribute_Type__c, Inventory_Location__c,Source_Type__c, Received_Quantity__c,AdjustedReceivedqty__c from Inventory_Location_Product__c where Products__c IN: lineitemqty.keyset()];
                Map<Id, List<Inventory_Location_Product__c>> ILPMap = new Map<Id, List<Inventory_Location_Product__c>>();
                System.debug(' ILPList:::'+ILPList);
                
                for(Inventory_Location_Product__c individualilp:ILPList)
                {
                    System.debug(' individualilp:::'+individualilp);
                    
                    if(ILPMap.containsKey(individualilp.Products__c))
                    {
                        List<Inventory_Location_Product__c> tempOnelist = ILPMap.get(individualilp.Products__c);
                        tempOnelist.add(individualilp);
                        ILPMap.put(individualilp.Products__c,tempOnelist);
                        
                    }else
                    {
                        List<Inventory_Location_Product__c> templist=new List<Inventory_Location_Product__c>();
                        templist.add(individualilp);
                        ILPMap.put(individualilp.Products__c,templist);
                    }
                }
                System.debug(' ILPMap:::'+ILPMap);
                
                List<Inventory_Location_Product__c> indilpupdate = new  List<Inventory_Location_Product__c>();
                List<Inventory_Location_Product__c> ILPlistToInsert = new  List<Inventory_Location_Product__c>();
                System.debug(' lineitemqty:::'+lineitemqty);
                
                for(Id individualilp:lineitemqty.keyset())
                {
                    System.debug(' individualilp:::'+individualilp);
                    List<Inventory_Location_Product__c> locationlist = new List<Inventory_Location_Product__c>();
                    Inventory_Location_Product__c test = new  Inventory_Location_Product__c();
                    test=null;  
                    if(ILPMap.containsKey(individualilp))
                    {
                        locationlist = ILPMap.get(individualilp);
                        for(Inventory_Location_Product__c loc:locationlist)
                        {
                            if(loc.Inventory_Location__c == values.Targetloc)
                            {
                                test = loc ;
                                break;
                            }
                            
                        }
                    }  
                    if(test == null)
                    {
                        
                        Inventory_Location_Product__c test1 = new Inventory_Location_Product__c();
                        if ((Schema.sObjectType.Inventory_Location_Product__c.isAccessible()) &&
                            (Schema.sObjectType.Inventory_Location_Product__c.fields.Products__c.isAccessible()) &&
                            (Schema.sObjectType.Inventory_Location_Product__c.fields.Products__c.isCreateable()) &&
                            (Schema.sObjectType.Inventory_Location_Product__c.fields.Products__c.isUpdateable()))
                        {
                            test1.Products__c = individualilp;
                        }
                        if ((Schema.sObjectType.Inventory_Location_Product__c.isAccessible()) &&
                            (Schema.sObjectType.Inventory_Location_Product__c.fields.Inventory_Location__c.isAccessible()) &&
                            (Schema.sObjectType.Inventory_Location_Product__c.fields.Inventory_Location__c.isCreateable()) &&
                            (Schema.sObjectType.Inventory_Location_Product__c.fields.Inventory_Location__c.isUpdateable()))
                        {
                            test1.Inventory_Location__c = values.Targetloc;
                        }
                        if ((Schema.sObjectType.Inventory_Location_Product__c.isAccessible()) &&
                            (Schema.sObjectType.Inventory_Location_Product__c.fields.Inventory__c.isAccessible()) &&
                            (Schema.sObjectType.Inventory_Location_Product__c.fields.Inventory__c.isCreateable()) &&
                            (Schema.sObjectType.Inventory_Location_Product__c.fields.Inventory__c.isUpdateable()))
                        {
                            system.debug('indpi.get(individualilp)-->'+indpi.get(individualilp));
                            test1.Inventory__c = indpi.get(individualilp);
                        }
                        if ((Schema.sObjectType.Inventory_Location_Product__c.isAccessible()) &&
                            (Schema.sObjectType.Inventory_Location_Product__c.fields.Received_Quantity__c.isAccessible()) &&
                            (Schema.sObjectType.Inventory_Location_Product__c.fields.Received_Quantity__c.isCreateable()) &&
                            (Schema.sObjectType.Inventory_Location_Product__c.fields.Received_Quantity__c.isUpdateable()))
                        {
                            test1.Received_Quantity__c = 0;
                        }
                        if(test1.AdjustedReceivedqty__c==null)
                        {
                            test1.AdjustedReceivedqty__c=0;
                        }
                        test1.AdjustedReceivedqty__c = test1.AdjustedReceivedqty__c +lineitemqty.get(individualilp)*values.convertedQty; 
                        test1.Source_Type__c = 'Manual';
                        ILPlistToInsert.add(test1);
                    }
                    else
                    {
                        if(test.AdjustedReceivedqty__c==null)
                        {
                            test.AdjustedReceivedqty__c=0;
                        }
                        if((Schema.sObjectType.Inventory_Location_Product__c.isAccessible()) &&
                           (Schema.sObjectType.Inventory_Location_Product__c.fields.AdjustedReceivedqty__c.isAccessible()) &&
                           (Schema.sObjectType.Inventory_Location_Product__c.fields.AdjustedReceivedqty__c.isCreateable()) &&
                           (Schema.sObjectType.Inventory_Location_Product__c.fields.AdjustedReceivedqty__c.isUpdateable()))
                        {
                            test.AdjustedReceivedqty__c = test.AdjustedReceivedqty__c +lineitemqty.get(test.Products__c)*values.convertedQty; 
                            test.Source_Type__c = 'Manual';
                        }
                        indilpupdate.add(test);
                    }          
                    
                }
                System.debug(' ILPlistToInsert:::'+ILPlistToInsert);
                System.debug(' indilpupdate:::'+indilpupdate);
                
                insert ILPlistToInsert;
                if(indilpupdate.size()>0)
                {
                    TriggerHandler.isIndvidualtoBOM ='StopUpdateManualPI';
                    update indilpupdate;
                }
                System.debug('ILPlistToInsert'+ILPlistToInsert); 
                System.debug('indilpupdate'+indilpupdate); 
                
                List<Lot__c> lotlist=new List<Lot__c>();
                lotlist=[select id,name,Product__c,Inventory_Location__c from  Lot__c where Product__c=: lineitemqty.keyset()];
                List<id> lotid=new List<id>();
                Map<id,id> lotproid=new Map<id,id>(); 
                Map<id,Decimal> IndprodunitPrice=new Map<id,Decimal>();
                
                System.debug(' lotlist:::'+lotlist);
                System.debug(' values:::'+values);
                Map<id,List<Product_Serial_Number__c>> Proidwithserial=new Map<id,List<Product_Serial_Number__c>>();
                Map<id,id> ilBinid=new Map<id,id>(); 
                for(BOMlineitem ltprorec:values.IndPros)
                {
                    System.debug('values.IndPros'+ltprorec);
                    // System.debug('id.valueof(ltprorec.lot)'+id.valueof(ltprorec.lot));
                    
                    if(ltprorec.lot!=null)
                    {
                        lotid.add(id.valueof(ltprorec.lot));
                        System.debug('lotid--'+lotid);
                        lotproid.put(ltprorec.indpro.Product__c,ltprorec.lot); 
                        
                        System.debug('lotproid-->>'+lotproid);
                        
                    }
                    IndprodunitPrice.put(ltprorec.indpro.Product__c,ltprorec.unitPrice);
                    ilBinid.put(ltprorec.indpro.Product__c,ltprorec.bin);
                    system.debug('ilBinid-->'+ilBinid);
                    System.debug('IndprodunitPrice-->>'+IndprodunitPrice);
                    system.debug('product id for ind-->'+ltprorec.indpro.Product__c);
                    //  system.debug('lineitemqty from lineitemqty-->'+lineitemqty.get(v.ProductCode__c)*values.convertedQty);
                    IndProdQty.put(ltprorec.indpro.Product__c,lineitemqty.get(ltprorec.indpro.Product__c)*values.convertedQty);
                    Proidwithserial.put(ltprorec.indpro.Product__c,ltprorec.eachserialNo);
                    System.debug('Proidwithserial--'+Proidwithserial);
                    
                }
                System.debug(' lotproid:::'+lotproid);
                List<Lot_Product__c> lotprolist=new List<Lot_Product__c>();
                lotprolist = [select id,Product__c,Quantity__c,Location__c,Lot__c,Bin__c from Lot_Product__c where Lot__c = : lotid];
                Map<Id, List<Lot_Product__c>> lotMap = new Map<Id, List<Lot_Product__c>>();
                System.debug(' lotprolist:::'+lotprolist);
                for(Lot_Product__c lotprorec:lotprolist)
                {
                    if(lotMap.containsKey(lotprorec.Product__c))
                    {
                        List<Lot_Product__c> tempOnelist = lotMap.get(lotprorec.Product__c);
                        tempOnelist.add(lotprorec);
                        lotMap.put(lotprorec.Product__c,tempOnelist);
                    }
                    else
                    {
                        List<Lot_Product__c> templist=new List<Lot_Product__c>();
                        templist.add(lotprorec);
                        lotMap.put(lotprorec.Product__c,templist);
                        
                    }
                }
                
                System.debug('lotMap::'+lotMap);
                System.debug('lineitemqty::'+lineitemqty);
                
                
                List<Lot_Product__c> lotproductlist=new List<Lot_Product__c>();
                List<Lot_Product__c> lotupdatelist=new List<Lot_Product__c>();  
                System.debug('lineitemqty::'+lineitemqty);
                for(Id ltprorec:lineitemqty.keyset())
                {
                    System.debug('ltprorec::'+ltprorec);
                    List<Lot_Product__c> locationlist = new List<Lot_Product__c>();
                    Lot_Product__c test = new  Lot_Product__c();
                    test=null;
                    if(lotMap.containsKey(ltprorec))
                    {
                        locationlist = lotMap.get(ltprorec);
                        for(Lot_Product__c loc:locationlist)
                        {
                            system.debug('before lot>>'+ilBinid.get(ltprorec));
                            if(loc.Location__c == values.Targetloc &&  loc.Bin__c== ilBinid.get(ltprorec))//values.fromBin
                            {
                                test = loc ;
                                break;
                            } 
                        }
                    }
                    if(test==null)
                    {
                        Lot_Product__c lotproductdata=new Lot_Product__c();
                        lotproductdata.Lot__c=lotproid.get(ltprorec);
                        lotproductdata.Location__c=values.Targetloc; 
                        // lotproductdata.Bin__c=values.fromBin; // added on on 12-11-2019
                        system.debug('bin-->>'+ilBinid.get(ltprorec));
                        lotproductdata.Bin__c=ilBinid.get(ltprorec);
                        lotproductdata.Product__c=ltprorec;
                        lotproductdata.Quantity__c=lineitemqty.get(ltprorec)*values.convertedQty;
                        lotproductlist.add(lotproductdata);
                    }
                    else
                    {
                        test.Quantity__c+=lineitemqty.get(test.Product__c)*values.convertedQty;
                        lotupdatelist.add(test);
                    } 
                }
                System.debug('lotproductlist::'+lotproductlist);
                System.debug('lotupdatelist::'+lotupdatelist);
                insert lotproductlist;
                update  lotupdatelist;
                
                List<Inventory_Location_Product__c> indILPforILPLI = [select Id, Name,Net_Quantity__c,Inventory_Location__c,Inventory_Location__r.Location__c,Attribute_Type__c, Products__c, Received_Quantity__c, Source_Type__c from Inventory_Location_Product__c where id =: indilpupdate OR id=: ILPlistToInsert];
                List<Inventory_Location_Product_Line_Item__c> IlpliList = new List<Inventory_Location_Product_Line_Item__c>();
                System.debug('indILPforILPLI-->>'+indILPforILPLI); 
                List<Product_Serial_Number__c>  indPsnList= new List<Product_Serial_Number__c>();
                Map<Id,List<String>> mapforeachPSN=new Map<Id,List<String>>();
                Set<String> slnum = new Set<String>();
                
                for(Inventory_Location_Product__c indilpli:indILPforILPLI)
                {
                    System.debug('indilpli'+indilpli); 
                    if(indilpli.Attribute_Type__c == 'SERIALIZED' && Proidwithserial.containsKey(indilpli.Products__c))
                    {
                        
                        system.debug('lineitemqty1-->'+lineitemqty.get(indilpli.Products__c));
                        system.debug('lineitemqty2-->'+lineitemqty.get(indilpli.Products__c)*values.convertedQty);
                        
                        List<Product_Serial_Number__c> serialList=Proidwithserial.get(indilpli.Products__c);
                        
                        for(Product_Serial_Number__c eachSerial:serialList)
                        {
                            Product_Serial_Number__c indPsn = new Product_Serial_Number__c();
                            
                            indPsn.Serial_Number__c = eachSerial.Serial_Number__c;
                            System.debug(' lotproid.get(indilpli.Products__c)-->:::'+lotproid.get(indilpli.Products__c));
                            indPsn.Lot__c=lotproid.get(indilpli.Products__c);
                            system.debug('Bin1-->>'+ilBinid.get(indilpli.Products__c));
                            indPsn.Bin__c=ilBinid.get(indilpli.Products__c);
                            indPsn.Inventory_Location__c=indilpli.Inventory_Location__c;
                            indPsn.Inventory_Location_Product__c = indilpli.id;
                            indPsn.Product_Code__c = indilpli.Products__c;
                            indPsn.Location__c=indilpli.Inventory_Location__r.Location__c;
                            indPsnList.add(indPsn);
                        }
                    }
                    else
                    {
                        System.debug('indILPforILPLI'); 
                        Inventory_Location_Product_Line_Item__c IlpliWithOPsn = new Inventory_Location_Product_Line_Item__c();
                        if(IlpliWithOPsn.AdjustedReceivedqty_c__c==null)
                        {
                            IlpliWithOPsn.AdjustedReceivedqty_c__c=0;
                            
                        }
                        system.debug('Bin1-->>'+ilBinid.get(indilpli.Products__c));
                        IlpliWithOPsn.Bin__c=ilBinid.get(indilpli.Products__c);
                        system.debug('Bin2-->>'+IlpliWithOPsn.Bin__c);
                        IlpliWithOPsn.Inventory_Location_Product__c = indilpli.id;
                        IlpliWithOPsn.Product__c = indilpli.Products__c;
                        IlpliWithOPsn.Inventory_Location__c=indilpli.Inventory_Location__c;
                        IlpliWithOPsn.Lot__c=lotproid.get(indilpli.Products__c);
                        
                        Integer ilpliqty=Integer.valueof(lineitemqty.get(indilpli.Products__c)*values.convertedQty);
                        IlpliWithOPsn.AdjustedReceivedqty_c__c =IlpliWithOPsn.AdjustedReceivedqty_c__c+ ilpliqty;
                        //}
                        system.debug('unit price1-->>'+IndprodunitPrice.get(indilpli.Products__c));
                        IlpliWithOPsn.Unit_Price__c=IndprodunitPrice.get(indilpli.Products__c);
                        system.debug('unit price1-->>'+IndprodunitPrice.get(indilpli.Products__c));
                        IlpliWithOPsn.Stock_Type__c='Individual Conversion';
                        IlpliList.add(IlpliWithOPsn);
                        system.debug('IlpliList'+IlpliList);
                    } 
                }
                insert indPsnList;
                system.debug('after inserting indPsnList-->'+indPsnList);
                set<id> serialrec=new  set<id>();
                for(Product_Serial_Number__c serialno:indPsnList)
                {
                    system.debug('iterating indPsnList-->'+serialno);
                    serialrec.add(serialno.id);
                }
                System.debug('after adding serialno.id-->>::'+serialrec);
                List<Product_Serial_Number__c> InsertedPsns= [select id, Serial_Number__c, Inventory_Location_Product__c,Inventory_Location_Product__r.Inventory_Location__c, Product_Code__c from Product_Serial_Number__c where id =: serialrec];
                for(Product_Serial_Number__c psn : InsertedPsns)
                {
                    system.debug('Iterating InsertedPsns-->'+psn);
                    Inventory_Location_Product_Line_Item__c IlpliWithPsn = new Inventory_Location_Product_Line_Item__c();
                    if(IlpliWithPsn.AdjustedReceivedqty_c__c==null)
                    {
                        IlpliWithPsn.AdjustedReceivedqty_c__c   =0;
                    }
                    IlpliWithPsn.Inventory_Location_Product__c = psn.Inventory_Location_Product__c;
                    IlpliWithPsn.Inventory_Location__c=psn.Inventory_Location_Product__r.Inventory_Location__c;
                    IlpliWithPsn.Product__c = psn.Product_Code__c;
                    IlpliWithPsn.Product_Serial_Number__c = psn.id;
                    IlpliWithPsn.AdjustedReceivedqty_c__c = 1;
                    system.debug('Bin1-->>'+ilBinid.get(psn.Product_Code__c));
                    IlpliWithPsn.Bin__c=ilBinid.get(psn.Product_Code__c);
                    system.debug('Bin4-->>'+ilBinid.get(psn.Product_Code__c));
                    system.debug('unit price2-->>'+IndprodunitPrice.get(psn.Product_Code__c));
                    IlpliWithPsn.Unit_Price__c=IndprodunitPrice.get(psn.Product_Code__c);
                    system.debug(' unit price2-->>'+ IndprodunitPrice.get(psn.Product_Code__c));
                    IlpliWithPsn.Stock_Type__c='Individual Conversion';
                    IlpliWithPsn.Lot__c=lotproid.get(psn.Product_Code__c);
                    IlpliList.add(IlpliWithPsn);
                }
                insert IlpliList;  //inserting individual product ilpli list here
                
                //code added on 20-03-2020 to handle Average Buying Price in Product Inventory
                
                list<Inventory_Location_Product_Line_Item__c>  lneItem=[select Product__c,Stock_Type__c, Attribute_Type__c,Unit_Price__c from Inventory_Location_Product_Line_Item__c where Product__c IN : lineitemqty.keyset()];
                system.debug('lneItem>>'+lneItem);
                map<id,decimal> prolist=new map<id,decimal>();
                map<id,decimal> ilplilist1 =new map<id,decimal>();  
                
                system.debug('lneItem>>>'+lneItem);
                
                for(Inventory_Location_Product_Line_Item__c prores :lneItem)
                {   
                    system.debug('prores>>>>'+prores);
                    ProdTypeid.add(prores.Product__c);//adding line item product ids to the set
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
                
                
            List<Inventory__c> productList = [select id, Name, ProductCode__c,Avg_Buying_Price__c, Total_Available_Qty__c, Available_Qty__c, ProductCode__r.Attribute_Type__c from Inventory__c where ProductCode__c IN : lineitemqty.keyset() ];
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
                values.message = 'Success';
                system.debug('Ilpliwithqty-->'+Ilpliwithqty);//Map of Bom Product ILPLI with qty
                system.debug('IlpliList-->'+IlpliList);//List of Individual product ILPLI's
                system.debug('indILPforILPLI-->'+indILPforILPLI);//List of Individual products ILP's
                system.debug('BomProdId-->'+BomProdId);//List of Individual products ILP's
                system.debug('IndProdQty-->'+IndProdQty);
                system.debug('IndprodunitPrice-->'+IndprodunitPrice);
                LinkageServiceClass.financeBomToIndiviual(Ilpliwithqty,IndprodunitPrice,IlpliList,indILPforILPLI,BomProdId,IndProdQty);
                return values;
            }
            catch(Exception e)
            {
                Database.rollback(sp);
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