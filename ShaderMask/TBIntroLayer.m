//
//  TBIntroLayer.m
//  ShaderMask
//
//  Created by Tony BELTRAMELLI on 26/01/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
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

-(void) onEnter
{
	[super onEnter];

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
	[self scheduleOnce:@selector(makeTransition:) delay:1];
}

-(void) makeTransition:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TBMainLayer scene] withColor:ccWHITE]];
}
@end
