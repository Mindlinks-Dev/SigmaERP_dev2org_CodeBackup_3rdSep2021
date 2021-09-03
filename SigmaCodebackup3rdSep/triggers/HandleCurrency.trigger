trigger HandleCurrency on Currency__c (before insert,after update) {
    
   
        HandleCurrency chandler = new HandleCurrency();
        system.debug('inside trigger>>>'+Trigger.New);
        if(trigger.isBefore)
        {
            if(Trigger.isInsert)
            {
                chandler.onBeforeInsert(Trigger.New);
            }            
        }
        if(trigger.isAfter)
        {
            system.debug('after update1>>>'+Trigger.New);
            if(Trigger.isUpdate)
            {
                system.debug('after update2>>>'+Trigger.New);
                //chandler.handleAfterUpdate(Trigger.New);
               Map<Id,Currency__c> currencyMap = new Map<Id,Currency__c>([Select id,Name,Symbol__c,Is_Default_Currency__c,Currency_Code__c from Currency__c where id not in:Trigger.New and Is_Default_Currency__c = true]);
               system.debug('currencyMap-->>>'+currencyMap);
                Map<ID,Currency__c> nullMap = new Map<ID,Currency__c>();
                Map<id,Currency__c> maplList = new Map<id,Currency__c>();
                set<Id> currencythis = new set<Id>();
                List<Currency__c> currencyList = [Select id,Name,Symbol__c,Is_Default_Currency__c,Currency_Code__c from Currency__c where id in:Trigger.New ];
                system.debug('after update2>>>'+currencyList);
                for(Currency__c listCurr :currencyList){
                    if(listCurr.Is_Default_Currency__c==true){
                        maplList.put(listCurr.Id,listCurr);
                    }                       
                }               
                
                for(Currency__c newcurrency : currencyMap.values() ){
                    if(newcurrency.Is_Default_Currency__c==true)
                    {
                        nullMap.put(newcurrency.Id,newcurrency);
                        system.debug('after update2>>>'+nullMap);
                    } 
                }
                if(maplList.size() >0 && nullMap.size() >0 )
                { 
                    for(Currency__c sC :Trigger.new){
                        sC.addError('Please Uncheck already Existing Default currency  to make this currency default!!!');
                    }                 
                }                
            } 
            
          /*if(Trigger.isInsert)
            {
                system.debug('after update2>>>'+Trigger.New);
                chandler.onAfterInsert(Trigger.New);
            }*/
        }
        
}