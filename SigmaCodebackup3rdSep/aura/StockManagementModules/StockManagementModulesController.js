({  
	/*showStockAdjustment : function(component, event, helper) {
		window.open('/lightning/n/sigmaerpdev2__Stock_Adjustment'); 
	},*/
    
    HelpMenu :function(component, event, helper){  
        var objName = component.get('v.currectObject');
        //alert(JSON.stringify(objName));
        console.log(JSON.stringify(objName));
        component.set("v.showHelpMenu", true);
        component.set("v.HelpIcons", true);
		const div1 =document.getElementById('trialWindow');
        $A.util.toggleClass(div1, 'slds-hide');
        //code to de-highlight the highlighted fields once help menu is closed
        var className1 = document.getElementById("trialWindow").className;
        if(className1.includes("slds-hide")){ 
            
            if(objName == 'Stock Adjustment'){
                var domId1 = document.getElementById("TempToDisplayLoc");
                if(domId1 != null)
                domId1.style.border= "";
                var domId2 = document.getElementById("TempToDisplayPro");
                if(domId2 != null)
                domId2.style.border= "";
            }
            if(objName == 'Stock Movement'){
				var domId16 = document.getElementById("TempToDisplayFromLoc");
			if(domId16 != null)
			domId16.style.border= "";
			var domId17 = document.getElementById("TempToDisplayFrombin");
			if(domId17 != null)
			domId17.style.border= "";
			var domId18 = document.getElementById("bucket");
			if(domId18 != null)
			domId18.style.border= "";
			var domId19 = document.getElementById("ToLocation");
			if(domId19 != null)
			domId19.style.border= "";
			var domId20 = document.getElementById("ToBin");
			if(domId20 != null)
			domId20.style.border= "";
            }
			if(objName == 'Stock Check'){
				var domId21 = document.getElementById("TempToDisplayCheckDate");
			if(domId21 != null)
			domId21.style.border= "";
			var domId22 = document.getElementById("TempToDisplayUser");
			if(domId22 != null)
			domId22.style.border= "";
			var domId23 = document.getElementById("TempToDisplayLoc");
			if(domId23 != null)
			domId23.style.border= "";
			var domId24 = document.getElementById("CheckQty");
			if(domId24 != null)
			domId24.style.border= "";
			var domId25 = document.getElementById("ReasonCode");
			if(domId25 != null)
			domId25.style.border= "";
			var domId36 = document.getElementById("TempToDisplayprodbarcode");
			if(domId36 != null)
			domId36.style.border= "";
            }
            if(objName == 'Stock Conversion'){
			//code for Stock Conversion(Individual To BOM starts here)
			var domId26 = document.getElementById("ProductName");
			if(domId26 != null)
			domId26.style.border= "";
			var domId27 = document.getElementById("TargetLocation");
			if(domId27 != null)
			domId27.style.border= "";
			var domId28 = document.getElementById("TempToDisplayFrombin1");
			if(domId28 != null)
			domId28.style.border= "";
			var domId29 = document.getElementById("temptodisplayLot");
			if(domId29 != null)
			domId29.style.border= "";
			var domId30 = document.getElementById("temptodisplayupdateqty");
			if(domId30 != null)
			domId30.style.border= "";
		   //Individual to Bom code ends here
			
			//Bom To Individual code starts here
			var domId32 = document.getElementById("templatetodisplayilp");
			if(domId32 != null)
			domId32.style.border= "";
		   
			var domId34 = document.getElementById("unitprice");
			if(domId34 != null)
			domId34.style.border= "";
			var domId35 = document.getElementById("convQty");
			if(domId35 != null)
			domId35.style.border= "";
            var domId36 = document.getElementById("quantity");
            if(domId36 != null)
            domId36.style.border= "";
		   //Bom To Individual code ends here
            }
        }
        
    },
    
    stepsOnclickHandler: function(component, event, helper){
        component.set("v.descriptionBody", ""); 
        var clickedIndexArray;
        if(event.currentTarget)
            clickedIndexArray=event.currentTarget.id.split("-");
        var jsonString=component.get('v.jsonString');
        console.log(JSON.stringify(jsonString));
        var clickedStep=jsonString.chapters[clickedIndexArray[0]].steps[clickedIndexArray[1]];
		console.log('clickedStep>>>'+JSON.stringify(clickedStep));
     
        //code for Stock Adjustment
        var domId1 = document.getElementById("TempToDisplayLoc");
        if(domId1 != null)
        domId1.style.border= "";
        var domId2 = document.getElementById("TempToDisplayPro");
        if(domId2 != null)
        domId2.style.border= "";
   		// Ends here
            
       //code for Stock Movement 
        var domId16 = document.getElementById("TempToDisplayFromLoc");
        if(domId16 != null)
        domId16.style.border= "";
        var domId17 = document.getElementById("TempToDisplayFrombin");
        if(domId17 != null)
        domId17.style.border= "";
        var domId18 = document.getElementById("bucket");
        if(domId18 != null)
        domId18.style.border= "";
        var domId19 = document.getElementById("ToLocation");
        if(domId19 != null)
        domId19.style.border= "";
        var domId20 = document.getElementById("ToBin");
        if(domId20 != null)
        domId20.style.border= "";
         var domId37 = document.getElementById("pickQty");
        if(domId37 != null)
        domId37.style.border= "";
		// Ends here        
        
		//code for Stock Check starts here
		var domId21 = document.getElementById("TempToDisplayCheckDate");
		if(domId21 != null)
		domId21.style.border= "";
		var domId22 = document.getElementById("TempToDisplayUser");
		if(domId22 != null)
		domId22.style.border= "";
		var domId23 = document.getElementById("TempToDisplayLoc");
		if(domId23 != null)
		domId23.style.border= "";
		var domId24 = document.getElementById("CheckQty");
		if(domId24 != null)
		domId24.style.border= "";
		var domId25 = document.getElementById("ReasonCode");
		if(domId25 != null)
		domId25.style.border= "";
        var domId36 = document.getElementById("TempToDisplayprodbarcode");
		if(domId36 != null)
		domId36.style.border= "";
       // Ends here
		
        //code for Stock Conversion(Individual To BOM starts here)
        var domId26 = document.getElementById("ProductName");
        if(domId26 != null)
        domId26.style.border= "";
        var domId27 = document.getElementById("TargetLocation");
        if(domId27 != null)
        domId27.style.border= "";
        var domId28 = document.getElementById("TempToDisplayFrombin1");
		if(domId28 != null)
        domId28.style.border= "";
        var domId29 = document.getElementById("temptodisplayLot");
        if(domId29 != null)
        domId29.style.border= "";
        var domId30 = document.getElementById("temptodisplayupdateqty");
        if(domId30 != null)
        domId30.style.border= "";
        
       //Individual to Bom code ends here
        
        //Bom To Individual code starts here
        var domId32 = document.getElementById("templatetodisplayilp");
        if(domId32 != null)
        domId32.style.border= "";
       
        var domId34 = document.getElementById("unitprice");
        if(domId34 != null)
        domId34.style.border= "";
        var domId35 = document.getElementById("convQty");
        if(domId35 != null)
        domId35.style.border= "";
        var domId36 = document.getElementById("quantity");
        if(domId36 != null)
        domId36.style.border= "";
        
       //Bom To Individual code ends here
		
		//code for Stock Adjustment starts here 
       if(clickedStep.title.startsWith("Location")){  
           var domId = document.getElementById("TempToDisplayLoc");
            if(domId != null)
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        } 

		if(clickedStep.title.includes("Product")){  
           var domId = document.getElementById("TempToDisplayPro");
            if(domId != null)
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        }  
		//Stock Adjustment Ends Here 
		
        //code for Stock Movement starts here       
       if(clickedStep.title.endsWith("From Location")){
           var domId = document.getElementById("TempToDisplayFromLoc");
            if(domId != null)
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        } 

		if(clickedStep.title.includes("From Bin")){  
           var domId = document.getElementById("TempToDisplayFrombin");
            if(domId != null)
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        }  
		
		if(clickedStep.title.startsWith("PickQty")){  
           var domId = document.getElementById("pickQty");
            if(domId != null)
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        } 
		
		if(clickedStep.title.includes("To Location")){  
           var domId = document.getElementById("ToLocation");
            if(domId != null)
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        } 
		
		if(clickedStep.title.includes("To Bin")){  
           var domId = document.getElementById("ToBin");
            if(domId != null)
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        } 
        //code Ends here
        
        //code for Stock Check starts here 
       if(clickedStep.title.includes("Check Date")){  
           var domId = document.getElementById("TempToDisplayCheckDate");
            if(domId != null)
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        } 

		if(clickedStep.title.includes("User")){  
           var domId = document.getElementById("TempToDisplayUser");
            if(domId != null)
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        }  
		
		if(clickedStep.title.includes("Location Name")){  
           var domId = document.getElementById("TempToDisplayLoc");
            if(domId != null)
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        } 
		
		
		if(clickedStep.title.includes("STOCK CHECK QTY")){  
           var domId = document.getElementById("CheckQty");
            if(domId != null)
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        } 
		
		
		if(clickedStep.title.includes("REASON")){  
           var domId = document.getElementById("ReasonCode");
            if(domId != null)
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        } 
        //code Ends for Stock Check
		
         //code for Stock Conversion starts here (Individuals to Bom)
        
        if(clickedStep.title.includes("BOM PRODUCT")){
           var domId = document.getElementById("ProductName");
            if(domId != null)
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        }
        if(clickedStep.title.includes("PRODUCT TO LOCATION")){  
           var domId = document.getElementById("TargetLocation");
            if(domId != null)
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        } 
        
        if(clickedStep.title.includes("BIN")){  
           var domId = document.getElementById("TempToDisplayFrombin1");
            if(domId != null)
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        } 
        
        if(clickedStep.title.includes("TO LOT")){  
           var domId = document.getElementById("temptodisplayLot");
            if(domId != null)
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        } 
		
		if(clickedStep.title.includes("UPDATE STOCK QUANTITY") && !clickedStep.title.startsWith("PICK")){  
           var domId = document.getElementById("temptodisplayupdateqty");
            if(domId != null)
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        } 
		
		if(clickedStep.title.includes("PICK QUANTITY") && clickedStep.title.startsWith("PICK")){  
           var domId = document.getElementById("quantity");
            if(domId != null)
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        }
        //code ends for Individuals to Bom
        
        //code for Bom to Individuals starts here
        if(clickedStep.title.includes("BOM ILP")){  
           var domId = document.getElementById("templatetodisplayilp");
            if(domId != null)
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        } 
        
		//alert('title==='+clickedStep.title);
		if(clickedStep.title.includes("CONVERT QUANTITY")){ 
            //alert('inside 246');
           var domId = document.getElementById("convQty");
            if(domId != null)
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        } 
		
		if(clickedStep.title.includes("UNIT PRICE")){  
           var domId = document.getElementById("unitprice");
            if(domId != null)
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        } 
	
	/*	if(clickedStep.title.endsWith("Pick Quantity")){  
           var domId = document.getElementById("quantity");
            if(domId != null)
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        }*/
        //code ends for Bom to Individual
     },
    
         dragContent : function(){
        function dragElement(elmnt) {
            var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
            if (document.getElementById(elmnt.id + "header")) {
                /* if present, the header is where you move the DIV from:*/
                document.getElementById(elmnt.id + "header").onmousedown = dragMouseDown;
            } else {
                /* otherwise, move the DIV from anywhere inside the DIV:*/
                elmnt.onmousedown = dragMouseDown;
            }
            
            function dragMouseDown(e) {
                e = e || window.event;
                e.preventDefault();
                // get the mouse cursor position at startup:
                pos3 = e.clientX;
                pos4 = e.clientY;
                document.onmouseup = closeDragElement;
                // call a function whenever the cursor moves:
                document.onmousemove = elementDrag;
            }
            
            function elementDrag(e) {
                e = e || window.event;
                e.preventDefault();
                // calculate the new cursor position:
                pos1 = pos3 - e.clientX;
                pos2 = pos4 - e.clientY;
                pos3 = e.clientX;
                pos4 = e.clientY;
                // set the element's new position:
                elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
                elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
            }
            
            function closeDragElement() {
                /* stop moving when mouse button is released:*/
                document.onmouseup = null;
                document.onmousemove = null;
            }
        }
        //dragElement("myimage", "myresult"); 
        dragElement(document.getElementById("trialWindow"));
    } ,
    init : function(component, event, helper){

        //Help Menu Start
        helper.helperMethod(component, event, helper);
		//Help Menu ends

        
        setTimeout(function(){
            var jsonString = component.get("v.jsonString");
          }, 2000);
       
        
        var fromModule = component.get("v.from");         
        var stkMId;        
        if(component.get("v.stkMId") != undefined){
        	stkMId = component.get("v.stkMId");     
        } 
        var stkChkId;
        if(component.get("v.stkChkId") != undefined){
        	stkChkId = component.get("v.stkChkId");     
        }                
        if(fromModule != undefined && fromModule != ''){
            if(fromModule == 'StkAdj'){                
          		component.set("v.showModules", true);        
           		component.set("v.showStkAdj", true);
           		component.set("v.showIcons", false);          
            }else if(fromModule == 'StkMvM'){				               
                component.set("v.showModules", true);        
           		component.set("v.showStkMvmnt", true);
           		component.set("v.showIcons", false);
                if(stkMId != undefined && stkMId != ''){                                                            
               		window.open('/lightning/r/sigmaerpdev2__StockMovement__c/'+stkMId+'/view');                        
                }                
            }else if(fromModule == 'StkCHK'){				               
                component.set("v.showModules", true);        
           		component.set("v.showStkChk", true);
           		component.set("v.showIcons", false);
                if(stkChkId != undefined && stkChkId != ''){                                                            
               		window.open('/lightning/r/sigmaerpdev2__Stock_Check__c/'+stkChkId+'/view');                        
                }                
            }
            
        }else{
           component.set("v.showIcons", true);  
        }        
    },

    showStockAdjustment : function(component, event, helper) {
        component.set("v.showHelpMenu", true);
		component.set("v.showModules", true);        
		component.set("v.showStkAdj", true);
        component.set("v.showStkMvmnt", false);
        component.set("v.showStkChk", false);
        component.set("v.showStkConv", false);      
        
        //Help menu Image nav
        var currentObject;
        if(event.currentTarget)
            currentObject=event.currentTarget.name;
        //var currentObjectId =document.getElementById('Purchase');
       // alert('currentObjectId'+currentObject)
        component.set('v.currectObject',currentObject);
        // alert('currentObjectIdObject'+component.get('v.currectObject'))
        if(component.get('v.currectObject')=='Stock Adjustment')
            //component.set('v.description','Help Menu - Stock Adjustment');       
        
            var str1 = "Stock Adjustment Tab";
           
        var str2= "Functionality : To make Adjustments to the Stock";
            
            component.set('v.description', str1); 
        	component.set('v.descriptionBody', str2);
        
        var objectFiledList=component.get('v.objectFiledList');
        var isDataPresent=false;
        for(var i=0;i<objectFiledList.length;i++)
        {
            if(objectFiledList[i].key==currentObject)
                isDataPresent=true;
        }
        if(!isDataPresent)
        {
           
        	var trialFloatchatid=component.find('trialWindow');
                $A.util.removeClass(trialFloatchatid, "enter");
        }
	},
    showStkMovement : function(component, event, helper) {
         component.set("v.showHelpMenu", true);
        component.set("v.showModules", true); 
		component.set("v.showStkMvmnt", true);
        component.set("v.showStkAdj", false);
        component.set("v.showStkChk", false);
        component.set("v.showStkConv", false);
        
        //Help menu Image nav
        var currentObject;
        if(event.currentTarget)
            currentObject=event.currentTarget.name;
        //var currentObjectId =document.getElementById('Purchase');
        //alert('currentObjectId'+currentObject)
        component.set('v.currectObject',currentObject);
        // alert('currentObjectIdObject'+component.get('v.currectObject'))
        if(component.get('v.currectObject')=='Stock Movement')
            //component.set('v.description','Help Menu - Stock Movement');       
        
            var str1 = "Stock Movement Tab";
			var str2= "Functionality : To transfer the stock between different Inventory Locations within the Company";
            component.set('v.description', str1); 
        	component.set('v.descriptionBody', str2);
        
        var objectFiledList=component.get('v.objectFiledList');
        var isDataPresent=false;
        for(var i=0;i<objectFiledList.length;i++)
        {
            if(objectFiledList[i].key==currentObject)
                isDataPresent=true;
        }
        if(!isDataPresent)
        {
           
        	var trialFloatchatid=component.find('trialWindow');
                $A.util.removeClass(trialFloatchatid, "enter");
        }
	},
    showStkCheck : function(component, event, helper) {
         component.set("v.showHelpMenu", true);
		component.set("v.showModules", true); 
        component.set("v.showStkChk", true);
        component.set("v.showStkMvmnt", false);
        component.set("v.showStkAdj", false);       
        component.set("v.showStkConv", false);
        
        //Help menu Image nav
        var currentObject;
        if(event.currentTarget)
            currentObject=event.currentTarget.name;
        //var currentObjectId =document.getElementById('Purchase');
       // alert('currentObjectId'+currentObject)
        component.set('v.currectObject',currentObject);
        // alert('currentObjectIdObject'+component.get('v.currectObject'))
        if(component.get('v.currectObject')=='Stock Check')
           // component.set('v.description','Help Menu - Stock Check');       
        
            var str1 = "Stock Check Tab ";
			var str2= "Functionality : To Verify,Compare & Update System held Stock against Physical Stock";
            component.set('v.description', str1); 
        	component.set('v.descriptionBody', str2);
        
        var objectFiledList=component.get('v.objectFiledList');
        var isDataPresent=false;
        for(var i=0;i<objectFiledList.length;i++)
        {
            if(objectFiledList[i].key==currentObject)
                isDataPresent=true;
        }
        if(!isDataPresent)
        {
           
        	var trialFloatchatid=component.find('trialWindow');
                $A.util.removeClass(trialFloatchatid, "enter");
        }
	},
    showStkConversion : function(component, event, helper) {
        component.set("v.showHelpMenu", true);
		component.set("v.showModules", true); 
        component.set("v.showStkConv", true);
        component.set("v.showStkMvmnt", false);
        component.set("v.showStkAdj", false);
        component.set("v.showStkChk", false); 
        
        //Help menu Image nav
        var currentObject;
        if(event.currentTarget)
            currentObject=event.currentTarget.name;
        //var currentObjectId =document.getElementById('Purchase');
       // alert('currentObjectId'+currentObject)
        component.set('v.currectObject',currentObject);
        // alert('currentObjectIdObject'+component.get('v.currectObject'))
        if(component.get('v.currectObject')=='Stock Conversion')
            //component.set('v.description','Help Menu - Stock Conversion');       
         
            var str1 = "Stock Conversion Tab ";
			var str2= "Functionality : To increase BOM Product inventory";
            component.set('v.description', str1); 
        	component.set('v.descriptionBody', str2);
        
        var objectFiledList=component.get('v.objectFiledList');
        var isDataPresent=false;
        for(var i=0;i<objectFiledList.length;i++)
        {
            if(objectFiledList[i].key==currentObject)
                isDataPresent=true;
        }
        if(!isDataPresent)
        {
           
        	var trialFloatchatid=component.find('trialWindow');
                $A.util.removeClass(trialFloatchatid, "enter");
        }
	},
    closeInfo : function(component, event, helper){		        
        component.set("v.showIcons", false);
    },
    showInfo :  function(component, event, helper){        
        component.set("v.showIcons", true);
    },
})