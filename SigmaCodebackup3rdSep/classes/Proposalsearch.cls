public with sharing class Proposalsearch{
  
     public String ClientId{get;set;}
public List<String> CompleteClientList{get;set;}
public List<SelectOption> ClientList{get;set;}
public String StatusId{get;set;}
public List<SelectOption> StatusList{get;set;}
public String ContactId{get;set;}
public List<String> CompleteContactList{get;set;}
public List<SelectOption> ContactList{get;set;}
public List<String> StatusListComplete {get;set;}
public Date StartDate{get;set;}
public Date EndDate{get;set;}
public String cancellationReason{get;set;}
public boolean displayPopupCancel{get; set;}    

public Proposal__c accountDetail {get;set;}   
public String campaignId {get;set;}  
public Boolean showResultsTable {get;set;} 
public String chosenName{get;set;} 
public String enteredName{get;set;}
public Boolean emptyResultsTable{get;set;}  
public String selectedCampaignId{get;set;}
public Integer size{get;set;}
public Integer counter {get;set;}
public Integer limitSize{get;set;}
public Integer totalSize{get;set;}
public Integer toCount{get;set;}
public Integer fromCount{get;set;}
public List<Proposal__c> CampaignToShow{get;set;}
public List<Proposal__c> CampaignList {get;set;}

public boolean displayPopUp{get;set;}

//Generate proposal code
public Proposal__c campObject {get;set;}
public String CampaignName {get;set;}
public String Name {get;set;}
public String insertedCampaignid{get;set;}  
public Proposal__c campaigndetails {get;set;}
public List<Proposal_Item__c> proditemdetails {get;set;}
public List<String> Productlistids {get;set;}
public List<String>Marketlistids {get;set;} 
public String campaignID1 {get;set;}
public Integer count{get;set;}
//public List<WrapperToDisplayAllocation> WrapperPropList{get;set;}
public String CampId{get;set;}
public Proposal__c CampDetails{get;set;}
public String SDate{get;set;}
public String EDate{get;set;}
public List<Id> PItemID{get;set;}
public List<String> TempProductList {get;set;} 
public Integer countproduct{get;set;}
//public List<WrapperToDisplayProduct> WrapperlistProduct {get;set;}
public String EventName{get;set;}
public String Duration{get;set;}
public DateTime d{get;set;}
public String aft{get;set;}

//For ProductXLS
public Integer productTotalQuantity{get;set;}
public Decimal productTotalCost{get;set;}
public Map <Id,String> ProAndMediaTypeList{get;set;}

//For ProposalDetails
public List<Proposal_Item__c> completeCampaignDetails{get;set;}
public Integer CampaignDetailsTotalQuantity{get;set;}
public Decimal CampaignDetailsTotalProductionCost{get;set;}
public Decimal CampaignDetailsTotalCost{get;set;}
public Decimal CampaignDetailsTotalCostForBundleProdCategory{get;set;} // for Bundle by Product Category

//For Discounts
public Decimal DiscountedCampaignDetailsTotalCost{get;set;}
public Decimal DiscountedValue{get;set;}    
public Decimal otherCharges{get;set;}
public Decimal totalOtherCharges{get;set;}
public String otherChargesComments{get;set;}
public Decimal agentCommission{get;set;}
//ends here.

//for bundle by dma
public List<Proposal_Item__c> completeCampaignList = new List<Proposal_Item__c>();

//ends here

//for sorting
public String sortOrder{get;set;}
public String startDateSortDirection{get;set;}
public String endDateSortDirection{get;set;}
    
    public class wrapper{
        @AuraEnabled
        public  Integer pageSize;
        @AuraEnabled
        public  Integer page;
        @AuraEnabled
        public  Integer total ;
        @AuraEnabled
        public string PropId;
        //@AuraEnabled
        //public boolean ProdEditFlag;
        //@AuraEnabled
        //public String RecordId;
        @AuraEnabled
        public List<Proposal__c> Poplist;
        
        
    }
    
    
    @auraEnabled
    public static wrapper FetchProposal(Decimal pageNumber,List<Proposal__c> propdetail){
        
     
        system.debug('propdetail>>>>'+propdetail);
        
         wrapper MainWrap;
        String PropId1;
        string status;
        Date StartDate;
        Date EndDate;
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Proposal__c',new set<String>{'id','Name','sigmaerpdev__Usage_Type__c','Proposal_Name__c','sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__c','sigmaerpdev__Estimated_Close_Date__c','sigmaerpdev__Account_Executive__r.Name','sigmaerpdev__Account_Executive_1_acc__r.Name','sigmaerpdev__Net_Amount__c','sigmaerpdev__Total_Amount__c','sigmaerpdev__Status__c','sigmaerpdev__Agency__r.Name', 'sigmaerpdev__Client__r.Name'})
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Proposal__c')
          ){
            if(propdetail[0].Name !=null || propdetail[0].Name !=''){
            PropId1 = propdetail[0].Name;
        }
        if(propdetail[0].Status__c !=null || propdetail[0].Status__c !=''){
            status = propdetail[0].Status__c;
            system.debug('status>>>>>>>>>>'+status);
        }
        if(propdetail[0].Start_Date__c !=null){
            StartDate = propdetail[0].Start_Date__c; 
            system.debug('StartDate>>>>>>>>>>'+StartDate);
        }
        
        if(propdetail[0].End_Date__c !=null){
            EndDate = propdetail[0].End_Date__c;
        }
        
        
        system.debug('StartDate>>>>>>>>>>>>'+StartDate);
        
        
       
        
        Integer pageSize = 30;
        Integer offset = ((Integer)pageNumber - 1) * pageSize;
        
        MainWrap =  new wrapper();
        MainWrap.pageSize = pageSize;
        MainWrap.page = (Integer) pageNumber;
        
        List<Proposal__c> propList = new List<Proposal__c>();
        
        if(string.valueOf(propdetail[0].Name)!='' && propdetail[0].Status__c!=null  && propdetail[0].Start_Date__c != null&& propdetail[0].End_Date__c != null )
        {
            propList=[select id,Name,Usage_Type__c,Proposal_Name__c,Start_Date__c,End_Date__c,Estimated_Close_Date__c,Account_Executive__r.Name,Net_Amount__c,Total_Amount__c,Status__c,Agency__r.Name, Client__r.Name from Proposal__c WHERE Name =:propdetail[0].Name AND Status__c =:propdetail[0].Status__c AND Start_Date__c >=:propdetail[0].Start_Date__c AND End_Date__c <=:propdetail[0].End_Date__c Order By Start_Date__c Asc limit :pageSize offset :offset];
            
        }
        
        else if(string.valueOf(propdetail[0].Name)!='' && propdetail[0].Status__c!=null && propdetail[0].Start_Date__c != null)
        {
            propList=[select id,Name,Usage_Type__c,Proposal_Name__c,Start_Date__c,End_Date__c,Estimated_Close_Date__c,Account_Executive__r.Name,Net_Amount__c,Total_Amount__c,Status__c,Agency__r.Name, Client__r.Name from Proposal__c WHERE Name =: propdetail[0].Name AND Status__c=:propdetail[0].Status__c AND Start_Date__c >=: propdetail[0].Start_Date__c   Order By Start_Date__c Asc limit :pageSize offset :offset];
            
        }
        
        else if(string.valueOf(propdetail[0].Name)!='' && propdetail[0].Status__c!=null && propdetail[0].End_Date__c != null)
        {
            propList=[select id,Name,Usage_Type__c,Proposal_Name__c,Start_Date__c,End_Date__c,Estimated_Close_Date__c,Account_Executive__r.Name,Net_Amount__c,Total_Amount__c,Status__c,Agency__r.Name, Client__r.Name from Proposal__c WHERE Name =: propdetail[0].Name AND Status__c=:propdetail[0].Status__c AND End_Date__c <=: propdetail[0].End_Date__c   Order By Start_Date__c Asc limit :pageSize offset :offset];
            
        }
        
        else if(string.valueOf(propdetail[0].Name)!=''  && propdetail[0].Start_Date__c != null&& propdetail[0].End_Date__c != null )
        {
            propList=[select id,Name,Usage_Type__c,Proposal_Name__c,Start_Date__c,End_Date__c,Estimated_Close_Date__c,Account_Executive__r.Name,Net_Amount__c,Total_Amount__c,Status__c,Agency__r.Name, Client__r.Name from Proposal__c WHERE Name =: propdetail[0].Name   AND Start_Date__c >=: propdetail[0].Start_Date__c AND End_Date__c<=: propdetail[0].End_Date__c Order By Start_Date__c Asc limit :pageSize offset :offset];
            
        }
        
        else if(string.valueOf(propdetail[0].Name)!='' && propdetail[0].Start_Date__c != null)
        {
            propList=[select id,Name,Usage_Type__c,Proposal_Name__c,Start_Date__c,End_Date__c,Estimated_Close_Date__c,Account_Executive__r.Name,Net_Amount__c,Total_Amount__c,Status__c,Agency__r.Name, Client__r.Name from Proposal__c WHERE Name =: propdetail[0].Name   AND Start_Date__c >=: propdetail[0].Start_Date__c   Order By Start_Date__c Asc limit :pageSize offset :offset];
            
        }
        
        else if(string.valueOf(propdetail[0].Name)!='' &&   propdetail[0].End_Date__c != null )
        {
            propList=[select id,Name,Usage_Type__c,Proposal_Name__c,Start_Date__c,End_Date__c,Estimated_Close_Date__c,Account_Executive__r.Name,Net_Amount__c,Total_Amount__c,Status__c,Agency__r.Name, Client__r.Name from Proposal__c WHERE Name =: propdetail[0].Name AND End_Date__c<=: propdetail[0].End_Date__c Order By Start_Date__c Asc limit :pageSize offset :offset];
            
        }
        
        else if(string.valueOf(propdetail[0].Name)!='' && propdetail[0].Status__c!=null )
        {
            propList=[select id,Name,Usage_Type__c,Proposal_Name__c,Start_Date__c,End_Date__c,Estimated_Close_Date__c,Account_Executive__r.Name,Net_Amount__c,Total_Amount__c,Status__c,Agency__r.Name, Client__r.Name from Proposal__c WHERE Name =: propdetail[0].Name AND Status__c=: propdetail[0].Status__c  Order By Start_Date__c Asc limit :pageSize offset :offset];
            
        }
        else if(propdetail[0].Status__c!=null  && propdetail[0].Start_Date__c != null&& propdetail[0].End_Date__c != null )
        {
            propList=[select id,Name,Usage_Type__c,Proposal_Name__c,Start_Date__c,End_Date__c,Estimated_Close_Date__c,Account_Executive__r.Name,Net_Amount__c,Total_Amount__c,Status__c,Agency__r.Name, Client__r.Name from Proposal__c WHERE  Status__c=:propdetail[0].Status__c AND Start_Date__c >=: propdetail[0].Start_Date__c AND End_Date__c<=: propdetail[0].End_Date__c Order By Start_Date__c Asc limit :pageSize offset :offset];
            
        }
        else if(propdetail[0].Status__c!=null  && propdetail[0].Start_Date__c != null )
        {
            propList=[select id,Name,Usage_Type__c,Proposal_Name__c,Start_Date__c,End_Date__c,Estimated_Close_Date__c,Account_Executive__r.Name,Net_Amount__c,Total_Amount__c,Status__c,Agency__r.Name, Client__r.Name from Proposal__c WHERE  Status__c=:propdetail[0].Status__c AND Start_Date__c >=: propdetail[0].Start_Date__c   Order By Start_Date__c Asc limit :pageSize offset :offset];
            
        } 
        
        else if(propdetail[0].Status__c!=null  && propdetail[0].End_Date__c != null )
        {
            propList=[select id,Name,Usage_Type__c,Proposal_Name__c,Start_Date__c,End_Date__c,Estimated_Close_Date__c,Account_Executive__r.Name,Net_Amount__c,Total_Amount__c,Status__c,Agency__r.Name, Client__r.Name from Proposal__c WHERE  Status__c=:propdetail[0].Status__c AND End_Date__c <=: propdetail[0].End_Date__c   Order By Start_Date__c Asc limit :pageSize offset :offset];
            
        } 
        else if(propdetail[0].Start_Date__c != null&& propdetail[0].End_Date__c != null)
        {
            propList=[select id,Name,Usage_Type__c,Proposal_Name__c,Start_Date__c,End_Date__c,Estimated_Close_Date__c,Account_Executive__r.Name,Net_Amount__c,Total_Amount__c,Status__c,Agency__r.Name, Client__r.Name from Proposal__c WHERE   Start_Date__c >=: propdetail[0].Start_Date__c AND End_Date__c<=: propdetail[0].End_Date__c Order By Start_Date__c Asc limit :pageSize offset :offset];
            
        }
        else if(string.valueOf(propdetail[0].Name)!='')
        {
            propList=[select id,Name,Usage_Type__c,Proposal_Name__c,Start_Date__c,End_Date__c,Estimated_Close_Date__c,Account_Executive__r.Name,Net_Amount__c,Total_Amount__c,Status__c,Agency__r.Name, Client__r.Name from Proposal__c WHERE Name =: propdetail[0].Name  Order By Start_Date__c Asc limit :pageSize offset :offset];
            
        }
        else if(propdetail[0].Status__c != null)
        {
            propList=[select id,Name,Usage_Type__c,Proposal_Name__c,Start_Date__c,End_Date__c,Estimated_Close_Date__c,Account_Executive__r.Name,Net_Amount__c,Total_Amount__c,Status__c,Agency__r.Name, Client__r.Name from Proposal__c WHERE Status__c =:propdetail[0].Status__c Order By Start_Date__c Asc limit :pageSize offset :offset];
            
        }
        else if(propdetail[0].Start_Date__c != null )
        {
            propList=[select id,Name,Usage_Type__c,Proposal_Name__c,Start_Date__c,End_Date__c,Estimated_Close_Date__c,Account_Executive__r.Name,Net_Amount__c,Total_Amount__c,Status__c,Agency__r.Name, Client__r.Name from Proposal__c WHERE   Start_Date__c >=:propdetail[0].Start_Date__c Order By Start_Date__c Asc limit :pageSize offset :offset];
            
        }
        else if(propdetail[0].End_Date__c != null )
        {
            propList=[select id,Name,Usage_Type__c,Proposal_Name__c,Start_Date__c,End_Date__c,Estimated_Close_Date__c,Account_Executive__r.Name,Net_Amount__c,Total_Amount__c,Status__c,Agency__r.Name, Client__r.Name from Proposal__c WHERE   End_Date__c<=:propdetail[0].End_Date__c Order By Start_Date__c Asc limit :pageSize offset :offset];
            
        }
        
        system.debug('propList>>>>>>>>>>>'+propList);
        MainWrap.total = propList.size();
        //MainWrap.ProdEditFlag = false;
        MainWrap.Poplist = propList;
        system.debug('MainWrap>>>>>>>>>>>>'+MainWrap);
        }
        
        
        return MainWrap;
    }
    
      @AuraEnabled
    public static Proposal__c UpdateStatus(String PropList){
        system.debug('PropList>>>>>>>>>>>>>'+PropList);
 //  if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Proposal__c',new set<String>{'id','Name','sigmaerpdev__Usage_Type__c','Proposal_Name__c','sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__c','sigmaerpdev__Estimated_Close_Date__c','sigmaerpdev__Account_Executive__r.Name','sigmaerpdev__Net_Amount__c','sigmaerpdev__Total_Amount__c','sigmaerpdev__Status__c','sigmaerpdev__Agency__r.Name', 'sigmaerpdev__Client__r.Name'})
  //   && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Proposal__c')
  //    && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Proposal__c',new set<String>{'name','sigmaerpdev__Status__c'})
  //   ){

       // List<sigmaerpdev__Proposal__c> propList = new List<sigmaerpdev__Proposal__c>();
        Proposal__c proobj = [select id,name,Status__c,Is_Order_Created__c,Usage_Type__c,Inventory_Allocated__c from Proposal__c where id=: PropList limit 1];
        if(!proobj.Is_Order_Created__c)
        proobj.Status__c = 'Cancelled';
        update proobj;
        system.debug('proobj>>>>>>>>>>>>>'+proobj);
        if(proobj.Usage_Type__c == 'Service' && proobj.Inventory_Allocated__c)
             Boolean cancel = AllocateInventoryCntrl.DeAllocateInventory(proobj.Id);
         system.debug('calling');
                //}
      return proobj;  
    }
    
    public PageReference generatereport() 
    {
    
    
   System.debug('inside generatereport>>>>>>>>');
    //insertedCampaignid = selectedCampaignId;
    if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Proposal__c',new set<String>{'Id','Name', 'sigmaerpdev__Account_Executive__r.Name','sigmaerpdev__Account_Executive_1_acc__r.Name', 'sigmaerpdev__Proposal_Name__c', 'sigmaerpdev__Client__c', 'sigmaerpdev__Other_Charges__c','sigmaerpdev__Total_OtherCharges__c', 'sigmaerpdev__Other_Charges_Comments__c','sigmaerpdev__Partner__r.Name', 'sigmaerpdev__Agent_Commission__c','sigmaerpdev__Discount_Value__c','sigmaerpdev__Other_Discount__c', 'sigmaerpdev__Field_Discount_Amount__c','sigmaerpdev__Line_level_Discount__c', 'sigmaerpdev__Client__r.Name','sigmaerpdev__Price__c','sigmaerpdev__Proposal_Date__c','sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__c','sigmaerpdev__Status__c','sigmaerpdev__Location_Level_Discount__c'})
     &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Proposal__c',new set<String>{'sigmaerpdev__Product__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Product__r.sigmaerpdev__Media_Type__c', 'sigmaerpdev__Inventory_Location__r.Name', 'sigmaerpdev__Quantity__c','sigmaerpdev__CPM__c','sigmaerpdev__Monthly_Impression__c','sigmaerpdev__Cost__c','sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__c','sigmaerpdev__Other_Charges_Euro__c','sigmaerpdev__Production_Cost_Euro__c','sigmaerpdev__Production_Cost__c','sigmaerpdev__Media_Cost_Euro__c','sigmaerpdev__Media_Cost__c','sigmaerpdev__AdjustedLineItemTotal__c','sigmaerpdev__OtherCharges__c','sigmaerpdev__Location_Level_Discount__c','sigmaerpdev__Discount__c'})
    &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Proposal_Item__c',new set<String>{ 'id','sigmaerpdev__Cost__c', 'sigmaerpdev__Media_Type__c', 'sigmaerpdev__Quantity__c', 'sigmaerpdev__Location__c', 'sigmaerpdev__Location__r.Name','sigmaerpdev__Location__r.sigmaerpdev__Partner__r.Name','sigmaerpdev__Number_of_Screens__c','sigmaerpdev__Media_Cost__c', 'sigmaerpdev__Media_Cost_Euro__c', 'sigmaerpdev__Production_Cost__c', 'sigmaerpdev__Production_Cost_Euro__c'})
     && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__ProposalLineItemLocation__c', new set<String>{'sigmaerpdev__Cost__c','sigmaerpdev__Production_Cost__c'})
    && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Proposal_Item__c', new set<String>{'sigmaerpdev__Monthly_Traffic__c','sigmaerpdev__Production_Cost__c','sigmaerpdev__Discount__c','sigmaerpdev__OtherCharges__c','sigmaerpdev__AdjustedLineItemTotal__c'})
     && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__ProposalLineItemLocation__c', new set<String>{'id', 'sigmaerpdev__Cost__c', 'sigmaerpdev__Media_Type__c', 'sigmaerpdev__Quantity__c', 'sigmaerpdev__Location__c', 'sigmaerpdev__Location__r.Name','sigmaerpdev__Location__r.sigmaerpdev__Partner__r.Name' })
      &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Proposal__c')
       &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Proposal_Item__c')
       &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__ProposalLineItemLocation__c')
      )  
    {
    String insertedCampaignid = ApexPages.currentPage().getParameters().get('ListId');
    system.debug('insertedCampaignid>>>>>>>>>>>>>'+insertedCampaignid);
    campaigndetails = new Proposal__c();
    Productlistids = new List<String>();
    Marketlistids= new List<String>();
    
    List<Id> PiIdList = new List<id>();
    
    campaigndetails = [select Id,Name, Account_Executive__r.Name,Account_Executive_1_acc__r.Name, Proposal_Name__c, Client__c, Other_Charges__c,Total_OtherCharges__c, Other_Charges_Comments__c,Partner__r.Name, Agent_Commission__c,AVR_Commission__c,Discount_Value__c,Other_Discount__c, Field_Discount_Amount__c,Line_level_Discount__c, Client__r.Name,Price__c,Proposal_Date__c,Start_Date__c,End_Date__c,Status__c,Location_Level_Discount__c,(select Id,Product__r.Name,Product__r.Media_Type__c, Inventory_Location__r.Name, Quantity__c,CPM__c,Monthly_Impression__c,Cost__c,Start_Date__c,End_Date__c from Proposal_Items__r) from Proposal__c where id=:insertedCampaignid];                                        

    String CampaignName;
    String Startdate;
    String Enddate;
    String AE;
    String dma;
    Decimal Totalimpress;
    Decimal Totalcpm;
    Decimal Totaltraffic;
    Decimal TotalCost;
    String PartnerName;
    String AirportName;
    String MarketNAme;
    Decimal avgcpm;
    Integer size;
    Decimal cpmavg;
    Integer units;
    TempProductList = new List<String>();
    countproduct = 0;
    count = 0; 
    
    //Bundle By Product
    productTotalQuantity = 0;
    productTotalCost = 0.0;
   proditemdetails = new List<Proposal_Item__c>();
    
    ProAndMediaTypeList = new Map<Id,String>();
    for(Proposal_Item__c pi : campaigndetails.Proposal_Items__r)
    {
        Productlistids.add(pi.Product__c); 
     
        proditemdetails.add(pi);
        PiIdList.add(pi.id);
        
        productTotalQuantity = productTotalQuantity + Integer.valueOf(pi.Quantity__c);
       productTotalCost = productTotalCost + pi.Cost__c;
       
    }
   completeCampaignList = [select id, Cost__c, Quantity__c, Monthly_Impression__c,Product__r.Name,Product__c,Start_Date__c,End_Date__c,Discount__c,Location_Level_Discount__c, OtherCharges__c, AdjustedLineItemTotal__c,Media_Cost__c,Media_Cost_Euro__c,Production_Cost__c,Production_Cost_Euro__c,Other_Charges_Euro__c, (select id, Cost__c, Monthly_Impressions__c, Media_Type__c, Quantity__c, Location__c, Location__r.Name,Location__r.Partner__r.Name from CampaignLineItemLocations__r) from Proposal_Item__c where Id in:PiIdList];

    if(campaigndetails.Field_Discount_Amount__c != null){
        DiscountedValue = campaigndetails.Other_Discount__c + campaigndetails.Field_Discount_Amount__c + campaigndetails.Line_level_Discount__c + campaigndetails.Location_Level_Discount__c;
    }else{
        DiscountedValue = campaigndetails.Other_Discount__c + campaigndetails.Line_level_Discount__c + campaigndetails.Location_Level_Discount__c;
    }
    
    
    DiscountedCampaignDetailsTotalCost = 0.0;
  
    CampaignDetailsTotalQuantity = 0;
    CampaignDetailsTotalCost = 0.0;
    CampaignDetailsTotalCostForBundleProdCategory = 0.0;
    
    CampaignDetailsTotalProductionCost = 0.00;
    
    agentCommission = 0.00;
     
    for(Proposal_Item__c pi : completeCampaignList)
    {
      
        if(!ProAndMediaTypeList.ContainsKey(pi.Product__c)){
            ProAndMediaTypeList.put(pi.Product__c, 'Not Available');
        }
       
        CampaignDetailsTotalQuantity += Integer.valueOf(pi.Quantity__c);
        CampaignDetailsTotalCost += pi.Cost__c; 
     
        if(pi.Production_Cost__c != null)
        {
            CampaignDetailsTotalProductionCost += pi.Production_Cost__c;
        }
    }
    
 
    otherCharges = campaigndetails.Other_Charges__c;
    if(campaigndetails.Total_OtherCharges__c != null){
        otherCharges += campaigndetails.Total_OtherCharges__c;
    }
    
    otherChargesComments = 'Other Charges Total:';
   
    if(campaigndetails.Partner__r.Name != null){
        otherChargesComments = '';
        otherChargesComments = 'Other Charges for '+campaigndetails.Partner__r.Name + ' :';
    }       
    CampaignDetailsTotalCost += otherCharges;
    CampaignDetailsTotalCostForBundleProdCategory = CampaignDetailsTotalCost - otherCharges;
     if(DiscountedValue > 0.00){
        System.debug('DiscountedValue in If =='+DiscountedValue);
        DiscountedCampaignDetailsTotalCost = (CampaignDetailsTotalCost - DiscountedValue).setScale(2);
    }else if(DiscountedValue < 0.00){ 
        Decimal changeToPositiveValue = 0;
        changeToPositiveValue = DiscountedValue * -1; // done to convert negative discount to positive value.
        DiscountedCampaignDetailsTotalCost = (CampaignDetailsTotalCost + changeToPositiveValue).setScale(2);            
    }
    
    //subtract agent commission from CampaignDetailsTotalCost - modified on 26/5/2017
    if(campaigndetails.Agent_Commission__c != null){
        agentCommission = campaigndetails.Agent_Commission__c;
        if(agentCommission > 0.00){
            if(DiscountedCampaignDetailsTotalCost != 0.0){
                DiscountedCampaignDetailsTotalCost = (DiscountedCampaignDetailsTotalCost - agentCommission).setScale(2);
            }else{
                DiscountedCampaignDetailsTotalCost = (CampaignDetailsTotalCost - agentCommission).setScale(2);
            }                   
        }
    }
  completeCampaignDetails = [select id, Cost__c, CPM__c, Quantity__c,Start_Date__c, End_Date__c, Monthly_Impression__c,Product__r.Name,Product__c,Monthly_Traffic__c,Discount__c,Location_Level_Discount__c,OtherCharges__c,AdjustedLineItemTotal__c,Media_Cost__c,Media_Cost_Euro__c,Production_Cost__c,Production_Cost_Euro__c, (select id, Cost__c, Monthly_Impressions__c, Media_Type__c, Monthly_Traffic__c, CPM__c, Quantity__c, Location__c, Location__r.Code__c, Location__r.Name,Location__r.Partner__r.Name, Location__r.Airport__r.Name,Location__r.Airport__r.Code__c, Location__r.Market__r.Name,Location__r.Market__r.DMA__c,Number_of_Screens__c,Media_Cost__c, Media_Cost_Euro__c, Production_Cost__c, Production_Cost_Euro__c from CampaignLineItemLocations__r Order by Location__r.Market__r.DMA__c ASC) from Proposal_Item__c where Id in:PiIdList];

        for(Proposal_Item__c pi : completeCampaignDetails)
    {
        
        pi.Monthly_Traffic__c = 0;
        for(ProposalLineItemLocation__c clil : pi.CampaignLineItemLocations__r)
        {
          
            clil.Cost__c *= clil.Quantity__c;
           
            if(clil.Production_Cost__c != null)
            {
                clil.Production_Cost__c *= clil.Quantity__c;
            }
            else{
                clil.Production_Cost__c = 0.00;
            }
            
          
        }
      
        if(pi.Production_Cost__c == null)
        {
            pi.Production_Cost__c = 0.00;
        }
        
      
        Decimal adjustedLineItemTotalCost = pi.Cost__c;
        if(pi.Discount__c > 0){             
            adjustedLineItemTotalCost = adjustedLineItemTotalCost - pi.Discount__c;
        }else if(pi.Discount__c < 0){
            Decimal tempDiscount = 0;
            tempDiscount = pi.Discount__c * -1;
            adjustedLineItemTotalCost = adjustedLineItemTotalCost + tempDiscount;
        }
        
        if(pi.Location_Level_Discount__c > 0){              
            adjustedLineItemTotalCost = adjustedLineItemTotalCost - pi.Location_Level_Discount__c;
        }else if(pi.Location_Level_Discount__c < 0){
            Decimal tempLocationDiscount = 0;
            tempLocationDiscount = pi.Location_Level_Discount__c * -1;
            adjustedLineItemTotalCost = adjustedLineItemTotalCost + tempLocationDiscount;
        }
        
        
        if(pi.OtherCharges__c > 0){             
            adjustedLineItemTotalCost = adjustedLineItemTotalCost + pi.OtherCharges__c;
        }
        pi.AdjustedLineItemTotal__c = adjustedLineItemTotalCost;
        //ends here.
    }
    }
  return null;
   // return new Pagereference('/apex/GenerateProposalXLS');
}

    
    
    public String xlsHeader
    {
        get
        {
            String strHeader = '';
            strHeader += '<?xml version="1.0"?>';
            strHeader += '<?mso-application progid="Excel.Sheet"?>';
            return strHeader;
        }
      }
    
  public PageReference generatepdfreport() 
{ 
    if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Proposal__c',new set<String>{'Id','Name', 'sigmaerpdev__Account_Executive__r.Name','sigmaerpdev__Account_Executive_1_acc__r.Name', 'sigmaerpdev__Proposal_Name__c', 'sigmaerpdev__Client__c', 'sigmaerpdev__Other_Charges__c','sigmaerpdev__Total_OtherCharges__c', 'sigmaerpdev__Other_Charges_Comments__c','sigmaerpdev__Partner__r.Name', 'sigmaerpdev__Agent_Commission__c','sigmaerpdev__Discount_Value__c','sigmaerpdev__Other_Discount__c', 'sigmaerpdev__Field_Discount_Amount__c','sigmaerpdev__Line_level_Discount__c', 'sigmaerpdev__Client__r.Name','sigmaerpdev__Price__c','sigmaerpdev__Proposal_Date__c','sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__c','sigmaerpdev__Status__c','sigmaerpdev__Location_Level_Discount__c'})
     &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Proposal__c',new set<String>{'sigmaerpdev__Usage_Type__c','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Product__r.sigmaerpdev__Media_Type__c', 'sigmaerpdev__Inventory_Location__r.Name', 'sigmaerpdev__Quantity__c','sigmaerpdev__CPM__c','sigmaerpdev__Monthly_Impression__c','sigmaerpdev__Cost__c','sigmaerpdev__Start_Date__c','sigmaerpdev__End_Date__c','sigmaerpdev__Other_Charges_Euro__c','sigmaerpdev__Production_Cost_Euro__c','sigmaerpdev__Production_Cost__c','sigmaerpdev__Media_Cost_Euro__c','sigmaerpdev__Media_Cost__c','sigmaerpdev__AdjustedLineItemTotal__c','sigmaerpdev__OtherCharges__c','sigmaerpdev__Location_Level_Discount__c','sigmaerpdev__Discount__c'})
    &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Proposal_Item__c',new set<String>{ 'id','sigmaerpdev__Cost__c', 'sigmaerpdev__Media_Type__c', 'sigmaerpdev__Quantity__c', 'sigmaerpdev__Location__c', 'sigmaerpdev__Location__r.Name','sigmaerpdev__Location__r.sigmaerpdev__Partner__r.Name','sigmaerpdev__Number_of_Screens__c','sigmaerpdev__Media_Cost__c', 'sigmaerpdev__Media_Cost_Euro__c', 'sigmaerpdev__Production_Cost__c', 'sigmaerpdev__Production_Cost_Euro__c'})
     && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__ProposalLineItemLocation__c', new set<String>{'sigmaerpdev__Cost__c','sigmaerpdev__Production_Cost__c'})
    && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Proposal_Item__c', new set<String>{'sigmaerpdev__Monthly_Traffic__c','sigmaerpdev__Production_Cost__c','sigmaerpdev__Discount__c','sigmaerpdev__OtherCharges__c','sigmaerpdev__AdjustedLineItemTotal__c'})
      && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__ProposalLineItemLocation__c', new set<String>{'id', 'sigmaerpdev__Cost__c', 'sigmaerpdev__Media_Type__c', 'sigmaerpdev__Quantity__c', 'sigmaerpdev__Location__c', 'sigmaerpdev__Location__r.Name','sigmaerpdev__Location__r.sigmaerpdev__Partner__r.Name' })
     &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Proposal__c')
       &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Proposal_Item__c')
       &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__ProposalLineItemLocation__c')
      )    
    {
   // insertedCampaignid = selectedCampaignId;
   // 
    System.debug('inside generatereport>>>>>>>>');
    insertedCampaignid = selectedCampaignId;
    String insertedCampaignid = ApexPages.currentPage().getParameters().get('ListId');
    system.debug('insertedCampaignid>>>>>>>>>>>>>'+insertedCampaignid);
    campaigndetails = new Proposal__c();
    Productlistids = new List<String>();
    Marketlistids= new List<String>();
    
    List<Id> PiIdList = new List<id>();
    
    campaigndetails = [select Id,Name, Account_Executive__r.Name,Account_Executive_1_acc__r.Name,Usage_Type__c, Proposal_Name__c, Client__c, Other_Charges__c,Total_OtherCharges__c, Other_Charges_Comments__c,Partner__r.Name, Agent_Commission__c,Discount_Value__c,Other_Discount__c, Field_Discount_Amount__c,Line_level_Discount__c, Client__r.Name,Price__c,Proposal_Date__c,Start_Date__c,End_Date__c,Status__c,Location_Level_Discount__c,(select Id,Product__r.Name,Product__r.Media_Type__c, Inventory_Location__r.Name, Quantity__c,CPM__c,Monthly_Impression__c,Cost__c,Start_Date__c,End_Date__c from Proposal_Items__r) from Proposal__c where id=:insertedCampaignid];                                        
    
    String CampaignName;
    String Startdate;
    String Enddate;
    String AE;
    String dma;
    Decimal Totalimpress;
    Decimal Totalcpm;
    Decimal Totaltraffic;
    Decimal TotalCost;
    String PartnerName;
    String AirportName;
    String MarketNAme;
    Decimal avgcpm;
    Integer size;
    Decimal cpmavg;
    Integer units;
    TempProductList = new List<String>();
    countproduct = 0;
    count = 0; 
    
    //Bundle By Product
    productTotalQuantity = 0;
   productTotalCost = 0.0;
    proditemdetails = new List<Proposal_Item__c>();
    
    ProAndMediaTypeList = new Map<Id,String>();
    for(Proposal_Item__c pi : campaigndetails.Proposal_Items__r)
    {
        Productlistids.add(pi.Product__c); 
      
        proditemdetails.add(pi);
        PiIdList.add(pi.id);
        
        productTotalQuantity = productTotalQuantity + Integer.valueOf(pi.Quantity__c);
      
        productTotalCost = productTotalCost + pi.Cost__c;
        //
    }
    completeCampaignList = [select id, Cost__c, Quantity__c,Product__r.Name,Product__c,Start_Date__c,End_Date__c,Discount__c,Location_Level_Discount__c, OtherCharges__c, AdjustedLineItemTotal__c,Media_Cost__c,Media_Cost_Euro__c,Production_Cost__c,Production_Cost_Euro__c,Other_Charges_Euro__c,Location__r.Name, (select id, Cost__c, Media_Type__c, Quantity__c, Location__c, Location__r.Name,Location__r.Partner__r.Name from CampaignLineItemLocations__r) from Proposal_Item__c where Id in:PiIdList];
    
   if(campaigndetails.Field_Discount_Amount__c != null){
        DiscountedValue = campaigndetails.Other_Discount__c + campaigndetails.Field_Discount_Amount__c + campaigndetails.Line_level_Discount__c + campaigndetails.Location_Level_Discount__c;
    }else{
        DiscountedValue = campaigndetails.Other_Discount__c + campaigndetails.Line_level_Discount__c + campaigndetails.Location_Level_Discount__c;
    }
    
    
    DiscountedCampaignDetailsTotalCost = 0.0;
    CampaignDetailsTotalQuantity = 0;
    CampaignDetailsTotalCost = 0.0;
    CampaignDetailsTotalCostForBundleProdCategory = 0.0;
    CampaignDetailsTotalProductionCost = 0.00;
    agentCommission = 0.00;
 
    for(Proposal_Item__c pi : completeCampaignList)
    {
     
        //For Bundle by product media Type
        if(!ProAndMediaTypeList.ContainsKey(pi.Product__c)){
            ProAndMediaTypeList.put(pi.Product__c, 'Not Available');
        }
        //Till here
        
        CampaignDetailsTotalQuantity += Integer.valueOf(pi.Quantity__c);
        CampaignDetailsTotalCost += pi.Cost__c; 
      
        if(pi.Production_Cost__c != null)
        {
            CampaignDetailsTotalProductionCost += pi.Production_Cost__c;
        }
    }
    
   
    otherCharges = campaigndetails.Other_Charges__c;
    if(campaigndetails.Total_OtherCharges__c != null){
        otherCharges += campaigndetails.Total_OtherCharges__c;
    }
    
    otherChargesComments = 'Other Charges Total:';
   
    if(campaigndetails.Partner__r.Name != null){
        otherChargesComments = '';
        otherChargesComments = 'Other Charges for '+campaigndetails.Partner__r.Name + ' :';
    }       
    CampaignDetailsTotalCost += otherCharges;
    CampaignDetailsTotalCostForBundleProdCategory = CampaignDetailsTotalCost - otherCharges;
   if(DiscountedValue >= 0.00){
        System.debug('DiscountedValue in If =='+DiscountedValue);
        DiscountedCampaignDetailsTotalCost = (CampaignDetailsTotalCost - DiscountedValue).setScale(2);
    }else if(DiscountedValue < 0.00){ 
        Decimal changeToPositiveValue = 0;
        changeToPositiveValue = DiscountedValue * -1; // done to convert negative discount to positive value.
        DiscountedCampaignDetailsTotalCost = (CampaignDetailsTotalCost + changeToPositiveValue).setScale(2);            
    }
    
    //subtract agent commission from CampaignDetailsTotalCost - modified on 26/5/2017
    if(campaigndetails.Agent_Commission__c != null){
        agentCommission = campaigndetails.Agent_Commission__c;
        if(agentCommission >= 0.00){
            if(DiscountedCampaignDetailsTotalCost != 0.0){
                DiscountedCampaignDetailsTotalCost = (DiscountedCampaignDetailsTotalCost - agentCommission).setScale(2);
            }else{
                DiscountedCampaignDetailsTotalCost = (CampaignDetailsTotalCost - agentCommission).setScale(2);
            }                   
        }
    }
    
   
    //Bundle by Campaign Details
     completeCampaignDetails = [select id, Cost__c,Location__r.Name, Quantity__c,Start_Date__c, End_Date__c,Product__r.Name,Product__c,Discount__c,Location_Level_Discount__c,OtherCharges__c,AdjustedLineItemTotal__c,Media_Cost__c,Media_Cost_Euro__c,Production_Cost__c,Production_Cost_Euro__c, (select id, Cost__c, Quantity__c, Location__c, Location__r.Code__c, Location__r.Name,Location__r.Partner__r.Name,Number_of_Screens__c,Media_Cost__c, Media_Cost_Euro__c, Production_Cost__c, Production_Cost_Euro__c from CampaignLineItemLocations__r) from Proposal_Item__c where Id in:PiIdList];
   
    for(Proposal_Item__c pi : completeCampaignDetails)
    {
        
        pi.Monthly_Traffic__c = 0;
        for(ProposalLineItemLocation__c clil : pi.CampaignLineItemLocations__r)
        {
            
    
            clil.Cost__c *= clil.Quantity__c;
          
            if(clil.Production_Cost__c != null)
            {
                clil.Production_Cost__c *= clil.Quantity__c;
            }
            else{
                clil.Production_Cost__c = 0.00;
            }
            
           
        }
      
        if(pi.Production_Cost__c == null)
        {
            pi.Production_Cost__c = 0.00;
        }
     
        //code added to sum up individual line items (adjusted values) - 2/Mar/2017
        Decimal adjustedLineItemTotalCost = pi.Cost__c;
        if(pi.Discount__c > 0){             
            adjustedLineItemTotalCost = adjustedLineItemTotalCost - pi.Discount__c;
        }else if(pi.Discount__c < 0){
            Decimal tempDiscount = 0;
            tempDiscount = pi.Discount__c * -1;
            adjustedLineItemTotalCost = adjustedLineItemTotalCost + tempDiscount;
        }
        
        if(pi.Location_Level_Discount__c > 0){              
            adjustedLineItemTotalCost = adjustedLineItemTotalCost - pi.Location_Level_Discount__c;
        }else if(pi.Location_Level_Discount__c < 0){
            Decimal tempLocationDiscount = 0;
            tempLocationDiscount = pi.Location_Level_Discount__c * -1;
            adjustedLineItemTotalCost = adjustedLineItemTotalCost + tempLocationDiscount;
        }
        
        
        if(pi.OtherCharges__c > 0){             
            adjustedLineItemTotalCost = adjustedLineItemTotalCost + pi.OtherCharges__c;
        }
        pi.AdjustedLineItemTotal__c = adjustedLineItemTotalCost;
        //ends here.
    }
    //Till here
    }
    //ends here
    return null;
   // return new Pagereference('/apex/GenerateProposalPDF');
}  

    
}