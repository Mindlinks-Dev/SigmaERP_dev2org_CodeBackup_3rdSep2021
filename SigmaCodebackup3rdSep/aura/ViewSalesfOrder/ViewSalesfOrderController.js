({
    doint : function(component, event, helper,page) 
    {
        //alert('dvchxjnc');
        var spinner = component.find('spinner');
        $A.util.toggleClass(spinner, "slds-hide"); 
        helper.fetchSO(component, event, helper,page);
    },
    pageChange: function(component, event, helper) {
        var spinner = component.find('spinner');
        $A.util.toggleClass(spinner, "slds-hide");
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        component.set("v.page",page);
        helper.fetchSO(component, event, helper,page);
    },
    
    handleSearchEvent : function(component, event) {
        var wrap = event.getParam("POList");
        var flag = event.getParam("flag");
        var type = event.getParam("type");
        var txt = event.getParam("searchtext");
        if(flag==true && type=='OrderHistory'){
            component.set('v.searchText',txt);
            component.set('v.SOresponse',wrap);
            component.set('v.total', wrap.totalRecords);
            component.set('v.page',	wrap.page);
            component.set('v.pages', Math.ceil(wrap.totalRecords/wrap.pageSize));
        }    
        else if(flag==false){
            var urlString = window.location.href;
            var eUrl= $A.get("e.force:navigateToURL");
            eUrl.setParams({
                "url": urlString 
            });
            eUrl.fire();
            //$A.get('e.force:refreshView').fire();
            //helper.fetchSO(component, event, helper,page);
        }
    }
    
})