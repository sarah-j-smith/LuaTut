//
//  LuaEngine.h
//  LuaTut
//
//  Created by Sarah Smith on 7/05/13.
//  Copyright (c) 2013 Sarah Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LuaEngine : NSObject

+ (LuaEngine *)sharedEngine;

- (void)runLua;

@end
