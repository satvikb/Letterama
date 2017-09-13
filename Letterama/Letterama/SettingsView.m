//
//  SettingsView.m
//  Letterama
//
//  Created by Satvik Borra on 9/11/17.
//  Copyright © 2017 satvik borra. All rights reserved.
//

#import "SettingsView.h"


@implementation SettingsView {
    UILabel* mainLabel;
    UILabel* scoreLabel;
    
    Button* backButton;
    Button* fontButton;
    Button* borderButton;
    Button* aboutButton;

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
    
    mainLabel = [[UILabel alloc] initWithFrame:[self propToRect:CGRectMake(0.05, 0.15, 0.9, 0.15)]];
    mainLabel.textAlignment = NSTextAlignmentCenter;
    mainLabel.text = @"settings";
    mainLabel.layer.borderWidth = 0;// [Storage getCurrentBorderWidth];
    mainLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:60]];
//    [mainLabel sizeToFit];
    mainLabel.tag = 1;
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
    
    aboutButton = [[Button alloc] initWithFrame:[self propToRect:CGRectMake(0.05, 0.8, 0.9, 0.1)] withBlock:^{
        [self showAboutScreen];
    } text:@"about"];
    aboutButton.layer.borderWidth = [Storage getCurrentBorderWidth];
    [self addSubview:aboutButton];
//
    return self;
}

-(void)showAboutScreen{
    UIView* aboutView = [[UIView alloc] initWithFrame:[self propToRect:CGRectMake(0, 0, 1, 1)]];
    aboutView.backgroundColor = UIColor.whiteColor;
    
    UILabel* mainAboutLabel = [[UILabel alloc] initWithFrame:CGRectIntegral([self propToRect:CGRectMake(0.05, 0.075, 0.9, 0.1)])];
    mainAboutLabel.text = @"about";
    mainAboutLabel.textAlignment = NSTextAlignmentCenter;
    mainAboutLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:70]];
    mainAboutLabel.adjustsFontSizeToFitWidth = true;
    [aboutView addSubview:mainAboutLabel];
    
    UILabel* gamesPlayedLabel = [[UILabel alloc] initWithFrame:CGRectIntegral([self propToRect:CGRectMake(0.05, 0.2, 0.9, 0.1)])];
    gamesPlayedLabel.text = [NSString stringWithFormat:@"games played: %i", [Storage getCurrentGamesPlayed]];
    gamesPlayedLabel.textAlignment = NSTextAlignmentCenter;
    gamesPlayedLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:30]];
    gamesPlayedLabel.adjustsFontSizeToFitWidth = true;
    gamesPlayedLabel.tag = 1;
    [aboutView addSubview:gamesPlayedLabel];
    
    UILabel* highScoreLabel = [[UILabel alloc] initWithFrame:CGRectIntegral([self propToRect:CGRectMake(0.05, 0.3, 0.9, 0.1)])];
    highScoreLabel.text = [NSString stringWithFormat:@"high score: %i", [Storage getSavedHighScore]];
    highScoreLabel.textAlignment = NSTextAlignmentCenter;
    highScoreLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:30]];
    highScoreLabel.adjustsFontSizeToFitWidth = true;
    highScoreLabel.layer.borderWidth = 0;//[Storage getCurrentBorderWidth];
    highScoreLabel.tag = 1;
    [aboutView addSubview:highScoreLabel];
    
    Button* wordStatsButton = [[Button alloc] initWithFrame:CGRectIntegral([self propToRect:CGRectMake(0.2, 0.4, 0.6, 0.1)]) withBlock:^void{
        [self showWordStatsScreen];
    } text:@"word lists"];
    wordStatsButton.layer.borderWidth = [Storage getCurrentBorderWidth];
    [aboutView addSubview:wordStatsButton];
    
    Button* developmentStats = [[Button alloc] initWithFrame:CGRectIntegral([self propToRect:CGRectMake(0.225, 0.525, 0.55, 0.05)]) withBlock:^void{
        [self showDevStatsScreen];
    } text:@"dev stats"];
    developmentStats.layer.borderWidth = [Storage getCurrentBorderWidth];
    [aboutView addSubview:developmentStats];
    
    Button* creditsBtn = [[Button alloc] initWithFrame:CGRectIntegral([self propToRect:CGRectMake(0.25, 0.6, 0.5, 0.1)]) withBlock:^void{
        [self showCreditsScreen];
    } text:@"credits"];
    creditsBtn.layer.borderWidth = [Storage getCurrentBorderWidth];
    [aboutView addSubview:creditsBtn];
    
    Button* doneBtn = [[Button alloc] initWithFrame:CGRectIntegral([self propToRect:CGRectMake(0.3, 0.8, 0.4, 0.1)]) withBlock:^void{
        [aboutView removeFromSuperview];
    } text:@"close"];
    doneBtn.layer.borderWidth = [Storage getCurrentBorderWidth];
    [aboutView addSubview:doneBtn];
    
    [self addSubview:aboutView];
}

