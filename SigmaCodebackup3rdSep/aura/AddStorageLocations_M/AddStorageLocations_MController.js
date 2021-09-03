({
    SelectedID : function(component, event, helper) {        
        var objectId = event.getParam("sObjectId");
        var context = event.getParam("instanceId");
        if(context=='MyInventoryCNK')
            component.set("v.dataobj.invLocRecID",objectId);            
        else if(context=='MyBins')
            component.set("v.dataobj.BinId",objectId);
    },
    getdefaultlocation : function(component, event, helper)
    {        
        var action = component.get("c.fetchDefaultLocation");
        action.setCallback(this, function (response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                	var value = response.getReturnValue();                 
				 	component.set("v.dataobj.locId",value.Id);	
				 	component.set("v.dataobj.locName",value.Name);                    
                }      
            });
         $A.enqueueAction(action);  
    },
    ClearID : function(component, event, helper) {
        var context = event.getParam("instanceId");
        if(context=="MyInventoryCNK")
            component.set("v.dataobj.invLocRecID",'');
        if(context=="MyBins")
            component.set("v.dataobj.BinId",'');
    },
    
    handleRemove : function(component, event, helper)
    {
        //alert('inside handleRemove');
    },
    
    showLocName : function(component, event, helper){
        var locationId = component.get("v.dataobj.invLocRecID");         
        if(locationId != ''){
        	var action = component.get("c.getLocationName");
            action.setParams({
                "locId" : locationId
            });
            action.setCallback(this, function (response){            
                 var state = response.getState();
                 if(state == "SUCCESS"){ 
                    component.set("v.selLocationName", response.getReturnValue());                
                 }else{
                    component.set("v.selLocationName", '');
                 }
            });
            $A.enqueueAction(action);    
        }else{            
            component.set("v.selLocationName", '');
        }        
    },
    
    clearSelValues : function(component, event, helper){        
        var locId = component.get("v.dataobj.locId");
        if(locId == '' || locId == undefined){            
            component.set("v.dataobj.invLocRecID", "");
            component.set("v.dataobj.ZoneId", "");
            component.set("v.dataobj.BinId", "");
        }
    }
})