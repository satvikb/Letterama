//
//  SettingsView.m
//  Letterama
//
//  Created by Satvik Borra on 9/11/17.
//  Copyright © 2017 satvik borra. All rights reserved.
//

#import "SettingsView.h"

#define NUMBER_OF_FONTS (3)
#define MAX_BORDER_WIDTH (7)

@implementation SettingsView {
    UILabel* mainLabel;
    UILabel* scoreLabel;
    
    Button* backButton;
    Button* fontButton;
    Button* borderButton;

    int currentFont;
    int currentBorder;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    currentFont = [Storage getCurrentFont];
    currentBorder = [Storage getCurrentBorderWidth];
    
    backButton = [[Button alloc] initWithFrame:[self propToRect:CGRectMake(0.7, 0.05, 0.25, 0.075)] withBlock:^{
        [self.delegate switchFrom:Settings to:Menu];
    } text:@"back"];
    backButton.layer.borderWidth = [Storage getCurrentBorderWidth];
    [self addSubview:backButton];
    
    mainLabel = [[UILabel alloc] initWithFrame:[self propToRect:CGRectMake(0.05, 0.15, 0.9, 0.2)]];
    mainLabel.textAlignment = NSTextAlignmentCenter;
    mainLabel.text = @"settings";
    mainLabel.layer.borderWidth = [Storage getCurrentBorderWidth];
    mainLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:40]];
    [self addSubview:mainLabel];
    
    
    fontButton = [[Button alloc] initWithFrame:[self propToRect:CGRectMake(0.05, 0.5, 0.9, 0.1)] withBlock:^{
        [self changeFont];
    } text:@"font 0"];
    fontButton.textLabel.text = [NSString stringWithFormat:@"font %i", currentFont];
    fontButton.layer.borderWidth = [Storage getCurrentBorderWidth];
    [self addSubview:fontButton];
    
    borderButton = [[Button alloc] initWithFrame:[self propToRect:CGRectMake(0.05, 0.65, 0.9, 0.1)] withBlock:^{
        [self changeBorder];
    } text:@""];
    borderButton.textLabel.text = [NSString stringWithFormat:@"border %i", currentBorder];
    borderButton.layer.borderWidth = [Storage getCurrentBorderWidth];
    [self addSubview:borderButton];
    
    self.tag = 1;
    
    return self;
}

-(void)changeFont{
    currentFont = (currentFont+1)%NUMBER_OF_FONTS;
    fontButton.textLabel.text = [NSString stringWithFormat:@"font %i", currentFont];
    
    [Storage setCurrentFont:currentFont];
    
    [self.delegate switchAllFontsTo:[Storage getFontNameFromNumber:currentFont]];
}

-(void)changeBorder {
    currentBorder = (currentBorder+1)%MAX_BORDER_WIDTH;
    borderButton.textLabel.text = [NSString stringWithFormat:@"border %i", currentBorder];
    
    [Storage setBorderWidth:currentBorder];
    
    [self.delegate switchAllBorderWidthTo:currentBorder];
}

- (CGRect) propToRect: (CGRect)prop {
    CGRect viewSize = self.frame;
    CGRect real = CGRectMake(prop.origin.x*viewSize.size.width, prop.origin.y*viewSize.size.height, prop.size.width*viewSize.size.width, prop.size.height*viewSize.size.height);
    return real;
}
@end
