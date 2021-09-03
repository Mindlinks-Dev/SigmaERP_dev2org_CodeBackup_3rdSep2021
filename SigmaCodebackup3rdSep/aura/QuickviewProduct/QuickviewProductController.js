({
    doInit : function(component, event,helper) 
    { 
        
        helper.fetchImageId(component, event,helper);
       
    },
    magnify : function(component, event,helper)
    {
        helper.magnify(component, event,helper);
        
    },
    magnifyleave : function(component, event,helper)
    {
        helper.magnifyleave(component, event,helper);
    },
    colorChange: function(component, event, helper){
        var ind=event.target.name;
        var color=event.target.id;
        var completeWrap=component.get('v.quickviewedProduct');
        completeWrap.selectedColor = color;
        component.set('v.quickviewedProduct',completeWrap);
        helper.magnifierHelper(component, event,helper);
    },
    // code for Saveing SO and SOLI by chandana 
    saveproddata :function(component, event, helper) {
        var index = event.currentTarget;
        var indexval = index.dataset.record;
        helper.saveToCart(component, event, helper,indexval);
    },
   
    close : function(component, event, helper)
    {        
        component.set("v.quickviewprod",false);   
    }
    
})