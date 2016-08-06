//
//  GasStationTwo.m
//  SpriteGuy
//
//  Created by Kevin Johnson on 9/13/15.
//  Copyright (c) 2015 kevinjohnson. All rights reserved.
//

#import "GasStationTwo.h"
#import "LevelThree.h"


@implementation GasStationTwo

-(NSString *)setText
{
    NSString *text = @"Still nothing for you! Move along";
    return text;
}

-(void)goToNextLevel
{
    LevelThree *nextLevel = [[LevelThree alloc] initWithSize:self.frame.size];
    [self.scene.view presentScene:nextLevel];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(skipTalk)
               withObject:self
               afterDelay:0.5];
}

-(void)skipTalk
{
    [self.view presentScene:[[LevelThree alloc] initWithSize:self.size]];
}

@end
