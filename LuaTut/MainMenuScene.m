//
//  MainMenuScene.m
//  LuaTut
//
//  Created by Sarah Smith on 6/05/13.
//  Copyright (c) 2013 Sarah Smith. All rights reserved.
//

#import "MainMenuScene.h"
#import "CCBReader.h"
#import "SimpleAudioEngine.h"

#define kfUpdateTimeout 5.0f

@implementation MainMenuScene

- (void)didLoadFromCCB
{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"DST-FallenRobot.mp3" loop:YES];
    
    NSString *creditsPath = [[NSBundle mainBundle] pathForResource:@"Credits" ofType:@"plist"];
    creditsList = [[NSDictionary dictionaryWithContentsOfFile:creditsPath] objectForKey:@"CreditsList"];
    NSAssert(creditsList, @"Credits list not found!");
    
    updateTimer = 0.0f;
    currentCredit = 0;
    [self loadCredit:currentCredit];
    [self scheduleUpdate];
}

- (void)loadCredit:(NSUInteger)creditIndex
{
    CCNode *creditsTextLabel = [self getChildByTag:kCreditsText];
    if (!creditsTextLabel)
    {
        CCLabelTTF *label = [CCLabelTTF labelWithString:[creditsList objectAtIndex:currentCredit] fontName:@"Marker Felt" fontSize:20];
        [label setTag:kCreditsText];
        [label setColor:ccBLUE];
        [self addChild:label];
        CGSize scrSize = [[CCDirector sharedDirector] winSize];
        [label setPosition:ccp(scrSize.width / 2.0f, scrSize.height / 8.0f)];
    }
    else
    {
        CCLabelTTF *label = (CCLabelTTF *)creditsTextLabel;
        [label setString:[creditsList objectAtIndex:currentCredit]];
        CCScaleTo *scaleOutAnim = [CCScaleTo actionWithDuration:0.5f scale:1.2f];
        CCScaleTo *scaleInAnim = [CCScaleTo actionWithDuration:0.7 scale:1.0f];
        CCSequence *seq = [CCSequence actionOne:[CCEaseBounceOut actionWithAction:scaleOutAnim]
                                            two:[CCEaseBounceOut actionWithAction:scaleInAnim]];
        [label runAction:seq];
    }
}

- (void)update:(ccTime)delta
{
    updateTimer += delta;
    if (updateTimer > kfUpdateTimeout)
    {
        updateTimer = 0.0f;
        currentCredit = (currentCredit + 1) % [creditsList count];
        [self loadCredit:currentCredit];
    }
}

- (void) pressedPlay:(id)sender
{
    // Load the game scene
    CCScene* gameScene = [CCBReader sceneWithNodeGraphFromFile:@"GameScene.ccbi"];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"wrssh.caf"];
    
    // Go to the game scene
    [[CCDirector sharedDirector] replaceScene:gameScene];
}

@end
