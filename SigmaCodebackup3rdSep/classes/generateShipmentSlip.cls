public with sharing class generateShipmentSlip
{
        public List<Shipment__c> masterShipment{get;set;} 
        public String shipmentId {get;set;}
        Public List<Shipment_Products__c> shipmentProductData{get; set;}
        public Decimal TotalQuantity{get;set;}
        public set<String> packageID = new set<String>();
        public List<Shipment_Products__c> getDetails = new List<Shipment_Products__c>();
        public Map<String,List<Shipment_Products__c>>  packageDetails{get;set;}
        public Map<String,Set<String>>  packageDetails2{get;set;}
        
        //Added
       public List<PackagedProducts__c> Pkegedproducts{get;set;}
        public List<Shipment_Products__c> productlist{get;set;} 
        public Set<String> productlist2{get;set;}

    public generateShipmentSlip(ApexPages.StandardController controller) 
    {
            if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Shipment__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Shipment_Products__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Package__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__PackagedProducts__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Shipment__c',new set<String>{'Id','Name','sigmaerpdev2__Delivery_Person__r.Name','sigmaerpdev2__Account__r.Name','sigmaerpdev2__Truck_No__c','sigmaerpdev2__Shipment_Date__c','sigmaerpdev2__Status__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Shipment_Products__c',new set<String>{'Id','sigmaerpdev2__Order_Product__r.Name','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__Total_Quantity__c','sigmaerpdev2__Status__c','sigmaerpdev2__Shipment_Delivery_Date__c','sigmaerpdev2__Price__c','sigmaerpdev2__Orderd_Quantity__c','sigmaerpdev2__Package_ID__c','sigmaerpdev2__Package_ID__r.Name','sigmaerpdev2__Customer_Name__r.sigmaerpdev2__Email__c','sigmaerpdev2__Customer_Name__r.Name','sigmaerpdev2__Customer_Name__r.BillingCountry','sigmaerpdev2__Customer_Name__r.BillingState','sigmaerpdev2__Customer_Name__r.BillingCity','sigmaerpdev2__Customer_Name__r.BillingStreet','sigmaerpdev2__Customer_Name__r.sigmaerpdev2__Zip__c','sigmaerpdev2__Shipment__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Package__c',new Set<String>{'Id', 'Name'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__PackagedProducts__c',new Set<String>{'Id','Name','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Quantity__c','sigmaerpdev2__Package__r.Name','sigmaerpdev2__Package__c'})
            )
            {
           
             shipmentId = System.currentPageReference().getParameters().get('Id');
              packageDetails =new  Map<String,List<Shipment_Products__c>>();
              packageDetails2 =new Map<String,Set<String>>();
               if(checkAccessPermissionsShipment() == true){
                  masterShipment=[Select  Id,Name,Delivery_Person__r.Name,Account__r.Name,
                               Truck_No__c,Shipment_Date__c,Status__c
                               from Shipment__c where Id=:shipmentId];
              }
             if(checkAccessPermissionsShipmentProducts() == true){
                 shipmentProductData =[Select Id,Order_Product__r.Name,Sigma_Order__c,Total_Quantity__c,Status__c,
                                    Shipment_Delivery_Date__c,
                                    Price__c,Orderd_Quantity__c,Package_ID__c,
                                    Package_ID__r.Name,
                                   Customer_Name__r.Email__c,Customer_Name__r.Name,
                                    Customer_Name__r.BillingCountry,Customer_Name__r.BillingState,
                                    Customer_Name__r.BillingCity,
                                    Customer_Name__r.BillingStreet,Customer_Name__r.Zip__c  from Shipment_Products__c WHERE Shipment__c=:shipmentId];
            }
            for(Shipment_Products__c ss : shipmentProductData ){  
            system.debug('ss.Package_ID__c]::' + ss.Package_ID__c) ;
         
            }  
            //Added
              Account Accid= shipmentProductData[0].Customer_Name__r;
              TotalQuantity=0;
          
                for(Shipment_Products__c sp:shipmentProductData )
                { 
                    
                   packageID.add(sp.Package_ID__C);
                   if(sp.Total_Quantity__c!=NULL)
                    {
                        TotalQuantity+=sp.Total_Quantity__c;
                    }
                    else
                    {
                           TotalQuantity=0;
                    }
                   
                }
          
                set<Id> pkid = new set<Id>();
                List<Package__c> Pkg;
                if(checkAccessPermissionsPackage() == true){
                    Pkg =[select Id, Name from Package__c where id=:packageID];
                }                
                for(Package__c p : Pkg ){
                   pkid.add(p.Id);
                }
              if(checkAccessPermissionsPackagedProducts() == true){
                  Pkegedproducts= [SELECT Id,Name,Product__r.Name,Quantity__c,Package__r.Name FROM PackagedProducts__c WHERE Package__c IN:pkid ];
              }
            
                        for(PackagedProducts__c  PkProd: Pkegedproducts)
                     {
                  TotalQuantity+=PkProd.Quantity__c ;
                     }
               
                }
    }
    
    
    /*
     * FLS Check
     */
     public Static boolean checkAccessPermissionsShipment(){
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Shipment__c',new Set<String>{'Id','Name','sigmaerpdev2__Delivery_Person__r.Name','sigmaerpdev2__Account__r.Name','sigmaerpdev2__Truck_No__c','sigmaerpdev2__Shipment_Date__c','sigmaerpdev2__Status__c'}))
        {
           return true;
        }  
        return false;
     }

      public Static boolean checkAccessPermissionsShipmentProducts(){
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Shipment_Products__c',new Set<String>{'Id','sigmaerpdev2__Order_Product__r.Name','sigmaerpdev2__Sigma_Order__c','sigmaerpdev2__Total_Quantity__c','sigmaerpdev2__Status__c','sigmaerpdev2__Shipment_Delivery_Date__c','sigmaerpdev2__Price__c','sigmaerpdev2__Orderd_Quantity__c','sigmaerpdev2__Package_ID__c','sigmaerpdev2__Package_ID__r.Name','sigmaerpdev2__Customer_Name__r.sigmaerpdev2__Email__c','sigmaerpdev2__Customer_Name__r.Name','sigmaerpdev2__Customer_Name__r.BillingCountry','sigmaerpdev2__Customer_Name__r.BillingState','sigmaerpdev2__Customer_Name__r.BillingCity','sigmaerpdev2__Customer_Name__r.BillingStreet','sigmaerpdev2__Customer_Name__r.sigmaerpdev2__Zip__c' }))
        {
           return true;
        }  
        return false;
     }

     public Static boolean checkAccessPermissionsPackagedProducts(){
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__PackagedProducts__c',new Set<String>{'Id','Name','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Quantity__c','sigmaerpdev2__Package__r.Name'}))
        {
           return true;
        }  
        return false;
     }
     
     public Static boolean checkAccessPermissionsPackage(){
        if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Package__c',new Set<String>{'Id', 'Name'}))
        {
           return true;
        }  
        return false;
     }
}