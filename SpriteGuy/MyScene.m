//
//  MyScene.m
//  SpriteGuy
//
//  Created by Kevin Johnson on 8/5/15.
//  Copyright (c) 2015 kevinjohnson. All rights reserved.
//

#import "MyScene.h"
#import "Player.h"
#import "SKTUtils.h"
#import "GasStationOne.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import <CoreGraphics/CoreGraphics.h>

static const uint32_t playerCategory =  0x1 << 0;
static const uint32_t enemyCategory  =  0x1 << 1;

@interface MyScene () <SKPhysicsContactDelegate>

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic, assign) NSTimeInterval previousUpdateTime;
@property (strong, nonatomic) NSMutableArray *groundArray;
@property (strong, nonatomic) NSMutableArray *skylineArray;
@property (strong, nonatomic) SKAction *walk;
@property (strong, nonatomic) SKLabelNode *instructionLabel;

/*

(V1.2)
-(####1 if you do more work!) ending scene more epic - flashing yellow light (like death animation) then just leave speach bubble and glowing 40 - no one is even gonna click on the 40 (didn't think  of that)
 
-add music V1.1 - intro, playing, stations, victory, jump, gameOver (unless you find something actual cool now that's free)
-add ducking

 */

@end

@implementation MyScene

-(SKLabelNode *)timeLabel
{
    if (!_timeLabel) _timeLabel = [[SKLabelNode alloc] init];
    return _timeLabel;
}

-(NSMutableArray *)groundArray
{
    if (!_groundArray) _groundArray = [NSMutableArray array];
    return _groundArray;
}

