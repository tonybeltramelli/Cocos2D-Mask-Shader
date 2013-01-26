//
//  TBSpriteMask.m
//  ShaderMask
//
//  Created by Tony BELTRAMELLI on 26/01/13.
//
//

#import "TBSpriteMask.h"

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
    self = [(TBSpriteMask *)sprite retain];
    if (self) {
        _type = type;
        [self buildMaskWithTexture:[[maskSprite texture] retain]];
    }
    
    return self;
}

-(id) initWithSprite:(CCSprite*)sprite andMaskFile:(NSString*)maskFile andType:(BOOL)type;
{
    self = [(TBSpriteMask *)sprite retain];
    if(self){
        _type = type;
        [self buildMaskWithTexture:[[CCTextureCache sharedTextureCache] addImage:maskFile]];
    }
    return self;
}

-(id) initWithFile:(NSString *)file andMaskSprite:(CCSprite*)maskSprite andType:(BOOL)type;
{
    self = [super initWithFile:file];
    if (self) {
        _type = type;
        [self buildMaskWithTexture:[[maskSprite texture] retain]];
    }
    
    return self;
}

-(id) initWithFile:(NSString *)file andMaskFile:(NSString*)maskFile andType:(BOOL)type;
{
    self = [super initWithFile:file];
    if (self) {
        _type = type;
        [self buildMaskWithTexture:[[CCTextureCache sharedTextureCache] addImage:maskFile]];
    }
    
    return self;
}

-(void) buildMaskWithTexture:(CCTexture2D*)texture
{
    NSString *shaderName =  _type ? @"MaskPositive.fsh" : @"MaskNegative.fsh";
    const GLchar * fragmentSource = (GLchar*) [[NSString stringWithContentsOfFile:[[CCFileUtils sharedFileUtils] fullPathFromRelativePath:shaderName] encoding:NSUTF8StringEncoding error:nil] UTF8String];
    
    self.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTextureA8Color_vert
                                                    fragmentShaderByteArray:fragmentSource];
    [self.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
    [self.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
    [self.shaderProgram addAttribute:kCCAttributeNameColor index:kCCVertexAttrib_Color];
    [self.shaderProgram link];
    [self.shaderProgram updateUniforms];
    
    _maskLocation = glGetUniformLocation(self.shaderProgram->program_, "u_overlayTexture");
    glUniform1i(_maskLocation, 1);
    _maskTexture = texture;
    [_maskTexture setAliasTexParameters];
    
    [self.shaderProgram use];
    ccGLBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, [_maskTexture name]);
    glActiveTexture(GL_TEXTURE0);
}

-(void) draw
{    
    CC_NODE_DRAW_SETUP();
    
    ccGLEnableVertexAttribs(kCCVertexAttribFlag_PosColorTex);
    ccGLBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [shaderProgram_ setUniformForModelViewProjectionMatrix];
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture( GL_TEXTURE_2D, [texture_ name] );
    glUniform1i(_textureLocation, 0);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture( GL_TEXTURE_2D, [_maskTexture name] );
    glUniform1i(_maskLocation, 1);
    
    #define kQuadSize sizeof(quad_.bl)
    long offset = (long)&quad_;
    
    NSInteger diff = offsetof( ccV3F_C4B_T2F, vertices);
    glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, kQuadSize, (void*) (offset + diff));
    
    diff = offsetof( ccV3F_C4B_T2F, texCoords);
    glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, kQuadSize, (void*)(offset + diff));
    
    diff = offsetof( ccV3F_C4B_T2F, colors);
    glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_UNSIGNED_BYTE, GL_TRUE, kQuadSize, (void*)(offset + diff));
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glActiveTexture(GL_TEXTURE0);
}

- (void)dealloc
{
    [_maskTexture release];
    [shaderProgram_ release];
    
    [super dealloc];
}

@end
