//
//  NSArray+Permute.m
//  Fallen Words
//
//  Created by Nick on 21/06/13.
//  Copyright (c) 2013 Nick. All rights reserved.
//

#import "NSArray+Permute.h"

@implementation NSArray (Permute)

static NSMutableArray *results;

void doPermute(NSMutableArray *input, NSMutableArray *output, NSMutableArray *used, int size, int level) {
    if (size == level) {
        NSString *word = [output componentsJoinedByString:@""];
        [results addObject:word];
        return;
    }
    
    level++;
    
    for (int i = 0; i < input.count; i++) {
        if ([used[i] boolValue]) {
            continue;
        }
        
        used[i] = [NSNumber numberWithBool:YES];
        [output addObject:input[i]];
        doPermute(input, output, used, size, level);
        used[i] = [NSNumber numberWithBool:NO];
        [output removeLastObject];
    }
}

-(NSArray *) getPermutations:(NSString *)input size:(int) size {
    results = [[NSMutableArray alloc] init];
    
    NSMutableArray *chars = [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i < [input length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [input characterAtIndex:i]];
        [chars addObject:ichar];
    }
    
    NSMutableArray *output = [[NSMutableArray alloc] init];
    NSMutableArray *used = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < chars.count; i++) {
        [used addObject:[NSNumber numberWithBool:NO]];
    }
    
    doPermute(chars, output, used, size, 0);
    
    return results;
}
@end
