trigger ManageInventoryLocation on Stock_In_Product__c(after insert, after update,before delete) {
    
    List <Vendor_Evaluation__c> veToInsert = new List <Vendor_Evaluation__c>();
    List <Stock_In_Product__c> listOfsip = Trigger.new;
    list<Id>proIds = new List<Id>();
    list<Id>poIds = new List<Id>();
    list<Id>popIds = new List<Id>();
    list<Id>srIds = new List<Id>();
    list<Id>srlIds = new List<Id>();
    
    List<Stock_In_Product__c> StockIns = Trigger.New;
    List<Stock_In_Product__c> StockInsOld = Trigger.Old;
    Map<Id,Stock_In_Product__c> stockInMap = Trigger.newMap;
    Map<Id,Stock_In_Product__c> stockInMapOld = Trigger.oldMap;
    
    Integer count = 0;
    
    List<Stock_In_Product__c> LstStockIn = new List<Stock_In_Product__c>();
    if(Trigger.isdelete)
    {
        for(Stock_In_Product__c sip : trigger.old){
            if(sip.Status__c == 'Verified'){
                sip.adderror('record Cannot be deleted');
                System.debug('Recordnotdeleted');
            }
        }
        Return;
    } 
    for(Stock_In_Product__c stockIn : StockIns){  
        if(Trigger.isUpdate)
        {       
            if((stockIn.Status__c == 'Verified')&&(StockInsOld[count].Status__c != 'Verified')){     
                LstStockIn.add(stockIn);        
            }
            count++;
        }
        else
        {
            if((stockIn.Status__c == 'Verified')){    
                LstStockIn.add(stockIn);        
            }           
        }        
    }
    
    TriggerHandler triggerHandler = new TriggerHandler();    
    triggerHandler.ManageInventoryLocation(LstStockIn,Trigger.isUpdate);                  
    
    try
    {
        //contents of merged trigger(Vendor_Evaluation_Trigger)
        if(Trigger.isAfter){
            if(Trigger.isInsert){
                for (Stock_In_Product__c sip :listOfsip) 
                {
                    proIds.add(sip.Product__c);
                    poIds.add(sip.Pur_Order__c);
                    popIds.add(sip.Purchase_Order__c);
                    srIds.add(sip.Stock_In__c);
                    srlIds.add(sip.id);
                }
                system.debug('srlIds>>'+srlIds);
                Stock_In__c sr=[select id,name,Vendor__c,Received_Date_Time__c from Stock_In__c where id=:srIds limit 1];
                List<Stock_In_Product__c> srlList=[select id,name,Remaining_Quantity__c,Quantity_Received__c,Vendor__c,Product__c ,Product__r.Name,Product__r.Product_Price__c,Purchase_Order__c,Stock_In__c,sigmaerpdev2__Pur_Order__c,Purchase_Order__r.Quantity__c,Purchase_Order__r.Buying_Price__c from Stock_In_Product__c where id IN:srlIds];
                system.debug('srlList>>'+srlList);
                
                
                Product2 pro=[select id,name,Product_Price__c from  Product2 where id=:proIds limit 1];
                Purchase_Order__c po=[select id,name,Expected_Date__c from  Purchase_Order__c where id=:poIds limit 1];
                
                Purchase_Order_Product__c pop=[select id,name,Total_Buying_Price__c,Quantity__c from  Purchase_Order_Product__c where id=:popIds limit 1];
                Vendor_Product__c vp= [select id,name,Buying_Price__c from Vendor_Product__c where Product_Name__c=:pro.id limit 1];
                
                for (Stock_In_Product__c sip :srlList) 
                {       
                    if(sip!=null)
                    {
                        Vendor_Evaluation__c ve=new Vendor_Evaluation__c();                       
                        ve.Stock_Recieving_Received_Quantity__c=sip.Quantity_Received__c;//adding recieved quantity from 
                        ve.Vendor_Name1__c=sr.Vendor__c;//adding vendor name from stock recieving  line item            
                        ve.Product__c= sip.Product__c;//adding product name from product            
                        ve.Product_Selling_Price__c= sip.Product__r.Product_Price__c;
                        ve.Product_Name__c= sip.Product__r.Name;            
                        ve.Purchase_Order__c=sip.Pur_Order__c;//adding product name from purchase order product
                        ve.PO_Expected_Date__c= po.Expected_Date__c;            
                        ve.Purchase_Order_Product__c=sip.Purchase_Order__c;//adding expected date from purchase order  
                        ve.Buying_Price__c= sip.Purchase_Order__r.Buying_Price__c; 
                        ve.Order_Quantity__c=Integer.valueOf(sip.Purchase_Order__r.Quantity__c);            
                        ve.Stock_Receiving__c=sip.Stock_In__c;//adding recieve date and time from stock recieving  
                        ve.Stock_Recieving_Received_Date__c=sr.Received_Date_Time__c;
                        ve.Stock_Receiving_Product__c=sip.id;            
                        veToInsert.add(ve);
                    }
                }
                if(veToInsert.size() > 0)
                    upsert veToInsert;  //inserting list of vendor evaluation records               
            }
        }
        //ends here
        
        Set<Id> ObjectIdSet = new Set<Id>();
        if(Trigger.isAfter && Trigger.isInsert)
        {
            for(Stock_In_Product__c  i:trigger.new)
            {            
                if(i.Status__c == 'Verified' && i.Product__c != null)
                {
                    ObjectIdSet.add(i.Id);
                }
            }
        }
        else if(Trigger.isUpdate)
        {
            for(Stock_In_Product__c  i:trigger.new)
            {
                for(Stock_In_Product__c  j:trigger.old)
                {
                    if( i.Id == j.Id && (i.Status__c == 'Verified' && j.Status__c != 'Verified') )
                    {
                        ObjectIdSet.add(i.Id);
                    }
                }
            }
        }
        
        if(ObjectIdSet.size() > 0)
        {
            if(!Test.isRunningTest()){
                LinkageServiceClass.createSLFromSRP(ObjectIdSet);
            }
        }
    }
    catch(Exception e)
    {
        System.debug('Exception in LinkerSRP:'+e);
        System.debug('Exception Line Num in LinkerSRP'+e.getLineNumber());
    }
    
    
    /*------------------------------------------code added on Reminder alert--------------------------------------------------------------*/
    
    Set<Id> purId = new Set<Id>();
    
    Integer RemaningQuantity;
    String statusSR;
    for(Stock_In_Product__c stocpro:Trigger.new)
    {
        //RemaningQuantity=(Integer)stocpro.sigmaerpdev2__Remaining_Quantity__c;
        statusSR = stocpro.Status__c;
        purId.add(stocpro.sigmaerpdev2__Pur_Order__c);
    }  
    
    System.debug('purId>>'+purId);
    List<sigmaerpdev2__Reminder_Queue__c> Remdata = [select id,sigmaerpdev2__Status__c,sigmaerpdev2__Purchase_Order__c from sigmaerpdev2__Reminder_Queue__c where sigmaerpdev2__Purchase_Order__c in:purId];
    System.debug('Remdata>>'+Remdata);  
    
    List<sigmaerpdev2__Purchase_Order__c> purchaseorder = [select id,(select id,sigmaerpdev2__Received_Quantity__c,sigmaerpdev2__Status__c from Purchase_Order_Products__r) from sigmaerpdev2__Purchase_Order__c where id in:purId];
    
    System.debug('purchaseorder>>'+purchaseorder);  
    String Status;
    for(sigmaerpdev2__Purchase_Order__c pur:purchaseorder){
        for(Purchase_Order_Product__c sta:pur.Purchase_Order_Products__r)
        {
            Status = (String)sta.sigmaerpdev2__Status__c;
            system.debug('sigmaerpdev2__Received_Quantity__c>>'+sta.sigmaerpdev2__Received_Quantity__c);
            RemaningQuantity=(Integer)sta.sigmaerpdev2__Received_Quantity__c;
        }
    }
    system.debug('RemaningQuantity>>'+RemaningQuantity);
    System.debug('Status>>'+Status);  
    List<sigmaerpdev2__Reminder_Queue__c> remqueue = new List<sigmaerpdev2__Reminder_Queue__c>();
    for(sigmaerpdev2__Reminder_Queue__c rem:Remdata){
        if(Trigger.isInsert)
        {
            if(Trigger.isAfter)
            {   
                if(statusSR == 'Verified' &&rem.sigmaerpdev2__Status__c == 'Pending' && purId.contains(rem.sigmaerpdev2__Purchase_Order__c))//RemaningQuantity == 0 && 
                {
                    sigmaerpdev2__Reminder_Queue__c reminder = new sigmaerpdev2__Reminder_Queue__c();
                    reminder.Id = rem.Id;
                    reminder.sigmaerpdev2__Status__c = 'Closed';
                    reminder.sigmaerpdev2__Purchase_Order__c = rem.sigmaerpdev2__Purchase_Order__c;
                    remqueue.add(reminder);
                }
            }
        }       
    }
    update remqueue;
    System.debug('remqueue>>'+remqueue);     
}