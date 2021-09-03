public with sharing class StockRecevingControllerLtng 
{      
    
    
    /*******************************************/  
     /*public class StockReceivingWrap
    {
        public string Id;
        public string Vendor;
        public string Contact;
        public string location;
       
        public DateTime Received_Date_Time;
        public string Delivery_Note_Number; //sigmaerpdev__Truck_Number__c
        public string Notes; 
        public string Company;
         public string Receiving_Sites;
          
        public string batchNumber;
        
        public Boolean isSerialCodeMandatory;
    }
    
      public class TransLineItems
    {
        @auraEnabled
        public String attributeType;
        @auraEnabled
        public String productName;
        @auraEnabled
        public String compId;
        @auraEnabled
        public Decimal Receiving_Quantity_Original;
        @auraEnabled
        public List<sigmaerpdev__Stock_Receiving_Product_Line_Item__c> serialNo; //Stock Receiving Product Line Item
        @auraEnabled
        public sigmaerpdev__Stock_In_Product__c TransLineItemRec; //Stock Receiving Product
        @auraEnabled
        public String BinId;
        @auraEnabled
        public String BinName;
        @auraEnabled
        public String BatchNo;
        @auraEnabled
        public Boolean hasBatchNo{get;set;}
        @auraEnabled
        public Boolean hasExpiryDate{get;set;}
    }    
    */
    /*******************************************/
    /* @AuraEnabled
    public static List<String> getStockInProductStatus()
    {
        List<String> options = new List<String>();
         if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Stock_In_Product__c',new set<String>{'sigmaerpdev__Status__c'}))
            {
                Schema.DescribeFieldResult fieldResult = Stock_In_Product__c.Status__c.getDescribe();
                options.add('--Select--');
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                for (Schema.PicklistEntry f: ple) 
                {
                    options.add(f.getLabel());
                }
            }
        return options;
    }
    
    @AuraEnabled
      public static Stock_In__c saveStockIn(Stock_In__c StockInObj,String status,String packageProduts,String proSerNumber)
    {
       
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location__c',new set<String>{'Id','Name','sigmaerpdev__Location__c','sigmaerpdev__Location__r.Id'})
         &&CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'Id','Name','sigmaerpdev__Email__c'})
         &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Lot__c',new set<String>{'Id','Name'})
         &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Lot_Product__c',new set<String>{'Id','Name','sigmaerpdev__Location__c','sigmaerpdev__Quantity__c'})
         &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Stock_In_Product__c',new set<String>{'Id','Name','sigmaerpdev__Putaway_location__c','sigmaerpdev__Purchase_Order__c','sigmaerpdev__Pur_Order__c','sigmaerpdev__Quantity_Received__c','sigmaerpdev__Product__c','sigmaerpdev__Lot__c',
                                'sigmaerpdev__Purchase_Order__r.sigmaerpdev__Product__c','sigmaerpdev__Purchase_Order__r.sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c','sigmaerpdev__Lot__r.Id','sigmaerpdev__Inventory_Location__c','sigmaerpdev__Status__c'})
         &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Serial_Number__c',new set<String>{'Id', 'Name'})   
         &&Schema.sObjectType.sigmaerpdev__Stock_In__c.fields.Id.isAccessible()
         &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Stock_In__c')
         &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Stock_In_Product__c',new set<String>{'sigmaerpdev__Purchase_Order__c','sigmaerpdev__Stock_In__c','sigmaerpdev__Return_Quantity_Comment__c','sigmaerpdev__Status__c','sigmaerpdev__Product__c','sigmaerpdev__Inventory_Location__c','sigmaerpdev__Putaway_location__c','sigmaerpdev__Returned_Quantity__c','sigmaerpdev__Quantity_Received__c','sigmaerpdev__Product__c','sigmaerpdev__pur_Order__c','sigmaerpdev__Lot__c'})  
         &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Serial_Number__c',new set<String>{'sigmaerpdev__Stock_Receiving_Product__c','sigmaerpdev__location__c','sigmaerpdev__Product_Code__c','sigmaerpdev__Purchase_Order__c','sigmaerpdev__Serial_Number__c','sigmaerpdev__Purchase_Order_Product__c'})
         &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Lot_Product__c',new set<String>{'sigmaerpdev__Quantity__c','sigmaerpdev__Lot__c','sigmaerpdev__Location__c','sigmaerpdev__Product__c'})
         &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Stock_Receiving_Product_Line_Item__c',new set<String>{'sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Product__c'})
         &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Stock_Receiving_Product_Line_Item__c',new set<String>{'sigmaerpdev__Stock_Receiving_Product__c'})
         &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location__c')
         &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Lot__c')
         &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Lot_Product__c')
         &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Stock_In_Product__c')
         &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Serial_Number__c')
         &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Stock_Receiving_Product_Line_Item__c')
          )
        {
        
        Map<String,Stock_In_Product__c>  getStockInProductMap= new Map<String,Stock_In_Product__c>();
          insert StockInObj;
        
       Account vendoracc=[Select Id,Name,sigmaerpdev__Email__c from Account where id=:StockInObj.sigmaerpdev__Vendor__c];
       // Getting All Inventory Starts
       Map<String,String> inventoryLocMap = new Map<String,String>();
       List<Inventory_Location__c>  invLocList;       
      
           invLocList = [Select Id,Name,sigmaerpdev__Location__c,sigmaerpdev__Location__r.Id From sigmaerpdev__Inventory_Location__c limit 50000];
           
       for(Inventory_Location__c ill:invLocList){
           inventoryLocMap.put(ill.Location__r.Id,ill.Id);
       }
       // Getting All Inventory Ends
       
       //Fetching Lot records of perticular Product Starts
       Map<String,List<Lot_Product__c>> lotMap = new Map<String,List<Lot_Product__c>>();
       List<Lot__c> lotList;
       
           lotList = [Select Id,Name,(Select Id,Name,sigmaerpdev__Location__c,sigmaerpdev__Quantity__c From sigmaerpdev__Lot_Products__r) From sigmaerpdev__Lot__c limit 50000];
      
       for(Lot__c lt:lotList){
           lotMap.put(lt.Id,lt.Lot_Products__r);
       }  
       //Fetching Lot records of perticular Product Ends
       
         
        List<String> selectedIdsList = new List<String>();
        Object[] values = (Object[])System.JSON.deserializeUntyped(packageProduts);
        if(values.size()>0){         
             for (Object id : values) {
                 selectedIdsList.add(string.valueof(id) );
             }
         }*/
     
        /* ----  Stock In Products  ----- */
      /*  String str1 = packageProduts.substring(1, packageProduts.length()-1);
        List<String> stringList = str1.split(',');        
        
        List<String> strSplt = str1.split('},');
        
        List<String> strList = new List<String>();
        for(integer i=0;i<strSplt.size();i++){
            if(i < strSplt.size()-1){
                strList.add(strSplt[i]+'}');
                }else{
                    strList.add(strSplt[i]);
                }
              
        }
        
        Integer len = strSplt.size();
        //new list to update in the varified stock of new flow by chandana 
        List<Stock_In_Product__c> packageProdList = new List<Stock_In_Product__c>();
         List<Stock_In_Product__c> sipToUpsertVerified = new List<Stock_In_Product__c>();
        List<Stock_In_Product__c> sipsToUpsertVerified = new List<Stock_In_Product__c>();
        List<Product_Serial_Number__c> psnToUpsert = new List<Product_Serial_Number__c>();
        
        Map<String, Object> rootProLoc; 
        for(Integer j=0; j<strList.size(); j++){
            Stock_In_Product__c sInPrd = new Stock_In_Product__c();
            Stock_In_Product__c tempCarrierForPSN = new Stock_In_Product__c();
            List<String> stringList2 = strList[j].split(',');
            String str2 = packageProduts.substring(1, packageProduts.length()-1);

            String str = strList[j];
            Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(str);
            rootProLoc= (Map<String, Object>) JSON.deserializeUntyped(str);
                for(Integer i=0; i<strList.size(); i++)
                {
                
                    if(root.get('sigmaerpdev__Lot__c') !=null){
                        sInPrd.Lot__c = String.valueOf(root.get('sigmaerpdev__Lot__c'));
                    }
                    if(root.get('sigmaerpdev__Pur_Order__c') !=null ){
                    sInPrd.pur_Order__c= String.valueOf(root.get('sigmaerpdev__Pur_Order__c'));
                    }
                    if(root.get('sigmaerpdev__Product__c') !=null){
                        sInPrd.Product__c = String.valueOf(root.get('sigmaerpdev__Product__c'));
                        
                    }
                   
                    if(root.get('sigmaerpdev__Purchase_Order__c')!=null)
                    {
                    sInPrd.Purchase_Order__c= String.valueOf(root.get('sigmaerpdev__Purchase_Order__c'));
                    tempCarrierForPSN.Purchase_Order__c = String.valueOf(root.get('sigmaerpdev__Purchase_Order__c')); 
                    }
                    if(root.get('sigmaerpdev__Quantity_Received__c') !=''){
                    Integer oldValue1 = Integer.valueOf(root.get('sigmaerpdev__Quantity_Received__c'));
                    sInPrd.Quantity_Received__c= oldValue1;
                    }
                    if(root.get('sigmaerpdev__Returned_Quantity__c')!='')
                    {
                    Integer oldValue2 = Integer.valueOf(root.get('sigmaerpdev__Returned_Quantity__c'));
                    sInPrd.Returned_Quantity__c= oldValue2;
                    }else
                    {
                      sInPrd.Returned_Quantity__c= 0;
                    }
                    if(root.get('sigmaerpdev__Putaway_location__c')!=''){
                        sInPrd.Putaway_location__c= String.valueOf(root.get('sigmaerpdev__Putaway_location__c'));
                        sInPrd.Inventory_Location__c = inventoryLocMap.get(String.valueOf(root.get('sigmaerpdev__Putaway_location__c')));
                        tempCarrierForPSN.Putaway_location__c = String.valueOf(root.get('sigmaerpdev__Putaway_location__c'));
                        
                    }
                     if(root.get('sigmaerpdev__Product__c') !=null){
                        sInPrd.Product__c = String.valueOf(root.get('sigmaerpdev__Product__c'));
                        String tempProductId = String.valueOf(root.get('sigmaerpdev__Product__c'));
                        getStockInProductMap.put(tempProductId,tempCarrierForPSN);
                    }
                    
                   
                    
                    if(root.get('sigmaerpdev__Status__c')!=''){
                    sInPrd.Status__c= String.valueOf(root.get('sigmaerpdev__Status__c'));
                    }else
                    {
                      sInPrd.Status__c='Open';
                    }
                    if(root.get('sigmaerpdev__Return_Quantity_Comment__c')!=''){
                    sInPrd.Return_Quantity_Comment__c= String.valueOf(root.get('sigmaerpdev__Return_Quantity_Comment__c'));
                    }else
                    {
                     sInPrd.Return_Quantity_Comment__c=' ';
                    }
                    sInPrd.Stock_In__c=StockInObj.Id;
                    sInPrd.sigmaerpdev__Vendor_Email__c=vendoracc.sigmaerpdev__Email__c;
                }
           
            packageProdList.add(sInPrd);
             
        }
        
       
            insert packageProdList;//INserting Stockin Products 
       
       
        //new code to add the package product by chandana 
    Stock_In_Product__c siprod = new Stock_In_Product__c();
        for(Stock_In_Product__c stockprodlist: packageProdList)
                 {
              if(stockprodlist.Status__c=='Verified')
                    {
                    siprod = stockprodlist;
                   sipToUpsertVerified.add(siprod); 
                    }
                   
                 }
       
         for(Stock_In_Product__c sicc: sipToUpsertVerified)
            {
             if(sicc.Quantity_Received__c >0)
             sipsToUpsertVerified.add(sicc);
            }
        
        Map<Integer,String>  ll=new Map<Integer,String>();
        
        integer k=0;
        for(Stock_In_Product__c  sINP:packageProdList)
        {
           
             ll.put(k,sINP.Id);
             k++;
        }*/
        
        /*  Product Serial Number   
            Map<ID,Product_Serial_Number__c> Stockinproduct=new Map<ID,Product_Serial_Number__c>();*/
  /*    
    List<Product_Serial_Number__c> ProdSNList = new List<Product_Serial_Number__c>();
        if(proSerNumber.length() >2){
        
        String str2 = proSerNumber.substring(1, proSerNumber.length()-1);
        List<String> strSpltPSN = str2.split('},');
        List<String> strListPSN = new List<String>();
        for(integer i=0;i<strSpltPSN .size();i++){
            if(i < strSpltPSN .size()-1){
                strListPSN.add(strSpltPSN [i]+'}');
                }else{
                    strListPSN.add(strSpltPSN [i]);
                }
              
        }

        ProdSNList = new List<Product_Serial_Number__c>();
        for(Integer j=0; j<strListPSN.size(); j++)
        {
            Product_Serial_Number__c sInPrd = new Product_Serial_Number__c();
           
            List<String> stringList2 = strListPSN[j].split(',');
            String str22 = proSerNumber.substring(1, proSerNumber.length()-1);
          
            String str = strListPSN[j];
            Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(str);
           for(Integer i=0; i<strListPSN.size(); i++)
                {   
                    Stock_In_Product__c tempCarrierForPSN1 = new Stock_In_Product__c();
                     
                   if(root.get('sigmaerpdev__Serial_Number__c')!=null)
                    {    
                      sInPrd.Serial_Number__c= String.valueOf(root.get('sigmaerpdev__Serial_Number__c'));
                    }
                     if(root.get('sigmaerpdev__Purchase_Order__c')!=null && (root.get('sigmaerpdev__Purchase_Order__c')!=''))
                    {
                      sInPrd.Purchase_Order__c= String.valueOf(root.get('sigmaerpdev__Purchase_Order__c'));
                    }
                    if(root.get('sigmaerpdev__Product_Code__c')!=null && (root.get('sigmaerpdev__Product_Code__c')!=''))
                    {
                      sInPrd.Product_Code__c= String.valueOf(root.get('sigmaerpdev__Product_Code__c'));
                    }
                    
                    if(root.get('sigmaerpdev__Location__c')!='')
                    {
                      sInPrd.location__c= String.valueOf(root.get('sigmaerpdev__Location__c'));
                    }
                    if(root.get('sigmaerpdev__Purchase_Order_Product__c')!='')
                    {
                      sInPrd.sigmaerpdev__Purchase_Order_Product__c= String.valueOf(root.get('sigmaerpdev__Purchase_Order_Product__c'));
                    }
                     
                    else
                    {  
                        if(getStockInProductMap.containsKey(String.valueOf(root.get('sigmaerpdev__Product_Code__c'))))
                        {   
                            tempCarrierForPSN1 = getStockInProductMap.get(String.valueOf(root.get('sigmaerpdev__Product_Code__c')));
                            sInPrd.location__c = tempCarrierForPSN1.Putaway_location__c;
                        }
                       
                    }
                    if(root.get('sigmaerpdev__Stock_Receiving_Product__c')!=null&& (root.get('sigmaerpdev__Stock_Receiving_Product__c')!=''))
                    {
                        
                      sInPrd.Stock_Receiving_Product__c=ll.get(Integer.valueOf(root.get('sigmaerpdev__Stock_Receiving_Product__c')));     
                       
                    }
                    else
                    {
            
                        for(Integer m=0; m<packageProdList.size(); m++)
                         {
           
                            if(packageProdList[m].Purchase_Order__c ==sInPrd.sigmaerpdev__Purchase_Order_Product__c && packageProdList[m].pur_Order__c ==sInPrd.Purchase_Order__c&& packageProdList[m].sigmaerpdev__Putaway_location__c==sInPrd.sigmaerpdev__Location__c)
                            {
                                sInPrd.Stock_Receiving_Product__c=packageProdList[m].Id;
                                 if(!Stockinproduct.containsKey(sInPrd.Stock_Receiving_Product__c))
                        {
                            Stockinproduct.put(sInPrd.Stock_Receiving_Product__c,sInPrd);
                          
                        }
                            }
                    
                        }  
                    }
                }
              
            ProdSNList.add(sInPrd);
            
            }
      
           
        }
        List<Stock_In_Product__c> Receivingproducts=new List<Stock_In_Product__c>();
        Receivingproducts = [select Id,Name,sigmaerpdev__Quantity_Received__c,sigmaerpdev__Purchase_Order__c,Purchase_Order__r.Product__r.Attribute_Type__c,sigmaerpdev__Pur_Order__c,Purchase_Order__r.Product__c,sigmaerpdev__Putaway_location__c from sigmaerpdev__Stock_In_Product__c where Id In : packageProdList];
   
         for(Stock_In_Product__c stocklineitems: Receivingproducts)
            {
              
                if(stocklineitems.Purchase_Order__r.Product__r.Attribute_Type__c =='SERIALIZED' && !Stockinproduct.containsKey(stocklineitems.id))
                {
                for(Integer i=0;i<stocklineitems.sigmaerpdev__Quantity_Received__c;i++)
                    {
                        Product_Serial_Number__c sInPrditem = new Product_Serial_Number__c();
                         sInPrditem.Purchase_Order__c=stocklineitems.sigmaerpdev__Pur_Order__c;
                         sInPrditem.sigmaerpdev__Purchase_Order_Product__c=stocklineitems.sigmaerpdev__Purchase_Order__c;
                         sInPrditem.Product_Code__c=stocklineitems.Purchase_Order__r.Product__c;
                          sInPrditem.location__c=stocklineitems.Putaway_location__c;
                          sInPrditem.Stock_Receiving_Product__c=stocklineitems.id;
                         ProdSNList.add(sInPrditem);
                         
                    }
                    
                }
            }
               
           insert ProdSNList;
            
        List<Id> stockProdList = new List<Id>();
        for(Stock_In_Product__c sip:packageProdList){
            stockProdList.add(sip.Id);            
        }
        
        List<Stock_In_Product__c> stockInProdLst;
           
                stockInProdLst = [Select Id,Name,sigmaerpdev__Quantity_Received__c,sigmaerpdev__Product__c,sigmaerpdev__Lot__c,
                                sigmaerpdev__Lot__r.Id,sigmaerpdev__Inventory_Location__c,sigmaerpdev__Status__c
                               From sigmaerpdev__Stock_In_Product__c where Id IN:stockProdList];
                                                   
            List<Lot_Product__c> lotProductsList = new List<Lot_Product__c>();
                boolean updateLotProductStaus = false;
                Map<id,Map<id,decimal>> lotqty=new  Map<id,Map<id,decimal>>();
                 for(Stock_In_Product__c lotpp:stockInProdLst)
                 {
                      if(lotpp.Status__c == 'Verified')
                      { 
                     if(lotqty.containsKey(lotpp.sigmaerpdev__Product__c))
                     {
                         if(lotqty.get(lotpp.sigmaerpdev__Product__c).containsKey(lotpp.sigmaerpdev__Inventory_Location__c))
                         {
                        lotpp.sigmaerpdev__Quantity_Received__c=lotqty.get(lotpp.sigmaerpdev__Product__c).get(lotpp.sigmaerpdev__Inventory_Location__c)+lotpp.sigmaerpdev__Quantity_Received__c;
                        lotqty.get(lotpp.sigmaerpdev__Product__c).put(lotpp.sigmaerpdev__Inventory_Location__c,lotpp.sigmaerpdev__Quantity_Received__c);
                         }
                         else{
                              lotqty.get(lotpp.sigmaerpdev__Product__c).put(lotpp.sigmaerpdev__Inventory_Location__c,lotpp.sigmaerpdev__Quantity_Received__c);
                        
                         }
                    }
                     else
                     {
                        Map<id,decimal> lotil= new Map<id,decimal>();
                        lotil.put(lotpp.sigmaerpdev__Inventory_Location__c,lotpp.sigmaerpdev__Quantity_Received__c);
                     lotqty.put(lotpp.sigmaerpdev__Product__c,lotil);
                     }
                    
                    }
                    
                 }
                Map<id, Map<id,decimal>> lotproqty=new Map<id, Map<id,decimal>>();
            for(Stock_In_Product__c pp:stockInProdLst){
                if(pp.Lot__c!=null)
                {
                List<Lot_Product__c> lotProdList = lotMap.get(pp.Lot__c);
                Boolean isMatched = false;
                Lot_Product__c lotProd = new Lot_Product__c();
                if(lotProdList != null)
                {
                    
                    for(Lot_Product__c lp:lotProdList){
                        if(lp.Location__c == pp.Inventory_Location__c){
                            lotProd = lp;                                               
                            isMatched = true;
                            break;
                        }
                    }
                    if(isMatched == true && pp.Status__c == 'Verified')
                    {   
                        if(!lotproqty.containsKey(pp.sigmaerpdev__Product__c)){ 
                         updateLotProductStaus = true;  

                        Map<id,decimal> lotil= new Map<id,decimal>();
                        lotil.put(pp.sigmaerpdev__Inventory_Location__c,pp.sigmaerpdev__Quantity_Received__c);                         
                            lotproqty.put(pp.sigmaerpdev__Product__c,lotil);
                            lotProd.Quantity__c = lotProd.Quantity__c + lotqty.get(pp.sigmaerpdev__Product__c).get(pp.sigmaerpdev__Inventory_Location__c);
                             lotProductsList.add(lotProd);
                       }
                        else if(lotproqty.containsKey(pp.sigmaerpdev__Product__c))
                        {
                            if(!lotproqty.get(pp.sigmaerpdev__Product__c).containsKey(pp.sigmaerpdev__Inventory_Location__c))
                            {
                                Map<id,decimal> lotil= new Map<id,decimal>();
                        lotil.put(pp.sigmaerpdev__Inventory_Location__c,pp.sigmaerpdev__Quantity_Received__c);
                                lotproqty.put(pp.sigmaerpdev__Product__c,lotil);
                            lotProd.Quantity__c = lotProd.Quantity__c + lotqty.get(pp.sigmaerpdev__Product__c).get(pp.sigmaerpdev__Inventory_Location__c);
                             lotProductsList.add(lotProd);
                            }
                        }
                        
                       
                    }else
                    {
                       if(!lotproqty.containsKey(pp.sigmaerpdev__Product__c)&& pp.Status__c == 'Verified')
                       {
                        Map<id,decimal> lotil= new Map<id,decimal>();
                        lotil.put(pp.sigmaerpdev__Inventory_Location__c,pp.sigmaerpdev__Quantity_Received__c);
                        lotproqty.put(pp.sigmaerpdev__Product__c,lotil);
                         updateLotProductStaus = true;
                       
                        lotProd = new Lot_Product__c();
                        lotProd.Product__c = pp.Product__c;
                        lotProd.Location__c = pp.Inventory_Location__c;
                        lotProd.Lot__c = pp.Lot__c;
                        System.debug('lotProd.Quantity__c:::'+lotProd.Quantity__c);
                        if(lotProd.Quantity__c==null)
                        {
                            lotProd.Quantity__c=0;
                        }
                        lotProd.Quantity__c = lotProd.Quantity__c +  lotqty.get(pp.sigmaerpdev__Product__c).get(pp.sigmaerpdev__Inventory_Location__c);
                        lotProductsList.add(lotProd);
                        }
                        else if(lotproqty.containsKey(pp.sigmaerpdev__Product__c))
                        {
                            if(!lotproqty.get(pp.sigmaerpdev__Product__c).containsKey(pp.sigmaerpdev__Inventory_Location__c))
                            {
                                Map<id,decimal> lotil= new Map<id,decimal>();
                        lotil.put(pp.sigmaerpdev__Inventory_Location__c,pp.sigmaerpdev__Quantity_Received__c);
                                lotproqty.put(pp.sigmaerpdev__Product__c,lotil);
                           
                                lotProd = new Lot_Product__c();
                                lotProd.Product__c = pp.Product__c;
                                lotProd.Location__c = pp.Inventory_Location__c;
                                lotProd.Lot__c = pp.Lot__c;
                                System.debug('lotProd.Quantity__c:::'+lotProd.Quantity__c);
                                if(lotProd.Quantity__c==null)
                                {
                                    lotProd.Quantity__c=0;
                                }
                                   lotProd.Quantity__c = lotProd.Quantity__c + lotqty.get(pp.sigmaerpdev__Product__c).get(pp.sigmaerpdev__Inventory_Location__c);
                                     lotProductsList.add(lotProd);
                            }
                        }
                    }
                }
                else
                {
                     if(!lotproqty.containsKey(pp.sigmaerpdev__Product__c)&& pp.Status__c == 'Verified')
                       {
                          Map<id,decimal> lotil= new Map<id,decimal>();
                        lotil.put(pp.sigmaerpdev__Inventory_Location__c,pp.sigmaerpdev__Quantity_Received__c);
                        lotproqty.put(pp.sigmaerpdev__Product__c,lotil);
                        
                        lotProd.Product__c = pp.Product__c;
                        lotProd.Location__c = pp.Inventory_Location__c;
                        lotProd.Lot__c = pp.Lot__c;
                        if(lotProd.Quantity__c==null)
                        {
                            lotProd.Quantity__c=0;
                        }
                        lotProd.Quantity__c = lotProd.Quantity__c +lotqty.get(pp.sigmaerpdev__Product__c).get(pp.sigmaerpdev__Inventory_Location__c);
                        lotProductsList.add(lotProd);
                       }
                        else if(lotproqty.containsKey(pp.sigmaerpdev__Product__c))
                        {
                            if(!lotproqty.get(pp.sigmaerpdev__Product__c).containsKey(pp.sigmaerpdev__Inventory_Location__c))
                            {
                                Map<id,decimal> lotil= new Map<id,decimal>();
                                lotil.put(pp.sigmaerpdev__Inventory_Location__c,pp.sigmaerpdev__Quantity_Received__c);
                                lotproqty.put(pp.sigmaerpdev__Product__c,lotil);
                                lotProd = new Lot_Product__c();
                                lotProd.Product__c = pp.Product__c;
                                lotProd.Location__c = pp.Inventory_Location__c;
                                lotProd.Lot__c = pp.Lot__c;
                                System.debug('lotProd.Quantity__c:::'+lotProd.Quantity__c);
                                if(lotProd.Quantity__c==null)
                                {
                                    lotProd.Quantity__c=0;
                                }
                                   lotProd.Quantity__c = lotProd.Quantity__c + lotqty.get(pp.sigmaerpdev__Product__c).get(pp.sigmaerpdev__Inventory_Location__c);
                                     lotProductsList.add(lotProd);
                            }
                        }
                }
            }
            }
                if(updateLotProductStaus)
                {
                upsert lotProductsList;
                }
                
        //new code to update only in the verified status in the new flow by chandana 
    List<Stock_In_Product__c> sipWithPSN = [select Id,Name,sigmaerpdev__Putaway_location__c,sigmaerpdev__Pur_Order__c,sigmaerpdev__Purchase_Order__c,sigmaerpdev__Quantity_Received__c, sigmaerpdev__Lot__c,sigmaerpdev__Purchase_Order__r.sigmaerpdev__Product__c,sigmaerpdev__Purchase_Order__r.sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c,sigmaerpdev__Status__c,(select Id, Name from sigmaerpdev__Product_Serial_Numbers__r) from sigmaerpdev__Stock_In_Product__c where Id In : sipToUpsertVerified];
        List<Stock_Receiving_Product_Line_Item__c> srpliListToUpsert = new List<Stock_Receiving_Product_Line_Item__c>();
        if(sipWithPSN.size() > 0)
        {
          for(Stock_In_Product__c srpInd : sipWithPSN)
          {
            if(srpInd.Status__c == 'Verified')
            {
            //for BULK Product
            if(srpInd.Purchase_Order__r.Product__r.Attribute_Type__c == 'BULK')
            {
              Stock_Receiving_Product_Line_Item__c srpli = new Stock_Receiving_Product_Line_Item__c();
              srpli.Stock_Receiving_Product__c = srpInd.Id;
              srpli.Product__c = srpInd.Purchase_Order__r.Product__c;
              srpliListToUpsert.add(srpli);
            }
                
            //for SERIALIZED Product
            for(Product_Serial_Number__c psn : srpInd.Product_Serial_Numbers__r)
            {
              Stock_Receiving_Product_Line_Item__c srpli = new Stock_Receiving_Product_Line_Item__c();
              srpli.Stock_Receiving_Product__c = srpInd.Id;
              srpli.Product__c = srpInd.Purchase_Order__r.Product__c;
              srpli.Product_Serial_Number__c = psn.Id;
              srpliListToUpsert.add(srpli);
            }
           
          }
          }
          ilpUpdate.updateILP(sipsToUpsertVerified,ProdSNList,srpliListToUpsert);
                  
        }
        
    if(srpliListToUpsert.size() > 0)
            upsert srpliListToUpsert;
    
    }
        return StockInObj;  
    }
      */
    /*
    ------------------------------------------------------------
    Author  :  Vikas .
    Company :  Mindlinks Solution .
    Description : Get the all the process and Prepare the edit record value .
           
    Inputs  : Process the id .
    Returns : options-  record list list .
                       
    History
    <Date>      <Authors Name>     <Brief Description of Change>
    14-11-2016  Vikas              Edit section starts here..
    ------------------------------------------------------------   */
     /*
    
    public static List<Stock_In_Product__c> stockInProdList{get;set;}
    
    public static List<Product_Serial_Number__c> ProductSerialNumberList{get;set;}
    
    @AuraEnabled
    public static Stock_In__c editStockIn(Id stockInObj) { 
//FLs Check : Sandhya   
    Stock_In__c  stockIn;          
   if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Stock_In__c',new set<string>{'id','Vendor__c','Vendor__r.Name',
                'sigmaerpdev__Location__c','sigmaerpdev__Truck_Number__c','sigmaerpdev__Received_Date_Time__c','sigmaerpdev__Location__r.Name',
                'sigmaerpdev__Delivery_Person__c','sigmaerpdev__Delivery_Person__r.Name'})
  &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Stock_In_Product__c',new set<string>{'Id','Name','sigmaerpdev__Product__c','sigmaerpdev__Lot__c','sigmaerpdev__Lot__r.Name','sigmaerpdev__pur_Order__c','sigmaerpdev__pur_Order__r.Name','sigmaerpdev__Purchase_Order__r.sigmaerpdev__Quantity__c','sigmaerpdev__Purchase_Order__c',
            'sigmaerpdev__Purchase_Order__r.Name','sigmaerpdev__Quantity_Received__c','sigmaerpdev__Returned_Quantity__c',
            'sigmaerpdev__Purchase_Order__r.sigmaerpdev__Product__r.Name','sigmaerpdev__Purchase_Order__r.sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c',
           'sigmaerpdev__Putaway_location__c','sigmaerpdev__Putaway_location__r.Name','sigmaerpdev__Return_Quantity_Comment__c',
            'sigmaerpdev__Status__c'})
    &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'Id','Name','sigmaerpdev__Location__c','sigmaerpdev__Purchase_Order__r.Name',
                    'sigmaerpdev__Purchase_Order__r.Id','sigmaerpdev__Product_Code__r.Name','sigmaerpdev__Code__c','sigmaerpdev__Serial_Number__c','sigmaerpdev__Purchase_Order_Product__c',
                    'sigmaerpdev__Product_Code__c','sigmaerpdev__Stock_Receiving_Product__c'}))
            {   
            
                stockIn = [SELECT id,Vendor__c,Vendor__r.Name,
                    sigmaerpdev__Location__c,sigmaerpdev__Truck_Number__c,sigmaerpdev__Received_Date_Time__c,sigmaerpdev__Location__r.Name,
                    sigmaerpdev__Delivery_Person__c,sigmaerpdev__Delivery_Person__r.Name FROM sigmaerpdev__Stock_In__c where Id=:stockInObj];
          
            List<ID>  sINList=new List<ID>(); 
            
                stockInProdList= [Select Id,Name,sigmaerpdev__Product__c,sigmaerpdev__Lot__c,sigmaerpdev__Lot__r.Name,sigmaerpdev__pur_Order__c,sigmaerpdev__pur_Order__r.Name,sigmaerpdev__Purchase_Order__r.sigmaerpdev__Quantity__c,sigmaerpdev__Purchase_Order__c,
                sigmaerpdev__Purchase_Order__r.Name,sigmaerpdev__Quantity_Received__c,sigmaerpdev__Returned_Quantity__c,
                sigmaerpdev__Purchase_Order__r.sigmaerpdev__Product__r.Name,sigmaerpdev__Purchase_Order__r.sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c,
               sigmaerpdev__Putaway_location__c,sigmaerpdev__Putaway_location__r.Name,sigmaerpdev__Return_Quantity_Comment__c,
                sigmaerpdev__Status__c From sigmaerpdev__Stock_In_Product__c where Stock_In__c =: stockIn.id AND Status__c NOT IN('Verified')]; 
                
                 for(Stock_In_Product__c  sIN:stockInProdList)
                {
                    sINList.add(sIN.Id);             
                }
           
                ProductSerialNumberList=[Select Id,Name,sigmaerpdev__Location__c,sigmaerpdev__Purchase_Order__r.Name,sigmaerpdev__Purchase_Order__r.Id,sigmaerpdev__Purchase_Order_Product__c,
                                         sigmaerpdev__Stock_Receiving_Product__c,sigmaerpdev__Product_Code__r.Name,sigmaerpdev__Code__c,sigmaerpdev__Serial_Number__c,sigmaerpdev__Product_Code__c 
                                         from sigmaerpdev__Product_Serial_Number__c where sigmaerpdev__Stock_Receiving_Product__c=:sINList];
                     
   }
            return stockIn;             
     }
    @AuraEnabled
    public static List<Stock_In_Product__c> editStProducts() {
            return StockRecevingControllerLtng.stockInProdList;
    } 
    
     @AuraEnabled
    public static List<Product_Serial_Number__c> editProductSerialNumber() {
            return StockRecevingControllerLtng.ProductSerialNumberList;
    } 
      
    @AuraEnabled
    public static  Stock_In__c  updateStockInProduct(Stock_In__c stockInObj,String stockInProduts,String psn) 
    {
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Lot__c',new set<String>{'Id','Name'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location__c',new set<String>{'Id','Name','sigmaerpdev__Location__c','sigmaerpdev__Location__r.Id'})
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Lot_Product__c',new set<String>{'Id','Name','sigmaerpdev__Location__c','sigmaerpdev__Quantity__c'})
             &&CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'Id','Name','sigmaerpdev__Email__c'})
          &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Stock_In_Product__c',new set<String>{'Id','Name','sigmaerpdev__Quantity_Received__c','sigmaerpdev__Product__c','sigmaerpdev__Lot__c',
                                'sigmaerpdev__Lot__r.Id','sigmaerpdev__Inventory_Location__c','sigmaerpdev__Status__c','sigmaerpdev__Putaway_location__c','sigmaerpdev__Pur_Order__c','sigmaerpdev__Purchase_Order__c','sigmaerpdev__Purchase_Order__r.sigmaerpdev__Product__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Serial_Number__c',new set<string>{'Id','Name'})
            &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Stock_In_Product__c',new set<String>{'sigmaerpdev__Stock_In__c','sigmaerpdev__Product__c','sigmaerpdev__Pur_Order__c','sigmaerpdev__Lot__c','sigmaerpdev__Purchase_Order__c','sigmaerpdev__Quantity_Received__c','sigmaerpdev__Returned_Quantity__c','sigmaerpdev__Putaway_location__c','sigmaerpdev__Status__c','sigmaerpdev__Return_Quantity_Comment__c','sigmaerpdev__Inventory_Location__c','sigmaerpdev__Vendor_Email__c'})
            &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Serial_Number__c',new set<String>{'sigmaerpdev__location__c','sigmaerpdev__Product_Code__c','sigmaerpdev__Purchase_Order__c','sigmaerpdev__Serial_Number__c','sigmaerpdev__Stock_Receiving_Product__c','sigmaerpdev__Purchase_Order_Product__c'})
            &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Lot_Product__c',new set<String>{'sigmaerpdev__Quantity__c','sigmaerpdev__Lot__c','sigmaerpdev__Location__c','sigmaerpdev__Product__c'})
            &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Stock_In__c')
            &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Stock_Receiving_Product_Line_Item__c',new set<String>{'sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Product__c'})
            &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Stock_Receiving_Product_Line_Item__c',new set<String>{'sigmaerpdev__Stock_Receiving_Product__c'})
        )
        {   
          
            Map<String,List<Lot_Product__c>> lotMap = new Map<String,List<Lot_Product__c>>();
           Map<String,Stock_In_Product__c>  getStockInProductMap= new Map<String,Stock_In_Product__c>();
            List<Lot__c> lotList = [Select Id,Name,(Select Id,Name,sigmaerpdev__Location__c,sigmaerpdev__Quantity__c From sigmaerpdev__Lot_Products__r) From sigmaerpdev__Lot__c Limit 1000];
           
            for(Lot__c lt:lotList){
               lotMap.put(lt.Id,lt.Lot_Products__r);
            }
            
                 upsert stockInObj;
              Account vendoracc=[Select Id,Name,sigmaerpdev__Email__c from Account where id=:StockInObj.sigmaerpdev__Vendor__c];
      
      // Getting All Inventory Starts
       Map<String,String> inventoryLocMap = new Map<String,String>();
       List<Inventory_Location__c>  invLocList;       
      
           invLocList = [Select Id,Name,sigmaerpdev__Location__c,sigmaerpdev__Location__r.Id From sigmaerpdev__Inventory_Location__c limit 50000];
         
       for(Inventory_Location__c ill:invLocList){
           inventoryLocMap.put(ill.Location__r.Id,ill.Id);
       }      
                        
            Object[] values = (Object[])System.JSON.deserializeUntyped(stockInProduts);
                   
            List<Stock_In_Product__c> stockInProductListForInsert = new List<Stock_In_Product__c>();
            List<Stock_In_Product__c> stockInProductListForUpdate = new List<Stock_In_Product__c>();
            List<Stock_In_Product__c> sipToUpsertVerified = new List<Stock_In_Product__c>();
            List<Stock_In_Product__c> sipsToUpsertVerified = new List<Stock_In_Product__c>();
            List<Product_Serial_Number__c> psnToUpsert = new List<Product_Serial_Number__c>();    
            for(Object obj:values)
            {
                    
                    String str = JSON.serialize(obj);
                    Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(str);
                    Stock_In_Product__c sInPrd= new  Stock_In_Product__c();
                
                     Stock_In_Product__c tempCarrierForPSN = new Stock_In_Product__c();
                    if(String.valueOf(root.get('Id')) != null)
                    {
                       // if(FLSCheckInsertStock_In_Product()){
                          sInPrd.Id = String.valueOf(root.get('Id'));
                          if(root.get('sigmaerpdev__Pur_Order__c')!=null)
                          {
                          sInPrd.Pur_Order__c= String.valueOf(root.get('sigmaerpdev__Pur_Order__c'));
                          }
                          if(root.get('sigmaerpdev__Lot__c') !=null){
                            sInPrd.Lot__c = String.valueOf(root.get('sigmaerpdev__Lot__c'));
                            }
                        if(root.get('sigmaerpdev__Purchase_Order__c')!=null)
                          {
                          sInPrd.Purchase_Order__c= String.valueOf(root.get('sigmaerpdev__Purchase_Order__c'));
                          }
                          if(root.get('sigmaerpdev__Quantity_Received__c')!=null)
                          {
                          Integer oldValue1 = Integer.valueOf(root.get('sigmaerpdev__Quantity_Received__c'));
                          sInPrd.Quantity_Received__c= oldValue1;
                          }
                          if(root.get('sigmaerpdev__Returned_Quantity__c')!=null)
                          {
                          Integer oldValue2 = Integer.valueOf(root.get('sigmaerpdev__Returned_Quantity__c'));
                          sInPrd.Returned_Quantity__c= oldValue2;
                          }else
                          {
                             sInPrd.Returned_Quantity__c= 0;
                          }
                          if(root.get('sigmaerpdev__Putaway_location__c')!=null)
                          {
                          sInPrd.Putaway_location__c= String.valueOf(root.get('sigmaerpdev__Putaway_location__c'));
                          sInPrd.Inventory_Location__c = inventoryLocMap.get(String.valueOf(root.get('sigmaerpdev__Putaway_location__c')));
                          tempCarrierForPSN.Putaway_location__c = String.valueOf(root.get('sigmaerpdev__Putaway_location__c'));
                          }
                          if(root.get('sigmaerpdev__Status__c')!=null)
                          {
                          sInPrd.Status__c= String.valueOf(root.get('sigmaerpdev__Status__c'));
                          }
                          if(root.get('sigmaerpdev__Return_Quantity_Comment__c')!=null)
                          {
                          sInPrd.Return_Quantity_Comment__c= String.valueOf(root.get('sigmaerpdev__Return_Quantity_Comment__c'));
                          }
                          else{
                          sInPrd.Return_Quantity_Comment__c='';
                          }
                            if(root.get('sigmaerpdev__Product__c') != null){
                                sInPrd.Product__c=String.valueOf(root.get('sigmaerpdev__Product__c'));
                                String tempProductId = String.valueOf(root.get('sigmaerpdev__Product__c'));
                                getStockInProductMap.put(tempProductId,tempCarrierForPSN);
                            }
                          sInPrd.sigmaerpdev__Vendor_Email__c=vendoracc.sigmaerpdev__Email__c;
                          stockInProductListForUpdate.add(sInPrd);
                     
                      
                   }else
                   {
                      
                            sInPrd = new Stock_In_Product__c();
                            if(root.get('sigmaerpdev__Pur_Order__c')!=null)
                            {
                            sInPrd.pur_Order__c= String.valueOf(root.get('sigmaerpdev__Pur_Order__c'));
                            }
                            if(root.get('sigmaerpdev__Purchase_Order__c')!=null)
                            {
                            sInPrd.Purchase_Order__c= String.valueOf(root.get('sigmaerpdev__Purchase_Order__c'));
                            }
                            if(root.get('sigmaerpdev__Lot__c') !=null){
                            sInPrd.Lot__c = String.valueOf(root.get('sigmaerpdev__Lot__c'));
                            }
                            if(root.get('sigmaerpdev__Quantity_Received__c')!='')
                            {
                            Integer oldValue1 = Integer.valueOf(root.get('sigmaerpdev__Quantity_Received__c'));
                            sInPrd.Quantity_Received__c= oldValue1;
                            }
                            if(root.get('sigmaerpdev__Returned_Quantity__c')!='')
                            {
                            Integer oldValue2 = Integer.valueOf(root.get('sigmaerpdev__Returned_Quantity__c'));
                            sInPrd.Returned_Quantity__c= oldValue2;
                            }else
                            {
                             sInPrd.Returned_Quantity__c= 0;
                            }
                            if(root.get('sigmaerpdev__Putaway_location__c')!=null)
                            {
                            sInPrd.Putaway_location__c= String.valueOf(root.get('sigmaerpdev__Putaway_location__c'));
                            sInPrd.Inventory_Location__c = inventoryLocMap.get(String.valueOf(root.get('sigmaerpdev__Putaway_location__c')));
                            tempCarrierForPSN.Putaway_location__c = String.valueOf(root.get('sigmaerpdev__Putaway_location__c'));
                            }
                            if(root.get('sigmaerpdev__Status__c')!=null)
                            {
                            sInPrd.Status__c= String.valueOf(root.get('sigmaerpdev__Status__c'));
                            }else{
                               sInPrd.Status__c='Open';
                            }
                            if(root.get('sigmaerpdev__Return_Quantity_Comment__c')!='')
                            {
                            sInPrd.Return_Quantity_Comment__c= String.valueOf(root.get('sigmaerpdev__Return_Quantity_Comment__c')); 
                            }else{
                             sInPrd.Return_Quantity_Comment__c=' ddd';
                            }
                            if(root.get('sigmaerpdev__Product__c') != null){
                                sInPrd.Product__c=String.valueOf(root.get('sigmaerpdev__Product__c'));
                                String tempProductId = String.valueOf(root.get('sigmaerpdev__Product__c'));
                                getStockInProductMap.put(tempProductId,tempCarrierForPSN);
                            }
                            sInPrd.sigmaerpdev__Vendor_Email__c=vendoracc.sigmaerpdev__Email__c;
                            sInPrd.Stock_In__c=stockInObj.Id; 
                            stockInProductListForInsert.add(sInPrd); 
                                         
               
                   }
              }
              
           
             
           if(stockInProductListForUpdate.size()>0) 
                 {
                update stockInProductListForUpdate; 
                 }
                 
                 if(stockInProductListForInsert.size()>0) 
                 {
                      insert stockInProductListForInsert;
                 }
               
                 
            Stock_In_Product__c siprod = new Stock_In_Product__c();
            
            for(Stock_In_Product__c stockprodlist1: stockInProductListForUpdate)
                 {
                     if(stockprodlist1.Status__c =='Verified')
                     {
                    siprod = stockprodlist1;
                    sipToUpsertVerified.add(siprod);
                     }
                          
                 }
        
       
            for(Stock_In_Product__c stockprodlist2: stockInProductListForInsert)
                 {
                     if(stockprodlist2.Status__c =='Verified')
                     {
                      siprod = stockprodlist2;
                        sipToUpsertVerified.add(siprod); 
                     }
                    
                 }
        
             for(Stock_In_Product__c sicc: sipToUpsertVerified)
            {
             if(sicc.Quantity_Received__c >0)
             sipsToUpsertVerified.add(sicc);
            }
            
            
            List<Stock_In_Product__c> stockInProdLst;
           
                stockInProdLst = [Select Id,Name,sigmaerpdev__Quantity_Received__c,sigmaerpdev__Product__c,sigmaerpdev__Lot__c,
                                sigmaerpdev__Lot__r.Id,sigmaerpdev__Inventory_Location__c,sigmaerpdev__Status__c
                               From sigmaerpdev__Stock_In_Product__c where Id IN:stockInProductListForUpdate OR Id IN:stockInProductListForInsert];
              
            List<Lot_Product__c> lotProductsList = new List<Lot_Product__c>();
        // commented by chandana because lot updatedining funcationality is in ilpupdate class testing
       Map<id,Map<id,decimal>> lotqty=new  Map<id,Map<id,decimal>>();
                for(Stock_In_Product__c lotpp:stockInProdLst)
                 {
                    if(lotpp.Status__c == 'Verified')
                    { 
                         if(lotqty.containsKey(lotpp.sigmaerpdev__Product__c))
                         {
                             if(lotqty.get(lotpp.sigmaerpdev__Product__c).containsKey(lotpp.sigmaerpdev__Inventory_Location__c))
                             {
                            lotpp.sigmaerpdev__Quantity_Received__c=lotqty.get(lotpp.sigmaerpdev__Product__c).get(lotpp.sigmaerpdev__Inventory_Location__c)+lotpp.sigmaerpdev__Quantity_Received__c;
                            lotqty.get(lotpp.sigmaerpdev__Product__c).put(lotpp.sigmaerpdev__Inventory_Location__c,lotpp.sigmaerpdev__Quantity_Received__c);
                             }
                             else
                             {
                             lotqty.get(lotpp.sigmaerpdev__Product__c).put(lotpp.sigmaerpdev__Inventory_Location__c,lotpp.sigmaerpdev__Quantity_Received__c);
                            
                             }
                        }
                     else
                     {
                        Map<id,decimal> lotil= new Map<id,decimal>();
                        lotil.put(lotpp.sigmaerpdev__Inventory_Location__c,lotpp.sigmaerpdev__Quantity_Received__c);
                     lotqty.put(lotpp.sigmaerpdev__Product__c,lotil);
                     }
                    
                    }
                    
                 }
                
             Map<id, Map<id,decimal>> lotproqty=new Map<id, Map<id,decimal>>();
            for(Stock_In_Product__c pp:stockInProdLst)
            {
                if(pp.Lot__c!=null)
                {
                List<Lot_Product__c> lotProdList = lotMap.get(pp.Lot__c);
                Boolean isMatched = false;
                if(lotProdList != null){
                    Lot_Product__c lotProd;// = new Lot_Product__c();
                    for(Lot_Product__c lp:lotProdList){
                        if(lp.Location__c == pp.Inventory_Location__c){
                            lotProd = lp;                                               
                            isMatched = true;
                            break;
                        }
                    }
                    if(isMatched == true && pp.Status__c == 'Verified'){
                        if(!lotproqty.containsKey(pp.sigmaerpdev__Product__c)){ 
                         //updateLotProductStaus = true;  

                        Map<id,decimal> lotil= new Map<id,decimal>();
                        lotil.put(pp.sigmaerpdev__Inventory_Location__c,pp.sigmaerpdev__Quantity_Received__c);                         
                            lotproqty.put(pp.sigmaerpdev__Product__c,lotil);
                            lotProd.Quantity__c = lotProd.Quantity__c + lotqty.get(pp.sigmaerpdev__Product__c).get(pp.sigmaerpdev__Inventory_Location__c);
                             lotProductsList.add(lotProd);
                       }
                        else if(lotproqty.containsKey(pp.sigmaerpdev__Product__c))
                        {
                            if(!lotproqty.get(pp.sigmaerpdev__Product__c).containsKey(pp.sigmaerpdev__Inventory_Location__c))
                            {
                                Map<id,decimal> lotil= new Map<id,decimal>();
                        lotil.put(pp.sigmaerpdev__Inventory_Location__c,pp.sigmaerpdev__Quantity_Received__c);
                                lotproqty.put(pp.sigmaerpdev__Product__c,lotil);
                            lotProd.Quantity__c = lotProd.Quantity__c + lotqty.get(pp.sigmaerpdev__Product__c).get(pp.sigmaerpdev__Inventory_Location__c);
                             lotProductsList.add(lotProd);
                            }
                        }
                    }else{
                        if(!lotproqty.containsKey(pp.sigmaerpdev__Product__c)&& pp.Status__c == 'Verified')
                       {
                               Map<id,decimal> lotil= new Map<id,decimal>();
                        lotil.put(pp.sigmaerpdev__Inventory_Location__c,pp.sigmaerpdev__Quantity_Received__c);
                        lotproqty.put(pp.sigmaerpdev__Product__c,lotil);
                         //updateLotProductStaus = true;
                       
                        lotProd = new Lot_Product__c();
                        lotProd.Product__c = pp.Product__c;
                        lotProd.Location__c = pp.Inventory_Location__c;
                        lotProd.Lot__c = pp.Lot__c;
                        if(lotProd.Quantity__c==null)
                        {
                            lotProd.Quantity__c=0;
                        }
                        lotProd.Quantity__c = lotProd.Quantity__c +  lotqty.get(pp.sigmaerpdev__Product__c).get(pp.sigmaerpdev__Inventory_Location__c);
                        lotProductsList.add(lotProd);
                        }
                        else if(lotproqty.containsKey(pp.sigmaerpdev__Product__c))
                        {
                            if(!lotproqty.get(pp.sigmaerpdev__Product__c).containsKey(pp.sigmaerpdev__Inventory_Location__c))
                            {
                                Map<id,decimal> lotil= new Map<id,decimal>();
                                lotil.put(pp.sigmaerpdev__Inventory_Location__c,pp.sigmaerpdev__Quantity_Received__c);
                                lotproqty.put(pp.sigmaerpdev__Product__c,lotil);
                           
                                lotProd = new Lot_Product__c();
                                lotProd.Product__c = pp.Product__c;
                                lotProd.Location__c = pp.Inventory_Location__c;
                                lotProd.Lot__c = pp.Lot__c;
                                if(lotProd.Quantity__c==null)
                                {
                                    lotProd.Quantity__c=0;
                                }
                                   lotProd.Quantity__c = lotProd.Quantity__c + lotqty.get(pp.sigmaerpdev__Product__c).get(pp.sigmaerpdev__Inventory_Location__c);
                                   lotProductsList.add(lotProd);
                            }
                        }
                    }
                }
            }
            }
            //commented by chandana 
          
                upsert lotProductsList;
           
            
            Map<Integer,String>  ll=new Map<Integer,String>();
        
            integer k=stockInProductListForUpdate.size()-1;
            for(Stock_In_Product__c  sINP:stockInProductListForInsert)
            {
               k++;
               ll.put(k,sINP.Id);
              
            }
        */
            
         /*  **************  Product Serial Number Starts Here ***************** */
          /*   
          List<Product_Serial_Number__c> psnListForInsert = new List<Product_Serial_Number__c>();
          List<Product_Serial_Number__c> psnListForUpdate = new List<Product_Serial_Number__c>();
          Object[] psnvalues = (Object[])System.JSON.deserializeUntyped(psn);
             Map<ID,Product_Serial_Number__c> Stockinproduct=new Map<ID,Product_Serial_Number__c>();
          for(Object obj:psnvalues)
          {
                    
                    String str = JSON.serialize(obj);
                    Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(str);
                    Product_Serial_Number__c sInPrd = new Product_Serial_Number__c();
                   Stock_In_Product__c tempCarrierForPSN1 = new Stock_In_Product__c();
                    if(String.valueOf(root.get('Id')) != null)
                    {
                        
                            sInPrd.Id = String.valueOf(root.get('Id'));
                            if(root.get('sigmaerpdev__Serial_Number__c')!='')
                            {
                            sInPrd.Serial_Number__c= String.valueOf(root.get('sigmaerpdev__Serial_Number__c'));
                            }
                            if(root.get('sigmaerpdev__Purchase_Order__c')!=null)
                            {
                             sInPrd.Purchase_Order__c= String.valueOf(root.get('sigmaerpdev__Purchase_Order__c'));
                            }
                    
                            if(root.get('sigmaerpdev__Purchase_Order__c')!='')
                            {
                            sInPrd.Purchase_Order__c= String.valueOf(root.get('sigmaerpdev__Purchase_Order__c'));
                            }
                             if(root.get('sigmaerpdev__Purchase_Order_Product__c')!='')
                                {
                                  sInPrd.sigmaerpdev__Purchase_Order_Product__c= String.valueOf(root.get('sigmaerpdev__Purchase_Order_Product__c'));
                                }
                            if(root.get('sigmaerpdev__Product_Code__c')!='')
                            {
                            sInPrd.Product_Code__c= String.valueOf(root.get('sigmaerpdev__Product_Code__c'));
                            }
                            if(root.get('sigmaerpdev__Stock_Receiving_Product__c')!='')
                            {
                            sInPrd.sigmaerpdev__Stock_Receiving_Product__c= String.valueOf(root.get('sigmaerpdev__Stock_Receiving_Product__c'));
                            }
                            
                            if(root.get('sigmaerpdev__Location__c')!=null)
                            {
                            sInPrd.location__c= String.valueOf(root.get('sigmaerpdev__Location__c'));
                            }
                            else
                            {
                                if(getStockInProductMap.containsKey(String.valueOf(root.get('sigmaerpdev__Product_Code__c'))))
                            {   
                            tempCarrierForPSN1 = getStockInProductMap.get(String.valueOf(root.get('sigmaerpdev__Product_Code__c')));
                            sInPrd.location__c = tempCarrierForPSN1.Putaway_location__c;
                              }
                           
                            }
                             for(Integer m=0; m<stockInProductListForUpdate.size(); m++)
                         {
                        if(stockInProductListForUpdate[m].Purchase_Order__c ==sInPrd.sigmaerpdev__Purchase_Order_Product__c && stockInProductListForUpdate[m].pur_Order__c ==sInPrd.Purchase_Order__c&& stockInProductListForUpdate[m].sigmaerpdev__Putaway_location__c==sInPrd.sigmaerpdev__Location__c)
                           
                           {
                                sInPrd.Stock_Receiving_Product__c=stockInProductListForUpdate[m].Id;
                                if(!Stockinproduct.containsKey(sInPrd.Stock_Receiving_Product__c))
                        {
                            Stockinproduct.put(sInPrd.Stock_Receiving_Product__c,sInPrd);
                           
                        }
                              
                            }
                    
                        
                        }
                           
                            psnListForUpdate.add(sInPrd);
                            System.debug('psnListForUpdate::'+psnListForUpdate);
                           
                                             
                    }else
                    {
                        sInPrd = new Product_Serial_Number__c();
                       
                           System.debug('root:::'+root);
                        
                            if(root.get('sigmaerpdev__Serial_Number__c')!=null)
                            {                            
                            sInPrd.Serial_Number__c= String.valueOf(root.get('sigmaerpdev__Serial_Number__c'));
                            }
                            if(root.get('sigmaerpdev__Purchase_Order__c')!=null)
                            {
                            sInPrd.Purchase_Order__c= String.valueOf(root.get('sigmaerpdev__Purchase_Order__c'));
                            }
                            if(root.get('sigmaerpdev__Purchase_Order_Product__c')!='')
                            {
                            sInPrd.sigmaerpdev__Purchase_Order_Product__c= String.valueOf(root.get('sigmaerpdev__Purchase_Order_Product__c'));
                            }
                             
                            if(root.get('sigmaerpdev__Product_Code__c')!=null)
                            {
                            sInPrd.Product_Code__c= String.valueOf(root.get('sigmaerpdev__Product_Code__c'));
                            }
                            if(root.get('sigmaerpdev__Location__c')!=null)
                            {
                            sInPrd.location__c= String.valueOf(root.get('sigmaerpdev__Location__c'));
                            }
                             else
                            {
                                if(getStockInProductMap.containsKey(String.valueOf(root.get('sigmaerpdev__Product_Code__c'))))
                            {   
                            tempCarrierForPSN1 = getStockInProductMap.get(String.valueOf(root.get('sigmaerpdev__Product_Code__c')));
                            sInPrd.location__c = tempCarrierForPSN1.Putaway_location__c;
                              }
                           
                            }
                             
            
                        for(Integer m=0; m<stockInProductListForInsert.size(); m++)
                         {
                            if(stockInProductListForInsert[m].Purchase_Order__c ==sInPrd.sigmaerpdev__Purchase_Order_Product__c && stockInProductListForInsert[m].pur_Order__c ==sInPrd.Purchase_Order__c&& stockInProductListForInsert[m].sigmaerpdev__Putaway_location__c==sInPrd.sigmaerpdev__Location__c)
                           {
                                sInPrd.Stock_Receiving_Product__c=stockInProductListForInsert[m].Id;
                                if(!Stockinproduct.containsKey(sInPrd.Stock_Receiving_Product__c))
                                {
                                Stockinproduct.put(sInPrd.Stock_Receiving_Product__c,sInPrd);
                                }
                              
                            }
                    
                        
                        }
                          
                            psnListForInsert.add(sInPrd);
                        }
          }
          List<Stock_In_Product__c> Receivingproducts=new List<Stock_In_Product__c>();
        Receivingproducts = [select Id,Name,sigmaerpdev__Purchase_Order__c,sigmaerpdev__Quantity_Received__c,Purchase_Order__r.Product__r.Attribute_Type__c,sigmaerpdev__Pur_Order__c,Purchase_Order__r.Product__c,sigmaerpdev__Putaway_location__c from sigmaerpdev__Stock_In_Product__c where Id In : stockInProductListForInsert OR Id In : stockInProductListForUpdate];
   
         for(Stock_In_Product__c stocklineitems: Receivingproducts)
            {
              
                if(stocklineitems.Purchase_Order__r.Product__r.Attribute_Type__c =='SERIALIZED' && !Stockinproduct.containsKey(stocklineitems.id))
                {
                    for(Integer i=0;i<stocklineitems.sigmaerpdev__Quantity_Received__c;i++)
                    {
                        Product_Serial_Number__c sInPrditem = new Product_Serial_Number__c();
                         sInPrditem.Purchase_Order__c=stocklineitems.sigmaerpdev__Pur_Order__c;
                         sInPrditem.sigmaerpdev__Purchase_Order_Product__c=stocklineitems.sigmaerpdev__Purchase_Order__c;
                         sInPrditem.Product_Code__c=stocklineitems.Purchase_Order__r.Product__c;
                          sInPrditem.location__c=stocklineitems.Putaway_location__c;
                          sInPrditem.Stock_Receiving_Product__c=stocklineitems.id;
                          psnListForInsert.add(sInPrditem);
                        
                    }
                    
                }
            }
       System.debug('psnListForUpdate::'+psnListForUpdate);
           update psnListForUpdate;
           System.debug('psnListForUpdate::'+psnListForUpdate);
            insert psnListForInsert;
         
        Product_Serial_Number__c sipsnlist = new Product_Serial_Number__c();
     
    for(Product_Serial_Number__c psnlist2: psnListForInsert)
        {
            sipsnlist = psnlist2;
            psnListForUpdate.add(sipsnlist);                         
        }
   
        //new code Stock_Receiving_Product_Line_Item__c by chandana 
        List<Stock_In_Product__c> sipWithPSN = [select Id,Name,sigmaerpdev__Putaway_location__c,sigmaerpdev__Pur_Order__c,sigmaerpdev__Purchase_Order__c,sigmaerpdev__Quantity_Received__c, sigmaerpdev__Lot__c,sigmaerpdev__Purchase_Order__r.sigmaerpdev__Product__c,sigmaerpdev__Purchase_Order__r.Product__r.sigmaerpdev__Attribute_Type__c,sigmaerpdev__Status__c,(select Id, Name from sigmaerpdev__Product_Serial_Numbers__r) from sigmaerpdev__Stock_In_Product__c where Id In : sipToUpsertVerified];
        List<Stock_Receiving_Product_Line_Item__c> srpliListToUpsert = new List<Stock_Receiving_Product_Line_Item__c>();
   
        
        if(sipWithPSN.size() > 0)
        {
      for(Stock_In_Product__c srpInd : sipWithPSN)
      {
                 
        if(srpInd.Status__c == 'Verified')
        {
            //for BULK Product
                if(srpInd.Purchase_Order__r.Product__r.Attribute_Type__c == 'BULK')
                {
                    
                    Stock_Receiving_Product_Line_Item__c srpli = new Stock_Receiving_Product_Line_Item__c();
                    srpli.Stock_Receiving_Product__c = srpInd.Id;
                    srpli.Product__c = srpInd.Purchase_Order__r.Product__c;
                    srpliListToUpsert.add(srpli);
                }
                
                //for SERIALIZED Product
               
                for(Product_Serial_Number__c psn1 : srpInd.Product_Serial_Numbers__r)
                {
                    Stock_Receiving_Product_Line_Item__c srpli = new Stock_Receiving_Product_Line_Item__c();
                    srpli.Stock_Receiving_Product__c = srpInd.Id;
                    srpli.Product__c = srpInd.Purchase_Order__r.Product__c;
                    srpli.Product_Serial_Number__c = psn1.Id;
                    srpliListToUpsert.add(srpli);
                }
        
        
      }
        
      }
             ilpUpdate.updateILP(sipsToUpsertVerified,psnListForUpdate,srpliListToUpsert);
           
      }
       
        if(srpliListToUpsert.size() > 0)
            upsert srpliListToUpsert;
       
        }   
        return stockInObj; 
    } 
    
    @AuraEnabled 
    public static String getProductId(String POPNumber) 
    {
         //FLS Check : Sandhya
         String pId;
         if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Purchase_Order_Product__c',new set<String>{'Id','Name','sigmaerpdev__Product__r.Id','sigmaerpdev__Product__r.Name'}))
         {
         Purchase_Order_Product__c  pName;
       
        pName = [Select Id,Name,sigmaerpdev__Product__r.Id,sigmaerpdev__Product__r.Name from sigmaerpdev__Purchase_Order_Product__c where Id=:POPNumber];
                 
        pId = pName.Product__r.Id;
         }
        return pId;           
    }  
    
    @AuraEnabled 
    public static Purchase_Order_Product__c getSerialized(String Id) 
    {
         
        list<string>  poplist=new list<String>();
        Purchase_Order_Product__c purOrdPrd;
        //FLS Check : Sandhya
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Purchase_Order_Product__c',new set<string>{'Id','Name','sigmaerpdev__Orderd_Quantity__c','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Id','sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c'}))
        {
         purOrdPrd = [Select Id,Name,sigmaerpdev__Orderd_Quantity__c,sigmaerpdev__Product__c,sigmaerpdev__Product__r.Id,sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c From sigmaerpdev__Purchase_Order_Product__c where id =:Id];          
            
        String rtnVal = purOrdPrd.Product__r.Attribute_Type__c;
       
        }
        
        return purOrdPrd;
    }
    @AuraEnabled 
    public static String getOrderedQuantity(String Id) 
    {
        Decimal vari;
        String rtnVal;
      
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Purchase_Order_Product__c',new set<String>{'Id','Name','sigmaerpdev__Received_Quantity__c','sigmaerpdev__Quantity__c','sigmaerpdev__Product__c','sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c'}))
        {
        list<string>  poplist=new list<String>();
        Purchase_Order_Product__c purOrdPrd;
       
            purOrdPrd = [Select Id,Name,sigmaerpdev__Received_Quantity__c,sigmaerpdev__Quantity__c,sigmaerpdev__Product__c,sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c From sigmaerpdev__Purchase_Order_Product__c where id =:Id];          
              
        vari=purOrdPrd.Received_Quantity__c;
        
       rtnVal = vari.toPlainString();
        
        }
        
        return rtnVal;
    }
    
    @AuraEnabled
    public static void deleteStockInProduct(String StockInProduct) 
    {
       
           if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Stock_In_Product__c',new set<String>{'Id','Name'})
              &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Stock_In_Product__c')
           )
           {   
            
         Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(StockInProduct);
       
            
         if(String.valueOf(root.get('Id')) != null){
                  List<sigmaerpdev__Stock_In_Product__c> stockInList;
                   
                    stockInList= [Select Id,Name From sigmaerpdev__Stock_In_Product__c where Id=:String.valueOf(root.get('Id'))];
                    
                   
                     delete stockInList;
                    
              }
           }            
     }  
    @AuraEnabled
    public static void deleteProductSerialNumber(string proSerialNumber) 
    {
        // FLS Check : Sandhya
           if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Serial_Number__c',new set<String>{'Id','Name'})
              && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Serial_Number__c')   
           )
         {
             System.debug('proSerialNumber'+proSerialNumber);
             List<id> psnid=new List<id>();
             Object[] values = (Object[])System.JSON.deserializeUntyped(proSerialNumber);
            for(Object obj:values)
            {
             String str = JSON.serialize(obj);
              System.debug('str'+str);
             Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(str);
                if(String.valueOf(root.get('Id')) != null)
                {
                psnid.add(String.valueOf(root.get('Id')));
                }
            } 
             
           List< Product_Serial_Number__c> psn=[Select Id,Name From  sigmaerpdev__Product_Serial_Number__c where Id=:psnid];
           delete psn;  
            
         }   
          
     }    
      
     @AuraEnabled 
     public static List<Product_Serial_Number__c>   getProductPSN(String stockRPId)
     {
         //FLS Check : Sandhya
         List<Product_Serial_Number__c> prodSerialNumberList;
         if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Serial_Number__c',new set<String>{'Id','Name','sigmaerpdev__Purchase_Order__r.Name','sigmaerpdev__Purchase_Order__r.Id','sigmaerpdev__Product_Code__r.Name','sigmaerpdev__Code__c',
                                                      'sigmaerpdev__Serial_Number__c','sigmaerpdev__Product_Code__c','sigmaerpdev__Stock_Receiving_Product__c'}))
         {
         String prodSN = stockRPId.substring(1, stockRPId.length()-1);
        
        prodSerialNumberList=[Select Id,Name,sigmaerpdev__Purchase_Order__r.Name,sigmaerpdev__Purchase_Order__r.Id,sigmaerpdev__Product_Code__r.Name,sigmaerpdev__Code__c,
                                         sigmaerpdev__Serial_Number__c,sigmaerpdev__Product_Code__c from sigmaerpdev__Product_Serial_Number__c where 
                                         sigmaerpdev__Stock_Receiving_Product__c=:prodSN];
          
         }
         return prodSerialNumberList;
     
     }
     
     
       
     @AuraEnabled 
     public static List<Product_Serial_Number__c> checkDuplicateProductPSN(String validatePSN,String ProductID)
     {
         //FLS Check : Sandhya
         List<Product_Serial_Number__c> prodSerialNumberList;
         if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'Id','Name','sigmaerpdev__Serial_Number__c','sigmaerpdev__Product_Code__c'}))
                    {
          Object[] psnvalues = (Object[])System.JSON.deserializeUntyped(validatePSN);
          List<String> psnlist=new List<String>();
          
          for(Object obj:psnvalues)
          {
                    
                    String str = JSON.serialize(obj);
                    Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(str);
                    psnlist.add(String.ValueOF(root.get('sigmaerpdev__Serial_Number__c')));
         }
         
        
         prodSerialNumberList=[Select Id,Name,sigmaerpdev__Serial_Number__c from sigmaerpdev__Product_Serial_Number__c
                            where sigmaerpdev__Serial_Number__c IN:psnlist and sigmaerpdev__Product_Code__c=:ProductID];
        
        }
         return prodSerialNumberList;
     
     }
   @AuraEnabled
    public static void removeProductSerialNumber(string proSerialNumber) 
    {
        // FLS Check : Sandhya
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Serial_Number__c',new set<String>{'Id','Name'})
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Serial_Number__c')   
          )
        {
           Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(proSerialNumber);
            
            if(String.valueOf(root.get('Id')) != null)
            {
                List< Product_Serial_Number__c> psn;
                
                    psn= [Select Id,Name From  sigmaerpdev__Product_Serial_Number__c where Id=:String.valueOf(root.get('Id'))];
               
                    delete psn;
                
            }
        }   
        
    }    */

}