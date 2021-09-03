({
    addStorageLoc: function (component, event, helper) {        
        if (component.get("v.SMData.ListOfILs") == null) {
            var wrap = [{
                'invLocRecID': '',
                'BinId' : '',
                'MovedQty': 0,
                'Name': '',
                'BinName':'',
                'locName':'',
                'locId':'',
                'ZoneId':'',
                'ZoneName':''
            }];
            component.set("v.SMData.ListOfILs", wrap);
        } else {
            var wrap = {
                'invLocRecID': '',
                'BinId' : '',
                'MovedQty': 0,
                'Name': '',
                'BinName':'',
                'locName':'',
                'locId':'',
                'ZoneId':'',
                'ZoneName':''
            };
            var temp = component.get("v.SMData.ListOfILs");
            temp.push(wrap);
            
            component.set("v.SMData.ListOfILs", temp);
        }
    },    
    handleRemove: function (component, event, helper) {
        var index = event.currentTarget.dataset.index;
        var v = component.get("v.SMData.ListOfILs");
        v.splice(index,1);
        component.set("v.SMData.ListOfILs",v);      
    },    
    saveStock: function (component, event, helper) {
               
        //var prodAttributeType1 = component.get("v.prodAttributeType"); 
                        
        var tempData = component.get("v.SMData.ListOfILs");
        //var qcPassedQuantity = component.get("v.manfObj.sigmaerpdev2__QC_Passed_Qty__c");
        var qcPassedQuantity = component.get("v.passedQty");                   
        if(qcPassedQuantity == '' || qcPassedQuantity == undefined){           
           var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Passed quantity is mandatory.Enter Passed quantity."
            });
            toastEvent.fire();            
            return; 
        }
        
        var count = 0;        
        if(component.get("v.manfObj.sigmaerpdev2__Produced_Quantity__c") == null || component.get("v.manfObj.sigmaerpdev2__Produced_Quantity__c") == undefined || component.get("v.manfObj.sigmaerpdev2__Produced_Quantity__c") <= 0) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Produced quantity is mandatory and should be greater than 0."
            });
            toastEvent.fire();
            return;
        } 
        //added newly on 27/12/2019
        if(component.get("v.manfObj.sigmaerpdev2__Produced_Quantity__c") != qcPassedQuantity){            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Produced quantity must be equal to QC Passed Qty."
            });
            toastEvent.fire();
            return;
        }     
        //ends here
        
        
        if(component.get("v.SMData.manfObject.sigmaerpdev2__Batch_Number__c")=='' || component.get("v.SMData.manfObject.sigmaerpdev2__Batch_Number__c") == null || component.get("v.SMData.manfObject.sigmaerpdev2__Batch_Number__c") == undefined){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Batch number is mandatory.Enter the batch number."
            });
            toastEvent.fire();
            return;
        }
        if(component.get("v.SMData.manfObject.sigmaerpdev2__Expiry_date_of_Batch__c") == '' || component.get("v.SMData.manfObject.sigmaerpdev2__Expiry_date_of_Batch__c") == null || component.get("v.SMData.manfObject.sigmaerpdev2__Expiry_date_of_Batch__c") == undefined) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Expiry date of batch is mandatory.Enter the expiry date of batch."
            });
            toastEvent.fire();
            return;
        }
        if(new Date(component.get("v.SMData.manfObject.sigmaerpdev2__Expiry_date_of_Batch__c"))<=new Date()) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Expiry date of batch should be a future date."
            });
            toastEvent.fire();
            return;
        }
        
        var prodAttrType = component.get("v.prodAttributeType");
        var serData = component.get("v.SMData.serialNumberLst");  
        if(prodAttrType == 'SERIALIZED'){            
            if(serData == null || serData == undefined || serData == ''){                
            	var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": "Add Serial number for the serialized product."
                });
                toastEvent.fire();
                return;    
            }            
        }
        
        for (var i = 0; i < tempData.length; i++) {       
            if(tempData[i].invLocRecID == ''){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": "Storage location is mandatory at row "+(i+1)
                });
                toastEvent.fire();
                return;
            }    
            //added newly for Bin mandatory validation on 11/9/2019            
            if(tempData[i].BinId == '' || tempData[i].BinId == undefined){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": "Bin is mandatory at row "+(i+1)
                });
                toastEvent.fire();
                return;
            } 
            //ends here
            if (tempData[i].MovedQty == 0 || tempData[i].MovedQty == '' || tempData[i].MovedQty == undefined || tempData[i].MovedQty == null) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": "Moving quantity should be greater than 0 at row "+(i+1)
                });
                toastEvent.fire();
                return;
            }            
            count += tempData[i].MovedQty;	
            
            for (var j = i + 1; j < tempData.length; j++) {
                if (tempData[i].invLocRecID == tempData[j].invLocRecID && tempData[i].BinId == tempData[j].BinId) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "title": "Error!",
                        "message": "Duplicate storage location and bin found at rows "+(i+1)+" and "+(j+1)+". Duplicate storage location and bin are not allowed"
                    });
                    toastEvent.fire();
                    return;
                }
            }
        }        
        count = parseFloat(count).toFixed(2);        
        if(count != component.get("v.manfObj.sigmaerpdev2__Produced_Quantity__c")) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Moving quantity should be equal to produced quantity."
            });
            toastEvent.fire();
            return;
        }
        
       
        
        var spinner = component.find("manProdSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        var AllData = component.get("v.SMData");
        var producedQty = component.get("v.manfObj.sigmaerpdev2__Produced_Quantity__c");
        var mfrun = component.get("v.manfObj");
        var UnitPrice = component.get("v.UnitPrice");
        var TotalPrice = component.get("v.TotalCost");
        
        //added newly on 13/4/2020 to handle wastage charges and save in MR object
        var sysWastage = component.get("v.sysWastg");
        var userAddedWast = component.get("v.usrWastg");
        var checkCmp3 = component.find("checkbox3");
        var chkBoxVal3 = checkCmp3.get("v.value");        
        //ends here
        
                        
        var action = component.get("c.StockEntrySave");
        action.setParams({
            "ILData": JSON.stringify(AllData),
            "producedQty": producedQty,
            "MfRun": mfrun,
            "UnitPrice": UnitPrice,
            "TotalCost" : TotalPrice,
            
            "passQty" : component.get("v.passedQty"),
            "failQty" : component.get("v.failedQty"),
            "qcDesc" : component.get("v.qcComments"),
            "barCodeValue" : component.get("v.barCodeVal"),
            "prodAttributeTypeNew" : component.get("v.prodAttributeType"),
            "systemCalc" : sysWastage,
            "userAdded": userAddedWast,
            "addWastage" : chkBoxVal3            
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();            
           
            if (state === "SUCCESS") {
                var errors = action.getError();
                $A.get('e.force:refreshView').fire();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "Produced goods have been moved successfully to the selected Location(s)."
                });
                toastEvent.fire();
                 if (response.getReturnValue() ==true) {
                    //var errors = action1.getError();
                    $A.get('e.force:refreshView').fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "success",
                        "title": "Success!",
                        "message": "Back order items related to this product can now be fulfilled." 
                    });
                    toastEvent.fire();
                }
            }			
			else{
                var errors = action.getError();
                if(errors && errors[0].message){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "title": "Error!",
                        "message": JSON.stringify(errors[0].message)
                    });
                    toastEvent.fire();
                }else if(errors && errors[0].pageErrors[0].message){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "title": "Error!",
                        "message": JSON.stringify(errors[0].pageErrors[0].message)
                    });
                    toastEvent.fire();
                }
            }
            
            var spinner = component.find("manProdSpinner");
            $A.util.toggleClass(spinner, "slds-hide");
        });		
        $A.enqueueAction(action);
		
    },    
    calculateUnitPrice: function (component, event, helper)
    {
        if(component.get("v.manfObj.sigmaerpdev2__PI_updated__c") == false)
        {
            if(component.get("v.manfObj.sigmaerpdev2__Produced_Quantity__c") == null || component.get("v.manfObj.sigmaerpdev2__Produced_Quantity__c") == 0){
                component.set("v.UnitPrice",0);
            }else if(component.get("v.manfObj.sigmaerpdev2__Produced_Quantity__c") > 0){
                var calc=component.get("v.TotalCost")/component.get("v.manfObj.sigmaerpdev2__Produced_Quantity__c");
                component.set("v.UnitPrice",calc.toFixed(2));
            }else if(component.get("v.manfObj.sigmaerpdev2__Produced_Quantity__c") < 0){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "Error",
                    "title": "Success!",
                    "message": "Produced quantity should be greater than 0."
                });
                toastEvent.fire();
                component.set("v.manfObj.sigmaerpdev2__Produced_Quantity__c", 0);
            }
        }
    },    
    getSMData: function (component, event, helper) {
        var spinner = component.find("manProdSpinner");       
        $A.util.toggleClass(spinner, "slds-hide");
        
        if(component.get("v.manfObj.Id") == '') {            
            var data = {
                'ListOfILs': [{
                    'invLocRecID': '',
                    'BinId' : '',
                    'MovedQty': 0,
                    'Name': '',
                    'BinName':'',
                    'locName':'',
                    'locId':'',
                    'ZoneId':'',
                    'ZoneName':''
                }],
                'ILsRec': [],
                'ILPsRec': [],
                'ILPLIsRec': []
            }
            component.set("v.SMData", data);
			var spinner = component.find("manProdSpinner");
        	$A.util.toggleClass(spinner, "slds-hide");            
        }else {
            var action = component.get("c.getStockMovementData");
            action.setParams({
                "mrID": component.get("v.manfObj.Id")
            });
            
            action.setCallback(this, function (response) {
                var state = response.getState();                
                if (state == "SUCCESS") {
                    component.set("v.prodAttributeType", response.getReturnValue().prodAttrType);                    
                    component.set("v.SMData",response.getReturnValue()); 
                    console.log('result=='+JSON.stringify(response.getReturnValue()));
                    var uprice = component.get("v.SMData.manfObject.sigmaerpdev2__Unit_Price__c");
                    var uprc = Number(uprice).toFixed(2);
                    var dat = component.get("v.SMData.manfObject.sigmaerpdev2__Produced_Quantity__c");
                    var totCost = component.get("v.SMData.manfObject.sigmaerpdev2__Total_Cost__c");
                    component.set("v.manfObj.sigmaerpdev2__Produced_Quantity__c",dat);
                    
                    component.set("v.origProdQty", dat);
                    var isQcPassed = component.get("v.SMData.manfObject.sigmaerpdev2__QC_Passed__c");                                        
                    if(isQcPassed)                    
                    	component.set("v.manfObj.sigmaerpdev2__QC_Passed__c", true); 
                    else
                        component.set("v.manfObj.sigmaerpdev2__QC_Passed__c", false);
                    
                   /* var qcPassedQty = component.get("v.SMData.manfObject.sigmaerpdev2__QC_Passed_Qty__c");                                        
                    if(qcPassedQty != null)                    
                    	component.set("v.manfObj.sigmaerpdev2__QC_Passed_Qty__c", qcPassedQty); 
                    else
                        component.set("v.manfObj.sigmaerpdev2__QC_Passed_Qty__c", '');*/                    
                    
                    component.set("v.UnitPrice",uprc);
                    
                    component.set("v.TotalCost", totCost);
                    //alert('wastageChrgs from def param==='+response.getReturnValue().wastageChrgs);
                    component.set("v.sysWastg", response.getReturnValue().wastageChrgs);
                    
                    component.set("v.dataobjNewDefLoc", response.getReturnValue().acctObj.Name);
                    
                    //code to be moved back
                    component.set("v.dataobjNewDmgdLoc", response.getReturnValue().defDamagedLocObj.Name);
                    //ends here
                    
                    
                    //added newly on 26/3/2020 to add bar code only if its not there already for the product
                    var prodBC = component.get("v.SMData.manfObject.sigmaerpdev2__Product__r.sigmaerpdev2__Product_Bar_Code__c");                    
                    if(prodBC == '' || prodBC == undefined)
                       component.set("v.isBarCodeAlreadyThere", false); 
                    else
                       component.set("v.isBarCodeAlreadyThere", true);
                    //ends here
                    
                    if (component.get("v.SMData.ListOfILs").length == 0) {
                        var wrap = [{
                            'invLocRecID': '',
                            'MovedQty': 0,
                            'Name': ''
                        }];
                        component.set("v.SMData.ListOfILs", wrap);
                    }
                    var spinner = component.find("manProdSpinner");
        			$A.util.toggleClass(spinner, "slds-hide");
                }
                else {
                    var error = response.getError();
                    console.log('Error: ' + JSON.stringify(error));
                    var spinner = component.find("manProdSpinner");
        			$A.util.toggleClass(spinner, "slds-hide");
                }
            });            
            $A.enqueueAction(action);
        }        
       
    },
    showSerialNumber : function(component, event, helper){        
        var serLn = component.get("v.SMData.serialNumberLst.length");
        if(serLn > 0){
        	var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"Error",
                "title": "Error!",
                "message": "Serial Number(s) are already added."
            });
            toastEvent.fire();
            return;	    
        }else{
        	component.set("v.showManSerNumEntryFlg", false);
        	component.set("v.showAutoSerNumEntryFlg", false);
        	component.set("v.enableSaveForUplAndMan", false);
        	helper.openModalHelper(component, event, helper);    
        }
    },
    
    closeModal : function(component, event, helper){
        component.set("v.showManSerNumEntryFlg", false);
        component.set("v.showAutoSerNumEntryFlg", false);
        component.set("v.openModal", false);
    },
    clearNumbers : function(component, event, helper){
        var index = event.target.dataset.index;
		var length = component.get("v.manfObj.sigmaerpdev2__Produced_Quantity__c");                    
        var serialList = [];        
		serialList =  component.get("v.serials");        
        for(var i=0;i<length;i++){
            if(i == index)
                serialList[i].SerialNo = '';                      	                      
        }
       	component.set('v.serials',serialList); 
    },
    showManualEntry : function(component, event, helper){
        component.set("v.showManSerNumEntryFlg", true);
        component.set("v.enableSaveForUplAndMan", true); 
        component.set("v.showAutoSerNumEntryFlg", false);
    },    
    addSerialNumber : function(component, event, helper){         
        var fileInput = component.find("file").get("v.files");        
        if(fileInput == null){			            
            //manual entry flow
            var srlNo = component.get('v.serials');
            var myArray = [];
            for(var i = 0; i < srlNo.length; i++){
                myArray.push(JSON.stringify(srlNo[i].SerialNo));
            }
            for(var i=0;i<srlNo.length;i++){
                if(srlNo[i].SerialNo.trim() == ''){                
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"Error",
                        "title": "Error!",
                        "message": "Serial Number is empty @ row : "+(i+1)
                    });
                    toastEvent.fire();
                    return;
                }
            }
            var flag = false;
            for(var i = 0; i < myArray.length; i++){
                for(var j = 0; j < myArray.length; j++){
                    if(i != j){                    
                        if (myArray[i] == myArray[j]){
                            flag = true;                        
                        }
                    }
                }
            }
            if(flag){            
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"Error",
                    "title": "Error!",
                    "message": "Duplicate serial number found."
                });
                toastEvent.fire();
                return;
            }
            //console.log('ripe====='+JSON.stringify(component.get('v.serials')));
            var finArr = [];
            var finalres = component.get('v.serials');
            for(var i=0;i<finalres.length;i++){                
                finArr.push(finalres[i].SerialNo);
            }
            component.set("v.SMData.serialNumberLst", finArr); 
            
            //added newly on 9/5/2020 to disable produced qty after serial number is generated
            component.set("v.disableAfterSerNum", true);
            //ends here
            
            //console.log('serNumLsr==='+JSON.stringify(component.get("v.SMData.serialNumberLst")));
        }else{
            //upload csv file flow            
            try{
                //var filename = event.getSource().get("v.files");         
            	var filename = component.find("file").get("v.files");  
                var textdata;
                var reader = new FileReader();
                var infolst = [];
                if(filename[0] != undefined && filename[0] != null && filename[0] != '') {                 
                    reader.readAsText(filename[0]);
                }
                reader.onload = function(){             
                    var text = reader.result;               
                    textdata = text;
                    var rows = textdata.split('\n'); 
                    var myArray = rows[0].split(',');                         
                    var srchString;
                    var selRow;
                    for(var i=0;i<myArray.length;i++){
                        srchString = myArray[i].toLowerCase();               
                        var iVal = srchString.indexOf("serial");               
                        if(iVal == 0){
                            selRow = i;                    
                            break;
                        }                   
                    }                
                    var finalSerList = [];
                    for(var i=1;i<rows.length;i++){
                       var cells = rows[i].split(',');               
                        if(cells[selRow] != '' || cells[selRow] != undefined){                           
                       		finalSerList.push(cells[selRow]);
                        }
                    }                     
                    finalSerList.pop();                     
                    for(var i=0;i<finalSerList.length;i++){                    	
                        if(finalSerList[i] != undefined){
                        	finalSerList[i] = finalSerList[i].replace(/(\r\n|\n|\r)/gm,"");
                            finalSerList[i] = finalSerList[i].replace (/("\"")/gm,"");
                        }                     		
                    }  
                    //added newly on 12/4/2020 to validate if csv file contains duplicate serial code or not
                    var flagCSV = false;
                    var valuesSoFar = [];
                    for(var i=0;i<finalSerList.length;i++){
                        var value1 = finalSerList[i];
                        if(valuesSoFar.indexOf(value1) !== -1) {
                            flagCSV = true;
							break;                            
                        }else{
                            valuesSoFar.push(value1);
                        }
                    }
                    if(flagCSV){            
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"Error",
                            "title": "Error!",
                            "message": "Duplicate serial numbers found in csv file.Remove duplicates and try again."
                        });
                        toastEvent.fire();
                        return;
                    }
                    //ends here 
                  
                    //added newly on 12/4/2020 to validate if csv file serial code count doesn't match with produced qnty                                      
                    var prodFinCount = component.get("v.manfObj.sigmaerpdev2__Produced_Quantity__c");
                    if(prodFinCount != finalSerList.length){            
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"Error",
                            "title": "Error!",
                            "message": "Serial codes count doesn't match Produced Quantity count.Upload failed."
                        });
                        toastEvent.fire();
                        return;
                    }
                    //ends here
                                     
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"Success",
                        "title": "Success!",
                        "message": "CSV file for Serial Numbers has been uploaded successfully."
                    });
                    toastEvent.fire();
                    //console.log('ser stringify==='+JSON.stringify(finalSerList));
                    //component.set("v.SMData.SerNumWrap", finalSerList);
                    
                    
                    //added newly on 9/5/2020 to disable produced qty after serial number is generated
                    component.set("v.disableAfterSerNum", true);
                    //ends here
                     
                    console.log("f12=="+JSON.stringify(component.get("v.SMData")));
                    component.set('v.serials', finalSerList);
                    component.set("v.SMData.serialNumberLst", component.get("v.serials"));
                    console.log('final------'+JSON.stringify(component.get("v.SMData"))); 
                    //console.log('res123======'+component.get("v.SMData.SerNumWrap"));                       
                }
            }catch(err){            	
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"Error",
                    "title": "Error!",
                    "message": "Found error - "+err+" while uploading CSV file.Please try again."
                });
                toastEvent.fire();
            }
        }        
        component.set('v.openModal',false);
    },
    uploadFile : function(component, event, helper){         
        component.set("v.showManSerNumEntryFlg", false);
        component.set("v.enableSaveForUplAndMan", true); 
        component.set("v.showAutoSerNumEntryFlg", false);        
    },    
    showAutoSerialize : function(component, event, helper){        
        component.set("v.showAutoSerNumEntryFlg", true);
        component.set("v.showManSerNumEntryFlg", false);
        component.set("v.enableSaveForUplAndMan", false);         
    },
    autoSerialize : function(component, event, helper){                             
        var selectedProdName = component.get("v.autoSerialName");        
        if(selectedProdName == undefined || selectedProdName == ''){
            var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"Error",
                    "title": "Error!",
                    "message": "Enter Serial number format."
                });
                toastEvent.fire();
                return;
        }else{
            var pName;
            if(selectedProdName.length >= 3)
                pName = component.get("v.autoSerialName").substring(0,3);
            else
                pName = component.get("v.autoSerialName").substring(0, selectedProdName.length);
            var serialList = component.get("v.serials");        
           
            var timezone = $A.get("$Locale.timezone");        
            var d = new Date().toLocaleString("en-US", {timeZone: timezone})        
            for(var i=0;i<serialList.length;i++)
            {
                if(!serialList[i].sigmaerpdev2__Serial_No__c)
                    serialList[i].sigmaerpdev2__Serial_No__c = pName+'-'+d[12]+d[13]+d[15]+d[16]+d[18]+d[19]+'-SER-'+d[6]+d[7]+d[8]+d[9]+d[0]+d[1]+'-'+i;           
            }               
            console.log('serialList==='+JSON.stringify(serialList));
            var finArr = [];
            var finalres = serialList;
            for(var i=0;i<finalres.length;i++){
                //alert('mod==='+finalres[i].sigmaerpdev2__Serial_No__c);
                finArr.push(finalres[i].sigmaerpdev2__Serial_No__c);
            }
            component.set("v.SMData.serialNumberLst", finArr); 
            
            
            //added newly on 9/5/2020 to disable produced qty after serial number is generated
            component.set("v.disableAfterSerNum", true);
            //ends here
            
            console.log('441==='+JSON.stringify(component.get("v.SMData.serialNumberLst")));
            //component.set("v.SMData.serialNumberLst", serialList);
            component.set('v.openModal',false);
        }                 
    },

    updateFailedQty : function(component, event, helper){
        var prodQty = component.get("v.manfObj.sigmaerpdev2__Produced_Quantity__c");
        var passQty = component.get("v.passedQty");        
        if(passQty == '' || passQty == undefined){           
            if(passQty == 0){
            	component.set("v.failedQty", (prodQty - passQty));       
            }else{
           		component.set("v.failedQty", "");     
            }           
        }else{            
        	component.set("v.failedQty", (prodQty - passQty));     
        }       		
    },

    addWastage : function(component, event, helper){
       /* if(component.get("v.totWastg") == 0){
        	component.set("v.TotalCost",  (parseFloat(component.get("v.TotalCost")) + parseFloat(component.get("v.sysWastg"))).toFixed(4));        
        	component.set("v.totWastg", parseFloat(component.get("v.sysWastg")));    
        } */
        component.set("v.showWastg", true);        
        component.set("v.showWastageBlk", false);
    },
    hideWastage : function(component, event, helper){
        component.set("v.showWastageBlk", true);
        component.set("v.showWastg", false);
    },
    
    /*addUsrWastage : function(component, event, helper){ 
        var newVal =  event.getSource().get("v.value");
        if(newVal == null)
            component.set("v.usrWastg", 0);
        var oldVal = component.get("v.usrWastgInterimVal");
        
        component.set("v.totWastg", (component.get("v.sysWastg") + newVal));
        if(newVal != oldVal){
            if(newVal == 0){
                component.set("v.TotalCost", component.get("v.sysWastg"));
            }else if(newVal > oldVal){
                component.set("v.TotalCost", component.get("v.sysWastg"));
            }
        }
        
        
        var totalProductionCost = component.get("v.TotalCost");
        totalProductionCost = parseFloat(totalProductionCost) + (parseFloat(component.get("v.totWastg")) - parseFloat(component.get("v.sysWastg")));
        component.set("v.TotalCost", totalProductionCost.toFixed(4));
    },*/
    
    strUserWstg : function(component, event, helper){        
        component.set("v.usrWastgInterimVal", component.get("v.usrWastg"));              
    },
    
    addWastagetoTotal : function(component, event, helper){
        var checkCmp = component.find("checkbox3");
        var chkBoxVal = checkCmp.get("v.value"); 
        var userVal = component.get("v.usrWastg");
        if(chkBoxVal){            
           component.set("v.showWastg", true); 
           if(userVal != null && userVal != 0){
           		component.set("v.totWastg", component.get("v.sysWastg") + component.get("v.usrWastg"));     
           }else{
               component.set("v.totWastg", component.get("v.sysWastg") + 0);
           }
           component.set("v.TotalCost", (parseFloat(component.get("v.TotalCost")) + parseFloat(component.get("v.totWastg"))).toFixed(4));
        }else{            
           component.set("v.showWastg", false);
           if(userVal != null && userVal != 0){
               var subtotal = parseFloat(component.get("v.sysWastg")) + parseFloat(component.get("v.usrWastg"));
           	   component.set("v.totWastg", (parseFloat(component.get("v.totWastg")) - subtotal));
               component.set("v.TotalCost", (parseFloat(component.get("v.TotalCost")) - parseFloat(subtotal)).toFixed(4));
           }else{
          	   component.set("v.totWastg", 0);
               component.set("v.TotalCost", (parseFloat(component.get("v.TotalCost")) - parseFloat(component.get("v.sysWastg"))).toFixed(4));
           }
        }        
    },
    
    addUsrWastage : function(component, event, helper){
        var newVal =  event.getSource().get("v.value");
        var oldVal = component.get("v.usrWastgInterimVal");		
        if(newVal >= 0){            
            if(oldVal == 0 || oldVal == undefined){                
            	component.set("v.totWastg", component.get("v.totWastg") + parseFloat(newVal));
                component.set("v.TotalCost", (parseFloat(component.get("v.TotalCost")) + newVal).toFixed(4));
            }else{
                var newUpdtVal;
                if(oldVal > newVal){
                	newUpdtVal = oldVal - newVal;                   
                    component.set("v.totWastg", parseFloat(component.get("v.totWastg")) - parseFloat(newUpdtVal));
                    component.set("v.TotalCost", (parseFloat(component.get("v.TotalCost")) - newUpdtVal).toFixed(4));
                }else if(newVal > oldVal){
                    newUpdtVal = newVal - oldVal;                   
                    component.set("v.totWastg", parseFloat(component.get("v.totWastg")) + parseFloat(newUpdtVal));
                    component.set("v.TotalCost", (parseFloat(component.get("v.TotalCost")) + newUpdtVal).toFixed(4));
                }
            }
        }
    },
    
    onCheckQCFail : function(component, event, helper){
        var failQty = component.get("v.failedQty");
        var checkCmp = component.find("checkbox2");
        var chkBoxVal = checkCmp.get("v.value");
        var checkCmp3 = component.find("checkbox3");
        var chkBoxVal3 = checkCmp3.get("v.value");
        var finalCost = component.get("v.SMData.manfObject.sigmaerpdev2__Total_Cost__c").toFixed(4);
        var finalCostBfChanges = component.get("v.TotalCost");
        
        if(failQty > 0){
            if(chkBoxVal){                
                component.set("v.TotalCost", finalCost);               
                var totWstg = component.get("v.totWastg");
                if(chkBoxVal3){
                    if(totWstg > 0){
                        component.set("v.TotalCost", (parseFloat(component.get("v.TotalCost")) + parseFloat(totWstg)).toFixed(4));
                    }
                }     
                var calc = (component.get("v.TotalCost") / component.get("v.manfObj.sigmaerpdev2__Produced_Quantity__c"));
                component.set("v.UnitPrice",calc.toFixed(2));
            }else{                  
                var totWstg = component.get("v.totWastg");
                var flg = false;
                if(chkBoxVal3){
                    if(totWstg > 0){
                        flg = true;                        
                    }
                }
                
                var initTotCost;
                if(flg){
                   initTotCost =  finalCostBfChanges - parseFloat(totWstg); 
                }else{
                    initTotCost = finalCostBfChanges;     
                }					       
                
                var fullProdQty = component.get("v.manfObj.sigmaerpdev2__Produced_Quantity__c");               
                var indvCost = initTotCost / fullProdQty;
                var costToReduce = failQty * indvCost;
                component.set("v.TotalCost", (finalCostBfChanges - costToReduce).toFixed(4));s                
                var calc = (component.get("v.TotalCost") / component.get("v.passedQty"));
                component.set("v.UnitPrice", calc.toFixed(2));                
            }            
        }
    },
    
    /*copyPassedQtyToProdQn : function(component, event, helper){
        component.set("v.manfObj.sigmaerpdev2__Produced_Quantity__c", component.get("v.passedQty"));
    }*/
    
    //code to be moved back
    checkBCAvailability : function(component, event, helper){
        helper.checkBCAvailabilityH(component, event, helper);
    },
    
    //code to be moved back
    valtabchanged : function(component, event, helper){        
        var tabVal = component.get("v.detTabClk1");
        var chkBoxVal;
        var checkCmp = component.find("checkbox3");
        var piUpdated = component.get("v.manfObj.sigmaerpdev2__PI_updated__c");        
        if(checkCmp != undefined){
            chkBoxVal = checkCmp.get("v.value");
            if(tabVal == false && chkBoxVal == true && piUpdated == false){
                checkCmp.set("v.value", false);
            }
        }
    }
})