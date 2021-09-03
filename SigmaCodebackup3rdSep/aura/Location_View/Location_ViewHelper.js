({
	getLocationDetails : function(component, event, helper) {
        var origArray = [];
        if(component.get("v.recordId") == '' || component.get("v.recordId") == undefined){
            component.set("v.currentCount", 0);
            component.set("v.initialRows", 8);
        }
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
		var action = component.get("c.fetchLocations");        
        action.setParams({
            "LocId" : component.get("v.recordId"),
            "limits": component.get("v.initialRows"),
            "offsets": component.get("v.currentCount")
        });
        action.setCallback(this, function(response){
			var state = response.getState();            
            if(state == "SUCCESS"){
                var spinner = component.find("mySpinner");
        		$A.util.toggleClass(spinner, "slds-hide");
                component.set("v.expanded", true);                
                if(response.getReturnValue() != null){
                	component.set("v.finalList", response.getReturnValue());                                         
                    origArray = component.get("v.finalList");
                    component.set("v.rowLength", response.getReturnValue().locList.length);
                    component.set("v.totalCount" , response.getReturnValue().locList.length);                    
                	
                    var counter = 0;
                    for(var i=0;i<origArray.length;i++){                    
                        for(var k=0;k<origArray[i].locList.length;k++){
                            counter++;
                        }
                    }
                    
                    if(response.getReturnValue().totalRows != null){
                        component.set("v.totalNumberOfRows", response.getReturnValue().totalRows);    
                    }   
                                        
                    /*if(component.get('v.finalList').length >= component.get('v.totalNumberOfRows')) {
                        component.set('v.loadMoreStatus', '');
                    }*/
                    
                    if(counter >= component.get('v.totalNumberOfRows')) {
                        component.set('v.loadMoreStatus', '');
                    }else{
                        component.set('v.loadMoreStatus', 'Load More'); 
                    }
                    
                    var countstemps = component.get("v.currentCount");
                    countstemps = countstemps + component.get("v.initialRows");
                    component.set("v.currentCount", countstemps);   
                }else{
                    component.set("v.rowLength", 0);
                }
            }else if (state === "ERROR") {
                var spinner = component.find("mySpinner");
        		$A.util.toggleClass(spinner, "slds-hide");
                component.set("v.expanded", false);
                var errors = response.getError();
                alert('Error occured while fetching Locations : '+JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
	},
    
    fetchData : function(component, event, helper){        
        var origArray = [];
        var newArray = [];
        var myFinalArray = [];
        
        var action = component.get("c.fetchLocations");        
        action.setParams({
            "LocId" : component.get("v.recordId"),
            "limits": component.get("v.initialRows"),
            "offsets": component.get("v.currentCount")
        });
        action.setCallback(this, function(response){
			var state = response.getState();             
            if(state == "SUCCESS"){
                origArray = component.get("v.finalList");
                console.log('resp=='+JSON.stringify(response.getReturnValue()));
            	newArray.push(response.getReturnValue());                
                
                var orgId = [];
                var newId = [];
                
                for(var j=0;j<newArray.length;j++) {                                        
                    for(var k=0;k<newArray[j].locList.length;k++){                                                                                  
                        newId.push(newArray[j].locList[k].locId);                                                        
                    }
                }
                
                for(var i=0;i<origArray.length;i++){                    
                	for(var k=0;k<origArray[i].locList.length;k++){
                    	orgId.push(origArray[i].locList[k].locId); 
                    }
                }
                
                for(var j=0;j<newArray.length;j++) {                                                            
                    for(var k=0;k<newArray[j].locList.length;k++){
                        for(var i=0;i<orgId.length;i++){
                        	if(newArray[j].locList[k].locId == orgId[i]){                                
                                newArray[j].locList[k] = {};                       
                            }else{
                                continue;                       
                            }       
                        }                    
                    }
                }
                
                for(var i=0;i<newArray.length;i++){
                    var innnArr = [];             
                    for(var k=0;k<newArray[i].locList.length;k++){                 
                        if(JSON.stringify(newArray[i].locList[k]) != '{}'){
                            innnArr.push(newArray[i].locList[k]);
                        }
                    }
                    myFinalArray.push({'locList':innnArr});
                }
                
                origArray = origArray.concat(myFinalArray);
                console.log('org arr=='+JSON.stringify(origArray));
                component.set("v.finalList", origArray);
                
                var counter = 0;
                for(var i=0;i<origArray.length;i++){                    
                    for(var k=0;k<origArray[i].locList.length;k++){
                        counter++;
                    }
                }
                
                if(response.getReturnValue().totalRows != null){
                    component.set("v.totalNumberOfRows", response.getReturnValue().totalRows);    
                }  
                
                if(counter >= component.get('v.totalNumberOfRows')) {
                    component.set('v.loadMoreStatus', '');
                }
                else{
                    component.set('v.loadMoreStatus', 'Load More'); 
                }
                var countstemps = component.get("v.currentCount");
                countstemps = countstemps + component.get("v.initialRows");
                component.set("v.currentCount", countstemps); 
                
            }else if (state === "ERROR") {
                component.set("v.expanded", false);
                var errors = response.getError();
                alert('Error occured while fetching Locations : '+JSON.stringify(errors));
            }
        });
        $A.enqueueAction(action);
    }       
})