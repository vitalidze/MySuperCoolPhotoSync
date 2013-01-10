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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!library) {
        library = [[ALAssetsLibrary alloc] init];
    }
    
    if (assets) {
        [assets removeAllObjects];
    } else {
        assets = [NSMutableArray arrayWithCapacity:10];
    }
    
    if (!syncManager) {
        syncManager = [[CSyncManager alloc] init];
    }
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    if (!activityIndicator) {
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    
    if (!progressView) {
        progressView = [[UIProgressView alloc] initWithProgressViewStyle: UIProgressViewStyleBar];
    }
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            NSLog(@"Loaded group %@", group);
            
            ALAssetsGroupEnumerationResultsBlock listAssetsBlock = ^(ALAsset* asset, NSUInteger index, BOOL *stop) {
                if (asset != nil) {// && ![syncManager isSynced: asset]) {
                    [assets addObject: [CAsset initWithALAsset: asset]];
                }
//                NSLog(@"Assets count %i", assets.count);
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
    UIBarButtonItem* buttonStop = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIBarButtonItem* progressBar = [[UIBarButtonItem alloc] initWithCustomView: progressView];
    [progressBar setWidth: 245.0];
    
    [self.navigationController setToolbarHidden: NO animated:YES];
    self.navigationController.toolbar.items = [NSArray arrayWithObjects:buttonStop, progressBar, nil];
    
    btnDoSync.customView = activityIndicator;
    
    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];

    [self performSelectorInBackground:@selector(syncAssetsThreaded) withObject: nil];
}

- (void) syncAssetsThreaded {
    [syncManager syncAssets:assets withProgressListenerObject: self andMethod: @selector(progressChanged:)];
    
    [self performSelectorOnMainThread:@selector(syncFinished) withObject: nil waitUntilDone:NO];
}

- (void) syncFinished {
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
    
    btnDoSync.customView = nil;
    
    [self.navigationController setToolbarHidden: YES animated:YES];
}

- (void) progressChanged: (NSNumber*) progress {
    [progressView setProgress: [progress floatValue]];
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
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return assets.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView startAnimating];
    [cell setAccessoryView:activityView];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
}

@end
