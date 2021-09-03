/**
* @Author      :   Raghavendr Hugar
* @Date        :   Sept-21-2020
* @Desc        :   This class is used to save the Registration details
* @TestClass   :   RegistrationServiceTest
* */

public without sharing class RegistrationService
{
    public class MainWrapper
    {

        @AuraEnabled public String FirstName;
        @AuraEnabled public String LastName;
        @AuraEnabled public String EmailId;
        @AuraEnabled public String ContactNumber;
        @AuraEnabled public String ContactPerson;
        @AuraEnabled public String Address;
        @AuraEnabled public String PostCode; 
        @AuraEnabled public String City; 
        @AuraEnabled public String BreweryName; 
        /*@AuraEnabled public String CardNumber; 
        @AuraEnabled public Date ExpiryDate; 
        @AuraEnabled public String CVV; */
        @AuraEnabled public Boolean ShowAddressOnSite; 
        @AuraEnabled public String ResistrationStatus; 
        @AuraEnabled public String ResponseMessage; 
        @AuraEnabled public Boolean CreateOrder; 
        @AuraEnabled public String AccountId; 
        @AuraEnabled public String OrderId; 
        @AuraEnabled public String orderAmount; 
        @AuraEnabled public String RegistryId;  
        @AuraEnabled public String TermsConditions; 
        
    }
    
    
    @AuraEnabled
    public static MainWrapper SaveBreweryInfo(String MainWrapperParam)      
    {
        System.debug('Inside SaveBreweryInfo>>'+MainWrapperParam);
        MainWrapper MainWrapperDetails = new MainWrapper();
        try
        {
            //List<RetailerDetailsWrapper> RetailerWrapList = (List<RetailerDetailsWrapper>)System.JSON.deserialize(RetailerList, List<RetailerDetailsWrapper>.class);
            MainWrapperDetails = (MainWrapper)System.JSON.deserialize(MainWrapperParam, MainWrapper.class);
            System.debug('MainWrapperDetails>>'+MainWrapperDetails);
            
            sigmaerpdev2__Brewery_Registry__c breweryrRegistry = new sigmaerpdev2__Brewery_Registry__c();
            breweryrRegistry.First_Name__c =  MainWrapperDetails.FirstName;
            breweryrRegistry.Last_Name__c = MainWrapperDetails.LastName;
            breweryrRegistry.Email__c = MainWrapperDetails.EmailId;
            //---Code to check existing customer using the same emailId starts here
            
            List<sigmaerpdev2__Brewery_Registry__c>   CheckExistingcustomerRegistry  = [select Id,Name,Email__c from sigmaerpdev2__Brewery_Registry__c where Email__c=:breweryrRegistry.Email__c];
            if(CheckExistingcustomerRegistry.size() > 0 && MainWrapperDetails.RegistryId =='')
            {
                //returnString = 'This Email id has been used, you should use different email id to register!';
                 MainWrapperDetails.ResponseMessage = 'This Email id has been used, you should use different email id to register!';
                 MainWrapperDetails.ResistrationStatus = 'Fail';
                 return MainWrapperDetails;
            }else
            {
                
                if(MainWrapperDetails.RegistryId !='')
                {
                    breweryrRegistry.Id = MainWrapperDetails.RegistryId; 
                }
              
    
                
                //----Code to fetch the custom settings values starts from here------
                Map<string,sigmaerpdev2__Community_Configuration__c> ConfigSettings = sigmaerpdev2__Community_Configuration__c.getAll();
                sigmaerpdev2__Community_Configuration__c config = null;
                if(ConfigSettings.containsKey('Community Configurations'))
                {
                    config = ConfigSettings.get('Community Configurations');
                    System.debug('config.:'+config); 
                    System.debug('config.sigmaerpdev2__Brewer_Registration_Product__c:'+config.sigmaerpdev2__Brewer_Registration_Product__c); 
                    System.debug('config.sigmaerpdev2__Collect_Platform_Registration_Fees__c:'+config.sigmaerpdev2__Collect_Platform_Registration_Fees__c); 
                    System.debug('config.sigmaerpdev2__Record_Owner__c:'+config.sigmaerpdev2__Record_Owner__c); 
                    
                    

                }  
                //----Code to fetch the custom settings values ends  here------

            
                
                //---create customerRegistry Instance and Store the necessary information
                breweryrRegistry.sigmaerpdev2__Brewery_Name__c = MainWrapperDetails.BreweryName;
                breweryrRegistry.sigmaerpdev2__Contact_Number__c =  MainWrapperDetails.ContactNumber;
                breweryrRegistry.sigmaerpdev2__Contact_Person__c = MainWrapperDetails.ContactPerson;
                breweryrRegistry.sigmaerpdev2__Address__c = MainWrapperDetails.Address;
                breweryrRegistry.sigmaerpdev2__City__c = MainWrapperDetails.City;
                breweryrRegistry.sigmaerpdev2__Postcode__c = MainWrapperDetails.PostCode;
                breweryrRegistry.sigmaerpdev2__Date_of_Registration__c =  System.today();
                /*breweryrRegistry.sigmaerpdev2__Card_Number__c = Decimal.valueOf(MainWrapperDetails.CardNumber);
                breweryrRegistry.sigmaerpdev2__Card_Expiry_Date__c = MainWrapperDetails.ExpiryDate;
                breweryrRegistry.sigmaerpdev2__CVV__c =  Decimal.valueOf(MainWrapperDetails.CVV);*/

                
                breweryrRegistry.OwnerId = config.sigmaerpdev2__Record_Owner__c;
                
                System.debug('breweryrRegistry object before insert>>>'+breweryrRegistry);
                upsert breweryrRegistry;
                MainWrapperDetails.RegistryId = breweryrRegistry.Id;  
                System.debug('breweryrRegistry object after insert>>>'+breweryrRegistry);
                
                
                  

                Account brewer = new Account();
                brewer.Name = breweryrRegistry.sigmaerpdev2__Brewery_Name__c;
                brewer.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
                brewer.Phone = breweryrRegistry.Contact_Number__c;
                brewer.sigmaerpdev2__Address__c = breweryrRegistry.sigmaerpdev2__Address__c;
                brewer.sigmaerpdev2__Email__c = breweryrRegistry.Email__c;
                brewer.sigmaerpdev2__City__c = breweryrRegistry.sigmaerpdev2__City__c;
                brewer.sigmaerpdev2__Zip__c = breweryrRegistry.sigmaerpdev2__Postcode__c;
                brewer.OwnerId = config.sigmaerpdev2__Record_Owner__c; 
                insert brewer;
                System.debug('After insert brewer>>'+brewer);

                MainWrapperDetails.AccountId = brewer.Id;   
                

                breweryrRegistry.sigmaerpdev2__Brewer_Account__c = brewer.Id;

                
                //---Code to create Customer Contact starts here-----   
                Contact customerContact = new Contact();
                customerContact.FirstName = breweryrRegistry.First_Name__c;
                customerContact.LastName = breweryrRegistry.Last_Name__c;
                customerContact.AccountId = brewer.Id;
                customerContact.Email = breweryrRegistry.Email__c;
                customerContact.Phone = breweryrRegistry.Contact_Number__c;
                customerContact.OwnerId = config.sigmaerpdev2__Record_Owner__c; 
                insert customerContact;
                System.debug('After insert customerContact>>'+customerContact);
                //---Till here---------------------------
                
                
            sigmaerpdev2__Sigma_Order__c order;  
            if(config.sigmaerpdev2__Collect_Platform_Registration_Fees__c)
            {
                        
                Product2 prod =[select id,name,(select id,UnitPrice,Pricebook2Id,Product2Id,ProductCode from 
                PricebookEntries where product2id =: config.sigmaerpdev2__Brewer_Registration_Product__c) 
                from Product2 where id=:config.sigmaerpdev2__Brewer_Registration_Product__c];
                System.debug('prod>>>'+prod);
                System.debug('prod.PricebookEntries[0].UnitPrice>>>'+prod.PricebookEntries[0].UnitPrice);
                
                Decimal NetQuantity = 1;
                Decimal discount = config.sigmaerpdev2__Discount__c;
                Decimal totalprice = NetQuantity * prod.PricebookEntries[0].UnitPrice;
                Decimal FinalAmount = totalprice -(totalprice*discount)/100;
                
              
                //---Code to create sigma order
                order = new sigmaerpdev2__Sigma_Order__c();
                order.AccountId__c = brewer.Id;
                order.Net_Amount__c = prod.PricebookEntries[0].UnitPrice;
                order.Order_Created_Via__c='Opportunity';
                //order.Customer_Type__c = brewer.Customer_Type__c;
                order.Orders_Status__c = 'Pending';
                order.Delivary_Date__c = System.today();
                order.TotalAmount__c = FinalAmount;
                order.OwnerId = config.sigmaerpdev2__Record_Owner__c; 
                System.debug('Before insert order>>'+order);
                insert order;
                System.debug('After insert order>>'+order);
                
                MainWrapperDetails.OrderId = order.Id;
                MainWrapperDetails.orderAmount = String.valueOf(FinalAmount);
                MainWrapperDetails.CreateOrder = true;
                
                
                //For Orderline  --   
                Product_Order_Price_Book__c orderline = new Product_Order_Price_Book__c();
                orderline.Product__c = config.sigmaerpdev2__Brewer_Registration_Product__c;
                
                orderline.Quantity__c= NetQuantity;
                orderline.Net_Quantity__c= NetQuantity;
                orderline.Sigma_Order__c= order.Id;
                orderline.Order_Status__c = 'Pending';
                orderline.Discounts__c = config.sigmaerpdev2__Discount__c;
                
            
 
                
                orderline.Total_Amount__c =  FinalAmount;
                orderline.Total_Price__c = prod.PricebookEntries[0].UnitPrice;
                System.debug('Before insert order>>'+orderline);
                insert orderline;
                System.debug('After insert order>>'+orderline);
                //---Till here
              
                
            }
               //https://ssigma-mvp-dev2-dev-ed-developer-edition.ap17.force.com/SigmaBrewery/s/brewerpaymentpage?orderId=a1l2x0000004rOWAAY&registryId=a2W2x000000HC2AEAW
                //breweryrRegistry.sigmaerpdev2__Payment_Link__c =config.sigmaerpdev2__Retailer_Community_URL__c+'/s/brewerpaymentpage?orderId='+MainWrapperDetails.OrderId+'&registryId='+breweryrRegistry.Id;
                breweryrRegistry.sigmaerpdev2__Platform_Fees__c = order.TotalAmount__c; 
                update breweryrRegistry;
                System.debug('After update breweryrRegistry>>'+breweryrRegistry);
                MainWrapperDetails.ResistrationStatus = 'success';
                MainWrapperDetails.ResponseMessage = 'Brewery Registration completed successfully.';
                    
            }

        }
        catch(Exception e)
        {  
            MainWrapperDetails.ResistrationStatus = 'Fail';
            MainWrapperDetails.ResponseMessage = e.getMessage() + e.getLineNumber();
            System.debug('Inside exception>>>'+e.getMessage());
            System.debug('Inside exception LineNumber >>>'+e.getLineNumber());
            System.debug('Inside exception getTypeName>>>'+e.getTypeName());
            System.debug('Inside exception getStackTraceString>>>'+e.getStackTraceString());
            
        }
        
        
        //-------Code to Send an email to the selected on OrderToCompany Ends here-----
        System.debug('before return final MainWrapperDetails>>>'+MainWrapperDetails);   
        return MainWrapperDetails;
    }
    
    
    //Used to construct the MainWrapper for payment
    @AuraEnabled
    public static MainWrapper getMainWrapper(String orderId,String registryId)      
    {
        System.debug('Inside getMainWrapper orderId>>>'+orderId +' registryId: '+registryId); 
        MainWrapper MainWrapperDetails = new MainWrapper();
        try
        {
 
        
        sigmaerpdev2__Brewery_Registry__c brwerRegistry  = [select Id,Name,Email__c,sigmaerpdev2__Brewer_Account__c,
                                                            sigmaerpdev2__Payment_Status__c,sigmaerpdev2__Card_Number__c,sigmaerpdev2__Contact_Person__c
                                                            ,sigmaerpdev2__CVV__c,sigmaerpdev2__Card_Expiry_Date__c,
                                                            sigmaerpdev2__Address__c,sigmaerpdev2__Contact_Number__c,sigmaerpdev2__Postcode__c,
                                                            sigmaerpdev2__Discount__c,sigmaerpdev2__Platform_Fees__c,sigmaerpdev2__City__c,sigmaerpdev2__TermsConditions__c from sigmaerpdev2__Brewery_Registry__c where Id=:registryId];
        System.debug('brwerRegistry>>>'+brwerRegistry); 
        
        /*MainWrapperDetails.CardNumber = String.valueOf(brwerRegistry.sigmaerpdev2__Card_Number__c);
         MainWrapperDetails.ExpiryDate = brwerRegistry.sigmaerpdev2__Card_Expiry_Date__c; 
        MainWrapperDetails.CVV = String.valueOf(brwerRegistry.sigmaerpdev2__CVV__c); */
        MainWrapperDetails.ContactPerson = brwerRegistry.sigmaerpdev2__Contact_Person__c; 
        
        MainWrapperDetails.Address = brwerRegistry.sigmaerpdev2__Address__c; 
        MainWrapperDetails.PostCode = brwerRegistry.sigmaerpdev2__Postcode__c; 
        MainWrapperDetails.City = brwerRegistry.sigmaerpdev2__City__c;    
        MainWrapperDetails.TermsConditions = brwerRegistry.sigmaerpdev2__TermsConditions__c;
        MainWrapperDetails.ResistrationStatus = 'success';
        MainWrapperDetails.RegistryId = registryId;  
        
        sigmaerpdev2__Sigma_Order__c order = [Select Id,Name,AccountId__c,Net_Amount__c,Order_Created_Via__c,Orders_Status__c,
                                              Delivary_Date__c,TotalAmount__c from  sigmaerpdev2__Sigma_Order__c where Id=:orderId];
        System.debug('order>>>'+order);  
        
        
        List<sigmaerpdev2__Sigma_Order__c> orderClone = [Select Id,Name,AccountId__c,Net_Amount__c,Order_Created_Via__c,Orders_Status__c,
                                              Delivary_Date__c,TotalAmount__c,(select id,name,Discounts__c,Total_Amount__c,Total_Price__c,Order_Status__c from Order_Lines__r) from  sigmaerpdev2__Sigma_Order__c where Id=:orderId];
        
        System.debug('order>>>'+orderClone); 
        Sigma_Order__c SO;
        sigmaerpdev2__Product_Order_Price_Book__c OL;
        for(Sigma_Order__c orderVar:orderClone)
        {
            System.debug('orderVar>>>'+orderVar); 
            SO = new Sigma_Order__c();
            SO.Id = orderVar.Id;
            Decimal NetQuantity = 1;
            Decimal discount = brwerRegistry.sigmaerpdev2__Discount__c;
            //Decimal totalprice = NetQuantity * prod.PricebookEntries[0].UnitPrice;
            Decimal totalprice = NetQuantity * brwerRegistry.sigmaerpdev2__Platform_Fees__c;
            
            Decimal FinalAmount = totalprice -(totalprice*discount)/100;
            SO.TotalAmount__c = FinalAmount;
            SO.Net_Amount__c = brwerRegistry.sigmaerpdev2__Platform_Fees__c;
            for(sigmaerpdev2__Product_Order_Price_Book__c var: orderVar.Order_Lines__r)
            {
                System.debug('orderLinevar >>>'+var); 
                OL = new sigmaerpdev2__Product_Order_Price_Book__c();
                OL.Id = var.Id;
                OL.Discounts__c = brwerRegistry.sigmaerpdev2__Discount__c;
                OL.Total_Amount__c =  FinalAmount;
                OL.Total_Price__c = brwerRegistry.sigmaerpdev2__Platform_Fees__c;
            }
            
        }
        
       
        update SO;
        update OL;
        System.debug('After update Final Order>>>'+SO); 
        System.debug('After update Final orderLine>>>'+OL); 
        
        MainWrapperDetails.OrderId = order.Id;
        MainWrapperDetails.AccountId = order.AccountId__c;
        MainWrapperDetails.orderAmount = String.valueOf(SO.TotalAmount__c);
        
        
        }
        catch(Exception e)
        {  
            MainWrapperDetails.ResistrationStatus = 'Fail';
            MainWrapperDetails.ResponseMessage = e.getMessage() + e.getLineNumber();
            System.debug('Inside exception>>>'+e.getMessage());
            System.debug('Inside exception LineNumber >>>'+e.getLineNumber());
            System.debug('Inside exception getTypeName>>>'+e.getTypeName());
            System.debug('Inside exception getStackTraceString>>>'+e.getStackTraceString());
            
        }
        

        System.debug('Inside getMainWrapper before return final MainWrapperDetails>>>'+MainWrapperDetails);   
        
        return MainWrapperDetails;
        
    }
    
    
    
    //Used to Activate the Customer Registry record
    public class ActivationWrapper
    {
        
        @AuraEnabled public sigmaerpdev2__Brewery_Registry__c brewerRegistry;
        @AuraEnabled public String responseMessage;
        
    }
    
    
    @AuraEnabled
    public static ActivationWrapper GetCustomerRegistryDetails(Id currentRecordId)    
    {
        System.debug('Inside  GetCustomerRegistryDetails currentRecordId>>>'+currentRecordId);
        ActivationWrapper responseActivationWrapper = new ActivationWrapper();
        

        //----Code to fetch the custom settings values starts from here------
        Map<string,sigmaerpdev2__Community_Configuration__c> ConfigSettings = sigmaerpdev2__Community_Configuration__c.getAll();
        sigmaerpdev2__Community_Configuration__c config = null;
            if(ConfigSettings.containsKey('Community Configurations'))
            {
            config = ConfigSettings.get('Community Configurations');
            System.debug('config.:'+config); 
            System.debug('config.sigmaerpdev2__Brewer_Registration_Product__c:'+config.sigmaerpdev2__Brewer_Registration_Product__c); 
            System.debug('config.sigmaerpdev2__Collect_Platform_Registration_Fees__c:'+config.sigmaerpdev2__Collect_Platform_Registration_Fees__c); 
            System.debug('config.sigmaerpdev2__Record_Owner__c:'+config.sigmaerpdev2__Record_Owner__c); 



            }  
        //----Code to fetch the custom settings values ends  here------

        
      
        sigmaerpdev2__Brewery_Registry__c breweryrRegistry  = [ Select Id,Name,sigmaerpdev2__Address__c,sigmaerpdev2__Brewer_Account__c,sigmaerpdev2__Brewery_Name__c,
                                                                sigmaerpdev2__City__c,sigmaerpdev2__Contact_Number__c,sigmaerpdev2__Contact_Person__c,sigmaerpdev2__Date_of_Registration__c,
                                                                sigmaerpdev2__Email__c,sigmaerpdev2__First_Name__c,sigmaerpdev2__Last_Name__c,sigmaerpdev2__Payment_Status__c,sigmaerpdev2__Postcode__c,
                                                                sigmaerpdev2__Registration_Status__c,sigmaerpdev2__Show_Address_On_Site__c from sigmaerpdev2__Brewery_Registry__c where Id=:currentRecordId];
        
        responseActivationWrapper.brewerRegistry = breweryrRegistry;

      
        System.debug('breweryrRegistry.sigmaerpdev2__Registration_Status__c>>>'+breweryrRegistry.sigmaerpdev2__Registration_Status__c);
        if(breweryrRegistry.sigmaerpdev2__Registration_Status__c !='Registered')
        {
            responseActivationWrapper.responseMessage = 'You can activate the users with Registered status only.';
            return responseActivationWrapper; 
        }else
        {

            Account brewer = [Select Id,Name,sigmaerpdev2__Active__c from Account where Id=:breweryrRegistry.sigmaerpdev2__Brewer_Account__c ];
            Contact brewerContact = [Select Id,FirstName,LastName,AccountId,Email,Phone from Contact where AccountId=:breweryrRegistry.sigmaerpdev2__Brewer_Account__c];
            System.debug('Existing brewer Account >>'+brewer);     
            System.debug('Existing brewerContact >>'+brewerContact);       

            responseActivationWrapper = new ActivationWrapper();
            responseActivationWrapper = ActivateRegistry(breweryrRegistry,brewer,brewerContact,config); 
            System.debug('After calling ActivateRegistry responseActivationWrapper is>>>>'+responseActivationWrapper);

            
        }
        
        return responseActivationWrapper; 
        
    }
    
    @AuraEnabled
    public static ActivationWrapper ActivateRegistry (sigmaerpdev2__Brewery_Registry__c recordtoActivate,Account customerAccount,Contact customerContact,sigmaerpdev2__Community_Configuration__c config)          
    {
        String responseMessage = null;
        ActivationWrapper responseActivationWrapper = new ActivationWrapper();
        User usr = new User();
        //usr.Title = customerContact.Title;
        usr.firstName = customerContact.FirstName;
        usr.lastName =  customerContact.LastName;
        //usr.Street =  customerContact.MailingStreet;
        //usr.City =  customerContact.MailingCity;
        //usr.PostalCode=customerContact.MailingPostalCode;
        //usr.Country= customerContact.MailingCountry;
        usr.Phone = customerContact.Phone;
        //usr.MobilePhone = customerContact.MobilePhone;
        usr.ContactId = customerContact.Id;
        usr.Username = customerContact.Email;
        usr.Email = customerContact.Email;
        String nickName = customerContact.Email;
        
        if (nickName.length() > 40) {
            nickName = nickName.substring(0, 40);
        }
        usr.CommunityNickname =nickName;
        usr.Alias = 'T';  
        usr.TimeZoneSidKey = 'America/Phoenix'; // Required
        //usr.TimeZoneSidKey = 'Asia/Hong_Kong'; // Required
        usr.LocaleSidKey = 'en_US'; // Required
        //usr.EmailEncodingKey = 'ISO-8859-1'; // Required
        usr.EmailEncodingKey = 'UTF-8'; // Required
        usr.LanguageLocaleKey = 'en_US'; // Required
        usr.ProfileId = config.sigmaerpdev2__Retailer_Profile_Id__c;
        
        usr.IsActive = true;
        
        try
        {
            System.debug('Before usr insertion>>>>>'+usr);
            
            Insert usr;
            System.debug('After usr insertion>>>>>'+usr);     
            
            if(usr.Id!=null)
            {
                customerAccount.sigmaerpdev2__Active__c = 'Yes';
                update customerAccount;
                System.debug('After customerAccount update >>>>>'+customerAccount);
                
                /*customerContact.Status__c = 'Active';
                update customerContact;
                System.debug('After customerContact update >>>>>'+customerContact);*/
                
                recordtoActivate.sigmaerpdev2__Registration_Status__c = 'Active';
                update recordtoActivate;
                
                responseMessage = 'Brewery registry has been activated successfully.';
            }
            
        }
        catch(exception ex)
        {
            System.debug('Exception Occured during creation of new User:'+ex.getMessage());
            responseMessage = ex.getMessage();
        }
        
        System.debug('Final responseMessage is>>>>>:'+responseMessage);
        responseActivationWrapper.brewerRegistry = recordtoActivate;
        responseActivationWrapper.responseMessage = responseMessage;
        return responseActivationWrapper;
        
    }
    
    @AuraEnabled
    public static ActivationWrapper InActivateRegistry(Id currentRecordId)          
    {
        String responseMessage = null;
        System.debug('Inside  GetCustomerRegistryDetails currentRecordId>>>'+currentRecordId);
        ActivationWrapper responseActivationWrapper = new ActivationWrapper();
        sigmaerpdev2__Brewery_Registry__c breweryrRegistry = new sigmaerpdev2__Brewery_Registry__c(); 
        try
        {

               breweryrRegistry  = [ Select Id,Name,sigmaerpdev2__Address__c,sigmaerpdev2__Brewer_Account__c,sigmaerpdev2__Brewery_Name__c,
                sigmaerpdev2__City__c,sigmaerpdev2__Contact_Number__c,sigmaerpdev2__Contact_Person__c,sigmaerpdev2__Date_of_Registration__c,
                sigmaerpdev2__Email__c,sigmaerpdev2__First_Name__c,sigmaerpdev2__Last_Name__c,sigmaerpdev2__Payment_Status__c,sigmaerpdev2__Postcode__c,
                sigmaerpdev2__Registration_Status__c,sigmaerpdev2__Show_Address_On_Site__c from sigmaerpdev2__Brewery_Registry__c where Id=:currentRecordId];

            responseActivationWrapper.brewerRegistry = breweryrRegistry;

            System.debug('breweryrRegistry.sigmaerpdev2__Registration_Status__c>>>'+breweryrRegistry.sigmaerpdev2__Registration_Status__c);
            if(breweryrRegistry.sigmaerpdev2__Registration_Status__c !='Active')
            {
            responseActivationWrapper.responseMessage = 'You can Inactivate the users with Active status only.';
            return responseActivationWrapper; 
            }else
            {
                breweryrRegistry.sigmaerpdev2__Registration_Status__c = 'Inactive';
                update breweryrRegistry;
                responseMessage = 'Brewery registry has been Deactivated successfully.';

            }
        }
        catch(exception ex)
        {
            System.debug('Exception Occured during InActivateRegistry :'+ex.getMessage());
            responseMessage = ex.getMessage();
        }
        
        System.debug('Final responseMessage is>>>>>:'+responseMessage);
        responseActivationWrapper.brewerRegistry = breweryrRegistry;
        responseActivationWrapper.responseMessage = responseMessage;
        return responseActivationWrapper;
    }    
    

}