({
	doInit : function(component, event, helper) 
    {
       var cmpTarget = component.find('card');
       $A.util.removeClass(cmpTarget, 'bordercolor');
       var cmpTarget = component.find('card');
       $A.util.addClass(cmpTarget, 'innercontainer');
       $A.util.addClass(cmpTarget, 'slds-card_boundary');
       if (component.get("{!v.selected}") == 0)
       {    
             var cmpTarget = component.find('card');
             $A.util.addClass(cmpTarget, 'bordercolor');
             var appEvent = $A.get("e.c:Apttus_PCD_Offer_Select_Event");
             appEvent.setParams({"offer" : component.get("{!v.item.Name}"),
                          "offerid" : component.get("{!v.item.Id}"),
                          "alertmsg" : component.get("{!v.item.Alert_Message__c}")});
             appEvent.fire();
       }
        
	},
    clickHandler : function(component, event, helper) 
    {
	   var cmpTarget = component.find('outerborder');
       $A.util.addClass(cmpTarget, 'bordercolor');
       var appEvent = $A.get("e.c:Apttus_PCD_Offer_Select_Event");
       appEvent.setParams({"offer" : component.get("{!v.item.Name}"),
                          "offerid" : component.get("{!v.item.Id}"),
                          "alertmsg" : component.get("{!v.item.Alert_Message__c}")});
       appEvent.fire();
	},
    handleofferEvent : function(component, event, helper) 
    {
        var offer = event.getParam("offer");
        if (offer != component.get("{!v.item.Name}"))
        {
            var cmpTarget = component.find('card');
            $A.util.removeClass(cmpTarget, 'bordercolor');
        }
         if (offer == component.get("{!v.item.Name}"))
        {
            var cmpTarget = component.find('card');
            $A.util.addClass(cmpTarget, 'bordercolor');
        }
    },
})