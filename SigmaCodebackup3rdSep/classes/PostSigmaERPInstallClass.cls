global without sharing class PostSigmaERPInstallClass implements InstallHandler 
{
    global void onInstall(InstallContext context)
    {
        
     
     
     if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sublevel_location__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location__c')  
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Default_Parameters__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__AfterShip_Courier_List__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__AfterShip_Defaults__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Allocate_Stock_MR__c') 
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Setup_Conversion_Rate_Euro__c') 
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__BackOrder__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Order_Usage__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Agent_Assignment_Settings__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__AssetTriggerCheck__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__domainURL__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Google_API_Key__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Service_Quote_Payment_Terms__c')
        
        && CRUD_FLS_CheckUtility.checkReadPermission('User',new set<String>{'id','name','Email'})
        && CRUD_FLS_CheckUtility.checkReadPermission('Organization',new set<String>{'id','name','Phone'})
        
        
        
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location__c',new set<String>{'id','sigmaerpdev__Location__c'})
        
           
        
        &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Sublevel_location__c',new Set<String>{'Name','RecordTypeId','sigmaerpdev__Inventory_Location__c'})
        &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Default_Parameters__c',new Set<String>{'Name','sigmaerpdev__Default_Location__c','sigmaerpdev__Default_Zone__c','sigmaerpdev__Default_Bin__c','sigmaerpdev__Logo__c','sigmaerpdev__EmailImage__c','sigmaerpdev__priceBook_for_orders__c','sigmaerpdev__Company_Phone__c','sigmaerpdev__Company_Name__c','sigmaerpdev__Company_Email__c','sigmaerpdev__Inventory_Status__c','sigmaerpdev__Company_VAT__c','sigmaerpdev__Wastage_Amount_MR__c','sigmaerpdev__GanttURL__c','sigmaerpdev__Approval_Process_Not_Needed__c'})
        &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__AfterShip_Courier_List__c',new Set<String>{'Name','sigmaerpdev__Slug__c'})
        &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__AfterShip_Defaults__c',new Set<String>{'Name','sigmaerpdev__API_Key__c','sigmaerpdev__Create_Shipment__c','sigmaerpdev__Get_Couriers__c','sigmaerpdev__Tracking__c'})
        &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Allocate_Stock_MR__c',new Set<String>{'Name','sigmaerpdev__Allocate_Back_Order_Quantity__c','sigmaerpdev__Auto_Allocate__c','sigmaerpdev__Show_Auto_Resv_Button__c'})     
        &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Setup_Conversion_Rate_Euro__c',new Set<String>{'Name','sigmaerpdev__Conversion_Rate__c'})
        &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__BackOrder__c',new Set<String>{'Name','sigmaerpdev__Email__c'})
        &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Order_Usage__c',new Set<String>{'Name','sigmaerpdev__Sigma_order__c'})
        &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Agent_Assignment_Settings__c',new Set<String>{'sigmaerpdev__Hover_Duration__c','sigmaerpdev__Maximum_Threshold_Travel_Time__c'})
        &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__AssetTriggerCheck__c',new Set<String>{'Name','sigmaerpdev__CheckAssetPriceUpdatetrigger__c'})
        &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__domainURL__c',new Set<String>{'Name','sigmaerpdev__IframeUrl__c'})
        &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Google_API_Key__c',new Set<String>{'sigmaerpdev__API_Key__c'})
        &&  CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Service_Quote_Payment_Terms__c',new Set<String>{'sigmaerpdev__Payment_Terms_1__c','sigmaerpdev__Payment_Terms_2__c','sigmaerpdev__Payment_Terms_3__c'}))
        
    {
        
        try{
           
                if(context.previousVersion() == null)
                {
                    // sending mail to the customer once package is installed
                    
                    Id OrgId     = context.organizationId();
                    ID instlId   = context.installerId();
                    Version ver = context.previousVersion();
                   
                    Organization orgzName;
                    
                    orgzName =[select id,Name,Phone from Organization where id=:OrgId];
                    String orgzName1=orgzName.Name;
                    
                    User u;
                    u = [Select Id,Name,Email from User where Id =:context.installerID()];   
                    
                    String toAddress = u.Email;
                    String nam = u.Name;
                    String[] toAddresses = new String[]{toAddress};
                        Messaging.SingleEmailMessage mail = 
                        new Messaging.SingleEmailMessage();
                    mail.setToAddresses(toAddresses);
                    mail.setReplyTo('support@sigmaerp365.com');
                    mail.setSenderDisplayName('Sigma ERP Support');
                    
                    
                    EmailTemplate emailTemplate = [Select name,Subject,Body from EmailTemplate where name = 'Post Install Welcome Email'];
                    mail.setSubject(emailTemplate.Subject); 
                    emailTemplate.Body = 'Hi '+nam+', \n\n' +emailTemplate.Body;
                    mail.setPlainTextBody(emailTemplate.Body);
                    
                    Messaging.sendEmail(new Messaging.Email[] { mail });
                    
                    // Sending email to sales team of Mindlinks at sales@sigmaerp365.com 
                    
                    String toAddress1= 'sales@sigmaerp365.com';
                    String[] toAddresses1 = new String[]{toAddress1};
                        Messaging.SingleEmailMessage mail1 = 
                        new Messaging.SingleEmailMessage();
                    mail1.setToAddresses(toAddresses1);
                    mail1.setReplyTo('support@sigmaerp365.com');
                    mail1.setSenderDisplayName('Sigma ERP Support');
                    mail1.setSubject('Sigma ERP Package installed successfully');
                    
                    mail1.setHtmlBody('Package installed by user '+nam+'<br/>Organization Name is:'+orgzName1+'<br/>Email Id'+toAddress+'<br/>Organization Id'+OrgId+'<br/>Installed version is'+ver);
                    Messaging.sendEmail(new Messaging.Email[] {mail1});
                    
                    //insert account location record                    
                    Account accNew = new Account();
                    accNew.Name = 'Bengaluru';
                    accNew.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Location').getRecordTypeId();
                    accNew.Type = 'Location';        
                    insert accNew;
                    //fetch IL record id
                    Inventory_Location__c ilObj = [select id,Location__c from Inventory_Location__c where Location__c = :accNew.Id];
                    
                    //insert Zone and bin record
                    Sublevel_location__c sulLevelObj = new Sublevel_location__c();
                    sulLevelObj.RecordTypeId = Schema.SObjectType.Sublevel_location__c.getRecordTypeInfosByName().get('Zone').getRecordTypeId();
                    sulLevelObj.Name = 'Zone2';
                    sulLevelObj.Inventory_Location__c = ilObj.Id;
                    insert sulLevelObj;
                 
                    Sublevel_location__c sulLevelBinObj = new Sublevel_location__c();
                    sulLevelBinObj.RecordTypeId = Schema.SObjectType.Sublevel_location__c.getRecordTypeInfosByName().get('Bin').getRecordTypeId();
                    sulLevelBinObj.Name = 'Bin2';
                    sulLevelBinObj.Inventory_Location__c = ilObj.Id;
                    sulLevelBinObj.zone__c = sulLevelObj.Id;
                    insert sulLevelBinObj;
                    
                    string orgUrl = URL.getSalesforceBaseUrl().toExternalForm();                
                    orgUrl = orgUrl.replace('my.salesforce.com', 'lightning.force.com/');
                    
                    
                    Pricebook2 pobObj = [select Id,Name from Pricebook2 limit 1];
                    
                    //update fields in default parameters
                    Default_Parameters__c  defparam = new Default_Parameters__c (); 
                    defparam.Name = 'Elift Merchant';
                    defparam.Default_Location__c = ilObj.Id; 
                    defparam.Default_Zone__c = sulLevelObj.Id;
                    defparam.Default_Bin__c = sulLevelBinObj.Id;                    
                    defparam.Logo__c = 'https://c.ap8.content.force.com/servlet/servlet.ImageServer?id=0150o00000GZhek&oid=00D0o0000019H25&lastMod=1550668926000';
                    
                    defparam.EmailImage__c = 'https://c.ap8.content.force.com/servlet/servlet.ImageServer?id=0150o00000GZhen&oid=00D0o0000019H25&lastMod=1550668926000';                    
                    defparam.priceBook_for_orders__c = pobObj.Id;
                    defparam.Company_Phone__c = orgzName.Phone;                    
                    defparam.Company_Name__c = orgzName.Name;
                    defparam.Company_Email__c = u.Email;
                    defparam.Inventory_Status__c = 'Reserve';
                    defparam.Company_VAT__c = 'Not Available';
                    defparam.Wastage_Amount_MR__c = 10;
                    defparam.GanttURL__c = orgUrl; 
                    defparam.Approval_Process_Not_Needed__c = true; 
                    insert defparam;
                    
                    //Custom Settings insertion starts from here
                    
                    //After Ship Courier List
                    List<AfterShip_Courier_List__c> courList = new List<AfterShip_Courier_List__c>();
                    AfterShip_Courier_List__c c1 = new AfterShip_Courier_List__c();
                    c1.name = 'DHL Express';
                    c1.Slug__c = 'dhl';
                    courList.add(c1);

                    AfterShip_Courier_List__c c2 = new AfterShip_Courier_List__c();
                    c2.name = 'FedEx';
                    c2.Slug__c = 'fedex';
                    courList.add(c2);

                    AfterShip_Courier_List__c c3 = new AfterShip_Courier_List__c();
                    c3.name = 'UPS';
                    c3.Slug__c = 'ups';
                    courList.add(c3);

                    AfterShip_Courier_List__c c4 = new AfterShip_Courier_List__c();
                    c4.name = 'USPS';
                    c4.Slug__c = 'usps';
                    courList.add(c4);

                    insert courList;
                    //ends here


                    //After Ship defaults
                    AfterShip_Defaults__c afterShipDefObj = new AfterShip_Defaults__c();
                    afterShipDefObj.Name = 'DefaultValues';
                    afterShipDefObj.API_Key__c = '';
                    afterShipDefObj.Create_Shipment__c = 'https://api.aftership.com/v4/trackings' ;
                    afterShipDefObj.Get_Couriers__c = 'https://api.aftership.com/v4/couriers' ;
                    afterShipDefObj.Tracking__c = 'https://api.aftership.com/v4/trackings/' ;
                    insert afterShipDefObj;
                    //ends here

                    //Allocate Stock MR
                    Allocate_Stock_MR__c allocMr = new Allocate_Stock_MR__c();
                    allocMr.Name = 'Allocate_Stock';
                    allocMr.Allocate_Back_Order_Quantity__c = true;
                    allocMr.Auto_Allocate__c = false;
                    allocMr.Show_Auto_Resv_Button__c = true;
                    insert allocMr;
                    //ends here
                   
                    //Back Order
                    BackOrder__c bckOrdObj = new BackOrder__c();
                    bckOrdObj.Name = 'Email1';
                    bckOrdObj.Email__c = u.Email;
                    insert bckOrdObj;
                    //ends here
                    
                    //Order Usage
                    Order_Usage__c ordUsgObj = new Order_Usage__c();
                    ordUsgObj.Name = 'Order Usage';
                    ordUsgObj.Sigma_order__c = true;
                    insert ordUsgObj;
                    //ends here
                   
                    //Setup Conversion Rate Euro
                    Setup_Conversion_Rate_Euro__c setConvEuroObj = new Setup_Conversion_Rate_Euro__c();
                    setConvEuroObj.Name = 'SetEuro';
                    setConvEuroObj.Conversion_Rate__c = 0.86;
                    insert setConvEuroObj;
                    //ends here
                    
                    //FFP configurations Custom settings code starts from here
                    Agent_Assignment_Settings__c agentassign = new Agent_Assignment_Settings__c();
                    agentassign.Hover_Duration__c = 15;
                    agentassign.Maximum_Threshold_Travel_Time__c = 30;
                    insert agentassign;

                    
                    
                    AssetTriggerCheck__c asserttriggerchck = new AssetTriggerCheck__c();
                    asserttriggerchck.Name = 'APU';
                    asserttriggerchck.CheckAssetPriceUpdatetrigger__c = false;
                    insert asserttriggerchck;

                    domainURL__c durl = new domainURL__c();
                    durl.Name = 'CommunityURL';
                    durl.IframeUrl__c = orgUrl;
                    insert durl;

                    Google_API_Key__c Gapi = new Google_API_Key__c();
                    Gapi.API_Key__c = '';
                    insert Gapi;

                    Service_Quote_Payment_Terms__c sqpt = new Service_Quote_Payment_Terms__c();
                    sqpt.Payment_Terms_1__c = '7';
                    sqpt.Payment_Terms_2__c = '10';
                    sqpt.Payment_Terms_3__c = '30';
                    insert sqpt;    
                    //ends here
           
                  
                }//If Block   
            }catch(Exception ex){
                System.debug('Exception occured when running post installation script for SigmaERP365 product, get in touch with SigmaERP365 team');
            Messaging.SingleEmailMessage emailTobeSent = new Messaging.SingleEmailMessage();
            list<String> listEmailMembers = new list<String>();
            listEmailMembers.add('vikaskumar.rv@gmail.com');
            emailTobeSent.setToAddresses(listEmailMembers);
            emailTobeSent.setSubject('Post install exception');
            emailTobeSent.setHtmlBody('Message : ' + ex.getMessage() + 'Line no : ' + ex.getLineNumber() + ' getStackTraceString ' + ex.getStackTraceString() + '' + ex.getCause());
            Messaging.SendEmailResult [] r1 = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailTobeSent});
           
            }//Catch Block
             
        } //End of Method
    }
    }