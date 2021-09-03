({
    init : function(component, event, helper){        
       helper.helperMethod(component, event, helper);
              
        
        //Help Menu Start
       /* var jsonString = {};
        jsonString['Purchase'] =[];
        jsonString['Purchase'].push('Vendor Name');
        jsonString['Purchase'].push('Status');
        jsonString['Purchase'].push('Order Date');
        jsonString['Purchase'].push('Expected Date');
        jsonString['Purchase'].push('Currency');
        jsonString['Purchase'].push('Add Product');
        
        jsonString['Stock'] =[];
        jsonString['Stock'].push('Vendor');
        jsonString['Stock'].push('Contact');
        jsonString['Stock'].push('Location');
		jsonString['Stock'].push('Received DateTime');
        jsonString['Stock'].push('Select PO');
        
        component.set('v.jsonString',jsonString); */ 
        setTimeout(function(){
            var jsonString = component.get("v.jsonString");
          }, 2000);
        
        /* var objectFiledList = [];
        for(var key in jsonString){
            objectFiledList.push({value:jsonString.steps, key:jsonString.chapters});
        }*/
              
        //End
        var fromModule = component.get("v.from");
        if(fromModule != undefined && fromModule !=''){
            if(fromModule == 'PO'){
                component.set("v.showModules", true);        
                component.set("v.showPurchaseOrder", true);
                component.set("v.showIcons", false);          
            }else if(fromModule == 'SR'){
                component.set("v.showModules", true);        
                component.set("v.showSRecvng", true);
                component.set("v.showIcons", false);  
            }   
        }else{
            component.set("v.showIcons", true);  
        }
    },
    //Help Menu for Highlighting element
    stepsOnclickHandler: function(component, event, helper){
        component.set("v.descriptionBody", "");
        //document.getElementById("stepDiscriptionHead").className = "fontClass"; 
        
         var clickedIndexArray;
        if(event.currentTarget)
            clickedIndexArray=event.currentTarget.id.split("-");
        //alert(clickedIndexArray);
        
        var jsonString=component.get('v.jsonString');
        var clickedStep=jsonString.chapters[clickedIndexArray[0]].steps[clickedIndexArray[1]];
        //alert(JSON.stringify(clickedStep));
        
        //var clickedFeild;
        //if(event.currentTarget){
        //    clickedFeild=event.currentTarget.name;
        //   }  
        var domId14 = document.getElementById("TempDispalyForAccountLookupTest");
        if(domId14 != null)
        domId14.style.border= "";
        var domId1 = document.getElementById("TempDispalyForAccountLookup");
        if(domId1 != null)
        domId1.style.border= "";
        var domId2 = document.getElementById("TempToDisplayStatus");
        if(domId2 != null)
        domId2.style.border= "";
        var domId3 = document.getElementById("TempToDisplayOrder");
        if(domId3 != null)
        domId3.style.border= "";
        var domId4 = document.getElementById("TempToDisplayExpected");
        if(domId4 != null)
        domId4.style.border= "";
        var domId5 = document.getElementById("TempToDisplayCurrency");
        if(domId5 != null)
        domId5.style.border= "";
        var domId6 = document.getElementById("addPOrderContent");
        if(domId6 != null)
        domId6.style.border= "";
        var domId7 =document.getElementById("VendorID");
        if(domId7 != null)
        domId7.style.border= ""; 
        var domId8 =document.getElementById("ContactID");
        if(domId8 != null)
        domId8.style.border= ""; 
        var domId9 =document.getElementById("LocId");
        if(domId9 != null)
        domId9.style.border= ""; 
        var domId10 =document.getElementById("DateTimeID");
        if(domId10 != null)
        domId10.style.border= "";
        var domId11 =document.getElementById("SelectPOId");
        if(domId11 != null)
        domId11.style.border= ""; 
        var domId12 =document.getElementById("prodBarCode");
        if(domId12 != null)
        domId12.style.border= ""; 
        
        var domId13 =document.getElementById("truckN");
        if(domId13 != null)
        domId13.style.border= ""; 
        
        //component.set('v.field',clickedFeild);
        //component.set('v.description','Enter the '+clickedFeild+' for the '+component.get('v.currectObject')+'.');
        //var dom111=document.getElementById(clickedIndexArray);
        //dom111.style.color="springgreen";
        if(clickedStep.title.includes("Vendor")){
            var domId = document.getElementById("TempDispalyForAccountLookup");
            if(domId != null){
                component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
                domId.style.border= "2px solid #19afd5";  
            }
            var domId1 = document.getElementById("TempDispalyForAccountLookupTest");
            if(domId1 != null)
                domId1.style.border= "2px solid #19afd5";
            
            //setTimeout(function () {document.getElementById('foo').style.display='none'}, 10000);
        }         
        if(clickedStep.title.includes("Status")){
            /* var obj=jsonString[0];
            if(obj!=null){
                obj.style.border="";
            jsonString.pop();
            }*/
            var domId = document.getElementById("TempToDisplayStatus");
            if(domId != null)
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
            domId.style.border= "2px solid #19afd5"; 
            //jsonString['domClicked'].push(domId);
        }
        if(clickedStep.title.includes("Order")){            
            var domId = document.getElementById("TempToDisplayOrder");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
        }
        if(clickedStep.title.includes("Expected")){            
            var domId = document.getElementById("TempToDisplayExpected");
            if(domId != null)
            domId.style.border= "2px solid #19afd5"; 
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
        }
        if(clickedStep.title.includes("Currency")){            
            var domId = document.getElementById("TempToDisplayCurrency");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
        }
        if(clickedStep.title.includes("Add")){           
            var domId = document.getElementById("addPOrderContent");
            if(domId != null)
            domId.style.border= "2px solid #19afd5";
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
        }
        //Stock 
        if(clickedStep.title.includes("vendor")){            
			var domIdVend = document.getElementById("VendorID"); 
            if(domIdVend != null)
            domIdVend.style.border= "2px solid #19afd5";
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
          }
        if(clickedStep.title.includes("Contact")){            
			var domIdVend = document.getElementById("ContactID"); 
            if(domIdVend != null)
            {
                    component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
					 domIdVend.style.border= "2px solid #19afd5";          
            }
           
          }
        
        if(clickedStep.title.includes("Location")){
			var domIdVend = document.getElementById("LocId");             
            if(domIdVend != null)
            domIdVend.style.border= "2px solid #19afd5";
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
          }
        if(clickedStep.title.includes("Truck number")){			           
			var domIdVend = document.getElementById("truckN");
            if(domIdVend != null)
            domIdVend.style.border= "2px solid #19afd5";
            component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
          }
        if(clickedStep.title.includes("DateTime")){  
           var domId = document.getElementById("DateTimeID");
           if(domId != null)
           domId.style.border= "2px solid #19afd5";
           component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
        } 
        if(clickedStep.title.includes("Select PO")){  
           var domId = document.getElementById("SelectPOId");
           if(domId != null)
           domId.style.border= "2px solid #19afd5";
           component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
        }
        if(clickedStep.title.includes("Product BarCode")){  
           var domId = document.getElementById("prodBarCode");
           if(domId != null)
           domId.style.border= "2px solid #19afd5";
           component.set('v.description',clickedStep.content.replace('<p>','').replace('</p>',''));
        }        
    },
    
    closeInfo : function(component, event, helper){		        
        component.set("v.showIcons", false);
    },
    showInfo :  function(component, event, helper){        
        component.set("v.showIcons", true);
    },
    //Help Menu open
    HelpMenu :function(component, event, helper){ 
        
        component.set("v.HelpIcons", true);
        //component.set('v.openTrailWindow',!component.get('v.openTrailWindow'));
        const div =document.getElementById('trialWindow');
        $A.util.toggleClass(div, 'slds-hide');
        
        //code to de-highlight the highlighted fields once help menu is closed
        var domId14 = document.getElementById("TempDispalyForAccountLookupTest");
        if(domId14 != null)
        domId14.style.border= "";
        var domId1 = document.getElementById("TempDispalyForAccountLookup");
        if(domId1 != null)
        domId1.style.border= "";
        var domId2 = document.getElementById("TempToDisplayStatus");
        if(domId2 != null)
        domId2.style.border= "";
        var domId3 = document.getElementById("TempToDisplayOrder");
        if(domId3 != null)
        domId3.style.border= "";
        var domId4 = document.getElementById("TempToDisplayExpected");
        if(domId4 != null)
        domId4.style.border= "";
        var domId5 = document.getElementById("TempToDisplayCurrency");
        if(domId5 != null)
        domId5.style.border= "";
        var domId6 = document.getElementById("addPOrderContent");
        if(domId6 != null)
        domId6.style.border= "";
        var domId7 =document.getElementById("VendorID");
        if(domId7 != null)
        domId7.style.border= ""; 
        var domId8 =document.getElementById("ContactID");
        if(domId8 != null)
        domId8.style.border= ""; 
        var domId9 =document.getElementById("LocId");
        if(domId9 != null)
        domId9.style.border= ""; 
        var domId10 =document.getElementById("DateTimeID");
        if(domId10 != null)
        domId10.style.border= "";
        var domId11 =document.getElementById("SelectPOId");
        if(domId11 != null)
        domId11.style.border= "";
        var domId12 =document.getElementById("prodBarCode");
        if(domId12 != null)
        domId12.style.border= "";
        var domId13 =document.getElementById("truckN");
        if(domId13 != null)
        domId13.style.border= ""; 
        
        //code Ends here
    },
    showPurchaseOrders :  function(component, event, helper){ 
        component.set("v.showHelpMenu", true);
        component.set("v.showModules", true);        
        component.set("v.showPurchaseOrder", true);
        component.set("v.showMultiplePurchaseOrder", false);
        component.set("v.showSRecvng", false); 
        component.set("v.showIcons", false);
        //Help menu Image nav
         
        
        var currentObject;
        if(event.currentTarget)
            currentObject=event.currentTarget.name;
        //var currentObjectId =document.getElementById('Purchase');
       // alert('currentObjectId'+currentObject)
        component.set('v.currectObject',currentObject);
         //alert('currentObjectIdObject'+component.get('v.currectObject'))
        if(component.get('v.currectObject')=='Purchase')
            //component.set('v.description','Help Menu - Purchase order');
                        
            var str1 = "Purchase Orders Tab ";
			var str2= "Functionality : To create Purchase Order for Vendor";
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
    showMultiplePurchaseOrders :  function(component, event, helper){
        component.set("v.showHelpMenu", true);
        component.set("v.showModules", true);        
        component.set("v.showMultiplePurchaseOrder", true);
        component.set("v.showPurchaseOrder", false);
        component.set("v.showSRecvng", false); 
        component.set("v.showIcons", false);
    },
    showSR :  function(component, event, helper){    
        component.set("v.showHelpMenu", true);
        component.set("v.showModules", true);  
        component.set("v.showMultiplePurchaseOrder", false);
        component.set("v.showPurchaseOrder", false);
        component.set("v.showSRecvng", true);
        component.set("v.showIcons", false);
        //Help Menu nav img
        var currentObject;
        if(event.currentTarget)
            currentObject=event.currentTarget.name;
        //var currentObjectId =document.getElementById('Purchase');
        //alert('currentObjectId'+currentObject)
        component.set('v.currectObject',currentObject);
        var str1 = "Stock Receiving Tab ";
			var str2= "Functionality : To Recieve goods From  Vendor";
            
        // alert('currentObjectIdObject'+component.get('v.currectObject'))
        if(component.get('v.currectObject')=='Stock'){
          //  component.set('v.description','Help Menu - Stock Receiving');  
            component.set('v.description', str1); 
        	component.set('v.descriptionBody', str2);
        }
                 
       
        var objectFiledList=component.get('v.objectFiledList');
        var isDataPresent=false;
        for(var i=0;i<objectFiledList.length;i++)
        {
            if(objectFiledList[i].key==currentObject)
                isDataPresent=true;
        }
        if(!isDataPresent)
        {
            //component.set('v.HelpIcons',false);
            //const div =document.getElementById('trialWindow');
            //document.getElementById("trialWindow").style.display = "none";
        	//$A.util.toggleClass(div, 'slds-hide');
        	var trialFloatchatid=component.find('trialWindow');
                $A.util.removeClass(trialFloatchatid, "enter");
        }
        //End
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
        //dragElement("myimage", "myresult"); 
        dragElement(document.getElementById("trialWindow"));
    } 

})