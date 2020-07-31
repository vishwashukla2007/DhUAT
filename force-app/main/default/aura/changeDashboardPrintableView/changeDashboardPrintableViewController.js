({
     onPageReferenceChange : function(component, event, helper) {
         var pageReference = component.get("v.pageReference");
         component.set("v.pageReference", pageReference);
         if(pageReference!==null){
         	component.set("v.recordId", pageReference.state.c__myAttr);
         }
         var pageType = component.get("v.type");
         if(pageType=="printPreviewRecFAF" || pageType=="printPreviewUpdateDoc"){
             if(pageType=="printPreviewRecFAF"){
                 component.set("v.typeLabel","Reconcile FAF to Agreement Record");
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
                         component.set("v.isSync", result.isSync);
                         //alert(result.isSync);
                     }
                 });
                 $A.enqueueAction(action);
             }else if(pageType=="printPreviewUpdateDoc"){
                 component.set("v.typeLabel","Update Legal Document with Agreement Record");
                 var action = component.get("c.viewReconcileHist");
                 action.setParams({"agreementId": component.get("v.recordId"),
                                   "filter": "viewUpdtLegalDoc"
                                  });
                 action.setCallback(this, function(response){
                     var state = response.getState();
                     if (state === "SUCCESS"){
                         var result = response.getReturnValue();
                         if(result.length !== 0){
                             component.set("v.fieldChangeLogList", result);
                         }
                     }
                 });
                 $A.enqueueAction(action);
             }      
         }else if(pageType=="viewRecHist" || pageType=="printRecAg" || pageType=="printRecDoc"){
             var action = component.get("c.viewReconcileHist");
             action.setParams({"agreementId": component.get("v.recordId"),
                                   "filter": pageType
                                  });
             action.setCallback(this, function(response){
                 var state = response.getState();
                 if (state === "SUCCESS"){
                     var result = response.getReturnValue();
                     component.set("v.fieldChangeLogList", result);
                     if(pageType=="viewRecHist"){
                         var getSelectedNumber = component.get("v.SelectedRecDocCount");
                         for (var i = 0; i < result.length; i++) {
                             if (result[i].Reconcile_to_Document__c == true) {
                                 getSelectedNumber++;
                             }
                         }
                         /*
                         if(result.length===getSelectedNumber){
                             component.find("selectAllDocId").set("v.value", true);
                         }
                         */
                         component.set("v.SelectedRecDocCount", getSelectedNumber);
                     }
                 }
             });
             $A.enqueueAction(action);
             if(pageType=="printRecAg"){
                 component.set("v.typeLabel","Reconciled to Agreement");
             }else if(pageType=="printRecDoc"){
                 component.set("v.typeLabel","Reconciled to Document");
             }else if(pageType=="viewRecHist"){
                 component.set("v.typeLabel","Reconcile History");
             }
         }
    },  
    cancel : function(component, event, helper) {
        alert('cancel');
        var navLink = component.find("navService");
        var pageRef = {
            type: 'standard__recordPage',
            attributes: {
                actionName: 'view',
                objectApiName: 'Apttus__APTS_Agreement__c',
                recordId : component.get("v.recordId") // change record id. 
            },
        };
        navLink.navigate(pageRef, true);
    },
    print : function(component, event, helper) {
        window.print();
    },
    selectAllAgreeCheckbox : function(component, event, helper) {
        var selectedHeaderCheck = event.getSource().get("v.value");
        var updatedPaginationList = [];
        var PaginationList = component.get("v.fieldList");
        // update the checkbox for 'PaginationList' based on header checbox 
        for (var i = 0; i < PaginationList.length; i++) {
            if (selectedHeaderCheck == true) {
                PaginationList[i].recToAgree = true;
            } else {
                PaginationList[i].recToAgree = false;
            }
            updatedPaginationList.push(PaginationList[i]);
        }
        component.set("v.fieldList", updatedPaginationList);
    },
    selectAllDocCheckbox : function(component, event, helper) {
        var selectedHeaderCheck = event.getSource().get("v.value");
        var updatedPaginationList = [];
        var pageType = component.get("v.type");
        if(pageType=="viewRecHist"){
            var PaginationList = component.get("v.fieldChangeLogList");
            // update the checkbox for 'PaginationList' based on header checbox 
            for (var i = 0; i < PaginationList.length; i++) {
                if (selectedHeaderCheck == true) {
                    PaginationList[i].Reconcile_to_Document__c = true;
                } else {
                    PaginationList[i].Reconcile_to_Document__c = false;
                }
                updatedPaginationList.push(PaginationList[i]);
            }
            component.set("v.fieldChangeLogList", updatedPaginationList);
            if (selectedHeaderCheck == true) {
                component.set("v.SelectedRecDocCount", component.get("v.fieldChangeLogList").length);
            }else{
                component.set("v.SelectedRecDocCount", 0);
            }
        }else if(pageType=="printPreview"){
            var PaginationList = component.get("v.fieldList");
            // update the checkbox for 'PaginationList' based on header checbox 
            for (var i = 0; i < PaginationList.length; i++) {
                if (selectedHeaderCheck == true) {
                    PaginationList[i].recToDoc = true;
                } else {
                    PaginationList[i].recToDoc = false;
                }
                updatedPaginationList.push(PaginationList[i]);
            }
            component.set("v.fieldList", updatedPaginationList);
            if (selectedHeaderCheck == true) {
                component.set("v.SelectedRecDocCount", component.get("v.fieldList").length);
            }else{
                component.set("v.SelectedRecDocCount", 0);
            }
        }
        
    },
    upRecDoc : function(component, event, helper) {
        //alert('upRecDoc');
        //$A.get('e.force:refreshView').fire();
        
        
        var recordList = component.get("v.fieldChangeLogList");
        //for (var i = 0; i < recordList.length; i++) {
           //alert(recordList[i].Agreement_Extension_Field_Name__c + '-' + recordList[i].Reconcile_to_Document__c )    
        //}
        
        var action = component.get("c.updateReconcile");
        action.setParams({
            				"fieldValParam": JSON.stringify(recordList)
                         });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                //alert(result);
                component.set("v.fieldChangeLogList",result);
                alert('Record Saved!');
                window.location.reload(true);
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
    CheckboxSelect : function(component, event, chkboxName) {
        var pageType = component.get("v.type");
        var selectedRec = event.getSource().get("v.value");
        var getSelectedNumber = component.get("v.SelectedRecDocCount");
        if (selectedRec === true) {
            getSelectedNumber++;
        } else {
            getSelectedNumber--;
            component.find("selectAllDocId").set("v.value", false);
        }
        
        component.set("v.SelectedRecDocCount", getSelectedNumber);    
        
    
    	if(pageType=="viewRecHist"){
            if (getSelectedNumber === component.get("v.fieldChangeLogList").length) {
                component.find("selectAllDocId").set("v.value", true);  
            }
        }else if(pageType=="printPreview"){
            if (getSelectedNumber === component.get("v.fieldList").length) {
                component.find("selectAllDocId").set("v.value", true);  
            }
        }
    },
    
})