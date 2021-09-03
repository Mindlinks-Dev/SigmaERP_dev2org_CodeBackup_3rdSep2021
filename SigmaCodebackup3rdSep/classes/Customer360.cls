public class Customer360 {
    @AuraEnabled
    public static CustomerDetails getWorkOrderData(String recordId){
        system.debug('WorkOrder Record Id - '+recordId);
        Boolean flag = false;
        
        DateTime todaysDate = DateTime.now();
        system.debug('Today\'s Date - '+todaysDate);
        
        //6 months before.
        DateTime sixMonthsBack = todaysDate.addMonths(-6);
        sixMonthsBack = DateTime.newInstanceGmt(sixMonthsBack.date().year(), sixMonthsBack.date().month(), sixMonthsBack.date().day(), 00, 00, 00);
        system.debug('6 months back - '+sixMonthsBack);
        
        CustomerDetails customerDetails = new CustomerDetails();
        
        String [] workOrderFields = new String [] {'Name','Product__c','sigmaerpdev2__Customer_Contact__c','LastModifiedDate','sigmaerpdev2__Account__c','sigmaerpdev2__Case_Number_text__c','sigmaerpdev2__Case_Subject_text__c','sigmaerpdev2__Case_Description__c','sigmaerpdev2__Customer_Availability_Date__c','sigmaerpdev2__AssignTo__c'};
            
            // Obtaining the field name/token map for the WorkOrder object
            Map<String,Schema.SObjectField> workOrderMap = Schema.SObjectType.sigmaerpdev2__Work_Order__c.fields.getMap();
        for (String fieldToCheck : workOrderFields) {
            // Check if the Work Order has create access on the each field
            if (!workOrderMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on Work Order Fields');
                return null;
            }
        }
        Work_Order__c workOrder = new Work_Order__c();
        try{
            //Fetching the Work Order on which the 360 View button was clicked.
            workOrder = [SELECT Id,Name,Account__c,Case_Description__c,Customer_Contact__c,FFP_MR_Contact__r.Name,FFP_MR_Contact__r.MailingPostalCode,FFP_MR_Contact__r.Phone,FFP_MR_Contact__r.MobilePhone,FFP_MR_Contact__c ,Customer_Availability_Date__c,Product__c,Product__r.Name,LastModifiedDate,Service_Zip_Postal_Code__c,Case_Subject_text__c,Case_Number_text__c FROM Work_Order__c where Id =: recordId];
            system.debug('WorkOrder - '+workOrder);
        }
        catch(Exception e){
            system.debug('Exception Occurred at Querying WorkOrder - '+e);
        }
        if(workOrder == null){
            system.debug('No WorkOrders');
            return null;
        }
        try{
            customerDetails.workOrderName = workOrder.Name;
            customerDetails.name = workOrder.FFP_MR_Contact__r.Name;
            if(workOrder.FFP_MR_Contact__r.Phone != null){
                customerDetails.customerPhone = workOrder.Customer_Contact__c;
            }
            else{
                customerDetails.customerPhone = workOrder.FFP_MR_Contact__r.MobilePhone;
            }
            
            if(workOrder.Case_Description__c!=NULL){
                customerDetails.issue =workOrder.Case_Subject_text__c+' - '+workOrder.Case_Description__c+'.'; 
            }
            else{
                customerDetails.issue = workOrder.Case_Subject_text__c;
            }
            customerDetails.customerPincode = workOrder.Service_Zip_Postal_Code__c;
            customerDetails.productName = workOrder.Product__r.Name+' - ';
            system.debug('Customer Details - '+customerDetails);
        }
        catch(Exception e){
            system.debug('Exception Occurred -'+e);
        }
        List<Work_Order__c> pastWorkOrders = new List<Work_Order__c>();
        try{
            //Fetching the past 6 months Work Orders with respect to the Current Work Order's Account in Descending Order with respect to the Preferred Service Date/Time.
            pastWorkOrders = [SELECT Id,name, AssignTo__r.Name ,Customer_Contact__c, AssignTo__c ,AssignTo__r.Phone,Product__c,Product__r.Name,LastModifiedDate , Case_Subject_text__c,Case_Number_text__c,Customer_Availability_Date__c  FROM Work_Order__c where Customer_Availability_Date__c >: sixMonthsBack AND Customer_Availability_Date__c <:workOrder.Customer_Availability_Date__c AND Account__c =:workOrder.Account__c AND (Status__c ='Completed' OR Status__c ='Invoiced to Customer') ORDER BY Customer_Availability_Date__c DESC];
            system.debug('Past WorkOrders - '+pastWorkOrders);
        }
        catch(Exception e){
            system.debug('Exception Occurred while fetching Work orders - '+e);
        }
        if(pastWorkOrders == null || pastWorkOrders.size()==0 ){
            system.debug('No Past WorkOrders');
            customerDetails.lastVisitDate = 'NA';
            customerDetails.lastVisitReason = 'NA';
            customerDetails.lastVisitReason1 = '';
            customerDetails.avgServiceRating = 'NA';
            customerDetails.lastVisitTechName = 'NA';
            customerDetails.numberOfCases = 'NA';
            customerDetails.lastVisitServiceRating = 'NA';
        }
        else{
            try{
                Set<Id> pastWorkOrdersId = new Set<Id>();
                for(Work_Order__c eachWorkOrder : pastWorkOrders){
                    if(pastWorkOrdersId.contains(eachWorkOrder.Id)==false){
                        pastWorkOrdersId.add(eachWorkOrder.Id);
                    }
                }
                customerDetails.lastVisitWorkOrderId = pastWorkOrders.get(0).Id;
                system.debug('Last Visit Work Order ID - '+customerDetails.lastVisitWorkOrderId);
                system.debug('Past Work Orders ID - '+pastWorkOrdersId);
                
                if(pastWorkOrders.size()==0 || pastWorkOrders ==null){
                    customerDetails.numberOfCases = '0';
                }
                else{
                    customerDetails.numberOfCases = String.valueOf(pastWorkOrders.size());
                }
                
                Date dt = pastWorkOrders[0].Customer_Availability_Date__c.date();
                customerDetails.lastVisitDate = String.valueOf(dt);
                customerDetails.lastVisitReason=pastWorkOrders[0].Product__r.Name+' - ';
                customerDetails.lastVisitReason1 = pastWorkOrders[0].Case_Subject_text__c+'.';
                customerDetails.lastVisitTechName = 'Mr. '+pastWorkOrders[0].AssignTo__r.Name;
                if(pastWorkOrders[0].AssignTo__r.Phone!=null){
                    customerDetails.lastVisitTechContact = '- '+pastWorkOrders[0].AssignTo__r.Phone;
                }
                else{
                    customerDetails.lastVisitTechContact = pastWorkOrders[0].AssignTo__r.Phone;
                }

                String [] serviceFeedbackFields = new String [] {'sigmaerpdev2__Service_Rating__c','sigmaerpdev2__Work_Order__c','sigmaerpdev2__Customer_Feedback__c'};
                    
                    // Obtaining the field name/token map for the Service Feedback object
                    Map<String,Schema.SObjectField> serviceFeedbackMap = Schema.SObjectType.sigmaerpdev2__Service_Feedback__c.fields.getMap();
                for (String fieldToCheck : serviceFeedbackFields) {
                    // Check if the Service Feedback has create access on the each field
                    if (!serviceFeedbackMap.get(fieldToCheck).getDescribe().isAccessible()) {
                        system.debug('Has no Access on Service Feedback Fields');
                        return null;
                    }
                }
                
                //Fetching Service Feedbacks of all the previous Work Orders.
                List<Service_Feedback__c> serviceFeedback = [SELECT Id, Service_Rating__c, Work_Order__c,Customer_Feedback__c FROM Service_Feedback__c where Work_Order__c IN :pastWorkOrdersId];
                system.debug('Past 6 months Service Feedback - '+serviceFeedback);
                if(serviceFeedback == null || serviceFeedback.size()==0){
                    customerDetails.serviceFeedbackList = false;
                    customerDetails.lastVisitServiceRating = 'NA';
                    customerDetails.avgServiceRating = 'NA';
                    system.debug('Customer Details - '+customerDetails);
                    return customerDetails;
                }
                
                Decimal average = 0.0;
                Integer i = 0;
                Integer workOrderIndex = 0;
                
                //Checking which immediate previous Work Order has a Service Feedback or not.
                //If yes copy that Past Work Order's Index value.
                /*for(Work_Order__c eachPastWorkOrder : pastWorkOrders){
                    i = 0;
                    for(Service_Feedback__c eachServiceFeedback : serviceFeedback){
                        system.debug('Value of i - '+i);
                        if(eachServiceFeedback.Work_Order__c == eachPastWorkOrder.Id){
                            system.debug('Match - ');
                            system.debug('Value of Work Order Index - '+i);
                            workOrderIndex = i;
                            break;
                        }
                        i++;
                    }
                    if(workOrderIndex!=null){
                        break;
                    }
                }*/
                
                //Calculating the Average Service Rating and also the last visit Service Rating.
                customerDetails.lastVisitServiceRating = 'NA';
                for(Service_Feedback__c eachServiceFeedback : serviceFeedback){
                    average = average + eachServiceFeedback.Service_Rating__c;
                    system.debug('Each Service Rating - '+average);
                    if(eachServiceFeedback.Work_Order__c == pastWorkOrders[workOrderIndex].Id){
                        system.debug('Service Feedback matched with Past Work Order');
                        if(eachServiceFeedback.Service_Rating__c!=NULL){
                            customerDetails.lastVisitServiceRating = String.valueOf(eachServiceFeedback.Service_Rating__c);
                            system.debug('Last visit Service Rating - '+customerDetails.lastVisitServiceRating);
                        }
                        else{
                            customerDetails.lastVisitServiceRating = 'NA';
                        }
                    }
                }
                customerDetails.avgServiceRating = String.valueOf((average/(serviceFeedback.size())).setScale(2));
                customerDetails.serviceFeedbackList = true;
                system.debug('Avergae Servcie Rating - '+customerDetails.avgServiceRating);
            }
            catch(Exception e){
                system.debug('Exception - '+e);
            }
        }  
        system.debug('Customer Details - '+customerDetails);
        return customerDetails;
    }
    
    public class CustomerDetails{
        @AuraEnabled
        public String workOrderName;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String customerPhone;
        @AuraEnabled
        public String customerPincode;
        @AuraEnabled
        public String productName;
        @AuraEnabled
        public String issue;
        @AuraEnabled
        public String lastVisitWorkOrderId;
        @AuraEnabled
        public String lastVisitDate;
        @AuraEnabled
        public String lastVisitTechName;    
        @AuraEnabled
        public String lastVisitTechContact;
        @AuraEnabled
        public String lastVisitReason;
        @AuraEnabled
        public String lastVisitReason1;
        @AuraEnabled
        public String lastVisitServiceRating; 
        @AuraEnabled
        public String numberOfCases;
        @AuraEnabled
        public String avgServiceRating;
        @AuraEnabled
        public Boolean serviceFeedbackList;
    }
}