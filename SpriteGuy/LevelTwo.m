//
//  LevelTwo.m
//  SpriteGuy
//
//  Created by Kevin Johnson on 9/12/15.
//  Copyright (c) 2015 kevinjohnson. All rights reserved.
//

#import "LevelTwo.h"
#import "GasStationTwo.h"

@interface LevelTwo () <SKPhysicsContactDelegate>


@end
 
@implementation LevelTwo


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.time = 900; // 900
        self.name = @"level2";
        
        //backgroundcolor
        self.backgroundColor = [SKColor colorWithRed:0.3882 green:0.3294 blue:.5490 alpha:1.0];
        
        //different time label color (level 3 background)
        self.timeLabel.fontColor = [SKColor colorWithRed:0.6275 green:0.5294 blue:0.8863 alpha:1.0];
    }
    return self;
}

-(void)goToGasStation
{
  if (self.playerDead == NO){
        GasStationTwo *newScene = [[GasStationTwo alloc] initWithSize:self.frame.size];
        [self.scene.view presentScene:newScene];
    }
   
}

@end
