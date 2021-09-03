public with sharing class StockCheckController {


@AuraEnabled
    public static List<Inventory_Location_Product__c> fetchILP(){
    
    List<Inventory_Location_Product__c> ILPlist;
    
    /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'id','name','sigmaerpdev2__Delivered_Quantity__c','sigmaerpdev2__Inventory_Location_Name__c','sigmaerpdev2__Product_Name__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Products__c','sigmaerpdev2__Products__r.Name','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Received_Quantity__c'})
     )
     {*/
    ILPlist = [select id, name, Products__c, Products__r.Name,Products__r.Product_Bar_Code__c,Delivered_Quantity__c,Inventory_Location_Name__c, Inventory_Location__c,Received_Quantity__c,Product_Name__c,Net_Quantity__c from Inventory_Location_Product__c where  Products__c!=NULL order by Products__r.Name];    
     system.debug('ILPlist1>>>>>'+ILPlist);
     //}
  return ILPlist;
  }
  
  @AuraEnabled
    public static List<Inventory_Location_Product__c> fetchselectILP(String locname){
    
    List<Inventory_Location_Product__c> ILPlist;
    
     /*if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'id','name','sigmaerpdev2__Delivered_Quantity__c','sigmaerpdev2__Inventory_Location_Name__c','sigmaerpdev2__Product_Name__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Products__c','sigmaerpdev2__Products__r.Name','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Received_Quantity__c'})
     )
     {*/
    ILPlist = [select id, name, Products__c,Code__c,Products__r.Name,Products__r.Product_Bar_Code__c,Delivered_Quantity__c,Inventory_Location_Name__c, Inventory_Location__c,Received_Quantity__c,Product_Name__c,Net_Quantity__c from Inventory_Location_Product__c where  Products__c!=NULL and Inventory_Location__r.Location__r.id =: locname order by Products__r.Name];    
     system.debug('ILPlist2>>>>'+ILPlist);
     //}
  return ILPlist;
  }
  
  
  @AuraEnabled
  public static string SaveStockCheck(String StockDetails,Stock_Check__c StockCheck)
  {
  /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Stock_Check__c')
      && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Stock_Check_Details__c')
      && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Stock_Check_Details__c',new set<String>{'sigmaerpdev2__Reason_Code__c','sigmaerpdev2__Stock_Check__c','sigmaerpdev2__StockCheckbox__c','sigmaerpdev2__Stock_Check_Quantity__c','sigmaerpdev2__Status__c','sigmaerpdev2__Available_Quantity__c'})
      && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Stock_Check__c',new set<String>{'id'})
     && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Stock_Check__c',new set<String>{'sigmaerpdev2__Status__c'})
   )
   {*/
        
        if(StockCheck != null){        
            insert StockCheck;
           
        }        
         
        List<Stock_Check_Details__c> scdToInsert = new List<Stock_Check_Details__c>();
        Type  objectType =Type.forName('List<Stock_Check_Details__c>');
        List<Stock_Check_Details__c> scDetails=(List<Stock_Check_Details__c>) JSON.deserialize(StockDetails, objectType);
        if(!scDetails.isEmpty()){
            for(Stock_Check_Details__c scd:scDetails){
               // added by babji (scd.StockCheckbox__c==true)
                if(StockCheck.Id != null){
                    scd.Stock_Check__c = StockCheck.Id;
                    if(scd.Reason_Code__c =='--None--'){
                        scd.Reason_Code__c = null;
                    }
                    
                    if(scd.StockCheckbox__c == true && scd.Available_Quantity__c!= scd.Stock_Check_Quantity__c){
                        scd.Status__c ='Verified - Not Matched';
                        
                    }
                    if(scd.StockCheckbox__c == true && scd.Available_Quantity__c== scd.Stock_Check_Quantity__c){
                        scd.Status__c ='Verified';
                    }
                    if(scd.StockCheckbox__c == true && scd.Available_Quantity__c== 0){
                        scd.Status__c ='Verified';
                    }
                    if(scd.StockCheckbox__c == false ){
                        scd.Status__c ='Not Verified';
                    }
                  scdToInsert.add(scd);
                }
                
            }
            if(!scdToInsert.isEmpty()){
                insert scdToInsert;
                Boolean chckFlag = false;
                for(Stock_Check_Details__c scd:scdToInsert){
                    if(scd.StockCheckbox__c){
                        chckFlag = true;
                    }
                    else{
                    chckFlag = false;
                       break;
                    }
                }
                Stock_Check__c  scToUpdate = [select id,Status__c from Stock_Check__c where Id =: StockCheck.Id];

                if(chckFlag){
                    scToUpdate.Status__c = 'Completed';
                    update scToUpdate;
                    return scToUpdate.Id;
                }
                else{
                scToUpdate.Status__c = 'InProgress';
                    update scToUpdate;
                    return scToUpdate.Id;
                }
               
                
            }
        }
        //}
    
        return null;
  }

}