//
//  Created by Oleksandr Nechet on 08.05.16.
//  Copyright © 2016 Oleksandr Nechet. All rights reserved.
//

#import "OLNNetworkActivityManager.h"
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface OLNNetworkActivityManager ()
// network activity counter (used to show/hide network activity indicator)
@property (nonatomic) NSUInteger networkActivityCount;
@end

@implementation OLNNetworkActivityManager

+ (instancetype)sharedManager {
    static OLNNetworkActivityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [OLNNetworkActivityManager new];
    });
    
    return _sharedManager;
}

+ (void)showHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    });
}

+ (void)hideHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
    });
}

+ (void)startNetworkActivity
{
    [[OLNNetworkActivityManager sharedManager] startNetworkActivity];
}

+ (void)stopNetworkActivity
{
    [[OLNNetworkActivityManager sharedManager] stopNetworkActivity];
}

- (void)startNetworkActivity
{
    self.networkActivityCount++;
}

- (void)stopNetworkActivity
{
    if (self.networkActivityCount > 0) {
        self.networkActivityCount--;
    }
}

- (void)setNetworkActivityCount:(NSUInteger)networkActivityCount
{
    if (_networkActivityCount != networkActivityCount) {
        _networkActivityCount = networkActivityCount;
        dispatch_async(dispatch_get_main_queue(), ^{
            UIApplication.sharedApplication.networkActivityIndicatorVisible = _networkActivityCount > 0;
        });
    }
}

@end
