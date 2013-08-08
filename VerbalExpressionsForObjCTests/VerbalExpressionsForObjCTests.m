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
    VerbalExpressions *verex = VerEx().endOfLine().something();
    XCTAssertTrue([[verex getRegexString] isEqualToString:@"(?:.+)$"], @"regex string should ends with $");
}

-(void)testAnything
{
    NSString *testString = @"what";
    VerbalExpressions *verex = VerEx().startOfLine().anything();
    XCTAssertTrue([verex test:testString], @"should return YES as regex match anything");
}

-(void)testAnythingBut
{
    // Kin Wah: Dont really understand how to use somethingBut and anythingBut
    NSString *testString = @"what";
    VerbalExpressions *verex = VerEx().startOfLine().anythingBut(@"w");
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
    VerbalExpressions *verex = VerEx().startOfLine().then(@"a").maybe(@"b");
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
    VerbalExpressions *verex = VerEx().startOfLine().then(@"a").anyOf(@"xyz");
    XCTAssertTrue([verex test:testString], @"doesnt have an x, y, or z after a");
    testString = @"abc";
    XCTAssertFalse([verex test:testString], @"has an x, y, or z after a");
}

- (void) testOr
{
    NSString *testString = @"defzzz";
    VerbalExpressions *verex = VerEx().startOfLine().then(@"abc").OR(@"def").something().endOfLine();
    XCTAssertTrue([verex test:testString], @"doesnt starts with abc or def");
    
    testString = @"xyzabc";
    XCTAssertFalse([verex test:testString], @"starts with abc or def");
}

- (void) testLineBreak
{
    NSString *testString = @"abc\r\ndef";
    VerbalExpressions *verex = VerEx().startOfLine().then(@"abc").lineBreak().then(@"def");
    XCTAssertTrue([verex test:testString], @"doesnt have linebreak between abc and def");
    
    NSString *testString2 = @"pqr\nsty";
    VerbalExpressions *verex2 = VerEx().startOfLine().then(@"pqr").br().then(@"sty");
    XCTAssertTrue([verex2 test:testString2], @"doesnt have linebreak between pqr and sty");
    
    testString = @"abc\r\n def";
    XCTAssertFalse([verex test:testString], @"space after linebreak");
}

- (void) testTab
{
    NSString *testString = @"\tabc";
    VerbalExpressions *verex = VerEx().tab().then(@"abc");
    XCTAssertTrue([verex test:testString], @"doesnt have tab");
}

- (void) testWithAnyCase
{
    NSString *testString = @"A";
    VerbalExpressions *verex = VerEx().then(@"a");
    XCTAssertFalse([verex test:testString], @"case sensitive doesnt match");
    
    VerbalExpressions *verex2 = VerEx().then(@"a").withAnyCase(YES);
    XCTAssertTrue([verex2 test:testString], @"case insensitive should match");
}

- (void) testSearchOnLine
{
    NSString *testString = @"a\nb";
    VerbalExpressions *verex = VerEx().startOfLine().then(@"a").br().then(@"b").endOfLine();
    XCTAssertTrue([verex test:testString], @"b is not on the second line");
    VerbalExpressions *verex2 = VerEx().searchOneLine(YES).startOfLine().then(@"a").br().then(@"b").endOfLine();
    XCTAssertTrue([verex2 test:testString], @"b is on the second line but we are only searching the first");
}

- (void) testReplace
{
    NSString *testString = @"http://www.google.com";
    
    NSString *result = VerEx().find(@"google").replace(testString,@"yahoo");
    
    XCTAssertTrue([result isEqualToString:@"http://www.yahoo.com"], @"cannot find the text to replace");
}

- (void) testRange
{
    NSString *testString = @"ahd";
    VerbalExpressions *verex = VerEx().something().range(@[@"a",@"i"]);
    XCTAssertTrue([verex test:testString], @"not within range");
    
    XCTAssertThrows(VerEx().something().range(@[]), @"expecting an exception");
}

- (void) testMultiple
{
    NSString *testString = @"baac";
    VerbalExpressions *verex = VerEx().startOfLine().then(@"b").multiple(@"a").then(@"c").endOfLine();
    XCTAssertTrue([verex test:testString], @"doesnt match");
}

- (void) testCapture {
    NSString *testString = @"http://www.google.com";
    
    VerbalExpressions *verex = VerEx()
    .searchOneLine(YES)
    .beginCapture()
    .find(@"google")
    .endCapture();
    
    NSArray *matches = [verex capture:testString];
    XCTAssert(matches.count == 1, @"no result or multiple result");
    for (NSTextCheckingResult *match in matches)
    {
        NSRange matchRange = match.range;
        NSString *captured = [testString substringWithRange:matchRange];
        XCTAssert([captured isEqualToString:@"google"], @"");
    }
}

- (void) testValidEmail {
    VerbalExpressions *verex = VerEx()
    .searchOneLine(YES)
    .startOfLine()
    .something()
    .then(@"@")
    .something()
    .then(@".")
    .then(@"co")
    .maybe(@"com");
    XCTAssertTrue([verex test:@"kinwah.lai@gmail.com"], @"not a valid email");
    XCTAssertTrue([verex test:@"appleseed@yahoo.co.uk"], @"not a valid email");
}

- (void) testHTTPURL {
    VerbalExpressions *verex = VerEx()
    .searchOneLine(YES)
    .startOfLine()
    .then( @"http" )
    .maybe( @"s" )
    .then( @"://" )
    .maybe( @"www." )
    .anythingBut( @" " )
    .endOfLine();
    XCTAssertTrue([verex test:@"https://mail.google.com"], @"not a valid url");
    XCTAssertTrue([verex test:@"http://google.com"], @"not a valid url");
    XCTAssertTrue([verex test:@"http://www.google.com"], @"not a valid url");
}
@end
