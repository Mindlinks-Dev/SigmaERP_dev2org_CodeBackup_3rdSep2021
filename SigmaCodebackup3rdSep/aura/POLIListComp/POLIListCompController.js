({
    toggle: function(component, event, helper) {
        var items = component.get("v.POList"); 
        var chevronright = component.find('chevronright');
        var chevrondown = component.find('chevrondown');
        $A.util.toggleClass(chevronright, 'slds-hide');
        $A.util.toggleClass(chevrondown, 'slds-hide');   
        var getAttributeValue = component.get("v.checkThis");
        if(getAttributeValue==true){
            component.set("v.checkThis", false);
            component.set('v.expanded',true);
        }
        else{
            component.set("v.checkThis", true);
            component.set('v.expanded',false);
        }
    },
    onSingleSelectChange2: function (cmp, evt, helper) {
        var  popWrapperLis=cmp.get('v.POList.popWrapperList');
      //  alert('vendorOldStatus'+popWrapperLis[evt.getSource().get("v.accesskey")].vendorOldStatus);
        //  alert("oldStatus"+popWrapperLis[evt.getSource().get("v.accesskey")].oldStatus);
        if(popWrapperLis[evt.getSource().get("v.accesskey")].vendorOldStatus==undefined)
        {
             //alert('oldStatus>>'+popWrapperLis[evt.getSource().get("v.accesskey")].oldStatus);
        
            
              popWrapperLis[evt.getSource().get("v.accesskey")].vendorOldStatus=evt.getSource().get("v.value");
          popWrapperLis[evt.getSource().get("v.accesskey")].oldStatus  =popWrapperLis[evt.getSource().get("v.accesskey")].vendorOldStatus;
          //  cmp.set("v.vendorOldStatus",  popWrapperLis[evt.getSource().get("v.accesskey")].vendorOldStatus);
        }
        else
        {
             popWrapperLis[evt.getSource().get("v.accesskey")].oldStatus =popWrapperLis[evt.getSource().get("v.accesskey")].vendorOldStatus;
                 
            //alert('oldStatus>>'+popWrapperLis[evt.getSource().get("v.accesskey")].oldStatus);
        
             // cmp.set("v.vendorOldStatus",  popWrapperLis[evt.getSource().get("v.accesskey")].vendorOldStatus);
          popWrapperLis[evt.getSource().get("v.accesskey")].vendorOldStatus=evt.getSource().get("v.value");
          
        }
      //  alert('vendorStatus'+popWrapperLis[evt.getSource().get("v.accesskey")].vendorStatus);
      // alert('vendorOldStatus>>'+popWrapperLis[evt.getSource().get("v.accesskey")].vendorOldStatus);
      //    alert('oldStatus>>'+popWrapperLis[evt.getSource().get("v.accesskey")].oldStatus);
      // return;
        //console.log("old value: " + evt.getParam("oldValue"));
        //console.log("current value: " + evt.getParam("value"));
       // if(evt.getSource().get("v.oldValue")!=undefined)
      //  {
		//	alert("old value: " + evt.getSource().get("v.oldValue"));            
       // }
       //  alert(evt.getParam('value'));
          //alert(evt.getParam('oldValue'));
        //alert(evt.getParam('value'));
         //alert("old value: " + evt.getSource().get("v.oldValue"));
     //  alert("current value: " + evt.getSource().get("v.value"));
       // return;
       //  console.log("old value: " + evt.getParam("oldValue"));
      //  console.log("current value: " + evt.getParam("value"));
        // alert("old value: " + evt.getParam("oldValue"));
        //alert("current value: " + evt.getParam("value"));
      //  var indexvar = evt.getSource().get("v.labelClass");
     var indexvar = evt.getSource().get("v.accesskey");
        if(popWrapperLis[indexvar].vendorStatus==='Accept' )
        {
            cmp.set('v.isAccept',true);
        }
        var tempList=[];
        if(popWrapperLis[indexvar].vendorStatus==='Dispatched' )
        {
            if(popWrapperLis[indexvar].vendorStatus==='Dispatched' )
            {
                popWrapperLis[indexvar].vendorStatus='Partial Dispatched';
            }
			cmp.set('v.POList.popWrapperList',popWrapperLis);
            var pop=JSON.parse(JSON.stringify(popWrapperLis[indexvar]));
            pop.DeleveredQuantity=0;
		pop.vendorExpectedShippedDate='';
		pop.vendorExpectedDeleveryDate='';
		pop.shipmentNotes='';
		pop.shipmentTrackingUrl='';
		pop.Reason='';
           // pop.oldStatus= popWrapperLis[evt.getSource().get("v.accesskey")].oldStatus;
            //cmp.set("v.POList.popWrapperList", popWrapperLis);
		//popWrapperLis[foundIndex1].DeleveredQuantity=0;
            
            tempList.push(pop);
            if(tempList.length>0)
                cmp.set('v.LineItem',tempList);
            cmp.set("v.isModalOpen3", true);
        } 
        if(popWrapperLis[indexvar].vendorStatus!=='Partial Dispatched' && popWrapperLis[indexvar].vendorStatus!=='Pending'  && popWrapperLis[indexvar].vendorStatus!=='Dispatched' ) 
        {
            if(popWrapperLis[indexvar].vendorStatus==='Request Cancel' || popWrapperLis[indexvar].vendorStatus==='Accept')
            {
                var  poList=cmp.get('v.POList'); 
                var found = popWrapperLis.find(function(element) { 
                    return element.POPName == popWrapperLis[indexvar].POPName; 
                }); 
                var foundIndex = popWrapperLis.findIndex(function(element) { 
                    return element.POPName == popWrapperLis[indexvar].POPName; 
                }); 
					var POListClone = JSON.parse(JSON.stringify(cmp.get('v.POList')));
					var popWrapperLisClone = JSON.parse(JSON.stringify(cmp.get('v.POList.popWrapperList')));
					var popWrapperLis2= popWrapperLisClone.filter(ele => ele.POPName === popWrapperLis[indexvar].POPName); 
					POListClone.popWrapperList=popWrapperLis2;
                //var popWrapperLis4= popWrapperLis.filter(ele => ele.POPName === found.POPName); 
               // poList.popWrapperList=popWrapperLis4;
                var action = cmp.get("c.savePos");
                action.setParams({ "polist" : JSON.stringify(POListClone) });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
						cmp.set("v.isSpinnerOpen", true);
		
				setTimeout(isOpen, 4000);
					function isOpen() {
					cmp.set("v.isSpinnerOpen", false);
					}
						var resp = response.getReturnValue(); 
					//	alert('resp'+JSON.stringify(resp));
						if(resp!=undefined)
						{
						popWrapperLis[foundIndex]=resp;	
						}
						//poList.popWrapperList=popWrapperLis;
						//alert('poList'+JSON.stringify(poList));
						console.log('poList'+JSON.stringify(poList));
						// alert('resp'+JSON.stringify(cmp.get('v.POList')));
						cmp.set('v.POList.popWrapperList',popWrapperLis);
                        //location.reload();
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            message: 'Purchase Order Updated successfully',
                            messageTemplate: 'Record {0} created! See it {1}!',
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'success',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                       // $A.get('e.force:refreshView').fire();
                    }
                });
                $A.enqueueAction(action);
                poList.popWrapperList=popWrapperLis;
                
            }
            
        }
    },
    closeModel3: function(cmp, event, helper) {
      var  LineItem2=cmp.get('v.LineItem')[0];
		var  popWrapperLis=cmp.get('v.POList.popWrapperList');
        var found = popWrapperLis.find(function(element) { 
            return element.POPName == LineItem2.POPName; 
        }); 
        var foundIndex1 = popWrapperLis.findIndex(function(element) { 
            return element.POPName == LineItem2.POPName; 
        });
       // alert('LineItem2.oldStatus'+LineItem2.oldStatus);
		
      //  alert('popWrapperLis[foundIndex1].oldStatus'+popWrapperLis[foundIndex1].oldStatus);
		popWrapperLis[foundIndex1].vendorStatus=popWrapperLis[foundIndex1].oldStatus;
        popWrapperLis[foundIndex1].vendorOldStatus=popWrapperLis[foundIndex1].oldStatus;
		cmp.set("v.POList.popWrapperList", popWrapperLis);
		//popWrapperLis[foundIndex1].DeleveredQuantity=0;
		cmp.set("v.LineItem", []);
        
        cmp.set("v.isModalOpen3", false);
        //$A.get('e.force:refreshView').fire();
    },
    keyCheck2: function(component, event, helper){
       // alert('LineItem'+JSON.stringify(component.get("v.LineItem")));
          var LineItem=component.get("v.LineItem");     
        var popWrapperList=component.get("v.POList.popWrapperList");     
        const found= LineItem.find(element => element.DeleveredQuantity === event.getParams('keyCode').value);
        if(found.DeleveredQuantity>found.Quantity)
        {
            component.set("v.isEnterReason", "false"); 
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message:' Delivered quantity should not be greater than order quantity',
                messageTemplate: 'Mode is pester ,duration is 5sec and Message is overrriden',
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
            return;
        }
        if(found.DeleveredQuantity<=0)
        {
            component.set("v.isEnterReason", "false"); 
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message:' Delivered quantity should not less than 0',
                messageTemplate: 'Mode is pester ,duration is 5sec and Message is overrriden',
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
            return;
        }
        console.log('zxczx'+event.getParams('keyCode').value);
        if(event.getParams('keyCode').value>0)
        {
            component.set("v.isEnterReason", true); 
        }
        else
        {
            component.set("v.isEnterReason", false); 
        }
        if(Number(found.Quantity)===Number(found.DeleveredQuantity))
        {
            component.set("v.isEnterReason", "false"); 
        }
    },
    savePurchaseOrder: function(cmp, event, helper) 
    {
		
        var LineItem2=cmp.get('v.LineItem')[0];
       // alert('LineItem2'+JSON.stringify(LineItem2.vendorExpectedShippedDate));
       
        if(JSON.stringify(LineItem2.vendorExpectedShippedDate)==='""' && JSON.stringify(LineItem2.vendorExpectedDeleveryDate)==='""')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message: 'Please Select Ship Date and Delivery Date',
                messageTemplate: 'Record {0} created! See it {1}!',
                duration:' 1000',
                key: 'info_alt',
                type: 'warning',
                mode: 'pester'
            });   
            toastEvent.fire();
            return;
        }
       else if(JSON.stringify(LineItem2.vendorExpectedShippedDate)===undefined && JSON.stringify(LineItem2.vendorExpectedDeleveryDate)===undefined)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message: 'Please Select Ship Date and Delivery Date',
                messageTemplate: 'Record {0} created! See it {1}!',
                duration:' 1000',
                key: 'info_alt',
                type: 'warning',
                mode: 'pester'
            });   
            toastEvent.fire();
            return;
        }
		 else if(JSON.stringify(LineItem2.vendorExpectedShippedDate)==='""' )
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message: 'Please Select Shipped Date',
                messageTemplate: 'Record {0} created! See it {1}!',
                duration:' 1000',
                key: 'info_alt',
                type: 'warning',
                mode: 'pester'
            });
            
            toastEvent.fire();
            return;
        }
        else if(JSON.stringify(LineItem2.vendorExpectedShippedDate)===undefined )
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message: 'Please Select Shipped Date',
                messageTemplate: 'Record {0} created! See it {1}!',
                duration:' 1000',
                key: 'info_alt',
                type: 'warning',
                mode: 'pester'
            });
            
            toastEvent.fire();
            return;
        }
		else if( JSON.stringify(LineItem2.vendorExpectedDeleveryDate)==='""')
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Please select  delevery date',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 1000',
                    key: 'info_alt',
                    type: 'warning',
                    mode: 'pester'
                });
                toastEvent.fire();
                return;
            }
            else if( JSON.stringify(LineItem2.vendorExpectedDeleveryDate)===undefined)
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Please select  delevery date',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 1000',
                    key: 'info_alt',
                    type: 'warning',
                    mode: 'pester'
                });
                toastEvent.fire();
                return;
            }
			   else if( JSON.stringify(LineItem2.shipmentNotes)==='""')
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Please enter  Shipment Note',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 1000',
                    key: 'info_alt',
                    type: 'warning',
                    mode: 'pester'
                });
                toastEvent.fire();
                return;
            }
			   else if( JSON.stringify(LineItem2.shipmentNotes)===undefined)
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Please enter  Shipment Note',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 1000',
                    key: 'info_alt',
                    type: 'warning',
                    mode: 'pester'
                });
                toastEvent.fire();
                return;
            }
			  else if( JSON.stringify(LineItem2.shipmentTrackingUrl)==='""')
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Please enter  Shipment TrackingUrl',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 1000',
                    key: 'info_alt',
                    type: 'warning',
                    mode: 'pester'
                });
                toastEvent.fire();
                return;
            }
			   else if( JSON.stringify(LineItem2.shipmentTrackingUrl)===undefined)
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Please enter  Shipment TrackingUrl',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 1000',
                    key: 'info_alt',
                    type: 'warning',
                    mode: 'pester'
                });
                toastEvent.fire();
                return;
            }
			
        if(LineItem2.DeleveredQuantity === 0)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({  
                message: 'Please enter Dispatched Qty',
                messageTemplate: 'Record {0} created! See it {1}!',
                duration:' 1000',
                key: 'info_alt',
                type: 'warning',
                mode: 'pester'
            });
            toastEvent.fire();
            return;
        }
        else if( LineItem2.DeleveredQuantity>0 && LineItem2.DeleveredQuantity>0 &&  LineItem2.DeleveredQuantity>LineItem2.remainingDispatchedQuantity )
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message: 'Please  Dispatched Qty Should not greater than Remaining Qty',
                messageTemplate: 'Record {0} created! See it {1}!',
                duration:' 1000',
                key: 'info_alt',
                type: 'warning',
                mode: 'pester'
            });
            toastEvent.fire();
            return;
        }
            else if( LineItem2.DeleveredQuantity>0 && LineItem2.DeleveredQuantity>0 &&  LineItem2.DeleveredQuantity>LineItem2.Quantity )
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Please  Dispatched Qty Should not greater than Total Qty',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 1000',
                    key: 'info_alt',
                    type: 'warning',
                    mode: 'pester'
                });
                toastEvent.fire();  
                return;
            }
                else if( LineItem2.DeleveredQuantity<=0 || LineItem2.DeleveredQuantity<=-0 )
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: '  Dispatched Qty Should be greater than 0',
                        messageTemplate: 'Record {0} created! See it {1}!',
                        duration:' 1000',
                        key: 'info_alt',
                        type: 'warning',
                        mode: 'pester'
                    });
                    toastEvent.fire();  
                    return;
                }
        /*else  if( LineItem2.DeleveredQuantity>0 && LineItem2.DeleveredQuantity>0 &&  LineItem2.DeleveredQuantity<LineItem2.Quantity &&  JSON.stringify(LineItem2.Reason)===undefined )
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        //   title : 'Success Message',
                        message: 'Please  enter comments',
                        messageTemplate: 'Record {0} created! See it {1}!',
                        duration:' 1000',
                        key: 'info_alt',
                        type: 'warning',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    return;
                }*/
		var deleveredDate = new Date(LineItem2.vendorExpectedDeleveryDate);      
		var today = new Date();
		var todaydate = new Date( today.getFullYear()+ "-" +(today.getMonth() + 1)+ "-" + today.getDate()); 
		var expDeleveyDate = new Date(deleveredDate.getFullYear()+ "-" +(deleveredDate.getMonth() + 1)+ "-" + deleveredDate.getDate() );        
		if(expDeleveyDate < todaydate)
        {
             var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        //   title : 'Success Message',
                        message: "Expected Delivery Date Should Be Greater Than Or Equal To Today's date.",
                        messageTemplate: 'Record {0} created! See it {1}!',
                        duration:' 1000',
                        key: 'info_alt',
                        type: 'warning',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    return;
        }
				
				
				
        var  poList=cmp.get('v.POList'); 
        var  popWrapperLis=cmp.get('v.POList.popWrapperList');
        var found = popWrapperLis.find(function(element) { 
            return element.POPName == LineItem2.POPName; 
        }); 
        var foundIndex1 = popWrapperLis.findIndex(function(element) { 
            return element.POPName == LineItem2.POPName; 
        }); 
        popWrapperLis[foundIndex1]=LineItem2;
		cmp.set('v.POList.popWrapperList',popWrapperLis)
         var popWrapperLis2= popWrapperLis.filter(ele => ele.POPName === found.POPName); 
        var POListClone = JSON.parse(JSON.stringify(cmp.get('v.POList')));
         var popWrapperLisClone = JSON.parse(JSON.stringify(cmp.get('v.POList.popWrapperList')));
        var popWrapperLis2= popWrapperLisClone.filter(ele => ele.POPName === LineItem2.POPName); 
        POListClone.popWrapperList=popWrapperLis2;
        //alert('POListClone'+JSON.stringify(POListClone));
        var action = cmp.get("c.savePos");
        action.setParams({ "polist" : JSON.stringify(POListClone) });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				cmp.set("v.isSpinnerOpen", true);
		
				setTimeout(isOpen, 4000);
					function isOpen() {
					cmp.set("v.isSpinnerOpen", false);
					}
                  var resp = response.getReturnValue(); 
                //alert('resp'+JSON.stringify(resp));
                if(resp!=undefined)
                {
                     popWrapperLis[foundIndex1]=resp;	
                }
                //poList.popWrapperList=popWrapperLis;
                //alert('poList'+JSON.stringify(poList));
                 console.log('poList'+JSON.stringify(poList));
                 // alert('resp'+JSON.stringify(cmp.get('v.POList')));
                cmp.set('v.POList.popWrapperList',popWrapperLis);
                  
                 //alert('POList'+JSON.stringify(cmp.get('v.POList')));
                // location.reload();
                cmp.set("v.isModalOpen3", false);
               // $A.get('e.force:refreshView').fire();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Purchase Order Updated successfully',
                    messageTemplate: 'Record {0} created! See it {1}!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        
    },
    OpenChat: function(component, event, helper) {
        component.set("v.isOpenChat", true);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isOpenChat", false);
    },
    EditPOLI: function(component, event, helper) {
        var  popWrapperLis=component.get('v.POList.popWrapperList');
        var indexvar = event.getSource().get("v.title");
        if(popWrapperLis[indexvar].POPId!=undefined && popWrapperLis[indexvar].POPId!=null && JSON.stringify(popWrapperLis[indexvar].POPId)!='""')
        {
            component.set("v.POliRecordId", popWrapperLis[indexvar].POPId);
            component.set("v.IsEditPOLI",true);
        }
    },
    handleSuccess1 : function(component, event, helper) {
        helper.hidePoli(component);
    },
    handleOnSubmit:function(component, event, helper)
    {
        component.set("v.IsEditPOLI",false);
    },
    handleCancel1 : function(component, event, helper) {
        component.set("v.IsEditPOLI",false); 
        helper.showHide(component);
        event.preventDefault();
    },
    
})