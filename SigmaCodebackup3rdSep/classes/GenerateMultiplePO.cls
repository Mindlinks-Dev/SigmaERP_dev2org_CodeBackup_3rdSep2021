public with sharing class GenerateMultiplePO {
    @AuraEnabled
    public static List<String> getPOStatus()
    {
        List<String> options;
        options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Purchase_Order__c.Status__c.getDescribe();
        system.debug('fieldResult-->>'+fieldResult);
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) 
        {
            options.add(f.getLabel());
            system.debug('options>>'+options);
        }   
        //}
        return options;        
    }
    @AuraEnabled
    public static Default_Parameters__c getApprDetails()
    {
        Default_Parameters__c fetchdefaultflag;
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('Default_Parameters__c')
        && CRUD_FLS_CheckUtility.checkReadPermission('Default_Parameters__c',new Set<String>{'Approval_Process_Not_Needed__c','PO_to_Contact__c'}))
        {*/
        fetchdefaultflag= [select Approval_Process_Not_Needed__c,PO_to_Contact__c from Default_Parameters__c Limit 1];
        system.debug('fetchdefaultflag>>>'+fetchdefaultflag);
        //}
        return fetchdefaultflag;
    }
    @AuraEnabled
    public Static Decimal getbuyingprice(ID  productid,Id vendorID,string locName)
    {    
        Vendor_Product__c  price =[Select Id,Name,Buying_Price__c,Vendor_Location__c,Vendor_Location__r.Name,Product_Name__c,Product_Name__r.Name from Vendor_Product__c where Product_Name__c =:productid and Account_Name__c =:vendorID and Vendor_Location__r.Name =:locName];
        Decimal buyingPrice=price.Buying_Price__c;
        return buyingPrice;
    }
    @AuraEnabled
    public static List<MultiplePOWrap> saveMultiplePO(String ListofMultiplePOs,Date expectedDate){
        system.debug('save PO list'+ListofMultiplePOs);
        system.debug('expectedDate>>>'+expectedDate);
        List<MultiplePOWrap> POWrap = (List<MultiplePOWrap>)System.JSON.deserialize(ListofMultiplePOs, List<MultiplePOWrap>.class);
        System.debug('POWrap>>'+POWrap);
        
        Map<Id,Map<String,Set<Id>>> checkVPLocmap =  new Map<Id, Map<String, Set<Id>>>(); //used to hold vendor id, vendor location id and product ids
        Map<Id,Set<Id>> checkVProdmap =  new Map<Id,Set<Id>>(); //used to hold vendor id,product ids   
        List<Purchase_Order__c> POList = new List<Purchase_Order__c>();
        List<Purchase_Order_Product__c> POPList = new List<Purchase_Order_Product__c>();
        Default_Parameters__c fetchdefaultflag= [select Approval_Process_Not_Needed__c,PO_to_Contact__c from Default_Parameters__c Limit 1];
        system.debug('fetchdefaultflag>>>'+fetchdefaultflag);
        if(fetchdefaultflag.PO_to_Contact__c == true)
        {
            for(MultiplePOWrap multiplepo:POWrap)
            {
                system.debug('checkVPLocmap.containsKey(multiplepo.vendorId)'+checkVPLocmap.containsKey(multiplepo.vendorId));
                if(checkVPLocmap.containsKey(multiplepo.vendorId))
                {
                    system.debug('get(multiplepo.vendorId).containsKey(multiplepo.vendorLocation)'+checkVPLocmap.get(multiplepo.vendorId).containsKey(multiplepo.vendorLocation));
                    if(checkVPLocmap.get(multiplepo.vendorId).containsKey(multiplepo.vendorLocation))
                    { 
                        Set<Id> SetOfexistProds = checkVPLocmap.get(multiplepo.vendorId).get(multiplepo.vendorLocation);
                        SetOfexistProds.add(multiplepo.POP.Product__c);
                        system.debug('SetOfexistProds>>>>>>..'+SetOfexistProds);
                        
                        Map<String,Set<Id>> MapOfVLPros = checkVPLocmap.get(multiplepo.vendorId);
                        MapOfVLPros.put(multiplepo.vendorLocation,SetOfexistProds);
                        system.debug('MapOfVLPros-->'+MapOfVLPros);
                        
                        checkVPLocmap.put(multiplepo.vendorId,MapOfVLPros);
                        system.debug('checkVPLocmap>>>>>>..'+checkVPLocmap);
                    }
                    else
                    {
                        Set<Id> SetOfNewProds=new Set<Id>();
                        SetOfNewProds.add(multiplepo.POP.Product__c);
                        system.debug('SetOfNewProds>>>>>>..'+SetOfNewProds);
                        
                        Map<String,Set<Id>> MapOfVLocPros = new Map<String,Set<Id>>();
                        MapOfVLocPros.put(multiplepo.vendorLocation,SetOfNewProds);
                        system.debug('MapOfVLocPros-->'+MapOfVLocPros);
                        
                        checkVPLocmap.put(multiplepo.vendorId,MapOfVLocPros);
                        system.debug('checkVPLocmap>>>>>>..'+checkVPLocmap);
                        
                        Purchase_Order__c po = new Purchase_Order__c();
                        po.Product_Supplier__c = multiplepo.vendorId;
                        po.Status__c = multiplepo.status;
                        po.Order_Date__c = system.today();
                        //   po.Expected_Date__c = multiplepo.POP.Expected_Delivery_Date__c;
                        po.Expected_Date__c = expectedDate ;
                        po.Vendor_Location_Name__c = multiplepo.vendorLocation;
                        POList.add(po);
                    }
                } 
                else{
                    Set<Id> SetOfVenLocProds=new Set<Id>();
                    SetOfVenLocProds.add(multiplepo.POP.Product__c);
                    system.debug('SetOfVenLocProds>>>>>>..'+SetOfVenLocProds);
                    
                    Map<String,Set<Id>> MapOfVenLocPros = new Map<String,Set<Id>>();
                    MapOfVenLocPros.put(multiplepo.vendorLocation,SetOfVenLocProds);
                    system.debug('MapOfVenLocPros-->'+MapOfVenLocPros);
                    
                    checkVPLocmap.put(multiplepo.vendorId,MapOfVenLocPros);
                    system.debug('checkVPLocmap>>>>>>..'+checkVPLocmap);
                    
                    Purchase_Order__c po = new Purchase_Order__c();
                    po.Product_Supplier__c = multiplepo.vendorId;
                    po.Status__c = multiplepo.status;
                    po.Order_Date__c = system.today();
                    //   po.Expected_Date__c = multiplepo.POP.Expected_Delivery_Date__c;
                    po.Expected_Date__c = expectedDate;
                    po.Vendor_Location_Name__c = multiplepo.vendorLocation;
                    POList.add(po);
                }
            }
            system.debug('checkVPLocmap'+checkVPLocmap);
            
            insert POList;
            system.debug('POList : '+POList);
            
            Map<Id,Map<String,Id>> POIDMap = new Map<Id,Map<String,Id>>();
            for(Purchase_Order__c povend : POList)
            {
                if(POIDMap.containsKey(povend.Product_Supplier__c))
                {
                    system.debug('get(povend.Product_Supplier__c).containsKey(povend.Vendor_Location_Name__c)'+POIDMap.get(povend.Product_Supplier__c).containsKey(povend.Vendor_Location_Name__c));
                    if(POIDMap.get(povend.Product_Supplier__c).containsKey(povend.Vendor_Location_Name__c))
                    { 
                        Map<String,Id> MapOfVLPros = POIDMap.get(povend.Product_Supplier__c);
                        MapOfVLPros.put(povend.Vendor_Location_Name__c,povend.Id);
                        system.debug('MapOfVLPros-->'+MapOfVLPros);
                        
                        POIDMap.put(povend.Product_Supplier__c,MapOfVLPros);
                        system.debug('POIDMap>>>>>>..'+POIDMap);
                    }
                    else
                    {
                        Map<String,Id> MapOfVLocPros = POIDMap.get(povend.Product_Supplier__c);
                        MapOfVLocPros.put(povend.Vendor_Location_Name__c,povend.Id);
                        system.debug('MapOfVLocPros-->'+MapOfVLocPros);
                        
                        POIDMap.put(povend.Product_Supplier__c,MapOfVLocPros);
                        system.debug('POIDMap>>>>>>..'+POIDMap);
                    }
                } 
                else{
                    Map<String,Id> MapOfVenLocPros = new Map<String,Id>();
                    MapOfVenLocPros.put(povend.Vendor_Location_Name__c,povend.Id);
                    system.debug('MapOfVenLocPros-->'+MapOfVenLocPros);
                    
                    POIDMap.put(povend.Product_Supplier__c,MapOfVenLocPros);
                    system.debug('POIDMap>>>>>>..'+POIDMap);
                }
            }
            
            system.debug('POIDMap--->'+POIDMap);
            Purchase_Order_Product__c pop;
            for(MultiplePOWrap multiplepo:POWrap)
            {
                system.debug('multiplepo : '+multiplepo);
                pop = new Purchase_Order_Product__c();
                pop.Purchase_Order__c = POIDMap.get(multiplepo.vendorId).get(multiplepo.vendorLocation);
                pop.Product__c= multiplepo.POP.Product__c;
                pop.Buying_Price__c= multiplepo.POP.Buying_Price__c;
                pop.Quantity__c= multiplepo.POP.Quantity__c;
                pop.Received_Quantity__c = Double.valueOf(multiplepo.POP.Quantity__c);
                pop.Status__c = 'Open';
                pop.Discount__c= multiplepo.POP.Discount__c;
                pop.Price__c=multiplepo.POP.Price__c;
                pop.Expected_Delivery_Date__c= multiplepo.POP.Expected_Delivery_Date__c;
                
                POPList.add(pop);
                system.debug('POPList : '+POPList);
            }
            upsert POPList; 
            //send an email notification to the Contact of perticular Location
            List<String> errorMessages = new List<String>();
            
            String mailBody = '<table border="1"><tr><th>PO No</th><th>Vendor Name</th><th>Vendor Location</th><th>POP No</th><th>Product Name</th><th>Ordered Quantity</th><th>Ordered Date</th><th>Expt. Delivery Date</th><th>Buying Price</th><th>Discount(%)</th><th>Total Buying Price</th><th>PO Status</th></tr>';
            Map<Id,String> prodIdProdNameMap=new Map<Id,String>();
            List<Purchase_Order_Product__c> ListofPOPs = [SELECT id,Name,Purchase_Order__r.Name,Purchase_Order__r.Product_Supplier__r.Name,Purchase_Order__r.Vendor_Location_Name__c,Purchase_Order__r.Order_Date__c,Purchase_Order__r.Status__c,Purchase_Order__r.Expected_Date__c,Product__c,Product__r.Name,Buying_Price__c,Quantity__c,Discount__c,Price__c from Purchase_Order_Product__c where id in:POPList ];
            system.debug('ListofPOPs>>>>>>...'+ListofPOPs);
            Set<Id> vendids=new Set<Id>();
            Set<ID> productid= new Set<Id>();
            for(Purchase_Order_Product__c popvends: ListofPOPs)
            {
                vendids.add(popvends.Purchase_Order__r.Product_Supplier__c);
                productid.add(popvends.Product__c);
                system.debug('vendid>>>>>>...'+vendids);
            }
            List<Vendor_Product__c> listvendorEmails =[SELECT id,Name,Account_Name__c,Product_Name__c,Vendor_Location__c,Vendor_Contact__c,Vendor_Contact__r.Email from Vendor_Product__c where Account_Name__c in: vendids  and Product_Name__c in:productid];
            system.debug('listvendorEmails>>>>>>...'+listvendorEmails);
            if(!ListofPOPs.isEmpty()) 
            { 
                List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
                for (Purchase_Order_Product__c pops : ListofPOPs)
                {      
                    prodIdProdNameMap.put(pops.Product__c,pops.Product__r.Name);
                    mailBody += '<tr><td>'+pops.Purchase_Order__r.Name+'</td><td>'+pops.Purchase_Order__r.Product_Supplier__r.Name+'</td><td>'+pops.Purchase_Order__r.Vendor_Location_Name__c+'</td><td>'+pops.Name+'</td><td>'+pops.Product__r.Name+'</td><td>'+pops.Quantity__c+'</td><td>'+pops.Purchase_Order__r.Order_Date__c+'</td><td>'+pops.Purchase_Order__r.Expected_Date__c+'</td><td>'+pops.Buying_Price__c+'</td><td>'+pops.Discount__c+'</td><td>'+pops.Price__c+'</td><td>'+pops.Purchase_Order__r.Status__c+'</td> <tr>';        }
                String completeMailBody='<html>Dear Customer,<br/><br/>Purchase Order Submitted successfully!<br/><br/><br/>'+mailBody+'</table><br/><br/><br/>Regards,<br/>Mindlinks Slution Pvt Ltd.</html>';
                system.debug('completeMailBody>>'+completeMailBody);
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();    
                for(Vendor_Product__c vpemail: listvendorEmails )
                {
                    mail.setToAddresses(new List<String>{vpemail.Vendor_Contact__r.Email}); 
                    mail.setSubject('PO Generated Successfully!!');
                    mail.setHTMLBody(completeMailBody);
                    mail.setSaveAsActivity(false);  
                    mailList.add(mail);
                }
                system.debug('mailList>>'+mailList);
                //Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                if(!mailList.isEmpty()) {
                    try{
                        
                        Messaging.sendEmail(mailList);
                    }
                    catch (Exception ex) {
                        errorMessages.add('Unable to send email to Tech: '+ ex.getStackTraceString());
                    }
                }
            }
        }
        else{
            for(MultiplePOWrap multiplepo:POWrap)
            {
                system.debug('checkVProdmap.containsKey(multiplepo.vendorId)'+checkVProdmap.containsKey(multiplepo.vendorId));
                if(checkVProdmap.containsKey(multiplepo.vendorId))
                {
                    Set<Id> SetOfexistProds = checkVProdmap.get(multiplepo.vendorId);
                    SetOfexistProds.add(multiplepo.POP.Product__c);
                    system.debug('SetOfexistProds>>>>>>..'+SetOfexistProds);
                    
                    checkVProdmap.put(multiplepo.vendorId,SetOfexistProds);
                    system.debug('checkVProdmap>>>>>>..'+checkVProdmap);
                } 
                else{
                    Set<Id> SetOfVenProds=new Set<Id>();
                    SetOfVenProds.add(multiplepo.POP.Product__c);
                    system.debug('SetOfVenProds>>>>>>..'+SetOfVenProds);
                    
                    checkVProdmap.put(multiplepo.vendorId,SetOfVenProds);
                    system.debug('checkVProdmap>>>>>>..'+checkVProdmap);
                    
                    Purchase_Order__c po = new Purchase_Order__c();
                    po.Product_Supplier__c = multiplepo.vendorId;
                    po.Status__c = multiplepo.status;
                    po.Order_Date__c = system.today();
                    //   po.Expected_Date__c = multiplepo.POP.Expected_Delivery_Date__c;
                    po.Expected_Date__c = expectedDate;
                    //po.Vendor_Location_Name__c = multiplepo.vendorLocation;
                    POList.add(po);
                }
            }
            system.debug('checkVProdmap'+checkVProdmap);
            insert POList;
            system.debug('POList : '+POList);
            
            Map<Id,Id> POIDMap = new Map<Id,Id>();
            for(Purchase_Order__c povend : POList)
            {
                POIDMap.put(povend.Product_Supplier__c,povend.id);
                system.debug('POIDMap>>>>>>..'+POIDMap);
            }
            
            system.debug('POIDMap--->'+POIDMap);
            Purchase_Order_Product__c pop;
            for(MultiplePOWrap multiplepo:POWrap)
            {
                if(checkVProdmap.containsKey(multiplepo.vendorId) && checkVProdmap.containsKey(multiplepo.vendorId))
                {
                    system.debug('multiplepo : '+multiplepo);
                    pop = new Purchase_Order_Product__c();
                    pop.Purchase_Order__c = POIDMap.get(multiplepo.vendorId);
                    pop.Product__c= multiplepo.POP.Product__c;
                    pop.Buying_Price__c= multiplepo.POP.Buying_Price__c;
                    pop.Quantity__c= pop.Quantity__c + multiplepo.POP.Quantity__c;
                    pop.Received_Quantity__c = Double.valueOf(multiplepo.POP.Quantity__c);
                    pop.Status__c = 'Open';
                    pop.Discount__c= multiplepo.POP.Discount__c;
                    pop.Price__c=multiplepo.POP.Price__c;
                    pop.Expected_Delivery_Date__c= multiplepo.POP.Expected_Delivery_Date__c;
                    
                    POPList.add(pop);
                    system.debug('POPList : '+POPList);
                }
                else
                {
                    system.debug('multiplepo : '+multiplepo);
                    pop = new Purchase_Order_Product__c();
                    pop.Purchase_Order__c = POIDMap.get(multiplepo.vendorId);
                    pop.Product__c= multiplepo.POP.Product__c;
                    pop.Buying_Price__c= multiplepo.POP.Buying_Price__c;
                    pop.Quantity__c= multiplepo.POP.Quantity__c;
                    pop.Received_Quantity__c = Double.valueOf(multiplepo.POP.Quantity__c);
                    pop.Status__c = 'Open';
                    pop.Discount__c= multiplepo.POP.Discount__c;
                    pop.Price__c=multiplepo.POP.Price__c;
                    pop.Expected_Delivery_Date__c= multiplepo.POP.Expected_Delivery_Date__c;
                    
                    POPList.add(pop);
                    system.debug('POPList : '+POPList);
                }
                
            }
            upsert POPList; 
        }
        return POWrap;
    }
    
    @AuraEnabled
    public static Vendor_Product__c fetchVendorInfo(Id vendorId,String venLocName ,Id productId)
    {
        //String vendorName;
        Vendor_Product__c vpdata =[SELECT Account_Name__c,Account_Name__r.Name,Vendor_Contact__c,Vendor_Contact__r.Email,VendorProductCode__c,Vendor_Location__c,Vendor_Location__r.Name,Current_Stock__c,Buying_Price__c,Product_Name__c,Product_Name__r.Name,Product_Name__r.ProductCode from Vendor_Product__c Where Account_Name__c=:vendorId and Vendor_Location__r.Name=:venLocName and Product_Name__c=:productId];
        system.debug('vpdata>>'+vpdata);
        /*if(vplist.size()>0)
{
for(Vendor_Product__c vpdata : vplist)
vendorName = vpdata.Account_Name__r.Name; 
}*/
        return vpdata;
    }
    
    
    @AuraEnabled
    public static wrapperClass loadvendorProductDetails(Id ProductId)
    {
        system.debug('ProductId>'+ProductId);
        wrapperClass returnwrapperClass = new  wrapperClass ();        
        returnwrapperClass.lstVendorProd = [SELECT Account_Name__c,Account_Name__r.Name,VendorProductCode__c,Vendor_Location__c,Vendor_Location__r.Name,Current_Stock__c,Buying_Price__c,Product_Name__c,Product_Name__r.Name,Product_Name__r.ProductCode from Vendor_Product__c Where Product_Name__c=:ProductId order by Account_Name__r.Name,Vendor_Location__r.Name];
        returnwrapperClass.size=returnwrapperClass.lstVendorProd.size();
        for(Vendor_Product__c vendprods : returnwrapperClass.lstVendorProd )
        {
            returnwrapperClass.ProductName = vendprods.Product_Name__r.Name;
            returnwrapperClass.ProductCode = vendprods.Product_Name__r.ProductCode;
        }
        system.debug('returnwrapperClass'+returnwrapperClass);
        return returnwrapperClass;    
    }
    public class MultiplePOWrap{
        // @AuraEnabled public List<Purchase_Order__c> lstPO{get;set;}
        // @AuraEnabled public List<Purchase_Order_Product__c> lstPOP{get;set;}
        @AuraEnabled public Purchase_Order_Product__c POP{get;set;}
        @AuraEnabled public String vendorName {get;set;}
        @AuraEnabled public String vendorId {get;set;}
        @AuraEnabled public String vendorLocation {get;set;}
        
        @AuraEnabled public String status {get;set;}
        @AuraEnabled public String POSubmitted {get;set;} 
        @AuraEnabled public Date expectedDate {get;set;}
        
    }
    public class wrapperClass{
        @AuraEnabled public List<Vendor_Product__c> lstVendorProd{get;set;}
        @AuraEnabled public String ProductName {get;set;}
        @AuraEnabled public String ProductCode {get;set;}
        @AuraEnabled public Integer size {get;set;}
    }
}