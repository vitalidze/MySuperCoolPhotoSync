//
//  CAsset.h
//  MySuperCoolPhotoSync
//
//  Created by Vitaly Litvak on 11/1/13.
//  Copyright (c) 2013 litvak.su. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface CAsset : NSObject
@property ALAsset* asset;
@property BOOL synced;
@property BOOL syncing;
@property NSIndexPath* indexPath;

-(NSData*) getFileData;
-(NSString*) getFileName;
-(NSString*) getFileDate;
-(long) getFileSize;
-(UIImage*) getThumbnail;

+(CAsset*) initWithALAsset: (ALAsset*) asset;

@end
