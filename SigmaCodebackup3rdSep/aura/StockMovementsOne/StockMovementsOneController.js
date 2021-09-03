({
     doInit  : function(component, event, helper){
      //  $A.get('e.force:refreshView').fire();    
    }, 
    goBack : function(component, event) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/lightning/n/sigmaerpdev2__Stock_Management_Modules"
        });        
        urlEvent.fire(); 
        // $A.get("e.force:closeQuickAction").fire(); 
    },
    SelectedID  : function(component, event, helper){
       //	alert('in');
        var context = event.getParam("instanceId");
        var objectId = event.getParam("sObjectId");
        var VendorId = event.getParam("VendersObjectId");  
        var SelId = event.getParam("sObjectId");
        var  objectLabel = event.getParam("objectLabel");        
        if(context === 'FromLocation')
        {
            component.set("v.FromLocId",SelId);
            //component.set("v.binId",'');
           /* var binId= component.get("v.binId");
            alert('binId'+JSON.stringify(binId));
            if(binId!=null && JSON.stringify(binId)!="" )
            helper.fetchILPdata(component, event, helper);   */       
        }
        if(context === 'From Location')
        {
            component.set("v.FormLocId",SelId);  
        }
        if(context === 'ilpName')
        {
            component.set("v.ilpId",SelId);  
        }        
    },
    SelectedID  : function(component, event, helper){
       //	alert('in');
        var context = event.getParam("instanceId");
        var objectId = event.getParam("sObjectId");
        var VendorId = event.getParam("VendersObjectId");  
        var SelId = event.getParam("sObjectId");
        var  objectLabel = event.getParam("objectLabel");        
        if(context === 'FromLocation')
        {
            component.set("v.FromLocId",SelId);
          //  component.set("v.binId",'');
           /* var binId= component.get("v.binId");
            alert('binId'+JSON.stringify(binId));
            if(binId!=null && JSON.stringify(binId)!="" )
            helper.fetchILPdata(component, event, helper);   */       
        }
        if(context === 'From Location')
        {
            component.set("v.FormLocId",SelId);  
        }
        if(context === 'ilpName')
        {
            component.set("v.ilpId",SelId);  
        }        
    },
    
  
    SaveStockMovement :function(component, event, helper)
    {
        var ILPlist = component.get("v.ILPlist");
        var searchStr = component.get("v.searchString");
       
        var frmloc=component.get("v.recID");
        var binId = component.get("v.binId");   
        if(frmloc==undefined || frmloc=='')
        {
 			component.set("v.isError",true); 
            component.set("v.errorMsg","Enter From Location."); 
            return;             
        }
        if( binId ==undefined || binId =='')
        {
            component.set("v.isError",true); 
            component.set("v.errorMsg","Please select  bin"); 
            return; 
        }
        
        if(ILPlist.length==0)
        {
            component.set("v.isError",true); 
            component.set("v.errorMsg","No Record Found."); 
            return; 
        }     
       console.log("ILPlist>>>>>>"+JSON.stringify(ILPlist));
        
		var  iaAlltrue=true;
         for(var i=0; i<ILPlist.length;i++)
        {
            for(var j=0;j<ILPlist[i].IlpliList.length;j++)
            {
                if(Number(ILPlist[i].IlpliList[j].sigmaerpdev2__bucket_field__c)!= null && Number(ILPlist[i].IlpliList[j].sigmaerpdev2__bucket_field__c)!= undefined && JSON.stringify(Number(ILPlist[i].IlpliList[j].sigmaerpdev2__bucket_field__c))!='""' && Number(ILPlist[i].IlpliList[j].sigmaerpdev2__bucket_field__c)>0)
				{
					if(ILPlist[i].IlpliList[j].sigmaerpdev2__ILid__c!= null && ILPlist[i].IlpliList[j].sigmaerpdev2__ILid__c!= undefined && JSON.stringify(ILPlist[i].IlpliList[j].sigmaerpdev2__ILid__c)!='""')
					{
						if(ILPlist[i].IlpliList[j].sigmaerpdev2__Bin__c!= null && ILPlist[i].IlpliList[j].sigmaerpdev2__Bin__c!= undefined && JSON.stringify(ILPlist[i].IlpliList[j].sigmaerpdev2__Bin__c)!='""')
						{
							iaAlltrue = false;
						}
						else{
					component.set("v.isError",true); 
				component.set("v.errorMsg",'Please Select Destination Bin  to move the Stock '+'Product '+ILPlist[i].ProName+' in '+ILPlist[i].IlpliList[j].Name);
				return;
							
						}
					}
					else
					{
				component.set("v.isError",true); 
                        component.set("v.errorMsg",'Please Select Destination  Location to move the Stock '+'Product '+ILPlist[i].ProName+' in '+ILPlist[i].IlpliList[j].Name);
				return;
					}
				}
			}
        }
		if(iaAlltrue===true){
			component.set("v.isError",true); component.set("v.errorMsg",'Please Enter  Pick Qty For  Any Product  to move the products');
        //component.set("v.errorMsg",'Please Enter Any Product Pick Qty to move the products');
        return;
		}
        

       
        var toSave=false;
        
        for(var i=0; i<ILPlist.length;i++)
        {
            for(var j=0;j<ILPlist[i].IlpliList.length;j++)
            {
               console.log(ILPlist[i].IlpliList[j].sigmaerpdev2__ILid__c+'='+ILPlist[i].IlpliList[j].sigmaerpdev2__Bin__c+'='+ Number(ILPlist[i].IlpliList[j].sigmaerpdev2__bucket_field__c));
               if(ILPlist[i].IlpliList[j].sigmaerpdev2__ILid__c != undefined && ILPlist[i].IlpliList[j].sigmaerpdev2__Bin__c != undefined && Number(ILPlist[i].IlpliList[j].sigmaerpdev2__bucket_field__c)> 0)
                toSave=true; 
            }
        }
    
        if(toSave==false){
        component.set("v.isError",true); 
        component.set("v.errorMsg",'Please Enter Atleast One  Product Pick Qty to move the Stock.');
        return;
        }
       
        
       //  return;
        var FromLocId = component.get("v.FromLocId");
        for(var i=0; i<ILPlist.length;i++){
           // alert('ILP');
            for(var j=0;j<ILPlist[i].IlpliList.length;j++){
               // alert('ILPLI'+JSON.stringify(ILPlist[i].IlpliList));
                if(ILPlist[i].IlpliList[j].sigmaerpdev2__bucket_field__c > ILPlist[i].IlpliList[j].sigmaerpdev2__Available_Quantity__c ){
                    component.set("v.isError",true); 
                    component.set("v.errorMsg",'Pick Qty should be less than or equal to Available Qty for product '+ILPlist[i].ProName);
                    return;
                }
                else if(ILPlist[i].IlpliList[j].sigmaerpdev2__bucket_field__c < 0){
                    component.set("v.isError",true); 
                    component.set("v.errorMsg",'Quantity should be positive. Please Enter valid Quantity.');
                    return;  
                }
                
                /*   else if((ILPlist[i].IlpliList[j].sigmaerpdev2__bucket_field__c % 1) != 0){
                    component.set("v.isError",true); 
                    component.set("v.errorMsg",'Please enter valid quantity.');
                    return;  
                }
                  
                
                    else if(FromLocId === ILPlist[i].IlpliList[j].sigmaerpdev2__ILid__c){
                        component.set("v.isError",true); 
                        component.set("v.errorMsg",'At '+ILPlist[i].IlpliList[j].Name+' for product '+ILPlist[i].ProName+', from & to locations should not be same.');
                        return;
                    }*/
                        //alert(ILPlist[i].IlpliList[j].sigmaerpdev2__Bin__c);
                        else if(binId === ILPlist[i].IlpliList[j].sigmaerpdev2__Bin__c){
                            component.set("v.isError",true); 
                           // component.set("v.errorMsg",'At '+ILPlist[i].IlpliList[j].Name+' for product '+ILPlist[i].ProName+', From & To Bin should not be same.');
                           component.set("v.errorMsg",'  From & To Location Bin should not be same. for product '+ILPlist[i].ProName+' in Ilpli '+ILPlist[i].IlpliList[j].Name);
                            return;
                        } 
                
                
                          /*  else if(ILPlist[i].IlpliList[j].sigmaerpdev2__ILid__c != undefined && ILPlist[i].IlpliList[j].sigmaerpdev2__ILid__c != null && ILPlist[i].IlpliList[j].sigmaerpdev2__ILid__c != ''  && (ILPlist[i].IlpliList[j].sigmaerpdev2__bucket_field__c == undefined || ILPlist[i].IlpliList[j].sigmaerpdev2__bucket_field__c === null || ILPlist[i].IlpliList[j].sigmaerpdev2__bucket_field__c == 0)){
                                component.set("v.isError",true);
                                component.set("v.errorMsg",'At '+ILPlist[i].IlpliList[j].Name+' for product '+ILPlist[i].ProName+', Please enter valid quantity.');
                                return;
                            } */
                
                                else if((ILPlist[i].IlpliList[j].sigmaerpdev2__ILid__c == undefined || ILPlist[i].IlpliList[j].sigmaerpdev2__ILid__c == null || ILPlist[i].IlpliList[j].sigmaerpdev2__ILid__c == '') && Number(ILPlist[i].IlpliList[j].sigmaerpdev2__bucket_field__c)>0){
                                    component.set("v.isError",true);
                                    component.set("v.errorMsg",'At '+ILPlist[i].IlpliList[j].Name+' for product '+ILPlist[i].ProName+', Please Enter To Location.');
                                    return;
                }
            }
        }
        
        component.set("v.isError",false);
        component.set("v.errorMsg",null);
       //alert("ILPlist>>>>>>"+JSON.stringify(ILPlist));
        // console.log("ILPlist>>>>>>"+JSON.stringify(ILPlist));
        //return;
        helper.SaveStockMovement(component, event, helper); 
        document.getElementById("Accspinner").style.display = "block";
    },

    BackButton:function(cmp, event){ 
      //  cmp.set("v.loaded",'true');
       //window.self.close();
        //window.history.back();
           cmp.set("v.loaded",'false');
        
        setTimeout(function(){ 
            
            
          
           var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/lightning/n/sigmaerpdev2__Stock_Management"
        });        
        urlEvent.fire();             
                             
                             }, 3000);
    },   
    doneWaiting: function(component, event, helper) {
        document.getElementById("Accspinner").style.display = "none";
    },
     recordCreatedOK: function(component, event, helper) 
    {
       sforce.one.navigateToSObject(component.get("v.curRecordID"));        
    },
    recordCreatedCancel: function(component, event, helper) 
    {
        var successAlert = component.find("successAlert");
        $A.util.addClass(successAlert,'slds-hide');        
    },
    binChange: function(component, event, helper) {
        var binId= component.get("v.binId");
         var recID= component.get("v.recID");
      //  alert('binId binChange>>>'+JSON.stringify(binId));
        // alert('recID binChange>>>'+JSON.stringify(recID));
        if(binId!=null && JSON.stringify(binId)!='""' && recID!=null && JSON.stringify(recID)!='""')
        {
            helper.fetchILPdata(component, event, helper);
        }
        else
        {
            component.set("v.ILPlist",[]);
            component.set("v.isError",false);
        component.set("v.errorMsg",null);
       
        }
            
    },
     locChange: function(component, event, helper) {
        var recID= component.get("v.recID");
       console.log('recID locChange>>>'+JSON.stringify(recID));
         if(JSON.stringify(recID)==='""')
         {
              component.set("v.binId",'');
              component.set("v.FormLocId",'');
             
             component.set("v.isBinShow",false);
            component.set("v.isError",false);
        component.set("v.errorMsg",null);
         }
         else{
             component.set("v.isBinShow",true);
             component.set("v.FormLocId",recID);
              let FormLocId= component.get("v.FormLocId");
              console.log('FormLocId>>'+FormLocId);
              component.set("v.binId",'');
         }
       // if(binId!=null && JSON.stringify(binId)!="" )
         //   helper.fetchILPdata(component, event, helper);
    }
})