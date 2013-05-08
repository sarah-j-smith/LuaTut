//
//  LuaEngine.h
//  LuaTut
//
//  Created by Sarah Smith on 7/05/13.
//  Copyright (c) 2013 Sarah Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameObject; // 2

@interface LuaEngine : NSObject // 1

+ (LuaEngine *)sharedEngine; // 1

- (void)runLua; // 1

- (void)runScript:(NSString *) script withHost:(GameObject *)host; // 2

@end
