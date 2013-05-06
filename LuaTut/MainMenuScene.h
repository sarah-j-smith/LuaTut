//
//  MainMenuScene.h
//  LuaTut
//
//  Created by Sarah Smith on 6/05/13.
//  Copyright (c) 2013 Sarah Smith. All rights reserved.
//

#import "CCLayer.h"

#define kCreditsText 77

@interface MainMenuScene : CCLayer
{
    float updateTimer;
    NSArray *creditsList;
    NSUInteger currentCredit;
}

@end
