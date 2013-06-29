//
//  Word.h
//  Fallen Words
//
//  Created by Nick on 17/06/13.
//  Copyright 2013 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PhysicsSprite.h"

@interface Letter : PhysicsSprite <NSCopying>{
    NSString *letter;
}
-(id) initWithType:(NSString *)letter;
@property (nonatomic) NSString *letterString;
@end
