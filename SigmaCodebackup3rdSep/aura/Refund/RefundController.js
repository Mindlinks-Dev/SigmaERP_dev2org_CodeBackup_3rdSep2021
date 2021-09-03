({
    doInit : function(component, event, helper) 
    { 
     
        var OrderID= component.get("v.recordId");
        //  alert('OrderID::'+OrderID);
        //new code to support for standared object getstandOrder()-------------start
        // By-forgation in standard and custom setting by chandana 
        var ordertype = component.get("c.CheckOrder");
        //  alert(JSON.stringify(ordertype));
        
        ordertype.setCallback( this, function(response1) 
                              {
                                  var state = response1.getState();
                                 // alert('state1>>>'+state);
                                  if (state === "SUCCESS")
                                  {
                                      var res = response1.getReturnValue();
                                      
                                      component.set("v.OrderUsageSigma",res. sigmaerpdev2__Sigma_order__c);
                                      component.set("v.OrderUsageStand",res. sigmaerpdev2__Standard_object__c);
                                      //alert('Sigma Order'+component.get("v.OrderUsageSigma"));
                                     // alert('StandOrder'+component.get("v.OrderUsageStand"));
                                      
                                      if(res. sigmaerpdev2__Standard_object__c == true)
                                      {
                                          //added by sandhya for validations
                                          var CheckOrd1 = component.get("v.OrderUsageSigma");
                                          if(CheckOrd1){
                                              var msg = "Please Check Standard Order in custom settings";
                                              component.set("v.errorMsg", msg);
                                              component.set("v.isError",true);
                                              return; 
                                          }else{
                                              component.set("v.isError",false);
                                              component.set("v.errorMsg", "");
                                          }
                                          // end here
                                          //alert('inside if stand order flow in refund flow ');
                                          component.set("v.isStandardOrder",true);
                                          var action1 = component.get("c.getstandOrder");
                                          var flagSQ = 0;
                                          var flagDQ = 0;
                                          var flagRS = 0;
                                          action1.setParams
                                          ({
                                              "OrderId" : OrderID
                                          });
                                          
                                          action1.setCallback(this, function(a1) 
                                                              {
                                                                  var savedOrderDetails = a1.getReturnValue();
                                                                   var creditamount=0;
                                                                  //alert('savedetails::'+JSON.stringify(savedOrderDetails));
                                                                  var state = a1.getState();
                                                                 // alert('state2::'+state);
                                                                  if(state === "SUCCESS")
                                                                  {
                                                                      for(var i=0;i<savedOrderDetails.OrderItems.length;i++)
                                                                      {
                                                                          if(savedOrderDetails.OrderItems[i]. sigmaerpdev2__Is_Credit_Updated__c)
                                                                          {
                                                                               creditamount += savedOrderDetails.OrderItems[i]. sigmaerpdev2__TotalPrice__c;
                                                                          }
                                                                          var shipqty  = savedOrderDetails.OrderItems[i]. sigmaerpdev2__Shipped_Quantity__c;
                                                                          var delqty = savedOrderDetails.OrderItems[i]. sigmaerpdev2__Delivired__c;
                                                                          if(savedOrderDetails.OrderItems[i]. sigmaerpdev2__Shipped_Quantity__c > 0){
                                                                              flagSQ = 1;
                                                                              break;
                                                                          }
                                                                          if(savedOrderDetails.OrderItems[i]. sigmaerpdev2__Delivired__c > 0 && savedOrderDetails.OrderItems[i]. sigmaerpdev2__Inventory_Status__c=='Reserve'){
                                                                              flagDQ = 1;
                                                                              break;
                                                                          } 
                                                                           if(savedOrderDetails.OrderItems[i]. sigmaerpdev2__Order_Status__c =='Ready To Ship'){
                                                                              flagRS = 1;
                                                                              break;
                                                                          }
                                                                      }
                                                                      if(creditamount>0)
                                                                      {
                                                                          component.set("v.CredituserAmount", creditamount);
                                                                      }
                                                                      if(flagSQ == 1)
                                                                      {
                                                                          var msg = "Unable to process Refund as Order got Shipped";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                          
                                                                      }
                                                                       if(flagDQ == 1)
                                                                      {
                                                                          var msg = "Unable to process Refund as Order got Delivered";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                          
                                                                      }
                                                                       if(flagRS == 1)
                                                                      {
                                                                          
                                                                          var msg = "Unable to process Refund as Order is InShipment";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                          
                                                                      }
                                                                      if(savedOrderDetails. sigmaerpdev2__No_Picking_Package_Shipment_Required__c)
                                                                      {
                                                                          var msg = "Unable to process Refund as No Pick,Pack,Ship Checkbox is true";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                      }
                                                                     // alert('amount in side checkso::'+savedOrderDetails. sigmaerpdev2__Net_Amount__c );
                                                                      //if(savedOrderDetails. sigmaerpdev2__Orders_Status__c !=null && savedOrderDetails. sigmaerpdev2__Orders_Status__c != undefined)
                                                                      component.set("v.orderStatus",savedOrderDetails. sigmaerpdev2__Orders_Status__c);
                                                                      component.set("v.Customertype",savedOrderDetails. sigmaerpdev2__Customer_Type__c);
                                                                     // alert(component.get("v.Customertype"));
                                                                      if(savedOrderDetails. sigmaerpdev2__Order_Created_Via__c=='Time Based Inventory')
                                                                      {
                                                                          var msg = "You Can't Refund Time Base Inventory Order.";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                      }
                                                                      else{
                                                                          component.set("v.isError",false);
                                                                          component.set("v.errorMsg", "");
                                                                      }
                                                                      if(savedOrderDetails. sigmaerpdev2__Net_Amount__c!=undefined)
                                                                      {
                                                                         component.set("v.CompleteAmountToRefund",savedOrderDetails. sigmaerpdev2__Net_Amount__c);
                                                                         // alert('after order set1::'+JSON.stringify(component.get("v.CompleteAmountToRefund",savedOrderDetails. sigmaerpdev2__TotalAmount__c)));
                                                                          
                                                                      }
                                                                      else
                                                                      {
                                                                          component.set("v.CompleteAmountToRefund",savedOrderDetails. sigmaerpdev2__Net_Amount__c);
                                                                          //alert('after order set2::'+JSON.stringify(component.get("v.CompleteAmountToRefund",savedOrderDetails. sigmaerpdev2__Net_Amount__c)));
                                                                          
                                                                      }
                                                                      var ordrstus = component.get("v.orderStatus");
                                                                      
                                                                      if(ordrstus == 'Order Confirmed' && savedOrderDetails. sigmaerpdev2__Due_Amount__c<=0)
                                                                      {
                                                                          var orderIdFromComponent = OrderID;
                                                                          component.set("v.Id",OrderID);
                                                                          
                                                                          var spinner = component.find('spinner');
                                                                          $A.util.addClass(spinner, "slds-show");
                                                                          var popover = component.find("IdForCompleteOrderRefund");
                                                                          $A.util.addClass(popover,'slds-hide');
                                                                          popover = component.find("PartialRefundFlow");
                                                                          $A.util.addClass(popover,'slds-hide');
                                                                          popover = component.find("IdForPartialOrderRefund");
                                                                          $A.util.removeClass(popover,'slds-hide');
                                                                          popover = component.find("CompleteRefundFlow");
                                                                          $A.util.removeClass(popover,'slds-hide');
                                                                          helper.fetchOrderDetails(component, event, orderIdFromComponent);
                                                                          helper.loadCompleteOrderPage(component,event);
                                                                      }
                                                                      else{
                                                                          //alert('inside else'+savedOrderDetails. sigmaerpdev2__Due_Amount__c);
                                                                          if(ordrstus == 'Canceled')
                                                                          {
                                                                              var msg = "Unable to process Refund as Order got cancelled";
                                                                              component.set("v.errorMsg", msg);
                                                                              component.set("v.isError",true);
                                                                              return;
                                                                          }
                                                                          else if((ordrstus == 'Order Confirmed' && savedOrderDetails. sigmaerpdev2__Due_Amount__c>0) || ordrstus == 'Pending')
                                                                          {
                                                                              var msg = "Please make complete payment.";
                                                                              component.set("v.errorMsg", msg);
                                                                              component.set("v.isError",true);
                                                                              return;
                                                                          }
                                                                          
                                                                      }
                                                                  }
                                                                  else
                                                                  {
                                                                      var msg = "Refund Failure,Please verify Order Usage Custom settings in Default Parameter";
                                                                      component.set("v.errorMsg", msg);
                                                                      component.set("v.isError",true);
                                                                      return;
                                                                  }
                                                                  
                                                              });
                                          $A.enqueueAction(action1);
                                      }
                                      else //you are in normal flow 
                                      {
                                          //added by sandhya for validations
                                          var CheckOrd = component.get("v.OrderUsageStand");
                                          if(CheckOrd){
                                              var msg = "Please Check Sigma Order in custom settings";
                                              component.set("v.errorMsg", msg);
                                              component.set("v.isError",true);
                                              return; 
                                          }else{
                                              component.set("v.isError",false);
                                              component.set("v.errorMsg", "");
                                          }
                                          // end here
                                          //alert('inside normal order flow in refund flow');
                                          //component.set("v.isStandardOrder",true); 
                                          // code added by chandana to restric the allocaled user to use the refund 
                                          var invaction = component.get("c.getInventorystatus");
                                          invaction.setCallback(this,function(a)
                                                                {
                                                                    var state = a.getState();
                                                                    // alert('stste is '+state);
                                                                    if(state === "SUCCESS"){
                                                                        var orderresult = a.getReturnValue();{
                                                                            //alert('orderresult is '+orderresult);
                                                                            if(orderresult. sigmaerpdev2__Inventory_Status__c == 'Allocated'){
                                                                                //alert("You Can't Refund Order for Allocated flow");
                                                                                //component.set("v.isOpen",false);
                                                                                var backdrop1 = component.find('backdrop1');
                                                                                $A.util.removeClass(backdrop1, "slds-hide");
                                                                                
                                                                            }
                                                                        }
                                                                    }    
                                                                });
                                          $A.enqueueAction(invaction);
                                          //code ends
                                          
                                          
                                          var action1 = component.get("c.getOrder");
                                          var flagSQ = 0;
                                          var flagDQ = 0;
                                          var flagRS = 0;
                                          action1.setParams
                                          ({
                                              "OrderId" : OrderID
                                          });
                                          
                                          action1.setCallback(this, function(a1) 
                                                              {
                                                                  var savedOrderDetails = a1.getReturnValue();
                                                                  var creditamount=0;
                                                                  var state = a1.getState();
                                                                  if(state === "SUCCESS")
                                                                  {
                                                                      for(var i=0;i<savedOrderDetails. sigmaerpdev2__Order_Lines__r.length;i++)
                                                                      {
                                                                          if(savedOrderDetails. sigmaerpdev2__Order_Lines__r[i]. sigmaerpdev2__Is_Credit_Updated__c)
                                                                          {
                                                                              //alert('in')
                                                                              creditamount += savedOrderDetails. sigmaerpdev2__Order_Lines__r[i]. sigmaerpdev2__Total_Price__c;
                                                                             // creditamount += savedOrderDetails. sigmaerpdev2__Order_Lines__r[i]. sigmaerpdev2__Total_Price__c+savedOrderDetails. sigmaerpdev2__Order_Lines__r[i].sigmaerpdev2__Tax_Amount1__c;
                                                                          } 
                                                                          var shipqty  = savedOrderDetails. sigmaerpdev2__Order_Lines__r[i]. sigmaerpdev2__Shipped_Quantity__c;
                                                                          var delqty = savedOrderDetails. sigmaerpdev2__Order_Lines__r[i]. sigmaerpdev2__Delivered_Quantity__c;
                                                                          if(savedOrderDetails. sigmaerpdev2__Order_Lines__r[i]. sigmaerpdev2__Shipped_Quantity__c > 0){
                                                                              flagSQ = 1;
                                                                              break;
                                                                          }
                                                                          if(savedOrderDetails. sigmaerpdev2__Order_Lines__r[i]. sigmaerpdev2__Delivered_Quantity__c > 0 && savedOrderDetails. sigmaerpdev2__Order_Lines__r[i]. sigmaerpdev2__Inventory_Status__c=='Reserve'){
                                                                              flagDQ = 1;
                                                                              break;
                                                                          }
                                                                           if(savedOrderDetails. sigmaerpdev2__Order_Lines__r[i]. sigmaerpdev2__Order_Status__c =='Ready To Ship'){
                                                                              flagRS = 1;
                                                                              break;
                                                                          }
                                                                      }
                                                                      if(creditamount>0)
                                                                      {
                                                                          component.set("v.CredituserAmount", creditamount);
                                                                      }
                                                                      if(flagSQ == 1)
                                                                      {
                                                                          var msg = "Unable to process Refund as Order got Shipped";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                          
                                                                      }
                                                                       if(flagDQ == 1)
                                                                      {
                                                                          var msg = "Unable to process Refund as Order got Delivered";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                          
                                                                      }
                                                                       if(flagRS == 1)
                                                                      {
                                                                          
                                                                          var msg = "Unable to process Refund as Order is InShipment";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                          
                                                                      }
                                                                      if(savedOrderDetails. sigmaerpdev2__No_Picking_Package_Shipment_Required__c)
                                                                      {
                                                                          var msg = "Unable to process Refund as No Pick,Pack,Ship Checkbox is true";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                      }
                                                                      
                                                                      //alert('state in side checkso::'+JSON.stringify(a1.getReturnValue()));
                                                                      component.set("v.orderStatus",savedOrderDetails. sigmaerpdev2__Orders_Status__c);
                                                                      component.set("v.Customertype",savedOrderDetails. sigmaerpdev2__Customer_Type__c);
                                                                     // alert(component.get("v.Customertype"));
                                                                      if(savedOrderDetails. sigmaerpdev2__Order_Created_Via__c=='Time Based Inventory')
                                                                      {
                                                                          var msg = "You Can't Refund Time Base Inventory Order.";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                      }
                                                                      else{
                                                                          component.set("v.isError",false);
                                                                          component.set("v.errorMsg", "");
                                                                      }
                                                                      //commented after introducing tax
                                                                     /* if(savedOrderDetails. sigmaerpdev2__TotalAmount__c!=undefined)
                                                                      {  
                                                                          component.set("v.CompleteAmountToRefund",savedOrderDetails. sigmaerpdev2__TotalAmount__c);
                                                                          //alert('after set1::'+JSON.stringify(component.get("v.CompleteAmountToRefund",savedOrderDetails. sigmaerpdev2__TotalAmount__c)));
                                                                      }*/
                                                                        if(savedOrderDetails.sigmaerpdev2__Total_Amount_With_Tax__c !=undefined)
                                                                      {  
                                                                          component.set("v.CompleteAmountToRefund",savedOrderDetails.sigmaerpdev2__Total_Amount_With_Tax__c);
                                                                          //alert('after set1::'+JSON.stringify(component.get("v.CompleteAmountToRefund",savedOrderDetails. sigmaerpdev2__TotalAmount__c)));
                                                                      }
                                                                      else
                                                                      {
                                                                        component.set("v.CompleteAmountToRefund",savedOrderDetails. sigmaerpdev2__Net_Amount__c);
                                                                          //alert('after set2 ::'+JSON.stringify(component.get("v.CompleteAmountToRefund",savedOrderDetails. sigmaerpdev2__TotalAmount__c)));
                                                                          
                                                                      }
                                                                      var ordrstus = component.get("v.orderStatus");
                                                                      
                                                                      if(ordrstus == 'Order Confirmed' && savedOrderDetails. sigmaerpdev2__Due_Amount__c<=0 )
                                                                      {
                                                                          var orderIdFromComponent = OrderID;
                                                                          component.set("v.Id",OrderID);
                                                                          //alert('orderid for helper ::'+JSON.stringify(component.get("v.Id")));
                                                                          //alert('OrderID::'+OrderID);
                                                                          //alert('orderIdFromComponent::'+orderIdFromComponent);
                                                                          var spinner = component.find('spinner');
                                                                          $A.util.addClass(spinner, "slds-show");
                                                                          var popover = component.find("IdForCompleteOrderRefund");
                                                                          $A.util.addClass(popover,'slds-hide');
                                                                          popover = component.find("PartialRefundFlow");
                                                                          $A.util.addClass(popover,'slds-hide');
                                                                          popover = component.find("IdForPartialOrderRefund");
                                                                          $A.util.removeClass(popover,'slds-hide');
                                                                          popover = component.find("CompleteRefundFlow");
                                                                          $A.util.removeClass(popover,'slds-hide');
                                                                          helper.fetchOrderDetails(component, event, orderIdFromComponent);
                                                                          helper.loadCompleteOrderPage(component,event);
                                                                      }
                                                                      else
                                                                      {
                                                                         // alert('ordrstus@@'+ordrstus);
                                                                          if(ordrstus == 'Canceled')
                                                                          {
                                                                              var msg = "Unable to process Refund as Order got cancelled";
                                                                              component.set("v.errorMsg", msg);
                                                                              component.set("v.isError",true);
                                                                              return;
                                                                              
                                                                          }
                                                                          else if((ordrstus == 'Order Confirmed' && savedOrderDetails. sigmaerpdev2__Due_Amount__c>0) ||ordrstus == 'Pending')
                                                                          {
                                                                              var msg = "Please make complete payment.";
                                                                              component.set("v.errorMsg", msg);
                                                                              component.set("v.isError",true);
                                                                              return;
                                                                              
                                                                          }
                                                                          
                                                                      }
                                                                  }
                                                                  else{
                                                                      var msg = "Refund Failure,Please verify Order Usage Custom settings in Default Parameter";
                                                                      component.set("v.errorMsg", msg);
                                                                      component.set("v.isError",true);
                                                                      return;
                                                                  }	
                                                                  
                                                              });
                                          $A.enqueueAction(action1);
                                      }
                                  }
                              });
        $A.enqueueAction(ordertype);
        //new code to support for standared object-------------end	
        
    },
    switchToCompleteOrder : function(component,event,helper)
    {
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, "slds-show");
        var popover = component.find("IdForCompleteOrderRefund");
        $A.util.addClass(popover,'slds-hide');
        popover = component.find("PartialRefundFlow");
        $A.util.addClass(popover,'slds-hide');
        popover = component.find("IdForPartialOrderRefund");
        $A.util.removeClass(popover,'slds-hide');
        popover = component.find("CompleteRefundFlow");
        $A.util.removeClass(popover,'slds-hide');
        helper.loadCompleteOrderPage(component,event);
    },
    switchToPartialOrder : function (component, event,helper)
    {
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, "slds-show");
        var popover = component.find("IdForPartialOrderRefund");
        $A.util.addClass(popover,'slds-hide');
        popover = component.find("CompleteRefundFlow");
        $A.util.addClass(popover,'slds-hide');
        popover = component.find("IdForCompleteOrderRefund");
        $A.util.removeClass(popover,'slds-hide');
        popover = component.find("PartialRefundFlow");
        $A.util.removeClass(popover,'slds-hide');
        var spinner1 = component.find('spinner');
        $A.util.removeClass(spinner1, "slds-show");
    },
    showTotalAmount : function (component, event, helper)
    {
        var selectedProduct = component.get("v.selectedStatus");
        if(selectedProduct === null || selectedProduct === '')
        {
            component.set("v.TotalAmount","0.00");
            component.set("v.quantityToRefund","0");
        }
        else
        {
            helper.fetchTotalAmount(component,event,selectedProduct);
        }
    },
    partial_cash_refund : function(component, event, helper)
    {
        var selectedProduct = component.get("v.selectedStatus");
        if(selectedProduct === null || selectedProduct === '')
        {
            alert("Please select a product to refund");
        }
        else
        {
            var selectedProductAmount = component.get("v.TotalAmount");
            if(selectedProductAmount === null || selectedProductAmount === "0.00")
            {
                alert("selected product has already been refunded");
            }
            else
            {
                helper.partialCashRefundFlow(component,event,selectedProduct);
            }
        }
    },
    partial_cheque_refund : function(component, event, helper)
    {
        var selectedProduct = component.get("v.selectedStatus");
        if(selectedProduct === null || selectedProduct === '')
        {
            alert("Please select a product to refund");
        }
        else
        {
            var selectedProductAmount = component.get("v.TotalAmount");
            if(selectedProductAmount === null || selectedProductAmount === '0.00')
            {
                alert('selected product has already been refunded');
            }
            else
            {
                helper.partialChequeRefundFlow(component,event,selectedProduct);
            }
        }
    },
    partial_voucher_refund : function(component, event, helper)
    {
        var selectedProduct = component.get("v.selectedStatus");
        if(selectedProduct === null || selectedProduct === '')
        {
            alert('Please select a product to refund');
        }
        else
        {
            var selectedProductAmount = component.get("v.TotalAmount");
            if(selectedProductAmount === null || selectedProductAmount === '0.00')
            {
                alert('selected product has already been refunded');
            }
            else
            {
                helper.partialVoucherRefundFlow(component,event,selectedProduct);
            }
        }
    },
    partial_card_refund : function(component, event, helper)
    {
        var selectedProduct = component.get("v.selectedStatus");
        if(selectedProduct === null || selectedProduct === '')
        {
            alert('Please select a product to refund');
        }
        else
        {
            var selectedProductAmount = component.get("v.TotalAmount");
            if(selectedProductAmount === null || selectedProductAmount === '0.00')
            {
                alert('selected product has already been refunded');
            }
            else
            {
                helper.partialCardRefundFlow(component,event,selectedProduct);
            }
        }
    },
    complete_cash_refund : function(component, event, helper)
    {
        var localvar= component.get("v.isStandardOrder");
        //alert('inside cash refund'+localvar);
        if(localvar == true)
        {
            var orderStatus = component.get("v.OrderstandObject. sigmaerpdev2__Orders_Status__c");
            if(orderStatus === 'Canceled')
            {
                alert('This order has already been Refunded');
                return;
            }
            else
            {
                var requestedRefundingAmount = component.get("v.CompleteAmountToRefund");
              //  var totalAvailableAmountForRefund = component.get("v.OrderstandObject. sigmaerpdev2__TotalAmount__c");
                var totalAvailableAmountForRefund=requestedRefundingAmount;
              //  alert('requestedRefundingAmount::'+requestedRefundingAmount);
              //  alert('totalAvailableAmountForRefund::'+totalAvailableAmountForRefund);
                
                //alert('requestedRefundingAmount::'+requestedRefundingAmount);
                //alert('totalAvailableAmountForRefund::'+totalAvailableAmountForRefund);
                if(requestedRefundingAmount > 0)
                {
                    if(requestedRefundingAmount > totalAvailableAmountForRefund)
                    {
                        alert('Requested Refunding  is greater than available');
                    }
                    else
                    {
                        helper.CompleteCashRefundFlow(component, event);
                    }
                }
                else
                {
                    alert('Please select a valid amount.');
                }
            }
        }
        else
        {
            var orderStatus = component.get("v.OrderObject. sigmaerpdev2__Orders_Status__c");
            if(orderStatus === 'Canceled')
            {
                alert('This order has already been refunded');
            }
            else
            {
                var requestedRefundingAmount = component.get("v.CompleteAmountToRefund");
                // var totalAvailableAmountForRefund = component.get("v.OrderObject. sigmaerpdev2__TotalAmount__c");
                var totalAvailableAmountForRefund=requestedRefundingAmount;
              //  alert('requestedRefundingAmount::'+requestedRefundingAmount);
             //   alert('totalAvailableAmountForRefund::'+totalAvailableAmountForRefund);
                if(requestedRefundingAmount > 0)
                {
                    if(requestedRefundingAmount > totalAvailableAmountForRefund)
                    {
                        alert('Requested Refunding  is greater than available');
                    }
                    else
                    {
                        helper.CompleteCashRefundFlow(component, event);
                    }
                }
                else
                {
                    alert('Please select a valid amount.');
                }
            }
        }
        
    },
    complete_cheque_refund : function(component, event, helper)
    {
        var localvar= component.get("v.isStandardOrder");
        //alert('inside cheque refund'+localvar);
        if(localvar == true)
        {
            var orderStatus = component.get("v.OrderstandObject. sigmaerpdev2__Orders_Status__c");
            if(orderStatus === 'Canceled')
            {
                alert('This order has already been refunded');
            }
            else
            {
                var requestedRefundingAmount = component.get("v.CompleteAmountToRefund");
               // var totalAvailableAmountForRefund = component.get("v.OrderstandObject. sigmaerpdev2__TotalAmount__c");
                var totalAvailableAmountForRefund=requestedRefundingAmount;
                if(requestedRefundingAmount > 0)
                {
                    if(requestedRefundingAmount > totalAvailableAmountForRefund)
                    {
                        alert('Requested Refunding Amount is greater than available');
                    }
                    else
                    {
                        helper.CompleteChequeRefundFlow(component, event);
                    }
                }
                else
                {
                    alert('Please select a valid amount.');
                }
            }
        }
        else{
            var orderStatus = component.get("v.OrderObject. sigmaerpdev2__Orders_Status__c");
            if(orderStatus === 'Canceled')
            {
                alert('This order has already been refunded');
            }
            else
            {
                var requestedRefundingAmount = component.get("v.CompleteAmountToRefund");
                //var totalAvailableAmountForRefund = component.get("v.OrderObject. sigmaerpdev2__TotalAmount__c");
                var totalAvailableAmountForRefund=requestedRefundingAmount;
                if(requestedRefundingAmount > 0)
                {
                    if(requestedRefundingAmount > totalAvailableAmountForRefund)
                    {
                        alert('Requested Refunding Amount is greater than available');
                    }
                    else
                    {
                        helper.CompleteChequeRefundFlow(component, event);
                    }
                }
                else
                {
                    alert('Please select a valid amount.');
                }
            }
            
        }
        
    },
    complete_voucher_refund : function(component, event, helper)
    {
        var orderStatus = component.get("v.OrderObject. sigmaerpdev2__Orders_Status__c");
        if(orderStatus === 'Canceled')
        {
            alert('This order has already been refunded');
        }
        else
        {
            var requestedRefundingAmount = component.get("v.CompleteAmountToRefund");
            var totalAvailableAmountForRefund = component.get("v.OrderObject. sigmaerpdev2__TotalAmount__c");
            if(requestedRefundingAmount > 0)
            {
                if(requestedRefundingAmount > totalAvailableAmountForRefund)
                {
                    alert('Requested Refunding Amount is greater than available');
                }
                else
                {
                    helper.CompleteVoucherRefundFlow(component, event);
                }
            }
            else
            {
                alert('Please select a valid amount.');
            }
        }
    },
    complete_card_refund : function(component, event, helper)
    {
        var localvar= component.get("v.isStandardOrder");
        if(localvar == true)
        {
            var orderStatus = component.get("v.OrderstandObject. sigmaerpdev2__Orders_Status__c");
            if(orderStatus === 'Canceled')
            {
                alert('This order has already been refunded');
            }
            else
            {
                var requestedRefundingAmount = component.get("v.CompleteAmountToRefund");
               // var totalAvailableAmountForRefund = component.get("v.OrderstandObject. sigmaerpdev2__TotalAmount__c");
                 var totalAvailableAmountForRefund=requestedRefundingAmount;
                if(requestedRefundingAmount > 0)
                {
                    if(requestedRefundingAmount > totalAvailableAmountForRefund)
                    {
                        alert('Requested Refunding Amount is greater than available');
                    }
                    else
                    {
                        helper.CompleteCardRefundFlow(component, event);
                    }
                }
                else
                {
                    alert('Please select a valid amount.');
                }
            }
        }
        else{
            var orderStatus = component.get("v.OrderObject. sigmaerpdev2__Orders_Status__c");
            if(orderStatus === 'Canceled')
            {
                alert('This order has already been refunded');
            }
            else
            {
                var requestedRefundingAmount = component.get("v.CompleteAmountToRefund");
                var totalAvailableAmountForRefund=requestedRefundingAmount;
                // var totalAvailableAmountForRefund = component.get("v.OrderObject. sigmaerpdev2__TotalAmount__c");
                
                if(requestedRefundingAmount > 0)
                {
                    if(requestedRefundingAmount > totalAvailableAmountForRefund)
                    {
                        alert('Requested Refunding Amount is greater than available');
                    }
                    else
                    {
                        helper.CompleteCardRefundFlow(component, event);
                    }
                }
                else
                {
                    alert('Please select a valid amount.');
                }
            } 
        }
    },
    Reload : function(component,event,helper)
    {
        location.reload();
    },
    cancelButton: function(component,event)
    {
        window.history.back();
    }
    
    
})