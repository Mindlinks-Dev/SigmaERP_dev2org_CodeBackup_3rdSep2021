({
    DisplayFileName : function(component, event, helper) {
        
        var fileInput = component.find("file").getElement();
        //alert(fileInput);
        var file = fileInput.files[0];
        if(file){
            //alert('if')
            var fileName = 'You have selected file : ['+file.name+']';  
               /* var reader = new FileReader();
                reader.readAsText(file, "UTF-8");
                reader.onload = function (evt) {
                    var csv = evt.target.result;
                    var result = helper.CSV2JSON(component,csv);
                    window.setTimeout($A.getCallback(function(){
                        helper.checkRecord(component, event, helper,result);
                    }), 10);
                    
                    
                }*/
                //alert(fileName);
            }
        
            else{
                //alert('else')
                var fileName = 'Please select File before uploading';   
                
            }
            component.set("v.fileName", fileName);
            
        },
            Uploadfile : function(component, event, helper){
                
                var fileInput = component.find("file").getElement();
                var file = fileInput.files[0];
                //alert(file);
                if (file){
                    
                    //component.set("v.isSpinner", true); 
                    //console.log("File");
                    var reader = new FileReader();
                    reader.readAsText(file, "UTF-8");
                    reader.onload = function (evt) {
                        
                        //console.log("EVT FN");
                        var csv = evt.target.result;
                        //console.log('csv file contains'+ csv);
                        var result = helper.CSV2JSON(component,csv);
                        let button = event.getSource();
                        button.set('v.disabled',true);
                        window.setTimeout($A.getCallback(function(){
                            helper.UpdateRecord(component, event, helper,result);
                        }), 10);
                        
                        
                    }
                }  
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Select File!",
                        "message": "Select File to upload stock."
                    });
                    toastEvent.fire(); 
                    
                }
            }
        
    })