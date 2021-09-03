({      
    doInit: function (component, event, helper) {
      /*  alert('MRNew-->>'+JSON.stringify(component.get("v.ManufacRunObj.Id")));
		var ResourceAction = component.get("c.fetchMRResource");
                                    ResourceAction.setParams({					
                                        "manfRunId": component.get("v.ManufacRunObj.Id")
                                    });
                                    ResourceAction.setCallback(this, function (response) {
                                        var state = response.getReturnValue();										                                       
                                        if(state == 'Success'){
                                            component.set("v.resourceList",response.getReturnValue());
                                             alert('response.getReturnValue>>'+JSON.stringify(response.getReturnValue())); 
                                        }else{
                                           
                                        	var errors = response.getError();
                                            console.error(errors);
                                            alert('error while reverting auotpicked stock:'+JSON.stringify(errors));
                                            return;
                                        }                             
                                    });
                                    $A.enqueueAction(ResourceAction);  */       
    },
    goHome: function (component, event, helper) {
        var isStockResv = component.get("v.isStockReserved");       
       	
        var valFromChild = component.get("v.orderItemNewFromChild");
        var autoReverted = component.get("v.autopickReverted");
        
        var autoPickedStock = false;
        if(valFromChild != null){
            var innerList = valFromChild[0].mainWrapProdList;        
            for(var i=0;i<innerList.length;i++){                            	
                if(innerList[i].allocatedViaAutopickOrManual == true){
                    autoPickedStock = true;    
                }                	              
            }    
        } 
        if(autoReverted == false && autoPickedStock == true && isStockResv == false){
            $.confirm({
                title: 'Are you sure?',
                content: 'You want to close this Manufacturing Run(Autopicked stock will be reverted back.)',
                type: 'orange',
                typeAnimated: true,
                animation: 'scale',
                closeAnimation: 'scale',
                animationBounce: 2,
                buttons: {
                	Yes: {
                        text: 'Yes',
                        btnClass: 'btn-green',
                        action: function () {
                            window.setTimeout(
                                $A.getCallback(function () {
                                    //revert back autopicked stock
                                    var action11 = component.get("c.revertAutopickedStock");
                                    action11.setParams({					
                                        "manfRunId": component.get("v.ManufacRunObj.Id")
                                    });
                                    action11.setCallback(this, function (response) {
                                        var state = response.getReturnValue();										                                       
                                        if(state == 'Success'){
                                            component.set("v.autopickReverted", true);
                                            $A.get('e.force:refreshView').fire();  
                                       		//helper.showDetailsTabH(component, event, helper);    
                                        }else{
                                            component.set("v.autopickReverted", false);
                                        	var errors = response.getError();
                                            console.error(errors);
                                            alert('error while reverting auotpicked stock:'+JSON.stringify(errors));
                                            return;
                                        }                             
                                    });
                                    $A.enqueueAction(action11);                        
                                    //ends here                                    
                                }), 500
                            );
                            
                        }
                    },
                    No: function () {
                        return;
                    },
                }
            });
            /*var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"warning",
                "title": "Warning!",
                "message": 'Manufacturing Run cannot be closed when any of the Stock has been Autopicked and Reservation of Stock has not been done.'
            });
            toastEvent.fire();*/	    
        }else{
            //$A.get('e.force:refreshView').fire();    
            //commented above line and added below line on 3-2-2020 to show in ManufacturingModules page after delete is completed	    
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:ManufacturingModules",
                componentAttributes: {
                    from : 'MR'
                }
            });
            evt.fire();
            //ends here
        }        
    },
    
    calculateRecipe: function (component, event, helper) {		       
        helper.calculateRecipeH(component, event, helper);
    },        
    
    statusChanged: function (component, event, helper) {        
        var isStockResv = component.get("v.isStockReserved"); 
      //  component.set("v.isAddResources",false); 
        var status = component.get("v.ManufacRunObj.sigmaerpdev2__Status__c");                        
        if (status == 'Produced' && isStockResv == true) {
           
            helper.movementTabH(component, event, helper);
        }else if(status == 'Cancelled'){
            $.confirm({
                title: 'Are you sure?',
                content: 'You want to cancel this Manufacturing Run.',
                type: 'orange',
                typeAnimated: true,
                animation: 'scale',
                closeAnimation: 'scale',
                animationBounce: 2,
                buttons: {
                    Yes: {
                        text: 'Yes',
                        btnClass: 'btn-green',
                        action: function () {
                            window.setTimeout(
                                $A.getCallback(function () {
                                    var spinner = component.find("mySpinner");
                                    $A.util.toggleClass(spinner, "slds-hide");
                                    helper.cancelMR(component, event, helper);
                                }), 500
                            );                              
                        }                        
                    },
                    No: function () {
                    },
                }
            });                       
        }else if(isStockResv == false && (status == 'Stock Reserved' || status == 'Produced')){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"warning",
                "title": "Warning!",
                "message": 'Reserve the Stock first before proceeding to Stock Reserved / Produced Status.'
            });
            toastEvent.fire();
            component.set('v.ManufacRunObj.sigmaerpdev2__Status__c','Planning');
            return;
        }
    },
    
    saveManuRun: function (component, event, helper) {
        var ManufacRunObj = component.get("v.ManufacRunObj");
        
     	 component.set("v.isAddResources",false); 
        if(ManufacRunObj.sigmaerpdev2__Manufacturing_Name__c == '' || ManufacRunObj.sigmaerpdev2__Product__c == '' || ManufacRunObj.sigmaerpdev2__Status__c == '' || ManufacRunObj.sigmaerpdev2__Run_Date__c == '' || ManufacRunObj.sigmaerpdev2__End_Date__c == '' || ManufacRunObj.sigmaerpdev2__Recipe__c == '' || ManufacRunObj.sigmaerpdev2__Required_Quantity__c == ''  )
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"error",
                "title": "Warning!",
                "message": "Fill all the mandatory fields."
            });
            toastEvent.fire();
            return;
        }
        
       var startDate = component.get("v.ManufacRunObj.sigmaerpdev2__Run_Date__c");
       var endDate = component.get("v.ManufacRunObj.sigmaerpdev2__End_Date__c");
       if(endDate < startDate){            
       		var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "End date must be greater than Start date."
            });
            toastEvent.fire(); 
			component.set("v.ManufacRunObj.sigmaerpdev2__End_Date__c", '');              
            return;	
       } 
        
       //added new validation to fix BUG-04499
       if(component.get("v.manufacturingRunDetails.productCompList.length") == 0){
            if(component.get("v.manufacturingRunDetails.packagingMatList.length") == 0){ 
                if(component.get("v.manufacturingRunDetails.AdditionalProductList.length") == 0){                    
                    if(component.get("v.resourceList.length") == 0){                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"warning",
                            "title": "Warning!",
                            "message": "Add Product Components / Packaging Materials / Non Stock Items / Resource before trying to save this Manufacturing Run."
                        });
                        toastEvent.fire();
                        return;
                    }
                }
            }
        }
       //ends here
        
        
        $.confirm({
            title: 'Are you sure?',
            content: 'You want to save this Manufacturing Run details.',
            type: 'orange',
            typeAnimated: true,
            animation: 'scale',
            closeAnimation: 'scale',
            animationBounce: 2,
            buttons: {
                Yes: {
                    text: 'Yes',
                    btnClass: 'btn-green',
                    action: function () {
                        window.setTimeout(
                            $A.getCallback(function () {
                                var spinner = component.find("mySpinner");
                                $A.util.toggleClass(spinner, "slds-hide");
                                helper.saveManuRunH(component, event, helper);
                            }), 500
                        );
                        
                    }
                },
                No: function () {
                    
                },
            }
        });
        
    },
    
    editManufRun: function (component, event, helper) {	
        var mRid = component.get('v.ManufacRunObj');     
       	if(mRid.Id == '')
        { 
            component.set("v.isAddResources",false);
        }
        else
        {
            component.set("v.isAddResources",true);
        }
        var flag = event.getParam("flag");
        component.set("v.flagChk",flag);
        if (flag == 'edit') {
            helper.editManufRunH(component, event, helper);
        }else if (flag == 'updateExtraProdList') {
            component.set('v.isDataChanged', true);
            helper.updateExtraProdList(component, event, helper);
        }else if (flag == 'updateProdMatList') {
            component.set('v.isDataChanged', true);
            helper.updateProdMatList(component, event, helper);
        }else if (flag == 'resourceList') {
        	component.set('v.isDataChanged', true);
            helper.resourceList(component, event, helper);
        }else if (flag == 'stockReserved') {
        	component.set('v.status', 'Stock Reserved');
            component.set('v.ManufacRunObj.sigmaerpdev2__Status__c', 'Stock Reserved');
        }    
        
    },
    
    updateManuRun: function (component, event, helper) {
        var ManufacRunObj = component.get("v.ManufacRunObj");    
       // component.set('v.refreshResvStockTab', false);
        if(ManufacRunObj.sigmaerpdev2__Manufacturing_Name__c == '' || ManufacRunObj.sigmaerpdev2__Product__c == '' || ManufacRunObj.sigmaerpdev2__Status__c == '' || ManufacRunObj.sigmaerpdev2__Run_Date__c == '' || ManufacRunObj.sigmaerpdev2__End_Date__c == ''  || ManufacRunObj.sigmaerpdev2__Recipe__c == '' || ManufacRunObj.sigmaerpdev2__Required_Quantity__c == '')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"error",
                "title": "Warning!",
                "message": "Fill all the mandatory fields."
            });
            toastEvent.fire();
            return;
        }
        
       var startDate = component.get("v.ManufacRunObj.sigmaerpdev2__Run_Date__c");
       var endDate = component.get("v.ManufacRunObj.sigmaerpdev2__End_Date__c");
       if(endDate < startDate){            
       		var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "End date must be greater than Start date."
            });
            toastEvent.fire(); 
			component.set("v.ManufacRunObj.sigmaerpdev2__End_Date__c", '');              
            return;	
       }
        
       //added new validation to fix BUG-04499
       if(component.get("v.manufacturingRunDetails.productCompList.length") == 0){
            if(component.get("v.manufacturingRunDetails.packagingMatList.length") == 0){ 
                if(component.get("v.manufacturingRunDetails.AdditionalProductList.length") == 0){                    
                    if(component.get("v.resourceList.length") == 0){                        
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"warning",
                            "title": "Warning!",
                            "message": "Add Product Components / Packaging Materials / Non Stock Items / Resource before trying to update this Manufacturing Run."
                        });
                        toastEvent.fire();
                        return;
                    }
                }
            }
        }
       //ends here 

        
        $.confirm({
            title: 'Are you sure?',
            content: 'You want to update this Manufacturing Run details.',
            type: 'orange',
            typeAnimated: true,
            animation: 'scale',
            closeAnimation: 'scale',
            animationBounce: 2,
            buttons: {
                Yes: {
                    text: 'Yes',
                    btnClass: 'btn-green',
                    action: function () {
                        window.setTimeout(
                            $A.getCallback(function () {
                                var spinner = component.find("mySpinner");
                                $A.util.toggleClass(spinner, "slds-hide");
                                helper.updateManuRunH(component, event, helper);
                            }), 500
                        );
                        
                    }
                },
                No: function () {
                    
                },
            }
        });
         component.set("v.isAddResources",false);
    },
    selectedRecipe: function(component,event,helper){        
        var calcRunDisb = component.find("calcRun");                               
        if(calcRunDisb.get("v.disabled") == true){
            calcRunDisb.set("v.disabled",false);
        }
        /*var context = event.getParam("instanceId");
        var objectId = component.get('v.sigmaerpdev2OrderID');  
        //console.log('hi....'+component.get('v.recipeName'));     
        if(context=='Recipe')
            component.set("v.ManufacRunObj.sigmaerpdev2__Recipe__c",component.get('v.recipeID')); */               
    },
    
    ChangeRecipe: function (component, event, helper) {        
        var calcRunDisb = component.find("calcRun");                               
        if(calcRunDisb.get("v.disabled") == true){
            calcRunDisb.set("v.disabled",false);
        }            
        var RecipeVal = event.getParam("value");
        component.set("v.ManufacRunObj.sigmaerpdev2__Recipe__c", RecipeVal);
    },
    
    ChangeProd: function (component, event, helper) {
        var RecipeVal = event.getParam("value");
        component.set("v.ManufacRunObj.sigmaerpdev2__Product__c",RecipeVal[0]);
    },    
       
    ChangeDate: function (component, event, helper) {         
        var initVal = component.get("v.invalidDateEntered"); 
        var DateVal = event.getParam("value");        
        //component.set("v.ManufacRunObj.sigmaerpdev2__Run_Date__c", DateVal);
        var manRunID = component.get("v.ManufacRunObj.Id");        
        if(new Date(component.get("v.ManufacRunObj.sigmaerpdev2__Run_Date__c")) <= new Date())
        {   
            component.set("v.ManufacRunObj.sigmaerpdev2__Run_Date__c", '');
            if (initVal == false)
                initVal = true;
            else
				initVal = false;            
            component.set("v.invalidDateEntered", initVal);            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Run date must be greater than today\'s date."
            });
            toastEvent.fire();            
            return;
        }       
    },
    
    addPackagingMaterials: function (component, event, helper) {
        /*var compId;
        if(component.get("v.ManufacRunObj.sigmaerpdev2__Company__c") != '' && component.get("v.ManufacRunObj.sigmaerpdev2__Company__c") != undefined)            
            compId = component.get("v.ManufacRunObj.sigmaerpdev2__Company__c");
        else
            compId = component.get("v.compName"); */       
        //helper.addPackagingMaterialsH(component, event, helper, 'Add Packaging Materials', 'MRpackagingMaterial',component.get("v.compName"),component.get("v.ManufacRunObj.Id"),false);
        //helper.addPackagingMaterialsH(component, event, helper, 'Add Packaging Materials', 'MRpackagingMaterial',component.get("v.ManufacRunObj.sigmaerpdev2__Company__c"),component.get("v.ManufacRunObj.Id"),false);
        helper.addPackagingMaterialsH(component, event, helper, 'Add Packaging Material', 'MRpackagingMaterial',component.get("v.ManufacRunObj.Id"),false);
    },
    
    addextraProd: function (component, event, helper) {
        /*var compId;
        if(component.get("v.ManufacRunObj.sigmaerpdev2__Company__c") != '' && component.get("v.ManufacRunObj.sigmaerpdev2__Company__c") != undefined)            
            compId = component.get("v.ManufacRunObj.sigmaerpdev2__Company__c");
        else
            compId = component.get("v.compName");  */  
        //helper.addPackagingMaterialsH(component, event, helper, 'Add Additional Product', 'MRadditionalproduct',component.get("v.compName"),component.get("v.ManufacRunObj.Id"),false);
        helper.addPackagingMaterialsH(component, event, helper, 'Add Non Stock Item', 'MRadditionalproduct',component.get("v.ManufacRunObj.Id"),false);
    },
    
    calculationTab: function (component, event, helper) {
        component.set("v.detTabClk", false); //added newly on 25/6/2020
        
        //unreserve the autopicked stock(if any) and reservation of stock has not yet been done
        //if tab is switched from Reservation to Details tab by notifying the user
        var isStockResv = component.get("v.isStockReserved");        
        var valFromChild = component.get("v.orderItemNewFromChild");
        var autoRevert = component.get("v.autopickReverted"); 
        
        var autoPickedStock = false;
        if(valFromChild != null){
            var innerList = valFromChild[0].mainWrapProdList;        
            for(var i=0;i<innerList.length;i++){                            	
                if(innerList[i].allocatedViaAutopickOrManual == true){
                    autoPickedStock = true;    
                }                	              
            }    
        }
        
        //added newly on 7/4/2020(BUG-04401) check stock details if any new product is added in details page and again traversed back to material planning page        
		var childComp = component.find('childComp');
        if(childComp != undefined){
        	childComp.callChild();    
        }        
        //ends here
        
        if(autoPickedStock == false && isStockResv == false){
            helper.showDetailsTabH(component, event, helper);
        }else if(isStockResv == true){
            helper.showDetailsTabH(component, event, helper);
        }else if(autoPickedStock == true && isStockResv == false){            
           $.confirm({
                title: 'Are you sure?',
                content: 'You want to switch to Details tab before reserving the Stock(Autopicked stock will be reverted back.)',
                type: 'orange',
                typeAnimated: true,
                animation: 'scale',
                closeAnimation: 'scale',
                animationBounce: 2,
                buttons: {
                	Yes: {
                        text: 'Yes',
                        btnClass: 'btn-green',
                        action: function () {
                            window.setTimeout(
                                $A.getCallback(function () {
                                    if(autoRevert == false){
                                    	//revert back autopicked stock
                                        var action11 = component.get("c.revertAutopickedStock");
                                        action11.setParams({					
                                            "manfRunId": component.get("v.ManufacRunObj.Id")
                                        });
                                        action11.setCallback(this, function (response) {
                                            var state = response.getReturnValue();
                                            //alert('state==='+state);
                                            if(state == 'Success'){
                                                component.set("v.autopickReverted", true);
                                                component.set("v.disableChkStkAfterAutopick", false); //added on 28-8-2019 to fix bug no - 02885 
                                                helper.showDetailsTabH(component, event, helper);    
                                            }else{
                                                component.set("v.autopickReverted", false);
                                                var errors = response.getError();
                                                console.error(errors);
                                                alert('error while reverting auotpicked stock:'+JSON.stringify(errors));
                                                return;
                                            }                             
                                        });
                                        $A.enqueueAction(action11);                        
                                        //ends here     
                                    }                                                                       
                                }), 500
                            );
                            
                        }
                    },
                    No: function () {
                        return;
                    },
                }
            });
        }
        
        //ends here
        
        /*component.set('v.refreshResvStockTab', false);
        var status = component.get('v.status');
        if (status == 'Stock Reserved') {
            var updateManuRun = component.find("updateManuRun");
            $A.util.removeClass(updateManuRun, "slds-hide");
        }
        
        var tab1 = component.find('calculationId');
        var TabOnedata = component.find('calTabDataId');
        
        var tab2 = component.find('ReserveId');
        var TabTwoData = component.find('reserveTabDataId');
        
        var tab3 = component.find('MovementId');
        var TabThreeData = component.find('movementTabDataId');
        //show and Active fruits tab
        $A.util.addClass(tab1, 'slds-active');
        $A.util.addClass(TabOnedata, 'slds-show');
        $A.util.removeClass(TabOnedata, 'slds-hide');
        // Hide and deactivate others tab
        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-show');
        $A.util.addClass(TabTwoData, 'slds-hide');
        
        $A.util.removeClass(tab3, 'slds-active');
        $A.util.removeClass(TabThreeData, 'slds-show');
        $A.util.addClass(TabThreeData, 'slds-hide');
        
        //added on 1/8/2019        
        var resvFlag = component.get("v.isStockReserved");
        if(resvFlag){
            var action = component.get('c.editManufac');
            action.setParams({
                recordID : component.get("v.ManufacRunObj.Id") 
            });
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();            
                if (state === "SUCCESS") {                    
                    component.set('v.manufacturingRunDetails', response.getReturnValue());                
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    console.error(errors);
                    alert('error while refreshing tab'+JSON.stringify(errors));
                }
            }));
            $A.enqueueAction(action);
        }*/
        //ends here
        
    },
    //code added to handle Resource Planning Usage on 09-01-2020
    reserveTab: function (component, event, helper) {
        component.set("v.detTabClk", false); //added newly on 25/6/2020
        
        //component.set("v.autopickReverted", false);
        component.set('v.refreshResvStockTab', true);
        var msg = '';
        var mRid = component.get('v.ManufacRunObj');
        if(mRid.Id == '')
        	msg = 'Save the Manufacturing Run details before reserving the stock.';  
        else
            msg = 'Update the Manufacturing Run details before reserving the stock.';               
        
        if (mRid.Id == '' || component.get('v.isDataChanged') == true) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Warning!",
                //"message": "Save the Manufacturing Run details before reserving the stock."
                "message": msg
            });
            toastEvent.fire();
            return;
        }
        
        var status = component.get('v.status');
        if (status == 'Stock Reserved') {
            var updateManuRun = component.find("updateManuRun");
            $A.util.removeClass(updateManuRun, "slds-hide");
        }
        var tab1 = component.find('calculationId');
        var TabOnedata = component.find('calTabDataId');
        
        var tab2 = component.find('ReserveId');
        var TabTwoData = component.find('reserveTabDataId');
        
        var tab3 = component.find('MovementId');
        var TabThreeData = component.find('movementTabDataId');
        
        //show and Active vegetables Tab
        $A.util.addClass(tab2, 'slds-active');
        $A.util.removeClass(TabTwoData, 'slds-hide');
        $A.util.addClass(TabTwoData, 'slds-show');
        // Hide and deactivate others tab
        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(TabOnedata, 'slds-show');
        $A.util.addClass(TabOnedata, 'slds-hide');
        
        $A.util.removeClass(tab3, 'slds-active');
        $A.util.removeClass(TabThreeData, 'slds-show');
        $A.util.addClass(TabThreeData, 'slds-hide');
        
    },
    resourceTab: function (component, event, helper) {
        component.set("v.detTabClk", false); //added newly on 25/6/2020
        
        /*var iframe = document.getElementById('vfFrame');
		iframe.src = iframe.src;
        */
        //document.getElementById('vfFrame').contentWindow.location.reload(true);
        component.set('v.refreshResvStockTab', true);
        console.log('load gantt');
        
       component.set('v.spinner', true);  
   			
       component.set('v.isAddResources', true);
     
       var Gantturl = component.get("c.getGanttURL");
		Gantturl.setCallback(this, function(a) {
            // alert('response>>'+a.getReturnValue().sigmaerpdev2__GanttURL__c);
            component.set("v.vfHost",a.getReturnValue().sigmaerpdev2__GanttURL__c);
        });
      
        $A.enqueueAction(Gantturl);
        // end
    
    	 var msg = '';
        var mRid = component.get('v.ManufacRunObj');
        if (mRid.Id == '') {
             component.set('v.isAddResources', false);
            component.set('v.LoadGantt', false);
             component.set('v.spinner', false);
            msg = 'Save the Manufacturing Run details before allocating the resources.';  
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "warning",
                "title": "Warning!",                
                "message": msg
            });
            toastEvent.fire();
            return;
        }  
        else
        {
            component.set('v.LoadGantt', true);
        }
		//window.open('/apex/sigmaerpdev2__MR_GanttChart?Id='+mRid.Id, "_self"); 
		 window.setTimeout(function(){
           component.set('v.spinner', false); 
       	}, 2000);
    },
    movementTab: function (component, event, helper) {
        component.set("v.detTabClk", true); //added on 25/6/2020
        helper.movementTabH(component, event, helper);
    }, 
    
    deletePackageMat : function(component, event, helper){
        var flag = 'PackageMaterials';
        $.confirm({
            title: 'Are you sure?',
            content: 'You want to delete this product from Packaging Materials.',
            type: 'orange',
            typeAnimated: true,
            animation: 'scale',
            closeAnimation: 'scale',
            animationBounce: 2,
            buttons: {
                Yes: {
                    text: 'Yes',
                    btnClass: 'btn-green',
                    action: function () {
                        window.setTimeout(
                            $A.getCallback(function () {                               
                                helper.deleteAddedProdH(component, event, helper, flag);                                
                            }), 5
                        );
                        
                    }
                },
                No: function () {
                },
            }
        }); 
    },
    
    deleteAddProd : function(component, event, helper){
        var flag = 'AdditionalProd';
        $.confirm({
            title: 'Are you sure?',
            content: 'You want to delete this product from Additional Products.',
            type: 'orange',
            typeAnimated: true,
            animation: 'scale',
            closeAnimation: 'scale',
            animationBounce: 2,
            buttons: {
                Yes: {
                    text: 'Yes',
                    btnClass: 'btn-green',
                    action: function () {
                        window.setTimeout(
                            $A.getCallback(function () {                                
                                helper.deleteAddedProdH(component, event, helper, flag);                               
                            }), 5
                        );
                        
                    }
                },
                No: function () {
                },
            }
        });       
    },
    deleteResourceData : function(component, event, helper){     
        $.confirm({
            title: 'Are you sure?',
            content: 'You want to delete this Resource from Manufacturing Run Resource Planning???.',
            type: 'orange',
            typeAnimated: true,
            animation: 'scale',
            closeAnimation: 'scale',
            animationBounce: 2,
            buttons: {
                Yes: {
                    text: 'Yes',
                    btnClass: 'btn-green',
                    action: function () {
                        window.setTimeout(
                            $A.getCallback(function () {   
                                helper.deleteAddedResH(component, event, helper);                               
                            }), 5
                        );
                        
                    }
                },
                No: function () {
                },
            }
        });       
    },
    EditPackageMaterials : function(cmp,event,helper)
    {
        var pkgdata=cmp.get("v.manufacturingRunDetails.packagingMatList");
        var prodId = event.target.id;
        for(var i=0;i<pkgdata.length;i++)
        {
            if(pkgdata[i].ProdID==prodId)
            {
                var info={'ProductName':'',
                          'productID':'',
                          'oldProductID':'',
                          'Description':'',
                          'Quantity':'',
                          'UnityOfMeasure':''}
                info.ProductName=pkgdata[i].ProdName;
                info.productID=pkgdata[i].ProdID;
                info.oldProductID=pkgdata[i].ProdID;
                info.Description='';
                info.Quantity=pkgdata[i].Quantity;
                info.UnityOfMeasure=pkgdata[i].UnityOfMeasure;
            }
        }
        
        //helper.addPackagingMaterialsH(cmp,event,helper,'Add Packaging Materials', 'MRpackagingMaterial',cmp.get("v.compName"),cmp.get("v.ManufacRunObj.Id"),true,info);
        /*var compId;
        if(cmp.get("v.ManufacRunObj.sigmaerpdev2__Company__c") != '' && cmp.get("v.ManufacRunObj.sigmaerpdev2__Company__c") != undefined)            
            compId = cmp.get("v.ManufacRunObj.sigmaerpdev2__Company__c");
        else
            compId = cmp.get("v.compName"); */ 
        helper.addPackagingMaterialsH(cmp,event,helper,'Add Packaging Materials', 'MRpackagingMaterial',cmp.get("v.ManufacRunObj.Id"),true,info);
    },
    
    EditAdditionalProducts : function(cmp,event,helper)
    {
        var pkgdata=cmp.get("v.manufacturingRunDetails.AdditionalProductList");
        var prodId = event.target.id;
       
        for(var i=0;i<pkgdata.length;i++)
        {
            if(pkgdata[i].ProdID==prodId)
            {
                var info={'ProductName':'',
                          'productID':'',
                          'oldProductID':'',
                          'Description':'',
                          'Quantity':'',
                          'UnityOfMeasure':''}

                info.ProductName=pkgdata[i].ProdName;
                info.productID=pkgdata[i].ProdID;
                info.oldProductID=pkgdata[i].ProdID;
                info.Description='';
                info.Quantity=pkgdata[i].Quantity;
                info.UnityOfMeasure=pkgdata[i].UnityOfMeasure;

            }
        }
        //helper.addPackagingMaterialsH(cmp, event, helper,'Add Additional Product', 'MRadditionalproduct',cmp.get("v.compName"),cmp.get("v.ManufacRunObj.Id"),true,info);
        /*var compId;
        if(cmp.get("v.ManufacRunObj.sigmaerpdev2__Company__c") != '' && cmp.get("v.ManufacRunObj.sigmaerpdev2__Company__c") != undefined)            
            compId = cmp.get("v.ManufacRunObj.sigmaerpdev2__Company__c");
        else
            compId = cmp.get("v.compName"); */ 
        helper.addPackagingMaterialsH(cmp, event, helper,'Add Additional Product', 'MRadditionalproduct',cmp.get("v.ManufacRunObj.Id"),true,info);        
    },
    EditResourceData : function(cmp,event,helper)
    {
		var resdata=cmp.get("v.resourceList");       
        var resId = event.target.id;
		for(var i=0;i<resdata.length;i++)
        {
         	if(resdata[i].Id==resId)
            {
                var info={'Id' : '',
                          'RecordType' : '',
                          'sigmaerpdev2__Resource__c':'',
                          'sigmaerpdev2__Resource__r.sigmaerpdev2__Roles__c':'',
                          'sigmaerpdev2__Manufacturing_Run__c':''
                         } //'sigmaerpdev2__Start_Date__c':'','sigmaerpdev2__End_Date__c':'',

                info.allocresId = resdata[i].Id;
             //   info.recType = resdata[i].RecordType;
                info.ResourceId=resdata[i].sigmaerpdev2__Resource__c;
                info.ResourceName=resdata[i].sigmaerpdev2__Resource__r.Name;
                info.ResourceRoles=resdata[i].sigmaerpdev2__Resource__r.sigmaerpdev2__Roles__c;
                //info.StartDate=resdata[i].sigmaerpdev2__Start_Date__c;
               // info.EndDate=resdata[i].sigmaerpdev2__End_Date__c;


            }
             
     
        }
        
        helper.addResourcesH(cmp, event, helper,cmp.get("v.ManufacRunObj.Id"),true,info);        
    },
    getbackorderquant:function (component, event, helper) {       
	    var product = component.get('v.ManufacRunObj.sigmaerpdev2__Product__c');
        if(product == '' || product == undefined){
            var msg = 'Select product before trying to fetch the quantity.';
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": msg                    
            });
            toastEvent.fire();
            return;
        }  
        component.set("v.showQtyCalc", true);
        var action = component.get("c.fetchsigmaorderline");
		action.setParams({
			"prodID": product,
		});
		action.setCallback(this, function (a) {
		var state = a.getState();
		if (state === "SUCCESS"){
			var totalquantity = a.getReturnValue();            
            if(totalquantity == 0){   
                var msg = 'Selected product is not listed in any of the back order line items.Hence quantity is not fetched.';
            	var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "warning",
                    "title": "Warning!",
                    "message": msg                    
                });
                toastEvent.fire();
            }else{
            	component.set('v.ManufacRunObj.sigmaerpdev2__Required_Quantity__c',totalquantity);
                component.set('v.dispBackOrdQty',totalquantity);                
            }           
		}
		});
		$A.enqueueAction(action);
	},
    RedirectGantt: function (component, event, helper) {
        var msg = '';
        var mRid = component.get('v.ManufacRunObj');        
        if(mRid.Id == '')
        	msg = 'Save the Manufacturing Run details before allocating the resources.';  
        
        if (mRid.Id == '') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "warning",
                "title": "Warning!",                
                "message": msg
            });
            toastEvent.fire();
            return;
        }                      
		window.open('/apex/sigmaerpdev2__MR_GanttChart?Id='+mRid.Id);         
	},
    addResource : function(component, event, helper){    
       // alert('called bu add resource button');
      var mRid = component.get('v.ManufacRunObj.Id');      
      var isAddResources = component.get("v.isAddResources"); 
         
        var header;
        var modalBody;        
        $A.createComponent("c:AddResources",{
            MRResID:mRid,
            
        },
                           function(content, status, errorMessage) {                               
                               if (status === "SUCCESS") {
                                   modalBody = content;                                   
                                   component.find('popupmodal1').showCustomModal({
                                       header: header,
                                       body: modalBody, 
                                       showCloseButton: true,
                                       cssClass: "mymodal"
                                   })   
                                  
                               } 
                                else if (status === "ERROR") {
                                    console.log("Error: " + errorMessage);
                                    // Show error message
                                }
                           });
						         
        
    },
    handleResources: function(component, event, helper)
    {
		helper.showResourcesH(component, event, helper);
    },
   
    closeInfo : function(component, event, helper){
        component.set("v.showQtyCalc", false);
    },
    
    QntyChange : function(component, event, helper){	        
        var selVal = component.get("v.ManufacRunObj.sigmaerpdev2__Required_Quantity__c");        
        var recpVal = component.get("v.ManufacRunObj.sigmaerpdev2__Recipe__c");
        
        var startDateNew = component.get("v.ManufacRunObj.sigmaerpdev2__Run_Date__c");
        var endDateNew = component.get("v.ManufacRunObj.sigmaerpdev2__End_Date__c");
                                
        var mRid = component.get('v.ManufacRunObj');        
        //if(mRid.Id != ''){
            if(selVal != '' && selVal != undefined && recpVal != undefined && recpVal != '' && startDateNew != '' && endDateNew != ''){
                 //to alert user to click on calculate button before pressing save
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "info",
                    "title": "Alert!",
                    "message": "Please click on calculate button before saving/updating the Manufacturing Run!"
                });
                toastEvent.fire();    
            }
        //}
    },
    
    checkProdAdded : function(component, event, helper){           
		var producedProdId = component.get("v.ManufacRunObj.sigmaerpdev2__Product__c");        
        var pkgdata = component.get("v.manufacturingRunDetails.packagingMatList");
        var flag = false;
        if(pkgdata != null && pkgdata != undefined && pkgdata != ''){
            for(var i=0;i<pkgdata.length;i++)
            {
                if(pkgdata[i].ProdID == producedProdId)
                {                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error!",
                        "message": 'Selected Product is already added in Packaging Materials.'
                    });
                    toastEvent.fire();
                    flag = true;
                    break;                    			                    
                }
            }
            if(flag){
                component.set('v.ManufacRunObj.sigmaerpdev2__Product__c','');
            }            	
        }        
    },
