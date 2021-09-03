public without sharing class customLookUpController
{
    @AuraEnabled
    public static List <sObject> fetchLookUpValues(String searchKeyWord, String whereCondition,String ObjectName) 
    {
         List <sObject> returnList = new List <sObject> ();
       /*if(CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
          && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location__c')
           
         && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'id','name','sigmaerpdev2__Location__c','sigmaerpdev2__Location__r.Name'})
           && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'id','Name','createdDate'})
         && CRUD_FLS_CheckUtility.checkReadPermission('Order',new Set<String>{'id','OrderNumber','createdDate'})
         ){*/
         
       system.debug('whereCondition-->' + whereCondition);
        String searchKey ='%' +searchKeyWord + '%';
        system.debug('searchKeyWord>>'+searchKeyWord);
       
        
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 
        String sQuery = '';
        
        if(ObjectName == 'Product2')
        {
            if(whereCondition != '' || whereCondition != null)
            {
                sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey '+whereCondition+' order by createdDate DESC limit 5';// changed 10-08-2019
                //  sQuery =  'select id, Name,Sub_Brand__c,Brand__c,High_Level_Cat_Pricing__c from ' +ObjectName + ' where Name LIKE: searchKey '+whereCondition+' order by createdDate DESC limit 10'; changed 10-08-2019
            }  
            else
            {
                sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5';// changed 10-08-2019
                //sQuery =  'select id, Name Sub_Brand__c,Brand__c,High_Level_Cat_Pricing__c from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 10';
            }
        }
            if(ObjectName == 'Account')
        {
            if(whereCondition != '' || whereCondition != null)
            {
                sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey '+whereCondition+' order by createdDate DESC limit 5';// changed 10-08-2019
                //  sQuery =  'select id, Name,Sub_Brand__c,Brand__c,High_Level_Cat_Pricing__c from ' +ObjectName + ' where Name LIKE: searchKey '+whereCondition+' order by createdDate DESC limit 10'; changed 10-08-2019
            }  
            else
            {
                sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5';// changed 10-08-2019
                //sQuery =  'select id, Name Sub_Brand__c,Brand__c,High_Level_Cat_Pricing__c from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 10';
            }
            
        }else if(ObjectName == 'Order')
        {
            if(whereCondition != '' || whereCondition != null)
            { 
                system.debug('whereCondition1>>' +whereCondition);
                sQuery =  'select id,OrderNumber from ' +ObjectName + ' where OrderNumber LIKE: searchKey ' +whereCondition+ ' order by createdDate DESC limit 5';
            }
            else
            {
                system.debug('whereCondition1>>' +whereCondition);
                sQuery =  'select id,OrderNumber from ' +ObjectName + ' where OrderNumber LIKE: searchKey order by createdDate DESC limit 5';
            }
        }
        else if(ObjectName == 'sigmaerpdev2__Inventory_Location__c')
        {
            //Code Added for FFTB
            Id CommUserId= UserInfo.getUserId();
            User currentuser = [select Id,Profile.Name,Contact.AccountId from User where Id =: CommUserId];
            Community_Configuration__c CommCustset= [select Id,Name,Retailer_Community_URL__c,Products_Per_Page__c,Retailer_Profile_Name__c,Vendor_Community_URL__c,Vendor_Profile_Name__c from Community_Configuration__c where Name = 'Community Configurations' LIMIT 1];
                if(currentuser.Profile.Name == CommCustset.Retailer_Profile_Name__c)
                {
                    if(whereCondition != '' || whereCondition != null)
                    { 
                        system.debug('whereCondition1>>' +whereCondition);
                        sQuery =  'select id,name,sigmaerpdev2__Location__c,sigmaerpdev2__Location__r.Name,sigmaerpdev2__Location_Type__c from ' +ObjectName + ' where sigmaerpdev2__Location__r.CreatedById = '+ '\''+CommUserId+'\''+' '+whereCondition+ ' order by createdDate DESC limit 5';
                    }
                    else
                    {
                        system.debug('whereCondition1>>' +whereCondition);
                        sQuery =  'select id,Name,sigmaerpdev2__Location__c,sigmaerpdev2__Location__r.Name,sigmaerpdev2__Location_Type__c from ' +ObjectName + ' where sigmaerpdev2__Location__r.CreatedById = '+'\''+CommUserId+'\''+' order by createdDate DESC limit 5';
                    }
                }
                else
                {
                    if(whereCondition != '' || whereCondition != null)
                    { 
                        system.debug('whereCondition1>>' +whereCondition);
                        sQuery =  'select id,name,sigmaerpdev2__Location__c,sigmaerpdev2__Location__r.Name,sigmaerpdev2__Location_Type__c from ' +ObjectName + ' where sigmaerpdev2__Location__r.Name LIKE: searchKey ' +whereCondition+ ' order by createdDate DESC limit 5 ';
                    }
                    else
                    {
                        system.debug('whereCondition1>>' +whereCondition);
                        sQuery =  'select id,Name,sigmaerpdev2__Location__c,sigmaerpdev2__Location__r.Name,sigmaerpdev2__Location_Type__c from ' +ObjectName + ' where sigmaerpdev2__Location__r.Name LIKE: searchKey order by createdDate DESC limit 5';
                    }
                }
                
                
           /* if(whereCondition != '' || whereCondition != null)
            { 
                system.debug('whereCondition1>>' +whereCondition);
                sQuery =  'select id,name,sigmaerpdev2__Location__c,sigmaerpdev2__Location__r.Name,sigmaerpdev2__Location_Type__c from ' +ObjectName + ' where sigmaerpdev2__Location__r.Name LIKE: searchKey ' +whereCondition+ ' order by createdDate DESC limit 5 ';
            }
            else
            {
                system.debug('whereCondition1>>' +whereCondition);
                sQuery =  'select id,Name,sigmaerpdev2__Location__c,sigmaerpdev2__Location__r.Name,sigmaerpdev2__Location_Type__c from ' +ObjectName + ' where sigmaerpdev2__Location__r.Name LIKE: searchKey order by createdDate DESC limit 5';
            }*/
        }
        
        else if(ObjectName == 'sigmaerpdev2__Product_Catalog__c')
        {
            //Code Added for FFTB
            Id CommUserId= UserInfo.getUserId();
            User currentuser = [select Id,Profile.Name,Contact.AccountId from User where Id =: CommUserId];
            Community_Configuration__c CommCustset= [select Id,Name,Retailer_Community_URL__c,Products_Per_Page__c,Retailer_Profile_Name__c,Vendor_Community_URL__c,Vendor_Profile_Name__c from Community_Configuration__c where Name = 'Community Configurations' LIMIT 1];
                if(currentuser.Profile.Name == CommCustset.Retailer_Profile_Name__c)
                {
                    if(whereCondition != '' || whereCondition != null)
                    { 
                        system.debug('whereCondition1>>' +whereCondition);
                        sQuery =  'select id,name from ' +ObjectName + ' where CreatedById = '+ '\''+CommUserId+'\''+' '+whereCondition+ ' order by createdDate DESC limit 5';
                    }
                    else
                    {
                        system.debug('whereCondition1>>' +whereCondition);
                        sQuery =  'select id,Name from ' +ObjectName + ' where CreatedById = '+'\''+CommUserId+'\''+' order by createdDate DESC limit 5';
                    }
                }
                else
                {
                    if(whereCondition != '' || whereCondition != null)
                    { 
                        system.debug('whereCondition1>>' +whereCondition);
                        sQuery =  'select id,name from ' +ObjectName + ' where Name LIKE: searchKey ' +whereCondition+ ' order by createdDate DESC limit 5 ';
                    }
                    else
                    {
                        system.debug('whereCondition1>>' +whereCondition);
                        sQuery =  'select id,Name from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5';
                    }
                }
            
        }
        
        else
        {    if(whereCondition != '' || whereCondition != null)
                {
                    system.debug('whereCondition2' +whereCondition);
                    sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey ' +whereCondition+ ' order by createdDate DESC limit 5';
                }
                else
                {
                    system.debug('whereCondition2' +whereCondition);
                    sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5';
                } 
        }
        System.debug('sQuery:::'+sQuery);
        List <sObject> lstOfRecords = Database.query(sQuery);
        System.debug('lstOfRecords:::'+lstOfRecords);
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        // }
        return returnList;
    }
}