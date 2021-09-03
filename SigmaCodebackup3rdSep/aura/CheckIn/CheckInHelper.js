({
    getWOCheckListRecords : function(cmp,event) {
        debugger;
        var action = cmp.get("c.getWOCheckList");
        action.setParams({ recordId:cmp.get('v.recordId') });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                debugger;
                var arrayOfMapKeys = [];
                var toastEvent = $A.get("e.force:showToast");
                
                
                //Fetching the data that is getting returned from the Apex.
                var responseData = (response.getReturnValue()).checkList;
                
                if(responseData==null){
                    //if the data is empty, display a corresponding message.
                    toastEvent.setParams({
                        title: "Error",
                        type: "error",
                        message:"",
                        mode : "sticky"
                    });
                    toastEvent.fire();
                }
                else{
                    var sizeOfTimeSheets = (response.getReturnValue()).sizeOfTimeSheet; 
                    if(parseInt(sizeOfTimeSheets) == 0 && responseData.length!=0){
                        
                        cmp.set('v.firstCheckIn',true);
                        cmp.set('v.secondCheckIn',false);
                        
                        toastEvent.setParams({
                            title: "Success",
                            type: "success",
                            message: ""
                        });
                        toastEvent.fire();
                        
                        var detailsMap = new Map(); 
                        
                        for(var i=0;i<responseData.length;i++){
                            var options = [];
                            var tempOption = new Object();
                            tempOption['name']=responseData[i].Name;
                            tempOption['label']='Yes';
                            tempOption['value']=responseData[i].sigmaerpdev2__Yes__c;
                            options.push(tempOption);
                            tempOption = new Object();
                            tempOption['name']=responseData[i].Name;
                            tempOption['label']='No';
                            tempOption['value']=responseData[i].sigmaerpdev2__No__c;
                            options.push(tempOption);
                            tempOption = new Object();
                            tempOption['name']=responseData[i].Name;
                            tempOption['label']='NA';
                            tempOption['value']=responseData[i].sigmaerpdev2__Not_Applicable__c;
                            options.push(tempOption);
                            detailsMap.set(responseData[i].sigmaerpdev2__Name_Text__c,options);
                        }
                        cmp.set('v.radioButtonDetails',detailsMap);
                        //var keysTemp = detailsMap.keys();
                        var keysTemp=Array.from(detailsMap.entries());
                        var keys=[];
                        for(var i=0;i<keysTemp.length;i++){
                            keys.push(keysTemp[i][0]);
                        }
                        
                        cmp.set('v.keys',keys);
                        cmp.set('v.checkList',responseData);
                        //cmp.set('v.radioButtonDetails',detailsMap);
                    }
                    else{
                        var finalValues = new Object();
                        cmp.set('v.finalValues',finalValues);
                        cmp.set('v.firstCheckIn',false);
                        cmp.set('v.secondCheckIn',true);
                    }
                }
            } else if (state === "INCOMPLETE") {
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
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Error",
                        type: "error",
                        message:"",
                        mode : "sticky"
                    });
                    toastEvent.fire();
                }
            //toastEvent.fire();
        });
        // optionally set storable, abortable, background flag here
        
        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
    },
    
    submitDetailsHelper : function(cmp,event) {
        var action = cmp.get("c.updateCheckListRecords");
        action.setParams({ checkListDetails : cmp.get('v.finalValues') });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var arrayOfMapKeys = [];
                var toastEvent = $A.get("e.force:showToast");
                
                //Fetching the data that is getting returned from the Apex.
                var responseData = response.getReturnValue();
                
                toastEvent.setParams({
                    title: "Success",
                    type: "success",
                    message: ""
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();
            } else if (state === "INCOMPLETE") {
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
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Error",
                        type: "error",
                        message:"",
                        mode : "sticky"
                    });
                    toastEvent.fire();
                }
            //toastEvent.fire();
        });
        // optionally set storable, abortable, background flag here
        
        // A client-side action could cause multiple events, 
        // which could trigger other events and 
        // other server-side action calls.
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
    }
})