//
//  MenuLayer.mm
//  Fallen Words
//
//  Created by Nick on 23/06/13.
//  Copyright 2013 Nick. All rights reserved.
//

#import "MenuLayer.h"
#import "Helper.h"

@implementation MenuLayer

+(id) scene
{
    CCScene *scene = [CCScene node];
    CCLayer* layer = [MenuLayer node];
    [scene addChild:layer];
    return scene;
}

-(id) init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}


@end
