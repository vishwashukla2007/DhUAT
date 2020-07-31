({
    doInit : function(component, event, helper){
        var base_url = window.location.origin;
    $A.get("e.force:navigateToURL").setParams({ 
        "url": base_url + "/apex/Apttus_XApps__EditInExcelLaunch?parentRecordId=" + component.get("v.iumsId") + "&&appName=iUMSModelUpload" 
     }).fire();
    }
})