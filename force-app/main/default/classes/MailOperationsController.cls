/* ================================================
 * @Class Name        : MailOperationsController
 * @author            : Kiran
 * @Purpose           : This is the controller class for MailOperationsNewEditPage
================================================*/ 
public class MailOperationsController{
    ApexPages.StandardController con;
    Public Boolean isMailOppExists{get;set;}
    public Boolean hasExisitingMP{get;set;}
    Mail_Operations__c mo = new Mail_Operations__c();
    public MailOperationsController( ApexPages.StandardController con )
    {
        
        this.con = con;
        mo = (Mail_Operations__c)con.getRecord();
        if( mo.FAF_ID__c == null && ApexPages.currentPage().getParameters().containsKey(Label.FAFFieldId) )
        {
            mo.FAF_ID__c = ApexPages.currentPage().getParameters().get(Label.FAFFieldId);
        }
        
        if(mo.FAF_ID__c != null)
            {
                List<Mail_Operations__c> mailOpr =[select Id from Mail_Operations__c where Id != :mo.Id AND FAF_ID__c=:mo.FAF_ID__c] ;
                
                if(!mailOpr.isEmpty())
                {
                   isMailOppExists = true;
                }
                else
                {
                    isMailOppExists = false;
                }
          }
          
           hasExisitingMP = false;
        if(con.getId()!=null) { 
            List<Mail_Pricing__c> mpList = [SELECT Id FROM Mail_Pricing__c WHERE FAF_Mail_Operations__c=:con.getId()];
            if(!mpList.isEmpty()) {
                hasExisitingMP = true;
            }
        }
    }
    
   public PageReference saveMailOperations()
   { 
       try{
          if( mo.Method__c == null){
                mo.Time_Frame__c=null;
                mo.Level__c =null;
            }
           con.save();
           Mail_Pricing__c[] mailPricingList = [ SELECT Id,
                                                          Generic_Basis__c,
                                                          MAC_Modeled__c,
                                                          Non_MAC_Generic_Rate__c
                                                          FROM Mail_Pricing__c
                                                          WHERE 
                                                          FAF_Mail_Operations__c =: con.getId()
                                                          ];
            if( !mailPricingList.isEmpty() )                                                          
            {
                for( Mail_Pricing__c mp : mailPricingList )
                {
                    //requirement 1.4.10
                     if( mo.Client__c == 'Lower of MAC or Discount' || mo.Client__c == 'MAC Prevails then Discount' )
                     {
                         mp.Generic_Basis__c = 'MAC Modeled & Non-MAC';
                         mp.Generic_Rate__c =null;
                     }
                     else if( mo.Client__c == 'No MAC' )
                     {
                        mp.Generic_Basis__c = 'Flat Generic Discount';   
                        mp.MAC_Modeled__c = null;
                        mp.Non_MAC_Generic_Rate__c = null;
                     }
                    //end of 1.4.10  
                }
                update mailPricingList;
            }
            
           PageReference ref = con.view();
           ref.setRedirect(true);
           return ref;
       }
       catch( exception e )
       {
           ApexPages.addMessages(e);
           return null;
       }
   }
   
}