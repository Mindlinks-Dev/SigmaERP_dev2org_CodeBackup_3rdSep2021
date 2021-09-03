({
	  toastMsg : function( strType, strMessage ) {  
          
        var showToast = $A.get( "e.force:showToast" );   
        showToast.setParams({   
              
            message : strMessage,  
            type : strType,  
            mode : 'sticky'  
              
        });   
        showToast.fire();   
          
    } ,
     toGetcustomerData:function(component, event,helper){
       alert('call helper');
         var action = component.get("c.fetchproductRecords");
         var pageSize = component.get("v.pageSize").toString();
         var pageNumber = component.get("v.pageNumber").toString();
         
        action.setParams({
            'pageSize' : pageSize,
            'pageNumber' : pageNumber
        });
          
        
         action.setCallback(this, function(response){
              var state = response.getState();
            if (state === "SUCCESS") {
             //   alert('success'+ response.getReturnValue());
                var resultData = response.getReturnValue();
                if(resultData.length < component.get("v.pageSize")){
                    component.set("v.isLastPage", true);
                } else{
                    component.set("v.isLastPage", false);
                }
                component.set("v.dataSize", resultData.length);
             
             alert('response>>>'+JSON.stringify(response.getReturnValue()));
             
             component.set("v.productList",response.getReturnValue());
                alert('productList>>>'+JSON.stringifycomponent.get("v.productList"));
            }
            
         });
         component.set('v.mycolumn', [
             {label: 'Product Name', fieldName: 'sigmaerpdev2__Product_Name__r.name', type: 'text'},
             {label: 'Product Code', fieldName: 'sigmaerpdev2__Product_Name__r.ProductCode', type: 'Text'},
             {label: 'Current Vendor Stock', fieldName: 'sigmaerpdev2__Product_Name__r.sigmaerpdev2__CurrentVendorStock__c', type: 'number',editable: true},
             {label: 'Location', fieldName: '', type: 'lookup',editable: true}
            

         ]);
                                   
         
         $A.enqueueAction(action);
    },

})