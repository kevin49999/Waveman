//
//  GasStationOne.m
//  SpriteGuy
//
//  Created by Kevin Johnson on 9/8/15.
//  Copyright (c) 2015 kevinjohnson. All rights reserved.
//

#import "GasStationOne.h"
#import "Player.h"
#import "LevelTwo.h"

@interface GasStationOne () <SKPhysicsContactDelegate>

@end

@implementation GasStationOne


-(NSMutableArray *)cases
{
    if (!_cases) _cases = [NSMutableArray array];
    return _cases;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        //backgroundcolor
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        // fortys on the wall
        [self addFortys];
        
        //gas station
        SKTexture *station1 = [SKTexture textureWithImageNamed:@"g1"];
        station1.filteringMode = SKTextureFilteringNearest;
        SKTexture *station2 = [SKTexture textureWithImageNamed:@"g8"];
        station2.filteringMode = SKTextureFilteringNearest;

        self.counter = [SKSpriteNode spriteNodeWithTexture:station2];
        [self.counter setScale:2.0];
        self.counter.position = CGPointMake(self.counter.size.width/2, self.counter.size.height/2);
        [self addChild:self.counter];
        
        //player
        SKTexture *texture1 = [SKTexture textureWithImageNamed:@"spriteman10"];
        texture1.filteringMode = SKTextureFilteringNearest;
        self.player = [Player spriteNodeWithTexture:texture1];
        [self.player setScale:1.0];
        self.player.position = CGPointMake(self.frame.size.width / 4, self.player.size.height/2);
        [self addChild:self.player];
        
        //man speaks
        SKLabelNode *saying = [SKLabelNode labelNodeWithFontNamed:@"Silkscreen"];
        saying.text = [self setText];
        saying.fontSize = 11;
        saying.alpha =0; // for fading
        saying.fontColor = [SKColor blackColor];
        
        if ([UIScreen mainScreen].bounds.size.height == 667){
            //iphone6
        saying.position = CGPointMake(CGRectGetMidX(self.frame) - 27.5,
                                      self.counter.size.height-54);
            
        } else if ([UIScreen mainScreen].bounds.size.height == 736){
            //iphone6plus
            saying.position = CGPointMake(CGRectGetMidX(self.frame) - 50,
                                          self.counter.size.height-54);
        }
        else  {
            saying.position = CGPointMake(CGRectGetMidX(self.frame),
                                          self.counter.size.height-54);
        }
        
        // http://makeapppie.com/2014/04/01/slippyflippy-1-1-adding-a-fading-in-and-out-label-with-background-in-spritekit/

        [self addChild:saying];
        SKAction *fadeIn = [SKAction fadeInWithDuration:.20];
        SKAction *delay = [SKAction waitForDuration:.5];
        SKAction *sequence = [SKAction sequence:@[delay, fadeIn]];
        [saying runAction:sequence];

    
        //player moves on (end of screen / remove from parent / transition to new sublcass of myscene)
        [self performSelector:@selector(playerTransitions) withObject:self afterDelay:3.0];
        
    }
    return self;
}

-(NSString *)setText
{
   NSString *text = @"Nothing useful here! Keep moving";
    return text;
}

-(void)playerTransitions
{
    //player starts walking
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"spriteman10"];
    texture1.filteringMode = SKTextureFilteringNearest;
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"spriteman11"];
    texture2.filteringMode = SKTextureFilteringNearest;
    SKTexture *texture3 = [SKTexture textureWithImageNamed:@"spriteman12"];
    texture3.filteringMode = SKTextureFilteringNearest;
    
    SKAction *walk = [SKAction repeatActionForever:[SKAction animateWithTextures:@[texture1, texture2, texture3] timePerFrame:0.25]];
    [self.player runAction:walk];
    
    //move him to the end
    self.player.physicsBody.dynamic = NO;
    SKAction *actionMove = [SKAction moveTo:CGPointMake(CGRectGetMaxX(self.frame)+250, self.player.position.y) duration:6.0];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    [self.player runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    //present next scene
    [self performSelector:@selector(goToNextLevel) withObject:self afterDelay:4.0];

}

