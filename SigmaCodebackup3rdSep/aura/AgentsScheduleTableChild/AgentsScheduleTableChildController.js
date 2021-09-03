({
	getEachTechDetails : function(component, event, helper) {
        debugger;
        
        var map1 = component.get('v.techScheduleDetails');
        var mapKey = component.get('v.key');
        var imageNameArray = mapKey.split(" ");
        var imageName = imageNameArray[0];
        component.set('v.imageName',imageName);
        
		var eachTechDetail = map1[mapKey];
        component.set('v.keyValue',eachTechDetail);
        //alert(JSON.stringify(eachTechDetail));
	}
})