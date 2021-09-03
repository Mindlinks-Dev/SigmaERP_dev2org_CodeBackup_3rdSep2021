({
    getILList : function(comp, event, helper,page) 
    {
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
    	SaveIL : function(component, event) {
            component.set("v.ILListval",component.get("v.InvLoc"));
         var actionIL = component.get("c.SaveIL");
        actionIL.setParams({            
          
          "InvLoc" : component.get("v.ILListval")
      });
        actionIL.setCallback( this, function(a){
            var state = a.getState();
            //alert(state)
              if (state === "SUCCESS"){ 
                 // alert('if');
                 if(a.getReturnValue() != null && a.getReturnValue() != undefined && a.getReturnValue() != ''){
                  alert('Record Successfully Created');
                     component.set("v.isOpen", false);
                     component.set("v.recordName2", "");
                       
                     //window.location.reload();
                  
                 }
                  else{
                      //alert('else');
                  alert('Record creation failed');
                  document.getElementById("Accspinner").style.display = "none";
                  
              }

              }
        });
        $A.enqueueAction(actionIL);
	}
})