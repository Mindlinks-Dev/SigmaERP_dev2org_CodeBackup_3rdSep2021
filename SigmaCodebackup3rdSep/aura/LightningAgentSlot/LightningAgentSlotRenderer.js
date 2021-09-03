({
    // Your renderer method overrides go here
    /*afterRender : function(component, helper) {
        this.superAfterRender();
        // Write your custom code here. 
        // var getListofmap = component.get('v.mapvalue'); 
        //alert(' getListofmap'+getListofmap);
        var getList = component.get('v.ListOfKeys'); 
        alert(' getList>>'+getList);
        var getElement = component.get('v.element');
        //alert(' getElement'+getElement);
        var getElementIndex = getList.indexOf(getElement);
        
        // if getElementIndex is not equal to -1 it's means list contains this element. 
        if(getElementIndex != -1){ 
            component.set('v.condition',true);
            component.set('v.Slot',true);
            var gettheslot=component.get('v.Slot');
            alert('If>>>'+gettheslot);
        }else{
            component.set('v.condition',true);
            component.set('v.Slot',false);
            var gettheslot=component.get('v.Slot');
            alert('ELSE>>>'+gettheslot);
        }        
    }   */ 
})