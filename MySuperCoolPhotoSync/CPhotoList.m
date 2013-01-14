//
//  CPhotoList.m
//  MySuperCoolPhotoSync
//
//  Created by Vitaly Litvak on 1/12/12.
//  Copyright (c) 2012 litvak.su. All rights reserved.
//

#import "CPhotoList.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation CPhotoList

- (void) viewDidLoad {
    [super viewDidLoad];
    
    assets = [NSMutableArray arrayWithCapacity:10];
    syncManager = [[CSyncManager alloc] init];
    library = [[ALAssetsLibrary alloc] init];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    progressView = [[CProgressViewWithLabelAndCancelButton alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [assets removeAllObjects];
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            NSLog(@"Loaded group %@", group);
            
            ALAssetsGroupEnumerationResultsBlock listAssetsBlock = ^(ALAsset* asset, NSUInteger index, BOOL *stop) {
                // TODO uncomment condition
                if (asset != nil) {// && ![syncManager isSynced: asset]) {
                    [assets addObject: [CAsset initWithALAsset: asset]];
                }
            };
            
            [group enumerateAssetsUsingBlock: listAssetsBlock];
        } else {
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    };
    
    [library enumerateGroupsWithTypes: ALAssetsGroupSavedPhotos usingBlock:listGroupBlock failureBlock: NULL];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction) doSync:(id)sender {
    [self.navigationController setToolbarHidden: NO animated:YES];
    self.navigationController.toolbar.items = progressView.barItems;
    
    btnDoSync.customView = activityIndicator;
    
    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];

    [self performSelectorInBackground:@selector(syncAssetsThreaded) withObject: nil];
}

- (void) syncAssetsThreaded {
    [syncManager syncAssets:assets progressBar: progressView table: [self tableView]];
    
    [self performSelectorOnMainThread:@selector(syncFinished) withObject: nil waitUntilDone:NO];
}

- (void) syncFinished {
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
    
    btnDoSync.customView = nil;
    
    [self.navigationController setToolbarHidden: YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)p_tableView cellForRowAtIndexPath:(NSIndexPath *)i {
    UITableViewCell *cell = [p_tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    CAsset* asset = [assets objectAtIndex: [i item]];
    
    cell.textLabel.text = [asset getFileName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %.1f KB", [asset getFileDate], [asset getFileSize] / 1024.0];
    cell.imageView.image = [asset getThumbnail];
    
    if ([asset syncing]) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        [cell setAccessoryView:activityView];
    } else {
        [cell setAccessoryView: nil];
    }
    
    if ([asset synced]) {
        cell.textLabel.enabled = NO;
        cell.detailTextLabel.enabled = NO;
        cell.imageView.alpha = 0.2;
    }
    
    if (asset.indexPath == nil) {
        asset.indexPath = i;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return assets.count;
}

@end
