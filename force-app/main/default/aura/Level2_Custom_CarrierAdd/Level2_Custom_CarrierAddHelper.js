({
/**** START - Method to Create Account Record from Lookup ****/
    createCarrierRecords: function(component, platform, lob, carid) {
        debugger;
        var Platformname= platform;
        var lobname = lob;
        var CarrId =component.get("v.SelectedCarrier");
        var AccId  = component.get("v.accid");
        var AccountId = component.get("v.AccountId");
        if(Platformname != null && lobname != null && CarrId != null) {
            //build payload:
            var actionCreateCarrier = component.get("c.createCarrier");
            var returnmessage;
            actionCreateCarrier.setParams({
                "CarrierId" : CarrId,
                "Platform" : Platformname,
                "Lob" : lobname,
                "AccountId" : AccId,
                "GroupId" : null,
                "Recordtype" : "A"
            }); 
            actionCreateCarrier.setCallback(this,function(a){
                var State = a.getState();
                if (State === "SUCCESS") {
                            debugger;
                    var res = a.getReturnValue();
                    var recordIden = component.get("v.recordIdentify");
                    if (res != null)
                    {
                    var carrieridselect = $A.get("e.c:Level2_Custom_CarrierAdd_Select");
       				 carrieridselect.setParams({
           					 "carrierid" : res,
                      "recordIdentify" : recordIden});
        			 carrieridselect.fire();
                    returnmessage = a.getReturnValue();
               	 	var toastEvent = $A.get("e.force:showToast");
                	if(res.includes('success')){
                    toastEvent.setParams({
                        mode: 'sticky',
                        message: 'Account records created successfully.',
                        type : 'info'
                    });
                
                    }}
                    
                    if (res == null)
                    {
                   
                   var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        message: 'Account record already exists.',
                        type : 'info'
                    });
                   
                    }  
                    
                }
				else{
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
    /**** END  Method to Create Account Record Lookup ****/
})