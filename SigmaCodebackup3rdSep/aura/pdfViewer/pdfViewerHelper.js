({
    RetrievecommmunityURL1 : function(component,event){
        var action = component.get('c.RetrievecommmunityURL');
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS") {
                var value = response.getReturnValue();
                component.set("v.DomainName", value);
            }
            else if (state === "ERROR") {
                alert('error');
            }
        });
        $A.enqueueAction(action);
    },
    
    
    loadpdf:function(component,event){
        try{
            
            var DomainName1 = component.get('v.DomainName');
            // alert(DomainName1);
            var pdfData = component.get('v.pdfData');
            var pdfjsframe = component.find('pdfFrame')
            if(typeof pdfData != 'undefined'){
                //pdfjsframe.getElement().contentWindow.postMessage(pdfData,'*');	
                pdfjsframe.getElement().contentWindow.postMessage(pdfData,DomainName1);
            }
        }catch(e){
            alert('Error: ' + e.message);
        }
    }
})