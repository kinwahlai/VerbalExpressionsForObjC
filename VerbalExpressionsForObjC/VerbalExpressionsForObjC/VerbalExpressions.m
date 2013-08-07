//
//  VerbalExpressions.m
//  VerbalExpressionsForObjC
//
//  Created by developer on 8/7/13.
//  Copyright (c) 2013 KinWah. All rights reserved.
//

#import "VerbalExpressions.h"

@implementation VerbalExpressions
extern VerbalExpressions * VerEx() {
    return [[VerbalExpressions alloc]init];
}

- (VerbalExpressions *(^)())something
{
    return ^(){
        return self;
    };
}
@end
