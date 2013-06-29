//
//  BlockStore.m
//  Fallen Words
//
//  Created by Nick on 17/06/13.
//  Copyright 2013 Nick. All rights reserved.
//

#import "LetterStore.h"
#import <CoreData+MagicalRecord.h>
#import "Dictionary.h"
#import "NSArray+Permute.h"

@implementation LetterStore


@synthesize visibleLettersArray, letterSize;



+(id) cache
{
	return [[self alloc] init];
}

-(id) init
{
	if ((self = [super init]))
	{
		// get any image from the Texture Atlas we're using
		// Load all of the game's artwork up front.
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		[frameCache addSpriteFramesWithFile:@"letters.plist"];
		
        lettersTexture = [[CCTextureCache sharedTextureCache] addImage:@"letters.png"];
		visibleLettersArray = [CCSpriteBatchNode batchNodeWithTexture:lettersTexture];
        letterSize = [[PhysicsSprite spriteWithSpriteFrameName:@"A.png" ] contentSize];

		[self addChild:visibleLettersArray];
		
        alphabets = [@"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z" componentsSeparatedByString:@" "];
        
        [self resetTouchLetters];
        [self resetVisibleLetters];
        
		//[self initAlphabets];
		[self scheduleUpdate];
        self.trie = [ARTST new];
        
        
        //allWordInDict = [Dictionary MR_findAll];
        CCLOG(@"Going to load %i words", [Dictionary MR_findAll].count);

        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue setName:@"trie started"];
        [queue addOperationWithBlock:^{
            for (Dictionary *word in [Dictionary MR_findAllSortedBy:@"length" ascending:YES] ) {
                if (word.word.length >= MIN_WORD_LENGTH) {
                    [self.trie putKey:word.word value:word.word];
                }
            }
            CCLOG(@"Finished loading %i words", [Dictionary MR_findAll].count);
        }];
        
        /*
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            for (Dictionary *word in [Dictionary MR_findAllSortedBy:@"length" ascending:YES] ) {
                if (word.word.length >= MIN_WORD_LENGTH) {
                    [self.trie putKey:word.word value:word.word];
                }
            }
            CCLOG(@"Finished loading %i words", [Dictionary MR_findAll].count);
        }];
*/
        
	}
	
	return self;
}


-(Letter *)createLetter:(NSString *)letter {
    Letter *myLetter = [[Letter alloc] initWithType:letter];
    
    [self addLetterToCollection:myLetter];
    return [visibleLettersArray.descendants lastObject];
}
-(Letter *)createRandomLetter {
    int index = arc4random_uniform(alphabets.count);
    NSString *alphabet = [alphabets objectAtIndex:index ];
    Letter *myLetter = [[Letter alloc] initWithType:alphabet];

    [self addLetterToCollection:myLetter];
    return [visibleLettersArray.descendants lastObject];
}
-(Letter *)createRandomLetterFromWordGrp {
    //static int wordGrpIndex = 0;
    //wordGrpRange.location;
    Dictionary *word = [wordGrpArray objectAtIndex:wordGrpRange.location];
    if (!word) {
        return [self createRandomLetter];
    }
    NSString *myLetter = [NSString stringWithFormat:@"%hu", [word.word characterAtIndex:wordGrpRange.length]];

    [self addLetterToCollection:[[Letter alloc] initWithType:myLetter]];
    if (word.word.length >= wordGrpRange.location) {
        wordGrpRange = NSMakeRange(wordGrpRange.location + 1, 0);
    } else {
        wordGrpRange = NSMakeRange(wordGrpRange.location, wordGrpRange.location + 1);
    }
    return [visibleLettersArray.descendants lastObject];
}
-(void)addLetterToCollection:(Letter *)letter {
    [visibleStringArray addObject:letter.letterString];
    [visibleLettersArray.descendants addObject:letter];
}
-(void)addTouchedLetters:(Letter *)letter {
    [touchedLetters addObject:letter];
    touchedLettersString = [touchedLettersString stringByAppendingString:[letter letterString]];
}
-(NSString *)getTouchedLettersString {
    return touchedLettersString;
}
-(void)resetTouchLetters {
    touchedLetters = [NSMutableArray array];
    touchedLettersString = @"";
}
-(void)resetVisibleLetters {
    [visibleLettersArray removeAllChildrenWithCleanup:YES];
    visibleStringArray =[NSMutableArray array];
}
//+ (NSPredicate*)predicateWithBlock:(BOOL (^)(id evaluatedObject, NSDictionary *bindings))block NS_AVAILABLE(10_6, 4_0);

