//
//  Level.m
//  LuaTut
//
//  Created by Sarah Smith on 6/05/13.
//  Copyright (c) 2013 Sarah Smith. All rights reserved.
//

#import "Level.h"
#import "Dragon.h"
#import "GameObject.h"
#import "Coin.h"

#import "LuaEngine.h" // 2
#import "CCBReader.h"

#define kCJScrollFilterFactor 0.1
#define kCJDragonTargetOffset 80
#define kCheatModeCoins 10

@implementation Level

@synthesize totalPossible = _totalPossible;

- (void)didLoadFromCCB
{
    CCLOG(@"Level -> didLoadFromCCB");
}

- (void) onEnter
{
    [super onEnter];
    
    BOOL isCheatMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"cheatMode"];
    if (isCheatMode)
    {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        float spacing = winSize.width / (kCheatModeCoins + 1);
        CGPoint dragonPos = [dragon position];
        float height = dragonPos.y * 0.33f;
        for (int i = 1; i <= kCheatModeCoins; ++i)
        {
            Coin *cheatCoin = (Coin *)[CCBReader nodeGraphFromFile:@"Coin"];
            [cheatCoin setPosition:ccp(spacing * i, height)];
            [self addChild:cheatCoin];
        }
        CCLabelTTF *lbl = [CCLabelTTF labelWithString:@"Cheat Mode On!" fontName:@"Marker Felt" fontSize:22];
        [lbl setColor:ccRED];
        [lbl setPosition:ccp(winSize.width / 2.0f, height + 30.0f)];
        [self addChild:lbl];
    }
    
    _totalPossible = 0;
    CCNode *k;
    CCArray *kids = [self children];
    CCARRAY_FOREACH(kids, k)
    {
        if ([k isKindOfClass:[Coin class]])
        {
            ++_totalPossible;
        }
    }
    
    // Schedule a selector that is called every frame
    [self schedule:@selector(update:)];
    
    // Make sure touches are enabled
    [self setTouchEnabled:YES];
}

- (void) onExit
{
    [super onExit];
    
    // Remove the scheduled selector
    [self unscheduleAllSelectors];
} 

- (void) update:(ccTime)delta
{
    // Iterate through all objects in the level layer
    CCNode* child;
    BOOL hitSomething = NO;
    CCARRAY_FOREACH(self.children, child)
    {
        // Check if the child is a game object
        if ([child isKindOfClass:[GameObject class]])
        {
            GameObject* gameObject = (GameObject*)child;
            
            [[LuaEngine sharedEngine] runScript:[gameObject updateScript] withHost:gameObject];
            
            // Update all game objects
            [gameObject update];
            
            // Check for collisions with dragon
            if (gameObject != dragon)
            {
                if (ccpDistance(gameObject.position, dragon.position) < gameObject.radius + dragon.radius)
                {
                    // Notify the game objects that they have collided
                    if (gameObject != lastHit)
                    {
                        // Don't keep notifying the same object of the hit over and over again
                        [gameObject handleCollisionWith:dragon];
                        [dragon handleCollisionWith:gameObject];
                        lastHit = gameObject;
                    }
                    hitSomething = YES;
                }
            }
        }
    }
    if (!hitSomething)
    {
        lastHit = nil;
    }
    
    // Check for objects to remove
    NSMutableArray* gameObjectsToRemove = [NSMutableArray array];
    CCARRAY_FOREACH(self.children, child)
    {
        if ([child isKindOfClass:[GameObject class]])
        {
            GameObject* gameObject = (GameObject*)child;
            
            if (gameObject.isScheduledForRemove)
            {
                [gameObjectsToRemove addObject:gameObject];
            }
        }
    }
    
    for (GameObject* gameObject in gameObjectsToRemove)
    {
        [self removeChild:gameObject cleanup:YES];
    }
    
    // Adjust the position of the layer so dragon is visible
    CGSize scrSize = [[CCDirector sharedDirector] winSize];
    float yTarget = (scrSize.height / 2.0f) - dragon.position.y;
    CGPoint oldLayerPosition = self.position;
    
    float xNew = oldLayerPosition.x;
    float yNew = yTarget * kCJScrollFilterFactor + oldLayerPosition.y * (1.0f - kCJScrollFilterFactor);
    
    if (yNew > 0.0f)
    {
        yNew = 0.0f;
    }
    
    self.position = ccp(xNew, yNew);
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView: [touch view]];
    
    dragon.xTarget = touchLocation.x;
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView: [touch view]];
    
    dragon.xTarget = touchLocation.x;
}

@end
