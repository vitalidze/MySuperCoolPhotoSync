//
//  CAsset.m
//  MySuperCoolPhotoSync
//
//  Created by Vitaly Litvak on 11/1/13.
//  Copyright (c) 2013 litvak.su. All rights reserved.
//

#import "CAsset.h"

@implementation CAsset

+(CAsset *)initWithALAsset:(ALAsset *)asset {
    CAsset* result = [[CAsset alloc] init];
    if (result) {
        result.asset = asset;
    }
    return result;
}

-(NSString*) getFileName {
    ALAssetRepresentation* representation = [_asset defaultRepresentation];
    return [representation filename];
}
-(NSData*) getFileData {
    // only photos are supported for now
    ALAssetRepresentation* representation = [_asset defaultRepresentation];
    
    UIImage *img = [UIImage imageWithCGImage:[representation fullResolutionImage]];
    
    return UIImageJPEGRepresentation(img, 1.0); // convert image in NSData
}
-(NSString*) getFileDate {
    ALAssetRepresentation* representation = [_asset defaultRepresentation];
    NSDate * date = [_asset valueForProperty:ALAssetPropertyDate];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/YY HH:mm:ss"];
    
    return [formatter stringFromDate: date];
}

-(long) getFileSize {
    ALAssetRepresentation* representation = [_asset defaultRepresentation];
    
    return [representation size];
}

-(UIImage*) getThumbnail {
    return [UIImage imageWithCGImage: [_asset thumbnail]];
}

@end
