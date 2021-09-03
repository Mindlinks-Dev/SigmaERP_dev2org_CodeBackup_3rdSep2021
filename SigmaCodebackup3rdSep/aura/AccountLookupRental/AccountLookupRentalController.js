({  
    doInit : function(cmp, event, helper) {   
        
        var action = cmp.get("c.getpaymenttype");
        var inputrentalstatus = cmp.find("paymenttype");
        var opts=[];
        action.setCallback(this, function(a) {
            opts.push({
                class: "optionClass",
                label: "--- None ---",
                value: ""
            });
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            inputrentalstatus.set("v.options", opts);
        });
        $A.enqueueAction(action);
        
        var savedOrderId = cmp.get("v.recordId");
        if(savedOrderId ==='Undefined' || savedOrderId==='')
        {        
            var isOrderID = cmp.get('v.orderSFId');
            var today = new Date();
            var month = today.getMonth() + 1;
            if(month >= 10){
                month = '';                    	       
            }else{
                month = 0;
            }
            var myDate = today.getDate();
            if(myDate >= 10){
                myDate = '';                    	       
            }else{
                myDate = 0;
            }        
            cmp.set('v.delivarydate', today.getFullYear() + "-"+month + (today.getMonth() + 1) + "-"+myDate + today.getDate());
        }
        else
        {   
            var isOrderID = savedOrderId;
            cmp.set('v.orderSFId',savedOrderId);  
        }
        if(isOrderID === 'undefined' || isOrderID === null || isOrderID === '' || isOrderID === undefined )
        {
            //alert('Order Id is undefined::'+isOrderID);
        }
        else
        {        
            helper.loadSavedOrders(cmp,event,isOrderID);   
        }       
        var toggleText = cmp.find("toggleProduct");    
        $A.util.addClass(toggleText, 'toggle');
        
        var productInfo = cmp.find("showProductToggle");
        $A.util.addClass(productInfo, 'toggle');      
        
        var tableList = cmp.find("tableListToogle");
        $A.util.addClass(tableList, 'toggle');          
        
        cmp.set('v.taxShow',false);   
        cmp.set('v.CreateCustomerShow',false);                 
        helper.fetchCurrency(cmp);
        
    },
    
    /**
     * Handler for receiving the updateLookupIdEvent event
     */
    handleAccountIdUpdate : function(cmp, event, helper) {
        var accountId = event.getParam("sObjectId");
        var customerAccountID = event.getParam("sObjectIdNew");
        var instanceId = event.getParam("instanceId");
        if (instanceId === "Supplier,Vendor")
        {
            cmp.set('v.recordId', accountId);
            cmp.set('v.recordName',instanceId);
            cmp.set('v.customerID',accountId);
        }
        else if(instanceId === "MyProduct")
        {          
            cmp.set('v.productId', accountId);
            cmp.set('v.productName',instanceId);
            helper.fetchProduct(cmp,accountId); 
            helper.fetchInventory(cmp,accountId);
        }      
            else if(instanceId === "MyContact")
            {
                cmp.set('v.CreatedbyID', accountId);
                cmp.set('v.CreatedbyName',instanceId);
            }
                else
                {
                    console.log('Unknown instance id: ' + instanceId);
                }
    },
    
    /**
     * Handler for receiving the clearLookupIdEvent event
     */
    handleAccountIdClear : function(cmp, event, helper) {
        var instanceId = event.getParam("instanceId");
        // Determine the instance Id of the component that fired the event
        if (instanceId === "MyAccount")
        {
            // Clear the Id bound to the View
            cmp.set('v.recordId', null);
        }
        else
        {
            console.log('Unknown instance id: ' + instanceId);
        }
    },
    
    showProduct : function(cmp,event,helper)
    {
        var deldate = cmp.get("v.delivarydate");
        var Today = new Date();
        var custNameComp = cmp.find("AccName");         
        var custName = custNameComp.get('v.searchString');
        if(custName === ''){
            alert('Please select a customer before adding products.');
            return null;
        }

        Today.setHours(0,0,0,0);
        var selecteddate = new Date(deldate);
        selecteddate.setHours(0,0,0,0);
        if(selecteddate<Today){
            alert('Past dates cannot be selected');
            return null;
        }
       
        var toggleText = cmp.find("toggleProduct");
        $A.util.removeClass(toggleText, 'toggle'); 
        var main = cmp.find("mainBlocktoggle");
        $A.util.addClass(main, 'toggle');      
        cmp.set('v.productName','');
    },
    
    handleProductObject : function(cmp,event,helper)
    {
        var productObj = event.getParam("productInfo");
        var productValue = event.getParam("productVal");
        var productQuantity = event.getParam("productQuantity");
        var productDiscount = event.getParam("ProductDiscount");
        var amountperinterval = event.getParam("amountperinterval");
        var productAmount = event.getParam("productAmount");
        var delivarydate = event.getParam("deliverydate");
        helper.PrepareProductList(cmp,event);
        cmp.set('v.showOrderLines',true);   
    },
    saveOrder : function(cmp,event,helper)
    {
        var productObj = cmp.get("v.prod");
        var accLookupId = cmp.get("v.recordId");
        var accRecordName = cmp.get("v.recordName");
        var billingPerson = cmp.get("v.billingPerson");
        
        if(productObj.length > 0) 
        {
            var bPersonName = cmp.get('v.recordName');
            var billingPersonName = cmp.get('v.CreatedBy');
            if(bPersonName === 'Undefined'  || bPersonName === null || bPersonName==='' || bPersonName.length <= 0)
            {
                alert('Please Select a Customer');    
            }
            else
            {
                helper.saveOrder(cmp);  
            }
        }
        else
        {
            alert('Please add some products to save.');
        }	   
        cmp.set('v.taxShow',false);
        cmp.set('v.showProductInfo',false);             
        cmp.set('v.CreateCustomerShow',false);  
    },
    
    goBack:function(cmp)
    {
        var toggleText = cmp.find("toggleProduct");
        $A.util.addClass(toggleText,'toggle');        
        var main = cmp.find("mainBlocktoggle");
        $A.util.removeClass(main, 'toggle');        
    },
    
    gotoTax : function(cmp,event,helper)
    {
        var productObj = cmp.get("v.prod");
        var bPersonName = cmp.get('v.recordName');
        var billingPersonName = cmp.get('v.CreatedBy');
        var delivarydate= cmp.get('v.delivarydate');
        var paymenttype = cmp.find("paymenttype");
        var paymenttypevalue =  paymenttype.get("v.value");
        var dateval= cmp.find('DateTime');
        
        cmp.set("v.paymenttype",paymenttypevalue);
        
        for(var i=0;i<productObj.length;i++)
        {
            for(var j=i+1;j<productObj.length;j++)
            {
                if(productObj[i].Name==productObj[j].Name)
                {
                    alert('Duplicate Product Exist! Remove the Line Item.');
                    return;
                }
            }           
        }                 
        var today = new Date();
        var todaydate = new Date(today.getFullYear()+ "-" +(today.getMonth() + 1)+ "-" + today.getDate());
        if( delivarydate!=null )
        {
            var someDate = new Date(delivarydate);
            var orderdate = new Date(someDate.getFullYear()+ "-" +(someDate.getMonth() + 1)+ "-" + someDate.getDate());
            if(orderdate < todaydate)  
            {
                dateval.set("v.errors", [{message:"Delivary Date Should be greater than or Equal to Today Date"}]);
                return null;
            }
            else
            {
                dateval.set("v.errors",null);
            }
        }      
        if(productObj.length > 0) 
        {           
            if(bPersonName === 'Undefined'  || bPersonName === null || bPersonName==='' || bPersonName.length <= 0)
            {
                alert('Please Select a Customer');             
            }
            else
            {
                helper.saveOrder(cmp);          
                var main = cmp.find("mainBlocktoggle");
                $A.util.addClass(main, 'toggle');              
                cmp.set('v.taxShow',true);
                cmp.set('v.CreateCustomerShow',false);               
            }
        }
        else
        {
            alert('Please add some products to proceed.');
        }		      
        document.getElementById("Accspinner").style.display = "block";
    },
    
    removeOrderLine : function(cmp,event,helper)
    {    
        if (confirm("Are you sure you want to delete this Product?") ) {
            var self = this;  // safe reference
            var index = event.target.dataset.index;              
            helper.removeOrderLineItem(cmp, index);
        }
        else {
            
        }        
    },     
    
    createNewCustomer : function(cmp, event, helper) {
        cmp.set('v.CreateCustomerShow',true);
        var toggleText = cmp.find("mainBlocktoggle");
        $A.util.addClass(toggleText, 'toggle');
    },    
    
    afterSaveCustomer : function(cmp, event, helper) {
        cmp.set('v.CreateCustomerShow',false);
        var toggleText = cmp.find("mainBlocktoggle");
        $A.util.removeClass(toggleText, 'toggle');    
    },
    
    viewSavedOrders : function (cmp, event, helper)
    {     
        var urlEvent = $A.get("e.sigmaerpdev:navigateToURL");     
        urlEvent.setParams({
            "url": "/01/o"
        });
        urlEvent.fire();         
    },
    
    showProductList : function(cmp, event, helper){                  
        var product_info = cmp.find("showProductToggle");
        $A.util.addClass(product_info,'toggle');                
        var toggleText = cmp.find("toggleProduct");
        $A.util.removeClass(toggleText, 'toggle');
        var productComp =  cmp.find("productName");       
    },
    
    showCreateOrders: function(cmp, event, helper){
        cmp.set('v.taxShow',false);
        var main = cmp.find("mainBlocktoggle");
        $A.util.removeClass(main, 'toggle');            
    },
    
    recordCreatedOK: function(component, event, helper) {
        document.getElementById("Accspinner").style.display = "none";
        var successAlert = component.find("successAlert");
        $A.util.addClass(successAlert,'slds-hide');             
    },
    
    recordCreatedCancel: function(component, event, helper) {
        document.getElementById("Accspinner").style.display = "none";
        var successAlert = component.find("successAlert");
        $A.util.addClass(successAlert,'slds-hide');      
    },
    
    cancel: function (component, event, helper) {
        window.location.reload();        
    }
})