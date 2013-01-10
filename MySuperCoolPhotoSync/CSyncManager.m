//
//  CSyncManager.m
//  MySuperCoolPhotoSync
//
//  Created by Vitaly Litvak on 8/12/12.
//  Copyright (c) 2012 litvak.su. All rights reserved.
//

#import "CSyncManager.h"
#import "CSettingsController.h"

@implementation CSyncManager

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)syncAssets: (NSMutableArray *)assets withProgressListenerObject: (id) progressListener andMethod:(SEL) progressChangedMethod {
    
    NSLog(@"Syncing...");
    NSString* urlAddress = [NSString stringWithFormat:@"http://%@/sync", [CSettingsController getServerAddress]];
    
    [progressListener performSelectorOnMainThread: progressChangedMethod withObject:[NSNumber numberWithFloat: 0.0] waitUntilDone:YES];
    int count = 0;
    
    
    for (ALAsset* asset in assets) {
        float progress = (float) ++count / [assets count];
        [progressListener performSelectorOnMainThread: progressChangedMethod withObject:[NSNumber numberWithFloat: progress] waitUntilDone:YES];
        
        if ([self isSynced: asset]) {
            continue;
        }
        
        ALAssetRepresentation* representation = [asset defaultRepresentation];
        
        UIImage *img = [UIImage imageWithCGImage:[representation fullResolutionImage]];
        NSError* error;
         
        NSString* response = [self uploadImage: img toUrl: urlAddress withFileName: [representation filename] error: &error];
        if (!error) {
            NSLog(@"Response: %@", response);
        } else {
            NSLog(@"%@", error);
        }
    }
}

-(NSString*) uploadImage: (UIImage*) image toUrl: (NSString*) urlString withFileName: (NSString*) fileName error: (NSError**) error {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0); // convert image in NSData
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *imgNameString = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", fileName];
    [body appendData:[[NSString stringWithString:imgNameString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error: error];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    return returnString;
}

-(BOOL)isSynced:(ALAsset *)asset {
    ALAssetRepresentation* representation = [asset defaultRepresentation];
    
    NSString* urlAddress = [NSString stringWithFormat:@"http://%@/is_synced?fileName=%@", [CSettingsController getServerAddress], [representation filename]];
    
    NSURLRequest* request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlAddress]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* strResponse = [[NSString alloc] initWithData: response encoding: NSUTF8StringEncoding];

    //NSError *jsonParsingError = nil;
    //BOOL isSyncedResponse = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
    
    return [strResponse isEqualToString: @"true"];
}

@end
