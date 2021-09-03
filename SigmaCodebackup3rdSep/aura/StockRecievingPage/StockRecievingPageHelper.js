({
	getstockList : function(comp, event, helper,page) 
    {
        page = page || 1;
        var action = comp.get("c.fetchStockRecievingList");
        action.setParams({ pageNumber : page });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var accs = response.getReturnValue();
                
                comp.set('v.total', accs.totalSigma);
                comp.set('v.page', accs.pageSigma);
                comp.set('v.pages', Math.ceil(accs.totalSigma/accs.pageSizeSigma));
                comp.set("v.stockList",accs.stockList);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
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
    viewProductHelper: function (component, event, helper,ind) {
      //  alert('calling viewProductHelper');
       // var prodId = component.get("v.orderLinesData")[ind].orderLines.sigmaerpdev__Product__c;
     //   alert('prodId>>>'+prodId);
     
        var action = component.get("c.getproductimage");
        action.setParams({
            "prodId": ind,
        });
        
        action.setCallback(this, function (a) {
            var state = a.getState();
           // alert('state::'+state);
            if (state == "SUCCESS") {
                var productimage=a.getReturnValue();
                component.set('v.ProductImageData',productimage);
                component.set('v.productimageexist',true);
            }
           else
           {
             component.set('v.productimageexist',false); 
           }   
             component.set('v.ProductView',true);
        });
        $A.enqueueAction(action);
    }
})