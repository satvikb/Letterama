//
//  Functions.m
//  Letterama
//
//  Created by Satvik Borra on 9/11/17.
//  Copyright © 2017 satvik borra. All rights reserved.
//

#import "Functions.h"
#define DEFAULT_WIDTH 375

@implementation Functions


+(CGFloat) fontSize:(CGFloat)fontSize{
    return fontSize*(UIScreen.mainScreen.bounds.size.width/DEFAULT_WIDTH);
}

@end
