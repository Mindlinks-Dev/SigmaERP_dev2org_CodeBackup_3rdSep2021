({  
     createRecipeChildH : function(component, event, helper,flagvalue,headerValue,recTypeID,rID,stagesCostList,recpProdId,Edit) {
        var modalBody;
        var recipeData = component.get("v.recipeData");
        var recpChildData = component.get("v.recipeChildData");
        //added newly on 19/2/2020
        if(recpProdId == undefined){
        	recpProdId = component.get("v.recipeData.sigmaerpdev2__Product__r.Id");
        }        
        //ends here 
         
        //$A.createComponent("c:AddRecipeComponents", {"flag":flagvalue,"Edit":Edit,"recipeID":recipeData.Id,"RecTypeID":recTypeID,"recID":rID,"recipeStagesCost":stagesCostList,"recpProdID":recpProdId,"recipeChildData":recpChildData,"companyID":component.get("v.recipeData.stapplink__Company__c")},
       // alert('recpprodid-----'+component.get("v.recpProdID"));
        $A.createComponent("c:AddRecipeComponents", {"flag":flagvalue,"Edit":Edit,"recipeID":recipeData.Id,"RecTypeID":recTypeID,"recID":rID,"recipeStagesCost":stagesCostList,"recpProdID":recpProdId,"recipeChildData":recpChildData,"companyID":null},
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   modalBody = content;
                                   component.find('RecipeDetailsModal').showCustomModal({
                                       header: headerValue,
                                       body: modalBody, 
                                       showCloseButton: true,
                                       cssClass: "mymodal"
                                   })
                                   
                               }
                               
                           });
    }, 
    
    loadRecipeChidData : function(component, event, helper) {
        var action = component.get('c.fetchRecipeChildData');
        var recipeData = component.get("v.recipeData");
        action.setParams({ RecipeId : recipeData.Id });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.recipeChildData',response.getReturnValue());
                if(event.getParam("flag") ==  'refreshStageCost')
                {
                    var idx = component.get("v.index");
                    var recipeChildData = component.get("v.recipeChildData");
                    helper.createRecipeChildH(component, event, helper,'viewcost','Recipe Stages Cost',null,null,recipeChildData.recipeStagesCostWrap[idx].recipeStagesCostList,recipeChildData.recipeStagesCostWrap[idx].recipeStagesRec.Id);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    deleteRecord : function(component, event, helper,RecordId) {
        var action = component.get('c.deleteRecord');
        action.setParams({ recID : RecordId });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() == 'success')
                {
                    helper.loadRecipeChidData(component, event, helper);
                }
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    }
})