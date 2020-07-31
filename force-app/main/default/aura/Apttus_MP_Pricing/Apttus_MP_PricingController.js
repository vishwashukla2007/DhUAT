({
    doInit : function(component, event, helper) {
        
        var url_string = window.location.href;
        var url = new URL(url_string);
    }, 
    
    
    clickEdit : function(component, event, helper) {
        component.set("v.vfHost",window.location.hostname);
        component.set("v.mpEdit",true);
        var mpId = component.get("v.mailPricing").Id;
        component.set("v.mpParams","id="+mpId+'&isExpandableView=true');
        
    },
    closeDeleteAlert: function(component, event, helper) {
        component.set("v.isDeleteAlertOpen", false);
    },
    
    deletepricing : function(component, event, helper) {
        component.set("v.isDeleteAlertOpen", true);
        /*
          var recordId = component.get("v.mailPricing").Id;
        console.log('recordId::'+recordId);
        helper.deleteRecord(component, event);
        */
    },
    deleteRecord : function(component, event, helper) {
        helper.deleteMpRecord(component, event);
        
    }
})