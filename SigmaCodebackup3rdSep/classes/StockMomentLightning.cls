public with sharing class StockMomentLightning
{
    public class WrapList {
        @AuraEnabled 
        public String ProName {get; set;}
        @AuraEnabled 
        public String IlpId {get; set;}
        @AuraEnabled 
        public Decimal ProQty {get; set;}
        @AuraEnabled
        public List<Inventory_Location_Product_Line_Item__c> IlpliList {get; set;}
        
       public WrapList(String ProName, String IlpId, Decimal ProQty, List<Inventory_Location_Product_Line_Item__c> IlpliList){
            this.ProName = ProName;
            this.IlpId = IlpId;
            this.ProQty = ProQty;
            this.IlpliList = IlpliList;
        }
    } 
    
    @AuraEnabled
    public static List<WrapList> fetchILP(String ilId,String BId){
        system.debug('BId>>'+BId);
        List<WrapList> WrapData;
        
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c') 
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c') 
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'id','name','sigmaerpdev__Products__c','sigmaerpdev__Products__r.Name','sigmaerpdev__Inventory_Location__c','sigmaerpdev__Received_Quantity__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'Id','Name','sigmaerpdev__ILid__c','sigmaerpdev__Lot__c','sigmaerpdev__Product__c','sigmaerpdev__Lot__r.Name','sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Serial_Name__c','sigmaerpdev__Available_Quantity__c','sigmaerpdev__Received_Quantity__c','sigmaerpdev__bucket_field__c','sigmaerpdev__Inventory_Location__c','sigmaerpdev__Expiry_Date__c','sigmaerpdev__Inventory_Location_Product__c'}))
        {*/
        try{
            
            List<Inventory_Location_Product__c> ILPsList=new List<Inventory_Location_Product__c>();
            List<Inventory_Location_Product__c> ILPlist = [select id, name, Products__c, Products__r.Name, Inventory_Location__c, Received_Quantity__c, (select id, Name,ILid__c,Lot__c, Product__c,Lot__r.Name,Product_Serial_Number__c,Serial_Name__c,Available_Quantity__c, Received_Quantity__c, bucket_field__c,Inventory_Location__c,Expiry_Date__c,Inventory_Location_Product__c,Unit_Price__c,Stock_Type__c from Inventory_Location_Product_Line_Items__r where Available_Quantity__c > 0 AND Product__c!=NULL AND Bin__c=:BId) from Inventory_Location_Product__c where Inventory_Location__c =: ilId AND Products__c!=NULL order by Products__r.Name ];    
            system.debug('ILPlist>>>>'+ILPlist); 
            //Added by CNK
            WrapData = new List<WrapList>();
            for(Inventory_Location_Product__c ilp : ILPlist)
            {
                if(ilp.Inventory_Location_Product_Line_Items__r.size()>0)
                    WrapData.add(new WrapList(ilp.Products__r.Name, ilp.Id, ilp.Received_Quantity__c,ilp.Inventory_Location_Product_Line_Items__r));   
                
            }
            
            String jsdata = JSON.serialize(WrapData);
            }catch(Exception e)
                {
                    String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                    //createErrorLog.insertError('Stock Movements',ex,'Method -fetchILP ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                    System.debug('ex>>>>>>'+ex);
                    System.debug('e'+e);
                }
            
       // }
        return WrapData;
    }
    
    @AuraEnabled
    public static StockMovement__c SaveStockMovementdata(String fromId, String ILPdata,Id binId){
        
        StockMovement__c smdata;
       try{
            /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__StockMovement__c')
               &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
               &&CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
               
               &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Serial_Number__c')
               &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
               &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')
               &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Stock_Moment_Product__c')
               &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Lot_Product__c')
               &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__StockMovement__c',new Set<String>{'sigmaerpdev__From_Location__c','sigmaerpdev__Bin__c'})
               &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new Set<String>{'id','sigmaerpdev__ProductCode__c','sigmaerpdev__Avg_Buying_Price__c'})
               &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new Set<String>{'sigmaerpdev__Avg_Buying_Price__c'})
               
               &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'sigmaerpdev__Inventory_Location__c','sigmaerpdev__Location__c','sigmaerpdev__Inventory_Location_Product__c'})
               &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'id','name','sigmaerpdev__Products__c','sigmaerpdev__Received_Quantity__c','sigmaerpdev__Inventory__c','sigmaerpdev__Inventory_Location__c','sigmaerpdev__AvailableAdjustedQty__c'})
               &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev__Received_Quantity__c','sigmaerpdev__Inventory_Location__c','sigmaerpdev__Products__c','sigmaerpdev__Inventory__c'})
               &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'sigmaerpdev__Received_Quantity__c','sigmaerpdev__Lot__c','sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__ILid__c','sigmaerpdev__Product__c','sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__Product_Received_Date__c','sigmaerpdev__AdjustedReceivedqty_c__c','sigmaerpdev__Inventory_Location__c'})
               &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Stock_Moment_Product__c',new Set<String>{'sigmaerpdev__Product2__c','sigmaerpdev__ILPLI__c','sigmaerpdev__PSN__c','sigmaerpdev__Moved_Quantity__c','sigmaerpdev__Moved_Location__c','sigmaerpdev__Stock_Movement__c','sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__From_ILPLI__c'})
               &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'id','name','sigmaerpdev__Products__c','sigmaerpdev__AvailableAdjustedQty__c','sigmaerpdev__bucket_field__c','sigmaerpdev__Product__c','sigmaerpdev__Unit_Price__c','sigmaerpdev__Available_Quantity__c'})
               &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Lot_Product__c',new Set<String>{'id','sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','Location__c','sigmaerpdev__Lot__c'})
               &&CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'Id','Name'})
              )
            {*/
                
                smdata = new StockMovement__c();
                List<Stock_Moment_Product__c> smpList = new List<Stock_Moment_Product__c>();
                List<Inventory_Location_Product__c> UpilpList = new List<Inventory_Location_Product__c>();
                List<Inventory_Location_Product__c> UpilpList1 = new List<Inventory_Location_Product__c>();
                List<Inventory_Location_Product_Line_Item__c> UpilpliList = new List<Inventory_Location_Product_Line_Item__c>();
                List<Inventory_Location_Product_Line_Item__c> InilpliList = new List<Inventory_Location_Product_Line_Item__c>();
                List<Product_Serial_Number__c> psnLoc = new List<Product_Serial_Number__c>();
                List<Lot_Product__c> LPOut = new List<Lot_Product__c>();
                List<Lot_Product__c> LPIN = new List<Lot_Product__c>();
                Map<Id, Map<Id, Decimal>> ILproQty = new Map<Id, Map<Id, Decimal>>();
                Map<Id, Decimal>  Lotqtymap = new Map<Id, Decimal>(); // added by sandhya for Lot
                Map<Id,Map<Id,Decimal>>  LotqtymapLoc = new Map<Id,Map<Id,Decimal>>();// added by sandhya for Lot
                List<ID> lotIDsTo1=new List<ID>(); // added by sandhya for Lot
                List<ID> lotProdTo=new List<ID>(); // added by sandhya for Lot
                Map<Id,Id> maplotpro = new Map<Id,Id>(); // added by sandhya for Lot
                Map<Id,Id> proInv = new Map<Id, Id>();
                Map<Id,Id> maplotproforIL = new Map<Id,Id>();//added by rashmi to update ToIL in ToLP
                Map<Id,Id> maplotproforBin = new Map<Id,Id>();//added by rashmi to update ToBin in ToLP
                Set<Id> ProIds = new Set<Id>();
                Map<ID,ID> prdInvMap=new Map<ID,ID>();
                List<Inventory__c> invList=[select id,ProductCode__c from Inventory__c];
                for(Inventory__c invn : invList)
                    prdInvMap.put(invn.ProductCode__c,invn.id); 
                
                if(!string.isBlank(ILPdata)){
                    
                    
                    List<WrapList> ILPlist=(List<WrapList>) JSON.deserialize(ILPdata, List<WrapList>.class);
                    
                    smdata.From_Location__c = fromId;
                    smdata.Bin__c = binId;
                    insert smdata;   
                    
                    Map<String, Decimal> ilpquantity=new  Map<String, Decimal> ();
                    Map<String, Decimal> ilpliquantity=new  Map<String, Decimal> ();
                    Map<Decimal, String> ilpliindex=new  Map<Decimal, String> ();
                    Decimal i=0;
                    System.debug('SaveStockMovementdata::ILPlist'+ILPlist);
                    for(WrapList WrapItem : ILPlist)
                    {
                        //system.debug('SaveStockMovementdata::WrapItem>>>'+WrapItem);
                        Decimal IlpQty = 0;
                        system.debug('SaveStockMovementdata::WrapItem.IlpliList>>>'+WrapItem.IlpliList);
                        for(Inventory_Location_Product_Line_Item__c ILPLIitem : WrapItem.IlpliList){
                            system.debug('ILPLIitem>>>'+ILPLIitem);
                            if(ILPLIitem.bucket_field__c > 0 && ILPLIitem.bucket_field__c != null){
                                
                                IlpQty = IlpQty + ILPLIitem.bucket_field__c;
                                ProIds.add(ILPLIitem.Product__c);
                                        
                                if(ILPLIitem.Inventory_Location_Product__r.Inventory__c != null){
                                    proInv.put(ILPLIitem.Product__c, ILPLIitem.Inventory_Location_Product__r.Inventory__c);
                                }
                                 system.debug('SaveStockMovementdata::ILproQty>>>'+ILproQty);
                          
                                system.debug('ILproQty.containsKey(ILPLIitem.ILid__c) check >>>'+ILproQty.containsKey(ILPLIitem.ILid__c));
                                if(ILproQty.containsKey(ILPLIitem.ILid__c)){
                                    system.debug('ILid__c and Product__c) check >>>'+ILproQty.get(ILPLIitem.ILid__c).containsKey(ILPLIitem.Product__c));
                                    if(ILproQty.get(ILPLIitem.ILid__c).containsKey(ILPLIitem.Product__c)){
                                        
                                        Decimal oldVal = ILproQty.get(ILPLIitem.ILid__c).get(ILPLIitem.Product__c);
                                        Decimal newVal = oldVal + ILPLIitem.bucket_field__c;
                                        ILproQty.get(ILPLIitem.ILid__c).put(ILPLIitem.Product__c, newVal);
                                        
                                    }else{
                                        ILproQty.get(ILPLIitem.ILid__c).put(ILPLIitem.Product__c, ILPLIitem.bucket_field__c);
                                    }
                                    
                                }else{
                                    
                                    Map<Id, Decimal> proQty = new Map<Id, Decimal>();
                                    proQty.put(ILPLIitem.Product__c, ILPLIitem.bucket_field__c);
                                    
                                    ILproQty.put(ILPLIitem.ILid__c ,proQty);
                                    system.debug('after adding to proQty>>'+proQty);
                                    system.debug('after adding to ILproQty>>'+ILproQty);
                                }
                                
                                 system.debug('SaveStockMovementdata::ILproQty>>>'+ILproQty);
                                 system.debug('SaveStockMovementdata::ILPLIitem.Product_Serial_Number__c>>>'+ILPLIitem.Product_Serial_Number__c);
                          
                                if(ILPLIitem.Product_Serial_Number__c != null)
                                    
                                { 
                                    
                                    Product_Serial_Number__c psnlocItem = new Product_Serial_Number__c();
                                    psnlocItem.Id = ILPLIitem.Product_Serial_Number__c;
                                    psnlocItem.Inventory_Location__c = ILPLIitem.ILid__c;
                                    psnlocItem.Bin__c = ILPLIitem.Bin__c;
                                    psnlocItem.Inventory_Location_Product__c = ILPLIitem.Inventory_Location_Product__c;
                                    psnLoc.add(psnlocItem); 
                                    
                                }
                                ilpliquantity.put(ILPLIitem.Id,ILPLIitem.bucket_field__c);
                                  system.debug('SaveStockMovementdata::ilpliquantity>>>'+ilpliquantity);
                                system.debug('SaveStockMovementdata::ILPLIitem.ILid__c>>>'+ILPLIitem.ILid__c);
                                
                                //=================added by sandhya for lot product,7/27/2018=======================
                                if(ILPLIitem.ILid__c != null){
                                    lotIDsTo1.add(ILPLIitem.ILid__c);
                                    lotProdTo.add(ILPLIitem.Product__c);
                                    system.debug('lotIDsTo1>>>'+lotIDsTo1);
                                    system.debug('lotProdTo>>>'+lotProdTo);
                                    
                                    if(ILPLIitem.Lot__c !=null){
                                        maplotpro.put(ILPLIitem.Lot__c,ILPLIitem.Product__c);
                                        maplotproforBin.put(ILPLIitem.Lot__c,ILPLIitem.Bin__c);
                                        maplotproforIL.put(ILPLIitem.Lot__c,ILPLIitem.ILid__c);
                                        system.debug('after inserting to maplotpro'+maplotpro);
                                        system.debug('after inserting to maplotproforBin'+maplotproforBin);
                                        system.debug('after inserting to maplotproforIL'+maplotproforIL);
                                    }
                                   system.debug('SaveStockMovementdata::LotqtymapLoc>>>'+LotqtymapLoc);
                                 
                                    system.debug('check Lot__c'+LotqtymapLoc.containsKey(ILPLIitem.Lot__c));
                                    if(LotqtymapLoc.containsKey(ILPLIitem.Lot__c)){
                                        system.debug('check Lot__c and ILid__c'+LotqtymapLoc.get(ILPLIitem.Lot__c).containskey(ILPLIitem.ILid__c));
                                        if(LotqtymapLoc.get(ILPLIitem.Lot__c).containskey(ILPLIitem.ILid__c)){
                                            
                                            decimal oldval = LotqtymapLoc.get(ILPLIitem.Lot__c).get(ILPLIitem.ILid__c);
                                            decimal newval = oldval + ILPLIitem.bucket_field__c;
                                            system.debug('oldval>>>'+oldval);
                                            system.debug('newval>>>'+newval);
                                            
                                            LotqtymapLoc.get(ILPLIitem.Lot__c).put(ILPLIitem.ILid__c,newval);
                                        }
                                        else{
                                            LotqtymapLoc.get(ILPLIitem.Lot__c).put(ILPLIitem.ILid__c,ILPLIitem.bucket_field__c);
                                        }
                                    }else{
                                        Map<Id,Decimal>  Locqty = new Map<Id,Decimal>();
                                        Locqty.put(ILPLIitem.ILid__c,ILPLIitem.bucket_field__c);
                                        LotqtymapLoc.put(ILPLIitem.Lot__c,Locqty);
                                    }
                                }
                                 system.debug('SaveStockMovementdata::LotqtymapLoc>>>'+LotqtymapLoc);
                                   system.debug('SaveStockMovementdata::Lotqtymap>>>'+Lotqtymap);
                                 
                                if(Lotqtymap.containsKey(ILPLIitem.Lot__c)){
                                    decimal oldval = Lotqtymap.get(ILPLIitem.Lot__c);
                                    decimal newval = oldval + ILPLIitem.bucket_field__c;
                                    system.debug('oldval>>>'+oldval);
                                    system.debug('newval>>>'+newval);
                                    Lotqtymap.put(ILPLIitem.Lot__c, newval);
                                    
                                }else{
                                    Lotqtymap.put(ILPLIitem.Lot__c, ILPLIitem.bucket_field__c);
                                }
                                  system.debug('SaveStockMovementdata::Lotqtymap>>>'+Lotqtymap);
                                 
                                ilpliindex.put(i,ILPLIitem.Id);
                                i++;
                                  system.debug('SaveStockMovementdata::ilpliindex>>>'+ilpliindex);
                                 
                            } 
                        }
                        
                        system.debug('SaveStockMovementdata::IlpQty>>>'+IlpQty);
                                 
                        if(IlpQty > 0)
                        {
                            ilpquantity.put(WrapItem.IlpId,IlpQty);
                        }
                        system.debug('SaveStockMovementdata::ilpquantity>>>'+ilpquantity);
                        
                    }
                    system.debug('SaveStockMovementdata::ilpquantity>>>'+ilpquantity);
                    
                    List<Inventory_Location_Product__c> ilpdataitem=new List<Inventory_Location_Product__c>();
                    ilpdataitem=[select id, name, Products__c, AvailableAdjustedQty__c, Inventory_Location__c, Received_Quantity__c from Inventory_Location_Product__c where id=:ilpquantity.keySet()];
                    
                    List<ID> lotProd=new List<ID>(); //for LOT added by sandhya
                    List<ID> lotLoc=new List<ID>(); //for LOT added by sandhya
                    system.debug('SaveStockMovementdata::ilpdataitem>>>'+ilpdataitem);
                    
                    for(Inventory_Location_Product__c ilpItem : ilpdataitem)
                    {
                        lotProd.add(ilpItem.Products__c); //for LOT added by sandhya
                        lotLoc.add(ilpItem.Inventory_Location__c); //for LOT added by sandhya
                        system.debug('SaveStockMovementdata::ilpquantity>>>'+ilpquantity);
                    
                        if(ilpquantity.containsKey(ilpItem.id))
                        {
                            Inventory_Location_Product__c ilp = new Inventory_Location_Product__c();
                            if(ilp.AvailableAdjustedQty__c==null)
                            {
                                ilp.AvailableAdjustedQty__c=0;
                            }
                            ilp.Id = ilpItem.id;
                            ilp.AvailableAdjustedQty__c=ilpItem.AvailableAdjustedQty__c+ilpquantity.get(ilpItem.id);
                            UpilpList1.add(ilp);
                        }
                        
                    }
                    
                    
                    //==================for  Lot Fromlocation added by sandhya===================
                    
                    List<Lot_Product__c> LPData = new List<Lot_Product__c>();
                    LPData = [select id,Product__c,Quantity__c,Location__c,Lot__c,Bin__c from Lot_Product__c where Lot__c = : Lotqtymap.keySet() AND Product__c IN : lotProd AND Location__c IN :lotLoc];
                    System.debug('LPData1>>>>>>>>'+LPData);
                    
                    for(Lot_Product__c lp: LPData){
                        System.debug(' iterating LPData>>>>>>>>'+lp);
                        System.debug(' Lot>>>>>>>>'+LotqtymapLoc.containsKey(lp.Lot__c));
                        if(lp.Bin__c == binId)
                        {
                            if(LotqtymapLoc.containsKey(lp.Lot__c)){
                                System.debug('before reducing qty in Lp qty---1>>>>>>>>'+lp.Quantity__c);
                                System.debug('before Lotqtymap qty check >>>>>>>>'+Lotqtymap.get(lp.Lot__c));
                                lp.Quantity__c -= Lotqtymap.get(lp.Lot__c);
                                System.debug('after Lp qty---2>>>>>>>>'+lp.Quantity__c);
                                LPOut.add(lp);
                                System.debug('LPOut after adding lp>>>>>>>>'+LPOut);
                            }
                        }
                    }
                    //=======================ends here=======================
                    
                    
                    List<Inventory_Location_Product_Line_Item__c> ilplidataitem=[select id,Lot__c, Unit_Price__c,name,Product__c,Inventory_Location__c,AvailableAdjustedQty__c,bucket_field__c  from Inventory_Location_Product_Line_Item__c where id=:ilpliquantity.keySet()];
                     system.debug('SaveStockMovementdata::ilplidataitem>>>'+ilplidataitem);
                    system.debug('SaveStockMovementdata::ilpliquantity>>>'+ilpliquantity);
                    
                    for(Inventory_Location_Product_Line_Item__c ilpliItem : ilplidataitem)
                    {
                        if(ilpliquantity.containsKey(ilpliItem.id))
                        {
                            Inventory_Location_Product_Line_Item__c ilpli = new Inventory_Location_Product_Line_Item__c();
                            
                            ilpli.Id = ILPLIitem.Id;
                            if(ilpli.AvailableAdjustedQty__c==null)
                            {
                                ilpli.AvailableAdjustedQty__c=0; 
                            }
                            ilpli.AvailableAdjustedQty__c = ilpliItem.AvailableAdjustedQty__c +ilpliquantity.get(ilpliItem.id);
                            UpilpliList.add(ilpli);
                            
                        }
                        
                    }
                    system.debug('SaveStockMovementdata::LPOut>>>'+LPOut);
                    system.debug('SaveStockMovementdata::UpilpList1>>>'+UpilpList1);
                    system.debug('SaveStockMovementdata::UpilpliList>>>'+psnLoc);
                    system.debug('SaveStockMovementdata::UpilpliList>>>'+UpilpliList);
                    
                    system.debug('before updating LPOut>>'+LPOut.size());
                    if(LPOut.size()>0){
                        update LPOut;
                    }
                    system.debug('after updating LPOut>>'+LPOut);
                    upsert UpilpList1;
                    //Insert InilpliList;
                    Upsert UpilpliList;
                    upsert psnLoc;
                    
                    
                    List<Inventory_Location_Product__c> ToIlpList = [Select Id, Name, Products__c,AdjustedReceivedqty__c, Received_Quantity__c, Inventory__c, Inventory_Location__c from Inventory_Location_Product__c where Products__c IN : ProIds AND Inventory_Location__c IN : ILproQty.KeySet()];
                    Map<Id, Map<Id, Inventory_Location_Product__c>> ToILPProMap = new Map<Id, Map<Id, Inventory_Location_Product__c>>();
                    for(Inventory_Location_Product__c ilp: ToIlpList)
                    {
                        
                        if(ToILPProMap.containsKey(ilp.Inventory_Location__c))
                        {
                            
                            ToILPProMap.get(ilp.Inventory_Location__c).put(ilp.Products__c, ilp);
                            
                        }else
                        {
                            Map<Id, Inventory_Location_Product__c> ProIlp = new Map<Id, Inventory_Location_Product__c>();
                            ProIlp.put(ilp.Products__c, ilp);
                            ToILPProMap.put(ilp.Inventory_Location__c, ProIlp);
                        }
                    }
                    
                    system.debug('SaveStockMovementdata:: ToILPProMap>>'+ToILPProMap);
                    for(Id Ilid: ILproQty.KeySet())
                    {
                        
                        if(ToILPProMap.containsKey(Ilid))
                        {
                            
                            for(Id ProId: ILproQty.get(Ilid).keySet())
                            {
                                
                                if(ToILPProMap.get(Ilid).containsKey(ProId))
                                {
                                    
                                    Inventory_Location_Product__c ToILp = new Inventory_Location_Product__c();
                                    
                                    ToILp.Id = ToILPProMap.get(Ilid).get(ProId).Id;
                                    if(ToILP.AdjustedReceivedqty__c==null)
                                    {
                                        ToILP.AdjustedReceivedqty__c=0; 
                                    }
                                    ToILP.AdjustedReceivedqty__c = ToILPProMap.get(Ilid).get(ProId).AdjustedReceivedqty__c + ILproQty.get(Ilid).get(ProId);
                                    ToILp.Inventory_Location__c = ToILPProMap.get(Ilid).get(ProId).Inventory_Location__c;
                                    ToILp.Products__c = proId;
                                    //added by cnk
                                    ToILp.Inventory__c = ToILPProMap.get(Ilid).get(ProId).Inventory__c;
                                    
                                    UpilpList.add(ToILp);
                                    
                                }else
                                {
                                    Inventory_Location_Product__c ToILp = new Inventory_Location_Product__c();
                                    
                                    ToILp.Inventory_Location__c = Ilid;
                                    
                                    
                                    ToILp.Products__c = proId;
                                    if(ToILP.AdjustedReceivedqty__c==null)
                                    {
                                        ToILP.AdjustedReceivedqty__c=0; 
                                    }
                                    ToILp.AdjustedReceivedqty__c = ILproQty.get(Ilid).get(proId);
                                    if(proInv.containsKey(proId)){ ToILp.Inventory__c = proInv.get(proId);}
                                    
                                    UpilpList.add(ToILp);       
                                }
                            }
                            
                        }else
                        {
                            
                            for(Id proId : ILproQty.get(Ilid).KeySet())
                            {
                                
                                Inventory_Location_Product__c ToILp = new Inventory_Location_Product__c();
                                
                                ToILp.Inventory_Location__c = Ilid;
                                ToILp.Products__c = proId;
                                
                                if(ToILP.AdjustedReceivedqty__c==null)
                                {
                                    ToILP.AdjustedReceivedqty__c=0; 
                                }
                                ToILp.AdjustedReceivedqty__c = ILproQty.get(Ilid).get(proId);
                                if(proInv.containsKey(proId)){ ToILp.Inventory__c = proInv.get(proId);}
                                
                                UpilpList.add(ToILp);
                            }
                        }
                        
                    }
                    
                    
                    for(Inventory_Location_Product__c ul:UpilpList)
                    {
                        ul.Inventory__c=(prdInvMap.containsKey(ul.Products__c)==true?prdInvMap.get(ul.Products__c):NULL); 
                    }
                    
                    upsert UpilpList;
                    
                    Map<Id, Map<Id, Inventory_Location_Product__c>> InILPProMap = new Map<Id, Map<Id, Inventory_Location_Product__c>>(); 
                    
                    for(Inventory_Location_Product__c ilp:UpilpList)
                    {
                        if(InILPProMap.containsKey(ilp.Inventory_Location__c))
                        {
                            
                            InILPProMap.get(ilp.Inventory_Location__c).put(ilp.Products__c, ilp);
                            
                        }else
                        {
                            Map<Id, Inventory_Location_Product__c> ProIlp = new Map<Id, Inventory_Location_Product__c>();
                            ProIlp.put(ilp.Products__c, ilp);
                            InILPProMap.put(ilp.Inventory_Location__c, ProIlp);
                        }   
                    }
                    
                    //==================for LOT Tolocation added by sandhya===================
                    
                    List<Lot_Product__c> LOtPrdTO=new List<Lot_Product__c>(); // updating Lsit of Lotproduct
                    
                    
                    List<Lot_Product__c> LPDataTo = new List<Lot_Product__c>();
                    LPDataTo = [select id,Product__c,Quantity__c,Location__c,Lot__c,Bin__c from Lot_Product__c where Lot__c = : LotqtymapLoc.keySet() AND Product__c IN : lotProdTo AND Location__c IN :lotIDsTo1];
                    System.debug('LPDataTo1>>>>>>>>'+LPDataTo);
                    system.debug('SaveStockMovementdata:: LPDataTo>>'+LPDataTo);
                    system.debug('SaveStockMovementdata:: LPDataTo>>'+LPDataTo);
                    Map<Id,Map<Id,Lot_Product__c>>  LotqtymapLocTo = new Map<Id,Map<Id,Lot_Product__c>>();// added by sandhya for Lot
                    system.debug('LotqtymapLocTo>>>>'+LotqtymapLocTo);
                    for(Lot_Product__c lpTo: LPDataTo){
                        system.debug('Iterating LPDATATO>>'+lpTo);
                        system.debug('checking Lot__c>>'+LotqtymapLocTo.containsKey(lpTo.Lot__c));
                        
                        if(LotqtymapLocTo.containsKey(lpTo.Lot__c))
                        {
                            system.debug('checking Bin__c>>'+LotqtymapLocTo.get(lpTo.Lot__c).containsKey(lpTo.Bin__c));
                            if(LotqtymapLocTo.get(lpTo.Lot__c).containsKey(lpTo.Bin__c))
                            {
                                //LotqtymapLocTo.get(lpTo.Lot__c).put(lpTo.Bin__c,lpTo);
                                system.debug('Do nothing');
                            }
                            else
                            {

                                system.debug('inside else1>>>');
                              //  Map<Id,Lot_Product__c>  LocqtyTo = new Map<Id,Lot_Product__c>();
                               // LocqtyTo.put(lpTo.Bin__c,lpTo);
                                LotqtymapLocTo.get(lpTo.Lot__c).put(lpTo.Bin__c,lpTo);
                             //LotqtymapLocTo.put(lpTo.Lot__c,LocqtyTo);
                                //system.debug('after adding LocqtyTo2>>>>'+LocqtyTo);
                                system.debug('after adding LotqtymapLocTo2>>>>'+LotqtymapLocTo);
                            }
                        }else
                        {
                            system.debug('inside else2>>>');
                            Map<Id,Lot_Product__c>  LocqtyTo = new Map<Id,Lot_Product__c>();
                            LocqtyTo.put(lpTo.Bin__c,lpTo);
                            LotqtymapLocTo.put(lpTo.Lot__c,LocqtyTo);
                            system.debug('after adding LocqtyTo3>>>>'+LocqtyTo);
                            system.debug('after adding LotqtymapLocTo3>>>>'+LotqtymapLocTo);
                        }
                    }
                    system.debug('newwwwww>>'+LotqtymapLocTo);
                    system.debug('SaveStockMovementdata:: LotqtymapLoc>>'+LotqtymapLoc);
                    system.debug('SaveStockMovementdata:: maplotproforBin>>lot and bin'+maplotproforBin);
                    
                    for(Id LotMapID: LotqtymapLoc.keyset()){
                        system.debug('LotqtymapLocTo.containsKey(LotMapID)>>>'+LotqtymapLocTo.containsKey(LotMapID));
                        system.debug('LotqtymapLocTo.get(LotMapID)>>>'+LotqtymapLocTo.get(LotMapID));
                        system.debug('LotqtymapLocTo.containsKey(maplotproforBin.get(LotMapID))>>>'+LotqtymapLocTo.containsKey(maplotproforBin.get(LotMapID)));
                        if(LotqtymapLocTo.containsKey(LotMapID) && LotqtymapLocTo.get(LotMapID).containsKey(maplotproforBin.get(LotMapID))){
                            //for(Id LocID : LotqtymapLoc.get(LotMapID).keyset()){
                            // if(LotqtymapLocTo.get(LotMapID).containsKey(LocID)){
                            system.debug('lpToupdate1>>>'+LotqtymapLocTo.get(LotMapID).get(maplotproforBin.get(LotMapID)));
                            Lot_Product__c lpToupdate = LotqtymapLocTo.get(LotMapID).get(maplotproforBin.get(LotMapID));
                            system.debug('lpToupdate1>>>'+lpToupdate);
                            system.debug('get LotMapID1>>'+LotqtymapLoc.get(LotMapID));
                            system.debug('get Location__c1>>'+LotqtymapLoc.get(LotMapID).get(lpToupdate.Location__c));
                            system.debug('before qty1>>>'+lpToupdate.Quantity__c);
                            lpToupdate.Quantity__c = lpToupdate.Quantity__c+LotqtymapLoc.get(LotMapID).get(lpToupdate.Location__c);
                            system.debug('after qty1>>>'+lpToupdate.Quantity__c);
                            LOtPrdTO.add(lpToupdate);
                            system.debug('after adding LOtPrdTO1>>>'+LOtPrdTO);
                        }
                        else{
                            Lot_Product__c lp = new Lot_Product__c();
                            system.debug('Product name'+maplotpro.get(LotMapID));
                            lp.Product__c = maplotpro.get(LotMapID);
                            system.debug('get LotMapID>>'+LotqtymapLoc.get(LotMapID));
                            
                            system.debug('get Location ID>>>'+maplotproforIL.get(LotMapID));
                            system.debug('get Bin ID>>>'+maplotproforBin.get(LotMapID));
                            
                            system.debug('before qty in to Location>>>'+LotqtymapLoc.get(LotMapID).get(maplotproforIL.get(LotMapID)));
                            
                            lp.Quantity__c = LotqtymapLoc.get(LotMapID).get(maplotproforIL.get(LotMapID));
                            //  lp.Quantity__c = LotqtymapLoc.get(LotMapID);
                            system.debug('after qty2>>>'+lp.Quantity__c);
                            lp.Lot__c = LotMapID;
                            system.debug(maplotproforIL.get(LotMapID));
                            lp.Location__c = maplotproforIL.get(LotMapID);
                            lp.Bin__c=maplotproforBin.get(LotMapID);
                            system.debug('location in LP'+lp.Location__c);
                            system.debug('Bin in LP'+lp.Bin__c);
                            LOtPrdTO.add(lp);
                            system.debug('after adding LOtPrdTO2>>>'+LOtPrdTO);
                        }
                        //}
                        
                        
                        /*else{
for(Id LocId2 : LotqtymapLoc.get(LotMapID).keyset()){
Lot_Product__c lp2 = new Lot_Product__c();
lp2.Product__c = maplotpro.get(LotMapID);
lp2.Quantity__c = LotqtymapLoc.get(LotMapID).get(LocId2);
lp2.Lot__c= LotMapID;
lp2.Location__c= LocId2;
lp2.Bin__c=maplotproforBin.get(LotMapID);
LOtPrdTO.add(lp2);
}
}*/
                    }
                    system.debug('before LOtPrdTO size'+LOtPrdTO.size());
                    if(LOtPrdTO.size()>0) {
                        try{
                            
                            upsert LOtPrdTO;
                            system.debug('after LOtPrdTO size'+LOtPrdTO.size());
                            system.debug('after LOtPrdTO '+LOtPrdTO);
                        } catch(Exception e){
                            System.debug('Error while upserting LOtPrdTO :'+e.getDMLMessage(0));
                        }
                    } 
                    //===================Lot Decreeasing end here========================== 
                    
                    for(WrapList WrapItem : ILPlist)
                    {
                        for(Inventory_Location_Product_Line_Item__c ILPLIlineitem : WrapItem.IlpliList)
                        {   
                            System.debug('ILPLIlineitem'+ILPLIlineitem);
                            if(ILPLIlineitem.bucket_field__c > 0 && ILPLIlineitem.bucket_field__c != null ){
                                Inventory_Location_Product_Line_Item__c Inilpli = new Inventory_Location_Product_Line_Item__c();
                                
                                if(Inilpli.AdjustedReceivedqty_c__c==null)
                                {
                                    Inilpli.AdjustedReceivedqty_c__c=0;
                                }
                                Inilpli.AdjustedReceivedqty_c__c = ILPLIlineitem.bucket_field__c;
                                Inilpli.Product__c = ILPLIlineitem.Product__c;
                                Inilpli.Product_Received_Date__c=system.today();
                                if(ILPLIlineitem.Lot__c != null)
                                { 
                                    Inilpli.Lot__c = ILPLIlineitem.Lot__c; 
                                }
                                if(ILPLIlineitem.Product_Serial_Number__c != null){ Inilpli.Product_Serial_Number__c = ILPLIlineitem.Product_Serial_Number__c; }
                                Inilpli.ILid__c = ILPLIlineitem.ILid__c;
                                Inilpli.Bin__c =ILPLIlineitem.Bin__c;    
                                Inilpli.Inventory_Location__c = ILPLIlineitem.Inventory_Location__c;
                                Inilpli.Stock_Type__c = 'Moved IN'; // commented on 31-01-2020
                                Inilpli.Unit_Price__c = ILPLIlineitem.Unit_Price__c;// added on 30-01-2020  to update unit price FIELD in new  ILPLI after stockMovement
                                //Inilpli.Stock_Type__c = 'Stock Movement';// added on 31-01-2020  to update SOURCE ORIGIN FIELD in new  ILPLI after stockMovement
                                
                                if(InILPProMap.containsKey(ILPLIlineitem.ILid__c))
                                {
                                    if(InILPProMap.get(ILPLIlineitem.ILid__c).containsKey(ILPLIlineitem.Product__c))
                                    {
                                        
                                        Inilpli.Inventory_Location_Product__c = InILPProMap.get(ILPLIlineitem.ILid__c).get(ILPLIlineitem.Product__c).Id;
                                        
                                    }
                                }
                                System.debug('ILPLIlineitem'+ILPLIlineitem);
                                InilpliList.add(Inilpli); 
                            }
                        }
                    }
                    System.debug('InilpliList>>'+InilpliList);
                    insert InilpliList;
                    list<Product_Serial_Number__c> psnList = new list<Product_Serial_Number__c>();
                    Decimal j=0;
                    for(Inventory_Location_Product_Line_Item__c ILPLIitem:InilpliList)
                    {
                        Stock_Moment_Product__c smpdata = new Stock_Moment_Product__c();
                        
                        Product_Serial_Number__c sn = new Product_Serial_Number__c();
                        sn.Inventory_Location_Product__c = ILPLIitem.Inventory_Location_Product__c;
                        sn.Id=ILPLIitem.Product_Serial_Number__c;
                        psnList.add(sn);
                        
                        smpdata.Product2__c = ILPLIitem.Product__c;
                        smpdata.ILPLI__c = ILPLIitem.Id;
                        smpdata.PSN__c = ILPLIitem.Product_Serial_Number__c;
                        if(ILPLIitem.Lot__c != null){ smpdata.Lot__c = ILPLIitem.Lot__c; }
                        smpdata.Moved_Quantity__c = ILPLIitem.AdjustedReceivedqty_c__c;
                        smpdata.Moved_Location__c = ILPLIitem.ILid__c;
                        smpdata.To_Bin__c = ILPLIitem.Bin__c;
                        smpdata.Inventory_Location_Product__c=ILPLIitem.Inventory_Location_Product__c;
                        //ILPLIitem.ILid__c = null;
                        ILPLIitem.Inventory_Location__c = ILPLIitem.ILid__c;
                        ILPLIitem.bucket_field__c= null;
                        smpdata.Stock_Movement__c = smdata.Id;
                        if(ilpliindex.containsKey(j))
                        {
                            smpdata.From_ILPLI__c=ilpliindex.get(j);
                        }
                        smpList.add(smpdata);
                        j++;
                        
                    }
                    update InilpliList;
                    insert smpList;
                    upsert psnList;
                    /***** update avg unit price in PI started******/
                    Set<ID>setOfproductId=new Set<ID>();
                    for(Stock_Moment_Product__c smp : smpList)
                        setOfproductId.add(smp.Product2__c);
                    System.debug('setOfproductId>>'+setOfproductId);
                    Map<Id,Double>productAndAveragePrice=new Map<Id,Double>();
                    for(Product2 pro : [select id,name,(select id,name,Unit_Price__c from Inventory_Location_Product_Line_Items__r where Product__c  =:setOfproductId and Available_Quantity__c>0)from Product2 where id=:setOfproductId ])
                    {
                        System.debug('pro>>'+pro);
                        System.debug('pro.Inventory_Location_Product_Line_Items__r>>'+pro.Inventory_Location_Product_Line_Items__r);
                        if(pro.Inventory_Location_Product_Line_Items__r.size()>0)
                        {
                            Double unitprice=0;
                            for(Inventory_Location_Product_Line_Item__c ilpli : pro.Inventory_Location_Product_Line_Items__r)
                            {
                                if(ilpli.Unit_Price__c!=NULL)unitprice+=ilpli.Unit_Price__c;
                            }
                            if(unitprice>=0)productAndAveragePrice.put(pro.Id,Double.valueOf(unitprice/pro.Inventory_Location_Product_Line_Items__r.size()));
                            System.debug('productAndAveragePrice>>'+productAndAveragePrice);
                        }
                    }
                    List<Inventory__c> invListNew=new List<Inventory__c>();
                    for(Inventory__c inv : [select id,Avg_Buying_Price__c,ProductCode__c from Inventory__c where ProductCode__c=:setOfproductId])
                    {
                        System.debug('inv>>'+inv);
                        if(productAndAveragePrice.containsKey(inv.ProductCode__c))
                        {
                            inv.Avg_Buying_Price__c=productAndAveragePrice.get(inv.ProductCode__c);invListNew.add(inv);
                        }
                    }
                    System.debug('invListNew>>'+invListNew);
                    if(invListNew.size()>0)update invListNew;
                    /***** update avg unit price in PI ended******/
                    
                    //code added by rashmi on 04-04-2020 to restrict changing attribute type after inventory updates
                    List<Product2> Listprodtype;
                    Listprodtype =[select id,Name,Typecheck__c from Product2 where Typecheck__c=false and id =:setOfproductId ];
                    system.debug('Listprodtype>>'+Listprodtype);
                    for(Product2 typeOfProd:Listprodtype){
                        typeOfProd.Typecheck__c=true;
                    }  
                    if(Listprodtype.size()>0)
                    {
                        upsert Listprodtype;
                    }
                    //code ends here
                }
                
           // }
            
            
        }
        catch(Exception e)
        {
        String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                   // createErrorLog.insertError('Stock Movements',ex,'Method -SaveStockMovementdata ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                    System.debug('ex>>>>>>'+ex);
                    System.debug('e'+e);
            //createErrorLog.insertError('Stock Movements',ex.getMessage(),'Method -SaveStockMovementdata ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
        }
        
        
        return smdata;  
    }
    
    
    @AuraEnabled
    public static List<Stock_Moment_Product__c> getStockProductDetails(String StockMomentId)
    { 
        List<Stock_Moment_Product__c> StkMomentProdList = new List<Stock_Moment_Product__c>();
        
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Stock_Moment_Product__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Stock_Moment_Product__c',new set<string>{'id','name','sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__Product_Name__c','sigmaerpdev__Location_Name__c','sigmaerpdev__Reason_for_Stock_Mismatch__c','sigmaerpdev__Stock_Movement__c','sigmaerpdev__Quantity_Out__c','sigmaerpdev__Quantity__c','sigmaerpdev__Product2__r.name','From_Location__r.name'}))
        {*/
            try{
            StkMomentProdList = [select Id, name,Inventory_Location_Product__c, Product_Name__c,Location_Name__c,Reason_for_Stock_Mismatch__c,Stock_Movement__c,Quantity_Out__c,Quantity__c,Product2__r.name,From_Location__r.name  from Stock_Moment_Product__c where Stock_Movement__c =:StockMomentId];
            }catch(Exception e)
                {
                    String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                    //createErrorLog.insertError('Stock Movements',ex,'Method -getStockProductDetails ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                    System.debug('ex>>>>>>'+ex);
                    System.debug('e'+e);
                }
        //}
        return  StkMomentProdList;
    }
    
    @AuraEnabled
    public Static List<StockMovement__c> getStockOutDetails(String StockMomentId)
    {
        List<StockMovement__c> Stkmov = new List<StockMovement__c>();
        
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__StockMovement__c') 
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__StockMovement__c',new set<string>{'id','sigmaerpdev__Location_Name__c','sigmaerpdev__Location__c'}))
        {*/
        try{
            Stkmov = [select Id,Location_Name__c,Location__c from StockMovement__c where ID =:StockMomentId];
        }catch(Exception e)
                {
                    String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                   // createErrorLog.insertError('Stock Movements',ex,'Method -getStockOutDetails ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                    System.debug('ex>>>>>>'+ex);
                    System.debug('e'+e);
                }
       // }
        return Stkmov ;
    }
    
    
    @AuraEnabled
    public Static void deleteStockMovementProd(String stockMovementProducts,Integer idx){
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Stock_Moment_Product__c'))
        {*/
            try{
            Type t = Type.forName('List<Stock_Moment_Product__c>');
            List<SObject> stockMovementProdList = (List<SObject>)JSON.deserialize(stockMovementProducts, t);
            
            if(stockMovementProdList.get(idx).Id != null)
            {
                delete stockMovementProdList.get(idx);
            }
            }catch(Exception e)
                {
                    String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                   // createErrorLog.insertError('Stock Movements',ex,'Method -deleteStockMovementProd ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                    System.debug('ex>>>>>>'+ex);
                    System.debug('e'+e);
                }
            
        //}      
    }
    
}