trigger DuplicateTax  on Tax__c (before insert,before Update) {

     CheckDuplicateTaxHandler cdTax=new CheckDuplicateTaxHandler();
  
  if((Trigger.isInsert && Trigger.isBefore)){
      cdTax.CheckDuplicateinsert(Trigger.New);
  } 
  
  if(Trigger.isUpdate && Trigger.isBefore){
     cdTax.checkDuplicatesupdate(Trigger.New);
  }  
}