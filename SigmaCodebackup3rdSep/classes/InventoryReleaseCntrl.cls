public with sharing class InventoryReleaseCntrl {
    @AuraEnabled
    public static List<wrapperClass> fetchOrderLine()
    {
        List<wrapperClass> fulldata =new List<wrapperClass>();
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Sigma_Order__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Sigma_Order__c',new Set<String>{'id','Name','sigmaerpdev__Order_Created_Via__c'}) 
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'Id','Name','sigmaerpdev__Inventory_Release_Comment__c','sigmaerpdev__Is_Inventory_Release__c','sigmaerpdev__Parent_Account__r.Name','sigmaerpdev__Inventory_Status__c','sigmaerpdev__Sigma_Order__r.Name','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Order_Status__c','sigmaerpdev__Quantity__c','sigmaerpdev__Order__r.Name','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Customer__r.Name','sigmaerpdev__Packaged_Quantity__c','sigmaerpdev__Picking_Slip__r.sigmaerpdev__Status__c','IsInventoryUpdated__c'})
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new Set<String>{'id','Name','sigmaerpdev__ProductCode__c','sigmaerpdev__Available_Qty__c','sigmaerpdev__Total_Qty__c','sigmaerpdev__Delivered_Qty__c','sigmaerpdev__Reserved_Qty__c'}))
        {*/
		
			Order_Usage__c ou = [Select Sigma_order__c,Standard_object__c from Order_Usage__c limit 1];
			if(ou.Sigma_order__c)
			{
				
				List<Sigma_Order__c> SgmaOrderList=[Select id,Name,Order_Created_Via__c from Sigma_Order__c where Order_Created_Via__c !='Time Based Inventory' ];
				system.debug('SgmaOrderList@@'+SgmaOrderList);
				List<String> sgma=new List<String>();
				
				for(Sigma_Order__c sigmaRef:SgmaOrderList)
				{
					sgma.add(sigmaRef.Name);
				}
				             
				List<Product_Order_Price_Book__c> ordLines=[select id,Name,Parent_Account__r.Name,Quantity__c,Inventory_Status__c,Sigma_Order__r.Name,Product__c,Product__r.Name,Order_Status__c,Order__r.Name,Is_Inventory_Release__c,Inventory_Release_Comment__c,Net_Quantity__c,Customer__r.Name,Packaged_Quantity__c,Picking_Slip__r.Status__c,IsInventoryUpdated__c,(select Order_Line__c from Inventory_Allocations1__r where Status__c in('',null) ) from Product_Order_Price_Book__c where Order_Status__c IN('Pending' ,'Order Confirmed','Request for cancel') and  Inventory_Status__c='Reserve' and Sigma_Order__r.Name IN:sgma and Packaged_Quantity__c IN(0,null) and IsInventoryUpdated__c=true];
				system.debug('ordline>>'+ordLines);
				
				
				for(Product_Order_Price_Book__c ordref:ordLines)
				{
					if(ordref.Inventory_Allocations1__r.size()>0)
					{
						
						wrapperClass w=new wrapperClass(); 
						w.sigmaorder = true;
						w.orderLne=ordref;                    
						fulldata.add(w);
					}                
				}     	
			}
			else
			{
				List<Order> OrderList=[Select id from Order where Order_Created_Via__c ='POS'];
				system.debug('OrderList@@'+OrderList);
				Set<Id>Orderid = new Set<Id>();
				for(Order orderitem :OrderList)
				{
					Orderid.add(orderitem.id);
				}
				
				List<OrderItem> orderlinelist=[select id,OrderItemNumber,Quantity,Inventory_Status__c,Order.OrderNumber,Product2Id,Product2.Name,Order_Status__c,Is_Inventory_Release__c,Inventory_Release_Comment__c,IsInventoryUpdated__c,(Select id,Order_Product__c from Inventory_Allocations__r where Status__c in('',null) ) from OrderItem where Order_Status__c IN('Pending' ,'Order Confirmed','Request for cancel') and  Inventory_Status__c='Reserve' and OrderId IN:Orderid and Packaged_Quantity__c IN(0,null) and IsInventoryUpdated__c=true];          
				system.debug('ordline>>'+orderlinelist);
				for(OrderItem ordref:orderlinelist)
				{
					if(ordref.Inventory_Allocations__r.size()>0)
					{
						//Boolean isPicked = isPickedMap.get(ordref.Sigma_Order__r.Name);
					   // if(isPicked == true) continue;
						wrapperClass w=new wrapperClass(); 
						w.sigmaorder = false;
						w.orderlineproduct=ordref;                    
						fulldata.add(w);
					}                
				}
				
			}
            
       
        return fulldata;        
    }
    
    @AuraEnabled
    public static  void updateOrderLine(Id recordId,String comment,Boolean pickvalue)
    {
        /*if(CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Product_Order_Price_Book__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory__c')
           && CRUD_FLS_CheckUtility.checkObjCRUD('sigmaerpdev__Inventory_Location_Product_Line_Item__c')
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Product_Order_Price_Book__c',new Set<String>{'Id','Name','sigmaerpdev__Inventory_Release_Comment__c','sigmaerpdev__Is_Inventory_Release__c','sigmaerpdev__Parent_Account__r.Name','sigmaerpdev__Inventory_Status__c','sigmaerpdev__Sigma_Order__r.Name','sigmaerpdev__Product__c','sigmaerpdev__Product__r.Name','sigmaerpdev__Order_Status__c','sigmaerpdev__Order__c','sigmaerpdev__Quantity__c','sigmaerpdev__Order__r.Name','sigmaerpdev__Net_Quantity__c','sigmaerpdev__Customer__r.Name','sigmaerpdev__Packaged_Quantity__c'}) 
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory__c',new Set<String>{'id','Name','sigmaerpdev__Available_Qty__c','sigmaerpdev__Reserved_Qty__c','sigmaerpdev__ProductCode__c','sigmaerpdev__Total_Qty__c','sigmaerpdev__Shipped_Qty__c'}) 
           && CRUD_FLS_CheckUtility.checkReadPermission('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new Set<String>{'id','name','Inventory_Location_Product__c','Reserved_Quantity__c','Adjusted_Quantity1__c','Product__c','Inventory_Location__c','sigmaerpdev__Product_Serial_Number__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Product_Order_Price_Book__c',new set<String>{'sigmaerpdev__Inventory_Status__c','sigmaerpdev__Is_Inventory_Release__c','sigmaerpdev__Inventory_Release_Comment__c'}) 
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory__c',new set<String>{'sigmaerpdev__Available_Qty__c','sigmaerpdev__Reserved_Qty__c'})
           && CRUD_FLS_CheckUtility.checkFLS('sigmaerpdev__Inventory_Location_Product_Line_Item__c',new set<String>{'sigmaerpdev__Reserved_Quantity__c'}))
        {*/
		Map<id,decimal> ReservedQuant=new Map<id,decimal>();
		List<Id>LocationID=new List<Id>(); 
		Set<Id>Productserialnumber = new Set<Id>();
		Set<Id> productId=new Set<Id>();
		Map<String,Product_Order_Price_Book__c> prodmap=new Map<String,Product_Order_Price_Book__c>();
		Map<Id,decimal>ProQuant = new Map<Id,decimal>();
		List<Product_Order_Price_Book__c> invtr = new List<Product_Order_Price_Book__c> ();
		List<OrderItem> orderlinelist = new List<OrderItem> ();
		Order_Usage__c ou = [Select Sigma_order__c,Standard_object__c from Order_Usage__c limit 1];
		
		if(ou.Sigma_order__c)
		{
		    invtr=[select id,Name,Inventory_Release_Comment__c,Is_Inventory_Release__c,Parent_Account__r.Name,Inventory_Status__c,Sigma_Order__r.Name,Product__c,Product__r.Name,Order_Status__c,Order__c,Quantity__c,Order__r.Name,Net_Quantity__c,Customer__r.Name,Packaged_Quantity__c,(Select id,Name,ILPLI__c,Quantity__c,ILPLI__r.Available_Quantity__c,ILPLI__r.Reserved_Quantity__c,Picked_Quantity__c from Inventory_Allocations1__r)from Product_Order_Price_Book__c where Id=:recordId and Inventory_Status__c='Reserve'];
            Product_Order_Price_Book__c OrderLine=new Product_Order_Price_Book__c();            
            
			for(Product_Order_Price_Book__c  refObj:invtr)
            {
                for(Inventory_Allocation__c Allocateproduct: refObj.Inventory_Allocations1__r )
                {
                    ReservedQuant.put(Allocateproduct.ILPLI__c,Allocateproduct.Quantity__c);
                } 
                prodmap.put(refObj.Product__c,refObj);
				if(ProQuant.containsKey(refObj.Product__c))
				{
					ProQuant.put(refObj.Product__c,ProQuant.get(refObj.Product__c)+refObj.Net_Quantity__c);
				}
				else
				{
					ProQuant.put(refObj.Product__c,refObj.Net_Quantity__c);
				}
                productId.add(refObj.Product__c);                
            }
		}
		else
		{
		    orderlinelist=[select id,OrderItemNumber,Quantity,Inventory_Status__c,Order.OrderNumber,Product2Id,Product2.Name,Order_Status__c,Is_Inventory_Release__c,Inventory_Release_Comment__c,IsInventoryUpdated__c,(Select id,Order_Product__c,ILPLI__c,Quantity__c from Inventory_Allocations__r) from OrderItem where  Id=:recordId and Inventory_Status__c='Reserve'];          
			system.debug('ordline>>'+orderlinelist);
			for(OrderItem orderitems :orderlinelist)
			{
				for(Inventory_Allocation__c Allocateproduct:orderitems.Inventory_Allocations__r)
				{
					ReservedQuant.put(Allocateproduct.ILPLI__c,Allocateproduct.Quantity__c);
				}
				if(ProQuant.containsKey(orderitems.Product2Id))
				{
					ProQuant.put(orderitems.Product2Id,ProQuant.get(orderitems.Product2Id)+orderitems.Quantity);
				}
				else
				{
					ProQuant.put(orderitems.Product2Id,orderitems.Quantity);
				}
				//prodmap.put(orderitems.Product2Id,orderitems);
                productId.add(orderitems.Product2Id); 
			
			}
		}
            
            Inventory__c invObject=new Inventory__c();            
            Map<String,Inventory__c> prodInvmap=new Map<String,Inventory__c>();
            List<Inventory__c> pInv=new List<Inventory__c>();
            pInv=[Select id,Name,Available_Qty__c,Reserved_Qty__c,ProductCode__c,Total_Qty__c,Shipped_Qty__c from Inventory__c where ProductCode__c IN:productId];
            
            for(Inventory__c  Invent:pInv)
            {
                prodInvmap.put(Invent.ProductCode__c,Invent);
                
            }
            for(Inventory__c rff:pInv)
            {
                
                if(ProQuant.containsKey(rff.ProductCode__c))
                {
                    rff.Available_Qty__c =rff.Available_Qty__c + ProQuant.get(rff.ProductCode__c);
                    
                    rff.Reserved_Qty__c = rff.Reserved_Qty__c - ProQuant.get(rff.ProductCode__c);
                    
                }
			}
                List<Inventory_Location_Product_Line_Item__c>updateILPLI=new List<Inventory_Location_Product_Line_Item__c>();
                updateILPLI=[select id,name,Inventory_Location_Product__c,Reserved_Quantity__c,Adjusted_Quantity1__c,Product__c,Inventory_Location__c,Product_Serial_Number__c from Inventory_Location_Product_Line_Item__c where id=:ReservedQuant.keySet()];
                system.debug('updateILPLI>>'+updateILPLI);                
                Map<id,decimal> ilpmap=new Map<id,decimal>();
                
                for(Inventory_Location_Product_Line_Item__c ilpli:updateILPLI)
                {                 
                    if(ilpli.Inventory_Location__c!=null)
                    {
                        LocationID.add(ilpli.Inventory_Location__c);
                    }
          if(ilpli.Product_Serial_Number__c!=null)
          {
            Productserialnumber.add(ilpli.Product_Serial_Number__c);
            system.debug('Productserialnumber>>'+Productserialnumber);
          }
                    if(ReservedQuant.containsKey(ilpli.id))
                    {
                        if(ilpli.Reserved_Quantity__c!=0 && ilpli.Reserved_Quantity__c!=NULL )
                            ilpli.Reserved_Quantity__c-=ReservedQuant.get(ilpli.id);
                        
                        
                        if(ilpmap.containsKey(ilpli.Inventory_Location_Product__c))
                        {
                            decimal qty= ilpmap.get(ilpli.Inventory_Location_Product__c);
                            
                            ilpmap.put(ilpli.Inventory_Location_Product__c,qty+ReservedQuant.get(ilpli.id));
                        }
                        else
                        {
                            ilpmap.put(ilpli.Inventory_Location_Product__c,ReservedQuant.get(ilpli.id));
                        }                        
                    }                                  
                }
                List<Inventory_Location_Product__c> ILPLIST= [select id,name,Delivered_Quantity__c,Reserved_Quantity__c from Inventory_Location_Product__c where id=:ilpmap.keySet()];
                system.debug('ILPLIST:::::'+ILPLIST);
                for(Inventory_Location_Product__c ilp:ILPLIST)
                {
                    if(ilpmap.containsKey(ilp.id))
                    {
                        ilp.Reserved_Quantity__c-=ilpmap.get(ilp.id);
                    }                 
                }
        if(Productserialnumber.size()>0)
        {
          List<Product_Serial_Number__c> serialststusupdate=new List<Product_Serial_Number__c>();
          serialststusupdate=[select id,name,Status__c from Product_Serial_Number__c where id=:Productserialnumber];
          for(Product_Serial_Number__c serialstatus:serialststusupdate)
          {
            serialstatus.Status__c='Available';
          }
          update serialststusupdate;
          system.debug('serialststusupdate>>'+serialststusupdate);
        }
                try 
                {
                    update pInv;
                    update updateILPLI;
                    update ILPLIST;
                    //update updateILPList;
                    //update updateILPLIList;  //Babji
                }
                
                catch(Exception e)
                {
                    System.debug('The following exception has occurred: ' + e.getMessage());
                }                
            
            if(invtr.size()>0)
			{
				for(Product_Order_Price_Book__c inref:invtr)
				{
					inref.Inventory_Status__c='Un Reserved';
					inref.Is_Inventory_Release__c=pickValue;
					inref.Inventory_Release_Comment__c=Comment;
				}
				try {
                upsert invtr;
				}
				catch(Exception e)
				{
					System.debug('The following exception has occurred: ' + e.getMessage());
				}
				//code to handle backorder qty
				try{
                    system.debug('ProQuant>>'+ProQuant);
                    if(ProQuant.size()>0)
                        system.debug('insidebackorder');
                    string flag='SR';
                        BackOrderMailService.notifyBackOrderStockAvailable(ProQuant,flag);
                }
                catch(Exception e){
                    
                }
			}
			
			if(orderlinelist.size()>0)
			{
				for(OrderItem orderlineitem:orderlinelist)
				{
					orderlineitem.Inventory_Status__c='Un Reserved';
					orderlineitem.Is_Inventory_Release__c=pickValue;
					orderlineitem.Inventory_Release_Comment__c=Comment;
				}
				try {
                upsert orderlinelist;
				}
				catch(Exception e)
				{
					System.debug('The following exception has occurred: ' + e.getMessage());
				}
				
				//code to handle backorder qty
				try{
                    system.debug('ProQuant>>'+ProQuant);
                    if(ProQuant.size()>0)
                        system.debug('insidebackorder');
                    string flag='SR';
                        BackOrderMailService.notifyBackOrderStockAvailable(ProQuant,flag);
                }
                catch(Exception e){
                    
                }
			}
            
            
            
       // }
    }
    
    public class wrapperClass
    {  
        @AuraEnabled public Decimal ReserveQuantity{get;set;}
        @AuraEnabled public Product_Order_Price_Book__c orderLne{get;set;}
        @AuraEnabled public Boolean pickvalue{get;set;}
        @AuraEnabled public String comment{get;set;}
		@AuraEnabled public Boolean sigmaorder{get;set;}
		@AuraEnabled public OrderItem orderlineproduct{get;set;}
		
    } 
}