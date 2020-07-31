({
doInit : function(component, event, helper) 
    {  
	},
    handleEditBtn : function(component, event, helper) 
    {
        component.set("v.showModal", true);
        component.set("v.vfHost",window.location.hostname);
        var cinfo = component.get("v.recordId");
        component.set("v.params", 'Id'+'='+cinfo);
    },
   mchoiceBtn : function(component, event, helper) 
    {
      helper.createApprovalRequest(component);  
    },
  handleApplicationEvent: function(component, event, helper)
    {  
      var btnvisible = event.getParam("btnvisible");
      component.set("v.showEditBtn", btnvisible);
        
    }

})