//
//  GameScene.m
//  LuaTut
//
//  Created by Sarah Smith on 6/05/13.
//  Copyright (c) 2013 Sarah Smith. All rights reserved.
//

#import "GameScene.h"
#import "CCBReader.h"
#import "Level.h"
#import "SimpleAudioEngine.h"

@implementation GameScene

@synthesize score;

static GameScene *sharedScene;

+ (GameScene *)sharedScene
{
    return sharedScene;
}

- (void) didLoadFromCCB
{
    // Save a reference to the currently used instance of GameScene
    sharedScene = self;
    
    self.score = 0;
    
    // Load the level
    level = [CCBReader nodeGraphFromFile:@"Level.ccbi"];
    
    // And add it to the game scene
    [levelLayer addChild:level];
}

- (void) setScore:(int)s
{
    if (score != s)
    {
        score = s;
        NSUInteger totPoss = [(Level *)level totalPossible];
        [scoreLabel setString:[NSString stringWithFormat:@"%d / %d",s, totPoss]];
    }
}

- (void)flashScoreLabelWithR:(GLubyte)red G:(GLubyte)green B:(GLubyte)blue
{
    CCTintTo *highlight = [CCTintTo actionWithDuration:0.5f red:red green:green blue:blue];
    CCScaleTo *scale = [CCScaleTo actionWithDuration:0.5f scale:1.2f];
    CCSpawn *anim = [CCSpawn actionOne:highlight two:scale];
    highlight = [CCTintTo actionWithDuration:0.5 red:255 green:255 blue:255];
    scale = [CCScaleTo actionWithDuration:0.5 scale:1.0f];
    CCSpawn *anim2 = [CCSpawn actionOne:highlight two:scale];
    CCSequence *seq = [CCSequence actionOne:anim two:anim2];
    [scoreLabel runAction:seq];
}

- (void) incrementScore
{
    score += 1;
    NSUInteger totPoss = [(Level *)level totalPossible];
    [scoreLabel setString:[NSString stringWithFormat:@"%d / %d", score, totPoss]];
    [self flashScoreLabelWithR:0 G:255 B:255];  // yellow
}

- (void) decrementScore
{
    score -= 1;
    NSUInteger totPoss = [(Level *)level totalPossible];
    [scoreLabel setString:[NSString stringWithFormat:@"%d / %d", score, totPoss]];
    [self flashScoreLabelWithR:255 G:0 B:0];  // red
}

- (void) handleGameOver
{
    [[CCDirector sharedDirector] replaceScene:[CCBReader sceneWithNodeGraphFromFile:@"MainMenuScene"]];
}

- (void) handleLevelComplete
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [level unscheduleAllSelectors];
    [[SimpleAudioEngine sharedEngine] playEffect:@"dream-harp-06.caf"];
    CCLayer *scoreLayer = (CCLayer *)[CCBReader nodeGraphFromFile:@"LevelComplete" owner:self];
    [scoreLayer setTouchPriority:-255];
    NSUInteger possibleScore = [(Level *)level totalPossible];
    [scoreAnnouncement setString:[NSString stringWithFormat:@"Your score: %d of a possible %d!", score, possibleScore]];
    [self addChild:scoreLayer];
}

- (void)okPressed:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[CCBReader sceneWithNodeGraphFromFile:@"MainMenuScene"]];
}

@end
