//
// Menu Demo
// a cocos2d example
// http://www.cocos2d-iphone.org
//


#import "MenuTest.h"

enum {
	kTagMenu = 1,
	kTagMenu0 = 0,
	kTagMenu1 = 1,
};

#pragma mark -
#pragma mark MainMenu
@implementation Layer1
-(id) init
{
	if( (self=[super init])) {
	
		[CCMenuItemFont setFontSize:30];
		[CCMenuItemFont setFontName: @"Courier New"];

		// Font Item
		
		CCSprite *spriteNormal = [CCSprite spriteWithFile:@"menuitemsprite.png" rect:CGRectMake(0,23*2,115,23)];
		CCSprite *spriteSelected = [CCSprite spriteWithFile:@"menuitemsprite.png" rect:CGRectMake(0,23*1,115,23)];
		CCSprite *spriteDisabled = [CCSprite spriteWithFile:@"menuitemsprite.png" rect:CGRectMake(0,23*0,115,23)];
		CCMenuItemSprite *item1 = [CCMenuItemSprite itemFromNormalSprite:spriteNormal selectedSprite:spriteSelected disabledSprite:spriteDisabled target:self selector:@selector(menuCallback:)];
		
		// Image Item
		CCMenuItem *item2 = [CCMenuItemImage itemFromNormalImage:@"SendScoreButton.png" selectedImage:@"SendScoreButtonPressed.png" target:self selector:@selector(menuCallback2:)];

		// Label Item (LabelAtlas)
		CCLabelAtlas *labelAtlas = [CCLabelAtlas labelAtlasWithString:@"0123456789" charMapFile:@"fps_images.png" itemWidth:16 itemHeight:24 startCharMap:'.'];
		CCMenuItemLabel *item3 = [CCMenuItemLabel itemWithLabel:labelAtlas target:self selector:@selector(menuCallbackDisabled:)];
		item3.disabledColor = ccc3(32,32,64);
		item3.color = ccc3(200,200,255);
		

		// Font Item
		CCMenuItem *item4 = [CCMenuItemFont itemFromString: @"I toggle enable items" target: self selector:@selector(menuCallbackEnable:)];
		
		// Label Item (BitmapFontAtlas)
		CCBitmapFontAtlas *label = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"configuration" fntFile:@"bitmapFontTest3.fnt"];
		CCMenuItemLabel *item5 = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(menuCallbackConfig:)];
		
		// Testing issue #500
		item5.scale = 0.8f;
		
		// Font Item
		CCMenuItemFont *item6 = [CCMenuItemFont itemFromString: @"Quit" target:self selector:@selector(onQuit:)];
		
		id color_action = [CCTintBy actionWithDuration:0.5f red:0 green:-255 blue:-255];
		id color_back = [color_action reverse];
		id seq = [CCSequence actions:color_action, color_back, nil];
		[item6 runAction:[CCRepeatForever actionWithAction:seq]];

		CCMenu *menu = [CCMenu menuWithItems: item1, item2, item3, item4, item5, item6, nil];
		[menu alignItemsVertically];
		
		
		// elastic effect
		CGSize s = [[CCDirector sharedDirector] winSize];
		int i=0;
		for( CCNode *child in [menu children] ) {
			CGPoint dstPoint = child.position;
			int offset = s.width/2 + 50;
			if( i % 2 == 0)
				offset = -offset;
			child.position = ccp( dstPoint.x + offset, dstPoint.y);
			[child runAction: 
			 [CCEaseElasticOut actionWithAction:
			  [CCMoveBy actionWithDuration:2 position:ccp(dstPoint.x - offset,0)]
									   period: 0.35f]
			];
			i++;
		}

		disabledItem = [item3 retain];
		disabledItem.isEnabled = NO;

		[self addChild: menu];
	}

	return self;
}

-(void) dealloc
{
	[disabledItem release];
	[super dealloc];
}

-(void) menuCallback: (id) sender
{
	[(CCMultiplexLayer*)parent_ switchTo:1];
}

-(void) menuCallbackConfig:(id) sender
{
	[(CCMultiplexLayer*)parent_ switchTo:3];
}

-(void) menuCallbackDisabled:(id) sender {
}

