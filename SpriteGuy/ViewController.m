//
//  ViewController.m
//  SpriteGuy
//
//  Created by Kevin Johnson on 8/5/15.
//  Copyright (c) 2015 kevinjohnson. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "IntroScene.h"
#import "GasStationOne.h"
#import "LevelThree.h"
#import "LevelTwo.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    // Create and configure the scene
    
    SKScene * scene = [IntroScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}


// changes from NSUInteger
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;

    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
