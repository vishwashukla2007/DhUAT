({
    edit : function(component, event, helper) {
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": component.get("v.recordId")
        });
        editRecordEvent.fire();
    },
    showChangeDashboard : function(component, event, helper) {
        component.find("navService").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c__changeDashboard" 
            },
            state: { 
                "c__myAttr": component.get("v.recordId") 
            }
        }); 
	},
    agreementHierarchy :function(component, event, helper) {
        var flow = component.find("flowId");
        var inputVariables = [
            {
                name : 'recordId',
                type : 'String',
                value : component.get("v.recordId")
            }
        ];
        flow.startFlow("viewAgreementHierarcyByAccount",inputVariables);
    },
    printablePage : function(component, event, helper) {
        var ename = event.currentTarget.name;
        if(ename==null){
            ename = event.getSource().get("v.name");
        }
        var url = location.origin + '/apex/changeDashboardPrintPage?id=' + component.get("v.recordId") + '&type='+ ename;
        window.open(url, '_blank');
    },
})