({
    pageChange: function(component, event, helper) {
       // alert('pageChange');
        var spinner = component.find("mySpinner");
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        helper.getPackageList(component, event, helper,page);
    },
     doInit : function(component, event, helper,page) {
         var action = component.get("c.fetchPackageDetails");  
         //var action = component.get("c.fetchDefaultParameters"); commented on 02-04-2020
        action.setCallback(this, function (response) {
            var state = response.getState();
            //  alert('fetchDefaultParameters for standard order>>'+state )
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                   //alert(data);
                if(data==false )
                {
                    component.set("v.sigmaOrderFlag",false);            
                }
                else{
                    component.set("v.sigmaOrderFlag",true);
                    //component.set("v.isError1",false);
                }
            }
        });
        $A.enqueueAction(action);
         
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        page = page || 1;        
        var action = component.get("c.fetchPackageList");    
        // alert(page);
        action.setParams({ pageNumber : page });
        action.setCallback(this, function(response) {
            var state = response.getState();
            // alert(state);
            if (state === "SUCCESS") {
//alert(JSON.stringify( component.get("v.sigmaOrderFlag")));
                var spinner = component.find("mySpinner");
        		$A.util.toggleClass(spinner, "slds-hide");
                var accs = response.getReturnValue(); 
              // alert(JSON.stringify(accs));
                  console.log(JSON.stringify(accs));
                component.set('v.total', accs.total);
                component.set('v.page', accs.page);
                component.set('v.pages', Math.ceil(accs.total/accs.pageSize));
                component.set("v.packageList",accs.packageList);
            }
            else if (state === "INCOMPLETE") {
                var spinner = component.find("mySpinner");
        		$A.util.toggleClass(spinner, "slds-hide");
                // do something
            }
                else if (state === "ERROR") {
                    var spinner = component.find("mySpinner");
        			$A.util.toggleClass(spinner, "slds-hide");
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
	selectPackage : function(component, event, helper) {
		 component.set("v.ispackageFlag",true);
         component.set("v.ispackageFlagWithId",false);
         component.set("v.Listflag",false);
	},
    selectShipment : function(component, event, helper) {
         component.set("v.ispackageFlag",false);
         component.set("v.ispackageFlagWithId",true);
         component.set("v.Listflag",false);
	},
     handlePackageId : function(cmp, event) {
         //alert('event.getParam("packageId")'+event.getParam("packageId"));
        var packId = event.getParam("packageId");
        if(packId!=undefined && packId!=null && JSON.stringify(packId)!='""')
        {
             
            cmp.set("v.packageId",packId);
            cmp.set("v.ispackageFlagWithId",true);
            cmp.set("v.ispackageFlag",false);
            cmp.set("v.Listflag",false);
             
         }

    }
})