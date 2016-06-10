//
//  OLNNetworkManager.m
//  ASFlickr
//
//  Created by Oleksandr Nechet on 10.06.16.
//  Copyright © 2016 Oleksandr Nechet. All rights reserved.
//

#import "OLNNetworkManager.h"
#import <UIKit/UIKit.h>
#import "PhotoItem.h"
#import "OLNNetworkActivityManager.h"

@interface OLNNetworkManager()
@end

@implementation OLNNetworkManager
+ (instancetype)sharedManager
{
    static OLNNetworkManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [OLNNetworkManager new];
    });
    
    return _sharedManager;
}

- (void)list:(void(^)(NSArray *list))completion
{
    NSURL *url = [NSURL URLWithString:@"http://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
   
    [OLNNetworkActivityManager showHUD];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [OLNNetworkActivityManager hideHUD];
        if (error) {
            [self showAlertWithError:error];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil);
            });
        }
        else {
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error: &err];
            if (err) {
                [self showAlertWithError:err];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil);
                });
            }
            else {
                NSArray *result;
                @autoreleasepool {
                    NSArray *items = dict[@"items"];
                    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:items.count];
                    for (NSDictionary *item in items) {
                        PhotoItem *pi = [[PhotoItem alloc] initWithDictionary:item];
                        [temp addObject:pi];
                    }
                    result = [NSArray arrayWithArray:temp];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(result);
                });
            }
        }
        
    }];
    [task resume];
}

#pragma mark - Alert

- (void)showAlertWithTitle:(NSString *)t message:(NSString *)m completion:(void(^)())block
{
    UIAlertController *view = [UIAlertController
                                 alertControllerWithTitle:t
                                 message:m
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action) {
                             [view dismissViewControllerAnimated:YES completion:nil];
                             if (block) {
                                 block();
                             }
                         }];
    
    [view addAction:ok];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[[UIApplication sharedApplication] delegate] window].rootViewController presentViewController:view animated:YES completion:nil];
    });
}

- (void)showAlertWithError:(NSError *)error
{
    [self showAlertWithTitle:@"An error occured" message:error.localizedDescription completion:nil];
}

@end
