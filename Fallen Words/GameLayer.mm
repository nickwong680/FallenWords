//
//  HelloWorldLayer.mm
//  cocos2d-2.x-Box2D-ARC-iOS
//
//  Created by Steffen Itterheim on 18.05.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "GameLayer.h"
#import "PhysicsSprite.h"
#import "Helper.h"
#import "WordGroup.h"
#import <CoreData+MagicalRecord.h>


@implementation GameLayer
{
    CCLabelTTF* touchLetterLabel;
}

+(CCScene*) scene
{
	CCScene* scene = [CCScene node];
	GameLayer* layer = [GameLayer node];
	[scene addChild:layer];
	return scene;
}
static CGRect screenRect;
-(CGRect) screenRect
{
	return screenRect;
}

-(id) init {
	self = [super init];
	if (self)
	{
		
        // make sure to initialize the screen rect only once
		if (CGRectIsEmpty(screenRect))
		{
			CGSize screenSize = [CCDirector sharedDirector].winSize;
			screenRect = CGRectMake(0, 0, screenSize.width, screenSize.height);
		}
        
		// if the background shines through we want to be able to see it!
		glClearColor(1, 1, 1, 1);
        
        letterStore = [[LetterStore alloc]init];
        
        [self addChild:letterStore z:0 tag:kTagBatchNode];
        
        //[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:letterStore.batch];

        CCLOG(@" pvr.ccz Loaded: %@", lettersTexture);
        
        [self setTouchEnabled:YES];
		[self initPhysics];
        //[self addGUI];
        [self showMenu];
		[self schedule:@selector(addNewLetterInterval:) interval:1.0f];
		[self scheduleUpdate];
        [self addNewSpriteAtPosition:ccp(screenRect.size.width, screenRect.size.height - 100) letterString:@"P"];
        [self addNewSpriteAtPosition:ccp(screenRect.size.width, screenRect.size.height - 100) letterString:@"E"];
        [self addNewSpriteAtPosition:ccp(screenRect.size.width, screenRect.size.height - 100) letterString:@"O"];
        [self addNewSpriteAtPosition:ccp(screenRect.size.width, screenRect.size.height - 100) letterString:@"P"];
        [self addNewSpriteAtPosition:ccp(screenRect.size.width, screenRect.size.height - 100) letterString:@"L"];
        queueMenu = [[NSOperationQueue alloc] init];
        queueGUIButton = [[NSOperationQueue alloc] init];
        queueAutoComplete = [[NSOperationQueue alloc] init];
        wordListSelectedByUser = [NSArray array];
	}
	return self;
}
-(void)showDemo {
    
}
-(void) dealloc
{
	delete world;
	world = NULL;
	delete debugDraw;
	debugDraw = NULL;
	delete contactListener;
	contactListener = NULL;
}

