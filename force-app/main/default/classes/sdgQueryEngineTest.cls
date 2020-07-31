/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@isTest
public class sdgQueryEngineTest {



    static testMethod void TestBooleanFilter()
    {
        //Generate test data: an account and an opportunity:
        String testdata= sdgTestData.GenerateTestSampleData();

        STring erlid = sdgTestData.GenerateTestSDG();
        String stringfield = sdgTestData.GenerateTestSDGFieldString(erlid);
        String datefield = sdgTestData.GenerateTestSDGFieldDate(erlid);
        String booleanfield = sdgTestData.GenerateTestSDGFieldBoolean(erlid);
        String picklistfield = sdgTestData.GenerateTestSDGFieldPicklist(erlid);

        Test.startTest();

        //Generate a request:
        SDGREquest req = new SDGREquest();
        req.SDGTag ='CustomObject:' + sdgTestData.TestSDGName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;


        //Now invoke normal list:
        SDGResult result = getresult(req);
        System.debug('TestBooleanFilter: Expected rowcount=2 from load' + result.FullQueryCount);

        //create a filter for TRUE:
        List<SDGFilter> Filters = new List<SDGFilter>();
        SDGFilter newfilter = new SDGFilter();
        newfilter.SDGFieldID = booleanfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue='true';
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result2 = getResult(req);
        System.debug('TestBooleanFilter: Expected rowcount=2 from is is_valid__c filter' + result2.FullQueryCount);
        System.debug('TestBooleanFilter: Expected no error with  boolean=true filter' + result2.isError);

        //create a filter for FALSE:
        filters.clear();
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = booleanfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue='false';
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result3 = getResult(req);
        System.debug('TestBooleanFilter: Expected rowcount=0 from is is_valid=false filter'+ result3.FullQueryCount);
        System.debug('TestBooleanFilter: Expected no error with  boolean=false filter' + result3.isError);

        //invalid value
        filters.clear();
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = booleanfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue='teapot';
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result4 = getResult(req);
        System.debug('TestBooleanFilter: Expected error with invalid boolean filter' + result4.isError);


        Test.stopTest();
    }
    static testMethod void TestPicklistFilter()
    {
        //Generate test data: an account and an opportunity:
        String testdata= sdgTestData.GenerateTestSampleData();

        STring erlid = sdgTestData.GenerateTestSDG();
        String stringfield = sdgTestData.GenerateTestSDGFieldString(erlid);
        String datefield = sdgTestData.GenerateTestSDGFieldDate(erlid);
        String booleanfield = sdgTestData.GenerateTestSDGFieldBoolean(erlid);
        String picklistfield = sdgTestData.GenerateTestSDGFieldPicklist(erlid);

        //Prep test catching values:
        Boolean errorThrown=false;
        String errorMsg = '';
        Test.startTest();

        //Generate a request:
        SDGREquest req = new SDGREquest();
        req.SDGTag = 'CustomObject:' + sdgTestData.TestSDGName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;


        //Now invoke:
        SDGResult  result = getresult(req);
        System.debug('TestPicklistFilter: Expected rowcount=2 from load' + result.FullQueryCount);
        System.debug('TestPicklistFilter: No error expected' + result.isError);

        //create a filter
        List<SDGFilter> Filters = new List<SDGFilter>();
        SDGFilter newfilter = new SDGFilter();
        newfilter.SDGFieldID = picklistfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue='Prospecting';
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result2 = getresult(req);
        System.debug('TestPicklistFilter: Expected rowcount=0 from picklist filter=prospecting' + result2.FullQueryCount);
        System.debug('TestPicklistFilter: No error expected filter = prospecting' + result2.isError);
        sdg_field__c f = [select id, field_style__c from sdg_field__c where sdg__r.id = :testdata limit 1];
        f.field_style__c = 'Age';
        update f;
        //test with a filter that returns 1 row:
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = picklistfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue='Age';
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result3 = getresult(req);
        System.debug('TestPicklistFilter: Expected rowcount=1 from filter=Age' + result3.FullQueryCount);
        System.debug('TestPicklistFilter: No error expected: filter=Age lost' + result3.isError);

        Test.stopTest();
    }
    static testMethod void TestDateFilter()
    {
        //Generate test data: an account and an opportunity:
        String testdata=sdgTestData.GenerateTestSampleData();

        STring erlid = sdgTestData.GenerateTestSDG();
        String stringfield = sdgTestData.GenerateTestSDGFieldString(erlid);
        String datefield = sdgTestData.GenerateTestSDGFieldDate(erlid);
        String datetimefield = sdgTestData.GenerateTestSDGFieldDateTime(erlid);
        String booleanfield = sdgTestData.GenerateTestSDGFieldBoolean(erlid);
        String picklistfield = sdgTestData.GenerateTestSDGFieldPicklist(erlid);


        Test.startTest();

        //Generate a request:
        SDGREquest req = new SDGREquest();
        req.SDGTag = 'CustomObject:' + sdgTestData.TestSDGName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;


        //Now invoke:
        SDGResult  result = getresult(req);
        System.debug('Expected rowcount=2 from load' + result.FullQueryCount);

        //create a filter that forces zero rows:
        List<SDGFilter> Filters = new List<SDGFilter>();
        SDGFilter newfilter = new SDGFilter();
        newfilter.SDGFieldID = datefield;
        newfilter.FilterOperator='LAST_WEEK';
        newfilter.filtervalue='=';
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result2 = getresult(req);
        System.debug('Expected rowcount=0 from date filter' + result2.FullQueryCount);

        //filter with thisweek
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = datefield;
        newfilter.FilterOperator='THIS_WEEK';
        newfilter.filtervalue='=';
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result3 = getresult(req);
        System.debug('Date filter this week: ' + result3.ErrorMessage);
        System.debug('Expected rowcount=2 from filter' + result3.FullQueryCount);

        //test with a real date filter
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = datefield;
        Date d = Date.today();
        String sd = d.year() + '-' + String.valueOf(d.month()).leftpad(2).replaceall(' ','0') + '-' + String.valueOf(d.day()).leftpad(2).replaceall(' ','0')  ;
        newfilter.FilterOperator='=';
        newfilter.filtervalue=sd;
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result4 = getresult(req);
        System.debug('Date filter today: ' + result4.ErrorMessage);
        System.debug('Date filter today: mismatch' + result4.FullQueryCount);

        //test with a real date filter
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = datefield;
        date d2 = DAte.today().addDays(-1);
        String sd2 = d2.year() + '-' + d2.month() + '-' + d2.day() ;

        newfilter.FilterOperator='=';
        newfilter.filtervalue=sd2;
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result5 = getresult(req);
        System.debug('Expected rowcount=0 from date filter yesterday' + result5.FullQueryCount);

        //test with a real date filter
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = datefield;
        newfilter.FilterOperator='GT';
        newfilter.filtervalue=sd2;
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result6 = getresult(req);
        System.debug('Expected rowcount=2 from date filter greater than yesterday' + result6.FullQueryCount);

        //Less than test
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = datefield;
        newfilter.FilterOperator='LT';
        newfilter.filtervalue=sd2;
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result7 = getresult(req);
        System.debug('Expected rowcount=0 from date filter less than yesterday' + result7.FullQueryCount);

        //Invalid date
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = datefield;
        newfilter.FilterOperator='LT';
        newfilter.filtervalue='an invalid date';
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result8 = getresult(req);
        System.debug('expected error for invalid date format' + result8.isError );


        Test.stopTest();
    }

