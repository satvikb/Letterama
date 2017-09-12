//
//  Functions.h
//  Letterama
//
//  Created by Satvik Borra on 9/11/17.
//  Copyright © 2017 satvik borra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Functions : NSObject

typedef enum AppState {
    Menu = 0,
    Game,
    GameOver,
    Settings,
    GamecenterLeaderboard
} AppState;

+(CGFloat) fontSize:(CGFloat)fontSize;

@end
