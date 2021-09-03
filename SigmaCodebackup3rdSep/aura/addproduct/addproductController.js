({
    changedate : function(component, event, helper){        
        var dateDOB = event.getSource().get("v.value");
        var dobres=dateDOB.split('/'); 
        var day = dobres[0];
        var month = dobres[1];
        var year = dobres[2];
        var myDate = new Date(dateDOB);
        var today = new Date();
        if ( myDate > today ) { 
            alert('You cannot enter a date in the future');
            component.set("v.Vplist.sigmaerpdev2__Last_Updated_Date__c",today); 
            return false;
            
        }
        },
	 doInit: function(component, event, helper) {
       //alert('1')
        helper.fetchUser(component, event,helper);
        
     },
     populateCode : function(component, event, helper){
        //alert('18');
        var pid=component.get("v.Vplist1.sigmaerpdev2__Product_Name__c");
        // alert('pid>>>>'+pid)
        if(pid==null || pid==undefined || pid==''){
            component.set('v.productcode','');
         
          component.set('v.showtable',false);
        }
        else{
             component.set('v.showtable',true);
        var action = component.get("c.getCode");
            action.setParams({
                pid:pid
            
        		});
           
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                   // alert('state>>'+state);
                    // if response if success then reset/blank the 'productList' Attribute 
                    // and call the common helper method for create a default Object Data to Contact List 
                    component.set("v.productcode", response.getReturnValue());
                    
                }
            });
      
            // enqueue the server side action  
            $A.enqueueAction(action);
        helper.loadData(component, event, helper,pid);
        }
         
    },
     Save: function(component, event, helper) {
       // alert('Save');
        var ProductName= component.get("v.Vplist1.sigmaerpdev2__Product_Name__c");
       var ProductCode= component.get("v.productcode");
        //alert('ProductName>>>>'+ProductName)
          var resultdata = component.get("v.Vplist"); 
        
      // alert('58>> '+JSON.stringify(resultdata));
        
        var validdata = [];
        if(ProductName == null || ProductName == ''){
            alert('Please Enter New Product');
            return;
        }
         for(var i=0; i<resultdata.length; i++)
        {
         console.log('loop : '+JSON.stringify(resultdata[i]));
         if((resultdata[i].sigmaerpdev2__Current_Stock__c != null && resultdata[i].sigmaerpdev2__Current_Stock__c != '') && (resultdata[i].sigmaerpdev2__Buying_Price__c  == null || resultdata[i].sigmaerpdev2__Buying_Price__c == '')){
               // alert('bp' ); 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please enter price for "+ resultdata[i].sigmaerpdev2__Vendor_Location__r.Name+'.',
                    "type": "error"
                });
                toastEvent.fire();
                return; 
         }
           
              if((resultdata[i].sigmaerpdev2__Buying_Price__c != null && resultdata[i].sigmaerpdev2__Buying_Price__c != '') && (resultdata[i].sigmaerpdev2__Current_Stock__c  == null || resultdata[i].sigmaerpdev2__Current_Stock__c == '')){
                //alert('cs'); 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please enter current stock for "+ resultdata[i].sigmaerpdev2__Vendor_Location__r.Name+'.',
                    "type": "error"
                });
                toastEvent.fire();
                return;
            }           
         if( resultdata[i].sigmaerpdev2__Current_Stock__c > 0 &&  resultdata[i].sigmaerpdev2__Buying_Price__c > 0){
         
             validdata.push(resultdata[i]);
           // component.set("v.Vplist",validdata);
           component.set("v.Vplist2",validdata);
         }
         
  
        }
        
        if(validdata.length == 0){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Enter atleast one product\'s current stock and price  ." , 
                "type": "error"
            });
            toastEvent.fire();
            return;
        }
 else{
            
            //var prodtolocList = component.get("v.Vplist");
     var prodtolocList = component.get("v.Vplist2");
           //alert('VPlistparam inside  save : '+JSON.stringify(prodtolocList));
        
            helper.saveProduct(component, event, helper,prodtolocList);
 }
    },
    cancel : function(component,event,helper){
        // on cancel refresh the view (This event is handled by the one.app container. It’s supported in Lightning Experience, the Salesforce app, and Lightning communities. ) 
        $A.get('e.force:refreshView').fire(); 
    },
})