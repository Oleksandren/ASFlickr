//
//  HomeListTVC.m
//  ASFlickr
//
//  Created by Oleksandr Nechet on 10.06.16.
//  Copyright © 2016 Oleksandr Nechet. All rights reserved.
//

#import "HomeListTVC.h"
#import "OLNStorageManager.h"
#import "PhotoItem.h"
#import "DetailVC.h"

static NSString *const segueToDetailVC = @"segueToDetailVC";

@interface HomeListTVC ()
{
    NSArray *arrayDisplayedItems;
    BOOL selectedStateCachedItems;
    UIRefreshControl *_refreshControl;
}

@end

@implementation HomeListTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupPullToRefresh];
    self.clearsSelectionOnViewWillAppear = NO;
    
    arrayDisplayedItems = [OLNStorageManager sharedManager].photos;
    if (arrayDisplayedItems) {
        [self.tableView reloadData];
    }
    else {
        [self refresh:nil];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self downloadImage];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (arrayDisplayedItems.count) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
    }
    else {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
        NSString *message;
        if (selectedStateCachedItems) {
            message = @"No cached objects.";
        }
        else {
            message = @"No data is currently available. Please pull down to refresh.";
        }
        messageLabel.text = message;
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
    return arrayDisplayedItems.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    PhotoItem *item = arrayDisplayedItems[indexPath.row];
    cell.textLabel.text = item.title;
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:segueToDetailVC]) {
        DetailVC *vc = segue.destinationViewController;
        NSIndexPath *indexPathSelected = self.tableView.indexPathForSelectedRow;
        vc.photoItemSelected = arrayDisplayedItems[indexPathSelected.row];
    }
}

#pragma mark - IBActions

- (IBAction)didChangeTab:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        self.refreshControl = _refreshControl;
        arrayDisplayedItems = [OLNStorageManager sharedManager].photos;
    }
    else {
        self.refreshControl = nil;
        arrayDisplayedItems = [OLNStorageManager sharedManager].photosCached;
    }
    
    selectedStateCachedItems = (sender.selectedSegmentIndex == 1);
    [self.tableView reloadData];
}

#pragma mark - Helpers

- (void)refresh:(UIRefreshControl *)refreshControl
{
    __weak typeof(self) wSelf = self;
    [[OLNStorageManager sharedManager] refresh:^{
        typeof(wSelf) sSelf = self;
        
        if (refreshControl) {
            [refreshControl endRefreshing];
        }
    
        arrayDisplayedItems = [OLNStorageManager sharedManager].photos;
        [sSelf.tableView reloadData];
    }];
}

- (void)setupPullToRefresh
{
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self
                            action:@selector(refresh:)
                  forControlEvents:UIControlEventValueChanged];
    self.refreshControl = _refreshControl;
}

- (void)downloadImage
{
    PhotoItem *item = arrayDisplayedItems[self.tableView.indexPathForSelectedRow.row];
    
    if (item.isCached) {
        [self performSegueWithIdentifier:segueToDetailVC sender:nil];
    }
    else {
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
}

@end
