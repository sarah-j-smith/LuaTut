//
//  Obstacle.m
//  LuaTut
//
//  Created by Sarah Smith on 6/05/13.
//  Copyright (c) 2013 Sarah Smith. All rights reserved.
//

#import "Obstacle.h"
#import "Dragon.h"

@implementation Obstacle

- (void) handleCollisionWith:(GameObject *)gameObject
{
    if ([gameObject isKindOfClass:[Dragon class]])
    {
        // Collided with the dragon, remove object and add an explosion instead
        CCLOG(@"Got obstacle collision");
    }
}

- (float) radius
{
    return 40;
}

@end