/*    checkResAdded : function(component, event, helper){           
		var producedProdId = component.get("v.ManufacRunObj.sigmaerpdev2__Product__c");        
        var pkgdata = component.get("v.manufacturingRunDetails.packagingMatList");
        var flag = false;
        if(pkgdata != null && pkgdata != undefined && pkgdata != ''){
            for(var i=0;i<pkgdata.length;i++)
            {
                if(pkgdata[i].ProdID == producedProdId)
                {                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error!",
                        "message": 'Selected Product is already added in Packaging Materials.'
                    });
                    toastEvent.fire();
                    flag = true;
                    break;                    			                    
                }
            }
            if(flag){
                component.set('v.ManufacRunObj.sigmaerpdev2__Product__c','');
            }            	
        }        
    },*/
    validateEndDate: function (component, event, helper) {
        var startDate = component.get("v.ManufacRunObj.sigmaerpdev2__Run_Date__c");
        var endDate = component.get("v.ManufacRunObj.sigmaerpdev2__End_Date__c");
        
        if(startDate != '' && endDate != ''){
            if(endDate < startDate){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": "End date must be greater than Start date."
                });
                toastEvent.fire();  
                component.set("v.ManufacRunObj.sigmaerpdev2__End_Date__c", "");                
            }
        }
    },
    
    getRecpProduct : function(component, event, helper){        
    	helper.getRecpProductH(component, event, helper);     
    }
    
})