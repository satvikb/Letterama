//
//  DigitButton.h
//  Letterama
//
//  Created by Satvik Borra on 9/11/17.
//  Copyright © 2017 satvik borra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Functions.h"
typedef void (^ButtonPressDown)(int digitId, int currentDigit);

@interface DigitButton : UIView

@property (nonatomic, copy) ButtonPressDown block;
@property (nonatomic, assign) int digitId;
@property (nonatomic, assign) int currentDigit;
@property (nonatomic, strong) UILabel* textLabel;

-(id)initWithFrame:(CGRect)frame digitId:(int)digitId currentDigit:(int)currentDigit withBlock:(ButtonPressDown)pressDown;

@end
