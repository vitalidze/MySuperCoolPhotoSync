//
//  CViewController.m
//  MySuperCoolPhotoSync
//
//  Created by Vitaly Litvak on 18/11/12.
//  Copyright (c) 2012 litvak.su. All rights reserved.
//

#import "CViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface CViewController ()

@end

@implementation CViewController

ALAssetsLibrary* library;

- (void)viewDidLoad
{
    [super viewDidLoad];
    library = [[ALAssetsLibrary alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doSync:(id)sender {
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            NSLog(@"Loaded group %@", group);
//            [groups addObject:group];
            
            ALAssetsGroupEnumerationResultsBlock listAssetsBlock = ^(ALAsset* asset, NSUInteger index, BOOL *stop) {
                ALAssetRepresentation* r = [asset defaultRepresentation];
                NSLog(@"Loaded asset %@ at %@ size = %i, UTI = %@", [r filename], [r url], [r size], [r UTI]);
                CGImageRef imgref = [r fullResolutionImage];
              //  UIImage* image = [UIImage imageWithCGImage:<#(CGImageRef)#>]
            };
            
            [group enumerateAssetsUsingBlock: listAssetsBlock];
        } else {
            // Add the favorites group if it has any elements
//            if (!favoriteAssets) {
//                favoriteAssets = [[FavoriteAssets alloc] init];
//            }
//            if ([favoriteAssets count] > 0) {
//                [groups addObject:favoriteAssets];
//            }
//            
//            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        NSLog(@"Failed loading group: err code @i", [error code]);
//        AssetsDataIsInaccessibleViewController *assetsDataInaccessibleViewController = [[AssetsDataIsInaccessibleViewController alloc] initWithNibName:@"AssetsDataIsInaccessibleViewController" bundle:nil];
//        
//        NSString *errorMessage = nil;
//        switch ([error code]) {
//            case ALAssetsLibraryAccessUserDeniedError:
//            case ALAssetsLibraryAccessGloballyDeniedError:
//                errorMessage = @"The user has declined access to it.";
//                break;
//            default:
//                errorMessage = @"Reason unknown.";
//                break;
//        }
//        
//        assetsDataInaccessibleViewController.explanation = errorMessage;
//        [self presentViewController:assetsDataInaccessibleViewController animated:NO completion: nil];
//        [assetsDataInaccessibleViewController release];
    };
    
//    NSUInteger groupTypes = ALAssetsGroupSavedPhotos
    [library enumerateGroupsWithTypes: ALAssetsGroupSavedPhotos usingBlock: listGroupBlock failureBlock: failureBlock];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


@end
