({
    doInit: function(component, event, helper) {
        helper.createObjectData(component, event);
        helper.fetchUser(component, event,helper);
    },
    Save: function(component, event, helper) {        
        var LocationName = component.find("productsLocationInput").get("v.value");
        var ContactInputs = component.find('contact-input').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);     
        if(LocationName == null || LocationName == ''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please enter new location." ,
                "type": "error"
            });
            toastEvent.fire();
            return;
        }
        var resultdata = component.get("v.ProductWrapper.VPList"); 
        var validdata = [];
        //alert(JSON.stringify(resultdata));
        
        for(var i=0; i<resultdata.length; i++)
        {
            //alert('loop : '+resultdata[i]);
            // var reqant = resultdata[i].sigmaerpdev2__Buying_Price__c; 
            
            if(resultdata[i].sigmaerpdev2__Buying_Price__c != 0 && (resultdata[i].sigmaerpdev2__Current_Stock__c  == null || resultdata[i].sigmaerpdev2__Current_Stock__c == '')){
                //alert('cs'); 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please enter current stock for "+ resultdata[i].sigmaerpdev2__Product_Name__r.Name+'.',
                    "type": "error"
                });
                toastEvent.fire();
                return;
            }           
            if(resultdata[i].sigmaerpdev2__Current_Stock__c != 0 && (resultdata[i].sigmaerpdev2__Buying_Price__c  == null || resultdata[i].sigmaerpdev2__Buying_Price__c == '')){
                //alert('bp'); 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please enter price for "+ resultdata[i].sigmaerpdev2__Product_Name__r.Name+'.',
                    "type": "error"
                });
                toastEvent.fire();
                return;                
            }
            if(resultdata[i].sigmaerpdev2__Buying_Price__c > 0 && resultdata[i].sigmaerpdev2__Current_Stock__c > 0){
                validdata.push(resultdata[i]);
            }
        }        
        //alert('validdata>>>>>'+JSON.stringify(validdata));
        //alert('final wrapper>>>>>'+JSON.stringify(component.get("v.ProductWrapper")));
        //alert('validdata length'+validdata.length);
        if(validdata.length == 0){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Enter atleast one product\'s current stock and price." , 
                "type": "error"
            });
            toastEvent.fire();
            return;
        }
        
        if(ContactInputs){            
            //var ProductWrapper = component.get("v.ProductWrapper");            
            if (confirm('Are you sure you want to create new location for '+validdata.length+' product?'+'\n\n Note: Empty(0) stock products will not be included in the new location -> Is it OK?')) {
                // Save it!
                component.set("v.spinner",true);
                component.set("v.ProductWrapper.VPList",validdata);
                helper.saveProduct(component, event, helper);
            } else {
                // Do nothing!
                return;
            }
            
        }
    },    
    cancel : function(component,event,helper){
        $A.get('e.force:refreshView').fire(); 
    },
    checkAlreadyLocationExists: function(component, event, helper) {
        var LocationName = component.find("productsLocationInput").get("v.value");
        if(LocationName != null || LocationName != ''){
            component.find("accordion").set('v.activeSectionName', 'A');
        }
    },
    loadMoreContent:function (component, event, helper) {
       
        if(component.get('v.numberOfRecordsToDisplay') && component.get('v.numberOfRecordsOnLoadMoreClick'))
            component.set('v.numberOfRecordsToDisplay',component.get('v.numberOfRecordsToDisplay')+component.get('v.numberOfRecordsOnLoadMoreClick'));
        else
        component.set('v.numberOfRecordsToDisplay',component.get('v.numberOfRecordsToDisplay')+20);
       
        alert(component.get('v.numberOfRecordsToDisplay'));
            helper.loadMoreContent(component, event, helper);
        
       
 }
    /*removeDeletedRow: function(component, event, helper) {
        var index = event.getParam("indexVar");var AllRowsList = component.get("v.ProductWrapper.VPList");
        AllRowsList.splice(index, 1);
        component.set("v.ProductWrapper.VPList", AllRowsList);
    },*/
    
})