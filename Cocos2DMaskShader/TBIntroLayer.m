//
//  TBIntroLayer.m
//  Cocos2DMaskShader
//
//  Created by tony's computer on 27/09/13.
//  Copyright Tony BELTRAMELLI 2013. All rights reserved.
//


#import "TBIntroLayer.h"
#import "TBMainLayer.h"


@implementation TBIntroLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	TBIntroLayer *layer = [TBIntroLayer node];
	
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init]))
    {
		CGSize size = [[CCDirector sharedDirector] winSize];

		CCSprite *background;
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"Default.png"];
			background.rotation = 90;
		} else {
			background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
		}
		background.position = ccp(size.width/2, size.height/2);
        
		[self addChild: background];
	}
	
	return self;
}

-(void) onEnter
{
	[super onEnter];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TBMainLayer scene]]];
}
@end
