({
    toGetcustomerData:function(component, event,helper){
        //var action1 = component.get("c.getCurrentUserContact");
        //action1.setCallback(this, function(response){
            //alert(response.getState());
           // var state = response.getState();
            //if (state === "SUCCESS") 
            //{
                var actiongetcart = component.get("c.getAllCartDetails");
                actiongetcart.setCallback(this, function(response){
                    var state = response.getState();
                    // alert('DisplayProducts'+JSON.stringify(response.getReturnValue()));
                    if (state === "SUCCESS") {
                        if(response.getReturnValue()!= null)
                        {
                            component.set('v.CartValue',response.getReturnValue().length);
                            component.set('v.DisplayCartDetail',response.getReturnValue());
                            console.log(response.getReturnValue());
                            //alert('cartdetails>>'+component.get("v.DisplayCartDetail"));
                        }
                        else
                        {
                            if(component.get('v.CartValue') == 0)
                            {
                                 var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title: "warning",
                                message: 'No Product in Cart',
                                type: "warning"
                            });
                            toastEvent.fire();
                                component.set("v.HideButtons",false);
                            } 
                           
                            component.set('v.DisplayCartDetail',null)
                        }
                        
                    }
                    var spinner = component.find('spinner');
                    $A.util.toggleClass(spinner, "slds-hide");
                });
                $A.enqueueAction(actiongetcart); 
                
           // }
       // });
       // $A.enqueueAction(action1);
    },
    toDeleteProductCart:function(component, event,helper,index) {
        var CartDisplay =component.get('v.DisplayCartDetail');
        console.log(CartDisplay);
        //alert(JSON.stringify(CartDisplay[index].ProductId));
        var action = component.get("c.deleteProductFromCart");
        action.setParams({ 
            "soliId": CartDisplay[index].Id,
            "soId":CartDisplay[index].SOid,
            "ProductId":CartDisplay[index].ProductId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success",
                    message: 'Product is Removed from Cart',
                    type: "success"
                });
                toastEvent.fire();
                component.set("v.HideButtons",true);
                helper.toGetcustomerData(component, event,helper);
                var spinner = component.find('spinner');
                $A.util.toggleClass(spinner, "slds-hide");
            }
        });
        $A.enqueueAction(action);
    },
    UpdateCart:function(component, event,helper) {
        
        var index=event.getSource().get("v.name");
        var updatedQuantity=event.getSource().get("v.value");
        var proName;
        var qtyval;
        var temp= component.get("v.DisplayCartDetail");
        for(var i=0;i<temp.length;i++)
        {
            var newqty= temp[i].OrderedQuantity;
            if(!newqty || newqty<=0)
            {
                qtyval = temp[i].OrderedQuantity;
            }
        }
        component.set('v.DisplayCartDetail',temp);
        if(qtyval || qtyval<=0 )
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Warning",
                message: 'Entered Product Quantity is not valid',
                type: "warning"
            });
            toastEvent.fire();
            return;
        }
        else{
            var CartDisplay =JSON.stringify(component.get('v.DisplayCartDetail'));
            console.log(CartDisplay);
            var action = component.get("c.updateCartValue");
            action.setParams({ 
                "solilistjson":CartDisplay
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") 
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "success",
                        message: 'Cart Updated Successfully',
                        type: "success"
                    });
                    toastEvent.fire();
                    helper.toGetcustomerData(component, event,helper);
                    var spinner = component.find('spinner');
                    $A.util.toggleClass(spinner, "slds-hide");
                }
                else if (state === "INCOMPLETE") {
                    // do something
                }
                    else if (state === "ERROR") 
                    {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title: "Error",
                            message: 'Contact System Admin ',
                            type: "Error"
                        });
                        toastEvent.fire();
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + 
                                            errors[0].message);
                            }
                        } 
                        else {
                            console.log("Unknown error");
                        }
                    }
            });
            $A.enqueueAction(action);
        }
        component.set("v.PlaceorderBtn",false);
        var PlaceorderBtn=component.find('placeorder');
        $A.util.removeClass(PlaceorderBtn, 'slds-button_disabled');
    },
    
    checkingAddAndCloneData:function(component,event,helper,custid) 
    { 
        alert('To Place Order');
        var AddandCloneData=component.get('c.placeOrder');
        var CartDetails= JSON.stringify(custid);
        console.log(CartDetails);
        AddandCloneData.setParams({
            "solilistjson": CartDetails
        });
        AddandCloneData.setCallback(this, function(response) {
            var state = response.getState();
            if(response.getReturnValue().Status === 'SUCCESS'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "success",
                    message: response.getReturnValue().errorMessage,
                    type: "success"
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
            }
            else if(response.getReturnValue().Status === 'ERROR'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "ERROR",
                    message: response.getReturnValue().errorMessage,
                    type: "ERROR"
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
            }
        })
        $A.enqueueAction(AddandCloneData);
    },
    ClearCart:function(component, event,helper) 
    {
        var CustomerID=component.get('v.DisplayCustDetail');
        var action1 = component.get("c.ClearCartDetails");
        action1.setParams({ 
            "customerid":CustomerID
        });
        action1.setCallback(this, function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") 
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "success",
                    message: 'Cart Cleared Successfully',
                    type: "success"
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") 
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Error",
                        message: 'Contact System Admin ',
                        type: "Error"
                    });
                    toastEvent.fire();
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } 
                    else{console.log("Unknown error");}
                }
        });
        $A.enqueueAction(action1);
    }
})