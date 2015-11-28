//
//  ViewController.m
//  Coin
//
//  Created by Alec Kriebel on 6/11/14.
//  Copyright (c) 2014 AlecKriebel. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperation.h"
#import "UzysSlideMenu.h"

@interface ViewController ()
@property (nonatomic,strong) UzysSlideMenu *uzysSMenu;

@end

@implementation ViewController {
    
    float bTCValue;
    float coinValue;
    BOOL internet;
}

-(void)setColors {
    
    topTile.backgroundColor = tileColor;
    midTile.backgroundColor = tileColor;
    
    self.view.backgroundColor = backColor;
    self.myGraph.backgroundColor = tileColor;
    
    [top setTitleColor:letterColor forState:UIControlStateNormal];
    
    bTCPrice.textColor = letterColor;
    fiatPrice.textColor = letterColor;
    volume.textColor = letterColor;
    totalCoins.textColor = letterColor;
    marketCap.textColor = letterColor;
    lastChange.textColor = letterColor;
    fiatPrice.textColor = letterColor;
    
    noInternet.textColor = letterColor;
    
    title24Vol.textColor = letterColor;
    titleChange.textColor = letterColor;
    titleMarketCap.textColor = letterColor;
    titleTotalCoins.textColor = letterColor;
    
}

-(void)startLoading {
    
    [top setTitle:@"LOADING" forState:UIControlStateNormal];
}

-(void)stopLoading {
    
    [top setTitle:kFullCapsCoinName forState:UIControlStateNormal];
}

-(IBAction)top:(id)sender {
    
    [self.uzysSMenu toggleMenu];
    top.hidden = YES;
    
}

-(IBAction)tutorialPressed:(id)sender {
    
    tut.hidden = YES;
    
}

-(void)parse {
    
    [self startLoading];

    [self parseCryptsy];
    [self parseBTCAverage];
    [self parseCoinMarketCap];
}

-(void)comeFromBackground {
    
    [self parse];
    [interstitial_ presentFromRootViewController:self];
    [interstitial_ loadRequest:[GADRequest request]];
}

-(void)parseCryptsy {
    
    NSURL *url = [[NSURL alloc] initWithString:kCryptsyURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Cryptsy Parsed");
        
        cryptsy = (NSDictionary *)responseObject;
        NSString *success = [cryptsy objectForKey:@"success"];
        int successNumber = [success intValue];
        
        if (successNumber == 1) {
            
            NSDictionary *returnData = [cryptsy objectForKey:@"return"];
            NSDictionary *markets = [returnData objectForKey:@"markets"];
            NSDictionary *coin = [markets objectForKey:kCryptoCurrency];
            NSString *coinPrice = [coin objectForKey:@"lasttradeprice"];
            coinValue = [coinPrice floatValue];
            
            NSString *coinPriceFormatted = [NSString stringWithFormat:@"฿%@", coinPrice];
            bTCPrice.text = coinPriceFormatted;
            
            [self multiplyPrices];
            
            volume.text = [coin objectForKey:@"volume"];
            
            NSString *string = [coin objectForKey:@"lasttradetime"];
            NSString *shortString = [string substringFromIndex:11];
            lastChange.text = [NSString stringWithFormat:@"LAST CHANGE: %@", shortString];
            
            [self.array removeAllObjects];
            
            NSArray *coinGraph = [coin objectForKey:@"recenttrades"];
            
            for (NSDictionary *numbers in coinGraph) {
                NSUInteger numberArray = [self.array count];
                //NSLog(@"%lu", (unsigned long)numberArray);
                if (numberArray < 50) {
                    
                    NSString *priceList = [numbers objectForKey:@"price"];
                    
                    [self.array addObject: priceList];
                    
                }

            }
            
            self.arrayOfValues = [[self.array reverseObjectEnumerator] allObjects];
            [self createGraph];
            [self stopLoading];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (!operation.isCancelled) {
            NSLog(@"%@", [error localizedDescription]);
            [self stopLoading];
            //Code for Failure Handling
        }  else {
            
            NSLog(@"BTCAve Operation Cancelled");
        }
        
        
    }];
    
    [operation start];
    
}

