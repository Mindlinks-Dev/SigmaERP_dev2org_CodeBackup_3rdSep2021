trigger ChangeCurrentAvailInvent on Inventory_Location_Product__c (after insert,after update) 
{
    List<Inventory_Location_Product__c> NewILP = Trigger.New;
    List<Inventory_Location_Product__c> OldIlp = Trigger.Old;
    system.debug('inside ChangeCurrentAvailInvent trigger');
    TriggerHandler triggerHandler1 = new TriggerHandler();
    system.debug('calling ManageCurrenAvail-->>>');
    triggerHandler1.ManageCurrenAvail(NewILP,OldIlp ,Trigger.isInsert,Trigger.isUpdate); 
    if(trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
            try
            {
                Set<Id> ObjectIdlist = new Set<Id>();
                Set<Id> proIdlist = new Set<Id>();
                for(Inventory_Location_Product__c  i:trigger.new)
                {
                    if(i.Stock_Origin__c == 'Direct Add' && i.Unit_Price__c != null)
                    {
                        ObjectIdlist.add(i.Id);
                    }
                }
                system.debug('ObjectIdlist>>>>'+ObjectIdlist);
                if(ObjectIdlist.size() > 0)
                {    
                    if(!Test.isRunningTest()){
                        LinkageServiceClass.createSLFromILP(ObjectIdlist,null);
                       // LinkageServiceClass.createSLFromILPforSerial(ObjectIdlist,null);
                     }
                }
                
            } 
            catch(Exception e)
            {
                System.debug('Exception in LinkerILP :'+e);
                System.debug('Exception in LinkerILP line:'+e.getLineNumber());
            }
        }
    }
  /*  if(Trigger.isUpdate && trigger.isAfter)
    {
        try
        {
            Set<Id> ObjectIdlist = new Set<Id>();
            
            for(Inventory_Location_Product__c  i:trigger.new)
            {
                if(i.Stock_Origin__c == 'Direct Add' && i.Unit_Price__c != null)
                {
                    ObjectIdlist.add(i.Id);
                }
            }
            system.debug('ObjectIdlist>>>>'+ObjectIdlist);
            if(ObjectIdlist.size() > 0)
            {    
                if(!Test.isRunningTest()){
                    LinkageServiceClass.createSLFromILP(ObjectIdlist,null,null);
                }
            }
            
        } 
        catch(Exception e)
        {
            System.debug('Exception in LinkerILP :'+e);
            System.debug('Exception in LinkerILP line:'+e.getLineNumber());
        }
    }*/
   
}