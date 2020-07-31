({
	doInit : function(component, event, helper) 
    {
      helper.editcaveats(component, event, helper);
	},
    handleLOBPricing : function(component, event, helper) 
    {
        component.set("{!v.DisplaySpinner}", true);
		helper.redirectsetuppricing(component, event, helper);
	},
   
    handleGenerate : function(component, event, helper) 
    {
        component.set("{!v.DisplaySpinner}", true);
		helper.redirectgeneratedoc(component, event, helper);
	},
    handleAlert : function(component, event, helper) 
    {
		component.set("{!v.isDeleteAlertOpen}", true);
	},
    closeDeleteAlert : function(component, event, helper) 
    {
		component.set("{!v.isDeleteAlertOpen}", false);
	},
    giveFocus : function(component, event, helper) 
    {
		var cmpTarget = component.find('card');
        $A.util.addClass(cmpTarget, 'outerborderblue');
        var cmpTarget = component.find('outerborders');
        $A.util.addClass(cmpTarget, 'hidden');
        var appEvent = $A.get("e.c:Apttus_Grid_Close_New_Event");
        appEvent.setParams({
            "message" : component.get("v.item.LOB_Detail__c")});
        appEvent.fire();
	},
    giveBlur : function(component, event, helper) 
    {
		var cmpTarget = component.find('card');
        $A.util.removeClass(cmpTarget, 'outerborderblue');

	},
    highlightlob : function(component, event, helper) 
    {
        var lob = event.getParam("message")
        if (lob != component.get("v.item.LOB_Detail__c"))
        {
			var cmpTarget = component.find('card');
        	$A.util.removeClass(cmpTarget, 'outerborderblue');
        }
	},
   
})