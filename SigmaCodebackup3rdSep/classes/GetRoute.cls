global with sharing class GetRoute 
{  
    public String work_order_ID { get; set; }
    public List<Work_Order__c> work_orders { get; set; }
    
    public static string startpoint
    { 
        get
        {
            startpoint = apexpages.currentpage().getparameters().get('startpoint');
            return startpoint;
        } 
        set;
    }
    
    public static string endpoint
    {
        get
        {
            endpoint = apexpages.currentpage().getparameters().get('endpoint');
            return endpoint;
        } 
        set;
    }
    @RemoteAction
    global static String getCustomSettings(String work_order_ID1)
    {
        //--get the google API from custom setting
        Google_API_Key__c googleAPIKey = Google_API_Key__c.getInstance();
        
        String key=googleAPIKey.API_Key__c;
        system.debug('Google Key - '+key);
        return key;
    }
    
    @RemoteAction
    global static List<Work_Order__c> getwork_orders(String work_order_ID)
    {
        System.debug('work_order_ID'+work_order_ID);
        
        List<Work_Order__c> work_orders;
        Id userId;
        User u = new User();
        try{
             // User Fields that will be accessed.
            /*String [] userFields = new String [] {'Name','ContactId'};
                
                // Obtaining the field name/token map for the User object
                Map<String,Schema.SObjectField> muserfields = Schema.SObjectType.User.fields.getMap();
            for (String fieldToCheck : userFields) {
                // Check if the user has create access on the each field
                if (!muserfields.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on user Fields');
                    return null;
                }
            }
            
            
            //To get the User Info.
            userId = UserInfo.getUserId();
            
            u = [select id, contactId from User where Id = :userId];
            //User u = [select id, contactId from User where Name = 'John M'];
            System.debug('userID: ' + u.Id);*/
            userId = UserInfo.getUserId();
        }
        catch(Exception e){
            system.debug('Exception occurred while fetching User details - '+e);
        }
        
        if(userId != null)
        {
            try{
                
                 // User Fields that will be accessed.
            String [] WOFields = new String [] {'sigmaerpdev2__Customer_Availability_Date__c','sigmaerpdev2__Status__c','sigmaerpdev2__AssignTo__c','sigmaerpdev2__Service_Street__c','sigmaerpdev2__Service_Zip_Postal_Code__c','sigmaerpdev2__Service_State_Province__c'};
                
                // Obtaining the field name/token map for the User object
                Map<String,Schema.SObjectField> mWOfields = Schema.SObjectType.Work_Order__c.fields.getMap();
            for (String fieldToCheck : WOFields) {
                // Check if the user has create access on the each field
                if (!mWOfields.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on user Fields');
                    return null;
                }
            }
            
                
                //Gets all the WorkOrders with Preferred Date = today's date and status as Accpeted and Assigned for the Above User.
                work_orders = [SELECT Id, Customer_Availability_Date__c, Status__c, AssignTo__c, Service_Street__c, Service_State_Province__c,Service_Zip_Postal_Code__c FROM Work_Order__c WHERE (Customer_Availability_Date__c = TODAY AND AssignTo__c = :userId AND (Status__c = 'Accepted')) ORDER BY Customer_Availability_Date__c ASC];
                system.debug('Word Orders -'+work_orders);
            }
            catch(Exception e){
                system.debug('Exception Occurred while fetching Work Orders - '+e);
            }
        }
        return work_orders; 
    }
}