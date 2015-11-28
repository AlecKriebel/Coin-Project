//
//  FadeSegue.m
//  Quark
//
//  Created by Alec Kriebel on 12/14/13.
//  Copyright (c) 2013 Alec Kriebel. All rights reserved.
//

#import "FadeSegue.h"
#import <QuartzCore/QuartzCore.h>

@implementation FadeSegue

- (void)perform
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionFade;
    
    [[[[[self sourceViewController] view] window] layer] addAnimation:transition
                                                               forKey:kCATransitionFade];
    
    [[self sourceViewController]
     presentViewController:[self destinationViewController]
     animated:NO completion:NULL];
}

@end
