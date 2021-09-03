({
    doInit : function(cmp, evt)
    {
      
        var wrapper =cmp.get("v.wrapper");
       // alert('wrapper>'+JSON.stringify(wrapper));
        
        var discountmethod = cmp.get('v.disval');
        //code added to restrict the multiple discount type
        if(discountmethod == 'radio-1')
        {
            wrapper.lineitemDiscount = 0;
            wrapper.ilpUiList.locationDiscount=0;
        }
        else if(discountmethod == 'radio-2' && wrapper.ilpUiList != undefined)
        {
                     
            for(var i=0;i<wrapper.ilpUiList.length;i++)
                {
                    wrapper.ilpUiList[i].locationDiscount=0;
                }
            
        }
        else if(discountmethod == 'radio-3')
        {
           wrapper.lineitemDiscount = 0;
        }
        if(wrapper.ilpUiList==undefined)
        {
            cmp.set('v.isError', true);
            cmp.set('v.errorMsg', 'Product ILP is not available for selected date.');
            return;  
        }
        else
        {
            cmp.set("v.isError",false);
            cmp.set("v.errorMsg", "");
        }
        cmp.set("v.wrapper",wrapper);
//        alert('cmp@@'+JSON.stringify(cmp.get('v.wrapper')));
    },
    editFlow: function(cmp, evt)
    {
       var popup = evt.getParam("popup");
        cmp.set("v.wrapper",popup);
        cmp.set("v.rowIndexVar",evt.getParam("rowIndex"));
        var promap=cmp.get("v.Promap");
        for(var i=0;i<promap.length;i++)
        {
            if(promap[i].ProId==popup.LineItem.sigmaerpdev2__Product__c)
            {
                cmp.set("v.wrapper",promap[i]);  
            }
        }
       //code added to restrict the multiple discount type
         var discountmethod = cmp.get('v.disval');
        var wrapper =cmp.get("v.wrapper");
        if(discountmethod == 'radio-1')
        {
            wrapper.lineitemDiscount = 0;
            wrapper.ilpUiList.locationDiscount=0;
        }
        else if(discountmethod == 'radio-2')
        {
          // wrapper.ilpUiList.locationDiscount=0;
            for(var i=0;i<wrapper.ilpUiList.length;i++)
            {
                wrapper.ilpUiList[i].locationDiscount=0;
            }
        }
      
        else if(discountmethod == 'radio-3')
        {
           
          wrapper.lineitemDiscount = 0;
            
        }
  		cmp.set("v.wrapper",wrapper);
       // alert('cmp@@'+JSON.stringify(cmp.get('v.wrapper')));
    
    },
    submit : function(component, event, helper) {
        var wrapper =component.get("v.wrapper"); 
       // alert('Wrap@@'+JSON.stringify(wrapper));
        var locationquantity =component.get("v.locationquantity"); 
        var locationquantitylist =component.get("v.locationquantitylist");
        /* var Promap =new Object; 
        Promap[wrapper.ProId]= wrapper;
        component.set("v.Promap",Promap);
        alert("Promap::"+JSON.stringify(component.get("v.Promap")));*/
        // alert("locationquantitylist1::"+JSON.stringify(locationquantitylist));
        var orderline = component.get("v.orderline");
        // alert("orderline::"+orderline);
        var productprice = component.get("v.productprice");
        var count=0;
        var Cost=0.00;
        var indLocationLevelDiscount=0;
        var ischeck=false;
        if(wrapper.ilpUiList != undefined)
        {
        for(var i=0;i<wrapper.ilpUiList.length;i++)
        {
            //alert('ILPLIST'+JSON.stringify(wrapper.ilpUiList[i]));
            if(wrapper.ilpUiList[i].checkBox)
            {
               // alert('inside');
               ischeck=true;
                if(wrapper.ilpUiList[i].pp==undefined)
                {
                    component.set('v.isError', true);
                    component.set('v.errorMsg', 'Product Price is not Available at line item --> '+(i+1));
                    locationquantitylist.pop();
                    return;    
                }
                else if(wrapper.ilpUiList[i].Quantity==0 ||wrapper.ilpUiList[i].Quantity==undefined )
                {
                    component.set('v.isError', true);
                    component.set('v.errorMsg', 'Please Enter the Quantity at line item -->'+i);
                    locationquantitylist.pop();
                    return;  
                }
                 else if(wrapper.ilpUiList[i].Quantity<0 )
                {
                    component.set('v.isError', true);
                    component.set('v.errorMsg', 'Quantity values cannot be negative.');
                    locationquantitylist.pop();
                    return;  
                }
                 else if(wrapper.ilpUiList[i].Availableqty < wrapper.ilpUiList[i].Quantity)
                {
                    component.set('v.isError', true);
                    component.set('v.errorMsg', 'Quantity  value must be less than or equal to available Quantity..');
                    locationquantitylist.pop();
                    return;  
                }
                  else if(wrapper.ilpUiList[i].locationDiscount<0 )
                {
                    component.set('v.isError', true);
                    component.set('v.errorMsg', 'Location Discount cannot be negative.');
                    locationquantitylist.pop();
                    return;  
                }
               
                else
                {
                    component.set("v.isError",false);
                    component.set("v.errorMsg", "");
                    
                    
                    locationquantity=new Object;
                    count = count + wrapper.ilpUiList[i].Quantity;
                    Cost = Cost + (wrapper.ilpUiList[i].pp.sigmaerpdev2__Cost__c * wrapper.ilpUiList[i].Quantity);
                    locationquantity.locid=wrapper.ilpUiList[i].locationId;
                    locationquantity.ILPId=wrapper.ilpUiList[i].ILPId;
                    locationquantity.Quantity= wrapper.ilpUiList[i].Quantity;
                    locationquantity.locdis=  wrapper.ilpUiList[i].locationDiscount;
                    locationquantity.loccost= wrapper.ilpUiList[i].pp.sigmaerpdev2__Cost__c * wrapper.ilpUiList[i].Quantity;
                    // alert('wrapper.ilpUiList[i].locationDiscount'+wrapper.ilpUiList[i].locationDiscount);
                    if(wrapper.ilpUiList[i].locationDiscount != null)
                    {
                        indLocationLevelDiscount +=  wrapper.ilpUiList[i].locationDiscount;
                    }
                  //  alert('locid'+locationquantitylist.locid);
                  //  alert('newid'+locationquantity.locid);
                  //  if(locationquantitylist.locid !=locationquantity.locid)
                    locationquantitylist.push(locationquantity);
                  //  alert('locationquantitylist>>'+JSON.stringify(locationquantitylist));
                }
            }
           
        }
        }
         if(ischeck==false)
            {
                component.set('v.isError', true);
                component.set('v.errorMsg', 'Select atleast one Line Item to continue.');
                return;   
            }
            else
            {
                component.set("v.isError",false);
                component.set("v.errorMsg", "");
            }
            
        if(wrapper.lineitemDiscount<0 )
        {
            component.set('v.isError', true);
            component.set('v.errorMsg', 'Product Discount cannot be negative.');
            return;  
        }
        else
        {
            component.set("v.isError",false);
            component.set("v.errorMsg", "");
        }
         //alert("locationquantitylist::"+JSON.stringify(locationquantitylist));
        orderline.sigmaerpdev2__Product__c=wrapper.ProId;
        
        orderline.sigmaerpdev2__Quantity__c=count;
        //orderline.sigmaerpdev2__Start_Date__c=new Date(wrapper.lineItemDate.sigmaerpdev2__Start_Date__c);
        var startDate = new Date(wrapper.lineItemDate.sigmaerpdev2__Start_Date__c);
        orderline.sigmaerpdev2__Start_Date__c=startDate.getFullYear()+ "-" +(startDate.getMonth() + 1)+ "-" + startDate.getDate() ;
        var endDate = new Date(wrapper.lineItemDate.sigmaerpdev2__End_Date__c);
        orderline.sigmaerpdev2__End_Date__c=endDate.getFullYear()+ "-" +(endDate.getMonth() + 1)+ "-" + endDate.getDate() ;
        
        // orderline.sigmaerpdev2__End_Date__c=new Date(wrapper.lineItemDate.sigmaerpdev2__End_Date__c);
        orderline.sigmaerpdev2__Cost__c=Cost;
        orderline.sigmaerpdev2__Sum_Location_Discount__c=indLocationLevelDiscount;
        
        orderline.sigmaerpdev2__Discount__c=wrapper.lineitemDiscount;
        orderline.proname=wrapper.ProName;
        productprice.sigmaerpdev2__Cost__c=Cost;
        // alert("orderline11"+JSON.stringify(orderline));
        var orderlines=new Object;
        orderlines.LineItem= component.get("v.orderline");
         orderlines.proname=wrapper.ProName;
        orderlines.locqty=locationquantitylist;
        orderlines.locdis=indLocationLevelDiscount;
        // orderlines.cost=Cost;
        component.set("v.wrapperListInsertLineItems",orderlines);
       // alert('value??>>'+JSON.stringify(component.get("v.wrapperListInsertLineItems")));
        component.set("v.Prowrap",wrapper);
        var orderinfo=component.get("v.wrapperListInsertLineItems");
        var compEvent = component.getEvent("carryorderList");
        compEvent.setParams({"orderinfo" : orderinfo,
                             "rowIndex" : component.get("v.rowIndexVar"),
                             "Promap" : component.get("v.Prowrap")});
        compEvent.fire();
       //  alert('absc'+JSON.stringify(component.get("v.wrapperListInsertLineItems")));
        component.set("v.isOpenchild", false);
        component.set("v.isOpenTablechild", true);
        
        
    },
    cancel : function(component, event, helper) {
        component.set("v.isOpenchild", false);  
    }
})