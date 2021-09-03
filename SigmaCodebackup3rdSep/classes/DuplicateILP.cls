public with sharing class DuplicateILP
{
  public void CheckILP(List<Inventory_Location_Product__c> ILPData)
  {
	set<Id>ILIds = new set<Id>();
	set<Id>ProIds = new set<Id>();
	for(Inventory_Location_Product__c ILP:ILPData)
	{
		ILIds.add(ILP.Inventory_Location__c);
		ProIds.add(ILP.Products__c);
	}
	
	if(ILIds.size()>0 && ProIds.size()>0 )
	{
		List<Inventory_Location_Product__c>ILPRecord = [Select Id,Inventory_Location__c,Products__c from Inventory_Location_Product__c where Inventory_Location__c=:ILIds and Products__c =:ProIds];
		if(ILPRecord.size()>0)
		{
			ILPData[0].addError('Inventory Location already exist');
		}
	}
	
	
  }

}