trigger WorkOrderTrigger on Work_Order__c(after update,before update,after insert) {
    try{ 
        String [] workOrderFields = new String [] {'Name','sigmaerpdev2__Customer_Availability_Date__c','sigmaerpdev2__Work_Type__c','sigmaerpdev2__Status__c','sigmaerpdev2__AssignTo__c'};
            
            // Obtaining the field name/token map for the WorkOrder object
            Map<String,Schema.SObjectField> workOrderMap = Schema.SObjectType.Work_Order__c.fields.getMap();
        for (String fieldToCheck : workOrderFields) {
            // Check if the user has create access on the each field
            if (!workOrderMap.get(fieldToCheck).getDescribe().isAccessible()) {
                system.debug('Has no Access on WorkOrder Fields');
                return;
            }
        }
        if (Trigger.isAfter) {
            if (Trigger.isUpdate) {
                if(AvoidRecurrsion.isRecurssiveAU()){
                    Work_Order__c  currentWO=[SELECT Id,Work_Type__r.name FROM Work_Order__c where id=:Trigger.old Limit 1];
                    Service_Appointments__c sa=new Service_Appointments__c();
                        sa=[SELECT Id ,Work_Order_Status__c FROM Service_Appointments__c
                      WHERE Work_Order__r.Id =:currentWO.Id order by CreatedDate desc limit 1];
                    // temporary variables
                    //List < Case > caseList = new List < Case > ();
                    String woStatusOld = '';
                    String woStatusNew = '';
                    
                    Map<Id,Work_Order__c> woOldMap = Trigger.oldMap;
                    system.debug('OldWorkOrder -'+woOldMap);
                    // if Case.Send_to_RPS__c = 'New' from something else
                    List<Work_Order__c> listWorkOrders = Trigger.New;
                    //for (sigmaerpdev2__Work_Order__c eachWORecord: listWorkOrders) {
                        system.debug('wORKoRDERS - '+listWorkOrders[0]);
                        //--old WO Value
                        Work_Order__c woRecordsOld = new Work_Order__c();
                        if (woOldMap != null) {
                            woRecordsOld = woOldMap.get(listWorkOrders[0].Id);
                            woStatusOld = woRecordsOld.Status__c;
                            system.debug('OldWorkOrder Status - '+woStatusOld);
                        }
                        
                        //--current WO status value
                        woStatusNew = listWorkOrders[0].Status__c;
                        sa.Work_Order_Status__c=listWorkOrders[0].Status__c;
                        update sa;
                        //woWorkType=eachWORecord.wo
                        system.debug('NewWorkOrder Status - '+woStatusNew);
                       
                        //-- if Old and New is different
                        //-- AND new Status='Completed'
                        if (woStatusOld != woStatusNew && woStatusNew.equals('Completed')) {
                            //Case updateCase = new Case(Id =  eachWORecord.sigmaerpdev2__Case__c, Status = 'Service Completed');
                            //caseList.add(updateCase);
                            system.debug('Calling WorkOrderCompletionStatus Apex Class');
                            WorkOrderCompletionStatus.onWorkOrderComplete(listWorkOrders);
                            system.debug('Service Completed');
                        }
                    else if(woStatusOld != woStatusNew && woStatusNew.equals('Another Visit Needed')){
                        
                          WorkOrderCompletionStatus.onWorkOrderComplete(listWorkOrders);
                    }
                     else if(woStatusOld != woStatusNew && woStatusNew.equals('Invoiced to Customer')){
                        
                       //   WorkOrderCompletionStatus.onWorkOrderComplete(listWorkOrders);
                    }
                     
                        else if(currentWO.Work_Type__r.name=='Inspection' && woStatusNew.equals('Completed')){
                            //Case updateCase = new Case(Id =  eachWORecord.sigmaerpdev2__Case__c, Status = 'ReOpen');
                            //caseList.add(updateCase);
                            system.debug('ReOpen');
                        }
                        else if(woRecordsOld.Customer_Availability_Date__c != listWorkOrders[0].Customer_Availability_Date__c && woRecordsOld.AssignTo__c!=null){
                            system.debug('Calling DeleteWOAOnDateUpdate Apex Class');
                            DeleteWOAOnDateUpdate.deleteWOAOnChangeOfPreferredDateTime(listWorkOrders);
                            
                        }
                    //}// for
                    
                }
            }// end if
            
        }
        
        if(Trigger.isUpdate && Trigger.isBefore){
            System.Debug('ISUpdate isBefore - ');
            if(AvoidRecurrsion.isRecurssive()){
                List<Work_Order__c> listWorkOrders = new List<Work_Order__c>();
                for (Work_Order__c Wo : Trigger.new) {
                    // Access the "old" record by its ID in Trigger.oldMap
                    Work_Order__c oldWo = Trigger.oldMap.get(Wo.Id);
                    System.debug('oldWo - '+oldWo);
                    if (!Schema.sObjectType.Work_Order__c.fields.Status__c.isUpdateable()){
                        system.debug('No Update access on Work Order\'s Status field');
                        return;
                    }
                    
                    if (trigger.oldMap.get(Wo.Id).AssignTo__c != Wo.AssignTo__c && Wo.AssignTo__c != Null )
                    {
                        System.debug('Inside First IF condition');
                        // if(Wo.sigmaerpdev2__AssignTo__c!='' && Wo.sigmaerpdev2__AssignTo__c!=Null){
                        Wo.OwnerId = Wo.AssignTo__c;
                        //}
                        Wo.Status__c = 'Assigned';
                    }else if (Wo.AssignTo__c == Null && Wo.AssignTo__c ==''){
                        System.debug('Inside Else If condition');
                        Wo.OwnerId = oldWo.OwnerId;
                        Wo.Status__c = 'Assigned';
                    }
                    if(Trigger.isInsert == false){
                        //This below piece of code should work only when there is a transition in WorkOrder's Status 
                        //From "In Progress" to "Completed".
                        
                        system.debug('Old WorkOrder - '+oldWo.Id);
                        system.debug('Old WorkOrder - '+Wo.Id);
                        //system.debug('Old WorkOrder - '+oldWo.sigmaerpdev2__Status__c);
                        system.debug('New WorkOrder - '+Wo.Status__c);
                        if(oldWo.Status__c == 'In Progress' && Wo.Status__c == 'Completed'){
                            system.debug('Inside In Progress IF CONDITION....');
                            if(oldWo.Another_Visit_Needed__c == true && oldWo.Reason_for_another_Visit__c == null){
                                system.debug('Reason for another visit - Picklist not selected....');
                                Wo.addError('Please select a value in the field "Reason for another Visit".');
                            }
                            else if(oldWo.Another_Visit_Needed__c == true && oldWo.Reason_for_another_Visit__c != null){
                                system.debug('creating a work order.');
                                
                                workOrderFields = new String [] {'Name','sigmaerpdev2__Customer_Availability_Date__c','sigmaerpdev2__Case_Subject_text__c','sigmaerpdev2__Status__c','sigmaerpdev2__AssignTo__c','sigmaerpdev2__Case_Description__c','sigmaerpdev2__Customer_Contact__c','sigmaerpdev2__Local_Contact__c','sigmaerpdev2__Territory__c','Product__c','sigmaerpdev2__Account__c'};
                                    
                                    // Obtaining the field name/token map for the WorkOrder object
                                    workOrderMap = Schema.SObjectType.Work_Order__c.fields.getMap();
                                for (String fieldToCheck : workOrderFields) {
                                    // Check if the user has create access on the each field
                                    if (!workOrderMap.get(fieldToCheck).getDescribe().isCreateable()) {
                                        system.debug('Has no Create access on WorkOrder Fields');
                                        return;
                                    }
                                }
                                
                                Work_Order__c newWorkOrder = new Work_Order__c();
                                newWorkOrder.Case_Subject_text__c = 'Revisit: '+oldWo.Case_Subject_text__c;
                                newWorkOrder.Account__c = oldWo.Account__c;
                                newWorkOrder.FFP_MR_Contact__c = oldWo.FFP_MR_Contact__c;
                                newWorkOrder.Product__c= oldWo.Product__c;
                                newWorkOrder.Territory__c = oldWo.Territory__c;
                                newWorkOrder.Local_Contact__c = oldWo.Local_Contact__c;
                                newWorkOrder.Customer_Contact__c = oldWo.Customer_Contact__c;
                                newWorkOrder.Case_Description__c = oldWo.Case_Description__c;
                                newWorkOrder.Status__c = 'Draft';
                                newWorkOrder.Parent_Work_Order__c = oldWo.Id;
                                if(oldWo.Next_Visit_Date_Time__c != null){
                                    newWorkOrder.Customer_Availability_Date__c = oldWo.Next_Visit_Date_Time__c;
                                }
                                listWorkOrders.add(newWorkOrder);
                            }
                        }
                    }
                    
                }
                if(listWorkOrders!=null && listWorkOrders.size()>0){
                    insert listWorkOrders;
                    system.debug('New WorkOrder successfully inserted');
                }
            }
            else{
                System.debug('Avoid Recusrion else');
            }
        }
        
        if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert)){
            if(AvoidRecurrsion.isRecurssiveAUI()){
                List<Work_Order__c> listWorkOrders = Trigger.New;
                Work_Order__c oldWo = new Work_Order__c();
                if(Trigger.isUpdate){
                    oldWo = Trigger.oldMap.get(listWorkOrders[0].Id);
                }
                //system.debug('oldWo - '+oldWo.sigmaerpdev2__Work_Type__c);
                system.debug('Work Order Status - '+listWorkOrders[0].Status__c);
                system.debug('Work Order Work Type - '+listWorkOrders[0].Work_Type__c);
                if(listWorkOrders[0].Status__c == 'Draft' && listWorkOrders[0].Work_Type__c!=null && Trigger.isInsert){
                    system.debug('Creating Work Order Lines - Calling InventoryModule Apex class');
                    Inventorymodule.workorderInventoryCheck(listWorkOrders);
                }
                else if(listWorkOrders[0].Status__c == 'Draft' && listWorkOrders[0].Work_Type__c!=null &&(listWorkOrders[0].Work_Type__c != oldWo.Work_Type__c)){
                    system.debug('Creating Work Order Lines during update - Calling InventoryModule Apex class');
                    Inventorymodule.workorderInventoryCheck(listWorkOrders);
                }
                else{
                    system.debug('Not calling InventoryModule Apex class');
                }
            }
        }
           /*  if(Trigger.isUpdate && Trigger.isBefore){


sigmaerpdev2__Work_Order__c workOrder = [SELECT Id, Name, sigmaerpdev2__Customer_Availability_Date__c FROM sigmaerpdev2__Work_Order__c where Id IN :Trigger.New limit 1];
Map<Id,sigmaerpdev2__Work_Order__c> workOrderOldMap = Trigger.oldMap;
Map<Id,sigmaerpdev2__Work_Order__c> workOrderNewMap = Trigger.NewMap;
system.debug('WorkOrderOldMap -'+workOrderNewMap);
system.debug('WorkOrderNewMap -'+workOrderNewMap);

sigmaerpdev2__Work_Order__c oldWorkOrder =  workOrderOldMap.get(workOrder.Id);
sigmaerpdev2__Work_Order__c neWworkOrder =  workOrderNewMap.get(workOrder.Id);

if(newWorkOrder.sigmaerpdev2__Customer_Availability_Date__c < DateTime.Now()){
newWorkOrder.addError('Preferred Service Date/Time should be greater than Current DateTime');
}
else{
system.debug('Preferred DateTime is greater than current DateTime');
}


}*/
system.debug('First Trigger Success');
    }
    catch(Exception e){
        system.debug('Exception -'+e);
        system.debug('Exception at -'+e.getLineNumber());
    }// end if
    
}// end trigger