-(void)showDevStatsScreen{
    UIView* devStatsView = [[UIView alloc] initWithFrame:[self propToRect:CGRectMake(0, 0, 1, 1)]];
    devStatsView.backgroundColor = UIColor.whiteColor;
    
    UILabel* mainCreditsLabel = [[UILabel alloc] initWithFrame:CGRectIntegral([self propToRect:CGRectMake(0.05, 0.075, 0.9, 0.1)])];
    mainCreditsLabel.text = @"dev stats";
    mainCreditsLabel.textAlignment = NSTextAlignmentCenter;
    mainCreditsLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:70]];
    mainCreditsLabel.adjustsFontSizeToFitWidth = true;
    [devStatsView addSubview:mainCreditsLabel];
    
    UILabel* hoursSpentLabel = [[UILabel alloc] initWithFrame:CGRectIntegral([self propToRect:CGRectMake(0.05, 0.2, 0.9, 0.1)])];
    hoursSpentLabel.text = [NSString stringWithFormat:@"hours spent developing: 15"];
    hoursSpentLabel.textAlignment = NSTextAlignmentCenter;
    hoursSpentLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:30]];
    hoursSpentLabel.adjustsFontSizeToFitWidth = true;
    hoursSpentLabel.tag = 1;
    [devStatsView addSubview:hoursSpentLabel];
    
    UILabel* peopleInvolvedLabel = [[UILabel alloc] initWithFrame:CGRectIntegral([self propToRect:CGRectMake(0.05, 0.3, 0.9, 0.1)])];
    peopleInvolvedLabel.text = [NSString stringWithFormat:@"people involved: 4"];
    peopleInvolvedLabel.textAlignment = NSTextAlignmentCenter;
    peopleInvolvedLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:30]];
    peopleInvolvedLabel.adjustsFontSizeToFitWidth = true;
    peopleInvolvedLabel.layer.borderWidth = 0;
    peopleInvolvedLabel.tag = 1;
    [devStatsView addSubview:peopleInvolvedLabel];
    
    UILabel* linesOfCodeLabel = [[UILabel alloc] initWithFrame:CGRectIntegral([self propToRect:CGRectMake(0.05, 0.4, 0.9, 0.1)])];
    linesOfCodeLabel.text = [NSString stringWithFormat:@"lines of code: 1359"];
    linesOfCodeLabel.textAlignment = NSTextAlignmentCenter;
    linesOfCodeLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:30]];
    linesOfCodeLabel.adjustsFontSizeToFitWidth = true;
    linesOfCodeLabel.layer.borderWidth = 0;
    linesOfCodeLabel.tag = 1;
    [devStatsView addSubview:linesOfCodeLabel];
    
    Button* doneBtn = [[Button alloc] initWithFrame:CGRectIntegral([self propToRect:CGRectMake(0.3, 0.8, 0.4, 0.1)]) withBlock:^void{
        [devStatsView removeFromSuperview];
    } text:@"close"];
    doneBtn.layer.borderWidth = [Storage getCurrentBorderWidth];
    [devStatsView addSubview:doneBtn];
    
    [self addSubview:devStatsView];
}

