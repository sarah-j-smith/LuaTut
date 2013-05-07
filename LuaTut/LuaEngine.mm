//
//  LuaEngine.mm - Obj-C++ file
//  LuaTut
//
//  Created by Sarah Smith on 7/05/13.
//  Copyright (c) 2013 Sarah Smith. All rights reserved.
//

#import "lua.hpp"

#import "LuaEngine.h"

@interface LuaEngine ()
{
    lua_State *luaState;
}


@end

@implementation LuaEngine

+ (LuaEngine *)sharedEngine
{
    static LuaEngine *theEngine;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        theEngine = [[LuaEngine alloc] init];
    });
    return theEngine;
}

- (id)init
{
    if (self = [super init])
    {
        luaState = luaL_newstate();
        NSAssert(luaState, @"Out of memory to create Lua instance!");
        
        luaL_openlibs(luaState);
    }
    return self;
}

- (void)dealloc
{
    lua_close(luaState);
}

- (void)runLua
{
    NSString *luaConfig = [[NSBundle mainBundle] pathForResource:@"init" ofType:@"lua"];
    NSAssert(luaConfig, @"Could not find lua config file");
    int isErr = luaL_dofile(luaState, [luaConfig cStringUsingEncoding:[NSString defaultCStringEncoding]]);
    if (isErr)
    {
        NSLog(@"Could not run lua.init: %s", lua_tostring(luaState, -1));
    }
}

@end
