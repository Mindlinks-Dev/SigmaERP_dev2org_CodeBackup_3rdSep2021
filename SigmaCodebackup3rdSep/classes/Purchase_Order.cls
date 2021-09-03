public class Purchase_Order {
    @AuraEnabled
    public static Account fetchAccountData(Id accId)
    {
        Account acc=new Account();
       
            acc=[select id,name,sigmaerpdev2__Default_Location__c,sigmaerpdev2__Tax_Treatment__c,(Select id,name from contacts ), sigmaerpdev2__Tax_Treatment__r.name,sigmaerpdev2__Vendor_Tax_Treatment__c,sigmaerpdev2__Vendor_Tax_Treatment__r.Name,ShippingCity,ShippingCountry,ShippingPostalCode,ShippingState,ShippingStreet,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet from Account where id=:accId];
            system.debug('acc>>'+acc);
        
        return acc;
    }
  @AuraEnabled
    public static PurchaseOrderUpdateWrap getPurchaseOrderData(String PoId){
        system.debug('PoId>>>'+PoId);
        PurchaseOrderUpdateWrap PoEdit=new PurchaseOrderUpdateWrap();
        
        
           
            List<PurchaseOrderProductWrap> PopWrapList = new List<PurchaseOrderProductWrap>(); 
            PoEdit.po = [select Id,Name,sigmaerpdev2__Net_Amount__c,sigmaerpdev2__Total_Amount1__c,sigmaerpdev2__Product_Supplier__c,sigmaerpdev2__Tax_Treatment__c,sigmaerpdev2__Tax_Treatment__r.name,sigmaerpdev2__Product_Supplier__r.Name,sigmaerpdev2__Contact__r.Name,sigmaerpdev2__City__c,sigmaerpdev2__Company__c,sigmaerpdev2__Company__r.Name,sigmaerpdev2__Contact__c,sigmaerpdev2__Country__c,sigmaerpdev2__Order_Date__c,sigmaerpdev2__Description__c,sigmaerpdev2__Legal_Note__c, sigmaerpdev2__Shipping_City__c,sigmaerpdev2__Shipping_Country__c,sigmaerpdev2__Shipping_State_Province__c,sigmaerpdev2__Shipping_Street__c,sigmaerpdev2__Shipping_Zip_Postal_Code__c,sigmaerpdev2__State_Province__c,sigmaerpdev2__Status__c,sigmaerpdev2__Street__c,sigmaerpdev2__Tax_Amount__c,sigmaerpdev2__Zip_Postal_Code__c from sigmaerpdev2__Purchase_Order__c where Id =:PoId];
            
            for(sigmaerpdev2__Purchase_Order_Product__c polref:[select Id,name,sigmaerpdev2__Net_Amount__c,sigmaerpdev2__Total_Amount__c,sigmaerpdev2__Tax_Code__c, sigmaerpdev2__Tax_Code__r.name,sigmaerpdev2__Description__c,sigmaerpdev2__Buying_Price__c,sigmaerpdev2__Discount__c,sigmaerpdev2__Product__c,sigmaerpdev2__Product__r.Name,sigmaerpdev2__Purchase_Order__c,sigmaerpdev2__Quantity__c,sigmaerpdev2__Tax_Amount__c,sigmaerpdev2__Tax_Rate__c from sigmaerpdev2__Purchase_Order_Product__c where sigmaerpdev2__Purchase_Order__c =:PoId  order by name ASC])
            {
                PurchaseOrderProductWrap wrap=new PurchaseOrderProductWrap();
                wrap.pop=polref;
                wrap.ProductName=polref.sigmaerpdev2__Product__r.Name;
               
                wrap.TaxCodeName=polref.sigmaerpdev2__Tax_Code__r.name;
                PopWrapList.add(wrap);
            }
            PoEdit.polineWrap=PopWrapList;
            system.debug('PoEdit>>>'+PoEdit);
            
           
        
        return PoEdit;
    }
      public class PurchaseOrderUpdateWrap
    {
        @auraEnabled
        public sigmaerpdev2__Purchase_Order__c po; 
        @auraEnabled
        public Boolean sop;
        @auraEnabled
        public List<sigmaerpdev2__Purchase_Order_Product__c> deletedList;
        @auraEnabled
        public List<PurchaseOrderProductWrap> polineWrap;
        
    }
     public class PurchaseOrderProductWrap
    {
        @auraEnabled
        public sigmaerpdev2__Purchase_Order_Product__c pop;      
        @auraEnabled
        public String ProductName;
      
        @auraEnabled
        public String TaxCodeName;
    }
     @AuraEnabled
    public static ProductDataWrap getProdRelData(Id prodId,string taxTreatmentId,string Customerid)
    {
        system.debug('taxTreatmentId>>'+taxTreatmentId);
        ProductDataWrap pdw=new ProductDataWrap();
                system.debug('inside ');
                List<Product2> PB = [select id,name,sigmaerpdev2__Tax_Code__c, sigmaerpdev2__Tax_Code__r.name,sigmaerpdev2__Buying_Price__c from Product2 where id=:prodId];
                
                    pdw.prodData=PB[0];
                
                
                pdw.taxRateList=new List<sigmaerpdev2__Tax_Rate__c>();
                pdw.taxRateList=[select id,name,sigmaerpdev2__Tax_Rate__c from sigmaerpdev2__Tax_Rate__c where sigmaerpdev2__Tax_Treatment__c=:taxTreatmentId AND sigmaerpdev2__Tax_Code__c=:pdw.prodData.sigmaerpdev2__Tax_Code__c];
            
        return pdw;
    }
      @AuraEnabled
    public static ProductDataWrap getVProdRelData(Id prodId,string taxTreatmentId,string Customerid,Id vendorlocationid,Id contactid)
    {
        system.debug('taxTreatmentId>>'+taxTreatmentId);
         system.debug('vendorlocationid>>'+vendorlocationid);
        system.debug('contactid>>'+contactid);
        ProductDataWrap pdw=new ProductDataWrap();
                system.debug('inside ');
       // List<sigmaerpdev2__Vendor_Product__c> PB = [select id,name,sigmaerpdev2__Buying_Price__c,sigmaerpdev2__Is_Preferred__c from sigmaerpdev2__Vendor_Product__c where sigmaerpdev2__Product_Name__c=:prodId AND sigmaerpdev2__Account_Name__c=:Customerid AND sigmaerpdev2__Is_Preferred__c=true];
              //  pdw.vprodData=PB[0];
        List<sigmaerpdev2__Vendor_Product__c> PB = [select id,name,sigmaerpdev2__Buying_Price__c,sigmaerpdev2__Is_Preferred__c from sigmaerpdev2__Vendor_Product__c where sigmaerpdev2__Product_Name__c=:prodId AND sigmaerpdev2__Account_Name__c=:Customerid AND sigmaerpdev2__Vendor_Contact__c=:contactid AND sigmaerpdev2__Vendor_Location__c=:vendorlocationid];
        for(sigmaerpdev2__Vendor_Product__c vp:PB)           
        pdw.vprodData=vp;
            
        return pdw;
    }
     public Class ProductDataWrap
    {
        @AuraEnabled
        public Product2 prodData;
       @AuraEnabled
        public sigmaerpdev2__Vendor_Product__c vprodData;
        @AuraEnabled
        public List<sigmaerpdev2__Tax_Rate__c> taxRateList;
    }
     @AuraEnabled
    public static String fetchTaxData(String headerData,String LinesData)
    {
        String className=[select id,sigmaerpdev2__Tax_Calculation_Handler_class_Name__c from Sigma_Configurations__c limit 1].sigmaerpdev2__Tax_Calculation_Handler_class_Name__c;
        Type t=Type.forName(className);
        TaxHandlerInterface obj=(TaxHandlerInterface)t.newInstance();
        return obj.fetchTaxData(headerData,LinesData);
    }
      @AuraEnabled
    public static ReturnWrapp savePurOrder2(String pdata)
    {
        ReturnWrapp retWrap=new ReturnWrapp();
           
            system.debug('pdata>>>'+pdata);
            PurchaseOrderUpdateWrap poDataToSave=(PurchaseOrderUpdateWrap)System.JSON.deserialize(pdata,PurchaseOrderUpdateWrap.class);
            if(poDataToSave.deletedList.size()>0)
                delete poDataToSave.deletedList;
            system.debug('poDataToSave.po>>>'+poDataToSave.po);
            system.debug('poDataToSave.polineWrap>>>'+poDataToSave.polineWrap);
         upsert poDataToSave.po;
            system.debug('poDataToSave After>>'+poDataToSave.po.Id);
        //added on 11/8/21 for exchange currency
         Currency__c currSymbol = null; 
            Currency_Exchange_Rate__c currExRate = null ;
            List<string> pString =new List<string>();   
            List<Purchase_Order__c > pOrder = [select id,Currency__c from Purchase_Order__c where Id = :poDataToSave.po.id];
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
         Double exRate=0;
                    string symbol='';
                    Double  amt=0;
           //ends here         
            
            List<sigmaerpdev2__Purchase_Order_Product__c> ppList=new List<sigmaerpdev2__Purchase_Order_Product__c>();
            
            for(PurchaseOrderProductWrap ppw: poDataToSave.polineWrap ){
                system.debug('inside for'+poDataToSave.polineWrap);
                if(ppw.pop.sigmaerpdev2__Purchase_Order__c==null)
                {
                    ppw.pop.sigmaerpdev2__Purchase_Order__c=poDataToSave.po.Id;
                    ppw.pop.sigmaerpdev2__Received_Quantity__c=Double.valueOf(ppw.pop.sigmaerpdev2__Quantity__c);
                   ppw.pop.sigmaerpdev2__Buying_Price__c=Double.valueOf(ppw.pop.Total_Amount__c);
                  
                   //added on 11/8/21 for exchange currency
                    if(currExRate!= null){
                        symbol =currSymbol.Symbol__c;
                        string rateEx = currExRate.Rate__c +'';
                        amt= Double.valueOf(rateEx)*ppw.pop.Total_Amount__c;
                        string currStr=symbol+' '+amt;
                        ppw.pop.Exchange_Net_Buying_Price__c= currStr;
                        ppw.pop.Exchange_Price__c = amt;
                        system.debug('sigmaerpdev2__Exchange_Total_Buying_Price_Euro__c>>'+ppw.pop.Exchange_Net_Buying_Price__c);
                         //ends here  
                    }
                }
                
                ppList.add(ppw.pop);
            }
            
            system.debug('ppList>>>'+ppList);
            upsert ppList;
            system.debug('ppList After>>>'+ppList);
            
            system.debug('ppList After>>>'+ppList);
            system.debug('po>>>'+poDataToSave);
            retWrap.poData=[select id,name from sigmaerpdev2__Purchase_Order__c where id=:poDataToSave.po.id];
            retWrap.status='SUCCESS';
        
        return retWrap;
    }
     public class ReturnWrapp
    {
        @AuraEnabled
        Public String status;
        @AuraEnabled
        Public sigmaerpdev2__Purchase_Order__c poData;
    }
    @AuraEnabled
   public static DefaultValuesWrap fetchConfigurationValues(String CompanyName)
    {
        DefaultValuesWrap defValues=new DefaultValuesWrap();
       
        
         
        
         defValues.company=[select id,name,sigmaerpdev2__City__c,sigmaerpdev2__Country__c,sigmaerpdev2__Zip_Postal_Code__c,sigmaerpdev2__State_Province__c,sigmaerpdev2__Street__c,sigmaerpdev2__Shipping_City__c,sigmaerpdev2__Shipping_Country__c,sigmaerpdev2__Shipping_State_Province__c,sigmaerpdev2__Shipping_Street__c,sigmaerpdev2__Shipping_Zip_Postal_Code__c  from sigmaerpdev2__Company__c where name =:CompanyName limit 1];
            
       
        return defValues;
    }
    
     public class DefaultValuesWrap
    {
        @AuraEnabled
        public Company__c company;
        
        @AuraEnabled
        public sigmaerpdev2__Sigma_Configurations__c sigmaConfg;
        @AuraEnabled
        public Sigma_Module_Configuration__c sigmaModConfg;
    }
     @AuraEnabled
     public static AccountRelatedData fetchTaxtreatmentData(Id accId)
    { 
        AccountRelatedData ard=new AccountRelatedData();
       
            Account acc=[select id,name,sigmaerpdev2__Vendor_Tax_Treatment__c,sigmaerpdev2__Vendor_Tax_Treatment__r.Name  from Account where id=:accId];
            ard.acc=acc;
        
       
        return ard;
    }  
     public class AccountRelatedData
    {
        @AuraEnabled
        public Account acc;
        @AuraEnabled
        public Dimension_Tag__c dimensionTag;
        @AuraEnabled
        public Decimal taxRate=0;
        @AuraEnabled
        public String paymentTermsId;
        @AuraEnabled
        public String paymentTermsName;
        @AuraEnabled
        public String salesPersonId;
        @AuraEnabled
        public String salesPersonName; 
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
    public static List<sigmaerpdev2__Tax_Treatment__c> fetchcompanyrelatedtaxtreatment(ID compid,ID taxtreatmentid)
    {
          
                List<sigmaerpdev2__Tax_Treatment__c>  PB= [select id,Name from  sigmaerpdev2__Tax_Treatment__c where sigmaerpdev2__Company__c=:compid];
                 
         return PB;
    }
   
    
    
}