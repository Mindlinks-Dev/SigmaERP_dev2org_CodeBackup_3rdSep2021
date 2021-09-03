({	
    init : function(component, event, helper){
        if($A.get("$Browser.formFactor") == "PHONE")
            component.set('v.mobileScreenFlag',true);
        //alert('from==='+component.get('v.mobileScreenFlag'));
        helper.helperMethod(component, event, helper);
        
        var fromModule = component.get("v.from");
        if(fromModule != undefined && fromModule != ''){
            if(fromModule == 'recipe'){
          		component.set("v.showModules", true);        
           		component.set("v.showRecpMgmt", true);
           		component.set("v.showIcons", false);          
            }else if(fromModule == 'MR'){
                component.set("v.showModules", true);        
           		component.set("v.showManfRun", true);
           		component.set("v.showIcons", false);  
            }    
        }else{
           component.set("v.showIcons", true); 
            
        }
    },
    
    showDemandPlanning : function(component, event, helper) {		
		component.set("v.showModules", true);        
        component.set("v.showDemandPlanng", true);
		component.set("v.showRecpMgmt", false);       
        component.set("v.showManfRun", false);  
        
        //Help Menu nav img
        component.set("v.showHelpMnu", true);
        var currentObject;
        if(event.currentTarget)
            currentObject = event.currentTarget.name;       
        component.set('v.currectObject',currentObject);        
        if(component.get('v.currectObject') == 'Demand Planning')
           // component.set('v.description','Help Menu - Demand Planning');   
           var str1 = " Demand Planning Tab";
        	var str2= " Functionality : To get the Demand for any Product";
            component.set('v.description', str1); 
        	component.set('v.descriptionBody', str2);    
       
        var objectFiledList=component.get('v.objectFiledList');
        var isDataPresent=false;
        for(var i=0;i<objectFiledList.length;i++)
        {
            if(objectFiledList[i].key == currentObject)
                isDataPresent=true;
        }
        if(!isDataPresent)
        {           
        	var trialFloatchatid=component.find('trialWindow');
                $A.util.removeClass(trialFloatchatid, "enter");
        }
        //End
        
	},
    showRecipeManagement : function(component, event, helper) {        
		component.set("v.showModules", true);        
		component.set("v.showRecpMgmt", true);
        component.set("v.showDemandPlanng", false);
        component.set("v.showManfRun", false);	
        
        //disable help menu - as its not implemented for popup
        component.set("v.showHelpMnu", false);
        component.set("v.HelpIcons", false);  
	},   
    showMR : function(component, event, helper) {        
		component.set("v.showModules", true);        
        component.set("v.showManfRun", true);              
        component.set("v.showDemandPlanng", false);
		component.set("v.showRecpMgmt", false);
        
        //Help Menu nav img
        component.set("v.showHelpMnu", true);
        
        var currentObject;
        if(event.currentTarget)
            currentObject=event.currentTarget.name;
      
        component.set('v.currectObject',currentObject);
       
        if(component.get('v.currectObject')=='Manufacturing Run')
           // component.set('v.description','Help Menu -Manufacturing Process'); 
           var str1 = "Manufacturing Run Tab";
        	var str2= "Functionality : To Plan,Schedule and Manufacture Product";
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
    
    //Help Menu for Highlighting element
    stepsOnclickHandler: function(component, event, helper){
          component.set("v.descriptionBody", "");
        
        var clickedIndexArray;
        if(event.currentTarget)
            clickedIndexArray = event.currentTarget.id.split("-");
        
        var jsonString = component.get('v.jsonString');
        var clickedStep = jsonString.chapters[clickedIndexArray[0]].steps[clickedIndexArray[1]];
             
        var domId1 = document.getElementById("TempToDisplayMRName");
        if(domId1 != null)
        domId1.style.border= "";
        var domId2 = document.getElementById("TempToDisplayRecp");
        if(domId2 != null)
        domId2.style.border= "";
        var domId3 = document.getElementById("TempToDisplayRecpProd");
        if(domId3 != null)
        domId3.style.border= "";
        var domId4 = document.getElementById("TempToDisplayQuantity");
        if(domId4 != null)
        domId4.style.border= "";
        var domId5 = document.getElementById("TempToDisplayStrtDate");
        if(domId5 != null)
        domId5.style.border= "";
        var domId6 = document.getElementById("TempToDisplayEndDate");
        if(domId6 != null)
        domId6.style.border= "";
        var domId7 = document.getElementById("TempToDisplayProduct");
        if(domId7 != null)
        domId7.style.border= "";
        var domId8 =document.getElementById("TempToDisplayProCategory");
        if(domId8 != null)
        domId8.style.border= ""; 
        var domId9 =document.getElementById("TempToDisplayFrom");
        if(domId9 != null)
        domId9.style.border= ""; 
        var domId10 =document.getElementById("TempToDisplayTo");
        if(domId10 != null)
        domId10.style.border= ""; 
        var domId11 =document.getElementById("TempToDisplayStatus");
        if(domId11 != null)
        domId11.style.border= ""; 
        var domId12 =document.getElementById("TempToDisplayMRPlantName");
        if(domId12 != null)
        domId12.style.border= "";
        var domId13 =document.getElementById("TempToDisplayMRPlantManager");
        if(domId13 != null)
        domId13.style.border= "";
        
        if(clickedStep.title.includes("Manufacturing Run Name")){
            var domId = document.getElementById("TempToDisplayMRName");
            if(domId != null)
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        } 
if(clickedStep.title.includes("MR Plant Name")){
            var domId = document.getElementById("TempToDisplayMRPlantName");
            if(domId != null)
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        }  
if(clickedStep.title.includes("Production Manager")){
            var domId = document.getElementById("TempToDisplayMRPlantManager");
            if(domId != null)
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";             
        }         
        if(clickedStep.title.includes("Recipe")){            
            var domId = document.getElementById("TempToDisplayRecp");
            if(domId != null)
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5";
        }
        if(clickedStep.title.includes("Product")){            
            var domId = document.getElementById("TempToDisplayRecpProd");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
        }
        if(clickedStep.title.includes("Quantity")){            
            var domId = document.getElementById("TempToDisplayQuantity");
            if(domId != null)
            domId.style.border= "2px solid #19afd5"; 
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
        }
        if(clickedStep.title.includes("Start Date")){            
            var domId = document.getElementById("TempToDisplayStrtDate");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
        }
        if(clickedStep.title.includes("End Date")){            
            var domId = document.getElementById("TempToDisplayEndDate");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
        }
       
        
        //Demand Planning
        if(clickedStep.title.endsWith("Product")){            
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
        }
    },
        
    //Help Menu drag
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
        dragElement(document.getElementById("trialWindow"));
    },
    
    //Help Menu open
    HelpMenu :function(component, event, helper){  
        component.set("v.HelpIcons", true);        
        var div1 = document.getElementById('trialWindow');        
        $A.util.toggleClass(div1, 'slds-hide');
        
        //code to de-highlight the highlighted fields once help menu is closed
        var className1 = document.getElementById("trialWindow").className;
        if(className1.includes("slds-hide")){ 
            var objName = component.get('v.currectObject');
            if(objName == 'Demand Planning'){
            	var domId1 = document.getElementById("TempToDisplayProduct");
                if(domId1 != null)
                    domId1.style.border= "";
                
                var domId2 = document.getElementById("TempToDisplayProCategory");
                if(domId2 != null)
                    domId2.style.border= "";
                
                var domId3 = document.getElementById("TempToDisplayFrom");
                if(domId3 != null)
                    domId3.style.border= "";
                
                var domId4 = document.getElementById("TempToDisplayTo");
                if(domId4 != null)
                    domId4.style.border= "";
                
				var domId5 = document.getElementById("TempToDisplayStatus");
                if(domId5 != null)
                    domId5.style.border= "";
            }
            if(objName == 'Manufacturing Run'){
                var domId1 = document.getElementById("TempToDisplayMRName");
                if(domId1 != null)
                    domId1.style.border= "";
                
                var domId2 = document.getElementById("TempToDisplayRecp");
                if(domId2 != null)
                    domId2.style.border= "";
                
                var domId3 = document.getElementById("TempToDisplayRecpProd");
                if(domId3 != null)
                    domId3.style.border= "";
                
                var domId4 = document.getElementById("TempToDisplayQuantity");
                if(domId4 != null)
                    domId4.style.border= "";
                
				var domId5 = document.getElementById("TempToDisplayStrtDate");
                if(domId5 != null)
                    domId5.style.border= "";
                
                var domId6 = document.getElementById("TempToDisplayEndDate");
                if(domId6 != null)
                    domId6.style.border= "";
                 var domId7 = document.getElementById("TempToDisplayMRPlantName");
                if(domId7 != null)
                    domId7.style.border= "";
                 var domId8 = document.getElementById("TempToDisplayMRPlantManager");
                if(domId8 != null)
                    domId8.style.border= "";
            }
        }
        //ends here
    },
})