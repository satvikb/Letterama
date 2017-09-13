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
    
    bool gameOverHappening;
}

@synthesize score;
@synthesize newHighScore;

-(instancetype)initWithFrame:(CGRect)frame andWords:(NSArray*)_words deleg:(id<GameViewDelegate>)deleg{
    self = [super initWithFrame:frame];
    
    score = 0;
    newHighScore = false;
 
    timePerWord = 3;
    currentWord = 0;
    words = _words;
    self.delegate = deleg;
    
   
    if([Storage getDidCompleteTutorial] == true){
        [self startGame];
    }else{
        UIView* tutorialView = [[UIView alloc] initWithFrame:[self propToRect:CGRectMake(0.2, 0.3, 0.6, 0.4)]];
        tutorialView.backgroundColor = UIColor.whiteColor;
        tutorialView.layer.borderWidth = 5;
        
        UILabel* mainLabel = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(tutorialView.frame.size.width*0.05, tutorialView.frame.size.height*0.1, tutorialView.frame.size.width*0.9, tutorialView.frame.size.height*0.7))];
        mainLabel.text = @"count the letters in each word, and pick the corresponding number";
        mainLabel.numberOfLines = 5;
        mainLabel.textAlignment = NSTextAlignmentCenter;
        mainLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:20]];
        mainLabel.adjustsFontSizeToFitWidth = true;
        mainLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [tutorialView addSubview:mainLabel];
        [mainLabel sizeToFit];
        
        [self addSubview:tutorialView];
        
        [self performSelector:@selector(showTutorialDissapearButton:) withObject:tutorialView afterDelay:3];
    }
    
    return self;
}

-(void)startGame{
    [self createScoreLabel];
    [self createMainWordLabel];
    [self createTimerBar];
    [self createNewWord];
    [self createAllDigitButtons];
    
    if([Storage getDidCompleteTutorial] == true){
        [self startGameLoop];
    }
}

-(void)createScoreLabel{
    scoreLabel = [[UILabel alloc] initWithFrame:[self propToRect:CGRectMake(0.05, 0.05, 0.9, 0.1)]];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:50]];
    scoreLabel.adjustsFontSizeToFitWidth = true;
    scoreLabel.text = @"0";
    scoreLabel.tag = 1;
    [self addSubview:scoreLabel];
}

-(void)createTimerBar {
    timerBar = [[UIView alloc] initWithFrame:[self propToRect:CGRectMake(0, 0.31875, 1, 0.0375)]];
    timerBar.backgroundColor = UIColor.blackColor;
    [self addSubview:timerBar];
}

-(void)createMainWordLabel {
    mainWordLabel = [[UILabel alloc] initWithFrame:[self propToRect:CGRectMake(0.05, 0.15, 0.9, 0.15)]];
    mainWordLabel.layer.borderWidth = [Storage getCurrentBorderWidth];
    mainWordLabel.textAlignment = NSTextAlignmentCenter;
    mainWordLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:60]];
    mainWordLabel.adjustsFontSizeToFitWidth = true;
    mainWordLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self addSubview:mainWordLabel];
}

-(void)showTutorialDissapearButton:(UIView*)tutorialView {
    Button* doneBtn = [[Button alloc] initWithFrame:CGRectIntegral(CGRectMake(tutorialView.frame.size.width*0.1, tutorialView.frame.size.height-(tutorialView.frame.size.height*0.3), tutorialView.frame.size.width*0.8, tutorialView.frame.size.height*0.2)) withBlock:^void{
        [tutorialView removeFromSuperview];
        [self startGame];
    } text:@"play"];
    [tutorialView addSubview:doneBtn];
}

-(void)createNewWord{
    NSString *string = [self.delegate getRandomWordWithNumberOfLetters:[Functions randomNumberBetween:1 maxNumber:9]];
    
    currentWord = string;
    mainWordLabel.text = string;
    
    currentTimer = 0;
    
    CGRect f = timerBar.frame;
    f.size = CGSizeMake([self propToRect:CGRectMake(0, 0, 1, 1)].size.width, f.size.height);
    timerBar.frame = f;
    
    [timerBar.layer removeAllAnimations];
    
    if([Storage getDidCompleteTutorial] == true){
        [self startAnimatingBarDown];
    }
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
        
        if([Storage getDidCompleteTutorial] == true){
            score += 1;
            scoreLabel.text = [NSString stringWithFormat:@"%i", score];
        }else{
            [Storage setDidCompleteTutorial];
        }
        
        [self createNewWord];
        
        btn.layer.borderColor = UIColor.greenColor.CGColor;
        [self performSelector:@selector(resetBorder:) withObject:btn afterDelay:0.5];
    }else{
        NSLog(@"Wrong");
        
        btn.layer.borderColor = UIColor.redColor.CGColor;
        timerBar.backgroundColor = UIColor.redColor;
        [self performSelector:@selector(gameOverAndResetBorder:) withObject:btn afterDelay:0.5];
    }
}

-(void)resetBorder:(DigitButton*)btn{
    btn.layer.borderColor = UIColor.blackColor.CGColor;
}

-(void)gameOverAndResetBorder:(DigitButton*)btn{
    btn.layer.borderColor = UIColor.blackColor.CGColor;
    [self gameOver];
}

-(bool)saveScore{
    if(score > [Storage getSavedHighScore]){
        [Storage saveHighScore:score];
        return true;
    }
    return false;
}

-(void)gameOver{
    
    if(gameOverHappening == false){
        newHighScore = [self saveScore];
        [Storage addToGamesPlayed];
        
        [self.delegate gcReportScore:score];
        
        [self stopGameLoop];
        [self.delegate switchFrom:Game to:GameOver];
        gameOverHappening = true;
    }
}

-(void)startGameLoop {
    gameTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(gameLoop:)];
    
    if(SYSTEM_VERSION_GREATER_THAN(@"10.0")) {
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
    return CGRectIntegral(real);
}

@end