-(void) initPhysics
{
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
	world->SetAllowSleeping(true);
	world->SetContinuousPhysics(false);
	
	contactListener = new ContactListener();
	world->SetContactListener(contactListener);
	
	debugDraw = new GLESDebugDraw(PTM_RATIO);
	world->SetDebugDraw(debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	debugDraw->SetFlags(flags);		
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	

	float boxWidth = screenRect.size.width / PTM_RATIO;
	float boxHeight = screenRect.size.height / PTM_RATIO;
	b2EdgeShape groundBox;
	int density = 0;
    PhysicsSprite* sprite = [PhysicsSprite spriteWithSpriteFrameName:@"A.png" ];

	// bottom
	groundBox.Set(b2Vec2(0, sprite.contentSize.height / PTM_RATIO), b2Vec2(boxWidth, sprite.contentSize.width / PTM_RATIO));
	groundBody->CreateFixture(&groundBox, density);
	// top
    groundBox.Set(b2Vec2(0, boxHeight - sprite.contentSize.height / PTM_RATIO), b2Vec2(boxWidth, boxHeight - sprite.contentSize.width / PTM_RATIO));
	//groundBox.Set(b2Vec2(0, boxHeight), b2Vec2(boxWidth, boxHeight));
	groundBody->CreateFixture(&groundBox, density);
	// left
	groundBox.Set(b2Vec2(0, boxHeight), b2Vec2(0, 0));
	groundBody->CreateFixture(&groundBox, density);
	// right
	groundBox.Set(b2Vec2(boxWidth, boxHeight), b2Vec2(boxWidth, 0));
	groundBody->CreateFixture(&groundBox, density);

	//[self addSomeJointedBodies:CGPointMake(screenRect.size.width / 4, screenRect.size.height - 50)];
}



#if DEBUG
-(void) draw
{
	[super draw];
	
	ccGLEnableVertexAttribs(kCCVertexAttribFlag_Position);
	kmGLPushMatrix();
	world->DrawDebugData();	
	kmGLPopMatrix();
}
#endif

-(PhysicsSprite*) createPhysicsSpriteAt:(CGPoint)pos letterString:(NSString *)letter
{
	CCLOG(@"Add sprite %0.2f, %02.f", pos.x, pos.y);
    PhysicsSprite *myLetter;
	if (letter) {
        myLetter = [letterStore createLetter:letter];
    } else {
        //myLetter = [letterStore createRandomLetter];
        myLetter = [letterStore createRandomLetterFromWordGrp];

    }
	myLetter.position = pos;
    
    CCLOG(@"Sprite added %@", myLetter);

	return myLetter;
}

-(void) createBodyFixture:(b2Body*)body sprite:(PhysicsSprite *)sprite
{
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	//dynamicBox.SetAsBox(sprite.contentSize.height /2 , sprite.contentSize.width /2);
    dynamicBox.SetAsBox((letterStore.letterSize.height/2) / PTM_RATIO, (letterStore.letterSize.width/2) / PTM_RATIO );//These are mid points for our 1m box

	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	body->CreateFixture(&fixtureDef);
}
-(void) addNewSpriteAtPosition:(CGPoint)pos {
    [self addNewSpriteAtPosition:pos letterString:nil];
}
-(void) addNewSpriteAtPosition:(CGPoint)pos letterString:(NSString *)letter
{
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.position = [Helper toMeters:pos];
	b2Body* body = world->CreateBody(&bodyDef);

	PhysicsSprite* sprite = [self createPhysicsSpriteAt:pos letterString:letter];
    [self createBodyFixture:body sprite:sprite];

	[sprite setPhysicsBody:body];
	body->SetUserData((__bridge void*)sprite);
}

-(void) update:(ccTime)delta
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(delta, velocityIterations, positionIterations);
}
-(void)addNewLetterInterval:(ccTime)delta {
    //if (letterStore.visibleLettersArray.count < 30 ) {
    //screenRect.size.width
    CGPoint point = ccp( arc4random_uniform(screenRect.size.width), screenRect.size.height - (letterStore.letterSize.height * 2));
    for  (Letter *letter in letterStore.visibleLettersArray.descendants ) {
        if (CGRectContainsPoint( [letter boundingBox], point)) {
            CCLOG(@"Unable to add new Letter, letter is blocking %@", letter);
            return;
        }
    }
     
    point.y += letterStore.letterSize.height;
    
    [self addNewSpriteAtPosition:point];
    
    //}

}
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for (UITouch* touch in touches)
	{
		CGPoint location = [touch locationInView:touch.view];
		location = [[CCDirector sharedDirector] convertToGL:location];
        if ([menuLayer parent]) {
            for (CCSprite *button in menuLayer.children) {
                if (CGRectContainsPoint( [button boundingBox], location)) {
                    CCLOG(@"Pressed  :%@" , button);
                    if ([queueMenu operationCount] == 0) {
                        [queueMenu setName:@"queueMenu"];
                        [queueMenu addOperationWithBlock:^{
                            switch ([button tag]) {
                                case TagMenuPreSchool:
                                    [letterStore setWordGroup:@"1 Grade Word List"];
                                    //wordListSelectedByUser = [WordGroup MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"name == %@ ",@"1 Grade Word List"]];
                                    break;
                                case TagMenuPrimarySchool:
                                    [letterStore setWordGroup:@"6 Grade Word List"];

                                    //wordListSelectedByUser = [WordGroup MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"name == %@ ",@"6 Grade Word List"]];
                                    break;
                                case TagMenuSecondarySchool:
                                    [letterStore setWordGroup:@"8 Grade Word List"];

                                    //wordListSelectedByUser = [WordGroup MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"name == %@ ",@"8 Grade Word List"]];
                                    break;
                            }
                            [self hideMenu];
                            [self startGame];
                        }];
                    }
                }
            }
        } else {
            for (Letter *letter in letterStore.visibleLettersArray.descendants) {
                
                if (CGRectContainsPoint( [letter boundingBox], location)) {
                    
                    CCLOG(@"Touched %@ :%@", letter.letterString , letter);
                    [letterStore addTouchedLetters: letter];
                    
                    [touchLetterLabel setString:[letterStore getTouchedLettersString]];
                    if ([letterStore getTouchedLettersString].length >= MIN_WORD_LENGTH) {

                        [self scheduleOnce:@selector(_match:) delay:0.0f];
                    }
                    
                }
            }
            for (CCSprite *button in buttonsLayer.children) {
                if (CGRectContainsPoint( [button boundingBox], location)) {
                    if ([queueGUIButton operationCount] == 0) {
                        [queueGUIButton setName:@"hintQueue"];
                        [queueGUIButton addOperationWithBlock:^{
                            CCLOG(@"Pressed  :%@" , button);
                            switch ([button tag]) {
                                case TagGUIOKButton:
                                    
                                    break;
                                case TagGUICancelButton:
                                    [letterStore resetTouchLetters];
                                    [touchLetterLabel setString:@""];

                                    break;
                                case TagGUIHintButton: {
                                    [letterStore giveHint];
                                    break;
                                }
                                default:
                                    break;
                            }
                            [self removeChild:menuLayer];
                        }];
                    }
                }
            }
        }
	}
}
-(void)addGUI {
    touchLetterLabel = [CCLabelTTF labelWithString:@"Tap screen"
                                          fontName:@"Marker Felt"
                                          fontSize:32];
    [self addChild:touchLetterLabel z:0];
    touchLetterLabel.color = ccc3(0, 0, 255);
    touchLetterLabel.position = ccp(screenRect.size.width / 2, screenRect.size.height - letterStore.letterSize.height / 2);
    
    CCSprite *okButton = [CCSprite spriteWithSpriteFrameName:@"A.png" ];
    CCSprite *canelButton = [CCSprite spriteWithSpriteFrameName:@"A.png" ];
    CCSprite *hintButton = [CCSprite spriteWithSpriteFrameName:@"A.png" ];
    buttonsLayer= [[CCLayer alloc] init];
    
    [buttonsLayer addChild:okButton z:0 tag:TagGUIOKButton];
    okButton.position = ccp(screenRect.size.width - [letterStore letterSize].width / 2, [letterStore letterSize].height / 2 );

    [buttonsLayer addChild:canelButton z:0 tag:TagGUICancelButton];
    canelButton.position = ccp(screenRect.size.width - ([letterStore letterSize].width ) * 1.5 , [letterStore letterSize].height / 2);
    
    [buttonsLayer addChild:hintButton z:0 tag:TagGUIHintButton];
    hintButton.position = ccp(screenRect.size.width - ([letterStore letterSize].width  ) * 2.5 , [letterStore letterSize].height / 2);
    [self addChild:buttonsLayer];

}
-(void)_match:(ccTime)delta {
    if ([queueAutoComplete operationCount] == 0) {
        [queueAutoComplete setName:@"autoQueue"];
        [queueAutoComplete addOperationWithBlock:^{
            
            matchWord match = [letterStore isDictionaryWord:[letterStore getTouchedLettersString]];
            
            if (match == wordIsMatch) {
                [touchLetterLabel setColor:ccc3(0, 255, 255)];
            } else if (match == wordIsPartiallyMatch) {
                [touchLetterLabel setColor:ccc3(0, 0, 255)];
            } else {
                [touchLetterLabel setColor:ccc3(0, 20, 20)];
                
            }
        }];
    } else {
        CCLOG(@"autoQueue is running");
    }

}

