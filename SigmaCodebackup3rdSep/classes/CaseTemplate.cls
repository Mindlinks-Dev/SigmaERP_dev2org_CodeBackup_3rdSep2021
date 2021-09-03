public class CaseTemplate 
{
    public Id caseId {get;set;}
    
    public String getsb(Id caseId)
    {
        Id recId = caseId;
        SObjectType objType;
        objType = recId.getSobjectType();  
        System.debug('Object Type is>> ' + objType);
        String objType11 = String.valueOf(objType);
        System.debug('Object apiname is>> ' + objType11); 
        
        List<String>FieldResult = new List<String>();
        List<Object>DataResult = new List<Object>();
        List<sigmaerpdev2__Survey_List__c>Field = [Select sigmaerpdev2__Field_Required__c from sigmaerpdev2__Survey_List__c where Name =: objType11];
        FieldResult.add(Field[0].sigmaerpdev2__Field_Required__c);
        String qString = 'select '+ Field[0].sigmaerpdev2__Field_Required__c +' from '+objType +' where Id = \''+ recId+'\'';
        sObject sb = database.query(qString);
        System.debug('sb>>>'+sb);
        String s12 = '';
        for(sigmaerpdev2__Survey_List__c esignobj : Field){
            s12 = (String)esignobj.sigmaerpdev2__Field_Required__c;
        }
        List<String> s13 = s12.split(',');
        System.debug('s12>>>'+s12);
        System.debug('s13>>>'+s13);
        List<String> finalList = new List<String>();
        Map<Id,String> recordId = new Map<Id,String>();
        for(Id myId : recordId.keySet()){
            String sObjName = myId.getSObjectType().getDescribe().getName();
            recordId.put(myId,sObjName);
        }
        List<String> lookUpNames = new List<String>();
        for(Id rowId : recordId.keySet()){
            String qString1 = 'select name from '+recordId.get(rowId) +' where id =\''+rowId+'\'';
            sObject name1 = database.query(qString1);
            system.debug('name1=='+name1.get('name'));
            lookUpNames.add((String)name1.get('name'));
        }
        system.debug('lookUpNames==='+lookUpNames);
        finalList.addall(lookUpNames);
        system.debug('finalList after==='+finalList);
        
        String sb11 = String.valueOf(sb);
        return sb11;     
    }
    
    public List<String> gets13()
    {
        Id recId = caseId;
        SObjectType objType;
        objType = recId.getSobjectType();  
        System.debug('Object Type is>> ' + objType);
        String objType11 = String.valueOf(objType);
        System.debug('Object apiname is>> ' + objType11); 
        
        List<String>FieldResult = new List<String>();
        List<Object>DataResult = new List<Object>();
        List<sigmaerpdev2__Survey_List__c>Field = [Select sigmaerpdev2__Field_Required__c from sigmaerpdev2__Survey_List__c where Name =: objType11];
        FieldResult.add(Field[0].sigmaerpdev2__Field_Required__c);
        String qString = 'select '+ Field[0].sigmaerpdev2__Field_Required__c +' from '+objType +' where Id = \''+ recId+'\'';
        sObject sb = database.query(qString);
        System.debug('sb>>>'+sb);
        String s12 = '';
        for(sigmaerpdev2__Survey_List__c esignobj : Field){
            s12 = (String)esignobj.sigmaerpdev2__Field_Required__c;
        }
        List<String> s13 = s12.split(',');
        System.debug('s12>>>'+s12);
        System.debug('s13>>>'+s13);
        for(Integer i=0;i<s13.size();i++)
        {
            if(s13[i].contains('sigmaerpdev2__'))
            {
                s13[i] =  s13[i].replace('sigmaerpdev2__','');
            }
            if(s13[i].contains('_text'))
            {
                s13[i] =  s13[i].replace('_text','');
            }
            if(s13[i].contains('__c'))
            {
                s13[i] =  s13[i].Substring(0,s13[i].length()-3);
            }
        }
        system.debug('colname@@'+s13);
        List<String> finalList = new List<String>();
        Map<Id,String> recordId = new Map<Id,String>();
        for(Id myId : recordId.keySet()){
            String sObjName = myId.getSObjectType().getDescribe().getName();
            recordId.put(myId,sObjName);
        }
        List<String> lookUpNames = new List<String>();
        for(Id rowId : recordId.keySet()){
            String qString1 = 'select name from '+recordId.get(rowId) +' where id =\''+rowId+'\'';
            sObject name1 = database.query(qString1);
            system.debug('name1=='+name1.get('name'));
            lookUpNames.add((String)name1.get('name'));
        }
        system.debug('lookUpNames==='+lookUpNames);
        finalList.addall(lookUpNames);
        system.debug('finalList after==='+finalList);
        
        String sb11 = String.valueOf(sb);
        return s13;    
    }
    
    public List<String> getfinalList()
    {
        Id recId = caseId;
        SObjectType objType;
        objType = recId.getSobjectType();  
        System.debug('Object Type is>> ' + objType);
        String objType11 = String.valueOf(objType);
        System.debug('Object apiname is>> ' + objType11); 
        
        List<String>FieldResult = new List<String>();
        List<Object>DataResult = new List<Object>();
        List<sigmaerpdev2__Survey_List__c>Field = [Select sigmaerpdev2__Field_Required__c from sigmaerpdev2__Survey_List__c where Name =: objType11];
        FieldResult.add(Field[0].sigmaerpdev2__Field_Required__c);
        String qString = 'select '+ Field[0].sigmaerpdev2__Field_Required__c +' from '+objType +' where Id = \''+ recId+'\'';
        sObject sb = database.query(qString);
        System.debug('sb>>>'+sb);
        String s12 = '';
        for(sigmaerpdev2__Survey_List__c esignobj : Field){
            s12 = (String)esignobj.sigmaerpdev2__Field_Required__c;
        }
        List<String> s13 = s12.split(',');
        System.debug('s12>>>'+s12);
        System.debug('s13>>>'+s13);
        List<String> finalList = new List<String>();
        Map<Id,String> recordId = new Map<Id,String>();
        for(string strObj: s13){    
            String temp = String.valueOf(sb.get(strObj));
            if(temp!=null)
            {
                if((temp.length() == 15 || temp.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', temp)){
                    recordId.put(temp, null);
                }
                else{
                    finalList.add(temp);  
                } 
            }
            else
            {
                finalList.add(' ');
            }
        }
        system.debug('finalList before==='+finalList);
        
        for(Id myId : recordId.keySet()){
            String sObjName = myId.getSObjectType().getDescribe().getName();
            recordId.put(myId,sObjName);
        }
        List<String> lookUpNames = new List<String>();
        for(Id rowId : recordId.keySet()){
            String qString1 = 'select name from '+recordId.get(rowId) +' where id =\''+rowId+'\'';
            sObject name1 = database.query(qString1);
            system.debug('name1=='+name1.get('name'));
            lookUpNames.add((String)name1.get('name'));
        }
        system.debug('lookUpNames==='+lookUpNames);
        finalList.addall(lookUpNames);
        system.debug('finalList after==='+finalList);
        
        String sb11 = String.valueOf(sb);
        return finalList;      
    }
    
}