    static testMethod void TestDateTimeFilter()
    {
        //generate test data of: one sdg, with two columns - name and [namespace]apiname
        String testdata= sdgTestData.GenerateTestSampleData();
        //Generate the querying sdg
        STring erlid = sdgTestData.GenerateTestSDG();
        sdgTestData.GenerateTestSDGFieldString(erlid);
        sdgTestData.GenerateTestSDGFieldDate(erlid);
        String datetimefield = sdgTestData.GenerateTestSDGFieldDateTime(erlid);
        sdgTestData.GenerateTestSDGFieldBoolean(erlid);
        sdgTestData.GenerateTestSDGFieldPicklist(erlid);


        Test.startTest();

        //Generate a request:
        SDGREquest req = new SDGREquest();
        req.SDGTag = 'CustomObject:' + sdgTestData.TestSDGName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;


        //Now invoke:
        SDGResult  result = getresult(req);
        System.debug('Expected rowcount=2 from load' + result.FullQueryCount);

        //create a literal filter:
        List<SDGFilter> Filters = new List<SDGFilter>();
        SDGFilter newfilter = new SDGFilter();
        newfilter.SDGFieldID = datetimefield;
        newfilter.FilterOperator='LAST_WEEK';
        newfilter.filtervalue='ABC';
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result2 = getresult(req);
        System.debug('Expected rowcount=0 from datetime filter last week' + result2.FullQueryCount);

        //filter with thisweek
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = datetimefield;
        newfilter.FilterOperator='THIS_WEEK';
        newfilter.filtervalue='DEF';
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result3 = getresult(req);
        System.debug('Expected rowcount=2 from filter this week' + result3.FullQueryCount);

        //test with a real date filter
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = datetimefield;
        Date d = Date.today();
        String sd = d.year() + '-' + String.valueOf(d.month()).leftpad(2).replaceall(' ','0') + '-' + String.valueOf(d.day()).leftpad(2).replaceall(' ','0')  ;
        newfilter.FilterOperator='=';
        newfilter.filtervalue=sd;
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result4 = getresult(req);
        System.debug('Expected no error from date filter today: ' + result4.ErrorMessage);
        System.debug('Expected rowcount=2 from date filter today' + result4.FullQueryCount);

        //GT
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = datetimefield;
        newfilter.FilterOperator='GT';
        newfilter.filtervalue=sd;
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result5 = getresult(req);
        System.debug('Expected no error from datetime GT ' + result4.ErrorMessage);
        System.debug('Expected rowcount=2 from datetime GT ' + result5.FullQueryCount);

        //LT
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = datetimefield;
        newfilter.FilterOperator='LT';
        newfilter.filtervalue=sd;
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result6 = getresult(req);
         System.debug('Expected no error from LT datetime filter ' + result4.ErrorMessage);
         System.debug('Expected rowcount=2 from LT datetime filter ' + result6.FullQueryCount);


        Test.stopTest();
    }

