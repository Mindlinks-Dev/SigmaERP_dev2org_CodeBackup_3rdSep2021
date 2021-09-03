public with sharing class HandleCurrency
{
    public void onBeforeInsert(List<Currency__c> currencies)
    {
    if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Currency__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Currency__c',new set<String>{'id','Name','sigmaerpdev__Symbol__c','sigmaerpdev__Is_Default_Currency__c','sigmaerpdev__Currency_Code__c'})){
        
        Set<String> nameids=new Set<String>();
        Set<String> symids=new Set<String>();
        
        Boolean isPreferedExist=false;
        for(Currency__c currency1 : currencies)
        {
            nameids.add(currency1.Name);
            symids.add(currency1.Symbol__c);
        

            if(currency1.Is_Default_Currency__c)
            {
                isPreferedExist=true;
            }
        }
    
    List<Currency__c> curdata=[Select id,Name,Symbol__c,Is_Default_Currency__c,Currency_Code__c from Currency__c where Is_Default_Currency__c=true];
        
        if(curdata.size()==0)
        {
            
            for(Currency__c default1 : currencies)
            {
                
                if(default1.Is_Default_Currency__c==false)
                {             
                    
                    currencies[0].addError('Please Check Is Default currency to make this currency as default');
                }
                else
                    system.debug('Do Nothing...');
            }
        }
        if(isPreferedExist)
        {
            for(Currency__c default1 : curdata)
            {
                if(default1.Is_Default_Currency__c)
                {
                    
                     currencies[0].Is_Default_Currency__c.adderror('Please Uncheck already Existing Default currency to make this currency default!!');
               System.debug(currencies);
                }
                else{
                    system.debug('Do Nothing...');
                }
            }
              
        }
        
        Map<String,List<String>> map1=new Map<String,List<String>>();
        Map<String,List<String>> mapcId=new Map<String,List<String>>();
        List<Currency__c> currencies1=new List<Currency__c>();
        currencies1=[Select id,Name,Symbol__c,Is_Default_Currency__c,Currency_Code__c from Currency__c where Symbol__c in :symids and Name in :nameids];
       
        
        for(Currency__c curList: currencies1)
        {
            
            if(map1.containsKey(curList.Symbol__c))
            {
                
                map1.get(curList.Symbol__c).add(curList.Name);
                mapcId.get(curList.Symbol__c).add(curList.Symbol__c);
            }
            else
            {
                system.debug('inside else');
                map1.put(curList.Symbol__c,new List<String>{curList.Name});
                mapcId.put(curList.Symbol__c,new List<String>{curList.Symbol__c});
                
            }
        }      
        
        for(Currency__c checkdupcur:currencies)
        {
           if(map1.containsKey(checkdupcur.Symbol__c) && map1.get(checkdupcur.Symbol__c).contains(checkdupcur.Name))
            {
                
                if(mapcId.containsKey(checkdupcur.Symbol__c) && mapcId.get(checkdupcur.Symbol__c).contains(checkdupcur.Symbol__c))
                {
                    
                    currencies[0].addError('Duplicate Name Found!!');
                }
                else
                {
                    
                    currencies[0].addError('Duplicate Name Found!!');
                    
                }
            }
            else
            {
                system.debug('Do Nothing...');
            }
        }
    }
  
}
}