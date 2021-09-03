({
    doInit : function(comp, event, helper,page) {   
        /*var spinner = comp.find("mySpinner");        
        $A.util.toggleClass(spinner, "slds-hide");*/
        
        page = page || 1;        
        var action = comp.get("c.fetchStappOrderList");
        action.setParams({ pageNumber : page });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                /*var spinner = comp.find("mySpinner");        
        		$A.util.toggleClass(spinner, "slds-hide");*/
                var accs = response.getReturnValue(); 
                comp.set('v.total', accs.total);
                comp.set('v.page', accs.page);
                comp.set('v.pages', Math.ceil(accs.total/accs.pageSize));
                comp.set("v.soList",accs.soList);
                comp.set("v.IsCommunityUser",accs.IsCommunityUser);
            }
            else if (state === "INCOMPLETE") {
                // do something
                /*var spinner = comp.find("mySpinner");        
        		$A.util.toggleClass(spinner, "slds-hide");*/
            }
                else if (state === "ERROR") {
                    /*var spinner = comp.find("mySpinner");        
        			$A.util.toggleClass(spinner, "slds-hide");*/
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
    
    createNewRecord  : function(component, event, helper) {
        //alert('create');
        var childname = event.getSource().get("v.name"); 
        
        if(childname=="Product Inventory"){
            var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({
                "entityApiName": "sigmaerpdev2__Inventory__c"
            });
            createRecordEvent.fire();
        }
        
    },
    
    createLocation  : function(component, event, helper) {
        //alert('create');
        /*  var childname = event.getSource().get("v.name"); 
         
       if(childname=="Inventory Location"){
           var createRecordEvent = $A.get("e.force:createRecord");
           createRecordEvent.setParams({
               "entityApiName": "sigmaerpdev2__Inventory_Location__c"
           });
           createRecordEvent.fire();
       }*/
        
        var InvLocFlag = component.find("invFlag");    
        $A.util.removeClass(InvLocFlag, 'slds-hide');
        var ListView = component.find("ListFlag");    
        $A.util.addClass(ListView, 'slds-hide');
        var InvMain = component.find("InvMain");    
        $A.util.addClass(InvMain, 'slds-hide');
        var InvRelease = component.find("InvRelease");    
        $A.util.addClass(InvRelease, 'slds-hide');
        var bulk = component.find("bulk");    
        $A.util.addClass(bulk, 'slds-hide');
    },
    
    callComponent : function(component, event, helper){
        /*var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:InventoryReleaseCntrl",
                        
                    });
                    evt.fire(); 
                    */
        var InvLocFlag = component.find("invFlag");    
        $A.util.addClass(InvLocFlag, 'slds-hide');
        var ListView = component.find("ListFlag");    
        $A.util.addClass(ListView, 'slds-hide');
        var InvRelease = component.find("InvRelease");    
        $A.util.removeClass(InvRelease, 'slds-hide');
        var InvMain = component.find("InvMain");    
        $A.util.addClass(InvMain, 'slds-hide');
        var bulk = component.find("bulk");    
        $A.util.addClass(bulk, 'slds-hide');
        var serial = component.find("serial");    
        $A.util.addClass(serial, 'slds-hide');
    },
    
    pageChange: function(component, event, helper) {
        var spinner = component.find("mySpinner");
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        helper.getPackagesList(component, event, helper,page);
    },
    
    
    BulkInventories : function(component, event, helper)
    {
       /* 
         var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url":"https://sigmaerpdev-dev-ed--sigmaerpdev.ap4.visual.force.com/apex/ImportBulkProductForInventory"
        });
        urlEvent.fire(); 
       */
        var InvLocFlag = component.find("invFlag");    
        $A.util.addClass(InvLocFlag, 'slds-hide');
        var ListView = component.find("ListFlag");    
        $A.util.addClass(ListView, 'slds-hide');
        var InvRelease = component.find("InvRelease");    
        $A.util.addClass(InvRelease, 'slds-hide');
        var InvMain = component.find("InvMain");    
        $A.util.addClass(InvMain, 'slds-hide');
        var bulk = component.find("bulk");    
        $A.util.removeClass(bulk, 'slds-hide');
        var serial = component.find("serial");    
        $A.util.addClass(serial, 'slds-hide');
        
    },
    serializedInventories : function(component, event, helper)
    {
       /*var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url":"https://sigmaerpdev-dev-ed--sigmaerpdev.ap4.visual.force.com/apex/ImportSerialProductForInventory"
        });
        urlEvent.fire(); 
        */
         var InvLocFlag = component.find("invFlag");    
        $A.util.addClass(InvLocFlag, 'slds-hide');
        var ListView = component.find("ListFlag");    
        $A.util.addClass(ListView, 'slds-hide');
        var InvRelease = component.find("InvRelease");    
        $A.util.addClass(InvRelease, 'slds-hide');
        var InvMain = component.find("InvMain");    
        $A.util.addClass(InvMain, 'slds-hide');
        var bulk = component.find("bulk");    
        $A.util.addClass(bulk, 'slds-hide');
        var serial = component.find("serial");    
        $A.util.removeClass(serial, 'slds-hide');
    },
    
    callInventoryMaintain : function(component, event, helper){
        /*                 
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:Inventroymaintain",
                        
                    });
                    evt.fire();    */
        var InvLocFlag = component.find("invFlag");    
        $A.util.addClass(InvLocFlag, 'slds-hide');
        var ListView = component.find("ListFlag");    
        $A.util.addClass(ListView, 'slds-hide');
        var InvRelease = component.find("InvRelease");    
        $A.util.addClass(InvRelease, 'slds-hide');
        var InvMain = component.find("InvMain");    
        $A.util.removeClass(InvMain, 'slds-hide');
        var bulk = component.find("bulk");    
        $A.util.addClass(bulk, 'slds-hide');
        var serial = component.find("serial");    
        $A.util.addClass(serial, 'slds-hide');
    } 
})