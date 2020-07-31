/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@isTest

public with sharing class sdgPreferencesTest {
    @isTest
    static void sdgPreferencesMethod(){
    
        test.startTest();
        sdgPreferences.hack();
        test.stopTest();
    }
}