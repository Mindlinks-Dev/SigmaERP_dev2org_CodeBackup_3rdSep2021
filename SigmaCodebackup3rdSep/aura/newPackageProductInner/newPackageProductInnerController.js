({
    
    doInit : function(component, event, helper){
        var oneshotflag = component.get("v.isoneshot");
        var isStandardOrder = component.get("v.isStandardOrder");
        if(component.get("v.AddorEdit") == undefined){
            var initialOrdQty = component.get("v.orderedQnt");
            component.set("v.orderItemNew.allocatedQnty",initialOrdQty); 
        }
        //added on 28/03/2018 to one shot package by chandana
        if(oneshotflag==true)
        {
           // var tempcheckbox = component.get("v.orderItemNew.isSelected");
            component.set("v.orderItemNew.isSelected",true)
            //alert('inner comp:'+JSON.stringify(component.get("v.orderItemNew.isSelected"))); 
            var temporderdqty=component.get("v.orderedQnt");
            component.set("v.orderItemNew.allocatedQnty",temporderdqty) 
            //alert('inner comp:'+JSON.stringify(component.get("v.orderItemNew.allocatedQnty"))); 
        }
        //added on 25/12/2017 to support partial packaging
        var enteredQuantity = component.get("v.orderItemNew.allocatedQnty"); 
        var transItemId= component.get("v.transItem");
		//new code to check for standard object 
		if(isStandardOrder == true)
		{
			//alert('inside @114 of packageInner');
			
			var action29 = component.get("c.getstandRemainingQtyToPackage"); //get remaining qty to package
			action29.setParams({
            "transLineId" : transItemId
			}); 
			action29.setCallback( this, function(response2) {
            var state2 = response2.getState();
            if (state2 === "SUCCESS"){
                var respValue = response2.getReturnValue();
                if(respValue > 0){
                    if(enteredQuantity > respValue){
                        component.set("v.orderItemNew.allocatedQnty",0);
                        alert('Packaged quantity must be less than or equal to '+respValue+' as this Order Line has been partially packaged already.');
                        component.set("v.orderItemNew.allocatedQnty",0);
                        return;    
                    }    
                }                
            }
        });
        $A.enqueueAction(action29);
        //ends here
		}
		else{
			
        var action29 = component.get("c.getRemainingQtyToPackage"); //get remaining qty to package
        action29.setParams({
            "transLineId" : transItemId
        }); 
        action29.setCallback( this, function(response2) {
            var state2 = response2.getState();
            if (state2 === "SUCCESS"){
                var respValue = response2.getReturnValue();
                if(respValue > 0){
                    if(enteredQuantity > respValue){
                        component.set("v.orderItemNew.allocatedQnty",0);
                        alert('Packaged quantity must be less than or equal to '+respValue+' as this Order Line has been partially packaged already.');
                        component.set("v.orderItemNew.allocatedQnty",0);
                        return;    
                    }    
                }                
            }
        });
        $A.enqueueAction(action29);
        //ends here
		}
		
    },
    //added for select box popup
    onSelectChange : function(component, event, helper) {
        var selected = event.getSource().get('v.value');  
        var res = selected.split("_");        
        var isMan = false;
        if(res[0] == 'Manual'){
            isMan = true; 
        }  
        component.set("v.isManual",isMan);        
        
        if(isMan){ 
            
            helper.showPopupHelper(component, 'modaldialogFastEntry', 'slds-fade-in-'); 
            component.set("v.selTransLineItemId",res[1]);
            
            var spinner = component.find('spinner');
            $A.util.addClass(spinner, "slds-hide");
            document.getElementById("showLink").style.display="block";
        }        
        
    },
    
    selectAutopick : function(component,event,helper)
{
        
        //added on 14/2/2018 to provide validation to do autopick only if that respective product is selected for packaging
        var rowSelected = component.get("v.orderItemNew.isSelected");        
        if(rowSelected == false){
            alert('Auto Allocation is possible only when product is selected for packaging.');
            return false;
        }		
        //ends here
        
        var selectedRowID = event.target.id;
        var res = selectedRowID.split("_"); 
        
        var transId = component.get("v.selTransId");  
        //used to set transId to v.selTransId as it was getting empty during edit flow[i.e.page load during edit] 
        var mainList = component.get("v.orderItemNew.prodwrap");
		//alert('main list in autopic ::'+JSON.stringify(component.get("v.orderItemNew.prodwrap")));
		//alert('main length ::'+mainList.length);
        for(var i = 0;i<mainList.length;i++){
            if(component.get("v.selTransId") == ''){                
                transId = mainList[i].transId;               
            }            
        }
        
        //ends here
        
        var transItemId= component.get("v.transItem");
        var productId = component.get("v.orderItemNew.prodId");               
        var orderQty = component.get("v.orderedQnt");
        var packQty = component.get("v.orderItemNew.allocatedQnty");
        //alert('transItem::'+JSON.stringify(component.get("v.transItem")));
		//alert('prodId::'+JSON.stringify(component.get("v.orderItemNew.prodId")));
		//alert('orderedQnt::'+JSON.stringify(component.get("v.orderedQnt")));
		//alert('allocatedQnty::'+JSON.stringify(component.get("v.orderItemNew.allocatedQnty")));
		
		
        if(packQty == 0 || packQty == ''){
            alert('Packaged Quantity value must be greater than zero to Autopick Stock.');
            return false;
        }
        var autoAllocate = true; //set auto allocate to true during autopick flow
        
        var chosenStatus = component.get("v.selStatus");
        if(chosenStatus == 'In Progress' || chosenStatus == ''){
            alert('Auto Allocation is possible only when Order Line Status is Ready.');
            return;
        }        
        
        var retVal = confirm("Are you sure you want to Allocate Stock Automatically?");
        if( retVal == true ){
            var spinner = component.find('spinner');
            $A.util.removeClass(spinner, "slds-hide");            
            document.getElementById('manualDiv_'+res[1]).className = "disabledbutton";
            document.getElementById('autopickDiv_'+res[1]).className = "";
            var isStandardOrder = component.get("v.isStandardOrder");
			if(isStandardOrder == true)
			{
				//alert('stand function to execute  AllocateStockUsingFIFODuringStandPackage');
				var action21 = component.get("c.AllocateStockUsingFIFODuringStandPackage"); //calling auto allocate method  - added on 1/12/2017
				action21.setParams({ 
                "transId" : transId,
                "transLineId" : transItemId,
                "ProductId" : productId,               
                
                "OrderedQty" : packQty //pass package qty instead of ordered qty
            });
            action21.setCallback( this, function(response) 
			{
                var state = response.getState();
                
                if (state === "SUCCESS") {                        
                    var spinner = component.find('spinner');
                    $A.util.addClass(spinner, "slds-hide");
                    var result = response.getReturnValue();
                    
                    if(result == true){
                        alert('Auto Allocation done successfully.');
                        var disableChkbox = component.find("checkbox");                
                        disableChkbox.set("v.disabled", true);
                        //ends here
                        //call Component event to make Parent Status field to Readonly by firing events
                        var compEvent = component.getEvent("sampleComponentEventNew"); 
                        compEvent.fire();
                        //ends here 
                        
                        //added below line on 18/12/2017 to avoid clicking of Autopick again [even after allocation is done using Autopick]
                        document.getElementById('autopickDiv_'+res[1]).className = "disabledbutton";
                        var action25 = component.get("c.getstandAutopickedStock"); //get back dynamically allocated stock - added on 3/12/2017
                        action25.setParams({ 
                            "orderId" : transId,
                            "transLineId" : transItemId
                        }); 
                        action25.setCallback( this, function(response1) {
                            var state1 = response1.getState();
                            if (state1 === "SUCCESS"){
                                component.set("v.orderItemNew.prodwrap",response1.getReturnValue());
                                component.set("v.orderItemNew.packProd.sigmaerpdev__Auto_allocate__c",autoAllocate);                                    
                            }
                        });
                        $A.enqueueAction(action25); 
                    }else if(result == false){                              
                        alert('Not enough stock to do Auto allocation.Try Manual Allocation.');                            
                        document.getElementById('manualDiv_'+res[1]).className = "";
                        document.getElementById('autopickDiv_'+res[1]).className = "disabledbutton";
                    }
                }
            });
            $A.enqueueAction(action21); 
			}
			else {
				var action21 = component.get("c.AllocateStockUsingFIFODuringPackage"); //calling auto allocate method  - added on 1/12/2017
            action21.setParams({ 
                "transId" : transId,
                "transLineId" : transItemId,
                "ProductId" : productId,               
                
                "OrderedQty" : packQty //pass package qty instead of ordered qty
            });
            action21.setCallback( this, function(response) 
			{
                var state = response.getState();
                
                if (state === "SUCCESS") {                        
                    var spinner = component.find('spinner');
                    $A.util.addClass(spinner, "slds-hide");
                    var result = response.getReturnValue();
                    
                    if(result == true){
                        alert('Auto Allocation done successfully.');
                        var disableChkbox = component.find("checkbox");                
                        disableChkbox.set("v.disabled", true);
                        //ends here
                        //call Component event to make Parent Status field to Readonly by firing events
                        var compEvent = component.getEvent("sampleComponentEventNew"); 
                        compEvent.fire();
                        //ends here 
                        
                        //added below line on 18/12/2017 to avoid clicking of Autopick again [even after allocation is done using Autopick]
                        document.getElementById('autopickDiv_'+res[1]).className = "disabledbutton";
                        var action25 = component.get("c.getAutopickedStock"); //get back dynamically allocated stock - added on 3/12/2017
                        action25.setParams({ 
                            "orderId" : transId,
                            "transLineId" : transItemId
                        }); 
                        action25.setCallback( this, function(response1) {
                            var state1 = response1.getState();
                            if (state1 === "SUCCESS"){
                                component.set("v.orderItemNew.prodwrap",response1.getReturnValue());
                                component.set("v.orderItemNew.packProd.sigmaerpdev__Auto_allocate__c",autoAllocate);                                    
                            }
                        });
                        $A.enqueueAction(action25); 
                    }else if(result == false){                              
                        alert('Not enough stock to do Auto allocation.Try Manual Allocation.');                            
                        document.getElementById('manualDiv_'+res[1]).className = "";
                        document.getElementById('autopickDiv_'+res[1]).className = "disabledbutton";
                    }
                }
            });
            $A.enqueueAction(action21); 
			}   
        }
        else{            
            return false;
        }
        
    },
    selectManual : function(component,event,helper){
        
        //added on 14/2/2018 to provide validation to do manual selection only if that respective product is selected for packaging
        var rowSelected = component.get("v.orderItemNew.isSelected");        
        if(rowSelected == false){
            alert('Select is possible only when product is selected for packaging.');
            return false;
        }		
        //ends here
        
        var packQty = component.get("v.orderItemNew.allocatedQnty");
        if(packQty == 0 || packQty == ''){
            alert('Packaged Quantity value must be greater than zero to Select stock.');
            return false;
        } 
        //var Mismatchflagselect = component.get("v.mismatchflag");
        var selectedRowID = event.target.id;
        var res = selectedRowID.split("_");
        var transId = component.get("v.selTransId");
        //used to set transId to v.selTransId as it was getting empty during edit flow[i.e.page load during edit] 
        
        //ends here
        
        var transItemId= component.get("v.transItem");
        var autoAllocate = false; //set auto allocate to false during manual flow
        var retVal = confirm("Are you sure you want to Select Stock Manually?");
        if( retVal == true ){            
            if(document.getElementById('autopickDiv_'+res[1]) != null){
                document.getElementById('autopickDiv_'+res[1]).className = "disabledbutton";    
            }        	
            document.getElementById('manualDiv_'+res[1]).className = ""; 
            var isMan = true; 
            var selTransLineId = component.get("v.orderItemNew.transLineItemId");        
            component.set("v.isManual",isMan);           
            if(isMan){ 
                helper.showPopupHelper(component, 'modaldialogFastEntry', 'slds-fade-in-'); 
                component.set("v.selTransLineItemId",selTransLineId);         
                //alert('inside ismanulselect befor manul select ::'+JSON.stringify(component.get("v.selTransLineItemId",selTransLineId)));
                
                //new code added to byfoget on standard object getstandManualStock
                var localvar= component.get("v.isStandardOrder");  
                //alert('localvar@214::'+localvar);
                if(localvar == true)
                {
					var action26 = component.get("c.getstandManualStock"); //get product ilpli list for manual selection - added on 3/12/2017
                action26.setParams({ 
                    "orderId" : transId,
                    "transLineId" : transItemId
                }); 
                action26.setCallback( this, function(response2) {
                    var state2 = response2.getState();
                    if (state2 === "SUCCESS"){
                        component.set("v.orderItemNew.prodwrap",response2.getReturnValue());
                        component.set("v.orderItemNew.packProd.sigmaerpdev__Auto_allocate__c",autoAllocate);
                    }
                });
                $A.enqueueAction(action26);                    
                }
                else
                {
                    var action26 = component.get("c.getManualStock"); //get product ilpli list for manual selection - added on 3/12/2017
                action26.setParams({ 
                    "orderId" : transId,
                    "transLineId" : transItemId
                }); 
                action26.setCallback( this, function(response2) {
                    var state2 = response2.getState();
                    if (state2 === "SUCCESS"){
                        component.set("v.orderItemNew.prodwrap",response2.getReturnValue());
                        component.set("v.orderItemNew.packProd.sigmaerpdev__Auto_allocate__c",autoAllocate);
                    }
                });
                $A.enqueueAction(action26);
                }
       
            }    
        }else{            
            return false;
        }
        
    },
    
    doValidate : function(component, event, helper){      
       
        var ordQty = component.get("v.orderedQnt");
        var enteredQuantity = component.get("v.orderItemNew.allocatedQnty"); 
        if(enteredQuantity > ordQty){
            alert('Package Quantity must be less than or equal to Ordered Quantity.');
            component.set("v.orderItemNew.allocatedQnty",0);
            return;
        }
        // validation on negative and spec-character by chandana 
        if(enteredQuantity < 0){
            alert('Enter valid Package Quantity')
            component.set("v.orderItemNew.allocatedQnty",0);
            return;
        }
        var iChars = "!`@#$%^&*()+=-[]\\\';,./{}|\":<>?~_"; 
        var data= component.get("v.orderItemNew.allocatedQnty");
        
        for (var i = 0; i < data.length; i++)
        {   
            if (iChars.indexOf(data.charAt(i)) != -1)
            {    
                alert ("Your string has special characters. \nThese are not allowed in package quantity .");
                component.set("v.orderItemNew.allocatedQnty",0);
                return false; 
            } 
        }
        //added by chandana  on 12 July 2018 to remove data 
        var Mismatchflag = component.get("v.mismatchflag");
		//alert('Mismatchflag::'+Mismatchflag);
		component.set("v.mismatchflag",true);
        //alert('productwrap:::'+JSON.stringify(component.get("v.orderItemNew.prodwrap")));
       //alert('productwrap:::'+JSON.stringify(component.get("v.orderItemNew.prodwrap")));
        var productwrap = component.get("v.orderItemNew.prodwrap");
        var prodlength= productwrap.length;
      
		for (var i = 0; i < productwrap.length; i++)
        {
            //alert('inside first for loop');
			for (var j = 0; j < productwrap[i].wrapProdList.length; j++)
			{
                //alert('etting product wrap to empty ');
				productwrap[i].wrapProdList[j].alpAvailableQuantity = '';
			}
		}
       // alert('productwrap1111:::'+JSON.stringify(component.get("v.orderItemNew.prodwrap")));
        
        
        //added by vdt on 10 July 2018 to remove data from ilpli list that is selected in manual flow
        //component.set("v.orderItemNew",[]);
        var productwrap = component.get("v.orderItemNew.prodwrap");
        var flag= component.get("v.isManual");
        //alert('flag::'+flag);
        //var orderItemvar = component.get("v.orderItemNew"); 
        //alert('orderItemvar length ::'+orderItemvar.length);
        //alert('productwrap:::'+JSON.stringify(component.get("v.orderItemNew.prodwrap")));
        //alert('orderItemvar[0] prodwrap length ::'+productwrap.length);
        if(productwrap.length != 0|| productwrap.length == ''|| productwrap.length >= 0)
        {
           //alert('inside if ');
        }
        else{
            
            //alert('inside lengthproductwrap');
            //component.set("v.productwrap",[]);

            while (productwrap.length > 0) 
            {
                productwrap.pop();
            }
            //alert('final length ::'+productwrap.length);
        }
        
        //added on 25/12/2017 to support partial packaging
        var enteredQuantity = component.get("v.orderItemNew.allocatedQnty"); 
        var transItemId= component.get("v.transItem");
        var action29 = component.get("c.getRemainingQtyToPackage"); //get remaining qty to package
        action29.setParams({
            "transLineId" : transItemId
        }); 
        action29.setCallback( this, function(response2) {
            var state2 = response2.getState();
            if (state2 === "SUCCESS"){
                var respValue = response2.getReturnValue();
                
                if(respValue > 0){
                    if(enteredQuantity > respValue){
                        alert('Packaged quantity must be less than or equal to '+respValue+' as this Order Line has been partially packaged already.');
                        component.set("v.orderItemNew.allocatedQnty",0);
                        return;    
                    }    
                }                
            }
        });
        $A.enqueueAction(action29);
        //ends here         
    },
    //added for virtual bom on 6-12-2017
    getInvQuant:function(component, event, helper){        
        //alert('getInvQuant');
        var pl = component.get("v.orderItemNew"); // new product list for autopick
        
        if(pl.isSelected===true)
        {
            var action = component.get("c.getInventoryId");
            action.setParams({ "prodId": pl.prodId });
            action.setCallback( this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    
                    var response= action.getReturnValue();
                    
                    component.set("v.InventoryID",response.Id);
                    
                    component.set("v.InventoryQuant",response.sigmaerpdev__Available_Qty__c);
                    
                    if(response.sigmaerpdev__Available_Qty__c<0 && response.sigmaerpdev__ProductCode__r.sigmaerpdev__BOM_Type__c=='Virtual')
                    {
                        
                        component.set("v.VBOMflag",true);
                    }
                    else{
                        
                    }
                }
                
            });
            
            $A.enqueueAction(action);
            
        }
        else{
            //alert('Nothing');
        }   
    },
    openpopup: function(component, event, helper) {
        
        
        helper.VBOMwindow(component, event, helper);
        
    },
    //ends here
})