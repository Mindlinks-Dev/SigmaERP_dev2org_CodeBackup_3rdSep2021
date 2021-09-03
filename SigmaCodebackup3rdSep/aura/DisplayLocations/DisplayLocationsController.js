({
	expandOrHide : function(component, event, helper) {
		var rowId = component.get("v.locationId");	        
        var selLineItem = document.getElementById('showdropdown_'+rowId);		           
        var imgId = document.getElementById('changeImage_'+rowId);         
        if(selLineItem.style.display == 'none') {  
            imgId.src= "/resource/sigmaerpdev__NMinus";            
            imgId.title="Hide Zones";   
            selLineItem.style.display = 'block';            
        }else{             
            imgId.src= "/resource/sigmaerpdev__NPlus";            
            imgId.title="Show Zones";   
            selLineItem.style.display = 'none';
        }
	},
    
    goToLoc : function(component, event, helper){
        var recId = component.get("v.locationId");        
        var sObectEvent = $A.get("e.force:navigateToSObject");
        sObectEvent .setParams({
            "recordId": recId
        });
        sObectEvent.fire(); 
    }
})