/*=====================================================================================================
Author     : Rashmi Degavi
Company    : Mindlinks Solution Pvt Ltd.
Date       : 13 Aug 2019
Description: Trigger to Generate Auto PO Based on Threshold Quantity,
             Based on Available quantity in Sales Order,
             Based on Interval time  and  To update Inventory Transactions after every Transaction
=======================================================================================================*/

trigger ManageInventoryTransactions on Inventory__c (after insert,after update) {
    
    system.debug('inside manage');
    List<Inventory__c> newInventory = new List<Inventory__c>();
    newInventory = Trigger.New;
    List<Inventory__c> oldInventory = new List<Inventory__c>();
    oldInventory = Trigger.Old;
    
    System.debug('Product StockIns Map  '+newInventory );
    System.debug('Product StockIns List  '+oldInventory );
    
    TriggerHandler triggerHandler1 = new TriggerHandler();
    system.debug('calling manageInventoryTransactions by TriggerHandler');
    triggerHandler1.manageInventoryTransactions(newInventory,Trigger.OldMap,Trigger.isInsert,Trigger.isUpdate);
    
    //Added new
    System.debug('Only one time execution::::  ' );
    //triggerHandler1.handleWebAvailable(newInventory,oldInventory,Trigger.isInsert,Trigger.isUpdate);
    System.debug('TriggerHandler.isBOMtoIndvidual>>>'+TriggerHandler.isBOMtoIndvidual);
    if(TriggerHandler.isBOMtoIndvidual=='BOMTOINDIVIDUAL')  
    {
        system.debug('came in');
        triggerHandler1.handleAvailableqty(newInventory,oldInventory ,Trigger.isUpdate); 
    }  
    else if(TriggerHandler.isBOMtoIndvidual=='BOMTOINDIVIDUALSTOP')
    {
        system.debug('BOMTOINDIVIDUALSTOP stopped');
    }else
    {
        system.debug('came to else');
        triggerHandler1.handleAvailableqty(newInventory,oldInventory ,Trigger.isUpdate); 
        
    }
    
    if(trigger.isAfter)
    {
        if(Trigger.isUpdate)
        {
            try
            {
                system.debug('inside Inventory Trigger');
                Set<Id> prodids=new Set<Id>();
                system.debug('Product Ids>>' + prodids);
                for(Inventory__c inv : newInventory)
                {
                    prodids.add(inv.ProductCode__c);
                }
                system.debug('Product Ids>>' + prodids);
                Map<Id,List<Purchase_Order_Product__c>> POMap=new Map<Id,List<Purchase_Order_Product__c>>();
                List<Purchase_Order_Product__c> popList=[select id,Product__c,Product__r.Name,Purchase_Order__c,Purchase_Order__r.Name,Orderd_Quantity__c,Remaining_to_come__c,
                                                      Received_Quantity__c,Status__c from Purchase_Order_Product__c
                                                      where Status__c='Partial Delivery' and Received_Quantity__c >0
                                                      and Product__c in :prodids];
                for(Purchase_Order_Product__c popli :popList )
                {
                    if(POMap.containsKey(popli.Product__c))
                    {
                        POMap.get(popli.Product__c).add(popli);
                        system.debug('After check1>>' + POMap);
                    }
                    
                    else
                    {
                        POMap.put(popli.Product__c,new List<Purchase_Order_Product__c>{popli});
                        system.debug('After check2>>' + POMap);
                    }
                }
                //code added to check default vendor to create auto po on 22-08-2019
                Default_Parameters__c dp=[select Default_Vendor__c,Vendor_Rating__c from Default_Parameters__c Limit 1];
                List<Purchase_Order__c> po=new List<Purchase_Order__c>();
                List<Purchase_Order_Product__c> pop=new List<Purchase_Order_Product__c>();
                List<Vendor_Product__c> vendorprod= new List<Vendor_Product__c>();
                Map<Id,Id> mapVendorProd=new Map<Id,Id>();
                if(dp.Default_Vendor__c==true)
                {
                    system.debug('Auto PO Based on Default vendor'+dp.Default_Vendor__c);
                    vendorprod=[select id,Name,Product_Name__c,Product_Name__r.Reorder_Quantity__c,Product_Name__r.Quantity__c,Account_Name__c,Account_Name__r.Name,Account_Name__r.Email__c,Selling_Price__c,Buying_Price__c,Is_Preferred__c from Vendor_Product__c where Is_Preferred__c=true and Product_Name__c in :prodids  ];
                    system.debug('Vendor Product >> ' +vendorprod);
                    
                    //code added to check Default vendor name based on productid on 21-08-2019
                    for(Vendor_Product__c checkdefaultVendor: vendorprod)
                    {
                        if(checkdefaultVendor.Is_Preferred__c = true )
                        {
                            mapVendorProd.put(checkdefaultVendor.Product_Name__c,checkdefaultVendor.Account_Name__c);
                            System.debug('mapVendorProd >>>' +mapVendorProd);
                        }           
                    }
                }
                else if(dp.Vendor_Rating__c==true)
                {
                    system.debug('Auto PO Based on Vendor Rating'+dp.Vendor_Rating__c);
                    //create auto PO based on Vendor Rating
                    vendorprod=[select id,Name,Product_Name__c,Product_Name__r.Reorder_Quantity__c,Product_Name__r.Quantity__c,Account_Name__c,Account_Name__r.Name,Account_Name__r.Email__c,Selling_Price__c,Buying_Price__c,Account_Name__r.Overall_Vendor_Rating__c from Vendor_Product__c where Product_Name__c in :prodids ORDER BY Account_Name__r.Overall_Vendor_Rating__c DESC Limit 1];
                    system.debug('Vendor Product >> ' +vendorprod);
                    
                    //code added to  check Vendor Rating provided by vendor based on product on 20-08-2019
                    for(Vendor_Product__c checkRating: vendorprod)
                    {
                            System.debug('mapVendorProd >>>' +mapVendorProd.put(checkRating.Product_Name__c,checkRating.Account_Name__c));
                            mapVendorProd.put(checkRating.Product_Name__c,checkRating.Account_Name__c);
                            System.debug('mapVendorProd >>>' +mapVendorProd);
                    }
                }
                else
                {
                     System.debug('Sorry! couldnt able to generate Auto PO.');
                }
                    
                Map<Id,Product2> ProdMap = new Map<Id,Product2>([select id,Name,Create_AutoPO__c,Threshold_Quantity__c,Reorder_Quantity__c from Product2 where id in : prodids]);
                System.debug('ProdMap >>>' +ProdMap);
                List<String> EmailId = new List<String>();
                for (Vendor_Product__c myAccount : vendorprod ) 
                {   
                    if (myAccount.Account_Name__c!= null )
                    {
                        EmailId.add(myAccount.Account_Name__r.Email__c);
                        System.debug('Email >>>' +EmailId);
                    }
                }
                for(Inventory__c inv : Trigger.new)
                {
                    //code added to stop auto PO after Stock receiving (Access the "old" record by its ID in Trigger.oldMap ) on 21-08-2019
                    map<Id,Inventory__c> oldMap=Trigger.oldMap;
                    system.debug('oldMap>>' + oldMap);
                    if(ProdMap.get(inv.ProductCode__c).Create_AutoPO__c==true)
                    {
                        system.debug('Create auto po for this product>>' + ProdMap.get(inv.ProductCode__c).Create_AutoPO__c);
                        system.debug('available quantity in inventory1>>' + oldMap.get(inv.id).Available_Qty__c);
                        system.debug('available quantity in inventory2>>' + inv.Available_Qty__c);
                        system.debug('available quantity in inventory3>>' + ProdMap.get(inv.ProductCode__c).Threshold_Quantity__c);
                        
                        if(oldMap.get(inv.id).Available_Qty__c!=inv.Available_Qty__c && inv.Available_Qty__c <= ProdMap.get(inv.ProductCode__c).Threshold_Quantity__c)
                        {
                            system.debug('available quantity in inventory' +inv.Available_Qty__c);
                            system.debug('available quantity in Product' +ProdMap.get(inv.ProductCode__c).Threshold_Quantity__c);
                           
                            //code to check whether any PO with remaining qty exist or not if exist send email notification
                            if(POMap.containsKey(inv.ProductCode__c))
                            {
                                system.debug('Inside email body');
                                system.debug('POMap' +inv.ProductCode__c);
                              
                                List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                                Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                                mail.setToAddresses(EmailId);
                                mail.setReplyTo('dev@mindlinkssolution.com');
                                mail.setSenderDisplayName('Generating Auto PO Failed!!');
                                List<String> ccTo = new List<String>();
                                ccTo.add('dev@mindlinkssolution.com');
                                mail.setCcAddresses(ccTo);
                                mail.setSubject('Can not Generate Auto PO');
                                string poName='';
                                String prodName='';
                                for(Purchase_Order_Product__c popemail:POMap.get(inv.ProductCode__c))
                                {
                                    poName+=popemail.Purchase_Order__r.Name+',';
                                    prodName+=popemail.Product__r.Name+',';
                                }
                                poName.removeEnd(',');
                                prodName.removeEnd(',');
                                String body = 'Dear '+vendorprod[0].Account_Name__r.Name+','+'<br /><br />'+' We request you to Receive remaining quantities from the Existiong PO or old PO which is not yet all Used. '+'<br /><br />'+' Purchase Order No: '+poName+'.'+'<br />'+' Product Name:  '+prodName+'<br />'+
                                'Please Make use of Existing POs.'+'<br /> <br />'+'Thank you'+'<br />'+'Team Sigma';
                                mail.setHtmlBody(body);
                                mails.add(mail);
                                Messaging.sendEmail(mails);
                            }
                            else
                            {
                                //code to create auto po after PI reaches threshold qty
                                system.debug('Inside else');
                                Purchase_Order__c porder=new Purchase_Order__c();
                                System.debug('product code in new inventory>>'+inv.ProductCode__c);
                                porder.Product_Supplier__c=mapVendorProd.get(inv.ProductCode__c);
                                porder.Status__c='Submitted';
                                porder.Expected_Date__c=System.today()+20;
                                porder.Order_Date__c=System.today();
                                system.debug('Expected_Date__c>>'+ porder.Expected_Date__c);
                                system.debug('Order_Date__c>>'+ porder.Order_Date__c);
                                po.add(porder);
                                system.debug('Purchase_Order>>'+po);
                                
                                Purchase_Order_Product__c poplineitem=new Purchase_Order_Product__c();
                                poplineitem.Product__c=inv.ProductCode__c;
                                poplineitem.Status__c='Open';
                                poplineitem.Quantity__c=String.valueOf(ProdMap.get(inv.ProductCode__c).Reorder_Quantity__c);
                                poplineitem.Received_Quantity__c=ProdMap.get(inv.ProductCode__c).Reorder_Quantity__c;
                                poplineitem.Remaining_to_come__c=0;
                                poplineitem.Expected_Delivery_Date__c=System.today()+20;
                                poplineitem.VendorPrice__c=vendorprod[0].Buying_Price__c;
                                poplineitem.Total_Buying_Price__c=vendorprod[0].Buying_Price__c*ProdMap.get(inv.ProductCode__c).Reorder_Quantity__c;
                                poplineitem.Buying_Price__c=vendorprod[0].Buying_Price__c*ProdMap.get(inv.ProductCode__c).Reorder_Quantity__c;
                                
                                system.debug('Remaining_to_come__c>>'+poplineitem.Remaining_to_come__c);
                                system.debug('Total_Buying_Price__c>>'+ poplineitem.Total_Buying_Price__c);
                                system.debug('Quantity__c>>'+poplineitem.Quantity__c);
                                system.debug('Buying_Price__c>>'+ poplineitem.Total_Buying_Price__c);
                                
                                pop.add(poplineitem);
                                system.debug('Purchase_Order_Product>>'+pop);
                            }
                        }
                    }
                }
                insert po;
                system.debug('After insert>> '+po);
                for(Integer i=0;i<po.size();i++)
                {
                    pop[i].Purchase_Order__c=po[i].id;
                    system.debug('iteration>> '+i);
                }
                insert pop;
                system.debug('After insert>> '+pop);
            }
            catch(exception e)
            {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
    }
    
    //triggerHandler.sendMailOnInventory(newInventory,oldInventory ,Trigger.isInsert,Trigger.isUpdate);
   
}