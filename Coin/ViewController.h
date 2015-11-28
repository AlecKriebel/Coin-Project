//
//  ViewController.h
//  Coin
//
//  Created by Alec Kriebel on 6/11/14.
//  Copyright (c) 2014 AlecKriebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "BEMSimpleLineGraphView.h"
#import "chartViewController.h"
#import "GADBannerView.h"
#import "GADInterstitial.h"

@interface ViewController : GAITrackedViewController <UIScrollViewDelegate, BEMSimpleLineGraphDelegate> {
    
    NSDictionary *cryptsy;
    NSDictionary *bTCAverage;
    NSDictionary *coinMarketCap;
    NSDictionary *graphs;
    
    IBOutlet UILabel *bTCPrice;
    IBOutlet UILabel *fiatPrice;
    IBOutlet UILabel *volume;
    IBOutlet UILabel *totalCoins;
    IBOutlet UILabel *marketCap;
    IBOutlet UILabel *lastChange;
    IBOutlet UILabel *dayChangePercent;
    
    IBOutlet UILabel *titleChange;
    IBOutlet UILabel *titleMarketCap;
    IBOutlet UILabel *title24Vol;
    IBOutlet UILabel *titleTotalCoins;

    IBOutlet UILabel *noInternet;
    
    IBOutlet UIImageView *topTile;
    IBOutlet UIImageView *midTile;
    IBOutlet UIImageView *upArrow;
    IBOutlet UIImageView *downArrow;
    
    IBOutlet UIButton *top;
    IBOutlet UIButton *tut;
    
    NSTimer *parseTimer;
    
    NSString *frontSymbol;
    NSString *backSymbol;
    
    IBOutlet UIView *adView;
    
    GADBannerView *bannerView_;
    GADInterstitial *interstitial_;
    
}

@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *myGraph;
@property (strong, nonatomic) NSArray *arrayOfValues;
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;

-(IBAction)top:(id)sender;
-(IBAction)tutorialPressed:(id)sender;

@end
