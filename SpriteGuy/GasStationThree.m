//
//  GasStationThree.m
//  SpriteGuy
//
//  Created by Kevin Johnson on 9/13/15.
//  Copyright (c) 2015 kevinjohnson. All rights reserved.
//

#import "GasStationThree.h"
#import "MyScene.h"
#import "IntroScene.h"

@implementation GasStationThree

-(NSString *)setText
{
    NSString *text = @"You are persistent! You win";
    return text;
}

-(void)goToNextLevel
{
   // GAME OVER (don't have to override this method, just here CALLED AFTER 8
}

-(void)playerTransitions
{
   // called after 3 seconds
    [self youWin];
}

-(void)youWin
{
    //get rid of background sprites
    for (SKSpriteNode *wall in self.cases)
    {
        [wall removeFromParent];
    }
    
    // victory beverage
    SKTexture *victoryBeverage = [SKTexture textureWithImageNamed:@"victory40"];
    victoryBeverage.filteringMode = SKTextureFilteringNearest;
    SKSpriteNode *victory = [SKSpriteNode spriteNodeWithTexture:victoryBeverage];
    victory.name = @"victoryNode";//how the node is identified later
    // http://stackoverflow.com/questions/19082202/setting-up-buttons-in-skscene
    [victory setScale:4.0];
    victory.position = CGPointMake(self.size.width/4*3 - 15, 175);
    
    
    // actions beverage
    SKAction *moveBeverage = [SKAction moveTo:CGPointMake(self.size.width/2, self.size.height/2 + 50) duration:1.0]; // above button
    SKAction *rotation = [SKAction rotateByAngle: M_PI*2 duration:1];
    [victory runAction:rotation];
    
    //make glow
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"victory401"];
    texture1.filteringMode = SKTextureFilteringNearest;
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"victory402"];
    texture2.filteringMode = SKTextureFilteringNearest;
    SKTexture *texture3 = [SKTexture textureWithImageNamed:@"victory403"];
    texture3.filteringMode = SKTextureFilteringNearest;
    
    SKAction *glow = [SKAction repeatActionForever:[SKAction animateWithTextures:@[victoryBeverage, texture1, texture2, texture3] timePerFrame:0.35]];
    
    SKAction *sequence = [SKAction sequence:@[moveBeverage, glow]];
    [victory runAction:sequence];

    [self addChild:victory];
    
    // animate spriteman smiling
    SKTexture *smilingFace = [SKTexture textureWithImageNamed:@"spritemanhappy5"];
    smilingFace.filteringMode = SKTextureFilteringNearest;
    SKAction* changeFace = [SKAction setTexture:smilingFace];
    
    [self.player runAction:changeFace];

    // get rid of last 40 case
    SKTexture *noCase = [SKTexture textureWithImageNamed:@"g7"];
    noCase.filteringMode = SKTextureFilteringNearest;
    SKAction *station = [SKAction animateWithTextures:@[noCase] timePerFrame:1.0];
    [self.counter runAction:station];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"victoryNode"]) {
        [self.view presentScene:[[IntroScene alloc] initWithSize:self.size]];
    }
}

@end
