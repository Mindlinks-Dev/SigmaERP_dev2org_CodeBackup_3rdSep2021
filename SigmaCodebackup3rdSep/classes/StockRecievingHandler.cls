public with sharing class StockRecievingHandler
{
    
    
    // Code For Stock Recieving
    @AuraEnabled
    public static SoPaginationHelper fetchStockRecievingList(Decimal pageNumber)
    {
        SoPaginationHelper r;
        
      /*  if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Stock_In__c',new set<String>{'id','Name','sigmaerpdev__Vendor__r.Name','sigmaerpdev__Location__r.Name','sigmaerpdev__Received_Date_Time__c','sigmaerpdev__Status__c'})
          ){ */
            
              Integer pageSize = 10;
              Integer offset = ((Integer)pageNumber - 1) * pageSize;
              
              r =  new SoPaginationHelper();
              r.pageSizeSigma = pageSize;
              r.pageSigma = (Integer) pageNumber;
              r.totalSigma = [SELECT count() FROM Stock_In__c];
              
              r.stockList = [select id,Name,Vendor__r.Name,Location__r.Name,Received_Date_Time__c,Status__c from Stock_In__c
                             order by createddate desc limit :pageSize offset :offset];
             
         // }
        
        return r;
        
    }
    @AuraEnabled
    public static ContentDocumentLink getproductimage(Id prodId)
    {
        ContentDocumentLink productimagecontent;
        //if(CRUD_FLS_CheckUtility.checkObjCRUD('ContentDocumentLink') && CRUD_FLS_CheckUtility.checkReadPermission('ContentDocumentLink',new set<String>{'id','ContentDocumentId','ContentDocument.FileExtension','ContentDocument.LatestPublishedVersionId','ContentDocument.LatestPublishedVersion.Title','SystemModstamp','LinkedEntityId','Visibility','ShareType'}))
        //{
            productimagecontent = [SELECT Id, ContentDocumentId,ContentDocument.FileExtension, ContentDocument.LatestPublishedVersionId,ContentDocument.LatestPublishedVersion.Title,SystemModstamp,LinkedEntityId,Visibility,ShareType FROM ContentDocumentLink WHERE LinkedEntityId =: prodId and ContentDocument.FileExtension IN ('jpg','png') order by SystemModstamp DESC limit 1];
        //}
        return productimagecontent;
    }
     @AuraEnabled
    public static String deletestock(Id StockId){
      //  if(CRUD_FLS_CheckUtility.checkReadPermission('Stock_In__c',new set<String>{'id'})
           //&& CRUD_FLS_CheckUtility.checkObjCRUD('Stock_In__c')
          //){
              try{        
                 
                  system.debug('aaa');
                  List<Stock_In__c> delStockList = [select id from Stock_In__c where id = :StockId];
                  delete delStockList;
                 
              }catch(Exception e){
                  System.debug('Exception in Delete>>>>>'+e.getMessage());
                  return null;
              }
          
        return null;
    }
    }