//
//  HelloWorldLayer.h
//  cocos2d-2.x-Box2D-ARC-iOS
//
//  Created by Steffen Itterheim on 18.05.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "ContactListener.h"
#import "LetterStore.h"


enum 
{
	kTagBatchNode = 0,
    TagGUIOKButton = 10,
    TagGUICancelButton,
    TagGUIHintButton,
    TagGUITouchLabel,
    TagGUIHintLabel,
    TagMenuPreSchool = 20,
    TagMenuPrimarySchool,
    TagMenuSecondarySchool

}Tags;

@interface GameLayer : CCLayer
{
	CCTexture2D* lettersTexture;
	b2World* world;
    ContactListener* contactListener;
	GLESDebugDraw* debugDraw;
    LetterStore *letterStore;
    CCLayer *buttonsLayer;
    CCLayerColor *menuLayer;
    
    NSArray *wordListSelectedByUser;
    NSOperationQueue *queueAutoComplete;
    NSOperationQueue *queueGUIButton;
    NSOperationQueue *queueMenu;

}

+(CCScene*) scene;
@end