    static testMethod void TestDefaultFilter()
    {
        //Generate test data: an account and an opportunity:
        String testdata=sdgTestData.GenerateTestSampleData();

        STring erlid = sdgTestData.GenerateTestSDG();

        String stringfield = sdgTestData.GenerateTestSDGFieldString(erlid);

        Test.startTest();

        //Generate a request:
        SDGRequest req = new SDGREquest();
        req.SDGTag = 'CustomObject:' + sdgTestData.TestSDGName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;
        req.sortOrder='A';
        req.sortColumn=stringfield;

        //Now invoke normal list:
        SDGResult result = getresult(req);
        System.debug('expected two rows in results' + result.FullQueryCount);

        //Now add a server side filter
        sdg__c sdg2 = [select id, name, filter__c from sdg__c where id=:erlid];

        sdg2.filter__c = 'apiname__c like \'na%\'';
        update sdg2;
        SDGResult result2 = getresult(req);
        System.debug('Server side filter' + result2.FullQueryCount);

        TEst.stopTest();

    }
    static testMethod void TestFilterCacheing()
    {
        String testdata=sdgTestData.GenerateTestSampleData();

        STring erlid = sdgTestData.GenerateTestSDG();
        String stringfield = sdgTestData.GenerateTestSDGFieldString(erlid);
        String datefield = sdgTestData.GenerateTestSDGFieldDate(erlid);
        String booleanfield = sdgTestData.GenerateTestSDGFieldBoolean(erlid);
        String picklistfield = sdgTestData.GenerateTestSDGFieldPicklist(erlid);

        //Prep test catching values:
        Boolean errorThrown=false;
        String errorMsg = '';
        Test.startTest();

        //Generate a request:
        SDGRequest req = new SDGRequest();
        req.SDGTag = 'CustomObject:' + sdgTestData.TestSDGName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;


        //Now invoke normal list:
        SDGResult result = getresult(req);
        system.assertEquals(2, result.FullQueryCount,'Expected rowcount=2 from load');

        //create a filter for =:
        List<SDGFilter> Filters = new List<SDGFilter>();
        SDGFilter newfilter = new SDGFilter();
        newfilter.SDGFieldID = stringfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue=sdgNamespaceUtility.GetNamespace() + 'APIName__c';
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result2 = getResult(req);
        system.debug('Expected rowcount=1 from = filter' + result2.FullQueryCount);

        //Filter should now be cached - so try and do a normal load and count the results:
        String results3 = sdgController.GetSDGInitialLoad(testdata, 'CustomObject:' + sdgTestDAta.TestSDGName, '', '',10,'');

        SDGInitialLoad initial2 = (SDGInitialLoad)JSON.deserialize(results3, SDGInitialLoad.class);
        //system.debug(initial2.Results.query);
        //system.debug('Should be able to execute.' + initial2.Results.isError);

        Test.stopTest();

    }
    static testMethod void TestStringFilter()
    {
        //Generate test data:
        //one sdg, with two columns - name and [namespace]apiname
        String testdata=sdgTestData.GenerateTestSampleData();
        //String s2 = sdgTestData.GenerateTestSDGFieldString(testdata);
        //String n2 = sdgTestData.GenerateTestSDGFieldStringName(testdata);

        //and the filterer
        STring erlid = sdgTestData.GenerateTestSDG();
        String stringfield = sdgTestData.GenerateTestSDGFieldString(erlid);
        String namefield = sdgTestData.GenerateTestSDGFieldStringName(erlid);
        String datefield = sdgTestData.GenerateTestSDGFieldDate(erlid);
        String booleanfield = sdgTestData.GenerateTestSDGFieldBoolean(erlid);
        String picklistfield = sdgTestData.GenerateTestSDGFieldPicklist(erlid);

        //Prep test catching values:
        Boolean errorThrown=false;
        String errorMsg = '';
        Test.startTest();

        //Generate a request:
        SDGREquest req = new SDGREquest();
        req.SDGTag = 'CustomObject:' + sdgTestData.TestSDGName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;


        //Now invoke normal list:
        SDGResult result = getresult(req);
        System.debug('Load with no filter' + result.FullQueryCount);

        //create a filter for =:
        List<SDGFilter> Filters = new List<SDGFilter>();
        SDGFilter newfilter = new SDGFilter();
        newfilter.SDGFieldID = stringfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue='Name';
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result2 = getResult(req);
        System.debug('Query with = filter' + result2.FullQueryCount);

        //Invalid filter test
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = 'an invalid value';
        newfilter.FilterOperator='NOT=';
        newfilter.filtervalue='Banana';
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result31 = getresult(req);
        System.debug('Expected error with invalid filter field specified' + result31.isError);


        //NOT= test
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = stringfield;
        newfilter.FilterOperator='NOT=';
        newfilter.filtervalue='Banana';
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result32 = getresult(req);
        System.debug('not= filter' + result32.FullQueryCount);


        //STARTS test
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = stringfield; //apiname
        newfilter.FilterOperator='STARTS';
        newfilter.filtervalue='Na';
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result3 = getresult(req);
        system.debug('zzzzzzz');
        system.debug(result3.query);
        system.debug(result3.errormessage);
        System.debug('Starts with filter' + result3.FullQueryCount);

        //ENDS test
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = stringfield;
        newfilter.FilterOperator='ENDS';
        newfilter.filtervalue='ame';
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result35 = getresult(req);
        System.debug('Expected rowcount=1 from ends filter' + result35.FullQueryCount);

        //ENDS test #2
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = stringfield;
        newfilter.FilterOperator='ENDS';
        newfilter.filtervalue='__c';
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result36 = getresult(req);
        System.debug('Expected rowcount=1 from ends filter' + result36.FullQueryCount);


        //Contains
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = stringfield;
        newfilter.FilterOperator='CONTAINS';
        newfilter.filtervalue='ame'; //part of 'test'
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result4 = getresult(req);
        System.debug('Expected rowcount=1 from contains filter' + result4.FullQueryCount);

        //2nd test for contains
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = stringfield;
        newfilter.FilterOperator='CONTAINS';
        newfilter.filtervalue='APIN'; // not part of 'test'
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result5 = getresult(req);
        System.debug('Expected rowcount=1 from  contains filter' + result5.FullQueryCount);

        // test for NOT contains
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = stringfield;
        newfilter.FilterOperator='NOTCONTAINS';
        newfilter.filtervalue='elephant'; //  part of 'test'
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result6 = getresult(req);
        System.debug('Expected rowcount=2 from notcontains filter' + result6.FullQueryCount);

        // negative test for NOT contains
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = stringfield;
        newfilter.FilterOperator='NOTCONTAINS';
        newfilter.filtervalue='__c'; //  part of 'test'
        filters.clear();
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result7 = getresult(req);
        System.debug('Expected rowcount=1 from negative notcontains filter' + result7.FullQueryCount);


        Test.stopTest();
    }


