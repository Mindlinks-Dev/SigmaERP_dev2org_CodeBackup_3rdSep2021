({
    CSV2JSON: function (component,csv) {
        var arr = []; 
        arr =  csv.split('\n');
        arr.pop();
        var jsonObj = [];
        var headers = arr[0].split(',');
        for(var i = 1; i < arr.length; i++) {
            var data = arr[i].split(',');
            var obj = {};
            for(var j = 0; j < data.length; j++) {
                obj[headers[j].trim()] = data[j].trim();
            }
            jsonObj.push(obj);
        }
        var json = JSON.stringify(jsonObj);
        return json;       
    },
    
    
    UpdateRecord : function (component, event, helper,jsonstr){
        
        var action = component.get('c.insertData');  
        action.setParams({
            strfromle : jsonstr
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            var result=response.getReturnValue();
            //alert(state);
            //alert(JSON.stringify(result));
            
            if(state==="SUCCESS"){
                if (response.getReturnValue() == "success") {  
                    //alert(result);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        type:"success",
                        "message": "Stock Updated successfully."
                    });
                    toastEvent.fire();
                    
                    
                }
                else if (response.getReturnValue().includes("error1")) {
                    var res=response.getReturnValue().replace('error1', '');
                    //alert(result);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        type:"Error",
                        "message": "Stock contains duplicate products at row "+res
                    });
                    toastEvent.fire(); 
                    
                }
                else if (response.getReturnValue().includes("errorp")) {
                    var res=response.getReturnValue().replace('errorp', '');
                    //alert(result);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        type:"Error",
                        "message": "Not found Vendor Product "
                    });
                    toastEvent.fire(); 
                    
                }
                else if (response.getReturnValue().includes("errorLoc")) {
                    var res=response.getReturnValue().replace('errorLoc', '');
                    //alert(result);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        type:"Error",
                        "message": "Location should not be empty for product: "+res
                    });
                    toastEvent.fire(); 
                    
                }
                else if (response.getReturnValue().includes("errorVC")) {
                    var res=response.getReturnValue().replace('errorVC', '');
                    //alert(result);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        type:"Error",
                        "message": "Vendor Product code should not be empty at row " + res
                    });
                    toastEvent.fire(); 
                    //button.set('v.disabled',true);
                }
                    else{
                        alert(JSON.stringify(response.getReturnValue()));
                    }
                
                
            }
            /*if(state === "ERROR"){
                var errors = response.getError(); 
                alert(errors[0].message);
                component.set("v.errorMessage",JSON.stringify(errors[0]));                           
                component.set("v.showErrors",true);
                idNotFound
                
            }*/
            else{
                //if (response.getReturnValue() == null){
                    //alert(result);
                    var errors = response.getError();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        type:"Error",
                        "message": JSON.stringify(errors[0])
                    });
                    toastEvent.fire(); 
                    
               // }
            }
            //component.set("v.fileName", '');
            $A.get('e.force:refreshView').fire();
            
        }); 
        
        $A.enqueueAction(action);    
        
    },
    
    checkRecord : function (component, event, helper,jsonstr){
        
        var action = component.get('c.checkData');  
        action.setParams({
            strfromle : jsonstr
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            var result=response.getReturnValue();
            alert(state);
            alert(JSON.stringify(response.getError()));
            alert('128'+JSON.stringify(result));
            if(state==="SUCCESS"){
                if (response.getReturnValue().includes("errorVC")) {
                    var res=response.getReturnValue().replace('errorVC', '');
                    //alert(result);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        type:"Error",
                        "message": "Vendor Product code should not be empty at row " + res
                    });
                    toastEvent.fire(); 
                    //button.set('v.disabled',true);
                }
                if (response.getReturnValue().includes("errorLoc")) {
                    var res=response.getReturnValue().replace('errorLoc', '');
                    //alert(result);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        type:"Error",
                        "message": "Location should not be empty for product: "+res
                    });
                    toastEvent.fire(); 
                    
                }
            
            }
            else{
                alert('else')
            }
            //component.set("v.fileName", '');
            $A.get('e.force:refreshView').fire();
            
        }); 
        
        $A.enqueueAction(action);    
        
    },
})