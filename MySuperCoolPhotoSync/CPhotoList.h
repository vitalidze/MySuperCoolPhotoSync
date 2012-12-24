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
#import "IProgressListener.h";


@interface CPhotoList : UITableViewController <IProgressListener> {
    ALAssetsLibrary* library;
    NSMutableArray* assets;
    NSDateFormatter* dateFormatter;
    CSyncManager* syncManager;
    UIActivityIndicatorView* activityIndicator;
    UIProgressView* progressView;
    __weak IBOutlet UIBarButtonItem *btnDoSync;
}
- (IBAction)doSync:(id)sender;

@end
