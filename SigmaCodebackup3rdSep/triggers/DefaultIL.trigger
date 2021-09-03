trigger DefaultIL on Account (after insert) {

     RecordType accRecordType = [SELECT Id
                                         FROM RecordType
                                         WHERE SobjectType = 'Account' AND Name = 'Location'
                                         LIMIT 1];

     set<Id> acIDs = new set<Id>();
     for(Account acc : trigger.new){
          if(acc.RecordTypeId == accRecordType.Id){
               acIDs.add(acc.Id);
          }
     }
     list<Account> accnt = [Select Id, Name,Locations_Type__c From Account Where Id IN : acIDs];
    for(Account a:accnt){
    
    Inventory_Location__c il=new Inventory_Location__c(LocationName__c=a.name,Location__c=a.Id);
    insert il;
    
    if(a.Locations_Type__c=='Truck'){
     Id RIDloc = Schema.SObjectType.Sublevel_location__c.getRecordTypeInfosByName().get('Zone').getRecordTypeId();
     Id RIDloc1 = Schema.SObjectType.Sublevel_location__c.getRecordTypeInfosByName().get('Bin').getRecordTypeId();
      Sublevel_location__c sb=new Sublevel_location__c(Name=il.LocationName__c+'Default Zone',Inventory_Location__c=il.Id,RecordtypeId = RIDloc);
      insert sb;
      Sublevel_location__c sb1=new Sublevel_location__c(Name=il.LocationName__c+'-default Bin',zone__c=sb.Id,Inventory_Location__c=il.Id,RecordtypeId = RIDloc1); 
      insert sb1;
    }
    }

}