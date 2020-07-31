({
/**** START - Method to Create Carrier Record from Platform Specifics ****/
    createCarrierRecords: function(component, platform, lob, carid) {
                           debugger;
        var Platformname= platform;
        var lobname = lob;
        var CarrId =carid;
        var accinfo = component.get("v.AccountId");
        var accid = accinfo.Account_Name__c;
        if(Platformname != null && lobname != null && CarrId != null) {
            //build payload:
            var actionCreateCarrier = component.get("c.createCarrier");
            var returnmessage;
            actionCreateCarrier.setParams({
                "CarrierId" : CarrId,
                "Platform" : Platformname,
                "Lob" : lobname,
                "AccountId" : null,
                "GroupId" : null,
                "Recordtype" : "C",
                "PAccountId" : accid
            }); 
            actionCreateCarrier.setCallback(this,function(a){
                var state = a.getState();
                if (state === "SUCCESS") {
                    var recordIden = component.get("v.recordIdentify"); 
                    var res = a.getReturnValue();
                     if (res != null)
                    {
                    var carrieridselect = $A.get("e.c:Level1_Custom_CarrierAdd_Select");
       				 carrieridselect.setParams({
           					 "carrierid" : res ,
                             "recordIdentify" : recordIden});
        			 carrieridselect.fire();
                   var toastEvent = $A.get("e.force:showToast");
                   if(res.includes('success')){
                    toastEvent.setParams({
                        mode: 'sticky',
                        message: 'Carrier record created successfully.',
                        type : 'info'
                    });
                   }}
                  if (res == null)
                    {
                   
                   var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        message: 'Carrier record already exists.',
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

    /**** END  Method to Create Platform Specific Record from CAG Search ****/
})