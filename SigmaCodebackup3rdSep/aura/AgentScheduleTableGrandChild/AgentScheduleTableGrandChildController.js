({
    doinit : function(component, event, helper) {
        debugger;
        var printWOCount = parseInt(component.get("v.printWOCount"));
        var woCount = parseInt(component.get("v.woCount"));
        var eachvalue=component.get('v.eachValue');
        if(eachvalue.available=='NW'){
            if($A.util.hasClass(borderclass,'tech-busy-start')){
                $A.util.removeClass(borderclass,'tech-busy-start');                
            }
            if($A.util.hasClass(borderclass,'tech-busy-inbetween')){
                $A.util.removeClass(borderclass,'tech-busy-inbetween');
            }
            if($A.util.hasClass(borderclass,'tech-busy-end')){
                $A.util.removeClass(borderclass,'tech-busy-end');  
            }
            
            component.set('v.emptySlot',false);
            component.set('v.slotBusy',false);
            component.set('v.Breakslot',true);
            component.set('v.BreakValue','NW');
        }
        else if(eachvalue.available=='Available' && eachvalue.duration>=1){
            component.set('v.slotBusy',true);
            var borderclass = component.find('Time-8');
            if(eachvalue.start==true && eachvalue.mid==false && eachvalue.stop==false){ 
                if(!$A.util.hasClass(borderclass,'tech-busy-start')){
                    $A.util.addClass(borderclass,'tech-busy-start');
                    if($A.util.hasClass(borderclass,'tech-busy-inbetween')){
                        $A.util.removeClass(borderclass,'tech-busy-inbetween');
                    }
                    if($A.util.hasClass(borderclass,'tech-busy-end')){
                        $A.util.removeClass(borderclass,'tech-busy-end');  
                    }
                }
                woCount++;
                if(printWOCount<1){
            component.set('v.printWO',true);
        }
        else{
            component.set('v.printWO',false);
        }
        printWOCount++;
            }
            
            else if(eachvalue.start==false &&  eachvalue.mid==true && eachvalue.stop==false ){
                if(!$A.util.hasClass(borderclass,'tech-busy-inbetween')){
                    $A.util.addClass(borderclass,'tech-busy-inbetween');
                    if($A.util.hasClass(borderclass,'tech-busy-start')){
                        $A.util.removeClass(borderclass,'tech-busy-start');                
                    }
                    if(!$A.util.hasClass(borderclass,'tech-busy-end')){
                        $A.util.removeClass(borderclass,'tech-busy-end');  
                    }
                }
                
            }
                else if(eachvalue.start==false && eachvalue.mid==false && eachvalue.stop==true){
                    if(!$A.util.hasClass(borderclass,'tech-busy-end')){
                        $A.util.addClass(borderclass,'tech-busy-end');
                        $A.util.removeClass(borderclass,'tech-busy-inbetween');
                    }
                    printWOCount = 0;
                    component.set("v.printWOCount",printWOCount);
                }
                    else{
                        if(!$A.util.hasClass(borderclass,'tech-busy-single')){
                            $A.util.addClass(borderclass,'tech-busy-single');
                            if($A.util.hasClass(borderclass,'tech-busy-start')){
                                $A.util.removeClass(borderclass,'tech-busy-start');                
                            }
                            if($A.util.hasClass(borderclass,'tech-busy-inbetween')){
                                $A.util.removeClass(borderclass,'tech-busy-inbetween');
                            }
                        }
                        woCount++;
                        if(printWOCount<1){
            component.set('v.printWO',true);
        }
        else{
            component.set('v.printWO',false);
        }
        
                    }
            
            component.set('v.woCount',woCount);
            component.set("v.printWOCount",printWOCount);
        }
            else{
                component.set('v.emptySlot',true);
            }  
    },
    navigate : function(component, event, helper) {
        
        var navEvt = $A.get("e.force:navigateToSObject");
        // alert(component.get("v.caserecordID"));
        navEvt.setParams({
            "recordId": component.get("v.eachValue.workOrderId")
        });
        navEvt.fire();
    }
})