public with sharing class POViewPageHandler 
{
    @AuraEnabled
    public Integer pageSize { get;set; }
    @AuraEnabled
    public Integer page { get;set; }
    @AuraEnabled
    public Integer total { get;set; }
   @AuraEnabled
    public static Community_Configuration__c getBaseURL()
    {
            try{
                   /* if( CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Community_Configuration__c',new set<String>{'id','Name','sigmaerpdev__Vendor_Community_URL__c','sigmaerpdev__Retailer_Community_URL__c'}))
                   {*/
                        Community_Configuration__c cc=[select id,Name,Vendor_Community_URL__c, Retailer_Community_URL__c  from Community_Configuration__c limit 1];
                        if(cc!=null)
                        return cc;
                   // }
            }catch(Exception e){
            createErrorLog.insertError('Vendor Community',e.getMessage(),'Method - getBaseURL',null,'',e.getStackTraceString(),UserInfo.getUserId());
            }
           return null;
    }
    @AuraEnabled
    public static PaginationHelper POListViewonly(Decimal pageNumber,String poId)
    {
        PaginationHelper r1=null;
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Purchase_Order__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Purchase_Order_Product__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('User',new set<String>{'id','Name','ContactId'})
           && CRUD_FLS_CheckUtility.checkReadPermission('Contact',new set<String>{'id','Name','AccountId'})
           && CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'id','name','Type'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Purchase_Order__c',new set<String>{'id','Name','sigmaerpdev__Expected_Delivery_Date__c','sigmaerpdev__Expected_Shipped_Date__c','sigmaerpdev__Product_Supplier__c','sigmaerpdev__Vendor_Status__c','sigmaerpdev__Product_Supplier__r.Name','sigmaerpdev__Order_Date__c','sigmaerpdev__Expected_Date__c','sigmaerpdev__Status__c','sigmaerpdev__Total_Amount__c','sigmaerpdev__Exchange_Total_Net_Buying_Price__c','sigmaerpdev__Paid_Amount__c','sigmaerpdev__Pending_Amount__c','sigmaerpdev__Payment_Due_Date__c','sigmaerpdev__Payment_Status__c','sigmaerpdev__Last_Payment_Date__c','sigmaerpdev__Last_Payment_Date__c','sigmaerpdev__Comments__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Purchase_Order_Product__c',new Set<String>{'Id','Name','sigmaerpdev__Shipment_Tracking_Url__c','sigmaerpdev__Shipment_Notes__c','sigmaerpdev__Orderd_Quantity__c','sigmaerpdev__Purchase_Order__c','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Status__c','sigmaerpdev__Expected_Delivery_Date__c','sigmaerpdev__Quantity__c','sigmaerpdev__Remaining_to_come__c','sigmaerpdev__Received_Quantity__c','sigmaerpdev__VendorPrice__c','sigmaerpdev__Total_Buying_Price__c','sigmaerpdev__Discount__c','sigmaerpdev__Buying_Price__c','sigmaerpdev__Exchange_Net_Buying_Price__c','sigmaerpdev__Under_Warranty__c','sigmaerpdev__Warranty_Duration__c','sigmaerpdev__Warranty_Duration_Unit__c','sigmaerpdev__Warranty_Start_Date__c','sigmaerpdev__Warranty_End_Date__c','sigmaerpdev__Description__c','sigmaerpdev__Delevered_Quantity__c','sigmaerpdev__Reason__c','sigmaerpdev__Vendor_Status__c','sigmaerpdev__Vendor_Expected_Shipped_Date__c','sigmaerpdev__Vendor_Expected_Delivery_Date__c','sigmaerpdev__Remaining_Dispatched_Quantity__c','sigmaerpdev__Recent_Dispatched_Quantity__c'}))
        {*/
            try
            {
                Integer pageSize = 25;
                Integer offset = ((Integer)pageNumber - 1) * pageSize;
                r1 =  new PaginationHelper();
                r1.pageSize = pageSize;
                r1.page = (Integer) pageNumber;
                Id UserId=UserInfo.getUserId();
                //Product_Supplier__c=:vendor[0].Id AND
                List<User> u=[select id,name,ContactId from User where id=:UserId limit 1];
               
                List<Contact> con=[select id,name,AccountId    from Contact where id=:u[0].ContactId limit 1];
                
                List<Account> vendor=[select id,name,Type  from Account where Type=:'Vendor' and id=:con[0].AccountId limit 1];
                
                List<Purchase_Order__c>listOfPos=new  List<Purchase_Order__c>();
                if(vendor!=null){
					if(poId!=null && poId!='')
					{
						listOfPos=[select Expected_Delivery_Date__c,Expected_Shipped_Date__c,id, 
                               name,Product_Supplier__c,Vendor_Status__c,Product_Supplier__r.Name,
                               Order_Date__c,Expected_Date__c ,Status__c ,Total_Amount__c ,
                               Exchange_Total_Net_Buying_Price__c ,Paid_Amount__c,
                               Pending_Amount__c,Payment_Due_Date__c,Payment_Status__c,
                               Last_Payment_Date__c,Comments__c,(select Shipment_Tracking_Url__c,Shipment_Notes__c,id,Name,Orderd_Quantity__c,
                                                                                           Purchase_Order__c,Product__c,Product__r.Name,Status__c,
                                                                                           Expected_Delivery_Date__c,Quantity__c,Remaining_to_come__c,
                                                                                           Received_Quantity__c,VendorPrice__c,Total_Buying_Price__c,
                                                                                           Discount__c,Buying_Price__c,Exchange_Net_Buying_Price__c ,
                                                                                           Under_Warranty__c,Warranty_Duration__c,Warranty_Duration_Unit__c,
                                                                                           Warranty_Start_Date__c,Warranty_End_Date__c,Description__c ,
                                                                                           Delevered_Quantity__c,Reason__c,Vendor_Status__c,Vendor_Expected_Shipped_Date__c,Vendor_Expected_Delivery_Date__c,Remaining_Dispatched_Quantity__c,Recent_Dispatched_Quantity__c from Purchase_Order_Products__r)  from Purchase_Order__c where Product_Supplier__c=:vendor[0].Id AND  Status__c='Submitted'  And Id=:poId order by Name desc limit 25 ];
					r1.total = [SELECT count() FROM Purchase_Order__c where Product_Supplier__c=:vendor[0].Id AND Status__c='Submitted' And Id=:poId];
               
						
					}
					else{
						listOfPos=[select Expected_Delivery_Date__c,Expected_Shipped_Date__c,id, 
                               name,Product_Supplier__c,Vendor_Status__c,Product_Supplier__r.Name,
                               Order_Date__c,Expected_Date__c ,Status__c ,Total_Amount__c ,
                               Exchange_Total_Net_Buying_Price__c ,Paid_Amount__c,
                               Pending_Amount__c,Payment_Due_Date__c,Payment_Status__c,
                               Last_Payment_Date__c,Comments__c,(select Shipment_Tracking_Url__c,Shipment_Notes__c,id,Name,Orderd_Quantity__c,
                                                                                           Purchase_Order__c,Product__c,Product__r.Name,Status__c,
                                                                                           Expected_Delivery_Date__c,Quantity__c,Remaining_to_come__c,
                                                                                           Received_Quantity__c,VendorPrice__c,Total_Buying_Price__c,
                                                                                           Discount__c,Buying_Price__c,Exchange_Net_Buying_Price__c ,
                                                                                           Under_Warranty__c,Warranty_Duration__c,Warranty_Duration_Unit__c,
                                                                                           Warranty_Start_Date__c,Warranty_End_Date__c,Description__c ,
                                                                                           Delevered_Quantity__c,Reason__c,Vendor_Status__c,Vendor_Expected_Shipped_Date__c,Vendor_Expected_Delivery_Date__c,Remaining_Dispatched_Quantity__c,Recent_Dispatched_Quantity__c from Purchase_Order_Products__r)  from Purchase_Order__c where Product_Supplier__c=:vendor[0].Id AND Status__c='Submitted' order by Name desc limit 25 OFFSET:offset ];
                r1.total = [SELECT count() FROM Purchase_Order__c where Product_Supplier__c=:vendor[0].Id AND Status__c='Submitted'];
               
						
					}
					 
					
				}
                   
                List<PaginationHelper.POWrapper> parentPOWrapperList=new  List<PaginationHelper.POWrapper>();
                for(Purchase_Order__c po:listOfPos)
                {
                  
                    List<PaginationHelper.POPWrapper> childPOPWrapperList=new List<PaginationHelper.POPWrapper>();
                    for(Purchase_Order_Product__c pop:po.Purchase_Order_Products__r)
                    {
                        PaginationHelper.POPWrapper childPOPWrapper=new PaginationHelper.POPWrapper();
                        childPOPWrapper.POPId=pop.Id;
                        childPOPWrapper.POPName=pop.Name;
                        childPOPWrapper.ProductId=pop.Product__c;
                        childPOPWrapper.ProductName=pop.Product__r.Name;
                        childPOPWrapper.Quantity=DECIMAL.valueof(pop.Quantity__c);
                        childPOPWrapper.ExpectedDeliveryDate=pop.Expected_Delivery_Date__c;
                        childPOPWrapper.Status=pop.Status__c; 
                        childPOPWrapper.Descripton=pop.Description__c; 
                        childPOPWrapper.totalAmount=pop.Total_Buying_Price__c;
                        childPOPWrapper.discount=pop.Discount__c; 
                        childPOPWrapper.NetBuyingPrice=pop.Buying_Price__c;
                        childPOPWrapper.discount=pop.Discount__c; 
                        childPOPWrapper.NetBuyingPrice=pop.Buying_Price__c;
                        childPOPWrapper.RemainingQuantity=pop.Received_Quantity__c;
                        childPOPWrapper.Reason=pop.Reason__c;
                        childPOPWrapper.vendorStatus=pop.Vendor_Status__c;
                        childPOPWrapper.vendorOldStatus=childPOPWrapper.vendorStatus;
                        childPOPWrapper.oldStatus=childPOPWrapper.vendorStatus;
                        childPOPWrapper.remainingDispatchedQuantity=pop.Remaining_Dispatched_Quantity__c;
                        childPOPWrapper.vendorExpectedShippedDate=pop.Vendor_Expected_Shipped_Date__c;
                        childPOPWrapper.vendorExpectedDeleveryDate=pop.Vendor_Expected_Delivery_Date__c;
                        childPOPWrapper.recentDispatchedQuantity=pop.Recent_Dispatched_Quantity__c;
                       
                        if(pop.Delevered_Quantity__c==null){
                            pop.Delevered_Quantity__c=0;
                        }
                        childPOPWrapper.DeleveredQuantity=pop.Delevered_Quantity__c;
                         childPOPWrapper.shipmentNotes=pop.Shipment_Notes__c;
                          childPOPWrapper.shipmentTrackingUrl=pop.Shipment_Tracking_Url__c;
                        childPOPWrapperList.add(childPOPWrapper);
                    }
                  
                    PaginationHelper.POWrapper parentPOWrapper=new PaginationHelper.POWrapper();
                    parentPOWrapper.isSelected=false;
                    parentPOWrapper.POId=po.id;
                    parentPOWrapper.POName=po.Name;
                    parentPOWrapper.VendorId=po.Product_Supplier__c;
                    parentPOWrapper.VendorName=po.Product_Supplier__r.Name;
                    parentPOWrapper.orderDate=po.Order_Date__c;
                    parentPOWrapper.expectedDate=po.Expected_Date__c;
                    parentPOWrapper.Status=po.Status__c;
                    if(po.Vendor_Status__c==null)
                    {
                        po.Vendor_Status__c='';
                    }
                    parentPOWrapper.vendorStatus=po.Vendor_Status__c;
                    if(po.Expected_Shipped_Date__c==null)
                    {
                        parentPOWrapper.expectedShippedDate=null;
                        parentPOWrapper.isDefaultShippedDate=true;
                    }
                    else
                    {
                        parentPOWrapper.isDefaultShippedDate=false;
                        parentPOWrapper.expectedShippedDate=po.Expected_Shipped_Date__c;
                    }
                    if(po.Expected_Delivery_Date__c==null)
                    {
                        parentPOWrapper.isDefaultDeleveryDate=true;
                        
                        parentPOWrapper.expectedDeleveryDate=null;
                    }
                    else
                    {
                        parentPOWrapper.isDefaultDeleveryDate=false;
                        parentPOWrapper.expectedDeleveryDate=po.Expected_Delivery_Date__c;
                    }
                   
                    if(childPOPWrapperList.size()>0)parentPOWrapper.popWrapperList=childPOPWrapperList;
                    parentPOWrapperList.add(parentPOWrapper);
                    
                }
               
                if(parentPOWrapperList.size()>0)
                    r1.PoWrapperList=parentPOWrapperList;
              
                return r1;
            }
            catch (Exception e)
            {
                
                createErrorLog.insertError('Vendor Community',e.getMessage(),'Method - POListViewonly',null,'',e.getStackTraceString(),UserInfo.getUserId());
                
            }
           
      // }
          return r1;
    }
    @AuraEnabled
    public static PaginationHelper.POPWrapper savePos(String  polist)
    {
        PaginationHelper.POPWrapper childPOPWrapper=new  PaginationHelper.POPWrapper();
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Purchase_Order__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Purchase_Order_Product__c')
           
           && CRUD_FLS_CheckUtility.checkReadPermission('User',new set<String>{'id','Name','ContactId'})
           && CRUD_FLS_CheckUtility.checkReadPermission('Contact',new set<String>{'id','Name','AccountId'})
           && CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'id','name','Type'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Purchase_Order__c',new set<String>{'id','Name','sigmaerpdev__Vendor_Status__c','sigmaerpdev__Expected_Delivery_Date__c','sigmaerpdev__Expected_Shipped_Date__c','sigmaerpdev__Approved__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Purchase_Order_Product__c',new Set<String>{'Id','Name','sigmaerpdev__Shipment_Tracking_Url__c','sigmaerpdev__Shipment_Notes__c','sigmaerpdev__Orderd_Quantity__c','sigmaerpdev__Purchase_Order__c','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Status__c','sigmaerpdev__Expected_Delivery_Date__c','sigmaerpdev__Quantity__c','sigmaerpdev__Remaining_to_come__c','sigmaerpdev__Received_Quantity__c','sigmaerpdev__VendorPrice__c','sigmaerpdev__Total_Buying_Price__c','sigmaerpdev__Discount__c','sigmaerpdev__Buying_Price__c','sigmaerpdev__Exchange_Net_Buying_Price__c','sigmaerpdev__Under_Warranty__c','sigmaerpdev__Warranty_Duration__c','sigmaerpdev__Warranty_Duration_Unit__c','sigmaerpdev__Warranty_Start_Date__c','sigmaerpdev__Warranty_End_Date__c','sigmaerpdev__Description__c','sigmaerpdev__Delevered_Quantity__c','sigmaerpdev__Reason__c','sigmaerpdev__Vendor_Status__c','sigmaerpdev__Vendor_Expected_Shipped_Date__c','sigmaerpdev__Vendor_Expected_Delivery_Date__c','sigmaerpdev__Remaining_Dispatched_Quantity__c','sigmaerpdev__Recent_Dispatched_Quantity__c'})
           
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Purchase_Order__c',new set<String>{'sigmaerpdev__Vendor_Status__c','sigmaerpdev__Expected_Delivery_Date__c','sigmaerpdev__Expected_Shipped_Date__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Purchase_Order_Product__c',new set<String>{'sigmaerpdev__Recent_Dispatched_Quantity__c','sigmaerpdev__Delevered_Quantity__c','sigmaerpdev__Reason__c','sigmaerpdev__Shipment_Notes__c','sigmaerpdev__Shipment_Tracking_Url__c','sigmaerpdev__Vendor_Expected_Shipped_Date__c','sigmaerpdev__Vendor_Expected_Delivery_Date__c','sigmaerpdev__Remaining_Dispatched_Quantity__c','sigmaerpdev__Vendor_Status__c'}))
        {*/
            try{
                PaginationHelper.POWrapper powrapper = (PaginationHelper.POWrapper)JSON.deserialize(
                polist,PaginationHelper.POWrapper.class);
                List<Id>popIds=new List<Id>();
                if(powrapper!=null && powrapper.popWrapperList!=null)
                {
                    Purchase_Order__c po=[select id,name,Vendor_Status__c,Expected_Delivery_Date__c,Approved__c,Expected_Shipped_Date__c from Purchase_Order__c where id=:powrapper.POId  limit 1];
                    if(po!=null )
                        update po;
                }
                if(powrapper.popWrapperList!=null)
                {
                    Map<Id,Decimal>PopIdQty=new Map<Id,Decimal>();
                    Map<Id,String>PopIdReason=new Map<Id,String>();
                    Map<Id,String>PopIdvendorStatus=new Map<Id,String>();
                    Map<Id,Date>PopIdvendorExpectedShippedDate=new Map<Id,Date>();
                    Map<Id,Date>PopIdvendorExpectedDeliveryDate=new Map<Id,Date>();
                     Map<Id,String>popIdAndshipmentNote=new Map<Id,String>();
                     Map<Id,String>popIdAndshipmentTrackingUrl=new Map<Id,String>();
                    for( PaginationHelper.POPWrapper popWrap:powrapper.popWrapperList)
                    {
                        popIds.add(popWrap.POPId);   
                        PopIdQty.put(popWrap.POPId,popWrap.DeleveredQuantity);
                        PopIdReason.put(popWrap.POPId,popWrap.Reason);
                        popIdAndshipmentNote.put(popWrap.POPId,popWrap.shipmentNotes);
                        popIdAndshipmentTrackingUrl.put(popWrap.POPId,popWrap.shipmentTrackingUrl);
                        PopIdvendorStatus.put(popWrap.POPId,popWrap.vendorStatus);
                        PopIdvendorExpectedShippedDate.put(popWrap.POPId,popWrap.vendorExpectedShippedDate);
                        PopIdvendorExpectedDeliveryDate.put(popWrap.POPId,popWrap.vendorExpectedDeleveryDate);
                    }
                    List<Purchase_Order_Product__c> popsNew=new List<Purchase_Order_Product__c>();
                    List<Purchase_Order_Product__c> pops=[select Shipment_Tracking_Url__c,Shipment_Notes__c,id,Name,Orderd_Quantity__c,
                                                                                           Purchase_Order__c,Product__c,Product__r.Name,Status__c,
                                                                                           Expected_Delivery_Date__c,Quantity__c,Remaining_to_come__c,
                                                                                           Received_Quantity__c,VendorPrice__c,Total_Buying_Price__c,
                                                                                           Discount__c,Buying_Price__c,Exchange_Net_Buying_Price__c ,
                                                                                           Under_Warranty__c,Warranty_Duration__c,Warranty_Duration_Unit__c,
                                                                                           Warranty_Start_Date__c,Warranty_End_Date__c,Description__c ,
                                                                                           Delevered_Quantity__c,Reason__c,Vendor_Status__c,Vendor_Expected_Shipped_Date__c,Vendor_Expected_Delivery_Date__c,Remaining_Dispatched_Quantity__c,Recent_Dispatched_Quantity__c from Purchase_Order_Product__c where id=:popIds and Purchase_Order__c=:powrapper.POId];
                    for(Purchase_Order_Product__c pop :pops)
                    {
                        if(PopIdvendorStatus.get(pop.id)!='Request Cancel')
                        {
                            if( pop.Recent_Dispatched_Quantity__c==null)
                            {
                                pop.Recent_Dispatched_Quantity__c=0;
                            }
                            pop.Recent_Dispatched_Quantity__c= PopIdQty.get(pop.id);
                            if( pop.Delevered_Quantity__c==null)
                            {
                                pop.Delevered_Quantity__c=0;
                            }
                            pop.Delevered_Quantity__c+=pop.Recent_Dispatched_Quantity__c;
                            pop.Reason__c=PopIdReason.get(pop.id);
                            pop.Shipment_Notes__c=popIdAndshipmentNote.get(pop.id);
                            pop.Shipment_Tracking_Url__c=popIdAndshipmentTrackingUrl.get(pop.id);
                            pop.Vendor_Expected_Shipped_Date__c=PopIdvendorExpectedShippedDate.get(pop.id);
                            pop.Vendor_Expected_Delivery_Date__c=PopIdvendorExpectedDeliveryDate.get(pop.id);
                            if(pop.Remaining_Dispatched_Quantity__c==null)
                            {
                                pop.Remaining_Dispatched_Quantity__c=0;
                                pop.Remaining_Dispatched_Quantity__c=Decimal.valueof(pop.Quantity__c) - PopIdQty.get(pop.id);
                            }
                            else{
                                pop.Remaining_Dispatched_Quantity__c=pop.Remaining_Dispatched_Quantity__c-PopIdQty.get(pop.id);  
                            }
                            if(pop.Remaining_Dispatched_Quantity__c>0)
                            {
                                pop.Vendor_Status__c=PopIdvendorStatus.get(pop.id);
                            }
                            else
                            {
                                pop.Vendor_Status__c='Dispatched';
                            } 
                        }else if(PopIdvendorStatus.get(pop.id)=='Request Cancel')
                        {
                            pop.Vendor_Status__c=PopIdvendorStatus.get(pop.id);
                        }
                        childPOPWrapper.POPId=pop.Id;
                        childPOPWrapper.POPName=pop.Name;
                        childPOPWrapper.ProductId=pop.Product__c;
                        childPOPWrapper.ProductName=pop.Product__r.Name;
                        childPOPWrapper.Quantity=DECIMAL.valueof(pop.Quantity__c);
                        childPOPWrapper.ExpectedDeliveryDate=pop.Expected_Delivery_Date__c;
                        childPOPWrapper.Status=pop.Status__c; 
                        childPOPWrapper.Descripton=pop.Description__c; 
                        childPOPWrapper.totalAmount=pop.Total_Buying_Price__c;
                        childPOPWrapper.discount=pop.Discount__c; 
                        childPOPWrapper.NetBuyingPrice=pop.Buying_Price__c;
                        childPOPWrapper.discount=pop.Discount__c; 
                        childPOPWrapper.NetBuyingPrice=pop.Buying_Price__c;
                        childPOPWrapper.RemainingQuantity=pop.Received_Quantity__c;
                        childPOPWrapper.Reason=pop.Reason__c;
                        childPOPWrapper.vendorStatus=pop.Vendor_Status__c;
                        childPOPWrapper.vendorOldStatus=childPOPWrapper.vendorStatus;
                        childPOPWrapper.oldStatus=childPOPWrapper.vendorStatus;
                        childPOPWrapper.remainingDispatchedQuantity=pop.Remaining_Dispatched_Quantity__c;
                        childPOPWrapper.vendorExpectedShippedDate=pop.Vendor_Expected_Shipped_Date__c;
                        childPOPWrapper.vendorExpectedDeleveryDate=pop.Vendor_Expected_Delivery_Date__c;
                        childPOPWrapper.recentDispatchedQuantity=pop.Recent_Dispatched_Quantity__c;
                        //System.debug('pop.sigmaerpdev__Delevered_Quantity__c>>'+pop.sigmaerpdev__Delevered_Quantity__c);
                        if(pop.Delevered_Quantity__c==null){
                            pop.Delevered_Quantity__c=0;
                        }
                        childPOPWrapper.DeleveredQuantity=pop.Delevered_Quantity__c;
                        childPOPWrapper.shipmentNotes=pop.Shipment_Notes__c;
                          childPOPWrapper.shipmentTrackingUrl=pop.Shipment_Tracking_Url__c;
                        popsNew.add(pop);
                    }
                    if(popsNew.size()>0)
                    {
                        update  popsNew;
                    }
                }
            }catch(Exception e)
            {
                System.debug('e:::'+e.getCause()+e.getMessage());
                  createErrorLog.insertError('Vendor Community',e.getMessage(),'Method - savePos',null,'',e.getStackTraceString(),UserInfo.getUserId());
              
            }
        //}
        return childPOPWrapper;
    }           
}