-(NSMutableArray *)skylineArray
{
    if (!_skylineArray) _skylineArray = [NSMutableArray array];
    return _skylineArray;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        self.playerDead = NO;
        self.time = 720; // 720
        self.name = @"level1";
        
        //instruction
   /*     self.instructionLabel = [SKLabelNode labelNodeWithFontNamed:@"Silkscreen"];
        self.instructionLabel.text = @"TAP TO JUMP";
        self.instructionLabel.fontSize = 32;
        self.instructionLabel.zPosition = 5;
        self.instructionLabel.position = CGPointMake(self.size.width / 2.0, self.size.height / 1.3333333);
        self.instructionLabel.fontColor = [SKColor colorWithRed:0.1098 green:0.0941 blue:.1529 alpha:1.0];
        [self addChild:self.instructionLabel]; */
        
        
        //player
        SKTexture *texture1 = [SKTexture textureWithImageNamed:@"spriteman10"];
        texture1.filteringMode = SKTextureFilteringNearest;
        SKTexture *texture2 = [SKTexture textureWithImageNamed:@"spriteman11"];
        texture2.filteringMode = SKTextureFilteringNearest;
        SKTexture *texture3 = [SKTexture textureWithImageNamed:@"spriteman12"];
        texture3.filteringMode = SKTextureFilteringNearest;
        
       SKAction *walk = [SKAction repeatActionForever:[SKAction animateWithTextures:@[texture1, texture2, texture3] timePerFrame:0.25]];
        
        self.player = [Player spriteNodeWithTexture:texture1];
       [self.player runAction:walk];
        
        //world physics
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0.0, -6.0); // default -5
        
        //backgroundcolor
        self.backgroundColor = [SKColor colorWithRed:0.6275 green:0.5294 blue:0.8863 alpha:1.0];

        [self scaleSprite:self.player];
        self.player.position = CGPointMake(self.frame.size.width / 4, CGRectGetMinY(self.frame)+ self.player.size.height/2 + 70);
        
        //contact
        self.player.physicsBody.categoryBitMask = playerCategory; // 3
        self.player.physicsBody.contactTestBitMask = enemyCategory;
        self.player.physicsBody.collisionBitMask = 1;
        self.player.physicsBody.restitution = 0.0f; // bounciness
        
        // player phyiscs
        self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
        self.player.physicsBody.dynamic = YES;
        self.player.physicsBody.allowsRotation = NO;
        [self addChild:self.player];
        
        //create ground & animate
        SKTexture *groundTexture = [SKTexture textureWithImageNamed:@"ground2"];
        groundTexture.filteringMode = SKTextureFilteringNearest;
        
        SKAction* moveGroundSprite = [SKAction moveByX:-groundTexture.size.width*2 y:0 duration:0.02 * groundTexture.size.width*2];
        SKAction* resetGroundSprite = [SKAction moveByX:groundTexture.size.width*2 y:0 duration:0];
        SKAction* moveGroundSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
        
        for( int i = 0; i < 2 + self.frame.size.width / ( groundTexture.size.width * 2 ); ++i ) {
            SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:groundTexture];
            [sprite setScale:2.0]; // do want everything to be 2 tho
            sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2);
            [sprite runAction:moveGroundSpritesForever withKey:@"groundAnimation"];
            sprite.zPosition = 3;
            [self addChild:sprite];
            [self.groundArray addObject:sprite];
        }
        
        //create skyline & animate
        SKTexture *skylineTexture = [SKTexture textureWithImageNamed:@"skylinetree2"];
        skylineTexture.filteringMode = SKTextureFilteringNearest;
        
        SKAction* moveSkylineSprite = [SKAction moveByX:-skylineTexture.size.width*2 y:0 duration:0.1 * skylineTexture.size.width*2];
        SKAction* resetSkylineSprite = [SKAction moveByX:skylineTexture.size.width*2 y:0 duration:0];
        SKAction* moveSkylineSpritesForever = [SKAction repeatActionForever:[SKAction sequence:@[moveSkylineSprite, resetSkylineSprite]]];
        
        
        for( int i = 0; i < 2 + self.frame.size.width / ( skylineTexture.size.width * 2 ); ++i ) {
            SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithTexture:skylineTexture];
            [sprite setScale:2.0]; // liked it at 3.0 but when it moved back it would look bad
            sprite.zPosition = -20;
            sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2 + groundTexture.size.height * 2);
            [sprite runAction:moveSkylineSpritesForever withKey:@"skylineAnimation"];
            [self addChild:sprite];
            [self.skylineArray addObject:sprite];
        }
   
        // create dummy ground physics container
        SKNode *dummy = [SKNode node];
        dummy.position = CGPointMake(0, 1); // y could = groundTexture.size.height
        dummy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, groundTexture.size.height * 2 + 45)]; // y could = groundTexture.size.height * 2 // need to fix this
        dummy.physicsBody.dynamic = NO;
        dummy.physicsBody.allowsRotation = NO;
        dummy.physicsBody.restitution = 0.0f;
        [self addChild:dummy];
        
        //dummy body at top
        SKNode *ceilingDummy = [SKNode node];
        ceilingDummy.position = CGPointMake(0, CGRectGetMaxY(self.frame) - 15); // so doesn't jump into wifi symbol
        ceilingDummy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, 1/*groundTexture.size.height *2*/)];
        ceilingDummy.physicsBody.dynamic = NO;
        ceilingDummy.physicsBody.allowsRotation = NO;
        ceilingDummy.physicsBody.restitution = 0;
        [self addChild:ceilingDummy];
        
        //timeLabel
        self.timeLabel = [SKLabelNode labelNodeWithFontNamed:@"Silkscreen"];
        self.timeLabel.text = [NSString stringWithFormat:@"%f", self.time];
        self.timeLabel.fontSize = 15;
        self.timeLabel.fontColor = [SKColor colorWithRed:0.3882 green:0.3294 blue:.5490 alpha:1.0];
        self.timeLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:self.timeLabel];

        
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if ([self.name isEqualToString:@"level1"] && self.instructionLabel.hidden == NO){
        NSLog(@"hide tap");
        self.instructionLabel.hidden = YES;
    }
    
    //FINE TUNE
    if (self.time / 60 > 0.0){
        if ([UIScreen mainScreen].bounds.size.height == 480){
            //iphone 4
            self.player.physicsBody.velocity = CGVectorMake(0, 0);
            [self.player.physicsBody applyImpulse:CGVectorMake(0, 55)];
            
        } else if ([UIScreen mainScreen].bounds.size.height == 568){
            //iphone 5
            self.player.physicsBody.velocity = CGVectorMake(0, 0);
            [self.player.physicsBody applyImpulse:CGVectorMake(0, 90)];
            
        } else if ([UIScreen mainScreen].bounds.size.height == 667){
            //iphone 6
            self.player.physicsBody.velocity = CGVectorMake(0, 0);
            [self.player.physicsBody applyImpulse:CGVectorMake(0, 135)];
            
        } else if ([UIScreen mainScreen].bounds.size.height >= 736){
            //iphone 6plus or greater
            self.player.physicsBody.velocity = CGVectorMake(0, 0);
            [self.player.physicsBody applyImpulse:CGVectorMake(0, 170)];
            
            }
        
  //  self.player.physicsBody.velocity = CGVectorMake(0, 0);
  //  [self.player.physicsBody applyImpulse:CGVectorMake(0, 90)];
        
    // http://opengameart.org/content/platformer-jumping-sounds
    //[self runAction:[SKAction playSoundFileNamed:@"jump.wav" waitForCompletion:NO]];
        
    // jump animation
    SKTexture *jump1 = [SKTexture textureWithImageNamed:@"spriteman10"];
    jump1.filteringMode = SKTextureFilteringNearest;
    SKTexture *jump2 = [SKTexture textureWithImageNamed:@"spriteman11"];
    jump2.filteringMode = SKTextureFilteringNearest;
    SKAction *jump = [SKAction animateWithTextures:@[jump2,jump1] timePerFrame:0.35];
    [self.player removeAllActions];
    [self.player runAction:jump];
        
    }
    
    // replay "button"
    if (self.playerDead == YES){
        
        [self performSelector:@selector(skipDeath)
                   withObject:self
                   afterDelay:0.10];
    }
    
}

