({
    /*clearAfterContactRemove: function (component, event, helper) {
         let Shipment=component.get('v.Shipment');
        let conID=component.get('v.conID');
		let conName=component.get('v.conName');
        console.log('Shipment>>'+JSON.stringify(Shipment));
        console.log('soID::'+JSON.stringify(conID)+!component.get('v.conID'));
        console.log('conName::'+JSON.stringify(conName));
        if(!component.get('v.conID'))
        {
			component.set("v.Shipment.sigmaerpdev2__Delivery_Person__c",'');
			component.set("v.conName",'');
			
        }
		else{
		component.set("v.Shipment.sigmaerpdev2__Delivery_Person__c",conID);
            if(component.get('v.conName'))
		component.set("v.Shipment.sigmaerpdev2__Delivery_Person__r.Name",component.get('v.conName'));
           Shipment=component.get('v.Shipment');
		console.log('Shipment>>'+JSON.stringify(Shipment));
		}
		
    },*/
     handleComponentEvent : function (component, event, helper) {
		 console.log('handleComponentEvent>>');
        if (event.getParam("flag") == 'shipOrderLine') {
            var ind = event.getParam("data").index;
            var ShipmentLineWrap = component.get("v.ShipmentLineWrap");
            if(ShipmentLineWrap[ind].shipLines.Id){
                var tempRec = component.find("recordLoader");
                tempRec.set("v.recordId", ShipmentLineWrap[ind].shipLines.Id);
                tempRec.reloadRecord();
            }
            ShipmentLineWrap.splice(ind,1);
            component.set("v.ShipmentLineWrap",ShipmentLineWrap); 
            var idListStr;
            var ShipmentLineWrap = component.get("v.ShipmentLineWrap");
            for(var i=0;i<ShipmentLineWrap.length;i++)
            {
                if(i==0)
                    idListStr=ShipmentLineWrap[i].shipLines.stapp__Package__c;
                else
                    idListStr+='\',\''+ShipmentLineWrap[i].shipLines.stapp__Package__c;
            }           
            component.set('v.packageList',idListStr);
        }
        
        if (event.getParam("flag") == 'clear') {
            //alert("in>>>");
            component.set("v.Shipment.stapp__Carrier_Contact__c",'');
            component.set("v.Shipment.ContactName",'');
            component.set("v.servicetype",'');
        }
        
        if (event.getParam("flag") == 'accountContact') {
         //   alert(component.get("v.Shipment"));
            //var con = event.getParam("data").AccContact;
           // var sertype = event.getParam("data").ServiceType;
            var conName = event.getParam("data").conName;
            var cust = event.getParam("data").customer;
			var contactPerson = event.getParam("data").contactPerson;
			 console.log('ShipmentProduct Handled contactPerson >>'+JSON.stringify(contactPerson));
			 component.set("v.Shipment.ContactName",'');
			 component.set("v.ShipmentProduct.sigmaerpdev2__Contact_Person__c",contactPerson);
			 console.log('ShipmentProduct Handled >>'+JSON.stringify(component.get("v.ShipmentProduct")));
             ////alert('conName>>'+conName);
            // alert('cust>>'+cust);
            
        }
    },
    doInit : function(component, event, helper) {
          
       // component.find("v.").get
         
        var action = component.get("c.getShipmentStatus");
        action.setCallback(this, function(a) {
            /// alert("alert doInit"+a.getReturnValue());
            component.set("v.status", a.getReturnValue());
            var headerSectionstatus = component.find("headerSectionstatus").get("v.value");
          //  alert("alert doInit"+headerSectionstatus);
             component.set("v.ShipmentProduct.sigmaerpdev2__Status__c", component.get("v.status")[0]);
        });        
        $A.enqueueAction(action);
        
        var ShipmentProductsList = component.get("v.ShipmentProducts");
        
        var len = ShipmentProductsList.length;
        
        component.set("v.ShipmentProducts",ShipmentProductsList);            
        //alert(component.get("v.Id"));
        
        if(component.get("v.Id") !== '')
        {
            //component.set("v.isOpenprodTable", true);     
            var action1 = component.get("c.editShipment");
            action1.setParams({ "shipmentObj": component.get("v.Id") });
            action1.setCallback( this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    component.set("v.Shipment", response.getReturnValue());
                  //  console.log('Shipment>>'+ JSON.stringify(component.get('v.Shipment')));
                    //alert('in edir flow ::'+JSON.stringify('v.Shipment'));
                    if(response.getReturnValue().sigmaerpdev2__Account__c != null){ 
                        component.set("v.recordName", response.getReturnValue().sigmaerpdev2__Account__r.Name);
                        component.set("v.SAccount", response.getReturnValue().sigmaerpdev2__Account__c);
                        
                        //alert('in flow ::'+JSON.stringify(component.get('v.recordName')));
                        //alert('in edir flow ::'+JSON.stringify(component.get('v.SAccount')));
                    }
                    if(response.getReturnValue().sigmaerpdev2__Delivery_Person__c != null){
                        component.set("v.recordName1", response.getReturnValue().sigmaerpdev2__Delivery_Person__r.Name);
                        component.set("v.SContact", response.getReturnValue().sigmaerpdev2__Delivery_Person__c);
                         component.set("v.conName", response.getReturnValue().sigmaerpdev2__Delivery_Person__r.Name);
                        component.set("v.conID", response.getReturnValue().sigmaerpdev2__Delivery_Person__c);
                    }  
                    if(response.getReturnValue().sigmaerpdev2__Selected_Courier__c!=null || response.getReturnValue().sigmaerpdev2__Selected_Courier__c!='' || response.getReturnValue().sigmaerpdev2__Selected_Courier__c!=undefined)
                        component.set("v.Showcourier",false);
                    component.find("headerSectionstatus").set("v.value", response.getReturnValue().sigmaerpdev2__Status__c); 
                    
                }
                
            });
            $A.enqueueAction(action1);
            
            var action2 = component.get("c.editShipmentProducts");
            action2.setParams({ "shipmentObj1": component.get("v.Id") });
            action2.setCallback( this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    var resp = response.getReturnValue();
                    var tempSIP = [];
                    console.log('resp>>'+JSON.stringify(resp));
                    for(var i=0;i<resp.length;i++)
                    {
                        component.set("v.ShipmentProduct", resp[i]);
                        var sipIndiv = component.get("v.ShipmentProduct");
                        
                        sipIndiv.Pkg__Name = resp[i].sigmaerpdev2__Package_ID__r.Name;
                        sipIndiv.Cust__Name = resp[i].sigmaerpdev2__Customer_Name__r.Name;
                        sipIndiv.sigmaerpdev2__Shipment_Delivery_Date__c = resp[i].sigmaerpdev2__Shipment_Delivery_Date__c;
                        sipIndiv.sigmaerpdev2__Status__c = resp[i].sigmaerpdev2__Status__c;
						sipIndiv.sigmaerpdev2__Contact_Person__c = resp[i].sigmaerpdev2__Contact_Person__c;
                                              
					   tempSIP.push(sipIndiv);
                    }
                    //alert('tempSIP>>'+JSON.stringify(tempSIP));
                    console.log('tempSIP[0]>>'+JSON.stringify(tempSIP[0]));
                    component.set("v.ShipmentProducts", tempSIP);
                    component.set("v.ShipmentProduct", tempSIP[0]);
                    //alert('tempSIP>>'+JSON.stringify( component.get("v.ShipmentProduct")));

                }
            });
            $A.enqueueAction(action2);
        }
         
         var action3 = component.get("c.getCouriers");
         action3.setCallback(this, function(response) {
             var state = response.getState();
             if (state === "SUCCESS") {
                 if (response.getReturnValue() != null) {
                     var couriers=[];
                     var result= response.getReturnValue();
                     component.set("v.myMap",result);
                     for(var key in result){
                         var data=key;
                         couriers.push(data);
                     }
                     component.set("v.courierlist",couriers);
                 }
             }
         });
         $A.enqueueAction(action3);
    },
    
    
    onPicklistChange : function(component,event,helper) {
        var selected = component.find("levels").get("v.value");
        component.set("v.Shipment.sigmaerpdev2__Selected_Courier__c",selected);
        component.set("v.selectedCourier",selected);
        var values=component.get("v.myMap");
        if(selected!="--None--"){
            for(var key in values){
                if(key==selected)
                    component.set("v.courierSlug",values[key]);
            } 
        }
        else
            component.set("v.courierSlug",null);
    },
    
    handleStockinList: function(component, event, helper) {
        var siList = event.getParam("shList");
        var editflag = event.getParam("isEdit");
        
        var editIndex = event.getParam("rowIndex");
        var sip =  component.get("v.ShipmentProducts");
        
        if(editflag == true && editIndex!=null)
        {
            sip[editIndex] = siList[0];
            component.set("v.ShipmentProducts",sip);
        }else
        {
            if(sip == '' || sip == 'undefined')
            {
                
                component.set("v.ShipmentProducts",siList);
            }else
            {
                
                sip.push(siList[0]);
                component.set("v.ShipmentProducts",sip);
                
            }
        }
        
    },
   
    addContact : function(component, event, helper){
        var ShipmentProductsList = component.get("v.ShipmentProducts");
        if(ShipmentProductsList !== ''){
            var len = ShipmentProductsList.length;
            ShipmentProductsList.push({
                'sigmaerpdev2__Package_ID__c': '',
                'sigmaerpdev2__Customer_Name__c': '',
                'sigmaerpdev2__Order__c': '',
                'sigmaerpdev2__Shipment_Delivery_Date__c': '',
                'sigmaerpdev2__Truck_No__c': '',
                'sigmaerpdev2__Status__c': '',
                'sigmaerpdev2__Total_Quantity__c':''
            });
            component.set("v.ShipmentProducts",ShipmentProductsList);
            
        }
        
    },
    
    handleRemoveProductItemClick : function(component, event, helper) {
        var self = this;  // safe reference
        var index = event.target.dataset.index;
        helper.removeProductItem(component, index);
    },
    
    createShipment :function(component,event,helper)
    {
		 console.log('createShipment ShipmentProduct >>>'+JSON.stringify(component.get('v.ShipmentProduct')));
        /* let conID22=component.get('v.Shipment.sigmaerpdev2__Delivery_Person__c'); 
        let conID33=component.get('v.conID'); 
        console.log('conID22'+JSON.stringify(conID22));
         console.log('conID33'+JSON.stringify(conID33));
        if(conID22)
        { 
            component.set("v.Shipment.sigmaerpdev2__Delivery_Person__c",conID22);
          
        }
        else
        {
                  alert('Please enter Contact Person name.');
            //logisticName.set("v.errors", [{message:"Please enter logistics name."}]);   	                	 
            return;         
        } */
         console.log('Shipment'+JSON.stringify(component.get('v.Shipment')));
      // return;
        //alert('inside create ship');
       console.log('Shipment>>'+JSON.stringify(component.get("v.Shipment")));
        console.log('conName>>'+JSON.stringify(component.get("v.conName")));
        
        //console.log('Shipment>>'+JSON.stringify(component.get("v.Shipment")));
        //return ;
     //return;
        var Shipment = new Date(component.get("v.Shipment.sigmaerpdev2__Shipment_Date__c"));      
        var logName = component.get("v.selectedCourier");
        var deleverPerson1 = component.find("deleverPerson").get("v.value");
        var deleverPerson = component.get("v.dpName");         
        var deleverPerson1 = component.find("deleverPerson").get("v.value");
        
        if(logName === '' || logName === null || logName == '--None--' || logName === undefined)
        {                      
            alert('Please enter logistics name.');
            //logisticName.set("v.errors", [{message:"Please enter logistics name."}]);   	                	 
            return null; 
        }
        
        if(deleverPerson1 === undefined || deleverPerson1 === '')
        {                      
            alert('Please enter Delivery Person name.');
            //logisticName.set("v.errors", [{message:"Please enter logistics name."}]);   	                	 
            return ; 
        }
        else
        {
            component.set("v.Shipment.sigmaerpdev2__Delivery_Person1__c",deleverPerson1)
            
        }      
        
        var statusComp = component.find('headerSectionstatus');
        var statusCompValue = statusComp.get('v.value');  
        var dateComp = component.find('DateTime');
        var dateCompValue = dateComp.get('v.value'); 
        var today = new Date();
        var todaydate = new Date( today.getFullYear()+ "-" +(today.getMonth() + 1)+ "-" + today.getDate());
        
        if(statusCompValue === undefined || statusCompValue === '--Select--')
        {     
            alert('Please select shipment status.');
            //statusComp.set("v.errors", [{message:"Please select shipment status."}]);      	                	 
            return null; 
        }
        else{
            statusComp.set("v.errors", null);
        }
        
        if(statusCompValue === 'Delivered' || statusCompValue === 'Returned')
        {           
            statusComp.set("v.errors", [{message:"Status cannot be set to Delivered before creating shipment"}]);      	                	 
            return null; 
        }
        else{
            statusComp.set("v.errors", null);
        }
        
        if(dateCompValue == '')
        {           
            alert('Please select Shipment Date.');
            //dateComp.set("v.errors", [{message:"Please select Shipment Date."}]);      	                	 
            return null; 
        }
        else{
            dateComp.set("v.errors", null);
        }
        
        var orderdate = new Date(Shipment.getFullYear()+ "-" +(Shipment.getMonth() + 1)+ "-" + Shipment.getDate() );
        
        if(orderdate < todaydate)
        {
            dateComp.set("v.errors", [{message:"Shipment Delivery Date Should be greater than or equal to Today."}]);      	                	 
            return null; 
        }
        else
        {
            dateComp.set("v.errors", null);
        }
        var ShipmentProductItem=component.get('v.ShipmentProduct');
        var shipmentlineItems=[];
         if(JSON.stringify(ShipmentProductItem.sigmaerpdev2__Package_ID__c)==='""')
        {
            alert('please select package');
             return;
        }
        //alert(JSON.stringify(ShipmentProductItem.sigmaerpdev2__Package_ID__c));
       // return;
        if(ShipmentProductItem!=undefined)
        {
            shipmentlineItems.push(ShipmentProductItem);
        }
        component.set("v.ShipmentProducts",shipmentlineItems);
        var newShipmentProducts = component.get("v.ShipmentProducts");
        //alert('newShipmentProducts::'+JSON.stringify(component.get("v.ShipmentProducts")));
        for(var i=0;i<newShipmentProducts.length;i++)
        {
            
            if(newShipmentProducts[i].sigmaerpdev2__Status__c == 'Delivered' || newShipmentProducts[i].sigmaerpdev2__Status__c== 'Returned' )
            {
                alert('Status cannot be set to Delivered before creating shipment.');
                return null;
            }
        }
        
        if(newShipmentProducts.length < 1)
        {
            alert('Please add packages for shipment.');
            return null;
        }
        
        for(var i=0;i<newShipmentProducts.length-1;i++)
        {
            for(var j=i+1;j<newShipmentProducts.length;j++)
            {
                
                if(newShipmentProducts[i].sigmaerpdev2__Package_ID__c == newShipmentProducts[j].sigmaerpdev2__Package_ID__c)
                {
                    var msg1 = "Duplicate package exist at line"+(i+1);
                    component.set("v.errorMsg", msg1);
                    component.set("v.isError",true);
                    return;
                }
            }
        }
          document.getElementById("Accspinner").style.display = "block";
        setTimeout(function(){ document.getElementById("Accspinner").style.display = "none"; }, 5000);
         
        var newShipment=component.get('v.Shipment');
          console.log("newShipment"+JSON.stringify(newShipment))
        /*var conName=component.get('v.conName');
         var conID=component.get('v.conID');
        console.log('conName'+JSON.stringify(conName))
         console.log('conID'+JSON.stringify(conID))
         if(conID)
        newShipment.sigmaerpdev2__Delivery_Person__c=conID;
        if(conName)
        newShipment.sigmaerpdev2__Delivery_Person__r.Name=conName;
        console.log("newShipment"+JSON.stringify(newShipment));
        console.log("newShipment"+JSON.stringify(component.get('v.Shipment')));*/
        //component.set('v.Shipment',newShipment);
        helper.createnewShipment(component, newShipment); 
    },
   
    updateShipmentProduct:function(component,event,helper)
    {
      /*   let conID22=component.get('v.Shipment.sigmaerpdev2__Delivery_Person__c'); 
        let conID33=component.get('v.conID'); 
        console.log('conID22'+JSON.stringify(conID22));
         console.log('conID33'+JSON.stringify(conID33));
        if(conID22)
        { 
            component.set("v.Shipment.sigmaerpdev2__Delivery_Person__c",conID22);
          
        }
        else
        {
                  alert('Please enter Contact Person name.');
            //logisticName.set("v.errors", [{message:"Please enter logistics name."}]);   	                	 
            return;         
        } */
         console.log('Shipment'+JSON.stringify(component.get('v.Shipment')));
      // return;
         //alert("hai");
       
        //return;
        var Shipment = new Date(component.get("v.Shipment.sigmaerpdev2__Shipment_Date__c"));
        var oldstatus=component.get("v.Shipment.sigmaerpdev2__Status__c");
        var newstatus=component.find('headerSectionstatus').get("v.value");
       // alert(JSON.stringify(component.get("v.Shipment")));
       // alert(JSON.stringify(component.find('headerSectionstatus').get("v.value")));
        // alert('oldstatus>>'+oldstatus);
       // alert('newstatus>>'+newstatus);
        var statusComp = component.find('headerSectionstatus');
        if(oldstatus==='Ready To Ship' && newstatus==='Delivered'	)
        {
                  
            statusComp.set("v.errors", [{message:"Status cannot be set to Delivered before creating shipment"}]);      	                	 
            return null; 
        
       
        }
         else{
            statusComp.set("v.errors", null);
        }
        
       // alert('newstatus>>'+newstatus);
       // return;
        var deleverPerson1=component.find("deleverPerson").get("v.value");         
        if(deleverPerson1 === undefined || deleverPerson1 === '')
        {                      
            alert('Please enter Delivery Person name.');
            //logisticName.set("v.errors", [{message:"Please enter logistics name."}]);   	                	 
            return; 
        }
        else
        {
            component.set("v.Shipment.sigmaerpdev2__Delivery_Person1__c",deleverPerson1);            
        } 
        
        var statusComp = component.find('headerSectionstatus');
        var statusCompValue = statusComp.get('v.value');
        if(statusCompValue === undefined || statusCompValue === '--Select--')
        {     
            alert('Please select shipment status.');
            //statusComp.set("v.errors", [{message:"Please select shipment status."}]);      	                	 
            return null; 
        }
        else{
            statusComp.set("v.errors", null);
        }
        
        var dateComp = component.find('DateTime');
        var dateCompValue = dateComp.get('v.value');        
        if(dateCompValue == '' || dateCompValue == undefined)
        {           
            alert('Please select Shipment Date.');
            //dateComp.set("v.errors", [{message:"Please select Shipment Date."}]);      	                	 
            return null; 
        }
        else{
            dateComp.set("v.errors", null);
        }
        var today = new Date();
        var todaydate = new Date( today.getFullYear()+ "-" +(today.getMonth() + 1)+ "-" + today.getDate());
        var orderdate = new Date(Shipment.getFullYear()+ "-" +(Shipment.getMonth() + 1)+ "-" + Shipment.getDate() );
        
        if(orderdate < todaydate)
        {
            alert('Shipment date Should be greater than or equal to today\'s date.');
            //var msg = 'Shipment date Should be greater than or equal to today\'s date.';
            //dateComp.set("v.errors", [{message:msg}]);      	                	 
            return null; 
        }
        else
        {
            dateComp.set("v.errors", null);
        }
        
        
        var headStatus=component.get("v.headStatus");
         console.log("Shipment>>>>"+JSON.stringify(component.get("v.Shipment")));
        if(JSON.stringify(headStatus)!=='""')
        component.set("v.Shipment.sigmaerpdev2__Status__c",headStatus);  
        console.log("Shipment>>>>"+JSON.stringify(component.get("v.Shipment")));
         console.log("headStatus>>>>"+JSON.stringify(headStatus));
         var ShipmentProductItem=component.get('v.ShipmentProduct');
         // alert('ShipmentProductItem>>'+JSON.stringify( ShipmentProductItem));
       // return;
        var shipmentlineItems=[];
        if(ShipmentProductItem!=undefined)
        {
            shipmentlineItems.push(ShipmentProductItem);
        }
        component.set("v.ShipmentProducts",shipmentlineItems);
        var newShipmentProducts = component.get("v.ShipmentProducts");
        if(newShipmentProducts.length < 1)
        {
            alert('Product has been deleverd.');
            //alert('Please add packages for shipment.');
            return null;
        }
          if(component.get("v.isError")==true)
        {
             var msg = "Please select valid status ";
            component.set("v.errorMsg", msg);
            return null;
        }
       // alert(component.find("headerSectionstatus").get("v.value"));
       // alert(component.get("v.ShipmentProducts.sigmaerpdev2__Status__c"));
        //component.set("v.package.sigmaerpdev2__Status__c",component.find("headerSectionstatus").get("v.value"));  
        var updateshipment = component.get("v.Shipment");
        var conName=component.get('v.conName');
         var conID=component.get('v.conID');
        console.log('conName'+JSON.stringify(conName))
         console.log('conID'+JSON.stringify(conID))
         if(conID)
        updateshipment.sigmaerpdev2__Delivery_Person__c=conID;
        if(conName)
        updateshipment.sigmaerpdev2__Delivery_Person__r.Name=conName;
       // updateshipment.sigmaerpdev2__Delivery_Person__c=component.get("v.SContact");
        updateshipment.sigmaerpdev2__Account__c=component.get("v.SAccount");
      	updateshipment.sigmaerpdev2__Selected_Courier__c=component.get("v.selectedCourier");
        //for single package
        
       console.log('updateshipment>>'+JSON.stringify(updateshipment));
       // return;
        
             document.getElementById("Accspinner").style.display = "block";
        setTimeout(function(){ document.getElementById("Accspinner").style.display = "none"; }, 5000);
     
        
        var shipmentProd = component.get("v.ShipmentProducts");
        if(updateshipment && updateshipment.sigmaerpdev2__Status__c)
         component.set("v.ShipmentProducts.sigmaerpdev2__Status__c",updateshipment.sigmaerpdev2__Status__c);
        else if(component.find("headerSectionstatus").get("v.value"))
            component.set("v.ShipmentProducts.sigmaerpdev2__Status__c",component.find("headerSectionstatus").get("v.value"));
        console.log('ShipmentProducts>>'+JSON.stringify(component.get("v.ShipmentProducts")));
        	
       // component.set("v.ShipmentProducts.sigmaerpdev2__Status__c",component.find("headerSectionstatus").get("v.value"));
        			//var ShipmentProducts=Json.stringify(component.get("v.ShipmentProducts")).sigmaerpdev2__Status__c=component.find("headerSectionstatus").get("v.value");
                      // alert(ShipmentProducts);
        	//ShipmentProducts.sigmaerpdev2__Status__c=component.find("headerSectionstatus").get("v.value");  
        			// alert(ShipmentProducts);
        //component.set("v.ShipmentProducts",ShipmentProducts);
        var action = component.get("c.updateShipment");
        action.setParams({ 
            "shipmentObj": updateshipment,
          	 //"shipmentProduts" : JSON.stringify(component.get("v.ShipmentProducts"))//$A.util.json.encode(component.get("v.packageProducts"))
        	"shipmentProduts" : JSON.stringify(component.get("v.ShipmentProducts"))
        });
        action.setCallback( this, function(a) 
                           {
                               var state = a.getState();
                               console.log("success>>"+state);
                               if (state === "SUCCESS") 
                               {
                                   component.set("v.curRecordID",a.getReturnValue().Id);
                                   if(a.getReturnValue() != null)
                                   {
                                       console.log('a>>>>>'+JSON.stringify(a.getReturnValue()));
                                       let Name=a.getReturnValue().Name;
                                       console.log("name:::"+JSON.stringify(Name));
                                       if ((typeof sforce !== 'undefined') && sforce && (!!sforce.one))
                                       {
                                           var successAlert = component.find("successAlert");
                                           $A.util.removeClass(successAlert,'slds-hide');
                                           var recordCreatedHeader = component.find("recordCreatedHeader");
                                           $A.util.addClass(recordCreatedHeader,'slds-hide');
                                           var recordUpdtatedHeader = component.find("recordUpdtatedHeader");
                                           $A.util.removeClass(recordUpdtatedHeader,'slds-hide');
                                            $A.get('e.force:refreshView').fire();//added on-01-05-2020
                                       }else
                                       {
                                           //window.location.href = "/" + a.getReturnValue().Id;
                                           //commented above line and added below line on 7-2-2020 to show in SalesOrderModules UI page after update button is pressed                                           
                                           var toastEvent = $A.get("e.force:showToast");
                                           toastEvent.setParams({
                                               "type":"success",
                                               "title": "Success!",
                                               "message": Name+" Shipment record updated successfully!"
                                           });
                                           toastEvent.fire();                                            
                                           var evt = $A.get("e.force:navigateToComponent");
                                           evt.setParams({
                                               componentDef : "c:SalesOrderModules",
                                               componentAttributes: {
                                                   from : 'Shipment'
                                               }
                                           });
                                           evt.fire();
                                           //ends here
                                            $A.get('e.force:refreshView').fire();//added on-01-05-2020
                                            document.getElementById("Accspinner").style.display = "none";
                                           
                                       }    
                                   } else
                                   {
                                        $A.get('e.force:refreshView').fire();//added on-01-05-2020
                                       var successAlert = component.find("successAlert");
                                       $A.util.removeClass(successAlert,'slds-hide');
                                       var successAlertTheme = component.find("successAlertTheme");
                                       $A.util.removeClass(successAlertTheme,'slds-theme--success');
                                       $A.util.addClass(successAlertTheme,'slds-theme--error');
                                       var iconsuccess=component.find("iconsuccess");
                                       $A.util.addClass(iconsuccess,'slds-hide');
                                       var iconwarning=component.find("iconwarning");
                                       $A.util.removeClass(iconwarning,'slds-hide');
                                       var recordCreatedHeader = component.find("recordCreatedHeader");
                                       $A.util.addClass(recordCreatedHeader,'slds-hide');
                                       var recordNotUpdtatedHeader = component.find("recordNotUpdtatedHeader");
                                       $A.util.removeClass(recordNotUpdtatedHeader,'slds-hide');
                                       var recordCreatedOK = component.find("recordCreatedOK");
                                       $A.util.addClass(recordCreatedOK,'slds-hide');
                                       var recordCreatedCancel = component.find("recordCreatedCancel");
                                       $A.util.removeClass(recordCreatedCancel,'slds-hide'); 
                                        $A.get('e.force:refreshView').fire();//added on-01-05-2020
                                   }   
                               }
                               else
                               {
                                    $A.get('e.force:refreshView').fire();//added on-01-05-2020
                                   var successAlert = component.find("successAlert");
                                   $A.util.removeClass(successAlert,'slds-hide');
                                   var successAlertTheme = component.find("successAlertTheme");
                                   $A.util.removeClass(successAlertTheme,'slds-theme--success');
                                   $A.util.addClass(successAlertTheme,'slds-theme--error');
                                   var iconsuccess=component.find("iconsuccess");
                                   $A.util.addClass(iconsuccess,'slds-hide');
                                   var iconwarning=component.find("iconwarning");
                                   $A.util.removeClass(iconwarning,'slds-hide');
                                   var recordCreatedHeader = component.find("recordCreatedHeader");
                                   $A.util.addClass(recordCreatedHeader,'slds-hide');
                                   var recordNotUpdtatedHeader = component.find("recordNotUpdtatedHeader");
                                   $A.util.removeClass(recordNotUpdtatedHeader,'slds-hide');
                                   var recordCreatedOK = component.find("recordCreatedOK");
                                   $A.util.addClass(recordCreatedOK,'slds-hide');
                                   var recordCreatedCancel = component.find("recordCreatedCancel");
                                   $A.util.removeClass(recordCreatedCancel,'slds-hide'); 
                                    $A.get('e.force:refreshView').fire();//added on-01-05-2020
                               }
                           });
       
        $A.enqueueAction(action);
        // $A.get('e.force:refreshView').fire();//added on-01-05-2020
    },
    
    SelectedID : function(component, event) {
        
        var context = event.getParam("instanceId");
        var objectId = event.getParam("sObjectId");
        if(context ==='MyPAccount')
        {
            component.set("v.SAccount",objectId);
            
        }else if(context ==='MyPContact')
        {
            
            component.set("v.SContact",objectId);  
        }
        
    },
 
    
     saveStatus : function(component, event) {
         var shipId=JSON.stringify(component.get("v.Shipment").Id);
         // console.log(JSON.stringify(component.get("v.Shipment").Id));
          console.log(component.find("headerSectionstatus").get("v.value"));
         console.log('shipId>>>'+shipId);
         if(component.get("v.ShipmentProduct")!=undefined)
		component.set("v.ShipmentProduct.sigmaerpdev2__Status__c",component.find("headerSectionstatus").get("v.value"));
         if(shipId===undefined)
         {
             //alert('ShipmentProducts>>'+JSON.stringify(component.get("v.ShipmentProducts")));
             //alert('Shipment>>'+JSON.stringify(component.get("v.Shipment")));
         console.log('ShipmentProducts>>'+JSON.stringify(component.get("v.ShipmentProducts")));
         console.log('Id>>'+JSON.stringify(component.get("v.Shipment").Id));
      	 //  return;
        var Oldstatus=component.get("v.Shipment.sigmaerpdev2__Status__c");
       // alert(component.get("v.Shipment.sigmaerpdev2__Status__c"));
		 var Newstatus=component.find("headerSectionstatus").get("v.value");
            component.set("v.Shipment.sigmaerpdev2__Status__c",Newstatus); 
         if(JSON.stringify(component.get("v.ShipmentProducts"))=='[]')
         {
            // alert('please add line items');
             return;   
         }
         var ShipmentProducts=component.get("v.ShipmentProducts");
		 for (var i = 0; i < ShipmentProducts.length; i++) 
		 {
                   	ShipmentProducts[i].sigmaerpdev2__Status__c = component.get("v.Shipment.sigmaerpdev2__Status__c");
        }
        component.set("v.ShipmentProducts", ShipmentProducts);
            if(Newstatus=== '--Select--')
               {
            var msg = "Please select valid status";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;	
            }else{
                 component.set("v.Shipment.sigmaerpdev2__Status__c",Newstatus);  
                 component.set("v.isError",false);
			}
		}
        else
         {
             //alert('ShipmentProducts>>'+JSON.stringify(component.get("v.ShipmentProducts")));
     //    alert('Shipment>>'+JSON.stringify(component.get("v.Shipment")));
         console.log('ShipmentProducts>>'+JSON.stringify(component.get("v.ShipmentProducts")));
         console.log('Shipment>>'+JSON.stringify(component.get("v.Shipment").Id));
       //  return;
        var Oldstatus=component.get("v.Shipment.sigmaerpdev2__Status__c");
       // alert(component.get("v.Shipment.sigmaerpdev2__Status__c"));
		 var Newstatus=component.find("headerSectionstatus").get("v.value");
		 
		 
		 
            component.set("v.headStatus",Newstatus); 
         if(JSON.stringify(component.get("v.ShipmentProducts"))=='[]')
         {
            // alert('please add line items');
             return;   
         }
         var ShipmentProducts=component.get("v.ShipmentProducts");
		 for (var i = 0; i < ShipmentProducts.length; i++) 
		 {
					
                   	ShipmentProducts[i].sigmaerpdev2__Status__c = component.get("v.headStatus");
        }
        component.set("v.ShipmentProducts", ShipmentProducts);
     //   alert(Newstatus);
		if((Oldstatus=='Ready To Ship' ))
		{
                
          //  var st=component.find("headerSectionstatus").get("v.value");
            if(Newstatus==='--Select--'){
                           // alert(st);
			// alert('in ready to ship');
			 var msg = "Please select valid status";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;

            }else{
				            component.set("v.headStatus",Newstatus);  
                 component.set("v.isError",false);
			}
            
		}
		else if(Oldstatus=='Shipped')
		{
			//var st=component.find("headerSectionstatus").get("v.value");
           // alert(st);
			if(Newstatus==='--Select--' | Newstatus==='Ready To Ship')
			{
				 var msg = "Product has been shipped Please select valid status ";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
				
			}
			else{
				
				component.set("v.headStatus",Newstatus);  
                component.set("v.isError",false);
			}
		}
		else if(Oldstatus=='Delivered')
		{
			var st=component.find("headerSectionstatus").get("v.value");
           // alert(st);
		
			//if(st=='Delivered' && (st!='--Select--' |st!='Ready To Ship' | st!='Shipped'))
			if(Newstatus==='--Select--' | Newstatus==='Ready To Ship' | Newstatus==='Shipped')
			{
				 var msg = "Product has been Delivered Please select valid status ";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
				
			}
			else{
				component.set("v.headStatus",Newstatus);  
                component.set("v.isError",false);
			}
		}
             
         }
         
         
	

        //component.set("v.Shipment.sigmaerpdev2__Status__c",component.find("headerSectionstatus").get("v.value"));  
    },
    
    cancelButton:function(cmp, event){
        
        /*window.self.close();
        window.history.back();*/
        
        //commented above line and added below line on 7-2-2020 to show in SalesOrderModules UI page after cancel button is pressed
        //alert("hai");
        //document.getElementById("Accspinner").style.display = "block";
        //setTimeout(function(){ document.getElementById("Accspinner").style.display = "none"; }, 5000);
     
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:SalesOrderModules",
            componentAttributes: {
                from : 'Shipment'
            }
        });
        evt.fire();
         $A.get('e.force:refreshView').fire();
        //ends here
    },
    
    addShipmentProducts : function(component,event,helper)
    {
        var logName = component.get("v.selectedCourier")   
        if(logName === '' || logName === null)
        {
            var msg = "Please enter logistics name.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
            
        }
        var shipdate = component.get("v.Shipment.sigmaerpdev2__Shipment_Date__c");
        var today = new Date();
        component.set('v.today', today.getFullYear()+ "-" +(today.getMonth() + 1)+ "-" + today.getDate() );
        var date = new Date(component.get("v.today"));
        var someDate = new Date(component.get("v.Shipment.sigmaerpdev2__Shipment_Date__c"));
        component.set('v.Shipmentdate', someDate.getFullYear()+ "-" +(someDate.getMonth() + 1)+ "-" + someDate.getDate() );
        
        var orderdate = new Date(component.get("v.Shipmentdate"));
        if(orderdate < date)
        {
            var msg = "Shipment Date Should be greater than or Equal to Today Date.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;            
        }
        else
        { 
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        component.set("v.isOpen", true);
        
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    
    recordCreatedOK: function(component, event, helper) 
    {
        
        sforce.one.navigateToSObject(component.get("v.curRecordID"));        
    },
    
    recordCreatedCancel: function(component, event, helper) 
    {
        var successAlert = component.find("successAlert");
        $A.util.addClass(successAlert,'slds-hide');        
    }
})