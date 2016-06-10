//
//  HomeListTVC.m
//  ASFlickr
//
//  Created by Oleksandr Nechet on 10.06.16.
//  Copyright © 2016 Oleksandr Nechet. All rights reserved.
//

#import "HomeListTVC.h"
#import "OLNNetworkManager.h"
#import "PhotoItem.h"
#import "DetailVC.h"

static NSString *const segueToDetailVC = @"segueToDetailVC";

@interface HomeListTVC ()
{
    NSArray *arrayAllItems;
    NSArray *arrayStoredItems;
}

@end

@implementation HomeListTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refresh:nil];
    [self setupPullToRefresh];
     self.clearsSelectionOnViewWillAppear = NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self downloadImage];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (arrayAllItems.count) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
    }
    else {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayAllItems.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"bla bla bla row #%d", indexPath.row];
    PhotoItem *item = arrayAllItems[indexPath.row];
    cell.textLabel.text = item.title;
    return cell;
}

#pragma mark - Helpers

- (void)refresh:(UIRefreshControl *)refreshControl
{
    __weak typeof(self) wSelf = self;
    [[OLNNetworkManager sharedManager] list:^(NSArray *list) {
        typeof(wSelf) sSelf = self;
        
        if (refreshControl) {
            [refreshControl endRefreshing];
        }
        
        arrayAllItems = list;
        [sSelf.tableView reloadData];
    }];
}

- (void)setupPullToRefresh
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refresh:)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)downloadImage
{
    PhotoItem *item = arrayAllItems[self.tableView.indexPathForSelectedRow.row];
    UIAlertController *view = [UIAlertController
                               alertControllerWithTitle:@"Download options"
                               message:item.title
                               preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *download = [UIAlertAction
                               actionWithTitle:@"Download image and save to disk"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [view dismissViewControllerAnimated:YES completion:nil];
                                   [self performSegueWithIdentifier:segueToDetailVC sender:nil];
                               }];
    
    UIAlertAction *open = [UIAlertAction
                           actionWithTitle:@"Open in browser"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               [view dismissViewControllerAnimated:YES completion:nil];
                               [[UIApplication sharedApplication] openURL:item.url];
                           }];
    
    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action) {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    [view addAction:download];
    [view addAction:open];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

@end
