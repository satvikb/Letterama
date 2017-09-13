//
//  DigitButton.m
//  Letterama
//
//  Created by Satvik Borra on 9/11/17.
//  Copyright © 2017 satvik borra. All rights reserved.
//

#import "DigitButton.h"
#import "Storage.h"

@implementation DigitButton
@synthesize block;
@synthesize digitId;
@synthesize textLabel;
@synthesize currentDigit;

-(id)initWithFrame:(CGRect)frame digitId:(int)dId currentDigit:(int)curDigit withBlock:(ButtonPressDown)pressDown{
    self = [super initWithFrame:frame];
    
    self.block = pressDown;
    self.digitId = dId;
    self.currentDigit = curDigit;
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(0, 0, frame.size.width, frame.size.height))];
    self.textLabel.text = [NSString stringWithFormat:@"%i", dId];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:50]];
    self.textLabel.adjustsFontSizeToFitWidth = true;
    [self addSubview:self.textLabel];
    
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    block(self.digitId, self.currentDigit);
}

@end
