// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WordGroup.h instead.

#import <CoreData/CoreData.h>


extern const struct WordGroupAttributes {
	__unsafe_unretained NSString *name;
} WordGroupAttributes;

extern const struct WordGroupRelationships {
	__unsafe_unretained NSString *words;
} WordGroupRelationships;

extern const struct WordGroupFetchedProperties {
} WordGroupFetchedProperties;

@class Word;



@interface WordGroupID : NSManagedObjectID {}
@end

@interface _WordGroup : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WordGroupID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *words;

- (NSMutableSet*)wordsSet;





@end

@interface _WordGroup (CoreDataGeneratedAccessors)

- (void)addWords:(NSSet*)value_;
- (void)removeWords:(NSSet*)value_;
- (void)addWordsObject:(Word*)value_;
- (void)removeWordsObject:(Word*)value_;

@end

@interface _WordGroup (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveWords;
- (void)setPrimitiveWords:(NSMutableSet*)value;


@end
