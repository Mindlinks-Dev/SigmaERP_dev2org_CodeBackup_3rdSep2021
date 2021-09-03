({
    doInit : function(component, event, helper) {
        var action = component.get("c.getPackageProductStatus");
        action.setCallback(this, function(a) {
            component.set("v.status", a.getReturnValue());			
            
        });                 
        $A.enqueueAction(action); 
    },
    
    expandOrHide : function(cmp,event,helper)
    {       
        var rowId = cmp.get("v.selTransLineItemId");
        var selLineItem = document.getElementById('showHide_'+rowId);        
        var imgId = document.getElementById('changeImage_'+rowId);
        var addIcon = cmp.find("addIcon");
        var dashIcon = cmp.find("dashIcon");
        
        $A.util.toggleClass(addIcon, "slds-hide");
        $A.util.toggleClass(dashIcon, "slds-hide");
        
        if(selLineItem.style.display == 'none') {                   
            imgId.src= "{!$Resource.sigmaerpdev__NPlus}"; 
            
            imgId.title="Hide Stock";   
            selLineItem.style.display = 'block';            
        }else{            
            imgId.src= "{!$Resource.sigmaerpdev__NPlus}";            
            imgId.title="Show Stock";   
            selLineItem.style.display = 'none';
        }
    },
    getStatus :function(cmp, event)
    {
        
        cmp.set("v.selStatus",cmp.find("status").get("v.value"));
        
    },
    autoFillQuantity :function(cmp,event,helper)
    {
        
        var packqty = cmp.get("v.packQtyShow");        
        var tempWrap = cmp.get("v.wrapList"); 
        
        if(tempWrap.length >= packqty){
            for(var i=0;i<packqty;i++){
                tempWrap[i].selQuantity = 1;            
            }    
        }else{
            alert('Sufficient stock is not available.');
        }        
        cmp.set("v.wrapList",tempWrap);        
    }
    
})