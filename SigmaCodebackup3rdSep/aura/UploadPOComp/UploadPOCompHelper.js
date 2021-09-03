({
	 MAX_FILE_SIZE: 750000, 
    
    save : function(component) {
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        var file1 = fileInput.Count;
      //  alert(file);
        if(file === undefined)
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
        //var fr2 = new FileReader();
        
        var self = this;
        fr.onload = function()
        {
            var fileContents = fr.result;
            var filetest=fileContents.size;
            var base64Mark = 'base64,';
            // alert('filetest>>>>>'+fileContents.indexOf(base64Mark));
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            fileContents = fileContents.substring(dataStart);
            //alert(fileContents);
            self.upload(component, file, fileContents);  
        };
        fr.readAsDataURL(file);
    },
    upload: function(cmp, file, fileContents) {
        var spinner = cmp.find("spinner");
        $A.util.toggleClass(spinner, "slds-hide"); 
        var action = cmp.get("c.UploadPO");
        action.setParams(
            { 
                fileName: file.name,
                base64Data: encodeURIComponent(fileContents), 
                contentType: file.type
            });
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                             //  alert(state);
                            //alert(JSON.stringify(response.getReturnValue()));
                               if(state == "SUCCESS")
                               {   
                                   var toastEvent = $A.get("e.force:showToast");
                                   var cmpTarget = cmp.find('errorBtn');
                                   var badge = cmp.find('badge');
                                   //new code
                                  // alert('response.getReturnValue() '+JSON.stringify(response.getReturnValue()))
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
})