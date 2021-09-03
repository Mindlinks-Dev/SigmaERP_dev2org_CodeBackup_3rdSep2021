trigger updateExpenditure on Inventory_Consumption__c (after insert, after update, before delete) 
{
 if(trigger.isInsert)
    {
        List<Id> projectsIds = new List<Id>();
        For(Inventory_Consumption__c a : Trigger.new)
        {
            if(a.Project__c != null)
                projectsIds.add(a.Project__c);
        }   
        
        Map<String, String> ProjectIdAndExpenditureIds = new Map<String, String>();
        List<Expenditure__c> expenditureList= [select id, Name,Project__c from Expenditure__c where Project__c In : projectsIds];
        for(Expenditure__c expRec : expenditureList)
        {
            ProjectIdAndExpenditureIds.put(expRec.Project__c, expRec.Id);
        }
          
        Map<Id, Decimal> expenditureWithQty = new Map<Id, Decimal>();
        for (Inventory_Consumption__c a : Trigger.new) 
        {
            if(ProjectIdAndExpenditureIds.containsKey(a.Project__c))
            {
                if(expenditureWithQty.containsKey(ProjectIdAndExpenditureIds.get(a.Project__c)))
                {
                    Decimal existingQty = expenditureWithQty.get(ProjectIdAndExpenditureIds.get(a.Project__c));
                    expenditureWithQty.put(ProjectIdAndExpenditureIds.get(a.Project__c), existingQty + a.Total_Billing_amount_of_Reserved_Product__c);
                }
                else
                    expenditureWithQty.put(ProjectIdAndExpenditureIds.get(a.Project__c), a.Total_Billing_amount_of_Reserved_Product__c);
            }
        }
        
        //Validation
        for(Inventory_Consumption__c a : Trigger.new)
        {
            if(!ProjectIdAndExpenditureIds.containsKey(a.Project__c))
                a.Project__c.addError('please enter the expenditure for this project');
        }
      
        List<Expenditure__c> expenditure = [select id, Inventory_Expenditure__c from Expenditure__c where Id In : expenditureWithQty.keySet()];
        for(Expenditure__c exp : expenditure)
        {
            if(exp.Inventory_Expenditure__c != null)
                exp.Inventory_Expenditure__c = exp.Inventory_Expenditure__c + expenditureWithQty.get(exp.Id);
            else 
                exp.Inventory_Expenditure__c = expenditureWithQty.get(exp.Id);
        }
        update expenditure;
    }

    if(trigger.isUpdate)
    {
        
        List<Id> projectsIds = new List<Id>();
        For(Inventory_Consumption__c a : Trigger.new)
        {
            if(a.Project__c != null)
                projectsIds.add(a.Project__c);
        }   
        
        Map<String, String> ProjectIdAndExpenditureIds = new Map<String, String>();
        List<Expenditure__c> expenditureList= [select id, Name,Project__c from Expenditure__c where Project__c In : projectsIds];
        for(Expenditure__c expRec : expenditureList)
        {
            ProjectIdAndExpenditureIds.put(expRec.Project__c, expRec.Id);
        }
        
        Map<Id, Decimal> expenditureWithQty = new Map<Id, Decimal>();
        for (Inventory_Consumption__c a : Trigger.new) 
        {
            if(ProjectIdAndExpenditureIds.containsKey(a.Project__c))
            {
                if(expenditureWithQty.containsKey(ProjectIdAndExpenditureIds.get(a.Project__c)))
                {
                    Decimal existingQty = expenditureWithQty.get(ProjectIdAndExpenditureIds.get(a.Project__c));
                    expenditureWithQty.put(ProjectIdAndExpenditureIds.get(a.Project__c), existingQty + a.Total_Billing_amount_of_Reserved_Product__c);
                }
                else
                    expenditureWithQty.put(ProjectIdAndExpenditureIds.get(a.Project__c), a.Total_Billing_amount_of_Reserved_Product__c);
            }
        }
        
        Map<Id, Decimal> expenditureWithQtyOld = new Map<Id, Decimal>();
        for (Inventory_Consumption__c a : Trigger.old) 
        {
            if(ProjectIdAndExpenditureIds.containsKey(a.Project__c))
            {
                if(expenditureWithQtyold.containsKey(ProjectIdAndExpenditureIds.get(a.Project__c)))
                {
                    Decimal existingQty= expenditureWithQtyold.get(ProjectIdAndExpenditureIds.get(a.Project__c));
                    expenditureWithQtyold.put(ProjectIdAndExpenditureIds.get(a.Project__c), existingQty + a.Total_Billing_amount_of_Reserved_Product__c);
                }
                else
                    expenditureWithQtyold.put(ProjectIdAndExpenditureIds.get(a.Project__c), a.Total_Billing_amount_of_Reserved_Product__c);
            }
        }
        

                
        List<Expenditure__c> expenditure = [select id, Inventory_Expenditure__c from Expenditure__c where Id In : expenditureWithQty.keySet()];
        for(Expenditure__c exp : expenditure)
        {
            if(exp.Inventory_Expenditure__c != null)
                exp.Inventory_Expenditure__c = exp.Inventory_Expenditure__c + expenditureWithQty.get(exp.Id)-expenditureWithQtyold.get(exp.Id) ;
            else 
                exp.Inventory_Expenditure__c = expenditureWithQty.get(exp.Id);
        }
        update expenditure;
    }


  if(trigger.isDelete)
    {
        List<Id> projectsIds = new List<Id>();
        For(Inventory_Consumption__c a : Trigger.old)
        {
            if(a.Project__c != null)
                projectsIds.add(a.Project__c);
        }   
        
        Map<String, String> ProjectIdAndExpenditureIds = new Map<String, String>();
        List<Expenditure__c> expenditureList= [select id, Name, Project__c from Expenditure__c where Project__c In : projectsIds];
        for(Expenditure__c expRec : expenditureList)
        {
            ProjectIdAndExpenditureIds.put(expRec.Project__c, expRec.Id);
        }
        
        Map<Id, Decimal> expenditureWithQty = new Map<Id, Decimal>();
        for (Inventory_Consumption__c a : Trigger.old) 
        {
            if(ProjectIdAndExpenditureIds.containsKey(a.Project__c))
            {
                if(expenditureWithQty.containsKey(ProjectIdAndExpenditureIds.get(a.Project__c)))
                {
                    Decimal existingQty = expenditureWithQty.get(ProjectIdAndExpenditureIds.get(a.Project__c));
                    expenditureWithQty.put(ProjectIdAndExpenditureIds.get(a.Project__c), existingQty - a.Total_Billing_amount_of_Reserved_Product__c);
                }
                else
                    expenditureWithQty.put(ProjectIdAndExpenditureIds.get(a.Project__c), a.Total_Billing_amount_of_Reserved_Product__c);
            }
        }
        
        List<Expenditure__c> expenditure = [select id, Inventory_Expenditure__c from Expenditure__c where Id In : expenditureWithQty.keySet()];
        for(Expenditure__c exp : expenditure)
        {
            if(exp.Inventory_Expenditure__c != null)
                exp.Inventory_Expenditure__c = exp.Inventory_Expenditure__c - expenditureWithQty.get(exp.Id);
            else 
                exp.Inventory_Expenditure__c = expenditureWithQty.get(exp.Id);
        }
        update expenditure;
    }


    
    
}