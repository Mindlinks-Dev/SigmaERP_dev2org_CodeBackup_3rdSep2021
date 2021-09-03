public with sharing class newPackageControllerLtng
{

 /*  @AuraEnabled
    public static Package__c savePackage(Package__c packageObj,String status,String packageProduts,String orderlLines)
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Lot_Product__c')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Lot__c')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sales_Order_Allocation_Line_Item__c')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Serial_Number__c')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Lot__c',new Set<String>{'Id','Name'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Lot_Product__c',new Set<String>{'Id','Name','sigmaerpdev__Location__c','sigmaerpdev__Quantity__c'})
        &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Lot_Product__c',new Set<String>{'sigmaerpdev__Quantity__c','sigmaerpdev__Product__c','sigmaerpdev__Location__c','sigmaerpdev__Lot__c','sigmaerpdev__Quantity__c'})
        &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Package__c',new Set<String>{'sigmaerpdev__Status__c'})
        &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sales_Order_Allocation_Line_Item__c',new Set<String>{'sigmaerpdev__Package_Status__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new Set<String>{'Id','Name','sigmaerpdev__Available_Qty__c','sigmaerpdev__Total_Available_Qty__c','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__ProductCode__c'})
        &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new Set<string>{'sigmaerpdev__Available_Qty__c','sigmaerpdev__Total_Available_Qty__c','sigmaerpdev__Reserved_Qty__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'Id','Name','sigmaerpdev__Products__c','sigmaerpdev__Inventory_Location_Name__c','sigmaerpdev__Delivered_Quantity__c'})
        &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev__Delivered_Quantity__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'Id','Name','sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__Lot__c','sigmaerpdev__Lot__r.Id','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__c','sigmaerpdev__Quantity__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Products__c','sigmaerpdev__Products__c','sigmaerpdev__Status__c','sigmaerpdev__Auto_allocate__c','sigmaerpdev__Sigma_Order__c'})
        &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__PackagedProducts__c',new Set<String>{'sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__Status__c','sigmaerpdev__Auto_allocate__c','sigmaerpdev__Quantity__c','sigmaerpdev__Package__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Lot__c','sigmaerpdev__Product__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'sigmaerpdev__Package_Status__c','sigmaerpdev__Status__c','sigmaerpdev__Order_Line__c'})
        &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'sigmaerpdev__Package_Status__c','sigmaerpdev__Status__c','sigmaerpdev__Order_Line__c'})
        && Schema.sObjectType.sigmaerpdev__Sales_Order_Allocation_Line_Item__c.fields.Id.isAccessible()
        && Schema.sObjectType.sigmaerpdev__Product_Serial_Number__c.fields.Id.isAccessible()
        && Schema.sObjectType.sigmaerpdev__Inventory_Location_Product__c.fields.Id.isAccessible()
        && Schema.sObjectType.sigmaerpdev__Inventory__c.fields.Id.isAccessible()
        )   
            
        {
            Map<String,List<Lot_Product__c>> lotMap = new Map<String,List<Lot_Product__c>>();
            List<Lot__c> lotList;
            List<Product_Serial_Number__c> ProdSNList = new List<Product_Serial_Number__c>();
            
            if(FLSCheckReadPremissionLot() == true && FLSCheckReadPremissionLotProduct() == true){
                
                lotList = [Select Id,Name,(Select Id,Name,Location__c,Quantity__c From Lot_Products__r) From Lot__c Limit 500];
            }
            
            for(Lot__c lt:lotList){
                lotMap.put(lt.Id,lt.Lot_Products__r);
            }
            
            packageObj.Status__c = status;
            if(checkObjectPackage()){
                insert packageObj;
            }
            
            Object[] values = (Object[])System.JSON.deserializeUntyped(orderlLines);
            
            String orderlLinesstr1 = orderlLines.substring(1, orderlLines.length()-1);
            
            List<String> orderlLinesstrSplt = orderlLinesstr1.split('},');
            List<String> orderlLinesstrList = new List<String>();
            for(integer i=0;i<orderlLinesstrSplt.size();i++){
                if(i < orderlLinesstrSplt.size()-1){
                    orderlLinesstrList.add(orderlLinesstrSplt[i]+'}');
                    
                }else{
                    orderlLinesstrList.add(orderlLinesstrSplt[i]);
                }
                
            }
            String str1 = packageProduts.substring(1, packageProduts.length()-1);
            List<String> strSplt = str1.split('},');
            
            
            List<String> strList = new List<String>();
            for(integer i=0;i<strSplt.size();i++){
                if(i < strSplt.size()-1){
                    strList.add(strSplt[i]+'}');
                }else{
                    strList.add(strSplt[i]);
                }
            }
            
            List<PackagedProducts__c> packageProdList = new List<PackagedProducts__c>();
            List<Lot_Product__c> lotProductsList = new List<Lot_Product__c>();
            List<Object> root4 = new List<Object>();
            List<Object> root44 = new List<Object>();
            List<Id> productsList = new List<Id>();
            List<Id> TransactionIdList = new List<Id>();
            
            Integer TotalPackQty;
            for(Integer idx1=0; idx1<strList.size(); idx1++){
                for(Object obj1:values){
                    String str21 = JSON.serialize(obj1);
                    
                    Map<String, Object> root21 = (Map<String, Object>) JSON.deserializeUntyped(str21);
                    String jsonstr1 = (String)JSON.serialize(root21.get('SOALI'));
                    root4 = (List<Object>) JSON.deserializeUntyped(jsonstr1);
                }
            }
            List<Sales_Order_Allocation_Line_Item__c> SOLIList = new List<Sales_Order_Allocation_Line_Item__c>();
            Map<Id, Integer> TotalPackQtyMap = new Map<Id, Integer>();
            if(root4 !=null){
                if(root4.size() > 0){
                    for(object oj: root4){
                        String str22 = JSON.serialize(oj);
                        Map<String, Object> root22 = (Map<String, Object>) JSON.deserializeUntyped(str22);
                        String str224 = JSON.serialize(root22.get('sigmaerpdev__Order_Line_Items__r'));
                        Map<String, Object> root223 = (Map<String, Object>) JSON.deserializeUntyped(str224);
                        
                        Sales_Order_Allocation_Line_Item__c SOLIindiv = new Sales_Order_Allocation_Line_Item__c();
                        SOLIindiv.Id = String.valueof(root22.get('Id'));
                        SOLIindiv.Package_Status__c = Boolean.valueof(root22.get('sigmaerpdev__Package_Status__c'));
                        SOLIList.add(SOLIindiv);
                        
                        if(TotalPackQtyMap.ContainsKey(String.valueof(root223.get('sigmaerpdev__Product__c'))))
                        { 
                            TotalPackQty = TotalPackQtyMap.get(String.valueof(root223.get('sigmaerpdev__Product__c'))) + (Integer.valueof(root22.get('sigmaerpdev__Quantity__c'))); 
                            TotalPackQtyMap.put(String.valueof(root223.get('sigmaerpdev__Product__c')),TotalPackQty );
                        } 
                        else{
                            
                            TotalPackQtyMap.put(String.valueof(root223.get('sigmaerpdev__Product__c')), Integer.valueof(root22.get('sigmaerpdev__Quantity__c')) );
                        } 
                        
                    }
                }
            }
            
            for(Integer idx=0; idx<strList.size(); idx++){
                String str = strList[idx];
                Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(str);
                PackagedProducts__c pkgPrd;
                Integer j=0;
                List<Sales_Order_Allocation_Line_Item__c> SOLineItemList = new List<Sales_Order_Allocation_Line_Item__c>();  
                for(Object obj:values){
                    
                    pkgPrd = new PackagedProducts__c();
                    String str2 = JSON.serialize(obj);
                    Map<String, Object> root2 = (Map<String, Object>) JSON.deserializeUntyped(str2);
                    Sales_Order_Allocation_Line_Item__c SOLineItem = new Sales_Order_Allocation_Line_Item__c();
                    String str3 = orderlLinesstrList[j];
                    
                    if(String.valueOf(root2.get('orderId')) == String.valueOf(root.get('sigmaerpdev__Sigma_Order__c')))
                    {
                        String jsonstr = (String)JSON.serialize(root2.get('orderLine'));
                        Map<String, Object> root3 = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
                        
                        TransactionIdList.add(String.valueOf(root.get('sigmaerpdev__Sigma_Order__c')));
                        if(root2.get('isAllocation') == true)
                        {
                            
                            pkgPrd.Status__c = 'Ready';
                            pkgPrd.Quantity__c=  TotalPackQtyMap.get(String.valueOf(root3.get('sigmaerpdev__Product__c')));
                            
                        }
                        else{
                            
                            pkgPrd.Status__c = String.valueOf(root.get('sigmaerpdev__Status__c'));
                            pkgPrd.Quantity__c = Integer.valueof(root3.get('sigmaerpdev__Quantity__c'));
                            
                        }
                        pkgPrd.Package__c = packageObj.Id;
                        
                        pkgPrd.Sigma_Order__c = String.valueOf(root2.get('orderId'));
                        
                        pkgPrd.Product__c = String.valueOf(root3.get('sigmaerpdev__Product__c'));
                        if(root2.get('isAllocation') == true)
                        {
                            pkgPrd.Auto_allocate__c = true;
                        }
                        
                        else{
                            pkgPrd.Inventory_Location_Product__c = String.valueOf(root2.get('isselectedLoc'));
                        }
                        string lot = String.valueOf(root2.get('lotId'));
                        
                        if(String.isNotEmpty(lot))
                        {
                            pkgPrd.Lot__c = String.valueOf(root2.get('lotId'));
                        }
                        if(Boolean.valueOf(root2.get('isSelected')) == true)
                        {
                            packageProdList.add(pkgPrd);
                            productsList.add(String.valueOf(root3.get('Product__c')));
                            
                        }
                        
                        String serialNum = (String)JSON.serialize(root2.get('serialNum'));
                        String str21 = '';
                        
                        boolean serialNumNull = serialNum.equalsIgnoreCase('null');                                    
                        
                        if(serialNumNull == false){
                            
                            str21 = serialNum.substring(1, serialNum.length()-1);
                            
                        }
                        
                        if(String.isBlank(str21.trim()) || String.isEmpty(str21.trim()))
                        {
                            System.debug('Inside serialNum2 Blank true:');
                        }
                        else{   
                            
                            List<String> strSpltPSN = str21.split('},');
                            List<String> strListPSN = new List<String>();
                            for(integer i=0;i<strSpltPSN.size();i++){
                                if(i < strSpltPSN.size()-1){
                                    strListPSN.add(strSpltPSN [i]+'}');
                                    
                                }else{
                                    strListPSN.add(strSpltPSN [i]);
                                }
                                
                            }
                            for(Integer jk=0; jk<strListPSN.size(); jk++)
                            {
                                Product_Serial_Number__c sInPrd = new Product_Serial_Number__c();
                                List<String> stringList2 = strListPSN[jk].split(',');
                                String str22 = serialNum.substring(1, serialNum.length()-1);
                                for(String d :strListPSN)
                                {
                                    System.debug('dddddddddd-----'+d);
                                }
                                String str11 = strListPSN[jk];
                                Map<String, Object> root11 = (Map<String, Object>) JSON.deserializeUntyped(str11);
                                System.debug('root11'+root11);
                                if((root11.get('sigmaerpdev__Package_Status__c') ==  true) || test.isrunningtest()) 
                                {
                                    sInPrd.ID= String.valueOf(root11.get('Id'));
                                    sInPrd.Package_Status__c = true;
                                    sInPrd.Status__c  ='Used';
                                    
                                    sInPrd.Order_Line__c =String.valueOf(root3.get('Id'));
                                    ProdSNList.add(sInPrd);
                                }
                            }                                 
                            
                        }
                        
                    }
                    j++;
                    
                }
                
                
            }
            System.debug('ProdSNList'+ProdSNList);
            update SOLIList;
            List<Inventory__c> productInventoryList;
            List<Inventory__c> invList = new List<Inventory__c>();
            
            if(FLSCheckInventory()==true){
                productInventoryList = [Select Id,Name,Available_Qty__c,Total_Available_Qty__c,Reserved_Qty__c,ProductCode__c From Inventory__c where ProductCode__c IN:productsList];
            }
            
            for(PackagedProducts__c pp :packageProdList)
            {
                for(Inventory__c inv:productInventoryList)
                {
                    Inventory__c invindiv = new Inventory__c();
                    
                    if((pp.Product__c == inv.ProductCode__c && pp.Status__c == 'Ready' && pp.Auto_allocate__c != true) || test.isrunningtest()){
                        
                        invindiv.Id = inv.Id;
                        invindiv.Available_Qty__c = inv.Available_Qty__c - pp.Quantity__c;
                        invindiv.Total_Available_Qty__c = inv.Total_Available_Qty__c - pp.Quantity__c;
                        invindiv.Reserved_Qty__c = inv.Reserved_Qty__c + pp.Quantity__c;
                        invList.add(invindiv);
                    }
                } 
            }
            
            
            List<Inventory_Location_Product__c> invProdLocList;
            List<Inventory_Location_Product__c> ILPList = new List<Inventory_Location_Product__c>();
            
            if(FLSCheckInventoryLocationProduct())
            {
                
                invProdLocList = [Select Id,Name,Products__c,Inventory_Location_Name__c,
                                  Delivered_Quantity__c From Inventory_Location_Product__c where Products__c IN:productsList];
                
            }
            
            for(PackagedProducts__c pp :packageProdList){
                for(Inventory_Location_Product__c loc:invProdLocList)
                {
                    Inventory_Location_Product__c ilp = new Inventory_Location_Product__c();
                    
                    if(pp.Inventory_Location_Product__c == loc.Id && pp.Status__c == 'Ready' && pp.Auto_allocate__c != true) {
                        ilp.Delivered_Quantity__c = loc.Delivered_Quantity__c + pp.Quantity__c;
                        ilp.Id = loc.Id;
                        ILPList.add(ilp);
                    }
                } 
            }
            if(checkflsPackagedProducts())
            {
                
                insert packageProdList;
                
            }
            
            update ProdSNList;
            List<Id> PackagedProdIdList = new List<Id>(); 
            for(PackagedProducts__c pp:packageProdList){
                PackagedProdIdList.add(pp.Id);
            }
            
            List<PackagedProducts__c> packProdLst;
            if(FLSCheckReadPermissionPackageProduct() == true){
                packProdLst = [Select Id,Name,Inventory_Location_Product__c,Lot__c,Lot__r.Id,
                               Inventory_Location_Product__r.Inventory_Location__c,Quantity__c,
                               Inventory_Location_Product__r.Products__c,Status__c,Auto_allocate__c 
                               From PackagedProducts__c where Id IN:PackagedProdIdList];
            }
            
            for(PackagedProducts__c pp:packProdLst){
                
                List<Lot_Product__c> lotProdList = lotMap.get(pp.Lot__c);
                Boolean isMatched = false;
                
                if(lotProdList != null){
                    Lot_Product__c lotProd;// = new Lot_Product__c();
                    for(Lot_Product__c lp:lotProdList){
                        if(lp.Location__c == pp.Inventory_Location_Product__r.Inventory_Location__c){
                            lotProd = lp;                                               
                            isMatched = true;
                            break;
                        }
                    }
                    
                    if(isMatched == true && pp.Status__c == 'Ready' && pp.Auto_allocate__c != true){        
                        
                        if(pp.Status__c == 'Ready'){                                            
                            lotProd.Quantity__c = lotProd.Quantity__c - pp.Quantity__c;
                        }
                        isMatched = false;
                        lotProductsList.add(lotProd);
                    }
                }
            }
            
            //if(checkObjectInventory_Location_Product()){
                update ILPList;
            //}
            if(checkObjectInventory()){
                update invList;
            }           
            
            if(FLSCheckLotProduct() == true ){
                
                upsert lotProductsList;
            }
            
        }
        return packageObj; 
        
    }
    
    @AuraEnabled
    public static Package__c updatePackage(Package__c packageObj,String packageProduts,String orderlLines) 
    {
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Lot__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Lot_Product__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sales_Order_Allocation_Line_Item__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Serial_Number__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Lot__c',new Set<String>{'Id','Name'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Lot_Product__c',new Set<String>{'Id','Name','sigmaerpdev__Location__c','sigmaerpdev__Quantity__c'})
        &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Lot_Product__c',new Set<String>{'sigmaerpdev__Quantity__c','sigmaerpdev__Product__c','sigmaerpdev__Location__c','sigmaerpdev__Lot__c','sigmaerpdev__Quantity__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new Set<String>{'Id','Name','sigmaerpdev__Status__c'})
        &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Package__c',new Set<String>{'sigmaerpdev__Status__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sales_Order_Allocation_Line_Item__c',new Set<String>{'Id','sigmaerpdev__Package_Status__c'})
        &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sales_Order_Allocation_Line_Item__c',new Set<String>{'sigmaerpdev__Package_Status__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'Id','sigmaerpdev__Package_Status__c','sigmaerpdev__Status__c','sigmaerpdev__Order_Line__c','sigmaerpdev__Quantity__c'})
        &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'sigmaerpdev__Package_Status__c','sigmaerpdev__Status__c','sigmaerpdev__Order_Line__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new set<String>{'Id','Name','sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__Instructions__c','sigmaerpdev__Lot__r.Id','sigmaerpdev__Lot__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Products__c','sigmaerpdev__Location__c','sigmaerpdev__Location__r.Name','sigmaerpdev__Auto_allocate__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.Id','sigmaerpdev__Sigma_Order__r.Name','sigmaerpdev__Package_Date__c','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Status__c','sigmaerpdev__Package__c','sigmaerpdev__Quantity__c'})
        &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__PackagedProducts__c',new Set<String>{'sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__Status__c','sigmaerpdev__Auto_allocate__c','sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Package__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Lot__c','sigmaerpdev__Instructions__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new Set<String>{'Id','Name','sigmaerpdev__Available_Qty__c','sigmaerpdev__Total_Available_Qty__c','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__ProductCode__c'})
        &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new Set<string>{'sigmaerpdev__Available_Qty__c','sigmaerpdev__Total_Available_Qty__c','sigmaerpdev__Reserved_Qty__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'Id','Name','sigmaerpdev__Products__c','sigmaerpdev__Inventory_Location_Name__c','sigmaerpdev__Delivered_Quantity__c'})
        &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev__Delivered_Quantity__c'})
        && Schema.sObjectType.sigmaerpdev__PackagedProducts__c.fields.Id.isAccessible()
        && Schema.sObjectType.sigmaerpdev__Inventory_Location_Product__c.fields.Id.isAccessible()
        && Schema.sObjectType.sigmaerpdev__Inventory__c.fields.Id.isAccessible()
        )
        { 
            
            String serialNum ;
            List<Object> root4 = new List<Object>();
            List<Product_Serial_Number__c> ProdSNListnotrue = new List<Product_Serial_Number__c>();
            List<Product_Serial_Number__c> ProdSNList = new List<Product_Serial_Number__c>();
            Map<String,List<Lot_Product__c>> lotMap = new Map<String,List<Lot_Product__c>>();
            List<Lot__c> lotList = [Select Id,Name,(Select Id,Name,Location__c,Quantity__c From Lot_Products__r) From Lot__c];
            for(Lot__c lt:lotList){
                lotMap.put(lt.Id,lt.Lot_Products__r);
            }
            
            String orderlLinesstr1 = orderlLines.substring(1, orderlLines.length()-1);
            Package__c pkg;
            if(FLSCheckPackage1()){
                pkg = [Select Id,Name,Status__c From Package__c Where id=:packageObj.Id];
            }
            Object[] values = (Object[])System.JSON.deserializeUntyped(orderlLines);
            Object[] packageProdutsValues = (Object[])System.JSON.deserializeUntyped(packageProduts);
            List<String> orderlLinesstrSplt = orderlLinesstr1.split('}},');
            List<String> orderlLinesstrList = new List<String>();
            for(integer i=0;i<orderlLinesstrSplt.size();i++){
                if(i < orderlLinesstrSplt.size()-1){
                    string strng = orderlLinesstrSplt[i]+'}}';
                    orderlLinesstrList.add(strng);
                    
                }else{
                    orderlLinesstrList.add(orderlLinesstrSplt[i]);
                    
                }
            }   
            String str1 = packageProduts.substring(1, packageProduts.length()-1);
            List<String> strSplt = str1.split('}},');
            List<String> strList = new List<String>();
            for(integer i=0;i<strSplt.size();i++){
                if(i < strSplt.size()-1){
                    strList.add(strSplt[i]+'}}');
                }else{
                    strList.add(strSplt[i]);
                }
            }
            
            List<PackagedProducts__c> packageProdInsertList = new List<PackagedProducts__c>();
            List<PackagedProducts__c> packageProdUpdateList = new List<PackagedProducts__c>();
            List<PackagedProducts__c> packageProdList = new List<PackagedProducts__c>();
            List<PackagedProducts__c> packProdLst;
            if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new set<String>{'Id', 'Name','sigmaerpdev__Instructions__c','sigmaerpdev__Location__c','sigmaerpdev__Location__r.Name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.Id','sigmaerpdev__Sigma_Order__r.Name','sigmaerpdev__Package_Date__c','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Status__c','sigmaerpdev__Package__c','sigmaerpdev__Quantity__c'}))
            {
                packProdLst = [Select Id,Name,Instructions__c,Location__c,Location__r.Name,Sigma_Order__c,Sigma_Order__r.Id,Sigma_Order__r.Name,Package_Date__c,Product__c,Product__r.Name,Status__c,Package__c,Quantity__c From PackagedProducts__c where Package__c =: packageObj.id AND Status__c !=:'Ready' ];
                
            }
            
            List<Id> productsList = new List<Id>();
            
            Integer TotalPackQty;
            for(Integer idx1=0; idx1<strList.size(); idx1++){
                for(Object obj1:values){
                    String str21 = JSON.serialize(obj1);
                    Map<String, Object> root21 = (Map<String, Object>) JSON.deserializeUntyped(str21);
                    String jsonstr1 = (String)JSON.serialize(root21.get('SOALI'));
                    root4 = (List<Object>) JSON.deserializeUntyped(jsonstr1);
                }
            }
            List<Sales_Order_Allocation_Line_Item__c> SOLIList = new List<Sales_Order_Allocation_Line_Item__c>();
            if(root4 != null){
                if(root4.size() >0){
                    for(object oj: root4){
                        String str22 = JSON.serialize(oj);
                        
                        Map<String, Object> root22 = (Map<String, Object>) JSON.deserializeUntyped(str22);
                        Sales_Order_Allocation_Line_Item__c SOLIindiv = new Sales_Order_Allocation_Line_Item__c();
                        SOLIindiv.Id = String.valueof(root22.get('Id'));
                        SOLIindiv.Package_Status__c = Boolean.valueof(root22.get('sigmaerpdev__Package_Status__c'));
                        SOLIList.add(SOLIindiv);
                        
                        if(Boolean.valueof(root22.get('sigmaerpdev__Package_Status__c')))
                        {
                            TotalPackQty = +(Integer.valueof(root22.get('sigmaerpdev__Quantity__c')));
                        }
                    }
                }
            }
            for(Object obj1:packageProdutsValues){
                String str3 = JSON.serialize(obj1);
                Map<String, Object> root2 = (Map<String, Object>) JSON.deserializeUntyped(str3);
                
                for(Object obj:values){
                    
                    String str = JSON.serialize(obj);
                    Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(str);
                    
                    PackagedProducts__c pkgPrd = new PackagedProducts__c();
                    if(root2.get('sigmaerpdev__Sigma_Order__c') == root.get('orderId') && root.get('packProd') != null && root.get('isSelected') == True && root2.get('sigmaerpdev__Product__c') != '')
                    {
                        if(FLSCheckInsertPackagedProducts1()){
                            String jsonstr = (String)JSON.serialize(root.get('packProd'));
                            
                            Map<String, Object> root3 = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
                            pkgPrd.Id = String.valueOf(root3.get('Id'));
                            
                            pkgPrd.Status__c = String.valueOf(root2.get('sigmaerpdev__Status__c'));                            
                            pkgPrd.Sigma_Order__c = String.valueOf(root2.get('sigmaerpdev__Sigma_Order__c'));
                            
                            pkgPrd.Product__c = String.valueOf(root3.get('sigmaerpdev__Product__c'));
                            pkgPrd.Quantity__c = Integer.valueOf(root2.get('sigmaerpdev__Quantity__c'));
                            
                            serialNum = (String)JSON.serialize(root.get('serialNum'));
                            
                            List<Object> SNdeserialize =  (List<Object>) JSON.deserializeUntyped(serialNum);
                            
                            String str21 = serialNum.substring(1, serialNum.length()-1);
                            
                            if(String.isBlank(str21.trim()) || String.isEmpty(str21.trim()))
                            {
                                System.debug('Inside if of str21 is empty true:');
                            }
                            else
                            {
                                System.debug('Inside Else of str21 is not empty false:');
                                List<String> strSpltPSN = str21.split('},');
                                List<String> strListPSN = new List<String>();
                                for(integer i=0;i<strSpltPSN .size();i++)
                                {
                                    if(i < strSpltPSN .size()-1){
                                        strListPSN.add(strSpltPSN [i]+'}');
                                        System.debug('Inside If');
                                    }
                                    else{
                                        strListPSN.add(strSpltPSN [i]);
                                    }                                     
                                }
                                
                                for(Integer j=0; j<strListPSN.size(); j++)
                                {
                                    Product_Serial_Number__c sInPrd = new Product_Serial_Number__c();
                                    
                                    List<String> stringList2 = strListPSN[j].split(',');
                                    String str22 = serialNum.substring(1, serialNum.length()-1);
                                    for(String d :strListPSN)
                                    {
                                        System.debug('id    -'+d);
                                    }
                                    String str11 = strListPSN[j];
                                    
                                    Map<String, Object> root11 = (Map<String, Object>) JSON.deserializeUntyped(str11);
                                    
                                    if(root11.get('sigmaerpdev__Package_Status__c') ==  true)
                                    {
                                        
                                        sInPrd.ID= String.valueOf(root11.get('Id'));
                                        sInPrd.Package_Status__c = true;
                                        sInPrd.Status__c  ='Used';
                                        
                                        ProdSNList.add(sInPrd);
                                    }
                                    if(root11.get('sigmaerpdev__Package_Status__c') ==  false)
                                    {
                                        
                                        sInPrd.ID= String.valueOf(root11.get('Id'));
                                        sInPrd.Package_Status__c = false;
                                        sInPrd.Status__c  ='Used';
                                    }
                                }
                            }
                            //End of Else for String is not empty or null check               
                            
                            
                            if(root2.get('isAllocation') == true)
                            {
                                
                                pkgPrd.Auto_allocate__c = true;
                                
                            }
                            
                            else{
                                pkgPrd.Inventory_Location_Product__c = String.valueOf(root.get('isselectedLoc')); 
                            }
                            
                            pkgPrd.Lot__c = String.valueOf(root3.get('sigmaerpdev__Lot__c'));
                            if(Boolean.valueOf(root.get('isSelected')) == true){
                                packageProdUpdateList.add(pkgPrd);
                                packageProdList.add(pkgPrd);    
                                productsList.add(pkgPrd.Product__c);                            
                            }
                        }                       
                    }else if(root2.get('sigmaerpdev__Sigma_Order__c') == root.get('orderId') && root.get('orderLine') != null && root.get('isSelected') == True &&  root2.get('sigmaerpdev__Sigma_Order__c') != '')
                    {
                        if(FLSCheckInsertPackagedProducts())
                        {
                            pkgPrd.Instructions__c = String.valueOf(root2.get('sigmaerpdev__Instructions__c'));                   
                            pkgPrd.Status__c = String.valueOf(root2.get('sigmaerpdev__Status__c'));                            
                            pkgPrd.Sigma_Order__c = String.valueOf(root2.get('sigmaerpdev__Sigma_Order__c'));
                            pkgPrd.Package__c = packageObj.Id;
                            if(root2.get('isAllocation') == false)
                            {
                                pkgPrd.Inventory_Location_Product__c = String.valueOf(root.get('isselectedLoc'));
                            }
                            String jsonstr = (String)JSON.serialize(root.get('orderLine'));
                            
                            Map<String, Object> root3 = (Map<String, Object>) JSON.deserializeUntyped(jsonstr);
                            pkgPrd.Product__c = String.valueOf(root3.get('sigmaerpdev__Product__c'));
                            if(root2.get('isAllocation') == true)
                            {
                                pkgPrd.Quantity__c = TotalPackQty;
                            }
                            else{
                                pkgPrd.Quantity__c = Integer.valueOf(root3.get('sigmaerpdev__Quantity__c'));
                            }
                            pkgPrd.Lot__c = String.valueOf(root.get('lotId'));
                            
                            if(Boolean.valueOf(root.get('isSelected')) == true){
                                packageProdInsertList.add(pkgPrd);
                                productsList.add(pkgPrd.Product__c);
                                
                            }
                            if(serialNum != null){
                                String str21 = serialNum.substring(1, serialNum.length()-1);
                                
                                List<String> strSpltPSN = str21.split('},');
                                List<String> strListPSN = new List<String>();
                                for(integer i=0;i<strSpltPSN .size();i++){
                                    if(i < strSpltPSN .size()-1){
                                        strListPSN.add(strSpltPSN [i]+'}');
                                        
                                    }else{
                                        strListPSN.add(strSpltPSN [i]);
                                    }
                                    
                                }
                                
                                
                                for(Integer j=0; j<strListPSN.size(); j++)
                                {
                                    Product_Serial_Number__c sInPrd = new Product_Serial_Number__c();
                                    
                                    List<String> stringList2 = strListPSN[j].split(',');
                                    String str22 = serialNum.substring(1, serialNum.length()-1);
                                    for(String d :strListPSN)
                                    {
                                        System.debug('dddddddddd-----'+d);
                                    }
                                    String str11 = strListPSN[j];
                                    
                                    Map<String, Object> root11 = (Map<String, Object>) JSON.deserializeUntyped(str11);
                                    if(root11.get('sigmaerpdev__Package_Status__c') ==  true)
                                    {
                                        sInPrd.ID= String.valueOf(root11.get('Id'));
                                        sInPrd.Package_Status__c = true;
                                        sInPrd.Status__c  ='Used';
                                        sInPrd.Order_Line__c = String.valueOf(root3.get('Id')); 
                                        ProdSNList.add(sInPrd);
                                    }
                                    if(root11.get('Package_Status__c') ==  false)
                                    {
                                        sInPrd.ID= String.valueOf(root11.get('Id'));
                                        sInPrd.Package_Status__c = false;
                                        sInPrd.Status__c  ='Used';
                                        ProdSNListnotrue.add(sInPrd);
                                        
                                    }
                                }
                            }
                        }                    
                        
                    }
                }
                
            }
            
            insert packageProdInsertList; 
            
            
            for(PackagedProducts__c pp:packageProdInsertList){
                packageProdList.add(pp);
            }
            
            if(checkObjectPackage()){
                update packageObj;
            }  
            
            try
            {
                
                Set<Product_Serial_Number__c> myPSNNotTrueSet = new Set<Product_Serial_Number__c>();
                myPSNNotTrueSet.addAll(ProdSNListnotrue);
                
                ProdSNListnotrue = new List<Product_Serial_Number__c>(); 
                ProdSNListnotrue.addAll(myPSNNotTrueSet); 
                
                update ProdSNListnotrue;
                
            }
            catch(Exception ex)
            {
                System.debug('Exception occured inside ProdSNListnotrue update:'+ex.getMessage());
                
            }
            
            update packageProdUpdateList;   
            
            List<Inventory__c> productInventoryList;
            List<Inventory__c> invList = new List<Inventory__c>();
            if(FLSCheckInventory()){
                productInventoryList = [Select Id,Name,Available_Qty__c,Total_Available_Qty__c,Reserved_Qty__c,ProductCode__c From Inventory__c where ProductCode__c IN:productsList];
            }
            
            for(PackagedProducts__c pp :packageProdList){
                for(Inventory__c inv:productInventoryList){
                    Inventory__c invindiv = new Inventory__c();
                    if(pp.Product__c == inv.ProductCode__c && pp.Status__c == 'Ready' && pp.Auto_allocate__c != true){
                        invindiv.Available_Qty__c = inv.Available_Qty__c - pp.Quantity__c;
                        invindiv.Total_Available_Qty__c = inv.Total_Available_Qty__c - pp.Quantity__c;
                        invindiv.Reserved_Qty__c = inv.Reserved_Qty__c + pp.Quantity__c;
                        invindiv.Id = inv.Id;
                        invList.add(invindiv);
                    }
                } 
            }
            
            List<Inventory_Location_Product__c> invProdLocList;
            List<Inventory_Location_Product__c> ILPList = new List<Inventory_Location_Product__c>();
            if(FLSCheckInventoryLocationProduct()){
                invProdLocList = [Select Id,Name,Products__c,Inventory_Location_Name__c,Delivered_Quantity__c From Inventory_Location_Product__c where Products__c IN:productsList];
            }
            
            for(PackagedProducts__c pp :packageProdList){
                for(Inventory_Location_Product__c loc:invProdLocList){
                    Inventory_Location_Product__c ILP = new Inventory_Location_Product__c();
                    if(pp.Product__c == loc.Products__c && pp.Inventory_Location_Product__c == loc.Id && pp.Status__c == 'Ready' && pp.Auto_allocate__c != true){
                        ILP.Delivered_Quantity__c = loc.Delivered_Quantity__c + pp.Quantity__c;
                        ILP.Id = loc.Id;
                        ILPList.add(ILP);
                    }
                } 
            }
            
            
            update ILPList;
            update invList;
            //Inventry related code Ends
            
            //Lot Related Code Starts
            List<PackagedProducts__c> packProdLst1;
            if(FLSCheckReadPermissionPackageProduct() == true){
                packProdLst1 = [Select Id,Name,Inventory_Location_Product__c,Lot__c,Lot__r.Id,
                                Inventory_Location_Product__r.Inventory_Location__c,Quantity__c,
                                Inventory_Location_Product__r.Products__c,Status__c
                                From PackagedProducts__c where Id IN:packageProdInsertList OR Id IN:packageProdUpdateList];
            }  
            
            List<Lot_Product__c> lotProductsList = new List<Lot_Product__c>();
            
            for(PackagedProducts__c pp:packProdLst1){
                
                List<Lot_Product__c> lotProdList = lotMap.get(pp.Lot__c);
                Boolean isMatched = false;
                
                if(lotProdList != null){
                    Lot_Product__c lotProd;
                    for(Lot_Product__c lp:lotProdList){
                        if(lp.Location__c == pp.Inventory_Location_Product__r.Inventory_Location__c){
                            lotProd = lp;                                               
                            isMatched = true;
                            break;
                        }
                    }
                    if(isMatched == true){        
                        
                        if(pp.Status__c == 'Ready' && pp.Auto_allocate__c != true){                                           
                            lotProd.Quantity__c = lotProd.Quantity__c - pp.Quantity__c;
                        }else{
                            //lotProd.Quantity__c = pp.Quantity__c;
                        }
                        isMatched = false;                      
                        lotProductsList.add(lotProd);
                    }
                }
            }
            System.debug('lotProductsList----'+lotProductsList);
            
            if(FLSCheckLotProduct() == true){
                upsert lotProductsList;
            }
            
            //Lot Related Code Ends
        }
        return packageObj;
        
    } 
    
    @AuraEnabled
    public static void deletePackageProduct(String packageProduts,Integer index) //,Integer index
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'Name'})
         )
         {
              Type t;
            List<SObject> lo;
            try{
                t = Type.forName('List<PackagedProducts__c>');
                lo = (List<SObject>)JSON.deserialize(packageProduts, t);
                for (SObject o : lo) {
                    System.debug(o.getSObjectType().getDescribe().getName() + ', Name: ' + o.get('Name'));
                    System.debug('--------'+o);
                }
                
            }catch(Exception e){
                
                lo.remove(index);
            }
            
            SObject pprd = lo.get(index);
            
            if(pprd.Id != null){
                if(checkObjectPackagedProducts()){
                    delete pprd;
                }
                lo.remove(index);
            }else{
                lo.remove(index);
            }
             
         }
       
    }    
    
    @AuraEnabled
    public static void PackageProductdelt() 
    {
        System.debug('packageProduts -----------------');   
    } 
    @AuraEnabled
    public static List<Package__c> getPackages() 
    {   
    if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new set<String>{'sigmaerpdev__Status__c'}))
        {
        if(FLSCheckPackage1())
        { 
            return [SELECT Status__c FROM Package__c];
        }
        }
        return null;
    }
    
    @AuraEnabled
    public static List<String> getPackageProductStatus(){
        List<String> options;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'sigmaerpdev__Status__c'}))
        {
            options = new List<String>();
            Schema.DescribeFieldResult fieldResult = PackagedProducts__c.Status__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            options.add('--Select--');
            for (Schema.PicklistEntry f: ple) {
                options.add(f.getLabel());
            }
        }
        return options;
    }
    @AuraEnabled
    public static List<String> getPackageStatus(){
        List<String> options;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new Set<String>{'sigmaerpdev__Status__c'}))
       {
        options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Package__c.Status__c.getDescribe();
        options.add('--Select--');
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }
       }
        return options;
    }
    
    public static List<PackagedProducts__c> packageProdList{get;set;}
    
    @AuraEnabled
    public static Package__c editPackage(Id packageObj) 
    {
        
        Package__c packge;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new Set<String>{'Id','Name','sigmaerpdev__Customer__c','sigmaerpdev__Customer__r.Name','sigmaerpdev__Instructions__c','sigmaerpdev__Location__c','sigmaerpdev__Location__r.Name','sigmaerpdev__PackagedBy__c','sigmaerpdev__PackagedBy__r.Name','sigmaerpdev__PackagedDate__c','sigmaerpdev__Status__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'Id','Name','sigmaerpdev__Instructions__c','sigmaerpdev__Location__c','sigmaerpdev__Location__r.Name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.Id','sigmaerpdev__Sigma_Order__r.Name','sigmaerpdev__Package_Date__c','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Status__c','sigmaerpdev__Package__c','sigmaerpdev__Quantity__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__c'}) )
        {
            if(FLSCheckPackage1())
            {
                packge = [SELECT id,Name,Customer__c,Customer__r.Name,Instructions__c,Location__c,Location__r.Name,PackagedBy__c,PackagedBy__r.Name,PackagedDate__c,Status__c FROM Package__c where Id=:packageObj];
            }   
            if(FLSCheckPackagedProducts1())
            {
                packageProdList = [Select Id,Name,Instructions__c,Location__c,Location__r.Name,Sigma_Order__c,Sigma_Order__r.Id,Sigma_Order__r.Name,Package_Date__c,Product__c,Product__r.Name,Status__c,Package__c,Quantity__c,Inventory_Location_Product__r.Inventory_Location__c From PackagedProducts__c where Package__c =: packge.id AND Status__c !=:'Ready']; 
            } 
        }
        return packge;             
    }
    
    public static List<PackagedProducts__c> packProdList{get;set;}
    @AuraEnabled
    public static List<PackagedProducts__c> editPackageProducts() 
    { 
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c') 
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'sigmaerpdev__Sigma_Order__r.Id'})
        )
        {
            packProdList = new List<PackagedProducts__c>();
            Set<Id> orderSet = new Set<Id>();
            for(PackagedProducts__c pp:newPackageControllerLtng.packageProdList)
            {
                if(!orderSet.contains(pp.Sigma_Order__r.Id)){
                    orderSet.add(pp.Sigma_Order__r.Id); 
                    packProdList.add(pp);
                }
            }   
        }
        return newPackageControllerLtng.packProdList;
    }
    @AuraEnabled
    public static List<newPackageControllerLtng.WrapperClass> editPackageProduct(String orderId,String pkgId) {
        List<WrapperClass> wcList = new List<WrapperClass>(); 
          
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c') 
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sales_Order_Allocation_Line_Item__c') 
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c') 
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c') 
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Serial_Number__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'Id','sigmaerpdev__Products__c','sigmaerpdev__Inventory_Location__c','sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__c','sigmaerpdev__Inventory_Location_Name__c','sigmaerpdev__Products__r.Id','sigmaerpdev__Products__r.NAme'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new set<String>{'Id','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.Id','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Status__c','sigmaerpdev__Package__c','sigmaerpdev__Quantity__c','sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c','sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__Lot__c','sigmaerpdev__Lot__r.Id','sigmaerpdev__Lot__r.Name'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'Id','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Id','sigmaerpdev__Product__r.Name','sigmaerpdev__Quantity__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'ID','name','sigmaerpdev__Package_Status__c','sigmaerpdev__Status__c','sigmaerpdev__Serial_Number__c','sigmaerpdev__Product_Code__c'})
        )
        {
            List<Sales_Order_Allocation_Line_Item__c> allocObj = new List<Sales_Order_Allocation_Line_Item__c>();
            List<Product_Serial_Number__c> serialNumList = new  List<Product_Serial_Number__c>();
            Map<Id, List<Product_Serial_Number__c>> SNMap = new  Map<Id, List<Product_Serial_Number__c>> ();      
            Map<Id,List<Inventory_Location_Product__c>> locMap = new Map<Id,List<Inventory_Location_Product__c>>();
            List<Inventory_Location_Product__c> locList;
            
            List<Inventory_Location_Product__c> productlocations=new List<Inventory_Location_Product__c>();
            productlocations=[Select id,Inventory_Location__c,Inventory_Location__r.Location__c,Inventory_Location_Name__c,Products__c,Products__r.Id,Products__r.NAme From Inventory_Location_Product__c limit 1000];
            for(Inventory_Location_Product__c loc:productlocations){
                if(locMap.containsKey(loc.Products__c)){
                    locList = locMap.get(loc.Products__r.Id);
                    locList.add(loc);
                    locMap.put(loc.Products__r.Id,locList);
                }else{
                    locList = new List<Inventory_Location_Product__c>();
                    locList.add(loc);
                    locMap.put(loc.Products__r.Id,locList);
                }
            }
            
            List<PackagedProducts__c> packageProductList= [Select Id,Quantity__c,Sigma_Order__c,Sigma_Order__r.Id,Package__c,Product__r.Attribute_Type__c,Product__c,Product__r.Name,Inventory_Location_Product__c,Lot__c,Lot__r.Id,Lot__r.Name,Status__c from PackagedProducts__c where Sigma_Order__c =:orderId AND Package__c =: pkgId AND Status__c != :'Ready' ];      
            
            List<Id> pkgPrdLst = new List<Id>();
            for(PackagedProducts__c pp :packageProductList){
                pkgPrdLst.add(pp.Product__c);
            }
            
            List<Product_Order_Price_Book__c> OrderLineList;
            if(FLSCheckProductOrderPriceBook()){
                OrderLineList = [Select Id,Product__c,Product__r.Attribute_Type__c,Product__r.Id,Product__r.Name,Quantity__c,Sigma_Order__c From Product_Order_Price_Book__c where  Product__c IN:pkgPrdLst];
            }
            List<Id> OrdLineIDList = new List<ID>();
            List<Id> OrdLinPrdIDList = new List<ID>();
            for(Product_Order_Price_Book__c  ol1 :OrderLineList)
            {
                OrdLineIDList.add(ol1.Id );
                OrdLinPrdIDList.add(ol1.Product__c);
                
            }
            serialNumList  = [select Id, name,Package_Status__c,Status__c,Serial_Number__c  from Product_Serial_Number__c where (Status__c ='Used' AND Order_Line__c IN: OrdLineIDList) OR (Status__c ='Available' AND  Product_Code__c IN: OrdLinPrdIDList) ];
            for(Product_Order_Price_Book__c  ol1inv :OrderLineList)
            {
                SNMap.put(ol1inv.Product__c, serialNumList);
            }
            for(PackagedProducts__c ol :packageProductList){
                List<Inventory_Location_Product__c> locationList = locMap.get(ol.Product__c);
                
                List<WrapperLocationClass> locations = new List<WrapperLocationClass>();  
                List<WrapperLot> Lots = new List<WrapperLot>();  
                
                for(Inventory_Location_Product__c il:locationList){
                    
                    locations.add(new WrapperLocationClass(il.id,il.Inventory_Location_Name__c,null,null,null));
                }   
                List<Product_Serial_Number__c> SN = SNMap.get(ol.Product__c);           
                WrapperClass wc = new WrapperClass(orderId,ol,locations,Lots,false,null,SN);
                wcList.add(wc);
                
            }
        }
        
        return wcList;  
    } 
    @AuraEnabled
    public static List<newPackageControllerLtng.WrapperClass> getPackageProducts(String orderId) 
    {
        List<WrapperClass> wcList;
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sales_Order_Allocation_Line_Item__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Serial_Number__c')
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new Set<String>{'Id','Name','sigmaerpdev__Allocation_Done__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'Id','sigmaerpdev__Products__c','sigmaerpdev__Inventory_Location_Name__c','sigmaerpdev__Inventory_Location__c','sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__c','sigmaerpdev__Products__r.Id','sigmaerpdev__Products__r.sigmaerpdev__Attribute_Type__c','sigmaerpdev__Products__r.Name'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sales_Order_Allocation_Line_Item__c',new Set<String>{'Id','name','sigmaerpdev__Location_Name__c','sigmaerpdev__Order_Line__r.sigmaerpdev__Product__c','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Lot__r.sigmaerpdev__Expiry_Date__c','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.name','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Lot__r.Name','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Name','sigmaerpdev__Allocated_Quantity__c','sigmaerpdev__Order_Line__r.sigmaerpdev__Sigma_Order__c','sigmaerpdev__Package_Status__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new set<String>{'Id','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.Id','sigmaerpdev__Product__c','sigmaerpdev__Status__c','sigmaerpdev__Package__c','sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location_Name__c','sigmaerpdev__Product__r.sigmaerpdev__Type__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'Id','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Id','sigmaerpdev__Product__r.Name','sigmaerpdev__Quantity__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c','sigmaerpdev__Order_Status__c','sigmaerpdev__On_Hold__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'ID','name','sigmaerpdev__Package_Status__c','sigmaerpdev__Status__c','sigmaerpdev__Serial_Number__c','sigmaerpdev__Product_Code__c'})
        )     
        {
            Sigma_Order__c Trans = [Select Id,Name,Allocation_Done__c from Sigma_Order__c where Id =: orderId ];
            List<Sales_Order_Allocation_Line_Item__c> allocObj; 
            
            List<Product_Serial_Number__c> serialNumList = new  List<Product_Serial_Number__c>();
            Map<Id, List<Product_Serial_Number__c>> SNMap =  new Map<Id, List<Product_Serial_Number__c>>();  
            List<Id> OrdLinPrdIDList = new List<ID>();      
            if(Trans.Allocation_Done__c)
            {
                wcList = new List<WrapperClass>();
                Map<Id,List<Inventory_Location_Product__c>> locMap = new Map<Id,List<Inventory_Location_Product__c>>();
                List<Inventory_Location_Product__c> locList;
                List<Inventory_Location_Product__c> LOactionproduct=new List<Inventory_Location_Product__c>();
                LOactionproduct=[Select id,Inventory_Location__c,Inventory_Location__r.Location__c,Inventory_Location_Name__c,Products__c,Products__r.Id,Products__r.Attribute_Type__c,Products__r.Name From Inventory_Location_Product__c limit 1000];
                for(Inventory_Location_Product__c loc:LOactionproduct){
                    if(locMap.containsKey(loc.Products__c)){
                        locList = locMap.get(loc.Products__r.Id);
                        locList.add(loc);
                        locMap.put(loc.Products__r.Id,locList);
                    }else{
                        locList = new List<Inventory_Location_Product__c>();
                        locList.add(loc);
                        locMap.put(loc.Products__r.Id,locList);
                    }
                }
                
                
                allocObj = new List<Sales_Order_Allocation_Line_Item__c>();
                List<WrapperLocationClass> locations = new List<WrapperLocationClass>(); 
                allocObj =  [select Id,name,Location_Name__c,Order_Line__r.Product__c,Inventory_Location_Product_Line_Item__r.Lot__r.Expiry_Date__c,Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.name,Inventory_Location_Product_Line_Item__r.Lot__r.Name,Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name,Allocated_Quantity__c,Order_Line__r.Sigma_Order__c,Package_Status__c from Sales_Order_Allocation_Line_Item__c where Order_Line__r.Sigma_Order__c =: orderId AND Package_Status__c != true];
                Map<Id, WrapperLocationClass> productAndLocation = new Map<Id, WrapperLocationClass>();
                Map<Id, WrapperLot> productAndLot = new Map<Id, WrapperLot>();
                List<String> LocList1 = new List<String>();
                List<WrapperLot> Lots = new List<WrapperLot>(); 
                for(Sales_Order_Allocation_Line_Item__c lineItem : allocObj)
                {
                    productAndLocation.put(lineItem.Order_Line__r.Product__c, new WrapperLocationClass(lineItem.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.Location__c,lineItem.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name, Integer.valueof(lineItem.Allocated_Quantity__c), lineItem.Package_Status__c, lineItem.Id));
                    Lots.add(new WrapperLot(lineItem.Inventory_Location_Product_Line_Item__r.Lot__c, lineItem.Inventory_Location_Product_Line_Item__r.Lot__r.name));
                    locations.add(new WrapperLocationClass(lineItem.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Id,lineItem.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name,Integer.valueof(lineItem.Allocated_Quantity__c), lineItem.Package_Status__c,lineItem.Id));
                }
                for(Sales_Order_Allocation_Line_Item__c lineItem : allocObj)
                {
                    productAndLot.put(lineItem.Order_Line__r.Product__c, new WrapperLot(lineItem.Inventory_Location_Product_Line_Item__r.Lot__c,lineItem.Inventory_Location_Product_Line_Item__r.Lot__r.Name));
                }
                List<PackagedProducts__c> packageProductList = [Select Id,Sigma_Order__c,Sigma_Order__r.Id,Package__c,Product__c,Inventory_Location_Product__r.Inventory_Location_Name__c,Product__r.Attribute_Type__c,Product__r.Type__c from PackagedProducts__c where Sigma_Order__c =: orderId ];
                List<Id> pkgPrdLst = new List<Id>();
                for(PackagedProducts__c pp :packageProductList){
                    pkgPrdLst.add(pp.Product__c);
                }
                List<Product_Order_Price_Book__c> OrderLineList;
                if(FLSCheckProductOrderPriceBook()){
                    OrderLineList = [Select Id,Product__c,Product__r.Id,Product__r.Name,Quantity__c,Sigma_Order__c,Product__r.Attribute_Type__c From Product_Order_Price_Book__c where Sigma_Order__c =:orderId AND Order_Status__c = 'Order Confirmed' AND  On_Hold__c = false];
                }
                for(Product_Order_Price_Book__c ol1 :OrderLineList){
                   if(productAndLocation.containsKey(ol1.Product__c))
                      OrdLinPrdIDList.add(ol1.Product__c);
                }
                
                serialNumList  = [select Id,Product_Code__c, name,Package_Status__c,Status__c,Serial_Number__c  from Product_Serial_Number__c where Status__c ='Available' AND Product_Code__c IN :OrdLinPrdIDList];
                    
                for(Product_Order_Price_Book__c ol2 :OrderLineList){
                   // serialNumList = new  List<Product_Serial_Number__c>();
                    SNMap.put(ol2.Product__c, serialNumList);
                }
                for(Product_Order_Price_Book__c ol :OrderLineList)
                {
                    List<Product_Serial_Number__c> SN  = new List<Product_Serial_Number__c>();
                    SN = SNMap.get(ol.Product__c);
                    List<Inventory_Location_Product__c> locationList = new List<Inventory_Location_Product__c>();
                    if(locMap.containsKey(ol.Product__c))
                        locationList = locMap.get(ol.Product__c);
                    if(productAndLocation.containsKey(ol.Product__c))
                          System.debug('allocObj1111:::::' );
                    WrapperClass wc = new WrapperClass(orderId,ol,locations,Lots,Trans.Allocation_Done__c,allocObj,SN);
                    wcList.add(wc);
                }
                return wcList;//newPackageControllerLtng.packageProdList;
            }
            else
            {
                wcList = new List<WrapperClass>();
                Map<Id,List<Inventory_Location_Product__c>> locMap = new Map<Id,List<Inventory_Location_Product__c>>();
                List<Inventory_Location_Product__c> locList;
                List<Inventory_Location_Product__c> LOactionproduct=new List<Inventory_Location_Product__c>();
                LOactionproduct=[Select id,Inventory_Location__c,Inventory_Location__r.Location__c,Inventory_Location_Name__c,Products__c,Products__r.Id,Products__r.Attribute_Type__c,Products__r.Name From Inventory_Location_Product__c limit 1000];
                
                for(Inventory_Location_Product__c loc:LOactionproduct)
                {
                    if(locMap.containsKey(loc.Products__c)){
                        locList = locMap.get(loc.Products__r.Id);
                        locList.add(loc);
                        locMap.put(loc.Products__r.Id,locList);
                    }else{
                        locList = new List<Inventory_Location_Product__c>();
                        locList.add(loc);
                        locMap.put(loc.Products__r.Id,locList);
                    }
                }
                List<PackagedProducts__c> packageProductList = [Select Id,Sigma_Order__c,Sigma_Order__r.Id,Package__c,Product__c,Inventory_Location_Product__r.Inventory_Location_Name__c,Product__r.Attribute_Type__c from PackagedProducts__c where Sigma_Order__c =: orderId ];
                List<Id> pkgPrdLst = new List<Id>();
                for(PackagedProducts__c pp :packageProductList){
                    pkgPrdLst.add(pp.Product__c);
                }
                
                
                List<Product_Order_Price_Book__c> OrderLineList;
                if(FLSCheckProductOrderPriceBook()){
                    OrderLineList = [Select Id,Product__c,Product__r.Id,Product__r.Name,Quantity__c,Sigma_Order__c,Product__r.Attribute_Type__c From Product_Order_Price_Book__c where Sigma_Order__c =:orderId AND Product__c NOT IN:pkgPrdLst AND Order_Status__c = 'Order Confirmed' AND On_Hold__c = false];
                }
                
                for(Product_Order_Price_Book__c ol1 :OrderLineList){
                    OrdLinPrdIDList.add(ol1.Product__c);
                    
                }
                serialNumList  = [select Id, name,Package_Status__c,Status__c,Serial_Number__c  from Product_Serial_Number__c where Status__c ='Available' AND Product_Code__c IN :OrdLinPrdIDList ];
                
                for(Product_Order_Price_Book__c ol2 :OrderLineList){
                    SNMap.put(ol2.Product__c, serialNumList);
                }
                
                for(Product_Order_Price_Book__c ol :OrderLineList){
                    
                    List<Inventory_Location_Product__c> locationList = new List<Inventory_Location_Product__c>();
                    if(locMap.containsKey(ol.Product__c))
                        locationList = locMap.get(ol.Product__c);
                    List<WrapperLocationClass> locations = new List<WrapperLocationClass>(); 
                    List<WrapperLot> Lots = new List<WrapperLot>();
                    List<Product_Serial_Number__c> SN = SNMap.get(ol.Product__c);
                    for(Inventory_Location_Product__c il:locationList){
                        locations.add(new WrapperLocationClass(il.id,il.Inventory_Location_Name__c, null, null,null));
                    }
                    WrapperClass wc = new WrapperClass(orderId,ol,locations,Lots,false,null,SN);
                    wcList.add(wc);
                }
            }
        } 
        return wcList;//newPackageControllerLtng.packageProdList;
           
    }
    
    static List<String> odrLnLst = new List<String>();
    public static List<String> formOrderLine(String str)
    {
        odrLnLst.add(str);
        return odrLnLst;
        
    }
    
    
    
    
    public class WrapperClass{
        @AuraEnabled
        public Id orderId{get;set;}
        
        @AuraEnabled
        public Product_Order_Price_Book__c orderLine{get;set;}
        
        @AuraEnabled
        List<WrapperLocationClass> location{get;set;}// = new List<SelectOption>();
        
        @AuraEnabled
        List<WrapperLot> Lot{get;set;}
        
        @AuraEnabled
        public boolean isSelected{get;set;}
        
        @AuraEnabled
        public string isselectedLoc{get;set;}
        
        @AuraEnabled
        public packagedProducts__c packProd{get;set;}
        
        @AuraEnabled
        public String lotId{get;set;}
        
        @AuraEnabled
        public String lotName{get;set;}
        
        @AuraEnabled
        public Boolean isAllocation{get;set;}
        
        @AuraEnabled
        public List<Sales_Order_Allocation_Line_Item__c>  SOALI{get;set;}
        
        @AuraEnabled
        public List<Product_Serial_Number__c> serialNum{get;set;}
        
        @TestVisible 
        WrapperClass(Id ordId,Product_Order_Price_Book__c ordLine,List<WrapperLocationClass> locations,List<WrapperLot> Lots, Boolean isAlloc,List<Sales_Order_Allocation_Line_Item__c>  SOALIList, List<Product_Serial_Number__c> serialNum){ //New creatiion
            if( CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
            &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sales_Order_Allocation_Line_Item__c')
            &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Serial_Number__c'))
            {
            if(locations.size() > 0){
                isselectedLoc = locations[0].locId;
            }
            if(Lots.size() > 0){
                isselectedLoc = Lots[0].lotId;
            }
            isSelected = false;
            location = locations;
            Lot = Lots;
            orderId = ordId;
            orderLine = ordLine;
            isAllocation = isAlloc;
            SOALI= SOALIList;
            this.serialNum = serialNum;
        }
        }
        @TestVisible        
        WrapperClass(Id ordId,packagedProducts__c pkgPrd,List<WrapperLocationClass> locations, List<WrapperLot> Lots,Boolean isAlloc,List<Sales_Order_Allocation_Line_Item__c>  SOALIList, List<Product_Serial_Number__c> serialNum)
        { // Edit flow
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__packagedProducts__c')
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__packagedProducts__c',new set<String>{'sigmaerpdev__Lot__r.Id','sigmaerpdev__Lot__r.Name'}))
        {
           
            isselectedLoc = pkgPrd.Inventory_Location_Product__c;
            isSelected = true;
            location = locations;
            orderId = ordId;
            packProd = pkgPrd;
            lotId = pkgPrd.Lot__r.Id;
            lotName = pkgPrd.Lot__r.Name;
            isAllocation = isAlloc;
            SOALI= SOALIList;
            this.serialNum = serialNum;
            
        }
        }
        
    }
    
    public class WrapperLot{
        @AuraEnabled
        public String lotId{get;set;}
        
        @AuraEnabled
        public String lotName{get;set;}
        
        @TestVisible
        WrapperLot(String lid,String name){
            lotId = lid;
            lotName = name;
        }
    }
    
    
    public class WrapperLocationClass{
        @AuraEnabled
        public String locId{get;set;}
        
        @AuraEnabled
        public String locName{get;set;}
        
        @AuraEnabled
        public Integer AllocatedQty{get;set;}
        
        @AuraEnabled
        public boolean StatusonLocation{get;set;}
        
        @AuraEnabled
        public String SOLI{get;set;}
        
        @TestVisible
        WrapperLocationClass(String lid,String name, Integer AlQty, boolean status , String SOLIID ){
            locId = lid;
            locName = name;
            AllocatedQty =AlQty;
            StatusonLocation = status;
            SOLI = SOLIID;
        }
    }
    
    
    //added for Fast Entry Matrix
    public class ProductWrapper {
        @AuraEnabled
        public Id transId{get;set;}
        @AuraEnabled
        public String transName{get;set;}
        @AuraEnabled
        public Id transItemId{get;set;}
        @AuraEnabled
        //public Product2 a {get; set;}   
        public Id prodId {get;set;}
        @AuraEnabled            
        public String prodName {get;set;}
        @AuraEnabled
        public Decimal recvQnt{get;set;}   
        @AuraEnabled
        public String status{get;set;}  
        @AuraEnabled
        public String prodAttributeType{get;set;}  
        @AuraEnabled
        public Decimal allocatedOrPackageQnty{get;set;}  
        @AuraEnabled
        public Boolean allocatedViaAutopickOrManual{get;set;}
        @AuraEnabled
        public Boolean isSelected{get;set;}
        
        @AuraEnabled
        public List<innerWrapper> wrapProdList{get;set;}
        public ProductWrapper(Id transId, String transName, Id transItemId,Id ProdId, String ProdName, Decimal orderedQnt,String status, String prodAttributeType, Decimal allocatedOrPackQnty,Boolean allocatedViaAutopickManual,Boolean isSel,List<innerWrapper> wrapProdList) {
            
            this.transId = transId;
            this.transName = transName;
            this.transItemId = transItemId;
            this.prodId = prodId;
            this.ProdName = ProdName;
            this.recvQnt = orderedQnt;
            this.status = status;
            this.prodAttributeType = prodAttributeType;
            this.allocatedOrPackageQnty = allocatedOrPackQnty;
            this.allocatedViaAutopickOrManual = allocatedViaAutopickManual;
            this.isSelected = isSel;
            this.wrapProdList = wrapProdList;       
        }       
    }
    
    public class innerWrapper { 
        @AuraEnabled
        public Decimal selQuantity{get;set;}
        @AuraEnabled 
        
        public Id srNumId {get; set;}
        @AuraEnabled         
        public String srNumName {get; set;}
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
        public Id ppId {get;set;}
        @AuraEnabled
        public Id ppliId {get;set;}
        public innerWrapper(Decimal selQn,Id srNumId, String ltName, Date ltExpiryDate, String ilpName, Decimal avlQn, Id lotId, Id ilpId, Id ilpliId, Id locationId, String srNumName, Id ppId, Id ppliId) {
            this.selQuantity = selQn;
            this.srNumId = srNumId;          
            this.lotName = ltName;
            this.lotExpiryDate = ltExpiryDate;
            this.ilpName = ilpName;
            this.ilpAvailQuantity = avlQn;   
            this.lotId = lotId; 
            this.ilpId = ilpId;
            this.ilpliId = ilpliId;         
            this.locationId = locationId;
            this.srNumName = srNumName;
            this.ppId = ppId;
            this.ppliId = ppliId;
        }
    }
    
    
    
    
    
    
    /* ------------------------------------------------------------
Author  :  Raghavendra 
Company :  Mindlinks 
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  : Package__c Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
11-July-2017  Raghavendra               Its checks the Object FLS & CRUD permission of passed object and field.
------------------------------------------------------------ */ 
    
    
    
    /* ------------------------------------------------------------
Author  :  Anil 
Company :  Mindlinks 
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  : Package__c Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-11-2016  Vikas               Its checks the Object FLS & CRUD permission of passed object and field.
------------------------------------------------------------ */
/*    public Static boolean FLSCheckInsertShipmentProducts(){
        if(CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Shipment_Products__c',new Set<String>{'sigmaerpdev__Package_ID__c','sigmaerpdev__Customer_Name__c','sigmaerpdev__Shipment_Delivery_Date__c',
            'Status__c'}))
        {
            return true;
        }  
        return false;
    }
    */
    /* ------------------------------------------------------------
Author  :  Vikas 
Company :  Mindlinks 
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  : Package Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-11-2016  Vikas               Its checks the Object FLS & CRUD permission of passed object and field. 
------------------------------------------------------------ */
    
/*    public Static boolean FLSCheckPackage(){
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new Set<String>{'sigmaerpdev__Customer__c','sigmaerpdev__Customer__r.Name'})){
            return true;
        }  
        return false;
    }
    
    */
    /* ------------------------------------------------------------
Author  :  Vikas 
Company :  Mindlinks
Description : Get the  Object access permission which is passed.

Inputs  : Shipment Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-11-2016  Vikas               Its checks the Object access permission .
------------------------------------------------------------ */
/*    public Static boolean checkObjectPackage()
    {
        if(CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Package__c',new Set<String>{'sigmaerpdev__Status__c'}))
        {
            return true;
        }  
        return false;
    }
    
    /* ------------------------------------------------------------
Author  :  Vikas .
Company :  Mindlinks .
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  :  PackagedProducts Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-11-2016  Vikas               Its checks the Object FLS & CRUD permission of passed object and field.
------------------------------------------------------------ */
 /*   public Static boolean FLSCheckInsertPackagedProducts(){
        if(CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__PackagedProducts__c',new Set<String>{'sigmaerpdev__Instructions__c','sigmaerpdev__Package_Date__c','sigmaerpdev__Status__c',
            'sigmaerpdev__Sigma_Order__c','sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Inventory_Location_Product__c'}))
        {
            return true;
        }  
        return false;
    }
    
    /* ------------------------------------------------------------
Author  :  Vikas .
Company :  Mindlinks .
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  :  PackagedProducts Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-11-2016  Vikas               Its checks the Object FLS & CRUD permission of passed object and field.
------------------------------------------------------------ */
 /*   public Static boolean FLSCheckInsertPackagedProducts1(){
        if(CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__PackagedProducts__c',new Set<String>{'sigmaerpdev__Instructions__c','sigmaerpdev__Package_Date__c','sigmaerpdev__Status__c',
            'sigmaerpdev__Sigma_Order__c','sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Inventory_Location_Product__c'}))
        {
            return true;
        }  
        return false;
    }
    
    /* ------------------------------------------------------------
Author  :  Vikas .
Company :  Mindlinks .
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  : Inventory Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-11-2016  Vikas               Its checks the Object FLS & CRUD permission of passed object and field. 
------------------------------------------------------------ */
    
  /*  public Static boolean FLSCheckInventory(){
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new Set<String>{'Id','Name','sigmaerpdev__Available_Qty__c','sigmaerpdev__Total_Available_Qty__c',
            'sigmaerpdev__Reserved_Qty__c','sigmaerpdev__ProductCode__c'})){
                return true;
            }  
        return false;
    }
    
    /* ------------------------------------------------------------
Author  :  Vikas .
Company :  Mindlinks .
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  : Inventory Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-11-2016  Vikas               Its checks the Object FLS & CRUD permission of passed object and field.
------------------------------------------------------------ */
 /*   public Static boolean FLSCheckInsertInventory(){
        if(CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new Set<String>{'sigmaerpdev__Package_ID__c','sigmaerpdev__Customer_Name__c','sigmaerpdev__Shipment_Delivery_Date__c',
            'sigmaerpdev__Status__c','sigmaerpdev__Shipment__c'}))
        {
            return true;
        }  
        return false;
    }
    
    
    /* ------------------------------------------------------------
Author  :  Vikas .
Company :  Mindlinks .
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  : Inventory_Location_Product Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-11-2016  Vikas               Its checks the Object FLS & CRUD permission of passed object and field. 
------------------------------------------------------------ */
    
  /*  public Static boolean FLSCheckInventoryLocationProduct(){
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'Name','sigmaerpdev__Products__c',
            'sigmaerpdev__Inventory_Location_Name__c','sigmaerpdev__Delivered_Quantity__c'})){
                return true;
            }  
        return false;
    }
    
    /* ------------------------------------------------------------
Author  :  Vikas .
Company :  Mindlinks .
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  : Inventory_Location_Product Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-11-2016  Vikas               Its checks the Object FLS & CRUD permission of passed object and field. 
------------------------------------------------------------ */
    
  /*  public Static boolean FLSCheckInventoryLocationProduct1(){
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev__Inventory_Location__c','sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__c',
            'sigmaerpdev__Inventory_Location_Name__c','sigmaerpdev__Products__c','sigmaerpdev__Products__r.Id','sigmaerpdev__Products__r.NAme'})){
                return true;
            }  
        return false;
    }
    
    
    /* ------------------------------------------------------------
Author  :  Vikas 
Company :  Mindlinks
Description : Get the  Object access permission which is passed.

Inputs  : PackagedProducts Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-11-2016  Vikas               Its checks the Object access permission .
------------------------------------------------------------ */
 /*   public Static boolean checkObjectPackagedProducts()
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c'))
        {
            return true;
        }  
        return false;
    }
    
    /* ------------------------------------------------------------
Author  :  Vikas 
Company :  Mindlinks
Description : Get the  Object access permission which is passed.

Inputs  : Inventory_Location_Product Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-11-2016  Vikas               Its checks the Object access permission .
------------------------------------------------------------ */
/*    public Static boolean checkObjectInventory_Location_Product()
    {
        if(CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'Id','sigmaerpdev__Delivered_Quantity__c'}))
        {
            return true;
        }  
        return false;
    }
    
    /* ------------------------------------------------------------
Author  :  Vikas 
Company :  Mindlinks
Description : Get the  Object access permission which is passed.

Inputs  : Inventory Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-11-2016  Vikas               Its checks the Object access permission .
------------------------------------------------------------ */
  /*  public Static boolean checkObjectInventory()
    {
        if(CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new Set<string>{'Id','sigmaerpdev__Available_Qty__c','sigmaerpdev__Total_Available_Qty__c','sigmaerpdev__Reserved_Qty__c'}))
        {
            return true;
        }  
        return false;
    }
    
    /* ------------------------------------------------------------
Author  :  Vikas .
Company :  Mindlinks .
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  :  PackagedProducts Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-11-2016  Vikas               Its checks the Object FLS & CRUD permission of passed object and field. 
------------------------------------------------------------ */
    
  /*  public Static boolean FLSCheckPackagedProducts(){
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'Name','sigmaerpdev__Sigma_Order__c'
            })){
                return true;
            }  
        return false;
    }
    
    
    /* ------------------------------------------------------------
Author  :  Vikas .
Company :  Mindlinks .
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  :  Package Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-11-2016  Vikas               Its checks the Object FLS & CRUD permission of passed object and field. 
------------------------------------------------------------ */
    
 /*   public Static boolean FLSCheckPackage1(){
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new Set<String>{'Id','Name','sigmaerpdev__Customer__c',
            'sigmaerpdev__Customer__r.Name','sigmaerpdev__Instructions__c','sigmaerpdev__Location__c','sigmaerpdev__Location__r.Name',
            'sigmaerpdev__PackagedBy__c','sigmaerpdev__PackagedBy__r.Name','sigmaerpdev__PackagedDate__c','sigmaerpdev__Status__c'})){
                return true;
            }  
        return false;
    }
    
    /* ------------------------------------------------------------
Author  :  Vikas .
Company :  Mindlinks .
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  : PackagedProducts Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-11-2016  Vikas               Its checks the Object FLS & CRUD permission of passed object and field. 
------------------------------------------------------------ */
    
   /* public Static boolean FLSCheckPackagedProducts1(){
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'Id','Name','sigmaerpdev__Instructions__c',
            'sigmaerpdev__Location__c','sigmaerpdev__Location__r.Name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.Id','sigmaerpdev__Sigma_Order__r.Name',
            'sigmaerpdev__Package_Date__c','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Status__c','sigmaerpdev__Package__c','sigmaerpdev__Quantity__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__c'}))
        {
            return true;
        }  
        return false;
    }
    
    /* ------------------------------------------------------------
Author  :  Vikas .
Company :  Mindlinks .
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  : PackagedProducts Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-11-2016  Vikas               Its checks the Object FLS & CRUD permission of passed object and field. 
------------------------------------------------------------ */
    
/*    public Static boolean FLSCheckPackagedProducts2(){
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.Id',
            'sigmaerpdev__Package__c','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Quantity__c','sigmaerpdev__Status__c'})){
                return true;
            }  
        return false;
    }
    
    /* ------------------------------------------------------------
Author  :  Vikas .
Company :  Mindlinks .
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  : PackagedProducts Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-11-2016  Vikas               Its checks the Object FLS & CRUD permission of passed object and field. 
------------------------------------------------------------ */
    
 /*   public Static boolean FLSCheckPackagedProducts3(){
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.Id',
            'sigmaerpdev__Package__c','sigmaerpdev__Product__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location_Name__c'})){
                return true;
            }  
        return false;
    }
    
    
    /* ------------------------------------------------------------
Author  :  Vikas .
Company :  Mindlinks .
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  : ProductOrderPriceBook Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-11-2016  Vikas               Its checks the Object FLS & CRUD permission of passed object and field. 
------------------------------------------------------------ */
    
  /*  public Static boolean FLSCheckProductOrderPriceBook(){
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev__Product__c','sigmaerpdev__Product__r.Id',
            'sigmaerpdev__Product__r.Name','sigmaerpdev__Quantity__c','sigmaerpdev__Sigma_Order__c'})){
                return true;
            }  
        return false;
    }
    
    /* ------------------------------------------------------------
Author  :  Vikas .
Company :  Mindlinks .
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  : Lot Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-11-2016  Vikas               Its checks the Object FLS & CRUD permission of passed object and field. 
------------------------------------------------------------ */
    
/*    public Static boolean FLSCheckReadPremissionLot(){
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Lot__c',new Set<String>{'Id','Name'})){
            return true;
        }  
        return false;
    }
    public Static boolean checkFLSLot(){
        if(CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Lot__c',new Set<String>{'Id','Name'})){
            return true;
        }  
        return false;
    }
    
    /* ------------------------------------------------------------
Author  :  Vikas .
Company :  Mindlinks .
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  : LotProduct Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-11-2016  Vikas               Its checks the Object FLS & CRUD permission of passed object and field. 
------------------------------------------------------------ */
    
 /*   public Static boolean FLSCheckReadPremissionLotProduct(){
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Lot_Product__c',new Set<String>{'Name','sigmaerpdev__Location__c','sigmaerpdev__Quantity__c'})){
            return true;
        }  
        return false;
    }
    
    /* ------------------------------------------------------------
Author  :  Vikas .
Company :  Mindlinks .
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  : Lot Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-11-2016  Vikas               Its checks the Object FLS & CRUD permission of passed object and field. 
------------------------------------------------------------ */
    
   /* public Static boolean FLSCheckLotProduct(){
        if(CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Lot_Product__c',new Set<String>{'sigmaerpdev__Quantity__c','sigmaerpdev__Product__c','sigmaerpdev__Location__c','sigmaerpdev__Lot__c','sigmaerpdev__Quantity__c'})){
            return true;
        }  
        return false;
    }
    
    /* ------------------------------------------------------------
Author  :  Vikas .
Company :  Mindlinks .
Description : Get the  Object and field FLS & CRUD permission which is passed.

Inputs  : Lot Object and its fields.
Returns : Boolean flag-  It returns True or False.

History
<Date>      <Authors Name>     <Brief Description of Change>
24-11-2016  Vikas               Its checks the Object FLS & CRUD permission of passed object and field. 
------------------------------------------------------------ */
    
  /*  public Static boolean FLSCheckReadPermissionPackageProduct(){
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'Id','Name','sigmaerpdev__Inventory_Location_Product__c',
            'sigmaerpdev__Lot__c','sigmaerpdev__Lot__r.Id','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__c','sigmaerpdev__Quantity__c',
            'sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Products__c','sigmaerpdev__Status__c','sigmaerpdev__Auto_allocate__c'}))
        {
            return true;
        }  
        return false;
    } 
    
    @AuraEnabled 
    public static List<Product_Serial_Number__c> getSerialNumber(String ProductId, String ID){
        List<Product_Serial_Number__c> serialNumList = new List<Product_Serial_Number__c>();
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Serial_Number__c')
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'ID','sigmaerpdev__Package_Status__c','sigmaerpdev__Status__c','sigmaerpdev__Serial_Number__c','sigmaerpdev__Product_Code__c'}))
        {
            serialNumList  = [select Id, name,Package_Status__c,Status__c,Serial_Number__c  from Product_Serial_Number__c where Status__c ='Available' AND Product_Code__c =: ProductId];
        }
        
        return   serialNumList;
        
    }
    @AuraEnabled 
    public static List<Product_Serial_Number__c> getSerialNumberOnLotOnProd(String ProductId,String LotId, String ID){
        List<Product_Serial_Number__c> serialNumList1 = new List<Product_Serial_Number__c>();
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Serial_Number__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'ID','sigmaerpdev__Package_Status__c','sigmaerpdev__Status__c','sigmaerpdev__Serial_Number__c','sigmaerpdev__Product_Code__c'}))
        {
            serialNumList1 = [select Id, name,Package_Status__c,Status__c,Serial_Number__c  from Product_Serial_Number__c where Status__c ='Available' AND Product_Code__c =: ProductId and Lot__c=:LotId];
        }
        
        return   serialNumList1;
        
    }
    
    @TestVisible
    private class Attach 
    {   
        @AuraEnabled
        public Integer ilpAvailQuantity;
        
        @AuraEnabled
        public Date lotExpiryDate;
        
        @AuraEnabled
        public Id lotId;
        
        @AuraEnabled
        public Id ilpId;
        
        @AuraEnabled
        public Integer selQuantity;
        
        @AuraEnabled
        public Id locationId;
        
        @AuraEnabled
        public Id ilpliId;
        
        @AuraEnabled 
        public String srNumName;
        
        @AuraEnabled 
        public Id srNumId;
        
        
        public Attach(Integer ilpAvailQuantity,Date lotExpiryDate,Id lotId,Id ilpId,Integer selQuantity,Id locationId,Id ilpliId,String srNumName,Id srNumId)
        {
            
            this.ilpAvailQuantity = ilpAvailQuantity;
            this.lotExpiryDate = lotExpiryDate;
            this.lotId = lotId;
            this.ilpId = ilpId;
            this.selQuantity = selQuantity;
            this.locationId = locationId;
            this.ilpliId = ilpliId;
            this.srNumName = srNumName;
            this.srNumId = srNumId;
            
        }
    }
    
    @TestVisible
    private class Data 
    {
        @AuraEnabled
        public Id prodId;
        
        @AuraEnabled
        public String prodName;
        
        @AuraEnabled
        public Integer recvQnt;
        
        @AuraEnabled
        public Id transId;
        
        @AuraEnabled
        public Id transItemId; 
        
        @AuraEnabled
        public String status;
        
        @AuraEnabled
        public list<Attach> wrapProdList;
        
        public Data(Id prodId,String prodName,Integer recvQnt,Id transId,Id transItemId,String status, list<Attach> wrapProdList)
        {   
            this.prodId = prodId;
            this.prodName = prodName;
            this.recvQnt = recvQnt;
            this.transId = transId;
            this.transItemId = transItemId;
            this.status = status;
            this.wrapProdList = wrapProdList;
        }
    }
    @AuraEnabled
    public static Inventory__c getInventoryId(Id prodId){
        Inventory__c invId;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new Set<String>{'Id','Name','sigmaerpdev__Available_Qty__c','sigmaerpdev__ProductCode__r.name'}))
        {
            if(!test.isrunningtest()){
                invId=[select id,name,ProductCode__r.name,Available_Qty__c from Inventory__c where ProductCode__c=:prodId];
                return invId;
            }
            else{
                invId=[select id,name,ProductCode__r.name,Available_Qty__c from Inventory__c where ProductCode__c=:prodId Limit 1];
                return invId;
            }
        }
        return invId;
        
    }
    
    @AuraEnabled
    public static String getDebutUrl(){
        return URL.getSalesforceBaseUrl().toExternalForm();
    }
    //added for new flow of Package - Autopick or Manual - added on 5/12/2017
    //ends here
    
    //new wrapper classes for Auto Pick Concept in Packaging - added on 6/12/2017
    //main wrapper
    public class MainWrapper{
        @AuraEnabled
        public String transId{get;set;}
        @AuraEnabled
        public String transName{get;set;}
        @AuraEnabled
        public List<lineItemsWrapper> lineItemsList{get;set;}
        @AuraEnabled
        public String status{get;set;}  
    }
    
    //line items wrapper
    public class lineItemsWrapper{  
        @AuraEnabled            
        public String prodName{get;set;}
        @AuraEnabled            
        public String prodId{get;set;} 
        @AuraEnabled            
        public String transLineItemId{get;set;} 
        @AuraEnabled 
        public String shipQty{get;set;} 
        @AuraEnabled  
        
        public String shipAdd{get;set;} 
        @AuraEnabled  
        
        public Decimal allocatedQnty{get;set;} //allocated quantity during allocation
        @AuraEnabled
        public Decimal orderedQnt{get;set;}   
        @AuraEnabled
        public Boolean isSelected{get;set;}   
        @AuraEnabled
        public PackagedProducts__c packProd{get;set;}
        @AuraEnabled         
        //public ProductWrapper prodwrap{get; set;}   
        public List<ProductWrapper> prodwrap{get;set;}
    }   */
    
    //ends here
    
  /*  @AuraEnabled                                                                                     
    public static List<newPackageControllerLtng.lineItemsWrapper> getPackageProductsForAutoPickOrManual(String orderId)
    {                
        List<lineItemsWrapper> lineItemsWrapperList = new List<lineItemsWrapper>();
        
    
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sales_Order_Allocation_Line_Item__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'Id','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Shipping_Code__c','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Id','sigmaerpdev__Allocation_Done__c','sigmaerpdev__Allocated_Quantity__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Quantity__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Shipping_Address__c','sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c','sigmaerpdev__PartialPackQuantCompare__c','sigmaerpdev__Order_Status__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'id','name','sigmaerpdev__Product__c','sigmaerpdev__Available_Quantity__c','sigmaerpdev__Expiry_Date__c','sigmaerpdev__Lot__r.Name','sigmaerpdev__Lot__r.Id','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Name','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Id','sigmaerpdev__Inventory_Location_Product__r.Id','sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Product_Serial_Number__r.Name','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Serial_Number__c','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Status__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sales_Order_Allocation_Line_Item__c',new Set<String>{'Id','name','sigmaerpdev__Order_Line__c','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Product_Serial_Number__r.Name','sigmaerpdev__Inventory_Location_Product_Line_Item__c','sigmaerpdev__Location_Name__c','sigmaerpdev__Order_Line__r.sigmaerpdev__Product__c','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Lot__r.sigmaerpdev__Expiry_Date__c','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.name','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Lot__r.Name','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Name','sigmaerpdev__Allocated_Quantity__c','sigmaerpdev__Order_Line__r.sigmaerpdev__Sigma_Order__c','sigmaerpdev__Package_Status__c','sigmaerpdev__Order_Line__r.sigmaerpdev__Sigma_Order__c' ,'sigmaerpdev__Package_Status__c' })
        &&CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'id','name','sigmaerpdev__Attribute_Type__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'sigmaerpdev__Product_Order__c','sigmaerpdev__Auto_allocate__c'})
        )
        {
            List<Product_Order_Price_Book__c> OrderLineList;     
            
            List<ProductWrapper> wrapProdListManual = new List<ProductWrapper>(); //full ilpli List for Manual flow
            Map<Id,Id> lineItemsProductsMap = new Map<Id,Id>(); //used to store transLineItemid and its ProductId
            Map<Id,Id> transLineItemsProduct = new Map<Id,Id>(); //used to store ProductId and its transLineItemid
            Map<Id,Id> lineItemsAllocationMap = new Map<Id,Id>(); //used to store transLineItemid and its soali ID
            Map<Id,Id> lineItemsManualMap = new Map<Id,Id>(); //used to store transLineItemid and its Manual ILPLI id
            Map<Id,Decimal> prodMap = new Map<Id,Decimal>();
            
            Map<Id,List<ProductWrapper>> allocationMapLineItems = new Map<Id,List<ProductWrapper>>(); //used to store transline items and its allocation list
            
            try{
                OrderLineList = [Select Id,Sigma_Order__r.Shipping_Code__c,Product__c,Product__r.Id,Allocation_Done__c,Allocated_Quantity__c,Product__r.Name,Quantity__c,Sigma_Order__c,Sigma_Order__r.Shipping_Address__c,Product__r.Attribute_Type__c From Product_Order_Price_Book__c where Sigma_Order__c = :orderId and (Order_Status__c = 'Packaged' or Order_Status__c = 'Order Confirmed' or Order_Status__c = 'Delivered') and PartialPackQuantCompare__c = 'true' and Quantity__c != 0];
                
                for(Product_Order_Price_Book__c tdiList : OrderLineList){
                    lineItemsProductsMap.put(tdiList.Id,tdiList.Product__r.Id);
                    transLineItemsProduct.put(tdiList.Product__r.Id,tdiList.Id);
                    prodMap.put(tdiList.Product__r.Id, tdiList.Quantity__c);
                }
                
                Id ProdId;
                String prodName; 
                String status;
                String prodAttrType;
                String prodBomType;
                
                Map<Id,List<Inventory_Location_Product_Line_Item__c>> prodILPLIListNewMap = new Map<Id,List<Inventory_Location_Product_Line_Item__c>>();
                List<Inventory_Location_Product_Line_Item__c> newIlpliList = [select id,name,Product__c,Available_Quantity__c,Expiry_Date__c,Lot__r.Name,Lot__r.Id,Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name,Inventory_Location_Product__r.Inventory_Location__r.Location__r.Id,Inventory_Location_Product__r.Id,Product_Serial_Number__c,Product_Serial_Number__r.Name,Product_Serial_Number__r.Serial_Number__c from Inventory_Location_Product_Line_Item__c where Available_Quantity__c > 0 and Product_Serial_Number__r.Status__c != 'Used' and Product__c in :prodMap.keySet()];
                for(Inventory_Location_Product_Line_Item__c ilpli1 : newIlpliList){
                    if(prodILPLIListNewMap.containsKey(ilpli1.Product__c)){
                        List<Inventory_Location_Product_Line_Item__c> showILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                        showILPLI = prodILPLIListNewMap.get(ilpli1.Product__c);
                        showILPLI.add(ilpli1);
                        prodILPLIListNewMap.put(ilpli1.Product__c,showILPLI);        
                    }else{
                        List<Inventory_Location_Product_Line_Item__c> showILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                        showILPLI.add(ilpli1);
                        prodILPLIListNewMap.put(ilpli1.Product__c,showILPLI);          
                    }
                }
                //ends here
                
                //fetch products full ilpli list for manual selection. - added on 27/11/2017
                
                List<Product2> products=new List<Product2>();
                products=[select id,name,Attribute_Type__c from Product2 where id in : prodMap.keySet()];       
                for(Product2 prd :products)
                {       
                    List<innerWrapper> innerWrapperList = new List<innerWrapper>();                    
                    
                    if(transLineItemsProduct.containsKey(prd.id)){              
                        
                        prodId = prd.id;
                        prodName = prd.name;
                        prodAttrType = prd.Attribute_Type__c;
                        
                        for(Inventory_Location_Product_Line_Item__c ilpli : prodILPLIListNewMap.get(prd.id)){                 
                            
                            innerWrapper iwrap = new innerWrapper(null,null,null,null,null,null,null,null,null,null,null,null,null);    
                            iwrap.selQuantity = null;
                            if(ilpli.Lot__r.Name == null){
                                iwrap.lotName = 'Not Available';  
                            }else{
                                iwrap.lotName = ilpli.Lot__r.Name;  
                            }
                            iwrap.lotExpiryDate = ilpli.Expiry_Date__c;
                            iwrap.ilpName = ilpli.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name;
                            iwrap.ilpAvailQuantity = ilpli.Available_Quantity__c;                    
                            iwrap.lotId = ilpli.Lot__r.Id;
                            iwrap.ilpId = ilpli.Inventory_Location_Product__r.Id; 
                            iwrap.ilpliId = ilpli.Id;
                            iwrap.locationId = ilpli.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Id;
                            iwrap.srNumId = ilpli.Product_Serial_Number__c;
                            
                            if(ilpli.Product_Serial_Number__r.Name == null){
                                iwrap.srNumName = 'Not Available';  
                            }else{
                                
                                //added on 19/12/2017 to show Serial code instead of PSN Auto number
                                iwrap.srNumName = ilpli.Product_Serial_Number__r.Serial_Number__c;
                            }
                            iwrap.ppId = null;
                            iwrap.ppliId = null;
                            //add only Serial Numbers which are not null
                            innerWrapperList.add(iwrap);
                        }
                        wrapProdListManual.add(new ProductWrapper(orderId,null,transLineItemsProduct.get(prd.id),ProdId,prodName,prodMap.get(prd.id),null,prodAttrType,null,false,false,innerWrapperList));
                        lineItemsManualMap.put(transLineItemsProduct.get(prd.id), prd.Id);
                    }                                          
                } 
                
                //ends here
                
                //ProductWrapper(Id transId, String transName, Id transItemId,Id ProdId, String ProdName, Decimal orderedQnt,String status, String prodAttributeType, List<innerWrapper> wrapProdList)
                //fetch allocated stock from soali object        
                List<Sales_Order_Allocation_Line_Item__c> allocObj = new List<Sales_Order_Allocation_Line_Item__c>();
                
                allocObj =  [select Id,name,Order_Line__c,Inventory_Location_Product_Line_Item__r.Product_Serial_Number__c,Inventory_Location_Product_Line_Item__r.Product_Serial_Number__r.Name,Inventory_Location_Product_Line_Item__c,Location_Name__c,Order_Line__r.Product__c,Inventory_Location_Product_Line_Item__r.Lot__r.Expiry_Date__c,Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.name,Inventory_Location_Product_Line_Item__r.Lot__r.Name,Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name,Allocated_Quantity__c,Order_Line__r.Sigma_Order__c,Package_Status__c from Sales_Order_Allocation_Line_Item__c where Order_Line__r.Sigma_Order__c =: orderId AND Package_Status__c != true];
                for(Sales_Order_Allocation_Line_Item__c soali : allocObj){
                    List<ProductWrapper> wrapProdListAllocated = new List<ProductWrapper>(); //full ilpli List for allocated flow
                    List<innerWrapper> innerWrapperList = new List<innerWrapper>(); 
                    Id transLineIds = soali.Order_Line__c;      
                    if(lineItemsProductsMap.containsKey(transLineIds)){ //if allocation is done for this trans Line item
                        innerWrapper iwrap = new innerWrapper(null,null,null,null,null,null,null,null,null,null,null,null,null);                        
                        iwrap.lotName = soali.Inventory_Location_Product_Line_Item__r.Lot__r.Name;
                        iwrap.lotExpiryDate = soali.Inventory_Location_Product_Line_Item__r.Lot__r.Expiry_Date__c;
                        iwrap.ilpAvailQuantity = null;                    
                        iwrap.lotId = soali.Inventory_Location_Product_Line_Item__r.Lot__r.Id;
                        iwrap.ilpId = soali.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Id; 
                        iwrap.ilpliId = soali.Inventory_Location_Product_Line_Item__c;               
                        iwrap.locationId = soali.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Id;
                        iwrap.srNumId = soali.Inventory_Location_Product_Line_Item__r.Product_Serial_Number__c;
                        iwrap.srNumName = soali.Inventory_Location_Product_Line_Item__r.Product_Serial_Number__r.Name;
                        iwrap.selQuantity = soali.Allocated_Quantity__c;
                        iwrap.ppId = null;
                        iwrap.ppliId = null;
                        innerWrapperList.add(iwrap);
                        lineItemsAllocationMap.put(transLineIds, soali.Id);
                        
                        if(allocationMapLineItems.containsKey(transLineIds)){
                            List<ProductWrapper> interimList = allocationMapLineItems.get(transLineIds);
                            interimList.add(new ProductWrapper(orderId,null,transLineIds,lineItemsProductsMap.get(transLineIds),null, null,null,null,null,false,false,innerWrapperList));                   
                            allocationMapLineItems.put(transLineIds,interimList);    
                        }else{
                            List<ProductWrapper> newList = new List<ProductWrapper>();
                            newList.add(new ProductWrapper(orderId,null,transLineIds,lineItemsProductsMap.get(transLineIds),null, null,null,null,null,false,false,innerWrapperList));
                            allocationMapLineItems.put(transLineIds,newList);  
                        }
                        
                    }
                    
                }
                //ends here             
                
                for(Product_Order_Price_Book__c tdi : OrderLineList){
                    System.debug('tdi.Id=='+tdi.Id);
                    lineItemsWrapper lineItems = new lineItemsWrapper();
                    lineItems.packProd =  new PackagedProducts__c();
                    lineItems.prodName = tdi.Product__r.Name;
                    lineItems.prodId = tdi.Product__r.Id;
                    lineItems.transLineItemId = tdi.Id;         
                    lineItems.orderedQnt = tdi.Quantity__c;          
                    
                    //changed on 4/12/2017 - these values will be filled up from lightning component
                    lineItems.packProd.Product_Order__c = tdi.Id;
                    lineItems.packProd.Auto_allocate__c = false;
                    lineItems.allocatedQnty = 0;
                    lineItems.shipQty = tdi.Sigma_Order__r.Shipping_Code__c;
                    lineItems.shipAdd = tdi.Sigma_Order__r.Shipping_Address__c;
                    lineItems.isSelected = false;
                    
                    List<ProductWrapper> wrapProdListEmpty = new List<ProductWrapper>(); //add empty list to prodWrap
                    lineItems.prodwrap = wrapProdListEmpty;
                    lineItemsWrapperList.add(lineItems);
                } 
                System.debug('lineItemsWrapperList===>'+lineItemsWrapperList);        
            }catch(Exception e){            
                
                return null;
            }
        }
        return lineItemsWrapperList;        
    }*/
    //ends here
    // new combined code for stand and cust order object start 
    /*    @AuraEnabled 
    public static Package__c saveAutoPickorManualPackage(Package__c packageObj,String packageProducts)
    {     
        if( CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package_Product_Line_Item__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Lot_Product__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Serial_Number__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Lot__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
        && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new set<String>{'id','sigmaerpdev__Via_Autopick__c','sigmaerpdev__Auto_allocate__c','sigmaerpdev__Product_Order__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Product__c','sigmaerpdev__Status__c','sigmaerpdev__Package__c','sigmaerpdev__Quantity__c','sigmaerpdev__Lot__c','sigmaerpdev__Location__c','sigmaerpdev__Order__c','sigmaerpdev__Order_Product__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__PackagedProducts__c',new set<String>{'sigmaerpdev__Via_Autopick__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Order__c','sigmaerpdev__Product__c','sigmaerpdev__Product_Order__c','sigmaerpdev__Order_Product__c','sigmaerpdev__Status__c','sigmaerpdev__Package__c','sigmaerpdev__Quantity__c','sigmaerpdev__Lot__c','sigmaerpdev__Location__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package_Product_Line_Item__c',new Set<String>{'Id','Name','sigmaerpdev__Lot__c','sigmaerpdev__Expiry_Date__c','sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__Location__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__c','sigmaerpdev__Quantity__c','sigmaerpdev__Rental_Reserved_Quantity__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Products__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Products__r.sigmaerpdev__Attribute_Type__c','sigmaerpdev__Status__c','sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Product_Serial_Number__r.Name','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Serial_Number__c','sigmaerpdev__Packaged_Product__c','sigmaerpdev__Inventory_Location_Product_Line_Item__c','sigmaerpdev__Packaged_Product__r.sigmaerpdev__Via_Autopick__c','sigmaerpdev__Packaged_Product__r.sigmaerpdev__Sigma_Order__r.RecordType.Name'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Package_Product_Line_Item__c',new set<String>{'sigmaerpdev__Status__c','sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Expiry_Date__c','sigmaerpdev__Lot__c','sigmaerpdev__Quantity__c','sigmaerpdev__Location__c','sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__Inventory_Location_Product_Line_Item__c'})
        && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Package_Product_Line_Item__c',new set<String>{'sigmaerpdev__Packaged_Product__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new Set<String>{'id','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Product_Order__c','sigmaerpdev__Quantity__c','sigmaerpdev__Status__c','sigmaerpdev__Package__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'Id','Name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__PartialPackQuantCompare__c','sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Remaining_Qty_To_Package__c','sigmaerpdev__Quantity__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new Set<String>{'Id','Name','sigmaerpdev__Fully_Packaged__c','RecordTypeId','RecordType.Name'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sigma_Order__c',new Set<String>{'sigmaerpdev__Fully_Packaged__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'Id','Name','sigmaerpdev__Products__c','sigmaerpdev__Inventory_Location_Name__c','sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Rental_Delivered_Quantity__c','sigmaerpdev__Rental_Adjustment_Quantity__c','sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Rental_Delivered_Quantity__c','sigmaerpdev__Rental_Adjustment_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'Id','Name','sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__Reserved_Quantity__c','sigmaerpdev__Rental_Adjustment_Quantity__c','sigmaerpdev__Rental_Reserved_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'sigmaerpdev__Reserved_Quantity__c','sigmaerpdev__Rental_Adjustment_Quantity__c','sigmaerpdev__Rental_Reserved_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Lot__c',new Set<String>{'Id','Name','sigmaerpdev__Product__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Lot_Product__c',new Set<String>{'Id','Name','sigmaerpdev__Location__c','sigmaerpdev__Quantity__c','sigmaerpdev__Lot__c','sigmaerpdev__Product__c','sigmaerpdev__Location__r.sigmaerpdev__Location__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Lot_Product__c',new Set<String>{'sigmaerpdev__Quantity__c','sigmaerpdev__Product__c','sigmaerpdev__Location__c','sigmaerpdev__Lot__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'Id','sigmaerpdev__Package_Status__c','sigmaerpdev__Status__c','sigmaerpdev__Serial_Number__c','sigmaerpdev__Quantity__c','sigmaerpdev__Order_Product__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'sigmaerpdev__Package_Status__c','sigmaerpdev__Status__c','sigmaerpdev__Serial_Number__c','sigmaerpdev__Quantity__c','sigmaerpdev__Order_Line__c','sigmaerpdev__Order_Product__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new Set<String>{'Id','Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c'})
        //&& CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Order_Usage__c',new Set<String>{})
        && Schema.sObjectType.sigmaerpdev__Sigma_Order__c.fields.Id.isAccessible()
        && Schema.sObjectType.sigmaerpdev__Product_Serial_Number__c.fields.Id.isAccessible()
        && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new Set<String>{'Id','OrderId','sigmaerpdev__PartialPackQuantCompare__c','sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Remaining_Qty_To_Package__c','Quantity'})
        && CRUD_FLS_CheckUtility.checkFLS('OrderItem',new Set<String>{'sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Remaining_Qty_To_Package__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('Order',new Set<String>{'Id','name','sigmaerpdev__Fully_Packaged__c'})
        && CRUD_FLS_CheckUtility.checkFLS('Order',new Set<String>{'sigmaerpdev__Fully_Packaged__c'})
        ) 
        {
            system.debug('inside fls'+packageProducts);
            try{   
                system.debug('inside packageObj'+packageObj);
                insert packageObj; //insert package header
                system.debug('inside packageObj'+packageObj);
                Map<Id,Decimal> transIdAndPackagedQty = new Map<Id,Decimal>(); 
                List<Id> productsList = new List<Id>(); 
                List<Id> productsidLists = new List<Id>(); 
                List<newPackageControllerLtng.MainWrapper> container = (List<newPackageControllerLtng.MainWrapper>)System.JSON.deserialize(packageProducts,List<newPackageControllerLtng.MainWrapper>.class);                
                system.debug('inside container'+container);
                List<ProductWrapper> AllData = new List<ProductWrapper>();
                String transPackStatus = '';
                String transId = '';
                Decimal allocatedOrPackageQnty = 0;
                Boolean isSelectedForPackage = false;
                Map<id,id> serialno=new Map<id,id>(); 
                
                sigmaerpdev__Order_Usage__c OrderTypeusage= new sigmaerpdev__Order_Usage__c();
                OrderTypeusage= [select Id, Name,sigmaerpdev__Sigma_order__c,sigmaerpdev__Standard_object__c from sigmaerpdev__Order_Usage__c limit 1];
                System.debug('OrderTypeusage>>>>'+OrderTypeusage); 
                
                for(newPackageControllerLtng.MainWrapper temp :container){          
                    transPackStatus = temp.status;
                    transId = temp.transId;
                    
                    for(lineItemsWrapper liwrap : temp.lineItemsList)
                    {
                        if(liwrap.isSelected)
                        {//add the product to package products only if isSelected is checked ()i.e. from UI checkbox during Packaging)
                            
                            isSelectedForPackage = liwrap.isSelected;
                            allocatedOrPackageQnty = liwrap.allocatedQnty;      
                            Boolean viaAutopick = liwrap.packProd.Auto_allocate__c;                  
                            for(ProductWrapper p1 : liwrap.prodwrap)
                            {
                                List<innerWrapper> innerListData = new List<innerWrapper>();
                                
                                for(innerWrapper temp1 : p1.wrapProdList)
                                {
                                    if(temp1.selQuantity != null && temp1.selQuantity != 0){
                                        if(OrderTypeusage.sigmaerpdev__Standard_object__c == true)
                                        {
                                             serialno.put(temp1.srNumId,liwrap.packProd.sigmaerpdev__Order_Product__c);
                                        }
                                        else 
                                        {
                                            serialno.put(temp1.srNumId,liwrap.packProd.sigmaerpdev__Product_Order__c);
                                        }
                                        innerListData.add(new innerWrapper(temp1.selQuantity,temp1.srNumId,temp1.lotName,temp1.lotExpiryDate,temp1.ilpName,temp1.ilpAvailQuantity,temp1.lotId,temp1.ilpId,temp1.ilpliId,temp1.locationId,temp1.srNumName,temp1.ppId,temp1.ppliId));
                                     }
                                    system.debug('serialno::'+serialno);
                                }
                                AllData.add(new ProductWrapper(transId,p1.transName,p1.transItemId,p1.prodId,p1.prodName,p1.recvQnt,transPackStatus,p1.prodAttributeType,allocatedOrPackageQnty,viaAutopick,isSelectedForPackage,innerListData));
                                productsList.add(p1.prodId);
                                system.debug('AllData::'+AllData);
                                system.debug('productsList::'+productsList);
                            }
                        }                   
                    }
                }
                //ends here 
                List<PackagedProducts__c> packProdList = new List<PackagedProducts__c>();
                Set<ID> packProdIDList = new Set<ID>();
                Map<Id,List<Package_Product_Line_Item__c>> PPLIMap = new Map<Id,List<Package_Product_Line_Item__c>>(); 
                Set<ID> packageProductIds = new Set<ID>(); //used to store the packaging product Ids
                for(ProductWrapper temp :AllData)
                {
                    List<Package_Product_Line_Item__c> PPLIList = new List<Package_Product_Line_Item__c>();
                    
                    packageProductIds.add(temp.prodId);
                    PackagedProducts__c tempPackProdObje = new PackagedProducts__c();
                    List<innerWrapper> innerData = temp.wrapProdList;
                    
                    for(innerWrapper PLIL :innerData)
                    {
                        Package_Product_Line_Item__c PPLI = new Package_Product_Line_Item__c();
                        PPLI.Inventory_Location_Product__c = PLIL.ilpId;
                        PPLI.Location__c = PLIL.locationId;
                        PPLI.Quantity__c = PLIL.selQuantity;
                        PPLI.Lot__c = PLIL.lotId;
                        PPLI.Inventory_Location_Product_Line_Item__c = PLIL.ilpliId;
                        PPLI.Expiry_Date__c = PLIL.lotExpiryDate;
                        PPLI.Product_Serial_Number__c = PLIL.srNumId;
                        PPLIList.add(PPLI);
                        
                        if(PPLIMap.ContainsKey(temp.transItemId))
                        {
                            List<Package_Product_Line_Item__c> interimList = PPLIMap.get(temp.transItemId);
                            interimList.add(PPLI);
                            PPLIMap.put(temp.transItemId,interimList);
                        }else
                        {
                            List<Package_Product_Line_Item__c> newList = new List<Package_Product_Line_Item__c>();
                            newList.add(PPLI);
                            PPLIMap.put(temp.transItemId,newList);
                        }
                        //ends here
                    }
                    
                    tempPackProdObje.Product__c = temp.prodId;                       
                    tempPackProdObje.Quantity__c = temp.allocatedOrPackageQnty;  //changed on 23-11-2017          
                    tempPackProdObje.Via_Autopick__c = temp.allocatedViaAutopickOrManual;  //changed on 23-11-2017  
                    if(OrderTypeusage.sigmaerpdev__Standard_object__c == true)
                    {
                        tempPackProdObje.Order__c = temp.transId;
                        tempPackProdObje.Order_Product__c = temp.transItemId;
                    }
                    else{
                        tempPackProdObje.Sigma_Order__c = temp.transId;
                        tempPackProdObje.Product_Order__c = temp.transItemId;
                    }
                    tempPackProdObje.Status__c = temp.status; //added for status
                    tempPackProdObje.Package__c = packageObj.Id;
                    for(innerWrapper PPrd :innerData)
                    {
                        tempPackProdObje.Lot__c= PPrd.lotId;
                        tempPackProdObje.Location__c= PPrd.locationId;
                    }
                    PackProdList.add(tempPackProdObje);
                    system.debug('tempPackProdObje::'+tempPackProdObje);
                    }
                //code to fix the issue - multiple package products for the same product if its quantity was more than 1
                Set<PackagedProducts__c> finalSet = new Set<PackagedProducts__c>();
                List<PackagedProducts__c> result = PackProdList;
                finalSet.addAll(result);
                result.clear();
                PackProdList.clear();
                result.addAll(finalSet);
                PackProdList = result;
                //ends here
                insert PackProdList;
                system.debug('PackProdList::'+PackProdList);
                
                //Rental order flow to update in ilp for rental deliverd qty
                List<Id> SOids = new List<Id>();
                for(PackagedProducts__c templistids :PackProdList)
                {
                    SOids.add(templistids.Sigma_Order__c);
                }
                List<Sigma_Order__c> interimorder = new List<Sigma_Order__c>();
                interimorder = [select id,RecordTypeId,RecordType.Name from sigmaerpdev__Sigma_Order__c where id in :SOids];
                
                List<Package_Product_Line_Item__c> PPLIInsertList = new List<Package_Product_Line_Item__c> ();  
                for(PackagedProducts__c var :PackProdList)
                {
                    packProdIDList.add(var.Product__c);
                    if(OrderTypeusage.sigmaerpdev__Standard_object__c == true)
                    {
                        if(PPLIMap.containsKey(var.Order_Product__c))
                        {
                            List<Package_Product_Line_Item__c> tempPPLIList = PPLIMap.get(var.Order_Product__c);
                             for(Package_Product_Line_Item__c var1 :tempPPLIList)
                            {  
                                var1.Packaged_Product__c =  var.Id;
                                var1.Status__c = var.Status__c;
                                PPLIInsertList.add(var1);                    
                            }
                        }
                    }
                    else
                    {
                        if(PPLIMap.containsKey(var.Product_Order__c))
                        {
                            List<Package_Product_Line_Item__c> tempPPLIList = PPLIMap.get(var.Product_Order__c);
                            for(Package_Product_Line_Item__c var1 :tempPPLIList)
                            {        
                                var1.Packaged_Product__c =  var.Id;
                                var1.Status__c = var.Status__c;
                                PPLIInsertList.add(var1);                    
                            }
                        }
                    }
                    
                }        
                insert PPLIInsertList;
                system.debug('PPLIInsertList:'+PPLIInsertList);
                //added on 27/12/2017 to update packaged qty and remaining qty on order line items to provide partial packaging
                Set<Id> transactionIdList = new Set<Id>();
                List<PackagedProducts__c> packageProdList1;
               
                if(OrderTypeusage.sigmaerpdev__Standard_object__c == true)
                {
                    packageProdList1 = [select id,Order__c,Order_Product__c,Quantity__c from 
                    PackagedProducts__c where Package__c = :packageObj.Id
                    and Status__c = 'Ready'];
                    for(PackagedProducts__c ppListIterate : packageProdList1)
                    {
                        transIdAndPackagedQty.put(ppListIterate.Order_Product__c,ppListIterate.Quantity__c);
                        transactionIdList.add(ppListIterate.Order__c);
                    }       
                    if(transIdAndPackagedQty.size() > 0){
                        List<OrderItem> transLineItemsList;  
                        List<OrderItem> transLineObjList = new List<OrderItem>();
                        
                        transLineItemsList = [Select Id,Packaged_Quantity__c,Remaining_Qty_To_Package__c,Quantity From OrderItem where Id IN :transIdAndPackagedQty.keySet()];
                        for(OrderItem tdi : transLineItemsList)
                        {
                            OrderItem tdiObj = new OrderItem(); 
                            //code altered by chandana for null values 
                            if(tdi.Packaged_Quantity__c == 0 || tdi.Packaged_Quantity__c == null){
                                tdiObj.Packaged_Quantity__c = transIdAndPackagedQty.get(tdi.Id);  
                            }
                            else{
                                if(tdi.Packaged_Quantity__c != null){
                                    tdiObj.Packaged_Quantity__c = tdi.Packaged_Quantity__c  + transIdAndPackagedQty.get(tdi.Id);  
                                    
                                }                    
                            }
                            if(tdi.Packaged_Quantity__c != null ){
                                tdiObj.Remaining_Qty_To_Package__c = tdi.Quantity - tdiObj.Packaged_Quantity__c;   
                            }                
                            tdiObj.Id = tdi.Id;
                            transLineObjList.add(tdiObj);                
                        }
                        
                        update transLineObjList; //update trans line item list
                        //new code added to check if any order line items are partially packaged and accordingly set the packageDone flag to true or false
                        List<Id> transIdListNew = new List<Id>(transactionIdList);
                        List<Order>  newTransFinalList = new List<Order>();            
                        Map<Id,Boolean> packagedTransMap = new Map<Id,Boolean>();
                        newTransFinalList = [select Id,name,Fully_Packaged__c,(select id,OrderId,sigmaerpdev__PartialPackQuantCompare__c from OrderItems)from Order where Id in :transIdListNew];
                         for(Order transIdNew : newTransFinalList){
                            Boolean packageDone = true; 
                            for(OrderItem tdiChild : transIdNew.OrderItems)
                            {
                                if(tdiChild.PartialPackQuantCompare__c == 'true'){
                                    packageDone = false;
                                }
                            }
                            packagedTransMap.put(transIdNew.Id,packageDone);
                        }
                        
                        
                        //ends here         
                        //update order field - fully packaged status to true if sigma order's line items[all line items] are packaged fully
                      //commented for bulkification issue 31/10/2018

                      // List<Order> interimTransactionList = new List<Order>();
                       // interimTransactionList = [select id,Fully_Packaged__c from Order where id in :packagedTransMap.keySet()];
                        List<Order> updatingTransactionList = new List<Order>();
                        for(Order tempIterate : newTransFinalList)
                        {
                           if(packagedTransMap.get(tempIterate.id) == true)
                           {
                                Order tempTrans = new Order();
                                tempTrans.id = tempIterate.id; 
                                tempTrans.Fully_Packaged__c = true;
                                updatingTransactionList.add(tempTrans);
                            }               
                        }
                        update updatingTransactionList;
                        //ends here            
                    }
                    //ends here
                } //end of if of sigma and stand order bi-forgation 
                else
                {
                    packageProdList1 = [select id,Sigma_Order__c,Product_Order__c,Quantity__c from 
                    PackagedProducts__c where Package__c = :packageObj.Id
                    and Status__c = 'Ready'];
                
                    system.debug('packageProdList1::'+packageProdList1);
                    for(PackagedProducts__c ppListIterate : packageProdList1){
                        transIdAndPackagedQty.put(ppListIterate.Product_Order__c,ppListIterate.Quantity__c);
                        transactionIdList.add(ppListIterate.Sigma_Order__c);
                    }       
                    system.debug('transactionIdList::'+transactionIdList);
                    
                    if(transIdAndPackagedQty.size() > 0){
                        List<Product_Order_Price_Book__c> transLineItemsList;  
                        List<Product_Order_Price_Book__c> transLineObjList = new List<Product_Order_Price_Book__c>();
                        transLineItemsList = [Select Id,Name,Packaged_Quantity__c,Remaining_Qty_To_Package__c,Quantity__c From Product_Order_Price_Book__c where Id IN :transIdAndPackagedQty.keySet()];
                        for(Product_Order_Price_Book__c tdi : transLineItemsList){
                            Product_Order_Price_Book__c tdiObj = new Product_Order_Price_Book__c();                            
                            
                            //code altered by chandana for null values 
                            if(tdi.Packaged_Quantity__c == 0|| tdi.Packaged_Quantity__c == null){
                                tdiObj.Packaged_Quantity__c = transIdAndPackagedQty.get(tdi.Id);
                            }else{
                                if(tdi.Packaged_Quantity__c != null){
                                    tdiObj.Packaged_Quantity__c = tdi.Packaged_Quantity__c  + transIdAndPackagedQty.get(tdi.Id);  
                                }                    
                            }
                            
                            if(tdi.Packaged_Quantity__c != null){
                                tdiObj.Remaining_Qty_To_Package__c = tdi.Quantity__c - tdiObj.Packaged_Quantity__c;
                            }                
                            tdiObj.Id = tdi.Id;
                            transLineObjList.add(tdiObj);                
                        }
                        
                        update transLineObjList; //update trans line item list
                        system.debug('transLineObjList::'+transLineObjList); 
                        //new code added to check if any order line items are partially packaged and accordingly set the packageDone flag to true or false
                        List<Id> transIdListNew = new List<Id>(transactionIdList);
                        // chandana
                        List<Sigma_Order__c>  newTransFinalList = new List<Sigma_Order__c>();            
                        Map<Id,Boolean> packagedTransMap = new Map<Id,Boolean>();
                        newTransFinalList = [select Id,name,(select id,Sigma_Order__c,PartialPackQuantCompare__c 
                                                             from Order_Lines__r)from Sigma_Order__c where Id in :transIdListNew];
                        
                        for(Sigma_Order__c transIdNew : newTransFinalList){
                            Boolean packageDone = true; 
                            for(Product_Order_Price_Book__c tdiChild : transIdNew.Order_Lines__r){
                                if(tdiChild.PartialPackQuantCompare__c == 'true'){
                                    packageDone = false;
                                }
                            }
                            packagedTransMap.put(transIdNew.Id,packageDone);
                            system.debug('packagedTransMap::'+packagedTransMap); 
                        }
                        //ends here         
                        //update order field - fully packaged status to true if sigma order's line items[all line items] are packaged fully
                        List<Sigma_Order__c> interimTransactionList = new List<Sigma_Order__c>();
                        interimTransactionList = [select id,Fully_Packaged__c from Sigma_Order__c where id in :packagedTransMap.keySet()];
                        List<Sigma_Order__c> updatingTransactionList = new List<Sigma_Order__c>();
                        for(Sigma_Order__c tempIterate : interimTransactionList){
                            
                            if(packagedTransMap.get(tempIterate.id) == true){
                                Sigma_Order__c tempTrans = new Sigma_Order__c();
                                tempTrans.id = tempIterate.id; 
                                tempTrans.Fully_Packaged__c = true;
                                updatingTransactionList.add(tempTrans);
                            }               
                        }
                        update updatingTransactionList;
                        system.debug('updatingTransactionList::'+updatingTransactionList);
                        //ends here            
                    }
                    //ends here
                }// end of else of sigma and stand order bi-forgation 
                
                Set<Id> LocationIDSet = new Set<Id>();
                 List<Id> ILPLIIDList = new List<Id>();
                for(Package_Product_Line_Item__c pp :PPLIInsertList)
                {
                    LocationIDSet.add(pp.Location__c);
                     ILPLIIDList.add(pp.Id);  
                }
                //added on 3-10-2017 to update ILP
                List<Inventory_Location_Product__c> invProdLocList;
                List<Inventory_Location_Product__c> ILPList = new List<Inventory_Location_Product__c>();
               
                
                invProdLocList = [Select Id,Name,Products__c,Inventory_Location_Name__c,
                                  Delivered_Quantity__c,Rental_Delivered_Quantity__c From Inventory_Location_Product__c where Products__c IN:productsList and Inventory_Location__r.Location__c IN :LocationIDSet];
                //commented for bulkification issue 31/10/2018
               /* for(Package_Product_Line_Item__c pp :PPLIInsertList){            
                    ILPLIIDList.add(pp.Id);            
                }*/
       /*         system.debug('ILPLIIDList'+ILPLIIDList);
                //added to reduce ILP and ILPLI quantities during package for manual selection - added on 5/12/2017
                List<Id> packProdIdListForManual  = new List<Id>();
                for(PackagedProducts__c ppId :PackProdList){            
                    packProdIdListForManual.add(ppId.Id);            
                }
                Map<Id,Integer> ILPReduceQtyMapForManual = new Map<Id,Integer>(); //used to store ILP and the quantity to be reduced 
               
                Map<Id,Integer> ILPReduceQtyMapForrental = new Map<Id,Integer>(); 
                Map<Id,Integer> ILPLIReduceQtyMapForManual = new Map<Id,Integer>(); 
                Map<Id,Integer> ILPLIReduceQtyMapForrental = new Map<Id,Integer>(); //used to store ILP and the quantity to be reduced 
                List<Inventory_Location_Product__c> fullILPList;        
                List<Package_Product_Line_Item__c> packProdLineList1;
                List<Inventory_Location_Product_Line_Item__c> fullILPLIList;
                List<Inventory_Location_Product_Line_Item__c> ILPLIListToUpdate = new List<Inventory_Location_Product_Line_Item__c>();
                
                packProdLineList1 = [Select Id,Name,Lot__c,Expiry_Date__c,Inventory_Location_Product__c,Location__c,
                                     Inventory_Location_Product__r.Inventory_Location__c,Quantity__c,
                                     Inventory_Location_Product__r.Products__c,
                                     Inventory_Location_Product__r.Products__r.Attribute_Type__c,Status__c,
                                     Product_Serial_Number__c,Product_Serial_Number__r.Name,
                                     Product_Serial_Number__r.Serial_Number__c,Packaged_Product__c,Packaged_Product__r.sigmaerpdev__Sigma_Order__r.RecordType.Name,
                                     Inventory_Location_Product_Line_Item__c,Inventory_Location_Product_Line_Item__r.Rental_Reserved_Quantity__c From Package_Product_Line_Item__c  
                                     where Packaged_Product__r.Via_Autopick__c = false and 
                                     Packaged_Product__c IN : packProdIdListForManual];
                
                system.debug('packProdLineList1::'+packProdLineList1);
                for(Package_Product_Line_Item__c pp1 :packProdLineList1)
                {
                    
                   
                     if(pp1.Status__c=='Ready' &&pp1.Packaged_Product__r.sigmaerpdev__Sigma_Order__r.RecordType.Name == 'Rental Order')
                        {
                             if(!ILPReduceQtyMapForrental.containsKey(pp1.Inventory_Location_Product__c)){
                                    ILPReduceQtyMapForrental.put(pp1.Inventory_Location_Product__c,Integer.valueOf(pp1.Quantity__c));
                                }else{
                                    Integer qty1 = ILPReduceQtyMapForrental.get(pp1.Inventory_Location_Product__c);
                                    
                                    ILPReduceQtyMapForrental.put(pp1.Inventory_Location_Product__c,(qty1 + Integer.valueOf(pp1.Quantity__c)));
                                } 
                                ILPLIReduceQtyMapForrental.put(pp1.Inventory_Location_Product_Line_Item__c,Integer.valueOf(pp1.Quantity__c));
                        }
                        else  if(pp1.Status__c=='Ready')
                            {
                                if(!ILPReduceQtyMapForManual.containsKey(pp1.Inventory_Location_Product__c)){
                                    ILPReduceQtyMapForManual.put(pp1.Inventory_Location_Product__c,Integer.valueOf(pp1.Quantity__c));
                                }else{
                                    Integer qty1 = ILPReduceQtyMapForManual.get(pp1.Inventory_Location_Product__c);
                                    
                                    ILPReduceQtyMapForManual.put(pp1.Inventory_Location_Product__c,(qty1 + Integer.valueOf(pp1.Quantity__c)));
                                } 
                                ILPLIReduceQtyMapForManual.put(pp1.Inventory_Location_Product_Line_Item__c,Integer.valueOf(pp1.Quantity__c)); //store selected ILPLI ids and quantity
                            }  
                }
                system.debug('ILPLIReduceQtyMapForManual::'+ILPLIReduceQtyMapForManual);
                system.debug('ILPReduceQtyMapForManual::'+ILPReduceQtyMapForManual);
                fullILPList = [Select Id,Name,Products__c,Inventory_Location_Name__c, Net_Quantity__c,sigmaerpdev__Rental_Adjustment_Quantity__c,
                               Delivered_Quantity__c,Rental_Delivered_Quantity__c From Inventory_Location_Product__c where Id IN :ILPReduceQtyMapForManual.keySet() OR Id IN :ILPReduceQtyMapForrental.keySet() ];
                
                    
                for(Inventory_Location_Product__c ilp : fullILPList)
                {
                    Inventory_Location_Product__c ilpObj = new Inventory_Location_Product__c(); 
                    if(ILPReduceQtyMapForManual.containsKey(ilp.Id))
                    { 
                        ilpObj.Delivered_Quantity__c = ilp.Delivered_Quantity__c + ILPReduceQtyMapForManual.get(ilp.Id);
                        ilpObj.Id = ilp.Id;
                    }
                    if(ILPReduceQtyMapForrental.containsKey(ilp.Id))
                    {
                        ilpObj.Rental_Delivered_Quantity__c = ilp.Rental_Delivered_Quantity__c + ILPReduceQtyMapForrental.get(ilp.Id);
                        //ilpObj.sigmaerpdev__Rental_Adjustment_Quantity__c = ilp.sigmaerpdev__Rental_Adjustment_Quantity__c - ILPReduceQtyMapForrental.get(ilp.Id);
                        ilpObj.Id = ilp.Id;
                    }
                    ILPList.add(ilpObj);
                }
                update ILPList; //update ILP list
                fullILPLIList = [Select Id,Name,Inventory_Location_Product__c,Reserved_Quantity__c ,sigmaerpdev__Rental_Reserved_Quantity__c,sigmaerpdev__Rental_Adjustment_Quantity__c
                                 From Inventory_Location_Product_Line_Item__c where Id IN :ILPLIReduceQtyMapForManual.keySet() OR Id IN :ILPLIReduceQtyMapForrental.keySet()];
                
                for(Inventory_Location_Product_Line_Item__c ilpli : fullILPLIList)
                {
                    Inventory_Location_Product_Line_Item__c ilpliObj = new Inventory_Location_Product_Line_Item__c(); 
                    
                    if(ILPLIReduceQtyMapForManual.containsKey(ilpli.Id))
                    {
                        
                        ilpliObj.Reserved_Quantity__c = ilpli.Reserved_Quantity__c + ILPLIReduceQtyMapForManual.get(ilpli.Id);
                        ilpliObj.Id = ilpli.Id;
                        
                    }
                    if(ILPLIReduceQtyMapForrental.containsKey(ilpli.Id))
                    {
                        ilpliObj.Rental_Reserved_Quantity__c = ilpli.Rental_Reserved_Quantity__c + ILPLIReduceQtyMapForrental.get(ilpli.Id);
                        //ilpliObj.sigmaerpdev__Rental_Adjustment_Quantity__c = ilpli.sigmaerpdev__Rental_Adjustment_Quantity__c - ILPLIReduceQtyMapForrental.get(ilpli.Id);
                        ilpliObj.Id = ilpli.Id;
                    }
                    ILPLIListToUpdate.add(ilpliObj);
                }    
                update ILPLIListToUpdate; //update ILPLI list
                //ends here
               
                List<Package_Product_Line_Item__c> packProdLineList;
                Map<Id,Integer> ILPReduceQtyMap = new Map<Id,Integer>();
                 Map<id,Map<Id,Decimal>> LotReduceQtyMap = new Map<id,Map<Id,Decimal>>();
                
                Set<ID> AllocatePSNIDSet = new Set<ID>(); 
                Map<Id,Integer> AllocatePSNMap = new Map<Id,Integer>();
                
                if(FLSCheckReadPermissionPackageProduct() == true){
                    packProdLineList = [Select Id,Name,Lot__c,Expiry_Date__c,Inventory_Location_Product__c,Location__c,Inventory_Location_Product__r.Inventory_Location__c,Quantity__c,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Attribute_Type__c,Status__c,Product_Serial_Number__c,Product_Serial_Number__r.Name,Product_Serial_Number__r.Serial_Number__c,Packaged_Product__c,Inventory_Location_Product_Line_Item__c From Package_Product_Line_Item__c where Id IN:ILPLIIDList];
                }
                system.debug('packProdLineList:::'+packProdLineList);
                //system.debug('packProdLineList and its lot :::'+packProdLineList.sigmaerpdev__Lot__c.id);
                
                 for(Package_Product_Line_Item__c pp :packProdLineList)
                {
                    if(pp.Status__c=='Ready')
                    {
                        if(LotReduceQtyMap.containsKey(pp.Lot__c))
                        {
                            if(LotReduceQtyMap.get(pp.Lot__c).containsKey(pp.Location__c))
                            {
                                pp.Quantity__c=LotReduceQtyMap.get(pp.Lot__c).get(pp.Location__c)+pp.Quantity__c;
                                LotReduceQtyMap.get(pp.Lot__c).put(pp.Location__c,pp.Quantity__c);
                            }
                            else
                            {
                                 LotReduceQtyMap.get(pp.Lot__c).put(pp.Location__c,pp.Quantity__c);
                            }
                        }
                        else
                        {
                            Map<id,decimal> lotil= new Map<id,decimal>();
                            lotil.put(pp.Location__c,pp.Quantity__c);
                            LotReduceQtyMap.put(pp.Lot__c,lotil);
                        }
                        system.debug('LotReduceQtyMap::'+LotReduceQtyMap);
                        if(pp.Inventory_Location_Product__r.Products__r.Attribute_Type__c=='SERIALIZED')
                        {
                            AllocatePSNIDSet.add(pp.Product_Serial_Number__c);
                            if(!AllocatePSNMap.containsKey(pp.Product_Serial_Number__c))
                            {
                                AllocatePSNMap.put(pp.Product_Serial_Number__c,Integer.valueOf(pp.Quantity__c));
                            }
                        }
                    } 
                }
                //added to upsert lot product on 4-10-2017
                
                List<Lot_Product__c> lotProductsList = new List<Lot_Product__c>();
                Map<String,List<Lot_Product__c>> lotMap = new Map<String,List<Lot_Product__c>>();
                List<Lot__c> lotList;
                //List<Lot__c> lotList1;
                if(FLSCheckReadPremissionLot() == true && FLSCheckReadPremissionLotProduct() == true){      
                    //lotList = [Select Id,Name,Product__c,(Select Id,Name,Location__c,Quantity__c,Lot__c,Product__c,Location__r.Location__c From Lot_Products__r) From Lot__c where Product__c IN :packProdIDList];
                    lotList = [Select Id,Name,Product__c,(Select Id,Name,Location__c,Quantity__c,Lot__c,Product__c,Location__r.Location__c From Lot_Products__r) From Lot__c where Product__c IN :packProdIDList];
                    //lotList1 =[select  Id,Name,Product__c from Lot__c where packProdLineList.sigmaerpdev__Lot__r.Id =:lotList.sigmaerpdev__Lot__r.Id];
                    system.debug('lotList::'+lotList);
                    //system.debug('lotList1::'+lotList1);
                }   
                 for(Lot__c lt:lotList)
                {
                  if(LotReduceQtyMap.containsKey(lt.id))  
                 { 
                    for(Lot_Product__c LP:lt.Lot_Products__r)
                    {
                        if(LotReduceQtyMap.get(lt.id).containsKey(LP.Location__r.Location__c))  
                        {
                            
                            LP.Quantity__c = LP.Quantity__c - LotReduceQtyMap.get(lt.id).get(LP.Location__r.Location__c);
                            
                            lotProductsList.add(LP);
                        }
                    }
                }
                    lotMap.put(lt.Id,lt.Lot_Products__r);
                }      
                if(FLSCheckLotProduct() == true){
                    
                    update lotProductsList;
                    system.debug('lotProductsList:::'+lotProductsList);
                    
                }
                
                //code to allocate PSN
                if(AllocatePSNIDSet.size() > 0)
                {
                    List<Product_Serial_Number__c> updatePSNList = [select Id,Status__c,Serial_Number__c,Package_Status__c,Quantity__c from Product_Serial_Number__c where Status__c ='Available' and Package_Status__c=false and ID IN:AllocatePSNIDSet]; 
                   
                    if(updatePSNList.size() > 0)
                    {
                        for(Product_Serial_Number__c var :updatePSNList)
                        {
                            
                            if(AllocatePSNMap.containsKey(var.Id))
                            {
                                var.Status__c = 'Used';
                                var.Package_Status__c =True;
                                if(serialno.containsKey(var.id))
                                {
                                    var.sigmaerpdev__Order_Line__c=serialno.get(var.id);
                                }
                                
                            }
                        }
                        
                        update updatePSNList;
                        system.debug('updatePSNList1111::'+updatePSNList);
                    }
                }
                //ends here               
                //return null;
            }catch(Exception e){            
                //createErrorLog.insertError('Stapp Order Package',e.getMessage(),'Method - saveAutoPickorManualPackage',null,'',e.getStackTraceString(),UserInfo.getUserId());
                return null;
            }
        }
        return packageObj;      
    }*/
    
    // new combined code for stand and cust order object end
    //get Package Header data for Edit
  /*  @AuraEnabled
    public static Package__c editPackageforAutopickorManual(Id packageId) 
    {
        
        Package__c packge;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new Set<String>{'id','Name','sigmaerpdev__Customer__c','sigmaerpdev__Customer__r.Name','sigmaerpdev__Instructions__c','sigmaerpdev__Location__c','sigmaerpdev__Location__r.Name','sigmaerpdev__PackagedBy__c','sigmaerpdev__PackagedBy__r.Name','sigmaerpdev__PackagedDate__c','sigmaerpdev__Status__c'}))
        {
            try{            
                packge = [SELECT id,Name,Customer__c,Customer__r.Name,Instructions__c,Location__c,Location__r.Name,PackagedBy__c,PackagedBy__r.Name,PackagedDate__c,Status__c FROM Package__c where Id=:packageId];                            
                
            }catch(Exception e){            
                
                return null;
            }  
        }       
        return packge;             
    }*/
    //ends here
    
    //get data for package products during edit flow
        //get data for package products during edit flow
/*    @AuraEnabled 
    public static List<newPackageControllerLtng.MainWrapper> getPackageProductsForEditAutoPickOrManual(String packageId){    
        
        Package__c packge;
        Id transactionId;
        String transName;
        Map<Id,String> transIdAndNameMap = new Map<Id,String>(); //used to store transactions Id and its name
        Map<Id,String> transIdAndStatusMap = new Map<Id,String>(); //used to store transactions Id and its status
        Map<Id,Id> transLineIdMap = new Map<Id,Id>(); //used to store transactions line items from package products
        Map<Id,Id> transMap = new Map<Id,Id>(); //used to store transactions from package products      
        List<Product_Order_Price_Book__c> OrderLineList;             
        List<ProductWrapper> wrapProdListManual = new List<ProductWrapper>(); //full ilpli List for Manual flow
        Map<Id,Id> lineItemsProductsMap = new Map<Id,Id>(); //used to store transLineItemid and its ProductId
        List<MainWrapper> mwrapList = new List<MainWrapper>(); 
        
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package_Product_Line_Item__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new Set<String>{'id','Name'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'Id','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Id','sigmaerpdev__Sigma_Order__r.Name','sigmaerpdev__Allocation_Done__c','sigmaerpdev__Allocated_Quantity__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Quantity__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new set<String>{'Id','name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.Name','sigmaerpdev__Product__c','sigmaerpdev__Product_Order__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Status__c','sigmaerpdev__Package__c','sigmaerpdev__Quantity__c','sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c','sigmaerpdev__Product_Order__r.sigmaerpdev__Quantity__c','sigmaerpdev__Product_Order__r.sigmaerpdev__Allocation_Done__c','sigmaerpdev__Quantity__c','sigmaerpdev__Via_Autopick__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'Id','Name','sigmaerpdev__Product__c','sigmaerpdev__Available_Quantity__c','sigmaerpdev__Expiry_Date__c','sigmaerpdev__Lot__r.Name','sigmaerpdev__Lot__r.Id','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Name','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Id','sigmaerpdev__Inventory_Location_Product__r.Id','sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Product_Serial_Number__r.Name','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Serial_Number__c','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Status__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'id','Name','sigmaerpdev__Attribute_Type__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package_Product_Line_Item__c',new Set<String>{'id','sigmaerpdev__Packaged_Product__r.Id','sigmaerpdev__Quantity__c','sigmaerpdev__Lot__c','sigmaerpdev__Lot__r.Name','sigmaerpdev__Expiry_Date__c','sigmaerpdev__Location__c','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Available_Quantity__c','sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Product_Serial_Number__r.Name','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Serial_Number__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Name'})
        )               
        {     
            try{
                packge = [select id,name,(select id,Sigma_Order__c,Sigma_Order__r.Name,Product_Order__c from PackagedProducts__r) from Package__c where id =: packageId];
                
                for(PackagedProducts__c pp : packge.PackagedProducts__r){                        
                    transLineIdMap.put(pp.Product_Order__c,pp.id);
                    transMap.put(pp.Sigma_Order__c,pp.id);
                }
                
                OrderLineList = [Select Id,Product__c,Product__r.Id,Sigma_Order__r.Name,Allocation_Done__c,Allocated_Quantity__c,Product__r.Name,Quantity__c,Sigma_Order__c,Product__r.Attribute_Type__c From Product_Order_Price_Book__c where id in :transLineIdMap.keySet()];
                for(Product_Order_Price_Book__c tdiList : OrderLineList){
                    lineItemsProductsMap.put(tdiList.Id,tdiList.Product__r.Id);
                }
                
                Map<Id,Decimal> prodMap = new Map<Id,Decimal>();
                Map<Id,Id> transLineItemsProduct = new Map<Id,Id>();        
                for(Product_Order_Price_Book__c transItem : OrderLineList){            
                    prodMap.put(transItem.Product__r.Id, transItem.Quantity__c);
                    transLineItemsProduct.put(transItem.Product__r.Id,transItem.Id); //used to store transline items and its product id
                    transName = transItem.Sigma_Order__r.Name;            
                }  
                // assign data to return list to UI 
                
                //new flow for picking products and transline items - added on 25/11/2017
                //get full list from ILPLI to use in Manual selection - starts from here        
                List<ProductWrapper> wrapProdListForFastEntry = new List<ProductWrapper>(); //selected ilpli list
                List<ProductWrapper> combinedProdListForFastEntry = new List<ProductWrapper>(); //combination of both selected and non-selected ilpli list
                
                Id ProdId;
                String prodName; 
                String status;
                String prodAttrType;
                String prodBomType;
                Map<Id,ProductWrapper> prodMapWrap = new Map<Id,ProductWrapper>();
                
                //removed the inner query and querying full ilpli list to fix inner query issue returning more than 200 ilpli's for particular product
                Map<Id,List<Inventory_Location_Product_Line_Item__c>> prodILPLIListNewMap = new Map<Id,List<Inventory_Location_Product_Line_Item__c>>();
                List<Inventory_Location_Product_Line_Item__c> newIlpliList = [select id,name,Product__c,Available_Quantity__c,Expiry_Date__c,Lot__r.Name,Lot__r.Id,Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name,Inventory_Location_Product__r.Inventory_Location__r.Location__r.Id,Inventory_Location_Product__r.Id,Product_Serial_Number__c,Product_Serial_Number__r.Name,Product_Serial_Number__r.Serial_Number__c from Inventory_Location_Product_Line_Item__c where Available_Quantity__c > 0 and Product_Serial_Number__r.Status__c != 'Used' and Product__c in :prodMap.keySet()];
                for(Inventory_Location_Product_Line_Item__c ilpli1 : newIlpliList)
                {
                    if(prodILPLIListNewMap.containsKey(ilpli1.Product__c))
                    {
                        List<Inventory_Location_Product_Line_Item__c> showILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                        showILPLI = prodILPLIListNewMap.get(ilpli1.Product__c);
                        showILPLI.add(ilpli1);
                        prodILPLIListNewMap.put(ilpli1.Product__c,showILPLI);        
                    }
                    else
                    {
                        List<Inventory_Location_Product_Line_Item__c> showILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                        showILPLI.add(ilpli1);
                        prodILPLIListNewMap.put(ilpli1.Product__c,showILPLI);          
                    }
                }
                //ends here
                
                List<Product2> products=new List<Product2>();
                products=[select id,name,Attribute_Type__c from Product2 where id in : prodMap.keySet()];    
                for(Product2 prd :products)
                {     
                    ProductWrapper wrapProdListTemp;
                    List<innerWrapper> innerWrapperList = new List<innerWrapper>();                    
                    {              
                        prodId = prd.id;
                        prodName = prd.name;
                        prodAttrType = prd.Attribute_Type__c;
                        
                        for(Inventory_Location_Product_Line_Item__c ilpli : prodILPLIListNewMap.get(prd.id)){                     
                            
                            innerWrapper iwrap = new innerWrapper(null,null,null,null,null,null,null,null,null,null,null,null,null);    
                            
                            if(ilpli.Lot__r.Name == null){
                                iwrap.lotName = 'Not Available';  
                            }else{
                                iwrap.lotName = ilpli.Lot__r.Name;  
                            }
                            iwrap.lotExpiryDate = ilpli.Expiry_Date__c;
                            iwrap.ilpName = ilpli.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name;
                            iwrap.ilpAvailQuantity = ilpli.Available_Quantity__c;                    
                            iwrap.lotId = ilpli.Lot__r.Id;
                            iwrap.ilpId = ilpli.Inventory_Location_Product__r.Id; 
                            iwrap.ilpliId = ilpli.Id;
                            iwrap.locationId = ilpli.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Id;
                            iwrap.srNumId = ilpli.Product_Serial_Number__c;
                            
                            if(ilpli.Product_Serial_Number__r.Serial_Number__c == null){
                                iwrap.srNumName = 'Not Available';  
                            }else{
                                
                                //added on 19/12/2017 to show Serial code instead of PSN Auto number
                                iwrap.srNumName = ilpli.Product_Serial_Number__r.Serial_Number__c;
                            }                                            
                            iwrap.selQuantity = null;
                            iwrap.ppId = null;
                            iwrap.ppliId = null;
                            
                            innerWrapperList.add(iwrap);
                            
                        }
                        wrapProdListTemp = new ProductWrapper(transactionId,transName,transLineItemsProduct.get(prd.id),ProdId,prodName,prodMap.get(prd.id),null,prodAttrType,null,false,true,innerWrapperList);
                    }
                    prodMapWrap.put(prd.id,wrapProdListTemp);
                }
                
                //ends here
                Map<Id,List<lineItemsWrapper>> transLineListMap = new Map<Id,List<lineItemsWrapper>>(); //used to store trans and its list of line items
                Map<Id,List<PackagedProducts__c>> transLineItemPackProdsMap = new Map<Id,List<PackagedProducts__c>>(); 
                
                List<PackagedProducts__c> pprdList =  [select id,name,Sigma_Order__c,Sigma_Order__r.Name,Product_Order__c,Product__c,Product__r.Attribute_Type__c,
                                                       Status__c,Product__r.name,Product_Order__r.Quantity__c,Product_Order__r.Allocation_Done__c,
                                                       Quantity__c,Via_Autopick__c,(select id,Packaged_Product__r.Id,Quantity__c,Lot__c,Lot__r.Name,Expiry_Date__c,Location__c,
                                                                                    Inventory_Location_Product_Line_Item__r.Available_Quantity__c,Product_Serial_Number__c,Product_Serial_Number__r.Name,Product_Serial_Number__r.Serial_Number__c,Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name
                                                                                    from Package_Product_Line_Items__r) from PackagedProducts__c where Product_Order__c  in :transLineIdMap.keySet() and 
                                                       Package__c = :packageId and Status__c != 'Ready' ORDER BY Id ASC];
                for(PackagedProducts__c tdi : pprdList){
                    transIdAndNameMap.put(tdi.Sigma_Order__c,tdi.Sigma_Order__r.Name);
                    transIdAndStatusMap.put(tdi.Sigma_Order__c,tdi.Status__c);
                    if(transLineItemPackProdsMap.containsKey(tdi.Sigma_Order__c)){
                        transLineItemPackProdsMap.get(tdi.Sigma_Order__c).add(tdi);
                    }else{
                        transLineItemPackProdsMap.put(tdi.Sigma_Order__c,new List<PackagedProducts__c>{tdi});
                    }           
                }
                
                for(Id transId : transLineItemPackProdsMap.keySet()){
                    List<lineItemsWrapper> lineItemsWrapperList = new List<lineItemsWrapper>();
                    for(PackagedProducts__c pprd : transLineItemPackProdsMap.get(transId)){
                        lineItemsWrapper lineItems = new lineItemsWrapper();
                        lineItems.packProd =  new PackagedProducts__c();         
                        lineItems.prodName = pprd.Product__r.name;
                        lineItems.prodId = pprd.Product__r.Id;
                        lineItems.transLineItemId = pprd.Product_Order__c;            
                        lineItems.orderedQnt = pprd.Product_Order__r.Quantity__c;          
                        lineItems.packProd.Product_Order__c = pprd.Product_Order__c;
                        
                        //fix to avoid collision b/w Allocate during Sales order[which will update Allocate Stock to true] and during Package
                        //so now we have to use Via_Autopick__c instead of Allocation_Done__c
                        
                        lineItems.packProd.Auto_allocate__c = pprd.Via_Autopick__c;
                        lineItems.allocatedQnty = pprd.Quantity__c; 
                        lineItems.isSelected = true;
                        
                        List<innerWrapper> innerWrapperList = new List<innerWrapper>();
                        Set<id> ilpIdsSelected = new Set<id>();
                        for(Package_Product_Line_Item__c ppli : pprd.Package_Product_Line_Items__r){
                            
                            innerWrapper iwrap = new innerWrapper(null,null,null,null,null,null,null,null,null,null,null,null,null);    
                            iwrap.selQuantity = ppli.Quantity__c;
                            iwrap.lotName = ppli.Lot__r.Name;
                            iwrap.lotExpiryDate = ppli.Expiry_Date__c;
                            iwrap.ilpName = ppli.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name;
                            iwrap.ilpAvailQuantity = ppli.Inventory_Location_Product_Line_Item__r.Available_Quantity__c;                    
                            iwrap.lotId = ppli.Lot__c;
                            iwrap.ilpId = ppli.Inventory_Location_Product__r.Id; 
                            iwrap.ilpliId = ppli.Inventory_Location_Product_Line_Item__r.Id;
                            iwrap.ppId = ppli.Packaged_Product__r.Id;
                            iwrap.ppliId = ppli.Id; 
                            iwrap.srNumId = ppli.Product_Serial_Number__c;
                            //commented below line on 31/1/2018 to show code instead of name
                            
                            iwrap.srNumName = ppli.Product_Serial_Number__r.Serial_Number__c;  
                            
                            iwrap.locationId = ppli.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Id;
                            
                            innerWrapperList.add(iwrap);
                            ilpIdsSelected.add(iwrap.ilpliId); 
                        }
                        if(prodMapWrap.containsKey(pprd.Product__r.Id)){
                            List<innerWrapper> innerWrapperListOriginal = prodMapWrap.get(pprd.Product__r.Id).wrapProdList;
                            for(innerWrapper iwrp : innerWrapperListOriginal){
                                if(!ilpIdsSelected.contains(iwrp.ilpliId)){
                                    innerWrapperList.add(iwrp);
                                }
                            }
                        }
                        
                        List<ProductWrapper> pwList = new List<ProductWrapper>();
                        ProductWrapper pw = new ProductWrapper(pprd.Sigma_Order__c,pprd.Sigma_Order__r.Name,
                                                               pprd.Product_Order__c,
                                                               pprd.Product__r.Id,pprd.Product__r.name,
                                                               pprd.Product_Order__r.Quantity__c,
                                                               pprd.Status__c,pprd.Product__r.Attribute_Type__c,
                                                               pprd.Quantity__c,pprd.Via_Autopick__c,
                                                               true,innerWrapperList);
                        pwList.add(pw);                 
                        lineItems.prodwrap = pwList;
                        lineItemsWrapperList.add(lineItems);
                        
                    }
                    transLineListMap.put(transId,lineItemsWrapperList);
                }       
                
                for(Id transId : transLineListMap.keySet()){
                    MainWrapper mwrap = new MainWrapper();
                    mwrap.transId = transId;
                    mwrap.transName = transIdAndNameMap.get(transId);
                    mwrap.lineItemsList = transLineListMap.get(transId);
                    
                    mwrap.status = transIdAndStatusMap.get(transId);
                    mwrapList.add(mwrap);
                }
                
            }catch(Exception e){            
                
                return null;
            }
        }
        return mwrapList; 
    }*/
    //ends here
    
    //save autopick or manual edit flow
 /*    @AuraEnabled    
    public static Package__c saveEditedAutoPickorManualPackage(String packageObjs, String packageProducts)
    {   
        
        Map<Id,Decimal> transIdAndPackagedQty = new Map<Id,Decimal>(); 
        List<Id> productsList = new List<Id>(); //added to use while updating Inv. Location      
        Package__c packageObj=new Package__c();
        List<newPackageControllerLtng.MainWrapper> container = (List<newPackageControllerLtng.MainWrapper>)System.JSON.deserialize(packageProducts,List<newPackageControllerLtng.MainWrapper>.class);                
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package_Product_Line_Item__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Lot__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Lot_Product__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Serial_Number__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new Set<String>{'Id','sigmaerpdev__Status__c','sigmaerpdev__PackagedDate__c','sigmaerpdev__PackagedBy__c','sigmaerpdev__Instructions__c','sigmaerpdev__Location__c','sigmaerpdev__Customer__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Package__c',new Set<String>{'sigmaerpdev__Status__c','sigmaerpdev__PackagedDate__c','sigmaerpdev__PackagedBy__c','sigmaerpdev__Instructions__c','sigmaerpdev__Location__c','sigmaerpdev__Customer__c'}) 
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'id','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Product_Order__c','sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Auto_allocate__c','sigmaerpdev__Package__c','sigmaerpdev__Status__c','sigmaerpdev__Lot__c','sigmaerpdev__Location__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__PackagedProducts__c',new Set<String>{'sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Via_Autopick__c','sigmaerpdev__Product_Order__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Status__c','sigmaerpdev__Package__c','sigmaerpdev__Lot__c','sigmaerpdev__Location__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package_Product_Line_Item__c',new Set<String>{'Id','Name','sigmaerpdev__Lot__c','sigmaerpdev__Expiry_Date__c','sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__Location__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__c','sigmaerpdev__Quantity__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Products__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Products__r.sigmaerpdev__Attribute_Type__c','sigmaerpdev__Status__c','sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Product_Serial_Number__r.Name','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Serial_Number__c','sigmaerpdev__Packaged_Product__c','sigmaerpdev__Inventory_Location_Product_Line_Item__c','sigmaerpdev__Packaged_Product__r.sigmaerpdev__Sigma_Order__r.RecordType.Name','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Rental_Reserved_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Package_Product_Line_Item__c',new Set<String>{'sigmaerpdev__Status__c','sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__Location__c','sigmaerpdev__Quantity__c','sigmaerpdev__Lot__c','sigmaerpdev__Inventory_Location_Product_Line_Item__c','sigmaerpdev__Expiry_Date__c','sigmaerpdev__Product_Serial_Number__c'})
        && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Package_Product_Line_Item__c',new Set<String>{'sigmaerpdev__Packaged_Product__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'id','Name','sigmaerpdev__Sigma_Order__c','sigmaerpdev__PartialPackQuantCompare__c','sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Remaining_Qty_To_Package__c','sigmaerpdev__Quantity__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev__Remaining_Qty_To_Package__c','sigmaerpdev__Packaged_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new Set<String>{'Id','name','sigmaerpdev__Fully_Packaged__c','RecordTypeId','RecordType.Name'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sigma_Order__c',new Set<String>{'sigmaerpdev__Fully_Packaged__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'Id','Name','sigmaerpdev__Products__c','sigmaerpdev__Inventory_Location_Name__c','sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__c','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Rental_Adjustment_Quantity__c','sigmaerpdev__Rental_Delivered_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Rental_Delivered_Quantity__c','sigmaerpdev__Rental_Adjustment_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'sigmaerpdev__Reserved_Quantity__c','sigmaerpdev__Rental_Reserved_Quantity__c','sigmaerpdev__Rental_Adjustment_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'Id','Name','sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__Reserved_Quantity__c','sigmaerpdev__Rental_Reserved_Quantity__c','sigmaerpdev__Rental_Adjustment_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Lot__c',new Set<String>{'Id','Name','sigmaerpdev__Product__c'})      
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Lot_Product__c',new Set<String>{'Id','Name','sigmaerpdev__Location__c','sigmaerpdev__Quantity__c','sigmaerpdev__Lot__c','sigmaerpdev__Product__c','sigmaerpdev__Location__r.sigmaerpdev__Location__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Lot_Product__c',new Set<String>{'sigmaerpdev__Quantity__c'}) 
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'Id','sigmaerpdev__Status__c','sigmaerpdev__Serial_Number__c','sigmaerpdev__Package_Status__c','sigmaerpdev__Quantity__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'sigmaerpdev__Status__c','sigmaerpdev__Package_Status__c','sigmaerpdev__Order_Line__c'})            
        )
        
        {
            
            try{
                Object packagevalue = (Object)System.JSON.deserializeUntyped(packageObjs);
                String packagedes = JSON.serialize(packagevalue);
                Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(packagedes);
                Map<id,id> serialno=new Map<id,id>(); 
                //new code added 11-06-2018
                packageObj.Id = String.valueOf(root.get('Id'));
                if(root.get('sigmaerpdev__Customer__c')!=null)
                {
                    packageObj.Customer__c= String.valueOf(root.get('sigmaerpdev__Customer__c'));
                }
                if(root.get('sigmaerpdev__Location__c') !=null)
                {
                    packageObj.Location__c = String.valueOf(root.get('sigmaerpdev__Location__c'));
                }
                if(root.get('sigmaerpdev__Instructions__c') !=null)
                {
                    packageObj.Instructions__c = String.valueOf(root.get('sigmaerpdev__Instructions__c'));
                }
                if(root.get('sigmaerpdev__PackagedBy__c') !=null)
                {
                    packageObj.PackagedBy__c = String.valueOf(root.get('sigmaerpdev__PackagedBy__c'));
                }
                if(root.get('sigmaerpdev__PackagedDate__c') !=null)
                {
                    System.debug('inside lot root');
                }
                if(root.get('sigmaerpdev__Status__c') !=null)
                {
                    packageObj.Status__c = String.valueOf(root.get('sigmaerpdev__Status__c'));
                }
                update packageObj;  
                
                if(container != null){
                    List<ProductWrapper> AllData = new List<ProductWrapper>();
                    String transPackStatus = '';
                    String transId = '';
                    Decimal allocatedOrPackageQnty = 0;
                    Boolean isSelectedForPackage = false;
                    for(newPackageControllerLtng.MainWrapper temp :container){          
                        transPackStatus = temp.status;
                        transId = temp.transId;
                        
                        for(lineItemsWrapper liwrap : temp.lineItemsList){
                            if(liwrap.isSelected){//add the product to package products only if isSelected is checked ()i.e. from UI checkbox during Packaging)
                                
                                isSelectedForPackage = liwrap.isSelected;
                                allocatedOrPackageQnty = liwrap.allocatedQnty;
                                
                                Boolean viaAutopick = liwrap.packProd.Auto_allocate__c;                  
                                for(ProductWrapper p1 : liwrap.prodwrap){
                                    List<innerWrapper> innerListData = new List<innerWrapper>();
                                    
                                    for(innerWrapper temp1 : p1.wrapProdList){
                                        if(temp1.selQuantity != null && temp1.selQuantity != 0){   
                                            serialno.put(temp1.srNumId,liwrap.packProd.sigmaerpdev__Product_Order__c);
                                            innerListData.add(new innerWrapper(temp1.selQuantity,temp1.srNumId,temp1.lotName,temp1.lotExpiryDate,temp1.ilpName,temp1.ilpAvailQuantity,temp1.lotId,temp1.ilpId,temp1.ilpliId,temp1.locationId,temp1.srNumName,temp1.ppId,temp1.ppliId));
                                        }                       
                                        
                                    }
                                    AllData.add(new ProductWrapper(transId,p1.transName,p1.transItemId,p1.prodId,p1.prodName,p1.recvQnt,transPackStatus,p1.prodAttributeType,allocatedOrPackageQnty,viaAutopick,isSelectedForPackage,
                                                                   innerListData));
                                    productsList.add(p1.prodId);                    
                                }
                            }
                            
                        }
                    }
                    
                    List<PackagedProducts__c> packageProductList = [select id from PackagedProducts__c where Package__c = :packageObj.Id and Status__c != 'Ready'];     
                    if(PackagedProducts__c.sObjectType.getDescribe().isDeletable())
                    {
                        delete packageProductList;
                    }
                    List<PackagedProducts__c> packProdList = new List<PackagedProducts__c>();
                    Set<ID> packProdIDList = new Set<ID>();
                    Map<Id,List<Package_Product_Line_Item__c>> PPLIMap = new Map<Id,List<Package_Product_Line_Item__c>>();        
                    for(ProductWrapper temp :AllData)
                    {
                        List<Package_Product_Line_Item__c> PPLIList = new List<Package_Product_Line_Item__c>();
                        PackagedProducts__c tempPackProdObje = new PackagedProducts__c();
                        List<innerWrapper> innerData = temp.wrapProdList;
                        
                        for(innerWrapper PLIL :innerData)
                        {
                            Package_Product_Line_Item__c PPLI = new Package_Product_Line_Item__c();
                            PPLI.Inventory_Location_Product__c = PLIL.ilpId;
                            PPLI.Location__c = PLIL.locationId;
                            PPLI.Quantity__c = PLIL.selQuantity;
                            PPLI.Lot__c = PLIL.lotId;
                            PPLI.Inventory_Location_Product_Line_Item__c = PLIL.ilpliId;
                            PPLI.Expiry_Date__c = PLIL.lotExpiryDate;
                            PPLI.Product_Serial_Number__c = PLIL.srNumId; 
                            PPLIList.add(PPLI);
                            //code to fix the issue - if there is two ilpli allocated for the same transaction line item                
                            
                            if(PPLIMap.ContainsKey(temp.transItemId))
                            {
                                List<Package_Product_Line_Item__c> interimList = PPLIMap.get(temp.transItemId);
                                interimList.add(PPLI);
                                PPLIMap.put(temp.transItemId,interimList);
                                
                            }else
                            {
                                List<Package_Product_Line_Item__c> newList = new List<Package_Product_Line_Item__c>();
                                newList.add(PPLI);
                                PPLIMap.put(temp.transItemId,newList);
                            }
                            //ends here             
                        }
                        tempPackProdObje.Product__c = temp.prodId;
                        tempPackProdObje.Quantity__c = temp.allocatedOrPackageQnty;  //changed on 23-11-2017          
                        tempPackProdObje.Via_Autopick__c = temp.allocatedViaAutopickOrManual;  //changed on 23-11-2017 
                        tempPackProdObje.Product_Order__c = temp.transItemId;
                        tempPackProdObje.Sigma_Order__c = temp.transId;
                        tempPackProdObje.Status__c = temp.status; //added for status
                        tempPackProdObje.Package__c = packageObj.Id;
                        //new code added by chandana to update in package product 
                        for(innerWrapper PPrd :innerData)
                        {
                            tempPackProdObje.Lot__c= PPrd.lotId;
                            tempPackProdObje.Location__c= PPrd.locationId;
                        }
                        PackProdList.add(tempPackProdObje);
                    }
                    //code to fix the issue - multiple package products for the same product if its quantity was more than 1
                    Set<PackagedProducts__c> finalSet = new Set<PackagedProducts__c>();
                    List<PackagedProducts__c> result = PackProdList;
                    finalSet.addAll(result);
                    result.clear();
                    PackProdList.clear();
                    result.addAll(finalSet);
                    PackProdList = result;
                    //ends here
                    insert PackProdList;
                    
                    //Rental order flow to update in ilp for rental deliverd qty
                       
                    List<Id> SOids = new List<Id>();
                    for(PackagedProducts__c templistids :PackProdList)
                    {
                        SOids.add(templistids.Sigma_Order__c);
                    }
                    List<Sigma_Order__c> interimorder = new List<Sigma_Order__c>();
                    interimorder = [select id,RecordTypeId,RecordType.Name from sigmaerpdev__Sigma_Order__c where id in :SOids];
                    
                    List<Package_Product_Line_Item__c> PPLIInsertList = new List<Package_Product_Line_Item__c> ();  
                    for(PackagedProducts__c var :PackProdList)
                    {
                        packProdIDList.add(var.Product__c);
                        if(PPLIMap.containsKey(var.Product_Order__c))
                        {
                            List<Package_Product_Line_Item__c> tempPPLIList = PPLIMap.get(var.Product_Order__c);
                            for(Package_Product_Line_Item__c var1 :tempPPLIList)
                            {                    
                                var1.Packaged_Product__c =  var.Id;
                                var1.Status__c = var.Status__c;
                                PPLIInsertList.add(var1);                    
                            }
                        }
                    }      
                    insert PPLIInsertList;
                    
                    //added on 27/12/2017 to update packaged qty and remaining qty on order line items to provide partial packaging
                    Set<Id> transactionIdList = new Set<Id>();
                    List<PackagedProducts__c> packageProdList1;
                    
                    packageProdList1 = [select id,Sigma_Order__c,Product_Order__c,Quantity__c from 
                                        PackagedProducts__c where Package__c = :packageObj.Id
                                        and Status__c = 'Ready'];
                    for(PackagedProducts__c ppListIterate : packageProdList1){
                        transIdAndPackagedQty.put(ppListIterate.Product_Order__c,ppListIterate.Quantity__c);
                        transactionIdList.add(ppListIterate.Sigma_Order__c);
                    }       
                    
                    if(transIdAndPackagedQty.size() > 0){
                        List<Product_Order_Price_Book__c> transLineItemsList;  
                        List<Product_Order_Price_Book__c> transLineObjList = new List<Product_Order_Price_Book__c>();
                        
                        transLineItemsList = [Select Id,Name,Packaged_Quantity__c,Remaining_Qty_To_Package__c,Quantity__c From Product_Order_Price_Book__c where Id IN :transIdAndPackagedQty.keySet()];
                        for(Product_Order_Price_Book__c tdi : transLineItemsList){
                            Product_Order_Price_Book__c tdiObj = new Product_Order_Price_Book__c();                            
                            
                            if(tdi.Packaged_Quantity__c == 0 || tdi.Packaged_Quantity__c== null){
                                
                                tdiObj.Packaged_Quantity__c = transIdAndPackagedQty.get(tdi.Id);
                            }else{
                                
                                if(tdi.Packaged_Quantity__c != null ){
                                    tdiObj.Packaged_Quantity__c = tdi.Packaged_Quantity__c  + transIdAndPackagedQty.get(tdi.Id);  
                                }                    
                            }   
                            if(tdi.Packaged_Quantity__c != null){
                                tdiObj.Remaining_Qty_To_Package__c = tdi.Quantity__c - tdiObj.Packaged_Quantity__c;
                            }                    
                            tdiObj.Id = tdi.Id;
                            transLineObjList.add(tdiObj);                
                        }
                        
                        update transLineObjList; //update trans line item list
                        
                        //new code added to check if any order line items are partially packaged and accordingly set the packageDone flag to true or false
                        List<Id> transIdListNew = new List<Id>(transactionIdList);
                        
                        List<Sigma_Order__c>  newTransFinalList = new List<Sigma_Order__c>();            
                        Map<Id,Boolean> packagedTransMap = new Map<Id,Boolean>();
                        newTransFinalList = [select Id,name,(select id,Sigma_Order__c,PartialPackQuantCompare__c 
                                                             from Order_Lines__r)from Sigma_Order__c where Id in :transIdListNew];
                        
                        for(Sigma_Order__c transIdNew : newTransFinalList){
                            Boolean packageDone = true; 
                            for(Product_Order_Price_Book__c tdiChild : transIdNew.Order_Lines__r){
                                if(tdiChild.PartialPackQuantCompare__c == 'true'){
                                    packageDone = false;
                                }
                            }
                            packagedTransMap.put(transIdNew.Id,packageDone);
                            
                        }
                        
                        //ends here         
                        //update transaction field - fully packaged status to true if sigma order's line items[all line items] are packaged fully
                        List<Sigma_Order__c> interimTransactionList = new List<Sigma_Order__c>();
                        interimTransactionList = [select id,Fully_Packaged__c from Sigma_Order__c where id in :packagedTransMap.keySet()];
                        system.debug('interimTransactionList::'+interimTransactionList);
                        List<Sigma_Order__c> updatingTransactionList = new List<Sigma_Order__c>();
                        for(Sigma_Order__c tempIterate : interimTransactionList){
                            
                            if(packagedTransMap.get(tempIterate.id) == true){
                                Sigma_Order__c tempTrans = new Sigma_Order__c();
                                tempTrans.id = tempIterate.id; 
                                tempTrans.Fully_Packaged__c = true;
                                updatingTransactionList.add(tempTrans);
                            }               
                        }
                        update updatingTransactionList;
                        //ends here            
                    }
                    //ends here
                    
                    Set<Id> LocationIDSet = new Set<Id>();
                    for(Package_Product_Line_Item__c pp :PPLIInsertList)
                    {
                        LocationIDSet.add(pp.Location__c);
                    }
                    
                    //added on 3-10-2017 to update ILP
                    //System.debug('PPLIList--->'+PPLIList);
                    List<Inventory_Location_Product__c> invProdLocList;
                    List<Inventory_Location_Product__c> ILPList = new List<Inventory_Location_Product__c>();
                    List<Id> ILPLIIDList = new List<Id>();
                    
                    invProdLocList = [Select Id,Name,Products__c,Inventory_Location_Name__c,
                                      Delivered_Quantity__c From Inventory_Location_Product__c where Products__c IN:productsList and Inventory_Location__r.Location__c IN :LocationIDSet];
                    
                    for(Package_Product_Line_Item__c pp :PPLIInsertList){            
                        ILPLIIDList.add(pp.Id);         
                    }
                    
                    
                    //added to reduce ILP and ILPLI quantities during package for manual selection - added on 5/12/2017
                    List<Id> packProdIdListForManual  = new List<Id>();
                    for(PackagedProducts__c ppId :PackProdList){            
                        packProdIdListForManual.add(ppId.Id);            
                    }
                    Map<Id,Integer> ILPReduceQtyMapForManual = new Map<Id,Integer>(); //used to store ILP and the quantity to be reduced 
                    Map<Id,Integer> ILPReduceQtyMapForrental = new Map<Id,Integer>();
                    Map<Id,Integer> ILPLIReduceQtyMapForManual = new Map<Id,Integer>(); //used to store ILP and the quantity to be reduced 
                    Map<Id,Integer> ILPLIReduceQtyMapForrental = new Map<Id,Integer>(); //used to store ILP and the quantity to be reduced 
                    List<Inventory_Location_Product__c> fullILPList;        
                    List<Package_Product_Line_Item__c> packProdLineList1;
                    List<Inventory_Location_Product_Line_Item__c> fullILPLIList;
                    List<Inventory_Location_Product_Line_Item__c> ILPLIListToUpdate = new List<Inventory_Location_Product_Line_Item__c>();
                    
                    packProdLineList1 = [Select Id,Name,Lot__c,Expiry_Date__c,Inventory_Location_Product__c,Location__c,
                                         Inventory_Location_Product__r.Inventory_Location__c,Quantity__c,Inventory_Location_Product__r.Products__c,
                                         Inventory_Location_Product__r.Products__r.Attribute_Type__c,Status__c,Product_Serial_Number__c,Product_Serial_Number__r.Name,
                                         Product_Serial_Number__r.Serial_Number__c,Packaged_Product__c,Packaged_Product__r.sigmaerpdev__Sigma_Order__r.RecordType.Name,
                                         Inventory_Location_Product_Line_Item__c, Inventory_Location_Product_Line_Item__r.Rental_Reserved_Quantity__c
                                         From Package_Product_Line_Item__c where Packaged_Product__r.Via_Autopick__c = false and 
                                         Packaged_Product__c IN : packProdIdListForManual];
                    
                    system.debug('packProdLineList1::'+packProdLineList1);
                    for(Package_Product_Line_Item__c pp1 :packProdLineList1)
                    {
                        
                       
                        if(pp1.Status__c=='Ready' &&pp1.Packaged_Product__r.sigmaerpdev__Sigma_Order__r.RecordType.Name == 'Rental Order')
                        {
                             if(!ILPReduceQtyMapForrental.containsKey(pp1.Inventory_Location_Product__c)){
                                    ILPReduceQtyMapForrental.put(pp1.Inventory_Location_Product__c,Integer.valueOf(pp1.Quantity__c));
                                }else{
                                    Integer qty1 = ILPReduceQtyMapForrental.get(pp1.Inventory_Location_Product__c);
                                    
                                    ILPReduceQtyMapForrental.put(pp1.Inventory_Location_Product__c,(qty1 + Integer.valueOf(pp1.Quantity__c)));
                                } 
                                ILPLIReduceQtyMapForrental.put(pp1.Inventory_Location_Product_Line_Item__c,Integer.valueOf(pp1.Quantity__c));
                        }
                        else  if(pp1.Status__c=='Ready')
                        {
                            if(!ILPReduceQtyMapForManual.containsKey(pp1.Inventory_Location_Product__c)){
                                ILPReduceQtyMapForManual.put(pp1.Inventory_Location_Product__c,Integer.valueOf(pp1.Quantity__c));
                            }else{
                                Integer qty1 = ILPReduceQtyMapForManual.get(pp1.Inventory_Location_Product__c);
                                
                                ILPReduceQtyMapForManual.put(pp1.Inventory_Location_Product__c,(qty1 + Integer.valueOf(pp1.Quantity__c)));
                            } 
                            ILPLIReduceQtyMapForManual.put(pp1.Inventory_Location_Product_Line_Item__c,Integer.valueOf(pp1.Quantity__c)); //store selected ILPLI ids and quantity
                        }  
                    }
                    system.debug('ILPLIReduceQtyMapForManual::'+ILPLIReduceQtyMapForManual);
                    system.debug('ILPReduceQtyMapForManual::'+ILPReduceQtyMapForManual);
                        
                    fullILPList = [Select Id,Name,Products__c,Inventory_Location_Name__c,Net_Quantity__c,sigmaerpdev__Rental_Adjustment_Quantity__c,
                                   Delivered_Quantity__c,Rental_Delivered_Quantity__c From Inventory_Location_Product__c where Id IN :ILPReduceQtyMapForManual.keySet() OR Id IN :ILPReduceQtyMapForrental.keySet()];
                    
                    
                    for(Inventory_Location_Product__c ilp : fullILPList)
                    {
                         Inventory_Location_Product__c ilpObj = new Inventory_Location_Product__c(); 
                        if(ILPReduceQtyMapForManual.containsKey(ilp.Id))
                        { 
                          
                            ilpObj.Delivered_Quantity__c = ilp.Delivered_Quantity__c + ILPReduceQtyMapForManual.get(ilp.Id);
                            ilpObj.Id = ilp.Id;
                                   
                             
                        }
                        if(ILPReduceQtyMapForrental.containsKey(ilp.Id))
                        {
                            ilpObj.Rental_Delivered_Quantity__c = ilp.Rental_Delivered_Quantity__c + ILPReduceQtyMapForrental.get(ilp.Id);
                            //ilpObj.sigmaerpdev__Rental_Adjustment_Quantity__c = ilp.sigmaerpdev__Rental_Adjustment_Quantity__c - ILPReduceQtyMapForrental.get(ilp.Id);
                            ilpObj.Id = ilp.Id;
                        }
                        ILPList.add(ilpObj);
                    }
                    system.debug('ILPList'+ILPList);
                    update ILPList; //update ILP list
                    system.debug('ILP List::'+ILPList);
                        
                    fullILPLIList = [Select Id,Name,Inventory_Location_Product__c,Reserved_Quantity__c, sigmaerpdev__Rental_Reserved_Quantity__c,sigmaerpdev__Rental_Adjustment_Quantity__c
                                     From Inventory_Location_Product_Line_Item__c where Id IN :ILPLIReduceQtyMapForManual.keySet() OR Id IN :ILPLIReduceQtyMapForrental.keySet()];
                    
                    for(Inventory_Location_Product_Line_Item__c ilpli : fullILPLIList)
                    {
                        Inventory_Location_Product_Line_Item__c ilpliObj = new Inventory_Location_Product_Line_Item__c(); 
                        
                        if(ILPLIReduceQtyMapForManual.containsKey(ilpli.Id))
                        {
                           
                            ilpliObj.Reserved_Quantity__c = ilpli.Reserved_Quantity__c + ILPLIReduceQtyMapForManual.get(ilpli.Id);
                            ilpliObj.Id = ilpli.Id;
                               
                        }
                        if(ILPLIReduceQtyMapForrental.containsKey(ilpli.Id))
                        {
                            system.debug('Rental Flow');
                            ilpliObj.Rental_Reserved_Quantity__c = ilpli.Rental_Reserved_Quantity__c + ILPLIReduceQtyMapForrental.get(ilpli.Id);
                            //ilpliObj.sigmaerpdev__Rental_Adjustment_Quantity__c = ilpli.sigmaerpdev__Rental_Adjustment_Quantity__c - ILPLIReduceQtyMapForrental.get(ilpli.Id);
                            ilpliObj.Id = ilpli.Id;
                        }
                        ILPLIListToUpdate.add(ilpliObj);
                    }    
                    system.debug('ILPLIListToUpdate before update::'+ILPLIListToUpdate);
                    update ILPLIListToUpdate; //update ILPLI list
                    //ends here
                    system.debug('ILPLIListToUpdate::'+ILPLIListToUpdate);
                    
                    List<Package_Product_Line_Item__c> packProdLineList;
                    Map<Id,Integer> ILPReduceQtyMap = new Map<Id,Integer>();
                    Map<id,Map<Id,Decimal>> LotReduceQtyMap = new Map<id,Map<Id,Decimal>>();
                    Set<ID> AllocatePSNIDSet = new Set<ID>(); 
                    Map<Id,Integer> AllocatePSNMap = new Map<Id,Integer>();
                    
                    packProdLineList = [Select Id,Name,Lot__c,Expiry_Date__c,Inventory_Location_Product__c,Location__c,Inventory_Location_Product__r.Inventory_Location__c,Quantity__c,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Attribute_Type__c,Status__c,Product_Serial_Number__c,Product_Serial_Number__r.Name,Product_Serial_Number__r.Serial_Number__c,Packaged_Product__c,Inventory_Location_Product_Line_Item__c From Package_Product_Line_Item__c where Id IN:ILPLIIDList];
                    system.debug('packProdLineList::'+packProdLineList);
                    
                    for(Package_Product_Line_Item__c pp :packProdLineList)
                    {            
                        if(pp.Status__c=='Ready')
                        {
                            if(LotReduceQtyMap.containsKey(pp.Lot__c))
                            {
                            if(LotReduceQtyMap.get(pp.Lot__c).containsKey(pp.Location__c))
                            {
                                pp.Quantity__c=LotReduceQtyMap.get(pp.Lot__c).get(pp.Location__c)+pp.Quantity__c;
                                LotReduceQtyMap.get(pp.Lot__c).put(pp.Location__c,pp.Quantity__c);
                         
                            }
                            else
                            {
                                 LotReduceQtyMap.get(pp.Lot__c).put(pp.Location__c,pp.Quantity__c);
                        
                            }
                            
                            }
                            else
                            {
                            Map<id,decimal> lotil= new Map<id,decimal>();
                            lotil.put(pp.Location__c,pp.Quantity__c);
                            LotReduceQtyMap.put(pp.Lot__c,lotil);
                            }
                            if(pp.Inventory_Location_Product__r.Products__r.Attribute_Type__c=='SERIALIZED')
                            {
                                AllocatePSNIDSet.add(pp.Product_Serial_Number__c);
                                if(!AllocatePSNMap.containsKey(pp.Product_Serial_Number__c))
                                {
                                    AllocatePSNMap.put(pp.Product_Serial_Number__c,Integer.valueOf(pp.Quantity__c));
                                }
                            }                
                        }        
                    }
                    
                    
                    //added to upsert lot product on 4-10-2017
                    List<Lot_Product__c> lotProductsList = new List<Lot_Product__c>();
                    Map<String,List<Lot_Product__c>> lotMap = new Map<String,List<Lot_Product__c>>();
                    List<Lot__c> lotList;

                    if(FLSCheckReadPremissionLot() == true && FLSCheckReadPremissionLotProduct() == true){      
                        lotList = [Select Id,Name,Product__c,(Select Id,Name,Location__c,Quantity__c,Lot__c,Product__c,Location__r.Location__c From Lot_Products__r) From Lot__c where Product__c IN :packProdIDList];
                    }
                    system.debug('lotList'+lotList);
                    for(Lot__c lt:lotList)
                    {
                         if(LotReduceQtyMap.containsKey(lt.id))  
                        { 
                            for(Lot_Product__c LP:lt.Lot_Products__r)
                            {
                                if(LotReduceQtyMap.get(lt.id).containsKey(LP.Location__r.Location__c))                          {
                                    LP.Quantity__c = LP.Quantity__c - LotReduceQtyMap.get(lt.id).get(LP.Location__r.Location__c);
                                    lotProductsList.add(LP);
                                    system.debug('lotProductsList111'+lotProductsList);
                                }
                            }
                      }
                      lotMap.put(lt.Id,lt.Lot_Products__r);
                    }   

                    if(FLSCheckLotProduct() == true){
                        update lotProductsList;
                        system.debug('lotProductsList'+lotProductsList);
                    }
                    
                    //code to allocate PSN        
                    if(AllocatePSNIDSet.size() > 0)
                    {
                        List<Product_Serial_Number__c> updatePSNList = [select Id,Status__c,Serial_Number__c,Package_Status__c,Quantity__c from Product_Serial_Number__c where Status__c ='Available' and Package_Status__c=false and ID IN:AllocatePSNIDSet]; 

                        if(updatePSNList.size() > 0)
                        {
                            for(Product_Serial_Number__c var :updatePSNList)
                            {
                                if(AllocatePSNMap.containsKey(var.Id))
                                {
                                    var.Status__c = 'Used';
                                    var.Package_Status__c = True;
                                    if(serialno.containsKey(var.id))
                                    {
                                        var.sigmaerpdev__Order_Line__c=serialno.get(var.id);
                                    }
                                }
                                system.debug('var::'+var);
                            }
                            update updatePSNList;
                            system.debug('updatePSNList::'+updatePSNList);
                        }
                    } 
                    //ends here
                } //end of (container != null) if loop
            }catch(Exception e){            
                return null;
            }
        }       
        return packageObj;
    }*/
    //ends here
    
    //Handle FIFO based allocation during Package - added on 1/12/2017
 /*   @AuraEnabled
    public static Boolean AllocateStockUsingFIFODuringPackage(Id transId, Id transLineId, Id ProductId, Decimal OrderedQty)
    {
        
        Decimal allocatedQnty = 0.0;
        Decimal requiredQuantity = 0.0;
        Decimal allocatingQuantity = 0.0;
        Decimal orderedQuantity = 0.0;
        Decimal remainingQnty = 0.0;
        Decimal lineItemOrderedQuantity = 0.0; //used to restrict partial allocation if stock is insufficient  
        
        //------------------------------FLS check--------------------
        
        
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sales_Order_Allocation__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sales_Order_Allocation_Line_Item__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new Set<String>{'id','name','sigmaerpdev__Allocation_Done__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'id','name','sigmaerpdev__Product__r.Name','sigmaerpdev__Quantity__c'})
        &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev__Allocation_Done__c','sigmaerpdev__Allocated_Quantity__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'id','name','sigmaerpdev__Products__c','sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Rental_Delivered_Quantity__c','sigmaerpdev__Inventory__r.Id'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Products__c','sigmaerpdev__Rental_Delivered_Quantity__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'name','sigmaerpdev__Inventory_Location_Product__r.Id','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Products__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Products__r.Name','sigmaerpdev__Reserved_Quantity__c','sigmaerpdev__Rental_Reserved_Quantity__c','sigmaerpdev__Available_Quantity__c','sigmaerpdev__Allocated_Quantity__c','sigmaerpdev__Expiry_Date__c','sigmaerpdev__Updated_Exp_Date__c','sigmaerpdev__Product_Received_Date__c'})
        //&&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Products__c','sigmaerpdev__Available_Quantity__c','sigmaerpdev__Reserved_Quantity__c','sigmaerpdev__Allocated_Quantity__c'})
        &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'sigmaerpdev__Reserved_Quantity__c','sigmaerpdev__Allocated_Quantity__c','sigmaerpdev__Rental_Reserved_Quantity__c'})
        &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sales_Order_Allocation__c',new Set<String>{'sigmaerpdev__Status__c','sigmaerpdev__Sigma_Order__c'})
        &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sales_Order_Allocation_Line_Item__c',new Set<String>{'sigmaerpdev__Order_Line__c','sigmaerpdev__Allocated_Quantity__c','sigmaerpdev__Inventory_Location_Product_Line_Item__c','sigmaerpdev__Status__c','sigmaerpdev__Ordered_Quantity__c','sigmaerpdev__Remaining_Quantity__c'})
        &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Sales_Order_Allocation_Line_Item__c',new Set<String>{'sigmaerpdev__Sales_Order_Allocation__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sigma_Order__c',new Set<String>{'sigmaerpdev__Allocation_Done__c'})
        )
        {
            system.debug('inside fls');
            try{
                List<Sigma_Order__c> transList = [select id,name,Allocation_Done__c from Sigma_Order__c where id = :transId];
                List<Product_Order_Price_Book__c> transItemsList = [select Id,Name,Product__r.Name,Quantity__c from Product_Order_Price_Book__c where id = :transLineId];
                 Sigma_Order__c orderList = [select id,name,RecordTypeId,RecordType.Name from Sigma_Order__c where id = :transId];
                system.debug('orderList::'+orderList);
                Map<Id,Id> indvTransItemMap = new Map<Id,Id>(); //used to store Trans Items and its Products in Map     
                Map<Id,Decimal> reqProductQuantityMap1 = new Map<Id,Decimal>(); // store Product Id and its Ordered Quantity
                Map<Id,Decimal> orderedQuantitymap = new Map<Id,Decimal>(); //used to store Ordered Product Id and its Quantity
                Map<Id,String> ilpListMap1 = new Map<Id,String>();
                Integer allocOption = 2; //allocation happens on FIFO basis - Option 1 for Expiry date,Option 2 for Received date  
                
                indvTransItemMap.put(ProductId,transLineId); 
                reqProductQuantityMap1.put(ProductId, OrderedQty); 
                orderedQuantitymap.put(ProductId,OrderedQty);
                lineItemOrderedQuantity = OrderedQty; //used to restrict partial allocation if stock is insufficient
                
                List<Inventory_Location_Product__c> ilpList = [select id,name from Inventory_Location_Product__c where Products__c = :reqProductQuantityMap1.keySet()];
                
                for (Inventory_Location_Product__c ilpListItems : ilpList){              
                    ilpListMap1.put(ilpListItems.Id,ilpListItems.Name);
                }
                
                List<Inventory_Location_Product_Line_Item__c> ilpliList = new List<Inventory_Location_Product_Line_Item__c>();
                if(allocOption == 1){
                    
                    ilpliList = [select name,Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Name,Reserved_Quantity__c,Available_Quantity__c,Allocated_Quantity__c,Expiry_Date__c,sigmaerpdev__Rental_Reserved_Quantity__c
                                 from Inventory_Location_Product_Line_Item__c where Inventory_Location_Product__r.Id in :ilpListMap1.keySet() and Updated_Exp_Date__c > TODAY order by Updated_Exp_Date__c ASC];
                    
                }else if(allocOption == 2){
                    
                    List<Inventory_Location_Product_Line_Item__c> tempilpliList = new List<Inventory_Location_Product_Line_Item__c>();
                    tempilpliList = [select name,Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Name,
                                     Reserved_Quantity__c,sigmaerpdev__Rental_Reserved_Quantity__c,Available_Quantity__c,Allocated_Quantity__c,Product_Received_Date__c from Inventory_Location_Product_Line_Item__c where 
                                     Inventory_Location_Product__r.Id in :ilpListMap1.keySet() and Updated_Exp_Date__c != null and Updated_Exp_Date__c > TODAY];
                    
                    
                    if(tempilpliList.size() > 0){ //if expiry date exists choose those ilpli's to do allocation
                        ilpliList = [select name,Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Name,
                                     Reserved_Quantity__c,sigmaerpdev__Rental_Reserved_Quantity__c,Available_Quantity__c,Allocated_Quantity__c,Product_Received_Date__c from Inventory_Location_Product_Line_Item__c where 
                                     Inventory_Location_Product__r.Id in :ilpListMap1.keySet() and Updated_Exp_Date__c > TODAY order by Product_Received_Date__c ASC];
                        
                    }else{ //else choose all ilpli's to do allocation
                        ilpliList = [select name,Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Name,
                                     Reserved_Quantity__c,sigmaerpdev__Rental_Reserved_Quantity__c,Available_Quantity__c,Allocated_Quantity__c,Product_Received_Date__c from Inventory_Location_Product_Line_Item__c where 
                                     Inventory_Location_Product__r.Id in :ilpListMap1.keySet() order by Product_Received_Date__c ASC];
                    }
                     system.debug('ilpliList::'+ilpliList);
                system.debug('tempilpliList::'+tempilpliList);
                    
                }                                          
               
                //added to restrict partial allocation if there is insufficient stock           
                Decimal tempQuantityTotal = 0.0;
                Boolean stockExists = false; //suggests there is not enough stock to do allocation
                for(Inventory_Location_Product_Line_Item__c checkQuantity : ilpliList){
                    tempQuantityTotal = tempQuantityTotal + checkQuantity.Available_Quantity__c;
                }
                
                if(tempQuantityTotal >= lineItemOrderedQuantity){
                    stockExists = true; //suggests there is enough stock to do allocation
                }
                
                //ends here.
                
                
                //allocate inventory in ILPLI object        
                Map<id,List<Inventory_Location_Product_Line_Item__c>> productAndILPLAllocated = new Map<id,List<Inventory_Location_Product_Line_Item__c>>();
                Map<id,Decimal> IlPLIQuan = new Map<id,Decimal>();
                //check whether there is enough stock to do allocation
                
                if(stockExists == true)
                { 
            //suggests there is enough stock to do allocation if stockExists is true
            
                    for(Inventory_Location_Product_Line_Item__c allocateProd : ilpliList)
                    {          
                        Id prodIds = allocateProd.Inventory_Location_Product__r.Products__c;          
                        requiredQuantity = reqProductQuantityMap1.get(String.valueOf(allocateProd.Inventory_Location_Product__r.Products__c));
                        
                        if(requiredQuantity != 0)
                        {          
                            allocatingQuantity = allocateProd.Available_Quantity__c;  
                            
                            if(allocatingQuantity <= requiredQuantity && allocatingQuantity != 0)
                            {
                                system.debug('allocateProd.Rese>>>>::::'+allocateProd.Reserved_Quantity__c);
                                if(allocateProd.Reserved_Quantity__c != null)
                                {
                                    if(orderList.RecordType.Name == 'Rental Order')
                                    {
                                        allocateProd.sigmaerpdev__Rental_Reserved_Quantity__c = allocateProd.sigmaerpdev__Rental_Reserved_Quantity__c + allocatingQuantity;
                                    }
                                    else{
                                        allocateProd.Reserved_Quantity__c = allocateProd.Reserved_Quantity__c + allocatingQuantity;
                                    
                                    }
                                    allocateProd.Allocated_Quantity__c = allocatingQuantity;
                                    IlPLIQuan.put(allocateProd.Id,allocatingQuantity);                                                          
                                    if(productAndILPLAllocated.containsKey(prodIds))
                                    {
                                        List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                                        usedILPLI = productAndILPLAllocated.get(prodIds);
                                        usedILPLI.add(allocateProd);
                                        productAndILPLAllocated.put(prodIds,usedILPLI);  
                                            system.debug('usedILPLI3690::>>'+usedILPLI);
                                    }
                                    else{
                                        List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                                        usedILPLI.add(allocateProd);
                                        productAndILPLAllocated.put(prodIds,usedILPLI);  
                                            system.debug('usedILPLI3695::>>'+usedILPLI);
                                    }
                                    
                                }
                                requiredQuantity = requiredQuantity - allocatingQuantity;
                            }
                            else if(allocatingQuantity > requiredQuantity)
                            { 
                            system.debug('allocateProd.Rese::::'+allocateProd.Reserved_Quantity__c);
                            if(allocateProd.Reserved_Quantity__c != null)
                                {  
                                        if(orderList.RecordType.Name == 'Rental Order')
                                        {
                                            allocateProd.sigmaerpdev__Rental_Reserved_Quantity__c = allocateProd.sigmaerpdev__Rental_Reserved_Quantity__c + requiredQuantity;
                                        }
                                        else{
                                            allocateProd.Reserved_Quantity__c = allocateProd.Reserved_Quantity__c + requiredQuantity;
                                        }
                                    
                                    allocateProd.Allocated_Quantity__c = requiredQuantity;
                                    IlPLIQuan.put(allocateProd.Id,requiredQuantity);                            
                                    if(productAndILPLAllocated.containsKey(prodIds))
                                    {
                                        List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                                        usedILPLI = productAndILPLAllocated.get(prodIds);
                                        usedILPLI.add(allocateProd);
                                        productAndILPLAllocated.put(prodIds,usedILPLI);                         
                                    }
                                    else{
                                        List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                                        usedILPLI.add(allocateProd);
                                        productAndILPLAllocated.put(prodIds,usedILPLI);
                                    }
                                }
                                requiredQuantity = 0;                   
                            }                                   
                            reqProductQuantityMap1.put(String.valueOf(allocateProd.Inventory_Location_Product__r.Products__c),requiredQuantity);                              
                        } //end of if statement
                    }  //end of for loop
                    update ilpliList;
                    system.debug('ilpliList::'+ilpliList);
                    //allocate inventory in ILPLI object ends here
                }else{
                    return false; //no sufficient stock to do allocation 
                }
                //check whether there is enough stock to do allocation ends here
                
                if(!productAndILPLAllocated.isEmpty())
                {             
                    //insert data into Sales Order Allocation object
                    Sales_Order_Allocation__c soa = new Sales_Order_Allocation__c();
                    soa.Sigma_Order__c = transId;                
                    soa.Status__c = 'Pending';
                    insert soa;    
                    //ends here            
                    
                    //insert data into Sales order Allocation Line Item object
                    List<Sales_Order_Allocation_Line_Item__c> soaliList = new List<Sales_Order_Allocation_Line_Item__c>();
                    for(Id proId : productAndILPLAllocated.keySet())
                    {
                        if(indvTransItemMap.containsKey(proId)){
                            for(Inventory_Location_Product_Line_Item__c ilpli : productAndILPLAllocated.get(proId)){
                                Sales_Order_Allocation_Line_Item__c soali = new Sales_Order_Allocation_Line_Item__c();
                                soali.Sales_Order_Allocation__c = soa.Id;
                                soali.Order_Line__c = indvTransItemMap.get(proId);
                                soali.Allocated_Quantity__c = IlPLIQuan.get(ilpli.Id); 
                                soali.Inventory_Location_Product_Line_Item__c = ilpli.Id;
                                soali.Status__c = 'Allocated';                                             
                                orderedQuantity = orderedQuantitymap.get(proId);                      
                                soali.Ordered_Quantity__c = orderedQuantity;                                                
                                allocatedQnty = allocatedQnty + IlPLIQuan.get(ilpli.Id);                        
                                remainingQnty = allocatedQnty;                        
                                soali.Remaining_Quantity__c = orderedQuantity - remainingQnty;
                                soaliList.add(soali);
                            } //end of inner for loop
                        } //end of if statement        
                    } //end of outer for loop
                    insert soaliList; 
                    
                    //ends here
                    
                    //set Allocation Done Status to true in Transaction Line Items
                    for(Product_Order_Price_Book__c updateStatus : transItemsList){
                        updateStatus.Allocation_Done__c = true;
                        updateStatus.Allocated_Quantity__c = allocatedQnty;
                    }
                    update transItemsList;              
                    
                    for(Sigma_Order__c updateAllocStatus : transList){
                        updateAllocStatus.Allocation_Done__c = true;             
                    }
                    update transList;
                    
                    //handle PI and ILP starts here (updating PI and ILP quantities)                
                    Map<Id,Decimal> allocatedILPs = new Map<Id,Decimal>(); //used to store ILP's and its respective allocated quantity
                    Map<Id,Decimal> allocatedPIs = new Map<Id,Decimal>(); //used to store PI's and its respective allocated quantity
                    
                    List<AggregateResult> aggrResult = [select Inventory_Location_Product__c,sum(Allocated_Quantity__c) from Inventory_Location_Product_Line_Item__c where id in :IlPLIQuan.keySet() group by Inventory_Location_Product__c];
                    for(AggregateResult tempList : aggrResult)
                    {
                        
                        allocatedILPs.put((Id)tempList.get('sigmaerpdev__Inventory_Location_Product__c'),(Decimal)tempList.get('expr0'));
                        
                    }
                    
                    //update ILP [Delivered Quantity] to match the quantities b/w ILP and ILPLI (if its respective ILPLI has been used in the allocation process)
                    List<Inventory_Location_Product__c> updateILPList = [select id,name,Delivered_Quantity__c,sigmaerpdev__Rental_Delivered_Quantity__c,Inventory__r.Id from Inventory_Location_Product__c where id in :allocatedILPs.keySet()];
                    system.debug('updateILPList::'+updateILPList);
                    Decimal tempQuantity = 0.0;  
                    
                    for(Inventory_Location_Product__c updateILP : updateILPList)
                    { 
                        if(orderList.RecordType.Name == 'Rental Order')
                        {
                            updateILP.sigmaerpdev__Rental_Delivered_Quantity__c = updateILP.sigmaerpdev__Rental_Delivered_Quantity__c + allocatedILPs.get(updateILP.Id); 
                        }
                        else if(orderList.RecordType.Name == 'Product Order'|| orderList.RecordType.Name == 'Service Order')
                        {
                            updateILP.Delivered_Quantity__c = updateILP.Delivered_Quantity__c + allocatedILPs.get(updateILP.Id);                  
                        
                        }
                        system.debug('updateILP>>>'+updateILP);
                        tempQuantity = tempQuantity + allocatedILPs.get(updateILP.Id);
                        allocatedPIs.put(updateILP.Inventory__r.Id, tempQuantity);
                    }
                    update updateILPList;
                    system.debug('updateILPList::'+updateILPList);
                } //end of if statement 
                
            }catch(Exception e){
                System.debug('The following exception has occurred in AllocateStockUsingFIFODuringPackage: ' + e.getMessage());
                
                return null;
            }
        }
        return true; //if allocation success
    }*/
    //ends here
    
    //return newly allocated auotpicked stock during package to the wrapper class
  /*  @AuraEnabled
    public static List<ProductWrapper> getAutopickedStock(String orderId, String transLineId)
    {
        List<ProductWrapper> wrapProdListAutopicked = new List<ProductWrapper>(); //full List for Autopicked flow
        List<Product_Order_Price_Book__c> OrderLineList; 
        Map<Id,Id> lineItemsProductsMap = new Map<Id,Id>(); //used to store transLineItemid and its ProductId
        
        //fetch allocated stock from soali object        
        List<Sales_Order_Allocation_Line_Item__c> allocObj = new List<Sales_Order_Allocation_Line_Item__c>();
        
        if( CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sales_Order_Allocation_Line_Item__c')
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'Id','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Id','sigmaerpdev__Allocation_Done__c','sigmaerpdev__Allocated_Quantity__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Quantity__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sales_Order_Allocation_Line_Item__c',new Set<String>{'Id','name','sigmaerpdev__Order_Line__c','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Product_Serial_Number__r.Name','sigmaerpdev__Inventory_Location_Product_Line_Item__c','sigmaerpdev__Location_Name__c','sigmaerpdev__Order_Line__r.sigmaerpdev__Product__c','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Lot__r.sigmaerpdev__Expiry_Date__c','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.name','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Lot__r.Name','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Name','sigmaerpdev__Allocated_Quantity__c','sigmaerpdev__Order_Line__r.sigmaerpdev__Sigma_Order__c','sigmaerpdev__Package_Status__c'})
        )
        {
            system.debug('inside fls ');
            try{        
                
                OrderLineList = [Select Id,Product__c,Product__r.Id,Allocation_Done__c,Allocated_Quantity__c,Product__r.Name,Quantity__c,Sigma_Order__c,Product__r.Attribute_Type__c From Product_Order_Price_Book__c where id = :transLineId];
                system.debug('OrderLineList::'+OrderLineList);
                
                for(Product_Order_Price_Book__c tdiList : OrderLineList){
                    lineItemsProductsMap.put(tdiList.Id,tdiList.Product__r.Id);
                    
                }
                
                allocObj =  [select Id,name,Order_Line__c,Inventory_Location_Product_Line_Item__r.Product_Serial_Number__c,Inventory_Location_Product_Line_Item__r.Product_Serial_Number__r.Name,Inventory_Location_Product_Line_Item__c,Location_Name__c,Order_Line__r.Product__c,Inventory_Location_Product_Line_Item__r.Lot__r.Expiry_Date__c,Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.name,Inventory_Location_Product_Line_Item__r.Lot__r.Name,Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name,Allocated_Quantity__c,Order_Line__r.Sigma_Order__c,Package_Status__c from Sales_Order_Allocation_Line_Item__c where Order_Line__r.Sigma_Order__c =: orderId AND Package_Status__c != true];
                system.debug('allocObj::'+allocObj);
                for(Sales_Order_Allocation_Line_Item__c soali : allocObj){
                    List<ProductWrapper> wrapProdListAllocated = new List<ProductWrapper>(); //full ilpli List for allocated flow
                    List<innerWrapper> innerWrapperList = new List<innerWrapper>(); 
                    Id transLineIds = soali.Order_Line__c;      
                    if(lineItemsProductsMap.containsKey(transLineIds)){ //if allocation is done for this trans Line item
                        innerWrapper iwrap = new innerWrapper(null,null,null,null,null,null,null,null,null,null,null,null,null);                        
                        iwrap.lotName = soali.Inventory_Location_Product_Line_Item__r.Lot__r.Name;
                        iwrap.lotExpiryDate = soali.Inventory_Location_Product_Line_Item__r.Lot__r.Expiry_Date__c;
                        
                        iwrap.ilpAvailQuantity = null;                    
                        iwrap.lotId = soali.Inventory_Location_Product_Line_Item__r.Lot__r.Id;
                        iwrap.ilpId = soali.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Id; 
                        iwrap.ilpliId = soali.Inventory_Location_Product_Line_Item__c;               
                        iwrap.locationId = soali.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Id;
                        iwrap.srNumId = soali.Inventory_Location_Product_Line_Item__r.Product_Serial_Number__c;
                        iwrap.srNumName = soali.Inventory_Location_Product_Line_Item__r.Product_Serial_Number__r.Name;
                        iwrap.selQuantity = soali.Allocated_Quantity__c;
                        iwrap.ppId = null;
                        iwrap.ppliId = null;
                        innerWrapperList.add(iwrap);
                        wrapProdListAutopicked.add(new ProductWrapper(orderId,null,transLineIds,lineItemsProductsMap.get(transLineIds),null, null,null,null,null,true,false,innerWrapperList));              
                        system.debug('wrapProdListAutopicked::'+wrapProdListAutopicked);
                    }
                }
                //ends here 
            }catch(Exception e){
                
                return null;
            }
        }
        return wrapProdListAutopicked;
    }*/
    //ends here
    
    //added to get product ilpli list during select(manual) flow
  /*  @AuraEnabled
    public static List<ProductWrapper> getManualStock(String orderId, String transLineId){      
        List<Product_Order_Price_Book__c> OrderLineList;    
        List<ProductWrapper> wrapProdListManual = new List<ProductWrapper>(); //full ilpli List for Manual flow        
        Map<Id,Id> transLineItemsProduct = new Map<Id,Id>(); //used to store ProductId and its transLineItemid 
        Map<Id,Decimal> prodMap = new Map<Id,Decimal>();
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('Product2')

        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'Id','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Id','sigmaerpdev__Allocation_Done__c','sigmaerpdev__Allocated_Quantity__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Quantity__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'id','name','sigmaerpdev__Product__c','sigmaerpdev__Available_Quantity__c','sigmaerpdev__Expiry_Date__c','sigmaerpdev__Lot__r.Name','sigmaerpdev__Lot__r.Id','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Name','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Id','sigmaerpdev__Inventory_Location_Product__r.Id','sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Product_Serial_Number__r.Name','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Serial_Number__c','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Status__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'id','name','sigmaerpdev__Attribute_Type__c'})
        )
        {
            
            OrderLineList = [Select Id,Product__c,Product__r.Id,Allocation_Done__c,Allocated_Quantity__c,Product__r.Name,Quantity__c,Sigma_Order__c,Product__r.Attribute_Type__c From Product_Order_Price_Book__c where id = :transLineId];
            
            for(Product_Order_Price_Book__c tdiList : OrderLineList){           
                transLineItemsProduct.put(tdiList.Product__r.Id,tdiList.Id);
                prodMap.put(tdiList.Product__r.Id, tdiList.Quantity__c);
            }
            
            Id ProdId;
            String prodName; 
            String status;
            String prodAttrType;
            String prodBomType;                                     
            
            //removed the inner query and querying full ilpli list to fix inner query issue returning more than 200 ilpli's for particular product
            Map<Id,List<Inventory_Location_Product_Line_Item__c>> prodILPLIListNewMap = new Map<Id,List<Inventory_Location_Product_Line_Item__c>>();
            List<Inventory_Location_Product_Line_Item__c> newIlpliList = [select id,name,Product__c,Available_Quantity__c,Expiry_Date__c,Lot__r.Name,Lot__r.Id,Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name,Inventory_Location_Product__r.Inventory_Location__r.Location__r.Id,Inventory_Location_Product__r.Id,Product_Serial_Number__c,Product_Serial_Number__r.Name,Product_Serial_Number__r.Serial_Number__c from Inventory_Location_Product_Line_Item__c where Available_Quantity__c > 0 and Product_Serial_Number__r.Status__c != 'Used' and Product__c in :prodMap.keySet()];
            for(Inventory_Location_Product_Line_Item__c ilpli1 : newIlpliList){
                if(prodILPLIListNewMap.containsKey(ilpli1.Product__c)){
                    List<Inventory_Location_Product_Line_Item__c> showILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                    showILPLI = prodILPLIListNewMap.get(ilpli1.Product__c);
                    showILPLI.add(ilpli1);
                    prodILPLIListNewMap.put(ilpli1.Product__c,showILPLI);        
                }else{
                    List<Inventory_Location_Product_Line_Item__c> showILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                    showILPLI.add(ilpli1);
                    prodILPLIListNewMap.put(ilpli1.Product__c,showILPLI);          
                }
            }
            //ends here
            
            //fetch products full ilpli list for manual selection. - added on 3/12/2017
            List<Product2> Products=new List<Product2>();
            Products=[select id,name,Attribute_Type__c from Product2 where id in : prodMap.keySet()];    
            for(Product2 prd :Products)
            {       
                List<innerWrapper> innerWrapperList = new List<innerWrapper>();                    
                
                if(transLineItemsProduct.containsKey(prd.id)){              
                    
                    prodId = prd.id;
                    prodName = prd.name;
                    prodAttrType = prd.Attribute_Type__c;
                    
                    for(Inventory_Location_Product_Line_Item__c ilpli : prodILPLIListNewMap.get(prd.id)){                                           
                        innerWrapper iwrap = new innerWrapper(null,null,null,null,null,null,null,null,null,null,null,null,null);    
                        iwrap.selQuantity = null;
                        
                        if(ilpli.Lot__r.Name == null){
                            iwrap.lotName = 'Not Available';  
                        }else{
                            iwrap.lotName = ilpli.Lot__r.Name;  
                        }
                        iwrap.lotExpiryDate = ilpli.Expiry_Date__c;
                        iwrap.ilpName = ilpli.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name;
                        iwrap.ilpAvailQuantity = ilpli.Available_Quantity__c;                    
                        iwrap.lotId = ilpli.Lot__r.Id;
                        iwrap.ilpId = ilpli.Inventory_Location_Product__r.Id; 
                        iwrap.ilpliId = ilpli.Id;
                        
                        iwrap.locationId = ilpli.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Id;                    
                        iwrap.srNumId = ilpli.Product_Serial_Number__c;
                        
                        if(ilpli.Product_Serial_Number__r.Name == null){
                            iwrap.srNumName = 'Not Available';  
                        }else{
                            
                            //added on 19/12/2017 to show Serial code instead of PSN Auto number
                            iwrap.srNumName = ilpli.Product_Serial_Number__r.Serial_Number__c;
                        }     
                        iwrap.ppId = null;
                        iwrap.ppliId = null;
                        
                        innerWrapperList.add(iwrap);
                        
                    }
                    wrapProdListManual.add(new ProductWrapper(orderId,null,transLineItemsProduct.get(prd.id),ProdId,prodName,prodMap.get(prd.id),null,prodAttrType,null,false,false,innerWrapperList));
                    
                }                                          
            }         
            //ends here
            
        }
        return wrapProdListManual;    
    }*/
    //ends here
    
    //get the remaining qty to be packaged form Order Line item
  /*  @AuraEnabled
    public static Decimal getRemainingQtyToPackage(String transLineId){
        Decimal remQty = 0;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'Id','Name','sigmaerpdev__Remaining_Qty_To_Package__c'}))
        {
            try{        
                List<Product_Order_Price_Book__c> salesOrder = [Select Id,Name,Remaining_Qty_To_Package__c From Product_Order_Price_Book__c where Id =:transLineId];   
                if(salesOrder.size() > 0){
                    remQty  = (Decimal)salesOrder[0].get('Remaining_Qty_To_Package__c');
                }
            }catch(Exception e){
                
                return null;
            }
        }
        return remQty;        
    }
    //ends here
    
    //display customer transaction for pending status page - added on 23-1-2018 
    public class transWrapperPending { 
        @AuraEnabled
        public String transName{get;set;}        
        @AuraEnabled
        public Boolean status{get;set;}         
        public Integer pageSize {get;set;}
        @AuraEnabled 
        public Integer page {get;set;}
        @AuraEnabled
        public Integer total {get;set;}
        @AuraEnabled
        public List<transItemWrapperPending> transItemsList{get;set;}   
        public transWrapperPending(String transName,Boolean status,Integer pageSize,Integer page,Integer total,List<transItemWrapperPending> transItemsList) {                      
            this.transName = transName;         
            this.status = status;       
            this.pageSize = pageSize;
            this.page = page;           
            this.total = total;
            this.transItemsList = transItemsList;       
        }       
    }
    
    public class transItemWrapperPending{
        @AuraEnabled
        public String transItemName{get;set;}               
        @AuraEnabled            
        public String prodName {get;set;}
        @AuraEnabled
        public Decimal orderedQnt{get;set;}
        @AuraEnabled
        public Decimal packagedQnt{get;set;}
        @AuraEnabled
        public Decimal remainingQnt{get;set;}       
        
        public transItemWrapperPending(String transItemName,String prodName,Decimal orderedQnt,Decimal packagedQnt,Decimal remainingQnt){
            this.transItemName = transItemName;
            this.prodName = prodName;
            this.orderedQnt = orderedQnt;
            this.packagedQnt = packagedQnt;
            this.remainingQnt = remainingQnt;
        }
    }*/
    
 /*   @AuraEnabled
    public static List<transWrapperPending> getPartiallyPackagedTransactions(String customerId, String packStatus, String selTrans)
    {        
        List<transWrapperPending> wrapTransList = new List<transWrapperPending>(); //full transaction List        
        String filterQuery = '';    
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new Set<String>{'id','name','sigmaerpdev__Account__c','sigmaerpdev__Fully_Packaged__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'name','sigmaerpdev__Product__r.Name','sigmaerpdev__Quantity__c','sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Remaining_Qty_To_Package__c'}))
            {
            try{       
                if(selTrans != null && selTrans != ''){
                    filterQuery = 'select id,name,sigmaerpdev__Account__c,sigmaerpdev__Fully_Packaged__c,(select name,sigmaerpdev__Product__r.Name,sigmaerpdev__Quantity__c,sigmaerpdev__Packaged_Quantity__c,sigmaerpdev__Remaining_Qty_To_Package__c from sigmaerpdev__Order_Lines__r) from sigmaerpdev__Sigma_Order__c where sigmaerpdev__Account__c = :customerId and Name = :selTrans order by name DESC';
                    System.debug('filterQuery==='+filterQuery);
                }else if(packStatus == 'Partially Packaged'){           
                    filterQuery = 'select id,name,sigmaerpdev__Account__c,sigmaerpdev__Fully_Packaged__c,(select name,sigmaerpdev__Product__r.Name,sigmaerpdev__Quantity__c,sigmaerpdev__Packaged_Quantity__c,sigmaerpdev__Remaining_Qty_To_Package__c from sigmaerpdev__Order_Lines__r) from sigmaerpdev__Sigma_Order__c where sigmaerpdev__Account__c = :customerId and sigmaerpdev__Fully_Packaged__c = false order by name DESC';
                }else if(packStatus == 'Fully Packaged'){
                    filterQuery = 'select id,name,sigmaerpdev__Account__c,sigmaerpdev__Fully_Packaged__c,(select name,sigmaerpdev__Product__r.Name,sigmaerpdev__Quantity__c,sigmaerpdev__Packaged_Quantity__c,sigmaerpdev__Remaining_Qty_To_Package__c from sigmaerpdev__Order_Lines__r) from sigmaerpdev__Sigma_Order__c where sigmaerpdev__Account__c = :customerId and sigmaerpdev__Fully_Packaged__c = true order by name DESC';
                }else{
                    filterQuery = 'select id,name,sigmaerpdev__Account__c,sigmaerpdev__Fully_Packaged__c,(select name,sigmaerpdev__Product__r.Name,sigmaerpdev__Quantity__c,sigmaerpdev__Packaged_Quantity__c,sigmaerpdev__Remaining_Qty_To_Package__c from sigmaerpdev__Order_Lines__r) from sigmaerpdev__Sigma_Order__c where sigmaerpdev__Account__c = :customerId order by name DESC';
                }        
                for(Sigma_Order__c trans : Database.query(filterQuery)){
                    List<transItemWrapperPending> wrapTransItemsList = new List<transItemWrapperPending>();                     
                    for(Product_Order_Price_Book__c tdiChild : trans.Order_Lines__r){
                        transItemWrapperPending transItemObj =  new transItemWrapperPending(null,null,null,null,null);
                        transItemObj.transItemName = tdiChild.name;
                        transItemObj.prodName = tdiChild.Product__r.Name;
                        transItemObj.orderedQnt = tdiChild.Quantity__c;
                        transItemObj.packagedQnt = tdiChild.Packaged_Quantity__c;
                        transItemObj.remainingQnt = tdiChild.Remaining_Qty_To_Package__c;                
                        wrapTransItemsList.add(transItemObj);
                    }  
                    system.debug('wrapTransItemsList::'+wrapTransItemsList);
                    wrapTransList.add(new transWrapperPending(trans.name,trans.Fully_Packaged__c,null,null,null,wrapTransItemsList));
                    system.debug('wrapTransList::'+wrapTransList);
                }
            }catch(Exception e){
                
                return null;
            }
        }
        return wrapTransList;
    } */
    /*
    @AuraEnabled
    public static string validatAddressStand(List<Id> stappId){
        
        List<Sigma_Order__c> sList = new List<Sigma_Order__c>();
        //if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new Set<String>{'Id','Name','sigmaerpdev__Shipping_Address__c'}))
        //{
      system.debug('stappId'+stappId);
            //sList = [select id,name,Shipping_Address__c from Sigma_Order__c where Id IN: stappId];
             sList = [select id,OrderNumber,sigmaerpdev__Shipping_Address__c from order where Id IN: stappId];
            if(!sList.isEmpty()){
                for(integer i=0;i<sList.size();i++){
                    for(integer j=0;j<sList.size() && i!=j;j++){
                        if(sList[i].Id != sList[j].Id && sList[i].Shipping_Address__c != sList[j].Shipping_Address__c){
                            return 'false';    
                        }    
                    }       
                }    
            }
      system.debug('sList::'+sList);
        //}
        
        
        return 'true';
    }*/
    //ends here
  /*@AuraEnabled
    public static string validatAddress(List<Id> stappId){
        
        List<Sigma_Order__c> sList = new List<Sigma_Order__c>();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new Set<String>{'Id','Name','sigmaerpdev__Shipping_Address__c'}))
        {
      
            sList = [select id,name,Shipping_Address__c from Sigma_Order__c where Id IN: stappId];
            if(!sList.isEmpty()){
                for(integer i=0;i<sList.size();i++){
                    for(integer j=0;j<sList.size() && i!=j;j++){
                        if(sList[i].Id != sList[j].Id && sList[i].Shipping_Address__c != sList[j].Shipping_Address__c){
                            return 'false';    
                        }    
                    }       
                }    
            }
        system.debug('sList::'+sList);
        }
        return 'true';
    }
    */    
    //code to access the one shot package from salesorder by chandana
    
 /*   @AuraEnabled
    public static Default_Parameters__c validationforAllocated()
    {
        Default_Parameters__c ppforpackage;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new Set<String>{'Id','Name','sigmaerpdev__Inventory_Status__c'})
        )
        {
            if(FLSCheckReadgetvalidationforAllocated())       
            {
                ppforpackage= [select Id, Name,Inventory_Status__c from Default_Parameters__c Limit 1];
            }
        
        }
        return ppforpackage;
        
    }
    public Static boolean FLSCheckReadgetvalidationforAllocated(){
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new Set<String>{'Id','Name','sigmaerpdev__Inventory_Status__c'})){
            return true;
        }  
        return false;
    }*/
  /*  @AuraEnabled
    public static Sigma_Order__c getorderdetails(String Ids)
    {
        Sigma_Order__c orderdetailsforpackage;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new Set<String>{'Id','Name','sigmaerpdev__Orders_Status__c','sigmaerpdev__Order_Number__c','sigmaerpdev__AccountId__r.Name','sigmaerpdev__AccountId__r.Id','sigmaerpdev__Order_Created_Via__c'}))
        {
            
            orderdetailsforpackage= [select Id, Name,Orders_Status__c,Order_Number__c,sigmaerpdev__Order_Created_Via__c,AccountId__r.Name,AccountId__r.Id from Sigma_Order__c where Id=:Ids ];
        }
        system.debug('orderdetailsforpackage::'+orderdetailsforpackage);
        return orderdetailsforpackage;
        
    }*/
  /*  @AuraEnabled
    public static Order getstandorderdetails(String Ids)
    {
        Order orderdetailsforpackage;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('Order')
        && CRUD_FLS_CheckUtility.checkReadPermission('Order',new Set<String>{'Id','sigmaerpdev__Orders_Status__c','OrderNumber','Account.Name','AccountId ','sigmaerpdev__Order_Created_Via__c'}))
        {
           orderdetailsforpackage= [select Id,sigmaerpdev__Orders_Status__c,OrderNumber,sigmaerpdev__Order_Created_Via__c,Account.Name,AccountId from order where Id=:Ids ];
           system.debug('orderdetailsforpackage1111::'+orderdetailsforpackage); 
        }
        return orderdetailsforpackage;
    }
    @AuraEnabled
    public static PackagedProducts__c getpackageproddetails(String Id)
    {
        system.debug('idddd:::'+Id);
        PackagedProducts__c ppdetailsforpackage;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'Id', 'Name','sigmaerpdev__Sigma_Order__r.id'}))
        {
            ppdetailsforpackage= [select Id, Name,Sigma_Order__r.id from PackagedProducts__c where Sigma_Order__r.id=:Id Limit 1];
            System.debug('ppdetailsforpackage--<<<-==>'+ppdetailsforpackage);
        }
        return ppdetailsforpackage;
    }*/
  /*  @AuraEnabled
    public static PackagedProducts__c getstandpackageproddetails(String Id)
    {
        PackagedProducts__c ppdetailsforpackage;
        system.debug('id--:'+Id);
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'Id', 'Name','Order__r.id'}))
        {
            ppdetailsforpackage= [select Id, Name,Order__r.id from PackagedProducts__c where Order__r.id=:Id ];
            system.debug('ppdetailsforpackage::'+ppdetailsforpackage);
        }
        return ppdetailsforpackage;
        
    }*/
/*    @AuraEnabled
    public static PackagedProducts__c checkSO(String sigmaorderObj)
    {
        PackagedProducts__c sodetailsforpackage;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'Id','Name','Sigma_Order__r.id','Sigma_Order__r.sigmaerpdev__Fully_Packaged__c'})
        )
        {
            sodetailsforpackage= new PackagedProducts__c();
            try
            {
                sodetailsforpackage= [select Id, Name,Sigma_Order__r.id,Sigma_Order__r.sigmaerpdev__Fully_Packaged__c from PackagedProducts__c where Sigma_Order__r.id=:sigmaorderObj limit 1];
            }
            catch(Exception e)
            {
                return null;
            }
        }
        return sodetailsforpackage;
    }*/
    
 /*   @AuraEnabled
    public static sigmaerpdev__Order_Usage__c CheckOrder()
    {
        sigmaerpdev__Order_Usage__c OrderTypeusage;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new Set<String>{'Id','Name','sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c'})
        )
        {
            OrderTypeusage= new sigmaerpdev__Order_Usage__c();
            try{
                OrderTypeusage= [select Id, Name,sigmaerpdev__Sigma_order__c,sigmaerpdev__Standard_object__c from sigmaerpdev__Order_Usage__c limit 1];
                System.debug('OrderTypeusage>>>>'+OrderTypeusage);  
            }
            catch(Exception e)
            {
                return null;
            }
        }
        return OrderTypeusage; 
    }*/
    //FLS CHECK FOR NEW CODE BY CHANDANA 
/*    
    public Static boolean checkflsPackagedProducts()
    {
        if(CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__PackagedProducts__c',new Set<String>{'sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__Status__c','sigmaerpdev__Auto_allocate__c','sigmaerpdev__Quantity__c'}))        
        {
            return true;
        }  
        return false;
    }*/
    // new code to add for standard object 
 /*   @AuraEnabled                                                                                     
    public static List<newPackageControllerLtng.lineItemsWrapper> getstandPackageProductsForAutoPickOrManual(String orderId) {                
        List<lineItemsWrapper> lineItemsWrapperList = new List<lineItemsWrapper>();
        
            if(CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sales_Order_Allocation_Line_Item__c')
            &&CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new Set<String>{'Id','Pricebookentry.Product2.Name','Order.sigmaerpdev__Shipping_Code__c','Pricebookentry.Product2Id','sigmaerpdev__Allocation_Done__c','sigmaerpdev__Allocated_Quantity__c','Quantity','OrderId','Order.sigmaerpdev__Shipping_Address__c','sigmaerpdev__Order_Status__c','sigmaerpdev__PartialPackQuantCompare__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'id','name','sigmaerpdev__Product__c','sigmaerpdev__Available_Quantity__c','sigmaerpdev__Expiry_Date__c','sigmaerpdev__Lot__r.Name','sigmaerpdev__Lot__r.Id','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Name','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Id','sigmaerpdev__Inventory_Location_Product__r.Id','sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Product_Serial_Number__r.Name','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Serial_Number__c','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Status__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'id','name','sigmaerpdev__Attribute_Type__c'})
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sales_Order_Allocation_Line_Item__c',new Set<String>{'Id','name','sigmaerpdev__Order_Line__c','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Product_Serial_Number__r.Name','sigmaerpdev__Inventory_Location_Product_Line_Item__c','sigmaerpdev__Location_Name__c','sigmaerpdev__Order_Line__r.sigmaerpdev__Product__c','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Lot__r.sigmaerpdev__Expiry_Date__c','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.name','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Lot__r.Name','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Name','sigmaerpdev__Allocated_Quantity__c','sigmaerpdev__Order_Line__r.sigmaerpdev__Sigma_Order__c','sigmaerpdev__Package_Status__c','sigmaerpdev__Order_Line__r.sigmaerpdev__Sigma_Order__c' ,'sigmaerpdev__Package_Status__c' })
            )
         {
            List<OrderItem> OrderLineList;     
            
            List<ProductWrapper> wrapProdListManual = new List<ProductWrapper>(); //full ilpli List for Manual flow
            Map<Id,Id> lineItemsProductsMap = new Map<Id,Id>(); //used to store transLineItemid and its ProductId
            Map<Id,Id> transLineItemsProduct = new Map<Id,Id>(); //used to store ProductId and its transLineItemid
            Map<Id,Id> lineItemsAllocationMap = new Map<Id,Id>(); //used to store transLineItemid and its soali ID
            Map<Id,Id> lineItemsManualMap = new Map<Id,Id>(); //used to store transLineItemid and its Manual ILPLI id
            Map<Id,Decimal> prodMap = new Map<Id,Decimal>();
            
            Map<Id,List<ProductWrapper>> allocationMapLineItems = new Map<Id,List<ProductWrapper>>(); //used to store transline items and its allocation list
            
            try{
               OrderLineList = [Select Id,Pricebookentry.Product2.Name,Order.sigmaerpdev__Shipping_Code__c,Pricebookentry.Product2Id,sigmaerpdev__Allocation_Done__c,sigmaerpdev__Allocated_Quantity__c,Quantity,OrderId,Order.sigmaerpdev__Shipping_Address__c From OrderItem where OrderId = :orderId and (Order_Status__c = 'Packaged' or Order_Status__c = 'Order Confirmed' or Order_Status__c = 'Delivered')  and  PartialPackQuantCompare__c= 'true' and Quantity!= 0];
                for(OrderItem tdiList : OrderLineList){
                    lineItemsProductsMap.put(tdiList.Id,tdiList.Pricebookentry.Product2Id);
                    transLineItemsProduct.put(tdiList.Pricebookentry.Product2Id,tdiList.Id);
                    prodMap.put(tdiList.Pricebookentry.Product2Id, tdiList.Quantity);
                }
                
                Id ProdId;
                String prodName; 
                String status;
                String prodAttrType;
                String prodBomType;
                
                Map<Id,List<Inventory_Location_Product_Line_Item__c>> prodILPLIListNewMap = new Map<Id,List<Inventory_Location_Product_Line_Item__c>>();
                List<Inventory_Location_Product_Line_Item__c> newIlpliList = [select id,name,Product__c,Available_Quantity__c,Expiry_Date__c,Lot__r.Name,Lot__r.Id,Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name,Inventory_Location_Product__r.Inventory_Location__r.Location__r.Id,Inventory_Location_Product__r.Id,Product_Serial_Number__c,Product_Serial_Number__r.Name,Product_Serial_Number__r.Serial_Number__c from Inventory_Location_Product_Line_Item__c where Available_Quantity__c > 0 and Product_Serial_Number__r.Status__c != 'Used' and Product__c in :prodMap.keySet()];
                for(Inventory_Location_Product_Line_Item__c ilpli1 : newIlpliList){
                    if(prodILPLIListNewMap.containsKey(ilpli1.Product__c)){
                        List<Inventory_Location_Product_Line_Item__c> showILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                        showILPLI = prodILPLIListNewMap.get(ilpli1.Product__c);
                        showILPLI.add(ilpli1);
                        prodILPLIListNewMap.put(ilpli1.Product__c,showILPLI);
                    }else{
                        List<Inventory_Location_Product_Line_Item__c> showILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                        showILPLI.add(ilpli1);
                        prodILPLIListNewMap.put(ilpli1.Product__c,showILPLI); 
                    }
                }
                //ends here
                
                //fetch products full ilpli list for manual selection. - added on 27/11/2017
                
                List<Product2> products=new List<Product2>();
                products=[select id,name,Attribute_Type__c from Product2 where id in : prodMap.keySet()];       
                for(Product2 prd :products)
                {       
                    List<innerWrapper> innerWrapperList = new List<innerWrapper>();                    
                    
                    if(transLineItemsProduct.containsKey(prd.id)){              
                        
                        prodId = prd.id;
                        prodName = prd.name;
                        prodAttrType = prd.Attribute_Type__c;
                        
                        for(Inventory_Location_Product_Line_Item__c ilpli : prodILPLIListNewMap.get(prd.id)){                 
                            
                            innerWrapper iwrap = new innerWrapper(null,null,null,null,null,null,null,null,null,null,null,null,null);    
                            iwrap.selQuantity = null;
                            if(ilpli.Lot__r.Name == null){
                                iwrap.lotName = 'Not Available';  
                            }else{
                                iwrap.lotName = ilpli.Lot__r.Name;  
                            }
                            iwrap.lotExpiryDate = ilpli.Expiry_Date__c;
                            iwrap.ilpName = ilpli.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name;
                            iwrap.ilpAvailQuantity = ilpli.Available_Quantity__c;                    
                            iwrap.lotId = ilpli.Lot__r.Id;
                            iwrap.ilpId = ilpli.Inventory_Location_Product__r.Id; 
                            iwrap.ilpliId = ilpli.Id;
                            iwrap.locationId = ilpli.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Id;
                            iwrap.srNumId = ilpli.Product_Serial_Number__c;
                            
                            if(ilpli.Product_Serial_Number__r.Name == null){
                                iwrap.srNumName = 'Not Available';  
                            }else{
                                
                                //added on 19/12/2017 to show Serial code instead of PSN Auto number
                                iwrap.srNumName = ilpli.Product_Serial_Number__r.Serial_Number__c;
                            }
                            iwrap.ppId = null;
                            iwrap.ppliId = null;
                            
                            //add only Serial Numbers which are not null
                            //commented on 5/12/2017 as ilpli without serial numbers must also be shown
                            
                            innerWrapperList.add(iwrap);
                        }
                        wrapProdListManual.add(new ProductWrapper(orderId,null,transLineItemsProduct.get(prd.id),ProdId,prodName,prodMap.get(prd.id),null,prodAttrType,null,false,false,innerWrapperList));
                        lineItemsManualMap.put(transLineItemsProduct.get(prd.id), prd.Id);
                    }                                          
                } 
                
                //ends here
                
                //ProductWrapper(Id transId, String transName, Id transItemId,Id ProdId, String ProdName, Decimal orderedQnt,String status, String prodAttributeType, List<innerWrapper> wrapProdList)
                //fetch allocated stock from soali object        
                List<Sales_Order_Allocation_Line_Item__c> allocObj = new List<Sales_Order_Allocation_Line_Item__c>();
                //need to customize the query for standered object 
                allocObj =  [select Id,name,Order_Line__c,Inventory_Location_Product_Line_Item__r.Product_Serial_Number__c,Inventory_Location_Product_Line_Item__r.Product_Serial_Number__r.Name,Inventory_Location_Product_Line_Item__c,Location_Name__c,Order_Line__r.Product__c,Inventory_Location_Product_Line_Item__r.Lot__r.Expiry_Date__c,Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.name,Inventory_Location_Product_Line_Item__r.Lot__r.Name,Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name,Allocated_Quantity__c,Order_Line__r.Sigma_Order__c,Package_Status__c from Sales_Order_Allocation_Line_Item__c where Order_Line__r.Sigma_Order__c =: orderId AND Package_Status__c != true];
                for(Sales_Order_Allocation_Line_Item__c soali : allocObj){
                    List<ProductWrapper> wrapProdListAllocated = new List<ProductWrapper>(); //full ilpli List for allocated flow
                    List<innerWrapper> innerWrapperList = new List<innerWrapper>(); 
                    Id transLineIds = soali.Order_Line__c;      
                    if(lineItemsProductsMap.containsKey(transLineIds)){ //if allocation is done for this trans Line item
                        innerWrapper iwrap = new innerWrapper(null,null,null,null,null,null,null,null,null,null,null,null,null);                        
                        iwrap.lotName = soali.Inventory_Location_Product_Line_Item__r.Lot__r.Name;
                        iwrap.lotExpiryDate = soali.Inventory_Location_Product_Line_Item__r.Lot__r.Expiry_Date__c;
                        iwrap.ilpAvailQuantity = null;                    
                        iwrap.lotId = soali.Inventory_Location_Product_Line_Item__r.Lot__r.Id;
                        iwrap.ilpId = soali.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Id; 
                        iwrap.ilpliId = soali.Inventory_Location_Product_Line_Item__c;               
                        iwrap.locationId = soali.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Id;
                        iwrap.srNumId = soali.Inventory_Location_Product_Line_Item__r.Product_Serial_Number__c;
                        iwrap.srNumName = soali.Inventory_Location_Product_Line_Item__r.Product_Serial_Number__r.Name;
                        iwrap.selQuantity = soali.Allocated_Quantity__c;
                        iwrap.ppId = null;
                        iwrap.ppliId = null;
                        innerWrapperList.add(iwrap);
                        lineItemsAllocationMap.put(transLineIds, soali.Id);
                        
                        if(allocationMapLineItems.containsKey(transLineIds)){
                            List<ProductWrapper> interimList = allocationMapLineItems.get(transLineIds);
                            interimList.add(new ProductWrapper(orderId,null,transLineIds,lineItemsProductsMap.get(transLineIds),null, null,null,null,null,false,false,innerWrapperList));                   
                            allocationMapLineItems.put(transLineIds,interimList);    
                        }else{
                            List<ProductWrapper> newList = new List<ProductWrapper>();
                            newList.add(new ProductWrapper(orderId,null,transLineIds,lineItemsProductsMap.get(transLineIds),null, null,null,null,null,false,false,innerWrapperList));
                            allocationMapLineItems.put(transLineIds,newList);  
                        }
                        
                    }
                    
                }
                //ends here             
                
                for(OrderItem tdi : OrderLineList){
                    System.debug('tdi.Id=='+tdi.Id);
                    lineItemsWrapper lineItems = new lineItemsWrapper();
                    lineItems.packProd =  new PackagedProducts__c();
                    lineItems.prodName = tdi.Pricebookentry.Product2.Name;
                    lineItems.prodId = tdi.Pricebookentry.Product2Id;
                    lineItems.transLineItemId = tdi.Id;         
                    lineItems.orderedQnt = tdi.Quantity;          
                    
                    //changed on 4/12/2017 - these values will be filled up from lightning component
                    lineItems.packProd.Product_Order__c = tdi.Id;
                    lineItems.packProd.Auto_allocate__c = false;
                    lineItems.allocatedQnty = 0;
                    lineItems.shipQty = tdi.Order.Shipping_Code__c;
                    lineItems.shipAdd = tdi.Order.Shipping_Address__c;
                    lineItems.isSelected = false;
                    
                    List<ProductWrapper> wrapProdListEmpty = new List<ProductWrapper>(); //add empty list to prodWrap
                    lineItems.prodwrap = wrapProdListEmpty;
                    lineItemsWrapperList.add(lineItems);
                } 
                System.debug('lineItemsWrapperList===>'+lineItemsWrapperList);        
            }catch(Exception e){            
                
                return null;
            }
        }
        return lineItemsWrapperList;        
    }
    */
 /*   //listing the ilpli for manual select 
    @AuraEnabled
    public static List<ProductWrapper> getstandManualStock(String orderId, String transLineId){      
        List<OrderItem> OrderLineList;    
        List<ProductWrapper> wrapProdListManual = new List<ProductWrapper>(); //full ilpli List for Manual flow        
        Map<Id,Id> transLineItemsProduct = new Map<Id,Id>(); //used to store ProductId and its transLineItemid 
        Map<Id,Decimal> prodMap = new Map<Id,Decimal>();
                        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
            && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new Set<String>{'Id','Pricebookentry.Product2.Name','Pricebookentry.Product2Id','sigmaerpdev__Allocation_Done__c','sigmaerpdev__Allocated_Quantity__c','Quantity','OrderId','PriceBookEntry.Product2.sigmaerpdev__Attribute_Type__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'id','name','sigmaerpdev__Product__c','sigmaerpdev__Available_Quantity__c','sigmaerpdev__Expiry_Date__c','sigmaerpdev__Lot__r.Name','sigmaerpdev__Lot__r.Id','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Name','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Id','sigmaerpdev__Inventory_Location_Product__r.Id','sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Product_Serial_Number__r.Name','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Serial_Number__c','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Status__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'id','name','sigmaerpdev__Attribute_Type__c'})
          )
        
        {
            
            OrderLineList = [Select Id,Pricebookentry.Product2.Name,Pricebookentry.Product2Id,Allocation_Done__c,Allocated_Quantity__c,Quantity,OrderId,PriceBookEntry.Product2.sigmaerpdev__Attribute_Type__c From OrderItem where id = :transLineId];
            for(OrderItem tdiList : OrderLineList)
            {           
                transLineItemsProduct.put(tdiList.Pricebookentry.Product2Id,tdiList.Id);
                prodMap.put(tdiList.Pricebookentry.Product2Id, tdiList.Quantity);
            }
            Id ProdId;
            String prodName; 
            String status;
            String prodAttrType;
            String prodBomType;                                     
            
            //removed the inner query and querying full ilpli list to fix inner query issue returning more than 200 ilpli's for particular product
            Map<Id,List<Inventory_Location_Product_Line_Item__c>> prodILPLIListNewMap = new Map<Id,List<Inventory_Location_Product_Line_Item__c>>();
            List<Inventory_Location_Product_Line_Item__c> newIlpliList = [select id,name,Product__c,Available_Quantity__c,Expiry_Date__c,Lot__r.Name,Lot__r.Id,Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name,Inventory_Location_Product__r.Inventory_Location__r.Location__r.Id,Inventory_Location_Product__r.Id,Product_Serial_Number__c,Product_Serial_Number__r.Name,Product_Serial_Number__r.Serial_Number__c from Inventory_Location_Product_Line_Item__c where Available_Quantity__c > 0 and Product_Serial_Number__r.Status__c != 'Used' and Product__c in :prodMap.keySet()];
            for(Inventory_Location_Product_Line_Item__c ilpli1 : newIlpliList){
                if(prodILPLIListNewMap.containsKey(ilpli1.Product__c)){
                    List<Inventory_Location_Product_Line_Item__c> showILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                    showILPLI = prodILPLIListNewMap.get(ilpli1.Product__c);
                    showILPLI.add(ilpli1);
                    prodILPLIListNewMap.put(ilpli1.Product__c,showILPLI);  
                    
                }else{
                    List<Inventory_Location_Product_Line_Item__c> showILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                    showILPLI.add(ilpli1);
                    prodILPLIListNewMap.put(ilpli1.Product__c,showILPLI);  
                }
            }
            //ends here
            
            //fetch products full ilpli list for manual selection. - added on 3/12/2017
            
            List<Product2> Products=new List<Product2>();
            Products=[select id,name,Attribute_Type__c from Product2 where id in : prodMap.keySet()];    
            for(Product2 prd :Products)
            {       
                List<innerWrapper> innerWrapperList = new List<innerWrapper>();                    
                
                if(transLineItemsProduct.containsKey(prd.id)){              
                    
                    prodId = prd.id;
                    prodName = prd.name;
                    prodAttrType = prd.Attribute_Type__c;
                    
                    for(Inventory_Location_Product_Line_Item__c ilpli : prodILPLIListNewMap.get(prd.id)){                                           
                        innerWrapper iwrap = new innerWrapper(null,null,null,null,null,null,null,null,null,null,null,null,null);    
                        iwrap.selQuantity = null;
                        
                        if(ilpli.Lot__r.Name == null){
                            iwrap.lotName = 'Not Available';  
                        }else{
                            iwrap.lotName = ilpli.Lot__r.Name;  
                        }
                        iwrap.lotExpiryDate = ilpli.Expiry_Date__c;
                        iwrap.ilpName = ilpli.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name;
                        iwrap.ilpAvailQuantity = ilpli.Available_Quantity__c;                    
                        iwrap.lotId = ilpli.Lot__r.Id;
                        iwrap.ilpId = ilpli.Inventory_Location_Product__r.Id; 
                        iwrap.ilpliId = ilpli.Id;
                        iwrap.locationId = ilpli.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Id;                    
                        iwrap.srNumId = ilpli.Product_Serial_Number__c;
                        if(ilpli.Product_Serial_Number__r.Name == null){
                            iwrap.srNumName = 'Not Available';  
                        }else{
                            
                            //added on 19/12/2017 to show Serial code instead of PSN Auto number
                            iwrap.srNumName = ilpli.Product_Serial_Number__r.Serial_Number__c;
                        }     
                        iwrap.ppId = null;
                        iwrap.ppliId = null;
                        innerWrapperList.add(iwrap);
                    }
                    wrapProdListManual.add(new ProductWrapper(orderId,null,transLineItemsProduct.get(prd.id),ProdId,prodName,prodMap.get(prd.id),null,prodAttrType,null,false,false,innerWrapperList));
                 
                }                                          
            }         
            //ends here   
        }
        return wrapProdListManual;    
    }*/
    //ends here
    
    //10-08-2018
    //new code to edit the package for standerd object 
    //save autopick or manual edit flow
 /*       @AuraEnabled    
    public static Package__c savestandEditedAutoPickorManualPackage(String packageObjs, String packageProducts)
    {   
        Map<Id,Decimal> transIdAndPackagedQty = new Map<Id,Decimal>(); 
        List<Id> productsList = new List<Id>(); //added to use while updating Inv. Location      
        Package__c packageObj;
        List<newPackageControllerLtng.MainWrapper> container = (List<newPackageControllerLtng.MainWrapper>)System.JSON.deserialize(packageProducts,List<newPackageControllerLtng.MainWrapper>.class);                
         
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
        && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package_Product_Line_Item__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Lot_Product__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Lot__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Serial_Number__c')
        
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new Set<String>{'Id','sigmaerpdev__Status__c','sigmaerpdev__PackagedDate__c','sigmaerpdev__PackagedBy__c','sigmaerpdev__Instructions__c','sigmaerpdev__Location__c','sigmaerpdev__Customer__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Package__c',new Set<String>{'sigmaerpdev__Customer__c','sigmaerpdev__Location__c','sigmaerpdev__PackagedBy__c','sigmaerpdev__Instructions__c','sigmaerpdev__Status__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('Order',new Set<String>{'Id','name','sigmaerpdev__Fully_Packaged__c'})
        && CRUD_FLS_CheckUtility.checkFLS('Order',new Set<String>{'sigmaerpdev__Fully_Packaged__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new Set<String>{'Id','sigmaerpdev__PartialPackQuantCompare__c','sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Remaining_Qty_To_Package__c','Quantity'})
        && CRUD_FLS_CheckUtility.checkFLS('OrderItem',new Set<String>{'sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Remaining_Qty_To_Package__c','Quantity'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package_Product_Line_Item__c',new Set<String>{'Id','Name','sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__Location__c','sigmaerpdev__Quantity__c','sigmaerpdev__Lot__c','sigmaerpdev__Inventory_Location_Product_Line_Item__c','sigmaerpdev__Expiry_Date__c','sigmaerpdev__Status__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Products__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Products__r.sigmaerpdev__Attribute_Type__c','sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Product_Serial_Number__r.Name','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Serial_Number__c','sigmaerpdev__Packaged_Product__c','sigmaerpdev__Packaged_Product__r.sigmaerpdev__Via_Autopick__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Package_Product_Line_Item__c',new Set<String>{'sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__Location__c','sigmaerpdev__Quantity__c','sigmaerpdev__Lot__c','sigmaerpdev__Inventory_Location_Product_Line_Item__c','sigmaerpdev__Expiry_Date__c','sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Status__c'})
        && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Package_Product_Line_Item__c',new Set<String>{'sigmaerpdev__Packaged_Product__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'sigmaerpdev__Auto_allocate__c','sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Via_Autopick__c','sigmaerpdev__Order__c','sigmaerpdev__Order_Product__c','sigmaerpdev__Status__c','sigmaerpdev__Package__c','sigmaerpdev__Lot__c','sigmaerpdev__Location__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__PackagedProducts__c',new Set<String>{'sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Via_Autopick__c','sigmaerpdev__Order__c','sigmaerpdev__Order_Product__c','sigmaerpdev__Status__c','sigmaerpdev__Package__c','sigmaerpdev__Lot__c','sigmaerpdev__Location__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'Id','Name','sigmaerpdev__Products__c','sigmaerpdev__Inventory_Location_Name__c','sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev__Delivered_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Lot_Product__c',new Set<String>{'Id','Name','sigmaerpdev__Location__c','sigmaerpdev__Quantity__c','sigmaerpdev__Lot__c','sigmaerpdev__Product__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Lot_Product__c',new Set<String>{'sigmaerpdev__Quantity__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Lot__c',new Set<String>{'Id','Name','sigmaerpdev__Product__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'Id','sigmaerpdev__Status__c','sigmaerpdev__Serial_Number__c','sigmaerpdev__Package_Status__c','sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Quantity__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'sigmaerpdev__Status__c','sigmaerpdev__Package_Status__c'})
        && Schema.sObjectType.sigmaerpdev__Package__c.fields.Id.isAccessible()
        && Schema.sObjectType.sigmaerpdev__PackagedProducts__c.fields.Id.isAccessible()
        && Schema.sObjectType.OrderItem.fields.Id.isAccessible()
        )
        {
            
           try{
                 packageObj=new Package__c();
                Object packagevalue = (Object)System.JSON.deserializeUntyped(packageObjs);
                String packagedes = JSON.serialize(packagevalue);
                Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(packagedes);
                //new code added 11-06-2018
                packageObj.Id = String.valueOf(root.get('Id'));
                
                if(root.get('sigmaerpdev__Customer__c')!=null)
                {
                    packageObj.Customer__c= String.valueOf(root.get('sigmaerpdev__Customer__c'));
                }
                if(root.get('sigmaerpdev__Location__c') !=null)
                {
                    
                    packageObj.Location__c = String.valueOf(root.get('sigmaerpdev__Location__c'));
                }
                if(root.get('sigmaerpdev__Instructions__c') !=null)
                {
                    
                    packageObj.Instructions__c = String.valueOf(root.get('sigmaerpdev__Instructions__c'));
                }
                if(root.get('sigmaerpdev__PackagedBy__c') !=null)
                {
                    
                    packageObj.PackagedBy__c = String.valueOf(root.get('sigmaerpdev__PackagedBy__c'));
                }
                if(root.get('sigmaerpdev__PackagedDate__c') !=null)
                {
                    System.debug('inside lot root');
                    
                }
                if(root.get('sigmaerpdev__Status__c') !=null)
                {
                    
                    packageObj.Status__c = String.valueOf(root.get('sigmaerpdev__Status__c'));
                }
                update packageObj;  
                
                if(container != null){
                    List<ProductWrapper> AllData = new List<ProductWrapper>();
                    String transPackStatus = '';
                    String transId = '';
                    Decimal allocatedOrPackageQnty = 0;
                    Boolean isSelectedForPackage = false;
                    for(newPackageControllerLtng.MainWrapper temp :container){          
                        transPackStatus = temp.status;
                        transId = temp.transId;
                        
                        for(lineItemsWrapper liwrap : temp.lineItemsList){
                            if(liwrap.isSelected)
                            {
                                //add the product to package products only if isSelected is checked ()i.e. from UI checkbox during Packaging)
                                isSelectedForPackage = liwrap.isSelected;
                                allocatedOrPackageQnty = liwrap.allocatedQnty;
                                
                                Boolean viaAutopick = liwrap.packProd.Auto_allocate__c;                  
                                for(ProductWrapper p1 : liwrap.prodwrap){
                                    List<innerWrapper> innerListData = new List<innerWrapper>();
                                    
                                    for(innerWrapper temp1 : p1.wrapProdList){
                                        if(temp1.selQuantity != null && temp1.selQuantity != 0){                            
                                            innerListData.add(new innerWrapper(temp1.selQuantity,temp1.srNumId,temp1.lotName,temp1.lotExpiryDate,temp1.ilpName,temp1.ilpAvailQuantity,temp1.lotId,temp1.ilpId,temp1.ilpliId,temp1.locationId,temp1.srNumName,temp1.ppId,temp1.ppliId));
                                        }                       
                                        
                                    }
                                    AllData.add(new ProductWrapper(transId,p1.transName,p1.transItemId,p1.prodId,p1.prodName,p1.recvQnt,transPackStatus,p1.prodAttributeType,allocatedOrPackageQnty,viaAutopick,isSelectedForPackage,
                                                                   innerListData));
                                    productsList.add(p1.prodId);                    
                                }
                            }  
                        }
                    }
                    List<PackagedProducts__c> packageProductList = [select id from PackagedProducts__c where Package__c = :packageObj.Id and Status__c != 'Ready'];     
                    if(PackagedProducts__c.sObjectType.getDescribe().isDeletable())     
                    {
                        delete packageProductList;
                    }
                    List<PackagedProducts__c> packProdList = new List<PackagedProducts__c>();
                    Set<ID> packProdIDList = new Set<ID>();
                    Map<Id,List<Package_Product_Line_Item__c>> PPLIMap = new Map<Id,List<Package_Product_Line_Item__c>>();        
                    for(ProductWrapper temp :AllData)
                    {
                        List<Package_Product_Line_Item__c> PPLIList = new List<Package_Product_Line_Item__c>();
                        
                        PackagedProducts__c tempPackProdObje = new PackagedProducts__c();
                        List<innerWrapper> innerData = temp.wrapProdList;
                       
                        for(innerWrapper PLIL :innerData)
                        {
                            Package_Product_Line_Item__c PPLI = new Package_Product_Line_Item__c();
                            PPLI.Inventory_Location_Product__c = PLIL.ilpId;
                            PPLI.Location__c = PLIL.locationId;
                            PPLI.Quantity__c = PLIL.selQuantity;
                            PPLI.Lot__c = PLIL.lotId;
                            PPLI.Inventory_Location_Product_Line_Item__c = PLIL.ilpliId;
                            PPLI.Expiry_Date__c = PLIL.lotExpiryDate;
                            PPLI.Product_Serial_Number__c = PLIL.srNumId; 
                            PPLIList.add(PPLI);
                            //code to fix the issue - if there is two ilpli allocated for the same transaction line item                
                            
                            if(PPLIMap.ContainsKey(temp.transItemId))
                            {
                                List<Package_Product_Line_Item__c> interimList = PPLIMap.get(temp.transItemId);
                                interimList.add(PPLI);
                                PPLIMap.put(temp.transItemId,interimList);
                            }
                            else
                            {
                                List<Package_Product_Line_Item__c> newList = new List<Package_Product_Line_Item__c>();
                                newList.add(PPLI);
                                PPLIMap.put(temp.transItemId,newList);
                                
                            }
                            //ends here             
                        }
                        
                        tempPackProdObje.Product__c = temp.prodId;
                        tempPackProdObje.Quantity__c = temp.allocatedOrPackageQnty;  //changed on 23-11-2017          
                        tempPackProdObje.Via_Autopick__c = temp.allocatedViaAutopickOrManual;  //changed on 23-11-2017 
                        tempPackProdObje.Order__c = temp.transId;
                        tempPackProdObje.Order_Product__c = temp.transItemId;
                        System.debug('Status.........'+temp.status);
                        tempPackProdObje.Status__c = temp.status; //added for status
                        tempPackProdObje.Package__c = packageObj.Id;
                        //new code added by chandana to update in package product 
                        for(innerWrapper PPrd :innerData)
                        {
                            tempPackProdObje.Lot__c= PPrd.lotId;
                            tempPackProdObje.Location__c= PPrd.locationId;
                        }
                        PackProdList.add(tempPackProdObje);
                    }
                    //code to fix the issue - multiple package products for the same product if its quantity was more than 1
                    Set<PackagedProducts__c> finalSet = new Set<PackagedProducts__c>();
                    List<PackagedProducts__c> result = PackProdList;
                    finalSet.addAll(result);
                    result.clear();
                    PackProdList.clear();
                    result.addAll(finalSet);
                    PackProdList = result;
                    insert PackProdList;
                    List<Package_Product_Line_Item__c> PPLIInsertList = new List<Package_Product_Line_Item__c> ();  
                    for(PackagedProducts__c var :PackProdList)
                    {
                        
                        packProdIDList.add(var.Product__c);
                        if(PPLIMap.containsKey(var.Order_Product__c))
                        {
                            List<Package_Product_Line_Item__c> tempPPLIList = PPLIMap.get(var.Order_Product__c);
                            
                            for(Package_Product_Line_Item__c var1 :tempPPLIList)
                            {                    
                                var1.Packaged_Product__c =  var.Id;
                                var1.Status__c = var.Status__c;
                                PPLIInsertList.add(var1);                    
                            }
                        }
                    }      
                    insert PPLIInsertList;
                    
                    //added on 27/12/2017 to update packaged qty and remaining qty on order line items to provide partial packaging
                    Set<Id> transactionIdList = new Set<Id>();
                    List<PackagedProducts__c> packageProdList1;
                    
                    packageProdList1 = [select id,sigmaerpdev__Order__c,Order_Product__c,Quantity__c from 
                                        PackagedProducts__c where Package__c = :packageObj.Id
                                        and Status__c = 'Ready'];
                    for(PackagedProducts__c ppListIterate : packageProdList1)
                    {
                        transIdAndPackagedQty.put(ppListIterate.Order_Product__c,ppListIterate.Quantity__c);
                        transactionIdList.add(ppListIterate.Order__c);
                    }       
                    if(transIdAndPackagedQty.size() > 0){
                        List<OrderItem> transLineItemsList;  
                        List<OrderItem> transLineObjList = new List<OrderItem>();
                        
                        transLineItemsList = [Select Id,Packaged_Quantity__c,Remaining_Qty_To_Package__c,Quantity From OrderItem where Id IN :transIdAndPackagedQty.keySet()];
                        
                        for(OrderItem tdi : transLineItemsList){
                            OrderItem tdiObj = new OrderItem();                            
                            
                            if(tdi.Packaged_Quantity__c == 0){
                                
                                tdiObj.Packaged_Quantity__c = transIdAndPackagedQty.get(tdi.Id);
                            }else{
                                
                                if(tdi.Packaged_Quantity__c != null){
                                    tdiObj.Packaged_Quantity__c = tdi.Packaged_Quantity__c  + transIdAndPackagedQty.get(tdi.Id);  
                                }                    
                            }   
                            if(tdi.Packaged_Quantity__c != null){
                                tdiObj.Remaining_Qty_To_Package__c = tdi.Quantity - tdiObj.Packaged_Quantity__c;
                            }                    
                            tdiObj.Id = tdi.Id;
                            transLineObjList.add(tdiObj);                
                        }
                        
                        update transLineObjList; //update trans line item list
                        
                        //new code added to check if any order line items are partially packaged and accordingly set the packageDone flag to true or false
                        List<Id> transIdListNew = new List<Id>(transactionIdList);
                        
                        List<Order>  newTransFinalList = new List<Order>();            
                        Map<Id,Boolean> packagedTransMap = new Map<Id,Boolean>();
                        newTransFinalList = [select Id,name,(select id,OrderId,PartialPackQuantCompare__c from OrderItems)from Order where Id in :transIdListNew];
                        for(Order transIdNew : newTransFinalList){
                            Boolean packageDone = true; 
                            for(OrderItem tdiChild : transIdNew.OrderItems){
                                if(tdiChild.PartialPackQuantCompare__c == 'true'){
                                    packageDone = false;
                                }
                            }
                            packagedTransMap.put(transIdNew.Id,packageDone); 
                        }
                        //ends here         
                        //update transaction field - fully packaged status to true if sigma order's line items[all line items] are packaged fully
                        List<Order> interimTransactionList = new List<Order>();
                        interimTransactionList = [select id,Fully_Packaged__c from Order where id in :packagedTransMap.keySet()];
                        List<Order> updatingTransactionList = new List<Order>();
                        for(Order tempIterate : interimTransactionList){
                            
                            if(packagedTransMap.get(tempIterate.id) == true){
                                Order tempTrans = new Order();
                                tempTrans.id = tempIterate.id; 
                                tempTrans.Fully_Packaged__c = true;
                                updatingTransactionList.add(tempTrans);
                            }               
                        }
                        update updatingTransactionList;
                        //ends here            
                    }
                    //ends here
                    
                    Set<Id> LocationIDSet = new Set<Id>();
                    for(Package_Product_Line_Item__c pp :PPLIInsertList)
                    {
                        LocationIDSet.add(pp.Location__c);
                    }
                    //added on 3-10-2017 to update ILP
                    List<Inventory_Location_Product__c> invProdLocList;
                    List<Inventory_Location_Product__c> ILPList = new List<Inventory_Location_Product__c>();
                    List<Id> ILPLIIDList = new List<Id>();
                    
                    invProdLocList = [Select Id,Name,Products__c,Inventory_Location_Name__c,
                                      Delivered_Quantity__c From Inventory_Location_Product__c where Products__c IN:productsList and Inventory_Location__r.Location__c IN :LocationIDSet];
                    
                    
                    for(Package_Product_Line_Item__c pp :PPLIInsertList){            
                        ILPLIIDList.add(pp.Id);         
                    }
                    
                    List<Package_Product_Line_Item__c> packProdLineList;
                    Map<Id,Integer> ILPReduceQtyMap = new Map<Id,Integer>();
                    Map<Id,Integer> LotReduceQtyMap = new Map<Id,Integer>();
                    Set<ID> AllocatePSNIDSet = new Set<ID>(); 
                    Map<Id,Integer> AllocatePSNMap = new Map<Id,Integer>();
                    
                    packProdLineList = [Select Id,Name,Lot__c,Expiry_Date__c,Inventory_Location_Product__c,Location__c,Inventory_Location_Product__r.Inventory_Location__c,Quantity__c,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Attribute_Type__c,Status__c,Product_Serial_Number__c,Product_Serial_Number__r.Name,Product_Serial_Number__r.Serial_Number__c,Packaged_Product__c,Inventory_Location_Product_Line_Item__c From Package_Product_Line_Item__c where Id IN:ILPLIIDList];
                    for(Package_Product_Line_Item__c pp :packProdLineList){            
                        if(pp.Status__c=='Ready'){
                            
                            if(!LotReduceQtyMap.containsKey(pp.Lot__c))
                            {
                                LotReduceQtyMap.put(pp.Lot__c,Integer.valueOf(pp.Quantity__c));
                            }else
                            {
                                Integer qty = LotReduceQtyMap.get(pp.Lot__c);
                                LotReduceQtyMap.put(pp.Lot__c,(qty + Integer.valueOf(pp.Quantity__c)));
                            }
                            if(pp.Inventory_Location_Product__r.Products__r.Attribute_Type__c=='SERIALIZED')
                            {
                                AllocatePSNIDSet.add(pp.Product_Serial_Number__c);
                                if(!AllocatePSNMap.containsKey(pp.Product_Serial_Number__c))
                                {
                                    AllocatePSNMap.put(pp.Product_Serial_Number__c,Integer.valueOf(pp.Quantity__c));
                                }
                            }                
                        }        
                    }
                    
                    //added to reduce ILP and ILPLI quantities during package for manual selection - added on 5/12/2017
                    List<Id> packProdIdListForManual  = new List<Id>();
                    for(PackagedProducts__c ppId :PackProdList){            
                        packProdIdListForManual.add(ppId.Id);            
                    }
                    Map<Id,Integer> ILPReduceQtyMapForManual = new Map<Id,Integer>(); //used to store ILP and the quantity to be reduced 
                    Map<Id,Integer> ILPLIReduceQtyMapForManual = new Map<Id,Integer>(); //used to store ILP and the quantity to be reduced 
                    List<Inventory_Location_Product__c> fullILPList;        
                    List<Package_Product_Line_Item__c> packProdLineList1;
                    List<Inventory_Location_Product_Line_Item__c> fullILPLIList;
                    List<Inventory_Location_Product_Line_Item__c> ILPLIListToUpdate = new List<Inventory_Location_Product_Line_Item__c>();
                    packProdLineList1 = [Select Id,Name,Lot__c,Expiry_Date__c,Inventory_Location_Product__c,Location__c,
                                         Inventory_Location_Product__r.Inventory_Location__c,Quantity__c,
                                         Inventory_Location_Product__r.Products__c,
                                         Inventory_Location_Product__r.Products__r.Attribute_Type__c,Status__c,
                                         Product_Serial_Number__c,Product_Serial_Number__r.Name,
                                         Product_Serial_Number__r.Serial_Number__c,Packaged_Product__c,
                                         Inventory_Location_Product_Line_Item__c From Package_Product_Line_Item__c  
                                         where Packaged_Product__r.Via_Autopick__c = false and 
                                         Packaged_Product__c IN : packProdIdListForManual];
                    
                    for(Package_Product_Line_Item__c pp1 :packProdLineList1){
                        
                        if(pp1.Status__c=='Ready'){
                            if(!ILPReduceQtyMapForManual.containsKey(pp1.Inventory_Location_Product__c)){
                                ILPReduceQtyMapForManual.put(pp1.Inventory_Location_Product__c,Integer.valueOf(pp1.Quantity__c));
                            }else{
                                Integer qty1 = ILPReduceQtyMapForManual.get(pp1.Inventory_Location_Product__c);
                                
                                ILPReduceQtyMapForManual.put(pp1.Inventory_Location_Product__c,(qty1 + Integer.valueOf(pp1.Quantity__c)));
                            } 
                            ILPLIReduceQtyMapForManual.put(pp1.Inventory_Location_Product_Line_Item__c,Integer.valueOf(pp1.Quantity__c)); //store selected ILPLI ids and quantity
                        }    
                    }
                    
                    fullILPList = [Select Id,Name,Products__c,Inventory_Location_Name__c,
                                   Delivered_Quantity__c From Inventory_Location_Product__c where Id IN :ILPReduceQtyMapForManual.keySet()];
                    
                    for(Inventory_Location_Product__c ilp : fullILPList){
                        Inventory_Location_Product__c ilpObj = new Inventory_Location_Product__c(); 
                        if(ILPReduceQtyMapForManual.containsKey(ilp.Id)){ 
                            
                            ilpObj.Delivered_Quantity__c = ilp.Delivered_Quantity__c + ILPReduceQtyMapForManual.get(ilp.Id);
                            ilpObj.Id = ilp.Id;
                            ILPList.add(ilpObj);
                        }    
                    }
                    
                    update ILPList; //update ILP list
                    
                    fullILPLIList = [Select Id,Name,Inventory_Location_Product__c,Reserved_Quantity__c 
                                     From Inventory_Location_Product_Line_Item__c where Id IN :ILPLIReduceQtyMapForManual.keySet()];
                    for(Inventory_Location_Product_Line_Item__c ilpli : fullILPLIList){
                        Inventory_Location_Product_Line_Item__c ilpliObj = new Inventory_Location_Product_Line_Item__c(); 
                        if(ILPLIReduceQtyMapForManual.containsKey(ilpli.Id)){ 
                            
                            ilpliObj.Reserved_Quantity__c = ilpli.Reserved_Quantity__c + ILPLIReduceQtyMapForManual.get(ilpli.Id);
                            ilpliObj.Id = ilpli.Id;
                            ILPLIListToUpdate.add(ilpliObj);
                        }    
                    }
                    update ILPLIListToUpdate; //update ILPLI list
                    //ends here
                    //added to upsert lot product on 4-10-2017
                    
                    List<Lot_Product__c> lotProductsList = new List<Lot_Product__c>();
                    Map<String,List<Lot_Product__c>> lotMap = new Map<String,List<Lot_Product__c>>();
                    List<Lot__c> lotList;
                    if(FLSCheckReadPremissionLot() == true && FLSCheckReadPremissionLotProduct() == true){      
                        lotList = [Select Id,Name,Product__c,(Select Id,Name,Location__c,Quantity__c,Lot__c,Product__c From Lot_Products__r) From Lot__c where Product__c IN :packProdIDList];
                        
                    }   
                    for(Lot__c lt:lotList){
                        
                        for(Lot_Product__c LP:lt.Lot_Products__r)
                        {
                            
                            if(LotReduceQtyMap.containsKey(lp.Lot__c))  
                            {
                                
                                LP.Quantity__c = LP.Quantity__c - LotReduceQtyMap.get(lp.Lot__c);
                                
                                lotProductsList.add(LP);
                            }
                        }
                        lotMap.put(lt.Id,lt.Lot_Products__r);
                    }   
                    if(FLSCheckLotProduct() == true){
                        update lotProductsList;  
                    }
                    //code to allocate PSN        
                    if(AllocatePSNIDSet.size() > 0)
                    {
                        
                        List<Product_Serial_Number__c> updatePSNList = [select Id,Status__c,Serial_Number__c,Package_Status__c,Quantity__c from Product_Serial_Number__c where Status__c ='Available' and Package_Status__c=false and ID IN:AllocatePSNIDSet]; 
                        if(updatePSNList.size() > 0)
                        {
                            for(Product_Serial_Number__c var :updatePSNList)
                            {
                                if(AllocatePSNMap.containsKey(var.Id))
                                {
                                    var.Status__c = 'Used';
                                    var.Package_Status__c = True;
                                }
                            }
                            update updatePSNList;
                        }
                    } 
                    //ends here
                } //end of (container != null) if loop
            }catch(Exception e){            
                system.debug('exception>>>'+e.getMessage());
                system.debug('exception>>>'+e.getLineNumber());
                return null;
            }
        }       
        return packageObj;
    }*/
    //get the remaining qty to be packaged form Order Line item 
/*    @AuraEnabled
    public static Decimal getstandRemainingQtyToPackage(String transLineId)
    {
        Decimal remQty = 0;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
        &&CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new Set<String>{'Id','sigmaerpdev__Remaining_Qty_To_Package__c'}))
        {
            try{        
                List<OrderItem> salesOrder = [Select Id,Remaining_Qty_To_Package__c From OrderItem where Id =:transLineId];   
                if(salesOrder.size() > 0){
                    remQty  = (Decimal)salesOrder[0].get('Remaining_Qty_To_Package__c');
                }
            }catch(Exception e){
                
                return null;
            }
        }
        return remQty;   
    }*/
 /*   @AuraEnabled
    public static List<newPackageControllerLtng.MainWrapper> getPackageProductsstandForEditAutoPickOrManual(String packageId)
    {    
        system.debug('inside pack edit flow ');
        Package__c packge;
        Id transactionId;
        String transName;
        Map<Id,String> transIdAndNameMap = new Map<Id,String>(); //used to store transactions Id and its name
        Map<Id,String> transIdAndStatusMap = new Map<Id,String>(); //used to store transactions Id and its status
        Map<Id,Id> transLineIdMap = new Map<Id,Id>(); //used to store transactions line items from package products
        Map<Id,Id> transMap = new Map<Id,Id>(); //used to store transactions from package products      
        List<OrderItem> OrderLineList;             
        List<ProductWrapper> wrapProdListManual = new List<ProductWrapper>(); //full ilpli List for Manual flow
        Map<Id,Id> lineItemsProductsMap = new Map<Id,Id>(); //used to store transLineItemid and its ProductId
        List<MainWrapper> mwrapList = new List<MainWrapper>(); 
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package__c')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Package_Product_Line_Item__c')
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package__c',new Set<String>{'id','name'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'id','name','sigmaerpdev__Package__c','sigmaerpdev__Status__c','sigmaerpdev__Order__c','sigmaerpdev__Order_Product__c','sigmaerpdev__Order__r.OrderNumber','sigmaerpdev__Order__r.Id','sigmaerpdev__Product__c','sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c','sigmaerpdev__Product__r.name','sigmaerpdev__Order_Product__r.Quantity','sigmaerpdev__Order_Product__r.sigmaerpdev__Allocation_Done__c','sigmaerpdev__Quantity__c','sigmaerpdev__Via_Autopick__c','sigmaerpdev__Product__r.Id'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new Set<String>{'Id','PriceBookEntry.Product2Id','PriceBookEntry.Product2.Id','sigmaerpdev__Allocation_Done__c','sigmaerpdev__Allocated_Quantity__c','PriceBookEntry.Product2.Name','Quantity','OrderId','PriceBookEntry.Product2.sigmaerpdev__Attribute_Type__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'id','name','sigmaerpdev__Product__c','sigmaerpdev__Available_Quantity__c','sigmaerpdev__Expiry_Date__c','sigmaerpdev__Lot__r.Name','sigmaerpdev__Lot__r.Id','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Name','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Id','sigmaerpdev__Inventory_Location_Product__r.Id','sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Product_Serial_Number__r.Name','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Serial_Number__c','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Status__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'id','name','sigmaerpdev__Attribute_Type__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Package_Product_Line_Item__c',new Set<String>{'id','sigmaerpdev__Packaged_Product__r.Id','sigmaerpdev__Quantity__c','sigmaerpdev__Lot__c','sigmaerpdev__Lot__r.Name','sigmaerpdev__Expiry_Date__c','sigmaerpdev__Location__c','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Available_Quantity__c','sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Product_Serial_Number__r.Name','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Serial_Number__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Name','sigmaerpdev__Inventory_Location_Product__r.Id'})
        )  
        {    
            try{
                packge = [select id,name,(select id,Order__c,Order__r.Id,Order__r.OrderNumber,Order_Product__c from PackagedProducts__r) from Package__c where id =: packageId];
                for(PackagedProducts__c pp : packge.PackagedProducts__r){                        
                    transLineIdMap.put(pp.Order_Product__c,pp.id);
                    transMap.put(pp.Order__c,pp.id);
                }
                OrderLineList = [Select Id,PriceBookEntry.Product2Id,PriceBookEntry.Product2.Id,sigmaerpdev__Allocation_Done__c,sigmaerpdev__Allocated_Quantity__c,PriceBookEntry.Product2.Name,Quantity,OrderId,PriceBookEntry.Product2.sigmaerpdev__Attribute_Type__c From OrderItem where id in :transLineIdMap.keySet()];
                
                for(OrderItem tdiList : OrderLineList){
                    lineItemsProductsMap.put(tdiList.Id,tdiList.PriceBookEntry.Product2Id);
                }
                
                Map<Id,Decimal> prodMap = new Map<Id,Decimal>();
                Map<Id,Id> transLineItemsProduct = new Map<Id,Id>();        
                for(OrderItem transItem : OrderLineList){            
                    prodMap.put(transItem.PriceBookEntry.Product2Id, transItem.Quantity);
                    transLineItemsProduct.put(transItem.PriceBookEntry.Product2Id,transItem.Id); //used to store transline items and its product id
                    transName = transItem.OrderId;  
                    system.debug('prodMap::'+prodMap);
                    system.debug('transLineItemsProduct::'+transLineItemsProduct);
                    system.debug('transName to cheeck::'+transName);
                }  
                
                // assign data to return list to UI 
                //new flow for picking products and transline items - added on 25/11/2017
                //get full list from ILPLI to use in Manual selection - starts from here        
                List<ProductWrapper> wrapProdListForFastEntry = new List<ProductWrapper>(); //selected ilpli list
                List<ProductWrapper> combinedProdListForFastEntry = new List<ProductWrapper>(); //combination of both selected and non-selected ilpli list
                
                Id ProdId;
                String prodName; 
                String status;
                String prodAttrType;
                String prodBomType;
                Map<Id,ProductWrapper> prodMapWrap = new Map<Id,ProductWrapper>();
              
                //removed the inner query and querying full ilpli list to fix inner query issue returning more than 200 ilpli's for particular product
                Map<Id,List<Inventory_Location_Product_Line_Item__c>> prodILPLIListNewMap = new Map<Id,List<Inventory_Location_Product_Line_Item__c>>();
                List<Inventory_Location_Product_Line_Item__c> newIlpliList = [select id,name,Product__c,Available_Quantity__c,Expiry_Date__c,Lot__r.Name,Lot__r.Id,Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name,Inventory_Location_Product__r.Inventory_Location__r.Location__r.Id,Inventory_Location_Product__r.Id,Product_Serial_Number__c,Product_Serial_Number__r.Name,Product_Serial_Number__r.Serial_Number__c from Inventory_Location_Product_Line_Item__c where Available_Quantity__c > 0 and Product_Serial_Number__r.Status__c != 'Used' and Product__c in :prodMap.keySet()];
                for(Inventory_Location_Product_Line_Item__c ilpli1 : newIlpliList){
                    if(prodILPLIListNewMap.containsKey(ilpli1.Product__c)){
                        List<Inventory_Location_Product_Line_Item__c> showILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                        showILPLI = prodILPLIListNewMap.get(ilpli1.Product__c);
                        showILPLI.add(ilpli1);
                        prodILPLIListNewMap.put(ilpli1.Product__c,showILPLI);        
                    }else{
                        List<Inventory_Location_Product_Line_Item__c> showILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                        showILPLI.add(ilpli1);
                        prodILPLIListNewMap.put(ilpli1.Product__c,showILPLI);          
                    }
                }
                //ends here
                
                
                List<Product2> products=new List<Product2>();
                products=[select id,name,Attribute_Type__c from Product2 where id in : prodMap.keySet()];    
                for(Product2 prd :products)
                {     
                    ProductWrapper wrapProdListTemp;
                    List<innerWrapper> innerWrapperList = new List<innerWrapper>();                    
                    
                    {              
                        
                        prodId = prd.id;
                        prodName = prd.name;
                        prodAttrType = prd.Attribute_Type__c;
                        
                        for(Inventory_Location_Product_Line_Item__c ilpli : prodILPLIListNewMap.get(prd.id)){                     
                            
                            innerWrapper iwrap = new innerWrapper(null,null,null,null,null,null,null,null,null,null,null,null,null);    
                            
                            if(ilpli.Lot__r.Name == null){
                                iwrap.lotName = 'Not Available';  
                            }else{
                                iwrap.lotName = ilpli.Lot__r.Name;  
                            }
                            iwrap.lotExpiryDate = ilpli.Expiry_Date__c;
                            iwrap.ilpName = ilpli.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name;
                            iwrap.ilpAvailQuantity = ilpli.Available_Quantity__c;                    
                            iwrap.lotId = ilpli.Lot__r.Id;
                            iwrap.ilpId = ilpli.Inventory_Location_Product__r.Id; 
                            iwrap.ilpliId = ilpli.Id;
                            System.debug('loc ID==='+ilpli.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Id);
                            iwrap.locationId = ilpli.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Id;
                            iwrap.srNumId = ilpli.Product_Serial_Number__c;
                            
                            if(ilpli.Product_Serial_Number__r.Serial_Number__c == null){
                                iwrap.srNumName = 'Not Available';  
                            }else{
                                
                                //added on 19/12/2017 to show Serial code instead of PSN Auto number
                                iwrap.srNumName = ilpli.Product_Serial_Number__r.Serial_Number__c;
                            }                                            
                            iwrap.selQuantity = null;
                            iwrap.ppId = null;
                            iwrap.ppliId = null;
                            
                            innerWrapperList.add(iwrap);
                            
                        }
                        wrapProdListTemp = new ProductWrapper(transactionId,transName,transLineItemsProduct.get(prd.id),ProdId,prodName,prodMap.get(prd.id),null,prodAttrType,null,false,true,innerWrapperList);
                    }
                    prodMapWrap.put(prd.id,wrapProdListTemp);
                }
                
                //ends here 
                
                Map<Id,List<lineItemsWrapper>> transLineListMap = new Map<Id,List<lineItemsWrapper>>(); //used to store trans and its list of line items
                Map<Id,List<PackagedProducts__c>> transLineItemPackProdsMap = new Map<Id,List<PackagedProducts__c>>(); 
                
                List<PackagedProducts__c> pprdList =  [select id,name,Order__c,Order__r.OrderNumber,Order_Product__c,Product__c,Product__r.Attribute_Type__c,
                                                       Status__c,Product__r.name,Order_Product__r.Quantity,Order_Product__r.Allocation_Done__c,
                                                       Quantity__c,Via_Autopick__c,
                                                       (select id,Packaged_Product__r.Id,Quantity__c,Lot__c,Lot__r.Name,Expiry_Date__c,Location__c,
                                                                                    Inventory_Location_Product_Line_Item__r.Available_Quantity__c,Product_Serial_Number__c,Product_Serial_Number__r.Name,Product_Serial_Number__r.Serial_Number__c,Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name
                                                                                    from Package_Product_Line_Items__r) from PackagedProducts__c where Order_Product__c  in :transLineIdMap.keySet() and 
                                                       Package__c = :packageId and Status__c != 'Ready' ORDER BY Id ASC];
                for(PackagedProducts__c tdi : pprdList)
                {  
                        
                    //transIdAndNameMap.put(tdi.Sigma_Order__c,tdi.Sigma_Order__r.Name);
                    transIdAndNameMap.put(tdi.Order__c,tdi.Order__r.OrderNumber);
                    transIdAndStatusMap.put(tdi.Order__c,tdi.Status__c);
                    if(transLineItemPackProdsMap.containsKey(tdi.Order__c)){
                        transLineItemPackProdsMap.get(tdi.Order__c).add(tdi);
                    }else{
                        transLineItemPackProdsMap.put(tdi.Order__c,new List<PackagedProducts__c>{tdi});
                    }           
                }
                
                for(Id transId : transLineItemPackProdsMap.keySet()){
                    List<lineItemsWrapper> lineItemsWrapperList = new List<lineItemsWrapper>();
                    for(PackagedProducts__c pprd : transLineItemPackProdsMap.get(transId)){
                        lineItemsWrapper lineItems = new lineItemsWrapper();
                        lineItems.packProd =  new PackagedProducts__c();         
                        lineItems.prodName = pprd.Product__r.name;
                        lineItems.prodId = pprd.Product__r.Id;
                        lineItems.transLineItemId = pprd.Order_Product__c;            
                        lineItems.orderedQnt = pprd.Order_Product__r.Quantity;          
                        lineItems.packProd.Order_Product__c = pprd.Order_Product__c;
                       
                       //fix to avoid collision b/w Allocate during Sales order[which will update Allocate Stock to true] and during Package
                        //so now we have to use Via_Autopick__c instead of Allocation_Done__c
                       
                        lineItems.packProd.Auto_allocate__c = pprd.Via_Autopick__c;
                        lineItems.allocatedQnty = pprd.Quantity__c; 
                        lineItems.isSelected = true;
                        
                        List<innerWrapper> innerWrapperList = new List<innerWrapper>();
                        Set<id> ilpIdsSelected = new Set<id>();
                        for(Package_Product_Line_Item__c ppli : pprd.Package_Product_Line_Items__r){
                            
                            innerWrapper iwrap = new innerWrapper(null,null,null,null,null,null,null,null,null,null,null,null,null);    
                            iwrap.selQuantity = ppli.Quantity__c;
                            iwrap.lotName = ppli.Lot__r.Name;
                            iwrap.lotExpiryDate = ppli.Expiry_Date__c;
                            iwrap.ilpName = ppli.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Name;
                            iwrap.ilpAvailQuantity = ppli.Inventory_Location_Product_Line_Item__r.Available_Quantity__c;                    
                            iwrap.lotId = ppli.Lot__c;
                            iwrap.ilpId = ppli.Inventory_Location_Product__r.Id; 
                            iwrap.ilpliId = ppli.Inventory_Location_Product_Line_Item__r.Id;
                            iwrap.ppId = ppli.Packaged_Product__r.Id;
                            iwrap.ppliId = ppli.Id; 
                            iwrap.srNumId = ppli.Product_Serial_Number__c;
                            //commented below line on 31/1/2018 to show code instead of name
                            
                            iwrap.srNumName = ppli.Product_Serial_Number__r.Serial_Number__c;  
                            
                            iwrap.locationId = ppli.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Id;
                            
                            innerWrapperList.add(iwrap);
                            ilpIdsSelected.add(iwrap.ilpliId); 
                        }
                        if(prodMapWrap.containsKey(pprd.Product__r.Id)){
                            List<innerWrapper> innerWrapperListOriginal = prodMapWrap.get(pprd.Product__r.Id).wrapProdList;
                            for(innerWrapper iwrp : innerWrapperListOriginal){
                                if(!ilpIdsSelected.contains(iwrp.ilpliId)){
                                    innerWrapperList.add(iwrp);
                                }
                            }
                        }
                        
                        List<ProductWrapper> pwList = new List<ProductWrapper>();
                        ProductWrapper pw = new ProductWrapper(pprd.Order__c,pprd.Order__r.OrderNumber,
                                                               pprd.Order_Product__c,
                                                               pprd.Product__r.Id,pprd.Product__r.name,
                                                               pprd.Order_Product__r.Quantity,
                                                               pprd.Status__c,pprd.Product__r.Attribute_Type__c,
                                                               pprd.Quantity__c,pprd.Via_Autopick__c,
                                                               true,innerWrapperList);
                        pwList.add(pw);     
                        lineItems.prodwrap = pwList;
                        lineItemsWrapperList.add(lineItems);
                    }
                    transLineListMap.put(transId,lineItemsWrapperList);
                }       
                for(Id transId : transLineListMap.keySet()){
                    MainWrapper mwrap = new MainWrapper();
                    mwrap.transId = transId;
                    mwrap.transName = transIdAndNameMap.get(transId);
                    mwrap.lineItemsList = transLineListMap.get(transId);
                    mwrap.status = transIdAndStatusMap.get(transId);
                    mwrapList.add(mwrap);
                }
            }catch(Exception e){            
                system.debug('exception>>>'+e.getMessage());
                system.debug('exception>>>'+e.getLineNumber());
                return null;
            }
        }
        return mwrapList; 
    }*/
    //ends here
    //Handle FIFO based allocation during Package - added on 1/12/2017
 /*   @AuraEnabled
    public static Boolean AllocateStockUsingFIFODuringStandPackage(Id transId, Id transLineId, Id ProductId, Decimal OrderedQty)
    {
        
        Decimal allocatedQnty = 0.0;
        Decimal requiredQuantity = 0.0;
        Decimal allocatingQuantity = 0.0;
        Decimal orderedQuantity = 0.0;
        Decimal remainingQnty = 0.0;
        Decimal lineItemOrderedQuantity = 0.0; //used to restrict partial allocation if stock is insufficient  
        
       if(CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            &&CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
            &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
            &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')
            &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sales_Order_Allocation__c')
            &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sales_Order_Allocation_Line_Item__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('Order',new Set<String>{'id','name','sigmaerpdev__Allocation_Done__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new Set<String>{'id','PriceBookEntry.Product2.Name','Quantity','sigmaerpdev__Allocation_Done__c','sigmaerpdev__Allocated_Quantity__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'id','name','Products__c','sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Inventory__r.Id'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'name','sigmaerpdev__Inventory_Location_Product__r.Id','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Products__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Products__r.Name','sigmaerpdev__Reserved_Quantity__c','sigmaerpdev__Available_Quantity__c','sigmaerpdev__Allocated_Quantity__c','sigmaerpdev__Expiry_Date__c','sigmaerpdev__Product_Received_Date__c','sigmaerpdev__Updated_Exp_Date__c','sigmaerpdev__Inventory_Location_Product__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'sigmaerpdev__Inventory_Location_Product__c','sigmaerpdev__Reserved_Quantity__c','sigmaerpdev__Allocated_Quantity__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev__Delivered_Quantity__c','sigmaerpdev__Inventory__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sales_Order_Allocation__c',new Set<String>{'sigmaerpdev__Sales_Order__c','sigmaerpdev__Status__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sales_Order_Allocation_Line_Item__c',new Set<String>{'sigmaerpdev__Order_Product__c','sigmaerpdev__Allocated_Quantity__c','sigmaerpdev__Inventory_Location_Product_Line_Item__c','sigmaerpdev__Status__c','sigmaerpdev__Ordered_Quantity__c','sigmaerpdev__Remaining_Quantity__c'})
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Sales_Order_Allocation_Line_Item__c',new Set<String>{'sigmaerpdev__Sales_Order_Allocation__c'})
            && CRUD_FLS_CheckUtility.checkFLS('OrderItem',new Set<String>{'sigmaerpdev__Allocation_Done__c','sigmaerpdev__Allocated_Quantity__c'})
            && CRUD_FLS_CheckUtility.checkFLS('Order',new Set<String>{'sigmaerpdev__Allocation_Done__c'})
            )     
          {
            system.debug('inside fls');
            try{
                List<Order> transList = [select id,name,Allocation_Done__c from Order where id = :transId];
                List<OrderItem> transItemsList = [select Id,PriceBookEntry.Product2.Name,Quantity from OrderItem where id = :transLineId];
                Map<Id,Id> indvTransItemMap = new Map<Id,Id>(); //used to store Trans Items and its Products in Map     
                Map<Id,Decimal> reqProductQuantityMap1 = new Map<Id,Decimal>(); // store Product Id and its Ordered Quantity
                Map<Id,Decimal> orderedQuantitymap = new Map<Id,Decimal>(); //used to store Ordered Product Id and its Quantity
                Map<Id,String> ilpListMap1 = new Map<Id,String>();
                Integer allocOption = 2; //allocation happens on FIFO basis - Option 1 for Expiry date,Option 2 for Received date  
                
                indvTransItemMap.put(ProductId,transLineId); 
                reqProductQuantityMap1.put(ProductId, OrderedQty); 
                orderedQuantitymap.put(ProductId,OrderedQty);
                lineItemOrderedQuantity = OrderedQty; //used to restrict partial allocation if stock is insufficient
                List<Inventory_Location_Product__c> ilpList = [select id,name from Inventory_Location_Product__c where Products__c = :reqProductQuantityMap1.keySet()];
                
                for (Inventory_Location_Product__c ilpListItems : ilpList){              
                    ilpListMap1.put(ilpListItems.Id,ilpListItems.Name);
                }
                List<Inventory_Location_Product_Line_Item__c> ilpliList = new List<Inventory_Location_Product_Line_Item__c>();
                if(allocOption == 1){
                    
                    ilpliList = [select name,Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Name,Reserved_Quantity__c,Available_Quantity__c,Allocated_Quantity__c,Expiry_Date__c 
                                 from Inventory_Location_Product_Line_Item__c where Inventory_Location_Product__r.Id in :ilpListMap1.keySet() and Updated_Exp_Date__c > TODAY order by Updated_Exp_Date__c ASC];
                    
                }else if(allocOption == 2){
                    
                    List<Inventory_Location_Product_Line_Item__c> tempilpliList = new List<Inventory_Location_Product_Line_Item__c>();
                    tempilpliList = [select name,Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Name,
                                     Reserved_Quantity__c,Available_Quantity__c,Allocated_Quantity__c,Product_Received_Date__c from Inventory_Location_Product_Line_Item__c where 
                                     Inventory_Location_Product__r.Id in :ilpListMap1.keySet() and Updated_Exp_Date__c != null and Updated_Exp_Date__c > TODAY];
                    
                    
                    if(tempilpliList.size() > 0){ //if expiry date exists choose those ilpli's to do allocation
                        ilpliList = [select name,Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Name,
                                     Reserved_Quantity__c,Available_Quantity__c,Allocated_Quantity__c,Product_Received_Date__c from Inventory_Location_Product_Line_Item__c where 
                                     Inventory_Location_Product__r.Id in :ilpListMap1.keySet() and Updated_Exp_Date__c > TODAY order by Product_Received_Date__c ASC];
                        
                    }else{ //else choose all ilpli's to do allocation
                        ilpliList = [select name,Inventory_Location_Product__r.Id,Inventory_Location_Product__r.Products__c,Inventory_Location_Product__r.Products__r.Name,
                                     Reserved_Quantity__c,Available_Quantity__c,Allocated_Quantity__c,Product_Received_Date__c from Inventory_Location_Product_Line_Item__c where 
                                     Inventory_Location_Product__r.Id in :ilpListMap1.keySet() order by Product_Received_Date__c ASC];
                    }
                }
                //added to restrict partial allocation if there is insufficient stock           
                Decimal tempQuantityTotal = 0.0;
                Boolean stockExists = false; //suggests there is not enough stock to do allocation
                for(Inventory_Location_Product_Line_Item__c checkQuantity : ilpliList){
                    tempQuantityTotal = tempQuantityTotal + checkQuantity.Available_Quantity__c;
                }
                if(Test.isrunningtest() || tempQuantityTotal >= lineItemOrderedQuantity)
                {
                    stockExists = true; //suggests there is enough stock to do allocation
                }
                //allocate inventory in ILPLI object        
                Map<id,List<Inventory_Location_Product_Line_Item__c>> productAndILPLAllocated = new Map<id,List<Inventory_Location_Product_Line_Item__c>>();
                Map<id,Decimal> IlPLIQuan = new Map<id,Decimal>();
                //check whether there is enough stock to do allocation
                if(stockExists == true)
                { //suggests there is enough stock to do allocation if stockExists is true
                    for(Inventory_Location_Product_Line_Item__c allocateProd : ilpliList){          
                        Id prodIds = allocateProd.Inventory_Location_Product__r.Products__c;          
                        requiredQuantity = reqProductQuantityMap1.get(String.valueOf(allocateProd.Inventory_Location_Product__r.Products__c));
                        system.debug('requiredQuantity::'+requiredQuantity);
                        if(requiredQuantity != 0){          
                            allocatingQuantity = allocateProd.Available_Quantity__c;  
       
                            if(allocatingQuantity <= requiredQuantity && allocatingQuantity != 0){
                                
                                if(allocateProd.Reserved_Quantity__c != null){
                                    allocateProd.Reserved_Quantity__c = allocateProd.Reserved_Quantity__c + allocatingQuantity;
                                    allocateProd.Allocated_Quantity__c = allocatingQuantity;
                                    IlPLIQuan.put(allocateProd.Id,allocatingQuantity);                                                          
                                    if(productAndILPLAllocated.containsKey(prodIds))
                                    {
                                        List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                                        usedILPLI = productAndILPLAllocated.get(prodIds);
                                        usedILPLI.add(allocateProd);
                                        productAndILPLAllocated.put(prodIds,usedILPLI);                         
                                    }
                                    else{
                                        List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                                        usedILPLI.add(allocateProd);
                                        productAndILPLAllocated.put(prodIds,usedILPLI);                         
                                    }
                                }
                                requiredQuantity = requiredQuantity - allocatingQuantity;
                            }else if(allocatingQuantity > requiredQuantity){  
                                
                                if(allocateProd.Reserved_Quantity__c != null){                       
                                    allocateProd.Reserved_Quantity__c = allocateProd.Reserved_Quantity__c + requiredQuantity;
                                    allocateProd.Allocated_Quantity__c = requiredQuantity;
                                    IlPLIQuan.put(allocateProd.Id,requiredQuantity);                            
                                    if(productAndILPLAllocated.containsKey(prodIds))
                                    {
                                        List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                                        usedILPLI = productAndILPLAllocated.get(prodIds);
                                        usedILPLI.add(allocateProd);
                                        productAndILPLAllocated.put(prodIds,usedILPLI);                         
                                    }
                                    else{
                                        List<Inventory_Location_Product_Line_Item__c> usedILPLI = new List<Inventory_Location_Product_Line_Item__c>();
                                        usedILPLI.add(allocateProd);
                                        productAndILPLAllocated.put(prodIds,usedILPLI);
                                    }
                                }                   
                                requiredQuantity = 0;                   
                            }                                   
                            reqProductQuantityMap1.put(String.valueOf(allocateProd.Inventory_Location_Product__r.Products__c),requiredQuantity);                                
                        } //end of if statement
                    }  //end of for loop
                    update ilpliList;
                    //allocate inventory in ILPLI object ends here
                }else{
                    return false; //no sufficient stock to do allocation 
                }
                //check whether there is enough stock to do allocation ends here 
                
                if(!productAndILPLAllocated.isEmpty())
                {             
                    //insert data into Sales Order Allocation object
                    Sales_Order_Allocation__c soa = new Sales_Order_Allocation__c();
                    soa.Sales_Order__c = transId;                 
                    soa.Status__c = 'Pending';
                    insert soa;
                    //ends here    
                    
                    //insert data into Sales order Allocation Line Item object
                    List<Sales_Order_Allocation_Line_Item__c> soaliList = new List<Sales_Order_Allocation_Line_Item__c>();
                    for(Id proId : productAndILPLAllocated.keySet())
                    {
                        if(indvTransItemMap.containsKey(proId)){
                            for(Inventory_Location_Product_Line_Item__c ilpli : productAndILPLAllocated.get(proId)){
                                Sales_Order_Allocation_Line_Item__c soali = new Sales_Order_Allocation_Line_Item__c();
                                soali.Sales_Order_Allocation__c = soa.Id;
                                soali.Order_Product__c = indvTransItemMap.get(proId);
                                soali.Allocated_Quantity__c = IlPLIQuan.get(ilpli.Id); 
                                soali.Inventory_Location_Product_Line_Item__c = ilpli.Id;
                                soali.Status__c = 'Allocated';                                             
                                orderedQuantity = orderedQuantitymap.get(proId);                      
                                soali.Ordered_Quantity__c = orderedQuantity;                                                
                                allocatedQnty = allocatedQnty + IlPLIQuan.get(ilpli.Id);                        
                                remainingQnty = allocatedQnty;                        
                                soali.Remaining_Quantity__c = orderedQuantity - remainingQnty;
                                soaliList.add(soali);
                            } //end of inner for loop
                        } //end of if statement        
                    } //end of outer for loop
                    insert soaliList; 
                    
                    //set Allocation Done Status to true in Transaction Line Items
                
                    for(OrderItem updateStatus : transItemsList){
                        updateStatus.Allocation_Done__c = true;
                        updateStatus.Allocated_Quantity__c = allocatedQnty;
                    }
                    update transItemsList;
                    
                    for(Order updateAllocStatus : transList){
                        updateAllocStatus.Allocation_Done__c = true;             
                    }
                    update transList;
          
                    //handle PI and ILP starts here (updating PI and ILP quantities)                
                    Map<Id,Decimal> allocatedILPs = new Map<Id,Decimal>(); //used to store ILP's and its respective allocated quantity
                    Map<Id,Decimal> allocatedPIs = new Map<Id,Decimal>(); //used to store PI's and its respective allocated quantity
                    List<AggregateResult> aggrResult = [select Inventory_Location_Product__c,sum(Allocated_Quantity__c) from Inventory_Location_Product_Line_Item__c where id in :IlPLIQuan.keySet() group by Inventory_Location_Product__c];
                    for(AggregateResult tempList : aggrResult)
                    {
                        allocatedILPs.put((Id)tempList.get('sigmaerpdev__Inventory_Location_Product__c'),(Decimal)tempList.get('expr0'));
                    }
                    //update ILP [Delivered Quantity] to match the quantities b/w ILP and ILPLI (if its respective ILPLI has been used in the allocation process)
                    List<Inventory_Location_Product__c> updateILPList = [select id,name,Delivered_Quantity__c,Inventory__r.Id from Inventory_Location_Product__c where id in :allocatedILPs.keySet()];
                    Decimal tempQuantity = 0.0;  
                    for(Inventory_Location_Product__c updateILP : updateILPList){
                        
                        updateILP.Delivered_Quantity__c = updateILP.Delivered_Quantity__c + allocatedILPs.get(updateILP.Id);                  
                        
                        tempQuantity = tempQuantity + allocatedILPs.get(updateILP.Id);
                        allocatedPIs.put(updateILP.Inventory__r.Id, tempQuantity);
                    }
                    update updateILPList;
                } //end of if statement 
                
            }catch(Exception e){
                System.debug('The following exception has occurred in AllocateStockUsingFIFODuringPackage: ' + e.getMessage());
                
                return null;
            }
        }
        return true; //if allocation success
    } */
     //return newly allocated auotpicked stock during package to the wrapper class
 /*   @AuraEnabled
    public static List<ProductWrapper> getstandAutopickedStock(String orderId, String transLineId)
    {
        List<ProductWrapper> wrapProdListAutopicked = new List<ProductWrapper>(); //full List for Autopicked flow
        List<OrderItem> OrderLineList; 
        Map<Id,Id> lineItemsProductsMap = new Map<Id,Id>(); //used to store transLineItemid and its ProductId
        
        //fetch allocated stock from soali object        
        List<Sales_Order_Allocation_Line_Item__c> allocObj = new List<Sales_Order_Allocation_Line_Item__c>();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sales_Order_Allocation_Line_Item__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new Set<String>{'Id','PriceBookEntry.Product2Id','PriceBookEntry.Product2.id','sigmaerpdev__Allocation_Done__c','sigmaerpdev__Allocated_Quantity__c','PriceBookEntry.Product2.Name','Quantity','OrderId','PriceBookEntry.Product2.sigmaerpdev__Attribute_Type__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sales_Order_Allocation_Line_Item__c',new Set<String>{'Id','name','sigmaerpdev__Order_Product__c','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Product_Serial_Number__r.Name','sigmaerpdev__Inventory_Location_Product_Line_Item__c','sigmaerpdev__Location_Name__c','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Lot__r.sigmaerpdev__Expiry_Date__c','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.name','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Lot__r.Name','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Name','sigmaerpdev__Allocated_Quantity__c','sigmaerpdev__Order_Product__r.OrderId','sigmaerpdev__Package_Status__c','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Lot__r.Id','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Inventory_Location_Product__r.Id','sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Id'})
        )
        {
            try{ 
                OrderLineList = [Select Id,PriceBookEntry.Product2Id,PriceBookEntry.Product2.id,sigmaerpdev__Allocation_Done__c,sigmaerpdev__Allocated_Quantity__c,PriceBookEntry.Product2.Name,Quantity,OrderId,PriceBookEntry.Product2.sigmaerpdev__Attribute_Type__c From OrderItem where id = :transLineId];
                for(OrderItem tdiList : OrderLineList)
                {
                    lineItemsProductsMap.put(tdiList.Id,tdiList.PriceBookEntry.Product2.Id);
                }
                allocObj =  [select Id,name,sigmaerpdev__Order_Product__c,sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Product_Serial_Number__c,sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Product_Serial_Number__r.Name,sigmaerpdev__Inventory_Location_Product_Line_Item__c,sigmaerpdev__Location_Name__c,sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Lot__r.sigmaerpdev__Expiry_Date__c,sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.name,sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Lot__r.Name,sigmaerpdev__Inventory_Location_Product_Line_Item__r.sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Name,sigmaerpdev__Allocated_Quantity__c,sigmaerpdev__Order_Product__r.OrderId,sigmaerpdev__Package_Status__c from sigmaerpdev__Sales_Order_Allocation_Line_Item__c where sigmaerpdev__Order_Product__r.OrderId =: orderId AND Package_Status__c != true];
                for(Sales_Order_Allocation_Line_Item__c soali : allocObj)
                {
                    List<ProductWrapper> wrapProdListAllocated = new List<ProductWrapper>(); //full ilpli List for allocated flow
                    List<innerWrapper> innerWrapperList = new List<innerWrapper>(); 
                    Id transLineIds = soali.Order_Product__c; 
                    //if allocation is done for this trans Line item
                    if(lineItemsProductsMap.containsKey(transLineIds))
                    { 
                        innerWrapper iwrap = new innerWrapper(null,null,null,null,null,null,null,null,null,null,null,null,null);                        
                        iwrap.lotName = soali.Inventory_Location_Product_Line_Item__r.Lot__r.Name;
                        iwrap.lotExpiryDate = soali.Inventory_Location_Product_Line_Item__r.Lot__r.Expiry_Date__c;
                        iwrap.ilpAvailQuantity = null;                    
                        iwrap.lotId = soali.Inventory_Location_Product_Line_Item__r.Lot__r.Id;
                        iwrap.ilpId = soali.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Id; 
                        iwrap.ilpliId = soali.Inventory_Location_Product_Line_Item__c;               
                        iwrap.locationId = soali.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.Id;
                        iwrap.srNumId = soali.Inventory_Location_Product_Line_Item__r.Product_Serial_Number__c;
                        iwrap.srNumName = soali.Inventory_Location_Product_Line_Item__r.Product_Serial_Number__r.Name;
                        iwrap.selQuantity = soali.Allocated_Quantity__c;
                        iwrap.ppId = null;
                        iwrap.ppliId = null;
                        innerWrapperList.add(iwrap);
                        wrapProdListAutopicked.add(new ProductWrapper(orderId,null,transLineIds,lineItemsProductsMap.get(transLineIds),null, null,null,null,null,true,false,innerWrapperList));              
                    }
                }//ends here 
            }catch(Exception e){
                return null;
            }
        }
        return wrapProdListAutopicked;
    }*/
 /*   @AuraEnabled
    public static PackagedProducts__c checkstandSO(String sigmaorderObj)
    {
        PackagedProducts__c sodetailsforpackage= new PackagedProducts__c();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__PackagedProducts__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__PackagedProducts__c',new Set<String>{'Id',' Name','sigmaerpdev__Order__r.id','sigmaerpdev__Order__r.sigmaerpdev__Fully_Packaged__c'}))
        {
            try{
                    sodetailsforpackage= [select Id, Name,sigmaerpdev__Order__r.id,sigmaerpdev__Order__r.sigmaerpdev__Fully_Packaged__c from PackagedProducts__c where sigmaerpdev__Order__r.id=:sigmaorderObj limit 1];
                }
                catch(Exception e)
                {
                    return null;
                }
        }
        return sodetailsforpackage;
        
    }*/
}