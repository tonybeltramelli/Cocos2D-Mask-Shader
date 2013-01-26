//
//  TBMainLayer.m
//  ShaderMask
//
//  Created by Tony BELTRAMELLI on 26/01/13.
//
//

#import "TBMainLayer.h"
#import "TBSpriteMask.h"

@implementation TBMainLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	
	TBMainLayer *layer = [TBMainLayer node];
	
	[scene addChild: layer];
	return scene;
}

- (id)init
{
    self = [super init];
    if (self) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        // EXAMPLES MaskNegative
        //
        // example 1
        /*
        CCSprite *spriteToMask = [CCSprite spriteWithFile:@"image_to_mask.jpg"];
        CCSprite *spriteMask = [TBSpriteMask spriteWithFile:@"mask.png"];
        
        TBSpriteMask *maskedSprite = [[TBSpriteMask alloc] initWithSprite:spriteMask andMaskSprite:spriteToMask];
        maskedSprite.position = ccp(size.width/2, size.height/2);
        [self addChild:maskedSprite];
        */
        // example 2
        /*
        CCSprite *spriteMask = [TBSpriteMask spriteWithFile:@"mask.png"];
        
        TBSpriteMask *maskedSprite = [[TBSpriteMask alloc] initWithSprite:spriteMask andMaskFile:@"image_to_mask.jpg"];
        maskedSprite.position = ccp(size.width/2, size.height/2);
        [self addChild:maskedSprite];
        */
        // example 3
        /*
        CCSprite *spriteToMask = [CCSprite spriteWithFile:@"image_to_mask.jpg"];
        
        TBSpriteMask *maskedSprite = [[TBSpriteMask alloc] initWithFile:@"mask.png" andMaskSprite:spriteToMask];
        maskedSprite.position = ccp(size.width/2, size.height/2);
        [self addChild:maskedSprite];
         */
        // example 4
        /*
        TBSpriteMask *maskedSprite = [[TBSpriteMask alloc] initWithFile:@"mask.png" andMaskFile:@"image_to_mask.jpg"];
        maskedSprite.position = ccp(size.width/2, size.height/2);
        [self addChild:maskedSprite];
        */
        //
        // EXAMPLES MaskPositive
        //
        // example 1
        /*
        CCSprite *spriteToMask = [CCSprite spriteWithFile:@"image_to_mask.jpg"];
        CCSprite *spriteMask = [TBSpriteMask spriteWithFile:@"mask.png"];
         
        TBSpriteMask *maskedSprite = [[TBSpriteMask alloc] initWithSprite:spriteMask andMaskSprite:spriteToMask andType:TRUE];
        maskedSprite.position = ccp(size.width/2, size.height/2);
        [self addChild:maskedSprite];
        */
        // example 2
        /*
        CCSprite *spriteMask = [TBSpriteMask spriteWithFile:@"mask.png"];
         
        TBSpriteMask *maskedSprite = [[TBSpriteMask alloc] initWithSprite:spriteMask andMaskFile:@"image_to_mask.jpg" andType:TRUE];
        maskedSprite.position = ccp(size.width/2, size.height/2);
        [self addChild:maskedSprite];
        */
        // example 3
        /*
        CCSprite *spriteToMask = [CCSprite spriteWithFile:@"image_to_mask.jpg"];
         
        TBSpriteMask *maskedSprite = [[TBSpriteMask alloc] initWithFile:@"mask.png" andMaskSprite:spriteToMask andType:TRUE];
        maskedSprite.position = ccp(size.width/2, size.height/2);
        [self addChild:maskedSprite];
        */ 
        // example 4
        /*
        TBSpriteMask *maskedSprite = [[TBSpriteMask alloc] initWithFile:@"mask.png" andMaskFile:@"image_to_mask.jpg" andType:TRUE];
        maskedSprite.position = ccp(size.width/2, size.height/2);
        [self addChild:maskedSprite];
        */
        
        TBSpriteMask *maskedSpriteNegative = [[TBSpriteMask alloc] initWithFile:@"mask.png" andMaskFile:@"image_to_mask.jpg"];
        maskedSpriteNegative.scale = 0.5;
        maskedSpriteNegative.position = ccp(size.width/2 + 90, size.height/2 + 90);
        [self addChild:maskedSpriteNegative];
            
        TBSpriteMask *maskedSpritePositive = [[TBSpriteMask alloc] initWithFile:@"mask.png" andMaskFile:@"image_to_mask.jpg" andType:TRUE];
        maskedSpritePositive.scale = 0.5;
        maskedSpritePositive.position = ccp(size.width/2 - 90, size.height/2 - 90);
        [self addChild:maskedSpritePositive];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
