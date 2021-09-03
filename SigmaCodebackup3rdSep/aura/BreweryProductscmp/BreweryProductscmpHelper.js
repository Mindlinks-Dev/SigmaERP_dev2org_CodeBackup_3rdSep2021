({
    /* doInitHelper funcation to fetch all records, and set attributes value on component load */
    doInitHelper : function(component,event,page){ 
        page = page || 1;
        var action = component.get("c.GetProductWrapper");
        action.setParams({ pageNumber : page });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                //alert('Inside success resonse>>');
                var oRes = response.getReturnValue();
                if(oRes.ProductListWrap.length > 0){
                    component.set('v.listOfAllAccounts', oRes.ProductListWrap);
                    
                    var pageSize = component.get("v.pageSize");
                    var totalRecordsList = oRes;
                    var totalLength = totalRecordsList.length ;
                    //alert('total recods>>'+totalLength);
                    component.set('v.total', oRes.totalSigma);
                component.set('v.page', oRes.pageSigma);
                component.set('v.pages', Math.ceil(oRes.totalSigma/oRes.pageSizeSigma));
                    var spinner = component.find("mySpinner");
                    // $A.util.toggleClass(spinner, "slds-hide");
                    var PaginationLst = [];
                    for(var i=0; i < oRes.pageSizeSigma; i++){
                        if(component.get("v.listOfAllAccounts").length > i){
                            
                            PaginationLst.push(oRes.ProductListWrap[i]); 
                            
                        } 
                    }
                    component.set('v.PaginationList', PaginationLst);
                    component.set("v.selectedCount" , 0);
                    //use Math.ceil() to Round a number upward to its nearest integer
                    component.set("v.totalPagesCount", Math.ceil(totalLength / pageSize));    
                }else{
                    
                    // if there is no records then display message
                    component.set("v.bNoRecordsFound" , true);
                    //$A.util.toggleClass(spinner, "slds-hide");
                } 
            }
            else{
                //$A.util.toggleClass(spinner, "slds-hide");
                alert('Error Occured while creating the record, Please Contact your Administrator');
            }
        });
        $A.enqueueAction(action);  
    },
    
    SaveProductData : function(component,event){
        
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        var file1 = fileInput.Count;
        var NewProd = component.get("v.isOpen");
        var EditProd = component.get("v.isEdit");
        var ProdName = component.get("v.IndividualObject.productName");
        
        if(ProdName == undefined || ProdName == '')
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type" : "error",
                "title": "ERROR!",
                "message": "Please Enter Product Name"
            });
            
            toastEvent.fire();
            return;
        }
        if(NewProd && file == undefined)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type" : "error",
                "title": "ERROR!",
                "message": "Please Select the Product Image before uploading"
            });
            toastEvent.fire();
            return;
        }
        if(file == undefined)
        {
            var ProdData = component.get("v.IndividualObject");
           
            if(ProdData.ProductPrice == null ||  ProdData.ProductPrice =='' || ProdData.ProductPrice == 'undefined')
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"Error",
                    "title": "Error!",
                    "message": "Please Enter Product Price!"
                });
                toastEvent.fire(); 
                return;
            }
            //confirm('Please Click on Ok to continue');
            if(confirm('Please Click on Ok to continue'))
            {
                var spinner = component.find("mySpinner");
       			$A.util.removeClass(spinner, "slds-hide");
                var action = component.get("c.SaveProducts");
                action.setParams({
                    "ProductDetails" : JSON.stringify(ProdData),
                    "NewProds" : NewProd,
                    "Editprods" : EditProd,
                    "base64Data" : null,
                    "fileName": '',
                    "contentType": ''
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS"){
                        if(NewProd)
                        {
                            
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "type":"success",
                                "title": "Success!",
                                "message": "Product record is created successfully!"
                            });
                            toastEvent.fire();
                            $A.util.addClass(spinner, "slds-hide");
                            $A.get('e.force:refreshView').fire();
                        }
                        else if(EditProd)
                        {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "type":"success",
                                "title": "Success!",
                                "message": "Product record is updated successfully!"
                            });
                            toastEvent.fire();
                            $A.util.addClass(spinner, "slds-hide");
                            $A.get('e.force:refreshView').fire();
                        }
                    }
                    else{
                        
                        if(NewProd)
                        {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "type":"error",
                                "title": "error!",
                                "message":"  Product record is not created!"
                            });
                            
                            toastEvent.fire();
                            $A.util.addClass(spinner, "slds-hide");
                        }
                        else if(EditProd)
                        {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "type":"error",
                                "title": "error!",
                                "message":"  Product record is not Updated!"
                            });
                            toastEvent.fire();
                            $A.util.addClass(spinner, "slds-hide");
                        }
                    }
                });
                component.set('v.isOpen',false);
                component.set('v.isEdit',false);
                $A.enqueueAction(action); 
            }
            else
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "error!",
                    "message":"  Product record is not Updated!"
                });
                toastEvent.fire();
            }
            
        }
        else
        {
            var fr = new FileReader();
            var self = this;
            fr.onload = function()
            {
                var fileContents = fr.result;
                var filetest=fileContents.size;
                var base64Mark = 'base64,';
                var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                
                fileContents = fileContents.substring(dataStart);
                //self.upload(component, file, fileContents); 
                
                var ProdData = component.get("v.IndividualObject");
                if(ProdData.ProductPrice == null ||  ProdData.ProductPrice =='' || ProdData.ProductPrice == 'undefined')
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"Error",
                        "title": "Error!",
                        "message": "Please Enter Product Price!"
                    });
                    toastEvent.fire(); 
                    return;
                }
                
                if(confirm('Please Click on Ok to continue'))
                {
                    var spinner = component.find("mySpinner");
       				$A.util.removeClass(spinner, "slds-hide");
                    var action = component.get("c.SaveProducts");
                    action.setParams({
                        "ProductDetails" : JSON.stringify(ProdData),
                        "NewProds" : NewProd,
                        "Editprods" : EditProd,
                        "base64Data" : encodeURIComponent(fileContents),
                        "fileName": file.name,
                        "contentType": file.type
                    });
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS"){
                            if(NewProd)
                            {
                                
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "type":"success",
                                    "title": "Success!",
                                    "message": "Product record created successfully!"
                                });
                                toastEvent.fire();
                                $A.util.addClass(spinner, "slds-hide");
                                $A.get('e.force:refreshView').fire();
                            }
                            else if(EditProd)
                            {
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "type":"success",
                                    "title": "Success!",
                                    "message": "Product record Updated successfully!"
                                });
                                toastEvent.fire();
                                $A.util.addClass(spinner, "slds-hide");
                                $A.get('e.force:refreshView').fire();
                            }
                        }
                        else{
                            
                            if(NewProd)
                            {
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "type":"error",
                                    "title": "error!",
                                    "message":"  Product record is not created!"
                                });
                                toastEvent.fire();
                                $A.util.addClass(spinner, "slds-hide");
                            }
                            else if(EditProd)
                            {
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "type":"error",
                                    "title": "error!",
                                    "message":"  Product record is not Updated!"
                                });
                                toastEvent.fire();
                                $A.util.addClass(spinner, "slds-hide");
                            }
                        }
                    });
                    component.set('v.isOpen',false);
                    component.set('v.isEdit',false);
                    $A.enqueueAction(action);
                }
                else
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "error!",
                        "message":"  Product record is not Created!"
                    });
                    toastEvent.fire();
                }
            }; 
            
            fr.readAsDataURL(file);
        } 
    },
    upload : function(component,file, fileContents){
        var ProdData = component.get("v.IndividualObject");
        var NewProd = component.get("v.isOpen");
        var EditProd = component.get("v.isEdit");
        
    },
    // navigate to next pagination record set   
    next : function(component,event,sObjectList,end,start,pageSize){
        var Paginationlist = [];
        var counter = 0;
        for(var i = end + 1; i < end + pageSize + 1; i++){
            if(sObjectList.length > i){ 
                if(component.find("selectAllId").get("v.value")){
                    Paginationlist.push(sObjectList[i]);
                }else{
                    Paginationlist.push(sObjectList[i]);  
                }
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
    },
    // navigate to previous pagination record set   
    previous : function(component,event,sObjectList,end,start,pageSize){
        var Paginationlist = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                if(component.find("selectAllId").get("v.value")){
                    Paginationlist.push(sObjectList[i]);
                }else{
                    Paginationlist.push(sObjectList[i]); 
                }
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
    },
    DisplayFileName : function(component, event, helper) {
       var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        if(file)
            var fileName = 'You have selected file : ['+file.name+']';
        else
            var fileName = 'Please select File before uploading';   
        component.set("v.fileName", fileName);
    },
    CreateCatalogwithVendor: function(component, event) {
        var CatalogData = component.get('v.CatalogObjectMap');
        var action = component.get("c.createCatalog");
                    action.setParams({
                        "CatalogData" : JSON.stringify(CatalogData)
                    });
        action.setCallback(this, function(response) {
            var ReturnVal = response.getReturnValue();
                        if (ReturnVal.Status === "SUCCESS"){
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "type":"success",
                                    "title": "Success!",
                                    "message": ReturnVal.ErrorMessage
                                });
                                toastEvent.fire();
                                $A.get('e.force:refreshView').fire();
                        }
            else if(ReturnVal.Status === "ERROR")
            {
                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "type":"ERROR",
                                    "title": "ERROR!",
                                    "message": ReturnVal.ErrorMessage
                                });
                                toastEvent.fire();
                                $A.get('e.force:refreshView').fire();
            }
            
        });
          $A.enqueueAction(action);
    },
    getProdList : function(component, event, helper,page) 
    {
        page = page || 1;
        var action = component.get("c.GetProductWrapper");
        action.setParams({ pageNumber : page });
        action.setCallback(this, function(response) {
            var state = response.getState();
             
            if (state === "SUCCESS") {
                var oRes = response.getReturnValue();
                 if(oRes.ProductListWrap.length > 0){
                    component.set('v.listOfAllAccounts', oRes.ProductListWrap);
                    component.set('v.total', oRes.totalSigma);
                	component.set('v.page', oRes.pageSigma);
                	component.set('v.pages', Math.ceil(oRes.totalSigma/oRes.pageSizeSigma));
                     var spinner = component.find("mySpinner");
                    // $A.util.toggleClass(spinner, "slds-hide");
                    var PaginationLst = [];
                    for(var i=0; i < oRes.pageSizeSigma; i++){
                        if(component.get("v.listOfAllAccounts").length > i){
                            PaginationLst.push(oRes.ProductListWrap[i]);    
                        } 
                    }
                     
                    component.set('v.PaginationList', PaginationLst);
                     
                 }
            }
            else if (state === "INCOMPLETE") {
               component.set("v.bNoRecordsFound" , true);
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
})