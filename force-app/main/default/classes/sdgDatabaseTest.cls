/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@isTest

public with sharing class sdgDatabaseTest {
    @isTest
    static void sdgDatabaseMethod(){
    
        test.startTest();
        sdgDatabase.hack();
        test.stopTest();
    }
}