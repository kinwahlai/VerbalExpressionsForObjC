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
    VerbalExpressions *verex = VerEx().something();
    XCTAssertNotNil(verex, @"should return a valid instance");
}
@end