-(matchWord)isDictionaryWord:(NSString*)word {
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(starting = %@) AND (word beginswith %@) AND (length >= %i)", [word substringToIndex:2], word, word.length];
    
    //NSArray *found = [allWordInDict filteredArrayUsingPredicate:predicate];
    //NSLog(@"found %@", found);
    
    //Dictionary *found = [Dictionary MR_findFirstWithPredicate:predicate sortedBy:@"word" ascending:YES];
    
    const NSUInteger resultLimit = 10;
    self.filteredObjects = [self.trie keysWithPrefix:word limit:resultLimit];
    NSLog(@"objects:%@\nfiltered:%@",self.objects,self.filteredObjects);
    /*
    CCLOG(@"Finding: %@, Found %@", word, found.word);
    
    if ([word isEqualToString:found.word]){
        return wordIsMatch;
    } else if (!found) {
        return wordNotMatch;
    } else if ([word componentsSeparatedByString:found.word]) {
        return wordIsPartiallyMatch;
    }
     */
}
//(BOOL (^)(id evaluatedObject, NSDictionary *bindings))
-(NSString *)isDictionaryWords:(NSArray*)words{
    //self.objects = [NSArray arrayWithArray:words];
    //words = @[@"apple"];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word IN %@", words];
    
    //Dictionary *found = [Dictionary MR_findFirstWithPredicate:predicate sortedBy:@"word" ascending:YES];
    //NSArray *found = [Dictionary MR_findAllWithPredicate:predicate ];
    //CCLOG(@"Finding: %@, Found %@", word, found.word);
    for (NSString *str in words) {
        self.filteredObjects = [self.trie keysWithPrefix:str limit:1];
        // NSLog(@"objects:%@\nfiltered:%@",self.objects, self.filteredObjects);
        if ([[self.filteredObjects lastObject] isEqualToString:str]) {
            CCLOG(@"Found word %@",str);
            return str;
            break;
        }
    }
    return @"";
}
-(BOOL)isDictionaryWordUsingUITextChecker:(NSString*)word {
    //CCLOG(@"Checking word: %@",word);
    UITextChecker *checker = [[UITextChecker alloc] init];
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *currentLanguage = [currentLocale objectForKey:NSLocaleLanguageCode];
    NSRange searchRange = NSMakeRange(0, [word length]);

    NSRange misspelledRange = [checker rangeOfMisspelledWordInString:word 
                                                               range:searchRange
                                                          startingAt:0
                                                                wrap:NO
                                                            language:@"en_US"];
    
    NSMutableArray *arrGuessed = [[checker guessesForWordRange:misspelledRange inString:word language:@"en_US"] mutableCopy];
    CCLOG(@"Checking word: %@",word);

    CCLOG(@"arrGuessed word: %@",arrGuessed);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith %@", word];
    [arrGuessed filterUsingPredicate:predicate];
    CCLOG(@"arrGuessed word: %@",arrGuessed);

    if (misspelledRange.location == NSNotFound) {
        NSLog(@"Word found");
        return true;
    } else {
        NSLog(@"Word not found");
        return false;
    }
    
    
    return misspelledRange.location == NSNotFound;
    //NSRange misspelledRange = [checker rangeOfMisspelledWordInString:word range: searchRange startingAt:0 wrap:NO language: currentLanguage ];
    //return misspelledRange.location == NSNotFound;
                                      
}

-(NSString *)giveHint {

    NSString *match = @"";
    int sizeToCheck = 3;
    static BOOL isChecking = NO;
    if (isChecking) return @"";
    do {
        isChecking = YES;
        NSMutableArray *aaa = [[[NSArray alloc] getPermutations:[visibleStringArray componentsJoinedByString:@""] size:sizeToCheck] mutableCopy];
        
        aaa = [self randomAArray:aaa];
        match = [self isDictionaryWords:aaa];
        sizeToCheck++;
    } while ([match isEqualToString:@""]);
    isChecking = NO;
     
    CCLOG(@"matchedWord: %@", match);
    return match;
}
-(void)setWordGroup:(NSString *)wordgroup {
    wordGrp = [WordGroup MR_findFirst];//:[NSPredicate predicateWithFormat:@"name == %@",wordgroup]];
    wordGrpArray = [NSMutableArray arrayWithArray:[wordGrp.words allObjects]];
    wordGrpArray = [self randomAArray:wordGrpArray];
    wordGrpRange = NSMakeRange(0, 0);
}
#pragma helper
-(NSMutableArray *)randomAArray:(NSMutableArray *)aaa {
    // the Knuth shuffle
    for (NSInteger i = aaa.count-1; i > 0; i--)
    {
        [aaa exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform(i+1)];
    }
    return aaa;
}
@end
