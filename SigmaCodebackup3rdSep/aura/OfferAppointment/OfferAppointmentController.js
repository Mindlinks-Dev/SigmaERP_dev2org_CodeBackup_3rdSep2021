({
    doInit : function(component, event, helper) {
        
        component.set("v.showChkAvail", true);
        var recId = component.get('v.recordId');
      //  alert('recId '+recId);
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set("v.MinDate", today);
        component.set("v.startDate", today);
        var action = component.get("c.fetchOfferAppointment");
        action.setParams({ recId : recId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            // alert(state);
            if (state =="SUCCESS") 
            {
                 //alert('hii'+JSON.stringify(response.getReturnValue()));
                component.set('v.workOrderDetails',response.getReturnValue().workOrderDetail);
            }
            
           /* var status=component.get("v.workOrderDetails.sigmaerpdev2__Status__c");
            if(status !='New' && status !='Another Visit Needed'){
                
                 var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Work Order is already Assigned"
            });
            toastEvent.fire();
           window.location.reload();

            }*/
        });
        $A.enqueueAction(action);
        
    },
     closeMessage: function(component, event, helper) {
        component.set("v.openSLAReasonModel", false);
        component.set("v.openModalPopUp", true);
    },
   
    getAppointmentData : function(component, event, helper ) 
    {
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
      
        //component.set("v.openModalPopUp",true);
        var startdate=component.get("v.startDate");        
        var enddate=component.get("v.endDate");
        
        if(enddate == null || enddate == undefined){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Please select To date."
            });
            toastEvent.fire();
            return;
        }
        
        if(startdate < today){
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Available From date should be today's or future dates."
            });
            toastEvent.fire();
            return;
        }
        if(enddate < today){
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "End  date should be today's or future dates."
            });
            toastEvent.fire();
            return;
        }
        
        
        
        var action = component.get("c.Getdates");
        action.setParams({ startdate : startdate,
                          enddate : enddate});        
        action.setCallback(this, function(response) {
            var state = response.getState();        
            if (state =="SUCCESS") 
            { 
                var result=response.getReturnValue();
                component.set("v.Dates",result);
                component.set("v.openModalPopUp",true);
            }
        });
        
        $A.enqueueAction(action);
    },
    clsoePopUp : function(component, event, helper ) 
    {
        component.set("v.selDateAndTime", null);
        component.set("v.showChkAvail", true);
        component.set("v.openModalPopUp",false);
    },
   
    submitSLAReason: function(component, event, helper )
    {
        if(!component.get('v.workOrderDetails.Out_of_SLA_Reason__c'))
        {
            component.find('slaReason').showHelpMessageIfInvalid();
            return;
        }
        component.set('v.workOrderDetails.Out_of_SLA_Customer_Consent__c',true);
        component.set("v.openSLAReasonModel",false);
        document.getElementById("Accspinner").style.display = 'block';
        
        helper.sumbitAppointmentData(component, event, helper);
    },
    closeSLAReasonModel : function(component, event, helper ) 
    {
        component.set('v.workOrderDetails.Out_of_SLA_Customer_Consent__c',false);
        component.set('v.workOrderDetails.Out_of_SLA_Reason__c','');
        component.set("v.openSLAReasonModel",false);
        component.set("v.openModalPopUp",true);
    },
   
    makeBookRequest : function(component, event, helper ) 
    {    
      
        var rec =component.get('v.recordId');
        //var SelDate = component.get('v.whatToUse');
         
        
        var SelDate =component.get("v.selDateAndTime");
         var SelDate1= $A.localizationService.formatDate(SelDate, "YYYY-MM-DD HH:mm:ss");
        //alert('SelDate>>>'+SelDate);
       
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD HH:mm:ss");
        // alert('today>>>'+today);
        
         if(SelDate1 < today){
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Selected time must be current or future time."
            });
            toastEvent.fire();
            return;
        }
       
        var action = component.get("c.SelectedDate");
        action.setParams({ rec : rec,
                          SelDate : SelDate});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state =="SUCCESS") 
            {
                // alert('hii'+JSON.stringify(response.getReturnValue()));
                /*component.set('v.workOrderDetails',response.getReturnValue());*/
              //  $A.get('e.force:refreshView').fire();
            
            	//component.set("v.ShowAgent", true);
            	component.set("v.openSLAReasonModel",true);
                component.set("v.openModalPopUp",false);
                 //window.location.href = "/" + rec;
            }
        });
        $A.enqueueAction(action);
        
        
    },
    onWhatToUse: function(cmp, evt) {
        var indexvar = evt.getSource().get("v.label");
        console.log("indexvar:::" + indexvar);
        cmp.set("v.whatToUse", indexvar);
        console.log (evt.currentTarget.name);
    },//onWhatToUse
    
    closeErrorMsg : function(component, event, helper ) 
    {
        component.set('v.isError',false);
    },
    showTotalOffer : function(component, event, helper ) 
    {
        document.getElementById("Accspinner").style.display = 'block';
        if(component.get('v.totalOfferCount')==component.get("v.responseData").length)
            component.set('v.totalOfferCount',component.get("v.DefaultViewCount"));
        else
            component.set('v.totalOfferCount',component.get("v.responseData").length);
        window.setTimeout(
            $A.getCallback(function() {
                document.getElementById("Accspinner").style.display = 'none';
            }), 500
        );
    },
    dateChange : function(component, event, helper ) {
        var startDate=new Date(component.get('v.startDate'));
        var year = startDate.getFullYear();
        var month = startDate.getMonth()+1;
        var day=startDate.getDate()+5;
        var formatted=year+"-"+month+"-"+day;
        //alert(formatted);
        //ar dd = startDate.setDate(startDate.getDate() + 5);         
        //var endDate = new Date(dd); 
        if(startDate != null){
            component.set('v.endDate',formatted);
        }
    },
    
    endDateUpdated :  function(component, event, helper){
        var target = event.getSource();
        
        var enteredValue = target.get("v.value");
        //alert('enteredValue>>'+enteredValue);
      /* alert('enteredValue>'+enteredValue);
       var enteredValue= component.get("v.tym");
        alert('g'+enteredValue);*/
       component.set("v.selDateAndTime",enteredValue);
    },
    onWhatToUseNew : function(component, event, helper){
        var isChecked = cmp.find('inpCk').get('v.checked');
alert('selectedd...'+isChecked);
        alert('new...'+component.get("v.selDateAndTime"));
        if(component.get("v.selDateAndTime") == null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "info",
                "title": "Info!",
                "message": "Select Preferred time."
            });
            toastEvent.fire();
        	//alert('Select preferred time.'); 
           /* var selLineItem = component.find(indexvar);
            alert('selLineItem==='+selLineItem);
            selLineItem.focus();*/
        }
        component.set("v.showChkAvail", false);
    }
    
})