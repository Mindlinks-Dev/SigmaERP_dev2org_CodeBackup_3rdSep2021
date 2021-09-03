({
    init : function(component, event, helper){ 
        
      	helper.helperMethod(component, event, helper);
        //Help Menu Start
        /*var jsonString = {};	
	    jsonString['SearchInventory'] =[];
        jsonString['SearchInventory'].push('Product');
        jsonString['SearchInventory'].push('Location');
		
        jsonString['LotView'] =[];
        jsonString['LotView'].push('Product');
        jsonString['LotView'].push('Lot');
        
        jsonString['ReleaseInventory'] =[];
        jsonString['ReleaseInventory'].push('RELEASE STATUS(YES/NO)');
        jsonString['ReleaseInventory'].push('COMMENTS');
        component.set('v.jsonString',jsonString);       
        
        var objectFiledList = [];
        for(var key in jsonString){
            objectFiledList.push({value:jsonString[key], key:key});
        }
        component.set('v.objectFiledList',objectFiledList);  */      
        //End
        
    },
    
    //Help Menu for Highlighting element
    /*highlightSteps: function(component, event, helper){		        
        var clickedFeild;
        if(event.currentTarget){
            clickedFeild=event.currentTarget.name;
           }  
        
        var domId1 = document.getElementById("TempDispalyForProduct");
        if(domId1 != null)
        domId1.style.border= "";
        var domId2 = document.getElementById("TempDispalyForLocation");
        if(domId2 != null)
        domId2.style.border= "";
        var domId3 = document.getElementById("TempDisplayforlotproduct");
        if(domId3 != null)
        domId3.style.border= "";
         var domId4 = document.getElementById("TempDisplayforlot");
        if(domId4 != null)
        domId4.style.border= "";
        var domId5 = document.getElementById("TempDisplayStatus");
        if(domId5 != null)
        domId5.style.border= "";
        var domId6 = document.getElementById("TempDisplayComment");
        if(domId6 != null)
        domId6.style.border= "";
        
        component.set('v.field',clickedFeild);
        component.set('v.description','Enter the '+clickedFeild+' for the '+component.get('v.currectObject')+'.');
        
        var dom111=document.getElementById(clickedFeild);
        dom111.style.color="red";
        if(clickedFeild.includes("Product")){  
           var domId = document.getElementById("TempDispalyForProduct");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";             
        }         
        if(clickedFeild.includes("Location")){
            var domId = document.getElementById("TempDispalyForLocation");
            if(domId != null)
            domId.style.border= "2px solid #19afd5"; 
            //jsonString['domClicked'].push(domId);
        }
        
           if(clickedFeild.includes("Product")){
            var domId = document.getElementById("TempDisplayforlotproduct");
            if(domId != null)
            domId.style.border= "2px solid #19afd5"; 
            //jsonString['domClicked'].push(domId);
        }
        if(clickedFeild.includes("Lot")){
            var domId = document.getElementById("TempDisplayforlot");
            if(domId != null)
            domId.style.border= "2px solid #19afd5"; 
            
        }
        if(clickedFeild.includes("RELEASE STATUS(YES/NO)")){
            var domId = document.getElementById("TempDisplayStatus");
            if(domId != null)
            domId.style.border= "2px solid #19afd5"; 
            
        }
        if(clickedFeild.includes("COMMENTS")){
            var domId = document.getElementById("TempDisplayComment");
            if(domId != null)
            domId.style.border= "2px solid #19afd5"; 
            
        }
        
    },*/
    
    //Help Menu for Highlighting element
    stepsOnclickHandler: function(component, event, helper){
        component.set("v.descriptionBody", "");
        
        var clickedIndexArray;
        if(event.currentTarget)
            clickedIndexArray = event.currentTarget.id.split("-");
        
        var jsonString = component.get('v.jsonString');
        var clickedStep = jsonString.chapters[clickedIndexArray[0]].steps[clickedIndexArray[1]];
             
        var domId1 = document.getElementById("TempDispalyForProduct");
        if(domId1 != null)
        domId1.style.border= "";
        var domId2 = document.getElementById("TempDispalyForLocation");
        if(domId2 != null)
        domId2.style.border= "";
        var domId3 = document.getElementById("TempDisplayforlotproduct");
        if(domId3 != null)
        domId3.style.border= "";
        var domId4 = document.getElementById("TempDisplayforlot");
        if(domId4 != null)
        domId4.style.border= "";
        var domId5 = document.getElementById("TempDisplayStatus");
        if(domId5 != null)
        domId5.style.border= "";
        var domId6 = document.getElementById("TempDisplayComment");
        if(domId6 != null)
        domId6.style.border= "";
        
        
        
        if(clickedStep.title.endsWith("Product")){             
            var domId = document.getElementById("TempDispalyForProduct");
            if(domId != null)
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        }      
        if(clickedStep.title.includes("Location")){            
            var domId = document.getElementById("TempDispalyForLocation");
            if(domId != null)
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";
        }
        
        if(clickedStep.title.endsWith("Product Name")){
            var domId = document.getElementById("TempDisplayforlotproduct");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
        }
        if(clickedStep.title.includes("Lot")){            
            var domId = document.getElementById("TempDisplayforlot");
            if(domId != null)
            domId.style.border= "2px solid #19afd5"; 
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
        }
        if(clickedStep.title.includes("RELEASE STATUS(YES/NO)")){            
            var domId = document.getElementById("TempDisplayStatus");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
        }
        if(clickedStep.title.includes("COMMENTS")){            
            var domId = document.getElementById("TempDisplayComment");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
        }
       
        
        //Demand Planning
        /*if(clickedStep.title.includes("Product")){            
			var domIdVend = document.getElementById("TempToDisplayProduct"); 
            if(domIdVend != null)
            domIdVend.style.border= "2px solid #19afd5";
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
          }
        if(clickedStep.title.includes("Product Category")){            
			var domIdVend = document.getElementById("TempToDisplayProCategory"); 
            if(domIdVend != null)
            domIdVend.style.border= "2px solid #19afd5"; 
          }
        if(clickedStep.title.includes("From Date")){            
			var domIdVend = document.getElementById("TempToDisplayFrom"); 
            if(domIdVend != null)
            domIdVend.style.border= "2px solid #19afd5";
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
          }
        if(clickedStep.title.includes("To Date")){  
           var domId = document.getElementById("TempToDisplayTo");
           if(domId != null)
           domId.style.border= "2px solid #19afd5";
           component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
        }
        if(clickedStep.title.includes("Status")){  
           var domId = document.getElementById("TempToDisplayStatus");
           if(domId != null)
           domId.style.border= "2px solid #19afd5";
           component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
        }*/
    },
    
    //Help Menu open
    HelpMenu :function(component, event, helper){  
        component.set("v.HelpIcons", true);
        //component.set('v.openTrailWindow',!component.get('v.openTrailWindow'));
        const div =document.getElementById('trialWindow');
        $A.util.toggleClass(div, 'slds-hide');
        
        
       //code to de-highlight the highlighted fields once help menu is closed
 var domId1 = document.getElementById("TempDispalyForProduct");
        if(domId1 != null)
        domId1.style.border= "";
        var domId2 = document.getElementById("TempDispalyForLocation");
        if(domId2 != null)
        domId2.style.border= "";
        var domId3 = document.getElementById("TempDisplayforlotproduct");
        if(domId3 != null)
        domId3.style.border= "";
        var domId4 = document.getElementById("TempDisplayforlot");
        if(domId4 != null)
        domId4.style.border= "";
        var domId5 = document.getElementById("TempDisplayStatus");
        if(domId5 != null)
        domId5.style.border= "";
        var domId6 = document.getElementById("TempDisplayComment");
        if(domId6 != null)
        domId6.style.border= "";
         //code Ends here
        
    },
    
	showInv : function(component, event, helper) {
		component.set("v.showModules", true);        
        component.set("v.showInv", true);
        component.set("v.showInvLocation", false);
		component.set("v.showSearchInv", false);       
        component.set("v.showReleaseInv", false);   
        component.set("v.showImportBulkPrd", false); 
        component.set("v.showImportSerializedPrd", false); 
        component.set("v.showLots", false); 
        
        component.set("v.showHelpMnu", false);
        component.set("v.HelpIcons", false);

        
	},
    showInvLoc : function(component, event, helper) {
		component.set("v.showModules", true);        
        component.set("v.showInv", false);
        component.set("v.showInvLocation", true);        
		component.set("v.showSearchInv", false);       
        component.set("v.showReleaseInv", false);   
        component.set("v.showImportBulkPrd", false); 
        component.set("v.showImportSerializedPrd", false); 
        component.set("v.showLots", false); 
        
        component.set("v.showHelpMnu", false);
        component.set("v.HelpIcons", false);
	},
    showSrchInv :  function(component, event, helper) {
		component.set("v.showModules", true);        
        component.set("v.showInv", false);
        component.set("v.showInvLocation", false);
		component.set("v.showSearchInv", true);       
        component.set("v.showReleaseInv", false);   
        component.set("v.showImportBulkPrd", false); 
        component.set("v.showImportSerializedPrd", false);
        component.set("v.showLots", false);   
        
        component.set("v.showHelpMnu", true);
        var currentObject;
        if(event.currentTarget)
            currentObject=event.currentTarget.name;
       
        component.set('v.currectObject',currentObject);
         
        if(component.get('v.currectObject')=='SearchInventory')
           // component.set('v.description','Help Menu - Search Inventory');       
        
            var str1 = "Search Inventory Tab ";
			var str2 = "Functionality : Provides Information regarding Product Inventory Status in one/many locations";
			
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
        //end
  
        
	},
    showRelInv :  function(component, event, helper) {
		component.set("v.showModules", true);        
        component.set("v.showInv", false);
        component.set("v.showInvLocation", false);
		component.set("v.showSearchInv", false);       
        component.set("v.showReleaseInv", true);   
        component.set("v.showImportBulkPrd", false); 
        component.set("v.showImportSerializedPrd", false);
        component.set("v.showLots", false); 
        
        component.set("v.showHelpMnu", true);
        var currentObject;
        if(event.currentTarget)
            currentObject=event.currentTarget.name;
       
        component.set('v.currectObject',currentObject);
        
        if(component.get('v.currectObject')=='ReleaseInventory')
            //component.set('v.description','Help Menu - Release Inventory');       
        
            var str1 = " Release Inventory Tab ";
			var str2= "Functionality : To Release the allocated Stock against an Order back into the Inventory";
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
        //end
  
	},
    showImpBulkPrd : function(component, event, helper) {
		component.set("v.showModules", true);        
        component.set("v.showInv", false);
        component.set("v.showInvLocation", false);
		component.set("v.showSearchInv", false);       
        component.set("v.showReleaseInv", false);   
        component.set("v.showImportBulkPrd", true); 
        component.set("v.showImportSerializedPrd", false); 
        component.set("v.showLots", false);   
        
        component.set("v.showHelpMnu", false);
        component.set("v.HelpIcons", false);
	},
    showSerlzPrd : function(component, event, helper) {
		component.set("v.showModules", true);        
        component.set("v.showInv", false);
        component.set("v.showInvLocation", false);
		component.set("v.showSearchInv", false);       
        component.set("v.showReleaseInv", false);   
        component.set("v.showImportBulkPrd", false); 
        component.set("v.showImportSerializedPrd", true);
        component.set("v.showLots", false); 
        
        component.set("v.showHelpMnu", false);
        component.set("v.HelpIcons", false);
	},
    showLot : function(component, event, helper) {
		component.set("v.showModules", true);        
        component.set("v.showInv", false);
        component.set("v.showInvLocation", false);
		component.set("v.showSearchInv", false);       
        component.set("v.showReleaseInv", false);   
        component.set("v.showImportBulkPrd", false); 
        component.set("v.showImportSerializedPrd", false);
        component.set("v.showLots", true);  
        
        component.set("v.showHelpMnu", true);
        var currentObject;
        if(event.currentTarget)
            currentObject=event.currentTarget.name;
       
        component.set('v.currectObject',currentObject);
        
        if(component.get('v.currectObject')=='LotView')
            //component.set('v.description','Help Menu - Lot View');       
        
            var str1 = " Lot View Tab ";
			var str2= "Functionality : To search for inventory details based on Lot number";
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
        //end
  
	},
    closeInfo : function(component, event, helper){		        
        component.set("v.showIcons", false);
    },
    showInfo :  function(component, event, helper){        
        component.set("v.showIcons", true);
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
    } 


})