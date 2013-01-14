//
//  CSyncManager.h
//  MySuperCoolPhotoSync
//
//  Created by Vitaly Litvak on 8/12/12.
//  Copyright (c) 2012 litvak.su. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAsset.h"
#import "CProgressViewWithLabelAndCancelButton.h"

@interface CSyncManager : NSObject 
-(void)syncAssets: (NSMutableArray*) assets progressBar: (CProgressViewWithLabelAndCancelButton*) progressBar table: (UITableView*) table;
-(BOOL)isSynced: (CAsset*) asset;
-(BOOL)checkConnection: (NSString*) urlAddress;
@end
