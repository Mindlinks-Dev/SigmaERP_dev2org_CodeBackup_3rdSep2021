({
	FullViewImg : function(component, event, helper) {
		component.set("v.FullViewImg",true);
	},
    CloseFullViewImg : function(component, event, helper) {
		component.set("v.FullViewImg",false);
	},
    OpenContent : function(component, event, helper){
        component.set("v.OpenContent",true);
        component.set("v.MainContent",false);
    },
    BookOnline : function(component, event, helper){
        component.set("v.ParticipantForm",true);
        component.set("v.OpenContent",false);
        component.set("v.MainContent",false);
    }
})