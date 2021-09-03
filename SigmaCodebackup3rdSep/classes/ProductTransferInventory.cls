public class ProductTransferInventory {
    
    public static void isverified(list<sigmaerpdev2__Product_transfer__c> SA)
    { 
        
        /**************inside*******************/
        Map<String,boolean> isStockAtWarehouse = new Map<String,Boolean>();
        
        Integer i =0;
        
        try{ 
            // RequestLineItems Fields that will be accessed.
            String [] requestlineitemFields = new String [] {'sigmaerpdev2__Quantity__c','sigmaerpdev2__Quantity_Received__c','sigmaerpdev2__Product__c','sigmaerpdev2__Product_Transfer__c'};
                
                // Obtaining the field name/token map for the sigmaerpdev2__Product_Request_Line_Item__c object
                Map<String,Schema.SObjectField> mPRLI = Schema.SObjectType.sigmaerpdev2__Product_Request_Line_Item__c.fields.getMap();
            for (String fieldToCheck : requestlineitemFields) {
                // Check if the user has create access on the each field
                if (!mPRLI.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on ProductRequestLineItem Fields');
                    return;
                }
            }
            //Fetching all the ProductRequestLineItems based on which Inventory transfer upon products happen.
            Id prliId = SA[0].Id;
            List<sigmaerpdev2__Product_Request_Line_Item__c> requestlineitem =[SELECT sigmaerpdev2__Quantity__c,sigmaerpdev2__Quantity_Received__c, sigmaerpdev2__Product__c,sigmaerpdev2__Product__r.Stock_Item__c,sigmaerpdev2__Product__r.Attribute_Type__c,sigmaerpdev2__Product_Transfer__c, Id FROM sigmaerpdev2__Product_Request_Line_Item__c where sigmaerpdev2__Product_Transfer__c=:prliID];
            System.debug('requestlineitem'+requestlineitem);
            
            
            
            // Location Fields that will be accessed.
            String [] locationFields = new String [] {'Name','sigmaerpdev2__Location_Type__c'};
                
                // Obtaining the field name/token map for the ProductStock object
                Map<String,Schema.SObjectField> locationMap = Schema.SObjectType.Account.fields.getMap();
            for (String fieldToCheck : locationFields) {
                // Check if the user has create access on the each field
                if (!locationMap.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on Location Fields');
                    return;
                }
            }
            //Fetching the Location of the Warehouse from which we have to get the stock.
            Id productTransferFromLocationId= SA[0].sigmaerpdev2__Request_Location__c;
            
            System.debug('productTransferFromLocationId===='+productTransferFromLocationId);
            
            list<Account> fromlocation = [SELECT Id,Name, sigmaerpdev2__Location_Type__c  FROM Account where Id =:productTransferFromLocationId];
            System.debug('fromlocation'+fromlocation);
            
            id fromBinTransfer=SA[0].sigmaerpdev2__From_Bin__c;
            list<sigmaerpdev2__Sublevel_location__c> sl1=[select id,name,sigmaerpdev2__Location__c,sigmaerpdev2__Inventory_Location__c from sigmaerpdev2__Sublevel_location__c where id=:fromBinTransfer];
            
            
            id tobinTransfer=SA[0].sigmaerpdev2__To_Bin__c;
            list<sigmaerpdev2__Sublevel_location__c> sl2=[select id,name,sigmaerpdev2__Location__c,sigmaerpdev2__Inventory_Location__c from sigmaerpdev2__Sublevel_location__c where id=:tobinTransfer];
            
            
            //Fetching the Location of the Technician for which the stock has to be delivered.
            Id productTransferToLocationId = SA[0].sigmaerpdev2__To_Requested_Location__c;
            list<Account> tolocation = [SELECT Id,Name, sigmaerpdev2__Location_Type__c  FROM Account where Id =:productTransferToLocationId];
            System.debug('tolocation'+tolocation);
            
            
            // ProductStock Fields that will be accessed.
            String [] productStockFields = new String [] {'sigmaerpdev2__Inventory__c','sigmaerpdev2__Location__c','sigmaerpdev2__Product_Lookup__c'};
                
                // Obtaining the field name/token map for the ProductStock object
                Map<String,Schema.SObjectField> productStockMap = Schema.SObjectType.sigmaerpdev2__Product_Stock__c.fields.getMap();
            for (String fieldToCheck : productStockFields) {
                // Check if the user has create access on the each field
                if (!productStockMap.get(fieldToCheck).getDescribe().isAccessible()) {
                    system.debug('Has no Access on ProductStock Fields');
                    return;
                }
            }
            
            //Fetching the Stock of all the products at the Technician's Location.
            Id toLocationId = tolocation[0].Id;
            List<sigmaerpdev2__Product_Stock__c> productStock = [SELECT Id,name,sigmaerpdev2__Location__c,sigmaerpdev2__Inventory__c, sigmaerpdev2__Product_Lookup__c FROM sigmaerpdev2__Product_Stock__c where sigmaerpdev2__Location__c =: toLocationId];
            System.debug('productStock'+productStock);
            
            List<sigmaerpdev2__Product_Stock__c> updatedProductStckOfWarehouse = new List<sigmaerpdev2__Product_Stock__c>();
            List<sigmaerpdev2__Product_Stock__c> updatestock = new List<sigmaerpdev2__Product_Stock__c>();
            List<sigmaerpdev2__Product_Stock__c> listPS1 = new List<sigmaerpdev2__Product_Stock__c>();
            
            /* **********************************************************************************************************
The below nested loop is for comparing a list of PRODUCTREQUESTLINEITEM and PRODUCTSTOCKOFWAREHOUSE 
with respect to name of the product and then checking whether the requested quantitny is <= to the quantity 
present in the warehouse, if yes then we are subtracting the required quantity in the Warehouse.
*********************************************************************************************************/
            /* if (!Schema.sObjectType.sigmaerpdev2__Product_Stock__c.fields.sigmaerpdev2__Inventory__c.isUpdateable()){
system.debug('No access on ProductStock\'s Inventory Field');
return;
}*/
            for(sigmaerpdev2__Product_Request_Line_Item__c productRequestLineItem : requestlineitem){
                boolean isProdPresent=false;
                for(sigmaerpdev2__Product_Stock__c productStckOfWarehouse : productStock){
                    
                    //Matching the product name at the central warehouse and at the Tech's truck.
                    if(productRequestLineItem.sigmaerpdev2__Product__c == productStckOfWarehouse.sigmaerpdev2__Product_Lookup__c){
                        isProdPresent=true;
                        productStckOfWarehouse.sigmaerpdev2__Inventory__c = productStckOfWarehouse.sigmaerpdev2__Inventory__c + productRequestLineItem.sigmaerpdev2__Quantity_Received__c;
                        
                    }
                }
                if(!isProdPresent)
                {
                    sigmaerpdev2__Product_Stock__c tempPS1 = new sigmaerpdev2__Product_Stock__c();
                    tempPS1.sigmaerpdev2__Product_Lookup__c = productRequestLineItem.sigmaerpdev2__Product__c;
                    tempPS1.sigmaerpdev2__Location__c = tolocation[0].Id;
                    tempPS1.sigmaerpdev2__Inventory__c = productRequestLineItem.sigmaerpdev2__Quantity_Received__c;
                    listPS1.add(tempPS1);
                }
            }
            
            insert listPS1;
            update productStock;
            
            
            
            
            
            /**********************************************************************************************************
The below nested loop is for comparing a list of PRODUCTREQUESTLINEITEM and PRODUCTSTOCKOFAGENT
with respect to name of the product and then adding the requested quantity to the ProductStock of the Agent.
**********************************************************************************************************/
            List<sigmaerpdev2__Product_Stock__c> updatedProductStck= new List<sigmaerpdev2__Product_Stock__c>();
            /*      if (!Schema.sObjectType.sigmaerpdev2__Product_Stock__c.fields.sigmaerpdev2__Inventory__c.isUpdateable()){
system.debug('No access on ProductStock\'s Inventory Field');
return;
}*/
            
            Boolean flag=false;
            // ProductStock Fields that will be accessed.
            productStockFields = new String [] {'sigmaerpdev2__Inventory__c','sigmaerpdev2__Product_Lookup__c','sigmaerpdev2__Location__c'};
                
                // Obtaining the field name/token map for the ProductStock object
                productStockMap = Schema.SObjectType.sigmaerpdev2__Product_Stock__c.fields.getMap();
            for (String fieldToCheck : productStockFields) {
                // Check if the user has create access on the each field
                if (!productStockMap.get(fieldToCheck).getDescribe().isCreateable()) {
                    system.debug('Has no create Access on ProductStock Fields');
                    return;
                }
            }
            
            
            
            for(String key: isStockAtWarehouse.keySet()){  
                for(sigmaerpdev2__Product_Stock__c productStck: productStock){
                    for(sigmaerpdev2__Product_Request_Line_Item__c productRequestLineItem : requestlineitem){
                        if(isStockAtWarehouse.get(key)){
                            //System.debug('isStockAtWarehouse' +isStockAtWarehouse.get(key));
                            if(productRequestLineItem.sigmaerpdev2__Product__c == productStck.sigmaerpdev2__Product_Lookup__c && productRequestLineItem.sigmaerpdev2__Product__c == key){ 
                                productStck.sigmaerpdev2__Inventory__c = productStck.sigmaerpdev2__Inventory__c + productRequestLineItem.sigmaerpdev2__Quantity_Received__c;
                                updatedProductStck.add(productStck);
                            }
                            
                        }
                    }
                }
            }
            update updatedProductStck;
            System.debug('update ProductStock' +updatedProductStck);
            
            list<id> proids=new list<id>();
            map<id,id> prodct=new map<id,id>();
            map<id,id>pic=new map<id,id>();
            system.debug('pi'+pic);
            Map<Id,Decimal> prodQnMap = new Map<Id,Decimal>();
            system.debug('prodct'+prodct);
            
            
            Set<Id> prodIdSetOrig = new Set<Id>();
            
            for(sigmaerpdev2__Product_Request_Line_Item__c productRequestLineItem1 : requestlineitem){ 
                proids.add(productRequestLineItem1.sigmaerpdev2__Product__c);
                prodQnMap.put(productRequestLineItem1.Product__c, productRequestLineItem1.sigmaerpdev2__Quantity_Received__c);
                prodIdSetOrig.add(productRequestLineItem1.Product__c);
            }
            system.debug('proids'+proids);
            
            
            
            list<sigmaerpdev2__Inventory_Location__c> ilc=[select id,Name,sigmaerpdev2__Location__c from sigmaerpdev2__Inventory_Location__c where sigmaerpdev2__Location__c=:toLocationId];
            system.debug('ilc==='+ilc);
            
            list<sigmaerpdev2__Inventory__c> pi=[select id ,name,sigmaerpdev2__ProductCode__c from sigmaerpdev2__Inventory__c where sigmaerpdev2__ProductCode__c=:proids];
            system.debug('pi'+pi);
            for(sigmaerpdev2__Inventory__c piz:pi)
            {
                pic.put(piz.sigmaerpdev2__ProductCode__c,piz.id);  
            }
            system.debug('pic'+pic);
            
            
            
            //new code added on 19/7/2020 to create ILP in that particular TO LoC if it doesn't already exist
            Set<Id> existingProdILP = new Set<Id>();            
            Set<Id> nonexistingProdILP = new Set<Id>();
            List<Inventory_Location_Product__c> ilpz = [select id,Inventory__c,Name,Availability__c,
                                                        Deliver_Quantity__c,Inventory_Location__c,AvailableAdjustedQty__c,
                                                        Products__c from Inventory_Location_Product__c 
                                                        where Inventory_Location__r.Location__c = :toLocationId and Products__c = :proids];
            system.debug('ilpz'+ilpz);
            List<Inventory_Location_Product__c> il = new List<Inventory_Location_Product__c>();
            if(ilpz.size() > 0){
                for(Inventory_Location_Product__c ilpObj : ilpz){
                    existingProdILP.add(ilpObj.Products__c);
                }
                
                for(Id objId: existingProdILP){
                    if(prodIdSetOrig.contains(objId)){
                        prodIdSetOrig.remove(objId);
                    }                       
                }   
                
                nonexistingProdILP = prodIdSetOrig;
                
                //to create new ilp's for products (if its not there already)
                if(nonexistingProdILP.size() > 0){
                    for(Id prodIdSet : nonexistingProdILP) {
                        for(Product_Request_Line_Item__c productRequestLineItem1: requestlineitem){
                            if(productRequestLineItem1.Product__c == prodIdSet && productRequestLineItem1.Product__r.Stock_Item__c == true){                            
                                Inventory_Location_Product__c temps2 = new Inventory_Location_Product__c();
                                temps2.Products__c = productRequestLineItem1.Product__c;
                                //temps2.AvailableAdjustedQty__c = -productRequestLineItem1.sigmaerpdev2__Quantity_Received__c;
                                temps2.AdjustedReceivedqty__c = productRequestLineItem1.sigmaerpdev2__Quantity_Received__c;
                                temps2.Inventory_Location__c = ilc[0].id;
                                temps2.Inventory__c = pic.get(productRequestLineItem1.Product__c);                              
                                il.add(temps2);                         
                            }
                        }                   
                    }
                }               
                //ends here
                
                //update existing ilp qty               
                List<Inventory_Location_Product__c> updateILPList = [select id,Inventory__c,
                                                                     AvailableAdjustedQty__c,AdjustedReceivedqty__c,
                                                                     Products__c from Inventory_Location_Product__c 
                                                                     where Inventory_Location__r.Location__c = :toLocationId and Products__c in : existingProdILP];              
                for(Product_Request_Line_Item__c productRequestLineItem2: requestlineitem){
                    for(Inventory_Location_Product__c ilpObj12 : updateILPList){
                        if(productRequestLineItem2.Product__c == ilpObj12.Products__c){ 
                            ilpObj12.AdjustedReceivedqty__c = ilpObj12.AdjustedReceivedqty__c + productRequestLineItem2.sigmaerpdev2__Quantity_Received__c;
                        }
                    }                   
                }
                update updateILPList;
                //ends here
            }else{
                for(Product_Request_Line_Item__c productRequestLineItem1: requestlineitem){                 
                    if(productRequestLineItem1.Product__r.Stock_Item__c == true){                           
                        Inventory_Location_Product__c temps2 = new Inventory_Location_Product__c();
                        temps2.Products__c = productRequestLineItem1.Product__c;
                        //temps2.AvailableAdjustedQty__c = -productRequestLineItem1.sigmaerpdev2__Quantity_Received__c;
                        temps2.AdjustedReceivedqty__c = productRequestLineItem1.sigmaerpdev2__Quantity_Received__c;                        
                        temps2.Inventory_Location__c = ilc[0].id;
                        temps2.Inventory__c = pic.get(productRequestLineItem1.Product__c);                              
                        il.add(temps2);                         
                    }                                   
                }   
            }
            
            if(il.size() > 0){
                insert il;
            }    
            
            
            //ends here
            
            
            
            //new code to reduce ILPLI quantities from FROM LOC after transfer is completed
            
            list<sigmaerpdev2__Inventory_Location_Product__c> ilpc=[select id,Name,sigmaerpdev2__Products__c,sigmaerpdev2__Inventory_Location__c from sigmaerpdev2__Inventory_Location_Product__c where sigmaerpdev2__Products__c=:proids and sigmaerpdev2__Inventory_Location__c=:ilc[0].id];  
            system.debug('ilpc==='+ilpc);
            
            for(sigmaerpdev2__Inventory_Location_Product__c ilpx : ilpc)
            {
                
                prodct.put(ilpx.Products__c, ilpx.id);
            }  
            
            Map<Id,Decimal> ilpliIdQuant =new Map<Id,Decimal>();
            Map<Id,Map<id,Decimal>> lotqtyupdate = new Map<Id,Map<id,Decimal>>();
            //Map<Id,Map<id,Decimal>> lotqtyupdate1 = new Map<Id,Map<id,Decimal>>();
            set<Id> LOTID =new set<Id>();
            Map<Id,Decimal> ilpliSelMap = new Map<Id,Decimal>();
            Map<Id,Decimal> ILPReduceQtyMap = new Map<Id,Decimal>();
            Map<id,id> lotmaps=new Map<id,id>();
            
            List<Product_Serial_Number__c> psnLoc = new List<Product_Serial_Number__c>();
            
            List<Product_Transfer_Inventory_Tracking__c> prodInvTrkList = [select Id,Inventory_Location_Product_Line_Item__c,
                                                                           Product_Transfer__c,sigmaerpdev2__Lot__c,Product__r.Attribute_Type__c,sigmaerpdev2__Received_qty__c,Transferred_Qty__c,Product__r.Stock_Item__c,sigmaerpdev2__Product__c,Product_Serial_Number__c from Product_Transfer_Inventory_Tracking__c where Product_Transfer__c = :prliId];
            for(Product_Transfer_Inventory_Tracking__c ptiObj : prodInvTrkList){
                ilpliSelMap.put(ptiObj.Inventory_Location_Product_Line_Item__c, ptiObj.sigmaerpdev2__Received_qty__c);
                
            }
            
            
            List<Inventory_Location_Product_Line_Item__c> ilpliList = [select Id,Bin__c,Lot__c,Product__c,Type__c,Product_Serial_Number__c,ILid__c,Delivered_Quantity__c,AvailableAdjustedQty__c,Inventory_Location_Product__c 
                                                                       from Inventory_Location_Product_Line_Item__c where id in :ilpliSelMap.keySet()];
            for(Inventory_Location_Product_Line_Item__c ilpliObj : ilpliList){
                
                if(!ILPReduceQtyMap.containsKey(ilpliObj.Inventory_Location_Product__c)){
                    ILPReduceQtyMap.put(ilpliObj.Inventory_Location_Product__c, ilpliSelMap.get(ilpliObj.Id));
                }else{
                    Decimal qty1 = ILPReduceQtyMap.get(ilpliObj.Inventory_Location_Product__c);                    
                    ILPReduceQtyMap.put(ilpliObj.Inventory_Location_Product__c,(qty1 + ilpliSelMap.get(ilpliObj.Id)));
                }
                
                ilpliObj.AvailableAdjustedQty__c += ilpliSelMap.get(ilpliObj.Id);
                
            }
            update ilpliList;
            //ends here
            
            //lot from product update
            set<id> LOTID1=new set<id>();
            for(Inventory_Location_Product_Line_Item__c indILPLI : ilpliList){
                system.debug('ilpliList'+ilpliList);
                lotmaps.put(indILPLI.Product__c,indILPLI.Lot__c);
                system.debug('lotmaps'+lotmaps);
                if(indILPLI.Lot__c!=null)
                {
                    system.debug('indILPLI.Lot__c'+indILPLI.Lot__c);
                    LOTID1.add(indILPLI.Lot__c);
                    if(lotqtyupdate.containsKey(indILPLI.Lot__c))
                    {
                        if(lotqtyupdate.get(indILPLI.Lot__c).containsKey(indILPLI.Bin__c))
                        {
                            decimal qty=lotqtyupdate.get(indILPLI.Lot__c).get(indILPLI.Bin__c);
                            lotqtyupdate.get(indILPLI.Lot__c).put(indILPLI.Bin__c,qty+ilpliSelMap.get(indILPLI.id));
                        }
                        else
                        {
                            Map<id,decimal> locid=new Map<id,decimal>();
                            lotqtyupdate.get(indILPLI.Lot__c).put(indILPLI.Bin__c,ilpliSelMap.get(indILPLI.id));
                        }
                    }
                    else
                    {
                        Map<id,decimal> locid=new Map<id,decimal>();
                        locid.put(indILPLI.Bin__c,ilpliSelMap.get(indILPLI.id));
                        lotqtyupdate.put(indILPLI.Lot__c,locid);
                    }
                }
                
                
                
                
            }
            
            
            
            List<Lot__c> lotList=new List<Lot__c>();
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
            
            //end here
            
            
            
            //ilpli for to location          
            
            list<lot__c> lt1= [select id,name,sigmaerpdev2__Product__c,sigmaerpdev2__Lot_Name__c from sigmaerpdev2__Lot__c where sigmaerpdev2__Product__c=:proids];
            system.debug('lt'+lt1);
            map<id,decimal> vps1=new map<id,decimal>();
            
            list<sigmaerpdev2__Inventory_Location_Product_Line_Item__c> ilpli=[select id,ILid__c,AdjustedReceivedqty_c__c,sigmaerpdev2__Lot__c,Unit_Price__c,sigmaerpdev2__Inventory_Location_Product__c,sigmaerpdev2__Product_Received_date__c,sigmaerpdev2__AvailableAdjustedQty__c,Name,sigmaerpdev2__Bin__c,sigmaerpdev2__Delivered_Quantity__c,sigmaerpdev2__Inventory_Location__c,sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c,sigmaerpdev2__Product__c from sigmaerpdev2__Inventory_Location_Product_Line_Item__c where sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c=:toLocationId and sigmaerpdev2__Product__c=:proids and sigmaerpdev2__Inventory_Location_Product__c=:ilpc ];
            system.debug('ilpli'+ilpli);
            list<sigmaerpdev2__Vendor_Product__c> svp=[select id,sigmaerpdev2__Buying_Price__c,sigmaerpdev2__Is_Preferred__c,sigmaerpdev2__Product_Name__c from sigmaerpdev2__Vendor_Product__c where sigmaerpdev2__Is_Preferred__c=true and sigmaerpdev2__Product_Name__c=:proids];
            for(sigmaerpdev2__Vendor_Product__c vps:svp)
            {
                vps1.put(vps.sigmaerpdev2__Product_Name__c,vps.sigmaerpdev2__Buying_Price__c);
            }
            list<sigmaerpdev2__Inventory_Location_Product_Line_Item__c> ilplinew=new list<sigmaerpdev2__Inventory_Location_Product_Line_Item__c>();
            
            for(Product_Transfer_Inventory_Tracking__c productRequestLineItem1 : prodInvTrkList){
                if(productRequestLineItem1.Product__r.Stock_Item__c == true && productRequestLineItem1.Product__r.Attribute_Type__c == 'BULK' && productRequestLineItem1.sigmaerpdev2__Received_qty__c!=null){
                    Inventory_Location_Product_Line_Item__c tempPS1 = new Inventory_Location_Product_Line_Item__c();
                    tempPS1.Product__c = productRequestLineItem1.sigmaerpdev2__Product__c;
                    //tempPS1.AvailableAdjustedQty__c = -productRequestLineItem1.Quantity__c;
                    tempPS1.AdjustedReceivedqty_c__c = productRequestLineItem1.sigmaerpdev2__Received_qty__c;
                    tempPS1.Product_Received_date__c=system.today();
                    tempPS1.Inventory_Location__c = ilc[0].id;
                    tempPS1.Inventory_Location_Product__c = prodct.get(productRequestLineItem1.Product__c);
                    tempPS1.Bin__c = tobinTransfer;
                    tempPS1.Stock_Type__c='Moved IN';
                    tempPS1.Unit_Price__c=vps1.get(productRequestLineItem1.Product__c);
                    if(productRequestLineItem1.sigmaerpdev2__Lot__c!=null){
                        tempPS1.sigmaerpdev2__Lot__c=productRequestLineItem1.sigmaerpdev2__Lot__c;
                        system.debug('tempPS1'+tempPS1.sigmaerpdev2__Lot__c);
                    }
                    system.debug('prodct'+prodct);
                    ilplinew.add(tempPS1);
                }else if(productRequestLineItem1.Product__r.Stock_Item__c == true && productRequestLineItem1.Product__r.Attribute_Type__c == 'SERIALIZED' && productRequestLineItem1.sigmaerpdev2__Received_qty__c!=null){
                    
                    for(Integer k=0;k<productRequestLineItem1.sigmaerpdev2__Received_qty__c;k++){
                        //psns.put(productRequestLineItem1.sigmaerpdev2__Product__c,ilpliList[k].sigmaerpdev2__Product_Serial_Number__c);
                        system.debug('k===='+k);
                        Inventory_Location_Product_Line_Item__c tempPS1 = new Inventory_Location_Product_Line_Item__c();
                        tempPS1.Product__c = productRequestLineItem1.sigmaerpdev2__Product__c;
                        //tempPS1.AvailableAdjustedQty__c = -1;
                        tempPS1.AdjustedReceivedqty_c__c = 1;
                        tempPS1.Product_Received_date__c = system.today();
                        tempPS1.Inventory_Location__c = ilc[0].id;
                        tempPS1.Inventory_Location_Product__c = prodct.get(productRequestLineItem1.Product__c);
                        tempPS1.Bin__c = tobinTransfer;
                        tempPS1.Stock_Type__c='Moved IN';
                        tempPS1.Unit_Price__c=vps1.get(productRequestLineItem1.Product__c);
                        if(productRequestLineItem1.sigmaerpdev2__Received_qty__c!=null && productRequestLineItem1.sigmaerpdev2__Received_qty__c!=0){
                            tempPS1.sigmaerpdev2__Product_Serial_Number__c=productRequestLineItem1.sigmaerpdev2__Product_Serial_Number__c;
                            system.debug('tempPS1.sigmaerpdev2__Product_Serial_Number__c'+tempPS1.sigmaerpdev2__Product_Serial_Number__c);     
                        }
                        if(productRequestLineItem1.sigmaerpdev2__Lot__c!=null){
                            tempPS1.sigmaerpdev2__Lot__c=productRequestLineItem1.sigmaerpdev2__Lot__c;
                            system.debug('tempPS1'+tempPS1.sigmaerpdev2__Lot__c);
                        }
                        system.debug('prodct'+prodct);
                        ilplinew.add(tempPS1);
                    }
                } 
            }
            system.debug('ilplinew==='+ilplinew);
            system.debug('ilplinew size==='+ilplinew.size());
            if(ilplinew.size() > 0){
                insert ilplinew;
                system.debug('ilpli'+ilplinew);
            } 
            //ilpli code ends here
            
            //code for to lot location
            set<id> lotss=new set<id>();
            set<id> ils=new set<id>();
            Map<Id,Map<Id,Decimal>>  LotqtymapLoc = new Map<Id,Map<Id,Decimal>>();
            List<Lot_Product__c> LOtPrdTO=new List<Lot_Product__c>(); // updating Lsit of Lotproduct
            map<id,id> toilpliid=new map<id,id>();
            map<id,id>topsnid=new map<id,id>();
            Map<Id,Id> maplotproforBin = new Map<Id,Id>();
            Map<Id,Id> maplotproforIL = new Map<Id,Id>();
            Map<Id,Id> maplotpro= new Map<Id,Id>();
            List<ID> lotProdTo=new List<ID>(); //26/9/2020
            String binId;
            for(Inventory_Location_Product_Line_Item__c indILPLI1 : ilplinew){
                system.debug('ilplinew'+ilplinew);
                lotProdTo.add(indILPLI1.Product__c); //26/09/2020
                system.debug('lotProdTo>>>'+lotProdTo); //26/09/2020
                binId = indILPLI1.Bin__c; //27/09/2020
                system.debug('binId>>'+binId);
                lotss.add(indILPLI1.sigmaerpdev2__Lot__c);
                system.debug('lotss'+lotss);
                ils.add(indILPLI1.Inventory_Location__c);
                system.debug('ils'+ils);
                toilpliid.put(indILPLI1.sigmaerpdev2__Lot__c,indILPLI1.id); 
                system.debug('toilpliid'+toilpliid);
                topsnid.put(indILPLI1.sigmaerpdev2__Product_Serial_Number__c,indILPLI1.id);
                system.debug('topsnid'+topsnid);
                maplotpro.put(indILPLI1.sigmaerpdev2__Lot__c,indILPLI1.Product__c);
                system.debug('maplotpro'+maplotpro);
                maplotproforBin.put(indILPLI1.sigmaerpdev2__Lot__c,indILPLI1.Bin__c);
                system.debug('maplotproforBin'+maplotproforBin);
                maplotproforIL.put(indILPLI1.sigmaerpdev2__Lot__c,indILPLI1.Inventory_Location__c);
                system.debug('maplotproforIL'+maplotproforIL);
                if(LotqtymapLoc.containsKey(indILPLI1.sigmaerpdev2__Lot__c)){
                    system.debug('innnnnnn'+LotqtymapLoc.containsKey(indILPLI1.sigmaerpdev2__Lot__c));
                    
                    system.debug('before going to if'+LotqtymapLoc.get(indILPLI1.sigmaerpdev2__Lot__c).containskey(indILPLI1.Inventory_Location__c));
                    if(LotqtymapLoc.get(indILPLI1.sigmaerpdev2__Lot__c).containskey(indILPLI1.Inventory_Location__c)){
                        decimal oldval = LotqtymapLoc.get(indILPLI1.Lot__c).get(indILPLI1.Inventory_Location__c);
                        system.debug('oldval'+oldval);
                        decimal newval = oldval + indILPLI1.AdjustedReceivedqty_c__c;
                        system.debug('newval'+newval);
                        LotqtymapLoc.get(indILPLI1.Lot__c).put(indILPLI1.Inventory_Location__c,newval);
                    }
                    
                    else{
                        system.debug('imm');
                        LotqtymapLoc.get(indILPLI1.Lot__c).put(indILPLI1.Inventory_Location__c,indILPLI1.AdjustedReceivedqty_c__c);
                    }
                }
                else{
                    system.debug('innnns');
                    Map<Id,Decimal>  Locqty = new Map<Id,Decimal>();
                    Locqty.put(indILPLI1.Inventory_Location__c,indILPLI1.AdjustedReceivedqty_c__c);
                    LotqtymapLoc.put(indILPLI1.Lot__c,Locqty);
                    system.debug('<<LotLocationupdate>>'+LotqtymapLoc.put(indILPLI1.Lot__c,Locqty));
                }
                
                if(indILPLI1.Product_Serial_Number__c!=null)
                    
                { 
                    Product_Serial_Number__c psnlocItem = new Product_Serial_Number__c();
                    psnlocItem.Id = indILPLI1.Product_Serial_Number__c;
                    psnlocItem.Inventory_Location__c = ilc[0].id;
                    psnlocItem.Bin__c =tobinTransfer;
                    psnlocItem.Inventory_Location_Product__c = prodct.get(indILPLI1.Product__c);
                    psnLoc.add(psnlocItem); 
                    system.debug('psnlocItem'+psnlocItem);
                    
                }
                
            }
            update psnLoc;
            
            List<Lot_Product__c> LPDataTo = new List<Lot_Product__c>();
            system.debug('proids'+proids);
            system.debug('ilc'+ilc);
            LPDataTo = [select id,Product__c,Quantity__c,Location__c,Lot__c,Bin__c from Lot_Product__c where Lot__c = : LotqtymapLoc.keySet() AND Product__c =: lotProdTo];
            system.debug('LPDataTo'+LPDataTo);
            Map<Id,Map<Id,Lot_Product__c>>  LotqtymapLocTo = new Map<Id,Map<Id,Lot_Product__c>>();
            for(Lot_Product__c lpTo: LPDataTo){
                system.debug('Iterating LPDATATO>>'+lpTo);
                system.debug('checking Lot__c>>'+LotqtymapLocTo.containsKey(lpTo.Lot__c));        
                if(LotqtymapLocTo.containsKey(lpTo.Lot__c))
                {
                    system.debug('lpTo.sigmaerpdev2__Bin__c == binId'+lpTo.sigmaerpdev2__Bin__c == binId); 
                    if(lpTo.sigmaerpdev2__Bin__c == binId){
                        system.debug('LotqtymapLocTo'+LotqtymapLocTo.get(lpTo.Lot__c).containsKey(lpTo.Bin__c));                    
                        if(LotqtymapLocTo.get(lpTo.Lot__c).containsKey(lpTo.Bin__c))
                        {
                            system.debug('Do nothing');
                        }
                        else
                        {
                            system.debug('inside else1>>>');
                            Map<Id,Lot_Product__c>  LocqtyTo = new Map<Id,Lot_Product__c>();
                            LocqtyTo.put(lpTo.Bin__c,lpTo);
                            LotqtymapLocTo.put(lpTo.Lot__c,LocqtyTo);
                            system.debug('after adding LocqtyTo2>>>>'+LocqtyTo);
                            system.debug('after adding LotqtymapLocTo2>>>>'+LotqtymapLocTo);
                        }
                    }
                }
                else
                {
                    system.debug('inside else2>>>');
                    Map<Id,Lot_Product__c>  LocqtyTo = new Map<Id,Lot_Product__c>();
                    LocqtyTo.put(lpTo.Bin__c,lpTo);
                    LotqtymapLocTo.put(lpTo.Lot__c,LocqtyTo);
                    system.debug('after adding LocqtyTo3>>>>'+LocqtyTo);
                    system.debug('after adding LotqtymapLocTo3>>>>'+LotqtymapLocTo);
                }
                system.debug('LotqtymapLocTo'+LotqtymapLocTo);
            }
            for(Id LotMapID: LotqtymapLoc.keyset()){
                system.debug('LotMapID'+LotMapID);
                system.debug('LotqtymapLocTo.containsKey(LotMapID)>>>'+LotqtymapLocTo.containsKey(LotMapID));
                system.debug('LotqtymapLocTo.get(LotMapID)>>>'+LotqtymapLocTo.get(LotMapID));
                system.debug('maplotproforBin.get(LotMapID)>>'+maplotproforBin.get(LotMapID));
                //  system.debug('Before=entering=into=if=condition'+LotqtymapLocTo.get(LotMapID).containsKey(maplotproforBin.get(LotMapID)));
                // if(lpTo.Bin__c==maplotproforBin.get(LotMapID)){
                if(LotqtymapLocTo.containsKey(LotMapID) && LotqtymapLocTo.get(LotMapID).containsKey(maplotproforBin.get(LotMapID))){
                    system.debug('lots'+LotqtymapLocTo.get(LotMapID).containsKey(maplotproforBin.get(LotMapID)));
                    Lot_Product__c lpToupdate = LotqtymapLocTo.get(LotMapID).get(maplotproforBin.get(LotMapID));
                    lpToupdate.Quantity__c = lpToupdate.Quantity__c+LotqtymapLoc.get(LotMapID).get(lpToupdate.Location__c);
                    system.debug('lpToupdate'+lpToupdate);
                    LOtPrdTO.add(lpToupdate);
                    system.debug('after adding LOtPrdTO1>>>'+LOtPrdTO);
                }
                else{
                    system.debug('innnnn');
                    Lot_Product__c lp = new Lot_Product__c();
                    lp.Product__c = maplotpro.get(LotMapID);
                    lp.Quantity__c = LotqtymapLoc.get(LotMapID).get(maplotproforIL.get(LotMapID));
                    lp.Lot__c = LotMapID;
                    lp.Location__c = maplotproforIL.get(LotMapID);
                    lp.Bin__c=maplotproforBin.get(LotMapID);
                    LOtPrdTO.add(lp);
                    system.debug('after adding LOtPrdTO2>>>'+LOtPrdTO);
                }
            }
            
            system.debug('before LOtPrdTO size'+LOtPrdTO.size());
            if(LOtPrdTO.size()>0) {
                try{
                    
                    upsert LOtPrdTO;
                    system.debug('after LOtPrdTO size'+LOtPrdTO.size());
                    system.debug('after LOtPrdTO '+LOtPrdTO);
                } catch(Exception e){
                    System.debug('Error while upserting LOtPrdTO :'+e.getDMLMessage(0));
                }
            } 
            
            
            //   upsert LOtPrdTO;
            
            //code end here    
            //new code to reduce ILP quantities from FROM LOC after transfer is completed 
            List<Inventory_Location_Product__c> ilpList = [select Id,Deliver_Quantity__c,AvailableAdjustedQty__c,Inventory__c from Inventory_Location_Product__c 
                                                           where Id in :ILPReduceQtyMap.keySet()]; 
            
            for(Inventory_Location_Product__c ilpObj1 : ilpList){
                //ilpObj.Deliver_Quantity__c += ILPReduceQtyMap.get(ilpObj.Id);
                ilpObj1.AvailableAdjustedQty__c += ILPReduceQtyMap.get(ilpObj1.Id);
            }            
            update ilpList;
            system.debug('ilpList'+ilpList);
            //ends here
            
            //FINANCE STARTS HERE
            
            Set<Id> fromIlpliSet = new Set<Id>();
            Set<Id> toIlpliSet = new Set<Id>();
            List<Product_Transfer_Inventory_Tracking__c> prodInvTrkList1 = [select Id,Lot__c,To_ilpli__c,Inventory_Location_Product_Line_Item__c,
                                                                            Product_Transfer__c,Product_Transfer__r.Transfer_Status__c,Product__r.Attribute_Type__c,sigmaerpdev2__Received_qty__c,Transferred_Qty__c,Product__r.Stock_Item__c,sigmaerpdev2__Product__c,Product_Serial_Number__c from Product_Transfer_Inventory_Tracking__c where Product_Transfer__c = :prliId and Inventory_Location_Product_Line_Item__c=:ilpliSelMap.keySet()];
            system.debug('prodInvTrkList1'+prodInvTrkList1);
            for(Product_Transfer_Inventory_Tracking__c ilpObj : prodInvTrkList1){
                system.debug('ilpObj'+ilpObj);    
                if(ilpObj.Product_Serial_Number__c!=null)
                {
                    ilpObj.To_ilpli__c=topsnid.get(ilpObj.Product_Serial_Number__c);
                    system.debug('inn'+ilpObj.To_ilpli__c);
                }else{
                    ilpObj.To_ilpli__c =toilpliid.get(ilpObj.Lot__c);
                    system.debug('inn'+ilpObj.To_ilpli__c);
                }
            } 
            if(prodInvTrkList1.size() > 0)
            {           
                update prodInvTrkList1;
                
            }
            system.debug('prodInvTrkList1'+prodInvTrkList1);
            
            for(Product_Transfer_Inventory_Tracking__c ilpObj2 : prodInvTrkList1){
                system.debug('ilpObj2>>'+ilpObj2.sigmaerpdev2__Product_Transfer__r.sigmaerpdev2__Transfer_Status__c);
                 if(ilpObj2.sigmaerpdev2__Product_Transfer__r.sigmaerpdev2__Transfer_Status__c == 'Product Verified')
                 {
                fromIlpliSet.add(ilpObj2.Inventory_Location_Product_Line_Item__c);
                system.debug('fromIlpliSet1'+fromIlpliSet);
                toIlpliSet.add(ilpObj2.To_ilpli__c);
                system.debug('toIlpliSet1'+toIlpliSet);
                     }
            }
          //  LinkageServiceClass.LinkProductTransfer(prodInvTrkList1,fromIlpliSet,toIlpliSet);
            //ends here
            
            
            
            
            
        }
        
        
        catch(Exception e){
            System.debug('Exception Occured'+e);
        }
        
    }
}