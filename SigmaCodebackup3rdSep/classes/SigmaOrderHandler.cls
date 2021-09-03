/*=====================================================================================================
Author   : Sandhya
Company  : Mindlinks Solution Pvt Ltd.
Class    : Sigma Order and Order Handlers,Proposal Handler 
Date     : 20-08-2018              
=======================================================================================================*/
public without sharing class SigmaOrderHandler
{
    
    
    // Code For Sigma Order
    @AuraEnabled
    public static SoPaginationHelper fetchSigmaOrderList(Decimal pageNumber)
    {
        SoPaginationHelper r;
        
       /* if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'id','Name','RecordTypeId','RecordType.Name','sigmaerpdev__AccountId__r.Name','CreatedById','sigmaerpdev__Order_Created_Via__c','sigmaerpdev__Orders_Status__c','sigmaerpdev__Is_Payment_Made__c','sigmaerpdev__Net_Quantity__c'})
          ){ */
			Id UserId= UserInfo.getUserId();
            User currentuser = [select Id,Profile.Name,Contact.AccountId from User where Id =: UserId];
            Community_Configuration__c Custset= [select Id,Name,Retailer_Community_URL__c,Products_Per_Page__c,Retailer_Profile_Name__c,Vendor_Community_URL__c,Vendor_Profile_Name__c from Community_Configuration__c where Name = 'Community Configurations' LIMIT 1];
            
              Integer pageSize = 10;
              Integer offset = ((Integer)pageNumber - 1) * pageSize;
              
              r =  new SoPaginationHelper();
              r.pageSizeSigma = pageSize;
              r.pageSigma = (Integer) pageNumber;
              
              if(currentuser.Profile.Name != Custset.Retailer_Profile_Name__c)
			  {
				 r.sigmaList = [select id,CreatedDate,AccountId__r.Email__c,Name,RecordTypeId,RecordType.Name,AccountId__r.Name,CreatedById,Order_Created_Via__c,Orders_Status__c,Paid_Amount__c,Is_Payment_Made__c,Net_Quantity__c,TotalAmount__c from Sigma_Order__c
                             order by createddate desc limit :pageSize offset :offset];
				r.totalSigma = [SELECT count() FROM Sigma_Order__c];
                r.IsCommunityUser = false;
			  }
			  else
			  {
				  r.sigmaList = [select id,CreatedDate,AccountId__r.Email__c,Name,RecordTypeId,RecordType.Name,AccountId__r.Name,CreatedById,Order_Created_Via__c,Orders_Status__c,Paid_Amount__c,Is_Payment_Made__c,Net_Quantity__c,Brewer_Account__c,Brewer_Account__r.Name from Sigma_Order__c where Brewer_Account__c =: currentuser.Contact.AccountId
                             order by createddate desc limit :pageSize offset :offset];
				  r.totalSigma = [SELECT count() FROM Sigma_Order__c where Brewer_Account__c =: currentuser.Contact.AccountId];
			 	r.IsCommunityUser = true;
              }
         // }
        
        return r;
        
    }
    
    
    @AuraEnabled
    public static String deleteSigmaOrder(Id SigmaOrderId){
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new set<String>{'id'})
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
          ){ */
              try{        
                 
                  List<Sigma_Order__c> delSigmaOrderList = [select id,TotalAmount__c,AccountId__c from Sigma_Order__c where id = :SigmaOrderId];
                  Sigma_Order__c so = delSigmaOrderList[0];
                  OrderCountCntrl.SOReduce(so);
                  delete delSigmaOrderList;
                 
              }catch(Exception e){
                  System.debug('Exception in Delete>>>>>'+e.getMessage());
                  return null;
              }
         // }
        return null;
    }
    // Code For Standard Order 
    @AuraEnabled
    public static SoPaginationHelper fetchOrderList(Decimal pageNumberOrder)
    {
        SoPaginationHelper r1;
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'id','AccountId','OrderNumber','Account.Name','CreatedById','TotalAmount','EffectiveDate','sigmaerpdev__Orders_Status__c','sigmaerpdev__Net_Quantity__c'})
          ){ */
            
              Integer pageSize = 10;
              Integer offset = ((Integer)pageNumberOrder - 1) * pageSize;
              
              r1 =  new SoPaginationHelper();
              r1.pageSizeOrder = pageSize;
              r1.pageOrder = (Integer) pageNumberOrder;
              r1.totalOrder = [SELECT count() FROM Order];
              
              r1.OrderList = [select id,AccountId,OrderNumber,Account.Name,CreatedById,TotalAmount,EffectiveDate,Orders_Status__c,Net_Quantity__c,Is_Payment_Made__c from Order
                              order by createddate desc limit :pageSize offset :offset];
              
          //}
        
        return r1;
        
    }
    @AuraEnabled
    public static String deleteOrder(Id OrderId){
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'id'})
           && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
          ){*/
              try{        
                   List<Order> delOrderList = [select id from Order where id = :OrderId];
                  delete delOrderList;
              }catch(Exception e){
                  System.debug('Exception in Order Delete>>>>>'+e.getMessage());
                  return null;
              }
          //}
        return null;
    }
    
    //CODE FOR VALIDATION OF SIGMA ORDER FROM CUSTOM SETTINGS 
    @AuraEnabled
    public Static customWrapper  OrderUsage(){
        
        customWrapper cu = new customWrapper();
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Time_Base_Inventory__c',new set<String>{'sigmaerpdev__Order__c','sigmaerpdev__Proposal__c','sigmaerpdev__Proposal_for_Products__c','sigmaerpdev__Proposal_to_Order__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_API__c',new set<String>{'sigmaerpdev__Subscription_Product__c','sigmaerpdev__Subscription_Renewal__c'})
          ){*/
              cu.ou = [Select Sigma_order__c,Standard_object__c from Order_Usage__c limit 1];
              cu.tmi = [Select Order__c,Proposal__c,Proposal_for_Products__c,Proposal_to_Order__c from Time_Base_Inventory__c limit 1];
              cu.OP =[select Subscription_Product__c,Subscription_Renewal__c from Order_API__c limit 1] ; 
          //}
        return cu;
    }
    
    public class customWrapper{
        @AuraEnabled
        public Order_Usage__c ou{get;set;}
        @AuraEnabled        
        public Time_Base_Inventory__c tmi{get;set;}
        @AuraEnabled 
        public Order_API__c OP{get;set;}
    }
    
    // Code For handling proposal Component 
    @AuraEnabled
    public static SoPaginationHelper fetchProposalList(Decimal pageNumberProposal)
    {
        SoPaginationHelper Prop;
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Proposal__c',new set<String>{'id','Name','sigmaerpdev__Usage_Type__c','sigmaerpdev__Proposal_Name__c','sigmaerpdev__Agency__c','sigmaerpdev__Agency__r.Name','sigmaerpdev__Client__c','sigmaerpdev__Client__r.Name','sigmaerpdev__Status__c','sigmaerpdev__Is_Order_Created__c'})
          ){*/
              Integer pageSize = 10;
              Integer offset = ((Integer)pageNumberProposal - 1) * pageSize;
              
              Prop =  new SoPaginationHelper();
              Prop.pageSizeProp = pageSize;
              Prop.pageProp = (Integer) pageNumberProposal;
              Prop.totalProp = [SELECT count() FROM Proposal__c];
              
              Prop.PropList = [select id,Name,Proposal_Name__c,Usage_Type__c,Client__r.Name,Agency__c,Agency__r.Name,Client__c,Status__c,Is_Order_Created__c from 
                               Proposal__c order by createddate desc limit :pageSize offset :offset];
             
          //}
        return Prop;
    }
    
    
    // deleting proposal
    @AuraEnabled
    public static String deleteproposal(Id propId){
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('Order',new set<String>{'id'})
           && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
          ){*/
              try{        
                   List<Proposal__c> delpropList = [select id from Proposal__c where id = :propId];
                  delete delpropList;
                  
              }catch(Exception e){
                  System.debug('Exception in proposal Delete>>>>>'+e.getMessage());
                  return null;
              }
          //}
        return null;
    }
    //CODE FOR VALIDATION OF Proposal FROM CUSTOM SETTINGS 
    @AuraEnabled
    public Static Time_Base_Inventory__c  TBIVal(){
        
        Time_Base_Inventory__c TBI = new Time_Base_Inventory__c();
        /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Time_Base_Inventory__c',new set<String>{'sigmaerpdev__Order__c','sigmaerpdev__Proposal__c','sigmaerpdev__Proposal_for_Products__c','sigmaerpdev__Proposal_to_Order__c'})
          ){*/
              TBI = [Select Order__c,Proposal__c,Proposal_for_Products__c,Proposal_to_Order__c from Time_Base_Inventory__c limit 1];
          //}
        return TBI;
    }
    
    @AuraEnabled
    public static Helpmenuwrap fetchJSONHelpMenu()
    {    
        Helpmenuwrap hlpWrap = new Helpmenuwrap();
        Id UserId= UserInfo.getUserId();
            User currentuser = [select Id,Profile.Name,Contact.AccountId from User where Id =: UserId];
            Community_Configuration__c Custset= [select Id,Name,Retailer_Community_URL__c,Products_Per_Page__c,Retailer_Profile_Name__c,Vendor_Community_URL__c,Vendor_Profile_Name__c from Community_Configuration__c where Name = 'Community Configurations' LIMIT 1];
            
                
        StaticResource sr= [select id, body from StaticResource Where Name = 'JSONStructureForSalesOrderModulesHelpMenu'];
        string allContent = sr.body.toString();
        Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(allContent);
        List<Object> trails = (List<Object>) results.get('Menu');
        hlpWrap.TralilsList = trails;
        if(currentuser.Profile.Name != Custset.Retailer_Profile_Name__c)
        	hlpWrap.CommunityUser = false;
        else
            hlpWrap.CommunityUser = true;
        return hlpWrap; 
    }   
    public class Helpmenuwrap
    {
        @AuraEnabled
        public List<object> TralilsList;
        @AuraEnabled
        public boolean CommunityUser;
    }
}