trigger CreateInventoryConversion on Inventory_Consumption__c (after insert, after update,after delete)
{
    List<Inventory_Consumption__c> ICSNew =trigger.new;
    System.debug('ICSNew>>>>'+ICSNew);
    List<Id>proIds=new List<Id>();
    List<Id>IlpliIds= new List<Id>();
    Map<Id,Decimal>IlpliQtyReserve=new Map<Id,Decimal>();
    Map<Id,Decimal>IlpliQtyAvailable=new Map<Id,Decimal>();
    List<Id>lisOfIlp= new List<Id>();
      System.debug('trigger.isUpdate'+trigger.isUpdate);
      System.debug('trigger.newMap'+trigger.newMap);
      System.debug('trigger.oldMap'+trigger.oldMap);
      if(trigger.isUpdate)
      {
      TriggerHelper.UpdateAvaliableQty(trigger.newMap,trigger.oldMap);
      }
  
   else if(ICSNew[0].Consumed_Quantity__c!=null && ICSNew[0].Reserve_Quantity__c==null)
        {
            
            for(Inventory_Consumption__c ic : ICSNew)
            {

                proIds.add(ic.Product__c);
                IlpliIds.add(ic.Inventory_Location_Product_Line_Item__c);
              
             
                if(IlpliQtyAvailable.containsKey(ic.Inventory_Location_Product_Line_Item__c))
                {
                IlpliQtyAvailable.put(ic.Inventory_Location_Product_Line_Item__c,IlpliQtyAvailable.get(ic.Inventory_Location_Product_Line_Item__c)+ic.Consumed_Quantity__c);
                }
                else
                {
                if(ic.Consumed_Quantity__c!=null)
                IlpliQtyAvailable.put(ic.Inventory_Location_Product_Line_Item__c,ic.Consumed_Quantity__c);
                }

            }
            
        
                List<Inventory_Location_Product_Line_Item__c>ilpliList=[select id,name,Used_Quantity__c,Inventory_Location_Product__c,Reserved_Quantity__c  from Inventory_Location_Product_Line_Item__c where Product__c=:proIds  and id=:IlpliIds ];
                List<Inventory_Location_Product_Line_Item__c>ilpliListNew=new List<Inventory_Location_Product_Line_Item__c>();
                System.debug('ilpliList>>'+ilpliList);
                Decimal qty=0;

                for(Inventory_Location_Product_Line_Item__c ilpli:ilpliList)
                {

                if(IlpliQtyAvailable.containsKey(ilpli.Id))
                {
                ///ilpli.Reserved_Quantity__c+=IlpliQtyAvailable.get(ilpli.Id);
                    ilpli.Used_Quantity__c+=IlpliQtyAvailable.get(ilpli.Id);
                ilpliListNew.add(ilpli);
                lisOfIlp.add(ilpli.Inventory_Location_Product__c);
                qty=IlpliQtyAvailable.get(ilpli.Id);
                }
                   
                }
                update ilpliListNew;
                List<Inventory_Location_Product__c>listOfIlplNew=[select id,name,Delivered_Quantity__c,Reserved_Quantity__c from  Inventory_Location_Product__c where id=:lisOfIlp];
                List<Inventory_Location_Product__c>listOfIlplNew1=new List<Inventory_Location_Product__c>();
                for(Inventory_Location_Product__c ilp:listOfIlplNew)
                {
                    if(ilp.Delivered_Quantity__c==null)ilp.Delivered_Quantity__c=0;
                ilp.Delivered_Quantity__c+=qty;
                listOfIlplNew1.add(ilp);
                }
                update listOfIlplNew1;
                List<Inventory__c>pis=[select id,name,Available_Qty__c,Reserved_Qty__c,Delivered_Qty__c from Inventory__c where  ProductCode__c=:proIds];
                List<Inventory__c>pisnew=new List<Inventory__c>();
                for(Inventory__c pi:pis)
                {
                    pi.Delivered_Qty__c+=qty;
                    pi.Available_Qty__c-=qty;
                    pisnew.add(pi);
                }
                update pisnew;
        }
        else if(ICSNew[0].Reserve_Quantity__c!=null && ICSNew[0].Consumed_Quantity__c==null)
        { 
            for(Inventory_Consumption__c ic : ICSNew)
            {

                proIds.add(ic.Product__c);
                IlpliIds.add(ic.Inventory_Location_Product_Line_Item__c);
                if(IlpliQtyReserve.containsKey(ic.Inventory_Location_Product_Line_Item__c))
                {
                IlpliQtyReserve.put(ic.Inventory_Location_Product_Line_Item__c,IlpliQtyReserve.get(ic.Inventory_Location_Product_Line_Item__c)+ic.Reserve_Quantity__c);
                }
                else
                {
                if(ic.Reserve_Quantity__c!=null)
                IlpliQtyReserve.put(ic.Inventory_Location_Product_Line_Item__c,ic.Reserve_Quantity__c);
                }
                
            }
                System.debug('IlpliQtyAvailable>>>>'+IlpliQtyAvailable);
                System.debug('IlpliQtyReserve>>>>'+IlpliQtyReserve);
                System.debug('proIds>>>>'+proIds); 
                System.debug('IlpliIds>>>>'+IlpliIds); 
                List<Inventory_Location_Product_Line_Item__c>ilpliList=[select id,name,Used_Quantity__c,Reserved_Quantity__c ,Inventory_Location_Product__c  from Inventory_Location_Product_Line_Item__c where Product__c=:proIds  and id=:IlpliIds ];
                List<Inventory_Location_Product_Line_Item__c>ilpliListNew=new List<Inventory_Location_Product_Line_Item__c>();
                System.debug('ilpliList>>>>'+ilpliList);
                Decimal qty=0;

                for(Inventory_Location_Product_Line_Item__c ilpli:ilpliList)
                {
                    System.debug('ilpli>>>>'+ilpli);
                if(IlpliQtyReserve.containsKey(ilpli.Id))
                {
                //ilpli.Used_Quantity__c+=IlpliQtyReserve.get(ilpli.Id);
                ilpli.Reserved_Quantity__c+=IlpliQtyReserve.get(ilpli.Id);
                
                
                lisOfIlp.add(ilpli.Inventory_Location_Product__c);
                    ilpliListNew.add(ilpli);
                qty=IlpliQtyReserve.get(ilpli.Id);
                }
                }
                System.debug('ilpliList>>>>'+ilpliList);
                System.debug('qty>>>>'+qty);
                update ilpliListNew;
                List<Inventory_Location_Product__c>listOfIlplNew=[select id,name,Delivered_Quantity__c,Reserved_Quantity__c from  Inventory_Location_Product__c where id=:lisOfIlp];
                List<Inventory_Location_Product__c>listOfIlplNew1=new List<Inventory_Location_Product__c>();
                System.debug('listOfIlplNew>>>>'+listOfIlplNew);
                for(Inventory_Location_Product__c ilp:listOfIlplNew)
                {
                //ilp.Delivered_Quantity__c+=qty; 
                if(ilp.Reserved_Quantity__c==null)ilp.Reserved_Quantity__c=0;
                ilp.Reserved_Quantity__c+=qty;
                
                listOfIlplNew1.add(ilp);
                }
                System.debug('listOfIlplNew1>>>>'+listOfIlplNew1);
                update listOfIlplNew1;
                List<Inventory__c>pis=[select id,name,Available_Qty__c,Reserved_Qty__c,Delivered_Qty__c from Inventory__c where  ProductCode__c=:proIds];
                List<Inventory__c>pisnew=new List<Inventory__c>();
                System.debug('pis>>>>'+pis);
                for(Inventory__c pi:pis)
                {
                pi.Reserved_Qty__c+=qty;
                 pi.Available_Qty__c-=qty;
                    
                pisnew.add(pi);
                }
                System.debug('pisnew>>>>'+pisnew);
                update pisnew;
        }
        
        else{
            if(ICSNew[0].Reserve_Quantity__c>=ICSNew[0].Consumed_Quantity__c)
            {
                Decimal newQty=ICSNew[0].Reserve_Quantity__c-ICSNew[0].Consumed_Quantity__c;
              //  Decimal resQty=ICSNew[0].Reserve_Quantity__c;
                for(Inventory_Consumption__c ic : ICSNew)
                {

                    proIds.add(ic.Product__c);
                    IlpliIds.add(ic.Inventory_Location_Product_Line_Item__c);
                    if(IlpliQtyReserve.containsKey(ic.Inventory_Location_Product_Line_Item__c))
                    {
                    IlpliQtyReserve.put(ic.Inventory_Location_Product_Line_Item__c,IlpliQtyReserve.get(ic.Inventory_Location_Product_Line_Item__c)+ic.Reserve_Quantity__c);
                    }
                    else
                    {
                    if(ic.Reserve_Quantity__c!=null)
                    IlpliQtyReserve.put(ic.Inventory_Location_Product_Line_Item__c,ic.Reserve_Quantity__c);
                    }
                    if(IlpliQtyAvailable.containsKey(ic.Inventory_Location_Product_Line_Item__c))
                    {
                    IlpliQtyAvailable.put(ic.Inventory_Location_Product_Line_Item__c,IlpliQtyAvailable.get(ic.Inventory_Location_Product_Line_Item__c)+ic.Consumed_Quantity__c);
                    }
                    else
                    {
                    if(ic.Consumed_Quantity__c!=null)
                    IlpliQtyAvailable.put(ic.Inventory_Location_Product_Line_Item__c,ic.Consumed_Quantity__c);
                    }

                }
                List<Inventory_Location_Product_Line_Item__c>ilpliList=[select id,name,Used_Quantity__c,Inventory_Location_Product__c,Reserved_Quantity__c  from Inventory_Location_Product_Line_Item__c where Product__c=:proIds  and id=:IlpliIds ];
                List<Inventory_Location_Product_Line_Item__c>ilpliListNew=new List<Inventory_Location_Product_Line_Item__c>();

                Decimal qty=0;

                for(Inventory_Location_Product_Line_Item__c ilpli:ilpliList)
                {

                if(IlpliQtyReserve.containsKey(ilpli.Id))
                {
                ilpli.Reserved_Quantity__c-=ICSNew[0].Reserve_Quantity__c;
                 ilpli.Used_Quantity__c+=ICSNew[0].Consumed_Quantity__c;
                ilpliListNew.add(ilpli);
                lisOfIlp.add(ilpli.Inventory_Location_Product__c);
                qty=IlpliQtyReserve.get(ilpli.Id);
                System.debug('qty>>>>'+qty);
                }
                }
                update ilpliListNew;
                List<Inventory_Location_Product__c>listOfIlplNew=[select id,name,Delivered_Quantity__c,Reserved_Quantity__c from  Inventory_Location_Product__c where id=:lisOfIlp];
                List<Inventory_Location_Product__c>listOfIlplNew1=new List<Inventory_Location_Product__c>();
                for(Inventory_Location_Product__c ilp:listOfIlplNew)
                {
                ilp.Reserved_Quantity__c-=ICSNew[0].Reserve_Quantity__c;
                ilp.Delivered_Quantity__c+=ICSNew[0].Consumed_Quantity__c;
                listOfIlplNew1.add(ilp);
                }
                update listOfIlplNew1;
                System.debug('listOfIlplNew1>>>>'+listOfIlplNew1);
                List<Inventory__c>pis=[select id,name,Available_Qty__c,Reserved_Qty__c,Delivered_Qty__c from Inventory__c where  ProductCode__c=:proIds];
                System.debug('pis>>>>'+pis);
                List<Inventory__c>pisnew=new List<Inventory__c>();
                for(Inventory__c pi:pis)
                {
                pi.Reserved_Qty__c-=ICSNew[0].Reserve_Quantity__c;
                pi.Delivered_Qty__c+=ICSNew[0].Consumed_Quantity__c;
                pi.Available_Qty__c+=newQty;
                
                pisnew.add(pi);
                }
                System.debug('pisnew>>>>'+pisnew);
                update pisnew;
            }
            
        }
         
      if(trigger.isDelete)
       {
      
            for(Inventory_Consumption__c ic : ICSNew)
            {

                proIds.add(ic.Product__c);
                IlpliIds.add(ic.Inventory_Location_Product_Line_Item__c);
            
                if(IlpliQtyAvailable.containsKey(ic.Inventory_Location_Product_Line_Item__c))
                {
                IlpliQtyAvailable.put(ic.Inventory_Location_Product_Line_Item__c,IlpliQtyAvailable.get(ic.Inventory_Location_Product_Line_Item__c)+ic.Consumed_Quantity__c);
                }
                else
                {
                if(ic.Consumed_Quantity__c!=null)
                IlpliQtyAvailable.put(ic.Inventory_Location_Product_Line_Item__c,ic.Consumed_Quantity__c);
                }

            }
            
        
                List<Inventory_Location_Product_Line_Item__c>ilpliList=[select id,name,Used_Quantity__c,Inventory_Location_Product__c,Reserved_Quantity__c  from Inventory_Location_Product_Line_Item__c where Product__c=:proIds  and id=:IlpliIds ];
                List<Inventory_Location_Product_Line_Item__c>ilpliListNew=new List<Inventory_Location_Product_Line_Item__c>();
                System.debug('ilpliList>>'+ilpliList);
                Decimal qty=0;

                for(Inventory_Location_Product_Line_Item__c ilpli:ilpliList)
                {

                if(IlpliQtyAvailable.containsKey(ilpli.Id))
                {
                //ilpli.Reserved_Quantity__c+=IlpliQtyAvailable.get(ilpli.Id);
                    ilpli.Used_Quantity__c+=IlpliQtyAvailable.get(ilpli.Id);
                ilpliListNew.add(ilpli);
                lisOfIlp.add(ilpli.Inventory_Location_Product__c);
                qty=IlpliQtyAvailable.get(ilpli.Id);
                }
                   
                }
                delete ilpliListNew;

}
}