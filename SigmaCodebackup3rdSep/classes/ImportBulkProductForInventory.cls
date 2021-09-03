public with sharing class ImportBulkProductForInventory
{
    public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    public String[] filelines = new String[]{};
    public Boolean successMsg {get;set;}
    public String ProType {get; set;}
    public String headerdata{get;set;}
    public String urlvalue{get;set;}
    public String url{get;set;}
    public Decimal totalunitprice = 0;
    public integer count=0;
    
    public ImportBulkProductForInventory()
    {
        successMsg = false; 
    }
    Public class excelwrap
    {
        Public String ProductName;
        Public String Inventory;
        Public String InventoryLocation;
        Public String ProQuantity;
        Public decimal unitPrice;
        Public String LotName;
        Public String Expirydate;
        Public String Bin;
        
    }
    public class dataWrap
    {
        public Id ilpid;
        public Id proid;
        public decimal qty = 0;
        public decimal unitprice = 0;
        

        //  public decimal ilpliup = 0;
        
    }
    /***This function reads the CSV file ***/
    public Pagereference ReadFile()
    {   
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Lot__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')  
           && CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Lot_Product__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sublevel_location__c')
            && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot_Product__c',new Set<String>{'sigmaerpdev2__Lot__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Location__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sublevel_location__c',new Set<String>{'id','Name','RecordType.Name'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location__c',new Set<String>{'id','Name'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'id','Name','sigmaerpdev2__ProductCode__c','sigmaerpdev2__Avg_Buying_Price__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__Product_Name__c','sigmaerpdev2__Total_Qty__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__ProductCode__r.sigmaerpdev2__Attribute_Type__c',' sigmaerpdev2__ProductCode__r.Name'}) 
           && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'id','Name','sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Typecheck__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'id','Name','sigmaerpdev2__Inventory__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Products__c', 'sigmaerpdev2__Received_Quantity__c', 'sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Source_Type__c','sigmaerpdev2__Stock_Origin__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot__c',new Set<String>{'id','Name','sigmaerpdev2__Product__r.Name'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'sigmaerpdev2__Inventory__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Products__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Source_Type__c','sigmaerpdev2__Stock_Origin__c','sigmaerpdev2__Unit_Price__c'}) 
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'sigmaerpdev2__Bin__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Product__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Stock_Type__c','sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Product_Expiry_Date__c','sigmaerpdev2__Lot__c'}) 
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new Set<String>{'sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__Avg_Buying_Price__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'sigmaerpdev2__Stock_Origin__c'}) 
           && CRUD_FLS_CheckUtility.checkFLS('Product2',new Set<String>{'sigmaerpdev2__Typecheck__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Lot_Product__c',new Set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Location__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Quantity__c'}))
        {*/
            try{
                nameFile = contentFile.toString();
                filelines = nameFile.split('\n');
                String[] inputvalues = new String[]{};
                Map<Id, decimal> InvIds = new Map<Id, decimal>(); 
                Map<Id, Id> InvPro = new Map<Id, Id>(); //used
                Map<Id, Map<String, Lot__c>> Invlot = new Map<Id, Map<String, Lot__c>>();
                Map<Id, Set<String>> lotRow = new Map<Id, Set<String>>();
                Map<Id, Map<Id, decimal>> ILPIrow = new Map<Id, Map<Id, decimal>>(); //used to get il,pi and product qty
                Map<Id, Map<Id, decimal>> ILPIprice = new Map<Id, Map<Id, decimal>>(); //used to get il,pi and product unit price added by rashmi on 27-02-2020
                Map<Id,decimal> productquant = New Map<Id,decimal>();
                Map<Id, Map<Id, Inventory_Location_Product__c>> ILPImap =  new Map<Id, Map<Id, Inventory_Location_Product__c>>(); //used
                Map<Id,Id>BinId = new Map<Id,Id>();
                 Map<Id,Id>lotId=new Map<Id,Id>();
               Set<Id>lotIds = new Set<Id>();               
                Set<String> lottxts = new Set<String>();
                List<Inventory_Location_Product_Line_Item__c> ilpliList = new List<Inventory_Location_Product_Line_Item__c>();
                List<Inventory_Location_Product__c> ILPlistUp = new List<Inventory_Location_Product__c>();
                List<Inventory_Location_Product__c> ILPlistIn = new List<Inventory_Location_Product__c>();
                List<Lot__c> lotdata = new List<Lot__c>();
        //Unitprice added by rashmi on 27-02-2020
                List<dataWrap> wrapList =new List<dataWrap>();
        Map<Id, Map<id,Map<Decimal,dataWrap>>> ILPforUpQty =  new Map<Id, Map<id,Map<Decimal,dataWrap>>>();  // is used to hold prod id,ilpid, UnitPrice of each row and Datawrap
               
                List<excelwrap> excelList = new List<excelwrap>();
                for(Integer i=1;i<filelines.size();i++)
                {
                    inputvalues = filelines[i].split(',');                
                    if(!String.isNotBlank(inputvalues[0])){
                        ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Enter Product Name at Row '+(i+1));
                        ApexPages.addMessage(errormsg);
                        return null;
                    }
                    if(!String.isNotBlank(inputvalues[1])){
                        ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Enter Product Inventory Id at Row '+(i+1));
                        ApexPages.addMessage(errormsg);
                        return null;
                    }
                    if(!String.isNotBlank(inputvalues[2])){
                        ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Enter Inventory Location Id at Row '+(i+1));
                        ApexPages.addMessage(errormsg);
                        return null;
                    }
                    if(!String.isNotBlank(inputvalues[3])){
                        ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Enter Bin Id at Row '+(i+1));
                        ApexPages.addMessage(errormsg);
                        return null;
                    }
                    if(!String.isNotBlank(inputvalues[4])){
                        ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Enter Quantity at Row '+(i+1));
                        ApexPages.addMessage(errormsg);
                        return null;
                    }   
                    if(!String.isNotBlank(inputvalues[5])){
                        ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Enter Unit Price at Row '+(i+1));
                        ApexPages.addMessage(errormsg);
                        return null;
                    }   
                    
                    excelwrap excelrow = new excelwrap();                
                    excelrow.ProductName = inputvalues[0].trim();                
                    excelrow.Inventory = inputvalues[1].trim();                
                    excelrow.InventoryLocation = inputvalues[2].trim();                
                    excelrow.ProQuantity = String.valueOf(inputvalues[4].trim());
                    excelrow.unitPrice = decimal.valueOf(inputvalues[5].trim());
                    system.debug('excelrow.unitPrice1-->>>'+excelrow.unitPrice);
                    if(String.isNotBlank(inputvalues[3]))
                    {
                        excelrow.Bin = inputvalues[3].trim();
                    }
                    excelrow.unitPrice = decimal.valueOf(inputvalues[5].trim());
                    system.debug('excelrow.unitPrice2-->>>'+excelrow.unitPrice);
                     system.debug('excelrow.unit-->>>'+inputvalues[6]);
                    if(String.isNotBlank(inputvalues[6]))
                    {
                        excelrow.LotName = inputvalues[6].trim();
                    }
                    excelList.add(excelrow); 
                }
                // validation not to allow to insert serialized product
                Map<string,string> pro1=new Map<string,string>();
                Map<string,string>productnamelist = new map<string,string>();
                for(excelwrap prodNam : excelList)
                {
                    system.debug('prodNam>>1'+prodNam);
                    pro1.put(prodNam.ProductName,prodNam.InventoryLocation);
                    BinId.put(prodNam.InventoryLocation,prodNam.Bin);
                    productnamelist.put(prodNam.ProductName,prodNam.Inventory);
                 lotId.put(prodNam.InventoryLocation,prodNam.LotName);
                 lotIds.add(prodNam.LotName);
                    system.debug('productnamelist>>'+productnamelist);
                }
                system.debug('prodt list-->'+pro1.keyset());
                
                list<Product2> productss= [select id,Name,(select id, Name, ProductCode__r.Name, Total_Available_Qty__c from Product_Inventory__r)from Product2 WHERE Name in: productnamelist.keySet()];
                system.debug('productss>>'+productss);

                  Map<string,string>prodpi = new map<string,string>();
                  Map<String,Id>LotProId = new Map<String,Id>();
                    for(Product2 prodrw:productss)
                {
                   for(Inventory__c inv:prodrw.Product_Inventory__r)
                           {      
                  prodpi.put(prodrw.Name,inv.id);
                  }
                  LotProId.put(prodrw.Name,prodrw.Id);
                  }
                   for(integer i=0;i<excelList.size();i++)
                    {
      if(prodpi.containsKey(excelList[i].ProductName) && prodpi.get(excelList[i].ProductName).contains(excelList[i].Inventory))
                  {
                            system.debug('inbreak');
                          //break;    
                        }
                        else
                        {  
                        ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Invalid Product Invenotry Id at line number'+'                           ' +(i+2));
                                 ApexPages.addMessage(errormsg);
                                    return null;
                        }
                    }
             
             
             
             //lot validation 
             
               list<Product2> prodz= [select id,Name,(select id, Name, Product__r.Name from Lots__r)from Product2 WHERE Name in: productnamelist.keySet()];

               Map<string,List<string>>prodlot = new map<string,List<string>>();
              
             for(Product2 prodrz:prodz)
                {
               for(Lot__c Lts:prodrz.Lots__r)
                {
                if(prodlot.containsKey(prodrz.Name))
                {
                  List<string> ltsidss=prodlot.get(prodrz.Name);
            ltsidss.add(Lts.id);
           prodlot.put(prodrz.Name,ltsidss);
                }
                else{
                List<string> ltsidss=new List<string>();
            ltsidss.add(Lts.id);
           prodlot.put(prodrz.Name,ltsidss);
                            }
                            
                            }
                            }
                            
                
                  for(integer i=0;i<excelList.size();i++)
                  {
                       if(excelList[i].LotName!=null)
         {            
         if(prodlot.containsKey(excelList[i].ProductName) && prodlot.get(excelList[i].ProductName).contains(excelList[i].LotName))
                  {
                            system.debug('inbreak');
                          //break;    
                        }
                        else
                        {  
                        ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Invalid Lot for product at line number'+'                           ' +(i+2));
                                 ApexPages.addMessage(errormsg);
                                    return null;
                        }
                    }
                    }
                    
                
                List<Product2> prodtn=[select id,Name,Attribute_Type__c from Product2 where Attribute_Type__c ='Bulk'];
                system.debug('prodtn-->'+prodtn);
                List<Product2> prodData=[select id,Name,Attribute_Type__c from Product2 where Name In:pro1.keyset()];
                system.debug('prodData-->'+prodData);
                Map<Id, decimal> uprow = new Map<Id, decimal>();
                for(Product2 prodrow:prodData)
                {
                    for(Product2 prod:prodtn)
                    {
                        if(prodrow.Attribute_Type__c != prod.Attribute_Type__c)
                        {
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Product Attribute Type ');
                            ApexPages.addMessage(errormsg);
                            return null;
                        }
                    
                    }
                }
                
                
                  Map<string,string>invlist = new map<string,string>();
                    for(excelwrap binNam : excelList)
                    {
                        
                        invlist.put(binNam.InventoryLocation,binNam.Bin);
                        
                        
                    }
                    
               list<Inventory_Location__c> iloc= [select id,Name,(select id,Name,RecordType.Name from Sublevel_locations__r where RecordType.Name='Bin') from Inventory_Location__c where id in: invlist.keySet()];
                  
                    Map<Id, List<Id>> ILBINID = new Map<Id, List<Id>>();
                    for(Inventory_Location__c il : iloc){
                        for(Sublevel_location__c ilc : il.Sublevel_locations__r){
                            if(ILBINID.containsKey(il.id)){
                                List<Id> binIdLst = ILBINID.get(il.id);                             
                                binIdLst.add(ilc.id);
                                //ILBINID.put(il.id, binIdLst);
                                ILBINID.get(il.id).add(ilc.id);
                            }else{
                                List<Id> binIdLst = new List<Id>();                             
                                binIdLst.add(ilc.id);
                                ILBINID.put(il.id, binIdLst);
                            }
                        }
                    }
                    System.debug('ILBINID'+ILBINID);
                    for(integer i=0;i<excelList.size();i++)
                    {   
                        System.debug('excelList/..'+excelList[i].InventoryLocation);
                        if(ILBINID.containsKey(excelList[i].InventoryLocation) && ILBINID.get(excelList[i].InventoryLocation).contains(excelList[i].Bin))
                        {
                            system.debug('inbreak');
                          //break;    
                        }
                        else
                        {
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Invalid Bin for Inventory Location at line number'+'  '+(i+2));
                            ApexPages.addMessage(errormsg);
                            return null;
                        }
                    }                   
                    
                    
                
                for(excelwrap row : excelList){
                    // PI & Quantity & Unit price
                    if(InvIds.containsKey(row.Inventory)){
                        decimal num = decimal.valueOf(row.ProQuantity) + InvIds.get(row.Inventory);
                        InvIds.put(row.Inventory, num);
                    } else {
                        InvIds.put(row.Inventory, decimal.valueOf(row.ProQuantity));
                    }
                    // ILPLI & row data  
                    if(ILPIrow.containsKey(row.InventoryLocation)){
                        
                        if(ILPIrow.get(row.InventoryLocation).containsKey(row.Inventory)){
                            decimal num = decimal.valueOf(row.ProQuantity) + ILPIrow.get(row.InventoryLocation).get(row.Inventory);
                            
                            ILPIrow.get(row.InventoryLocation).put(row.Inventory, num);
                            
                        } else {
                            ILPIrow.get(row.InventoryLocation).put(row.Inventory, decimal.valueOf(row.ProQuantity));
                            
                        }
                    } else {
                        Map<Id, decimal> pirow = new Map<Id, decimal>();
                        pirow.put(row.Inventory,decimal.valueOf(row.ProQuantity));
                        ILPIrow.put(row.InventoryLocation, pirow);
                    }
                    // Code To get Unit price data from map ILPIprice added by rashmi on 27-02-2020
                    system.debug('up>>>'+ILPIprice.containsKey(row.InventoryLocation));
                    if(ILPIprice.containsKey(row.InventoryLocation)){
                        if(ILPIprice.get(row.InventoryLocation).containsKey(row.Inventory))
                        {
                            system.debug('row.unitPrice >>'+row.unitPrice );
                            system.debug('row.unitPrice >>'+ILPIprice.get(row.InventoryLocation).get(row.Inventory) );
                            decimal unitprice = row.unitPrice + ILPIprice.get(row.InventoryLocation).get(row.Inventory); 
                            system.debug('unitprice>>>>'+unitprice);
                            ILPIprice.get(row.InventoryLocation).put(row.Inventory, unitprice);
                           // system.debug('ILPIprice1>>>>'+ILPIprice);
                        }
                        else{
                            ILPIprice.get(row.InventoryLocation).put(row.Inventory, row.unitprice);
                          //  system.debug('ILPIprice2>>>>'+ILPIprice);
                        }
                    }
                    else{
                        uprow.put(row.Inventory, row.unitPrice);
                        system.debug('uprow>>>'+uprow);
                        ILPIprice.put(row.InventoryLocation, uprow);
                      //  system.debug('ILPIprice3-->>>>'+ILPIprice);
                    }
                    system.debug('ILPIprice>>>>'+ILPIprice);
                }
                if(InvIds.size() > 0 && ILPIrow.size() > 0)
                {
                    
                    List<Inventory__c> productList = [select id, Name, ProductCode__c,Avg_Buying_Price__c, Total_Available_Qty__c,Total_Qty__c,Available_Qty__c, ProductCode__r.Attribute_Type__c from Inventory__c where Id In : InvIds.keySet() ];
                    for(Inventory__c invId : productList)
                    {
                        InvPro.put(invId.Id, invId.ProductCode__c);
                        invId.Total_Available_Qty__c = invId.Total_Available_Qty__c + InvIds.get(invId.Id);
                        
                       invId.Total_Qty__c=invId.Total_Available_Qty__c;
                       invId.Comments__c='Inventory updated after importing "Bulk Product" via "CSV File Upload"';
                    }
                    List<Inventory_Location_Product__c> ILPlist = [select Id, Name,Inventory__c,Inventory_Location__c,Products__c, Received_Quantity__c, Unit_Price__c,Source_Type__c,Stock_Origin__c from Inventory_Location_Product__c WHERE Inventory__c IN : InvIds.keySet() AND Inventory_Location__c IN : ILPIrow.keySet()];
                    system.debug('ILPlist-->'+ILPlist);
                    for(Inventory_Location_Product__c ilp : ILPlist){
                        if(ILPImap.containsKey(ilp.Inventory_Location__c)){
                            ILPImap.get(ilp.Inventory_Location__c).put(ilp.Inventory__c, ilp);
                        }   else {
                            map<Id,Inventory_Location_Product__c> InvId = new map<Id,Inventory_Location_Product__c>();
                            InvId.put(ilp.Inventory__c, ilp);
                            ILPImap.put(ilp.Inventory_Location__c,InvId);
                        }
                    }
                    
                    
                    for(Id ilid : ILPIrow.KeySet()){
                        if(ILPImap.containsKey(ilid)){
                            for(Id piid: ILPIrow.get(ilid).KeySet()){
                                system.debug('ILPImap.get(ilid).containsKey(piid)>>>'+ILPImap.get(ilid).containsKey(piid));
                                
                                if(ILPImap.get(ilid).containsKey(piid)){
                                    System.debug('am same');
                                } 
                                else 
                                {
                                    Inventory_Location_Product__c newilp = new Inventory_Location_Product__c();
                                    newilp.Inventory__c = piid;
                                    newilp.Inventory_Location__c = ilid;
                                    newilp.Products__c = InvPro.get(piid);
                                    newilp.Received_Quantity__c = 0;
                                    newilp.Source_Type__c = 'System';
                                    // newilp.Stock_Origin__c = 'Direct Add';
                                    // newilp.Unit_Price__c = 0;
                                    ILPlistIn.add(newilp);
                                    system.debug('ILPlistIn1-->>>'+ILPlistIn);
                                }
                            }
                        } 
                        else 
                        {
                            for(Id piid : ILPIrow.get(ilid).keySet()){
                                Inventory_Location_Product__c newilp = new Inventory_Location_Product__c();
                                newilp.Inventory__c = piid;
                                newilp.Inventory_Location__c = ilid;
                                newilp.Products__c = InvPro.get(piid);
                                newilp.Received_Quantity__c = 0;
                                newilp.Source_Type__c = 'System';
                                newilp.Unit_Price__c = 0;
                                newilp.Stock_Origin__c = 'Direct Add';
                                ILPlistIn.add(newilp);
                                system.debug('ILPlistIn2-->>>'+ILPlistIn);
                            }
                        }
                    }
                    Insert ILPlistIn; // inserting ILP
                    system.debug('ILPlistIn3-->>>'+ILPlistIn);
                    
                    for(Inventory_Location_Product__c ilp : ILPlistIn)
                    {
                        if(ILPImap.containsKey(ilp.Inventory_Location__c))
                        {
                            ILPImap.get(ilp.Inventory_Location__c).put(ilp.Inventory__c, ilp);
                            system.debug('ILPImap1 if>>>'+ILPImap);
                        } 
                        else{
                            map<Id, Inventory_Location_Product__c> InvId = new map<Id, Inventory_Location_Product__c>();
                            InvId.put(ilp.Inventory__c, ilp);
                            ILPImap.put(ilp.Inventory_Location__c, InvId);
                            system.debug('ILPImap2 else>>>'+ILPImap);
                        }
                    }
                    
                    
                                            //code to handle Lot
                            
     Lot_Product__c LotPro = new Lot_Product__c();
     List<Lot_Product__c>LotProductList = new List<Lot_Product__c>();
     List<Lot_Product__c> lotproducts=[select Product__c,Lot__c,Quantity__c,Bin__c,Location__c from Lot_Product__c where Lot__c=:lotIds];

     for(Lot_Product__c ltp:lotproducts)
      {
      LotProductList.add(ltp);
      }                     
                            
         for(excelwrap row :excelList)
         {                  
 Boolean MatchFound = false;
 if(row.LotName!=null)
 {
if(LotProductList.size()>0)
{
   for(Lot_Product__c LP:LotProductList)
{

if(LP.Product__c == LotProId.get(row.ProductName) && LP.Bin__c == Id.valueOf(row.Bin) && LP.Lot__c == Id.valueOf(row.LotName))
{
MatchFound =true;
LotPro = LP;
break;
}
}
if(MatchFound)
{
LotPro.Quantity__c +=decimal.valueOf(row.ProQuantity);
//LotProductList.add(LotPro);
}
else
{
LotPro = new Lot_Product__c();
LotPro.Lot__c = Id.valueOf(row.LotName);
LotPro.Location__c =Id.valueOf(row.InventoryLocation);
LotPro.Bin__c = Id.valueOf(row.Bin);
LotPro.Quantity__c = decimal.valueOf(row.ProQuantity);
LotPro.Product__c = LotProId.get(row.ProductName);
LotProductList.add(LotPro);
}
}
else
{
  LotPro = new Lot_Product__c();
  LotPro.Lot__c = Id.valueOf(row.LotName);
  LotPro.Location__c =Id.valueOf(row.InventoryLocation);
  LotPro.Bin__c = Id.valueOf(row.Bin);
  LotPro.Quantity__c = decimal.valueOf(row.ProQuantity);
  LotPro.Product__c = LotProId.get(row.ProductName);
  LotProductList.add(LotPro);
}
}
         }


if(LotProductList.size()>0)
{
upsert LotProductList;
}
//end
                    
                    
                    
                    
                    
                    
                    
                    for(Id ilid : ILPIrow.KeySet()){
                        for(Id piid: ILPIrow.get(ilid).KeySet()){
                            system.debug('ILPImap.get(ilid).get(piid)->>>'+ILPImap.get(ilid).get(piid));
                            Inventory_Location_Product__c newilp = ILPImap.get(ilid).get(piid);
                            newilp.Received_Quantity__c = newilp.Received_Quantity__c + ILPIrow.get(ilid).get(piid);
                            newilp.Source_Type__c = 'System';
                            system.debug('unitprice-->>>'+newilp.Unit_Price__c );
                            system.debug('unitprice-->>>'+ILPIprice.get(ilid).get(piid));
                            //newilp.Unit_Price__c = newilp.Unit_Price__c + ILPIprice.get(ilid).get(piid);
                            system.debug('newilp.Unit_Price__c-->>>'+newilp.Unit_Price__c);
                            ILPlistUp.add(newilp);
                            
                            
                            system.debug('ILPlistUp--------->>>>>>'+ILPlistUp);
                            
                          
                        }
                    }
                    
                    
                    for(excelwrap row : excelList){
                        if(ILPImap.containsKey(row.InventoryLocation)){
                            if(ILPImap.get(row.InventoryLocation).containsKey(row.Inventory)){
                                Inventory_Location_Product_Line_Item__c lneItem= new Inventory_Location_Product_Line_Item__c(); 
                                lneItem.Inventory_Location_Product__c = ILPImap.get(row.InventoryLocation).get(row.Inventory).Id;
                                lneItem.Product__c = InvPro.get(row.Inventory);
                                lneItem.Received_Quantity__c = decimal.valueOf(row.ProQuantity);
                                lneItem.Inventory_Location__c  = row.InventoryLocation;
                                lneItem.Stock_Type__c = 'Direct Add'; 
                                lneItem.Attribute_Type__c = 'BULK';
                                lneItem.Unit_Price__c = row.unitPrice;
                                system.debug('up in ilpli>>>'+lneItem.Unit_Price__c);
                                if(row.LotName!=null)
                                {
                                    lneItem.Lot__c=row.LotName;
                                }
                                if(row.Bin!=null)
                                {
                                    lneItem.Bin__c = row.Bin;
                                }
                                if(row.Expirydate != null)
                                    lneItem.Product_Expiry_Date__c = Date.valueOf(row.Expirydate);
                                
                                //code to handle Auto allocate for backorder product 02-04-2020 //Added by Harish
                                if(productquant.containsKey(lneItem.Product__c)){
                                    decimal num = productquant.get(lneItem.Product__c);
                                    productquant.put(lneItem.Product__c, num+lneItem.Received_Quantity__c);
                                } 
                                else{
                                    productquant.put(lneItem.Product__c, lneItem.Received_Quantity__c);
                                }
                                //code ends
                                ilpliList.add(lneItem);
                            }
                        }
                    }       
          // Finance code started here changed on 13-05-2020  -by rashmi
          for(Inventory_Location_Product_Line_Item__c ilpli :ilpliList)
          {
            
            system.debug('ILPforUpQty contains product>>>>'+ILPforUpQty.containsKey(ilpli.Inventory_Location__c));
                         system.debug('ilpli loc>>>>'+ilpli);
                      
            if(ILPforUpQty.containsKey(ilpli.Product__c)  )
            {
              system.debug('Products__c>>>>'+ILPforUpQty.get(ilpli.Product__c).containsKey(ilpli.Inventory_Location_Product__c) );
                            if(ILPforUpQty.get(ilpli.Product__c).containsKey(ilpli.Inventory_Location_Product__c))
                {
                  if(ILPforUpQty.get(ilpli.Product__c).get(ilpli.Inventory_Location_Product__c).containsKey(ilpli.Unit_Price__c))
                  {
                    
                    dataWrap wrap = ILPforUpQty.get(ilpli.Product__c).get(ilpli.Inventory_Location_Product__c).get(ilpli.Unit_Price__c);
                    wrap.qty = ilpli.Received_Quantity__c+ILPforUpQty.get(ilpli.Product__c).get(ilpli.Inventory_Location_Product__c).get(ilpli.Unit_Price__c).qty;
                    ILPforUpQty.get(ilpli.Product__c).get(ilpli.Inventory_Location_Product__c).put(ilpli.Unit_Price__c,wrap);
                    system.debug('ILPforUpQty contains pro and unit price>'+ILPforUpQty);
                  }
                  else{
                    Map<Decimal,dataWrap> wrapMap=ILPforUpQty.get(ilpli.Product__c).get(ilpli.Inventory_Location_Product__c);
                    
                    dataWrap wrap =new dataWrap();
                    wrap.ilpid = ilpli.Inventory_Location_Product__c;
                    wrap.proid = ilpli.Product__c;
                    wrap.qty = ilpli.Received_Quantity__c;
                    wrap.unitprice = ilpli.Unit_Price__c;
                    
                    system.debug('wrap.qty33>>>'+wrap.qty);
                    ILPforUpQty.get(ilpli.Product__c).get(ilpli.Inventory_Location_Product__c).put(wrap.unitprice,wrap);
                                      system.debug('ILPforUpQty contains only product>'+ILPforUpQty);
                  }
              }
              else{
                  Map<Decimal,dataWrap> wrapMap=new Map<Decimal,dataWrap>();
                  
                  dataWrap wrap =new dataWrap();
                  wrap.ilpid = ilpli.Inventory_Location_Product__c;
                  wrap.proid = ilpli.Product__c;
                  wrap.qty = ilpli.Received_Quantity__c;
                  wrap.unitprice = ilpli.Unit_Price__c;
                  
                  system.debug('wrap.qty33>>>'+wrap.qty);
                  wrapMap.put(wrap.unitprice,wrap);
                  system.debug('wrapMap-->'+wrapMap);
                  
                  Map<Id,Map<Decimal,dataWrap>> locMap=ILPforUpQty.get(ilpli.Product__c);
                  locMap.put(wrap.ilpid,wrapMap);
                  system.debug('locMap-->'+locMap);
                  
                  ILPforUpQty.put(ilpli.Product__c,locMap);
                  system.debug('ILPforUpQty contains only product>'+ILPforUpQty);
                }
            }
            else
            {
              Map<Decimal,dataWrap> wrapMap=new Map<Decimal,dataWrap>();
              dataWrap wrap =new dataWrap();
              wrap.ilpid = ilpli.Inventory_Location_Product__c;
              wrap.proid = ilpli.Product__c;
              wrap.qty = ilpli.Received_Quantity__c;
              wrap.unitprice=ilpli.Unit_Price__c;
              
              system.debug('wrap.qty33>>>'+wrap.qty);
              wrapMap.put(wrap.unitprice,wrap);
              system.debug('wrapMap-->'+wrapMap);
              
              Map<Id,Map<Decimal,dataWrap>> locMap=new Map<Id,Map<Decimal,dataWrap>>();
              locMap.put(wrap.ilpid,wrapMap);
              system.debug('locMap-->'+locMap);
              
              ILPforUpQty.put(ilpli.Product__c,locMap);
                           
              system.debug('ILPforUpQty new product>'+ILPforUpQty);
                           
            }

                    }
          for(Id ilprodid: ILPforUpQty.KeySet())
                    {
                        system.debug('ilprodid>>>>'+ilprodid);
                        Map<Id,Map<Decimal,dataWrap>> locMap=ILPforUpQty.get(ilprodid);
            for(Id ilpid : locMap.keySet())
            {
               system.debug('ilpid>>>>'+ilpid);
               
               Map<decimal,dataWrap> wrapMap= locMap.get(ilpid);
               for(Decimal up: wrapMap.KeySet())
               {
                system.debug('up>>>'+up);
                wrapList.add(wrapMap.get(up));
               }
            }
                       
                    }
          try
                    {
                        Set<Id> ObjectIdlist = new Set<Id>();
                        for(Inventory_Location_Product__c  i:ILPlistUp)
                        {
                            if(i.Stock_Origin__c == 'Direct Add' && i.Unit_Price__c != null)
                            {
                                ObjectIdlist.add(i.Id);
                            }
                        }
                        system.debug('ObjectIdlist>>>>'+ObjectIdlist);
                        if(ObjectIdlist.size() > 0)
                        {    
                            
                                system.debug('calling SF before update');
                                LinkageServiceClass.createSLFromILP(ObjectIdlist,wrapList);
                            
                        }
                        
                    } 
                    catch(Exception e)
                    {
                        System.debug('Exception in ImportBulkProductForInventory :'+e);
                        System.debug('Exception in ImportBulkProductForInventory line:'+e.getLineNumber());
                    }
          //Finance code ends here
                    insert ilpliList; // inserting ilpli
                    if(ILPlistUp.size()>0 && wrapList.size()>0 )
                    {
                        update ILPlistUp; // updating ILP
                        
                    }
                    
                    system.debug('after updating ILPlistUp-->>>'+ILPlistUp);
                    
                    //code added to update Average Buying Price in PI
                    set<id> ProdTypeid=new set<id>();//created by rashmi to restrict Attribute type changing after updating inventories on 04-04-2020
              
                    list<Inventory_Location_Product_Line_Item__c>  lneItem=[select Product__c,Stock_Type__c, Attribute_Type__c,Unit_Price__c from Inventory_Location_Product_Line_Item__c where Id In :ilpliList];
                 
         map<id,decimal> prolist=new map<id,decimal>();
           map<id,decimal> ilplilist1 =new map<id,decimal>();
           system.debug('lneItem>>'+lneItem);
           
                    for(Inventory_Location_Product_Line_Item__c prores :lneItem)
                    {   
                        ProdTypeid.add(prores.Product__c);//adding all product ids-by rashmi
                        if(prolist.containsKey(prores.Product__c))
                        {
                            decimal unitprice=prolist.get(prores.Product__c);
                            prolist.put(prores.Product__c,unitprice+prores.Unit_Price__c);
                            system.debug('prolistsss'+unitprice);
                        }
                        else
                        {
                            prolist.put(prores.Product__c,prores.Unit_Price__c);
                        }
                        if(ilplilist1.containsKey(prores.Product__c))
                        {
                            decimal counts=ilplilist1.get(prores.Product__c);
                            ilplilist1.put(prores.Product__c,counts+1);
                            system.debug('ilplilist111'+counts);
                        }
                        else
                        {
                            ilplilist1.put(prores.Product__c,1);
                        }
                    }
                    
                    
                    for(Inventory__c invId1 : productList)
                    {
                        
                        invId1.Avg_Buying_Price__c=prolist.get(invId1.ProductCode__c)/ilplilist1.get(invId1.ProductCode__c);
                        system.debug('invId1.ProductCode__c'+invId1.Avg_Buying_Price__c);
                    }
                    
                    update productList; // updating Product Inventory
                    //code ends here
                    //code added by rashmi on 04-04-2020 to restrict changing attribute type after inventory updates
                    List<Product2> Listprodtype;
                    Listprodtype =[select id,Name,Typecheck__c from Product2 where Typecheck__c=false and id =:ProdTypeid ];
                    system.debug('Listprodtype>>'+Listprodtype);
                    for(Product2 typeOfProd:Listprodtype){
                        typeOfProd.Typecheck__c=true;
                    }  
                    if(Listprodtype.size()>0)
                    {
                        upsert Listprodtype;
                    }
                    //code ends here
                    //code to handle autoallocation when inventory available 02-04 -added by Harish  
                    try{
                        system.debug('productquant@@'+productquant);
                        if(productquant.size()>0)
                        {
                            string flag='SR';
                            BackOrderMailService.notifyBackOrderStockAvailable(productquant,flag);
                        }
                        
                        
                    }
                    catch(Exception e){
                        System.debug('An exception occurred: ' + e.getMessage());
                    }
                    //code ends
                    ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.Confirm,'Imported Successfully!!');
                    ApexPages.addMessage(errormsg);
                }
            }
            catch(Exception e)
            {       
                System.debug('Exception Is: '+ e);
                System.debug('Exception Number Is: '+ e.getLineNumber());
                ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured reading the CSV file'+e.getMessage());
                ApexPages.addMessage(errormsg);
                contentFile = null;
                return null;
            }
       // }
        
        contentFile = null;
        return null;
    }
    
    public Pagereference Refresh(){
        PageReference pg = new PageReference('/apex/ImportBulkProductForInventory'); 
        pg.setRedirect(true);
        return pg;
    }
}