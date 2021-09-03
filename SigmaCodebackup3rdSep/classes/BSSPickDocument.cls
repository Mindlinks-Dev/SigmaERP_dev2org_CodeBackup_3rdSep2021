public with sharing class BSSPickDocument{
    List<BSSPickDocument.listOfProductsWrapper> container;
    Manufacturing_Run__c headerDetailsList; 
    public BSSPickDocument() {        
        String manfId = ApexPages.currentPage().getParameters().get('manfId');      
        headerDetailsList = [select Manufacturing_Name__c,Run_Date__c,Recipe__r.Name,Required_Quantity__c,Recipe__c from Manufacturing_Run__c where id = :manfId];
        Recipe__c recpObj = [select Quantity__c from Recipe__c where Id = :headerDetailsList.Recipe__c];
        headerDetailsList.Required_Quantity__c = (headerDetailsList.Required_Quantity__c * recpObj.Quantity__c).setScale(2);
        //fetch all the reserved stock to show in pdf
        List<listOfProductsWrapper> wrapProdListOuter = new List<listOfProductsWrapper>();  
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
                   from Manufacturing_Run_Allocation__c where Manufacturing_Run__c = : manfId];      
        for(Manufacturing_Run_Allocation__c mraItr : mraList){
            prodMap.put(mraItr.Product__c, mraItr.Quantity__c);
            manfRunAllocIds.add(mraItr.Id);
        }
        
        List<Manufacturing_Run_Allocation_Line_Items__c> mraLineItemsList = new List<Manufacturing_Run_Allocation_Line_Items__c>();
        mraLineItemsList = [select id,name,Inventory_Location_Product__c,Inventory_Location_Product_Line_Item__c,                                                                                    
                            Inventory_Location_Product_Line_Item__r.Serial_Number_Code__c,                           
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
                        iwrap.lotName = 'NA';
                    else
                        iwrap.lotName = mraliIteration.Inventory_Location_Product_Line_Item__r.Bin__r.Name;                    
                    
                    if(mraliIteration.Inventory_Location_Product_Line_Item__r.Bin__r.Zone__r.Name == null)
                        iwrap.zoneName = 'NA';
                    else
                        iwrap.zoneName = mraliIteration.Inventory_Location_Product_Line_Item__r.Bin__r.Zone__r.Name;                                        
                                       
                    iwrap.ilpAvailQuantity = null;                                         
                    if(mraliIteration.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.name == null)
                        iwrap.ilName = 'NA';
                    else
                        iwrap.ilName = mraliIteration.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.name;                                         
                    
                    if(mraliIteration.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Name == null)
                        iwrap.ilpName = 'NA';
                    else
                        iwrap.ilpName = mraliIteration.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Name;                  
                                        
                    iwrap.ilpliName = mraliIteration.Inventory_Location_Product_Line_Item__r.Name;                    
                    iwrap.ilpId = mraliIteration.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Id; 
                    iwrap.ilpliId = mraliIteration.Inventory_Location_Product_Line_Item__c;                                   
                    iwrap.srNumName = mraliIteration.Inventory_Location_Product_Line_Item__r.Serial_Number_Code__c;                    
                    
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
        container = wrapProdListOuter;                                                      
    }
    
    public List<BSSPickDocument.listOfProductsWrapper> getcontainer(){
        return container;
    }    
    
    public Manufacturing_Run__c getheaderDetailsList(){
        return headerDetailsList;
    }
    
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
        public ProductWrapper(Id ProdId, String ProdName, Decimal requiredQnt,String prodAttributeType,String pBom,List<innerWrapper> wrapProdList,String prodUOM,Id manufRunId,Boolean allocatedViaAutopickOrManual, Decimal totalAvailQty, Decimal avgUnitPrice) {                           
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
        public String ilName {get;set;}
        @AuraEnabled        
        public Decimal unitPrice {get;set;}
        
        @AuraEnabled        
        public String zoneName {get;set;}
                
        public innerWrapper(Decimal selQn,Id srNumId, String ltName, Date ltExpiryDate, String ilpName, Decimal avlQn, Id lotId, Id ilpId, Id ilpliId, Id locationId, String srNumName, Id ppId, Id ppliId, String prodUOM,Date prodExpDate,ID recID,String ilpliName, String ilName, Decimal unitPrice, String zoneName) {
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
            this.ilName = ilName;
            this.unitPrice = unitPrice;
            this.zoneName = zoneName;
        }
    }   
    
}