// In a separate class so that it can be used elsewhere
Global with sharing class FAFPlatformSpecifics {
    
    @InvocableMethod
    public static void PlatformSpecifics(List<Id> FAFIds) {         

        List<Central_Hub__c> fafList = new List<Central_Hub__c>();
        
        Set<Id> FAFReleasedDateNullIds = new Set<Id>();
        Set<Id> FAFReleasedDateNotNullIds = new Set<Id>();
        string Cont = '';
        integer Cnt = 0;
        
        system.debug('::Entering PlatformSpecifics::');
        for(Central_Hub__c faf1 : [Select id,Platform_Specifics_Detail_Length__c,FAF_Released_Date__c from Central_Hub__c where id in : FAFIds and Platform_Specifics_Detail_Length__c = 0]){
            system.debug('::FAF Release Date::'+faf1.FAF_Released_Date__c);
            system.debug('::Platform_Specifics_Detail_Length__c::'+faf1.Platform_Specifics_Detail_Length__c);
            if (faf1.Platform_Specifics_Detail_Length__c == 0) {
                if(faf1.FAF_Released_Date__c == null){
                    FAFReleasedDateNullIds.add(faf1.id);
                }
                else if(faf1.FAF_Released_Date__c != null){
                    FAFReleasedDateNotNullIds.add(faf1.Id);
                }
           }
        }

        if(FAFReleasedDateNullIds.size()>0){                             
              for ( Central_Hub__c faf : [Select Id, FAF_Released_Date__c,Platform_Specifics_Details__c, Platform_Specifics_Detail_Length__c from Central_Hub__c where id in : FAFReleasedDateNullIds]) {                 
                 system.debug('::FAF Null Release Date::');   
                 if(faf.FAF_Released_Date__c == null){                                    
                    String htmlBody = '';

                    //open table..
                    htmlBody = '<table border="1" style="border-collapse: collapse">'
                    +'<caption>Platform Specific Data</caption>'
                    +'<tr>'
                        +'<th>Record</th>'
                        +'<th>Platform</th>'
                        +'<th>LOB</th>'
                        +'<th>Instruction</th>'
                        +'<th>Level 1 ID</th>'
                        +'<th>Level 1 Name</th>'
                        +'<th>Level 2 ID</th>'
                        +'<th>Level 3 ID</th>'
                        +'<th>Effective Date</th>'

                    +'</tr>';

                    //iterate over list and output columns/data into table rows...
                      List<Platform_Specifics__c > PSList = [Select id,Name,Platform__c,LOB__c,Instruction__c,Level_1_ID__c,Level1_Name__c,Level_2_ID__c,Level_3_ID__c,EffectiveDate__c,LastModifiedDate from Platform_Specifics__c where FAF_ID__c = :faf.Id];
                      if(PSList != null && !PSList .isEmpty())  {
                      system.debug('::Platform_Specifics 2::');
                      for(Platform_Specifics__c ps: PSList) {                      
                        system.debug('::Platform_Specifics1::');       
                        String myName = ps.Name == null ? '' : ps.Name;
                        String myPlatform = ps.Platform__c; if(ps.Platform__c == null){myPlatform = '';}                   
                        String myLOB = ps.LOB__c; if(ps.LOB__c == null){myLOB = '';}
                        String myInstruction = ps.Instruction__c; if(ps.Instruction__c == null){myInstruction = '';}
                        String myLevel1ID = ps.Level_1_ID__c; if(ps.Level_1_ID__c == null){myLevel1ID = '';}
                        String myLevel1Name = ps.Level1_Name__c; if(ps.Level1_Name__c == null){myLevel1Name = '';}
                        String myLevel2ID = ps.Level_2_ID__c; if(ps.Level_2_ID__c == null){myLevel2ID = '';}
                        String myLevel3ID = ps.Level_3_ID__c; if(ps.Level_3_ID__c == null){myLevel3ID = '';} 
                        String myEffectiveDate = ps.EffectiveDate__c == null ? '': string.valueOf(ps.EffectiveDate__c.format());
                        String myModifiedDate = ps.LastModifiedDate == null ? '': string.valueOf(ps.LastModifiedDate.format());
                        
                        if(ps.EffectiveDate__c == null){myEffectiveDate = '';}                 

                        htmlBody += '<tr>'
                                        +'<td>' + myName + '</td>'
                                        +'<td>' + myPlatform + '</td>'
                                        +'<td>' + myLOB + '</td>'
                                        +'<td>' + myInstruction + '</td>'
                                        +'<td>' + myLevel1ID + '</td>'
                                        +'<td>' + myLevel1Name + '</td>'
                                        +'<td>' + myLevel2ID + '</td>'
                                        +'<td>' + myLevel3ID + '</td>'
                                        +'<td>' + myEffectiveDate + '</td>'
                                        
                                    +'</tr>';
                             cnt++;
                             if (htmlBody.length() > Integer.valueOf(Label.MaxEmailBody)) {
                                 Cont = '....';
                                 htmlBody +='<tr>'
                                    +'<td>' + Cont + '</td>'
                                    +'<td>' + Cont + '</td>'
                                    +'<td>' + Cont + '</td>'
                                    +'<td>' + Cont + '</td>'
                                    +'<td>' + Cont + '</td>'
                                    +'<td>' + Cont + '</td>'
                                    +'<td>' + Cont + '</td>'
                                    +'<td>' + Cont + '</td>'
                                    +'<td>' + Cont + '</td>'                                                                              
                                +'</tr>';                             

                                 break;
                             }                                    

                    }

                    //close table...
                    htmlBody += '</table>'; 
                    system.debug('::htmlBody Length::'+htmlBody.length()+' count='+cnt);
                     
//                    faf.Platform_Specifics_Details__c = htmlBody;
                    faf.TestField__c = htmlBody;                    
                   faf.Platform_Specifics_Detail_Length__c = htmlBody.length();
                    system.debug('::Platform_Specifics_Details::'+faf.TestField__c);
                    fafList.add(faf);
              
                }
                }                       
            }
        }
        
        else if(FAFReleasedDateNotNullIds.size()>0){
              for ( Central_Hub__c faf : [Select Id, FAF_Released_Date__c,Platform_Specifics_Detail_Length__c from Central_Hub__c where id in : FAFReleasedDateNotNullIds]) {                                    
                system.debug('::faf 2::'); 
                if(faf.FAF_Released_Date__c != null){
                    //iterate over list and output columns/data into table rows...
                    String htmlBody = '';
                    //open table..
                    htmlBody = '<table border="1" style="border-collapse: collapse">'
                    +'<caption>Platform Specific Data</caption>'
                    +'<tr>'
                        +'<th>Record</th>'
                        +'<th>Platform</th>'
                        +'<th>LOB</th>'
                        +'<th>Instruction</th>'
                        +'<th>Level 1 ID</th>'
                        +'<th>Level 1 Name</th>'
                        +'<th>Level 2 ID</th>'
                        +'<th>Level 3 ID</th>'
                        +'<th>Effective Date</th>'
//                                +'<th>Modified Date</th>'                                

                    +'</tr>';                   
                    
                      List<Platform_Specifics__c > PSList = [Select id,Name,Platform__c,LOB__c,Instruction__c,Level_1_ID__c,Level1_Name__c,Level_2_ID__c,Level_3_ID__c,EffectiveDate__c,LastModifiedDate from Platform_Specifics__c where FAF_ID__c = :faf.Id];
                      if(PSList != null && !PSList .isEmpty())  
                      {
                      for(Platform_Specifics__c ps: PSList) {
                         system.debug('::Platform_Specifics 2::'+ ps.Id + ' Release:' +faf.FAF_Released_Date__c + ' Modified:' + ps.LastModifiedDate );                                                                       
                        if(ps.LastModifiedDate >= faf.FAF_Released_Date__c){                                                                                                                    
                            String myName = ps.Name == null ? '' : ps.Name;
                            String myPlatform = ps.Platform__c; if(ps.Platform__c == null){myPlatform = '';}                   
                            String myLOB = ps.LOB__c; if(ps.LOB__c == null){myLOB = '';}
                            String myInstruction = ps.Instruction__c; if(ps.Instruction__c == null){myInstruction = '';}
                            String myLevel1ID = ps.Level_1_ID__c; if(ps.Level_1_ID__c == null){myLevel1ID = '';}
                            String myLevel1Name = ps.Level1_Name__c; if(ps.Level1_Name__c == null){myLevel1Name = '';}
                            String myLevel2ID = ps.Level_2_ID__c; if(ps.Level_2_ID__c == null){myLevel2ID = '';}
                            String myLevel3ID = ps.Level_3_ID__c; if(ps.Level_3_ID__c == null){myLevel3ID = '';} 
                            String myEffectiveDate = ps.EffectiveDate__c == null ? '': string.valueOf(ps.EffectiveDate__c.format());
                            String myModifiedDate = ps.LastModifiedDate == null ? '': string.valueOf(ps.LastModifiedDate.format());                 

                            htmlBody += '<tr>'
                                            +'<td>' + myName + '</td>'
                                            +'<td>' + myPlatform + '</td>'
                                            +'<td>' + myLOB + '</td>'
                                            +'<td>' + myInstruction + '</td>'
                                            +'<td>' + myLevel1ID + '</td>'
                                            +'<td>' + myLevel1Name + '</td>'
                                            +'<td>' + myLevel2ID + '</td>'
                                            +'<td>' + myLevel3ID + '</td>'
                                            +'<td>' + myEffectiveDate + '</td>'
//                                            +'<td>' + myModifiedDate + '</td>'                                            
                                            
                                        +'</tr>';
                             cnt++; 
                             if (htmlBody.length() > Integer.valueOf(Label.MaxEmailBody)) {
                                 Cont = '....';
                                 htmlBody +='<tr>'
                                    +'<td>' + Cont + '</td>'
                                    +'<td>' + Cont + '</td>'
                                    +'<td>' + Cont + '</td>'
                                    +'<td>' + Cont + '</td>'
                                    +'<td>' + Cont + '</td>'
                                    +'<td>' + Cont + '</td>'
                                    +'<td>' + Cont + '</td>'
                                    +'<td>' + Cont + '</td>'
                                    +'<td>' + Cont + '</td>'                                                                              
                                +'</tr>';                             

                                 break;
                             }
                         }                                                                                 
                                    
                    }     
                    //close table...
                    htmlBody += '</table>';                 
                    system.debug('::htmlBody Length::'+htmlBody.length()+' count='+cnt);
                     
//                    faf.Platform_Specifics_Details__c = htmlBody;
                    faf.TestField__c = htmlBody;
                    faf.Platform_Specifics_Detail_Length__c = htmlBody.length();
                    system.debug('::Platform_Specifics_Details::'+faf.TestField__c);
                    fafList.add(faf);             
                }                       
            }
        }
        }     
        if(fafList.size()>0){
            system.debug('::Updating FAF');
            database.update(fafList);

        }
    }   
}