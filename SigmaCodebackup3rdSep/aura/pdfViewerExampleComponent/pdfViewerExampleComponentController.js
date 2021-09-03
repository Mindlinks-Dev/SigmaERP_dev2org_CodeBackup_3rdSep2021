({
    doInit : function(cmp, event, helper) {
        debugger;
        var action = cmp.get("c.getPDFContAsBase64");
        action.setParams({ currentRecordRowId : cmp.get("v.recordId") });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('inside doinit');
            var pdfData = response.getReturnValue();
            if(pdfData.indexOf('No Invoice Available') > -1 && state == "SUCCESS")
            {
                cmp.set('v.noInvoice',true);
               /* $A.get("e.force:closeQuickAction").fire();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record has been updated successfully."
                });
                toastEvent.fire();
                
                 $A.createComponent(
                   "sigmaerpdev:PreviewInvoiceWithoutWOL",{}
                    ,function(pdfViewer, status, errorMessage){
                        if (status === "SUCCESS") {
                            var pdfContainer = cmp.get("v.pdfContainer");
                            pdfContainer.push(PreviewInvoiceWithoutWOL);
                            cmp.set("v.pdfContainer", pdfContainer);
                        }
                        else if (status === "INCOMPLETE") {
                            console.log("No response from server or client is offline.")
                        }
                            else if (status === "ERROR") {
                                console.log("Error: " + errorMessage);
                            }
                    }
                );*/
                
                
            }
            // if(state == "SUCCESS") {
            else if (state === "SUCCESS" && pdfData.indexOf('No Invoice Available') == -1) {
                var pdfData = response.getReturnValue();
                //alert('No iNvoice'+pdfData);
                $A.createComponent(
                    "c:pdfViewer",
                    {
                        "pdfData": pdfData
                    },
                    function(pdfViewer, status, errorMessage){
                        if (status === "SUCCESS") {
                            var pdfContainer = cmp.get("v.pdfContainer");
                            pdfContainer.push(pdfViewer);
                            cmp.set("v.pdfContainer", pdfContainer);
                        }
                        else if (status === "INCOMPLETE") {
                            console.log("No response from server or client is offline.")
                        }
                            else if (status === "ERROR") {
                                console.log("Error: " + errorMessage);
                            }
                    }
                );
            }
                else if (state === "ERROR") {
                    alert('error 123'+errorMessage);
                }
        });
        $A.enqueueAction(action);
    }
})