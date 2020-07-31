({
    doInit : function(component, event, helper) {
        component.set("{!v.display}", true);
        var vfOrigin = component.get("v.vfHost");
        var message = component.get("v.message");
        //var vfOrigin = "https://" + component.get("v.vfHost") + '/apex/NetworkPricingEditNewPage?'+ component.get("v.params") +'?nooverride=1';
        //var vfWindow = component.find("vfFrame").getElement().contentWindow;
        //fWindow.postMessage(message, vfOrigin);
         window.addEventListener("message", function(event) {
           //if (event.origin !== vfOrigin) {
                // Not the expected origin: Reject the message!
            //    return;
            //}
            // Handle the message
            if(event.data == 'success') {
                    component.set("{!v.display}", false);
            	   //var appEvent = $A.get("e.c:Apttus_NT_Grid_Modal_Close_Event");
                   //appEvent.setParams({ "message" : true });
                   //appEvent.fire();
                   //helper.fireevent(component, event);
            }
        }, false);
    },
    
    display : function(component, event, helper) 
    {

        var parm = event.getParam("message");
        component.set("{!v.params}", parm);
        component.set("{!v.display}", true);
        
    }
    
})