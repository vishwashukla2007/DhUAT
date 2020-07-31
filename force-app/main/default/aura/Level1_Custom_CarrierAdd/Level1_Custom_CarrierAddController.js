({

    closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "False"  
      component.set("v.isOpen", false);
   },
 
   closesave: function(component, event, helper) {
      var carid = component.get("v.carrid");
         var platform = component.get("v.platform");
         var lob = component.get("v.lob");
         helper.createCarrierRecords(component, platform, lob, carid); 
  		 component.set("v.isOpen", false);

   }

})