-(void)parseBTCAverage {
    
    NSURL *url = [[NSURL alloc] initWithString:kBitcoinURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

            NSLog(@"BTCAverage Parsed");
            
            bTCAverage = (NSDictionary *)responseObject;
            NSString *savedCurrency = [[NSUserDefaults standardUserDefaults] stringForKey:@"currency"];
            NSDictionary *currency = [bTCAverage objectForKey:savedCurrency];
            NSString *lastBTCPrice = [currency objectForKey:@"last"];
            bTCValue = [lastBTCPrice floatValue];
        
            [self multiplyPrices];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (!operation.isCancelled) {
            NSLog(@"%@", [error localizedDescription]);
            //Code for Failure Handling
        } else {
            
            NSLog(@"BTCAve Operation Cancelled");
        }
        
    }];
    
    [operation start];
    

    
}

-(void)multiplyPrices {
    
    fiatPrice.text = [NSString stringWithFormat:@"%@%.2f%@", frontSymbol, coinValue * bTCValue, backSymbol];
    NSLog(@"%f", bTCValue);

}

-(void)parseCoinMarketCap {
    
    NSURL *url = [[NSURL alloc] initWithString:kCoinCapURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"CoinMarketCap Parsed");
        
        coinMarketCap = (NSDictionary *)responseObject;
        totalCoins.text = [coinMarketCap objectForKey:@"totalSupply"];
        NSDictionary *change = [coinMarketCap objectForKey:@"change1h"];
        
        NSString *savedCurrency = [[NSUserDefaults standardUserDefaults] stringForKey:@"currency"];
        
        
        if ([savedCurrency isEqualToString:@"USD"]) {
            
            NSDictionary *marketCapacity = [coinMarketCap objectForKey:@"marketCap"];
            marketCap.text = [NSString stringWithFormat:@"%@%@%@", frontSymbol, [marketCapacity objectForKey:@"usd"], backSymbol];
            
            NSString *bTCChange = [change objectForKey:@"usd"];
            dayChangePercent.text = [NSString stringWithFormat:@"%@ %%", bTCChange];
            
            [self setColorFromNumber:[bTCChange floatValue]];
            
        } else if ([savedCurrency isEqualToString:@"EUR"]) {
            
            NSDictionary *marketCapacity = [coinMarketCap objectForKey:@"marketCap"];
            marketCap.text = [NSString stringWithFormat:@"%@%@%@", frontSymbol, [marketCapacity objectForKey:@"eur"], backSymbol];
            
            NSString *bTCChange = [change objectForKey:@"eur"];
            dayChangePercent.text = [NSString stringWithFormat:@"%@ %%", bTCChange];
            
            [self setColorFromNumber:[bTCChange floatValue]];
            
        } else if ([savedCurrency isEqualToString:@"CNY"]) {
            
            NSDictionary *marketCapacity = [coinMarketCap objectForKey:@"marketCap"];
            marketCap.text = [NSString stringWithFormat:@"%@%@%@", frontSymbol, [marketCapacity objectForKey:@"cny"], backSymbol];
            
            NSString *bTCChange = [change objectForKey:@"cny"];
            dayChangePercent.text = [NSString stringWithFormat:@"%@ %%", bTCChange];
            
            [self setColorFromNumber:[bTCChange floatValue]];
            
        } else if ([savedCurrency isEqualToString:@"GBP"]) {
            
            NSDictionary *marketCapacity = [coinMarketCap objectForKey:@"marketCap"];
            marketCap.text = [NSString stringWithFormat:@"%@%@%@", frontSymbol, [marketCapacity objectForKey:@"gbp"], backSymbol];
            
            NSString *bTCChange = [change objectForKey:@"gbp"];
            dayChangePercent.text = [NSString stringWithFormat:@"%@ %%", bTCChange];
            
            [self setColorFromNumber:[bTCChange floatValue]];
            
        } else if ([savedCurrency isEqualToString:@"CAD"]) {
            
            NSDictionary *marketCapacity = [coinMarketCap objectForKey:@"marketCap"];
            marketCap.text = [NSString stringWithFormat:@"%@%@%@", frontSymbol, [marketCapacity objectForKey:@"cad"], backSymbol];
            
            NSString *bTCChange = [change objectForKey:@"cad"];
            dayChangePercent.text = [NSString stringWithFormat:@"%@ %%", bTCChange];
            
            [self setColorFromNumber:[bTCChange floatValue]];
            
        } else if ([savedCurrency isEqualToString:@"RUB"]) {
            
            NSDictionary *marketCapacity = [coinMarketCap objectForKey:@"marketCap"];
            marketCap.text = [NSString stringWithFormat:@"%@%@%@", frontSymbol, [marketCapacity objectForKey:@"rub"], backSymbol];
            
            NSString *bTCChange = [change objectForKey:@"rub"];
            dayChangePercent.text = [NSString stringWithFormat:@"%@ %%", bTCChange];
            
            [self setColorFromNumber:[bTCChange floatValue]];
            
        } else {
            
            NSDictionary *marketCapacity = [coinMarketCap objectForKey:@"marketCap"];
            marketCap.text = [NSString stringWithFormat:@"฿%@",[marketCapacity objectForKey:@"btc"]];
            
            NSString *bTCChange = [change objectForKey:@"btc"];
            dayChangePercent.text = [NSString stringWithFormat:@"%@ %%", bTCChange];
            
            [self setColorFromNumber:[bTCChange floatValue]];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (!operation.isCancelled) {
            NSLog(@"%@", [error localizedDescription]);
            //Code for Failure Handling
        } else {
            
            NSLog(@"Coin Market Cap. Operation Cancelled");
            
        }
        
    }];
    
    [operation start];
    
}