-(void) menuCallbackEnable:(id) sender {
	disabledItem.isEnabled = ~disabledItem.isEnabled;
}

-(void) menuCallback2: (id) sender
{
	[(CCMultiplexLayer*)parent_ switchTo:2];
}

-(void) onQuit: (id) sender
{
	[[CCDirector sharedDirector] end];
	
	// HA HA... no more terminate on sdk v3.0
	// http://developer.apple.com/iphone/library/qa/qa2008/qa1561.html
	if( [[UIApplication sharedApplication] respondsToSelector:@selector(terminate)] )
		[[UIApplication sharedApplication] performSelector:@selector(terminate)];
	else
		NSLog(@"YOU CAN'T TERMINATE YOUR APPLICATION PROGRAMATICALLY in SDK 3.0+");
}
@end

#pragma mark -
#pragma mark StartMenu

@implementation Layer2

-(void) alignMenusH
{
	for(int i=0;i<2;i++) {
		CCMenu *menu = (CCMenu*)[self getChildByTag:100+i];
		menu.position = centeredMenu;
		if(i==0) {
			// TIP: if no padding, padding = 5
			[menu alignItemsHorizontally];			
			CGPoint p = menu.position;
			menu.position = ccpAdd(p, ccp(0,30));
			
		} else {
			// TIP: but padding is configurable
			[menu alignItemsHorizontallyWithPadding:40];
			CGPoint p = menu.position;
			menu.position = ccpSub(p, ccp(0,30));
		}		
	}
}

-(void) alignMenusV
{
	for(int i=0;i<2;i++) {
		CCMenu *menu = (CCMenu*)[self getChildByTag:100+i];
		menu.position = centeredMenu;
		if(i==0) {
			// TIP: if no padding, padding = 5
			[menu alignItemsVertically];			
			CGPoint p = menu.position;
			menu.position = ccpAdd(p, ccp(100,0));			
		} else {
			// TIP: but padding is configurable
			[menu alignItemsVerticallyWithPadding:40];	
			CGPoint p = menu.position;
			menu.position = ccpSub(p, ccp(100,0));
		}		
	}
}

-(id) init
{
	if( (self=[super init]) ) {
			
		for( int i=0;i < 2;i++ ) {
			CCMenuItemImage *item1 = [CCMenuItemImage itemFromNormalImage:@"btn-play-normal.png" selectedImage:@"btn-play-selected.png" target:self selector:@selector(menuCallbackBack:)];
			CCMenuItemImage *item2 = [CCMenuItemImage itemFromNormalImage:@"btn-highscores-normal.png" selectedImage:@"btn-highscores-selected.png" target:self selector:@selector(menuCallbackOpacity:)];
			CCMenuItemImage *item3 = [CCMenuItemImage itemFromNormalImage:@"btn-about-normal.png" selectedImage:@"btn-about-selected.png" target:self selector:@selector(menuCallbackAlign:)];
			
			item1.scaleX = 1.5f;
			item2.scaleY = 0.5f;
			item3.scaleX = 0.5f;
			
			CCMenu *menu = [CCMenu menuWithItems:item1, item2, item3, nil];
			
			menu.tag = kTagMenu;
			
			[self addChild:menu z:0 tag:100+i];
			centeredMenu = menu.position;
		}

		alignedH = YES;
		[self alignMenusH];
	}

	return self;
}

-(void) dealloc
{
	[super dealloc];
}

-(void) menuCallbackBack: (id) sender
{
	[(CCMultiplexLayer*)parent_ switchTo:0];
}

-(void) menuCallbackOpacity: (id) sender
{
	id menu = [sender parent];
	GLubyte opacity = [menu opacity];
	if( opacity == 128 )
		[menu setOpacity: 255];
	else
		[menu setOpacity: 128];	
}
-(void) menuCallbackAlign: (id) sender
{
	alignedH = ! alignedH;
	
	if( alignedH )
		[self alignMenusH];
	else
		[self alignMenusV];
}

@end

#pragma mark -
#pragma mark SendScores

