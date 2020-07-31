/* ================================================
 * @Class Name        : MailPricingEditController
 * @author            : Kiran
 * @Purpose           : This is the controller class for MailPricingNewEditPage
================================================*/ 
public class MailPricingEditController 
{
   public ApexPages.StandardController con;
   
   public boolean disableSSG {get;set;}
   public string mailOperationsId {get;set;}
   public boolean disableSSGIntoBrand {get;set;}
   public list<SelectOption> yearOptions {get;set;}
   public string yearval{get;set;}
   public boolean isExpandableView {get;set;}
   public string urlString {get;set;} 
   Mail_Pricing__c mailPricing;
   public String operationType;// custom clone functionality
   public MailPricingEditController( ApexPages.StandardController con )
   {
         operationType=ApexPages.currentPage().getParameters().get(ConstantsUtil.TYPE); //for the clone
         if( ApexPages.currentPage().getParameters().containsKey('isExpandableView') 
                && ApexPages.currentPage().getParameters().get('isExpandableView') == 'true' )
        {
            isExpandableView = true;
        }
        else isExpandableView = false;
        this.con = con; 
        mailPricing = (Mail_Pricing__c)con.getRecord();
        
        if( ApexPages.currentPage().getParameters().containsKey(Label.MailOperationsFieldId) )
        {
            string mailOppId = ApexPages.currentPage().getParameters().get(Label.MailOperationsFieldId);
            for( Mail_Operations__c mp : [SELECT Id , FAF_ID__c, Client__c FROM Mail_Operations__c WHERE Id =: mailOppId] )
            {
                //system.debug(mp.FAF_ID__c);
                if( mailPricing.FAF_Mail_Operations__c == null ){
                    mailPricing.FAF_Mail_Operations__c = mp.Id;
                }
                 
                
                 mailPricing.FAF_ID__c = mailPricing.FAF_ID__c == null ? mp.FAF_ID__c: mailPricing.FAF_ID__c;
                
                //requirement 1.2.24
                
                 if( mp.Client__c == 'Lower of MAC or Discount' || mp.Client__c == 'MAC Prevails then Discount' )
                 {
                     mailPricing.Generic_Basis__c = 'MAC Modeled & Non-MAC';
                 }
                 else if( mp.Client__c == 'No MAC' )
                 {
                    mailPricing.Generic_Basis__c = 'Flat Generic Discount';
                     
                 }
                //end of 1.2.24  
            }
        }
        
        mailOperationsId = mailPricing.FAF_Mail_Operations__c;
        disableSSG = true;
        disableSSGIntoBrand = true;
        if( con.getId() <> null )
        {
           for( Mail_Guarantees__c mg :[ SELECT Id,
                                                SSG__c,
                                                Type__c
                                                FROM Mail_Guarantees__c 
                                                WHERE Mail_Pricing__c = :con.getId() 
                                                 ] )
            {
                if(mg.SSG__c == 'No'  )
                    disableSSG = false;
                    
                if( mg.Type__c == 'BER' || mg.Type__c == 'SSG')   
                    disableSSGIntoBrand = false;
            }
        }
        
        //prepare year options 
        yearOptions = new list<SelectOption>();
        string[] selectedYears = new string[]{};
        for( Client_Information__c cif : [SELECT Year_1__c, 
                                                 Year_2__c, 
                                                 Year_3__c, 
                                                 Year_4__c, 
                                                 Year_5__c 
                                                 FROM Client_Information__c
                                                 WHERE Escalating_Pricing__c=true AND FAF_ID__c = : mailPricing.FAF_ID__c LIMIT 1] )
        {
            for( string fld : new list<string>{ 'Year_1__c', 'Year_2__c', 'Year_3__c', 'Year_4__c', 'Year_5__c' })
            {
                if( cif.get(fld) <> null )
                {
                   selectedYears.add(cif.get(fld)+'');
                   //yearOptions.add( new SelectOption( cif.get(fld)+'', cif.get(fld)+'' ) );
                }
            }
        }
        
        
        if( selectedYears.isEmpty() )//if escalating price is null
        {
            yearOptions.add(new SelectOption('All','All'));
        }
        else
        {
            if( mailPricing.Id == null ){
                yearOptions.add(new SelectOption('','--None--'));// if escalating price have years 
            }
            for( string str:selectedYears )   
            {
                yearOptions.add(new SelectOption(str,str));
            }
            
            
            yearOptions.add(new SelectOption('All','All'));
        }
   } 
   
