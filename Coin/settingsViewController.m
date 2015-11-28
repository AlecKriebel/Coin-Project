//
//  settingsViewController.m
//  Coin
//
//  Created by Alec Kriebel on 6/19/14.
//  Copyright (c) 2014 AlecKriebel. All rights reserved.
//

#import "settingsViewController.h"
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperation.h"
#import "UzysSlideMenu.h"

@interface settingsViewController ()
@property (nonatomic,strong) UzysSlideMenu *uzysSMenu;
@end

@implementation settingsViewController

-(void)setColors {
    
    self.view.backgroundColor = backColor;
    
    back.backgroundColor = tileColor;
    
    [top setTitleColor:letterColor forState:UIControlStateNormal];
    [donation setTitleColor:letterColor forState:UIControlStateNormal];
    [currency setTitleColor:letterColor forState:UIControlStateNormal];
    
    titleCurrency.textColor = letterColor;
    titleDisable.textColor = letterColor;
    titleDisclaimer.textColor = letterColor;
}

-(IBAction)top:(id)sender {
    
    [self.uzysSMenu toggleMenu];
    top.hidden = YES;
    
}

-(IBAction)currencySelect:(id)sender {
    
    btn1.hidden = NO;
    currencyPicker.hidden = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationDuration:.5];
    [currencyPicker setAlpha:1];
    [UIView commitAnimations];
    NSLog(@"currency selected");
}

-(IBAction)hidePicker:(id)sender {
    
    btn1.hidden = YES;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationDuration:.5];
    [currencyPicker setAlpha:0];
    [UIView commitAnimations];
    [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(makePickerHidden) userInfo:nil repeats:NO];
}

-(void)makePickerHidden {
    
    currencyPicker.hidden = NO;
}

-(IBAction)animation:(id)sender {
    
    if (animationSwitch.on) {
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:YES forKey:@"shouldNotShowAnimation"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"Animation: Off");
        
    } else {
        
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"shouldNotShowAnimation"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"Animation: On");
    }
    
    
}

-(IBAction)donation:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = kCoinAddress;
    [copiedConf setAlpha:1];
    [self hideConfirmation];
    NSLog(@"Copied Address");
    
}

-(IBAction)website:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.aleckriebel.com"]];
    
}

-(void)hideConfirmation{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.5];
    [UIView setAnimationDuration:.5];
    [copiedConf setAlpha:0];
    [UIView commitAnimations];
}

