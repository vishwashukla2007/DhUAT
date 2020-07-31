({
    FetchRecord: function(component, event) {
        var action = component.get("c.Extract_Question_Answer");
        action.setParams({
            recordId : "{!v.agreementline.Last_PCD_Question_Answer__c}"
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS") 
            {
               component.set("v.pcdquestion", result.getReturnValue());
            }
            else if (state === "INCOMPLETE") 
            {
                // Need to Provide Error Message
            }
            else if (state === "ERROR") 
            {
               
            } 
        });
        $A.enqueueAction(action);
    },
FetchPicklist: function(component, event) {
        var action = component.get("c.getPickListValuesIntoList");
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS") 
            {
               component.set("v.picvalue", result.getReturnValue());
            }
            else if (state === "INCOMPLETE") 
            {
                // Need to Provide Error Message
            }
            else if (state === "ERROR") 
            {
               
            } 
        });
        $A.enqueueAction(action);
    }
})