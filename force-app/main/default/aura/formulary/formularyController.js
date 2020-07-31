({
	doInit : function(component, event, helper) {
		
	},
    handleChange : function(component, event, helper) {
		var varVal = event.getSource().get('v.value');
        component.set("v.defineType",varVal);
        var defType = component.get("v.defineType");
        var defmessage = "";
        if(defType=="Standard with Exclusion"){
            defmessage +=  '"Formulary" means'; 
            defmessage +=  " CVS Caremark’s formulary, adopted by Client pursuant to Section 2.6 of this Agreement, as created, maintained and amended by CVS Caremark from time to time.";  
            defmessage +=  " The Formulary consists of (a) a ranking of Covered Products into preferred and non-preferred tiers, (b) a listing of Non-Covered Products, and (c) associated utilization review programs pursuant to"; 
            defmessage +=  " CVS Caremark’s standard clinical criteria, which may include, but not limited to, prior authorizations, step therapy and/or quantity limits for one or more Covered Products.";  
            defmessage +=  " These programs may be conducted prospectively or retrospectively. The Formulary has been approved by CVS Caremark’s P&T Committee.";  
            defmessage +=  " The pricing set forth in Exhibit A to this Agreement is conditioned upon Client adoption of the Formulary identified in Exhibit A as its Plan formulary.";
        }else if(defType=="Standard without exclusion"){
            defmessage +=  '"Formulary" means';
            defmessage +=  " CVS Caremark’s formulary, adopted by Client pursuant to Section 2.6 of this Agreement, as created, maintained and amended by CVS Caremark from time to time.";  
            defmessage +=  " The Formulary consists of (a) a ranking of Covered Products into preferred and non-preferred tiers, and (b) associated utilization review programs pursuant to CVS Caremark’s standard clinical criteria,"; 
            defmessage +=  " which may include, but not limited to, prior authorizations, step therapy and/or quantity limits for one or more Covered Products.  These programs may be conducted prospectively or retrospectively.";  
            defmessage +=  " The Formulary has been approved by CVS Caremark’s P&T Committee. The pricing set forth in Exhibit A to this Agreement is conditioned upon Client adoption of the Formulary identified in Exhibit A as its Plan formulary.";
        }
        //alert(defmessage);
        component.set("v.customDef",defmessage);
	},
    handleChangeIncNotif : function(component, event, helper) {
		var varVal = event.getSource().get('v.value');
        if(varVal=="Yes"){
            component.set("v.incNotif","Yes");
        }else{
            component.set("v.incNotif","No");
        }
        
        var incNotif = component.get("v.incNotif");
        //alert(incNotif);
        //component.set("v.isText", "true");
	},
    handleSave : function(component, event, helper) {
        var validInput = true;
        var errmessage = '';
        var remNotDays = component.get("v.remNotDays");
        if(remNotDays == null || remNotDays == ''){
            validInput = false;
            errmessage = "Please complete Formulary removal notification days";
        }
        var incNotif = component.get("v.incNotif");
        var memNotifDays = component.get("v.memNotifDays");
        if(incNotif == "Yes" && (memNotifDays == null || memNotifDays == '')){
            validInput = false;
            errmessage = "Please complete Formulary client member notification days";
        }
        if(incNotif == "No"){
            component.set("v.memNotifDays",0);
        }
        
        var defType = component.get("v.defineType");
        var defmessage = "";
        if(defType=="Standard with Exclusion"){
            defmessage +=  '"Formulary" means'; 
            defmessage +=  " CVS Caremark’s formulary, adopted by Client pursuant to Section 2.6 of this Agreement, as created, maintained and amended by CVS Caremark from time to time.";  
            defmessage +=  " The Formulary consists of (a) a ranking of Covered Products into preferred and non-preferred tiers, (b) a listing of Non-Covered Products, and (c) associated utilization review programs pursuant to"; 
            defmessage +=  " CVS Caremark’s standard clinical criteria, which may include, but not limited to, prior authorizations, step therapy and/or quantity limits for one or more Covered Products.";  
            defmessage +=  " These programs may be conducted prospectively or retrospectively. The Formulary has been approved by CVS Caremark’s P&T Committee.";  
            defmessage +=  " The pricing set forth in Exhibit A to this Agreement is conditioned upon Client adoption of the Formulary identified in Exhibit A as its Plan formulary.";
            component.set("v.customDef",defmessage);
        }else if(defType=="Standard without exclusion"){
            defmessage +=  '"Formulary" means';
            defmessage +=  " CVS Caremark’s formulary, adopted by Client pursuant to Section 2.6 of this Agreement, as created, maintained and amended by CVS Caremark from time to time.";  
            defmessage +=  " The Formulary consists of (a) a ranking of Covered Products into preferred and non-preferred tiers, and (b) associated utilization review programs pursuant to CVS Caremark’s standard clinical criteria,"; 
            defmessage +=  " which may include, but not limited to, prior authorizations, step therapy and/or quantity limits for one or more Covered Products.  These programs may be conducted prospectively or retrospectively.";  
            defmessage +=  " The Formulary has been approved by CVS Caremark’s P&T Committee. The pricing set forth in Exhibit A to this Agreement is conditioned upon Client adoption of the Formulary identified in Exhibit A as its Plan formulary.";
            component.set("v.customDef",defmessage);
        }else if(defType=="Custom"){
            var customDef = component.get("v.customDef");
            if(customDef == null || customDef == ''){
                validInput = false;
                errmessage = "Please complete Custom Formulary definition";
            }
        }

        if(validInput){
            var navigate = component.get("v.navigateFlow");
            navigate("NEXT");
        }else{
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
      
        
	}
})