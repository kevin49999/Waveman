//
//  MyScene.h
//  SpriteGuy
//

//  Copyright (c) 2015 kevinjohnson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Player.h"

@interface MyScene : SKScene

@property (strong, nonatomic) Player *player;
@property (nonatomic,assign) BOOL playerDead;
@property (nonatomic, assign) NSTimeInterval time;
@property (strong, nonatomic) SKLabelNode *timeLabel;

@end
