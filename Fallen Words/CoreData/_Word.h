// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Word.h instead.

#import <CoreData/CoreData.h>


extern const struct WordAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *length;
	__unsafe_unretained NSString *word;
} WordAttributes;

extern const struct WordRelationships {
} WordRelationships;

extern const struct WordFetchedProperties {
} WordFetchedProperties;






@interface WordID : NSManagedObjectID {}
@end

@interface _Word : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WordID*)objectID;





@property (nonatomic, strong) NSNumber* id;



@property int32_t idValue;
- (int32_t)idValue;
- (void)setIdValue:(int32_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* length;



@property int32_t lengthValue;
- (int32_t)lengthValue;
- (void)setLengthValue:(int32_t)value_;

//- (BOOL)validateLength:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* word;



//- (BOOL)validateWord:(id*)value_ error:(NSError**)error_;






@end

@interface _Word (CoreDataGeneratedAccessors)

@end

@interface _Word (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int32_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int32_t)value_;




- (NSNumber*)primitiveLength;
- (void)setPrimitiveLength:(NSNumber*)value;

- (int32_t)primitiveLengthValue;
- (void)setPrimitiveLengthValue:(int32_t)value_;




- (NSString*)primitiveWord;
- (void)setPrimitiveWord:(NSString*)value;




@end
