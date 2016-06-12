//
//  DetailVC.m
//  ASFlickr
//
//  Created by Oleksandr Nechet on 10.06.16.
//  Copyright © 2016 Oleksandr Nechet. All rights reserved.
//

#import "DetailVC.h"
#import "PhotoItem.h"
#import "OLNStorageManager.h"

@interface DetailVC ()
{
    __weak IBOutlet UIImageView *imageViewMain;
}

@end

@implementation DetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.photoItemSelected.title;
    if (self.photoItemSelected.isCached) {
        [self updateImage];
    }
    else {
        [[OLNStorageManager sharedManager] cacheImageForPhotoItem:self.photoItemSelected
                                                       completion:^(BOOL success) {
                                                           [self updateImage];
                                                       }];
    }
}

- (void)updateImage
{
    NSData *data = [NSData dataWithContentsOfURL:self.photoItemSelected.cacheURL];
    UIImage * img = [UIImage imageWithData:data];
    imageViewMain.image = img;
}

@end
