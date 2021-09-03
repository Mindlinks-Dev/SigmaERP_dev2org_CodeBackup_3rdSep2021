({
	doInit : function(comp, event, helper,page) {   
        
        page = page || 1;        
        var action = comp.get("c.fetchILList");
        action.setParams({ pageNumberIL : page });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var accs = response.getReturnValue(); 
                comp.set('v.total', accs.totalIL);
                comp.set('v.page', accs.pageIL);
                comp.set('v.pages', Math.ceil(accs.totalIL/accs.pageSizeIL));
                comp.set("v.ILList",accs.ILList);
                comp.set("v.IsCommunityUser",accs.IsCommunityUser);
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
    pageChange: function(component, event, helper) {
        var spinner = component.find("mySpinner");
		var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        helper.getILList(component, event, helper,page);
	},
    close: function(component, event, helper){
       window.location.reload();
        
    },
    
	openmodal:function(component,event,helper) {
		component.set("v.isOpen", true);	
	},
    closeModel:function(component,event,helper) {
		component.set("v.isOpen", false);	
	},
     SelectedID : function(component, event,helper) 
    {
          var context = event.getParam("instanceId");
         var objectId = event.getParam("sObjectId");
       component.set("v.InvLoc.sigmaerpdev2__Location__c",objectId);
    },
   ILSave:function(component, event, helper){
	   
        var ILLIST = component.get("v.ILList");
	     var ILEmpty = component.find("ILValidation");
      
        if(component.get("v.InvLoc.sigmaerpdev2__Location__c") === null ||component.get("v.InvLoc.sigmaerpdev2__Location__c") === '' || component.get("v.InvLoc.sigmaerpdev2__Location__c") ===undefined)
        {
            $A.util.addClass(ILEmpty , "textClass");
            ILEmpty.set("v.value", "Select Location");
            return;
        }
        else
        {
            ILEmpty.set("v.value", " ");
        }
      
      // component.set("v.ILListName",temp);
     //alert(component.get("v.recordName2"));
        var checkvalid = component.get("c.CheckduplicateIL");
       //alert(checkvalid);
       checkvalid.setParams({"InvLocId":component.get("v.recordName2")});
       checkvalid.setCallback(this, function(a) {
            var state = a.getState();
            var dupIL=a.getReturnValue();
           //alert(dupIL+'dupIL');
           if(dupIL != null && dupIL != '' && dupIL != undefined){
               alert(component.get("v.recordName2") +''+'Location is already Exists ');
               //return;
               component.set("v.isOpen", false);	
             
                          }
           else{
               
               document.getElementById("Accspinner").style.display = "block"; 
         
        helper.SaveIL(component,event, helper);
           }
       });
          $A.enqueueAction(checkvalid);  
           
           
           
           
         /*  
           alert('IL'+component.get("v.InvLoc.sigmaerpdev2__Location__c"));
           //alert(dupIL[].sigmaerpdev2__Location__r.Name);
           if(component.get("v.recordName2") == dupIL.sigmaerpdev2__Location__c){
                 alert('if');
               var msg = component.get("v.InvLoc.sigmaerpdev2__Location__c")+"Location is already Exists ";
                        component.set("v.errorMsgs", msg);
                        component.set("v.isErrors",true);
                        return; 
             }else{
                 component.set("v.isErrors",false);
                 component.set("v.errorMsgs", ""); 
             }
       });
        $A.enqueueAction(checkvalid); 
    
        document.getElementById("Accspinner").style.display = "block"; 
         
        helper.SaveIL(component,event, helper); */
        },
    CancelIL:function(component, event, helper){
        window.location.href = "/apex/PropductInventoryVF";
    }
    
})