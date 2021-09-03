({
    doInit : function(component, event, helper) {
        var currentrec = component.get("v.recordId");
        component.set("v.carddetails.sigmaerpdev__SFDC_Account__c",currentrec);
    },
    
    save : function(component, event, helper) {
        var creditCardID = component.find('Credit_card_number');
        
        var creditCardNumber = creditCardID.get('v.value');
        creditCardNumber = creditCardNumber.replace(/ +/g, ""); //added to remove empty spaces b/w numbers if its pasted instead of typing
        var creditCardLength = 16;
        var mystring = creditCardNumber.substring(0, 2);
        if(mystring == '34' || mystring == '37')
            creditCardLength = 15;
        var creditCardType = component.get("v.selectedCardType");

        //code added to save card type 08-05
        component.set('v.carddetails.sigmaerpdev__Card_Type__c',creditCardType);
        //code ends
        if(creditCardNumber.length < creditCardLength || isNaN(creditCardNumber) || creditCardNumber == null)
        {
            creditCardID.set("v.errors", [{message:"Enter valid "+creditCardLength+" digit credit card number."}]);
            var spinners = component.find('spinner');
            $A.util.removeClass(spinners, 'slds-show');	
            return null;
        }else
        {
            creditCardID.set("v.errors", null);
        }
        var expiryID = component.find('Expiry_Date');
        var expiryYear = expiryID.get('v.value');
        
        var currentdate = new Date();  
        var curdate=currentdate.getFullYear();
        var curmonth=currentdate.getMonth() + 1;
        
        var expdate = new Date(expiryYear);
        var expdate=expdate.getFullYear();
        var cardHolderName =component.find('Card_holderName').get('v.value');
        var name=component.find('Card_holderName');
        if(cardHolderName== '' || cardHolderName == null)
        {
            name.set("v.errors", [{message:"Enter Card Holder Name."}]);
            var spinners = component.find('spinner');
            $A.util.removeClass(spinners, 'slds-show');	
            return null;
            
        }else
        {
            name.set("v.errors", null);
        }
        
        
        if(expiryYear== '' || expiryYear == null)
        {
            expiryID.set("v.errors", [{message:"Enter Expiry Year."}]);
            var spinners = component.find('spinner');
            $A.util.removeClass(spinners, 'slds-show');	
            return null;
            
        }else
        {
            expiryID.set("v.errors", null);
        }
        if(expdate < curdate)
        {
            expiryID.set("v.errors", [{message:"Your Card is Expired."}]);
            var spinners = component.find('spinner');
            $A.util.removeClass(spinners, 'slds-show');	
            return null;
        }
        else
        {
            expiryID.set("v.errors", null);            
        }
        
        var cardVerificationValue = component.find('cardVerificationValue');
        var CVV = component.find('cardVerificationValue').get('v.value'); 
        if(isNaN(CVV) || CVV == null || CVV == undefined)
        {
            cardVerificationValue.set("v.errors", [{message:"Enter valid CVV Number "}]);
            var spinners = component.find('spinner');
            $A.util.removeClass(spinners, 'slds-show');		
            return null;
        }
        else if(CVV.length < 3)
        {             
            cardVerificationValue.set("v.errors", [{message:"CVV Number should be of 3 digits "}]);
            var spinners = component.find('spinner');
            $A.util.removeClass(spinners, 'slds-show');	
            return null;
        }
            else
            {
                cardVerificationValue.set("v.errors", null);   
            }
        
        
        var savecarddetails = component.get("v.carddetails");
		component.set("v.Spinner",true);
        //code starts here on 5-5-2020 - added by rashmi to restrict duplicate card entry for same customer 
        var currentrec = component.get("v.recordId");
        var dupCardAction = component.get("c.fetchcardDetails");
        dupCardAction.setParams({					
            "customerId": currentrec
        });
        dupCardAction.setCallback(this, function (response) {
            var state = response.getState();	
            
            if(state == 'SUCCESS'){
                component.set("v.Spinner",true);	
                component.set("v.cardsinfoList",response.getReturnValue());
                var cardList= component.get("v.cardsinfoList");
                var  cardNumer=savecarddetails.sigmaerpdev__Credit_Card_No__c.substring(savecarddetails.sigmaerpdev__Credit_Card_No__c.length-4, savecarddetails.sigmaerpdev__Credit_Card_No__c.length).split("").reverse().join("");
                for(var j=0;j<cardList.length;j++)
                {
                    if(cardList[j].sigmaerpdev__Card_Number__c.substring(cardList[j].sigmaerpdev__Card_Number__c.length-4, cardList[j].sigmaerpdev__Card_Number__c.length)==cardNumer)
                    {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"error",
                            "title": "Error!",
                            "message": " Duplicate card entry is not allowed for same customer. "
                        });
                        toastEvent.fire(); 
                        component.set("v.isAlradyExist",true);
                        window.setTimeout(function(){
                           location.reload(); 
                        }, 500);
                        return;
                    }
                    if(cardList[j].sigmaerpdev__Default_Card__c==true && savecarddetails.sigmaerpdev__Default_Card__c==true)
                    {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"warning",
                            "title": "Warning!",
                            "message": " Default card already exist! Please uncheck existing card to make this card as default. "
                        });
                        toastEvent.fire(); 
                        component.set("v.isAlradyExist",true);
                        window.setTimeout(function(){
                           location.reload(); 
                        }, 500);
                        return;
                        
                    }
                    
                }
                //code ends here
                if(!component.get("v.isAlradyExist"))
                { 
                  component.set("v.Spinner",true);
                    var actioncardsave = component.get("c.cardsave"); 
                    actioncardsave.setParams
                    ({
                        "savecarddetails"  : savecarddetails
                    }); 
                    actioncardsave.setCallback(this, function(response2) 
                    {
                        var currentrec1 = component.get("v.recordId");
                        var state = response2.getState();
                        
                        if (state === "SUCCESS") 
                        {
                           var returnValues = response2.getReturnValue();      
                           if ( returnValues == null || returnValues == '')
                            {    
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "type":"error",
                                    "title": "Error!",
                                    "message": " Something went wrong!! Failed to save card details. "
                                });
                                toastEvent.fire(); 
                                return;
                            }
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "type":"success",
                                "title": "Success!",
                                "message": " Card details saved successfully. "
                            });
                            toastEvent.fire(); 
                          
                          /*if ((typeof sforce != 'undefined') && sforce && (!!sforce.one)) {
                                alert('currentrec1>>>'+currentrec1);
							//sforce.one.navigateToSObject(currentrec1);
                            //    window.location.href = "/one/one.app#/sObject/" +currentrec1;
                                var navEvt = $A.get("e.force:navigateToSObject");
                                navEvt.setParams({ "recordId": currentrec1,
                                                  "slideDevName": "related" 
                                                 }); 
                                navEvt.fire();   
                            }
                            else{
                                 alert('currentrec1111>>>'+currentrec1);
                                sforce.one.navigateToSObject(currentrec1);
                              // window.location.href = "/" + currentrec1;
                            } */
                             var navEvt = $A.get("e.force:navigateToSObject");
                                navEvt.setParams({ "recordId": currentrec1,
                                                  "slideDevName": "related" 
                                                 }); 
                                navEvt.fire();  
                        }
                    });    
                    $A.enqueueAction(actioncardsave); 			   
                }
            }
        });
        $A.enqueueAction(dupCardAction); 
        window.setTimeout(function(){
           component.set('v.Spinner', false); 
       	}, 2000);
    },
    checkForCardType : function(component, event, helper)
    {
        var accountNumber = component.get("v.carddetails.sigmaerpdev__Credit_Card_No__c");
        accountNumber = accountNumber.replace(/ +/g, ""); //added to remove empty spaces b/w numbers if its pasted instead of typing
        var result = "Enter card number";
        
        if (/^5[1-5]/.test(accountNumber))
        {
            result = "MasterCard";
        }
        
        //then check for Visa
        else if (/^4/.test(accountNumber))
        {
            result = "Visa";
        }
        
        //then check for AmEx
            else if (/^3[47]/.test(accountNumber))
            {
                result = "AmEx";
            }
        
        var temp = result;
        component.set("v.selectedCardType",temp);
        
    },
    getMonth : function(component,event,helper){
        var inputCmp = component.find("soStatus").get("v.value");
    },
    
    getYear : function(component,event,helper){
        var inputCmp = component.find("soStatus1").get("v.value");
    }
})