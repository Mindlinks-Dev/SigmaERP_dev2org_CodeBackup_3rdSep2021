({
    fetchRecipes: function (cmp, event, helper) {
        var action = cmp.get('c.fetchRecipes');
        var counts = cmp.get("v.currentCount");
        action.setParams({
            "limits": cmp.get("v.initialRows"),
            "offsets": counts
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.recipedataList', response.getReturnValue().recipeList);
                cmp.set("v.totalNumberOfRows", response.getReturnValue().totalRows);
                /*if(response.getReturnValue().totalRows != null){
                    cmp.set("v.totalNumberOfRows", response.getReturnValue().totalRows);
                }*/
                if (cmp.get('v.recipedataList').length >= cmp.get('v.totalNumberOfRows')) {
                    cmp.set('v.loadMoreStatus', '');
                }
                
                var countstemps = cmp.get("v.currentCount");
                countstemps = countstemps + cmp.get("v.initialRows");
                cmp.set("v.currentCount", countstemps);
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
            var spinner = cmp.find("mySpinner");
            $A.util.toggleClass(spinner, "slds-hide");
        }));
        $A.enqueueAction(action);
    },
    fetchData: function (component, event, helper) {
        return new Promise($A.getCallback(function (resolve, reject) {
            var currentDatatemp = component.get('c.fetchRecipes');
            var counts = component.get("v.currentCount");
            currentDatatemp.setParams({
                "limits": component.get("v.initialRows"),
                "offsets": counts
            });
            currentDatatemp.setCallback(this, function (a) {
                if(a.getReturnValue().totalRows != null){
                    component.set("v.totalNumberOfRows", a.getReturnValue().totalRows);    
                }
                var countstemps = component.get("v.currentCount");
                countstemps = countstemps + component.get("v.initialRows");
                component.set("v.currentCount", countstemps);
                
                resolve(a.getReturnValue().recipeList);
                
            });
            $A.enqueueAction(currentDatatemp);
        }));
        
    },
       
    createRecipeH: function (component, event, helper, recordID) {
        var modalBody;
        $A.createComponent("c:AddRecipeComponents_M", { "flag": "createrecipe", "recID": recordID },
                           function (content, status) {                
                               if (status === "SUCCESS") {
                                   modalBody = content;
                                   component.find('createRecipeModal').showCustomModal({
                                       header: "Create Recipe",
                                       body: modalBody,
                                       showCloseButton: true,
                                       cssClass: "mymodal"
                                   })
                                   
                               }
                               
                           });
    },
    
    updateRecipesListH: function (cmp, event, helper) {
        var flag = event.getParam("flag");
        if (flag == 'updaterecipelist') {
            var action = cmp.get('c.fetchRecipes');
            var counts = cmp.get("v.currentCount");
            action.setParams({
                "limits": counts,
                "offsets": 0
            });
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    cmp.set('v.recipedataList', response.getReturnValue().recipeList);
                    cmp.set("v.totalNumberOfRows", response.getReturnValue().totalRows);
                    
                    if (cmp.get('v.recipedataList').length >= cmp.get('v.totalNumberOfRows')) {
                        cmp.set('v.loadMoreStatus', '');
                    }
                    
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    console.error(errors);
                }
            }));
            $A.enqueueAction(action);
        }
        
    },
    handleEditFlowH: function (component, event, helper) {
        var data = event.getParam("data");
        var flag = event.getParam("flag");
        component.set("v.recipedata",data);
        if (flag == 'view') {
            var RecipeManagementDetails = component.find("RecipeManagementDetails");
            var dataList = component.find("dataList");
            $A.util.removeClass(RecipeManagementDetails, "slds-hide");
            $A.util.addClass(dataList, "slds-hide");
            component.set("v.hideMRHeader", true);
        } else if (flag == 'update') {
            helper.createRecipeH(component, event, helper, data.Id)
        }else if (flag == 'delete') {
            //console.log('data.Id===>'+data.Id);
            helper.deleteRecipeH(component, event, helper, data.Id)
        }else if (flag == 'clone') {
            var action = component.get('c.cloneRecipe');
            action.setParams({
                "recipID": data.Id,
                "limits": component.get("v.currentCount"),
                "offsets": 0
            });
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set('v.recipedataList', response.getReturnValue().recipeList);
                    component.set("v.totalNumberOfRows", response.getReturnValue().totalRows);
                    if (component.get('v.recipedataList').length >= component.get('v.totalNumberOfRows')) {
                        component.set('v.loadMoreStatus', '');
                    }
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    console.error(errors);
                }
            }));
            $A.enqueueAction(action);
        }
    },
    
    deleteRecipeH : function(component, event, helper,recordID){        
        var action = component.get('c.deleteRecipe');
        action.setParams({
            "recipeID": recordID
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {               
                var resp = response.getReturnValue();                
                if(resp == 'success'){                   
                    //$A.get('e.force:refreshView').fire();
                    //commented above line and added below line on 3-2-2020 to show in ManufacturingModules page after delete is completed	    
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:ManufacturingModules",
                        componentAttributes: {
                            from : 'recipe'
                        }
                    });
                    evt.fire();
                    //ends here
                }else if(resp == 'failure'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "title": "Error!",
                        "message": "Recipe could not be deleted."					
                    });
                    toastEvent.fire();    
                }                
            }else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    }
})