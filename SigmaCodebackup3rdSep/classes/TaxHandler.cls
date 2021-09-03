public class TaxHandler implements TaxHandlerInterface{
    public class TaxData
    {
        @AuraEnabled
        public string taxRateName;
        @AuraEnabled
        public decimal taxRate;
        //@AuraEnabled
        //public List<Productdata> productDataList;
    }
    public class Productdata
    {
        @AuraEnabled
        public Integer indx;
        @AuraEnabled
        public string productId;
        @AuraEnabled
        public string productName;
        @AuraEnabled
        public Decimal netAmount;
        @AuraEnabled
        public Decimal taxAmount;
        @AuraEnabled
        public Decimal totAmount;
        public List<TaxData> TaxDataList;
    }
    
    public String fetchTaxData(String headerData,String LinesData)
    {
        List<Productdata> pdList=new List<Productdata>();
        
            sigmaerpdev2__Purchase_Order__C headerDataDes=(sigmaerpdev2__Purchase_Order__C)System.JSON.deserialize(headerData,sigmaerpdev2__Purchase_Order__C.class);
            List<PurchaseOrderProductWrap> LinesDataList=(List<PurchaseOrderProductWrap>)System.JSON.deserialize(LinesData,List<PurchaseOrderProductWrap>.class);
            system.debug('headerDataDes>>'+headerDataDes);
            system.debug('LinesDataList>>'+LinesDataList);
            
            String compName=[select name from sigmaerpdev2__Company__c where id=:headerDataDes.sigmaerpdev2__Company__c limit 1].name;
            String taxTreatmentName='';
            try{
                taxTreatmentName=[select name from sigmaerpdev2__Tax_Treatment__c where id=:headerDataDes.sigmaerpdev2__Tax_Treatment__c limit 1].name;
            }catch(Exception e){}
            
            
            Map<id,sigmaerpdev2__Tax_Code__c> taxCodeMap=new Map<id,sigmaerpdev2__Tax_Code__c>([select id,name,(select id,name,sigmaerpdev2__Tax_Rate__c from sigmaerpdev2__Tax_Rates__r  where sigmaerpdev2__Tax_Treatment__c=:headerDataDes.sigmaerpdev2__Tax_Treatment__c) from sigmaerpdev2__Tax_Code__c where id in (select sigmaerpdev2__Tax_Code__c from sigmaerpdev2__Tax_Rate__c where sigmaerpdev2__Tax_Treatment__c=:headerDataDes.sigmaerpdev2__Tax_Treatment__c)]);
            
            Integer indx=0;
            for(PurchaseOrderProductWrap popw:LinesDataList)
            {
                if(popw.pop.sigmaerpdev2__Net_Amount__c!=null && !String.isEmpty(popw.pop.sigmaerpdev2__Product__c))
                {
                    Productdata pd=new Productdata();
                    pd.indx=indx;
                    pd.productName=popw.ProductName;
                    pd.netAmount=popw.pop.sigmaerpdev2__Net_Amount__c;
                    pd.TaxDataList=new List<TaxData>();
                    Decimal taxAmount=0;
                    
                    if(taxCodeMap.containsKey(popw.pop.sigmaerpdev2__Tax_Code__c))
                    {
                        for(sigmaerpdev2__Tax_Rate__c tr:taxCodeMap.get(popw.pop.sigmaerpdev2__Tax_Code__c).sigmaerpdev2__Tax_Rates__r)
                        {
                            TaxData td=new TaxData();
                            td.taxRateName=tr.name;
                            td.taxRate=tr.sigmaerpdev2__Tax_Rate__c;
                            pd.TaxDataList.add(td);
                            taxAmount+=popw.pop.sigmaerpdev2__Net_Amount__c*(tr.sigmaerpdev2__Tax_Rate__c/100);
                        }
                    }
                   
                    pd.taxAmount=taxAmount;
                    pd.totAmount=taxAmount+popw.pop.sigmaerpdev2__Net_Amount__c;
                    pdList.add(pd);
                }
                indx++;
            }
        
        return JSON.serialize(pdList);
    }
    public class PurchaseOrderProductWrap
    {
        @auraEnabled
        public sigmaerpdev2__Purchase_Order_Product__c pop;      
        @auraEnabled
        public String ProductName;
        @auraEnabled
        public String PricebookName;
    }
     public String fetchTaxDataSO(String headerData,String LinesData)
    {
        List<Productdata> pdList=new List<Productdata>();
        
            Sigma_Order__c headerDataDes=(Sigma_Order__c)System.JSON.deserialize(headerData,Sigma_Order__c.class);
            List<sigmaOrderWrap> LinesDataDes=(List<sigmaOrderWrap>)System.JSON.deserialize(LinesData,List<sigmaOrderWrap>.class);
            system.debug('headerDataDes>>'+headerDataDes);
            system.debug('LinesDataDes>>'+LinesDataDes);
            
           // String compName=[select name from sigmaerpdev2__Company__c where id=:headerDataDes.sigmaerpdev2__Company__c limit 1].name;
            String taxTreatmentName='';
            try{
                taxTreatmentName=[select name from sigmaerpdev2__Tax_Treatment__c where id=:headerDataDes.sigmaerpdev2__Tax_Treatment__c limit 1].name;
            }catch(Exception e){}
           
           
            Map<id,sigmaerpdev2__Tax_Code__c> taxCodeMap=new Map<id,sigmaerpdev2__Tax_Code__c>([select id,name,(select id,name,sigmaerpdev2__Tax_Rate__c,sigmaerpdev2__Tax_Code__c from sigmaerpdev2__Tax_Rates__r where sigmaerpdev2__Tax_Treatment__c=:headerDataDes.sigmaerpdev2__Tax_Treatment__c) from sigmaerpdev2__Tax_Code__c where id in (select sigmaerpdev2__Tax_Code__c from sigmaerpdev2__Tax_Rate__c where sigmaerpdev2__Tax_Treatment__c=:headerDataDes.sigmaerpdev2__Tax_Treatment__c)]);
            system.debug('taxCodeMap>>'+taxCodeMap);
            
            Integer indx=0;
            for(sigmaOrderWrap sow:LinesDataDes)
            {
                if(sow.orderLines.sigmaerpdev2__Total_Amount__c >0 && !sow.orderLines.sigmaerpdev2__Back_Order__c  && !sow.orderLines.sigmaerpdev2__Splited_Order_Line__c )
                {
                    Productdata pd=new Productdata();
                    pd.indx=indx;
                    pd.productName=sow.ProductName;
                  //  sow.orderLines.sigmaerpdev2__Discount__c=sow.orderLines.sigmaerpdev2__Discount__c!=null?sow.orderLines.sigmaerpdev2__Discount__c:0;
                    sow.orderLines.sigmaerpdev2__Discounts__c=sow.orderLines.sigmaerpdev2__Discounts__c!=null?sow.orderLines.sigmaerpdev2__Discounts__c:0;
                   // pd.netAmount=(sow.orderLines.sigmaerpdev2__Total_Amount__c-sow.orderLines.sigmaerpdev2__Discount__c)*sow.orderLines.sigmaerpdev2__Quantity__c;
                     pd.netAmount=(sow.orderLines.sigmaerpdev2__Total_Amount__c-(sow.orderLines.sigmaerpdev2__Total_Amount__c*sow.orderLines.sigmaerpdev2__Discounts__c/100))*sow.orderLines.sigmaerpdev2__Quantity__c;
                    headerDataDes.sigmaerpdev2__Discount__c=headerDataDes.sigmaerpdev2__Discount__c!=null?headerDataDes.sigmaerpdev2__Discount__c:0;
                    pd.netAmount=pd.netAmount-(pd.netAmount*headerDataDes.sigmaerpdev2__Discount__c/100);
                    
                    pd.TaxDataList=new List<TaxData>();
                    Decimal taxAmount=0;
                    
                    if(taxCodeMap.containsKey(sow.orderLines.sigmaerpdev2__Tax_Code__c))
                    {
                        system.debug('IN IF');
                        for(sigmaerpdev2__Tax_Rate__c tr:taxCodeMap.get(sow.orderLines.sigmaerpdev2__Tax_Code__c).sigmaerpdev2__Tax_Rates__r)
                        {
                            system.debug('IN For');
                            TaxData td=new TaxData();
                            td.taxRateName=tr.name;
                            td.taxRate=tr.sigmaerpdev2__Tax_Rate__c;
                            pd.TaxDataList.add(td);
                            taxAmount+=pd.netAmount*(tr.sigmaerpdev2__Tax_Rate__c/100);
                             //taxAmount=pd.netAmount*(tr.sigmaerpdev2__Tax_Rate__c/100);
                        }
                    }
                   
                    pd.taxAmount=taxAmount;
                    pd.totAmount=taxAmount+pd.netAmount;
                    pdList.add(pd);
                }
                indx++;
            }
            system.debug('pdList>>'+pdList);
        
        return JSON.serialize(pdList);
    }
    public class sigmaOrderWrap
    {
       
        public Boolean hasBackOrder;
       
        public Boolean isDisabled;
        
        public Boolean isDisplay;
       
        public String productName;
       
        public Product_Order_Price_Book__c orderLines;
    }
}