trigger PreventDuplicateSCLI on sigmaerpdev2__Service_Contract_Line_Item__c (before insert) {
	Set<String> setName = new Set<String>();
    if(trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            For(sigmaerpdev2__Service_Contract_Line_Item__c scli : trigger.new)
            {
                setName.add(scli.sigmaerpdev2__Product__c);
            }
            
            if(setName.size() > 0 )
            {
                List<sigmaerpdev2__Service_Contract_Line_Item__c> lstAccount = [select sigmaerpdev2__Product__c ,id from sigmaerpdev2__Service_Contract_Line_Item__c where sigmaerpdev2__Product__c in :setName ];
                
                Map<String ,sigmaerpdev2__Service_Contract_Line_Item__c> mapNameWiseAccount = new Map<String,sigmaerpdev2__Service_Contract_Line_Item__c>();
                For(sigmaerpdev2__Service_Contract_Line_Item__c scli: lstAccount)
                {
                    mapNameWiseAccount.put(scli.sigmaerpdev2__Product__c ,scli);
                }
                
                For(sigmaerpdev2__Service_Contract_Line_Item__c scli : trigger.new)
                {
                    if(mapNameWiseAccount.containsKey(scli.sigmaerpdev2__Product__c))
                    {
                        scli.Name.addError('Product already exists in service contract!');
                    }
                }
                
            }
        }
    }
}