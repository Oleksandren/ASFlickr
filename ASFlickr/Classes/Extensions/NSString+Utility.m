//
//  NSString+Utility.m
//  ASFlickr
//
//  Created by Oleksandr Nechet on 12.06.16.
//  Copyright © 2016 Oleksandr Nechet. All rights reserved.
//

#import "NSString+Utility.h"

@implementation NSString (Utility)

+ (NSString *)documentsDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString *)documentsDirectoryWithLastPathComponent:(NSString *)lastPathComponent
{
    return [[NSString documentsDirectoryPath] stringByAppendingPathComponent:lastPathComponent];
}

@end
