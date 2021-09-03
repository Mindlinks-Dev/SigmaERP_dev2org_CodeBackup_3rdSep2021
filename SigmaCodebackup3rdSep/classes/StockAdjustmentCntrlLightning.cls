public with sharing Class StockAdjustmentCntrlLightning
{ 
    @AuraEnabled
    public static Inventory_Location_Product__c fectchILP(string invLocPrdId)
    {
        Inventory_Location_Product__c stAdj; 
        
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'Id','Name','sigmaerpdev2__Inventory_Location__c', 'sigmaerpdev2__Net_Quantity__c', 'sigmaerpdev2__Inventory_Location__r.Name', 'sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c','sigmaerpdev2__Product_Name__c','sigmaerpdev2__Products__c','sigmaerpdev2__Products__r.sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Adjusted_Quantity__c', 'sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Reduced_Adjusted_Quantity__c','sigmaerpdev2__Increased_Adjusted_Quantity__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'Id', 'Name','sigmaerpdev2__Inventory_Location_Product__c', 'sigmaerpdev2__Lot__c', 'sigmaerpdev2__Lot__r.Name','sigmaerpdev2__Serial_Name__c', 'sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Received_Quantity1__c', 'sigmaerpdev2__Used_Quantity__c', 'sigmaerpdev2__Product__c','sigmaerpdev2__Product_Expiry_Date__c', 'sigmaerpdev2__Expiry_Date__c', 'sigmaerpdev2__Product__r.sigmaerpdev2__Attribute_Type__c', 'sigmaerpdev2__Product_Serial_Number__c', 'sigmaerpdev2__Product_Serial_Number__r.Name', 'sigmaerpdev2__bucket_field__c','sigmaerpdev2__Adjusted_Quantity__c', 'sigmaerpdev2__Reduced_Adjusted_Quantity__c', 'sigmaerpdev2__Recent_Adjusted_Quantity__c','sigmaerpdev2__Available_Quantity__c'})
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
          )
        {*/
        try{
            if(invLocPrdId != null)
            {
                stAdj = [SELECT Id,Name,Inventory_Location__c, Net_Quantity__c, Inventory_Location__r.Name, Inventory_Location__r.Location__c,Product_Name__c,Products__c,Products__r.Attribute_Type__c,Attribute_Type__c,Adjusted_Quantity__c, Received_Quantity__c,Reduced_Adjusted_Quantity__c,Increased_Adjusted_Quantity__c,(SELECT Id, Name,Inventory_Location_Product__c, Lot__c, Lot__r.Name,Serial_Name__c, Available_Quantity__c,Received_Quantity__c,Received_Quantity1__c, Used_Quantity__c, Product__c,Product_Expiry_Date__c, Expiry_Date__c, Product__r.Attribute_Type__c, Product_Serial_Number__c, Product_Serial_Number__r.Name, bucket_field__c,Adjusted_Quantity__c, Reduced_Adjusted_Quantity__c, Recent_Adjusted_Quantity__c,Unit_Price__c,Stock_Type__c FROM Inventory_Location_Product_Line_Items__r WHERE Available_Quantity__c > 0)FROM Inventory_Location_Product__c WHERE Id = :invLocPrdId ];
                
            }
        }catch(Exception e)
                {
                    String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                    createErrorLog.insertError('Stock Adjustments',ex,'Method -fectchILP ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                    System.debug('ex>>>>>>'+ex);
                    System.debug('e'+e);
                }
        //}
        return stAdj; 
    }
    
    @AuraEnabled
    public static List<Inventory_Location_Product__c> fetchILPLocation (string locId,string productID){
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'Id','Name','sigmaerpdev2__Inventory_Location__c', 'sigmaerpdev2__Net_Quantity__c', 'sigmaerpdev2__Inventory_Location__r.Name', 'sigmaerpdev2__Inventory_Location__r.Location__c','sigmaerpdev2__Product_Name__c','sigmaerpdev2__Products__c','sigmaerpdev2__Products__r.sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Adjusted_Quantity__c', 'sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Reduced_Adjusted_Quantity__c','sigmaerpdev2__Increased_Adjusted_Quantity__c','sigmaerpdev2__Inventory_Location_Name__c'})
          ){*/
          try{
              List<Inventory_Location_Product__c> ilpList = [SELECT Id,Name,Inventory_Location__c, Net_Quantity__c, Inventory_Location__r.Name, Inventory_Location__r.Location__c,Product_Name__c,Products__c,Products__r.Attribute_Type__c,Attribute_Type__c,Adjusted_Quantity__c, Received_Quantity__c,Reduced_Adjusted_Quantity__c,Increased_Adjusted_Quantity__c,Inventory_Location_Name__c FROM Inventory_Location_Product__c WHERE Products__c = :productID and Inventory_Location__c =:locId];
              if(!ilpList.isEmpty()){
                  return ilpList;
              }
            }catch(Exception e)
                {
                    String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                    createErrorLog.insertError('Stock Adjustments',ex,'Method -fetchILPLocation ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                    System.debug('ex>>>>>>'+ex);
                    System.debug('e'+e);
                }
          //}
        return null;
    }
    @AuraEnabled
    public static void saveStockAdjustment(StockAdjustment__c stockAdjustments, String sapItems, Inventory_Location_Product__c ILP)
    {

         /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new set<String>{'Id','Name','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__ProductCode__c','sigmaerpdev2__Products__c','sigmaerpdev2__Avg_Buying_Price__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new set<String>{'sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__Avg_Buying_Price__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'sigmaerpdev2__Increased_Adjusted_Quantity__c','sigmaerpdev2__Adjusted_Quantity__c','sigmaerpdev2__Reduced_Adjusted_Quantity__c','sigmaerpdev2__Recent_Adjusted_Quantity__c','sigmaerpdev2__Source_Type__c','sigmaerpdev2__Products__c','sigmaerpdev2__Inventory_Location__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot_Product__c',new set<String>{'id','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Location__c','sigmaerpdev2__Bin__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Product_Received_Date__c','sigmaerpdev2__Product_Serial_Number__c','sigmaerpdev2__ILid__c','sigmaerpdev2__Reason__c','sigmaerpdev2__Reduced_Adjusted_Quantity__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Recent_Adjusted_Quantity__c','sigmaerpdev2__bucket_field__c','sigmaerpdev2__Product_Expiry_Date__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Adjusted_Quantity__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Stock_Adjustment_Product__c',new set<String>{'sigmaerpdev2__ILPLI__c','sigmaerpdev2__PSN__c','sigmaerpdev2__Adjusted_Quantity__c','sigmaerpdev2__Product__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Serial_Number__c',new set<String>{'id'})
           &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Stock_Adjustment_Product__c',new set<String>{'sigmaerpdev2__Stock_Adjustment__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Lot_Product__c',new set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Location__c','sigmaerpdev2__Bin__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'id','sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Products__c','sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c','sigmaerpdev2__Inventory_Location__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'id','sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__Product_Expiry_Date__c','sigmaerpdev2__bucket_field__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Product__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Serial_Number__c',new set<String>{'sigmaerpdev2__Product_Code__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Location__c','sigmaerpdev2__Serial_Number__c','sigmaerpdev2__Expiry_date__c','sigmaerpdev2__Status__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Package_Status__c','sigmaerpdev2__Inventory_Location__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__StockAdjustment__c',new set<String>{'Id','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Authorized_By__c','sigmaerpdev2__Adjusted_Qty__c','sigmaerpdev2__Original_Qty__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Reason_Code__c','sigmaerpdev2__Date__c','sigmaerpdev2__Adjust_Type__c','sigmaerpdev2__Comments__c'})
           &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__StockAdjustment__c',new set<String>{'sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Authorized_By__c','sigmaerpdev2__Adjusted_Qty__c','sigmaerpdev2__Original_Qty__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Reason_Code__c','sigmaerpdev2__Date__c','sigmaerpdev2__Adjust_Type__c','sigmaerpdev2__Comments__c'})
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Lot_Product__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Stock_Adjustment_Product__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Serial_Number__c')
           &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__StockAdjustment__c')
           
          ) 
        {*/
            try{
            stockAdjustments.Adjusted_Qty__c = stockAdjustments.Quantity__c;
            upsert stockAdjustments;
            System.debug('stockAdjustments>>'+stockAdjustments);  

            set<id> ProdTypeid=new set<id>();//created by rashmi to restrict Attribute type changing after updating inventories on 04-04-2020
            // new code added
            Inventory_Location_Product__c ilpUpdate = ILP;
            ilpUpdate.id=stockAdjustments.Inventory_Location_Product__c;
            ProdTypeid.add(ilpUpdate.Products__c);
            System.debug('ilpUpdate>>'+ilpUpdate);  

            if (stockAdjustments.Adjust_Type__c=='Increase Stock'){
                
                if(ilpUpdate.Increased_Adjusted_Quantity__c==null)
                {
                    ilpUpdate.Increased_Adjusted_Quantity__c=0; 
                }
                ilpUpdate.Increased_Adjusted_Quantity__c = ilpUpdate.Increased_Adjusted_Quantity__c + stockAdjustments.Quantity__c;
                if(ilpUpdate.Recent_Adjusted_Quantity__c==null)
                {
                    ilpUpdate.Recent_Adjusted_Quantity__c=0; 
                }
                ilpUpdate.Recent_Adjusted_Quantity__c= stockAdjustments.Quantity__c;
                ilpUpdate.Source_Type__c='System';
            }
            else
            {
                if(ilpUpdate.Reduced_Adjusted_Quantity__c==null)
                {
                    ilpUpdate.Reduced_Adjusted_Quantity__c=0; 
                }
                ilpUpdate.Reduced_Adjusted_Quantity__c = ilpUpdate.Reduced_Adjusted_Quantity__c + stockAdjustments.Quantity__c;
                if(ilpUpdate.Recent_Adjusted_Quantity__c==null)
                {
                    ilpUpdate.Recent_Adjusted_Quantity__c=0; 
                }
                ilpUpdate.Recent_Adjusted_Quantity__c= stockAdjustments.Quantity__c;
                ilpUpdate.Source_Type__c='System';
            }
                System.debug('ilpUpdate>>'+ilpUpdate);
            update ilpUpdate;
            
            
            //-----New code to update PI----------
            
            Inventory__c PI = [select Id,Name,Available_Qty__c,Total_Available_Qty__c from Inventory__c where ProductCode__c =: ILP.Products__c limit 1];
            System.debug('PI>>'+PI); 
            if (stockAdjustments.Adjust_Type__c=='Increase Stock'){
                
                PI.Total_Available_Qty__c = PI.Total_Available_Qty__c + stockAdjustments.Adjusted_Qty__c;
                PI.Comments__c='Inventory increases due to the New stocks adjustment';
                
            }else{
                PI.Available_Qty__c = PI.Available_Qty__c - stockAdjustments.Adjusted_Qty__c;
                PI.Total_Available_Qty__c = PI.Total_Available_Qty__c - stockAdjustments.Adjusted_Qty__c;
                PI.Comments__c='Inventory decreases due to the Damaged/Expired/Missing/Unknown stocks adjustment';
            }
                System.debug('PI>>'+PI);
            update PI;
            System.debug('sapItems>>'+sapItems);
            
            if(!string.isBlank(sapItems))
            {
                List<Stock_Adjustment_Product__c> saplist = new List<Stock_Adjustment_Product__c>(); 
                List<Product_Serial_Number__c> psnList = new List<Product_Serial_Number__c>();
                List<Lot_Product__c> lpList=new List<Lot_Product__c>();
                List<ID> lotIDs=new List<ID>();
                
                Map<String, Product_Serial_Number__c> ScPSNmap = new Map<String, Product_Serial_Number__c>();
                Map<Id, Lot_Product__c>  LotProMap = new Map<Id, Lot_Product__c>();
                
                Type  objectType =Type.forName('List<Inventory_Location_Product_Line_Item__c>');
                     System.debug('sapItems>>'+sapItems);
               sapItems= sapItems.replace('"sigmaerpdev2__Product_Expiry_Date__c":""', '"sigmaerpdev2__Product_Expiry_Date__c":null');
                 System.debug('sapItems>>'+sapItems);
                List<Inventory_Location_Product_Line_Item__c> ilplidata=(List<Inventory_Location_Product_Line_Item__c>) JSON.deserialize(sapItems, objectType);
                List<Inventory_Location_Product_Line_Item__c> ilplinewdata=new List<Inventory_Location_Product_Line_Item__c>();
                System.debug('ilplidata>>'+ilplidata);
                List<Lot_Product__c> lpListToInsert=new List<Lot_Product__c>();// commented on 29-10-2019
                
                if(stockAdjustments.Adjust_Type__c == 'Increase Stock' && ILP.Attribute_Type__c == 'BULK')
                {
                    Map<Id,Id>lotAndBinIds=new Map<Id,Id>();
                    
                    for(Inventory_Location_Product_Line_Item__c ilpli : ilplidata)
                    { 
                        lotIDs.add(ilpli.Lot__c);
                        ProdTypeid.add(ilpli.Product__c);//code added by rashmi on 05-04-2020 to add all product ids
                        system.debug('ProdTypeid>>>'+ProdTypeid);
                        if(!(lotAndBinIds.containsKey(ilpli.Lot__c)))
                        {
                            lotAndBinIds.put(ilpli.Lot__c,ilpli.Bin__c);
                            
                        }
                        
                    }
                    
                    lpList=[select id,Product__c,Quantity__c,Lot__c,Location__c,Bin__c from Lot_Product__c where Lot__c  =: lotIDs order by Name];
                    
                    
                    for(Lot_Product__c lp: lpList){ 
                        
                        if(lotAndBinIds.containsKey(lp.Lot__c))
                        {
                            if(lotAndBinIds.get(lp.Lot__c)==lp.Bin__c)
                            {
                                LotProMap.put(lp.Lot__c, lp);
                            }
                        }
                        
                        
                    }
                    
                }
                else{
                    
                    List<Id>lisBin=new List<Id>();
                    for(Inventory_Location_Product_Line_Item__c ilpli : ilplidata)
                    { 
                        lotIDs.add(ilpli.Lot__c);
                        lisBin.add(ilpli.Bin__c);

                    }
                    System.debug('lotIDs else >>>'+lotIDs);
                    
                    lpList=[select id,Product__c,Quantity__c,Lot__c,Location__c,Bin__c from Lot_Product__c where Lot__c  =: lotIDs and Bin__c=:lisBin ];
                    
                    //code added by anuja
                    System.debug('lpList>>'+lpList);
                    for(Lot_Product__c lp: lpList)
                    { 
                         LotProMap.put(lp.Lot__c, lp);
                    }
                    
                    System.debug('LotProMap>>'+LotProMap);
                    
                }
                
                if(stockAdjustments.Adjust_Type__c =='Increase Stock' && ILP.Attribute_Type__c == 'SERIALIZED')
                {
                    Map<Id,set<Lot_Product__c>>setOfLotPros=new Map<Id,set<Lot_Product__c>>();
                    Map<id,Map<id,decimal>> lotqtyupdate=new Map<id,Map<id,decimal>>();
                    Set<Id>setofBins=new Set<Id>();
					system.debug('ilplidata->>>>'+ilplidata);
                    for(Inventory_Location_Product_Line_Item__c ilpli : ilplidata)
                    { 
						system.debug('ilpli->>>>'+ilpli);
                       // if(!(lotIDs.contains(ilpli.Lot__c)))
                       // {
                            lotIDs.add(ilpli.Lot__c);
                        	setofBins.add(ilpli.Bin__c);
                         //   system.debug('Lot__c->>>>'+lotqtyupdate.containsKey(ilpli.Lot__c));
                          //  system.debug('Bin__c->>>>'+lotqtyupdate.get(ilpli.Lot__c).containsKey(ilpli.Bin__c));
                        if(lotqtyupdate.containsKey(ilpli.Lot__c))
                        {
                            if(lotqtyupdate.get(ilpli.Lot__c).containsKey(ilpli.Bin__c))
                            {
                                decimal qty=lotqtyupdate.get(ilpli.Lot__c).get(ilpli.Bin__c);
                                lotqtyupdate.get(ilpli.Lot__c).put(ilpli.Bin__c,qty+ilpli.sigmaerpdev2__Adjusted_Quantity__c);
                            	system.debug('lotqtyupdate1???'+lotqtyupdate);
                            }
                            else
                            {
                                Map<id,decimal> locid=new Map<id,decimal>();
                                lotqtyupdate.get(ilpli.Lot__c).put(ilpli.Bin__c,ilpli.sigmaerpdev2__Adjusted_Quantity__c);
                                system.debug('lotqtyupdate2???'+lotqtyupdate);
                            }
                        }
                        else
                        {
                            Map<id,decimal> locid=new Map<id,decimal>();
                            locid.put(ilpli.Bin__c,ilpli.sigmaerpdev2__Adjusted_Quantity__c);
                            lotqtyupdate.put(ilpli.Lot__c,locid);
                            system.debug('lotqtyupdate3???'+lotqtyupdate);
                        }
                      // }  
                    }
                    system.debug('setofBins???'+setofBins);
					system.debug('lotIDs>>>>'+lotIDs);
                    lpList=[select id,Product__c,Quantity__c,Lot__c,Location__c,Bin__c from Lot_Product__c where Lot__c  =: lotIDs  and Bin__c=:setofBins ];
					system.debug('lpList>>>'+lpList);
					system.debug('setOfLotPros>>>'+setOfLotPros);
                   // 
                    for(Lot_Product__c lp: lpList)
                    { 
							system.debug('lp>>>'+lp);
							system.debug('setOfLotPros>>>'+setOfLotPros.containsKey(lp.Lot__c));
                        if(!(setOfLotPros.containsKey(lp.Lot__c)))
                        {
                            
                            set<Lot_Product__c>lp1=new set<Lot_Product__c>();
                            lp1.add(lp);
							system.debug('lp1>>>'+lp1);
                            setOfLotPros.put(lp.Lot__c,lp1);
                        }
                        else{
                            set<Lot_Product__c>lp2=setOfLotPros.get(lp.Lot__c);
                            lp2.add(lp);
							system.debug('lp2>>>'+lp2);
                            setOfLotPros.put(lp.Lot__c,lp2);
                        }
                    }
                    System.debug('setOfLotPros>>'+setOfLotPros);
                    
                    
                    System.debug('ILP::'+ILP);
                    for(Inventory_Location_Product_Line_Item__c ilpli : ilplidata)
                    {
                        
                        
                        Product_Serial_Number__c psn = new Product_Serial_Number__c();
                        psn.Product_Code__c = ILP.Products__c;
                        psn.Inventory_Location_Product__c = ILP.ID;
                        psn.Inventory_Location__c=ILP.Inventory_Location__c;
                        psn.Location__c = ILP.Inventory_Location__r.Location__c;
                        psn.Serial_Number__c = ilpli.ILid__c;
                        if(ilpli.Product_Expiry_Date__c != NULL){
                            psn.Expiry_date__c = ilpli.Product_Expiry_Date__c;
                        }
                        psn.Status__c = 'Available';
                        psn.Lot__c = ilpli.Lot__c;
                        psn.Bin__c=ilpli.Bin__c;
                        psnList.add(psn);
                    }
                    Insert psnList;
                    for(Product_Serial_Number__c psn: psnList){
                        ScPSNmap.put(psn.Serial_Number__c, psn);
                    }
                    
                    Lot_Product__c lotPro =new  Lot_Product__c();
                    Map<id,Decimal> lotproduct=new Map<id,Decimal>();
                    Decimal qty;
                    List<Lot_Product__c> lotlist=new List<Lot_Product__c>();
                    List<Lot_Product__c> lotnewlist=new List<Lot_Product__c>();
                    System.debug('lotproduct>>'+lotproduct); 
                    
                    for(Inventory_Location_Product_Line_Item__c ilpli : ilplidata)
                    {
                        
                        if(ilpli.Lot__c != null && String.valueof(ilpli.Lot__c) != '' &&  ilpli.Adjusted_Quantity__c > 0)
                        {
                            
                            qty=0;
                            if(lotproduct.containsKey(ilpli.Bin__c))
                            {
                                qty=lotproduct.get(ilpli.Bin__c)+1;
								system.debug('qty????'+qty);
                                lotproduct.put(ilpli.Lot__c,qty);
								system.debug('lotproduct????'+lotproduct);
                            }
                            else
                            {
                                lotproduct.put(ilpli.Bin__c,1.0);
								system.debug('lotproduct????'+lotproduct);
                            }
                            
                            
                        }
                    }
                    
                    Map<id,decimal> lotproqty=new Map<id,decimal>();
                    Lot_Product__c lotproNew=new Lot_Product__c();
                    for(Inventory_Location_Product_Line_Item__c ilpli : ilplidata)
                    { 
                        
                        ilpli.Product__c = ILP.Products__c;
                        ilpli.Inventory_Location_Product__c = ILP.ID;  
                        ilpli.Inventory_Location__c=ILP.Inventory_Location__c;   
                        ilpli.Product_Received_Date__c=system.today();
                        ilpli.Product_Serial_Number__c = ScPSNmap.get(ilpli.ILid__c).Id;
                        ilpli.ILid__c = null;
                        ilpli.Reason__c=stockAdjustments.Reason_Code__c;
                        ilpli.Reduced_Adjusted_Quantity__c   = ilpli.bucket_field__c;
                        if(String.valueof(ilpli.Lot__c) != '' && ilpli.Adjusted_Quantity__c > 0)
                        {
                           // if(setOfLotPros.containsKey(ilpli.Lot__c))
                            //{
                            system.debug('setOfLotPros.get(ilpli.Lot__c)>>>>'+setOfLotPros.get(ilpli.Lot__c));
                              if(lotqtyupdate.containsKey(ilpli.Lot__c))
                              {
                                if(lotqtyupdate.get(ilpli.Lot__c).containsKey(ilpli.Bin__c))
                                { 
                                    set<Lot_Product__c>lp3=setOfLotPros.get(ilpli.Lot__c);
                                    system.debug('lp3>>>'+lp3);
                                    boolean isFound=false;
                                    for(Lot_Product__c lp4:lp3)
                                    {
                                        if(lp4.Bin__c==ilpli.Bin__c)
                                        {
                                            lotproNew=lp4;
                                            system.debug('lotproNew>>>'+lotproNew);
                                            isFound=true;
                                            break;
                                        }
                                    }
                                    if(isFound==false)
                                    {
                                        lotproNew.Product__c = ILP.Products__c;
                                        lotproNew.Location__c = ilpli.Inventory_Location__c;
                                        lotproNew.Lot__c = ilpli.Lot__c;
                                        if(lotproNew.Quantity__c==null)
                                        {
                                            lotproNew.Quantity__c = 0;
                                        }
                                        lotproNew.Quantity__c = lotproNew.Quantity__c + lotproduct.get(ilpli.Bin__c);
                                        lotproNew.Bin__c=ilpli.Bin__c;
                                        system.debug('lpListToInsert???'+lpListToInsert);
                                        if(lpListToInsert.contains(lotproNew))
                                        {
                                            if(lpListToInsert.get(lpListToInsert.indexOf(lotproNew)).Bin__c==ilpli.Bin__c)
                                            {
                                                lpListToInsert.set(lpListToInsert.indexOf(lotproNew),lotproNew);  
                                            } 
                                        }
                                        else 
                                            lpListToInsert.add(lotproNew);
                                        System.debug('lotproNew inside if lpListToInsert>>'+lpListToInsert);
                                        
                                    }
                                    else{
                                        lotproNew.Product__c = ILP.Products__c;
                                        lotproNew.Location__c = ilpli.Inventory_Location__c;
                                        lotproNew.Lot__c = ilpli.Lot__c;
                                        if(lotproNew.Quantity__c==null)
                                        {
                                            lotproNew.Quantity__c = 0;
                                        }
                                        lotproNew.Quantity__c = lotproNew.Quantity__c + lotproduct.get(ilpli.Bin__c);
                                        lotproNew.Bin__c=ilpli.Bin__c;
                                        System.debug('lotproNew>>'+lpListToInsert.contains(lotproNew));
                                        if(lpListToInsert.contains(lotproNew))
                                        {
                                            if(lpListToInsert.get(lpListToInsert.indexOf(lotproNew)).Bin__c==ilpli.Bin__c)
                                            {
                                                lpListToInsert.set(lpListToInsert.indexOf(lotproNew),lotproNew);  
                                            }   
                                        }
                                        else 
                                            lpListToInsert.add(lotproNew);
                                        System.debug('lotproNew inside if lpListToInsert>>'+lpListToInsert);
                                    } 
                                } 
                            }
                            else
                            {
                                if(lotqtyupdate.size()==0)
                                {
                                    Lot_Product__c newlotPro=new Lot_Product__c();
                                    newlotPro.Lot__c=ilpli.Lot__c;
                                    newlotPro.Bin__c=ilpli.Bin__c;
                                    newlotPro.Quantity__c=1;
                                    System.debug('newlotPro>>'+newlotPro);
                                    set<Lot_Product__c>lp1=new set<Lot_Product__c>();
                                    lp1.add(newlotPro);
									System.debug('lp1>>'+lp1);
                                    setOfLotPros.put(ilpli.Lot__c,lp1);
                                    lpListToInsert.add(newlotPro);
                                }
                                
                            }
                            System.debug('lpListToInsert>>'+lpListToInsert);
                           
                            System.debug('saplist>>'+saplist);
                            
                        }
                        
                    }
                    insert ilplidata;
                    for(Inventory_Location_Product_Line_Item__c ilpli : ilplidata){
                        Stock_Adjustment_Product__c sap = new Stock_Adjustment_Product__c();
                        
                        sap.ILPLI__c = ilpli.Id;
                        sap.PSN__c = ilpli.Product_Serial_Number__c;
                        sap.Adjusted_Quantity__c = ilpli.Adjusted_Quantity__c;
                        if(ilpli.Lot__c != null && String.valueof(ilpli.Lot__c) != ''){ sap.Lot__c = ilpli.Lot__c; }
                        sap.Product__c = ILP.Products__c;
                        sap.Stock_Adjustment__c = stockAdjustments.Id;
                        saplist.add(sap);
                    }
                    
                    
                    
                    try{
                        System.debug('lpListToInsert>>'+lpListToInsert);
                        insert saplist;
                        if(lpListToInsert.size()>0) {
                            upsert lpListToInsert;
                        }
						System.debug('lpListToInsert????'+lpListToInsert);
                    } catch(Exception e){
                        System.debug('Error while upserting lpList :'+e.getDMLMessage(0));
                    }
                    
                    
                }
                
                else if(stockAdjustments.Adjust_Type__c == 'Reduce Stock' && ILP.Attribute_Type__c == 'SERIALIZED')
                {
                    Map<Id,set<Lot_Product__c>>setOfLotPros=new Map<Id,set<Lot_Product__c>>();
                    System.debug('inside else >>>'+ilplidata);
                    Set<Id>setofBins=new Set<Id>();
                    for(Inventory_Location_Product_Line_Item__c ilpli : ilplidata)
                    { 
                        if(!(lotIDs.contains(ilpli.Lot__c)))
                            lotIDs.add(ilpli.Lot__c);
                        setofBins.add(ilpli.Bin__c);
                    }
                    System.debug('lotIDs  >>>'+lotIDs);
                    System.debug('setofBins  >>>'+setofBins);
                    lpList=[select id,Product__c,Quantity__c,Lot__c,Location__c,Bin__c from Lot_Product__c where Lot__c  =: lotIDs and Bin__c=:setofBins and Quantity__c>0 ];
                    System.debug('lpList  >>>'+lpList);
                    
                    for(Lot_Product__c lp: lpList)
                    { 
                        if(!(setOfLotPros.containsKey(lp.Lot__c)))
                        {
                            set<Lot_Product__c>lp1=new set<Lot_Product__c>();
                            lp1.add(lp);
                            setOfLotPros.put(lp.Lot__c,lp1);
                        }
                        else{
                            set<Lot_Product__c>lp2=setOfLotPros.get(lp.Lot__c);
                            lp2.add(lp);
                            setOfLotPros.put(lp.Lot__c,lp2);
                        }
                    }
                    System.debug('setOfLotPros>>'+setOfLotPros);
                    Map<id,Map<id,Decimal>> lotproduct2=new Map<id,Map<id,Decimal>>();
                    Decimal qty;
                    
                    
                    System.debug('setOfLotPros>>'+setOfLotPros);
                    
                    
                    Lot_Product__c lotPro=new Lot_Product__c ();
                    for(Inventory_Location_Product_Line_Item__c ilpli : ilplidata)
                    {
                        System.debug('ilpli>>'+ilpli);
                        if( ilpli.Product_Serial_Number__c != null)
                        {
                            Product_Serial_Number__c psn = new Product_Serial_Number__c();
                            if(ilpli.bucket_field__c > 0 && ilpli.bucket_field__c != null)
                            {
                                psn.Id = ilpli.Product_Serial_Number__c;
                                psn.Status__c = 'used';
                                psn.Package_Status__c=true;
                                psnList.add(psn);
                            }
                        }
                        if(ilpli.Lot__c != null && String.valueof(ilpli.Lot__c) != '' && ilpli.bucket_field__c > 0)
                        {
                            System.debug('lotproduct2>>'+lotproduct2);
                            qty=0;
                            System.debug('lotproduct2>>'+lotproduct2);
                            if(lotproduct2.containsKey(ilpli.Lot__c))
                            {
                                Map<id,Decimal>mapOfBinIdAndQty2=lotproduct2.get(ilpli.Lot__c);
                                if(mapOfBinIdAndQty2.containsKey(ilpli.Bin__c))
                                {
                                    qty=mapOfBinIdAndQty2.get(ilpli.Bin__c)+ilpli.bucket_field__c;
                                    mapOfBinIdAndQty2.put(ilpli.Bin__c,qty);
                                    lotproduct2.put(ilpli.Lot__c,mapOfBinIdAndQty2);
                                }
                                
                            }
                            else
                            {
                                Map<id,Decimal>mapOfBinIdAndQty=new Map<id,Decimal>();
                                mapOfBinIdAndQty.put(ilpli.Bin__c,ilpli.bucket_field__c);
                                
                                lotproduct2.put(ilpli.Lot__c,mapOfBinIdAndQty);
                            }
                            
                            
                            
                            
                        }
                        System.debug('lotproduct2>>'+lotproduct2);
                    }
                    System.debug('lotproduct2>>'+lotproduct2);
                    System.debug('ilplidata>>'+ilplidata);
                    for(Inventory_Location_Product_Line_Item__c ilpli : ilplidata)
                    {
                        System.debug('ilpli>>'+ilpli);
                        
                        Stock_Adjustment_Product__c sap = new Stock_Adjustment_Product__c();
                        
                        if(ilpli.bucket_field__c > 0 && ilpli.bucket_field__c != null)
                        {
                            
                            sap.Adjusted_Quantity__c = ilpli.bucket_field__c;
                            sap.ILPLI__c = ilpli.Id;
                            sap.Product__c = ilpli.Product__c;
                            sap.Stock_Adjustment__c = stockAdjustments.Id;
                            if(ilpli.Lot__c != null && String.valueof(ilpli.Lot__c) != ''){ sap.Lot__c = ilpli.Lot__c; }
                            if(ilpli.Product_Serial_Number__c != null ){ sap.PSN__c = ilpli.Product_Serial_Number__c; }
                            
                            saplist.add(sap);
                            if(ilpli.Reduced_Adjusted_Quantity__c   ==null)
                            {
                                ilpli.Reduced_Adjusted_Quantity__c  =0;
                            }
                            ilpli.Reduced_Adjusted_Quantity__c   = ilpli.Reduced_Adjusted_Quantity__c    + ilpli.bucket_field__c;
                            ilpli.Recent_Adjusted_Quantity__c = 0 - ilpli.bucket_field__c;
                            
                            ilpli.bucket_field__c = null;
                            ilpli.Reason__c=stockAdjustments.Reason_Code__c;
                            
                            if(ilpli.Lot__c != null && String.valueof(ilpli.Lot__c) != '')
                            {
                                
                                if(setOfLotPros.containsKey(ilpli.Lot__c))
                                {
                                    set<Lot_Product__c>lp2=setOfLotPros.get(ilpli.Lot__c);
                                    
                                    for(Lot_Product__c lp3:lp2)
                                    {
                                        if(lp3.Bin__c==ilpli.Bin__c)
                                        {
                                            lotPro = lp3;
                                            
                                            if(lpListToInsert.contains(lotPro))
                                            {
                                                
                                                lpListToInsert.set(lpListToInsert.indexOf(lotPro),lotPro);
                                            }
                                            else
                                            {
                                                if(lotproduct2.containsKey(ilpli.Lot__c) && lotproduct2.get(ilpli.Lot__c).containsKey(ilpli.Bin__c))
                                                {
                                                    Map<Id,Decimal>map1=lotproduct2.get(ilpli.Lot__c);
                                                    if(map1.containsKey(ilpli.Bin__c))
                                                    {
                                                        lotPro.Quantity__c-=lotproduct2.get(ilpli.Lot__c).get(ilpli.Bin__c);
                                                        lpListToInsert.add(lotPro);
                                                        System.debug('map1>>'+map1);
                                                        System.debug('lpListToInsert>>'+lpListToInsert);
                                                    }
                                                }
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                    
                                    
                                    
                                }
                            }
                            
                        }
                    } 
                    
                    try
                    {
                        
                        update psnList;
                        update ilplidata;
                        insert saplist;
                        
                        if(lpListToInsert.size()>0)
                        {
                            update lpListToInsert;
                        }
                        
                    }catch(Exception e)
                    {
                        System.debug('Error while upserting lpList :'+e.getDMLMessage(0));
                    }             
                    
                }
                
                else if(stockAdjustments.Adjust_Type__c == 'Reduce Stock' && ILP.Attribute_Type__c == 'BULK')
                {
                    Map<Id,set<Lot_Product__c>>setOfLotPros=new Map<Id,set<Lot_Product__c>>();
                    System.debug('inside else >>>'+ilplidata);
                    Set<Id>setofBins=new Set<Id>();
                    for(Inventory_Location_Product_Line_Item__c ilpli : ilplidata)
                    { 
                        if(!(lotIDs.contains(ilpli.Lot__c)))
                            lotIDs.add(ilpli.Lot__c);
                        setofBins.add(ilpli.Bin__c);
                    }
                    System.debug('lotIDs  >>>'+lotIDs);
                    System.debug('setofBins  >>>'+setofBins);
                    lpList=[select id,Product__c,Quantity__c,Lot__c,Location__c,Bin__c from Lot_Product__c where Lot__c  =: lotIDs and Bin__c=:setofBins and Quantity__c>0 ];
                    System.debug('lpList  >>>'+lpList);
                    for(Lot_Product__c lp: lpList)
                    { 
                        if(!(setOfLotPros.containsKey(lp.Lot__c)))
                        {
                            set<Lot_Product__c>lp1=new set<Lot_Product__c>();
                            lp1.add(lp);
                            setOfLotPros.put(lp.Lot__c,lp1);
                        }
                        else{
                            set<Lot_Product__c>lp2=setOfLotPros.get(lp.Lot__c);
                            lp2.add(lp);
                            setOfLotPros.put(lp.Lot__c,lp2);
                        }
                    }
                    
                    
                    System.debug('setOfLotPros>>'+setOfLotPros);
                    Map<id,Map<id,Decimal>> lotproduct2=new Map<id,Map<id,Decimal>>();
                    
                    Map<id,Decimal> lotproduct=new Map<id,Decimal>();
                    Decimal qty;
                    System.debug('ilplidata>>'+ilplidata);
                    for(Inventory_Location_Product_Line_Item__c ilpli : ilplidata)
                    { 
                        System.debug('ilpli>>'+ilpli);
                        System.debug('LotProMap>>'+LotProMap);
                        System.debug('lpListToInsert>>'+lpListToInsert);
                        ilpli.Product__c = ILP.Products__c;
                        ilpli.Inventory_Location_Product__c = ILP.ID; 
                        ilpli.Inventory_Location__c=ILP.Inventory_Location__r.id;                   
                        ilpli.Product_Received_Date__c=system.today();
                        ilpli.ILid__c = null;
                        ilpli.Reason__c=stockAdjustments.Reason_Code__c;
                        
                        
                        if(ilpli.Lot__c != null && String.valueof(ilpli.Lot__c) != '' && ilpli.bucket_field__c > 0)
                        {
                            qty=0;
                            System.debug('lotproduct2>>'+lotproduct2);
                            if(lotproduct2.containsKey(ilpli.Lot__c))
                            {
                                Map<id,Decimal>mapOfBinIdAndQty2=lotproduct2.get(ilpli.Lot__c);
                                System.debug('mapOfBinIdAndQty2>>'+mapOfBinIdAndQty2);
                                if(mapOfBinIdAndQty2.containsKey(ilpli.Bin__c))
                                {
                                    qty=mapOfBinIdAndQty2.get(ilpli.Bin__c)+ilpli.bucket_field__c;
                                    mapOfBinIdAndQty2.put(ilpli.Bin__c,qty);
                                    lotproduct2.put(ilpli.Lot__c,mapOfBinIdAndQty2);
                                }
                                else{
                                    if(ilpli.bucket_field__c!=null)
                                    {
                                        mapOfBinIdAndQty2.put(ilpli.Bin__c,ilpli.bucket_field__c);
                                        lotproduct2.put(ilpli.Lot__c,mapOfBinIdAndQty2);
                                        System.debug('mapOfBinIdAndQty2>>'+mapOfBinIdAndQty2);
                                    }
                                    
                                }
                                
                            }
                            else
                            {
                                Map<id,Decimal>mapOfBinIdAndQty=new Map<id,Decimal>();
                                mapOfBinIdAndQty.put(ilpli.Bin__c,ilpli.bucket_field__c);
                                
                                lotproduct2.put(ilpli.Lot__c,mapOfBinIdAndQty);
                            }
                            
                            
                            
                        }
                    }
                    System.debug('lotproduct>>'+lotproduct);
                    System.debug('lotproduct2>>'+lotproduct2);
                    Lot_Product__c lotPro=new Lot_Product__c();
                    for(Inventory_Location_Product_Line_Item__c ilpli : ilplidata)
                    {
                        System.debug('ilpli>>'+ilpli);
                        Stock_Adjustment_Product__c sap = new Stock_Adjustment_Product__c();
                        if(ilpli.bucket_field__c > 0 && ilpli.bucket_field__c != null)
                        {
                            sap.Adjusted_Quantity__c = ilpli.bucket_field__c;
                            sap.ILPLI__c = ilpli.Id;
                            sap.Product__c = ilpli.Product__c;
                            sap.Stock_Adjustment__c = stockAdjustments.Id;
                            if(ilpli.Lot__c != null && String.valueof(ilpli.Lot__c) != ''){ sap.Lot__c = ilpli.Lot__c; }
                            if(ilpli.Product_Serial_Number__c != null ){ sap.PSN__c = ilpli.Product_Serial_Number__c; }
                            saplist.add(sap);
                            
                            if( ilpli.Product_Serial_Number__c != null)
                            {
                                Product_Serial_Number__c psn = new Product_Serial_Number__c();
                                
                                psn.Id = ilpli.Product_Serial_Number__c;
                                psn.Status__c = 'used';
                                psn.Package_Status__c=true;
                                psnList.add(psn);
                            }
                            if(ilpli.Reduced_Adjusted_Quantity__c    ==null)
                            {
                                ilpli.Reduced_Adjusted_Quantity__c   =0;
                            }
                            ilpli.Reduced_Adjusted_Quantity__c   = ilpli.Reduced_Adjusted_Quantity__c    + ilpli.bucket_field__c;
                            ilpli.Recent_Adjusted_Quantity__c = 0 - ilpli.bucket_field__c;
                            
                            ilpli.Reason__c=stockAdjustments.Reason_Code__c;
                            if(ilpli.Lot__c != null &&String.valueof(ilpli.Lot__c) != '' )
                            {
                                
                                if(setOfLotPros.containsKey(ilpli.Lot__c))
                                {
                                    set<Lot_Product__c>lp2=setOfLotPros.get(ilpli.Lot__c);
                                    
                                    for(Lot_Product__c lp3:lp2)
                                    {
                                        if(lp3.Bin__c==ilpli.Bin__c)
                                        {
                                            lotPro = lp3;
                                            System.debug('lotproduct2>>'+lotproduct2);
                                            
                                            if(lpListToInsert.contains(lotPro))
                                            {
                                                
                                                lpListToInsert.set(lpListToInsert.indexOf(lotPro),lotPro);
                                            }
                                            else
                                            {
                                                
                                                if(lotproduct2.containsKey(ilpli.Lot__c) && lotproduct2.get(ilpli.Lot__c).containsKey(ilpli.Bin__c))
                                                {
                                                    Map<Id,Decimal>map1=lotproduct2.get(ilpli.Lot__c);
                                                    if(map1.containsKey(ilpli.Bin__c))
                                                    {
                                                        lotPro.Quantity__c-=lotproduct2.get(ilpli.Lot__c).get(ilpli.Bin__c);
                                                        lotproduct.get(ilpli.Bin__c);
                                                        lpListToInsert.add(lotPro);
                                                        System.debug('lpListToInsert>>'+lpListToInsert);
                                                    }
                                                    
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                    
                                    
                                    
                                }
                                
                            }
                            ilpli.bucket_field__c = null;
                        }
                        
                    }      
                    System.debug('lpListToInsert>>'+lpListToInsert);
                    try{
                        update psnList;
                        update ilplidata;
                        insert saplist;
                        if(lpListToInsert.size()>0)
                        {
                            update lpListToInsert;
                        }
                    }catch(Exception e)
                    {
                        System.debug('Error while upserting lpList :'+e.getDMLMessage(0));
                    }
                } 
                
                
                
                
                
                else if(stockAdjustments.Adjust_Type__c == 'Increase Stock' && ILP.Attribute_Type__c == 'BULK')
                {
                    
                    Map<Id,set<Lot_Product__c>>setOfLotPros=new Map<Id,set<Lot_Product__c>>();
                    System.debug('inside else >>>'+ilplidata);
                    Set<Id>setofBins=new Set<Id>();
                    for(Inventory_Location_Product_Line_Item__c ilpli : ilplidata)
                    { 
                        if(!(lotIDs.contains(ilpli.Lot__c)))
                            lotIDs.add(ilpli.Lot__c);
                        setofBins.add(ilpli.Bin__c);
                    }
                    
                    lpList=[select id,Product__c,Quantity__c,Lot__c,Location__c,Bin__c from Lot_Product__c where Lot__c  =: lotIDs and Bin__c=:setofBins and Quantity__c>=0 ];
                    System.debug('lpList  >>>'+lpList);
                    for(Lot_Product__c lp: lpList)
                    { 
                        if(!(setOfLotPros.containsKey(lp.Lot__c)))
                        {
                            set<Lot_Product__c>lp1=new set<Lot_Product__c>();
                            lp1.add(lp);
                            setOfLotPros.put(lp.Lot__c,lp1);
                        }
                        else{
                            set<Lot_Product__c>lp2=setOfLotPros.get(lp.Lot__c);
                            lp2.add(lp);
                            setOfLotPros.put(lp.Lot__c,lp2);
                        }
                    }
                    
                    
                    System.debug('setOfLotPros>>'+setOfLotPros);
                    
                    Map<id,Decimal> lotproduct=new Map<id,Decimal>();
                    Decimal qty;
                    Lot_Product__c lotproNew =new  Lot_Product__c();
                    System.debug('ilplidata>>'+ilplidata);
                    for(Inventory_Location_Product_Line_Item__c ilpli : ilplidata)
                    { 
                        
                        ilpli.Product__c = ILP.Products__c;
                        ilpli.Inventory_Location_Product__c = ILP.ID; 
                        ilpli.Inventory_Location__c=ILP.Inventory_Location__r.id;                   
                        ilpli.Product_Received_Date__c=system.today();
                        ilpli.ILid__c = null;
                        ilpli.Reason__c=stockAdjustments.Reason_Code__c;
                        
                        
                        if(ilpli.Bin__c != null && String.valueof(ilpli.Bin__c) != '' && ilpli.Adjusted_Quantity__c > 0)
                        {
                            qty=0;
                            if(lotproduct.containsKey(ilpli.Bin__c))
                            {
                                qty=lotproduct.get(ilpli.Bin__c)+ilpli.Adjusted_Quantity__c;
                                lotproduct.put(ilpli.Lot__c,qty);
                            }
                            else
                            {
                                
                                lotproduct.put(ilpli.Bin__c,ilpli.Adjusted_Quantity__c);
                            }
                            
                            
                            
                        }
                    }
                    for(Inventory_Location_Product_Line_Item__c ilpli : ilplidata)
                    { 
                        
                        if(setOfLotPros.containsKey(ilpli.Lot__c))
                        {
                            
                            set<Lot_Product__c>lp3=setOfLotPros.get(ilpli.Lot__c);
                            boolean isFound=false;
                            for(Lot_Product__c lp4:lp3)
                            {
                                if(lp4.Bin__c==ilpli.Bin__c)
                                {
                                    lotproNew=lp4;
                                    
                                    isFound=true;
                                    break;
                                }
                            }
                            if(isFound==false)
                            {
                                lotproNew.Product__c = ILP.Products__c;
                                lotproNew.Location__c = ilpli.Inventory_Location__c;
                                lotproNew.Lot__c = ilpli.Lot__c;
                                if(lotproNew.Quantity__c==null)
                                {
                                    lotproNew.Quantity__c = 0;
                                }
                                lotproNew.Quantity__c = lotproNew.Quantity__c + lotproduct.get(ilpli.Bin__c);
                                lotproNew.Bin__c=ilpli.Bin__c;
                                if(lpListToInsert.contains(lotproNew))
                                {
                                    if(lpListToInsert.get(lpListToInsert.indexOf(lotproNew)).Bin__c==ilpli.Bin__c)
                                    {
                                        lpListToInsert.set(lpListToInsert.indexOf(lotproNew),lotproNew);  
                                    } 
                                }
                                else 
                                    lpListToInsert.add(lotproNew);
                                System.debug('lotproNew inside if>>'+lotproNew);
                                
                            }
                            else{
                                lotproNew.Product__c = ILP.Products__c;
                                lotproNew.Location__c = ilpli.Inventory_Location__c;
                                lotproNew.Lot__c = ilpli.Lot__c;
                                if(lotproNew.Quantity__c==null)
                                {
                                    lotproNew.Quantity__c = 0;
                                }
                                lotproNew.Quantity__c = lotproNew.Quantity__c + lotproduct.get(ilpli.Bin__c);
                                lotproNew.Bin__c=ilpli.Bin__c;
                                if(lpListToInsert.contains(lotproNew))
                                {
                                    if(lpListToInsert.get(lpListToInsert.indexOf(lotproNew)).Bin__c==ilpli.Bin__c)
                                    {
                                        lpListToInsert.set(lpListToInsert.indexOf(lotproNew),lotproNew);  
                                    }   
                                }
                                else 
                                    lpListToInsert.add(lotproNew);
                                System.debug('lotproNew>>'+lotproNew);
                            } 
                        }
                        else
                        {
                            if(setOfLotPros.size()==0)
                            {
                                Lot_Product__c newlotPro=new Lot_Product__c();
                                newlotPro.Lot__c=ilpli.Lot__c;
                                newlotPro.Bin__c=ilpli.Bin__c;
                                newlotPro.Quantity__c=lotproduct.get(ilpli.Bin__c);//ilpli.bucket_field__c;
                                newlotPro.Product__c = ILP.Products__c;
                                newlotPro.Location__c = ilpli.Inventory_Location__c;
                                newlotPro.Lot__c = ilpli.Lot__c;
                                set<Lot_Product__c>lp1=new set<Lot_Product__c>();
                                lp1.add(newlotPro);
                                setOfLotPros.put(ilpli.Lot__c,lp1);
                                lpListToInsert.add(newlotPro);
                            }
                            
                        }
                        
                    }
                    
                    insert ilplidata;
                    for(Inventory_Location_Product_Line_Item__c ilpli : ilplidata)
                    {
                        Stock_Adjustment_Product__c sap = new Stock_Adjustment_Product__c();
                        
                        sap.ILPLI__c = ilpli.Id;
                        sap.Adjusted_Quantity__c = ilpli.Adjusted_Quantity__c;
                        if(ilpli.Lot__c != null && String.valueof(ilpli.Lot__c) != ''){ sap.Lot__c = ilpli.Lot__c; }
                        sap.Product__c = ILP.Products__c;
                        sap.Stock_Adjustment__c = stockAdjustments.Id;
                        saplist.add(sap);
                    }
                    Map<Id,Map<Id,List<Lot_Product__c>>> lotAndBinIds1=new Map<Id,Map<Id,List<Lot_Product__c>>>();//lotid,binid
                    System.debug('lotAndBinIds1>>'+lotAndBinIds1);
                    for(Inventory_Location_Product_Line_Item__c ilpli : ilplidata)
                    { 
                        System.debug('ilpli>>'+ilpli);
                        System.debug('lotAndBinIds1>>'+lotAndBinIds1);
                        for(Lot_Product__c lp: lpList)
                        {
                            System.debug('lp>>'+lp);
                            if(lotAndBinIds1.containsKey(ilpli.id))
                            {
                                lotAndBinIds1.get(ilpli.id).get(lp.Lot__c).add(lp);
                            }
                            else{
                                Map<Id,List<Lot_Product__c>>map2=new Map<Id,List<Lot_Product__c>>();
                                List<Lot_Product__c>lp2=new List<Lot_Product__c>();
                                lp2.add(lp);
                                map2.put(lp.Lot__c,lp2);
                                lotAndBinIds1.put(ilpli.id,map2);
                            }
                            
                        }
                        
                    }
                    System.debug('lotAndBinIds1>>'+lotAndBinIds1);
                    
                    try{
                        insert saplist;
                        if(lpListToInsert.size()>0) 
                        {
                            upsert lpListToInsert;
                        }
                    } catch(Exception e)
                    {
                        System.debug('Error while upserting lpList :'+e.getDMLMessage(0));
                    }
                    
                }
                
                
                
                List<Inventory_Location_Product_Line_Item__c>ILPLIForcalculateAvgUnitPrice=[select Unit_Price__c from Inventory_Location_Product_Line_Item__c where Product__c=: ILP.Products__c and Available_Quantity__c>0];
                System.debug('ILPLIForcalculateAvgUnitPrice>>'+ILPLIForcalculateAvgUnitPrice);
                Double avgUnitPrice=0;Double totalUnitPrice=0;
                Integer count=ILPLIForcalculateAvgUnitPrice.size();
                System.debug('count>>'+count);
                for(Inventory_Location_Product_Line_Item__c ilpli : ILPLIForcalculateAvgUnitPrice)
                {
                    System.debug('ilpli>>'+ilpli);
                    if(ilpli.Unit_Price__c!=null)
                        totalUnitPrice+=ilpli.Unit_Price__c;
                }
                if(count>0)
                {
                    avgUnitPrice=Double.valueof(totalUnitPrice/count);
                }
                System.debug('avgUnitPrice>>'+avgUnitPrice);
                if(avgUnitPrice>=0)
                {
                    
                    Inventory__c PI2 = [select Id,Name,Avg_Buying_Price__c,Available_Qty__c,Total_Available_Qty__c from Inventory__c where ProductCode__c =: ILP.Products__c limit 1];
                    PI2.Avg_Buying_Price__c=avgUnitPrice;
                    System.debug('PI2>>'+PI2);
                    update PI2;
                }
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
                
                
            }
            
            //code to handle autoallocation when inventory available 02-04 -added by Harish  
            try{
                if(stockAdjustments.Adjust_Type__c == 'Increase Stock')
                {
                    Map<Id,decimal>Productquant = new Map<Id,decimal>();  
                    Productquant.put(ILP.Products__c,stockAdjustments.Quantity__c); 
                    system.debug('Productquant@@@'+Productquant);         
                    if(Productquant.size()>0)
                    {
                        
                        string flag='SR';
                        BackOrderMailService.notifyBackOrderStockAvailable(Productquant,flag);
                    }
                }
                
            }
            catch(Exception e){
                System.debug('An exception occurred: ' + e.getMessage());
            }
            
            //code end 
            }catch(Exception e)
            {
                   String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                    System.debug('  Stock Adjustments ex>>'+ex);                   
                   createErrorLog.insertError('Stock Adjustments',ex,'Method -saveStockAdjustment ',null,'',e.getStackTraceString(),UserInfo.getUserId());
            }
            
            
            
       // } 
        
        
    }
    
    //code added by anuja
    
    @AuraEnabled
    public static List<Inventory_Location_Product_Line_Item__c> fetchILPLI(string invLocPrdId)
    {
        List<Inventory_Location_Product_Line_Item__c> stAdj;
        
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'Id','sigmaerpdev2__Reduced_Adjusted_Quantity__c','sigmaerpdev2__Unit_Price__c', 'Name','sigmaerpdev2__Product_Received_Date__c','sigmaerpdev2__Inventory_Location_Product__c', 'sigmaerpdev2__Lot__c', 'sigmaerpdev2__Lot__r.Name', 'sigmaerpdev2__Serial_Name__c', 'sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Received_Quantity1__c', 'sigmaerpdev2__Used_Quantity__c', 'sigmaerpdev2__Product__c', 'sigmaerpdev2__Product_Expiry_Date__c', 'sigmaerpdev2__Expiry_Date__c', 'sigmaerpdev2__Product__r.sigmaerpdev2__Attribute_Type__c', 'sigmaerpdev2__Product_Serial_Number__c', 'sigmaerpdev2__Product_Serial_Number__r.Name', 'sigmaerpdev2__bucket_field__c', 'sigmaerpdev2__Adjusted_Quantity__c','sigmaerpdev2__Product_Serial_Number__r.sigmaerpdev2__Serial_Number__c','sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__r.Name','sigmaerpdev2__Bin__r.Name','sigmaerpdev2__Available_Quantity__c'}))
        {*/
        try{
            
            stAdj = new List<Inventory_Location_Product_Line_Item__c>(); 
            
            if(invLocPrdId != null)
            {
                stAdj = [SELECT Id,Reduced_Adjusted_Quantity__c,Product_Serial_Number__r.Serial_Number__c,Unit_Price__c, Name,Product_Received_Date__c,Inventory_Location_Product__c, Lot__c, Lot__r.Name, Serial_Name__c, Available_Quantity__c,Received_Quantity__c,Received_Quantity1__c, Used_Quantity__c, Product__c, Product_Expiry_Date__c, Expiry_Date__c, Product__r.Attribute_Type__c, Product_Serial_Number__c, Product_Serial_Number__r.Name, bucket_field__c, Adjusted_Quantity__c,Inventory_Location__r.Location__r.Name,Bin__r.Name FROM Inventory_Location_Product_Line_Item__c WHERE Inventory_Location_Product__c = :invLocPrdId AND Available_Quantity__c > 0];
                
            }
            }catch(Exception e)
                {
                    String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                    createErrorLog.insertError('Stock Adjustments',ex,'Method -fetchILPLI ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                    System.debug('ex>>>>>>'+ex);
                    System.debug('e'+e);
                }
        //}
        return stAdj; 
    }
    
    @AuraEnabled 
    public static List<Product_Serial_Number__c> checkDuplicateProductPSN(String validatePSN,String ProductID)
    {
        List<Product_Serial_Number__c> prodSerialNumberList;
        
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Serial_Number__c')
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Serial_Number__c',new Set<String>{'Id','Name','sigmaerpdev2__Serial_Number__c','sigmaerpdev2__Product_Code__c' })
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'sigmaerpdev2__ILid__c'})
          )
        {*/
            try{
            /*Object[] psnvalues = (Object[])System.JSON.deserializeUntyped(validatePSN);
            List<String> psnlist=new List<String>();
            
            for(Object obj:psnvalues)
            {
                String str = JSON.serialize(obj);
                Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(str);
                
                psnlist.add(String.ValueOF(root.get('ILid__c')));
            }*/
                List<String> lstString = (List<String>)System.JSON.deserialize(validatePSN, List<String>.class);
            system.debug('lstString=='+lstString);
                 prodSerialNumberList=[Select Id,Name,Serial_Number__c from Product_Serial_Number__c
                                  where Serial_Number__c IN:lstString /*and Product_Code__c=:ProductID*/];
            system.debug('prodSerialNumberList=='+prodSerialNumberList);
            
            
            /*prodSerialNumberList=[Select Id,Name,Serial_Number__c from Product_Serial_Number__c
                                  where Serial_Number__c IN:psnlist and Product_Code__c=:ProductID];*/
            }catch(Exception e)
                {
                    String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                    //createErrorLog.insertError('Stock Adjustments',ex,'Method -checkDuplicateProductPSN ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                    System.debug('ex>>>>>>'+ex);
                    System.debug('e'+e);
                }
            
        //}
        return prodSerialNumberList;
    } 
    @AuraEnabled
    public static List<object> fetchJSONHelpMenu()
    {  
        List<Object> trails=null;
        try{
        StaticResource sr= [select id, body from StaticResource Where Name = 'JsonStockManagementMM'];
        string allContent = sr.body.toString();
        Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(allContent);
         trails= (List<Object>) results.get('Menu');
         }catch(Exception e)
                {
                    String ex=e.getTypeName()+'::'+e.getCause()+'::'+e.getLineNumber()+'::'+e.getMessage()+'::'+e.getStackTraceString();
                    createErrorLog.insertError('Stock Adjustments',ex,'Method -fetchJSONHelpMenu ',null,'',e.getStackTraceString(),UserInfo.getUserId());
                    System.debug('ex>>>>>>'+ex);
                    System.debug('e'+e);
                }
        
        return trails; 
    }   
        
}