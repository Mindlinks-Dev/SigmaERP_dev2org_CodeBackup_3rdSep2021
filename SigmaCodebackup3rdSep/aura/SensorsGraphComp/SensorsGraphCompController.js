({	
    loadGraph : function(cmp, event, helper) 
    {
        var temp2 = [];
        var action = cmp.get("c.loadGraphDetails");
        action.setParams({ recordId : cmp.get("v.recordId") });
        action.setCallback(this, function(response){        	    	    
            if(response.getState() === 'SUCCESS' && response.getReturnValue()){
                var el = cmp.find('chart').getElement();
                var ctx = el.getContext('2d');
                
                if(response.getReturnValue().sensorIoTId.includes("E1021"))
                {
                    new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: response.getReturnValue().labels,
                            datasets: [{
                                label: 'Monitoring Data',
                                data: response.getReturnValue().values,
                                backgroundColor: "rgb(59, 109, 246)"
                            }]
                        }
                    });
                }
                else
                {
                    new Chart(ctx, {
                        type: 'line',
                        data: {
                            labels: response.getReturnValue().labels,
                            datasets: [{
                                label: 'Monitoring Data',
                                data: response.getReturnValue().values,
                                borderColor: "rgb(59, 109, 246)"
                            }]
                        }
                    });
                }
            }            
        });  
        $A.enqueueAction(action);
    }
})