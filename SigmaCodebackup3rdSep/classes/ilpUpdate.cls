public with sharing class ilpUpdate 
    {   
    //This method receives list of verified products and creates ILPLI and updates ILP.
    @AuraEnabled
    public static void updateILP(list<Stock_In_Product__c> srpList,List<Product_Serial_Number__c> SerialNumberList, List<Stock_Receiving_Product_Line_Item__c> srpliList)
    { 
    
     /* if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Stock_In_Product__c') &&
        CRUD_FLS_CheckUtility.checkObjCRUD('product2')&&
        CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')&&
        CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')&&
        CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location__c')&&
        CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Serial_Number__c')&&
        CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')&&
        CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Lot_Product__c')&&
        CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Purchase_Order_Product__c')&&
        CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Stock_Receiving_Product_Line_Item__c')&&
        



        CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Stock_In_Product__c',new set<String>{'id','name','sigmaerpdev2__Stock_In__c','sigmaerpdev2__Pur_Order__c','sigmaerpdev2__Putaway_location__c','sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c','sigmaerpdev2__Purchase_Order__c','sigmaerpdev2__Status__c','sigmaerpdev2__Quantity_Received__c','sigmaerpdev2__Product__c,Lot__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Expiry_Date__c'})&&
        CRUD_FLS_CheckUtility.checkReadPermission('product2',new set<String>{'id','name','sigmaerpdev2__Attribute_Type__c'})&&
        CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'id','name','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Product__c'})&&
        CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'id','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Products__c','sigmaerpdev2__Inventory_Location__r.sigmaerpdev2__Location__c '})&&
        CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Serial_Number__c',new set<String>{'id','sigmaerpdev2__Lot__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Stock_Receiving_Product__c'})&&
        CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new set<String>{'id','sigmaerpdev2__ProductCode__c','sigmaerpdev2__Avg_Buying_Price__c'})&&
        CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Purchase_Order_Product__c',new set<String>{'id','sigmaerpdev2__Product__c','sigmaerpdev2__Purchase_Order__c','sigmaerpdev2__VendorPrice__c','sigmaerpdev2__Buying_Price__c','sigmaerpdev2__Quantity__c '})&&
        CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot_Product__c',new set<String>{'sigmaerpdev2__Inventory_Location_Product__cid','sigmaerpdev2__Product__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Lot__c'})&&
        CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location__c',new set<String>{'Id','Name','sigmaerpdev2__Location__c','sigmaerpdev2__Location__r.Id'})
       
       && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new set<String>{'sigmaerpdev2__ProductCode__c','sigmaerpdev2__Avg_Buying_Price__c'})
       && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Stock_Receiving_Product_Line_Item__c',new set<String>{'sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Available_Quantity__c'})
       && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Serial_Number__c',new set<String>{'sigmaerpdev2__Lot__c','sigmaerpdev2__Inventory_Location_Product__c'})
       && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Products__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Inventory__c'})
       && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new set<String>{'sigmaerpdev2__Purchase_Order__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Product_Expiry_Date__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Source__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Product_Received_date__c','sigmaerpdev2__Stock_Receiving_Product__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Product__c','sigmaerpdev2__Received_Quantity1__c'})

    
    ){*/
  
    ID ilpID,ilID,iID,locID;
    List<ID> LotList=new List<ID>();
    List<ID> LocList=new List<ID>();
    List<ID> prdLists=new List<ID>();
    List<ID> ilLists=new List<ID>();
    List<ID> srpIdList=new List<ID>();
    List<ID> lineIDList=new List<ID>();

    for(Stock_In_Product__c srps :[select id,name,Stock_In__c,Pur_Order__c,Putaway_location__c,Inventory_Location__r.Location__c,Purchase_Order__c,Status__c,Quantity_Received__c,Product__c,Lot__c,Inventory_Location__c,Bin__c,Expiry_Date__c from Stock_In_Product__c where Id in :srpList])
    {
   
    LotList.add(srps.Lot__c);

    LocList.add(srps.Inventory_Location__r.Location__c);
   
    prdLists.add(srps.Product__c);
  
    ilLists.add(srps.Inventory_Location__r.Location__c);
   
    srpIdList.add(srps.id);
   
    lineIDList.add(srps.Purchase_Order__c);
   
    }

    List<Inventory_Location_Product_Line_Item__c> ilpliList=new List<Inventory_Location_Product_Line_Item__c>();
   
    List<product2> prdList=[select id,name,Attribute_Type__c from product2 where id IN: prdLists];
    Map<ID,product2> prdMaptoUpdate=new Map<ID,product2>();
    LIst<Inventory_Location_Product__c> ilpList=[select id,Inventory_Location__c,Received_Quantity__c,Products__c,Inventory_Location__r.Location__c,Source_Type__c from Inventory_Location_Product__c where Inventory_Location__r.Location__c IN: LocList ];
    system.debug('ilpList11>>'+ilpList);
    List<Inventory_Location__c> ilList=[Select Id,Name,Location__c,Location__r.Id From Inventory_Location__c where Location__c IN: ilLists];
    system.debug('ilList22>>'+ilList);
    List<Product_Serial_Number__c> psnList=[select id,Lot__c,Bin__c,Stock_Receiving_Product__c from Product_Serial_Number__c where Stock_Receiving_Product__c IN : srpIdList];
    system.debug('psnList>>'+psnList);
    List<Product_Serial_Number__c> psnListToUpdate=new List<Product_Serial_Number__c>();
    List<Inventory__c> PiToUpdate=new List<Inventory__c>();
    List<Stock_Receiving_Product_Line_Item__c> srpliToUpdate=new List<Stock_Receiving_Product_Line_Item__c>();
    system.debug('srpliToUpdate22>>'+srpliToUpdate);
    Map<ID,Inventory__c> PImap=new Map<ID,Inventory__c>();
    List<Lot_Product__c> LotProductsToInsert=new List<Lot_Product__c>();
    List<Inventory__c> iList=new List<Inventory__c>();
    iList=[select id,ProductCode__c,Avg_Buying_Price__c from Inventory__c where ProductCode__c IN: prdLists];
    system.debug('iList++'+iList);           
    List<Purchase_Order_Product__c> itemLists=new List<Purchase_Order_Product__c>();

    itemLists=[select id,Product__c,Purchase_Order__c,VendorPrice__c,Buying_Price__c,Quantity__c from Purchase_Order_Product__c where ID IN: lineIDList];
    system.debug('Line #56itemLists>>'+itemLists);
    Map<id,decimal> unitpricemap = new Map<id,decimal>();
    //code to upadte unit price in ILPLI
    for(Purchase_Order_Product__c POP :itemLists)
    {
        system.debug('POP ------>>'+POP );
        Integer Quanity = Integer.valueOf(POP.Quantity__c);
        system.debug('Quanity -->'+Quanity );
        unitpricemap.put(POP.Product__c,(POP.Buying_Price__c/Quanity));
        system.debug('unitpricemap-->>'+unitpricemap);
    }

    system.debug('line#64unitpricemap>>'+unitpricemap);
    List<Lot_Product__c> LotProductList=new List<Lot_Product__c>();
    List<Lot_Product__c> lotpToUpdate=new List<Lot_Product__c>();
    if(LotList.size()>0)
    LotProductList=[select id,Product__c,Quantity__c,Lot__c from Lot_Product__c where Lot__c IN: LotList];
    List<Purchase_Order_Product__c> LinesToUpdate=new List<Purchase_Order_Product__c>();
    Map<ID,Lot_Product__c> lotProdMap=new Map<ID,Lot_Product__c>();     
    Map<ID,product2> prdmap=new Map<ID,product2>();
    Map<String,ID> ilMap=new Map<String,ID>();
    Map<ID,ID> iMap=new Map<ID,ID>();
    Map<ID,Product_Serial_Number__c> psnMap=new Map<ID,Product_Serial_Number__c>();
    Map<ID,Lot_Product__c> lpToUp=new Map<ID,Lot_Product__c>();
    Map<ID,Purchase_Order_Product__c> linesUpd=new Map<ID,Purchase_Order_Product__c>();

    for(product2 p: prdList)
    prdMap.put(p.id,p);

    List<Inventory_Location_Product__c> newlyCreatedILPList=new List<Inventory_Location_Product__c>();
    List<Inventory_Location__c> newILs=new List<Inventory_Location__c>();
    Map<ID,Inventory_Location_Product__c > ILPtoUpdate=new Map<ID,Inventory_Location_Product__c>();
    Map<ID,ID> invnMap=new Map<ID,ID>();
    for(Inventory_Location_Product__c illp : ilpList)
    invnMap.put(illp.Inventory_Location__c,illp.Inventory_Location__r.Location__c);
    system.debug('invnMap>>'+invnMap);

    Map<id,Map<id,decimal>> ilpwithproid=new Map<id,Map<id,decimal>>();
    Map<ID,ID> pipromap=new Map<ID,ID>();
    Map<ID,ID> srpid=new Map<ID,ID>();
    system.debug('srpList>>>>'+srpList);
    if(srpList.size()>0)
    {

    for(Stock_In_Product__c li: srpList)
    {
    ilpID=NULL;
    ilID=NULL;
    iID=NULL;
    locID=NULL;
    Inventory_Location__c iloc=new Inventory_Location__c();

    srpid.put(li.id,li.Inventory_Location__c);
    system.debug('srpid>>'+srpid);
    for(Inventory_Location__c ic: ilList)
    {
    iMap.put(li.Inventory_Location__c,ic.id);
 
    if(ic.Location__c==li.Inventory_Location__c)
    {
    ilID=ic.id;
    break;
    }
    }  

    for(Inventory__c ill: iList)
    {
    pipromap.put(ill.ProductCode__c,ill.id);
    if(ill.ProductCode__c==li.Product__c)
    {
    iID=ill.id;
    break;
    }
    }  

 
    for(Inventory_Location_Product__c i:ilpList)
    {
    if(i.Inventory_Location__c==li.Inventory_Location__c && i.Products__c==li.Product__c)
    {
    i.Received_Quantity__c+=li.Quantity_Received__c;
    ilpID=i.id;
    ILPtoUpdate.put(i.id,i);
    break;
    }


    }
    System.debug('inside ilp>>'+ILPtoUpdate); 
    if(ilpID==NULL)
    {
    if(ilpwithproid.containsKey(li.Product__c))
    {
    if(ilpwithproid.get(li.Product__c).containsKey(li.Inventory_Location__c))
    {
    decimal qty=ilpwithproid.get(li.Product__c).get(li.Inventory_Location__c);
    System.debug('qty>>'+qty);
    ilpwithproid.get(li.Product__c).put(li.Inventory_Location__c,qty+li.Quantity_Received__c);
    System.debug('ilpwithproid>>'+ilpwithproid);
    }
    else
    {

    ilpwithproid.get(li.Product__c).put(li.Inventory_Location__c,li.Quantity_Received__c);
    System.debug('ilpwithproid>>'+ilpwithproid.get(li.Product__c).put(li.Inventory_Location__c,li.Quantity_Received__c));

    }
    }else
    {
    Map<id,decimal> ilpqty=new Map<id,decimal>();
    ilpqty.put(li.Inventory_Location__c,li.Quantity_Received__c);
    ilpwithproid.put(li.Product__c,ilpqty);
    System.debug('ilpqty>>'+ilpqty);
    }
    System.debug('ilpilpwithproid'+ilpwithproid);
    }


    for(Inventory_Location_Product__c nci: ilpList)
    {
    system.debug('inside if1>>>>>>>'+nci);
    system.debug('inside if1<<<<<<<<<<<'+invnMap.containsKey(nci.Inventory_Location__c));
    if(invnMap.containsKey(nci.Inventory_Location__c))
    {
    system.debug('inside if');
    if(invnMap.get(nci.Inventory_Location__c)==li.Inventory_Location__c && nci.Products__c==li.Product__c)
    {
    if(nci.Received_Quantity__c==NULL)
    nci.Received_Quantity__c=0;

    system.debug('inside if1<<<<<<>>'+ILPtoUpdate.containsKey(nci.id));
    if(ILPtoUpdate.containsKey(nci.id))
    {
    nci.Received_Quantity__c=ILPtoUpdate.get(nci.id).Received_Quantity__c+li.Quantity_Received__c;
    nci.Source_Type__c='System'; 
    ILPtoUpdate.put(nci.id,nci);
    system.debug('ILPtoUpdate>>>>'+ILPtoUpdate);
    }
    //if(!ILPtoUpdate.containsKey(nci.id))
    else 
    {
    nci.Received_Quantity__c=li.Quantity_Received__c;
    nci.Source_Type__c='System';    
    ILPtoUpdate.put(nci.id,nci);
    system.debug('ILPtoUpdate>>>>'+ILPtoUpdate);
    }

    ilpID=nci.id;
    break;
    }
    }
    }
    //} 
    system.debug('psnList---->'+psnList);
    for(Product_Serial_Number__c psnl: psnList)
    {
     
    if(psnl.Stock_Receiving_Product__c==li.id)
    {
    psnl.Lot__c=li.Lot__c;
    psnl.Inventory_Location_Product__c=(ilpID!=NULL?ilpID:NULL);
    psnListToUpdate.add(psnl);
    system.debug('psnListToUpdate-->'+psnListToUpdate);
    }
    }


    Map<ID,ID> idList=new Map<ID,ID>();
    system.debug('li.Quantity_Received__c-->'+li.Quantity_Received__c);
    if(prdMap.get(li.Product__c).Attribute_Type__c=='SERIALIZED' && li.Quantity_Received__c>0)
    {
    for(integer i=0;i<li.Quantity_Received__c;i++)
    {
        
    Inventory_Location_Product_Line_Item__c l=new Inventory_Location_Product_Line_Item__c();
    l.Purchase_Order__c=li.Pur_Order__c;
    l.Received_Quantity__c=1;
    l.Received_Quantity1__c=1;
    l.Product__c=li.Product__c;
    l.Inventory_Location_Product__c=(ilpID!=NULL?ilpID:NULL);
    system.debug('li.id---->'+li.id);
    l.Stock_Receiving_Product__c=li.id;
    system.debug('li.id---->'+l.Stock_Receiving_Product__c);
    l.Product_Received_date__c=system.today();
    //  l.Inventory_Location__c=(ilID!=NULL?ilID:(locID!=NULL?locID:NULL));

    system.debug('il in srp>>'+li.Inventory_Location__c);
    l.Inventory_Location__c=li.Inventory_Location__c;
    system.debug('il in ilpli1>>>>'+l.Inventory_Location__c);
    system.debug('bin in srp>>'+li.Bin__c);
    l.Bin__c=li.Bin__c;
    system.debug('bin in ilpli>>'+l.Bin__c);
    system.debug('exp date in srp>>'+li.Expiry_Date__c);
    l.Product_Expiry_Date__c=li.Expiry_Date__c;
    system.debug('exp date in ilpli>>'+l.Expiry_Date__c);
    if(li.Lot__c!=NULL)
    l.Lot__c=li.Lot__c;
    l.Unit_Price__c = unitpricemap.get(l.Product__c);
    l.Source__c='Stock Receiving';
    system.debug('unitprice'+l.Unit_Price__c);
    system.debug('SerialNumberList.size()--->'+SerialNumberList.size());
    if(SerialNumberList.size()>0)
    { 
    system.debug('SerialNumberList--->'+SerialNumberList);
    for(Product_Serial_Number__c ssn:SerialNumberList)
    {
    system.debug('l.Stock_Receiving_Product__c--->'+l.Stock_Receiving_Product__c);
    system.debug('ssn.Stock_Receiving_Product__c--->'+ssn.Stock_Receiving_Product__c);
    if(l.Stock_Receiving_Product__c==ssn.Stock_Receiving_Product__c)
    {
    ssn.Inventory_Location_Product__c=(ilpID!=NULL?ilpID:NULL);
    if(ssn.Stock_Receiving_Product__c==li.id && !(idList.containsKey(ssn.id)))
    { 
    system.debug('ssn.id---->'+ssn.id);
    l.Product_Serial_Number__c=ssn.id;
    system.debug('l.Product_Serial_Number__c---->'+l.Product_Serial_Number__c);
    idList.put(ssn.id,null);
    system.debug('idList---->'+idList);
    break;
    }
    
    } 

    }

    }


    ilpliList.add(l);
    system.debug('ilpliList>>'+ilpliList);

    } 
    }
    else if(prdMap.get(li.Product__c).Attribute_Type__c=='BULK' && li.Quantity_Received__c>0)
    {

    Inventory_Location_Product_Line_Item__c l=new Inventory_Location_Product_Line_Item__c();
    l.Purchase_Order__c=li.Pur_Order__c;
    l.Received_Quantity__c=li.Quantity_Received__c;
    l.Received_Quantity1__c=li.Quantity_Received__c;
    l.Product__c=li.Product__c;
    l.Inventory_Location_Product__c=(ilpID!=NULL?ilpID:NULL);
    l.Stock_Receiving_Product__c=li.id;
    l.Product_Received_date__c=system.today();
    l.Unit_Price__c = unitpricemap.get(l.Product__c);
    l.Source__c='Stock Receiving';
    // l.Inventory_Location__c=(ilID!=NULL?ilID:(locID!=NULL?locID:NULL));
    system.debug('Inventory_Location__c11>>'+l.Inventory_Location__c);
    system.debug('Inventory_Location__c22>>'+li.Inventory_Location__c);
    l.Inventory_Location__c=li.Inventory_Location__c;
    if(li.Lot__c!=NULL)
    l.Lot__c=li.Lot__c;
    l.Bin__c=li.Bin__c;
    system.debug('bin in ilpli>>'+l.Bin__c);
    system.debug('exp date in srp>>'+li.Expiry_Date__c);
    l.Product_Expiry_Date__c=li.Expiry_Date__c;
    system.debug('exp date in ilpli>>'+l.Expiry_Date__c);
    ilpliList.add(l);
    system.debug('ilpliList++++'+ilpliList);
    }   
    if(srpliList.size()>0)
    {
    for(Stock_Receiving_Product_Line_Item__c srpli: srpliList)
    {
    System.debug('srpli.Stock_Receiving_Product__c'+srpli.Stock_Receiving_Product__c);
    System.debug('li.id'+li.id);
    System.debug(' prdMap.get(li.Product__c).Attribute_Type__c'+prdMap.get(li.Product__c).Attribute_Type__c);
    if(srpli.Stock_Receiving_Product__c==li.id && prdMap.get(li.Product__c).Attribute_Type__c=='SERIALIZED')
    {
    srpli.Received_Quantity__c=1;
    srpli.Inventory_Location_Product__c=(ilpID!=NULL?ilpID:NULL);
    srpli.Lot__c=li.Lot__c;
    srpli.Available_Quantity__c=1;
    srpliToUpdate.add(srpli);
    }
    else if(srpli.Stock_Receiving_Product__c==li.id && prdMap.get(li.Product__c).Attribute_Type__c=='BULK')
    {
    srpli.Received_Quantity__c=li.Quantity_Received__c;
    srpli.Inventory_Location_Product__c=(ilpID!=NULL?ilpID:NULL);
    srpli.Lot__c=li.Lot__c;
    srpli.Available_Quantity__c=li.Quantity_Received__c;
    srpliToUpdate.add(srpli);
    }
    }
    }

    }
    //}   
    Map<ID,ID> idList=new Map<ID,ID>();
    system.debug(ilpwithproid.keyset());
    for(id proid:ilpwithproid.keyset())
    {
    Map<id,decimal> proidlist=ilpwithproid.get(proid);
    System.debug('proidlist'+proidlist);
    for(id ilprecid:proidlist.keyset())
    {
    Inventory_Location_Product__c ilpdata=new Inventory_Location_Product__c();
    ilpdata.Received_Quantity__c=ilpwithproid.get(proid).get(ilprecid);
    ilpdata.Products__c=proid;
    ilpdata.Inventory_Location__c=iMap.get(ilprecid);
    ilpdata.Source_Type__c ='System';
    ilpdata.Inventory__c=pipromap.get(proid);
    newlyCreatedILPList.add(ilpdata);

    }
    System.debug('newlyCreatedILPList'+newlyCreatedILPList);

    }


    if(ILPtoUpdate.values().size()>0){
    try{
    update ILPtoUpdate.values();
    system.debug('ILPtoUpdate-->>>'+ILPtoUpdate.values());
    }
    catch(Exception e)
    {
    System.debug('Error while updating ILP map values');
    }
    }
   
    if(newlyCreatedILPList.size()>0){
    try{
    insert newlyCreatedILPList;
    //upsert newlyCreatedILPList;
    system.debug('newlyCreatedILPList>>>>'+newlyCreatedILPList);

    }
    catch(Exception e)
    {
    System.debug('Error while updating ILP map values');
    }
    }
    Map<id,id> serialid=new  Map<id,id>();
    for(Inventory_Location_Product__c ilp:newlyCreatedILPList)
    {
    for(Inventory_Location_Product_Line_Item__c ilpli:ilpliList)
    {
    if(ilp.Products__c==ilpli.Product__c && ilp.Inventory_Location__c==ilpli.Inventory_Location__c)
    {
    if(ilpli.Inventory_Location_Product__c==NULL || ilpli.Inventory_Location_Product__c==null)
    {
    ilpli.Inventory_Location_Product__c=ilp.id;
    system.debug('serialid---11>>>>'+serialid);
    serialid.put(ilpli.Product_Serial_Number__c,ilp.id);
    system.debug('serialid---22>>>>'+serialid);
    }
    }
    }
    for(Stock_Receiving_Product_Line_Item__c srpli:srpliList)
    {
    if(ilp.Products__c== srpli.Product__c && srpid.get(srpli.Stock_Receiving_Product__c)==ilp.Inventory_Location__c)
    {
    if(srpli.Inventory_Location_Product__c==NULL ||srpli.Inventory_Location_Product__c==null)
    {
    srpli.Inventory_Location_Product__c=ilp.id;

    }
    }

    }


    }

    system.debug('SerialNumberList--->'+SerialNumberList);
    for(Product_Serial_Number__c ser:SerialNumberList)
    {
    system.debug('ser-->'+ser);
    system.debug('ser-->'+serialid.containsKey(ser.id));
    if(serialid.containsKey(ser.id))
    {
    system.debug('ser-->'+serialid.get(ser.id));
    ser.Inventory_Location_Product__c=serialid.get(ser.id);

    } 
    }
    system.debug('ilpliList--->'+ilpliList.size()); 




    if(ilpliList.size()>0)
    {

    try{
    insert ilpliList; 
    system.debug('after inserting ilpliList--->'+ilpliList); 
    }
    catch(Exception ex)
    {
    System.debug('Error while updating ILPLI list--:> '+ex.getMessage());
    } 
    }
    if(psnListToUpdate.size()>0)
    {

    try{
    update psnListToUpdate; 
    System.debug('after updating psnListToUpdate--:> '+psnListToUpdate);
    }
    catch(Exception ex)
    {
    System.debug('Error while updating Serial Number list: '+ex.getMessage());
    } 
    } 

    if(srpliToUpdate.size()>0)
    {

    try{
    update srpliToUpdate; 
    System.debug('after updating srpliToUpdate--:> '+srpliToUpdate);
    }
    catch(Exception ex)
    {
    System.debug('Error while updating SRPLI list: '+ex.getMessage());
    } 
    }
    System.debug('srpliToUpdate: '+srpliToUpdate);

    if(LotProductsToInsert.size()>0)
    {
    try{
    insert LotProductsToInsert; 
    System.debug('after updating LotProductsToInsert--:> '+LotProductsToInsert);
    }
    catch(Exception ex)
    {
    System.debug('Error while inserting lot products list: '+ex.getMessage());
    } 
    }  

    if(linesUpd.values().size()>0)
    {
    try{
    update linesUpd.values(); 
    }
    catch(Exception ex)
    {
    System.debug('Error while updating linesUpd map: '+ex.getMessage());
    } 
    }
    if(lotProdMap.values().size()>0)
    {
    try{
    update lotProdMap.values(); 
    }
    catch(Exception ex)
    {
    System.debug('Error while updating lotProdMap.values: '+ex.getMessage());
    } 
    }


    if(lpToUp.values().size()>0)
    {
    try{
    update lpToUp.values(); 
    }
    catch(Exception ex)
    {
    System.debug('Error while updating lpToUp.values: '+ex.getMessage());
    } 
    }


    if(prdMaptoUpdate.values().size()>0)
    {
    try{
    update prdMaptoUpdate.values(); 
    }
    catch(Exception ex)
    {
    System.debug('Error while updating prdMaptoUpdate map: '+ex.getMessage());
    } 
    }
    if(SerialNumberList.size()>0)
    {

    try{
    update SerialNumberList;
    system.debug('after UPDATING SerialNumberList'+SerialNumberList);

    }
    catch(Exception ex)
    {
    System.debug('Error while updating ILPLI list: '+ex.getMessage());
    } 
    }

    //code to handle avg buying price in PI

    List<Inventory_Location_Product_Line_Item__c>ILPLI =[select id,name,Unit_Price__c,Product__c from Inventory_Location_Product_Line_Item__c where Product__c =:prdLists];
    system.debug('ILPLI>>'+ILPLI);
    map<ID,decimal>avnprice = new map<Id,decimal>();
    map<Id,decimal>count = new map<Id,decimal>();
    if(ILPLI.size()>0)
    {
        for(Inventory_Location_Product_Line_Item__c ILPLILIST1 :ILPLI)
        {
            if(ILPLILIST1.Unit_Price__c!=null)
            {
                if(avnprice.containsKey(ILPLILIST1.Product__c))
                {
                    decimal qty = avnprice.get(ILPLILIST1.Product__c);
                    decimal countilpli = count.get(ILPLILIST1.Product__c);
                    avnprice.put(ILPLILIST1.Product__c,qty+ILPLILIST1.Unit_Price__c);
                    count.put(ILPLILIST1.Product__c,countilpli+1);
                }
                else
                {
                avnprice.put(ILPLILIST1.Product__c,ILPLILIST1.Unit_Price__c);
                count.put(ILPLILIST1.Product__c,1);
                }
            }
        }
        system.debug('avnprice>>'+avnprice);
        system.debug('count>>'+count);
    }
    for(Inventory__c ill:iList)
    {
        if(avnprice.containsKey(ill.ProductCode__c))
        {
            ill.Avg_Buying_Price__c = (avnprice.get(ill.ProductCode__c)/count.get(ill.ProductCode__c)).setScale(2);
        }
         
        system.debug('AVG price'+ill.Avg_Buying_Price__c);
    }
    if(iList.size()>0)
    {
        try{
        update iList; 
        system.debug('after inserting iList--->'+iList); 
        }
        catch(Exception ex)
        {
        System.debug('Error while updating ILPLI list--:> '+ex.getMessage());
        } 

    }           

    }
    }
    }