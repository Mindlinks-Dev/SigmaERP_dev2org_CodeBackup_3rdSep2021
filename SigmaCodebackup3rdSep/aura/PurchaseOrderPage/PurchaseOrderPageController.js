({
    doInit : function(component, event, helper,page) {
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        page = page || 1;        
        var action = component.get("c.fetchpurchaseorderList");                
        action.setParams({ pageNumber : page });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var spinner = component.find("mySpinner");
                $A.util.toggleClass(spinner, "slds-hide");
                var accs = response.getReturnValue(); 
                component.set('v.total', accs.totalSigma);
                component.set('v.page', accs.pageSigma);
                component.set('v.pages', Math.ceil(accs.totalSigma/accs.pageSizeSigma));
                component.set("v.purchaselist",accs.purchaselist);
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
    
    newpurchaseorder : function(component, event, helper){
        //  alert(component.get("v.purchaseFlag"));
        component.set("v.NewpurchaseFlag",true); 
        component.set("v.Listflag",false);
        component.set("v.ImportFlag",false);
        

    },
    
    pageChange: function(component, event, helper) {
        var spinner = component.find("mySpinner");
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        helper.getpurchaseorderlist(component, event, helper,page);
    },
  handlepurchaseId : function(cmp, event) {
      // alert('called by parent>>'+event.getParam("purchaseId"));
        var purchId = event.getParam("purchaseId");
    //alert('purchId-->>'+purchId);
        if(purchId!=undefined && purchId!=null && JSON.stringify(purchId)!='""')
        {
           
            cmp.set("v.purchaseId",purchId);
             cmp.set("v.NewpurchaseFlag",false);
            cmp.set("v.ispurchaseFlagWithId",true); 
        cmp.set("v.Listflag",false);

       
         }

    }
 

})