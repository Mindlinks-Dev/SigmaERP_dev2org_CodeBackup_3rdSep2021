global with sharing class ConvertProposaltoOrder
{
     @AuraEnabled
    public static Proposal__c getProposal(Id Proposalid)
    {
        Proposal__c campObject ;
         
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Proposal__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Proposal__c',new set<String>{'Id','Name','sigmaerpdev2__Proposal_Name__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Inventory_Allocated__c','sigmaerpdev2__Is_Order_Created__c','sigmaerpdev2__Status__c','sigmaerpdev2__Client__c','sigmaerpdev2__Client__r.Name','sigmaerpdev2__Billing_Contact__c','sigmaerpdev2__Billing_Contact__r.Name','sigmaerpdev2__Type__c'}))
        {*/
           
         campObject=[Select Id,Name,Proposal_Name__c,Inventory_Allocated__c,Start_Date__c,End_Date__c  ,Is_Order_Created__c,Status__c,Client__c,Client__r.Name,Billing_Contact__c,Billing_Contact__r.Name,Type__c from Proposal__c where Id =: Proposalid];
         
        //}
        return campObject;        
    }
     @AuraEnabled
    public static Order_Usage__c getcustomsettings()
    {
        Order_Usage__c setting ;
        
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Order_Usage__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Order_Usage__c',new set<String>{'sigmaerpdev2__Standard_object__c'}))
        {*/
           
         setting=[Select Standard_object__c from Order_Usage__c Limit 1];
         
        //}
        return setting;        
    }
 
    @AuraEnabled
    webservice static Id saveOrder(Id Orderid)
    {
        system.debug('Orderid>>'+Orderid);
        Sigma_Order__c orderObj ;
        try
        {
                
            Dimension_Tag__c creditdetails;
            /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Proposal__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Dimension_Tag__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Proposal_Item__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__ProposalLineItemLocation__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__OrderLineLocation__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Default_Parameters__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('Account')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Proposal__c',new set<String>{'Id','Name','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Billing_Contact__r.Name','sigmaerpdev2__Total_Amount__c','sigmaerpdev2__Client__c','sigmaerpdev2__Billing_Contact__c','sigmaerpdev2__Other_Discount__c','sigmaerpdev2__Other_Discount_Euro__c','sigmaerpdev2__Other_Charges__c','sigmaerpdev2__Discount_Method__c','sigmaerpdev2__Discount__c','sigmaerpdev2__Field_Discount_Amount__c','sigmaerpdev2__Field_Discount_Amount_Euro__c','sigmaerpdev2__Agent_Commission__c','sigmaerpdev2__Other_Charges_Euro__c','sigmaerpdev2__Agent_Commission_Euro__c','sigmaerpdev2__Usage_Type__c' })
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Proposal_Item__c',new set<String>{'Id', 'Name','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__Discount__c','sigmaerpdev2__Discount_Euro__c','sigmaerpdev2__Cost__c','sigmaerpdev2__Cost_Euro__c','sigmaerpdev2__Proposal__c' })
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__ProposalLineItemLocation__c',new set<String>{'Id','Name','sigmaerpdev2__Location__c','sigmaerpdev2__Location_Discount__c','sigmaerpdev2__Location_Discount_Euro__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Cost__c','sigmaerpdev2__Cost_Euro__c','sigmaerpdev2__Proposal_Line_Item__c'})
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Default_Parameters__c',new Set<String>{'Id','sigmaerpdev2__Inventory_Status__c','sigmaerpdev2__Default_Location__c','sigmaerpdev2__Package_ID__c','sigmaerpdev2__Parent_Id__c','sigmaerpdev2__Shipment_ID__c','sigmaerpdev2__StockReceiving_ID__c','sigmaerpdev2__Currency__c'})
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new set<String>{'Id','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__ProductCode__c'})
            &&CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'id','name','sigmaerpdev2__Customer_Type__c'})
            &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Dimension_Tag__c',new set<String>{'id','sigmaerpdev2__Ordered_Amount__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Order__c',new set<String>{'sigmaerpdev2__Tax__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__BillingPersonNew__c','sigmaerpdev2__Billing_Person__c','sigmaerpdev2__Proposals__c','sigmaerpdev2__Orders_Status__c','sigmaerpdev2__Customer_Type__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Order_Created_Via__c','sigmaerpdev2__Field_Discount_Amount__c','sigmaerpdev2__Field_Discount_Amount_Euro__c','sigmaerpdev2__Other_Discount__c','sigmaerpdev2__Other_Discount_Euro__c','sigmaerpdev2__Other_Charges__c','sigmaerpdev2__Other_Charges_Euro__c','sigmaerpdev2__Agency_Commission__c','sigmaerpdev2__Agency_Commission_Euro__c','sigmaerpdev2__TotalAmount__c','sigmaerpdev2__Net_Amount__c','sigmaerpdev2__Delivary_Date__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Dimension_Tag__c',new set<String>{'sigmaerpdev2__Ordered_Amount__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Remaining_Qty_To_Package__c','sigmaerpdev2__Discount__c','sigmaerpdev2__Discount_Euro__c','sigmaerpdev2__Cost__c','sigmaerpdev2__Total_Amount__c','sigmaerpdev2__Total_Price__c','sigmaerpdev2__TotalPrice__c','sigmaerpdev2__Cost_Euro__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Order_Status__c','sigmaerpdev2__Inventory_Status__c','sigmaerpdev2__Back_Order__c','sigmaerpdev2__Stock_Fulfilled__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__OrderLineLocation__c',new set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Location__c','sigmaerpdev2__Location_Discount__c','sigmaerpdev2__Location_Discount_Euro__c','sigmaerpdev2__Cost__c' })
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Proposal__c',new set<String>{'sigmaerpdev2__Is_Order_Created__c'})
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Sigma_Order__c',new set<String>{'sigmaerpdev2__AccountId__c'})
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev2__Sigma_Order__c'})
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__OrderLineLocation__c',new set<String>{'sigmaerpdev2__Order_Line__c'})
            )
            { */
                Proposal__c campObject ;
                Account ACC;
                Decimal TotalNetAmount =0;
           Double TaxOnBillAmount = 0;
                //Time_Base_Inventory__c TBI=[select Proposal_for_Products__c from Time_Base_Inventory__c Limit 1];
                List<Proposal_Item__c> campaignLineItems;
                List<Product_Order_Price_Book__c> OrderLineItems =new List<Product_Order_Price_Book__c>();
                List<ProposalLineItemLocation__c> campaignlocitem;
                List<OrderLineLocation__c> orderlocitem=new List<OrderLineLocation__c>();
                campObject=[Select Id,Name,Start_Date__c,End_Date__c,Total_Amount__c,Client__c,Billing_Contact__c,Billing_Contact__r.Name,Agent_Commission__c,Agent_Commission_Euro__c,Other_Discount__c,Other_Discount_Euro__c,Other_Charges__c,Other_Charges_Euro__c,Discount_Method__c,Discount__c,Field_Discount_Amount__c,Field_Discount_Amount_Euro__c,Usage_Type__c from Proposal__c where Id =: Orderid];
                ACC=[Select id,name,Customer_Type__c from Account where id =:campObject.Client__c];
                Id camid=campObject.Id;
                orderObj = new Sigma_Order__c ();
                orderObj.BillingPersonNew__c=campObject.Billing_Contact__c;
                orderObj.Billing_Person__c = campObject.Billing_Contact__r.Name;
                orderObj.Proposals__c=campObject.Id;
                orderObj.AccountId__c=campObject.Client__c;
                orderObj.Orders_Status__c = 'Pending';
                orderObj.Customer_Type__c = ACC.Customer_Type__c;
                orderObj.Start_Date__c=campObject.Start_Date__c;
                orderObj.End_Date__c=campObject.End_Date__c;
                if(campObject.Usage_Type__c == 'Product')
                {
                orderObj.Order_Created_Via__c = 'Proposal';
                }else
                {
                orderObj.Order_Created_Via__c = 'Time Based Inventory';
                }
                orderObj.Field_Discount_Amount__c=campObject.Field_Discount_Amount__c;
                orderObj.Field_Discount_Amount_Euro__c=campObject.Field_Discount_Amount_Euro__c;
                orderObj.Other_Discount__c=campObject.Other_Discount__c;
                orderObj.Other_Discount_Euro__c=campObject.Other_Discount_Euro__c;
                orderObj.Other_Charges__c=campObject.Other_Charges__c;
                orderObj.Other_Charges_Euro__c=campObject.Other_Charges_Euro__c;
                orderObj.Agency_Commission__c=campObject.Agent_Commission__c;
                orderObj.Agency_Commission_Euro__c=campObject.Agent_Commission_Euro__c;
          orderObj.Net_Amount__c=campObject.Total_Amount__c;
          
          //Code for TAX
          
          List<Tax__c> taxObj = TaxCntr.getTax(orderObj.AccountId__c);
          Double federalTax = Double.valueOf(taxObj.get(0).Tax_Amount__c);
          String fedTaxType = String.valueOf(taxObj.get(0).Type__c);
          Double stateTax = Double.valueOf(taxObj.get(1).Tax_Amount__c);
          String stateTaxType = String.valueOf(taxObj.get(1).Type__c);

          if(fedTaxType == 'Percentage'){
          TaxOnBillAmount = (orderObj.Net_Amount__c * federalTax)/100;
          }else{
          TaxOnBillAmount = orderObj.Net_Amount__c + federalTax;
          }               
          if(stateTaxType == 'Percentage'){
          TaxOnBillAmount = (TaxOnBillAmount + (orderObj.Net_Amount__c * stateTax)/100);
          }else{
          TaxOnBillAmount = (TaxOnBillAmount + (orderObj.Net_Amount__c + stateTax));
          }        
          orderObj.Tax_Amount__c = TaxOnBillAmount;
                orderObj.Tax__c = federalTax+stateTax;
                orderObj.TotalAmount__c=orderObj.Net_Amount__c+TaxOnBillAmount;
                
                orderObj.Delivary_Date__c = System.today();
                insert orderObj;

                //code t update credituser details
              /*  if(orderObj.Customer_Type__c=='Credit Customer')
                {
                    creditdetails = [select id,Ordered_Amount__c from Dimension_Tag__c where Account__c=:orderObj.AccountId__c limit 1];
                    if(creditdetails!=null){
                        if(orderObj.TotalAmount__c!=null){
                            if(creditdetails.Ordered_Amount__c==null)
                            creditdetails.Ordered_Amount__c=0;
                            creditdetails.Ordered_Amount__c+=orderObj.TotalAmount__c;
                        }
                    }
                    update creditdetails;
                } */

                campaignLineItems=[Select Id,Name,Product__c,Quantity__c,End_Date__c,Start_Date__c,Discount__c,Discount_Euro__c,Cost__c,Cost_Euro__c,Proposal__c from Proposal_Item__c where Proposal__c =: campObject.Id];
                system.debug('campaignLineItems>>'+campaignLineItems);
                system.debug('campaignLineItemssize>>'+campaignLineItems.size());
                List<Id>prod = new List<Id>();
                for(Proposal_Item__c proposalitem:campaignLineItems)
                {
                prod.add(proposalitem.Product__c);
                }

                //code tp handle backorder 
                List<Inventory__c> PI = [Select id,ProductCode__c,Available_Qty__c from Inventory__c where ProductCode__c =:prod];
                //upsert order line Items
                decimal NoofProducts=0;
                String inventorystatus;
                Default_Parameters__c options;
                options = [select Id,Inventory_Status__c,Default_Location__c,Package_ID__c,Parent_Id__c,Shipment_ID__c,StockReceiving_ID__c from Default_Parameters__c];
                inventorystatus = options.Inventory_Status__c; 
                Map<id,Decimal> orderlinepro=new  Map<id,Decimal>();
                for(Proposal_Item__c proposalitem:campaignLineItems)
                {
                    for(Inventory__c proinv : PI)
                    {
                        if(proinv.ProductCode__c == proposalitem.Product__c)
                        {
                            if(proposalitem.Quantity__c > proinv.Available_Qty__c && campObject.Usage_Type__c=='Product')
                            {
                                decimal remainqunt=proposalitem.Quantity__c - proinv.Available_Qty__c;
                                Product_Order_Price_Book__c orderline = new Product_Order_Price_Book__c();
                                orderline.Product__c=proposalitem.Product__c;
                                orderline.Quantity__c=proposalitem.Quantity__c;
                                orderline.Net_Quantity__c = proinv.Available_Qty__c;
                                orderline.Remaining_Qty_To_Package__c=orderline.Net_Quantity__c;
                                orderlinepro.put(orderline.Product__c,orderline.Quantity__c);
                                NoofProducts+=orderline.Quantity__c;
                                orderline.Discount__c=proposalitem.Discount__c;
                                orderline.Discount_Euro__c=proposalitem.Discount_Euro__c;
                                orderline.Cost__c=((proposalitem.Cost__c*orderline.Net_Quantity__c)/proposalitem.Quantity__c);
                                if(orderObj.Order_Created_Via__c == 'Proposal')
                                orderline.Total_Amount__c= orderline.Cost__c/orderline.Quantity__c;
                                orderline.Total_Price__c= orderline.Cost__c;
                                orderline.TotalPrice__c= orderline.Cost__c;
                                orderline.Cost_Euro__c=((proposalitem.Cost_Euro__c*orderline.Net_Quantity__c)/proposalitem.Quantity__c);
                                orderline.Start_Date__c=proposalitem.Start_Date__c;
                                orderline.End_Date__c=proposalitem.End_Date__c;
                                orderline.Sigma_Order__c=orderObj.Id;
                                orderline.Order_Status__c='Pending';
                                TotalNetAmount +=orderline.Cost__c-orderline.Discount__c;
                                if(inventorystatus=='Reserve')
                                {
                                orderline.Inventory_Status__c = 'Reserve';
                                }
                                OrderLineItems.add(orderline);

                                Product_Order_Price_Book__c orderline1 = new Product_Order_Price_Book__c();
                                orderline1.Product__c=proposalitem.Product__c;
                                orderline1.Net_Quantity__c = remainqunt;
                                orderline1.Remaining_Qty_To_Package__c=orderline1.Net_Quantity__c;
                                orderline1.Cost__c=((proposalitem.Cost__c*orderline1.Net_Quantity__c)/proposalitem.Quantity__c);
                                if(orderObj.Order_Created_Via__c == 'Proposal')
                                orderline1.Total_Amount__c= orderline1.Cost__c/orderline1.Net_Quantity__c;
                                orderline1.Total_Price__c= orderline1.Cost__c;
                                orderline1.TotalPrice__c= orderline1.Cost__c;
                                orderline1.Cost_Euro__c=((proposalitem.Cost_Euro__c*orderline1.Net_Quantity__c)/proposalitem.Quantity__c);
                                orderline1.Start_Date__c=proposalitem.Start_Date__c;
                                orderline1.End_Date__c=proposalitem.End_Date__c;
                                orderline1.Sigma_Order__c=orderObj.Id;
                                orderline1.Order_Status__c='Pending';
                                orderline1.Back_Order__c =true;
                                orderline1.Stock_Fulfilled__c = false;
                                if(inventorystatus=='Reserve')
                                {
                                orderline1.Inventory_Status__c = 'Reserve';
                                }
                                OrderLineItems.add(orderline1);
                            }
                            else
                            {
                                Product_Order_Price_Book__c orderline2 = new Product_Order_Price_Book__c();
                                orderline2.Product__c=proposalitem.Product__c;
                                orderline2.Quantity__c=proposalitem.Quantity__c;
                                orderline2.Remaining_Qty_To_Package__c=proposalitem.Quantity__c;
                                orderlinepro.put(orderline2.Product__c,orderline2.Quantity__c);
                                orderline2.Net_Quantity__c=proposalitem.Quantity__c;
                                NoofProducts+=orderline2.Quantity__c;
                                orderline2.Discount__c=proposalitem.Discount__c;
                                orderline2.Discount_Euro__c=proposalitem.Discount_Euro__c;
                                orderline2.Cost__c=proposalitem.Cost__c;
                                if(orderObj.Order_Created_Via__c == 'Proposal')
                                orderline2.Total_Amount__c= orderline2.Cost__c/orderline2.Net_Quantity__c;
                                orderline2.Total_Price__c= orderline2.Cost__c;
                                orderline2.TotalPrice__c= orderline2.Cost__c;
                                orderline2.Cost_Euro__c=proposalitem.Cost_Euro__c;
                                orderline2.Start_Date__c=proposalitem.Start_Date__c;
                                orderline2.End_Date__c=proposalitem.End_Date__c;
                                orderline2.Sigma_Order__c=orderObj.Id;
                                orderline2.Order_Status__c='Pending';
                                //code added by rashmi to update IsInventoryUpdated__c checkbox feild in orderlines on 1-08-2019
                                //orderline.IsInventoryUpdated__c = true;
                                if(inventorystatus=='Reserve')
                                {
                                orderline2.Inventory_Status__c = 'Reserve';

                                }
                                OrderLineItems.add(orderline2);
                            }
                        }   
                    }
                }
                insert OrderLineItems;
                system.debug('OrderLineItems>>'+OrderLineItems);
                //List<Inventory__c> inventoryObj = [Select Id,Available_Qty__c,Delivered_Qty__c ,ProductCode__c,Reserved_Qty__c,Purchased_Qty__c, Total_Available_Qty__c from Inventory__c where ProductCode__r.Id=:orderlinepro.keySet()];
                Sigma_Order__c sogmaorderObj=new Sigma_Order__c() ;
                sogmaorderObj.id=orderObj.id;
                sogmaorderObj.Net_Quantity__c=NoofProducts;
                update sogmaorderObj;


                //upsert order location Items
                campaignlocitem=[Select Id,Name,Location__c,Location_Discount__c,Location_Discount_Euro__c,Product__c,Quantity__c,Cost__c,Cost_Euro__c,Proposal_Line_Item__c from ProposalLineItemLocation__c where Proposal_Line_Item__c =: campaignLineItems];
                system.debug('campaignlocitem@@'+campaignlocitem);
                system.debug('campaignlocitemsize@@'+campaignlocitem.size());
                
                for(Proposal_Item__c orderlineitem:campaignLineItems)
                {
                    for(ProposalLineItemLocation__c locationitem:campaignlocitem)
                    {
                        if(orderlineitem.Id==locationitem.Proposal_Line_Item__c)
                        {
                            OrderLineLocation__c locline = new OrderLineLocation__c();

                            locline.Product__c=locationitem.Product__c;
                            locline.Quantity__c=locationitem.Quantity__c;
                            locline.Location__c=locationitem.Location__c;
                            locline.Location_Discount__c=locationitem.Location_Discount__c;
                            locline.Location_Discount_Euro__c=locationitem.Location_Discount_Euro__c;
                            locline.Cost__c=locationitem.Cost__c;
                            for(Product_Order_Price_Book__c ordrlinr:OrderLineItems)
                            {
                                if(orderlineitem.Product__c == ordrlinr.Product__c)
                                {
                                locline.Order_Line__c = ordrlinr.Id;
                                orderlocitem.add(locline);
                                }
                            }
                        }   

                    }
                }
                system.debug('orderlocitem@@'+orderlocitem);
               // if(!Test.isRunningTest()){
                upsert orderlocitem;
             

                campObject.Is_Order_Created__c = true; 
                update campObject;

           // }
        }
        catch(Exception ex)
        {
            createErrorLog.insertError('Proposal',ex.getMessage(),'Method -saveOrder ',null,'',ex.getStackTraceString(),UserInfo.getUserId());
        } 
        
        return orderObj.Id;
    }
   //code added by chandana for FFP migration 
    @AuraEnabled
    public static Service_Quote__c getQuote(Id Quoteid)
    {
        Service_Quote__c QuoteObject ; 
       /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Service_Quote__c')
        &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Service_Quote__c',new set<String>{'Id','Name','sigmaerpdev2__Work_Order__c','sigmaerpdev2__Total_Price__c','sigmaerpdev2__Account__c','sigmaerpdev2__Account__r.Name','sigmaerpdev2__Status__c','sigmaerpdev2__Work_Order__r.FFP_MR_Contact__c','sigmaerpdev2__Work_Order__r.FFP_MR_Contact__r.name','sigmaerpdev2__Is_Order_Created__c'}))
        {*/  
         QuoteObject=[Select Id,Name,Work_Order__c,Total_Price__c,Account__c,Account__r.Name,Status__c,Work_Order__r.FFP_MR_Contact__c,Work_Order__r.FFP_MR_Contact__r.name,Is_Order_Created__c from Service_Quote__c where Id =: Quoteid];
        //}
        system.debug('QuoteObject>>'+QuoteObject);
    return QuoteObject;        
    }
    //code to convert service quote to order
    @AuraEnabled
    webservice static Id saveOrderQuote(Id Orderid)
    {
 
    Sigma_Order__c orderObj ;
    /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Service_Quote__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Service_Quote_Line_Item__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('Account')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Default_Parameters__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Tax__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c')
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Service_Quote__c',new set<String>{'Id','Name','sigmaerpdev2__Work_Order__c','sigmaerpdev2__Total_Price__c','sigmaerpdev2__Account__c','sigmaerpdev2__Account__r.Name','sigmaerpdev2__Status__c','sigmaerpdev2__Work_Order__r.FFP_MR_Contact__r.name','sigmaerpdev2__Is_Order_Created__c'})
    && CRUD_FLS_CheckUtility.checkReadPermission('Account',new set<String>{'id','name','sigmaerpdev2__Customer_Type__c','sigmaerpdev2__Email__c'})
    && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Order__c',new set<String>{'sigmaerpdev2__Tax__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Billing_Person__c','sigmaerpdev2__BillingPersonNew__c','sigmaerpdev2__Service_Quote__c','sigmaerpdev2__Delivary_Date__c','sigmaerpdev2__Customer_Type__c','sigmaerpdev2__Customer_Email__c','sigmaerpdev2__Orders_Status__c','sigmaerpdev2__Order_Created_Via__c','sigmaerpdev2__TotalAmount__c','sigmaerpdev2__Tax_Amount__c'})
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Service_Quote_Line_Item__c',new set<String>{'Id','Name','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Service_Contract__c,sigmaerpdev2__Service_Quote__c','sigmaerpdev2__Price__c','sigmaerpdev2__Covered_under_Contract_Y_N__c','sigmaerpdev2__Unit_Price__c'})
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new set<String>{'id','sigmaerpdev2__ProductCode__c','sigmaerpdev2__Available_Qty__c'})        
    && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev2__Inventory_Status__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Order_Status__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Remaining_Qty_To_Package__c','sigmaerpdev2__Stock_Fulfilled__c','sigmaerpdev2__Back_Order__c','sigmaerpdev2__Total_Price__c','sigmaerpdev2__Total_Amount__c','sigmaerpdev2__tax_amount__c'})
    && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Service_Quote__c',new set<String>{'sigmaerpdev2__Is_Order_Created__c'})
    && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev2__Sigma_Order__c'})
    && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Service_Quote_Line_Item__c',new set<String>{'sigmaerpdev2__Service_Contract__c'})
    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Tax__c',new set<String>{'sigmaerpdev2__Type__c','sigmaerpdev2__Tax_Amount__c'})

 ){*/

 
        Double TaxOnBillAmount = 0;
        Double TaxonLineitem = 0;
        Double TaxOnBillAmountinpercentage=0;
        Account ACC;
       
        Service_Quote__c ServiceQuote ;
        List<Service_Quote_Line_Item__c> ServiceQuoteLineitem;
        List<Product_Order_Price_Book__c> OrderLineItems =new List<Product_Order_Price_Book__c>();
        ServiceQuote = [Select Id,Name,Work_Order__c,Total_Price__c,Account__c,Account__r.Name,Status__c,Work_Order__r.FFP_MR_Contact__r.name,Work_Order__r.FFP_MR_Contact__c,Is_Order_Created__c from Service_Quote__c where Id =: Orderid];
        ACC=[Select id,name,Customer_Type__c,Email__c from Account where id =:ServiceQuote.Account__c];
        
       // Contact cntObj = [select Id,Name from Contact where AccountId = :ACC.id];
        Id ServiceQuoteId=ServiceQuote.Id;
       
       
          //tax object data
          List<Tax__c> taxObj = TaxCntr.getTax(ServiceQuote.Account__c);
          Double federalTax = Double.valueOf(taxObj.get(0).Tax_Amount__c);
          String fedTaxType = String.valueOf(taxObj.get(0).Type__c);
          
          Double stateTax = Double.valueOf(taxObj.get(1).Tax_Amount__c);
          String stateTaxType = String.valueOf(taxObj.get(1).Type__c);
         
          if(fedTaxType == 'Percentage'){
              TaxOnBillAmount = (ServiceQuote.Total_Price__c * federalTax)/100;
          }else{
              TaxOnBillAmount = ServiceQuote.Total_Price__c + federalTax;
          }               
          
          
          if(stateTaxType == 'Percentage'){
              TaxOnBillAmount = (TaxOnBillAmount + (ServiceQuote.Total_Price__c * stateTax)/100);
          }else{
              TaxOnBillAmount = (TaxOnBillAmount + (ServiceQuote.Total_Price__c + stateTax));
          }        
        
        orderObj = new Sigma_Order__c ();
        //orderObj.Billing_Person__c=ServiceQuote.Work_Order__r.FFP_MR_Contact__r.name;
       // orderObj.BillingPersonNew__c = cntObj.Id;
        orderObj.BillingPersonNew__c = ServiceQuote.Work_Order__r.FFP_MR_Contact__c; //added newly on 7/7/2020
        orderObj.Service_Quote__c = ServiceQuoteId; 
        orderObj.AccountId__c=ServiceQuote.Account__c;
        orderObj.Orders_Status__c = 'Pending';
        orderObj.Order_Created_Via__c = 'Service Quote';
        orderObj.Net_Amount__c =ServiceQuote.Total_Price__c;
        orderObj.Tax_Amount__c=TaxOnBillAmount;
        orderObj.Tax__c=federalTax+stateTax;
        orderObj.Customer_Type__c = ACC.Customer_Type__c;
        orderObj.Customer_Email__c=ACC.Email__c;
        orderObj.TotalAmount__c=ServiceQuote.Total_Price__c + TaxOnBillAmount;
        orderObj.Delivary_Date__c = System.today();
        insert orderObj;
        
    
        ServiceQuoteLineitem=[Select Id,Name,Product__c,Quantity__c,Service_Contract__c,Service_Quote__c,Price__c,Covered_under_Contract_Y_N__c,Unit_Price__c from Service_Quote_Line_Item__c where Service_Quote__c =: ServiceQuote.Id];
        Map<id,Decimal> orderlinepro=new  Map<id,Decimal>();
        
        
        List<Id>prod = new List<Id>();
            for(Service_Quote_Line_Item__c productids:ServiceQuoteLineitem)
            {
            prod.add(productids.Product__c);
            }
    
        List<Inventory__c> PI = [Select id,ProductCode__c,Available_Qty__c from Inventory__c where ProductCode__c =:prod];
         decimal NoofProducts=0;
         String inventorystatus;
         Default_Parameters__c options;
       
        for(Service_Quote_Line_Item__c ServiceQuoteitem:ServiceQuoteLineitem)
        {
            Product_Order_Price_Book__c orderline = new Product_Order_Price_Book__c();
            
               if(fedTaxType == 'Percentage'){
                  TaxonLineitem = (ServiceQuoteitem.Price__c * federalTax)/100;
              }else{
                  TaxonLineitem = ServiceQuoteitem.Price__c + federalTax;
              }               
                           
              if(stateTaxType == 'Percentage'){
                  TaxonLineitem = (TaxonLineitem + (ServiceQuoteitem.Price__c * stateTax)/100);
              }else{
                  TaxonLineitem = (TaxonLineitem + (ServiceQuoteitem.Price__c + stateTax));
              }   
            
               for(Inventory__c proinv : PI)
                    {
                      if(proinv.ProductCode__c == ServiceQuoteitem.Product__c)
                        {
                        if(ServiceQuoteitem.Quantity__c > proinv.Available_Qty__c )
                         {
            decimal remainqunt=ServiceQuoteitem.Quantity__c - proinv.Available_Qty__c;
            orderline.Product__c=ServiceQuoteitem.Product__c;
            orderline.Quantity__c=ServiceQuoteitem.Quantity__c;
            orderline.Total_Amount__c=ServiceQuoteitem.Unit_Price__c;
            orderline.tax_amount__c=TaxonLineitem;
            NoofProducts+=orderline.Quantity__c;
            orderlinepro.put(orderline.Product__c,orderline.Quantity__c);
            orderline.Net_Quantity__c=proinv.Available_Qty__c;
            orderline.Total_Price__c=(orderline.Net_Quantity__c*ServiceQuoteitem.Unit_Price__c);
            orderline.Sigma_Order__c=orderObj.Id;
            orderline.Inventory_Status__c = 'Reserve';
            orderline.Remaining_Qty_To_Package__c=remainqunt;
              if(inventorystatus=='Reserve')
                            {
                            orderline.Inventory_Status__c = 'Reserve';
                            }
                            OrderLineItems.add(orderline);

                            Product_Order_Price_Book__c orderline1 = new Product_Order_Price_Book__c();
                            orderline1.Product__c=ServiceQuoteitem.Product__c;
                            orderline1.Net_Quantity__c = remainqunt;
                            orderline1.Remaining_Qty_To_Package__c=remainqunt;
                            orderline1.Total_Amount__c= ServiceQuoteitem.Unit_Price__c;
                            orderline1.Total_Price__c=(orderline1.Net_Quantity__c*ServiceQuoteitem.Unit_Price__c);
                            orderline1.Sigma_Order__c=orderObj.Id;
                            orderline1.Order_Status__c='Pending';
                            orderline1.Back_Order__c =true;
                            orderline1.Stock_Fulfilled__c = false;
                            if(inventorystatus=='Reserve')
                            {
                            orderline1.Inventory_Status__c = 'Reserve';
                            }
                            OrderLineItems.add(orderline1);
                        }
                        else
                        {
                            Product_Order_Price_Book__c orderline2 = new Product_Order_Price_Book__c();
                            orderline2.Product__c=ServiceQuoteitem.Product__c;
                            orderline2.Quantity__c=ServiceQuoteitem.Quantity__c;
                            orderline2.Total_Amount__c=ServiceQuoteitem.Unit_Price__c;
                            orderline2.Remaining_Qty_To_Package__c=ServiceQuoteitem.Quantity__c;
                            orderlinepro.put(orderline2.Product__c,orderline2.Quantity__c);
                            orderline2.Net_Quantity__c=ServiceQuoteitem.Quantity__c;
                             orderline2.Total_Price__c=(orderline2.Net_Quantity__c*ServiceQuoteitem.Unit_Price__c);
                            NoofProducts+=orderline2.Quantity__c;
                            orderline2.Sigma_Order__c=orderObj.Id;
                            orderline2.Order_Status__c='Pending';
       
                            if(inventorystatus=='Reserve')
                            {
                            orderline2.Inventory_Status__c = 'Reserve';

                            }
                            OrderLineItems.add(orderline2);
                          }
                        }
                     }
                 }
        upsert OrderLineItems;
        
        //code to create invoice records
               
                    Map<Id,Invoice_Item__c>Invoiceitemdetails = new Map<Id,Invoice_Item__c>();
                    List<Invoice_Item__c> InvoiceItemslist = new List<Invoice_Item__c>();
                    List<Invoice__c> invoicedata = [select id,name,SO__c,Invoice_Type__c,Customer__c,Invoice_Status__c,(select id,name,Invoice_Number__c,SOI__c,Quantity__c,Total_Amount__c,Product__c,Net_Amount__c,Discount__c from Invoice_Items__r) from Invoice__c where SO__c=:orderObj.id];
                     if(invoicedata.size()>0)
                		{
                            system.debug('#509 inside if');
        				for(Invoice__c inv :invoicedata)
                    	{
                        if(orderObj.Orders_Status__c=='Pending')
                        {
                            inv.Invoice_Status__c='Unpaid'; 
                        }
                        else if(orderObj.Orders_Status__c =='Canceled')
                        {
                            inv.Invoice_Status__c='Cancelled';
                        }
                        else
                        {
                            inv.Invoice_Status__c = 'paid';
                        }
                        for(Invoice_Item__c invitem:inv.Invoice_Items__r)
                        {
                            Invoiceitemdetails.put(invitem.SOI__c,invitem);
                        }
                        system.debug('Invoiceitemdetails@@'+Invoiceitemdetails);
                        
                    }
                    for(Product_Order_Price_Book__c orderline : OrderLineItems) 
                    {
                        if(Invoiceitemdetails.containsKey(orderline.id))
                        {
                            Invoice_Item__c InvoiceItems =Invoiceitemdetails.get(orderline.id);
                            InvoiceItems.Quantity__c = orderline.Net_Quantity__c;
                            InvoiceItems.Total_Amount__c=orderline.Total_Price__c;
                            InvoiceItems.Product__c=orderline.Product__c;
                            InvoiceItems.Net_Amount__c = orderline.Total_Amount__c*orderline.Net_Quantity__c;
                            if(orderline.Discounts__c!=null && orderline.Discounts__c>0)
                                InvoiceItems.Discount__c = orderline.Discounts__c;
                            InvoiceItemslist.add(InvoiceItems);
                        }
                        //system.debug('invitem@@'+invitem);
                    }
                    if(invoicedata.size()>0)
                        update invoicedata;
                    system.debug('InvoiceItemslist@@'+InvoiceItemslist);
                    if(InvoiceItemslist.size()>0)
                        upsert InvoiceItemslist;
                    
                }
                else 
                {
                    system.debug('#555 inside else');
                    Invoice__c invoice = new Invoice__c();
                    List<Invoice_Item__c>Invoiceitem = new List<Invoice_Item__c>();
                    invoice.SO__c = orderObj.id; 
                    invoice.Invoice_Type__c='Sales Invoice';
                    invoice.Customer__c =orderObj.AccountId__c; 
                    if(orderObj.Orders_Status__c=='Pending')
                    {
                        invoice.Invoice_Status__c='Unpaid'; 
                    }
                    else if(orderObj.Orders_Status__c =='Canceled')
                    {
                        invoice.Invoice_Status__c='Cancelled';
                    }
                    else
                    {
                        invoice.Invoice_Status__c = 'paid';
                    }
                    insert invoice;
                    for(Product_Order_Price_Book__c orderline : OrderLineItems)
                    {
                        Invoice_Item__c invoicedata1 = new Invoice_Item__c();
                        invoicedata1.Invoice_Number__c=invoice.id;
                        invoicedata1.SOI__c=orderline.id;
                        invoicedata1.Quantity__c = orderline.Net_Quantity__c;
                        invoicedata1.Total_Amount__c=orderline.Total_Price__c;
                        invoicedata1.Product__c=orderline.Product__c;
                        invoicedata1.Net_Amount__c = orderline.Total_Amount__c*orderline.Net_Quantity__c;
                        if(orderline.Discounts__c!=null && orderline.Discounts__c>0)
                            invoicedata1.Discount__c = orderline.Discounts__c;
                        Invoiceitem.add(invoicedata1);
                    }
                    if(Invoiceitem.size()>0)
                        insert Invoiceitem;
                }
                //CODE END
        
        
        
        Sigma_Order__c sogmaorderObj=new Sigma_Order__c() ;
            sogmaorderObj.id=orderObj.id;
            sogmaorderObj.Net_Quantity__c=NoofProducts;
            update sogmaorderObj;
        ServiceQuote.Is_Order_Created__c = true;
        update ServiceQuote;
  
 //}
        return orderObj.Id;
}


}