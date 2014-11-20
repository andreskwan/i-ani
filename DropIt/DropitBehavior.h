//
//  DropitBehavior.h
//  DropIt
//
//  Created by Andres Kwan on 11/19/14.
//  Copyright (c) 2014 Kwan Castle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropitBehavior : UIDynamicBehavior

- (void) addItem:(id <UIDynamicItem>)item;
- (void) removeItem:(id <UIDynamicItem>)item;
@end
