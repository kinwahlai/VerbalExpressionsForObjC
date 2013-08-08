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

#pragma mark - Expressions
- (VerbalExpressions *(^)())something
{
    return ^(){
        return [self add:@"(?:.+)"];
    };
}

- (VerbalExpressions *(^)(NSString*))somethingBut
{
    return ^(NSString* value){
        return [self add:[NSString stringWithFormat:@"(?:[^%@]+)", value]];
    };
}

-(VerbalExpressions *(^)(BOOL))startOfLine
{
    return ^(BOOL enable){
        _prefixes = enable ? @"^" :@"";
        return self;
    };
}

-(VerbalExpressions *(^)(BOOL))endOfLine
{
    return ^(BOOL enable){
        _suffixes = enable ? @"$" :@"";
        return self;
    };
}

-(VerbalExpressions *(^)())anything
{
    return ^(){
        return [self add:@"(?:.*)"];
    };
}

-(VerbalExpressions *(^)(NSString *))anythingBut
{
    return ^(NSString* value){
        return [self add:[NSString stringWithFormat:@"(?:[^%@]*)", value]];
    };
}

-(VerbalExpressions *(^)(NSString *))then
{
    return ^(NSString* value){
        return [self add:[NSString stringWithFormat:@"(?:%@)", value]];
    };
}

-(VerbalExpressions *(^)(NSString * value))find
{
    return ^(NSString* value){
        return self.then(value);
    };
}

-(VerbalExpressions *(^)(NSString *))maybe
{
    return ^(NSString* value){
        return [self add:[NSString stringWithFormat:@"(?:%@)?", value]];
    };
}

-(VerbalExpressions *(^)(NSString *))anyOf
{
    return ^(NSString* value){
        return [self add:[NSString stringWithFormat:@"[%@]", value]];
    };
}

-(VerbalExpressions *(^)(NSString *))any
{
    return ^(NSString* value){
        return self.anyOf(value);
    };
}

-(VerbalExpressions *(^)(NSString *))OR
{
    return ^(NSString* value){
        _prefixes = [_prefixes stringByAppendingString:@"(?:"];
        [self add:@")|(?:"];
        
        if (value) {
            self.then(value);
        }
        [self add:@")"];
        return self;
    };
}

-(VerbalExpressions *(^)())lineBreak
{
    return ^(){
        return [self add:@"(?:(?:\\n)|(?:\\r\\n))"];
    };
}

-(VerbalExpressions *(^)())br
{
    return ^(){
        return self.lineBreak();
    };
}

-(VerbalExpressions *(^)())tab
{
    return ^(){
        return [self add:@"\\t"];
    };
}

-(VerbalExpressions *(^)())word
{
    return ^(){
        return [self add:@"\\w+"];
    };
}

-(VerbalExpressions *(^)(BOOL enable))withAnyCase
{
    return ^(BOOL enable){
        if (enable) {
            return [self addModifier:NSRegularExpressionCaseInsensitive];
        }
        else {
            return [self removeModifier:NSRegularExpressionCaseInsensitive];
        }
    };
}

#pragma mark - Public methods
-(BOOL)test:(NSString *)toTest
{
    NSArray *result = [self.regex matchesInString:toTest options:0 range:NSMakeRange(0, toTest.length)];
    return (result.count);
}

- (NSString *)getRegexString{
    return [NSString stringWithFormat:@"%@%@%@",_prefixes,_source,_suffixes];
}

#pragma mark - Private methods
- (VerbalExpressions *)add:(NSString *)value
{
    _source = (value)?[_source stringByAppendingString:value]:_source;
    return self;
}

- (NSRegularExpression *)regex{
    if (!_regex || (_regex && ![_regex.pattern isEqualToString:self.getRegexString])) {
        // create new regex object
        NSError *outError;
        _regex = [[NSRegularExpression alloc] initWithPattern:self.getRegexString options:_regexOptions error:&outError];
        if (outError) {
            NSLog(@"outError = %@",outError);
        }
    }
    return _regex;
}

- (id)addModifier:(NSRegularExpressionOptions)regularExpressionOptions {
    _regexOptions |= regularExpressionOptions;
    return self;
}

- (id)removeModifier:(NSRegularExpressionOptions)regularExpressionOptions {
    _regexOptions &= ~regularExpressionOptions;
    return self;
}
@end