-(void)setColorFromNumber:(float)number {
    
    if (number > 0) {
        
        downArrow.hidden = YES;
        upArrow.hidden = NO;
        
        [dayChangePercent setTextColor:[UIColor greenColor]];
    } else if (number == 0) {
        
        downArrow.hidden = YES;
        upArrow.hidden = YES;
        
        [dayChangePercent setTextColor:[UIColor blueColor]];
    } else if (number < 0) {
        
        downArrow.hidden = NO;
        upArrow.hidden = YES;
        
        [dayChangePercent setTextColor:[UIColor redColor]];
    }
    
}

-(void)createGraph {
    
    // Customization of the graph
    _myGraph.delegate = self;
    self.myGraph.colorTop = tileColor;
    self.myGraph.colorBottom = tileColor;
    self.myGraph.colorLine = letterColor;
    self.myGraph.widthLine = 1.0;
    self.myGraph.enablePopUpReport = NO;
    self.myGraph.enableBezierCurve = NO;
    self.myGraph.animationGraphEntranceSpeed = 0;
    [self.myGraph reloadGraph];
    
    UITapGestureRecognizer *tapGR;
    tapGR = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)] autorelease];
    tapGR.numberOfTapsRequired = 1;
    [self.myGraph addGestureRecognizer:tapGR];
    
}

-(void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        [self performSegueWithIdentifier:@"goToChart" sender:self];
        [self.myGraph removeFromSuperview];
        
    }
}

-(void)createMenu {
    
    UzysSMMenuItem *item0 = [[UzysSMMenuItem alloc] initWithTitle:kFullCapsCoinName image:nil action:^(UzysSMMenuItem *item) {
        
        [self.uzysSMenu openIconMenu];
        top.hidden = NO;
    }];
    
    UzysSMMenuItem *item1 = [[UzysSMMenuItem alloc] initWithTitle:@"SETTINGS" image:[UIImage imageNamed:@"settings"] action:^(UzysSMMenuItem *item) {

        [self performSegueWithIdentifier:@"goToSettings" sender:self];
        
    }];
    
    item0.tag = 0;
    item1.tag = 1;
    
    self.uzysSMenu = [[UzysSlideMenu alloc] initWithItems:@[item0,item1]];
    [self.view addSubview:self.uzysSMenu];
    [self.uzysSMenu openIconMenu];
    
}

