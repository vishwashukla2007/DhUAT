public without sharing class AgreementTriggerHelper {

  public static void captureSessionId(List<Apttus__APTS_Agreement__c> AggrList) 
  {
    List<Apttus__APTS_Agreement__c> AggrUpdate = new List<Apttus__APTS_Agreement__c>();
    for(Apttus__APTS_Agreement__c aggr: AggrList){ 
    if (aggr.Apttus__Agreement_Category__c == Label.PCD)
      {
      aggr.SessionId__c = UserInfo.getSessionId();
      AggrUpdate.add(aggr);
      }
    }
    if(!AggrUpdate.IsEmpty())
    {
      //Database.Update(AggrUpdate);
    }
  }
  public static void onAfterInsert(List<Apttus__APTS_Agreement__c> agreementList){
      Map<id, Apttus__APTS_Agreement__c> sfsAgreements = new Map<id, Apttus__APTS_Agreement__c>();

      for(Apttus__APTS_Agreement__c agreement : agreementList){
         if(agreement.RecordTypeId == Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get(Label.Speciality_Fees_Schedule).getRecordTypeId() && agreement.PBM_FAF__c != null){
           system.debug('jp iwent here');
            sfsAgreements.put(agreement.PBM_FAF__c, agreement);
         }
      }
      updateFafSfsField(sfsAgreements);
  }
  public static void updateFafSfsField(Map<id, Apttus__APTS_Agreement__c> sfsAgreements){
    list<Central_Hub__c> fafList = [select id , SFS_Agreement__c from Central_Hub__c where id in: sfsAgreements.keySet()];
    for(Central_Hub__c faf : fafList){
      if(faf.SFS_Agreement__c == null){
          faf.SFS_Agreement__c = sfsAgreements.get(faf.Id).Id;
      }
    }
    update fafList;
  }

}