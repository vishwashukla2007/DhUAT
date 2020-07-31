({
    onPageReferenceChange : function(component, event, helper) {
        var pageReference = component.get("v.pageReference");
        component.set("v.recordId", pageReference.state.c__myAttr);
        var url = $A.get('$Resource.changeDashboardEmptyStateImg');
        component.set('v.backgroundImageURL', url);
        
        var action = component.get("c.compareAgreementAndFAF");
        action.setParams({"agreementId": component.get("v.recordId"),
                          "IsBatchJob" : false,
                          "agreeList" : null,
                          "owea" : null,
                          "IsForceRun" : false});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.fieldList", result.fieldValueList);
                component.set("v.fieldListSize", result.fieldValueList.length);
                component.set("v.isSync", result.isSync);
                component.set("v.agName", result.AgName);
                component.set("v.NoOfMismatch", result.NoOfMismatch);
                component.set("v.fieldChangeLogList", result.fieldChangeLogList);
                component.set("v.recHistCount", result.fieldChangeLogList.length);
                component.set("v.recAgreeList", result.recAgreeList);
                component.set("v.NoRecAgree", result.recAgreeList.length);
                component.set("v.recDocuList", result.recDocuList);
                component.set("v.NoRecDocu", result.recDocuList.length);
                if(result.fieldValueList.length !== 0){
                    component.set("v.currentStepInd", "1");
                    component.set("v.currentStepMark", true);
                }else{
                    //var action = component.get("c.viewReconcileHist");
                    var action = component.get("c.viewReconcileHist2");
                    action.setParams({"agreementId": component.get("v.recordId"),
                                      "filter": "viewUpdtLegalDoc"
                                     });
                    action.setCallback(this, function(response){
                        var state = response.getState();
                        if (state === "SUCCESS"){
                            var result = response.getReturnValue();
                            if(result.length !== 0){
                                component.set("v.currentStepInd", "2");
                                component.set("v.currentStepMark", true);
                                //component.set("v.fieldChangeLogList", result);
                                component.set("v.fieldList2", result.fieldValueList2);
                                //component.set("v.fieldChangeLogListSize", result.length);
                                component.set("v.fieldChangeLogListSize", result.fieldValueList2.length);
                                ////var getSelectedNumber = component.get("v.SelectedRecDocCount");
                                var getSelectedNumber = 0;
                                /*
                                for (var i = 0; i < result.length; i++) {
                                    if (result[i].Reconcile_to_Document__c == true) {
                                        getSelectedNumber++;
                                    }
                                }
                                if(result.length===getSelectedNumber){
                                    component.find("selectAllDocId").set("v.value", true);
                                    component.set("v.currentStepInd", "3");
                                    component.set("v.currentStepMark", false);
                                }
                                */
                                for (var i = 0; i < result.fieldValueList2.length; i++) {
                                    if (result.fieldValueList2[i].recToDoc2 == true) {
                                        getSelectedNumber++;
                                    }
                                }
                                if(result.fieldValueList2.length===getSelectedNumber){
                                    component.find("selectAllDocId").set("v.value", true);
                                    component.set("v.currentStepInd", "3");
                                    component.set("v.currentStepMark", false);
                                }
                                component.set("v.SelectedRecDocCount", getSelectedNumber);                          
                            }else{
                                component.set("v.currentStepInd", "3");
                                component.set("v.currentStepMark", false);
                            }
                        }
                    });
                    $A.enqueueAction(action);
                }        
            }else if (state === "ERROR") {
                var errors = response.getError();
                var errmessage = '';
                if (errors) {
                    for(var i=0; i < errors.length; i++) {
                        for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                            errmessage += (errmessage.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                        }
                        if(errors[i].fieldErrors) {
                            for(var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for(var j=0; j < thisFieldError.length; j++) {
                                    errmessage += (errmessage.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                }
                            }
                        }
                        if(errors[i].message) {
                            errmessage += (errmessage.length > 0 ? '\n' : '') + errors[i].message;
                        }
                    }
                } else {
                    errmessage = "Error Found. Please contact System Administrator";
                }
                //prevent save and next
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: errmessage,
                    //messageTemplate: 'Mode is pester ,duration is 4sec and Message is overrriden',
                    duration:' 2000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'sticky'
                });
                toastEvent.fire();
            }
        });
        component.set("v.headerAgCheckboxDef", "false");
        component.set("v.headerDoCheckboxDef", "false");
        $A.enqueueAction(action);
    },
    handleReconcile : function(component, event, helper) {
        event.getSource().set("v.disabled",true);
        component.set("v.SelectedRecAgCount",0);
        component.set("v.SelectedRecDocCount",0);
        window.setTimeout(
            $A.getCallback(function() {
                helper.handleReconcileHelper(component, event);
            }), 1000)
    },
    navigateToRec : function(component, event, helper) {
        
        var navLink = component.find("navLink");
        var pageRef = {
            type: 'standard__recordPage',
            attributes: {
                actionName: 'view',
                objectApiName: 'Apttus__APTS_Agreement__c',
                recordId : component.get("v.recordId") // change record id. 
            },
        };
        navLink.navigate(pageRef, true);
        //$A.get('e.force:refreshView').fire();
    },
    navigateToTab : function(component, event, helper) {
        var navLink = component.find("navLink");
        var pageRef = {
            type: 'standard__objectPage',
            attributes: {
                actionName: 'home',
                objectApiName: 'Apttus__APTS_Agreement__c',
            },
        };
        navLink.navigate(pageRef, true);
    },
    agreeCheckboxSelect : function(component, event, helper) {
        helper.CheckboxSelect(component, event, "Agreement"); 
    },
    docCheckboxSelect : function(component, event, helper) {
        helper.CheckboxSelect(component, event, "Document");
    },
    selectAllDocCheckbox : function(component, event, helper) {
        var selectedHeaderCheck = event.getSource().get("v.value");
        var updatedPaginationList = [];
        var PaginationList = component.get("v.fieldList2");
        // update the checkbox for 'PaginationList' based on header checbox 
        for (var i = 0; i < PaginationList.length; i++) {
            if (selectedHeaderCheck == true) {
                PaginationList[i].recToDoc2 = true;
            } else {
                PaginationList[i].recToDoc2 = false;
            }
            updatedPaginationList.push(PaginationList[i]);
        }
        component.set("v.fieldList2", updatedPaginationList);
        if (selectedHeaderCheck == true) {
            component.set("v.SelectedRecDocCount", component.get("v.fieldList2").length);
        }else{
            component.set("v.SelectedRecDocCount", 0);
        }
    },
    CheckboxSelect : function(component, event, chkboxName) {
        var selectedRec = event.getSource().get("v.value");
        var getSelectedNumber = component.get("v.SelectedRecDocCount");
        if (selectedRec === true) {
            getSelectedNumber++;
        } else {
            getSelectedNumber--;
            component.find("selectAllDocId").set("v.value", false);
        }
        component.set("v.SelectedRecDocCount", getSelectedNumber);    
        if (getSelectedNumber === component.get("v.fieldList2").length) {
            component.find("selectAllDocId").set("v.value", true);  
        }
    },
    upRecDoc : function(component, event, helper) {
        //var recordList = component.get("v.fieldChangeLogList");
        //var action = component.get("c.updateReconcile");
        var recordList = component.get("v.fieldList2");
        var action = component.get("c.updateReconcile2");
        action.setParams({
            "fieldValParam": JSON.stringify(recordList),
            "agreementId": component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                //alert(result);
                component.set("v.fieldList2",result);
                var toastTitle;
                var toastMessage;
                var action2 = component.get("c.viewReconcileHist2");
                action2.setParams({"agreementId": component.get("v.recordId"),
                                  "filter": "viewUpdtLegalDoc"
                                 });
                action2.setCallback(this, function(response){
                    var state = response.getState();
                    if (state === "SUCCESS"){
                        var result = response.getReturnValue();
                        if(result.fieldValueList2.length == 0){
                        	toastTitle = "Update to Legal Document Process Completed"
                    		toastMessage = "Legal Document is now up to date with Agreement Document."
                        }else{
                            toastTitle = "Progress Save"
                    		toastMessage = "Agreement Document Update Progress Saved!"
                        }
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : toastTitle,
                            message: toastMessage,
                            duration:'500',
                            key: 'info_alt',
                            type: 'success',
                            mode: 'dismissible'
                        });
                        toastEvent.fire();
                        $A.get('e.force:refreshView').fire();
                    }
                });
                $A.enqueueAction(action2);
            }else if(state === "ERROR"){
                var errors = response.getError();
                if (errors) {
                    var errmessage = [];
                    for(var i=0; i < errors.length; i++) {
                        for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                            errmessage += (errmessage.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                        }
                        if(errors[i].fieldErrors) {
                            for(var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for(var j=0; j < thisFieldError.length; j++) {
                                    errmessage += (errmessage.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                }
                            }
                        }
                        if(errors[i].message) {
                            errmessage += (errmessage.length > 0 ? '\n' : '') + errors[i].message;
                        }
                    }
                    alert(errmessage);
                } 
            }else{
                alert('System encounter error, Please reach out to System Admin.');
            }
        });
        $A.enqueueAction(action);  
    },
    printablePage : function(component, event, helper) {
        var ename = event.currentTarget.name;
        if(ename==null){
            ename = event.getSource().get("v.name");
        }
        //alert(event.currentTarget);
        var url = location.origin + '/apex/changeDashboardPrintPage?id=' + component.get("v.recordId") + '&type='+ ename;
        window.open(url, '_blank');
    },
    selectAllAgreeCheckbox : function(component, event, helper) {
        helper.selectAllCheckbox(component, event, "Agreement");        
    },
    //selectAllDocCheckbox : function(component, event, helper) {
    //    helper.selectAllCheckbox(component, event, "Document");
    //},
    showSpinner : function(component, event, helper) {
        //helper.selectAllCheckbox(component, event, "Document");
        component.set("v.IsSpinner", true); 
    },
    hideSpinner : function(component, event, helper) {
        //helper.selectAllCheckbox(component, event, "Document");
        component.set("v.IsSpinner", false);
    },
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
})