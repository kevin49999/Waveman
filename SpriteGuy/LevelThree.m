//
//  LevelThree.m
//  SpriteGuy
//
//  Created by Kevin Johnson on 9/13/15.
//  Copyright (c) 2015 kevinjohnson. All rights reserved.
//

#import "LevelThree.h"
#import "GasStationThree.h"

@implementation LevelThree

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.time = 1080; // 1080
        self.name = @"level3";
        //backgroundcolor
        self.backgroundColor = [SKColor colorWithRed:0.2353 green:0.2 blue:0.3333 alpha:1.0];
        
        //timelabel color
        self.timeLabel.fontColor = [SKColor blackColor];
    }
    return self;
}

-(void)goToGasStation
{
    if (self.playerDead == NO){
        GasStationThree *newScene = [[GasStationThree alloc] initWithSize:self.frame.size];
        [self.scene.view presentScene:newScene];
    }
    
}

@end
