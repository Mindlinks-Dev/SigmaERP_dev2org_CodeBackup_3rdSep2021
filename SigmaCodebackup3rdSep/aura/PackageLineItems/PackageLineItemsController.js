({
     handleProductImageData : function(component, event, helper){		
          var data = event.getParam("data");
        var flag = event.getParam("flag");
         console.log("handleProductImageData>>>data>>"+JSON.stringify(data));
         console.log("handleProductImageData>>>flag"+JSON.stringify(flag));
          console.log("handleProductImageData>>>data[prodId]"+JSON.stringify(data["prodId"]));
         var proId=data["prodId"];
         console.log("proId"+JSON.stringify(proId)+'>>>'+JSON.stringify(proId)!='""' && JSON.stringify(flag) ==='"viewProductImage"');
         
         //if(JSON.stringify(proId)!="")
        if (JSON.stringify(proId)!='""' && JSON.stringify(flag) ==='"viewProductImage"' ) 
        {
            helper.fetchProductImageDataHelper(component, event, helper,proId);
        }
    },
    handleBasketValChange : function(component, event, helper){		
        if(event.getParam("value") == '' || event.getParam("value") == undefined){                      
            if(component.get("v.stappOrderID") != '' && component.get("v.custId") != ''){                
                component.set("v.stappOrderID", '');    
                if(component.get('v.isSigmaOrder')==true)
                {
                    component.set("v.stappOrderName", ''); 
                }
                else
                {
                    component.set("v.standOrderNumber", '');
                }
                var StappCompEvent = component.getEvent("SigmaComponentResetEvent");                
                StappCompEvent.fire();
            }
        }       
    },
    doInit: function(component, event, helper) {
         //  alert('stappOrderName'+JSON.stringify(component.get('v.isSOComingFromPicking')));
        //alert(component.get('v.packRecordId'));
        //alert('stappOrderName'+JSON.stringify(component.get('v.stappOrderName')));
       //  alert('stappOrderID'+JSON.stringify(component.get('v.stappOrderID')));
       //   alert('packageProduct>>>'+JSON.stringify(component.get('v.packageProduct')));
        if($A.get("$Browser.formFactor") !== "DESKTOP"){
            component.set('v.mobileScreenFlag',true);
        }
     //alert(JSON.stringify(component.get('v.mobileScreenFlag'))); 
        //alert('isSigmaOrder'+JSON.stringify(component.get('v.isSigmaOrder'))); 
       // alert('isSOComingFromPicking'+JSON.stringify(component.get('v.isSOComingFromPicking'))); 
         //alert('stappOrderID'+JSON.stringify(component.get('v.stappOrderID'))); 
         //alert('custName1'+JSON.stringify(component.get('v.custName1'))); 
        
      //  alert(JSON.stringify(component.get('v.isSigmaOrder'))); 
        
        
        if(component.get("v.stappOrderID") != '' && component.get("v.stappOrderID") != undefined){
            if(component.get('v.isSigmaOrder'))
            {	
                helper.getBasketInfoH(component, event, helper);
            }
            else
            {	
                helper.getBasketOrderInfoH(component, event, helper);
            }
         }
    },
    handleLookupValueselected:function(component,event,helper){
        //helper.helperFetchSOItems(component,event,helper);
        if(event.getParam("objectAPIName")==='sigmaerpdev2__Sigma_Order__c'){
            var StappComponentEvent = component.getEvent("StappComponentEvent");
            StappComponentEvent.setParams({
                "data" : {"index":component.get('v.indexNum'),
                          "soID":component.get('v.stappOrderID'),
                          "soName":component.get('v.stappOrderName')
                         },
                "flag" : "fetchPPDataList"
            });
            StappComponentEvent.fire();
        }
        
        //Code added by rashmi to handle standard order in package on 25-07-2019    
        else if(event.getParam("objectAPIName")==='Order'){
            var StappComponentEvent = component.getEvent("StappComponentEvent");
            StappComponentEvent.setParams({
                "data" : {"index":component.get('v.indexNum'),
                          "soID":component.get('v.stappOrderID'),
                          "soName":component.get('v.standOrderNumber')
                         },
                "flag" : "fetchPPDataList"
            });
            StappComponentEvent.fire();
        }
            else if(event.getParam("objectAPIName")==='stapp__Location__c'){
                var StappComponentEvent = component.getEvent("StappComponentEvent");
                StappComponentEvent.setParams({
                    "data" : {"index":component.get('v.indexNum'),"basketId":component.get('v.basketId'),"basketName":component.get('v.basketName')},
                    "flag" : "fetchPPDataListBasedOnBasket"
                });
                StappComponentEvent.fire();
            }
    },
    handleSOIdValueChange: function(component, event, helper) 
    {
		//alert('::::::::::'+JSON.stringify(component.get('v.isSOComingFromPicking')));
       var stappOrderID=component.get('v.stappOrderID');
          console.log('stappOrderID'+stappOrderID);
        if(JSON.stringify(stappOrderID)!=='""')
        {
            var controlOrderIdEvent = component.getEvent("controlOrderIdEvent");
            controlOrderIdEvent.setParams({
                "orderId" : stappOrderID
            });
            controlOrderIdEvent.fire(); 
        }
        else
        {
            var controlOrderIdEvent = component.getEvent("controlOrderIdEvent");
            controlOrderIdEvent.setParams({
                "orderId" : ''
            });
            controlOrderIdEvent.fire(); 
            
        }
       
         // alert('stappOrderIDStr'+JSON.stringify(stappOrderID));
       // alert('stappOrderIDStr'+JSON.stringify(stappOrderID)); 
          //component.set('v.isSOComingFromPicking',true);
        
		//alert('::::::::::'+JSON.stringify(component.get('v.isSOComingFromPicking')));
        if(!component.get('v.stappOrderID')){
            if(JSON.stringify(stappOrderID)==='""')
            {
                 console.log('stappOrderID in side if '+JSON.stringify(component.get('v.stappOrderID')));
           //  alert('idListStr'+JSON.stringify(component.get('v.idListStr')));
            // alert('isSigmaOrder'+JSON.stringify(component.get('v.isSigmaOrder')));
            // alert('packageProduct'+JSON.stringify(component.get('v.packageProduct')));
            component.set('v.packageProduct',[]);
            var idListStr=component.get('v.idListStr');
            // alert('idListStr'+JSON.stringify(component.get('v.idListStr')));
            if(idListStr)
                idListStr = idListStr.replace(event.getParam("oldValue"), "");
            component.set('v.idListStr',idListStr);
            // component.set('v.basketBarCodeValue','');             
            //component.set('v.custName1', '');	
            // alert('isSigmaOrder'+JSON.stringify(component.get('v.isSigmaOrder')));
            //if(component.get("v.stappOrderID") == ''){                             
            component.set("v.stappOrderID", '');
            //component.set("v.custId", '');
            // component.set("v.stappOrderName", '');
            if(component.get("v.isSigmaOrder")==true)
            {
                component.set("v.stappOrderName", ''); 
            }
            else
            {
                component.set("v.standOrderNumber", '');
            }
           // alert('34234234');
            var StappCompEvent = component.getEvent("StappComponentResetEvent");                
            if(StappCompEvent !=null)
            StappCompEvent.fire();
            }
           
            //}
        }
        
        
        
        
        
        /*else{ //get the basket for the selected Stapp order
             if(component.get("v.basketBarCodeValue") == '' || component.get("v.basketBarCodeValue") == undefined){
             	helper.getBasketInfoH(component, event, helper);
             }
        }*/
    },
    /*   afterBasketScaned:function (component, event, helper){        
               
       // alert("basketBarCodeValue"+component.get("v.basketBarCodeValue"));
        if(!component.get('v.basketBarCodeValue') || component.get('v.basketBarCodeValue').length < 5){                       
            return;
        }        
        var baskBarCodeValue = component.get('v.basketBarCodeValue');        
        window.setTimeout(
            $A.getCallback(function(){
                var locBarCodeValueInner=component.get('v.basketBarCodeValue');                
                if(locBarCodeValueInner.length == baskBarCodeValue.length){
                    helper.getBasketDetailsH(component, event, helper);					
                }
            }), 2000
        );     
    },*/
    
})