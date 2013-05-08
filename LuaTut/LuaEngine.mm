//
//  LuaEngine.mm - Obj-C++ file
//  LuaTut
//
//  Created by Sarah Smith on 7/05/13.
//  Copyright (c) 2013 Sarah Smith. All rights reserved.
//

#import "lua.hpp"

#import "LuaEngine.h"
#import "GameObject.h" // 3

#define kfEpsilon 0.01f

BOOL fuzzyEquals(float a, float b)
{
    return fabsf(a - b) < kfEpsilon;
}

@interface LuaEngine ()
{
    lua_State *luaState;
}


@end

/// ----------------------------------------------------------- // 3
///
/// LUA EXPORT FUNCTIONS
///
/// -----------------------------------------------------------

// x, y = game.getPosition(self); print("Hello Seeker at: ", x, ", ", y)
static int getPosition(lua_State *L)
{
    if (!lua_islightuserdata(L, 1))
    {
        NSLog(@"Arg 1 to game.setPosition() was not a game object");
        return 0;
    }
    GameObject *obj = (__bridge GameObject *)lua_touserdata(L, 1);
    CGPoint pos = [obj position];
    lua_pushnumber(L, pos.x);
    lua_pushnumber(L, pos.y);
    return 2;  // number of return values that have been pushed
}

// game.setPosition(self, newx, newy)
static int setPosition(lua_State *L)
{
    if (!lua_islightuserdata(L, 1))
    {
        NSLog(@"Arg 1 to game.setPosition() was not a game object");
        return 0;
    }
    if (!lua_isnumber(L, 2))
    {
        NSLog(@"Arg 2 to game.setPosition() was not a number");
        return 0;
    }
    if (!lua_isnumber(L, 3))
    {
        NSLog(@"Arg 3 to game.setPosition() was not a number");
        return 0;
    }
    GameObject *obj = (__bridge GameObject *)lua_touserdata(L, 1);
    float x = lua_tonumber(L, 2);
    float y = lua_tonumber(L, 3);
    
    if (!fuzzyEquals([obj position].x, x) || !fuzzyEquals([obj position].y, y))
    {
        [obj setPosition:ccp(x, y)];
    }
    return 0;
}

// d = game.distance(from_x, from_y, to_x, to_y)
static int distance(lua_State *L)
{
    for (int i = 1; i <= 4; ++i)
    {
        if (!lua_isnumber(L, i))
        {
            NSLog(@"Arg %d to distance(from_x, from_y, to_x, to_y) was not a number!",i);
            return 0;
        }
    }
    float from_x = lua_tonumber(L, 1);
    float from_y = lua_tonumber(L, 2);
    float to_x = lua_tonumber(L, 3);
    float to_y = lua_tonumber(L, 4);
    
    float dist = sqrtf(((to_x - from_x) * (to_x - from_x)) + ((to_y - from_y) * (to_y - from_y)));
    
    lua_pushnumber(L, dist);
    
    return 1;
}

/// ----------------------------------------------------------- // 3
///
/// LUA EXPORT STRUCTURES
///
/// -----------------------------------------------------------

// A c-style array of luaL_Reg structs - which are just pairs of
// function pointers and names for them - the array is terminated
// with a null pair
static const struct luaL_Reg gamelib_func_table[] = {
    {"getPosition", getPosition},
    {"setPosition", setPosition},
    {"distance", distance},
    {NULL, NULL}
};

int luaopen_gamelib(lua_State *L)
{
    fprintf(stderr, "Opening game Lua library\n");
    
    // Need to #define LUA_COMPAT_MODULE for this to work
    luaL_register(L, "game", gamelib_func_table);
    return 1;
}


/// ----------------------------------------------------------- // 3
///
/// OBJECTIVE-C LUA ENGINE IMPLEMENTATION
///
/// -----------------------------------------------------------



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
    lua_getglobal(luaState, "cheatMode");
    if (lua_isboolean(luaState, -1))
    {
        NSLog(@"Cheat mode enabled via lua");
        BOOL cheatMode = lua_toboolean(luaState, -1);
        [[NSUserDefaults standardUserDefaults] setBool:cheatMode forKey:@"cheatMode"];
    }
    
    lua_pushcfunction(luaState, luaopen_gamelib);
    lua_pushstring(luaState, "game");
    lua_call(luaState, 1, 0);
}

- (void)runScript:(NSString *)script withHost:(GameObject *)host
{
    if ([script length] > 0)
    {
        lua_pushlightuserdata(luaState, (__bridge void*)host);
        lua_setglobal(luaState, "self");
        int isErr = luaL_dostring(luaState, [script cStringUsingEncoding:[NSString defaultCStringEncoding]]);
        if (isErr)
        {
            NSLog(@"Object %@ had script %@ which failed: %s", host, script, lua_tostring(luaState, -1));
        }
    }
}

@end
