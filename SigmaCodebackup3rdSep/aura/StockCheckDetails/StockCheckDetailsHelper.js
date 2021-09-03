({ 
    fetchIlpListBasedOnLocationName:function(component, event, helper,recID)
    {  
        //component.set("v.ilid",objectId); 
        //component.set("v.showBarCodeFlg", true); //to hide or show Scan barcode checkbox - added on 12/11/2019
        var TotalQty =0;
        var action = component.get("c.fetchselectILP");
        // alert('recID>>>'+recID);	
        //alert(JSON.stringify(component.get("v.ilid"))); 
        action.setParams({            
            
            "locname" : recID
        });
        action.setCallback( this, function(a) 
                           {
                               var state = a.getState();
                               //alert('state>>>>'+state);
                               if (state === "SUCCESS") 
                               {
                                   if(a.getReturnValue() !== null)
                                   {
                                       
                                       var temp = a.getReturnValue();
                                       /// alert('temp2'+JSON.stringify(temp));
                                       //component.set("v.ILPlist", temp);
                                       
                                       //	var StockCheck = []; //code commented bcz throwing Reason_code Undefined error msg in component
                                       //component.set("v.StockCheckDetails","");
                                       //alert('StockCheck>>>'+component.get("v.StockCheckDetails"));
                                       var StockCheck = [];
                                       //  alert('StockCheck>>>'+StockCheck);
                                       for(var i=0; i<temp.length;i++){
                                           
                                           TotalQty = temp[i].sigmaerpdev2__Net_Quantity__c + temp[i].sigmaerpdev2__Delivered_Quantity__c; 
                                           //alert(TotalQty);        
                                           StockCheck.push({                                               
                                               'sigmaerpdev2__Inventory_Location_Product__c' : temp[i].Id,
                                               'ilpName' : temp[i].Name,
                                               'sigmaerpdev2__Product__c' : temp[i].sigmaerpdev2__Products__c,
                                               'prodName' : temp[i].sigmaerpdev2__Products__r.Name,
                                               'sigmaerpdev2__Inventory_Location__c': temp[i].sigmaerpdev2__Inventory_Location__c,
                                               'Loc':temp[i].sigmaerpdev2__Inventory_Location_Name__c,
                                               'sigmaerpdev2__Available_Quantity__c' : temp[i].sigmaerpdev2__Net_Quantity__c ,
                                               'sigmaerpdev2__Stock_Check_Quantity__c' : (!!temp[i].sigmaerpdev2__Stock_Check_Quantity__c)? temp[i].sigmaerpdev2__Stock_Check_Quantity__c : 0 ,
                                               //'sigmaerpdev2__Stock_Check_Quantity__c' : temp[i].sigmaerpdev2__Net_Quantity__c ,	
                                               //'sigmaerpdev2__Reason_Code__c' :'',
                                               'sigmaerpdev2__StockCheckbox__c':'',
                                               'prodBarCode': temp[i].sigmaerpdev2__Products__r.sigmaerpdev2__Product_Bar_Code__c
                                               
                                           });
                                           
                                       } 
                                       //alert('push val..2'+JSON.stringify(StockCheck));
                                       component.set("v.StockCheckDetails",StockCheck);
                                       
                                       //	alert(' new StockCheckDetails>>'+JSON.stringify(component.get("v.StockCheckDetails")));
                                       
                                       
                                   } 
                                   else{
                                       alert('Fetching ILP data Failed');
                                   }   
                               }
                               else
                               {
                                   alert('Fetching ILP data Failed');
                               }                              
                           }); 
        $A.enqueueAction(action);  
    },
    getStockList:function(component, event){
        // alert('called by controller class');
        var TotalQty =0;
        var action = component.get("c.fetchILP");
        // alert('fetchILP>>>'+JSON.stringify(component.get("c.fetchILP")));
        
        
        action.setCallback( this, function(a) 
                           {
                               var state = a.getState();
                               if (state === "SUCCESS") 
                               {
                                   //alert('state>>>'+state);
                                     //alert('a.getReturnValue()>>>'+a.getReturnValue());
                                   if(a.getReturnValue()!==null)
                                   {
                                       
                                       var temp = a.getReturnValue();
                                       //alert('temp1>>>'+JSON.stringify(temp));
                                       //component.set("v.ILPlist", temp);
                                       var StockCheck = [];
                                       //var StockCheck = component.get("v.StockCheckDetails");
                                       //alert('StockCheck1>>>'+JSON.stringify(StockCheck));
                                       for(var i=0; i<temp.length;i++){
                                           
                                           TotalQty = temp[i].sigmaerpdev2__Net_Quantity__c + temp[i].sigmaerpdev2__Delivered_Quantity__c; 
                                           //alert(TotalQty);
                                           StockCheck.push({                                               
                                               'sigmaerpdev2__Inventory_Location_Product__c' : temp[i].Id,
                                               'ilpName' : temp[i].Name,
                                               'sigmaerpdev2__Product__c' : temp[i].sigmaerpdev2__Products__c,
                                               'prodName' : temp[i].sigmaerpdev2__Products__r.Name,
                                               'sigmaerpdev2__Inventory_Location__c': temp[i].sigmaerpdev2__Inventory_Location__c,
                                               'Loc':temp[i].sigmaerpdev2__Inventory_Location_Name__c,
                                               'sigmaerpdev2__Available_Quantity__c' : temp[i].sigmaerpdev2__Net_Quantity__c ,
                                               'sigmaerpdev2__Stock_Check_Quantity__c' : (!!temp[i].sigmaerpdev2__Stock_Check_Quantity__c)? temp[i].sigmaerpdev2__Stock_Check_Quantity__c : 0 ,
                                               //'sigmaerpdev2__Stock_Check_Quantity__c' : temp[i].sigmaerpdev2__Net_Quantity__c ,	
                                               'sigmaerpdev2__Reason_Code__c' :'',
                                               'sigmaerpdev2__StockCheckbox__c':'',
                                               'prodBarCode': temp[i].sigmaerpdev2__Products__r.sigmaerpdev2__Product_Bar_Code__c
                                               
                                           });
                                           
                                       } 
                                       //  alert('push val..1'+JSON.stringify(StockCheck));
                                       component.set("v.StockCheckDetails",StockCheck);
                                       //   alert(' new StockCheckDetails1>>'+JSON.stringify(component.get("v.StockCheckDetails")));
                                       
                                       
                                   } else{
                                       alert('Fetching ILP data Failed1');
                                   }   
                               }
                               else
                               {
                                   alert('Fetching ILP data Failed2');
                               }
                               
                               
                           }); 
        
        // document.getElementById("Accspinner").style.display = "block";
        
        $A.enqueueAction(action);  
        
    },
    
    
    SaveHelperMethod:function(component, event) {
        component.set("v.loaded",'false');
        
        setTimeout(function(){  component.set("v.loaded",'true');}, 3000);
        //alert('test');
        var action = component.get("c.SaveStockCheck");		
        action.setParams({            
            "StockDetails" : JSON.stringify(component.get("v.StockCheckDetails")),
            "StockCheck" : component.get("v.StockCheck")
        });
        action.setCallback( this, function(a){
            var state = a.getState();
            if (state === "SUCCESS"){   
                
                if(a.getReturnValue() != null && a.getReturnValue() != undefined && a.getReturnValue() != ''){
                    alert('Stock check record created successfully.');
                    //alert(a.getReturnValue());
                    // window.location.href = "/" + a.getReturnValue();
                    //var temp = component.get("v.StockCheck.Id");
                    //window.location.href = "/one/one.app#/sObject/" +a.getReturnValue();
                    
                    if ((typeof sforce != 'undefined') && sforce && (!!sforce.one)) {
                        var temp = a.getReturnValue();
                        //alert(temp+temp);
                        sforce.one.navigateToSObject(temp);
                        //window.location.href = "/one/one.app#/sObject/" +a.getReturnValue();
                        /*alert('if');
                   var navEvt = $A.get("e.force:navigateToSObject");
                     alert(navEvt);
                       navEvt.setParams({
                           "recordId": a.getReturnValue(),
                           "slideDevName": "related"
                       });
                       navEvt.fire(); 
                       
                   
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": temp,
            "slideDevName": "related"
        });
        navEvt.fire();
                 */    
                    
                    //ForceUI.isSalesforce1() ? navigateToSObject(temp) : (window.location.href='/' + temp); 
                }
                  
                  else{
                      //window.location.href = "/" + a.getReturnValue();
                      //commented above line and added below line to redirect back to StockMngmtMod UI page after record is created.
                      
                      var evt = $A.get("e.force:navigateToComponent");
                      evt.setParams({
                          componentDef : "c:StockManagementModules",
                          componentAttributes: {
                              from : 'StkCHK',
                              stkChkId : a.getReturnValue()
                          }
                      });
                      evt.fire();   
                  }      
                  
              }
              else{
                  alert('Record creation failed,please check atleast in One ILP');
                  document.getElementById("Accspinner").style.display = "none";
                  
              }
          }
          
      });
      $A.enqueueAction(action); 
  },
    
})