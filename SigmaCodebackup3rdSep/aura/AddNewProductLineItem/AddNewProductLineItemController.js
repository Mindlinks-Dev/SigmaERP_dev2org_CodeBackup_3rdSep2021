({
    AddNewRow : function(component, event, helper){
       // fire the AddNewRowEvt Lightning Event 
        component.getEvent("AddRowEvt").fire();     
    },
    
    doInit : function(component, event, helper){
       // alert('inside child');
        var today = new Date();
        component.set('v.LocationInstance.sigmaerpdev2__Last_Updated_Date__c', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        component.set('v.LocationInstance.sigmaerpdev2__Current_Stock__c',0);
         component.set('v.LocationInstance.sigmaerpdev2__Buying_Price__c',0);
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
            component.set("v.LocationInstance.sigmaerpdev2__Last_Updated_Date__c",today); 
            return false;
        }
        
    },
    removeRow : function(component, event, helper){
       
      
        component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex"),"AllRowsList" : component.get("v.LocationInstanceInner")}).fire();
    }, 
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        // get the all List (contactList attribute) and remove the Object Element Using splice method    
        alert(index);
        var AllRowsList = component.get("v.LocationInstance.lStrings");
      alert('AllRowsListfromchild>>'+JSON.stringify(AllRowsList))
        AllRowsList.splice(index, 1);
        // set the contactList after remove selected row element  
        component.set("v.LocationInstance.lStrings", AllRowsList);
     
    },
    changestock: function(component, event, helper){
        
        var index = component.get("v.rowIndex");
        var index1 =index+1;
       // alert('52>>>>>'+index)
       var AllRowsList = component.get("v.LocationInstance.lStrings");
         var ProductName= component.get("v.LocationInstance1.sigmaerpdev2__Product_Name__c");
        var productcode=component.get("v.productcodefromparent");
       var currentstock=component.get("v.LocationInstance.sigmaerpdev2__Current_Stock__c");
        var location=component.get("v.LocationInstanceInner");
        var AsOnDate=component.get("v.LocationInstance.sigmaerpdev2__Last_Updated_Date__c");
        
        var Buyingprice=component.get("v.LocationInstance.sigmaerpdev2__Buying_Price__c");
       var RowItemList = component.get("v.VPlistparamfromparent");
         
        RowItemList.push({
            'location':location,
            'sobjectType': 'sigmaerpdev2__Vendor_Product__c',
            'sigmaerpdev2__Product_Name__c': ProductName,
            'sigmaerpdev2__VendorProductCode__c': productcode,
            'sigmaerpdev2__Vendor_Location__c' :location,
             'sigmaerpdev2__Current_Stock__c': currentstock,
           
             'sigmaerpdev2__Last_Updated_Date__c':AsOnDate
        });
        //'sigmaerpdev2__Buying_Price__c':Buyingprice,
         component.set("v.VPlistparamfromparent", RowItemList);
            
     // alert('67>>>>'+JSON.stringify(component.get("v.VPlistparamfromparent")));
        
      
       
         if( currentstock<0 ){
              
          var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": " Current stock value Should not be negative at line"+ index1 + ".", 
                "type": "error"
            });
            toastEvent.fire();
      
           return; 
            }
     
    },
     changeprice: function(component, event, helper){
     
        var index = component.get("v.rowIndex");
         var index1 =index+1;
       var buyingprice=  component.find("price");
        //alert('108>>>>>'+index)
       
         var ProductName= component.get("v.LocationInstance1.sigmaerpdev2__Product_Name__c");
        var productcode=component.get("v.productcodefromparent");
       var currentstock=component.get("v.LocationInstance.sigmaerpdev2__Current_Stock__c");
        var Buyingprice=component.get("v.LocationInstance.sigmaerpdev2__Buying_Price__c");
        var location=component.get("v.LocationInstanceInner");
        var AsOnDate=component.get("v.LocationInstance.sigmaerpdev2__Last_Updated_Date__c");
        
         
         var RowItemList = component.get("v.VPlistparamfromparent");
           
            
             RowItemList.push({
           
             'location':location,
            'sobjectType': 'sigmaerpdev2__Vendor_Product__c',
            'sigmaerpdev2__Product_Name__c': ProductName,
            'sigmaerpdev2__VendorProductCode__c': productcode,
            'sigmaerpdev2__Vendor_Location__c' :location,
             'sigmaerpdev2__Current_Stock__c': currentstock,
            'sigmaerpdev2__Buying_Price__c':Buyingprice,
             'sigmaerpdev2__Last_Updated_Date__c':AsOnDate
             
        });
              component.set("v.VPlistparamfromparent", RowItemList);
             
       // alert('135>>>>'+JSON.stringify(component.get("v.VPlistparamfromparent")));
            
      if( Buyingprice<0 ){
              
          var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": " Price value Should not be negative at line at line"+ index1 + ".", 
                "type": "error"
            });
            toastEvent.fire();
      
           return; 
            }
     }
    
         
})