-(void)skipDeath
{
   [self.view presentScene:[[MyScene alloc] initWithSize:self.size]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

#pragma mark ENEMY
- (void)addEnemy
{
    //http://www.raywenderlich.com/42699/spritekit-tutorial-for-beginners
    
    SKTexture *enemyTexture = [SKTexture textureWithImageNamed:@"lonestarcan"];
    enemyTexture.filteringMode = SKTextureFilteringNearest;
    SKSpriteNode *enemy = [SKSpriteNode spriteNodeWithTexture:enemyTexture];
    enemy.zPosition = 2;
    
    SKSpriteNode *ground = [self.groundArray firstObject];
    int minY = ground.size.height + enemy.size.height / 2;
    int maxY = self.frame.size.height - enemy.size.height / 2 - 1;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    enemy.position = CGPointMake(self.frame.size.width + enemy.size.width/2, actualY);
   // int y = [self scaleFieldLayout:self.view.bounds.size.height];
    [self scaleSprite:enemy];
   // [enemy setScale:2.0];
    [self addChild:enemy];
    
    
    enemy.physicsBody = [SKPhysicsBody  bodyWithRectangleOfSize:enemy.size]; // 1
    enemy.physicsBody.dynamic = NO; // 2
    enemy.physicsBody.categoryBitMask = enemyCategory; // 3
    enemy.physicsBody.contactTestBitMask = playerCategory; // 4
    enemy.physicsBody.collisionBitMask = 0; // 5
   
    //speed
  //  int minDuration = 2.0; // default was 2
  //  int maxDuration = 2.0; // default was 4
  //  int rangeDuration = maxDuration - minDuration;
    int actualDuration = 2.0; //(arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    SKAction * actionMove = [SKAction moveTo:CGPointMake(-enemy.size.width/2, actualY) duration:actualDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [enemy runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > .55) { // was > 1
        self.lastSpawnTimeInterval = 0;
      
        if (self.time / 60  > 1.0) {
       [self addEnemy];
        }
    }
}

- (void)update:(NSTimeInterval)currentTime {
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
  //  NSLog(@"%@", self);
    self.time--;
  //  NSLog(@"%d", self.playerDead);
    
    if (self.time / 60 > 0.0 && self.playerDead == NO) {
        
        int myInt = (int) self.time / 60.0;
        self.timeLabel.text = [NSString stringWithFormat:@"%d", myInt/*self.time / 60.0*/];
    } else {
        self.timeLabel.text = [NSString stringWithFormat:@"0.000000"];
    }
    
    if (self.playerDead == YES){
        self.time++;
       // self.timeLabel.text = [NSString stringWithFormat:@"%f", self.time / 60.0];
        self.timeLabel.text = @"";
    }
    
    if (self.time /60 == 0.0 && self.playerDead == NO) {
        
        self.timeLabel.hidden = YES;
        [self performSelector:@selector(transitionToGasStation) withObject:self afterDelay:1.5];
    }
    
    SKSpriteNode *ground = [self.groundArray firstObject];
    if (self.player.position.y <= ground.size.height + self.player.size.height/2 ) {
        [self makePlayerWalk];
    }
    
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    self.playerDead = YES;
    [self.player removeFromParent]; // or dead player animation would be funny (turn eyes into x's)
    [self gameOver];
}

-(void)makePlayerWalk
{
    SKTexture *texture1 = [SKTexture textureWithImageNamed:@"spriteman10"];
    texture1.filteringMode = SKTextureFilteringNearest;
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"spriteman11"];
    texture2.filteringMode = SKTextureFilteringNearest;
    SKTexture *texture3 = [SKTexture textureWithImageNamed:@"spriteman12"];
    texture3.filteringMode = SKTextureFilteringNearest;
    
    SKAction *walk = [SKAction repeatActionForever:[SKAction animateWithTextures:@[texture1, texture2, texture3] timePerFrame:0.25]];
    
    if (![self.player hasActions])
    {
        [self.player runAction:walk];
    }
}

