public with sharing class HandleVendorProduct
{
    public void onBeforeInsert(List<Vendor_Product__c> lstNewVendorProd)
    {
        Set<Id> vendids=new Set<Id>();
        Set<Id> venlocids=new Set<Id>();
        Set<Id> prodids=new Set<Id>();
        Set<Id> conids=new Set<Id>();
        
        Boolean isPreferedExist=false;
        if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev2__Vendor_Product__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev2__Vendor_Product__c',new Set<String>{'id','sigmaerpdev2__Product_Name__c','sigmaerpdev2__Account_Name__c','sigmaerpdev2__VendorProductCode__c','sigmaerpdev2__Vendor_Location__c','sigmaerpdev2__Is_Preferred__c','sigmaerpdev2__Buying_Price__c'}))
        {
            for(Vendor_Product__c ProdrelatedVP : lstNewVendorProd)
            {
                vendids.add(ProdrelatedVP.Account_Name__c);
                venlocids.add(ProdrelatedVP.Vendor_Location__c);
                prodids.add(ProdrelatedVP.Product_Name__c);
                conids.add(ProdrelatedVP.Vendor_Contact__c);
                system.debug('vendids>>' + vendids);
                system.debug('venlocids>>' + venlocids);
                system.debug('prodids>>' + prodids);
                if(ProdrelatedVP.Is_Preferred__c)
                {
                    isPreferedExist=true;
                }
            }
            
            List<Contact> con=[select id,Name,Vendor_Location__c,Vendor_Location__r.Name from Contact where id in : conids];
            if(con.size()==0){
               lstNewVendorProd[0].addError('Please select contact first.');
            }
            else{
                if(lstNewVendorProd[0].Vendor_Location__c != con[0].Vendor_Location__c ){
                	lstNewVendorProd[0].addError('Please select contact related location:'+con[0].Vendor_Location__r.Name);
            	} 
            }
            List<Vendor_Product__c> vendordata=[Select id,Product_Name__c,Account_Name__c,VendorProductCode__c,Is_Preferred__c,Buying_Price__c from Vendor_Product__c where Product_Name__c in :prodids and Is_Preferred__c=true ];
            system.debug('Vendor_Product Ids>>' + vendordata);
            system.debug('Vendor_Product size>>' + vendordata.size());
            if(vendordata.size()==0)
            {
                system.debug('new vendor product list >>' + lstNewVendorProd);
                for(Vendor_Product__c DefaultVendor : lstNewVendorProd)
                {
                    system.debug(' Is_Preferred__c>>' +DefaultVendor.Is_Preferred__c);
                    if(DefaultVendor.Is_Preferred__c==false)
                    {             
                        system.debug('inside if5::' +DefaultVendor.Is_Preferred__c);
                        lstNewVendorProd[0].addError('Please Check Is Prefered Vendor to make default vendor for this product');
                    }
                    else
                        system.debug('Do Nothing...');
                }
            }
            if(isPreferedExist)
            {
                for(Vendor_Product__c DefaultVendor : vendordata)
                {
                    if(DefaultVendor.Is_Preferred__c)
                    {
                        lstNewVendorProd[0].Is_Preferred__c.adderror('Please Uncheck already Existing Default vendor for this product to make this vendor default!!');
                    }
                    else{
                        system.debug('Do Nothing...');
                    }
                }
                
            }
            
            Map<Id,Map<Id,List<Id>>> mapVendorProd=new Map<Id,Map<Id,List<Id>>>();
            Map<Id,Map<Id,List<Id>>> mapVPId=new Map<Id,Map<Id,List<Id>>>();
            
            Map<Id,Map<Id,List<String>>> Newmapvenprodcode = new Map<Id,Map<Id,List<String>>>();
            Map<Id,Map<Id,List<String>>> oldmapvenprodcode = new Map<Id,Map<Id,List<String>>>();
            
            List<Vendor_Product__c> lstOldvendorprod=new List<Vendor_Product__c>();
            lstOldvendorprod=[Select id,Product_Name__c,Account_Name__c,Vendor_Location__c,VendorProductCode__c,Is_Preferred__c,Buying_Price__c from Vendor_Product__c where Product_Name__c in :prodids and Vendor_Location__c in :venlocids];
            system.debug('lstOldvendorprod in vendor product >>' + lstOldvendorprod);
            system.debug('size of old vendor product list >>' + lstOldvendorprod.size());
            
            List<Vendor_Product__c> lstOldvendorproddata=new List<Vendor_Product__c>();
            lstOldvendorproddata=[Select id,Product_Name__c,Account_Name__c,Vendor_Location__c,VendorProductCode__c,Is_Preferred__c,Buying_Price__c from Vendor_Product__c where Product_Name__c in :prodids and Account_Name__c in : vendids];
            system.debug('lstOldvendorproddata in vendor product >>' + lstOldvendorproddata);
            system.debug('size of old vendor product list >>' + lstOldvendorproddata.size());
            
            
      
            for(Vendor_Product__c vpOldList: lstOldvendorprod)
    {
        system.debug('mapVendorProd.containsKey(vpOldList.Product_Name__c)'+mapVendorProd.containsKey(vpOldList.Product_Name__c));
        if(mapVendorProd.containsKey(vpOldList.Product_Name__c))
        {
            system.debug('get(vpOldList.Product_Name__c).containsKey(vpOldList.Account_Name__c)'+mapVendorProd.get(vpOldList.Product_Name__c).containsKey(vpOldList.Account_Name__c));
            if(mapVendorProd.get(vpOldList.Product_Name__c).containsKey(vpOldList.Account_Name__c))
            { 
                List<Id> ListOfexistlocs = mapVendorProd.get(vpOldList.Product_Name__c).get(vpOldList.Account_Name__c);
                ListOfexistlocs.add(vpOldList.Vendor_Location__c);
                
                
                
                Map<Id,List<Id>> MapOfVLocs = mapVendorProd.get(vpOldList.Product_Name__c);
                MapOfVLocs.put(vpOldList.Account_Name__c,ListOfexistlocs);
                system.debug('MapOfVLocs-->'+MapOfVLocs);
                
                
                Map<Id,List<Id>> OldMapOfVLocs = mapVendorProd.get(vpOldList.Product_Name__c);
                OldMapOfVLocs.put(vpOldList.Account_Name__c,new List<Id>{vpOldList.Vendor_Location__c});
                system.debug('OldMapOfVLocs-->'+OldMapOfVLocs);

                
                mapVendorProd.put(vpOldList.Product_Name__c,OldMapOfVLocs);
                system.debug('mapVendorProd>>>>>>..'+mapVendorProd);
                mapVPId.put(vpOldList.Product_Name__c,OldMapOfVLocs);
                system.debug('mapVPId>>>>>>..'+mapVPId);
            
            }
            else
            {
                List<Id> ListOfnewlocs=new List<Id>();
                ListOfnewlocs.add(vpOldList.Vendor_Location__c);
                system.debug('ListOfnewlocs>>>>>>..'+ListOfnewlocs);
                
                Map<Id,List<Id>> MapOfnewVLocs =mapVendorProd.get(vpOldList.Product_Name__c);
                MapOfnewVLocs.put(vpOldList.Account_Name__c,ListOfnewlocs);
                system.debug('MapOfnewVLocs-->'+MapOfnewVLocs);
                
                
                Map<Id,List<Id>> OldMapOfVLocs =mapVendorProd.get(vpOldList.Product_Name__c);
                OldMapOfVLocs.put(vpOldList.Account_Name__c,new List<Id>{vpOldList.Vendor_Location__c});
                system.debug('OldMapOfVLPros-->'+OldMapOfVLocs);
                
                mapVendorProd.put(vpOldList.Product_Name__c,MapOfnewVLocs);
                system.debug('mapVendorProd>>>>>>..'+mapVendorProd);
                mapVPId.put(vpOldList.Product_Name__c,OldMapOfVLocs);
                system.debug('mapVPId>>>>>>..'+mapVPId);
                
            }
        } 
        else
        {
            
            List<Id> ListOfnewlocs=new List<Id>();
            ListOfnewlocs.add(vpOldList.Vendor_Location__c);
            system.debug('ListOfnewlocs>>>>>>..'+ListOfnewlocs);
            
            
            Map<Id,List<Id>> MapOfnewVLocs =new Map<Id,List<Id>>();
            MapOfnewVLocs.put(vpOldList.Account_Name__c,ListOfnewlocs);
            system.debug('MapOfnewVLocs-->'+MapOfnewVLocs);
            
            
            Map<Id,List<Id>> OldMapOfVLocs =new Map<Id,List<Id>>();
            OldMapOfVLocs.put(vpOldList.Account_Name__c,new List<Id>{vpOldList.Vendor_Location__c});
            system.debug('OldMapOfVLPros-->'+OldMapOfVLocs);
            
            mapVendorProd.put(vpOldList.Product_Name__c,MapOfnewVLocs);
            system.debug('mapVendorProd>>>>>>..'+mapVendorProd);
            mapVPId.put(vpOldList.Product_Name__c,OldMapOfVLocs);
            system.debug('mapVPId>>>>>>..'+mapVPId);
            
        }
    }
         for(Vendor_Product__c vpOldList: lstOldvendorproddata)
    {
        system.debug('Newmapvenprodcode.containsKey(vpOldList.Product_Name__c)'+Newmapvenprodcode.containsKey(vpOldList.Product_Name__c));
        if(Newmapvenprodcode.containsKey(vpOldList.Product_Name__c))
        {
            system.debug('get(vpOldList.Product_Name__c).containsKey(vpOldList.Account_Name__c)'+Newmapvenprodcode.get(vpOldList.Product_Name__c).containsKey(vpOldList.Account_Name__c));
            if(Newmapvenprodcode.get(vpOldList.Product_Name__c).containsKey(vpOldList.Account_Name__c))
            { 
                
                List<String> ListOfexistvpcode = Newmapvenprodcode.get(vpOldList.Product_Name__c).get(vpOldList.Account_Name__c);
                ListOfexistvpcode.add(vpOldList.VendorProductCode__c);
                system.debug('ListOfexistvpcode>>>'+ListOfexistvpcode);
                
                Map<Id,List<String>> MapOfVpcodes = Newmapvenprodcode.get(vpOldList.Product_Name__c);
                MapOfVpcodes.put(vpOldList.Account_Name__c,ListOfexistvpcode);
                system.debug('MapOfVpcodes-->'+MapOfVpcodes);
                
                Map<Id,List<String>> OldMapOfVpcodes = Newmapvenprodcode.get(vpOldList.Product_Name__c);
                OldMapOfVpcodes.put(vpOldList.Account_Name__c,new List<String>{vpOldList.VendorProductCode__c});
                system.debug('OldMapOfVpcodes-->'+OldMapOfVpcodes);
                
                
                Newmapvenprodcode.put(vpOldList.Product_Name__c,MapOfVpcodes);
                oldmapvenprodcode.put(vpOldList.Product_Name__c,OldMapOfVpcodes);
            }
            else
            {
                List<String> ListOfnewvpcode = new List<String>();
                ListOfnewvpcode.add(vpOldList.VendorProductCode__c);
                system.debug('ListOfnewvpcode>>>'+ListOfnewvpcode);
            
                Map<Id,List<String>> MapOfnewVpcodes = Newmapvenprodcode.get(vpOldList.Product_Name__c);
                MapOfnewVpcodes.put(vpOldList.Account_Name__c,ListOfnewvpcode);
                system.debug('MapOfnewVpcodes-->'+MapOfnewVpcodes);
                
                Map<Id,List<String>> OldMapOfVpcodes = Newmapvenprodcode.get(vpOldList.Product_Name__c);
                OldMapOfVpcodes.put(vpOldList.Account_Name__c,new List<String>{vpOldList.VendorProductCode__c});
                system.debug('OldMapOfVpcodes-->'+OldMapOfVpcodes);
                
                
                Newmapvenprodcode.put(vpOldList.Product_Name__c,MapOfnewVpcodes);
                oldmapvenprodcode.put(vpOldList.Product_Name__c,OldMapOfVpcodes);
            }
        } 
        else
        {
            List<String> ListOfnewvpcode = new List<String>();
            ListOfnewvpcode.add(vpOldList.VendorProductCode__c);
            system.debug('ListOfnewvpcode>>>'+ListOfnewvpcode);
            
            Map<Id,List<String>> MapOfnewVpcodes = new Map<Id,List<String>>();
            MapOfnewVpcodes.put(vpOldList.Account_Name__c,ListOfnewvpcode);
            system.debug('MapOfnewVpcodes-->'+MapOfnewVpcodes);
                
            Map<Id,List<String>> OldMapOfVpcodes = new Map<Id,List<String>>();
            OldMapOfVpcodes.put(vpOldList.Account_Name__c,new List<String>{vpOldList.VendorProductCode__c});
            system.debug('OldMapOfVpcodes-->'+OldMapOfVpcodes);

            
            Newmapvenprodcode.put(vpOldList.Product_Name__c,MapOfnewVpcodes);
            oldmapvenprodcode.put(vpOldList.Product_Name__c,OldMapOfVpcodes);
            
        }
    }
  system.debug('Newmapvenprodcode out of loop------>>>'+Newmapvenprodcode);
  system.debug('oldmapvenprodcode out of loop------>>>'+oldmapvenprodcode);
        
  system.debug('mapVendorProd out of loop------>>>'+mapVendorProd);
  system.debug('mapVPId out of loop------>>>'+mapVPId);

        
         
            for(Vendor_Product__c checkdupvendor:lstNewVendorProd)
            {
                /*system.debug('1>>'+Newmapvenprodcode.containsKey(checkdupvendor.Product_Name__c));
                system.debug('2>>'+Newmapvenprodcode.get(checkdupvendor.Product_Name__c).containsKey(checkdupvendor.Account_Name__c));
                system.debug('3>>'+oldmapvenprodcode.containsKey(checkdupvendor.Product_Name__c));
                system.debug('4>>'+oldmapvenprodcode.get(checkdupvendor.Product_Name__c).containsKey(checkdupvendor.Account_Name__c));
                system.debug('5>>'+Newmapvenprodcode.get(checkdupvendor.Product_Name__c).get(checkdupvendor.Account_Name__c).contains(checkdupvendor.VendorProductCode__c));
                system.debug('6>>'+oldmapvenprodcode.get(checkdupvendor.Product_Name__c).get(checkdupvendor.Account_Name__c).contains(checkdupvendor.VendorProductCode__c));
                */
              if(mapVendorProd.containsKey(checkdupvendor.Product_Name__c) && mapVendorProd.get(checkdupvendor.Product_Name__c).containsKey(checkdupvendor.Account_Name__c))
                {
                    if(mapVendorProd.get(checkdupvendor.Product_Name__c).get(checkdupvendor.Account_Name__c).contains(checkdupvendor.Vendor_Location__c))
                    {
                        if(mapVPId.containsKey(checkdupvendor.Product_Name__c) && mapVPId.get(checkdupvendor.Product_Name__c).containsKey(checkdupvendor.Account_Name__c))
                        {
                            if(mapVPId.get(checkdupvendor.Product_Name__c).get(checkdupvendor.Account_Name__c).contains(checkdupvendor.Vendor_Location__c))
                            {
                                lstNewVendorProd[0].addError('Duplicate Location Found!!');
                            }
                        }
                    }
                    else
                    {
                        system.debug('Do Nothing...!!');
                    }
                }
                else if(Newmapvenprodcode.containsKey(checkdupvendor.Product_Name__c) && Newmapvenprodcode.get(checkdupvendor.Product_Name__c).containsKey(checkdupvendor.Account_Name__c))
                {
                    if(oldmapvenprodcode.containsKey(checkdupvendor.Product_Name__c) && oldmapvenprodcode.get(checkdupvendor.Product_Name__c).containsKey(checkdupvendor.Account_Name__c))
                        {
                            if(!Newmapvenprodcode.get(checkdupvendor.Product_Name__c).get(checkdupvendor.Account_Name__c).contains(checkdupvendor.VendorProductCode__c))
                            {
                                if(!oldmapvenprodcode.get(checkdupvendor.Product_Name__c).get(checkdupvendor.Account_Name__c).contains(checkdupvendor.VendorProductCode__c))
                                {
                                    lstNewVendorProd[0].addError('Vendor product code must be unique!!');
                                    
                                }
                        }
                    }
                    else
                    {
                        system.debug('Do Nothing...');
                    }
                }
                else
                {
                    system.debug('Do Nothing...');
                }
            }
        }         
    }
    public void onAfterUpdate(List<Vendor_Product__c> lstNewVendorProd)
    {
        Set<Id> prodids=new Set<Id>();
        for(Vendor_Product__c vProd : lstNewVendorProd)
        {
            if(vProd .Product_Name__c != null)                
                prodids.add(vProd.Product_Name__c);
        }
        Map<Id,Vendor_Product__c> venMap = new Map<Id,Vendor_Product__c>([Select id,Product_Name__c,Account_Name__c,Vendor_Location__c,VendorProductCode__c,Is_Preferred__c,Buying_Price__c from Vendor_Product__c where id not in:lstNewVendorProd and Is_Preferred__c=true and Product_Name__c in :prodids]);
        //List<Vendor_Product__c> newvendorList  =[Select id,Product_Name__c,Account_Name__c,Is_Preferred__c,Buying_Price__c from Vendor_Product__c where id in :lstOldvendorprod and Is_Preferred__c=true and Product_Name__c in :prodids];
        Map<ID,Vendor_Product__c> nullMap = new Map<ID,Vendor_Product__c>();
        Map<id,Vendor_Product__c> maplList = new Map<id,Vendor_Product__c>();
        set<Id> vendorthis = new set<Id>();
        List<Vendor_Product__c> vendorList = [Select id,Product_Name__c,Account_Name__c,Is_Preferred__c,Buying_Price__c,Vendor_Location__c,VendorProductCode__c from Vendor_Product__c where id in :lstNewVendorProd];
        system.debug('after update2>>>'+vendorList);
        
        for(Vendor_Product__c listVendor :vendorList){
            if(listVendor.Is_Preferred__c==true){
                maplList.put(listVendor.Id,listVendor);
            }                       
        }               
        
        for(Vendor_Product__c newvendor : venMap.values()){
            if(newvendor.Is_Preferred__c==true)
            {
                nullMap.put(newvendor.Id,newvendor);
                system.debug('after update2>>>'+nullMap);
            } 
        }
        if(maplList.size() >0 && nullMap.size() >0 )
        { 
            for(Vendor_Product__c vrList: lstNewVendorProd){
                vrList.addError('Please Uncheck already Existing Default vendor  to make this vendor default!!!');
            }            
        }
    }
}