/*
    Name        :    CRUD_FLS_CheckUtility
    Date        :    14th Oct. 2016
    Author      :    javed
    Description :    Check the CRUD and FLS on objects and fields.
*/

public with sharing class CRUD_FLS_CheckUtility{

    public Static boolean checkReadPermission(String objApiName, Set<String> fieldsApiNameSet){       
        boolean isAccessible = true;
         SObjectType obj = Schema.getGlobalDescribe().get(objApiName);     
        if(obj != null && fieldsApiNameSet != null && fieldsApiNameSet.size()>0){            
            DescribeSObjectResult objDef = obj.getDescribe();
            Map<String, SObjectField> fieldsMap = objDef.fields.getMap();
            for(String fieldName : fieldsApiNameSet){   
                System.debug('obj-----fieldName--------'+fieldName);              
                if(fieldsMap.containsKey(fieldName)){
                    SObjectField field = fieldsMap.get(fieldName);
                    Schema.DescribeFieldResult fieldDes = field.getDescribe();                    
                    //check isAccessible  
                    System.debug('obj-----fieldName---fieldDes.isAccessible-----'+fieldDes.isAccessible());                   
                    if(!fieldDes.isAccessible()){
                        isAccessible = false; break;                   
                    }              
                }                          
            }
        }else{
            return false;
        }        
        
        return isAccessible;
    }

    public Static boolean checkFLS(String objApiName, Set<String> fieldsApiNameSet){
        //check object's CRUD Permission
        if(!checkObjCRUD(objApiName)){
            return false;
        }
        boolean isFLSPermission = true;
        boolean isCreateable,isUpdateable,isAccessible;
        SObjectType obj = Schema.getGlobalDescribe().get(objApiName);
        if(obj != null && fieldsApiNameSet != null && fieldsApiNameSet.size()>0){
            
            DescribeSObjectResult objDef = obj.getDescribe();
            Map<String, SObjectField> fieldsMap = objDef.fields.getMap();
            for(String fieldName : fieldsApiNameSet){ 
                isCreateable = isUpdateable = isAccessible = false;
                if(fieldsMap.containsKey(fieldName)){
                    SObjectField field = fieldsMap.get(fieldName);
                    Schema.DescribeFieldResult fieldDes = field.getDescribe(); 
                    
                    system.debug('fieldDes===>>>'+fieldDes);
                    //check isAccessible
                    if(fieldDes.isAccessible()){
                        isAccessible = true;  
                         system.debug('if true fieldDes===>>>'+fieldDes);                     
                    }  
                    //check isCreatable
                    if(fieldDes.isCreateable()){
                        isCreateable = true;   
                         system.debug('if true fieldDes===>>>'+fieldDes);                                    
                    }
                    //check isUpdateable
                    if(fieldDes.isUpdateable()){
                        isUpdateable = true;  
                        system.debug('if true fieldDes===>>>'+fieldDes);                                      
                    }
                                     
                }
               if(isAccessible == false || isCreateable == false || isUpdateable == false){
                    isFLSPermission = false;
                    break;
                }                
            }
        }else{
            return false;
        }        
        
        return isFLSPermission;
    }
    
    public static boolean checkObjCRUD(String objName){
        boolean isCRUD = true;
        SObjectType obj = Schema.getGlobalDescribe().get(objName);        
        if(obj != null){
            DescribeSObjectResult objDef = obj.getDescribe();
            if(objDef.isAccessible() == false || objDef.isCreateable() == false || objDef.isUpdateable() == false || objDef.isDeletable() == false){
                isCRUD = false;
            }
        }else{
         return false;
        }
        
        return isCRUD;
    }
  
     public Static boolean checkFLScreateAccess(String objApiName, Set<String> fieldsApiNameSet){
        if(!checkObjCRUD(objApiName)){
            return false;
        }
        boolean isFLSPermission = true;
        boolean isCreateable,isAccessible;
        SObjectType obj = Schema.getGlobalDescribe().get(objApiName);
        if(obj != null && fieldsApiNameSet != null && fieldsApiNameSet.size()>0){
            
            DescribeSObjectResult objDef = obj.getDescribe();
            Map<String, SObjectField> fieldsMap = objDef.fields.getMap();
            for(String fieldName : fieldsApiNameSet){ 
                isCreateable = isAccessible = false;
                if(fieldsMap.containsKey(fieldName)){
                    SObjectField field = fieldsMap.get(fieldName);
                    Schema.DescribeFieldResult fieldDes = field.getDescribe(); 
                    
                    system.debug('fieldDes===>>>'+fieldDes);
                    //check isAccessible
                    if(fieldDes.isAccessible()){
                        isAccessible = true;  
                         system.debug('if true fieldDes===>>>'+fieldDes);                     
                    }  
                    //check isCreatable
                    if(fieldDes.isCreateable()){
                        isCreateable = true;   
                         system.debug('if true fieldDes===>>>'+fieldDes);                                    
                    }
                                   
                }
                system.debug('isAccessible '+isAccessible);
                system.debug('isCreateable '+isCreateable);
                
                if(isAccessible == false || isCreateable == false ){
                    isFLSPermission = false;
                    break;
                }                
            }
        }else{
            return false;
        }        
        
        return isFLSPermission;
    }
}