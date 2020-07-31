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

})