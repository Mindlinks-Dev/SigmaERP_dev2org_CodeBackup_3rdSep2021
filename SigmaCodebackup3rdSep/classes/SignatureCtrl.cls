public without sharing class SignatureCtrl{

    public String recordId { get; set; }
   public String signatureId { get; set; }
   public Id salesid { get; set; }
    public Id ObjectId {get;set;}
    /*@AuraEnabled
    public static void saveSignature(Id salesid, String signatureBody){
       Attachment a = new Attachment();
       a.ParentId =salesid; // record id of object.
        a.Body = EncodingUtil.base64Decode(signatureBody);
        a.ContentType = 'image/png';
        a.Name = 'Signature Capture.png';
        insert a;
    }*/
    
    @AuraEnabled
    public static String fetchdetails(Id ObjectId)
    {
        system.debug('ObjectId>>>'+ObjectId);
        list<sigmaerpdev2__Product_transfer__c> pt =[Select id,sigmaerpdev2__To_Requested_Location__c,sigmaerpdev2__Transfer_Status__c,sigmaerpdev2__To_Bin__c from sigmaerpdev2__Product_transfer__c where id=:ObjectId];
        system.debug('pt>>>>>>'+pt);
        if(pt.size() > 0)
        {
            system.debug('Jai hind');
            if(pt[0].sigmaerpdev2__Transfer_Status__c == 'Product Verified')
            {
                system.debug('inside if at line no. 27');
                return 'true1';
            }
        }
        return 'success';
    }
	
	 public class listOfProductsWrapper{
        @AuraEnabled
        public List<ProductWrapper> mainWrapProdList{get;set;}
        public listOfProductsWrapper(List<ProductWrapper> mainWrapProdList){
            this.mainWrapProdList = mainWrapProdList;
        }
    }
	public class ProductWrapper { 
	@AuraEnabled
        public string producttransfer{get;set;}
		@AuraEnabled
        public string tolocation{get;set;}
		@AuraEnabled
        public string status{get;set;}
	@AuraEnabled
        public List<innerWrapper> wrapProdList{get;set;}
		
		 public ProductWrapper(string producttransfer,string tolocation,string status,List<innerWrapper> wrapProdList){
			 this.producttransfer=producttransfer;
			 this.tolocation=tolocation;
			 this.status=status;
			 this.wrapProdList=wrapProdList;
		 }
	}
	
	 public class innerWrapper {
	  @AuraEnabled
        public Decimal selQuantity{get;set;} 
       @AuraEnabled
        public String ProductName{get;set;} 
		@AuraEnabled
        public id productid{get;set;} 
       @AuraEnabled
        public Decimal quantity{get;set;}
		@AuraEnabled
        public String psn{get;set;} 
		@AuraEnabled
        public String lots{get;set;} 
		@AuraEnabled
        public String resons{get;set;}
       @AuraEnabled
        public String fromilp{get;set;} 
        @AuraEnabled
        public id ilplis{get;set;} 		


 		
		 public innerWrapper(Decimal selQuantity,String ProductName,id productid,Decimal quantity,String psn,String lots,String resons,string fromilp,id ilplis)
		 {
			     this.selQuantity = selQuantity; 
                 this.ProductName=ProductName;
				 this.productid=productid;
                 this.quantity=quantity;
                 this.psn=psn;
                 this.lots=lots;
                 this.resons=resons;
                 this.fromilp=fromilp;
                 this.ilplis=ilplis;				 
		 }
	}
	
	
    
      @AuraEnabled
        public static Attachment saveSignature(Id salesid, String signatureBody,String selJsonStr){
            system.debug('salesid@@'+salesid);
        //Blob signature = EncodingUtil.base64Decode(signatureBody);
          map<String,decimal> selectwrap=new map<String,decimal>();
		map<String,decimal> psnwrap=new map<String,decimal>();
		map<string,string> resonwrap=new map<string,string>();
		map<string,string> resonpsn=new map<string,string>();
         map<id,decimal> proid=new map<id,decimal>();
		 
            Attachment a = new Attachment();
            a.ParentId = salesid; // record id of object.
            a.Body = EncodingUtil.base64Decode(signatureBody);
            a.ContentType = 'image/png';
            a.Name = 'Signature Capture.png';
            insert a;
            system.debug('attach@@'+a);

        
      
 List<SignatureCtrl.listOfProductsWrapper> container = (List<SignatureCtrl.listOfProductsWrapper>)System.JSON.deserialize(selJsonStr,List<SignatureCtrl.listOfProductsWrapper>.class);                                                 
        System.debug('container===='+container);
        List<ProductWrapper> AllData = new List<ProductWrapper>();
		for(SignatureCtrl.listOfProductsWrapper temp : container){
            for(ProductWrapper p1 : temp.mainWrapProdList){
       List<innerWrapper> innerListData = new List<innerWrapper>();                                   
                    for(innerWrapper temp1 : p1.wrapProdList){  
					proid.put(temp1.productid,temp1.selQuantity);
			system.debug('proid'+proid);
                        
          	if(temp1.selQuantity != null){                        
              innerListData.add(new innerWrapper(temp1.selQuantity,temp1.ProductName,temp1.productid,temp1.quantity,temp1.psn,temp1.lots,temp1.resons,temp1.fromilp,temp1.ilplis));
                    if(temp1.psn!=null){
                         system.debug('psnwrap'+temp1.psn);
					psnwrap.put(temp1.psn,temp1.selQuantity);
                        system.debug('psnwrap'+psnwrap);
					if(temp1.resons=='--None--'){
						temp1.resons=null;
					}else{
					resonwrap.put(temp1.psn,temp1.resons);
					}
					}
					else{
					selectwrap.put(temp1.ilplis,temp1.selQuantity);
					if(temp1.resons=='--None--'){
						temp1.resons=null;
					}else{
					resonpsn.put(temp1.ilplis,temp1.resons);
                        
						} 
						}
               
                
            }
                        else{
                        if(temp1.selQuantity == null){  
                            return null;
                        }
                        }
                     
						  
			}
		 AllData.add(new ProductWrapper(p1.producttransfer,p1.tolocation,p1.status,innerListData)); 

		}
		}
		
		list<sigmaerpdev2__Product_Transfer_Inventory_Tracking__c> prdTrackListselect=[select sigmaerpdev2__Inventory_Location_Product_Line_Item__c,sigmaerpdev2__Received_qty__c,sigmaerpdev2__Product_Serial_Number__c,sigmaerpdev2__Ilp__c,sigmaerpdev2__Transferred_Qty__c,sigmaerpdev2__Product__c,sigmaerpdev2__Product__r.Name,sigmaerpdev2__Product_Transfer__c,sigmaerpdev2__Product_Serial_Number__r.Name,sigmaerpdev2__Lot__r.Name,sigmaerpdev2__Reason__c from sigmaerpdev2__Product_Transfer_Inventory_Tracking__c where sigmaerpdev2__Product_Transfer__c=:salesid];
			   system.debug('prdTrackListselect'+prdTrackListselect);
            for(ProductWrapper temp : AllData){
                system.debug('temp'+temp);
                List<innerWrapper> innerData = temp.wrapProdList;                
                for(innerWrapper innerObj :innerData){
				   for(sigmaerpdev2__Product_Transfer_Inventory_Tracking__c temp1:prdTrackListselect){

					  if(temp1.sigmaerpdev2__Product_Serial_Number__c!=null){
				 temp1.sigmaerpdev2__Received_qty__c=psnwrap.get(temp1.sigmaerpdev2__Product_Serial_Number__r.Name);
				    
					  temp1.sigmaerpdev2__Reason__c=resonwrap.get(temp1.sigmaerpdev2__Product_Serial_Number__r.Name);
				   
					 }else{
				   temp1.sigmaerpdev2__Received_qty__c=selectwrap.get(temp1.sigmaerpdev2__Inventory_Location_Product_Line_Item__c);
				  
				   temp1.sigmaerpdev2__Reason__c=resonpsn.get(temp1.sigmaerpdev2__Inventory_Location_Product_Line_Item__c);
				   	   
			   }
			   }
				}
			}
			    if(prdTrackListselect.size() > 0){
                update prdTrackListselect;
				system.debug('prdTrackList'+prdTrackListselect);
            }
			
		
		  map<id,decimal> selectqtys=new  map<id,decimal> ();
            for(ProductWrapper temp : AllData){
                List<innerWrapper> innerData = temp.wrapProdList;                
                for(innerWrapper innerObj :innerData){
                     if(selectqtys.Containskey(innerObj.productid)){
                          Decimal qty=selectqtys.get(innerObj.productid);
                        selectqtys.put(innerObj.productid,(qty + innerObj.SelQuantity));
                     }else{
                           selectqtys.put(innerObj.productid,innerObj.SelQuantity);
                     }
                }
            }
			
     list<sigmaerpdev2__Product_Request_Line_Item__c> prdTrackList=[select id,name,sigmaerpdev2__Product_Transfer__c,sigmaerpdev2__Product__c,sigmaerpdev2__Product__r.Name,OwnerId,sigmaerpdev2__Quantity__c,sigmaerpdev2__Quantity_Received__c from sigmaerpdev2__Product_Request_Line_Item__c where sigmaerpdev2__Product_Transfer__c=:salesid and sigmaerpdev2__Product__c=:proid.keySet()];
			    system.debug('prdTrackList'+prdTrackList);
				
				   for(sigmaerpdev2__Product_Request_Line_Item__c temp1:prdTrackList){ 
                      
			 temp1.sigmaerpdev2__Quantity_Received__c=selectqtys.get(temp1.sigmaerpdev2__Product__c);
                       system.debug('select'+temp1.sigmaerpdev2__Quantity_Received__c);

			   }
				
				
			    if(prdTrackList.size() > 0){
                update prdTrackList;
				system.debug('prdTrackList'+prdTrackList);
            }
		
		return a;
        }
        
        @AuraEnabled
        public static void saveattachment(Attachment attachmentimage){
            Attachment Attchnt = [select id,ParentId from Attachment where Id =: attachmentimage.Id limit 1];
            system.debug('attachmentimage@@'+attachmentimage);
            Id ptid = Attchnt.ParentId;
            Id attchmentid = attachmentimage.Id;
            system.debug('ptid'+ptid);
            system.debug('attchmentid@@'+attchmentid);
         
			
       
	   PageReference pref = Page.Emaill;
            pref.getParameters().put('id',ptid);
            //String signatureId =  null;
            //signatureId = '00P6F0000361K8GUAU';
            pref.getParameters().put('signatureId',attchmentid);
            pref.setRedirect(true);
            Blob b = pref.getContentAsPDF();
            system.debug('blob@@'+b);
            //Create Document
            ContentVersion cv = new ContentVersion();
            cv.Title = 'Product Transfer Confirmation';
            cv.PathOnClient = '/'+'Product Transfer Confirmation.pdf';
            cv.VersionData = b;
            cv.IsMajorVersion = true;
            cv.FirstPublishLocationId = ptid;
            // cv.ContentUrl='pdf';        
            insert cv;
            system.debug('cv'+cv);
            /*
            List<ContentDocumentLink> ContList = new List<ContentDocumentLink>();
            for(ContentDocumentLink ConteDoc : [select id,Visibility,LinkedEntityId from ContentDocumentLink where LinkedEntityId =: SalesAgreementId])
            {
                ConteDoc.Visibility = 'AllUsers';
                ConteDoc.ShareType = 'V';
                ContList.add(ConteDoc);
            }
            System.debug(ContList);
            update ContList;*/
          


           if(ptid !=null)
            {
               list<sigmaerpdev2__Product_transfer__c> SA =[Select id,sigmaerpdev2__To_Requested_Location__c,sigmaerpdev2__Request_Location__c,sigmaerpdev2__From_Bin__c,sigmaerpdev2__Transfer_Status__c,sigmaerpdev2__To_Bin__c from sigmaerpdev2__Product_transfer__c where id=:ptid];
               system.debug('SA>>>>>>'+SA);
                SA[0].sigmaerpdev2__Transfer_Status__c='Product Verified';
                //SA.Signature_Captured_Date_Time__c = DateTime.now();
                
                Update SA;
                system.debug('SA>>>>>>'+SA);
                
                if(SA[0].sigmaerpdev2__Transfer_Status__c=='Product Verified')
                {
                    system.debug('inside');
                ProductTransferInventory.isverified(SA);
                   
                }
                
            }
    
        }    
      
    
    @AuraEnabled
    public static List<listOfProductsWrapper> requestdetails(Id SAId){
		string producttransfer;
		string tolocation;
		string status;
		 Map<Id,Decimal> lineItemProdId = new Map<Id,Decimal>();
		   List<ProductWrapper> wrapProdListManual = new List<ProductWrapper>();
		    List<listOfProductsWrapper> wrapProdListOuter = new List<listOfProductsWrapper>();
        List<innerWrapper> innerWrapperList = new List<innerWrapper>(); 
    
     list<sigmaerpdev2__Product_transfer__c> prdLineObj=[select id,name,sigmaerpdev2__To_Requested_Location__r.Name,OwnerId,sigmaerpdev2__Product_Request__r.Name,sigmaerpdev2__Transfer_Status__c,(select id,name,sigmaerpdev2__Product__r.Name,OwnerId,sigmaerpdev2__Transferred_Qty__c,sigmaerpdev2__Received_qty__c,sigmaerpdev2__Reason__c from Product_Transfer_Inv_Tracking__r)from sigmaerpdev2__Product_transfer__c where id=:SAId];
        system.debug('prdLineObj'+prdLineObj);
		 for(sigmaerpdev2__Product_transfer__c prdMainObj : prdLineObj){
   for(sigmaerpdev2__Product_Transfer_Inventory_Tracking__c prdLineObj1 : prdMainObj.Product_Transfer_Inv_Tracking__r){
	       lineItemProdId.put(prdLineObj1.sigmaerpdev2__Product__c, prdLineObj1.sigmaerpdev2__Transferred_Qty__c);
system.debug('lineItemProdId'+lineItemProdId);
            }
	 producttransfer=prdMainObj.name;
	 tolocation=prdMainObj.sigmaerpdev2__To_Requested_Location__r.Name;
	 status=prdMainObj.sigmaerpdev2__Transfer_Status__c;
		 }
		
 for(sigmaerpdev2__Product_Transfer_Inventory_Tracking__c prd :[select sigmaerpdev2__Inventory_Location_Product_Line_Item__c,sigmaerpdev2__Ilp__c,sigmaerpdev2__Product_Serial_Number__r.Name,sigmaerpdev2__Received_qty__c,sigmaerpdev2__Transferred_Qty__c,sigmaerpdev2__Product__c,sigmaerpdev2__Product__r.Name,sigmaerpdev2__Product_Transfer__c,sigmaerpdev2__Product_Serial_Number__c,sigmaerpdev2__Lot__r.Name from sigmaerpdev2__Product_Transfer_Inventory_Tracking__c where sigmaerpdev2__Product_Transfer__c=:prdLineObj]){
     system.debug('prd'+prd);
  innerWrapper iwrap = new innerWrapper(null,null,null,null,null,null,null,null,null);    
  iwrap.selQuantity = null; 
  iwrap.resons=null;
  iwrap.fromilp=prd.sigmaerpdev2__Ilp__c;
  iwrap.psn=prd.sigmaerpdev2__Product_Serial_Number__r.Name;
  iwrap.lots=prd.sigmaerpdev2__Lot__r.Name;
  iwrap.ProductName=prd.sigmaerpdev2__Product__r.Name;
  iwrap.productid=prd.sigmaerpdev2__Product__c;
  iwrap.quantity=prd.sigmaerpdev2__Transferred_Qty__c;
  iwrap.ilplis=prd.sigmaerpdev2__Inventory_Location_Product_Line_Item__c;
  innerWrapperList.add(iwrap);
 }
wrapProdListManual.add(new ProductWrapper(producttransfer,tolocation,status,innerWrapperList));
	system.debug('wrapProdListManual'+wrapProdListManual);
	  wrapProdListOuter.add(new listOfProductsWrapper(wrapProdListManual));
        System.debug('wrapProdListOuter==='+wrapProdListOuter);
        return wrapProdListOuter;
    
    }
}