public with sharing class PaginationHelper 
{
    @AuraEnabled
    public Integer pageSize { get;set; }
    @AuraEnabled
    public Integer page { get;set; }
    @AuraEnabled
    public Integer total { get;set; }
    @AuraEnabled
    public List<POWrapper> PoWrapperList { get;set; }
    @AuraEnabled
    public List<Account> accList { get;set; }
    public class POWrapper
    {
        @AuraEnabled
        public Boolean isSelected { get;set; }
        @AuraEnabled
        public String POName { get;set; }
        @AuraEnabled
        public Id POId { get;set; }
        @AuraEnabled
        public String VendorName { get;set; }
        @AuraEnabled
        public Id VendorId { get;set; }
        @AuraEnabled
        public Date orderDate { get;set; }
        @AuraEnabled
        public DateTime  expectedDate { get;set; }
        @AuraEnabled
        public String Status { get;set; }
        @AuraEnabled
        public String vendorStatus { get;set; }
        @AuraEnabled
        public Date expectedShippedDate { get;set; }
        @AuraEnabled
        public Date expectedDeleveryDate { get;set; }
        @AuraEnabled
        public Boolean isDefaultShippedDate { get;set; }
        @AuraEnabled
        public Boolean isDefaultDeleveryDate { get;set; }
        @AuraEnabled
        public List<POPWrapper> popWrapperList { get;set; }  
    }
    public class POPWrapper
    {
        @AuraEnabled
        public String POPName { get;set; }
        @AuraEnabled
        public Id POPId { get;set; }
        @AuraEnabled
        public Id ProductId { get;set; }
        @AuraEnabled
        public String ProductName { get;set; }
        @AuraEnabled
        public Decimal Quantity { get;set; }
        @AuraEnabled
        public Date ExpectedDeliveryDate { get;set; }
        @AuraEnabled
        public String Status { get;set; }  
        @AuraEnabled
        public String Descripton { get;set; } 
        @AuraEnabled
        public Decimal discount { get;set; } 
        @AuraEnabled
        public Decimal totalAmount { get;set; } 
        @AuraEnabled
        public Decimal NetBuyingPrice { get;set; } 
        @AuraEnabled
        public Decimal RemainingQuantity { get;set; } 
        @AuraEnabled
        public Decimal DeleveredQuantity { get;set; } 
        @AuraEnabled
        public Decimal remainingDispatchedQuantity { get;set; }
        @AuraEnabled
        public String Reason { get;set; } 
        @AuraEnabled
        public String vendorStatus { get;set; }
        @AuraEnabled
        public String vendorOldStatus { get;set; }
        @AuraEnabled
        public String oldStatus { get;set; }
        @AuraEnabled
        public Date vendorExpectedShippedDate { get;set; }
        @AuraEnabled
        public Date vendorExpectedDeleveryDate { get;set; }
        @AuraEnabled
        public Decimal recentDispatchedQuantity { get;set; }
        @AuraEnabled
        public String shipmentNotes { get;set; } 
        @AuraEnabled
        public String shipmentTrackingUrl { get;set; } 
    }
}