-(void)gameOver
{
    // http://www.raywenderlich.com/62053/sprite-kit-tutorial-make-platform-game-like-super-mario-brothers-part-2
    
    //4
   /* UIButton *replay = [UIButton buttonWithType:UIButtonTypeCustom];
    replay.tag = 321;
    UIImage *replayImage = [UIImage imageNamed:@"deathface3"];
    [replay setImage:replayImage forState:UIControlStateNormal];
    [replay addTarget:self action:@selector(replay:) forControlEvents:UIControlEventTouchUpInside];
    replay.frame = CGRectMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame), replayImage.size.width, replayImage.size.height);
    [self.view addSubview:replay];
    */
    
    //hide instructions if they didn't jump
  /*  if (self.instructionLabel.hidden == NO){
        self.instructionLabel.hidden = YES;
    }
   */
    
    //screen flashing
    SKSpriteNode *backGround = [SKSpriteNode spriteNodeWithColor:self.backgroundColor size:self.frame.size];
    backGround.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    backGround.zPosition = 4;
    SKAction *color1 = [SKAction colorizeWithColor:self.backgroundColor colorBlendFactor:0.0 duration:.05];
    SKAction *color2 = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:0.0 duration:.05];
    SKAction *done = [SKAction removeFromParent];
    SKAction *colorSequence = [SKAction sequence:@[color2, color1, color2, color1, color2, color1, done]];
    [backGround runAction:colorSequence];
    [self addChild:backGround];
    
    //death texture
    SKTexture *deathFace = [SKTexture textureWithImageNamed:@"deathface3"];
    deathFace.filteringMode = SKTextureFilteringNearest;
    SKSpriteNode *death = [SKSpriteNode spriteNodeWithTexture:deathFace];
    death.name = @"deathButton";
    death.zPosition = 5;
    death.position = CGPointMake(self.size.width / 2.0, self.size.height / 2.0);
    [self addChild:death];
    
  /*  SKSpriteNode *whiteButton = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(130, 130)];
    whiteButton.name = @"invisibleButton";
    whiteButton.zPosition = 0;
    whiteButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:whiteButton];
   */
    
    SKLabelNode *replayGameLabel = [SKLabelNode labelNodeWithFontNamed:@"Silkscreen"];
    replayGameLabel.text = @"REPLAY";
    replayGameLabel.fontSize = 32;
    replayGameLabel.zPosition = 5;
    replayGameLabel.position = CGPointMake(self.size.width / 2.0, self.size.height / 1.7);
    replayGameLabel.fontColor = [SKColor colorWithRed:0.1098 green:0.0941 blue:.1529 alpha:1.0];
    [self addChild:replayGameLabel];
    
    //kill timelabel
    self.timeLabel.text = [NSString stringWithFormat:@""];
    
}


