({
	handleMenuSelect : function(component, event, helper) {
        var brewId = component.get("v.rowDetails.sigmaerpdev2__Brewer_Account__c");
        var selectedMenuItemValue = event.getParam("value");         
        var brewName = component.get("v.rowDetails.Name");
        var soId = component.get("v.rowDetails.Id");
        var msg = '';
        if(selectedMenuItemValue == 'Mark as Delivered')
            msg = 'Are you sure you want to mark '+brewName+' as delivered ?';
        else
            msg = 'Are you sure you want to delete '+brewName+' ?';          
        
        $.confirm({
            title: msg,
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
                                helper.handleActionsH(component, event, helper, soId, selectedMenuItemValue);
                            }), 100
                        );
                    }
                },
                No: function () {
                },
            }
        });
	},
})