@implementation Layer3
-(id) init
{
	if( (self=[super init]) ) {
		[CCMenuItemFont setFontName: @"Marker Felt"];
		[CCMenuItemFont setFontSize:28];

		CCBitmapFontAtlas *label = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"Enable AtlasItem" fntFile:@"bitmapFontTest3.fnt"];
		CCMenuItemLabel *item1 = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(menuCallback2:)];
		CCMenuItemFont *item2 = [CCMenuItemFont itemFromString: @"--- Go Back ---" target:self selector:@selector(menuCallback:)];
		
		CCSprite *spriteNormal = [CCSprite spriteWithFile:@"menuitemsprite.png" rect:CGRectMake(0,23*2,115,23)];
		CCSprite *spriteSelected = [CCSprite spriteWithFile:@"menuitemsprite.png" rect:CGRectMake(0,23*1,115,23)];
		CCSprite *spriteDisabled = [CCSprite spriteWithFile:@"menuitemsprite.png" rect:CGRectMake(0,23*0,115,23)];
		
		CCMenuItemSprite *item3 = [CCMenuItemSprite itemFromNormalSprite:spriteNormal selectedSprite:spriteSelected disabledSprite:spriteDisabled target:self selector:@selector(menuCallback3:)];
		disabledItem = item3;
		disabledItem.isEnabled = NO;
		
		CCMenu *menu = [CCMenu menuWithItems: item1, item2, item3, nil];	
		menu.position = ccp(0,0);
		
		CGSize s = [[CCDirector sharedDirector] winSize];
		
		item1.position = ccp(s.width/2 - 150, s.height/2);
		item2.position = ccp(s.width/2 - 200, s.height/2);
		item3.position = ccp(s.width/2, s.height/2 - 100);
		
		id jump = [CCJumpBy actionWithDuration:3 position:ccp(400,0) height:50 jumps:4];
		[item2 runAction: [CCRepeatForever actionWithAction:
					 [CCSequence actions: jump, [jump reverse], nil]
									   ]
		 ];
		id spin1 = [CCRotateBy actionWithDuration:3 angle:360];
		id spin2 = [[spin1 copy] autorelease];
		id spin3 = [[spin1 copy] autorelease];
		
		[item1 runAction: [CCRepeatForever actionWithAction:spin1]];
		[item2 runAction: [CCRepeatForever actionWithAction:spin2]];
		[item3 runAction: [CCRepeatForever actionWithAction:spin3]];
		
		[self addChild: menu];
	}
	
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

-(void) menuCallback: (id) sender
{
	[(CCMultiplexLayer*)parent_ switchTo:0];
}

-(void) menuCallback2: (id) sender
{
	NSLog(@"Label clicked. Toogling Sprite");
	disabledItem.isEnabled = ~disabledItem.isEnabled;
	[disabledItem stopAllActions];
}
-(void) menuCallback3:(id) sender
{
	NSLog(@"MenuItemSprite clicked");
}

@end


