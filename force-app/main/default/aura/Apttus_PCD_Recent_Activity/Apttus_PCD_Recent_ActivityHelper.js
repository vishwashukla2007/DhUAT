({
	getHistory : function(component, event) 
    {
        var action = component.get("c.get_aggrhistory");
        action.setParams({"Recid": component.get("v.taskid")})
        action.setCallback(this, $A.getCallback(function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                  component.set("{!v.objects}",response.getReturnValue());
                  var item = component.get("{!v.objects}");
                  var itemcount  = item.length;
                  component.set("{!v.recordcount}",itemcount);         
            }
            else {
                //helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);	
	}
})