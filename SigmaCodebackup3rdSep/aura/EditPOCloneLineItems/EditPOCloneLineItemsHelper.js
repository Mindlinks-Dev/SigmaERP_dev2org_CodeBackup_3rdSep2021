({
	doInit : function(component, event, helper) {
        var pop=component.get('v.popid');
        
        var action = component.get("c.getLine");
        action.setParams({
            popid:pop
        });
        
        action.setCallback(this, function(result) {
           // alert('olage bande');
            var state = result.getState();
           // alert(state);
            //alert('for order line<<<'+result.getReturnValue());
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
               // alert(JSON.stringify(resultData));
                //component.set("v.lineItem",resultData);
                component.set('v.productname',resultData.sigmaerpdev2__Product__r.Name);
               // alert(component.get('v.productname'));
                component.set('v.popDetails',resultData);
                
            }
        });
        $A.enqueueAction(action);
	},
    fetchPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.find(elementId).set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    }
})