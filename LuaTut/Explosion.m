//
//  Explosion.m
//  LuaTut
//
//  Created by Sarah Smith on 6/05/13.
//  Copyright (c) 2013 Sarah Smith. All rights reserved.
//

#import "Explosion.h"

@implementation Explosion

- (void) didLoadFromCCB
{
    // Setup a delegate method for the animationManager of the explosion
    CCBAnimationManager* animationManager = self.userObject;
    animationManager.delegate = self;
}

- (void) completedAnimationSequenceNamed:(NSString *)name
{
    // Remove the explosion object after the animation has finished
    self.isScheduledForRemove = YES;
}

@end
