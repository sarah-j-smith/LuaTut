//
//  GameObject.h
//  LuaTut
//
//  Created by Sarah Smith on 6/05/13.
//  Copyright (c) 2013 Sarah Smith. All rights reserved.
//

#import "CCNode.h"

@interface GameObject : CCNode
{
    BOOL isScheduledForRemove;
}

@property (nonatomic,assign) BOOL isScheduledForRemove;
@property (nonatomic,readonly) float radius;

- (void) update;

- (void) handleCollisionWith:(GameObject*)gameObject;

@end
