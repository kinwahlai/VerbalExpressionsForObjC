//
//  VerbalExpressions.m
//  VerbalExpressionsForObjC
//
//  This is a ported version of VerbalExpressions JavaScript Library
//  https://github.com/jehna/VerbalExpressions
//
//  Created by developer on 8/7/13.
//  Copyright (c) 2013 KinWah. All rights reserved.
//

#import "VerbalExpressions.h"

@interface VerbalExpressions ()
{
@private
    NSString *_prefixes;
    NSString *_source;
    NSString *_suffixes;
    NSRegularExpression *_regex;
}
- (id)add:(NSString *)value;
@end

@implementation VerbalExpressions
extern VerbalExpressions * VerEx() {
    return [[VerbalExpressions alloc]init];
}

- (id)init {
    if ((self=[super init])) {
        _prefixes = @"";
        _source = @"";
        _suffixes = @"";
        _regex = nil;
    }
    return self;
}

- (VerbalExpressions *(^)())something
{
    return ^(){
        return [self add:@"(?:.+)"];
    };
}

-(BOOL)test:(NSString *)toTest
{
    NSArray *result = [self.regex matchesInString:toTest options:0 range:NSMakeRange(0, toTest.length)];
    return (result.count);
}

- (VerbalExpressions *)add:(NSString *)value
{
    _source = (value)?[_source stringByAppendingString:value]:_source;
    return self;
}

- (NSRegularExpression *)regex{
    if (!_regex || (_regex && ![_regex.pattern isEqualToString:self.getRegexString])) {
        // create new regex object
        NSError *outError;
        _regex = [[NSRegularExpression alloc] initWithPattern:self.getRegexString options:0 error:&outError];
        if (outError) {
            NSLog(@"outError = %@",outError);
        }
    }
    return _regex;
}

- (NSString *)getRegexString{
    return [NSString stringWithFormat:@"%@%@%@",_prefixes,_source,_suffixes];
}
@end
