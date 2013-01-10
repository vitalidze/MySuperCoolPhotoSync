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

- (void) progressChanged: (NSNumber*) progress {
    
}

-(void)syncAssets: (NSMutableArray *)assets progressBar:(UIProgressView *)progressBar table:(UITableView *)table {
    
    NSLog(@"Syncing...");
    NSString* urlAddress = [NSString stringWithFormat:@"http://%@/sync", [CSettingsController getServerAddress]];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [progressBar setProgress: 0];
	});
    
    int count = 0;
    
    
    for (CAsset* asset in assets) {
        float progress = (float) ++count / [assets count];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [progressBar setProgress: progress];
        });
        
        if ([self isSynced: asset]) {
            continue;
        }
        
        asset.syncing = YES;
        
        NSError* error;
         
        NSString* response = [self uploadAsset: asset toUrl: urlAddress error: &error];
        
        asset.syncing = NO;
        
        if (!error) {
            NSLog(@"Response: %@", response);
            asset.synced = YES;
        } else {
            NSLog(@"%@", error);
        }
    }
}

-(NSString*) uploadAsset: (CAsset*) asset toUrl: (NSString*) urlString error: (NSError**) error {
    NSData *imageData = [asset getFileData];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // TODO change content-disposition to appropriate file type
    NSString *imgNameString = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", [asset getFileName]];
    [body appendData:[[NSString stringWithString:imgNameString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error: error];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    return returnString;
}

-(BOOL)isSynced:(CAsset*) asset {
    if (!asset.synced) {
        NSString* urlAddress = [NSString stringWithFormat:@"http://%@/is_synced?fileName=%@", [CSettingsController getServerAddress], [asset getFileName]];
    
        NSURLRequest* request = [NSURLRequest requestWithURL: [NSURL URLWithString:urlAddress]];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString* strResponse = [[NSString alloc] initWithData: response encoding: NSUTF8StringEncoding];

        //NSError *jsonParsingError = nil;
        //BOOL isSyncedResponse = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
        asset.synced = [strResponse isEqualToString: @"true"];
    }
    
    return asset.synced;
}

@end
