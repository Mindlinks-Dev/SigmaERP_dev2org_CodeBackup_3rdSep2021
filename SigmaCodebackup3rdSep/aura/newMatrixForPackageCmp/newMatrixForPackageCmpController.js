({
	doInit : function(component, event, helper) {
     
    },
    
     SelectedID : function(component, event){       
       var context = event.getParam("instanceId");
       var objectId = event.getParam("sObjectId");
       if(context == 'MyOrder'){  
           component.set("v.tempRecordId1",objectId);              
       } 
    },
    
    transChange : function(component, event, helper) {         
		component.set("v.transId",component.get("v.tempRecordId1")); 
       	helper.getTransLineItems(component);       
    },
    
    savePackage : function(component, event, helper){ 
       //added for validation for package quantity on 24/10/2017                             
       var tempWrap = component.get("v.transLineList");
      for(var i=0;i<tempWrap.length;i++)
       {
           var tempSelQuantity = 0;
            for(var j=0;j<tempWrap[i].wrapProdList.length;j++){
                if(tempWrap[i].wrapProdList[j].selQuantity != undefined && tempWrap[i].wrapProdList[j].selQuantity != ''){
                	tempSelQuantity = tempSelQuantity + parseInt(tempWrap[i].wrapProdList[j].selQuantity);    
                }                                
                if(j == tempWrap[i].wrapProdList.length -1)
                {                    
                   if(tempSelQuantity > tempWrap[i].recvQnt)
                    {
                        var msg = "Package quantity should be less than ordered quantity for bill item "+(i+1);
                        component.set("v.errorMsg", msg);
                        component.set("v.isError",true);
                        return;
                    }else{
                        component.set("v.isError",false);
                        component.set("v.errorMsg", "");
                    }
                }
           }           
           if(i == tempWrap.length - 1)
           {               
			 helper.createPackage(component);
           }
       }      
     
    },
    
  
    hidePopup:function(component, event, helper)
    {  
        component.set("v.isManualFromParent",false);
        //alert('selquantit'+JSON.stringify(component.get("v.transLineList.wrapProdList.selQuantity")));
        component.set("v.transLineList.wrapProdList.selQuantity",0);
        //alert(' After selquantit'+JSON.stringify(component.get("v.transLineList.wrapProdList.selQuantity")));
      var quant = component.get("v.transLineList.wrapProdList.selQuantity");
        //alert('quant::'+quant);
        var appEvent = $A.get("e.c:handlebackEvent");
        appEvent.setParams({
            "quantity" : quant 
             });
        appEvent.fire();
        //alert('after fire');
    },
    
    //update the selected ilpli values to the original list [for Autopick / Manual Flow]
    saveManualList : function(component, event, helper){            
    	var autoManualList = component.get("v.autopickOrManualList");
		var selTransId = component.get("v.selTransLineItemId"); 
        
        var tempWrap = component.get("v.transLineList");
        console.log('tempWrap=='+JSON.stringify(tempWrap));
       	var popupTransLineId ;
        var arr = []; //wrapProdList array to store only selected ilplis from popup        
        console.log('autoList console=='+JSON.stringify(autoManualList));
        for(var k=0;k<tempWrap.length;k++){            
            popupTransLineId = tempWrap[k].transItemId;            
        }         
          
        
        var tempSelQuantity = 0;
        var orderedQty = 0;
        var packQty = 0;
         for(var i=0;i<=tempWrap.wrapProdList.length;i++){
            orderedQty = parseInt(tempWrap.recvQnt); 
            packQty = parseInt(component.get("v.packQty"));
           if(tempWrap.wrapProdList[i] != undefined){
            	if(tempWrap.wrapProdList[i].selQuantity != undefined && tempWrap.wrapProdList[i].selQuantity != ''){                    
                   tempSelQuantity = tempSelQuantity + parseInt(tempWrap.wrapProdList[i].selQuantity);
                   
            	}        
            }                 	
        }
        
        if(tempSelQuantity == 0){
            alert('Enter value for Quantity field.');
            return;
        }
        
        if(tempSelQuantity > packQty){
            alert('Selected quantity cannot be greater than Packaged quantity.');
            return;
        }
        if(tempSelQuantity < packQty){
            alert('Selected quantity cannot be lesser than Packaged quantity.');
            return;
        }
        //ends here
        for(var i=0;i<autoManualList.length;i++){             
            if(autoManualList[i].transLineItemId == selTransId){                
                
                var t = [];
                t.push(tempWrap);
                autoManualList[i].prodwrap = t;                                
            }
        }
       
		//close the popup after selecting ilpli via the manual flow	    
        component.set("v.isManualFromParent",false);
       
	},
    
})