//
//  Dragon.h
//  LuaTut
//
//  Created by Sarah Smith on 6/05/13.
//  Copyright (c) 2013 Sarah Smith. All rights reserved.
//

#import "GameObject.h"
#import "CCBAnimationManager.h"

@interface Dragon : GameObject<CCBAnimationManagerDelegate>
{
    float ySpeed;
    float xTarget;
}

@property (nonatomic,assign) float xTarget;


@end
