({
    doInit: function(component, event, helper) {
        var spinner = component.find("mySpinner");
       // $A.util.toggleClass(spinner, "slds-hide");
        helper.doInitHelper(component, event);
    },
 dropdown : function (component, event, helper)
    { 
       //alert('targetid'+event.currentTarget.id);
        //alert(event.target.id);
        var DropIndex = event.currentTarget.id;
        
        var dropdownContent = component.find('dropdownContent');
        $A.util.toggleClass(dropdownContent[DropIndex], 'slds-is-open');
        
    },
    SaveProductInfo: function(component, event, helper) {
        var spinner = component.find("mySpinner");
        //$A.util.toggleClass(spinner, "slds-hide");
        helper.SaveProductData(component, event);
    },
    
    /* javaScript function for pagination */
    navigation: function(component, event, helper) {
        var sObjectList = component.get("v.listOfAllAccounts");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var whichBtn = event.getSource().get("v.name");
        // check if whichBtn value is 'next' then call 'next' helper method
        if (whichBtn == 'next') {
            component.set("v.currentPage", component.get("v.currentPage") + 1);
            helper.next(component, event, sObjectList, end, start, pageSize);
        }
        // check if whichBtn value is 'previous' then call 'previous' helper method
        else if (whichBtn == 'previous') {
            component.set("v.currentPage", component.get("v.currentPage") - 1);
            helper.previous(component, event, sObjectList, end, start, pageSize);
        }
    },
 
    selectAllCheckbox: function(component, event, helper) {
        var selectedHeaderCheck = event.getSource().get("v.value");
        var updatedAllRecords = [];
        var updatedPaginationList = [];
        var listOfAllAccounts = component.get("v.listOfAllAccounts");
        var PaginationList = component.get("v.PaginationList");
        // play a for loop on all records list 
        for (var i = 0; i < listOfAllAccounts.length; i++) {
            // check if header checkbox is 'true' then update all checkbox with true and update selected records count
            // else update all records with false and set selectedCount with 0  
            if (selectedHeaderCheck == true) {
                listOfAllAccounts[i].isChecked = true;
                component.set("v.selectedCount", listOfAllAccounts.length);
            } else {
                listOfAllAccounts[i].isChecked = false;
                component.set("v.selectedCount", 0);
            }
            updatedAllRecords.push(listOfAllAccounts[i]);
        }
        // update the checkbox for 'PaginationList' based on header checbox 
        for (var i = 0; i < PaginationList.length; i++) {
            if (selectedHeaderCheck == true) {
                PaginationList[i].isChecked = true;
            } else {
                PaginationList[i].isChecked = false;
            }
            updatedPaginationList.push(PaginationList[i]);
        }
        component.set("v.listOfAllAccounts", updatedAllRecords);
        component.set("v.PaginationList", updatedPaginationList);
    },
 
    checkboxSelect: function(component, event, helper) {
        // on each checkbox selection update the selected record count 
        var selectedRec = event.getSource().get("v.value");
        var getSelectedNumber = component.get("v.selectedCount");
        if (selectedRec == true) {
            getSelectedNumber++;
        } else {
            getSelectedNumber--;
            component.find("selectAllId").set("v.value", false);
        }
        component.set("v.selectedCount", getSelectedNumber);
        // if all checkboxes are checked then set header checkbox with true   
        if (getSelectedNumber == component.get("v.totalRecordsCount")) {
            component.find("selectAllId").set("v.value", true);
        }
    },
 
    getSelectedRecords: function(component, event, helper) {
        var allRecords = component.get("v.listOfAllAccounts");
        var selectedRecords = [];
        for (var i = 0; i < allRecords.length; i++) {
            if (allRecords[i].isChecked) {
                selectedRecords.push(allRecords[i].objAccount);
            }
        }
        alert(JSON.stringify(selectedRecords));
    },
    
     AddNewProduct: function(component, event, helper) {
         
         var action = component.get("c.getPicklistValues");
         action.setCallback(this, function(response) {
             var state = response.getState();
             if (state === "SUCCESS"){
             component.set("v.PickmapList",response.getReturnValue().PicklistWraps);
                 //component.set("v.IndividualObject.AttributeType",response.getReturnValue().PicklistWraps[0].PicklistAPI);
             component.set("v.UOMPickmapList",response.getReturnValue().PicklistWrapss);
             component.set("v.TypePickmapList",response.getReturnValue().PicklistWrapsss);
             }
            
         });
         $A.enqueueAction(action);
         var CurrentRowToEdit = component.get('v.IndividualObject');
         //component.set('v.IndividualObject',null);
         var tempmap = new Map();
         component.set('v.IndividualObject',tempmap);
         component.set("v.isOpen",true);
         
         //component.set('v.IndividualObject',CurrentRowToEdit);
          
    },
    
    CreateNewCatalog: function(component, event, helper) {
         component.set("v.isCatalog",true);  
    },
    SaveCatalogDetails: function(component, event, helper) {
        helper.CreateCatalogwithVendor(component, event); 
    },
      EditProd: function(component, event, helper) {
          var rowIndex = event.currentTarget.id;  
          var AllProductList = component.get('v.PaginationList');
          var CurrentRowToEdit = AllProductList[rowIndex];
          component.set('v.IndividualObject',CurrentRowToEdit); 
          component.set("v.isEdit",true);   
    },
    
    DeleteProd : function(component, event, helper) {
         //alert('Inside edit Product ::');
          //
          
          var rowIndex = event.currentTarget.id;
          var AllProductList = component.get('v.PaginationList');
          var CurrentRowToEdit = AllProductList[rowIndex];
        var Prodid = CurrentRowToEdit.productId;
          component.set('v.IndividualObject',CurrentRowToEdit); 
         //alert('CurrentRowToEdit::'+CurrentRowToEdit +'<>'+JSON.stringify(component.get('v.IndividualObject')));
           
         var action = component.get("c.DeleteProductsapex");
         action.setParams({
            "ProdIDs" : Prodid
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
             if (state === "SUCCESS"){
             var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"success",
                            "title": "Success!",
                            "message": "Product record Deleted successfully!"
                        });
                        toastEvent.fire();
                 $A.get('e.force:refreshView').fire();
             }
            else
            {
                var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"Error",
                            "title": "Error!",
                            "message": "Error Occured during Product deletion, please contact your Admin!"
                        });
                        toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
     closeModal:function(component, event, helper){
        var NewProd = component.get("v.isOpen");
        var EditProd = component.get("v.isEdit");
          var NewCatalog = component.get("v.isCatalog");
        
        component.set('v.isOpen',false);
         component.set('v.isEdit',false);
         component.set('v.isCatalog',false);
         component.set('v.IndividualObject',"{'productId':'','productName':''}");
         
    },
    closeCatalogModal:function(component, event, helper){
         component.set('v.isCatalog',false);
         component.set('v.CatalogObjectMap','');
    },
    handleFilesChange: function(component, event, helper) {
        helper.DisplayFileName(component, event, helper);
    } ,
    getproductimagedata: function (component, event, helper,Ind) {
       /* var rowIndex = event.getSource().get("v.name"); 
          var AllProductList = component.get('v.PaginationList');
          var CurrentRowToEdit = AllProductList[rowIndex];*/
        var productId = event.getSource().get("v.name");
        var action = component.get("c.getproductimage");
        action.setParams({
            "prodId": productId,
        });
        
        action.setCallback(this, function (a) {
            var state = a.getState();
           // alert('state::'+state);
            if (state == "SUCCESS") {
                var productimage=a.getReturnValue();
               
                component.set('v.ProductImageData',productimage.ProdImage);
                component.set('v.CommunityURL',productimage.CommunityURL);
                component.set('v.productimageexist',true);
               // alert('dataaaa'+JSON.stringify(component.get('v.ProductImageData')));
                
            }
            else
            {
                component.set('v.productimageexist',false);
            }
             component.set('v.ProductView',true);
        });
        $A.enqueueAction(action);
    },
     pageChange: function(component, event, helper) {
        
        var spinner = component.find("mySpinner");
        var page = component.get("v.page") || 1;
        var direction = event.getParam("direction");
        page = direction === "previous" ? (page - 1) : (page + 1);
        helper.getProdList(component, event, helper,page);
    },
    accordionProductInventory : function(component, event, helper) {
        
       /* var chevronrightProductInventory = component.find('chevronrightProductInventory');
        $A.util.toggleClass(chevronrightProductInventory, 'slds-hide');
        
        var chevrondownProductInventory = component.find('chevrondownProductInventory');
        $A.util.toggleClass(chevrondownProductInventory, 'slds-hide');
        
        var ProductInventoryBody = component.find('ProductInventoryBody');
        $A.util.toggleClass(ProductInventoryBody, 'slds-hide');*/
        
        
        var rowIndex = event.currentTarget.id;
         var ProductInventoryBody = component.find('ProdInvdata');
        $A.util.toggleClass(ProductInventoryBody[rowIndex], 'slds-hide');
        
        /*var AllProductList = component.get('v.PaginationList');
          var CurrentRowToEdit = AllProductList[rowIndex];
        var Prodid = CurrentRowToEdit.productId;
        */
        
        
        
       /* var action = component.get("c.InvDetails");
        action.setParams({ ProductId : Prodid });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS"){
                //alert('Inside success resonse>>');
                var InvDetails = response.getReturnValue();
                 component.set('v.prodInvList',InvDetails);
                
                
            }
            else{
                
                alert('Error...');
            }
        });
        
        
        
         $A.enqueueAction(action);*/
    },
    clearcurrency: function (component, event, helper)
    {
        if(component.get('v.currencyname') == '')
        {
            
        }
    },
})