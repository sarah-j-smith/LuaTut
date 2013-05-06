//
//  Dragon.m
//  LuaTut
//
//  Created by Sarah Smith on 6/05/13.
//  Copyright (c) 2013 Sarah Smith. All rights reserved.
//

#import "Dragon.h"
#import "Coin.h"
#import "Bomb.h"
#import "GameScene.h"
#import "CCBAnimationManager.h"
#import "Obstacle.h"
#import "SimpleAudioEngine.h"

#define kCJStartSpeed 2
#define kCJCoinSpeed 10
#define kCJStartTarget 160

#define kCJTargetFilterFactor 0.01
#define kCJSlowDownFactor 0.995
#define kCJGravitySpeed 0.05
#define kCJGameOverSpeed -10
#define kCJDeltaToRotationFactor 5

@implementation Dragon

@synthesize xTarget;

- (id) init
{
    self = [super init];
    if (!self) return NULL;
    
    xTarget = kCJStartTarget;
    ySpeed = kCJStartSpeed;
    
    return self;
} 

- (void) update
{
    // Calculate new position
    CGPoint oldPosition = self.position;
    
    float xNew = xTarget * kCJTargetFilterFactor + oldPosition.x * (1-kCJTargetFilterFactor);
    float yNew = oldPosition.y + ySpeed;
    if (yNew < 10.0f)
    {
        [[GameScene sharedScene] handleGameOver];
    }
    
    self.position = ccp(xNew,yNew);
    
    // Update the vertical speed
    ySpeed = (ySpeed - kCJGravitySpeed) * kCJSlowDownFactor;
    
    // Tilt the dragon depending on horizontal speed
    float xDelta = xNew - oldPosition.x;
    self.rotation = xDelta * kCJDeltaToRotationFactor;
    
    // Check for game over
    if (ySpeed < kCJGameOverSpeed)
    {
        [[GameScene sharedScene] handleGameOver];
    }
} 

- (void) handleCollisionWith:(GameObject *)gameObject
{
    if ([gameObject isKindOfClass:[Coin class]])
    {
        // Took a coin
        ySpeed = kCJCoinSpeed;
        
        [GameScene sharedScene].score += 1;
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"bling.caf"];
    }
    else if ([gameObject isKindOfClass:[Bomb class]])
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"bluh-wup.caf"];
        // Hit a bomb or obstacle
        if (ySpeed > 0) ySpeed = 0;
        
        CCBAnimationManager* animationManager = self.userObject;
        NSLog(@"animationManager: %@", animationManager);
        [animationManager runAnimationsForSequenceNamed:@"Hit"];
    }
    else if ([gameObject isKindOfClass:[Obstacle class]])
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"bluh-wup.caf"];
        // Hit a bomb or obstacle
        ySpeed = 0;
        
        CCBAnimationManager* animationManager = self.userObject;
        NSLog(@"animationManager: %@", animationManager);
        [animationManager runAnimationsForSequenceNamed:@"Hit"];
    }
}

- (float) radius
{
    return 25;
}

@end
