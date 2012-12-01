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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    library = [[ALAssetsLibrary alloc] init];
    assets = [NSMutableArray arrayWithCapacity:10];
    
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
        }
    };
    
    [library enumerateGroupsWithTypes: ALAssetsGroupSavedPhotos usingBlock:listGroupBlock failureBlock: NULL];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)i {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ALAsset* asset = [assets objectAtIndex: [i item]];
    ALAssetRepresentation* representation = [asset defaultRepresentation];
    cell.textLabel.text = [representation filename];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lli", [representation size]];
    cell.imageView.image = [UIImage imageWithCGImage: [asset thumbnail]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return assets.count;
}

@end
