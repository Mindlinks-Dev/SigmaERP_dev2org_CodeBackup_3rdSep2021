public with sharing class demandplanpdf{
    public List<demandplanpdf.fullWrap> container;
    public String fromdate{get;set;}
    public String toDate  {get;set;}
    public String prodname {get;set;}
    public String status {get;set;}
    public Date fromdate1{get;set;}
    public Integer TotalBackorder{get;set;}
  public Decimal Availqunt{get;set;}
    public demandplanpdf()
    {
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c') 
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'id','name','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Order_Status__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.Name','sigmaerpdev__Sigma_Order__r.sigmaerpdev__AccountId__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__AccountId__r.name','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Customer_Type__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Delivary_Date__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Back_Order__c','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Name','sigmaerpdev__IsInventoryUpdated__c','sigmaerpdev__Product__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'id','name','sigmaerpdev__AccountId__c','sigmaerpdev__AccountId__r.name','sigmaerpdev__Customer_Type__c','sigmaerpdev__Delivary_Date__c','sigmaerpdev__Order_Created_Via__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new set<String>{'id','sigmaerpdev__Available_Qty__c','sigmaerpdev__ProductCode__c'})
        )
        {*/
		try
		{
			
		
            List<fullWrap> wrapProdListOuter = new List<fullWrap>();
            String prodId = ApexPages.currentPage().getParameters().get('productid');
            fromdate = ApexPages.currentPage().getParameters().get('fromdate');
            toDate = ApexPages.currentPage().getParameters().get('toDate');
            status = ApexPages.currentPage().getParameters().get('status');
            Date fromdate1 = date.valueOf(fromdate);
            Date todate1 = date.valueOf(toDate);
            prodname = ApexPages.currentPage().getParameters().get('prodname');
            TotalBackorder=0;
            List<soWrap> soWrapList = new List<soWrap>();
            List<Sigma_Order__c> soList = new List<Sigma_Order__c>();
            List<Product_Order_Price_Book__c> solineitemList = new List<Product_Order_Price_Book__c>();
            Set<Id> soIDSet = new Set<Id>();
            Map<Id,String> orderLinesInvoicedMap = new Map<Id,String>();
            set<Id> Sigmaorder = new set<Id>();
            if(prodId != null && prodId != ''){
			Inventory__c invent = [select id,Available_Qty__c from Inventory__c where ProductCode__c =:prodId];
			Availqunt = invent.Available_Qty__c;
            if(status =='All')
            {
                solineitemList = [select id,name,Net_Quantity__c,Order_Status__c,Sigma_Order__c,Sigma_Order__r.Name,Sigma_Order__r.AccountId__c,Sigma_Order__r.AccountId__r.name,Sigma_Order__r.Customer_Type__c,Sigma_Order__r.Delivary_Date__c,Sigma_Order__r.Order_Created_Via__c,Back_Order__c,Product__c,Product__r.Name from Product_Order_Price_Book__c where Back_Order__c=true and IsInventoryUpdated__c=false and Product__c =:prodId and  Sigma_Order__r.Delivary_Date__c >= :fromDate1 and Sigma_Order__r.Delivary_Date__c <= :toDate1 order by Sigma_Order__r.Delivary_Date__c];
            }                
            else if(status =='Pending')
            {
                solineitemList = [select id,name,Net_Quantity__c,Order_Status__c,Sigma_Order__c,Sigma_Order__r.Name,Sigma_Order__r.AccountId__c,Sigma_Order__r.AccountId__r.name,Sigma_Order__r.Customer_Type__c,Sigma_Order__r.Delivary_Date__c,Sigma_Order__r.Order_Created_Via__c,Back_Order__c,Product__c,Product__r.Name from Product_Order_Price_Book__c where Back_Order__c=true and IsInventoryUpdated__c=false and  Order_Status__c ='Pending' and Product__c =:prodId and  Sigma_Order__r.Delivary_Date__c >= :fromDate1 and Sigma_Order__r.Delivary_Date__c <= :toDate1 order by Sigma_Order__r.Delivary_Date__c];
            }
            else
            {
                solineitemList = [select id,name,Net_Quantity__c,Order_Status__c,Sigma_Order__c,Sigma_Order__r.Name,Sigma_Order__r.AccountId__c,Sigma_Order__r.AccountId__r.name,Sigma_Order__r.Customer_Type__c,Sigma_Order__r.Delivary_Date__c,Sigma_Order__r.Order_Created_Via__c,Back_Order__c,Product__c,Product__r.Name from Product_Order_Price_Book__c where Back_Order__c=true and IsInventoryUpdated__c=false and Order_Status__c ='Order Confirmed' and Product__c =:prodId and  Sigma_Order__r.Delivary_Date__c >= :fromDate1 and Sigma_Order__r.Delivary_Date__c <= :toDate1 order by Sigma_Order__r.Delivary_Date__c];
            }        }
            if(solineitemList.size() > 0){
                for(Product_Order_Price_Book__c soObj : solineitemList){
                Sigmaorder.add(soObj.Sigma_Order__c);
                }
            }
            if(Sigmaorder.size()>0)
            soList = [select id,name,AccountId__c,AccountId__r.name,Customer_Type__c,Delivary_Date__c,Order_Created_Via__c,(select id,name,Order_Status__c, Product__r.Name, Net_Quantity__c,Back_Order__c from Order_Lines__r where Back_Order__c=true and IsInventoryUpdated__c=false and Product__c =:prodId)from Sigma_Order__c where id = :Sigmaorder  order by Delivary_Date__c];
            //Main
            for(Sigma_Order__c soObj : soList)
            {
                soWrap soWrapObj = new soWrap(null, null, null, null, null, null, null,null);
                soWrapObj.soId = soObj.id;
                soWrapObj.soName = soObj.name;
                soWrapObj.createDate = soObj.Delivary_Date__c;
                soWrapObj.custName = soObj.AccountId__r.Name;
                soWrapObj.custType = soObj.Customer_Type__c;
                soWrapObj.orderType = soObj.Order_Created_Via__c;
                //soWrapObj.packageStatus = 'NA';
                List<soliWrap> soliWrapList = new List<soliWrap>();

                for(Product_Order_Price_Book__c soLiObj : soObj.Order_Lines__r)
                {  
                    soliWrap soliWrapObj = new soliWrap(null, null, null, null, null, null, null);
                    soliWrapObj.soliId = soLiObj.Id;
                    soliWrapObj.soliName = soLiObj.name;
                    soliWrapObj.status = soLiObj.Order_Status__c;
                    soliWrapObj.prodName = soLiObj.Product__r.Name;
                    soliWrapObj.ordQuantity = soLiObj.Net_Quantity__c;
                    soliWrapList.add(soliWrapObj);
                    if(soLiObj.Back_Order__c=true)
                    TotalBackorder=TotalBackorder+Integer.valueOf(soLiObj.Net_Quantity__c);
                }
                    soWrapObj.orderLinesList = soliWrapList;
                    soWrapList.add(soWrapObj); 
                    system.debug('soWrapList>>'+soWrapList);
            }
                wrapProdListOuter.add(new fullWrap(soWrapList));
                container = wrapProdListOuter;                                          
                System.debug('container::'+container);
       // }
		}
		catch(Exception ex)
		{
			createErrorLog.insertError('DemandPlanning',ex.getMessage(),'Method -demandplanpdf ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
		} 
	}  

    public List<demandplanpdf.fullWrap> getcontainer(){
    return container;
    }

    public class fullWrap
    {
        @auraenabled
        public List<soWrap> sigmaOrderList{get;set;}
        public fullWrap(List<soWrap> sigmaOrderList){
        this.sigmaOrderList = sigmaOrderList;
        }
    }

    public class soWrap
    {     
        @auraenabled
        public Id soId{get;set;}
        @auraenabled
        public String soName{get;set;}
        @AuraEnabled
        public String custName{get;set;}
        @AuraEnabled
        public String custType{get;set;}        
        @AuraEnabled
        public String packageStatus{get;set;}
        @auraenabled
        public List<soliWrap> orderLinesList{get;set;} 
        @auraenabled
        public Date createDate{get;set;}
        @AuraEnabled
        public String orderType{get;set;}

        public soWrap(Id soId, String soName, String custName, String custType, String packageStatus, List<soliWrap> orderLinesList,Date createDate,String orderType){            
        this.soId = soId;
        this.soName = soName; 
        this.custName = custName;
        this.custType = custType;
        this.packageStatus = packageStatus;
        this.orderLinesList = orderLinesList;
        this.createDate = createDate;
        this.orderType=orderType;
        }
    }

    public class soliWrap
    {  
        @auraenabled
        public Id soliId{get;set;}      
        @auraenabled
        public String soliName{get;set;} 
        @AuraEnabled
        public String status{get;set;}  
        @AuraEnabled
        public String prodName{get;set;}            
        @AuraEnabled
        public Decimal ordQuantity{get;set;}    
        @AuraEnabled
        public Decimal delvQuantity{get;set;}           
        @AuraEnabled
        public Date dueDate{get;set;}   
        //added to hold total backorder qty
        public soliWrap(Id soliId, String soliName, String status, String prodName, Decimal ordQuantity, Decimal delvQuantity, Date dueDate){            
        this.soliId = soliId;   
        this.soliName = soliName;
        this.status = status;           
        this.prodName = prodName;           
        this.ordQuantity = ordQuantity;         
        this.delvQuantity = delvQuantity;           
        this.dueDate = dueDate; 
        }
    }
}