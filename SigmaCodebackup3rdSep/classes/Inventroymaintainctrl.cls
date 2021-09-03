public with sharing class Inventroymaintainctrl {
    @AuraEnabled
    public static wrap fetchIP(string productName, string LocationName){
        wrap wp;
        System.debug('productName>>'+productName);
        System.debug('LocationName>>>'+LocationName);
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'id','Name'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new set<String>{'id','name','sigmaerpdev2__Product_Name__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Shipped_Qty__c','sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Delivered_Qty__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'id','Name','sigmaerpdev2__Products__r.Name','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Availability__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Delivered_Quantity__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Reserved_Quantity__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'id','name','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Received_Quantity__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location__c',new set<String>{'id','name','sigmaerpdev2__Location__r.Name'})
          ){*/
              list<wrap>  wrapList = new list<wrap>();
              wp = new wrap();
              Product2 prod = new Product2();
              List<Product2> prodctList = new List<Product2> ();
              List<Inventory_Location__c> invLocList = new  List<Inventory_Location__c>();
              List<Inventory__c> pIList = new List<Inventory__c>();
              List<Inventory_Location_Product__c> invLocPrdList = new List<Inventory_Location_Product__c>();
              List<Inventory_Location_Product_Line_Item__c> prdLIList = new List<Inventory_Location_Product_Line_Item__c>();
              
              Inventory_Location__c iloc =new Inventory_Location__c();
              //if((productName != null || productName =='') && (LocationName!=null || LocationName ==''))
              if(String.isNotBlank(productName) && String.isNotBlank(LocationName))
              {
                system.debug('Inside if>>');  
                prodctList = [select id, name, (select id,name,Product_Name__c,Available_Qty__c,Shipped_Qty__c,Reserved_Qty__c,Delivered_Qty__c from Product_Inventory__r  ),
                                               (select id, Name,Products__r.Name, Net_Quantity__c,Received_Quantity__c,Delivered_Quantity__c,Inventory_Location__c,Inventory_Location_Name__c,Reserved_Quantity__c from Inventory_Location_Products__r where Inventory_Location_Name__c LIKE:LocationName),
                                               (select id, name,Product__r.Name,Available_Quantity__c,Reserved_Quantity__c,  Received_Quantity__c,Bin__r.name,Inventory_Location_Product__r.Inventory_Location_Name__c  from Inventory_Location_Product_Line_Items__r where Inventory_Location_Product__r.Inventory_Location_Name__c LIKE:LocationName) from Product2  where Name LIKE: productName];  
              }
              else if(String.isNotBlank(productName)){
                  system.debug('Inside else>>');
                  prodctList = [select id, name, (select id,name,Product_Name__c,Available_Qty__c,Shipped_Qty__c,Reserved_Qty__c,Delivered_Qty__c from Product_Inventory__r  ),
                                               (select id, Name,Products__r.Name, Net_Quantity__c,Received_Quantity__c,Delivered_Quantity__c,Inventory_Location__c,Inventory_Location_Name__c,Reserved_Quantity__c from Inventory_Location_Products__r),
                                               (select id, name,Product__r.Name,Available_Quantity__c,Reserved_Quantity__c,  Received_Quantity__c,Bin__r.name,Inventory_Location_Product__r.Inventory_Location_Name__c  from Inventory_Location_Product_Line_Items__r) from Product2  where Name LIKE: productName  ];
                 
              }
              else
              {
                system.debug('else>>');
                invLocList = [select id,name,(select id,name,Products__r.Name,Net_Quantity__c,Availability__c,Received_Quantity__c,Delivered_Quantity__c,Inventory_Location__c,Inventory_Location_Name__c,Reserved_Quantity__c  from Inventory_Location_Products__r),(select id,name,Product__r.Name,Available_Quantity__c,Reserved_Quantity__c, Received_Quantity__c,Bin__r.name,Inventory_Location_Product__r.Inventory_Location_Name__c  from Inventory_Location_Product_Line_Items__r ) from Inventory_Location__c where Location__r.Name  LIKE:LocationName ];  
              }
              system.debug('prodctList>>'+prodctList);
              system.debug('invLocList>>'+invLocList);
                if(prodctList.size() > 0) 
                {
                 for(Product2 pr:prodctList){
                      if(pr.Product_Inventory__r.size() > 0){
                          for(Inventory__c pi : pr.Product_Inventory__r){
                              PIList.add(pi);
                          }
                      }
                      if(pr.Inventory_Location_Products__r.size() > 0){
                          for(Inventory_Location_Product__c pi : pr.Inventory_Location_Products__r){
                              invLocPrdList.add(pi);
                          }
                      }
                      if(pr.Inventory_Location_Product_Line_Items__r.size() > 0){
                          for(Inventory_Location_Product_Line_Item__c pi : pr.Inventory_Location_Product_Line_Items__r){
                              prdLIList.add(pi);
                          }
                      }
                  }
                }
                if(invLocList.size()>0)
                {                    
                  for(Inventory_Location__c il:invLocList){
                      
                      if(il.Inventory_Location_Products__r.size() > 0){
                          for(Inventory_Location_Product__c pi : il.Inventory_Location_Products__r){
                              invLocPrdList.add(pi);
                          }
                      }
                      if(il.Inventory_Location_Product_Line_Items__r.size() > 0){
                          for(Inventory_Location_Product_Line_Item__c pi : il.Inventory_Location_Product_Line_Items__r){
                              prdLIList.add(pi);
                          }
                      }
                      
                  }
                }
                  wp.prodinv=pIList;
                  wp.invlocpod=invLocPrdList;
                  wp.ilpli=prdLIList;    
     
              
         // }
        return wp;
    }
    
    public Class wrap
    {
        @AuraEnabled 
        public  list<Inventory__c> prodinv {set;get;}
        @AuraEnabled 
        public list<Inventory_Location_Product__c> invlocpod {set;get;}
        @AuraEnabled
        public list<Inventory_Location_Product_Line_Item__c> ilpli{set;get;}
    }  
}