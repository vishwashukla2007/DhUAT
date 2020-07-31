({
/**** START - Method to Create Group Record from Platform Specifics ****/
    createGroupRecords: function(component, platform, lob) {
        debugger;
        var Platformname= platform;
        var lobname = lob;
        var Groupid = component.get("v.carrid");
        var CarrierId =component.get("v.SelectedCarrier");
        var CarrierName = component.get("v.SelectedCarrierName");
        var AccountId = component.get("v.SelectedAccount");
        var AccountName = component.get("v.SelectedAccountName");
        if(Platformname != null && lobname != null && Groupid != null) {
            //build payload:
            var actionCreateCarrier = component.get("c.createCarrier");
            var returnmessage;
            actionCreateCarrier.setParams({
                "CarrierId": CarrierId,
                "CarrierName" : CarrierName,
                "Platform" : Platformname,
                "AccountId" : AccountId,
                "Recordtype" : "G",
                "AccountName" : AccountName,
                "GroupId" : Groupid
            }); 
            actionCreateCarrier.setCallback(this,function(a){
                var state = a.getState();
                if (state === "SUCCESS") {
                    debugger;
                    var recordIden = component.get("v.recordIdentify"); 
                    var res = a.getReturnValue();
                      if (res != null)
                    {
                    var carrieridselect = $A.get("e.c:Level3_Custom_CarrierAdd_Select");
       				 carrieridselect.setParams({
           					 "carrierid" : res ,
                             "recordIdentify" : recordIden});
        			 carrieridselect.fire();
                   var toastEvent = $A.get("e.force:showToast");
                   if(res.includes('success')){
                    toastEvent.setParams({
                        mode: 'sticky',
                        message: 'Group records created successfully.',
                        type : 'info'
                    });
                   }}
                     if (res == null)
                    {
                   
                   var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        message: 'Group record already exists.',
                        type : 'info'
                    });
                   
                    }     
                
                
                }else{
                    toastEvent.setParams({
                        mode: 'sticky',
                        message: a.getReturnValue(),
                        type : 'error'
                      
                    });

                }
                toastEvent.fire();
            });      
                $A.enqueueAction(actionCreateCarrier);  

        }
    },

    /**** END  Method to Create Group from Platform Specifics ****/
})