//
//  NSString+Utility.h
//  ASFlickr
//
//  Created by Oleksandr Nechet on 12.06.16.
//  Copyright © 2016 Oleksandr Nechet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)
+ (NSString *)documentsDirectoryPath;
+ (NSString *)documentsDirectoryWithLastPathComponent:(NSString *)lastPathComponent;
@end
