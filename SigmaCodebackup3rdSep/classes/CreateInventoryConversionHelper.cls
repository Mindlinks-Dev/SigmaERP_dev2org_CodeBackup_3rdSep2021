public with sharing class CreateInventoryConversionHelper 
{
    public static List<Id>listOFProIds;
    public static List<Id>listOFIlpliIds;
    public static Map<Id,Decimal> getMapOfQty2(List<Inventory_Consumption__c> ICSNew,String str)
    {
        ////listOFProIds=new List<Id>();
       // listOFIlpliIds=new List<Id>();
                System.debug('IlpliQty>>'+ICSNew);
                System.debug('str>>'+str);
       Map<Id,Decimal>IlpliQty=new Map<Id,Decimal>();
       Map<Id, Map<Id ,Map<Decimal,Decimal>>>IlpliQty2=new  Map<Id, Map<Id ,Map<Decimal,Decimal>>>();//PId,IlplID RQ CQ
       for(Inventory_Consumption__c ic : ICSNew)
            {
                if(IlpliQty2.containsKey(ic.Product__c) && IlpliQty2.get(ic.Product__c).containsKey(ic.Inventory_Location_Product_Line_Item__c))
                {
                    Map<Decimal,Decimal> RQCQ=IlpliQty2.get(ic.Product__c).get(ic.Inventory_Location_Product_Line_Item__c);
                    
                   
                }
                else
                {
                    Map<Decimal,Decimal>RQCQ=new Map<Decimal,Decimal>();
                    RQCQ.put(ic.Reserve_Quantity__c,ic.Consumed_Quantity__c);
                    Map<Id ,Map<Decimal,Decimal>>ilpli=new Map<Id ,Map<Decimal,Decimal>>();
                    ilpli.put(ic.Inventory_Location_Product_Line_Item__c,RQCQ);
                    IlpliQty2.put(ic.Product__c,ilpli);
                }
                if(str=='CONSUME')
                {
                    if(IlpliQty.containsKey(ic.Inventory_Location_Product_Line_Item__c))
                    IlpliQty.put(ic.Inventory_Location_Product_Line_Item__c,IlpliQty.get(ic.Inventory_Location_Product_Line_Item__c)+ic.Consumed_Quantity__c);
                    else
                    {
                    if(ic.Consumed_Quantity__c!=null)
                    IlpliQty.put(ic.Inventory_Location_Product_Line_Item__c,ic.Consumed_Quantity__c);
                    }
                   //////  listOFProIds.add(ic.Product__c);
                    //     listOFIlpliIds.add(ic.Inventory_Location_Product_Line_Item__c);
                   
                }else if(str == 'RESERVE'){
                    if(IlpliQty.containsKey(ic.Inventory_Location_Product_Line_Item__c))
                    IlpliQty.put(ic.Inventory_Location_Product_Line_Item__c,IlpliQty.get(ic.Inventory_Location_Product_Line_Item__c)+ic.Reserve_Quantity__c);
                    else
                    {
                    if(ic.Reserve_Quantity__c!=null)
                    IlpliQty.put(ic.Inventory_Location_Product_Line_Item__c,ic.Reserve_Quantity__c);
                    }
                  ////  listOFProIds.add(ic.Product__c);
                    //     listOFIlpliIds.add(ic.Inventory_Location_Product_Line_Item__c);
                }
            }
        System.debug('IlpliQty>>'+IlpliQty);
            return IlpliQty;
    }
     public static Map<Id,Decimal> getMapOfQty(List<Inventory_Consumption__c> ICSNew,String str)
    {
        listOFProIds=new List<Id>();
        listOFIlpliIds=new List<Id>();
                System.debug('IlpliQty>>'+ICSNew);
                System.debug('str>>'+str);
       Map<Id,Decimal>IlpliQty=new Map<Id,Decimal>();
       for(Inventory_Consumption__c ic : ICSNew)
            {
                if(str=='CONSUME')
                {
                    if(IlpliQty.containsKey(ic.Product__c))
                    IlpliQty.put(ic.Product__c,IlpliQty.get(ic.Product__c)+ic.Consumed_Quantity__c);
                    else
                    {
                    if(ic.Consumed_Quantity__c!=null)
                    IlpliQty.put(ic.Product__c,ic.Consumed_Quantity__c);
                    }
                     listOFProIds.add(ic.Product__c);
                         listOFIlpliIds.add(ic.Inventory_Location_Product_Line_Item__c);
                   
                }else if(str == 'RESERVE'){
                    if(IlpliQty.containsKey(ic.Product__c))
                    IlpliQty.put(ic.Product__c,IlpliQty.get(ic.Product__c)+ic.Reserve_Quantity__c);
                    else
                    {
                    if(ic.Reserve_Quantity__c!=null)
                    IlpliQty.put(ic.Product__c,ic.Reserve_Quantity__c);
                    }
                    listOFProIds.add(ic.Product__c);
                         listOFIlpliIds.add(ic.Inventory_Location_Product_Line_Item__c);
                }
            }
        System.debug('IlpliQty>>'+IlpliQty);
            return IlpliQty;
    }

     public static void getMapOfIds(List<Id> ilpIds,List<Id> proIds,Map<Id,Decimal> IlpliQty,Map<Id,Decimal> reserveQty,String str)
    {
        System.debug('ilpIds>>'+ilpIds); 
        System.debug('proIds>>'+proIds);
         System.debug('IlpliQty>>'+IlpliQty);
        System.debug('reserveQty>>'+reserveQty);
          System.debug('str>>'+str);
        List<Id>lisOfIlp=new List<Id>();
        List<Inventory_Location_Product_Line_Item__c>ilpliList=[select id,name,Product__c,Used_Quantity__c,Inventory_Location_Product__c,Reserved_Quantity__c  from Inventory_Location_Product_Line_Item__c where Product__c=:proIds  and id=:ilpIds ];
                List<Inventory_Location_Product_Line_Item__c>ilpliListNew=new List<Inventory_Location_Product_Line_Item__c>();
                System.debug('ilpliList>>'+ilpliList);
                Decimal qty=0;Decimal consumedQty=0;Decimal resQty=0;
                for(Inventory_Location_Product_Line_Item__c ilpli:ilpliList)
                { 
                  if(str=='RESERVECONSUME' && IlpliQty.containsKey(ilpli.Product__c) && reserveQty.containsKey(ilpli.Product__c))
                  {
                      //consumedQty+=IlpliQty.get(ilpli.Product__c);
                      ilpli.Reserved_Quantity__c-=reserveQty.get(ilpli.Product__c);
                      ilpli.Used_Quantity__c+=IlpliQty.get(ilpli.Product__c);
                      ilpliListNew.add(ilpli);
                      lisOfIlp.add(ilpli.Inventory_Location_Product__c);
                      qty=reserveQty.get(ilpli.Product__c)-IlpliQty.get(ilpli.Product__c);
                      consumedQty=((reserveQty.get(ilpli.Product__c)+IlpliQty.get(ilpli.Product__c))-(reserveQty.get(ilpli.Product__c)));
                     Decimal RQ=reserveQty.get(ilpli.Product__c);   
                      Decimal CQ=IlpliQty.get(ilpli.Product__c);
                    //  resQty=((RQ+CQ)-CQ);
                      resQty=((reserveQty.get(ilpli.Product__c)+IlpliQty.get(ilpli.Product__c))-(IlpliQty.get(ilpli.Product__c)));
                      System.debug('consumedQty>>'+consumedQty);
                       System.debug('resQty>>'+resQty);
                  }
                else if(IlpliQty.containsKey(ilpli.Product__c) && str=='CONSUME')
                {
                //ilpli.Reserved_Quantity__c+=IlpliQtyAvailable.get(ilpli.Id);
                    ilpli.Used_Quantity__c+=IlpliQty.get(ilpli.Product__c);
                ilpliListNew.add(ilpli);
                
                }
                    else if(IlpliQty.containsKey(ilpli.Product__c) && str=='RESERVE')
                    {
                        ilpli.Reserved_Quantity__c+=IlpliQty.get(ilpli.Product__c);
                
                    }
                    qty=IlpliQty.get(ilpli.Product__c);
                    lisOfIlp.add(ilpli.Inventory_Location_Product__c);
                }
        System.debug('ilpliListNew'+ilpliListNew);
                if(ilpliListNew.size()>0)
                update ilpliListNew;
                List<Inventory_Location_Product__c>listOfIlplNew=[select id,name,Delivered_Quantity__c,Reserved_Quantity__c,Products__c from  Inventory_Location_Product__c where id=:lisOfIlp];
                List<Inventory_Location_Product__c>listOfIlplNew1=new List<Inventory_Location_Product__c>();
                for(Inventory_Location_Product__c ilp:listOfIlplNew)
                {
                    if(str=='RESERVECONSUME' && IlpliQty.containsKey(ilp.Products__c) && reserveQty.containsKey(ilp.Products__c))
                  {
                      ilp.Reserved_Quantity__c-=reserveQty.get(ilp.Products__c);
                      ilp.Delivered_Quantity__c+=consumedQty;
                      listOfIlplNew1.add(ilp);
                  }
                    
                    else if(IlpliQty.containsKey(ilp.Products__c) && str=='CONSUME')
                    {
                        if(ilp.Delivered_Quantity__c==null)ilp.Delivered_Quantity__c=0;
                        ilp.Delivered_Quantity__c+=qty;
                        listOfIlplNew1.add(ilp);
               
                    }
                    else if(IlpliQty.containsKey(ilp.Products__c) && str=='RESERVE')
                    {
                        if(ilp.Reserved_Quantity__c==null)ilp.Reserved_Quantity__c=0;
                ilp.Reserved_Quantity__c+=qty;             
                listOfIlplNew1.add(ilp);                        
                    }
                    
                }
        System.debug('listOfIlplNew1'+listOfIlplNew1);
        if(listOfIlplNew1.size()>0)
                update listOfIlplNew1;
                List<Inventory__c>pis=[select id,name,ProductCode__c,Available_Qty__c,Reserved_Qty__c,Delivered_Qty__c from Inventory__c where  ProductCode__c=:proIds];
                List<Inventory__c>pisnew=new List<Inventory__c>();
                for(Inventory__c pi:pis)
                {
                    System.debug(' IlpliQty '+IlpliQty);System.debug('IlpliQty>>>'+qty);System.debug('consumedQty>>>'+consumedQty);
                     System.debug(' reserveQty  '+reserveQty);
                     System.debug(' pi in inventory>>   '+pi);
                     System.debug(' pi in resQty>>  '+resQty);
                     if(str=='RESERVECONSUME' && IlpliQty.containsKey(pi.ProductCode__c) && reserveQty.containsKey(pi.ProductCode__c))
                  {
                      System.debug('consumedQty>>'+consumedQty);
                      //consumedQty=IlpliQty.get(pi.ProductCode__c);
                      Decimal consumeQuantity= ((IlpliQty.get(pi.ProductCode__c)+reserveQty.get(pi.ProductCode__c))-reserveQty.get(pi.ProductCode__c));// fetch concume qty
                      System.debug('consumedQty inside if>>> consumeQuantity'+consumeQuantity);
                      pi.Reserved_Qty__c-=resQty;
                      pi.Delivered_Qty__c+=consumedQty;
                      pi.Available_Qty__c+=qty;
                          pisnew.add(pi);
                       System.debug(' pi in inventory>> '+pi);
                      
                  }
                     else if(IlpliQty.containsKey(pi.ProductCode__c) && str=='CONSUME')
                    {
                    pi.Delivered_Qty__c+=qty;
                    pi.Available_Qty__c-=qty;
                    pisnew.add(pi);
                    }
                    else  if(IlpliQty.containsKey(pi.ProductCode__c) && str=='RESERVE')
                    {
                        pi.Reserved_Qty__c+=qty;
                        pi.Available_Qty__c-=qty;
                        pisnew.add(pi);
                    }
                }
         System.debug('pisnew'+pisnew);
        if(pisnew.size()>0)
                update pisnew;
       // return null
    }
    
   /* public static Map<Id,Decimal> getMapOfQty(List<Product2>lisOfProducts,Map<Id,Decimal> IlpliQty,String str)
    {
         Map<Id,Decimal>IlpliQty2=new Map<Id,Decimal>();
        List<Inventory__c>pisnew=new List<Inventory__c>();
        List<Inventory_Location_Product__c>listOfIlplNew1=new List<Inventory_Location_Product__c>();
        List<Inventory_Location_Product_Line_Item__c>ilpliListNew=new List<Inventory_Location_Product_Line_Item__c>();
                
        for(Product2 pro:lisOfProducts)
        {
            for(Inventory_Location_Product_Line_Item__c ilpli:pro.Inventory_Location_Product_Line_Items__r)
            {
                if(IlpliQty.containsKey(ilpli.Product__c) && str=='RESERVE')
                { 
                    ilpli.Reserved_Quantity__c+=IlpliQty.get(ilpli.Product__c);
                    ilpliListNew.add(ilpli);
                }else if(IlpliQty.containsKey(ilpli.Product__c) && str=='CONSUME')
                {
                    ilpli.Used_Quantity__c+=IlpliQty.get(ilpli.Product__c);
                     ilpliListNew.add(ilpli);
                }
                
            }
            for(Inventory_Location_Product__c ilp:pro.Inventory_Location_Products__r)
            {
                if(IlpliQty.containsKey(ilp.Products__c) && str=='RESERVE')
                {
                    ilp.Reserved_Quantity__c+=IlpliQty.get(ilp.Products__c);
                    listOfIlplNew1.add(ilp);
                }
                else if(IlpliQty.containsKey(ilp.Products__c) && str=='CONSUME')
                {
                    if(ilp.Delivered_Quantity__c==null)ilp.Delivered_Quantity__c=0;
                    ilp.Delivered_Quantity__c+=IlpliQty.get(ilp.Products__c);
                    listOfIlplNew1.add(ilp);
                    
                }
            }
            for(Inventory__c pi:pro.Product_Inventory__r)
            {
                
                if(IlpliQty.containsKey(pi.ProductCode__c)  && str=='RESERVE')
                {
                    pi.Reserved_Qty__c+=IlpliQty.get(pi.ProductCode__c);
                    pi.Available_Qty__c-=IlpliQty.get(pi.ProductCode__c);
                    pisnew.add(pi);
                }
                
                else if(IlpliQty.containsKey(pi.ProductCode__c)  && str=='CONSUME')
                {
                    pi.Delivered_Qty__c+=IlpliQty.get(pi.ProductCode__c);
                    pi.Available_Qty__c-=IlpliQty.get(pi.ProductCode__c);
                        pisnew.add(pi);
                }
            }
        }
        if(pisnew.size()>0)
        {
            update pisnew;
        }
        if(listOfIlplNew1.size()>0)
        {
            update listOfIlplNew1;
        }
         if(ilpliListNew.size()>0)
        {
            update ilpliListNew;
        }
         return IlpliQty;
    }
    public static List<Product2> getProducts(List<Inventory_Consumption__c> ICSNew)
    {
        List<Product2> pros=null;
        List<Id>proIds=new List<Id>();
        List<Id>IlpliIds= new List<Id>();
        List<Id>ilpids=new List<Id>();
        List<Id>piIds= new List<Id>();
        for(Inventory_Consumption__c ic : ICSNew)
        {
            proIds.add(ic.Product__c);
            IlpliIds.add(ic.Inventory_Location_Product_Line_Item__c);
            ilpids.add(ic.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__c);
            piIds.add(ic.Inventory_Location_Product_Line_Item__r.Inventory_Location_Product__r.Inventory__c);
        }
        System.debug('proIds>>'+proIds);
        System.debug('piids>>'+piids);
        System.debug('ilpids>>'+ilpids);
        System.debug('IlpliIds>>'+IlpliIds);
        pros=[select Name,(select id,name,Available_Qty__c,Reserved_Qty__c,Delivered_Qty__c from Product_Inventory__r where id in :piids),(select id,name,Delivered_Quantity__c,Reserved_Quantity__c from Inventory_Location_Products__r where id in :ilpids),(select id,name,Used_Quantity__c,Inventory_Location_Product__c,Reserved_Quantity__c from Inventory_Location_Product_Line_Items__r where id in :IlpliIds )  from Product2 where id in :proIds];
        System.debug('pros'+pros);
        return pros;
    }
    public static void editData(Map<Id,Decimal> IlpliQtyRESERVE,Map<Id,Decimal> IlpliQtyCONSUME,List<Product2>lisOfProducts)
    {
         List<Inventory__c>pisnew=new List<Inventory__c>();
        List<Inventory_Location_Product__c>listOfIlplNew1=new List<Inventory_Location_Product__c>();
        List<Inventory_Location_Product_Line_Item__c>ilpliListNew=new List<Inventory_Location_Product_Line_Item__c>();
        System.debug('IlpliQtyRESERVE>>'+IlpliQtyRESERVE);
        System.debug('IlpliQtyCONSUME>>'+IlpliQtyCONSUME);
        System.debug('listOfIlplNew1>>'+lisOfProducts);
        
         for(Product2 pro:lisOfProducts)
        {
            for(Inventory_Location_Product_Line_Item__c ilpli:pro.Inventory_Location_Product_Line_Items__r)
            {
                if(IlpliQtyRESERVE.containsKey(ilpli.Product__c) && IlpliQtyCONSUME.containsKey(ilpli.Product__c ))
                {
                    if(IlpliQtyRESERVE.get(ilpli.Product__c)>=IlpliQtyCONSUME.get(ilpli.Product__c))
                    {
                        ilpli.Reserved_Quantity__c-=IlpliQtyRESERVE.get(ilpli.Product__c);
                        ilpli.Used_Quantity__c+=IlpliQtyCONSUME.get(ilpli.Product__c);
                         ilpliListNew.add(ilpli);
                    }
                    
                  
                }
                
            }
            for(Inventory_Location_Product__c ilp:pro.Inventory_Location_Products__r)
            {
                if(IlpliQtyRESERVE.containsKey(ilp.Products__c) && IlpliQtyCONSUME.containsKey(ilp.Products__c))
                {
                    if(IlpliQtyRESERVE.get(ilp.Products__c)>=IlpliQtyCONSUME.get(ilp.Products__c))
                    {
                        ilp.Reserved_Quantity__c-=IlpliQtyRESERVE.get(ilp.Products__c);
                        ilp.Delivered_Quantity__c+=IlpliQtyCONSUME.get(ilp.Products__c);
                          listOfIlplNew1.add(ilp);
                    }
                 
                }
              
            }
            for(Inventory__c pi:pro.Product_Inventory__r)
            {
                
                if(IlpliQtyRESERVE.containsKey(pi.ProductCode__c)  && IlpliQtyCONSUME.containsKey(pi.ProductCode__c) )
                {
                    if(IlpliQtyRESERVE.get(pi.ProductCode__c)>=IlpliQtyCONSUME.get(pi.ProductCode__c))
                    {
                        Decimal qty=(IlpliQtyRESERVE.get(pi.ProductCode__c)-IlpliQtyCONSUME.get(pi.ProductCode__c));
                         pi.Reserved_Qty__c-=qty;
                        pi.Delivered_Qty__c+=IlpliQtyCONSUME.get(pi.ProductCode__c);                        
                            pi.Available_Qty__c+=qty;
                            pisnew.add(pi);
                    }
                }
                
            }
        }
        System.debug('pisnew>>'+pisnew);
        System.debug('listOfIlplNew1>>'+listOfIlplNew1);
        System.debug('listOfIlplNew1>>'+ilpliListNew);
         if(pisnew.size()>0)
        {
            update pisnew;
        }
        if(listOfIlplNew1.size()>0)
        {
            update listOfIlplNew1;
        }
         if(ilpliListNew.size()>0)
        {
            update ilpliListNew;
        }
        
    }
     public static void saveIlpliData(List<Inventory_Location_Product_Line_Item__c>ilpli,Map<Id,Decimal> IlpliQty,String str)
    {
        
    }
    public static void saveIlpData(List<Inventory_Location_Product__c>ilp,Map<Id,Decimal> IlpliQty,String str)
    {
        
    }
    public static void savePiData(List<Inventory_Location_Product__c>pi,Map<Id,Decimal> IlpliQty,String str)
    {
        
    }*/

}