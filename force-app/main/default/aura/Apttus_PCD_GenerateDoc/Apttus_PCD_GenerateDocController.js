({
    doInit : function(component, event, helper) {
        helper.getColumns(component);
        helper.getTemplates(component, helper);
    },
     
    handleNext : function(component, event, helper) { 
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        helper.getTemplates(component, helper);
    },
     
    handlePrev : function(component, event, helper) {        
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        helper.getTemplates(component,event, helper); 
    },
 	 createDocVersionDetail : function(component, event, helper) 
    {
        helper.createDocVersionDetail(component, helper);
    },
    onselectRadio: function(component, event,helper) {
        helper.getTemplates(component,event, helper);
       
    }
   
})