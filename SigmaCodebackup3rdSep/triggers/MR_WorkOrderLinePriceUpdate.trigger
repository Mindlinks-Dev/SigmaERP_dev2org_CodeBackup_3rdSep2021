trigger MR_WorkOrderLinePriceUpdate on Work_Oder_Lines__c (before insert, before update) {
    
    /*pricebook2 pb = [select Id from pricebook2 where IsStandard = TRUE][0];
Id stPrId = pb.Id;

Work_Oder_Lines__c[] wrlObj = Trigger.New;
pricebookentry pbe=[select Product2Id,UnitPrice from pricebookentry where pricebook2Id = :stPrId and product2Id = :wrlObj[0].Product__c];
wrlObj[0].Price__c= pbe.UnitPrice;*/
   
    if (!Schema.sObjectType.Product2.fields.Name.isAccessible()){
        system.debug('Has no access to PriceBook Product2 Field');
    }
    if (!Schema.sObjectType.Product2.fields.sigmaerpdev2__Product_Price__c.isAccessible()){
        system.debug('Has no access to PriceBook UnitPrice Field');
    }
    
   
        Integer i =0;
      
      
        for(Work_Oder_Lines__c wrlObj : Trigger.New ){
      
            for(Product2 pbe : [select Id,Name,sigmaerpdev2__Product_Price__c from Product2 where id=:wrlObj.Product__c] ){
         
                system.debug('pricebookentry - '+pbe);
                wrlObj.Price__c= pbe.sigmaerpdev2__Product_Price__c;
                system.debug('wrlObj.Price__c - '+wrlObj.Price__c);
                i++;
          
            }   
        
    }
    
    
    if(Trigger.isUpdate && Trigger.isBefore){
        try{
            // Work_Oder_Lines__c Fields that will be accessed.
            String [] WOLFields = new String [] {'sigmaerpdev2__Quote__c','Name','sigmaerpdev2__Product__c','sigmaerpdev2__Used1__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Work_Order_Line_Item_Number__c','sigmaerpdev2__Work_Order__c'};
                
                // Obtaining the field name/token map for the Work_Oder_Lines__c object
                Map<String,Schema.SObjectField> mWOLI = Schema.SObjectType.Work_Oder_Lines__c.fields.getMap();
            for (String fieldToCheck : WOLFields) {
                // Check if the user has create access on the each field
                if (!mWOLI.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on Work_Oder_Lines__c Fields');
                    return;
                }
            }
            
            // WorkOrder Fields that will be accessed.
            String [] workOrderFields = new String [] {'sigmaerpdev2__Status__c'};
                
                // Obtaining the field name/token map for the WorkOrder object
                Map<String,Schema.SObjectField> workOrderMap = Schema.SObjectType.Work_Order__c.fields.getMap();
            for (String fieldToCheck : workOrderFields) {
                // Check if the user has create access on the each field
                if (!workOrderMap.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on WorkOrder Fields');
                    return;
                }
            }
            Work_Oder_Lines__c workOrderLine = [select Id,Work_Order__c from Work_Oder_Lines__c where Id in: Trigger.New AND Work_Order__c!=null limit 1];
            system.debug('Work Order Lines - '+workOrderLine);
            
            List<Work_Order__c> listWorkOrders = [Select Id,Status__c  from Work_Order__c where Id=:workOrderLine.Work_Order__c];
            system.debug('listWorkOrders - '+listWorkOrders);
            
            //Map<Id,Work_Oder_Lines__c> newWorkOrderLineMap = Trigger.NewMap;
            List<Work_Oder_Lines__c> newWorkOrderLine = Trigger.New;
            
            //Looping through list of WorkOrders along with displaying appropriate Messages based on the Work Order's status field.
            for(Work_Order__c eachWO : listWorkOrders){
                if(eachWO.Status__c == 'Accepted'){
                    newWorkOrderLine[0].addError('Cannot edit as you have not yet Checked-In.');
                }
                else if(eachWO.Status__c == 'Assigned'){
                    newWorkOrderLine[0].addError('Cannot edit as you have not yet Checked-In.');
                }
                else if(eachWO.Status__c == 'Completed'){
                    newWorkOrderLine[0].addError('Work Order has been Completed.');
                }
                else if(eachWO.Status__c == 'Rejected'){
                    newWorkOrderLine[0].addError('Work Order has been Rejected.');
                }
                else if(eachWO.Status__c == 'Invoiced to Customer'){
                    newWorkOrderLine[0].addError('Work Order has been Completed.');
                }
            }
        }
        catch(Exception e){
            system.debug('Exception Occured at line - '+e.getLineNumber());
            system.debug('Exception Occured - '+e.getMessage());
        }
    }
    
}