//
//  OLNNetworkManager.h
//  ASFlickr
//
//  Created by Oleksandr Nechet on 10.06.16.
//  Copyright © 2016 Oleksandr Nechet. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;

@interface OLNNetworkManager : NSObject
+ (instancetype) sharedManager;
- (void)list:(void(^)(NSArray *list))completion;
-(void)imageByURL:(NSURL *)url
        cacheURL:(NSURL *)cachedURL
       completion:(void(^)(BOOL success))completion;
@end
