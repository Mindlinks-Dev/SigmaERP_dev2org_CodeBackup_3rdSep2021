public class OrderDetailsCntrl
{
	public class OrderData
    {
        @AuraEnabled
        public String OrderNumber;
        @AuraEnabled
        public Decimal TotalAmount;
        @AuraEnabled
        public Decimal Tax;
        @AuraEnabled
        public Decimal NetAmount;
         
    }
	@AuraEnabled
	public static OrderData FetchOrderData(String OrderId)
	{
		Sigma_Order__c SO = [Select id,Name,Tax_Amount__c,Net_Amount__c,TotalAmount__c from Sigma_Order__c where id=:OrderId];
		
		OrderData OD = new OrderData();
		OD.OrderNumber = SO.Name;
		OD.TotalAmount = SO.Net_Amount__c;
		OD.Tax = SO.Tax_Amount__c;
		OD.NetAmount = SO.TotalAmount__c;
		return OD;
	}
}