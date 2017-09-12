//
//  Settings.m
//  Letterama
//
//  Created by Satvik Borra on 9/11/17.
//  Copyright © 2017 satvik borra. All rights reserved.
//

#import "Storage.h"
#import "Lockbox.h"

@implementation Storage

static NSString* const fontId = @"font";
static NSString* const borderId = @"border";
static NSString* const tutorialId = @"tutorial";

+(bool)saveHighScore:(int)score{
    //    NSInteger* s = [NSInteger numberWithInt:score];
    int currentHighScore = [self getSavedHighScore];
    if(currentHighScore < score){
        NSNumber* s = [NSNumber numberWithInt:score];
        [Lockbox archiveObject:s forKey:@"highscore"];
        return true;
    }
    return false;
}

+(int)getSavedHighScore {
    NSNumber* currentHighScore = [Lockbox unarchiveObjectForKey:@"highscore"];
    if(currentHighScore == nil){
        return 0;
    }
    return currentHighScore.intValue;
}

+(int)getCurrentFont {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
  
    return (int)[defaults integerForKey:fontId];
}

+(void)setCurrentFont:(int)font{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:font forKey:fontId];
}

+(int)getCurrentBorderWidth {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    return (int)[defaults integerForKey:borderId];
}

+(void)setBorderWidth:(int)width{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:width > 7 ? 7 : width < 0 ? 0 : width forKey:borderId];
}

+(bool)getDidCompleteTutorial {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults boolForKey:tutorialId];
}

+(void)setDidCompleteTutorial{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:true forKey:tutorialId];
}

+(NSString*)getFontNameFromNumber:(int)number{
    switch (number) {
        case 0:
            return @"Pixel_3";
        case 1:
            return @"Helvetica";
        case 2:
            return @"Ariel";
        default:
            return @"Pixel_3";
            break;
    }
}

@end
