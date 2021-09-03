({
    SaveAssignAgentDetails : function(component,event){
       // alert('in helper')
        debugger;
        var slotDetailsMap = component.get("v.slotWODetails");
       // alert(JSON.stringify(slotDetailsMap));
        var actiontoSaveAgentAssign = component.get("c.SaveAssignAgentAssignDetails");
        var CurrentWOId = component.get("v.recordId");
      // alert('RecordID'+CurrentWOId);
        actiontoSaveAgentAssign.setParams({            
            "CurrentWOId":CurrentWOId,
            "slotDetailsMap": slotDetailsMap,
            "eachSlotDuration":component.get("v.eachSlotDuration"),
            "slotIndexHeaders":component.get('v.indexHeaders')
        });
        actiontoSaveAgentAssign.setCallback(this, function(a) {
            var result = a.getReturnValue();
            var state = a.getState();
           // alert('state'+state)
            if(state== "SUCCESS"){
                component.set("v.AssignAgentSuccessMsg",false);
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
                
                $A.get('e.force:refreshView').fire();
            }
            else{
                // console.log("Failed with state: " + state);
                var errors = actiontoSaveAgentAssign.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log("...Error message: .. " +errors[0].message);
                        var showToast = $A.get('e.force:showToast');
                        showToast.setParams({
                            'title' : '',
                            'message' : errors[0].message,
                            'type' : 'Error'
                        });
                        showToast.fire();
                        // component.set("v.isSpinnertoLoad",false);
                        // component.set("v.isFLSAccess",false);
                        return false;
                    }
                } else {
                    //console.log("Unknown error");
                    var showToast = $A.get('e.force:showToast');
                    showToast.setParams({
                        'title' : '',
                        'message' : 'Unable to Process. Please contact your Administrator',
                        'type' : 'Error'
                    });
                    showToast.fire();
                }
            }
            //var dismissActionPanel = $A.get("e.force:closeQuickAction");
            //dismissActionPanel.fire();
        });
        $A.enqueueAction(actiontoSaveAgentAssign); 
        
    },
    
    InitialListOfTechnicians : function(component,event, searchText,startHeader,endHeader){       
        var action = component.get("c.fetchTechnicianList");
      //console.log(component.getJSON.stringify(("v.WorkOrderDetailList")));
       // alert('63>>>>'+searchText);
        component.set('v.startHeader',startHeader);
        component.set('v.endHeader',endHeader);
        
        action.setParams({            
            
            "WorkOrderType": component.get("v.WorkOrderDetailList.sigmaerpdev2__Work_Type__c"),
            "PreferredDateandTime":component.get("v.WorkOrderDetailList.sigmaerpdev2__Customer_Availability_Date__c"),
            "territory":component.get("v.WorkOrderDetailList.sigmaerpdev2__Territory__c"),
            "searchText":searchText,
            "startHeader":startHeader,
            "endHeader":endHeader,
            "tableHeaderDuration":component.get('v.eachSlotDuration')
        });
        action.setCallback(this, function(a) {
            var result = a.getReturnValue();
            //alert('tech>>>line number 79'+JSON.stringify(result)); 
           
            console.log('tech>>>79'+JSON.stringify(result));
            var state = a.getState();
           //alert('stat===='+state);
            if(state== "SUCCESS"){
                var arrayOfMapKeys = [];
               component.set("v.TechnicianList",result);  
                debugger;
                
               
               if(result == null ||   result == '' ){  
                    component.set("v.showLoadingSpinner",false);
                }
                 //Object.keys(result).length <=0 || JSON.stringify(result)=="{}"
                if(Object.keys(result).length <=0 || JSON.stringify(result)=="{}"){
                    //alert('length is 0')
                    component.set("v.showLoadingSpinner",false);
                       component.set("v.showWorkOrderMessage",true);
                       component.set("v.workOrderMessage",'no active service resources/technicians available to assign the work order.Please make resouce as Active to assign work order.');
                    
                }
                
               
                //alert('90>>>'+JSON.stringify(component.get("v.TechnicianList")));
                console.log("TechnicianList :"+JSON.stringify(component.get("v.TechnicianList")));
                //alert('res len==='+result.length);
                for (var singlekey in result) {
                    //alert('inside for 93 line...'+singlekey);
                    arrayOfMapKeys.push(singlekey);
                }
               //arrayOfMapKeys.push('a1e2x000000AByRAAW');
               component.set('v.lstKey', arrayOfMapKeys); 
                for (var singlekey in result) {
                    
                    console.log(JSON.stringify(result[singlekey]));
                }
               //component.set("v.lstKey", "a1e2x000000AByRAAW");  
                //alert('97 assign helper===='+component.get('v.lstKey'));
                
                //alert('line 101');
                //--find the preferre day and set to the attribute -START
                //alert('before....pdate?>>>');
                var prefferedDate=component.get("v.WorkOrderDetailList.sigmaerpdev2__Customer_Availability_Date__c");
                //alert('pdate?>>>'+prefferedDate);
                var d = new Date(prefferedDate);
                
                var timezone = $A.get("$Locale.timezone");               
                var mydate = d.toLocaleString("en-GB", {timeZone: timezone})
                
                var mydateTimeArray = mydate.split(',');
                //alert('112==='+mydateTimeArray[0]);//--dd/mm/yyy
                var mydateValueArray = mydateTimeArray[0].split('/');                
                var prefDate = new Date(mydateValueArray[2],mydateValueArray[1] - 1,mydateValueArray[0]);
                //alert('115==='+prefDate);
                
                var days = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];
                //var dayOfPrefferreddate=days[d.getDay()];
                var dayOfPrefferreddate=days[prefDate.getDay()]; 
                //alert('dayOfPrefferreddate>>'+dayOfPrefferreddate);
                component.set('v.preferredDay', dayOfPrefferreddate); 
                //alert('117>>>'+component.get('v.preferredDay'));
                //--find the preferre day and set to the attribute -END
                
            }
            else{
                // console.log("Failed with state: " + state);
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("...Error message: .. " +errors[0].message);
                        var showToast = $A.get('e.force:showToast');
                        showToast.setParams({
                            'title' : '',
                            'message' : errors[0].message,
                            'type' : 'Error'
                        });
                        showToast.fire();
                        // component.set("v.isSpinnertoLoad",false);
                        // component.set("v.isFLSAccess",false);
                        return false;
                    }
                } else {
                    
                    //console.log("Unknown error");
                    var showToast = $A.get('e.force:showToast');
                    showToast.setParams({
                        'title' : '',
                        'message' : 'Unable to Process. Please contact your Administrator',
                        'type' : 'Error'
                    });
                    showToast.fire();
                }
            }
        });
        $A.enqueueAction(action); 
        
    },
    WorkOrderDetails : function(component,event){
        component.set("v.showLoadingSpinner",true); 
        var actionTogetWorkOrder = component.get("c.WorkOrderDetailsL");	
        var CurrentWOId = component.get("v.recordId");
        //alert('CurrentWOId>>>'+CurrentWOId);
        
        actionTogetWorkOrder.setParams({            
            "CurrentWOId":CurrentWOId,
            "WorkOrderDetailList": component.get("v.WorkOrderDetailList")
        });
        actionTogetWorkOrder.setCallback(this, function(a) {
            var result = a.getReturnValue();
            var state = a.getState();
            //alert('state>>'+state);
            if(state== "SUCCESS"){
                debugger;
                var resultSearch = a.getReturnValue();
                
                
                component.set("v.WorkOrderDetailList", resultSearch);
                //alert('result>>>>>'+JSON.stringify(resultSearch));
                if(resultSearch == null){
                    component.set("v.showLoadingSpinner",false);
                    component.set("v.showWorkOrderMessage",true);
                    component.set("v.workOrderMessage",'Missing Work Type or Territory or Preffered Service Date/Time. Please provide one before assigning a Technician.');
                }
             
                //--COMMENTED THE CODE AS RESSIGNEMENT CONCEPT IS INTRODUCED--START
                //--disable the spinner if the Agent is already assigned for WO
                /*if(resultSearch.Status__c !='Draft' || resultSearch.AssignTo__c!=null){
                     component.set("v.showLoadingSpinner",false);
                }*/
                //--COMMENTED THE CODE AS RESSIGNEMENT CONCEPT IS INTRODUCED--END
                
                //--check whether preferreddate is past date --START
                else{
					component.set("v.showLoadingSpinner",false); //commented on 25-11-2020
                     //component.set("v.showLoadingSpinner",false);
                    if(resultSearch.sigmaerpdev2__Work_Type__r.sigmaerpdev2__Gantt_Chart_Slot_Duration__c == null){
                      //  alert('null');
                        component.set('v.eachSlotDuration',1.0);
                    }
                   
                    else{
                        component.set('v.eachSlotDuration',resultSearch.sigmaerpdev2__Work_Type__r.sigmaerpdev2__Gantt_Chart_Slot_Duration__c);
                       // alert('192>>'+component.get('v.eachSlotDuration'));
                    }
                    var isPast = true;
                    var prefferedDate=component.get("v.WorkOrderDetailList.sigmaerpdev2__Customer_Availability_Date__c");
                   // alert('prefferedDate>>'+prefferedDate);
                    var d = new Date(prefferedDate);    
                    //alert('d..'+d);
                    var timezone = $A.get("$Locale.timezone");               
                    var mydate = d.toLocaleString("en-GB", {timeZone: timezone})                
                    var mydateTimeArray = mydate.split(',');
                    var mydateValueArray = mydateTimeArray[0].split('/');                
                    var prefDate = new Date(mydateValueArray[2],mydateValueArray[1] - 1,mydateValueArray[0]);
                    var today = new Date();
                    today.setHours(0);
                    today.setMinutes(0);
                    today.setSeconds(0);
                    prefDate.setDate(prefDate.getDate() + 1);
                    if(prefDate >= today){
                        isPast = false;
                        //alert('isPast>>'+isPast);
                    }else{
                        isPast = true;
                    }
                    //--check whether preferreddate is past date --END
                    
                    if(resultSearch.sigmaerpdev2__Status__c == 'Accepted'){
                        component.set("v.showLoadingSpinner",false);
                        component.set("v.showWorkOrderMessage",true);
                        component.set("v.workOrderMessage",'The Work Order has been accepted by the assigned technician.');                    
                    }else if(resultSearch.sigmaerpdev2__Status__c == 'Completed'){
                        component.set("v.showLoadingSpinner",false);
                        component.set("v.showWorkOrderMessage",true);
                        component.set("v.workOrderMessage",'The Work Order has been completed by the technician.');
                    }else if(resultSearch.sigmaerpdev2__Status__c == 'Invoiced to Customer'){
                        component.set("v.showLoadingSpinner",false);
                        component.set("v.showWorkOrderMessage",true);
                        component.set("v.workOrderMessage",'The Work Order has been completed and invoiced to the customer.');
                    }else if(resultSearch.sigmaerpdev2__Status__c == 'Assigned'){
                        component.set("v.showLoadingSpinner",false);
                        component.set("v.showWorkOrderMessage",true);
                        component.set("v.workOrderMessage",'The Work Order is already assigned.');
                    }
                    else if(resultSearch.sigmaerpdev2__Status__c == 'Rejected'){
                        component.set("v.showLoadingSpinner",false);
                        component.set("v.showWorkOrderMessage",true);
                        component.set("v.workOrderMessage",'The Work Order is Rejected.');
                    }
                    else if(resultSearch.sigmaerpdev2__Status__c == 'In Progress'){
                        component.set("v.showLoadingSpinner",false);
                        component.set("v.showWorkOrderMessage",true);
                        component.set("v.workOrderMessage",'The Work Order is already In Progress.');
                    }
                        else if(isPast){
                        component.set("v.showLoadingSpinner",false);
                        component.set("v.showWorkOrderMessage",true);
                        component.set("v.workOrderMessage",'The preferred service date should be current or future date.');
                    }else{
                        //alert('another header')
                        //check the Google API key is available, if yes proceed further
                        this.getGoogleAPICustomSetting(component,event);
                        this.getTimeSlotsForHeadersHelper(component,event);
                    }
                   
                }                
            }
            else{
                //console.log("Failed with state: " + state);
                var errors = actionTogetWorkOrder.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log("...Error message: .. " +errors[0].message);
                        var showToast = $A.get('e.force:showToast');
                        showToast.setParams({
                            'title' : '',
                            'message' : errors[0].message,
                            'type' : 'Error'
                        });
                        showToast.fire();
                        //component.set("v.isSpinnertoLoad",false);
                        //component.set("v.isFLSAccess",false);
                        return false;
                    }
                } else {
                    //console.log("Unknown error");
                    var showToast = $A.get('e.force:showToast');
                    showToast.setParams({
                        'title' : '',
                        'message' : 'Unable to Process. Please contact your Administrator',
                        'type' : 'Error'
                    });
                    showToast.fire();
                }
            }
        });
        $A.enqueueAction(actionTogetWorkOrder);
    },
    
    getTimeSlotsForHeadersHelper : function(component,event){
        debugger;
        
      
        var actionTogetWorkOrder = component.get("c.getTimeSlotsForHeader");	
     
        actionTogetWorkOrder.setParams({            
            
            "PreferredDateandTime":component.get("v.WorkOrderDetailList.sigmaerpdev2__Customer_Availability_Date__c"),
            "territory":component.get("v.WorkOrderDetailList.sigmaerpdev2__Territory__c"),
            "tableHeaderDuration":component.get('v.eachSlotDuration')
            
        });
        actionTogetWorkOrder.setCallback(this, function(a) {
            var result = a.getReturnValue();
            var state = a.getState();
           //alert('in'+state);
           //alert('result'+JSON.stringify(result));
            if(result!=null){
            if(state== "SUCCESS"){
               //	alert('inns');
                debugger;
                var resultSearch = a.getReturnValue();
                component.set("v.timeSlotsForHeaders", resultSearch.tableHeaders);
                component.set("v.indexHeaders", resultSearch.indexHeaders);
                //alert(JSON.stringify(resultSearch));
                var headerSlots = component.get("v.timeSlotsForHeaders");
                var startTimeSplit = headerSlots[0].split(':');
                var endTimeSplit =  headerSlots[headerSlots.length - 1].split(':');
                var tempStart;
               
                if(parseInt(startTimeSplit[0])>12){
                    tempStart = (parseInt(startTimeSplit[0]) - 12 );
                    if(parseInt(startTimeSplit[1])>0){
                        tempStart = tempStart +':'+ startTimeSplit[1] + ' PM';
                    }
                    else{
                        tempStart = tempStart + ' PM';
                    }
                }
                else{
                    tempStart = parseInt(startTimeSplit[0]);
                    if(parseInt(startTimeSplit[1])>0){
                        tempStart = tempStart +':'+ startTimeSplit[1] + ' AM';
                    }
                    else{
                        tempStart = tempStart +' AM';
                    }
                }
                component.set("v.startHeaderUI",tempStart);
                
                var tempEnd;
                if(parseInt(endTimeSplit[0])>12){
                    tempEnd = (parseInt(endTimeSplit[0]) - 12 );
                    if(parseInt(endTimeSplit[1])>0){
                        tempEnd = tempEnd +':'+ endTimeSplit[1] + ' PM';
                    }
                    else{
                        tempEnd = tempEnd + ' PM';
                    }
                }
                else{
                    tempEnd = parseInt(endTimeSplit[0]);
                    if(parseInt(endTimeSplit[1])>0){
                        tempEnd = tempEnd +':'+ endTimeSplit[1] + ' AM';
                    }
                    else{
                        tempEnd = tempEnd + ' AM';
                    }
                }
                component.set("v.endHeaderUI",tempEnd);
                this.InitialListOfTechnicians(component,event,'',headerSlots[0],headerSlots[headerSlots.length - 1]);
                
                //alert(JSON.Stringify(resultSearch));    
            }
            
 
          
            else{
                //console.log("Failed with state: " + state);
                var errors = actionTogetWorkOrder.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log("...Error message: .. " +errors[0].message);
                        var showToast = $A.get('e.force:showToast');
                        showToast.setParams({
                            'title' : '',
                            'message' : errors[0].message,
                            'type' : 'Error'
                        });
                        showToast.fire();
                       
                        //component.set("v.isSpinnertoLoad",false);
                        //component.set("v.isFLSAccess",false);
                        return false;
                    }
                 
                } else {
                    //alert('inss');
                    //console.log("Unknown error");
                    var showToast = $A.get('e.force:showToast');
                    showToast.setParams({
                        'title' : '',
                        'message' : 'Unable to Process. Please contact your Administrator',
                        'type' : 'Error'
                    });
                    showToast.fire();
                }
            }
            }
          if(state === "ERROR") {
              if(result==null){    
				component.set("v.showLoadingSpinner",false);
				component.set("v.showWorkOrderMessage",true);
				component.set("v.workOrderMessage",'There is no technician available in this territory.');
           
           }
          }
            
else if(result==null) {
     
         //alert('sss');
             component.set("v.showLoadingSpinner",false);
             component.set("v.showWorkOrderMessage",true);
             component.set("v.workOrderMessage",'There is no Business calendar/Business slots on this day.');
           
}
    

                
        });
        $A.enqueueAction(actionTogetWorkOrder);
    },
    
    getGoogleAPICustomSetting: function(component,event) {
        var googleAPICustomSetting = component.get("c.getGoogleAPICustomSetting");	
        
        googleAPICustomSetting.setParams({
        });
        googleAPICustomSetting.setCallback(this, function(a) {
            var result = a.getReturnValue();
            var state = a.getState();
            if(state== "SUCCESS"){
                
                console.log(result.sigmaerpdev2__API_Key__c);
                if(result.sigmaerpdev2__API_Key__c ==undefined || result.sigmaerpdev2__API_Key__c == null || result.sigmaerpdev2__API_Key__c =='' || result.sigmaerpdev2__API_Key__c =="undefined"){
                    
                    //component.set("v.isGoogleAPIAvailable",true);
                    //component.set("v.showLoadingSpinner",);
                    //component.set("v.showWorkOrderMessage",true);
                    //component.set("v.workOrderMessage",'Please make sure you have provided a valid Google API key.');
                    
                    component.set("v.isGoogleAPIAvailable",true);
                    //component.set("v.showLoadingSpinner",true); //commented on 25-11-2020
                    component.set("v.showWorkOrderMessage",false);
                    this.InitialListOfTechnicians(component,event,'');
                    
                    this.getCustomSetting(component,event);
                    
                }else{
                    component.set("v.isGoogleAPIAvailable",true);
                    //component.set("v.showLoadingSpinner",true); //commented on 25-11-2020
                    component.set("v.showWorkOrderMessage",false);
                    //this.InitialListOfTechnicians(component,event,'');
                    
                    this.getCustomSetting(component,event);
                }
            }
            else{
                component.set("v.isGoogleAPIAvailable",false);
                component.set("v.showLoadingSpinner",false);
                component.set("v.showWorkOrderMessage",true);
                component.set("v.workOrderMessage",'Please make sure you have provided a valid Google API key.');
            }
        });
        $A.enqueueAction(googleAPICustomSetting);
    },
    
    getCustomSetting: function(component,event) {
        var agentAssignmentCustomSetting = component.get("c.getAgentAssignmentCustomSetting");	
        
        agentAssignmentCustomSetting.setParams({
        });
        agentAssignmentCustomSetting.setCallback(this, function(a) {
            var result = a.getReturnValue();
            var state = a.getState();
            if(state== "SUCCESS"){
                var customSettingDetails = new Object()
                if(result!=null){
                    if(result.sigmaerpdev2__Maximum_Threshold_Travel_Time__c == null){
                        customSettingDetails['minTravelTime'] = 15;
                    }
                    else{
                        customSettingDetails['minTravelTime'] = result.sigmaerpdev2__Maximum_Threshold_Travel_Time__c;
                    }
                    if(result.sigmaerpdev2__Hover_Duration__c == null){
                        component.set("v.hoverDuration",2500);
                    }
                    else{
                        component.set("v.hoverDuration",result.sigmaerpdev2__Hover_Duration__c);
                    }
                    
                    component.set("v.customSettingDetails", customSettingDetails);
                }
            }
            else{
                var customSettingDetails = new Object()
                customSettingDetails['minTravelTime'] = 15;
                component.set("v.hoverDuration",2500);
                component.set("v.customSettingDetails", customSettingDetails);
            }
        });
        $A.enqueueAction(agentAssignmentCustomSetting);
    },
    getSearchTechnician : function(component,event) {
        var actionTogetSearchTechnician = component.get("c.getTechnicianName");	
        var searchTextId =component.find("searchTechnician");
        var searchText=searchTextId.getElement().value;
        component.set("v.SearchTextVal",searchText);
        actionTogetSearchTechnician.setParams({
            
            "searchText":searchText,
            "TechnicianList": component.get("v.TechnicianList")
        });
        actionTogetSearchTechnician.setCallback(this, function(a) {
            var result = a.getReturnValue();
            var state = a.getState();
            if(state== "SUCCESS"){
                var resultSearch = a.getReturnValue();
                component.set("v.TechnicianList", resultSearch);
            }
            else{
                //console.log("Failed with state: " + state);
                var errors = actionTogetSearchTechnician.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //console.log("...Error message: .. " +errors[0].message);
                        var showToast = $A.get('e.force:showToast');
                        showToast.setParams({
                            'title' : '',
                            'message' : errors[0].message,
                            'type' : 'Error'
                        });
                        showToast.fire();
                        //component.set("v.isSpinnertoLoad",false);
                        //component.set("v.isFLSAccess",false);
                        return false;
                    }
                } else {
                    //console.log("Unknown error");
                    var showToast = $A.get('e.force:showToast');
                    showToast.setParams({
                        'title' : '',
                        'message' : 'Unable to Process. Please contact your Administrator',
                        'type' : 'Error'
                    });
                    showToast.fire();
                }
            }
            
        });
        $A.enqueueAction(actionTogetSearchTechnician);
    }
})