public with sharing class MultiplePOCtrl 
{
    public static Purchase_Order__c POList {get;set;}
    public static List<Purchase_Order_Product__c> POPList{get;set;}
    
    public class MultiplePO{
        @AuraEnabled
        public Vendor_Product__c vpdata;
        @AuraEnabled
        public Boolean isSelected= false;
        @AuraEnabled
        public String productName;
        @AuraEnabled
        public Date OrderDate;
        @AuraEnabled
        public String vendorName;
        @AuraEnabled
        public Integer orderedQty;
        @AuraEnabled
        public Integer discount;
        @AuraEnabled
        public Integer buyingPrice;
        @AuraEnabled
        public Date deliveryDate;
        @AuraEnabled
        public String selectedStatus;
    }
    
    @AuraEnabled
    public static void saveAccounts(List<Account> accList){
        Insert accList;
    }
    @AuraEnabled
    public static List<Vendor_Product__c> getAccountRecord(Id productId)
    {
        MultiplePO mw = new MultiplePO();
        List<Vendor_Product__c> vptlist =[Select id,Name,VendorProductCode__c,Account_Name__c,Current_Stock__c,Product_Name__c,Is_Preferred__c,Buying_Price__c from Vendor_Product__c Where Product_Name__c=:productId];
        
        return vptlist;
    }
    
    @AuraEnabled
    public static Id CreatePO(Purchase_Order__c POObject,String POProductObject) 
    {           
        system.debug('POObject-->>'+POObject);
        insert POObject;
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
        
        insert POProductList; 
        return POObject.Id;
    }
}