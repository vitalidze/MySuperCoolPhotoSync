//
//  CSyncManager.m
//  MySuperCoolPhotoSync
//
//  Created by Vitaly Litvak on 8/12/12.
//  Copyright (c) 2012 litvak.su. All rights reserved.
//

#import "CSyncManager.h"
#import "CSettingsController.h"

@interface SyncStopper : NSObject
@property BOOL stopped;
-(void) stopPressed;
@end

@implementation SyncStopper

- (id)init
{
    self = [super init];
    if (self) {
        self.stopped = NO;
    }
    return self;
}

-(void) stopPressed {
    self.stopped = YES;
}

@end

@implementation CSyncManager

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)syncAssets: (NSMutableArray *)assets progressBar:(CProgressViewWithLabelAndCancelButton*) progressBar table:(UITableView *)table {
    
    NSLog(@"Syncing...");
    NSString* urlAddress = [NSString stringWithFormat:@"http://%@/sync", [CSettingsController getServerAddress]];
    
    // reset progress bar
    dispatch_sync(dispatch_get_main_queue(), ^{
        [progressBar setProgress: 0];
	});
    
    int count = 0;
    
    // initialize stopper object, used to stop synchrnonization cycle
    SyncStopper *stopper = [[SyncStopper alloc] init];
    [progressBar setStopTarget: stopper action: @selector(stopPressed)];
    
    for (int i = 0; i < [assets count]; i++) {
        CAsset* asset = [assets objectAtIndex: i];
        
        float progress = (float) ++count / [assets count];
        
        // update progress bar
        dispatch_sync(dispatch_get_main_queue(), ^{
            [progressBar setProgress: progress];
            [progressBar setText: [NSString stringWithFormat:@"Uploading %i of %i", i + 1, [assets count]]];
        });
        
        // check whether asset is already synced
        if ([self isSynced: asset]) {
            continue;
        }
        
        // set syncing attribute and update table UI
        asset.syncing = YES;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [table reloadRowsAtIndexPaths: [NSArray arrayWithObject: asset.indexPath] withRowAnimation: UITableViewRowAnimationNone];
        });
        
        // upload image
        NSError* error;
         
        NSString* response = [self uploadAsset: asset toUrl: urlAddress error: &error];
        
        // update syncing attribute
        asset.syncing = NO;
        if (!error) {
            // update 'synced' attribute if no error happened
            NSLog(@"Response: %@", response);
            asset.synced = YES;
        } else {
            NSLog(@"%@", error);
        }
        
        // update table UI
        dispatch_sync(dispatch_get_main_queue(), ^{
            [table reloadRowsAtIndexPaths: [NSArray arrayWithObject: asset.indexPath] withRowAnimation: UITableViewRowAnimationNone];
        });
        
        // stop if stop button was pressed
        if ([stopper stopped]) {
            break;
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
