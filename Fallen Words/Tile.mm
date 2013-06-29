//
//  Word.m
//  Fallen Words
//
//  Created by Nick on 17/06/13.
//  Copyright 2013 Nick. All rights reserved.
//

#import "Letter.h"


@implementation Letter
@synthesize letterString;

-(id)initWithType:(NSString *)myLetter {
    letterString = myLetter.uppercaseString;
    NSString *frameName = [letterString stringByAppendingString:@".png"];
    self = [super initWithSpriteFrameName:frameName];
    if (self) {
        
    }
    return self;
}
-(NSString *)description {
    return [[super description] stringByAppendingString:letterString];
}
@end
