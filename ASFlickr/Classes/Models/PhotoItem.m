//
//  PhotoItem.m
//  ASFlickr
//
//  Created by Oleksandr Nechet on 10.06.16.
//  Copyright © 2016 Oleksandr Nechet. All rights reserved.
//

#import "PhotoItem.h"

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

#pragma mark -

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _title = dictionary[@"title"];
        _link = dictionary[@"link"];
    }
    
    return self;
}

- (NSURL *)url
{
    return [NSURL URLWithString:self.link];
}

@end
