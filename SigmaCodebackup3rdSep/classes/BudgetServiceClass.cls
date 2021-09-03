/*=====================================================================================================
Author     : Vidit Kumar
Company    : Mindlinks Solution Pvt Ltd.
Date       : 18 Jul 2018
Description: Creates Budget Transactions, to be used by Scheduler BudgetSchedule 
=======================================================================================================*/

global with sharing class BudgetServiceClass  
{
    
    public Date currentDate = date.today();

    public BudgetServiceClass()
    {
        
    }
    
    public void createBudgetTransaction()
    {
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Purchase_Order_Product__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Budget__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Budget_Items__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Budget_Transaction__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Expenditure__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new Set<String>{'id' ,'name','RecordType.name'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'id' ,'name','sigmaerpdev__Total_Price__c', 'sigmaerpdev__Product__c', 'sigmaerpdev__Quantity__c', 'sigmaerpdev__Sigma_Order__r.RecordType.name','sigmaerpdev__Sigma_Order__r.sigmaerpdev__Orders_Status__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Budget__c',new Set<String>{'id' ,'name','sigmaerpdev__Budget_Type__c','sigmaerpdev__Group__c','sigmaerpdev__Region__c','sigmaerpdev__Active__c','sigmaerpdev__FY_End_Date__c','sigmaerpdev__FY_Start_Date__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Budget_Items__c',new Set<String>{'id' ,'name','sigmaerpdev__Amount__c', 'sigmaerpdev__Product__c', 'sigmaerpdev__Project__c', 'sigmaerpdev__Quantity__c', 'sigmaerpdev__Budget__r.Budget_Type__c', 'sigmaerpdev__Budget__r.Resource__c','sigmaerpdev__Budget__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Budget_Transaction__c',new Set<String>{'id' ,'name','sigmaerpdev__POP__c', 'sigmaerpdev__Amt_in_PO__c', 'sigmaerpdev__PO_Quantity__c', 'sigmaerpdev__Order_Line__c', 'sigmaerpdev__Amt_in_SO__c', 'sigmaerpdev__SO_Quantity__c', 'sigmaerpdev__Expenditure__c', 'sigmaerpdev__Amt_in_project__c', 'sigmaerpdev__Transaction_Type__c','sigmaerpdev__Budget_Item__r.sigmaerpdev__Budget__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Expenditure__c',new Set<String>{'id' ,'name','sigmaerpdev__Amount__c', 'sigmaerpdev__Project__c','sigmaerpdev__Status__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Budget_Transaction__c',new set<String>{'sigmaerpdev__POP__c', 'sigmaerpdev__Amt_in_PO__c', 'sigmaerpdev__PO_Quantity__c', 'sigmaerpdev__Order_Line__c', 'sigmaerpdev__Amt_in_SO__c', 'sigmaerpdev__SO_Quantity__c', 'sigmaerpdev__Expenditure__c', 'sigmaerpdev__Amt_in_project__c', 'sigmaerpdev__Transaction_Type__c'})  
        && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev__Budget_Transaction__c',new set<String>{'sigmaerpdev__Budget_Item__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Purchase_Order_Product__c',new set<String>{'id','name','sigmaerpdev__Buying_Price__c','sigmaerpdev__Total_Price__c','sigmaerpdev__Product__c','sigmaerpdev__Quantity__c','sigmaerpdev__Sigma_Order__r.RecordType.name','sigmaerpdev__Purchase_Order__r.sigmaerpdev__Status__c'})
        )
        {
            List<Budget__c> budgetList = new List<Budget__c>([select id,name,Budget_Type__c,Group__c,Region__c from Budget__c where Active__c = true and FY_End_Date__c >: currentDate and FY_Start_Date__c <=: currentDate]);
            
            Set<Id> budgetIds = new Set<Id>();
            for(Budget__c b: budgetList)
            {
                budgetIds.add(b.id);
            }
            
            List<Budget_Items__c> budgetItemsList = new List<Budget_Items__c>([select id,name,Amount__c,Product__c,Project__c,Quantity__c,Budget__r.Budget_Type__c,Budget__r.Resource__c from Budget_Items__c where Budget__c IN: budgetIds]);
            
            List<Budget_Transaction__c> budgetTransToBeUpserted = new List<Budget_Transaction__c>();
            List<Budget_Transaction__c> budgetTransList = [Select id,name,POP__c,Amt_in_PO__c,PO_Quantity__c, Order_Line__c,Amt_in_SO__c,SO_Quantity__c, Expenditure__c,Amt_in_project__c, Transaction_Type__c from Budget_Transaction__c where Budget_Item__r.Budget__c IN: budgetIds ];
            
            DateTime freshSchedule = System.now();
            DateTime scheduleBeforeHours = freshSchedule.addHours(-25);
            
            Map<Id,Purchase_Order_Product__c> POPMap = new Map<Id,Purchase_Order_Product__c>([Select id,name,Buying_Price__c,Product__c,Quantity__c from Purchase_Order_Product__c where ( LastModifieddate >=: scheduleBeforeHours ) and Purchase_Order__r.Status__c=:'Submitted' ]);
            
            List<String> acceptableSigmaOrderStatus = new List<String>();
            acceptableSigmaOrderStatus.add('Order Confirmed');
            acceptableSigmaOrderStatus.add('Delivered');
            acceptableSigmaOrderStatus.add('Ready To Ship');
            acceptableSigmaOrderStatus.add('Shipped');
            Map<Id,Product_Order_Price_Book__c> SOLIMap = new Map<Id,Product_Order_Price_Book__c>([Select id,name,Total_Price__c,Product__c,Quantity__c,Sigma_Order__r.RecordType.name from Product_Order_Price_Book__c where ( LastModifieddate >=: scheduleBeforeHours ) and (Sigma_Order__r.Orders_Status__c IN:acceptableSigmaOrderStatus ) ]);

            Map<Id,Expenditure__c> expenditureMap = new Map<Id,Expenditure__c>([Select id,name,Project__c,Status__c,Amount__c from Expenditure__c where ( LastModifieddate >=: scheduleBeforeHours ) AND (Status__c =: 'Approved') ]);
            
            //to insert budget transaction - 
            for( Budget_Items__c bi:budgetItemsList )
            {
                if(bi.Budget__r.Budget_Type__c == 'Budget - Purchase')
                {
                    for( Id pop:POPMap.keyset() )
                    {
                        if( bi.Product__c == POPMap.get(pop).Product__c )
                        {
                            Budget_Transaction__c bt = new Budget_Transaction__c();
                            bt.Budget_Item__c = bi.Id;
                            bt.POP__c = pop;
                            bt.Amt_in_PO__c = POPMap.get(pop).Buying_Price__c;
                            bt.PO_Quantity__c = decimal.valueOf( POPMap.get(pop).Quantity__c );
                            bt.Transaction_Type__c = 'Purchase Order';
                            budgetTransToBeUpserted.add(bt);
                        }
                    }
                }
                
                if(bi.Budget__r.Budget_Type__c == 'Sales Target')
                {
                    for( Id soli:SOLIMap.keyset() )
                    {
                        if( bi.Product__c == SOLIMap.get(soli).Product__c  && SOLIMap.get(soli).Sigma_Order__r.RecordType.name !='Service Order' )
                        {
                            Budget_Transaction__c bt = new Budget_Transaction__c();
                            bt.Budget_Item__c = bi.Id;
                            bt.Order_Line__c = soli;
                            bt.Amt_in_SO__c = SOLIMap.get(soli).Total_Price__c;
                            bt.SO_Quantity__c = SOLIMap.get(soli).Quantity__c;
                            bt.Transaction_Type__c = 'Sigma Order';
                            budgetTransToBeUpserted.add(bt);
                        }
                    }
                }
                
                if(bi.Budget__r.Budget_Type__c == 'Budget - Delivery')
                {
                    for( Id exp:expenditureMap.keyset() )
                    {
                        if( bi.Project__c == expenditureMap.get(exp).Project__c )
                        {
                            Budget_Transaction__c bt = new Budget_Transaction__c();
                            bt.Budget_Item__c = bi.Id;
                            bt.Expenditure__c = exp;
                            bt.Amt_in_project__c = expenditureMap.get(exp).Amount__c;
                            bt.Transaction_Type__c = 'Service Order';
                            budgetTransToBeUpserted.add(bt);
                        }
                    }
                }
            }
            //to remove duplicate records
            for( Budget_Transaction__c existingbt:budgetTransList )
            {
                Integer j = 0;
                while (j < budgetTransToBeUpserted.size())
                {
                    if(budgetTransToBeUpserted.get(j).POP__c == existingbt.POP__c && budgetTransToBeUpserted.get(j).Transaction_Type__c == 'Purchase Order' )
                    {
                        budgetTransToBeUpserted.remove(j);
                    }
                    else if(budgetTransToBeUpserted.get(j).Order_Line__c == existingbt.Order_Line__c && budgetTransToBeUpserted.get(j).Transaction_Type__c == 'Sigma Order' )
                    {
                        budgetTransToBeUpserted.remove(j);
                    }
                    else if(budgetTransToBeUpserted.get(j).Expenditure__c == existingbt.Expenditure__c && budgetTransToBeUpserted.get(j).Transaction_Type__c == 'Service Order' )
                    {
                        budgetTransToBeUpserted.remove(j);
                    }
                    else
                    {
                        j++;
                    }
                }
            }

            try
            {
                upsert budgetTransToBeUpserted;
            }
            catch(Exception e)
            {
                System.debug('BudgetServiceClass exception' + e.getmessage() );
            }
        }
    }
    
    public void BudgetNotification()
    {
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Budget__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Budget__c',new Set<String>{'id' ,'name', 'sigmaerpdev__Budget_Type__c','sigmaerpdev__Budget_Name__c','sigmaerpdev__Financial_Year__c','sigmaerpdev__Group__c','sigmaerpdev__Region__c','Budget_Achieved_Percent__c','sigmaerpdev__Resource__c','sigmaerpdev__Resource__r.Email','sigmaerpdev__Resource__r.name','sigmaerpdev__Active__c','sigmaerpdev__FY_End_Date__c','sigmaerpdev__FY_Start_Date__c','sigmaerpdev__Budget_Achieved_Percent__c'})
        )
        {
            List<Budget__c> budgetList = new List<Budget__c>([select id,name,Budget_Type__c,Group__c,Region__c,Budget_Name__c,Financial_Year__c,Budget_Achieved_Percent__c,Resource__c,Resource__r.name,Resource__r.Email from Budget__c where Active__c = true and FY_End_Date__c >: currentDate and FY_Start_Date__c <=: currentDate]);
            
            try 
            {
                Boolean saveAsActivity = false;
                for(Budget__c b:budgetList)
                {
                    if((b.Budget_Achieved_Percent__c >=75 && b.Budget_Achieved_Percent__c <=80) || (b.Budget_Achieved_Percent__c >=90 && b.Budget_Achieved_Percent__c <=95) || (b.Budget_Achieved_Percent__c >= 100))
                    {
                        List<String> toRecipients = new List<String>();
                        toRecipients.add(b.Resource__r.Email);
                        
                        
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setToAddresses(toRecipients);
                        String body = '';
                        if(b.Budget_Achieved_Percent__c >= 100)
                        {
                            body = 'The Budget plan with name "'+b.Budget_Name__c+ '" planned for financial year '+b.Financial_Year__c+' has crossed the planned amount and reached '+b.Budget_Achieved_Percent__c+'% of the total planned amount.';
                        }
                        else
                        {
                            body = 'The Budget plan with name "'+b.Budget_Name__c+ '" planned for financial year '+b.Financial_Year__c+' has reached '+b.Budget_Achieved_Percent__c+'% of the total planned amount.';
                        }
                        email.setSubject('Budget Amount Consumption has reached '+b.Budget_Achieved_Percent__c);
                        email.setHtmlBody('Hi ' + b.Resource__r.name +'<br/><br/>'+ body + '<br/><br/> Thanks');
                        
                        //email.setSaveAsActivity(saveAsActivity);      // save email as activity on the targetObjId (i.e. Contact). Note activity can't be saved on Users
                        
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                    }
                }
            
                
            }
            catch(EmailException e)
            {
                System.debug('EmailException:' + e);
            }
        }
    }
}