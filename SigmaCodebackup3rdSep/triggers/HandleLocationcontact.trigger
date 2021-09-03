/*code added by Rashmi
Date: 28-06-2021 
reason: To handle prefered contact for location
---------------------------------------------------------------------- */
trigger HandleLocationcontact on Contact(before insert,after update) {
    
    HandleLocationcontact conhandler = new HandleLocationcontact();
        system.debug('inside trigger>>>'+Trigger.New);
        if(trigger.isBefore)
        {
            if(Trigger.isInsert)
            {
                system.debug('inside trigger #10>>>'+Trigger.New);
                conhandler.onBeforeInsert(Trigger.New);
            }            
        }
        if(trigger.isAfter)
        {
            system.debug('after update1>>>'+Trigger.New);
            if(Trigger.isUpdate)
            {       
                conhandler.onAfterUpdate(Trigger.New);
              } 
        }
        
}