({
    doInit : function(component, event, helper) {
		var pbmQuest = component.get("v.mydata_custom1");  
        var pbmQuestAns = [];
        var secheader = null;
        var isecheader = null;
        
        for(var i = 0;i < pbmQuest.length;i++){
            if(secheader != pbmQuest[i].Section_Header__c){
            	isecheader = pbmQuest[i].Section_Header__c;   
            }else{
                isecheader = null;
            }
            secheader = pbmQuest[i].Section_Header__c;
            pbmQuestAns.push({'sobjectType':'PBM_Questions_Answers__c','PBM_Question__c':pbmQuest[i].Id, 'Answer__c':null, 'Field_API__c': pbmQuest[i].Field_API__c, 'Section_Header__c':isecheader});
        }
        component.set("v.pbmQuestAns",pbmQuestAns);
    },
	handleSave : function(component, event, helper) {
        var errmessage = "";
        //Start - US28917: Need to wait until we get confirmation from Lauren that the fields we are using are actually required
        /**var errmessage = "";
        var allRecords = component.get("v.pbmQuestAns");
        var tempArray = [];
        var i;
        for(i=0; i < allRecords.length; i++){
            if(allRecords[i].Field_API__c=='Master_Client_Name__c' && allRecords[i].Answer__c==null){
                errmessage += (errmessage.length > 0 ? '\n' : '') + 'Select a value for missing master client field before sending request';
                component.set("v.isValidInput",false);
            }
        }**/
        //End - US28917
        
        var doSaveNext = component.get("v.isValidInput");
        if(doSaveNext){
            var insRecords = component.get("v.pbmQuestAns");
            var insTempArray = [];
            var i;
            for(i=0; i < insRecords.length; i++){
                insTempArray.push(insRecords[i].PBM_Question__c + '-' + insRecords[i].Answer__c);  
            }
            var action = component.get("c.getSaveRecord");
            action.setParams({ "pbmQuestAnsString" : insTempArray, "fafid" : component.get("v.fafId")});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                    var rec = response.getReturnValue();
                    console.log(rec);
                    component.set("v.insertedpbmQuestAnsList",rec);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Record Saved!',
                        //messageTemplate: 'Record {0} created! See it {1}!',
                        duration:'500',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    var navigate = component.get("v.navigateFlow");
                    navigate("NEXT");
                    
                }else if (state === "ERROR") {
                    var errors = response.getError();
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
            $A.enqueueAction(action);    
        }else{
            //prevent save and next
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: errmessage,
                //messageTemplate: 'Mode is pester ,duration is 4sec and Message is overrriden',
                duration:' 2000',
                key: 'info_alt',
                type: 'error',
                mode: 'dismissible'
            });
            toastEvent.fire();
        }
		
	},
    handleComponentEvent : function(component, event, helper) {
        var qId = event.getParam("qId");
        var qAns = event.getParam("qAns");
        var qFieldNm = event.getParam("qFieldNm");
        var qdisabled = event.getParam("qdisable");
        var qisValid = event.getParam("qisValid");
        var qdisabledFldNm = event.getParam("qdisableFieldNm");
        //alert(qId + '-------' + qAns + '-------' + qdisabled);
         

        var allRecords = component.get("v.pbmQuestAns");
        var tempArray = [];
        var i;
        for(i=0; i < allRecords.length; i++){
            if(allRecords[i].PBM_Question__c==qId){
                allRecords[i].Answer__c = qAns;
            }
            tempArray.push(allRecords[i]);
        }
        component.set("v.pbmQuestAns",tempArray);
        if(qdisabledFldNm != null){
             var element = component.find(qdisabledFldNm);
            if(qdisabled){  
                element.set("v.disabledInput",true);
            }else{
                element.set("v.disabledInput",false);
            }
        }
        
        if(qisValid){
            component.set("v.isValidInput",true);
        }else{
            component.set("v.isValidInput",false);
        }
    },
})