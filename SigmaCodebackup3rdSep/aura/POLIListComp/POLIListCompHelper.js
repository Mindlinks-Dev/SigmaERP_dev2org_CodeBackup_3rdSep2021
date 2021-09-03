({
	showHide : function(component) {
       var vs=component.find('vs').get('v.value');
        
        component.set("v.isOpen",false);
        component.set("v.IsPOLI",false);

    },
      hidePoli : function(component) {
      component.set("v.IsPOLI",false);
        $A.get('e.force:refreshView').fire();
    }
})