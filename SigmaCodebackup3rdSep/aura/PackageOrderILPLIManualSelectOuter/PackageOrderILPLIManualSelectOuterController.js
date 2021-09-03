({
	expandOrHide : function(component, event, helper) {
		var rowId = component.get("v.standOrderIlpliWrapper.orderLineWrap.Id");		  
        var selLineItem = document.getElementById('showHide_'+rowId);		           
        var imgId = document.getElementById('changeImage_'+rowId);         
        if(selLineItem.style.display == 'none') {  
            imgId.src= "/resource/sigmaerpdev__NMinus";            
            imgId.title="Hide Stock";   
            selLineItem.style.display = 'block';            
        }else{             
            imgId.src= "/resource/sigmaerpdev__NPlus";            
            imgId.title="Show Stock";   
            selLineItem.style.display = 'none';
        }
	},
    autoSelectQnty : function(component, event, helper){        
        var orderedqty = component.get("v.standOrderIlpliWrapper.orderLineWrap.sigmaerpdev__Net_Quantity__c");        
        var tempWrap = component.get("v.standOrderIlpliWrapper.wrapperIlpli");
        var prodAttrType = component.get("v.standOrderIlpliWrapper.orderLineWrap.Product2.sigmaerpdev__Attribute_Type__c");        
        
        if(prodAttrType == 'BULK'){                       
            if(tempWrap[0].AvailableQuantity >= orderedqty){
            	tempWrap[0].EnterQuantity = orderedqty;
            	component.set("v.standOrderIlpliWrapper.wrapperIlpli",tempWrap);     
            }else{
               alert('Sufficient stock is not available.'); 
            }                       
        }else if(prodAttrType == 'SERIALIZED'){                      
            if(tempWrap.length >= orderedqty){
            	for(var i=0; i < orderedqty; i++){
                	tempWrap[i].EnterQuantity = 1;            
                }    
            }else{
                alert('Sufficient stock is not available.');
            } 
            component.set("v.standOrderIlpliWrapper.wrapperIlpli",tempWrap);
        }
        console.log('list==='+JSON.stringify(component.get("v.standOrderIlpliWrapper")));
    }
})