({
    selectAllCheckbox : function(component, event,chkboxName) {
        var selectedHeaderCheck = event.getSource().get("v.value");
        var updatedPaginationList = [];
        var PaginationList = component.get("v.fieldList"); 
        for (var i = 0; i < PaginationList.length; i++) {
            if (selectedHeaderCheck == true) {
                if(chkboxName=="Agreement"){
                    PaginationList[i].recToAgree = true;
                }else if(chkboxName=="Document"){
                    PaginationList[i].recToDoc = true;
                }
            } else {
                if(chkboxName=="Agreement"){
                    PaginationList[i].recToAgree = false;
                }else if(chkboxName=="Document"){
                    PaginationList[i].recToDoc = false;
                }
            }
            updatedPaginationList.push(PaginationList[i]);
        }
        component.set("v.fieldList", updatedPaginationList);
        
        if(chkboxName=="Agreement"){
            if (selectedHeaderCheck == true) {    
                component.set("v.SelectedRecAgCount", updatedPaginationList.length);
            } else {
                component.set("v.SelectedRecAgCount", 0);
                if(component.find("selectAllDocId").get("v.value")==true){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message: $A.get("$Label.c.changeDashboardReconcileMessage"),
                        duration:'500',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    var getAllDocu = component.find("selectedDocu");
                    if(Array.isArray(getAllDocu)){
                        for (var i = 0; i < getAllDocu.length; i++) {
                            component.find("selectedAgree")[i].set("v.value",true);     
                        }
                    }else{
                        if(getAllDocu !==null){
                            component.find("selectedAgree").set("v.value",true);   
                        }
                    }
                    component.find("selectAllAgreeId").set("v.value",true);
                }
            }
        }else if(chkboxName=="Document"){
            if (selectedHeaderCheck == true) {    
                component.set("v.SelectedRecDocCount", updatedPaginationList.length);
                component.find("selectAllAgreeId").set("v.value", true);
                var getAllDocu = component.find("selectedDocu");
                if(Array.isArray(getAllDocu)){
                    for (var i = 0; i < getAllDocu.length; i++) {
                        component.find("selectedAgree")[i].set("v.value",true);
                    }
                }else{
                    if(getAllDocu !==null){
                        component.find("selectedAgree").set("v.value",true);
                    }
                }
            } else {
                component.set("v.SelectedRecDocCount", 0);
            }
        }
    },
    CheckboxSelect : function(component, event, chkboxName) {
        var selectedRec = event.getSource().get("v.value");
        if(chkboxName=="Agreement"){
            var getSelectedNumber = component.get("v.SelectedRecAgCount");
        }else if(chkboxName=="Document"){
            var getSelectedNumber = component.get("v.SelectedRecDocCount");
        }
        
        if (selectedRec == true) {
            getSelectedNumber++;
        } else {
            getSelectedNumber--;
            if(chkboxName=="Agreement"){
                if(component.find("selectAllDocId").get("v.value")==false){
                    component.find("selectAllAgreeId").set("v.value", false);
                }
            }else if(chkboxName=="Document"){
                component.find("selectAllDocId").set("v.value", false);
            }
            
        }
        if (getSelectedNumber == component.get("v.fieldListSize")) {
            if(chkboxName=="Agreement"){
                component.find("selectAllAgreeId").set("v.value", true);
            }else if(chkboxName=="Document"){
                component.find("selectAllDocId").set("v.value", true);
                component.find("selectAllAgreeId").set("v.value", true);
            }
        }
        if(chkboxName=="Agreement"){
            component.set("v.SelectedRecAgCount", getSelectedNumber);
        }else if(chkboxName=="Document"){
            component.set("v.SelectedRecDocCount", getSelectedNumber);
            if(selectedRec == true) {
                component.set("v.SelectedRecAgCount", getSelectedNumber);
            }
        }
        
        if(chkboxName=="Document" && selectedRec == true){
            var getAllDocu = component.find("selectedDocu");
            if(Array.isArray(getAllDocu)){
                for (var i = 0; i < getAllDocu.length; i++) {
                    if (getAllDocu[i].get("v.value") == true) {
                        component.find("selectedAgree")[i].set("v.value",true);
                    }     
                }
            }else{
                if(getAllDocu!==null){
                    if(component.find("selectedDocu").get("v.value") == true) {
                        component.find("selectedAgree").set("v.value",true);
                    }
                }
            }
        }
        
        if(chkboxName=="Agreement" && selectedRec == false){
            var getAllAgree = component.find("selectedAgree");
            var showToast = false;
            if(Array.isArray(getAllAgree)){
                for (var i = 0; i < getAllAgree.length; i++) {
                    if (getAllAgree[i].get("v.value") == false) {
                        if(component.find("selectedDocu")[i].get("v.value")==true){
                            showToast = true;        	
                            component.find("selectedAgree")[i].set("v.value",true);
                        }
                    } 
                    
                }
            }else{
                if(getAllAgree!=null){
                    if(component.find("selectedAgree").get("v.value") == false) {
                        if(component.find("selectedDocu").get("v.value")==true){
                            showToast = true;
                            component.find("selectedAgree").set("v.value",true);
                        }
                    }
                }
            }
            var vmessage = $A.get("$Label.c.changeDashboardReconcileMessage");
            if(showToast){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: vmessage,
                    duration:'500',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'dismissible'
                });
                toastEvent.fire();
            }
        }
    },
    handleReconcileHelper : function(component, event) {
        var allRecords = component.get("v.fieldList");
        var selectedRecords = [];
        for (var i = 0; i < allRecords.length; i++) {
            //if (allRecords[i].recToAgree || allRecords[i].recToDoc ) {
            allRecords[i].recToAgree = true;
            selectedRecords.push(allRecords[i]);
            //}
        }
        var action = component.get("c.reconcile");
        action.setParams({
            "fieldValParam": JSON.stringify(selectedRecords),
            "AgreementId" : component.get("v.recordId"),
            "NoOfMismatch" : component.get("v.NoOfMismatch")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Reconciliation of FAF to Agreement Record Successful',
                    message: 'Record Saved!',
                    duration:'500',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'dismissible'
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
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
    }
})