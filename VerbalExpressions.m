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
VerbalExpressions * VerEx() {
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

-(VerbalExpressions *(^)())startOfLine
{
    return ^(){
        _prefixes = @"^";
        return self;
    };
}

-(VerbalExpressions *(^)())endOfLine
{
    return ^(){
        _suffixes = @"$";
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

-(VerbalExpressions *(^)(BOOL))withAnyCase
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

-(VerbalExpressions *(^)(BOOL))searchOneLine
{
    // TODO: verify if this is correct
    return ^(BOOL enable){
        if (enable) {
            return [self removeModifier:NSRegularExpressionDotMatchesLineSeparators];
        }
        else {
            return [self addModifier:NSRegularExpressionDotMatchesLineSeparators];
        }
    };
}

-(NSString *(^)(NSString *, NSString *))replace
{
    return ^(NSString * source, NSString * value){
        return [self.regex stringByReplacingMatchesInString:source options:0 range:NSMakeRange(0, [source length]) withTemplate:value];
    };
}

-(VerbalExpressions *(^)(NSArray *))range
{
    return ^(NSArray *args){
        if(!args || args.count == 0  || args.count % 2 == 1)
        {
            [NSException raise:@"Invalid range" format:@"range needs one or more pairs of arguments to work."];
        }
        
        NSString *value = @"[";
        
        for(int _from = 0; _from < args.count; _from += 2) {
            int _to = _from+1;
            if(args.count <= _to) break;
            
            NSString *from = args[_from];
            NSString *to = args[_to];
            
            value = [NSString stringWithFormat:@"%@%@-%@", value, from, to];
        }
        
        value = [value stringByAppendingString:@"]"];
        
        return [self add:value];
    };
}

-(VerbalExpressions *(^)(NSString *))multiple
{
    return ^(NSString *value){
        NSString *safeValue = value;
        NSString *lastStr = [safeValue substringFromIndex:safeValue.length-1];
        if (![lastStr isEqualToString:@"+"] && ![lastStr isEqualToString:@"*"]) {
            safeValue = [safeValue stringByAppendingString:@"+"];
        }
        return [self add:safeValue];
    };
}

-(VerbalExpressions *(^)())beginCapture
{
    return ^(){
        _suffixes = [_suffixes stringByAppendingFormat:@")"];
        return [self add:@"("];
    };
}

-(VerbalExpressions *(^)())endCapture
{
    return ^(){
        _suffixes = [_suffixes substringWithRange:NSMakeRange(0, _suffixes.length-1)];
        return [self add:@")"];
    };
}

#pragma mark - Public methods
-(NSArray *)capture:(NSString *)toTest
{
   return [self.regex matchesInString:toTest options:0 range:NSMakeRange(0, toTest.length)];
}

-(BOOL)test:(NSString *)toTest
{
    return ([self capture:toTest].count);
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
