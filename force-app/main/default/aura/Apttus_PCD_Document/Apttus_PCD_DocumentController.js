({
	doInit : function(component, event, helper) 
    {
        component.set("v.displaycount", 2);
		helper.retrievedocument(component, event, helper);
	},
    ViewallDocs : function(component, event, helper) 
    {
        component.set("v.displaycount", component.get("v.doccount"));
	},
    ViewlessDocs : function(component, event, helper) 
    {
        component.set("v.displaycount", 2);
	},
    handleDocEvent : function(component, event, helper) 
    {
        component.set("v.displaycount", 2);
		helper.retrievedocument(component, event, helper);
	},
})