public with sharing class newPurchaseOrderControllerLightning
{
    public static Purchase_Order__c POList {get;set;}
    public static List<Purchase_Order_Product__c> POPList{get;set;}

    @AuraEnabled
    public static Account fetchPurchanse(Id vendor)
    {    
        Account POrderList;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('Account')
           && CRUD_FLS_CheckUtility.checkReadPermission('Account',new Set<String>{'Id','Name','ShippingStreet','ShippingCity','ShippingState','ShippingPostalcode','ShippingCountry','sigmaerpdev2__Exchange_Currency__c','sigmaerpdev2__Exchange_Currency__r.name','sigmaerpdev2__Exchange_Currency__r.sigmaerpdev2__Display_Name__c'}))
           {
        {
            POrderList = [SELECT id,Exchange_Currency__c,Exchange_Currency__r.name,Exchange_Currency__r.Display_Name__c from Account WHERE id =: vendor];
        }
        
           }
        return POrderList;
    }  
    //code added by rashmi on 
    @AuraEnabled
    public static Default_Parameters__c getApprDetails()
    {
        Default_Parameters__c fetchdefaultflag;
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Default_Parameters__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Default_Parameters__c',new Set<String>{'sigmaerpdev2__Approval_Process_Not_Needed__c'}))
        {*/
        fetchdefaultflag= [select Approval_Process_Not_Needed__c from Default_Parameters__c Limit 1];
        system.debug('fetchdefaultflag>>>'+fetchdefaultflag);
        //}
        return fetchdefaultflag;
    }
    @AuraEnabled
    public static List<String> getPOStatus()
    {
        List<String> options;
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Default_Parameters__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order__c',new Set<String>{'sigmaerpdev2__Status__c'})
        )
        {*/
            options = new List<String>();
            Schema.DescribeFieldResult fieldResult = Purchase_Order__c.Status__c.getDescribe();
            system.debug('fieldResult-->>'+fieldResult);
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f: ple) 
            {
                options.add(f.getLabel());
                system.debug('options>>'+options);
            }   
        //}
        return options;        
    }
    
    
    
    @AuraEnabled
    public static Purchase_Order__c getPODetails(Id PurchaseOrderId)
    {
        
     /*  if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order__c')
        &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order_Product__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order__c',new Set<String>{'Id','name','sigmaerpdev2__Expected_Date__c','sigmaerpdev2__Currency__r.sigmaerpdev2__Display_Name__c','sigmaerpdev2__POSubmitted__c','sigmaerpdev2__Approved__c','sigmaerpdev2__sub_Approval__c','sigmaerpdev2__Merchant_Account__c','sigmaerpdev2__Product_Supplier__r.Name','sigmaerpdev2__Order_Date__c','sigmaerpdev2__Parent_Account__c','sigmaerpdev2__Status__c','sigmaerpdev2__Product_Supplier__c','sigmaerpdev2__Currency__r.Name','sigmaerpdev2__Currency__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order_Product__c',new Set<String>{'Id','sigmaerpdev2__Total_Buying_Price__c','sigmaerpdev2__VendorPrice__c','name','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Discount__c','sigmaerpdev2__Buying_Price__c','sigmaerpdev2__Expected_Delivery_Date__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Status__c'})
        && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Purchase_Order_Product__c',new Set<String>{'sigmaerpdev2__Purchase_Order__c'})
        )
        {*/
            /*if(checkAccessForPO())
            {*/
                POList = [select Id,name,Expected_Date__c,Currency__c,Currency__r.Name,Currency__r.Display_Name__c,POSubmitted__c,Approved__c,sub_Approval__c,Merchant_Account__c,Product_Supplier__r.Name,Order_Date__c,Parent_Account__c,Status__c,Product_Supplier__c,Product_Supplier__r.Email__c FROM Purchase_Order__c WHERE Id=:PurchaseOrderId Limit 1]; 
                system.debug('POList>>'+POList);            
           /* }
            if(checkAccessForPOP())
            {*/
               POPList = [select Id,name, Total_Buying_Price__c,VendorPrice__c,Product__c,Product__r.Name,Discount__c, Buying_Price__c, Expected_Delivery_Date__c, Quantity__c, Status__c from Purchase_Order_Product__c where Purchase_Order__c =:POList.Id];
              system.debug('PO>>'+POPList);
           // }
            for(Purchase_Order_Product__c temp : POPList)
            {
                If(temp.Buying_Price__c == null)
                {
                    temp.Buying_Price__c = 0;
                }
                If(temp.Expected_Delivery_Date__c == null)
                {
                    temp.Expected_Delivery_Date__c = date.today();
                }
            }
        //}
        return POList; 
    }
    
    @AuraEnabled
    public static List<Purchase_Order_Product__c> editPackageProducts(Id PurchaseOrderId1) 
    {  
    /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order__c')
        &&  CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order_Product__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order__c',new Set<String>{'Id','name','sigmaerpdev2__Expected_Date__c','sigmaerpdev2__Product_Supplier__c','sigmaerpdev2__Currency__r.sigmaerpdev2__Display_Name__c','sigmaerpdev2__POSubmitted__c','sigmaerpdev2__Approved__c','sigmaerpdev2__sub_Approval__c','sigmaerpdev2__Merchant_Account__c','sigmaerpdev2__Product_Supplier__r.Name','sigmaerpdev2__Order_Date__c','sigmaerpdev2__Parent_Account__c','sigmaerpdev2__Status__c','sigmaerpdev2__Currency__r.Name','sigmaerpdev2__Currency__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order_Product__c',new Set<String>{'Id','sigmaerpdev2__Total_Buying_Price__c','sigmaerpdev2__VendorPrice__c','name','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Discount__c','sigmaerpdev2__Buying_Price__c','sigmaerpdev2__Expected_Delivery_Date__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Remaining_to_come__c','sigmaerpdev2__Status__c'})
       && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Purchase_Order_Product__c',new Set<String>{'sigmaerpdev2__Purchase_Order__c'})

        )
        {*/
       
       POList = [select Id,name,Expected_Date__c,Currency__c,Currency__r.Name,Currency__r.Display_Name__c,POSubmitted__c,Approved__c,sub_Approval__c,Merchant_Account__c,Product_Supplier__r.Name,Order_Date__c,Parent_Account__c,Status__c,Product_Supplier__c FROM Purchase_Order__c WHERE Id=:PurchaseOrderId1 Limit 1]; 
                system.debug('POList>>'+POList);   
     
       POPList = [select Id,name, Total_Buying_Price__c,VendorPrice__c,Product__c,Product__r.Name,Discount__c, Buying_Price__c, Expected_Delivery_Date__c, Quantity__c,Remaining_to_come__c,Status__c from Purchase_Order_Product__c where Purchase_Order__c =:POList.Id and Status__c!='Closed']; //and sigmaerpdev2__Remaining_to_come__c=0 
              system.debug('PO>>'+POPList);
              //}
              return POPList;
    }
     @AuraEnabled
    public static List<String> getPOProductStatus()
    {
        List<String> options;
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order_Product__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order_Product__c',new Set<String>{'sigmaerpdev2__Status__c'})
        )
        {*/
           
            options = new List<String>();
            Schema.DescribeFieldResult fieldResult = Purchase_Order_Product__c.Status__c.getDescribe();
             system.debug('fieldResult-->>'+fieldResult);
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f: ple) 
            {
                options.add(f.getLabel());
                 system.debug('options-->>'+options);
            }
       // }
        return options;
    }
    
    @AuraEnabled
    public static Id CreatePO(Purchase_Order__c POObject,String POProductObject) 
       // public static Id CreatePO(string POObject,String POProductObject)
    {           
       /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order_Product__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Currency__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Currency_Exchange_Rate__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order__c',new Set<String>{'id','sigmaerpdev2__Currency__c','sigmaerpdev2__Net_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order_Product__c',new Set<String>{'sigmaerpdev2__Purchase_Order__c'})
       && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Currency__c',new Set<String>{'id','sigmaerpdev2__Symbol__c','sigmaerpdev2__Currency_Code__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Currency_Exchange_Rate__c',new Set<String>{'id','sigmaerpdev2__Rate__c','sigmaerpdev2__Currency__c'})
       && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Purchase_Order_Product__c',new Set<String>{'sigmaerpdev2__Expected_Delivery_Date__c','sigmaerpdev2__Product__c','sigmaerpdev2__Buying_Price__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Status__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Discount__c','sigmaerpdev2__Total_Buying_Price__c','sigmaerpdev2__VendorPrice__c'})
        && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Currency_Exchange_Rate__c',new Set<String>{'sigmaerpdev2__Currency__c'})
            )
        {*/
       
        system.debug('POObject-->>'+POObject);
            insert POObject;
            //upsert POObject;
            system.debug('POObject>>'+POObject);
            
            Currency__c currSymbol = null; 
            Currency_Exchange_Rate__c currExRate = null ;
            List<string> pString =new List<string>();   
            List<Purchase_Order__c > pOrder = [select id,Currency__c from Purchase_Order__c where Id = :POObject.Id];
            for(Purchase_Order__c pList :pOrder)
            {
                if(pList.Currency__c!=null)
                {
                    pString.add(pList.Currency__c);
                }
            }
            if(pString.size() > 0 )
            {
                currSymbol = [select id,Symbol__c,Currency_Code__c from Currency__c where Id =: pString limit 1];
                system.debug('currSymbol:::'+currSymbol);
                currExRate = [select id,Rate__c,Currency__c from Currency_Exchange_Rate__c where Currency__c =: pString limit 1 ];
                system.debug('currExRate>>'+currExRate);
            }
            
            List<String> selectedIdsList = new List<String>();
            Object[] values = (Object[])System.JSON.deserializeUntyped(POProductObject);
            system.debug('values>>'+values);
            if(values.size()>0)
            {         
                 for (Object id : values) 
                 {
                    selectedIdsList.add(string.valueof(id) );
                 }
             }
            String str1 = POProductObject.substring(1, POProductObject.length()-1);
            List<String> stringList = str1.split(',');
           
            List<String> strSplt = str1.split('},');
            List<String> strList = new List<String>();
            for(integer i=0;i<strSplt.size();i++)
            {
                if(i < strSplt.size()-1)
                {
                    strList.add(strSplt[i]+'}');
                }
                else
                {
                    strList.add(strSplt[i]);
                }
            }
           Integer len = strSplt.size();
          List<Purchase_Order_Product__c> POProductList = new List<Purchase_Order_Product__c>();
          for(Integer j=0; j<strList.size(); j++)
            {
                Purchase_Order_Product__c PoProd = new Purchase_Order_Product__c();
                List<String> stringList2 = strList[j].split(',');
                String str2 = POProductObject.substring(1, POProductObject.length()-1);
               
                String str = strList[j];
               Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(str);
                //added by sandhya, for upserting Quantity in PO
             Purchase_Order__c  scToUpdate = [select id,Net_Quantity__c from Purchase_Order__c where Id =: POObject.Id];

                
               for(Integer i=0; i<strList.size(); i++)
                {
                    String tempDateForChecking = String.valueOf(root.get('sigmaerpdev2__Expected_Delivery_Date__c'));
                   if(!String.isBlank(tempDateForChecking))
                    {
                        String[] TempDate = String.valueOf(root.get('sigmaerpdev2__Expected_Delivery_Date__c')).split('T');
                       Date tempExpectedDeliveryDate = Date.valueOf(TempDate[0]);
                       PoProd.Expected_Delivery_Date__c= tempExpectedDeliveryDate;
                    }
                    PoProd.Product__c = String.valueOf(root.get('sigmaerpdev2__Product__c'));
                    String tempBuyingPriceForChecking =String.valueOf(root.get('sigmaerpdev2__Buying_Price__c'));
                    if(!String.isBlank(tempBuyingPriceForChecking))
                    {
                        PoProd.Buying_Price__c = Double.valueOf(root.get('sigmaerpdev2__Buying_Price__c'));
                    }
                    PoProd.Quantity__c= String.valueOf(root.get('sigmaerpdev2__Quantity__c'));
                    PoProd.Purchase_Order__c = POObject.Id;
                    PoProd.Status__c = String.valueOf(root.get('sigmaerpdev2__Status__c'));
                    PoProd.Received_Quantity__c = Double.valueOf(root.get('sigmaerpdev2__Quantity__c'));
                    if(root.get('sigmaerpdev2__Discount__c') != null){
                        PoProd.Discount__c = Double.valueOf(root.get('sigmaerpdev2__Discount__c'));
                    }else{
                        PoProd.Discount__c = 0;  
                    }
                    //Currency
                    Double exRate=0;
                    string symbol='';
                    Double  amt=0;
                    if(currExRate!= null){
                        symbol =currSymbol.Symbol__c;
                        string rateEx = currExRate.Rate__c +'';
                        amt= Double.valueOf(rateEx)*PoProd.Buying_Price__c;
                        string currStr=symbol+' '+amt;
                        PoProd.Exchange_Net_Buying_Price__c= currStr;
                        PoProd.Exchange_Price__c = amt;
                        system.debug('sigmaerpdev2__Exchange_Total_Buying_Price_Euro__c>>'+PoProd.Exchange_Net_Buying_Price__c);
                    }
                    PoProd.Total_Buying_Price__c= Double.valueOf(root.get('sigmaerpdev2__Total_Buying_Price__c'));
                    PoProd.VendorPrice__c= Double.valueOf(root.get('sigmaerpdev2__VendorPrice__c'));
                }
                POProductList.add(PoProd);
            }
            
           
            if(checkCrudAccessForPOP1() && checkCrudAccessForPOP2())
            {
                insert POProductList;         
            }
           
           
       // } 
        return POObject.Id;
    }
    @AuraEnabled
    /*public static void UpdatePO(Purchase_Order__c POObj, String POProducts) 
    {
   if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Currency__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Currency_Exchange_Rate__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order_Product__c')
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Currency_Exchange_Rate__c',new Set<String>{'id','sigmaerpdev2__Rate__c','sigmaerpdev2__Currency__c'})
    && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Currency_Exchange_Rate__c',new Set<String>{'sigmaerpdev2__Currency__c'})
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order_Product__c',new Set<String>{'id','sigmaerpdev2__Currency__c','Name','sigmaerpdev2__Expected_Delivery_Date__c','sigmaerpdev2__Product__c','sigmaerpdev2__Buying_Price__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Status__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Discount__c','sigmaerpdev2__Total_Buying_Price__c','sigmaerpdev2__VendorPrice__c'})
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Currency__c',new Set<String>{'id','sigmaerpdev2__Symbol__c','sigmaerpdev2__Currency_Code__c'})
   && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Purchase_Order_Product__c',new Set<String>{'sigmaerpdev2__Buying_Price__c','sigmaerpdev2__Exchange_Price__c','sigmaerpdev2__Exchange_Net_Buying_Price__c','sigmaerpdev2__Expected_Delivery_Date__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Status__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Discount__c','sigmaerpdev2__Total_Buying_Price__c','sigmaerpdev2__VendorPrice__c'})
    && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Purchase_Order_Product__c',new Set<String>{'sigmaerpdev2__Purchase_Order__c'})
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order__c',new Set<String>{'id','sigmaerpdev2__Currency__c'})
    )

    {
        if(checkCrudAccessForPO())
        {
            update POObj;
        }
        //Currency
        Currency__c currSymbol = null;
        List<string> poString =new List<string>();   
        List<Purchase_Order__c > pOrder = [select id,Currency__c from Purchase_Order__c where Id = :POObj.Id];

        
        for(Purchase_Order__c pList :pOrder){
            if(pList.Currency__c !=null)
                poString.add(pList.Currency__c);
        }
        system.debug('postring'+poString);
        system.debug('postring'+poString.size());
        if( poString != null && poString.size() != 0 ) 
            currSymbol = [select id,Symbol__c,Currency_Code__c from Currency__c where Id =: poString limit 1];
        
        List<Currency_Exchange_Rate__c> currExRate = [select id,Rate__c,Currency__c from Currency_Exchange_Rate__c where Currency__c =: poString ];
 
        //End Here
        String str1 = POProducts.substring(1, POProducts.length()-1);
        List<String> stringList = str1.split(',');
        
        List<String> strSplt = str1.split('\\}\\,\\{');
        for (Integer i =1;i< strSplt.size();i++)
        {
            strSplt[i] = '{'+strSplt[i];
        }
        List<String> strList = new List<String>();
        for(integer i=0;i<strSplt.size();i++)
        {
            if(i < strSplt.size()-1)
            {
                strList.add(strSplt[i]+'}');
            }
            else
            {
                strList.add(strSplt[i]);
            }
        }
        
        List<Purchase_Order_Product__c> finalListToInsert = new List<Purchase_Order_Product__c>();
        List<Purchase_Order_Product__c> finalListToUpdate = new List<Purchase_Order_Product__c>();
        if(checkCrudAccessForPOP1() && checkCrudAccessForPOP2())
        {
            
            for(Integer j=0; j<strList.size(); j++)
            {
            Purchase_Order_Product__c tempProductList = new Purchase_Order_Product__c();
            String str = strList[j];
            Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(str);
            if(String.valueOf(root.get('Id')) == null)
            {
                tempProductList.Buying_Price__c = Double.valueOf(root.get('Buying_Price__c'));
                if(String.valueOf(root.get('sigmaerpdev2__Expected_Delivery_Date__c')) != null)
                {
                    String[] tempExpectedDeliveryDate = String.valueOf(root.get('sigmaerpdev2__Expected_Delivery_Date__c')).split('-');
                    Integer yr = Integer.valueOf(tempExpectedDeliveryDate[0]);
                    Integer mnt = Integer.valueOf(tempExpectedDeliveryDate[1]);
                    Integer Dat = Integer.valueOf(tempExpectedDeliveryDate[2]);
                    DateTime formatedExpectedDeliveryDate = DateTime.newInstance(yr, mnt, Dat);
                    tempProductList.Expected_Delivery_Date__c = Date.valueOf(formatedExpectedDeliveryDate);
                }
                tempProductList.Product__c = String.valueOf(root.get('sigmaerpdev2__Product__c'));
                tempProductList.Quantity__c = String.valueOf(root.get('sigmaerpdev2__Quantity__c'));
                tempProductList.Status__c = String.valueOf(root.get('sigmaerpdev2__Status__c'));
                system.debug('tempProductList.Status__c-->>'+tempProductList.Status__c);
                tempProductList.Purchase_Order__c = POObj.Id;
                tempProductList.Received_Quantity__c = Integer.valueOf(root.get('sigmaerpdev2__Quantity__c'));
                tempProductList.VendorPrice__c= Double.valueOf(root.get('sigmaerpdev2__VendorPrice__c'));
                tempProductList.Discount__c = Double.valueOf(root.get('sigmaerpdev2__Discount__c'));
                tempProductList.Total_Buying_Price__c= Double.valueOf(root.get('sigmaerpdev2__Total_Buying_Price__c'));
                //Currency
                Double exRate=0;
                string symbol='';
                Double  amt=0;
                if(currSymbol!= null){
                    if(currExRate.size() > 0){
                        symbol =currSymbol.Symbol__c;
                        string rateEx = currExRate[0].Rate__c +'';
                        amt= Double.valueOf(rateEx)*tempProductList.sigmaerpdev2__Buying_Price__c;
                        string currStr=symbol+' '+amt;
                        tempProductList.Exchange_Net_Buying_Price__c= currStr;
                        tempProductList.Exchange_Price__c = amt;
                    }
                }
                finalListToInsert.add(tempProductList);
            }
            else
            {
                tempProductList.Buying_Price__c = Double.valueOf(root.get('sigmaerpdev2__Buying_Price__c')); 
                if(String.valueOf(root.get('sigmaerpdev2__Expected_Delivery_Date__c')) != null)
                {
                    String[] tempExpectedDeliveryDate = String.valueOf(root.get('sigmaerpdev2__Expected_Delivery_Date__c')).split('-');
                    Integer yr = Integer.valueOf(tempExpectedDeliveryDate[0]);
                    Integer mnt = Integer.valueOf(tempExpectedDeliveryDate[1]);
                    Integer Dat = Integer.valueOf(tempExpectedDeliveryDate[2]);
                    DateTime formatedExpectedDeliveryDate = DateTime.newInstance(yr, mnt, Dat);
                    tempProductList.Expected_Delivery_Date__c = Date.valueOf(formatedExpectedDeliveryDate);
                }        
                tempProductList.Product__c = String.valueOf(root.get('sigmaerpdev2__Product__c'));
                tempProductList.Quantity__c = String.valueOf(root.get('sigmaerpdev2__Quantity__c'));
                tempProductList.Status__c = String.valueOf(root.get('sigmaerpdev2__Status__c'));
                tempProductList.Purchase_Order__c = POObj.Id;
                tempProductList.Id = String.valueOf(root.get('Id'));
                tempProductList.Received_Quantity__c = Integer.valueOf(root.get('sigmaerpdev2__Quantity__c'));
                tempProductList.Discount__c = Double.valueOf(root.get('sigmaerpdev2__Discount__c'));
                tempProductList.Total_Buying_Price__c= Double.valueOf(root.get('sigmaerpdev2__Total_Buying_Price__c'));
                tempProductList.VendorPrice__c= Double.valueOf(root.get('sigmaerpdev2__VendorPrice__c'));
                Double exRate=0;
                string symbol='';
                Double  amt=0;
                if(currSymbol!= null){
                    if(currExRate.size() > 0){
                        symbol =currSymbol.Symbol__c;
                        string rateEx = currExRate[0].Rate__c +'';
                        amt= Double.valueOf(rateEx)*tempProductList.Buying_Price__c;
                        string currStr=symbol+' '+amt;
                        tempProductList.Exchange_Net_Buying_Price__c= currStr;
                        tempProductList.Exchange_Price__c = amt;
                    }
                }
                finalListToUpdate.add(tempProductList);
            }            
            }
        }
       if(checkCrudAccessForPOP1() && checkCrudAccessForPOP2())
        {
            insert finalListToInsert;
            update finalListToUpdate;
        }
        System.debug('finalListToInsert'+finalListToInsert);
        List<Purchase_Order_Product__c> finalListToDelete = new List<Purchase_Order_Product__c>();
        List<Purchase_Order_Product__c> tempListToFetchAllPOP;
        if(checkAccessForPOP())
        {
            tempListToFetchAllPOP = [select Id, name from Purchase_Order_Product__c where Purchase_Order__c =:POObj.Id];
        }
        Map<Id,Purchase_Order_Product__c> DeleteMap = new Map<Id,Purchase_Order_Product__c>();
        Set<Id> OriginalSet = new Set<Id>();
        Set<Id> CheckingSet = new Set<Id>();
        for(Purchase_Order_Product__c temp : tempListToFetchAllPOP)
        {
            OriginalSet.add(temp.Id);
            DeleteMap.put(temp.Id,temp);
        }
        for(Purchase_Order_Product__c temp : finalListToInsert)
        {
            CheckingSet.add(temp.Id);
        }
        for(Purchase_Order_Product__c temp : finalListToUpdate)
        {
            CheckingSet.add(temp.Id);
        }
        if(OriginalSet.removeAll(CheckingSet))
        {
            OriginalSet.removeAll(CheckingSet);
        }
        for(Id temp : OriginalSet)
        {
            finalListToDelete.add(DeleteMap.get(temp));
        }
        if(checkCrudAccessForPOP())
        {
            delete finalListToDelete;
        }
        
           
    }
    }*/
    
    
    public static void UpdatePO(Purchase_Order__c POObj, String POProducts) 
    {
  /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Currency__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Currency_Exchange_Rate__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order_Product__c')
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Currency_Exchange_Rate__c',new Set<String>{'id','sigmaerpdev2__Rate__c','sigmaerpdev2__Currency__c'})
    && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Currency_Exchange_Rate__c',new Set<String>{'sigmaerpdev2__Currency__c'})
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order_Product__c',new Set<String>{'id','sigmaerpdev2__Currency__c','Name','sigmaerpdev2__Expected_Delivery_Date__c','sigmaerpdev2__Product__c','sigmaerpdev2__Buying_Price__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Status__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Discount__c','sigmaerpdev2__Total_Buying_Price__c','sigmaerpdev2__VendorPrice__c'})
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Currency__c',new Set<String>{'id','sigmaerpdev2__Symbol__c','sigmaerpdev2__Currency_Code__c'})
   && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Purchase_Order_Product__c',new Set<String>{'sigmaerpdev2__Buying_Price__c','sigmaerpdev2__Exchange_Price__c','sigmaerpdev2__Exchange_Net_Buying_Price__c','sigmaerpdev2__Expected_Delivery_Date__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Status__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Discount__c','sigmaerpdev2__Total_Buying_Price__c','sigmaerpdev2__VendorPrice__c'})
    && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Purchase_Order_Product__c',new Set<String>{'sigmaerpdev2__Purchase_Order__c'})
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order__c',new Set<String>{'id','sigmaerpdev2__Currency__c'})
    )

    {*/
        if(checkCrudAccessForPO())
        {
            update POObj;
        }
        //Currency
        Currency__c currSymbol = null;
        List<string> poString =new List<string>();   
        List<Purchase_Order__c > pOrder = [select id,Currency__c from Purchase_Order__c where Id = :POObj.Id];

        
        for(Purchase_Order__c pList :pOrder){
            if(pList.Currency__c !=null)
                poString.add(pList.Currency__c);
        }
        system.debug('postring'+poString);
        system.debug('postring'+poString.size());
        if( poString != null && poString.size() != 0 ) 
            currSymbol = [select id,Symbol__c,Currency_Code__c from Currency__c where Id =: poString limit 1];
        
        List<Currency_Exchange_Rate__c> currExRate = [select id,Rate__c,Currency__c from Currency_Exchange_Rate__c where Currency__c =: poString ];
 
        //End Here
        String str1 = POProducts.substring(1, POProducts.length()-1);
        List<String> stringList = str1.split(',');
        
        List<String> strSplt = str1.split('\\}\\,\\{');
        for (Integer i =1;i< strSplt.size();i++)
        {
            strSplt[i] = '{'+strSplt[i];
        }
        List<String> strList = new List<String>();
        for(integer i=0;i<strSplt.size();i++)
        {
            if(i < strSplt.size()-1)
            {
                strList.add(strSplt[i]+'}');
            }
            else
            {
                strList.add(strSplt[i]);
            }
        }
        
        List<Purchase_Order_Product__c> finalListToInsert = new List<Purchase_Order_Product__c>();
        List<Purchase_Order_Product__c> finalListToUpdate = new List<Purchase_Order_Product__c>();
        if(checkCrudAccessForPOP1() && checkCrudAccessForPOP2())
        {
            
            for(Integer j=0; j<strList.size(); j++)
            {
            Purchase_Order_Product__c tempProductList = new Purchase_Order_Product__c();
            String str = strList[j];
            Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(str);
            if(String.valueOf(root.get('Id')) == null)
            {
                tempProductList.Buying_Price__c = Double.valueOf(root.get('Buying_Price__c'));
                if(String.valueOf(root.get('Expected_Delivery_Date__c')) != null)
                {
                    String[] tempExpectedDeliveryDate = String.valueOf(root.get('Expected_Delivery_Date__c')).split('-');
                    Integer yr = Integer.valueOf(tempExpectedDeliveryDate[0]);
                    Integer mnt = Integer.valueOf(tempExpectedDeliveryDate[1]);
                    Integer Dat = Integer.valueOf(tempExpectedDeliveryDate[2]);
                    DateTime formatedExpectedDeliveryDate = DateTime.newInstance(yr, mnt, Dat);
                    tempProductList.Expected_Delivery_Date__c = Date.valueOf(formatedExpectedDeliveryDate);
                }
                tempProductList.Product__c = String.valueOf(root.get('Product__c'));
                tempProductList.Quantity__c = String.valueOf(root.get('Quantity__c'));
                tempProductList.Status__c = String.valueOf(root.get('Status__c'));
                system.debug('tempProductList.Status__c-->>'+tempProductList.Status__c);
                tempProductList.Purchase_Order__c = POObj.Id;
                tempProductList.Received_Quantity__c = Integer.valueOf(root.get('Quantity__c'));
                tempProductList.VendorPrice__c= Double.valueOf(root.get('VendorPrice__c'));
                tempProductList.Discount__c = Double.valueOf(root.get('Discount__c'));
                tempProductList.Total_Buying_Price__c= Double.valueOf(root.get('Total_Buying_Price__c'));
                //Currency
                Double exRate=0;
                string symbol='';
                Double  amt=0;
                if(currSymbol!= null){
                    if(currExRate.size() > 0){
                        symbol =currSymbol.Symbol__c;
                        string rateEx = currExRate[0].Rate__c +'';
                        amt= Double.valueOf(rateEx)*tempProductList.Buying_Price__c;
                        string currStr=symbol+' '+amt;
                        tempProductList.Exchange_Net_Buying_Price__c= currStr;
                        tempProductList.Exchange_Price__c = amt;
                    }
                }
                finalListToInsert.add(tempProductList);
            }
            else
            {
                tempProductList.Buying_Price__c = Double.valueOf(root.get('Buying_Price__c')); 
                if(String.valueOf(root.get('Expected_Delivery_Date__c')) != null)
                {
                    String[] tempExpectedDeliveryDate = String.valueOf(root.get('Expected_Delivery_Date__c')).split('-');
                    Integer yr = Integer.valueOf(tempExpectedDeliveryDate[0]);
                    Integer mnt = Integer.valueOf(tempExpectedDeliveryDate[1]);
                    Integer Dat = Integer.valueOf(tempExpectedDeliveryDate[2]);
                    DateTime formatedExpectedDeliveryDate = DateTime.newInstance(yr, mnt, Dat);
                    tempProductList.Expected_Delivery_Date__c = Date.valueOf(formatedExpectedDeliveryDate);
                }        
                tempProductList.Product__c = String.valueOf(root.get('Product__c'));
                tempProductList.Quantity__c = String.valueOf(root.get('Quantity__c'));
                tempProductList.Status__c = String.valueOf(root.get('Status__c'));
                tempProductList.Purchase_Order__c = POObj.Id;
                tempProductList.Id = String.valueOf(root.get('Id'));
                tempProductList.Received_Quantity__c = Integer.valueOf(root.get('Quantity__c'));
                tempProductList.Discount__c = Double.valueOf(root.get('Discount__c'));
                tempProductList.Total_Buying_Price__c= Double.valueOf(root.get('Total_Buying_Price__c'));
                tempProductList.VendorPrice__c= Double.valueOf(root.get('VendorPrice__c'));
                Double exRate=0;
                string symbol='';
                Double  amt=0;
                if(currSymbol!= null){
                    if(currExRate.size() > 0){
                        symbol =currSymbol.Symbol__c;
                        string rateEx = currExRate[0].Rate__c +'';
                        amt= Double.valueOf(rateEx)*tempProductList.Buying_Price__c;
                        string currStr=symbol+' '+amt;
                        tempProductList.Exchange_Net_Buying_Price__c= currStr;
                        tempProductList.Exchange_Price__c = amt;
                    }
                }
                finalListToUpdate.add(tempProductList);
            }            
            }
        }
       if(checkCrudAccessForPOP1() && checkCrudAccessForPOP2())
        {
            insert finalListToInsert;
            update finalListToUpdate;
        }
        System.debug('finalListToInsert'+finalListToInsert);
        List<Purchase_Order_Product__c> finalListToDelete = new List<Purchase_Order_Product__c>();
        List<Purchase_Order_Product__c> tempListToFetchAllPOP;
        if(checkAccessForPOP())
        {
            tempListToFetchAllPOP = [select Id, name from Purchase_Order_Product__c where Purchase_Order__c =:POObj.Id];
        }
        Map<Id,Purchase_Order_Product__c> DeleteMap = new Map<Id,Purchase_Order_Product__c>();
        Set<Id> OriginalSet = new Set<Id>();
        Set<Id> CheckingSet = new Set<Id>();
        for(Purchase_Order_Product__c temp : tempListToFetchAllPOP)
        {
            OriginalSet.add(temp.Id);
            DeleteMap.put(temp.Id,temp);
        }
        for(Purchase_Order_Product__c temp : finalListToInsert)
        {
            CheckingSet.add(temp.Id);
        }
        for(Purchase_Order_Product__c temp : finalListToUpdate)
        {
            CheckingSet.add(temp.Id);
        }
        if(OriginalSet.removeAll(CheckingSet))
        {
            OriginalSet.removeAll(CheckingSet);
        }
        for(Id temp : OriginalSet)
        {
            finalListToDelete.add(DeleteMap.get(temp));
        }
        if(checkCrudAccessForPOP())
        {
            delete finalListToDelete;
        }
        
           
    //}
    }
    
    
    public Static boolean checkAccessForPO()
    {
       /* if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order__c',new Set<String>{'Id','name','sigmaerpdev2__Expected_Date__c','sigmaerpdev2__Merchant_Account__c','sigmaerpdev2__Product_Supplier__r.Name','sigmaerpdev2__Order_Date__c','sigmaerpdev2__Parent_Account__c','sigmaerpdev2__Status__c','sigmaerpdev2__Product_Supplier__c','sigmaerpdev2__Product_Supplier__r.sigmaerpdev2__Exchange_Currency__c','sigmaerpdev2__Currency__r.Name','sigmaerpdev2__Currency__c'}))
        {*/
           return true;
       // }  
        return false;
    }
    
    public Static boolean checkAccessForPOP()
    {
      /*  if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order_Product__c',new Set<String>{'Id','name','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.Name', 'sigmaerpdev2__Buying_Price__c', 'sigmaerpdev2__Expected_Delivery_Date__c', 'sigmaerpdev2__Quantity__c', 'sigmaerpdev2__Status__c'}))
        {*/
           return true;
       // }  
        return false;
    }
    
    public Static boolean checkCrudAccessForPO()
    {
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order_Product__c'))
        {*/
            return true;    
       // }
        return false;
    }
    
    public Static boolean checkCrudAccessForPOP()
    {
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order_Product__c'))
        {*/
            return true;    
       // }
        return false;
    }
    public Static boolean checkCrudAccessForPOP1()
    {
        /*if(CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Purchase_Order_Product__c',new set<String>{'sigmaerpdev2__Buying_Price__c','sigmaerpdev2__Expected_Delivery_Date__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Status__c','sigmaerpdev2__Received_Quantity__c'}))
        {*/
            return true;    
        //}
        return false;
    }
     public Static boolean checkCrudAccessForPOP2()
    {
       /* if(CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Purchase_Order_Product__c',new set<String>{'sigmaerpdev2__Purchase_Order__c'}))
        {*/
            return true;    
       // }
        return false;
    }

     //code added by Anuja
    @AuraEnabled
    public Static Vendor_Product__c getbuyingprice(ID  productid,Id VendorID)
    {    
       Vendor_Product__c  price;
      /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Vendor_Product__c')
       && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Vendor_Product__c',new Set<String>{'Id','name','sigmaerpdev2__Buying_Price__c','sigmaerpdev2__Product_Name__c','sigmaerpdev2__Product_Name__r.Name','sigmaerpdev2__Account_Name__c'}))
        {*/
            price =[Select Id,Name,Buying_Price__c,Product_Name__c,Product_Name__r.Name from Vendor_Product__c where Product_Name__c =:productid and Account_Name__c =:VendorID];
        //}
        return price;
    }
    @AuraEnabled
    public Static List<Vendor_Product__c>  editvendorvalidation(String Venderid)
    {
        List<Vendor_Product__c> proname;
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Vendor_Product__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Vendor_Product__c',new Set<String>{'Id','Name','sigmaerpdev2__Product_Name__c','sigmaerpdev2__Product_Name__r.Name','sigmaerpdev2__Account_Name__c'}))
        {*/
            proname= new List<Vendor_Product__c>();
            proname=[Select Id,Name,Product_Name__c,Product_Name__r.Name,Account_Name__c from Vendor_Product__c where Account_Name__c=:Venderid and Product_Name__c!=null];
       
       // }
        return proname;
    } 
    
    @AuraEnabled
    public static List<object> fetchJSONHelpMenu()
    {    
        StaticResource sr= [select id, body from StaticResource Where Name = 'JsonPurchaseMM'];
        string allContent = sr.body.toString();
        Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(allContent);
        List<Object> trails = (List<Object>) results.get('Menu');
        
        return trails; 
    } 
    @AuraEnabled
    public static ContentDocumentLink getproductimage(Id prodId)
    {
        ContentDocumentLink productimagecontent;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('ContentDocumentLink') && CRUD_FLS_CheckUtility.checkReadPermission('ContentDocumentLink',new set<String>{'id','ContentDocumentId','ContentDocument.FileExtension','ContentDocument.LatestPublishedVersionId','ContentDocument.LatestPublishedVersion.Title','SystemModstamp','LinkedEntityId','Visibility','ShareType'}))
        {
            productimagecontent = [SELECT Id, ContentDocumentId,ContentDocument.FileExtension, ContentDocument.LatestPublishedVersionId,ContentDocument.LatestPublishedVersion.Title,SystemModstamp,LinkedEntityId,Visibility,ShareType FROM ContentDocumentLink WHERE LinkedEntityId =: prodId and ContentDocument.FileExtension IN ('jpg','png') order by SystemModstamp DESC limit 1];
        }
        return productimagecontent;
    }
    
    //Method Written by mahantesh to differentiate Community and other user login
    /*@AuraEnabled
    public static String fetchUser(){
        // query current user information
        User oUser = [select id,Profile.Name FROM User Where id =: userInfo.getUserId()];
        String URL = '';
        List<Community_Configuration__c> Custset= new List<Community_Configuration__c>();
        Custset = [select Id,Name,Retailer_Community_URL__c,Products_Per_Page__c,
                   Retailer_Profile_Name__c,Vendor_Community_URL__c,Vendor_Profile_Name__c 
                   from Community_Configuration__c where Name = 'Community Configurations' LIMIT 1];
        if(oUser.Profile.Name == Custset[0].Retailer_Profile_Name__c){      
            URL = Custset[0].Retailer_Community_URL__c;
        }else if(oUser.Profile.Name == Custset[0].Vendor_Profile_Name__c){
            URL = Custset[0].Vendor_Community_URL__c;
        }else{
            URL = '';
        }
        return URL;
    }*/
 /* @AuraEnabled
    public static List<sigmaerpdev2__Purchase_Order_Product__c> getLineItems(string purchaseId){
        System.debug('purchaseId'+purchaseId);
        return [select id,Name,sigmaerpdev2__Product__r.Name,sigmaerpdev2__Purchase_Order__r.Name,sigmaerpdev2__Total_Buying_Price__c,
                sigmaerpdev2__Expected_Delivery_Date__c,sigmaerpdev2__Quantity__c,sigmaerpdev2__Discount__c,sigmaerpdev2__Status__c from sigmaerpdev2__Purchase_Order_Product__c where sigmaerpdev2__Purchase_Order__r.Name=:purchaseId];
    }*/
    @AuraEnabled
    public static String ClonePO(String po,String pop){
        system.debug('po'+po);
         system.debug('pop'+pop);
        
        sigmaerpdev2__Purchase_Order__c posave=(sigmaerpdev2__Purchase_Order__c)System.JSON.deserialize(po,sigmaerpdev2__Purchase_Order__c.class);
        system.debug('po deser'+po);
        
        
        sigmaerpdev2__Purchase_Order__c savepo=new sigmaerpdev2__Purchase_Order__c();
        savepo.sigmaerpdev2__Product_Supplier__c=posave.sigmaerpdev2__Product_Supplier__c;
        savepo.sigmaerpdev2__Status__c=posave.sigmaerpdev2__Status__c;
        savepo.sigmaerpdev2__Order_Date__c=posave.sigmaerpdev2__Order_Date__c;
        savepo.sigmaerpdev2__Expected_Date__c=posave.sigmaerpdev2__Expected_Date__c;
        savepo.sigmaerpdev2__Cloned_From__c=posave.Name;
        savepo.sigmaerpdev2__Currency__c=posave.sigmaerpdev2__Currency__c;
        //savepo.sigmaerpdev2__Total_Amount__c=posave.sigmaerpdev2__Total_Amount__c;
        // savepo.sigmaerpdev2__Exchange_Total_Net_Buying_Price__c=posave.sigmaerpdev2__Exchange_Total_Net_Buying_Price__c;
       
        System.debug('before savepo'+savepo);
        insert savepo;
        System.debug('after savepo'+savepo);
        
         List<sigmaerpdev2__Purchase_Order_Product__c> saveli=(List<sigmaerpdev2__Purchase_Order_Product__c>)System.JSON.deserialize(pop,List<sigmaerpdev2__Purchase_Order_Product__c>.class);
        system.debug('saveli deser'+saveli);
        
        List<sigmaerpdev2__Purchase_Order_Product__c> newpop =new List<sigmaerpdev2__Purchase_Order_Product__c>();
        for(sigmaerpdev2__Purchase_Order_Product__c pref : saveli){
            sigmaerpdev2__Purchase_Order_Product__c pobj = new sigmaerpdev2__Purchase_Order_Product__c();
            pobj.sigmaerpdev2__Purchase_Order__c = savepo.id; 
            pobj.sigmaerpdev2__Product__c= pref.sigmaerpdev2__Product__c;
            pobj.sigmaerpdev2__Buying_Price__c=pref.sigmaerpdev2__Buying_Price__c;           
            pobj.sigmaerpdev2__Total_Buying_Price__c=pref.sigmaerpdev2__Total_Buying_Price__c;
            pobj.sigmaerpdev2__Expected_Delivery_Date__c=pref.sigmaerpdev2__Expected_Delivery_Date__c;
            pobj.sigmaerpdev2__Quantity__c=pref.sigmaerpdev2__Quantity__c;
            pobj.sigmaerpdev2__Discount__c=pref.sigmaerpdev2__Discount__c;
            pobj.sigmaerpdev2__Status__c=pref.sigmaerpdev2__Status__c;
            pobj.sigmaerpdev2__VendorPrice__c=pref.sigmaerpdev2__VendorPrice__c;
            pobj.sigmaerpdev2__Remaining_Dispatched_Quantity__c=pref.sigmaerpdev2__Remaining_Dispatched_Quantity__c;	
            pobj.sigmaerpdev2__Received_Quantity__c=integer.ValueOf(pobj.sigmaerpdev2__Quantity__c);
           		
            newpop.add(pobj);
        }
        System.debug('newpop'+newpop);
        insert newpop;
         System.debug('after'+newpop);
        
        
       	return savepo.Id;
        
    }
}