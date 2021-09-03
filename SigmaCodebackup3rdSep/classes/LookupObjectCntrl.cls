/**
* Apex Controller for looking up an SObject via SOSL
*/
public without sharing class LookupObjectCntrl
{
    /**
* Aura enabled method to search a specified SObject for a specific string
*/
    
    @AuraEnabled
    public static Result[] lookup(String searchString, String sObjectAPIName,String WsearchString,String WsearchString1)
    {
            List<Result> results = new List<Result>();
            String sanitizedSearchString = String.escapeSingleQuotes(searchString);
            String sanitizedSObjectAPIName = String.escapeSingleQuotes(sObjectAPIName);
            String filterCondition=null;
            String filterCondition1;
            if(WsearchString!=null) //added on 30-11-2019
                filterCondition =String.escapeSingleQuotes(WsearchString);//added on 30-11-2019
           
            if(WsearchString1 != null) // code added when FFP merged 19-03-2020
            {
                filterCondition1 = String.escapeSingleQuotes(WsearchString1); 
            }
            System.debug('sanitizedSearchString::'+sanitizedSearchString);
            System.debug('sanitizedSObjectAPIName::'+sanitizedSObjectAPIName);
            System.debug('filterCondition::'+filterCondition);
            String searchQuery = null;
            
        // Build our SOSL query
        //Extra condition added to differentiate between Products and Account
       /* if( CRUD_FLS_CheckUtility.checkObjCRUD('Account')
            && CRUD_FLS_CheckUtility.checkObjCRUD('Contact')
            && CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
            && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Vendor_Product__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Currency__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sublevel_location__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__SubscriptionDetail__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Subscription_Line_Item__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Package__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Resource__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Project_Resource__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('
            ')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Work_Order__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Service_Contract__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Service_Contract_Line_Item__c') 
        ) 
        {*/   
        
            Id UserId= UserInfo.getUserId();
			User currentuser = [select Id,Profile.Name from User where Id =: UserId];
			Community_Configuration__c Custset= [select Id,Name,Retailer_Community_URL__c,Products_Per_Page__c,Retailer_Profile_Name__c,Vendor_Community_URL__c,Vendor_Profile_Name__c from Community_Configuration__c where Name = 'Community Configurations' LIMIT 1];
						
            
            if(sanitizedSObjectAPIName == 'Account' && filterCondition!=null)
            {
                if(filterCondition=='AutoPOVendor')
                {
                     /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Default_Parameters__c')
                        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Default_Parameters__c',new Set<String>{'Id','Name','Default_Vendor__c','Vendor_Rating__c'})
                    ){*/
                    Default_Parameters__c dp=[select Default_Vendor__c,Vendor_Rating__c from Default_Parameters__c];
                  
                        system.debug('Default vendor is true-->'+dp.Default_Vendor__c);
                        searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name,Type,sigmaerpdev2__Status__c,sigmaerpdev2__Active__c where type=\'Vendor\') Limit 1000'; 
                        system.debug('searchQuery for po::'+searchQuery);
                    //}
                }
               
                else{
						if(currentuser.Profile.Name == Custset.Retailer_Profile_Name__c)
						{
							searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name,Type,sigmaerpdev2__Status__c,sigmaerpdev2__Active__c where type=:filterCondition) Limit 1000';
								system.debug('searchQuery for po::'+searchQuery);
						}
						else
						{
							searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name,Type,sigmaerpdev2__Status__c,sigmaerpdev2__Active__c where type=:filterCondition) Limit 1000'; 
								system.debug('searchQuery for po::'+searchQuery);
						}
                    
                }
                  
            } 
            
            else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Currency__c')
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,Name,sigmaerpdev2__Display_Name__c) Limit 1000'; 
            } 
         else if(sanitizedSObjectAPIName == 'Contact')
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,Name) Limit 1000'; 
            } 
         else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Company__c')
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,Name) Limit 1000'; 
            } 
        else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Tax_Treatment__c')
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,Name) Limit 1000'; 
            } 
        else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Tax_Code__c')
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,Name) Limit 1000'; 
            } 
            else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Sublevel_location__c')
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,Name) Limit 1000'; 
            } 
            
            
            //code for subscription
            else if(sanitizedSObjectAPIName == 'sigmaerpdev2__SubscriptionDetail__c')
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,sigmaerpdev2__Subscription_Name__c) Limit 100'; 
            }
            else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Subscription_Line_Item__c' )
            {
                //searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,Name) Limit 100';
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,Name where sigmaerpdev2__Subscription__r.sigmaerpdev2__Subscription_Name__c=:filterCondition ) Limit 100'; 
            }
            else if(sanitizedSObjectAPIName == 'Contact' && filterCondition!=null)
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name where Account.name =:filterCondition) Limit 1000'; 
                system.debug('searchQuery>>'+searchQuery);
            }
            
            else if( sanitizedSObjectAPIName == 'sigmaerpdev2__Purchase_Order__c' && filterCondition!=null)
            {
                system.debug('filterCondition>>'+filterCondition);
                ID Ids=ID.ValueOf(filterCondition);
                String status='Submitted';
                String sts= String.escapeSingleQuotes(status);
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name,sigmaerpdev2__Status__c where  sigmaerpdev2__Product_Supplier__c=:filterCondition) Limit 1000'; 
            }else if(sanitizedSObjectAPIName ==' ' && filterCondition!=null)
            {
                ID Ids=ID.ValueOf(filterCondition);
                String status='Open';
                String sts= String.escapeSingleQuotes(status);
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name,sigmaerpdev2__Status__c,sigmaerpdev2__Product__c,sigmaerpdev2__Product__r.Name where sigmaerpdev2__Purchase_Order__c=:filterCondition) Limit 1000'; 
            }
            else if(sanitizedSObjectAPIName ==' ' && filterCondition!=null)
            {
                ID Ids=ID.ValueOf(filterCondition);
                String status='Closed';
                String sts= String.escapeSingleQuotes(status);
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name,sigmaerpdev2__Status__c,sigmaerpdev2__Product__c,sigmaerpdev2__Product__r.Name where sigmaerpdev2__Purchase_Order__c=:filterCondition) Limit 1000'; 
            }
            else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Package__c' && filterCondition!=null)
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name,sigmaerpdev2__Status__c,sigmaerpdev2__Canceled_Package__c where sigmaerpdev2__Customer__c=:filterCondition)  Limit 1000'; 
                
            }else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Package__c')
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name,sigmaerpdev2__Status__c,sigmaerpdev2__Canceled_Package__c)  Limit 1000'; 
                
            }
            //added for Proposal time based product filtering on 12-8-2019 by vikas
            else if(sanitizedSObjectAPIName =='Product2' && filterCondition == 'true')
            {
                system.debug('inside>>');
             /*   if(filterCondition=='MyVendorProduct')
                {
                     system.debug('inside>>1');
                    system.debug('sanitizedSearchString------>>>'+sanitizedSearchString);
                    searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name,Type__c where sigmaerpdev2__Active__c = true AND RecordType.Name=\'Individual\') Limit 1000';               //        
                    system.debug('searchQuery------>>>'+searchQuery);  
                }
                else{*/
                     system.debug('inside>>1');
                     system.debug('sanitizedSearchString------>>>'+sanitizedSearchString);
                    if(currentuser.Profile.Name == Custset.Retailer_Profile_Name__c)
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name,Type__c where sigmaerpdev2__Active__c = true and sigmaerpdev2__Stock_Item__c=true and CreatedById =: UserId) Limit 1000';   
            }
            else
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name,Type__c where sigmaerpdev2__Active__c = true and sigmaerpdev2__Stock_Item__c=true) Limit 1000';   
            }
                                 //AND RecordType.Name=\'Individual\'        
                     system.debug('searchQuery------>>>'+searchQuery);
              //  }
               
            }
            //ends here
            else if(sanitizedSObjectAPIName =='Product2')
            {
                 system.debug('inside>>2');
                 system.debug('sanitizedSearchString1------>>>'+sanitizedSearchString);
                 
                 //for FFTB purpose added code to get community user
            if(currentuser.Profile.Name == Custset.Retailer_Profile_Name__c)
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name,Type__c where IsActive=true and CreatedById =: UserId) Limit 1000'; 
            }
            else
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name,Type__c where IsActive=true) Limit 1000'; 
            }
                 
                
                 system.debug('searchQuery1------>>>'+searchQuery);
            }
            else if(sanitizedSObjectAPIName =='Product2Rental')
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING Product2 (Id,Name,sigmaerpdev2__Type__c where sigmaerpdev2__Rental_Product__c=true) Limit 1000'; 
            }
            else if(sanitizedSObjectAPIName =='AccComp' && filterCondition!=null)
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING Account (id,name,Type,sigmaerpdev2__Status__c,sigmaerpdev2__Active__c where type=:filterCondition) Limit 1000'; 
                System.debug('searchQuery AccComp>>>>>>>>>>>>'+searchQuery);
            }
            else if(sanitizedSObjectAPIName =='Purchase' && filterCondition =='All')
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING sigmaerpdev2__Purchase_Order__c (id,name) Limit 1000'; 
                System.debug('searchQuery AccComp>>>>>>>>>>>>'+searchQuery);
            }   
            
            else if(sanitizedSObjectAPIName =='sigmaerpdev2__Vendor_Product__c')
            {
                 if( CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Vendor_Product__c')
                     && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Vendor_Product__c',new Set<String>{'Id','Name','sigmaerpdev2__Product_Name__c','sigmaerpdev2__Product_Name__r.Id','sigmaerpdev2__Account_Name__c'}) 
                    )
                {
                                
                    List<Vendor_Product__c> venProd = new List<Vendor_Product__c>();
                    venProd = [select Product_Name__r.Id From Vendor_Product__c where Account_Name__c =:filterCondition]; 
                    List<Id> prodIdList = new List<Id>();
                    for(Vendor_Product__c vp:venProd){
                        prodIdList.add(vp.Product_Name__r.Id);
                    }
                    searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING Product2 (Id,Name where Id IN: prodIdList and sigmaerpdev2__Stock_Item__c = true ) Limit 1000'; //AND RecordType.Name = \'Individual\'
                 }                  
                
            }
            else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Resource__c')
            {
               searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,Name,sigmaerpdev2__Roles__c where type=:filterCondition) Limit 1000'; 
               system.debug('searchQuery for sigmaerpdev2__Resource__c::'+searchQuery);
            }
            else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Project_Resource__c')
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name,sigmaerpdev2__Resource__c,sigmaerpdev2__Resource__r.Name,sigmaerpdev2__Resource__r.sigmaerpdev2__Roles__c  where sigmaerpdev2__Resource__c=:filterCondition) Limit 1000'; 
            }
            else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Sigma_Order__c')
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name,sigmaerpdev2__AccountId__c,sigmaerpdev2__Orders_Status__c,sigmaerpdev2__Order_Number__c,sigmaerpdev2__Fully_Packaged__c,sigmaerpdev2__Order_Created_Via__c  where sigmaerpdev2__AccountId__c=:filterCondition) Limit 1000'; 
            }
            else if(sanitizedSObjectAPIName == 'Order')
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,Name,Account.id,Account.Name,sigmaerpdev2__Orders_Status__c,OrderNumber,sigmaerpdev2__Fully_Packaged__c,sigmaerpdev2__Order_Created_Via__c ) Limit 1000'; 
            }
            else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Order__c')
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name,sigmaerpdev2__Order__r.Account.id,sigmaerpdev2__Order__r.Account.Name,sigmaerpdev2__AccountId__c,sigmaerpdev2__Orders_Status__c,sigmaerpdev2__Order__r.OrderNumber,sigmaerpdev2__Fully_Packaged__c,sigmaerpdev2__Order_Created_Via__c ) Limit 1000'; 
            }
            else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Lot__c')
            {
                System.debug('inside::');
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name,sigmaerpdev2__Location_Name__c,sigmaerpdev2__Lot_Name__c,sigmaerpdev2__Product__c,sigmaerpdev2__Inventory_Location__c,sigmaerpdev2__Created_Date__c,sigmaerpdev2__Expiry_Date__c,sigmaerpdev2__Quantity__c where Product__r.Id=:filterCondition) Limit 1000'; 
            }
            else if(sanitizedSObjectAPIName == 'LotforLotView')
            {
                System.debug('inside::');
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING sigmaerpdev2__Lot__c (id,name,sigmaerpdev2__Location_Name__c,sigmaerpdev2__Lot_Name__c,sigmaerpdev2__Product__c,sigmaerpdev2__Inventory_Location__c,sigmaerpdev2__Created_Date__c,sigmaerpdev2__Expiry_Date__c,sigmaerpdev2__Quantity__c) Limit 1000'; 
            }
            else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Inventory_Location__c' && filterCondition!=null)
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name,sigmaerpdev2__Actual_Quantity__c,sigmaerpdev2__Available_Quantity__c,sigmaerpdev2__Inventory__c,sigmaerpdev2__Last_Quantity_Received__c,sigmaerpdev2__Last_Received_Date__c,sigmaerpdev2__Location__c,sigmaerpdev2__Location__r.Name,sigmaerpdev2__LocationName__c,sigmaerpdev2__Merchant_Account__c,sigmaerpdev2__Parent_Account__c,sigmaerpdev2__Product_Name__c) Limit 1000'; 
            }
            else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Inventory__c')
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING sigmaerpdev2__Inventory__c (id,name) Limit 1000'; 
            }
            else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Inventory_Location_Product__c' && filterCondition!=null)
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name,sigmaerpdev2__Adjusted_Quantity__c,sigmaerpdev2__Availability__c,sigmaerpdev2__Delivered_Quantity__c,sigmaerpdev2__End_Date__c,sigmaerpdev2__Inventory__c,sigmaerpdev2__Inventory_Location__c,sigmaerpdev2__Products__c,sigmaerpdev2__Products__r.Name where sigmaerpdev2__Inventory_Location__c=:filterCondition) Limit 1000'; 
                
            }
            else if(sanitizedSObjectAPIName =='User')
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name) Limit 1000'; 
                
            }
            else if(sanitizedSObjectAPIName =='Productname')
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING sigmaerpdev2__Inventory_Location_Product__c (id,sigmaerpdev2__Products__c,sigmaerpdev2__Product_Name__c where sigmaerpdev2__Inventory_Location__c =:filterCondition) Limit 1000'; 
                
            }
            //code added by Anuja
            //To filter Open status
            else if( sanitizedSObjectAPIName == 'sigmaerpdev2__Purchase_Order_Product__c' && filterCondition!=null)
            {
                System.debug('inside'); 
                ID Ids=ID.ValueOf(filterCondition);
                System.debug('Ids'+Ids); 
                String status='Open';
                String sts= String.escapeSingleQuotes(status);
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name,sigmaerpdev2__Status__c,sigmaerpdev2__Product__c where  sigmaerpdev2__Purchase_Order__c =:filterCondition) Limit 50'; 
                System.debug('searchQuery'+searchQuery); 
            }
            else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Work_Order__c')
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,Name) Limit 1000'; 
            }
            //query on service contract line item
            else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Service_Contract__c' && filterCondition!=null)
            {
                if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Service_Contract__c')
                    && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Service_Contract_Line_Item__c')
                    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Service_Contract__c',new Set<String>{'Id','Name','sigmaerpdev2__Contract_End_Date__c','sigmaerpdev2__Status__c','sigmaerpdev2__Product__c'})
                    && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Service_Contract_Line_Item__c',new Set<String>{'Id','Name','sigmaerpdev2__Service_Contract__c','sigmaerpdev2__Service_Contract__r.sigmaerpdev2__Customer__c','sigmaerpdev2__Product__c'})
                )
                {
                    system.debug('filterCondition'+filterCondition);
                    List<Id> ids = new List<Id>();
                    for(Service_Contract_Line_Item__c temp: [select Service_Contract__c from Service_Contract_Line_Item__c where Service_Contract__r.Customer__c =:filterCondition and Product__c =:filterCondition1])
                    {
                        ids.add(temp.Service_Contract__c);
                    }
                
                
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name,sigmaerpdev2__Contract_End_Date__c  where id=:ids and sigmaerpdev2__Contract_End_Date__c >=Today and sigmaerpdev2__Status__c=\'Active\')  Limit 1000'; 
                system.debug('result++++'+searchQuery);
                }
            }
            else 
            {
                searchQuery = 'FIND {' + sanitizedSearchString + '*} IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name,sigmaerpdev2__Status__c,sigmaerpdev2__Product__c) Limit 1000'; 
            }
            // Execute the Query
            List<List<SObject>> searchList = search.query(searchQuery);
            system.debug('searchList>>0'+searchList);
            // Create a list of matches to return
            List<Id> POID = new List<Id>();
            for (SObject so : searchList[0])
            {
                if(sanitizedSObjectAPIName == 'Account')
                {
                    if(so.get('Type') == 'Customer'){
                        
                        results.add(new Result((String)so.get('Name'), so.Id)); 
                    }else if(so.get('Type') == 'Vendor')
                    {
                        if(so.get('sigmaerpdev2__Active__c') == 'Yes')
                        {
                            results.add(new Result((String)so.get('Name'), so.Id));
                        }
                    }
                    
                    else{
                        results.add(new Result((String)so.get('Name'), so.Id)); 
                    }  
                }
                //code for subscription
                else if(sanitizedSObjectAPIName == 'sigmaerpdev2__SubscriptionDetail__c')
                {
                    results.add(new Result((String)so.get('sigmaerpdev2__Subscription_Name__c'), so.Id));  
                }            
                else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Subscription_Line_Item__c')
                {
                    results.add(new Result((String)so.get('Name'), so.Id));  
                }
                 //code for subscription
                else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Project_Resource__c')
                {
                    results.add(new Result((String)so.get('sigmaerpdev2__Resource__c'), so.Id));  
                } 
                else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Package__c')
                {
                    if(so.get('sigmaerpdev2__Status__c') == 'Ready' && so.get('sigmaerpdev2__Canceled_Package__c') == false)
                    {
                        results.add(new Result((String)so.get('Name'), so.Id)); 
                    }
                }
                else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Vendor_Product__c')
                {
                    results.add(new Result((String)so.get('Name'), so.Id)); 
                    
                }
                
                //code for Currency
                else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Currency__c')
                {
                    results.add(new Result((String)so.get('sigmaerpdev2__Display_Name__c'), so.Id)); 
                    system.debug('results>>'+results);
                }
                else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Sublevel_location__c')
                {
                    results.add(new Result((String)so.get('Name'), so.Id)); 
                    system.debug('results>>'+results);
                }
                else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Tax_Treatment__c')
                {
                    results.add(new Result((String)so.get('Name'), so.Id)); 
                    system.debug('results>>'+results);
                }
                else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Tax_Code__c')
                {
                    results.add(new Result((String)so.get('Name'), so.Id)); 
                    system.debug('results>>'+results);
                }
                 else if(sanitizedSObjectAPIName == 'Contact')
                {
                    results.add(new Result((String)so.get('Name'), so.Id)); 
                    system.debug('results>>'+results);
                }
                else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Company__c')
                {
                    results.add(new Result((String)so.get('Name'), so.Id)); 
                    system.debug('results>>'+results);
                }
                
                //added by sandhya
                else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Inventory__c')
                {
                    results.add(new Result((String)so.get('Name'), so.Id));
                }
                else if(sanitizedSObjectAPIName == 'AccComp')
                {
                    results.add(new Result((String)so.get('Name'), so.Id));
                    system.debug('results>>>>>>>>>>>'+results);
                }
                
                else if(sanitizedSObjectAPIName == 'Purchase')
                {
                    results.add(new Result((String)so.get('Name'), so.Id));
                    system.debug('results>>>>>>>>>>>'+results);
                }
                
                else  if(sanitizedSObjectAPIName == 'sigmaerpdev2__Sigma_Order__c')
                {
                    if(so.get('sigmaerpdev2__Orders_Status__c') == 'Order Confirmed' && so.get('sigmaerpdev2__Fully_Packaged__c')!=true && so.get('sigmaerpdev2__Order_Created_Via__c')!='Time Based Inventory')
                    {
                        results.add(new Result((String)so.get('Name'),so.Id));
                    }                 
                }
                else  if(sanitizedSObjectAPIName == 'sigmaerpdev2__Order__c')
                {
                    if(so.get('sigmaerpdev2__Orders_Status__c') == 'Order Confirmed' && so.get('sigmaerpdev2__Fully_Packaged__c')!=true && so.get('sigmaerpdev2__Order_Created_Via__c')!='Time Based Inventory')
                    {
                        results.add(new Result((String)so.get('Name'),so.Id));
                    }                 
                }
                else  if(sanitizedSObjectAPIName == 'Order')
                {
                    if(so.get('sigmaerpdev2__Orders_Status__c') == 'Order Confirmed' && so.get('sigmaerpdev2__Fully_Packaged__c')!=true && so.get('sigmaerpdev2__Order_Created_Via__c')!='Time Based Inventory')
                    {
                        results.add(new Result((String)so.get('OrderNumber'),so.Id));
                    }         
                }
                else  if(sanitizedSObjectAPIName == 'sigmaerpdev2__Purchase_Order__c')
                {
                    if(so.get('sigmaerpdev2__Status__c') == 'Submitted')
                    {
                        results.add(new Result((String)so.get('Name'), so.Id)); 
                    }
                    
                }else  if(sanitizedSObjectAPIName == 'sigmaerpdev2__Purchase_Order_Product__c')
                {   
                    if(so.get('sigmaerpdev2__Status__c') == 'Open' || so.get('sigmaerpdev2__Status__c') == 'Partial Delivery')
                    {
                        POID.add((ID)so.get('sigmaerpdev2__Product__c'));
                        System.debug('POID::'+POID);
                    }
                }else if(sanitizedSObjectAPIName == 'Contact')
                {
                    results.add(new Result((String)so.get('Name'), so.Id));
                }else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Lot__c'){
                    results.add(new Result((String)so.get('Name'), so.Id));
                }
                else if(sanitizedSObjectAPIName == 'LotforLotView'){
                    results.add(new Result((String)so.get('Name'), so.Id));
                }
                else if(sanitizedSObjectAPIName =='Product2')
                {
                    if(so.get('sigmaerpdev2__Type__c') == 'BOM' || so.get('sigmaerpdev2__Type__c') == 'Individual'){
                        
                        results.add(new Result((String)so.get('Name'), so.Id));      
                    }
                    else{
                        
                        results.add(new Result((String)so.get('Name'), so.Id)); 
                    }
                }
                else if(sanitizedSObjectAPIName =='Product2Rental')
                {
                    if(so.get('sigmaerpdev2__Type__c') == 'BOM' || so.get('sigmaerpdev2__Type__c') == 'Individual'){
                        
                        results.add(new Result((String)so.get('Name'), so.Id));      
                    }
                    else{
                        
                        results.add(new Result((String)so.get('Name'), so.Id)); 
                    }
                }
                else if(sanitizedSObjectAPIName =='sigmaerpdev2__Inventory_Location__c')
                {
                    
                results.add(new Result((String)so.get('sigmaerpdev2__LocationName__c'), so.Id)); 
                 //     results.add(new Result((String)so.get('sigmaerpdev2__Location__r.Name'), so.Id)); 
                    system.debug('results>>>'+results);
                }  
                else if(sanitizedSObjectAPIName =='sigmaerpdev2__Inventory_Location_Product__c')
                {
                    results.add(new Result((String)so.get('Name'), so.Id));      
                } 
                else if(sanitizedSObjectAPIName == 'User')
                {
                    results.add(new Result((String)so.get('Name'), so.Id)); 
                }
                else if(sanitizedSObjectAPIName == 'Productname'){
                    results.add(new Result((String)so.get('sigmaerpdev2__Product_Name__c'), so.Id));
                }
                else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Work_Order__c')
                {
                    results.add(new Result((String)so.get('Name'), so.Id));  
                }
                else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Service_Contract__c')
                {
                    results.add(new Result((String)so.get('Name'), so.Id));  
                }
                
                else if(sanitizedSObjectAPIName == 'sigmaerpdev2__Service_Contract_Line_Item__c')
                {
                    results.add(new Result((String)so.get('sigmaerpdev2__Service_Contract__r.Name'), so.Id));  
                }
                else
                {
                    
                    System.debug('Inside ApiName is Nomatch for any Object else condition of Product Type is BOM Or Individual');
                }
                
                
            }
            
            if(POID !=null)
            {
                System.debug('POID::');
                List<Purchase_Order_Product__c>  pName =new List<Purchase_Order_Product__c>();
                if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order_Product__c')
                && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order_Product__c',new Set<String>{'Id','Name','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Status__c','sigmaerpdev2__Purchase_Order__c','sigmaerpdev2__Product__c','sigmaerpdev2__Tax_Code__c','sigmaerpdev2__Tax_Code__r.Name'}))
               
                { 
                    pName=[Select Id,Name,Product__r.Name,Status__c,sigmaerpdev2__Tax_Code__r.Name from Purchase_Order_Product__c where Product__c In :POID AND Purchase_Order__c=:filterCondition];
                    System.debug('pName::'+pName);
                }    
                for(Purchase_Order_Product__c pr:pName)
                {
                    results.add(new Result(pr.Product__r.Name, pr.Id)); 
                    
                }
                
            }
