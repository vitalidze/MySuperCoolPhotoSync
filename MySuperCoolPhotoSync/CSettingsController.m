//
//  CSettingsController.m
//  MySuperCoolPhotoSync
//
//  Created by Vitaly Litvak on 25/12/12.
//  Copyright (c) 2012 litvak.su. All rights reserved.
//

#import "CSettingsController.h"



@implementation CSettingsController

NSString const* KEY_SERVER_ADDRESS = @"KeyServerAddress";
NSString const* KEY_BACKGROUND_SYNC = @"KeyBackgroundSync";
NSString const* KEY_ALBUM_SYNC = @"KeyAlbumSync";
NSString const* KEY_VIDEO_SYNC = @"KeyVideoSync";

+ (void) initialize {
    NSMutableDictionary *defaults = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @"", KEY_SERVER_ADDRESS,
                                    [NSNumber numberWithBool: NO], KEY_BACKGROUND_SYNC,
                                    [NSNumber numberWithBool: NO], KEY_ALBUM_SYNC,
                                    [NSNumber numberWithBool: NO], KEY_VIDEO_SYNC,
                                    nil];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults: defaults];
}

- (void) viewDidLoad {
    [_fldServerAddress setText: [CSettingsController getServerAddress]];
    [_swBackgroundSync setOn: [CSettingsController isBackgroundSync]];
    [_swAlbumSync setOn: [CSettingsController isAlbumSync]];
    [_swVideoSync setOn: [CSettingsController isVideoSync]];
}

+ (void) setServerAddress:(NSString *)serverAddress {
    [[NSUserDefaults standardUserDefaults] setValue:serverAddress forKey:KEY_SERVER_ADDRESS];
}

+ (NSString*) getServerAddress {
    return [[NSUserDefaults standardUserDefaults] valueForKey:KEY_SERVER_ADDRESS];
}

+ (void) setAlbumSync:(BOOL)albumSync {
    [[NSUserDefaults standardUserDefaults] setBool: albumSync forKey: KEY_ALBUM_SYNC];
}

+ (BOOL) isAlbumSync {
    return [[NSUserDefaults standardUserDefaults] boolForKey: KEY_ALBUM_SYNC];
}

+ (void) setBackgroundSync:(BOOL)backgroundSync {
    [[NSUserDefaults standardUserDefaults] setBool: backgroundSync forKey: KEY_BACKGROUND_SYNC];
}

+ (BOOL) isBackgroundSync {
    return [[NSUserDefaults standardUserDefaults] boolForKey: KEY_BACKGROUND_SYNC];
}

+ (void) setVideoSync:(BOOL)videoSync {
    [[NSUserDefaults standardUserDefaults] setBool: videoSync forKey: KEY_VIDEO_SYNC];
}

+ (BOOL) isVideoSync {
    return [[NSUserDefaults standardUserDefaults] boolForKey: KEY_VIDEO_SYNC];
}

- (IBAction)serverAddressEntered:(id)sender {
    [CSettingsController setServerAddress: [_fldServerAddress text]];
}

- (IBAction)backgroundSyncOptionChanged:(id)sender {
    [CSettingsController setBackgroundSync: [_swBackgroundSync isOn]];
}

- (IBAction)albumSyncOptionChanged:(id)sender {
    [CSettingsController setBackgroundSync: [_swAlbumSync isOn]];
}

- (IBAction)videoSyncOptionChanged:(id)sender {
    [CSettingsController setBackgroundSync: [_swVideoSync isOn]];
}
@end
