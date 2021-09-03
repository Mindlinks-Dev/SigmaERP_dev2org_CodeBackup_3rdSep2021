({
    goBack : function(component, event) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/lightning/n/sigmaerpdev2__Stock_Management_Modules"
        });        
        urlEvent.fire(); 
        // $A.get("e.force:closeQuickAction").fire(); 
    },
     getMessage : function(component, event) {
        // alert('dczxv');
        //get method paramaters
        var params = event.getParam('arguments');
        if (params) {
            var param1 = params.childGreetingParam;
            var param2 = params.childPersonNameParam;
            alert(param1 + " " + param2);
            
        }
         window.location.reload(true);
    },
	getProdDetails : function(component, event, helper) {	       
        if(!component.get("v.locID")){
            component.set("v.productID","");
            component.set("v.showFlag",false);
        }        
	},
    getshowFlag : function(component, event, helper){
        if(!component.get("v.productID")){
            component.set("v.showFlag",false);
        }        
    },
    Search : function(component, event, helper) {	

        
        if(!component.get("v.locID")){
            component.set("v.errorMessage","Please select a Location");
            component.set("v.isError",true);
            return;
        }
        else if(!component.get("v.productID")){
            component.set("v.errorMessage","Please Select a Product");
            component.set("v.isError",true);
            return;

        }
        component.set("v.showFlag",true);
        component.set("v.isError",false);
        helper.getBinDetailsHelper(component, event, helper);
	}, 
})