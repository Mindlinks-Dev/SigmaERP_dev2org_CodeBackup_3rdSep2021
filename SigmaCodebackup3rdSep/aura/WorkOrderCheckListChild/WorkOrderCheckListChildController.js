({
	doChildInit : function(component, event, helper) {
        //debugger;
		var detailsMap = new Map(component.get('v.radioButtonDetails'));
        var key = component.get('v.key');
        
        var mapValue = detailsMap.get(key);
        component.set('v.listRadioButtons',mapValue);
        
	},
    
    handleRadioButtonValue : function(component, event, helper) {
        
        var objectRecordName = event.getSource().get('v.name');
        var value = event.getSource().get('v.label');
        console.log(objectRecordName + '  '+value);
        
        var finalValues = new Object();
        if(component.get('v.finalValues')!=null){
            finalValues = component.get('v.finalValues');
                finalValues[objectRecordName]=value;
        }
        else{
            finalValues[objectRecordName]=value;
        }
        component.set('v.finalValues',finalValues);
        console.log(Object.entries(finalValues));
    },
})