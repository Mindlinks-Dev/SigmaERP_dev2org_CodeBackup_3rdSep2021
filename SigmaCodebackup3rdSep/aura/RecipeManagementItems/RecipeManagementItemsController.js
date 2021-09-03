({
	handleMenuSelect : function(component, event, helper) {
        var selectedMenuItemValue = event.getParam("value");
        
        if(selectedMenuItemValue == 'Edit')
        {
            helper.handleMenuSelectH(component, event, helper,'update');
        }
        else if(selectedMenuItemValue == 'Clone')
        {
            helper.handleMenuSelectH(component, event, helper,'clone');   
        }
        else if(selectedMenuItemValue == 'Delete')
        {             
            $.confirm({
            title: 'Are you sure you want to delete this recipe?',
            content: '',           
            type: 'orange',            
            typeAnimated: true,
            animation: 'scale',
            closeAnimation: 'scale',
            animationBounce: 2,
            buttons: {
                Yes: {
                    text: 'Yes',
                    btnClass: 'btn-green',
                    action: function () {
                        window.setTimeout(
                            $A.getCallback(function () {
                                helper.handleMenuSelectH(component, event, helper,'delete');
                            }), 500
                        );
                    }
                },
                No: function () {
                },
            }
        });
            //helper.handleMenuSelectH(component, event, helper,'delete');   
        }   
        
	},
    viewDetails: function(component, event, helper) {
        helper.handleMenuSelectH(component, event, helper,'view');
	},
})