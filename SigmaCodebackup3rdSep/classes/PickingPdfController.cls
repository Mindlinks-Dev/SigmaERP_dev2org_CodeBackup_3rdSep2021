public with sharing class PickingPdfController 
{
    Public List<PrintPDFWrap> ppwList{get;set;}
    Public string soIdList{get;set;}
    Public String selectedTab{get;set;}
    Public List<PickingCtrl.sigmaOrderLineWrapper> sigmaOrderLineWrapper{get;set;}
    Public List<PickingOrderCtrl.standOrderLineWrapper> standOrderLineWrapper{get;set;}
    Public string solw{get;set;}
    Public string Order{get;set;}
    
    public Default_Parameters__c defaultparam{get;set;}
    
    public PickingPdfController()
    {
        this.getdefaultparameter();
        soIdList=ApexPages.currentPage().getParameters().get('soIdList');
        selectedTab=ApexPages.currentPage().getParameters().get('selectedTab');
        solw=ApexPages.currentPage().getParameters().get('solw');
        
        if(ApexPages.currentPage().getParameters().get('Order')=='SigmaOrder')
        {
            if(solw!=null)
            sigmaOrderLineWrapper = (List<PickingCtrl.sigmaOrderLineWrapper>)System.JSON.deserialize(solw, List<PickingCtrl.sigmaOrderLineWrapper>.class); 
        }
        else
        {
          if(solw!=null)
            standOrderLineWrapper = (List<PickingOrderCtrl.standOrderLineWrapper>)System.JSON.deserialize(solw, List<PickingOrderCtrl.standOrderLineWrapper>.class);
        } 
    }
    
    public class PrintPDFWrap
    {
        public String soName{get;set;}
        public String soAccountName{get;set;}
        public String soId{get;set;}
        public String allocatedTo{get;set;}
        public List<PrintPDFChildWrap> ppcw{get;set;}
    }
    
    public class PrintPDFChildWrap
    {
        public String prodName{get;set;}
        public String code{get;set;}
        public String brand{get;set;}
        public String description{get;set;}
        public String locName{get;set;}
        public decimal qty{get;set;}
        public decimal pickedQuant{get;set;}
    }
    public void FetchPDFdata()
    {
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
            &&CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')               
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Allocation__c',new set<String>{'id','name','sigmaerpdev__Order_Product__c','sigmaerpdev__Order_Product__r.Product2.Name','sigmaerpdev__Order_Line__c','sigmaerpdev__Order_Line__r.sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Status__c','sigmaerpdev__Picked_Quantity__c','sigmaerpdev__ILPLI__c','sigmaerpdev__Picking__c','sigmaerpdev__ILPLI__r.sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.name','sigmaerpdev__Status__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Order_Usage__c',new set<String>{'sigmaerpdev__Sigma_order__c','sigmaerpdev__Standard_object__c','sigmaerpdev__Allocation_in_Sales_Order__c','sigmaerpdev__Allocation_in_Picking__c','sigmaerpdev__Auto_Allocate_in_picking__c '})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'id','name','sigmaerpdev__Product__r.sigmaerpdev__Description__c','sigmaerpdev__Sigma_Order__c','sigmaerpdev__Sigma_Order__r.sigmaerpdev__AccountId__r.name','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Allocated_User__r.name','sigmaerpdev__Sigma_Order__r.name','sigmaerpdev__Product__c','sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c','sigmaerpdev__Product__r.ProductCode,sigmaerpdev__Product__r.sigmaerpdev__Product_Bar_Code__c','sigmaerpdev__Quantity__c','sigmaerpdev__Product__r.name'})
            && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new set<String>{'id','OrderId','Order.OrderNumber','Order.AccountId','Order.Account.name','Order.sigmaerpdev__Allocated_User__r.name','Product2Id','Product2.name','Product2.sigmaerpdev__Description__c','Product2.sigmaerpdev__Attribute_Type__c','Product2.ProductCode','Product2.sigmaerpdev__Product_Bar_Code__c','Quantity','sigmaerpdev__Net_Quantity__c'})
            &&CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev__Sigma_Order__c'})
                    ){*/
        Order_Usage__c orderusage=[select Sigma_order__c,Standard_object__c,Allocation_in_Sales_Order__c,Allocation_in_Picking__c,Auto_Allocate_in_picking__c  from Order_Usage__c Limit 1];
        System.debug('orderusage>>'+orderusage);
        System.debug('soIdList>>'+soIdList);
        List<String> soIDs = soIdList.split(',');
        
        System.debug('soIDs>>'+soIDs);
        ppwList=new List<PrintPDFWrap>();
        Map<id,PrintPDFWrap> soIdppw=new Map<id,PrintPDFWrap>();
        List<Product_Order_Price_Book__c> solList=new List<Product_Order_Price_Book__c>();
      
        List<OrderItem> oitemList=new List<OrderItem>();
        
        if(orderusage.Sigma_order__c==true)
        {
      
            System.debug('soIDs>>'+soIDs);
                solList=[select id,name,Product__r.Description__c,Sigma_Order__c,Sigma_Order__r.AccountId__r.name,Sigma_Order__r.Allocated_User__r.name,Sigma_Order__r.name,Product__c,Product__r.Attribute_Type__c,Product__r.ProductCode,Product__r.Product_Bar_Code__c,Quantity__c,Product__r.name,
                         (select id,name,Order_Line__c,Order_Line__r.Product__c,Quantity__c,Status__c,Picked_Quantity__c,ILPLI__c,Picking__c, ILPLI__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.name from Inventory_Allocations1__r where Status__c= 'Printed' ) 
                         from Product_Order_Price_Book__c  where Sigma_Order__c=:soIDs ];
     
                System.debug('solList>>'+solList);
     
                for(Product_Order_Price_Book__c sol:solList)
                {
                     System.debug('sol>>'+sol);
                     System.debug('soIdppw>>'+soIdppw);
                    if(soIdppw.containsKey(sol.Sigma_Order__c))
                    {
                        PrintPDFWrap ppw=soIdppw.get(sol.Sigma_Order__c);
                        System.debug('sol.Inventory_Allocations1__r>>'+sol.Inventory_Allocations1__r);
                        for(Inventory_Allocation__c ia:sol.Inventory_Allocations1__r)
                        {
                            PrintPDFChildWrap tempPPCWInd=new PrintPDFChildWrap();
                            tempPPCWInd.prodName=sol.Product__r.name;
                            tempPPCWInd.code=sol.Product__r.Product_Bar_Code__c;
                            tempPPCWInd.description=sol.Product__r.Description__c;
                            tempPPCWInd.locName=ia.ILPLI__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.name;
                            tempPPCWInd.qty=ia.Quantity__c;
                            tempPPCWInd.pickedQuant=ia.Picked_Quantity__c;
                            ppw.ppcw.add(tempPPCWInd);
                        }
                        System.debug('ppw.ppcw>>'+ ppw.ppcw);
                        System.debug('ppw>>'+ppw);
                        
                    }
                    else
                    {
                        
                        
                        PrintPDFWrap ppw=new PrintPDFWrap();
                        ppw.soName=sol.Sigma_Order__r.name;
                        ppw.soAccountName=sol.Sigma_Order__r.AccountId__r.name;
                        ppw.soId=sol.Sigma_Order__c;
                        ppw.allocatedTo=sol.Sigma_Order__r.Allocated_User__r.name;
                        List<PrintPDFChildWrap> tempPPCW=new List<PrintPDFChildWrap>();
                       System.debug('ppw>>'+ppw);
                       System.debug('sol.Inventory_Allocations1__r>>'+sol.Inventory_Allocations1__r);
                       
                       for(Inventory_Allocation__c ia:sol.Inventory_Allocations1__r)
                        {
                            PrintPDFChildWrap tempPPCWInd=new PrintPDFChildWrap();
                            tempPPCWInd.prodName=sol.Product__r.name;
                            tempPPCWInd.code=sol.Product__r.Product_Bar_Code__c;
                            
                            tempPPCWInd.description=sol.Product__r.Description__c;
                            tempPPCWInd.locName=ia.ILPLI__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.name;
                            tempPPCWInd.qty=ia.Quantity__c;
                            tempPPCWInd.pickedQuant=ia.Picked_Quantity__c;
                            tempPPCW.add(tempPPCWInd);
                            System.debug('tempPPCW>>'+tempPPCW);
                        }
                        System.debug('tempPPCW>>'+tempPPCW);
                        ppw.ppcw=tempPPCW;
                        soIdppw.put(sol.Sigma_Order__c,ppw);
                        System.debug('ppw>>'+ppw);
                        ppwList.add(ppw);
                        System.debug('ppwList>>'+ppwList);
                    }
                }
           
                System.debug('ppwList>>'+ppwList);
        }
        else{
            
            
                
                oitemList=[select id,OrderId,Order.OrderNumber,Order.AccountId,Order.Account.name,Order.Allocated_User__r.name,Product2Id,Product2.name,Product2.Description__c,Product2.Attribute_Type__c,Product2.ProductCode,Product2.Product_Bar_Code__c,Quantity,Net_Quantity__c,
                           (select id,name,Order_Product__c,Order_Product__r.Product2.Name,ILPLI__c,Status__c,Picked_Quantity__c,Quantity__c,Picking__c,ILPLI__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.name from Inventory_Allocations__r where Status__c= 'Printed')
                           from OrderItem where OrderId=:soIDs ];
        
         
                for(OrderItem oi:oitemList)
                {
                    
                    if(soIdppw.containsKey(oi.OrderId))
                    {
                        PrintPDFWrap ppw=soIdppw.get(oi.OrderId);
                        for(Inventory_Allocation__c ia:oi.Inventory_Allocations__r)
                        {
                            PrintPDFChildWrap tempPPCWInd=new PrintPDFChildWrap();
                            tempPPCWInd.prodName=oi.Product2.Name;
                            tempPPCWInd.code=oi.Product2.Product_Bar_Code__c;
                          
                            tempPPCWInd.description=oi.Product2.Description__c;
                            tempPPCWInd.locName=ia.ILPLI__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.name;
                          
                            tempPPCWInd.qty=ia.Quantity__c;
                            tempPPCWInd.pickedQuant=ia.Picked_Quantity__c;
                            ppw.ppcw.add(tempPPCWInd);
                        }
                    }
                    else
                    {
                        PrintPDFWrap ppw=new PrintPDFWrap();
                        ppw.soName=oi.Order.OrderNumber;
                        ppw.soAccountName=oi.Order.Account.name;
                        ppw.soId=oi.OrderId;
                        ppw.allocatedTo=oi.Order.Allocated_User__r.name;
                        List<PrintPDFChildWrap> tempPPCW=new List<PrintPDFChildWrap>();
                        for(Inventory_Allocation__c ia:oi.Inventory_Allocations__r)
                        {
                            PrintPDFChildWrap tempPPCWInd=new PrintPDFChildWrap();
                            tempPPCWInd.prodName=oi.Product2.name;
                            tempPPCWInd.code=oi.Product2.Product_Bar_Code__c;
                          
                            tempPPCWInd.description=oi.Product2.Description__c;
                            tempPPCWInd.locName=ia.ILPLI__r.Inventory_Location_Product__r.Inventory_Location__r.Location__r.name;
                          
                            tempPPCWInd.qty=ia.Quantity__c;
                            tempPPCWInd.pickedQuant=ia.Picked_Quantity__c;
                            tempPPCW.add(tempPPCWInd);
                        }
                        ppw.ppcw=tempPPCW;
                        soIdppw.put(oi.OrderId,ppw);
                        System.debug('ppw>>'+ppw);
                        ppwList.add(ppw);
                    }
                }
                System.debug('ppwList>>'+ppwList);
          
        }
    //}
    }
    
    public Default_Parameters__c getdefaultparameter(){
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Default_Parameters__c',new set<String>{'sigmaerpdev__Company_Name__c','sigmaerpdev__Company_Email__c','sigmaerpdev__Company_Phone__c','sigmaerpdev__Logo__c','sigmaerpdev__Company_VAT__c'}))
        {   */     
            defaultparam = [SELECT Company_Name__c,Company_Email__c,Company_Phone__c,Logo__c,Company_VAT__c from Default_Parameters__c Limit 1];
            System.debug('defaultparam>>'+defaultparam);
       // }
        return defaultparam;
    }
    
}