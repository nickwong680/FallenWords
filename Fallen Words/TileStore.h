//
//  BlockStore.h
//  Fallen Words
//
//  Created by Nick on 17/06/13.
//  Copyright 2013 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Letter.h"
#import "ARArrayList.h"
#import "ARTST.h"
#import "WordGroup.h"

#define MIN_WORD_LENGTH 3

typedef enum
{
    wordNotMatch = 0,
	wordIsMatch,
    wordIsPartiallyMatch,
    
}matchWord;

@interface LetterStore : CCNode {
    //CCSpriteBatchNode* batch;
    CCTexture2D* lettersTexture;

	CCSpriteBatchNode* visibleLettersArray;
	NSMutableArray* visibleStringArray;

    NSArray *alphabets;
    CGSize letterSize;
    
    NSString *touchedLettersString;
    NSMutableArray *touchedLetters;
    
    WordGroup *wordGrp;
    NSMutableArray *wordGrpArray;
    NSRange wordGrpRange;
}
@property (nonatomic, assign) CGSize letterSize;
@property (nonatomic) CCSpriteBatchNode* visibleLettersArray;
@property (nonatomic, strong) ARTST *trie;
@property (nonatomic, strong) ARArrayList *objects;
@property (nonatomic, strong) ARArrayList *filteredObjects;


-(Letter *)createRandomLetter;
-(Letter *)createLetter:(NSString *)letter;
-(Letter *)createRandomLetterFromWordGrp;

-(void)addTouchedLetters:(Letter *)letter;
-(NSString *)getTouchedLettersString;
-(void)resetTouchLetters;
-(void)resetVisibleLetters;

-(matchWord)isDictionaryWord:(NSString*)word;

-(NSString *)giveHint ;

-(void)setWordGroup:(NSString *)wordgrp;

@end
