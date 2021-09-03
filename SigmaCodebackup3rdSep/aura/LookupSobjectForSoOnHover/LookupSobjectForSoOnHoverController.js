/**
 * (c) Tony Scott. This code is provided as is and without warranty of any kind.
 *
 * This work by Tony Scott is licensed under a Creative Commons Attribution 3.0 Unported License.
 * http://creativecommons.org/licenses/by/3.0/deed.en_US
 */
({
    doInit:function(cmp, event, helper)
    {	
        var customer = cmp.find("forCustomer");
       
        var toggleText = cmp.find("slds");
        $A.util.removeClass(toggleText, 'toggle');
        //alert('hiii');
        //setting data if standard order object is used 
        // By-forgation in standard and custom setting by chandana 
		var ordertype = cmp.get("c.CheckOrder");
        
		ordertype.setCallback( this, function(response1) 
		{
            var state = response1.getState();
            if (state === "SUCCESS")
			{
				var res = response1.getReturnValue();
				if(res.sigmaerpdev__Standard_object__c == true)
                {
                    cmp.set("v.isStandardOrder",true);
					//alert('standered order flow ');
				}
            }
        });
        $A.enqueueAction(ordertype);
       
    },
    /**
     * Search an SObject for a match
     */
	search : function(cmp, event, helper) {
       
		helper.doSearch(cmp,event);        
    },

    /**
     * Select an SObject from a list
     */
    select: function(cmp, event, helper) {
             
    	helper.handleSelection(cmp, event);
    },
    
    /**
     * Clear the currently selected SObject
     */
    clear: function(cmp, event, helper) {
        
    	helper.clearSelection(cmp);    
    }, 
    
   
    
    showData : function(cmp, event, helper){
        
        cmp.set("v.showOnHoverDetails","");
        var index = event.target.dataset.index;
        var selAnch = document.getElementById('id_'+index);         
        var localval= cmp.get("v.isStandardOrder");
        //alert('localvalflag::'+index);
        if(localval == true)
        {
          var action = cmp.get("c.getStandInfoForSoOnHover");        
        action.setParams({           
            "stappOrderId":index
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
           //alert('success');
            if (state === "SUCCESS"){
           	var totStr = '';
               var res = a.getReturnValue();
               var convDate = String(res[0].sigmaerpdev__Date__c);                
               var dd = convDate.substring(8,11);
               var mm = convDate.substring(5,7);
               var year = convDate.substring(0,4);                
               if(res[0].OrderItems != undefined){
                   //alert('inside if');
               	for(var j=0;j<res[0].OrderItems.length;j++){
					//alert('inside for');
                       if(totStr == ''){
                           totStr = 'Date : '+dd+'-'+mm+'-'+year +"\n"+ 'Product(s) : '+res[0].OrderItems[j].PricebookEntry.Product2Id ;
                       }else{
                           totStr = "\n" + totStr + "," + res[0].OrderItems[j].PricebookEntry.Product2Id;    
                       }                
                   }            
                        
                   cmp.set("v.showOnHoverDetails",totStr);
                 //alert('totstr::'+JSON.stringify(cmp.get("v.showOnHoverDetails")));
               }                    
           }                           
        });
        $A.enqueueAction(action);  
        }
        else
        {
            var action = cmp.get("c.getInfoForSoOnHover");        
        	action.setParams({           
            "stappOrderId":index
        	});
        	action.setCallback(this, function(a) {
            var state = a.getState();
                //alert('ststes::'+state);
            if (state === "SUCCESS"){
            	var totStr = '';
                var res = a.getReturnValue();
                var convDate = String(res[0].sigmaerpdev__Date__c);                
                var dd = convDate.substring(8,11);
                var mm = convDate.substring(5,7);
                var year = convDate.substring(0,4); 
                console.log('responce='+JSON.stringify(res));
                if(res[0].Order_Lines__r != undefined){
                    //alert('inside if');
                	for(var j=0;j<res[0].Order_Lines__r.length;j++){    
                        //alert('inside for');
                        if(totStr == ''){
                            totStr = 'Date : '+dd+'-'+mm+'-'+year +"\n"+ 'Product(s) : '+res[0].Order_Lines__r[j].Product__r.Name;
                        }else{
                            totStr = "\n" + totStr + "," + res[0].Order_Lines__r[j].Product__r.Name;    
                        }  
                       // alert('inside ifelse');
                    }            
                    cmp.set("v.showOnHoverDetails",totStr);
                  //alert('totstr:'+JSON.stringify(cmp.get("v.showOnHoverDetails")));
                }  
                 //cmp.set("v.showOnHoverDetails",totStr);
                //alert('totstr:'+JSON.stringify(cmp.get("v.showOnHoverDetails")));
            }                         
        });
        $A.enqueueAction(action);
        }
        
    }
})