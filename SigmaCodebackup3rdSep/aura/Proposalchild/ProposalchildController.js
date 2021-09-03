({
    doInit: function (component, event, helper)
    {
        
        if( (typeof sforce != 'undefined') && (sforce != null) ) {
        
           component.set("v.LightView",true);
        } 
      
        else {
        
           component.set("v.LightView",false);
        }
    },
	openRecords : function(component, event, helper){
        var PropList =  component.get("v.PropList.Id");
       
        // Lightning Navigation
        if( (typeof sforce != 'undefined') && (sforce != null) ) {
          
            sforce.one.navigateToSObject(PropList, 'detail');
        } 
        // classic Navigation
        else {
          
            window.location.href = "/"+PropList;
        }
    },
    changestatus : function(component, event, helper){
        //alert('changestatus');
         var PropList =  component.get("v.PropList.Id");
         var action = component.get("c.UpdateStatus");
        action.setParams({PropList:PropList});
        action.setCallback(this,function(a){
            var state = a.getState();
          var proposal = a.getReturnValue();
           // alert('value>'+JSON.stringify(proposal));
           // return;
            // alert(state);
            if(state == 'SUCCESS'){
                if(proposal.sigmaerpdev2__Is_Order_Created__c)
                {
                    alert('Cannot cancel the Proposal Once Order is Created');
                }
                else
                {
                    alert('Proposal Cancelled successfully');
                }
                
            }else{
               alert('error'); 
            }
            
        });
        $A.enqueueAction(action);
    
    },
    XLSdownload : function(component, event, helper){
        var PropList =  component.get("v.PropList.Id");
       // alert('PropList>>>>'+PropList);
        var url = '/apex/sigmaerpdev2__GenerateProposalXLS?ListId='+PropList;
        window.open(url);
    },
    PDFDownload : function(component, event, helper){
        var PropList =  component.get("v.PropList.Id");
       // alert('PropList>>>>'+PropList);
        var url = '/apex/sigmaerpdev2__GeneratePropPDFlight?ListId='+PropList;
        window.open(url);
    },
    PropEdit : function(component, event, helper){
        var PropId =  component.get("v.PropList.Id");
        //alert('PropId>>>>>>>>>>>>'+PropId);
        component.set("v.RecordId",PropId);
        //alert(component.get("v.RecordId"));
        var PropType = component.get("v.PropList.sigmaerpdev2__Usage_Type__c");
        var PropStatus = component.get("v.PropList.sigmaerpdev2__Status__c");
        if(PropType != null || PropType != undefined){
            if( PropStatus != 'Signed'){
                if(PropType == 'Product'){
                    component.set("v.ProdEditFlag",true);
                    component.set("v.MainFlag",false);
                }else{
                    component.set("v.ServEditFlag",true);
                    component.set("v.MainFlag",false); 
                }   
            }
            else{
                alert('Proposal is signed, Cannot Edit');
              component.set("v.MainFlag",true);
              component.set("v.ProdEditFlag",false);
              component.set("v.ServEditFlag",false);
               
            }
          
        }
        
        
        
       
        //alert(component.get("v.EditFlag")+'in child>>');
        //alert(component.get("v.MainFlag")+'in child>>');
         
    }
})