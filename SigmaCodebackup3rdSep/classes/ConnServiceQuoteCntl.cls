public with sharing  class ConnServiceQuoteCntl {

    public class WrappedILP
    {
        @AuraEnabled
        public Id locationId;
        @AuraEnabled
        public Id ILPId;
        @AuraEnabled
        public String LocationName;
        @AuraEnabled
        public Integer Availableqty;
        @AuraEnabled
        public Integer Quantity;
        @AuraEnabled
        public Boolean checkBox;
        @AuraEnabled
        public Product_Price__c pp;
        @AuraEnabled
        public Integer daysCount;
        @AuraEnabled
        public Decimal locationDiscount;
        
    }
    public class wrapperList
    {
        @AuraEnabled
        public String ProName;
        @AuraEnabled
        public List<WrappedILP> ilpUiList;
        @AuraEnabled
        public decimal lineitemDiscount;
        @AuraEnabled
        public Id ProId;
        @AuraEnabled
        public Inventory_Location_Product__c lineItemDate;
        
    }
    public class wrappereditflow
    {
        @AuraEnabled
        public List<wrapperListInsertLineItems> wrapperListInsertLineItems;
        @AuraEnabled
        public List<wrapperList> wrapperList;
        @AuraEnabled
        public  Service_Quote__c proposalobj {get;set;}
    }
    public class wrapperListInsertLineItems
    {
        @AuraEnabled
        public Service_Quote_Line_Item__c LineItem;
        @AuraEnabled
        public String proname;
        @AuraEnabled
        public List<locationquantity> locqty;
    }
    public class locationquantity
    {
        @AuraEnabled
        public Id locid;
        @AuraEnabled
        public Id ILPId;
        @AuraEnabled
        public decimal Quantity;
        @AuraEnabled
        public decimal locdis;
        @AuraEnabled
        public decimal loccost;
        
    }
    @AuraEnabled  
    public static Work_Order__c getProducts(String workorderid)
    {
        Work_Order__c workorder = new Work_Order__c();
         if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Work_Order__c')
         &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Work_Oder_Lines__c')
         && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Work_Order__c',new set<String>{'id','name','sigmaerpdev2__Account__c','sigmaerpdev2__Account__r.Name','sigmaerpdev2__Asset__c'})
         && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Work_Oder_Lines__c',new set<String>{'id','Name','sigmaerpdev2__Quote__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Quantity__c','sigmaerpdev2__Work_Order__c'}))
         {
             workorder=[select id,Name,Account__c,Account__r.Name,(select id,name,Quote__c,Product__c,Product__r.Name,Quantity__c from Work_Order_Lines__r where Quote__c=true) from Work_Order__c where id=:workorderid];
         }
        return workorder;
    }
    @AuraEnabled
    public static List<String> getProposalStatus()
    {
        List<String> options = new List<String>();
         if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Service_Quote__c')
         && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Service_Quote__c',new set<String>{'sigmaerpdev2__Status__c'}))
         {
        
        Schema.DescribeFieldResult fieldResult = Service_Quote__c.Status__c.getDescribe();
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
    public static Service_Quote_Line_Item__c quoteforproductdetails(String Proid,String account,String assetid)
    {
        
        wrapperList wrapper;
        Service_Quote_Line_Item__c line=new Service_Quote_Line_Item__c();
        Product2 proList = new Product2();
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Service_Quote__c')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Price__c')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Service_Quote_Line_Item__c')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('Product2') 
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Service_Contract_Line_Item__c')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Service_Contract__c')
        &&CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'id','Name','sigmaerpdev2__Product_Price__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Service_Contract__c',new set<String>{'id','Name','sigmaerpdev2__Proposal__c','sigmaerpdev2__Customer__c','sigmaerpdev2__Asset__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Service_Quote_Line_Item__c',new set<String>{'sigmaerpdev2__Price__c','sigmaerpdev2__Covered_under_Contract_Y_N__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Service_Contract_Line_Item__c',new set<String>{'id','name','sigmaerpdev2__Service_Contract__c','sigmaerpdev2__Product__c'})
        &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Service_Contract_Line_Item__c',new set<String>{'sigmaerpdev2__Service_Contract__c'})
      )
     {
        List<wrapperList> WrapList;
        List<WrappedILP> WrapILPList = new List<WrappedILP>(); 
        proList = [select id, Name,Product_Price__c from Product2 where id =: Proid];
        
        List<PricebookEntry> pbe = [Select UnitPrice From PricebookEntry WHERE PriceBook2.Name = 'Standard Price Book' and Product2.Id = :Proid limit 1];                
                
        List<Service_Contract_Line_Item__c> SClineitemdata=[select id,name,Service_Contract__c from Service_Contract_Line_Item__c where Product__c=:proid];
         
         
        List<id> SCid=new List<id>();
        for(Service_Contract_Line_Item__c eachSCLI:SClineitemdata)
        {
            
            if(SCid.contains(eachSCLI.Service_Contract__c)==false){
                SCid.add(eachSCLI.Service_Contract__c);
            }           
        }
        List<Service_Contract__c> servicecon=[select id,name,Proposal__c from Service_Contract__c where Id In :SCid AND Customer__c=: account And Asset__c=:assetid];
        
         if(servicecon.size()>0)
        {
            
            line.Price__c=0.0;
            line.Covered_under_Contract_Y_N__c=true;
        }
        else
        {
            //line.Price__c=proList.Product_Price__c;
            if(pbe.size () > 0){     //added on 10/7/2020 to get price from price book instead of product selling price               
                if(pbe[0].UnitPrice != null)
                  line.Price__c = pbe[0].UnitPrice;              
            }
            line.Covered_under_Contract_Y_N__c=false;
        }
     }
        return  line;        
    }

    @AuraEnabled  
    public static Decimal getprice(String serviceid,String proid)
    {
        system.debug('serviceid>>'+serviceid);
        system.debug('proid>>'+proid);
        Decimal productprice=0.0;
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Service_Contract__c')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Service_Contract_Line_Item__c')      
        &&CRUD_FLS_CheckUtility.checkObjCRUD('Product2') 
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Price__c')
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Service_Contract__c',new set<String>{'id','Name','sigmaerpdev2__Proposal__c','sigmaerpdev2__Asset__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'id','Name','sigmaerpdev2__Product_Price__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Price__c',new set<String>{'id','Name','sigmaerpdev2__Cost__c','sigmaerpdev2__Status__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Service_Contract_Line_Item__c',new set<String>{'name','sigmaerpdev2__Service_Contract__c','sigmaerpdev2__Product__c','sigmaerpdev2__Net_Value__c'})
        && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Service_Contract_Line_Item__c',new set<String>{'sigmaerpdev2__Service_Contract__c'}))
      
        {
        
            // new code to fetch price from SCLI 
            Service_Contract__c servicecon=[select id,name,Proposal__c,Asset__c from Service_Contract__c where id=: serviceid];
            List<Service_Contract_Line_Item__c> SCLIdata =[select name,Service_Contract__c,Product__c,Net_Value__c from Service_Contract_Line_Item__c where Product__c=:proid AND Service_Contract__c=:servicecon.id];
            if(SCLIdata.size() == 0)
            {
                Product2 proList = [select id, Name,Product_Price__c,(select id,name,Cost__c,Status__c from Product_Prices__r Limit 1)from Product2 where id =: Proid];
                productprice=proList.Product_Prices__r[0].Cost__c;
            }
            else
            {
                
                productprice=SCLIdata[0].Net_Value__c;
            }
        }
        system.debug('productprice>>>'+productprice);
        return productprice;
    }

    @AuraEnabled     
    public static id Savequote(Service_Quote__c proposalObject,String orderline)
    { 

      if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Service_Quote__c')
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Service_Quote_Line_Item__c')
        &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Service_Quote_Line_Item__c',new set<String>{'sigmaerpdev2__Service_Quote__c'}))
      {
           try{
            List<Service_Quote_Line_Item__c> values = (List<Service_Quote_Line_Item__c>)JSON.deserialize(orderline, List<Service_Quote_Line_Item__c>.class);
            upsert proposalObject;
            
            List<Service_Quote_Line_Item__c> LineItemList = new List<Service_Quote_Line_Item__c>();
            for(Service_Quote_Line_Item__c genList: values)
            { 
                genList.Service_Quote__c = proposalObject.Id; 
                LineItemList.add(genList);
                
            }    
            insert LineItemList;
            }
            catch(Exception e){
                system.debug('Exception - '+e.getMessage());
                system.debug('Exceptiopn - '+e.getLineNumber());
            }
        }
        return proposalObject.id;
    }
    
    @AuraEnabled  
    public static Decimal getproductprice(String proid)
    {
        Decimal productprice = 0.0;
        /*Product2 proList;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
        &&CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'id','Name','sigmaerpdev2__Product_Price__c'}) )
        {   
            proList = [select id, Name,Product_Price__c from Product2 where id =:Proid];
            if(proList.Product_Price__c != null)
            productprice = proList.Product_Price__c;
        }*/
        //commented above section on 10/7/2020 and getting price from price book now
        List<PricebookEntry> pbe = [Select UnitPrice From PricebookEntry WHERE PriceBook2.Name = 'Standard Price Book' and Product2.Id = :proid limit 1]; 
        if(pbe.size () > 0){                
            if(pbe[0].UnitPrice != null)
                productprice = pbe[0].UnitPrice;              
        }
        return productprice;
    }

    
     
}