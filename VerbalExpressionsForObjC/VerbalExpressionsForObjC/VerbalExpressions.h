//
//  VerbalExpressions.h
//  VerbalExpressionsForObjC
//
//  Created by developer on 8/7/13.
//  Copyright (c) 2013 KinWah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerbalExpressions : NSObject
extern VerbalExpressions * VerEx();
- (VerbalExpressions *(^)())something;
@end
