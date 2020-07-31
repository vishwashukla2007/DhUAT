({
    doInit : function(component, event, helper) {
		var pbmQuest = component.get("v.mydata_custom1");  
        var pbmQuestAns = [];
        var secheader = null;
        var isecheader = null;
        for(var i = 0;i < pbmQuest.length;i++){
            if(secheader != pbmQuest[i].Section_Header__c){
            	isecheader = pbmQuest[i].Section_Header__c;   
            }else{
                isecheader = null;
            }
            secheader = pbmQuest[i].Section_Header__c;
            pbmQuestAns.push({'sobjectType':'PBM_Questions_Answers__c','PBM_Question__c':pbmQuest[i].Id, 'Answer__c':null, 'Field_API__c': pbmQuest[i].Field_API__c, 'Section_Header__c':isecheader});
        }
        component.set("v.pbmQuestAns",pbmQuestAns);
    },
})