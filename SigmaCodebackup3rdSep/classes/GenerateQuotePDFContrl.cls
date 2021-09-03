public with sharing class GenerateQuotePDFContrl {
    public static List<Service_Quote_Line_Item__c> PropLineItem{get; set;}
    public static Default_Parameters__c defaultparam{get;set;}
  public static Service_Quote_Payment_Terms__c servicequotepaymentterms{get;set;}
    public String orderId;
    public decimal lineItemsTotal{get;set;}
    public decimal SLNo{get;set;}
    public String dt {get;set;}
   public String servicequotename {get;set;}
    
  
  
    public GenerateQuotePDFContrl(ApexPages.StandardController controller) 
    {   
        orderId = System.currentPageReference().getParameters().get('id');
       // this.getdefaultparameter();
        this.PropLineItemMethod();
    this.servicepaymentterms();
       
    }
    public pagereference PropLineItemMethod()
  {
        lineItemsTotal = 0;
       // SLNo = 0;
        Date d = date.today();
        dt = DateTime.newInstance(d.year(),d.month(),d.day()).format('dd-MM-YYYY');
        
    if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Service_Quote_Line_Item__c')
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Service_Quote_Line_Item__c',new set<String>{'id','Name','sigmaerpdev2__Service_Quote__c','sigmaerpdev2__Service_Quote__r.Name','sigmaerpdev2__Service_Contract__c','sigmaerpdev2__Service_Contract__r.Name','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product__r.name','sigmaerpdev2__Price__c','sigmaerpdev2__Unit_Price__c'})
    && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Service_Quote_Line_Item__c',new set<String>{'sigmaerpdev2__Service_Quote__c'}))
    
    {
      PropLineItem = [select id,Name,Service_Quote__c,Service_Quote__r.Name,Service_Contract__c,Service_Contract__r.Name,Quantity__c,Product__c,Product__r.name,Price__c,Unit_Price__c from Service_Quote_Line_Item__c where Service_Quote__c =: orderId];
      for(Service_Quote_Line_Item__c SCLI : PropLineItem )
            {
                lineItemsTotal = lineItemsTotal+SCLI.Price__c;
                servicequotename =SCLI.Service_Quote__r.Name; 
            }
            
         }
       return null;
    }
    
    public static Default_Parameters__c getdefaultparameter()
    {
    if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Default_Parameters__c')
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Default_Parameters__c',new set<String>{'sigmaerpdev2__Company_Name__c','sigmaerpdev2__Company_Email__c','sigmaerpdev2__Company_Phone__c','sigmaerpdev2__Logo__c'})
    )
    {
      defaultparam = [SELECT Company_Name__c,Company_Email__c,Company_Phone__c,Logo__c from Default_Parameters__c Limit 1];
      
    }
        return defaultparam;
    }
  
   public pagereference  servicepaymentterms()
    {
    if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Service_Quote_Payment_Terms__c')
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Service_Quote_Payment_Terms__c',new set<String>{'sigmaerpdev2__Payment_Terms_1__c','sigmaerpdev2__Payment_Terms_2__c','sigmaerpdev2__Payment_Terms_3__c'})
    )
    {
      servicequotepaymentterms = [SELECT Payment_Terms_1__c,Payment_Terms_2__c,Payment_Terms_3__c from Service_Quote_Payment_Terms__c Limit 1];
    }
        return null;
    }
  
}