({
	 doInit:function(component, event, helper){
        // helper.getVerticles(component);
    },
     Uploadfile : function(component, event, helper) {
        helper.save(component);
    },
     handleFilesChange: function(component, event, helper) {
        helper.DisplayFileName(component, event, helper);
    },
})