public with sharing class RecipeManagement
{
    @auraEnabled
    Public static recipeWrap fetchRecipes(Integer limits , Integer offsets)
    {
         if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Recipe__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Recipe__c',new set<String>{'Id',' Name','sigmaerpdev2__Quantity__c','sigmaerpdev2__Recipe_Type__c','sigmaerpdev2__Unit_of_Measure__c', 'sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.Name','createddate'}))
        {
                
        try{
            Integer intlimits = integer.valueof(limits);
            Integer intoffsets = integer.valueof(offsets);
            List<Recipe__c> recipeList = [SELECT Id, Name,Quantity__c,Recipe_Type__c,Unit_of_Measure__c, Product__c,Product__r.Name FROM Recipe__c order by createddate desc Limit :intlimits Offset :intoffsets];
            List<AggregateResult> result = [SELECT COUNT(Id) total FROM Recipe__c];
            integer rowscount = (Integer)result[0].get('total');
            return new recipeWrap(recipeList,rowscount);
        }
        catch(Exception ex)
        {            
            createErrorLog.insertError('ManufacturingRun',ex.getMessage(),'Error in class RecipeManagement and fetchRecipes method',null,'',ex.getStackTraceString(),UserInfo.getUserId());
           
        } 
            }
             return null;
    }    
    
    public class recipeWrap
    {
         
        @auraenabled
        public List<Recipe__c> recipeList{get;set;}
        @auraenabled
        public integer totalRows{get;set;}
        
        public recipeWrap(List<Recipe__c> recipeList,integer totalRows)
        {
            this.recipeList = recipeList;
            this.totalRows = totalRows;
        }
       
    }
    
    public class productWrapper
    {
        @auraenabled
        public product2 product;
        @auraenabled
        public decimal NonStockPrice;
        @auraenabled
        public Boolean isStockAvailable;
    }
    
    @auraEnabled
    Public static productWrapper getProductDetails(String prodID,String recipID)
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
         && CRUD_FLS_CheckUtility.checkObjCRUD('PricebookEntry')
         && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')

         && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'Id','Name','sigmaerpdev2__Stock_Item__c','sigmaerpdev2__Product_UOM__c'})
         && CRUD_FLS_CheckUtility.checkReadPermission('PricebookEntry',new set<String>{'UnitPrice','PriceBook2.Name','Product2.Id'})
         && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new set<String>{'id','sigmaerpdev2__ProductCode__c','sigmaerpdev2__Total_Available_Qty__c'}))
             {
            
        try{
            Product2 prd = [SELECT Id, Name,Stock_Item__c,Product_UOM__c  FROM Product2 where Id=:prodID];                    
            productWrapper pw=new productWrapper();
            if(prd.Stock_Item__c==false){        
                pw.NonStockPrice=0;
                List<PricebookEntry> pbe =[Select UnitPrice From PricebookEntry WHERE PriceBook2.Name = 'Standard Price Book' and Product2.Id = :prodID limit 1];                
                if(pbe.size() > 0){                    
                    if(pbe[0].UnitPrice!=null)
                      pw.NonStockPrice=pbe[0].UnitPrice;              
                }
            }  
            
            pw.isStockAvailable=true;
            List<Inventory__c> inventory=[select id,ProductCode__c,Total_Available_Qty__c from Inventory__c where ProductCode__c=: prodID];
            if(inventory.size()>0)
            {                
                if(prd.Stock_Item__c==true && (inventory[0].Total_Available_Qty__c==0 || inventory[0].Total_Available_Qty__c==NULL))
                pw.isStockAvailable=false;
            }
            
            pw.product=prd;
            
            return pw;
        }
        catch(Exception ex)
        {          
            createErrorLog.insertError('ManufacturingRun',ex.getMessage(),'Error in class RecipeManagement and getProductDetails method',null,'',ex.getStackTraceString(),UserInfo.getUserId());
            
        }
        
    }
    return null;
    }
    

    
    @auraEnabled
    Public static recipeWrap cloneRecipe(String recipID,Integer limits , Integer offsets)
    {
         if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Recipe__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Recipe_Details__c')

           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Recipe__c',new set<String>{'Id',' Name','sigmaerpdev2__Quantity__c','sigmaerpdev2__Recipe_Type__c','sigmaerpdev2__Unit_of_Measure__c', 'sigmaerpdev2__Product__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Recipe_Details__c',new set<String>{'Id','sigmaerpdev2__Cost__c','sigmaerpdev2__Average_Buying_Price__c','sigmaerpdev2__Dependent_Recipe__r.Name','sigmaerpdev2__Dependent_Recipe__c','sigmaerpdev2__Description__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Quantity__c','sigmaerpdev2__Unit_of_Measure__c','RecordType.Name','sigmaerpdev2__Recipe__c'})
           && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Recipe_Details__c',new set<String>{'sigmaerpdev2__Recipe__c'})
           
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Recipe__c',new set<String>{'Name'}))
           //&& CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Recipe_Details__c',new set<String>{'sigmaerpdev2__Recipe__c'}))
           {
        
        try{
            Recipe__c recp = [SELECT Id, Name,Quantity__c,Recipe_Type__c,Unit_of_Measure__c, Product__c FROM Recipe__c where Id=:recipID];
            Recipe__c recipClone = recp.clone(false, false, false, false);
            recipClone.Name = recp.Name +' Cloned';
            insert recipClone;
            
            List<Recipe_Details__c> rpList = new List<Recipe_Details__c>();
            for(Recipe_Details__c recProd :[select Id,Cost__c,Average_Buying_Price__c,Dependent_Recipe__r.Name,Dependent_Recipe__c,Description__c,Product__c,Product__r.Name,Quantity__c,Unit_of_Measure__c,RecordType.Name from Recipe_Details__c where Recipe__c = : recipID])
            {               
                Recipe_Details__c rp = recProd.clone(false, false, false, false);
                rp.Recipe__c = recipClone.Id;
                rpList.add(rp);
            }
            insert rpList;
            return fetchRecipes(limits,offsets);
        }
        catch(Exception ex)
        {           
            createErrorLog.insertError('ManufacturingRun',ex.getMessage(),'Error in class RecipeManagement and cloneRecipe method',null,'',ex.getStackTraceString(),UserInfo.getUserId());
            
        } 
                  }
                  return null;
    }
    
    @auraEnabled
    Public static recipeChildWrap fetchRecipeChildData(String RecipeId)
    {    
    if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Recipe_Details__c')
     && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Recipe_Details__c',new set<String>{'Id','sigmaerpdev2__Cost__c','sigmaerpdev2__Dependent_Recipe__r.Name','sigmaerpdev2__Dependent_Recipe__c','sigmaerpdev2__Description__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Quantity__c','sigmaerpdev2__Unit_of_Measure__c','RecordType.Name','sigmaerpdev2__Product__r.sigmaerpdev2__Stock_Item__c'})
         ){
    
        try{
            recipeChildWrap rcw = new recipeChildWrap();
            rcw.recipeProdList = new List<Recipe_Details__c>();
            rcw.recipeStagesList = new List<Recipe_Details__c>();
            rcw.recipeAddProdList = new List<Recipe_Details__c>();
            rcw.recipePackagingMatList = new List<Recipe_Details__c>();
            rcw.rtWrap = new recordtypeWrap();
            
            for(Recipe_Details__c rp:[select Id,Cost__c,Dependent_Recipe__r.Name,Dependent_Recipe__c,Description__c,Product__c,Product__r.Name,Quantity__c,Unit_of_Measure__c,RecordType.Name,Product__r.Stock_Item__c from Recipe_Details__c where Recipe__c =:RecipeId])
            {   
                if(rp.recordType.Name=='Product Components')
                {
                    if(rp.Cost__c != null){                        
                        rp.Cost__c = (rp.Cost__c).setScale(2);
                    }                   
                    rcw.recipeProdList.add(rp);
                }
                else if(rp.recordType.Name=='Package Materials')
                {
                    if(rp.Cost__c != null){                        
                        rp.Cost__c = (rp.Cost__c).setScale(2);
                    }
                    rcw.recipePackagingMatList.add(rp);
                }
                else if(rp.recordType.Name=='Stages')
                {
                    if(rp.Cost__c != null){                        
                        rp.Cost__c = (rp.Cost__c).setScale(2);
                    }
                    rcw.recipeStagesList.add(rp);
                }
                else if(rp.recordType.Name=='Additional Products')
                {
                    if(rp.Cost__c != null){                        
                        rp.Cost__c = (rp.Cost__c).setScale(2); 
                    }
                    rcw.recipeAddProdList.add(rp);
                }
            }
            
            recordtypeWrap rtw = new recordtypeWrap();
            rtw.productComponentID = Schema.SObjectType.Recipe_Details__c.getRecordTypeInfosByName().get('Product Components').getRecordTypeId();
            rtw.stagesID = Schema.SObjectType.Recipe_Details__c.getRecordTypeInfosByName().get('Stages').getRecordTypeId();
            rtw.additionalProdID = Schema.SObjectType.Recipe_Details__c.getRecordTypeInfosByName().get('Additional Products').getRecordTypeId();
            rtw.packagingMaterialID = Schema.SObjectType.Recipe_Details__c.getRecordTypeInfosByName().get('Package Materials').getRecordTypeId();
            rcw.rtWrap = rtw;
            
            return rcw;
        }
        catch(Exception ex)
        {           
            createErrorLog.insertError('ManufacturingRun',ex.getMessage(),'Error in class RecipeManagement and fetchRecipeChildData method',null,'',ex.getStackTraceString(),UserInfo.getUserId());
            return null;
        } 
     }
     return null;
    }
    
    public SObject getNewSobject(String t) {
        
        try{  
            /* Call global describe to get the map of string to token. */
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
            
            /* Get the token for the sobject based on the type. */
            Schema.SObjectType st = gd.get(t);
            
            /* Instantiate the sobject from the token. */
            Sobject s = st.newSobject();
            
            return s;
        }
        catch(Exception ex)
        {           
            createErrorLog.insertError('ManufacturingRun',ex.getMessage(),'Error in class RecipeManagement and getNewSobject method',null,'',ex.getStackTraceString(),UserInfo.getUserId());
            return null;
        } 
    }
    
    @auraEnabled
    public static string deleteRecord(String recID)
    {
        
        
        try{
            ID recordID = Id.valueOf(recID);
            String sObjName = recordID.getSObjectType().getDescribe().getName();
            RecipeManagement rm = new RecipeManagement();
            Sobject s = rm.getNewSObject(sObjName);
            s.Id = recordID;
            delete s;
            return 'success';
        }
        catch(Exception ex)
        {           
            createErrorLog.insertError('ManufacturingRun',ex.getMessage(),'Error in class RecipeManagement and deleteRecord method',null,'',ex.getStackTraceString(),UserInfo.getUserId());
            return null;
        } 
    }
    
    //delete recipe and its associated items
    @auraEnabled 
    public static String deleteRecipe(Id recipeID){
        String str = 'success'; 
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Recipe_Details__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Recipe__c')
          && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Recipe_Details__c',new set<String>{'id','Recipe__c'})  
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Recipe__c',new set<String>{'id'}))
                {
           
        try{            
            List<Recipe_Details__c> recipeProdsList = [select id from Recipe_Details__c where Recipe__c = :recipeID];
            delete recipeProdsList;
            
            List<Recipe__c> recipeList = [select id from Recipe__c where id = :recipeID];
            delete recipeList;
        }
        catch(Exception ex)
        {            
            createErrorLog.insertError('ManufacturingRun',ex.getMessage(),'Error in class RecipeManagement and deleteRecipe method',null,'',ex.getStackTraceString(),UserInfo.getUserId());
        } 
    }
        return str;
    }   
        
    public class recipeChildWrap
    {
        @auraEnabled
        public recordtypeWrap rtWrap{get;set;}
        @auraEnabled
        public List<Recipe_Details__c> recipeProdList{get;set;}
        @auraEnabled
        public List<Recipe_Details__c> recipeStagesList{get;set;}
        @auraEnabled
        public List<Recipe_Details__c> recipeAddProdList{get;set;}
        @auraEnabled
        public List<Recipe_Details__c> recipePackagingMatList{get;set;}
    }
    
    public class recordtypeWrap
    {
        @auraEnabled
        public string productComponentID{get;set;}
        @auraEnabled
        public string packagingMaterialID{get;set;}
        @auraEnabled
        public string additionalProdID{get;set;}
        @auraEnabled
        public string stagesID{get;set;}
    }
    
}