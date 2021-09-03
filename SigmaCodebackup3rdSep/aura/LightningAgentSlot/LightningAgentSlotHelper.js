({
    setSlotDetails : function(component, event,slotValueArray) {
        //debugger;
        
        var slotBusy = true;        
        
        var slotBreak=true;
        //debugger;
        var isSameWorkOrder = true;
        if(slotValueArray[0] == "true"){
            var WODetailMap=component.get("v.WOADetails");
            var workOrderId = component.get("v.workOrderId");
            if(WODetailMap['workOrderId'] == workOrderId){
                var selectedTd1 = component.find('Time-8');
                $A.util.addClass(selectedTd1, 'SelectForAssign');  
                slotBusy = false;
                isSameWorkOrder = true;
            }else{
                slotBusy = true;
                isSameWorkOrder = false;
            }           
            slotBreak = false;
        }else if(slotValueArray[0] == "Lunch"){
            
            slotBreak = true;
            slotBusy = false;
            isSameWorkOrder = false;
            component.set("v.BreakValue","Lunch");
        } else if(slotValueArray[0] == "NW"){
            slotBreak = true;
            slotBusy = false;
            isSameWorkOrder = false;
            component.set("v.BreakValue","NW");
        }
            else{
                slotBusy = false;
                slotBreak = false; 
                isSameWorkOrder = false;
            }
        
        component.set('v.Breakslot', slotBreak);
        component.set('v.slotBusy', slotBusy);
        component.set('v.isSameWorkOrder', isSameWorkOrder);
        
        
    },
    
    /*
     * calculate the travel time based on the contact Speed
     * */
    calculateTravelTime: function(component, event, distance){
        
        //--get contact speed
        var contactSpeedValue = component.get('v.contactSpeed'); 
        //alert(component.get('v.contactSpeed'));
        //calculate the travel time
        if(contactSpeedValue!=0){
            var distanceArray = distance.split(" ");  
           // alert('distanceArray'+distanceArray);
            var dis = distanceArray[0];
            dis = parseFloat(dis.replace(/,/g, ''));
            contactSpeedValue = parseFloat(contactSpeedValue.replace(/,/g, ''));
            var time = dis/contactSpeedValue;            
            time = time*60;
            time = time.toFixed(0); 
           // alert('dis'+dis);
           // alert('time'+time);
            return time;
        }
    },
    
    slotAllocation :function(component, event,  initialTimeAvailable, toDuration,fromDuration,availableSlotInBetween,slotAssigned,booleancheckforhometoslot8){
        //debugger;
        var WOADetailMap=component.get("v.WOADetails");
        var defaultMinTravelTime = 15;
        var customSettingDetails = component.get('v.customSettingDetails');
        if(customSettingDetails != undefined){
            console.log(">>>>>>>>>>>>/??"+customSettingDetails['minTravelTime']);
            if(customSettingDetails['minTravelTime'] != undefined){
                defaultMinTravelTime = parseInt(customSettingDetails['minTravelTime']);
            }
            //alert(defaultMinTravelTime);
        }                
        var mintravelTime = (initialTimeAvailable *60) + defaultMinTravelTime;
        
        //--holds the total travel time
        var totalTravelTime = parseInt(toDuration) + parseInt(fromDuration);
        if(isNaN(totalTravelTime)){
            totalTravelTime = 0;
        }
        
        //--holds the available time in minitues
        //var availableSlotInBetweenInMin = (availableSlotInBetween *60) + mintravelTime;
        var availableSlotInBetweenInMin = (availableSlotInBetween *60) + defaultMinTravelTime;
        if(booleancheckforhometoslot8==false){
           
            //--in case the toduration is more than 30 mins --added newly
            if(parseInt(toDuration) > mintravelTime){
                component.set("v.showMessage",true);
                component.set("v.message","Technician cannot reach the Work Order service location on time.");     
            }
            
            else if(availableSlotInBetween == 0){
                
                //--in case the toduration is more than 30 mins
                if(parseInt(toDuration) > mintravelTime){
                    component.set("v.showMessage",true);
                    component.set("v.message","Technician cannot reach the Work Order service location on time.");     
                }
                //--in case total duration (to and from) is more than 30 mins
                else if(parseInt(fromDuration) > defaultMinTravelTime){
                    //alert("Cannot Allocate as travel time is more");    
                    component.set("v.showMessage",true);
                    component.set("v.message","Technician cannot reach the subsequent Work Order on its preferred service time."); 
                }                     
                
                //--if travel time is less that minimum time in case no free slot in between allow to assign the agent
                    else if(totalTravelTime < mintravelTime){
                        
                        component.set("v.allocatedSlot",slotAssigned);
                        //--build global map which hild contactId, WOId, duration,start slot
                        var slotAllocationDetailsMap = new Object();
                        slotAllocationDetailsMap['contactId']= WOADetailMap['contactId'];
                        slotAllocationDetailsMap['WOId']= WOADetailMap['workOrderId'];
                        slotAllocationDetailsMap['Duration']= WOADetailMap['Duration'];
                        slotAllocationDetailsMap['slots']= slotAssigned;
                        component.set("v.slotWODetails",slotAllocationDetailsMap);
                        
                        var recordidtodelete=component.getEvent('slotDetails');
                        recordidtodelete.setParams({
                            "slotDetails":slotAllocationDetailsMap
                        });
                        recordidtodelete.fire();
                        
                    }else{
                        //--in case the toduration is more than 30 mins
                        if(parseInt(toDuration) > mintravelTime){
                            component.set("v.showMessage",true);
                            component.set("v.message","Technician cannot reach the Work Order service location on time.");     
                        }
                        //--in case total duration (to and from) is more than 30 mins
                        else{
                            //alert("Cannot Allocate as travel time is more");    
                            component.set("v.showMessage",true);
                            component.set("v.message","Technician cannot reach the subsequent Work Order on its preferred service time.");                                 
                        }                                           
                    }
            }
            
            //--in case total duration (to and from) is more than available free time +30 mins
            else if(availableSlotInBetweenInMin < parseInt(fromDuration)){
                //alert("Cannot Allocate as travel time is more");                   
                component.set("v.showMessage",true);
                component.set("v.message","Technician cannot reach the subsequent Work Order on its preferred service time.");
            }  
           
            //--check if travel time is less that minimum time including free slot in between allow to assign Agent
                else if(availableSlotInBetweenInMin >= totalTravelTime){
                    
                    component.set("v.allocatedSlot",slotAssigned);
                    //--build global map which hold contactId, WOId, duration,start slot
                    var slotAllocationDetailsMap = new Object();
                    slotAllocationDetailsMap['contactId']=WOADetailMap['contactId'];
                    slotAllocationDetailsMap['WOId']= WOADetailMap['workOrderId'];
                    slotAllocationDetailsMap['Duration']= WOADetailMap['Duration'];
                    slotAllocationDetailsMap['slots']= slotAssigned;
                    component.set("v.slotWODetails",slotAllocationDetailsMap);
                    var recordidtodelete=component.getEvent('slotDetails');
                    recordidtodelete.setParams({
                        "slotDetails":slotAllocationDetailsMap
                    });
                    recordidtodelete.fire();
                }else{
                    //--in case the to-duration is more than available free time +30 mins
                    if(availableSlotInBetweenInMin < parseInt(toDuration)){               
                        component.set("v.showMessage",true);
                        component.set("v.message","Technician cannot reach the Work Order service location on time.");
                    }
                    //--in case total duration (to and from) is more than available free time +30 mins
                    else{
                        //alert("Cannot Allocate as travel time is more");                   
                        component.set("v.showMessage",true);
                        component.set("v.message","Technician cannot reach the subsequent Work Order on its preferred service time.");
                    }                    
                }
        }
        else{
            if(availableSlotInBetween == 0){
                debugger;
                if(parseInt(fromDuration) > defaultMinTravelTime){
                    //alert("Cannot Allocate as travel time is more");    
                    component.set("v.showMessage",true);
                    component.set("v.message","Technician cannot reach the subsequent Work Order on its preferred service time."); 
                }                    
                
                //--if travel time is less that minimum time in case no free slot in between allow to assign the agent
                else if(totalTravelTime < mintravelTime){
                    
                    component.set("v.allocatedSlot",slotAssigned);
                    //--build global map which hild contactId, WOId, duration,start slot
                    var slotAllocationDetailsMap = new Object();
                    slotAllocationDetailsMap['contactId']= WOADetailMap['contactId'];
                    slotAllocationDetailsMap['WOId']= WOADetailMap['workOrderId'];
                    slotAllocationDetailsMap['Duration']= WOADetailMap['Duration'];
                    slotAllocationDetailsMap['slots']= slotAssigned;
                    component.set("v.slotWODetails",slotAllocationDetailsMap);
                    
                    var recordidtodelete=component.getEvent('slotDetails');
                    recordidtodelete.setParams({
                        "slotDetails":slotAllocationDetailsMap
                    });
                    recordidtodelete.fire();
                    
                }
                    else if(totalTravelTime > mintravelTime){
                    
                    component.set("v.allocatedSlot",slotAssigned);
                    //--build global map which hild contactId, WOId, duration,start slot
                    var slotAllocationDetailsMap = new Object();
                    slotAllocationDetailsMap['contactId']= WOADetailMap['contactId'];
                    slotAllocationDetailsMap['WOId']= WOADetailMap['workOrderId'];
                    slotAllocationDetailsMap['Duration']= WOADetailMap['Duration'];
                    slotAllocationDetailsMap['slots']= slotAssigned;
                    component.set("v.slotWODetails",slotAllocationDetailsMap);
                    
                    var recordidtodelete=component.getEvent('slotDetails');
                    recordidtodelete.setParams({
                        "slotDetails":slotAllocationDetailsMap
                    });
                    recordidtodelete.fire();
                    
                }else{
                    
                    //alert("Cannot Allocate as travel time is more");    
                    component.set("v.showMessage",true);
                    component.set("v.message","Technician cannot reach the subsequent Work Order on its preferred service time.");                                 
                    
                }
            }
            
            else{
                debugger;
                component.set("v.allocatedSlot",slotAssigned);
                //--build global map which hild contactId, WOId, duration,start slot
                var slotAllocationDetailsMap = new Object();
                slotAllocationDetailsMap['contactId']= WOADetailMap['contactId'];
                slotAllocationDetailsMap['WOId']= WOADetailMap['workOrderId'];
                slotAllocationDetailsMap['Duration']= WOADetailMap['Duration'];
                slotAllocationDetailsMap['slots']= slotAssigned;
                component.set("v.slotWODetails",slotAllocationDetailsMap);
                
                var recordidtodelete=component.getEvent('slotDetails');
                recordidtodelete.setParams({
                    "slotDetails":slotAllocationDetailsMap
                });
                recordidtodelete.fire();        }
        }
    }
})