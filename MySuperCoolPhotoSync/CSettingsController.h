//
//  CSettingsController.h
//  MySuperCoolPhotoSync
//
//  Created by Vitaly Litvak on 25/12/12.
//  Copyright (c) 2012 litvak.su. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString const* KEY_SERVER_ADDRESS;
extern NSString const* KEY_BACKGROUND_SYNC;
extern NSString const* KEY_ALBUM_SYNC;
extern NSString const* KEY_VIDEO_SYNC;

@interface CSettingsController : UIViewController

    + (void) setServerAddress: (NSString*) serverAddress;
    + (NSString*) getServerAddress;

    + (void) setBackgroundSync: (BOOL) backgroundSync;
    + (BOOL) isBackgroundSync;

    + (void) setAlbumSync: (BOOL) albumSync;
    + (BOOL) isAlbumSync;

    + (void) setVideoSync: (BOOL) videoSync;
    + (BOOL) isVideoSync;


    @property (weak, nonatomic) IBOutlet UITextField *fldServerAddress;
    @property (weak, nonatomic) IBOutlet UISwitch *swBackgroundSync;
    @property (weak, nonatomic) IBOutlet UISwitch *swAlbumSync;
    @property (weak, nonatomic) IBOutlet UISwitch *swVideoSync;

    - (IBAction)serverAddressEntered:(id)sender;
    - (IBAction)backgroundSyncOptionChanged:(id)sender;
    - (IBAction)albumSyncOptionChanged:(id)sender;
    - (IBAction)videoSyncOptionChanged:(id)sender;
@end
