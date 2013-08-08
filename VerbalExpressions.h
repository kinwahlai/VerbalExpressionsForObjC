//
//  VerbalExpressions.h
//  VerbalExpressionsForObjC
//
//  Created by developer on 8/7/13.
//  Copyright (c) 2013 KinWah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerbalExpressions : NSObject
@property (strong, nonatomic, readonly) NSRegularExpression *regex;
@property (nonatomic, readonly) NSRegularExpressionOptions regexOptions;

extern VerbalExpressions * VerEx();

- (BOOL)test:(NSString*)toTest;
- (NSString *)getRegexString;

@property (readonly) VerbalExpressions *(^something)();
@property (readonly) VerbalExpressions *(^somethingBut)(NSString* value);
// TODO : How to have another startOfLine() without parameter?
@property (readonly) VerbalExpressions *(^startOfLine)(BOOL enable);
@property (readonly) VerbalExpressions *(^endOfLine)(BOOL enable);
@property (readonly) VerbalExpressions *(^anything)();
@property (readonly) VerbalExpressions *(^anythingBut)(NSString* value);
@property (readonly) VerbalExpressions *(^then)(NSString* value);
@property (readonly) VerbalExpressions *(^find)(NSString* value);
@property (readonly) VerbalExpressions *(^maybe)(NSString* value);
@property (readonly) VerbalExpressions *(^any)(NSString* value);
@property (readonly) VerbalExpressions *(^anyOf)(NSString* value);
// `or` is a Obj C keyword so we use `OR` instead.
@property (readonly) VerbalExpressions *(^OR)(NSString* value);
@property (readonly) VerbalExpressions *(^lineBreak)();
@property (readonly) VerbalExpressions *(^br)();
@property (readonly) VerbalExpressions *(^tab)();
@property (readonly) VerbalExpressions *(^word)();
@property (readonly) VerbalExpressions *(^withAnyCase)(BOOL enable);
@property (readonly) VerbalExpressions *(^searchOneLine)(BOOL enable);
@property (readonly) NSString *(^replace)(NSString *source, NSString *value);
@property (readonly) VerbalExpressions *(^range)(NSArray *args);
@end

/*
 TODO: 
 sanitize ?? dunno how

 range
 stopatfirst
 multiple
 begincapture & endcapture
 */
