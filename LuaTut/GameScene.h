//
//  GameScene.h
//  LuaTut
//
//  Created by Sarah Smith on 6/05/13.
//  Copyright (c) 2013 Sarah Smith. All rights reserved.
//

#import "CCLayer.h"

@interface GameScene : CCLayer
{
    CCLayer* levelLayer;
    CCLabelTTF* scoreLabel;
    CCLabelTTF *scoreAnnouncement;
    CCNode* level;
    int score;
}

@property (nonatomic,assign) int score;

+ (GameScene*) sharedScene;

- (void) handleGameOver;
- (void) handleLevelComplete;

@end
