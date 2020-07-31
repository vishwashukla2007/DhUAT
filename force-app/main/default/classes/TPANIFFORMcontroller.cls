/**************************************************************************************************
    Purpose   : Controller class for TPA NIF FORM VF Page.
    Test_Class: Test_TPANIFFORMcontroller
****************************************************************************************************/
public class TPANIFFORMcontroller {
    public ApexPages.StandardController con;
    public TPA_Form__c TF{get;set;}
    //public Id CI;
    //public String CI{get; set;}
    public TPANIFFORMcontroller (ApexPages.StandardController controller) {
        con=controller;
        
        TF=(TPA_Form__c)controller.getRecord();
        //if record is new.
        if( TF.Client_Info_ID__c == null && ApexPages.currentPage().getParameters().containsKey(Label.ClientInfoTpaLab) )
        {
            TF.Client_Info_ID__c = ApexPages.currentPage().getParameters().get(Label.ClientInfoTpaLab);
        }
        
        //CI=ApexPages.currentPage().getParameters().get(Label.ClientInfoTpaLab);
        List<Network_Pricing__c> ntwrkList= new List<Network_Pricing__c>();
        Map<id, id> networkFAFMap= new Map<id,id>();
        List<Central_Hub__c> faflist = new List<Central_Hub__c>();
        List<Client_Information__c> ClientInfoList = new List<Client_Information__c>();
        Set<id> fafId = new Set<id>();
        //Commented by sonal sharma
        //TF.Client_Info_ID__c=CI.id;
        if(TF.Client_Info_ID__c!=null){
            ClientInfoList =[select id, FAF_ID__c from Client_Information__c where id=: TF.Client_Info_ID__c];
            
            if(!ClientInfoList.isEmpty()){
                for(Client_Information__c cinfo:ClientInfoList){
                    fafId.add(cinfo.FAF_ID__c);
                }
            }
          }
      //  System.debug('TF.Client_Info_ID__c == '+TF.Client_Info_ID__c);
       if(!fafId.isEmpty()){
            ntwrkList= [Select id, Network_Name__c, FAF_ID__c from Network_Pricing__c where FAF_ID__c IN: fafId];
        }
        if(!ntwrkList.isEmpty()){
            for(Network_Pricing__c ntwrkObj : ntwrkList){
            //    System.debug('ntwrkObj == '+ntwrkObj );
                if(ntwrkObj.Network_Name__c.startsWith('MC')){
                    //if Maintenance_Choice_Network1__c is already yes than skip the part
                    //if(TF.Maintenance_Choice_Network1__c!='yes'){
                        TF.Maintenance_Choice_Network1__c='Yes';
                        TF.X90_Day_Network__c='No';
                        if(!networkFAFMap.containsKey(ntwrkObj.FAF_ID__c)){
                            networkFAFMap.put(ntwrkObj.FAF_ID__c,ntwrkObj.id);
                        }
                      //  System.debug('maintainance choice is yes');
                    //}
                }else if(!ntwrkObj.Network_Name__c.startsWith('MC') && (ntwrkObj.Network_Name__c.contains('90'))){
                    //if(TF.X90_Day_Network__c!='yes'){
                        TF.X90_Day_Network__c='Yes';
                        TF.Maintenance_Choice_Network1__c='No';
                        if(!networkFAFMap.containsKey(ntwrkObj.FAF_ID__c)){
                            networkFAFMap.put(ntwrkObj.FAF_ID__c,ntwrkObj.id);
                        }
                      //  System.debug('90 day network is yes');
                    //}
                }else if(!ntwrkObj.Network_Name__c.startsWith('MC') && (!ntwrkObj.Network_Name__c.contains('90'))){
                    if(!networkFAFMap.containsKey(ntwrkObj.FAF_ID__c)){
                        TF.X90_Day_Network__c='No';
                        TF.Maintenance_Choice_Network1__c='No';
                     //   System.debug('both no');
                     }
                }
            }
        }
    }
    
    public Pagereference Save(){
       Try{
        database.upsert(TF);
        //return new pageReference('/'+CI.id);
        return new pageReference(ConstantsUtil.FORWARD_SlASH + TF.id);
        
      }
      catch(exception e){system.debug ('Exception='+e.getmessage());return null;}
    }
    public Pagereference Cancel(){
        //return new pageReference('/'+CI.id);
        try{
        if(TF.id!=null){
            return new pageReference(ConstantsUtil.FORWARD_SlASH + TF.id);
        }else{
            return new pageReference(ConstantsUtil.FORWARD_SlASH + TF.Client_Info_ID__c);
        }
        }catch(Exception e){
         //   System.debug('Exception='+e.getmessage());
            return null;
        }
    }
    
}