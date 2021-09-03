({
	editStock : function(component,event,helper){
		var currQty = component.get("v.rowDetails.requiredQnt");		
		component.set("v.reservedQty",currQty);		
        var rowId = component.get("v.prodId");
		var showEditQuan = document.getElementById('requiredQnt_'+rowId);				
		var editBtn = document.getElementById('edit_'+rowId);
		var showSaveBtn = document.getElementById('save_'+rowId);
		var showCancelBtn = document.getElementById('cancel_'+rowId);                
        if(showEditQuan.disabled == true) {               
			showEditQuan.disabled = false; 
			showEditQuan.focus();           
		}   
		if(showSaveBtn.disabled == true) {               
            	showSaveBtn.disabled = false;            
		}
		if(showCancelBtn.disabled == true) {               
            	showCancelBtn.disabled = false;            
		}  
		if(editBtn.disabled == false){
			editBtn.disabled = true;            
		}  		
	},	
	saveEditedStock : function(component,event,helper){
        var rowId = component.get("v.prodId");		
		var showCancelBtn = document.getElementById('cancel_'+rowId);
		var showSaveBtn = document.getElementById('save_'+rowId);
		if(showCancelBtn.disabled == false) {               
            showCancelBtn.disabled = true;            
		}  		
		if(showSaveBtn.disabled == false) {               
            showSaveBtn.disabled = true;            
		}
		helper.saveEditedStockH(component,event,helper);		  
	},

    cancelEditStock : function(component,event,helper){
		var originalQty = component.get("v.rowDetails.requiredQnt");		
        var rowId = component.get("v.prodId");
		var showEditQuan = document.getElementById('requiredQnt_'+rowId);  
		var showSaveBtn = document.getElementById('save_'+rowId);   
		var editBtn = document.getElementById('edit_'+rowId);
		var showCancelBtn = document.getElementById('cancel_'+rowId);            
        if(showEditQuan.disabled == false) {               
            	showEditQuan.disabled = true;            
		}  
		if(showSaveBtn.disabled == false) {               
            	showSaveBtn.disabled = true;            
		} 
		if(editBtn.disabled == true){
			editBtn.disabled = false;            
		}   
		if(showCancelBtn.disabled == false) {               
            	showCancelBtn.disabled = true;            
		}  
		component.set("v.rowDetails.requiredQnt",originalQty);
		showEditQuan.value = originalQty;
    	}
})