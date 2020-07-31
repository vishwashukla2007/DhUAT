/* ================================================
 * @Class Name        : MailGuaranteesController
 * @author            : Kiran
 * @Purpose           : This is the controller class for MailguaranteesNewEditPage
================================================*/ 
public class MailGuaranteesController 
{
    ApexPages.StandardController con;
    Mail_Guarantees__c mg;
    public boolean hasMethodExists {get;set;}
    public string mailOperationsId {get;set;}
    public boolean isExpandableView {get;set;}
    public string urlString {get;set;} 
    
    public MailGuaranteesController( ApexPages.StandardController con )
    {
      if( ApexPages.currentPage().getParameters().containsKey('isExpandableView') 
                && ApexPages.currentPage().getParameters().get('isExpandableView') == 'true' )
        {
            isExpandableView = true;
        }
        else isExpandableView = false; 

        this.con = con;
        mg = (Mail_Guarantees__c)con.getRecord();
        string mailPricingId;
        hasMethodExists = true;
        
        if( mg.FAF_ID__c == null && ApexPages.currentPage().getParameters().containsKey(Label.MailPricingFieldId) )
        {
            mailPricingId = ApexPages.currentPage().getParameters().get(Label.MailPricingFieldId);
        }
        else
            mailPricingId = mg.Mail_Pricing__c;
        
        if( mg.Mail_Pricing__c == null )
                mg.Mail_Pricing__c = mailPricingId;
        
        for( Mail_Pricing__c mp : [SELECT Id, 
                                          FAF_ID__c,
                                          Brand_Rate__c, 
                                          FAF_Mail_Operations__c,
                                          FAF_Mail_Operations__r.Method__c ,
                                          FAF_Mail_Operations__r.Time_Frame__c, 
                                          FAF_Mail_Operations__r.Level__c 
                                          FROM Mail_Pricing__c 
                                          WHERE Id = : mg.Mail_Pricing__c] )
        {
            mailOperationsId = mp.FAF_Mail_Operations__c;
            if( mg.FAF_ID__c == null )    
                mg.FAF_ID__c = mp.FAF_ID__c;
                
            if( mg.Id == null && mp.FAF_Mail_Operations__r.Method__c == null && mp.FAF_Mail_Operations__r.Time_Frame__c == null && mp.FAF_Mail_Operations__r.Level__c ==null)            
            {
                hasMethodExists = false;
                ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.FATAL,  
                'Cannot create a Mail Guarantee record when Mail Guarantee Reconciliation Method, Level and Timeframe are not specified on Mail Operations.'));
            }
        }    
        
    }
   
   public PageReference saveMailGuarantees()
   {
       try{
           urlString = '';
           boolean errorFlag = false;
           if(mg.LDD__c == 'Yes' )
           {
             mg.LDD_Inclusion_Option__c = null;
           }
           if(mg.X340B__c == 'Yes' )
           {
             mg.X340B_Inclusion_Option__c = null;
           }
           if(mg.Vaccine__c == 'Yes' )
           {
            mg.Vaccine_Inclusion_Option__c = null;
           }
           if( mg.Rate__c  <> null &&( mg.Rate__c  > 100 || mg.Rate__c  < 0 ) )
            {
                mg.Rate__c .addError('Mail Guarantee Rate must be between 0.00% and 100.00%.');
                errorFlag = true;
            }
            if( errorFlag ) return null;
           upsert mg;
           Mail_Guarantees__c[] mgList = [SELECT Id from Mail_Guarantees__c WHERE Mail_Pricing__c = :mg.Mail_Pricing__c AND( Type__c = 'BER' OR Type__c = 'SSG')];
           Mail_Pricing__c mpObject =  new Mail_Pricing__c( Id = mg.Mail_Pricing__c );
           
           if( mgList.isEmpty() )  
           {
               mpObject.SSGs_into_Brands__c = false;
           }
           Mail_Guarantees__c[] mgList2 = [SELECT Id from Mail_Guarantees__c 
                                          WHERE Mail_Pricing__c = :mg.Mail_Pricing__c 
                                          AND SSG__c = 'No' LIMIT 1];
           if( mgList2.isEmpty() )
           {
               mpObject.SSG_Exclusion_List__c = null;
               mpObject.SSG_Exclusivity_Period__c = null;
           }
           /*
           if( mg.SSG__c == 'Yes' )
           {
               mpObject.SSG_Exclusion_List__c = null;
               mpObject.SSG_Exclusivity_Period__c = null;
           }
           */
           update mpObject;
           
          if( isExpandableView ){
                //urlString = '/c/Apttus_MP_Expandable_View.app?moId='+mailOperationsId ;
                urlString = '/'+mailOperationsId;
                return null;
           }

           PageReference ref = new PageReference('/'+ mg.Id);
           ref.setRedirect(true);
           return ref;
       }
       catch(exception e)
       {
           //ApexPages.addMessages(e);
           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getDmlMessage(0))); 
           return null;
       }
   }
   
   public void populateRate()
   {
        if( mg.Type__c == 'SSG' && mg.SSG__c == 'No' )
        {
            for( Mail_Pricing__c mp : [SELECT Id, FAF_ID__c,Brand_Rate__c FROM Mail_Pricing__c WHERE Id = : mg.Mail_Pricing__c] )
            {
                 mg.Rate__c = mp.Brand_Rate__c;
            }
        }
        //else mg.Rate__c = null;
       if( mg.Type__c == 'SSG')
       {
           mg.X340B_Inclusion_Option__c=null;
           mg.LDD_Inclusion_Option__c=null;
           mg.Vaccine_Inclusion_Option__c = null;
           
       }
       
   }
   
}