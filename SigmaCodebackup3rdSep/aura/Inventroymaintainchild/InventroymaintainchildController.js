({
    editRecord : function(component, event, helper) {
       
    },
    doInit: function (component, event, helper)
    {
        if( (typeof sforce != 'undefined') && (sforce != null) ) {
           component.set("v.LightView",true);
        } 
      
        else {
           component.set("v.LightView",true);
        }
    },
})