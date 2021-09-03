({
    binClearEvent: function (component, event, helper) {
        var ilpli=component.get('v.IlpliItem');
        var binId= component.get('v.binId');
         if(binId)
        component.set("v.IlpliItem.sigmaerpdev2__Bin__c",binId);
        else component.set("v.IlpliItem.sigmaerpdev2__Bin__c","");
       
    },
	    SelectedID:function(component,event,helper){
        var  context = event.getParam("instanceId");
        var  objectId = event.getParam("sObjectId");
        var  sInPro=component.get("v.stockInProdObj");
        if(context=='Lot')
        {
            component.set("v.IlpliItem.sigmaerpdev2__Lot__c",objectId);       
        } 
    },
    validatepsn:function(component,event,helper){
        var psnlist=component.get("v.PSerialNumber");
        var psn=component.get("v.IlpliItem.sigmaerpdev2__ILid__c");
        psnlist.push(psn);   
     }
})