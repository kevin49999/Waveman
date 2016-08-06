//
//  IntroScene.m
//  SpriteGuy
//
//  Created by Kevin Johnson on 9/8/15.
//  Copyright (c) 2015 kevinjohnson. All rights reserved.
//

#import "IntroScene.h"
#import "MyScene.h"
#import "SKTUtils.h"

@implementation IntroScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        //backgroundcolor
        self.backgroundColor = [SKColor colorWithRed:0.6275 green:0.5294 blue:0.8863 alpha:1.0];
    
       // http://stackoverflow.com/questions/19082202/setting-up-buttons-in-skscene
        
        //white invisible button (bigger than face)
        
        SKSpriteNode *backGround = [SKSpriteNode spriteNodeWithColor:self.backgroundColor size:CGSizeMake(CGRectGetMaxX(self.frame) , CGRectGetMaxY(self.frame))];
        backGround.name = @"invisibleButton";
        backGround.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:backGround];
        
        // other button option
        SKTexture *winFace = [SKTexture textureWithImageNamed:@"aliveface2"];
        winFace.filteringMode = SKTextureFilteringNearest;
        SKSpriteNode *faceNode = [SKSpriteNode spriteNodeWithTexture:winFace];
        faceNode.name = @"roninButton";//how the node is identified later
        faceNode.position = CGPointMake(self.size.width / 2.0, self.size.height / 2.0);
        [self addChild:faceNode];
        
        //symbol below
        SKTexture *roninSymbol = [SKTexture textureWithImageNamed:@"ronin4"];
        roninSymbol.filteringMode = SKTextureFilteringNearest;
        SKSpriteNode *ronin = [SKSpriteNode spriteNodeWithTexture:roninSymbol];
        [ronin setScale:2.0];
        ronin.position = CGPointMake(self.size.width / 2.0, self.size.height / 2.0 - 75);
    //    [self addChild:ronin];
        
        // http://www.raywenderlich.com/62053/sprite-kit-tutorial-make-platform-game-like-super-mario-brothers-part-2
        
        //3 label
        SKLabelNode *endGameLabel = [SKLabelNode labelNodeWithFontNamed:@"Silkscreen"];
        endGameLabel.text = @"WAVEMAN";
        endGameLabel.fontSize = 36;
        endGameLabel.position = CGPointMake(self.size.width / 2.0, self.size.height / 1.7);
        endGameLabel.fontColor = [SKColor colorWithRed:0.3882       green:0.3294 blue:.5490 alpha:1.0];
        endGameLabel.name = @"endGame";
        [self addChild:endGameLabel];
        
         //3 play
        SKLabelNode *playGameLabel = [SKLabelNode labelNodeWithFontNamed:@"Silkscreen"];
        playGameLabel.text = @"TAP TO JUMP";
        playGameLabel.fontSize = 32;
        playGameLabel.position = CGPointMake(self.size.width / 2.0, self.size.height / 2.6); // divide something rather than - 55
        playGameLabel.fontColor = [SKColor colorWithRed:0.3882       green:0.3294 blue:.5490 alpha:1.0];
        playGameLabel.name = @"playGame";
        [self addChild:playGameLabel];
        
    }
        return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"invisibleButton"] || [node.name isEqualToString:@"roninButton"] || [node.name isEqualToString:@"endGame"] ||[node.name isEqualToString:@"playGame"]) {
        [self.view presentScene:[[MyScene alloc] initWithSize:self.size]];
    }
    
}



@end
