({
	onPageLoad : function(component, event, record) {
        var action = component.get("c.onload");
        action.setParams({ "recordId" : record });
        action.setCallback(this, function(response){
            var state = response.getState();
            //alert(state);
            
            if(state == 'SUCCESS')
            {
                var value = response.getReturnValue();
            	//alert('value.stapp__Product__r.RecordType.Name '+value.stapp__Product__r.RecordType.Name);
                
                if(value.stapp__Product__r.RecordType.Name != 'BOM')
                {
                    component.find('notifLib').showNotice({
                        "variant": "warning",
                        "header": "Data Problem!",
                        "message": "Choose BOM Product.",
                        closeCallback: function() {
                            $A.get("e.force:closeQuickAction").fire();
                        }
                    });
                    return;
                }else{
                    component.set('v.BomRecord', value);   
                }
                
            }else{
                var errors = response.getError();
                
                if(errors){
                    if(errors[0] && errors[0].message){
                        alert("Error message: " + errors[0].message);
                    }
                }else{
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    handleActive: function (cmp, event) {
        var tab = event.getSource();
        switch (tab.get('v.id')) {
            case 'badge' :
                this.injectComponent('lightningcomponentdemo:exampleBadge', tab);
                break;
            case 'buttons' :
                this.injectComponent('lightningcomponentdemo:exampleRegularButtons', tab);
                break;
            case 'icons':
                this.injectComponent('lightningcomponentdemo:exampleIcon', tab);
                break;
            case 'inputs':
                this.injectComponent('lightningcomponentdemo:exampleInputValidation', tab);
                break;
        }
    },
    injectComponent: function (name, target) {
        $A.createComponent(name, {
            // no attrs
        }, function (contentComponent, status, error) {
            if (status === "SUCCESS") {
                target.set('v.body', contentComponent);
            } else {
                throw new Error(error);
            }
        });
    }
})