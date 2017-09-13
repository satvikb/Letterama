//
//  Functions.m
//  Letterama
//
//  Created by Satvik Borra on 9/11/17.
//  Copyright © 2017 satvik borra. All rights reserved.
//

#import "Functions.h"

@implementation Functions

+(CGFloat) fontSize:(CGFloat)fontSize{
    return fontSize*(UIScreen.mainScreen.bounds.size.width/DEFAULT_WIDTH);
}

+ (int)randomNumberBetween:(int)min maxNumber:(int)max {
    return arc4random_uniform(max - min + 1) + min;
}

@end
