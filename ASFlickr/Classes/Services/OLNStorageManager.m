//
//  OLNStorageManager.m
//  ASFlickr
//
//  Created by Oleksandr Nechet on 11.06.16.
//  Copyright © 2016 Oleksandr Nechet. All rights reserved.
//

#import "OLNStorageManager.h"
#import "OLNNetworkManager.h"
#import "PhotoItem.h"

static NSString *const kPhotos = @"Photos";
static NSString *const kPhotosCached = @"PhotosCached";


@implementation OLNStorageManager

+ (instancetype)sharedManager
{
    static OLNStorageManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [OLNStorageManager new];
    });
    
    return _sharedManager;
}

- (NSArray *)photos
{
    return [self unarchiveArrayByKey:kPhotos];
}

- (NSArray *)photosCached
{
    return [self unarchiveArrayByKey:kPhotosCached];
}

- (void)setPhotos:(NSArray *)photos
{
    if (photos && ![self.photos isEqual:photos]) {
        [self archiveArray:photos ByKey:kPhotos];
    }
}

- (void)setPhotosCached:(NSArray *)photosCached
{
    if (photosCached && ![self.photosCached isEqual:photosCached]) {
        [self archiveArray:photosCached ByKey:kPhotosCached];
    }
}

- (void)refresh:(void (^)())completion
{
    __weak typeof(self) wSelf = self;
    [[OLNNetworkManager sharedManager] list:^(NSArray *list) {
        typeof(wSelf) sSelf = self;
        [sSelf setPhotos:list];
        if (completion) {
            completion();
        }
    }];
}

- (void)cacheImageForPhotoItem:(PhotoItem *)item completion:(void (^)(BOOL success))completion
{
    if (!item.isCached) {
        __weak typeof(self) wSelf = self;
        [[OLNNetworkManager sharedManager] imageByURL:item.url
                                             cacheURL:item.cacheURL
                                           completion:^(BOOL success) {
                                               if (success) {
                                                   typeof(wSelf) sSelf = self;
                                                   @autoreleasepool {
                                                       NSMutableArray *temp = [NSMutableArray arrayWithArray:sSelf.photosCached];
                                                       [temp addObject:item];
                                                       [sSelf setPhotosCached:[NSArray arrayWithArray:temp]];
                                                   }
                                               }
                                               if (completion) {
                                                   completion(success);
                                               }
                                           }];
    }
}

#pragma mark - Archive & Unarchive

- (NSArray *)unarchiveArrayByKey:(NSString *)key
{
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [currentDefaults objectForKey:key];
    if (data) {
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return arr;
    }
    return nil;
}

- (void)archiveArray:(NSArray *)array ByKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:array]
                                              forKey:key];
}



@end
