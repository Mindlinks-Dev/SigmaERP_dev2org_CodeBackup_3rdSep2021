({
    fetchProductInventory : function(component) {
        //alert('Product>>'+component.get('v.productName'));
       // alert('location>>>'+component.get('v.LocationName'));
        component.set('v.pinotempty',false);
        var loc = component.get(('v.LocationName'));
        var action = component.get("c.fetchIP");
        
        action.setParams(
            {"productName": component.get('v.productName'), 
             "LocationName": component.get('v.LocationName')
            });
        action.setCallback(this, function(response) {
            var state = response.getState();
           // alert("state"+state);
            // alert('state In Order : '+state);
            if (state=== 'SUCCESS')
            {
                var IPObj = response.getReturnValue();
                var Iop=JSON.stringify(IPObj);
               // alert('Totals ##'+JSON.stringify(IPObj));
                component.set('v.prodInvList',IPObj.prodinv)
                component.set('v.invLocProdList',IPObj.invlocpod);
                component.set('v.invLocprodLinelist',IPObj.ilpli);
				
				if(component.get('v.prodInvList').length > 0)
                {
                   // alert('inside')
				component.set('v.pinotempty',true);
                }
                if(component.get('v.invLocprodLinelist').length == 0)
                {
                    alert('Inventory not available for selected product at '+ loc+' location');
                }
            }
        });
        $A.enqueueAction(action);    
    }
    
})