({
     printPurchaseOrdersPDFHelper : function(component, event, helper,selectedPos) 
    {
		var selectedPos2=JSON.stringify(selectedPos);
        var action = component.get("c.getBaseURL");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log("resp>>>"+JSON.stringify(resp));
				if(resp!=null)
				{
					var baseUrl=resp["sigmaerpdev2__Vendor_Community_URL__c"];
                   
                    console.log('baseUrl>>'+baseUrl);
					var url=baseUrl+'/apex/sigmaerpdev2__PurchaseOrderPdfDowload?purchaseOrderList='+selectedPos2;	
					console.log('url>>'+url);
                    window.open(url);
				}
            }
        });
        $A.enqueueAction(action);
    },
	getPOList : function(comp, event, helper,page,poId) 
    {
        console.log('getPOList>>>poId>>>>'+poId);
        page = page || 1;
        var action = comp.get("c.POListViewonly");
        action.setParams({ pageNumber : page , poId:poId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var accs = response.getReturnValue();
                
                comp.set('v.total', accs.total);
                comp.set('v.page', accs.page);
                comp.set('v.pages', Math.ceil(accs.total/accs.pageSize));
                  console.log('accs>>'+JSON.stringify(accs));
                console.log('accs.PoList>>'+JSON.stringify(accs.PoWrapperList));
                 console.log('accs.total>>'+JSON.stringify(accs.total));
                 console.log('accs>>'+JSON.stringify(accs)); 
                console.log('accs>>'+JSON.stringify(Math.ceil(accs.total/accs.pageSize)));
               // alert('accs.PoWrapperList>>'+JSON.stringify(accs.PoWrapperList));
               //  alert('accs.total>>'+JSON.stringify(accs.total));
                // alert('accs.page>>'+JSON.stringify(accs.page));
                comp.set("v.items",accs.PoWrapperList);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);
    },
   /* validateVendorCredentials : function(comp, event, helper,VendorEmail,Password) 
    {
        //page = page || 1;
        var action = comp.get("c.CheckVendorCredentials");
        action.setParams({ 'vendorEmail' : VendorEmail,
                         'password' : Password
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
           // alert(state);
            if (state === "SUCCESS") {
                var VendorWrapper2 = response.getReturnValue();
               // alert('VendorWrapper2>>'+JSON.stringify(VendorWrapper2));
                if(VendorWrapper2!=undefined && VendorWrapper2.isVendorFound===true )
                {
                    comp.set('v.VendorWrapper', VendorWrapper2);
                     comp.set("v.isModalOpen", false);
                }
                else
                {
                    alert('please enter valid input');
                    return;
                }
               
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);
    },*/
})