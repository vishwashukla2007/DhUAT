({
  //Method to Validate Pricing Effective Date at Lightning Grid
	validateEffectiveDate : function(component) {
		var pItem = component.get("v.pItem");
        var eDate = pItem.platformSpecific.EffectiveDate__c;
        var diff = pItem.platformSpecific.DifferentGSTPFormularyEffectiveDates__c;
        console.log("here vinitha eDate"+eDate);
        var sfSectionRequired = component.get("v.sfSectionRequired");
        var gstpSectionRequired = component.get("v.gstpSectionRequired");
        var nsfSectionRequired = component.get("v.nsfSectionRequired");
        
        console.log("sfSectionRequired:"+sfSectionRequired+"gstpSectionRequired"+gstpSectionRequired+"nsfSectionRequired"+nsfSectionRequired);
        if(!diff){
            if(sfSectionRequired){
                component.set("v.pItem.platformSpecific.SpecialtyFormularyEffectiveDate__c", eDate);
            }
            
            if(gstpSectionRequired){
                component.set("v.pItem.platformSpecific.GSTPEffectiveDate__c", eDate);
            }
            
            if(nsfSectionRequired){
                component.set("v.pItem.platformSpecific.NonSpecialtyFormularyEffectiveDate__c", eDate);
            }
        }
        var val = eDate.split("-");
        var dayfst = val[2];
        var pricingEffectiveDate = pItem.pricingEffectiveDate;
        var eDateMsg = '';
        var isInvalidPlatformSpecific = false;
        if(eDate){
            eDate = new Date(eDate);
            //Get the day as a number (1-31)
            var dayfirst = eDate.getDate();
            console.log("-----edate----"+eDate+"---------dayfirst------"+dayfirst);
            if(dayfst != 1){
                isInvalidPlatformSpecific = true;
                eDateMsg = "The Platform Specifics Effective Date is not the first day of the month.";
            }
            if(pricingEffectiveDate){
            	pricingEffectiveDate = new Date(pricingEffectiveDate);
                if(eDate < pricingEffectiveDate){
                    isInvalidPlatformSpecific = true;
					eDateMsg+= " The Platform Specifics Effective Date is earlier than the Pricing Effective Date.";                    
                }
        	}
            component.set("v.pItem.isInvalidEffectiveDateMsg", eDateMsg);
        }
        
	}
})