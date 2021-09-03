({
    /*removeRow : function(component, event, helper){
        component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    },*/
    doInit : function(component, event, helper){
        var today = new Date();
        component.set('v.ProductInstance.sigmaerpdev2__Last_Updated_Date__c', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        component.set('v.ProductInstance.sigmaerpdev2__Current_Stock__c',0);
        component.set('v.ProductInstance.sigmaerpdev2__Buying_Price__c',0);
    },
    changedate : function(component, event, helper){        
        var dateDOB = event.getSource().get("v.value");
        var dobres=dateDOB.split('/'); 
        var day = dobres[0];
        var month = dobres[1];
        var year = dobres[2];
        var myDate = new Date(dateDOB);
        var today = new Date();
        if ( myDate > today ) { 
            alert('You cannot enter a date in the future');
            component.set("v.ProductInstance.sigmaerpdev2__Last_Updated_Date__c",today); 
            return false;
        }
        
    }
})