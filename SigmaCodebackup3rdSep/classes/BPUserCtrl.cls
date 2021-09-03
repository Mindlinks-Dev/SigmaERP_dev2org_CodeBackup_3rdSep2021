public with sharing class BPUserCtrl {
    public class AccountWrap{
        @auraEnabled
        public String AccountIds;
		@auraEnabled
        public String AccountName;
		@auraEnabled
        public Decimal Duration;
		@auraEnabled
        public String PaymentInterval;
		@auraEnabled
        public Decimal commisionFees;
        
    }
    
   
 	@AuraEnabled
    public static void saveBPUsers(String act){
         AccountWrap actwrap= (AccountWrap)System.JSON.deserialize(act,AccountWrap.class);
		 system.debug('actwrap>>'+actwrap);
		 Account acc= new Account();
		 acc.id = actwrap.AccountIds;
		 acc.sigmaerpdev2__Payment_interval__c = actwrap.Duration;
		 acc.sigmaerpdev2__Interval__c = actwrap.PaymentInterval;
		 acc.sigmaerpdev2__Commision_Fees__c = actwrap.commisionFees;
		 
        update acc;
    }
   
}