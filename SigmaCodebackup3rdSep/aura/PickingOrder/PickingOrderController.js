({
	 pageChange: function(component, event, helper) {
       // var spinner = component.find("mySpinner");
        var page = component.get("v.page") || 1;
        
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
         //let POId= component.get('v.POId');
       //  console.log('POId>>>'+POId);
		 component.set("v.page",page)
         //if(POId)
        helper.getSOData(component, event, helper,null,null);
        // else helper.getPOList(component, event, helper,page,null);
    },
    sortOnPriority: function (component, event, helper) {
        var spinner=component.find('spinner');
        $A.util.removeClass(spinner, 'slds-hide');
        
        $A.util.toggleClass(component.find('priorityArrowup'),'slds-hide');
        $A.util.toggleClass(component.find('priorityArrowdown'),'slds-hide');
        if(component.get('v.mobileScreenFlag'))
        {
            $A.util.toggleClass(component.find('priorityArrowupMobi'),'slds-hide');
            $A.util.toggleClass(component.find('priorityArrowdownMobi'),'slds-hide');
        }
        if(component.get('v.prioritySort')!='desc')
            component.set('v.prioritySort','desc');
        else
            component.set('v.prioritySort','asc');
        console.log('prioritySort'+component.get('v.prioritySort'));
        helper.getSOData(component, event, helper,'OrderNumber',component.get('v.prioritySort'));
    },
    sortOnDueDate: function (component, event, helper) {
        var spinner=component.find('spinner');
        $A.util.removeClass(spinner, 'slds-hide');
        
        $A.util.toggleClass(component.find('dueDateArrowup'),'slds-hide');
        $A.util.toggleClass(component.find('dueDateArrowdown'),'slds-hide');
        if(component.get('v.mobileScreenFlag'))
        {
            $A.util.toggleClass(component.find('dueDateArrowupMobi'),'slds-hide');
            $A.util.toggleClass(component.find('dueDateArrowdownMobi'),'slds-hide');
        }
        if(component.get('v.dueDateSort')!='desc')
            component.set('v.dueDateSort','desc');
        else
            component.set('v.dueDateSort','asc');
        console.log('dueDateSort'+component.get('v.dueDateSort'));
        helper.getSOData(component, event, helper,'sigmaerpdev2__Delivary_Date__c',component.get('v.dueDateSort'));
    },
    
    confirmPickMultiSO:function (component, event, helper) {
        var standOrderData=component.get('v.standOrderData');
        var selectedOrderIdList=[];
        
        for(var i=0;i<standOrderData.length;i++)
        {
            if(standOrderData[i].standOrder.isSelected)
            {
                selectedOrderIdList.push(standOrderData[i].standOrder.Id);
            }
        }
        if(selectedOrderIdList.length>0)
        {
            component.set('v.disableSave',true);
            var spinner=component.find('spinner');
            $A.util.toggleClass(spinner, 'slds-hide');
            
            helper.helperConfirmPickMultiSO(component, event, helper,selectedOrderIdList);
            //var url1 = '/apex/Stapp__PickingPDF?soIdList='+selectedSoIdList+'&selectedTab='+component.get('v.selectedTab');
            //window.open(url1);
            //$A.get('e.force:refreshView').fire();
        }
        else
        {
            alert('Please select the Order');
        }
    },
    allocatBulk:function (component, event, helper) {
        var standOrderData=component.get('v.standOrderData');
        var selectedOrderIdList='[';
        var isSelected=false;
        for(var i=0;i<standOrderData.length;i++)
        {
            if(standOrderData[i].standOrder.isSelected)
            {
                //selectedSoIdList.soId=stappOrderData[i].stappOrder.Id;
                //selectedSoIdList.userId=stappOrderData[i].PickedUser;
                selectedOrderIdList+='{"oId":"'+standOrderData[i].standOrder.Id+'","userId":"'+standOrderData[i].PickedUser+'"},';
                isSelected=true;
            }
        }
        selectedOrderIdList=selectedOrderIdList.slice(0, -1);
        selectedOrderIdList+=']'
        if(isSelected)
        {
            helper.helperAllocatBulk(component, event, helper,selectedOrderIdList);
        }
        else
        {
            alert('Please select the Order');
        }
    },
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
      //  component.set("v.isSpin", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
      /*  var executed = false;
        var loaded = function () {
            if (!executed) {
                $(".sk-rotating-plane").fadeOut("slow");
                setTimeout(function () {
                    $('body').addClass('slds-spinner_container');
                }, 10);
                executed = true;
            }
        };
        $(window).on('load', loaded);
        setTimeout(loaded, 5000);*/
       
      // component.set("v.isSpin", false);
    },
    
    autoAllocation : function (cmp, event, helper) 
    {
        
        // alert('allocatedAs');
        var allocatedAs=  cmp.get('v.allocatedAs');
        //alert('allocatedAs'+allocatedAs);
        allocatedAs='AutoPick';
        cmp.set('v.allocatedAs',allocatedAs);
        //alert('allocatedAs'+ cmp.get('v.allocatedAs'));
        //alert("You clicked: " + event.getSource().get("v.label"));
        var autoAllocationInpicking = cmp.get("v.autoAllocationInpicking");
        autoAllocationInpicking=true;
        var action = cmp.get("c.getOrderUsage");
        action.setParams
        ({
            'autoAllocationInpicking':autoAllocationInpicking,
        }); 
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                               //alert(state);
                               if (state === "SUCCESS") 
                               {
                                   //    alert(response.getReturnValue());
                                   cmp.set("v.autoAllocationInpicking",response.getReturnValue());
                                   
                               }
                               else{
                                   //  alert("something went wrong");
                               }
                           });
        $A.enqueueAction(action);	
        var selChkbox = cmp.get("v.selChkboxCount");    	
        if(selChkbox > 1)
        {            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"warning",
                "title": "Warning!",
                "message": 'You can select only one Order at a time for Manual/Auto allocation during Picking.'
            });
            toastEvent.fire();	 
            return;
        }
        var standOrderData=cmp.get('v.standOrderData');
        var selectedSoIdList=[];
        for(var i=0;i<standOrderData.length;i++)
        {
            if(standOrderData[i].standOrder.isSelected)
            {
                if(!standOrderData[i].standOrder.sigmaerpdev2__Allocated_User__c)
                {
                    //   alert('Picker is not allocated for the Order \''+standOrderData[i].standOrder.Name+'\'');
                    return;
                }
                selectedSoIdList.push(standOrderData[i].standOrder.Id);
                //  var allocatedAs=cmp.get("v.allocatedAs");
                //	allocatedAs='ManualPick';
                //	cmp.set("v.allocatedAs", allocatedAs);
            }
        }
        
        var action = cmp.get("c.getIlpli1");
        // alert();
        action.setParams({
            'soIds':selectedSoIdList,
        });  
        // alert(action);
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                               //  alert(state);
                               if (state === "SUCCESS") 
                               {
                                   
                                   var data = response.getReturnValue();
                                   // alert('in'+JSON.stringify(data));
                                   console.log('Data>>>>>'+JSON.stringify(data)); 
                                   cmp.set("v.standOrderLineWrapper", response.getReturnValue());
                               }
                               
                           });
        $A.enqueueAction(action);
        
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "type": "success",
            "message": "Auto Allocation is Done Sucessfully"
        });
        resultsToast.fire();
    },  
    handleAutoSelectCheckBox:function(component, event, helper){
        // alert('handleAutoSelectCheckBox called');
        var checkBoxValue=component.find('checkbox1').get('v.value');
        // alert('handleAutoSelectCheckBox called>>'+checkBoxValue);
        var tempILPLIData=component.get("v.originalILPLIData");
        //alert(component.find("orderedQuant").get('v.value'));
        var tempQaunt=component.find("orderedQuant").get('v.value');
        for(var i=0;i<tempILPLIData.length;i++){
            if(checkBoxValue){
                if(tempQaunt>=tempILPLIData[i].sigmaerpdev2__Available_Quantity__c && tempQaunt!=0){
                    tempILPLIData[i].enteredQuant=tempILPLIData[i].sigmaerpdev2__Available_Quantity__c;
                    tempQaunt-=tempILPLIData[i].sigmaerpdev2__Available_Quantity__c;
                }
                else if(tempQaunt!=0){
                    tempILPLIData[i].enteredQuant=tempQaunt;
                    tempQaunt-=tempQaunt;
                }
            }
            else{
                tempILPLIData[i].enteredQuant=0;
            }
        }
        component.set("v.originalILPLIData",tempILPLIData);
    },
    selectMalually: function (component, event, helper) {
        
        if(component.get("v.StandardOrderLines.Product2Id")==undefined || component.get("v.StandardOrderLines.Product2Id")==='')
        {
            //alert('Product Not Selected');
            return;
        }
        if(component.get("v.StandardOrderLines.sigmaerpdev2__Net_Quantity__c")==undefined || component.get("v.StandardOrderLines.sigmaerpdev2__Net_Quantity__c")==='' || component.get("v.StandardOrderLines.sigmaerpdev2__Net_Quantity__c")<1)
        {
            // alert('Enter a Valid Quantity');
            return;
        } 
        var SigmaComponentEvent = component.getEvent("SigmaComponentEvent");
        SigmaComponentEvent.setParams({
            "data" : {"index":component.get('v.indexNum')},//"AttributeType":component.get("v.productPrices")[0].stapp__Attribute_Type__c},
            "flag" : "manualSelectILPLI"
        });
        SigmaComponentEvent.fire();
    },
    proceedToPackShip:function (component, event, helper) {
        // alert('proceedToPackShip');
        //return;
        helper.helperProceedToPackShip(component, event, helper,event.target.name)
        //helper.helperPopupProceedToPackShip(component, event, helper);
        
    },
    doInit: function (component, event, helper) {
        var action = component.get("c.allocation");
        action.setParams({
            'isAllocationInPicking':component.get('v.isAllocationInPicking'),
        });  
        action.setCallback(this, function(response) {
            var state = response.getState();
            // alert(state);
            if (state === "SUCCESS") 
            {
                var data = response.getReturnValue();
                if(data!=null)
                {
                    //	alert("v.isAllocationInPicking"+response.getReturnValue());
                    component.set('v.isAllocationInPicking',response.getReturnValue()); 
                }
                else
                {
                    //	alert("somethimng went wrong");
                    
                }
                
                
            }
            else{
                //alert(response.getError());
                //  var spinner=component.find('spinner');
                //  $A.util.toggleClass(spinner, 'slds-hide');
            }
        });
        $A.enqueueAction(action);        
        if(component.get('v.isPicking')){
            
            if($A.get("$Browser.formFactor") !== "DESKTOP")
                component.set('v.mobileScreenFlag',true);
            // var spinner=component.find('spinner');
            //$A.util.toggleClass(spinner, 'slds-hide');
            helper.getSOData(component, event, helper,null,null);
        }
        
    },
    allocateUser: function (component, event, helper) {
       // alert('allocateUser');
        //return;
      //  alert('target.name::'+ event.target.name);
        helper.helperAllocateUser(component, event, helper,event.target.name);
    },
    navigateToPicking: function (component, event, helper) {
        
        var isAllocationInPicking=component.get("v.isAllocationInPicking");
        if(isAllocationInPicking==false)
        {
          //  alert('navigate to picking>>');
            helper.getPickingDataHelper(component, event, helper,event.target.name);
        }
        else
        {
            var allocatedAs=component.get("v.allocatedAs"); 
            var so=component.get("v.standOrderData")[event.target.name].standOrder.isSelected;
          //  alert("so::"+JSON.stringify(so));
            if(so==true && ( allocatedAs== "AutoPick" || allocatedAs== "ManualPick" ))
            {
              //  alert('inside allocation in picking');
                component.set("v.isError",false);
                helper.getPickingDataHelper(component, event, helper,event.target.name);
            }
            else
            {
                component.set("v.errorMsg","please select check box!!!!!!!!!!!!!!!!!!!  and make inventory allocation");
                
                component.set("v.isError",true);
                //alert('please select check box!!!!!!!!!!!!!!!!!!!  and make inventory allocation');
                return;
            }
            
        }
        
        
        
    },
    
    fetchOrders:function (component, event, helper) {
        // alert(event.getSource().get('v.id'));
        //var spinner=component.find('spinner');
        //$A.util.toggleClass(spinner, 'slds-hide');
        //alert(component.find('tabs').get('v.selectedTabId'));
        component.set('v.selectedTab',(component.find('tabs').get('v.selectedTabId')));
       if(component.find('tabs').get('v.selectedTabId')==='Picked')
        {
            component.set('v.isPickedTab',true);
            
        }
        else
        {
            component.set('v.isPickedTab',false);
            
        }
         if(component.find('tabs').get('v.selectedTabId')==='PickingInProgress')
        {
            component.set('v.isPickingInProgressTab',true);
            
        }
        else
        {
            component.set('v.isPickingInProgressTab',false);
            
        }
        helper.getSOData(component, event, helper,null,null);
    },
    soClearEvent: function (component, event, helper) {
        //alert('soClearEvent is called ');
        // alert(component.get('v.soID'));
        if(!component.get('v.soID')){
            //    alert('soClearEvent is called insidwe if ');
            //  var spinner=component.find('spinner');
            //   $A.util.toggleClass(spinner, 'slds-hide');
            helper.getSOData(component, event, helper,null,null);
        }
        else
        {
            //  var spinner=component.find('spinner');
            // $A.util.toggleClass(spinner, 'slds-hide');
            helper.getSOData(component, event, helper,null,'desc');
        }
    },
    reInit:function (component, event, helper){
        // var spinner=component.find('spinner');
        // $A.util.toggleClass(spinner, 'slds-hide');
        //alert(component.find('tabs').get('v.selectedTabId'));
        component.set('v.selectedTab',(component.find('tabs').get('v.selectedTabId')));
        helper.getSOData(component, event, helper,null,null);
    },
    printPDF:function (component, event, helper) {
      //  alert('PrintPDF');
        var standOrderData=component.get('v.standOrderData');
        var selectedSoIdList=[];
        console.log('standOrderData>>'+JSON.stringify(standOrderData));
         console.log(''+JSON.stringify(standOrderData));
        for(var i=0;i<standOrderData.length;i++)
        {
            if(standOrderData[i].standOrder.isSelected)
            {
                if(!standOrderData[i].standOrder.sigmaerpdev2__Allocated_User__c){
                        alert('User is Not allocated to pick the selected Order \''+standOrderData[i].standOrder.OrderNumber+'\'');
                 
                    
                   // alert('Picker is not allocated for the Order \''+standOrderData[i].standOrder.Name+'\'');
                    return;
                }
              //  alert(standOrderData[i].standOrder.Id);
                selectedSoIdList.push(standOrderData[i].standOrder.Id);
            }
        }
        if(selectedSoIdList.length>0)
        {
            console.log('standOrderData>>'+JSON.stringify(standOrderData));
            console.log('selectedSoIdList>>'+JSON.stringify(selectedSoIdList));
            
            helper.helperPrintPdf(component, event, helper,selectedSoIdList);
        }
        else
        {
            alert('No  Order is selected Please select order');
        }
    },
    
    refreshView : function(component, event, helper) 
    {
        var spinner = component.find('spinner');
        $A.util.removeClass(spinner, 'slds-hide');
        
        $A.get("e.force:refreshView").fire();
        
        // var spinner = component.find('spinner');
        $A.util.addClass(spinner, 'slds-hide');
        
    },
    PickPrinted:function (component, event, helper) {
     //   alert('PickPrinted');
        //return;
        helper.helperPickPrinted(component, event, helper,event.target.name)
    },
    altPickForPrinted: function (component, event, helper) {
        //alert('altPickForPrinted');
        //return;
        helper.helperAltPickForPrinted(component, event, helper,event.target.name);
    },
    closeAltPickModel: function (component, event, helper) {
        component.set('v.altPickModelForPrinted',false);
    },
   /* confirmPicking:function (component, event, helper){
       // alert('confirmPicking');
        //return;
        var pickingData=component.get('v.dataForPicking.PickingDuplicateDataWrap');
        var isAltPicked=false;
        for(var i=0;i<pickingData.length;i++)
        {
            if(pickingData[i].hasAltPick)
            {
                isAltPicked=true;
            }
        }
        if(!isAltPicked){
            //alert('Please pick alternate stock');
            return;
        }
        helper.helperconfirmPicking(component, event, helper);
    },*/
    navigateToPicking1: function (component, event, helper) {
        var selChkbox = component.get("v.selChkboxCount");    	
        if(selChkbox > 1){            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"warning",
                "title": "Warning!",
                "message": 'You can select only one Order at a time for Manual/Auto allocation during Picking.'
            });
            toastEvent.fire();	 
            return;
        }
        var standOrderData=component.get('v.standOrderData');
        //  alert("v.allocatedAs"+component.get("v.allocatedAs"));
        // component.set('v.allocatedAs','ManualPick');
        
        //alert(" after"+component.get("v.allocatedAs"));
        var selectedSoIdList=[];
        
        for(var i=0;i<standOrderData.length;i++)
        {
            if(standOrderData[i].standOrder.isSelected)
            {
                if(!standOrderData[i].standOrder.sigmaerpdev2__Allocated_User__c){
                    //   alert('Picker is not allocated for the Order \''+standOrderData[i].standOrder.Name+'\'');
                    return;
                }
                selectedSoIdList.push(standOrderData[i].standOrder.Id);
                var allocatedAs=component.get("v.allocatedAs");
                allocatedAs='ManualPick';
                component.set("v.allocatedAs", allocatedAs);
            }
        }
        //  alert(JSON.stringify(selectedSoIdList));
        
        
   /*     
        var action = component.get("c.getIlpli1");
        action.setParams({
            'soIds':selectedSoIdList,
        });  
        // alert(action);
        action.setCallback(this, function(response) {
            var state = response.getState();
            //  alert(state);
            if (state === "SUCCESS") 
            {
                var data = response.getReturnValue();
                console.log('Data>>>>>'+JSON.stringify(data)); 
                
                //  component.set("v.StandOrderWrap", data);
                component.set("v.standOrderLineWrapper", data);
                
            }*/
			
	var action = component.get("c.getIlpli1");
    action.setParams({
        'soIds':selectedSoIdList,
		});  
		// alert(action);
		action.setCallback(this, function(response) {
			var state = response.getState();
			//  alert(state);
			if (state === "SUCCESS") 
			{
				var data = response.getReturnValue();
				console.log('Data>>>>>'+JSON.stringify(data)); 	
				component.set("v.sigmaOrderLineWrapper", data);
			}
		});
			$A.enqueueAction(action);
			component.set("v.openSelectManual",true);
    },
	closeSelectManualModal:function(component, event, helper){
        component.set("v.openSelectManual",false);//changed false to true by Sarah
    },
    selectedIPPLI:function(component, event, helper){
        // alert("StandOrderWrap"+JSON.stringify(component.get("v.StandOrderWrap")));
        // alert(JSON.stringify(component.get("v.ilpliData")));
        // alert(JSON.stringify(component.get("v.originalILPLIData")));
        var enteredQuant=0;
        var newILPLI=[];
        var ilpliData=component.get("v.originalILPLIData");
        
        // standOrderLineWrapper
        var standOrderLineWrapper=component.get("v.standOrderLineWrapper");
        
        var ilpliIdAllocatedQuantMap=component.get('v.ilpliIdAllocatedQuantMap');
        //  alert('ilpliIdAllocatedQuantMap11'+JSON.stringify(ilpliIdAllocatedQuantMap));
        for(var i=0;i<ilpliData.length;i++){
            if(ilpliData[i].enteredQuant){
                //     alert("1st");
                enteredQuant+=parseInt(ilpliData[i].enteredQuant);
                newILPLI.push(ilpliData[i]);
                if(ilpliIdAllocatedQuantMap[ilpliData[i].Id])
                    ilpliIdAllocatedQuantMap[ilpliData[i].Id]=(ilpliIdAllocatedQuantMap[ilpliData[i].Id]+parseInt(ilpliData[i].enteredQuant));
                else
                    ilpliIdAllocatedQuantMap[ilpliData[i].Id]=parseInt(ilpliData[i].enteredQuant);
            }
        }
        
        var oederlines=[];
        var OrderlineIlplis=[];
        
        
        
        for(var i=0;i<standOrderLineWrapper.length;i++)
        {
            
        }
        var StandOrderWrap=component.get('v.StandOrderWrap');
        // alert(StandOrderWrap.orderLines[0].sigmaerpdev2__Net_Quantity__c);
        //  alert(StandOrderWrap.enteredQuant);
        
        if(StandOrderWrap!=null)
        {
            if(StandOrderWrap.orderitems[0].sigmaerpdev2__Net_Quantity__c!= enteredQuant)
            {
                alert('enter quantity should be equal to order quantity');
                return ;
            }
        }
        component.set('v.ilpliIdAllocatedQuantMap',ilpliIdAllocatedQuantMap);
        // alert("SAVERECORD:"+JSON.stringify(component.get("v.originalILPLIData")));
        //  alert('ilpliIdAllocatedQuantMap33'+JSON.stringify(ilpliIdAllocatedQuantMap));
        
        
        var map1=JSON.stringify(component.get("v.ilpliIdAllocatedQuantMap"));
        if(map1!='{}')
        {
            component.set("v.openSelectManual",false);
            //  return true;
        }
        else
        {
            // component.set("v.openSelectManual",true);
            alert('please enter the values');
            //return false;
            return;
        }
        
    },
    
    expandOrHide : function(component, event, helper) {
        var rowId = component.get("v.prodId");		  
        var selLineItem = document.getElementById('showHide_'+rowId);		           
        var imgId = document.getElementById('changeImage_'+rowId);         
        if(selLineItem.style.display == 'none') {  
            imgId.src= "/resource/sigmaerpdev2__NMinus";            
            imgId.title="Hide Stock";   
            selLineItem.style.display = 'block';            
        }else{             
            imgId.src= "/resource/sigmaerpdev2__NPlus";            
            imgId.title="Show Stock";   
            selLineItem.style.display = 'none';
        }
    },
    
    onCheck : function(component, event, helper){
        var standOrderData = component.get('v.standOrderData');  
        var selectedSoIdList=[];
        var count = 0;	   
        for(var i=0;i<standOrderData.length;i++){          
            if(standOrderData[i].standOrder.isSelected == true){
                count++;        
            }
            if(count == 2)           
                break;
        }                      
        if(count == 2)
            component.set("v.selChkboxCount", count);
        else
            component.set("v.selChkboxCount", 1);       
    },         
    
    selectedIPPLI2 : function(component, event, helper){
        var myWrap = component.get("v.standOrderLineWrapper");                
        for(var i=0; i<myWrap.length; i++){
            //check whether manual selection is done before saving picking            
            var prodName = myWrap[i].orderLineWrap.Product2.Name;
            var ordQnty = myWrap[i].orderLineWrap.Quantity;            
            var count = 0;            
            for(var j=0;j<myWrap[i].wrapperIlpli.length;j++){                           
                if(myWrap[i].wrapperIlpli[j].EnterQuantity){
                    count = count + parseInt(myWrap[i].wrapperIlpli[j].EnterQuantity);
                }
            }             
            if(count == 0){                                                       
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"warning",
                    "title": "Warning!",
                    "message": "Select Stock for the Product : "+prodName+ " at row "+ parseInt(i+1)
                });
                toastEvent.fire();	
                return;
            }
            //ends here
            //added to validate manual select stock quantity - to check whether its equal to packaged qty or not
            var mismatchQn = false;
            var reason = '';            
            if(parseInt(ordQnty) > count){
                mismatchQn = true;
                reason = 'less than the packaged quantity';
            }else if(count > parseInt(ordQnty)){
                mismatchQn = true;
                reason = 'more than the packaged quantity';
            }
            if(mismatchQn){
             //   var msg = "Selected quantity is "+reason+" for the Product : "+prodName+ " at row : "+ parseInt(i+1);                
                var msg = "Enter quantity Sohould be equal to Order Quantity";             
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"warning",
                    "title": "Warning!",
                    "message": msg,
                    "mode" : "sticky"
                });
                toastEvent.fire();	
                return;
            }
            //ends here
        }//end of for loop
        component.set("v.openSelectManual",false);
        
    }
    
});