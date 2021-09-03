({
    goBack : function(component, event) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/lightning/n/sigmaerpdev2__Stock_Management_Modules"
        });        
        urlEvent.fire(); 
        // $A.get("e.force:closeQuickAction").fire(); 
    },
    refresh : function(component, event, helper)
    {
        var selectedProject = event.getParam('selfRefreshEvttab');        
    },
    doInit : function(component, event, helper)
    { 
        
        var recordIdFromUi = component.get("v.productid");
        var productids=component.get('v.wrapper');
        
        if(recordIdFromUi!=null)
        {
            
            var action = component.get("c.getPIData");
            action.setParams({
                "inventoryid" : recordIdFromUi
            });
            action.setCallback(this, function(response) 
                               {
                                   var state = response.getState();
                                   
                                   if (state == 'SUCCESS')
                                   {
                                       var ILPObj = response.getReturnValue();
                                       // alert('ILPObj>>>'+JSON.stringify(ILPObj));
                                       component.set('v.wrapper',ILPObj);
                                       
                                       var lineitem=component.get('v.wrapper');
                                       /*   alert('lineitem?/'+JSoN.stringify(component.get('v.wrapper')));
                                       if(lineitem){
                                           alert('inventpry??'+lineitem.sigmaerpdev2__ProductCode__r.sigmaerpdev2__Attribute_Type__c);
                                           
                                           component.set('v.wrapper.productinventory.sigmaerpdev2__ProductCode__r.sigmaerpdev2__Attribute_Type__c',lineitem.sigmaerpdev2__ProductCode__r.sigmaerpdev2__Attribute_Type__c);
                                           component.set('v.wrapper.productinventory.sigmaerpdev2__Available_Qty__c',lineitem.sigmaerpdev2__Available_Qty__c);
                                           component.set('v.wrapper.UpdateStockNum',0);
                                       }*/
                                       
                                   }
                                   
                                   /*            if(lineitem.vendorList == undefined || lineitem.vendorList == '' || lineitem.vendorList == null){

                                           component.set('v.errorMsg', 'Please Check Vendor is not available for BOM product.');
                                           component.set('v.isError', true);
                                           return;
                                       }else{

                                           component.set("v.isError",false);
                                           component.set("v.errorMsg",''); 
                                       }
*/                                       
                                   /*//code to handle validation if Bom Product doesnt have Vendor
                                          if(lineitem.vendorList.sigmaerpdev2__Product_Name__c==null || lineitem.vendorList.sigmaerpdev2__Product_Name__c=='' || lineitem.vendorList.sigmaerpdev2__Product_Name__c == undefined)
                                           {
                                               
                                               component.set('v.errorMsg', 'Please Check Vendor is not available for BOM product.');
                                               component.set('v.isError', true);
                                               return; 
                                           }
                                           else
                                           {
                                               component.set("v.isError",false);
                                               component.set("v.errorMsg",null); 
                                           }
                                       }*/
                                   
                                   //code to handle validation if Bom Product doesnt have Line Items    
                                   if(lineitem.eachWrapperLineItem.length<=0)
                                   {
                                       
                                       component.set('v.errorMsg', 'Please Check NO line item is added to BOM product.');                       
                                       component.set('v.isError', true);
                                       return;  
                                   }
                                   else
                                   {
                                       
                                       component.set("v.isError",false);
                                       component.set("v.errorMsg",''); 
                                   }
                                   
                                   for(var i=0;i<lineitem.length;i++)
                                   {
                                       if(lineitem[i].eachLineItemILPLIWrapper.length<=0)
                                       {
                                           component.set('v.errorMsg', 'Please Check Line Item '+lineitem[i].eachLineItem+' do not have ILPLI');
                                           component.set('v.isError', true);
                                           return;  
                                       }
                                       else
                                       {
                                           component.set("v.isError",false);
                                           component.set("v.errorMsg",''); 
                                       }  
                                   }
                               });
            
            $A.enqueueAction(action); 
        }
        if(!recordIdFromUi)
        {
            component.set('v.wrapper.productinventory.sigmaerpdev2__ProductCode__r.sigmaerpdev2__Attribute_Type__c','');
            component.set('v.wrapper.productinventory.sigmaerpdev2__Available_Qty__c',0);
            component.set('v.wrapper.UpdateStockNum',0);
            
            var idListStr=component.get('v.idListStr');
            if(idListStr)
                idListStr = idListStr.replace(event.getParam("oldValue"), "");
            component.set('v.idListStr',idListStr)
            
        } 
    }, 
    
    //code added by rashmi to remove bin id if location/IL is undefined on 02-05-2019 
    binClearEvent: function (component, event, helper) {
        
        
        var teargetlocname= component.get('v.locID');
        var binId= component.get("v.BinId");
        
        
        if(teargetlocname!='')
        {
            component.set("v.wrapper.bomloc",teargetlocname);
            //alert('targetloc>>'+component.get('v.wrapper.bomloc'));
            
        }
        else
        {
            if(!component.get('v.locID'))
            {
                component.set('v.BinId','');
            }
        }
        if(binId)
        {
            component.set('v.binId',binId);
        }
    },//ends here
    SelectedID  : function(component, event, helper)
    {
        
        var context = event.getParam("instanceId");
        var objectId = event.getParam("sObjectId");
        var VendorId = event.getParam("VendersObjectId");  
        var SelId = event.getParam("sObjectId");
        var  objectLabel = event.getParam("objectLabel");
        
        if(context == 'TargetLocation')
        {
            
            
            component.set("v.wrapper.bomloc",objectId);
            
        }
        /*        if(context =='MyAccount2')
        { 
            
            cmp.set("v.wrapper.sigmaerpdev2__Account__c",objectId); 
            
        }*/
        else if(context == 'Lot')
        {
            component.set("v.wrapper.bomlot",SelId);
        }
        
        
        
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
    addilplitoWrap :function(component, event, helper) 
    {
        // var updatestock = component.find("updatestock").get("v.value");
        var sersec = component.find('serialinput');
        var availQty = component.get('v.wrapper.productinventory.sigmaerpdev2__Available_Qty__c');
        var upqty = component.get('v.wrapper.UpdateStockNum');
        var wrapper = component.get('v.wrapper');
        var protype=component.get('v.wrapper.productinventory.sigmaerpdev2__ProductCode__r.sigmaerpdev2__Attribute_Type__c');
        //alert('wrapper.eachWrapperLineItem--->>>>'+JSON.stringify(wrapper.eachWrapperLineItem));        
        var proname;
        //  alert('Bom product is serialized product so individual(bulk) product is converting as serialized ');
        
        for(var i=0;i<wrapper.eachWrapperLineItem.length;i++)
        {
            
            wrapper.eachWrapperLineItem[i].pickqtydisplay =wrapper.eachWrapperLineItem[i].LineItemqty * upqty;
            if(wrapper.eachWrapperLineItem[i].pickqtydisplay > wrapper.eachWrapperLineItem[i].Indavailable) 
            {
                if(proname == undefined)
                {
                    proname=wrapper.eachWrapperLineItem[i].eachLineItem;
                }
                else
                {
                    proname=proname+','+wrapper.eachWrapperLineItem[i].eachLineItem;
                }
                
            }
        }
        if(proname!= undefined)
        {
            alert('Warning!! Conversion is not possible with insufficient stock available in the inventory of line item products : '+proname+' '); 
        }
        
        component.set("v.wrapper",wrapper);
        if( upqty > 0 && protype == 'SERIALIZED'){
            //show
            $A.util.removeClass(sersec,"slds-hide");
            $A.util.addClass(sersec, "slds-show"); 
        }else{
            //hide
            $A.util.removeClass(sersec,"slds-show");
            $A.util.addClass(sersec, "slds-hide"); 
        }
        var serial=component.get("v.serial");
        if (!Array.isArray(serial)) {
            serial = [serial];
        }
        var WrapperArray = [];
        if(protype == 'SERIALIZED')
        {
            //  alert('protype>>>>'+protype);
            for(var i= 0; i< upqty; i++ )
            {
                WrapperArray.push({
                    'code': null
                });   
            }
            component.set("v.serial", WrapperArray); 
            
        }
       // alert('upqty>>'+upqty);
       // alert('isError>>'+component.get("v.isError"));
        if (upqty == 0)
        {
            component.find("updatestock").set("v.errors", [{message:"Enter valid quantity "}]);
           // component.set('v.isError', true);
            return;
        }
        else if((upqty %1)!= 0 )
        {
            component.find("updatestock").set("v.errors", [{message:"Quantity should not be negative  or less than Zero"}]);
            return;
        }
        else if(upqty < availQty || upqty == availQty )
        {
            component.find("updatestock").set("v.errors", [{message:""}]);
            return;
        }
        else
        {
            // alert('3'+upqty);
            component.find("updatestock").set("v.errors", [{message:" "}]);
            component.set("v.isError",false);
            
        }
        var isChecked = component.find('inputToggle').get('v.checked');
        var checkBoxValue=component.find('isAutoSelChecked').get('v.value');
        
        if(upqty == '' || upqty == undefined)
        {
            
            component.find('inputToggle').set('v.checked',true);
            component.find('isAutoSelChecked').set('v.value',true);
            var inputToggle = component.find('inputToggle');
            $A.util.addClass(inputToggle, 'slds-hide'); 
        }
        else{
            
            component.find('inputToggle').set('v.checked',false);
            component.find('isAutoSelChecked').set('v.value',false);
            var inputToggle = component.find('inputToggle');
            $A.util.removeClass(inputToggle, 'slds-hide');
        }
        
        
    },
    BackButton : function(component, event, helpe)
    {
        var Opprec  = component.get("v.productid");
        window.location.href = "/one/one.app#/sObject/" + Opprec;
    },
    Save : function(component, event, helper)
    {
        //var spin = component.find('mySpinner');
        //  $A.util.removeClass(spin, 'slds-hide');
        var wrapper = component.get("v.wrapper");
        var serial=component.get("v.serial"); 
        var binId = component.get("v.binId");
        var productId = component.get("v.productid");
        
        var protype=component.get('v.wrapper.productinventory.sigmaerpdev2__ProductCode__r.sigmaerpdev2__Attribute_Type__c');
        var serialNos=[];	
        // alert('binId'+component.get("v.binId"));
        var totalPickQty;
        //    alert('wrapper'+JSON.stringify(wrapper.bomloc));
        // alert('prodid-->>'+component.get('v.wrapper.productinventory.sigmaerpdev2__ProductCode__c'));
        /*   if(wrapper.bomloc==undefined || wrapper.bomloc=='' || wrapper.bomloc==null )
        {
            //alert('hi');
            component.set('v.errorMsg', 'Please Choose Target location to Update Stock from Individual Products.');
            component.set('v.isError', true);
            return; 
        }
        else if(wrapper.bomloc!=undefined || wrapper.bomloc!='' || wrapper.bomloc!=null  )
        {
            //alert('making false');
            component.set("v.isError",false);
            component.set("v.errorMsg",''); 
        }*/
        if(!component.get("v.productid")) 
        {
            component.set('v.errorMsg', 'Please Choose any Product to Update Stock from Individual Products.');
            component.set('v.isError', true);
            return;  
        }
        if(!component.get("v.teargetlocname")) 
        {
            component.set('v.errorMsg', 'Please Choose Target location to Update Stock from Individual Products.');
            component.set('v.isError', true);
            return;  
        }
        if(!component.get("v.BinId"))
        {
            component.set('v.errorMsg', 'Please Choose Bin location to Update Stock from Individual Products.');
            component.set('v.isError', true);
            return; 
        }
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg",''); 
        }
        if(wrapper.UpdateStockNum<=0 )
        {
            component.set('v.errorMsg', 'Please Enter Valid Quantity to Update Stock From Individual Products to BOM.');
            component.set('v.isError', true);
            return;  
        }
        else if ((wrapper.UpdateStockNum%1)!=0){
            component.set('v.errorMsg', 'Decimals are not allowed,Please Enter valid Quantity to Update Stock From Individual Products to BOM.');
            component.set('v.isError', true);
            return;  
            
        }
            else
            {
                component.set("v.isError",false);
                component.set("v.errorMsg",''); 
            }
        if(!component.get("v.wrapper.productinventory.sigmaerpdev2__ProductCode__c"))
        {
            component.set('v.errorMsg', ' Please Enter Mandatory fields to convert Individuals to BOM Product');
            component.set('v.isError', true);
            return; 
            
        } 
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg",''); 
        }
        for(var i=0;i<wrapper.eachWrapperLineItem.length;i++)
        {
            var individualtotalPickQty=0;
            totalPickQty = wrapper.eachWrapperLineItem[i].pickqtydisplay;
            // totalPickQty = (totalPickQty *wrapper.UpdateStockNum);
            // alert('wrapper.eachWrapperLineItem>>'+JSON.stringify(wrapper.eachWrapperLineItem)); 
            //	alert('wrapper.eachWrapperLineItem--->>>'+JSON.stringify(wrapper.eachWrapperLineItem));
            // alert('wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper--->>>'+JSON.stringify(wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper));
            for(var j=0;j<wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper.length;j++)
            {
                
                individualtotalPickQty = individualtotalPickQty + +wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty;
                
                if(wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Available_Quantity__c < wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty )
                {
                    component.set('v.isError', true);
                    component.set('v.errorMsg', 'Update Stock Quantity should not be greater than Available Quantity At -->'+wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.Name);
                    return;  
                }
                else
                {
                    component.set("v.isError",false);
                    component.set("v.errorMsg",''); 
                } 
            }
            
            if(totalPickQty != individualtotalPickQty )
            {
                component.set('v.isError', true);
                component.set('v.errorMsg', 'Sum of Update Stock Quantity should be equal to Total Pick Quantity At Line Item --->'+wrapper.eachWrapperLineItem[i].eachLineItem);
                return; 
            }
            else
            {
                component.set("v.isError",false);
                component.set("v.errorMsg",''); 
            } 
            
        }
        //code added by rashmi to validate serial code on 18-11-2019
        // alert('serial nos length-->'+serial.length);
        for(var i=0;i<serial.length;i++)
        {
            // alert('serial[i]--->'+i);
            if(!serial[i].code && protype == 'SERIALIZED')
            {
                //   alert('serial code at--->'+serial[i].code);
                //   alert("Serial No Missing at Line '"+(j+1)+"' of '"+srp[i].transName+"' Purchase Order");
                component.set("v.errorMsg","Serial No Missing at Line '"+(i+1)+"' of Selected BOM Product");
                component.set("v.isError", true);
                return;
            }
            else
            {
                component.set("v.isError",false);
                component.set("v.errorMsg",''); 
            }
            
            if(serialNos.includes(serial[i].code )){
                // alert('duplicate serial code'+serial[i].code);
                component.set("v.errorMsg", "Duplicate Serial No : '" +serial[i].code+ "' found at Row--> '" +(i+1)+ "' of selected BOM Product");
                component.set("v.isError", true);
                return;
            }
            else
            {
                component.set("v.isError",false);
                component.set("v.errorMsg",''); 
            }
            serialNos.push(serial[i].code);
            /*   for(var j=i+1; j< serial.length; j++ )
            {
                alert('serial[i].code -->'+serial[i].code );
                alert('serial[j].code -->'+serial[j].code );
                if(serial[i].code === serial[j].code){
                    component.set("v.errorMsg", "Duplicate Serial No : '" +serial[i].code+ "' found at Row--> '" +(i+1)+ "' of selected BOM Product");
                    //show 
                    component.set("v.isError", true);
                	return;
                }
            }*/
        }//code ends here
        /*	for(var i=0;i<serial.length;i++)
            {
                alert('serial[i].code-->'+serial[i].code);
                if(serial[i].code==null || serial[i].code=='' || serial[i].code==undefined)
                {
                    alert('serial[i].code-->'+serial[i].code);
                    component.set('v.isError', true);
                    component.set('v.errorMsg', 'Please Enter all the Serial Numbers');
                    return; 
                } 
                for(var j=i+1;j<serial.length;j++)
                {
                    if(serial[i].code==serial[j].code || (serial[j].code != null || serial[j].code !=''))
                    {
                        alert('serial[i].code-->'+serial[i].code);
                        component.set('v.isError', true);
                        component.set('v.errorMsg', 'Duplicate serial number found--->'+serial[i].code);
                        return; 
                    }
                    else
                    {
                        alert('inside else');
                        component.set("v.isError",false);
                        component.set("v.errorMsg",null); 
                    } 
                }
                system.debug('wrapper.serialList.length-->'+wrapper.serialList.length);
                for(var k=0;k<wrapper.serialList.length;k++)
                {
                    //alert('serial11111:'+JSON.stringify(wrapper.serialList[k].sigmaerpdev2__Serial_Number__c));
                   //  alert('serial2:'+JSON.stringify(wrapper.serialList[k]));
                    if(wrapper.serialList[k].sigmaerpdev2__Serial_Number__c==undefined || serial[i].code==wrapper.serialList[k].sigmaerpdev2__Serial_Number__c || (serial[i].code == null || serial[i].code ==''||serial[i].code == undefined))
                    {
                        alert('inside if'+wrapper.serialList[k].sigmaerpdev2__Serial_Number__c);
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
        /*    if(wrapper.serialList[k].sigmaerpdev2__Serial_Number__c!=undefined || serial[i].code==wrapper.serialList[k].sigmaerpdev2__Serial_Number__c || (serial[i].code != null || serial[i].code !=''||serial[i].code != undefined))
                    {
                        alert('duplicate serial no');
                        component.set('v.isError', true);
                        component.set('v.errorMsg', 'Duplicate serial number found--->'+serial[i].code);
                        return; 
                    }
                    else
                    {
                        alert('inside else 2');
                        component.set("v.isError",false);
                        component.set("v.errorMsg",null); 
                    } 
                }
            }*/
        //    return;
        //     alert('wrapper'+JSON.stringify(wrapper));
        var actSave = component.get("c.savedata");
        actSave.setParams({
            "wrapperdata": JSON.stringify(wrapper),
            "serial": JSON.stringify(serial),
            "binId":component.get("v.BinId")            
            
        });
        actSave.setCallback(this, function(response) 
                            {
                                var state = response.getState();
                                  // alert('state::'+state);
                                
                                //  alert('dcfshgcb'+component.get(response.getReturnValue()));
                                if (state=== 'SUCCESS')
                                {
                                    component.set("v.spinner",false);
                                    //component.set("v.curRecordID",response.getReturnValue());
                                    var recid=component.get("v.productid");
                                    component.set("v.curRecordID",recid);
                                    //  alert('response-->'+ response.getReturnValue().message);
                                    // alert('response-->'+ response.getReturnValue().data);
                                    if(response.getReturnValue().message=='Success')
                                    {
                                        // alert('inside if1');
                                        if ((typeof sforce !== 'undefined') && sforce && (!!sforce.one)) 
                                        {
                                            // alert('inside if2');
                                            var successAlert = component.find("successAlert");
                                            $A.util.removeClass(successAlert,'slds-hide');
                                            // window.location.href = "/one/one.app#/sObject/" + a.getReturnValue();
                                        }
                                        else
                                        {
                                            //   window.location.href = "/" + response.getReturnValue();
                                            // window.location.href = "/" +recid;*/
                                            //code added by rashmi on 03-02-2020 to show Success msg after conversion
                                            //alert('Individual to Bom conversion completed successfully');
                                            var toastEvent = $A.get("e.force:showToast");
                                            toastEvent.setParams({
                                                "title": "Success!",
                                                "type" : "success",
                                                "message": "Individual to Bom conversion completed successfully.",
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
                                        // alert('inside else2');
                                        for(var i=0;i<serial.length;i++)
                                        {
                                              //alert('serial[i].code-->'+serial[i].code);
                                             // alert('serial[i].code-->'+response.getReturnValue().duplicateSerialNo);
                                            if(serial[i].code===response.getReturnValue().duplicateSerialNo )
                                            {
                                                
                                                //   alert('Serial_Number__c>>'+serial[i].code);
                                                 // alert('Duplicate serial number Found. The duplicate value is--> ' + response.getReturnValue().duplicateSerialNo + ' at Line ' + (i+1) + ' of selected BOM Product.');
                                                var toastEvent = $A.get("e.force:showToast");
                                                toastEvent.setParams({
                                                    "title": "Error!",
                                                    "type" : "error",
                                                    "message": "Duplicate serial number Found. The duplicate value is--> '" + response.getReturnValue().duplicateSerialNo + "' at Line '" + (i+1) + "' of selected BOM Product.",
                                                    //	"message": "Duplicate serial number Found. The duplicate value is '"+response.getReturnValue().duplicateSerialNo+"' at Line '" + (k+1) + "' of serial No in '" +SRL[i].transName+ "'  Purchase Order.",
                                                });
                                                toastEvent.fire(); 
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
                                    
                                    /*   var errors = response.getError();
                                   
                					alert("Error message: " +JON.stringify(Component.get(response.getError())));
                                    if(errors){
                                        if(errors[0] && errors[0].message){
                                            alert("Error message: " + errors[0].message);
                                            
                                            component.find('notifLib').showNotice({
                                                "variant": "error",
                                                "header": "Something went wrong!",
                                                "message":errors[0].message,
                                                closeCallback: function() {
                                                    $A.get('e.force:refreshView').fire();
                                                }
                                            });
                                            $A.get("e.force:closeQuickAction").fire();
                                            
                                        }else{
                                            component.find('notifLib').showNotice({
                                                "variant": "error",
                                                "header": "Unknow Error!",
                                                "message": "Duplicate serial number found please try with other serial number's.",
                                                closeCallback: function() {}
                                            });
                                        }
                                    }else{
                                        alert("Unknown error");
                                    }
                                  /*   if(response.getReturnValue().data.includes("DUPLICATE_VALUE, duplicate value found: sigmaerpdev2__Serial_Number__c"))
                                     {
                                         alert('inside if');
                                         for(var i=0;i<serial.length;i++)
       									 {
                                              alert('serial[i].code-->'+serial[i].code);
                                              alert('serial[i].code-->'+response.getReturnValue().duplicateSerialNo);
                                             if(serial[i].code==response.getReturnValue().duplicateSerialNo)
                                             {
                                                
                                                 //alert('Serial_Number__c>>'+srlNo[k].sigmaerpdev2__Serial_Number__c);
                                                 var toastEvent = $A.get("e.force:showToast");
                                                 toastEvent.setParams({
                                                     "title": "Error!",
                                                     "type" : "error",
                                                     "message": "Duplicate serial number Found. The duplicate value is '" + response.getReturnValue().duplicateSerialNo + "' at Line '" + (i+1) + "' of selected BOM Product.",
                                                     //	"message": "Duplicate serial number Found. The duplicate value is '"+response.getReturnValue().duplicateSerialNo+"' at Line '" + (k+1) + "' of serial No in '" +SRL[i].transName+ "'  Purchase Order.",
                                                 });
                                                 toastEvent.fire();
                                             }
                                         }
                                     }*/
                                }
                            });
        component.set("v.spinner",true);
        $A.enqueueAction(actSave); 
    },
    
    //code to fetch Product inventory ID
    fetchPIdata :function(component,event,helper)
    {
        
        var productid = component.get('v.productid');
        
        var productids=component.get('v.wrapper');
        
        //alert('productid>>>'+productid);
        
        if(productid){
            
            var action = component.get("c.fetchPI");
            action.setParams({
                "proid": productid
            });
            
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state=== 'SUCCESS')
                {
                    var inventory = response.getReturnValue();
                    alert('inventory Id???'+inventory.Id);
                    component.set('v.productid',inventory.Id);
                    alert('after set???');
                    //alert('productid?????'+component.get('v.productid'));
                    if(productids){
                        alert('678 productids>>'+JSON.stringify(productids));
                        component.set('v.wrapper.productinventory.sigmaerpdev2__ProductCode__r.sigmaerpdev2__Attribute_Type__c',inventory.sigmaerpdev2__ProductCode__r.sigmaerpdev2__Attribute_Type__c);
                        component.set('v.wrapper.productinventory.sigmaerpdev2__Available_Qty__c',inventory.sigmaerpdev2__Available_Qty__c);
                        component.set('v.wrapper.UpdateStockNum',0);
                    }
                }
            });
            $A.enqueueAction(action);    
        }
        if(productids){
            if(!component.get('v.productids')){
                alert('689 productids>>'+JSON.stringify(productids));
                //   component.set('v.wrapper.productinventory.sigmaerpdev2__Product__c','');
                component.set('v.wrapper.productinventory.sigmaerpdev2__ProductCode__r.sigmaerpdev2__Attribute_Type__c','');
                component.set('v.wrapper.productinventory.sigmaerpdev2__Available_Qty__c',0);
                component.set('v.wrapper.UpdateStockNum',0);
                
                var idListStr=component.get('v.idListStr');
                if(idListStr)
                    idListStr = idListStr.replace(event.getParam("oldValue"), "");
                component.set('v.idListStr',idListStr)
            }          
        }
    },
    
    clear : function(component, event, helper){ 
        component.set("v.recordId",'');
        component.set("v.productid",'');
        component.set("v.prodname",'');
        component.set("v.locID",'');
        component.set("v.teargetlocname",'');
        component.set("v.BinName",'');
        component.set("v.wrapper.productinventory.sigmaerpdev2__ProductCode__c",'');
        component.set("v.wrapper.productinventory.sigmaerpdev2__ProductCode__r.sigmaerpdev2__Attribute_Type__c",'');
        component.set("v.wrapper.productinventory.sigmaerpdev2__Available_Qty__c",'');
        component.set("v.wrapper.UpdateStockNum",'');
        component.set("v.isError",false);
        
        
        return;
        
    },
    validateQuantity : function(component, event, helper)
    {
        var serial = component.get("v.wrapper.serialno");
        // alert('serial::'+JSON.stringify(serial));
    },
    recordCreatedOK: function(component, event, helper) 
    {
        //  alert('curRecordID-->'+component.get("v.curRecordID"));
        sforce.one.navigateToSObject(component.get("v.curRecordID"));        
    },
    recordCreatedCancel: function(component, event, helper) 
    {
        var successAlert = component.find("successAlert");
        $A.util.addClass(successAlert,'slds-hide');        
    },
    closeSerial: function(component, event, helper) 
    {
        var sersec = component.find('serialinput');
        $A.util.addClass(sersec, "slds-hide");
    },
    //code added on 07-04-2020 to handle auto stock reservation and auto/Manual aullocation-by rashmi
    
    autoPickInventory: function (component, event, helper) {
        
        var isChecked = component.find('inputToggle').get('v.checked');
        var wrapper=component.get("v.wrapper");
        // alert('test'+JSON.stringify(wrapper.UpdateStockNum));
        if(isChecked==true){
            component.set("v.showAutoResvButton",false); 
            component.set("v.autoAllocFlag",true); 
            
            for(var i=0;i<wrapper.eachWrapperLineItem.length;i++)
            {
                
                var qty=wrapper.eachWrapperLineItem[i].pickqtydisplay;
                
                for(var j=0;j<wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper.length;j++)
                {
                    
                    if(wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Available_Quantity__c>=qty && qty!=0)
                    {
                        
                        wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty=qty; 
                        qty=0;
                        
                        
                    }
                    else if(wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Available_Quantity__c < qty)
                    {
                        
                        wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty=wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Available_Quantity__c;
                        qty=qty-wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Available_Quantity__c;
                        
                        
                    }
                    
                }
            }
        }
        else
        {
            for(var i=0;i<wrapper.eachWrapperLineItem.length;i++)
            {
                var qty=wrapper.eachWrapperLineItem[i].pickqtydisplay;
               // alert('qty>>'+qty);
                for(var j=0;j<wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper.length;j++)
                {                
                    if(qty!=0)
                    {
                        wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty=0; 
                        
                    }
                }
            }
            
            component.set("v.showAutoResvButton",true);
            component.set("v.autoAllocFlag",false); 
        }
        component.set("v.wrapper",wrapper);
        //alert('abc::'+JSON.stringify(component.get("v.wrapper")));
    },
    /*  handleAutoSelectCheckBox:function(component, event, helper){
        
        var checkBoxValue=component.find('isAutoSelChecked').get('v.value');
        var wrapper=component.get("v.wrapper");
        
        
        if(checkBoxValue)
        {
            component.set("v.autoAllocFlag","true"); 
            for(var i=0;i<wrapper.eachWrapperLineItem.length;i++)
            {
                var updpickqty=wrapper.eachWrapperLineItem[i].pickqtydisplay;
                
                
                for(var j=0;j<wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper.length;j++)
                {
                    
                    var availqty=wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Available_Quantity__c;
                    
                    if(updpickqty <= availqty && updpickqty!=0)
                    {
                        wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty=updpickqty;
                        //updpickqty-=availqty;
                        updpickqty=0;
                        
                    }
                    else if(updpickqty > availqty)
                    {
                        wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty=availqty;
                        updpickqty-=availqty;
                        
                    }
                    
                }
            }
        }
        else
        {
            for(var i=0;i<wrapper.eachWrapperLineItem.length;i++)
            {
                var updpickqty=wrapper.eachWrapperLineItem[i].pickqtydisplay;
                
                for(var j=0;j<wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper.length;j++)
                {                
                    if(updpickqty!=0)
                    {
                        wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty=0; 
                        
                    }
                }
            }
            component.set("v.autoAllocFlag","false"); 
        }
        component.set("v.wrapper",wrapper);   
    }*/
    AfterBinBarcScan:function (component, event, helper){
        // alert('BinBarcScan ios calling');
        
        component.set("v.locationFoundFlag",false);
        var locBarCodeValue=component.get('v.locBarCodeValue');
        // alert('locBarCodeValue>>>'+locBarCodeValue);
        var wrapper=component.get("v.wrapper");
        window.setTimeout(
            $A.getCallback(function() {
                var locBarCodeValueInner=component.get('v.locBarCodeValue');
                //   alert('locBarCodeValueInner>>'+locBarCodeValueInner.length);
                var locFound=false;
                var allProdPickedInThisLoc=false;
                
                if(locBarCodeValueInner.length==locBarCodeValue.length)
                {
                    // var pickilpliData=component.get("v.wrapper.eachWrapperLineItem");
                    // alert('afterLocScaned2 ios calling pickilpliData'+JSON.stringify(wrapper.eachWrapperLineItem));
                     // alert(pickilpliData.size);
                    for(var i=0;i<wrapper.eachWrapperLineItem.length;i++)
                    {
                        var updpickqty=wrapper.eachWrapperLineItem[i].pickqtydisplay;
                        // alert('updpickqty>>>'+wrapper.eachWrapperLineItem[i].pickqtydisplay);
                        
                        for(var j=0;j<wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper.length;j++)
                        {
                            var pickqty=wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty;
                           //  alert('pickqty>>>'+pickqty);
                            // alert('binbarcode>>>>'+wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Bin__r.sigmaerpdev2__Bar_Code__c);
                            // alert('locBarCodeValue>>>>'+locBarCodeValue);
                            if(wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Bin__r.sigmaerpdev2__Bar_Code__c==locBarCodeValue && updpickqty!=pickqty)
                            {
                                //  alert('inside locScanedcode');
                                var input = component.find("prodScanedCode");
                                //  alert('input>>>'+input);
                                input.focus ();
                                //code added by bhaskar to remove  slds-hide to show bin barcode on 16-10-2019
                                var prodScanedCodeDiv = component.find("prodScanedCodeDiv");
                                $A.util.removeClass(prodScanedCodeDiv, 'slds-hide'); //ends here
                                //alert('zonename>>>'+wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Bin__r.sigmaerpdev2__zone__r.Name);
                                
                                component.set("v.scannedLocationName",'('+wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Bin__r.sigmaerpdev2__zone__r.Name?wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Bin__r.sigmaerpdev2__zone__r.Name:'None'+','+wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Bin__r.Name+')');
                                // alert('scannedLocationName>>>'+JSON.stringify(component.get("v.scannedLocationName")));
                                
                                locFound=true;
                                //  alert('updpickqty11111>>>'+updpickqty);
                                //   alert('pickqty22222>>>'+pickqty);
                                
                                if(updpickqty==pickqty)
                                    allProdPickedInThisLoc=true;
                                var rowData = document.getElementById("rowData_"+j);
                                //   alert('rowData>'+rowData.length);
                                window.scrollTo(0, rowData.offsetTop);
                                break;
                            }
                        }
                    }
                  //   alert('locFound>>>'+locFound);
                    if(locFound)
                    {
                     //    alert('v.autoAllocFlag'+ component.get("v.autoAllocFlag"));
                        component.set("v.autoAllocFlag","true"); 
                        
                        //component.set('v.scannedLocationName','');
                        component.set("v.locationFoundFlag",true);
                        
                        
                    }
                    else
                    {
                        
                        component.set("v.scannedLocationName",'Not Found');
                        component.set("v.locationFoundFlag",true);
                        
                        window.setTimeout(
                            $A.getCallback(function() {
                                if(!component.get('v.locBarCodeValue'))
                                    component.set("v.locationFoundFlag",false);
                            }), 1000
                        );
                        
                        
                    }
                    
                }
            }),1000
        );
    },
    afterProdScaned:function (component, event, helper){
        
       // alert('afterProdScaned is called ');
        component.set("v.productFoundFlag",false);
        
        var prodBarCodeValue=component.get('v.prodBarCodeValue');
       // alert('prodBarCodeValue>>>'+JSON.stringify(prodBarCodeValue));
        var locBarCodeValue=component.get('v.locBarCodeValue');
		//alert('locBarCodeValue>>>'+JSON.stringify(locBarCodeValue));
		//alert('afterProdScaned is called ::locBarCodeValue::'+JSON.stringify(locBarCodeValue));
        // alert('afterProdScaned is called ::prodBarCodeValue::'+JSON.stringify(component.get('v.prodBarCodeValue')));
        var wrapper=component.get("v.wrapper");
		//alert('wrapper>>>'+JSON.stringify(wrapper));
        window.setTimeout(
            $A.getCallback(function() {
                var prodBarCodeValueInner=component.get('v.prodBarCodeValue');
                var prodFound = false;
                var allProdPicked = false;
                var alreadyScanned = false;
                var allPickedProdName = '';
				//alert('prodBarCodeValueInner>>>'+JSON.stringify(prodBarCodeValueInner));
                if(prodBarCodeValueInner.length==prodBarCodeValue.length)
                {
                  //  alert('wrapper.eachWrapperLineItem>>>'+JSON.stringify(wrapper.eachWrapperLineItem)); 
                   // let autopick=component.get("v.autoAllocFlag");
                    
                   // alert('autopick::'+autopick);
                    for(var i=0;i<wrapper.eachWrapperLineItem.length;i++)
                    {
                        var updpickqty=wrapper.eachWrapperLineItem[i].pickqtydisplay;
                        var totalPickQty=0;
                       // alert('updpickqty>>>'+updpickqty);
                        for(var j=0;j<wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper.length;j++)
                        {
                            //alert('j>>>'+j);
                            var pickqty=wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty;
                           // alert('pickqty>>>'+pickqty);
                           //   alert('sigmaerpdev2__Product_Bar_Code__c>>>'+wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Product__r.sigmaerpdev2__Product_Bar_Code__c);
                            //  alert('sigmaerpdev2__Bar_Code__c--->>>'+prodBarCodeValue);
                             //  alert('sigmaerpdev2__Product_Bar_Code__c>>>'+wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Bin__r.sigmaerpdev2__Bar_Code__c);
                              // alert('locBarCodeValue--->>>'+locBarCodeValue);
                            if(wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Product__r.sigmaerpdev2__Product_Bar_Code__c==prodBarCodeValue && updpickqty!=pickqty && locBarCodeValue==wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Bin__r.sigmaerpdev2__Bar_Code__c )
                            {
                               // alert("1234");
                                //let found = wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.find(element => wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Product__r.Name===element.wrapper.productinventory.sigmaerpdev2__ProductCode__r && wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Product__r.Product_Bar_Code__c===element.wrapper.productinventory.sigmaerpdev2__ProductCode__r .sigmaerpdev2__Product_Bar_Code__c && wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Product__c===element.element.wrapper.productinventory.sigmaerpdev2__ProductCode__c);
                                //alert(" found>>>"+wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Product__r.sigmaerpdev2__Attribute_Type__c);
                                // alert(" found>>>"+JSON.stringify( found));
                                //if(found.sigmaerpdev2__ILPLI__r.sigmaerpdev2__Product__r.sigmaerpdev2__Attribute_Type__c==='SERIALIZED')
                                if(wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Product__r.sigmaerpdev2__Attribute_Type__c=='SERIALIZED')
                                {
                                  //  alert('qwerty-->'+autopick);
                                    //let yes=;
                                   // if(autopick)
                                   // {
                                       // component.set("v.autoAllocFlag",false);
                                     
                                        var availqty=wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Available_Quantity__c;
                                        //if(updpickqty <= availqty && updpickqty!=0)
                                        //alert('1111---'+wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty);
                                    	//alert('2222----'+availqty);
                                        //alert('wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty>>'+JSON.stringify(wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty));
                                             //alert('wrapper.eachWrapperLineItem[i].pickqtydisplay'+JSON.stringify(wrapper.eachWrapperLineItem[i].pickqtydisplay));
                                            // alert('wrapper.eachWrapperLineItem[i].totalPickQty>>'+JSON.stringify(wrapper.eachWrapperLineItem[i].totalPickQty));
                                    // alert('totalPickQty>>'+JSON.stringify(totalPickQty));
                                    		
                                    if(  updpickqty >= availqty && updpickqty!=0 && updpickqty>totalPickQty && updpickqty>wrapper.eachWrapperLineItem[i].totalPickQty){
                                            if(wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty==1)continue;
                                            wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty=wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty? parseInt(wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty)+1:1;
                                        	//totalPickQty=totalPickQty+1;
                                        wrapper.eachWrapperLineItem[i].totalPickQty=wrapper.eachWrapperLineItem[i].totalPickQty+1;
                                         //alert('wrapper.eachWrapperLineItem[i].totalPickQty>>'+JSON.stringify(wrapper.eachWrapperLineItem[i].totalPickQty));
                                  
                                          //  if( wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty!=availqty && wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty==0)
                                           
                                                
                                     	}
                 
                                    	  	
                                        component.set("v.scannedProductName",wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Product__r.Name);
                                        prodFound=true;
                                    	if(wrapper.eachWrapperLineItem[i].totalPickQty===wrapper.eachWrapperLineItem[i].pickqtydisplay)alreadyScanned=true;
                                        //$A.util.removeClass(component.find('ProdName'), 'slds-hide');
                                        if(wrapper.eachWrapperLineItem[i].pickqtydisplay==wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty || wrapper.eachWrapperLineItem[i].pickqtydisplay >= availqty ){
                                            allProdPicked=true;
                                            allPickedProdName=wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Product__r.Name;
                                        }
                                        break;
                                  /*  }else{
                                        //alert('1111');
                                        wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty=wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty? parseInt(wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty)+1:1;
                                        component.set("v.scannedProductName",wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Product__r.Name);
                                        prodFound=true;
                                        //$A.util.removeClass(component.find('ProdName'), 'slds-hide');
                                        if(wrapper.eachWrapperLineItem[i].pickqtydisplay==wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty  && wrapper.eachWrapperLineItem[i].pickqtydisplay <= availqty){
                                            allProdPicked=true;
                                            allPickedProdName=wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Product__r.Name;
                                        }*/
                                       
                                    
                                }
                                else
                                {
                                     var availqty=wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Available_Quantity__c;
                                     //  alert('wrapper.eachWrapperLineItem[i].totalPickQty>>'+JSON.stringify(wrapper.eachWrapperLineItem[i].totalPickQty));
                                  // alert('updpickqty'+JSON.stringify(updpickqty));
                                  // alert('availqty'+JSON.stringify(availqty));
                                  
                                   // alert('3331213243');
                                   if(  updpickqty <= availqty && updpickqty!=0 && updpickqty>wrapper.eachWrapperLineItem[i].totalPickQty)
                                   {
                                       wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty=wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty? parseInt(wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty)+1:1;
                                    	 wrapper.eachWrapperLineItem[i].totalPickQty=wrapper.eachWrapperLineItem[i].totalPickQty+1;
                                  		// alert('wrapper.eachWrapperLineItem[i].totalPickQty>>'+JSON.stringify(wrapper.eachWrapperLineItem[i].totalPickQty));
                                  
                                   }
                                   // alert('pickqty--------------1>>>'+pickqty);
                                    component.set("v.scannedProductName",wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Product__r.Name);
                                    //alert('v.scannedProductName>>>'+ component.get("v.scannedProductName"));
                                    
                                    prodFound=true;
                                   if(wrapper.eachWrapperLineItem[i].totalPickQty===wrapper.eachWrapperLineItem[i].pickqtydisplay)
                                    alreadyScanned=true;
                                    if(wrapper.eachWrapperLineItem[i].pickqtydisplay==wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty){
                                        allProdPicked=true;
                                        allPickedProdName=wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].eachLineItemILPLI.sigmaerpdev2__Product__r.Name;
                                    }
                                    break;
                                    
                                }
                            }
                        }
                    }
                    
                    component.set("v.wrapper",wrapper);
                    //alert('wrapper-->>>::'+JSON.stringify(component.get("v.wrapper")));
                    //   alert('afterProdScaned is called ::allProdPicked::'+allProdPicked);
                    if(JSON.stringify(locBarCodeValue)=='""')
                    {
                        component.set("v.scannedLocationName",'please scan first bin barcode');
                        component.set("v.scannedProductName",'Not Found');
                        component.set("v.productFoundFlag",true);
                        //  component.set("v.scannedLocationName",'Not Found');
                        component.set("v.locationFoundFlag",true);
                        window.setTimeout(
                            $A.getCallback(function() {
                                if(!component.get('v.prodBarCodeValue'))
                                    component.set("v.productFoundFlag",false);
                            }), 3000
                        );
                        return ;
                    }
                    
                    if(prodFound)
                    {
                        //alert('if(prodFound)'+prodFound);
                        component.set("v.prodBarCodeValue",'');
                        component.set("v.productFoundFlag",true);
                        // alert('allProdPicked-->>'+allProdPicked);
                        if(allProdPicked){
                            
                            component.set("v.locBarCodeValue",'');
                            
                            var input = component.find("locScanedCode"); 
                           // alert('input-->>'+input);
                            input.focus ();
                            
                        }
                        else if(alreadyScanned) {
                                     component.set("v.locBarCodeValue",'');
                                    component.set("v.scannedProductName",'product is alredy scanned');
                                   
                                }
                        window.setTimeout(
                            $A.getCallback(function() {
                                /*if(alreadyScanned) {
                                     component.set("v.locBarCodeValue",'');
                                    component.set("v.scannedProductName",'product is alredy picked');
                                   
                                }*/
                                   
                                component.set("v.locationFoundFlag",false);
                            }), 3000
                        );
                    } else
                    {
                       // alert('if(Not prodFound)'+prodFound);
                        component.set("v.scannedProductName",'Not Found');
                        component.set("v.productFoundFlag",true);
                        window.setTimeout(
                            $A.getCallback(function() {
                                if(!component.get('v.prodBarCodeValue'))
                                    component.set("v.productFoundFlag",false);
                            }), 3000
                        );
                    }
                    
                  //  alert('allProdPicked-->>>::'+allProdPicked);
                  if(allProdPicked){
                        
                        var allProductsRecieved=true;
                        for(var i=0;i<wrapper.eachWrapperLineItem.length;i++)
                        {
                            var updpickqty=wrapper.eachWrapperLineItem[i].pickqtydisplay;
                          //  alert('updpickqty--->>>'+wrapper.eachWrapperLineItem[i].pickqtydisplay);
                            for(var j=0;j<wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper.length;j++)
                            {
                                var pickqty=wrapper.eachWrapperLineItem[i].eachLineItemILPLIWrapper[j].pickQty;
                                
                               // alert('pickqty------------2>>>'+pickqty);
                                if(updpickqty!=pickqty)
                                {
                                    allProductsRecieved=false;
                                }
                            }
                        }
                     //   alert('allProductsRecieved:---->>>:'+allProductsRecieved);
                        if(allProductsRecieved){
                            var resultsToast = $A.get("e.force:showToast");
                            resultsToast.setParams({
                                "type": "success",
                                "message": "All Products Picked Successfully. Now you can click on submit"
                            });
                            resultsToast.fire();
                            component.find("locScanedCode").blur();
                            component.set("v.IsShowAndHidAutoPick",true);
                            
                        }
                        else{
                            
                            var resultsToast = $A.get("e.force:showToast");
                            resultsToast.setParams({
                                "type": "success",
                                "message": "Product '"+allPickedProdName+"' checked completely. You can proceed to the next Bin"
                            });
                            resultsToast.fire();
                            
                        }
                    }
                }
            }), 1000
        );
    },
})