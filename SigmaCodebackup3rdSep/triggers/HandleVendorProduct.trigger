trigger HandleVendorProduct on Vendor_Product__c (before insert,after update) {
    
   
        HandleVendorProduct vhandler = new HandleVendorProduct();
        system.debug('inside trigger>>>'+Trigger.New);
        if(trigger.isBefore)
        {
            if(Trigger.isInsert)
            {
                system.debug('inside trigger #10>>>'+Trigger.New);
                vhandler.onBeforeInsert(Trigger.New);
            }            
        }
        if(trigger.isAfter)
        {
            system.debug('after update1>>>'+Trigger.New);
            if(Trigger.isUpdate)
            {       
				vhandler.onAfterUpdate(Trigger.New);
			} 
        }
        
}