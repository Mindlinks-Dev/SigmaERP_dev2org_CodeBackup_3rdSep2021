({
    doInit : function(cmp, evt)
    {
       
        var wrapper =cmp.get("v.wrapper"); 
     
        
    },
    updateprice:function (component, event, helper){

        if(component.get("v.orderline.sigmaerpdev2__Quantity__c")!=null)
        {
           
           var totalprice=((component.get("v.orderline.sigmaerpdev2__Unit_Price__c")) * (component.get("v.orderline.sigmaerpdev2__Quantity__c")));   
           component.set("v.orderline.sigmaerpdev2__Price__c",(totalprice));

        }
        
        
    },
    Proposaleditflow: function(cmp, evt)
    {
        
        var popup = evt.getParam("popup");
       
        cmp.set("v.orderline",popup);
        cmp.set("v.ServiceConName",popup.contractname);
    },
    submit : function(component, event, helper) {
       
        var orderline = component.get("v.orderline");
	    if(orderline.sigmaerpdev2__Covered_under_Contract_Y_N__c==true && (orderline.sigmaerpdev2__Service_Contract__c == undefined || orderline.sigmaerpdev2__Service_Contract__c==''))
                {
                    component.set('v.isError', true);
                    component.set('v.errorMsg', 'Choose Service Contract');
                    return;    
                }
        var compEvent = component.getEvent("carryorderList");
        compEvent.setParams({"orderinfo" : orderline,
                             "rowIndex" : component.get("v.rowIndexVar")
                            });
        compEvent.fire();
        component.set("v.isOpenchild", false);
        component.set("v.isOpenTablechild", true);
        
        
    },
    cancel : function(component, event, helper) {
        component.set("v.isOpenchild", false); 
        
    },
    handleAccountIdUpdate : function(cmp, event, helper) {
        var accountId = event.getParam("sObjectId");
        //alert('accountId>>'+accountId);
        var customerAccountID = event.getParam("sObjectIdNew");
        var instanceId = event.getParam("instanceId");
        var  objectLabel = event.getParam("objectLabel");
        var orderline=cmp.get("v.orderline");
        if(instanceId === "SerCon")
          {
           cmp.set('v.orderline.sigmaerpdev2__Service_Contract__c', accountId);
           cmp.set('v.ContractId', accountId);  
              orderline.contractname=objectLabel;
              
           var action = cmp.get("c.getprice");
        action.setParams({
            "serviceid" : accountId,
             "proid" : orderline.sigmaerpdev2__Product__c,
        });
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                               if (state == 'SUCCESS')
                               {
                                   var wraplist = response.getReturnValue();
                                   orderline.sigmaerpdev2__Unit_Price__c=wraplist;
                                   orderline.sigmaerpdev2__Price__c=orderline.sigmaerpdev2__Quantity__c*wraplist;
                                  
                                   //SETTING UNIT PRICE FOR PRODUCT
                                   cmp.set("v.UnitPrice",wraplist);
                                   cmp.set("v.orderline", orderline);
                                   cmp.set("v.productrate1", orderline.sigmaerpdev2__Price__c);     
                               }
                           });
        
        $A.enqueueAction(action); 
                        
                    }
    },
    onCheck:function (component, event, helper)
    {
  
        var orderline=component.get("v.orderline");
        
        var bool = component.get("v.orderline.sigmaerpdev2__Covered_under_Contract_Y_N__c");
      
        if(bool ==false)
       {
          var action = component.get("c.getproductprice");
        action.setParams({
            
             "proid" : orderline.sigmaerpdev2__Product__c
        });
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                             
                               if (state == 'SUCCESS')
                               {
                                   var wraplist = response.getReturnValue();
                                  //SETTING UNIT PRICE FOR PRODUCT
                                   component.set("v.orderline.sigmaerpdev2__Unit_Price__c",wraplist);
                                   var unitprice=component.get("v.orderline.sigmaerpdev2__Unit_Price__c");
                                   var quantity = component.get("v.orderline.sigmaerpdev2__Quantity__c");
                                  var totalprice=unitprice*quantity;
                                  component.set("v.orderline.sigmaerpdev2__Price__c",totalprice);
                                  component.set("v.orderline.sigmaerpdev2__Service_Contract__c",'');
                                  component.set("v.orderline.contractname",'');
                                         
                               
                               } 
                           });
        
        $A.enqueueAction(action); 
                        
         }
        
        else if(bool == true)  
        {
            var contractname =component.get("v.ServiceConName");
            var contractId =component.get("v.ContractId");
            
            component.set("v.orderline.sigmaerpdev2__Unit_Price__c",""); //set back to empty
            component.set("v.orderline.sigmaerpdev2__Price__c",""); //set back to empty
            
           
            component.set("v.orderline.sigmaerpdev2__Service_Contract__c",contractId)
            component.set("v.orderline.contractname",contractname)
            
            if(component.get("v.ServiceConName") !=null)
            {               
              var unitprice = component.get("v.UnitPrice");
              
              var quantity =  component.get("v.orderline.sigmaerpdev2__Quantity__c");
              var totalprice = unitprice*quantity;
              component.set("v.orderline.sigmaerpdev2__Unit_Price__c",unitprice);
             component.set("v.orderline.sigmaerpdev2__Price__c",totalprice);
            }
        }
  },
     changeprice:function (component, event, helper){
        
        if(component.get("v.orderline.sigmaerpdev2__Quantity__c")!=null)
      {
       var totalprice=((component.get("v.orderline.sigmaerpdev2__Unit_Price__c")) * (component.get("v.orderline.sigmaerpdev2__Quantity__c")));   
        component.set("v.orderline.sigmaerpdev2__Price__c",parseInt(totalprice));
      }
        
    }
 
})