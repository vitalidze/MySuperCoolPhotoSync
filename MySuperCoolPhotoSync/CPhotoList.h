//
//  CPhotoList.h
//  MySuperCoolPhotoSync
//
//  Created by Vitaly Litvak on 1/12/12.
//  Copyright (c) 2012 litvak.su. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "CSyncManager.h"

@interface CPhotoList : UITableViewController {
    ALAssetsLibrary* library;
    NSMutableArray* assets;
    CSyncManager* syncManager;
}
- (IBAction)doSync:(id)sender;

@end
