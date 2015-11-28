//
//  chartViewController.m
//  Coin
//
//  Created by Alec Kriebel on 6/19/14.
//  Copyright (c) 2014 AlecKriebel. All rights reserved.
//

#import "chartViewController.h"

@interface chartViewController ()

@end

@implementation chartViewController

-(void)setColors {
    
    self.myGraph.backgroundColor = tileColor;
    
    [goBack setTitleColor:letterColor forState:UIControlStateNormal];
    
    label.textColor = letterColor;
}

-(void)createGraph {
    
    // Customization of the graph
    _myGraph.delegate = self;
    self.myGraph.colorTop = tileColor;
    self.myGraph.colorBottom = tileColor;
    self.myGraph.colorLine = letterColor;
    self.myGraph.widthLine = 3.0;
    self.myGraph.enablePopUpReport = YES;
    self.myGraph.animationGraphEntranceSpeed = 0;
    [self.myGraph reloadGraph];
    
}

-(IBAction)goBack {
    
    [self performSegueWithIdentifier:@"chartToHome" sender:self];
}

-(void)tutorial {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Chart Details" message:[NSString stringWithFormat:@"Tap, hold, and move your finger to reveal the closest %@ value.", kCryptoCurrency] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setBool:YES forKey:@"chartOpened"];
    
}

- (void)viewDidLoad
{
    [self setColors];
    
    self.view.backgroundColor = backColor;
    
    self.screenName = @"Chart View";
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height != 568) {
        
        self.myGraph.frame = CGRectMake(0, 25, 480, 295);
        goBack.frame = CGRectOffset(goBack.frame, -88.0f, 0.0f);
        label.frame = CGRectOffset(label.frame, -44.0f, 0.0f);
    }
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (![standardUserDefaults boolForKey:@"chartOpened"]) {
        
        [self tutorial];
        
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"Chart: View Loaded");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(void)viewDidAppear:(BOOL)animated {
    
    [self createGraph];
    NSUInteger numberArray = [self.arrayOfValues count];
    label.text = [NSString stringWithFormat:@"LAST %lu TRADES", (unsigned long)numberArray];
    
    NSLog(@"Chart: View Appeared");
    
}

-(void)viewDidDisappear:(BOOL)animated {

    [self.myGraph removeFromSuperview];
    
    NSLog(@"Chart: View Disappeared");
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[_arrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[_arrayOfValues objectAtIndex:index] floatValue];
}

@end
