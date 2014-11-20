//
//  ViewController.m
//  DropIt
//
//  Created by Andres Kwan on 11/19/14.
//  Copyright (c) 2014 Kwan Castle. All rights reserved.
//

#import "DropItViewController.h"
#import "DropitBehavior.h"

@interface DropItViewController ()
//just for the bounds
@property (weak, nonatomic) IBOutlet UIView *gameView;
//add behavior gravity (default)
@property (strong, nonatomic) UIDynamicAnimator * animator;
//add custom behavior
@property (strong, nonatomic) DropitBehavior * dropitB;

@end

@implementation DropItViewController
static const CGSize DROP_SIZE = {40, 40};
#pragma mark - Properties
//the main view will have gravity
- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.gameView];
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

#pragma mark - Add subviews
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
