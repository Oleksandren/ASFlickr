//
//  DetailVC.h
//  ASFlickr
//
//  Created by Oleksandr Nechet on 10.06.16.
//  Copyright © 2016 Oleksandr Nechet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoItem;

@interface DetailVC : UIViewController
@property (nonatomic, strong) PhotoItem *photoItemSelected;
@end