//}
        System.debug('results::'+results);
        return results;
    
}
    
    /**
* Inner class to wrap up an SObject Label and its Id
*/
    public class Result
    {
        @AuraEnabled public String SObjectLabel {get; set;}
        @AuraEnabled public Id SObjectId {get; set;}
        
        public Result(String sObjectLabel, Id sObjectId)
        {
            this.SObjectLabel = sObjectLabel;
            this.SObjectId = sObjectId;
        }
    }
    
   /* @AuraEnabled
    public static Account fetchAddress(String customer)
    {    
        Account acc;
        
        if(CRUD_FLS_CheckUtility.checkObjCRUD('Account')
           && CRUD_FLS_CheckUtility.checkReadPermission('Account',new Set<String>{'Id','Name','ShippingStreet','ShippingCity','ShippingState','ShippingPostalcode','ShippingCountry'}))
        {
            acc = [ SELECT ShippingStreet,ShippingCity,ShippingState,ShippingPostalcode,ShippingCountry from Account WHERE Name =: customer ];
        }
        
        return acc;
    } */
    
    /*@AuraEnabled
    public static Account fetchAddress(String customer)
    {    
        Account acc;
        
        
        acc = [ SELECT ShippingStreet,ShippingCity,ShippingState,ShippingPostalcode,ShippingCountry from Account WHERE Name =: customer ];
        
        return acc;
    }*/
    
    
    @AuraEnabled
    public static Product2 fetchProduct(Id prodId)
    {    
        
        Product2 prod;
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
           && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'Id','Name','sigmaerpdev2__Product_Description__c','sigmaerpdev2__Product_Price__c','sigmaerpdev2__Max_Discount__c','sigmaerpdev2__Product_Weight__c','sigmaerpdev2__SKU__c'}))
        {*/
            prod = [Select Id,Name,Product_Description__c,Product_Price__c,Max_Discount__c,Product_Weight__c,SKU__c  from Product2 where Id =:prodId];
        //}
        
        return prod;
    } 
    
    
   
    @AuraEnabled
    public static Default_Parameters__c getCurrency()
    {
        Default_Parameters__c options;
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Default_Parameters__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Default_Parameters__c',new Set<String>{'Id','sigmaerpdev2__Inventory_Status__c','sigmaerpdev2__Package_ID__c','sigmaerpdev2__Parent_Id__c','sigmaerpdev2__Shipment_ID__c','sigmaerpdev2__StockReceiving_ID__c','sigmaerpdev2__Currency__c'}))
        {*/
            
            options = [select Id,Inventory_Status__c,Package_ID__c,Parent_Id__c,Shipment_ID__c,StockReceiving_ID__c,Currency__c from Default_Parameters__c limit 1];
        //}
        return options;
    }
     @AuraEnabled
    public static Id orderSave(List<String> productList, String OrderIDD ,Id accId,String subid,String billingPerson,String custType,String storeName,Double allPdtsAmount,Date orderdelivarydate,
                               String ShippingStreet,String ShippingCity,String ShippingState,String ShippingPostalcode, String ShippingCountry)
    {   
        Id orderId = OrderIDD;

        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Default_Parameters__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__OrderLineLocation__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c')
            && CRUD_FLS_CheckUtility.checkObjCRUD('Account')
            && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Tax__c') 
           // && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Dimension_Tag__c')    

            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'Id','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__ProductCode__c','sigmaerpdev2__Delivered_Qty__c','sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Purchased_Qty__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__ProductCode__r.Id'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'id','name','sigmaerpdev2__Products__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Delivered_Quantity__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Products__r.Id'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'id','name','sigmaerpdev2__Type__c','sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Received_Quantity1__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Adjusted_Quantity__c','sigmaerpdev2__Available_Quantity__c','sigmaerpdev2__AvailableAdjustedQty__c'})
            //&& CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Dimension_Tag__c',new Set<String>{'id','sigmaerpdev2__Ordered_Amount__c','sigmaerpdev2__Account__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new Set<String>{'id','name','sigmaerpdev2__Net_Amount__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new Set<String>{'id','name','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c'})
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Default_Parameters__c',new Set<String>{'Id','sigmaerpdev2__Inventory_Status__c','sigmaerpdev2__Default_Location__c','sigmaerpdev2__Package_ID__c','sigmaerpdev2__Parent_Id__c','sigmaerpdev2__Shipment_ID__c','sigmaerpdev2__StockReceiving_ID__c'})  
            
            && CRUD_FLS_CheckUtility.checkFLS('Account',new Set<String>{'ShippingStreet','ShippingCity','ShippingState','ShippingCountry','ShippingPostalCode'}) 
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new Set<String>{'sigmaerpdev2__Available_Qty__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev2__Delivered_Quantity__c','sigmaerpdev2__Products__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'sigmaerpdev2__Reserved_Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Inventory_Location_Product__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Order__c',new Set<String>{'sigmaerpdev2__Billing_Person__c','sigmaerpdev2__Customer_Type__c','sigmaerpdev2__StoreName__c','sigmaerpdev2__EffectiveDate__c','sigmaerpdev2__Status__c','sigmaerpdev2__Orders_Status__c','sigmaerpdev2__Order_Type__c','sigmaerpdev2__Account_Subscription_Interval__c','sigmaerpdev2__Order_Created_Via__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Delivary_Date__c','sigmaerpdev2__Tax_Amount__c','sigmaerpdev2__Tax__c','sigmaerpdev2__Net_Amount__c','sigmaerpdev2__ShippingPostalCode__c','sigmaerpdev2__ShippingCountry__c','sigmaerpdev2__ShippingState__c','sigmaerpdev2__ShippingCity__c','sigmaerpdev2__Shipping_Street__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev2__Remaining_Qty_To_Package__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Total_Price__c','sigmaerpdev2__Total_Amount__c','sigmaerpdev2__Discounts__c','sigmaerpdev2__Inventory_Status__c','sigmaerpdev2__tax_amount__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__Delivary_Date__c','sigmaerpdev2__Order_Status__c','sigmaerpdev2__Order_Id__c'})
            && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__OrderLineLocation__c',new Set<String>{'sigmaerpdev2__Location__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Status__c','sigmaerpdev2__Allocation_Done__c','sigmaerpdev2__Inventory_Status__c','sigmaerpdev2__Product_Price__c','sigmaerpdev2__Inventory_Location_Product__c'})
           // && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Dimension_Tag__c',new Set<String>{'sigmaerpdev2__Ordered_Amount__c'})
        
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__OrderLineLocation__c',new Set<String>{'sigmaerpdev2__Order_Line__c'})
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev2__Sigma_Order__c'})
            && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Sigma_Order__c',new Set<String>{'sigmaerpdev2__AccountId__c'})

        ){*/
        system.debug('OrderIDD>>'+OrderIDD);
        system.debug('billingPerson>>'+billingPerson);
        system.debug('billingPerson>>'+billingPerson);
        system.debug('custType>>'+custType);
        String inventorystatus;
        String invlocation;
        List<Inventory_Location_Product__c> ILP=new List<Inventory_Location_Product__c>();
        List<Inventory_Location_Product_Line_Item__c> ILPLI =new  List<Inventory_Location_Product_Line_Item__c>();
        
        Default_Parameters__c options;
        options = [select Id,Inventory_Status__c,Default_Location__c,Package_ID__c,Parent_Id__c,Shipment_ID__c,StockReceiving_ID__c from Default_Parameters__c limit 1];

        inventorystatus = options.Inventory_Status__c; 
        invlocation  = options.Default_Location__c;
        
        Map<Id,List<OrderLineLocation__c>> OrderLineItemLocations = new Map<Id,List<OrderLineLocation__c>>();
        List<OrderLineLocation__c> OrderLineLocList ;
        Map<Id,Product_Order_Price_Book__c> retainOrderLineData = new Map<Id,Product_Order_Price_Book__c>();
        List<Inventory__c> inventoryObj = new List<Inventory__c>();
        Sigma_Order__c productOrder ;
       
        system.debug('orderId>>'+orderId);
        Boolean temp = false;
        Double TaxOnBillAmount = 0; 
        Integer numOfOrderLines = 0;
        Integer numofProds = 0;
        String delivarydate;
        Integer netQuantity = 0;
        Double ProdDiscountd = 0.0;
        Double ProdDiscountsd = 0.0;
        
       
        
        //For updating customer shipping address to Account
        system.debug('temp>>'+temp);
        Account acc =  New Account();
        acc.Id = accId;
        acc.ShippingStreet = ShippingStreet;
        acc.ShippingCity = ShippingCity;
        acc.ShippingState = ShippingState;
        acc.ShippingPostalCode = ShippingPostalcode;
        acc.ShippingCountry = ShippingCountry;
        
        upsert acc;
        system.debug('acc>>'+acc);
        If(OrderIDD InstanceOf Id)
        {
            temp = true;
        }
        Sigma_Order__c editingOrder;
        if(temp)
        {
            //code is deleted
            system.debug('Do Nothing!!');
            
        }
        else
        {

            system.debug('inside else part>>');
            productOrder = new Sigma_Order__c();
            productOrder.AccountId__c = accId;
            productOrder.Billing_Person__c = billingPerson;
            productOrder.Customer_Type__c =custType;
            productOrder.StoreName__c = storeName; 
            productOrder.EffectiveDate__c = Date.today(); 
            productOrder.Status__c = 'Draft';
            productOrder.Orders_Status__c = 'Pending';
            productOrder.Order_Type__c = 'OFFLINE';
            productOrder.Account_Subscription_Interval__c= subid;
            productOrder.Shipping_Street__c=ShippingStreet;
            productOrder.ShippingCity__c=ShippingCity;
            productOrder.ShippingState__c=ShippingState;
            productOrder.ShippingPostalCode__c=ShippingPostalCode;
            productOrder.ShippingCountry__c=ShippingCountry;
            
            if(subid!=null)
            {
                productOrder.Account_Subscription_Interval__c= subid; 
                productOrder.Order_Created_Via__c = 'Subscription';
            }
            else{
                productOrder.Order_Created_Via__c = 'POS';
            }
            numOfOrderLines = productList.size();
            for(String a: productList)
            {
                String str =a;
                List<String> jsonList = new List<String>();
                jsonList = str.split('},');
                for (Integer i=0 ; i<jsonList.size() ; i++ )
                {
                    
                    String s1 = '';
                    if(i != jsonList.size()-1)
                    {
                        s1 = jsonList.get(i)+'}';
                    }
                    else
                    {    
                        s1 = jsonList.get(i);
                        
                    }
                    Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(s1); 
                    numofProds = numofProds + Integer.valueOf(root.get('quantity'));
                    if(root.get('Discount') != null && root.get('Discount') != ''){
                        ProdDiscountd = ProdDiscountd + Double.valueOf(root.get('Discount'));
                    }
                    else{
                        ProdDiscountd =0;
                    }
                }                
            }
            netQuantity = numofProds;
            ProdDiscountsd = ProdDiscountd;
            productOrder.Net_Quantity__c= netQuantity;
            productOrder.Quantity__c= netQuantity;
            if(orderdelivarydate!=null )
            {
                productOrder.Delivary_Date__c=orderdelivarydate;
            }
            

            
            List<Tax__c> taxObj = TaxCntr.getTax(accId);
            Double federalTax = Double.valueOf(taxObj.get(0).Tax_Amount__c);
            String fedTaxType = String.valueOf(taxObj.get(0).Type__c);
            
            Double stateTax = Double.valueOf(taxObj.get(1).Tax_Amount__c);
            String stateTaxType = String.valueOf(taxObj.get(1).Type__c);
            
            if(fedTaxType == 'Percentage'){
                TaxOnBillAmount = (allPdtsAmount * federalTax)/100;
            }else{
                TaxOnBillAmount = allPdtsAmount + federalTax;
            }               
            
            if(stateTaxType == 'Percentage'){
                TaxOnBillAmount = (TaxOnBillAmount + (allPdtsAmount * stateTax)/100);
            }else{
                TaxOnBillAmount = (TaxOnBillAmount + (allPdtsAmount + stateTax));
            }        
            productOrder.Tax_Amount__c = TaxOnBillAmount;
            productOrder.Tax__c = federalTax+stateTax;
            productOrder.Net_Amount__c=allPdtsAmount;
            productOrder.TotalAmount__c = allPdtsAmount + TaxOnBillAmount;
            
        } 
        
        List<Product_Order_Price_Book__c> productLines = new List<Product_Order_Price_Book__c>();
        Product_Order_Price_Book__c productLineObj;
        
        List<Inventory__c> inventoryLines = new List<Inventory__c>();
        
        List<Inventory_Location_Product__c> ILPList = new List<Inventory_Location_Product__c>();
        List<Inventory_Location_Product_Line_Item__c> ILPLIList = new List<Inventory_Location_Product_Line_Item__c>();
        
        numOfOrderLines = productList.size();
        Map<id,Decimal> proids= new Map<id,Decimal>();
        for(String a: productList)
        {
            productLineObj = new Product_Order_Price_Book__c();
            Inventory_Location_Product__c ILPrd = new Inventory_Location_Product__c();
            
            String str =a;// a.substring(1, a.length()-1);
            List<String> jsonList = new List<String>();
            jsonList = str.split('},');
            for (Integer i=0 ; i<jsonList.size() ; i++ )
            {
                String s1 = '';
                if(i != jsonList.size()-1)
                {
                    s1 = jsonList.get(i)+'}';
                }
                else
                {    
                    s1 = jsonList.get(i);
                    
                }  
                
                Map<String, Object> root = (Map<String, Object>) JSON.deserializeUntyped(s1);
                productLineObj.Product__c = String.valueOf(root.get('Id'));
                productLineObj.Quantity__c = Integer.valueOf(root.get('quantity'));
                productLineObj.Remaining_Qty_To_Package__c = Integer.valueOf(root.get('quantity'));
                proids.put( productLineObj.Product__c, productLineObj.Quantity__c);
                productLineObj.Net_Quantity__c= Integer.valueOf(root.get('quantity'));
                productLineObj.Total_Amount__c = Double.valueOf(root.get('productAmount'));
                productLineObj.Total_Price__c = Double.valueOf(root.get('totalAmount'));
                system.debug('productLineObj111>>'+productLineObj);
                if(root.get('Discount') != null && root.get('Discount') != ''){
                    productLineObj.Discounts__c = Double.valueOf(root.get('Discount'));
                }
                else{
                    productLineObj.Discounts__c = 0.0;
                }
              
                delivarydate=String.valueOf(root.get('date'));
                if(delivarydate!='' && delivarydate!=null)
                {
                    productLineObj.Delivary_Date__c=Date.valueOf(delivarydate); 
                }
                productLineObj.Order_Status__c = 'Pending';
                if(retainOrderLineData.containsKey(productLineObj.Product__c))
                {
                    productLineObj.Start_Date__c = retainOrderLineData.get(productLineObj.Product__c).Start_Date__c;
                    productLineObj.End_Date__c = retainOrderLineData.get(productLineObj.Product__c).End_Date__c;
                }
                
                Double taxForPriceBookItems;
                Double totalAmountOL = Double.valueOf(root.get('totalAmount'));
                
                taxForPriceBookItems = (Double.valueOf(totalAmountOL) / Double.valueOf(allPdtsAmount)) * Double.valueOf(TaxOnBillAmount);
                productLineObj.tax_amount__c = taxForPriceBookItems;
                if(inventorystatus =='Reserve' )
                {
                    productLineObj.Inventory_Status__c = 'Reserve';
                }else
                {
                    productLineObj.Inventory_Status__c = 'Allocated';
                }
                
                
                productLines.add(productLineObj);
                system.debug('productLines22>>'+productLines);
            }
        }
       
        inventoryObj = [Select Id,Available_Qty__c,ProductCode__c,Delivered_Qty__c ,Reserved_Qty__c,Purchased_Qty__c, Total_Available_Qty__c from Inventory__c where ProductCode__r.Id=:proids.keyset()];
        system.debug('inventoryObj::'+inventoryObj);
        if(inventorystatus !='Reserve')
        {
            
            ILP = [select id, name,Products__c, Net_Quantity__c,Delivered_Quantity__c,Inventory_Location__c, Received_Quantity__c from Inventory_Location_Product__c where Products__r.Id = :proids.keyset()];
            system.debug('ilp::'+ILP);                       
            ILPLI = [select id, name,Type__c,Reserved_Quantity__c,Received_Quantity1__c,Received_Quantity__c,Product__c,Inventory_Location_Product__c,Inventory_Location__c,Adjusted_Quantity__c,Available_Quantity__c,AvailableAdjustedQty__c from Inventory_Location_Product_Line_Item__c where Product__c =:proids.keyset()];
            system.debug('ilpli::'+ILPLI);
            Map<id,Decimal> ilpdelqty=new Map<id,Decimal>();
            Map<id,Inventory_Location_Product__c> ilpmap=new Map<id,Inventory_Location_Product__c>();
            Map<id,Inventory_Location_Product__c> ilpproid=new Map<id,Inventory_Location_Product__c>();
            for(Inventory_Location_Product__c ilpqty:ILP)
            {
                
                if(proids.containsKey(ilpqty.Products__c) && ilpqty.Net_Quantity__c > 0.0 && (!ilpproid.containsKey(ilpqty.Products__c)))
                {
                    
                    ilpqty.Delivered_Quantity__c = ilpqty.Delivered_Quantity__c + proids.get(ilpqty.Products__c);
                    ilpmap.put(ilpqty.id,ilpqty);
                    ilpproid.put(ilpqty.Products__c,ilpqty);
                    ilpdelqty.put(ilpqty.id,proids.get(ilpqty.Products__c));
                    
                    // break ;
                }       
                System.debug('ilpqty2222::'+ilpqty);
            }
            Map<id,Inventory_Location_Product_Line_Item__c> ilplimap=new Map<id,Inventory_Location_Product_Line_Item__c>();
            
            
            for(Inventory_Location_Product_Line_Item__c ilpliqty:ILPLI)
            {
                System.debug('ilpliqty1111::'+ilpliqty);
                if(proids.containsKey(ilpliqty.Product__c) && ilpliqty.Available_Quantity__c > 0.0 &&(ilpmap.containsKey(ilpliqty.Inventory_Location_Product__c)))
                {
                    if(ilpliqty.Type__c=='BULK' &&(!ilplimap.containsKey(ilpliqty.id)))
                    {
                        ilpliqty.Reserved_Quantity__c = ilpliqty.Reserved_Quantity__c + proids.get(ilpliqty.Product__c);
                        ilplimap.put(ilpliqty.id,ilpliqty);
                    }
                    else if(ilpliqty.Type__c=='SERIALIZED' && (ilpdelqty.get(ilpliqty.Inventory_Location_Product__c)<=proids.get(ilpliqty.Product__c))&&(ilpdelqty.get(ilpliqty.Inventory_Location_Product__c)>0))
                    {
                        ilpliqty.Reserved_Quantity__c = ilpliqty.Reserved_Quantity__c + 1;
                        Decimal proqty=ilpdelqty.get(ilpliqty.Inventory_Location_Product__c)-1;
                        System.debug('proqty111111::'+proqty);
                        ilpdelqty.put(ilpliqty.Inventory_Location_Product__c,proqty);
                    }
                    else
                    {
                        ilpliqty.Delivered_Quantity__c=ilpliqty.Delivered_Quantity__c+ proids.get(ilpliqty.Product__c);
                        ilplimap.put(ilpliqty.id,ilpliqty);
                        System.debug('ilplimap::'+ilplimap);
                    }
                }
                System.debug('ilpliqty222::'+ilpliqty);
            }
        }
        
        
        List<OrderLineLocation__c> LineLocationInsertList = new List<OrderLineLocation__c>();
        if(inventoryObj[0].Available_Qty__c >= productOrder.Net_Quantity__c)
        {
           insert productOrder;
           system.debug('productOrder>>'+productOrder);
           orderId = productOrder.Id;
           productLineObj.Sigma_Order__c = orderId;
           productLineObj.Order_Id__c = orderId;
          // productLineObj.Product__r.Product_Price__c=;
            /*try{
                if(productOrder.Customer_Type__c=='Credit Customer'){
                    Sigma_Order__c updatedData=[select id,name,Net_Amount__c from Sigma_Order__c where id=:orderId];
                    system.debug('updatedData>>>::'+updatedData);
                    Dimension_Tag__c dimTag;
                    try{
                        dimTag=[select id,Ordered_Amount__c from Dimension_Tag__c where Account__c=:productOrder.AccountId__c limit 1];
                        system.debug('dimTag>>>::'+dimTag);
                    }
                    catch(Exception e){
                        
                    }
                    if(dimTag!=null){
                        if(productOrder.Orders_Status__c!=' Canceled')
                        {
                            if(productOrder.Net_Amount__c!=null)
                            {
                                system.debug('net amount in old order'+productOrder.Net_Amount__c);
                                system.debug('net amount in new order'+updatedData.Net_Amount__c);
                                
                                if(updatedData.Net_Amount__c!=productOrder.Net_Amount__c)
                                {
                                    system.debug('Inside dim>>');
                                    if(dimTag.Ordered_Amount__c==null)
                                        dimTag.Ordered_Amount__c=0;
                                    dimTag.Ordered_Amount__c+=(updatedData.Net_Amount__c-productOrder.Net_Amount__c);
                                }
                                
                                else
                                {
                                    if(dimTag.Ordered_Amount__c==null)
                                        dimTag.Ordered_Amount__c=0;
                                    if(updatedData.Net_Amount__c!=null)
                                        dimTag.Ordered_Amount__c+=updatedData.Net_Amount__c;
                                }
                            }
                        }
                        else{
                            if(dimTag.Ordered_Amount__c!=null)
                                dimTag.Ordered_Amount__c-=updatedData.Net_Amount__c;
                        }
                        update dimTag;
                        System.debug('dimTag::'+dimTag);
                    }
                }
            }
            catch(Exception exc)
            {
                try{
                }                                                      
                catch(Exception ex)
                {                              
                }
            }*/
           
           upsert productLines;
           system.debug('productOrder::'+productOrder);
           system.debug('productLines::'+productLines);
             //code added by rashmi on 13-01-2021 to create invoice records 
            Invoice__c invoice = new Invoice__c();
            List<Invoice_Item__c>Invoiceitem = new List<Invoice_Item__c>();
            invoice.SO__c = orderId; 
            invoice.Invoice_Type__c='Sales Invoice';
            invoice.Customer__c =accId; 
            if(productOrder.Orders_Status__c=='Pending')
            {
                invoice.Invoice_Status__c='Unpaid'; 
            }
            else if(productOrder.Orders_Status__c =='Canceled')
            {
                invoice.Invoice_Status__c='Cancelled';
            }
            else
            {
                invoice.Invoice_Status__c = 'paid';
            }
            insert invoice;
            for(Product_Order_Price_Book__c orderline : productLines)
            {
                system.debug('orderline????'+orderline.id);
                Invoice_Item__c invoicedata = new Invoice_Item__c();
                invoicedata.Invoice_Number__c=invoice.id;
                invoicedata.SOI__c=orderline.id;
                invoicedata.Quantity__c = orderline.Net_Quantity__c;
                invoicedata.Total_Amount__c=orderline.Total_Price__c;
                invoicedata.Product__c=orderline.Product__c;
              //  invoicedata.Net_Amount__c = orderline.Product__r.Product_Price__c;
                if(orderline.Discounts__c!=null && orderline.Discounts__c>0)
                    invoicedata.Discount__c = orderline.Discounts__c;
                Invoiceitem.add(invoicedata);
                system.debug('Invoiceitem????'+Invoiceitem);
            }
            if(Invoiceitem.size()>0)
                insert Invoiceitem;
           //code ends here
            if(subid!=null)
            {
                Sigma_Order__c updatedTaxData=[select id,name,Tax_Amount__c,Tax__c from Sigma_Order__c where id=:orderId];
                system.debug('updatedTaxData>>>::'+updatedTaxData);
                Account_Subscription_Intervals__c accinterval=new Account_Subscription_Intervals__c();
                if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Account_Subscription_Intervals__c',new Set<String>{'Id','Name','sigmaerpdev2__Order_Status__c','sigmaerpdev2__Tax_Amount__c','sigmaerpdev2__next_Billing_Amount__c'}))
                { 
                    accinterval=[Select Id,Name,Order_Status__c,Tax_Amount__c,next_Billing_Amount__c from Account_Subscription_Intervals__c where id=:subid ];
                }
                if(CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Account_Subscription_Intervals__c',new Set<String>{'sigmaerpdev2__Order_Status__c'})
                   &&Schema.sObjectType.Account_Subscription_Intervals__c.fields.Id.isAccessible())
                { 
                    accinterval.id=subid;
                    accinterval.Order_Status__c = 'Pending';
                    accinterval.Tax_Amount__c = updatedTaxData.Tax_Amount__c;
                    accinterval.Amount__c = accinterval.next_Billing_Amount__c + accinterval.Tax_Amount__c;
                    accinterval.Tax__c = updatedTaxData.Tax__c;
                    update accinterval;
                    
                }
            }
        }
        
           
        
        
        for(Product_Order_Price_Book__c tempOrdeLine: productLines)
        {
            if(OrderLineItemLocations.containsKey(tempOrdeLine.Product__c))
            {
                List<OrderLineLocation__c> LineLocationList  = OrderLineItemLocations.get(tempOrdeLine.Product__c);
                for(OrderLineLocation__c lineiItem : LineLocationList)
                {
                    OrderLineLocation__c lineItemObj = new OrderLineLocation__c();
                    lineItemObj.Order_Line__c = tempOrdeLine.Id;
                    lineItemObj.Location__c = lineiItem.Location__c;
                    lineItemObj.Unit_Price__c = lineiItem.Unit_Price__c; 
                    lineItemObj.Start_Date__c = lineiItem.Start_Date__c;
                    lineItemObj.Product__c = lineiItem.Product__c;
                    lineItemObj.Quantity__c = lineiItem.Quantity__c;
                    lineItemObj.Status__c = 'Order Confirmed';
                    lineItemObj.Allocation_Done__c = lineiItem.Allocation_Done__c;
                    lineItemObj.Inventory_Status__c = lineiItem.Inventory_Status__c;
                    lineItemObj.Product_Price__c = lineiItem.Product_Price__c; 
                    lineItemObj.Inventory_Location_Product__c = lineiItem.Inventory_Location_Product__c;    
                    LineLocationInsertList.add(lineItemObj);
                }
            }
        }
        
        system.debug('LineLocationInsertList::'+LineLocationInsertList);
        system.debug('inventoryLines:::'+inventoryLines);
        system.debug('ILP::'+ILP);
        system.debug('ILPLI>>'+ILPLI);
        insert LineLocationInsertList;
       // update inventoryObj;
        if(ILP.size() > 0)
            update ILP;
        if(ILPLI.size() > 0)
            update ILPLI;
        
        //}
    
        return orderId;
        
    } 
    
    
    @AuraEnabled
    public static Sigma_Order__c fetchSavedOrders(String orderSFId)
    {
        Sigma_Order__c orderList = new Sigma_Order__c();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new Set<String>{'id','sigmaerpdev2__AccountId__c','sigmaerpdev2__AccountId__r.name','sigmaerpdev2__StoreName__c','sigmaerpdev2__Order_Number__c','sigmaerpdev2__Status__c','sigmaerpdev2__TotalAmount__c','sigmaerpdev2__Orders_Status__c','sigmaerpdev2__Discount_New__c','sigmaerpdev2__BillingPersonNew__r.Name'}))
        {*/
            orderList = [select id,AccountId__c,AccountId__r.name,StoreName__c,Order_Number__c,
                         Status__c,TotalAmount__c,Discount_New__c,Orders_Status__c,BillingPersonNew__r.Name FROM Sigma_Order__c WHERE Id=:orderSFId];
        //}
        return orderList; 
    }
    
    @AuraEnabled
    public static List<Product_Order_Price_Book__c> fetchOrderLines(String orderSFId)
    {
        List<Product_Order_Price_Book__c> orderLineList = new List<Product_Order_Price_Book__c>();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new Set<String>{'id','sigmaerpdev2__Customer__r.Id','sigmaerpdev2__Sigma_Order__r.Id','sigmaerpdev2__Quantity__c','sigmaerpdev2__Product_Name__c','sigmaerpdev2__Total_Amount__c','sigmaerpdev2__Total_Price__c','sigmaerpdev2__TotalProductPrice__c','sigmaerpdev2__Product__r.Id'}))
        {*/
            orderLineList = [select id,Customer__r.Id,Sigma_Order__r.Id,Quantity__c,Product_Name__c,IsInventoryUpdated__c,Total_Amount__c,
                             Total_Price__c,TotalProductPrice__c,Product__r.Id from Product_Order_Price_Book__c where Sigma_Order__r.Id = :orderSFId];
        //}
        return orderLineList ; 
    }       
    
    public static void deleteOldRecordsAndRollBackInventory(Set<Id> deletingOrderProductsId,Map<Id,Decimal> deletingOrderProductsQuantity, String inventorystatus,List<Product_Order_Price_Book__c> deleteOldRecords, String invlocation)
    {
        
       /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new Set<string>{'sigmaerpdev2__Purchased_Qty__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__Delivered_Qty__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Reserved_Qty__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev2__Delivered_Quantity__c','sigmaerpdev2__Inventory_Location__c'})
           && Schema.sObjectType.Inventory__c.fields.Id.isAccessible()
           && Schema.sObjectType.Inventory_Location_Product__c.fields.Id.isAccessible()
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'Id', 'sigmaerpdev2__Available_Qty__c', 'sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Total_Available_Qty__c', 'sigmaerpdev2__Purchased_Qty__c','sigmaerpdev2__ProductCode__r.Id'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'id', 'name', 'sigmaerpdev2__Delivered_Quantity__c','sigmaerpdev2__Inventory_Location__c', 'sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Products__r.Id'})
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c')  )
        {*/
            List<Inventory__c> InventoryLISTS; 
            Inventory_Location_Product__c ILP;  
            List<Inventory_Location_Product__c> ILPList = new List<Inventory_Location_Product__c>();         
            
            InventoryLISTS = [Select Id, Available_Qty__c,Reserved_Qty__c, Total_Available_Qty__c,ProductCode__r.Id, Purchased_Qty__c from Inventory__c where ProductCode__r.Id in :deletingOrderProductsId];
            
            if(inventorystatus !='Reserve')
            {
               
                       
                    
                    ILP = [select id, name, Delivered_Quantity__c,Inventory_Location__c, Received_Quantity__c from Inventory_Location_Product__c where Inventory_Location__c =:invlocation AND  Products__r.Id = :deletingOrderProductsId];
                    
                 
                
            }           
            List<Inventory__c> modifiedInventoryList = new List<Inventory__c>();
            Inventory__c temp1;
            for(Inventory__c b : InventoryLISTS )
            {
                Inventory_Location_Product__c  ILPrd = new Inventory_Location_Product__c ();
                Decimal tempQuantity = deletingOrderProductsQuantity.get(b.ProductCode__r.Id);
                temp1 = new Inventory__c();
                if(inventorystatus == 'Reserve')
                {
                    temp1.Reserved_Qty__c = b.Reserved_Qty__c -  tempQuantity;
                    temp1.Available_Qty__c  = b.Available_Qty__c + tempQuantity;
                    
                }
                else
                {      
                    temp1.Available_Qty__c = b.Available_Qty__c + tempQuantity ;
                    temp1.Purchased_Qty__c = b.Purchased_Qty__c - tempQuantity ;
                    try
                    {
                        temp1.Total_Available_Qty__c = b.Total_Available_Qty__c - tempQuantity;
                    }
                    catch(Exception ex)
                    {
                        System.debug('Inside a Exception catch block for total available quantity***'+ex);
                    }
                    ILPrd.Delivered_Quantity__c = ILP.Delivered_Quantity__c - tempQuantity;
                    ILPrd.Inventory_Location__c = invlocation;
                    ILPrd.Id = ILP.Id;
                    ILPList.add(ILPrd); 
                }
                temp1.Id = b.Id;
                modifiedInventoryList.add(temp1);
            }
            
            upsert modifiedInventoryList;
            update ILPList;
            
            delete deleteOldRecords;
            
       //}
        
    }
    
    @AuraEnabled
    public static Sigma_Order__c getOrderDetails(Id OrderId)
    {
        Sigma_Order__c OrderObjectDetail = new Sigma_Order__c();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new Set<String>{'Id','Name','sigmaerpdev2__Order_Number__c','sigmaerpdev2__TotalAmount__c','sigmaerpdev2__Orders_Status__c','sigmaerpdev2__Is_Payment_Made__c','sigmaerpdev2__Discount_New__c'}))
        {*/
            OrderObjectDetail = [select id,Name,Order_Number__c,Discount_New__c, TotalAmount__c,Orders_Status__c,Is_Payment_Made__c from Sigma_Order__c where Id=:OrderId limit 1];
            system.debug('OrderObjectDetail>>'+OrderObjectDetail);
        //}
        return OrderObjectDetail;
        
    }
    @AuraEnabled
    public static Account_Subscription_Intervals__c subscriptionrecord(id Ids)
    {
        Account_Subscription_Intervals__c srecord = new Account_Subscription_Intervals__c();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Account_Subscription_Intervals__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Account_Subscription_Intervals__c',new Set<String>{'id','sigmaerpdev2__Order_Status__c','sigmaerpdev2__Account_Subscription__r.sigmaerpdev2__Status__c','sigmaerpdev2__Usage_Type__c','sigmaerpdev2__Customer__c','sigmaerpdev2__Customer__r.sigmaerpdev2__Customer_Type__c','sigmaerpdev2__Product_Name__c','sigmaerpdev2__Customer__r.Name','sigmaerpdev2__next_Billing_Amount__c','sigmaerpdev2__Product_Name__r.name','sigmaerpdev2__Quantity__c'}))
        {
            srecord =  [select id,Order_Status__c,Customer__c,Account_Subscription__r.Status__c,Usage_Type__c,Customer__r.Name,Customer__r.Customer_Type__c,next_Billing_Amount__c,Product_Name__c,Product_Name__r.Name,Quantity__c from Account_Subscription_Intervals__c where id=:ids];
            system.debug('srecord>>'+srecord);
        }
        return srecord;    
    }
     @AuraEnabled
    public static Inventory__c pirecord(id Ids)
    {
        Inventory__c prodinvdata = new Inventory__c();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'id','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Delivered_Qty__c','sigmaerpdev2__Packaged_Quantity__c','sigmaerpdev2__Picked_Quantity__c','sigmaerpdev2__ProductCode__c','sigmaerpdev2__ProductCode__r.Name'}))
        {*/
            prodinvdata =  [select id,Available_Qty__c,Delivered_Qty__c,Packaged_Quantity__c,Picked_Quantity__c,ProductCode__c,ProductCode__r.Name from Inventory__c where id=:ids];
            system.debug('prodinvdata>>'+prodinvdata);
        //}
        return prodinvdata;    
    }
    
  public static Id subordersave(String Id,String Name,String quantity, String OrderIDD ,Id accId,String subid,String custType,String billingPerson,String storeName,Double allPdtsAmount)
    {        
        //New concept to introduce Inventory reserve or to be reduced based on custom settings inventory status
        //*********************** Logic starts here****************************************
        system.debug('OrderIDD>>'+OrderIDD);
        system.debug('custType>>'+custType);
        String inventorystatus;
        String invlocation;
        Inventory_Location_Product__c ILP;
        Default_Parameters__c options;
        Account acc;
        //if(CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Default_Parameters__c',new Set<String>{'Id','sigmaerpdev2__Default_Location__c','sigmaerpdev2__Inventory_Status__c','sigmaerpdev2__Package_ID__c','sigmaerpdev2__Parent_Id__c','sigmaerpdev2__Shipment_ID__c','sigmaerpdev2__StockReceiving_ID__c'}))
        //{
            options = [select Id,Inventory_Status__c,Default_Location__c,Package_ID__c,Parent_Id__c,Shipment_ID__c,StockReceiving_ID__c from Default_Parameters__c limit 1];
        //}
        inventorystatus = options.Inventory_Status__c; 
        invlocation  = options.Default_Location__c;
        //*********************** Logic Ends here****************************************
        Map<Id,List<OrderLineLocation__c>> OrderLineItemLocations = new Map<Id,List<OrderLineLocation__c>>();
        List<OrderLineLocation__c> OrderLineLocList ;
        Map<Id,Product_Order_Price_Book__c> retainOrderLineData = new Map<Id,Product_Order_Price_Book__c>();
        Id orderId = OrderIDD;
        Boolean temp = false;
        Double TaxOnBillAmount = 0; 
        Integer numOfOrderLines = 0;
        Integer numofProds = 0;
        Integer netQuantity = 0;
        
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__OrderLineLocation__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Tax__c')    
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Dimension_Tag__c')                          
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Sigma_Order__c',new Set<String>{'sigmaerpdev2__Customer_Type__c','sigmaerpdev2__Billing_Person__c','sigmaerpdev2__StoreName__c','sigmaerpdev2__EffectiveDate__c','sigmaerpdev2__Status__c','sigmaerpdev2__Orders_Status__c','sigmaerpdev2__Order_Type__c','sigmaerpdev2__Order_Created_Via__c','sigmaerpdev2__Account_Subscription_Interval__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Tax_Amount__c','sigmaerpdev2__Tax__c','sigmaerpdev2__Net_Amount__c','sigmaerpdev2__Paid_Amount__c','sigmaerpdev2__TotalAmount__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev2__Order_Id__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Net_Quantity__c','sigmaerpdev2__Total_Amount__c','sigmaerpdev2__Total_Price__c','sigmaerpdev2__Order_Status__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__End_Date__c','sigmaerpdev2__tax_amount__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__OrderLineLocation__c',new Set<String>{'sigmaerpdev2__Location__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Start_Date__c','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Status__c','sigmaerpdev2__Allocation_Done__c','sigmaerpdev2__Inventory_Status__c','sigmaerpdev2__Product_Price__c','sigmaerpdev2__Inventory_Location_Product__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new Set<string>{'sigmaerpdev2__Purchased_Qty__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__Delivered_Qty__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__ProductCode__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Dimension_Tag__c',new Set<String>{'sigmaerpdev2__Ordered_Amount__c','sigmaerpdev2__Account__c'})
        && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev2__Sigma_Order__c'})
        && CRUD_FLS_CheckUtility.checkFLScreateAccess('sigmaerpdev2__OrderLineLocation__c',new Set<String>{'sigmaerpdev2__Order_Line__c'})
        && Schema.sObjectType.Inventory__c.fields.Id.isAccessible()
        && Schema.sObjectType.Inventory_Location_Product__c.fields.Id.isAccessible()
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new Set<String>{'id','name','sigmaerpdev2__Net_Amount__c'})       
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'Id', 'sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Delivered_Qty__c', 'sigmaerpdev2__Reserved_Qty__c','sigmaerpdev2__Total_Available_Qty__c', 'sigmaerpdev2__Purchased_Qty__c','sigmaerpdev2__ProductCode__r.Id'})  
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Tax__c',new set<String>{'sigmaerpdev2__Tax_Amount__c','sigmaerpdev2__Type__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c', new Set<String>{'Id','Name','sigmaerpdev2__Delivered_Quantity__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Received_Quantity__c','Products__r.Id'})) // Added by Raghavendra on 05-June
                         
        {*/
        If(OrderIDD InstanceOf Id)
        {
            temp = true;
        }
        
        Sigma_Order__c editingOrder;
        if(temp)
        {
            //code is deleted
        }
        else
        {

            //acc=[Select id,name,Customer_Type__c from Account where id =:subid.Customer__c];
            Sigma_Order__c productOrder = new Sigma_Order__c();
            productOrder.AccountId__c = accId;
            productOrder.Billing_Person__c = billingPerson;
            productOrder.Customer_Type__c =custType;
            productOrder.StoreName__c = storeName; 
            productOrder.EffectiveDate__c = Date.today(); 
            productOrder.Status__c = 'Draft';
            productOrder.Orders_Status__c = 'Pending';
            productOrder.Order_Type__c = 'OFFLINE';
            productOrder.Order_Created_Via__c = 'Subscription';
            productOrder.Account_Subscription_Interval__c= subid; 
            productOrder.Net_Quantity__c= Double.valueOf(quantity);
            //ends here
            //get tax from TaxCntr 
            List<Tax__c> taxObj = TaxCntr.getTax(accId);
            Double federalTax = Double.valueOf(taxObj.get(0).Tax_Amount__c);
            String fedTaxType = String.valueOf(taxObj.get(0).Type__c);
            Double stateTax = Double.valueOf(taxObj.get(1).Tax_Amount__c);
            String stateTaxType = String.valueOf(taxObj.get(1).Type__c);
            
            if(fedTaxType == 'Percentage'){
                TaxOnBillAmount = (allPdtsAmount * federalTax)/100;
            }else{
                TaxOnBillAmount = allPdtsAmount + federalTax;
            }               
            if(stateTaxType == 'Percentage'){
                TaxOnBillAmount = (TaxOnBillAmount + (allPdtsAmount * stateTax)/100);
            }else{
                TaxOnBillAmount = (TaxOnBillAmount + (allPdtsAmount + stateTax));
            }        
            productOrder.Tax_Amount__c = TaxOnBillAmount;
            productOrder.Tax__c = federalTax+stateTax;
            productOrder.Net_Amount__c= allPdtsAmount;
            productOrder.TotalAmount__c = allPdtsAmount + TaxOnBillAmount;
            productOrder.Paid_Amount__c = allPdtsAmount + TaxOnBillAmount;
            //ends here
            //**********************New code Added to Write shipping Address into an order on Nov-24 Starts here **************
            //code added by rashmi to update Credit User Info on 15-10-2019
            try{
                insert productOrder;
                orderId = productOrder.Id;
            }      
            catch(exception e)
            {
                System.debug('newly inserted order Id Is::<<<<< '+e);    
            }
            try
            {
                if(productOrder.Customer_Type__c=='Credit Customer'){
                    Sigma_Order__c updatedData=[select id,name,Net_Amount__c from Sigma_Order__c where id=:orderId];
                    system.debug('updatedData>>>::'+updatedData);
                    Dimension_Tag__c dimTag;
                    //  Payment__c payData;
      
     
                    try{
                        dimTag=[select id,Ordered_Amount__c from Dimension_Tag__c where Account__c=:productOrder.AccountId__c limit 1];
                        system.debug('dimTag>>>::'+dimTag);
                        //  payData=[select id,name,Customer_SFID__c,Payment_Mode__c,Paid_Amount__c,Sigma_Order__c,Status__c from Payment__c where Customer_SFID__c=:productOrder.AccountId__c limit 1];
                        //  system.debug('payData>>>::'+payData);
                    }
                    catch(Exception e){
                        System.debug('newly inserted order Id Is::<<<<< '+e); 
                    }
                    //Account acc=[select id,name,Ordered_Amount__c,Customer_Type__c from Account where id=:soDataToSave.Account__c];
                    if(dimTag!=null){
                        if(productOrder.Orders_Status__c!=' Canceled')
                        {
                            if(productOrder.Net_Amount__c!=null)
                            {
                                system.debug('net amount in old order'+productOrder.Net_Amount__c);
                                system.debug('net amount in new order'+updatedData.Net_Amount__c);
                                
                                if(updatedData.Net_Amount__c!=productOrder.Net_Amount__c)
                                {
                                    system.debug('Inside dim>>');
                                    if(dimTag.Ordered_Amount__c==null)
                                        dimTag.Ordered_Amount__c=0;
                                    dimTag.Ordered_Amount__c+=(updatedData.Net_Amount__c-productOrder.Net_Amount__c);
                                }
                                
                                else
                                {
                                    if(dimTag.Ordered_Amount__c==null)
                                        dimTag.Ordered_Amount__c=0;
                                    if(updatedData.Net_Amount__c!=null)
                                        dimTag.Ordered_Amount__c+=updatedData.Net_Amount__c;
                                }
                            }
                        }
                        else{
                            if(dimTag.Ordered_Amount__c!=null)
                                dimTag.Ordered_Amount__c-=updatedData.Net_Amount__c;
                        }
                        update dimTag;
                        System.debug('dimTag::'+dimTag);
                    }
                    
                    
                }
                
                
                
            }
            catch(exception e)
            {
                System.debug('newly inserted order Id Is::<<<<< '+e);    
            }
            
        //} 

        List<Product_Order_Price_Book__c> productLines = new List<Product_Order_Price_Book__c>();
        Product_Order_Price_Book__c productLineObj= new Product_Order_Price_Book__c();
        List<Inventory__c> inventoryLines = new List<Inventory__c>();
        Inventory__c inventoryObj;
        List<Inventory_Location_Product__c> ILPList = new List<Inventory_Location_Product__c>();
        Inventory_Location_Product__c ILPrd = new Inventory_Location_Product__c();
        productLineObj.Sigma_Order__c = orderId;
        productLineObj.Order_Id__c = orderId;
        productLineObj.Product__c = String.valueOf(Id);
        productLineObj.Quantity__c = Integer.valueOf(quantity);
        productLineObj.Net_Quantity__c= Integer.valueOf(quantity);
        productLineObj.Total_Amount__c = Double.valueOf(allPdtsAmount);
        productLineObj.Total_Price__c = Double.valueOf(allPdtsAmount);
        //Chaged on 16 November to isolate order status and OrderLines status
        productLineObj.Order_Status__c = 'Pending';
        //code added by rashmi to update IsInventoryUpdated__c checkbox feild in orderlines on 1-08-2019
        // productLineObj.IsInventoryUpdated__c = true;
        if(retainOrderLineData.containsKey(productLineObj.Product__c))
        {
            productLineObj.Start_Date__c = retainOrderLineData.get(productLineObj.Product__c).Start_Date__c;
            productLineObj.End_Date__c = retainOrderLineData.get(productLineObj.Product__c).End_Date__c;
        }
        //added for tax calculation orderLines
        Double taxForPriceBookItems;
        Double totalAmountOL = Double.valueOf(allPdtsAmount);
          if(totalAmountOL!=0)
          {
               taxForPriceBookItems = (Double.valueOf(totalAmountOL) / Double.valueOf(allPdtsAmount)) * Double.valueOf(TaxOnBillAmount);
                productLineObj.tax_amount__c = taxForPriceBookItems;
          }
               
            
       
        
        //ends here.
        
       
        inventoryObj = [Select Id,Available_Qty__c,Delivered_Qty__c ,Reserved_Qty__c,Purchased_Qty__c, Total_Available_Qty__c from Inventory__c where ProductCode__r.Id=:productLineObj.Product__c];
        
        if(inventorystatus !='Reserve')
        {
            
                ILP = [select id, name, Delivered_Quantity__c,Inventory_Location__c, Received_Quantity__c from Inventory_Location_Product__c where Products__r.Id = :productLineObj.Product__c Limit 1];
                
              
        }
        //code needed but commented to stop reducing pi on 11-07-2019
        /*  if(inventorystatus =='Reserve')
{   
productLineObj.Inventory_Status__c = 'Reserve';
inventoryObj.Reserved_Qty__c = inventoryObj.Reserved_Qty__c + productLineObj.Quantity__c;
inventoryObj.Available_Qty__c  = inventoryObj.Available_Qty__c - productLineObj.Quantity__c;

}
else{
productLineObj.Inventory_Status__c = 'Allocated';    
inventoryObj.Available_Qty__c  = inventoryObj.Available_Qty__c - productLineObj.Quantity__c;
inventoryObj.Delivered_Qty__c  = inventoryObj.Delivered_Qty__c + productLineObj.Quantity__c;
ILPrd.Delivered_Quantity__c = ILP.Delivered_Quantity__c +  productLineObj.Quantity__c;
ILPrd.Inventory_Location__c = invlocation;
ILPrd.Id = ILP.Id;
ILPList.add(ILPrd);
}*/
        
        inventoryLines.add(inventoryObj);
        productLines.add(productLineObj);
        List<OrderLineLocation__c> LineLocationInsertList = new List<OrderLineLocation__c>();
        upsert productLines;
        
        
        //------Code to Insert OrderLineItemLocationsif Exists ------------------
        for(Product_Order_Price_Book__c tempOrdeLine: productLines)
        {
            if(OrderLineItemLocations.containsKey(tempOrdeLine.Product__c))
            {
                List<OrderLineLocation__c> LineLocationList  = OrderLineItemLocations.get(tempOrdeLine.Product__c);
                
                for(OrderLineLocation__c lineiItem : LineLocationList)
                {

                    OrderLineLocation__c lineItemObj = new OrderLineLocation__c();
                    lineItemObj.Order_Line__c = tempOrdeLine.Id;
                    lineItemObj.Location__c = lineiItem.Location__c;
                    lineItemObj.Unit_Price__c = lineiItem.Unit_Price__c; 
                    lineItemObj.Start_Date__c = lineiItem.Start_Date__c;
                    lineItemObj.Product__c = lineiItem.Product__c;
                    lineItemObj.Quantity__c = lineiItem.Quantity__c;
                    lineItemObj.Status__c = 'Order Confirmed';
                    lineItemObj.Allocation_Done__c = lineiItem.Allocation_Done__c;
                    lineItemObj.Inventory_Status__c = lineiItem.Inventory_Status__c;
                    lineItemObj.Product_Price__c = lineiItem.Product_Price__c; 
                    lineItemObj.Inventory_Location_Product__c = lineiItem.Inventory_Location_Product__c;    
                    LineLocationInsertList.add(lineItemObj);
                }
            }
        }
        //code added by rashmi to update Payment details in Account related on 07-11-2019
        //payData=[select id,name,Customer_SFID__c,Payment_Mode__c,Paid_Amount__c,Sigma_Order__c,Status__c from Payment__c where Customer_SFID__c=:productOrder.AccountId__c limit 1];
        /*  Payment__c payData=new Payment__c();
payData.Customer_SFID__c=accId;
//payData.Payment_Mode__c=true;
//payData.Paid_Amount__c=;
payData.Sigma_Order__c=orderId;
//  payData.Status__c=;*/
        
        //----------Till Here ----------------------------------------------------
        insert LineLocationInsertList;
        update inventoryLines;
        update ILPList;
        //  update payData;
        // }
        }
        return orderId;
     //-------------------End Ord orderSave()--------------------------------------------------------
    }
    
    //------method for newpackage module to on load the order------
    @AuraEnabled
    public static List<Sigma_Order__c> getInfoForSoOnHover(String stappOrderId){
        List<Sigma_Order__c> retStr = new List<Sigma_Order__c>();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Order_Price_Book__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sigma_Order__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev2__Product__r.Name'})
           &&CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sigma_Order__c',new Set<String>{'Id','sigmaerpdev2__Date__c'}))
        {
            retStr = [select id,Date__c,(select Product__r.Name from Order_Lines__r) from Sigma_Order__c where id = :stappOrderId];        
            
        }
        return retStr;
    }
    @AuraEnabled
    public static List<Order> getStandInfoForSoOnHover(String stappOrderId){
        List<Order> retStr = new List<Order>();
        List<OrderItem> resstr1= new List<OrderItem>();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')
           && CRUD_FLS_CheckUtility.checkObjCRUD('Order')
           && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new Set<String>{'Id','Pricebookentry.Product2Id'})
           && CRUD_FLS_CheckUtility.checkReadPermission('Order',new Set<String>{'Id'}))
        {
            retStr = [SELECT Id, (SELECT Id,Pricebookentry.Product2Id from OrderItems) FROM Order where id = :stappOrderId];
        }
        return retStr;
    }
    
    @AuraEnabled
    public static List<Package__c> getPackageInfoForSoOnHover(String packageId){
        List<Package__c> retStr = new List<Package__c>();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Package__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__PackagedProducts__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Package__c',new Set<String>{'id','Name','sigmaerpdev2__Customer__r.Name'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__PackagedProducts__c',new Set<String>{'sigmaerpdev2__Sigma_Order__r.name','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Package__r.Name','sigmaerpdev2__Package__r.sigmaerpdev2__Customer__r.Name'}))
        {
            retStr = [select id,Name,Customer__r.Name,(select Sigma_Order__r.name,Product__r.Name,Package__r.Name,Package__r.Customer__r.Name from PackagedProducts__r) from Package__c where id = :packageId];        
        }
        return retStr;
        
    }
    
    @AuraEnabled
    public static List<Package__c> getPackageInfoOnHover(String packageId){
        List<Package__c> retStr = new List<Package__c>();
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Package__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__PackagedProducts__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Package__c',new Set<String>{'id','Name','sigmaerpdev2__Customer__r.Name'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__PackagedProducts__c',new Set<String>{'sigmaerpdev2__Sigma_Order__r.name','sigmaerpdev2__Product__r.Name','sigmaerpdev2__Package__r.Name','sigmaerpdev2__Package__r.sigmaerpdev2__Customer__r.Name'}))
        {
            retStr = [select id,Name,Customer__r.Name,(select Sigma_Order__r.name,Product__r.Name,Package__r.Name,Package__r.Customer__r.Name from PackagedProducts__r) from Package__c where id = :packageId];        
        }
        return retStr;
    }
    // added by sandhya - for checking Order Usage Custom settings
    @AuraEnabled
    public static Order_Usage__c CheckOrder()
    {
        Order_Usage__c OrderTypeusage= new Order_Usage__c();
        try{
            if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Order_Usage__c')
               && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Order_Usage__c',new Set<String>{'Id.name','Name','sigmaerpdev2__Sigma_order__c','sigmaerpdev2__Standard_object__c'}))
            { 
                OrderTypeusage= [select Id, Name,Sigma_order__c,Standard_object__c from Order_Usage__c limit 1];
            }               
        }
        catch(Exception e)
        {
            return null;
        }
        
        return OrderTypeusage;
        
    }
    
    
}