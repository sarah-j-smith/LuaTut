//
//  GameObject.m
//  LuaTut
//
//  Created by Sarah Smith on 6/05/13.
//  Copyright (c) 2013 Sarah Smith. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject

@synthesize isScheduledForRemove;
@synthesize updateScript = _updateScript;

- (void)setUpdateScript:(NSString *)updateScript  // 4
{
    if ([[updateScript pathExtension] isEqualToString:@"lua"])
    {
        NSString *scriptPath = [[NSBundle mainBundle] pathForResource:updateScript ofType:nil];
        NSError *err;
        NSString *fileContents = [NSString stringWithContentsOfFile:scriptPath encoding:[NSString defaultCStringEncoding] error:&err];
        if ([fileContents length] == 0)
        {
            if (err) NSLog(@"%@", [err localizedDescription]);
            NSLog(@"Could not load script file for %@ - %@", NSStringFromClass([self class]), scriptPath);
        }
        else
        {
            _updateScript = fileContents;
            NSLog(@"Loaded update script for %@:\n\n%@\n\n", NSStringFromClass([self class]), _updateScript);
        }
    }
    else
    {
        _updateScript = updateScript;
        NSLog(@"Set update script for %@ to:  %@", NSStringFromClass([self class]), _updateScript);
    }
}

// Update is called for every game object once every frame
- (void) update
{
    // override me
}

// If this game object has collided with another game object this method is called
- (void) handleCollisionWith:(GameObject *)gameObject
{
    // override me
}

// Returns the radius of this game object
- (float) radius
{
    return 0;
}


@end
