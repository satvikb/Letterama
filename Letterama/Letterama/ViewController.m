//
//  ViewController.m
//  Letterama
//
//  Created by Satvik Borra on 9/11/17.
//  Copyright © 2017 satvik borra. All rights reserved.
//

#import "ViewController.h"
#define GAMECENTER_LEADERBOARD_IDENTIFIER (@"wordscorrect")
#import "Flurry.h"
@import GoogleMobileAds;

@interface ViewController () <GADBannerViewDelegate, GADInterstitialDelegate> {
    NSArray *words;
    UILabel* mainWordLabel;
    NSString* currentWord;
    
    MenuView* menuView;
    GameView* gameView;
    GameOverView* gameOverView;
    SettingsView* settingsView;
    GameCenterLeaderboardView* gameCenterLeaderboardView;
}

@property(nonatomic, strong) GADBannerView *bannerView;
@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation ViewController

@synthesize gameCenterEnabled;
@synthesize isAdDisplayed;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self authenticateLocalPlayer];
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"words_alpha" ofType:@"txt"];
    
    NSString *fileContents = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *lines = [fileContents componentsSeparatedByString:@"\r\n"];
    words = lines;
    
    /* initialize random seed: */
    srand ( (unsigned int)time(NULL) );
    
    
    menuView = [self createMenuView];
    [self.view addSubview:menuView];
   
//    gameView = [self createGameView]
    
    
    self.bannerView = [[GADBannerView alloc]
                       initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.bannerView.adUnitID = @"ca-app-pub-2889096611002538/5198583224";
    CGRect screenBounds = [self propToRect:CGRectMake(0, 0, 1, 1)];
    [self.bannerView setFrame:CGRectMake(0, 0, screenBounds.size.width, self.bannerView.bounds.size.height)];
    self.bannerView.center = CGPointMake(screenBounds.size.width / 2, screenBounds.size.height - (self.bannerView.bounds.size.height / 2));
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
    self.bannerView.layer.zPosition = 200;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID,                       // All simulators
                             @"2e8fb434d98fb223f735071df2de6280"];
    [self.bannerView loadRequest:request];
    
}

-(MenuView*)createMenuView{
    MenuView* menu = [[MenuView alloc] initWithFrame:[self propToRect:CGRectMake(0, 0, 1, 1)]];
    menu.delegate = self;
    menu.layer.zPosition = 40;
    return menu;
}

-(GameView*)createGameView{
    GameView* game = [[GameView alloc] initWithFrame:[self propToRect:CGRectMake(0, 0, 1, 1)] andWords:words];
    game.delegate = self;
    game.layer.zPosition = 30;
    return game;
}

-(GameOverView*)createGameOverViewScore:(int)score newHighScore:(bool)newHighScore{
    GameOverView* gameOver = [[GameOverView alloc] initWithFrame:[self propToRect:CGRectMake(0, 0, 1, 1)] score:score newHighScore:newHighScore];
    gameOver.delegate = self;
    gameOver.layer.zPosition = 20;

    return gameOver;
}

-(SettingsView*)createSettingsView{
    SettingsView* settings = [[SettingsView alloc] initWithFrame:[self propToRect:CGRectMake(0, 0, 1, 1)]];
    settings.delegate = self;
    settings.layer.zPosition = 10;
    return settings;
}

-(GameCenterLeaderboardView*)createGameCenterLeaderboardViewWithScores:(NSArray*)scores{
    GameCenterLeaderboardView* leaderboard = [[GameCenterLeaderboardView alloc] initWithFrame:[self propToRect:CGRectMake(0, 0, 1, 1)] scores:scores];
    leaderboard.delegate = self;
    return leaderboard;
}


-(void)authenticateLocalPlayer{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                gameCenterEnabled = YES;
            }else{
                gameCenterEnabled = NO;
            }
        }
    };
}

-(void)gcReportScore:(int)s{
    if(gameCenterEnabled == true){
        GKScore *gkScore = [[GKScore alloc] initWithLeaderboardIdentifier:GAMECENTER_LEADERBOARD_IDENTIFIER];
        gkScore.value = s;
        
        [GKScore reportScores:@[gkScore] withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            
//            [Flurry logEvent:@"GameCenterReportScore" withParameters:@{@"score":[NSNumber numberWithInt:s]}];
        }];
    }
}

-(void)showGCLeaderboard {
    if(gameCenterEnabled == true){
        GKLeaderboard* leaderboard = [[GKLeaderboard alloc] init];
        leaderboard.playerScope = GKLeaderboardPlayerScopeGlobal;
        leaderboard.identifier = GAMECENTER_LEADERBOARD_IDENTIFIER;
        leaderboard.range = NSMakeRange(1, 50);
        //    leaderboard.
        menuView.labelUnderScores.text = @"loading...";
//        [self showLabelUnderScores:@"loading..." time:10];
        [leaderboard loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error){
            if(error){
                NSLog(@"Error retreiving scores %@", error);
                [self showLabelUnderScores:@"failed to get scores" time:3];
            }else{
                for(GKScore* score in scores){
                    NSLog(@"SCORE: %@ %lli", score.player.displayName, score.value);
                }
                
                gameCenterLeaderboardView = [self createGameCenterLeaderboardViewWithScores:scores];
                [self.view addSubview:gameCenterLeaderboardView];
            }
        }];
    }else{
        [self showLabelUnderScores:@"game center not authenticated" time:2];
    }
}

