({
    doInit : function(component, event, helper) {		       
        helper.getStockList(component);
    },
	locChange: function(component, event, helper) {
        var recID= component.get("v.recID");
      // alert('recID locChange>>>'+JSON.stringify(recID));
         if(JSON.stringify(recID)==='""')
         {
              component.set("v.StockCheckDetails",[]);
             component.set("v.isError",false);
        component.set("v.errorMsg",null);
               component.set('v.StockCheckDetails','');
             document.getElementById("Accspinner").style.display = "block";
             window.setTimeout(function(){ document.getElementById("Accspinner").style.display = "none"; }, 5000);
            
			helper.getStockList(component);
         }
    },
	searchILP : function(component, event, helper) {
         component.set("v.isError",false);
        component.set("v.errorMsg",null);
		let recID=component.get("v.recID");
			console.log('recID'+JSON.stringify(recID));
			//alert(recID);
        
		if(JSON.stringify(recID)!='undefined' && recID!=undefined && JSON.stringify(recID)!='""')
		{
            document.getElementById("Accspinner").style.display = "block";
             window.setTimeout(function(){ document.getElementById("Accspinner").style.display = "none";; }, 5000);
           
				helper.fetchIlpListBasedOnLocationName(component, event, helper,recID);
		}
		else{
            component.set('v.StockCheckDetails','');
             document.getElementById("Accspinner").style.display = "block";
             window.setTimeout(function(){ document.getElementById("Accspinner").style.display = "none";; }, 5000);
            
			helper.getStockList(component);
		}
		 
		
    },
    SaveStockCheckkkk:function(component, event, helper){      
        var today = new Date();
        component.set('v.today', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        var todaydate = new Date( component.get('v.today'));
        
        var someDate = new Date(component.get("v.StockCheck.sigmaerpdev2__Stock_Check_Date__c"));
        component.set('v.Orderdate', someDate.getFullYear()+ "-" +(someDate.getMonth() + 1)+ "-" + someDate.getDate() );
        
        var orderdate = new Date(component.get("v.Orderdate"));
        
        var myOutput2 = component.find("custValidationss");
        if(component.get("v.StockCheck.sigmaerpdev2__Stock_Check_Date__c") === null ||component.get("v.StockCheck.sigmaerpdev2__Stock_Check_Date__c") === '' || component.get("v.StockCheck.sigmaerpdev2__Stock_Check_Date__c") ===undefined)
        {
            $A.util.addClass(myOutput1 , "textClass");
            myOutput2.set("v.value", "Select Stock Check Date");
			window.scrollTo(0, 0);            
            return;
        }else{
            myOutput2.set("v.value", " ");
        }
        
        if(orderdate > todaydate){
            $A.util.addClass(myOutput1 , "textClass");
            myOutput2.set("v.value", "Date value must be lesser than or equal to Today's date.");           
            return;
        }        
        
        var myOutput1 = component.find("custValidation");
        if(component.get("v.StockCheck.sigmaerpdev2__Stock_Check_User_Name__c") === null ||component.get("v.StockCheck.sigmaerpdev2__Stock_Check_User_Name__c") === '' || component.get("v.StockCheck.sigmaerpdev2__Stock_Check_User_Name__c") ===undefined)
        {
            $A.util.addClass(myOutput1 , "textClass");
            window.scrollTo(0, 0);   
            myOutput1.set("v.value", "Select Verifying User");            
            return;
        }
        else
        {
            myOutput1.set("v.value", " ");
        }  
                
        var StockCheckDetails = component.get("v.StockCheckDetails");      
        
        
        var isChecked = false;
        for (var key in StockCheckDetails) {
            if (StockCheckDetails.hasOwnProperty(key)) {
                if(StockCheckDetails[key]['sigmaerpdev2__StockCheckbox__c']===true)
                    isChecked = true;
            }
        }      
        if(!isChecked){
            component.set("v.isError",true); 
            component.set("v.errorMsg",'Stock check to be completed for atleast one Product.');
            window.scrollTo(0, 0);           
            return;
        }
        
        //reason code validation - newly added on 4/4/2020
        for(var i=0; i<StockCheckDetails.length;i++){            
            if(StockCheckDetails[i].sigmaerpdev2__Stock_Check_Quantity__c > 0 && StockCheckDetails[i].sigmaerpdev2__Stock_Check_Quantity__c != StockCheckDetails[i].sigmaerpdev2__Available_Quantity__c){
                if(StockCheckDetails[i].sigmaerpdev2__StockCheckbox__c == true){
                    if(StockCheckDetails[i].sigmaerpdev2__Reason_Code__c == undefined || StockCheckDetails[i].sigmaerpdev2__Reason_Code__c == ''){                    
                        component.set("v.isError",true); 
                        component.set("v.errorMsg",'Reason is not selected @ row : '+(i+1));
                        return;
                    }
                }
            }            
        }       
        //ends here  
        
        //commented below lines on 4/4/2020 - as validations were not working as expected.
        /*for(var i=0; i<StockCheckDetails.length;i++){            
            if(StockCheckDetails[i].sigmaerpdev2__Available_Quantity__c != StockCheckDetails[i].sigmaerpdev2__Stock_Check_Quantity__c && StockCheckDetails[i].sigmaerpdev2__Reason_Code__c =='--None--' && StockCheckDetails[i].sigmaerpdev2__Stock_Check_Quantity__c!=0){
                component.set("v.isError",true); 
                component.set("v.errorMsg",'Select Reason for Difference Quantity in '+StockCheckDetails[i].ilpName);
                return;
            }           
            else if(StockCheckDetails[i].sigmaerpdev2__Stock_Check_Quantity__c < 0){
                component.set("v.isError",true); 
                component.set("v.errorMsg",'Provide valid Stock check qty for :'+StockCheckDetails[i].ilpName);
                return;
            }
        }*/
        
        component.set("v.isError",false);
        component.set("v.errorMsg",null);
        
        document.getElementById("Accspinner").style.display = "block"; 
        
        helper.SaveHelperMethod(component,event, helper);
        
    },
    SelectedID : function(component, event, helper){
        var context = event.getParam("instanceId");
        var objectId = event.getParam("sObjectId");
        //alert('context==='+context);
        //alert(objectId);
        
        if(context=='MyContact')
        {
            component.set("v.StockCheck.sigmaerpdev2__Stock_Check_User_Name__c",objectId);  
        }
        if(context=='ReceivingLocation')
        {         
            component.set("v.ilid",objectId); 
            component.set("v.showBarCodeFlg", true); //to hide or show Scan barcode checkbox - added on 12/11/2019
            
         /*   var TotalQty =0;
            var action = component.get("c.fetchselectILP");
            //	 alert('fetchselectILP>>>'+action);	
            //alert(JSON.stringify(component.get("v.ilid"))); 
            action.setParams({            
                
                "locname" : component.get("v.ilid")
            });
            action.setCallback( this, function(a) 
                               {
                                   var state = a.getState();
                                   //alert('state>>>>'+state);
                                   if (state === "SUCCESS") 
                                   {
                                       if(a.getReturnValue() !== null)
                                       {
                                           
                                           var temp = a.getReturnValue();
                                           //alert('temp2'+JSON.stringify(temp));
                                           //component.set("v.ILPlist", temp);
                                           
                                           //	var StockCheck = []; //code commented bcz throwing Reason_code Undefined error msg in component
                                           //component.set("v.StockCheckDetails","");
                                           //alert('StockCheck>>>'+component.get("v.StockCheckDetails"));
                                           var StockCheck = [];
                                           //  alert('StockCheck>>>'+StockCheck);
                                           for(var i=0; i<temp.length;i++){
                                               
                                               TotalQty = temp[i].sigmaerpdev2__Net_Quantity__c + temp[i].sigmaerpdev2__Delivered_Quantity__c; 
                                               //alert(TotalQty);        
                                               StockCheck.push({                                               
                                                   'sigmaerpdev2__Inventory_Location_Product__c' : temp[i].Id,
                                                   'ilpName' : temp[i].Name,
                                                   'sigmaerpdev2__Product__c' : temp[i].sigmaerpdev2__Products__c,
                                                   'prodName' : temp[i].sigmaerpdev2__Products__r.Name,
                                                   'sigmaerpdev2__Inventory_Location__c': temp[i].sigmaerpdev2__Inventory_Location__c,
                                                   'Loc':temp[i].sigmaerpdev2__Inventory_Location_Name__c,
                                                   'sigmaerpdev2__Available_Quantity__c' : temp[i].sigmaerpdev2__Net_Quantity__c ,
                                                   'sigmaerpdev2__Stock_Check_Quantity__c' : (!!temp[i].sigmaerpdev2__Stock_Check_Quantity__c)? temp[i].sigmaerpdev2__Stock_Check_Quantity__c : 0 ,
                                                   //'sigmaerpdev2__Stock_Check_Quantity__c' : temp[i].sigmaerpdev2__Net_Quantity__c ,	
                                                   //'sigmaerpdev2__Reason_Code__c' :'',
                                                   'sigmaerpdev2__StockCheckbox__c':'',
                                                   'prodBarCode': temp[i].sigmaerpdev2__Products__r.sigmaerpdev2__Product_Bar_Code__c
                                                   
                                               });
                                               
                                           } 
                                           //alert('push val..2'+JSON.stringify(StockCheck));
                                           component.set("v.StockCheckDetails",StockCheck);
                                           
                                           //	alert(' new StockCheckDetails>>'+JSON.stringify(component.get("v.StockCheckDetails")));
                                           
                                           
                                       } 
                                       else{
                                           alert('Fetching ILP data Failed1');
                                       }   
                                   }
                                   else
                                   {
                                       alert('Fetching ILP data Failed2');
                                   }
                                   
                                   
                               }); 
            
            // document.getElementById("Accspinner").style.display = "block";
            
            $A.enqueueAction(action);  
         */   
        }
        
    },
      /*print: function(component, event, helper) {
         //  console.log('chalu'+component.get("v.recordId"));
          var recordId = 'a0D0o00001RsTZJEA3';
         alert('chalu'+component.get("v.recordId"));
        var url = '/apex/StockCheckvf?id=' + recordId ;
        var urlEvent = $A.get("e.force:navigateToURL");
  urlEvent.setParams({
    'url': url
  });
  urlEvent.fire();
        // window.print();
    },*/
    
  print: function (component, event, helper) {
    
        var locname = component.get("v.ilid");
        var pkgid= component.get('v.packagedBy');
	 	var date1 = component.get("v.StockCheck.sigmaerpdev2__Stock_Check_Date__c");  
       	/*var url = '/apex/sigmaerpdev2__StockCheckvf?name='+locname+'&packagedBy='+pkgid+'&selDate='+date1;
       	var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();*/ 
     	window.open('/apex/sigmaerpdev2__StockCheckvf?name='+locname+'&packagedBy='+pkgid+'&selDate='+date1);
 },
    BackButton : function(component, event, helper){
        component.set("v.loaded",'false');
        component.set("v.loaded",'true');          
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/lightning/n/sigmaerpdev2__Stock_Management_Modules"
        });        
        urlEvent.fire();         
    },
    afterProdScaned:function (component, event, helper){
        //alert('lineItem>>'+JSON.stringify(lineItem));
        component.set("v.productFoundFlag",false);
        var prodBarCodeValue=component.get('v.prodBarCodeValue');
        var prodBarCodeValue1=JSON.stringify(prodBarCodeValue);
        var pickingData=component.get('v.StockCheckDetails'); 
        if(prodBarCodeValue!==undefined)
        {
            prodBarCodeValue=prodBarCodeValue.trim();
            var lineItem=pickingData.find(x => x.prodBarCode===prodBarCodeValue);
            console.log('lineItem>>'+JSON.stringify(lineItem));
            //	  alert('lineItem>>'+JSON.stringify(lineItem));
            // alert('lineItem>>'+JSON.stringify(lineItem));
            if(lineItem!==undefined)
            {
                if(lineItem.sigmaerpdev2__Available_Quantity__c===0)
                {
                    alert('DIFFERENCE QTY  CANNOT BE NEGATIVE.');
                    
                    return ;
                }
            }
        }
        // alert('pickingData>>'+JSON.stringify(pickingData));
        console.log('pickingData>>'+JSON.stringify(pickingData));
        var locid=component.get('v.ilid');
        window.setTimeout(
            $A.getCallback(function() {
                var prodBarCodeValueInner=component.get('v.prodBarCodeValue');
                var prodFound = false;
                var allProdPicked = false;
                var allPickedProdName = '';
                if(prodBarCodeValueInner.length==prodBarCodeValue.length)
                {
                    var pickingData=component.get('v.StockCheckDetails');
                    console.log(pickingData);
                    //alert('afterProdScaned is called ::pickingData::'+JSON.stringify(pickingData));
                    for(var i=0;i<pickingData.length;i++)
                    {
                        console.log(pickingData[i].prodBarCode + '--'+prodBarCodeValue);
                        console.log(pickingData[i].Loc+'--'+locid);
                        if(pickingData[i].prodBarCode==prodBarCodeValue && pickingData[i].Loc==locid)/* && pickingData[i].reqQty!=pickingData[i].totalPickedQty   && !pickingData[i].hasAltPick)*/
                        {
                            pickingData[i].sigmaerpdev2__Stock_Check_Quantity__c=pickingData[i].sigmaerpdev2__Stock_Check_Quantity__c? parseInt(pickingData[i].sigmaerpdev2__Stock_Check_Quantity__c)+1:1;
                            //alert('chkbox==='+pickingData[i].sigmaerpdev2__StockCheckbox__c);
                            pickingData[i].sigmaerpdev2__StockCheckbox__c = true;
                            component.set("v.qnty",pickingData[i].sigmaerpdev2__Net_Quantity__c - pickingData[i].sigmaerpdev2__Stock_Check_Quantity__c);
                            //component.set("v.scannedProductName",pickingData[i].prodName);
                            //component.find("ProdName").set('v.value',pickingData[i].prodName);
                            prodFound=true;
                            //$A.util.removeClass(component.find('ProdName'), 'slds-hide');
                            if(pickingData[i].sigmaerpdev2__Stock_Check_Quantity__c==pickingData[i].sigmaerpdev2__Available_Quantity__c){
                                allProdPicked=true;
                                allPickedProdName=pickingData[i].prodName;
                            }
                            break;
                        }
                    }
                    
                    component.set('v.StockCheckDetails',pickingData);
                    if(prodFound)
                    {
                        component.set('v.prodBarCodeValue','');
                        component.set("v.productFoundFlag",true);
                        //if(allProdPicked){
                        component.set("v.scannedProductName",'Product Found');
                        //}
                    }
                    else
                    {
                        component.set("v.scannedProductName",'Not Found');
                        component.set("v.productFoundFlag",true);
                    }
                    if(allProdPicked){
                        console.log('1');
                        var allProductsRecieved=true;
                        for(var i=0;i<pickingData.length;i++)
                        {
                            console.log('in loop');
                            if(pickingData[i].sigmaerpdev2__Stock_Check_Quantity__c!=pickingData[i].sigmaerpdev2__Available_Quantity__c)
                            {
                                console.log('in loop condition');
                                allProductsRecieved=false;
                            }
                        }
                        console.log(allProductsRecieved);                        
                        if(allProductsRecieved){
                            var resultsToast = $A.get("e.force:showToast");
                            resultsToast.setParams({
                                "type": "success",
                                // "message": "All Products Picked Successfully. Now you can click on submit"
                            });
                            resultsToast.fire();
                            component.set("v.scannedProductName",'');
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
    checkEmptyDate : function(component, event, helper){
        var selDate = component.get("v.StockCheck.sigmaerpdev2__Stock_Check_Date__c");        
        var myOutput2 = component.find("custValidationss");
        if(selDate != '' && selDate != undefined){
            myOutput2.set("v.value", " ");
        }
       
    },
    userChanged : function(component, event, helper){
        var userName = component.get("v.StockCheck.sigmaerpdev2__Stock_Check_User_Name__c");
        var pkgby = component.get("v.packagedBy");                
        var myOutput1 = component.find("custValidation");
        if(pkgby != '' && pkgby != undefined)
            myOutput1.set("v.value", " ");
        else
            component.set("v.StockCheck.sigmaerpdev2__Stock_Check_User_Name__c", "");
    },
    
    removeLoc : function(component, event, helper){
        var locId = component.get("v.ilid");
        if(locId == '' || locId == undefined)
            component.set("v.showBarCodeFlg", false);                
    }
})