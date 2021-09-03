({
    doInit : function(cmp, evt)
    {
        //alert('oldstatus>>'+cmp.get('v.proposalproduct'));
        var wrapper =cmp.get("v.wrapper"); 
        
       // alert('wrapper:::'+JSON.stringify(wrapper));
       // alert('wrapperilplist'+JSON.stringify(wrapper.ilpUiList));
        if(wrapper!=null)
        {
             //alert('insidewrapper');
            if(wrapper.ilpUiList==undefined || wrapper.ilpUiList.length<1)
            {
                 //alert('fire');   
                cmp.set('v.isError', true);
                cmp.set('v.errorMsg', 'Product ILP is not available for selected date.');
                return;  
            }
            else
            {
                cmp.set("v.isError",false);
                cmp.set("v.errorMsg", "");
            }  
        }
        
    },
    Proposaleditflow: function(cmp, evt)
    {
        
        var popup = evt.getParam("popup");
       // alert('popup>>'+JSON.stringify(popup));
        var disval=cmp.get("v.disval");
        cmp.set("v.wrapper",popup.length);
       
        cmp.set("v.rowIndexVar",evt.getParam("rowIndex"));
        var promap=cmp.get("v.Promap");
    
        for(var i=0;i<promap.length;i++)
        {

            if(promap[i].ProId==popup.LineItem.sigmaerpdev2__Product__c)
            {
               
                promap[i].lineitemDiscount=popup.LineItem.sigmaerpdev2__Discount__c;
                if(disval=='radio-3')
                {
                for(var j=0;j<promap[i].ilpUiList.length;j++)
                    {
                     
                     if(popup.locqty[j].locdis!= undefined) 
                     {
                        promap[i].ilpUiList[j].locationDiscount=popup.locqty[j].locdis;
                     }
                      else
                      {
                        
                          promap[i].ilpUiList[j].locationDiscount=null;
                      }
                    }
                }
                cmp.set("v.wrapper",promap[i]);  
            }
        }
      
        
    },
    submit : function(component, event, helper) {
        var wrapper =component.get("v.wrapper"); 
        var locationquantity =component.get("v.locationquantity"); 
        var locationquantitylist =component.get("v.locationquantitylist");
        var proposalproduct =component.get("v.proposalproduct");
        
        var orderline = component.get("v.orderline");
        // alert("orderline::"+orderline);
        var productprice = component.get("v.productprice");
        var count=0;
        var Cost=0;
        var indLocationLevelDiscount=0;
        var ischeck=false;
        var iscount=0;
        for(var i=0;i<wrapper.ilpUiList.length;i++)
        {
            
            if(wrapper.ilpUiList[i].checkBox)
            {
               
                ischeck=true;
                iscount=iscount+1;
               
                   if(wrapper.ilpUiList[i].pp.sigmaerpdev2__Cost__c==undefined || wrapper.ilpUiList[i].pp.sigmaerpdev2__Cost__c==0)
                {
                    component.set('v.isError', true);
                    component.set('v.errorMsg', 'Price is not Available at line item --> '+i);
                    return;    
                }
                else if(wrapper.ilpUiList[i].Quantity==0 ||wrapper.ilpUiList[i].Quantity==undefined )
                {
                    component.set('v.isError', true);
                    component.set('v.errorMsg', 'Please Enter the Quantity.');
                    return;  
                }
                else if(wrapper.ilpUiList[i].Quantity % 1 != 0 )
                {
                    component.set('v.isError', true);
                    component.set('v.errorMsg', 'Decimal quantity are not allowed');
                    return;  
                }
                    else if(wrapper.ilpUiList[i].Quantity<0 )
                    {
                        component.set('v.isError', true);
                        component.set('v.errorMsg', 'Quantity values cannot be negative.');
                        return;  
                    }
                        else if(wrapper.ilpUiList[i].Availableqty < wrapper.ilpUiList[i].Quantity && component.get('v.proposalproduct'))
                        {
                            component.set('v.isError', true);
                            component.set('v.errorMsg', 'Quantity  value must be less than or equal to available Quantity..');
                            return;  
                        }
                            else if(wrapper.ilpUiList[i].locationDiscount<0 )
                            {
                                component.set('v.isError', true);
                                component.set('v.errorMsg', 'Location Discount cannot be negative.');
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
                                    locationquantitylist.push(locationquantity);
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
        
         if(iscount>1 && proposalproduct==false)
        {
            component.set('v.isError', true);
            component.set('v.errorMsg', 'Select One Line Item to continue.');
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
        // alert("locationquantitylist::"+JSON.stringify(locationquantitylist));
        orderline.sigmaerpdev2__Product__c=wrapper.ProId;
        
        orderline.sigmaerpdev2__Quantity__c=count;
        //orderline.sigmaerpdev2__Start_Date__c=new Date(wrapper.lineItemDate.sigmaerpdev2__Start_Date__c);
        if(proposalproduct==true)
        {
            var startDate = new Date(wrapper.lineItemDate.sigmaerpdev2__Start_Date__c);
            orderline.sigmaerpdev2__Start_Date__c=startDate.getFullYear()+ "-" +(startDate.getMonth() + 1)+ "-" + startDate.getDate() ;
            var endDate = new Date(wrapper.lineItemDate.sigmaerpdev2__End_Date__c);
            orderline.sigmaerpdev2__End_Date__c=endDate.getFullYear()+ "-" +(endDate.getMonth() + 1)+ "-" + endDate.getDate() ;
            
        }
        
        // orderline.sigmaerpdev2__End_Date__c=new Date(wrapper.lineItemDate.sigmaerpdev2__End_Date__c);
        orderline.sigmaerpdev2__Cost__c=Cost;
        orderline.sigmaerpdev2__Sum_Location_Discount__c=indLocationLevelDiscount;
        
        orderline.sigmaerpdev2__Discount__c=wrapper.lineitemDiscount;
        //orderline.PoName=wrapper.ProName;
        productprice.sigmaerpdev2__Cost__c=Cost;
        // alert("orderline11"+JSON.stringify(orderline));
        var orderlines=new Object;
        orderlines.LineItem= component.get("v.orderline");
        orderlines.locqty=locationquantitylist;
        orderlines.proname=wrapper.ProName;
        // orderlines.locdis=indLocationLevelDiscount;
        // alert("orderline11"+JSON.stringify(orderline));
        component.set("v.wrapperListInsertLineItems",orderlines);
        component.set("v.Prowrap",wrapper);
        var orderinfo=component.get("v.wrapperListInsertLineItems");
        var compEvent = component.getEvent("carryorderList");
        compEvent.setParams({"orderinfo" : orderinfo,
                             "rowIndex" : component.get("v.rowIndexVar"),
                             "Promap" : component.get("v.Prowrap")});
        compEvent.fire();
        // alert('absc'+JSON.stringify(component.get("v.wrapperListInsertLineItems")));
        component.set("v.isOpenchild", false);
        component.set("v.isOpenTablechild", true);
        
        
    },
    cancel : function(component, event, helper) {
        component.set("v.isOpenchild", false);  
    }
})