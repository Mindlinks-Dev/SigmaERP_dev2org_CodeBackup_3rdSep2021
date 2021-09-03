({
	FullViewImg : function(component, event, helper) {
		component.set("v.FullViewImg",true);
	},
    CloseFullViewImg : function(component, event, helper) {
		component.set("v.FullViewImg",false);
	},
    OpenContent : function(component, event, helper){
        /*component.set("v.OpenContent",true);
        component.set("v.MainContent",false);
         alert('courseId:'+[event.currentTarget.name]);
        */
        
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
       
        var courseId = [event.currentTarget.name];
        //alert('courseId:'+courseId);
        var CourseWrapper = component.get('v.CourseWrapper');
        var Events;
        var EventSWrapper;
        for(var j = 0 ; j<CourseWrapper.length ; j++)
        {
            if(CourseWrapper[j].course.Id ==courseId)
            {
                Events = CourseWrapper[j].EventList;
                //alert('Inside matching Events:'+Events +'events size():'+Events.length);
                break;
            }
        }
        
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        component.set("v.EventSWrapper",Events);
        component.set("v.OpenContent",true);
        component.set("v.MainContent",false);
        
        /*component.set("v.recordId",object.Id); 
        component.set("v.quickviewedProduct",component.get('v.completeWrap.productList')[event.currentTarget.name]); 
        component.set("v.quickview",true);*/
        
        
        
    },
    BookOnline : function(component, event, helper){
        
       
        var eventId = event.getSource().get("v.value");
        //alert('Selected Event Id:'+eventId);
        var EventSWrapper = component.get('v.EventSWrapper');
        var Events;
        //alert('EventSWrapper.length:'+EventSWrapper.length);
         for(var j = 0 ; j<EventSWrapper.length ; j++)
        {
            
            if(EventSWrapper[j].Event.Id == eventId)
            {
                Events = EventSWrapper[j].Event;
                //component.set('v.BookingWrapper.sigmaerpdev2__Event__c',Events);
                component.set('v.BookingWrapper.EventId',Events.Id);
                break;
            }
        }

        component.set("v.ParticipantForm",true);
        component.set("v.OpenContent",false);
        component.set("v.MainContent",false);
    },
    
    init: function (component, event, helper,page) {
		 var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        helper.getCourses(component, event, helper);
    },
    
    save : function(component, event, helper) {
        var BookingWrapper = component.get("v.BookingWrapper");
        //alert('BookingWrapper>>'+JSON.stringify(BookingWrapper));
        //alert('BookingWrapper.custWrap.FirstName>>'+BookingWrapper.custWrap.FirstName);
        
        if(BookingWrapper.custWrap.FirstName==undefined)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                type: "error",
                message: "Enter your firstname."
            });
            toastEvent.fire();
            return;
        }
         if(BookingWrapper.custWrap.LastName==undefined)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                type: "error",
                message: "Enter your LastName."
            });
            toastEvent.fire();
            return;
        }
        
         if(BookingWrapper.custWrap.StreeAddress==undefined)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                type: "error",
                message: "Enter your StreeAddress."
            });
            toastEvent.fire();
            return;
        }
        
         if(BookingWrapper.custWrap.Address==undefined)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                type: "error",
                message: "Enter your Address."
            });
            toastEvent.fire();
            return;
        }
        
        if(BookingWrapper.custWrap.TownCity==undefined)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                type: "error",
                message: "Enter your Address."
            });
            toastEvent.fire();
            return;
        }
        
        if(BookingWrapper.custWrap.PostalCode==undefined)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                type: "error",
                message: "Enter your PostalCode."
            });
            toastEvent.fire();
            return;
        }
        
          if(BookingWrapper.custWrap.MobilePhoneNumber==undefined)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                type: "error",
                message: "enter your Mobile Phone Number."
            });
            toastEvent.fire();
            return;
        }
        
         if(BookingWrapper.custWrap.EmailId==undefined)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                type: "error",
                message: "enter your EmailId."
            });
            toastEvent.fire();
            return;
        }
        
         if(BookingWrapper.custWrap.hearaboutUs==undefined || BookingWrapper.custWrap.hearaboutUs=='-- None --')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error",
                type: "error",
                message: "enter your Address."
            });
            toastEvent.fire();
            return;
        }
        
        
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide"); 
         var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        helper.saveCustomerInfo(component, event, helper);
		
	},
    
    gotoMainPage:function(component, event, helper) 
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": component.get("v.RedirectURL")
        });
        urlEvent.fire();
    },
    
    
})