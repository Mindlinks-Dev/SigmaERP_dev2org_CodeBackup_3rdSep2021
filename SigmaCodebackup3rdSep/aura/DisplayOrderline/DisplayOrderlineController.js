({
    
     doInit : function(component, event, helper) {
        // alert('value>>'+JSON.stringify(component.get('v.innerList2')));
     },
	
    navigateToRecord : function(component, event, helper) {
        var fromMob = component.get("v.fromMobile1");
        var soid = event.target.getAttribute('data-recid');
        if(fromMob){
            var navEvent = $A.get("e.force:navigateToSObject");
            navEvent.setParams({
                  recordId: soid,
                  slideDevName: "detail"
            });
            navEvent.fire(); 
        }else{
        	window.open("/lightning/r/stapp__Stapp_Order__c/"+soid+"/view");     
        }
    },   
    
    expandOrHide : function(component, event, helper) {
		var rowId = component.get("v.rowId1");		  
        var selLineItem = document.getElementById('showHide_'+rowId);		           
        var imgId = document.getElementById('changeImage_'+rowId);         
        if(selLineItem.style.display == 'none') {  
            imgId.src= "/resource/sigmaerpdev__NMinus";            
            imgId.title="Hide details";   
            selLineItem.style.display = 'block';            
        }else{             
            imgId.src= "/resource/sigmaerpdev__NPlus";            
            imgId.title="Show details";   
            selLineItem.style.display = 'none';
        }
	},
})