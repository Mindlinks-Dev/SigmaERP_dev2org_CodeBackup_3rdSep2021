({
	productTitle : function(component, event, helper) {		
        var sldsSection2 = component.find('sldsSection');
        $A.util.toggleClass(sldsSection2, 'slds-is-open');
	},
        autoPickInventory: function (component, event, helper) {
              var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
        SigmaComponentEvent.setParams({
            "data" : {"index":component.get('v.indexNum')},
            "flag" : "autoPickILPLI"
        });
        SigmaComponentEvent.fire();
},
     selectMalually: function (component, event, helper) {
          var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
        SigmaComponentEvent.setParams({
            "data" : {"index":component.get('v.indexNum')},//"AttributeType":component.get("v.productPrices")[0].stapp__Attribute_Type__c},
            "flag" : "manualSelectILPLI"
        });
        SigmaComponentEvent.fire();
       
     
     }
})