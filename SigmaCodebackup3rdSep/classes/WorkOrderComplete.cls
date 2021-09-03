public with sharing class WorkOrderComplete {
 
    /*************************************************************************************************************************/
     @AuraEnabled
    public static String WorkOrderCompleteNew(string workOrderId,Boolean IsAndroid){
        system.Debug('Hello - '+workOrderId);
        List<Work_Order__c> workOrder = [SELECT Id, Work_Type__c,Territory__c,Customer_Availability_Date__c,Status__c,Another_Visit_Needed__c,Reason_for_another_Visit__c,Case_Subject_text__c,Account__c,FFP_MR_Contact__c,Product__c,Next_Visit_Date_Time__c  FROM Work_Order__c where Id =:workOrderId];
        
       
        
            List<Work_Order__c> listWorkOrders = new List<Work_Order__c>();
            for (Work_Order__c Wo : workOrder) {
                
                //This below piece of code should work only when there is a transition in WorkOrder's Status 
                //From "In Progress" to "Completed".
                system.debug('WorkOrder - '+Wo.Status__c);
                
                /*if(Wo.Status__c == 'In Progress'){
                    system.debug('Inside In Progress IF CONDITION....');
                    if(Wo.Another_Visit_Needed__c == true && Wo.Reason_for_another_Visit__c == null){
                        system.debug('Reason for another visit - Picklist not selected....');
                        return 'Reason for another visit empty';
                    } 
                }*/
            }
           
         Work_Order__c wo ;
       //  boolean IsAndroid ;
         string result = 'success';
        System.debug('Work_Order__c Id-->'+workOrderId);
        System.debug('IsAndroid -->'+IsAndroid);
        Savepoint sp = Database.setSavepoint(); 
        try{
            if (Schema.sObjectType.Work_Order__c.isAccessible()) {
                wo= [SELECT Id,Status__c,Another_Visit_Needed__c,Next_Visit_Date_Time__c,NonAndroidDevicesCheck__c FROM Work_Order__c
                          WHERE Id =:workOrderId limit 1];
                 System.debug('wo>>>>>>>>'+wo);
            }else{
                system.debug('Has no Access on WorkOrder' );
            }
            
            System.debug('IsAndroid  : '+IsAndroid);
            if(IsAndroid){
                wo.NonAndroidDevicesCheck__c = False;
            }else {
                wo.NonAndroidDevicesCheck__c = True;
            }
            if(wo != null){ 
                if(!Work_Order__c.sObjectType.getDescribe().isUpdateable()){                    
                    System.debug('Insufficient access to Update Event Record access');
                }else{
                    
                     if(wo.Another_Visit_Needed__c==true){
                        system.debug('inside if>>>>>>');
                     if(Schema.sObjectType.Work_Order__c.fields.Status__c.isUpdateable()){
                          system.debug('inside if1>>>>>>');
                       wo.Status__c= 'Another Visit Needed';
                       wo.Customer_Availability_Date__c=wo.Next_Visit_Date_Time__c;
                         
                       //wo.RecordType  =  [select Id from RecordType where Name = 'Another Visit Needed' and SobjectType = 'Work_Order__c'];
                   /* string RID3 = [Select Id From RecordType Where SobjectType = 'Work_Order__c' and Name = 'Another_Visit_Needed'].id;
                     wo.RecordTypeId=RID3;
                     wo.RecordTypeId= Schema.SObjectType.Work_Order__c.getRecordTypeInfosByName().get('Another Visit Needed').getRecordTypeId();*/
                    String gsRecordTypeID = Schema.SObjectType.Work_Order__c.getRecordTypeInfosByName().get('Another Visit Needed').getRecordTypeId();
                      wo.RecordTypeId=gsRecordTypeID;
                     }
                    }
                    else{
                         if(Schema.sObjectType.Work_Order__c.fields.Status__c.isUpdateable()){
                        wo.Status__c= 'Completed';
                         }
                         }
                   /* if(Schema.sObjectType.Work_Order__c.fields.Status__c.isUpdateable()){
                        
                       
                    }
                   
                    else if{
                        System.debug('Insufficient access to Update Status__c field access');
                    }*/
                    if(Schema.sObjectType.Work_Order__c.isUpdateable()){
                        //update wo;
                        performDML(JSON.serialize(wo), 'True');
                    }else{
                        System.debug('Insufficient access to Update Work_Order__c Record access');
                    }
                    
                }
            }else{
                System.debug('Insufficient access to Update Work_Order__c Record access');
            }
        }
        catch(Exception e){
            system.debug('exception'+e);
            Database.rollback(sp);}
            
            Work_Order__c srecord = new Work_Order__c();
            
        
            srecord = [Select Id,Name,sigmaerpdev2__Is_Payment_Made__c,sigmaerpdev2__Account__c,sigmaerpdev2__Account__r.Name,Account__r.Customer_Type__c,Tax__c,Tax_Amount__c,Service_Contract__c,Service_Contract__r.Contract_End_Date__c,
                       sigmaerpdev2__Account__r.AccountNumber,sigmaerpdev2__Work_Type__c,Service_Warrenty_End_date__c,sigmaerpdev2__TotalAmount__c,sigmaerpdev2__Paid_Amount__c,Customer_Availability_Date__c,Account__r.Email__c,
                       sigmaerpdev2__Work_Type__r.sigmaerpdev2__Service_Charge__c ,Sigma_orders__r.Total_Price__c,sigmaerpdev2__FFP_MR_Contact__c,Status__c,Break_time_In_Minutes__c,
                       sigmaerpdev2__Due_Amount__c,Net_Amount__c FROM sigmaerpdev2__Work_Order__c where id=:workOrderId]; 

              Datetime dT=srecord.Customer_Availability_Date__c;
             Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
            
            if((srecord.Service_Warrenty_End_date__c!=null) || (srecord.Service_Contract__c!=null)){
             
            system.debug('myDate - '+myDate);
            if((myDate<=srecord.Service_Warrenty_End_date__c) || (myDate<=srecord.Service_Contract__r.Contract_End_Date__c)){
            srecord.sigmaerpdev2__Work_Type__r.sigmaerpdev2__Service_Charge__c=0;
            }
            }
            Decimal scharge=0;
            if(srecord.sigmaerpdev2__Work_Type__r.sigmaerpdev2__Service_Charge__c!=null){
            scharge=srecord.sigmaerpdev2__Work_Type__r.sigmaerpdev2__Service_Charge__c;
            }
        if(srecord.sigmaerpdev2__TotalAmount__c==null){
            srecord.sigmaerpdev2__TotalAmount__c=0;
            
        }
        String W0Name=srecord.Name;
        
        List<sigmaerpdev2__Work_Oder_Lines__c> sorecord;
        set<Id> prod=new set<Id>();
       sorecord=[Select Id,sigmaerpdev2__Product__c,Work_Order__r.Status__c,Work_Order__r.Product_Warranty_End_date__c,sigmaerpdev2__Discount__c,sigmaerpdev2__Quote__c,sigmaerpdev2__Quantity__c,sigmaerpdev2__Price__c,sigmaerpdev2__Value__c,
         sigmaerpdev2__Warranty__c,sigmaerpdev2__Description__c,sigmaerpdev2__Cost__c,sigmaerpdev2__Product__r.Name FROM sigmaerpdev2__Work_Oder_Lines__c where sigmaerpdev2__Work_Order__c=:workOrderId AND sigmaerpdev2__quote__c = false AND (sigmaerpdev2__Used1__c = true OR sigmaerpdev2__Warranty__c = true) ];
        
        system.debug('sorecord>>>>>>'+sorecord);
        
            Decimal TotalAmount;
            Decimal amnt;
            Decimal amt;
            Decimal cnt=0;
            Decimal cn=0;
            Decimal tamount=0;
            
     for(sigmaerpdev2__Work_Oder_Lines__c wol: sorecord) {
        prod.add(wol.sigmaerpdev2__Product__c);
        }
         
         
        List<PricebookEntry> prce =[Select Product2Id,UnitPrice From PricebookEntry WHERE PriceBook2.Name = 'Standard Price Book' and Product2.Id =:prod];
        Decimal unitprice=0;
        Map<Id,Decimal> uprice = new Map<Id,Decimal>();
        for(PricebookEntry pbe: prce) {
          unitprice=pbe.UnitPrice;
            uprice.put(pbe.Product2Id,UnitPrice);
          }
         for(sigmaerpdev2__Work_Oder_Lines__c wol: sorecord) {
         

             amt=uprice.get(wol.sigmaerpdev2__Product__c)*wol.sigmaerpdev2__Quantity__c;
        system.debug('amt #154'+amt);
            
            
                 
             Service_Quote__c[] sq = [select id,Name,Work_Order__c from Service_Quote__c where Work_Order__c=:workOrderId];
                 system.debug('sq'+sq);
                 
            
            if (!sq.isEmpty()) {
                List<Sigma_Order__c> so=new List<Sigma_Order__c>([Select id,name,sigmaerpdev2__Paid_Amount__c,sigmaerpdev2__Is_Payment_Made__c,Orders_Status__c,sigmaerpdev2__Service_Quote__c,(select id,Name,sigmaerpdev2__Product__c from sigmaerpdev2__Order_Lines__r) from sigmaerpdev2__Sigma_Order__c where Service_Quote__c =:sq]);
             system.debug('so'+so);
            
                if(so.size()>0){
             if(so[0].Orders_Status__c=='Order Confirmed'){
                 for(Sigma_Order__c s:so){
                     for(Product_Order_Price_Book__c ol:s.sigmaerpdev2__Order_Lines__r){
                         if(ol.Product__c==wol.sigmaerpdev2__Product__c){
                           amt=0;  
                         }
                     }
                     
                 }
                 
                 
             }
                    }
            } 
             
             system.debug('amt #169'+amt);
         amnt=amt;
         wol.sigmaerpdev2__Price__c=amt;
             system.debug('amt1>>'+amt);
        cn=cn+amt;
        system.debug('myDate>>'+myDate);
        if((myDate<=wol.Work_Order__r.Product_Warranty_End_date__c) || (myDate<=wol.Work_Order__r.Product_Warranty_End_date__c)){
        
                wol.sigmaerpdev2__Warranty__c=true;
                
        }
               system.debug('wol.sigmaerpdev2__Warranty__c>>'+wol.sigmaerpdev2__Warranty__c);
               if(wol.sigmaerpdev2__Warranty__c==true){
                    system.debug('inside if>>');
                    cnt=cnt+amt;
                   
                }
            
         
    
         }
        
        
            
            amnt=cn-cnt;
            system.debug('amt1111>>'+amnt);
            tamount=scharge+amnt;
            srecord.Net_Amount__c=tamount;
            system.debug('srecord.Net_Amount__c::::'+srecord.Net_Amount__c);
            
            Double TaxOnBillAmount = 0;
            List<Tax__c> taxObj = WoPayment.getTax(srecord.Account__c);
                Double federalTax = Double.valueOf(taxObj.get(0).Tax_Amount__c);
                String fedTaxType = String.valueOf(taxObj.get(0).Type__c);
                Double stateTax = Double.valueOf(taxObj.get(1).Tax_Amount__c);
                String stateTaxType = String.valueOf(taxObj.get(1).Type__c);
                
                if(fedTaxType == 'Percentage'){
                    TaxOnBillAmount = (tamount* federalTax)/100;
                }else{
                    TaxOnBillAmount = tamount + federalTax;
                }               
                if(stateTaxType == 'Percentage'){
                    TaxOnBillAmount = (TaxOnBillAmount + (tamount * stateTax)/100);
                }else{
                    TaxOnBillAmount = (TaxOnBillAmount + (tamount + stateTax));
                }        
                srecord.Tax_Amount__c = TaxOnBillAmount;
                srecord.Tax__c = federalTax+stateTax;
            system.debug('TaxOnBillAmount::'+TaxOnBillAmount);
            TotalAmount=tamount+TaxOnBillAmount;
            
            system.debug('TotalAmount::'+TotalAmount);
            srecord.sigmaerpdev2__TotalAmount__c=TotalAmount;
        update srecord;
        system.debug('srecord::'+srecord);
        
         Site_Visits__c  sites=[select Work_Order__c from Site_Visits__c where Work_Order__c=:srecord.id order by CreatedDate DESC limit 1];
                sites.Break_Time_In_minutes__c=srecord.Break_time_In_Minutes__c;
        update sites;
        
                    Invoice__c invoiceW = new Invoice__c();
                    invoiceW.Work_Order__c = srecord.id; 
                    invoiceW.Invoice_Type__c='Work order Invoice';
                    invoiceW.Total_Amounts__c=srecord.TotalAmount__c;
                    //invoiceW.sigmaerpdev2__Customer__c= srecord.sigmaerpdev2__Account__r.id;
                    invoiceW.Invoice_Status__c='Unpaid';
                    
                    system.debug('invoiceW>>>>'+invoiceW);
                    insert invoiceW;
                    system.debug('invoiceW 253>>>>'+invoiceW);
        decimal totalorderamount =0;
        Work_Order__c workOrderRecord;
      workOrderRecord=[select Id,Name,Account__c,Account__r.Name,Account__r.Customer_Type__c,Account__r.AccountNumber,Status__c,Case_Subject_text__c,Case_Description__c,Is_Credit_Updated__c from Work_Order__c where Id = :workOrderId];
      
        if(workOrderRecord.Account__r.Customer_Type__c=='Credit Customer'){
            
            if(workOrderRecord.Is_Credit_Updated__c == false){
             workOrderRecord.Is_Credit_Updated__c =true;
            
            }
            totalorderamount += TotalAmount;
        system.debug('totalorderamount@@'+totalorderamount);
        
        Dimension_Tag__c dimTag;
                        try{
                            dimTag=[select id,Ordered_Amount__c,Account__c from Dimension_Tag__c where Account__c=:workOrderRecord.Account__c limit 1];
                        }
                        catch(Exception e){
                            
                        }
                       
                        if(dimTag!=null){
                            if(dimTag.Ordered_Amount__c==null)
                                dimTag.Ordered_Amount__c=0;
                            if(totalorderamount>0){
                                dimTag.Ordered_Amount__c+=totalorderamount;
                            update dimTag;
                            System.debug('dimTag::'+dimTag);
                            TransactionHistory.creditHistoryWO(dimTag,TotalAmount,W0Name);
                       }
                        }
                      
                
                        
        update workOrderRecord;
        }
         Site_Visits__c site;
                 site=[select Work_Order__c from Site_Visits__c where Work_Order__c=:workOrderId order by createdDate DESC limit 1];
                       
                         Sigma_Order__c so=new Sigma_Order__c();
                    so.Site_Visits__c=site.id;
                    so.Accountid__c=srecord.Account__c;
                    so.Customer_Type__c=srecord.Account__r.Customer_Type__c;
        			so.sigmaerpdev2__Customer_Email__c=srecord.Account__r.Email__c;
                    so.Order_Created_Via__c = 'Work Order';
                     so.BillingPersonNew__c=srecord.FFP_MR_Contact__c;
                        so.Delivary_Date__c=System.today();
                        so.Orders_Status__c= 'Delivered';
                        so.Net_Amount__c=srecord.Net_Amount__c;
                        so.TotalAmount__c=srecord.TotalAmount__c;
                        so.Tax__c=srecord.Tax__c;
                     insert so;
        
        Decimal amts;
         for(sigmaerpdev2__Work_Oder_Lines__c woli: sorecord) {
         
             amts=uprice.get(woli.sigmaerpdev2__Product__c);
                system.debug('amt>>>>'+amts);
            }
        
         Invoice__c invoice1 = new Invoice__c();
                    List<Invoice_Item__c>Invoiceitem = new List<Invoice_Item__c>();
                    invoice1.SO__c = so.id; 
                    invoice1.Invoice_Type__c='Work order Invoice';
                    invoice1.Total_Amounts__c=so.TotalAmount__c;
                    invoice1.Customer__c =so.AccountId__c; 
                    invoice1.Invoice_Status__c='Unpaid';
                   system.debug('invoice1>>>>'+invoice1);
                    insert invoice1;
        		system.debug('invoice1 323>>>>'+invoice1);
                    for(sigmaerpdev2__Work_Oder_Lines__c woline:sorecord)
                {
                    Product_Order_Price_Book__c popb1=new Product_Order_Price_Book__c();
                         popb1.Sigma_Order__c=so.id;
                         popb1.Product__c=woline.Product__c;
                         popb1.Net_Quantity__c=woline.Quantity__c;
                         popb1.Quantity__c=woline.Quantity__c;
                         popb1.Inventory_Status__c='Reserve';
                         popb1.Order_Status__c='Delivered';
                         popb1.Delivary_Date__c=system.today();
                         popb1.Total_Amount__c=uprice.get(woline.sigmaerpdev2__Product__c);
                     system.debug('334'+uprice.get(woline.sigmaerpdev2__Product__c));
                       popb1.Total_Price__c=uprice.get(woline.sigmaerpdev2__Product__c)*woline.Quantity__c;
                  
                         insert popb1;
                    system.debug('popb1'+popb1);
                    
                   Invoice_Item__c invoicedata = new Invoice_Item__c();
                        invoicedata.Invoice_Number__c=invoice1.id;
                        invoicedata.SOI__c=popb1.id;
                        invoicedata.Quantity__c = popb1.Net_Quantity__c;
                        invoicedata.Total_Amount__c=popb1.Total_Price__c;
                        invoicedata.Product__c=popb1.Product__c;
                        invoicedata.Net_Amount__c = popb1.Total_Amount__c*popb1.Net_Quantity__c;
                        if(popb1.Discounts__c!=null && popb1.Discounts__c>0)
                            invoicedata.Discount__c = popb1.Discounts__c;
        insert invoicedata;
                    
                }
                
               
        
         				
        
        Set<Id>ProId = new Set<Id>();
        Map<Id,Decimal>produration = new Map<Id,Decimal>();
                Map<Id,string>prointerval = new Map<Id,string>();
        Map<Id,Decimal>serviceduration = new Map<Id,Decimal>();
                Map<Id,string>serviceinterval = new Map<Id,string>();
        Decimal days;
        Decimal totaldays;
        Decimal servicedays;
        Decimal servicetotaldays;
        
         List<Product_Order_Price_Book__c> OrderShippedQtyToUpdatedelivered = new List<Product_Order_Price_Book__c>();  
                    List<Product_Order_Price_Book__c> Orderdelivered;
                    Orderdelivered =[Select id,name,Sigma_Order__c,Product__r.Id,Quantity__c,Net_Quantity__c ,Order_Status__c from Product_Order_Price_Book__c where Sigma_Order__r.id =:so.id];
          for(Product_Order_Price_Book__c orditem :Orderdelivered)
           {
             ProId.add(orditem.Product__r.Id);
           }
         List<Product2> productlist = [Select id,name,Warranty_Applicable__c,Warranty_Duration__c,Warranty_Interval__c,Service_Warranty_Applicable__c,Service_Warranty_Duration__c,Service_Warranty_Interval__c from Product2 where id=:ProId];
                    for(Product2 pro:productlist)
          {
            if(pro.Warranty_Applicable__c)
            {
              produration.put(pro.id,pro.Warranty_Duration__c);
              prointerval.put(pro.id,pro.Warranty_Interval__c);
            }
            if(pro.Service_Warranty_Applicable__c)
            {
              serviceduration.put(pro.id,pro.Service_Warranty_Duration__c);
              serviceinterval.put(pro.id,pro.Service_Warranty_Interval__c);
            }
            
          } 
        
           for(Product_Order_Price_Book__c ordtoupdate : Orderdelivered)
                    {                        
                        Product_Order_Price_Book__c newordtoupdate = new Product_Order_Price_Book__c();
            newordtoupdate.Delivary_Date__c =  date.today();
            if(produration.containsKey(ordtoupdate.Product__r.Id) && prointerval.containsKey(ordtoupdate.Product__r.Id))
            {
              newordtoupdate.Product_Warranty_Start_Date__c = newordtoupdate.Delivary_Date__c; 
              newordtoupdate.Product_Duration__c = produration.get(ordtoupdate.Product__r.Id);
              newordtoupdate.Product_Interval__c = prointerval.get(ordtoupdate.Product__r.Id);
            if(newordtoupdate.Product_Interval__c =='Day')
                        {
                            days = 1;
                            totaldays = newordtoupdate.Product_Duration__c * days;    
                        }
                         
                        else if(newordtoupdate.Product_Interval__c == 'Month')
                        {
                        days = 30;
                        totaldays = newordtoupdate.Product_Duration__c * days;
                        }
                        else if(newordtoupdate.Product_Interval__c == 'Year')
                        {
                        days = 365;
                        totaldays = newordtoupdate.Product_Duration__c * days;
                        }
                        Date enddate = newordtoupdate.Product_Warranty_Start_Date__c + Integer.valueOf(totaldays);
                        //enddate.setDate(enddate.getDate() + totaldays);
                        newordtoupdate.Product_Warranty_End_Date__c = enddate;
            newordtoupdate.Warranty_Created__c =true;
            }
            
            if(serviceduration.containsKey(ordtoupdate.Product__r.Id) && serviceinterval.containsKey(ordtoupdate.Product__r.Id))
            {
              newordtoupdate.Service_Start_Date__c = newordtoupdate.Delivary_Date__c; 
              newordtoupdate.Service_Duration__c = serviceduration.get(ordtoupdate.Product__r.Id);
              newordtoupdate.Service_Intervals__c = serviceinterval.get(ordtoupdate.Product__r.Id);
            if(newordtoupdate.Service_Intervals__c =='Day')
                        {
                            servicedays = 1;
                            servicetotaldays = newordtoupdate.Service_Duration__c * servicedays;    
                        }
                         
                        else if(newordtoupdate.Service_Intervals__c == 'Month')
                        {
                        servicedays = 30;
                        servicetotaldays = newordtoupdate.Service_Duration__c * servicedays;
                        }
                        else if(newordtoupdate.Service_Intervals__c == 'Year')
                        {
                        servicedays = 365;
                        servicetotaldays = newordtoupdate.Service_Duration__c * servicedays;
                        }
                        Date enddate = newordtoupdate.Service_Start_Date__c + Integer.valueOf(servicetotaldays);
                        //enddate.setDate(enddate.getDate() + totaldays);
                        newordtoupdate.Service_End_Date__c = enddate;
            newordtoupdate.Warranty_Created__c =true;
            }
            
            
            
                        newordtoupdate.Id = ordtoupdate.Id;
                        update newordtoupdate;
                        
                        
                    } 
        
        system.debug('SUCCESS');
        system.debug('Result Value - '+result);
        return result;
        
        
        
    }
    
    @auraEnabled
    public static String workOrderLineItemStatus(Id workOrderId){
        
        String [] workOrderLineItemFields = new String [] {'sigmaerpdev2__Quantity__c','sigmaerpdev2__Quote__c','sigmaerpdev2__Used1__c','sigmaerpdev2__Work_Order__c','sigmaerpdev2__Product__c'};
                
                // Obtaining the field name/token map for the WorkOrderLineItem object
                Map<String,Schema.SObjectField> workOrderLineItemMap = Schema.SObjectType.Work_Oder_Lines__c.fields.getMap();
            for (String fieldToCheck : workOrderLineItemFields) {
                // Check if the user has create access on the each field
                if (!workOrderLineItemMap.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on WorkOrderLineItem Fields');
                    return null;
                }
            }
        //Getting all the WOLI of the above WorkOrder.
        List<Work_Oder_Lines__c> workOrderLineItems=[SELECT Id, Quote__c ,Quantity__c,Used1__c,Work_Order__c, Product__c FROM Work_Oder_Lines__c where Work_Order__c = :workOrderId];
        
        for(Work_Oder_Lines__c eachWorkOrderLineItem: workOrderLineItems){
            System.debug('eachWorkOrderLineItem.Used__c'+eachWorkOrderLineItem.Used1__c);
            //WorkOrder should not be completed if the WOLI has not been used.
            if(eachWorkOrderLineItem.Used1__c == false && eachWorkOrderLineItem.Quote__c  == false){
                return 'failure';
            }
        }
        return 'success';
    }
    
    @future
    public static void performDML(String obj, String isUpdate) {
        if(isUpdate == 'True') {
            update (Work_Order__c) JSON.deserialize(obj, Work_Order__c.class);
            system.debug('isUpdate - '+isUpdate);
            system.debug('Update Completed');
        } 
    }
   
}