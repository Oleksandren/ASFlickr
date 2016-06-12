//
//  PhotoItem.h
//  ASFlickr
//
//  Created by Oleksandr Nechet on 10.06.16.
//  Copyright © 2016 Oleksandr Nechet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoItem : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *localPath;
@property (nonatomic, weak, readonly) NSURL *url;
@property (nonatomic, weak, readonly) NSURL *cacheURL;
@property (nonatomic, assign, readonly, getter=isCached) BOOL cached;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
