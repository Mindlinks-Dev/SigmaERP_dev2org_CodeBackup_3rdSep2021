public with sharing class demandplanning{
    public class fullWrap
    {
        @auraenabled
        public List<soWrap> stappOrderList{get;set;}
        @auraenabled
        public Integer totalRows{get;set;}
        @AuraEnabled
        public Integer pageSize {get;set;}
        @AuraEnabled
        public Integer pageNumber {get;set;}
        @AuraEnabled
        public Integer totalRecords {get;set;}
        @AuraEnabled
        public Integer recordStart {get;set;}
        @AuraEnabled
        public Integer recordEnd {get;set;}
        @AuraEnabled
        public Decimal totalqty{get;set;}
        @AuraEnabled
        public Decimal availqunt{get;set;}

        public fullWrap(List<soWrap> stappOrderList, Integer totalRows, Integer pageSize, Integer pageNumber, Integer totalRecords, Integer recordStart, Integer recordEnd,Decimal totalqty,Decimal availqunt){
        this.stappOrderList = stappOrderList;
        this.totalRows = totalRows;
        this.pageSize = pageSize;
        this.pageNumber = pageNumber;
        this.totalRecords = totalRecords;
        this.recordStart = recordStart;
        this.recordEnd = recordEnd;
        this.totalqty = totalqty;
        this.availqunt = availqunt;
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
        public String orderType{get;set;}
        @AuraEnabled
        public String packageStatus{get;set;}
        @auraenabled
        public List<soliWrap> orderLinesList{get;set;} 
        @auraenabled
        public String salesInvGen{get;set;}
        @auraenabled
        public DateTime createDate{get;set;}
		

        public soWrap(Id soId, String soName, String custName, String custType, String orderType, String packageStatus, List<soliWrap> orderLinesList,String salesInvGen, DateTime createDate){            
        this.soId = soId;
        this.soName = soName; 
        this.custName = custName;
        this.custType = custType;
        this.orderType = orderType;
        this.packageStatus = packageStatus;
        this.orderLinesList = orderLinesList;
        this.salesInvGen = salesInvGen;
        this.createDate = createDate;
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
       

    @auraenabled
    public static fullWrap fetchCustomerInfo(String prodId,Decimal pageNumber,Decimal pageSize,Date fromDate, Date toDate,string status){        
        List<soWrap> soWrapList = new List<soWrap>();
        Integer rowscount = 0;
        Integer off =0;
        Integer recEnd =0;
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        Integer totalRecords;
        Integer offset = (pNumber - 1) * pSize;
        Integer recordEnd = pSize * pNumber;
        Decimal totalqty =0;
        Decimal availqunt =0;
      
	   try
	   {
		   
	   
	    sigmaerpdev2__Order_Usage__c OrderTypeusage = [select Id, Name,sigmaerpdev2__Sigma_order__c,sigmaerpdev2__Standard_object__c from sigmaerpdev2__Order_Usage__c limit 1];
		if(prodId != null && prodId != '')
		{
                  Inventory__c invent = [select id,Available_Qty__c from Inventory__c where ProductCode__c =:prodId];
                            availqunt = invent.Available_Qty__c; 
        
		}
		if(OrderTypeusage.sigmaerpdev2__Sigma_order__c)
		{
            
            
            List<Sigma_Order__c> soList = new List<Sigma_Order__c>();
            List<Product_Order_Price_Book__c> solineitemList = new List<Product_Order_Price_Book__c>();
            Set<Id> soIDSet = new Set<Id>();
            set<Id> Sigmaorder = new set<Id>();
			
			
            if(prodId != null && prodId != ''){
				
             
                
            if(status =='All')
            {
            solineitemList = [select id,name,Net_Quantity__c,Order_Status__c,Sigma_Order__c,Sigma_Order__r.Name,Sigma_Order__r.AccountId__c,Sigma_Order__r.AccountId__r.name,Sigma_Order__r.Customer_Type__c,Sigma_Order__r.Delivary_Date__c,Sigma_Order__r.Order_Created_Via__c,Back_Order__c,Product__c,Product__r.Name from Product_Order_Price_Book__c where Back_Order__c=true and IsInventoryUpdated__c=false and Product__c =:prodId and sigmaerpdev2__Order_Status__c !='Canceled' and Sigma_Order__r.Delivary_Date__c >= :fromDate and Sigma_Order__r.Delivary_Date__c <= :toDate order by Sigma_Order__r.Delivary_Date__c];
            system.debug('solineitemList>>'+solineitemList);    
            }         
            else if(status =='Pending')
            {
            solineitemList = [select id,name,Net_Quantity__c,Order_Status__c,Sigma_Order__c,Sigma_Order__r.Name,Sigma_Order__r.AccountId__c,Sigma_Order__r.AccountId__r.name,Sigma_Order__r.Customer_Type__c,Sigma_Order__r.Delivary_Date__c,Sigma_Order__r.Order_Created_Via__c,Back_Order__c,Product__c,Product__r.Name from Product_Order_Price_Book__c where Back_Order__c=true and IsInventoryUpdated__c=false  and Order_Status__c ='Pending' and Product__c =:prodId and  Sigma_Order__r.Delivary_Date__c >= :fromDate and Sigma_Order__r.Delivary_Date__c <= :toDate order by Sigma_Order__r.Delivary_Date__c];
            }
            else
            {
            solineitemList = [select id,name,Net_Quantity__c,Order_Status__c,Sigma_Order__c,Sigma_Order__r.Name,Sigma_Order__r.AccountId__c,Sigma_Order__r.AccountId__r.name,Sigma_Order__r.Customer_Type__c,Sigma_Order__r.Delivary_Date__c,Sigma_Order__r.Order_Created_Via__c,Back_Order__c,Product__c,Product__r.Name from Product_Order_Price_Book__c where Back_Order__c=true and  IsInventoryUpdated__c=false and  Order_Status__c ='Order Confirmed' and Product__c =:prodId and  Sigma_Order__r.Delivary_Date__c >= :fromDate and Sigma_Order__r.Delivary_Date__c <= :toDate order by Sigma_Order__r.Delivary_Date__c];
            }        
            if(solineitemList.size() > 0){
            for(Product_Order_Price_Book__c soObj : solineitemList){
            Sigmaorder.add(soObj.Sigma_Order__c);
            }
            }
            system.debug('Sigmaorder'+Sigmaorder);
            if(Sigmaorder.size()>0)
            soList = [select id,name,AccountId__c,AccountId__r.name,Customer_Type__c,Delivary_Date__c,Order_Created_Via__c,(select id,name,Order_Status__c, Product__r.Name, Net_Quantity__c,Back_Order__c from Order_Lines__r where Back_Order__c=true and IsInventoryUpdated__c=false and Product__c =:prodId)from Sigma_Order__c where id = :Sigmaorder and Delivary_Date__c >= :fromDate and Delivary_Date__c <= :toDate order by Delivary_Date__c];
            system.debug('soList+++'+soList);    
            }

            //Main
            for(Sigma_Order__c soObj : soList){
                soWrap soWrapObj = new soWrap(null, null, null, null, null, null, null,null,null);
                soWrapObj.soId = soObj.id;
                soWrapObj.soName = soObj.name;
                soWrapObj.createDate = soObj.Delivary_Date__c;
                system.debug('date++>'+soWrapObj.createDate);
                soWrapObj.custName = soObj.AccountId__r.Name;
                soWrapObj.custType = soObj.Customer_Type__c;
                soWrapObj.orderType = soObj.Order_Created_Via__c;
                List<soliWrap> soliWrapList = new List<soliWrap>();
                String stat = '';
                String invGen = '';
                String creditImg = '';
                for(Product_Order_Price_Book__c soLiObj : soObj.Order_Lines__r){  
                    soliWrap soliWrapObj = new soliWrap(null, null, null, null, null, null, null);
                    soliWrapObj.soliId = soLiObj.Id;
                    soliWrapObj.soliName = soLiObj.name;
                    soliWrapObj.status = soLiObj.Order_Status__c;
                    soliWrapObj.prodName = soLiObj.Product__r.Name;
                    soliWrapObj.ordQuantity = soLiObj.Net_Quantity__c;
                    soliWrapList.add(soliWrapObj);
                    totalqty +=soLiObj.Net_Quantity__c;
                }           
                    soWrapObj.orderLinesList = soliWrapList;
                    soWrapList.add(soWrapObj); 
                    system.debug('soWrapList>>'+soWrapList);
                    rowscount = soWrapList.size();
                    totalRecords = soWrapList.size();
            }
		}

	else if(OrderTypeusage.sigmaerpdev2__Standard_object__c)
		{
			List<Order> orderList = new List<Order>();
            List<OrderItem> popbList = new List<OrderItem>();
            set<Id> Stdorder = new set<Id>();
            if(prodId != null && prodId != ''){
				if(status =='All')
				{
					popbList = [select id,OrderId from OrderItem where sigmaerpdev2__Back_Order__c=true and sigmaerpdev2__IsInventoryUpdated__c=false and Product2Id =:prodId and  Order.EffectiveDate >= :fromDate and Order.EffectiveDate <= :toDate order by Order.EffectiveDate];
				}         
				else if(status =='Pending')
				{
					popbList = [select id,OrderId from OrderItem where sigmaerpdev2__Back_Order__c=true and sigmaerpdev2__IsInventoryUpdated__c=false  and sigmaerpdev2__Order_Status__c ='Pending' and Product2Id =:prodId and  Order.EffectiveDate >= :fromDate and Order.EffectiveDate <= :toDate order by Order.EffectiveDate];
				}
				else
				{
					popbList = [select id,OrderId from OrderItem where sigmaerpdev2__Back_Order__c=true and  sigmaerpdev2__IsInventoryUpdated__c=false and  sigmaerpdev2__Order_Status__c ='Order Confirmed' and Product2Id =:prodId and  Order.EffectiveDate >= :fromDate and Order.EffectiveDate <= :toDate order by Order.EffectiveDate];
				} 
				
				if(popbList.size() > 0){
					for(OrderItem soObj : popbList){
						Stdorder.add(soObj.OrderId);
					}
				}
				
				if(Stdorder.size()>0)
				orderList = [select id,OrderNumber,Account.Name,EffectiveDate,sigmaerpdev2__Order_Created_Via__c,sigmaerpdev2__Customer_Type__c,Type,(select id,OrderItemNumber,Product2.Name,sigmaerpdev2__Back_Order__c,Quantity,sigmaerpdev2__Order_Status__c from OrderItems where sigmaerpdev2__Back_Order__c=true and sigmaerpdev2__IsInventoryUpdated__c=false and Product2Id =:prodId)from Order where id = :Stdorder and EffectiveDate >= :fromDate and EffectiveDate <= :toDate order by EffectiveDate];
				system.debug('orderList+++'+orderList); 
            
			}
			 for(Order soObj : orderList){
                soWrap soWrapObj = new soWrap(null, null, null, null, null, null, null,null,null);
                soWrapObj.soId = soObj.id;
				soWrapObj.soName = soObj.OrderNumber;
                soWrapObj.custName = soObj.Account.Name;
                soWrapObj.createDate = soObj.EffectiveDate;
                //soWrapObj.custName = soObj.AccountId.Name;
                soWrapObj.custType = soObj.sigmaerpdev2__Customer_Type__c;
                soWrapObj.orderType = soObj.sigmaerpdev2__Order_Created_Via__c;
                List<soliWrap> soliWrapList = new List<soliWrap>();
                String stat = '';
                String invGen = '';
                String creditImg = '';
                for(OrderItem soLiObj : soObj.OrderItems){  
                    soliWrap soliWrapObj = new soliWrap(null, null, null, null, null, null, null);
					soliWrapObj.soliId = soLiObj.id;
					soliWrapObj.soliName = soLiObj.OrderItemNumber;
					soliWrapObj.status = soLiObj.sigmaerpdev2__Order_Status__c;
					soliWrapObj.prodName = soLiObj.Product2.Name;
					soliWrapObj.ordQuantity = soLiObj.Quantity;
					soliWrapList.add(soliWrapObj);
                    totalqty +=soLiObj.Quantity;
                }           
                    soWrapObj.orderLinesList = soliWrapList;
					soWrapList.add(soWrapObj); 
					system.debug('soWrapList>>'+soWrapList);
                   
                    rowscount = soWrapList.size();
					totalRecords = soWrapList.size();
            }
			
		}		
             off = offset + 1;
             recEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            
        //}
         
		}
		catch(Exception ex)
		{
			createErrorLog.insertError('DemandPlanning',ex.getMessage(),'Method -fetchCustomerInfo ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
		} 
		if(soWrapList.size() > 0)
        return new fullWrap(soWrapList, rowscount, pSize, pNumber, totalRecords, off, recEnd,totalqty,availqunt);          
        else
        return null;
    }
     
    @auraenabled
    public static Product2 fetchCatogeryInfo(String prodId)
    {
    Product2 prodctlist;
     prodctlist = [select id,name,Product_Type__c from Product2 where id =:prodId];
     
     return prodctlist;
    }
 
}