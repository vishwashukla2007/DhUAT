({
	getThisReconciliation : function(component, helper) {
          var action = component.get("c.get_yearcount");
        action.setParams({"fafid":  component.get("{!v.fafid}")})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.yearcount", response.getReturnValue());
            }
            else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);  
        
        if(component.get("v.showInSpec")==false){
        console.log('First');
        console.log('FAFID'+component.get("v.fafid"));
        console.log('plan'+component.get("{!v.plan}"));
		console.log('basis'+component.get("v.basis"));
		console.log('nonspecForm'+component.get("v.nonspecForm"));
		console.log('specForm'+component.get("v.specForm"));
		console.log('specialty chekbox'+component.get("v.showInSpec"));
			var action = component.get("c.get_RebatedataSpec");
			action.setParams({"fafid":component.get("{!v.fafid}"),
			"plan":component.get("{!v.plan}"),
			"basis":component.get("{!v.basis}"),
			"nonspecForm":component.get("{!v.nonspecForm}"),
			"specForm":component.get("{!v.specForm}"),
			"gstp":component.get("{!v.gstp}")})
			action.setCallback(this, $A.getCallback(function(response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					component.set("v.netobjects", response.getReturnValue());
					var data = component.get("v.netobjects");
					var itemcount = data.length;
					component.set("v.pricingcount", itemcount);
					console.log('$$$response.getReturnValue()'+response.getReturnValue());
				}
				else {
					console.log('response.getError()'+response.getError());
					//helper.counselLogErrors(response.getError());
				}
			}));
			$A.enqueueAction(action);
		}
		 if(component.get("v.showInSpec")==true){
              console.log('Second');
        console.log('FAFID'+component.get("v.fafid"));
        console.log('plan'+component.get("{!v.plan}"));
		console.log('basis'+component.get("v.basis"));
		console.log('nonspecForm'+component.get("v.nonspecForm"));
		console.log('specForm'+component.get("v.specForm"));
		console.log('specialty chekbox'+component.get("v.showInSpec"));
			var action = component.get("c.get_Rebatedata");
			action.setParams({"fafid":component.get("{!v.fafid}"),
			"plan":component.get("{!v.plan}"),
			"basis":component.get("{!v.basis}"),
			"nonspecForm":component.get("{!v.nonspecForm}"),
			"specForm":component.get("{!v.specForm}"),
			"gstp":component.get("{!v.gstp}")})
			action.setCallback(this, $A.getCallback(function(response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					component.set("v.netobjects", response.getReturnValue());
					var data = component.get("v.netobjects");
					var itemcount = data.length;
					component.set("v.pricingcount", itemcount);
					console.log('$$$response.getReturnValue()'+response.getReturnValue());
				}
				else {
					console.log('response.getError()'+response.getError());
					//helper.counselLogErrors(response.getError());
				}
			}));
			$A.enqueueAction(action);
		}
		
        var action = component.get("c.findPicklistOptions");
        action.setParams({"objAPIName":"Rebate_Guarantees__c",
                          "fieldAPIname":"Non_Specialty_Formulary_2__c"})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.nnameoptions", response.getReturnValue());
                console.log('response.getReturnValue()'+response.getReturnValue());
            }
            else {
                console.log('eror'+response.getError());
            }
        }));
        $A.enqueueAction(action);
		
		var action = component.get("c.findPicklistOptions");
        action.setParams({"objAPIName":"Rebate_Guarantees__c",
                          "fieldAPIname":"Basis__c"})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.ntypeoptions", response.getReturnValue());
                console.log('response.getReturnValue()'+response.getReturnValue());
            }
            else {
                console.log('eror'+response.getError());
            }
        }));
        $A.enqueueAction(action);
        
         var action = component.get("c.findPicklistOptions");
        action.setParams({"objAPIName":  "Rebate_Guarantees__c",
                          "fieldAPIname": "LOB2__c"})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.loboptions", response.getReturnValue());
            }
            else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        
          },
    
})