//
//  Coin.m
//  LuaTut
//
//  Created by Sarah Smith on 6/05/13.
//  Copyright (c) 2013 Sarah Smith. All rights reserved.
//

#import "Coin.h"
#import "Dragon.h"
#import "GameScene.h"

@implementation Coin

@synthesize isEndCoin;

- (void) handleCollisionWith:(GameObject *)gameObject
{
    if ([gameObject isKindOfClass:[Dragon class]])
    {
        if (isEndCoin)
        {
            // Level is complete!
            [[GameScene sharedScene] handleLevelComplete];
        }
        self.isScheduledForRemove = YES;
    }
}

- (float) radius
{
    return 15;
}

@end
