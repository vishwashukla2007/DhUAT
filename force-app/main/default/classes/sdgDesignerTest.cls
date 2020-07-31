/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@isTest
public class sdgDesignerTest {
    static testmethod void GetSObjectFieldsTest()
    {
        test.startTest();

        List<AuraFieldSelectOption> results = sdgDesigner.GetSObjectFields('Account', '');
        System.debug('Expecting multiple fields' + results.size());

        test.stopTest();
    }

    static testmethod void GetNamespaceTest()
    {
        test.startTest();

        string results = sdgDesigner.GetNamespace();
        System.debug('Expecting namespace' + results);

        test.stopTest();
    }
    static testmethod void GetNewFieldOrderTest()
    {
        Id sdgid = sdgTestData.GenerateTestSampleData();
        test.startTest();
        integer result = sdgDesigner.GetNewFieldOrder(sdgid);
        System.debug('Expecting new field order' + result);
        sdgTestData.GenerateTestSDGFieldString(sdgid, 'name', 5);
        integer result2 = sdgDesigner.GetNewFieldOrder(sdgid);
        System.debug('Expecting new field order - 5+1' + result2);
        test.stopTest();

    }

    static testmethod void GetSObjectFieldsIDTest()
    {
        Id recordId = sdgTestData.GenerateTestSDG();
        test.startTest();

        List<AuraFieldSelectOption> sdgresults = sdgDesigner.GetSObjectFields('SDG__c', '');
        //system.debug(sdgresults.size());
        List<AuraFieldSelectOption> fieldresults = sdgDesigner.GetSObjectFields('SDG_Field__c', '');
        //system.debug(fieldresults.size());
        List<AuraFieldSelectOption> sdgbyIDresults = sdgDesigner.GetSObjectFields('', recordId);
        //system.debug(sdgbyIDresults.size());
        System.debug('Expecting multiple fields');
        System.debug( 'Expecting multiple sObjectTypes');

        //test data has a sObjectName of sdg_field__c
        System.debug('Expecting same data from both object name and id');

        test.stopTest();
    }

}