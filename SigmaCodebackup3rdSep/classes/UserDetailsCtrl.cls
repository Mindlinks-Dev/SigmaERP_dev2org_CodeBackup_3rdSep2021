public class UserDetailsCtrl {
    @AuraEnabled
    public static List<String> getPickList(String objName,String fldName) {
        List<String> pkList = new List<String>();Map<String,Schema.SObjectType> allObj = Schema.getGlobalDescribe();
        Map<String,Schema.SObjectField> allFlds = allObj.get(objName).getDescribe().fields.getMap();
        List<Schema.PicklistEntry> pickList = allFlds.get(fldName).getDescribe().getPickListValues();
        for(Schema.PicklistEntry pk : pickList){
            pkList.add(pk.getValue());
        }
        return pkList;
    }
    @AuraEnabled
    public static Account createAccount(Account ac){
        insert ac;
        
        Contact con = new Contact();
        con.AccountId = ac.Id;
        con.LastName = ac.Name;
        con.Email = ac.sigmaerpdev2__Email__c;
        insert con;
        
        Lead ld = new Lead();
        ld.sigmaerpdev2__Account__c = ac.Id; 
        ld.LastName = ac.Name;
        ld.Email = ac.sigmaerpdev2__Email__c;
        ld.Company = ac.sigmaerpdev2__Company__c;
        insert ld;
            
        List<sigmaerpdev2__Sigma_Order__c> sigmaorder=[select id,Name,sigmaerpdev2__AccountId__c, sigmaerpdev2__Orders_Status__c, sigmaerpdev2__Order_Type__c,sigmaerpdev2__Order_Created_Via__c, sigmaerpdev2__Delivary_Date__c from sigmaerpdev2__Sigma_Order__c where sigmaerpdev2__Orders_Status__c = 'Pending' AND sigmaerpdev2__Order_Created_Via__c = 'Community'];
        //sigmaerpdev2__Sigma_Order__c SigOrder = new sigmaerpdev2__Sigma_Order__c();
        System.debug('sigmaorder.size()>>>>'+sigmaorder.size());
        for(sigmaerpdev2__Sigma_Order__c SO:sigmaorder)
        {
            SO.sigmaerpdev2__AccountId__c=ac.Id;
            SO.sigmaerpdev2__Orders_Status__c='Order Confirmed';
            SO.sigmaerpdev2__Delivary_Date__c=System.today();
            SO.sigmaerpdev2__Lead__c=ld.Id;
        }
        if(sigmaorder.size() >= 0)
        {
            update sigmaorder;
        }
        System.debug('SigOrder>>>>'+sigmaorder);
        
        
        return ac;
    }
}