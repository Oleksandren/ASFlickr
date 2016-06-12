//
//  OLNStorageManager.h
//  ASFlickr
//
//  Created by Oleksandr Nechet on 11.06.16.
//  Copyright © 2016 Oleksandr Nechet. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PhotoItem;

static NSString *const OLNStorageManagerDidUpdatePhotosNotification = @"OLNStorageManagerDidUpdatePhotosNotification";


@interface OLNStorageManager : NSObject
@property (nonatomic, weak, readonly) NSArray *photos;
@property (nonatomic, weak, readonly) NSArray *photosCached;
+ (instancetype)sharedManager;
- (void)refresh:(void (^)())completion;
/// PhotoItem will be added to photosCached array;
- (void)cacheImageForPhotoItem:(PhotoItem *)item
                    completion:(void (^)(BOOL success))completion;
@end
