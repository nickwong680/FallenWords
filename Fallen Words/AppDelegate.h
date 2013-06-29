//
//  AppDelegate.h
//  Fallen Words
//
//  Created by Nick on 16/06/13.
//  Copyright (c) 2013 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"


@class ViewController;



@interface AppDelegate : UIResponder <UIApplicationDelegate, CCDirectorDelegate> {
    UIWindow* window;
	UINavigationController *navController_;
    
	CCDirectorIOS	*__unsafe_unretained director_;							// weak ref
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (readonly) UINavigationController *navController;
@property (unsafe_unretained, readonly) CCDirectorIOS *director;


@end
