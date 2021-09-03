({
    doInit: function (component, event, helper){                
        //hide or show Check stock after coming from details tab - if autopick was done earlier- added on 26/8/2019        
        component.set("v.autopickRev", false);
        //ends here 
        
        var status = component.get('v.isStockReservedStock');        
        if(status){
            var action3 = component.get("c.viewReservedStock");
            action3.setParams({
                "manufactureRunObj": component.get("v.manfObj")
            });
            action3.setCallback(this, function (response1) {
                var response = response1.getReturnValue();
                component.set("v.orderItemNewForView", response);
            });
            $A.enqueueAction(action3);
        }
    },    

    showStock: function (component, event, helper) {        
        helper.showStockH(component, event, helper);
    },

    editReservedStock : function(component, event, helper){
        helper.editReservedStockH(component, event, helper);
    },

    reserveStock: function (component, event, helper) {
        var myWrapList = component.get("v.orderItemNew");
        var innerListWrap = myWrapList[0].mainWrapProdList;
        var t = [];
        var tempSelQuantity = 0;

        for (var i = 0; i < innerListWrap.length; i++) {            
            for (var j = 0; j < innerListWrap[i].wrapProdList.length; j++) {
                if (innerListWrap[i].wrapProdList[j] != undefined) {
                    if (innerListWrap[i].wrapProdList[j].selQuantity != undefined && innerListWrap[i].wrapProdList[j].selQuantity != '' && innerListWrap[i].wrapProdList[j].selQuantity != null) {
                        tempSelQuantity = tempSelQuantity + parseFloat(innerListWrap[i].wrapProdList[j].selQuantity);
                    }
                }
            }
            t.push(innerListWrap[i]);
        }

        //added for validation if Autopick or Select Stock is not selected and directly reserved stock button is clicked.
        if(tempSelQuantity == 0){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"error",
                "title": "Warning!",
                "message": "Autopick or Select Stock for the manufacturing run products before reserving the Stock."
            });
            toastEvent.fire();
            return;
        }
        //ends here
       
        //added for validation of picked quantity field for Select Stock
        var prodId;
        for (var i = 0; i < innerListWrap.length; i++){ 
            prodId = innerListWrap[i].prodId;            
            var selStockVal = 0.0;
            if(innerListWrap[i].allocatedViaAutopickOrManual == false && prodId == innerListWrap[i].prodId) {               
                for (var j = 0; j<innerListWrap[i].wrapProdList.length; j++){ 
                    if (innerListWrap[i].wrapProdList[j].selQuantity != undefined && innerListWrap[i].wrapProdList[j].selQuantity != '' && innerListWrap[i].wrapProdList[j].selQuantity != null) {                                                
                        selStockVal = parseFloat(selStockVal) + parseFloat(innerListWrap[i].wrapProdList[j].selQuantity);                                              
                    }
                } 
                var reqQnt = innerListWrap[i].requiredQnt; 
                if(selStockVal == 0.0){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Warning!",
                        "message": "Enter value for picked quantity field for the Product : \""+ innerListWrap[i].prodName +"\"."
                    });
                    toastEvent.fire();
                    return;   
                }else if(selStockVal < reqQnt){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Warning!",
                        "message": "Selected Stock quantity for the Product \""+ innerListWrap[i].prodName+"\" is lesser than the required quantity."
                    });
                    toastEvent.fire();
                    return;
                }else if(selStockVal > reqQnt){
                    var toastEvent = $A.get("e.force:showToast"); 
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Warning!",
                        "message": "Selected Stock quantity for the Product \""+ innerListWrap[i].prodName+"\" is greater than the required quantity."
                    });
                    toastEvent.fire();
                    return;
                }
            }    
        } 
        //ends here      
        innerListWrap = t;
        
        $.confirm({
                title: 'Are you sure?',
                content: 'You want to reserve the stock.',
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
                                    helper.reserveStockH(component, event, helper);     
                                }), 5
                            );                              
                        }						                      
                    },
                    No: function () {                        
                    },
                }
            });        
       
    },
    
    AutoReserveStock: function (component, event, helper) {
        $.confirm({
            title: 'Are you sure you want to reserve the stock automatically?',
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
                                helper.AutoReserveStockH(component, event, helper);
                            }), 500
                        );
                    }
                },
                No: function () {
                },
            }
        });
    },

    showResvStockBtn: function (component, event, helper) {        
        helper.showReserveStockBtnH(component, event, helper);
    },

    ShowReservedStock: function (component, event, helper) {       
        helper.showReservedStockH(component, event, helper);
    },

    ViewOrDownloadReservedStockPDF: function (component, event, helper) {           
        helper.vieworDownloadPDFH(component, event, helper);
    },
    
    requiredQtyChanged : function(component, event, helper){
        var showStock = component.find('showRow');
		$A.util.addClass(showStock, "slds-hide");
        component.set("v.showAutoResvBtn", false);
    },
    
    callChildMethod : function(component, event, helper) {        
        var showStock = component.find('showRow');
		$A.util.addClass(showStock, "slds-hide");
    }

})