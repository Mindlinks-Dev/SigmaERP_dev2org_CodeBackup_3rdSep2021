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
     close : function(component, event, helper)
    {     
        component.set("v.ProductView",false);   
    },
   
   
    
    AutoSelect:function (component, event, helper){
        var pickingData=component.get('v.dataForPicking.PickingDuplicateDataWrap');
        //pickingDatav.find(element => element.reqQty!=element.totalPickedQty));
          var locBarCodeValue=component.get('v.locBarCodeValue');
        if(JSON.stringify( locBarCodeValue)==='""' | JSON.stringify( locBarCodeValue)==='undefined' )
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Warning',
                    message: 'Please Scan The Bin',
                    messageTemplate: 'Mode is sticky ,duration is 5sec and Message is overrriden because messageTemplateData is {1}',
                  /*  messageTemplateData: ['Salesforce', {
                        url: 'http://www.webkul.com/',
                        label: 'Click Here',
                    }],*/
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'warning',
                  //  mode: 'sticky'
                });
                toastEvent.fire();
                return;
            }
        
              console.log(" pickingData[i]="+JSON.stringify( pickingData[i]));
         let IsLocationFound=false;
        let IsProductFound=false;
        let  found;
        for(var i=0;i<pickingData.length;i++)
        {
             console.log(JSON.stringify( pickingData[i].binBarCode)+" locBarCodeValue="+JSON.stringify( locBarCodeValue));
           
            if(locBarCodeValue===pickingData[i].binBarCode)
            {
                IsLocationFound=true;
                if(locBarCodeValue===pickingData[i].binBarCode && pickingData[i].iaData.length>0)
                {
                     found = pickingData[i].iaData.find(element => pickingData[i].prodName===element.sigmaerpdev2__ILPLI__r.sigmaerpdev2__Product__r.Name && pickingData[i].prodCode===element.sigmaerpdev2__ILPLI__r.sigmaerpdev2__Product__r.sigmaerpdev2__Product_Bar_Code__c && pickingData[i].prodId===element.sigmaerpdev2__ILPLI__r.sigmaerpdev2__Product__c);
                    console.log(" found>>>"+JSON.stringify( found));
                    if(found.sigmaerpdev2__ILPLI__r.sigmaerpdev2__Product__r.sigmaerpdev2__Attribute_Type__c==='SERIALIZED')
                    {
                        IsProductFound=true;
                        let  reqQtyNew=pickingData[i].reqQty
                        pickingData[i].totalPickedQty= reqQtyNew;
                        console.log(" pickingData[i]="+JSON.stringify( pickingData[i]));
                        console.log(" pickingData[i].totalPickedQty="+JSON.stringify( pickingData[i].totalPickedQty));
                    }
					
                  
                }
                console.log("iaData>>>"+JSON.stringify( pickingData[i].iaData.length));
            }
          
        }
        if(IsLocationFound==false)
        {
            var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Warning',
                    message: ' Bin Not found',
                   // messageTemplate: 'Mode is sticky ,duration is 5sec and Message is overrriden because messageTemplateData is {1}',
                  /*  messageTemplateData: ['Salesforce', {
                        url: 'http://www.webkul.com/',
                        label: 'Click Here',
                    }],*/
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'warning',
                   // mode: 'sticky'
                });
                toastEvent.fire();
                return;
            
        }
        
        if(IsLocationFound==true && IsProductFound==false)
        {
            var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Warning',
                    message: 'Please Scan The Respective Product',
                   // messageTemplate: 'Mode is sticky ,duration is 5sec and Message is overrriden because messageTemplateData is {1}',
                  /*  messageTemplateData: ['Salesforce', {
                        url: 'http://www.webkul.com/',
                        label: 'Click Here',
                    }],*/
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'warning',
                   // mode: 'sticky'
                });
                toastEvent.fire();
                return;
            
        }
        
 
        
        
        console.log("pickingData"+JSON.stringify(pickingData));
        component.set('v.dataForPicking.PickingDuplicateDataWrap',pickingData);    
        let allProcutsPicked=true;
        for(var i=0;i<pickingData.length;i++)
        {
             console.log(JSON.stringify( pickingData[i].binBarCode)+" locBarCodeValue="+JSON.stringify( locBarCodeValue));
            if(pickingData[i].reqQty!=pickingData[i].totalPickedQty)
            {
                allProcutsPicked=false;
                    var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Warning',
                    message: 'Please Scan The Remaining Products.',
                   // messageTemplate: 'Mode is sticky ,duration is 5sec and Message is overrriden because messageTemplateData is {1}',
                  /*  messageTemplateData: ['Salesforce', {
                        url: 'http://www.webkul.com/',
                        label: 'Click Here',
                    }],*/
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'warning',
                   // mode: 'sticky'
                });
                toastEvent.fire();
                return;
            }
        }
        if(allProcutsPicked=true)
        {
            component.set("v.IsShowAndHidAutoPick",true);
                   var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'All Products  Are Picked. Now You can click on Submit',
                   // messageTemplate: 'Mode is sticky ,duration is 5sec and Message is overrriden because messageTemplateData is {1}',
                  /*  messageTemplateData: ['Salesforce', {
                        url: 'http://www.webkul.com/',
                        label: 'Click Here',
                    }],*/
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                   // mode: 'sticky'
                });
                toastEvent.fire();
                return;
            
            
        }
    },
    /* mouseOver: function(component, event, helper) {
        var barcode= document.getElementById("demo").value;
        // alert('barcode>>'+barcode);
         component.set('v.locBarCodeValue',barcode);
        this.afterLocScaned2(component, event, helper)
    },*/
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
                        if(pickingData[i].binBarCode==locBarCodeValue && pickingData[i].reqQty!=pickingData[i].totalPickedQty && !pickingData[i].hasAltPick)
                        {
                           // alert('inside prodScanedcode');
                            var input = component.find("prodScanedCode");
                            input.focus ();
                           //code added by bhaskar to remove  slds-hide to show bin barcode on 16-10-2019
                            var prodScanedCodeDiv = component.find("prodScanedCodeDiv");
                            $A.util.removeClass(prodScanedCodeDiv, 'slds-hide'); //ends here
                            
                            var locName=pickingData[i].zoneName?pickingData[i].zoneName:'None';
                            locName=locName+','+pickingData[i].binName;
                         //   alert(locName);
                            component.set("v.scannedLocationName",'('+locName+')');
                            //$A.util.removeClass(component.find('LocBinName'), 'slds-hide');
                            locFound=true;
                            if(pickingData[i].reqQty==pickingData[i].totalPickedQty)
                                allProdPickedInThisLoc=true;
                            //component.find("LocBinName").set('v.value','('+pickingData[i].locName+','+pickingData[i].binName+')');
                            var rowData = document.getElementById("rowData_"+i);
                          //  alert('rowData>'+rowData.length);
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
						component.set("v.IsShowAndHidAutoPick",false);
                       
                        //component.set('v.scannedLocationName','');
                       component.set("v.locationFoundFlag",true);
                    /*    window.setTimeout(
                            $A.getCallback(function() {
                              component.set("v.locationFoundFlag",false);
                            }), 10000
                        );*/
                        
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
            }),1000
        );
    },
    selectMalually: function(component, event, helper) {
        var isConfirm=confirm('Are you sure you want select Stock Manually!');
        if(isConfirm)
            helper.getILPLIDataForManSelect(component, event, helper);
    },
    doInit: function (component, event, helper) {
       // alert('soID::+++++++++++++++++++'+JSON.stringify(component.get('v.soID')));
        // alert('soName::+++++++++++++++++++++++++++'+JSON.stringify(component.get('v.soName'))); 
      //  var SigmaOrderWrap=component.get('v.SigmaOrderWrap');
        //  alert('SigmaOrderWrap::++++++++++++++++++++'+JSON.stringify(component.get('v.SigmaOrderWrap')));
      //  var originalILPLIData=component.get('v.originalILPLIData');
      //  var ilpliIdAllocatedQuantMap1=component.get('v.ilpliIdAllocatedQuantMap1');
        //  alert('originalILPLIData::++++++++++++++'+JSON.stringify(component.get('v.originalILPLIData')));
        //     alert('ilpliIdAllocatedQuantMap1::+|+++++++++++++'+JSON.stringify(component.get('v.ilpliIdAllocatedQuantMap1')));
        //window.history.forward();
        var myPageRef = component.get("v.pageReference");
        //alert("myPageRef::"+JSON.stringify(myPageRef));
        // alert("myPageRef.state"+JSON.stringify(myPageRef.state));
        if($A.get("$Browser.formFactor") !== "DESKTOP")
            component.set('v.mobileScreenFlag',true);
        
        if(component.get('v.soID')){
            //  alert("if");
            helper.getPickingDataHelper(component, event, helper,component.get('v.soID'));
        }
        else if(myPageRef.state.soID && !component.get('v.goBackClickedFlag'))
        {
            //  alert("else if");
            component.set('v.soID',myPageRef.state.soID);
            component.set('v.soName',myPageRef.state.soName);
            helper.getPickingDataHelper(component, event, helper,myPageRef.state.soID);
        }
    },
    reInit:function (component, event, helper){
        //window.history.forward();
        var myPageRef = component.get("v.pageReference");
        // alert(JSON.stringify(myPageRef));
        //alert(JSON.stringify(myPageRef.state));
        if($A.get("$Browser.formFactor") !== "DESKTOP")
            component.set('v.mobileScreenFlag',true);
        if(myPageRef.state.soID && !component.get('v.goBackClickedFlag'))
        {
            component.set('v.soID',myPageRef.state.soID);
            component.set('v.soName',myPageRef.state.soName);
            helper.getPickingDataHelper(component, event, helper,myPageRef.state.soID);
        }
        //$A.get("e.force:refreshView").fire();
    },
    handleLookupValueselected: function (component, event, helper) {
        //var input = component.find("basketScanedCode");
        //input.focus ();
        
        helper.getPickingDataHelper(component, event, helper,component.get('v.soID'));
    },
    startPicking: function (component, event, helper) {
         
        component.set('v.isPickingStarted',true);
        component.set('v.isBarcodeScanned',true);
      /*  alert('startPicking:: called');
          window.setTimeout(
            $A.getCallback(function() {
                var input = component.find("basketScanedCode");
                input.focus ();
            }), 100
        ); */
        helper.helperStartPicking(component, event, helper);
      //   alert('startPicking:: ended');
    },
    showPickedProducts:function (component, event, helper) {
        component.set('v.showHidenItems',!component.get('v.showHidenItems'));
    },
    clearAfterSORemove: function (component, event, helper) {
        let soID=component.get('v.soID');
        console.log('soID::'+JSON.stringify(soID)+!component.get('v.soID'));
        if(!component.get('v.soID'))
        {
            component.set('v.dataForPicking',null);
            //var baskatName = component.find("baskatName");
            //component.set('v.basket','');
            //component.set('v.basketBarCodeValue','');
            //console.log('baskatName::'+baskatName);
           // if(baskatName!=undefined){
            //     baskatName.set('v.value','');
            //}
           
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
    /*afterBasketScaned:function (component, event, helper){
        var basketBarCodeValue=component.get('v.basketBarCodeValue');
        if(!basketBarCodeValue || basketBarCodeValue.length <5){
            var baskatName = component.find("baskatName");
            component.set('v.basket','');
            component.get('v.dataForPicking').basket='';
            //baskatName.set('v.value','');
            //component.set('v.isBarcodeScanned',false);
            return;
        }
        helper.helperAfterBasketScaned(component, event, helper,basketBarCodeValue);
    },*/
    /* afterBasketScaned:function (component, event, helper){
        var basketBarCodeValue=component.get('v.basketBarCodeValue');
        if(!basketBarCodeValue || basketBarCodeValue.length <5){
            component.set('v.basket','');
            component.get('v.dataForPicking').basket='';
            component.set("v.basketFoundFlag",false);
            //component.set("v.scannedBasketName",'');
            return;
        }
        window.setTimeout(
            $A.getCallback(function() {
                var basketBarCodeValueInner=component.get('v.basketBarCodeValue');
                if(basketBarCodeValueInner.length==basketBarCodeValue.length)
                {
                    helper.helperAfterBasketScaned(component, event, helper,basketBarCodeValue);
                }
            }), 1000
        );
    },*/
    /*afterLocScaned:function (component, event, helper){
        var locBarCodeValue=component.get('v.locBarCodeValue');
        if(!locBarCodeValue || locBarCodeValue.length <5){
            $A.util.removeClass(component.find('LocBinName'), 'slds-hide');
            component.set("v.locName",'');
            //component.find("LocBinName").set('v.value','');
            return;
        }
        var pickingData=component.get('v.dataForPicking.PickingDuplicateDataWrap');
        var locFound=false;
        var allProdPickedInThisLoc=false;
        for(var i=0;i<pickingData.length;i++)
        {
            if(pickingData[i].binBarCode==locBarCodeValue && pickingData[i].reqQty!=pickingData[i].totalPickedQty && !pickingData[i].hasAltPick)
            {
                var input = component.find("prodScanedCode");
                input.focus ();
                var locName=pickingData[i].zoneName?pickingData[i].zoneName:'None';
                locName=locName+','+pickingData[i].binName;
                component.set("v.locName",'('+locName+')');
                $A.util.removeClass(component.find('LocBinName'), 'slds-hide');
                locFound=true;
                if(pickingData[i].reqQty==pickingData[i].totalPickedQty)
                    allProdPickedInThisLoc=true;
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
        if(!locFound)
        {
            $A.util.removeClass(component.find('LocBinName'), 'slds-hide');
            component.set("v.locName",'');
        }
        if(allProdPickedInThisLoc)
        {
            $A.util.removeClass(component.find('LocBinName'), 'slds-hide');
            component.set("v.locName",'Already');
        }
    },
    afterProdScaned:function (component, event, helper){
        var prodBarCodeValue=component.get('v.prodBarCodeValue');
        var locBarCodeValue=component.get('v.locBarCodeValue');
        if(!prodBarCodeValue || prodBarCodeValue.length <5){
            component.set("v.prodName",'');
            //component.find('ProdName').set('v.value','');
            return;
        }
        var pickingData=component.get('v.dataForPicking.PickingDuplicateDataWrap');
        var prodFound = false;
        var allProdPicked = false;
        for(var i=0;i<pickingData.length;i++)
        {
            if(pickingData[i].prodCode==prodBarCodeValue && pickingData[i].reqQty!=pickingData[i].totalPickedQty && locBarCodeValue==pickingData[i].binBarCode  && !pickingData[i].hasAltPick)
            {
                pickingData[i].totalPickedQty=pickingData[i].totalPickedQty? parseInt(pickingData[i].totalPickedQty)+1:1;
                component.set("v.prodName",pickingData[i].prodName);
                //component.find("ProdName").set('v.value',pickingData[i].prodName);
                prodFound=true;
                $A.util.removeClass(component.find('ProdName'), 'slds-hide');
                if(pickingData[i].reqQty==pickingData[i].totalPickedQty)
                    allProdPicked=true;
                break;
            }
        }
        component.set('v.dataForPicking.PickingDuplicateDataWrap',pickingData);
        window.setTimeout(
            $A.getCallback(function() {
                if(prodFound)
                {
                    component.set('v.prodBarCodeValue','');
                    $A.util.removeClass(component.find('ProdName'), 'slds-hide');
                    //component.find("ProdName").set('v.value','');
                    if(allProdPicked){
                        component.set('v.locBarCodeValue','');
                        $A.util.toggleClass(component.find('LocBinName'), 'slds-hide');
                        $A.util.toggleClass(component.find('ProdName'), 'slds-hide');
                        //component.find("LocBinName").set('v.value','');
                        var input = component.find("locScanedCode");
                        input.focus ();
                    }
                    //component.find('barcodeError').set('v.value',prodName);
                    //$A.util.removeClass(component.find('barcodeError'), 'slds-text-color_error');
                    //$A.util.addClass(component.find('barcodeError'), 'slds-text-color_success');
                }
                //toastEvent.fire();
                else{
                    component.set("v.prodName",'');
                    $A.util.removeClass(component.find('ProdName'), 'slds-hide');
                    //component.find('ProdName').set('v.value','Not Found');
                    //$A.util.removeClass(component.find('barcodeError'), 'slds-text-color_success');
                    //$A.util.addClass(component.find('barcodeError'), 'slds-text-color_error');
                }
            }), 500
        );
    },*/
    afterLocScaned:function (component, event, helper){
        component.set("v.locationFoundFlag",false);
        /*if(!component.get('v.locBarCodeValue') || component.get('v.locBarCodeValue').length <5){
            //component.set("v.scannedProductName",'');
            //$A.util.removeClass(component.find('productNameDispaly'), 'slds-hide');
            //component.find('ProdName').set('v.value','');
            return;
        }*/
        
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
                        if(pickingData[i].binBarCode==locBarCodeValue && pickingData[i].reqQty!=pickingData[i].totalPickedQty && 	!pickingData[i].hasAltPick)
                        {
                            var input = component.find("prodScanedCode");
                            input.focus ();
                            var locName=pickingData[i].zoneName?pickingData[i].zoneName:'None';
                            locName=locName+','+pickingData[i].binName;
                          //  component.set("v.scannedLocationName",'('+locName+')');
                            //$A.util.removeClass(component.find('LocBinName'), 'slds-hide');
                            locFound=true;
                            if(pickingData[i].reqQty==pickingData[i].totalPickedQty)
                                allProdPickedInThisLoc=true;
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
                    if(locFound)
                    {
                        //component.set('v.scannedLocationName','');
                        component.set("v.locationFoundFlag",true);y
                        isShowAutoPick
                    }
                    else
                    {
                        component.set("v.scannedLocationName",'Not Found');
                        component.set("v.locationFoundFlag",true);
                    }
                    /*if(allProdPickedInThisLoc)
                {
                    $A.util.removeClass(component.find('LocBinName'), 'slds-hide');
                    component.set("v.locName",'Already');
                }*/
                }
            }), 1000
        );
    },

    afterProdScaned:function (component, event, helper){
        
        // alert('afterProdScaned is called ');
        component.set("v.productFoundFlag",false);
        /*if(!component.get('v.prodBarCodeValue') || component.get('v.prodBarCodeValue').length <5){
            component.set("v.scannedProductName",'');
            A.util.removeClass(component.find('productNameDispaly'), 'slds-hide');
            component.find('ProdName').set('v.value','');
            return;
        } */
        var prodBarCodeValue=component.get('v.prodBarCodeValue');
        var locBarCodeValue=component.get('v.locBarCodeValue');
       // alert('afterProdScaned is called ::locBarCodeValue::'+JSON.stringify(locBarCodeValue));
       // alert('afterProdScaned is called ::prodBarCodeValue::'+prodBarCodeValue);
        window.setTimeout(
            $A.getCallback(function() {
                var prodBarCodeValueInner=component.get('v.prodBarCodeValue');
                var prodFound = false;
                var allProdPicked = false;
                var allPickedProdName = '';
                if(prodBarCodeValueInner.length==prodBarCodeValue.length)
                {
                    var pickingData=component.get('v.dataForPicking.PickingDuplicateDataWrap');
                   let  autopick=component.get('v.autopick');
               //      alert('afterProdScaned is called ::pickingData::'+JSON.stringify(pickingData));
                    for(var i=0;i<pickingData.length;i++)
                    {
                        // if(pickingData[i].prodCode==prodBarCodeValue && pickingData[i].reqQty!=pickingData[i].totalPickedQty && locBarCodeValue==pickingData[i].binBarCode  && !pickingData[i].hasAltPick)
                        if(pickingData[i].prodCode==prodBarCodeValue && pickingData[i].reqQty!=pickingData[i].totalPickedQty && locBarCodeValue==pickingData[i].binBarCode  && !pickingData[i].hasAltPick)
                        {
                            let found = pickingData[i].iaData.find(element => pickingData[i].prodName===element.sigmaerpdev2__ILPLI__r.sigmaerpdev2__Product__r.Name && pickingData[i].prodCode===element.sigmaerpdev2__ILPLI__r.sigmaerpdev2__Product__r.sigmaerpdev2__Product_Bar_Code__c && pickingData[i].prodId===element.sigmaerpdev2__ILPLI__r.sigmaerpdev2__Product__c);
						console.log(" found>>>"+JSON.stringify( found));
						if(found.sigmaerpdev2__ILPLI__r.sigmaerpdev2__Product__r.sigmaerpdev2__Attribute_Type__c==='SERIALIZED')
                        {
                             //let yes=;
                            if(autopick)
							{
								pickingData[i].totalPickedQty=pickingData[i].totalPickedQty? parseInt(pickingData[i].totalPickedQty)+1:1;
								component.set("v.scannedProductName",pickingData[i].prodName);
								prodFound=true;
								//$A.util.removeClass(component.find('ProdName'), 'slds-hide');
								if(pickingData[i].reqQty==pickingData[i].totalPickedQty){
								allProdPicked=true;
								allPickedProdName=pickingData[i].prodName;
								}
							}else{
								pickingData[i].totalPickedQty=pickingData[i].totalPickedQty? parseInt(pickingData[i].totalPickedQty)+1:1;
								component.set("v.scannedProductName",pickingData[i].prodName);
								prodFound=true;
								//$A.util.removeClass(component.find('ProdName'), 'slds-hide');
								if(pickingData[i].reqQty==pickingData[i].totalPickedQty){
								allProdPicked=true;
								allPickedProdName=pickingData[i].prodName;
								}
								break;
							}
                        }
                          else
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
                              break;
                              
                          }
                            
                        }
                    }
                    
                    component.set('v.dataForPicking.PickingDuplicateDataWrap',pickingData);
                     //alert('PickingDuplicateDataWrap:'+component.get('v.dataForPicking.PickingDuplicateDataWrap'));
                   //   alert('afterProdScaned is called ::allProdPicked::'+allProdPicked);
                   if(JSON.stringify(locBarCodeValue)=='""')
                    {
                        component.set("v.scannedLocationName",'please scan first bin barcode');
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
                            //alert('if(prodFound)');
                        component.set('v.prodBarCodeValue','');
                        component.set("v.productFoundFlag",true);
                        // alert('if(allProdPicked)'+allProdPicked);
                        if(allProdPicked){
                            
                            component.set('v.locBarCodeValue','');
                          //  component.set('v.scannedLocationName','');
                            //  //component.find("LocBinName").set('v.value','');
                            var input = component.find("locScanedCode"); 
                             input.focus ();
                           // component.set("v.scannedProductName",'');
                        }
                        window.setTimeout(
                            $A.getCallback(function() {
                                component.set("v.locationFoundFlag",false);
                            }), 3000
                        );
                    } else
                    {
                        component.set("v.scannedProductName",'Not Found');
                        component.set("v.productFoundFlag",true);
                        window.setTimeout(
                            $A.getCallback(function() {
                                if(!component.get('v.prodBarCodeValue'))
                                    component.set("v.productFoundFlag",false);
                            }), 3000
                        );
                    }
                                      
                    //alert('afterProdScaned is called ::allProdPicked::'+allProdPicked);
                    if(allProdPicked){
                        
                        var allProductsRecieved=true;
                        for(var i=0;i<pickingData.length;i++)
                        {
                            if(pickingData[i].reqQty!=pickingData[i].totalPickedQty)
                            {
                                allProductsRecieved=false;
                            }
                        }
                        //   alert('allProductsRecieved::'+allProductsRecieved);
                        if(allProductsRecieved){
                            var resultsToast = $A.get("e.force:showToast");
                            resultsToast.setParams({
                                "type": "success",
                                "message": "All Products Picked Successfully. Now you can click on submit"
                            });
                            resultsToast.fire();
                             component.find("locScanedCode").blur();
                            component.set("v.IsShowAndHidAutoPick",true);
                           // component.set("v.scannedProductName",'');
                        }
                        else{
                            // component.set("v.locationFoundFlag",false);
                            // component.set('v.scannedLocationName','');
                          //    var prodScanedCodeDiv = component.find("prodScanedCodeDiv");
                          //  $A.util.removeClass(prodScanedCodeDiv, ''); //ends here
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
            if(pickingData[i].reqQty!=pickingData[i].totalPickedQty && !pickingData[i].hasAltPick && countOfLineItems==1)
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
        //  if(!component.get('v.dataForPicking').basket)
        //  {
        //      alert('No Basket Found');
        //      return;
        //  }
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
                evt.fire();  //component.set('v.soID','');
      	 $A.get('e.force:refreshView').fire();
     /*
        component.find("PickingNewNav").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c:Picking"
                
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
                evt.fire();  //component.set('v.soID','');
      	 $A.get('e.force:refreshView').fire();
        /*comment by harish  
        component.find("PickingNewNav").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c:Picking"
                
            }
        },true);
        $A.get("e.force:refreshView").fire(); */
    },
    
})