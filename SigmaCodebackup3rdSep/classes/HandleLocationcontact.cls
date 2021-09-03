public with sharing class HandleLocationcontact {
public void onBeforeInsert(List<Contact> lstNewLocationCon)
{
    Set<String> Contactids=new Set<String>();
    Set<Id> locids=new Set<Id>();
    system.debug('lstNewLocationCon>>>>'+lstNewLocationCon);
    Boolean isPreferedExist=false;
    if(CRUD_FLS_CheckUtility.checkObjCRUD('Contact')
       && CRUD_FLS_CheckUtility.checkReadPermission('Contact',new Set<String>{'id','FirstName'}))
    {
        for(Contact conrelatedloc : lstNewLocationCon)
        {
            //vendorids.add(ProdrelatedVP.Account_Name__c);
            Contactids.add(conrelatedloc.FirstName);
            locids.add(conrelatedloc.AccountId);
            system.debug('Contactids>>' + Contactids);
            system.debug('locids>>' + locids);
            if(conrelatedloc.Preferred_Contact_for_Location__c)
            {
                isPreferedExist=true;
            }
        }
        List<Contact> condata=[Select id,FirstName,AccountId,Preferred_Contact_for_Location__c from Contact where AccountId in :locids and Preferred_Contact_for_Location__c=true ];
        system.debug('Contact Ids>>' + condata);
        system.debug('Contact Ids size>>' + condata.size());
        if(condata.size()==0)
        {
            system.debug('new condata list >>' + lstNewLocationCon);
            for(Contact Defaultcontact : lstNewLocationCon)
            {
                system.debug(' Preferred_Contact_for_Location__c>>' +Defaultcontact.Preferred_Contact_for_Location__c);
                if(Defaultcontact.Preferred_Contact_for_Location__c==false)
                {             
                    system.debug('inside if5::' +Defaultcontact.Preferred_Contact_for_Location__c);
                    lstNewLocationCon[0].addError('Please check is preferred contact for location to make this as default contact');
                }
                else
                    system.debug('Do Nothing...');
            }
        }
        if(isPreferedExist)
        {
            for(Contact Defaultcontact : condata)
            {
                if(Defaultcontact.Preferred_Contact_for_Location__c)
                {
                    lstNewLocationCon[0].Preferred_Contact_for_Location__c.adderror('Please uncheck already existing default contact for this location to make this contact default!!');
                }
                else{
                    system.debug('Do Nothing...');
                }
            }
            
        }                   

            Map<Id,List<String>> mapLocConts=new Map<Id,List<String>>();
            Map<Id,List<String>> mapLcId=new Map<Id,List<String>>();
            List<Contact> lstOldlocConts=new List<Contact>();
            lstOldlocConts=[Select id,FirstName,AccountId from Contact where AccountId in :locids and FirstName in :Contactids];
            system.debug('lstOldlocConts in vendor product >>' + lstOldlocConts);
            system.debug('size of old vendor product list >>' + lstOldlocConts.size());
            
            for(Contact lcOldList: lstOldlocConts)
            {
                if(mapLocConts.containsKey(lcOldList.AccountId))
                {
                    system.debug('inside if1'+mapLocConts.containsKey(lcOldList.AccountId));
                    system.debug('inside if1'+mapLocConts.containsKey(lcOldList.AccountId));
                    mapLocConts.get(lcOldList.AccountId).add(lcOldList.FirstName);
                    mapLcId.get(lcOldList.AccountId).add(lcOldList.FirstName);
                }
                else
                {
                    system.debug('inside else');
                    mapLocConts.put(lcOldList.AccountId,new List<String>{lcOldList.FirstName});
                    mapLcId.put(lcOldList.AccountId,new List<String>{lcOldList.FirstName});
                    system.debug('After checking Product and vendor ids >>' + mapLocConts);
                    system.debug('After checking Product and vendor Product ids >>' + mapLcId);
                }
            }
            
            
            for(Contact checkdupcontact:lstNewLocationCon)
            {
                if(mapLocConts.containsKey(checkdupcontact.AccountId) && mapLocConts.get(checkdupcontact.AccountId).contains(checkdupcontact.FirstName))
                {
                    system.debug('inside if2');
                    if(mapLcId.containsKey(checkdupcontact.AccountId) && mapLcId.get(checkdupcontact.AccountId).contains(checkdupcontact.FirstName))
                    {
                        system.debug('inside if3 ::' +Trigger.isUpdate);
                        system.debug('new mapLcId1 ::' +mapLcId.containsKey(checkdupcontact.AccountId));
                        system.debug('new mapLcId2 ::' +mapLcId.get(checkdupcontact.AccountId).contains(checkdupcontact.FirstName));
                        
                        lstNewLocationCon[0].addError('Duplicate Contact Found!!');
                    }
                    else
                    {
                        system.debug('inside if4');
                        lstNewLocationCon[0].addError('Duplicate Contact Found!!');
                        system.debug('inside if4::'+lstNewLocationCon[0].FirstName);
                    }
                }
                else
                {
                    system.debug('Do Nothing...');
                }
            }
         } 
}		 
    
    public void onAfterUpdate(List<Contact> lstNewLocationCon)
    {
        Set<Id> locids=new Set<Id>();
        for(Contact vProd : lstNewLocationCon)
        {
            if(vProd .AccountId != null)                
                locids.add(vProd.AccountId);
        }
        Map<Id,Contact> venMap = new Map<Id,Contact>([Select id,AccountId,sigmaerpdev2__Preferred_Contact_for_Location__c from Contact where id not in:lstNewLocationCon and sigmaerpdev2__Preferred_Contact_for_Location__c=true and AccountId in :locids]);
        //List<Contact> newcontactList  =[Select id,AccountId,Account_Name__c,sigmaerpdev2__Preferred_Contact_for_Location__c,Buying_Price__c from Contact where id in :lstOldlocConts and sigmaerpdev2__Preferred_Contact_for_Location__c=true and AccountId in :locids];
        Map<ID,Contact> nullMap = new Map<ID,Contact>();
        Map<id,Contact> maplList = new Map<id,Contact>();
        set<Id> vendorthis = new set<Id>();
        List<Contact> contactList = [Select id,AccountId,sigmaerpdev2__Preferred_Contact_for_Location__c from Contact where id in :lstNewLocationCon];
        system.debug('after update2>>>'+contactList);
        
        for(Contact listContact :contactList){
            if(listContact.sigmaerpdev2__Preferred_Contact_for_Location__c==true){
                maplList.put(listContact.Id,listContact);
            }                       
        }               
        
       for(Contact newvendor : venMap.values()){
            if(newvendor.sigmaerpdev2__Preferred_Contact_for_Location__c==true)
            {
                nullMap.put(newvendor.Id,newvendor);
                system.debug('after update2>>>'+nullMap);
            } 
        }
        if(maplList.size() >0 && nullMap.size() >0 )
        { 
            for(Contact vrList: lstNewLocationCon){
                vrList.addError('Please uncheck already existing default contact for this location to make this contact default!!!');
            }            
        }
        
}
}