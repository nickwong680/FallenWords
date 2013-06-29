//
//  AppDelegate.m
//  Fallen Words
//
//  Created by Nick on 16/06/13.
//  Copyright (c) 2013 Nick. All rights reserved.
//

#import "AppDelegate.h"


#import "cocos2d.h"
#import "GameLayer.h"
#import <CoreData+MagicalRecord.h>
#import "Dictionary.h"
#import "WordGroup.h"
#import "Helper.h"

//#import "MainMenu.h"
@implementation AppDelegate

@synthesize window=window_, navController=navController_, director=director_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[self setupCoreDataFromSeedDB];
    [MagicalRecord setupCoreDataStack];
    
    [self importDictFromTextFile];
    [self importWordGroupFromTextFile];
    
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];
    
	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
    
	director_.wantsFullScreenLayout = YES;
    
	// Display FSP and SPF
	[director_ setDisplayStats:YES];
    
	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];
    
	// attach the openglView to the director
	[director_ setView:glView];
    
	// for rotation and other messages
	[director_ setDelegate:self];
    
	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
    //	[director setProjection:kCCDirectorProjection3D];
    
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
    
	// Create a Navigation Controller with the Director
	navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;
    
	// set the Navigation Controller as the root view controller
    //	[window_ setRootViewController:rootViewController_];
	[window_ addSubview:navController_.view];
    
	// make main window visible
	[window_ makeKeyAndVisible];
    
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
	// When in iPhone RetinaDisplay, iPad, iPad RetinaDisplay mode, CCFileUtils will append the "-hd", "-ipad", "-ipadhd" to all loaded files
	// If the -hd, -ipad, -ipadhd files are not found, it will load the non-suffixed version
	[[CCFileUtils sharedFileUtils] setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[[CCFileUtils sharedFileUtils] setiPadSuffix:@"-hd"];					// Default on iPad is "" (empty string)
	[[CCFileUtils sharedFileUtils] setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"
    
	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
    
	// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
	[director_ pushScene: [GameLayer scene]];
    
    if (![director_ enableRetinaDisplay:YES])
    {
        CCLOG(@"Retina Display Not supported");
    }
	return YES;
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}
-(void)importDictFromTextFile {

    
    CCLOG(@"%@", [Dictionary MR_findAll]);
    
    NSMutableArray *files = [NSMutableArray array];
    [files addObject:[[NSBundle mainBundle] pathForResource:@"english-words" ofType:@"txt"]];

    for (NSString *file in files) {
        
        NSString* dataText = [NSString stringWithContentsOfFile:file encoding:NSStringEncodingConversionAllowLossy error:nil];
        
        NSMutableArray *dataLine = [[dataText componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]] mutableCopy];
        
        int lineCount = 0;
        
        for (NSString *line in dataLine) {
            if (line.length > 1) {
                //CCLOG(@"%@", line);
                Dictionary *word = [Dictionary MR_createEntity];
                word.word = line.uppercaseString;
                word.id = [NSNumber numberWithInt:lineCount];
                word.length = [NSNumber numberWithInteger:line.length];
                lineCount++;
            }
        }
        [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];

    }
}
-(void)importWordGroupFromTextFile {
    NSMutableArray *files = [NSMutableArray array];
    NSArray *filenames = [NSArray arrayWithObjects:@"Preschool Word List",
                      @"Kindergarten Word List",
                      @"1 Grade Word List",
                      @"2 Grade Word List",
                      @"3 Grade Word List",
                      @"4 Grade Word List",
                      @"5 Grade Word List",
                      @"6 Grade Word List",
                      @"7 Grade Word List",
                      @"8 Grade Word List", nil];

    
    for (NSString *filename in filenames) {
        NSString *fullpath = [[NSBundle mainBundle] pathForResource:filename ofType:@"txt"];

        NSString* dataText = [[NSString stringWithContentsOfFile:fullpath encoding:NSStringEncodingConversionAllowLossy error:nil] uppercaseString];
        NSMutableArray *dataLine = [[dataText componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]] mutableCopy];
        
        WordGroup *grp = [WordGroup MR_createEntity];
        grp.name = filename;
        for (Dictionary *dict in [self loadWords:dataLine]) {
            [grp addWordsObject:dict];
        }
        [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
    }
}
                             
-(NSArray *)loadWords:(NSArray *)words {
    NSArray *array = [Dictionary MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"word IN %@", words]];
    return array;
}
/*
-(void)setupCoreDatamodel {
        
    //does the file excit in sandbox?
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"lotto.archive"];
    
    
     Set up the store.
     For the sake of illustration, provide a pre-populated default store.
     
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        // doesn't excsit in sandbox, so now we check if it is in bundle, if so copy to sandbox
        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"lotto" withExtension:@"archive"];
        if (defaultStoreURL) {
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
        }
    }
}
*/
- (void)setupCoreDataFromSeedDB {
    // Get the default store path, then add the name that MR uses for the store
    NSURL *defaultStorePath = [NSPersistentStore MR_defaultLocalStoreUrl];
    defaultStorePath = [[defaultStorePath URLByDeletingLastPathComponent] URLByAppendingPathComponent:[MagicalRecord defaultStoreName]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[defaultStorePath path]]) {
        NSURL *seedPathSQL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[[[NSBundle mainBundle] infoDictionary] valueForKey:(id)kCFBundleNameKey]
                                                                                 ofType:@"sqlite"]];

        NSLog(@"Core data store does not yet exist at: %@. Attempting to copy from seed db %@.", [defaultStorePath path], [seedPathSQL path]);
        
        // We must create the path first, or the copy will fail
        [self createPathToStoreFileIfNeccessary:defaultStorePath];
        
        NSError* err = nil;
        if (![fileManager copyItemAtURL:seedPathSQL toURL:defaultStorePath error:&err]) {
            NSLog(@"Could not copy seed data. error: %@", err);
        }
    }
}

// This method is copied from one of MR's categories
- (void) createPathToStoreFileIfNeccessary:(NSURL *)urlForStore {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *pathToStore = [urlForStore URLByDeletingLastPathComponent];
    
    NSError *error = nil;
    [fileManager createDirectoryAtPath:[pathToStore path] withIntermediateDirectories:YES attributes:nil error:&error];
}

@end
