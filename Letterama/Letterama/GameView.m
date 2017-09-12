//
//  GameView.m
//  Letterama
//
//  Created by Satvik Borra on 9/11/17.
//  Copyright © 2017 satvik borra. All rights reserved.
//

#import "GameView.h"
#import "Storage.h"

@implementation GameView {
    NSArray *words;
    UILabel* scoreLabel;
    UILabel* mainWordLabel;
    NSString* currentWord;
    
    CADisplayLink* gameTimer;
    CGFloat timePerWord;
    CGFloat currentTimer;
    
    UIView* timerBar;
    
}

@synthesize score;
@synthesize newHighScore;

-(instancetype)initWithFrame:(CGRect)frame andWords:(NSArray*)_words{
    self = [super initWithFrame:frame];
    
    score = 0;
    newHighScore = false;
 
    timePerWord = 3;
    currentWord = 0;
    words = _words;
    [self createAllDigitButtons];
    
    scoreLabel = [[UILabel alloc] initWithFrame:[self propToRect:CGRectMake(0.05, 0.05, 0.9, 0.1)]];
//    scoreLabel.layer.borderWidth = 1;
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:30]];
    scoreLabel.adjustsFontSizeToFitWidth = true;
    scoreLabel.text = @"0";
    scoreLabel.tag = 1;
    [self addSubview:scoreLabel];
    
    mainWordLabel = [[UILabel alloc] initWithFrame:[self propToRect:CGRectMake(0.05, 0.15, 0.9, 0.15)]];
    mainWordLabel.layer.borderWidth = [Storage getCurrentBorderWidth];
    mainWordLabel.textAlignment = NSTextAlignmentCenter;
    mainWordLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:60]];
    mainWordLabel.adjustsFontSizeToFitWidth = true;
    [self addSubview:mainWordLabel];
    
    
    timerBar = [[UIView alloc] initWithFrame:[self propToRect:CGRectMake(0, 0.3125, 1, 0.05)]];
    timerBar.backgroundColor = UIColor.blackColor;
    [self addSubview:timerBar];
    
    [self createNewWord];

    [self startGameLoop];
    
    return self;
}

-(void)createNewWord{
    NSString *string = @"";
    
    while (string.length <= 0 || string.length > 9) {
        int index = rand() % [words count];
        string = [words objectAtIndex:index];
        NSLog(@"S %@", string);
    }
    
    currentWord = string;
    mainWordLabel.text = string;
    
    currentTimer = 0;
    
    CGRect f = timerBar.frame;
    f.size = CGSizeMake([self propToRect:CGRectMake(0, 0, 1, 1)].size.width, f.size.height);
    timerBar.frame = f;
    
    [timerBar.layer removeAllAnimations];
    
    [self startAnimatingBarDown];
}

- (void)createAllDigitButtons{
    int i = 0;
    for(int y = 0; y < 3; y++){
        for(int x = 0; x < 3; x++){
            i++;
            
            DigitButton* digitButton = [[DigitButton alloc] initWithFrame:[self propToRect:CGRectMake(0.075+(x*0.3), 0.375+(y*0.175), 0.25, 0.15)] digitId:i currentDigit:i withBlock:^(int digitId, int currentDigit){
                
            }];
            
            
            digitButton.layer.borderWidth = [Storage getCurrentBorderWidth];
            
            __unsafe_unretained typeof(DigitButton*) wb = digitButton;
            
            [digitButton setBlock:^(int digitId, int currentDigit){
                NSLog(@"Digit Id: %i %i", digitId, currentDigit);
                [self pressDigitButton:wb];
            }];
            
            [self addSubview:digitButton];
        }
    }
}

-(void)pressDigitButton:(DigitButton*)btn {
    if(btn.currentDigit == currentWord.length){
        NSLog(@"Correct");
        score += 1;
        scoreLabel.text = [NSString stringWithFormat:@"%i", score];
        
        [self createNewWord];
    }else{
        NSLog(@"Wrong");
        [self gameOver];
    }
}

-(bool)saveScore{
    if(score > [Storage getSavedHighScore]){
        [Storage saveHighScore:score];
        return true;
    }
    return false;
}

-(void)gameOver{
    newHighScore = [self saveScore];

    [self.delegate gcReportScore:score];

    [self stopGameLoop];
    [self.delegate switchFrom:Game to:GameOver];

}

-(void)startGameLoop {
    gameTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(gameLoop:)];
    if (@available(iOS 10.0, *)) {
        gameTimer.preferredFramesPerSecond = 60;
    } else {
        // Fallback on earlier versions
        gameTimer.frameInterval = 1;
    }
    [gameTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

-(void)stopGameLoop {
    [gameTimer setPaused:true];
    [gameTimer removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    gameTimer = nil;
}

-(void)gameLoop:(CADisplayLink*)tmr {
    CGFloat delta = tmr.duration;
    currentTimer += delta;
    
    if(currentTimer >= timePerWord){
        [self gameOver];
    }
}

-(void)startAnimatingBarDown{
    CGRect f = timerBar.frame;
    f.size = CGSizeMake(0, f.size.height);
    [UIView animateWithDuration:timePerWord delay:0 options:UIViewAnimationOptionCurveLinear animations:^void{
        timerBar.frame = f;

    } completion:nil];
}

- (CGRect) propToRect: (CGRect)prop {
    CGRect viewSize = self.frame;
    CGRect real = CGRectMake(prop.origin.x*viewSize.size.width, prop.origin.y*viewSize.size.height, prop.size.width*viewSize.size.width, prop.size.height*viewSize.size.height);
    return real;
}

@end