-(void)transitionToGasStation
{
    
   //halt background animations
    for (SKSpriteNode *sprite in self.groundArray) {
    [sprite removeActionForKey:@"groundAnimation"];
    }
    
    //halt skyline animation
    for (SKSpriteNode *skyline in self.skylineArray) {
    [skyline removeActionForKey:@"skylineAnimation"];
    }
    
    //move player to station / end of screen
    self.player.physicsBody.dynamic = NO;
    SKAction *actionMove = [SKAction moveTo:CGPointMake(CGRectGetMaxX(self.frame)+250, self.player.position.y) duration:6.0];
    SKAction *actionMoveDone = [SKAction removeFromParent];
    [self.player runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    //present gas station entrance (sliding from offscreen)
    SKSpriteNode *ground = [self.groundArray firstObject];
    
    
    SKSpriteNode *store = [SKSpriteNode spriteNodeWithTexture:[self textureForGasStation]];
    [store setScale:2.0]; // do want everything to be 2 tho
    store.position = CGPointMake(self.size.width/4*3 + 60, (ground.size.height + store.size.height/2));
    SKAction *moveStore = [SKAction moveTo:CGPointMake(self.size.width/4*3 + 25, (ground.size.height + store.size.height/2)) duration:1.0];
    [store runAction:moveStore];
    [self addChild:store];
    
    //present new scene (GasStationOne)
    [self performSelector:@selector(goToGasStation) withObject:self afterDelay:4.0]; // 3.75
    
}

-(SKTexture *)textureForGasStation
{
    //change door based on scene.name
    NSLog(@"self.name = %@", self.name);
    if ([self.name isEqualToString:@"level1"]){
        
        NSLog(@"door1");
        SKTexture *fourtyStore = [SKTexture textureWithImageNamed:@"door1"];
        fourtyStore.filteringMode = SKTextureFilteringNearest;
        return fourtyStore;
        
    }else if ([self.name isEqualToString:@"level2"]){
        
        NSLog(@"door2");
        SKTexture *fourtyStore = [SKTexture textureWithImageNamed:@"door2"];
        fourtyStore.filteringMode = SKTextureFilteringNearest;
        return fourtyStore;
        
    } else if ([self.name isEqualToString:@"level3"]){
        
        NSLog(@"door3");
        SKTexture *fourtyStore = [SKTexture textureWithImageNamed:@"door3"];
        fourtyStore.filteringMode = SKTextureFilteringNearest;
        return fourtyStore;
        
    } else {
        
        NSLog(@"ELSE");
        SKTexture *fourtyStore = [SKTexture textureWithImageNamed:@"door"];
        fourtyStore.filteringMode = SKTextureFilteringNearest;
        return fourtyStore;
        
    }
    
}

-(void)goToGasStation
{
    if (self.playerDead == NO){
    GasStationOne *newScene = [[GasStationOne alloc] initWithSize:self.frame.size];
    [self.scene.view presentScene:newScene];
    }
}

#pragma mark Scaling field for screen sizes (4)

-(void)scaleSprite:(SKSpriteNode *)sprite
{
 //   NSLog(@"screen height %f", [UIScreen mainScreen].bounds.size.height);
    if ([UIScreen mainScreen].bounds.size.height == 480){
        //iphone 4
        if ([sprite isEqual:self.player]) {
        [sprite setScale:0.8451];
        }
        else {
            // is enemy
        [sprite setScale:1.6902];
        }
        
    } else if ([UIScreen mainScreen].bounds.size.height == 568){
        //iphone 5
            if ([sprite isEqual:self.player]) {
                [sprite setScale:1];
            }
            else {
                // is enemy
                [sprite setScale:2.0];
            }
        
    } else if ([UIScreen mainScreen].bounds.size.height == 667){
        //iphone 6
            if ([sprite isEqual:self.player]) {
                [sprite setScale:1.1743];
            }
            else {
                // is enemy
                [sprite setScale:2.3486];
            }
        
    } else if ([UIScreen mainScreen].bounds.size.height >= 736){
        //iphone 6plus or greater
            if ([sprite isEqual:self.player]) {
                [sprite setScale:1.2958];
            }
            else {
                // is enemy
                [sprite setScale:2.5916];
            }
        
    } else {
        
        nil;
    }
}


@end
