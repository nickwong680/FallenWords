//
//  PhysicsSprite.mm
//  cocos2d-2.x-Box2D-ARC-iOS
//
//  Created by Steffen Itterheim on 18.05.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import "PhysicsSprite.h"
#import "GameLayer.h"
#import "Helper.h"

#pragma mark - PhysicsSprite
@implementation PhysicsSprite

@synthesize physicsBody;

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
}

// this method will only get called if the sprite is batched.
// return YES if the physics values (angles, position ) changed
// If you return NO, then nodeToParentTransform won't be called.
-(BOOL) dirty
{
	return YES;
}

// returns the transform matrix according the Chipmunk Body values
-(CGAffineTransform) nodeToParentTransform
{	
	b2Vec2 pos = physicsBody->GetPosition();
	
	float x = pos.x * PTM_RATIO;
	float y = pos.y * PTM_RATIO;
	
	if (_ignoreAnchorPointForPosition)
	{
		x += _anchorPointInPoints.x;
		y += _anchorPointInPoints.y;
	}
	
	float radians = physicsBody->GetAngle();
	float c = cosf(radians);
	float s = sinf(radians);
	
	if (!CGPointEqualToPoint(_anchorPointInPoints, CGPointZero))
	{
		x += c * -_anchorPointInPoints.x + -s * -_anchorPointInPoints.y;
		y += s * -_anchorPointInPoints.x + c * -_anchorPointInPoints.y;
	}
	
	// Rot, Translate Matrix
	_transform = CGAffineTransformMake(c, s, -s, c, x, y);	
	return _transform;
}

@end
