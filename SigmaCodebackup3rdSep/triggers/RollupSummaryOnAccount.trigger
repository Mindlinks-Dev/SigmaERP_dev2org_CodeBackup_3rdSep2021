trigger RollupSummaryOnAccount on Vendor_Evaluation__c (after insert, after update, after delete, after undelete)
{
    Set<ID> setOfAccountIDs = new Set<ID>();
    List<Account> lstAcc = new List<Account>();
     if(trigger.isinsert || trigger.isundelete)
     {
        for(Vendor_Evaluation__c ve : trigger.new){
            setOfAccountIDs.add(ve.Vendor_Name1__c);
        }
    }
    else if(trigger.isDelete){
        for(Vendor_Evaluation__c ve : trigger.old){
            setOfAccountIDs.add(ve.Vendor_Name1__c);
        }
    }
    
    else if(trigger.isUpdate){
         for(Vendor_Evaluation__c ve : trigger.new){
            if(ve.Vendor_Name1__c != null){
                if(trigger.oldmap.get(ve.id).Vendor_Name1__c != ve.Vendor_Name1__c){
                    setOfAccountIDs.add(ve.Vendor_Name1__c);     
                }
            } 
            setOfAccountIDs.add(trigger.oldmap.get(ve.id).Vendor_Name1__c);
         }
    }
    if(setOfAccountIDs.size() > 0){
        lstAcc = [Select id,Overall_Vendor_Evaluation_Rating__c,(Select id,name,Delivery_Rating__c from Vendor_Evaluations__r WHERE CreatedDate = LAST_N_DAYS:30 ) from Account where id IN : setOfAccountIDs];
    }
    for(Account acc : lstAcc){
        Double val = 0;
        for(Vendor_Evaluation__c ve : acc.Vendor_Evaluations__r){
            
            val += ve.Delivery_Rating__c;
            
        }
        acc.Overall_Vendor_Evaluation_Rating__c = val;
        acc.Count_Of_Vendor_Evaluations__c=acc.Vendor_Evaluations__r.size();
    }
    update lstAcc;
    
}