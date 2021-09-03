({
    /*   handleProtoTypeEvent: function (component, event, helper) {
      // alert('Inside Parent handler event caught>>>');   
       var proType = event.getParam("prodType"); 
		component.set("v.protype", proType); 
         alert('Inside Parent handler proType>>>'+component.get("v.protype"));    
    },*/
    refresh : function(component, event, helper) {
        
        $A.get('e.force:refreshView').fire();
    },
    goBack : function(component, event) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/lightning/n/sigmaerpdev2__Stock_Management_Modules"
        });        
        urlEvent.fire(); 
        // $A.get("e.force:closeQuickAction").fire(); 
    },
    binAddAndClearEvent: function (component, event, helper) {
        
        var teargetlocname= component.get('v.locID');
        var wrapper = component.get("v.wrapper");
        var IndLine = wrapper.IndPros;
        var binId= component.get('v.binId'); 
        var lotId= component.get('v.lotId');
       // alert('teargetlocname-->>'+teargetlocname);
        if(teargetlocname!='')
        {
            //alert('came if');
              component.set("v.wrapper.Targetloc",teargetlocname);
        }
        else{
       //    alert('came else');
            if(!component.get('v.locID'))
            {
                var individual=component.get('v.wrapper.IndPros');
                //alert('individual-->>' + JSON.stringify(individual));
                for(var i=0;i<individual.length; i++)
                {
                    //alert('bin name-->>'+individual[i].bin);
                    individual[i].bin='';
                    individual[i].binName='';
                    
                }
                component.set('v.wrapper.IndPros',individual);
                //alert('outside loop-->>' + JSON.stringify(component.get('v.wrapper.IndPros')));
                //component.set('v.wrapper.IndPros.lot','');
            } 
        }
            
       
        //  alert('set bin' + JSON.stringify(component.get('v.wrapper.IndPros')));
        if(lotId)
        {
            component.set("v.IlpliItem.fromLot",lotId); 
        }
        //   alert(JSON.stringify(component.get("v.IlpliItem.lot")));
    },
    /*     itemsChange: function(component, event, helper)
    {
        var InvLocationId = component.find("FromLocation");
        $A.util.addClass(InvLocationId,"slds-hide");
        var record = component.get('v.wrapper');
        var SelId = component.get("v.ilid");
        
        if(SelId != null && SelId != undefined && SelId !=''){
            //alert('before calling');
            helper.onSelect(component, event, record, SelId);
        }
    },*/
    doInit : function(component, event, helper){ 
        //   alert('inside doinit');
        var recordIdFromUi = component.get("v.ilpid");
        //    alert('ILP id'+component.get("v.ilpid"));
        if(recordIdFromUi!=null)
        {
            var action = component.get("c.getilpData");
            action.setParams({
                "ilpId" : recordIdFromUi
            });
            action.setCallback(this, function(response) 
                               {
                                   var state = response.getState();
                                   //  alert('state::'+state);
                                   if (state == 'SUCCESS')
                                   {
                                       var ILPObj = response.getReturnValue();
                                       //alert('ilpobj:::'+ILPObj.length);
                                       component.set('v.wrapper',ILPObj);
                                       var ilplength=component.get('v.wrapper');
                                       // alert('ilplength:::'+JSON.stringify(component.get('v.wrapper')));
                                       if(JSON.stringify(ilplength.record)=="{}")
                                       {
                                           // alert('inside if1');
                                           component.set('v.errorMsg', 'Please select Inventory Location Product to Convert Bom Product as Individual Products.');
                                           component.set('v.isError', true);
                                           return; 
                                       }
                                       else
                                       {
                                           //  alert('inside if5');
                                           component.set("v.isError",false);
                                           component.set("v.errorMsg",''); 
                                       }
                                       /*    if(v.wrapper.record.sigmaerpdev2__Products__r.sigmaerpdev2__Attribute_Type__c=="Individual")
                                      {
                                         // alert('inside if1');
                                           component.set('v.errorMsg', 'BOM to Individual Conversion is not possible Because Product type is Individual.');
                                           component.set('v.isError', true);
                                           return; 
                                      }*/
                                       /*    if(ilplength.vendorList.length<=0)
                                       {
                                            //alert('inside if112');
                                           component.set('v.errorMsg', 'Please Check Vendor is not available for BOM product.');
                                           component.set('v.isError', true);
                                           return;   
                                       }
                                       else
                                       {
                                         //   alert('inside if113');
                                           component.set("v.isError",false);
                                           component.set("v.errorMsg",''); 
                                       }*/
                                       if(ilplength.IndPros.length<=0)
                                       {
                                           // alert('inside if122');
                                           component.set('v.errorMsg', 'No Line Item are added to Bom Product.');
                                           component.set('v.isError', true);
                                           return;   
                                       }else if(ilplength.record.sigmaerpdev2__Net_Quantity__c<=0)
                                       {
                                           //  alert('inside if4');
                                           component.set('v.errorMsg', 'No available Quantity to convert.');
                                           component.set('v.isError', true);
                                           return;  
                                       }
                                           else
                                           {
                                               //  alert('inside if5');
                                               component.set("v.isError",false);
                                               component.set("v.errorMsg",''); 
                                           }
                                   }
                                   
                               });
        }
        $A.enqueueAction(action);   
        var ilpIds=component.get('v.wrapper');
        //	alert('ilpIds>>'+ilpIds);
        if(ilpIds){
            //    alert('innn');
            if(!component.get('v.ilpIds')){
                //   alert('remove');
                component.set('v.wrapper.record.sigmaerpdev2__Products__c','');
                component.set('v.wrapper.record.sigmaerpdev2__Products__r.sigmaerpdev2__Attribute_Type__c','');
                
                component.set('v.wrapper.record.sigmaerpdev2__Inventory_Location__r.Name','');
                component.set('v.wrapper.record.sigmaerpdev2__Inventory_Location_Name__c','');
                component.set('v.wrapper.record.sigmaerpdev2__Net_Quantity__c',0);
                component.set('v.wrapper.convertedQty',0);
                
            }
        }
    },
     clear : function(component, event, helper){ 
       	component.set("v.recordId",'');
        component.set("v.proid",'');
		component.set("v.prodname",'');
        component.set("v.ilpid",'');
        component.set("v.ilpname",'');
         component.set("v.locID",'');
        component.set("v.teargetlocname",'');
        component.set("v.wrapper.convertedQty",'');
        component.set("v.wrapper.record.sigmaerpdev2__Products__r.sigmaerpdev2__Attribute_Type__c",''); 
        component.set("v.wrapper.record.sigmaerpdev2__Inventory_Location_Name__c",'');
        component.set("v.wrapper.record.sigmaerpdev2__Inventory_Location__r.Name",'');
        component.set("v.wrapper.record.sigmaerpdev2__Net_Quantity__c",'');
        component.set("v.isError",false); 
         return;
      
    },
    SelectedID  : function(component, event, helper)
    {
        //alert('hyujjuu');
        var context = event.getParam("instanceId");
        var objectId = event.getParam("sObjectId");
        var VendorId = event.getParam("VendersObjectId");  
        var SelId = event.getParam("sObjectId");
        var  objectLabel = event.getParam("objectLabel");
        if(context == 'TargetLocation')
        {
            component.set("v.wrapper.Targetloc",objectId);
        }
        
        if(context == 'Lot')
        {
            component.set("v.wrapper.fromLot",objectId);
        }
        //    alert(JSON.stringify( component.get("v.wrapper.fromLot")));
        
    },
    
    LineItemSection : function(component, event, helper)
    {    
        var LineItemSection = component.find('LineItemSection');
        $A.util.toggleClass(LineItemSection, 'slds-is-open');		
    },
    ILPLISection : function(component, event, helper)
    {    
        var ILPLISection = component.find('ILPLISection');
        $A.util.toggleClass(ILPLISection, 'slds-is-open');		
    },
    Save : function(component, event, helper)
    { 
        var wrapper = component.get("v.wrapper");
        wrapper.IsPIupdate=true;
        //  var proType = component.get("v.protype");
        // alert('wrapper'+ JSON.stringify(component.get("v.wrapper")));
        //var serial=component.get("v.serial"); 
        //   alert('individaual line item-->>'+JSON.stringify(component.get("v.wrapper.IndPros")));
        
        var IndLine = wrapper.IndPros;
        //   alert('IndLine-->>'+JSON.stringify(wrapper.IndPros.unitPrice));
        //return;
        //   var serial=wrapper.IndPros.serialNo;
        //  var protype=component.get('v.lineItem.indpro.sigmaerpdev2__Product__r.sigmaerpdev2__Attribute_Type__c');
        // 	alert('proType--->>>>>'+proType);
        var serialNos=[];
        //   alert(JSON.stringify(wrapper.fromBin));
        if(!component.get('v.proid'))
        {
            component.set('v.errorMsg', 'Please Select Any Product to Convert Stock from BOM Product.');
            component.set('v.isError', true);
            return;
        }
        if(!component.get('v.teargetlocname'))
        {
            component.set('v.errorMsg', 'Please Target Location to Convert Stock from BOM Product.');
            component.set('v.isError', true);
            return;
        }
        if(wrapper.IndPros.length<=0)
        {
            component.set('v.errorMsg', 'No Line Item are added to Bom Product.');
            component.set('v.isError', true);
            return;   
        }
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg",'');
        }
        if(wrapper.convertedQty==undefined)
        {
            component.set('v.errorMsg', 'Please Enter Valid Quantity to Convert Stock from BOM Product');
            component.set('v.isError', true);
            return;
        }
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg",'');
        }/*else if(wrapper.Targetloc==undefined)
        {
            component.set('v.isError', true);
            component.set('v.errorMsg', 'Please Choose Target location to Convert Stock from BOM Product.');
            return;
        }else if(JSON.stringify(wrapper.IndPros.unitPrice)==undefined|| JSON.stringify(wrapper.IndPros.unitPrice)==''||JSON.stringify(wrapper.IndPros.unitPrice)==null)
        {
            alert('IndLine.unitPrice-->>'+IndLine.unitPrice);
            component.set('v.isError', true);
            component.set('v.errorMsg', 'Unit Price is Missing for Individual Products to Convert Stock from BOM Product.');
            return;
        }
        else if(JSON.stringify(wrapper.fromBin)=='""' ||  JSON.stringify(wrapper.fromBin)==undefined)
        {
            component.set('v.isError', true);
            component.set('v.errorMsg', 'Please Choose Bin location to Convert Stock from BOM Product.');
            return;
        }
        if(wrapper.vendorList.length<=0)
        {
            component.set('v.errorMsg', 'Please Check Vendor is not available for Bom Product.');
            component.set('v.isError', true);
            return;   
        }
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg",''); 
        }*/
        
        var adjustedQtysum = 0;
        //  alert('wrapper.eachLineItemILPLIWrapper>>'+JSON.stringify(wrapper.eachLineItemILPLIWrapper)); 
        for(var i = 0; i < wrapper.eachLineItemILPLIWrapper.length; i ++)
        {
            if(wrapper.eachLineItemILPLIWrapper[i].eachLineItemILPLI.sigmaerpdev2__Available_Quantity__c < wrapper.eachLineItemILPLIWrapper[i].pickQty)
            {
                //alert('came in');
                component.set('v.errorMsg', 'Pick Quantity should be less than or equal to available quantity.');
                component.set('v.isError', true);
                return; 
            }
            else
            {
               // alert('came out');
                component.set("v.isError",false);
                component.set("v.errorMsg",'');                
            }
            if(wrapper.eachLineItemILPLIWrapper[i].pickQty != undefined)
            {
                adjustedQtysum = +adjustedQtysum + +wrapper.eachLineItemILPLIWrapper[i].pickQty;
            }
        }
        if(wrapper.convertedQty > wrapper.record.sigmaerpdev2__Net_Quantity__c || wrapper.convertedQty<=0 ){
            component.set('v.errorMsg', 'Please Enter Valid Quantity to Convert Stock From Bom to Individual Products');
            component.set('v.isError', true);
            return;
        }
        else if((wrapper.convertedQty%1)!=0)
        {
            component.set('v.errorMsg', 'Decimals are not allowed,Please Enter valid Quantity to Convert Stock From Individual Products to BOM.');
            component.set('v.isError', true);
            return;
        }
            else if(wrapper.convertedQty != adjustedQtysum){
                component.set('v.errorMsg', 'Sum of Pick quantities should be equal to Convert Stock From Bom to Individual Products');
                component.set('v.isError', true);
                return;
            }
                else{
                    component.set("v.isError",false);
                    component.set("v.errorMsg",'');
                }
        //code added by rashmi to validate serial code on 18-11-2019
        //  alert('Individual Line Items length-->'+IndLine.length);
        for(var i=0;i<IndLine.length;i++)
        {
            //alert('unitPrice-->'+IndLine[i].bin);
            if(IndLine[i].unitPrice==undefined || IndLine[i].unitPrice=='' || IndLine[i].unitPrice==null )
            {
                component.set('v.errorMsg', 'Unit Price is Missing for Individual Products to Convert Stock from BOM Product.');
                component.set('v.isError', true);
                return;
            }else if(IndLine[i].bin =='' ||  IndLine[i].bin==undefined ||IndLine[i].bin ==null)
            {
                component.set('v.errorMsg', 'Please Choose Bin location to Convert Stock from BOM Product.');
                component.set('v.isError', true);
                return;
            }
                else{
                    component.set("v.isError",false);
                    component.set("v.errorMsg",'');
                }
            //     alert('IndLineItem is>>>'+IndLine[i].indpro.sigmaerpdev2__Product__r.sigmaerpdev2__Attribute_Type__c);
            if(IndLine[i].indpro.sigmaerpdev2__Product__r.sigmaerpdev2__Attribute_Type__c == 'SERIALIZED')
            {
                //  alert('serial size-->'+IndLine[i].eachserialNo.length)
                
                for(var j=0;j<IndLine[i].eachserialNo.length;j++)
                {
                    // alert('IndLine[i].eachserialNo[j]--->'+IndLine[i].eachserialNo[j].sigmaerpdev2__Serial_Number__c);
                    
                    if(!IndLine[i].eachserialNo[j].sigmaerpdev2__Serial_Number__c )
                    {
                        // alert('serial code at--->'+IndLine[i].eachserialNo[j].sigmaerpdev2__Serial_Number__c);
                        //    alert("Serial No Missing at Line '"+(j+1)+"' of '"+srp[i].transName+"' Purchase Order");
                        component.set("v.errorMsg","Serial No Missing at Line '"+(j+1)+"' for Product" +IndLine[i].indpro.sigmaerpdev2__Product__r.Name+ ".");
                        component.set("v.isError", true);
                        return;
                    }
                    //alert('serialNo in List--->'+serialNos.includes(IndLine[i].eachserialNo[j].sigmaerpdev2__Serial_Number__c));
                    if(serialNos.includes(IndLine[i].eachserialNo[j].sigmaerpdev2__Serial_Number__c))
                    {
                        //  alert('checking duplicate serial code'+serial[j].sigmaerpdev2__Serial_Number__c);
                        component.set("v.errorMsg", "Duplicate Serial No : '" +IndLine[i].eachserialNo[j].sigmaerpdev2__Serial_Number__c+ "' found at Row--> '" +(j+1)+ "' for Product " +IndLine[i].indpro.sigmaerpdev2__Product__r.Name+ ".");
                        component.set("v.isError", true);
                        return;
                    }else{
                        component.set("v.isError",false);
                        component.set("v.errorMsg",'');
                    }
                    serialNos.push(IndLine[i].eachserialNo[j].sigmaerpdev2__Serial_Number__c);
                    
                    //  alert('after adding Serial code in serialNo List--->'+serialNos.includes(IndLine[i].eachserialNo[j].sigmaerpdev2__Serial_Number__c));
                    /*    for(var k=1; k<serial.length; k++ )
                    {
                        alert('serial[j].code -->'+serial[j].code );
                        alert('serial[k].code -->'+serial[k].code );
                        if(serial[j].code === serial[k].code){
                            component.set("v.errorMsg", "Duplicate Serial No : '" +serial[k].code+ "' found at Row--> '" +(k+1)+ "' for Product " +IndLine[i].indpro.sigmaerpdev2__Product__r.Name+ ".");
                            //show 
                            component.set("v.isError", true);
                            return;
                        }
                    }*/
                    //  }
                }//code ends here
            }
        }
        /*  for(var i=0;i<serial.length;i++)
            {
             /*   if(serial[i].code==null&&serial[i].code=='')
                {
                    component.set('v.isError', true);
                    component.set('v.errorMsg', 'Please Enter all the Serial Numbers');
                    return; 
                } */
        /* for(var j=i+1;j<serial.length;j++)
                {
                    if(serial[i].code==serial[j].code && (serial[i].code != null && serial[i].code !=''))
                    {
                        component.set('v.isError', true);
                        component.set('v.errorMsg', 'Duplicate serial number found--->'+serial[i].code);
                        return; 
                    }
                    else
                    {
                        component.set("v.isError",false);
                        component.set("v.errorMsg",null); 
                    } 
                }
                for(var k=0;k<wrapper.serialList.length;k++)
                {
                   // alert('serial11111:'+JSON.stringify(wrapper.serialList[k].sigmaerpdev2__Serial_Number__c));
                   //  alert('serial2:'+JSON.stringify(wrapper.serialList[k]));
                    if(wrapper.serialList[k].sigmaerpdev2__Serial_Number__c==undefined && serial[i].code==wrapper.serialList[k].sigmaerpdev2__Serial_Number__c && (serial[i].code == null || serial[i].code ==''||serial[i].code == undefined))
                    {
                        component.set('v.isError', true);
                        component.set('v.errorMsg', 'Serial code is mandatory for BOM Product');
                        return; 
                    }
                    /* if(wrapper.serialList[k].sigmaerpdev2__Serial_Number__c==''&&wrapper.serialList[k].sigmaerpdev2__Serial_Number__c==null)
                    {
                        component.set('v.isError', true);
                        component.set('v.errorMsg', 'Serial code is mandatory for BOM Product');
                        return; 
                    } */
        /*// alert(serial[k]);
                     if(serial[k].sigmaerpdev2__Serial_Number__c==null &&serial[k].sigmaerpdev2__Serial_Number__c=='')
                    {
                        	
                        component.set('v.isError', true);
                        component.set('v.errorMsg', 'Serial code is mandatory for BOM Product');
                        return; 
                    } */
        /*  if(wrapper.serialList[k].sigmaerpdev2__Serial_Number__c!=undefined && serial[i].code==wrapper.serialList[k].sigmaerpdev2__Serial_Number__c && (serial[i].code != null || serial[i].code !=''||serial[i].code != undefined))
                    {
                        component.set('v.isError', true);
                        component.set('v.errorMsg', 'Duplicate serial number found--->'+serial[i].code);
                        return; 
                    }
                    else
                    {
                        component.set("v.isError",false);
                        component.set("v.errorMsg",null); 
                    } 
                }
            }*/
        //   alert('wrapperdata ::'+JSON.stringify(wrapper));
        
        //  alert('serial data'+JSON.stringify(serial))
        var actSave = component.get("c.savedata");
        
        actSave.setParams({
            "wrapperdata": JSON.stringify(wrapper)
            //  "serial": JSON.stringify(serial)
        });
        actSave.setCallback(this, function(response) 
                            {
                                var state = response.getState();
                                //  alert('state-->'+state);
                                if (state=== 'SUCCESS')
                                {
                                    component.set("v.spinner",false);
                                    var recid=component.get("v.ilpid");
                                    component.set("v.curRecordID",recid);
                                    // alert('recid-->'+JSON.stringify(component.get("v.curRecordID",recid)));
                                    //alert('response-->'+ response.getReturnValue().message);
                                    // alert('response-->'+ response.getReturnValue().data);
                                    if(response.getReturnValue().message=='Success')
                                    {
                                        // alert('inside if1');
                                        if ((typeof sforce !== 'undefined') && sforce && (!!sforce.one)) 
                                        {
                                            //alert('inside if2');
                                            var successAlert = component.find("successAlert");
                                            $A.util.removeClass(successAlert,'slds-hide');
                                            // window.location.href = "/one/one.app#/sObject/" + a.getReturnValue();
                                            
                                        }
                                        else
                                        {
                                            
                                            //  window.location.href = "/" + recid;
                                            // alert('Bom to Individual conversion completed successfully');
                                            var toastEvent = $A.get("e.force:showToast");
                                            toastEvent.setParams({
                                                "title": "Success!",
                                                "type" : "success",
                                                "message": "Bom to Individual conversion completed successfully.",
                                                //	"message": "Duplicate serial number Found. The duplicate value is '"+response.getReturnValue().duplicateSerialNo+"' at Line '" + (k+1) + "' of serial No in '" +SRL[i].transName+ "'  Purchase Order.",
                                            });
                                            toastEvent.fire(); 
                                            var evt = $A.get("e.force:navigateToComponent");
                                            evt.setParams({
                                                componentDef : "c:StockManagementModules",
                                                componentAttributes: {
                                                    from : 'stkMngmnt'
                                                }
                                            });
                                            evt.fire();
                                            //ends here 
                                        }   
                                    }
                                    else
                                    {
                                        // alert('length-->'+IndLine.length);
                                        for(var i=0;i<IndLine.length;i++)
                                        {
                                            //  alert('IndLineItem is>>>'+IndLine[i].indpro.sigmaerpdev2__Product__r.sigmaerpdev2__Attribute_Type__c);
                                            if(IndLine[i].indpro.sigmaerpdev2__Product__r.sigmaerpdev2__Attribute_Type__c == 'SERIALIZED')
                                            {
                                                //  alert('serial size-->'+IndLine[i].eachserialNo.length)
                                                
                                                for(var j=0;j<IndLine[i].eachserialNo.length;j++)
                                                {
                                                    
                                                    
                                                    //	alert('IndLine[i].eachserialNo[j].sigmaerpdev2__Serial_Number__c--->'+IndLine[i].eachserialNo[j].sigmaerpdev2__Serial_Number__c+'and duplicate serial code is-->'+response.getReturnValue().duplicateSerialNo);
                                                    if(IndLine[i].eachserialNo[j].sigmaerpdev2__Serial_Number__c===response.getReturnValue().duplicateSerialNo)
                                                    {
                                                        
                                                        //  alert('Serial_Number__c>>'+serial[j].code);
                                                        //  alert('Duplicate serial number Found. The duplicate value is--> ' + response.getReturnValue().duplicateSerialNo + ' at Line ' + (j+1) + ' of selected BOM Product.');
                                                        var toastEvent = $A.get("e.force:showToast");
                                                        toastEvent.setParams({
                                                            "title": "Error!",
                                                            "type" : "error",
                                                            "message": "Duplicate serial number Found. The duplicate value is--> '" + response.getReturnValue().duplicateSerialNo + "' at Line '" + (j+1) + "' of selected BOM Product.",
                                                            //	"message": "Duplicate serial number Found. The duplicate value is '"+response.getReturnValue().duplicateSerialNo+"' at Line '" + (k+1) + "' of serial No in '" +SRL[i].transName+ "'  Purchase Order.",
                                                        });
                                                        toastEvent.fire();
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                                else
                                {
                                    var successAlert = component.find("successAlert");
                                    $A.util.removeClass(successAlert,'slds-hide');
                                    var successAlertTheme = component.find("successAlertTheme");
                                    $A.util.removeClass(successAlertTheme,'slds-theme--success');
                                    $A.util.addClass(successAlertTheme,'slds-theme--error');
                                    var iconsuccess=component.find("iconsuccess");
                                    $A.util.addClass(iconsuccess,'slds-hide');
                                    var iconwarning=component.find("iconwarning");
                                    $A.util.removeClass(iconwarning,'slds-hide');
                                    var recordCreatedHeader = component.find("recordCreatedHeader");
                                    $A.util.addClass(recordCreatedHeader,'slds-hide');
                                    var recordNotCreatedHeader = component.find("recordNotCreatedHeader");
                                    $A.util.removeClass(recordNotCreatedHeader,'slds-hide');
                                    var recordCreatedOK = component.find("recordCreatedOK");
                                    $A.util.addClass(recordCreatedOK,'slds-hide');
                                    var recordCreatedCancel = component.find("recordCreatedCancel");
                                    $A.util.removeClass(recordCreatedCancel,'slds-hide'); 
                                }
                            });
        component.set("v.spinner",true);
        $A.enqueueAction(actSave); 
    },
    /* //code added to fetch Product inventory ID on 07-01-2020
    fetchPI :function(component,event,helper)
    {
        var action = component.get("c.fetchPI");
         action.setParams({
            "proid": component.get("v.proid")
        });
    },*/
    validateQuantity : function(component, event, helper) 
    {
        var convertstock = component.find("quantity").get("v.value");
        var isChecked = component.find('inputToggle').get('v.checked');
        // alert('convertstock stock>>'+ convertstock +'autostock>>'+ isChecked);
        if(convertstock == null || convertstock == 0)
        {
            component.find('inputToggle').set('v.checked',true);
            var inputToggle = component.find('inputToggle');
            $A.util.addClass(inputToggle, 'slds-hide'); 
        }
        else{     
            component.find('inputToggle').set('v.checked',false);
            var inputToggle = component.find('inputToggle');
            $A.util.removeClass(inputToggle, 'slds-hide');
        }
        
        var originalQty = component.get('v.wrapper.record.sigmaerpdev2__Net_Quantity__c');
        var adjustedQty = component.get('v.wrapper.convertedQty');
        //code added on 13-04-2020
        var wrapper = component.get('v.wrapper');
        //   wrapper.updqtydisplay=adjustedQty;
        // alert('camein>>'+wrapper.updqtydisplay);
        /*for(var i=0;i<wrapper.eachLineItemILPLIWrapper.length;i++)
        {
           // alert('camein');
            wrapper.eachLineItemILPLIWrapper[i].updqtydisplay =adjustedQty;
          //  alert('updqtydisplay>>'+JSON.stringify(wrapper.IndPros[i].updqtydisplay));
        }*/
        
        component.set("v.wrapper",wrapper);
        if(adjustedQty > originalQty )
        {
            component.find("quantity").set("v.errors", [{message:"Quantity should be Less than or Equal to Available quantity in the BOM product ILP."}]);
            return;
        }
        else  if (adjustedQty == 0)
        {
            component.find("quantity").set("v.errors", [{message:"Pick valid quantity "}]);
            return;
        }
            else if((adjustedQty %1)!= 0  )
            {
                component.find("quantity").set("v.errors", [{message:"Quantity should not be negative  or less than Zero"}]);
                return;
            }
                else if(adjustedQty < originalQty || adjustedQty == originalQty )
                {
                    component.find("quantity").set("v.errors", [{message:""}]);
                    return;
                } 
        /////
        //     alert('set serial no');
        
        /*  var wrapper = component.get('v.wrapper');
       // var convqty = component.get('v.convqty');
       // var lineqty = component.get('v.lineItem.indpro.sigmaerpdev2__Quantity__c'); 
       // var protype = component.get('v.lineItem.indpro.sigmaerpdev2__Product__r.sigmaerpdev2__Attribute_Type__c');
       // alert('set serial no>>'+convqty*lineqty);
       //alert("avc"+originalQty);
      
       if(wrapper.convertedQty <=  originalQty)
       {
         //  alert('vtr'+wrapper.IndPros);
           for(var i=0; i< wrapper.IndPros.length; i++)
               {
                  // alert('inside for');
                   var reqserqty=wrapper.IndPros[i].indpro.sigmaerpdev2__Quantity__c * wrapper.convertedQty;
               //alert(reqserqty);
                   if( reqserqty > 0 && wrapper.IndPros[i].indpro.sigmaerpdev2__Product__r.sigmaerpdev2__Attribute_Type__c == 'SERIALIZED')
                {
                   var WrapperArray = [];
       				
            
           			 for(var j= 0; j< reqserqty; j++ )
           					 {
               					WrapperArray.push({
                    				'sigmaerpdev2__Serial_Number__c': null
                						});   
             
           						 }
            component.set("v.wrapper.IndPros[i].eachserialNo", WrapperArray); 
                 //   alert('vfhegfey');
            alert('abvccc'+JSON.stringify(component.get("v.wrapper.IndPros[i].eachserialNo")));
        
        			}
               }
       }
     
      alert('bgt111'+JSON.stringify(component.get("v.wrapper.IndPros")));   */
    },
    BackButton : function(component, event, helpe)
    {
        var Opprec  = component.get("v.ilpid");
        window.location.href = "/one/one.app#/sObject/" + Opprec;
    },
    recordCreatedOK: function(component, event, helper) 
    {
        // alert('curRecordID-->'+component.get("v.curRecordID"));
        sforce.one.navigateToSObject(component.get("v.curRecordID"));      
    },
    recordCreatedCancel: function(component, event, helper) 
    {
        //alert('close button');
        var successAlert = component.find("successAlert");
        // alert('close button'+successAlert);
        $A.util.addClass(successAlert,'slds-hide');        
    },
    closeSerial: function(component, event, helper) 
    {
        var sersec = component.find('serialinput');
        $A.util.addClass(sersec, "slds-hide");
    },
    //code added on 07-04-2020 to handle auto stock reservation and auto/Manual aullocation-by rashmi
    
    autoPickInventory: function (component, event, helper) {
        //alert('auto picking');
        var isChecked = component.find('inputToggle').get('v.checked');
        var wrapper=component.get("v.wrapper");
        // var updqty=wrapper.updqtydisplay;
        //  alert('test before wraper set'+JSON.stringify(wrapper));
        if(isChecked==true){
            component.set("v.autostock","true");
            component.set("v.showAutoResvButton","false"); 
            var qty=component.get("v.wrapper.convertedQty");
            var convqty=qty;
            //	var qyt=0;
            var istrue=true;
            
            //	var convqty=wrapper.eachLineItemILPLIWrapper[i].updqtydisplay;
            for(var i = 0; i < wrapper.eachLineItemILPLIWrapper.length; i ++)
            {
                //if pick qty selected manually assign zero before pick qty automatically
                wrapper.eachLineItemILPLIWrapper[i].pickQty=0;
                //alert('pickQty>>>'+ wrapper.eachLineItemILPLIWrapper[i].pickQty);
                if(wrapper.eachLineItemILPLIWrapper[i].eachLineItemILPLI.sigmaerpdev2__Available_Quantity__c>=convqty && convqty!=0)
                {
                    wrapper.eachLineItemILPLIWrapper[i].pickQty=convqty; 
                    convqty=0;
                }
                else if(wrapper.eachLineItemILPLIWrapper[i].eachLineItemILPLI.sigmaerpdev2__Available_Quantity__c < convqty)
                {
                    wrapper.eachLineItemILPLIWrapper[i].pickQty=wrapper.eachLineItemILPLIWrapper[i].eachLineItemILPLI.sigmaerpdev2__Available_Quantity__c;
                    //  qyt++;
                    //	if(qyt==convqty)break;
                    convqty=convqty-wrapper.eachLineItemILPLIWrapper[i].eachLineItemILPLI.sigmaerpdev2__Available_Quantity__c;
                }
                
            }
        }
        else
        {
            var convqty=component.get("v.wrapper.convertedQty");
            //	var updqty=wrapper.updqtydisplay
            for(var i = 0; i < wrapper.eachLineItemILPLIWrapper.length; i ++)
            {
                
                if(convqty!=0)
                {
                    wrapper.eachLineItemILPLIWrapper[i].pickQty=0; 
                }
            }
            component.set("v.showAutoResvButton","true");
            component.set("v.autostock","false");
        }
        component.set("v.wrapper",wrapper);
        // alert('abc aftr wrapper set::'+JSON.stringify(component.get("v.wrapper")));
    },
    /*       handleAutoSelectCheckBox:function(component, event, helper){
               
                var checkBoxValue=component.find('isAutoSelChecked').get('v.value');
                var wrapper=component.get("v.wrapper");

             	
                // alert(JSON.stringify(wrapper));
                if(checkBoxValue)
                {
                    component.set("v.autostock","true");
                  
                     var updqty=component.get("v.wrapper.convertedQty");
                    for(var i = 0; i < wrapper.eachLineItemILPLIWrapper.length; i ++)
                    {
                        //if pick qty selected manually assign zero before pick qty automatically
                        wrapper.eachLineItemILPLIWrapper[i].pickQty=0;
                      //  alert('pickQty>>>'+ wrapper.eachLineItemILPLIWrapper[i].pickQty);
                        var availqty=wrapper.eachLineItemILPLIWrapper[i].eachLineItemILPLI.sigmaerpdev2__Available_Quantity__c;
                        if(updqty <= availqty && updqty!=0)
                        {
                            wrapper.eachLineItemILPLIWrapper[i].pickQty=updqty; 
                            updqty=0;
                        }
                        else if(updqty > availqty)
                        {
                            wrapper.eachLineItemILPLIWrapper[i].pickQty=availqty;
                            updqty-=wrapper.eachLineItemILPLIWrapper[i].eachLineItemILPLI.sigmaerpdev2__Available_Quantity__c;
                        }
                        
                    }
                    // component.get("v.autostock","true");
                }
                else
                {
                    var updqty=component.get("v.wrapper.convertedQty");
                    for(var i = 0; i < wrapper.eachLineItemILPLIWrapper.length; i ++)
                    {
                        if(updqty!=0)
                        {
                            wrapper.eachLineItemILPLIWrapper[i].pickQty=0; 
                        }
                        
                    }
                    component.set("v.autostock","false");
                }
                component.set("v.wrapper",wrapper);  
                
            },*/
    
})