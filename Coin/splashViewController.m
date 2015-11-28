//
//  splashViewController.m
//  Coin
//
//  Created by Alec Kriebel on 6/16/14.
//  Copyright (c) 2014 AlecKriebel. All rights reserved.
//

#import "splashViewController.h"

@interface splashViewController ()

@end

@implementation splashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)showMain {
    
    [self performSegueWithIdentifier:@"fade" sender:self];
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"shouldNotShowAnimation"]) {
        
        [self performSegueWithIdentifier:@"goNoAnimation" sender:self];
        NSLog(@"Going to home view without animation");
    } else {
        
        [self performSelector:@selector(showMain) withObject:nil afterDelay:2.0];
        NSLog(@"Going to home view with animation");
    }
    
}

- (void)viewDidLoad {
    
    self.screenName = @"Splash View";
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height != 568) {
        
        coin.frame = CGRectMake(32, 112, 256, 256);
        
    }
    
    [super viewDidLoad];
    
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

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