-(void)setSymbol {
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"currency"];
    
    if ([savedValue isEqualToString:@"USD"] || [savedValue isEqualToString:@"MXN"]) {
        
        frontSymbol = @"$";
        backSymbol = @"";
        
    } else if ([savedValue isEqualToString:@"AUD"]) {
        
        frontSymbol = @"AU$";
        backSymbol = @"";
        //[uSDLabel setFont: [UIFont fontWithName:@"Avenir Next Condensed" size:30.0]];
        
    } else if ([savedValue isEqualToString:@"CAD"]) {
        
        frontSymbol = @"CA$";
        backSymbol = @"";
        
    } else if ([savedValue isEqualToString:@"CHF"]) {
        
        frontSymbol = @"";
        backSymbol = @"CHF";
        
    } else if ([savedValue isEqualToString:@"CNY"]) {
        
        frontSymbol = @"";
        backSymbol = @"\u00a0\u5143";
        
    } else if ([savedValue isEqualToString:@"EUR"]) {
        
        frontSymbol = @"";
        backSymbol = @"\u00a0\u20ac";
        
    } else if ([savedValue isEqualToString:@"GBP"]) {
        
        frontSymbol = @"\u00a3";
        backSymbol = @"";
        
    } else if ([savedValue isEqualToString:@"HKD"]) {
        
        frontSymbol = @"HK$";
        backSymbol = @"";
        
    } else if ([savedValue isEqualToString:@"NZD"]) {
        
        frontSymbol = @"NZ$";
        backSymbol = @"";
        
    } else if ([savedValue isEqualToString:@"PLN"]) {
        
        frontSymbol = @"";
        backSymbol = @"\u00a0z\u0142";
        
    } else if ([savedValue isEqualToString:@"RUB"]) {
        
        frontSymbol = @"";
        backSymbol = @"\u00a0RUB";
        
    } else if ([savedValue isEqualToString:@"SGD"]) {
        
        frontSymbol = @"SG$";
        backSymbol = @"";
        
    } else if ([savedValue isEqualToString:@"THB"]) {
        
        frontSymbol = @"\u0e3f";
        backSymbol = @"";
        
    } else if ([savedValue isEqualToString:@"NOK"]) {
        
        frontSymbol = @"";
        backSymbol = @"\u00a0Kr";
        
    } else if ([savedValue isEqualToString:@"JPY"]) {
        
        frontSymbol = @"\u00a5";
        backSymbol = @"";
        
    } else if ([savedValue isEqualToString:@"TRY"]) {
        
        frontSymbol = @"";
        backSymbol = @" TRY";
        
    } else if ([savedValue isEqualToString:@"IDR"]) {
        
        frontSymbol = @"Rp ";
        backSymbol = @"";
        
    } else if ([savedValue isEqualToString:@"RON"]) {
        
        frontSymbol = @"";
        backSymbol = @" RON";
        
    } else if ([savedValue isEqualToString:@"ILS"]) {
        
        frontSymbol = @"";
        backSymbol = @" ₪";
        
    } else if ([savedValue isEqualToString:@"ZAR"]) {
        
        frontSymbol = @"R ";
        backSymbol = @"";
        
    }
}


- (void)viewDidLoad
{
    
    downArrow.hidden = YES;
    upArrow.hidden = YES;
    
    self.ArrayOfValues = [[NSMutableArray alloc] init];
    self.array = [[NSMutableArray alloc] init];
    
    [top setTitle: kFullCapsCoinName forState:UIControlStateNormal];
    
    [self createMenu];
    [self setColors];

    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height != 568) {
     
        adView.frame = CGRectMake(0, 430, 320, 50);
        topTile.frame = CGRectMake(6, 45, 308, 120);
        bTCPrice.frame = CGRectOffset(bTCPrice.frame, 0.0f, -14.0f);
        fiatPrice.frame = CGRectOffset(fiatPrice.frame, 0.0f, -14.0f);
        dayChangePercent.frame = CGRectOffset(dayChangePercent.frame, 0.0f, -14.0f);
        [dayChangePercent setTextAlignment: NSTextAlignmentLeft];
        upArrow.frame = CGRectMake(285, 123, 20, 25);
        downArrow.frame = CGRectMake(285, 123, 20, 25);
        
        midTile.frame = CGRectMake(6, 172, 308, 120);
        titleMarketCap.frame = CGRectOffset(titleMarketCap.frame, 0.0f, -34.0f);
        marketCap.frame = CGRectOffset(marketCap.frame, 0.0f, -34.0f);
        titleTotalCoins.frame = CGRectOffset(titleTotalCoins.frame, 0.0f, -38.0f);
        totalCoins.frame = CGRectOffset(totalCoins.frame, 0.0f, -38.0f);
        title24Vol.frame = CGRectOffset(title24Vol.frame, 0.0f, -42.0f);
        volume.frame = CGRectOffset(volume.frame, 0.0f, -42.0f);
        lastChange.frame = CGRectOffset(lastChange.frame, 0.0f, -53.0f);
        
        noInternet.frame = CGRectOffset(lastChange.frame, -12.0f, -44.0f);
        
        self.myGraph.frame = CGRectMake(6, 299, 308, 120);
        
        tut.frame = CGRectMake(0, 0, 320, 480);
        [tut setBackgroundImage:[UIImage imageNamed:@"tut"] forState:UIControlStateNormal];


    }
    
    self.screenName = @"Main View";
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToChart"]) {
        
        chartViewController *cVC = (chartViewController *)segue.destinationViewController;
        cVC.arrayOfValues = self.arrayOfValues;
    }
}

