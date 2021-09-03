//code to revert back TBI inventory
//Author -  Harish 13-05-2021
global class SalesOrderTBIScheduler implements Schedulable {

    global void execute(SchedulableContext sc)
    {
        try
        {
			Map<Id,Map<Id,decimal>> ProLocQty = new Map<Id,Map<Id,decimal>>();
			
			for(OrderLineLocation__c OLL : [Select id,name,Product__c,Inventory_Location_Product__c,Quantity__c,Order_Line__c from OrderLineLocation__c where End_Date__c = TODAY])
			{
				if(ProLocQty.containskey(OLL.Product__c))
				{
					if(ProLocQty.get(OLL.Product__c).containskey(OLL.Inventory_Location_Product__c))
					{
						Decimal Qty = ProLocQty.get(OLL.Product__c).get(OLL.Inventory_Location_Product__c);
						ProLocQty.get(OLL.Product__c).put(OLL.Inventory_Location_Product__c,OLL.Quantity__c+Qty);
					}
					else
					{
						ProLocQty.get(OLL.Product__c).put(OLL.Inventory_Location_Product__c,OLL.Quantity__c);
					}
					
				}
				else
				{
					Map<Id,Decimal>LocQty = new Map<Id,Decimal>{OLL.Inventory_Location_Product__c => OLL.Quantity__c};
					ProLocQty.put(OLL.Product__c,LocQty);
				}
				System.debug('ProLocQtyMap@@@'+ProLocQty);
				
				
			}
			
			List<Inventory_Location_Product__c>ILPList = [Select Id,Name,Products__c,Reserved_Quantity__c,Delivered_Quantity__c from Inventory_Location_Product__c where Products__c=:ProLocQty.keyset()];
			for(Inventory_Location_Product__c ILP:ILPList)
			{
				if(ProLocQty.containskey(ILP.Products__c)&&ProLocQty.get(ILP.Products__c).containskey(ILP.Id))
				{
					ILP.Delivered_Quantity__c -=ProLocQty.get(ILP.Products__c).get(ILP.Id);
					
				}
				
			}
			if(ILPList.size()>0)
			Update ILPList;
		}
		catch(Exception e) {
        System.debug('An exception occurred: at line number '+e.getLineNumber()+' Message ' + e.getMessage());
        }
	}
}