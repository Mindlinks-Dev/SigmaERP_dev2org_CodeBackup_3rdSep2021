trigger HandleShipmentAdderess on Shipment_Detail__c (before insert,after insert,after update) {
    
        Boolean isdefualtExist=false;
        Set<Id>Accid = new Set<Id>();
        HandleVendorProduct vhandler = new HandleVendorProduct();
        system.debug('inside trigger>>>'+Trigger.New);
        List<Shipment_Detail__c> shipdetails = Trigger.New;
        List<Shipment_Detail__c> allshipdetails = new List<Shipment_Detail__c> ();
        for(Shipment_Detail__c SD :shipdetails)
        {
            Accid.add(SD.Account__c);
            if(SD.Default_Address__c)
            {
                isdefualtExist=true;
            }
        }
        
        if(trigger.isBefore)
        {
            if(Trigger.isInsert)
            {
                if(Accid.size()>0)
                {
                    allshipdetails = [Select id,Account__c,Default_Address__c from Shipment_Detail__c where Account__c=:Accid and Default_Address__c =true];
                }
                if(allshipdetails.size()==0)
                {
                    for(Shipment_Detail__c SD : shipdetails)
                    {
                    
                    if(SD.Default_Address__c==false)
                    {             
                        
                        shipdetails[0].addError('Please Check default address checkbox');
                    }
                    else
                        system.debug('Do Nothing...');
                    }

                }
                if(isdefualtExist)
                {
                    for(Shipment_Detail__c ShipDeta : allshipdetails)
                    {
                        if(ShipDeta.Default_Address__c)
                        {
                            shipdetails[0].Default_Address__c.adderror('Please Uncheck already Existing Default shipment address');
                        }
                        else{
                            system.debug('Do Nothing...');
                        }
                    }
                    
                }
            }            
        }
        /*if(trigger.isAfter)
        {
            system.debug('after update1>>>'+Trigger.New);
            if(Trigger.isUpdate)
            {       
        vhandler.onAfterUpdate(Trigger.New);
      } 
        }*/
        
}