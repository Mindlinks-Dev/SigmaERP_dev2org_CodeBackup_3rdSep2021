public without sharing class ProductReqCntrl {
  @AuraEnabled
    public static EditDataWrapper getInitValues(){
        EditDataWrapper editData;
        List<String> pkLstVal = new List<String>();
        /*Schema.DescribeFieldResult field = Product_Request__c.Status__c.getDescribe();
        for(Schema.PicklistEntry f : field.getPicklistValues()){
          pkLstVal.add(f.getLabel());
		}*/
        
        pkLstVal.add('Draft');
        pkLstVal.add('Submitted');    
		
        editData = new EditDataWrapper(pkLstVal,null,null);         
        return editData;
    }
    
    @AuraEnabled
    public static String savePRDetails(String reqData){
        String msg = 'success';
        try{
          EditDataWrapper manuFacWrap = (EditDataWrapper)JSON.deserialize(reqData, EditDataWrapper.class); 
            Product_Request__c prObj = new Product_Request__c();
            prObj.sigmaerpdev2__Need_by_Date__c = manuFacWrap.prObject.sigmaerpdev2__Need_by_Date__c;
            prObj.sigmaerpdev2__Status__c = manuFacWrap.prObject.sigmaerpdev2__Status__c;
            insert prObj;
            List<Product_Request_Line_Item__c> prliList = new List<Product_Request_Line_Item__c>();
            for(wrapperData prliObject : manuFacWrap.ListOfProdReqLIs){
				Product_Request_Line_Item__c priObj = new Product_Request_Line_Item__c();
                priObj.Product__c = prliObject.prodID;                
                priObj.Quantity__c = prliObject.reqQty;
                priObj.Product_Request__c = prObj.Id;
                prliList.add(priObj);
            }
			if(prliList.size() > 0){
				insert prliList;   
			}       
            return msg;
        }catch(Exception e){
            msg = e.getMessage() +' '+e.getLinenumber();
            return msg;
        }
    }
	
	
	@AuraEnabled
    public static String updatePRDetails(String reqData, String recID){
        String msg = 'success';
        try{
			EditDataWrapper manuFacWrap = (EditDataWrapper)JSON.deserialize(reqData, EditDataWrapper.class); 
		  
            Product_Request__c prObj = new Product_Request__c();
			prObj = [select Id,Need_by_Date__c,Status__c from Product_Request__c where Id = :recID];			
            prObj.Need_by_Date__c = manuFacWrap.prObject.Need_by_Date__c;
            prObj.Status__c = manuFacWrap.prObject.Status__c;
            update prObj;
			
            List<Product_Request_Line_Item__c> prliList = new List<Product_Request_Line_Item__c>();
			List<Product_Request_Line_Item__c> newPriList = new List<Product_Request_Line_Item__c>();
			prliList = [select ID from Product_Request_Line_Item__c where Product_Request__c = :recID];
			delete prliList;
			
            for(wrapperData prliObject : manuFacWrap.ListOfProdReqLIs){
				Product_Request_Line_Item__c priObj = new Product_Request_Line_Item__c();
                priObj.Product__c = prliObject.prodID;                
                priObj.Quantity__c = prliObject.reqQty;
                priObj.Product_Request__c = prObj.Id;
                newPriList.add(priObj);
            }
			if(newPriList.size() > 0){
				insert newPriList;    
			}                   
            return msg;
        }catch(Exception e){
            msg = e.getMessage() +' '+e.getLinenumber();
            return msg;
        }
    }
	
	@AuraEnabled
    public static String deletePR(String recID){
		String msg = 'success';
		try{
			List<Product_Request_Line_Item__c> prliList = new List<Product_Request_Line_Item__c>();
			prliList = [select ID from Product_Request_Line_Item__c where Product_Request__c = :recID];
			delete prliList;			
			
			Product_Request__c prObj = new Product_Request__c();
			prObj = [select Id from Product_Request__c where Id = :recID];	
            delete prObj;
			return msg;            
		}catch(Exception e){
			msg = e.getMessage() +' '+e.getLinenumber();
            return msg;
		}
	}    
    
    @auraenabled
    public static prMainWrap listPRDetails(Integer limits, Integer offsets)
    {
        List<Product_Request__c> prList;
        integer rowscount;
        try{
            Integer intlimits = integer.valueof(limits);
            Integer intoffsets = integer.valueof(offsets);
            prList = [select Id,Name,Need_by_Date__c,Status__c,CreatedBy.Name from Product_Request__c order by createddate desc Limit :intlimits Offset :intoffsets];
            List<AggregateResult> result = [SELECT COUNT(Id) total FROM Product_Request__c];
            rowscount = (Integer)result[0].get('total');
			
			String pName = '';
			User userObj = [select id,Profile.Name from User where id =: userInfo.getUserId()];
			pName = userObj.Profile.Name;
			
            return new prMainWrap(prList,rowscount,pName);
        }catch(Exception ex){           
            //createErrorLog.insertError('ManufacturingRun',ex.getMessage(),'Method - fetchManufacturingRun',null,'',ex.getStackTraceString(),UserInfo.getUserId());
            return null;
        } 
    }
	
	@auraenabled
    public static EditDataWrapper editValues(String recId){
		EditDataWrapper editData;
        List<String> pkLstVal = new List<String>();
        /*Schema.DescribeFieldResult field = Product_Request__c.Status__c.getDescribe();
        for(Schema.PicklistEntry f : field.getPicklistValues()){
          pkLstVal.add(f.getLabel());
		}*/
		
        pkLstVal.add('Draft');
        pkLstVal.add('Submitted');        
        
		Product_Request__c prObj = new Product_Request__c();
		prObj = [select Id,Need_by_Date__c,Status__c from Product_Request__c where id = :recId];
		
		List<Product_Request_Line_Item__c> prliList = new List<Product_Request_Line_Item__c>();
		List<wrapperData> prliListWrapObj = new List<wrapperData>();
		prliList = [select Product__c,Quantity__c,Product__r.Name from Product_Request_Line_Item__c where Product_Request__c = :recId];
		for(Product_Request_Line_Item__c prliObj : prliList){
			wrapperData wrapObj = new wrapperData(null,null,null);
			wrapObj.prodID = prliObj.Product__c;
			wrapObj.reqQty = prliObj.Quantity__c;
			wrapObj.prodName = prliObj.Product__r.Name;
			prliListWrapObj.add(wrapObj);
		}
		editData = new EditDataWrapper(pkLstVal,prliListWrapObj,prObj);         
        return editData;
		
	}
    
    
    public class EditDataWrapper{
        @auraEnabled
        public List<String> pickVals;
        @auraEnabled
        public List<wrapperData> ListOfProdReqLIs;
        @auraEnabled
        public Product_Request__c prObject;
		
        
        public EditDataWrapper(List<String> pV, List<wrapperData> d, Product_Request__c ob){
            pickVals = new List<String>();             
            ListOfProdReqLIs = new List<wrapperData>();
            pickVals = pV;
            ListOfProdReqLIs = d;
            prObject = ob;
        }
    }
    
   public class wrapperData{
        @auraEnabled
        public ID prodID;
        @auraEnabled
        public Decimal reqQty = 0;
		@auraEnabled
        public String prodName;
                
        public wrapperData(ID prodID,Decimal qty,String prodName){
            prodID = prodID;
            reqQty = qty;
			prodName = prodName;
        }
    }
    
    public class prMainWrap
    {
        @auraenabled
        public List<Product_Request__c> prList{get;set;}
        @auraenabled
        public integer totalRows{get;set;}
		@auraEnabled
        public String profileName;
        
        public prMainWrap(List<Product_Request__c> prList, integer totalRows, String profileName)        
        {
            this.prList = prList;
            this.totalRows = totalRows;			
			this.profileName = profileName;
        }
    }
}