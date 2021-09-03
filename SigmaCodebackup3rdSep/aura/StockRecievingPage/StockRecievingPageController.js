({
    doInit : function(component, event, helper,page) {
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        page = page || 1;        
        var action = component.get("c.fetchStockRecievingList");                
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
                component.set("v.stockList",accs.stockList);
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
     handleComponentEvent: function (component, event, helper) {
        if (event.getParam("flag") == 'Viewproductimage') {
           
          // component.set('v.ViewProductIndex',event.getParam("data").index);
            // alert(component.get('v.ViewProductIndex'));
           helper.viewProductHelper(component, event, helper,event.getParam("data").ProductID);
        }
     },
    StockReceivingComponent : function(component, event, helper){
		component.set("v.stockFlag",true); 
        component.set("v.Listflag",false);
        
    },   
    
    handlestockId : function(cmp, event) {
    //     alert('called by parent>>'+event.getParam("purchaseId"));
        var Stockid = event.getParam("stockId");
     // alert('purchId-->>'+purchId);
        if(Stockid!=undefined && Stockid!=null && JSON.stringify(Stockid)!='""')
        {
             
            cmp.set("v.stockId",Stockid);
             cmp.set("v.stockFlag",false);
            cmp.set("v.isstockrecieveWithId",true); 
        cmp.set("v.Listflag",false);

        
         }

    },
  
    pageChange: function(component, event, helper) {
        var spinner = component.find("mySpinner");
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        helper.getstockList(component, event, helper,page);
    },
})