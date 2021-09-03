({
    doInit : function(component, event, helper) 
    { 
        var OrderID= component.get("v.recordId");
        
        var ordertype = component.get("c.CheckOrder");
         
        
        ordertype.setCallback(this, function(response1) 
                            {
                                  var state = response1.getState();
                                // alert('state1>>>'+state);
                                  if (state === "SUCCESS")
                                  {
                                      var res = response1.getReturnValue();
                                      
                                      component.set("v.OrderUsageSigma",res.sigmaerpdev2__Sigma_order__c);
                                      component.set("v.OrderUsageStand",res.sigmaerpdev2__Standard_object__c);
                                      //alert('Sigma Order'+component.get("v.OrderUsageSigma"));
                                     // alert('StandOrder'+component.get("v.OrderUsageStand"));
                                      
                                      if(res.sigmaerpdev2__Standard_object__c == true)
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
                                                                          if(savedOrderDetails.OrderItems[i].sigmaerpdev2__Is_Credit_Updated__c)
                                                                          {
                                                                               creditamount += savedOrderDetails.OrderItems[i].sigmaerpdev2__TotalPrice__c;
                                                                          }
                                                                          var shipqty  = savedOrderDetails.OrderItems[i].sigmaerpdev2__Shipped_Quantity__c;
                                                                          var delqty = savedOrderDetails.OrderItems[i].sigmaerpdev2__Delivired__c;
                                                                          if(savedOrderDetails.OrderItems[i].sigmaerpdev2__Shipped_Quantity__c > 0){
                                                                              flagSQ = 1;
                                                                              break;
                                                                          }
                                                                          if(savedOrderDetails.OrderItems[i].sigmaerpdev2__Delivired__c > 0 && savedOrderDetails.OrderItems[i].sigmaerpdev2__Inventory_Status__c=='Reserve'){
                                                                              flagDQ = 1;
                                                                              break;
                                                                          }
                                                                          if(savedOrderDetails.OrderItems[i].sigmaerpdev2__Order_Status__c =='Ready To Ship'){
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
                                                                          
                                                                          var msg = "Unable to process Cancel as Order got Shipped";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                          
                                                                      }
                                                                       if(flagDQ == 1)
                                                                      {
                                                                          
                                                                          var msg = "Unable to process Cancel as Order got Delivered";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                          
                                                                      }
                                                                       if(flagRS == 1)
                                                                      {
                                                                          
                                                                          var msg = "Unable to process Cancel as Order is InShipment";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                          
                                                                      }
                                                                      if(savedOrderDetails.sigmaerpdev2__No_Picking_Package_Shipment_Required__c)
                                                                      {
                                                                          var msg = "Unable to process Cancel Order as No Pick,Pack,Ship Checkbox is true";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                      }
                                                                     // alert('amount in side checkso::'+savedOrderDetails.sigmaerpdev2__Net_Amount__c );
                                                                      //if(savedOrderDetails.sigmaerpdev2__Orders_Status__c !=null && savedOrderDetails.sigmaerpdev2__Orders_Status__c != undefined)
                                                                      component.set("v.orderStatus",savedOrderDetails.sigmaerpdev2__Orders_Status__c);
                                                                      component.set("v.Customertype",savedOrderDetails.sigmaerpdev2__Customer_Type__c);
                                                                      if(savedOrderDetails.sigmaerpdev2__Order_Created_Via__c=='Time Based Inventory')
                                                                      {
                                                                          var msg = "You Can't Cancel Time Base Inventory Order.";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                      }
                                                                      else{
                                                                          component.set("v.isError",false);
                                                                          component.set("v.errorMsg", "");
                                                                      }
                                                                       if(savedOrderDetails.sigmaerpdev2__Paid_Amount__c > 0)
                                                                      {
                                                                          var msg = "Unable to process Cancel as there is Payment received,Please use Refund button";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                      }
                                                                      else{
                                                                          component.set("v.isError",false);
                                                                          component.set("v.errorMsg", "");
                                                                      }
                                                                      if(savedOrderDetails.sigmaerpdev2__Orders_Status__c=='Canceled')
                                                                      {
                                                                          var msg = "Order already Cancelled";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                      }
                                                                      
                                                                      else if(savedOrderDetails.sigmaerpdev2__Orders_Status__c=='Delivered')
                                                                      {
                                                                          var msg = "Can not cancel after delivered";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                      }
                                                                      else{
                                                                          component.set("v.isError",false);
                                                                          component.set("v.errorMsg", "");
                                                                      }
                                                                      if(savedOrderDetails.sigmaerpdev2__Net_Amount__c!=undefined)
                                                                      {
                                                                          component.set("v.CompleteAmountToRefund",savedOrderDetails.sigmaerpdev2__Net_Amount__c);
                                                                         // alert('after order set1::'+JSON.stringify(component.get("v.CompleteAmountToRefund",savedOrderDetails.sigmaerpdev2__TotalAmount__c)));
                                                                          
                                                                      }
                                                                      else
                                                                      {
                                                                          component.set("v.CompleteAmountToRefund",savedOrderDetails.sigmaerpdev2__Net_Amount__c);
                                                                          //alert('after order set2::'+JSON.stringify(component.get("v.CompleteAmountToRefund",savedOrderDetails.sigmaerpdev2__Net_Amount__c)));
                                                                          
                                                                      }
                                                                      var ordrstus = component.get("v.orderStatus");
                                                                      
                                                                    //  if(ordrstus == 'Order Confirmed')
                                                                    //  {
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
                                                                         // helper.loadCompleteOrderPage(component,event);
                                                                   //   }
                                                                    /*  else{
                                                                          //alert('inside else'+savedOrderDetails.sigmaerpdev2__Due_Amount__c);
                                                                          if(ordrstus != 'Order Confirmed')
                                                                          {
                                                                              var msg = "order cannot be refunded.";
                                                                              component.set("v.errorMsg", msg);
                                                                              component.set("v.isError",true);
                                                                              return;
                                                                          }
                                                                          
                                                                          
                                                                      } */
                                                                  }
                                                                  else
                                                                  {
                                                                      var msg = "Cancel Order Failure,Please verify Order Usage Custom settings";
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
                                                                            if(orderresult.sigmaerpdev2__Inventory_Status__c == 'Allocated'){
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
                                                                  //alert('data@@'+JSON.stringify(savedOrderDetails));
                                                                  var state = a1.getState();
                                                                  if(state === "SUCCESS")
                                                                  {
                                                                      for(var i=0;i<savedOrderDetails.sigmaerpdev2__Order_Lines__r.length;i++)
                                                                      {
                                                                          if(savedOrderDetails.sigmaerpdev2__Order_Lines__r[i].sigmaerpdev2__Is_Credit_Updated__c)
                                                                          {
                                                                              //alert('in')
                                                                               creditamount += savedOrderDetails.sigmaerpdev2__Order_Lines__r[i].sigmaerpdev2__Total_Price__c;
                                                                          } 
                                                                          var shipqty  = savedOrderDetails.sigmaerpdev2__Order_Lines__r[i].sigmaerpdev2__Shipped_Quantity__c;
                                                                          var delqty = savedOrderDetails.sigmaerpdev2__Order_Lines__r[i].sigmaerpdev2__Delivered_Quantity__c;
                                                                          if(savedOrderDetails.sigmaerpdev2__Order_Lines__r[i].sigmaerpdev2__Shipped_Quantity__c > 0){
                                                                              flagSQ = 1;
                                                                              break;
                                                                          }
                                                                          if(savedOrderDetails.sigmaerpdev2__Order_Lines__r[i].sigmaerpdev2__Delivered_Quantity__c > 0 && savedOrderDetails.sigmaerpdev2__Order_Lines__r[i].sigmaerpdev2__Inventory_Status__c=='Reserve'){
                                                                              flagDQ = 1;
                                                                              break;
                                                                          } 
                                                                           if(savedOrderDetails.sigmaerpdev2__Order_Lines__r[i].sigmaerpdev2__Order_Status__c =='Ready To Ship'){
                                                                              flagRS = 1;
                                                                              break;
                                                                          }
                                                                      }
                                                                      //alert('Amount@'+creditamount);
                                                                      if(creditamount>0)
                                                                      {
                                                                          component.set("v.CredituserAmount", creditamount);
                                                                      }
                                                                      if(flagSQ == 1)
                                                                      {
                                                                          var msg = "Unable to process Cancel as Order got Shipped";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                          
                                                                      }
                                                                       if(flagDQ == 1)
                                                                      {
                                                                          var msg = "Unable to process Cancel as Order got Delivered";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                          
                                                                      }
                                                                       if(flagRS == 1)
                                                                      {
                                                                          var msg = "Unable to process Cancel as Order is InShipment";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                          
                                                                      }
                                                                      if(savedOrderDetails.sigmaerpdev2__No_Picking_Package_Shipment_Required__c)
                                                                      {
                                                                          var msg = "Unable to process Cancel Order as No Pick,,Pack,Ship Checkbox is true";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                      }
                                                                      //alert('state in side checkso::'+JSON.stringify(a1.getReturnValue()));
                                                                      component.set("v.orderStatus",savedOrderDetails.sigmaerpdev2__Orders_Status__c);
                                                                      component.set("v.Customertype",savedOrderDetails.sigmaerpdev2__Customer_Type__c);
                                                                      //alert('status@@'+component.get("v.orderStatus"));
                                                                      if(savedOrderDetails.sigmaerpdev2__Order_Created_Via__c=='Time Based Inventory')
                                                                      {
                                                                          var msg = "You Can't Cancel Time Base Inventory Order.";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                      }
                                                                      else{
                                                                          component.set("v.isError",false);
                                                                          component.set("v.errorMsg", "");
                                                                      }
																	  if(savedOrderDetails.sigmaerpdev2__Paid_Amount__c > 0)
                                                                      {
                                                                          var msg = "Unable to process Cancel as there is Payment received,Please use Refund button";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                      }
                                                                      else{
                                                                          component.set("v.isError",false);
                                                                          component.set("v.errorMsg", "");
                                                                      }
                                                                      if(savedOrderDetails.sigmaerpdev2__Orders_Status__c=='Canceled')
                                                                      {
                                                                          var msg = "Order already Cancelled";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                      }
                                                                      else if(savedOrderDetails.sigmaerpdev2__Orders_Status__c=='Delivered')
                                                                      {
                                                                          var msg = "Can not cancel after delivered";
                                                                          component.set("v.errorMsg", msg);
                                                                          component.set("v.isError",true);
                                                                          return;
                                                                      }
                                                                      else{
                                                                          component.set("v.isError",false);
                                                                          component.set("v.errorMsg", "");
                                                                      }
																	  
                                                                      if(savedOrderDetails.sigmaerpdev2__TotalAmount__c!=undefined)
                                                                      {
                                                                          component.set("v.CompleteAmountToRefund",savedOrderDetails.sigmaerpdev2__TotalAmount__c);
                                                                        //  alert('after set1::'+JSON.stringify(component.get("v.CompleteAmountToRefund",savedOrderDetails.sigmaerpdev2__TotalAmount__c)));
                                                                      }
                                                                      else
                                                                      {
                                                                          component.set("v.CompleteAmountToRefund",savedOrderDetails.sigmaerpdev2__Net_Amount__c);
                                                                         // alert('after set2 ::'+JSON.stringify(component.get("v.CompleteAmountToRefund",savedOrderDetails.sigmaerpdev2__TotalAmount__c)));
                                                                          
                                                                      }
                                                                      var ordrstus = component.get("v.orderStatus");
                                                                     // alert('ordrstus'+ordrstus);
                                                                     // if(ordrstus == 'Order Confirmed')
                                                                     // {
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
                                                                         // helper.loadCompleteOrderPage(component,event);
                                                                     // }
                                                                     /* else
                                                                      {
                                                                          if(ordrstus != 'Order Confirmed')
                                                                          {
                                                                              var msg = "order cannot be refunded.";
                                                                              component.set("v.errorMsg", msg);
                                                                              component.set("v.isError",true);
                                                                              return;
                                                                              
                                                                          }
                                                                         
                                                                          
                                                                      } */
                                                                  }
                                                                  else{
                                                                      var msg = "Cancel Order Failure,Please verify Order Usage Custom settings";
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
    
    CancelingOrder : function(component, event, helper)
    {
        var localvar= component.get("v.isStandardOrder");
        //alert('inside cash refund'+localvar);
        if(localvar == true)
        {
            var orderStatus = component.get("v.OrderstandObject.sigmaerpdev2__Orders_Status__c");
            if(orderStatus === 'Canceled')
            {
                alert('This order has already been Refunded');
                return;
            }
            else
            {
               
                helper.CancelOrderhelper(component, event);
                    
            }
                
            
        }
        else
        {
            var orderStatus = component.get("v.OrderObject.sigmaerpdev2__Orders_Status__c");
            if(orderStatus === 'Canceled')
            {
                alert('This order has already been refunded');
            }
            else
            {
               // var requestedRefundingAmount = component.get("v.CompleteAmountToRefund");
                helper.CancelOrderhelper(component, event);
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