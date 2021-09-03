({ 
    doInit : function(component, event,helper,page) 
    { 
         
    },
    colorChange: function(component, event, helper){
        var ind=event.target.name;
        var color=event.target.id;
        var completeWrap=component.get('v.completeWrap');
        console.log(JSON.stringify(completeWrap));
        completeWrap[ind].selectedColor = color;
        
        component.set('v.completeWrap',completeWrap);
    },
    renderCart:function(component, event, helper) {
        component.set("v.parentcmp",false);
        component.set("v.isShipcmp",true);
    },
    
    saveproddata :function(component, event, helper) {
        var index = event.currentTarget;
        var indexval = index.dataset.record;
        helper.saveToCart(component, event, helper,indexval);
    },
   
    bulkAdd: function (component, event, helper) {
        console.log(component.get('v.completeWrap'));
        var completeWrap=component.get('v.completeWrap');
        var bulkCartDataToSave=[];
        var retailerCodeId='';
        for(var i=0;i<completeWrap.length;i++)
        {
            for(var j=0;j<completeWrap[i].tempMap.length;j++)
            {
                
                if(completeWrap[i].tempMap[j].quantity && !completeWrap[i].tempMap[j].value.addedToCart)
                {
                    if(completeWrap[i].tempMap[j].value.fullboxQty && completeWrap[i].tempMap[j].value.boxquantity && (completeWrap[i].tempMap[j].quantity<completeWrap[i].tempMap[j].value.boxquantity || completeWrap[i].tempMap[j].quantity % completeWrap[i].tempMap[j].value.boxquantity!=0))
                    {
                        var result = Math.ceil(completeWrap[i].tempMap[j].quantity/completeWrap[i].tempMap[j].value.boxquantity)*completeWrap[i].tempMap[j].value.boxquantity;
                        if (!confirm("Entered value for Product: "+completeWrap[i].tempMap[j].value.MainettiModelCode+" is not the multiples of Box quantity.\nCan system automatically change to nearest mutiples of box quantity ( "+result+" ) ?"))
                        {
                            return; 
                        }
                        retailerCodeId=completeWrap[i].tempMap[j].value.retailercodeId;
                        var singlecartDataToSave={"color":completeWrap[i].tempMap[j].key,"pricebookId":completeWrap[i].tempMap[j].value.priceBookId,"quantity":result,"cur":completeWrap[i].tempMap[j].value.priceByCurr,"custRefModel":completeWrap[i].tempMap[j].value.custRefModel};
                        bulkCartDataToSave.push(singlecartDataToSave);
                    }
                    else
                    {
                        retailerCodeId=completeWrap[i].tempMap[j].value.retailercodeId;
                        var singlecartDataToSave={"color":completeWrap[i].tempMap[j].key,"pricebookId":completeWrap[i].tempMap[j].value.priceBookId,"quantity":completeWrap[i].tempMap[j].quantity,"cur":completeWrap[i].tempMap[j].value.priceByCurr,"custRefModel":completeWrap[i].tempMap[j].value.custRefModel};
                        bulkCartDataToSave.push(singlecartDataToSave); 
                    }
                }
            }
        }
        if(bulkCartDataToSave.length>0)
            helper.saveBulkToCart(component, event, helper,retailerCodeId,bulkCartDataToSave);
    },
    quickviewcmp :function(component, event, helper)
    { 
        component.set("v.quickviewedProduct",component.get('v.SigProductList')[event.currentTarget.name]); 
        component.set("v.quickview",true);
    },
    
    //function helps to hide the increment and  decrement of number field
    afterRender: function (component, event, helper) {
        this.superAfterRender();
        
        //disable up, down, right, left arrow keys
        window.addEventListener("keydown", function(e) {
            if([37, 38, 39, 40].indexOf(e.keyCode) > -1) {
                e.preventDefault();
            }
        }, false);
        
        //disable mousewheel
        window.addEventListener("mousewheel", function(e) {
            e.preventDefault();
        }, false);
        
        window.addEventListener("DOMMouseScroll", function(e) {
            e.preventDefault();
        }, false);
        
    },
})