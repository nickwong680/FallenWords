// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Word.m instead.

#import "_Word.h"

const struct WordAttributes WordAttributes = {
	.id = @"id",
	.length = @"length",
	.word = @"word",
};

const struct WordRelationships WordRelationships = {
};

const struct WordFetchedProperties WordFetchedProperties = {
};

@implementation WordID
@end

@implementation _Word

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Word" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Word";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Word" inManagedObjectContext:moc_];
}

- (WordID*)objectID {
	return (WordID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lengthValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"length"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic id;



- (int32_t)idValue {
	NSNumber *result = [self id];
	return [result intValue];
}

- (void)setIdValue:(int32_t)value_ {
	[self setId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveIdValue {
	NSNumber *result = [self primitiveId];
	return [result intValue];
}

- (void)setPrimitiveIdValue:(int32_t)value_ {
	[self setPrimitiveId:[NSNumber numberWithInt:value_]];
}





@dynamic length;



- (int32_t)lengthValue {
	NSNumber *result = [self length];
	return [result intValue];
}

- (void)setLengthValue:(int32_t)value_ {
	[self setLength:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveLengthValue {
	NSNumber *result = [self primitiveLength];
	return [result intValue];
}

- (void)setPrimitiveLengthValue:(int32_t)value_ {
	[self setPrimitiveLength:[NSNumber numberWithInt:value_]];
}





@dynamic word;











@end
