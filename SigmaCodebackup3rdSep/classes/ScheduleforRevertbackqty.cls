global with sharing class ScheduleforRevertbackqty implements Schedulable
{
    global void execute(SchedulableContext SC) 
    {
        AllocateInventoryCntrl1.DeAllocateInventoryforOrder();
        
      
    }
}