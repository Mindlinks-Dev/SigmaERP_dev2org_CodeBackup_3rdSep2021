({
    fetchOrderDetails : function(component, event, orderIdFromComponent) 
    {
		var localvar = component.get("v.isStandardOrder");
		//alert('localvar in fetchOrderDetails::'+localvar);
		if(localvar == true)
		{
			var action = component.get("c.getstandProductList");
			var inputsel = component.find("ProductSelectSelectDynamic");
			var opts=[];
			action.setParams
				({
				"OrderId" : orderIdFromComponent
				});
			action.setCallback(this, function(a) 
			{
				var savedOrderDetails = a.getReturnValue();
				if(savedOrderDetails.length===0)
				{

						var toastEvent = $A.get("e.force:showToast");

						toastEvent.setParams({
						"title": "Success!",

						"message": "You cannot cancel this order.!"
						});
					component.set("v.showCompleteOrderButton",true);
					toastEvent.fire(); 

				}
				else
				{
					opts.push({"class": "optionClass", label: "Select a product", value: null});
					for(var i=0;i< savedOrderDetails.length;i++)
					{
						opts.push({"class": "optionClass", label: savedOrderDetails[i], value: savedOrderDetails[i]});
					}
					inputsel.set("v.options", opts);
				}

			});
			$A.enqueueAction(action);
			this.loadOrderName(component,event);
			var action2 = component.get("c.getstandOrderProductDetails");
			action2.setParams
			({
				"OrderId" : orderIdFromComponent
			});        
			action2.setCallback(this, function(a2) 
            {
              var savedOrderDetails = a2.getReturnValue();
              component.set("v.OrderPriceBookList", savedOrderDetails); 
            });
			$A.enqueueAction(action2);
			this.loadPaymentMode(component,event,"Partial");
			var spinners = component.find('spinner');
			$A.util.removeClass(spinners, 'slds-show'); 
		}
		else
		{
           // alert('inside else ');
			var action = component.get("c.getProductList");
			var inputsel = component.find("ProductSelectSelectDynamic");
			var opts=[];
			action.setParams
				({
				"OrderId" : orderIdFromComponent
				});
			action.setCallback(this, function(a) 
			{
				var savedOrderDetails = a.getReturnValue();
                //alert('savedata'+JSON.stringify(savedOrderDetails));
				if(savedOrderDetails.length===0)
				{
					var toastEvent = $A.get("e.force:showToast");

					toastEvent.setParams({
					"title": "Success!","message": "You cannot cancel this order.!"
					});
					component.set("v.showCompleteOrderButton",true);
					toastEvent.fire(); 

				}
				else
				{
					opts.push({"class": "optionClass", label: "Select a product", value: null});
					for(var i=0;i< savedOrderDetails.length;i++)
					{
						opts.push({"class": "optionClass", label: savedOrderDetails[i], value: savedOrderDetails[i]});
					}
					inputsel.set("v.options", opts);
				}

			});
			$A.enqueueAction(action);
			this.loadOrderName(component,event);
			var action2 = component.get("c.getOrderProductDetails");
			action2.setParams
			({
				"OrderId" : orderIdFromComponent
			});        
			action2.setCallback(this, function(a2) 
			{
                var savedOrderDetails = a2.getReturnValue();
                component.set("v.OrderPriceBookList", savedOrderDetails); 
				
            });
			$A.enqueueAction(action2);
			this.loadPaymentMode(component,event,"Partial");
			var spinners = component.find('spinner');
			$A.util.removeClass(spinners, 'slds-show'); 
		}
        
    },
	
    fetchTotalAmount : function (component, event, selectedProduct)
    {
        var OrderPriceBooks = component.get("v.OrderPriceBookList");
        for(var i=0;i<OrderPriceBooks.length;i++)
        {
            if(selectedProduct === OrderPriceBooks[i].Product__r.Name)
            {
                var tempTotalAmount;
                if(OrderPriceBooks[i]. sigmaerpdev2__Subtotal__c !== "0.00" ||OrderPriceBooks[i]. sigmaerpdev2__Subtotal__c !== "")
                {
                    tempTotalAmount = (OrderPriceBooks[i]. sigmaerpdev2__Subtotal__c - 0.01).toFixed(2);
                }
                else
                {
                    tempTotalAmount = (OrderPriceBooks[i]. sigmaerpdev2__Subtotal__c).toFixed(2);
                }
                component.set("v.TotalAmount",tempTotalAmount);
                component.set("v.quantityToRefund",OrderPriceBooks[i]. sigmaerpdev2__Quantity__c);                
            }
        }
    },
    partialCashRefundFlow : function(component,event,selectedProduct)
    {
       // alert('Callingpartialpaid');
         var OrderPriceBooks = component.get("v.OrderPriceBookList");
        var orderIdFromComponent = component.get("v.Id");
        for(var i=0;i<OrderPriceBooks.length;i++)
        {
            if(selectedProduct === OrderPriceBooks[i]. sigmaerpdev2__Product__r.Name)
            {
                if(OrderPriceBooks[i]. sigmaerpdev2__Order_Status__c !== "Canceled")
                {
                    var spinner = component.find('spinner');
                    $A.util.addClass(spinner, "slds-show");
                    var action1 = component.get("c.partialCashRefund");
                    action1.setParams
                    ({
                        "OrderId" : orderIdFromComponent,
                        "productId" : OrderPriceBooks[i]. sigmaerpdev2__Product__c,
                        "selectedQuantity" : OrderPriceBooks[i]. sigmaerpdev2__Quantity__c,
                        "subTotalAmount" : OrderPriceBooks[i]. sigmaerpdev2__Subtotal__c
                    });
                    action1.setCallback(this, function(a1) 
                                        {
                                            var savedOrderDetails = a1.getReturnValue();
                                            var state = a1.getState();
                                            var spinner44 = component.find('spinner');
                                            $A.util.removeClass(spinner44, "slds-show");
                                            if(savedOrderDetails)
                                            {
                                                alert('Partial cash refund successful');
                                                location.reload();
                                            }
                                            else
                                            {
                                                alert('Partial cash refund failed');
                                            }
                                        });
                    $A.enqueueAction(action1);
                }
                else
                {
                    alert('This product has already been refunded');
                }
            }
        }
    },
    partialChequeRefundFlow: function(component,event,selectedProduct)
    {
        var OrderPriceBooks = component.get("v.OrderPriceBookList");
        var orderIdFromComponent = component.get("v.Id");
        for(var i=0;i<OrderPriceBooks.length;i++)
        {
            if(selectedProduct === OrderPriceBooks[i]. sigmaerpdev2__Product__r.Name)
            {
                if(OrderPriceBooks[i]. sigmaerpdev2__Order_Status__c !== "Canceled")
                {
                    var spinner33 = component.find('spinner');
                    $A.util.addClass(spinner33, "slds-show");
                    var action1 = component.get("c.partialChequeRefund");
                    action1.setParams
                    ({
                        "OrderId" : orderIdFromComponent,
                        "productId" : OrderPriceBooks[i]. sigmaerpdev2__Product__c,
                        "selectedQuantity" : OrderPriceBooks[i]. sigmaerpdev2__Quantity__c,
                        "subTotalAmount" : OrderPriceBooks[i]. sigmaerpdev2__Subtotal__c
                    });
                    action1.setCallback(this, function(a1) 
                                        {
                                            var spinner22 = component.find('spinner');
                                            $A.util.removeClass(spinner22, "slds-show");
                                            var state = a1.getState();
                                           var savedOrderDetails = a1.getReturnValue();
                                            if(savedOrderDetails)
                                            {
                                                alert('Partial cheque refund successful');
                                                location.reload();
                                            }
                                            else
                                            {
                                                alert('Partial cheque refund failed ');
                                            }
                                        });
                    $A.enqueueAction(action1);
                }
                else
                {
                    alert("This product has already been refunded");
                }
            }
        }        
    },
    partialVoucherRefundFlow : function(component,event,selectedProduct)
    {
        var OrderPriceBooks = component.get("v.OrderPriceBookList");
        var orderIdFromComponent = component.get("v.Id");
        
        for(var i=0;i<OrderPriceBooks.length;i++)
        {
            if(selectedProduct === OrderPriceBooks[i]. sigmaerpdev2__Product__r.Name)
            {
                if(OrderPriceBooks[i]. sigmaerpdev2__Order_Status__c !== "Canceled")
                {
                    var spinner = component.find('spinner');
                    $A.util.addClass(spinner, "slds-show");
                    var action1 = component.get("c.partialVoucherRefund");
                    action1.setParams
                    ({
                        "OrderId" : orderIdFromComponent,
                        "productId" : OrderPriceBooks[i]. sigmaerpdev2__Product__c,
                        "selectedQuantity" : OrderPriceBooks[i]. sigmaerpdev2__Quantity__c,
                        "subTotalAmount" : OrderPriceBooks[i]. sigmaerpdev2__Subtotal__c
                    });
                    action1.setCallback(this, function(a1) 
                                        {
                                            var spinner11 = component.find('spinner');
                                            $A.util.removeClass(spinner11, "slds-show");
                                            var state = a1.getState();
                                            var savedOrderDetails = a1.getReturnValue();
                                            if(savedOrderDetails)
                                            {
                                                alert('Partial voucher refund successful ');
                                                location.reload();
                                            }
                                            else
                                            {
                                                alert('Partial voucher refund failed');
                                            }
                                        });
                    $A.enqueueAction(action1);
                }
                else
                {
                    alert('This product has already been refunded');
                }
            }
        }        
    },
    partialCardRefundFlow : function(component,event,selectedProduct)
    {
        var OrderPriceBooks = component.get("v.OrderPriceBookList");
        var orderIdFromComponent = component.get("v.Id");
        for(var i=0;i<OrderPriceBooks.length;i++)
        {
            if(selectedProduct === OrderPriceBooks[i]. sigmaerpdev2__Product__r.Name)
            {
                if(OrderPriceBooks[i]. sigmaerpdev2__Order_Status__c !== "Canceled")
                {
                    var spinner = component.find('spinner');
                    $A.util.addClass(spinner, "slds-show");
                    var action1 = component.get("c.partialCardRefund");
                    var tempTotalAmount; 
                    
                    if(OrderPriceBooks[i]. sigmaerpdev2__Subtotal__c !== "0.00" ||OrderPriceBooks[i]. sigmaerpdev2__Subtotal__c !== "")
                    {
                        tempTotalAmount = (OrderPriceBooks[i]. sigmaerpdev2__Subtotal__c - 0.01).toFixed(2);
                    }
                    else
                    {
                        tempTotalAmount = (OrderPriceBooks[i]. sigmaerpdev2__Subtotal__c).toFixed(2);
                    }
                    
                    action1.setParams
                    ({
                        "OrderId" : orderIdFromComponent,
                        "productId" : OrderPriceBooks[i]. sigmaerpdev2__Product__c,
                        "selectedQuantity" : OrderPriceBooks[i]. sigmaerpdev2__Quantity__c,
                        "subTotalAmount" : tempTotalAmount
                    });
                    action1.setCallback(this, function(a1) 
                                        {
                                            var spinner1 = component.find('spinner');
                                            $A.util.removeClass(spinner1, "slds-show");
                                            var state = a1.getState();
                                            var savedOrderDetails = a1.getReturnValue();
                                            if(savedOrderDetails)
                                            {
                                                alert('Partial card refund successful ');
                                                location.reload();
                                            }
                                            else
                                            {
                                                alert('Partial card refund failed ');
                                            }
                                        });
                    $A.enqueueAction(action1);
                }
                else
                {
                    alert('This product has already been refunded');
                }
            }
        }        
    },
    loadCompleteOrderPage : function (component, event)
    {
        this.loadPaymentMode(component,event,"Complete");
        if(component.get("v.OrderObject. sigmaerpdev2__Orders_Status__c") === "Canceled")
        {
            component.set("v.CompleteAmountToRefund","0.00");
        }
      
        
        var spinners = component.find('spinner');
        $A.util.removeClass(spinners, 'slds-show');
    },
    
    loadPaymentMode : function(component, event, refundType)
    {
        var orderIdFromComponent = component.get("v.Id");
		var localvar = component.get("v.isStandardOrder");
		//alert('localvar::'+localvar);
		if(localvar == true)
		{
			//alert('localvar::'+localvar);
			var action3 = component.get("c.getstandPaymentMode");
			action3.setParams
			({
				"OrderId" : orderIdFromComponent
			});        
			action3.setCallback(this, function(a3) 
            {
                                var savedOrderDetails = a3.getReturnValue();   
                               if(savedOrderDetails. sigmaerpdev2__Payment_Mode__c === "Cash" || savedOrderDetails. sigmaerpdev2__Payment_Mode__c === "CASH" )
                                {
                                    if(refundType === "Partial")
                                    {
                                        
                                        var popover = component.find("cashRefundbutton");
                                        $A.util.removeClass(popover,'slds-hide');
                                       
                                    }
                                    else
                                    {
                                       
                                        var popover1 = component.find("cashRefundbuttonInComplete");
                                        $A.util.removeClass(popover1,'slds-hide');
                                       
                                    }
                                }
                                else if(savedOrderDetails. sigmaerpdev2__Payment_Mode__c === "Card" || savedOrderDetails. sigmaerpdev2__Payment_Mode__c === "CARD" )
                                {
                                    if(refundType === "Partial")
                                    {
                                        var popover7 = component.find("cardRefundbutton");
                                        $A.util.removeClass(popover7,'slds-hide');
                                        
                                    }
                                    else
                                    {
                                        
                                        var popover2 = component.find("cardRefundbuttonInComplete");
                                        $A.util.removeClass(popover2,'slds-hide');
                                       
                                    }
                                }
                                    else if(savedOrderDetails. sigmaerpdev2__Payment_Mode__c === "Cheque"  || savedOrderDetails. sigmaerpdev2__Payment_Mode__c === "CHEQUE" )
                                    {
                                        if(refundType === "Partial")
                                        {
                                            var popover3 = component.find("chequeRefundbutton");
                                            $A.util.removeClass(popover3,'slds-hide');
                                            
                                        }
                                        else
                                        {
                                            var popover4 = component.find("chequeRefundbuttonInComplete");
                                            $A.util.removeClass(popover4,'slds-hide');
                                            
                                        }
                                    }
            });
			$A.enqueueAction(action3);
		}
		else 
		{
			//alert('localvar in else::'+localvar);
			var action3 = component.get("c.getPaymentMode");
			action3.setParams
			({
				"OrderId" : orderIdFromComponent
			});        
			action3.setCallback(this, function(a3) 
                            {
                                var savedOrderDetails = a3.getReturnValue();   
                               if(savedOrderDetails. sigmaerpdev2__Payment_Mode__c === "Cash" || savedOrderDetails. sigmaerpdev2__Payment_Mode__c === "CASH" )
                                {
                                    if(refundType === "Partial")
                                    {
                                        
                                        var popover = component.find("cashRefundbutton");
                                        $A.util.removeClass(popover,'slds-hide');
                                       
                                    }
                                    else
                                    {
                                       
                                        var popover1 = component.find("cashRefundbuttonInComplete");
                                        $A.util.removeClass(popover1,'slds-hide');
                                       
                                    }
                                }
                                else if(savedOrderDetails. sigmaerpdev2__Payment_Mode__c === "Card" || savedOrderDetails. sigmaerpdev2__Payment_Mode__c === "CARD" )
                                {
                                    if(refundType === "Partial")
                                    {
                                        var popover7 = component.find("cardRefundbutton");
                                        $A.util.removeClass(popover7,'slds-hide');
                                        
                                    }
                                    else
                                    {
                                        
                                        var popover2 = component.find("cardRefundbuttonInComplete");
                                        $A.util.removeClass(popover2,'slds-hide');
                                       
                                    }
                                }
                                    else if(savedOrderDetails. sigmaerpdev2__Payment_Mode__c === "Cheque"  || savedOrderDetails. sigmaerpdev2__Payment_Mode__c === "CHEQUE" )
                                    {
                                        if(refundType === "Partial")
                                        {
                                            var popover3 = component.find("chequeRefundbutton");
                                            $A.util.removeClass(popover3,'slds-hide');
                                            
                                        }
                                        else
                                        {
                                            var popover4 = component.find("chequeRefundbuttonInComplete");
                                            $A.util.removeClass(popover4,'slds-hide');
                                            
                                        }
                                    }
                            });
        $A.enqueueAction(action3);
		}
    },
    loadOrderName : function (component,event)
    {
        
        var orderIdFromComponent = component.get("v.recordId");
			//alert('orderIdFromComponentrecid::'+JSON.stringify(component.get("v.recordId")));
			//alert('orderIdFromComponent1::'+component.get(orderIdFromComponent));
		var localvar = component.get("v.isStandardOrder");
	      //alert('localvar::loadOrderName'+localvar);
		if(localvar == true )
		{
           // alert('Inside::>>');
			var action1 = component.get("c.getstandOrderDetails");
			action1.setParams
			({
				"OrderId" : orderIdFromComponent
			});
			action1.setCallback(this, function(a1) 
                            {
                                var savedOrderDetails = a1.getReturnValue();
                                //alert('savedOrderDetails>>'+JSON.stringify(savedOrderDetails));
                                var state = a1.getState();
                               component.set("v.OrderstandObject.OrderNumber", savedOrderDetails.OrderNumber); 
								//alert('OrderNumber::'+JSON.stringify(component.get("v.OrderstandObject.OrderNumber")));
                                component.set("v.OrderstandObject. sigmaerpdev2__TotalAmount__c",savedOrderDetails. sigmaerpdev2__TotalAmount__c);
                               // alert(' sigmaerpdev2__TotalAmount__c::'+JSON.stringify(component.get("v.OrderstandObject. sigmaerpdev2__TotalAmount__c")));
								component.set("v.OrderstandObject. sigmaerpdev2__Orders_Status__c",savedOrderDetails. sigmaerpdev2__Orders_Status__c);
                               // alert(''+JSON.stringify(component.get("v.OrderstandObject. sigmaerpdev2__Orders_Status__c")));
                            });
				$A.enqueueAction(action1);
		}
		else{
			var action1 = component.get("c.getOrderDetails");
			action1.setParams
			({
				"OrderId" : orderIdFromComponent
			});
			action1.setCallback(this, function(a1) 
                            {
                                var savedOrderDetails = a1.getReturnValue();
                                var state = a1.getState();
                               component.set("v.OrderObject.Name", savedOrderDetails.Name); 
                                component.set("v.OrderObject. sigmaerpdev2__TotalAmount__c",savedOrderDetails. sigmaerpdev2__TotalAmount__c);
                                component.set("v.OrderObject. sigmaerpdev2__Orders_Status__c",savedOrderDetails. sigmaerpdev2__Orders_Status__c);
                                //alert('OrderNumber::'+JSON.stringify(component.get("v.OrderObject.Name")));
                                //alert(' sigmaerpdev2__TotalAmount__c::'+JSON.stringify(component.get("v.OrderObject. sigmaerpdev2__TotalAmount__c")));
								//alert(''+JSON.stringify(component.get("v.OrderObject. sigmaerpdev2__Orders_Status__c")));
                           
                            });
			$A.enqueueAction(action1);
		}
        
    },
    CompleteCashRefundFlow : function(component,event)
    {        
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, "slds-show");
        var action1 = component.get("c.completeCashRefund");
        var orderIdFromComponent = component.get("v.Id");
       // alert('orderIdFromComponent::'+JSON.stringify(component.get("v.Id")));
        var SubTotalAmount = component.get("v.CompleteAmountToRefund");
       // alert('SubTotalAmount::'+JSON.stringify(component.get("v.CompleteAmountToRefund")));
        action1.setParams
        ({
            "OrderId" : orderIdFromComponent,
            "subTotalAmount" : SubTotalAmount
        });
        action1.setCallback(this, function(a1) 
                            {
                                var spinner2 = component.find('spinner');
                                $A.util.removeClass(spinner2, "slds-show");
                                var savedOrderDetails = a1.getReturnValue();
                                var state = a1.getState();
                                //alert('sucess::'+state);
                                //alert('savedOrderDetails::'+savedOrderDetails);
                                if(savedOrderDetails)
                                {
                                    alert("Complete cash refund successful ");
                                    location.reload();
                                }
                                else
                                {
                                    alert("Complete cash refund failed ");
                                }
                            });
        document.getElementById("Accspinner").style.display = "block";
        $A.enqueueAction(action1);
    },
    CompleteChequeRefundFlow : function(component,event)
    {        
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, "slds-show");
        var action1 = component.get("c.completeChequeRefund");
        var orderIdFromComponent = component.get("v.Id");
        var SubTotalAmount = component.get("v.CompleteAmountToRefund");
        action1.setParams
        ({
            "OrderId" : orderIdFromComponent,
            "subTotalAmount" : SubTotalAmount
        });
        action1.setCallback(this, function(a1) 
                            {
                                var spinner1 = component.find('spinner');
                                $A.util.removeClass(spinner1, "slds-show");
                                var state = a1.getState();
                                 var savedOrderDetails = a1.getReturnValue();
                                if(savedOrderDetails)
                                {
                                    alert("Complete cheque refund successful ");
                                    location.reload();
                                }
                                else
                                {
                                    alert("Complete cheque refund failed ");
                                }
                            });
        document.getElementById("Accspinner").style.display = "block";
        $A.enqueueAction(action1);
    },
    CompleteVoucherRefundFlow : function(component,event)
    {        
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, "slds-show");
        var action1 = component.get("c.completeVoucherRefund");
        var orderIdFromComponent = component.get("v.Id");
        var SubTotalAmount = component.get("v.CompleteAmountToRefund");
        action1.setParams
        ({
            "OrderId" : orderIdFromComponent,
            "subTotalAmount" : SubTotalAmount
        });
        action1.setCallback(this, function(a1) 
                            {
                                var spinner55 = component.find('spinner');
                                $A.util.removeClass(spinner55, "slds-show");
                                var state = a1.getState();
                               var savedOrderDetails = a1.getReturnValue();
                                if(savedOrderDetails)
                                {
                                    alert('Complete voucher refund successful');   
                                    location.reload();
                                }
                                else
                                {
                                    alert('Complete voucher refund failed');
                                }
                            });
        document.getElementById("Accspinner").style.display = "block";
        $A.enqueueAction(action1);
    },
    CompleteCardRefundFlow : function(component,event)
    {    
        
        var spinner66 = component.find('spinner');
        $A.util.addClass(spinner66, "slds-show");
        var action1 = component.get("c.completeCardRefund");
        var orderIdFromComponent = component.get("v.Id");
        var SubTotalAmount = component.get("v.CompleteAmountToRefund");
        action1.setParams
        ({
            "OrderId" : orderIdFromComponent,
            "subTotalAmount" : SubTotalAmount
        });
        action1.setCallback(this, function(a1) 
                            {
                                var spinner77 = component.find('spinner');
                                $A.util.removeClass(spinner77, "slds-show");
                                var state = a1.getState();
                               var savedOrderDetails = a1.getReturnValue();
                                if(savedOrderDetails)
                                {
                                    alert('Complete card refund successful');
                                    location.reload();
                                }
                                else
                                {
                                    alert('Complete card refund failed');
                                }
                            });
        document.getElementById("Accspinner").style.display = "block";
        $A.enqueueAction(action1);
    }
    
    
})