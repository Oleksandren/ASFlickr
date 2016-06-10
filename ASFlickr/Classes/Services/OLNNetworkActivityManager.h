//
//  Created by Oleksandr Nechet on 08.05.16.
//  Copyright © 2016 Oleksandr Nechet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLNNetworkActivityManager : NSObject
+ (void)stopNetworkActivity;
+ (void)startNetworkActivity;
+ (void)showHUD;
+ (void)hideHUD;
@end
