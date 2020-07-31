({
	onChange : function(component, event, helper) 
    {    
        var tab = event.getSource();
		var appEvent = $A.get("e.c:Apttus_Grid_Name_Event");
        appEvent.setParams({ "gridname" : tab.get('v.id')});
		appEvent.fire();
	},
    stylechange : function(component, event, helper) 
    {
      var cmpTarget = component.find('modalheight');
      $A.util.addClass(cmpTarget, 'finalheight');
      component.set("v.DisplaySpinner", false);
      component.set("v.disablesavebtn", false);
    },
    create : function(component, event, helper) 
    {
        component.set("v.disablesavebtn", true);
	/*	if (component.get("{!v.value}")=="Network_Pricing__c")
        {
            component.set("v.disablesavebtn", true);
            var npoLabel = $A.get("$Label.c.FAFIDNetworkPricing");
            var npoId = component.get("v.OpsId");
            component.set("v.params", '/apex/NetworkPricingEditNewPage?lightning=true&'+npoLabel+'='+npoId);
    		component.set("v.clickNewModal", true);
            var cmpTarget = component.find('modalheight');
            $A.util.addClass(cmpTarget, 'initheight');
            component.set("v.DisplaySpinner", true);
   			var appEvent = $A.get("e.c:Apttus_Grid_NT_Open_Event");
            appEvent.setParams({ "message" : component.get("v.params")});
            appEvent.fire();	
        }
        
        if (component.get("{!v.value}")=="Mail_Pricing__c")
        {
            var npoLabel = $A.get("$Label.c.MailOperationsFieldId");
            var npoId = component.get("v.OpsId");
            component.set("v.params", '/apex/MailPricingEditNewPage?lightning=true&'+npoLabel+'='+npoId);
    		component.set("v.clickNewModal", true);
   			var appEvent = $A.get("e.c:Apttus_Grid_NT_Open_Event");
            appEvent.setParams({ "message" : component.get("v.params")});
            appEvent.fire();	
        } */
	},
    OpsIdupdate : function(component, event, helper) 
    {
        var OpsId = event.getParam("OpsId");
        component.set("{!v.OpsId}",OpsId);
        if (OpsId != null)
        {
             component.set("{!v.disablebtn}",false);
        }
        else
        {
            component.set("{!v.disablebtn}",true);
        }
    },
 updatepricing : function(component, event, helper) 
 {
  var appEvent = $A.get("e.c:Apttus_Grid_NT_Save_Event");
  appEvent.setParams({ "SaveRec" : true});
  appEvent.fire();	
 },
 cancel : function(component, event, helper) 
 {
  component.set("v.clickNewModal", false);
  var appEvent = $A.get("e.c:Apttus_Grid_NT_Close_Event");
  appEvent.fire();
 },
 handleCloseEdit : function(component, event, helper) 
 {
  component.set("v.clickNewModal", false);	
 },
 handleClose : function(component, event, helper) 
 {
  component.set("v.clickNewModal", false);	
 },
  handleError : function(component, event, helper) 
    {   var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
        var Errmsg = event.getParam("Error")
        var toastEvent = $A.get("e.force:showToast");
    	            toastEvent.setParams({
                                 title : 'Error!',
       				             mode : 'sticky',
                                 type : 'error',
        			             message : Errmsg,
                                 mode: 'sticky',
                                 duration:' 4000'
    					 });
         toastEvent.fire();
    },
})