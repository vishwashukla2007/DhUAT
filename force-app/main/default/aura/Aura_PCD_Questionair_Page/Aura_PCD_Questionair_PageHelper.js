({
    getAdditionalSpecialtyPicklist: function(component, event) {
        var action = component.get("c.getTierOption");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var industryMap = [];
                for(var key in result){
                    industryMap.push({key: key, value: result[key]});
                }
                component.set("v.industryMap", industryMap);
            }
        });
        $A.enqueueAction(action);
    },
    getAdditionalSpecialtyPicklist1: function(component, event) {
        var action = component.get("c.getNetworkType");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var industryMap = [];
                for(var key in result){
                    industryMap.push({key: key, value: result[key]});
                }
                
                component.set("v.industryMap1", industryMap);
                component.set("v.industryMap2", industryMap);
                component.set("v.industryMap3", industryMap);
                component.set("v.industryMap4", industryMap);
                component.set("v.industryMap5", industryMap);
                
            }
        });
        $A.enqueueAction(action);
    },
	getAggrementLineItemData: function(component, event) {
		console.log('In AgreemntLine item'+component.get("v.record"));
        var action = component.get("c.getAuraAgreementItemData");
        action.setParams({Aggrid:component.get("v.record")});
        action.setCallback(this, function(response) {
       
            var state = response.getState();
            if (state === "SUCCESS") {
                var json1 = JSON.parse(JSON.stringify(response.getReturnValue()));
                component.set("v.Med_D_HIF",json1.Med_D_HIF__c);
				console.log("LOB"+json1.Apttus__AgreementId__r.Primary_ALI_LOB__c);
				console.log("Med_D_HIF__c"+json1.Med_D_HIF__c);
				if((json1.Med_D_HIF__c!=null||json1.Med_D_HIF__c==0) && json1.Apttus__AgreementId__r.Primary_ALI_LOB__c=='EGWP'){
					component.set("v.QuestionMEDHIFDiv1","display:block");
				}
                if((json1.Med_D_IHS__c!=null||json1.Med_D_IHS__c==0) && json1.Apttus__AgreementId__r.Primary_ALI_LOB__c=='EGWP'){
					component.set("v.QuestionMEDIHFDiv","display:block");
				}
                if((json1.Med_D_LTC__c!=null||json1.Med_D_LTC__c==0) && json1.Apttus__AgreementId__r.Primary_ALI_LOB__c=='EGWP'){
					component.set("v.QuestionMEDLTCDiv","display:block");
				}
                 if((json1.Med_D_TER__c!=null||json1.Med_D_TER__c==0) && json1.Apttus__AgreementId__r.Primary_ALI_LOB__c=='EGWP'){
					component.set("v.QuestionMEDTERDiv","display:block");
				}
                if(json1.Network_Operations_Count__c!=0 && json1.Network_Operations_Count__c!=null){
				component.set("v.DisplayNetworkQuestion","display:block");
                }
                if(json1.Apttus__AgreementId__r.Primary_ALI_LOB__c=='EGWP'){
                    console.log("json1.Apttus__AgreementId__r.Primary_ALI_LOB__c"+json1.Apttus__AgreementId__r.Primary_ALI_LOB__c);
				      component.set("v.NetWorkTypeDiabled5",true);
					  component.set("v.NetWorkTypeDiabled1",true);
					  component.set("v.NetWorkTypeDiabled2",true);
					  component.set("v.NetWorkTypeDiabled3",true);
					  component.set("v.NetWorkTypeDiabled4",true);
					  component.set("v.NetWorkTypeValue","Transparent");
                }
				else{
				component.set("v.NetWorkTypeValue","--None--");	
				}
				
            }
        });
        $A.enqueueAction(action);
    },
	getAggrementData: function(component, event) {
		console.log('In Agreemnt item'+component.get("v.record"));
        var action = component.get("c.getAuraAgreementData");
        action.setParams({Aggrid:component.get("v.record")});
        action.setCallback(this, function(response) {
       
            var state = response.getState();
            if (state === "SUCCESS") {
                var json1 = JSON.parse(JSON.stringify(response.getReturnValue()));
                component.set("v.OfferCategory",json1.Offer_Category__c);
				component.set("v.LOB",json1.Primary_ALI_LOB__c);
                console.log("OfferCategory"+component.get("v.OfferCategory"));
                if(component.get("v.OfferCategory")=='Market check'){
                    component.set("v.Question1Div","slds-show");
                 }
                 else{
                    component.set("v.Question1Div","slds-hide"); 
                  }
            }
        });
        $A.enqueueAction(action);
    },
    
})