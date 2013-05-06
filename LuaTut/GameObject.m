//
//  GameObject.m
//  LuaTut
//
//  Created by Sarah Smith on 6/05/13.
//  Copyright (c) 2013 Sarah Smith. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject

@synthesize isScheduledForRemove;

// Update is called for every game object once every frame
- (void) update
{
    // override me
}

// If this game object has collided with another game object this method is called
- (void) handleCollisionWith:(GameObject *)gameObject
{
    // override me
}

// Returns the radius of this game object
- (float) radius
{
    return 0;
}


@end
