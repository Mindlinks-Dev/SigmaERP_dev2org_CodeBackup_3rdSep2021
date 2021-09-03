({
    doInit: function (component, event, helper)
    {
        if( (typeof sforce != 'undefined') && (sforce != null) ) {
           
           component.set("v.LightView",true);
        } 
      
        else {
           
           component.set("v.LightView",false);
        }
    },
	dropdown : function (component, event, helper)
    { 
        var dropdownContent = component.find('dropdownContent');
        $A.util.toggleClass(dropdownContent, 'slds-is-open');
    },
    openRecords : function(component, event, helper){
        
       /* var temp = component.get("v.soList.Id");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": temp,
            "slideDevName": "related"
        });
        navEvt.fire();
        */
         var ILList =  component.get("v.ILList.Id");
        //alert(Orderlist);
        if( (typeof sforce != 'undefined') && (sforce != null) ) {
            //alert('if');
            sforce.one.navigateToSObject(ILList, 'detail');
        } 
        // Desktop Navigation
        else {
            // alert('else');
            window.location.href = "/"+ILList;
        }
    },
    DeleteRecord : function(component, event, helper) {        
        var InvLocId = component.get("v.ILList");
        var result = confirm("Are you sure you want to delete this record ?");
        if (result) {            
        	var action29 = component.get("c.deleteInvLoc"); 
            action29.setParams({
                "LocID" : InvLocId.Id
            });
            action29.setCallback( this, function(response2) {
                var state2 = response2.getState();                
                if (state2 === "SUCCESS"){
                    alert('Record deleted Successfully.');
                    window.location.reload();
                   // $A.get('e.force:refreshView').fire();
                    
                }
            });
            $A.enqueueAction(action29);
        }            
    }
})