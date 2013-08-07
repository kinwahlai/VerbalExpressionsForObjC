//
//  VerbalExpressionsForObjCTests.m
//  VerbalExpressionsForObjCTests
//
//  Created by developer on 8/7/13.
//  Copyright (c) 2013 KinWah. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VerbalExpressions.h"

@interface VerbalExpressionsForObjCTests : XCTestCase

@end

@implementation VerbalExpressionsForObjCTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testReturnAValidInstance
{
    VerbalExpressions *verex = VerEx();
    XCTAssertNotNil(verex, @"should return a valid instance");
}

- (void)testSomething
{
    NSString *testString = @"";
    VerbalExpressions *verex = VerEx().something();
    XCTAssertFalse([verex test:testString], @"should return NO");
    
    NSString *testString2 = @"a";
    XCTAssertTrue([verex test:testString2], @"should return YES as regex match something");
}

- (void)testSomethingBut
{
    NSString *testString = @"b";
    
    VerbalExpressions *verex = VerEx().somethingBut(@"a");
    
    XCTAssertTrue([verex test:testString], @"doesnt start with a");

    testString = @"a";
    XCTAssertFalse([verex test:testString], @"starts with a");
}

-(void)testStartOfLine
{
    VerbalExpressions *verex = VerEx().startOfLine(YES).something();
    XCTAssertTrue([[verex getRegexString] isEqualToString:@"^(?:.+)"], @"regex string should starts with ^");
}

-(void)testEndOfLine
{
    VerbalExpressions *verex = VerEx().endOfLine(YES).something();
    XCTAssertTrue([[verex getRegexString] isEqualToString:@"(?:.+)$"], @"regex string should ends with $");
}

-(void)testAnything
{
    NSString *testString = @"what";
    VerbalExpressions *verex = VerEx().startOfLine(YES).anything();
    XCTAssertTrue([verex test:testString], @"should return YES as regex match anything");
}

-(void)testAnythingBut
{
    // Kin Wah: Dont really understand how to use somethingBut and anythingBut
    NSString *testString = @"what";
    VerbalExpressions *verex = VerEx().startOfLine(YES).anythingBut(@"w");
    XCTAssertTrue([verex test:testString], @"not starts with w");
}

-(void)testThen
{
    NSString *testString = @"ba";
    VerbalExpressions *verex = VerEx().then(@"b").then(@"a");
    XCTAssertTrue([verex test:testString], @"not starts with b then a");
}

- (void) testMaybe {
    NSString *testString = @"acb";
    VerbalExpressions *verex = VerEx().startOfLine(YES).then(@"a").maybe(@"b");
    XCTAssertTrue([verex test:testString], "no maybe has a b after an a");
    testString = @"abc";
    XCTAssertTrue([verex test:testString], "no maybe has a b after an a");
}

- (void) testFind
{
    NSString *testString = @"http://www.google.com";
    VerbalExpressions *verex = VerEx().find(@"google");
    XCTAssertTrue([verex test:testString], @"google not found");
}

- (void) testAnyOf
{
    NSString *testString = @"ay";
    VerbalExpressions *verex = VerEx().startOfLine(YES).then(@"a").anyOf(@"xyz");
    XCTAssertTrue([verex test:testString], @"doesnt have an x, y, or z after a");
    testString = @"abc";
    XCTAssertFalse([verex test:testString], @"has an x, y, or z after a");
}

- (void) testOr
{
    NSString *testString = @"defzzz";
    VerbalExpressions *verex = VerEx().startOfLine(YES).then(@"abc").OR(@"def").something().endOfLine(YES);
    XCTAssertTrue([verex test:testString], @"doesnt starts with abc or def");
    
    testString = @"xyzabc";
    XCTAssertFalse([verex test:testString], @"starts with abc or def");
}


@end