-(void)showWordStatsScreen{
    UIView* wordStatsView = [[UIView alloc] initWithFrame:[self propToRect:CGRectMake(0, 0, 1, 1)]];
    wordStatsView.backgroundColor = UIColor.whiteColor;
    
    UILabel* mainCreditsLabel = [[UILabel alloc] initWithFrame:CGRectIntegral([self propToRect:CGRectMake(0.05, 0.05, 0.9, 0.075)])];
    mainCreditsLabel.text = @"word lists";
    mainCreditsLabel.textAlignment = NSTextAlignmentCenter;
    mainCreditsLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:70]];
    mainCreditsLabel.adjustsFontSizeToFitWidth = true;
    [wordStatsView addSubview:mainCreditsLabel];
    
    CGFloat propHeightPerLetterView = 0.1;
    UIScrollView* wordLettersList = [[UIScrollView alloc] initWithFrame:[self propToRect:CGRectMake(0.05, 0.15, 0.9, 0.7)]];
    wordLettersList.contentSize = CGSizeMake(wordLettersList.frame.size.width, (wordLettersList.frame.size.height*propHeightPerLetterView)*MAX_NUMBER_OF_LETTERS);
    
    NSMutableArray* words = [self.delegate getWordList];
    
    for(int i = 0; i < words.count; i++){
        NSMutableArray* wordsForLetterAmount = [words objectAtIndex:i];
        
        UIView* letterAmountView = [[UIView alloc] initWithFrame: [self propToRect:CGRectMake(0, i*propHeightPerLetterView, 1, propHeightPerLetterView) withParentView:wordLettersList]];
        
        UILabel* numberOfCharactersLabel = [[UILabel alloc] initWithFrame:[self propToRect:CGRectMake(0, 0, 0.7, 1) withParentView:letterAmountView]];
        numberOfCharactersLabel.text = [NSString stringWithFormat:@"%i %@", i+1, i+1 == 1 ? @"character" : @"characters"];
        numberOfCharactersLabel.textAlignment = NSTextAlignmentLeft;
        numberOfCharactersLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:20];
        numberOfCharactersLabel.adjustsFontSizeToFitWidth = true;
        [letterAmountView addSubview:numberOfCharactersLabel];
       
        Button* numberOfWordsButton = [[Button alloc] initWithFrame:[self propToRect:CGRectMake(0.7, 0, 0.3, 1) withParentView:letterAmountView] withBlock:^void{
            [self showAllWordsForCharacterAmount:i+1 wordList:wordsForLetterAmount];
        } text: [NSString stringWithFormat:@"%i", (int)wordsForLetterAmount.count]];
        numberOfWordsButton.layer.borderWidth = [Storage getCurrentBorderWidth];
        [letterAmountView addSubview:numberOfWordsButton];
        
        
        [wordLettersList addSubview:letterAmountView];
    }
    
    [wordStatsView addSubview:wordLettersList];
    
    Button* doneBtn = [[Button alloc] initWithFrame:CGRectIntegral([self propToRect:CGRectMake(0.3, 0.8, 0.4, 0.1)]) withBlock:^void{
        [wordStatsView removeFromSuperview];
    } text:@"close"];
    doneBtn.layer.borderWidth = [Storage getCurrentBorderWidth];
    [wordStatsView addSubview:doneBtn];
    
    [self addSubview:wordStatsView];
}

-(void)showAllWordsForCharacterAmount:(int)characters wordList:(NSMutableArray*)words{
    UIView* allWordsView = [[UIView alloc] initWithFrame:[self propToRect:CGRectMake(0, 0, 1, 1)]];
    allWordsView.layer.zPosition = 100;
    allWordsView.backgroundColor = UIColor.whiteColor;
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectIntegral([self propToRect:CGRectMake(0.05, 0.05, 0.6, 0.075)])];
    titleLabel.text = [NSString stringWithFormat:@"%i character words", characters];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:40]];
    titleLabel.adjustsFontSizeToFitWidth = true;
    [allWordsView addSubview:titleLabel];
    
    UITextView* wordList = [[UITextView alloc] initWithFrame:[self propToRect:CGRectMake(0, 0.125, 1, 0.875)]];
    wordList.textAlignment = NSTextAlignmentLeft;
    wordList.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:15]];
    wordList.text = [words componentsJoinedByString:@"\n"];
    wordList.delegate = self;
    wordList.editable = false;
    [allWordsView addSubview:wordList];
    
    Button* bacButton = [[Button alloc] initWithFrame:[self propToRect:CGRectMake(0.7, 0.05, 0.25, 0.075)] withBlock:^void{
        [allWordsView removeFromSuperview];
    } text:@"back"];
    bacButton.layer.borderWidth = [Storage getCurrentBorderWidth];
    [allWordsView addSubview:bacButton];
    
    [self addSubview:allWordsView];
}

