//
//  DropitBehavior.m
//  DropIt
//
//  Created by Andres Kwan on 11/19/14.
//  Copyright (c) 2014 Kwan Castle. All rights reserved.
//

#import "DropitBehavior.h"

@interface DropitBehavior()
@property (strong, nonatomic) UIGravityBehavior * gravityB;
@property (strong, nonatomic) UICollisionBehavior * collisionB;
//to configure items behaviors
@property (strong, nonatomic) UIDynamicItemBehavior * animationOptions;
@end

@implementation DropitBehavior
//overriding init
#pragma mark - Properties
- (UIGravityBehavior *)gravityB
{
    if (!_gravityB) {
        //just need to happen once
        _gravityB = [[UIGravityBehavior alloc]init];
        _gravityB.magnitude = 0.9;
    }
    return _gravityB;
}

- (UICollisionBehavior *)collisionB
{
    if (!_collisionB) {
        _collisionB = [[UICollisionBehavior alloc]init];
        //set collition boundaries?
        _collisionB.translatesReferenceBoundsIntoBoundary = YES;
    }
    return _collisionB;
}

- (UIDynamicItemBehavior *)animationOptions
{
    if (!_animationOptions) {
        _animationOptions = [[UIDynamicItemBehavior alloc]init];
        _animationOptions.allowsRotation = NO;
        
    }
    return _animationOptions;
}

#pragma mark - Public API
- (void)addItem:(id<UIDynamicItem>)item
{
    [self.gravityB   addItem:item];
    [self.collisionB addItem:item];
    [self.animationOptions addItem:item];
}
- (void)removeItem:(id<UIDynamicItem>)item
{
    [self.gravityB   removeItem:item];
    [self.collisionB removeItem:item];
    [self.animationOptions removeItem:item];
}

//overriding init
- (instancetype)init
{
    self = [super init];
    [self addChildBehavior:self.gravityB];
    [self addChildBehavior:self.collisionB];
    [self addChildBehavior:self.animationOptions];
    return self;
}

@end
