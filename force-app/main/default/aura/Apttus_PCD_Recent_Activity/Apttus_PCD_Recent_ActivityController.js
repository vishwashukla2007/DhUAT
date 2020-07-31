({
	doInit : function(component, event, helper) 
    {
        helper.getHistory(component, event);	
	},
    taskrefresh : function(component, event, helper) 
    {
        var taskid = event.getParam("accntid");
        component.set("v.taskid",taskid);
        helper.getHistory(component, event);
    },
    handleDocEvent : function(component, event, helper) 
    {
        helper.getHistory(component, event);	
	},
})