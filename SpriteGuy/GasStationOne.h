//
//  GasStationOne.h
//  SpriteGuy
//
//  Created by Kevin Johnson on 9/8/15.
//  Copyright (c) 2015 kevinjohnson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Player.h"

@interface GasStationOne : SKScene

@property (strong, nonatomic) NSMutableArray *cases;
@property (strong, nonatomic) SKSpriteNode *counter;
@property (strong, nonatomic) Player *player;

@end
