public with sharing class ImportSerialProductForInventory
{
    public String ProType { get; set; }
    public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    public String[] filelines = new String[]{};
        public Boolean successMsg {get;set;}
    public string callscript{get;set;}
    public ImportSerialProductForInventory(){
        successMsg = false;    
    }
    Public class excelwrap {
        Public String ProductName;
        Public String Inventory;
        Public String InventoryLocation;
        Public String SerialCode;
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
    }
    
    /***This function reads the CSV file ***/
    public Pagereference ReadFile()
    {
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product__c') 
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Lot_Product__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Lot__c')       
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location_Product_Line_Item__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Product_Serial_Number__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('Product2')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Inventory_Location__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Sublevel_location__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot_Product__c',new Set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Quantity__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Location__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Stock_Type__c','sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Unit_Price__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Product_Serial_Number__c',new Set<String>{'id','name','sigmaerpdev2__Serial_Number__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location__c',new Set<String>{'id','Name'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Sublevel_location__c',new Set<String>{'id','Name','RecordType.Name'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory__c',new Set<String>{'id','Name','sigmaerpdev2__ProductCode__c','sigmaerpdev2__Total_Available_Qty__c','sigmaerpdev2__Product_Name__c','sigmaerpdev2__Total_Qty__c','sigmaerpdev2__Available_Qty__c','sigmaerpdev2__ProductCode__r.sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__ProductCode__r.Name'}) 
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Inventory_Location_Product__c',new Set<String>{'id','Name','sigmaerpdev2__Inventory__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Products__c', 'sigmaerpdev2__Received_Quantity__c', 'sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Source_Type__c','sigmaerpdev2__Stock_Origin__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('Product2',new Set<String>{'id','Name','sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Typecheck__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Lot__c',new Set<String>{'id','Name','sigmaerpdev2__Product__r.Name'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product__c',new set<String>{'sigmaerpdev2__Inventory__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Products__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Source_Type__c','sigmaerpdev2__Stock_Origin__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Source_Type__c','sigmaerpdev2__Unit_Price__c'}) 
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory_Location_Product_Line_Item__c',new Set<String>{'sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Product__c','sigmaerpdev2__Received_Quantity__c','sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Stock_Type__c','sigmaerpdev2__Attribute_Type__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Product_Expiry_Date__c','sigmaerpdev2__Product_Serial_Number__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Lot__c'}) 
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Inventory__c',new Set<String>{'sigmaerpdev2__Available_Qty__c','sigmaerpdev2__Avg_Buying_Price__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Product_Serial_Number__c',new Set<String>{'sigmaerpdev2__Inventory_Location__c','sigmaerpdev2__Product_Code__c','sigmaerpdev2__Serial_Number__c','sigmaerpdev2__Status__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Unit_Price__c','sigmaerpdev2__Inventory_Location_Product__c','sigmaerpdev2__Expiry_date__c','sigmaerpdev2__Lot__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev2__Lot_Product__c',new Set<String>{'sigmaerpdev2__Product__c','sigmaerpdev2__Lot__c','sigmaerpdev2__Location__c','sigmaerpdev2__Bin__c','sigmaerpdev2__Quantity__c'})
           && CRUD_FLS_CheckUtility.checkFLS('Product2',new Set<String>{'sigmaerpdev2__Typecheck__c'}))
        {
            try{
                //Convert the uploaded file which is in BLOB format into a string
                nameFile = contentFile.toString();
                // blobToString( contentFile,'ISO-8859-1');
                
                //Now sepatate every row of the excel file
                filelines = nameFile.split('\n'); 
                system.debug('filelines-->'+filelines);
                String[] inputvalues = new String[]{};
                    Map<Id, decimal> InvIds = new Map<Id, decimal>(); //used
                Map<Id, Map<String, Lot__c>> Invlot = new Map<Id, Map<String, Lot__c>>();
                Map<Id, Set<String>> lotRow = new Map<Id, Set<String>>();
                Map<Id, Id> InvPro = new Map<Id, Id>(); //used
                Map<Id, Id> ProInv = new Map<Id, Id>(); //used
                Map<Id, Map<Id, decimal>> ILPIrow = new Map<Id, Map<Id, decimal>>(); //used to get il,pi and product qty
                Map<Id, Map<Id, decimal>> ProdUProw = new Map<Id, Map<Id, decimal>>(); //used to get il,pi and product unit price added by rashmi on 27-02-2020
                List<dataWrap> wrapList =new List<dataWrap>();
                Map<Id, Map<Id, Inventory_Location_Product__c>> ILPImap =  new Map<Id, Map<Id, Inventory_Location_Product__c>>(); //used
                
                Map<Id, Map<id,Map<Decimal,dataWrap>>> ILPforUpQty =  new Map<Id, Map<id,Map<Decimal,dataWrap>>>(); // is used to hold prod id,ilpid, UnitPrice of each row and Datawrap
                Map<Id,Id>BinId = new Map<Id,Id>();
                Map<Id,Id>lotId=new Map<Id,Id>(); 
                Set<Id>lotIds = new Set<Id>();
                Map<Id,decimal> productquant = New Map<Id,decimal>();
                Set<String> lottxts = new Set<String>();
                
                List<Inventory_Location_Product_Line_Item__c> ilpliList = new List<Inventory_Location_Product_Line_Item__c>();
                List<Inventory_Location_Product__c> ILPlistUp = new List<Inventory_Location_Product__c>();
                List<Inventory_Location_Product__c> ILPlistUpd = new List<Inventory_Location_Product__c>();
                List<Product_Serial_Number__c> psnList = new List<Product_Serial_Number__c>();
                List<Lot__c> lotdata = new List<Lot__c>();
                Map<String,decimal>CsvSerialCode = new Map<String,decimal>(); 
                // Data for Line Items
                List<excelwrap> excelList = new List<excelwrap>();
                system.debug('filelines.size()@@'+filelines.size());
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
                        ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Enter Bin at Row '+(i+1));
                        ApexPages.addMessage(errormsg);
                        return null;
                    }
                    if(!String.isNotBlank(inputvalues[4])){
                        ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Enter Serial code at Row '+(i+1));
                        ApexPages.addMessage(errormsg);
                        return null;
                    }
                    if(!String.isNotBlank(inputvalues[5])){
                        ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Enter unit price at Row '+(i+1));
                        ApexPages.addMessage(errormsg);
                        return null;
                    }
                    excelwrap excelrow = new excelwrap();
                    excelrow.ProductName = inputvalues[0].trim();
                    excelrow.Inventory = inputvalues[1].trim();
                    excelrow.InventoryLocation = inputvalues[2].trim();
                    excelrow.SerialCode = inputvalues[4].trim();
                    system.debug('excelrow.SerialCode->'+excelrow.SerialCode);
                    excelrow.unitPrice =  Decimal.valueOf(inputvalues[5].trim());
                    
                    system.debug('exc inv>>'+ excelrow.Inventory);
                    if(String.isNotBlank(inputvalues[3])){
                        excelrow.Bin = inputvalues[3].trim(); //Date.valueOf(transMainWrap.PostingDate);
                    }
                    if(String.isNotBlank(inputvalues[6]))
                    {
                        excelrow.LotName=inputvalues[6].trim(); 
                    }
                    excelList.add(excelrow);
                    system.debug('excelList>>'+excelList);
                }
                
                system.debug('finaleelList>>'+excelList);
                Map<string,string> pro1=new Map<string,string>();
                Map<string,string> productnamelist1 = new map<string,string>();
                integer count=1 ;
                for(excelwrap prodNam : excelList)
                {
                    count++;
                    pro1.put(prodNam.ProductName,prodNam.InventoryLocation);
                    BinId.put(prodNam.InventoryLocation,prodNam.Bin);
                    lotId.put(prodNam.InventoryLocation,prodNam.LotName);
                    lotIds.add(prodNam.LotName);
                    productnamelist1.put(prodNam.ProductName,prodNam.Inventory);
                    CsvSerialCode.put(prodNam.SerialCode,count);
                }
                system.debug('productnamelist1-->'+productnamelist1);
                system.debug('prodt list-->'+pro1.keyset());
                
                list<Product2> productss= [select id,Name,(select id, Name, ProductCode__r.Name, Total_Available_Qty__c from Product_Inventory__r)from Product2 WHERE Name in: productnamelist1.keySet()];
                
                
                map<string,string> serilpi=new map<string,string>();
                Map<String,Id>LotProId = new Map<String,Id>();
                for(Product2 pr:productss)
                {
                    for(Inventory__c inv:pr.Product_Inventory__r)
                    {
                        serilpi.put(pr.Name,inv.id);
                        
                    }
                    LotProId.put(pr.Name,pr.Id);
                }
                for(integer i=0;i<excelList.size();i++)
                {
                    if(serilpi.containsKey(excelList[i].ProductName) && serilpi.get(excelList[i].ProductName).contains(excelList[i].Inventory))
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
                
                list<Product2> prodz= [select id,Name,(select id, Name, Product__r.Name from Lots__r)from Product2 WHERE Name in: productnamelist1.keySet()];
                
                
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
                
                
                Map<string,string>invlist = new map<string,string>();
                for(excelwrap binNam : excelList)
                {
                    
                    invlist.put(binNam.InventoryLocation,binNam.Bin);
                    
                    
                }
                
                list<Inventory_Location__c> iloc= [select id,Name,(select id,Name,RecordType.Name from Sublevel_locations__r where RecordType.Name='bin') from Inventory_Location__c where id in: invlist.keySet()];
                
                
                
                Map<Id, List<Id>> ILBINID = new Map<Id, List<Id>>();
                for(Inventory_Location__c il : iloc){
                    for(Sublevel_location__c ilc : il.Sublevel_locations__r){
                        if(ILBINID.containsKey(il.id)){
                            List<Id> binIdLst = ILBINID.get(il.id);                             
                            binIdLst.add(ilc.id);
                            ILBINID.put(il.id, binIdLst);
                        }else{
                            List<Id> binIdLst = new List<Id>();                             
                            binIdLst.add(ilc.id);
                            ILBINID.put(il.id, binIdLst);
                        }
                    }
                }
                
                for(integer i=0;i<excelList.size();i++)
                {                        
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
                
                
                
                
                List<Product2> prodtn=[select id,Name,Attribute_Type__c from Product2 where Attribute_Type__c ='SERIALIZED'];
                List<Product2> prodData=[select id,Name,Attribute_Type__c from Product2 where Name In:pro1.keyset()];
                system.debug('prodData-->'+prodData);
                
                for(Product2 prodrow:prodData) 
                {
                    for(Product2 prod:prodtn)
                    {
                        if(prodrow.Attribute_Type__c != prod.Attribute_Type__c)
                        {
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Product Attribute Type is BULK ');
                            ApexPages.addMessage(errormsg);
                            return null;
                        }
                        
                    }
                    
                }
                
                
                //code to handle same serial code value in CSV file  23-03
                for(integer i=0;i<excelList.size();i++)
                {
                    for(integer j=i+1;j<excelList.size();j++)
                    {
                        if(excelList[i].SerialCode == excelList[j].SerialCode)
                        {
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Duplicate serial code found in the file at row number'+''+(j+2));
                            ApexPages.addMessage(errormsg);
                            return null;
                        }
                    }
                }
                //code ends
                //code to compare Serial code with DB 23-03-2020
                List<Product_Serial_Number__c> PsndataList =[select id,name,Serial_Number__c from Product_Serial_Number__c limit 1000];
                if(PsndataList.size()>0)
                {
                    for(integer i=0;i<PsndataList.size();i++)
                    {
                        if(CsvSerialCode.containsKey(PsndataList[i].Serial_Number__c))
                            
                        {
                            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'The given serial code in the file at row number '+CsvSerialCode.get(PsndataList[i].Serial_Number__c)+' already exist');
                            ApexPages.addMessage(errormsg);
                            return null;
                        }
                    }
                }
                
                
                
                for(excelwrap row : excelList)
                {
                    
                    // PI & Quantity
                    if(InvIds.containsKey(row.Inventory)){
                        decimal num = 1 + InvIds.get(row.Inventory);
                        InvIds.put(row.Inventory, num);
                    } else {
                        InvIds.put(row.Inventory, 1);
                    }
                    
                    // ILPLI & row data
                    if(ILPIrow.containsKey(row.InventoryLocation)){
                        //code added by rashmi to update Sigma finance details in ILP and and in Sigma Finance object
                        if(ILPIrow.get(row.InventoryLocation).containsKey(row.Inventory)){
                            decimal num = 1 + ILPIrow.get(row.InventoryLocation).get(row.Inventory);
                            system.debug('num>>>>>'+num);
                            decimal unitprice = row.unitPrice + ProdUProw.get(row.InventoryLocation).get(row.Inventory); 
                            system.debug('unitprice>>>'+unitprice);            
                            ILPIrow.get(row.InventoryLocation).put(row.Inventory, num);
                            system.debug('ILPIrow>>>'+ILPIrow);    
                            ProdUProw.get(row.InventoryLocation).put(row.Inventory, unitprice);
                            system.debug('ProdUProw>>>'+ProdUProw);  
                        } else {
                            ILPIrow.get(row.InventoryLocation).put(row.Inventory, 1);
                            system.debug('ILPIrow>>>'+ILPIrow);  
                            ProdUProw.get(row.InventoryLocation).put(row.Inventory, row.unitPrice); 
                            system.debug('ProdUProw>>>'+ProdUProw);  
                        }
                    } else {
                        Map<Id, decimal> pirow = new Map<Id, decimal>();
                        pirow.put(row.Inventory, 1);
                        system.debug('pirow>>>'+pirow);
                        ILPIrow.put(row.InventoryLocation, pirow);
                        system.debug('ILPIrow>>>'+ILPIrow);
                        Map<Id, decimal> uprow = new Map<Id, decimal>();
                        uprow.put(row.Inventory, row.unitPrice);
                        system.debug('uprow>>>'+uprow);      
                        ProdUProw.put(row.InventoryLocation, uprow);  
                        system.debug('ProdUProw>>>'+ProdUProw);            
                    }
                    system.debug('ILPIrow>>'+ILPIrow);
                    
                }
                
                system.debug('lottxts>>>'+lottxts);
                 List<Inventory__c> productList ;
                if(InvIds.size() > 0 && ILPIrow.size() > 0 && ProdUProw.size() > 0)
                {
                  productList = [select id, Name, ProductCode__c, Total_Available_Qty__c, Available_Qty__c,ProductCode__r.Attribute_Type__c from Inventory__c where Id In : InvIds.keySet() ];
                    system.debug('productlist>>'+productList);
                    for(Inventory__c invId : productList)
                    {
                        InvPro.put(invId.Id, invId.ProductCode__c);
                        ProInv.put(invId.ProductCode__c, invId.Id);
                        invId.Available_Qty__c = invId.Available_Qty__c + InvIds.get(invId.Id);
                        invId.Total_Qty__c=invId.Available_Qty__c;
                        invId.Comments__c='Inventory updated after importing "Serialized Product" via "CSV File Upload"';
                    }
                    List<Inventory_Location_Product__c> ILPlist = [select Id, Name,Inventory__c,Inventory_Location__c,Products__c,Received_Quantity__c,Unit_Price__c, Source_Type__c,Stock_Origin__c from Inventory_Location_Product__c WHERE Inventory__c IN : InvIds.keySet() AND Inventory_Location__c IN : ILPIrow.keySet()];
                    system.debug('ILPlist>>>'+ILPlist);
                    for(Inventory_Location_Product__c ilp : ILPlist)
                    {
                        
                        if(ILPImap.containsKey(ilp.Inventory_Location__c)){
                            
                            ILPImap.get(ilp.Inventory_Location__c).put(ilp.Inventory__c, ilp);
                            
                        } 
                        else{
                            map<Id,Inventory_Location_Product__c> InvId = new map<Id,Inventory_Location_Product__c>();
                            InvId.put(ilp.Inventory__c, ilp);
                            
                            ILPImap.put(ilp.Inventory_Location__c, InvId);
                        }
                    }
                    system.debug('lotsize'+lottxts.size());
                    
                    
                    for(Id ilid : ILPIrow.KeySet()){
                        
                        if(ILPImap.containsKey(ilid)){
                            
                            for(Id piid: ILPIrow.get(ilid).KeySet()){   
                                if(ILPImap.get(ilid).containsKey(piid)){
                                    
                                } else {
                                    system.debug('in else');
                                    Inventory_Location_Product__c newilp = new Inventory_Location_Product__c();
                                    
                                    newilp.Inventory__c = piid;
                                    newilp.Inventory_Location__c = ilid;
                                    newilp.Products__c = InvPro.get(piid);
                                    newilp.Received_Quantity__c = 0;
                                    newilp.Source_Type__c = 'System';
                                    newilp.Stock_Origin__c = 'Direct Add';
                                    newilp.Unit_Price__c = 0;
                                    ILPlistUp.add(newilp);
                                    system.debug('ILPlistIn1-->>>'+ILPlistUp);
                                    
                                }
                            }
                            
                        } else {
                            system.debug('else 2');
                            for(Id piid : ILPIrow.get(ilid).keySet()){
                                Inventory_Location_Product__c newilp = new Inventory_Location_Product__c();
                                newilp.Inventory__c = piid;
                                newilp.Inventory_Location__c = ilid;
                                newilp.Products__c = InvPro.get(piid);
                                newilp.Received_Quantity__c = 0;
                                newilp.Unit_Price__c = 0;
                                newilp.Source_Type__c = 'System';
                                newilp.Stock_Origin__c = 'Direct Add';
                                ILPlistUp.add(newilp);
                                system.debug('ILPlistIn2-->>>'+ILPlistUp);   
                            }
                        }
                    }
                    Insert ILPlistUp; //upsert ilp
                    system.debug('ILPlistIn3-->>>'+ILPlistUp);
                    for(Inventory_Location_Product__c ilp : ILPlistUp)
                    {
                        
                        if(ILPImap.containsKey(ilp.Inventory_Location__c)){
                            ILPImap.get(ilp.Inventory_Location__c).put(ilp.Inventory__c, ilp);
                        } 
                        else 
                        {
                            map<Id, Inventory_Location_Product__c> InvId = new map<Id,Inventory_Location_Product__c>();
                            InvId.put(ilp.Inventory__c, ilp);
                            ILPImap.put(ilp.Inventory_Location__c, InvId);
                        }
                        
                    }
                    for(Id ilid : ILPIrow.KeySet()){
                        
                        for(Id piid: ILPIrow.get(ilid).KeySet())
                        {
                            Inventory_Location_Product__c newilp = ILPImap.get(ilid).get(piid);
                            newilp.Received_Quantity__c = newilp.Received_Quantity__c + ILPIrow.get(ilid).get(piid);
                            newilp.Source_Type__c = 'System';
                            //  newilp.Unit_Price__c = newilp.Unit_Price__c + ProdUProw.get(ilid).get(piid);
                            ILPlistUpd.add(newilp);
                            system.debug('before ILPlistUpd->>>'+ILPlistUpd);
                            
                        }
                        
                        } 
                      
                      Lot_Product__c LotPro = new Lot_Product__c();
                       
                    
                     List<Lot_Product__c>LotProductList = new List<Lot_Product__c>();
             //After end of main for loop do update operation
            List<Lot_Product__c> lotproducts=[select Product__c,Lot__c,Quantity__c,Bin__c,Location__c from Lot_Product__c where Lot__c=:lotIds];

                       for(Lot_Product__c ltp:lotproducts)
                        {
                        LotProductList.add(ltp);
                        }

                        
                        for(excelwrap row : excelList){
                            
                            Product_Serial_Number__c psn = new Product_Serial_Number__c();
                            psn.Inventory_Location__c = row.InventoryLocation;
                            psn.Product_Code__c = InvPro.get(row.Inventory);
                            psn.Serial_Number__c = row.SerialCode;
                            psn.Status__c = 'Available';
                            psn.Inventory_Location_Product__c = ILPImap.get(row.InventoryLocation).get(row.Inventory).Id;
                            if(row.Expirydate != null)
                                psn.Expiry_date__c = Date.valueOf(row.Expirydate); 
                            if(row.LotName !=null)
                            {
                                psn.Lot__c= row.LotName;
                            }              
                            if(row.bin !=null)
                            {
                                psn.Bin__c = row.Bin;
                            }
                            psn.Unit_Price__c = row.unitPrice;
                            psnList.add(psn);
                            
                            //code to handle Lot
                            
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
LotPro.Quantity__c +=1;
//LotProductList.add(LotPro);
}
else
{
LotPro = new Lot_Product__c();
LotPro.Lot__c = Id.valueOf(row.LotName);
LotPro.Location__c =Id.valueOf(row.InventoryLocation);
LotPro.Bin__c = Id.valueOf(row.Bin);
LotPro.Quantity__c = 1;
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
  LotPro.Quantity__c = 1;
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
                        system.debug('before insert-->'+psnList);
                        if(psnList.size()>0)
                        {
                            upsert psnList; 
                        }
                        
                        
                        system.debug('After insert-->'+psnList);
                        for(Product_Serial_Number__c psn : psnList){
                            
                            Inventory_Location_Product_Line_Item__c lneItem= new Inventory_Location_Product_Line_Item__c(); 
                            lneItem.Inventory_Location_Product__c = ILPImap.get(psn.Inventory_Location__c).get(ProInv.get(psn.Product_Code__c)).Id;
                            lneItem.Product__c = psn.Product_Code__c;
                            lneItem.Received_Quantity__c = 1;
                            lneItem.Inventory_Location__c  = psn.Inventory_Location__c;
                            lneItem.Stock_Type__c = 'Direct Add';
                            lneItem.Attribute_Type__c = 'SERIALIZED';
                            lneItem.Product_Serial_Number__c = psn.Id; 
                            if(psn.Expiry_date__c != null)
                                lneItem.Product_Expiry_Date__c = psn.Expiry_date__c;
                            
                            if(psn.Lot__c!=null)
                            {
                                lneItem.Lot__c=psn.Lot__c;
                            }
                            
                            if(psn.Bin__c != null)
                            {
                                lneItem.Bin__c = psn.Bin__c ;
                            }
                            lneItem.Unit_Price__c = psn.Unit_Price__c;
                            //code to handle Auto allocate for backorder product 02-04-2020 //Added by Harish
                            if(productquant.containsKey(lneItem.Product__c)){
                                decimal num = 1 + productquant.get(lneItem.Product__c);
                                productquant.put(lneItem.Product__c, num);
                            } 
                            else{
                                productquant.put(lneItem.Product__c, 1);
                            }
                            //code ends
                            
                            ilpliList.add(lneItem);
                            
                            
                        }   
                        
                        //Finance code starts here changed on 13-05-2020  -by rashmi   
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
                        for(Inventory_Location_Product__c  i:ILPlistUpd)
                        {
                            if(i.Stock_Origin__c == 'Direct Add' && i.Unit_Price__c != null)
                            {
                                ObjectIdlist.add(i.Id);
                            }
                        }
                        system.debug('ObjectIdlist>>>>'+ObjectIdlist);
                        system.debug('wrapList>>>>'+wrapList);
                        if(ObjectIdlist.size() > 0)
                        {    
                            
                            LinkageServiceClass.createSLFromILPforSerial(ObjectIdlist,wrapList);
                            
                        }
                        
                    } 
                    catch(Exception e)
                    {
                        System.debug('Exception in ImportBulkProductForInventory :'+e);
                        System.debug('Exception in ImportBulkProductForInventory line:'+e.getLineNumber());
                    }      
                    
                    //Finance code Ends here
                    
                    insert ilpliList; // inserting ilpli
                    system.debug('inserting ilpliList>>>'+ilpliList);
                    update ILPlistUpd; // updating ILP 
                    system.debug('updating ILPlistUpd>>>'+ILPlistUpd);
                    
                    //code added to update Average Buying Price in PI
                    set<id> ProdTypeid=new set<id>();//created by rashmi to restrict Attribute type changing after updating inventories on 04-04-2020
                    list<Inventory_Location_Product_Line_Item__c>   lneItem=[select Product__c,Stock_Type__c, Attribute_Type__c,Unit_Price__c from Inventory_Location_Product_Line_Item__c where id In :ilpliList];
                    map<id,decimal> prolist=new map<id,decimal>();
                    map<id,decimal> ilplilist1 =new map<id,decimal>(); 
                    
                    for(Inventory_Location_Product_Line_Item__c prores :lneItem)
                    {   
                        ProdTypeid.add(prores.Product__c);//adding all product ids-by rashmi
                        if(prolist.containsKey(prores.Product__c))
                        {
                            decimal unitprice=prolist.get(prores.Product__c);
                            prolist.put(prores.Product__c,unitprice+prores.Unit_Price__c);
                        }
                        else
                        {
                            prolist.put(prores.Product__c,prores.Unit_Price__c);
                        }
                        if(ilplilist1.containsKey(prores.Product__c))
                        {
                            decimal counts=ilplilist1.get(prores.Product__c);
                            ilplilist1.put(prores.Product__c,counts+1);
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
                    //code added by rashmi on 04-04-2020 to restrict changing attribute type after inventory updates
                    List<Product2> Listprodtype;
                    Listprodtype =[select id,Name,Typecheck__c from Product2 where id =:ProdTypeid ];
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
                //}
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
            
            
        }
        
        contentFile = null;
        return null;
    }
    
    public Pagereference Refresh(){
        PageReference pg = new PageReference('/apex/ImportSerialProductForInventory');
        pg.setRedirect(true);
        return pg;
    }
}