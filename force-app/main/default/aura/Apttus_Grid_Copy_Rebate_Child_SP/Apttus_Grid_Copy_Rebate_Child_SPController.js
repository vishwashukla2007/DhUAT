({
    doInit : function(component, event, helper) {
        console.log("Percentage check1111"+component.get("v.percentageCheck"));
        //alert("Percentage check1111"+component.get("v.percentageCheck"));
        var yr = [];
        for (var i = 0; i < component.get("v.yearcount"); i++)  {
            var j = i+1;
            yr.push({value: j});
        }
        yr.push({
            value: 'All'
        });
        component.set("{!v.yearoptions}", yr);
        helper.fetchpicklistvalue(component, helper);
        component.set("v.basis",component.get("v.objects.Basis__c"));
        component.set("v.desc",component.get("v.objects.Specialty_Display_Name__c"));

    },
    handledelete : function(component, event, helper) {
        var cmpTarget = component.find("tablerow");
        $A.util.addClass(cmpTarget, "slds-has-error");
        component.set("{!v.isDeleteAlertOpen}", true);
    },
    closeDeleteAlert : function(component, event, helper) {
        var cmpTarget = component.find("tablerow");
        $A.util.removeClass(cmpTarget, "slds-has-error");
        component.set("{!v.isDeleteAlertOpen}", false);
    },
    handleupdate : function(component, event, helper) {
        component.set("{!v.lob}", event.getParam("lob"));
        component.set("{!v.objects.LOB2__c}",component.get("{!v.lob}"));
        
    },
    handleChange : function(component, event, helper) {
        var inputcmp1 = component.find("inputYear");
        if(inputcmp1 != undefined){
            var value = inputcmp1.get("v.value");
            component.set("{!v.objects.Year__c}",value);
        }
        var inputcmp2 = component.find("inputSpecForm");
        if(inputcmp2 != undefined){
            var value = inputcmp2.get("v.value");
            component.set("{!v.objects.Specialty_Formulary__c}",value);
        }
        var inputcmp3 = component.find("inputBasis");
        if(inputcmp3 != undefined){
            var value = inputcmp3.get("v.value");
            component.set("{!v.objects.Basis__c}",value);
        }
    },
    deleteSelectedRec : function(component, event, helper) {
        component.set("{!v.isDeleteAlertOpen}", false);
        component.set("{!v.display}", false);
        var objId = component.get("{!v.objects.Id}");
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success Message',
            message: 'Selected record(s) were deleted.',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
        
        var appEvent1 = $A.get("e.c:Apttus_Grid_Delete_RG_RowEvent");
        appEvent1.setParams({ 
            "isDeleteSuccess" : true,
            "section" : component.get("v.planDesignOption"),
            "delIndex" : component.get("v.currentIndex"),
            "delObjId" : objId
        });
        appEvent1.fire();
    },
    handleSaveController: function(component, event, helper) {
        helper.handleValidateHelper(component, event, helper);
        component.set("v.isSavedAndClose",event.getParam("isSavedAndClose"));
    },
    copystart: function(component, event, helper) {
        //alert('handleSaveNewHelper');
        helper.handleSaveNewHelper(component, event, helper);
        component.set("v.isSavedAndClose",event.getParam("isSavedAndClose"));
    }
    
})