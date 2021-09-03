({
    createProdComp: function (component, event, helper) {
        console.log('prodList::'+JSON.stringify(component.get("v.recipeChildData.recipeProdList")));
        var childdata = component.get("v.recipeChildData");
        helper.createRecipeChildH(component, event, helper, 'productcomponent', 'Add Product Component', childdata.rtWrap.productComponentID);
    },
    init: function (component, event, helper) {
        helper.loadRecipeChidData(component, event, helper);
    },
    createPackagingMat: function (component, event, helper) {
        var childdata = component.get("v.recipeChildData");
        helper.createRecipeChildH(component, event, helper, 'packagingMaterial', 'Add Packaging Material', childdata.rtWrap.packagingMaterialID);
    },
    addRecipes: function (component, event, helper) {
        var childdata = component.get("v.recipeChildData");
        helper.createRecipeChildH(component, event, helper, 'addrecipes', 'Add Dependent Recipe',childdata.rtWrap.stagesID);
    },
    createAddProd: function (component, event, helper) {
        var childdata = component.get("v.recipeChildData");
        helper.createRecipeChildH(component, event, helper, 'additionalproduct', 'Add Non Stock Item', childdata.rtWrap.additionalProdID);
    },
    refreshChildData: function (component, event, helper) {
        if (event.getParam("flag") == 'refreshchild') {
            helper.loadRecipeChidData(component, event, helper);
        }
        else if (event.getParam("flag") == 'refreshStageCost') {
            helper.loadRecipeChidData(component, event, helper);
        }

    },
    handleEdit: function (component, event, helper) {
        var HandleEditValue = event.getParam("value");

        var editchild = HandleEditValue.split(":");
        var childdata = component.get("v.recipeChildData");
        /* switch (editchild[2]) {
            case 'prodcomp':
                if (editchild[1] == 'edit') {
                    helper.createRecipeChildH(component, event, helper, 'productcomponent', 'Edit Product Component', childdata.rtWrap.productComponentID, editchild[0]);
                } else if (editchild[1] == 'delete') {
                    helper.deleteRecord(component, event, helper, editchild[0]);
                }
                break;
            case 'packagingMaterial':
                if (editchild[1] == 'edit') {
                    helper.createRecipeChildH(component, event, helper, 'packagingMaterial', 'Edit Packaging Material', childdata.rtWrap.packagingMaterialID, editchild[0]);
                } else if (editchild[1] == 'delete') {
                    helper.deleteRecord(component, event, helper, editchild[0]);
                }
                break;
            case 'additionalproduct':
                if (editchild[1] == 'edit') {
                    helper.createRecipeChildH(component, event, helper, 'additionalproduct', 'Edit Additional Prod', childdata.rtWrap.additionalProdID, editchild[0]);
                } else if (editchild[1] == 'delete') {
                    helper.deleteRecord(component, event, helper, editchild[0]);
                }
                break;
            case 'recipeStages':
                if (editchild[1] == 'edit') {
                    helper.createRecipeChildH(component, event, helper, 'addrecipes', 'Edit Dependent Recipes', childdata.rtWrap.stagesID, editchild[0]);
                } else if (editchild[1] == 'delete') {
                    helper.deleteRecord(component, event, helper, editchild[0]);
                }
                break;
        } */
        
        switch (editchild[2]) {
            case 'prodcomp':
                if (editchild[1] == 'edit') {
                    helper.createRecipeChildH(component, event, helper, 'productcomponent', 'Edit Product Component',childdata.rtWrap.productComponentID,editchild[0],null,null,true);
                } else if (editchild[1] == 'delete') {
                    helper.deleteRecord(component, event, helper, editchild[0]);
                }
                break;
            case 'packagingMaterial':
                if (editchild[1] == 'edit') {
                    helper.createRecipeChildH(component, event, helper, 'packagingMaterial', 'Edit Packaging Material', childdata.rtWrap.packagingMaterialID, editchild[0],null,null,true);
                } else if (editchild[1] == 'delete') {
                    helper.deleteRecord(component, event, helper, editchild[0]);
                }
                break;
            case 'additionalproduct':
                if (editchild[1] == 'edit') {
                    helper.createRecipeChildH(component, event, helper, 'additionalproduct', 'Edit Additional Prod', childdata.rtWrap.additionalProdID, editchild[0],null,null,true);
                } else if (editchild[1] == 'delete') {
                    helper.deleteRecord(component, event, helper, editchild[0]);
                }
                break;
            case 'recipeStages':
                if (editchild[1] == 'edit') {
                    helper.createRecipeChildH(component, event, helper, 'addrecipes', 'Edit Dependent Recipes', childdata.rtWrap.stagesID, editchild[0],null,null,true);
                } else if (editchild[1] == 'delete') {
                    helper.deleteRecord(component, event, helper, editchild[0]);
                }
                break;
        }
    },
    goHome : function(component, event, helper){
        //$A.get('e.force:refreshView').fire(); 
        //commented above line and added below line on 4-2-2020 to show in ManufacturingModules page after delete is completed	    
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:ManufacturingModules",
            componentAttributes: {
                from : 'recipe'
            }
        });
        evt.fire();
        //ends here
    },
     goHome1 : function(component, event, helper){
       var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:ManufacturingModules",
            componentAttributes: {
                from : 'recipe'
            }
        });
        evt.fire();
       var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"success",
                            "title": "Success!",
                            "message": "Recipe record saved successfully!"
                        });
                        toastEvent.fire();
    }
})