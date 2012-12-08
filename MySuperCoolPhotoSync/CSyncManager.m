//
//  CSyncManager.m
//  MySuperCoolPhotoSync
//
//  Created by Vitaly Litvak on 8/12/12.
//  Copyright (c) 2012 litvak.su. All rights reserved.
//

#import "CSyncManager.h"
#import "ASIFormDataRequest.h"

@implementation CSyncManager

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)syncAssets:(NSMutableArray *)assets {
    
    NSLog(@"Syncing...");
    NSURL* url = [NSURL URLWithString:@"http://localhost:8080/sync"];
    
    for (ALAsset* asset in assets) {
        if ([self isSynced: asset]) {
            continue;
        }
        
        ALAssetRepresentation* representation = [asset defaultRepresentation];
        
        ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod: @"POST"];
        
        UIImage *img = [UIImage imageWithCGImage:[representation fullResolutionImage]];
        //[request appendPostData: UIImageJPEGRepresentation(img, 1.0)];
        [request setData:UIImageJPEGRepresentation(img, 1.0) withFileName:[representation filename] andContentType:@"multipart/form-data" forKey:@"file"];
        [request startSynchronous];
        
        NSError *error = [request error];
        if (!error) {
            NSString *response = [request responseString];
            NSLog(@"Response: %@", response);
        } else {
            NSLog(@"%@", error);
        }
    }
}

-(BOOL)isSynced:(ALAsset *)asset {
    ALAssetRepresentation* representation = [asset defaultRepresentation];
    
    NSString* strUrl = [NSString stringWithFormat:@"http://localhost:8080/is_synced?fileName=%@", [representation filename]];
    
    NSURLRequest* request = [NSURLRequest requestWithURL: [NSURL URLWithString:strUrl]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* strResponse = [[NSString alloc] initWithData: response encoding: NSUTF8StringEncoding];

    //NSError *jsonParsingError = nil;
    //BOOL isSyncedResponse = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
    
    return [strResponse isEqualToString: @"true"];
}

@end