-(void)goToNextLevel
{
    LevelTwo *nextLevel = [[LevelTwo alloc] initWithSize:self.frame.size];
    [self.scene.view presentScene:nextLevel]; 

}

-(void)addFortys
{
    if ([UIScreen mainScreen].bounds.size.height == 480){
        //iphone 4
        SKTexture *fortys = [SKTexture textureWithImageNamed:@"fortys"];
        fortys.filteringMode = SKTextureFilteringNearest;
        SKTexture *topFortys = [SKTexture textureWithImageNamed:@"fortys"];
        topFortys.filteringMode = SKTextureFilteringNearest;
        SKSpriteNode *fortyWall = [SKSpriteNode spriteNodeWithTexture:fortys];
        [fortyWall setScale:2.0];
        fortyWall.position = CGPointMake(fortyWall.size.width/2, (fortyWall.size.height)+30);
        [self addChild:fortyWall];
        [self.cases addObject:fortyWall];
        
        SKSpriteNode *fortyWall2 = [SKSpriteNode spriteNodeWithTexture:topFortys];
        [fortyWall2 setScale:2.0];
        fortyWall2.position = CGPointMake(fortyWall.size.width/2, (fortyWall.position.y)+fortyWall2.size.height/2+30);
  //      [self addChild:fortyWall2];
        [self.cases addObject:fortyWall2];
        
        // on the right
        SKSpriteNode *fortyWall3 = [SKSpriteNode spriteNodeWithTexture:fortys];
        [fortyWall3 setScale:2.0];
        fortyWall3.position = CGPointMake(fortyWall.size.width+5, (fortyWall.size.height)+30);
        [self addChild:fortyWall3];
        [self.cases addObject:fortyWall3];
        
        SKSpriteNode *fortyWall4 = [SKSpriteNode spriteNodeWithTexture:topFortys];
        [fortyWall4 setScale:2.0];
        fortyWall4.position = CGPointMake(fortyWall.size.width+5, (fortyWall.position.y)+fortyWall2.size.height/2+30);
 //       [self addChild:fortyWall4];
        [self.cases addObject:fortyWall4];
        
    } else if ([UIScreen mainScreen].bounds.size.height == 568){
        //iphone5

    SKTexture *fortys = [SKTexture textureWithImageNamed:@"fortys"];
    fortys.filteringMode = SKTextureFilteringNearest;
    SKTexture *topFortys = [SKTexture textureWithImageNamed:@"fortys"];
    topFortys.filteringMode = SKTextureFilteringNearest;
    SKSpriteNode *fortyWall = [SKSpriteNode spriteNodeWithTexture:fortys];
    [fortyWall setScale:2.0];
    fortyWall.position = CGPointMake(fortyWall.size.width/2, (fortyWall.size.height)+30);
    [self addChild:fortyWall];
    [self.cases addObject:fortyWall];
    
    SKSpriteNode *fortyWall2 = [SKSpriteNode spriteNodeWithTexture:topFortys];
    [fortyWall2 setScale:2.0];
    fortyWall2.position = CGPointMake(fortyWall.size.width/2, (fortyWall.position.y)+fortyWall2.size.height/2+30);
    [self addChild:fortyWall2];
    [self.cases addObject:fortyWall2];
    
    // on the right
    SKSpriteNode *fortyWall3 = [SKSpriteNode spriteNodeWithTexture:fortys];
    [fortyWall3 setScale:2.0];
    fortyWall3.position = CGPointMake(fortyWall.size.width+5, (fortyWall.size.height)+30);
    [self addChild:fortyWall3];
    [self.cases addObject:fortyWall3];
    
    SKSpriteNode *fortyWall4 = [SKSpriteNode spriteNodeWithTexture:topFortys];
    [fortyWall4 setScale:2.0];
    fortyWall4.position = CGPointMake(fortyWall.size.width+5, (fortyWall.position.y)+fortyWall2.size.height/2+30);
    [self addChild:fortyWall4];
    [self.cases addObject:fortyWall4];
    
    }  else if ([UIScreen mainScreen].bounds.size.height == 667){
        
    //iphone 6
        //on left
        SKTexture *fortys = [SKTexture textureWithImageNamed:@"fortys"];
        fortys.filteringMode = SKTextureFilteringNearest;
        
        SKSpriteNode *fortyWall = [SKSpriteNode spriteNodeWithTexture:fortys];
        [fortyWall setScale:2.0];
        fortyWall.position = CGPointMake(fortyWall.size.width/2, (fortyWall.size.height)+30);
        [self addChild:fortyWall];
        [self.cases addObject:fortyWall];
        
        SKSpriteNode *fortyWall2 = [SKSpriteNode spriteNodeWithTexture:fortys];
        [fortyWall2 setScale:2.0];
        fortyWall2.position = CGPointMake(fortyWall.size.width/2, (fortyWall.position.y)+fortyWall2.size.height/2+30);
        [self addChild:fortyWall2];
        [self.cases addObject:fortyWall2];
        
        SKSpriteNode *fortyWall6 = [SKSpriteNode spriteNodeWithTexture:fortys];
        [fortyWall6 setScale:2.0];
        fortyWall6.position = CGPointMake(fortyWall.size.width/2, (fortyWall2.position.y)+fortyWall2.size.height/2+30);
        [self addChild:fortyWall6];
        [self.cases addObject:fortyWall6];
        
        
        // on the right
        SKSpriteNode *fortyWall3 = [SKSpriteNode spriteNodeWithTexture:fortys];
        [fortyWall3 setScale:2.0];
        fortyWall3.position = CGPointMake(fortyWall.size.width+5, (fortyWall.size.height)+30);
        [self addChild:fortyWall3];
        [self.cases addObject:fortyWall3];
        
        SKSpriteNode *fortyWall4 = [SKSpriteNode spriteNodeWithTexture:fortys];
        [fortyWall4 setScale:2.0];
        fortyWall4.position = CGPointMake(fortyWall.size.width+5, (fortyWall.position.y)+fortyWall2.size.height/2+30);
        [self addChild:fortyWall4];
        [self.cases addObject:fortyWall4];
        
        // more top and side forties
        SKSpriteNode *fortyWall5 = [SKSpriteNode spriteNodeWithTexture:fortys];
        [fortyWall5 setScale:2.0];
        fortyWall5.position = CGPointMake(fortyWall.size.width+5, (fortyWall4.position.y)+fortyWall2.size.height/2+30);
        [self addChild:fortyWall5];
        [self.cases addObject:fortyWall5];
        
        //4 on right starting at bottom
        
        SKSpriteNode *fortyWall7 = [SKSpriteNode spriteNodeWithTexture:fortys];
        [fortyWall7 setScale:2.0];
        fortyWall7.position = CGPointMake(fortyWall.size.width*3/2+10, (fortyWall.size.height)+30);
        [self addChild:fortyWall7];
        [self.cases addObject:fortyWall7];
        
        SKSpriteNode *fortyWall8 = [SKSpriteNode spriteNodeWithTexture:fortys];
        [fortyWall8 setScale:2.0];
        fortyWall8.position = CGPointMake(fortyWall.size.width*3/2+10, (fortyWall.position.y)+fortyWall2.size.height/2+30);
        [self addChild:fortyWall8];
        [self.cases addObject:fortyWall8];
        
        // more top and side forties
        SKSpriteNode *fortyWall9 = [SKSpriteNode spriteNodeWithTexture:fortys];
        [fortyWall9 setScale:2.0];
        fortyWall9.position = CGPointMake(fortyWall.size.width*3/2+10, (fortyWall4.position.y)+fortyWall2.size.height/2+30);
        [self addChild:fortyWall9];
        [self.cases addObject:fortyWall9];
        
        SKSpriteNode *fortyWall10 = [SKSpriteNode spriteNodeWithTexture:fortys];
        [fortyWall10 setScale:2.0];
        fortyWall10.position = CGPointMake(fortyWall.size.width*3/2+10, (fortyWall.size.height)/2);
        [self addChild:fortyWall10];
        [self.cases addObject:fortyWall10];
       
        
    }   else if ([UIScreen mainScreen].bounds.size.height == 736){
    //iphone 6plus
        //on left
        SKTexture *fortys = [SKTexture textureWithImageNamed:@"fortys"];
        fortys.filteringMode = SKTextureFilteringNearest;
        
        SKSpriteNode *fortyWall = [SKSpriteNode spriteNodeWithTexture:fortys];
        [fortyWall setScale:2.0];
        fortyWall.position = CGPointMake(fortyWall.size.width/2, (fortyWall.size.height)+30);
        [self addChild:fortyWall];
        [self.cases addObject:fortyWall];
        
        SKSpriteNode *fortyWall2 = [SKSpriteNode spriteNodeWithTexture:fortys];
        [fortyWall2 setScale:2.0];
        fortyWall2.position = CGPointMake(fortyWall.size.width/2, (fortyWall.position.y)+fortyWall2.size.height/2+30);
        [self addChild:fortyWall2];
        [self.cases addObject:fortyWall2];
        
        SKSpriteNode *fortyWall6 = [SKSpriteNode spriteNodeWithTexture:fortys];
        [fortyWall6 setScale:2.0];
        fortyWall6.position = CGPointMake(fortyWall.size.width/2, (fortyWall2.position.y)+fortyWall2.size.height/2+30);
        [self addChild:fortyWall6];
        [self.cases addObject:fortyWall6];
        
        
        // on the right
        SKSpriteNode *fortyWall3 = [SKSpriteNode spriteNodeWithTexture:fortys];
        [fortyWall3 setScale:2.0];
        fortyWall3.position = CGPointMake(fortyWall.size.width+5, (fortyWall.size.height)+30);
        [self addChild:fortyWall3];
        [self.cases addObject:fortyWall3];
        
        SKSpriteNode *fortyWall4 = [SKSpriteNode spriteNodeWithTexture:fortys];
        [fortyWall4 setScale:2.0];
        fortyWall4.position = CGPointMake(fortyWall.size.width+5, (fortyWall.position.y)+fortyWall2.size.height/2+30);
        [self addChild:fortyWall4];
        [self.cases addObject:fortyWall4];
        
        // more top and side forties
        SKSpriteNode *fortyWall5 = [SKSpriteNode spriteNodeWithTexture:fortys];
        [fortyWall5 setScale:2.0];
        fortyWall5.position = CGPointMake(fortyWall.size.width+5, (fortyWall4.position.y)+fortyWall2.size.height/2+30);
        [self addChild:fortyWall5];
        [self.cases addObject:fortyWall5];
        
        //4 on right starting at bottom
        
        SKSpriteNode *fortyWall7 = [SKSpriteNode spriteNodeWithTexture:fortys];
        [fortyWall7 setScale:2.0];
        fortyWall7.position = CGPointMake(fortyWall.size.width*3/2+10, (fortyWall.size.height)+30);
        [self addChild:fortyWall7];
        [self.cases addObject:fortyWall7];
        
        SKSpriteNode *fortyWall8 = [SKSpriteNode spriteNodeWithTexture:fortys];
        [fortyWall8 setScale:2.0];
        fortyWall8.position = CGPointMake(fortyWall.size.width*3/2+10, (fortyWall.position.y)+fortyWall2.size.height/2+30);
        [self addChild:fortyWall8];
        [self.cases addObject:fortyWall8];
        
        // more top and side forties
        SKSpriteNode *fortyWall9 = [SKSpriteNode spriteNodeWithTexture:fortys];
        [fortyWall9 setScale:2.0];
        fortyWall9.position = CGPointMake(fortyWall.size.width*3/2+10, (fortyWall4.position.y)+fortyWall2.size.height/2+30);
        [self addChild:fortyWall9];
        [self.cases addObject:fortyWall9];
        
        SKSpriteNode *fortyWall10 = [SKSpriteNode spriteNodeWithTexture:fortys];
        [fortyWall10 setScale:2.0];
        fortyWall10.position = CGPointMake(fortyWall.size.width*3/2+10, (fortyWall.size.height)/2);
        [self addChild:fortyWall10];
        [self.cases addObject:fortyWall10];
    
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(skipTalk)
               withObject:self
               afterDelay:0.5]; // could try .25
}

-(void)skipTalk
{
    [self.view presentScene:[[LevelTwo alloc] initWithSize:self.size]];
}

@end
