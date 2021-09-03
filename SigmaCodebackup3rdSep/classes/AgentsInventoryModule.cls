/***************************************************************************************************************************** 
SL.No      Author                  Version                     Description

1.         Jayanth G                1.0 (Initial Version)       AgentsInventoryModule is an Apex class which gets invoked
                                                                by AgentsInventoryModuleHelper. This class returns a Map
                                                                that contains details of Products such as Product Needed, 
                                                                Stock Availability, Product Name with respect to every Date.
*******************************************************************************************************************************/  
public with sharing class AgentsInventoryModule {  
    @AuraEnabled
    public static Map<String,Map<Date,ProductList>> getProductStck(String fromDateString, DateTime toDateString, String[] arrDateString){
        System.debug('From Date - '+fromDateString);
        System.debug('To Date - '+toDateString);
        System.debug('Array Date - '+arrDateString);
        Date testDate = Date.today();
        system.debug('Testing Date - '+testDate);
        
        List<sigmaerpdev2__Products_Needed__c> commonProductNeeded = new List<sigmaerpdev2__Products_Needed__c>();
        
        Map<Date,List<ProductList>> plDate = new Map<Date,List<ProductList>>();
        Map<String,Map<Date,ProductList>> plList = new Map<String,Map<Date,ProductList>>();
        
        Integer i = 0;
        Date[] arrDate;
        try{
            //creating Array of Dates.
            arrDate = new Date[arrDateString.size()];
            for(i=0;i<arrDateString.size();i++){
                arrDate[i] = Date.valueOf(arrDateString[i]);
            }
        }
        catch(Exception e){
            system.debug(' Exception in Array of Dates - '+e);
        }
        
        Map<Date,List<sigmaerpdev2__Work_Oder_Lines__c>> dateWOLI = new Map<Date,List<sigmaerpdev2__Work_Oder_Lines__c>>();
        
        //Initalizing 'dateWOLI' Map with each key as Date and value as NULL.
        
        for(Date eachDate:arrDate){
            dateWOLI.put(eachDate,null);
        }

        System.debug('update DateArray -'+arrDate);
        
        DateTime fromDate;
        DateTime toDate;
        try{
            //Converting String to DateTime.
            fromDate = getDateTime(fromDateString);
            System.debug('fromDateString' + fromDate);
            
            //Converting String to DateTime.
            //toDate = getDateTime(toDateString);
            toDate = toDateString;
            System.debug('toDateString' + toDate);
            
            //Getting DATETIME according to timezone of the user.
            fromDate = DateTime.valueOfGmt((fromDate).format('yyyy-MM-dd HH:mm:ss', UserInfo.getTimeZone().getID()));
            //toDate = DateTime.valueOfGmt((toDate).format('yyyy-MM-dd HH:mm:ss', UserInfo.getTimeZone().getID()));
            System.debug('fromDate' + fromDate);
            System.debug('toDate' + toDate);
        }
        catch(Exception e){
            system.debug(' Exception in fromDate and toDate Initialisation - '+e);
        }
        
        Map<Id,Double> common = new Map<Id,Double>();
        
        
        User u = new User();
        list<Service_Resource__c> contact = new list<Service_Resource__c>();
        List<sigmaerpdev2__Work_Order__c> workOrdersAssigned = new List<sigmaerpdev2__Work_Order__c>();
        try{
            //Get UserId.
            Id userId = UserInfo.getUserId();        
            System.debug('User' + userId);
            
            // User Fields that will be accessed.
            /*String [] userFields = new String [] {'Name','contactId'};
                
                // Obtaining the field name/token map for the User object
                Map<String,Schema.SObjectField> userMap = Schema.SObjectType.User.fields.getMap();
            for (String fieldToCheck : userFields) {
                // Check if the user has create access on the each field
                if (!userMap.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on User Fields');
                    return null;
                }
            }
           u = [select id, Name, contactId from User where Id = :userId];
            
             //u = [select id, contactId from User where Name = 'John M'];    
            system.debug('user -'+u);*/
            
            
            // Contact Fields that will be accessed.
            String [] serviceResourceFields = new String [] {'Name','sigmaerpdev2__Service_Location__c'};
                
                // Obtaining the field name/token map for the Contact object
                Map<String,Schema.SObjectField> serviceResourceMap = Schema.SObjectType.sigmaerpdev2__Service_Resource__c.fields.getMap();
            for (String fieldToCheck : serviceResourceFields) {
                // Check if the user has create access on the each field
                if (!serviceResourceMap.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on Service Resource Fields');
                    return null;
                }
            }
            //Getting contact's location.
            contact = [SELECT Id,Name,sigmaerpdev2__Service_Location__c FROM sigmaerpdev2__Service_Resource__c where sigmaerpdev2__User__c =:userId];
            system.debug('Contact wrt User -'+contact);
            
            
            // WorkOrder Fields that will be accessed.
            String [] workOrderFields = new String [] {'sigmaerpdev2__Work_Type__c','sigmaerpdev2__Customer_Availability_Date__c','sigmaerpdev2__Status__c','sigmaerpdev2__AssignTo__c'};
                
                // Obtaining the field name/token map for the WorkOrder object
                Map<String,Schema.SObjectField> workOrderMap = Schema.SObjectType.sigmaerpdev2__Work_Order__c.fields.getMap();
            for (String fieldToCheck : workOrderFields) {
                // Check if the user has create access on the each field
                if (!workOrderMap.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on WorkOrder Fields');
                    return null;
                }
            }
            //Assigned WorkOrders between fromDate and toDate.
            workOrdersAssigned = [SELECT Id, sigmaerpdev2__Work_Type__c,sigmaerpdev2__Customer_Availability_Date__c  FROM sigmaerpdev2__Work_Order__c where (sigmaerpdev2__Status__c = 'Assigned' OR sigmaerpdev2__Status__c = 'Accepted') and sigmaerpdev2__AssignTo__c  =: userId and (sigmaerpdev2__Customer_Availability_Date__c >= :fromDate and sigmaerpdev2__Customer_Availability_Date__c <:toDate)];
            System.debug('workOrdersAssigned' + workOrdersAssigned);
        }
        catch(Exception e){
            system.debug('Exception in Queries - '+e);
        }
        
        
        //Return Null if there are no work orders.
        if(workOrdersAssigned == null || workOrdersAssigned.size()==0){
            return null;
        }
        
        //Creating a set of WorkOrder Id's.
        Set<Id> workorderid = new Set<Id>();
        
        
        //Fetching all the WorkOrder Id's only if its between fromDate and toDate.
        for(sigmaerpdev2__Work_Order__c  eachworkOrderAssign : workOrdersAssigned){
            //Fetching the Prefferred DateTime w.r.t the timeline of the user.
            Date ffpDate = convertDateTimetoDate(DateTime.valueOfGmt((eachWorkOrderAssign.sigmaerpdev2__Customer_Availability_Date__c).format('yyyy-MM-dd HH:mm:ss', UserInfo.getTimeZone().getID())));
            system.debug('ffdDate - '+ffpDate);
            if(fromDate<= ffpDate && ffpDate<toDate){
                system.debug(' Match ffdDate - '+ffpDate);
                if(workorderid.contains(eachworkOrderAssign.Id)== false){
                    workorderid.add(eachworkOrderAssign.Id);
                } 
            }
        }
        System.debug('workorderid' + workorderid);
        
        
        List<sigmaerpdev2__Product_Stock__c> productStock = new List<sigmaerpdev2__Product_Stock__c>();
        List<sigmaerpdev2__Work_Oder_Lines__c> productNeeded = new List<sigmaerpdev2__Work_Oder_Lines__c>();
        try{
            
            // ProductStock Fields that will be accessed.
            String [] productStockFields = new String [] {'sigmaerpdev2__Inventory__c','sigmaerpdev2__Product_Lookup__c','sigmaerpdev2__Location__c'};
                
                // Obtaining the field name/token map for the ProductStock object
                Map<String,Schema.SObjectField> productStockMap = Schema.SObjectType.sigmaerpdev2__Product_Stock__c.fields.getMap();
            for (String fieldToCheck : productStockFields) {
                // Check if the user has create access on the each field
                if (!productStockMap.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on ProductStock Fields');
                    return null;
                }
            }
            //Stock present at Technician's Location.
            productStock = [SELECT Id, sigmaerpdev2__Inventory__c, sigmaerpdev2__Product_Lookup__r.Name,sigmaerpdev2__Location__c   FROM sigmaerpdev2__Product_Stock__c where sigmaerpdev2__Location__c =: contact[0].sigmaerpdev2__Service_Location__c];
            System.debug('ProductStock at Agent' + productStock);
            
            // WorkOrderLines Fields that will be accessed.
            String [] workOrderLineFields = new String [] {'sigmaerpdev2__Quantity__c','sigmaerpdev2__Work_Order__c','sigmaerpdev2__Product__c'};
                
                // Obtaining the field name/token map for the WorkOrderLines object
            Map<String,Schema.SObjectField> workOrderLineMap = Schema.SObjectType.sigmaerpdev2__Work_Oder_Lines__c.fields.getMap();
            for (String fieldToCheck : workOrderLineFields) {
                // Check if the user has create access on the each field
                if (!workOrderLineMap.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on WorkOrderLine Fields');
                    return null;
                }
            }
            //Required WorkOrderLineItems of all the WorkOrders.
            productNeeded=[SELECT Id, sigmaerpdev2__Quantity__c,sigmaerpdev2__Work_Order__c, sigmaerpdev2__Product__c FROM sigmaerpdev2__Work_Oder_Lines__c where sigmaerpdev2__Work_Order__c IN:workorderid];
            System.debug('productNeeded>>>' + productNeeded);
            
            
            
            //Adding WorkOrderLines to Map according to the Date with 'Date' as Key and 'List of WOLI' as its value.
            List<Id> productNeedId = new List<Id>();
            
            //Loop containing array of Dates.
            for(Date eachDate:arrDate){
                system.debug('eachDate-'+eachDate);
                List<sigmaerpdev2__Work_Oder_Lines__c> workOrderLines = new List<sigmaerpdev2__Work_Oder_Lines__c>();
                
                //Loop of WorkOrders.
                for(sigmaerpdev2__Work_Order__c eachWorkOrder : workOrdersAssigned){
                    system.debug('eachWorkOrder-'+eachWorkOrder);
                    Date ffpDate = convertDateTimetoDate(DateTime.valueOfGmt((eachWorkOrder.sigmaerpdev2__Customer_Availability_Date__c).format('yyyy-MM-dd HH:mm:ss', UserInfo.getTimeZone().getID())));
                    
                    //Comparing a date in the 'arrDate' and 'customer availability date of a workOrder'.
                    if(eachDate == ffpDate){
                        system.debug('eachDate-'+eachDate+' ffpDate-'+ffpDate);
                        system.debug('DateMatchedWorkOrder - '+ eachWorkOrder);
                        
                        //Loop of WorkOrderLine items required.
                        for(sigmaerpdev2__Work_Oder_Lines__c productNeed : productNeeded){
                            
                            //Matching WorkOrderLineItem's WorkOrder with actual WorkOrder.
                            if(eachWorkOrder.Id == productNeed.sigmaerpdev2__Work_Order__c){
                                system.debug('DateMatchedWorkOrderLine - '+ productNeed);
                                sigmaerpdev2__Work_Oder_Lines__c temp = new sigmaerpdev2__Work_Oder_Lines__c();
                                temp.Id = productNeed.Id;
                                temp.sigmaerpdev2__Quantity__c = productNeed.sigmaerpdev2__Quantity__c;
                                temp.sigmaerpdev2__Product__c = productNeed.sigmaerpdev2__Product__c;
                                
                                //Grouping all the WorkOrderLineItems of a particular Workorder in a List.
                                workOrderLines.add(temp);
                            }
                        }  
                    }
                }
                if(workOrderLines.size()!=0){
                    if(dateWOLI.containsKey(eachDate)){
                        //Assigning the List of WorkOrderLine Items to eachDate w.r.t to the Customer Availability Date of a WorkOrder.
                        dateWOLI.put(eachDate,workOrderLines);     
                    }
                }
            }
            system.debug('WOLI wrt Date - '+dateWOLI);
            
            //Combining two records the one with same ProductName by the Adding the quantity from each of the record.
            
            //Loop of dates with value as List of WorkOrderLineItems.
            for(Date key : dateWOLI.keySet()){
                Map<Id,Double> commonProd = new Map<Id,Double>();
                i=0;
                if(dateWOLI.get(key)!=null){
                    List<sigmaerpdev2__Work_Oder_Lines__c> temp = dateWOLI.get(key);
                    for(sigmaerpdev2__Work_Oder_Lines__c productNeed1:temp){
                        
                        //Checking if there are two WorkOrderLineItems with same name and combining it by adding both of its quantites.
                        commonProd.put(productNeed1.sigmaerpdev2__Product__c,commonProd.containsKey(productNeed1.sigmaerpdev2__Product__c)?commonProd.get(productNeed1.sigmaerpdev2__Product__c)+productNeed1.sigmaerpdev2__Quantity__c:productNeed1.sigmaerpdev2__Quantity__c);
                        temp[i].sigmaerpdev2__Quantity__c = commonProd.get(productNeed1.sigmaerpdev2__Product__c);
                        i++;
                    }
                    dateWOLI.put(key,temp);
                }
            }
            system.debug('Common '+dateWOLI);
            
            
            //Defining a Map with eachDate as key and List of ProductList object as its value.
            //
            //Loop of map with date as key and unique List of WOLI for eah Key.
            for(Date keyDate : dateWOLI.keySet()){
                system.debug('null - '+keyDate);
                List<ProductList> productList = new List<ProductList>();
                List<ProductList> productListEmpty = new List<ProductList>();
                if(dateWOLI.get(keyDate)!=null){
                    system.debug('date not null - '+keyDate);
                    List<sigmaerpdev2__Work_Oder_Lines__c> tempDateWOLI = dateWOLI.get(keyDate);
                    system.debug('tempDate -'+tempDateWOLI);
                    
                    //Loop of Product Stock at the Technician.
                    for(sigmaerpdev2__Product_Stock__c productStck : productStock){
                        
                        //Loop of the WorkOrderLineItems of each Date.
                        for(sigmaerpdev2__Work_Oder_Lines__c eachProduct : tempDateWOLI){
                            
                            //Comparing the Product at ProductStock and WorkOrderLineItem.
                            if(productStck.sigmaerpdev2__Product_Lookup__c == eachProduct.sigmaerpdev2__Product__c){
                                system.debug('Product Match'+productStck.sigmaerpdev2__Product_Lookup__c); 
                                
                                //creating an Object of only required Fields.
                                ProductList temp = new ProductList();                            
                                System.debug('If' + productStck.sigmaerpdev2__Location__c );
                                temp.productName = productStck.sigmaerpdev2__Product_Lookup__r.Name;                            
                                temp.productAvailable = productStck.sigmaerpdev2__Inventory__c;                            
                                temp.productNeeded = eachProduct.sigmaerpdev2__Quantity__c;
                                
                                //List of all Products for each Date with the Product's fields such as Name, Stock Available and Needed.
                                productList.add(temp);
                                System.debug('productList'+productList);
                            }  
                        }
                    }  
                }
                if(productList.size()!=0 && dateWOLI.get(keyDate)!=null){
                    
                    //A map with eachDate as Key and Its productList Object as its value.
                    plDate.put(keyDate,productList);
                }
                else{
                    ProductList temp = new ProductList();
                    productListEmpty.add(temp);
                    plDate.put(keyDate,productListEmpty);
                    productListEmpty.clear();
                }
            }
            
            system.debug('PLDate - '+plDate);
            
            //Initialising a Map with key as Product Name and its value as NULL.
            Set<String> productNameList = new Set<String>();
            
            //Loop of List of ProductDetails with respect to each Date.
            for(Date key : plDate.keySet()){
                
                //Getting the list Product and its details from eachDate to 'temp'.
                List<ProductList> temp = plDate.get(key);
                for(ProductList eachProductList : temp){
                    if(productNameList.contains(eachProductList.productName)==false){
                        
                        //Adding all the product Names into a set.
                        productNameList.add(eachProductList.productName);
                    }
                }
            }
            
            //Creating Map with key as EachProductName and its value as Null.
            for(String eachProductName : productNameList){
                plList.put(eachProductName,null); 
            }
            
            //Loop containing ProductName -> Map of (Date -> List of Product Details).
            for(String eachProductName : plList.keySet()){
                Map<Date,ProductList> dateList = new Map<Date,ProductList>();
                
                //Map with Date -> List of Product Details.
                for(Date eachDate : plDate.keySet()){
                    
                    //fetching the list of product Details from eachDate.
                    List<ProductList> temp = plDate.get(eachDate);
                    
                    //going through every object in the above List.
                    for(ProductList eachProductList : temp){
                        if(eachProductList.productName == eachProductName){
                            ProductList tempProduct = new ProductList();
                            tempProduct.productNeeded = eachProductList.productNeeded;
                            tempProduct.productAvailable = eachProductList.productAvailable;
                            
                            //A Map containing Key as Date and its value as List of ProductDetails.
                            dateList.put(eachDate,tempProduct);
                        }
                    }
                    if(plList.containsKey(eachProductName) && dateList.containsKey(eachDate)){
                        
                        //Adding Product Name as key and its value as Map<date,ProductList>.
                        plList.put(eachProductName,dateList);
                    }
                    else{
                        ProductList tempProduct = new ProductList();
                        dateList.put(eachDate,tempProduct);
                        plList.put(eachProductName,dateList);
                    }
                }
            }
            system.debug('ProductList with Name - '+plList);
            System.debug('ProductList with Date - '+plDate);
            return plList;
        }
        catch(Exception e){
            system.debug('Exception Occurred - '+e);
            return null;
        }
        
    }
    
    public static Date convertDateTimetoDate(DateTime dtRec){
        Date ffpDate;
        String dateVal = String.valueOfGmt(dtRec);
        
        if(dateVal != null && dateVal != '') {
            String[] dateValArray = dateVal.split('-');
            ffpDate = Date.valueOf(dateValArray[0]+'-'+dateValArray[1]+'-'+dateValArray[2]);
            return ffpDate;
        }
        return null;
    }
    
    public static DateTime getDateTime(String temp){
        Date Preferreddate1 = Date.valueOf(temp);
        System.debug('Preferreddate1' + Preferreddate1);
        Integer d = Preferreddate1.day();
        Integer mo = Preferreddate1.month();
        Integer yr = Preferreddate1.year();
        DateTime DT = DateTime.newInstance(yr, mo, d, 00, 00, 00);
        return DT;
    }
    
    public class ProductList{
        @AuraEnabled
        public String productName;
        @AuraEnabled
        public Double productNeeded;
        @AuraEnabled
        public Double productAvailable;
    }
}