@implementation Layer4
-(id) init
{
	[super init];

	[CCMenuItemFont setFontName: @"American Typewriter"];
	[CCMenuItemFont setFontSize:18];
	CCMenuItemFont *title1 = [CCMenuItemFont itemFromString: @"Sound"];
    [title1 setIsEnabled:NO];
	[CCMenuItemFont setFontName: @"Marker Felt"];
	[CCMenuItemFont setFontSize:34];
    CCMenuItemToggle *item1 = [CCMenuItemToggle itemWithTarget:self selector:@selector(menuCallback:) items:
                             [CCMenuItemFont itemFromString: @"On"],
                             [CCMenuItemFont itemFromString: @"Off"],
                             nil];
    
	[CCMenuItemFont setFontName: @"American Typewriter"];
	[CCMenuItemFont setFontSize:18];
	CCMenuItemFont *title2 = [CCMenuItemFont itemFromString: @"Music"];
    [title2 setIsEnabled:NO];
	[CCMenuItemFont setFontName: @"Marker Felt"];
	[CCMenuItemFont setFontSize:34];
    CCMenuItemToggle *item2 = [CCMenuItemToggle itemWithTarget:self selector:@selector(menuCallback:) items:
                             [CCMenuItemFont itemFromString: @"On"],
                             [CCMenuItemFont itemFromString: @"Off"],
                             nil];
    
	[CCMenuItemFont setFontName: @"American Typewriter"];
	[CCMenuItemFont setFontSize:18];
	CCMenuItemFont *title3 = [CCMenuItemFont itemFromString: @"Quality"];
    [title3 setIsEnabled:NO];
	[CCMenuItemFont setFontName: @"Marker Felt"];
	[CCMenuItemFont setFontSize:34];
    CCMenuItemToggle *item3 = [CCMenuItemToggle itemWithTarget:self selector:@selector(menuCallback:) items:
                             [CCMenuItemFont itemFromString: @"High"],
                             [CCMenuItemFont itemFromString: @"Low"],
                             nil];
    
	[CCMenuItemFont setFontName: @"American Typewriter"];
	[CCMenuItemFont setFontSize:18];
	CCMenuItemFont *title4 = [CCMenuItemFont itemFromString: @"Orientation"];
    [title4 setIsEnabled:NO];
	[CCMenuItemFont setFontName: @"Marker Felt"];
	[CCMenuItemFont setFontSize:34];
    CCMenuItemToggle *item4 = [CCMenuItemToggle itemWithTarget:self selector:@selector(menuCallback:) items:
                             [CCMenuItemFont itemFromString: @"Off"], nil];
	
	NSArray *more_items = [NSArray arrayWithObjects:
                             [CCMenuItemFont itemFromString: @"33%"],
                             [CCMenuItemFont itemFromString: @"66%"],
                             [CCMenuItemFont itemFromString: @"100%"],
                             nil];
	// TIP: you can manipulate the items like any other NSMutableArray
	[item4.subItems addObjectsFromArray: more_items];
	
    // you can change the one of the items by doing this
    item4.selectedIndex = 2;
    
    [CCMenuItemFont setFontName: @"Marker Felt"];
	[CCMenuItemFont setFontSize:34];
	
	CCBitmapFontAtlas *label = [CCBitmapFontAtlas bitmapFontAtlasWithString:@"go back" fntFile:@"bitmapFontTest3.fnt"];
	CCMenuItemLabel *back = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(backCallback:)];
    
	CCMenu *menu = [CCMenu menuWithItems:
                  title1, title2,
                  item1, item2,
                  title3, title4,
                  item3, item4,
                  back, nil]; // 9 items.
    [menu alignItemsInColumns:
     [NSNumber numberWithUnsignedInt:2],
     [NSNumber numberWithUnsignedInt:2],
     [NSNumber numberWithUnsignedInt:2],
     [NSNumber numberWithUnsignedInt:2],
     [NSNumber numberWithUnsignedInt:1],
     nil
    ]; // 2 + 2 + 2 + 2 + 1 = total count of 9.
    
	[self addChild: menu];
	
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

-(void) menuCallback: (id) sender
{
	NSLog(@"selected item: %@ index:%d", [sender selectedItem], [sender selectedIndex] );
}

-(void) backCallback: (id) sender
{
	[(CCMultiplexLayer*)parent_ switchTo:0];
}

@end



// CLASS IMPLEMENTATIONS
@implementation AppController

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// must be called before any othe call to the director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeMainLoop];
	
	// before creating any layer, set the landscape mode
	[[CCDirector sharedDirector] setDeviceOrientation: CCDeviceOrientationLandscapeRight];

	// show FPS
	[[CCDirector sharedDirector] setDisplayFPS:YES];

	// multiple touches or not ?
//	[[Director sharedDirector] setMultipleTouchEnabled:YES];
	
	// frames per second
	[[CCDirector sharedDirector] setAnimationInterval:1.0/60];	

	// attach cocos2d to a window
	[[CCDirector sharedDirector] attachInView:window];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];	

	CCScene *scene = [CCScene node];

	CCMultiplexLayer *layer = [CCMultiplexLayer layerWithLayers: [Layer1 node], [Layer2 node], [Layer3 node], [Layer4 node], nil];
	[scene addChild: layer z:0];

	[window makeKeyAndVisible];
	[[CCDirector sharedDirector] runWithScene: scene];
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] resume];
}

// purge memroy
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCTextureCache sharedTextureCache] removeAllTextures];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window dealloc];
	[super dealloc];
}

@end
