({
	handleMenuSelect : function(component, event, helper) {
        var brewId = component.get("v.rowDetails.sigmaerpdev2__Brewer_Account__c");
        var selectedMenuItemValue = event.getParam("value"); 
        var msg = '';
        if(selectedMenuItemValue == 'Deactivate')
            msg = 'deactivate';
        else
            msg = 'activate';            
        var brewName = component.get("v.rowDetails.sigmaerpdev2__Brewery_Name__c");
        $.confirm({
            title: 'Are you sure you want to '+msg+' "'+brewName+'" ?',
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
                                helper.changeStatusH(component, event, helper);
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