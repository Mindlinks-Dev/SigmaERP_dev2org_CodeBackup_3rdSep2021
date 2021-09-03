({
    editFlow: function(component, event, helper) {
        var siList = event.getParam("stockIn");
        var srList = event.getParam("srlno");
        component.set("v.rowIndexVar",event.getParam("rowIndex"));
        component.set("v.indexes",event.getParam("index"));
        component.set("v.StockInProductPopup",siList);
        component.set("v.recordName1",siList.Pur_Order_Name);
        component.set("v.recordName2",siList.PO_Name);
        component.set("v.recordName3",siList.Loc_Name);
        component.set("v.lotRecord",siList.Lot_Name);
        
        component.set("v.StockInProductPopup.sigmaerpdev__Pur_Order__c",siList.sigmaerpdev__Pur_Order__c);
        if(srList!= undefined)
        {
            component.set("v.PSerialNumber",srList);
        }
        
        if(siList.Attribute_type == 'SERIALIZED'){
           
            
            component.set("v.productId",siList.sigmaerpdev__Product__c); 
            if(siList.sigmaerpdev__Product__c==undefined)
            {
                component.set("v.productId",siList.sigmaerpdev__Purchase_Order__r.sigmaerpdev__Product__c);
            }
            var btn = component.find('serialBtn');
            $A.util.removeClass(btn, "slds-hide");
            
        }
        else{
          
            component.set("v.productId",siList.sigmaerpdev__Product__c);
            if(siList.sigmaerpdev__Product__c==undefined)
            {
                component.set("v.productId",siList.sigmaerpdev__Purchase_Order__r.sigmaerpdev__Product__c);
                
            }
            var btn = component.find('serialBtn');
            $A.util.addClass(btn, "slds-hide");
            
        }
    },
    
   
    
    doInit : function(component, event, helper) {
        
        var btn = component.find('serialBtn');
        $A.util.addClass(btn, "slds-hide");
        
        component.set("v.PSerialNumber",component.get("v.PSNumber"));
      
        var StockInProductList = component.get("v.StockInProductPopup");
        component.set("v.StockInProductPopup.sigmaerpdev__Quantity_Received__c",'');
        component.set("v.StockInProductPopup.sigmaerpdev__Status__c",'');
        
        var action1 = component.get("c.getStockInProductStatus");
        action1.setCallback(this, function(res) {
            component.set("v.status", res.getReturnValue());
          
            component.set("v.StockInProductPopup",component.get("v.StockInProductPopup"));
            
            
            
        });
        $A.enqueueAction(action1); 
        
    },
    SelectedID:function(component,event,helper)
    {
        var  context = event.getParam("instanceId");
        var  objectId = event.getParam("sObjectId");
        var  objectLabel = event.getParam("objectLabel");
        var  sInPro=component.get("v.StockInProductPopup");

        
        if(context =='POrder')
        {
            sInPro.sigmaerpdev__Pur_Order__c=objectId;
            sInPro.Pur_Order_Name= objectLabel;
           
             component.set("v.recordName2",' ');
            component.set("v.lotRecord",' ');
            component.set("v.StockInProductPopup.sigmaerpdev__Lot__c",null);
             component.set("v.StockInProductPopup.Lot_Name",' ');
            
        }
        else if(context== 'POProduct')
        {
       
            sInPro.sigmaerpdev__Purchase_Order__c=objectId;
            
            sInPro.PO_Name = objectLabel;
            var action = component.get("c.getSerialized"); 
            action.setParams({"Id":objectId});
            action.setCallback(this, function(a) {
                var res = a.getReturnValue();  
              
                sInPro.Attribute_type=res.sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c;
              
                if(res.sigmaerpdev__Product__r.sigmaerpdev__Attribute_Type__c == 'SERIALIZED'){
                    
                    component.set("v.productId",res.sigmaerpdev__Product__c); 
                    sInPro.sigmaerpdev__Product__c = res.sigmaerpdev__Product__c;  
                    
                    var btn = component.find('serialBtn');
                    $A.util.removeClass(btn, "slds-hide");
                    
                }
                else{
                    
                    component.set("v.productId",res.sigmaerpdev__Product__c);
                    sInPro.sigmaerpdev__Product__c = res.sigmaerpdev__Product__c;
                    var btn = component.find('serialBtn');
                    $A.util.addClass(btn, "slds-hide");
                    
                }
            }) 
            $A.enqueueAction(action); 
            
            var action1 = component.get("c.getOrderedQuantity"); 
            action1.setParams({"Id":objectId});
            action1.setCallback(this, function(a) {
                var res = a.getReturnValue();
               component.set("v.POPQuantity",res);
                sInPro.Qty = res;
            }) 
            $A.enqueueAction(action1); 
            
        }else if(context=='MyAccount3')
        {
            sInPro.sigmaerpdev__Putaway_location__c=objectId;
            sInPro.Loc_Name = objectLabel;
            
        }else if(context=='Lot')
        {
            sInPro.sigmaerpdev__Lot__c = objectId;
            sInPro.Lot_Name = objectLabel;
        }
        
        
    },
    saveStatus : function(cmp,event,helper)
    {
        cmp.set("v.StockInProduct.sigmaerpdev__Status__c",cmp.find("status").get("v.value")); 
    },
    showOppmodal: function(component, event, helper) {
        
        var logisticName = component.find('ReceivingLocation');
        var logName = logisticName.get('v.searchString'); 
        var QReceived=component.find("QReceived").get("v.value");
       if(QReceived == '')
        {
            alert("Please enter Quantity Received.");
            return null; 
            
        }else if(QReceived <= 0)
        {
            alert("Please enter Quantity received greater than zero.");
            return null; 
            
        }else
        {
            
            var QReceived=component.find("QReceived").get("v.value");
          
            var ProductSNList = component.get("v.PSerialNumber");
          
            component.set("v.completePSNumber",ProductSNList);  
            var comPSN=component.get("v.completePSNumber");
            var lenPSN=comPSN.length;;
           if(lenPSN == 0)
            {
              
                if(QReceived > 0 )
                {
                    var btn = component.find('snbutton');
                    $A.util.addClass(btn, "slds-hide");
                    var cmpMsg = component.find("msg");
                    $A.util.addClass(cmpMsg, 'slds-hide');
                    var ProductSerialNumberList = component.get("v.PSerialNumber");
                    for(var i=1;i<=QReceived;i++)
                    {
                        ProductSerialNumberList.push({
                            'sigmaerpdev__Code__c':'',
                            'sigmaerpdev__Purchase_Order__c': '',
                            'sigmaerpdev__Product_Code__c': '',
                            'sigmaerpdev__Location__c':'',
                            'sigmaerpdev__Serial_Number__c':'',
                            'sigmaerpdev__Stock_Receiving_Product__c': component.get("v.index")
                        });                
                    } 
                    component.set("v.PSerialNumber",ProductSerialNumberList); 
                   
                    helper.showPopupHelper(component, 'modaldialog', 'slds-fade-in-');
                    helper.showPopupHelper(component,'backdrop','slds-backdrop--');
                    
                }
                
            }else
            {
                //alert("inside else");
                var PSNlist=[];
                var poname1=component.get("v.POName");
                var popname1=component.get("v.POPName");
                
                if(poname1 != "" && popname1 != "")
                {
                    
                    var action = component.get("c.getProductPSN");
                   action.setParams({"stockRPId":JSON.stringify(component.get("v.PurchageOrder")) });
                    action.setCallback(this, function(a) {
                        var state = a.getState();
                        if(state=='SUCCESS') 
                        {
                            
                            var inpsnlist=a.getReturnValue();
                            
                            for(var k=0; k<inpsnlist.length;k++){
                            PSNlist.push(inpsnlist[k]); 
                            }
                            component.set("v.PSerialNumber",PSNlist); 
                            
                            if(parseInt(QReceived) > parseInt(PSNlist.length)){
                               
                                var noOfRow=parseInt(QReceived) - parseInt(PSNlist.length);
                               
                                component.set("v.psnadd",noOfRow);  
                                var btn = component.find('snbutton');
                                $A.util.removeClass(btn, "slds-hide");
                                var cmpMsg = component.find("msg");
                                $A.util.removeClass(cmpMsg, 'slds-hide');
                            }else
                            {
                             
                                var btn = component.find('snbutton');
                                $A.util.addClass(btn, "slds-hide");
                                var cmpMsg = component.find("msg");
                                $A.util.addClass(cmpMsg, 'slds-hide');   
                            }
                            helper.showPopupHelper(component, 'modaldialog', 'slds-fade-in-');
                            helper.showPopupHelper(component,'backdrop','slds-backdrop--');    
                        }
                    });
                    $A.enqueueAction(action);     
                   
                }else
                {
                    var PSNList=component.get("v.DummyPSNumber");
                   
                    var evetlist=[];
                    component.set("v.DummyPSNumber",evetlist);
                    var psn=component.get("v.Id");
                    var comPSN=component.get("v.completePSNumber"); 
                    if(psn=='' || psn!='')
                    { 
                        
                        var QReceived=component.find("QReceived").get("v.value");
                        if(parseInt(QReceived) > parseInt(comPSN.length))
                        {
                            var btn = component.find('snbutton');
                           
                            $A.util.removeClass(btn, "slds-hide");
                            
                            var noOfRow=parseInt(QReceived) - parseInt(comPSN.length);
                       
                            component.set("v.psnadd",noOfRow);  
                           var cmpMsg = component.find("msg");
                            $A.util.removeClass(cmpMsg, 'slds-hide');
                        }
                        for(var i=0;i<comPSN.length;i++)
                        {
                          
                            PSNList.push(comPSN[i]);
                        }
                     
                        for(var j=0;j<noOfRow;j++)
                        {
                         
                            PSNList.push({
                                'sigmaerpdev__Code__c':'',
                                'sigmaerpdev__Purchase_Order__c': '',
                                'sigmaerpdev__Product_Code__c': '',
                                'sigmaerpdev__Location__c':'',
                                'sigmaerpdev__Stock_Receiving_Product__c': component.get("v.index")
                            });
                        }
                      
                        var ProductSerialNumberList = component.get("v.PSerialNumber");
                    }
                    component.set("v.PSerialNumber",PSNList); 
                   var test = component.get("v.PSerialNumber");     
                    helper.showPopupHelper(component, 'modaldialog', 'slds-fade-in-');
                    helper.showPopupHelper(component,'backdrop','slds-backdrop--');
                }
            }
        }
    },
    hidePopup:function(component, event, helper)
    {
        helper.hidePopupHelper(component, 'modaldialog', 'slds-fade-in-');
        helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--'); 
        
        
     /*   var psn=component.get("v.Id");
       
         var isEmpty;
     	
            isEmpty = true;
            var serialNoLst = component.get("v.PSerialNumber");
           
            for(var i=0;i<serialNoLst.length;i++){
               
                if(serialNoLst[i].sigmaerpdev__Serial_Number__c != '' &&serialNoLst[i].sigmaerpdev__Product_Code__c=='')
                {
                    serialNoLst[i].sigmaerpdev__Serial_Number__c='';
                   // isEmpty = false;
                    //break;
                }
            }
           
            if(isEmpty == true){
                 
                serialNoLst.splice(0,serialNoLst.length);
                 
                component.set("v.PSerialNumber",serialNoLst);
            }*/
      //  }
        
    },
    
    handleRemoveProductItemClick : function(component, event, helper) {
        
        var self = this;  // safe reference
        var index = event.target.dataset.index;
        helper.removeProductItem(component, index);
    },
    saveProductSerialNumber:function(component,event,helper)
    {
        var ProductId;
        var  sInPro=component.get("v.StockInProductPopup");
        var POPID=sInPro.sigmaerpdev__Purchase_Order__c;
        var validatePSN=component.get("v.PSerialNumber");
       
        for(var i=0 ;i < validatePSN.length;i++)
        {
            if(parseInt(validatePSN[i].sigmaerpdev__Serial_Number__c) <= 0 )
            { 
                var msg = "Enter valid serial number at line number "+(i+1);
                component.set("v.errorMsgs", msg);
                component.set("v.isErrors",true);
                return;
            }else
            {
                
                component.set("v.isErrors",false);
                component.set("v.errorMsgs", "");  
            }
            
            if(validatePSN[i].sigmaerpdev__Serial_Number__c == undefined || validatePSN[i].sigmaerpdev__Serial_Number__c == ''){
                var msg = "Please Enter the Serial Number at line "+(i+1);
                component.set("v.errorMsgs", msg);
                component.set("v.isErrors",true);
                validatePSN[i].sigmaerpdev__Serial_Number__c = '';
                return;
            } 
        }
         var validatePSNlist=component.get("v.ProductSerNumberList");
             var validatePSN=component.get("v.PSerialNumber");
        var proid= component.get("v.productId");
         for(var i=0 ;i < validatePSNlist.length;i++)
          {
              for(var k=0 ;k < validatePSN.length;k++)
              {
                  if((parseInt(validatePSNlist[i].sigmaerpdev__Serial_Number__c) == validatePSN[k].sigmaerpdev__Serial_Number__c || validatePSNlist[i].sigmaerpdev__Serial_Number__c == validatePSN[k].sigmaerpdev__Serial_Number__c) && validatePSNlist[i].sigmaerpdev__Product_Code__c== proid)
                    {
                   
                        var msg = "Should not take duplicate serial number at line "+(k+1);
                        component.set("v.errorMsgs", msg);
                        component.set("v.isErrors",true);
                        return;
                    }else
                    {
                                
                        component.set("v.isErrors",false);
                        component.set("v.errorMsgs", ""); 
                    }             
                               
              }
          }
        var action1 = component.get("c.checkDuplicateProductPSN"); 
        action1.setParams({"validatePSN":JSON.stringify(validatePSN),"ProductID":sInPro.sigmaerpdev__Product__c});
        action1.setCallback(this, function(a) {
            var state = a.getState();
            var valipsn=a.getReturnValue();
            for(var i=0 ;i < validatePSN.length;i++)
            {		
                for(var k=0;k<valipsn.length;k++)
                {    
                    if((parseInt(validatePSN[i].sigmaerpdev__Serial_Number__c) == valipsn[k].sigmaerpdev__Serial_Number__c || validatePSN[i].sigmaerpdev__Serial_Number__c == valipsn[k].sigmaerpdev__Serial_Number__c) && validatePSN[i].Id == undefined) 
                    {
                        
                        var msg = "Should not take duplicate serial number at line "+(i+1);
                        component.set("v.errorMsgs", msg);
                        component.set("v.isErrors",true);
                        return;
                    }else
                    {
                        
                        component.set("v.isErrors",false);
                        component.set("v.errorMsgs", ""); 
                    }
                    
                }
            }
            for(var i=0 ;i < validatePSN.length;i++)
            {
                for(var k=i+1 ;k < validatePSN.length;k++)
                {
                    if((parseInt(validatePSN[i].sigmaerpdev__Serial_Number__c) == validatePSN[k].sigmaerpdev__Serial_Number__c || validatePSN[i].sigmaerpdev__Serial_Number__c == validatePSN[k].sigmaerpdev__Serial_Number__c) && validatePSN[i].Id == undefined) 
                    {
                        
                        var msg = "Should not take duplicate serial number at line "+(i+1);
                        component.set("v.errorMsgs", msg);
                        component.set("v.isErrors",true);
                        return;
                    }else
                    {
                        
                        component.set("v.isErrors",false);
                        component.set("v.errorMsgs", ""); 
                    }
                }
            }
           
            var action = component.get("c.getProductId"); 
            action.setParams({"POPNumber":POPID});
            
            action.setCallback(this, function(a) {
                var state = a.getState();
               if(state=='SUCCESS') 
                {
                    ProductId=a.getReturnValue();
                    var savePSerialNumber=component.get("v.PSerialNumber");
                    var  sInPro=component.get("v.StockInProductPopup");
                    //alert('sInPro::'+JSON.stringify(sInPro));
                    var  slen=savePSerialNumber.length;
                    for(var i=0; i < slen;i++)
                    {  
                        savePSerialNumber[i].sigmaerpdev__Stock_Receiving_Product__c = sInPro.Id; 
                        savePSerialNumber[i].sigmaerpdev__Location__c=sInPro.sigmaerpdev__Putaway_location__c;
                        savePSerialNumber[i].sigmaerpdev__Purchase_Order__c=sInPro.sigmaerpdev__Pur_Order__c;  
                        savePSerialNumber[i].sigmaerpdev__Purchase_Order_Product__c=sInPro.sigmaerpdev__Purchase_Order__c;
                        savePSerialNumber[i].sigmaerpdev__Product_Code__c=ProductId;
                       //savePSerialNumber[i].count=23;
                     }
                    component.set("v.PSerialNumber",savePSerialNumber);
                    
           // alert('validatePSNlist::'+JSON.stringify(validatePSNlist));
           //alert('validatePSN::'+JSON.stringify(validatePSN));
       
                    helper.hidePopupHelper(component, 'modaldialog', 'slds-fade-in-');
                    helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--'); 
                    
                }
			 });
            $A.enqueueAction(action);
             
          });
        $A.enqueueAction(action1);
        
       },
    
    upsertProductID:function(component, POPID, callback) {
        var action = component.get("c.getProductId"); 
        action.setParams({ "POPNumber":POPID
                         });
        action.setCallback(this, function(a) {
            
            var status=a.getReturnValue();
        });
        $A.enqueueAction(action);
        
        
    },
    QRecived:function(component,event,helper){
        
        var QReceived=component.find("QReceived").get("v.value");
        var RQuantity=component.find("RQuantity").get("v.value");  
        if(QReceived !=undefined && RQuantity !=undefined) 
        {
            if(RQuantity >= 0)
            {
                //alert('grater than zero');
            }else
            {
                alert('Should not take negative value.');
            }
            
            if( RQuantity > QReceived )
            {
                
                alert('Return quantity is less than Quantity recevied .');
                return null;   
            }
        }
    },
    
    QuantityReceived:function(component,event,helper)
    {
        var QReceived=component.find("QReceived").get("v.value"); 
        var POPQuantity=component.get('v.POPQuantity');
        
        if(QReceived !=undefined)
        {
            if(QReceived >= 0)
            {
             
            }else
            {
                alert('Should not take negative value.');
            }
            
        } 
    },
    Addmoreserialnumber:function(component,event,helper)
    {
        var QReceived=component.find("QReceived").get("v.value");  
        
        var PSNList=component.get("v.PSerialNumber");
        var evetlist=[];
        component.set("v.DummyPSNumber",evetlist);
        var psn=component.get("v.Id");
        
        var comPSN=component.get("v.completePSNumber");
        var noOfRow=parseInt(QReceived) - parseInt(comPSN.length);
        for(var i=1;i<=parseInt(noOfRow);i++)
        {  
            PSNList.push({
                'sigmaerpdev__Code__c':'',
                'sigmaerpdev__Purchase_Order__c': '',
                'sigmaerpdev__Product_Code__c': '',
                'sigmaerpdev__Location__c':'',
                'sigmaerpdev__Stock_Receiving_Product__c': component.get("v.index")
            });
            
            
        } 
        component.set("v.PSerialNumber",PSNList); 
        var btn = component.find('snbutton');
        $A.util.addClass(btn, "slds-hide");
        var cmpMsg = component.find("msg");
        $A.util.addClass(cmpMsg, 'slds-hide');
    },
    clearLookup:function(cmp,event){
        
        var  context = event.getParam("instanceId");
        if(context == 'POrder'){
            var stnp = cmp.get("v.StockInProduct");
            stnp.sigmaerpdev__Pur_Order__c = '';
        }
        if(context == 'POProduct'){
            var stnp = cmp.get("v.StockInProduct");
            stnp.sigmaerpdev__Purchase_Order__c = '';
        }        
        if(context == 'MyAccount3'){
            var stnp = cmp.get("v.StockInProduct");
            stnp.sigmaerpdev__Putaway_location__c = '';
        }
        if(context == 'Lot'){
            var stnp = cmp.get("v.StockInProduct");
            stnp.sigmaerpdev__Lot__c = '';
        }		
        
    },
    addProducts : function(component, event, helper) {
        
        var addprod = component.find("modal");
        var backdrop = component.find("slds-backdrop");
        
        $A.util.removeClass(addprod, " slds-fade-in-close");
        $A.util.addClass(addprod, " slds-fade-in-open"); 
        
        $A.util.removeClass(backdrop, " slds-backdrop--close");
        $A.util.addClass(backdrop, " slds-backdrop--open");
    },
    submit : function(component, event, helper) {
        
        var Popupval = component.get("v.StockInProductPopup");
        component.set("v.StockInProduct",Popupval);
        var StkPrdList =  component.get("v.StockInProduct");
        var Quantitylist=component.get("v.POPQuantity");
         var serialnolist=component.get("v.PSerialNumber");
		var isloc=component.get("v.isloc");      
       
         var po = component.find('PurchaseOrder{!v.index}');        
        var poName = po.get('v.searchString');
        var pop = component.find('Purchase_Order_Product{!v.index}');        
        var popName = pop.get('v.searchString');
         var StkList =  component.get("v.StockInProductlist");
         //var valStockInProd=component.get("v.StockInProduct");
         var listindex=component.get("v.rowIndexVar");
       //alert('serialnolist::'+JSON.stringify(serialnolist[0].sigmaerpdev__Serial_Number__c));
           for( var i=0;i<serialnolist.length;i++)
            {
                
                if(serialnolist[i].sigmaerpdev__Location__c!= Popupval.sigmaerpdev__Putaway_location__c)
                {
                   
                   serialnolist[i].sigmaerpdev__Location__c= Popupval.sigmaerpdev__Putaway_location__c; 
                 
                }
               
                if(serialnolist[i].sigmaerpdev__Serial_Number__c==undefined && i!=0 &&serialnolist[i-1].sigmaerpdev__Serial_Number__c!=undefined)
                {
                    var msg = "Enter all serial numbers";
                    component.set("v.errorMsg", msg);
                    component.set("v.isError",true);
                    return;
                }
            }
      
         component.set("v.PSerialNumber",serialnolist);
         var serialno=component.get("v.PSerialNumber");
      
        if(poName =="" || poName==undefined ) 
        {
            
            var msg = "Select Stock Receiving Products for Purchase Order ";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        } if(popName =="" || popName==undefined) 
        {
            
            var msg = "Select Stock Receiving Products for Purchase Order Product ";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        
        
        
        if(Popupval.sigmaerpdev__Quantity_Received__c ==="") 
        {
            
            var msg3 = "Select Stock Receiving Products for Quantity Received ";
            component.set("v.errorMsg", msg3);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        
        if(Popupval.Loc_Name =="") 
        {
            
            var msg = "Please Select Actual location.";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        } 
        if(Popupval.Status__c ==""|| Popupval.sigmaerpdev__Status__c === '--Select--') 
        {
            
            var msg = "Select Stock Receiving Product Status ";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        if(parseInt(Popupval.sigmaerpdev__Quantity_Received__c) <=0)
        { 
            
            var msg = "Please enter valid received quantity ";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }else
        {
            
            component.set("v.isError",false);
            component.set("v.errorMsg", "");  
        }
        
        if(isNaN(Popupval.sigmaerpdev__Quantity_Received__c) )
        { 
            
            var msg = "Should not take charecter Quantity Received";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return;
        }else
        {
            
            component.set("v.isError",false);
            component.set("v.errorMsg", "");  
        }
        
        if(parseInt(Quantitylist,10) < parseInt(Popupval.sigmaerpdev__Quantity_Received__c,10) ||parseInt(Popupval.Qty,10) < parseInt(Popupval.sigmaerpdev__Quantity_Received__c,10))
        {
          
            var msg9 = "Received Quantity should be less than or equal to Ordered Quantity,Ordered Quantity:"+Popupval.Qty;
            component.set("v.errorMsg", msg9);
            component.set("v.isError",true);
            return;
        }
        else{
           
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
        //alert('serialno.length'+JSON.stringify(serialno));
        //alert('serialno.length'+serialno.length);
        //alert('StkPrdList.Attribute_type'+JSON.stringify(StkPrdList));
        //alert('Popupval.sigmaerpdev__Quantity_Received__c'+Popupval.sigmaerpdev__Quantity_Received__c);
         if(Popupval.Attribute_type =='SERIALIZED' && serialno.length !=Popupval.sigmaerpdev__Quantity_Received__c && serialno.length!=0 )
        {
            var msg = "Entered serial number and received Quantity are miss matched";
            component.set("v.errorMsg", msg);
            component.set("v.isError",true);
            return; 
        }
        else{
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
       
          for(var i=0;i<StkList.length;i++)
          {
               
              if(StkList[i].sigmaerpdev__Pur_Order__c==Popupval.sigmaerpdev__Pur_Order__c && StkList[i].sigmaerpdev__Purchase_Order__c==Popupval.sigmaerpdev__Purchase_Order__c&& StkList[i].sigmaerpdev__Putaway_location__c==Popupval.sigmaerpdev__Putaway_location__c && i!=listindex)
                       {
                           
                            var msg11 = "Duplicate Purchase Order Exist for same location.";
                            component.set("v.errorMsg", msg11);
                            component.set("v.isError",true);
                            return;
                       }
             
                      else{
                            component.set("v.isError",false);
                            component.set("v.errorMsg", "");
            			}   
          }
         component.set("v.isloc",true);
       // alert('serialno'+JSON.stringify(serialno));
        var compEvent = component.getEvent("carryStockInList");
        compEvent.setParams({"siList" : StkPrdList,"isEdit":true,"srlList" : serialno,
                             "rowIndex":component.get("v.rowIndexVar"),"index":component.get("v.indexes")});
        compEvent.fire();
        
        component.set("v.isOpenchild", false);
        component.set("v.isOpenTablechild", true);
    },
    close : function(component,event,helper)
    {
        var addprod = component.find("modal");
        var backdrop = component.find("slds-backdrop");
        
        $A.util.addClass(addprod, " slds-fade-in-close");
        $A.util.removeClass(addprod, " slds-fade-in-open"); 
        
        $A.util.addClass(backdrop, " slds-backdrop--close");
        $A.util.removeClass(backdrop, " slds-backdrop--open");
    },
    closeModel1: function(component, event, helper) {
        
        component.set("v.isOpenchild", false);
        
    },
      validateQuantity : function (cmp,event)
    {
       var Stockproduct = cmp.get("v.StockInProductPopup"); 
        var remainingqty=Stockproduct.RemainQty-Stockproduct.sigmaerpdev__Quantity_Received__c;
       cmp.set("v.StockInProductPopup.RemainQty",remainingqty); 
    }
    
})