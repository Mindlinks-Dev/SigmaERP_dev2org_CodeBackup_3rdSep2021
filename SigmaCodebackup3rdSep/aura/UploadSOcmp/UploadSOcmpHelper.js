({
    
    MAX_FILE_SIZE: 750000,
    save : function(component) {
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        var file1 = fileInput.Count;
        if(file == undefined)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type" : "error",
                "title": "ERROR!",
                "message": "Please Select the file before uploading"
            });
            toastEvent.fire();
            return;
        }
        if (file.size > this.MAX_FILE_SIZE) 
        {
            alert('File size cannot exceed ' + this.MAX_FILE_SIZE + ' bytes.\n' +
                  'Selected file size: ' + file.size);
            return;
        }
        var fr = new FileReader();
        var self = this;
        fr.onload = function()
        {
            var fileContents = fr.result;
            var filetest=fileContents.size;
            var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            fileContents = fileContents.substring(dataStart);
            self.upload(component, file, fileContents);  
        };
        fr.readAsDataURL(file);
    },
    upload: function(cmp, file, fileContents) {
        var spinner = cmp.find("spinner");
        $A.util.toggleClass(spinner, "slds-hide"); 
        var action = cmp.get("c.UploadSO");
        action.setParams(
            { 
                fileName: file.name,
                base64Data: encodeURIComponent(fileContents), 
                contentType: file.type
            });
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                               if(state == "SUCCESS")
                               {   
                                   var toastEvent = $A.get("e.force:showToast");
                                   var cmpTarget = cmp.find('errorBtn');
                                   var badge = cmp.find('badge');
                                   if(response.getReturnValue().Status == 'Success')
                                   {        
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type" : "Success",
                                           "title": "Success!",
                                           "message": "File Uploaded Successfully"
                                       });
                                       toastEvent.fire();
                                       $A.util.toggleClass(spinner, "slds-hide");
                                   }
                                   else if(response.getReturnValue().Status == 'Error')
                                   {   
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "type" : "error",
                                           "title": "ERROR!",
                                           "message": response.getReturnValue().errorMessage
                                       });
                                       toastEvent.fire();
                                       $A.util.toggleClass(spinner, "slds-hide");
                                       return;
                                   }
                               }   
                           });
        window.setTimeout(
            $A.getCallback(function() {
                $A.enqueueAction(action);
            }), 1000
        );
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
    POHelper: function(component) {
        var fileInput1 = component.find("file").getElement();
        var file1 = fileInput1.files[0];
        var file11 = fileInput1.Count;
        
        if (file1.size > this.MAX_FILE_SIZE) 
        {
            alert('File size cannot exceed ' + this.MAX_FILE_SIZE + ' bytes.\n' +
                  'Selected file size: ' + file1.size);
            return;
        }
        
        var fr1 = new FileReader();
        var self = this;
        fr1.onload = function()
        {
            var fileContents = fr1.result;
            var filetest=fileContents.size;
            var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            fileContents = fileContents.substring(dataStart);
            self.uploadPO(component, file1, fileContents);
            
        };
        
        fr1.readAsDataURL(file1);
    },
    uploadPO: function(cmp, file1, fileContents) {
        
        var userId = $A.get( "$SObjectType.CurrentUser.Id" );
        var spinner = cmp.find("spinner");
        $A.util.toggleClass(spinner, "slds-hide"); 
        var action = cmp.get("c.SavePOdetails");
        action.setParams(
            { 
                VUDId : cmp.get("v.VaId"),
                ProductVartical:cmp.get("v.RetailNamesNProdVertical.ProdVertical"),
                UserId:userId,
                ShowError : false
                
            });
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState(); 
                               var toastEvent = $A.get("e.force:showToast");
                               var cmpTarget = cmp.find('errorBtn');
                               var badge = cmp.find('badge');
                               var returnValue=response.getReturnValue();
                               if(state == "SUCCESS")
                               {
                                   cmp.set("v.Next",false);
                                   if(returnValue.Status=="OK")
                                   {
                                       cmp.set("v.Next",false);
                                       cmp.set("v.Success",true);
                                       $A.util.toggleClass(spinner, "slds-hide");
                                       console.log(response.getReturnValue()); 
                                   }
                                   else
                                   {
                                       var message = returnValue.errorMessage;
                                       if(returnValue.rowNumber!=null)
                                           message += ' at line number '+returnValue.rowNumber;
                                       if(returnValue.colName!=null)
                                           message += ' and column '+returnValue.colName;
                                       
                                       $A.util.addClass(cmpTarget, 'slds-hide');
                                       $A.util.removeClass(badge, 'slds-hide');
                                       toastEvent.setParams({
                                           "type":"error",
                                           "title": "Error",
                                           "message": message
                                       } );
                                       toastEvent.fire();   
                                       $A.util.toggleClass(spinner, "slds-hide");
                                       console.log(response.getReturnValue());
                                   }
                                   
                                   
                                   
                               }
                               else if(returnValue === "Incomplete")
                               {
                                   cmp.set("v.Next",false);
                                   $A.util.addClass(cmpTarget, 'slds-hide');
                                   $A.util.removeClass(badge, 'slds-hide');
                                   toastEvent.setParams({
                                       "type":"warning",
                                       "title": "Data uploaded partially Check your Mail For Error Records",
                                       "message": "Records are Uploaded Partially."
                                   } );
                                   toastEvent.fire();   
                                   $A.util.toggleClass(spinner, "slds-hide");
                                   console.log(response.getReturnValue());
                               }
                                   else if(returnValue === "Error")
                                   {
                                       cmp.set("v.Next",false);
                                       $A.util.addClass(cmpTarget, 'slds-hide');
                                       $A.util.removeClass(badge, 'slds-hide');
                                       toastEvent.setParams({
                                           "type":"error",
                                           "title": "Error",
                                           "message": "Records are Not Uploaded."
                                       } );
                                       toastEvent.fire();   
                                       $A.util.toggleClass(spinner, "slds-hide");
                                       console.log(response.getReturnValue());
                                   }     
                           });
        window.setTimeout(
            $A.getCallback(function() {
                $A.enqueueAction(action);
            }), 1000
        );
    },  
    CancelUpload: function(component, event, helper) {
        var userId = $A.get( "$SObjectType.CurrentUser.Id" );
        var spinner = component.find("spinner");
        $A.util.toggleClass(spinner, "slds-hide"); 
        var action = component.get("c.cancelUpload");
        action.setParams(
            { 
                VId : component.get("v.VaId"),    
            });
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState(); 
                               var toastEvent = $A.get("e.force:showToast");
                               var cmpTarget = component.find('errorBtn');
                               var badge = component.find('badge');
                               var returnValue=response.getReturnValue();
                               if(state == "SUCCESS")
                               {
                                   if(returnValue)
                                   {
                                       toastEvent.setParams({
                                           "type":"warning",
                                           "title": "Warning",
                                           "message": "File uploading is cancelled.Please Re-upload the file"
                                       } );
                                       toastEvent.fire();   
                                       $A.util.toggleClass(spinner, "slds-hide");
                                       console.log(response.getReturnValue()); 
                                   }   
                               }
                               
                           });
        $A.enqueueAction(action);
    }, 
    
})