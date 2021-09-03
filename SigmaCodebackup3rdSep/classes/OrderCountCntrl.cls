public with sharing class OrderCountCntrl
{
	public static Boolean SigmaOrderCount(Sigma_Order__c SigmaOrder){
		try
		{
			
            Sigma_Order__c order = [select id,AccountId__c,TotalAmount__c from Sigma_Order__c where id=:SigmaOrder.Id];
            Account Acc = [Select id,Total_Sigma_Order__c,Total_Sigma_Order_Amount__c from Account where id=:order.AccountId__c limit 1 ];
			
			if(SigmaOrder !=null && Acc !=null)
			{
                if(Acc.Total_Sigma_Order__c == null)
                  Acc.Total_Sigma_Order__c = 0;  
				Acc.Total_Sigma_Order__c += 1;
                if(Acc.Total_Sigma_Order_Amount__c == null)
                  Acc.Total_Sigma_Order_Amount__c = 0; 
				Acc.Total_Sigma_Order_Amount__c += SigmaOrder.TotalAmount__c;
				Update Acc;
			}
			return true;
			
		}
		catch(Exception e)
		{
			System.debug('The following exception has occurred: ' + e.getMessage());
			return false;
		}
	
	}
    
    public static Boolean SOReduce(Sigma_Order__c SigmaOrder){
		try
		{
			Account Acc = [Select id,Total_Sigma_Order__c,Total_Sigma_Order_Amount__c from Account where id=:SigmaOrder.AccountId__c limit 1 ];
			
			if(SigmaOrder !=null && Acc !=null)
			{
				Acc.Total_Sigma_Order__c -= 1;
				Acc.Total_Sigma_Order_Amount__c -= SigmaOrder.TotalAmount__c;
				Update Acc;
			}
			return true;
			
		}
		catch(Exception e)
		{
			System.debug('The following exception has occurred: ' + e.getMessage());
			return false;
		}
    }
    
	
}