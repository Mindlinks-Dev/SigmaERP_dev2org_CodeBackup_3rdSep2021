({
    AddNewRow : function(component, event, helper){
        // fire the AddNewRowEvt Lightning Event 
        component.getEvent("AddRowEvt").fire();     
    }, 
    
    // function call on component Load
    doInit: function(component, event, helper) {
        // create a Default RowItem [POP Instance] on first time Component Load
        // by call this helper function  
        
        var today = new Date();
        component.set('v.OrderedDate', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        var tempPurchaseOrderId = component.get("v.Id");
        helper.createObjectData(component, event);
    },
    
    // function for save the Records 
    Save: function(component, event, helper) {
        //	alert('save');
        //Check validations in helper function
       
        if (helper.validateRequired(component, event)) {
            // call the apex class method for save the PO and POP List
            // with pass the list of object attribute to method param.  
            
            var orderDate= component.get("v.OrderedDate");
            var expectedDate = component.get("v.ExpectedDate");
            
            //  alert('expectedDate>>'+expectedDate);
            //   alert('Data'+JSON.stringify(component.get("v.MultiplePOWrapList")));
            console.log('came in'+JSON.stringify(component.get("v.MultiplePOWrapList")));
            
            var resultdata = component.get("v.MultiplePOWrapList"); 
            console.log('resultdata.length>>'+resultdata.length);
            //    alert('resultdata>>'+resultdata);
            if(expectedDate == undefined || expectedDate == null || expectedDate == '')
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:'PO expected date is mandatory',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                return;
            }
            var todaysDate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
            if( expectedDate<todaysDate){
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": "Expected date  must be future date."
                });
                toastEvent.fire();
                return;
            }            
            if(resultdata == undefined || resultdata == null || resultdata == '')
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:'No details found to Generate PO.',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                return;
            }
            for(var i=0; i<resultdata.length; i++)
            {
                var reqant = resultdata[i].POP.sigmaerpdev2__Product__c;
                var vendorIdData = resultdata[i].vendorId;
                var vendorLocationName =resultdata[i].vendorLocation
                var orderQty =resultdata[i].POP.sigmaerpdev2__Quantity__c;
                // alert('vendorLocationName before save'+resultdata[i].vendorLocation);
                var excepedDeliveryDate = resultdata[i].POP.sigmaerpdev2__Expected_Delivery_Date__c;
                console.log('excepted date'+resultdata[i].POP.sigmaerpdev2__Expected_Delivery_Date__c);
                console.log('reqant>>'+JSON.stringify(reqant));
                console.log('reqant.length>>'+reqant);
                if(reqant == undefined || reqant == null || reqant == '')
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'Please select the product to create PO!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    return;
                }
                if(vendorIdData == undefined || vendorIdData == null || vendorIdData == '')
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'Please select the vendor details to create PO!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    return;
                }
                if(vendorLocationName == undefined || vendorLocationName == null || vendorLocationName == '')
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'Selected vendor location is not configured to create PO!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    return;
                }
                if(orderQty == 0)
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'Order Qty should be greater than 0!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    return;
                }
                if(excepedDeliveryDate == undefined || excepedDeliveryDate == null || excepedDeliveryDate == '')
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'Please select the Expected Delivery Date to create PO!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    return;
                }
            }
            //alert('MultiplePOWrapList<>>>>>>>>.'+JSON.stringify(component.get("v.MultiplePOWrapList")));
            var action = component.get("c.saveMultiplePO");
            // alert('expectedDate'+expectedDate);
            action.setParams({
                "ListofMultiplePOs": JSON.stringify(component.get("v.MultiplePOWrapList")),
                "expectedDate": expectedDate
                // "orderDate": component.get("v.OrderedDate")
            });
            // set call back 
            action.setCallback(this, function(response) {
                var state = response.getState();
                // alert('state suc>>>>>>>>'+state);
                if (state === "SUCCESS") {
                    // if response if success then reset/blank the 'contactList' Attribute 
                    // and call the common helper method for create a default Object Data to Contact List 
                    component.set("v.MultiplePOWrapList", []);
                    helper.createObjectData(component, event);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Purchase Orders created Successfully!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    window.location.reload();
                    console.log('close');
                    // alert('Purchase Order created Successfully!');
                }
                else if(state === "ERROR") {
                    // var spinner = component.find("mySpinner");
                    //$A.util.toggleClass(spinner, "slds-hide");   
                    //component.set("v.expanded", false);      
                    var errors = response.getError();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'Error occured while creating PO record : '+JSON.stringify(errors),
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    return;          
                    
                    // alert('Error occured while creating PO record : '+JSON.stringify(errors));
                }
            });
            // enqueue the server side action  
            $A.enqueueAction(action);
        }
    },
    
    // function for create new object Row in Contact List 
    addNewRow: function(component, event, helper) {
        // call the comman "createObjectData" helper method for add new Object Row to List  
        helper.createObjectData(component, event);
    },
    
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        // get the all List (contactList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.MultiplePOWrapList");
        AllRowsList.splice(index, 1);
        // set the contactList after remove selected row element  
        component.set("v.MultiplePOWrapList", AllRowsList);
    },
})