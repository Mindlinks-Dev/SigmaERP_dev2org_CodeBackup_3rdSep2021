/*=====================================================================================================
Author     : Vidit Kumar 
Company    : Mindlinks Solution Pvt Ltd.
Date       : 12 Mar 2018
Description: Imperitive for Sigma Financials Used by Linker Triggers
=======================================================================================================*/

global without sharing class LinkageServiceClass  
{
    public static String ref = '';   //to hold reference of the source document, to be used to create MR Finance
    //public static date transDate = Date.today();   //to hold transactioDate, 
    //////////////////////////////////////////////////Fetch SRP(Stock Receiving flow)//////////////////////////////////////////////////
    public Static void createSLFromSRP(Set<Id> ObjectId) 
    {
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Stock_In_Product__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Vendor_Product__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Stock_In_Product__c',new Set<String>{'Id', 'Name','sigmaerpdev2__Pur_Order__c', 'sigmaerpdev2__Product__c', 'sigmaerpdev2__Stock_In__c', 'sigmaerpdev2__Quantity_Received__c', 'sigmaerpdev2__Status__c', 'sigmaerpdev2__Stock_In__r.sigmaerpdev2__Vendor__c','sigmaerpdev2__Purchase_Order__c', 'sigmaerpdev2__Purchase_Order__r.sigmaerpdev2__Buying_Price__c', 'sigmaerpdev2__Purchase_Order__r.sigmaerpdev2__Quantity__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Vendor_Product__c',new Set<String>{'id' ,'name','sigmaerpdev2__Account_Name__c', 'sigmaerpdev2__Product_Name__c', 'sigmaerpdev2__Duty__c', 'sigmaerpdev2__Freight__c', 'sigmaerpdev2__Insurance__c', 'sigmaerpdev2__Other__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Purchase_Order__c','sigmaerpdev2__Purchase_Order_Product__c','sigmaerpdev2__SRP__c','sigmaerpdev2__Unit_Cost__c','sigmaerpdev2__Vendor__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Stock_Origin__c','sigmaerpdev2__Duty__c','sigmaerpdev2__Freight__c','sigmaerpdev2__Insurance__c','sigmaerpdev2__Other__c'})  
          )
        {
            
            List<Sigma_Linkage__c> SLToInsertList = new List<Sigma_Linkage__c>();   //to store list of SL records to be inserted
            List<Stock_In_Product__c> SRPList = new List<Stock_In_Product__c>();
            SRPList = [select Id, name, Pur_Order__c, Product__c, Stock_In__c, Quantity_Received__c, Status__c, Stock_In__r.Vendor__c,
                       Purchase_Order__c, Purchase_Order__r.Buying_Price__c, Purchase_Order__r.Quantity__c
                       from Stock_In_Product__c where Id =: ObjectId];
            
            Map<id,Vendor_Product__c> VenPro = new Map<id,Vendor_Product__c>(); //key => vendor product Id; value => Vendor Product object
            
            List<Vendor_Product__c> vendorproducts=new List<Vendor_Product__c>();
            vendorproducts=[select id ,name, Account_Name__c, Product_Name__c, Duty__c, Freight__c, Insurance__c, Other__c from Vendor_Product__c where Account_Name__c =: SRPList[0].Stock_In__r.Vendor__c ];
            for(Vendor_Product__c vp:vendorproducts)
            {
                VenPro.put(vp.Product_Name__c,vp);
            }
            for(Stock_In_Product__c srp:SRPList)
            {
                
                String Qty = srp.Purchase_Order__r.Quantity__c != null ? srp.Purchase_Order__r.Quantity__c : '0';
                Decimal orderedQty = Decimal.valueOf(String.valueOf(Qty));
                Decimal TotalBuyPrice = srp.Purchase_Order__r.Buying_Price__c != null ? srp.Purchase_Order__r.Buying_Price__c : 0;
                Decimal UnitBuyPrice = TotalBuyPrice/orderedQty;
                Decimal ReceivedQty = srp.Quantity_Received__c != null ? srp.Quantity_Received__c : 0;
                Sigma_Linkage__c stockLink = new Sigma_Linkage__c();
                stockLink.Product__c = srp.Product__c;
                stockLink.Purchase_Order__c = srp.Pur_Order__c;
                stockLink.Purchase_Order_Product__c = srp.Purchase_Order__c;
                stockLink.SRP__c = srp.Id;
                stockLink.Unit_Cost__c = UnitBuyPrice;
                stockLink.Vendor__c = srp.Stock_In__r.Vendor__c;
                stockLink.Received_Quantity__c = ReceivedQty;
                stockLink.Stock_Origin__c = 'Stock Receiving';
                
                try
                {
                    stockLink.Duty__c = ( VenPro.get(srp.Product__c).Duty__c/100 * (ReceivedQty*UnitBuyPrice) );
                    stockLink.Freight__c = ( VenPro.get(srp.Product__c).Freight__c/100 * (ReceivedQty*UnitBuyPrice) );
                    stockLink.Insurance__c = ( VenPro.get(srp.Product__c).Insurance__c/100 * (ReceivedQty*UnitBuyPrice) );
                    stockLink.Other__c = ( VenPro.get(srp.Product__c).Other__c/100 * (ReceivedQty*UnitBuyPrice) );
                }
                catch(Exception e)
                {
                    System.debug('Exception while calculating landed cost:'+e.getMessage());
                }
                SLToInsertList.add(stockLink);
                System.debug('ListSize'+SLToInsertList);
                
            }
            
            
            try
            {
                System.debug('ListSize'+SLToInsertList.size());
                if(SLToInsertList.size() > 0)
                {
                    insert SLToInsertList;
                }
            }
            catch(Exception e)
            {
                System.debug('Exception createSLFromSRP:'+e.getMessage());
            }
        } 
    }
    
    //////////////////////////////////////////////////Fetch ILP(Add Stock flow) data//////////////////////////////////////////////////
    public Static void createSLFromILP(Set<Id> ILPObjectId,List<ImportBulkProductForInventory.dataWrap> wrapList) 
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'id' ,'name','sigmaerpdev2__Received_Quantity__c', 'sigmaerpdev2__Products__c', 'sigmaerpdev2__Stock_Origin__c', 'sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Inventory__c', 'sigmaerpdev2__Inventory__r.sigmaerpdev2__Total_Qty__c', 'sigmaerpdev2__Inventory__r.sigmaerpdev2__Total_Available_Qty__c', 'sigmaerpdev2__Inventory__r.sigmaerpdev2__Available_Qty__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'id' ,'name', 'sigmaerpdev2__ILP__c','sigmaerpdev2__Received_Quantity__c'})  
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__ILP__c','sigmaerpdev2__Unit_Cost__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Stock_Origin__c'})  
          )
        {
            system.debug('ILPObjectId-->>>'+ILPObjectId);
            system.debug('wrap-->>>1'+wrapList);
            
            
            List<Sigma_Linkage__c> InsertStockLinkList = new List<Sigma_Linkage__c>();  //for new ilps
            Map<Id,ImportBulkProductForInventory.dataWrap> mapforwrap=new Map<Id,ImportBulkProductForInventory.dataWrap>();
            if(wrapList.size()>0)
            {
                for(ImportBulkProductForInventory.dataWrap w: wrapList)
                {
                    mapforwrap.put(w.ilpid,w);   
                }
                for(ImportBulkProductForInventory.dataWrap ilpwrap:wrapList)
                {
                    Sigma_Linkage__c stockLink = new Sigma_Linkage__c();
                    stockLink.Product__c = ilpwrap.proid;
                    stockLink.ILP__c = ilpwrap.ilpid;         
                    /*if(ilpwrap.qty!=null)
{
stockLink.Uploaded_UnitCost__c=ilpwrap.ilpliup;
system.debug('stockLink-->>>'+stockLink.Uploaded_UnitCost__c);
}*/             
                    stockLink.Unit_Cost__c = ilpwrap.unitprice;
                    stockLink.Received_Quantity__c = ilpwrap.qty;
                    
                    
                    stockLink.Stock_Origin__c = 'Direct Add';
                    InsertStockLinkList.add(stockLink);
                    system.debug('stockLink-->>>'+stockLink);
                }
            }
            /*if(wrapList1.size()>0)
{
Map<Id,ImportSerialProductForInventory.dataWrap> mapforwrap1=new Map<Id,ImportSerialProductForInventory.dataWrap>();
for(ImportSerialProductForInventory.dataWrap w: wrapList1)
{
mapforwrap1.put(w.ilpid,w);   
}
for(ImportSerialProductForInventory.dataWrap ilpwrap:wrapList1)
{
Sigma_Linkage__c stockLink = new Sigma_Linkage__c();
stockLink.Product__c = ilpwrap.proid;
stockLink.ILP__c = ilpwrap.ilpid;            
stockLink.Unit_Cost__c = ilpwrap.unitprice;
stockLink.Received_Quantity__c = ilpwrap.qty;

stockLink.Stock_Origin__c = 'Direct Add';
InsertStockLinkList.add(stockLink);
system.debug('stockLink-->>>'+stockLink);


}
system.debug('InsertStockLinkList>>>'+InsertStockLinkList);
}*/
            if(InsertStockLinkList.size() > 0)
            {
                insert InsertStockLinkList;
            }
        }
    }
    //////////////////////////////////////////////////Fetch ILP(Add Stock flow) data//////////////////////////////////////////////////
    public Static void createSLFromILPforSerial(Set<Id> ILPObjectId,List<ImportSerialProductForInventory.dataWrap> wrapList1) 
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'id' ,'name','sigmaerpdev2__Received_Quantity__c', 'sigmaerpdev2__Products__c', 'sigmaerpdev2__Stock_Origin__c', 'sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Inventory__c', 'sigmaerpdev2__Inventory__r.sigmaerpdev2__Total_Qty__c', 'sigmaerpdev2__Inventory__r.sigmaerpdev2__Total_Available_Qty__c', 'sigmaerpdev2__Inventory__r.sigmaerpdev2__Available_Qty__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'id' ,'name', 'sigmaerpdev2__ILP__c','sigmaerpdev2__Received_Quantity__c'})  
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__ILP__c','sigmaerpdev2__Unit_Cost__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Stock_Origin__c'})  
          )
        {
            system.debug('ILPObjectId-->>>'+ILPObjectId);
            system.debug('wrap-->>>1'+wrapList1);
            
            List<Sigma_Linkage__c> InsertStockLinkList = new List<Sigma_Linkage__c>();  //for new ilps
            
            
            Map<Id,ImportSerialProductForInventory.dataWrap> mapforwrap1=new Map<Id,ImportSerialProductForInventory.dataWrap>();
            for(ImportSerialProductForInventory.dataWrap w: wrapList1)
            {
                mapforwrap1.put(w.ilpid,w);  
            }
            
            for(ImportSerialProductForInventory.dataWrap ilpwrap:wrapList1)
            {
                system.debug('ilpwrap>>>'+ilpwrap);
                Sigma_Linkage__c stockLink = new Sigma_Linkage__c();
                stockLink.Product__c = ilpwrap.proid;
                stockLink.ILP__c = ilpwrap.ilpid;            
                stockLink.Unit_Cost__c = ilpwrap.unitprice;
                stockLink.Received_Quantity__c = ilpwrap.qty;
                stockLink.Stock_Origin__c = 'Direct Add';
                InsertStockLinkList.add(stockLink);
                system.debug('stockLink-->>>'+stockLink);
                
                
            }
            
            if(InsertStockLinkList.size() > 0)
            {
                insert InsertStockLinkList;
            }
            system.debug('InsertStockLinkList>>>'+InsertStockLinkList);
        }
    }
    //method to create sl through ilpli
    public Static Map<Id,Sigma_Linkage__c> createSLFromILPLI(Set<Id> ILPLISet) 
    {
			system.debug('ILPLISet>>>'+ILPLISet);        
        Map<Id, Sigma_Linkage__c> SLRecordToReturnMap;    //key=>SL id, value=>sl record
        
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage_Item__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'id', 'Name', 'sigmaerpdev2__Available_Quantity__c', 'sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Product__c', 'sigmaerpdev2__Stock_Origin__c', 'sigmaerpdev2__Inventory_Location_Product__c', 'sigmaerpdev2__Stock_Receiving_Product__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'Id', 'name', 'sigmaerpdev2__Received_Quantity__c', 'sigmaerpdev2__SRP__c','sigmaerpdev2__Stock_Origin__c','sigmaerpdev2__ILP__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Received_Quantity__c', 'sigmaerpdev2__SRP__c','sigmaerpdev2__Stock_Origin__c','sigmaerpdev2__ILP__c','sigmaerpdev2__Unit_Cost__c'})
           &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'sigmaerpdev2__Received_Quantity__c', 'sigmaerpdev2__Product__c','sigmaerpdev2__Stock_Origin__c','sigmaerpdev2__ILP__c','sigmaerpdev2__Unit_Cost__c'})
           &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Sigma_Linkage__c'})  
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Activity_Date_Time__c','sigmaerpdev2__Product__c','sigmaerpdev2__Type__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c'})  
           &&Schema.sObjectType.Sigma_Linkage__c.fields.Id.isAccessible()
           &&Schema.sObjectType.Sigma_Linkage__c.fields.name.isAccessible()
          )
        {*/
            SLRecordToReturnMap = new Map<Id, Sigma_Linkage__c>();
            List<Sigma_Linkage__c> SLList = new List<Sigma_Linkage__c>();   //to insert SL
            List<Sigma_Linkage_Item__c> SLIList = new List<Sigma_Linkage_Item__c>();   //to insert SLLI
            
         //  Map<ID, Inventory_Location_Product_Line_Item__c> ILPLIMap = new Map<ID, Inventory_Location_Product_Line_Item__c>([select id, Name, Available_Quantity__c, Received_Quantity__c,Unit_Price__c,
         //                                                                              Product__c, Stock_Origin__c, Inventory_Location_Product__c, Stock_Receiving_Product__c
           //                                                                                                                   from Inventory_Location_Product_Line_Item__c where Id =: ILPLISet]);
            Map<ID, Inventory_Location_Product_Line_Item__c> ILPLIMap = new Map<ID, Inventory_Location_Product_Line_Item__c>([select id, Name,sigmaerpdev2__Available_Quantity__c,sigmaerpdev2__Received_Quantity__c,sigmaerpdev2__Unit_Price__c,sigmaerpdev2__Product__c, sigmaerpdev2__Stock_Origin__c, sigmaerpdev2__Inventory_Location_Product__c, sigmaerpdev2__Stock_Receiving_Product__c from sigmaerpdev2__Inventory_Location_Product_Line_Item__c where Id =:ILPLISet]);
           system.debug('ILPLIMap>>>'+ILPLIMap);
           Map<Id,decimal> ilpQtyMap = new Map<Id,decimal>();  //key=>ilp quantity, value total qty in ilp
            Map<Id,dataWrap> sldata = new Map<Id,dataWrap>();
            for(Id ilpliId : ILPLIMap.keyset())
            {
                system.debug('ilpliId>>>'+ilpliId);   
                if(sldata.containskey( ILPLIMap.get(ilpliId).Inventory_Location_Product__c ))
                {
                    dataWrap db = sldata.get( ILPLIMap.get(ilpliId).Inventory_Location_Product__c );
                    db.qty += ILPLIMap.get(ilpliId).Available_Quantity__c;
                    sldata.put(ILPLIMap.get(ilpliId).Inventory_Location_Product__c,db);
                }
                else
                {
                    dataWrap d = new dataWrap();
                    d.ilpid = ILPLIMap.get(ilpliId).Inventory_Location_Product__c;
                    d.proid = ILPLIMap.get(ilpliId).Product__c;
                    d.refid = ilpliId;
                    d.qty = ILPLIMap.get(ilpliId).Available_Quantity__c;
                    if( ILPLIMap.get(ilpliId).Stock_Origin__c == '' || ILPLIMap.get(ilpliId).Stock_Origin__c == 'Stock Receiving' )
                    {
                        d.type = 'Direct Add';
                    }
                    else
                    {
                        d.type = ILPLIMap.get(ilpliId).Stock_Origin__c;
                    }
                    d.price = 0;
                    sldata.put( ILPLIMap.get(ilpliId).Inventory_Location_Product__c,d );
                    
                }
            }
            
            for(Id ilpId : sldata.keyset())
            {
                Sigma_Linkage__c stockLink = new Sigma_Linkage__c();
                stockLink.Product__c = sldata.get(ilpId).proid;
                stockLink.ILP__c = sldata.get(ilpId).ilpid;
                stockLink.Unit_Cost__c = 0;
                stockLink.Received_Quantity__c = sldata.get(ilpId).qty;
                stockLink.Stock_Origin__c = sldata.get(ilpId).type;
                SLList.add(stockLink);
                
            }
            insert SLList;
            system.debug('SLList>>'+SLList);
            Map<Id, Id> ilpliIdSLIdMap = new Map<Id, Id>(); //key=>ilpli id, value=>sl id
            for(Id ilpliId : ILPLIMap.keyset())
            {
                for(Sigma_Linkage__c sl : SLList )
                {
                    if(sl.ILP__c == ILPLIMap.get(ilpliId).Inventory_Location_Product__c)
                        ilpliIdSLIdMap.put( ilpliId,sl.id );
                    SLRecordToReturnMap.put(sl.id,sl);
                }
            }
            
            for(Id ilpliId : ILPLIMap.keyset())
            {
                system.debug('ilpliId>>'+ilpliId);
                Sigma_Linkage_Item__c SLLI = new Sigma_Linkage_Item__c();
                SLLI.Activity_Date_Time__c = system.now();
                SLLI.Sigma_Linkage__c = ilpliIdSLIdMap.get(ilpliId);
                SLLI.Product__c = ILPLIMap.get(ilpliId).Product__c;
                SLLI.Type__c = 'Inventory';
                SLLI.Quantity__c = ILPLIMap.get(ilpliId).Available_Quantity__c;
                //SLLI.Uploaded_UnitCost__c =ILPLIMap.get(ilpliId).Available_Quantity__c ;
                SLLI.Inventory_Location_Product_Line_Item__c = ilpliId;
                SLIList.add(SLLI);
                
            }
            insert SLIList;
             system.debug('SLIList>>'+SLIList);
      //  }
        return SLRecordToReturnMap;
    }
    
    /*--------------Individual to BOM By Rashmi starts on 21-19-2019--------------*/
    //Invoked from UpdateBomStock
    public static void financeIndiviualToBom(Map<id, decimal> decIlpli,List<Inventory_Location_Product_Line_Item__c> incILPLI,Inventory_Location_Product__c incILP,Decimal incBomQty,Map<Id,Id> BomProds )
    {
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Vendor_Product__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage_Item__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Vendor_Product__c',new Set<String>{'id' ,'name','sigmaerpdev2__Buying_Price__c','sigmaerpdev2__Account_Name__c', 'sigmaerpdev2__Product_Name__c', 'sigmaerpdev2__Duty__c', 'sigmaerpdev2__Freight__c', 'sigmaerpdev2__Insurance__c', 'sigmaerpdev2__Other__c'})
           && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Sigma_Linkage__c'})  
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Type__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Sales_Unit_Price__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'sigmaerpdev2__ILP__c','sigmaerpdev2__Product__c','sigmaerpdev2__Stock_Origin__c','sigmaerpdev2__Unit_Cost__c','sigmaerpdev2__Received_Quantity__c'}))
        {  
                   
            
            Map<Id,Id> ilpliSLMap = new Map<Id,Id>(); //key=>ilpli id, value=>finance product id
            
            ilpliSLMap = returnSlForIlpli(decIlpli.keyset());
            
            Map<Id,Sigma_Linkage__c> fromSLToUpdateMap = new Map<Id,Sigma_Linkage__c>();    //key => sl id value=> sigma linkage record
            
            fromSLToUpdateMap = toGetSigmaLinkage( ilpliSLMap.values() );
            
            set<Id> ProdIds=new set<Id>();
            for(Inventory_Location_Product_Line_Item__c ilpli : incILPLI)
            {
                ProdIds.add(ilpli.Product__c);
                
            }
            List<Vendor_Product__c> vendorproducts=[select id ,name,Buying_Price__c,Account_Name__c, Product_Name__c, Duty__c, Freight__c, Insurance__c, Other__c from Vendor_Product__c where Product_Name__c IN: ProdIds ];
            
            try
            {
                List<Sigma_Linkage_Item__c> toInsertSLI = new List<Sigma_Linkage_Item__c>();
                
                for(Id ilpliId:decIlpli.keyset())
                {
                    
                    system.debug(ilpliSLMap.containskey(ilpliId));
                    if(ilpliSLMap.containskey(ilpliId))
                    {
                        
                        
                        Sigma_Linkage_Item__c SLI = new Sigma_Linkage_Item__c();
                        SLI.Sigma_Linkage__c = ilpliSLMap.get( ilpliId );
                        SLI.Product__c=BomProds.get(ilpliId);
                        SLI.Inventory_Location_Product_Line_Item__c = ilpliId;
                        SLI.Quantity__c = decIlpli.get(ilpliId)< 0 ? decIlpli.get(ilpliId): -1*(decIlpli.get(ilpliId));                      
                        SLI.Type__c = 'Stock Decreased';
                        SLI.Sales_Unit_Price__c = 0;
                        toInsertSLI.add(SLI);
                        system.debug('toInsertSLI-->'+toInsertSLI);
                        
                        //updating Adjusted_Quantity__c in Individual product Sigma Finance
                        Sigma_Linkage__c SLind = fromSLToUpdateMap.get(ilpliSLMap.get(ilpliId));
                        SLind.Adjusted_Quantity__c += decIlpli.get(ilpliId);
                        fromSLToUpdateMap.put(SLind.Id,SLind);


                        
                    }
                }
                
                Sigma_Linkage__c SL;
                
                SL = new Sigma_Linkage__c();
                SL.ILP__c = incILP.Id;
                
                SL.Product__c = incILP.Products__c;
                SL.Stock_Origin__c = 'BOM Conversion';
                
                SL.Unit_Cost__c = incILPLI[0].Unit_Price__c; // /incBomQty
                
                SL.Received_Quantity__c = incBomQty;
                
                if(vendorproducts.size()>0)
                {
                    SL.Vendor__c=vendorproducts[0].Account_Name__c;
                }
                
                
                upsert SL;
                system.debug('after adding SL'+SL);
                
                for(Inventory_Location_Product_Line_Item__c ilpli:incILPLI)
                {
                    system.debug('iterating incILPLI in ilpli--->'+ilpli);
                    Sigma_Linkage_Item__c SLI = new Sigma_Linkage_Item__c();
                    SLI.Sigma_Linkage__c = SL.Id;
                    SLI.Product__c=ilpli.Product__c;
                    SLI.Inventory_Location_Product_Line_Item__c = ilpli.Id;
                    
                    SLI.Quantity__c = ilpli.AdjustedReceivedqty_c__c;
                    SLI.Type__c = 'Inventory';
                    toInsertSLI.add(SLI);
                    System.debug('before add SLI BOM::'+SLI);
                }
                
                
                if(toInsertSLI.size()>0)
                {
                    insert toInsertSLI;

                    
                    update fromSLToUpdateMap.values();

                    
                }
                
                
            }
            catch(exception ex)
            {
                createErrorLog.insertError('LinkageServiceClass',ex.getMessage(),'individual to BOM',null,'',ex.getStackTraceString(),UserInfo.getUserId());
                System.debug('Q Exception ::'+ex+' @ line '+ex.getLineNumber());
            }
        }
    }
    
    /*-----------BOM to Individual Ends------------*/
    ////////////////////////////////////////Fetch SRPLI(Stock Receiving) data////////////////////////////////////////
    /*--------------Bom to Individual By Rashmi starts on 11-12-2019--------------*/
    //Invoked from ConvertBOMToIndividualCntrl
    public static void financeBomToIndiviual(Map<id, decimal> decIlpli,Map<id,Decimal> indprounitPrice,List<Inventory_Location_Product_Line_Item__c> incILPLI, List<Inventory_Location_Product__c> incILP,Map<Id,Id> BomProd,Map<id,Decimal> updateIndQty)
    {
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Vendor_Product__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage_Item__c') 
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Vendor_Product__c',new Set<String>{'id' ,'name','sigmaerpdev2__Buying_Price__c','sigmaerpdev2__Account_Name__c', 'sigmaerpdev2__Product_Name__c', 'sigmaerpdev2__Duty__c', 'sigmaerpdev2__Freight__c', 'sigmaerpdev2__Insurance__c', 'sigmaerpdev2__Other__c'})
           && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Sigma_Linkage__c'})  
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Type__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Sales_Unit_Price__c','sigmaerpdev2__Type__c'})  
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'sigmaerpdev2__ILP__c','sigmaerpdev2__Product__c','sigmaerpdev2__Stock_Origin__c','sigmaerpdev2__Unit_Cost__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Vendor__c'}))
            
        {
            
            
            Map<Id,Id> ilpliSLMap = new Map<Id,Id>(); //key=>ilpli id, value=>finance product id
            
            ilpliSLMap = returnSlForIlpli(decIlpli.keyset());
            
            Map<Id,Sigma_Linkage__c> fromSLToUpdateMap = new Map<Id,Sigma_Linkage__c>();    //key => sl id value=> sigma linkage record
            
            
            fromSLToUpdateMap = toGetSigmaLinkage( ilpliSLMap.values() );
            
            
            set<Id> ProdIds=new set<Id>();
            for(Inventory_Location_Product_Line_Item__c ilpli : incILPLI)
            {
                ProdIds.add(ilpli.Product__c);
                
            }
            
            List<Vendor_Product__c> vendorproducts=[select id ,name,Buying_Price__c,Account_Name__c, Product_Name__c, Duty__c, Freight__c, Insurance__c, Other__c from Vendor_Product__c where Product_Name__c IN: ProdIds ];
            
            
            try
            {
                List<Sigma_Linkage_Item__c> toInsertSLI = new List<Sigma_Linkage_Item__c>();
                
                for(Id ilpliId:decIlpli.keyset())
                {
                    
                    
                    if(ilpliSLMap.containskey(ilpliId))
                    {
                        
                        
                        Sigma_Linkage_Item__c SLI = new Sigma_Linkage_Item__c();
                        SLI.Sigma_Linkage__c = ilpliSLMap.get( ilpliId );
                        
                        
                        SLI.Product__c=BomProd.get(ilpliId);
                        SLI.Inventory_Location_Product_Line_Item__c = ilpliId;
                        SLI.Quantity__c = decIlpli.get(ilpliId)< 0 ? decIlpli.get(ilpliId): -1*(decIlpli.get(ilpliId));
                        

                        SLI.Type__c = 'Stock Decreased';
                        SLI.Sales_Unit_Price__c = 0;
                        toInsertSLI.add(SLI);
                        
                        //updating Adjusted_Quantity__c in Individual product Sigma Finance
                        
                        Sigma_Linkage__c SLbom = fromSLToUpdateMap.get(ilpliSLMap.get(ilpliId));
                        
                        
                        SLbom.Adjusted_Quantity__c += decIlpli.get(ilpliId);
                        fromSLToUpdateMap.put(SLbom.Id,SLbom);
                        system.debug('after SLbom in fromSLToUpdateMap'+fromSLToUpdateMap);
                        System.debug('before adding increase::'+toInsertSLI);
                        
                    }
                }
                List<Sigma_Linkage__c> toInsertnewSL=new List<Sigma_Linkage__c>();
                List<Sigma_Linkage_Item__c> toInsertnewSLI = new List<Sigma_Linkage_Item__c>();
                
                for(Inventory_Location_Product__c indilps:incILP)
                {
                    system.debug('indilps--->'+indilps);
                    Sigma_Linkage__c SL = new Sigma_Linkage__c();
                    SL.ILP__c = indilps.Id;
                    SL.Product__c = indilps.Products__c;
                    SL.Stock_Origin__c = 'Individual Conversion';
                    
                    SL.Unit_Cost__c = indprounitPrice.get(indilps.Products__c);
                    
                    SL.Received_Quantity__c =updateIndQty.get(indilps.Products__c);
                    
                    if(vendorproducts.size()>0)
                    {
                        SL.Vendor__c=vendorproducts[0].Account_Name__c;
                    }
                    
                    toInsertnewSL.add(SL);

                }
                insert toInsertnewSL;
                system.debug('toInsertnewSL after insert:::: '+toInsertnewSL);
                
                for(Inventory_Location_Product_Line_Item__c ilpli:incILPLI)
                {
                    
                    
                    for(Sigma_Linkage__c sl: toInsertnewSL)
                    {
                        
                        if(sl.ILP__c==ilpli.Inventory_Location_Product__c)
                        {
                            
                            Sigma_Linkage_Item__c SLI = new Sigma_Linkage_Item__c();
                            SLI.Sigma_Linkage__c = sl.id;
                            SLI.Product__c=sl.Product__c;
                            SLI.Inventory_Location_Product_Line_Item__c = ilpli.Id;
                            
                            SLI.Quantity__c = ilpli.AdjustedReceivedqty_c__c;
                            

                            SLI.Type__c = 'Inventory';
                            toInsertnewSLI.add(SLI);

                            
                        }
                        
                    }
                    
                }
                insert toInsertnewSLI;
                System.debug('after toInsertSLI::'+toInsertSLI);
                if(toInsertSLI.size()>0)
                {
                    insert toInsertSLI;

                    
                    update fromSLToUpdateMap.values();

                }
                
                
                
            }
            catch(exception ex)
            {
                createErrorLog.insertError('LinkageServiceClass',ex.getMessage(),'BOM to Individual',null,'',ex.getStackTraceString(),UserInfo.getUserId());
                System.debug('Q Exception ::'+ex+' @ line '+ex.getLineNumber());
            }
        }
    }
    
    /*------------Bom to Individual Ends------------*/
    ////////////////////////////////////////Fetch SRPLI(Stock Receiving) data////////////////////////////////////////
    //create Stock Linkage Line Item record for stock receiving flow &Invoked from sigmafinanceInbound method
    //@Future
    public Static void LinkSRPLI(Set<Id> ObjectId,String EventType) 
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Stock_Receiving_Product_Line_Item__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage_Item__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Stock_Receiving_Product_Line_Item__c',new set<String>{'Id', 'name', 'sigmaerpdev2__Received_Quantity__c', 'sigmaerpdev2__Stock_Receiving_Product__c','sigmaerpdev2__Product__c', 'sigmaerpdev2__Inventory_Location_Product__c', 'sigmaerpdev2__Purchase_Order_Product__c', 'sigmaerpdev2__Stock_Receiving_Product__r.sigmaerpdev2__Purchase_Order__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'Id', 'name', 'sigmaerpdev2__Received_Quantity__c', 'sigmaerpdev2__SRP__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Activity_Date_Time__c','sigmaerpdev2__Product__c','sigmaerpdev2__Stock_Receiving_Product_Line_Item__c','sigmaerpdev2__Purchase_Order_Product__c','sigmaerpdev2__Type__c','sigmaerpdev2__Quantity__c'})  
           &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Sigma_Linkage__c'})  
          )
        {
            
            List<Sigma_Linkage_Item__c> SLLIList = new List<Sigma_Linkage_Item__c>();
            if(EventType == 'SRPLIInsert')
            {
                
                Decimal Quantity =0;
                Map<ID, Stock_Receiving_Product_Line_Item__c> SRPLIMap = new Map<ID, Stock_Receiving_Product_Line_Item__c>([select Id, name, Received_Quantity__c, Stock_Receiving_Product__c, 
                                                                                                                            Product__c, Inventory_Location_Product__c, Purchase_Order_Product__c, Stock_Receiving_Product__r.Purchase_Order__c
                                                                                                                            from Stock_Receiving_Product_Line_Item__c where Id IN: ObjectId]);
                
                system.debug('SRPLIMap>>'+ SRPLIMap);
                
                
                Set<Id> SRPSet = new Set<Id>();    //to store Srp Id in Srpli
                for(Id srpliId:SRPLIMap.keySet())
                {
                    SRPSet.add(SRPLIMap.get(srpliId).Stock_Receiving_Product__c);
                }
                
                Map<Id, Sigma_Linkage__c> SrpliIdSLMap = new Map<Id, Sigma_Linkage__c>();
                List<Sigma_Linkage__c> stockLink = [select Id, name, Received_Quantity__c, SRP__c from Sigma_Linkage__c where SRP__c IN: SRPSet];
                system.debug('Received_Quantity__c>>'+stockLink);
                for(Sigma_Linkage__c sl:stockLink)
                {
                    for(Id srpliId:SRPLIMap.keySet())
                    {
                        if(sl.SRP__c == SRPLIMap.get(srpliId).Stock_Receiving_Product__c)
                        {
                            SrpliIdSLMap.put(srpliId,sl);
                        }
                    }
                }
                system.debug('SrpliIdSLMap>>'+SrpliIdSLMap);
                if(SrpliIdSLMap.size() > 0)
                {
                    //Inserting child object
                    for(Id srpliId:SRPLIMap.keySet())
                    {
                        Sigma_Linkage_Item__c SLLI = new Sigma_Linkage_Item__c();
                        
                        SLLI.Activity_Date_Time__c = system.now();
                        SLLI.Sigma_Linkage__c = SrpliIdSLMap.get(srpliId).Id;
                        SLLI.Product__c = SRPLIMap.get(srpliId).Product__c;
                        SLLI.Stock_Receiving_Product_Line_Item__c = srpliId;
                        SLLI.Purchase_Order_Product__c = SRPLIMap.get(srpliId).Stock_Receiving_Product__r.Purchase_Order__c;
                        SLLI.Type__c = 'Stock Receiving';
                        system.debug('SRPLIMap.get(srpliId).Received_Quantity__c>>'+SRPLIMap.get(srpliId).Received_Quantity__c);
                        SLLI.Quantity__c = SRPLIMap.get(srpliId).Received_Quantity__c;
                        SLLIList.add(SLLI);
                    }
                    try
                    {
                        system.debug('SLLIList>>'+SLLIList);
                        if(SLLIList.size() > 0)
                        {
                            insert SLLIList;
                        }
                    }
                    catch(Exception e)
                    {
                        System.debug('Exception createSLFromILP LinkSRPLI slli:'+e.getMessage());
                    }
                }
            }
            else if(EventType == 'SRPLIUpdate')
            {
                slliList = [Select id,name,Stock_Receiving_Product_Line_Item__r.Received_Quantity__c from Sigma_Linkage_Item__c where Stock_Receiving_Product_Line_Item__c IN:ObjectId ];
                
                for(Sigma_Linkage_Item__c slli:slliList)
                {
                    slli.Quantity__c = slli.Stock_Receiving_Product_Line_Item__r.Received_Quantity__c;
                }
                update slliList;
            }
        }
        
    }
    ////////////////////////////////////////Fetch ILPLI(Inventory Location Product) data////////////////////////////////////////
    //create Stock Linkage Line Item record for inventory flow only in cases of Stock Receiving or Direct add
    //@Future
    public Static void LinkILPLI(Set<Id> ObjectId,String EventType) 
    {
        system.debug('ObjectId>>'+ObjectId);
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage_Item__c')
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'id', 'Name', 'sigmaerpdev2__Available_Quantity__c', 'sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Product__c', 'sigmaerpdev2__Stock_Origin__c', 'sigmaerpdev2__Inventory_Location_Product__c', 'sigmaerpdev2__Stock_Receiving_Product__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'Id', 'name', 'sigmaerpdev2__Received_Quantity__c', 'sigmaerpdev2__SRP__c','sigmaerpdev2__Stock_Origin__c','sigmaerpdev2__ILP__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'sigmaerpdev2__Received_Quantity__c', 'sigmaerpdev2__SRP__c','sigmaerpdev2__Stock_Origin__c','sigmaerpdev2__ILP__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Activity_Date_Time__c','sigmaerpdev2__Product__c','sigmaerpdev2__Type__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c'})  
           &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Sigma_Linkage__c'})  
           &&Schema.sObjectType.Sigma_Linkage__c.fields.Id.isAccessible()
           &&Schema.sObjectType.Sigma_Linkage__c.fields.name.isAccessible()
          )
        {*/
            
            List<Sigma_Linkage_Item__c> SLLIList = new List<Sigma_Linkage_Item__c>();   //to insert SLLI
            Set<Id> ilpliSR = new Set<Id>();    //to store ilpli with Stock Origin as 'Stock Receiving'
            Set<Id> ilpliDA = new Set<Id>();    //to store ilpli with Stock Origin as 'Direct Add'
            Map<ID, Inventory_Location_Product_Line_Item__c> ILPLIMap = new Map<ID, Inventory_Location_Product_Line_Item__c>([select id, Name, Available_Quantity__c, Received_Quantity__c,
                                                                                                                              Product__c, Stock_Origin__c, Inventory_Location_Product__c,Unit_Price__c, Stock_Receiving_Product__c
                                                                                                                              from Inventory_Location_Product_Line_Item__c where Id =: ObjectId]);                
            system.debug('ILPLIMap>>.'+ILPLIMap);
        	for(Id ilpli:ILPLIMap.keySet())
            {
                
                if(ILPLIMap.get(ilpli).Stock_Origin__c == 'Stock Receiving')
                {
                    ilpliSR.add(ILPLIMap.get(ilpli).Stock_Receiving_Product__c);
                    
                }
                else if(ILPLIMap.get(ilpli).Stock_Origin__c == 'Direct Add')
                {
                    ilpliDA.add(ILPLIMap.get(ilpli).Inventory_Location_Product__c);
                    system.debug('ilpliDA>>>'+ilpliDA);
                    
                }
            }
            
            Map<Decimal, Map<Id, Sigma_Linkage__c>> PriceIlpliIdSLMap = new Map<Decimal, Map<Id, Sigma_Linkage__c>>();
            List<Sigma_Linkage__c> stockLink = new List<Sigma_Linkage__c>();
            //Get Stock Linkage
            stockLink = [select Id, name, Received_Quantity__c, Stock_Origin__c, SRP__c, ILP__c, Unit_Cost__c from Sigma_Linkage__c where SRP__c IN: ilpliSR OR ILP__c IN: ilpliDA];
            system.debug('LinkILPLI stockLink:::: '+stockLink);
            for(Sigma_Linkage__c sl:stockLink)
            {
                
                for(Id ilpli:ILPLIMap.keySet())
                {
                    if(sl.Stock_Origin__c == 'Stock Receiving' && sl.SRP__c == ILPLIMap.get(ilpli).Stock_Receiving_Product__c)
                    {
                     /*   Map<Id, Sigma_Linkage__c> priceSLMap = new Map<Id, Sigma_Linkage__c>();
                        priceSLMap.put(ilpli,SL);
                        PriceIlpliIdSLMap.put(sl.Unit_Cost__c,priceSLMap);*/
                        if(PriceIlpliIdSLMap.containskey(sl.Unit_Cost__c))
                        {
                            Map<Id, Sigma_Linkage__c> priceSLMap = PriceIlpliIdSLMap.get(sl.Unit_Cost__c);
                            priceSLMap.put(ilpli,SL);
                            PriceIlpliIdSLMap.put(sl.Unit_Cost__c,priceSLMap);
                        }
                        else
                        {
                            Map<Id, Sigma_Linkage__c> priceSLMap = new Map<Id, Sigma_Linkage__c>();
                            priceSLMap.put(ilpli,SL);
                            PriceIlpliIdSLMap.put(sl.Unit_Cost__c,priceSLMap);
                        }
                        
                        system.debug('ilpliIdSLMap >>>'+PriceIlpliIdSLMap);
                        
                       
                    }
                    else if(sl.Stock_Origin__c == 'Direct Add' && sl.ILP__c == ILPLIMap.get(ilpli).Inventory_Location_Product__c)
                    {
                        if(PriceIlpliIdSLMap.containskey(sl.Unit_Cost__c))
                        {
                            Map<Id, Sigma_Linkage__c> priceSLMap = PriceIlpliIdSLMap.get(sl.Unit_Cost__c);
                            priceSLMap.put(ilpli,SL);
                            PriceIlpliIdSLMap.put(sl.Unit_Cost__c,priceSLMap);
                        }
                        else
                        {
                            Map<Id, Sigma_Linkage__c> priceSLMap = new Map<Id, Sigma_Linkage__c>();
                            priceSLMap.put(ilpli,SL);
                            PriceIlpliIdSLMap.put(sl.Unit_Cost__c,priceSLMap);
                        }
                        
                        system.debug('ilpliIdSLMap >>>'+PriceIlpliIdSLMap);
                    }
                }
            }
            
            if(PriceIlpliIdSLMap.size() > 0)
            {
                //Inserting child object
                for(Id ilpli:ILPLIMap.keySet())
                {
                    if(PriceIlpliIdSLMap.containskey(ILPLIMap.get(ilpli).Unit_Price__c) && PriceIlpliIdSLMap.get(ILPLIMap.get(ilpli).Unit_Price__c).containskey(ilpli))
                    {
                        Sigma_Linkage_Item__c SLLI = new Sigma_Linkage_Item__c();
                        SLLI.Activity_Date_Time__c = system.now();
                        SLLI.Sigma_Linkage__c = PriceIlpliIdSLMap.get(ILPLIMap.get(ilpli).Unit_Price__c).get(ilpli).Id;
                        SLLI.Product__c = ILPLIMap.get(ilpli).Product__c;
                        SLLI.Type__c = 'Inventory';
                        SLLI.Quantity__c = ILPLIMap.get(ilpli).Received_Quantity__c;
                        SLLI.Alternate_Unit_Price__c = ILPLIMap.get(ilpli).Unit_Price__c;
                        SLLI.Inventory_Location_Product_Line_Item__c = ilpli;
                        SLLIList.add(SLLI);
                    }
                }
            }
            try
            {
                if(SLLIList.size() > 0)
                {
                    insert SLLIList;
                }
                 system.debug('SLLIList >>>'+SLLIList);
            }
            catch(Exception e)
            {
                System.debug('Exception createSLFromILP LinkILPLI slli:'+e.getMessage());
            }
            
            // --------------------updating stock Linkage - parent object-------------------- //
            
            /*for(Sigma_Linkage__c sl:stockLink)
            {
                for(Id ilpli:ILPLIMap.keySet())
                {
                    if(ilpliIdSLMap.get(ilpli).Id == sl.Id)
                    {
                        sl.ILP__c = ILPLIMap.get(ilpli).Inventory_Location_Product__c;
                    }
                }
            }
            try
            {
                if(stockLink.size() > 0)
                {
                    update stockLink;
                }
            }
            catch(Exception e)
            {
                System.debug('Exception createSLFromILP LinkILPLI sl:'+e.getMessage());
            }*/
        //} 
        
    }
    ////////////////////////////////////////Fetch PPLI(Package Product Line Item) data////////////////////////////////////////
    //create Stock Linkage Line Item record for packaging
    //@Future
    public Static void LinkPPLI(Set<Id> ObjectId,String EventType,Map<Id,Id> ShipPackMap) 
    {
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Package_Product_Line_Item__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage_Item__c')
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Package_Product_Line_Item__c',new set<String>{'id', 'Name', 'sigmaerpdev2__Quantity__c', 'sigmaerpdev2__Status__c', 'sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__r.sigmaerpdev2__Stock_Origin__c', 'sigmaerpdev2__Inventory_Location_Product_Line_Item__r.sigmaerpdev2__Stock_Receiving_Product__c', 'sigmaerpdev2__Inventory_Location_Product_Line_Item__r.sigmaerpdev2__Inventory_Location_Product__c', 'sigmaerpdev2__Packaged_Product__c', 'sigmaerpdev2__Packaged_Product__r.sigmaerpdev2__Sigma_Order__c', 'sigmaerpdev2__Packaged_Product__r.sigmaerpdev2__Product_Order__c', 'sigmaerpdev2__Packaged_Product__r.sigmaerpdev2__Quantity__c', 'sigmaerpdev2__Packaged_Product__r.sigmaerpdev2__Quantity_used__c', 'sigmaerpdev2__Packaged_Product__r.sigmaerpdev2__Product__c','sigmaerpdev2__Packaged_Product__r.sigmaerpdev2__Package__c', 'sigmaerpdev2__Packaged_Product__r.sigmaerpdev2__Package__r.sigmaerpdev2__Status__c', 'sigmaerpdev2__Packaged_Product__r.sigmaerpdev2__Product_Order__r.sigmaerpdev2__Total_Amount__c','sigmaerpdev2__Packaged_Product__r.sigmaerpdev2__Product_Order__r.sigmaerpdev2__Total_Price__c','sigmaerpdev2__Packaged_Product__r.sigmaerpdev2__Product_Order__r.sigmaerpdev2__Subtotal__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'id', 'Name', 'sigmaerpdev2__Available_Quantity__c', 'sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Product__c', 'sigmaerpdev2__Stock_Origin__c', 'sigmaerpdev2__Inventory_Location_Product__c', 'sigmaerpdev2__Stock_Receiving_Product__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'Id', 'name', 'sigmaerpdev2__Packaged_Quantity__c', 'sigmaerpdev2__SRP__c','sigmaerpdev2__Stock_Origin__c','sigmaerpdev2__ILP__c','sigmaerpdev2__Delivered_Quantity__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'sigmaerpdev2__Packaged_Quantity__c', 'sigmaerpdev2__SRP__c','sigmaerpdev2__Stock_Origin__c','sigmaerpdev2__ILP__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'Id','sigmaerpdev2__Inventory_Location_Product_Line_Item__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Activity_Date_Time__c','sigmaerpdev2__Product__c','sigmaerpdev2__Type__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Sales_Unit_Price__c','sigmaerpdev2__Total_Sales_Value__c','sigmaerpdev2__Package_Product_Line_Item__c','sigmaerpdev2__Order_Line__c','sigmaerpdev2__Shipment_Product__c'})  
           &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Sigma_Linkage__c'})  
           && Schema.sObjectType.Sigma_Linkage__c.fields.Id.isAccessible()
           && Schema.sObjectType.Sigma_Linkage__c.fields.name.isAccessible()
          )
        {
            
            Map<ID, Package_Product_Line_Item__c> PPLIMap = new Map<ID, Package_Product_Line_Item__c>([select id, Name, Quantity__c, Status__c, Inventory_Location_Product_Line_Item__c, 
                                                                                                       Inventory_Location_Product_Line_Item__r.Stock_Origin__c, Inventory_Location_Product_Line_Item__r.Stock_Receiving_Product__c, Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__c,
                                                                                                       Packaged_Product__c, Packaged_Product__r.Sigma_Order__c, Packaged_Product__r.Product_Order__c, Packaged_Product__r.Quantity__c, Packaged_Product__r.Quantity_used__c, Packaged_Product__r.Product__c,
                                                                                                       Packaged_Product__r.Package__c, Packaged_Product__r.Package__r.Status__c, Packaged_Product__r.Product_Order__r.Total_Amount__c,Packaged_Product__r.Product_Order__r.Total_Price__c,Packaged_Product__r.Product_Order__r.Subtotal__c,
                                                                                                       Packaged_Product__r.Sigma_Order__r.recordtype.name,Packaged_Product__r.Product_Order__r.Amount_Per_Interval__c
                                                                                                       from Package_Product_Line_Item__c where Id =: ObjectId ]);
            
            if(PPLIMap.size() > 0)
            {
                
                Set<Id> IlpliSet = new Set<Id>();    //stores ilpli id
                Map<Id,Id> IlpliSlIdMap = new Map<Id,Id>();    //key => Ilpli id, value => stock Linkage record id
                Map<Id,Id> PpliSlIdMap = new Map<Id,Id>();    //key => Ppli id, value => stock Linkage record id
                
                //fetch ilpli ids
                for(Id ppli:PPLIMap.keySet())
                {
                    IlpliSet.add(PPLIMap.get(ppli).Inventory_Location_Product_Line_Item__c);
                }
                //to create a map of ilpli and respective sigma linkage
                //code added by anuja to remove bulkification
                List<Sigma_Linkage_Item__c> sigmalinkage=new List<Sigma_Linkage_Item__c>();
                sigmalinkage=[select Id, Sigma_Linkage__c, Inventory_Location_Product_Line_Item__c from Sigma_Linkage_Item__c where Inventory_Location_Product_Line_Item__c IN: IlpliSet];
                for(Sigma_Linkage_Item__c slli:sigmalinkage)
                {
                    IlpliSlIdMap.put(slli.Inventory_Location_Product_Line_Item__c, slli.Sigma_Linkage__c);
                }
                
                Map<Id,Sigma_Linkage__c> SLToUpdateMap = new Map<Id,Sigma_Linkage__c>();    //List of SL to be updated
                //code added by anuja to remove bulkification    
                List<Sigma_Linkage__c> Linkage=new List<Sigma_Linkage__c>();
                Linkage=[select Id, name, SRP__c, ILP__c, Packaged_Quantity__c,Delivered_Quantity__c, Stock_Origin__c from Sigma_Linkage__c where Id IN: IlpliSlIdMap.values()];
                for(Sigma_Linkage__c sl:Linkage)
                {
                    for(Id ppli:PPLIMap.keySet())
                    {
                        if(sl.Id == IlpliSlIdMap.get(PPLIMap.get(ppli).Inventory_Location_Product_Line_Item__c) )
                        {
                            if(EventType == 'SHIP')
                            {
                                sl.Delivered_Quantity__c = sl.Delivered_Quantity__c + PPLIMap.get(ppli).Quantity__c;
                            }
                            else
                            {
                                sl.Packaged_Quantity__c = sl.Packaged_Quantity__c + PPLIMap.get(ppli).Quantity__c;
                            }
                            
                            PpliSlIdMap.put(ppli,sl.Id);
                            SLToUpdateMap.put(sl.Id,sl);
                        }
                        
                    }
                }
                
                List<Sigma_Linkage__c> SLToUpdatelist = new List<Sigma_Linkage__c>();   //List of SL to be updated
                SLToUpdatelist = SLToUpdateMap.values();
                
                if(PpliSlIdMap.size() > 0)
                {
                    List<Sigma_Linkage_Item__c> SLLIList = new List<Sigma_Linkage_Item__c>();   //to insert SLLI
                    for(Id ppli:PPLIMap.keySet())
                    {
                        system.debug('record name::'+PPLIMap.get(ppli).Packaged_Product__r.Sigma_Order__r.recordtype.name);
                        system.debug('rental amount::'+PPLIMap.get(ppli).Packaged_Product__r.Product_Order__r.Amount_Per_Interval__c);
                        Sigma_Linkage_Item__c SLLI = new Sigma_Linkage_Item__c();
                        SLLI.Activity_Date_Time__c = system.now();
                        SLLI.Sigma_Linkage__c = PpliSlIdMap.get(ppli);
                        SLLI.Product__c = PPLIMap.get(ppli).Packaged_Product__r.Product__c;
                        SLLI.Quantity__c = PPLIMap.get(ppli).Quantity__c;
                        if(PPLIMap.get(ppli).Packaged_Product__r.Sigma_Order__r.recordtype.name == 'Rental Order')
                        {
                            SLLI.Sales_Unit_Price__c = PPLIMap.get(ppli).Packaged_Product__r.Product_Order__r.Amount_Per_Interval__c;
                        }
                        else
                        {
                            SLLI.Sales_Unit_Price__c = PPLIMap.get(ppli).Packaged_Product__r.Product_Order__r.Total_Amount__c;
                        }
                       // SLLI.Total_Sales_Value__c = PPLIMap.get(ppli).Packaged_Product__r.Product_Order__r.Total_Price__c/PPLIMap.get(ppli).Quantity__c;
            SLLI.Total_Sales_Value__c = (SLLI.Sales_Unit_Price__c  * SLLI.Quantity__c);
                        
                        SLLI.Inventory_Location_Product_Line_Item__c = PPLIMap.get(ppli).Inventory_Location_Product_Line_Item__c;
                        SLLI.Package_Product_Line_Item__c = ppli;
                        SLLI.Order_Line__c = PPLIMap.get(ppli).Packaged_Product__r.Product_Order__c;
                        if(EventType == 'SHIP')
                        {
                            SLLI.Shipment_Product__c = ShipPackMap.get(PPLIMap.get(ppli).Packaged_Product__r.Package__c);
                            SLLI.Type__c = 'Shipment';
                        }
                        else
                        {
                            SLLI.Type__c = 'Package';
                        }
                        SLLIList.add(SLLI);
                    }
                    
                    try
                    {
                        if(SLLIList.size() > 0)
                        {
                            insert SLLIList;
                        }
                        if(SLToUpdatelist.size() > 0)
                        {
                            update SLToUpdatelist;
                        }
                    }
                    catch(Exception e)
                    {
                        System.debug('Exception createSLFromILP LinkPPLI:'+e.getMessage());
                    }
                }
                //end of if for ppli map
            }
        }
        //end of method
    }
    
    ////////////////////////////////////////Fetch SOALI(Sales Order Allocation Line Item) data////////////////////////////////////////
    //create Stock Linkage Line Item record for Allocation
    //@Future
    public Static void LinkSOALI(Set<Id> ObjectId,String EventType) 
    {
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sales_Order_Allocation_Line_Item__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage_Item__c')
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sales_Order_Allocation_Line_Item__c',new set<String>{'id', 'Name','sigmaerpdev2__Allocated_Quantity__c', 'sigmaerpdev2__Inventory_Location_Product_Line_Item__c', 'sigmaerpdev2__Ordered_Quantity__c','sigmaerpdev2__Order_Line__c','sigmaerpdev2__Status__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__r.sigmaerpdev2__Stock_Origin__c', 'sigmaerpdev2__Inventory_Location_Product_Line_Item__r.sigmaerpdev2__Stock_Receiving_Product__c', 'sigmaerpdev2__Inventory_Location_Product_Line_Item__r.sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Order_Line__r.sigmaerpdev2__Product__c','sigmaerpdev2__Sales_Order_Allocation__c','sigmaerpdev2__Sales_Order_Allocation__r.sigmaerpdev2__Sigma_Order__c', 'sigmaerpdev2__Sales_Order_Allocation__r.sigmaerpdev2__Status__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'Id', 'name', 'sigmaerpdev2__Allocated_Quantity__c', 'sigmaerpdev2__SRP__c','sigmaerpdev2__Stock_Origin__c','sigmaerpdev2__ILP__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'sigmaerpdev2__Allocated_Quantity__c', 'sigmaerpdev2__SRP__c','sigmaerpdev2__Stock_Origin__c','sigmaerpdev2__ILP__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'Id', 'sigmaerpdev2__Sigma_Linkage__c', 'sigmaerpdev2__Inventory_Location_Product_Line_Item__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Activity_Date_Time__c','sigmaerpdev2__Product__c','sigmaerpdev2__Type__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Sales_Order_Allocation_Line_Item__c','sigmaerpdev2__Order_Line__c'})  
           &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Sigma_Linkage__c'})  
           && Schema.sObjectType.Sigma_Linkage__c.fields.Id.isAccessible() 
           && Schema.sObjectType.Sigma_Linkage__c.fields.name.isAccessible()     
          )
        {
            
            Map<ID, Sales_Order_Allocation_Line_Item__c> SOALIMap = new Map<ID, Sales_Order_Allocation_Line_Item__c>([select id, Name, Allocated_Quantity__c, Inventory_Location_Product_Line_Item__c, Ordered_Quantity__c,Order_Line__c,Status__c,
                                                                                                                      Inventory_Location_Product_Line_Item__r.Stock_Origin__c, Inventory_Location_Product_Line_Item__r.Stock_Receiving_Product__c, Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__c,Order_Line__r.Product__c,
                                                                                                                      Sales_Order_Allocation__c,Sales_Order_Allocation__r.Sigma_Order__c, Sales_Order_Allocation__r.Status__c
                                                                                                                      from Sales_Order_Allocation_Line_Item__c where Id =: ObjectId]);
            
            
            if(SOALIMap.size() > 0)
            {
                
                Set<Id> IlpliSet = new Set<Id>();    //stores ilpli id
                Map<Id,Id> IlpliSlIdMap = new Map<Id,Id>();    //key => Ilpli id, value => stock Linkage record id
                //fetch ilpli ids
                for(Id soali:SOALIMap.keySet())
                {
                    IlpliSet.add(SOALIMap.get(soali).Inventory_Location_Product_Line_Item__c);
                }
                
                //To create a map of ilpli and respective sigma linkage
                //code added by anuja to remove bulkification
                List<Sigma_Linkage_Item__c> sigmalinkage=new List<Sigma_Linkage_Item__c>();
                sigmalinkage=[select Id, Sigma_Linkage__c, Inventory_Location_Product_Line_Item__c from Sigma_Linkage_Item__c where Inventory_Location_Product_Line_Item__c IN: IlpliSet];
                for(Sigma_Linkage_Item__c slli:sigmalinkage)
                {
                    IlpliSlIdMap.put(slli.Inventory_Location_Product_Line_Item__c, slli.Sigma_Linkage__c);
                }
                Map<Id,Id> SoaliSlIdMap = new Map<Id,Id>();    //key => soali id, value => stock Linkage record id
                Map<Id,Sigma_Linkage__c> SLToUpdateMap = new Map<Id,Sigma_Linkage__c>();    //List of SL to be updated
                //code added by anuja to remove bulkification
                List<Sigma_Linkage__c> linkage=new List<Sigma_Linkage__c>();
                linkage=[select Id, name, Allocated_Quantity__c,SRP__c, ILP__c, Stock_Origin__c from Sigma_Linkage__c where Id IN: IlpliSlIdMap.values()];
                for(Sigma_Linkage__c sl:linkage)
                {
                    for(Id soali:SOALIMap.keySet())
                    {
                        if(sl.Id == IlpliSlIdMap.get(SOALIMap.get(soali).Inventory_Location_Product_Line_Item__c) )
                        {
                            sl.Allocated_Quantity__c = sl.Allocated_Quantity__c + SOALIMap.get(soali).Allocated_Quantity__c;
                            SoaliSlIdMap.put(soali,sl.Id);
                            SLToUpdateMap.put(sl.Id,sl);
                        }
                        
                    }
                }
                List<Sigma_Linkage__c> SLToUpdatelist = new List<Sigma_Linkage__c>();   //List of SL to be updated
                SLToUpdatelist = SLToUpdateMap.values();
                if(SoaliSlIdMap.size() > 0)
                {
                    List<Sigma_Linkage_Item__c> SLLIList = new List<Sigma_Linkage_Item__c>();   //to insert SLLI
                    for(Id soali:SOALIMap.keySet())
                    {
                        Sigma_Linkage_Item__c SLLI = new Sigma_Linkage_Item__c();
                        SLLI.Activity_Date_Time__c = system.now();
                        SLLI.Sigma_Linkage__c = SoaliSlIdMap.get(soali);
                        SLLI.Product__c = SOALIMap.get(soali).Order_Line__r.Product__c;
                        SLLI.Type__c = 'Allocation';
                        SLLI.Quantity__c = SOALIMap.get(soali).Allocated_Quantity__c;
                        SLLI.Inventory_Location_Product_Line_Item__c = SOALIMap.get(soali).Inventory_Location_Product_Line_Item__c;
                        SLLI.Sales_Order_Allocation_Line_Item__c = soali;
                        SLLI.Order_Line__c = SOALIMap.get(soali).Order_Line__c;
                        SLLIList.add(SLLI);
                    }
                    try
                    {   
                        if(SLLIList.size() > 0)
                        {
                            insert SLLIList;
                        }
                        if(SLToUpdatelist.size() > 0)
                        {
                            update SLToUpdatelist;
                        }
                    }
                    catch(Exception e)
                    {
                        System.debug('Exception createSLFromILP LinkSOALI:'+e.getMessage());
                    }
                }
                
                //end of if soali map
            }
        }
        //end of method
    }
    ////////////////////////////////////////Fetch Ship Pro(Package Product Line Item) data////////////////////////////////////////
    //create Stock Linkage Line Item record for Shipment
    //@Future
    public Static void LinkShipment(Map<Id,Id> ShipPackMap,Set<Id> PackageId,String EventType) 
    {
        
       if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__PackagedProducts__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Allocation__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Package_Product_Line_Item__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage_Item__c')
           
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'Id','name','sigmaerpdev2__SRP__c','sigmaerpdev2__ILP__c','sigmaerpdev2__Packaged_Quantity__c','sigmaerpdev2__Delivered_Quantity__c','sigmaerpdev2__Stock_Origin__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'Id','sigmaerpdev2__Sigma_Linkage__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__PackagedProducts__c',new set<String>{'id', 'Name','sigmaerpdev2__Package__c','sigmaerpdev2__Order__c','sigmaerpdev2__Order__r.recordtype.name','sigmaerpdev2__Quantity__c','sigmaerpdev2__Status__c','sigmaerpdev2__Package__c','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__Product_Order__c','sigmaerpdev2__Quantity_used__c','sigmaerpdev2__Product__c','sigmaerpdev2__Package__r.sigmaerpdev2__Status__c','sigmaerpdev2__Product_Order__r.sigmaerpdev2__Total_Amount__c','sigmaerpdev2__Product_Order__r.sigmaerpdev2__Total_Price__c','sigmaerpdev2__Product_Order__r.sigmaerpdev2__Subtotal__c','sigmaerpdev2__Sigma_Order__r.recordtype.name','sigmaerpdev2__Product_Order__r.sigmaerpdev2__Amount_Per_Interval__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Package_Product_Line_Item__c',new set<String>{'id', 'Name','sigmaerpdev2__Packaged_Product__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Allocation__c',new set<String>{'id','sigmaerpdev2__ILPLI__c','sigmaerpdev2__Packaged_Product__c','sigmaerpdev2__Packaged_Product__r.sigmaerpdev2__Product__c','sigmaerpdev2__Packaged_Product__r.Product__r.sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Packaged_Product__r.sigmaerpdev2__Package__c','sigmaerpdev2__Order_Line__c','sigmaerpdev2__Order_Line__r.sigmaerpdev2__Total_Amount__c','sigmaerpdev2__Order_Line__r.sigmaerpdev2__Total_Price__c','sigmaerpdev2__Order_Line__r.sigmaerpdev2__Subtotal__c','sigmaerpdev2__Order_Line__r.sigmaerpdev2__Amount_Per_Interval__c','sigmaerpdev2__Order_Line__r.sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Order_Product__c','sigmaerpdev2__Order_Product__r.UnitPrice','sigmaerpdev2__Order_Product__r.sigmaerpdev2__TotalPrice__c','sigmaerpdev2__Order_Product__r.product2.sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Order_Product__r.Quantity'})
           
           
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'sigmaerpdev2__Delivered_Quantity__c','sigmaerpdev2__Packaged_Quantity__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Activity_Date_Time__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Sales_Unit_Price__c','sigmaerpdev2__Total_Sales_Value__c','sigmaerpdev2__Order_Line__c','sigmaerpdev2__Order_Products__c','sigmaerpdev2__Type__c','sigmaerpdev2__Shipment_Product__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c'})
           &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Sigma_Linkage__c'})     
          )
        {    
            /*
Set<Id> PPSet = new Set<Id>();
Set<Id> PPLISet = new Set<Id>();
for(PackagedProducts__c pp : [select id, Name from PackagedProducts__c where Package__c =: PackageId] )
{
PPSet.add(pp.id);
}  
for(Package_Product_Line_Item__c ppli : [select id, Name from Package_Product_Line_Item__c where Packaged_Product__c =: PPSet] )
{
PPLISet.add(ppli.id);
} 
LinkPPLI(PPSet,EventType,ShipPackMap);
*/
            //changes done on 4 Oct to go forward with new PackagedProducts__c object instead of Package_Product_Line_Item__c
            
            Map<ID, PackagedProducts__c> PPLIMap = new Map<ID, PackagedProducts__c>([select id,Order__c,Order__r.recordtype.name, Name, Quantity__c, Status__c, Package__c, Sigma_Order__c, Product_Order__c, Quantity_used__c, Product__c, Package__r.Status__c, Product_Order__r.Total_Amount__c,Product_Order__r.Total_Price__c,Product_Order__r.Subtotal__c, Sigma_Order__r.recordtype.name,Product_Order__r.Amount_Per_Interval__c, (select id,ILPLI__c, Packaged_Product__c, Packaged_Product__r.Product__c,Packaged_Product__r.Product__r.Attribute_Type__c,Packaged_Product__r.Package__c, Order_Line__c, Order_Line__r.Total_Amount__c, Order_Line__r.Total_Price__c, Order_Line__r.Subtotal__c, Order_Line__r.Amount_Per_Interval__c,Order_Line__r.Net_Quantity__c, Quantity__c,Order_Product__c,Order_Product__r.UnitPrice,Order_Product__r.TotalPrice__c,Order_Product__r.product2.Attribute_Type__c,Order_Product__r.Quantity from Inventory_Allocations1__r) from PackagedProducts__c where Package__c =: PackageId ]);
            
            Set<Id> IlpliSet = new Set<Id>();    //stores ilpli id
            Map<Id,Inventory_Allocation__c> IlpliNIaMap = new Map<Id,Inventory_Allocation__c>();    //stores inventory allocation list
            Map<Id,Id> IlpliSlIdMap = new Map<Id,Id>();    //key => Ilpli id, value => stock Linkage record id
            Map<Id,Id> IaSlIdMap = new Map<Id,Id>();    //key => inventory allocation id, value => stock Linkage record id
            
            //fetch ilpli ids
            for(Id ppli:PPLIMap.keySet())
            {
                for(Inventory_Allocation__c ia:PPLIMap.get(ppli).Inventory_Allocations1__r)
                {
                    IlpliSet.add(ia.ILPLI__c);
                    IlpliNIaMap.put(ia.Id,ia);
                }
            }
            //to create a map of ilpli and respective sigma linkage
            //code added by anuja to remove bulkification
            List<Sigma_Linkage_Item__c> sigmalinkage=new List<Sigma_Linkage_Item__c>();
            sigmalinkage=[select Id, Sigma_Linkage__c, Inventory_Location_Product_Line_Item__c from Sigma_Linkage_Item__c where Inventory_Location_Product_Line_Item__c IN: IlpliSet];
            for(Sigma_Linkage_Item__c slli:sigmalinkage)
            {
                IlpliSlIdMap.put(slli.Inventory_Location_Product_Line_Item__c, slli.Sigma_Linkage__c);
            }
            
            //List<Sigma_Linkage__c> SLToUpdateList = new List<Sigma_Linkage__c>();    //List of SL to be updated
            //code added by anuja to remove bulkification    
            List<Sigma_Linkage__c> slListToUpdate=new List<Sigma_Linkage__c>();
            slListToUpdate=[select Id, name, SRP__c, ILP__c, Packaged_Quantity__c,Delivered_Quantity__c, Stock_Origin__c from Sigma_Linkage__c where Id IN: IlpliSlIdMap.values()];
            
            for(Id ia:IlpliNIaMap.keySet())
            {
                for(Sigma_Linkage__c sl:slListToUpdate)
                {
                    if(sl.Id == IlpliSlIdMap.get( IlpliNIaMap.get(ia).ILPLI__c ))
                    {
                        if(EventType == 'SHIP')
                        {
                            sl.Delivered_Quantity__c = sl.Delivered_Quantity__c + IlpliNIaMap.get(ia).Quantity__c;
                        }
                        else
                        {
                            sl.Packaged_Quantity__c = sl.Packaged_Quantity__c + IlpliNIaMap.get(ia).Quantity__c;
                        }
                        
                        IaSlIdMap.put(ia,sl.Id);
                        //SLToUpdateMap.add(sl);
                    }
                }
            }
            
            if(IaSlIdMap.size() > 0)
            {
                List<Sigma_Linkage_Item__c> SLLIList = new List<Sigma_Linkage_Item__c>();   //to insert SLLI
                for(Id ia:IlpliNIaMap.keySet())
                {
                    system.debug('record name::'+PPLIMap.get( IlpliNIaMap.get(ia).Packaged_Product__c ).Sigma_Order__r.recordtype.name);
                    system.debug('rental amount::'+IlpliNIaMap.get(ia).Order_Line__r.Amount_Per_Interval__c);
                    Sigma_Linkage_Item__c SLLI = new Sigma_Linkage_Item__c();
                    SLLI.Activity_Date_Time__c = system.now();
                    SLLI.Sigma_Linkage__c = IaSlIdMap.get(ia);
                    SLLI.Product__c = IlpliNIaMap.get(ia).Packaged_Product__r.Product__c;
                    SLLI.Quantity__c = IlpliNIaMap.get(ia).Quantity__c;
          
                    if(PPLIMap.get( IlpliNIaMap.get(ia).Packaged_Product__c ).Sigma_Order__r.recordtype.name == 'Rental Order')
                    {
                        SLLI.Sales_Unit_Price__c = IlpliNIaMap.get(ia).Order_Line__r.Amount_Per_Interval__c;
                        if(IlpliNIaMap.get(ia).Packaged_Product__r.Product__r.Attribute_Type__c == 'SERIALIZED')
                        {
                            SLLI.Total_Sales_Value__c = (IlpliNIaMap.get(ia).Order_Line__r.Total_Price__c/IlpliNIaMap.get(ia).Order_Line__r.Net_Quantity__c);
                        }
                        else
                        {
                           // SLLI.Total_Sales_Value__c = (IlpliNIaMap.get(ia).Order_Line__r.Total_Price__c/IlpliNIaMap.get(ia).Order_Line__r.Net_Quantity__c);
               SLLI.Total_Sales_Value__c = (SLLI.Sales_Unit_Price__c  * SLLI.Quantity__c);
                        
                        }
                        SLLI.Order_Line__c = IlpliNIaMap.get(ia).Order_Line__c;
                    }
                    else if(PPLIMap.get( IlpliNIaMap.get(ia).Packaged_Product__c).Order__r.recordtype.name == 'Record Type')
                    {
                        SLLI.Sales_Unit_Price__c = IlpliNIaMap.get(ia).Order_Product__r.UnitPrice;
                        if(IlpliNIaMap.get(ia).Order_Product__r.product2.Attribute_Type__c == 'SERIALIZED')
                        {
                            SLLI.Total_Sales_Value__c = (IlpliNIaMap.get(ia).Order_Product__r.TotalPrice__c/IlpliNIaMap.get(ia).Order_Product__r.Quantity);
                        }
                        else
                        {
                            //SLLI.Total_Sales_Value__c = (IlpliNIaMap.get(ia).Order_Product__r.TotalPrice__c/IlpliNIaMap.get(ia).Order_Line__r.Net_Quantity__c);
               SLLI.Total_Sales_Value__c = (SLLI.Sales_Unit_Price__c  * SLLI.Quantity__c);
                        }
                        
                        SLLI.Order_Products__c = IlpliNIaMap.get(ia).Order_Product__c;
                    }
                    else
                    {
                        SLLI.Sales_Unit_Price__c = IlpliNIaMap.get(ia).Order_Line__r.Total_Amount__c;
                        if(IlpliNIaMap.get(ia).Packaged_Product__r.Product__r.Attribute_Type__c == 'SERIALIZED')
                        {
                            SLLI.Total_Sales_Value__c = (IlpliNIaMap.get(ia).Order_Line__r.Total_Price__c/IlpliNIaMap.get(ia).Order_Line__r.Net_Quantity__c);
                        }
                        else
                        {
                            SLLI.Total_Sales_Value__c = (IlpliNIaMap.get(ia).Order_Line__r.Total_Price__c/IlpliNIaMap.get(ia).Order_Line__r.Net_Quantity__c);
              SLLI.Total_Sales_Value__c = (SLLI.Sales_Unit_Price__c  * SLLI.Quantity__c);
            }
                        SLLI.Order_Line__c = IlpliNIaMap.get(ia).Order_Line__c;
                    }
                    
                    SLLI.Inventory_Location_Product_Line_Item__c = IlpliNIaMap.get(ia).ILPLI__c;
                    //SLLI.Package_Product_Line_Item__c = ppli;
                    SLLI.Shipment_Product__c = ShipPackMap.get( IlpliNIaMap.get(ia).Packaged_Product__r.Package__c );
                    SLLI.Type__c = 'Shipment';
                    SLLIList.add(SLLI);
                }
                System.debug('SLLIList:'+SLLIList);
                try
                {
                    if(SLLIList.size() > 0)
                    {
                        insert SLLIList;
                    }
                    if(slListToUpdate.size() > 0)
                    {
                        update slListToUpdate;
                    }
                }
                catch(Exception e)
                {
                    System.debug('Exception createSLFromILP LinkPPLI:'+e.getMessage());
                }
            }
        }
        //end of method
    }
    ////////////////////////////////////////Stock Adjustment////////////////////////////////////////
    //created SL and SLLI on Stock Adjustment Increase operation
    //@Future
    public Static void LinkSAIncrease(List<StockAdjustment__c> SaRecords, Map<Id,Stock_Adjustment_Product__c> SAPMap) 
    {
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__StockAdjustment__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Stock_Adjustment_Product__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage_Item__c')
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__StockAdjustment__c',new set<String>{'id', 'Name','sigmaerpdev2__Adjust_Type__c','sigmaerpdev2__Adjusted_Qty__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Inventory_Location_Product__r.Products__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Unit_Price__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Stock_Adjustment_Product__c',new set<String>{'id', 'Name', 'sigmaerpdev2__Adjusted_Quantity__c','sigmaerpdev2__ILPLI__c', 'sigmaerpdev2__ILPLI__r.Products__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'Id', 'name','sigmaerpdev2__Adjusted_Quantity__c','sigmaerpdev2__Allocated_Quantity__c','sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Packaged_Quantity__c','sigmaerpdev2__Delivered_Quantity__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage__c',new set<String>{ 'sigmaerpdev2__Product__c', 'sigmaerpdev2__ILP__c','sigmaerpdev2__Stock_Origin__c','sigmaerpdev2__Unit_Cost__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__SA__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'Id','sigmaerpdev2__Activity_Date_Time__c','sigmaerpdev2__Sigma_Linkage__c', 'sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Product__c','sigmaerpdev2__Type__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__SAP__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Activity_Date_Time__c','sigmaerpdev2__Product__c','sigmaerpdev2__Type__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__SAP__c'})  
           &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Sigma_Linkage__c'})  
          )
        {
            List<Sigma_Linkage_Item__c> SlliToInsert = new List<Sigma_Linkage_Item__c>();   //to insert SLLI
            
            List<Sigma_Linkage__c>  sllistToInsert=new List<Sigma_Linkage__c>();
            for(StockAdjustment__c SaRecord:SaRecords)
            {
                Sigma_Linkage__c slToInsert = new Sigma_Linkage__c();
                slToInsert.Product__c = SaRecord.Inventory_Location_Product__r.Products__c;
                slToInsert.ILP__c = SaRecord.Inventory_Location_Product__c;
                slToInsert.Unit_Cost__c = SaRecord.Unit_Price__c;
                //slToInsert.Received_Quantity__c = SaRecord.Adjusted_Qty__c;
                slToInsert.Received_Quantity__c = SaRecord.Quantity__c;
                slToInsert.Stock_Origin__c = 'Stock Increased';
                slToInsert.SA__c = SaRecord.Id;
                sllistToInsert.add(slToInsert);
            }
            insert sllistToInsert;
            system.debug('LinkSAIncrease slToInsert after insert:::: '+sllistToInsert);
            
            for(Id sapid:SAPMap.keyset())
            {
                Sigma_Linkage_Item__c SLLI = new Sigma_Linkage_Item__c();
                SLLI.Activity_Date_Time__c = system.now();
                SLLI.SAP__c = sapid;
                SLLI.Sigma_Linkage__c = sllistToInsert[0].id;
                SLLI.Product__c = sllistToInsert[0].Product__c;
                SLLI.Type__c = 'Inventory';
                SLLI.Quantity__c = SAPMap.get(sapid).Adjusted_Quantity__c;
                SLLI.Inventory_Location_Product_Line_Item__c = SAPMap.get(sapid).ILPLI__c;
                
                SlliToInsert.add(SLLI);
            }
            
            insert SlliToInsert;
            system.debug('LinkSAIncrease SlliToInsert after insert:::: '+SlliToInsert);
        }
    }
    //created SL and SLLI on Stock Adjustment decrease operation
    //@Future
    public Static void LinkSADecrease(List<Stock_Adjustment_Product__c> SAPList, Id SAId, Set<Id> ILPLISet, String EventType) 
    {
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__StockAdjustment__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Stock_Adjustment_Product__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage_Item__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__StockAdjustment__c',new set<String>{'id', 'Name','sigmaerpdev2__Adjust_Type__c','sigmaerpdev2__Adjusted_Qty__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Inventory_Location_Product__r.Products__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Unit_Price__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Stock_Adjustment_Product__c',new set<String>{'id', 'Name', 'sigmaerpdev2__Adjusted_Quantity__c','sigmaerpdev2__ILPLI__c', 'sigmaerpdev2__ILPLI__r.Products__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'Id', 'name','sigmaerpdev2__Adjusted_Quantity__c','sigmaerpdev2__Allocated_Quantity__c','sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Packaged_Quantity__c','sigmaerpdev2__Delivered_Quantity__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'Id','name', 'sigmaerpdev2__Sigma_Linkage__c', 'sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Product__c','sigmaerpdev2__Type__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__SAP__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Activity_Date_Time__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Product__c','sigmaerpdev2__Type__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__SAP__c'})  
           &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Sigma_Linkage__c'})  
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'Id','name','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Stock_Origin__c','sigmaerpdev2__Inventory_Location_Product__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'sigmaerpdev2__Adjusted_Quantity__c'})
          )
        {
            List<StockAdjustment__c> SAObj = new List<StockAdjustment__c>();
            SAObj = [select id,name,Adjust_Type__c,Adjusted_Qty__c,Inventory_Location_Product__c,Inventory_Location_Product__r.Products__c,Quantity__c,Unit_Price__c from StockAdjustment__c where Id =:SAId limit 1];
            Map<ID, Inventory_Location_Product_Line_Item__c> ILPLIMap = new Map<ID, Inventory_Location_Product_Line_Item__c>([select id, Name, Received_Quantity__c,Product__c, Stock_Origin__c, Inventory_Location_Product__c
                                                                                                                              from Inventory_Location_Product_Line_Item__c where Id =: ILPLISet]);
            Map<Id,Stock_Adjustment_Product__c> SAPMap = new Map<Id,Stock_Adjustment_Product__c>();
            for(Stock_Adjustment_Product__c sap:SAPList)
            {
                SAPMap.put(sap.Id,sap);
            }
            if( SAObj[0].Adjust_Type__c == 'Increase Stock' )
            {
                LinkSAIncrease(SAObj,SAPMap);
            }
            else
            {
                List<Sigma_Linkage_Item__c> SLLIList = new List<Sigma_Linkage_Item__c>();   //to insert SLLI
                Map<Id,Id> ilpliIdSLMap = new Map<Id,Id>(); //key => ilpli id value=> sigma linkage record
                ilpliIdSLMap = returnSlForIlpli(ILPLISet);
                
                Map<Id,Sigma_Linkage__c> SLToUpdateMap = new Map<Id,Sigma_Linkage__c>();    //key => sl id value=> sigma linkage record
                SLToUpdateMap = toGetSigmaLinkage( ilpliIdSLMap.values() );
                
                for(Stock_Adjustment_Product__c sap:SAPList)
                {
                    if( ilpliIdSLMap.containskey( sap.ILPLI__c ) && SLToUpdateMap.containskey( ilpliIdSLMap.get( sap.ILPLI__c ) ) )
                    {
                        Sigma_Linkage_Item__c SLLI = new Sigma_Linkage_Item__c();
                        SLLI.Activity_Date_Time__c = system.now();
                        SLLI.Sigma_Linkage__c = ilpliIdSLMap.get( sap.ILPLI__c );
                        SLLI.Product__c = ILPLIMap.get( sap.ILPLI__c ).Product__c;
                        SLLI.Type__c = 'Stock Decreased';
                        SLLI.Quantity__c = sap.Adjusted_Quantity__c;
                        SLLI.Inventory_Location_Product_Line_Item__c = sap.ILPLI__c;
                        SLLI.SAP__c = sap.Id;
                        SLLIList.add(SLLI);
                        
                        Sigma_Linkage__c sl = SLToUpdateMap.get( ilpliIdSLMap.get( sap.ILPLI__c ) );
                        sl.Adjusted_Quantity__c += sap.Adjusted_Quantity__c;
                        SLToUpdateMap.put(sl.Id,sl);
                        
                    }
                }
                if(SLLIList.size()>0)
                {
                    insert SLLIList;
                    update SLToUpdateMap.values();
                }
                
            }
        }
    }
    ////////////////////////////////////////Stock Movement////////////////////////////////////////
    //created SL and SLLI on Stock Adjustment Increase operation; called from updateInventoryFromStockMov1
    //@Future
    public Static void LinkStockMovement(List<Stock_Moment_Product__c> SMPList, Set<Id> fromIlpliSet, Set<Id> toIlpliSet, String EventType) 
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Stock_Moment_Product__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage_Item__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Stock_Moment_Product__c',new set<String>{'id','Name','sigmaerpdev2__Adjusted_Quantity__c','sigmaerpdev2__ILPLI__c','sigmaerpdev2__ILPLI__r.Products__c','sigmaerpdev2__From_ILPLI__c','sigmaerpdev2__Product2__c','sigmaerpdev2__Moved_Quantity__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'Id', 'name','sigmaerpdev2__Adjusted_Quantity__c','sigmaerpdev2__Allocated_Quantity__c','sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Packaged_Quantity__c','sigmaerpdev2__Delivered_Quantity__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'Id','sigmaerpdev2__Activity_Date_Time__c','sigmaerpdev2__Sigma_Linkage__c', 'sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Product__c','sigmaerpdev2__Type__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__SMP__c','sigmaerpdev2__Alternate_Unit_Price__c'})
           &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Sigma_Linkage__c'})  
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Activity_Date_Time__c','sigmaerpdev2__Product__c','sigmaerpdev2__Type__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__SMP__c','sigmaerpdev2__Alternate_Unit_Price__c'})  
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'sigmaerpdev2__Insurance__c','sigmaerpdev2__Freight__c','sigmaerpdev2__Duty__c','sigmaerpdev2__Other__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Product__c', 'sigmaerpdev2__ILP__c','sigmaerpdev2__Stock_Origin__c','sigmaerpdev2__Unit_Cost__c','sigmaerpdev2__Adjusted_Quantity__c'})
          )
        {
            List<Sigma_Linkage_Item__c> SLIList = new List<Sigma_Linkage_Item__c>();   //to insert SLLI
            //from location/ stock out
            Map<Id,Id> fromilpliIdSLMap = new Map<Id,Id>(); //key => ilpli id value=> sigma linkage record
            fromilpliIdSLMap = returnSlForIlpli(fromIlpliSet);
            
            Map<Id,Sigma_Linkage__c> fromSLToUpdateMap = new Map<Id,Sigma_Linkage__c>();    //key => sl id value=> sigma linkage record
            fromSLToUpdateMap = toGetSigmaLinkage( fromilpliIdSLMap.values() );
            
            //to location/ stock in
            Map<Id,Id> toilpliIdSLMap = new Map<Id,Id>();   //key => ilpli id value=> sigma linkage Id
            
            createSLFromILPLI(toIlpliSet);
            toilpliIdSLMap = returnSlForIlpli(toIlpliSet);
            Map<Id,Sigma_Linkage__c> toSLToUpdateMap = new Map<Id,Sigma_Linkage__c>();  //key => sl id value=> sigma linkage record
            toSLToUpdateMap = toGetSigmaLinkage( toilpliIdSLMap.values() );
            
            //create SLI for source ILPLI
            for(Stock_Moment_Product__c smp:SMPList)
            {
            system.debug('smp>>'+smp);
                if( fromilpliIdSLMap.containskey( smp.From_ILPLI__c ) && toilpliIdSLMap.containskey( smp.ILPLI__c ) )
                {
                system.debug('SLIList'+SLIList);
                    Sigma_Linkage_Item__c SLIsource = new Sigma_Linkage_Item__c();
                    SLIsource.Activity_Date_Time__c = system.now();
                    SLIsource.Sigma_Linkage__c = fromilpliIdSLMap.get( smp.From_ILPLI__c );
                    SLIsource.Product__c = smp.Product2__c;
                    SLIsource.Type__c = 'Stock OUT';
                    SLIsource.Quantity__c = smp.Moved_Quantity__c;
                    SLIsource.Inventory_Location_Product_Line_Item__c = smp.From_ILPLI__c;
                    SLIsource.SMP__c = smp.Id;
                    SLIList.add(SLIsource);
                    
                    Sigma_Linkage__c slout = fromSLToUpdateMap.get( fromilpliIdSLMap.get( smp.From_ILPLI__c ) );
                    slout.Moved_OUT__c += smp.Moved_Quantity__c;
                    fromSLToUpdateMap.put(slout.Id,slout);
                    
                    Sigma_Linkage_Item__c SLIdestination = new Sigma_Linkage_Item__c();
                    SLIdestination.Activity_Date_Time__c = system.now();
                    SLIdestination.Sigma_Linkage__c = toilpliIdSLMap.get( smp.ILPLI__c );
                    SLIdestination.Product__c = smp.Product2__c;
                    SLIdestination.Type__c = 'Stock IN';
                    SLIdestination.Quantity__c = smp.Moved_Quantity__c;
                    SLIdestination.Inventory_Location_Product_Line_Item__c = smp.ILPLI__c;
                    SLIdestination.SMP__c = smp.Id;
                    SLIdestination.Alternate_Unit_Price__c = 0;//to replace below line on Jan 30 2020; this field will contain the unit price of the source SL during stock movement
                    //SLIdestination.Alternate_Unit_Price__c = fromSLToUpdateMap.get( fromilpliIdSLMap.get( smp.From_ILPLI__c ) ).Net_Unit_Cost__c; //unit price should come from the source sl - changed to net unit cost on 14 Jan 2019
                    SLIList.add(SLIdestination);
                    
                    Sigma_Linkage__c slin = toSLToUpdateMap.get( toilpliIdSLMap.get( smp.ILPLI__c ) );
                    if(slin.Unit_Cost__c == 0)
                    {
                        slin.Unit_Cost__c = slout.Unit_Cost__c;
                        slin.Insurance__c = (slout.Insurance__c/slout.Received_Quantity__c) * slin.Received_Quantity__c ;
                        slin.Freight__c = (slout.Freight__c/slout.Received_Quantity__c) * slin.Received_Quantity__c;
                        slin.Duty__c = (slout.Duty__c/slout.Received_Quantity__c) * slin.Received_Quantity__c;
                        slin.Other__c = (slout.Other__c/slout.Received_Quantity__c) * slin.Received_Quantity__c;
                    }
                    toSLToUpdateMap.put(slin.Id,slin); 
                }
            }
            if(SLIList.size()>0)
            {
                insert SLIList;
                system.debug('LinkSADecrease SLIList after insert:::: '+SLIList);
                
                update fromSLToUpdateMap.values();
                system.debug('LinkSADecrease fromSLToUpdateMap after update:::: '+fromSLToUpdateMap);
                
                update toSLToUpdateMap.values();
                system.debug('LinkSADecrease toSLToUpdateMap after update:::: '+toSLToUpdateMap);
            }
            //create SLI for destination ILPLI
        }
    }
    
   //code added by rashmi for product transfer Sigma Finance on 22-12-2020
     public Static void LinkProductTransfer(List<Product_Transfer_Inventory_Tracking__c> prodInvTrkList, Set<Id> fromIlpliSet, Set<Id> toIlpliSet) 
    {
           system.debug('called by prodInv'+prodInvTrkList+'fromIlpliSet>>'+fromIlpliSet+'toIlpliSet>>'+toIlpliSet);
            List<Sigma_Linkage_Item__c> SLIList = new List<Sigma_Linkage_Item__c>();   //to insert SLLI
            //from location/ stock out
            Map<Id,Id> fromilpliIdSLMap = new Map<Id,Id>(); //key => ilpli id value=> sigma linkage record
			system.debug('returnSlForIlpli(fromIlpliSet)'+fromIlpliSet);
            fromilpliIdSLMap = returnSlForIlpli(fromIlpliSet);
            system.debug('fromilpliIdSLMap>>'+fromilpliIdSLMap);
            Map<Id,Sigma_Linkage__c> fromSLToUpdateMap = new Map<Id,Sigma_Linkage__c>();    //key => sl id value=> sigma linkage record
            fromSLToUpdateMap = toGetSigmaLinkage( fromilpliIdSLMap.values() );
            system.debug('fromSLToUpdateMap>>'+fromilpliIdSLMap);
            //to location/ stock in
            Map<Id,Id> toilpliIdSLMap = new Map<Id,Id>();   //key => ilpli id value=> sigma linkage Id
            
            createSLFromILPLI(toIlpliSet);
            toilpliIdSLMap = returnSlForIlpli(toIlpliSet);
            Map<Id,Sigma_Linkage__c> toSLToUpdateMap = new Map<Id,Sigma_Linkage__c>();  //key => sl id value=> sigma linkage record
            toSLToUpdateMap = toGetSigmaLinkage( toilpliIdSLMap.values() );
            
            //create SLI for source ILPLI
            for(Product_Transfer_Inventory_Tracking__c ptt:prodInvTrkList)
            {
            system.debug('smp>>'+ptt);
                system.debug('fromilpliIdSLMap'+fromilpliIdSLMap.get( ptt.Inventory_Location_Product_Line_Item__c ));
                system.debug('toilpliIdSLMap'+toilpliIdSLMap.get(ptt.To_ilpli__c));
                if( fromilpliIdSLMap.containskey( ptt.Inventory_Location_Product_Line_Item__c ) && toilpliIdSLMap.containskey(ptt.To_ilpli__c) )
                {
                	system.debug('SLIList'+prodInvTrkList);
                    Sigma_Linkage_Item__c SLIsource = new Sigma_Linkage_Item__c();
                    SLIsource.Activity_Date_Time__c = system.now();
                    SLIsource.Sigma_Linkage__c = fromilpliIdSLMap.get( ptt.Inventory_Location_Product_Line_Item__c );
                    SLIsource.Product__c = ptt.sigmaerpdev2__Product__c;
                    SLIsource.Type__c = 'Stock OUT';
                    SLIsource.Quantity__c = ptt.Transferred_Qty__c;
                    SLIsource.Inventory_Location_Product_Line_Item__c = ptt.Inventory_Location_Product_Line_Item__c;
                    //SLIsource.SMP__c = smp.Id;
                    SLIList.add(SLIsource);
                    
                    system.debug('fromSLToUpdateMap>>>>>'+fromilpliIdSLMap.get( ptt.Inventory_Location_Product_Line_Item__c ));
                    system.debug('fromSLToUpdateMap>>>>>'+fromSLToUpdateMap.get(fromilpliIdSLMap.get( ptt.Inventory_Location_Product_Line_Item__c )));
                    Sigma_Linkage__c slout = fromSLToUpdateMap.get( fromilpliIdSLMap.get( ptt.Inventory_Location_Product_Line_Item__c ) );
                    slout.Moved_OUT__c += ptt.Transferred_Qty__c;
                    system.debug('slout.Moved_OUT__c'+slout.Moved_OUT__c);
                    fromSLToUpdateMap.put(slout.Id,slout);
                    
                    Sigma_Linkage_Item__c SLIdestination = new Sigma_Linkage_Item__c();
                    SLIdestination.Activity_Date_Time__c = system.now();
                    SLIdestination.Sigma_Linkage__c = toilpliIdSLMap.get( ptt.To_ilpli__c );
                    SLIdestination.Product__c = ptt.sigmaerpdev2__Product__c;
                    SLIdestination.Type__c = 'Stock IN';
                    SLIdestination.Quantity__c = ptt.Transferred_Qty__c;
                    SLIdestination.Inventory_Location_Product_Line_Item__c = ptt.To_ilpli__c;
                    //SLIdestination.SMP__c = smp.Id;
                    SLIdestination.Alternate_Unit_Price__c = 0;//to replace below line on Jan 30 2020; this field will contain the unit price of the source SL during stock movement
                    //SLIdestination.Alternate_Unit_Price__c = fromSLToUpdateMap.get( fromilpliIdSLMap.get( smp.From_ILPLI__c ) ).Net_Unit_Cost__c; //unit price should come from the source sl - changed to net unit cost on 14 Jan 2019
                    SLIList.add(SLIdestination);
                    
                    Sigma_Linkage__c slin = toSLToUpdateMap.get( toilpliIdSLMap.get(ptt.To_ilpli__c ) );
                    if(slin.Unit_Cost__c == 0)
                    {
                        slin.Unit_Cost__c = slout.Unit_Cost__c;
                        slin.Insurance__c = (slout.Insurance__c/slout.Received_Quantity__c) * slin.Received_Quantity__c ;
                        slin.Freight__c = (slout.Freight__c/slout.Received_Quantity__c) * slin.Received_Quantity__c;
                        slin.Duty__c = (slout.Duty__c/slout.Received_Quantity__c) * slin.Received_Quantity__c;
                        slin.Other__c = (slout.Other__c/slout.Received_Quantity__c) * slin.Received_Quantity__c;
                    }
                    toSLToUpdateMap.put(slin.Id,slin); 
                }
            }
            if(SLIList.size()>0)
            {
                insert SLIList;
                system.debug('LinkSADecrease SLIList after insert:::: '+SLIList);
                
                update fromSLToUpdateMap.values();
                system.debug('LinkSADecrease fromSLToUpdateMap after update:::: '+fromSLToUpdateMap);
                
                update toSLToUpdateMap.values();
                system.debug('LinkSADecrease toSLToUpdateMap after update:::: '+toSLToUpdateMap);
            }
            //create SLI for destination ILPLI
        }
    //code ends for Product Transfer SF
	//code for work order complete////////
	 public Static void LinkWorkorderComp(list<sigmaerpdev2__Work_Order_Inventory_Track__c> workorderinv)
     {
         system.debug('workorderinv????'+workorderinv);
         set<Id> ilpliset = new set<Id>();
         Map<Id,Id> ilpliSourceFPMap = new Map<Id,Id>();
         Map<Id,Id> IaSlIdMap = new Map<Id,Id>();    //key => inventory allocation id, value => stock Linkage record id
         set<id> proidses=new set<id>();
         Map<Id,sigmaerpdev2__Work_Order_Inventory_Track__c> IlpliWOITMap = new Map<Id,sigmaerpdev2__Work_Order_Inventory_Track__c>();  
         map<id,Decimal> unitp=new map<id,Decimal>();
         Decimal unitprice=0;
         Decimal amt;
         for(sigmaerpdev2__Work_Order_Inventory_Track__c woILPLI: workorderinv)
         {
             ilpliset.add(woILPLI.sigmaerpdev2__Inventory_Location_Product_Line_Item__c);
             proidses.add(woILPLI.sigmaerpdev2__Product__c);
             IlpliWOITMap.put(woILPLI.id,woILPLI);
         }
         system.debug('ilpliset>>>'+ilpliset);
         List<PricebookEntry> prce =[Select Product2Id,UnitPrice,PriceBook2.Name From PricebookEntry WHERE PriceBook2.Name = 'Standard Price Book' and Product2.Id =:proidses];
         system.debug('pbe'+prce);
         for(PricebookEntry pbe:prce)
         {
             unitprice=pbe.UnitPrice;
             unitp.put(pbe.Product2Id,unitprice);  
         }
         ilpliSourceFPMap = returnSlForIlpli(ilpliset);
         system.debug('ilpliSourceFPMap'+ilpliSourceFPMap);
       
         //code added to reduce Inventory available quantity in Sigma Linkage on 31-12-2020 
        
         List<Sigma_Linkage_Item__c> sigmalinkage = new List<Sigma_Linkage_Item__c>();
         Map<Id,Id> IlpliSlIdMap = new Map<Id,Id>();    //key => Ilpli id, value => sigma Linkage record id
         sigmalinkage=[select Id, Sigma_Linkage__c, Inventory_Location_Product_Line_Item__c from Sigma_Linkage_Item__c where Inventory_Location_Product_Line_Item__c IN: IlpliSet];
         system.debug('sigmalinkage????'+sigmalinkage);
         for(Sigma_Linkage_Item__c slli:sigmalinkage)
         {
             IlpliSlIdMap.put(slli.Inventory_Location_Product_Line_Item__c, slli.Sigma_Linkage__c);
         }
          system.debug('IlpliSlIdMap????'+IlpliSlIdMap);
         List<Sigma_Linkage__c> slListToUpdate=new List<Sigma_Linkage__c>();
         slListToUpdate=[select Id, name, SRP__c, ILP__c, sigmaerpdev2__Work_Order__c,Packaged_Quantity__c,Delivered_Quantity__c, Stock_Origin__c from Sigma_Linkage__c where Id IN: IlpliSlIdMap.values()];
         system.debug('slListToUpdate???'+slListToUpdate);
         for(Id woit:IlpliWOITMap.keySet())
         {
             if(slListToUpdate.size() > 0)
             {
                 for(Sigma_Linkage__c sl:slListToUpdate)
                 {	 
                     system.debug('slid->'+sl.Id);
                     system.debug('qty used???1583'+IlpliWOITMap.get(woit).sigmaerpdev2__Quantity_Used__c);
                     system.debug('IlpliSlIdMap'+IlpliSlIdMap.get(IlpliWOITMap.get(woit).sigmaerpdev2__Inventory_Location_Product_Line_Item__c));
                     if(sl.Id == IlpliSlIdMap.get( IlpliWOITMap.get(woit).sigmaerpdev2__Inventory_Location_Product_Line_Item__c ))
                     {
                         if(sl.Work_Order__c!=null)
                             sl.Work_Order__c = sl.Work_Order__c + IlpliWOITMap.get(woit).sigmaerpdev2__Quantity_Used__c;
                         system.debug('workorder??'+sl.Work_Order__c ); 
                         IaSlIdMap.put(woit,sl.id);
                     }
                 }
             }
         }
         // for(sigmaerpdev2__Work_Order_Inventory_Track__c worinvtrack: workorderinv)
        // {
           //  system.debug('worinvtrack'+worinvtrack);
             
            // if(ilpliSourceFPMap.containskey(worinvtrack.sigmaerpdev2__Inventory_Location_Product_Line_Item__c))
         if(IaSlIdMap.size() > 0)
         {
             List<Sigma_Linkage_Item__c> SLLIList = new List<Sigma_Linkage_Item__c>();   //to insert SLLI
             for(Id woit:IlpliWOITMap.keySet())
             {
                 for(Sigma_Linkage__c sl:slListToUpdate)
                 {
                     system.debug('innnn'+IaSlIdMap.containskey(woit));
                     
                     Sigma_Linkage_Item__c SLI = new Sigma_Linkage_Item__c();
                     SLI.Sigma_Linkage__c =IaSlIdMap.get(woit);
                     SLI.Quantity__c = IlpliWOITMap.get(woit).sigmaerpdev2__Quantity_Used__c;
                     SLI.Product__c=IlpliWOITMap.get(woit).sigmaerpdev2__Product__c;
                     SLI.Inventory_Location_Product_Line_Item__c = IlpliWOITMap.get(woit).sigmaerpdev2__Inventory_Location_Product_Line_Item__c;
                     SLI.Type__c = 'Work Order Completed';
                     amt=unitp.get(SLI.Product__c)*IlpliWOITMap.get(woit).sigmaerpdev2__Quantity_Used__c;
                     SLI.sigmaerpdev2__Total_Sales_Value__c=amt;
                     system.debug('innnn'+amt);
                     system.debug('inn'+SLI.sigmaerpdev2__Total_Sales_Value__c);
                     SLLIList.add(SLI);
                 }
             }
          try
          {
              if(SLLIList.size() > 0)
              {
                  insert SLLIList;
                  system.debug('SLLIList>>>'+SLLIList);
              }
              if(slListToUpdate.size() > 0)
              {
                  update slListToUpdate;
                  system.debug('slListToUpdate>>>'+slListToUpdate);
              }
          }
             catch(Exception e)
             {
                 System.debug('Exception createSLFromILP LinkPPLI:'+e.getMessage());
             }
         
         }
     }
    //code ends here for finance on 30-12-2020
    
	
	
    //code started for MR Sigma Finance on 22-02-2020
    //Invoked from StockReceivingCtrl and ManufacturingRun class
    public static void slInbound(sigmafinanceInboundwrap inboundItems)
    {
        if(inboundItems.source == 'StockManufacting')
        {
            system.debug('StockManufacting-->>'+inboundItems.source);
            inManufacturing(inboundItems.MnufcturingDetails,inboundItems.ilpliList);
        }
    }
    //code to handle manufacturing run Sigma finance starts here on 01-02-2020
    //Invoked from sigmafinanceInbound method
    public static void inManufacturing(sigmafinanceInboundMRunwrap mftringRun,List<Inventory_Location_Product_Line_Item__c> createdILPLIs)
    {
        system.debug('called by slInbound');
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage__c') &&
           CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c') &&
           CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage_Item__c') &&
           CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c') &&
           CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run__c') &&
           CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'sigmaerpdev2__Manufacturing__c','sigmaerpdev2__Product__c','sigmaerpdev2__ILP__c','sigmaerpdev2__Stock_Origin__c','sigmaerpdev2__Unit_Cost__c'}) &&
           CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Sigma_Linkage_Item__c',new Set<String>{'sigmaerpdev2__Sigma_Linkage__c'}) &&
           CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Type__c'}))
        {
            
            System.debug('mftringRun:::' +mftringRun);
            System.debug('mftringRun ILPs:::' +mftringRun.ILPs);
            System.debug('mftringRun moved qty :::'+mftringRun.movedQty);
            System.debug('createdILPLIs:::' +createdILPLIs);
            System.debug('MAnufacturing run name:::' +mftringRun.MfRun.Manufacturing_Name__c);
            System.debug('MAnufacturing :::' +mftringRun.MfRun);
            
            //  ref = mftringRun.MfRun.Manufacturing_Name__c;
            //#ToBeCommented
            //  createErrorLog.insertError('LinkageServiceClass','details of manufacturing data in finance','inManufacturing method',mftringRun.MfRun.Id,JSON.serialize(mftringRun),null,UserInfo.getUserId());
            
            List<Sigma_Linkage__c> newSLList = new List<Sigma_Linkage__c>();
            Map<Id,Inventory_Location_Product__c> ILPsMap=new Map<Id,Inventory_Location_Product__c>();  //Key=>Ilp id, value=> ilp record
            Map<Id,Id> IlpSLMap=new Map<Id,Id>();   //Key=>Ilp id, value=>FP id
            List<Sigma_Linkage_Item__c> toInsertSLI = new List<Sigma_Linkage_Item__c>();
            set<id> ProdTypeid=new set<id>();//created by rashmi to restrict Attribute type changing after updating inventories on 04-04-2020
            try
            {
                system.debug('mftringRun-->>>'+mftringRun.ILPs.keyset());
                system.debug('mftringRun-->>>'+mftringRun.movedQty.keyset());
                for(Id locId:mftringRun.ILPs.keyset() )
                {
                    Sigma_Linkage__c SL = new Sigma_Linkage__c();
                    SL.Manufacturing__c = mftringRun.MfRun.Id;
                    SL.Product__c = mftringRun.mfRun.Product__c;
                    SL.ILP__c = mftringRun.ILPs.get(locId).Id;
                    SL.Stock_Origin__c = 'Manufacturing Run';
                    SL.Received_Quantity__c = mftringRun.movedQty.get(SL.ILP__c);
                    SL.Unit_Cost__c = mftringRun.TotalCost/mftringRun.producedQty;
                    newSLList.add(SL);
                    system.debug('newSLList-->>'+newSLList);
                    ILPsMap.put( mftringRun.ILPs.get(locId).Id,mftringRun.ILPs.get(locId) );
                    system.debug('ILPsMap-->>'+ILPsMap);
                }
               
                insert newSLList;
                System.debug('newSLList after insert:::'+newSLList);
                
                for(Sigma_Linkage__c sl:newSLList)
                {
                    IlpSLMap.put(sl.ILP__c,sl.Id);
                }
                System.debug('IlpSLMap:::'+IlpSLMap);
                
                for(Inventory_Location_Product_Line_Item__c ilpli:createdILPLIs)
                {
                    Sigma_Linkage_Item__c SLI = new Sigma_Linkage_Item__c();
                    SLI.Sigma_Linkage__c = IlpSLMap.get(ilpli.Inventory_Location_Product__c);
                    SLI.Inventory_Location_Product_Line_Item__c = ilpli.Id;
                    SLI.Product__c = ilpli.Product__c;
                    SLI.Quantity__c = ilpli.Received_Quantity__c;
                    SLI.Type__c = 'Stock Produced';
                    toInsertSLI.add(SLI);
                    system.debug('toInsertSLI-->>'+toInsertSLI);
                    ProdTypeid.add(ilpli.Product__c);
                    system.debug('ProdTypeid-->>'+ProdTypeid);
                }
                
                insert toInsertSLI;
                System.debug('toInsertSLI after insert:::'+toInsertSLI);
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
                
                //calling outbound methods to record consumption of goods
                sigmafinanceOutboundwrap sfout = new sigmafinanceOutboundwrap();
                sfout.source = 'ManufacturingRun';
                sfout.MnufcturingDetails = mftringRun;
                sigmafinanceOutbound(sfout);
                
            }
            catch(exception ex)
            {
                createErrorLog.insertError('LinkageServiceClass',ex.getMessage(),'ManufacturingRun',null,'',ex.getStackTraceString(),UserInfo.getUserId());
                System.debug('Q Exception ::'+ex+' @ line '+ex.getLineNumber());
            }
        }
    }
    
    //Consumption starts //Invoked from financeOutbound method
    public static void stockOutByMRun(sigmafinanceInboundMRunwrap mftringRun)
    {   
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage_Item__c') &&
           CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run_Allocation_Line_Items__c') &&
           CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Products__c') &&
           CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run__c') &&
           CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c') &&
           CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Products__c',new set<String>{'Id', 'name','sigmaerpdev2__Product__c','sigmaerpdev2__Cost__c','RecordTypeId.name','sigmaerpdev2__Modified_Quantity__c','sigmaerpdev2__Manufacturing_Run__c'}) &&
           CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Manufacturing_Run_Allocation_Line_Items__c',new Set<String>{'sigmaerpdev2__Manufacturing_Run_Allocation__c'}) &&
           CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run_Allocation_Line_Items__c',new set<String>{'Id', 'name','sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Manufacturing_Run_Allocation__r.sigmaerpdev2__Product__c'}) &&
           CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Sigma_Linkage_Item__c',new Set<String>{'sigmaerpdev2__Sigma_Linkage__c'}) &&
           CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Quantity__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Type__c','sigmaerpdev2__Sales_Unit_Price__c'}) &&
           CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'Id','sigmaerpdev2__Product__c','sigmaerpdev2__Stock_Origin__c'}) &&
           CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Stock_Origin__c','sigmaerpdev2__Unit_Cost__c'}))
        {
            try
            {
                Map<Id,String> proCompTypeMap= new Map<Id,String>();    //key=>product Id, value=>component type
                Map<Id,Id> ilpliSourceSFMap = new Map<Id,Id>(); //key=>ilpli id, value=>finance product id
                Map<Id,Manufacturing_Products__c> addProQtyMap = new Map<Id,Manufacturing_Products__c>(); //key=>product id, value=>manufacturing product
                Map<Id,Manufacturing_Run_Allocation_Line_Items__c> ilpliMRAllMap= new Map<Id,Manufacturing_Run_Allocation_Line_Items__c>(); //key=>ilpli Id, value=>manufacturing run allocation line items records
                List<Sigma_Linkage_Item__c> toInsertSLI = new List<Sigma_Linkage_Item__c>();
                
                for(Manufacturing_Products__c mPro:[select id,name,Product__c,Cost__c,RecordType.name,Modified_Quantity__c,Manufacturing_Run__c from Manufacturing_Products__c where Manufacturing_Run__c =:mftringRun.MfRun.Id])
                {
                    //Product Components, //Additional Products, //Packaging Materials//Non stock Product
                    if(mPro.RecordType.name=='Additional Products')
                    {
                        addProQtyMap.put(mPro.Product__c,mPro);
                    }
                    else   
                    {
                        proCompTypeMap.put(mPro.Product__c,mPro.RecordType.name);
                    }
                }
                System.debug('proCompTypeMap:::'+proCompTypeMap);
                System.debug('addProQtyMap:::'+addProQtyMap);
                
                for(Manufacturing_Run_Allocation_Line_Items__c milpli:[Select id,name,Manufacturing_Run_Allocation__c,Inventory_Location_Product_Line_Item__c,Quantity__c,Unit_Price__c,Manufacturing_Run_Allocation__r.Product__c from Manufacturing_Run_Allocation_Line_Items__c where Manufacturing_Run_Allocation__r.Manufacturing_Run__c =:mftringRun.MfRun.Id ])
                {
                    if(ilpliMRAllMap.containsKey(milpli.Inventory_Location_Product_Line_Item__c))
                    {
                        milpli.Quantity__c += ilpliMRAllMap.get(milpli.Inventory_Location_Product_Line_Item__c).Quantity__c;
                        ilpliMRAllMap.put(milpli.Inventory_Location_Product_Line_Item__c,milpli);
                    }
                    else
                    {
                        ilpliMRAllMap.put(milpli.Inventory_Location_Product_Line_Item__c,milpli);
                    }
                    
                }
                System.debug('ilpliMRAllMap:::'+ilpliMRAllMap);
                
                //fetching Sigma_Linkage_Item__c  lookup for ilpli
                ilpliSourceSFMap = returnSlForIlpli(ilpliMRAllMap.keyset());
                System.debug('ilpliSourceSFMap::'+ilpliSourceSFMap);
                Map<Id,Sigma_Linkage__c> fromSLToUpdateMap = new Map<Id,Sigma_Linkage__c>();    //key => sl id value=> sigma linkage record
                fromSLToUpdateMap = toGetSigmaLinkage( ilpliSourceSFMap.values() );
                for(Id mIlpli:ilpliMRAllMap.keyset())
                {
                    if(ilpliSourceSFMap.containskey(mIlpli))
                    {
                        System.debug('mIlpli::'+mIlpli+' M.R.A.L.:'+ilpliMRAllMap.get( mIlpli ));
                        
                        Sigma_Linkage_Item__c SLI = new Sigma_Linkage_Item__c();
                        SLI.Sigma_Linkage__c = ilpliSourceSFMap.get( mIlpli);
                        SLI.Quantity__c = ilpliMRAllMap.get(mIlpli).Quantity__c;
                        SLI.Product__c = ilpliMRAllMap.get(mIlpli).Manufacturing_Run_Allocation__r.Product__c;
                        SLI.Inventory_Location_Product_Line_Item__c = mIlpli;
                        SLI.Type__c = proCompTypeMap.get( ilpliMRAllMap.get(mIlpli).Manufacturing_Run_Allocation__r.Product__c );
                        SLI.Sales_Unit_Price__c = ilpliMRAllMap.get(mIlpli).Unit_Price__c;
                        toInsertSLI.add(SLI);
                        system.debug('toInsertSLI-->'+toInsertSLI);
                        
                        //updating Adjusted_Quantity__c in product components and Packaging Products Sigma Finance
                        system.debug('SL id from fromSLToUpdateMap'+fromSLToUpdateMap.get(ilpliSourceSFMap.get( mIlpli)));
                        Sigma_Linkage__c SLind = fromSLToUpdateMap.get(ilpliSourceSFMap.get( mIlpli));
                        system.debug('SLind--->'+SLind);
                        system.debug('Adjusted_Quantity__c--->'+ilpliMRAllMap.get(mIlpli).Quantity__c);
                        SLind.Adjusted_Quantity__c += ilpliMRAllMap.get(mIlpli).Quantity__c;
                        fromSLToUpdateMap.put(SLind.Id,SLind);
                        system.debug('after SLind in fromSLToUpdateMap'+fromSLToUpdateMap);
                        System.debug('before adding increase::'+toInsertSLI);
                    }
                }
                
                //added on Jan 28 2018 to create journals for Non stock Products (additional products )
                if(addProQtyMap.size()>0)   //to check if additional product are there
                {
                    Map<Id,Id> proSLMap = new Map<Id,Id>();   //key=>non stock pro id, value=>finance product id
                    List<Sigma_Linkage__c> SLListToInsert = new List<Sigma_Linkage__c>();
                    for(Sigma_Linkage__c sl:[Select id,Product__c,Stock_Origin__c from Sigma_Linkage__c where ILP__c IN:addProQtyMap.keyset() AND Stock_Origin__c=:'Non stock Product' ])
                    {
                        proSLMap.put(sl.Product__c,sl.Id);
                    }
                    
                    for(Id pro:addProQtyMap.keyset())
                    {
                        if(!proSLMap.containskey(pro))
                        {
                            System.debug('creating nonstaockFp for:::'+pro);
                            Sigma_Linkage__c SL = new Sigma_Linkage__c();
                            SL.Product__c = pro;
                            SL.Stock_Origin__c = 'Non stock Product';
                            //SL.Received_Quantity__c =addProQtyMap.get(pro).Modified_Quantity__c; 
                            SL.Unit_Cost__c = addProQtyMap.get(pro).Cost__c/addProQtyMap.get(pro).Modified_Quantity__c;
                            SLListToInsert.add(SL);
                            system.debug('SLListToInsert-->>>'+SLListToInsert);
                        }
                    }
                    
                    if(SLListToInsert.size()>0) //to check if additional product are there
                    {
                        insert SLListToInsert;
                        system.debug('after insert SLListToInsert-->>>'+SLListToInsert);
                        for(Sigma_Linkage__c sf:SLListToInsert)
                        {
                            proSLMap.put(sf.Product__c,sf.Id);
                        }
                    }
                    
                    for(Id pro:addProQtyMap.keyset())
                    {               
                        Sigma_Linkage_Item__c SLI = new Sigma_Linkage_Item__c();
                        SLI.Sigma_Linkage__c = proSLMap.get( pro);
                        SLI.Quantity__c = addProQtyMap.get(pro).Modified_Quantity__c;
                        SLI.Product__c = addProQtyMap.get(pro).Product__c;
                        SLI.Type__c = 'Additional Products';
                        SLI.Sales_Unit_Price__c = addProQtyMap.get(pro).Cost__c/addProQtyMap.get(pro).Modified_Quantity__c;
                        toInsertSLI.add(SLI);
                    }
                }
                
                // transDate = mftringRun.MfRun.Run_Date__c;   //to pass transaction data to journal
                System.debug('consumed SLI before insert:::'+toInsertSLI);
                
                if(toInsertSLI.size()>0)
                {
                    insert toInsertSLI;
                    System.debug('consumed SLI after insert:::'+toInsertSLI);
                    update fromSLToUpdateMap.values();
                    system.debug('fromSLToUpdateMap after update:::: '+fromSLToUpdateMap);
                }
                
                //To create journals
                //  relayToJournal(toInsertFPT,'stockOutByMRun');
            }
            catch(exception ex)
            {
                createErrorLog.insertError('LinkageServiceClass',ex.getMessage(),'ManufacturingRun',null,'',ex.getStackTraceString(),UserInfo.getUserId());
                System.debug('Q Exception ::'+ex+' @ line '+ex.getLineNumber());
            }
        }
    }
    
    //Invoked from ShipmentCtrl class and inManufacturing method
    public static void sigmafinanceOutbound(sigmafinanceOutboundwrap outboundItems)
    {
        System.debug('<<inside financeOutbound>>');
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Shipment__c') &&
           CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage_Item__c') &&
           CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c') &&
           CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__PackagedProducts__c') &&
           CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Allocation__c') &&
           CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Shipment__c',new set<String>{'Id', 'name','sigmaerpdev2__Shipment_Date__c'}) && 
           CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'Id','sigmaerpdev2__Shipment_Product__c'}) &&
           CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Sigma_Linkage_Item__c',new Set<String>{'sigmaerpdev2__Sigma_Linkage__c'}) &&
           CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev2__Sigma_Order__c'}) &&
           CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__PackagedProducts__c',new set<String>{'Id','name','sigmaerpdev2__Product_Order__c','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__Package__c','sigmaerpdev2__Product_Order__r.sigmaerpdev2__Back_Order__c'}) &&
           CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Allocation__c',new set<String>{'Id','sigmaerpdev2__ILPLI__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Packaged_Product__c'}) &&
           CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'id','sigmaerpdev2__TotalProductPrice__c','sigmaerpdev2__Product__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Total_Amount__c','sigmaerpdev2__TotalPrice__c','sigmaerpdev2__Ordered_Quantity__c','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__Sigma_Order__r.sigmaerpdev2__Discount__c','sigmaerpdev2__Sigma_Order__r.sigmaerpdev2__Customer__c','sigmaerpdev2__Back_Order__c'}))
        {
            
            try
            {
                System.debug('outboundItems::'+outboundItems);
                List<Inventory_Allocation__c> inventAllocat = new List<Inventory_Allocation__c>();
                Map<Id,Product_Order_Price_Book__c> ordrLineMap = new Map<Id,Product_Order_Price_Book__c>();
                Map<Id,Id> ppShipRefMap = new Map<Id,Id>(); //key => package product Id, value => ship line item id
                
                if(outboundItems.source == 'shipment')
                {
                    Map<Id,Id> ppOrderLinesMap = new Map<Id,Id>();
                    Set<Id> shipItemSet = new Set<Id>();
                    Set<Id> shipSet = new Set<Id>();
                    for(Shipment_Products__c shli:outboundItems.shipPackMap.keyset())
                    {
                        shipItemSet.add(shli.Id);
                        shipSet.add(shli.Shipment__c);
                    }
                    System.debug('shipItemSet::'+shipItemSet);
                    System.debug('shipSet::'+shipSet);
                    
                    List<Shipment__c> ship= [select id,name,Shipment_Date__c from Shipment__c where ID IN:shipSet ];
                    /* if(ship.size()>0)
{
//to take shipment date from shipment header
transDate = ship[0].Shipment_Date__c;  //to pass transaction data to journal
System.debug('transDate in financeOutbound for shipment:::'+transDate);
}
else
{
System.debug('no shipment');
}*/
                    
                    Map<Id,Sigma_Linkage_Item__c> shipIdSLI = new Map<Id,Sigma_Linkage_Item__c>();   //key=>ship id, value=>finance product Transaction id
                    for(Sigma_Linkage_Item__c sli:[Select id,Sigma_Linkage__c,Shipment_Product__c from Sigma_Linkage_Item__c where Shipment_Product__c IN:shipItemSet])
                    {
                        shipIdSLI.put(sli.Shipment_Product__c,sli);
                    }
                    System.debug('shipIdSLI::'+shipIdSLI);
                    
                    Set<Id> packageIds = new Set<Id>();
                    Map<Id,Id> shipIdPackIdSLI = new Map<Id,Id>();   //key=>ship id, value=>package id
                    System.debug('shipPackMap::'+outboundItems.shipPackMap.keyset());
                    for(Shipment_Products__c shli:outboundItems.shipPackMap.keyset())
                    {
                        
                        System.debug('shli::'+shli);
                        System.debug('shli.Package_ID__c::'+shli.Package_ID__c+':: shli.Id ::'+shli.Id);
                        if(!shipIdSLI.containskey(shli.Id))
                        {
                            packageIds.add(shli.Package_ID__c);
                            shipIdPackIdSLI.put(shli.Package_ID__c,shli.Id);
                        }
                        else
                        {
                            System.debug('::repeated::');
                        }
                    }
                    System.debug('packageIds::'+packageIds);
                    
                    Set<Id> stoOrderIds = new Set<Id>();
                    //Map<Id,Decimal> productPriceMap = new Map<Id,Decimal>();
                    for(PackagedProducts__c pp:[Select id,name,Product_Order__c,Sigma_Order__c,Package__c,Product_Order__r.Back_Order__c from PackagedProducts__c where Package__c IN:packageIds])
                    {
                        ppOrderLinesMap.put(pp.Product_Order__c,pp.Id);
                        ppShipRefMap.put(pp.Id, shipIdPackIdSLI.get(pp.Package__c) );
                        if(pp.Product_Order__r.Back_Order__c)
                        {
                            stoOrderIds.add(pp.Sigma_Order__c);
                        }
                    }
                    System.debug('ppOrderLinesMap::'+ppOrderLinesMap);
                    System.debug('ppShipRefMap::'+ppShipRefMap);
                    
                    inventAllocat = [select id,ILPLI__c,Quantity__c,Packaged_Product__c from Inventory_Allocation__c where Packaged_Product__c IN:ppOrderLinesMap.values()];
                    System.debug('inventAllocat::'+inventAllocat);
                    
                    for(Product_Order_Price_Book__c ol:[select id,TotalProductPrice__c,Product__c,Net_Quantity__c,Quantity__c,Total_Amount__c,TotalPrice__c,Ordered_Quantity__c,Sigma_Order__c,Sigma_Order__r.Discount__c,Sigma_Order__r.Customer__c,Back_Order__c from Product_Order_Price_Book__c where Id IN:ppOrderLinesMap.keySet() ])
                    {
                        ordrLineMap.put( ppOrderLinesMap.get(ol.Id),ol );
                        //customerId = ol.Sigma_Order__r.Customer__c;
                    }
                    System.debug('ordrLineMap key=>pp id, value=>orderline::'+ordrLineMap);
                    
                    /*  for( Product_Order_Price_Book__c sol:[select id,TotalProductPrice__c,Product__c,Product__r.name,Net_Quantity__c,Quantity__c,Total_Amount__c,TotalPrice__c,Ordered_Quantity__c,Sigma_Order__c,Sigma_Order__r.Discount__c,Sigma_Order__r.Customer__c,Back_Order__c from Product_Order_Price_Book__c where Sigma_Order__c IN:stoOrderIds ])
{
if(sol.IsSplitParent__c||sol.IsBackOrderParent__c)
{
productPriceMap.put(sol.Product__c,sol.Total_Product_Price__c/sol.Original_Ordered_Quantity__c);
System.debug('product name '+sol.Product__r.name + 'unit price '+sol.Total_Product_Price__c/sol.Original_Ordered_Quantity__c);
}
}*/
                    //System.debug('ordrLineMap key=>pro id, value=>pro pice::'+productPriceMap);
                    //stockOutbySO(ordrLineMap,inventAllocat,ppShipRefMap,productPriceMap,outboundItems.source);
                    stockOutbySO(ordrLineMap,inventAllocat,ppShipRefMap,outboundItems.source);
                }
                if(outboundItems.source == 'ManufacturingRun')
                {
                    stockOutByMRun(outboundItems.MnufcturingDetails);
                }
                
            }
            catch(exception ex)
            {
                createErrorLog.insertError('LinkageServiceClass',ex.getMessage(),'shipment-financeOutbound',null,'',ex.getStackTraceString(),UserInfo.getUserId());
                System.debug('Q Exception ::'+ex+' @ line '+ex.getLineNumber());
            }
        }
        
    }
    //Invoked from financeOutbound method
    public static void stockOutbySO(Map<Id,Product_Order_Price_Book__c> ordrLineMap,List<Inventory_Allocation__c> inventAllocat,Map<Id,Id> RefMap,String source) //Map<Id,Decimal> productPriceMap,
    {
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage_Item__c') &&
           CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'sigmaerpdev2__Quantity__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Shipment_Product__c','sigmaerpdev2__Type__c', 'sigmaerpdev2__Order_Line__c','sigmaerpdev2__Sales_Unit_Price__c'}) && 
           CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Sigma_Linkage_Item__c',new Set<String>{'sigmaerpdev2__Sigma_Linkage__c'}))
        {  
            
            try
            {
                
                system.debug('ordrLineMap>>>'+ordrLineMap);
                system.debug('inventAllocat>>>'+inventAllocat);
                system.debug('RefMap>>>'+RefMap);
                //  system.debug('productPriceMap>>>'+productPriceMap);
                system.debug('source>>>'+source);
                
                Map<Id,Id> ilpliSourceFPMap = new Map<Id,Id>(); //key=>ilpli id, value=>finance product id
                set<Id> ilpli = new set<Id>();
                for(Inventory_Allocation__c ia:inventAllocat)
                {
                    ilpli.add(ia.ILPLI__c);
                }
                
                system.debug('ilpli>>>'+ilpli);
                ilpliSourceFPMap = returnSlForIlpli(ilpli);
                System.debug('ilpliSourceFPMap::'+ilpliSourceFPMap);
                List<Sigma_Linkage_Item__c> toInsertSLI = new List<Sigma_Linkage_Item__c>();
                //Map<Id,Decimal> productPriceMap = new Map<Id,Decimal>(); //key=>Product id, value=>Price 
                for(Inventory_Allocation__c alloc:inventAllocat)
                {
                    if(ilpliSourceFPMap.containskey(alloc.ILPLI__c))
                    {
                        System.debug('ppid::'+alloc.Packaged_Product__c+' ordrLineMap::'+ordrLineMap.get( alloc.Packaged_Product__c ));
                        
                        //if( ordrLineMap.get( alloc.PP__c ).IsBackOrderParent__c || ordrLineMap.get( alloc.PP__c ).IsSplitParent__c )
                        //    productPriceMap.put( ordrLineMap.get( alloc.PP__c ).Product__c, ordrLineMap.get( alloc.PP__c ).Parent_Order_Line__r.Total_Product_Price__c );
                        
                        Sigma_Linkage_Item__c SLI = new Sigma_Linkage_Item__c();
                        SLI.Sigma_Linkage__c = ilpliSourceFPMap.get( alloc.ILPLI__c );
                        SLI.Quantity__c = alloc.Quantity__c;
                        SLI.Inventory_Location_Product_Line_Item__c = alloc.ILPLI__c;
                        SLI.Shipment_Product__c = RefMap.get( alloc.Packaged_Product__c );
                        SLI.Type__c     = 'Delivered';
                        SLI.Order_Line__c = ordrLineMap.get( alloc.Packaged_Product__c ).Id;
                        Decimal totalPrice = 0;
                        if( ordrLineMap.get( alloc.Packaged_Product__c ).Back_Order__c )
                        {
                            System.debug('parent sol totel product price::'+ordrLineMap.get( alloc.Packaged_Product__c ).TotalProductPrice__c+' parent sol original ordered qty::'+ordrLineMap.get( alloc.Packaged_Product__c ).Quantity__c);
                            totalPrice = ordrLineMap.get( alloc.Packaged_Product__c ).TotalProductPrice__c;
                        }
                        else
                            totalPrice = ordrLineMap.get( alloc.Packaged_Product__c ).TotalProductPrice__c;
                        
                        Decimal unitPrice = 0;
                        //if(ordrLineMap.get( alloc.PP__c ).Original_Ordered_Quantity__c != null),
                        if( !(ordrLineMap.get( alloc.Packaged_Product__c ).Back_Order__c ))
                            unitPrice = totalPrice/ordrLineMap.get( alloc.Packaged_Product__c ).Quantity__c;
                        else if(ordrLineMap.get( alloc.Packaged_Product__c ).Back_Order__c )
                            unitPrice = totalPrice/ordrLineMap.get( alloc.Packaged_Product__c ).Quantity__c;
                        else
                            unitPrice = totalPrice/ordrLineMap.get( alloc.Packaged_Product__c ).Net_Quantity__c;
                        
                        SLI.Sales_Unit_Price__c = unitPrice;
                        toInsertSLI.add(SLI);
                    }
                }
                system.debug('toInsertSLI before>>>'+toInsertSLI);
                insert toInsertSLI;
                system.debug('toInsertSLI>>>'+toInsertSLI);
                //To create journals
                //relayToJournal(toInsertFPT,'stockOutbySO');
            }
            catch(exception ex)
            {
                createErrorLog.insertError('LinkageServiceClass',ex.getMessage(),'SO and Inventpry allocation',null,'',ex.getStackTraceString(),UserInfo.getUserId());
                System.debug('Q Exception ::'+ex+' @ line '+ex.getLineNumber());
            }
        }
    }
    //code ends for MR Sigma Finance////////////////////////////////////////Utility Methods////////////////////////////////////////
    
    //method to get sl ids from ilpli by quering on slli
    public Static Map<Id,Id> returnSlForIlpli(Set<Id> ILPLISet) 
    {
        system.debug('ILPLISet  '+ILPLISet);
        Map<Id,Id> IlpliSlIdMap = new Map<Id,Id>();    //key => Ilpli id, value => stock Linkage record id
        
      /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage_Item__c')
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Linkage_Item__c',new set<String>{'Id','name', 'sigmaerpdev2__Sigma_Linkage__c', 'sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Type__c'})
           &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Sigma_Linkage_Item__c',new Set<String>{'sigmaerpdev2__Sigma_Linkage__c'}))
            
        {*/
        List<Sigma_Linkage_Item__c> SLIList=[select Id, sigmaerpdev2__Sigma_Linkage__c, sigmaerpdev2__Inventory_Location_Product_Line_Item__c from sigmaerpdev2__Sigma_Linkage_Item__c where sigmaerpdev2__Inventory_Location_Product_Line_Item__c =: ILPLISet and sigmaerpdev2__Type__c  =:'Inventory' ];
           system.debug('SLIList  '+SLIList);
        for(Sigma_Linkage_Item__c slli:SLIList)
            {
                system.debug('slli-->>>'+slli);
                IlpliSlIdMap.put(slli.Inventory_Location_Product_Line_Item__c, slli.Sigma_Linkage__c);
                system.debug('IlpliSlIdMap-->>>'+IlpliSlIdMap);
            }
            
        //}
        return IlpliSlIdMap;
    }
    //method o get sigma linkage records by Id
    public Static Map<Id,Sigma_Linkage__c> toGetSigmaLinkage(List<Id> SLIdList) 
    {
        system.debug('SLIdList-->>>'+SLIdList);
        Map<Id,Sigma_Linkage__c> SlMap = new Map<Id,Sigma_Linkage__c>();    //key => Ilpli id, value => stock Linkage record id
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Linkage__c')
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Linkage__c',new set<String>{'Id', 'name', 'sigmaerpdev2__Adjusted_Quantity__c', 'sigmaerpdev2__Allocated_Quantity__c','sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__Moved_OUT__c','sigmaerpdev2__Delivered_Quantity__c','sigmaerpdev2__Packaged_Quantity__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Moved_OUT__c','sigmaerpdev2__Unit_Cost__c','sigmaerpdev2__Net_Unit_Cost__c','sigmaerpdev2__Duty__c','sigmaerpdev2__Freight__c','sigmaerpdev2__Insurance__c','sigmaerpdev2__Other__c'})    
          )
        {*/
            List<Sigma_Linkage__c> slList = [Select id,name,Adjusted_Quantity__c,Allocated_Quantity__c,Available_Quantity__c,Delivered_Quantity__c,Packaged_Quantity__c,Received_Quantity__c,Moved_OUT__c,Unit_Cost__c,Net_Unit_Cost__c,Insurance__c,Freight__c,Duty__c,Other__c from Sigma_Linkage__c where Id IN:SLIdList ];
            system.debug('slList-->>>'+slList);
            for(Sigma_Linkage__c sl: slList)
            {
                system.debug('sl-->>>'+sl);
                SlMap.put(sl.Id,sl);
                system.debug('SlMap-->>>'+SlMap);
            }
    //   }
        return SlMap;
    }
    
    public class dataWrap
    {
        public Id ilpid;
        public Id proid;
        public Id refid;
        public decimal qty = 0;
        public String type;
        public decimal price = 0;
        
    }
    //code added to handle Manufacturing Run Finance starts here on 03-01-2020
    public class sigmafinanceInboundwrap
    {
        public String source;
        public List<Inventory_Location_Product_Line_Item__c> ilpliList;
        public sigmafinanceInboundMRunwrap MnufcturingDetails;
        
    }
    
    public class sigmafinanceInboundMRunwrap
    {
        public Decimal UnitPrice;
        public Decimal TotalCost;
        public Decimal producedQty;
        public Manufacturing_Run__c MfRun;
        public Map<ID,Inventory_Location_Product__c> ILPs;
        public Map<ID,Decimal> movedQty;
    }
    
    public class sigmafinanceOutboundwrap
    {
        public String source;
        public Map<Shipment_Products__c,Package__c> shipPackMap;
        public sigmafinanceInboundMRunwrap MnufcturingDetails;
    }
}