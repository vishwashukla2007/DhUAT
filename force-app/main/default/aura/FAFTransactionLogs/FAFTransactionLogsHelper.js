({
	convertArrayOfObjectsToCSV : function(component,objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
       
        // check if "objectRecords" parameter is null, then return from function
        if (objectRecords == null || !objectRecords.length) {
            return null;
         }
        // store ,[comma] in columnDivider variabel for sparate CSV values and 
        // for start next line use '\n' [new line] in lineDivider varaible  
        columnDivider = ',';
        lineDivider =  '\n';
 
        // in the keys valirable store fields API Names as a key 
        // this labels use in CSV file header  
        var headers = ['FAF ID', 'Timestamp','Transaction By', 'FAF Object', 'Transaction Type','Transaction Detail','User Profile'];
        keys = ['FAFId__r.Name','TimeStamp__c' ,'TransactionBy__r.Name', 'FafObject__c', 'TransactionType__c','TransactionDetail__c','TransactionBy__r.Profile.Name'];

        csvStringResult = '';
        csvStringResult += headers.join(columnDivider);
        csvStringResult += lineDivider;
 
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
           
             for(var sTempkey in keys)
             {
                var skey = keys[sTempkey] ;  
 
              // add , [comma] after every String value,. [except first]
                  if(counter > 0){ 
                      csvStringResult += columnDivider; 
                   }   
               		
                 if( skey == 'FAFId__r.Name' )
                 {
                     if(  objectRecords[i]['FAFId__r'] )
                     	csvStringResult += '"'+ objectRecords[i]['FAFId__r']['Name']+'"';
                     else
                         csvStringResult += '';
                 }
                 else if( skey == 'TransactionBy__r.Profile.Name' && objectRecords[i]['TransactionBy__r'] 
                         && objectRecords[i]['TransactionBy__r']['Profile']  )
                 {
                     csvStringResult += '"'+ objectRecords[i]['TransactionBy__r']['Profile']['Name']+'"';
                 }
                 else if( skey == 'TransactionBy__r.Name' && objectRecords[i]['TransactionBy__r'])
                 {
                     csvStringResult += '"'+ objectRecords[i]['TransactionBy__r']['Name']+'"';
                 }
                  else{
                      csvStringResult += '"'+ objectRecords[i][skey]+'"';
                  }
               
               counter++;
 
            } // inner for loop close 
             csvStringResult += lineDivider;
          }// outer main for loop close 
       
       // return the CSV formate String 
        return csvStringResult;        
    },
})