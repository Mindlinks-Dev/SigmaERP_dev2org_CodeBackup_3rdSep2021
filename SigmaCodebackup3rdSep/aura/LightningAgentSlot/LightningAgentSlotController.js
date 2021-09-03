({
    doInit: function(component, event, helper) {
        
        
        debugger;
        var topicName = component.get('v.ListOfKeys');
        var eachSlotDuration = parseFloat(component.get("v.eachSlotDuration"));
        var startHeader = parseInt(component.get('v.startHeader'));
        var endHeader = parseInt(component.get('v.endHeader'));
        var slotMap = component.get('v.slotMap');      
        var listOfHeadersHour = component.get('v.indexHeaders');
        var key = component.get("v.slotKey");       
        var slotDurationMap = component.get('v.slotDurationMap1');
        var zipcode=component.get('v.serviceZipCode');
        //alert('serviceZipcode>>>'+component.get('v.serviceZipCode'));
        component.set('v.zippostalcode', zipcode);
        //alert('zipcode>>>'+component.get('v.zippostalcode'));
        var conatct=component.get('v.PresentWOContact');
        // alert('contact>>>'+component.get('v.PresentWOContact'));
        component.set('v.WOContact', conatct);
        
        
        
        var slotDistance = '';
        var distance = '0';
        
        component.set("v.showLoadingSpinner", true);
        
        //alert("slotDurationMap"+JSON.stringify(slotDurationMap));
        if(slotDurationMap != undefined){
            if(key in slotDurationMap){
                
                slotDistance = slotDurationMap[key];
                var slotValueZipArray = slotDistance.split('##');
                var startZipCode = slotValueZipArray[0];
                var endZipCode = slotValueZipArray[1];
                
                //var slotValue1 = slotMap[key];
                //var slotValueArray1 = slotValue1.split('#');
                var slotValue = slotMap[key];
                // alert('slotValue'+slotValue);
                var slotValueArray = slotValue.split('#');
                // alert('slotValueArray---1>>'+slotValueArray);
                if(slotValueArray[0] == "Lunch" || slotValueArray[0] == "NW"){
                    //distance = response.getReturnValue();
                    component.set('v.travelDuration', distance);  
                    
                    helper.setSlotDetails(component,event,slotValueArray);                }
                else{
                    //debugger;
                    var workOrderDetails = slotValueArray[1];
                    var workOrderDetailsArray = workOrderDetails.split("@@");
                    //alert('workOrderDetailsArray---1>>'+workOrderDetailsArray[2]);
                    
                    var workOrderServiceZip = workOrderDetailsArray[0];
                    var workOrderContact = workOrderDetailsArray[1];
                    // alert('workOrderContact---1>>'+workOrderContact);
                    if(workOrderServiceZip != undefined && workOrderServiceZip!="undefined"){
                        component.set('v.workOrderZip', workOrderDetailsArray[1]);
                    }
                    if(workOrderContact != undefined && workOrderContact != "undefined"){
                        // alert('workOrderContact---2>>'+v.workOrderContact);
                        component.set('v.workOrderContact', workOrderDetailsArray[1]);
                        //  alert('workOrderContact---55>>'+component.get('v.workOrderContact'));
                        
                    }                    
                    if(workOrderDetailsArray[2] != undefined && workOrderDetailsArray[2] !="undefined"){
                        component.set('v.workOrderName', workOrderDetailsArray[1]);                        
                    }
                    if(workOrderDetailsArray[3] != undefined && workOrderDetailsArray[3] !="undefined"){
                        component.set('v.workOrderId', workOrderDetailsArray[3]);                        
                    }
                    //--if origin and destination Zip is different calculate hte distance using Google API
                    /*if(startZipCode!=endZipCode){
                        
                        component.set("v.showLoadingSpinner", true);
                        component.set("v.showLoadingSpinnerFlag", true);
                        
                        var action = component.get("c.getDistance");
                        action.setParams({
                            "startPincode":startZipCode,
                            "endPincode":endZipCode
                        });
                        action.setCallback(this,function(response){
                            var state = response.getState();
                            if(state== "SUCCESS"){
                                
                                component.set("v.showLoadingSpinner", false);
                                
                                distance = response.getReturnValue();
                                var duration = helper.calculateTravelTime(component, event, distance);
                                component.set('v.travelDuration', duration); 
                                
                                
                                helper.setSlotDetails(component,event,slotValueArray);
                            }
                        });
                        $A.enqueueAction(action);        
                    }else{
                        component.set('v.travelDuration', distance); 
                        helper.setSlotDetails(component,event,slotValueArray);                   
                    }*/
                    //component.set("v.showLoadingSpinner", false);
                    component.set('v.travelDuration', distance); 
                    helper.setSlotDetails(component,event,slotValueArray);   
                }
                if(parseFloat(listOfHeadersHour[key]) == endHeader){
                    if(!component.get("v.showLoadingSpinnerFlag")){
                        component.set("v.showLoadingSpinner", false);
                    }
                }
            }
            
        }       
        //alert('eee'+component.get('v.workOrderContact'));
    },
    
    deleteTimeOut : function(component, event, helper) {
        var hoverDuration = parseInt(component.get('v.hoverDuration')) + 1000;
        console.log('mouse out');
        component.set("v.timeOut",0);
        console.log(parseInt(component.get("v.timeOut"))+'-mouseout before setTime');
        window.setTimeout(
            $A.getCallback(function() {
                component.set("v.timeOut",3);
                console.log(parseInt(component.get("v.timeOut"))+'-mouseout inside SetTine');
                
            }), hoverDuration
        );
        console.log(parseInt(component.get("v.timeOut"))+'-mouseout');
    },
    
    
    getDistanceFromGoogleAPI : function(component, event, helper) {
        //debugger;
        var topicName = component.get('v.ListOfKeys');
        var eachSlotDuration = parseFloat(component.get("v.eachSlotDuration"));
        var startHeader = parseInt(component.get('v.startHeader'));
        var endHeader = parseInt(component.get('v.endHeader'));
        var slotMap = component.get('v.slotMap');      
        var listOfHeadersHour = component.get('v.indexHeaders');
        var key = component.get("v.slotKey");       
        var slotDurationMap = component.get('v.slotDurationMap1');
        var distanceExists = parseInt(component.get('v.travelDuration'));
        var hoverDuration = parseInt(component.get('v.hoverDuration'));
        console.log(parseInt(component.get("v.timeOut"))+'- before ');
        //component.set('v.isAPILoaded',true);
        if(!component.get('v.isAPILoaded')){
            console.log(component.get('v.isAPILoaded')+' Inside IF');
            window.setTimeout(
                $A.getCallback(function() {
                    console.log(parseInt(component.get("v.timeOut"))+'- before If Condition');
                    if(parseInt(component.get("v.timeOut"))){
                        console.log(parseInt(component.get("v.timeOut")) + ' Time Out');
                        var slotDistance = '';
                        var distance = '0';
                        
                        //component.set("v.showLoadingSpinner", true);
                        
                        //alert("slotDurationMap"+JSON.stringify(slotDurationMap));
                        if(slotDurationMap != undefined){
                            if(key in slotDurationMap){
                                
                                slotDistance = slotDurationMap[key];
                                var slotValueZipArray = slotDistance.split('##');
                                var startZipCode = slotValueZipArray[0];
                                //var startZipCode = 522261;
                                var endZipCode = slotValueZipArray[1];
                               // alert('startZipCode>>'+startZipCode)
                                //alert('endZipCode>>'+endZipCode)
                                //var slotValue1 = slotMap[key];
                                //var slotValueArray1 = slotValue1.split('#');
                                var slotValue = slotMap[key];
                                var slotValueArray = slotValue.split('#');
                                
                                if(slotValueArray[0] == "Lunch" || slotValueArray[0] == "NW"){
                                    // distance = response.getReturnValue();
                                    component.set('v.travelDuration', distance);  
                                    
                                    helper.setSlotDetails(component,event,slotValueArray);                }
                                else{
                                    //debugger;
                                    /*var workOrderDetails = slotValueArray[1];
                    var workOrderDetailsArray = workOrderDetails.split("@@");
                    
                    var workOrderServiceZip = workOrderDetailsArray[0];
                    var workOrderContact = workOrderDetailsArray[1];
                    if(workOrderServiceZip != undefined && workOrderServiceZip!="undefined"){
                        component.set('v.workOrderZip', workOrderDetailsArray[0]);
                    }
                    if(workOrderContact != undefined && workOrderContact != "undefined"){
                        component.set('v.workOrderContact', workOrderDetailsArray[1]);
                    }                    
                    if(workOrderDetailsArray[2] != undefined && workOrderDetailsArray[2] !="undefined"){
                        component.set('v.workOrderName', workOrderDetailsArray[2]);                        
                    }
                    if(workOrderDetailsArray[3] != undefined && workOrderDetailsArray[3] !="undefined"){
                        component.set('v.workOrderId', workOrderDetailsArray[3]);                        
                    }*/
                                    //--if origin and destination Zip is different calculate hte distance using Google API
                                    if(startZipCode!=endZipCode && slotValueZipArray.length!=3){
                                        
                                        //component.set("v.showLoadingSpinner", true);
                                        //component.set("v.showLoadingSpinnerFlag", true);
                                        
                                        var action = component.get("c.getDistance");
                                        action.setParams({
                                            "startPincode":startZipCode,
                                            "endPincode":endZipCode
                                        });
                                        console.log('Calling API');
                                        action.setCallback(this,function(response){
                                            var state = response.getState();
                                            
                                            if(state== "SUCCESS"){
                                              //  alert('state>>>'+state)
                                                //component.set("v.showLoadingSpinner", false);
                                                
                                                distance = response.getReturnValue();
                                                //alert('distance'+distance);
                                                var duration = helper.calculateTravelTime(component, event, distance);
                                                component.set('v.travelDuration', duration);
                                                component.set('v.isAPILoaded',true);
                                                console.log('APILoaded '+component.get('v.isAPILoaded'));
                                                slotDurationMap[key] = slotDurationMap[key] +"##"+ component.get('v.travelDuration');
                                                
                                                component.set('v.slotDurationMap1',slotDurationMap);
                                                helper.setSlotDetails(component,event,slotValueArray);
                                                
                                            }
                                        });
                                        $A.enqueueAction(action);      
                                    }else{
                                        if(slotValueZipArray.length!=3){
                                            component.set('v.travelDuration', distance);
                                        }
                                        else{
                                            component.set('v.travelDuration', slotValueZipArray[2]);
                                            component.set('v.isAPILoaded',true);
                                        }
                                        
                                        helper.setSlotDetails(component,event,slotValueArray);                   
                                    }
                                    
                                }
                                /*if(parseFloat(listOfHeadersHour[key]) == endHeader){
                    if(!component.get("v.showLoadingSpinnerFlag")){
                        component.set("v.showLoadingSpinner", false);
                    }                    
                }*/
                            }
                        }     
                    }
                    else{
                        console.log('less hovering time');
                    }
                }), hoverDuration
            );
        }
        else{
            component.set('v.isAPILoaded',true);
            
        }
        
        
    },
    
    SelectAvailableTime: function(component, event, helper){
        debugger;
        //alert(component.get('v.slotBusy'));
        var selectedTd = '';
        var techbusy = '';
        var notBusyCount = 0;
        var count = 0;
        var selectedItem = event.currentTarget;               
        var selectedId = selectedItem.dataset.record;
        var eachSlotDuration = parseFloat(component.get("v.eachSlotDuration"));
        var startHeader = parseInt(component.get('v.startHeader'));
        var endHeader = parseInt(component.get('v.endHeader'));
        
        //--holds the details to create WOA on assignment
        var WOADetailMap=component.get("v.WOADetails");
        //alert(JSON.stringify(WOADetailMap));
        
        //--holds the selected slot 
        var key = component.get("v.slotKey");
        
        //var toastEvent = $A.get("e.force:showToast");
        
        //time availability check - START
        var availablePreferredTime = false;
        //--get the current WO preferred date time
        var prefferedDate = WOADetailMap['preferredDateTime']
        var d = new Date(prefferedDate);                
        var timezone = $A.get("$Locale.timezone");
        var mydate = d.toLocaleString("en-GB", {timeZone: timezone});
        
        var dateTime =d.toLocaleString("en-US", {timeZone: timezone});
        var dateTimeArray = dateTime.split(" ");
        
        var mydateArray = mydate.split(',');      
        //--get the current WO preferred Time(Hour)
        var timeArray = mydateArray[1].split(':');        
        
        //--check whether the preferred time is greater then or equal to selected time/slot --OLD code
        //if(key >= timeArray[0]){ --OLD code
        //--check whether the preferred time is greater then or equal to selected time/slot
        //
        /*if(eachSlotDuration == 1.0){
            var listOfHeadersHour = ['0.0','1.0','2.0','3.0','4.0','5.0','6.0','7.0','8.0','9.0','10.0','11.0','12.0','13.0','14.0','15.0','16.0','17.0','18.0','19.0','20.0','21.0','22.0','23.0','24.0'];
        }
        else if(eachSlotDuration == 0.5){
            var listOfHeadersHour = ['0.0','0.5','1.0','1.5','2.0','2.5','3.0','3.5','4.0','4.5','5.0','5.5','6.0','6.5','7.0','7.5','8.0','8.5','9.0','9.5','10.0','10.5','11.0','11.5','12.0','12.5','13.0','13.5','14.0','14.5','15.0','15.5','16.0','16.5','17.0','17.5','18.0','18.5','19.0','19.5','20.0','20.5','21.0','21.5','22.0','22.5','23.0','23.5','24.0'];
            startHeader = startHeader *2;
            endHeader = endHeader*2;
        }*/
        
        var listOfHeadersHour = component.get('v.indexHeaders');  
        
        if(listOfHeadersHour[key] == parseInt(timeArray[0]) + (timeArray[1]/60)){
            availablePreferredTime = true;
        }
        //time availability check - END
        
        if(availablePreferredTime){
            //--Duration availability check -START
            var WODuration = WOADetailMap['Duration'];
            
            //var slotAssigned = "";
            var slotAssigned = WOADetailMap['contactId'];
            var available = true;
            var isReAssign = false;
            if(WODuration >= 1){
                var slotMap = component.get('v.slotMap'); 
                var slotKey = key;
                
                while(slotKey < (key + WODuration)){
                    
                    //--if slot is more than 20 make unavailable
                    if(slotKey > (listOfHeadersHour.length)-1){
                        available = false;
                        break;
                    }
                    var slotValue = slotMap[slotKey];
                    var slotValueArray = slotValue.split('#');
                    
                    //--if the slot is already allocated
                    if(slotValueArray[0] == "true")
                    {
                        available = false;
                        //--check whether the allocated Work Order is the Current one
                        var WODetailMap=component.get("v.WOADetails");
                        var workOrderId = component.get("v.workOrderId");
                        if(WODetailMap['workOrderId'] == workOrderId){
                            //available=true;
                            isReAssign =true;
                        }
                        break;
                    }
                    //--if Lunch or NW comes check further slots
                    else if(slotValueArray[0] == "Lunch" || slotValueArray[0] == "NW"){
                        WODuration+=1;
                    }else{
                        slotAssigned = slotAssigned + ","+slotKey;
                    }
                    slotKey +=1;               
                }
            }
            //--Duration availability check -END
            //debugger;
            //--check the travel time - START
            if(available){                
                
                var toDuration = component.get("v.travelDuration");
                var fromDuration=0;
                
                var availableSlotInBetween =0;
                //--calculate toNext
                var key = component.get("v.slotKey");
                var WODurationValue = WOADetailMap['Duration'];
                var slotKeyValue = key + WODurationValue;
                var allocatedSlotZip ='';
                
                //--if this is the first WO assigned/ no WO assigned before get the free slots available before the current WO
                var indexSlotValue = 0;
                var initialTimeAvailable = 0;
                var booleancheckforhometoslot8 =true;
                //--check whether any slots prior to the selected slot is allocated/free
                while(indexSlotValue < key){
                    
                    //--get the slot details to get information whether allocated or free
                    var slotMap = component.get('v.slotMap');  
                    var slotValue = slotMap[indexSlotValue];
                    if(slotValue!=undefined){
                        var slotValueArray = slotValue.split('#');                        
                        //-- add the free slots available before to check with travel time
                        if(slotValueArray[0] == "false"){
                            initialTimeAvailable = initialTimeAvailable + 1;
                            
                        }//--if the slot is already allocated make available slot as 0
                        else if(slotValueArray[0] == "true")
                        {
                            booleancheckforhometoslot8=false;
                            initialTimeAvailable = 0; 
                        }
                        //--increment the variable to check each slots till currently selected slot
                        indexSlotValue = indexSlotValue+1;
                    }                    
                }
                // alert(initialTimeAvailable);
                
                //--check whether free slots available in between the current WO and next WO if any--START
                while(slotKeyValue <= (listOfHeadersHour.length)-1){
                    //alert(slotKeyValue);
                    var slotMap = component.get('v.slotMap');  
                    var slotValue = slotMap[slotKeyValue];
                    if(slotValue!=undefined){
                        var slotValueArray = slotValue.split('#');
                        //--if the slot is already allocated
                        if(slotValueArray[0] == "true")
                        {
                            var slotZipMap = component.get('v.slotDurationMap1');   
                            allocatedSlotZip = slotZipMap[slotKeyValue];                   
                            break;
                        }
                        //-- add the slots available between to check with travel time
                        else if(slotValueArray[0] == "false" || slotValueArray[0] == "NW"){
                            if(!(slotValueArray[0] == "NW")){
                                availableSlotInBetween = availableSlotInBetween + 1;
                            }                            
                            if(slotKeyValue==(listOfHeadersHour.lenght)-1){
                                availableSlotInBetween = 0;
                            }
                        }
                        slotKeyValue+=1;
                    }  
                    //alert('availableSlotInBetween'+availableSlotInBetween);
                }   
                //--check whether free slots available in between the current WO and next WO if any--END
                //debugger;
                //--get the distance to next WO if any --START
                if(allocatedSlotZip != null && allocatedSlotZip != ''){                    
                    
                    if(allocatedSlotZip!=undefined){
                        var allocatedSlotZipArray = allocatedSlotZip.split('##');  
                        
                        var action = component.get("c.getDistance");
                        action.setParams({
                            "startPincode":allocatedSlotZipArray[0],
                            "endPincode":allocatedSlotZipArray[1]
                        });
                        action.setCallback(this,function(response){
                            var state = response.getState();
                            if(state== "SUCCESS"){
                                var distance = response.getReturnValue();                                    
                                fromDuration = helper.calculateTravelTime(component, event, distance);                                    
                                //--get the distance to next WO if any --END
                                
                                helper.slotAllocation(component, event, initialTimeAvailable, toDuration,fromDuration,availableSlotInBetween,slotAssigned,booleancheckforhometoslot8);
                                
                                
                                
                            }
                        });
                        $A.enqueueAction(action);     
                        //}
                    }
                }  
                
                
                else{
                    //alert("else");
                    helper.slotAllocation(component, event, initialTimeAvailable, toDuration,fromDuration,availableSlotInBetween,slotAssigned,booleancheckforhometoslot8);
                }
            }else{
                if(isReAssign){
                    //alert("Not Available");               
                    component.set("v.showMessage",true);
                    component.set("v.message","This Work Order has already been assigned to this technician.");
                }else{
                    //alert("Not Available");               
                    component.set("v.showMessage",true);
                    //component.set("v.message","Technician cannot complete the Work Order on the preferred service time because of insufficient working hours left for the day.");
                    component.set("v.message","Technician cannot complete the Work Order because of insufficient working hours left in the day.");
                }
            }
            //--check the travel time - END            
        }else{
            //alert("Not Available.");  
            component.set("v.showMessage",true);
            component.set("v.message","Preferred service time for the Work Order is "+dateTimeArray[1]+" "+dateTimeArray[2]+".");
        }
       
        
        
    },
    
    /*
     * this will change the css of the slots on assignment/on click of slots
     * */
    agentSlotAssignmentChange :function(component,event,helper){        
        
        //--holds the WOA details 
        var WOADetailMap=component.get("v.WOADetails");
        
        //--current slot user has selected
        var selectedId = component.get("v.slotKey");
        
        //--holds the allocated slot and corresponding contact/technician Id
        var allocatedSlot = component.get("v.allocatedSlot"); 
        //alert('allocatedSlot'+component.get("v.allocatedSlot"));
        var allocatedSlotArray = allocatedSlot.split(',');
        
        //--only for allocated slot apply green css else normal css
        //if(allocatedSlot.includes(selectedId)){
        if(WOADetailMap['contactId'] == allocatedSlotArray[0] && allocatedSlotArray.includes(selectedId.toString())){
            
            var selectedTd1 = component.find('Time-8');
            $A.util.addClass(selectedTd1, 'SelectForAssign');    
        }else{
            var selectedTd1 = component.find('Time-8');
            $A.util.removeClass(selectedTd1, 'SelectForAssign');    
        }
    },
    showError:function(component,event,helper){
        
            component.set("v.showMessage",true);
            component.set("v.message","This Slot is already assigned ");
        
    }
})