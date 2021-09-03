public class ClonePOController {
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        system.debug('objObject --->' + objObject);
        system.debug('fld --->' + fld);
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
    @AuraEnabled
    public static sigmaerpdev2__Purchase_Order__c getCloningDetails(string purchaseId){
        Integer pocount =[select count() from sigmaerpdev2__Purchase_Order__c where id=:purchaseId];
        if(pocount == 1){
            return [select id,Name,sigmaerpdev2__Product_Supplier__c,sigmaerpdev2__Total_Amount__c,sigmaerpdev2__Product_Supplier__r.Name,sigmaerpdev2__Status__c,sigmaerpdev2__Order_Date__c,sigmaerpdev2__Expected_Date__c,
                    sigmaerpdev2__Currency__c from sigmaerpdev2__Purchase_Order__c where id=:purchaseId];
        }
        else{
            return null;
        }
    }
    @AuraEnabled
    public static List<sigmaerpdev2__Purchase_Order_Product__c> getLineItems(string purchaseId){
        System.debug('purchaseId'+purchaseId);
        return [select id,Name,sigmaerpdev2__Product__r.Name,sigmaerpdev2__Purchase_Order__r.Name,sigmaerpdev2__Total_Buying_Price__c,
                sigmaerpdev2__Expected_Delivery_Date__c,sigmaerpdev2__Quantity__c,sigmaerpdev2__Discount__c,sigmaerpdev2__Status__c from sigmaerpdev2__Purchase_Order_Product__c where sigmaerpdev2__Purchase_Order__r.Name=:purchaseId];
    }
    @AuraEnabled
    public static sigmaerpdev2__Purchase_Order_Product__c getLine(string popid){
        System.debug('popid>>'+popid);
        return [select id,Name,sigmaerpdev2__Product__r.Name,sigmaerpdev2__Purchase_Order__r.Name,sigmaerpdev2__Total_Buying_Price__c,
                sigmaerpdev2__Expected_Delivery_Date__c,sigmaerpdev2__Quantity__c,sigmaerpdev2__Discount__c,sigmaerpdev2__Status__c from sigmaerpdev2__Purchase_Order_Product__c where id=:popid];
    }
    @AuraEnabled
    public static sigmaerpdev2__Vendor_Product__c getBuyingPrice(string productid,string vendorId){
        
        return [Select Id,Name,sigmaerpdev2__Buying_Price__c,sigmaerpdev2__Product_Name__c,sigmaerpdev2__Product_Name__r.Name from sigmaerpdev2__Vendor_Product__c where sigmaerpdev2__Product_Name__c =:productid and sigmaerpdev2__Account_Name__c =:vendorId];
    }
   @AuraEnabled
    public static String savePO(String po,String pop){
        system.debug('po'+po);
         system.debug('pop'+pop);
        
        sigmaerpdev2__Purchase_Order__c posave=(sigmaerpdev2__Purchase_Order__c)System.JSON.deserialize(po,sigmaerpdev2__Purchase_Order__c.class);
        system.debug('po deser'+po);
        
        
        sigmaerpdev2__Purchase_Order__c savepo=new sigmaerpdev2__Purchase_Order__c();
        savepo.sigmaerpdev2__Product_Supplier__c=posave.sigmaerpdev2__Product_Supplier__c;
        savepo.sigmaerpdev2__Status__c=posave.sigmaerpdev2__Status__c;
        savepo.sigmaerpdev2__Order_Date__c=posave.sigmaerpdev2__Order_Date__c;
        savepo.sigmaerpdev2__Expected_Date__c=posave.sigmaerpdev2__Expected_Date__c;
        System.debug('before savepo'+savepo);
        insert savepo;
        System.debug('after savepo'+savepo);
        
         List<sigmaerpdev2__Purchase_Order_Product__c> saveli=(List<sigmaerpdev2__Purchase_Order_Product__c>)System.JSON.deserialize(pop,List<sigmaerpdev2__Purchase_Order_Product__c>.class);
        system.debug('saveli deser'+saveli);
        
        List<sigmaerpdev2__Purchase_Order_Product__c> newpop =new List<sigmaerpdev2__Purchase_Order_Product__c>();
        for(sigmaerpdev2__Purchase_Order_Product__c pref : saveli){
            sigmaerpdev2__Purchase_Order_Product__c pobj = new sigmaerpdev2__Purchase_Order_Product__c();
            pobj.sigmaerpdev2__Purchase_Order__c = savepo.id; 
            pobj.sigmaerpdev2__Product__c= pref.sigmaerpdev2__Product__c;
            pobj.sigmaerpdev2__Buying_Price__c=pref.sigmaerpdev2__Total_Buying_Price__c;            
            pobj.sigmaerpdev2__Total_Buying_Price__c=pref.sigmaerpdev2__Total_Buying_Price__c;
            pobj.sigmaerpdev2__Expected_Delivery_Date__c=pref.sigmaerpdev2__Expected_Delivery_Date__c;
            pobj.sigmaerpdev2__Quantity__c=pref.sigmaerpdev2__Quantity__c;
            pobj.sigmaerpdev2__Discount__c=pref.sigmaerpdev2__Discount__c;
            pobj.sigmaerpdev2__Status__c=pref.sigmaerpdev2__Status__c;
            newpop.add(pobj);
        }
        System.debug('newpop'+newpop);
        insert newpop;
         System.debug('after'+newpop);
        
        
       	return savepo.Id;
        
    }
    @AuraEnabled
    public static List<sigmaerpdev2__Purchase_Order_Product__c> saveLI(string purchaseId,List<sigmaerpdev2__Purchase_Order_Product__c> pop){
        //insert po;
        List<sigmaerpdev2__Purchase_Order_Product__c> saveli=new List<sigmaerpdev2__Purchase_Order_Product__c>();
        
        for(sigmaerpdev2__Purchase_Order_Product__c po: pop){
            sigmaerpdev2__Purchase_Order_Product__c li=new sigmaerpdev2__Purchase_Order_Product__c();
            li.sigmaerpdev2__Purchase_Order__c=po.sigmaerpdev2__Purchase_Order__c;
            li.sigmaerpdev2__Product__c=po.sigmaerpdev2__Product__c;
            li.sigmaerpdev2__Total_Buying_Price__c=po.sigmaerpdev2__Total_Buying_Price__c;
            li.sigmaerpdev2__Expected_Delivery_Date__c=po.sigmaerpdev2__Expected_Delivery_Date__c;
            li.sigmaerpdev2__Quantity__c=po.sigmaerpdev2__Quantity__c;
            li.sigmaerpdev2__Discount__c=po.sigmaerpdev2__Discount__c;
            li.sigmaerpdev2__Status__c=po.sigmaerpdev2__Status__c;
            saveli.add(li);
        }        
        insert saveli;
        System.debug('po>>'+saveli);
        return saveli;
    }
    @AuraEnabled
    public static string updatepop(sigmaerpdev2__Purchase_Order_Product__c pop){
        System.debug('ts>'+pop);
        update pop;
        return pop.id;
    }
    
    @AuraEnabled
    public static string savepop(sigmaerpdev2__Purchase_Order_Product__c pop){
        System.debug('ts>'+pop);
        sigmaerpdev2__Purchase_Order_Product__c savepop=new sigmaerpdev2__Purchase_Order_Product__c();
        savepop.sigmaerpdev2__Product__c=pop.sigmaerpdev2__Product__c;
        savepop.sigmaerpdev2__Total_Buying_Price__c=pop.sigmaerpdev2__Total_Buying_Price__c;
        savepop.sigmaerpdev2__Expected_Delivery_Date__c=pop.sigmaerpdev2__Expected_Delivery_Date__c;
        savepop.sigmaerpdev2__Quantity__c=pop.sigmaerpdev2__Quantity__c;
        savepop.sigmaerpdev2__Discount__c=pop.sigmaerpdev2__Discount__c;
        savepop.sigmaerpdev2__Status__c=pop.sigmaerpdev2__Status__c;
        insert savepop;
        return savepop.id;
    }
}