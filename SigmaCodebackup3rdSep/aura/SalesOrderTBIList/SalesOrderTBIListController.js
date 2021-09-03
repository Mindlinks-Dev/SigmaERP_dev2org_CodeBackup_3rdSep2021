({
	myAction : function(component, event, helper) {
		
	},
    addProducts : function(component, event, helper) {
		 var rowIndex =event.getSource().get("v.name");
       	var wrapperListInsertLineItems= component.get("v.wrapperListInsertLineItems");
          component.set("v.isOpen", true);
        var appEvent  = $A.get("e.c:carryorderpopup");
        appEvent.setParams({"popup" : wrapperListInsertLineItems[rowIndex],
                            "rowIndex": rowIndex 
                           });
        appEvent.fire();
        
	},
     handleRemoveProductItemClick : function(component, event, helper) {
       var self = this;  // safe reference
		 var TestDelete1 = component.find('ModalDelete');
        $A.util.removeClass(TestDelete1, 'slds-hide');
         var index = event.target.dataset.index;
        component.set("v.index",index);
   },
     confirmModalDelete : function(component, event, helper) 
    {
        var olRemoveIdList=new Array();
        var abc=  component.get("v.index");
       // alert('abc>>'+abc);
       var wraplist=component.get("v.wrapperListInsertLineItems"); 
       // alert('wraplist++'+JSON.stringify(wraplist));
       // alert('wraplistitem++'+JSON.stringify(wraplist[abc].LineItem));
        
        if(wraplist[abc].LineItem.Id)
        {
           olRemoveIdList.push(wraplist[abc].LineItem); 
        }
       // alert('olRemoveIdList>>'+JSON.stringify(olRemoveIdList));
        wraplist.splice(abc, 1);
         component.set("v.wrapperListInsertLineItems",wraplist);
       // alert('data>>'+ JSON.stringify(component.get("v.wrapperListInsertLineItems")));
        
         if(olRemoveIdList.length>0){
            var action = component.get("c.deleteIndividualproposalline");        
            action.setParams({ 
                "ProposalLines" : olRemoveIdList
            });
            action.setCallback( this, function(a){
                var state = a.getState();
               // alert("state"+state);
                /*if (state === "SUCCESS")
                {
                   alert('Record deleted');
                     var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Deleted",
                        "message": "The Order Lines deleted from Database also."
                    });
                    resultsToast.fire(); 
                }*/
            });
            $A.enqueueAction(action);
        }
        
        var confirmModalDelete = component.find('ModalDelete');
        $A.util.addClass(confirmModalDelete, 'slds-hide');
    },
     cancelModalDelete : function(component, event, helper) {
       
        var cancelModalDelete = component.find('ModalDelete');
        $A.util.addClass(cancelModalDelete, 'slds-hide');
    }
   
})