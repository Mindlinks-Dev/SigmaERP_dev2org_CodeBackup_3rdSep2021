({
	expandOrHide : function(component, event, helper) {
		var rowId = component.get("v.zoneRowId");        
        var selLineItem = document.getElementById('showdropdown_'+rowId);		           
        var imgId = document.getElementById('changeImage_'+rowId);         
        if(selLineItem.style.display == 'none') {  
            imgId.src= "/resource/sigmaerpdev__NMinus";            
            imgId.title="Hide Bins";   
            selLineItem.style.display = 'block';            
        }else{             
            imgId.src= "/resource/sigmaerpdev__NPlus";            
            imgId.title="Show Bins";   
            selLineItem.style.display = 'none';
        }
	}
})