({
    doInit : function(component, event, helper) {
        console.log("Percentage check1111"+component.get("v.percentageCheck"));
        //alert("Retail_30__c check1111"+component.get("{!v.objects.Retail_30__c}"));
        var yr = [];
        for (var i = 0; i < component.get("v.yearcount"); i++)  {
            var j = i+1;
            yr.push({value: j});
        }
        yr.push({
            value: 'All'
        });
        component.set("{!v.yearoptions}", yr);
		//component.set("{!v.desc}", desc);
		console.log('Custom Des'+component.get("{!v.desc}"));
        //alert('--'+component.get("v.currentIndex"));
        helper.fetchpicklistvalue(component, helper);
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
		component.set("{!v.objects.Custom_Description__c}",component.get("{!v.desc}"));
        component.set("{!v.Custom_Description__c}",component.get("{!v.desc}"));
        alert('Custom Des'+component.get("{!v.desc}"));
        
    },
    handleChange : function(component, event, helper) {
        var inputcmp1 = component.find("inputYear");
        var value = inputcmp1.get("v.value");
        component.set("{!v.objects.Year__c}",value);
        
        var inputcmp3 = component.find("inputBasis");
        if(inputcmp3 != undefined){
            var value = inputcmp3.get("v.value");
            component.set("{!v.objects.Basis__c}",value);
        }
    },
    deleteSelectedRec : function(component, event, helper) {
        component.set("{!v.isDeleteAlertOpen}", false);
        if (component.get("{!v.objects.Id}") == null || component.get("{!v.objects.Id}") == 'undefined') {
            component.set("{!v.display}", false);
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Success Message',
                message: 'Selected record(s) were deleted.',
                type: 'success',
                mode: 'pester'
            });
            toastEvent.fire();
            //var appEventD = $A.get("e.c:Apttus_Grid_Delete_RG_RowEvent");
            //appEventD.fire();
            var appEvent1 = $A.get("e.c:Apttus_Grid_Delete_RG_RowEvent");
            appEvent1.setParams({ 
                "isDeleteSuccess" : true,
                "section" : component.get("v.planDesignOption"),
                "delIndex" : component.get("v.currentIndex"),
                "delObjId" : null
            });
            appEvent1.fire();
        }
        //alert('-11--'+component.get("{!v.objects.Id}"));
        if (component.get("{!v.objects.Id}") != null && component.get("{!v.objects.Id}") != 'undefined') {
            //var appEvent = $A.get("e.c:Apttus_Grid_Inactive_Parent_Event");
            //appEvent.fire();
            helper.deleteSelectedRecords(component,event,helper);
        }
    },
    handleSaveController: function(component, event, helper) {
        helper.handleSaveNewHelper(component, event, helper);
        component.set("v.isSavedAndClose",event.getParam("isSavedAndClose"));
    },
    
    
})