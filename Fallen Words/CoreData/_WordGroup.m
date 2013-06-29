// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WordGroup.m instead.

#import "_WordGroup.h"

const struct WordGroupAttributes WordGroupAttributes = {
	.name = @"name",
};

const struct WordGroupRelationships WordGroupRelationships = {
	.words = @"words",
};

const struct WordGroupFetchedProperties WordGroupFetchedProperties = {
};

@implementation WordGroupID
@end

@implementation _WordGroup

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WordGroup" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WordGroup";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WordGroup" inManagedObjectContext:moc_];
}

- (WordGroupID*)objectID {
	return (WordGroupID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic name;






@dynamic words;

	
- (NSMutableSet*)wordsSet {
	[self willAccessValueForKey:@"words"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"words"];
  
	[self didAccessValueForKey:@"words"];
	return result;
}
	






@end
