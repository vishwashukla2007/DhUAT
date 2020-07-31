({
	doInit : function(component, event, helper) 
    {
		helper.retrievepricing(component, event, helper); 
	},
    onSelectAll : function(component, event, helper) 
    {
        if (component.get('v.checked') == false)
        {
            component.set('v.checked',true);
        }
        else
        {
            component.set('v.checked',false);
        }
        var appEvent = $A.get("e.c:Apttus_Grid_Add_Additional_Rebate_Event");
                   appEvent.setParams({
                      "nonspec" : component.get("{!v.rebateguarantee.Modeled_Non_Specialty_Formulary_Name__c}"),
                      "spec" : component.get("{!v.rebateguarantee.GSTP__c}"),
                      "checked" : component.get("{!v.checked}")});
        appEvent.fire();
     
        
    },
  
     handleCheck : function(component, event, helper) 
    {
       
	},
})