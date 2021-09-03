({
    getProductStock : function(component, event, helper) {
        //Initialising fromDate and toDate to Today's Date.
        var today = new Date();
        component.set('v.fromDate',  today.getFullYear()+ "-" + ((today.getMonth() + 1)<10 ? '0': '') + (today.getMonth() + 1)+ "-" + ((today.getDate() < 10 ? '0' : '') + today.getDate()));
        var todayPlusFour = new Date();
        todayPlusFour.setDate(today.getDate()+3);
        component.set('v.toDate',  todayPlusFour.getFullYear()+ "-" + ((todayPlusFour.getMonth() + 1)<10 ? '0': '') + (todayPlusFour.getMonth() + 1)+ "-" + ((todayPlusFour.getDate() < 10 ? '0' : '') + todayPlusFour.getDate()));
        
        //Getting the value from fromDate.
        var enteredDate = component.find("fromDate").get("v.value");
        
        ////Getting the value from toDate.
        var toDate = component.find("toDate").get("v.value");
        var arr = new Array();
        var dt = new Date(enteredDate);
        var end = new Date(toDate);
        var arrUI = new Array();
        
        //Calculating the TimeDiff between fromDate and toDate.
        var timeDiff = Math.abs(dt.getTime() - end.getTime());
        var diffFromToDays = Math.ceil(timeDiff / (1000 * 3600 * 24));
        component.set('v.diffFromToDates',diffFromToDays);
        component.set('v.numberOfDays',diffFromToDays+1);
        
        //Creating an Array of Dates between fromDate and toDate.
        while(dt <= end) {
        	//arr.push(new Date(dt));
            var temp = new Date(dt);
            var temp1 = new Date(dt);
            temp1 = temp1.getFullYear()+ "-" + ((temp1.getMonth() + 1)<10 ? '0': '')+ (temp1.getMonth() + 1) + "-" + ((temp1.getDate() < 10 ? '0' : '') + temp1.getDate());
            arr.push(temp1);
            temp =  temp.getDate()+ "-" + ((temp.getMonth() + 1)<10 ? '0': '')+ (temp.getMonth() + 1) + "-" +temp.getFullYear();
            arrUI.push(temp);
            dt.setDate(dt.getDate() + 1);
        }
        component.set('v.arrDate',arr);
        component.set('v.arrDateUI',arrUI);
        helper.getProductStockHelper(component,event);  
    },
    
    getOutputDate : function(component, event, helper) {
        
        //Getting the value from fromDate.
        var enteredDate = component.find("fromDate").get("v.value");
        //alert(enteredDate);
        //Getting the value from toDate.
        var toDate = component.find("toDate").get("v.value");
        //alert(toDate);
        var today1 = new Date();
        //today1 =  today1.getFullYear()+ "-" + (today1.getMonth() + 1) + "-" +today1.getDate();
        
        var from = new Date(enteredDate);
        var to = new Date(toDate);
        
        //Calculating the TimeDiff between fromDate and toDate.
        var timeDiff = Math.abs(from.getTime() - to.getTime());
        var diffFromToDays = Math.ceil(timeDiff / (1000 * 3600 * 24));
        component.set('v.diffFromToDates',diffFromToDays);
        component.set('v.numberOfDays',diffFromToDays+2);
        
        //display a message if fromDate is greater than toDate.
        if(enteredDate>toDate){
            component.set('v.isEmpty',false);
            component.set('v.message','\'From Date\' must be lesser than or equal to \'To Date\'');
        }
        
        //Both fromDate and toDate should be greater or equals to "today's" Date.
        else if((enteredDate<today1 || toDate<today1)){
            component.set('v.isEmpty',false);
            component.set('v.message','You must enter either a current date or a future date');
        }
        //you can enter only a range of 5 days.
        else if(diffFromToDays >= 5){
            component.set('v.isEmpty',false);
            component.set('v.message','You can select a range of only 5 days');
        }
        else{
            component.set('v.isEmpty',false);
            component.set('v.message','There\'s no WorkOrder Assigned on this Date....');
            var arr = new Array();
            var arrUI = new Array();
            var dt = new Date(enteredDate);
            var end = new Date(toDate);
            
            //Creating an Array of Dates between fromDate and toDate.
            while(dt <= end){
                var temp = new Date(dt);
            var temp1 = new Date(dt);
            temp1 = temp1.getFullYear()+ "-" + ((temp1.getMonth() + 1)<10 ? '0': '')+ (temp1.getMonth() + 1) + "-" + ((temp1.getDate() < 10 ? '0' : '') + temp1.getDate());
            arr.push(temp1);
            temp =  temp.getDate()+ "-" + ((temp.getMonth() + 1)<10 ? '0': '')+ (temp.getMonth() + 1) + "-" +temp.getFullYear();
            arrUI.push(temp);
            dt.setDate(dt.getDate() + 1);   
            }
            component.set('v.arrDate',arr);
            component.set('v.arrDateUI',arrUI);
            helper.getProductStockHelper(component,event);
        } 
    },
    refreshTable: function(component, event, helper) {
        
        component.set('v.isEmpty',true);
        
        //Getting the value from fromDate.
        var enteredDate = component.find("fromDate").get("v.value");
        
        //Getting the value from toDate.
        var toDate = component.find("toDate").get("v.value");
        
        var today1 = new Date();
        //today1 =  today1.getFullYear()+ "-" + (today1.getMonth() + 1) + "-" +today1.getDate();
        
        var from = new Date(enteredDate);
        var to = new Date(toDate);
        
        //Calculating the TimeDiff between fromDate and toDate.
        var timeDiff = Math.abs(from.getTime() - to.getTime());
        var diffFromToDays = Math.ceil(timeDiff / (1000 * 3600 * 24));
        component.set('v.diffFromToDates',diffFromToDays);
        component.set('v.numberOfDays',diffFromToDays+2);
        
        //display a message if fromDate is greater than toDate.
        if(enteredDate>toDate){
            component.set('v.isEmpty',false);
            component.set('v.message','\'From Date\' must be lesser than or equal to \'To Date\'');
        }
        
        //Both fromDate and toDate should be greater or equals to "today's" Date.
        else if((enteredDate<today1 || toDate<today1)){
            component.set('v.isEmpty',false);
            component.set('v.message','You must enter either a current date or a future date');
        }
        //you can enter only a range of 5 days.
        else if(diffFromToDays >= 5){
            component.set('v.isEmpty',false);
            component.set('v.message','You can select a range of only 5 days');
        }
        else{
            component.set('v.isEmpty',false);
            component.set('v.message','There\'s no WorkOrder Assigned on this Date....');
            var arr = new Array();
            var arrUI = new Array();
            var dt = new Date(enteredDate);
            var end = new Date(toDate);
            
            //Creating an Array of Dates between fromDate and toDate.
            while(dt <= end){
                arr.push(new Date(dt));
                var temp = new Date(dt);
                dt.setDate(dt.getDate() + 1);
                temp =  temp.getDate()+ "-" + ((temp.getMonth() + 1)<10 ? '0': '')+ (temp.getMonth() + 1) + "-" +temp.getFullYear();
                arrUI.push(temp);   
            }
            component.set('v.arrDate',arr);
            component.set('v.arrDateUI',arrUI);
            component.set('v.isEmpty',true);
            helper.getProductStockHelper(component,event);
        }
    }
})