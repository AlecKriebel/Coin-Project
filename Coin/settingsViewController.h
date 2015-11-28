//
//  settingsViewController.h
//  Coin
//
//  Created by Alec Kriebel on 6/19/14.
//  Copyright (c) 2014 AlecKriebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface settingsViewController : GAITrackedViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    
    NSArray *currencyArray;
    
    IBOutlet UIPickerView *currencyPicker;
    
    IBOutlet UIButton *top;
    IBOutlet UIButton *currency;
    IBOutlet UIButton *btn1;
    IBOutlet UIButton *donation;
    
    IBOutlet UISwitch *animationSwitch;
    
    IBOutlet UIImageView *back;
    IBOutlet UIImageView *copiedConf;
    
    IBOutlet UILabel *titleCurrency;
    IBOutlet UILabel *titleDisable;
    IBOutlet UILabel *titleDisclaimer;
}

-(IBAction)top:(id)sender;
-(IBAction)currencySelect:(id)sender;
-(IBAction)animation:(id)sender;
-(IBAction)donation:(id)sender;
-(IBAction)website:(id)sender;
@end