   public PageReference saveMailPricing()
   {
       try{
            urlString='';
           boolean errorFlag = false;
           
           
           if( mailPricing.Brand_Rate__c  <> null &&( mailPricing.Brand_Rate__c  > 100 || mailPricing.Brand_Rate__c  < 0 ) )
            {
                mailPricing.Brand_Rate__c .addError('Brand Rate must be between 0.00% and 100.00%.');
                errorFlag = true;
            }
            if( mailPricing.Generic_Rate__c   <> null &&( mailPricing.Generic_Rate__c   > 100 || mailPricing.Generic_Rate__c   < 0 ) )
            {
                mailPricing.Generic_Rate__c  .addError('Generic Rate must be between 0.00% and 100.00%.');
                errorFlag = true;
            }
            if( mailPricing.Non_MAC_Generic_Rate__c    <> null &&( mailPricing.Non_MAC_Generic_Rate__c    > 100 || mailPricing.Non_MAC_Generic_Rate__c    < 0 ) )
            {
                mailPricing.Non_MAC_Generic_Rate__c   .addError('Non-MAC Generic Rate must be between 0.00% and 100.00%.');
                errorFlag = true;
            }
        
            if( mailPricing.Preferred_Brand_Rate__c <> null &&( mailPricing.Preferred_Brand_Rate__c > 100 || mailPricing.Preferred_Brand_Rate__c < 0 ) )
            {
                mailPricing.Preferred_Brand_Rate__c.addError('Preferred Brand Rate must be between 0.00% and 100.00%.');
                errorFlag = true;
            }
            if( mailPricing.Non_Preferred_Brand_Rate__c <> null &&( mailPricing.Non_Preferred_Brand_Rate__c > 100 || mailPricing.Non_Preferred_Brand_Rate__c < 0 ) )
            {
                mailPricing.Non_Preferred_Brand_Rate__c.addError('Non-Preferred Brand Rate must be between 0.00% and 100.00%.');
                errorFlag = true;
            }
           system.debug('==============mailPricing============='+mailPricing);
           system.debug('==============errorFlag============='+errorFlag);
           if( errorFlag ){
               return null;
           }
           // Condition added for copy pricing & its Guarantees functionality
           String url;
            if(ConstantsUtil.CLONE.equals(operationType)){
                SObject cloneSObj;
                cloneSObj=CustomCloneUtility.customCloneMethod(mailPricing);
                insert cloneSObj;
                
                List<Mail_Guarantees__c>MailGuaranteeList = new List<Mail_Guarantees__c>();
                List<Mail_Guarantees__c>newMailGuaranteeList = new List<Mail_Guarantees__c>();
                MailGuaranteeList = [select id, name, X340B__c, X340B_Inclusion_Option__c, Biosimilars__c, COB__c, Compound__c, FAF_ID__c, LDD__c, LDD_Inclusion_Option__c, Link__c, Mail_Operations_Link__c, Mail_Pricing__c, Mail_Pricing_Link__c, OTC__c, Paper__c, Rate__c, Source_Record_ID__c, SSG__c, Type__c, Vaccine__c, Vaccine_Inclusion_Option__c, ZBD__c FROM Mail_Guarantees__c where Mail_Pricing__c = :mailPricing.id];
                for(Mail_Guarantees__c mpg: MailGuaranteeList){
                    mpg.id = null;
                    mpg.Mail_Pricing__c = cloneSObj.id;
                    newMailGuaranteeList.add(mpg);
                }
                insert newMailGuaranteeList;
                url = ConstantsUtil.FORWARD_SlASH +cloneSObj.id;
            }else{
                upsert mailPricing;
                url = '/' + mailPricing.id;
            }
           //con.save();
          /* Mail_Guarantees__c[] mgList = [ SELECT Id, Rate__c FROM Mail_Guarantees__c WHERE Mail_Pricing__c = : con.getId()  ]  ;
          
          if( !mgList.isEmpty() )
           {
               for( Mail_Guarantees__c mg: mgList )
               {
                   mg.Rate__c = mailPricing.Brand_Rate__c;
               }
               update mgList;
           }
           */
           system.debug('=======isExpandableView'+isExpandableView);
           if( isExpandableView ){
               
                urlString = '/'+mailOperationsId;
                return null;
           }
           
          // PageReference ref =  con.view();
           //ref.setRedirect(true);
           //return ref;
           
           PageReference ref = new PageReference(url);
           return ref;
       }
       catch(exception e)
       {
           ApexPages.addMessages(e);
       }
       return null;
   }
   
   Public void changeYearMeth(){
        mailPricing.year__c = yearval;
    }

}