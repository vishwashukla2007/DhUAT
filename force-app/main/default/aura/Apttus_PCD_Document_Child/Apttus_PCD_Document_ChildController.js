({
	doInit : function(component, event, helper) 
    {
        component.set("v.url", "/servlet/servlet.FileDownload?file=" + component.get("v.docs.Apttus__ContentId__c"));
		helper.retrievenote(component, event, helper);
	},
    deletepricing : function(component, event, helper)  {     
        component.set("{!v.isDelete}", true);
    }, 
    closeDeleteAlert : function(component, event, helper)  {
        component.set("{!v.isDelete}", false);
    },
    deleteSelectedRec : function(component, event, helper)  {
        component.set("{!v.isDelete}", false);
        helper.deletedocument(component, event, helper);
    },
})