public with sharing class AddRecipeComponentsController {
    @auraEnabled
    public static Recipe__c saveRecipeObject(string recipe)
    {
                Recipe__c recipeRecord = (Recipe__c)JSON.deserialize(recipe,Recipe__c.class);

                if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Recipe__c')
                && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Recipe__c',new Set<String>{'sigmaerpdev2__Product__c'})
            ){
                
        recipeRecord.Product__r=null;        
        upsert recipeRecord;
        }
      return recipeRecord;
    }
    
    @auraEnabled
    public static Recipe_Details__c saveRecipeProduct(string recipeproduct,String recordType)
    {   
           Recipe_Details__c recipeProd = (Recipe_Details__c)JSON.deserialize(recipeproduct,Recipe_Details__c.class);   
                if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Recipe_Details__c')
                    && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Recipe_Details__c',new Set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Dependent_Recipe__c','recordTypeID'})
                    ){
    
                
        Id RecordTypeId;
        if(recordType=='productcomponent')
        {
            RecordTypeId = Schema.SObjectType.Recipe_Details__c.getRecordTypeInfosByName().get('Product Components').getRecordTypeId();
        }
        else if(recordType=='packagingMaterial')
        {
            RecordTypeId = Schema.SObjectType.Recipe_Details__c.getRecordTypeInfosByName().get('Package Materials').getRecordTypeId();
        }
        else if(recordType=='additionalproduct')
        {
            RecordTypeId = Schema.SObjectType.Recipe_Details__c.getRecordTypeInfosByName().get('Additional Products').getRecordTypeId();
        }
        else if(recordType=='addrecipes')
        {
            RecordTypeId = Schema.SObjectType.Recipe_Details__c.getRecordTypeInfosByName().get('Stages').getRecordTypeId();
        }        
        recipeProd.recordTypeID=RecordTypeId;
        recipeProd.Product__r=null;
        recipeProd.Dependent_Recipe__r=null;
        upsert recipeProd;   
                    }       
        return recipeProd;
    }
    
    public class productWrapper
    {
        @auraEnabled
        public product2 product;
        @auraEnabled
        public Boolean isStockAvailable;
        @auraEnabled
        public Decimal ProductPrice;
    }
        
    @auraEnabled
    Public static productWrapper getProductDetails(String prodID,Boolean decider)
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
           && CRUD_FLS_CheckUtility.checkObjCRUD('PricebookEntry')
           && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'Id','Name','sigmaerpdev2__Stock_Item__c','sigmaerpdev2__Product_UOM__c','sigmaerpdev2__Average_Buying_Price__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('PricebookEntry',new Set<String>{'UnitPrice','PriceBook2.Name','Product2.Id'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'id','sigmaerpdev2__ProductCode__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Avg_Buying_Price__c'})
           ){
            
        try{            
            List<Inventory__c> inventory = new List<Inventory__c>();
            Product2 prd = [SELECT Id, Name, Stock_Item__c,Product_UOM__c,Average_Buying_Price__c FROM Product2 where Id=:prodID];                    
            productWrapper pw = new productWrapper();
            pw.ProductPrice = 0;
            if(prd.Stock_Item__c == false){
                List<PricebookEntry> pbe = [Select UnitPrice From PricebookEntry WHERE PriceBook2.Name = 'Standard Price Book' and Product2.Id = :prodID limit 1];                
                if(pbe.size()>0){                    
                    if(pbe[0].UnitPrice != null)
                        pw.ProductPrice = pbe[0].UnitPrice;            
                }                
            }  
            
            pw.isStockAvailable = true;
            if(decider == false)
            {
                inventory = [select id,ProductCode__c,Available_Qty__c,Avg_Buying_Price__c from Inventory__c where ProductCode__c=: prodID];            
            }
            else if(decider == true)
            {
              inventory=[select id,ProductCode__c,Available_Qty__c,Avg_Buying_Price__c from Inventory__c where ProductCode__c=: prodID];  
            }
            
            if(inventory.size()>0)
            {                
                if(prd.Stock_Item__c==true && (inventory[0].Available_Qty__c == 0 || inventory[0].Available_Qty__c == NULL))
                    pw.isStockAvailable = false;                
                
                //commented below line on 10/4/2020 - changed to getting Avg. buying price from product2 instead of PI object
                /*if(prd.Stock_Item__c == true && inventory[0].Avg_Buying_Price__c != null)
                    pw.ProductPrice = inventory[0].Avg_Buying_Price__c;*/
                //ends here
                //newly added code in place of above commented code.
                if(prd.Stock_Item__c == true && prd.Average_Buying_Price__c != null)
                    pw.ProductPrice = prd.Average_Buying_Price__c; 
            }        
            
            pw.product = prd;
                    
            return pw;
            
        }
        catch(Exception ex)
        {            
            createErrorLog.insertError('ManufacturingRun',ex.getMessage(),'Error in AddRecipeComponentsController - getProductDetails',null,'',ex.getStackTraceString(),UserInfo.getUserId());
        
        }
        
        }
            return null;
 
    }    
        
    @auraEnabled
    Public static Recipe_Details__c getRecordInfo(String recID)
    {
        List<Recipe_Details__c> dataList=new List<Recipe_Details__c>();
         if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Recipe_Details__c')
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Recipe_Details__c',new Set<String>{'id','sigmaerpdev2__Cost__c','sigmaerpdev2__Dependent_Recipe__c','sigmaerpdev2__Dependent_Recipe__r.Name','sigmaerpdev2__Description__c','Product__c','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Quantity__c','Recipe__c','sigmaerpdev2__Unit_of_Measure__c','sigmaerpdev2__Average_Buying_Price__c'})
        ){
        
        dataList=[select id,Cost__c,Dependent_Recipe__c,Dependent_Recipe__r.Name,Description__c,Product__c,Product__r.Name,Quantity__c,Recipe__c,Unit_of_Measure__c,Average_Buying_Price__c from Recipe_Details__c where Id=:recID];        
        }
       return dataList[0];
    }
    
    @auraEnabled
    Public static Recipe__c getRecipeRecord(String recID)
    {
                List<Recipe__c> dataList=new List<Recipe__c>();        
         if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Recipe__c')
             && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Recipe__c',new Set<String>{'Id','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Quantity__c','Name','sigmaerpdev2__Recipe_Type__c','sigmaerpdev2__Unit_of_Measure__c'})
             ){

        dataList=[select id,Product__c,Product__r.Name,Quantity__c,Name,Recipe_Type__c,Unit_of_Measure__c from Recipe__c where Id=:recID];   
             }      
        return dataList[0];
    } 
    
    @auraEnabled
    public static Manufacturing_Products__c saveMRProduct(String MRprod,String recType)
    {  
     Manufacturing_Products__c manfProd = (Manufacturing_Products__c)JSON.deserialize(MRprod, Manufacturing_Products__c.class);  
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Manufacturing_Products__c')
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Manufacturing_Products__c',new Set<String>{'RecordTypeId','sigmaerpdev2__Product__c'})
        ){
             
        Id RecordTypeId;
        if(recType=='MRadditionalproduct')
        {
            RecordTypeId = Schema.SObjectType.Manufacturing_Products__c.getRecordTypeInfosByName().get('Additional Products').getRecordTypeId();
        }
        else if(recType=='MRpackagingMaterial')
        {
            RecordTypeId = Schema.SObjectType.Manufacturing_Products__c.getRecordTypeInfosByName().get('Packaging Materials').getRecordTypeId();
        }
        manfProd.recordTypeID=RecordTypeId;
        manfProd.Product__r=null;
        upsert manfProd;   
        }       
        return manfProd;
    }

    
    //check if product is added in product comp or packaging materials and trying to add same in recipe in edit flow
    //added on 17/3/2020
    @auraEnabled 
    public static Boolean checkProdAddedEditFlow(Id recipeId, Id selProdId){
        Boolean flag = false;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Recipe_Details__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Recipe_Details__c',new Set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Recipe__c','RecordType.Name'})
    ){
        List<Recipe_Details__c> recpdetList = [select Product__c,RecordType.Name from Recipe_Details__c 
                    where Recipe__c = :recipeId and RecordType.name != 'Additional Products'];      
        for(Recipe_Details__c recpObj : recpdetList){           
            if(recpObj.Product__c == selProdId){
                flag = true;
                break;
            }
        }
    }
        return flag;
    }
    //ends here
    
}