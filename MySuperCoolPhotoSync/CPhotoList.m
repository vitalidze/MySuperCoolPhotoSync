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
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            NSLog(@"Loaded group %@", group);
            
            ALAssetsGroupEnumerationResultsBlock listAssetsBlock = ^(ALAsset* asset, NSUInteger index, BOOL *stop) {
                if (asset != nil) {
                    [assets addObject: asset];
                }
                NSLog(@"Assets count %i", assets.count);
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
    [syncManager syncAssets: assets];
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
    ALAsset* asset = [assets objectAtIndex: [i item]];
    ALAssetRepresentation* representation = [asset defaultRepresentation];
    cell.textLabel.text = [representation filename];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Synced: %@, Size: %.1f KB", [syncManager isSynced: asset] ? @"yes" : @"no", [representation size] / 1024.0];
    cell.imageView.image = [UIImage imageWithCGImage: [asset thumbnail]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return assets.count;
}

@end
