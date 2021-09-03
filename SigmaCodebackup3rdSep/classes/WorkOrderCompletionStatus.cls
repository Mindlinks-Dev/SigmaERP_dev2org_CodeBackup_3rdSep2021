public with sharing class WorkOrderCompletionStatus { 
    
    public static void onWorkOrderComplete(List<sigmaerpdev2__Work_Order__c> workorderId){
        try{
            System.debug('*********** WorkOrderCompletionStatus **************');
            // Work_Oder_Lines__c Fields that will be accessed.
            String [] WOLFields = new String [] {'sigmaerpdev2__Quote__c','Name','sigmaerpdev2__Product__c','sigmaerpdev2__Used1__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Work_Order_Line_Item_Number__c','sigmaerpdev2__Work_Order__c'};
                
                // Obtaining the field name/token map for the Work_Oder_Lines__c object
                Map<String,Schema.SObjectField> mWOLI = Schema.SObjectType.sigmaerpdev2__Work_Oder_Lines__c.fields.getMap();
            for (String fieldToCheck : WOLFields) {
                // Check if the user has create access on the each field
                if (!mWOLI.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on Work_Oder_Lines__c Fields');
                    return;
                }
            }
            List<sigmaerpdev2__Product_Stock__c> updatedProductStock = new List<sigmaerpdev2__Product_Stock__c>();
            List<sigmaerpdev2__Work_Oder_Lines__c> workOrderLines = [SELECT Id, Name, sigmaerpdev2__Product__c,sigmaerpdev2__Quote__c, sigmaerpdev2__Used1__c,sigmaerpdev2__Quantity__c, sigmaerpdev2__Work_Order_Line_Item_Number__c FROM sigmaerpdev2__Work_Oder_Lines__c where sigmaerpdev2__Work_Order__c =:workorderId[0].Id ];
            List<sigmaerpdev2__Work_Oder_Lines__c> workOrderLinesDel = new List<sigmaerpdev2__Work_Oder_Lines__c>();
            List<sigmaerpdev2__Work_Oder_Lines__c> workOrderLinesUpdt = new List<sigmaerpdev2__Work_Oder_Lines__c>();
            List<sigmaerpdev2__Work_Oder_Lines__c> allQuoteWOLS=new List<sigmaerpdev2__Work_Oder_Lines__c>();
            system.debug('WorkOrderLine -'+workOrderLines);
             Set<id> Prod= new Set<id>();
            
            Integer i = 0;  
            for(sigmaerpdev2__Work_Oder_Lines__c eachWorkOrderLineItem: workOrderLines){
                if(eachWorkOrderLineItem.sigmaerpdev2__Used1__c==true){
                    workOrderLinesUpdt.add(eachWorkOrderLineItem);
                }
                else if(eachWorkOrderLineItem.sigmaerpdev2__Used1__c==false && eachWorkOrderLineItem.sigmaerpdev2__Quote__c==false ){
                    workOrderLinesDel.add(eachWorkOrderLineItem);
                }
                if(eachWorkOrderLineItem.sigmaerpdev2__Quote__c==true){
                    allQuoteWOLS.add(eachWorkOrderLineItem);
                }
                                
            Prod.add(eachWorkOrderLineItem.Product__c);
            
            }
            system.debug('Used Line Items - '+workOrderLinesUpdt);
            system.debug('Quote Line Items - '+allQuoteWOLS);
            // Check if the user has delete access on the Work_Oder_Lines__c object
            if (!sigmaerpdev2__Work_Oder_Lines__c.sObjectType.getDescribe().isDeletable()) {
                return;
            }
            if(workOrderLinesDel!=null && workOrderLinesDel.size()!=0){
                delete workOrderLinesDel;  
                System.debug('WOLI Deleted successfully');
            }
           
            if (!Schema.sObjectType.sigmaerpdev2__Service_Resource__c.fields.sigmaerpdev2__User__c.isAccessible()){
                system.debug('Has no Access on Service Resource\'s User field.');
                return;
            }
            list<sigmaerpdev2__Service_Resource__c> contact = [SELECT Id, Name,sigmaerpdev2__Service_Location__c FROM sigmaerpdev2__Service_Resource__c where sigmaerpdev2__User__c =: workorderId[0].sigmaerpdev2__AssignTo__c];
            system.debug('Contact - '+contact);
            
            // Product_Stock__c Fields that will be accessed.
            String [] productStockFields = new String [] {'sigmaerpdev2__Inventory__c','sigmaerpdev2__Product_Lookup__c','sigmaerpdev2__Location__c'};
                
                // Obtaining the field name/token map for the ProductStock object
                Map<String,Schema.SObjectField> mPS = Schema.SObjectType.sigmaerpdev2__Product_Stock__c.fields.getMap();
            for (String fieldToCheck : productStockFields) {
                // Check if the user has create access on the each field
                if (!mPS.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on Product_Stock__c Fields');
                    return;
                }
            }
            
            List<sigmaerpdev2__Product_Stock__c> productStock = [SELECT Id, sigmaerpdev2__Inventory__c, sigmaerpdev2__Product_Lookup__c,sigmaerpdev2__Location__c   FROM sigmaerpdev2__Product_Stock__c where sigmaerpdev2__Location__c =: contact[0].sigmaerpdev2__Service_Location__c and sigmaerpdev2__Product_Lookup__c=:Prod];
            system.debug('productStock'+productStock);
            
            if (!Schema.sObjectType.sigmaerpdev2__Product_Stock__c.fields.sigmaerpdev2__Inventory__c.isUpdateable()){
                system.debug('No Edit Access on ProductStock\'s Inventory field');
                return;
            }
            for(sigmaerpdev2__Work_Oder_Lines__c eachWorkOrderLineItem : workOrderLinesUpdt){
                for(sigmaerpdev2__Product_Stock__c productStck : productStock){
                    if(eachWorkOrderLineItem.sigmaerpdev2__Product__c == productStck.sigmaerpdev2__Product_Lookup__c){
                        if(eachWorkOrderLineItem.Quantity__c<=productStck.sigmaerpdev2__Inventory__c){
                            productStck.sigmaerpdev2__Inventory__c = productStck.sigmaerpdev2__Inventory__c - eachWorkOrderLineItem.sigmaerpdev2__Quantity__c;  
                            // System.debug('productStck.Inventory__c'+productStck.Inventory__c);
                        } 
                    }
                }
            }
            update productStock;
            system.debug('Product Stock Updated');
            
            
        Map<Id,Decimal>Deliveredqty=new Map<Id,Decimal>();
        List<Id>lisOfIlp= new List<Id>();
        Decimal qty=0;
        for(Work_Oder_Lines__c eachWorkOrderLineItem : workOrderLinesUpdt){
            if(Deliveredqty.containsKey(eachWorkOrderLineItem.sigmaerpdev2__Product__c)){
              Deliveredqty.put(eachWorkOrderLineItem.sigmaerpdev2__Product__c,Deliveredqty.get(eachWorkOrderLineItem.sigmaerpdev2__Product__c)+eachWorkOrderLineItem.sigmaerpdev2__Quantity__c);
            }
            else if(eachWorkOrderLineItem.sigmaerpdev2__Quantity__c!=null)
            {
                Deliveredqty.put(eachWorkOrderLineItem.sigmaerpdev2__Product__c,eachWorkOrderLineItem.sigmaerpdev2__Quantity__c);
            }
        }         
     
        /*List<Inventory_Location_Product_Line_Item__c>ilpliList=[select id,Inventory_Location_Product__c,sigmaerpdev2__Available_Quantity__c,sigmaerpdev2__Delivered_Quantity__c,name,Used_Quantity__c,Reserved_Quantity__c,sigmaerpdev2__Product__c,sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c from Inventory_Location_Product_Line_Item__c where sigmaerpdev2__Product__c=:Prod and sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c=: contact.sigmaerpdev2__Service_Location__c and sigmaerpdev2__Available_Quantity__c > 0 order by sigmaerpdev2__Product_Received_date__c];
        system.debug('ilpliList'+ilpliList);
        for(Inventory_Location_Product_Line_Item__c ilplist : ilpliList)
        {
            if(Deliveredqty.containsKey(ilplist.sigmaerpdev2__Product__c))
            {               
                ilplist.sigmaerpdev2__Delivered_Quantity__c += Deliveredqty.get(ilplist.sigmaerpdev2__Product__c);
                qty = Deliveredqty.get(ilplist.sigmaerpdev2__Product__c);
                lisOfIlp.add(ilplist.Inventory_Location_Product__c);
            }    
        }
        
        update ilpliList;
        system.debug('ilpliList'+ilpliList);*/
        
        //new code for ilpliList
        Decimal requiredQuantity = 0;
        Decimal allocatingQuantity = 0;
        Map<Id,Decimal> IlPLIQuan = new Map<Id,Decimal>();
        Map<id,Decimal> LotQuan=new Map<Id,Decimal>();
        List<Inventory_Location_Product_Line_Item__c>ilpliList=[select id,Lot__c,Bin__c,inventory_Location_Product__c,sigmaerpdev2__Available_Quantity__c,sigmaerpdev2__Delivered_Quantity__c,name,Used_Quantity__c,Reserved_Quantity__c,sigmaerpdev2__Product__c,sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c from Inventory_Location_Product_Line_Item__c where sigmaerpdev2__Product__c in :Prod and sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c=:contact[0].sigmaerpdev2__Service_Location__c and sigmaerpdev2__Available_Quantity__c > 0 order by sigmaerpdev2__Product_Received_date__c];
        System.debug('ilpliList===='+ilpliList);
        
        System.debug('Deliveredqty==='+Deliveredqty);
        if(ilpliList.size() > 0){
            for(Inventory_Location_Product_Line_Item__c ilpliObj : ilpliList){
                if(Deliveredqty.containsKey(ilpliObj.Product__c)){
                    requiredQuantity = Deliveredqty.get(ilpliObj.Product__c);
                    if(requiredQuantity > 0){
                        allocatingQuantity = ilpliObj.Available_Quantity__c;
                        if(allocatingQuantity <= requiredQuantity && allocatingQuantity != 0){                      
                            ilpliObj.Delivered_Quantity__c += allocatingQuantity;
                            IlPLIQuan.put(ilpliObj.Id,allocatingQuantity);
                            requiredQuantity = requiredQuantity - allocatingQuantity;                           
                        }else if(allocatingQuantity > requiredQuantity){
                            ilpliObj.Delivered_Quantity__c += requiredQuantity;
                            IlPLIQuan.put(ilpliObj.Id, requiredQuantity);
                            requiredQuantity = 0;                           
                        }
                        Deliveredqty.put(ilpliObj.Product__c, requiredQuantity);
                        
                    }               
                }
                
                
            }
                 update ilpliList; 
        }
        system.debug('ilpliList'+ilpliList);


        System.debug('IlPLIQuan===='+IlPLIQuan);
        
      
             //lot code
       List<Inventory_Location_Product_Line_Item__c> ilpliSumLists= [select Id,sigmaerpdev2__Inventory_Location_Product__c,Lot__c,Bin__c,Product__c,sigmaerpdev2__Product_Serial_Number__c from Inventory_Location_Product_Line_Item__c where id in :IlPLIQuan.keySet()];
        system.debug('ilpliSumLists'+ilpliSumLists);
        set<id> psns=new set<id>();
         Map<Id,Map<id,Decimal>> lotqtyupdate = new Map<Id,Map<id,Decimal>>();
        set<id> LOTID1=new set<id>();
            map<id,id>linkids=new map<id,id>();
			map<id,id>ilpids=new map<id,id>();
            for(Inventory_Location_Product_Line_Item__c indILPLI : ilpliSumLists){
                system.debug('ilpliList'+ilpliSumLists);
                linkids.put(indILPLI.id,indILPLI.Product__c);
				ilpids.put(indILPLI.id,indILPLI.sigmaerpdev2__Inventory_Location_Product__c);
            if(indILPLI.Lot__c!=null)
                    {
                        system.debug('indILPLI.Lot__c'+indILPLI.Lot__c);
                         LOTID1.add(indILPLI.Lot__c);
                        if(lotqtyupdate.containsKey(indILPLI.Lot__c))
                        {
                            
                            if(lotqtyupdate.get(indILPLI.Lot__c).containsKey(indILPLI.Bin__c))
                            {
                                system.debug('checkkks'+lotqtyupdate.get(indILPLI.Lot__c).containsKey(indILPLI.Bin__c));
                                decimal qty2=lotqtyupdate.get(indILPLI.Lot__c).get(indILPLI.Bin__c);
                                system.debug('qty1'+qty2);
                                lotqtyupdate.get(indILPLI.Lot__c).put(indILPLI.Bin__c,qty2+IlPLIQuan.get(indILPLI.id));
                            system.debug('lotqtyupdate'+lotqtyupdate);
                            }
                            else
                            {
                                Map<id,decimal> locid=new Map<id,decimal>();
                                lotqtyupdate.get(indILPLI.Lot__c).put(indILPLI.Bin__c,IlPLIQuan.get(indILPLI.id));
                            system.debug('lotqtyupdate'+lotqtyupdate);
                            }
                        }
                        else
                        {
                            Map<id,decimal> locid=new Map<id,decimal>();
                            locid.put(indILPLI.Bin__c,IlPLIQuan.get(indILPLI.id));
                            lotqtyupdate.put(indILPLI.Lot__c,locid);
                        }
                    }
                    if(indILPLI.sigmaerpdev2__Product_Serial_Number__c!=null)
                    {
                        psns.add(indILPLI.sigmaerpdev2__Product_Serial_Number__c);
                    }
            }
            system.debug('LOTID1'+LOTID1);
            
            
            
        list<Lot__c> lotList=new List<Lot__c>();
           List<Lot_Product__c> updatelotpro=new List<Lot_Product__c>();
           lotList = [Select Id,Name,(Select Id,Name,Location__c,Bin__c,Quantity__c,Lot__c From Lot_Products__r) From Lot__c where Id in:LOTID1];
           system.debug('lotList'+lotList);
             for(Lot__c lt3:lotList)
            {
                for(Lot_Product__c ltpro:lt3.Lot_Products__r)
                {
              if(lotqtyupdate.containsKey(ltpro.Lot__c))
                    {
                        if(lotqtyupdate.get(ltpro.Lot__c).containsKey(ltpro.Bin__c))
                        {
                            ltpro.Quantity__c-=lotqtyupdate.get(ltpro.Lot__c).get(ltpro.Bin__c);
                            system.debug('lt3.Quantity__c'+ltpro.Quantity__c);
                            updatelotpro.add(ltpro);
                        }
                     
                }
            }
            }
            upsert updatelotpro;
            
            system.debug('updatelotpro'+updatelotpro);
            
        
        //ends here
        
        //code for psn 
        
        List<Product_Serial_Number__c> serialststusupdate=new List<Product_Serial_Number__c>();
            serialststusupdate=[select id,name,Status__c from Product_Serial_Number__c where id=:psns];
            for(Product_Serial_Number__c serialstatus:serialststusupdate)
            {
              
               serialstatus.Status__c='Used';
               
            }
            update serialststusupdate;
            
            //psn code ends here
        
            
               
        /*List<Inventory_Location_Product__c>listOfIlplNew=[select id,sigmaerpdev2__Deliver_Quantity__c,sigmaerpdev2__Products__c,sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c,name,sigmaerpdev2__Net_Quantity__c,sigmaerpdev2__Reserved_Quantity__c,sigmaerpdev2__Availability__c,Delivered_Quantity__c from  Inventory_Location_Product__c where id=:lisOfIlp];
           for(Work_Oder_Lines__c eachWorkOrderLineItem : workOrderLinesUpdt){
             for(Inventory_Location_Product__c productStck1: listOfIlplNew){
                 if(eachWorkOrderLineItem.sigmaerpdev2__Product__c==productStck1.sigmaerpdev2__Products__c)
              {
                 if(eachWorkOrderLineItem.Quantity__c<=productStck1.sigmaerpdev2__Net_Quantity__c){
                productStck1.sigmaerpdev2__Deliver_Quantity__c+=qty;
                  }  
                }
             }
           }
        update listOfIlplNew;
        system.debug('listOfIlplNew'+listOfIlplNew);*/
        
        
        
        /*List<sigmaerpdev2__Inventory__c> productStock1 = [SELECT Id,sigmaerpdev2__Reserved_Qty__c,sigmaerpdev2__Available_Qty__c,sigmaerpdev2__Total_Available_Qty__c, sigmaerpdev2__Total_Qty__c, sigmaerpdev2__ProductCode__c,sigmaerpdev2__Delivered_Qty__c   FROM sigmaerpdev2__Inventory__c where sigmaerpdev2__ProductCode__c=:Prod];
        for(Work_Oder_Lines__c eachWorkOrderLineItem : workOrderLinesUpdt){
            for(sigmaerpdev2__Inventory__c productStck : productStock1){
                    if(eachWorkOrderLineItem.Quantity__c<=productStck.sigmaerpdev2__Available_Qty__c){
                    productStck.sigmaerpdev2__Delivered_Qty__c+=eachWorkOrderLineItem.sigmaerpdev2__Quantity__c;
                    productStck.sigmaerpdev2__Available_Qty__c-=qty;
                 } 
               } 
            }
        update productStock1;
        system.debug('productStock1'+productStock1);
        system.debug('Product Stock Updated');*/
        
        //new code to update ILP delivered qty and PI quantities
        Map<Id,Decimal> allocatedILPs = new Map<Id,Decimal>(); //used to store ILP's and its respective allocated quantity                  
        Map<Id,Decimal> allocatedPIs = new Map<Id,Decimal>(); //used to store PI's and its respective allocated quantity                  
       
       List<Inventory_Location_Product_Line_Item__c> ilpliSumList = [select Id,Lot__c,Bin__c,Inventory_Location_Product__c from Inventory_Location_Product_Line_Item__c where id in :IlPLIQuan.keySet()];
        system.debug('ilpliSumList'+ilpliSumList);
        if(ilpliSumList.size() > 0){
            for(Inventory_Location_Product_Line_Item__c ilpliObj1 : ilpliSumList){                
                if(!allocatedILPs.containsKey(ilpliObj1.Inventory_Location_Product__c)){
                    allocatedILPs.put(ilpliObj1.Inventory_Location_Product__c, IlPLIQuan.get(ilpliObj1.Id));
                }else{                          
                   // Decimal qty1 = IlPLIQuan.get(ilpliObj1.Id);
                   Decimal qty1=allocatedILPs.get(ilpliObj1.Inventory_Location_Product__c);
                    allocatedILPs.put(ilpliObj1.Inventory_Location_Product__c,(qty1 + IlPLIQuan.get(ilpliObj1.Id)));
                }
            }
        }
        
        
        
         
        
        System.debug('allocatedILPs===='+allocatedILPs);
        List<Inventory_Location_Product__c> listOfIlplNew = [select Id, Deliver_Quantity__c, Inventory__c from Inventory_Location_Product__c where id in :allocatedILPs.keySet()];
        System.debug('listOfIlplNew===='+listOfIlplNew);
        for(Inventory_Location_Product__c productStck1 : listOfIlplNew){
            productStck1.Deliver_Quantity__c += allocatedILPs.get(productStck1.Id);
            system.debug('allocatedILPs===='+allocatedILPs);
           if(!allocatedPIs.containsKey(productStck1.Inventory__c)){
                allocatedPIs.put(productStck1.Inventory__c, allocatedILPs.get(productStck1.Id));                
            }else{                          
                Decimal qty1 = allocatedILPs.get(productStck1.Id);                
                allocatedPIs.put(productStck1.Inventory__c,(qty1 + allocatedILPs.get(productStck1.Id)));                
            }
        }
        update listOfIlplNew;

        System.debug('allocatedPIs===='+allocatedPIs);
        
        List<Inventory__c> productStock1 = [SELECT Id,Available_Qty__c,Delivered_Qty__c FROM Inventory__c where Id in :allocatedPIs.keySet()];
        System.debug('productStock1===='+productStock1);
        for(Inventory__c productStck : productStock1){
            productStck.Delivered_Qty__c += allocatedPIs.get(productStck.Id);
            productStck.Available_Qty__c -= allocatedPIs.get(productStck.Id);
            productStck.Comments__c='Inventory Used for Work Order';
        }
        update productStock1;
        system.debug('productStock1'+productStock1);
        //ends here
		
		
          
            
            
          
            // Task Fields that will be accessed.
            String [] taskFields = new String [] {'sigmaerpdev2__Work_Order__c','Status','Subject','OwnerId','ActivityDate'};
                
                // Obtaining the field name/token map for the ProductStock object
                Map<String,Schema.SObjectField> taskFieldsMap = Schema.SObjectType.Task.fields.getMap();
            for (String fieldToCheck : taskFields) {
                // Check if the user has create access on the each field
                if (!taskFieldsMap.get(fieldToCheck).getDescribe().isCreateable()) {
                    system.debug('Has no Access on Product_Stock__c Fields');
                    return;
                }
            }
            if(allQuoteWOLS!=null && !allQuoteWOLS.isEmpty()){
                sigmaerpdev2__Work_Order__c wo=[SELECT Id,Status__c,CreatedById  FROM sigmaerpdev2__Work_Order__c where id=:workorderId[0].Id  Limit 1];
                
                Task t1=new Task();
                t1.sigmaerpdev2__Work_Order__c=wo.id;
                t1.Status='Not Started';
                t1.Subject='Create a Quote';
                t1.OwnerId=wo.CreatedById;
                t1.ActivityDate=Date.Today()+1;
                
                insert t1;
            }
			
			
		list<sigmaerpdev2__Work_Order_Inventory_Track__c> workorderinv=new list<sigmaerpdev2__Work_Order_Inventory_Track__c>();
            for(Inventory_Location_Product_Line_Item__c indILPLI :ilpliSumLists ){
                sigmaerpdev2__Work_Order_Inventory_Track__c WOIT=new sigmaerpdev2__Work_Order_Inventory_Track__c();
                WOIT.sigmaerpdev2__Product__c=linkids.get(indILPLI.id);
                system.debug('WOIT.sigmaerpdev2__Product__c'+WOIT.sigmaerpdev2__Product__c);
                WOIT.sigmaerpdev2__Inventory_Location_Product__c=ilpids.get(indILPLI.id);
                system.debug('WOIT.sigmaerpdev2__Product__c'+WOIT.sigmaerpdev2__Inventory_Location_Product__c);
                WOIT.sigmaerpdev2__Inventory_Location_Product_Line_Item__c=indILPLI.id;
                WOIT.sigmaerpdev2__Quantity_Used__c=IlPLIQuan.get(indILPLI.id);
                WOIT.sigmaerpdev2__Work_Order__c=workorderId[0].id;
                workorderinv.add(WOIT);
            }
		insert workorderinv;
		system.debug('workorderinv'+workorderinv);
		
 		LinkageServiceClass.LinkWorkorderComp(workorderinv);
     			
            
        }
        catch(Exception e){
            System.debug('Exception '+e);
        }
    }
}