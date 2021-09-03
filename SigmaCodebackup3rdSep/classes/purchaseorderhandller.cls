/*=====================================================================================================
Author   : vidya minajigi
Company  : Mindlinks Solution Pvt Ltd.
Class    : purchaseorderhandller
Date     : 5/2/2020              
=======================================================================================================*/
public with sharing class purchaseorderhandller
{
    
    
   
    @AuraEnabled
    public static SoPaginationHelper fetchpurchaseorderList(Decimal pageNumber)
    {
        SoPaginationHelper r;
        
        if( CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order__c') && 
          CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order__c',new set<String>{'id','Name','sigmaerpdev2__Product_Supplier__c','sigmaerpdev2__Total_Amount__c','sigmaerpdev2__Order_Date__c','sigmaerpdev2__Expected_Date__c','CreatedById','sigmaerpdev2__Status__c','sigmaerpdev2__sub_Approval__c','sigmaerpdev2__Payment_Status__c','sigmaerpdev2__Paid_Amount__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Product_Supplier__r.Name'})
          ){
            
              Integer pageSize = 10;
              Integer offset = ((Integer)pageNumber - 1) * pageSize;
              
              r =  new SoPaginationHelper();
              r.pageSizeSigma = pageSize;
              r.pageSigma = (Integer) pageNumber;
              r.totalSigma = [SELECT count() FROM Purchase_Order__c];
              
              r.purchaselist = [select id,Name,CreatedById,Product_Supplier__c,Product_Supplier__r.Name,Total_Amount__c,Total_Amount1__c,Order_Date__c,Expected_Date__c,Status__c,Payment_Status__c,sub_Approval__c,Paid_Amount__c,Net_Quantity__c from Purchase_Order__c
                             order by createddate desc limit :pageSize offset :offset];
             
          }
        
        return r;
        
    }
     @AuraEnabled
    public static String deletepurchaseorder(Id purchaseOrderId){
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order__c') 
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order__c',new set<String>{'id'}))
         {
              try{        
                 
                  List<Purchase_Order__c> delpurchaseOrderList = [select id from Purchase_Order__c where id = :purchaseOrderId];
                  delete delpurchaseOrderList;
                 
              }catch(Exception e){
                 
                  return null;
              }
          }
        return null;
    }
    }