-(void)showLabelUnderScores:(NSString*)text time:(NSTimeInterval)time {
    menuView.labelUnderScores.text = text;
    
    [self performSelector:@selector(resetTextUnderScores) withObject:nil afterDelay:time];
}

-(void)resetTextUnderScores{
    menuView.labelUnderScores.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchAllFontsTo:(NSString*)fontName{
    [self changeViewLabels:self.view fontTo:fontName];
}

-(void)changeViewLabels:(UIView*)mainView fontTo:(NSString*)font{
    for(UIView* subview in mainView.subviews){
        if([subview isKindOfClass:[UILabel class]]){
            UILabel* label = (UILabel*)subview;
            
            label.font = [UIFont fontWithName:font size: label.font.pointSize ];
            
        }else{
            [self changeViewLabels:subview fontTo:font];
        }
    }
}

-(void)switchAllBorderWidthTo:(int)borderWidth{
    [self changeViews:self.view borderTo:borderWidth];
}

-(void)changeViews:(UIView*)mainView borderTo:(int)border{
    for(UIView* subview in mainView.subviews){
        if(subview.tag != 1){
            subview.layer.borderWidth = border;
        }else{
            subview.layer.borderWidth = 0;
        }
        
        [self changeViews:subview borderTo:border];
    }
}

-(void)switchFrom:(AppState)currentState to:(AppState)newState{
    int score = 0;
    bool newHighScore = false;
    
    switch (currentState) {
        case Menu:
            if(menuView != nil && newState != GamecenterLeaderboard){
                [menuView removeFromSuperview];
                menuView = nil;
            }
            break;
        case Game:
            if(gameView != nil){
                score = gameView.score;
                newHighScore = gameView.newHighScore;
                
                [gameView removeFromSuperview];
                gameView = nil;
            }
            break;
        case GameOver:
            if(gameOverView != nil){
                [gameOverView removeFromSuperview];
                gameOverView = nil;
            }
            break;
        case Settings:
            if(settingsView != nil){
                [settingsView removeFromSuperview];
                settingsView = nil;
            }
            break;
        case GamecenterLeaderboard:
            if(gameCenterLeaderboardView != nil){
                [gameCenterLeaderboardView removeFromSuperview];
                gameCenterLeaderboardView = nil;
            }
            break;
    }
    
    switch (newState) {
        case Menu:
            if(currentState != GamecenterLeaderboard){
                menuView = [self createMenuView];
                [self.view addSubview:menuView];
            }else{
                menuView.labelUnderScores.text = @"";
            }
            break;
        case Game:
            gameView = [self createGameView];
            [self.view addSubview:gameView];
            [Flurry logEvent:@"game" timed:true];
            break;
        case GameOver:
            gameOverView = [self createGameOverViewScore:score newHighScore:newHighScore];
            [self.view addSubview:gameOverView];
            [Flurry endTimedEvent:@"game" withParameters:@{@"score":[NSNumber numberWithInt:score], @"newHighScore":[NSNumber numberWithBool:newHighScore]}];
            
            if (self.interstitial.isReady) {
                [self.interstitial presentFromRootViewController:self];
            }
            
            break;
        case Settings:
            settingsView = [self createSettingsView];
            [self.view addSubview:settingsView];
            break;
        case GamecenterLeaderboard:
            [self showGCLeaderboard];
            break;
    }
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-2889096611002538/8183128773"];
    interstitial.delegate = self;
    GADRequest *interstitialRequest = [GADRequest request];
    interstitialRequest.testDevices = @[ kGADSimulatorID,                       // All simulators
                                         @"2e8fb434d98fb223f735071df2de6280"];
    [interstitial loadRequest:interstitialRequest];
    return interstitial;
}

- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    [Flurry logEvent:@"AdViewDidReceiveAd"];
    NSLog(@"Ad %f", adView.bounds.size.height);

    isAdDisplayed = true;
    
    [self.view addSubview:adView];
}

-(void)adView:(GADBannerView *)adView didFailToReceiveAdWithError:(GADRequestError *)error{
    isAdDisplayed = false;
    
    NSLog(@"Should remove ad");
}

-(void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    self.interstitial = [self createAndLoadInterstitial];
}

-(void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    [Flurry logEvent:@"Interstitial Receive Ad"];
}

-(void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    [Flurry logEvent:@"Interstitial Fail Ad" withParameters:@{@"error":[error localizedDescription]}];
}

- (CGRect) propToRect: (CGRect)prop {
    CGRect viewSize = [[self view] frame];
    CGRect real = CGRectMake(prop.origin.x*viewSize.size.width, prop.origin.y*viewSize.size.height, prop.size.width*viewSize.size.width, prop.size.height*viewSize.size.height);
    return real;
}

@end
