//
//  TBSpriteMask.m
//  ShaderMask
//
//  Created by Tony BELTRAMELLI on 26/01/13.
//
//

#import "TBSpriteMask.h"

#define DRAW_SETUP()                                                                \
do {                                                                                \
    ccGLEnable( _mask.glServerState );                                              \
    NSAssert1(_mask.shaderProgram, @"No shader program set for node: %@", _mask);   \
    [_mask.shaderProgram use];                                                      \
    [_mask.shaderProgram setUniformForModelViewProjectionMatrix];                   \
} while(0)                                                                          \

@implementation TBSpriteMask

-(id) initWithSprite:(CCSprite*)sprite andMaskSprite:(CCSprite*)maskSprite
{
    return [self initWithSprite:sprite andMaskSprite:maskSprite andType:FALSE];
}

-(id) initWithSprite:(CCSprite*)sprite andMaskFile:(NSString*)maskFile
{
    return [self initWithSprite:sprite andMaskFile:maskFile andType:FALSE];
}

-(id) initWithFile:(NSString *)file andMaskSprite:(CCSprite*)maskSprite
{
    return [self initWithFile:file andMaskSprite:maskSprite andType:FALSE];
}

-(id) initWithFile:(NSString *)file andMaskFile:(NSString*)maskFile;
{
    return [self initWithFile:file andMaskFile:maskFile andType:FALSE];
}

-(id) initWithSprite:(CCSprite*)sprite andMaskSprite:(CCSprite*)maskSprite andType:(BOOL)type;
{
    self = [super init];
    if (self) {
        _mask = [sprite retain];
        _type = type;
        [self builtWithTexture:_mask andTexture:[[maskSprite texture] retain]];
    }
    return self;
}

-(id) initWithSprite:(CCSprite*)sprite andMaskFile:(NSString*)maskFile andType:(BOOL)type;
{
    self = [super init];
    if(self){
        _mask = [sprite retain];
        _type = type;
        [self builtWithTexture:_mask andTexture:[[CCTextureCache sharedTextureCache] addImage:maskFile]];
    }    
    return self;
}

-(id) initWithFile:(NSString *)file andMaskSprite:(CCSprite*)maskSprite andType:(BOOL)type;
{
    self = [super init];
    if (self) {
        _mask = [[CCSprite alloc] initWithFile:file];
        _type = type;
        [self builtWithTexture:_mask andTexture:[[maskSprite texture] retain]];
    }
    return self;
}

-(id) initWithFile:(NSString *)file andMaskFile:(NSString*)maskFile andType:(BOOL)type;
{
    self = [super init];
    if (self) {
        _mask = [[CCSprite alloc] initWithFile:file];
        _type = type;
        [self builtWithTexture:_mask andTexture:[[CCTextureCache sharedTextureCache] addImage:maskFile]];
    }    
    return self;
}

- (void)builtWithTexture:(CCSprite *)mask andTexture:(CCTexture2D*)texture
{
    [_mask setAnchorPoint:CGPointZero];
    [self buildMaskWithTexture:texture];
}

-(void) buildMaskWithTexture:(CCTexture2D*)texture
{
    NSString *shaderName =  _type ? @"MaskPositive.fsh" : @"MaskNegative.fsh";
    const GLchar * fragmentSource = (GLchar*) [[NSString stringWithContentsOfFile:[[CCFileUtils sharedFileUtils] fullPathFromRelativePath:shaderName] encoding:NSUTF8StringEncoding error:nil] UTF8String];
    
    _mask.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTextureA8Color_vert
                                                    fragmentShaderByteArray:fragmentSource];
    [_mask.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
    [_mask.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
    [_mask.shaderProgram addAttribute:kCCAttributeNameColor index:kCCVertexAttrib_Color];
    [_mask.shaderProgram link];
    [_mask.shaderProgram updateUniforms];
    
    _maskLocation = glGetUniformLocation(_mask.shaderProgram->program_, "u_overlayTexture");
    glUniform1i(_maskLocation, 1);
    _maskTexture = texture;
    [_maskTexture setAliasTexParameters];
    
    [_mask.shaderProgram use];
    ccGLBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, [_maskTexture name]);
    glActiveTexture(GL_TEXTURE0);
}

-(void) draw
{    
    DRAW_SETUP();
    
    ccGLEnableVertexAttribs(kCCVertexAttribFlag_PosColorTex);
    ccGLBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [_mask.shaderProgram setUniformForModelViewProjectionMatrix];
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture( GL_TEXTURE_2D, [_mask.texture name] );
    glUniform1i(_textureLocation, 0);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture( GL_TEXTURE_2D, [_maskTexture name] );
    glUniform1i(_maskLocation, 1);
    
    #define kQuadSize sizeof(_mask.quad.bl)
    ccV3F_C4B_T2F_Quad q = _mask.quad;
    long offset = (long)&q;
    
    NSInteger diff = offsetof( ccV3F_C4B_T2F, vertices);
    glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, kQuadSize, (void*) (offset + diff));
    
    diff = offsetof( ccV3F_C4B_T2F, texCoords);
    glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, kQuadSize, (void*)(offset + diff));
    
    diff = offsetof( ccV3F_C4B_T2F, colors);
    glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_UNSIGNED_BYTE, GL_TRUE, kQuadSize, (void*)(offset + diff));
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glActiveTexture(GL_TEXTURE0);
}

-(void)updateWithSprite:(CCSprite*)sprite
{
    [_mask.shaderProgram release];
    [_mask release];
    _mask = nil;
    
    _mask = [sprite retain];
    [self builtWithTexture:_mask andTexture:_maskTexture];
}

-(void)updateWithFile:(NSString *)file
{
    [self updateWithSprite:[[CCSprite alloc] initWithFile:file]];
}

-(CCTexture2D *)getTexture
{
    CCRenderTexture *renderTexture = [CCRenderTexture renderTextureWithWidth:_mask.contentSize.width height:_mask.contentSize.height];
    [renderTexture begin];
    _mask.flipY = YES;
    [_mask draw];
    _mask.flipY = NO;
    [renderTexture end];
    
    return renderTexture.sprite.texture;
}

- (void)dealloc
{
    [_mask release];
    _mask = nil;
    
    [_maskTexture release];
    _maskTexture = nil;
    
    [_mask.shaderProgram release];
    
    [super dealloc];
}

@end
