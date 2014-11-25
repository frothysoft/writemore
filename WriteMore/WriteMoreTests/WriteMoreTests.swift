//
//  WriteMoreTests.swift
//  WriteMoreTests
//
//  Created by Josh Berlin on 11/8/14.
//  Copyright (c) 2014 FrothySoft. All rights reserved.
//

import Cocoa
import XCTest

class WriteMoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}

// TODO 0: Write database tests using an in memory core data store.
/*
NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"SomeClass")];
NSString* path = [bundle pathForResource:@"WriteMore" ofType:@"momd"];
NSURL *modURL = [NSURL URLWithString:path];
NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
NSPersistentStoreCoordinator *coord = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: model];
NSPersistentStore *store = [coord addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
testingContext = [[NSManagedObjectContext alloc] init];
[testingContext setPersistentStoreCoordinator: coord];
*/

/*
http://augustl.com/blog/2011/unit_testing_ios_core_data_versioned_or_multiple_models/
*/