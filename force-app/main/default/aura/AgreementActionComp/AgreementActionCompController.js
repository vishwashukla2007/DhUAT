({
    doInit : function(component, event, helper){
        var action = component.get("c.getPGInformation");
        action.setParams({ id : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
              console.log(response.getReturnValue());
              component.set("v.PG", response.getReturnValue());
              if(response.getReturnValue().Status__c == "Draft"){
                component.set("v.Draft", true);
                component.set("v.ApprovalInProg", false);
                component.set("v.Approved", false);
              }
              else if(response.getReturnValue().Status__c == "Approval In-Progress"){
                component.set("v.Draft", false);
                component.set("v.Approved", false);
              }
              else{
                component.set("v.Draft", false);
                component.set("v.ApprovalInProg", false);
                component.set("v.Approved", true);
              }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    create : function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Performance_Guarantee_Detail__c",
            "defaultFieldValues": {
                'Performance_Guarantees__c' : component.get("v.recordId")
            }
        });
        createRecordEvent.fire();
    },
    createPGSummary : function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Performance_Guarantees__c"
        });
        createRecordEvent.fire();
    },
    edit : function(component, event, helper) {
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": component.get("v.recordId")
        });
        editRecordEvent.fire();
    },
	gotoDataImportWizard : function(component, event, helper) {
		
		var base_url = window.location.origin;
		window.open("/dataImporter/dataImporter.app?objectSelection=Performance_Guarantee_Detail__c",'_blank');
		// var evt = $A.get("e.force:navigateToURL");
		// $A.get("e.force:navigateToURL").setParams({ 
		// 	"url": base_url + "/dataImporter/dataImporter.app?objectSelection=Performance_Guarantee_Detail__c"	
		// }).fire(); 
	},
	closeModal:function(component,event,helper){    
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        var cmpTarget2 = component.find('approvalModalbox');
        var cmpTarget3 = component.find('rejectModalbox');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        $A.util.removeClass(cmpTarget2, 'slds-fade-in-open'); 
        $A.util.removeClass(cmpTarget3, 'slds-fade-in-open'); 
    },
    openmodal: function(component) {
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open'); 
       
    },
    generate: function(component){
        component.set("v.Spinner", true); 
        var pg = component.get('v.PG');
        console.log(pg);
        var action = component.get('c.generateDocument');     
        action.setParams({  pgData: component.get('v.PG')});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success!',
                        message: 'The Performance Guarantee Document has been successfully generated.',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire(); 
                    $A.get('e.force:refreshView').fire();
                    component.set("v.Spinner", false);
                }
               
             
            }
            else if (state === "INCOMPLETE") {
                // do something
                component.set("v.Spinner", false);
            }
            else if (state === "ERROR") {
                  component.set("v.Spinner", false);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
    // ,
    // showSpinner: function(component, event, helper) {
    //     // make Spinner attribute true for display loading spinner 
    //      component.set("v.Spinner", true); 
    // },
    //  hideSpinner : function(component,event,helper){
    //   // make Spinner attribute to false for hide loading spinner    
    //     component.set("v.Spinner", false);
    //  }
})