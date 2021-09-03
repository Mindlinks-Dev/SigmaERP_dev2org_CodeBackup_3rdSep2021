({
	searchHelper : function(component,event,getInputkeyWord) {
	  // call the apex class method 
     var action = component.get("c.fetchLookUpValues");
      // set param to method  
      //alert(getInputkeyWord+' '+component.get("v.whereCondition")+' '+component.get("v.objectAPIName"));
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'whereCondition': component.get("v.whereCondition"),
            'ObjectName' : component.get("v.objectAPIName")
          });
      // set a callBack    
        action.setCallback(this, function(response) {
          $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                //alert('state>>>>'+state)
                var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
                // alert('27>>>>'+JSON.stringify(component.get("v.listOfSearchRecords")))
               //alert('value>>'+JSON.stringify(component.get("v.listOfSearchRecords")));
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    },
})