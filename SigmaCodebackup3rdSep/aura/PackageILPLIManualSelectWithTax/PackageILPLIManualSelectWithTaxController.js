({
	doInit : function(component, event, helper) {
        // alert("doInit sigmaOrderIlpliWrapper");
		var sigmaOrderIlpliWrapper=component.get("v.sigmaOrderIlpliWrapper");
        var ilpliIndividualData=component.get("v.ilpliIndividualData");
       //alert('bool>>'+component.get('v.isMannualPicking'));
            // alert('data'+JSON.stringify(ilpliIndividualData));
        
      
        console.log("sigmaOrderIlpliWrapper"+JSON.stringify(sigmaOrderIlpliWrapper));
	},
    
})