public with sharing class TransactionHistory{

 public static void creditHistoryWO(Dimension_Tag__c DT,Decimal TotalAmount,String Woname){
             system.debug('DT::::'+DT);
           list<Dimension_Tag__c> dimTag=new list<Dimension_Tag__c>();
            dimTag.add(DT);
            
            List<sigmaerpdev2__Credit_History__c> Ch = new List<sigmaerpdev2__Credit_History__c>();
            
                for(Dimension_Tag__c d : dimTag){
                    
                    sigmaerpdev2__Credit_History__c credit = new sigmaerpdev2__Credit_History__c();
                    //credit.Remaining_Credit_Limit__c = d.Remaining_Credit_Limit__c;
                    credit.Amount__c=TotalAmount;
                    credit.Total_Ordered_Amount__c=d.Ordered_Amount__c;
                    credit.Reason__c = 'Work Order';
                    credit.Account__c=d.Account__c;
                    credit.Order_ID__c=Woname;
                    Ch.add(credit);
                } 
                 insert Ch;
                 
                
 }
 
 public static void creditHistorySO(Dimension_Tag__c DT,Decimal TotalPrice,String Sigmaorder){
             system.debug('DT::::'+DT);
           list<Dimension_Tag__c> dimTag=new list<Dimension_Tag__c>();
            dimTag.add(DT);
            
            List<sigmaerpdev2__Credit_History__c> Ch = new List<sigmaerpdev2__Credit_History__c>();
            
                for(Dimension_Tag__c d : dimTag){
                    
                    sigmaerpdev2__Credit_History__c credit = new sigmaerpdev2__Credit_History__c();
                    credit.Remaining_Credit_Limit__c = d.Remaining_Credit_Limit__c;
                    credit.Amount__c=TotalPrice;
                    credit.Total_Ordered_Amount__c=d.Ordered_Amount__c;
                    credit.Reason__c = 'Sigma Order';
                    credit.Account__c=d.Account__c;
                    credit.Order_ID__c=Sigmaorder;
                    Ch.add(credit);
                } 
                 insert Ch;
                 
                
 }
}