-(void)createMenu {
    
    UzysSMMenuItem *item0 = [[UzysSMMenuItem alloc] initWithTitle:@"SETTINGS" image:nil action:^(UzysSMMenuItem *item) {
        
        [self.uzysSMenu openIconMenu];
        top.hidden = NO;
    }];
    
    UzysSMMenuItem *item1 = [[UzysSMMenuItem alloc] initWithTitle:@"HOME" image:[UIImage imageNamed:@"home"] action:^(UzysSMMenuItem *item) {
        
        [self performSegueWithIdentifier:@"settingsToHome" sender:self];
        //[self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    item0.tag = 0;
    item1.tag = 1;
    
    self.uzysSMenu = [[UzysSlideMenu alloc] initWithItems:@[item0,item1]];
    [self.view addSubview:self.uzysSMenu];
    [self.uzysSMenu openIconMenu];
    
}

-(void)createPicker {
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"currency"];
    [currency setTitle:savedValue forState:UIControlStateNormal];
    NSLog(@"%@", savedValue);
    
    if ([savedValue isEqualToString:@"USD"]) {
        
        [currencyPicker selectRow:0 inComponent:0 animated:NO];
        
    } else if ([savedValue isEqualToString:@"CNY"]) {
        
        [currencyPicker selectRow:1 inComponent:0 animated:NO];
        
    } else if ([savedValue isEqualToString:@"EUR"]) {
        
        [currencyPicker selectRow:2 inComponent:0 animated:NO];
        
    } else if ([savedValue isEqualToString:@"GBP"]) {
        
        [currencyPicker selectRow:3 inComponent:0 animated:NO];
        
    } else if ([savedValue isEqualToString:@"CAD"]) {
        
        [currencyPicker selectRow:4 inComponent:0 animated:NO];
        
    } else if ([savedValue isEqualToString:@"RUB"]) {
        
        [currencyPicker selectRow:5 inComponent:0 animated:NO];
        
    } else if ([savedValue isEqualToString:@"AUD"]) {
        
        [currencyPicker selectRow:6 inComponent:0 animated:NO];
        
    } else if ([savedValue isEqualToString:@"PLN"]) {
        
        [currencyPicker selectRow:7 inComponent:0 animated:NO];
        
    } else if ([savedValue isEqualToString:@"TRY"]) {
        
        [currencyPicker selectRow:8 inComponent:0 animated:NO];
        
    } else if ([savedValue isEqualToString:@"MXN"]) {
        
        [currencyPicker selectRow:9 inComponent:0 animated:NO];
        
    } else if ([savedValue isEqualToString:@"IDR"]) {
        
        [currencyPicker selectRow:10 inComponent:0 animated:NO];
        
    } else if ([savedValue isEqualToString:@"RON"]) {
        
        [currencyPicker selectRow:11 inComponent:0 animated:NO];
        
    } else if ([savedValue isEqualToString:@"HKD"]) {
        
        [currencyPicker selectRow:12 inComponent:0 animated:NO];
        
    } else if ([savedValue isEqualToString:@"ILS"]) {
        
        [currencyPicker selectRow:13 inComponent:0 animated:NO];
        
    } else if ([savedValue isEqualToString:@"NZD"]) {
        
        [currencyPicker selectRow:14 inComponent:0 animated:NO];
        
    } else if ([savedValue isEqualToString:@"ZAR"]) {
        
        [currencyPicker selectRow:15 inComponent:0 animated:NO];
        
    } else if ([savedValue isEqualToString:@"CHF"]) {
        
        [currencyPicker selectRow:16 inComponent:0 animated:NO];
        
    } else if ([savedValue isEqualToString:@"NOK"]) {
        
        [currencyPicker selectRow:17 inComponent:0 animated:NO];
        
    } else if ([savedValue isEqualToString:@"SGD"]) {
        
        [currencyPicker selectRow:18 inComponent:0 animated:NO];
        
    } else if ([savedValue isEqualToString:@"THB"]) {
        
        [currencyPicker selectRow:19 inComponent:0 animated:NO];
        
    } else if ([savedValue isEqualToString:@"JPY"]) {
        
        [currencyPicker selectRow:20 inComponent:0 animated:NO];
        
    }
    
    currencyArray  = [[NSArray alloc] initWithObjects:@"USD", @"CNY", @"EUR", @"GBP", @"CAD", @"RUB", @"AUD", @"PLN", @"TRY", @"MXN", @"IDR", @"RON", @"HKD", @"ILS", @"NZD", @"ZAR", @"CHF", @"NOK", @"SGD", @"THB", @"JPY", nil];
    
}

- (void)viewDidLoad
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"shouldNotShowAnimation"]) {
        
        [animationSwitch setOn:YES];
        
    } else {
        
        [animationSwitch setOn:NO];
        
    }
    
    [donation setTitle:[NSString stringWithFormat:@"DEVELOPER DONATION ADRESS: %@", kCoinAddress] forState:UIControlStateNormal];
    [donation.titleLabel setTextAlignment: NSTextAlignmentCenter];
    
    [self createMenu];
    [self createPicker];
    [self setColors];
    
    [top setTitle:@"SETTINGS" forState:UIControlStateNormal];
    
    self.screenName = @"Settings View";
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height != 568) {
        
        back.frame = CGRectMake(6, 48, 308, 424);
        currencyPicker.frame = CGRectOffset(currencyPicker.frame, 0, -104.0f);
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//Set Up the Picker View
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
    
    return 20;
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    
    return [currencyArray objectAtIndex:row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    switch(row) {
            
        case 0:
            
            [standardUserDefaults setObject:@"USD" forKey:@"currency"];
            [standardUserDefaults synchronize];
            [currency setTitle:@"USD" forState:UIControlStateNormal];
            break;
        case 1:
            
            [standardUserDefaults setObject:@"CNY" forKey:@"currency"];
            [standardUserDefaults synchronize];
            [currency setTitle:@"CNY" forState:UIControlStateNormal];
            break;
        case 2:
            
            [standardUserDefaults setObject:@"EUR" forKey:@"currency"];
            [standardUserDefaults synchronize];
            [currency setTitle:@"EUR" forState:UIControlStateNormal];
            break;
        case 3:
            
            [standardUserDefaults setObject:@"GBP" forKey:@"currency"];
            [standardUserDefaults synchronize];
            [currency setTitle:@"GBP" forState:UIControlStateNormal];
            break;
        case 4:
            
            [standardUserDefaults setObject:@"CAD" forKey:@"currency"];
            [standardUserDefaults synchronize];
            [currency setTitle:@"CAD" forState:UIControlStateNormal];
            break;
        case 5:
            
            [standardUserDefaults setObject:@"RUB" forKey:@"currency"];
            [standardUserDefaults synchronize];
            [currency setTitle:@"RUB" forState:UIControlStateNormal];
            break;
        case 6:
            
            [standardUserDefaults setObject:@"AUD" forKey:@"currency"];
            [standardUserDefaults synchronize];
            [currency setTitle:@"AUD" forState:UIControlStateNormal];
            break;
        case 7:
            
            [standardUserDefaults setObject:@"PLN" forKey:@"currency"];
            [standardUserDefaults synchronize];
            [currency setTitle:@"PLN" forState:UIControlStateNormal];
            break;
        case 8:
            
            [standardUserDefaults setObject:@"TRY" forKey:@"currency"];
            [standardUserDefaults synchronize];
            [currency setTitle:@"TRY" forState:UIControlStateNormal];
            break;
        case 9:
            
            [standardUserDefaults setObject:@"MXN" forKey:@"currency"];
            [standardUserDefaults synchronize];
            [currency setTitle:@"MXN" forState:UIControlStateNormal];
            break;
        case 10:
            
            [standardUserDefaults setObject:@"IDR" forKey:@"currency"];
            [standardUserDefaults synchronize];
            [currency setTitle:@"IDR" forState:UIControlStateNormal];
            break;
        case 11:
            
            [standardUserDefaults setObject:@"RON" forKey:@"currency"];
            [standardUserDefaults synchronize];
            [currency setTitle:@"RON" forState:UIControlStateNormal];
            break;
        case 12:
            
            [standardUserDefaults setObject:@"HKD" forKey:@"currency"];
            [standardUserDefaults synchronize];
            [currency setTitle:@"HKD" forState:UIControlStateNormal];
            break;
        case 13:
            
            [standardUserDefaults setObject:@"ILS" forKey:@"currency"];
            [standardUserDefaults synchronize];
            [currency setTitle:@"ILS" forState:UIControlStateNormal];
            break;
        case 14:
            
            [standardUserDefaults setObject:@"NZD" forKey:@"currency"];
            [standardUserDefaults synchronize];
            [currency setTitle:@"NZD" forState:UIControlStateNormal];
            break;
        case 15:
            
            [standardUserDefaults setObject:@"ZAR" forKey:@"currency"];
            [standardUserDefaults synchronize];
            [currency setTitle:@"ZAR" forState:UIControlStateNormal];
            break;
        case 16:
            
            [standardUserDefaults setObject:@"CHF" forKey:@"currency"];
            [standardUserDefaults synchronize];
            [currency setTitle:@"CHF" forState:UIControlStateNormal];
            break;
        case 17:
            
            [standardUserDefaults setObject:@"NOK" forKey:@"currency"];
            [standardUserDefaults synchronize];
            [currency setTitle:@"NOK" forState:UIControlStateNormal];
            break;
        case 18:
            
            [standardUserDefaults setObject:@"SGD" forKey:@"currency"];
            [standardUserDefaults synchronize];
            [currency setTitle:@"SGD" forState:UIControlStateNormal];
            break;
        case 19:
            [standardUserDefaults setObject:@"THB" forKey:@"currency"];
            [standardUserDefaults synchronize];
            [currency setTitle:@"THB" forState:UIControlStateNormal];
            break;
        case 20:
            [standardUserDefaults setObject:@"JPY" forKey:@"currency"];
            [standardUserDefaults synchronize];
            [currency setTitle:@"JPY" forState:UIControlStateNormal];
            break;
    }
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"currency"];
    NSLog(@"%@", savedValue);
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.textColor = letterColor;
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.text = [currencyArray objectAtIndex:row];
    [label setTextAlignment: NSTextAlignmentCenter];
    return label;    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
