({
	openModalHelper : function(component, event, helper,data) {
        var srlLength = component.get("v.pro.sigmaerpdev2__Net_Quantity__c");        
        var serialList = [];
        for(var i=0;i < srlLength; i++){
            serialList[i] = {'SerialNo':''};
        }        
        component.set('v.serials',serialList);
        component.set('v.showModal',true);
    }
})