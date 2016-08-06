//
//  Player.m
//  SuperKoalio
//
//  Created by Jake Gundersen on 12/27/13.
//  Copyright (c) 2013 Razeware, LLC. All rights reserved.
//

#import "Player.h"
#import "SKTUtils.h"

@implementation Player
//1
- (instancetype)initWithImageNamed:(NSString *)name
{
  if (self == [super initWithImageNamed:name]) {
    self.velocity = CGPointMake(0.0, 0.0);
  }
  return self;
}

//find where to use this
- (CGRect)collisionBoundingBox
{
  CGRect boundingBox = CGRectInset(self.frame, 2, 0);
  CGPoint diff = CGPointSubtract(self.desiredPosition, self.position);
  return CGRectOffset(boundingBox, diff.x, diff.y);
}


@end
