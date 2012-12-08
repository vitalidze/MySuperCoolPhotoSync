//
//  ISyncProgressListener.h
//  MySuperCoolPhotoSync
//
//  Created by Vitaly Litvak on 8/12/12.
//  Copyright (c) 2012 litvak.su. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


@protocol ISyncProgressListener <NSObject>
- (void) synced: (ALAsset*) asset, double percentage;
@end
