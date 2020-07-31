({
	handleEvent : function(component, event, helper) 
    {
        var nonspec = event.getParam("nonspec");
		var spec = event.getParam("spec");
        var checked = event.getParam("checked");
        if (nonspec ==component.get("v.modnonspecialty") && spec ==component.get("v.gstp"))
        {
            component.set("v.checked1",checked);
            var appEventC = $A.get("e.c:Apttus_Grid_Add_MLOB_Count_Event");
            appEventC.setParams({ "count" : checked });
            appEventC.fire();
        }
	},
   
    updatecheckbox : function(component, event, helper) 
    {
       
    },
    handleRebateEvent : function(component, event, helper) 
    {
        var rebate = event.getParam("rebate");
        var existrebate = false;
        for (var reb in rebate)
        { 
            if (rebate[reb] == component.get("v.Id"))
             {
                existrebate = true;
             }
        }
        if (existrebate == false && component.get("v.checked1") == true)
        {
          rebate.push(component.get("v.Id"));
          var appEventR = $A.get("e.c:Apttus_Grid_Add_MLOB_Rebate_Event");
          appEventR.setParams({ "rebate" : rebate });
          var appEventN = $A.get("e.c:Apttus_Grid_Add_MLOB_Notify_Event");
          appEventN.setParams({ "rebate" : rebate },
                              { "selectedcount" : component.get("v.selectedcount")});
          appEventN.fire();
        }
    },
})