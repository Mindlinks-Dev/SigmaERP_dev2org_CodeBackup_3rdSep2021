({ 
    doInit : function(component, event,helper) 
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
    Search: function(component, event, helper) 
    {
        component.set("v.page",1)
        helper.productSearch(component, event, helper);  
        
    },
    pageChange: function(component, event, helper) { 
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        component.set("v.page",page);
        //alert('page '+page);
        if(component.get("v.isSearch"))
        {
        	helper.productSearch(component, event, helper);
        }
        else
        {  
            helper.toGetTabData(component, event, helper);
        }
    },
    Shipcmp:function(component, event, helper) {
        component.set("v.parentcmp",false);
        component.set("v.isShipcmp",true);
    }
})