//
//  GameCenterLeaderboardView.m
//  Letterama
//
//  Created by Satvik Borra on 9/11/17.
//  Copyright © 2017 satvik borra. All rights reserved.
//

#import "GameCenterLeaderboardView.h"
#import "Storage.h"
#import "Button.h"

@implementation GameCenterLeaderboardView {
    UIScrollView* scroll;
    Button* backButton;
}

-(instancetype)initWithFrame:(CGRect)frame scores:(NSArray*)scores{
    self = [super initWithFrame:frame];
    self.backgroundColor = UIColor.whiteColor;
    CGSize cellSize = [self propToRect:CGRectMake(0, 0, 1, 0.1)].size;
    
    scroll = [[UIScrollView alloc] initWithFrame:[self propToRect:CGRectMake(0, 0.125, 1, 0.875)]];
    scroll.contentSize = CGSizeMake(frame.size.width, (scores.count+1)*cellSize.height);
//    scroll.layer.borderWidth = 3;
    [self addSubview:scroll];
    
    for(int i = 0; i < scores.count; i++){
        GKScore* score = [scores objectAtIndex:i];
        GKPlayer* player = score.player;
        
        [self addScoreUnitScore:score withPlayer:player cellSize:cellSize i:i];
    }
    
    backButton = [[Button alloc] initWithFrame:[self propToRect:CGRectMake(0.7, 0.05, 0.25, 0.075)] withBlock:^void{
        [self.delegate switchFrom:GamecenterLeaderboard to:Menu];
    } text:@"back"];
    backButton.layer.borderWidth = [Storage getCurrentBorderWidth];
    [self addSubview:backButton];
    
    return self;
}

-(void)addScoreUnitScore:(GKScore*)score withPlayer:(GKPlayer*)player cellSize:(CGSize)cellSize i:(int)i{
    
    UIView* playerScoreUnit = [[UIView alloc] initWithFrame:CGRectIntegral(CGRectMake(0, cellSize.height*i, cellSize.width, cellSize.height))];
    UILabel* rankLabel = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(cellSize.width*0, cellSize.height*0, cellSize.width*0.2, cellSize.height))];
    rankLabel.text = [NSString stringWithFormat:@"%li.", (long)score.rank];
    rankLabel.textAlignment = NSTextAlignmentCenter;
    rankLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:20]];
    [playerScoreUnit addSubview:rankLabel];
    
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(cellSize.width*0.2, cellSize.height*0, cellSize.width*0.5, cellSize.height))];
    nameLabel.text = [NSString stringWithFormat:@"%@", player.alias];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.adjustsFontSizeToFitWidth = true;
    nameLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:20]];
    [playerScoreUnit addSubview:nameLabel];
    
    UILabel* scoreLabel = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(cellSize.width*0.7, cellSize.height*0, cellSize.width*0.3, cellSize.height))];
    scoreLabel.text = [NSString stringWithFormat:@"%lli", score.value];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.font = [UIFont fontWithName:[Storage getFontNameFromNumber:[Storage getCurrentFont]] size:[Functions fontSize:40]];
    scoreLabel.adjustsFontSizeToFitWidth = true;
//    scoreLabel.layer.borderWidth = [Storage getCurrentBorderWidth];
    [playerScoreUnit addSubview:scoreLabel];
    
    [scroll addSubview:playerScoreUnit];
}

- (CGRect) propToRect: (CGRect)prop {
    CGRect viewSize = self.frame;
    CGRect real = CGRectMake(prop.origin.x*viewSize.size.width, prop.origin.y*viewSize.size.height, prop.size.width*viewSize.size.width, prop.size.height*viewSize.size.height);
    return CGRectIntegral(real);
}

@end


