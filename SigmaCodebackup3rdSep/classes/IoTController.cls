global with sharing class IoTController
{
    public static Boolean isAccessTokenChanged = false;
    public static String accessTokenChanged;
    @future (callout=true)
    public static void createMachineRecords(id machineId) 
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__IoT_Settings__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Resource__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__BOM_Line_Item__c')
    
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__IoT_Settings__c',new Set<String>{'sigmaerpdev__Access_Token__c','sigmaerpdev__Domain_Name__c','sigmaerpdev__Password__c','sigmaerpdev__User_Name__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Resource__c',new Set<String>{'id',' Name', 'sigmaerpdev__Product__c','sigmaerpdev__Product__r.ProductCode','sigmaerpdev__Product__r.Name'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__BOM_Line_Item__c',new Set<String>{'id','Name','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Name', 'sigmaerpdev__Product__r.sigmaerpdev__Description__c','sigmaerpdev__Quantity__c','sigmaerpdev__Products__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__IoT_Settings__c',new Set<String>{'sigmaerpdev__Access_Token__c'})
         && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Resource__c',new Set<String>{'sigmaerpdev__Is_data_sent_to_IoT__c'})
         ){
        //Retrive custom settings data
        String accessToken = '';
        String domainName = '';
        Map<string, IoT_Settings__c> settingsData = IoT_Settings__c.getAll();
        if(settingsData.get('IoT Settings').Access_Token__c != null)
            accessToken = settingsData.get('IoT Settings').Access_Token__c;
        domainName = settingsData.get('IoT Settings').Domain_Name__c;
        
        //Get Machine details
        JSONGenerator gen = JSON.createGenerator(true);    
        gen.writeStartObject();   
        List<Resource__c> resources = [select id, Name, Product__c, Product__r.ProductCode, Product__r.Name from Resource__c where Id =: machineId];
        if(resources.size() > 0)
        {
            gen.writeStringField('Manufacturing Code ', (resources[0].Product__r.ProductCode != null) ? resources[0].Product__r.ProductCode : '' );
            gen.writeStringField('Product Name', resources[0].Product__r.Name);
            gen.writeStringField('Resource Id', machineId);
            gen.writeFieldName('Components');
            gen.writeStartArray();
            List<BOM_Line_Item__c> bomLineItems = [select id, Name, Product__c, Product__r.Name, Product__r.Description__c, Quantity__c from BOM_Line_Item__c where Products__c =: resources[0].Product__c];
            if(bomLineItems.size() > 0)
            {
                for(BOM_Line_Item__c indComponents : bomLineItems)
                {
                    gen.writeStartObject();
                    gen.writeStringField('Component Name',indComponents.Product__r.Name);
                    gen.writeStringField('Component Id', indComponents.Product__c);
                    gen.writeStringField('Description', (indComponents.Product__r.Description__c) != null ? indComponents.Product__r.Description__c : '');
                    gen.writeStringField('Specification', '');
                    gen.writeNumberField('Quantity', (indComponents.Quantity__c != null) ? indComponents.Quantity__c : 0);
                    gen.writeEndObject();
                }
            }
            gen.writeEndArray();
        }
        gen.writeEndObject();
        String jsonString = gen.getAsString();
        
        system.debug('jsonString::'+jsonString);
        
        HTTPResponse res = APICallout.postAPI(domainName + '/sfdc/add_new_machine', accessToken, jsonString);
        
        //Update custom settings when token has been changed
        IoT_Settings__c updateSettings = settingsData.get('IoT Settings');
        if(isAccessTokenChanged)
        {
            if(accessTokenChanged.length() > 0)
                updateSettings.Access_Token__c = accessTokenChanged;
            update updateSettings;
        }
        
        //Update resource record if we get success response
        if(res.getStatusCode() == 200)
        {
            Resource__c resourceRec = new Resource__c();
            resourceRec.Id = machineId;
            resourceRec.Is_data_sent_to_IoT__c = true;
            update resourceRec;
        }
         
        System.debug(res.getBody());
    }
    }
    
}