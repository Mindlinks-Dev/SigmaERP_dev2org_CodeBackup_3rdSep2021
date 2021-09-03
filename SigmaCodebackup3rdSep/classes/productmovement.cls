public class productmovement {    
 
    public class WrapList {
        @AuraEnabled 
       public String ProName{get; set;}
        @AuraEnabled 
       public String IlpId{get; set;}
        @AuraEnabled 
        public Decimal ProQty{get; set;}
        @AuraEnabled
        public List<Inventory_Location_Product_Line_Item__c> IlpliList{get; set;}
        
        public WrapList(String ProName1, String IlpId1, Decimal ProQty1, List<Inventory_Location_Product_Line_Item__c> IlpliList1){
            this.ProName = ProName1;
            this.IlpId = IlpId1;
            this.ProQty = ProQty1;
            this.IlpliList = IlpliList1;
        }
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
        public List<innerWrapper> wrapProdList{get;set;}
        @AuraEnabled            
        public Boolean stkItem {get;set;}
        @AuraEnabled
        public Decimal totalAvailQty{get;set;}
        
        public ProductWrapper(Id ProdId, String ProdName, Decimal requiredQnt, List<innerWrapper> wrapProdList, Boolean stkItem,Decimal totalAvailQty) {                           
            this.prodId = prodId;
            this.ProdName = ProdName;
            this.requiredQnt = requiredQnt;
            this.wrapProdList = wrapProdList;
            this.stkItem = stkItem;
            this.totalAvailQty = totalAvailQty;
        }       
    }
    
    //Wrapper class to store ILPLI Details
    public class innerWrapper { 
        @AuraEnabled
        public Decimal selQuantity{get;set;}   
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
        public Date prodExpDate{get;set;}        
        @AuraEnabled        
        public String ilpliName {get;set;}
        @AuraEnabled        
        public String serNum {get;set;}
        @AuraEnabled        
        public Id serNumid {get;set;}
        @AuraEnabled 
        public String BinName {get;set;}
        @AuraEnabled 
        public Id Binid {get;set;}
      
        
        
        public innerWrapper(Decimal selQn,String ltName, Date ltExpiryDate, String ilpName, Decimal avlQn, Id lotId, Id ilpId, Id ilpliId, Id locationId, Date prodExpDate,String ilpliName, String serNum,id serNumid,String binnam,Id bins) {
            this.selQuantity = selQn;       
            this.lotName = ltName;
            this.lotExpiryDate = ltExpiryDate;
            this.ilpName = ilpName;
            this.ilpAvailQuantity = avlQn;   
            this.lotId = lotId; 
            this.ilpId = ilpId;
            this.ilpliId = ilpliId;         
            this.locationId = locationId;            
            this.prodExpDate = prodExpDate;
            this.ilpliName = ilpliName; 
            this.serNum = serNum;
            this.serNumid=serNumid;
            this.BinName=binnam;
            this.Binid=bins;
        }
    } 
    
    
        
    @AuraEnabled
    public static List<WrapList> fetchILP(String ilId,String BId){
        
        List<WrapList> WrapData = new List<WrapList>();             
        List<Inventory_Location_Product__c> ILPlist = [select id, name from Inventory_Location_Product__c 
        where Inventory_Location__r.Location__c = :ilId limit 1]; 
        for(Inventory_Location_Product__c ilpObj : ILPlist){
            //if(ilpObj.Inventory_Location_Product_Line_Items__r.size() > 0){
                WrapData.add(new WrapList('test1',null,null,null));  
            //}         
        }
        
        return WrapData;        
        
        /*system.debug('BId>>'+BId);
        List<WrapList> WrapData  = new List<WrapList>();
        List<Inventory_Location_Product__c> ILPsList=new List<Inventory_Location_Product__c>();
        List<Inventory_Location_Product__c> ILPlist = [select id, name, Products__c, Products__r.Name, Inventory_Location__c, Received_Quantity__c, 
        (select id, Name,ILid__c,Lot__c, Product__c,Lot__r.Name,Product_Serial_Number__c,Serial_Name__c,Available_Quantity__c, Received_Quantity__c, bucket_field__c,Inventory_Location__c,Expiry_Date__c,Inventory_Location_Product__c,Unit_Price__c,Stock_Type__c from Inventory_Location_Product_Line_Items__r where Available_Quantity__c > 0 AND Product__c!=NULL AND Bin__c=:BId) from Inventory_Location_Product__c where Inventory_Location__c =: ilId AND Products__c!=NULL order by Products__r.Name ];    
      
        
        for(Inventory_Location_Product__c ilp : ILPlist)
        {
            WrapData.add(new WrapList('test1',null,null,null));   
            system.debug('inside....');
            if(ilp.Inventory_Location_Product_Line_Items__r.size() > 0){
                system.debug('inside 1111....');
                //WrapData.add(new WrapList(ilp.Products__r.Name, ilp.Id, ilp.Received_Quantity__c,ilp.Inventory_Location_Product_Line_Items__r));   
                
                //WrapData.add(new WrapList('test1',null,null,null));   
            }
            system.debug('WrapData....'+WrapData);
        }
        //String jsdata = JSON.serialize(WrapData);
        system.debug('outside WrapData....'+WrapData);
        return WrapData;*/
    }
        
    @AuraEnabled
    public static List<listOfProductsWrapper> fetchILP1( Id recId){
        Decimal totalAvailableQty;
        Id ProdId;
        String prodName; 
        String status;
        Decimal requiredQnt;
        String prodAttrType;
        Boolean stkItem;
        
        Map<Id,Decimal> lineItemProdId = new Map<Id,Decimal>();
        
        List<Product_Request__c> prodReqList = [select id,sigmaerpdev2__Status__c,(select id,Product__c,Product__r.Name,Quantity__c from Product_Request_Line_Item__r)
                                                from Product_Request__c where id= :recId];
        
       
        for(Product_Request__c prdMainObj : prodReqList){
            for(Product_Request_Line_Item__c prdLineObj : prdMainObj.Product_Request_Line_Item__r){
                lineItemProdId.put(prdLineObj.Product__c, prdLineObj.Quantity__c);
            }           
        }
        
        
        List<listOfProductsWrapper> wrapProdListOuter = new List<listOfProductsWrapper>();
        List<ProductWrapper> wrapProdListManual = new List<ProductWrapper>();
        
   
       
        
        Map<Id,String> ilpListMap1 = new Map<Id,String>();
        List<Inventory_Location_Product__c> ilpList = [select id,name,sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__r.sigmaerpdev2__Locations_Type__c from Inventory_Location_Product__c where sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__r.sigmaerpdev2__Locations_Type__c='Warehouse' and Products__c in :lineItemProdId.keySet() order by Products__r.Name];
        for (Inventory_Location_Product__c ilpListItems : ilpList){              
            ilpListMap1.put(ilpListItems.Id,ilpListItems.Name);
        }  
        
        System.debug('ilpListMap1==='+ilpListMap1);
        
        //removed the inner query and querying full ilpli list to fix inner query issue returning more than 200 ilpli's for particular product
        Map<Id,List<Inventory_Location_Product_Line_Item__c>> prodILPLIListNewMap = new Map<Id,List<Inventory_Location_Product_Line_Item__c>>();
        
        List<Inventory_Location_Product_Line_Item__c> newIlpliList = [select id, Name,ILid__c,Lot__c, Product__c,Lot__r.Name,Bin__r.Name,Product_Serial_Number__r.Name,Serial_Name__c,Available_Quantity__c,
        Received_Quantity__c, bucket_field__c,Inventory_Location__c,Expiry_Date__c,Product_Expiry_Date__c,Inventory_Location_Product__r.Name,Inventory_Location_Product__r.Id,
        Inventory_Location_Product__c,Unit_Price__c,Stock_Type__c,Inventory_Location_Product__r.Products__c,
        Serial_Number_Code__c   from
        Inventory_Location_Product_Line_Item__c where Available_Quantity__c > 0 AND Product__c !=NULL and 
        sigmaerpdev2__Inventory_Location_Product__c in :ilpListMap1.keySet()];   
    
        System.debug('newIlpliList==='+newIlpliList.size());
        
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
        
        for(Product2 prd :[select id,name,Attribute_Type__c,Product_UOM__c,Stock_Item__c,(select sigmaerpdev2__Quantity__c from sigmaerpdev2__Product_Request_Line_Item__r) from Product2 where id in :lineItemProdId.keySet() order by name ASC]){
            System.debug('line 175');
            List<innerWrapper> innerWrapperList = new List<innerWrapper>(); 
            totalAvailableQty = 0.0;
            ProdId = prd.id;
            prodName = prd.name;
            stkItem = prd.Stock_Item__c;
            
            /*for(sigmaerpdev2__Product_Request_Line_Item__c prlObj : prd.sigmaerpdev2__Product_Request_Line_Item__r){
                requiredQnt =prlObj.sigmaerpdev2__Quantity__c;
            }*/
            
            requiredQnt = lineItemProdId.get(prd.id);
            prodAttrType = prd.Attribute_Type__c;                            
            
            if(prodILPLIListNewMap.containsKey(prd.id)) {
                System.debug('line 183');
                for(Inventory_Location_Product_Line_Item__c ilpli : prodILPLIListNewMap.get(prd.id)){
                    totalAvailableQty = totalAvailableQty + ilpli.Available_Quantity__c;
                    innerWrapper iwrap = new innerWrapper(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);    
                    iwrap.selQuantity = null;                        
                    if(ilpli.Bin__r.Name == null)
                        iwrap.lotName = 'Not Available';  
                    else
                        iwrap.lotName = ilpli.Bin__r.Name;
                    iwrap.lotId=ilpli.Lot__c;                    
                    iwrap.ilpName = ilpli.Inventory_Location_Product__r.Name;                       
                    iwrap.ilpliName = ilpli.name;
                    iwrap.ilpAvailQuantity = ilpli.Available_Quantity__c;                                            
                    iwrap.ilpId = ilpli.Inventory_Location_Product__r.Id; 
                    iwrap.locationId = ilpli.Inventory_Location__c;
                    iwrap.ilpliId = ilpli.Id;                                                                                                                       
                    iwrap.prodExpDate = ilpli.Product_Expiry_Date__c;
                    iwrap.serNumId=ilpli.Product_Serial_Number__r.Id;
                    iwrap.serNum = ilpli.Product_Serial_Number__r.Name;
                    iwrap.BinName=ilpli.Lot__r.Name;
                    iwrap.Binid=ilpli.Lot__c;
                    innerWrapperList.add(iwrap);
                }
                wrapProdListManual.add(new ProductWrapper(ProdId,prodName,requiredQnt,innerWrapperList,stkItem,totalAvailableQty));                              
            }else{
                innerWrapper iwrap = new innerWrapper(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null); 
                innerWrapperList.add(iwrap);
                wrapProdListManual.add(new ProductWrapper(ProdId,prodName,requiredQnt,innerWrapperList,stkItem,totalAvailableQty));                   
            }
        }
        System.debug('wrapProdListManual==='+wrapProdListManual);
        wrapProdListOuter.add(new listOfProductsWrapper(wrapProdListManual));
        System.debug('wrapProdListOuter==='+wrapProdListOuter);
        return wrapProdListOuter;
    }
    

    
    
    /*@AuraEnabled
    public static sigmaerpdev2__Product_Request__c saveproduct(String fromid)
    {   
        sigmaerpdev2__Product_Request__c smdata=new sigmaerpdev2__Product_Request__c();
        {
             smdata=[select id,Name,sigmaerpdev2__Requested_From_Location__c,sigmaerpdev2__From_Bin__c,sigmaerpdev2__Requested_From_Location__r.Name,
             sigmaerpdev2__From_Bin__r.Name,sigmaerpdev2__Request_To_Location__r.Name,sigmaerpdev2__To_Bin__r.Name,
             sigmaerpdev2__Request_To_Location__c,sigmaerpdev2__To_Bin__c,
             (select id,name,sigmaerpdev2__Product__c,sigmaerpdev2__Quantity__c 
             from sigmaerpdev2__Product_Request_Line_Item__r) 
             from sigmaerpdev2__Product_Request__c where id=:fromid];
        }     
        return smdata;      
    }*/
    
    //added newly on 17/7/2020 to get TO Location and Bin from technician
    @AuraEnabled
    public static Service_Resource__c saveproduct(String fromid)
    { 
        Product_Request__c productRequest = [SELECT Id,OwnerId,sigmaerpdev2__Status__c FROM Product_Request__c where Id = :fromid]; 
        Service_Resource__c srObj = [select id,User__c,Service_Location__r.Name,Default_Bin__r.Name from Service_Resource__c where User__c = :productRequest.OwnerId limit 1];
        if(productRequest.sigmaerpdev2__Status__c!='Approved'){
            return null;
        }else{
            return srObj;
        }
        
        
    }
    //ends here
    
    @AuraEnabled
    public static String checkProductReqStatus(Id recordId){
        
        // ProductRequest Fields that will be accessed.
        String [] productRequestFields = new String [] {'sigmaerpdev2__Requested_From_Location__c','sigmaerpdev2__Request_To_Location__c','sigmaerpdev2__Status__c'};
         
        Product_Request__c productRequest;
        
         if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Request__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Request__c',new set<String>{'Id','sigmaerpdev2__Requested_From_Location__c','sigmaerpdev2__Request_To_Location__c','sigmaerpdev2__Status__c'}))
     {
            // Obtaining the field name/token map for the ProductRequest object
            Map<String,Schema.SObjectField> productRequestMap = Schema.SObjectType.Product_Request__c.fields.getMap();
        for (String fieldToCheck : productRequestFields) {
            // Check if the user has create access on the each field
            if (!productRequestMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on ProductRequest Fields');
                return null;
            }
        }
        productRequest = [SELECT Id, sigmaerpdev2__Requested_From_Location__c, sigmaerpdev2__Request_To_Location__c, Status__c FROM Product_Request__c where Id =:recordId limit 1];
     }   
        if(productRequest.Status__c == 'Approved'){
            return 'success';
        }
        else{
            return 'failure';
        }
     
    }
        
    @AuraEnabled
    public static String createProductTrans(Id recordId, String selJsonStr){
        
        List<productmovement.listOfProductsWrapper> container = (List<productmovement.listOfProductsWrapper>)System.JSON.deserialize(selJsonStr,List<productmovement.listOfProductsWrapper>.class);                                                 
        System.debug('container===='+container);
        List<ProductWrapper> AllData = new List<ProductWrapper>();
        
        for(productmovement.listOfProductsWrapper temp : container){
            for(ProductWrapper p1 : temp.mainWrapProdList){
                if(p1.stkItem == true){
                    List<innerWrapper> innerListData = new List<innerWrapper>();                                   
                    for(innerWrapper temp1 : p1.wrapProdList){                  
                        if(temp1.selQuantity != null && temp1.selQuantity != 0){                        
                            innerListData.add(new innerWrapper(temp1.selQuantity,temp1.lotName,null,temp1.ilpName,temp1.ilpAvailQuantity,null,temp1.ilpId,temp1.ilpliId,temp1.locationId,null,null,temp1.serNum,temp1.serNumId,temp1.BinName,temp1.Binid));
                        } 
                    }           
                    AllData.add(new ProductWrapper(p1.prodId,p1.prodName,p1.requiredQnt,innerListData,p1.stkItem,null)); 
                }
            }           
        }   
    
        List<Product_Request_Line_Item__c> listPRLI = new List<Product_Request_Line_Item__c>();
        
     
        /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Request__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Request_Line_Item__c') 
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_transfer__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Request__c',new set<String>{'Id','sigmaerpdev2__Requested_From_Location__c','sigmaerpdev2__Request_To_Location__c','sigmaerpdev2__Status__c','sigmaerpdev2__Product_Transfer__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Request_Line_Item__c',new set<String>{'Id','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product_Request__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_transfer__c',new set<String>{'Id','Name','sigmaerpdev2__From_Location__c','sigmaerpdev2__To_Location__c','sigmaerpdev2__Transfer_Status__c','sigmaerpdev2__Product_Request__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_transfer__c',new set<String>{'sigmaerpdev2__From_Location__c','sigmaerpdev2__To_Location__c','sigmaerpdev2__Product_Request__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Request__c',new set<String>{'sigmaerpdev2__Requested_From_Location__c','sigmaerpdev2__Request_To_Location__c','sigmaerpdev2__Product_Transfer__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Request_Line_Item__c',new set<String>{'sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product_Transfer__c'}))
     {*/
        // ProductRequest Fields that will be accessed.
        String [] productRequestFields = new String [] {'sigmaerpdev2__Requested_From_Location__c','sigmaerpdev2__Request_To_Location__c','sigmaerpdev2__Status__c','sigmaerpdev2__Product_Transfer__c'};
            
            // Obtaining the field name/token map for the ProductRequest object
            Map<String,Schema.SObjectField> productRequestMap = Schema.SObjectType.Product_Request__c.fields.getMap();
        for (String fieldToCheck : productRequestFields) {
            // Check if the user has create access on the each field
            if (!productRequestMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on ProductRequest Fields');
                return null;
            }
        }
        Product_Request__c productRequest = [SELECT Id,sigmaerpdev2__From_Bin__c,sigmaerpdev2__To_Bin__c,sigmaerpdev2__Requested_From_Location__c, sigmaerpdev2__Request_To_Location__c,Product_Transfer__c , Status__c,OwnerId FROM Product_Request__c where Id =:recordId limit 1];
        system.debug('Product Request - '+productRequest);
        
        //added newly on 17/7/2020 to get TO Location and Bin from technician
        Service_Resource__c srObj = [select id,User__c,Service_Location__c,Default_Bin__c from Service_Resource__c where User__c = :productRequest.OwnerId limit 1];    
        //ends here
        
        //Product Transfer must be created only when the ProductRequest's Status is Approved.
        if(productRequest.Status__c != 'Approved'){
            return 'failure';
        }
        
        // RequestLineItems Fields that will be accessed.
        String [] requestlineitemFields = new String [] {'sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product_Request__c'};
            
            // Obtaining the field name/token map for the sigmaerpdev2__Product_Request_Line_Item__c object
            Map<String,Schema.SObjectField> mPRLI = Schema.SObjectType.Product_Request_Line_Item__c.fields.getMap();
        for (String fieldToCheck : requestlineitemFields) {
            // Check if the user has create access on the each field
            if (!mPRLI.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on ProductRequestLineItem Fields');
                return null;
            }
        }
        List<Product_Request_Line_Item__c> productRequestLineItems = [SELECT Id, Product__c,Product_Transfer__c, Product_Request__c, Quantity__c FROM Product_Request_Line_Item__c where Product_Request__c =: recordId];
        system.debug('Product Request Line Items - '+productRequestLineItems);
        
        
        // ProductTransfer Fields that will be accessed.
        String [] productTransferFields = new String [] {'Name','sigmaerpdev2__Request_Location__c','sigmaerpdev2__To_Requested_Location__c','sigmaerpdev2__Transfer_Status__c','sigmaerpdev2__Product_Request__c'};
            
            // Obtaining the field name/token map for the ProductTransfer object
            Map<String,Schema.SObjectField> productTransferMap = Schema.SObjectType.Product_transfer__c.fields.getMap();
        for (String fieldToCheck : productTransferFields) {
            // Check if the user has create access on the each field
            if (!productTransferMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on ProductTransfer Fields');
                return null;
            }
        }
        List<Product_transfer__c> productTransferList = [SELECT Id, Name,sigmaerpdev2__From_Bin__c,sigmaerpdev2__To_Bin__c, sigmaerpdev2__Request_Location__c, sigmaerpdev2__To_Requested_Location__c, Transfer_Status__c, Product_Request__c FROM Product_transfer__c where Product_Request__c =:productRequest.Id];
        
        if(productTransferList!=null && productTransferList.size()!=0){
            system.debug('Product Transfer already created');
            return 'fail';
        }
        
        // ProductTransfer fields taht will be created.
        productTransferFields = new String [] {'sigmaerpdev2__Request_Location__c','sigmaerpdev2__To_Requested_Location__c','sigmaerpdev2__Product_Request__c'};
            // Obtaining the field name/token map for the ProductTransfer object
            productTransferMap = Schema.SObjectType.Product_transfer__c.fields.getMap();
        for (String fieldToCheck : productTransferFields) {
            // Check if the user has create access on the each field
            if (!productTransferMap.get(fieldToCheck).getDescribe().isCreateable()) {
                system.debug('User has no create access on Product Transfer');
                return null;
            }
        }
        //Creating a new ProductTransfer with ProductRequest as its LookUp.
        Product_transfer__c productTransfer = new Product_transfer__c();
        productTransfer.sigmaerpdev2__Request_Location__c = productRequest.sigmaerpdev2__Requested_From_Location__c;        
        productTransfer.Product_Request__c  = productRequest.Id;
        productTransfer.From_Bin__c = productRequest.sigmaerpdev2__From_Bin__c;
        
        /*productTransfer.sigmaerpdev2__To_Requested_Location__c = productRequest.sigmaerpdev2__Request_To_Location__c;
        productTransfer.sigmaerpdev2__To_Bin__c = productRequest.sigmaerpdev2__To_Bin__c;*/
        //now getting TO Location and Bin from Product request owner i.e. Technician
        productTransfer.To_Requested_Location__c = srObj.Service_Location__c;       
        productTransfer.To_Bin__c = srObj.Default_Bin__c;
        
        
        if(productRequestLineItems!=NULL && productRequestLineItems.size()!=0){
            insert productTransfer;
        }
        else{
            return 'No Product Line Items';
        }
        system.debug('ProductTransfer Inserted - '+productTransfer);
        if (Schema.sObjectType.Product_Request__c.fields.Product_Transfer__c.isUpdateable()){ 
            productRequest.Product_Transfer__c = productTransfer.Id;
            update productRequest;
            system.debug('Product Request Field Updated');
        }
        else{
            system.debug('User has no Edit Access on ProductRequest\'s ProductTransfer Field');
        }
        // RequestLineItems Fields that will be accessed.
        requestlineitemFields = new String [] {'sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product_Transfer__c'};
            
            // Obtaining the field name/token map for the sigmaerpdev2__Product_Request_Line_Item__c object
            mPRLI = Schema.SObjectType.Product_Request_Line_Item__c.fields.getMap();
        for (String fieldToCheck : requestlineitemFields) {
            // Check if the user has create access on the each field
            if (!mPRLI.get(fieldToCheck).getDescribe().isCreateable()) {
                system.debug('User has no create Access on ProductRequestLineItem Fields');
                return null;
            }
        }
        //Creating ProductRequestLineItems for ProductTransfer as per ProductRequestLineItems of ProductRequest object.
      /* for(Product_Request_Line_Item__c eachPRLI : productRequestLineItems){
            Product_Request_Line_Item__c tempPRLI = new Product_Request_Line_Item__c();
            tempPRLI.Product__c = eachPRLI.Product__c;
            tempPRLI.Quantity__c = eachPRLI.Quantity__c;
            tempPRLI.Product_Transfer__c = productTransfer.Id;
            listPRLI.add(tempPRLI);
        }
       //}              
        
        
        if(listPRLI!=null && listPRLI.size()!=0){
            insert listPRLI;*/
        
        for(Product_Request_Line_Item__c eachPRLI : productRequestLineItems){
eachPRLI.Product_Transfer__c=productTransfer.id;
 }
        if(productRequestLineItems.size()>0){
            update productRequestLineItems;
            }
        
        
        
        
            system.debug('ProductTransferLineItems Updated');
            
            //store selected ilpli in new prod. transfer inv tracking object.
            List<Product_Transfer_Inventory_Tracking__c> prdTrackList = new List<Product_Transfer_Inventory_Tracking__c>();
            for(ProductWrapper temp : AllData){
                List<innerWrapper> innerData = temp.wrapProdList;                
                for(innerWrapper innerObj :innerData){
                    Product_Transfer_Inventory_Tracking__c tempObj = new Product_Transfer_Inventory_Tracking__c(); 
                    tempObj.Inventory_Location_Product_Line_Item__c = innerObj.ilpliId;
                    tempObj.Product__c = temp.prodId;
                    tempObj.Product_Transfer__c = productTransfer.Id;
                    tempObj.Transferred_Qty__c = innerObj.selQuantity;
                    tempObj.Product_Serial_Number__c=innerObj.serNumId;
                    tempObj.sigmaerpdev2__Lot__c=innerObj.Binid;
                    prdTrackList.add(tempObj);
                }
            }
            if(prdTrackList.size() > 0){
                insert prdTrackList;
            }
            //ends here
            
            
            return 'success';
        /*}
        else{
            return 'fail';
        }*/
        
    }
    
    //get profile name of logged in user - added on 25/7/2020
    @AuraEnabled
    public static String getProfileName(){
        String pName = '';
        User userObj = [select id,Profile.Name from User where id =: userInfo.getUserId()];
        pName = userObj.Profile.Name;
        return pName;
    }
    //ends here
    
}