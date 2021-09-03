({
    doInit  : function(component, event, helper){
        //alert('in');
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        
        var fromids = component.get("v.recordId");  			
        //alert('fromids'+fromids);
        var action1 = component.get("c.saveproduct"); 
        // alert('action1'+action1);
        action1.setParams({
            "fromid" : fromids,     
        });
        action1.setCallback(this, function(response) 
                            {                                
                                var state = response.getState();
                                // alert('state'+state);
                                if (state == 'SUCCESS')
                                {              
                                    //alert('ins');
                                    var productlineitem = response.getReturnValue(); 
                                     //alert('productlineitem'+JSON.stringify(productlineitem));
                                    if(productlineitem==null){
                                        //alert('errors');
                                        //var spinner = component.find("mySpinner");
                                        //$A.util.toggleClass(spinner, "slds-hide");  
                                        var toastEvent = $A.get("e.force:showToast");    
                                        
                                        toastEvent.setParams({"title": "Warning!",    
                                                              "message": "Product Request is not approved",
                                                              "mode":"sticky",
                                                              "type":"error"
                                                             });    
                                        toastEvent.fire();
                                        
                                        alert('Product Request is not approved');
                                        $A.get("e.force:closeQuickAction").fire();
                                    }
                                    component.set('v.ToLocation',productlineitem.sigmaerpdev2__Service_Location__r.Name);                                                                          
                                    if(productlineitem.sigmaerpdev2__Default_Bin__r != undefined){
                                        component.set('v.ToBin',productlineitem.sigmaerpdev2__Default_Bin__r.Name);    
                                    }   
                                    
                                    /*component.set('v.FromLocationId',productlineitem.sigmaerpdev2__Requested_From_Location__c);
                                    	component.set('v.FromBinId',productlineitem.sigmaerpdev2__From_Bin__c);
                                    	 
                                     	/*var toId = component.get('v.ToLocationId');
                                     	var bintoId = component.get('v.ToBinId');*/
                                    
                                    //var fromLocId = component.get('v.FromLocationId');
                                    //	var binfromId = component.get('v.FromBinId');
                                    
                                    var action123 = component.get("c.fetchILP1");
                                    //alert('action123'+action123);
                                    action123.setParams({
                                        
                                        "recId" : fromids,  
                                    });
                                    
                                    action123.setCallback(this, function (response123) {
                                        var state = response123.getState();     
                                       //  alert('state1'+state);
                                        if (state == "SUCCESS") {                                                   
                                            component.set('v.wrappdatas', response123.getReturnValue());
                                            console.log('productlineitem@=='+JSON.stringify(component.get('v.wrappdatas')));
                                        }else{
                                            var errors = response123.getError();
                                            alert('err==='+JSON.stringify(errors));
                                        }                                                
                                    });
                                    
                                    var spinner = component.find("mySpinner");
                                    $A.util.toggleClass(spinner, "slds-hide");
                                    $A.enqueueAction(action123);
                                    
                                }else{
                                    // alert('innns');
                                    var spinner = component.find("mySpinner");
                                    $A.util.toggleClass(spinner, "slds-hide");
                                }
                            });         
         $A.enqueueAction(action1);
         
         
     },
    
    //call apex class method
    /*   var action = component.get('c.getproduct');
      var prodId = '01t4S000000HxChQAK';
      action.setCallback(this, function(response) {
            action.setParams({
                "fromid" : prodId,     
            });
        //store state of response
        var state = response.getState();
        if (state === "SUCCESS") {
            console.log('resp===='+JSON.stringify(response.getReturnValue()));
          component.set('v.wrappdatas', response.getReturnValue());
            alert('productlineitem@'+JSON.stringify(component.get('v.wrappdatas')));
        }
      });
      $A.enqueueAction(action);
    
         
         
         
       
    },*/
    
    checkProductRequestStatus : function(component, event, helper) {
        helper.checkProductRequestStatusHelper(component,event);
    },
    createProductTransfer : function(component, event, helper) {
        var value = component.get("v.wrappdatas[0].mainWrapProdList");
        //alert('value>>>'+JSON.stringify(value));
        for(var i=0; i<value.length; i++)
        {
            var reqant = value[i].requiredQnt;
            var prodNames = value[i].prodName;
           // alert('prodName'+prodNames);
            var totalqyant = 0;
            var data1 = value[i].wrapProdList.length;
            for(var j=0; j<data1; j++)
            {
                var result2 = value[i].wrapProdList[j].selQuantity;
                var availquanty = value[i].wrapProdList[j].ilpAvailQuantity;
               // alert('availquanty>>>'+availquanty);
               // alert('Inside if result2>>'+result2); 
                if(result2 > availquanty)
                {
                    j +=1;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'Pick Quantity must be equal to or less than Available Quantity of ' + prodNames +' at line Number '+ j,
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    return;
                }
                else if(result2 < 0)
                {
                    j +=1;
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:'Pick Quantity cannot be Negative of ' + prodNames +' at line Number '+ j,
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    return; 
                }
                if(result2 != undefined)
                {
                    totalqyant +=result2; 
                   // alert('Inside if totalqyant'+totalqyant); 
                }
               
            }
           // alert('totalqyant>>>'+totalqyant);
           // alert('reqant>>'+reqant);
            if(reqant != totalqyant)
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:'Pick Quantity cannot be more or less than Requested Quantity of ' + prodNames,
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                return;
            }
        }
        helper.createProductTransferHelper(component,event);
    },
    closeWindow : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    
    
    
    
    productTitle : function(component, event, helper) {
        var sldsSection = component.find('sldsSection');
        $A.util.toggleClass(sldsSection, 'slds-hide');
        
    },
    cancel : function(component, event, helper) {
        location.reload();
    }
})