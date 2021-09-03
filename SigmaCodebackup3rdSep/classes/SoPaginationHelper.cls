/*=====================================================================================================
Author   : Samad , Sandhya
Company  : Mindlinks Solution Pvt Ltd.
Class    : SoPaginationHelper
Date     : 21/8/2018              
=======================================================================================================*/
public with sharing class SoPaginationHelper {
    
    @AuraEnabled
    public Integer pageSize { get;set; }
    
    @AuraEnabled
    public Integer page { get;set; }
    
    @AuraEnabled
    public Integer total { get;set; }
    
    @AuraEnabled
    public List<Inventory__c> soList { get;set; }
    
    // code used for SigmaOrderHandler , added by sandhya,20/8/2018
    @AuraEnabled
    public Integer pageSizeSigma { get;set; }
    
    @AuraEnabled
    public Integer pageSigma { get;set; }
    
    @AuraEnabled
    public Integer totalSigma { get;set; }
    
    @AuraEnabled
    public List<Sigma_Order__c> sigmaList { get;set; }
    
     @AuraEnabled
     public List<Purchase_Order__c> purchaselist{ get;set; }
    
    @AuraEnabled
     public List<Stock_In__c> stockList{ get;set; }
    
    // code used for OrderHandler , added by sandhya,21/8/2018
    @AuraEnabled
    public Integer pageSizeOrder { get;set; }
    
    @AuraEnabled
    public Integer pageOrder { get;set; }
    
    @AuraEnabled
    public Integer totalOrder { get;set; }
    
    @AuraEnabled
    public List<Order> OrderList { get;set; }
    
    
    // code used for Inventory Location , added by sandhya,27/8/2018
    @AuraEnabled
    public Integer pageSizeIL { get;set; }
    
    @AuraEnabled
    public Integer pageIL { get;set; }
    
    @AuraEnabled
    public Integer totalIL { get;set; }
    
    @AuraEnabled
    public List<Inventory_Location__c> ILList { get;set; }
    
    // code used for ProposalHandling , added by sandhya,28/8/2018
    @AuraEnabled
    public Integer pageSizeProp { get;set; }
    
    @AuraEnabled
    public Integer pageProp { get;set; }
    
    @AuraEnabled
    public Integer totalProp { get;set; }
    
    @AuraEnabled
    public List<Proposal__c> PropList { get;set; }
    
     @AuraEnabled
    public boolean IsCommunityUser { get;set; }
}