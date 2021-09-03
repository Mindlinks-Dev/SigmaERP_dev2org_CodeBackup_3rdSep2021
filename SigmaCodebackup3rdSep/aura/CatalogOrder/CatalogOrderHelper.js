({
    productSearch: function(component, event,helper) //revoked onClick of the search button
    {
        component.find("Id_spinner").set("v.class" , 'slds-show');
        var action = component.get("c.searchProducts");
        action.setParams({
            'SearchKeyword': component.get("v.searchKeyword"),
            'offsetValue': component.get("v.RecordStart"),
            'SelectedProductType': component.get("v.SelectedProductType"),
            'pageNumber' : component.get("v.page")
        });
        action.setCallback(this, function(response) {
            // hide spinner when response coming from server 
            //alert(JSON.stringify(response.getReturnValue()));
            component.find("Id_spinner").set("v.class" , 'slds-hide');
            var state = response.getState();
            //alert(JSON.stringify(response.getReturnValue()).ResponseWrapperList);
            if (state === "SUCCESS") 
            {
               if(response.getReturnValue().ResponseWrapperList[0].Status = 'ERROR')
               {
                   var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                title: "warning",
                                message: response.getReturnValue().ResponseWrapperList[0].errorMessage,
                                type: "warning"
                            });
                            toastEvent.fire();
               }
                var res = response.getReturnValue();
                for(var i=0;i< res.productList.length;i++)
                {
                    var tempList=[];
                    for(var key in res.productList[i].ProductDataMap){
                        tempList.push({value:res.productList[i].ProductDataMap[key], key:key});
                    }
                    res.productList[i].tempMap=tempList;
                }
                
                component.set('v.completeWrap', res);
                component.set('v.total', res.totalRecords);
                component.set('v.page',	res.pageNumber);
                component.set('v.pages', Math.ceil(res.totalRecords/res.pageSize));
                component.set("v.isSearch",true);
            }
            else if (state === "ERROR") {
                alert('Error : ' + JSON.stringify(response.getError()));
            } 
        });
        $A.enqueueAction(action);
        console.log('helper productSearch');
    },
    toGetTabData : function(component, event,helper)	//revoked onload of catalog order or on selecting another tab
    {
         var selProdType = component.get("v.SelectedProductType");
        var actionSaveBulk = component.get("c.getProductList");
        //alert(selProdType);
        actionSaveBulk.setParams({ 
            ProdType : selProdType,
            PageNumber : component.get("v.page")
        });
        actionSaveBulk.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                component.set("v.completeWrap", response.getReturnValue());
                component.set("v.page", response.getReturnValue().pageNumber);
                if(Math.ceil(response.getReturnValue().totalRecords/response.getReturnValue().pageSize) >= 1)
                {
                    component.set("v.pages", Math.ceil(response.getReturnValue().totalRecords/response.getReturnValue().pageSize));
                }
                else
                {
                    component.set("v.pages", response.getReturnValue().pageNumber);
                }
                component.set("v.total", response.getReturnValue().totalRecords);
            //alert('page '+component.get("v.page")+' Pages '+component.get("v.pages") + ' response.totalRecords '+component.get("v.total"));
            }
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") 
                {
                  
                }
        });
        $A.enqueueAction(actionSaveBulk); 
    },
})