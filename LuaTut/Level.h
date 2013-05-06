//
//  Level.h
//  LuaTut
//
//  Created by Sarah Smith on 6/05/13.
//  Copyright (c) 2013 Sarah Smith. All rights reserved.
//

#import "GameObject.h"

@class Dragon;

@interface Level : CCLayer
{
    Dragon *dragon;
    GameObject *lastHit;
    NSUInteger _totalPossible;
}

@property (nonatomic, assign) NSUInteger totalPossible;

@end
