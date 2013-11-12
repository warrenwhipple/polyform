//
//  PFViewController.mm
//  Polyform
//
//  Created by Warren Whipple on 12/19/12.
//  Copyright (c) 2012 Warren Whipple. All rights reserved.
//

#import "PFViewController.h"
#import "GLProgram.h"
#import "PFVertHandler.h"
#import "PFAudioHandler.h"
#import "PFCamera.h"
#import "PFLabel.h"
#import "PFTitleScene.h"
#import "PFMenuScene.h"
#import "PFGameScene.h"

@implementation PFViewController
{
    int _launchImageDelay;
    UIImageView *_launchImageView;
    
    id<PFScene> _currentScene;
    
    EAGLContext *_context;
    GLProgram *_program;
    GLuint _positionAttribute;
    GLuint _transformAttribute;
    GLuint _colorAttribute;
    GLuint _modelViewMatrixUniform;
    PFVertHandler *_vertHandler;
    
    GLKBaseEffect *_effect;
    
    PFAudioHandler *_audioHandler;
    int _instruments;
    
    UILabel *_helloLabel;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _launchImageDelay = LAUNCH_ANIMATION_DELAY;
    UIImage *launchImage;
    CGSize screenSize = self.view.bounds.size;
    UIDevice *device = [UIDevice currentDevice];
    if (device.userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        if (screenSize.height > 480.0f) launchImage = [UIImage imageNamed:@"Default-568h.png"];
        else launchImage = [UIImage imageNamed:@"Default.png"];
    }
    else if (device.userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        if (UIDeviceOrientationIsPortrait(device.orientation)) launchImage = [UIImage imageNamed:@"Default-Portrait.png"];
        else if (UIDeviceOrientationIsLandscape(device.orientation)) launchImage = [UIImage imageNamed:@"Default-Landscape.png"];
    }
    _launchImageView = [[UIImageView alloc] initWithImage:launchImage];
    [self.view addSubview:_launchImageView];
    self.preferredFramesPerSecond = FRAMERATE;
    [PFLabel bindGLKView:self.view];
}


- (void)viewDidLoad
{     
    CGSize screenSize = self.view.bounds.size;
    _launchImageView.center = CGPointMake(screenSize.width/2.0f, screenSize.height/2.0f);
    [super viewDidLoad];
    [PFCamera linkView:self.view];
    _currentScene = [[PFTitleScene alloc] init];
    _vertHandler = [[PFVertHandler alloc] init];
    [_vertHandler loadModelsForSceneType:PFSceneTypeTitle];
    //_audioHandler = [[PFAudioHandler alloc] init];
    [self setupGL];    
}

- (void)dealloc
{    
    [self tearDownGL];
    if ([EAGLContext currentContext] == _context) [EAGLContext setCurrentContext:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == _context) {
            [EAGLContext setCurrentContext:nil];
        }
        _context = nil;
    }
    // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!_context) NSLog(@"Failed to create ES context");
    GLKView *view = (GLKView *)self.view;
    view.context = _context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormatNone;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGB565;
    view.drawableMultisample = GLKViewDrawableMultisample4X;
    //view.drawableMultisample = GLKViewDrawableMultisampleNone;
    [EAGLContext setCurrentContext:_context];
    
    _program = [[GLProgram alloc] initWithVertexShaderFilename:@"Shader"
                                        fragmentShaderFilename:@"Shader"];
    [_program addAttribute:@"position"];
    [_program addAttribute:@"transform"];
    [_program addAttribute:@"color"];
    
    if (![_program link])
    {
        NSLog(@"Link failed");        
        NSString *progLog = [_program programLog];
        NSLog(@"Program Log: %@", progLog);
        NSString *fragLog = [_program fragmentShaderLog];
        NSLog(@"Frag Log: %@", fragLog);
        NSString *vertLog = [_program vertexShaderLog];
        NSLog(@"Vert Log: %@", vertLog);
        _program = nil;
    }
    
    _positionAttribute = [_program attributeIndex:@"position"];
    _transformAttribute = [_program attributeIndex:@"transform"];
    _colorAttribute = [_program attributeIndex:@"color"];
    _modelViewMatrixUniform = [_program uniformIndex:@"modelViewMatrix"];

    _effect = [[GLKBaseEffect alloc] init];
    
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:_context];
    _effect = nil;
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    // count down launchImageDelay then remove launchImageView
    if (_launchImageView)
    {
        if (!_launchImageDelay)
        {
            [_launchImageView removeFromSuperview];
            _launchImageView = nil;
        }
        else _launchImageDelay--;
    }
    
    if (_currentScene.state == PFSceneStateExitComplete)
    {
        [_vertHandler changeLineBrightness:1.0f];
        PFSceneType nextSceneType = _currentScene.nextSceneType;
        PFRuleSet nextRuleSet;
        if (nextSceneType == PFSceneTypeGame) nextRuleSet = _currentScene.nextRuleSet;
        _currentScene = nil;
        [_vertHandler unloadAllModels];
        [_vertHandler loadModelsForSceneType:nextSceneType];
        switch (nextSceneType)
        {
            case PFSceneTypeTitle:
            {
                _currentScene = [[PFTitleScene alloc] init];
            } break;
            case PFSceneTypeMenu:
            {
                _currentScene = [[PFMenuScene alloc] init];
            } break;
            case PFSceneTypeGame:
            {
                _currentScene = [[PFGameScene alloc] initWithRuleSet:nextRuleSet];
                [_vertHandler loadModelsForBrickGenus:nextRuleSet.brickGenus];
                [_vertHandler loadModelsForSmallCirclePoints:48 largeCirclePoints:64];
            } break;
        }
    }
    
    [_currentScene update];
    [_audioHandler updateWithInstrumentDistribution:nil];
    [_vertHandler resetDraw];
    [_currentScene writeToVertHandler:_vertHandler];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    _effect.transform.projectionMatrix = _currentScene.camera.projection;
    [_effect prepareToDraw];
    
    if (_vertHandler.bubbleVertCount > 0)
    {
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(PFAlignedVert), _vertHandler.bubbleVerts);
        
        glEnableVertexAttribArray(GLKVertexAttribColor);
        glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(PFAlignedVert), &_vertHandler.bubbleVerts[0].r);
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, _vertHandler.bubbleVertCount);
    }
    
    if (_vertHandler.vertCount > 0)
    {
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(PFAlignedVert), _vertHandler.verts);
        
        glEnableVertexAttribArray(GLKVertexAttribColor);
        glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(PFAlignedVert), &_vertHandler.verts[0].r);
        
        glDrawElements(GL_TRIANGLES, _vertHandler.indexCount, GL_UNSIGNED_SHORT, _vertHandler.indices);
    }    
}

#pragma mark - UIResponder touch methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_currentScene touchesBegan:touches];
}

// Everything after touchesBegan: is handled during glView:drawInRect method
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {}

#pragma mark - UIViewController autorotation methods

// iOS 6.0 and up
- (BOOL)shouldAutorotate {return YES;}
- (NSUInteger)supportedInterfaceOrientations {return  UIInterfaceOrientationMaskAll;}
// iOS 5.1 and down
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {return YES;}

- (BOOL)prefersStatusBarHidden
{    
    return YES;
}

@end
