({
     printPurchaseOrdersPDF:function (component, event, helper) 
    {    
       var listOfPos= component.get("v.items");
       // alert(JSON.stringify(listOfPos));
            console.log(JSON.stringify(listOfPos));
       let selectedPos=[];
        for(var i=0;i<listOfPos.length;i++)
        {
          // if(JSON.stringify(listOfPos[i].Status))
           if(listOfPos[i].Status)
           {
              if(listOfPos[i].isSelected===true && listOfPos[i].Status!=null  && listOfPos[i].Status!=undefined && listOfPos[i].Status!='')
            {
                 // alert('status'+JSON.stringify(listOfPos[i].Status));
                selectedPos.push(listOfPos[i]);
            } 
           }
            
        }
		//alert('selectedPos>>'+JSON.stringify(selectedPos));
        //return ;
            console.log(JSON.stringify(selectedPos));
         //alert(selectedPos.length);
        if(selectedPos.length>0)
        {
            helper.printPurchaseOrdersPDFHelper(component, event, helper,selectedPos) ;
        }
        else
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                //title : 'Error Message',
                message:'Please Select Any Purchase Order to Print.',
                messageTemplate: 'Mode is pester ,duration is 5sec and Message is overrriden',
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            toastEvent.fire();
            return;
        }
        
        
        
    },
	 doint: function(component, event, helper,page) {
          // component.set('v.isModalOpen', true);
        let POId=component.get('v.POId') 
         
        // return;
       // alert('if');
        page = page || 1;    
      //    alert('if'+page);
        var action = component.get("c.POListViewonly");
         action.setParams({ 'pageNumber' : page , 'poId' :POId });
        action.setCallback(this, function(response) {
            var state = response.getState();
           // alert(state);
            if (state === "SUCCESS") {
                var accs = response.getReturnValue(); 
               // alert(JSON.stringify(accs.PoWrapperList));
                 console.log(JSON.stringify(accs));
                component.set('v.total', accs.total);
                component.set('v.page', accs.page);
                component.set('v.pages', Math.ceil(accs.total/accs.pageSize));
                component.set("v.items",accs.PoWrapperList);
               // component.set("v.items",[{expanded: false, title: accs.PoList}]);
               /* for(var i =0; i<accs.PoList.length ; i++){
                    var group = accs.PoList;
                    group.splice(i, 1); 
                    component.set("v.items", [
                        { expanded: false, title: group}
                        
                    ]);                
                }*/
                
               // alert(JSON.stringify(component.get("v.items")));
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action); 
    },
    fetchPOS: function(component, event, helper,page) {
          var VendorWrapper= component.get('v.VendorWrapper');
        if(VendorWrapper!==undefined && VendorWrapper.isVendorFound===true)
        {
             // alert('if');
        page = page || 1;    
      //    alert('if'+page);
        var action = component.get("c.POListViewonly");
        action.setParams({ 'pageNumber' : page, 'vendorId':VendorWrapper.vendor.Id });
        action.setCallback(this, function(response) {
            var state = response.getState();
           // alert(state);
            if (state === "SUCCESS") {
                var accs = response.getReturnValue(); 
              //  alert(JSON.stringify(accs));
                 console.log(JSON.stringify(accs));
                component.set('v.total', accs.total);
                component.set('v.page', accs.page);
                component.set('v.pages', Math.ceil(accs.total/accs.pageSize));
                component.set("v.items",accs.PoWrapperList);
               // component.set("v.items",[{expanded: false, title: accs.PoList}]);
               /* for(var i =0; i<accs.PoList.length ; i++){
                    var group = accs.PoList;
                    group.splice(i, 1); 
                    component.set("v.items", [
                        { expanded: false, title: group}
                        
                    ]);                
                }*/
                
               // alert(JSON.stringify(component.get("v.items")));
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action); 
        }
      
    },
     pageChange: function(component, event, helper) {
       // var spinner = component.find("mySpinner");
        var page = component.get("v.page") || 1;
        
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
         let POId= component.get('v.POId');
         console.log('POId>>>'+POId);
         if(POId)
        helper.getPOList(component, event, helper,page,POId);
         else helper.getPOList(component, event, helper,page,null);
    },
   /* openModel: function(component, event, helper) {
      // Set isModalOpen attribute to true
      component.set("v.isModalOpen", true);
   },
  
   closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
   },
  
   submitDetails: function(component, event, helper) {
      // Set isModalOpen attribute to false
      //Add your code to call apex method or do some processing
       var VendorEmail= component.get('v.VendorEmail');
          var Password= component.get('v.Password');
         //alert(VendorEmail);
       //    alert(Password);
     
       if(VendorEmail!==undefined && Password!==undefined)
       {
            helper.validateVendorCredentials(component,event, helper,VendorEmail,Password);
       }
      
   },*/
   poClearEvent: function (component, event, helper) {
      //  alert('poClearEvent is called ');
        // alert(component.get('v.soID'));
         var page = component.get("v.page") || 1;
        if(!component.get('v.POId')){
         //  let POId= component.get('v.POId');
        helper.getPOList(component, event, helper,page,null);
           // helper.getPOListTemp(component, event, helper,page,null);
            //    alert('soClearEvent is called insidwe if ');
            //  var spinner=component.find('spinner');
            //   $A.util.toggleClass(spinner, 'slds-hide');
            
        }
        else
        {
            let POId= component.get('v.POId');
        helper.getPOList(component, event, helper,page,POId);
           // helper.getPOListTemp(component, event, helper,page,component.get('v.POId'));
            //  var spinner=component.find('spinner');
            // $A.util.toggleClass(spinner, 'slds-hide');
            //helper.getSOData(component, event, helper,null,'desc');
        }
    },
})