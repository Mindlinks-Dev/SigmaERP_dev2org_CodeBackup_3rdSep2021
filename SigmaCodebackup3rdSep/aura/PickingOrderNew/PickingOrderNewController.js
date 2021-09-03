({
     fetchProductImageData:function (component, event, helper)
    {
        var dataForPicking=component.get('v.dataForPicking.PickingDuplicateDataWrap');
        console.log('dataForPicking>>'+JSON.stringify(dataForPicking));
         console.log('tar>>'+JSON.stringify( event.getSource()));
         console.log('tar>>'+JSON.stringify( event.target));
        var productId = event.getSource().get("v.accesskey");
        console.log('productId>>'+JSON.stringify( productId));
         if(JSON.stringify( productId)!='""')
         {
             if(productId)helper.fetchProductImageDataHelper(component, event, helper,productId);
         }
    },
    afterLocScaned2:function (component, event, helper){
        //alert('afterLocScaned2 ios calling');
        
        component.set("v.locationFoundFlag",false);
        /*if(!component.get('v.locBarCodeValue') || component.get('v.locBarCodeValue').length <5){
            //component.set("v.scannedProductName",'');
            //$A.util.removeClass(component.find('productNameDispaly'), 'slds-hide');
            //component.find('ProdName').set('v.value','');
            return;
        }*/
        
        var locBarCodeValue=component.get('v.locBarCodeValue');
         
      //  alert('afterLocScaned2 ios calling locBarCodeValue'+locBarCodeValue);
        window.setTimeout(
            $A.getCallback(function() {
                var locBarCodeValueInner=component.get('v.locBarCodeValue');
               //  alert('afterLocScaned2 ios calling locBarCodeValueInner'+locBarCodeValueInner.length);
                var locFound=false;
                var allProdPickedInThisLoc=false;
             //   alert('afterLocScaned2 ios calling locBarCodeValueInner'+locBarCodeValue.length);
                if(locBarCodeValueInner.length==locBarCodeValue.length)
                {
                    var pickingData=component.get('v.dataForPicking.PickingDuplicateDataWrap');
                  //      alert('afterLocScaned2 ios calling pickingData'+JSON.stringify(pickingData));
                   // alert(pickingData.size);
                    for(var i=0;i<pickingData.length;i++)
                    {
                     //   alert('pickingData[i].binBarCode'+pickingData[i].binBarCode)
                   //     alert('locBarCodeValue'+locBarCodeValue)
                        if(pickingData[i].binBarCode==locBarCodeValue)
                        {
                            var input = component.find("locScanedCode");
                            input.focus ();
                            
                            var locName=pickingData[i].zoneName?pickingData[i].zoneName:'None';
                            locName=locName+','+pickingData[i].binName;
                          //  alert(locName);
                            component.set("v.scannedLocationName",'('+locName+')');
                            //$A.util.removeClass(component.find('LocBinName'), 'slds-hide');
                            locFound=true;
                           // if(pickingData[i].reqQty==pickingData[i].totalPickedQty)
                             //   allProdPickedInThisLoc=true;
                            //component.find("LocBinName").set('v.value','('+pickingData[i].locName+','+pickingData[i].binName+')');
                            var rowData = document.getElementById("rowData_"+i);
                            //alert('rowData>'+rowData.length);
                            //alert('1>'+document.getElementById("rowData_1").offsetTop);
                            //alert(rowData.offsetTop);
                            //var scroller = component.find("scroller");
                            //scroller.scrollTo("bottom");
                            window.scrollTo(0, rowData.offsetTop);
                            //document.documentElement.scrollTop = rowData.offsetTop;
                            //document.body.scrollTop = rowData.offsetTop;
                            break;
                        }
                    }
                  //  alert(locFound);
                    if(locFound)
                    {
                       // component.set("v.locBarCodeValue",'');
                      //component.set("v.locationFoundFlag",true);
                        window.setTimeout(
                            $A.getCallback(function() {
                             // component.set("v.locationFoundFlag",false);
                            }), 10000
                        );
                         component.set("v.locationFoundFlag",true);
                        component.set("v.IsShowAndHidAutoPick",false);
                    }
                    else
                    {
                        component.set("v.scannedLocationName",'Not Found');
                        component.set("v.locationFoundFlag",true);
                        component.set("v.locationFoundFlag",true);
                        window.setTimeout(
                            $A.getCallback(function() {
                                if(!component.get('v.locBarCodeValue'))
                                    component.set("v.locationFoundFlag",false);
                            }), 1000
                        );
                    }
                    /*if(allProdPickedInThisLoc)
                {
                    $A.util.removeClass(component.find('LocBinName'), 'slds-hide');
                    component.set("v.locName",'Already');
                }*/
                }
            }),3000
        );
    },
    selectMalually: function(component, event, helper) {
		var isConfirm=confirm('Are you sure you want select Stock Manually!');
		if(isConfirm)
			helper.getILPLIDataForManSelect(component, event, helper);
	},
    doInit: function (component, event, helper) {
       // alert('calling');
          var StandOrderWrap=component.get('v.StandOrderWrap');
    
                     var originalILPLIData=component.get('v.originalILPLIData');
                    var ilpliIdAllocatedQuantMap1=component.get('v.ilpliIdAllocatedQuantMap1');
      
        var myPageRef = component.get("v.pageReference");
     
        if($A.get("$Browser.formFactor") !== "DESKTOP")
            component.set('v.mobileScreenFlag',true);
        
        if(component.get('v.soID')){
          
            helper.getPickingDataHelper(component, event, helper,component.get('v.soID'));
        }
        else if(myPageRef.state.soID && !component.get('v.goBackClickedFlag'))
        {
                    
            component.set('v.soID',myPageRef.state.soID);
            component.set('v.soName',myPageRef.state.soName);
            helper.getPickingDataHelper(component, event, helper,myPageRef.state.soID);
        }
    },
    reInit:function (component, event, helper){
       
        var myPageRef = component.get("v.pageReference");
      
        if($A.get("$Browser.formFactor") !== "DESKTOP")
            component.set('v.mobileScreenFlag',true);
        if(myPageRef.state.soID && !component.get('v.goBackClickedFlag'))
        {
            component.set('v.soID',myPageRef.state.soID);
            component.set('v.soName',myPageRef.state.soName);
            helper.getPickingDataHelper(component, event, helper,myPageRef.state.soID);
        }

    },
    handleLookupValueselected: function (component, event, helper) {
        
        helper.getPickingDataHelper(component, event, helper,component.get('v.soID'));
    },
    startPicking: function (component, event, helper) {
        component.set('v.isPickingStarted',true);
        component.set('v.isBarcodeScanned',true);
      
        helper.helperStartPicking(component, event, helper);
    },
    showPickedProducts:function (component, event, helper) {
        component.set('v.showHidenItems',!component.get('v.showHidenItems'));
    },
    clearAfterSORemove: function (component, event, helper) {
        if(!component.get('v.soID'))
        {
            component.set('v.dataForPicking',null);
            //var baskatName = component.find("baskatName");
            //component.set('v.basket','');
            //component.set('v.basketBarCodeValue','');
            //baskatName.set('v.value','');
            component.set('v.isBarcodeScanned',false);
        }
    },
    expandTogle:function (component, event, helper){
        var toggleText = component.find("DuplicateData");
        var down = component.find("down");
        var up = component.find("up");
        
        var idexOfAltPick = event.target.id;
        if(toggleText[idexOfAltPick]){
            $A.util.toggleClass(toggleText[idexOfAltPick], 'slds-hide');
            $A.util.toggleClass(down[idexOfAltPick], 'slds-hide');
            $A.util.toggleClass(up[idexOfAltPick], 'slds-hide');
        }
        else{
            $A.util.toggleClass(toggleText, 'slds-hide');
            $A.util.toggleClass(down, 'slds-hide');
            $A.util.toggleClass(up, 'slds-hide');
        }
	},
   
    afterLocScaned:function (component, event, helper){
        component.set("v.locationFoundFlag",false);
        var locBarCodeValue=component.get('v.locBarCodeValue');
        window.setTimeout(
            $A.getCallback(function() {
                var locBarCodeValueInner=component.get('v.locBarCodeValue');
                var locFound=false;
                var allProdPickedInThisLoc=false;
                if(locBarCodeValueInner.length==locBarCodeValue.length)
                {
                    var pickingData=component.get('v.dataForPicking.PickingDuplicateDataWrap');
                    for(var i=0;i<pickingData.length;i++)
                    {
                        if(pickingData[i].binBarCode==locBarCodeValue && pickingData[i].reqQty!=pickingData[i].totalPickedQty && !pickingData[i].hasAltPick)
                        {
                            var input = component.find("prodScanedCode");
                            input.focus ();
                            var locName=pickingData[i].zoneName?pickingData[i].zoneName:'None';
                            locName=locName+','+pickingData[i].binName;
                            component.set("v.scannedLocationName",'('+locName+')');
                            //$A.util.removeClass(component.find('LocBinName'), 'slds-hide');
                            locFound=true;
                            if(pickingData[i].reqQty==pickingData[i].totalPickedQty)
                                allProdPickedInThisLoc=true;
                            //component.find("LocBinName").set('v.value','('+pickingData[i].locName+','+pickingData[i].binName+')');
                            var rowData = document.getElementById("rowData_"+i);
                            window.scrollTo(0, rowData.offsetTop);
                            break;
                        }
                    }
                    if(locFound)
                    {
                        component.set("v.locationFoundFlag",true);
                         component.set("v.IsShowAndHidAutoPick",false);
                    }
                    else
                    {
                        component.set("v.scannedLocationName",'Not Found');
                        component.set("v.locationFoundFlag",true);
                    }
                }
            }), 1000
        );
    },
    afterProdScaned:function (component, event, helper){
        
        component.set("v.productFoundFlag",false);
        var prodBarCodeValue=component.get('v.prodBarCodeValue');
     
        window.setTimeout(
            $A.getCallback(function() {
                var prodBarCodeValueInner=component.get('v.prodBarCodeValue');
                var prodFound = false;
                var allProdPicked = false;
                var allPickedProdName = '';
                    var locBarCodeValue=component.get('v.locBarCodeValue');
                if(prodBarCodeValueInner.length==prodBarCodeValue.length)
                {
                    var pickingData=component.get('v.dataForPicking.PickingDuplicateDataWrap');
					let  autopick=component.get('v.autopick');                   
				   //  alert('afterProdScaned is called ::pickingData::'+pickingData);
                    for(var i=0;i<pickingData.length;i++)
                    {
						// if(pickingData[i].prodCode==prodBarCodeValue && pickingData[i].reqQty!=pickingData[i].totalPickedQty && locBarCodeValue==pickingData[i].binBarCode  && !pickingData[i].hasAltPick)
                        if(pickingData[i].prodCode==prodBarCodeValue && pickingData[i].reqQty!=pickingData[i].totalPickedQty &&   locBarCodeValue==pickingData[i].binBarCode  && !pickingData[i].hasAltPick)
                        {
							let found = pickingData[i].iaData.find(element => pickingData[i].prodName===element.sigmaerpdev2__ILPLI__r.sigmaerpdev2__Product__r.Name && pickingData[i].prodCode===element.sigmaerpdev2__ILPLI__r.sigmaerpdev2__Product__r.sigmaerpdev2__Product_Bar_Code__c && pickingData[i].prodId===element.sigmaerpdev2__ILPLI__r.sigmaerpdev2__Product__c);
						console.log(" found>>>"+JSON.stringify( found));
						if(found.sigmaerpdev2__ILPLI__r.sigmaerpdev2__Product__r.sigmaerpdev2__Attribute_Type__c==='SERIALIZED')
                        {
							if(autopick)
							{
							pickingData[i].totalPickedQty=pickingData[i].totalPickedQty? parseInt(pickingData[i].totalPickedQty)+1:1;
                            component.set("v.scannedProductName",pickingData[i].prodName);
                            //component.find("ProdName").set('v.value',pickingData[i].prodName);
                            prodFound=true;
                            //$A.util.removeClass(component.find('ProdName'), 'slds-hide');
                            if(pickingData[i].reqQty==pickingData[i].totalPickedQty){
                                allProdPicked=true;
                                allPickedProdName=pickingData[i].prodName;
                            }
                            //break;
							}else{
								  pickingData[i].totalPickedQty=pickingData[i].totalPickedQty? parseInt(pickingData[i].totalPickedQty)+1:1;
                            component.set("v.scannedProductName",pickingData[i].prodName);
                            //component.find("ProdName").set('v.value',pickingData[i].prodName);
                            prodFound=true;
                            //$A.util.removeClass(component.find('ProdName'), 'slds-hide');
                            if(pickingData[i].reqQty==pickingData[i].totalPickedQty){
                                allProdPicked=true;
                                allPickedProdName=pickingData[i].prodName;
                            }
                            break;
								
							}
							
						}
						else{
							  pickingData[i].totalPickedQty=pickingData[i].totalPickedQty? parseInt(pickingData[i].totalPickedQty)+1:1;
                            component.set("v.scannedProductName",pickingData[i].prodName);
                            //component.find("ProdName").set('v.value',pickingData[i].prodName);
                            prodFound=true;
                            //$A.util.removeClass(component.find('ProdName'), 'slds-hide');
                            if(pickingData[i].reqQty==pickingData[i].totalPickedQty){
                                allProdPicked=true;
                                allPickedProdName=pickingData[i].prodName;
                            }
                            break;
							
						}
                          
                        }
                    }
                    
                    component.set('v.dataForPicking.PickingDuplicateDataWrap',pickingData);
                  if(JSON.stringify(locBarCodeValue)=='""')
                    {
                        component.set("v.scannedLocationName",'please scan the bar code');
                         component.set("v.scannedProductName",'Not Found');
                        component.set("v.productFoundFlag",true);
                       //  component.set("v.scannedLocationName",'Not Found');
                        component.set("v.locationFoundFlag",true);
                        window.setTimeout(
                            $A.getCallback(function() {
                                if(!component.get('v.prodBarCodeValue'))
                                    component.set("v.productFoundFlag",false);
                            }), 3000
                        );
                        return ;
                    }
                    if(prodFound)
                    {
                   
                        component.set('v.prodBarCodeValue','');
                        component.set("v.productFoundFlag",true);
                        if(allProdPicked){
                       			component.set('v.locBarCodeValue','');
                            component.set("v.scannedProductName",'');
                        }
                    }
                    else
                    {
                   
                        component.set("v.scannedProductName",'Not Found');
                        component.set("v.productFoundFlag",true);
                    }
                
                    if(allProdPicked){
                        
                        var allProductsRecieved=true;
                        for(var i=0;i<pickingData.length;i++)
                        {
                            if(pickingData[i].reqQty!=pickingData[i].totalPickedQty)
                            {
                                allProductsRecieved=false;
                            }
                        }
                    
                        if(allProductsRecieved){
                            var resultsToast = $A.get("e.force:showToast");
                            resultsToast.setParams({
                                "type": "success",
                                "message": "All Products Picked Successfully. Now you can click on submit"
                            });
                            resultsToast.fire();
                           
                            component.set("v.scannedProductName",'');
                            component.set("v.IsShowAndHidAutoPick",true);
                        }
                        else{
                            var resultsToast = $A.get("e.force:showToast");
                            resultsToast.setParams({
                                "type": "success",
                                "message": "Product '"+allPickedProdName+"' checked completely. You can proceed to the next Bin"
                            });
                            resultsToast.fire();
                        }
                    }
                }
            }), 1000
        );
    },
    submit:function (component, event, helper){
        var pickingData=component.get('v.dataForPicking.PickingDuplicateDataWrap');
        var countOfLineItems=1;
        for(var i=0;i<pickingData.length;i++)
        {
            if(pickingData[i].reqQty!=pickingData[i].totalPickedQty && !pickingData[i].hasAltPick  && countOfLineItems==1)
            {
              //alert('Not all Products Picked');
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "type":"warning",
                    "title": "Warning!",
                    "message": "PICKED QTY should be equal to REQUIRED QTY"
                });
                resultsToast.fire();
                return;
            }
            else if(pickingData[i].reqQty!=pickingData[i].totalPickedQty && !pickingData[i].hasAltPick && countOfLineItems>1)
            {
                 var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "type":"warning",
                    "title": "Warning!",
                    "message": "Please Pick all the products!!PICKED QTY should be equal to REQUIRED QTY....!!"
                });
                resultsToast.fire();
                return;
            }
            countOfLineItems++;
        }
     
        helper.submitPickedDataHelper(component, event, helper);
    },
    goBackToPickingSlip:function (component, event, helper){
       // component.set('v.soID','');
              var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef : "c:SalesOrderModules",
                    componentAttributes: {
                        from : 'Picking'
                    }
                });
                evt.fire(); 
                                       $A.get('e.force:refreshView').fire();//added on 01-05-2020
    
        /*component.find("PickingNewNav").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c:PickingOrder"
                
            }
        },true);
        $A.get("e.force:refreshView").fire();*/
    },
    CancelAndNavigate:function (component, event, helper){

        var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef : "c:SalesOrderModules",
                    componentAttributes: {
                        from : 'Picking'
                    }
                });
                evt.fire(); 
                                       $A.get('e.force:refreshView').fire();//added on 01-05-2020
        //component.set('v.soID','');
        
      /*  component.find("PickingNewNav").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c:PickingOrder"
                
            }
        },true);
        $A.get("e.force:refreshView").fire();*/
    },
   
})