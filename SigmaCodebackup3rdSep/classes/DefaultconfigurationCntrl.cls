/*=========================================================
Created by Sandhya,25-06-2018 for Stripe API Custom Setting
============================================================*/
public with sharing Class DefaultconfigurationCntrl 
{    
    public Boolean displayCheckBox{get;set;}
    public Boolean checkboxValue{get;set;}
    public Default_Parameters__c dpSettings {get;set;}
    public Setup_Conversion_Rate_Euro__c SCRE {get;set;}
    public Order_API__c OrdeAPISettings {get;set;}
    public Order_Usage__c OrderUsageSettings {get;set;}
    public Time_Base_Inventory__c Timebased {get;set;}
    public String selectedValue { get; set; }
    public String OrderUSage{ get; set; }
     public String OrderUSage1{ get; set; }
    public String TBIValue{ get; set; }
    public boolean OrderAPIFlag = false;
    public boolean OrderUsageFlag = false;
    public boolean TBIFlag = false;
   
   public DefaultconfigurationCntrl()
    {  
    if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Time_Base_Inventory__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Default_Parameters__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Setup_Conversion_Rate_Euro__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Order_API__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Order_Usage__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Time_Base_Inventory__c',new Set<String>{'Id','Name','sigmaerpdev2__Order__c','sigmaerpdev2__Proposal__c','sigmaerpdev2__Proposal_for_Products__c','sigmaerpdev2__Proposal_to_Order__c'}) 
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Default_Parameters__c',new Set<String>{'Id','Name','sigmaerpdev2__Currency__c','sigmaerpdev2__Default_Location__c','sigmaerpdev2__EmailImage__c','sigmaerpdev2__Inventory_Status__c','sigmaerpdev2__Invoice_Doc_Id__c','sigmaerpdev2__Logo__c','sigmaerpdev2__Package_ID__c','sigmaerpdev2__Parent_Id__c','sigmaerpdev2__POId__c','sigmaerpdev2__priceBook_for_orders__c','sigmaerpdev2__Shipment_ID__c','sigmaerpdev2__Stock_Moment__c','sigmaerpdev2__StockReceiving_ID__c','sigmaerpdev2__Company_Email__c','sigmaerpdev2__Company_Name__c','sigmaerpdev2__Company_Phone__c','sigmaerpdev2__ShowDispatchedQuantityInStockReceivingUI__c'})            
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Setup_Conversion_Rate_Euro__c',new Set<String>{'Id','Name','sigmaerpdev2__Conversion_Rate__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Order_API__c',new set<String>{'Id','Name','sigmaerpdev2__Subscription_Product__c','sigmaerpdev2__Subscription_Renewal__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Order_Usage__c',new set<String>{'Id','Name','sigmaerpdev2__Sigma_order__c','sigmaerpdev2__Standard_object__c','sigmaerpdev2__Allocation_in_Picking__c','sigmaerpdev2__Allocation_in_Sales_Order__c','sigmaerpdev2__Auto_Allocate_in_picking__c'})
        ){     
        Map<string,Default_Parameters__c> dpMap = Default_Parameters__c.getAll();
        Map<string,Setup_Conversion_Rate_Euro__c> SCREMap = Setup_Conversion_Rate_Euro__c.getAll();
        Map<string,Order_API__c> OrdeAPIMap = Order_API__c.getAll();
        Map<string,Time_Base_Inventory__c> TimeBasedMap = Time_Base_Inventory__c.getAll();
        Map<string,Order_Usage__c> OrderUsageMap = Order_Usage__c.getAll();
        
        if(!(dpMap.containsKey('Elift Merchant')))
        {    
            dpSettings = new Default_Parameters__c();
            
            dpSettings.Name = 'Elift Merchant';
            
            
        }else
        {
            dpSettings =  Default_Parameters__c.getValues('Elift Merchant');
            
        }
        
        if(!(SCREMap.containsKey('SetEuro')))
        {    
            SCRE = new Setup_Conversion_Rate_Euro__c();          
            SCRE.Name = 'SetEuro';
            
            
        }else
        {
            SCRE =  Setup_Conversion_Rate_Euro__c.getValues('SetEuro');
            
        }
        
        if(!(OrdeAPIMap.containsKey('Order API'))){           
            OrdeAPISettings = new Order_API__c();          
            OrdeAPISettings.Name = 'Order API';
        }
        else{
            OrdeAPISettings =  Order_API__c.getValues('Order API');
            if(OrdeAPISettings.Subscription_Product__c==true){            
                selectedValue = 'Subscription Product';
            }
            else if(OrdeAPISettings.Subscription_Renewal__c==true){            
                selectedValue = 'Subscription Renewal';
            }
            else{
                selectedValue = '--None--';
            }
            
        }
        
        if(!(OrderUsageMap.containsKey('Order Usage')) )
        { 
            OrderUsageSettings = new Order_Usage__c();
            OrderUsageSettings.Name = 'Order Usage';
            
        }
        else{        
            
            OrderUsageSettings =  Order_Usage__c.getValues('Order Usage'); 
            if(OrderUsageSettings.Sigma_order__c==true)
            {
                OrderUSage = 'Sigma Order';
            }
            else if(OrderUsageSettings.Standard_object__c==true)
            {
                OrderUSage = 'Order';
            }
            else
            {
                OrderUSage = '--None--';
            }
        }
         
        
        //===================TBI============================
        if(!(TimeBasedMap.containsKey('TBI')) )
        { 
            Timebased = new Time_Base_Inventory__c();
            Timebased.Name = 'TBI';
            
        }else
        {
            
            Timebased =  Time_Base_Inventory__c.getValues('TBI'); 
            if(Timebased.Order__c)
            {
                TBIValue = 'Sales Order TBI';
            }
            else if(Timebased.Proposal__c)
            {
                TBIValue = 'Proposal';
            }
             else if(Timebased.Proposal_for_Products__c)
            {
                TBIValue = 'Proposal for Products';
            }
             else if(Timebased.Proposal_to_Order__c)
            {
                TBIValue = 'Proposal for Order';
            }
            else 
            {
                TBIValue = '--None--';
            }
            
        }
        //=================Ends Here======================
                }
        
    }     
  
    public pagereference saveConfig1(){
       if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Time_Base_Inventory__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Default_Parameters__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Setup_Conversion_Rate_Euro__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Order_API__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Order_Usage__c')
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Time_Base_Inventory__c',new Set<String>{'sigmaerpdev2__Order__c','sigmaerpdev2__Proposal__c','sigmaerpdev2__Proposal_for_Products__c','sigmaerpdev2__Proposal_to_Order__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Default_Parameters__c',new Set<String>{'Name','sigmaerpdev2__Default_Vendor__c','sigmaerpdev2__Vendor_Rating__c','sigmaerpdev2__ShowDispatchedQuantityInStockReceivingUI__c'})   
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Setup_Conversion_Rate_Euro__c',new Set<String>{'Name','sigmaerpdev2__Conversion_Rate__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Order_API__c',new set<String>{'sigmaerpdev2__Subscription_Product__c','sigmaerpdev2__Subscription_Renewal__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Order_Usage__c',new set<String>{'sigmaerpdev2__Sigma_order__c','sigmaerpdev2__Standard_object__c'})

       ){
        
        try{
            
            if(dpSettings.Default_Vendor__c==true && dpSettings.Vendor_Rating__c==true)
            {
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select either Create AutoPO Based On Default Vendor or Create AutoPO Based On Vendor Rating checkbox'));
                 return null;
            }
            
            
            if(dpSettings != null){ 
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Record Created'));   
                upsert dpSettings; 
            }
            if(SCRE != null){
                upsert SCRE;
            }
            
            if(selectedValue == 'Subscription Product'){                
                OrdeAPISettings.Subscription_Product__c = true;
                OrdeAPISettings.Subscription_Renewal__c = false;
            }
            else if(selectedValue == 'Subscription Renewal'){
                OrdeAPISettings.Subscription_Product__c = false;
                OrdeAPISettings.Subscription_Renewal__c = true;
            }
            else{
                OrdeAPISettings.Subscription_Product__c = false;
                OrdeAPISettings.Subscription_Renewal__c = false;
            }
            
            if(OrdeAPISettings != null ){
                upsert OrdeAPISettings;
            }  
            
            if(OrderUSage == 'Sigma Order'){
                OrderUsageSettings.Sigma_order__c = true;
                OrderUsageSettings.Standard_object__c = false;
            }
            else if(OrderUSage == 'Order'){
                OrderUsageSettings.Sigma_order__c = false;
                OrderUsageSettings.Standard_object__c = true;
            }
            
            //upserting
            if(OrderUsageSettings != null){
                upsert OrderUsageSettings;
            }
            
            //upserting
            if(OrderUsageSettings != null){
                upsert OrderUsageSettings;
            }
            
            //=====================TBI============================
            System.debug('Timebased:::'+Timebased);
                if(TBIValue=='Sales Order TBI')
                {
                    System.debug('TBIValueIffffffffffffff');
                    Timebased.Order__c = true;
                    Timebased.Proposal__c = false;
                    Timebased.Proposal_for_Products__c = false;
                    Timebased.Proposal_to_Order__c = false;
                }
                else if(TBIValue=='Proposal')
                {
                    System.debug('TBIValue Proposal');
                    Timebased.Order__c = false;
                    Timebased.Proposal__c = true;
                    Timebased.Proposal_for_Products__c = false;
                    Timebased.Proposal_to_Order__c = false;
                }
                else if(TBIValue=='Proposal for Products')
                {
                    System.debug('TBIValue Proposal For Products');
                    Timebased.Order__c = false;
                    Timebased.Proposal__c = false;
                    Timebased.Proposal_for_Products__c = true;
                    Timebased.Proposal_to_Order__c = false;
                }
                else if(TBIValue=='Proposal for Order')
                {
                    System.debug('TBIValue Proposal To Order');
                    Timebased.Order__c = false;
                    Timebased.Proposal__c = false;
                    Timebased.Proposal_for_Products__c = false;
                    Timebased.Proposal_to_Order__c = true;
                }
            else
                {
                    System.debug('TBIValue Proposal To Order');
                    Timebased.Order__c = false;
                    Timebased.Proposal__c = false;
                    Timebased.Proposal_for_Products__c = false;
                    Timebased.Proposal_to_Order__c = false;
                }
                
                if(Timebased != null)
            {    
                    upsert Timebased;
            }
            
        }
        catch(Exception e){  
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
            return null;
        }
        
        
        } 
       
        return null;
        
    }
    
    public Pagereference cancelConfig()
    {
      
        return null;
    }
    
}