//
//  chartViewController.h
//  Coin
//
//  Created by Alec Kriebel on 6/19/14.
//  Copyright (c) 2014 AlecKriebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"
#import "GAITrackedViewController.h"

@interface chartViewController : GAITrackedViewController <BEMSimpleLineGraphDelegate> {
    
    NSDictionary *cryptsy;
    
    IBOutlet UIButton *goBack;
    
    IBOutlet UILabel *label;
    
}

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *myGraph;
@property (strong, nonatomic) NSArray *arrayOfValues;

-(IBAction)goBack;

@end
