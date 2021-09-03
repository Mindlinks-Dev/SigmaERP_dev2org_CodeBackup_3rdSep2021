public with sharing class NewStockreceiving
{

    public class VendorDetailsWrap
    {
       @AuraEnabled
       public Account vendcontact;
       @AuraEnabled 
       public Contact acccon;
    }
    public class StockReceivingWrap
    {
        public string Id;
        public string Vendor;
        public string Contact;
        public string Receiving_Sites;
        public DateTime Received_Date_Time;
        public string Delivery_Note_Number;
        public string Notes;
    }
    public class StockRecWrap
    {
        @auraEnabled
        public Stock_In_Product__c SRLineItemRec{get;set;}
        @auraEnabled
        public String productName{get;set;}
        @auraEnabled
        public String productid{get;set;}
        @auraEnabled
        public String Product_Bar_Code{get;set;}
        @auraEnabled
        public String remainqty{get;set;}
        @auraEnabled
        public String orderqty{get;set;}
        @auraEnabled
        public Decimal dispatchedQuantity;// added on 10-06-2020 To show dispatched Quantity on UI      
       
        @auraEnabled
        public Decimal Receiving_Quantity_Original;
        @auraEnabled
        public String attributeType{get;set;}
        @auraEnabled
        public List<Product_Serial_Number__c> serialNo{get;set;}
        @auraEnabled
        public Boolean hasExpiryDate{get;set;}
        
        public StockRecWrap(Stock_In_Product__c SRLineItemRec,String productName,String productid,String Product_Bar_Code,String remainqty,String orderqty,Decimal Receiving_Quantity_Original,String attributeType,List<Product_Serial_Number__c> srpli,Boolean hasExpiryDate,Decimal dispatchedQuantity)
        {
            this.SRLineItemRec = SRLineItemRec;
            this.productName = productName;
            this.productid=productid;
            this.Product_Bar_Code=Product_Bar_Code;
            this.remainqty = remainqty;
            this.orderqty = orderqty;
            this.Receiving_Quantity_Original = Receiving_Quantity_Original;
            this.attributeType = attributeType;
            this.serialNo = serialNo;
            this.hasExpiryDate=hasExpiryDate;
            this.dispatchedQuantity=dispatchedQuantity;
            
        }
    }
    public class strockRecevUpdateWrap
    {
        @auraEnabled
        public Stock_In__c stockReceive;
        @auraEnabled
        public List<SRLinesUpdateWrap> srlwList;
    }
    public class SRLinesUpdateWrap
    {
        @auraEnabled
        public String transID;
        @auraEnabled
        public String transName;
        @auraEnabled
        public List<TransLineItems> TransLineItems;
    }
    public class TransLineItems
    {
        @auraEnabled
        public String attributeType;
        @auraEnabled
        public String productName;
        @auraEnabled
        public String productid;
        @auraEnabled
        public String Product_Bar_Code;
        @auraEnabled
        public Decimal orderqty; 
        @auraEnabled
        public Decimal remainqty;
        @auraEnabled
        public Decimal Receiving_Quantity_Original;
        @auraEnabled
        public List<Product_Serial_Number__c> serialNo;
        @auraEnabled
        public Stock_In_Product__c SRLineItemRec;
         @auraEnabled
        public String BinId;
        @auraEnabled
        public String BinName;
        @auraEnabled
        public Boolean hasExpiryDate{get;set;}
    }
    public class responseWrapper
    {
        @auraEnabled
        public String message{get;set;}
        @auraEnabled
        public String data{get;set;}
        @auraEnabled
        public String duplicateSerialNo{get;set;}
    }
 /*    @auraEnabled
    public static VendorDetailsWrap fetchVendorContactdetails(String vendName)
    {
        VendorDetailsWrap venwrap=new VendorDetailsWrap();
        List<Account> vendacc=[select id,name from Account where RecordType.Name='Vendor' and name=:vendName limit 1];
        system.debug('vendacc>>'+vendacc);
        try{
            venwrap.acccon=[select id,name,AccountId from Contact where AccountId=:vendacc[0].name Limit 1];
            system.debug('acccon>>'+venwrap.acccon);
        }
        catch(Exception e){
            
        }
        return venwrap;
    }*/
    @auraEnabled
    public static List<StockRecWrap> fetchStockReceivingItems(String transID)
    {
        List<StockRecWrap> StockRecWrapList = new List<StockRecWrap>();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order_Product__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Stock_In_Product__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Serial_Number__c')
          
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order_Product__c',new Set<String>{'Id','Name','sigmaerpdev2__Delevered_Quantity__c','sigmaerpdev2__Status__c','sigmaerpdev2__Purchase_Order__c','sigmaerpdev2__Product__r.Attribute_Type__c','sigmaerpdev2__Product__r.sigmaerpdev2__Product_Bar_Code__c','sigmaerpdev2__Product__r.Has_Expiry_Date__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Remaining_to_come__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Delevered_Quantity__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Stock_In_Product__c',new Set<String>{'Id','Name','sigmaerpdev2__Pur_Order__c','sigmaerpdev2__Purchase_Order__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity_Received__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Serial_Number__c',new Set<String>{'Id','Name'}))
        {*/
            for(Purchase_Order_Product__c trans:[select id,Delevered_Quantity__c,Status__c,Purchase_Order__c,Product__r.Attribute_Type__c,Product__r.Product_Bar_Code__c,Product__r.Has_Expiry_Date__c,Quantity__c,Product__c,Product__r.Name,Remaining_to_come__c,Received_Quantity__c from Purchase_Order_Product__c where Purchase_Order__c =:transID and Received_Quantity__c>0 and Status__c!='Closed' ])
            {
                //system.debug('sigmaerpdev2__Purchase_Order_Product__c>>'+trans);
                Stock_In_Product__c srp = new Stock_In_Product__c();
                srp.Pur_Order__c = trans.Purchase_Order__c;
                srp.Purchase_Order__c=trans.id;
                srp.Lot__c= null;
                srp.Product__c = trans.Product__c;
                srp.Quantity_Received__c = 0;
               
                List<Product_Serial_Number__c> srpList = new List<Product_Serial_Number__c>();
                if(trans.Delevered_Quantity__c==null)
                {
                     StockRecWrapList.add(new StockRecWrap(srp,trans.Product__r.Name,trans.Product__c,trans.Product__r.Product_Bar_Code__c,String.valueof(trans.Received_Quantity__c),trans.Quantity__c,0,trans.Product__r.Attribute_Type__c,srpList,trans.Product__r.Has_Expiry_Date__c,0));
                }
               else
                {
                    StockRecWrapList.add(new StockRecWrap(srp,trans.Product__r.Name,trans.Product__c,trans.Product__r.Product_Bar_Code__c,String.valueof(trans.Received_Quantity__c),trans.Quantity__c,0,trans.Product__r.Attribute_Type__c,srpList,trans.Product__r.Has_Expiry_Date__c,trans.Delevered_Quantity__c));
                }
                     
            }
        //}
        return StockRecWrapList;       
    }
     @auraEnabled
    public static void removeSRP(List<id> deletedSRPIdList)
    {
        system.debug('deletedSRPIdList>>>'+deletedSRPIdList);
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Stock_In_Product__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Stock_In_Product__c',new Set<String>{'Id','Name'}))
          
        {*/
            List<Stock_In_Product__c> srpList = [SELECT Id FROM Stock_In_Product__c WHERE Id IN:deletedSRPIdList];
            system.debug('srpList>>>'+srpList);
            if(srpList.size()>0)
                delete srpList;
        //}
    }
    //display default contact, added by Krishna pujara on 15-06-2021
    @auraEnabled
    public static list<Contact> fetchVendorContact(String vendorId){
        list<Contact> con=[select id,Name from Contact where AccountId=:vendorId];
        return con;
    }
    
    // added on 10-06-2020 To show dispatched Quantity on UI        
     @auraEnabled
    public static Boolean fetchDefaultParameters()
    {
        Boolean isShow=false;
        try{
                /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Default_Parameters__c')
                && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Default_Parameters__c',new Set<String>{'Id','Name','sigmaerpdev2__ShowDispatchedQuantityInStockReceivingUI__c'}))  
                { */ 
                    Default_Parameters__c dp=[select id,name,ShowDispatchedQuantityInStockReceivingUI__c from Default_Parameters__c limit 1];
                    if(dp!=null && dp.ShowDispatchedQuantityInStockReceivingUI__c==true)
                    {
                            isShow=dp.ShowDispatchedQuantityInStockReceivingUI__c;
                            return isShow;
                    }
                
                //}
            
        }catch(Exception e)
        {
            String ex=e.getMessage()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getTypeName()+'::'+e.getStackTraceString();
            System.debug('ex>>>>'+ex);
          createErrorLog.insertError('Stock Receiving',ex,'Method -fetchDefaultParameters ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                   
        }
        return isShow;
    }
    @auraEnabled
    public static strockRecevUpdateWrap fetchStockLinesUpdate(String srID)
    {
        system.debug('srID>>>'+srID);
        Map<ID,String> transNameMap = new Map<ID,String>();
        strockRecevUpdateWrap sruw = new strockRecevUpdateWrap();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Stock_In__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Stock_In_Product__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Serial_Number__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Stock_Receiving_Product_Line_Item__c')

           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Stock_In__c',new Set<String>{'Id','Name','sigmaerpdev2__Vendor__c','sigmaerpdev2__Vendor__r.Name','sigmaerpdev2__Purchase_Order__c','sigmaerpdev2__Location__c','sigmaerpdev2__Truck_Number__c','sigmaerpdev2__Received_Date_Time__c','sigmaerpdev2__Location__r.Name','sigmaerpdev2__Delivery_Person__c','sigmaerpdev2__Delivery_Person__r.Name','sigmaerpdev2__Status__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Stock_In_Product__c',new Set<String>{'Id','Name','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.sigmaerpdev2__Product_Bar_Code__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Lot__r.Name','sigmaerpdev2__Bin__c','sigmaerpdev2__Bin__r.Name','sigmaerpdev2__pur_Order__c','sigmaerpdev2__pur_Order__r.Name','sigmaerpdev2__Purchase_Order__r.sigmaerpdev2__Quantity__c','sigmaerpdev2__Purchase_Order__r.sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Purchase_Order__c','sigmaerpdev2__Purchase_Order__r.Name','sigmaerpdev2__Quantity_Received__c','sigmaerpdev2__Returned_Quantity__c','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Product__r.sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Product__r.sigmaerpdev2__Has_Expiry_Date__c','sigmaerpdev2__Putaway_location__c','sigmaerpdev2__Putaway_location__r.Name','sigmaerpdev2__Return_Quantity_Comment__c','sigmaerpdev2__Status__c','sigmaerpdev2__Expiry_Date__c','sigmaerpdev2__Stock_In__c','sigmaerpdev2__Product_Serial_Numbers__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'Id','Name','sigmaerpdev2__Bin__c','sigmaerpdev2__Bin__r.name','sigmaerpdev2__Stock_Receiving_Product__c','sigmaerpdev2__Stock_Receiving_Product__r.sigmaerpdev2__Stock_In__c' })
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Serial_Number__c',new Set<String>{'Id','Name','sigmaerpdev2__Serial_Number__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Stock_Receiving_Product_Line_Item__c',new Set<String>{'Id','Name','sigmaerpdev2__Expiry_Date__c'}))
        {*/
            sruw.stockReceive = [select id,Vendor__c,Vendor__r.Name,Purchase_Order__c,Location__c,Truck_Number__c,Received_Date_Time__c,Status__c,Location__r.Name,Delivery_Person__c,Delivery_Person__r.Name from Stock_In__c where Id=:srID AND Status__c NOT IN('Verified')];            
            system.debug('sruw.stockReceive-->'+sruw.stockReceive);
            Map<String,List<TransLineItems>> srliMap = new Map<String,List<TransLineItems>>();
           
            //code added by rashmi to handle Warehouse Location in SR on 20-09-2019
            Map<ID,ID> srpliIdBinIdMap = new Map<ID,ID>();
            Map<ID,String> srpliIdBinNameMap = new Map<ID,String>();
            for(Inventory_Location_Product_Line_Item__c ilpli:[select id,name,Bin__c,Bin__r.name,Stock_Receiving_Product__c from Inventory_Location_Product_Line_Item__c where Stock_Receiving_Product__r.Stock_In__c=:srID])
            {
                system.debug('ilpli>>>'+ilpli);
                srpliIdBinIdMap.put(ilpli.Stock_Receiving_Product__c,ilpli.Bin__c);
                srpliIdBinNameMap.put(ilpli.Stock_Receiving_Product__c,ilpli.Bin__r.name);
                system.debug('ilpli>>'+ilpli);
            }
            system.debug('srpliIdBinIdMap>>'+srpliIdBinIdMap);
            system.debug('srpliIdBinNameMap>>'+srpliIdBinNameMap);
            //code Ends here
            
            for(Stock_In_Product__c srp:[select Id,Name,Product__c,Product__r.Product_Bar_Code__c,Lot__c,Lot__r.Name,Bin__c,Bin__r.Name,pur_Order__c,pur_Order__r.Name,Purchase_Order__r.Quantity__c,Purchase_Order__r.Received_Quantity__c,Purchase_Order__c,Purchase_Order__r.Name,Quantity_Received__c,Returned_Quantity__c,Product__r.Name,Product__r.Attribute_Type__c,Product__r.Has_Expiry_Date__c,Putaway_location__c,Putaway_location__r.Name,Return_Quantity_Comment__c,Status__c,Expiry_Date__c,(select id,Serial_Number__c from Product_Serial_Numbers__r),(select id,Expiry_Date__c from Stock_Receiving_Product_Line_Items__r)  from Stock_In_Product__c where Stock_In__c =: srID AND Status__c NOT IN('Verified')])
            { 
                system.debug('srp---->'+srp);
                transNameMap.put(srp.pur_Order__c,srp.pur_Order__r.Name);
                /*system.debug('transNameMap--->'+transNameMap);
                system.debug('srliMap-->'+srliMap);
                system.debug('srliMap--->'+srliMap.containskey(srp.sigmaerpdev2__pur_Order__c));*/
                if(srliMap.containskey(srp.pur_Order__c))
                {
                    TransLineItems tli = new TransLineItems();
                    tli.attributeType = srp.Product__r.Attribute_Type__c;
                    tli.productName = srp.Product__r.Name;
                    tli.productid=srp.Product__c;
                    tli.Product_Bar_Code=srp.Product__r.Product_Bar_Code__c;
                    tli.orderqty=decimal.valueOf(srp.Purchase_Order__r.Quantity__c);
                    tli.remainqty=srp.Purchase_Order__r.Received_Quantity__c;
                    tli.hasExpiryDate = srp.Product__r.Has_Expiry_Date__c;
                    
                    //code added by rashmi to handle Warehouse Location in SR on 20-09-2019
                    List<Stock_Receiving_Product_Line_Item__c> srpList=new List<Stock_Receiving_Product_Line_Item__c>();
                    for(Stock_Receiving_Product_Line_Item__c srprod:srp.Stock_Receiving_Product_Line_Items__r){
                        system.debug('srprod>>>>'+srprod);
                        srpList.add(srprod);
                        system.debug('srpList>>>>'+srpList);
                        system.debug('srpList>>>>'+srpliIdBinIdMap.containsKey(srprod.Id));
                        if(srpliIdBinIdMap.containsKey(srprod.Id))
                        {
                            tli.BinId=srpliIdBinIdMap.get(srprod.Id);
                            tli.BinName=srpliIdBinNameMap.get(srprod.Id);
                        }
                    }
                    //code Ends here

                    system.debug('srpList>>>>'+srp.Product_Serial_Numbers__r.size());
                    if(srp.Product_Serial_Numbers__r.size()>0)
                        tli.serialNo = srp.Product_Serial_Numbers__r;
                    system.debug(' tli.serialNo >>>>'+tli.serialNo );
                    tli.Receiving_Quantity_Original = srp.Quantity_Received__c;
                    tli.SRLineItemRec = srp;
                    srliMap.get(srp.pur_Order__c).add(tli);
                    
                }else
                {
                    system.debug('Inside else>>>');
                    List<TransLineItems> tliList = new List<TransLineItems>();
                    TransLineItems tli = new TransLineItems();
                    tli.attributeType = srp.Product__r.Attribute_Type__c;
                    tli.productName = srp.Product__r.Name;
                    tli.productid=srp.Product__c;
                    tli.Product_Bar_Code=srp.Product__r.Product_Bar_Code__c;
                    tli.orderqty=decimal.valueOf(srp.Purchase_Order__r.Quantity__c);
                    tli.remainqty=srp.Purchase_Order__r.Received_Quantity__c;
                    tli.hasExpiryDate = srp.Product__r.Has_Expiry_Date__c;
                    system.debug('tli--->'+tli);
                    
                    //code added by rashmi to handle Warehouse Location in SR on 20-09-2019
                    List<Stock_Receiving_Product_Line_Item__c> srpliList=new List<Stock_Receiving_Product_Line_Item__c>();
                    for(Stock_Receiving_Product_Line_Item__c srpli:srp.Stock_Receiving_Product_Line_Items__r){
                        srpliList.add(srpli);
                        system.debug('after adding srpli >>>'+srpliList);
                        if(srpliIdBinIdMap.containsKey(srpli.Id))
                        {
                            tli.BinId=srpliIdBinIdMap.get(srpli.Id);
                            tli.BinName=srpliIdBinNameMap.get(srpli.Id);
                        }
                    }

                    //code Ends here
                    system.debug('srpList>>>>'+srp.Product_Serial_Numbers__r.size());
                    if(srp.Product_Serial_Numbers__r.size()>0)
                        tli.serialNo = srp.Product_Serial_Numbers__r;
                    system.debug(' tli.serialNo >>>>'+tli.serialNo );
                    tli.Receiving_Quantity_Original = srp.Quantity_Received__c;
                    tli.SRLineItemRec = srp;
                    
                    tliList.add(tli);
                    system.debug('tliList--->'+tliList);
                    
                    srliMap.put(srp.pur_Order__c,tliList);
                    system.debug(' srliMap >>>>'+srliMap);
                }
            }
            system.debug(' SRL-- >>>>'+srliMap);
            List<SRLinesUpdateWrap> srluwList = new List<SRLinesUpdateWrap>();
            system.debug('srliMap.keySet()--->'+srliMap.keySet());
            for(String uniqueTrans: srliMap.keySet())
            {
                // String transID = uniqueTrans.split(':')[1];
                SRLinesUpdateWrap srluw = new SRLinesUpdateWrap();
                srluw.transID = uniqueTrans;
                srluw.transName = transNameMap.get(uniqueTrans);
                srluw.TransLineItems = srliMap.get(uniqueTrans);
                srluwList.add(srluw);
                system.debug('after adding srluw'+srluwList);
            }
            sruw.srlwList = srluwList;
            system.debug('sruw.srlwList--->'+sruw.srlwList);
        //}
        return sruw;
    }
    
    @auraEnabled
    public static responseWrapper saveStockReceiving(String srData,String srpl)
    {
        system.debug('srData>>'+srData);
        system.debug('srpl>>'+srpl);
        Savepoint sp;
        responseWrapper rw = new responseWrapper();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Stock_In__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Stock_In_Product__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sublevel_location__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Serial_Number__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Stock_Receiving_Product_Line_Item__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Lot__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Lot_Product__c')
        
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Stock_In__c',new Set<String>{'Id','Name','sigmaerpdev2__Location__c','sigmaerpdev2__Delivery_Person__c','sigmaerpdev2__Delivery_Person__r.Name','sigmaerpdev2__Vendor__r.Name','sigmaerpdev2__Vendor__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Stock_In_Product__c',new Set<String>{'Id','Name','sigmaerpdev2__Putaway_location__c','sigmaerpdev2__Expiry_Date__c','sigmaerpdev2__pur_Order__c','sigmaerpdev2__Purchase_Order__c','sigmaerpdev2__Quantity_Received__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Purchase_Order__r.sigmaerpdev2__Product__c','sigmaerpdev2__Purchase_Order__r.sigmaerpdev2__Product__r.sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Status__c' })
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Serial_Number__c',new Set<String>{'Id','Name','sigmaerpdev2__Serial_Number__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location__c',new Set<String>{'Id','Name','sigmaerpdev2__Location__c','sigmaerpdev2__Location__r.Id'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sublevel_location__c',new Set<String>{'Id','Name','sigmaerpdev2__zone__r.sigmaerpdev2__Location__c' })
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'Id','Name','sigmaerpdev2__Bin__c','sigmaerpdev2__Bin__r.name','sigmaerpdev2__Stock_Receiving_Product__c','sigmaerpdev2__Stock_Receiving_Product__r.sigmaerpdev2__Stock_In__c' })
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Stock_Receiving_Product_Line_Item__c',new Set<String>{'Id','Name','sigmaerpdev2__Expiry_Date__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot__c',new Set<String>{'Id','Name'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot_Product__c',new Set<String>{'Id','Name','sigmaerpdev2__Location__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Quantity__c'})
        
           &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Stock_In__c',new Set<String>{'sigmaerpdev2__Location__c'})
           &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Stock_In_Product__c',new Set<String>{'sigmaerpdev2__Stock_In__c','sigmaerpdev2__Pur_Order__c','sigmaerpdev2__Purchase_Order__c','sigmaerpdev2__Status__c','sigmaerpdev2__Quantity_Received__c','sigmaerpdev2__Product__c','sigmaerpdev2__Putaway_location__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Expiry_Date__c'})
           &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Serial_Number__c',new Set<String>{'sigmaerpdev2__Serial_Number__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product_Code__c','sigmaerpdev2__Purchase_Order__c','sigmaerpdev2__Purchase_Order_Product__c','sigmaerpdev2__Status__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Stock_Receiving_Product__c'})
           &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Stock_Receiving_Product_Line_Item__c',new Set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Product_Serial_Number__c'})
           &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Lot_Product__c',new Set<String>{'sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Location__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Lot__c'})
           && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Stock_Receiving_Product_Line_Item__c',new Set<String>{'sigmaerpdev2__Stock_Receiving_Product__c'}))
        {*/
            try
            {
                system.debug('srpl:::'+srpl);
                sp = Database.setSavepoint();
               
                Stock_In__c srd = (Stock_In__c)System.JSON.deserialize(srData, Stock_In__c.class);
                srd.Vendor__r=null;
                srd.Location__r=null;
                srd.Delivery_Person__r=null;
                 
                
             /*   system.debug('srData:::'+srData);
                system.debug('srpl:::'+srpl);
                srData = srData.replace('__c','');
                srData = srData.replace('sigmaerpdev','');
                srData =srData.replace('__r','Parent');
                system.debug('srData After Remove:::'+srData);
    
                srpl = srpl.replace('Pur_Order__c','TransactionID');
                srpl =srpl.replace('__c','');
                srpl =srpl.replace('sigmaerpdev','');
                srpl =srpl.replace('__r','Parent');
                system.debug('srpl:::'+srpl);
                
                StockReceivingWrap srd = (StockReceivingWrap)System.JSON.deserialize(srData, StockReceivingWrap.class);
                system.debug('StockReceivingWrap>>:::'+srd);
                sigmaerpdev2__Stock_In__c sr = new sigmaerpdev2__Stock_In__c();
                sr.sigmaerpdev2__Vendor__r = null;  
                sr.sigmaerpdev2__Vendor__c = srd.Vendor;
                sr.sigmaerpdev2__Delivery_Person__r = null;
                if(String.isNotBlank(srd.Contact))
                sr.sigmaerpdev2__Delivery_Person__c = srd.Contact;
                sr.sigmaerpdev2__Location__r =null;
                sr.sigmaerpdev2__Location__c = srd.Receiving_Sites;
                sr.sigmaerpdev2__Received_Date_Time__c = srd.Received_Date_Time;
                sr.sigmaerpdev2__Delivery_Note_Number__c = srd.Delivery_Note_Number;
                sr.sigmaerpdev2__Notes__c = srd.Notes;
               
                if(String.isNotBlank(srd.Id))
                    sr.Id = srd.Id;*/
    
                system.debug('srd'+srd);
                upsert srd;
                
               
                Map<String,String> inventoryLocMap = new Map<String,String>();
                List<Inventory_Location__c>  invLocList;       
                
                invLocList = [Select Id,Name,Location__c,Location__r.Id From Inventory_Location__c where Location__c =:srd.Location__c limit 50000];
                
                for(Inventory_Location__c ill:invLocList)
                {
                    inventoryLocMap.put(ill.Location__r.Id,ill.Id);
                }  
                
                //code added to update Bin in SRP on 24-09-2019 
                List<Sublevel_location__c> sublocList;
                sublocList=[select id,Name,zone__r.Location__c from Sublevel_location__c where zone__r.Location__c=:srd.Location__c limit 50000 ];
                
                srpl = srpl.replace('Pur_Order__c','TransactionID');
                srpl =srpl.replace('__c','');
                srpl =srpl.replace('sigmaerpdev2__','');
                srpl =srpl.replace('__r','Parent');
                system.debug('srpl:::'+srpl);
                List<StockReceivingLinesWrap> srwList = StockReceivingLinesWrap.parse(srpl);
                List<Stock_In_Product__c> srpList= new List<Stock_In_Product__c>();
                List<Stock_In_Product__c> sipToUpsertVerified = new List<Stock_In_Product__c>();
                Map<Id,Decimal> popLineUpdate = new Map<Id,Decimal>();
                List<Product_Serial_Number__c> srpliList = new List<Product_Serial_Number__c>();
                system.debug('srwList:::'+srwList);
                set<id> lotid=new set<id>();
                set<id> ProdTypeid=new set<id>();//created by rashmi to restrict Attribute type changing after updating inventories on 04-04-2020
                Map<Id,Decimal> prodIdSRPQuantMap=new Map<Id,Decimal>();
                
                
                for(StockReceivingLinesWrap srlw : srwList)
                {
                    for(StockReceivingLinesWrap.TransLineItems tli : srlw.TransLineItems)
                    {
                        system.debug('tli:::'+tli);
                        system.debug('tli:::'+tli.SRLineItemRec.Quantity_Received);
                        Stock_In_Product__c  srp= new Stock_In_Product__c();
                        srp.Stock_In__c=srd.id;
                        srp.Pur_Order__c=tli.SRLineItemRec.TransactionID;
                        srp.Purchase_Order__c=tli.SRLineItemRec.Purchase_Order;
                        srp.Status__c = tli.SRLineItemRec.Status;
                        srp.Quantity_Received__c = tli.SRLineItemRec.Quantity_Received;
                        srp.Product__c = tli.SRLineItemRec.Product;
                        srp.Putaway_location__c=tli.SRLineItemRec.Putaway_location;
                        srp.Lot__c=tli.SRLineItemRec.Lot;
                        lotid.add(tli.SRLineItemRec.Lot);
                        ProdTypeid.add(tli.SRLineItemRec.Product);

                        //code commented on 23-09-2019 to update IL in SIP
                        srp.Inventory_Location__c = invLocList[0].id;//added on 23-09-2019
                        //code added on 24-09-2019 to update Bin in SIP
                        srp.Bin__c=tli.BinId;
                        if(String.isNotBlank(tli.SRLineItemRec.Id))
                            srp.id=tli.SRLineItemRec.Id;
                        srp.Expiry_Date__c = tli.SRLineItemRec.Expiry_Date;
                        
                        srpList.add(srp);
                        system.debug('before upsert srpList--->'+srpList);
                        
                        if(tli.SRLineItemRec.Status=='Verified')
                        {
                              sipToUpsertVerified.add(srp);
                            System.debug('inside if');
                           
                            if(prodIdSRPQuantMap.containskey(tli.SRLineItemRec.Product))
                                prodIdSRPQuantMap.put(tli.SRLineItemRec.Product,prodIdSRPQuantMap.get(tli.SRLineItemRec.Product)+tli.SRLineItemRec.Quantity_Received);
                            else
                                prodIdSRPQuantMap.put(tli.SRLineItemRec.Product,tli.SRLineItemRec.Quantity_Received);
                        }
                    }
                }
                upsert srpList;
                system.debug('after upsert srpList--->'+srpList);
                 System.debug('sipToUpsertVerified'+sipToUpsertVerified);
                  System.debug('sipToUpsertVerified'+srpList);
                   integer i=0;
                for(StockReceivingLinesWrap srlw : srwList)
                {
                   system.debug('srlw-->>>'+srlw);
                    for(StockReceivingLinesWrap.TransLineItems tli : srlw.TransLineItems)
                    {
                         System.debug('inside if2 tli--->>'+tli);
                        if(tli.attributeType == 'SERIALIZED' && tli.SRLineItemRec.Status=='Verified')
                        {
                            System.debug('inside if2--->'+tli.serialNo);
                            for(StockReceivingLinesWrap.serialNo sn:tli.serialNo)
                            {
                                System.debug('inside for sn--->>'+sn);
                               
                                Product_Serial_Number__c srpli = new Product_Serial_Number__c();
                                srpli.Serial_Number__c=sn.Serial_Number;
                                srpli.Quantity__c=1;
                                srpli.Product_Code__c=tli.SRLineItemRec.Product;
                                srpli.Purchase_Order__c=tli.SRLineItemRec.TransactionID;
                                srpli.Purchase_Order_Product__c=tli.SRLineItemRec.Purchase_Order;
                                srpli.Status__c='Available';
                                srpli.Lot__c=tli.SRLineItemRec.Lot;
                                system.debug('IL in Inventory Location>>'+ invLocList[0].id);
                                srpli.Inventory_Location__c = invLocList[0].id;
                                //system.debug('IL in PSN>>'+ srpli.sigmaerpdev2__Inventory_Location__c );
                                //code added on 24-09-2019 to update Bin in SIP
                                srpli.Bin__c=tli.BinId;
                                system.debug('Stock_Receiving_Product1-->'+sn.Stock_Receiving_Product);
                                
                                //comment removed by rashmi on 29-11-2019
                                if(String.isNotBlank(sn.Stock_Receiving_Product) && sn.Stock_Receiving_Product!=null)
                                {
                                    srpli.Stock_Receiving_Product__c = sn.Stock_Receiving_Product;
                                    //system.debug('Stock_Receiving_Product2-->'+ srpli.sigmaerpdev2__Stock_Receiving_Product__c);
                                }
                                else
                                {
                                    srpli.Stock_Receiving_Product__c =srpList[i].Id;
                                    //system.debug('Stock_Receiving_Product-->'+ srpli.sigmaerpdev2__Stock_Receiving_Product__c);
                                }//ends here
                                if(String.isNotBlank(sn.Id))
                                    system.debug('before binding sn.Id--->'+sn.Id);
                                    srpli.Id = sn.Id;
                                system.debug('after binding srpli.Id --->'+srpli.Id );
                                srpliList.add(srpli);
                               system.debug('after adding srpliList-->'+ srpliList);
                            }
                        }
                       i++;
                        system.debug('after increasing i--->'+i);
                    }
                }
                System.debug('sipToUpsertVerified11111111111'+sipToUpsertVerified);
                upsert srpliList;
                system.debug('after updating srpliList::'+srpliList);
              
                // upserting srpli data  for BULK Products On 03/05/2019
                List<Stock_In_Product__c> sipWithPSN = [select Id,Name,Putaway_location__c,Expiry_Date__c,Pur_Order__c,Purchase_Order__c,Quantity_Received__c, Lot__c,Purchase_Order__r.Product__c,Purchase_Order__r.Product__r.Attribute_Type__c,Status__c,(select Id, Name from Product_Serial_Numbers__r) from Stock_In_Product__c where Id In : sipToUpsertVerified];
                system.debug('sipWithPSN-->'+sipWithPSN);
                List<Stock_Receiving_Product_Line_Item__c> srpliListToUpsert = new List<Stock_Receiving_Product_Line_Item__c>();
                system.debug('sipWithPSN-->'+sipWithPSN.size());
                if(sipWithPSN.size() > 0)
                {
                    for(Stock_In_Product__c srpInd : sipWithPSN)
                    {
                        system.debug('srpInd-->'+srpInd);
                        if(srpInd.Status__c == 'Verified')
                        {
                            //for BULK Product
                            if(srpInd.Purchase_Order__r.Product__r.Attribute_Type__c == 'BULK')
                            {
                                Stock_Receiving_Product_Line_Item__c srpli = new Stock_Receiving_Product_Line_Item__c();
                                srpli.Stock_Receiving_Product__c = srpInd.Id;
                                srpli.Product__c = srpInd.Purchase_Order__r.Product__c;
                                srpliListToUpsert.add(srpli);
                                system.debug('srpliListToUpsert1--->'+srpliListToUpsert);
                            }
                            else
                            {
                                system.debug('srpInd.Product_Serial_Numbers__r size--->>>'+srpInd.Product_Serial_Numbers__r.size());
                                for(Product_Serial_Number__c psn : srpInd.Product_Serial_Numbers__r)
                                {
                                  system.debug('srpInd.Product_Serial_Numbers__r-->>>'+psn);
                                  Stock_Receiving_Product_Line_Item__c srpli = new Stock_Receiving_Product_Line_Item__c();
                                  srpli.Stock_Receiving_Product__c = srpInd.Id;
                                  srpli.Product__c = srpInd.Purchase_Order__r.Product__c;
                                  srpli.Product_Serial_Number__c = psn.Id;
                                  srpliListToUpsert.add(srpli);
                                  system.debug('srpliListToUpsert2--->'+srpliListToUpsert);
                                }
                            }
                        }
                    }
                }
            system.debug('srpliListToUpsert size>>>'+srpliListToUpsert.size());
           
            if(srpliListToUpsert.size() > 0)
                upsert srpliListToUpsert;
        
                System.debug('after upsert srpliListToUpsert-->'+srpliListToUpsert);
                System.debug('sipToUpsertVerified--->'+sipToUpsertVerified);
                system.debug('passing sipToUpsertVerified-----'+sipToUpsertVerified);
                system.debug('passing srpliList-----'+srpliList);
                system.debug('passing srpliListToUpsert-----'+srpliListToUpsert);
                ilpUpdate.updateILP(sipToUpsertVerified,srpliList,srpliListToUpsert);
                
                //Fetching Lot records of perticular Product Starts
                 try{
                    system.debug('prodIdSRPQuantMap>>'+prodIdSRPQuantMap);
                    if(prodIdSRPQuantMap.size()>0)
                        system.debug('insidebackorder');
                    string flag='SR';
                        BackOrderMailService.notifyBackOrderStockAvailable(prodIdSRPQuantMap,flag);
                }
                catch(Exception e){
                    
                }
                Map<String,List<Lot_Product__c>> lotMap = new Map<String,List<Lot_Product__c>>();
                List<Lot__c> lotList;
                //code added by rashmi on 04-04-2020 to restrict changing attribute type after inventory updates
                List<Product2> Listprodtype;
                Listprodtype =[select id,Name,Typecheck__c from Product2 where id =:ProdTypeid ];
                system.debug('Listprodtype>>'+Listprodtype);
                 for(Product2 typeOfProd:Listprodtype){
                    typeOfProd.Typecheck__c=true;
                }  
                if(Listprodtype.size()>0)
                {
                     upsert Listprodtype;
                }
                //code ends here
                lotList = [Select Id,Name,(Select Id,Name,Location__c,Bin__c,Quantity__c From Lot_Products__r) From Lot__c where id=:lotid];
                
                system.debug('lotlist>>'+lotList);
                for(Lot__c lt:lotList){
                    lotMap.put(lt.Id,lt.Lot_Products__r);
                }  
                system.debug('lotMap>>>'+lotmap);
                
                //Fetching Lot records of perticular Product Ends
                List<Lot_Product__c> lotProductsList = new List<Lot_Product__c>();
                boolean updateLotProductStaus = false;
                Map<id,Map<id,decimal>> lotqty=new  Map<id,Map<id,decimal>>();
                for(Stock_In_Product__c lotpp:srpList)
                {
                    if(lotpp.Status__c == 'Verified')
                    { 
                        if(lotqty.containsKey(lotpp.Lot__c))
                        {
                            system.debug(lotqty.get(lotpp.Lot__c).containsKey(lotpp.Bin__c));
                            if(lotqty.get(lotpp.Lot__c).containsKey(lotpp.Bin__c))
                            {
                                lotpp.Quantity_Received__c=lotqty.get(lotpp.Lot__c).get(lotpp.Bin__c)+lotpp.Quantity_Received__c;
                                lotqty.get(lotpp.Lot__c).put(lotpp.Bin__c,lotpp.Quantity_Received__c);
                            }
                            else{
                                lotqty.get(lotpp.Lot__c).put(lotpp.Bin__c,lotpp.Quantity_Received__c);
                                
                            }
                        }
                        else
                        {
                            Map<id,decimal> lotil= new Map<id,decimal>();
                            lotil.put(lotpp.Bin__c,lotpp.Quantity_Received__c);
                            lotqty.put(lotpp.Lot__c,lotil);
                        }
                        
                    }
                    
                }
                
                system.debug('lotqty>>>'+lotqty);
                
                
                
                Map<id, Map<id,decimal>> lotproqty=new Map<id, Map<id,decimal>>();
                for(Stock_In_Product__c pp:srpList){
                    system.debug('pp>>'+pp);
                    if(pp.Lot__c!=null)
                    {
                        system.debug('hii');
                        system.debug('LotProduct>>'+lotMap.get(pp.Lot__c));
                        List<Lot_Product__c> lotProdList = lotMap.get(pp.Lot__c);
                        system.debug('lotProdList>>'+lotProdList);
                        Boolean isMatched = false;
                        Lot_Product__c lotProd = new Lot_Product__c();
                        if(lotProdList != null && lotProdList.size()>0)
                        {
                         system.debug('pass');   
                            for(Lot_Product__c lp:lotProdList){
                                if(lp.Bin__c == pp.Bin__c){
                                    lotProd = lp;                                               
                                    isMatched = true;
                                    break;
                                }
                            }
                            if(isMatched == true && pp.Status__c == 'Verified')
                            {
                                system.debug('match');
                                if(!lotproqty.containsKey(pp.Product__c)){ 
                                    updateLotProductStaus = true;  
                                    
                                    Map<id,decimal> lotil= new Map<id,decimal>();
                                    lotil.put(pp.Bin__c,pp.Quantity_Received__c);                         
                                    lotproqty.put(pp.Product__c,lotil);
                                    lotProd.Quantity__c = lotProd.Quantity__c + lotqty.get(pp.Lot__c).get(pp.Bin__c);
                                    lotProductsList.add(lotProd);
                                }
                                else if(lotproqty.containsKey(pp.Product__c))
                                {
                                    if(!lotproqty.get(pp.Product__c).containsKey(pp.Bin__c))
                                    {
                                        Map<id,decimal> lotil= new Map<id,decimal>();
                                        lotil.put(pp.Bin__c,pp.Quantity_Received__c);
                                        lotproqty.put(pp.Product__c,lotil);
                                        lotProd.Quantity__c = lotProd.Quantity__c + lotqty.get(pp.Lot__c).get(pp.Bin__c);
                                        lotProductsList.add(lotProd);
                                    }
                                }
                                
                                
                            }else
                            {
                                system.debug('inside else');
                                if(!lotproqty.containsKey(pp.Product__c)&& pp.Status__c == 'Verified')
                                {
                                    system.debug('lot++');
                                    Map<id,decimal> lotil= new Map<id,decimal>();
                                    lotil.put(pp.Bin__c,pp.Quantity_Received__c);
                                    lotproqty.put(pp.Product__c,lotil);
                                    updateLotProductStaus = true;
                                    
                                    lotProd = new Lot_Product__c();
                                    lotProd.Product__c = pp.Product__c;
                                    lotProd.Location__c = pp.Inventory_Location__c;
                                    lotProd.Bin__c = pp.Bin__c;
                                    lotProd.Lot__c = pp.Lot__c;
                                    System.debug('lotProd.Quantity__c:::'+lotProd.Quantity__c);
                                    if(lotProd.Quantity__c==null)
                                    {
                                        lotProd.Quantity__c=0;
                                    }
                                    lotProd.Quantity__c = lotProd.Quantity__c +  lotqty.get(pp.Lot__c).get(pp.Bin__c);
                                    lotProductsList.add(lotProd);
                                }
                                else if(lotproqty.containsKey(pp.Product__c))
                                {
                                    if(!lotproqty.get(pp.Product__c).containsKey(pp.Bin__c))
                                    {
                                        Map<id,decimal> lotil= new Map<id,decimal>();
                                        lotil.put(pp.Bin__c,pp.Quantity_Received__c);
                                        lotproqty.put(pp.Product__c,lotil);
                                        
                                        lotProd = new Lot_Product__c();
                                        lotProd.Product__c = pp.Product__c;
                                        lotProd.Location__c = pp.Inventory_Location__c;
                                        lotProd.Bin__c = pp.Bin__c;
                                        lotProd.Lot__c = pp.Lot__c;
                                        System.debug('lotProd.Quantity__c:::'+lotProd.Quantity__c);
                                        if(lotProd.Quantity__c==null)
                                        {
                                            lotProd.Quantity__c=0;
                                        }
                                        lotProd.Quantity__c = lotProd.Quantity__c + lotqty.get(pp.Lot__c).get(pp.Bin__c);
                                        lotProductsList.add(lotProd);
                                    }
                                    
                                }
                            }
                        }
                        else
                        {
                            if(!lotproqty.containsKey(pp.Product__c)&& pp.Status__c == 'Verified')
                            {
                                system.debug('insidenull');
                                Map<id,decimal> lotil= new Map<id,decimal>();
                                lotil.put(pp.Bin__c,pp.Quantity_Received__c);
                                lotproqty.put(pp.Product__c,lotil);
                                
                                lotProd.Product__c = pp.Product__c;
                                lotProd.Location__c = pp.Inventory_Location__c;
                                lotProd.Bin__c = pp.Bin__c;
                                lotProd.Lot__c = pp.Lot__c;
                                if(lotProd.Quantity__c==null)
                                {
                                    lotProd.Quantity__c=0;
                                }
                                lotProd.Quantity__c = lotProd.Quantity__c +lotqty.get(pp.Lot__c).get(pp.Bin__c);
                                lotProductsList.add(lotProd);
                                system.debug('lotProductsList!!!'+lotProductsList);
                            }
                            else if(lotproqty.containsKey(pp.Product__c))
                            {
                                if(!lotproqty.get(pp.Product__c).containsKey(pp.Bin__c))
                                {
                                    Map<id,decimal> lotil= new Map<id,decimal>();
                                    lotil.put(pp.Bin__c,pp.Quantity_Received__c);
                                    lotproqty.put(pp.Product__c,lotil);
                                    lotProd = new Lot_Product__c();
                                    lotProd.Product__c = pp.Product__c;
                                    lotProd.Location__c = pp.Inventory_Location__c;
                                    lotProd.Bin__c = pp.Bin__c;
                                    lotProd.Lot__c = pp.Lot__c;
                                    System.debug('lotProd.Quantity__c:::'+lotProd.Quantity__c);
                                    system.debug('lotProd Bin'+lotProd.Bin__c );
                                    if(lotProd.Quantity__c==null)
                                    {
                                        lotProd.Quantity__c=0;
                                    }
                                    lotProd.Quantity__c = lotProd.Quantity__c + lotqty.get(pp.Lot__c).get(pp.Bin__c);
                                    lotProductsList.add(lotProd);
                                }
                            }
                        }
                    }
                }
               if(lotProductsList.size()>0)
                {
                    System.debug('lotProductsList4>>'+lotProductsList);
                    upsert lotProductsList;
                }
                System.debug('lotProductsList5>>'+lotProductsList);
                rw.message = 'success';
                rw.data = srd.Id;
                return rw;
            }
            catch(Exception e)
            {
                Database.rollback(sp);
                try{
                    if(e.getMessage().contains('DUPLICATE_VALUE, duplicate value found:'))
                    {
                        String subStringId=e.getMessage().substringBetween('id: ',': []');
                        system.debug('subStringId>>'+subStringId);
                        Product_Serial_Number__c psn=[select Id,Serial_Number__c from Product_Serial_Number__c where id=:subStringId];
                        system.debug('psn>>'+psn);
                        rw.duplicateSerialNo=psn.Serial_Number__c;
                    }
                }
                catch(Exception ecs){
                    
                }
                rw.message = 'error';
                rw.data = e.getMessage()+ ', At Line number '+e.getStackTraceString();
                return rw;
            }
        //}
        //return rw;
    }
}