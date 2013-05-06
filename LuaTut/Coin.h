//
//  Coin.h
//  LuaTut
//
//  Created by Sarah Smith on 6/05/13.
//  Copyright (c) 2013 Sarah Smith. All rights reserved.
//

#import "GameObject.h"

@interface Coin : GameObject
{
    BOOL isEndCoin;
}

@property (nonatomic,assign) BOOL isEndCoin;


@end
