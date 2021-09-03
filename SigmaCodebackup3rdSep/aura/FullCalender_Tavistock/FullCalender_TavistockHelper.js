({
    loadDataToCalendar :function(data){        
        $('#calendar').fullCalendar({
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,basicWeek,basicDay'
            },
            defaultDate: '2016-04-01',
            editable: true,
            eventLimit: true,
            events:data
        });
    },

    tranformToFullCalendarFormat : function(component,events) {
        var eventArr = [];
        for(var i = 0;i < events.length;i++){
            eventArr.push({
                'id':events[i].Id,
                'start':events[i].StartDateTime,
                'end':events[i].EndDateTime,
                'title':events[i].Subject
            });
        }
        return eventArr;
    },

    fetchEvents : function(component) {
        var action = component.get("c.getEvents"); 
        var self = this;
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
                var eventArr = self.tranformToFullCalendarFormat(component,response.getReturnValue());
                self.loadDataToCalendar(component,eventArr);
                component.set("v.events",eventArr);
            }
        });

        $A.enqueueAction(action); 
    }, 
})