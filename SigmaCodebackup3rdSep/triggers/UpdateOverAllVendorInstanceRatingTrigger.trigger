trigger UpdateOverAllVendorInstanceRatingTrigger on Vendor_Incidence__c (before insert,after insert, after update, after delete, after undelete)
{
    Set<ID> setOfAccountIDs = new Set<ID>();
    List<Account> lstAcc = new List<Account>();
    if(trigger.isinsert || trigger.isundelete){
        for(Vendor_Incidence__c vi : trigger.new){
            setOfAccountIDs.add(vi.Vendor_Name1__c);
        }
    }
    else if(trigger.isDelete){
        for(Vendor_Incidence__c vi : trigger.old){
            setOfAccountIDs.add(vi.Vendor_Name1__c);
        }
    }
    else if(trigger.isUpdate){
        for(Vendor_Incidence__c vi : trigger.new){
            if(vi.Vendor_Name1__c != null){
                if(trigger.oldmap.get(vi.id).Vendor_Name1__c != vi.Vendor_Name1__c){
                    setOfAccountIDs.add(vi.Vendor_Name1__c);     
                }
            } 
            setOfAccountIDs.add(trigger.oldmap.get(vi.id).Vendor_Name1__c);
        }
    }
    if(setOfAccountIDs.size() > 0){
        lstAcc = [Select id,Overall_Vendor_Incidence_Rating__c,Count_Of_Vendor_Incidences__c,(Select id,Overall_Rating__c from Vendor_Incidences__r WHERE CreatedDate = LAST_N_DAYS:30) from Account where id IN : setOfAccountIDs];
    }
    for(Account acc : lstAcc){
        Double val = 0;
        for(Vendor_Incidence__c vi : acc.Vendor_Incidences__r){
            if(vi.Overall_Rating__c!=null)
                val += vi.Overall_Rating__c;
        }
        acc.Overall_Vendor_Incidence_Rating__c = val;
        acc.Count_Of_Vendor_Incidences__c=acc.Vendor_Incidences__r.size();
    }
    update lstAcc;
}