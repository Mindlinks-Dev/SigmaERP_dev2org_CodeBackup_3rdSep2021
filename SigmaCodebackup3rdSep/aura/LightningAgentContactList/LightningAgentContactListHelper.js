({
    getDistance:function (component,event,startZipCode,endZipCode, index){ 
        var distance ='';
        var action = component.get("c.getDistance");
        action.setParams({
            "startPincode":startZipCode,
            "endPincode":endZipCode
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state== "SUCCESS"){
                //component.set("v.distance", response.getReturnValue());
                distance = response.getReturnValue();
               
                //alert(component.get("v.distance"));
                //return distance;
                
                var slotDurationMap = new Object();
                slotDurationMap = component.get("v.slotDurationMap");
                if(slotDurationMap == null){
                    slotDurationMap = new Object();
                    slotDurationMap[index] = distance;
                    component.set("v.slotDurationMap",slotDurationMap);
                }else{
                    slotDurationMap[index] = distance;
                    component.set("v.slotDurationMap",slotDurationMap);                    
                }
                //alert('index'+index);
               	//alert(component.get("v.slotDurationMap"));               
                
            }
        });
        $A.enqueueAction(action);        
    },
    Blockedhoursoftechnician : function (component,event){ 
        
        console.log('test');
        var selectedTd = '';
        var techbusy = '';
        var notBusyCount = 0;
        var count = 0;
        var selectedItem = event.currentTarget;
        var selectedId = selectedItem.dataset.record;
        var Duration =2;
        var res = selectedId.split("-");
        for(var i=0; i<=1; i++){
            count = 0;
            count = parseInt(res[1])+i;
            selectedTd = component.find(res[0]+'-'+count);
            techbusy = $A.util.hasClass(selectedTd, 'tech-busy');
            if(!techbusy){
               // alert('not busy');
                notBusyCount = notBusyCount+1;
            }
        }
       if(notBusyCount == Duration){
            for(var i=0; i<=1; i++){
                count = 0;
                count = parseInt(res[1])+i;
                selectedTd = component.find(res[0]+'-'+count);
                $A.util.addClass(selectedTd, 'SelectForAssign');
            }
        }        
        
    }
})