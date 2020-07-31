({

    doInit : function(component, event, helper) {
 
    },
    clickEdit : function(component, event, helper) { 
        var recordId = component.get("v.retailgurantee.Id");
        component.set("v.params", 'lightning=true&id='+recordId);   
        component.set("v.clickEditModal", true);  
	},
        handleClick: function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.retailgurantee.Id")
        });
        navEvt.fire();
    }
    
    /*
    onCheckboxSelect : function(component, event, helper) {
        var recordId = component.get("v.retailgurantee.Id");
        var record = component.get("v.retailgurantee");
        var value = event.getSource().get("v.value");
        console.log('is Checkbox selected'+value)
        console.log("recordId"+recordId)
        console.log('record'+record.Name)
        if(value) {
            console.log('If true')
        var compEvent = component.getEvent("oSelectedRecordEvent");
        compEvent.setParams({"recordByEvent" : record,
                             "recordId" : recordId,
                             
                            });  
        compEvent.fire();
        }
    },
    */
    
})