//
//  TBMainLayer.m
//  Cocos2DMaskShader
//
//  Created by tony's computer on 27/09/13.
//  Copyright (c) 2013 Tony BELTRAMELLI. All rights reserved.
//

#import "TBMainLayer.h"
#import "TBSpriteMask.h"

@implementation TBMainLayer
{
    TBSpriteMask *_maskedSpriteNegative;
    TBSpriteMask *_maskedSpritePositive;
    
    BOOL _isFirstMask;
}

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
    if (self)
    {
        #ifdef __CC_PLATFORM_IOS
            self.touchEnabled = YES;
        #elif defined(__CC_PLATFORM_MAC)
            self.isMouseEnabled = YES;
        #endif
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        // EXAMPLES MaskNegative
        //
        // example 1
        /*
         CCSprite *spriteToMask = [CCSprite spriteWithFile:@"image_to_mask.jpg"];
         CCSprite *spriteMask = [CCSprite spriteWithFile:@"mask.png"];
         
         TBSpriteMask *maskedSprite = [[TBSpriteMask alloc] initWithSprite:spriteMask andMaskSprite:spriteToMask];
         [self addChild:maskedSprite];
         */
        // example 2
        /*
         CCSprite *spriteMask = [CCSprite spriteWithFile:@"mask.png"];
         
         TBSpriteMask *maskedSprite = [[TBSpriteMask alloc] initWithSprite:spriteMask andMaskFile:@"image_to_mask.jpg"];
         [self addChild:maskedSprite];
         */
        // example 3
        /*
         CCSprite *spriteToMask = [CCSprite spriteWithFile:@"image_to_mask.jpg"];
         
         TBSpriteMask *maskedSprite = [[TBSpriteMask alloc] initWithFile:@"mask.png" andMaskSprite:spriteToMask];
         [self addChild:maskedSprite];
         */
        // example 4
        /*
         TBSpriteMask *maskedSprite = [[TBSpriteMask alloc] initWithFile:@"mask.png" andMaskFile:@"image_to_mask.jpg"];
         [self addChild:maskedSprite];
         */
        //
        // EXAMPLES MaskPositive
        //
        // example 1
        /*
         CCSprite *spriteToMask = [CCSprite spriteWithFile:@"image_to_mask.jpg"];
         CCSprite *spriteMask = [CCSprite spriteWithFile:@"mask.png"];
         
         TBSpriteMask *maskedSprite = [[TBSpriteMask alloc] initWithSprite:spriteMask andMaskSprite:spriteToMask andType:TRUE];
         [self addChild:maskedSprite];
         */
        // example 2
        /*
         CCSprite *spriteMask = [CCSprite spriteWithFile:@"mask.png"];
         
         TBSpriteMask *maskedSprite = [[TBSpriteMask alloc] initWithSprite:spriteMask andMaskFile:@"image_to_mask.jpg" andType:TRUE];
         [self addChild:maskedSprite];
         */
        // example 3
        /*
         CCSprite *spriteToMask = [CCSprite spriteWithFile:@"image_to_mask.jpg"];
         
         TBSpriteMask *maskedSprite = [[TBSpriteMask alloc] initWithFile:@"mask.png" andMaskSprite:spriteToMask andType:TRUE];
         [self addChild:maskedSprite];
         */
        // example 4
        /*
         TBSpriteMask *maskedSprite = [[TBSpriteMask alloc] initWithFile:@"mask.png" andMaskFile:@"image_to_mask.jpg" andType:TRUE];
         [self addChild:maskedSprite];
         */
        
        _maskedSpriteNegative = [[TBSpriteMask alloc] initWithFile:@"mask.png" andMaskFile:@"image_to_mask.jpg"];
        _maskedSpriteNegative.scale = 0.5;
        [self addChild:_maskedSpriteNegative];
        
        _maskedSpritePositive = [[TBSpriteMask alloc] initWithFile:@"mask.png" andMaskFile:@"image_to_mask.jpg" andType:TRUE];
        _maskedSpritePositive.scale = 0.5;
        _maskedSpritePositive.position = ccp(size.width/2, size.height/2);
        [self addChild:_maskedSpritePositive];
        
        // Create sprite with resulting texture
        //
        /*
        CCSprite *resultingSprite = [CCSprite spriteWithTexture:[_maskedSpriteNegative getTexture]];
        resultingSprite.scale = 0.5;
        resultingSprite.position = ccp(size.width/2, size.height/2);
        [self addChild:resultingSprite];
         */
        
        _isFirstMask = TRUE;
    }
    return self;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for( UITouch *touch in touches )
    {
        // EXAMPLES update
        //
        // example 1
        /*
         CCSprite *spriteMask = [CCSprite spriteWithFile:@"mask.png"];
         [maskedSprite updateWithSprite:spriteMask];
         */
        // example 2
        /*
         [maskedSprite updateWithFile:@"mask.png"];
         */
        
        if(_isFirstMask)
        {
            _isFirstMask = FALSE;
            [_maskedSpriteNegative updateWithFile:@"mask2.png"];
            [_maskedSpritePositive updateWithFile:@"mask2.png"];
        }else{
            _isFirstMask = TRUE;
            [_maskedSpriteNegative updateWithFile:@"mask.png"];
            [_maskedSpritePositive updateWithFile:@"mask.png"];
        }
    }
}

- (void)dealloc
{
    [_maskedSpriteNegative release];
    _maskedSpriteNegative = nil;
    
    [_maskedSpritePositive release];
    _maskedSpritePositive = nil;
    
    [super dealloc];
}

@end
