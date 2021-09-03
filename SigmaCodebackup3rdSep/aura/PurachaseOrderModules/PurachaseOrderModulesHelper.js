({
    helperMethod : function(component) {
        
        
     /* var jsonString={
       "Menu":[
      {
               "chapters":[
      {
         "objectName":"Purchase",
         "steps":[
            {
               "stepNum":1,
               "title":"Vendor",
               "content":"<p>This is step 1 - image. Recently viewed opportunities are listed here</p>"
            },
            {
               "stepNum":2,
               "title":"Status",
               "content":"<p>This is step 1 - image. Recently viewed opportunities are listed here</p>"
            },
            {
               "stepNum":3,
               "title":"Order Date",
               "content":"<p>This is step 1 - image. Recently viewed opportunities are listed here</p>"
            },
            {
               "stepNum":4,
               "title":"Expected Date",
               "content":"<p>This is step 1 - image. Recently viewed opportunities are listed here</p>"
            },
            {
               "stepNum":5,
               "title":"Currency",
               "content":"<p>This is step 1 - image. Recently viewed opportunities are listed here</p>"
            }            
         ]
      },
      {		
         "objectName":"Stock",
         "steps":[
            {
               "stepNum":1,
               "title":"vendor",
               "content":"<p>This is step 1 - image. Recently viewed opportunities are listed here</p>"
            },
            {
               "stepNum":2,
               "title":"Contact",
               "content":"<p>This is step 1 - image. Recently viewed opportunities are listed here</p>"
            },
            {
               "stepNum":3,
               "title":"Location",
               "content":"<p>This is step 1 - image. Recently viewed opportunities are listed here</p>"
            },
            {
               "stepNum":4,
               "title":"Truck number",
               "content":"<p>This is step 1 - image. Recently viewed opportunities are listed here</p>"
            },
            {
               "stepNum":5,
               "title":"Received DateTime",
               "content":"<p>This is step 1 - image. Recently viewed opportunities are listed here</p>"
            }                       
         ]
      }
   ]
   }
   ]
         };
     	component.set('v.jsonString',jsonString);*/
       var action = component.get("c.fetchJSONHelpMenu");
        //alert(cmp.get("v.recordId"));
        //action.setParams({ recId : cmp.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                console.log("From server: " + response.getReturnValue());
                var jsonData=response.getReturnValue();
               	component.set('v.jsonString',jsonData[0]);      
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
    }
})