    static testMethod void TestAllRows()
    {
        String testdata= sdgTestData.GenerateTestSampleData();

        String erlid = sdgTestData.GenerateTestSDG();
        String stringfield = sdgTestData.GenerateTestSDGFieldString(erlid);
        
        Test.startTest();

        //Generate a request:
        SDGREquest req = new SDGREquest();
        req.SDGTag = 'CustomObject:' + sdgTestData.TestSDGName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;

        //Now invoke normal list:
        SDGResult result = getresult(req);
        System.debug('Expected rowcount=2 from load' + result.FullQueryCount);

        //Now delete a row and try again:
        SDG_Field__c row1 = [select id from sdg_field__c where sdg__c = :testdata limit 1];
        delete row1;

        SDGResult result2 = getResult(req);
        System.debug('Expected rowcount=1 with deleted row' + result2.FullQueryCount);
        System.debug('Expected no error with deleted row' + result2.isError);

        //Now set All_Rows = true and try again
        sdg__c erl = [select id, All_rows__c from sdg__c where id = :erlid limit 1];
        erl.all_rows__c = true;
        update erl; 

        SDGResult result3 = getResult(req);
        System.debug('Expected rowcount=1 with deleted row' + result3.FullQueryCount);
        System.debug('Expected no error with deleted row' + result3.isError);
        
        Test.stopTest();
    }
    static testMethod void TestNumberFilter()
    {
        //Generate test data: an account and an opportunity:
        String testdata= sdgTestData.GenerateTestSampleData();

        STring erlid = sdgTestData.GenerateTestSDG();
        String stringfield = sdgTestData.GenerateTestSDGFieldString(erlid);
        String datefield = sdgTestData.GenerateTestSDGFieldDate(erlid);
        string numberfield = sdgTestData.GenerateTestSDGFieldNumber(erlid);
        String booleanfield = sdgTestData.GenerateTestSDGFieldBoolean(erlid);
        String picklistfield = sdgTestData.GenerateTestSDGFieldPicklist(erlid);


        Test.startTest();

        //Generate a request:
        SDGREquest req = new SDGREquest();
        req.SDGTag = 'CustomObject:' + sdgTestData.TestSDGName;
        req.ParentRecordID = testdata;
        req.pageid=1;
        req.pagesize=5;


        //Now invoke normal list:
        SDGResult result = getresult(req);
        System.debug('Expected rowcount=2 from load' + result.FullQueryCount);

        //create a filter for TRUE:
        List<SDGFilter> Filters = new List<SDGFilter>();
        SDGFilter newfilter = new SDGFilter();
        newfilter.SDGFieldID = numberfield;
        newfilter.FilterOperator='=';
        newfilter.filtervalue='5';
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result2 = getResult(req);
        System.debug('Expected rowcount=0 from fieldorder=number filter' + result2.FullQueryCount);
        System.debug('Expected no error with  fieldorder=number filter' + result2.isError);

        //create a filter for FALSE:
        filters.clear();
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = numberfield;
        newfilter.FilterOperator='GT';
        newfilter.filtervalue='1';
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result3 = getResult(req);
        System.debug('Expected rowcount=1 from is fieldorder>1 filter' + result3.FullQueryCount);
        System.debug('Expected no error with  fieldorder>1 filter' + result3.isError);


        filters.clear();
        newfilter = new SDGFilter();
        newfilter.SDGFieldID = numberfield;
        newfilter.FilterOperator='LT';
        newfilter.filtervalue='10';
        filters.add(newfilter);
        req.Filters = filters;

        SDGResult result4 = getResult(req);
        System.debug('Expected rowcount=2 from is fieldorder<10 filter' + result4.FullQueryCount);
        System.debug('Expected no error with  amount<10 filter' + result4.isError);


        Test.stopTest();
    }

    static SDGResult GetResult(SDGRequest req)
    {
        String results = sdgController.getSDGResult(JSON.serialize(req));
        SDGResult result = (SDGResult)JSON.deserialize(results, SDGResult.class);
        return result;

    }
    @isTest
    static void sdgQueryEngineTestMethod(){
    
        test.startTest();
        sdgQueryEngine.hack();
        test.stopTest();
    }
}