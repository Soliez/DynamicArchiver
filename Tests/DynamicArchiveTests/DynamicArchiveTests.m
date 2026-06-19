//
//  DynamicArchiveTests.m
//  DynamicArchiveTests
//
//  Created by Erik Solis  on 2026-06-18.
//

#import <XCTest/XCTest.h>

#import "TestClasses/TestPerson.h"
#import "TestClasses/TestPrimitivesObject.h"

#import "DynamicArchiver.h"
#import "DynamicArchiveContainer.h"
#import "IOHelper.h"



@interface DynamicArchiveTests : XCTestCase
- (void)testTestPerson;
- (void)testTestPrimitivesObject;
@end


@implementation DynamicArchiveTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    // XCTest Documentation
    // https://developer.apple.com/documentation/xctest
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testTestPerson {
    TestPerson *person = [[TestPerson alloc] initWithName:@"Fyodor Dostoevsky" Age:@59];
    NSError *error = nil;
    NSData *data = [DynamicArchiver dumpObjectToArchiveData:person error:&error];
    XCTAssertNotNil(data, @"Failed to archive person: %@", error.localizedDescription);

    id restoredObj = [DynamicArchiver loadObjectFromArchiveData:data error:&error];
    XCTAssertNotNil(restoredObj, @"Failed to unarchive person: %@", error.localizedDescription);
    XCTAssertTrue([restoredObj isKindOfClass:[TestPerson class]], @"Unarchived object is not TestPerson");

    TestPerson *restoredPerson = (TestPerson *)restoredObj;
    XCTAssertEqualObjects(restoredPerson->_name, person->_name, @"Name property did not round-trip");
    XCTAssertEqualObjects(restoredPerson->_age, person->_age, @"Age property did not round-trip");
}

/**
 Test round-trip archiving for TestPrimitivesObject
 */
- (void)testTestPrimitivesObject {
    TestPrimitivesObject *obj = [[TestPrimitivesObject alloc] initWithVariables_intValue:1 integerValue:2 unsignedIntegerValue:3 doubleValue:4 floatValue:5 booleanValue:YES charValue:'q' storedClass:[NSString class] storedMethodSelector:NSSelectorFromString(@"stringWithFormat:") stringValue:@"hello world"];
    NSError *error = nil;
    NSData *data = [DynamicArchiver dumpObjectToArchiveData:obj error:&error];
    XCTAssertNotNil(data, @"Failed to archive primitives object: %@", error.localizedDescription);

    id restoredObj = [DynamicArchiver loadObjectFromArchiveData:data error:&error];
    XCTAssertNotNil(restoredObj, @"Failed to unarchive primitives object: %@", error.localizedDescription);
    XCTAssertTrue([restoredObj isKindOfClass:[TestPrimitivesObject class]], @"Unarchived object is not TestPrimitivesObject");

    TestPrimitivesObject *restored = (TestPrimitivesObject *)restoredObj;
    XCTAssertEqual(restored->_intValue, obj->_intValue);
    XCTAssertEqual(restored->_integerValue, obj->_integerValue);
    XCTAssertEqual(restored->_unsignedIntegerValue, obj->_unsignedIntegerValue);
    XCTAssertEqual(restored->_doubleValue, obj->_doubleValue);
    XCTAssertEqual(restored->_floatValue, obj->_floatValue);
    XCTAssertEqual(restored->_booleanValue, obj->_booleanValue);
    XCTAssertEqual(restored->_charValue, obj->_charValue);
    XCTAssertEqual(restored->_storedClass, obj->_storedClass);
    XCTAssertEqual(restored->_storedMethodSelector, obj->_storedMethodSelector);
    XCTAssertEqualObjects(restored->_stringValue, obj->_stringValue);
}


@end
