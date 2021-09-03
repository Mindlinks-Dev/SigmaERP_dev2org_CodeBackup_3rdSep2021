({
    doInit: function(component, event, helper){ 
        //alert('inside...cntlist controller');
        // helper.Blockedhoursoftechnician(component,event);   // To load blocked hours of the technician
        debugger;
        var eachSlotDuration = parseFloat(component.get("v.eachSlotDuration"));
        //alert(eachSlotDuration);
        //-- this map holds all the technician details along with the WOA 
        var map = component.get("v.ListOfContacts");
        
         //alert('inside...cntlist controller..10'+JSON.stringify(map));
        //--holds the technician id
        var key = component.get("v.key");
        
        //--holds current WO preferred date
        var preferredDateTime = component.get("v.PreferredDate");
        
        //--holds current WO zip code
        var serviceZipCode = component.get("v.serviceZipCode"); 
       
        component.set('v.serviceZipCode', serviceZipCode);
       // alert('serviceZipCode>>>21-'+serviceZipCode);
        //--holds current WO related contact
        var presentWOContact =component.get("v.PresentWOContact");
        component.set('v.PresentWOContact', presentWOContact);
        
        //--holds the technician zip code
        var technicianZipCode = ''
       
        component.set("v.value1" , map[key]);
        var arrayOfMapKeys = [];
        var result=component.get("v.value1");  
        
        //iterate through the technician details to show in Agent assignement page
        //alert('resultr..31'+JSON.stringify(result));
        for (var singlekey in result) {
            
            arrayOfMapKeys.push(singlekey);
             // alert('resultrarray..'+JSON.stringify(arrayOfMapKeys));
            if(singlekey=='sigmaerpdev2__Skill_Level__c')
            {                
                component.set('v.Skill', result[singlekey]);
            }else if(singlekey=='sigmaerpdev2__Service_Duration__c')
            {
                component.set('v.Duration', (result[singlekey]));
                component.set('v.DurationUI', (result[singlekey])*eachSlotDuration);
            }else if(singlekey =='contactName')
            {
                component.set('v.contactName', result[singlekey]);
                 //alert('contactName..'+component.get('v.contactName'));
            }else if(singlekey == 'MailingPostalCode')
            {
                component.set('v.technicianPostalCode', result[singlekey]);
                technicianZipCode = result[singlekey];
            }else if(singlekey == 'contactSpeed')
            {
                component.set('v.contactSpeed', result[singlekey]);  
             
            }
        }
        var slotKeyList = [];                
        //--holds the slot hour as key and value as true or false or LUNCH or NW#WOzipcode@@WOContactname
        var slotDetailsMap = new Object();
        
        //--holds the zip code details to calcualte the travel time
        var slotDurationMap = new Object();
        debugger;
        //--holds the details to create WOA on assignment
        var WOAMapDetails = new Object();
        WOAMapDetails['contactId']=key;
        WOAMapDetails['workOrderId']=component.get("v.currenWorkOrderId");
        WOAMapDetails['Duration']=component.get("v.Duration");
        WOAMapDetails['preferredDateTime']=preferredDateTime;
        component.set("v.WOADetails",WOAMapDetails);
        //alert( '0071>>>>'+JSON.stringify(component.get('v.WOADetails')));
         
        var isFirst = true;
        
        //--holds the previous Zip
        var previousZipCode = '';
        //--holds the previously allocated WO if any
        var previousWO = '';
        //--use this previous zip in case previous and current slot WO is same
        var previousAllocatedZipCode = '';
        var startHeader = parseInt(component.get('v.startHeader'));
        var endHeader = parseInt(component.get('v.endHeader'));
        
        /*if(eachSlotDuration == 1.0){
            var listOfHeadersHour = ['0.0','1.0','2.0','3.0','4.0','5.0','6.0','7.0','8.0','9.0','10.0','11.0','12.0','13.0','14.0','15.0','16.0','17.0','18.0','19.0','20.0','21.0','22.0','23.0','24.0'];
        }
        else if(eachSlotDuration == 0.5){
            var listOfHeadersHour = ['0.0','0.5','1.0','1.5','2.0','2.5','3.0','3.5','4.0','4.5','5.0','5.5','6.0','6.5','7.0','7.5','8.0','8.5','9.0','9.5','10.0','10.5','11.0','11.5','12.0','12.5','13.0','13.5','14.0','14.5','15.0','15.5','16.0','16.5','17.0','17.5','18.0','18.5','19.0','19.5','20.0','20.5','21.0','21.5','22.0','22.5','23.0','23.5','24.0'];
            startHeader = startHeader *2;
            endHeader = endHeader*2;
        }*/
		
		var listOfHeadersHour = component.get('v.indexHeaders');        
        
        //--iterate to get each slot details from 8 to 20
        for(var i=0 ; i<listOfHeadersHour.length;i++){
           
            slotKeyList.push(i);
            //slotAvailabilityMap = [8:"NW",9:"NW",10:"NW",12:"LUNCH",14:"A"]
            
            //-- iterate through the map to set each slot details
            if(listOfHeadersHour[i] in result){ 
                var slotDetails = result[listOfHeadersHour[i]];
               // alert('slotDetails'+JSON.stringify(slotDetails));
                //alert('slotDetails=='+JSON.stringify(slotDetails));
                //--if slot is LUNCH time set the slot details Map and set the zip Map to calculate travel time
                if(slotDetails == "LUNCH"){
                    slotDetailsMap[i] = "Lunch"+"#"+" ";
                    slotDurationMap[i]= technicianZipCode+'##'+serviceZipCode;
                    //previousZipCode = technicianZipCode;
                }
                //--if the slot NW
                else if(slotDetails == "NW"){
                    slotDetailsMap[i] = "NW"+"#"+" ";
                    slotDurationMap[i]= technicianZipCode+'##'+serviceZipCode;
                }else{
                    //--in case slot is assigned for any other WO
                    //alert('000113 new cnt'+JSON.stringify(result[listOfHeadersHour[i]]));
                    
                    //slotDetailsMap[i] = "true"+"#"+result[listOfHeadersHour[i]].sigmaerpdev2__Work_Order__r.sigmaerpdev2__Service_Zip_Postal_Code__c+"@@"+result[listOfHeadersHour[i]].sigmaerpdev2__Work_Order__r.sigmaerpdev2__Account__r.Name+"@@"+result[listOfHeadersHour[i]].sigmaerpdev2__Work_Order__r.Name+"@@"+result[listOfHeadersHour[i]].sigmaerpdev2__Work_Order__c;  
                    
                    slotDetailsMap[i] = "true"+"#"+result[listOfHeadersHour[i]].sigmaerpdev2__Work_Order__r.sigmaerpdev2__Service_Zip_Postal_Code__c+"@@"+result[listOfHeadersHour[i]].sigmaerpdev2__Work_Order__r.Name+"@@"+result[listOfHeadersHour[i]].sigmaerpdev2__Work_Order__c;                                  
                    //alert('slotDetailsMap1>>>>'+slotDetailsMap);
                    
                    //--in case of first allocated slot(red colour) add the zip code to map for distance calculation
                    if(isFirst){
                        isFirst = false;
                        //alert('line 125');
                        //--calculate from Contact/technician home
                        var currentWOZip = result[listOfHeadersHour[i]].sigmaerpdev2__Work_Order__r.sigmaerpdev2__Service_Zip_Postal_Code__c;
                        // previousZipCode = currentWOZip;
                        //slotDurationMap[i]= technicianZipCode+'##'+previousZipCode;
                        
                        //--in case previous slot was free/ available for allocation
                        if(previousZipCode != ''){
                            slotDurationMap[i]= previousZipCode+'##'+currentWOZip;
                            previousAllocatedZipCode = previousZipCode;
                        }else{
                            slotDurationMap[i]= technicianZipCode+'##'+currentWOZip;
                            previousAllocatedZipCode = technicianZipCode;
                        }                            
                        previousZipCode = currentWOZip;
                        previousWO = result[listOfHeadersHour[i]].sigmaerpdev2__Work_Order__c;
                        //previousAllocatedZipCode = technicianZipCode;
                    }                       
                    else{
                      // alert('line 140');
                        var currentWOZip = result[listOfHeadersHour[i]].sigmaerpdev2__Work_Order__r.sigmaerpdev2__Service_Zip_Postal_Code__c;
                        
                        //--incase previous slot was of same WO
                        if(result[listOfHeadersHour[i]].sigmaerpdev2__Work_Order__c == previousWO){
                            slotDurationMap[i]= previousAllocatedZipCode+'##'+currentWOZip;
                            //previousAllocatedZipCode = technicianZipCode;
                            previousZipCode = currentWOZip;
                        }else{
                            slotDurationMap[i]= previousZipCode+'##'+currentWOZip;
                            previousAllocatedZipCode = previousZipCode;
                            previousZipCode = currentWOZip;                                
                        }                            
                        previousWO = result[listOfHeadersHour[i]].sigmaerpdev2__Work_Order__c;
                    }
                }
            }
            //-if the slot is not allocated
            else{
                //alert('line 159');
                slotDetailsMap[i] = "false"+"#"+serviceZipCode+"@@"+presentWOContact;
                //---in case of first free slot have to consider the technician Zip as start Zip
                if(isFirst){
                    //isFirst = false; 
                    slotDurationMap[i]= technicianZipCode+'##'+serviceZipCode;
                    var index =i;
                    //--only in case of next slot is allocated, assign the previousSlot as current WO serviceZipcode
                    while(index <= endHeader){
                        index +=eachSlotDuration;
                        if(listOfHeadersHour[index] in result){
                            previousZipCode = serviceZipCode;
                            break;                                   
                        }else{
                            break;
                        }
                    }                                
                }else{
                    //previousZipCode = '';   //previous work order Zip and assign nothing                   
                    
                    slotDurationMap[i]= previousZipCode+'##'+serviceZipCode;
                    //previousZipCode = serviceZipCode;
                    var index =i;
                    //--only in case of next slot is allocated, assign the previousSlot as current WO serviceZipcode
                    while(index <= endHeader){
                        index +=eachSlotDuration;
                        if(listOfHeadersHour[index] in result){
                           // previousZipCode = serviceZipCode;
                            break;
                        }else{
                            break;
                        }                                       
                        //}
                    }
                }
                //}             
            }
        }    
       // alert('slotDurationMap'+JSON.stringify(slotDurationMap));
        console.log('slotDurationMap'+JSON.stringify(slotDurationMap));
     // alert('slotDetailsMap#197'+JSON.stringify(slotDetailsMap));
        component.set('v.slotDurationMap',slotDurationMap);
        component.set('v.slotMap', slotDetailsMap); 
        component.set('v.slotKeys', slotKeyList);                     
        
        //component.set('v.lstKey', arrayOfMapKeys);
        
    },
    setbooleanVariableFromChild:function(component, event, helper){
        var ValueOfBoolean=event.getParam('Slot');
     //   alert(ValueOfBoolean);
        component.set('v.HasSlot', ValueOfBoolean)
        //alert('>>'+component.get('v.HasSlot'));
        
    },
    
    /*
     * Navigate to the contact details page
     * */
    handleClick: function (component, event, helper) {
      
        window.open('/' + component.get("v.key"));  
    },
   
    
})