-(void)showCreditsScreen{
    UIView* creditsView = [[UIView alloc] initWithFrame:[self propToRect:CGRectMake(0, 0, 1, 1)]];
    creditsView.backgroundColor = UIColor.whiteColor;
    
    UILabel* mainCreditsLabel = [[UILabel alloc] initWithFrame:CGRectIntegral([self propToRect:CGRectMake(0.05, 0.075, 0.9, 0.1)])];
    mainCreditsLabel.text = @"credits";
    mainCreditsLabel.textAlignment = NSTextAlignmentCenter;
    mainCreditsLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:70]];
    mainCreditsLabel.adjustsFontSizeToFitWidth = true;
    [creditsView addSubview:mainCreditsLabel];
    
    UILabel* creditsLabel =  [[UILabel alloc] initWithFrame:CGRectIntegral([self propToRect:CGRectMake(0.025, 0.2, 0.95, 0.25)])];
    creditsLabel.text = @"idea by satvik borra\n'font 1' by satvik borra\ncoding by satvik borra";
    creditsLabel.textAlignment = NSTextAlignmentCenter;
    creditsLabel.numberOfLines = 3;
    creditsLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:30]];
    creditsLabel.adjustsFontSizeToFitWidth = true;
    creditsLabel.layer.borderWidth = [Storage getCurrentBorderWidth];
    creditsLabel.layer.borderColor = UIColor.blueColor.CGColor;
    [creditsView addSubview:creditsLabel];
    
    Button* removeAds = [[Button alloc] initWithFrame:CGRectIntegral([self propToRect:CGRectMake(0.15, 0.5, 0.7, 0.1)]) withBlock:^void{} text:@""];
    
    removeAds.textLabel.text = [Storage getAdsState] == 0 ? @"remove ads :(" : @"enable ads :)";
    __unsafe_unretained typeof(Button*) wb = removeAds;

    [removeAds setBlock:^{
        if([Storage getAdsState] == 0){
            [Storage setAdsState:1];
            wb.textLabel.text = @"enable ads :)";
            [self.delegate removeAds];
        }else{
            [Storage setAdsState:0];
            wb.textLabel.text = @"remove ads :(";
            [self.delegate initAds];
        }
    }];
    
    [creditsView addSubview:removeAds];
    removeAds.layer.borderWidth = [Storage getCurrentBorderWidth];
    
    Button* resetTutorialBtn = [[Button alloc] initWithFrame:CGRectIntegral([self propToRect:CGRectMake(0.2, 0.625, 0.6, 0.05)]) withBlock:^void{
        [Storage setDidNotCompleteTutorial];
    } text:@"reset tutorial"];
    resetTutorialBtn.layer.borderWidth = [Storage getCurrentBorderWidth];
    [creditsView addSubview:resetTutorialBtn];
    
    Button* doneBtn = [[Button alloc] initWithFrame:CGRectIntegral([self propToRect:CGRectMake(0.3, 0.8, 0.4, 0.1)]) withBlock:^void{
        [creditsView removeFromSuperview];
    } text:@"close"];
    [creditsView addSubview:doneBtn];
    doneBtn.layer.borderWidth = [Storage getCurrentBorderWidth];
    
    [self addSubview:creditsView];
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}

- (CGRect) propToRect: (CGRect)prop {
    CGRect viewSize = self.frame;
    CGRect real = CGRectMake(prop.origin.x*viewSize.size.width, prop.origin.y*viewSize.size.height, prop.size.width*viewSize.size.width, prop.size.height*viewSize.size.height);
    return CGRectIntegral(real);
}

- (CGRect) propToRect: (CGRect)prop withParentView:(UIView*)parent {
    CGRect viewSize = parent.frame;
    CGRect real = CGRectMake(prop.origin.x*viewSize.size.width, prop.origin.y*viewSize.size.height, prop.size.width*viewSize.size.width, prop.size.height*viewSize.size.height);
    return CGRectIntegral(real);
}
@end