-(void)noInternet {
    
    adView.hidden = YES;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"A connection to the internet is required for this app. Come back when you have one." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    bTCPrice.hidden = YES;
    fiatPrice.hidden = YES;
    volume.hidden = YES;
    totalCoins.hidden = YES;
    marketCap.hidden = YES;
    lastChange.hidden = YES;
    dayChangePercent.hidden = YES;
    titleTotalCoins.hidden = YES;
    titleChange.hidden = YES;
    titleMarketCap.hidden = YES;
    title24Vol.hidden = YES;
    topTile.hidden = YES;
    midTile.hidden = YES;
    self.myGraph.hidden = YES;
    upArrow.hidden = YES;
    downArrow.hidden = YES;
    
    top.enabled = NO;
    
    noInternet.hidden = NO;
    
    internet = NO;
    
    tut.hidden = YES;
}

-(void)yesInternet {
    
    adView.hidden = NO;
    
    bTCPrice.hidden = NO;
    fiatPrice.hidden = NO;
    volume.hidden = NO;
    totalCoins.hidden = NO;
    marketCap.hidden = NO;
    lastChange.hidden = NO;
    dayChangePercent.hidden = NO;
    titleTotalCoins.hidden = NO;
    titleChange.hidden = NO;
    titleMarketCap.hidden = NO;
    title24Vol.hidden = NO;
    topTile.hidden = NO;
    midTile.hidden = NO;
    self.myGraph.hidden = NO;
    
    top.enabled = YES;
    
    noInternet.hidden = YES;
    
    internet = YES;
}

-(void)tutorial {
    
    tut.hidden = NO;
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setBool:YES forKey:@"opened"];
}

-(void)viewDidAppear:(BOOL)animated {
    
    NSLog(@"Home View: viewDidAppear Called");
    
    [self setSymbol];
    
    if (!self.myGraph.superview) {
        
        UIView *myRootView = [self.myGraph superview];
        [myRootView addSubview: self.myGraph];
        
    }
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
            NSLog(@"NETWORK IS REACHABILE");
            
            if (![parseTimer isValid]) {
                
                parseTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(parse) userInfo:nil repeats:YES];
            }
            
            [[NSNotificationCenter defaultCenter]addObserver:self
                                                    selector:@selector(comeFromBackground)
                                                        name:UIApplicationDidBecomeActiveNotification
                                                      object:nil];
            
            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
            if (![standardUserDefaults boolForKey:@"opened"]) {
                
                [self tutorial];
                
            }
            
            if (internet == NO) {
                [self yesInternet];
            }
            
            bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                CGRect screenBounds = [[UIScreen mainScreen] bounds];
                if (screenBounds.size.height == 568) {
                    bannerView_ = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height -GAD_SIZE_320x50.height, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
                } else {
                    bannerView_ = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height-GAD_SIZE_320x50.height, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
                }
                
                bannerView_.adUnitID = kGoogleBannerAdsID;
                bannerView_.rootViewController = self;
                [self.view addSubview:bannerView_];
                [bannerView_ loadRequest:[GADRequest request]];
            }
            
            interstitial_ = [[GADInterstitial alloc] init];
            interstitial_.adUnitID = kGoogleInterstitialAdsID;
            [interstitial_ loadRequest:[GADRequest request]];
            
            [self parse];
        } else {
            NSLog(@"NETWORK IS NOT REACHABLE");
            
            [self noInternet];
            
        }
        
    }];

}

-(void)viewDidDisappear:(BOOL)animated {
    
    NSLog(@"Home View: viewDidDisappear Called");
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    
    [parseTimer invalidate];
    parseTimer = nil;
}

#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[_arrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[_arrayOfValues objectAtIndex:index] floatValue];
}


@end
