({
    doInit : function(component) {
        var vfOrigin = component.get("v.vfHost");
        
        window.addEventListener("message", function(event) {
            if(event.data == 'success') {
            	console.log(event.data);
                window.location.reload();
            }
        }, false);
    }

})