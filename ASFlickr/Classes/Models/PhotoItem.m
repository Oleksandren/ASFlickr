//
//  PhotoItem.m
//  ASFlickr
//
//  Created by Oleksandr Nechet on 10.06.16.
//  Copyright © 2016 Oleksandr Nechet. All rights reserved.
//

#import "PhotoItem.h"
#import "NSString+Utility.h"

static NSString *const kTitle = @"Title";
static NSString *const kLink = @"Link";

@interface PhotoItem() <NSCoding>
@end

@implementation PhotoItem

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _title = [aDecoder decodeObjectForKey:kTitle];
        _link = [aDecoder decodeObjectForKey:kLink];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:kTitle];
    [aCoder encodeObject:self.link forKey:kLink];
}

#pragma mark - Lifecycle

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _title = dictionary[@"title"];
        _link = dictionary[@"media"][@"m"];
    }
    
    return self;
}

#pragma mark - Helpers

- (void)clearCachedData
{
    NSError *error;
    if (self.isCached) {
        [[NSFileManager defaultManager] removeItemAtPath:self.localPath error:&error];
        if (error) {
            NSLog(@"Error deleting the cached image: %@", error.localizedDescription);
        }
    }
}

#pragma mark - Convenience properties

- (NSURL *)url
{
    return [NSURL URLWithString:self.link];
}

- (NSURL *)cacheURL
{
    return [NSURL fileURLWithPath:self.localPath];
}

- (BOOL)isCached
{
    return [[NSFileManager defaultManager] fileExistsAtPath:self.localPath];
}

- (NSString *)localPath
{
    return [NSString documentsDirectoryWithLastPathComponent:[self imageName]];
}

- (NSString *)imageName
{
    return self.link.lastPathComponent;
}

@end
