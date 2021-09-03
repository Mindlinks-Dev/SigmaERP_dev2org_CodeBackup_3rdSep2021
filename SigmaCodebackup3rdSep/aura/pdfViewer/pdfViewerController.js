({
    doInit :function(component,event,helper){
     helper.RetrievecommmunityURL1(component,event); 
    },  
	loadpdf : function(component, event, helper) {
        
        setTimeout(function(){
            helper.loadpdf(component,event);    
        }, 3000);
		
	}
})