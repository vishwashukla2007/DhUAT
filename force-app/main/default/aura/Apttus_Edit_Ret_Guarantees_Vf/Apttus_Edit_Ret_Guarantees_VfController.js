({
    doInit : function(component) {
        var vfOrigin = component.get("v.vfHost");
        window.addEventListener("message", function(event) {
            //if (event.origin !== vfOrigin) {
                // Not the expected origin: Reject the message!
             //   return;
            //}
            // Handle the message
            if(event.data == 'success') {
            	console.log(event.data);
                window.location.reload();
            }
        }, false);
    }
	/*doInit : function(component, event, helper) {
		var message = component.get("v.message");
        var vfOrigin = "LEXORIGIN";
        if (component.find("vfFrame").getElement() != null)
        {
        var vfWindow = component.find("vfFrame").getElement().contentWindow;
        vfWindow.postMessage(message, vfOrigin);
        }
	},
    closeModel : function(component, event, helper) {
        component.set("v.isOpen", false);
    }*/
})