#pragma menu
-(void)showMenu {

    menuLayer = [CCLayerColor layerWithColor:ccc4(15, 15, 15, 255)];
    
    CCSprite *menuPreSchool = [CCSprite spriteWithSpriteFrameName:@"A.png" ];
    CCSprite *menuPrimarySchool = [CCSprite spriteWithSpriteFrameName:@"A.png" ];
    CCSprite *menuSecondarySchool = [CCSprite spriteWithSpriteFrameName:@"A.png" ];
    //menuLayer= [[CCLayer alloc] init];
    
    [menuLayer addChild:menuPreSchool z:0 tag:TagMenuPreSchool];
    menuPreSchool.position = ccp([letterStore letterSize].width, ([letterStore letterSize].height / 2) + ([letterStore letterSize].height * 1));
    
    [menuLayer addChild:menuPrimarySchool z:0 tag:TagMenuPrimarySchool];
    menuPrimarySchool.position = ccp([letterStore letterSize].width , ([letterStore letterSize].height / 2) + ([letterStore letterSize].height * 2));
    
    [menuLayer addChild:menuSecondarySchool z:0 tag:TagMenuSecondarySchool];
    menuSecondarySchool.position = ccp([letterStore letterSize].width , ([letterStore letterSize].height / 2) + ([letterStore letterSize].height * 3));
    
    [self addChild:menuLayer z:10];
    menuLayer.opacity = 240;
}
-(void)showMenuWithCCMenu {
    
    menuLayer = [CCLayerColor layerWithColor:ccc4(15, 15, 15, 255)];
    CCMenuItemSprite *menuPreSchool = [CCMenuItemSprite  itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"A.png" ] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"B.png" ] ];
    CCMenuItemSprite *menuPrimarySchool = [CCMenuItemSprite  itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"A.png" ] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"B.png" ] ];
    CCMenuItemSprite *menuSecondarySchool = [CCMenuItemSprite  itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"A.png" ] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"B.png" ] ];
    //menuLayer= [[CCLayer alloc] init];
    
    CCMenu *menu = [CCMenu menuWithItems:menuPreSchool ,menuPrimarySchool, menuSecondarySchool,  nil];
    [menuLayer addChild:menu];
    menuPreSchool.position = ccp([letterStore letterSize].width, ([letterStore letterSize].height / 2) + ([letterStore letterSize].height * 1));
    
    menuPrimarySchool.position = ccp([letterStore letterSize].width , ([letterStore letterSize].height / 2) + ([letterStore letterSize].height * 2));
    
    menuSecondarySchool.position = ccp([letterStore letterSize].width , ([letterStore letterSize].height / 2) + ([letterStore letterSize].height * 3));
    
    [self addChild:menuLayer z:10];
    menuLayer.opacity = 240;
}
-(void)hideMenu {
    [self removeChild:menuLayer];
}
-(void)startGame {
    [self addGUI];
    if ([[letterStore visibleLettersArray] descendants] > 0) {
        for (PhysicsSprite *letter in [[letterStore visibleLettersArray] descendants]) {
            world->DestroyBody([letter physicsBody]);
            [letter removeFromParent];
        }
    }
    [letterStore resetVisibleLetters];
    [letterStore resetTouchLetters];

}
@end
