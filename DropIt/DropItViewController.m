//
//  ViewController.m
//  DropIt
//
//  Created by Andres Kwan on 11/19/14.
//  Copyright (c) 2014 Kwan Castle. All rights reserved.
//

#import "DropItViewController.h"
#import "DropitBehavior.h"
//this protocol allows me to identify when an
//animator is going to pause (stop animation) or
//when is going to resume animation
@interface DropItViewController () <UIDynamicAnimatorDelegate>
//just for the bounds
@property (weak, nonatomic) IBOutlet UIView *gameView;
//add behavior gravity (default)
@property (strong, nonatomic) UIDynamicAnimator * animator;
//add custom behavior
@property (strong, nonatomic) DropitBehavior * dropitB;
//to attach
@property (strong, nonatomic) UIAttachmentBehavior * attachmentB;
//we also need which view is droppingView so I could attach to it.
@property (strong, nonatomic) UIView * droppingView;

@end

@implementation DropItViewController
static const CGSize DROP_SIZE = {40, 40};
#pragma mark - Properties
//the main view will have gravity
- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.gameView];
        //to identify when the animation is going to
        //pause or resume.
        //we need to know when is going to stop, to start
        //the UIView transition animation.
        _animator.delegate = self;
    }
    return _animator;
}

- (DropitBehavior *)dropitB
{
    if (!_dropitB) {
        _dropitB = [[DropitBehavior alloc]init];
        [self.animator addBehavior:_dropitB];
    }
    return _dropitB;
}

#pragma mark - Animator Delegate implementation
- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator
{
    
}
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self removeCompletedRows];
}
#pragma mark - Animations
 -(BOOL)removeCompletedRows
{
    //will be fill with all drops that complete a row
    NSMutableArray * dropsToRemove = [[NSMutableArray alloc]init];
    for (CGFloat y = self.gameView.bounds.size.height-(DROP_SIZE.height/2); y > 0; y -= DROP_SIZE.height)
    {
        BOOL rowIsComplete = YES;
        NSMutableArray *dropsFound = [[NSMutableArray alloc]init];
        for (CGFloat x = DROP_SIZE.width/2; x <= self.gameView.bounds.size.width-(DROP_SIZE.width/2); x += DROP_SIZE.width)
        {
            UIView *hitView = [self.gameView hitTest:CGPointMake(x, y) withEvent:NULL];
            if ([hitView superview] == self.gameView) {
                [dropsFound addObject:hitView];
            }else{
                rowIsComplete = NO;
                break;
            }
        }
        if (![dropsFound count]) break;
        if (rowIsComplete) [dropsToRemove addObjectsFromArray:dropsFound];
    }
    //how to remove them
    //should then need to [customBehavior removeItem:item]?
    if ([dropsToRemove count]) {
        for (UIView *drop in dropsToRemove) {
            [self.dropitB removeItem:drop];
        }
        [self animateRemoveingDrops:dropsToRemove];
    }
    return NO;
}
//here I'm going to use blocks to implement the animation for blow up
- (void)animateRemoveingDrops:(NSArray*)dropsToRemove
{
    [UIView animateWithDuration:1.0
                     animations:^{
                         //send each drop outside the frame
                         //to a random position
                         for (UIView *drop in dropsToRemove) {
                             int x = (arc4random()%(int)(self.gameView.bounds.size.width*5)) - (int)self.gameView.bounds.size.width*2;
                             int y = self.gameView.bounds.size.height;
                             drop.center = CGPointMake(x, -y);
                         }
                     }
                     completion:^(BOOL finished){
                         //deallocate drops? ARC takes care of this
                         //remove from view?

                         for (UIView *drop in dropsToRemove) {
                             if ([drop respondsToSelector:@selector(removeFromSuperview)]) {
                                 [drop removeFromSuperview];
                             }else{
                                 NSLog(@"%@",@"Not removed from superview");
                             }
                         }
                     }];

}
#pragma mark - Pan Gesture (Attaching)
//pan gesture to use with attachmentBehavior
- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    CGPoint gesturePoint = [sender locationInView:self.gameView];
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        [self attachDroppingViewToPoint:gesturePoint];
    }else if(sender.state == UIGestureRecognizerStateChanged){
        self.attachmentB.anchorPoint = gesturePoint;
    }else if(sender.state == UIGestureRecognizerStateEnded){
        [self.animator removeBehavior:self.attachmentB];
    }
}
- (void)attachDroppingViewToPoint:(CGPoint)anchorPoint
{
    if (self.droppingView){
        self.attachmentB =
        [[UIAttachmentBehavior alloc]initWithItem:self.droppingView
                                 attachedToAnchor:anchorPoint];
        self.droppingView = nil;
        //start to animate the attachment
        [self.animator addBehavior:self.attachmentB];
    }
}

#pragma mark - Tap Gesture (Dropping)
//tab gesture
//drop a square
- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    [self drop];
}

- (void)drop
{
    //how to crear a UIView from code
    CGRect frame;
    frame.origin = CGPointZero;
    //random in x
    frame.size   = DROP_SIZE;
    int x = (arc4random()%(int)self.gameView.bounds.size.width)/DROP_SIZE.width;
    frame.origin.x = x * DROP_SIZE.width;
    
    UIView *dropView = [[UIView alloc]initWithFrame:frame];
    dropView.backgroundColor = [self randomColor];
    //add subview to the main view
    [self.gameView addSubview:dropView];
    
    self.droppingView = dropView;
    
    //add drop to behaviors
    [self.dropitB addItem:dropView];
}

- (UIColor *)randomColor
{
    switch (arc4random()%5) {
        case 0: return [UIColor greenColor];
        case 1: return [UIColor blueColor];
        case 2: return [UIColor orangeColor];
        case 3: return [UIColor redColor];
        case 4: return [UIColor purpleColor];
    }
    return [UIColor blueColor];
}

#pragma mark - Lifecycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
