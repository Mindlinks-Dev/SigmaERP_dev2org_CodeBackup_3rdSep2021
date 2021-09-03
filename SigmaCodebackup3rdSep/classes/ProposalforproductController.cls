/*------------------------------------------------------------
Author: <Anuja Tupale>
Company: Mindlinks Solution
Description: creating Proposal for products

------------------------------------------------------------*/
public with sharing class ProposalforproductController
{
    public Inventory_Location_Product__c DateIlp{get;set;}
    public List<Proposal_Item__c> campaignLineItems{get;set;}
    public boolean campaignDateEditable{get;set;}
    public boolean DiaplayPopUpError{get;set;}
    public boolean DiaplayMainError{get;set;}
    public boolean isEdit{get;set;}
    public Map<Id,String> ProIDLocCPM = new Map<Id,String>();
    public Set<Id> PrposalIDs {get;set;} 
    
    public String Name {get;set;}
    public String WrapProId{get;set;}
    public String billingOption{get;set;}
    public String Po_Number{get;set;}
    public Map<Id,Integer> Quantity{get;set;}
    public List<Integer> enteredQty{get;set;}
    public Map<Id,Integer> CompareQty {get;set;}
    public String billingCurrency{get;set;}
    public Boolean ordercreted{get;set;} 
    public String billingFrequency{get;set;}
    public Map<id,Map<Id,Id>> ProIlpppMap = new Map<id,Map<Id,Id>>();
    public String billingDetail{get;set;}
    public Setup_Conversion_Rate_Euro__c conRateEuro{get;set;}
    public List<Inventory_Location_Product__c> ILPValues {get;set;}
    public Map<id,Proposal_Item__c> ProAndProItemList = new Map<id,Proposal_Item__c>();
    public String consolidatedBilling{get;set;}
    public String internalBusiness{get;set;}
    public boolean displayPopUp{get;set;}
    public Double ownership{get;set;}
    public Double ownership1{get;set;}
    public Double ownership2{get;set;} 
    public String insertedCampaignid{get;set;}
    public String paymentTerms{get;set;}  
    public String currencyType{get;set;}
    public String headerInfo{get;set;}
    public String campaignID {get;set;}
    public String OldCampStatus{get;set;}
    public Proposal__c campObject {get;set;}
    public boolean OpenLine{get;set;}
    public List<wrapperList> WrapList{get;set;}
    public List<wrapperList> tempWrapList{get;set;}
    public Proposal_Item__c temp{get;set;}
    public String prdct{get;set;}
    public Set<Id> ProIdLIst = new Set<Id>();
    public List<selectOption> ProductList{get;set;}
    public Map<Id,Product2> ProductMapforQuery;
    public List<Proposal_Item__c> DeleteLineItem = new List<Proposal_Item__c>();
    public Map<id,wrapperListInsertLineItems> LineMap = new Map<id,wrapperListInsertLineItems>();
    public Map<id,Map<Id,Integer>> NewMap = new Map<id,Map<Id,Integer>>();
    public Map<id,List<wrapperList>> ProAndPSNList = new Map<id,List<wrapperList>>();
    
    public List<wrapperListInsertLineItems> CompleteList{get;set;}
    public Integer discountMethodOptionValue{get;set;}
    public String notesDescription{get;set;}
    public Boolean errorOccurred{get;set;} //to set focus to error message
    public String discountMethodChosen{get;set;}
    public List<Proposal_Item__c> DeleteLineItemWhenDelete = new List<Proposal_Item__c>();
    
    public class wrapperListInsertLineItems
    {
        public Proposal_Item__c LineItem{get;set;}
        public Id ProID{get;set;}
        public String Productname{get;set;}
        public Decimal SellingPrice{get;set;}
        public wrapperListInsertLineItems(Id ProID, Proposal_Item__c LineItem, String Productname , Decimal SellingPrice)
        {
            this.ProID = ProID;
            this.LineItem = LineItem;
            this.Productname = Productname;
            this.SellingPrice = SellingPrice;
        }
    }
    public class wrapperList
    {
        public String ProName{get;set;}
        public List<Inventory_Location_Product__c> ILPList{get;set;}
        public List<WrappedILP> ilpUiList{get;set;}
        public decimal lineitemDiscount{get;set;}
        public Id ProId{get;set;}
        
        public wrapperList(String ProName,List<Inventory_Location_Product__c> ILPList, List<WrappedILP> ilpUiList, decimal lineitemDiscount, Id ProId)
        {
            this.ProName = ProName;
            this.ILPList = ILPList;
            this.ilpUiList = ilpUiList;
            this.lineitemDiscount = lineitemDiscount;
            this.ProId = ProId;
            
        }
    }
    public class WrappedILP
    {
        public Id locationId{get;set;}
        public String LocationName{get;set;}
        public Decimal availqty{get;set;}
        public Integer Quantity{get;set;}
        public Boolean checkBox{get;set;}
        
        public String warningMessage{get;set;}
        public Decimal pp{get;set;}
        public WrappedILP(Id locationId, String LocationName, Decimal availqty, Integer Quantity, Boolean checkBox,String warningMessage,Decimal pp)
        {
            this.locationId = locationId;
            this.LocationName = LocationName;
            this.availqty=availqty;
            this.Quantity = Quantity;
            this.checkBox = checkBox;
            
            this.warningMessage = warningMessage;
            this.pp = pp;
        }
    }
    public ProposalforproductController(ApexPages.StandardController controller) 
    {
        if(CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'id','Name','sigmaerpdev__Product_Price__c','sigmaerpdev__Active__c'})
          && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Setup_Conversion_Rate_Euro__c',new set<String>{'sigmaerpdev__Conversion_Rate__c'})
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Setup_Conversion_Rate_Euro__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Proposal__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Proposal_Item__c')
           )
        {
            DateIlp = new Inventory_Location_Product__c();
            isEdit = false;
            campaignDateEditable = true;
            displayPopUp = false;
            CompleteList = new List<wrapperListInsertLineItems>(); 
            campObject = new Proposal__c();
            displayPopUp = false;
            OldCampStatus = '';
            
            campaignID = ApexPages.currentPage().getParameters().get('id');
            
            headerInfo = 'Proposal Info';
            currencyType = 'Dollar';
            conRateEuro = Setup_Conversion_Rate_Euro__c.getOrgDefaults();
            if(conRateEuro.Conversion_Rate__c == null)
            {
                conRateEuro.Conversion_Rate__c = 1.06;
            }
            if(campaignID != NULL && campaignID !='')
            {
                this.getCampaignByID();
                headerInfo = 'Proposal Edit Info';
            }
            //Newly Added
            DiaplayPopUpError =false;
            DiaplayMainError = false;
            
            displayPopUp = false;
            OpenLine = false;
            WrapList = new List<wrapperList>();
            tempWrapList = new List<wrapperList>();
            temp=new Proposal_Item__c ();
            prdct = '';
            ProductList = new List<selectOption>();
            ProductMapforQuery = new Map<Id,Product2>([select id, Name,Product_Price__c  from Product2 where Active__c = true Order By Name]);
            for(Id refId :ProductMapforQuery.keySet())
            {
                ProductList.add(new selectOption(refId,ProductMapforQuery.get(refId).Name));
            }
            
            if(discountMethodOptionValue == null){
                discountMethodOptionValue = 0;
            }
            
        }
        
    }
    //getCampaignByID to populate campaignData from edit mode
    public void getCampaignByID()
    {
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Proposal__c',new set<String>{'Id','sigmaerpdev__Is_Order_Created__c','sigmaerpdev__Proposal_Name__c','sigmaerpdev__Client__c','sigmaerpdev__Contact__c','sigmaerpdev__Billing_Contact__c','sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__c','sigmaerpdev__Internal_Business__c','sigmaerpdev__Account_Executive__c','sigmaerpdev__Account_Executive1__c','sigmaerpdev__Account_Executive2__c','sigmaerpdev__Ownership__c','sigmaerpdev__Ownership1__c',
            'sigmaerpdev__Ownership2__c','sigmaerpdev__Industry_Exclusively__c','sigmaerpdev__Prediction__c','sigmaerpdev__Estimated_Close_Date__c','sigmaerpdev__Proposal_Submitted_Date__c','sigmaerpdev__PO_Number__c','sigmaerpdev__Discount__c','sigmaerpdev__Billing_Option__c','sigmaerpdev__Billing_Frequency__c','sigmaerpdev__Billing_Detail__c','sigmaerpdev__Consolidated_Billing__c','sigmaerpdev__Billing_Currency__c','sigmaerpdev__Status__c','sigmaerpdev__Payment_Terms__c','sigmaerpdev__Field_Discount_Amount__c','sigmaerpdev__Other_Charges_Comments__c','sigmaerpdev__Other_Charges__c','sigmaerpdev__Other_Discount_Comments__c','sigmaerpdev__Other_Discount__c','sigmaerpdev__Discount_Method_Option_Value__c','sigmaerpdev__Discount_Method__c','sigmaerpdev__Partner__c','sigmaerpdev__Other_Charges_Euro__c','sigmaerpdev__Other_Discount_Euro__c','sigmaerpdev__Field_Discount_Amount_Euro__c','sigmaerpdev__Agent_Commission__c','sigmaerpdev__Agent_Commission_Euro__c','sigmaerpdev__Agency_Percent__c','sigmaerpdev__Partner_Proposal__c','sigmaerpdev__AVR_Percent__c','sigmaerpdev__AVR_Commission__c','sigmaerpdev__AVR_Commission_Euro__c','sigmaerpdev__Billing_Start_Date__c', 'sigmaerpdev__Billing_End_Date__c','sigmaerpdev__Deduct_from_Net__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Proposal_Item__c',new set<String>{'Id', 'Name', 'sigmaerpdev__Discount__c', 'sigmaerpdev__Proposal__c','sigmaerpdev__Proposal__r.Name','sigmaerpdev__Product__r.Name','sigmaerpdev__Cost__c','sigmaerpdev__Inventory_Location__r.Name','sigmaerpdev__Inventory_Location__c','sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__c','sigmaerpdev__OtherCharges__c','sigmaerpdev__Other_Charges_Euro__c','sigmaerpdev__Discount_Euro__c','sigmaerpdev__Cost_Euro__c','sigmaerpdev__Sum_Location_Discount__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'id', 'Name','sigmaerpdev__Impression_Multiplier__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new set<String>{'id', 'name','sigmaerpdev__Market__r.Name', 'sigmaerpdev__Airport__r.Name','sigmaerpdev__Airport__r.sigmaerpdev__Code__c', 'sigmaerpdev__Net_Quantity__c', 'sigmaerpdev__Received_Quantity__c','sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Name', 'sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__c', 'sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.sigmaerpdev__Active__c', 'sigmaerpdev__Partner__r.Name', 'sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.sigmaerpdev__Code__c', 'sigmaerpdev__Market__r.sigmaerpdev__DMA__c', 'sigmaerpdev__Start_Date__c', 'sigmaerpdev__End_Date__c','sigmaerpdev__Number_of_Screens__c', 'sigmaerpdev__Message__c'})
           
          )
        {
            Map<Id, decimal> productIdAndLineItemDiscount = new Map<Id, decimal>();
            campObject =[select Id,Proposal_Name__c,Is_Order_Created__c,Client__c,Contact__c,Billing_Contact__c,Start_Date__c,End_Date__c,Internal_Business__c,Account_Executive__c,Account_Executive1__c,Account_Executive2__c,Ownership__c,Ownership1__c,
                         Ownership2__c,Industry_Exclusively__c,Prediction__c,Estimated_Close_Date__c,Proposal_Submitted_Date__c,PO_Number__c,Discount__c,Billing_Option__c,Billing_Frequency__c,Billing_Detail__c,Consolidated_Billing__c,Billing_Currency__c,Status__c,Payment_Terms__c,Field_Discount_Amount__c,Other_Charges_Comments__c,Other_Charges__c,Other_Discount_Comments__c,Other_Discount__c,Discount_Method_Option_Value__c,Discount_Method__c,Partner__c,Other_Charges_Euro__c,Other_Discount_Euro__c,Field_Discount_Amount_Euro__c,Billing_Start_Date__c,
                         Billing_End_Date__c,Deduct_from_Net__c  FROM Proposal__c WHERE Id=:campaignID];
            
            ordercreted=campObject.Is_Order_Created__c;
            Name = campObject.Proposal_Name__c;
            
            ownership = campObject.Ownership__c;
            ownership1 = campObject.Ownership1__c;
            ownership2 = campObject.Ownership2__c;
            Po_Number = campObject.PO_Number__c;
            billingOption = campObject.Billing_Option__c;
            billingFrequency = campObject.Billing_Frequency__c;
            billingDetail = campObject.Billing_Detail__c;
            consolidatedBilling = campObject.Consolidated_Billing__c;
            
            billingCurrency = campObject.Billing_Currency__c;
            
            discountMethodOptionValue = Integer.valueOf(campObject.Discount_Method_Option_Value__c);
            
            paymentTerms = campObject.Payment_Terms__c;
            
            //code to fetch Campaign Line Items
            List<Id> ProId = new List<Id>();
            campaignLineItems =[select Id, Name, Discount__c, Proposal__c,Proposal__r.Name,Product__r.Name,Cost__c,Inventory_Location__r.Name,Inventory_Location__c,Product__c,Quantity__c,OtherCharges__c,Other_Charges_Euro__c,Discount_Euro__c,Cost_Euro__c,Sum_Location_Discount__c from Proposal_Item__c  WHERE Proposal__c =:campaignID];
            PrposalIDs = new Set<Id>(); 
            
            for(Proposal_Item__c tempPropList :campaignLineItems)
            {
                
                DeleteLineItem.add(tempPropList);
                LineMap.put(Id.valueOf(tempPropList.Product__c),new wrapperListInsertLineItems(tempPropList.Product__c, tempPropList, tempPropList.Product__r.Name,null));
                //Newly Added
                ProId.add(tempPropList.Product__c);
                productIdAndLineItemDiscount.put(tempPropList.Product__c, tempPropList.Discount__c);
                
                PrposalIDs.add(tempPropList.Id);
            }
            //New Flow
            for(Proposal_Item__c tempPropList :campaignLineItems)
            {
                id produtId = tempPropList.Product__c;
                Map<id,Integer> refvalue = new Map<id,Integer>();
                Map<id,Id> refIlpPP = new Map<id,Id>();
                
                NewMap.put(produtId,refvalue);
                
                ProIlpppMap.put(produtId,refIlpPP);
            } 
            CompleteList = new List<wrapperListInsertLineItems>();
            set<Id> IdList = LineMap.KeySet();
            
            for(Id IdRef:IdList)
            {
                CompleteList.add(LineMap.get(IdRef));
            }
            //for(id proid1 : ProId)
           // {
                campaignDateEditable = false;
                map<id,Map<Integer,Inventory_Location_Product__c>> LocAndILPList = new map<id,Map<Integer,Inventory_Location_Product__c>>();
                map<id,Map<Integer,Inventory_Location_Product__c>> validLocAndILPList = new map<id,Map<Integer,Inventory_Location_Product__c>>();
                
                
                List<Product2> proList = [select id, Name,Product_Price__c,(select id, name, Net_Quantity__c, Received_Quantity__c,Inventory_Location__r.Location__r.Name, Inventory_Location__r.Location__c, Inventory_Location__r.Location__r.Active__c, Inventory_Location__r.Location__r.Code__c, Message__c  from Inventory_Location_Products__r where ( (Inventory_Location__r.Location__r.Active__c = 'Yes') And (Net_Quantity__c >= 0))) from Product2 where id =: ProId];
                
                    
                
                List<Proposal_Item__c> tempProductList = new List<Proposal_Item__c>();
                tempProductList = [select Id,Name,Proposal__c,Cost__c,Inventory_Location__c,Product__c,Quantity__c from Proposal_Item__c where Id in :PrposalIDs];
                
                
                Map<Id,String> psnlistval = new Map<Id,String>();
                
                String PRONAME='';
                List<Inventory_Location_Product__c> ILPListInMet;
                
                List<WrappedILP> WrapILPList;
                Decimal price=0.0;
                for(Product2 pro: proList)
                {
                    PRONAME = pro.Name;
                      Map<id,Integer> JustToCheck = new Map<id,Integer>();
                
                JustToCheck = (Map<id,Integer>)NewMap.get(pro.id);    
                    price=pro.Product_Price__c;
                    ILPListInMet = new List<Inventory_Location_Product__c>();
                    
                    Integer count =0;
                    Decimal CostValue = 0.00;
                    Decimal ProductionCost =0.00;
                    Decimal editProductionCost =0.00;
                    WrapILPList=new List<WrappedILP>();
                    
                    ProductionCost = 0.00;
                    editProductionCost=0.00;
                    
                    //for Warning message in ilp
                    Map<id,String> locationWithWarning = new Map<id,String>();
                    
                    for(Inventory_Location_Product__c ilp : pro.Inventory_Location_Products__r)
                    { 
                        
                        ILPListInMet.add(ilp);
                        
                        //message
                        if(ilp.Message__c!= null)
                        {
                            if(locationWithWarning.containsKey(ilp.Inventory_Location__r.Location__c))
                            {
                                String message = locationWithWarning.get(ilp.Inventory_Location__r.Location__c) + ' , ' +ilp.Name+' - ' +ilp.Message__c;
                                locationWithWarning.put((ilp.Inventory_Location__r.Location__c), message);
                                
                            }
                            else{
                                locationWithWarning.put((ilp.Inventory_Location__r.Location__c), ilp.Name+' - ' +ilp.Message__c);
                            }
                        }
                        WrapILPList.add(new WrappedILP(ilp.Inventory_Location__r.Location__c,ilp.Inventory_Location__r.Location__r.Name,ilp.Net_Quantity__c,0,false, locationWithWarning.get(ilp.Inventory_Location__r.Location__c),price));
                        
                    }
                    
                //}
                WrapList= new List<wrapperList>();
                WrapList.add(new wrapperList(PRONAME, ILPListInMet, WrapILPList,0.00, pro.id));
            }
            OldCampStatus = campObject.Status__c; 
        }       
    }
    public pageReference changeDiscountMethods()
    { 
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Proposal__c',new set<String>{'id','sigmaerpdev__Discount_Method_Option_Value__c','sigmaerpdev__Field_Discount_Amount__c','sigmaerpdev__Discount__c'})
         && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Proposal_Item__c',new set<String>{'sigmaerpdev__Discount__c','sigmaerpdev__Discount_Euro__c'})
        
        )
        {
            
            Integer storedDiscountOption = 0;
            if(campaignID != null)
            {
                Proposal__c optionId = [select Discount_Method_Option_Value__c from Proposal__c where id =:campaignID];
                
                storedDiscountOption = Integer.valueOf(optionId.Discount_Method_Option_Value__c);
            }       
            if(storedDiscountOption == 1)
            {
                for(Id RefId: LineMap.KeySet())
                {
                    wrapperListInsertLineItems wil = LineMap.get(RefId);
                    wil.LineItem.Discount__c = 0.00;
                    wil.LineItem.Discount_Euro__c = 0.00;
                    LineMap.put(RefId,wil);
                }
                for(Id proId : ProAndPSNList.keySet())
                {
                    List<wrapperList> wrapperToCahngeDiscount = new List<wrapperList>();
                    wrapperToCahngeDiscount = ProAndPSNList.get(proId);
                    for(wrapperList wl : wrapperToCahngeDiscount)
                    {
                        wl.lineitemDiscount = 0.00;
                    }
                    ProAndPSNList.put(proId,wrapperToCahngeDiscount);
                }
            }else if(storedDiscountOption == 3)
            {
                
                campObject.Discount__c = 0.00;
                campObject.Field_Discount_Amount__c = 0.00;
            }    
        }        
        return null;
    }
    public pageReference setFocusToError(){
        
        return null;
    } 
    public pageReference productdetails()
    {  
        //FLS Check : Sandhya
        if(CRUD_FLS_CheckUtility.checkReadPermission('Product2',new set<String>{'id', 'Name','sigmaerpdev__Product_Price__c','sigmaerpdev__Impression_Multiplier__c'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new set<String>{'id', 'name','sigmaerpdev__Market__r.Name', 'sigmaerpdev__Airport__r.Name', 'sigmaerpdev__Airport__r.sigmaerpdev__Code__c', 'sigmaerpdev__Net_Quantity__c', 'sigmaerpdev__Received_Quantity__c','sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.Name', 'sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__c', 'sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.sigmaerpdev__Active__c', 'sigmaerpdev__Partner__r.Name', 'sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.sigmaerpdev__Code__c', 'sigmaerpdev__Market__r.sigmaerpdev__DMA__c', 'sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__c','sigmaerpdev__Number_of_Screens__c', 'sigmaerpdev__Message__c'})
         //&&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Price__c',new set<String>{'id', 'Name','sigmaerpdev__Airport__r.Name','sigmaerpdev__Airport__r.sigmaerpdev__Code__c','sigmaerpdev__Cost__c','sigmaerpdev__Monthly_Impressions__c','sigmaerpdev__Cost_Value__c','sigmaerpdev__CPM__c','sigmaerpdev__Location__r.Name','sigmaerpdev__End_Date__c','sigmaerpdev__Start_Date__c','sigmaerpdev__Monthly_Traffic__c','sigmaerpdev__Partner__r.Name,sigmaerpdev__Location__c','sigmaerpdev__Product_Id__c','sigmaerpdev__Location__r.sigmaerpdev__Active__c', 'sigmaerpdev__Status__c','sigmaerpdev__Production_Cost__c','sigmaerpdev__HiddenSelectedUnits__c'})
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Proposal__c',new set<String>{'sigmaerpdev__Client__c','sigmaerpdev__Account_Executive__c','sigmaerpdev__Ownership__c','sigmaerpdev__Account_Executive1__c','sigmaerpdev__Account_Executive2__c','sigmaerpdev__Status__c','sigmaerpdev__Other_Discount__c','sigmaerpdev__Other_Charges__c','sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__c'})
        &&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new set<String>{'sigmaerpdev__Number_of_Screens__c'})
       //&&CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Price__c',new set<String>{'sigmaerpdev__CPM__c','sigmaerpdev__Monthly_Impressions__c','sigmaerpdev__Cost__c','sigmaerpdev__Production_Cost__c','sigmaerpdev__Production_Cost_Euro__c','sigmaerpdev__Media_Cost_Euro__c','sigmaerpdev__CPM_Euro__c','sigmaerpdev__Cost_Euro__c','sigmaerpdev__Monthly_Traffic__c','sigmaerpdev__Location__c','sigmaerpdev__HiddenSelectedUnits__c'})
       &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
       //&&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Price__c')
       &&CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
       &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Proposal__c')
          )
        {
            if(Name == null || Name==''){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Enter Proposal Name.'));
                return null; 
            }
            if(campObject.Client__c == null){
                System.debug('Inside a Client__c is null condition');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Select Client.'));
                return null;
            }
            if(campObject.Account_Executive__c == null){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Select Sales Executive.'));
                return null;
            }
            if(campObject.Ownership__c == 0.0 || ownership == 00){
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Ownership for Account Executive1 client is required.'));
                return null;
            }
            if(campObject.Account_Executive1__c != null && ownership1 == 0.0){
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Ownership for Account Executive2 client is required.'));
                return null;
            }
            if(campObject.Account_Executive2__c != null && ownership2 == 0.0){
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Ownership for Account Executive3 client is required.'));
                return null;
            }
            
            if(campObject.Status__c == null){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter Proposal Status.'));
                return null;
            }
            if(campObject.Other_Discount__c < 0.00){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Other Discounts cannot have negative values.'));
                return null;
            }
            if(campObject.Other_Charges__c < 0.00){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Other Charges cannot have negative values.'));
                return null;
            }
            displayPopUp = true; 
            
            id proId =Id.valueOf(prdct);
            
            system.debug('ProAndPSNList::'+ProAndPSNList);
            if(ProAndPSNList.containsKey(proId))
            {
                
                WrapList = new List<wrapperList>();
                WrapList = ProAndPSNList.get(proId);
                isEdit = true;
                WrapProId = proId;
            }
            else
            {
                map<id,Map<Integer,Inventory_Location_Product__c>> LocAndILPList = new map<id,Map<Integer,Inventory_Location_Product__c>>();
                map<id,Map<Integer,Inventory_Location_Product__c>> validLocAndILPList = new map<id,Map<Integer,Inventory_Location_Product__c>>();
                
                List<Product2> proList = [select id, Name,Product_Price__c,(select id, name, Net_Quantity__c, Received_Quantity__c,Inventory_Location__r.Location__r.Name, Inventory_Location__r.Location__c, Inventory_Location__r.Location__r.Active__c, Inventory_Location__r.Location__r.Code__c, Message__c  from Inventory_Location_Products__r where(Inventory_Location__r.Location__r.Active__c = 'Yes') And (Net_Quantity__c >= 0))  from Product2 where id =: proId];
                
                String PRONAME='';
                Id PROId1;
                Decimal price=0.0;
                List<Inventory_Location_Product__c> ILPListInMet;
                List<WrappedILP> WrapILPList;
                WrapList = new List<wrapperList>();
                for(Product2 pro: proList)
                {
                    PRONAME = pro.Name;
                    PROId1 = pro.Id;
                    price=pro.Product_Price__c;
                    ILPListInMet = new List<Inventory_Location_Product__c>();
                    //for warning message
                    Map<id,String> locationWithWarning = new Map<id,String>();
                    WrapILPList = new List<WrappedILP>();
                    for(Inventory_Location_Product__c ilp : pro.Inventory_Location_Products__r)
                    {
                        //message
                        if(ilp.Message__c!= null)
                        {
                            if(locationWithWarning.containsKey(ilp.Inventory_Location__r.Location__c))
                            {
                                String message = locationWithWarning.get(ilp.Inventory_Location__r.Location__c) + ' , ' +ilp.Name+' - ' +ilp.Message__c;
                                locationWithWarning.put((ilp.Inventory_Location__r.Location__c), message);
                                
                            }
                            else{
                                locationWithWarning.put((ilp.Inventory_Location__r.Location__c), ilp.Name+' - ' +ilp.Message__c);
                            }
                        }
                        WrapILPList.add(new WrappedILP(ilp.Inventory_Location__r.Location__c,ilp.Inventory_Location__r.Location__r.Name,ilp.Net_Quantity__c,0,false, locationWithWarning.get(ilp.Inventory_Location__r.Location__c),price));
                    }
                    
                    
                }
                WrapList.add(new wrapperList(PRONAME, ILPListInMet, WrapILPList,0.00, PROId1));
            }
            
            
        }
        return null;  
    }
    public pageReference SubmitValues()
    {
         if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Setup_Conversion_Rate_Euro__c',new set<String>{'sigmaerpdev__Conversion_Rate__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Price__c',new set<String>{'Id','sigmaerpdev__Production_Cost__c','sigmaerpdev__Monthly_Impressions__c','sigmaerpdev__Media_Cost__c','sigmaerpdev__Media_Cost_Euro__c','sigmaerpdev__Cost__c','sigmaerpdev__Cost_Euro__c','sigmaerpdev__Monthly_Traffic__c','sigmaerpdev__CPM__c','sigmaerpdev__CPM_Euro__c','sigmaerpdev__Production_Cost_Euro__c','sigmaerpdev__HiddenSelectedUnits__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Price__c',new set<String>{'sigmaerpdev__Production_Cost__c','sigmaerpdev__Monthly_Impressions__c','sigmaerpdev__Media_Cost__c','sigmaerpdev__Media_Cost_Euro__c','sigmaerpdev__Cost__c','sigmaerpdev__Cost_Euro__c','sigmaerpdev__Monthly_Traffic__c','sigmaerpdev__CPM__c','sigmaerpdev__CPM_Euro__c','sigmaerpdev__Production_Cost_Euro__c','sigmaerpdev__HiddenSelectedUnits__c'})
       && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Proposal_Item__c',new set<String>{'sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__c','sigmaerpdev__CPM__c','sigmaerpdev__CPM_Euro__c','sigmaerpdev__Cost__c','sigmaerpdev__Cost_Euro__c','sigmaerpdev__Media_Cost__c',
                                                                                                'sigmaerpdev__Media_Cost_Euro__c','sigmaerpdev__Production_Cost__c','sigmaerpdev__Production_Cost_Euro__c','sigmaerpdev__Sum_Location_Discount__c','sigmaerpdev__Discount__c',
                                                                                                'sigmaerpdev__Discount_Euro__c','sigmaerpdev__OtherCharges__c','sigmaerpdev__Other_Charges_Euro__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Proposal_Item__c',new set<String>{'sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__c','sigmaerpdev__CPM__c','sigmaerpdev__CPM_Euro__c','sigmaerpdev__Cost__c','sigmaerpdev__Cost_Euro__c','sigmaerpdev__Media_Cost__c',
                                                                                    'sigmaerpdev__Media_Cost_Euro__c','sigmaerpdev__Production_Cost__c','sigmaerpdev__Production_Cost_Euro__c','sigmaerpdev__Sum_Location_Discount__c','sigmaerpdev__Discount__c',
                                                                                    'sigmaerpdev__Discount_Euro__c','sigmaerpdev__OtherCharges__c','sigmaerpdev__Other_Charges_Euro__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Proposal__c',new set<String>{'sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__c'})

        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Proposal_Item__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Price__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Proposal__c')
        )
        {
        DiaplayPopUpError = false;
        DiaplayMainError = false;
        isEdit = false;
        Decimal Cost = 0.00;
        Decimal productionCost = 0.00;
        //for Euro
        Decimal CostEuro = 0.00;
        Decimal productionCostEuro = 0.00;
        Decimal TotalCost = 0.00;
        OpenLine =true;
        Integer TotalCount = 0;
        
        Decimal indlineitemDiscount = 0.00;
        
        if(String.IsBlank(WrapProId))
        {
            system.debug('inside if:::');
            // WrapProId ='00570000001LlBD';commented by sandhya,22-10-2018
            //added by sandhya,22-10-2018,WrapProId assigned by current user
            Id usersId = UserInfo.getUserId();
            WrapProId = String.valueOf(usersId);
        }
       
        if(LineMap.containsKey(Id.valueOf(WrapProId)))
        {
            
            ProIdLIst.add(Id.valueOf(WrapProId));
            ProAndPSNList.put(Id.valueOf(WrapProId),WrapList);
            Integer count = 0;
            Cost = 0.00;
            productionCost = 0.00;
            
            //for Euro
            CostEuro = 0.00;
            productionCostEuro = 0.00;
            TotalCost =0.00;
            Integer i;
            String NameOfPro= '';
            Map<Id,Integer> ref = new Map<Id,Integer>();
            Map<Id,Decimal> refLocationDiscount = new Map<Id,Decimal>();
            Map<Id,Id> IlpPP = new Map<Id,Id>();
            for(wrapperList wl : WrapList)
            {
                
                Quantity= new Map<Id,Integer>();
                CompareQty = new Map<Id, Integer>();
                ILPValues = new List<Inventory_Location_Product__c>();
                
                List<Boolean> ischeckbox=new List<Boolean>();
                for(WrappedILP w : wl.ilpUiList)
                {
                    
                    if(w.checkBox && w.Quantity >0)
                    {
                        
                        Quantity.put(w.locationId,w.Quantity);
                        
                    }
                    if(w.checkBox && w.Quantity ==0){
                        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter the Units.'));
                        return null; 
                    }
                    if(w.checkBox && w.Quantity < 0 ){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Quantity values cannot be negative.'));
                        return null;
                    } 
                    if(w.availqty < w.Quantity){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Units value must be less than or equal to available Quantity.'));
                        return null;
                    }
                    if(w.checkBox==false && w.Quantity > 0 ){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Select check box.'));
                        return null;
                    } 
                    if(w.checkBox==false)
                    {
                        ischeckbox.add(false);
                    }
                    
                }
                
                if(ischeckbox.size()==wl.ilpUiList.size()){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'enter the atleast one Unit.'));
                    return null;
                } 
                
                
                NameOfPro = wl.ProName;
                
                for(WrappedILP wlpsn : wl.ilpUiList)
                {
                    if(wlpsn.checkBox)
                    {
                        ref.put(wlpsn.locationId,wlpsn.Quantity);
                        
                        count = count + wlpsn.Quantity;
                        Cost = Cost + wlpsn.pp* wlpsn.Quantity;
                    }
                    if(wlpsn.checkBox == true){
                        
                        Quantity.put(wlpsn.locationId,wlpsn.Quantity);                          
                        
                    }
                }
                
                indlineitemDiscount = wl.lineitemDiscount;
                
            }
            
            List<wrapperListInsertLineItems> JustOne = new List<wrapperListInsertLineItems>();
            JustOne.add(LineMap.get(Id.valueOf(WrapProId)));
            Proposal_Item__c pi;
            
            for(wrapperListInsertLineItems xyz: JustOne)
            {
                pi = xyz.LineItem;
                pi.Product__c = Id.valueOf(WrapProId);
                pi.Quantity__c = count;
                
                pi.Cost__c = Cost ;
                pi.Cost_Euro__c = Cost * (1/conRateEuro.Conversion_Rate__c);
                pi.Production_Cost__c = productionCost ;
                pi.Production_Cost_Euro__c = productionCost * (1/conRateEuro.Conversion_Rate__c);
                pi.Discount__c = indlineitemDiscount;
                if(indlineitemDiscount != null)
                {
                    pi.Discount_Euro__c = indlineitemDiscount * (1/conRateEuro.Conversion_Rate__c);
                }
                
                
                
            }
            LineMap.put(Id.valueOf(WrapProId),new wrapperListInsertLineItems(Id.valueOf(WrapProId), pi, NameOfPro,Cost ));
            NewMap.put(Id.valueOf(WrapProId),ref);
            
            ProIlpppMap.put(Id.valueOf(WrapProId),IlpPP);
            
            CompleteList = new List<wrapperListInsertLineItems>();
            set<Id> IdList = LineMap.KeySet();
            for(Id IdRef:IdList)
            {
                CompleteList.add(LineMap.get(IdRef));
            }
            System.debug('CompleteList'+CompleteList);
            List<Date> startDateList = new List<Date>();
            List<Date> EndDateList = new List<Date>();
            
            
            campaignDateEditable = false;
            ProAndProItemList.put(Id.valueOf(WrapProId), pi);
            Id usersId = UserInfo.getUserId();
            WrapProId = String.valueOf(usersId);
            displayPopUp = false;
            return null;
        }
        else
        {
            //for Dollar
            Cost = 0.00;
            productionCost = 0.00;
            //for Euro
            CostEuro = 0.00;
            productionCostEuro = 0.00;
            TotalCost =0.00;
            Integer i;
            
            ProIdLIst.add(Id.valueOf(prdct));
            ProAndPSNList.put(Id.valueOf(prdct),WrapList);
            Integer count = 0;
            String NameOfPro= '';
            Map<Id,Integer> ref = new Map<Id,Integer>();
            
            Map<Id,id> IlpPP = new Map<Id,id>();
            for(wrapperList wl : WrapList)
            {
                Quantity= new Map<Id,Integer>();
                CompareQty = new Map<Id, Integer>();
                ILPValues = new List<Inventory_Location_Product__c>();
                //for Error message
                List<Boolean> ischeckbox = new List<Boolean>();
                for(WrappedILP w : wl.ilpUiList)
                {
                    
                    if(w.checkBox && w.Quantity >0)
                    { 
                        Quantity.put(w.locationId,w.Quantity);
                        
                        
                    }
                    if(w.checkBox && w.Quantity ==0){
                        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Enter the Units.'));
                        return null;
                    }
                    if(w.checkBox && w.Quantity < 0 ){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Quantity values cannot be negative.'));
                        return null;
                    } 
                    if(w.availqty < w.Quantity){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Units value must be less than or equal to available Screens.'));
                        return null;
                    }
                    if(w.checkBox==false && w.Quantity > 0 ){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Select check box.'));
                        return null;
                    } 
                    if(w.checkBox==false)
                    {
                        ischeckbox.add(false);
                    }
                    
                }
               
                if(ischeckbox.size()==wl.ilpUiList.size()){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'enter the atleast one Unit.'));
                    return null;
                } 
                
                //Till here
                NameOfPro = wl.ProName;
                
                for(WrappedILP wlpsn : wl.ilpUiList)
                {
                    
                    if(wlpsn.checkBox)
                    {
                        
                        ref.put(wlpsn.locationId,wlpsn.Quantity);
                        
                        count = count + wlpsn.Quantity;
                        Cost = Cost + wlpsn.pp* wlpsn.Quantity;
                    }
                    
                    if(wlpsn.checkBox == true)
                    {
                        
                        Quantity.put(wlpsn.locationId,wlpsn.Quantity);
                        
                    }
                }
                
                indlineitemDiscount = wl.lineitemDiscount; 
                
            } 
            Proposal_Item__c pi = new Proposal_Item__c();
            
            pi.Product__c = Id.valueOf(prdct);
            pi.Quantity__c = count;
            pi.Cost__c = Cost ;
            pi.Cost_Euro__c = Cost * (1/conRateEuro.Conversion_Rate__c);
            pi.Production_Cost__c = productionCost ;
            pi.Production_Cost_Euro__c = productionCost * (1/conRateEuro.Conversion_Rate__c);
            pi.Discount__c = indlineitemDiscount;
            if(indlineitemDiscount != null)
            {
                pi.Discount_Euro__c = indlineitemDiscount * (1/conRateEuro.Conversion_Rate__c);
            }
            
            LineMap.put(Id.valueOf(prdct),new wrapperListInsertLineItems(Id.valueOf(prdct), pi, NameOfPro, Cost));
            NewMap.put(Id.valueOf(prdct),ref);
            
            ProIlpppMap.put(Id.valueOf(prdct),IlpPP);            
            CompleteList = new List<wrapperListInsertLineItems>();
            set<Id> IdList = LineMap.KeySet();
            for(Id IdRef:IdList)
            {
                CompleteList.add(LineMap.get(IdRef));
            }
            
            ProAndProItemList.put(Id.valueOf(prdct), pi);
            
            displayPopUp = false; 
            campaignDateEditable = false;           
            return null;    
        }
    }
    return null;    
    }
    
    public pageReference CancelPopUp()
    {
        displayPopUp = false;
        if(isEdit)
        {
            WrapList = ProAndPSNList.get(id.valueOf(WrapProId));
            
        }
        //WrapProId ='00570000001LlBr'; ccommented by sandhya,22-10-2018
        //added by sandhya,22-10-2018,WrapProId assigned by current user
        Id usersId = UserInfo.getUserId();
        WrapProId = String.valueOf(usersId);
        isEdit = false;
        return null;
    }
    public pageReference SaveChange()
    {
        Id CampId;
        //======================[Check FLS]======================
        //FLS Check : Sandhya
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Proposal__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Proposal_Item__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Proposal__c',new set<String>{'sigmaerpdev__Client__c','sigmaerpdev__Account_Executive__c', 'sigmaerpdev__Usage_Type__c',
               'sigmaerpdev__Ownership__c','sigmaerpdev__Account_Executive1__c','sigmaerpdev__Account_Executive2__c','sigmaerpdev__Discount__c','sigmaerpdev__Status__c',
               'sigmaerpdev__Other_Discount__c','sigmaerpdev__Other_Charges__c','sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__C','sigmaerpdev__Agent_Commission__c','sigmaerpdev__Agent_Commission_Euro__c','sigmaerpdev__AVR_Commission__c','sigmaerpdev__Proposal_Name__c','sigmaerpdev__PO_Number__c','sigmaerpdev__Billing_Option__c',
               'sigmaerpdev__Billing_Frequency__c','sigmaerpdev__Billing_Detail__c','sigmaerpdev__Consolidated_Billing__c','sigmaerpdev__Internal_Business__c','sigmaerpdev__Ownership1__c','sigmaerpdev__Ownership2__c','sigmaerpdev__Field_Discount_Amount__c','sigmaerpdev__Discount_Method_Option_Value__c','sigmaerpdev__Billing_Currency__c','sigmaerpdev__Other_Charges_Euro__c','sigmaerpdev__Field_Discount_Amount_Euro__c','sigmaerpdev__Other_Discount_Euro__c','sigmaerpdev__AVR_Commission_Euro__c','sigmaerpdev__AVR_Percent__c','Account_Executive2__c','sigmaerpdev__Discount_Method__c','sigmaerpdev__Agency_Percent__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Proposal_Item__c',new set<String>{'sigmaerpdev__AdjustedLineItemTotal__c','sigmaerpdev__Proposal__c','sigmaerpdev__Charlie_Id__c','sigmaerpdev__Cost__c','sigmaerpdev__Cost_Euro__c','sigmaerpdev__CPM__c','sigmaerpdev__CPM_Euro__c','sigmaerpdev__Discount__c','sigmaerpdev__Discount_Euro__c','sigmaerpdev__End_Date__c','sigmaerpdev__Inventory_Allocated__c ','sigmaerpdev__Inventory_Location__c','sigmaerpdev__Location__c','sigmaerpdev__Media_Cost__c','sigmaerpdev__Media_Cost_Euro__c','sigmaerpdev__Monthly_Impression__c','sigmaerpdev__Monthly_Traffic__c','sigmaerpdev__OtherCharges__c','sigmaerpdev__Other_Charges_Euro__c','sigmaerpdev__Product__c','sigmaerpdev__Product_Inventory_Location__c','sigmaerpdev__Production_Cost__c','sigmaerpdev__Production_Cost_Euro__c','sigmaerpdev__Quantity__c','sigmaerpdev__Sales_Commission__c','sigmaerpdev__Sales_Commission_Copy__c','sigmaerpdev__Sales_Commission_Copy_Euro__c','sigmaerpdev__Sum_Location_Discount__c','sigmaerpdev__Start_Date__c','sigmaerpdev__Sales_Commission_Euro__c'})
           && Schema.sObjectType.Proposal_Item__c.isDeletable()
           && CRUD_FLS_CheckUtility.checkReadPermission('Contact',new set<String>{'Id', 'Name'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Time_Base_Inventory__c',new set<String>{'sigmaerpdev__Proposal__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Proposal__c',new set<String>{'sigmaerpdev__Status__c','sigmaerpdev__Discount_Method__c','sigmaerpdev__Account_Executive2__c','sigmaerpdev__Account_Executive1__c','sigmaerpdev__Account_Executive__c','sigmaerpdev__Other_Charges_Euro__c','sigmaerpdev__Field_Discount_Amount_Euro__c','sigmaerpdev__Other_Discount_Euro__c','sigmaerpdev__Agent_Commission_Euro__c','sigmaerpdev__AVR_Commission_Euro__c','sigmaerpdev__AVR_Commission__c','sigmaerpdev__Agent_Commission__c','sigmaerpdev__Other_Discount__c','sigmaerpdev__Field_Discount_Amount__c','sigmaerpdev__Other_Charges__c','sigmaerpdev__Billing_Currency__c','sigmaerpdev__Discount_Method_Option_Value__c','sigmaerpdev__Field_Discount_Amount__c','sigmaerpdev__Ownership2__c','sigmaerpdev__Ownership1__c','sigmaerpdev__Ownership__c','sigmaerpdev__Internal_Business__c','sigmaerpdev__Consolidated_Billing__c','sigmaerpdev__Billing_Detail__c','sigmaerpdev__Billing_Frequency__c','sigmaerpdev__Billing_Option__c','sigmaerpdev__PO_Number__c','sigmaerpdev__Proposal_Name__c' ,'sigmaerpdev__Usage_Type__c'}) 
           && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Proposal_Item__c',new set<String>{'sigmaerpdev__Proposal__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Setup_Conversion_Rate_Euro__c',new set<String>{'sigmaerpdev__Conversion_Rate__c'})
           
          )
        { 
           Double OwnershipSum;
            if(ordercreted == true ){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Order is created for this Proposal'));
                errorOccurred = true;
                return null;
            }
            if(Name == null || Name==''){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter Proposal Name.'));
                errorOccurred = true;
                return null;
            }
            if(campObject.Client__c == null){
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Customer.'));
                errorOccurred = true;
                return null;
            }
            if(campObject.Account_Executive__c== null){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select Sales Executive.'));
                errorOccurred = true;
                return null;
            }
            if(campObject.Ownership__c == 0.0 || ownership == 00){
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Ownership for Account Executive-1 client is required.'));
                errorOccurred = true;
                return null;
            }
            if(campObject.Ownership__c < 0.0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Ownership for Account Executive1 cannot have negative values.'));
                errorOccurred = true;
                return null;
            }
            if(campObject.Account_Executive1__c != null && ownership1 == 0.0){
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Ownership for Account Executive2 client is required.'));
                errorOccurred = true;
                return null;
            }
            if(campObject.Account_Executive2__c != null && ownership2 == 0.0){
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Ownership for Account Executive3 client is required.'));
                errorOccurred = true;
                return null;
            }
            if(campObject.Discount__c > 100 ){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Discount value cannot be more than 100%.'));
                errorOccurred = true;
                return null;
            }
            System.debug('campObject.Status__c:::' + campObject.Status__c);
            if(campObject.Status__c == null){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter Proposal Status.'));
                errorOccurred = true;
                return null;
            }
            //To check userPermission for Signed and ContractPending
            
            if((OldCampStatus == 'Signed')  && ((campObject.Status__c == 'Proposed') || (campObject.Status__c == 'Active Negotiation')  || (campObject.Status__c == 'Planning'))){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Signed Proposal cannot be moved to Planning/Proposed/Active Negotiation Status'));
                errorOccurred = true;
                return null;
            } 
            if((OldCampStatus == 'Contract Pending')  && ((campObject.Status__c == 'Proposed') || (campObject.Status__c == 'Active Negotiation'))){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Contract Pending Proposal cannot be moved to Proposed/Active Negotiation Status'));
                errorOccurred = true;
                return null;
            }
            if((OldCampStatus == 'Cancelled')  && ((campObject.Status__c == 'Signed') || (campObject.Status__c == 'Planning') ||(campObject.Status__c == 'Proposed')||(campObject.Status__c == 'Active Negotiation') )){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Can not change cancelled status'));
                errorOccurred = true;
                return null;
            }
            
            if(campObject.Other_Discount__c < 0.00){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Other Discounts cannot have negative values.'));
                errorOccurred = true;
                return null;
            }
            if(campObject.Other_Charges__c < 0.00){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Other Charges cannot have negative values.'));
                errorOccurred = true;
                return null;
            } 
            
            //ends here.
            campObject.Proposal_Name__c = Name;
            campObject.PO_Number__c = Po_Number;
            campObject.Billing_Option__c = billingOption;
            campObject.Billing_Frequency__c = billingFrequency;
            campObject.Billing_Detail__c = billingDetail;
            campObject.Consolidated_Billing__c = consolidatedBilling;
            campObject.Internal_Business__c = internalBusiness;
            campObject.Ownership__c = ownership;
            campObject.Ownership1__c = ownership1;
            campObject.Ownership2__c = ownership2;
            campObject.Usage_Type__c='Product';
            system.debug('discountAmount==='+campObject.Field_Discount_Amount__c);
            campObject.Field_Discount_Amount__c = campObject.Field_Discount_Amount__c;
            System.debug('discountMethodOptionValue::::::'+discountMethodOptionValue);
            campObject.Discount_Method_Option_Value__c = discountMethodOptionValue;
            
            campObject.Billing_Currency__c = billingCurrency;
            
            
            if(campObject.Other_Charges__c == null)
            {
                campObject.Other_Charges__c = 0.00;
            }
            if(campObject.Field_Discount_Amount__c == null)
            {
                campObject.Field_Discount_Amount__c = 0.00;
            }
            if(campObject.Other_Discount__c == null)
            {
                campObject.Other_Discount__c = 0.00;
            }
            if(campObject.Agent_Commission__c == null)
            {
                campObject.Agent_Commission__c = 0.00;
            }
            if(campObject.AVR_Commission__c == null)
            {
                campObject.AVR_Commission__c = 0.00;
            }
            campObject.Other_Charges_Euro__c = campObject.Other_Charges__c * (1/conRateEuro.Conversion_Rate__c);
            campObject.Field_Discount_Amount_Euro__c = campObject.Field_Discount_Amount__c * (1/conRateEuro.Conversion_Rate__c);
            campObject.Other_Discount_Euro__c = campObject.Other_Discount__c * (1/conRateEuro.Conversion_Rate__c);
            
            
            if(discountMethodOptionValue == 0){
                discountMethodChosen = 'None';
            }else if(discountMethodOptionValue == 1){
                discountMethodChosen = 'Product';
            }else if(discountMethodOptionValue == 3){
                discountMethodChosen = 'Proposal';
            }
            
            //for user in campaign
            List<Id> accExecutiveListId = new List<Id>();
            if(campObject.Account_Executive__c != null)
            {
                accExecutiveListId.add(campObject.Account_Executive__c);
            }
            if(campObject.Account_Executive1__c != null)
            {
                accExecutiveListId.add(campObject.Account_Executive1__c);
            }
            if(campObject.Account_Executive2__c != null)
            {
                accExecutiveListId.add(campObject.Account_Executive2__c);
            }       
            Map<Id,Contact> IdAndContactObject = new Map<Id,Contact>([select Id, Name from Contact where Id IN: accExecutiveListId]);
            System.debug('IdAndContactObject'+IdAndContactObject);
            if(campObject.Account_Executive__c != null)
            {
                if(IdAndContactObject.containsKey(campObject.Account_Executive__c))
                {
                    campObject.Account_Executive__c = IdAndContactObject.get(campObject.Account_Executive__c).Id;
                }
            }
            else
            {
                campObject.Account_Executive__c = null;
            }
            if(campObject.Account_Executive1__c != null)
            {
                if(IdAndContactObject.containsKey(campObject.Account_Executive1__c))
                {
                    campObject.Account_Executive1__c = IdAndContactObject.get(campObject.Account_Executive1__c).Id;
                }
            }
            else
            {
                campObject.Account_Executive1__c = null;
            }
            if(campObject.Account_Executive2__c != null)
            {
                if(IdAndContactObject.containsKey(campObject.Account_Executive2__c))
                {
                    campObject.Account_Executive2__c = IdAndContactObject.get(campObject.Account_Executive2__c).Id;
                }
            }
            else
            {
                campObject.Account_Executive2__c = null;
            }
            
            campObject.Discount_Method__c = discountMethodChosen;
            {
                try{
                    upsert campObject;
                }
                catch(DmlException ex){
                    
                    ApexPages.addMessages(ex);
                    return null;
                }
                
                Set<Id> deletedLineItemIds = new Set<Id>();
                if(DeleteLineItemWhenDelete.size() != 0)
                {
                    for(Proposal_Item__c pi : DeleteLineItemWhenDelete)
                    {
                        deletedLineItemIds.add(pi.Id);
                    }
                    
                    if(Proposal_Item__c.sObjectType.getDescribe().isDeletable())
                        
                    {
                        delete DeleteLineItemWhenDelete;
                    }
                    
                }
                
                CampId = campObject.Id;
                String CampStatus = campObject.Status__c;
                List<wrapperListInsertLineItems> ToInsertLine = new List<wrapperListInsertLineItems>();
                Set<Id> IdList = LineMap.KeySet();
                for(Id RefId: IdList)
                {
                    ToInsertLine.add(LineMap.get(RefId));
                }   
                
                List<Proposal_Item__c> LineItemList = new List<Proposal_Item__c>();
                for(wrapperListInsertLineItems genList: ToInsertLine)
                {
                    Proposal_Item__c PI = new Proposal_Item__c();
                    
                    if(genList.LineItem.id == null)
                    {
                        genList.LineItem.Proposal__c = CampId;
                    } 
                    LineItemList.add(genList.LineItem);
                }
                
                upsert LineItemList;
                //New flow
                Map<Id, Integer> RefToMap = new Map<Id, Integer>();
                Map<Id, Decimal> RefToLocationDiscountMap = new Map<Id, Decimal>();
                Map<Id, Integer> RechangeNewMap = new Map<Id, Integer>();
                for(Proposal_Item__c IndLine : LineItemList)
                {
                    if(NewMap.ContainsKey(IndLine.Product__c))
                    {
                        RefToMap = NewMap.get(IndLine.Product__c);
                        RechangeNewMap = NewMap.get(IndLine.Product__c);
                        
                    }
                    NewMap.put(IndLine.Product__c,RechangeNewMap);
                    
                }
                
                set<id> campLineItemLocationId = new set<id>();
                set<id> campLineItem = new set<id>();
                
                
                List<wrapperList> ChangeWrapList = new List<wrapperList>();
                Map<Id, Integer> justRef = new Map<Id, Integer>();
                Map<Id, Decimal> justRefLocationDiscount = new Map<Id, Decimal>();
                Map<Id,Id> justIlpPP = new Map<Id,Id>();
                
            }
            
        }
        
        
        // PageReference pageRef = new PageReference('/' +CampId );
        PageReference pageRef = new PageReference('/apex/ProposalVF');
        pageRef.setRedirect(true);
        return pageRef;
        
    }
    public pageReference CancelMainflow()
    {
        
        Id CampId = campObject.Id;
        PageReference pageRef;
        Schema.DescribeSObjectResult anySObjectSchema = Proposal__c.SObjectType.getDescribe();
        String objectIdPrefix = anySObjectSchema.getKeyPrefix();
        
        if(CampId == null){
            //pageRef = new PageReference('/'+objectIdPrefix+'/o');
            pageRef = new PageReference('/apex/ProposalVF');
            pageRef.setRedirect(true);
        }else{
            //pageRef =  new PageReference('/' +CampId);
            pageRef = new PageReference('/apex/ProposalVF');
            pageRef.setRedirect(true);
        }        
        return pageRef;
    }
    
    public pageReference DeleteFeature()
    {
        if( CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Proposal__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Proposal__c',new set<String>{'sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__c'})
          )
        {
           
            if(LineMap.containsKey(Id.valueOf(WrapProId)))
            {
                List<wrapperListInsertLineItems> JustOne = new List<wrapperListInsertLineItems>();
                JustOne.add(LineMap.get(Id.valueOf(WrapProId)));
                for(wrapperListInsertLineItems xyz: JustOne)
                {
                    if(xyz.LineItem.id != null)
                    {
                        DeleteLineItemWhenDelete.add(xyz.LineItem);
                    }
                    
                }
                LineMap.remove(Id.valueOf(WrapProId));
                ProAndPSNList.remove(Id.valueOf(WrapProId));
               
            }
            
            CompleteList = new List<wrapperListInsertLineItems>();
            set<Id> IdList = LineMap.KeySet();
            
            for(Id IdRef:IdList)
            {
                CompleteList.add(LineMap.get(IdRef));
            }
            WrapProId = null;
            //New Logic for campaign date
            
        }else
        {
            return null;
        }
        return null;
    }
    public pageReference EditFeature()
    {
        displayPopUp = true;
        isEdit = true;
        
        if(ProAndPSNList.containsKey(Id.valueOf(WrapProId)))
        {
            
            WrapList = new List<wrapperList>();
            WrapList = ProAndPSNList.get(Id.valueOf(WrapProId));
        }
        
        return null;
    }
    
    
}