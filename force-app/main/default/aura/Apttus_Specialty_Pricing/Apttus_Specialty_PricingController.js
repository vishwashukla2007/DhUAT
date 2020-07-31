({
	doInit : function(component, event, helper) {

	},
   
  	clickNew : function(component, event, helper) {
        var spoLabel = $A.get("$Label.c.SpecialtyOpsLabel");
        var spoId = component.get("v.spricing.Specialty_Operations__c");
        component.set("v.params", 'lightning=true&'+spoLabel+'='+spoId);
        component.set("v.clickNewModal", true);
    },
    clickEdit : function(component, event, helper) { 
        var recordId = component.get("v.spricing.Id");
        component.set("v.params", 'lightning=true&id='+recordId);   
        component.set("v.clickEditModal", true);  
    },
    closeDeleteAlert: function(component, event, helper) {
        helper.closeDeleteAlertPopup(component, event);
    },
    
    deletepricing : function(component, event, helper) {
        component.set("v.isDeleteAlertOpen", true);
        /*
          var recordId = component.get("v.specialtyPricing").Id;
        console.log('recordId::'+recordId);
        helper.deleteRecord(component, event);
        */
    },
    deleteRecord : function(component, event, helper) {
        helper.deleteSPRecord(component, event);
        component.set("v.isDeleteAlertOpen", false);

        
    },
    closeDeleteAlert : function(component, event, helper) {
        component.set("v.isDeleteAlertOpen", false);        
    }
})