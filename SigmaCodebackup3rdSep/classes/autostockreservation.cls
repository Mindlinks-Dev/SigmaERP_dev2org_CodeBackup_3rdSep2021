public with sharing class autostockreservation {
    public static void autostockreserve(List<Product_Order_Price_Book__c>solDataToSave)
    {
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')  
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c') 
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Serial_Number__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')

        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev__IsInventoryUpdated__c','sigmaerpdev__Product__c','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Order_Status__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new Set<String>{'id','name','ProductCode__c','Reserved_Qty__c','Available_Qty__c','Delivered_Qty__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'id','name','sigmaerpdev__Available_Quantity__c','sigmaerpdev__Reserved_Quantity__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Products__c','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Serial_Number__c','sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Status__c','sigmaerpdev__Received_Date__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.name','sigmaerpdev__Lot__c','sigmaerpdev__Lot__r.Name','sigmaerpdev__Inventory_Location_Product__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'id','name','sigmaerpdev__Status__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'id','name','sigmaerpdev__Reserved_Quantity__c','sigmaerpdev__Source_Type__c','sigmaerpdev__Deliver_Quantity__c'})

        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'sigmaerpdev__IsInventoryUpdated__c','sigmaerpdev__Product__c','sigmaerpdev__Net_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new Set<String>{'sigmaerpdev__Reserved_Qty__c','sigmaerpdev__Available_Qty__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Allocation__c',new Set<String>{'sigmaerpdev__ILPLI__c','sigmaerpdev__Order_Line__c','sigmaerpdev__Quantity__c'}) 
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'sigmaerpdev__Status__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev__Reserved_Quantity__c','sigmaerpdev__Source_Type__c','sigmaerpdev__Deliver_Quantity__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'sigmaerpdev__Reserved_Quantity__c'})
        )
        {*/
            List<Product_Order_Price_Book__c> solListToUpdateAsAllocated = new List<Product_Order_Price_Book__c>();
            Map<Id,Decimal> productQuantityMap=new Map<Id,Decimal>();
            Map<Id,Decimal> orderlinequnt = new map<Id,Decimal>();
            Map<Id,Decimal> nopickproductQuantityMap=new Map<Id,Decimal>();
            Map<Id,decimal> maplotproforBin = new Map<Id,decimal>();
            Map<id,Map<id,decimal>> lotqtyupdate=new Map<id,Map<id,decimal>>();
            
            List<Id>orderlineid = new List<Id>();
            set<Id>productid = new set<Id>();
            String OrderCreatedVia;
            System.debug('solDataToSave>>'+solDataToSave);
            for(Product_Order_Price_Book__c sol:solDataToSave)
            {
                OrderCreatedVia = sol.Sigma_Order__r.Order_Created_Via__c;
                if(sol.IsInventoryUpdated__c == false)
                {
                    if(sol.Sigma_Order__r.No_Picking_Package_Shipment_Required__c || sol.Inventory_Status__c =='Allocated')
                    {
                        if(nopickproductQuantityMap.containsKey(sol.Product__c))
                        {
                            nopickproductQuantityMap.put(sol.Product__c,(nopickproductQuantityMap.get(sol.Product__c)+sol.Net_Quantity__c));
                        }
                        else
                        {
                            nopickproductQuantityMap.put(sol.Product__c,sol.Net_Quantity__c);
                        }
                    }
                    else
                    {
                         if(productQuantityMap.containsKey(sol.Product__c))
                        {
                            productQuantityMap.put(sol.Product__c,(productQuantityMap.get(sol.Product__c)+sol.Net_Quantity__c));
                        }
                        else
                        {
                            productQuantityMap.put(sol.Product__c,sol.Net_Quantity__c);
                        }
                    }
                   
                    orderlinequnt.put(sol.id,sol.Net_Quantity__c);
                    productid.add(sol.Product__c);
                }
                solListToUpdateAsAllocated.add(sol);
            }
            //Updating PI
            List<Inventory__c> inventory=[select id,name,Comments__c,ProductCode__c,Reserved_Qty__c,Available_Qty__c,Delivered_Qty__c from Inventory__c where ProductCode__c =:productid];
            
            map<Id,Boolean>inventoryupdated = new map<Id,Boolean>();
            for(Inventory__c tempInv:inventory)
            {
                if(productQuantityMap.size()>0)
                {
                     if(tempInv.Available_Qty__c >=productQuantityMap.get(tempInv.ProductCode__c))
                    {
                        if(tempInv.Reserved_Qty__c==null)
                        tempInv.Reserved_Qty__c=0;
                        tempInv.Reserved_Qty__c+=productQuantityMap.get(tempInv.ProductCode__c);
                       tempInv.Available_Qty__c-=productQuantityMap.get(tempInv.ProductCode__c); 
                    
                    }
                }
                if(nopickproductQuantityMap.size()>0)
                {
                     if(tempInv.Available_Qty__c >=nopickproductQuantityMap.get(tempInv.ProductCode__c))
                    {
                        
                        tempInv.Delivered_Qty__c+=nopickproductQuantityMap.get(tempInv.ProductCode__c);
                        tempInv.Available_Qty__c-=nopickproductQuantityMap.get(tempInv.ProductCode__c); 
                    
                    }
                }
                if(OrderCreatedVia == 'Community')
                tempInv.Comments__c = 'Inventory Reduced because "order created" via "community" ';
               
                
            }
            if(inventory.size()>0)
            {
                update inventory;
            }
            //fetching ILPLI
            List<Inventory_Location_Product_Line_Item__c> ilpliDataRecieveData= [Select id,name,Available_Quantity__c,Reserved_Quantity__c,Inventory_Location_Product__r.Products__c,Product_Serial_Number__r.Serial_Number__c,Product_Serial_Number__c  ,Product_Serial_Number__r.Status__c,Received_Date__c,Inventory_Location_Product__r.Inventory_Location__r.Location__r.name,Lot__c,Lot__r.Name,Inventory_Location_Product__c,Delivered_Quantity__c,Bin__c from Inventory_Location_Product_Line_Item__c  where Inventory_Location_Product__r.Products__c=:productid and  Available_Quantity__c>0 ORDER BY Product_Expiry_Date__c ASC NULLS LAST,Product_Received_date__c ASC NULLS LAST];
            system.debug('ilpliDataRecieveData@'+ilpliDataRecieveData);
            Map<id,decimal> ILPLIIdQuantMap1 = new Map<id,decimal>();
            Map<Id,Inventory_Location_Product_Line_Item__c> ilpliIdILPLIMapToUpdate1=new Map<Id,Inventory_Location_Product_Line_Item__c>();
            Map<Id,decimal> ILPQuant= new Map<id,decimal>();
            Map<Id,decimal> LotQuant= new Map<id,decimal>();
            Map<Id,decimal> ILPQuantNoPick= new Map<id,decimal>();
            set<Id> Serialid =new set<Id>();
            set<Id> NopickSerialid =new set<Id>();
            set<Id>LOTID = new set<Id>();
            List<Inventory_Allocation__c> IAListToInsert=new List<Inventory_Allocation__c>();
            for(Integer i=0;i<solDataToSave.size();i++)
            {
                Decimal solQuantCount=solDataToSave[i].Net_Quantity__c;
                Boolean nopickpack = solDataToSave[i].Sigma_Order__r.No_Picking_Package_Shipment_Required__c;
                if(solDataToSave[i].Order_Status__c=='Order Confirmed' && !solDataToSave[i].IsInventoryUpdated__c)
                {
                    for(Inventory_Location_Product_Line_Item__c ilpli:ilpliDataRecieveData)
                    {
                        if(ILPLIIdQuantMap1.containsKey(ilpli.id) ? ILPLIIdQuantMap1.get(ilpli.id)!=ilpli.Available_Quantity__c :true)
                        {
                            
                            if(solQuantCount==0)
                                Break;
                            if(ilpli.Inventory_Location_Product__r.Products__c==solDataToSave[i].Product__c)
                            {
                                 
                                if(ilpli.Product_Serial_Number__c!=null)
                                {
                                    if(nopickpack || solDataToSave[i].Inventory_Status__c =='Allocated')
                                    {
                                        NopickSerialid.add(ilpli.Product_Serial_Number__c);
                                    }
                                    else
                                    {
                                        Serialid.add(ilpli.Product_Serial_Number__c);
                                    }
                                     
                                }
                                
                                if(ilpli.Lot__c != null)
                                {
                                    LOTID.add(ilpli.Lot__c);
                                }
                                
                                if(nopickpack || solDataToSave[i].Inventory_Status__c =='Allocated')
                                {
                                    if(ilpli.Available_Quantity__c>=nopickproductQuantityMap.get(solDataToSave[i].Product__c))
                                    {
                                        
                                        system.debug('orderlinequntIA@@'+orderlinequnt);
                                        Inventory_Allocation__c indIA=new Inventory_Allocation__c();
                                        indIA.ILPLI__c=ilpli.id;
                                        indIA.Order_Line__c=solDataToSave[i].id;
                                        indIA.Quantity__c=orderlinequnt.get(indIA.Order_Line__c);
                                        IAListToInsert.add(indIA);
                                        if(orderlineid.contains(indIA.Order_Line__c))
                                        {
                                            //do nothing
                                        }
                                        else
                                        {
                                            orderlineid.add(indIA.Order_Line__c);
                                        }
                                        system.debug('orderlineidif@@'+orderlineid);
                                        inventoryupdated.put(indIA.Order_Line__c,true);
                                        if(ilpliIdILPLIMapToUpdate1.containsKey(ilpli.id)){
                                            ILPLIIdQuantMap1.put(ilpli.id,ILPLIIdQuantMap1.get(ilpli.id)+nopickproductQuantityMap.get(solDataToSave[i].Product__c));
                                        }
                                        else{
                                            ILPLIIdQuantMap1.put(ilpli.id,nopickproductQuantityMap.get(solDataToSave[i].Product__c));
                                        }
                                        
                                        if(ilpliIdILPLIMapToUpdate1.containsKey(ilpli.id)){
                                            Inventory_Location_Product_Line_Item__c tempILPLI=ilpliIdILPLIMapToUpdate1.get(ilpli.id);
                                            
                                            tempILPLI.Delivered_Quantity__c+=nopickproductQuantityMap.get(solDataToSave[i].Product__c);
                                            ilpliIdILPLIMapToUpdate1.put(ilpli.id,tempILPLI);
                                        }
                                        else{
                                            
                                            ilpli.Delivered_Quantity__c+=nopickproductQuantityMap.get(solDataToSave[i].Product__c);
                                            ilpliIdILPLIMapToUpdate1.put(ilpli.id,ilpli);
                                        }
                                        
                                        if(ILPQuantNoPick.containsKey(ilpli.Inventory_Location_Product__c))
                                        {
                                            
                                            ILPQuantNoPick.put(ilpli.Inventory_Location_Product__c,ILPQuantNoPick.get(ilpli.Inventory_Location_Product__c)+nopickproductQuantityMap.get(solDataToSave[i].Product__c));
                                            
                                        }
                                        else
                                        {
                                            
                                            ILPQuantNoPick.put(ilpli.Inventory_Location_Product__c,nopickproductQuantityMap.get(solDataToSave[i].Product__c));
                                            
                                        }
                                        
                                        //LOT for Allocated
                                        
                                        if(LotQuant.containsKey(ilpli.Lot__c))
                                        {
                                           
                                            LotQuant.put(ilpli.Lot__c,LotQuant.get(ilpli.Lot__c)+nopickproductQuantityMap.get(solDataToSave[i].Product__c));
                                           
                                        }
                                        else if(LOTID.size()>0)
                                        {
                                           
                                            LotQuant.put(ilpli.Lot__c,nopickproductQuantityMap.get(solDataToSave[i].Product__c));
                                            
                                        }
                                        
                                        if(maplotproforBin.containsKey(ilpli.Bin__c))
                                        {
                                            system.debug('Inside if Condition');
                                            maplotproforBin.put(ilpli.Bin__c,maplotproforBin.get(ilpli.Bin__c)+nopickproductQuantityMap.get(solDataToSave[i].Product__c));
                                            
                                            system.debug('maplotproforBin '+maplotproforBin);
                                        }
                                        else
                                        {
                                            maplotproforBin.put(ilpli.Bin__c,nopickproductQuantityMap.get(solDataToSave[i].Product__c));
                                            system.debug('maplotproforBinelse@@'+maplotproforBin);
                                        }
                                        
                                        if(LOTID.size()>0)
                                        {
                                        if(lotqtyupdate.containsKey(ilpli.Lot__c))
                                        {
                                            if(lotqtyupdate.get(ilpli.Lot__c).containsKey(ilpli.Bin__c))
                                            {
                                                decimal qty=lotqtyupdate.get(ilpli.Lot__c).get(ilpli.Bin__c);
                                                lotqtyupdate.get(ilpli.Lot__c).put(ilpli.Bin__c,qty+nopickproductQuantityMap.get(solDataToSave[i].Product__c));
                                            }
                                            else
                                            {
                                                Map<id,decimal> locid=new Map<id,decimal>();
                                                lotqtyupdate.get(ilpli.Lot__c).put(ilpli.Bin__c,nopickproductQuantityMap.get(solDataToSave[i].Product__c));
                                            }
                                        }
                                        else
                                        {
                                            Map<id,decimal> locid=new Map<id,decimal>();
                                            locid.put(ilpli.Bin__c,nopickproductQuantityMap.get(solDataToSave[i].Product__c));
                                            lotqtyupdate.put(ilpli.Lot__c,locid);
                                        }
                                        }
                                        
                                        
                                        
                                       
                                        solQuantCount-=nopickproductQuantityMap.get(solDataToSave[i].Product__c);
                                        nopickproductQuantityMap.put(ilpli.Inventory_Location_Product__r.Products__c,0);
                                        orderlinequnt.put(solDataToSave[i].id,0);
                                    }
                                    else
                                    {
                                        decimal tempQuant=ilpli.Available_Quantity__c;
                                        Inventory_Allocation__c indIA=new Inventory_Allocation__c();
                                        indIA.ILPLI__c=ilpli.id;
                                        indIA.Order_Line__c=solDataToSave[i].id;
                                        indIA.Quantity__c=tempQuant;
                                        IAListToInsert.add(indIA);
                                        if(orderlineid.contains(indIA.Order_Line__c))
                                        {
                                            //do nothing
                                        }
                                        else
                                        {
                                            orderlineid.add(indIA.Order_Line__c);
                                        }
                                        system.debug('orderlineidelse@@'+orderlineid);
                                        inventoryupdated.put(indIA.Order_Line__c,true);
                                        if(ilpliIdILPLIMapToUpdate1.containsKey(ilpli.id)){
                                            ILPLIIdQuantMap1.put(ilpli.id,ILPLIIdQuantMap1.get(ilpli.id)+tempQuant);
                                        }
                                        else{
                                            ILPLIIdQuantMap1.put(ilpli.id,tempQuant);
                                        }
                                        if(ilpliIdILPLIMapToUpdate1.containsKey(ilpli.id)){
                                            Inventory_Location_Product_Line_Item__c tempILPLI=ilpliIdILPLIMapToUpdate1.get(ilpli.id);
                                            tempILPLI.Delivered_Quantity__c+=tempQuant;
                                            ilpliIdILPLIMapToUpdate1.put(ilpli.id,tempILPLI);
                                        }
                                        else{
                                            ilpli.Delivered_Quantity__c+=tempQuant;
                                            ilpliIdILPLIMapToUpdate1.put(ilpli.id,ilpli);
                                        }
                                        if(ILPQuantNoPick.containsKey(ilpli.Inventory_Location_Product__c))
                                        {
                                            ILPQuantNoPick.put(ilpli.Inventory_Location_Product__c,ILPQuantNoPick.get(ilpli.Inventory_Location_Product__c)+tempQuant);
                                        }
                                        else
                                        {
                                            ILPQuantNoPick.put(ilpli.Inventory_Location_Product__c,tempQuant);
                                        }
                                        //LOT for Allocated
                                        if(LotQuant.containsKey(ilpli.Lot__c))
                                        {
                                            LotQuant.put(ilpli.Lot__c,LotQuant.get(ilpli.Lot__c)+nopickproductQuantityMap.get(solDataToSave[i].Product__c));
                                        }
                                        else if(LOTID.size()>0)
                                        {
                                           LotQuant.put(ilpli.Lot__c,nopickproductQuantityMap.get(solDataToSave[i].Product__c));
                                        }
                                        if(maplotproforBin.containsKey(ilpli.Bin__c))
                                        {
                                            system.debug('Inside if Condition');
                                            maplotproforBin.put(ilpli.Bin__c,maplotproforBin.get(ilpli.Bin__c)+tempQuant);
                                            
                                            system.debug('maplotproforBin '+maplotproforBin);
                                        }
                                        else
                                        {
                                            maplotproforBin.put(ilpli.Bin__c,tempQuant);
                                            system.debug('maplotproforBinelse@@'+maplotproforBin);
                                        }
                                        
                                        if(LOTID.size()>0)
                                        {
                                        if(lotqtyupdate.containsKey(ilpli.Lot__c))
                                        {
                                            if(lotqtyupdate.get(ilpli.Lot__c).containsKey(ilpli.Bin__c))
                                            {
                                                decimal qty=lotqtyupdate.get(ilpli.Lot__c).get(ilpli.Bin__c);
                                                lotqtyupdate.get(ilpli.Lot__c).put(ilpli.Bin__c,qty+tempQuant);
                                            }
                                            else
                                            {
                                                Map<id,decimal> locid=new Map<id,decimal>();
                                                lotqtyupdate.get(ilpli.Lot__c).put(ilpli.Bin__c,tempQuant);
                                            }
                                        }
                                        else
                                        {
                                            Map<id,decimal> locid=new Map<id,decimal>();
                                            locid.put(ilpli.Bin__c,tempQuant);
                                            lotqtyupdate.put(ilpli.Lot__c,locid);
                                        }
                                        }
                                        
                                        
                                        solQuantCount-=tempQuant;
                                        nopickproductQuantityMap.put(ilpli.Inventory_Location_Product__r.Products__c,nopickproductQuantityMap.get(ilpli.Inventory_Location_Product__r.Products__c)-tempQuant);
                                        orderlinequnt.put(solDataToSave[i].id,orderlinequnt.get(solDataToSave[i].id)-tempQuant);
                                    }
                                }
                                else
                                {
                                    if(ilpli.Available_Quantity__c>=productQuantityMap.get(solDataToSave[i].Product__c))
                                    {
                                        
                                       system.debug('orderlinequntIA@@'+orderlinequnt);
                                        Inventory_Allocation__c indIA=new Inventory_Allocation__c();
                                        indIA.ILPLI__c=ilpli.id;
                                        indIA.Order_Line__c=solDataToSave[i].id;
                                        indIA.Quantity__c=orderlinequnt.get(indIA.Order_Line__c);
                                        IAListToInsert.add(indIA);
                                        if(orderlineid.contains(indIA.Order_Line__c))
                                        {
                                            //do nothing
                                        }
                                        else
                                        {
                                            orderlineid.add(indIA.Order_Line__c);
                                        }
                                        system.debug('orderlineidif@@'+orderlineid);
                                        inventoryupdated.put(indIA.Order_Line__c,true);
                                        if(ilpliIdILPLIMapToUpdate1.containsKey(ilpli.id)){
                                            ILPLIIdQuantMap1.put(ilpli.id,ILPLIIdQuantMap1.get(ilpli.id)+productQuantityMap.get(solDataToSave[i].Product__c));
                                        }
                                        else{
                                            ILPLIIdQuantMap1.put(ilpli.id,productQuantityMap.get(solDataToSave[i].Product__c));
                                        }
                                        
                                        if(ilpliIdILPLIMapToUpdate1.containsKey(ilpli.id)){
                                            Inventory_Location_Product_Line_Item__c tempILPLI=ilpliIdILPLIMapToUpdate1.get(ilpli.id);
                                            if(tempILPLI.Reserved_Quantity__c==null)
                                                tempILPLI.Reserved_Quantity__c=0;
                                            tempILPLI.Reserved_Quantity__c+=productQuantityMap.get(solDataToSave[i].Product__c);
                                            ilpliIdILPLIMapToUpdate1.put(ilpli.id,tempILPLI);
                                        }
                                        else{
                                            if(ilpli.Reserved_Quantity__c==null)
                                                ilpli.Reserved_Quantity__c=0;
                                            ilpli.Reserved_Quantity__c+=productQuantityMap.get(solDataToSave[i].Product__c);
                                            ilpliIdILPLIMapToUpdate1.put(ilpli.id,ilpli);
                                        }
                                        
                                        if(ILPQuant.containsKey(ilpli.Inventory_Location_Product__c))
                                        {
                                            
                                            ILPQuant.put(ilpli.Inventory_Location_Product__c,ILPQuant.get(ilpli.Inventory_Location_Product__c)+productQuantityMap.get(solDataToSave[i].Product__c));
                                            
                                        }
                                        else
                                        {
                                            
                                            ILPQuant.put(ilpli.Inventory_Location_Product__c,productQuantityMap.get(solDataToSave[i].Product__c));
                                            
                                        }
                                        
                                        //LOT for Allocated
                                        
                                        if(LotQuant.containsKey(ilpli.Lot__c))
                                        {
                                           
                                            LotQuant.put(ilpli.Lot__c,LotQuant.get(ilpli.Lot__c)+productQuantityMap.get(solDataToSave[i].Product__c));
                                           
                                        }
                                        else if(LOTID.size()>0)
                                        {
                                           
                                            LotQuant.put(ilpli.Lot__c,productQuantityMap.get(solDataToSave[i].Product__c));
                                            
                                        }
                                        
                                        //end time
                                        if(maplotproforBin.containsKey(ilpli.Bin__c))
                                        {
                                            system.debug('Inside if Condition');
                                            maplotproforBin.put(ilpli.Bin__c,maplotproforBin.get(ilpli.Bin__c)+productQuantityMap.get(solDataToSave[i].Product__c));
                                            
                                            system.debug('maplotproforBin '+maplotproforBin);
                                        }
                                        else
                                        {
                                            maplotproforBin.put(ilpli.Bin__c,productQuantityMap.get(solDataToSave[i].Product__c));
                                            system.debug('maplotproforBinelse@@'+maplotproforBin);
                                        }
                                       
                                        solQuantCount-=productQuantityMap.get(solDataToSave[i].Product__c);
                                        productQuantityMap.put(ilpli.Inventory_Location_Product__r.Products__c,0);
                                        orderlinequnt.put(solDataToSave[i].id,0);
                                    }
                                    else
                                    {
                                        decimal tempQuant=ilpli.Available_Quantity__c;
                                        Inventory_Allocation__c indIA=new Inventory_Allocation__c();
                                        indIA.ILPLI__c=ilpli.id;
                                        indIA.Order_Line__c=solDataToSave[i].id;
                                        indIA.Quantity__c=tempQuant;
                                        IAListToInsert.add(indIA);
                                        if(orderlineid.contains(indIA.Order_Line__c))
                                        {
                                            //do nothing
                                        }
                                        else
                                        {
                                            orderlineid.add(indIA.Order_Line__c);
                                        }
                                        system.debug('orderlineidelse@@'+orderlineid);
                                        inventoryupdated.put(indIA.Order_Line__c,true);
                                        if(ilpliIdILPLIMapToUpdate1.containsKey(ilpli.id)){
                                            ILPLIIdQuantMap1.put(ilpli.id,ILPLIIdQuantMap1.get(ilpli.id)+tempQuant);
                                        }
                                        else{
                                            ILPLIIdQuantMap1.put(ilpli.id,tempQuant);
                                        }
                                        if(ilpliIdILPLIMapToUpdate1.containsKey(ilpli.id)){
                                            Inventory_Location_Product_Line_Item__c tempILPLI=ilpliIdILPLIMapToUpdate1.get(ilpli.id);
                                            tempILPLI.Reserved_Quantity__c+=tempQuant;
                                            ilpliIdILPLIMapToUpdate1.put(ilpli.id,tempILPLI);
                                        }
                                        else{
                                            ilpli.Reserved_Quantity__c+=tempQuant;
                                            ilpliIdILPLIMapToUpdate1.put(ilpli.id,ilpli);
                                        }
                                        if(ILPQuant.containsKey(ilpli.Inventory_Location_Product__c))
                                        {
                                            ILPQuant.put(ilpli.Inventory_Location_Product__c,ILPQuant.get(ilpli.Inventory_Location_Product__c)+tempQuant);
                                        }
                                        else
                                        {
                                            ILPQuant.put(ilpli.Inventory_Location_Product__c,tempQuant);
                                        }
                                        //LOT for Allocated
                                        if(LotQuant.containsKey(ilpli.Lot__c))
                                        {
                                            LotQuant.put(ilpli.Lot__c,LotQuant.get(ilpli.Lot__c)+productQuantityMap.get(solDataToSave[i].Product__c));
                                        }
                                        else if(LOTID.size()>0)
                                        {
                                           LotQuant.put(ilpli.Lot__c,productQuantityMap.get(solDataToSave[i].Product__c));
                                        }
                                        
                                        if(maplotproforBin.containsKey(ilpli.Bin__c))
                                        {
                                            system.debug('Inside if Condition');
                                            maplotproforBin.put(ilpli.Bin__c,productQuantityMap.get(ilpli.Bin__c)+tempQuant);
                                            
                                            system.debug('maplotproforBin '+maplotproforBin);
                                        }
                                        else
                                        {
                                            maplotproforBin.put(ilpli.Bin__c,tempQuant);
                                            system.debug('maplotproforBinelse@@'+maplotproforBin);
                                        }
                                        solQuantCount-=tempQuant;
                                        productQuantityMap.put(ilpli.Inventory_Location_Product__r.Products__c,productQuantityMap.get(ilpli.Inventory_Location_Product__r.Products__c)-tempQuant);
                                        orderlinequnt.put(solDataToSave[i].id,orderlinequnt.get(solDataToSave[i].id)-tempQuant);
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
            if(Serialid.size()>0)
            {
                List<Product_Serial_Number__c> serialststusupdate=new List<Product_Serial_Number__c>();
                serialststusupdate=[select id,name,Status__c from Product_Serial_Number__c where id=:Serialid];
                for(Product_Serial_Number__c serialstatus:serialststusupdate)
                {
                    serialstatus.Status__c='Allocate';
                }
                update serialststusupdate;
            }
            
            List<Lot_Product__c> lotproduct = [select id,Product__c,Quantity__c,Location__c,Lot__c,Bin__c from Lot_Product__c where Lot__c =: lotqtyupdate.keySet()]; 
            system.debug('aftr querrying lotproduct-->>'+lotproduct);
            system.debug('lotqtyupdate>>'+lotqtyupdate);
            
            for(Lot_Product__c LP : lotproduct ) 
            {
                if(lotqtyupdate.containsKey(LP.Lot__c))
                {
                    if(lotqtyupdate.get(LP.Lot__c).containsKey(LP.Bin__c))
                    {
                        LP.Quantity__c-=lotqtyupdate.get(LP.Lot__c).get(LP.Bin__c);
                    }
                } 
            }
            if(lotproduct.size()>0){
                update lotproduct;
            }
                
            if(NopickSerialid.size()>0)
            {
                List<Product_Serial_Number__c> nopickserialststusupdate=new List<Product_Serial_Number__c>();
                nopickserialststusupdate=[select id,name,Status__c from Product_Serial_Number__c where id=:NopickSerialid];
                for(Product_Serial_Number__c serialstatus:nopickserialststusupdate)
                {
                    serialstatus.Status__c='Used';
                }
                update nopickserialststusupdate;
            }   
            List<Inventory_Location_Product__c>updatesoldqunt=new List<Inventory_Location_Product__c>();
            List<Inventory_Location_Product__c>updateilpdeliver=new List<Inventory_Location_Product__c>();
            if(ILPQuant.size()>0)
            {
                updatesoldqunt=[select id,name,Reserved_Quantity__c,Source_Type__c,Delivered_Quantity__c from Inventory_Location_Product__c where id=:ILPQuant.keySet()];
                system.debug('Before Update'+updatesoldqunt);
                for(Inventory_Location_Product__c ILP:updatesoldqunt)
                {
                    
                    if(ILPQuant.size()>0)
                    {
                        ILP.Reserved_Quantity__c+=ILPQuant.get(ILP.id);
                    }
                
                    ILP.Source_Type__c = 'System';
                }
                update updatesoldqunt;
                system.debug('After Debug'+updatesoldqunt);
            }
            
            if(ILPQuantNoPick.size()>0)
            {
                updateilpdeliver=[select id,name,Reserved_Quantity__c,Source_Type__c,Deliver_Quantity__c from Inventory_Location_Product__c where id=:ILPQuantNoPick.keySet()];
                system.debug('Before Update'+updateilpdeliver);
                for(Inventory_Location_Product__c ILP:updateilpdeliver)
                {
                    if(ILPQuantNoPick.size()>0)
                    {
                        ILP.Deliver_Quantity__c+=ILPQuantNoPick.get(ILP.id);
                    }
                    ILP.Source_Type__c = 'System';
                }
                update updateilpdeliver;
                system.debug('After Debug'+updateilpdeliver);
            }
            
            if(ilpliIdILPLIMapToUpdate1.size()>0)
            {
                update ilpliIdILPLIMapToUpdate1.values();
            }
            if(IAListToInsert.size()>0)
            {
               Upsert IAListToInsert;
            }
            for(Product_Order_Price_Book__c tempSOL:solListToUpdateAsAllocated){
                system.debug('orderlineid@@'+orderlineid);
                if(orderlineid.contains(tempSOL.id))
                {
                    system.debug('in@@in');
                    tempSOL.IsInventoryUpdated__c=true;
                } 
            }
            if(solListToUpdateAsAllocated.size()>0){
            upsert solListToUpdateAsAllocated;
            }
       // }
    }
    public static void autostockreserveforOrder(List<OrderItem>solDataToSave)
    {
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('OrderItem')  
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c') 
        &&CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Allocation__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Serial_Number__c')
        && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product__c')

        && CRUD_FLS_CheckUtility.checkReadPermission('OrderItem',new Set<String>{'sigmaerpdev__IsInventoryUpdated__c','Quantity','sigmaerpdev__Order_Status__c','Product2'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new Set<String>{'id','name','ProductCode__c','Reserved_Qty__c','Available_Qty__c','Delivered_Qty__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'id','name','sigmaerpdev__Available_Quantity__c','sigmaerpdev__Reserved_Quantity__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Products__c','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Serial_Number__c','sigmaerpdev__Product_Serial_Number__c','sigmaerpdev__Product_Serial_Number__r.sigmaerpdev__Status__c','sigmaerpdev__Received_Date__c','sigmaerpdev__Inventory_Location_Product__r.sigmaerpdev__Inventory_Location__r.sigmaerpdev__Location__r.name','sigmaerpdev__Lot__c','sigmaerpdev__Lot__r.Name','sigmaerpdev__Inventory_Location_Product__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'id','name','sigmaerpdev__Status__c'})
        && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'id','name','sigmaerpdev__Reserved_Quantity__c','sigmaerpdev__Source_Type__c'})

        && CRUD_FLS_CheckUtility.checkFLS('OrderItem',new Set<String>{'sigmaerpdev__IsInventoryUpdated__c','Quantity','sigmaerpdev__Order_Status__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new Set<String>{'sigmaerpdev__Reserved_Qty__c','sigmaerpdev__Available_Qty__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Allocation__c',new Set<String>{'sigmaerpdev__ILPLI__c','sigmaerpdev__Order_Product__c','sigmaerpdev__Quantity__c'}) 
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Serial_Number__c',new Set<String>{'sigmaerpdev__Status__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev__Reserved_Quantity__c','sigmaerpdev__Source_Type__c'})
        && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'sigmaerpdev__Reserved_Quantity__c'})
        )
        {*/
            system.debug('solDataToSave>>'+solDataToSave);
            List<OrderItem> solListToUpdateAsAllocated = new List<OrderItem>();
            Map<Id,Decimal> productQuantityMap=new Map<Id,Decimal>();
            Map<Id,Decimal> stdorderlinequnt = new map<Id,Decimal>();
            Map<Id,Decimal> nopickproductQuantityMap=new Map<Id,Decimal>();
            Map<Id,decimal> maplotproforBin = new Map<Id,decimal>();
            Map<id,Map<id,decimal>> lotqtyupdate=new Map<id,Map<id,decimal>>();
            List<Id>orderlineid =new List<Id>();
            set<Id>productid = new set<Id>();
            for(OrderItem ol:solDataToSave)
            {
                if(ol.IsInventoryUpdated__c == false)
                {
                    if(ol.Order.No_Picking_Package_Shipment_Required__c || ol.Inventory_Status__c =='Allocated')
                    {
                        if(nopickproductQuantityMap.containsKey(ol.Product2Id))
                        {
                            nopickproductQuantityMap.put(ol.Product2Id,(nopickproductQuantityMap.get(ol.Product2Id)+ol.Quantity));
                        }
                        else
                        {
                            nopickproductQuantityMap.put(ol.Product2Id,ol.Quantity);
                        }
                    }
                    else
                    {
                         if(productQuantityMap.containsKey(ol.Product2Id))
                        {
                            productQuantityMap.put(ol.Product2Id,(productQuantityMap.get(ol.Product2Id)+ol.Quantity));
                        }
                        else
                        {
                            productQuantityMap.put(ol.Product2Id,ol.Quantity);
                        }
                    }
                   productid.add(ol.Product2Id);
                   stdorderlinequnt.put(ol.id,ol.Quantity);
                }
                stdorderlinequnt.put(ol.id,ol.Quantity);
                solListToUpdateAsAllocated.add(ol);
            }
            //Updating PI
            List<Inventory__c> inventory=[select id,name,ProductCode__c,Reserved_Qty__c,Available_Qty__c,Delivered_Qty__c from Inventory__c where ProductCode__c =:productid];
            
            for(Inventory__c tempInv:inventory)
            {
                if(productQuantityMap.size()>0)
                {
                    if(tempInv.Available_Qty__c >=productQuantityMap.get(tempInv.ProductCode__c))
                    {
                        if(tempInv.Reserved_Qty__c==null)
                        tempInv.Reserved_Qty__c=0;
                        tempInv.Reserved_Qty__c+=productQuantityMap.get(tempInv.ProductCode__c);
                        tempInv.Available_Qty__c-=productQuantityMap.get(tempInv.ProductCode__c);
                    }
                }
                if(nopickproductQuantityMap.size()>0)
                {
                    if(tempInv.Available_Qty__c >=nopickproductQuantityMap.get(tempInv.ProductCode__c))
                    {
                        
                        tempInv.Delivered_Qty__c+=nopickproductQuantityMap.get(tempInv.ProductCode__c);
                        tempInv.Available_Qty__c-=nopickproductQuantityMap.get(tempInv.ProductCode__c);
                    }
                }
                
               
            }
            if(inventory.size()>0)
            {
                update inventory;
            }
            //fetching ILPLI
            List<Inventory_Location_Product_Line_Item__c> ilpliDataRecieveData= [Select id,name,Available_Quantity__c,Reserved_Quantity__c,Inventory_Location_Product__r.Products__c,Product_Serial_Number__r.Serial_Number__c,Product_Serial_Number__c  ,Product_Serial_Number__r.Status__c,Received_Date__c,Inventory_Location_Product__r.Inventory_Location__r.Location__r.name,Lot__c,Lot__r.Name,Inventory_Location_Product__c,Delivered_Quantity__c,Bin__c from Inventory_Location_Product_Line_Item__c where Inventory_Location_Product__r.Products__c=:productid and  Available_Quantity__c>0 ORDER BY Product_Expiry_Date__c ASC NULLS LAST,Product_Received_date__c ASC NULLS LAST];
            
            Map<id,decimal> ILPLIIdQuantMap1 = new Map<id,decimal>();
            Map<Id,Inventory_Location_Product_Line_Item__c> ilpliIdILPLIMapToUpdate1=new Map<Id,Inventory_Location_Product_Line_Item__c>();
            Map<Id,decimal> ILPQuant= new Map<id,decimal>();
            Map<Id,decimal> LotQuant= new Map<id,decimal>();
            Map<Id,decimal> ILPQuantNoPick= new Map<id,decimal>();
            set<Id> Serialid =new set<Id>();
            set<Id> NopickSerialid =new set<Id>();
            set<Id>LOTID = new set<Id>();
            List<Inventory_Allocation__c> IAListToInsert=new List<Inventory_Allocation__c>();
            for(Integer i=0;i<solDataToSave.size();i++)
            {
                Decimal solQuantCount=solDataToSave[i].Quantity;
                Boolean nopickpack = solDataToSave[i].Order.No_Picking_Package_Shipment_Required__c;
                if(solDataToSave[i].Order_Status__c=='Order Confirmed' && !solDataToSave[i].IsInventoryUpdated__c)
                {
                   
                    
                    for(Inventory_Location_Product_Line_Item__c ilpli:ilpliDataRecieveData)
                    {
                        if(ILPLIIdQuantMap1.containsKey(ilpli.id) ? ILPLIIdQuantMap1.get(ilpli.id)!=ilpli.Available_Quantity__c :true)
                        {
                            
                            if(solQuantCount==0)
                                Break;
                            if(ilpli.Inventory_Location_Product__r.Products__c==solDataToSave[i].Product2Id)
                            {
                                 
                                if(ilpli.Product_Serial_Number__c!=null)
                                {
                                    if(nopickpack || solDataToSave[i].Inventory_Status__c =='Allocated')
                                    {
                                        NopickSerialid.add(ilpli.Product_Serial_Number__c);
                                    }
                                    else
                                    {
                                        Serialid.add(ilpli.Product_Serial_Number__c);
                                    }
                                     
                                }
                                
                                if(ilpli.Lot__c != null)
                                {
                                    LOTID.add(ilpli.Lot__c);
                                }
                                
                                if(nopickpack || solDataToSave[i].Inventory_Status__c =='Allocated')
                                {
                                    if(ilpli.Available_Quantity__c>=nopickproductQuantityMap.get(solDataToSave[i].Product2Id))
                                    {
                                        Inventory_Allocation__c indIA=new Inventory_Allocation__c();
                                        indIA.ILPLI__c=ilpli.id;
                                        indIA.Order_Product__c=solDataToSave[i].id;
                                        indIA.Quantity__c=stdorderlinequnt.get(indIA.Order_Product__c);
                                        IAListToInsert.add(indIA);
                                        if(orderlineid.contains(indIA.Order_Product__c))
                                        {
                                            //do nothing
                                        }
                                        else
                                        {
                                            orderlineid.add(indIA.Order_Product__c);
                                        }
                                        //inventoryupdated.put(indIA.Order_Product__c,true);
                                        if(ilpliIdILPLIMapToUpdate1.containsKey(ilpli.id)){
                                            ILPLIIdQuantMap1.put(ilpli.id,ILPLIIdQuantMap1.get(ilpli.id)+nopickproductQuantityMap.get(solDataToSave[i].Product2Id));
                                        }
                                        else{
                                            ILPLIIdQuantMap1.put(ilpli.id,nopickproductQuantityMap.get(solDataToSave[i].Product2Id));
                                        }
                                        
                                        if(ilpliIdILPLIMapToUpdate1.containsKey(ilpli.id)){
                                            Inventory_Location_Product_Line_Item__c tempILPLI=ilpliIdILPLIMapToUpdate1.get(ilpli.id);
                                            
                                            tempILPLI.Delivered_Quantity__c+=nopickproductQuantityMap.get(solDataToSave[i].Product2Id);
                                            ilpliIdILPLIMapToUpdate1.put(ilpli.id,tempILPLI);
                                        }
                                        else{
                                            
                                            ilpli.Delivered_Quantity__c+=nopickproductQuantityMap.get(solDataToSave[i].Product2Id);
                                            ilpliIdILPLIMapToUpdate1.put(ilpli.id,ilpli);
                                        }
                                        
                                        if(ILPQuantNoPick.containsKey(ilpli.Inventory_Location_Product__c))
                                        {
                                            
                                            ILPQuantNoPick.put(ilpli.Inventory_Location_Product__c,ILPQuantNoPick.get(ilpli.Inventory_Location_Product__c)+nopickproductQuantityMap.get(solDataToSave[i].Product2Id));
                                        }
                                        else
                                        {
                                           
                                            ILPQuantNoPick.put(ilpli.Inventory_Location_Product__c,nopickproductQuantityMap.get(solDataToSave[i].Product2Id));
                                           
                                        }
                                        //LOT for Allocated
                                        if(LotQuant.containsKey(ilpli.Lot__c))
                                        {
                                           LotQuant.put(ilpli.Lot__c,LotQuant.get(ilpli.Lot__c)+nopickproductQuantityMap.get(solDataToSave[i].Product2Id));
                                        }
                                        else if(LOTID.size()>0)
                                        {
                                            LotQuant.put(ilpli.Lot__c,nopickproductQuantityMap.get(solDataToSave[i].Product2Id));
                                        }
                                        
                                        if(maplotproforBin.containsKey(ilpli.Bin__c))
                                        {
                                            system.debug('Inside if Condition');
                                            maplotproforBin.put(ilpli.Bin__c,maplotproforBin.get(ilpli.Bin__c)+nopickproductQuantityMap.get(solDataToSave[i].Product2Id));
                                            
                                            system.debug('maplotproforBin '+maplotproforBin);
                                        }
                                        else
                                        {
                                            maplotproforBin.put(ilpli.Bin__c,nopickproductQuantityMap.get(solDataToSave[i].Product2Id));
                                            system.debug('maplotproforBinelse@@'+maplotproforBin);
                                        }
                                        
                                        if(LOTID.size()>0)
                                        {
                                        if(lotqtyupdate.containsKey(ilpli.Lot__c))
                                        {
                                            if(lotqtyupdate.get(ilpli.Lot__c).containsKey(ilpli.Bin__c))
                                            {
                                                decimal qty=lotqtyupdate.get(ilpli.Lot__c).get(ilpli.Bin__c);
                                                lotqtyupdate.get(ilpli.Lot__c).put(ilpli.Bin__c,qty+nopickproductQuantityMap.get(solDataToSave[i].Product2Id));
                                            }
                                            else
                                            {
                                                Map<id,decimal> locid=new Map<id,decimal>();
                                                lotqtyupdate.get(ilpli.Lot__c).put(ilpli.Bin__c,nopickproductQuantityMap.get(solDataToSave[i].Product2Id));
                                            }
                                        }
                                        else
                                        {
                                            Map<id,decimal> locid=new Map<id,decimal>();
                                            locid.put(ilpli.Bin__c,nopickproductQuantityMap.get(solDataToSave[i].Product2Id));
                                            lotqtyupdate.put(ilpli.Lot__c,locid);
                                        }
                                        }
                                        
                                        solQuantCount-=nopickproductQuantityMap.get(solDataToSave[i].Product2Id);
                                        nopickproductQuantityMap.put(ilpli.Inventory_Location_Product__r.Products__c,0);
                                    }
                                    else
                                    {
                                        decimal tempQuant=ilpli.Available_Quantity__c;
                                        Inventory_Allocation__c indIA=new Inventory_Allocation__c();
                                        indIA.ILPLI__c=ilpli.id;
                                        indIA.Order_Product__c=solDataToSave[i].id;
                                        indIA.Quantity__c=tempQuant;
                                        IAListToInsert.add(indIA);
                                        if(orderlineid.contains(indIA.Order_Product__c))
                                        {
                                            //do nothing
                                        }
                                        else
                                        {
                                            orderlineid.add(indIA.Order_Product__c);
                                        }
                                        if(ilpliIdILPLIMapToUpdate1.containsKey(ilpli.id)){
                                            ILPLIIdQuantMap1.put(ilpli.id,ILPLIIdQuantMap1.get(ilpli.id)+tempQuant);
                                        }
                                        else{
                                            ILPLIIdQuantMap1.put(ilpli.id,tempQuant);
                                        }
                                        if(ilpliIdILPLIMapToUpdate1.containsKey(ilpli.id)){
                                            Inventory_Location_Product_Line_Item__c tempILPLI=ilpliIdILPLIMapToUpdate1.get(ilpli.id);
                                            tempILPLI.Delivered_Quantity__c+=tempQuant;
                                            ilpliIdILPLIMapToUpdate1.put(ilpli.id,tempILPLI);
                                        }
                                        else{
                                            ilpli.Delivered_Quantity__c+=tempQuant;
                                            ilpliIdILPLIMapToUpdate1.put(ilpli.id,ilpli);
                                        }
                                        if(ILPQuantNoPick.containsKey(ilpli.Inventory_Location_Product__c))
                                        {
                                            ILPQuantNoPick.put(ilpli.Inventory_Location_Product__c,ILPQuantNoPick.get(ilpli.Inventory_Location_Product__c)+tempQuant);
                                        }
                                        else
                                        {
                                            ILPQuantNoPick.put(ilpli.Inventory_Location_Product__c,tempQuant);
                                        }
                                        if(LotQuant.containsKey(ilpli.Lot__c))
                                        {
                                            LotQuant.put(ilpli.Lot__c,LotQuant.get(ilpli.Lot__c)+nopickproductQuantityMap.get(solDataToSave[i].Product2Id));
                                        }
                                        else if(LOTID.size()>0)
                                        {
                                            LotQuant.put(ilpli.Lot__c,nopickproductQuantityMap.get(solDataToSave[i].Product2Id));
                                        }
                                        
                                        if(maplotproforBin.containsKey(ilpli.Bin__c))
                                        {
                                            system.debug('Inside if Condition');
                                            maplotproforBin.put(ilpli.Bin__c,maplotproforBin.get(ilpli.Bin__c)+tempQuant);
                                            
                                            system.debug('maplotproforBin '+maplotproforBin);
                                        }
                                        else
                                        {
                                            maplotproforBin.put(ilpli.Bin__c,tempQuant);
                                            system.debug('maplotproforBinelse@@'+maplotproforBin);
                                        }
                                        
                                        if(LOTID.size()>0)
                                        {
                                        if(lotqtyupdate.containsKey(ilpli.Lot__c))
                                        {
                                            if(lotqtyupdate.get(ilpli.Lot__c).containsKey(ilpli.Bin__c))
                                            {
                                                decimal qty=lotqtyupdate.get(ilpli.Lot__c).get(ilpli.Bin__c);
                                                lotqtyupdate.get(ilpli.Lot__c).put(ilpli.Bin__c,qty+tempQuant);
                                            }
                                            else
                                            {
                                                Map<id,decimal> locid=new Map<id,decimal>();
                                                lotqtyupdate.get(ilpli.Lot__c).put(ilpli.Bin__c,tempQuant);
                                            }
                                        }
                                        else
                                        {
                                            Map<id,decimal> locid=new Map<id,decimal>();
                                            locid.put(ilpli.Bin__c,tempQuant);
                                            lotqtyupdate.put(ilpli.Lot__c,locid);
                                        }
                                        }
                                        
                                        solQuantCount-=tempQuant;
                                        nopickproductQuantityMap.put(ilpli.Inventory_Location_Product__r.Products__c,nopickproductQuantityMap.get(ilpli.Inventory_Location_Product__r.Products__c)-tempQuant);
                                        stdorderlinequnt.put(solDataToSave[i].id,stdorderlinequnt.get(solDataToSave[i].id)-tempQuant);
                                    }
                                }
                                else
                                {
                                    if(ilpli.Available_Quantity__c>=productQuantityMap.get(solDataToSave[i].Product2Id))
                                    {
                                        Inventory_Allocation__c indIA=new Inventory_Allocation__c();
                                        indIA.ILPLI__c=ilpli.id;
                                        indIA.Order_Product__c=solDataToSave[i].id;
                                        indIA.Quantity__c=stdorderlinequnt.get(indIA.Order_Product__c);
                                        IAListToInsert.add(indIA);
                                        if(orderlineid.contains(indIA.Order_Product__c))
                                        {
                                            //do nothing
                                        }
                                        else
                                        {
                                            orderlineid.add(indIA.Order_Product__c);
                                        }
                                        //inventoryupdated.put(indIA.Order_Product__c,true);
                                        if(ilpliIdILPLIMapToUpdate1.containsKey(ilpli.id)){
                                            ILPLIIdQuantMap1.put(ilpli.id,ILPLIIdQuantMap1.get(ilpli.id)+productQuantityMap.get(solDataToSave[i].Product2Id));
                                        }
                                        else{
                                            ILPLIIdQuantMap1.put(ilpli.id,productQuantityMap.get(solDataToSave[i].Product2Id));
                                        }
                                        
                                        if(ilpliIdILPLIMapToUpdate1.containsKey(ilpli.id)){
                                            Inventory_Location_Product_Line_Item__c tempILPLI=ilpliIdILPLIMapToUpdate1.get(ilpli.id);
                                            if(tempILPLI.Reserved_Quantity__c==null)
                                                tempILPLI.Reserved_Quantity__c=0;
                                            tempILPLI.Reserved_Quantity__c+=productQuantityMap.get(solDataToSave[i].Product2Id);
                                            ilpliIdILPLIMapToUpdate1.put(ilpli.id,tempILPLI);
                                        }
                                        else{
                                            if(ilpli.Reserved_Quantity__c==null)
                                                ilpli.Reserved_Quantity__c=0;
                                            ilpli.Reserved_Quantity__c+=productQuantityMap.get(solDataToSave[i].Product2Id);
                                            ilpliIdILPLIMapToUpdate1.put(ilpli.id,ilpli);
                                        }
                                        
                                        if(ILPQuant.containsKey(ilpli.Inventory_Location_Product__c))
                                        {
                                            
                                            ILPQuant.put(ilpli.Inventory_Location_Product__c,ILPQuant.get(ilpli.Inventory_Location_Product__c)+productQuantityMap.get(solDataToSave[i].Product2Id));
                                        }
                                        else
                                        {
                                           
                                            ILPQuant.put(ilpli.Inventory_Location_Product__c,productQuantityMap.get(solDataToSave[i].Product2Id));
                                           
                                        }
                                        //LOT for Allocated
                                        if(LotQuant.containsKey(ilpli.Lot__c))
                                        {
                                           LotQuant.put(ilpli.Lot__c,LotQuant.get(ilpli.Lot__c)+productQuantityMap.get(solDataToSave[i].Product2Id));
                                        }
                                        else if(LOTID.size()>0)
                                        {
                                            LotQuant.put(ilpli.Lot__c,productQuantityMap.get(solDataToSave[i].Product2Id));
                                        }
                                        if(maplotproforBin.containsKey(ilpli.Bin__c))
                                        {
                                            system.debug('Inside if Condition');
                                            maplotproforBin.put(ilpli.Bin__c,productQuantityMap.get(ilpli.Bin__c)+productQuantityMap.get(solDataToSave[i].Product2Id));
                                            
                                            system.debug('maplotproforBin '+maplotproforBin);
                                        }
                                        else
                                        {
                                            maplotproforBin.put(ilpli.Bin__c,productQuantityMap.get(solDataToSave[i].Product2Id));
                                            system.debug('maplotproforBinelse@@'+maplotproforBin);
                                        }
                                        solQuantCount-=productQuantityMap.get(solDataToSave[i].Product2Id);
                                        productQuantityMap.put(ilpli.Inventory_Location_Product__r.Products__c,0);
                                    }
                                    else
                                    {
                                        decimal tempQuant=ilpli.Available_Quantity__c;
                                        Inventory_Allocation__c indIA=new Inventory_Allocation__c();
                                        indIA.ILPLI__c=ilpli.id;
                                        indIA.Order_Product__c=solDataToSave[i].id;
                                        indIA.Quantity__c=tempQuant;
                                        IAListToInsert.add(indIA);
                                        if(orderlineid.contains(indIA.Order_Product__c))
                                        {
                                            //do nothing
                                        }
                                        else
                                        {
                                            orderlineid.add(indIA.Order_Product__c);
                                        }
                                        if(ilpliIdILPLIMapToUpdate1.containsKey(ilpli.id)){
                                            ILPLIIdQuantMap1.put(ilpli.id,ILPLIIdQuantMap1.get(ilpli.id)+tempQuant);
                                        }
                                        else{
                                            ILPLIIdQuantMap1.put(ilpli.id,tempQuant);
                                        }
                                        if(ilpliIdILPLIMapToUpdate1.containsKey(ilpli.id)){
                                            Inventory_Location_Product_Line_Item__c tempILPLI=ilpliIdILPLIMapToUpdate1.get(ilpli.id);
                                            tempILPLI.Reserved_Quantity__c+=tempQuant;
                                            ilpliIdILPLIMapToUpdate1.put(ilpli.id,tempILPLI);
                                        }
                                        else{
                                            ilpli.Reserved_Quantity__c+=tempQuant;
                                            ilpliIdILPLIMapToUpdate1.put(ilpli.id,ilpli);
                                        }
                                        if(ILPQuant.containsKey(ilpli.Inventory_Location_Product__c))
                                        {
                                            ILPQuant.put(ilpli.Inventory_Location_Product__c,ILPQuant.get(ilpli.Inventory_Location_Product__c)+tempQuant);
                                        }
                                        else
                                        {
                                            ILPQuant.put(ilpli.Inventory_Location_Product__c,tempQuant);
                                        }
                                        if(LotQuant.containsKey(ilpli.Lot__c))
                                        {
                                            LotQuant.put(ilpli.Lot__c,LotQuant.get(ilpli.Lot__c)+productQuantityMap.get(solDataToSave[i].Product2Id));
                                        }
                                        
                                        else if(LOTID.size()>0)
                                        {
                                            LotQuant.put(ilpli.Lot__c,productQuantityMap.get(solDataToSave[i].Product2Id));
                                        }
                                        if(maplotproforBin.containsKey(ilpli.Bin__c))
                                        {
                                            system.debug('Inside if Condition');
                                            maplotproforBin.put(ilpli.Bin__c,productQuantityMap.get(ilpli.Bin__c)+tempQuant);
                                            
                                            system.debug('maplotproforBin '+maplotproforBin);
                                        }
                                        else
                                        {
                                            maplotproforBin.put(ilpli.Bin__c,tempQuant);
                                            system.debug('maplotproforBinelse@@'+maplotproforBin);
                                        }
                                        solQuantCount-=tempQuant;
                                        productQuantityMap.put(ilpli.Inventory_Location_Product__r.Products__c,productQuantityMap.get(ilpli.Inventory_Location_Product__r.Products__c)-tempQuant);
                                        stdorderlinequnt.put(solDataToSave[i].id,stdorderlinequnt.get(solDataToSave[i].id)-tempQuant);
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
            
            system.debug('LotQuant-->>'+LotQuant);
            //system.debug('LotQuant.keySet()-->>'+LotQuant.keySet());
            
            List<Lot_Product__c> lotproduct = [select id,Product__c,Quantity__c,Location__c,Lot__c,Bin__c from Lot_Product__c where Lot__c =: lotqtyupdate.keySet()]; 
            system.debug('aftr querrying lotproduct-->>'+lotproduct);
            system.debug('lotqtyupdate>>'+lotqtyupdate);
            
            for(Lot_Product__c LP : lotproduct ) 
            {
                if(lotqtyupdate.containsKey(LP.Lot__c))
                {
                    if(lotqtyupdate.get(LP.Lot__c).containsKey(LP.Bin__c))
                    {
                        LP.Quantity__c-=lotqtyupdate.get(LP.Lot__c).get(LP.Bin__c);
                    }
                } 
            }
            if(lotproduct.size()>0){
                update lotproduct;
            }
            if(Serialid.size()>0)
            {
                List<Product_Serial_Number__c> serialststusupdate=new List<Product_Serial_Number__c>();
                serialststusupdate=[select id,name,Status__c from Product_Serial_Number__c where id=:Serialid];
                for(Product_Serial_Number__c serialstatus:serialststusupdate)
                {
                    serialstatus.Status__c='Allocate';
                }
                update serialststusupdate;
            }
            if(NopickSerialid.size()>0)
            {
                List<Product_Serial_Number__c> nopickserialststusupdate=new List<Product_Serial_Number__c>();
                nopickserialststusupdate=[select id,name,Status__c from Product_Serial_Number__c where id=:NopickSerialid];
                for(Product_Serial_Number__c serialstatus:nopickserialststusupdate)
                {
                    serialstatus.Status__c='Used';
                }
                update nopickserialststusupdate;
            }
           
            
            List<Inventory_Location_Product__c>updatesoldqunt=new List<Inventory_Location_Product__c>();
            List<Inventory_Location_Product__c>updateilpdeliver=new List<Inventory_Location_Product__c>();
            
            if(ILPQuant.size()>0)
            {
                updatesoldqunt=[select id,name,Reserved_Quantity__c,Source_Type__c,Delivered_Quantity__c from Inventory_Location_Product__c where id=:ILPQuant.keySet()];
                for(Inventory_Location_Product__c ILP:updatesoldqunt)
                {
                    
                    if(ILPQuant.size()>0)
                    {
                        ILP.Reserved_Quantity__c+=ILPQuant.get(ILP.id);
                    }
                
                    ILP.Source_Type__c = 'System';
                }
                    update updatesoldqunt;
            }
            
            
            if(ILPQuantNoPick.size()>0)
            {
                updateilpdeliver=[select id,name,Reserved_Quantity__c,Source_Type__c,Deliver_Quantity__c from Inventory_Location_Product__c where id=:ILPQuantNoPick.keySet()];
                system.debug('Before Update'+updateilpdeliver);
                for(Inventory_Location_Product__c ILP:updateilpdeliver)
                {
                    if(ILPQuantNoPick.size()>0)
                    {
                        ILP.Deliver_Quantity__c+=ILPQuantNoPick.get(ILP.id);
                    }
                    ILP.Source_Type__c = 'System';
                }
                update updateilpdeliver;
                system.debug('After Debug'+updateilpdeliver);
            }
            
            if(ilpliIdILPLIMapToUpdate1.size()>0)
            {
                update ilpliIdILPLIMapToUpdate1.values();
            }
            if(IAListToInsert.size()>0)
            {
               
                Upsert IAListToInsert;
            }
            
            for(OrderItem tempSOL:solListToUpdateAsAllocated){
                if(orderlineid.contains(tempSOL.id))
                tempSOL.IsInventoryUpdated__c=true;
                
            }
            if(solListToUpdateAsAllocated.size()>0){
            upsert solListToUpdateAsAllocated;
            }
        //}
    }
}