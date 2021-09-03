({
    HelpMenu :function(component, event, helper){  
        component.set("v.HelpIcons", true);        
        var div1 = document.getElementById('trialWindow');        
        $A.util.toggleClass(div1, 'slds-hide');
         //code to de-highlight the highlighted fields once help menu is Shipment SigmaOrder Package Picking
        var trialWindow = document.getElementById("trialWindow");
      console.log(JSON.stringify(trialWindow));
        
        if(trialWindow!=null)
        {
            var className1=trialWindow.className;
            if(className1.includes("slds-hide"))
        {
            var objName = component.get('v.currectObject');
            console.log('objName>>>'+JSON.stringify(objName));
            if(objName == 'Shipment')
            {
                var domId1 = document.getElementById("tempToDisplayLogistics");
                if(domId1 != null)
                    domId1.style.border= "";
                var domId2 = document.getElementById("tempToDisplayDescription");
                if(domId2 != null)
                    domId2.style.border= "";
                var domId3 = document.getElementById("tempToDisplayTruckNumber");
                if(domId3 != null)
                    domId3.style.border= "";
                var domId4 = document.getElementById("tempToDisplayWayBill");
                if(domId4 != null)
                    domId4.style.border= "";
                var domId5 = document.getElementById("tempToDisplayDeleveryPerson");
                if(domId5 != null)
                    domId5.style.border= "";
                var domId6 = document.getElementById("tempToDisplayShipmentDate");
                if(domId6 != null)
                    domId6.style.border= "";
                var domId7 =document.getElementById("tempToDisplayShipmentStatus");
                if(domId7 != null)
                    domId7.style.border= ""; 
                var domId8 =document.getElementById("tempToDisplayConsignment");
                if(domId8 != null)
                    domId8.style.border= ""; 
                var domId9 =document.getElementById("tempToDisplayTrackingUrl");
                if(domId9 != null)
                    domId9.style.border= ""; 
                var domId10 =document.getElementById("tempToDisplayPackageNumber");
                if(domId10 != null)
                    domId10.style.border= "";
                var domId11 =document.getElementById("tempToDisplayShipmentCustomerName");
                if(domId11!= null)
                    domId11.style.border= ""; 
                
                var domId12 =document.getElementById("tempToDisplayShipmentProductStatus");
                if(domId12 != null)
                    domId12.style.border= ""; 
            }
            if(objName == 'SigmaOrder')
            {
                //code for sales order
                var domId21 = document.getElementById("CustomerName");
                if(domId21 != null)
                    domId21.style.border= "";
                var domId22 = document.getElementById("BillingPerson");
                if(domId22 != null)
                    domId22.style.border= "";
                var domId23 = document.getElementById("Status");
                if(domId23 != null)
                    domId23.style.border= "";
                var domId24 = document.getElementById("ExchangeCurrency");
                if(domId24 != null)
                    domId24.style.border= "";
                var domId27 = document.getElementById("NoPickPack");
                if(domId27 != null)
                    domId27.style.border= "";
                var domId25 = document.getElementById("Product");
                if(domId25 != null)
                    domId25.style.border= "";
                var domId26 = document.getElementById("Quantity");
                if(domId26 != null)
                    domId26.style.border= "";
                //code ends
                
            }
            if(objName == 'Package')
            {
                var domId34 = document.getElementById("tempToDisplayPackageCustomer");
                if(domId34 != null)
                    domId34.style.border= "";
                var domId35 = document.getElementById('tempToDisplayPackageStatus');
                if(domId35 != null)
                    domId35.style.border= "";
                var domId36 = document.getElementById("tempToDisplayPackageDate");
                if(domId36 != null)
                    domId36.style.border= "";
                var domId37 = document.getElementById("tempDisplayOrder");
                if(domId37 != null)
                    domId37.style.border= "";
                var domId38 = document.getElementById("tempDisplayPackageProductName");
                if(domId38 != null)
                    domId38.style.border= "";
                var domId39 = document.getElementById("tempDisplayPackageOrderQuantity");
                if(domId39 != null)
                    domId39.style.border= "";
                var domId40 = document.getElementById("tempDisplayPackageQuantity");
                if(domId40!= null)
                    domId40.style.border= "";
                var domId41 = document.getElementById("tempDisplayPackageProductStatus");
                if(domId41!= null)
                    domId41.style.border= "";
                //package code ended
                
            }
            if(objName == 'Picking')
            {
                var domId31 = document.getElementById("SigmaOrder");
                if(domId31 != null)
                    domId31.style.border= "";
                var domId32 = document.getElementById("AllocatedUser");
                if(domId32 != null)
                    domId32.style.border= "";
                var domId33 = document.getElementById("BinID");
                if(domId33 != null)
                    domId33.style.border= "";
                var domId34 = document.getElementById("PickedQty");
                if(domId34 != null)
                    domId34.style.border= "";
                var domId35 = document.getElementById("productScannedCode");
                if(domId35 != null)
                    domId35.style.border= "";   
            }  
        
            
        }
            
        }
        
    },
    stepsOnclickHandler555: function(component, event, helper){
        var clickedFeild;
        if(event.currentTarget){
            clickedFeild=event.currentTarget.name;
           }  
        //alert(JSON.stringify(clickedFeild));
        var domId1 = document.getElementById("tempToDisplayLogistics");
        if(domId1 != null)
        domId1.style.border= "";
        var domId2 = document.getElementById("tempToDisplayDescription");
        if(domId2 != null)
        domId2.style.border= "";
        var domId3 = document.getElementById("tempToDisplayTruckNumber");
        if(domId3 != null)
        domId3.style.border= "";
        var domId4 = document.getElementById("tempToDisplayWayBill");
        if(domId4 != null)
        domId4.style.border= "";
        var domId5 = document.getElementById("tempToDisplayDeleveryPerson");
        if(domId5 != null)
        domId5.style.border= "";
        var domId6 = document.getElementById("tempToDisplayShipmentDate");
        if(domId6 != null)
        domId6.style.border= "";
        var domId7 =document.getElementById("tempToDisplayShipmentStatus");
        if(domId7 != null)
        domId7.style.border= ""; 
        var domId8 =document.getElementById("tempToDisplayConsignment");
        if(domId8 != null)
        domId8.style.border= ""; 
        var domId9 =document.getElementById("tempToDisplayTrackingUrl");
        if(domId9 != null)
        domId9.style.border= ""; 
        var domId10 =document.getElementById("tempToDisplayPackageNumber");
        if(domId10 != null)
        domId10.style.border= "";
        
        //code for sales order
        var domId21 = document.getElementById("CustomerName");
        if(domId21 != null)
        domId21.style.border= "";
        var domId22 = document.getElementById("BillingPerson");
        if(domId22 != null)
        domId22.style.border= "";
        var domId23 = document.getElementById("Status");
        if(domId23 != null)
        domId23.style.border= "";
        var domId24 = document.getElementById("ExchangeCurrency");
        if(domId24 != null)
        domId24.style.border= "";
        var domId27 = document.getElementById("NoPickPack");
        if(domId27 != null)
        domId27.style.border= "";
        var domId25 = document.getElementById("Product");
        if(domId25 != null)
        domId25.style.border= "";
        var domId26 = document.getElementById("Quantity");
        if(domId26 != null)
        domId26.style.border= "";
        //code ends
        //
        //
        //
        
		//package code started
		var domId34 = document.getElementById("tempToDisplayPackageCustomer");
        if(domId34 != null)
        domId34.style.border= "";
        var domId35 = document.getElementById('tempToDisplayPackageStatus');
        if(domId35 != null)
        domId35.style.border= "";
        var domId36 = document.getElementById("tempToDisplayPackageDate");
        if(domId36 != null)
        domId36.style.border= "";
	var domId37 = document.getElementById("tempDisplayOrder");
        if(domId37 != null)
        domId37.style.border= "";
	var domId38 = document.getElementById("tempDisplayPackageProductName");
        if(domId38 != null)
        domId38.style.border= "";
	var domId39 = document.getElementById("tempDisplayPackageOrderQuantity");
        if(domId39 != null)
        domId39.style.border= "";
	var domId40 = document.getElementById("tempDisplayPackageQuantity");
        if(domId40!= null)
        domId40.style.border= "";
	var domId41 = document.getElementById("tempDisplayPackageProductStatus");
        if(domId41!= null)
        domId41.style.border= "";
	//package code ended
        
        //Pick Code
        var domId31 = document.getElementById("SigmaOrder");
        if(domId31 != null)
        domId31.style.border= "";
        var domId32 = document.getElementById("AllocatedUser");
        if(domId32 != null)
        domId32.style.border= "";
        var domId33 = document.getElementById("BinID");
        if(domId33 != null)
        domId33.style.border= "";
        var domId34 = document.getElementById("PickedQty");
		if(domId34 != null)
		domId34.style.border= "";
         var domId35 = document.getElementById("productScannedCode");
        if(domId35 != null)
		domId35.style.border= "";
        
        /*var domId11 =document.getElementById("tempToDisplayShipmentCustomerName");
        if(domId11!= null)
        domId11.style.border= ""; 
        var domId12 =document.getElementById("tempToDisplayShipmentProductStatus");
        if(domId12 != null)
        domId12.style.border= ""; */
        component.set('v.field',clickedFeild);
        
        component.set('v.description','Enter the '+clickedFeild+' for the '+component.get('v.currectObject')+'.');
		 var dom111=document.getElementById(clickedFeild);
        dom111.style.color="red";
        
		//package code started
		if(clickedFeild.includes("Customer")){  
           var domId = document.getElementById("tempToDisplayPackageCustomer");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";             
        } 
		
	if(clickedFeild.includes("Status")){  
           var domId = document.getElementById("tempToDisplayPackageStatus");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";             
        } 
		if(clickedFeild.includes("Packaged Date")){  
           var domId = document.getElementById("tempToDisplayPackageDate");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";             
        } 
		if(clickedFeild.includes("Select Order")){  
           var domId = document.getElementById("tempDisplayOrder");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";             
        } 
		if(clickedFeild.includes("PRODUCT")){  
           var domId = document.getElementById("tempDisplayPackageProductName");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";             
        } 
		if(clickedFeild.includes("ORDERED QUANTITY")){  
           var domId = document.getElementById("tempDisplayPackageOrderQuantity");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";             
        } 
		if(clickedFeild.includes("PACKAGED QUANTITY")){  
           var domId = document.getElementById("tempDisplayPackageQuantity");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";             
        } 
		if(clickedFeild.includes("STATUS")){  
           var domId = document.getElementById("tempDisplayPackageProductStatus");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";             
        } 
		// package code ended
        
        
        if(clickedFeild.includes("Logistics Name")){  
           var domId = document.getElementById("tempToDisplayLogistics");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";             
        } 
         if(clickedFeild.includes("Delivery Note")){
            var domId = document.getElementById("tempToDisplayDescription");
            if(domId != null)
            domId.style.border= "2px solid #19afd5"; 
        }
        if(clickedFeild.includes("Truck Number")){            
            var domId = document.getElementById("tempToDisplayTruckNumber");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";  
        }
        if(clickedFeild.includes("WayBill/Ref")){            
            var domId = document.getElementById("tempToDisplayWayBill");
            if(domId != null)
            domId.style.border= "2px solid #19afd5"; 
        }
        if(clickedFeild.includes("Delivery Person")){            
            var domId = document.getElementById("tempToDisplayDeleveryPerson");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";
        }
        if(clickedFeild.includes("Shipment Date")){           
            var domId = document.getElementById("tempToDisplayShipmentDate");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";
        }
        //Stock 
        if(clickedFeild.includes("Shipment Status")){            
			var domIdVend = document.getElementById("tempToDisplayShipmentStatus"); 
            if(domIdVend != null)
            domIdVend.style.border= "2px solid #19afd5"; 
          }
        if(clickedFeild.includes("Consignment Number")){            
			var domIdVend = document.getElementById("tempToDisplayConsignment"); 
            if(domIdVend != null)
            domIdVend.style.border= "2px solid #19afd5"; 
          }
        if(clickedFeild.includes("Tracking URL")){            
			var domIdVend = document.getElementById("tempToDisplayTrackingUrl"); 
            if(domIdVend != null)
            domIdVend.style.border= "2px solid #19afd5"; 
          }
        if(clickedFeild.includes("PACKAGE NUMBER")){  
           var domId = document.getElementById("tempToDisplayPackageNumber");
           if(domId != null)
           domId.style.border= "2px solid #19afd5";              
        } 
     /*   if(clickedFeild.includes("CUSTOMER NAME")){  
           var domId = document.getElementById("tempToDisplayShipmentCustomerName");
           if(domId != null)
           domId.style.border= "2px solid #19afd5";              
        } 
		if(clickedFeild.includes("STATUS")){  
           var domId = document.getElementById("tempToDisplayShipmentProductStatus");
           if(domId != null)
           domId.style.border= "2px solid #19afd5";              
        } */
        //code for Sigma Order
        if(clickedFeild.includes("Customer")){  
           var domId = document.getElementById("CustomerName");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";             
        }  

		if(clickedFeild.includes("Billing")){  
           var domId = document.getElementById("BillingPerson");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";             
        } 

		if(clickedFeild.includes("Status")){  
           var domId = document.getElementById("Status");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";             
        } 
		
		if(clickedFeild.includes("Exchange")){  
           var domId = document.getElementById("ExchangeCurrency");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";             
        } 
		
        if(clickedFeild.includes("No")){  
           var domId = document.getElementById("NoPickPack");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";             
        } 

        
		if(clickedFeild.includes("Product")){  
           var domId = document.getElementById("Product");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";             
        } 
		
		if(clickedFeild.includes("Quantity")){  
           var domId = document.getElementById("Quantity");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";             
        } 
        
        //code ends
        
        //Picking Code
        if(clickedFeild.includes("Sigma")){  
            var domId = document.getElementById("SigmaOrder");
            if(domId != null)
                domId.style.border= "2px solid #19afd5";             
        } 
        if(clickedFeild.includes("Allocate")){  
            var domId = document.getElementById("AllocatedUser");
            if(domId != null)
                domId.style.border= "2px solid #19afd5";             
        } 
        
        if(clickedFeild.includes("Bin")){  
            var domId = document.getElementById("BinID");
            if(domId != null)
                domId.style.border= "2px solid #19afd5";             
        } 
        if(clickedFeild.includes("Picked")){  
		var domId = document.getElementById("PickedQty");
		if(domId != null)
		domId.style.border= "2px solid #19afd5";             
		} 
        if(clickedFeild.includes("Scan Product barcode")){  
		var domId = document.getElementById("productScannedCode");
		if(domId != null)
		domId.style.border= "2px solid #19afd5";             
		} 
        
        //Code ends
        
    
    },
         dragContent : function(){
        function dragElement(elmnt) {
            var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
            if (document.getElementById(elmnt.id + "header")) {
                /* if present, the header is where you move the DIV from:*/
                document.getElementById(elmnt.id + "header").onmousedown = dragMouseDown;
            } else {
                /* otherwise, move the DIV from anywhere inside the DIV:*/
                elmnt.onmousedown = dragMouseDown;
            }
            
            function dragMouseDown(e) {
                e = e || window.event;
                e.preventDefault();
                // get the mouse cursor position at startup:
                pos3 = e.clientX;
                pos4 = e.clientY;
                document.onmouseup = closeDragElement;
                // call a function whenever the cursor moves:
                document.onmousemove = elementDrag;
            }
            
            function elementDrag(e) {
                e = e || window.event;
                e.preventDefault();
                // calculate the new cursor position:
                pos1 = pos3 - e.clientX;
                pos2 = pos4 - e.clientY;
                pos3 = e.clientX;
                pos4 = e.clientY;
                // set the element's new position:
                elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
                elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
            }
            
            function closeDragElement() {
                /* stop moving when mouse button is released:*/
                document.onmouseup = null;
                document.onmousemove = null;
            }
        }
        //dragElement("myimage", "myresult"); 
        dragElement(document.getElementById("trialWindow"));
    } ,
    init : function(component, event, helper){
       //Help Menu Start
       helper.helperMethod(component, event, helper);
        /*
        var jsonString = {};
        jsonString['SigmaOrder'] =[];
        jsonString['SigmaOrder'].push('Customer Name');
        jsonString['SigmaOrder'].push('Billing person');
        jsonString['SigmaOrder'].push('Status');
        jsonString['SigmaOrder'].push('Exchange Currency');
        jsonString['SigmaOrder'].push('Product');
        jsonString['SigmaOrder'].push('Quantity');
        
        jsonString['Shipment'] =[];
        jsonString['Shipment'].push('Logistics Name');
        jsonString['Shipment'].push('Delivery Note');
        jsonString['Shipment'].push('Truck Number');
		jsonString['Shipment'].push('WayBill/Ref');
        jsonString['Shipment'].push('Delivery Person');
        jsonString['Shipment'].push('Shipment Date');
        jsonString['Shipment'].push('Shipment Status');
        jsonString['Shipment'].push('Consignment Number');
        jsonString['Shipment'].push('Tracking URL');
        jsonString['Shipment'].push('PACKAGE NUMBER');
        //jsonString['Shipment'].push('CUSTOMER NAME');
        //jsonString['Shipment'].push('STATUS');
        
        //Picking
        jsonString['Picking'] =[];
        jsonString['Picking'].push('Sigma Order');
        jsonString['Picking'].push('Allocate User');
        jsonString['Picking'].push('Bin Barcode');
		jsonString['Picking'].push('Picked Quantity');
        jsonString['Picking'].push('Scan Product barcode');
        
		
		jsonString['Package'] =[];
        jsonString['Package'].push('Customer');
        jsonString['Package'].push('Status');
        jsonString['Package'].push('Packaged Date');
		jsonString['Package'].push('Select Order');
        jsonString['Package'].push('PRODUCT');
        jsonString['Package'].push('ORDERED QUANTITY');
        jsonString['Package'].push('PACKAGED QUANTITY');
        jsonString['Package'].push('STATUS');
        
        
        
        
        component.set('v.jsonString',jsonString);       
        var objectFiledList = [];
        for(var key in jsonString){
            objectFiledList.push({value:jsonString[key], key:key});
        }
        component.set('v.objectFiledList',objectFiledList);        
        //End 
        console.log('objectFiledList>>'+JSON.stringify(component.get('v.objectFiledList'))); */
        
      	 setTimeout(function(){
            var jsonString = component.get("v.jsonString");
          }, 2000);
       
        var fromRecp = component.get("v.from");
        //alert('fromRecp>>'+fromRecp);
        if(fromRecp != undefined && fromRecp != ''){
        	if(fromRecp == 'SigmaOrder'){
          		component.set("v.showModules", true);        
           		component.set("v.showSalesOrder", true);
           		component.set("v.showIcons", false);         
            }
            else if(fromRecp == 'StdOrder'){
          		component.set("v.showModules", true);        
           		component.set("v.showStandardOrder", true);
           		component.set("v.showIcons", false);         
            }
            else if(fromRecp == 'PKG'){
          		component.set("v.showModules", true);        
           		component.set("v.showPackage", true);
           		component.set("v.showIcons", false);         
            }else if(fromRecp == 'Shipment'){
          		component.set("v.showModules", true);        
           		component.set("v.showShipment", true);
           		component.set("v.showIcons", false); 
                
            }
			else if(fromRecp =='Picking')
            {
             	component.set("v.showModules", true);        
           		component.set("v.showPick", true);
           		component.set("v.showIcons", false);    
            }
        }else{
           component.set("v.showIcons", true);  
        }
    },
    
	showSalesOrder : function(component, event, helper) {
 
        component.set("v.showModules", true);
	  
        var ordertype = component.get("c.OrderUsage");
         
        
        ordertype.setCallback(this, function(response1) 
                            {
                                  var state = response1.getState();
                                  if (state === "SUCCESS")
                                  {
                                      var resp = response1.getReturnValue();
                                      //alert('resp>>'+JSON.stringify(resp.ou.sigmaerpdev2__Sigma_order__c));
                                      //component.set("v.Sigmaord",resp.sigmaerpdev__Sigma_order__c);
                                      //component.set("v.Standord",resp.sigmaerpdev__Standard_object__c);
                                      
                                      if(resp.ou.sigmaerpdev2__Sigma_order__c == true)
                                      {
										 //alert('resp.sigmaerpdev2__Sigma_order__c>>'+resp.sigmaerpdev2__Sigma_order__c);
										component.set("v.showSalesOrder", true);
									  }
									else{
									 									    
										component.set("v.showStandardOrder", true);
									
									    }
										}
										});
        $A.enqueueAction(ordertype);
         component.set("v.showHelpMenu", true);  		 
		 component.set("v.showPick", false);       
         component.set("v.showPackage", false); 
         component.set("v.showShipment", false);
         component.set("v.showIcons", false);
          //Help menu Image nav
        var currentObject;
        if(event.currentTarget)
            currentObject=event.currentTarget.name;
        //var currentObjectId =document.getElementById('Purchase');
       // alert('currentObjectId'+currentObject)
        component.set('v.currectObject',currentObject);
        
        
        // alert('currentObjectIdObject'+component.get('v.currectObject'))
        if(component.get('v.currectObject')=='SigmaOrder')
        {
              var str1 = "Sales Orders Tab ";
			var str2= "Functionality : To Create Sales Order for Customer";
            component.set('v.description', str1); 
        	component.set('v.descriptionBody', str2);
        }
            //component.set('v.description','Help Menu - Sales Order');       
        
        var objectFiledList=component.get('v.objectFiledList');
        var isDataPresent=false;
        for(var i=0;i<objectFiledList.length;i++)
        {
            if(objectFiledList[i].key==currentObject)
                isDataPresent=true;
        }
        if(!isDataPresent)
        {
           
        	var trialFloatchatid=component.find('trialWindow');
                $A.util.removeClass(trialFloatchatid, "enter");
        }
	},
    showPick : function(component, event, helper) {
 		component.set("v.showHelpMenu", true);        
		component.set("v.showModules", true);        
		component.set("v.showPick", true);
        component.set("v.showStandardOrder", false);
        component.set("v.showSalesOrder", false);
        component.set("v.showPackage", false);	
        component.set("v.showShipment", false);
         component.set("v.showIcons", false);
         //Help menu Image nav
        var currentObject;
        if(event.currentTarget)
            currentObject=event.currentTarget.name;
        //var currentObjectId =document.getElementById('Purchase');
        //alert('currentObjectId'+currentObject)
        component.set('v.currectObject',currentObject);
        // alert('currentObjectIdObject'+component.get('v.currectObject'))
        if(component.get('v.currectObject')=='Picking')
        {
            var str1 = "Picking Tab";
			var str2= "Functionality : To Pick Appropriate Products from Warehouse with respect to Sales order.";
            component.set('v.description', str1); 
        	component.set('v.descriptionBody', str2);
        }
           // component.set('v.description','Help Menu - Picking');       
        
        var objectFiledList=component.get('v.objectFiledList');
        var isDataPresent=false;
        for(var i=0;i<objectFiledList.length;i++)
        {
            if(objectFiledList[i].key==currentObject)
                isDataPresent=true;
        }
        if(!isDataPresent)
        {
           
        	var trialFloatchatid=component.find('trialWindow');
                $A.util.removeClass(trialFloatchatid, "enter");
        }
	},   
    showPackage : function(component, event, helper) {
         component.set("v.showHelpMenu", true);
		component.set("v.showModules", true);        
        component.set("v.showPackage", true);
        component.set("v.showStandardOrder", false);
        component.set("v.showSalesOrder", false);
		component.set("v.showPick", false);
        component.set("v.showShipment", false);
         component.set("v.showIcons", false);
		//Help menu Image nav
        var currentObject;
        if(event.currentTarget)
            currentObject=event.currentTarget.name;
        //var currentObjectId =document.getElementById('Purchase');
       // alert('currentObjectId'+currentObject)
        component.set('v.currectObject',currentObject);
        // alert('currentObjectIdObject'+component.get('v.currectObject'))
        if(component.get('v.currectObject')=='Package'){
             var str1 = "Packages Tab";
			var str2= "Functionality : To create package for Sales Order.";
            component.set('v.description', str1); 
        	component.set('v.descriptionBody', str2);
        }
          //  component.set('v.description','Help Menu - Package');       
        
        var objectFiledList=component.get('v.objectFiledList');
        var isDataPresent=false;
        for(var i=0;i<objectFiledList.length;i++)
        {
            if(objectFiledList[i].key==currentObject)
                isDataPresent=true;
        }
        if(!isDataPresent)
        {
           
        	var trialFloatchatid=component.find('trialWindow');
                $A.util.removeClass(trialFloatchatid, "enter");
        }
		
	},
    showShipment : function(component, event, helper) {	
         component.set("v.showHelpMenu", true);
		component.set("v.showModules", true);        
        component.set("v.showShipment", true);
        component.set("v.showStandardOrder", false);
        component.set("v.showPick", false);
        component.set("v.showSalesOrder", false);
		component.set("v.showPackage", false); 
          component.set("v.showIcons", false);
        /*lightning/o/sigmaerpdev__Shipment__c/list?filterName=Recent
        window.open('/lightning/o/sigmaerpdev__Shipment__c/list?filterName=Recent');
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "sigmaerpdev__Shipment__c"
        });
        homeEvent.fire();*/
        //Help menu Image nav
        var currentObject;
        if(event.currentTarget)
            currentObject=event.currentTarget.name;
        //var currentObjectId =document.getElementById('Purchase');
       // alert('currentObjectId'+currentObject)
        component.set('v.currectObject',currentObject);
        // alert('currentObjectIdObject'+component.get('v.currectObject'))
        if(component.get('v.currectObject')=='Shipment'){
             var str1 = "Shipments Tab";
			var str2= "Functionality :To create Shipment for the Packed Orders";
            component.set('v.description', str1); 
        	component.set('v.descriptionBody', str2);
        }
          //  component.set('v.description','Help Menu - Shipment');       
        
        var objectFiledList=component.get('v.objectFiledList');
        var isDataPresent=false;
        for(var i=0;i<objectFiledList.length;i++)
        {
            if(objectFiledList[i].key==currentObject)
                isDataPresent=true;
        }
        if(!isDataPresent)
        {
           
        	var trialFloatchatid=component.find('trialWindow');
                $A.util.removeClass(trialFloatchatid, "enter");
        }
        
	},    
    closeInfo : function(component, event, helper){		        
        component.set("v.showIcons", false);
    },
    showInfo :  function(component, event, helper){        
        component.set("v.showIcons", true);
    },
    stepsOnclickHandler: function(component, event, helper){
         component.set("v.descriptionBody", "");
          var objName = component.get('v.currectObject');
            console.log('objName>>>'+JSON.stringify(objName));//Shipment 
        var clickedIndexArray;
        if(event.currentTarget)
            clickedIndexArray=event.currentTarget.id.split("-");
        //alert(JSON.stringify(clickedIndexArray));
        var jsonString=component.get('v.jsonString');
      // alert(JSON.stringify(jsonString));
        console.log(JSON.stringify(jsonString));
        var clickedStep=jsonString.chapters[clickedIndexArray[0]].steps[clickedIndexArray[1]];
console.log('clickedStep>>>'+JSON.stringify(clickedStep));
   //  alert("clickedStep	"+JSON.stringify(clickedStep));
     //  alert("clickedStep.title"+JSON.stringify(clickedStep.title));
         /* var clickedFeild;
        if(event.currentTarget){
            clickedFeild=event.currentTarget.name;
           }  */
        //alert(JSON.stringify(clickedFeild));
        var domId1 = document.getElementById("tempToDisplayLogistics");
        if(domId1 != null)
        domId1.style.border= "";
        var domId2 = document.getElementById("tempToDisplayDescription");
        if(domId2 != null)
        domId2.style.border= "";
        var domId3 = document.getElementById("tempToDisplayTruckNumber");
        if(domId3 != null)
        domId3.style.border= "";
        var domId4 = document.getElementById("tempToDisplayWayBill");
        if(domId4 != null)
        domId4.style.border= "";
        var domId5 = document.getElementById("tempToDisplayDeleveryPerson");
        if(domId5 != null)
        domId5.style.border= "";
        var domId6 = document.getElementById("tempToDisplayShipmentDate");
        if(domId6 != null)
        domId6.style.border= "";
        var domId7 =document.getElementById("tempToDisplayShipmentStatus");
        if(domId7 != null)
        domId7.style.border= ""; 
        var domId8 =document.getElementById("tempToDisplayConsignment");
        if(domId8 != null)
        domId8.style.border= ""; 
        var domId9 =document.getElementById("tempToDisplayTrackingUrl");
        if(domId9 != null)
        domId9.style.border= ""; 
        var domId10 =document.getElementById("tempToDisplayPackageNumber");
        if(domId10 != null)
        domId10.style.border= "";
        
        
        //code for sales order
        var domId21 = document.getElementById("CustomerName");
        if(domId21 != null)
        domId21.style.border= "";
        var domId22 = document.getElementById("BillingPerson");
        if(domId22 != null)
        domId22.style.border= "";
        var domId23 = document.getElementById("Status");
        if(domId23 != null)
        domId23.style.border= "";
        var domId24 = document.getElementById("ExchangeCurrency");
        if(domId24 != null)
        domId24.style.border= "";
        var domId25 = document.getElementById("Product");
        if(domId25 != null)
        domId25.style.border= "";
        var domId26 = document.getElementById("Quantity");
        if(domId26 != null)
        domId26.style.border= "";
        var domId37 = document.getElementById("NoPickPack");
        if(domId37 != null)
        domId37.style.border= "";
        //code ends
        //
        //
        //
        
		//package code started
		var domId34 = document.getElementById("tempToDisplayPackageCustomer");
        if(domId34 != null)
        domId34.style.border= "";
        var domId35 = document.getElementById('tempToDisplayPackageStatus');
        if(domId35 != null)
        domId35.style.border= "";
        var domId36 = document.getElementById("tempToDisplayPackageDate");
        if(domId36 != null)
        domId36.style.border= "";
	var domId37 = document.getElementById("tempDisplayOrder");
        if(domId37 != null)
        domId37.style.border= "";
	var domId38 = document.getElementById("tempDisplayPackageProductName");
        if(domId38 != null)
        domId38.style.border= "";
	var domId39 = document.getElementById("tempDisplayPackageOrderQuantity");
        if(domId39 != null)
        domId39.style.border= "";
	var domId40 = document.getElementById("tempDisplayPackageQuantity");
        if(domId40!= null)
        domId40.style.border= "";
	var domId41 = document.getElementById("tempDisplayPackageProductStatus");
        if(domId41!= null)
        domId41.style.border= "";
	//package code ended
        
        //Pick Code
        var domId31 = document.getElementById("SigmaOrder");
        if(domId31 != null)
        domId31.style.border= "";
        var domId32 = document.getElementById("AllocatedUser");
        if(domId32 != null)
        domId32.style.border= "";
        var domId33 = document.getElementById("BinID");
        if(domId33 != null)
        domId33.style.border= "";
        var domId34 = document.getElementById("PickedQty");
		if(domId34 != null)
		domId34.style.border= "";
         var domId35 = document.getElementById("productScannedCode");
        if(domId35 != null)
		domId35.style.border= "";
        
        var domId11 =document.getElementById("tempToDisplayShipmentCustomerName");
        if(domId11!= null)
        domId11.style.border= ""; 
        var domId12 =document.getElementById("tempToDisplayShipmentProductStatus");
        if(domId12 != null)
        domId12.style.border= ""; 
        /*component.set('v.field',clickedFeild);
        s
        component.set('v.description','Enter the '+clickedFeild+' for the '+component.get('v.currectObject')+'.');
		 var dom111=document.getElementById(clickedFeild);
        dom111.style.color="red";*/
        
		//package code started
		//shipment start
		//Shipment code starts
        if(objName==='Shipment')
           {
           //Shipment code ends
           if(clickedStep.title.includes("Logistics Name")){  
            var domId = document.getElementById("tempToDisplayLogistics");
            console.log('domId'+domId);
            if(domId != null)
            {
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
                domId.style.border= "2px solid #19afd5"; 
            }
            
        } 
        else if(clickedStep.title.includes("Delivery Note")){
            var domId = document.getElementById("tempToDisplayDescription");
            if(domId != null){
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
                domId.style.border= "2px solid #19afd5";
            }
        }
            else if(clickedStep.title.includes("Truck Number")){            
                var domId = document.getElementById("tempToDisplayTruckNumber");
                if(domId != null){
                    component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
                    domId.style.border= "2px solid #19afd5"; 
                }
            }
                else if(clickedStep.title.includes("WayBill/Ref")){            
                    var domId = document.getElementById("tempToDisplayWayBill");
                    if(domId != null){
                        component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
                        domId.style.border= "2px solid #19afd5"; 
                    }
                }
                    else if(clickedStep.title.includes("Delivery Person")){            
                        var domId = document.getElementById("tempToDisplayDeleveryPerson");
                        if(domId != null){
                            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
                            domId.style.border= "2px solid #19afd5";
                        }
                    }
                        else if(clickedStep.title.includes("Shipment Date")){           
                            var domId = document.getElementById("tempToDisplayShipmentDate");
                            if(domId != null){
                                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
                                domId.style.border= "2px solid #19afd5";
                            }
                        }
        
                            else if(clickedStep.title.includes("Shipment Status")){            
                                var domIdVend = document.getElementById("tempToDisplayShipmentStatus"); 
                                if(domIdVend != null){
                                    component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
                                    // if(domIdVend != null)
                                    domIdVend.style.border= "2px solid #19afd5"; 
                                }
                            }
                                else if(clickedStep.title.includes("Consignment Number")){            
                                    var domIdVend = document.getElementById("tempToDisplayConsignment"); 
                                    if(domIdVend != null){
                                        component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
                                        domIdVend.style.border= "2px solid #19afd5";
                                    }
                                }
                                    else if(clickedStep.title.includes("Tracking URL")){            
                                        var domIdVend = document.getElementById("tempToDisplayTrackingUrl"); 
                                        if(domIdVend != null){
                                            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
                                            domIdVend.style.border= "2px solid #19afd5"; 
                                        }
                                    }
                                        else if(clickedStep.title.includes("PACKAGE NUMBER")){  
                                            var domId = document.getElementById("tempToDisplayPackageNumber");
                                            if(domId != null){
                                                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
                                                domId.style.border= "2px solid #19afd5"; 
                                                
                                            }
                                            
                                        } 
                                            else if(clickedStep.title.includes("CUSTOMER NAME")){  
                                                var domId = document.getElementById("tempToDisplayShipmentCustomerName");
                                                if(domId != null){
                                                    component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
                                                    domId.style.border= "2px solid #19afd5";     
                                                }
                                            } 
                                                else if(clickedStep.title.includes("Shipment Product Status")){  
                                                    var domId = document.getElementById("tempToDisplayShipmentProductStatus");
                                                    if(domId != null){
                                                        component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
                                                        //if(domId != null)
                                                        domId.style.border= "2px solid #19afd5";  
                                                    }
                                                } 
        
    }
    //sjipment end
    else if(objName==='Package')
    {
        if( clickedStep.title.startsWith("Package") && clickedStep.title.endsWith("Customer")  ){  
           var domId = document.getElementById("tempToDisplayPackageCustomer");
             console.log(">>>domId"+JSON.stringify(domId));
          // console.log(">>>domId.style"+JSON.stringify(domId.style));
            if(domId != null)
            {
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5"; 
            }
                             
        } 
		//alert("clickedStep.title"+JSON.stringify(clickedStep));
	else if( clickedStep.title.includes("Package Status") &&!clickedStep.title.includes("Customer"))
    {  
           var domId = document.getElementById("tempToDisplayPackageStatus");
        	console.log(">>>domId"+JSON.stringify(domId));
        if(domId != null){
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
           // alert('domId'+JSON.stringify(domId));
           console.log(JSON.stringify(domId.style));
           //alert(">>>domId.style"+JSON.stringify(domId.style));
           if(domId.style!=null)
           {
               domId.style.border= "2px solid #19afd5";  
           }
             
        }                      
        } 
		else if(clickedStep.title.includes("Packaged Date")){  
           var domId = document.getElementById("tempToDisplayPackageDate");
            if(domId != null){
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5"; 
            }
                             
        } 
		else if(clickedStep.title.includes("Select Order")){  
           var domId = document.getElementById("tempDisplayOrder");
            if(domId != null)
            {
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5"; 
                
            }
                             
        } 
		else if(clickedStep.title.includes("PRODUCT")){  
           var domId = document.getElementById("tempDisplayPackageProductName");
            if(domId != null){
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5"; 
            }
                             
        } 
		else if(clickedStep.title.includes("ORDERED QUANTITY")){  
           var domId = document.getElementById("tempDisplayPackageOrderQuantity");
            if(domId != null){
                 component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";
            }
			             
        } 
		else if(clickedStep.title.includes("PACKAGED QUANTITY")){  
           var domId = document.getElementById("tempDisplayPackageQuantity");
            if(domId != null)
            {
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5"; 
                
            }
                             
        } 
		else if(clickedStep.title.includes("Package Product Status")){  
           var domId = document.getElementById("tempDisplayPackageProductStatus");
            if(domId != null){
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";   
                
            }
                           
        } 
		// package code ended
        
    }
    else if(objName==='SigmaOrder')
    {
        //code for Sigma Order
        if(clickedStep.title.includes("Customer")){
            
           var domId = document.getElementById("CustomerName");
            if(domId != null)
			{
				component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";
				
			}
                              
        }  

		else if(clickedStep.title.includes("Billing")){  
           var domId = document.getElementById("BillingPerson");
            if(domId != null){
				 component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";
				
			}
                             
        } 

		else if(clickedStep.title.includes("Status")){  
           var domId = document.getElementById("Status");
            if(domId != null)
			{
				component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";   
			}
                           
        } 
		
		else if(clickedStep.title.includes("Exchange")){  
           var domId = document.getElementById("ExchangeCurrency");
            if(domId != null)
			{
				 component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";
				
			}
                             
        } 
        
        else if(clickedStep.title.includes("No Picking, Package And Shipment")){  
           var domId = document.getElementById("NoPickPack");
            if(domId != null)
			{
				 component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";
				
			}
                             
        } 
		
		else if(clickedStep.title.startsWith("Product") &&  !clickedStep.title.endsWith("Quantity")){  
           var domId = document.getElementById("Product");
            if(domId != null)
			{
				component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5"; 
				
			}
                             
        } 
		
		else if(clickedStep.title.startsWith("Quantity")){  
           var domId = document.getElementById("Quantity");
            if(domId != null){
                 component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";  
			}			
			
        } 
        
        //code ends
        
        
    }
     else if(objName==='Picking')
    {
         //Picking Code
        if(clickedStep.title.includes("Sales")){  
            var domId = document.getElementById("SigmaOrder");
            if(domId != null){
				component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
                domId.style.border= "2px solid #19afd5"; 
				
			}
                             
        } 
       else if(clickedStep.title.includes("Allocate")){  
            var domId = document.getElementById("AllocatedUser");
            if(domId != null){
                 component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
                domId.style.border= "2px solid #19afd5";  
			}				
        } 
        
        else if(clickedStep.title.includes("Bin Barcode")){  
            var domId = document.getElementById("BinID");
            if(domId != null)
			{
				component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
                domId.style.border= "2px solid #19afd5";
				
			}
                              
        } 
        else if(clickedStep.title.startsWith("Picked") && clickedStep.title.endsWith("Quantity")){  
		var domId = document.getElementById("PickedQty");
		if(domId != null){
			component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
		domId.style.border= "2px solid #19afd5";   
			
		}
                       
		} 
       else  if(clickedStep.title.startsWith("Scan") && clickedStep.title.endsWith(" Product barcode")){  
		var domId = document.getElementById("productScannedCode");
		if(domId != null){
			component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
		domId.style.border= "2px solid #19afd5";    
			
		}
                      
		} 
        
        //Code ends
       
        
    }
  
    }
})