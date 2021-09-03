public class ManufacturingRun
{
     @auraenabled
    public static manWrap fetchManufacturingRun(Integer limits , Integer offsets)
    {
        List<Manufacturing_Run__c> manfList;
        integer rowscount;
        boolean allocStock; 
        try{
            if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run__c') 
            //&& CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Allocate_Stock_MR__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run__c',new set<String>{'Id','sigmaerpdev2__Manufacturing_Name__c','sigmaerpdev2__Expiry_date_of_Batch__c','sigmaerpdev2__Batch_Number__c','sigmaerpdev2__PI_updated__c','sigmaerpdev2__Recipe__r.Name','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Required_Quantity__c','sigmaerpdev2__Produced_Quantity__c','sigmaerpdev2__Status__c','sigmaerpdev2__Run_Date__c','sigmaerpdev2__End_Date__c','createddate'})
           // && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Allocate_Stock_MR__c',new set<String>{'sigmaerpdev2__Auto_Allocate__c'})
            )
            {
                Integer intlimits = integer.valueof(limits);
                Integer intoffsets = integer.valueof(offsets);
                manfList = [select Id,sigmaerpdev2__manufactuting_Run_Plant_name__r.Name,sigmaerpdev2__Production_Manager__r.Name,Manufacturing_Name__c,Expiry_date_of_Batch__c,Batch_Number__c,PI_updated__c,Recipe__r.Name,Product__c,Product__r.Name,Required_Quantity__c,Produced_Quantity__c,Status__c,Run_Date__c,End_Date__c from Manufacturing_Run__c order by createddate desc Limit :intlimits Offset :intoffsets];
                List<AggregateResult> result = [SELECT COUNT(Id) total FROM Manufacturing_Run__c];
                rowscount = (Integer)result[0].get('total');
                Allocate_Stock_MR__c allocStockObj = [Select Auto_Allocate__c FROM Allocate_Stock_MR__c where Name  = 'Allocate_Stock'];      
                allocStock = allocStockObj.Auto_Allocate__c;
            }
            return new manWrap(manfList,rowscount,allocStock);
        }catch(Exception ex){           
            createErrorLog.insertError('ManufacturingRun',ex.getMessage(),'Method - fetchManufacturingRun',null,'',ex.getStackTraceString(),UserInfo.getUserId());
            return null;
        } 
    }
    @AuraEnabled
    public static Default_Parameters__c getGanttURL()
    {
        Default_Parameters__c fetchdefaulturl;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Default_Parameters__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Default_Parameters__c',new Set<String>{'sigmaerpdev2__GanttURL__c'}))
        {
        fetchdefaulturl= [select GanttURL__c from Default_Parameters__c Limit 1];
        }
        return fetchdefaulturl;
    }
    public class manWrap
    {
        @auraenabled
        public List<Manufacturing_Run__c> manfList{get;set;}
        @auraenabled
        public integer totalRows{get;set;}
        @auraenabled
        public boolean autoAllocate{get;set;}
        
        public manWrap(List<Manufacturing_Run__c> manfList, integer totalRows, boolean autoAllocate)        
        {
            this.manfList = manfList;
            this.totalRows = totalRows;
            this.autoAllocate = autoAllocate;
        }
    }
    
    public class productInfo
    {
        @auraenabled
        public product2 product;
        @auraenabled
        public decimal NonStockPrice;
        @auraenabled
        public Boolean isStockAvailable;
    }    
    
   @auraEnabled
    Public static productInfo getProductDetails(String prodID,String recipID)
    {
        productInfo pw=new productInfo();
        try{
            //if(CRUD_FLS_CheckUtility.checkObjCRUD('Product2') 
            //&& CRUD_FLS_CheckUtility.checkObjCRUD('PricebookEntry')
            //&& CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'Id', 'Name', 'sigmaerpdev2__Stock_Item__c','sigmaerpdev2__Product_UOM__c'})
           // && CRUD_FLS_CheckUtility.checkReadPermission('PricebookEntry',new set<String>{'UnitPrice','PriceBook2.Name','Product2.Id'})
            //)
            {
                Product2 prd = [SELECT Id, Name, Stock_Item__c,Product_UOM__c FROM Product2 where Id=:prodID];                    
                
                if(prd.Stock_Item__c==false){
                    pw.NonStockPrice=0;
                    List<PricebookEntry> pbe =[Select UnitPrice From PricebookEntry WHERE PriceBook2.Name = 'Standard Price Book' and Product2.Id = :prodID limit 1];                
                    if(pbe.size() > 0){                    
                        if(pbe[0].UnitPrice!=null)
                          pw.NonStockPrice=pbe[0].UnitPrice;              
                    }
                }  
                            
                pw.product=prd;
            }
            return pw;
        }
        catch(Exception ex)
        {            
            createErrorLog.insertError('ManufacturingRun',ex.getMessage(),'Error in class RecipeManagement and getProductDetails method',null,'',ex.getStackTraceString(),UserInfo.getUserId());
            return null;
        } 
    }
    
    @auraenabled
    public static ManufacturingWrap calculateMan(Id recipeID,Decimal selectedQuantity, String manfId)   
    {
            ManufacturingWrap manFacWrap = new ManufacturingWrap();
            manFacWrap.productCompList = new List<productComp>();
            manFacWrap.packagingMatList = new List<packagingMaterial>();
            manFacWrap.AdditionalProductList = new List<AdditionalProduct>();
        try{
           if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run__c')  
            &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
            &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Recipe_Details__c')
            &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Products__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
            
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new set<String>{'id','sigmaerpdev2__ProductCode__c','sigmaerpdev2__Avg_Buying_Price__c'})
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Recipe_Details__c',new set<String>{'id','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.Name','recordType.Name','sigmaerpdev2__Cost__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Recipe__c','sigmaerpdev2__Unit_of_Measure__c','sigmaerpdev2__Product__r.sigmaerpdev2__Stock_Item__c'})            
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Products__c',new set<String>{'Id', 'Name','sigmaerpdev2__Cost__c','sigmaerpdev2__Modified_Quantity__c','sigmaerpdev2__Product__r.Name','RecordType.Name', 'sigmaerpdev2__Manufacturing_Run__c','sigmaerpdev2__Product__c','sigmaerpdev2__Unit_of_measure__c', 'sigmaerpdev2__Quantity__c', 'sigmaerpdev2__Description__c', 'sigmaerpdev2__Procedure_Name__c', 'sigmaerpdev2__Stock_Item__c'})         
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Recipe_Details__c',new set<String>{'sigmaerpdev2__Cost__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'Id','sigmaerpdev2__Average_Buying_Price__c'})
            )
            {
            
                Set<Id> prodIdPackList = new Set<Id>();
                Set<Id> prodIdAddProdList = new Set<Id>();
                
                //Map<Id, Map<String,Decimal>> recTypeProdUnitPriceMap = new Map<Id, Map<String,Decimal>>();
                Set<Id> recTypeProdUnitPriceSet = new Set<Id>();
                
                manFacWrap.manfRun = new Manufacturing_Run__c(); 
                
                Map<Id,Decimal> prodUnitCost = new Map<Id,Decimal>();
                Map<Id,Decimal> newAvgBuyingPriceCost = new Map<Id,Decimal>();
                List<Inventory__c> prodInvPriceList = new List<Inventory__c>();
                
                List<Product2> prodInvPriceListNew = new List<Product2>();
                
                //new flow added on 29-8-2019 to get the latest Avg.Buying Price from PI and update the Recipe Details Cost with the latest avg.buying price
                List<Recipe_Details__c> recpDetList = [select id,Product__c,recordType.Name,Cost__c,Quantity__c from Recipe_Details__c where Recipe__c = :recipeID and (recordType.Name = 'Product Components' or recordType.Name = 'Package Materials')];
                for(Recipe_Details__c recpDetObj : recpDetList){                
                    prodUnitCost.put(recpDetObj.Product__c, recpDetObj.Cost__c);
                }
                if(prodUnitCost.size() > 0){
                    //commented below line on 10/4/2020 - changed to getting Avg. buying price from product2 instead of PI object
                    //prodInvPriceList = [select id,ProductCode__c,Avg_Buying_Price__c from Inventory__c where ProductCode__c In : prodUnitCost.keySet() and Avg_Buying_Price__c != null];
                    prodInvPriceListNew = [select Id,Average_Buying_Price__c from Product2 where Id In : prodUnitCost.keySet() and Average_Buying_Price__c != null];
                }
                
                /*if(prodInvPriceList.size() > 0){
                    for(Inventory__c piObj : prodInvPriceList){
                        newAvgBuyingPriceCost.put(piObj.ProductCode__c, piObj.Avg_Buying_Price__c);
                    }               
                }*/
                if(prodInvPriceListNew.size() > 0){
                    for(Product2 prdObj : prodInvPriceListNew){
                        newAvgBuyingPriceCost.put(prdObj.Id, prdObj.Average_Buying_Price__c);
                    }               
                }
                
                
                for(Recipe_Details__c detObj : recpDetList){
                    if(newAvgBuyingPriceCost.containsKey(detObj.Product__c)){
                        Decimal unitPrice = newAvgBuyingPriceCost.get(detObj.Product__c);
                        if(detObj.Cost__c != unitPrice){
                            detObj.Cost__c = detObj.Quantity__c * unitPrice;
                        }
                    }
                }
                update recpDetList;
                //ends here
                
                for(Recipe_Details__c rp:[select id,recordType.Name,Product__c,Cost__c,Product__r.Name,Unit_of_Measure__c,Quantity__c,Product__r.Stock_Item__c from Recipe_Details__c where Recipe__c = :recipeID])
                {                
                    if(rp.recordType.Name == 'Product Components')
                    {
                        productComp pc = new productComp();
                        pc.ProdName = rp.Product__r.Name;
                        pc.ProdID = rp.Product__c;
                        pc.UnityOfMeasure = rp.Unit_of_Measure__c;
                        pc.Quantity = rp.Quantity__c * selectedQuantity;
                        pc.ModifiedQuantity = rp.Quantity__c * selectedQuantity;                    
                        pc.StockItem = rp.Product__r.Stock_Item__c;
                                            
                        if(rp.Cost__c != null){                        
                            pc.UnitPrice = (rp.Cost__c * selectedQuantity).setScale(2);
                        }else{                      
                            recTypeProdUnitPriceSet.add(rp.Product__c);
                        }                                            
                        manFacWrap.productCompList.add(pc);
                    }
                    else if(rp.recordType.Name == 'Package Materials')
                    {
                        packagingMaterial pm = new packagingMaterial();
                        pm.ProdName = rp.Product__r.Name;
                        pm.ProdID = rp.Product__c;
                        pm.UnityOfMeasure = rp.Unit_of_Measure__c;
                        pm.Quantity = rp.Quantity__c * selectedQuantity;                                                                              
                        pm.ModifiedQuantity = rp.Quantity__c * selectedQuantity;                    
                        pm.StockItem = rp.Product__r.Stock_Item__c;
                                            
                        if(rp.Cost__c != null){                       
                           pm.UnitPrice = (rp.Cost__c * selectedQuantity).setScale(2);
                        }else{                      
                            recTypeProdUnitPriceSet.add(rp.Product__c);
                        }    
                        manFacWrap.packagingMatList.add(pm);
                    }
                    else if(rp.recordType.Name == 'Additional Products')
                    {
                        AdditionalProduct ap = new AdditionalProduct();
                        ap.ProdName = rp.Product__r.Name;
                        ap.ProdID = rp.Product__c;
                        ap.UnityOfMeasure = rp.Unit_of_Measure__c;
                        ap.Quantity = rp.Quantity__c * selectedQuantity;                                                                                
                        ap.ModifiedQuantity = rp.Quantity__c * selectedQuantity;                                  
                        ap.StockItem = rp.Product__r.Stock_Item__c;                    
                        
                        if(rp.Cost__c != null){                       
                           ap.UnitPrice = (rp.Cost__c * selectedQuantity).setScale(2);
                        }
                        manFacWrap.AdditionalProductList.add(ap);   
                    }                
                } 

                //added to fix the issue when product is added into the recipe before stock receiving
                if(recTypeProdUnitPriceSet.size() > 0){
                    Map<Id, Decimal> prodUnitPriceValMap = new Map<Id, Decimal>();
                    List<Inventory__c> piObjList = new List<Inventory__c>();
                    
                    List<Product2> piObjListNew = new List<Product2>();
                    
                    /*piObjList=[select ProductCode__c, Avg_Buying_Price__c from Inventory__c where ProductCode__c in :recTypeProdUnitPriceSet];
                    for(Inventory__c objPI : piObjList){
                        if(objPI.Avg_Buying_Price__c == null)
                            prodUnitPriceValMap.put(objPI.ProductCode__c, 0.00);
                        else
                            prodUnitPriceValMap.put(objPI.ProductCode__c, objPI.Avg_Buying_Price__c);
                    }*/
                    
                    piObjListNew = [select Id,Average_Buying_Price__c from Product2 where Id in :recTypeProdUnitPriceSet];
                    for(Product2 objPI : piObjListNew){
                        if(objPI.Average_Buying_Price__c == null)
                            prodUnitPriceValMap.put(objPI.Id, 0.00);
                        else
                            prodUnitPriceValMap.put(objPI.Id, objPI.Average_Buying_Price__c);
                    }
                    
                                    
                    for(productComp pcomObj : manFacWrap.productCompList){
                        if(pcomObj.UnitPrice == null){                  
                            pcomObj.UnitPrice = (prodUnitPriceValMap.get(pcomObj.ProdID)) * selectedQuantity;
                        }
                    }
                    
                    for(packagingMaterial pMatObj : manFacWrap.packagingMatList){
                        if(pMatObj.UnitPrice == null){                  
                            pMatObj.UnitPrice = (prodUnitPriceValMap.get(pMatObj.ProdID)) * selectedQuantity;
                        }
                    }
                }           
                //ends here         
                
                if(manfId != '' && manfId != null){
                    List<Manufacturing_Products__c> manfProdList = [SELECT Id, Name,Cost__c,Modified_Quantity__c,Product__r.Name,RecordType.Name, Manufacturing_Run__c, Product__c, Unit_of_measure__c, Quantity__c, Description__c, Procedure_Name__c, Stock_Item__c FROM Manufacturing_Products__c where Manufacturing_Run__c = :manfId];
                    if(manfProdList.size() > 0){
                        for(packagingMaterial pmObj : manFacWrap.packagingMatList){
                            prodIdPackList.add(pmObj.ProdID);
                        }                   
                        for(AdditionalProduct addObj : manFacWrap.AdditionalProductList){
                            prodIdAddProdList.add(addObj.ProdID);
                        }                   
                        for(Manufacturing_Products__c mp : manfProdList){
                            if(mp.RecordType.Name == 'Packaging Materials' && prodIdPackList.contains(mp.Product__c) == false){                         
                                packagingMaterial pm = new packagingMaterial();
                                pm.ProdName = mp.Product__r.Name;
                                pm.ProdID = mp.Product__c;
                                pm.UnityOfMeasure = mp.Unit_of_measure__c;
                                pm.Quantity = mp.Quantity__c;
                                pm.UnitPrice = mp.Cost__c;                          
                                pm.ManufactureProdID = mp.Id;
                                pm.ModifiedQuantity = mp.Modified_Quantity__c;
                                pm.ModifiedUnitPrice = mp.Cost__c;
                                pm.StockItem = mp.Stock_Item__c;
                                manFacWrap.packagingMatList.add(pm);
                            }else if(mp.RecordType.Name == 'Additional Products' && prodIdAddProdList.contains(mp.Product__c) == false){                            
                                AdditionalProduct ap = new AdditionalProduct();
                                ap.ProdName = mp.Product__r.Name;
                                ap.ProdID = mp.Product__c;
                                ap.UnityOfMeasure = mp.Unit_of_measure__c;
                                ap.Quantity = mp.Quantity__c;
                                ap.UnitPrice = mp.Cost__c;
                                ap.ManufactureProdID = mp.Id;
                                ap.ModifiedQuantity = mp.Modified_Quantity__c;
                                ap.ModifiedUnitPrice = mp.Cost__c;
                                ap.StockItem = mp.Stock_Item__c;
                                manFacWrap.AdditionalProductList.add(ap);
                            }
                        }                   
                    }               
                }
            }
            return manFacWrap; 
        }catch(Exception ex){           
            createErrorLog.insertError('ManufacturingRun',ex.getMessage(),'Method - calculateMan',null,'',ex.getStackTraceString(),UserInfo.getUserId());
            return null;
        }         
    }
    
    public class responseWrapper
    {
        @auraenabled
        public string message{get;set;}
        @auraenabled
        public Manufacturing_Run__c mr{get;set;}
    }
        
    @auraenabled
    public static responseWrapper saveManufacturingRun(String data, String manfacData)
    {
        responseWrapper rw = new responseWrapper();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Recipe__c') 
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Products__c')
            
           &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Recipe__c',new set<String>{'sigmaerpdev2__Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run__c',new set<String>{'Id','sigmaerpdev2__Manufacturing_Name__c','sigmaerpdev2__Expiry_date_of_Batch__c','sigmaerpdev2__Batch_Number__c','sigmaerpdev2__PI_updated__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Recipe__r.Name','sigmaerpdev2__Required_Quantity__c','sigmaerpdev2__Produced_Quantity__c','sigmaerpdev2__Status__c','sigmaerpdev2__Run_Date__c','sigmaerpdev2__manufactuting_Run_Plant_name__r.Name','sigmaerpdev2__Production_Manager__r.Name'})
            
           // &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Manufacturing_Run__c',new set<String>{'sigmaerpdev2__Manufacturing_Name__c','sigmaerpdev2__Recipe__c','sigmaerpdev2__Required_Quantity__c','sigmaerpdev2__Status__c','sigmaerpdev2__Run_Date__c','sigmaerpdev2__Product__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Produced_Quantity__c','sigmaerpdev2__manufactuting_Run_Plant_name__c','sigmaerpdev2__Production_Manager__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Manufacturing_Products__c',new set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Unit_of_measure__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Modified_Quantity__c','sigmaerpdev2__Cost__c','sigmaerpdev2__Stock_Item__c'})
            
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Manufacturing_Products__c',new Set<String>{'sigmaerpdev2__Manufacturing_Run__c'})
            ) 
        {   
            Try{
                   
                ManufacturingWrap manuFacWrap = (ManufacturingWrap)JSON.deserialize(data, ManufacturingWrap.class);
                Manufacturing_Run__c mrr = (Manufacturing_Run__c)JSON.deserialize(manfacData, Manufacturing_Run__c.class);
                         system.debug('manfacData>>'+mrr);  
                Manufacturing_Run__c mr = new Manufacturing_Run__c();
                mr.Manufacturing_Name__c = mrr.Manufacturing_Name__c;
                mr.Recipe__c = mrr.Recipe__c;
                mr.Required_Quantity__c = mrr.Required_Quantity__c;            
                mr.Status__c = mrr.Status__c;
                mr.Run_Date__c = mrr.Run_Date__c;
                mr.Product__c = mrr.Product__c;
                mr.End_Date__c = mrr.End_Date__c;
                mr.manufactuting_Run_Plant_name__c = mrr.manufactuting_Run_Plant_name__c;
                //mr.MR_Plant_Manager__c = mrr.MR_Plant_Manager__c;
                mr.Production_Manager__c = mrr.Production_Manager__c;
                insert mr;
                
                //fetch quantity from recipe and update MR Produced quantity - added on 22/8/2019 
                Recipe__c rp = [select Quantity__c from Recipe__c where Id = :mrr.Recipe__c];           
                mr.Produced_Quantity__c = rp.Quantity__c * mrr.Required_Quantity__c;            
                update mr;
                //ends here
                
                Id PcompRecID = Schema.SObjectType.Manufacturing_Products__c.getRecordTypeInfosByName().get('Product Components').getRecordTypeId();
                Id ProcedureRecID = Schema.SObjectType.Manufacturing_Products__c.getRecordTypeInfosByName().get('Packaging Materials').getRecordTypeId();
                Id AdditionalProdRecID = Schema.SObjectType.Manufacturing_Products__c.getRecordTypeInfosByName().get('Additional Products').getRecordTypeId();
                
                List<Manufacturing_Products__c> mpList = new List<Manufacturing_Products__c>();
                
                if(manuFacWrap.productCompList != null){
                    for(productComp pc : manuFacWrap.productCompList){
                        Manufacturing_Products__c mp = new Manufacturing_Products__c();
                        mp.Product__c = pc.ProdID;
                        mp.Manufacturing_Run__c = mr.Id;
                        mp.Unit_of_measure__c = pc.UnityOfMeasure;
                        mp.Quantity__c = pc.Quantity;
                        mp.RecordTypeId = PcompRecID;
                        mp.Modified_Quantity__c = pc.ModifiedQuantity;                    
                        mp.Cost__c = (pc.UnitPrice).setScale(2);
                        mp.Stock_Item__c = true;
                        mpList.add(mp);
                    }
                }
                
                if(manuFacWrap.packagingMatList != null){
                    for(packagingMaterial pc : manuFacWrap.packagingMatList){
                        Manufacturing_Products__c mp = new Manufacturing_Products__c();
                        mp.Product__c = pc.ProdID;
                        mp.Manufacturing_Run__c = mr.Id;
                        mp.Unit_of_measure__c = pc.UnityOfMeasure;
                        mp.Quantity__c = pc.Quantity;
                        mp.RecordTypeId = ProcedureRecID;
                        mp.Modified_Quantity__c = pc.ModifiedQuantity;                    
                        mp.Cost__c = (pc.UnitPrice).setScale(2);
                        mp.Stock_Item__c = true;
                        mpList.add(mp);
                    }
                }            
                   
                if(manuFacWrap.AdditionalProductList != null){
                    for(AdditionalProduct pc : manuFacWrap.AdditionalProductList){
                        Manufacturing_Products__c mp = new Manufacturing_Products__c();
                        mp.Product__c = pc.ProdID;
                        mp.Manufacturing_Run__c = mr.Id;
                        mp.Unit_of_measure__c = pc.UnityOfMeasure;
                        mp.Quantity__c = pc.Quantity;
                        mp.RecordTypeId = AdditionalProdRecID;
                        mp.Modified_Quantity__c = pc.ModifiedQuantity;                    
                        mp.Cost__c = pc.UnitPrice;
                        mp.Stock_Item__c = false;
                        mpList.add(mp);
                    }
                }            
                
                if(mpList.size() > 0){
                    insert mpList;
                }
                rw.message = 'success';
                rw.mr = new Manufacturing_Run__c();
                rw.mr = [select Id,Manufacturing_Name__c,Expiry_date_of_Batch__c,Batch_Number__c,PI_updated__c,Product__c,Product__r.Name,Recipe__r.Name,Required_Quantity__c,Produced_Quantity__c,Status__c,Run_Date__c,End_Date__c,manufactuting_Run_Plant_name__c,Production_Manager__c from Manufacturing_Run__c where ID =: mr.Id];
                return rw;
            }catch(Exception e){
                createErrorLog.insertError('ManufacturingRun',e.getMessage(),'Method - saveManufacturingRun',null,'',e.getStackTraceString(),UserInfo.getUserId());
                //responseWrapper rw = new responseWrapper();
                rw.message = e.getMessage() +' '+e.getLinenumber();
                return rw;
            }
        }
        return rw;
    }
    
    @auraenabled
    public static ManufacturingWrap editManufac(ID recordID)
    {
        ManufacturingWrap manFacWrap = new ManufacturingWrap();
        manFacWrap.productCompList = new List<productComp>();
        manFacWrap.packagingMatList = new List<packagingMaterial>();
        manFacWrap.AdditionalProductList = new List<AdditionalProduct>();
        manFacWrap.manfRunResList = new List<Project_Resource__c>();
        manFacWrap.manfRun = new Manufacturing_Run__c(); 
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run__c')
            &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Products__c')
            &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Project_Resource__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run__c',new set<String>{'Id', 'Name', 'sigmaerpdev2__Manufacturing_Name__c','sigmaerpdev2__Expiry_date_of_Batch__c','sigmaerpdev2__Batch_Number__c','sigmaerpdev2__PI_updated__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Status__c', 'sigmaerpdev2__Required_Quantity__c', 'sigmaerpdev2__Run_Date__c', 'sigmaerpdev2__End_Date__c', 'sigmaerpdev2__Recipe__c','sigmaerpdev2__Recipe__r.Name','sigmaerpdev2__manufactuting_Run_Plant_name__c','sigmaerpdev2__manufactuting_Run_Plant_name__r.Name','sigmaerpdev2__Production_Manager__c','sigmaerpdev2__Production_Manager__r.Name'})
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Products__c',new set<String>{'Id', 'Name','sigmaerpdev2__Cost__c','sigmaerpdev2__Modified_Quantity__c','sigmaerpdev2__Product__r.Name','RecordType.Name', 'sigmaerpdev2__Manufacturing_Run__c','sigmaerpdev2__Product__c','sigmaerpdev2__Unit_of_measure__c', 'sigmaerpdev2__Quantity__c', 'sigmaerpdev2__Description__c', 'sigmaerpdev2__Procedure_Name__c', 'sigmaerpdev2__Stock_Item__c'})         
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Project_Resource__c',new set<String>{'id','name','sigmaerpdev2__Manufacturing_Run__c','sigmaerpdev2__Resource__r.Name','sigmaerpdev2__Resource__r.sigmaerpdev2__Roles__c','sigmaerpdev2__Interval__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Manufacturing_Run__r.id'})         
            ) 
        {   
            try
            {           
                manFacWrap.manfRun = [SELECT Id, Name,sigmaerpdev2__manufactuting_Run_Plant_name__r.Name,sigmaerpdev2__Production_Manager__r.Name, Manufacturing_Name__c,Expiry_date_of_Batch__c,Batch_Number__c,PI_updated__c,Product__c,Product__r.Name,Status__c, Required_Quantity__c, Run_Date__c, End_Date__c, Recipe__c,Recipe__r.Name FROM Manufacturing_Run__c where Id = :recordID];
                for(Manufacturing_Products__c mp:[SELECT Id, Name,Cost__c,Modified_Quantity__c,Product__r.Name,RecordType.Name,Manufacturing_Run__c, Product__c, Unit_of_measure__c, Quantity__c, Description__c, Procedure_Name__c,Stock_Item__c FROM Manufacturing_Products__c where Manufacturing_Run__c=:recordID])
                {
                    if(mp.RecordType.Name == 'Product Components')
                    {
                        productComp pc = new productComp();
                        pc.ProdName = mp.Product__r.Name;
                        pc.ProdID = mp.Product__c;
                        pc.UnityOfMeasure = mp.Unit_of_measure__c;                                      
                        pc.ManufactureProdID = mp.Id;                   
                        pc.Quantity = mp.Quantity__c;
                        pc.ModifiedQuantity = mp.Modified_Quantity__c;                                                                        
                        pc.StockItem = mp.Stock_Item__c;                    
                        pc.UnitPrice = (mp.Cost__c).setScale(2);  
                        pc.ModifiedUnitPrice = (mp.Cost__c).setScale(2); 
                        
                        manFacWrap.productCompList.add(pc);
                    }
                    else if(mp.RecordType.Name == 'Packaging Materials')
                    {
                        packagingMaterial pm = new packagingMaterial();
                        pm.ProdName = mp.Product__r.Name;
                        pm.ProdID = mp.Product__c;
                        pm.UnityOfMeasure = mp.Unit_of_measure__c;                                        
                        pm.ManufactureProdID = mp.Id;                    
                        pm.Quantity = mp.Quantity__c;
                        pm.ModifiedQuantity = mp.Modified_Quantity__c;
                        pm.UnitPrice = (mp.Cost__c).setScale(2);
                        pm.ModifiedUnitPrice = (mp.Cost__c).setScale(2);
                        pm.StockItem = mp.Stock_Item__c;
                        manFacWrap.packagingMatList.add(pm);
                    }
                    else if(mp.RecordType.Name == 'Additional Products')
                    {
                        AdditionalProduct ap = new AdditionalProduct();
                        ap.ProdName = mp.Product__r.Name;
                        ap.ProdID = mp.Product__c;
                        ap.UnityOfMeasure = mp.Unit_of_measure__c;                   
                        ap.UnitPrice = mp.Cost__c;
                        ap.ManufactureProdID = mp.Id;                    
                        ap.Quantity = mp.Quantity__c;
                        ap.ModifiedQuantity = mp.Modified_Quantity__c;                    
                        ap.ModifiedUnitPrice = mp.Cost__c;
                        ap.StockItem = mp.Stock_Item__c;
                        manFacWrap.AdditionalProductList.add(ap);
                    }
                    
                }           
                manFacWrap.manfRunResList=[select id,name,Manufacturing_Run__c,Resource__r.Name,Resource__r.Roles__c,Interval__c,Start_Date__c,End_Date__c from Project_Resource__c where Manufacturing_Run__r.id = :recordID];            
                return manFacWrap;
            }catch(Exception e){
                createErrorLog.insertError('ManufacturingRun',e.getMessage(),'Method - editManufac',null,'',e.getStackTraceString(),UserInfo.getUserId());
                return null;
            } 
        }
        return manFacWrap;      
    }    
        
    //new update Method for MR
    @auraenabled
    public static responseWrapper updateManufacturingRun(String data, String manfacData, Boolean resvFlg )//List<sigmaerpdev2__Project_Resource__c> resData
    {
        responseWrapper rw = new responseWrapper();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Recipe__c') 
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Products__c')
            
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run__c',new set<String>{'sigmaerpdev2__Recipe__c','sigmaerpdev2__Required_Quantity__c'}) 
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Recipe__c',new set<String>{'sigmaerpdev2__Quantity__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Products__c',new set<String>{'Id','sigmaerpdev2__Manufacturing_Run__c'})
            
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Manufacturing_Run__c',new set<String>{'sigmaerpdev2__Produced_Quantity__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Manufacturing_Products__c',new set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Unit_of_measure__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Modified_Quantity__c','sigmaerpdev2__Cost__c','sigmaerpdev2__Stock_Item__c','RecordTypeId'})
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Manufacturing_Products__c',new Set<String>{'sigmaerpdev2__Manufacturing_Run__c'})
            )
        {
            Try 
            {  
                 Manufacturing_Run__c mr = (Manufacturing_Run__c)JSON.deserialize(manfacData, Manufacturing_Run__c.class);           
                            
                //above commented section has been replaced by this - fetch quantity from recipe and update MR Produced quantity - added on 22/8/2019 
                Recipe__c rp = [select Quantity__c from Recipe__c where Id = :mr.Recipe__c];            
                mr.Produced_Quantity__c = rp.Quantity__c * mr.Required_Quantity__c;            
                update mr;
                //ends here
                
                if(resvFlg == false){               
                    Delete [select id from Manufacturing_Products__c where Manufacturing_Run__c =:mr.Id];                                               
                    ManufacturingWrap manuFacWrap = (ManufacturingWrap)JSON.deserialize(data, ManufacturingWrap.class);
                                
                    Id PcompRecID = Schema.SObjectType.Manufacturing_Products__c.getRecordTypeInfosByName().get('Product Components').getRecordTypeId();
                    Id ProcedureRecID = Schema.SObjectType.Manufacturing_Products__c.getRecordTypeInfosByName().get('Packaging Materials').getRecordTypeId();
                    Id AdditionalProdRecID = Schema.SObjectType.Manufacturing_Products__c.getRecordTypeInfosByName().get('Additional Products').getRecordTypeId();
                    
                    List<Manufacturing_Products__c> mpList = new List<Manufacturing_Products__c>();            
                    
                    if(manuFacWrap.productCompList != null){
                        for(productComp pc : manuFacWrap.productCompList){
                            Manufacturing_Products__c mp = new Manufacturing_Products__c();
                            mp.Product__c = pc.ProdID;
                            mp.Manufacturing_Run__c = mr.Id;
                            mp.Unit_of_measure__c = pc.UnityOfMeasure;                   
                            mp.RecordTypeId = PcompRecID;                    
                            
                            mp.Quantity__c = pc.Quantity;
                            mp.Modified_Quantity__c = pc.ModifiedQuantity; 
                            
                            mp.Cost__c = (pc.UnitPrice).setScale(2);                     
                            if(pc.StockItem != null){
                                mp.Stock_Item__c = pc.StockItem;
                            }          
                            mpList.add(mp);
                        }
                    }
                    
                    if(manuFacWrap.packagingMatList != null){
                            for(packagingMaterial pc : manuFacWrap.packagingMatList){
                            Manufacturing_Products__c mp = new Manufacturing_Products__c();
                            mp.Product__c = pc.ProdID;
                            mp.Manufacturing_Run__c = mr.Id;
                            mp.Unit_of_measure__c = pc.UnityOfMeasure;
                            mp.RecordTypeId = ProcedureRecID;
                            mp.Quantity__c = pc.Quantity;                    
                            mp.Modified_Quantity__c = pc.ModifiedQuantity;                    
                            mp.Cost__c = (pc.UnitPrice).setScale(2);                    
                            if(pc.StockItem != null){
                                mp.Stock_Item__c = pc.StockItem;
                            }
                            mpList.add(mp);
                        }
                    }
                    
                    if(manuFacWrap.AdditionalProductList != null){
                        for(AdditionalProduct pc : manuFacWrap.AdditionalProductList){
                            Manufacturing_Products__c mp = new Manufacturing_Products__c();
                            mp.Product__c = pc.ProdID;
                            mp.Manufacturing_Run__c = mr.Id;
                            mp.Unit_of_measure__c = pc.UnityOfMeasure;
                            mp.RecordTypeId = AdditionalProdRecID;                    
                            mp.Quantity__c = pc.Quantity;                    
                            mp.Modified_Quantity__c = pc.ModifiedQuantity;
                            mp.Cost__c = (pc.UnitPrice).setScale(2);        
                            if(pc.StockItem != null){
                                mp.Stock_Item__c = pc.StockItem;
                            }
                            mpList.add(mp);
                        }
                    }            
                    if(mpList.size() > 0){
                        insert mpList;
                    } 
                }
                rw.message = 'success';
                rw.mr = new Manufacturing_Run__c();
                rw.mr = mr;
                return rw;    
            }
            catch(Exception e)
            {
                createErrorLog.insertError('ManufacturingRun',e.getMessage(),'Method - updateManufacturingRun ',null,'',e.getStackTraceString(),UserInfo.getUserId());           
                rw.message = e.getMessage() +' '+e.getLinenumber();
                return rw;
            } 
        }
        return rw;          
    }
    //ends here
    @auraEnabled
    public static String deleteManufacturingRun(Id manRunId){
        String flag = 'FAILED';
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run__c',new set<String>{'Id','Name'})
            )
        {
            try{
                Manufacturing_Run__c mrObj = [select Id,Name from Manufacturing_Run__c where Id = :manRunId];   
                delete mrObj;
                flag = 'SUCCESS';
            }catch(Exception ex){           
                createErrorLog.insertError('ManufacturingRun',ex.getMessage(),'deleteManufacturingRun',null,'',ex.getStackTraceString(),UserInfo.getUserId());
                return flag;
            } 
        }
        return flag;
    }
    
    public class ManufacturingWrap
    {
        @auraenabled
        public Manufacturing_Run__c manfRun{get;set;}
        @auraenabled
        public List<productComp> productCompList{get;set;}
        @auraenabled
        public List<packagingMaterial> packagingMatList{get;set;}
        @auraenabled
        public List<AdditionalProduct> AdditionalProductList{get;set;}
        @auraenabled
        public List<Project_Resource__c> manfRunResList{get;set;}
        
    }
    
    public class productComp
    {
        @auraenabled
        public String ProdName{get;set;}
        @auraenabled
        public String ProdID{get;set;}
        @auraenabled
        public String UnityOfMeasure{get;set;}
        @auraenabled
        public Decimal Quantity{get;set;}
        @auraenabled
        public Decimal UnitPrice{get;set;}
        @auraenabled
        public ID ManufactureProdID{get;set;}
        @auraenabled
        public Decimal ModifiedQuantity{get;set;}
        @auraenabled
        public Decimal ModifiedUnitPrice{get;set;}
        @auraenabled
        public Boolean StockItem{get;set;}
    }
    
    public class packagingMaterial
    {
        @auraenabled
        public String ProdName{get;set;}
        @auraenabled
        public String ProdID{get;set;}
        @auraenabled
        public String UnityOfMeasure{get;set;}
        @auraenabled
        public Decimal Quantity{get;set;}
        @auraenabled
        public Decimal UnitPrice{get;set;}
        
        @auraenabled
        public ID ManufactureProdID{get;set;}
        @auraenabled
        public Decimal ModifiedQuantity{get;set;}
        @auraenabled
        public Decimal ModifiedUnitPrice{get;set;}
        @auraenabled
        public Boolean StockItem{get;set;}
    }
    
    public class AdditionalProduct
    {
        @auraenabled
        public String ProdName{get;set;}
        @auraenabled
        public String ProdID{get;set;}
        @auraenabled
        public String UnityOfMeasure{get;set;}
        @auraenabled
        public Decimal Quantity{get;set;}
        @auraenabled
        public Decimal UnitPrice{get;set;}
        @auraenabled
        public ID ManufactureProdID{get;set;}
        @auraenabled
        public Decimal ModifiedQuantity{get;set;}
        @auraenabled
        public Decimal ModifiedUnitPrice{get;set;}
        @auraenabled
        public Boolean StockItem{get;set;}
    }
    
    //code added by vikas for Check and Reserve Stock on 5/4/2018
    public class listOfProductsWrapper{
        @AuraEnabled
        public List<ProductWrapper> mainWrapProdList{get;set;}
        public listOfProductsWrapper(List<ProductWrapper> mainWrapProdList){
            this.mainWrapProdList = mainWrapProdList;
        }
    }
    
    //Wrapper class to store Product Details
    public class ProductWrapper {       
        @AuraEnabled            
        public Id prodId {get;set;}
        @AuraEnabled            
        public String prodName {get;set;}
        @AuraEnabled          
        public Decimal requiredQnt{get;set;}          
        @AuraEnabled
        public String prodAttributeType{get;set;}                         
        @AuraEnabled
        public String prodBomType{get;set;}
        @AuraEnabled
        public List<innerWrapper> wrapProdList{get;set;}
        @AuraEnabled
        public String prodUOM{get;set;}         
        @AuraEnabled            
        public Id manufRunId {get;set;}
        @AuraEnabled
        public Boolean allocatedViaAutopickOrManual{get;set;}
        @AuraEnabled
        public Decimal totalAvailQty{get;set;}
        @AuraEnabled
        public Decimal avgUnitPrice{get;set;}
        public ProductWrapper(Id ProdId, String ProdName, Decimal requiredQnt,String prodAttributeType,String pBom,List<innerWrapper> wrapProdList,String prodUOM,Id manufRunId,Boolean allocatedViaAutopickOrManual, Decimal totalAvailQty,Decimal avgUnitPrice) {                           
            this.prodId = prodId;
            this.ProdName = ProdName;
            this.requiredQnt = requiredQnt;            
            this.prodAttributeType = prodAttributeType;
            this.prodBomType = pBom;
            this.wrapProdList = wrapProdList;       
            this.prodUOM = prodUOM;                     
            this.manufRunId = manufRunId;
            this.allocatedViaAutopickOrManual = allocatedViaAutopickOrManual; 
            this.totalAvailQty = totalAvailQty;
            this.avgUnitPrice = avgUnitPrice;
          
        }       
    }
    
    //Wrapper class to store ILPLI Details
    public class innerWrapper { 
        @AuraEnabled
        public Decimal selQuantity{get;set;}
        @AuraEnabled         
        public Id srNumId {get; set;}
        @AuraEnabled         
        public String srNumName {get; set;}
        @AuraEnabled        
        public String lotName {get;set;}
        @AuraEnabled        
        public Date lotExpiryDate {get;set;}
        @AuraEnabled        
        public String ilpName {get;set;}
        @AuraEnabled
        public Decimal ilpAvailQuantity {get;set;}
        @AuraEnabled
        public Id lotId {get;set;}
        @AuraEnabled
        public Id ilpId {get;set;}
        @AuraEnabled
        public Id ilpliId {get;set;}
        @AuraEnabled
        public Id locationId {get;set;}
        @AuraEnabled
        public Id ppId {get;set;}
        @AuraEnabled
        public Id ppliId {get;set;}
        @AuraEnabled
        public String prodUOM{get;set;}
        @AuraEnabled
        public Date prodExpDate{get;set;}
        @AuraEnabled
        public ID recordID{get;set;}  
        @AuraEnabled        
        public String ilpliName {get;set;}
        @AuraEnabled        
        public Decimal unitPrice {get;set;}
        @AuraEnabled        
        public String ilName {get;set;}
        
        @AuraEnabled        
        public String zoneName {get;set;}
        
        public innerWrapper(Decimal selQn,Id srNumId, String ltName, Date ltExpiryDate, String ilpName, Decimal avlQn, Id lotId, Id ilpId, Id ilpliId, Id locationId, String srNumName, Id ppId, Id ppliId, String prodUOM,Date prodExpDate,ID recID,String ilpliName,Decimal unitPrice, String ilName, String zoneName) {
            this.selQuantity = selQn;
            this.srNumId = srNumId;          
            this.lotName = ltName;
            this.lotExpiryDate = ltExpiryDate;
            this.ilpName = ilpName;
            this.ilpAvailQuantity = avlQn;   
            this.lotId = lotId; 
            this.ilpId = ilpId;
            this.ilpliId = ilpliId;         
            this.locationId = locationId;
            this.srNumName = srNumName;
            this.ppId = ppId;
            this.ppliId = ppliId;
            this.prodUOM = prodUOM;
            this.prodExpDate = prodExpDate;
            this.recordID=recID;
            this.ilpliName = ilpliName;
            this.unitPrice = unitPrice;
            this.ilName = ilName;
            this.zoneName = zoneName;
        }
    } 
    
    //Storage Location wrapper
    public class StorageLocationWrapper{
        @AuraEnabled
        public String invLocId{get;set;}
        @AuraEnabled
        public Decimal quantity{get;set;}        
    }
    
    //retrieve Stock details required to Manufacture a particular recipe by getting its recipeId
    @AuraEnabled
    public static List<listOfProductsWrapper> getFullStock(String manfRunId, Decimal manfQuan, String data){
        List<listOfProductsWrapper> wrapProdListOuter = new List<listOfProductsWrapper>();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Products__c')  
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')    
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
            
             &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'id','name','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Products__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Products__c',new set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__r.name','sigmaerpdev2__Manufacturing_Run__c','Product__r.Stock_Item__c','RecordTypeId'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'id','name','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Products__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'id','name','sigmaerpdev2__Bin__r.Name','sigmaerpdev2__Bin__r.sigmaerpdev2__Zone__r.Name','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Inventory_Location__r.Name','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Products__c','sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Products__r.sigmaerpdev2__Product_UOM__c','sigmaerpdev2__Expiry_Date__c','sigmaerpdev2__Inventory_Location_Product__r.Name','sigmaerpdev2__Inventory_Location_Product__r.Id','sigmaerpdev2__Serial_Number_Code__c','sigmaerpdev2__Unit_Price__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'id','name','sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Product_UOM__c'})
        )
        {
            Map<Id,Decimal> modProdQuanMap = new Map<Id,Decimal>();                
            ManufacturingWrap manuFacWrap = (ManufacturingWrap)JSON.deserialize(data, ManufacturingWrap.class);
            for(productComp pc : manuFacWrap.productCompList){            
                if((pc.StockItem == true) && (pc.Quantity > 0)){
                    modProdQuanMap.put(pc.ProdID, pc.Quantity);
                }
            }        
            Map<Id,Decimal> packMatQuanMap = new Map<Id,Decimal>(modProdQuanMap);        
            for(packagingMaterial pc1 : manuFacWrap.packagingMatList){            
                if((pc1.StockItem == true) && (pc1.Quantity > 0)){
                    packMatQuanMap.put(pc1.ProdID, pc1.Quantity); 
                }                      
            }                
                    
            //List<listOfProductsWrapper> wrapProdListOuter = new List<listOfProductsWrapper>(); //list of all Products and its ilpli list
            try{
                Id ProdId;
                String prodName; 
                String status;
                String prodAttrType;
                String prodBomType; 
                String productUOM;
                Decimal totalAvailableQty;
                                        
                List<ProductWrapper> wrapProdListManual = new List<ProductWrapper>(); //list of indiv. Products and its ilpli list 
                Map<Id,Decimal> prodMap = new Map<Id,Decimal>(); 
                Map<Id,String> ilpListMap1 = new Map<Id,String>();
                
                Id AdditionalProdRecID = Schema.SObjectType.Manufacturing_Products__c.getRecordTypeInfosByName().get('Additional Products').getRecordTypeId();
                
                List<Manufacturing_Products__c> OrderLineList = [select Product__c,Quantity__c,Product__r.name from Manufacturing_Products__c where Manufacturing_Run__c = :manfRunId and Product__c != null and Product__r.Stock_Item__c != false and RecordTypeId != :AdditionalProdRecID];
                for(Manufacturing_Products__c tdiList : OrderLineList){                
                    if(packMatQuanMap.get(tdiList.Product__c) != null){
                        prodMap.put(tdiList.Product__c,packMatQuanMap.get(tdiList.Product__c));
                    }
                }
                            
                List<Inventory_Location_Product__c> ilpList = [select id,name from Inventory_Location_Product__c where Net_Quantity__c > 0 and Products__c IN :prodMap.keySet()];
                for (Inventory_Location_Product__c ilpListItems : ilpList){              
                    ilpListMap1.put(ilpListItems.Id,ilpListItems.Name);
                }                     
                //removed the inner query and querying full ilpli list to fix inner query issue returning more than 200 ilpli's for particular product
                Map<Id,List<Inventory_Location_Product_Line_Item__c>> prodILPLIListNewMap = new Map<Id,List<Inventory_Location_Product_Line_Item__c>>();
                
                //List<Inventory_Location_Product_Line_Item__c> newIlpliList = [select id,name,Bin__r.Name,Bin__r.Zone__r.Name,Inventory_Location_Product__r.Inventory_Location__r.Name,Inventory_Location_Product__r.Products__c,Actual_Available_Quantity__c ,Inventory_Location_Product__r.Product__r.Product_UOM__c,Expiry_Date__c,Inventory_Location_Product__r.Inventory_Location__r.Locations__r.Name,Inventory_Location_Product__r.Name,Inventory_Location_Product__r.Inventory_Location__r.Locations__r.Id,Inventory_Location_Product__r.Id,Serial_Bulk_No__c,Unit_Price__c from Inventory_Location_Product_Line_Item__c where Actual_Available_Quantity__c  > 0 and Needs_Review__c = false and  Inventory_Location_Product__r.Id in :ilpListMap1.keySet()];                                                                
                List<Inventory_Location_Product_Line_Item__c> newIlpliList = [select id,name,Bin__r.Name,Bin__r.Zone__r.Name,Inventory_Location_Product__r.Inventory_Location__r.Name,Inventory_Location_Product__r.Products__c,Available_Quantity__c ,Inventory_Location_Product__r.Products__r.Product_UOM__c,Expiry_Date__c,Inventory_Location_Product__r.Name,Inventory_Location_Product__r.Id,Serial_Number_Code__c,Unit_Price__c from Inventory_Location_Product_Line_Item__c where Available_Quantity__c  > 0 and  Inventory_Location_Product__r.Id in :ilpListMap1.keySet()];                                                                
                if(newIlpliList.size() > 0){
                    for(Inventory_Location_Product_Line_Item__c ilpli1 : newIlpliList){
                        if(ilpli1.Inventory_Location_Product__r.Products__c != null){
                            if(prodILPLIListNewMap.containsKey(ilpli1.Inventory_Location_Product__r.Products__c)){
                                List<Inventory_Location_Product_Line_Item__c> showILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                                showILPLI = prodILPLIListNewMap.get(ilpli1.Inventory_Location_Product__r.Products__c);
                                showILPLI.add(ilpli1);
                                prodILPLIListNewMap.put(ilpli1.Inventory_Location_Product__r.Products__c,showILPLI);        
                            }else{
                                List<Inventory_Location_Product_Line_Item__c> showILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                                showILPLI.add(ilpli1);
                                prodILPLIListNewMap.put(ilpli1.Inventory_Location_Product__r.Products__c,showILPLI);          
                            }
                        }            
                    }
                }            
                //ends here
                
                for(Product2 prd :[select id,name,Attribute_Type__c,Product_UOM__c from Product2 where id in : prodMap.keySet() order by name ASC]){
                    List<innerWrapper> innerWrapperList = new List<innerWrapper>(); 
                    totalAvailableQty = 0.0;
                    ProdId = prd.id;
                    prodName = prd.name;
                    prodAttrType = prd.Attribute_Type__c;                            
                    if(prd.Product_UOM__c != null){
                        productUOM = prd.Product_UOM__c;
                    }
                                                    
                    if(prodILPLIListNewMap.containsKey(prd.id)) {
                        for(Inventory_Location_Product_Line_Item__c ilpli : prodILPLIListNewMap.get(prd.id)){
                            totalAvailableQty = totalAvailableQty + ilpli.Available_Quantity__c;
                            innerWrapper iwrap = new innerWrapper(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);    
                            iwrap.selQuantity = null;                        
                            if(ilpli.Bin__r.Name == null) //now showing bin name instead of lot name - added on 20-3-2019
                                iwrap.lotName = 'Not Available';  
                            else
                                iwrap.lotName = ilpli.Bin__r.Name;
                            
                            if(ilpli.Bin__r.Zone__r.Name == null) //now showing zone name - added on 30-7-2019
                                iwrap.zoneName = 'Not Available';  
                            else
                                iwrap.zoneName = ilpli.Bin__r.Zone__r.Name;
                            
                            if(ilpli.Inventory_Location_Product__r.Inventory_Location__r.Name == null) //now showing IL name - added on 30-7-2019                       
                                iwrap.ilName = 'Not Available';
                            else    
                                iwrap.ilName = ilpli.Inventory_Location_Product__r.Inventory_Location__r.Name;
                                                    
                            iwrap.ilpName = ilpli.Inventory_Location_Product__r.Name;                       
                            iwrap.ilpliName = ilpli.name;
                            iwrap.ilpAvailQuantity = ilpli.Available_Quantity__c;                                            
                            iwrap.ilpId = ilpli.Inventory_Location_Product__r.Id; 
                            iwrap.ilpliId = ilpli.Id;                                                
                            if(ilpli.Serial_Number_Code__c == null)
                                iwrap.srNumName = 'Not Available';  
                            else                                                
                                iwrap.srNumName = ilpli.Serial_Number_Code__c;                
                            iwrap.ppId = null;
                            iwrap.ppliId = null; 
                            iwrap.prodUOM = ilpli.Inventory_Location_Product__r.Products__r.Product_UOM__c;
                            iwrap.prodExpDate = ilpli.Expiry_Date__c;  
                            if(ilpli.Unit_Price__c != null){                              
                                iwrap.unitPrice = ilpli.Unit_Price__c;     
                            }                              
                            innerWrapperList.add(iwrap);
                        }
                        wrapProdListManual.add(new ProductWrapper(ProdId,prodName,prodMap.get(prd.id),prodAttrType,prodBomType,innerWrapperList,productUOM,null,false,totalAvailableQty,null));                              
                    }else{
                        innerWrapper iwrap = new innerWrapper(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null); 
                        innerWrapperList.add(iwrap);
                        wrapProdListManual.add(new ProductWrapper(ProdId,prodName,prodMap.get(prd.id),prodAttrType,prodBomType,innerWrapperList,productUOM,null,false,totalAvailableQty,null));                   
                    } 
                }
                wrapProdListOuter.add(new listOfProductsWrapper(wrapProdListManual));
            }catch(Exception e){            
                createErrorLog.insertError('ManufacturingRun',e.getMessage(),'Method - getFullStock',null,'',e.getStackTraceString(),UserInfo.getUserId());
                return null;
            } 
        }       
        return wrapProdListOuter;
    }
    
    @AuraEnabled
    public static void reserveRecipeStock(String selProductsList, Id manfRunId, Manufacturing_Run__c manufactureRunObj, String additionalProducts){                     
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run__c')  
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Recipe__c')      
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run_Allocation__c')  
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run_Allocation_Line_Items__c')  
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c') 
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c') 
            
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run__c',new set<String>{'sigmaerpdev2__Required_Quantity__c','sigmaerpdev2__Recipe__c'})    
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Recipe__c',new set<String>{'sigmaerpdev2__Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new set<String>{'Id','Name','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__ProductCode__c','sigmaerpdev2__Comments__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run_Allocation_Line_Items__c',new set<String>{'Id','Name','sigmaerpdev2__Quantity__c','sigmaerpdev2__Expiry_Date__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Location__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Manufacturing_Run_Allocation__r.sigmaerpdev2__Via_Autopick__c','sigmaerpdev2__Manufacturing_Run_Allocation__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'Id','sigmaerpdev2__Reserved_Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'id','name','sigmaerpdev2__Bin__r.Name','sigmaerpdev2__Bin__r.sigmaerpdev2__Zone__r.Name','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Inventory_Location__r.Name','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Products__c','sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Products__r.sigmaerpdev2__Product_UOM__c','sigmaerpdev2__Expiry_Date__c','sigmaerpdev2__Inventory_Location_Product__r.Name','sigmaerpdev2__Inventory_Location_Product__r.Id','sigmaerpdev2__Serial_Number_Code__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Reserved_Quantity__c'})
            
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Manufacturing_Run__c',new set<String>{'sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Total_Cost__c','sigmaerpdev2__Status__c','sigmaerpdev2__Produced_Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Manufacturing_Run_Allocation__c',new set<String>{'sigmaerpdev2__Manufacturing_Run__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Status__c','sigmaerpdev2__Via_Autopick__c','sigmaerpdev2__Avg_Unit_Price__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Manufacturing_Run_Allocation_Line_Items__c',new set<String>{'sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Expiry_Date__c','sigmaerpdev2__Location__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new set<String>{'sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Comments__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'sigmaerpdev2__Reserved_Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'sigmaerpdev2__Reserved_Quantity__c'})
            
            &&  CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Manufacturing_Run_Allocation_Line_Items__c',new set<String>{'sigmaerpdev2__Manufacturing_Run_Allocation__c'})
            )
        {
           
            List<ProductWrapper> AllData = new List<ProductWrapper>();
            Set<ID> packProdIDList = new Set<ID>();
            List<Id> productsList = new List<Id>(); //added to use while updating Inv. Location
            
            try{
                Map<Id,Decimal> prodUnitPriceMap = new Map<Id,Decimal>(); //store respective product and its unit price value[sum of all ilpli's unit prices]
                Decimal reqQty = manufactureRunObj.Required_Quantity__c;
                            
                List<ManufacturingRun.listOfProductsWrapper> container = (List<ManufacturingRun.listOfProductsWrapper>)System.JSON.deserialize(selProductsList,List<ManufacturingRun.listOfProductsWrapper>.class);                                                 
                for(ManufacturingRun.listOfProductsWrapper temp : container){
                    system.debug('temp>>...'+temp);
                    for(ProductWrapper p1 : temp.mainWrapProdList){    
                         system.debug('p1>>...'+p1);
                        List<innerWrapper> innerListData = new List<innerWrapper>();
                        Decimal avgUnitPrc = 0.0;                   
                        for(innerWrapper temp1 : p1.wrapProdList){  
                             system.debug('temp1>>...'+temp1);
                            if(temp1.selQuantity != null && temp1.selQuantity != 0){                            
                                Decimal totUnitPrc = 0.0;                            
                                if(temp1.unitPrice != null){
                                    totUnitPrc = temp1.unitPrice * temp1.selQuantity;
                                }                                                      
                                avgUnitPrc = avgUnitPrc + totUnitPrc;                            
                                innerListData.add(new innerWrapper(temp1.selQuantity,temp1.srNumId,temp1.lotName,temp1.lotExpiryDate,temp1.ilpName,temp1.ilpAvailQuantity,temp1.lotId,temp1.ilpId,temp1.ilpliId,temp1.locationId,temp1.srNumName,temp1.ppId,temp1.ppliId,p1.prodUOM,temp1.prodExpDate,null,temp1.ilpliName,temp1.unitPrice,null,null));
                            } 
                        }                                      
                        p1.avgUnitPrice = avgUnitPrc;
                        prodUnitPriceMap.put(p1.prodId,p1.avgUnitPrice);                                 
                        AllData.add(new ProductWrapper(p1.prodId,p1.prodName,p1.requiredQnt,p1.prodAttributeType,p1.prodBomType,innerListData,p1.prodUOM,manfRunId,p1.allocatedViaAutopickOrManual,null,p1.avgUnitPrice));
                        productsList.add(p1.prodId);  
                        packProdIDList.add(p1.prodId);
                        system.debug('AllData>>...'+AllData);
                          system.debug('productsList>>...'+productsList);
                          system.debug('packProdIDList>>...'+packProdIDList);
                    }           
                }   
                            
                //store the overall unit price in Manufacturing run obj by fetching it from Reserved Stock Products and Additonal Products
                ManufacturingWrap manuFacWrap = (ManufacturingWrap)JSON.deserialize(additionalProducts, ManufacturingWrap.class);
                Map<Id,Decimal> additionalProdQuanMap = new Map<Id,Decimal>(prodUnitPriceMap);
                for(AdditionalProduct pc2 : manuFacWrap.AdditionalProductList){                
                    additionalProdQuanMap.put(pc2.ProdID, pc2.UnitPrice);               
                }
                Decimal overallAvgCost = 0.0;
                for(Id prodID : additionalProdQuanMap.keySet()){
                    overallAvgCost = overallAvgCost + additionalProdQuanMap.get(prodID);
                }
                //ends here            
                manufactureRunObj.Unit_Price__c = overallAvgCost / reqQty;            
                manufactureRunObj.Total_Cost__c = manufactureRunObj.Required_Quantity__c * manufactureRunObj.Unit_Price__c;
                manufactureRunObj.Status__c = 'Stock Reserved'; //set status to Stock reserved
                
                //fetch quantity from recipe and update MR Produced quantity - added on 22/8/2019 
                Recipe__c rp = [select Quantity__c from Recipe__c where Id = :manufactureRunObj.Recipe__c];         
                manufactureRunObj.Produced_Quantity__c = rp.Quantity__c * manufactureRunObj.Required_Quantity__c;           
                //ends here         
                
                update manufactureRunObj; //update Manufacturing Run data
                
                
                List<Manufacturing_Run_Allocation__c> manfList = new List<Manufacturing_Run_Allocation__c>();
                Set<ID> prodIDList = new Set<ID>(); // used to keep track of ProdIdList - used to update lot
                Map<Id,List<Manufacturing_Run_Allocation_Line_Items__c>> PPLIMap = new Map<Id,List<Manufacturing_Run_Allocation_Line_Items__c>>();
                for(ProductWrapper temp : AllData){                   
                    Manufacturing_Run_Allocation__c tempMRAObj = new Manufacturing_Run_Allocation__c();           
                    List<innerWrapper> innerData = temp.wrapProdList;                
                    for(innerWrapper PLIL :innerData){
                        Manufacturing_Run_Allocation_Line_Items__c mrali = new Manufacturing_Run_Allocation_Line_Items__c();
                        mrali.Inventory_Location_Product__c = PLIL.ilpId;                    
                        mrali.Quantity__c = PLIL.selQuantity;
                        mrali.Unit_Price__c = PLIL.unitPrice;                    
                        mrali.Inventory_Location_Product_Line_Item__c = PLIL.ilpliId;
                        mrali.Expiry_Date__c = PLIL.lotExpiryDate;                    
                        if(PPLIMap.ContainsKey(temp.prodId))
                        {
                            List<Manufacturing_Run_Allocation_Line_Items__c> interimList = PPLIMap.get(temp.prodId);
                            interimList.add(mrali);
                            PPLIMap.put(temp.prodId,interimList);                        
                        }else
                        {
                            List<Manufacturing_Run_Allocation_Line_Items__c> newList = new List<Manufacturing_Run_Allocation_Line_Items__c>();
                            newList.add(mrali);
                            PPLIMap.put(temp.prodId,newList);                       
                        }
                    }
                    tempMRAObj.Manufacturing_Run__c = manfRunId;
                    tempMRAObj.Product__c = temp.prodId;                       
                    tempMRAObj.Quantity__c = temp.requiredQnt;
                    tempMRAObj.Status__c = 'Confirmed';                
                    tempMRAObj.Via_Autopick__c = temp.allocatedViaAutopickOrManual; 
                    tempMRAObj.Avg_Unit_Price__c  = temp.avgUnitPrice;
                    manfList.add(tempMRAObj);
                }
                //code to fix the issue - multiple package products for the same product if its quantity was more than 1
                Set<Manufacturing_Run_Allocation__c> finalSet = new Set<Manufacturing_Run_Allocation__c>();
                List<Manufacturing_Run_Allocation__c> result = manfList;
                finalSet.addAll(result);
                result.clear();
                manfList.clear();
                result.addAll(finalSet);
                manfList = result;
                //ends here
                insert manfList;                                   
                
                List<Manufacturing_Run_Allocation_Line_Items__c> mraliInsertList = new List<Manufacturing_Run_Allocation_Line_Items__c> ();  
                for(Manufacturing_Run_Allocation__c var : manfList)
                {           
                    prodIDList.add(var.Product__c); //used to store Product Id which will be used during update Lot 
                    if(PPLIMap.containsKey(var.Product__c))
                    {
                        List<Manufacturing_Run_Allocation_Line_Items__c> tempPPLIList = PPLIMap.get(var.Product__c);                                        
                        for(Manufacturing_Run_Allocation_Line_Items__c var1 :tempPPLIList)
                        {    
                            var1.Manufacturing_Run_Allocation__c =  var.Id;
                            var1.Location__c = null;                        
                            mraliInsertList.add(var1);                    
                        }
                    }
                }                    
                insert mraliInsertList;                        
                
                //update Product Inventory Stock
                List<Inventory__c> productInventoryList;        
                productInventoryList = [Select Id,Name,Available_Qty__c,Reserved_Qty__c,Comments__c,ProductCode__c From Inventory__c where ProductCode__c in :prodIDList];                 

                for(Manufacturing_Run_Allocation__c pp : manfList){
                    for(Inventory__c inv : productInventoryList){
                        if(pp.Product__c  == inv.ProductCode__c){                        
                            inv.Reserved_Qty__c = inv.Reserved_Qty__c + pp.Quantity__c;
                            inv.Available_Qty__c = inv.Available_Qty__c - pp.Quantity__c;   
                      		inv.Comments__c='Inventory updated after "Reserving Stock" for "Manufacturing Process" ';

                        }
                    } 
                }            
                update productInventoryList;
               //added by jyothi 
              /*List<Product_Serial_Number__c> productSerialNumberList;        
                productSerialNumberList = [Select Name,Product_Code__c,Status__c From Product_Serial_Number__c where Product_Code__c in :prodIDList];                 

                for(Manufacturing_Run_Allocation__c pp : manfList){
                    for(Product_Serial_Number__c psn: productSerialNumberList){
                        if(pp.Product__c  == psn.Product_Code__c){                        
                            psn.Status__c = 'Allocate';
                          
                        }
                    } 
                }            
                update productSerialNumberList;*/

                //ends here
                            
                //code to reduce ILP and ILPLI quantities during manufacturing run for manual selection
                List<Id> manfRunIdListForManual  = new List<Id>();
                for(Manufacturing_Run_Allocation__c ppId :manfList){            
                    manfRunIdListForManual.add(ppId.Id);            
                }
                system.debug('manfRunIdListForManual'+manfRunIdListForManual);
                                        
                Map<Id,Decimal> ILPReduceQtyMapForManual = new Map<Id,Decimal>(); //Map used to store ILP Id and the quantity to be reduced  
                Map<Id,Decimal> ILPLIReduceQtyMapForManual = new Map<Id,Decimal>(); //used to store ILPLI Id and the quantity to be reduced     
                Map<Id,Id> ILPLIPSNMapForManual = new Map<Id,Id>(); //used to store ILPLI Id and the PSN Id to change the PSN status available to Allocated         
                
                List<Inventory_Location_Product__c> fullILPList; // used to store query results for ILP     
                List<Inventory_Location_Product_Line_Item__c> fullILPLIList;   // used to store query results for ILPLI 
                List<Product_Serial_Number__c> fullPSNList; // used to store query results for PSN 
                List<Manufacturing_Run_Allocation_Line_Items__c> manfLineList;
                
                List<Inventory_Location_Product__c> ILPList = new List<Inventory_Location_Product__c>();
                List<Inventory_Location_Product_Line_Item__c> ILPLIListToUpdate = new List<Inventory_Location_Product_Line_Item__c>();
                List<Product_Serial_Number__c> PSNListToUpdate = new List<Product_Serial_Number__c>();
              
                
                manfLineList = [Select Id,Name,Quantity__c,Expiry_Date__c,Inventory_Location_Product__c,
                                Inventory_Location_Product_Line_Item__c,Location__c,Lot__c From Manufacturing_Run_Allocation_Line_Items__c where 
                                Manufacturing_Run_Allocation__r.Via_Autopick__c = false
                                and Manufacturing_Run_Allocation__c IN :manfRunIdListForManual];
                system.debug('manfLineList>...'+manfLineList);
                            
                for(Manufacturing_Run_Allocation_Line_Items__c pp1 :manfLineList){              
                    if(!ILPReduceQtyMapForManual.containsKey(pp1.Inventory_Location_Product__c)){
                        ILPReduceQtyMapForManual.put(pp1.Inventory_Location_Product__c, pp1.Quantity__c);
                        system.debug('ILPLIReduceQtyMapForManual'+ILPLIReduceQtyMapForManual);
                    }else{
                        Integer qty1 = Integer.valueOf(ILPReduceQtyMapForManual.get(pp1.Inventory_Location_Product__c));                    
                        ILPReduceQtyMapForManual.put(pp1.Inventory_Location_Product__c,(qty1 + pp1.Quantity__c));
                        system.debug('ILPLIReduceQtyMapForManual'+ILPLIReduceQtyMapForManual);
                    }
                    ILPLIReduceQtyMapForManual.put(pp1.Inventory_Location_Product_Line_Item__c,pp1.Quantity__c); //store selected ILPLI ids and quantity                    
                	system.debug('ILPLIReduceQtyMapForManual'+ILPLIReduceQtyMapForManual);
                } 
                
                            
                //update ILP added on 16/12/2019 - newly for Sigma
                fullILPList = [Select Id,Reserved_Quantity__c From Inventory_Location_Product__c where Id IN :ILPReduceQtyMapForManual.keySet()];            
                for(Inventory_Location_Product__c ilp : fullILPList){
                    Inventory_Location_Product__c ilpObj = new Inventory_Location_Product__c(); 
                    if(ILPReduceQtyMapForManual.containsKey(ilp.Id)){                                          
                        ilpObj.Reserved_Quantity__c = ilp.Reserved_Quantity__c + ILPReduceQtyMapForManual.get(ilp.Id);                    
                        ilpObj.Id = ilp.Id;
                        ILPList.add(ilpObj);
                      }   
                 }            
                update ILPList; //update ILP list
                
                //update ILP after autopick fifo flow also - added on 30-12-2019
                List<Inventory_Location_Product__c> fullILPListAutoPickUpdate; // used to store query results for ILP 
                Map<Id,Decimal> ILPReduceQtyMapForAutoPick = new Map<Id,Decimal>(); //Map used to store ILP Id and the quantity to be reduced  
                List<Manufacturing_Run_Allocation_Line_Items__c> manfLineListForAutoPick;
                manfLineListForAutoPick = [Select Id,Quantity__c,Inventory_Location_Product__c,
                                Inventory_Location_Product_Line_Item__c From Manufacturing_Run_Allocation_Line_Items__c where 
                                Manufacturing_Run_Allocation__r.Via_Autopick__c = true
                                and Manufacturing_Run_Allocation__c IN :manfRunIdListForManual];
                for(Manufacturing_Run_Allocation_Line_Items__c pp2 : manfLineListForAutoPick){              
                    if(!ILPReduceQtyMapForAutoPick.containsKey(pp2.Inventory_Location_Product__c)){
                        ILPReduceQtyMapForAutoPick.put(pp2.Inventory_Location_Product__c, pp2.Quantity__c);
                    }else{
                        Integer qty1 = Integer.valueOf(ILPReduceQtyMapForAutoPick.get(pp2.Inventory_Location_Product__c));                    
                        ILPReduceQtyMapForAutoPick.put(pp2.Inventory_Location_Product__c,(qty1 + pp2.Quantity__c));
                    }
                } 
                fullILPListAutoPickUpdate = [Select Id,Reserved_Quantity__c From Inventory_Location_Product__c where Id IN :ILPReduceQtyMapForAutoPick.keySet()];            
                for(Inventory_Location_Product__c ilp : fullILPListAutoPickUpdate){                
                    if(ILPReduceQtyMapForAutoPick.containsKey(ilp.Id)){                                          
                        ilp.Reserved_Quantity__c = ilp.Reserved_Quantity__c + ILPReduceQtyMapForAutoPick.get(ilp.Id);                                                       
                     }    
                }            
                update fullILPListAutoPickUpdate; //update ILP list
                //ends here
                                
                      
                fullILPLIList = [Select Id,Name,Inventory_Location_Product__c,Reserved_Quantity__c,Available_Quantity__c,Product_Serial_Number__r.Name 
                                 From Inventory_Location_Product_Line_Item__c where Id IN :ILPLIReduceQtyMapForManual.keySet()];
                 system.debug('fullILPLIList'+fullILPLIList);
                for(Inventory_Location_Product_Line_Item__c ilpli : fullILPLIList){
                     system.debug('ilpli'+ilpli);
                    Inventory_Location_Product_Line_Item__c ilpliObj = new Inventory_Location_Product_Line_Item__c(); 
                    if(ILPLIReduceQtyMapForManual.containsKey(ilpli.Id)){ 
                        ilpliObj.Reserved_Quantity__c = ilpli.Reserved_Quantity__c + ILPLIReduceQtyMapForManual.get(ilpli.Id);                    
                        ilpliObj.Id = ilpli.Id;                    
                        ILPLIListToUpdate.add(ilpliObj);
                    }   
                    ILPLIPSNMapForManual.put(ilpli.Product_Serial_Number__c,ilpli.id);
                    system.debug('ILPLIPSNMapForManual'+ILPLIPSNMapForManual);
                }
                update ILPLIListToUpdate; //update ILPLI list
                  system.debug('ILPLIListToUpdate'+ILPLIListToUpdate);
                //code to reduce ILPLI quantities ends here
                
                //code to update PSN status as used after stock reserve on 06-07-2021
              	fullPSNList = [Select Id,Name,Status__c From Product_Serial_Number__c where Id IN :ILPLIPSNMapForManual.keySet()];   
                system.debug('fullPSNList>>.'+fullPSNList);
                for(Product_Serial_Number__c psn : fullPSNList){
                    system.debug('psn>>.'+psn);
                    Product_Serial_Number__c psnObj = new Product_Serial_Number__c(); 
                    if(ILPLIPSNMapForManual.containsKey(psn.Id)){                                          
                        psnObj.Status__c = 'Used';                    
                        psnObj.Id = psn.Id;
                        PSNListToUpdate.add(psnObj);
                      }   
                 }            
               update PSNListToUpdate; 
                system.debug('PSNListToUpdate>>.'+PSNListToUpdate);
               //code ends here
                
            }catch(Exception e){            
                createErrorLog.insertError('ManufacturingRun',e.getMessage(),'Method - reserveRecipeStock',null,'',e.getStackTraceString(),UserInfo.getUserId());            
            }
        }
    }
    
    @AuraEnabled
    public static Boolean AllocateStockUsingFIFODuringManufactureRun(Id ProductId, Decimal reqQty, Id manfRunId){
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c') 
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Auto_Allocations_For_Manufaturing_Run__c') 
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Allocation_Item_Manufaturing_Run__c')
            
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'id','name','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Products__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'name','sigmaerpdev2__Inventory_Location_Product__r.Id','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Products__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Products__r.Name','sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__Product_Expiry_Date__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Received_Date__c'})
            
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'sigmaerpdev2__Reserved_Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Allocation_Item_Manufaturing_Run__c',new set<String>{'sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Status__c','sigmaerpdev2__Ordered_Quantity__c','sigmaerpdev2__Selected_Quantity__c','sigmaerpdev2__Remaining_Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Unit_Price__c'})
           
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Allocation_Item_Manufaturing_Run__c',new Set<String>{'sigmaerpdev2__Auto_Allocation_For_Manufaturing_Run__c'})
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Auto_Allocations_For_Manufaturing_Run__c',new Set<String>{'sigmaerpdev2__Manufacturing_Run__c'})
            )
           
        {
            Decimal allocatedQnty = 0.0;
            Decimal requiredQuantity = 0.0;
            Decimal allocatingQuantity = 0.0;
            Decimal orderedQuantity = 0.0;
            Decimal remainingQnty = 0.0;
            Decimal lineItemOrderedQuantity = 0.0; //used to restrict partial allocation if stock is insufficient  
             Map<Id,Id> ILPLIPSNMapForAutoStockReserve = new Map<Id,Id>(); //used to store  the PSN Id and ILPLI Id to change the PSN status available to Allocated    
            List<Product_Serial_Number__c> fullPSNList; // used to store query results for PSN 
            List<Product_Serial_Number__c> PSNListToUpdate = new List<Product_Serial_Number__c>();
            try{
                Map<Id,Decimal> reqProductQuantityMap1 = new Map<Id,Decimal>(); // store Product Id and its required Quantity
                Map<Id,Decimal> orderedQuantitymap = new Map<Id,Decimal>(); //used to store required Product Id and its Quantity
                Map<Id,String> ilpListMap1 = new Map<Id,String>();
                Integer allocOption = 2; //allocation happens on FIFO basis - Option 1 for Expiry date,Option 2 for Received date 
                            
                reqProductQuantityMap1.put(ProductId, reqQty); 
                orderedQuantitymap.put(ProductId,reqQty);
                lineItemOrderedQuantity = reqQty; //used to restrict partial allocation if stock is insufficient
                
                List<Inventory_Location_Product__c> ilpList = [select id,name from Inventory_Location_Product__c where Net_Quantity__c > 0 and Products__c In :reqProductQuantityMap1.keySet()];
                for (Inventory_Location_Product__c ilpListItems : ilpList){              
                    ilpListMap1.put(ilpListItems.Id,ilpListItems.Name);
                }
                            
                List<Inventory_Location_Product_Line_Item__c> ilpliList = new List<Inventory_Location_Product_Line_Item__c>();
                List<Inventory_Location_Product_Line_Item__c> additionalILPLIList = new List<Inventory_Location_Product_Line_Item__c>();
                if(allocOption == 1){               
                    ilpliList = [select name,Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Name,Reserved_Quantity__c,Available_Quantity__c,Product_Expiry_Date__c, 
                                 Unit_Price__c,Product_Serial_Number__r.Name from Inventory_Location_Product_Line_Item__c where Inventory_Location_Product__c in :ilpListMap1.keySet() and Product_Expiry_Date__c > TODAY order by Product_Expiry_Date__c ASC];                                
                }else if(allocOption == 2){                
                    List<Inventory_Location_Product_Line_Item__c> tempilpliList = new List<Inventory_Location_Product_Line_Item__c>();
                    tempilpliList = [select name,Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Name,
                                     Reserved_Quantity__c,Available_Quantity__c,Received_Date__c,Unit_Price__c,Product_Serial_Number__r.Name from Inventory_Location_Product_Line_Item__c where 
                                     Inventory_Location_Product__r.Id in :ilpListMap1.keySet() and Product_Expiry_Date__c != null and Product_Expiry_Date__c > TODAY and Available_Quantity__c > 0];
                                    
                    Decimal enoughStock = 0.0;
                    if(tempilpliList.size() > 0){ //if expiry date exists choose those ilpli's to do allocation
                        ilpliList = [select name,Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Name,
                                     Reserved_Quantity__c,Available_Quantity__c,Received_Date__c,Unit_Price__c,Product_Serial_Number__r.Name from Inventory_Location_Product_Line_Item__c where 
                                     Inventory_Location_Product__r.Id in :ilpListMap1.keySet() and Product_Expiry_Date__c > TODAY and Available_Quantity__c > 0 order by Product_Expiry_Date__c ASC];
                        
                        for(Inventory_Location_Product_Line_Item__c ilpItr : ilpliList){
                            enoughStock = enoughStock + ilpItr.Available_Quantity__c;
                        }
                        if(enoughStock < reqQty){ // if stock is low again pick from the remaining ilpli's which doesn't have expiry date
                            additionalILPLIList = [select name,Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Name,
                                                   Reserved_Quantity__c,Available_Quantity__c,Received_Date__c,Unit_Price__c,Product_Serial_Number__r.Name from Inventory_Location_Product_Line_Item__c where   
                                                   Inventory_Location_Product__r.Id in :ilpListMap1.keySet() and Available_Quantity__c > 0 and Product_Expiry_Date__c = null order by Received_Date__c ASC];
                            
                            ilpliList.addAll(additionalILPLIList);
                        }
                    }else{ //else choose all ilpli's to do allocation
                        ilpliList = [select name,Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Name,
                                     Reserved_Quantity__c,Available_Quantity__c,Received_Date__c,Unit_Price__c,Product_Serial_Number__r.Name from Inventory_Location_Product_Line_Item__c where 
                                     Inventory_Location_Product__r.Id in :ilpListMap1.keySet() and Available_Quantity__c > 0 order by Received_Date__c ASC];
                    }                                
                    
                }
                
                //added to restrict partial allocation if there is insufficient stock           
                Decimal tempQuantityTotal = 0.0;
                Boolean stockExists = false; //suggests there is not enough stock to do allocation
                for(Inventory_Location_Product_Line_Item__c checkQuantity : ilpliList){
                    tempQuantityTotal = tempQuantityTotal + checkQuantity.Available_Quantity__c;
                }            
                if(tempQuantityTotal >= lineItemOrderedQuantity){
                    stockExists = true; //suggests there is enough stock to do allocation
                }            
                //ends here.
                
                //allocate inventory in ILPLI object        
                Map<id,List<Inventory_Location_Product_Line_Item__c>> productAndILPLAllocated = new Map<id,List<Inventory_Location_Product_Line_Item__c>>();
                Map<id,Decimal> IlPLIQuan = new Map<id,Decimal>();
                
                //check whether there is enough stock to do allocation
                if(stockExists == true){ //suggests there is enough stock to do allocation if stockExists is true
                    for(Inventory_Location_Product_Line_Item__c allocateProd : ilpliList){                                        
                        Id prodIds = allocateProd.Inventory_Location_Product__r.Products__c;                              
                        requiredQuantity = reqProductQuantityMap1.get(allocateProd.Inventory_Location_Product__r.Products__c);                    
                        if(requiredQuantity != 0.0){                               
                            allocatingQuantity = allocateProd.Available_Quantity__c;
                            if(allocatingQuantity <= requiredQuantity && allocatingQuantity != 0){                                                       
                                if(allocateProd.Available_Quantity__c != null){
                                    allocateProd.Reserved_Quantity__c = allocateProd.Reserved_Quantity__c + allocatingQuantity;
                                                                   
                                    IlPLIQuan.put(allocateProd.Id,allocatingQuantity);                                                          
                                    if(productAndILPLAllocated.containsKey(prodIds))
                                    {
                                        List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                                        usedILPLI = productAndILPLAllocated.get(prodIds);
                                        usedILPLI.add(allocateProd);
                                        productAndILPLAllocated.put(prodIds,usedILPLI);  
                                ILPLIPSNMapForAutoStockReserve.put(allocateProd.Product_Serial_Number__c,allocateProd.id);
                               system.debug('ILPLIPSNMapForAutoStockReserve'+ILPLIPSNMapForAutoStockReserve);
                                    }
                                    else{
                                        List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                                        usedILPLI.add(allocateProd);
                                        productAndILPLAllocated.put(prodIds,usedILPLI); 
                                   ILPLIPSNMapForAutoStockReserve.put(allocateProd.Product_Serial_Number__c,allocateProd.id);
                               system.debug('ILPLIPSNMapForAutoStockReserve'+ILPLIPSNMapForAutoStockReserve);
                                    }
                                }
                                requiredQuantity = requiredQuantity - allocatingQuantity;                            
                            }else if(allocatingQuantity > requiredQuantity){                                                     
                                if(allocateProd.Available_Quantity__c != null){                       
                                    allocateProd.Reserved_Quantity__c = allocateProd.Reserved_Quantity__c + requiredQuantity;                                                              
                                    IlPLIQuan.put(allocateProd.Id,requiredQuantity);                            
                                    if(productAndILPLAllocated.containsKey(prodIds))
                                    {
                                        List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                                        usedILPLI = productAndILPLAllocated.get(prodIds);
                                        usedILPLI.add(allocateProd);
                                        productAndILPLAllocated.put(prodIds,usedILPLI); 
                                   ILPLIPSNMapForAutoStockReserve.put(allocateProd.Product_Serial_Number__c,allocateProd.id);
                                 system.debug('ILPLIPSNMapForAutoStockReserve'+ILPLIPSNMapForAutoStockReserve);
                                    }
                                    else{
                                        List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                                        usedILPLI.add(allocateProd);
                                        productAndILPLAllocated.put(prodIds,usedILPLI);
                                     ILPLIPSNMapForAutoStockReserve.put(allocateProd.Product_Serial_Number__c,allocateProd.id);
                                  system.debug('ILPLIPSNMapForAutoStockReserve'+ILPLIPSNMapForAutoStockReserve);
                                    }
                                }                                              
                                requiredQuantity = 0.0;                                               
                            }                                                                                                                                    
                            reqProductQuantityMap1.put(allocateProd.Inventory_Location_Product__r.Products__c,requiredQuantity);                        
                        } //end of if statement
                    }  //end of for loop                        
                    update ilpliList;
                    
                    //allocate inventory in ILPLI object ends here
                }else{
                    return false; //no sufficient stock to do allocation 
                }
                 //code to update PSN status as Allocated after stock reserve on 06-07-2021
                    system.debug('ILPLIPSNMapForAutoStockReserve'+ILPLIPSNMapForAutoStockReserve);
                    system.debug('ILPLIPSNMapForAutoStockReserve.keySet()'+ILPLIPSNMapForAutoStockReserve.keySet());
                    fullPSNList = [Select Id,Name,Status__c From Product_Serial_Number__c where Id IN :ILPLIPSNMapForAutoStockReserve.keySet()];   
                    system.debug('fullPSNList>>.'+fullPSNList);
                    for(Product_Serial_Number__c psn : fullPSNList){
                        system.debug('psn>>.'+psn);
                        Product_Serial_Number__c psnObj = new Product_Serial_Number__c(); 
                        if(ILPLIPSNMapForAutoStockReserve.containsKey(psn.Id)){                                          
                            psnObj.Status__c = 'Used';                    
                            psnObj.Id = psn.Id;
                            PSNListToUpdate.add(psnObj);
                        }   
                    }            
                    update PSNListToUpdate; 
                    system.debug('PSNListToUpdate>>.'+PSNListToUpdate);
                    //code ends here
                //check whether there is enough stock to do allocation ends here            
                if(!productAndILPLAllocated.isEmpty()){             
                    //insert data into Sales Order Allocation object
                    Auto_Allocations_For_Manufaturing_Run__c soa = new Auto_Allocations_For_Manufaturing_Run__c();                
                    soa.Manufacturing_Run__c = manfRunId; 
                    insert soa;    
                    //ends here            
                    
                    //insert data into Sales order Allocation Line Item object
                    List<Allocation_Item_Manufaturing_Run__c> soaliList = new List<Allocation_Item_Manufaturing_Run__c>();
                    for(Id proId : productAndILPLAllocated.keySet()){
                        if(reqProductQuantityMap1.containsKey(proId)){
                            for(Inventory_Location_Product_Line_Item__c ilpli : productAndILPLAllocated.get(proId)){                            
                                Allocation_Item_Manufaturing_Run__c soali = new Allocation_Item_Manufaturing_Run__c();
                                soali.Auto_Allocation_For_Manufaturing_Run__c = soa.Id;
                                soali.Inventory_Location_Product_Line_Item__c = ilpli.Id;
                                soali.Status__c = 'Allocated';                                             
                                orderedQuantity = orderedQuantitymap.get(proId);                      
                                soali.Ordered_Quantity__c = orderedQuantity;
                                soali.Selected_Quantity__c = IlPLIQuan.get(ilpli.Id);                                               
                                allocatedQnty = allocatedQnty + IlPLIQuan.get(ilpli.Id);                        
                                remainingQnty = allocatedQnty;                        
                                soali.Remaining_Quantity__c = orderedQuantity - remainingQnty;
                                soali.Product__c = proId;
                                soali.Unit_Price__c = ilpli.Unit_Price__c;
                                soaliList.add(soali);
                            } //end of inner for loop
                        } //end of if statement        
                    } //end of outer for loop
                    insert soaliList;                               
                    //ends here                
                    
                    //handle PI and ILP starts here (updating PI and ILP quantities)                
                    Map<Id,Decimal> allocatedILPs = new Map<Id,Decimal>(); //used to store ILP's and its respective allocated quantity
                    Map<Id,Decimal> allocatedPIs = new Map<Id,Decimal>(); //used to store PI's and its respective allocated quantity
                                    
                } //end of if statement 
                return true; //if allocation success    
            }catch(Exception e){            
                createErrorLog.insertError('ManufacturingRun',e.getMessage(),'Method - AllocateStockUsingFIFODuringManufactureRun',null,'',e.getStackTraceString(),UserInfo.getUserId());
                return null;
            }
        }
        return true; //if allocation success
    }
    
    @AuraEnabled
    public Static String revertAutopickedStock(Id manfRunId){
        String status = 'Success';
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Allocation_Item_Manufaturing_Run__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')  
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Auto_Allocations_For_Manufaturing_Run__c')
            
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'id','sigmaerpdev2__Reserved_Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Allocation_Item_Manufaturing_Run__c',new set<String>{'Id','sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Selected_Quantity__c','sigmaerpdev2__Auto_Allocation_For_Manufaturing_Run__r.sigmaerpdev2__Manufacturing_Run__c '}) 
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Auto_Allocations_For_Manufaturing_Run__c',new set<String>{'id','name','sigmaerpdev2__Manufacturing_Run__c'})
            
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'sigmaerpdev2__Reserved_Quantity__c'})
            )
        {
            List<Allocation_Item_Manufaturing_Run__c> allocObjList = new List<Allocation_Item_Manufaturing_Run__c>();
            Map<Id, Decimal> ilpliIdQnMap = new Map<Id, Decimal>(); 
            List<Inventory_Location_Product_Line_Item__c> ilpliList = new List<Inventory_Location_Product_Line_Item__c>();
            List<Auto_Allocations_For_Manufaturing_Run__c> alreadyAllocatedList = new List<Auto_Allocations_For_Manufaturing_Run__c>();
            try{
                allocObjList = [select Id,Inventory_Location_Product_Line_Item__c,                                               
                                Selected_Quantity__c from Allocation_Item_Manufaturing_Run__c 
                                where Auto_Allocation_For_Manufaturing_Run__r.Manufacturing_Run__c = :manfRunId];
                if(allocObjList.size() > 0){
                    for(Allocation_Item_Manufaturing_Run__c allocObj : allocObjList){
                        ilpliIdQnMap.put(allocObj.Inventory_Location_Product_Line_Item__c, allocObj.Selected_Quantity__c);
                    }
                }       
                if(ilpliIdQnMap.size() > 0){
                    ilpliList = [select id,Reserved_Quantity__c from Inventory_Location_Product_Line_Item__c
                                    where id in : ilpliIdQnMap.keySet()];           
                }
                if(ilpliList.size() > 0){
                    for(Inventory_Location_Product_Line_Item__c ilpliObj : ilpliList){
                        ilpliObj.Reserved_Quantity__c = ilpliObj.Reserved_Quantity__c - ilpliIdQnMap.get(ilpliObj.Id);
                    }
                    update ilpliList;
                }
                //delete autopicked stock entries from Auto Allocations object or else duplicate records will come up after Stock is reserved
                alreadyAllocatedList = [select id,name from Auto_Allocations_For_Manufaturing_Run__c where Manufacturing_Run__c = :manfRunId];
                if(alreadyAllocatedList.size() > 0){
                    delete alreadyAllocatedList;
                }           
                //ends here
                
                return status;
            }catch(Exception e){
                createErrorLog.insertError('ManufacturingRun',e.getMessage(),'Method - revertAutopickedStock',null,'',e.getStackTraceString(),UserInfo.getUserId());
                status = 'Error';
                return status;
            }
        }
        return status;
    }
    
    @AuraEnabled
    public static List<innerWrapper> getAutopickedStock(Id manfRunId, Id ProductId){        
        List<innerWrapper> wrapProdListAutopicked = new List<innerWrapper>(); //full List for Autopicked flow                        
        //fetch allocated stock from soali object        
        List<Allocation_Item_Manufaturing_Run__c> allocObj = new List<Allocation_Item_Manufaturing_Run__c>();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Allocation_Item_Manufaturing_Run__c')
            
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Allocation_Item_Manufaturing_Run__c',new set<String>{'Id','name','sigmaerpdev2__Inventory_Location_Product_Line_Item__r.sigmaerpdev2__Product_Serial_Number__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__r.sigmaerpdev2__Inventory_Location_Product__r.Name','sigmaerpdev2__Inventory_Location_Product_Line_Item__r.Name','sigmaerpdev2__Ordered_Quantity__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Selected_Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Auto_Allocation_For_Manufaturing_Run__r.sigmaerpdev2__Manufacturing_Run__c','sigmaerpdev2__Product__c'})
            )
        {   
            try{ 
                        
                allocObj = [select Id,name,Inventory_Location_Product_Line_Item__r.Product_Serial_Number__c,                        
                            Inventory_Location_Product_Line_Item__c,                                                
                            Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Name,
                            Inventory_Location_Product_Line_Item__r.Name,                                                
                            Ordered_Quantity__c,Unit_Price__c,Selected_Quantity__c from Allocation_Item_Manufaturing_Run__c where Auto_Allocation_For_Manufaturing_Run__r.Manufacturing_Run__c = :manfRunId
                            and Product__c = :ProductId];
                for(Allocation_Item_Manufaturing_Run__c soali : allocObj){
                    innerWrapper iwrap = new innerWrapper(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);                        
                                                      
                    iwrap.ilpAvailQuantity = null;                 
                    iwrap.ilpName = soali.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Name;
                    iwrap.ilpliName = soali.Inventory_Location_Product_Line_Item__r.Name;                
                    iwrap.ilpId = soali.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Id; 
                    iwrap.ilpliId = soali.Inventory_Location_Product_Line_Item__c; 
                    //need to fix below line  - data model changes
                    //iwrap.locationId = soali.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__c;                                
                    iwrap.srNumName = soali.Inventory_Location_Product_Line_Item__r.Product_Serial_Number__c;                                
                    iwrap.selQuantity = soali.Selected_Quantity__c;
                    iwrap.ppId = null;
                    iwrap.ppliId = null;                    
                    iwrap.prodUOM = null;
                    iwrap.prodExpDate = null; 
                    iwrap.unitPrice = soali.Unit_Price__c;                    
                    wrapProdListAutopicked.add(iwrap);
                } 
                return wrapProdListAutopicked;
            }           
            catch(Exception e){
                createErrorLog.insertError('ManufacturingRun',e.getMessage(),'Method - getAutopickedStock',null,'',e.getStackTraceString(),UserInfo.getUserId());
                return null;
            }
        }
        //ends here 
        return wrapProdListAutopicked;
    }
    //ends here        
    
    //Do Automatic Reservation of Stock For Manufacturing Run Starts here
    @AuraEnabled
    public static String AutoReserveStockForManufactureRun(Id manRunID, Manufacturing_Run__c manufactureRunObj, String data, Boolean fromSkipAllocFlow){  
        String stockExists = 'true'; //suggests whether there is not enough stock to do allocation or not
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run__c') 
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c') 
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Products__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Auto_Allocations_For_Manufaturing_Run__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Allocation_Item_Manufaturing_Run__c') 
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Recipe__c') 
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run_Allocation__c')  
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run_Allocation_Line_Items__c')  
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c') 
            
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run__c',new set<String>{'sigmaerpdev2__Required_Quantity__c','Id','sigmaerpdev2__Recipe__c','sigmaerpdev2__Unit_Price__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Products__c',new set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__r.name','sigmaerpdev2__Manufacturing_Run__c','sigmaerpdev2__Product__r.sigmaerpdev2__Stock_Item__c','RecordTypeId'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'Id','sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Products__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'name','sigmaerpdev2__Inventory_Location_Product__r.Id','sigmaerpdev2__Inventory_Location_Product__r.Products__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Products__r.Name','sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__Received_Date__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Product_Expiry_Date__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Allocation_Item_Manufaturing_Run__c',new set<String>{'Id','name','sigmaerpdev2__Inventory_Location_Product_Line_Item__r.sigmaerpdev2__Product_Serial_Number__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Location_Name__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__r.sigmaerpdev2__Inventory_Location_Product__r.Name','sigmaerpdev2__Inventory_Location_Product_Line_Item__r.Name','sigmaerpdev2__Inventory_Location_Product_Line_Item__r.sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__r.Name','sigmaerpdev2__Inventory_Location_Product_Line_Item__r.sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Products__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Selected_Quantity__c','sigmaerpdev2__Ordered_Quantity__c','sigmaerpdev2__Auto_Allocation_For_Manufaturing_Run__r.sigmaerpdev2__Manufacturing_Run__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'id','name','sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Product_UOM__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Recipe__c',new set<String>{'id','sigmaerpdev2__Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new set<String>{'Id','Name','sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__ProductCode__c','sigmaerpdev2__Comments__c'})
            
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'sigmaerpdev2__Reserved_Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Manufacturing_Run__c',new set<String>{'sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Total_Cost__c','sigmaerpdev2__Status__c','sigmaerpdev2__Produced_Quantity__c'}) 
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'sigmaerpdev2__Reserved_Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Allocation_Item_Manufaturing_Run__c',new set<String>{'sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Status__c','sigmaerpdev2__Ordered_Quantity__c','sigmaerpdev2__Selected_Quantity__c','sigmaerpdev2__Remaining_Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Unit_Price__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Manufacturing_Run_Allocation_Line_Items__c',new set<String>{'sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Expiry_Date__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Manufacturing_Run_Allocation__c',new set<String>{'sigmaerpdev2__Manufacturing_Run__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Status__c','sigmaerpdev2__Via_Autopick__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new set<String>{'sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Comments__c'})     
            
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Allocation_Item_Manufaturing_Run__c',new Set<String>{'sigmaerpdev2__Auto_Allocation_For_Manufaturing_Run__c'})
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Auto_Allocations_For_Manufaturing_Run__c',new Set<String>{'sigmaerpdev2__Manufacturing_Run__c'})
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Manufacturing_Run_Allocation_Line_Items__c',new Set<String>{'sigmaerpdev2__Manufacturing_Run_Allocation__c'})
            )
        {
            Map<Id,Decimal> reqProductQuantityMap1 = new Map<Id,Decimal>(); // store Product Id and its required Quantity
            Map<Id,Decimal> orderedQuantitymap = new Map<Id,Decimal>(); //used to store required Product Id and its Quantity
            Decimal requiredQuantity = 0.0;
            Decimal allocatingQuantity = 0.0;
            Decimal orderedQuantity = 0.0;
            Decimal allocatedQnty = 0.0;
            Decimal remainingQnty = 0.0;        
            Decimal reqQty = manufactureRunObj.Required_Quantity__c;                         
            
            Map<Id,Id> ILPLIPSNMapForAutoStockReserve = new Map<Id,Id>(); //used to store  the PSN Id and ILPLI Id to change the PSN status available to Allocated    
            List<Product_Serial_Number__c> fullPSNList; // used to store query results for PSN 
            List<Product_Serial_Number__c> PSNListToUpdate = new List<Product_Serial_Number__c>();
            
            //fetch the modified quantity from the Manufacturing run object which will be used as the Quantity for Reserve Stock
            Map<Id,Decimal> modProdQuanMap = new Map<Id,Decimal>();
            ManufacturingWrap manuFacWrap = (ManufacturingWrap)JSON.deserialize(data, ManufacturingWrap.class);
            for(productComp pc : manuFacWrap.productCompList){            
                if(pc.StockItem == true){
                    modProdQuanMap.put(pc.ProdID, pc.Quantity);
                }            
            }
            Map<Id,Decimal> packMatQuanMap = new Map<Id,Decimal>(modProdQuanMap);
            for(packagingMaterial pc1 : manuFacWrap.packagingMatList){            
                if(pc1.StockItem == true){
                    packMatQuanMap.put(pc1.ProdID, pc1.Quantity);
                }           
            }        
            //ends here
            
            Map<id,List<Inventory_Location_Product__c>> prodIlpMap = new Map<id,List<Inventory_Location_Product__c>>(); //store Product and its respective ILPs
            Map<id,List<Inventory_Location_Product_Line_Item__c>> IlpandILPLIListMap = new Map<id,List<Inventory_Location_Product_Line_Item__c>>(); //store Product and its respective ILPs
            try{            
                Map<Id,Decimal> prodMap = new Map<Id,Decimal>();
                Map<Id,String> ilpListMap1 = new Map<Id,String>();            
                Map<Id,String> prodNameMap = new Map<Id,String>(); 
                
                Id AdditionalProdRecID = Schema.SObjectType.Manufacturing_Products__c.getRecordTypeInfosByName().get('Additional Products').getRecordTypeId();            
                List<Manufacturing_Products__c> OrderLineList = [select Product__c,Quantity__c,Product__r.name from Manufacturing_Products__c where Manufacturing_Run__c = :manRunID and Product__c != null and Product__r.Stock_Item__c != false and RecordTypeId != :AdditionalProdRecID];            
                for(Manufacturing_Products__c tdiList : OrderLineList){                
                    prodNameMap.put(tdiList.Product__c, tdiList.Product__r.name);                               
                    prodMap.put(tdiList.Product__c, packMatQuanMap.get(tdiList.Product__c));
                    reqProductQuantityMap1.put(tdiList.Product__c, packMatQuanMap.get(tdiList.Product__c)); 
                    orderedQuantitymap.put(tdiList.Product__c, packMatQuanMap.get(tdiList.Product__c));                
                }            
                List<Inventory_Location_Product__c> ilpList = [select id,name,Products__c from Inventory_Location_Product__c where Net_Quantity__c > 0 and Products__c In :prodMap.keySet()];            
                for(Inventory_Location_Product__c ilpListItems : ilpList){
                    ilpListMap1.put(ilpListItems.Id,ilpListItems.Name);                
                    Id prodIds = ilpListItems.Products__c; 
                    if(prodIlpMap.containsKey(prodIds))
                    {
                        List<Inventory_Location_Product__c> usedILP = new List<Inventory_Location_Product__c>();
                        usedILP = prodIlpMap.get(prodIds);
                        usedILP.add(ilpListItems);
                        prodIlpMap.put(prodIds,usedILP);                         
                    }
                    else{
                        List<Inventory_Location_Product__c> usedILP = new List<Inventory_Location_Product__c>();
                        usedILP.add(ilpListItems);
                        prodIlpMap.put(prodIds,usedILP);                         
                    }
                }
                            
                List<Inventory_Location_Product_Line_Item__c> ilpliList = new List<Inventory_Location_Product_Line_Item__c>();
                List<Inventory_Location_Product_Line_Item__c> tempilpliList = new List<Inventory_Location_Product_Line_Item__c>();
                List<Inventory_Location_Product_Line_Item__c> additionalILPLIList = new List<Inventory_Location_Product_Line_Item__c>();
                Decimal reqStock  = 0.0;
                Set<Id> insuffStockSet = new Set<Id>();
                            
                tempilpliList = [select name,Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Name,
                                 Reserved_Quantity__c,Available_Quantity__c,Received_Date__c,Unit_Price__c,Product_Serial_Number__r.Name from Inventory_Location_Product_Line_Item__c where 
                                 Inventory_Location_Product__c in :ilpListMap1.keySet() and Product_Expiry_Date__c != null and Product_Expiry_Date__c > TODAY and Available_Quantity__c > 0];
                
                
                //new changes in selecting ilpli made on 8/5/2018 which will be a combination of both records which consists of
                // Updated_Exp_Date__c > today and Updated_Exp_Date__c which are null so that to fulfill the required stock.
                            
                if(tempilpliList.size() > 0){ //if expiry date exists choose those ilpli's to do allocation
                    ilpliList = [select name,Inventory_Location_Product__r.Id,Product_Serial_Number__c,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Name,
                                 Reserved_Quantity__c,Available_Quantity__c,Received_Date__c,Unit_Price__c,Product_Serial_Number__r.Name from Inventory_Location_Product_Line_Item__c where 
                                 Inventory_Location_Product__c in :ilpListMap1.keySet() and Product_Expiry_Date__c > TODAY and Available_Quantity__c > 0 order by Product_Expiry_Date__c ASC];
                    for(Id prodID : orderedQuantitymap.keySet()){
                        Decimal enoughStock = 0.0;                
                        reqStock = orderedQuantitymap.get(prodID);
                        for(Inventory_Location_Product_Line_Item__c ilpItr : ilpliList){ 
                            if(ilpItr.Inventory_Location_Product__r.Products__c == prodID){
                                enoughStock = enoughStock + ilpItr.Available_Quantity__c;
                            }
                        }
                        if(enoughStock < reqStock){                        
                            insuffStockSet.add(prodID);
                        }                
                    }                
                    if(insuffStockSet.size() > 0){ // if still stock is low,again pick from the remaining ilpli's which doesn't have expiry date and combine both the lists
                        additionalILPLIList = [select name,Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Name,
                                               Reserved_Quantity__c,Available_Quantity__c,Received_Date__c,Unit_Price__c,Product_Serial_Number__r.Name from Inventory_Location_Product_Line_Item__c where 
                                               Inventory_Location_Product__c in :ilpListMap1.keySet() and Inventory_Location_Product__r.Products__c in :insuffStockSet and Available_Quantity__c > 0 and Product_Expiry_Date__c = null order by Received_Date__c ASC];
                        
                        ilpliList.addAll(additionalILPLIList);
                    }
                }else{ //else choose all ilpli's to do allocation
                    ilpliList = [select name,Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Name,
                                 Reserved_Quantity__c,Available_Quantity__c,Product_Serial_Number__c,Received_Date__c,Unit_Price__c,Product_Serial_Number__r.Name from Inventory_Location_Product_Line_Item__c where 
                                 Inventory_Location_Product__r.Id in :ilpListMap1.keySet() and Available_Quantity__c > 0 order by Received_Date__c ASC];
                }                     
                for(Inventory_Location_Product_Line_Item__c ilpliItr : ilpliList){
                    Id ILPIds = ilpliItr.Inventory_Location_Product__r.Id; 
                    if(IlpandILPLIListMap.containsKey(ILPIds))
                    {
                        List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                        usedILPLI = IlpandILPLIListMap.get(ILPIds);
                        usedILPLI.add(ilpliItr);
                        IlpandILPLIListMap.put(ILPIds,usedILPLI);                         
                    }
                    else{
                        List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                        usedILPLI.add(ilpliItr);
                        IlpandILPLIListMap.put(ILPIds,usedILPLI);                         
                    }

                }            
                
                //added to restrict partial allocation if there is insufficient stock                       
                Decimal lineItemOrderedQuantity = 0.0;           
                Map<id,List<Inventory_Location_Product_Line_Item__c>> productAndILPLAllocated = new Map<id,List<Inventory_Location_Product_Line_Item__c>>();
                Map<id,Decimal> IlPLIQuan = new Map<id,Decimal>();
                List<Inventory_Location_Product_Line_Item__c> ilpliListToBeUpdated = new List<Inventory_Location_Product_Line_Item__c>();
                
                String lowStockProdName = '';
                for(Id recordId : prodMap.keySet()){
                    Decimal tempQuantityTotal = 0.0;
                    lineItemOrderedQuantity = prodMap.get(recordId);                
                    if(prodIlpMap.get(recordId) != null){
                        for(Inventory_Location_Product__c recordILPId : prodIlpMap.get(recordId)){                          
                            if(IlpandILPLIListMap.get(recordILPId.Id) != null){
                                for(Inventory_Location_Product_Line_Item__c ilpliRecord : IlpandILPLIListMap.get(recordILPId.Id)){                                                                  
                                    tempQuantityTotal = tempQuantityTotal + ilpliRecord.Available_Quantity__c;  
                                    system.debug('ilpliRecord>'+ilpliRecord);
                                }
                            }                    
                        }                     
                    }                             
                    if(tempQuantityTotal < lineItemOrderedQuantity){
                        if(lowStockProdName != '')
                            lowStockProdName = lowStockProdName+','+prodNameMap.get(recordId);                    
                        else
                            lowStockProdName = prodNameMap.get(recordId);                                                         
                        stockExists = 'false';
                    }               
                }                               
                if(stockExists == 'false'){                
                    stockExists = 'false'+'_'+lowStockProdName;
                    return stockExists;
                }else{ //Stock exists continue with the allocation process
                    for(Id recordId : prodMap.keySet()){                
                        for(Inventory_Location_Product__c recordILPId : prodIlpMap.get(recordId)){
                            if(IlpandILPLIListMap.get(recordILPId.Id) != null){
                                for(Inventory_Location_Product_Line_Item__c allocateProd : IlpandILPLIListMap.get(recordILPId.Id)){                                                                                                 
                                    Id prodIds = allocateProd.Inventory_Location_Product__r.Products__c;                                                                                                                              
                                    requiredQuantity = reqProductQuantityMap1.get(allocateProd.Inventory_Location_Product__r.Products__c);                                
                                    if(requiredQuantity != 0.0){          
                                        allocatingQuantity = allocateProd.Available_Quantity__c;                                    
                                        if(allocatingQuantity <= requiredQuantity && allocatingQuantity != 0){
                                            if(allocateProd.Available_Quantity__c != null){
                                                allocateProd.Reserved_Quantity__c = allocateProd.Reserved_Quantity__c + allocatingQuantity;                                            
                                                IlPLIQuan.put(allocateProd.Id,allocatingQuantity);                                                          
                                                if(productAndILPLAllocated.containsKey(prodIds))
                                                {
                                                    List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                                                    usedILPLI = productAndILPLAllocated.get(prodIds);
                                                    usedILPLI.add(allocateProd);
                                                     system.debug('usedILPLI>'+usedILPLI);
                                                    productAndILPLAllocated.put(prodIds,usedILPLI);   
                                                    system.debug('productAndILPLAllocated>'+productAndILPLAllocated);
                                                    ILPLIPSNMapForAutoStockReserve.put(allocateProd.Product_Serial_Number__c,allocateProd.id);
                                    				system.debug('ILPLIPSNMapForAutoStockReserve'+ILPLIPSNMapForAutoStockReserve);
                                                }
                                                else{
                                                    List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                                                    usedILPLI.add(allocateProd);
                                                     system.debug('usedILPLI>'+usedILPLI);
                                                    productAndILPLAllocated.put(prodIds,usedILPLI);  
                                                    system.debug('productAndILPLAllocated>'+productAndILPLAllocated);
                                                    ILPLIPSNMapForAutoStockReserve.put(allocateProd.Product_Serial_Number__c,allocateProd.id);
                                    				system.debug('ILPLIPSNMapForAutoStockReserve'+ILPLIPSNMapForAutoStockReserve);
                                                }
                                            }
                                            requiredQuantity = requiredQuantity - allocatingQuantity;
                                        }else if(allocatingQuantity > requiredQuantity){                              
                                            if(allocateProd.Available_Quantity__c != null){                       
                                                allocateProd.Reserved_Quantity__c = allocateProd.Reserved_Quantity__c + requiredQuantity;                                                                                       
                                                IlPLIQuan.put(allocateProd.Id,requiredQuantity);                            
                                                if(productAndILPLAllocated.containsKey(prodIds))
                                                {
                                                    List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                                                    usedILPLI = productAndILPLAllocated.get(prodIds);
                                                    usedILPLI.add(allocateProd);
                                                    productAndILPLAllocated.put(prodIds,usedILPLI);    
                                                    ILPLIPSNMapForAutoStockReserve.put(allocateProd.Product_Serial_Number__c,allocateProd.id);
                                    				system.debug('ILPLIPSNMapForAutoStockReserve'+ILPLIPSNMapForAutoStockReserve);
                                                }
                                                else{
                                                    List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                                                    usedILPLI.add(allocateProd);
                                                    productAndILPLAllocated.put(prodIds,usedILPLI);
                                                    ILPLIPSNMapForAutoStockReserve.put(allocateProd.id,allocateProd.Product_Serial_Number__c);
                                    				system.debug('ILPLIPSNMapForAutoStockReserve'+ILPLIPSNMapForAutoStockReserve);
                                                }
                                            }                   
                                            requiredQuantity = 0.0;                   
                                        }                                                                                                     
                                        reqProductQuantityMap1.put(allocateProd.Inventory_Location_Product__r.Products__c,requiredQuantity);
                                    } //end of if statement
                                    ilpliListToBeUpdated.add(allocateProd);
                                    
                                }
                            }                        
                        }       
                    }                
                    update ilpliListToBeUpdated; //update full ilpliList
                    system.debug('ilpliListToBeUpdated>>>>...'+ilpliListToBeUpdated);
                    if(!productAndILPLAllocated.isEmpty()){             
                        //insert data into Sales Order Allocation object
                        Auto_Allocations_For_Manufaturing_Run__c soa = new Auto_Allocations_For_Manufaturing_Run__c();                
                        soa.Manufacturing_Run__c = manufactureRunObj.Id;                                                           
                        insert soa;    
                        //ends here            
                        
                        //insert data into Sales order Allocation Line Item object
                        List<Allocation_Item_Manufaturing_Run__c> soaliList = new List<Allocation_Item_Manufaturing_Run__c>();
                        for(Id proId : productAndILPLAllocated.keySet()){
                            if(reqProductQuantityMap1.containsKey(proId)){
                                for(Inventory_Location_Product_Line_Item__c ilpli : productAndILPLAllocated.get(proId)){
                                    system.debug('ilpli>'+ilpli);
                                    Allocation_Item_Manufaturing_Run__c soali = new Allocation_Item_Manufaturing_Run__c();
                                    soali.Auto_Allocation_For_Manufaturing_Run__c = soa.Id;                              
                                    soali.Inventory_Location_Product_Line_Item__c = ilpli.Id;
                                    soali.Status__c = 'Allocated';                                             
                                    orderedQuantity = orderedQuantitymap.get(proId);                      
                                    soali.Ordered_Quantity__c = orderedQuantity;  
                                    soali.Selected_Quantity__c = IlPLIQuan.get(ilpli.Id);                                              
                                    allocatedQnty = allocatedQnty + IlPLIQuan.get(ilpli.Id);                        
                                    remainingQnty = allocatedQnty;                        
                                    soali.Remaining_Quantity__c = orderedQuantity - remainingQnty;
                                    soali.Product__c = proId;
                                    soali.Unit_Price__c = ilpli.Unit_Price__c;
                                    soaliList.add(soali);
                                } //end of inner for loop
                            } //end of if statement        
                        } //end of outer for loop
                        insert soaliList;                
                        //ends here                
                        
                        //Map<Id,Decimal> allocatedPIs = new Map<Id,Decimal>(); //used to store PI's and its respective allocated quantity
                                            
                    } //end of if statement 
                    
                    
                    //get back the allocated data from SOA and SOALI objects to save the Autopicked Stock
                    List<listOfProductsWrapper> wrapProdListOuter = new List<listOfProductsWrapper>(); //list of all Products and its ilpli list
                    List<ProductWrapper> wrapProdListManual = new List<ProductWrapper>(); //list of indiv. Products and its ilpli list
                    Id ProdId;
                    String prodName; 
                    String status;
                    String prodAttrType;
                    String prodBomType; 
                    String productUOM;
                    Decimal totalAvailableQty; 
                    
                    
                    //fetch allocated stock from soali object        
                    List<Allocation_Item_Manufaturing_Run__c> allocObj = new List<Allocation_Item_Manufaturing_Run__c>();
                    allocObj = [select Id,name,Inventory_Location_Product_Line_Item__r.Product_Serial_Number__c,                            
                                Inventory_Location_Product_Line_Item__c,Location_Name__c,                                                       
                                Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Name,
                                Inventory_Location_Product_Line_Item__r.Name,
                                Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name,
                                Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Products__c,                            
                                Unit_Price__c,Selected_Quantity__c,Ordered_Quantity__c from Allocation_Item_Manufaturing_Run__c where Auto_Allocation_For_Manufaturing_Run__r.Manufacturing_Run__c = :manufactureRunObj.Id];
                    
                    for(Product2 prd :[select id,name,Attribute_Type__c,Product_UOM__c from Product2 where id in : prodMap.keySet()]){
                        List<innerWrapper> wrapProdListAutopicked = new List<innerWrapper>(); //full List for Autopicked Products 
                        ProdId = prd.id;
                        prodName = prd.name;
                        prodAttrType = prd.Attribute_Type__c;                    
                        totalAvailableQty = 0.0;
                        if(prd.Product_UOM__c != null){
                            productUOM = prd.Product_UOM__c;
                        }
                        for(Allocation_Item_Manufaturing_Run__c soali : allocObj){                       
                            if(soali.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Products__c == ProdId){
                                innerWrapper iwrap = new innerWrapper(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);                                                                                
                                iwrap.ilpAvailQuantity = null;                             
                                iwrap.ilpName = soali.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Name;
                                iwrap.ilpliName = soali.Inventory_Location_Product_Line_Item__r.Name;                            
                                iwrap.ilpId = soali.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Id; 
                                iwrap.ilpliId = soali.Inventory_Location_Product_Line_Item__c; 
                                //need to fix this loc issue
                                iwrap.locationId = soali.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.Location__c;                                                        
                                iwrap.srNumName = soali.Inventory_Location_Product_Line_Item__r.Product_Serial_Number__c;                            
                                iwrap.selQuantity = soali.Selected_Quantity__c;
                                iwrap.unitPrice = soali.Unit_Price__c;                            
                                iwrap.ppId = null;
                                iwrap.ppliId = null;                    
                                iwrap.prodUOM = null;
                                iwrap.prodExpDate = null;                    
                                wrapProdListAutopicked.add(iwrap);
                            }
                        }                    
                        wrapProdListManual.add(new ProductWrapper(ProdId,prodName,prodMap.get(prd.id),prodAttrType,prodBomType,wrapProdListAutopicked,productUOM,null,true,totalAvailableQty,null));
                    }
                    wrapProdListOuter.add(new listOfProductsWrapper(wrapProdListManual));                   
                    //ends here
                    
                    Map<Id,Decimal> prodUnitPriceMap = new Map<Id,Decimal>(); //store respective product and its unit price value[sum of all ilpli's unit prices]
                    //do the actual saving of Manufacture run and its line items
                    List<ManufacturingRun.listOfProductsWrapper> container = wrapProdListOuter;
                    List<ProductWrapper> AllData = new List<ProductWrapper>();
                    List<Id> productsList = new List<Id>(); //added to use while updating Inv. Location 
                    Set<ID> packProdIDList = new Set<ID>();
                    for(ManufacturingRun.listOfProductsWrapper temp : container){
                        for(ProductWrapper p1 : temp.mainWrapProdList){                        
                            Decimal avgUnitPrc = 0.0;
                            List<innerWrapper> innerListData = new List<innerWrapper>();
                            for(innerWrapper temp1 : p1.wrapProdList){                                            
                                if(temp1.selQuantity != null && temp1.selQuantity != 0){  
                                    Decimal totUnitPrc = 0.0;                                 
                                    if(temp1.unitPrice != null){
                                        totUnitPrc = temp1.unitPrice * temp1.selQuantity;
                                    }                         
                                    avgUnitPrc = avgUnitPrc + totUnitPrc;                                                           
                                    innerListData.add(new innerWrapper(temp1.selQuantity,temp1.srNumId,temp1.lotName,temp1.lotExpiryDate,temp1.ilpName,temp1.ilpAvailQuantity,temp1.lotId,temp1.ilpId,temp1.ilpliId,temp1.locationId,temp1.srNumName,temp1.ppId,temp1.ppliId,p1.prodUOM,temp1.prodExpDate,null,temp1.ilpliName,temp1.unitPrice,null,null));
                                } 
                            }                                                  
                            p1.avgUnitPrice = avgUnitPrc; 
                            prodUnitPriceMap.put(p1.prodId,p1.avgUnitPrice);                      
                            AllData.add(new ProductWrapper(p1.prodId,p1.prodName,p1.requiredQnt,p1.prodAttributeType,p1.prodBomType,innerListData,p1.prodUOM,manufactureRunObj.Id,p1.allocatedViaAutopickOrManual,null,p1.avgUnitPrice));
                            productsList.add(p1.prodId);  
                            packProdIDList.add(p1.prodId);
                        }           
                    }   
                                    
                    //store the overall unit price in Manufacturing run obj by fetching it from Reserved Stock Products and Additonal Products and also update Status to Stock Reserved
                    //ManufacturingWrap manuFacWrap = (ManufacturingWrap)JSON.deserialize(additionalProducts, ManufacturingWrap.class);
                    Map<Id,Decimal> additionalProductsQuantityMap = new Map<Id,Decimal>(prodUnitPriceMap);
                    for(AdditionalProduct pc2 : manuFacWrap.AdditionalProductList){                
                        additionalProductsQuantityMap.put(pc2.ProdID, pc2.UnitPrice);               
                    }
                    Decimal overallAvgCost = 0.0;
                    for(Id productID : additionalProductsQuantityMap.keySet()){
                        overallAvgCost = overallAvgCost + additionalProductsQuantityMap.get(productID);
                    }
                    
                    Recipe__c recipe=new Recipe__c();
                    recipe=[select id,Quantity__c from Recipe__c where Id=: manufactureRunObj.Recipe__c];
                                                                    
                    List<Manufacturing_Run_Allocation__c> manfList = new List<Manufacturing_Run_Allocation__c>();
                    Set<ID> prodIDList = new Set<ID>(); // used to keep track of ProdIdList - used to update lot
                    Map<Id,List<Manufacturing_Run_Allocation_Line_Items__c>> PPLIMap = new Map<Id,List<Manufacturing_Run_Allocation_Line_Items__c>>();
                    for(ProductWrapper temp : AllData){                     
                        Manufacturing_Run_Allocation__c tempMRAObj = new Manufacturing_Run_Allocation__c();           
                        List<innerWrapper> innerData = temp.wrapProdList;                    
                        for(innerWrapper PLIL :innerData){
                            Manufacturing_Run_Allocation_Line_Items__c mrali = new Manufacturing_Run_Allocation_Line_Items__c();
                            mrali.Inventory_Location_Product__c = PLIL.ilpId;                        
                            mrali.Quantity__c = PLIL.selQuantity;                       
                            mrali.Unit_Price__c = PLIL.unitPrice;
                            mrali.Inventory_Location_Product_Line_Item__c = PLIL.ilpliId;
                            mrali.Expiry_Date__c = PLIL.lotExpiryDate;                                                           
                            if(PPLIMap.ContainsKey(temp.prodId))
                            {
                                List<Manufacturing_Run_Allocation_Line_Items__c> interimList = PPLIMap.get(temp.prodId);
                                interimList.add(mrali);
                                PPLIMap.put(temp.prodId,interimList);                           
                            }else
                            {
                                List<Manufacturing_Run_Allocation_Line_Items__c> newList = new List<Manufacturing_Run_Allocation_Line_Items__c>();
                                newList.add(mrali);
                                PPLIMap.put(temp.prodId,newList);                            
                            }
                        }
                        tempMRAObj.Manufacturing_Run__c = manufactureRunObj.Id;                    
                        tempMRAObj.Product__c = temp.prodId;                       
                        tempMRAObj.Quantity__c = temp.requiredQnt;
                        tempMRAObj.Status__c = 'Confirmed';                    
                        tempMRAObj.Via_Autopick__c = temp.allocatedViaAutopickOrManual;                  
                        manfList.add(tempMRAObj);
                    }
                    //code to fix the issue - multiple package products for the same product if its quantity was more than 1
                    Set<Manufacturing_Run_Allocation__c> finalSet = new Set<Manufacturing_Run_Allocation__c>();
                    List<Manufacturing_Run_Allocation__c> result = manfList;
                    finalSet.addAll(result);
                    result.clear();
                    manfList.clear();
                    result.addAll(finalSet);
                    manfList = result;
                    //ends here
                    insert manfList;
                    
                    List<Manufacturing_Run_Allocation_Line_Items__c> mraliInsertList = new List<Manufacturing_Run_Allocation_Line_Items__c> ();  
                    for(Manufacturing_Run_Allocation__c var : manfList)
                    {           
                        prodIDList.add(var.Product__c); //used to store Product Id which will be used during update Lot 
                        if(PPLIMap.containsKey(var.Product__c))
                        {
                            List<Manufacturing_Run_Allocation_Line_Items__c> tempPPLIList = PPLIMap.get(var.Product__c);                      
                            for(Manufacturing_Run_Allocation_Line_Items__c var1 :tempPPLIList)
                            {   
                                var1.Manufacturing_Run_Allocation__c =  var.Id;                          
                                mraliInsertList.add(var1);                    
                            }
                        }
                    }               
                    insert mraliInsertList;
                    
                    //update Product Inventory Stock 
                    List<Inventory__c> productInventoryList;        
                    productInventoryList = [Select Id,Name,Reserved_Qty__c,Available_Qty__c,ProductCode__c From Inventory__c where ProductCode__c in :prodIDList];                     
                    for(Manufacturing_Run_Allocation__c pp : manfList){
                        for(Inventory__c inv : productInventoryList){
                            if(pp.Product__c == inv.ProductCode__c){                            
                                inv.Reserved_Qty__c = inv.Reserved_Qty__c + pp.Quantity__c;    
                                inv.Available_Qty__c = inv.Available_Qty__c - pp.Quantity__c;
                                inv.Comments__c = ' Inventory updated after "Reserving Stock" for "Manufacturing Process" ';
                            }
                        } 
                    }
                    update productInventoryList;
                    //ends here   
                    //code to update PSN status as Allocated after stock reserve on 06-07-2021
                    system.debug('ILPLIPSNMapForAutoStockReserve'+ILPLIPSNMapForAutoStockReserve);
                    system.debug('ILPLIPSNMapForAutoStockReserve.keySet()'+ILPLIPSNMapForAutoStockReserve.keySet());
                    fullPSNList = [Select Id,Name,Status__c From Product_Serial_Number__c where Id IN :ILPLIPSNMapForAutoStockReserve.keySet()];   
                    system.debug('fullPSNList>>.'+fullPSNList);
                    for(Product_Serial_Number__c psn : fullPSNList){
                        system.debug('psn>>.'+psn);
                        Product_Serial_Number__c psnObj = new Product_Serial_Number__c(); 
                        if(ILPLIPSNMapForAutoStockReserve.containsKey(psn.Id)){                                          
                            psnObj.Status__c = 'Used';                    
                            psnObj.Id = psn.Id;
                            PSNListToUpdate.add(psnObj);
                        }   
                    }            
                    update PSNListToUpdate; 
                    system.debug('PSNListToUpdate>>.'+PSNListToUpdate);
                    //code ends here
                    
                    //update ILP(Reserved qty) flow added on 20-2-2020
                    Map<Id,Decimal> allocatedILPs = new Map<Id,Decimal>(); //used to store ILP's and its respective allocated quantity                  
                    List<Inventory_Location_Product_Line_Item__c> ilpSumList = [select Id,name,Inventory_Location_Product__c from Inventory_Location_Product_Line_Item__c where id in :IlPLIQuan.keySet()];
                    if(ilpSumList.size() > 0){
                        for(Inventory_Location_Product_Line_Item__c ilpliObj1 : ilpSumList){                                                                                    
                            if(!allocatedILPs.containsKey(ilpliObj1.Inventory_Location_Product__c)){
                                allocatedILPs.put(ilpliObj1.Inventory_Location_Product__c, IlPLIQuan.get(ilpliObj1.Id));
                            }else{                          
                                Decimal qty1 = IlPLIQuan.get(ilpliObj1.Id);
                                allocatedILPs.put(ilpliObj1.Inventory_Location_Product__c,(qty1 + IlPLIQuan.get(ilpliObj1.Id)));
                            }
                        }
                    }                    
                    List<Inventory_Location_Product__c> fetchILPList = [select Id,Reserved_Quantity__c from Inventory_Location_Product__c where id in :allocatedILPs.keySet()];
                    if(fetchILPList.size() > 0){
                        for(Inventory_Location_Product__c ilpObj1 : fetchILPList){                           
                            ilpObj1.Reserved_Quantity__c = ilpObj1.Reserved_Quantity__c + allocatedILPs.get(ilpObj1.Id);
                        }
                        update fetchILPList;
                    }
                    //ends here
                               
                    manufactureRunObj.Unit_Price__c = overallAvgCost / reqQty;                
                    manufactureRunObj.Total_Cost__c = manufactureRunObj.Required_Quantity__c * manufactureRunObj.Unit_Price__c;
                    
                    //commented above section and added below two lines on 3/4/2020 
                    //to restrict changing to status to produced - to make he changes as suggested by QA
                   /* if(fromSkipAllocFlow){
                        manufactureRunObj.Status__c = 'Produced'; //set status to Produced
                        manufactureRunObj.Produced_Quantity__c = manufactureRunObj.Required_Quantity__c * recipe.Quantity__c;
                    }else{
                        manufactureRunObj.Status__c = 'Stock Reserved'; //set status to Stock reserved
                    } */  
                    //ends here
                    //new section added here
                    manufactureRunObj.Status__c = 'Stock Reserved'; //set status to Stock reserved
                    //ends here

                    
                    update manufactureRunObj;   //update Manufacturing Run data 
                    //ends here
                }// else loop ends here.
            }catch(Exception e){
                createErrorLog.insertError('ManufacturingRun',e.getMessage(),'Method - AutoReserveStockForManufactureRun',null,'',e.getStackTraceString(),UserInfo.getUserId());
                return 'false';
            }
        }           
        return stockExists;
    }
    //Ends here
    
    //View Reserved Stock
    @AuraEnabled
    public static List<listOfProductsWrapper> viewReservedStock(Manufacturing_Run__c manufactureRunObj){
        List<listOfProductsWrapper> wrapProdListOuter = new List<listOfProductsWrapper>();
        try{
            if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run_Allocation__c')
                &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run_Allocation_Line_Items__c') 
                &&  CRUD_FLS_CheckUtility.checkObjCRUD('Product2') 
                
                &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run_Allocation__c',new set<String>{'id','name','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Quantity__c','sigmaerpdev2__Manufacturing_Run__c'})
                &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run_Allocation_Line_Items__c',new set<String>{'id','name','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__r.sigmaerpdev2__Product_Serial_Number__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__r.sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Inventory_Location__r.name','sigmaerpdev2__Inventory_Location_Product_Line_Item__r.sigmaerpdev2__Inventory_Location_Product__r.Name','sigmaerpdev2__Inventory_Location_Product_Line_Item__r.Name','sigmaerpdev2__Inventory_Location_Product_Line_Item__r.sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Products__c','sigmaerpdev2__Location__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__r.sigmaerpdev2__Bin__r.Name','sigmaerpdev2__Inventory_Location_Product_Line_Item__r.sigmaerpdev2__Bin__r.Zone__r.Name','sigmaerpdev2__Lot__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Manufacturing_Run_Allocation__c'})
                &&  CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'id','name','sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Product_UOM__c'})
            )
            {  
            Map<Id,Decimal> prodMap = new Map<Id,Decimal>();
            Set<Id> manfRunAllocIds = new Set<Id>();
            List<ProductWrapper> wrapProdListManual = new List<ProductWrapper>(); //list of indiv. Products and its ilpli list
            Id ProdId;
            String prodName; 
            String status;
            String prodAttrType;
            String prodBomType; 
            String productUOM;
            Decimal totalAvailableQty; 
            
            List<Manufacturing_Run_Allocation__c> mraList = new List<Manufacturing_Run_Allocation__c>();
            mraList = [select id,name,Product__c,Product__r.Name,Quantity__c
                       from Manufacturing_Run_Allocation__c where Manufacturing_Run__c = : manufactureRunObj.Id];      
            for(Manufacturing_Run_Allocation__c mraItr : mraList){
                prodMap.put(mraItr.Product__c, mraItr.Quantity__c);
                manfRunAllocIds.add(mraItr.Id);
            }
            
            List<Manufacturing_Run_Allocation_Line_Items__c> mraLineItemsList = new List<Manufacturing_Run_Allocation_Line_Items__c>();
            mraLineItemsList = [select id,name,Inventory_Location_Product__c,Inventory_Location_Product_Line_Item__c,
                                Inventory_Location_Product_Line_Item__r.Product_Serial_Number__c,
                                Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.name,
                                Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Name,                                
                                Inventory_Location_Product_Line_Item__r.Name,                                
                                Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Products__c,Location__c,Unit_Price__c,
                                Inventory_Location_Product_Line_Item__r.Bin__r.Name,
                                Inventory_Location_Product_Line_Item__r.Bin__r.Zone__r.Name,                                                                
                                Lot__c,Quantity__c from Manufacturing_Run_Allocation_Line_Items__c
                                where Manufacturing_Run_Allocation__c In : manfRunAllocIds];
            
            for(Product2 prd :[select id,name,Attribute_Type__c,Product_UOM__c from Product2 where id in : prodMap.keySet()]){
                List<innerWrapper> wrapProdListSelected = new List<innerWrapper>();
                ProdId = prd.id;
                prodName = prd.name;
                prodAttrType = prd.Attribute_Type__c;                
                totalAvailableQty = 0.0;
                if(prd.Product_UOM__c != null){
                    productUOM = prd.Product_UOM__c;
                }
                for(Manufacturing_Run_Allocation_Line_Items__c mraliIteration : mraLineItemsList){
                    if(mraliIteration.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Products__c == ProdId){
                        innerWrapper iwrap = new innerWrapper(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);                        
                                                
                        if(mraliIteration.Inventory_Location_Product_Line_Item__r.Bin__r.Name == null)
                            iwrap.lotName = 'Not Available';
                        else
                            iwrap.lotName = mraliIteration.Inventory_Location_Product_Line_Item__r.Bin__r.Name;
                        
                        if(mraliIteration.Inventory_Location_Product_Line_Item__r.Bin__r.Zone__r.Name == null)
                            iwrap.zoneName = 'Not Available';
                        else
                            iwrap.zoneName = mraliIteration.Inventory_Location_Product_Line_Item__r.Bin__r.Zone__r.Name; 

                        if(mraliIteration.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.Name == null)
                            iwrap.ilName = 'Not Available';
                        else
                            iwrap.ilName = mraliIteration.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.Name;
                        
                        
                        iwrap.ilpAvailQuantity = null;                                                 
                        iwrap.ilpName = mraliIteration.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Name;
                        iwrap.ilpliName = mraliIteration.Inventory_Location_Product_Line_Item__r.Name;                        
                        iwrap.ilpId = mraliIteration.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Id; 
                        iwrap.ilpliId = mraliIteration.Inventory_Location_Product_Line_Item__c;                                       
                        iwrap.srNumName = mraliIteration.Inventory_Location_Product_Line_Item__r.Product_Serial_Number__c;
                        iwrap.selQuantity = mraliIteration.Quantity__c;
                        iwrap.unitPrice = mraliIteration.Unit_Price__c;
                        iwrap.ppId = null;
                        iwrap.ppliId = null;                    
                        iwrap.prodUOM = null;
                        iwrap.prodExpDate = null;                    
                        wrapProdListSelected.add(iwrap);
                    }
                }
                wrapProdListManual.add(new ProductWrapper(ProdId,prodName,prodMap.get(prd.id),prodAttrType,prodBomType,wrapProdListSelected,productUOM,null,true,totalAvailableQty,null));               
            }   
            wrapProdListOuter.add(new listOfProductsWrapper(wrapProdListManual)); 
            }
            return wrapProdListOuter;
        }catch(Exception e){
            createErrorLog.insertError('ManufacturingRun',e.getMessage(),'Method - viewReservedStock',null,'',e.getStackTraceString(),UserInfo.getUserId());
            return null;
        }
    }
    
    //return unit Price from MAnufacturing Run
    @auraEnabled
    public static Manufacturing_Run__c fetchUnitPrice(Id manfRunId){
        try{
            Manufacturing_Run__c mrRunObj;
            if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Recipe__c')
                &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run__c') 
                
                &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run__c',new set<String>{'sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Total_Cost__c','sigmaerpdev2__Recipe__c','sigmaerpdev2__Produced_Quantity__c','sigmaerpdev2__Required_Quantity__c','sigmaerpdev2__PI_updated__c'})
                &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Recipe__c',new set<String>{'id','sigmaerpdev2__Quantity__c'})
            )
            {
            Recipe__c recipe=new Recipe__c();
            mrRunObj = [select Unit_Price__c,Total_Cost__c,Recipe__c,Produced_Quantity__c,Required_Quantity__c,PI_updated__c from Manufacturing_Run__c where id = :manfRunId];
            recipe=[select id,Quantity__c from Recipe__c where Id=: mrRunObj.Recipe__c];
            mrRunObj.Produced_Quantity__c=mrRunObj.Required_Quantity__c*recipe.Quantity__c;
            }
            return mrRunObj;
        }catch(Exception e){
            createErrorLog.insertError('ManufacturingRun',e.getMessage(),'Method - fetchUnitPrice',null,'',e.getStackTraceString(),UserInfo.getUserId());
            return null;
        }
    }
    //ends here
    
    //Cancel the Manufacturing Run and revert the Stock if its reserved
    @auraEnabled
    public static Boolean cancelManfRun(Id manfRunId){
        Boolean flag = false;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run__c') 
                &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run_Allocation__c')
                &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
                &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
                &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run_Allocation_Line_Items__c')
                &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
                
                &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run__c',new set<String>{'id','Name','sigmaerpdev2__Status__c'})
                &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run_Allocation__c',new set<String>{'id','name','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c'})
                &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'id','name','sigmaerpdev2__Reserved_Quantity__c'})
                &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'id','Name','sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__Available_Quantity__c'})
                &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run_Allocation_Line_Items__c',new set<String>{'id','name','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Manufacturing_Run_Allocation__c'})
                &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new set<String>{'id','Name','sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__ProductCode__c'})
                
                &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Manufacturing_Run__c',new set<String>{'sigmaerpdev2__Status__c'})
                &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'sigmaerpdev2__Reserved_Quantity__c'})
                &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'sigmaerpdev2__Reserved_Quantity__c'})
                &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new set<String>{'sigmaerpdev2__Reserved_Qty__c'})
            )
        {
               Map<Id,Id> ILPLIPSNMapForManual = new Map<Id,Id>(); //used to store ILPLI Id and the PSN Id to change the PSN status available to Allocated          
                List<Product_Serial_Number__c> fullPSNList; // used to store query results for PSN 
                 List<Product_Serial_Number__c> PSNListToUpdate = new List<Product_Serial_Number__c>();
                                      
            try{
                Manufacturing_Run__c mrRunObj = [select Status__c from Manufacturing_Run__c where id = :manfRunId];
                if(mrRunObj.Status__c == 'Stock Reserved'){
                    //get all the reserved stock and revert them back
                    List<Manufacturing_Run_Allocation__c> manfRunAllocList = new List<Manufacturing_Run_Allocation__c>();
                    manfRunAllocList = [select id,name,Quantity__c,Product__c from Manufacturing_Run_Allocation__c where Manufacturing_Run__c = :manfRunId];
                    Set<Id> manfRunAllocIDs = new Set<Id>();
                    Set<Id> manfRunAllocProdIDList = new Set<Id>();
                    for(Manufacturing_Run_Allocation__c mraItr : manfRunAllocList){
                        manfRunAllocIDs.add(mraItr.Id);
                        manfRunAllocProdIDList.add(mraItr.Product__c);
                    }
                    Map<Id,Decimal> ILPIncreaseQtyMapForManual = new Map<Id,Decimal>(); //used to store ILP and the quantity to be increased/reverted
                    Map<Id,Decimal> ILPLIIncreaseQtyMapForManual = new Map<Id,Decimal>(); //used to store ILPLI and the quantity to be increased/reverted               
                    List<Inventory_Location_Product__c> fullILPList;                
                    List<Inventory_Location_Product_Line_Item__c> fullILPLIList;
                    List<Manufacturing_Run_Allocation_Line_Items__c> mraliList = new List<Manufacturing_Run_Allocation_Line_Items__c>();
                    //increase Lot Qty and set PSN status to Unused
                    Map<Id,Decimal> LotIncrQtyMap = new Map<Id,Decimal>();
                    Set<ID> AllocatePSNIDSet = new Set<ID>(); 
                    Map<Id,Decimal> AllocatePSNMap = new Map<Id,Decimal>();     
                   
                                 
                    mraliList = [select id,name,Inventory_Location_Product__c,Inventory_Location_Product_Line_Item__c,Quantity__c,
                                 Manufacturing_Run_Allocation__c from
                                 Manufacturing_Run_Allocation_Line_Items__c where Manufacturing_Run_Allocation__c IN : manfRunAllocIDs];
                                   
                    
                    for(Manufacturing_Run_Allocation_Line_Items__c mraliItr : mraliList){                    
                        if(!ILPIncreaseQtyMapForManual.containsKey(mraliItr.Inventory_Location_Product__c)){
                            ILPIncreaseQtyMapForManual.put(mraliItr.Inventory_Location_Product__c, mraliItr.Quantity__c);
                        }else{
                            Decimal quan = ILPIncreaseQtyMapForManual.get(mraliItr.Inventory_Location_Product__c);
                            ILPIncreaseQtyMapForManual.put(mraliItr.Inventory_Location_Product__c,(quan + mraliItr.Quantity__c));
                        }
                        ILPLIIncreaseQtyMapForManual.put(mraliItr.Inventory_Location_Product_Line_Item__c, mraliItr.Quantity__c);                                                           
                    }
                    
                    //update Product Inventory Stock
                    List<Inventory__c> productInventoryList;        
                    productInventoryList = [Select Id,Name,Reserved_Qty__c,Available_Qty__c,ProductCode__c From Inventory__c where ProductCode__c in :manfRunAllocProdIDList];                     
                    for(Manufacturing_Run_Allocation__c pp : manfRunAllocList){
                        for(Inventory__c inv : productInventoryList){
                            if(pp.Product__c == inv.ProductCode__c){                                                        
                                inv.Reserved_Qty__c = inv.Reserved_Qty__c - pp.Quantity__c;
                                inv.Available_Qty__c = inv.Available_Qty__c + pp.Quantity__c;
                                inv.Comments__c = ' Inventory updated after CANCELLING ManufactureRun ';
                            }
                        } 
                    }
                    update productInventoryList;
                    //ends here                                
                    
                    fullILPList = [Select Id, Reserved_Quantity__c from Inventory_Location_Product__c where Id IN :ILPIncreaseQtyMapForManual.keySet()];
                    for(Inventory_Location_Product__c ilpItr : fullILPList){                    
                        ilpItr.Reserved_Quantity__c = ilpItr.Reserved_Quantity__c - ILPIncreaseQtyMapForManual.get(ilpItr.Id);                                                            
                    }
                    update fullILPList;   
                    
                    fullILPLIList = [Select Id,Reserved_Quantity__c,Available_Quantity__c,Product_Serial_Number__r.Name  from Inventory_Location_Product_Line_Item__c where Id IN :ILPLIIncreaseQtyMapForManual.keySet()];
                    List<Inventory_Location_Product_Line_Item__c> ILPLIListToUpdate = new List<Inventory_Location_Product_Line_Item__c>();
                    for(Inventory_Location_Product_Line_Item__c ilpliItr : fullILPLIList){
                        Inventory_Location_Product_Line_Item__c ilpliObj = new Inventory_Location_Product_Line_Item__c();
                        ilpliObj.Reserved_Quantity__c = ilpliItr.Reserved_Quantity__c - ILPLIIncreaseQtyMapForManual.get(ilpliItr.Id);                    
                        ilpliObj.Id = ilpliItr.Id;                    
                        ILPLIListToUpdate.add(ilpliObj);
                        ILPLIPSNMapForManual.put(ilpliItr.Product_Serial_Number__c,ilpliItr.Id);
                   // system.debug('ILPLIPSNMapForManual'+ILPLIPSNMapForManual);
                    }
                    //ILPLIPSNMapForManual.put(ilpliObj.Product_Serial_Number__c,ilpliObj.id);
                    system.debug('ILPLIPSNMapForManual'+ILPLIPSNMapForManual);
                    update ILPLIListToUpdate;                
                    //ends here           
                    delete manfRunAllocList; //delete the Manufacture Run Allocations
                    flag = true;
                }
                mrRunObj.Status__c = 'Cancelled'; //update the current Status as Cancelled for the Manufacturing Run
                update mrRunObj; 
                //update the Manufacturing Run object with the Status set to Cancelled            
                 //code to update PSN status as Allocated after stock reserve on 06-07-2021
              	fullPSNList = [Select Id,Name,Status__c From Product_Serial_Number__c where Id IN :ILPLIPSNMapForManual.keySet()];   
                system.debug('fullPSNList>>.'+fullPSNList);
                for(Product_Serial_Number__c psn : fullPSNList){
                    system.debug('psn>>.'+psn);
                    Product_Serial_Number__c psnObj = new Product_Serial_Number__c(); 
                    if(ILPLIPSNMapForManual.containsKey(psn.Id)){                                          
                        psnObj.Status__c = 'Available';                    
                        psnObj.Id = psn.Id;
                        PSNListToUpdate.add(psnObj);
                      }   
                 }            
               update PSNListToUpdate; 
                system.debug('PSNListToUpdate>>.'+PSNListToUpdate);
               //code ends here
                return flag;
                
            }catch(Exception e){
                createErrorLog.insertError('ManufacturingRun',e.getMessage(),'Method - cancelManfRun',null,'',e.getStackTraceString(),UserInfo.getUserId());  
                flag = null;       
            }
        }
        return flag;
    }
    //ends here
    
    //edit the reserved stock and increase or decrease the stock 
    @auraEnabled
    public static String editReservedStock(Id manfID, Decimal oldVal, Decimal newVal, Id prodId){  
        String msg = '';  
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Products__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__PricebookEntry')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run_Allocation__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run_Allocation_Line_Items__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Auto_Allocations_For_Manufaturing_Run__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Allocation_Item_Manufaturing_Run__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
            
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run__c',new set<String>{'id','Name','sigmaerpdev2__Required_Quantity__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Total_Cost__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Products__c',new set<String>{'id','Name','sigmaerpdev2__Quantity__c','sigmaerpdev2__Cost__c','sigmaerpdev2__Product__c','sigmaerpdev2__Manufacturing_Run__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__PricebookEntry',new set<String>{'id','UnitPrice','Product2','Product2.Id','PriceBook2.Name'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run_Allocation__c',new set<String>{'id','name','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Manufacturing_Run__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'id','name','sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Products__c','sigmaerpdev2__Inventory__c','sigmaerpdev2__Net_Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'id','Name','sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Inventory_Location_Product__r.Id','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Products__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Products__r.Name','sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__Received_Date__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Product_Expiry_Date__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Allocation_Item_Manufaturing_Run__c',new set<String>{'Id','name','sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__r.sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Ordered_Quantity__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Selected_Quantity__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__r.sigmaerpdev2__Product_Serial_Number__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__r.sigmaerpdev2__Inventory_Location_Product__r.Name','sigmaerpdev2__Inventory_Location_Product_Line_Item__r.Name','sigmaerpdev2__Auto_Allocation_For_Manufaturing_Run__c ','sigmaerpdev2__Product__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run_Allocation_Line_Items__c',new set<String>{'id','name','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Inventory_Location_Product__r.sigmaerpdev2__Products__r.sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Manufacturing_Run_Allocation__r.sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Manufacturing_Run_Allocation__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new set<String>{'id','Name','sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__ProductCode__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Auto_Allocations_For_Manufaturing_Run__c',new set<String>{'id','name'})
            
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Manufacturing_Run__c',new set<String>{'sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Total_Cost__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Manufacturing_Products__c',new set<String>{'sigmaerpdev2__Quantity__c','sigmaerpdev2__Cost__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Manufacturing_Run_Allocation__c',new set<String>{'sigmaerpdev2__Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Manufacturing_Run_Allocation_Line_Items__c',new set<String>{'sigmaerpdev2__Quantity__c','sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Unit_Price__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'sigmaerpdev2__Reserved_Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'sigmaerpdev2__Reserved_Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new set<String>{'sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Available_Qty__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Allocation_Item_Manufaturing_Run__c',new set<String>{'sigmaerpdev2__Inventory_Location_Product_Line_Item__c','sigmaerpdev2__Status__c','sigmaerpdev2__Ordered_Quantity__c','sigmaerpdev2__Selected_Quantity__c','sigmaerpdev2__Remaining_Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Unit_Price__c'})
            
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Manufacturing_Run_Allocation_Line_Items__c',new Set<String>{'sigmaerpdev2__Manufacturing_Run_Allocation__c'})
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Allocation_Item_Manufaturing_Run__c',new Set<String>{'sigmaerpdev2__Auto_Allocation_For_Manufaturing_Run__c'})
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Auto_Allocations_For_Manufaturing_Run__c',new Set<String>{'sigmaerpdev2__Manufacturing_Run__c'})
            
            )
            {    
            List<Manufacturing_Run_Allocation__c> manfRunAllocList = new List<Manufacturing_Run_Allocation__c>();
            List<Manufacturing_Run_Allocation_Line_Items__c> manfRunAllocLineItemsList = new List<Manufacturing_Run_Allocation_Line_Items__c>();
            Set<Id> mraId = new Set<Id>();        
            
            Map<Id,Decimal> mraLineItemsIdsMap = new Map<Id,Decimal>(); //store MRALI id and quantity
            Map<Id,Decimal> mraLineItemsIdQuan = new Map<Id,Decimal>(); // store selected MRALI Id and its quantity
            Map<Id,Decimal> ILPIdsMap = new Map<Id,Decimal>(); //store selected ILP Id and quantity
            Map<Id,Decimal> ILPLIIdsMap = new Map<Id,Decimal>(); //store selected ILPLI Id and quantity
            
            Decimal avgBuyingPrice = 0.0;
            try{           
                if(oldVal < newVal){
                    //increase the stock                 
                    Id manfRunAllocId;
                    manfRunAllocList = [select Id,name,Product__c,Quantity__c from Manufacturing_Run_Allocation__c where Manufacturing_Run__c = :manfID and Product__c = :prodId];
                    for(Manufacturing_Run_Allocation__c mraItr : manfRunAllocList){
                        mraItr.Quantity__c = newVal;
                        manfRunAllocId = mraItr.Id;
                    }
                    
                    Decimal newQty = newVal - oldVal;                
                    Decimal requiredQuantity = 0.0;
                    Decimal allocatingQuantity = 0.0;                   
                    Decimal orderedQuantity = 0.0;
                    Decimal remainingQnty = 0.0;    
                    Decimal allocatedQnty = 0.0;                        
                    Map<Id,String> ilpListMap1 = new Map<Id,String>();               
                    
                    List<Inventory_Location_Product__c> ilpList = [select id,name,Net_Quantity__c from Inventory_Location_Product__c where Net_Quantity__c > 0 and Products__c = :prodId];
                    for (Inventory_Location_Product__c ilpListItems : ilpList){              
                        ilpListMap1.put(ilpListItems.Id,ilpListItems.Name);
                    }
                    
                    List<Inventory_Location_Product_Line_Item__c> ilpliList = new List<Inventory_Location_Product_Line_Item__c>();
                    List<Inventory_Location_Product_Line_Item__c> additionalILPLIList = new List<Inventory_Location_Product_Line_Item__c>();                         
                    List<Inventory_Location_Product_Line_Item__c> tempilpliList = new List<Inventory_Location_Product_Line_Item__c>();
                    tempilpliList = [select name,Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Name,
                                     Reserved_Quantity__c,Available_Quantity__c,Received_Date__c,Unit_Price__c from Inventory_Location_Product_Line_Item__c where 
                                     Inventory_Location_Product__c in :ilpListMap1.keySet() and Product_Expiry_Date__c != null and Product_Expiry_Date__c > TODAY and Available_Quantity__c > 0];               
                    Decimal enoughStock = 0.0;
                    if(tempilpliList.size() > 0){ //if expiry date exists choose those ilpli's to do allocation
                        ilpliList = [select name,Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Name,
                                     Reserved_Quantity__c,Available_Quantity__c,Received_Date__c,Unit_Price__c from Inventory_Location_Product_Line_Item__c where 
                                     Inventory_Location_Product__c in :ilpListMap1.keySet() and Product_Expiry_Date__c > TODAY and Available_Quantity__c > 0 order by Product_Expiry_Date__c ASC];
                        
                        for(Inventory_Location_Product_Line_Item__c ilpItr : ilpliList){
                            enoughStock = enoughStock + ilpItr.Available_Quantity__c;
                        }
                        if(enoughStock < newQty){ // if stock is low again pick from the remaining ilpli's which doesn't have expiry date
                            additionalILPLIList = [select name,Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Name,
                                                   Reserved_Quantity__c,Available_Quantity__c,Received_Date__c,Unit_Price__c from Inventory_Location_Product_Line_Item__c where 
                                                   Inventory_Location_Product__c in :ilpListMap1.keySet() and Available_Quantity__c > 0 and Product_Expiry_Date__c = null order by Received_Date__c ASC];                        
                            ilpliList.addAll(additionalILPLIList);
                        }
                    }else{ //else choose all ilpli's to do allocation
                        ilpliList = [select name,Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Name,
                                     Reserved_Quantity__c,Available_Quantity__c,Received_Date__c,Unit_Price__c from Inventory_Location_Product_Line_Item__c where 
                                     Inventory_Location_Product__c in :ilpListMap1.keySet() and Available_Quantity__c > 0 order by Received_Date__c ASC];
                    }  

                                   
                    //added to restrict partial allocation if there is insufficient stock           
                    Decimal tempQuantityTotal = 0.0;
                    Boolean stockExists = false; //suggests there is not enough stock to do allocation
                    Map<Id,Decimal> reqProductQuantityMap1 = new Map<Id,Decimal>(); // store Product Id and its required Quantity
                    reqProductQuantityMap1.put(prodId, newQty); 
                    Map<Id,Decimal> orderedQuantitymap = new Map<Id,Decimal>(); //used to store required Product Id and its Quantity
                    orderedQuantitymap.put(prodId, newQty); 
                    
                    for(Inventory_Location_Product_Line_Item__c checkQuantity : ilpliList){
                        tempQuantityTotal = tempQuantityTotal + checkQuantity.Available_Quantity__c;
                    }
                    
                    if(tempQuantityTotal >= newQty){
                        stockExists = true; //suggests there is enough stock to do allocation
                    }                
                    Map<id,List<Inventory_Location_Product_Line_Item__c>> productAndILPLAllocated = new Map<id,List<Inventory_Location_Product_Line_Item__c>>();
                    Map<id,Decimal> IlPLIQuan = new Map<id,Decimal>();
                    if(stockExists == true){                    
                        for(Inventory_Location_Product_Line_Item__c allocateProd : ilpliList){                    
                            //allocateProd.Bypass_Rule__c = true;
                            Id prodIds = allocateProd.Inventory_Location_Product__r.Products__c;                              
                            requiredQuantity = reqProductQuantityMap1.get(prodId);                    
                            if(requiredQuantity != 0.0){                               
                                allocatingQuantity = allocateProd.Available_Quantity__c;
                                if(allocatingQuantity <= requiredQuantity && allocatingQuantity != 0){                                 
                                    if(allocateProd.Available_Quantity__c != null){
                                        allocateProd.Reserved_Quantity__c = allocateProd.Reserved_Quantity__c + allocatingQuantity;                                                                        
                                        IlPLIQuan.put(allocateProd.Id,allocatingQuantity);                                                          
                                        if(productAndILPLAllocated.containsKey(prodIds))
                                        {
                                            List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                                            usedILPLI = productAndILPLAllocated.get(prodIds);
                                            usedILPLI.add(allocateProd);
                                            productAndILPLAllocated.put(prodIds,usedILPLI);                         
                                        }
                                        else{
                                            List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                                            usedILPLI.add(allocateProd);
                                            productAndILPLAllocated.put(prodIds,usedILPLI);                         
                                        }
                                    }
                                    requiredQuantity = requiredQuantity - allocatingQuantity;                                 
                                }else if(allocatingQuantity > requiredQuantity){                                                     
                                    if(allocateProd.Available_Quantity__c != null){                       
                                        allocateProd.Reserved_Quantity__c = allocateProd.Reserved_Quantity__c + requiredQuantity;                                                                        
                                        IlPLIQuan.put(allocateProd.Id,requiredQuantity);                            
                                        if(productAndILPLAllocated.containsKey(prodIds))
                                        {
                                            List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                                            usedILPLI = productAndILPLAllocated.get(prodIds);
                                            usedILPLI.add(allocateProd);
                                            productAndILPLAllocated.put(prodIds,usedILPLI);                         
                                        }
                                        else{
                                            List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                                            usedILPLI.add(allocateProd);
                                            productAndILPLAllocated.put(prodIds,usedILPLI);
                                        }
                                    }                                              
                                    requiredQuantity = 0.0;                                                   
                                } 
                                reqProductQuantityMap1.put(prodId,requiredQuantity);                                                                          
                            } //end of if statement
                        }  //end of for loop                        
                        update ilpliList; 
                        
                        
                        Set<Id> soaIDSet = new Set<Id>();                   
                        
                        if(!productAndILPLAllocated.isEmpty()){             
                            //insert data into Sales Order Allocation object
                            Auto_Allocations_For_Manufaturing_Run__c soa = new Auto_Allocations_For_Manufaturing_Run__c();                
                            soa.Manufacturing_Run__c = manfID; 
                            insert soa;    
                            //ends here    
                            
                            soaIDSet.add(soa.Id);
                            //insert data into Sales order Allocation Line Item object
                            List<Allocation_Item_Manufaturing_Run__c> soaliList = new List<Allocation_Item_Manufaturing_Run__c>();
                            for(Id proId : productAndILPLAllocated.keySet()){
                                if(reqProductQuantityMap1.containsKey(proId)){
                                    for(Inventory_Location_Product_Line_Item__c ilpli : productAndILPLAllocated.get(proId)){                                    
                                        Allocation_Item_Manufaturing_Run__c soali = new Allocation_Item_Manufaturing_Run__c();
                                        soali.Auto_Allocation_For_Manufaturing_Run__c = soa.Id;                                   
                                        soali.Inventory_Location_Product_Line_Item__c = ilpli.Id;
                                        soali.Status__c = 'Allocated';                                             
                                        orderedQuantity = orderedQuantitymap.get(proId);                      
                                        soali.Ordered_Quantity__c = orderedQuantity;
                                        soali.Selected_Quantity__c = IlPLIQuan.get(ilpli.Id);                                               
                                        allocatedQnty = allocatedQnty + IlPLIQuan.get(ilpli.Id);                        
                                        remainingQnty = allocatedQnty;                        
                                        soali.Remaining_Quantity__c = orderedQuantity - remainingQnty;
                                        soali.Product__c = proId;
                                        soali.Unit_Price__c = ilpli.Unit_Price__c;
                                        soaliList.add(soali);
                                    } //end of inner for loop
                                } //end of if statement        
                            } //end of outer for loop
                            insert soaliList;                                       
                            //ends here                                                                
                        } //end of if statement 
                        
                                                                                
                        Map<Id,Decimal> allocatedILPs = new Map<Id,Decimal>(); //used to store ILP's and its respective allocated quantity
                        Map<Id,Decimal> allocatedPIs = new Map<Id,Decimal>(); //used to store PI's and its respective allocated quantity                    
                        Set<Id> prodInvId = new Set<Id>();
                        //update PI new flow added on 20-12-2019                                
                        List<Inventory_Location_Product_Line_Item__c> ilpSumList = [select Id,name,Inventory_Location_Product__c from Inventory_Location_Product_Line_Item__c where id in :IlPLIQuan.keySet()];
                        if(ilpSumList.size() > 0){
                            for(Inventory_Location_Product_Line_Item__c ilpliObj1 : ilpSumList){                                                                                    
                                if(!allocatedILPs.containsKey(ilpliObj1.Inventory_Location_Product__c)){
                                    allocatedILPs.put(ilpliObj1.Inventory_Location_Product__c, IlPLIQuan.get(ilpliObj1.Id));
                                }else{                          
                                    Decimal qty1 = IlPLIQuan.get(ilpliObj1.Id);
                                    allocatedILPs.put(ilpliObj1.Inventory_Location_Product__c,(qty1 + IlPLIQuan.get(ilpliObj1.Id)));
                                }
                            }
                        }
                        Decimal tempQuantity = 0.0;
                        List<Inventory_Location_Product__c> fetchILPList = [select Id,Inventory__c,Reserved_Quantity__c from Inventory_Location_Product__c where id in :allocatedILPs.keySet()];
                        if(fetchILPList.size() > 0){
                            for(Inventory_Location_Product__c ilpObj1 : fetchILPList){
                                tempQuantity = tempQuantity + allocatedILPs.get(ilpObj1.Id);
                                allocatedPIs.put(ilpObj1.Inventory__c, tempQuantity);
                                ilpObj1.Reserved_Quantity__c = ilpObj1.Reserved_Quantity__c + allocatedILPs.get(ilpObj1.Id);
                            }
                            update fetchILPList;
                        }
                        List<Inventory__c> productInventoryList = [select Id, Available_Qty__c, Reserved_Qty__c from Inventory__c where id in : allocatedPIs.keySet()];
                        if(productInventoryList.size() > 0){
                            for(Inventory__c piObj : productInventoryList){
                                piObj.Reserved_Qty__c = piObj.Reserved_Qty__c + allocatedPIs.get(piObj.Id);
                                piObj.Available_Qty__c = piObj.Available_Qty__c - allocatedPIs.get(piObj.Id);                               
                            }
                            update productInventoryList;
                        }
                        //ends here
                                            
                        //get the recently allocated stock for the new quantity
                        List<Allocation_Item_Manufaturing_Run__c> allocObj = new List<Allocation_Item_Manufaturing_Run__c>();
                        allocObj = [select Id,name,Inventory_Location_Product_Line_Item__c,
                                    Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__c,
                                    //Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.Locations__c,
                                    Ordered_Quantity__c,Unit_Price__c,Selected_Quantity__c,                                
                                    Inventory_Location_Product_Line_Item__r.Product_Serial_Number__c,
                                    //Location_Name__c,                                                                                                
                                    Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Name,
                                    Inventory_Location_Product_Line_Item__r.Name
                                    //Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.Locations__r.Name                                                                
                                    from Allocation_Item_Manufaturing_Run__c
                                    where Auto_Allocation_For_Manufaturing_Run__c = :soaIDSet and Product__c = :prodId];
                        //ends here
                       
                        //insert the Manufacturing_Run_Allocation_Line_Items__c for the newly reserved stock
                        List<Manufacturing_Run_Allocation_Line_Items__c> mraliList = new List<Manufacturing_Run_Allocation_Line_Items__c>();
                        for(Allocation_Item_Manufaturing_Run__c allocItr : allocObj){
                            Manufacturing_Run_Allocation_Line_Items__c mrali = new Manufacturing_Run_Allocation_Line_Items__c();
                            mrali.Manufacturing_Run_Allocation__c = manfRunAllocId;
                            mrali.Inventory_Location_Product_Line_Item__c = allocItr.Inventory_Location_Product_Line_Item__c;
                            mrali.Inventory_Location_Product__c = allocItr.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__c;
                            mrali.Quantity__c = allocItr.Selected_Quantity__c;   
                            mrali.Unit_Price__c  =  allocItr.Unit_Price__c;                                                                         
                            mraliList.add(mrali);
                        }                     
                        insert mraliList;
                        //ends here              
                        
                        update manfRunAllocList; //increase the Manufacturing_Run_Allocation__c Quantity with the new value
                        msg = 'INCREASED';                                      
                    }else{
                        msg = 'LOWSTOCK';
                        return msg;
                    }                
                }else{
                    //decrease the stock 
                    Id manfRunAllocId1;
                    Map<Id,Decimal> allocatedPIs = new Map<Id,Decimal>(); //used to store PI's and its respective allocated quantity
                    Decimal newQty = oldVal - newVal;
                                    
                    manfRunAllocList = [select Id,name,Product__c,Quantity__c from Manufacturing_Run_Allocation__c where Manufacturing_Run__c = :manfID and Product__c = :prodId];         
                    for(Manufacturing_Run_Allocation__c mraItr : manfRunAllocList){
                        mraId.add(mraItr.Id);
                        mraItr.Quantity__c = newVal;
                        manfRunAllocId1 = mraItr.Id;
                    }                    
                    manfRunAllocLineItemsList = [select Id,name,Quantity__c from Manufacturing_Run_Allocation_Line_Items__c where Manufacturing_Run_Allocation__c In : mraId];      
                                
                    Decimal totalQuan = 0.0;
                    Decimal remQn = newQty;
                    Decimal allocQuan = 0.0;
                    
                    for(Manufacturing_Run_Allocation_Line_Items__c mraliItr : manfRunAllocLineItemsList){
                        mraLineItemsIdsMap.put(mraliItr.Id, mraliItr.Quantity__c);                                     
                    }
                    
                    for(Id recID : mraLineItemsIdsMap.keySet()){                    
                        if(remQn != 0){                    
                            allocQuan = mraLineItemsIdsMap.get(recID);
                            if(allocQuan <= remQn && allocQuan != 0){                                                        
                                mraLineItemsIdQuan.put(recID, allocQuan);                            
                                remQn = remQn - allocQuan;                            
                            }else if(allocQuan > remQn){                                                        
                                mraLineItemsIdQuan.put(recID, remQn);
                                remQn = 0;
                            }
                        }                        
                    }
                                                    
                    List<Manufacturing_Run_Allocation_Line_Items__c> selectedMRLIList;
                    Map<Id,Decimal> LotReduceQtyMap = new Map<Id,Decimal>();
                    Set<ID> AllocatePSNIDSet = new Set<ID>(); 
                    Map<Id,Decimal> AllocatePSNMap = new Map<Id,Decimal>();
                    
                    selectedMRLIList = [select Id,name,Quantity__c,Inventory_Location_Product__c,
                                        Inventory_Location_Product_Line_Item__c,Lot__c,Inventory_Location_Product__r.Products__r.Attribute_Type__c
                                        from Manufacturing_Run_Allocation_Line_Items__c where Id in :mraLineItemsIdQuan.keySet()];
                    for(Manufacturing_Run_Allocation_Line_Items__c listItr : selectedMRLIList){
                        if(!ILPIdsMap.containsKey(listItr.Inventory_Location_Product__c)){
                            ILPIdsMap.put(listItr.Inventory_Location_Product__c, mraLineItemsIdQuan.get(listItr.Id));
                        }else{
                            Decimal qty1 = ILPIdsMap.get(listItr.Inventory_Location_Product__c);                        
                            ILPIdsMap.put(listItr.Inventory_Location_Product__c,(qty1 + mraLineItemsIdQuan.get(listItr.Id)));
                        }                        
                        if(!ILPLIIdsMap.containsKey(listItr.Inventory_Location_Product_Line_Item__c)){
                            ILPLIIdsMap.put(listItr.Inventory_Location_Product_Line_Item__c, mraLineItemsIdQuan.get(listItr.Id));
                        }else{
                            Decimal qty2 = ILPLIIdsMap.get(listItr.Inventory_Location_Product_Line_Item__c);                        
                            ILPLIIdsMap.put(listItr.Inventory_Location_Product_Line_Item__c,(qty2 + mraLineItemsIdQuan.get(listItr.Id)));
                        }                                      
                    }
                                    
                    //update the respective ILP quantities
                    List<Inventory_Location_Product__c> fullILPList; 
                    List<Inventory_Location_Product__c> ILPList = new List<Inventory_Location_Product__c>();
                    fullILPList = [Select Id,Name,Products__c,Reserved_Quantity__c,
                                   Inventory__c From Inventory_Location_Product__c where Id IN :ILPIdsMap.keySet()];                
                    
                    //update the respective ILPLI quantities
                    List<Inventory_Location_Product_Line_Item__c> fullILPLIList;  
                    List<Inventory_Location_Product_Line_Item__c> ILPLIListToUpdate = new List<Inventory_Location_Product_Line_Item__c>();
                    fullILPLIList = [Select Id,Name,Inventory_Location_Product__c,Reserved_Quantity__c,Available_Quantity__c From Inventory_Location_Product_Line_Item__c where Id IN :ILPLIIdsMap.keySet()];
                    for(Inventory_Location_Product_Line_Item__c ilpli : fullILPLIList){
                        Inventory_Location_Product_Line_Item__c ilpliObj = new Inventory_Location_Product_Line_Item__c(); 
                        if(ILPLIIdsMap.containsKey(ilpli.Id)){                        
                            ilpliObj.Reserved_Quantity__c = ilpli.Reserved_Quantity__c - ILPLIIdsMap.get(ilpli.Id);                                                
                            ilpliObj.Id = ilpli.Id;                        
                            ILPLIListToUpdate.add(ilpliObj);
                        }    
                    }
                    update ILPLIListToUpdate; //update ILPLI list
                    //ends here 
                    
                    //update Product Inventory Stock and ILP quantities
                    List<Inventory__c> productInventoryList;        
                    productInventoryList = [Select Id,Name,Reserved_Qty__c,Available_Qty__c,ProductCode__c From Inventory__c where ProductCode__c = :prodId];     
                    Decimal tempQuantity = 0.0;
                    for(Inventory_Location_Product__c updateILP : fullILPList){ 
                        if(ILPIdsMap.get(updateILP.Id) != null){
                            tempQuantity = tempQuantity + ILPIdsMap.get(updateILP.Id);                        
                            allocatedPIs.put(updateILP.Inventory__c, tempQuantity);
                            updateILP.Reserved_Quantity__c = updateILP.Reserved_Quantity__c - ILPIdsMap.get(updateILP.Id);
                        }                     
                    } 
                    update fullILPList; 
                    
                    for(Inventory__c inv : productInventoryList){                                                                
                        if(allocatedPIs.get(inv.Id) != null){
                            inv.Reserved_Qty__c = inv.Reserved_Qty__c - allocatedPIs.get(inv.Id);
                            inv.Available_Qty__c = inv.Available_Qty__c + allocatedPIs.get(inv.Id);                                                     
                        }                                          
                    }                     
                    update productInventoryList;         
                    //ends here     
                    
                    //update the Manf.Run Allocation Line Items with the edited quantity
                    List<Manufacturing_Run_Allocation_Line_Items__c> updateMRLIList = new List<Manufacturing_Run_Allocation_Line_Items__c>();
                    for(Id recID : mraLineItemsIdsMap.keySet()){
                        if(mraLineItemsIdQuan.containsKey(recID)){
                            Manufacturing_Run_Allocation_Line_Items__c mrli = new Manufacturing_Run_Allocation_Line_Items__c();
                            mrli.Id = recID;                                                 
                            mrli.Quantity__c = mraLineItemsIdsMap.get(recID) - mraLineItemsIdQuan.get(recID);
                            updateMRLIList.add(mrli);
                        }
                    }     
                    update updateMRLIList;
                    //ends here                
                    
                    
                    //delete the Manf.Run Allocation Line Items which has quantity equal to 0
                    List<Manufacturing_Run_Allocation_Line_Items__c> deleteMRLIList = new List<Manufacturing_Run_Allocation_Line_Items__c>();
                    deleteMRLIList = [select Id,Quantity__c from Manufacturing_Run_Allocation_Line_Items__c where Quantity__c = 0 and Manufacturing_Run_Allocation__c = :manfRunAllocId1];
                    delete deleteMRLIList;
                    //ends here                              
                    
                    update manfRunAllocList;
                    msg = 'REDUCED';                
                }                        

                //added newly to fix ilpli unit price issue during editing reserved stock - on 26/9/2018
                if(msg == 'INCREASED' ||  msg == 'REDUCED'){
                    Set<Id> mraIds = new Set<Id>();
                    Map<Id,Decimal> prodQnMap = new Map<Id,Decimal>();
                    Map<Id,Decimal> prodUnitPrice = new Map<Id,Decimal>();
                    
                    Map<Id,Decimal> finalProdPrice = new Map<Id,Decimal>();
                    Map<Id,Decimal> finalNonStkProdUnitPrice = new Map<Id,Decimal>();
                    Decimal finalTotalManfCost = 0.00;
                    
                    List<Manufacturing_Run_Allocation__c> mraList11 = [select Id,Product__c,Quantity__c from Manufacturing_Run_Allocation__c where Manufacturing_Run__c = :manfID];
                    if(mraList11.size() > 0){
                        for(Manufacturing_Run_Allocation__c mraObj11 : mraList11){
                            mraIds.add(mraObj11.Id);
                            prodQnMap.put(mraObj11.Product__c, mraObj11.Quantity__c);
                        }
                    }               
                    List<Manufacturing_Run_Allocation_Line_Items__c>  mraliList11 = [select id,name,Inventory_Location_Product__c,Inventory_Location_Product_Line_Item__c,
                                Unit_Price__c,Manufacturing_Run_Allocation__r.Product__c,                            
                                Quantity__c from Manufacturing_Run_Allocation_Line_Items__c
                                where Manufacturing_Run_Allocation__c in : mraIds];                          
                    if(mraliList11.size() > 0){
                        for(Manufacturing_Run_Allocation_Line_Items__c mraliObj11 : mraliList11){
                            Decimal unitPrice = 0.00;
                            if(prodUnitPrice.containsKey(mraliObj11.Manufacturing_Run_Allocation__r.Product__c)){ 
                                unitPrice = (mraliObj11.Unit_Price__c * mraliObj11.Quantity__c) + prodUnitPrice.get(mraliObj11.Manufacturing_Run_Allocation__r.Product__c);                         
                                prodUnitPrice.put(mraliObj11.Manufacturing_Run_Allocation__r.Product__c, unitPrice);
                            }else{
                                unitPrice = mraliObj11.Unit_Price__c * mraliObj11.Quantity__c;
                                prodUnitPrice.put(mraliObj11.Manufacturing_Run_Allocation__r.Product__c, unitPrice);
                            }
                        }                   
                    }

                    for(Id prodID1 : prodQnMap.keySet()){                   
                        Decimal indvProdUnitPrice = 0.00;                                       
                        indvProdUnitPrice = prodUnitPrice.get(prodID1);                 
                        finalProdPrice.put(prodID1, indvProdUnitPrice);
                    }
                                    
                    Map<Id,Decimal> nonStockProdIdQn = new Map<Id,Decimal>();
                    Map<Id,Decimal> nonStockProdIdUnitPrice = new Map<Id,Decimal>();                
                    List<Manufacturing_Products__c> nonStkManfProdList= [select Product__c,Quantity__c from Manufacturing_Products__c where Manufacturing_Run__c = : manfID and Stock_Item__c = false];
                    if(nonStkManfProdList.size() > 0){
                        for(Manufacturing_Products__c manfProdObj : nonStkManfProdList){
                            nonStockProdIdQn.put(manfProdObj.Product__c, manfProdObj.Quantity__c);
                        }
                    }               
                    
                    List<PricebookEntry> pbEntryList =[Select UnitPrice,Product2.Id From PricebookEntry WHERE PriceBook2.Name = 'Standard Price Book' and Product2.Id in :nonStockProdIdQn.keySet()];                        
                    if(pbEntryList.size() > 0){                                     
                        for(PricebookEntry pbObj : pbEntryList){
                            if(pbObj.UnitPrice != null){
                                nonStockProdIdUnitPrice.put(pbObj.Product2.Id, pbObj.UnitPrice);
                            }                       
                        }
                    } 
                    
                    for(Id nonStockProdID : nonStockProdIdQn.keySet()){
                        Decimal Qnty = 0.00;
                        Decimal indvProdUnitPrice = 0.00;
                        Decimal totUnitPrice = 0.00;
                        
                        Qnty = nonStockProdIdQn.get(nonStockProdID);
                        indvProdUnitPrice = nonStockProdIdUnitPrice.get(nonStockProdID);
                        totUnitPrice = indvProdUnitPrice * Qnty;
                        finalNonStkProdUnitPrice.put(nonStockProdID, totUnitPrice);
                    }               
                    
                    List<Manufacturing_Products__c> manfProdList = [select id,Quantity__c,Cost__c,Product__c from Manufacturing_Products__c where Manufacturing_Run__c = :manfID and Product__c = :prodId];
                    for(Manufacturing_Products__c mrItr : manfProdList){
                        mrItr.Quantity__c = newVal;                                       
                        mrItr.Cost__c = finalProdPrice.get(mrItr.Product__c);
                    }               
                    update manfProdList; //update the Manufacturing_Products__c Quantity with the new value  
                    
                    for(Id stkProdId : finalProdPrice.keySet()){
                        finalTotalManfCost += finalProdPrice.get(stkProdId);
                    }       

                    for(Id nonStkProdId : finalNonStkProdUnitPrice.keySet()){
                        finalTotalManfCost += finalNonStkProdUnitPrice.get(nonStkProdId);
                    }
                    
                    //get the manufacturing run and update the unit cost 
                    Manufacturing_Run__c mrObj = [select id,Required_Quantity__c,Unit_Price__c,Total_Cost__c from Manufacturing_Run__c where id = :manfID];
                    mrObj.Unit_Price__c = finalTotalManfCost / mrObj.Required_Quantity__c;              
                    mrObj.Total_Cost__c = mrObj.Unit_Price__c * mrObj.Required_Quantity__c;                 
                    update mrObj;
                    //ends here             
                }//recalculation logic ends here 
                
            }catch(Exception e){
                createErrorLog.insertError('ManufacturingRun',e.getMessage(),'Method - editReservedStock',null,'',e.getStackTraceString(),UserInfo.getUserId());                    
            }
        }
        return msg;
    }
    //ends here        
    
    // Stock Movement code starts from here
    @AuraEnabled
    public static String getLocationName(String locId){
        String locName = '';
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location__c')
            
            &&  CRUD_FLS_CheckUtility.checkReadPermission('Inventory_Location__c',new set<String>{'id','Name','sigmaerpdev2__Location__r.Name'}))
        {
            List<Inventory_Location__c> locNameList = [select Location__r.Name from Inventory_Location__c where id = :locId];
            if(locNameList[0].Location__r.Name != null){
                locName = locNameList[0].Location__r.Name;
            } 
        }           
        return locName;
    }
           
    @auraEnabled
    public static String StockEntrySave(String ILData,Decimal producedQty,Manufacturing_Run__c MfRun,Decimal UnitPrice,Decimal TotalCost, Decimal passQty, Decimal failQty, String qcDesc, String barCodeValue, String prodAttributeTypeNew, Decimal systemCalc, Decimal userAdded, Boolean addWastage)
    {   
        Boolean backOrderPresent;
        String retVal = 'success';
        if(CRUD_FLS_CheckUtility.checkObjCRUD('product2')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sublevel_location__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run_ILPs__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run_Inventory_Location__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run_QC__c')          
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Serial_Number__c')
            
            &&  CRUD_FLS_CheckUtility.checkReadPermission('product2',new set<String>{'id','Name','sigmaerpdev2__Product_Bar_Code__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new set<String>{'id','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__ProductCode__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location__c',new set<String>{'id','name'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sublevel_location__c',new set<String>{'id','name','sigmaerpdev2__Inventory_Location__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'id','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Products__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Inventory__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run__c',new set<String>{'id','name','sigmaerpdev2__Product__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run_ILPs__c',new set<String>{'id','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Produced_Quantity__c','sigmaerpdev2__Manufacturing_Run__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'id','name'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run_Inventory_Location__c',new set<String>{'id','name'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run_QC__c',new set<String>{'id','name'})
            
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Serial_Number__c',new set<String>{'id','name'})
            
            &&  CRUD_FLS_CheckUtility.checkFLS('product2',new set<String>{'sigmaerpdev2__Product_Bar_Code__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new set<String>{'sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Total_Qty__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'sigmaerpdev2__Inventory__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Products__c','sigmaerpdev2__Received_Quantity__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Batch_No__c','sigmaerpdev2__Manufacturing_Run__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Stock_Type__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product_Expiry_Date__c','sigmaerpdev2__Product_Serial_Number__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Manufacturing_Run__c',new set<String>{'sigmaerpdev2__Batch_Number__c','sigmaerpdev2__Expiry_date_of_Batch__c','sigmaerpdev2__Status__c','sigmaerpdev2__PI_updated__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Total_Cost__c','sigmaerpdev2__System_Wastage__c','sigmaerpdev2__User_Wastage__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Manufacturing_Run_QC__c',new set<String>{'sigmaerpdev2__Passed_Qty__c','sigmaerpdev2__Failed_Qty__c','sigmaerpdev2__Comments__c','sigmaerpdev2__Product__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Manufacturing_Run_ILPs__c',new set<String>{'sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Product__c'})
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Manufacturing_Run_Inventory_Location__c',new set<String>{'sigmaerpdev2__Moved_Quantity__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Location_Sublevel__c','sigmaerpdev2__Location_Sublevel_Zone__c'})
            
            &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Serial_Number__c',new set<String>{'sigmaerpdev2__Serial_Number__c','sigmaerpdev2__Status__c'})
        
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Manufacturing_Run_QC__c',new Set<String>{'sigmaerpdev2__Manufacturing_Run__c'})
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Manufacturing_Run_ILPs__c',new Set<String>{'sigmaerpdev2__Manufacturing_Run__c'})
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Manufacturing_Run_Inventory_Location__c',new Set<String>{'sigmaerpdev2__Manufacturing_Run__c'})
        )
        {          
            ID productID;
            Date bExpDate;
            List<product2> prodList = new List<Product2>();        
            List<Inventory_Location__c> ILList = new List<Inventory_Location__c>();
            List<ID> locIDs = new List<ID>();
            List<ID> BinIDs = new List<ID>();
            Map<ID,Decimal> wrapperMap = new Map<ID,Decimal>();
            List<Inventory__c> Pi = new List<Inventory__c>();
            LIst<Inventory_Location_Product__c> ilpList = new LIst<Inventory_Location_Product__c>();
            Map<ID,Inventory_Location_Product__c> ILPMap = new Map<ID,Inventory_Location_Product__c>();
            Map<ID,Inventory_Location_Product__c> existingILPs = new Map<ID,Inventory_Location_Product__c>();
            Map<Id, Decimal> ilpRecQnMap = new Map<Id, Decimal>();
            Map<ID,Inventory_Location_Product__c> createdILPs = new Map<ID,Inventory_Location_Product__c>();
            List<Inventory_Location_Product_Line_Item__c> createILPLIs = new List<Inventory_Location_Product_Line_Item__c>();
            
            EditDataWrapper WrapperList = (EditDataWrapper)JSON.deserialize(ILData,EditDataWrapper.class);
                                    
            List<Manufacturing_Run_ILPs__c> MRilpList = new List<Manufacturing_Run_ILPs__c>();
            MRilpList = [select id,Inventory_Location_Product__c,Produced_Quantity__c,Manufacturing_Run__c from Manufacturing_Run_ILPs__c where Manufacturing_Run__c=:MfRun.id];
            Decimal numberOfQty = 0;
            system.debug('MRilpList>>>'+MRilpList);
            for(Manufacturing_Run_ILPs__c i : MRilpList)
            {
                system.debug('i.Produced_Quantity__c;>>>'+ i.Produced_Quantity__c);
            
                numberOfQty += i.Produced_Quantity__c;
            }
            system.debug('numberOfQty>>>'+numberOfQty);
                    
            List<Manufacturing_Run_Inventory_Location__c> iListToInsert=new List<Manufacturing_Run_Inventory_Location__c>();
            for(wrapperData invloc : WrapperList.ListOfILs)
            {
                if(wrapperMap.containsKey(invloc.invLocRecID))
                    wrapperMap.put(invloc.invLocRecID,wrapperMap.get(invloc.invLocRecID)+invloc.MovedQty);
                else if(!wrapperMap.containsKey(invloc.invLocRecID))
                    wrapperMap.put(invloc.invLocRecID,invloc.MovedQty);
                locIDs.add(invloc.invLocRecID);
                if(invloc.BinID != '')
                    BinIDs.add(invloc.BinID);
                
                Manufacturing_Run_Inventory_Location__c ch = new Manufacturing_Run_Inventory_Location__c();
                ch.Manufacturing_Run__c = mfRun.id;
                ch.Moved_Quantity__c = invloc.MovedQty;
                ch.Inventory_Location__c = invloc.invLocRecID;
                ch.Location_Sublevel__c = (invloc.BinId != '' ? invloc.BinId : null);
                //newly added code to save Zone - added on 2/5/2019            
                ch.Location_Sublevel_Zone__c = (invloc.ZoneId != '' ? invloc.ZoneId : null);            
                //ends here
                iListToInsert.add(ch);
            }
            
            List<Sublevel_location__c> binList = new List<Sublevel_location__c>();
            if(BinIDs.size() > 0)
                binList = [select id,name,Inventory_Location__c from Sublevel_location__c where id IN: BinIDs];
            map<ID,ID> binMap = new map<ID,ID>();
            for(Sublevel_location__c bn : binList)
                binMap.put(bn.id,bn.Inventory_Location__c);
            
            for(wrapperData invlo : WrapperList.ListOfILs){
                if(invlo.BinID != ''){
                    if(binMap.containsKey(invlo.BinID)){
                        if(binMap.get(invlo.BinID) != invlo.invLocRecID)
                            throw new AuraHandledException('Bin \''+invlo.BinName+'\' does\'nt belong to location \''+invlo.Name+'\'. Please choose the correct bin.');
                    }
                }
            }
            
            try{                        
                prodList = [select id,Name from product2 where id =: mfRun.Product__c];
                 system.debug('pi>>'+prodList);
                if(prodList.size() > 0)
                    productID = prodList[0].id;    
                
                pi = [select id,Available_Qty__c,Total_Available_Qty__c from Inventory__c where ProductCode__c = :mfRun.Product__c];
                system.debug('pi>>'+pi);
                ilpList = [select id,Inventory_Location__c,Products__c,Received_Quantity__c from Inventory_Location_Product__c where Inventory_Location__c IN: locIDs AND Products__c =: productID];
                
                List<Manufacturing_Run_ILPs__c> MRILPsToInsert = new List<Manufacturing_Run_ILPs__c>();
                
                for(Inventory_Location_Product__c il : ilpList)
                    ILPMap.put(il.Inventory_Location__c,il);
                
                for(wrapperData w: WrapperList.ListOfILs){
                    if(ILPMap.containsKey(w.invLocRecID)){
                        existingILPs.put(w.invLocRecID,ILPMap.get(w.invLocRecID));
                        Manufacturing_Run_ILPs__c mi = new Manufacturing_Run_ILPs__c();
                        mi.Inventory_Location_Product__c = ILPMap.get(w.invLocRecID).id;
                        mi.Inventory_Location__c = w.invLocRecID;
                        mi.Manufacturing_Run__c = MfRun.id;                    
                        mi.Product__c = productID;
                        MRILPsToInsert.add(mi);
                    }else if(createdILPs.containsKey(w.invLocRecID)){
                        Decimal prodQuantity = 0;
                        Inventory_Location_Product__c ilpp = new Inventory_Location_Product__c();
                        ilpp = createdILPs.get(w.invLocRecID);                                       
                        ilpp.Inventory__c = pi[0].id;
                        createdILPs.put(w.invLocRecID,ilpp);
                    }else{
                        Inventory_Location_Product__c ii = new Inventory_Location_Product__c();
                        ii.Inventory_Location__c = w.invLocRecID;
                        ii.Products__c = productID;                                                          
                        ii.Inventory__c = pi[0].id;
                        createdILPs.put(w.invLocRecID,ii);
                    } 
                }             
                insert createdILPs.values();
                
                for(Inventory_Location_Product__c s : createdILPs.values()){
                    Manufacturing_Run_ILPs__c mi = new Manufacturing_Run_ILPs__c();
                    mi.Inventory_Location_Product__c = s.id;
                    mi.Inventory_Location__c = s.Inventory_Location__c;
                    mi.Manufacturing_Run__c = MfRun.id;                
                    mi.Product__c = productID;
                    MRILPsToInsert.add(mi);
                }
                
                update existingILPs.values();
                existingILPs.putAll(createdILPs); 
                            
                MfRun.Batch_Number__c = WrapperList.manfObject.Batch_Number__c;
                MfRun.Expiry_date_of_Batch__c = WrapperList.manfObject.Expiry_date_of_Batch__c;
                MfRun.Status__c = 'Produced';
                MfRun.PI_updated__c = true;
                MfRun.Unit_Price__c = UnitPrice;
                MfRun.Total_Cost__c = TotalCost;
        
                MfRun.Produced_Quantity__c = producedQty; //added on 8/5/2020 - as produced qty is now editable in post production stage(updating with new value).
                
                //added newly on 13/4/2020 to add wastage charges and update to MR object
                if(addWastage){
                    MfRun.System_Wastage__c = systemCalc;
                    MfRun.User_Wastage__c = userAdded;
                }
                //ends here
                            
                //added newly to insert MR - QC records on 24/1/2020
                Manufacturing_Run_QC__c mrQC = new Manufacturing_Run_QC__c();           
                mrQC.Passed_Qty__c = passQty;
                mrQC.Failed_Qty__c = failQty;
                mrQC.Comments__c = qcDesc;
                mrQC.Manufacturing_Run__c = mfRun.id;
                mrQC.Product__c = mfRun.Product__c;
                insert mrQC;
                //ends here
                
                //code to be moved back - added on 15/6/2020
                Default_Parameters__c defPrmObj = [select Default_Damaged_Location__c from Default_Parameters__c limit 1];                      
                
                Damaged_Products_MR__c damProObj = new Damaged_Products_MR__c();
                damProObj.Damaged_Qty__c = failQty;
                damProObj.Reason__c = qcDesc;
                if(defPrmObj.Default_Damaged_Location__c != null){
                    damProObj.Location__c = defPrmObj.Default_Damaged_Location__c;
                }                   
                insert damProObj;
                //ends here
                
                //added newly to insert bar code value for manufactured product
                if(barCodeValue != null && barCodeValue != ''){
                    Product2 prodObj = [select id,Product_Bar_Code__c from Product2 where id = : mfRun.Product__c];
                    prodObj.Product_Bar_Code__c = barCodeValue;
                    update prodObj;
                }
                //ends here
                                
               
                //if product is serialized product create same number of ilplis(as produced qty) -added on 3/3/2020             
                List<Product_Serial_Number__c> srpliList = new List<Product_Serial_Number__c>();
                Map<Integer, Id> ilpMapPsn = new Map<Integer, Id>();
                Map<Integer, Id> ilpBinPsn = new Map<Integer, Id>();
                if(prodAttributeTypeNew == 'SERIALIZED'){                   
                    Set<String> serNumSetVal = new Set<String>();                   
                    for(String sWrapObj : WrapperList.serialNumberLst){                     
                        serNumSetVal.add(sWrapObj);
                        system.debug('serNumSetVal>>>>'+serNumSetVal);
                    }                   
                    //insert product serial number records       
                    system.debug('mfRun>>>>'+mfRun);               
                    for(String serNamesObj : serNumSetVal){ 
                         system.debug('serNamesObj>>>>'+serNamesObj);
                        Product_Serial_Number__c srpli = new Product_Serial_Number__c();                        
                        srpli.Serial_Number__c = serNamesObj;
                        srpli.Status__c = 'Available';   
                        srpli.Product_Code__c = mfRun.Product__c;
                    //    srpli.Location__c=;
					 //   srpli.Bin__c=;
                        srpliList.add(srpli);                       
                    }
                    //ends here
                    insert srpliList;
                                        
                    Integer insRowId = 0;
                    Map<Integer, String> psnValMap = new Map<Integer, String>();
                    for(Product_Serial_Number__c psnObj : srpliList){
                        psnValMap.put(insRowId, psnObj.Id);
                        insRowId++;
                    }
                        
                    Integer rowListofILs = 0;
                    for(wrapperData w: WrapperList.ListOfILs){ 
                        if(ilpRecQnMap.containsKey(existingILPs.get(w.invLocRecID).id)){
                            Decimal qty = ilpRecQnMap.get(existingILPs.get(w.invLocRecID).id) + w.MovedQty;
                            ilpRecQnMap.put(existingILPs.get(w.invLocRecID).id, qty);
                        }else{
                            ilpRecQnMap.put(existingILPs.get(w.invLocRecID).id, w.MovedQty);
                        }

                        List<Inventory_Location_Product_Line_Item__c> interimILPLISaveList = new List<Inventory_Location_Product_Line_Item__c>();
                        for(Integer i=0; i < w.MovedQty; i++){
                            Inventory_Location_Product_Line_Item__c ilpli = new Inventory_Location_Product_Line_Item__c();
                            ilpli.Inventory_Location_Product__c = existingILPs.get(w.invLocRecID).id;
                            ilpli.Received_Quantity__c = 1; 
                            ilpli.Batch_No__c = WrapperList.manfObject.Batch_Number__c;              
                            ilpli.Manufacturing_Run__c = MfRun.id; 
                            ilpli.Unit_Price__c = UnitPrice;                
                            ilpli.Bin__c = (w.BinId != ''?w.BinId:null);                                                        
                            ilpli.Stock_Type__c = 'Manufactured';                           
                            ilpli.Product__c = productID;                           
                            ilpli.Product_Expiry_Date__c = WrapperList.manfObject.Expiry_date_of_Batch__c;                          
                            
                            ilpli.Inventory_Location__c = w.invLocRecID; //added newly on 24-6-2020 to update IL field in ILPLI 
                            
                            interimILPLISaveList.add(ilpli);
                            ilpMapPsn.put(rowListofILs, existingILPs.get(w.invLocRecID).id);
                        ilpBinPsn.put(rowListofILs, (w.BinId != ''?w.BinId:null));
                        rowListofILs++;
                            
                        }
                        createILPLIs.addAll(interimILPLISaveList);
                        
                       /* ilpMapPsn.put(rowListofILs, existingILPs.get(w.invLocRecID).id);
                        ilpBinPsn.put(rowListofILs, (w.BinId != ''?w.BinId:null));
                        rowListofILs++;*/
                        
                    }
                    insert createILPLIs;
                    
                    Integer getRowId = 0;
                    for(Inventory_Location_Product_Line_Item__c ilpliObj1 : createILPLIs){                      
                        if(psnValMap.get(getRowId) != null){
                            ilpliObj1.Product_Serial_Number__c = psnValMap.get(getRowId);                           
                        }                       
                        getRowId++;
                    }
                    update createILPLIs;
                    
                    //update psn object ilp and bin
                    Integer rowValPsn = 0;
                    for(Product_Serial_Number__c psnObj : srpliList){
                        if(ilpMapPsn.get(rowValPsn) != null){
                            psnObj.Inventory_Location_Product__c = ilpMapPsn.get(rowValPsn); 
                            system.debug('psnObj.Bin__c>>>'+psnObj.Inventory_Location_Product__c);
                        }
                        if(ilpBinPsn.get(rowValPsn) != null){
                            psnObj.Bin__c = ilpBinPsn.get(rowValPsn);
                            system.debug('psnObj.Bin__c>>>'+psnObj.Bin__c);
                        }
                       rowValPsn++;
                    }
                    update srpliList;
                    //ends here
                    //update IL in psn
                    Map<Id,Id> ilpILMap = new Map<Id,Id>();
                    List<Inventory_Location_Product__c> ilpILListNew = [select Id,Inventory_Location__c from Inventory_Location_Product__c where Id in : ilpMapPsn.values()];
                    for(Inventory_Location_Product__c ilpObj1 : ilpILListNew){
                        ilpILMap.put(ilpObj1.Id, ilpObj1.Inventory_Location__c);
                    }
                    for(Product_Serial_Number__c psnObj : srpliList){
                        system.debug('psnObj>>>'+psnObj);
                        if(ilpILMap.get(psnObj.Inventory_Location_Product__c) != null){
                            system.debug('Inventory_Location_Product__c>>>'+ilpILMap.get(psnObj.Inventory_Location_Product__c));
                            psnObj.Inventory_Location__c = ilpILMap.get(psnObj.Inventory_Location_Product__c);                          
                        }                       
                    }
                    update srpliList;
                    system.debug('srpliList>>>'+srpliList);
                    //ends here
                    
                }//ends here                
                else{ //else if product is bulk product
                    for(wrapperData w: WrapperList.ListOfILs){ 
                        if(ilpRecQnMap.containsKey(existingILPs.get(w.invLocRecID).id)){
                            Decimal qty = ilpRecQnMap.get(existingILPs.get(w.invLocRecID).id) + w.MovedQty;
                            ilpRecQnMap.put(existingILPs.get(w.invLocRecID).id, qty);
                        }else{
                            ilpRecQnMap.put(existingILPs.get(w.invLocRecID).id, w.MovedQty);
                        }
                       
                        Inventory_Location_Product_Line_Item__c ilpli = new Inventory_Location_Product_Line_Item__c();
                        ilpli.Inventory_Location_Product__c = existingILPs.get(w.invLocRecID).id;
                        ilpli.Received_Quantity__c = w.MovedQty; //available quantity replaced with Received_Quantity__c 
                        ilpli.Batch_No__c = WrapperList.manfObject.Batch_Number__c;              
                        ilpli.Manufacturing_Run__c = MfRun.id; 
                        ilpli.Unit_Price__c = UnitPrice;                
                        ilpli.Bin__c = (w.BinId != ''?w.BinId:null);
                        
                        //changed on 10/02/2020 to show ilpli source is manufactured[updates stock_type__c field now]
                        ilpli.Stock_Type__c = 'Manufactured'; 
                        //ends here 

                        ilpli.Product__c = productID; //product Id                        
                        ilpli.Product_Expiry_Date__c = WrapperList.manfObject.Expiry_date_of_Batch__c;                          
                        ilpli.Inventory_Location__c = w.invLocRecID; //added newly on 24-6-2020 to update IL field in ILPLI 
                            
                        createILPLIs.add(ilpli); 
                    }
                    insert createILPLIs;
                }

                //update ILP and PI received quantities once stock is moved - added on 23/12/2019
                Map<Id, Decimal> allocatedPIs = new Map<Id, Decimal>();
                LIst<Inventory_Location_Product__c> ilpListToUpdate = new LIst<Inventory_Location_Product__c>();            
                ilpListToUpdate = [select id, Received_Quantity__c,Inventory__c from Inventory_Location_Product__c where id in :ilpRecQnMap.keySet()];
                     
                for(Inventory_Location_Product__c ilpObj : ilpListToUpdate){
                    if(ilpRecQnMap.get(ilpObj.Id) != null){
                        ilpObj.Received_Quantity__c = ilpObj.Received_Quantity__c + ilpRecQnMap.get(ilpObj.Id);
                        if(allocatedPIs.containsKey(ilpObj.Inventory__c)){                        
                            Decimal qty1 = allocatedPIs.get(ilpObj.Inventory__c) + ilpRecQnMap.get(ilpObj.Id);                      
                            allocatedPIs.put(ilpObj.Inventory__c, qty1);
                        }else{                        
                            allocatedPIs.put(ilpObj.Inventory__c, ilpRecQnMap.get(ilpObj.Id));
                        }                   
                    }               
                }
                update ilpListToUpdate;
                
                List<Inventory__c> productInventoryList;        
                productInventoryList = [Select Id,Comments__c,Available_Qty__c,Total_Qty__c,ProductCode__c,Avg_Buying_Price__c From Inventory__c where ProductCode__c = :mfRun.Product__c];     

                Id prodInvId;
                if(productInventoryList.size() > 0){
                    prodInvId = productInventoryList[0].Id;
                    for(Inventory__c inv : productInventoryList){                                                                
                        if(allocatedPIs.get(inv.Id) != null){
                            inv.Available_Qty__c = inv.Available_Qty__c + allocatedPIs.get(inv.Id); 
                            inv.Total_Qty__c = inv.Total_Qty__c + allocatedPIs.get(inv.Id);   
                            inv.Comments__c = 'Inventory Updated after producing product via Manufacture Run Process.';

                       }                                          
                    }
                   // productInventoryList[0].Comments__c = 'Inventory Updated after producing product via Manufacture Run Process.';             
                    update productInventoryList;

                }
                //ends here
                        
                update MfRun;
                //insert createILPLIs;
                insert MRILPsToInsert;
                insert iListToInsert;
                
                //added code on 20/2/2020 to update avg buying price in PI
                Set<Id> ilpIds = new Map<Id, Inventory_Location_Product__c>([select id from Inventory_Location_Product__c where Inventory__c = :prodInvId]).keySet();
                List<Inventory_Location_Product_Line_Item__c> prodILPLIList = [select id,Unit_Price__c from Inventory_Location_Product_Line_Item__c where Inventory_Location_Product__c in :ilpIds];  
                Decimal unitPricTot = 0.0;
                if(prodILPLIList.size() > 0){
                    for(Inventory_Location_Product_Line_Item__c ilpliListObj : prodILPLIList){
                        unitPricTot += ilpliListObj.Unit_Price__c;
                    }
                    if(productInventoryList.size() > 0){
                        for(Inventory__c inv1 : productInventoryList){
                            inv1.Avg_Buying_Price__c = (unitPricTot / prodILPLIList.size());
                        }
                        update productInventoryList;
                    }   
                }                   
                //ends here
                
                //code to handle backorder notify
                 
                Map<ID,decimal> backorderqunt = new Map<ID,decimal>();
                string flag ='MR';
                backorderqunt.put(mfRun.Product__c,producedQty);
                
                try{
                    if(backorderqunt.size()>0)          
                        backOrderPresent = BackOrderMailService.notifyBackOrderStockAvailable(backorderqunt,flag);
                    if(backOrderPresent)
                          retVal = 'passed';
                }
                catch(Exception e){             
                    //return false;
                }
                
               
                //calling Finance class                
                LinkageServiceClass.sigmafinanceInboundwrap slvar = new LinkageServiceClass.sigmafinanceInboundwrap();
                LinkageServiceClass.sigmafinanceInboundMRunwrap slvarInner = new LinkageServiceClass.sigmafinanceInboundMRunwrap();
                slvarInner.UnitPrice = UnitPrice;
                slvarInner.TotalCost = TotalCost;
                slvarInner.producedQty = producedQty;
                slvarInner.MfRun = MfRun;
                slvarInner.ILPs = existingILPs;
                slvarInner.movedQty = ilpRecQnMap;
                slvar.source = 'StockManufacting';
                slvar.MnufcturingDetails = slvarInner;
                slvar.ilpliList = createILPLIs;
                
                LinkageServiceClass.slInbound(slvar); 
                
            }catch(Exception ex){
                String errormsg = ex.getMessage();
                 System.debug('errormsg>>'+errormsg);
                createErrorLog.insertError('ManufacturingRun',ex.getMessage(),'Error in StockEntrySave method',null,'',ex.getStackTraceString(),UserInfo.getUserId());
                retVal = ex.getMessage();
            }
        }
        //return backOrderPresent;
        return retVal;
    } 
    
   
    
    @auraEnabled
    public static EditDataWrapper getStockMovementData(ID mrID)
    {
        EditDataWrapper editData;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run__c') 
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run_Inventory_Location__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run_ILPs__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
            
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run__c',new set<String>{'id','sigmaerpdev2__Status__c','sigmaerpdev2__Product__r.sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Total_Cost__c','sigmaerpdev2__QC_Passed__c','sigmaerpdev2__Batch_Number__c','sigmaerpdev2__Produced_Quantity__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Expiry_date_of_Batch__c','sigmaerpdev2__Manufacturing_Run__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run_Inventory_Location__c',new set<String>{'id','Name','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Inventory_Location__r.Name','sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__r.Name','sigmaerpdev2__Manufacturing_Run__c','sigmaerpdev2__Moved_Quantity__c','sigmaerpdev2__Location_Sublevel__c','sigmaerpdev2__Location_Sublevel__r.Name','sigmaerpdev2__Location_Sublevel_Zone__c','sigmaerpdev2__Location_Sublevel_Zone__r.Name'})   
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run_ILPs__c',new set<String>{'id','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Manufacturing_Run__c','sigmaerpdev2__Inventory_Location__c'})
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'id','sigmaerpdev2__Manufacturing_Run__c'})
        )
        {
            try{
                List<Manufacturing_Run__c> m = new List<Manufacturing_Run__c>();
                m = [select id,Status__c,Product__r.Attribute_Type__c,Product__r.Product_Bar_Code__c,Total_Cost__c,QC_Passed__c,Batch_Number__c,Produced_Quantity__c,Unit_Price__c,Expiry_date_of_Batch__c,(select id,Name,Inventory_Location__c,Inventory_Location__r.Name,Inventory_Location__r.Location__r.Name,Manufacturing_Run__c,Moved_Quantity__c,Location_Sublevel__c,Location_Sublevel__r.Name,
                        Location_Sublevel_Zone__c,Location_Sublevel_Zone__r.Name from Manufacturing_Run_Inventory_Locations__r),(select id,Inventory_Location_Product__c,Manufacturing_Run__c,Inventory_Location__c from Manufacturing_Run_ILPs__r),(select id,Manufacturing_Run__c from Inventory_Location_Product_Line_Items__r) from Manufacturing_Run__c where id=: mrID];
                Map<ID,Decimal> mp = new Map<ID,Decimal>();
                List<Manufacturing_Run_Inventory_Location__c> i1 = new List<Manufacturing_Run_Inventory_Location__c>();
                List<Manufacturing_Run_ILPs__c> i2 = new List<Manufacturing_Run_ILPs__c>();
                List<Inventory_Location_Product_Line_Item__c> i3 = new List<Inventory_Location_Product_Line_Item__c>();
                List<wrapperData> ww = new List<wrapperData>();
                List<String> serialNumberLst = new List<String>();
                String prodAttr;
                
                //added newly on 8/4/2020 to handle wastage charges in MR
                Decimal wastgCharges; 
                Account acctObj = new Account();    //added on 20/4/2020 to show Default Location name before adding Storage locations          
                Default_Parameters__c defPrmObj = [select Wastage_Amount_MR__c, Default_Location__c,Default_Damaged_Location__c from Default_Parameters__c limit 1];
                if(defPrmObj.Wastage_Amount_MR__c != null){
                    wastgCharges = (defPrmObj.Wastage_Amount_MR__c * m[0].Total_Cost__c) / 100;
                }
                
                if(defPrmObj.Default_Location__c != null){                  
                    Inventory_Location__c ilObj = [select id, Location__c from Inventory_Location__c where id = :defPrmObj.Default_Location__c];
                    acctObj = [select id, name from account where id = :ilObj.Location__c]; 
                }
                  
                //ends here		
                
                //code to be moved back - added on 12/6/2020
                Account damagedLocObj = new Account();
                if(defPrmObj.Default_Damaged_Location__c != null){                  
                    Inventory_Location__c ilDamagedObj = [select id, Location__c from Inventory_Location__c where id = :defPrmObj.Default_Damaged_Location__c];
                  //  damagedLocObj = [select id, name from account where id = :ilDamagedObj.Location__c]; 
                }
                //ends here
                
                Manufacturing_Run__c mobj = new Manufacturing_Run__c();
                if(m.size() > 0){
                    mobj = m[0];
                    mobj.Batch_Number__c = m[0].Batch_Number__c;
                    mobj.Expiry_date_of_Batch__c = m[0].Expiry_date_of_Batch__c;
                    prodAttr = m[0].Product__r.Attribute_Type__c;                           
                    
                    for(Manufacturing_Run_Inventory_Location__c il : m[0].Manufacturing_Run_Inventory_Locations__r){
                        i1.add(il);                    
                        ww.add(new wrapperData(il.Inventory_Location__c,
                        il.Inventory_Location__r.Name,
                        il.Moved_Quantity__c,
                        il.Location_Sublevel__c,
                        il.Location_Sublevel__r.Name,
                        il.Inventory_Location__r.Location__c,
                        il.Inventory_Location__r.Location__r.Name,
                        il.Location_Sublevel_Zone__c,
                        il.Location_Sublevel_Zone__r.Name 
                        ));
                    }                 
                    for(Manufacturing_Run_ILPs__c ilp : m[0].Manufacturing_Run_ILPs__r){
                        i2.add(ilp);
                    }                
                    for(Inventory_Location_Product_Line_Item__c ilpli : m[0].Inventory_Location_Product_Line_Items__r){
                        i3.add(ilpli);
                    }
                }
                editData = new EditDataWrapper(mobj,ww,i1,i2,i3,prodAttr,serialNumberLst,wastgCharges,acctObj,damagedLocObj);         
                return editData;
            }catch(Exception ex){            
                createErrorLog.insertError('ManufacturingRun',ex.getMessage(),'Error in getStockMovementData method',null,'',ex.getStackTraceString(),UserInfo.getUserId());
                return null;
            }
        }
        return editData;
    }
    
    
    //code added to handle the total backorder quantity--- 19-12-2019
    @auraenabled
    public static decimal fetchsigmaorderline(String prodID)
    {
        decimal totalquantity = 0;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('account') 

            &&  CRUD_FLS_CheckUtility.checkReadPermission('account',new set<String>{'id','Name','sigmaerpdev2__Default_Location__c'})
        )
        {
            if(prodID !=null)
            {
              for(Product_Order_Price_Book__c ordeline :[select id,name,Back_Order__c,Net_Quantity__c,Order_Status__c,Sigma_Order__r.Order_Created_Via__c,Sigma_Order__r.Name from Product_Order_Price_Book__c where Back_Order__c = true and Product__c =:prodID and IsInventoryUpdated__c =false and Order_Status__c ='Order Confirmed'])
              {
                 
                    totalquantity+=ordeline.Net_Quantity__c;
               }
            }
        }
        return totalquantity;
    }
    
    //code ends
    
    //code to handle default location 
    /*@auraenabled
    public static account fetchDefaultLocation()
    {
        account acc=[select id,name from account where Default_Location__c =true limit 1];
        return acc;
    }*/
    
    /*@auraenabled
    public static account fetchDefaultLocation()
    {    
        Account acc = new Account();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Default_Parameters__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location__c')
            &&  CRUD_FLS_CheckUtility.checkObjCRUD('Account')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Default_Parameters__c',new Set<String>{'sigmaerpdev2__Default_Location__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location__c',new Set<String>{'Id','sigmaerpdev2__Location__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('Account',new Set<String>{'Id','Name'})
        )
        {
            try{
                Default_Parameters__c defObj = [select Default_Location__c from Default_Parameters__c limit 1];
                Inventory_Location__c ilObj = [select id, Location__c from Inventory_Location__c where id = :defObj.Default_Location__c];
                acc = [select id,name from account where id = :ilObj.Location__c];              
            }catch(Exception ex){            
                createErrorLog.insertError('ManufacturingRun',ex.getMessage(),'Error in fetchDefaultLocation method',null,'',ex.getStackTraceString(),UserInfo.getUserId());
                return null;
            }                   
        }
        return acc;     
    }*/
    
    public class wrapperData{
        @auraEnabled
        public ID invLocRecID;
        @auraEnabled
        public Decimal MovedQty = 0;
        @auraEnabled
        public String Name;
        @auraEnabled
        public String BinID;
        @auraEnabled
        public String BinName;
        @auraEnabled
        public String locID;
        @auraEnabled
        public String locName;        
        @auraEnabled
        public String ZoneId;
        @auraEnabled
        public String ZoneName;
        
        public wrapperData(ID recID,String nm,Decimal qty,String Bin,String BName, String loc, String locN, String zone, String zoneN){
            invLocRecID = recID;
            Name = nm;
            MovedQty = qty;
            BinID = Bin;
            BinName = BName;
            locID = loc;
            locName = locN;
            ZoneId = zone;
            ZoneName = zoneN;
        }
    }
    
    public class SerNumWrap{
        @AuraEnabled
        public String SerialNo{get;set;}
        public SerNumWrap(String SerialNo){
            this.SerialNo = SerialNo;
        }
    }
    
    public class EditDataWrapper{
        @auraEnabled
        public List<wrapperData> ListOfILs;
        @auraEnabled
        public Manufacturing_Run__c manfObject;
        @auraEnabled
        public List<Manufacturing_Run_Inventory_Location__c> ILsRec;
        @auraEnabled
        public List<Manufacturing_Run_ILPs__c> ILPsRec;
        @auraEnabled
        public List<Inventory_Location_Product_Line_Item__c> ILPLIsRec;
        @auraEnabled
        public String prodAttrType;     
        @AuraEnabled
        public List<String> serialNumberLst{get;set;}
        
        @AuraEnabled
        public Decimal wastageChrgs{get;set;}
        
        @AuraEnabled
        public Account acctObj{get;set;}
        
        @AuraEnabled
        public Account defDamagedLocObj{get;set;}
        
        public EditDataWrapper(Manufacturing_Run__c ob,List<wrapperData> d,List<Manufacturing_Run_Inventory_Location__c> ils,List<Manufacturing_Run_ILPs__c> ilps,List<Inventory_Location_Product_Line_Item__c> ilplis, String prodAttrTy, List<String> serNumLst, Decimal wastg, Account actObj, Account defDmgdObj){
            if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run_Inventory_Location__c') 
                && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Run_ILPs__c')
                && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
            )
            {
                ListOfILs = new List<wrapperData>();
                ILsRec = new List<Manufacturing_Run_Inventory_Location__c>();
                ILPsRec = new List<Manufacturing_Run_ILPs__c>();
                ILPLIsRec = new List<Inventory_Location_Product_Line_Item__c>();            
                serialNumberLst = new List<String>();
                
                ListOfILs = d;
                manfObject = ob;
                ILsRec = ils;
                ILPsRec = ilps;
                ILPLIsRec = ilplis; 
                prodAttrType = prodAttrTy;
                serialNumberLst = serNumLst;   

                wastageChrgs = wastg;
                acctObj = actObj;
                defDamagedLocObj = defDmgdObj;
            }
        }
    }
    
   @AuraEnabled
    public static Project_Resource__c saveResourceObject(String resource, String ManuID)
    {        
        Project_Resource__c resourceRecord;
         if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Project_Resource__c')
        &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Project_Resource__c',new set<String>{'sigmaerpdev2__Manufacturing_Run__c','sigmaerpdev2__Resource__r'})
            ){ 
        try{     
            Type otype = Type.forName('sigmaerpdev2__Project_Resource__c');
            resourceRecord = (Project_Resource__c )JSON.deserialize(resource, otype);            
            resourceRecord.Resource__r = null;
            resourceRecord.Manufacturing_Run__c=ManuID;
            insert resourceRecord;            
        }catch (Exception ex){
            
        }
            }
        return resourceRecord;
    }
    
    //code added to fetch existing Resource Roles to autopopulate while adding Resources to Respective MR for Resource Planning Usage
    @AuraEnabled
    public static Resource__c fetchResourceData(String resourceid)
    {     
        Resource__c res;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Resource__c') 
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Manufacturing_Run__c',new set<String>{'id','Name','sigmaerpdev2__Roles__c'}))
        {
            res=[select id,Name,Roles__c from Resource__c where id=:resourceid limit 1];          
        }
        return res;
  }
   
    //code added to fetch existing Resources in respective MR Table view for Resource Planning Usage
    @AuraEnabled
    public static List<Project_Resource__c> fetchMRResource(String manfRunId)
    {
        List<Project_Resource__c> manuResource;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Project_Resource__c') 
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Project_Resource__c',new set<String>{'id','Name','sigmaerpdev2__Manufacturing_Run__c','sigmaerpdev2__Resource__r.Name','sigmaerpdev2__Resource__r.sigmaerpdev2__Roles__c','sigmaerpdev2__Interval__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c'}))
        {
            if(manfRunId !=null && manfRunId !='')
            {
                manuResource =[select id,name,Manufacturing_Run__c,Resource__r.Name,Resource__r.Roles__c,Interval__c,Start_Date__c,End_Date__c from Project_Resource__c where Manufacturing_Run__c=:manfRunId limit 1000];                
            }
        }
        return manuResource;
    }
    
    //code added to Delete allocated Resources in respective MR for Resource Planning Usage
   @auraEnabled
    public static List<Project_Resource__c> deleteAllocResources(Id resId,String manfRunId){
        String flag = 'FAILED';
        List<Project_Resource__c> manuResource;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Project_Resource__c') 
            &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Project_Resource__c',new set<String>{'id','Name','sigmaerpdev2__Manufacturing_Run__c','sigmaerpdev2__Resource__r.Name','sigmaerpdev2__Resource__r.sigmaerpdev2__Roles__c','sigmaerpdev2__Interval__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c'}))
        {
            try{
                Project_Resource__c allocresobj = [select Id,Name from Project_Resource__c where Id = :resId];               
                delete allocresobj;
                manuResource=[select id,name,Manufacturing_Run__c,Resource__r.Name,Resource__r.Roles__c,Interval__c,Start_Date__c,End_Date__c from Project_Resource__c where Manufacturing_Run__c=:manfRunId limit 1000];
                flag = 'SUCCESS';
            }catch(Exception ex){           
                createErrorLog.insertError('ManufacturingRun',ex.getMessage(),'deleteAllocResources',null,'',ex.getStackTraceString(),UserInfo.getUserId());
                return manuResource;
            } 
        }
        return manuResource;
    }
    
    @auraEnabled
    Public static productInfo getProdFromRecp(Id recpID)
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
         && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Recipe__c')
         &&  CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'Id','Name'})
         &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Recipe__c',new set<String>{'sigmaerpdev2__Product__c'})
        ){
            try{
                Id prodID;
                productInfo prodObj = new productInfo();
                Recipe__c recpObj = [select Product__c from Recipe__c where id = :recpID];
                prodID = recpObj.Product__c;
                Product2 prd = [SELECT Id, Name FROM Product2 where Id = :prodID]; 
                prodObj.product = prd;          
                return prodObj;
            }catch(Exception ex){
                System.debug('Error in class RecipeManagement and getProductDetails method: '+ex.getMessage());
                createErrorLog.insertError('ManufacturingRun',ex.getMessage(),'Error in getProdFromRecp method',null,'',ex.getStackTraceString(),UserInfo.getUserId());
            }
        }
            return null;
        
    }

    @auraEnabled
    Public static boolean chkResourcesAdded(Id mrID){       
        boolean isAdded = false;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Project_Resource__c')
         &&  CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Project_Resource__c',new set<String>{'sigmaerpdev2__Manufacturing_Run__c','id'})
        ){
            List<Project_Resource__c> prObjList = [select id,Manufacturing_Run__c from Project_Resource__c where Manufacturing_Run__c = :mrID];
            if(prObjList.size() > 0){
                isAdded = true;
            }
        }
        return isAdded; 
    }
    
    @AuraEnabled
    public static List<object> fetchJSONHelpMenu()
    {    
        StaticResource sr= [select id, body from StaticResource Where Name = 'JsonManufacturingMM'];
        string allContent = sr.body.toString();
        Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(allContent);
        List<Object> trails = (List<Object>) results.get('Menu');        
        return trails; 
    }  

    //code to be moved back
    @auraEnabled
    Public static boolean checkBarCodeAvailable(String barCodeVal){       
        boolean exists = false;        
        List<Product2> prObjList = [select Product_Bar_Code__c from Product2 where Product_Bar_Code__c = :barCodeVal];
        if(prObjList.size() > 0){
            exists = true;
        }        
        return exists; 
    }
    //ends here
    
}